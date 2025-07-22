package service;

import dao.BookingDAO;
import dao.ServiceDAO;
import dao.UserDAO;
import dao.RoomDAO;
import dao.BedDAO;
import model.Booking;
import model.Service;
import model.User;
import model.Room;
import model.Bed;
import model.csp.BookingCSPRequest;
import model.csp.TimeSlot;
import model.csp.CSPDomain;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.DayOfWeek;
import java.util.*;
import java.util.stream.Collectors;
import java.util.logging.Logger;

/**
 * Real-time availability service for spa booking system
 * Provides calendar display with CSP-based slot validation
 */
public class RealTimeAvailabilityService {
    
    private static final Logger LOGGER = Logger.getLogger(RealTimeAvailabilityService.class.getName());
    
    // Business constraints
    private static final LocalTime BUSINESS_START = LocalTime.of(8, 0);
    private static final LocalTime BUSINESS_END = LocalTime.of(20, 0);
    private static final int TIME_SLOT_INTERVAL = 30; // 30-minute intervals
    private static final List<DayOfWeek> BUSINESS_DAYS = Arrays.asList(
        DayOfWeek.MONDAY, DayOfWeek.TUESDAY, DayOfWeek.WEDNESDAY,
        DayOfWeek.THURSDAY, DayOfWeek.FRIDAY, DayOfWeek.SATURDAY, DayOfWeek.SUNDAY
    );
    
    private final BookingDAO bookingDAO;
    private final ServiceDAO serviceDAO;
    private final UserDAO userDAO;
    private final RoomDAO roomDAO;
    private final BedDAO bedDAO;
    
    public RealTimeAvailabilityService() {
        this.bookingDAO = new BookingDAO();
        this.serviceDAO = new ServiceDAO();
        this.userDAO = new UserDAO();
        this.roomDAO = new RoomDAO();
        this.bedDAO = new BedDAO();
    }
    
    /**
     * Get all available time slots for a specific date with availability status
     * Returns slots from 8:00 AM to 8:00 PM with 30-minute intervals
     */
    public List<AvailabilitySlot> getAvailabilityForDate(LocalDate date, int serviceId, int customerId) 
            throws SQLException {
        
        LOGGER.info(String.format("Getting availability for date: %s, service: %d, customer: %d", 
            date, serviceId, customerId));
        
        // Get service details
        Optional<Service> serviceOpt = serviceDAO.findById(serviceId);
        if (!serviceOpt.isPresent()) {
            throw new IllegalArgumentException("Service not found: " + serviceId);
        }
        Service service = serviceOpt.get();
        
        int serviceDurationMinutes = service.getDurationMinutes();
        
        // Create CSP request
        BookingCSPRequest request = new BookingCSPRequest();
        request.setCustomerId(customerId);
        request.setServiceId(serviceId);
        request.setPreferredDate(date);
        request.setSearchStartDate(date);
        request.setSearchEndDate(date);
        
        // Generate all possible time slots for the day
        List<TimeSlot> allTimeSlots = generateTimeSlotsForDate(date, serviceDurationMinutes);
        
        // Load constraint data
        CSPDomain cspDomain = loadConstraintData(request, service);
        
        // Initialize domains
        List<Integer> therapists = getQualifiedTherapists(serviceId);
        List<Integer> rooms = getSuitableRooms(serviceId);
        List<Integer> beds = getAvailableBeds();
        Map<String, Object> serviceData = Map.of("service", service);
        
        cspDomain.initializeDomains(allTimeSlots, therapists, rooms, beds, serviceData);
        
        // Apply constraint propagation
        cspDomain.applyConstraintPropagation(request);
        
        // Create availability slots with status
        List<AvailabilitySlot> availabilitySlots = new ArrayList<>();
        
        for (TimeSlot slot : allTimeSlots) {
            boolean isAvailable = cspDomain.isSlotAvailable(slot, request);
            
            AvailabilitySlot availabilitySlot = new AvailabilitySlot(
                slot.getStartTime(),
                slot.getEndTime(),
                isAvailable,
                isAvailable ? getAvailableResources(slot, cspDomain) : new ArrayList<>()
            );
            
            availabilitySlots.add(availabilitySlot);
        }
        
        LOGGER.info(String.format("Generated %d availability slots for %s", availabilitySlots.size(), date));
        
        return availabilitySlots;
    }
    
    /**
     * Generate all 30-minute time slots for a specific date
     */
    private List<TimeSlot> generateTimeSlotsForDate(LocalDate date, int serviceDurationMinutes) {
        List<TimeSlot> slots = new ArrayList<>();
        
        // Check if date is a business day
        if (!BUSINESS_DAYS.contains(date.getDayOfWeek())) {
            LOGGER.info("Date " + date + " is not a business day");
            return slots;
        }
        
        LocalTime currentTime = BUSINESS_START;
        
        // Generate 30-minute intervals throughout the business day
        while (currentTime.plusMinutes(serviceDurationMinutes).isBefore(BUSINESS_END) ||
               currentTime.plusMinutes(serviceDurationMinutes).equals(BUSINESS_END)) {
            
            LocalDateTime slotStart = LocalDateTime.of(date, currentTime);
            TimeSlot slot = new TimeSlot(slotStart, serviceDurationMinutes);
            slots.add(slot);
            
            // Move to next 30-minute interval
            currentTime = currentTime.plusMinutes(TIME_SLOT_INTERVAL);
        }
        
        LOGGER.info(String.format("Generated %d time slots for %s (service duration: %d minutes)", 
            slots.size(), date, serviceDurationMinutes));
        
        return slots;
    }
    
    /**
     * Load constraint data from database
     */
    private CSPDomain loadConstraintData(BookingCSPRequest request, Service service) throws SQLException {
        CSPDomain domain = new CSPDomain();
        
        // Load existing bookings for the date range
        List<Booking> existingBookings = bookingDAO.findByDate(request.getSearchStartDate());

        // Process bookings to create unavailable slots
        Map<Integer, Set<LocalDateTime>> therapistUnavailableSlots = new HashMap<>();
        Map<Integer, Set<LocalDateTime>> roomUnavailableSlots = new HashMap<>();
        Map<Integer, Set<LocalDateTime>> bedUnavailableSlots = new HashMap<>();

        for (Booking booking : existingBookings) {
            if (booking.getAppointmentDate() != null && booking.getAppointmentTime() != null) {
                LocalDateTime bookingStart = LocalDateTime.of(
                    booking.getAppointmentDate().toLocalDate(),
                    booking.getAppointmentTime().toLocalTime()
                );
                LocalDateTime bookingEnd = bookingStart.plusMinutes(booking.getDurationMinutes());
                
                // Add buffer time
                LocalDateTime bufferStart = bookingStart.minusMinutes(15);
                LocalDateTime bufferEnd = bookingEnd.plusMinutes(15);
                
                // Mark therapist unavailable
                if (booking.getTherapistUserId() != null) {
                    Set<LocalDateTime> therapistSlots = therapistUnavailableSlots.computeIfAbsent(
                        booking.getTherapistUserId(), k -> new HashSet<>());
                    
                    LocalDateTime current = bufferStart;
                    while (!current.isAfter(bufferEnd)) {
                        therapistSlots.add(current);
                        current = current.plusMinutes(15);
                    }
                }
                
                // Mark room unavailable
                if (booking.getRoomId() != null) {
                    Set<LocalDateTime> roomSlots = roomUnavailableSlots.computeIfAbsent(
                        booking.getRoomId(), k -> new HashSet<>());
                    
                    LocalDateTime current = bufferStart;
                    while (!current.isAfter(bufferEnd)) {
                        roomSlots.add(current);
                        current = current.plusMinutes(15);
                    }
                }
                
                // Mark bed unavailable
                Integer bedId = booking.getBedId() != null ? booking.getBedId() : booking.getRoomId();
                if (bedId != null) {
                    Set<LocalDateTime> bedSlots = bedUnavailableSlots.computeIfAbsent(
                        bedId, k -> new HashSet<>());
                    
                    LocalDateTime current = bufferStart;
                    while (!current.isAfter(bufferEnd)) {
                        bedSlots.add(current);
                        current = current.plusMinutes(15);
                    }
                }
            }
        }
        
        domain.setTherapistUnavailableSlots(therapistUnavailableSlots);
        domain.setRoomUnavailableSlots(roomUnavailableSlots);
        domain.setBedUnavailableSlots(bedUnavailableSlots);
        
        return domain;
    }
    
    /**
     * Get therapists qualified for a service
     */
    private List<Integer> getQualifiedTherapists(int serviceId) throws SQLException {
        // For now, get all active therapists
        // TODO: Implement service-specific qualifications
        List<User> therapists = userDAO.findByRoleId(3, 1, 100); // Role 3 = Therapist
        return therapists.stream()
            .filter(User::getIsActive)
            .map(User::getUserId)
            .collect(Collectors.toList());
    }
    
    /**
     * Get rooms suitable for a service
     */
    private List<Integer> getSuitableRooms(int serviceId) throws SQLException {
        // For now, get all active rooms
        // TODO: Implement service-specific room requirements
        List<Room> rooms = roomDAO.findAll();
        return rooms.stream()
            .filter(Room::getIsActive)
            .map(Room::getRoomId)
            .collect(Collectors.toList());
    }
    
    /**
     * Get all available beds
     */
    private List<Integer> getAvailableBeds() throws SQLException {
        List<Bed> beds = bedDAO.findAll();
        return beds.stream()
            .filter(Bed::getIsActive)
            .map(Bed::getBedId)
            .collect(Collectors.toList());
    }
    
    /**
     * Get available resources for a time slot
     */
    private List<Map<String, Object>> getAvailableResources(TimeSlot slot, CSPDomain domain) {
        List<Map<String, Object>> resources = new ArrayList<>();
        
        // Get available therapists, rooms, and beds for this slot
        for (Integer therapistId : domain.getTherapistDomain()) {
            for (Integer roomId : domain.getRoomDomain()) {
                for (Integer bedId : domain.getBedDomain()) {
                    Map<String, Object> resource = new HashMap<>();
                    resource.put("therapistId", therapistId);
                    resource.put("roomId", roomId);
                    resource.put("bedId", bedId);
                    resources.add(resource);
                }
            }
        }
        
        return resources;
    }
    
    /**
     * Availability slot data structure
     */
    public static class AvailabilitySlot {
        private final LocalDateTime startTime;
        private final LocalDateTime endTime;
        private final boolean available;
        private final List<Map<String, Object>> availableResources;
        
        public AvailabilitySlot(LocalDateTime startTime, LocalDateTime endTime, 
                               boolean available, List<Map<String, Object>> availableResources) {
            this.startTime = startTime;
            this.endTime = endTime;
            this.available = available;
            this.availableResources = availableResources;
        }
        
        // Getters
        public LocalDateTime getStartTime() { return startTime; }
        public LocalDateTime getEndTime() { return endTime; }
        public boolean isAvailable() { return available; }
        public List<Map<String, Object>> getAvailableResources() { return availableResources; }
    }
}
