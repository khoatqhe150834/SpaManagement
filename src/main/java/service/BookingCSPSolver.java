package service;

import dao.BookingDAO;
import dao.ServiceDAO;
import dao.UserDAO;
import model.Booking;
import model.Service;
import model.User;
import model.csp.BookingAssignment;
import model.csp.BookingCSPRequest;
import model.csp.TimeSlot;

import java.sql.SQLException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

/**
 * Constraint Satisfaction Problem solver for spa booking system
 * Uses backtracking with constraint propagation to find available booking slots
 * 
 * @author SpaManagement
 */
public class BookingCSPSolver {
    
    private static final Logger LOGGER = Logger.getLogger(BookingCSPSolver.class.getName());
    
    // Business constraints
    private static final LocalTime BUSINESS_START = LocalTime.of(8, 0);
    private static final LocalTime BUSINESS_END = LocalTime.of(20, 0);
    private static final List<DayOfWeek> BUSINESS_DAYS = Arrays.asList(
        DayOfWeek.MONDAY, DayOfWeek.TUESDAY, DayOfWeek.WEDNESDAY,
        DayOfWeek.THURSDAY, DayOfWeek.FRIDAY, DayOfWeek.SATURDAY
    );
    private static final int TIME_SLOT_INTERVAL = 30; // 30-minute intervals
    
    private final BookingDAO bookingDAO;
    private final ServiceDAO serviceDAO;
    private final UserDAO userDAO;
    
    // CSP domains
    private List<TimeSlot> timeSlotDomain;
    private List<Integer> therapistDomain;
    private List<Integer> roomDomain;
    private List<Integer> bedDomain;
    
    // Constraint data
    private Map<LocalDate, List<Booking>> existingBookingsByDate;
    private Map<Integer, Set<LocalDateTime>> therapistUnavailableSlots;
    private Map<Integer, Set<LocalDateTime>> roomUnavailableSlots;
    private Map<Integer, Set<LocalDateTime>> bedUnavailableSlots;
    
    public BookingCSPSolver() {
        this.bookingDAO = new BookingDAO();
        this.serviceDAO = new ServiceDAO();
        this.userDAO = new UserDAO();
    }
    
    public BookingCSPSolver(BookingDAO bookingDAO, ServiceDAO serviceDAO, UserDAO userDAO) {
        this.bookingDAO = bookingDAO;
        this.serviceDAO = serviceDAO;
        this.userDAO = userDAO;
    }
    
    /**
     * Solve CSP to find all available booking assignments
     */
    public List<BookingAssignment> findAvailableSlots(BookingCSPRequest request) throws SQLException {
        LOGGER.info("Starting CSP solver for request: " + request);
        
        long startTime = System.currentTimeMillis();
        
        // Validate request
        if (!isValidRequest(request)) {
            LOGGER.warning("Invalid CSP request: " + request);
            return new ArrayList<>();
        }
        
        // Get service details
        Optional<Service> serviceOpt = serviceDAO.findById(request.getServiceId());
        if (!serviceOpt.isPresent()) {
            LOGGER.warning("Service not found: " + request.getServiceId());
            return new ArrayList<>();
        }
        Service service = serviceOpt.get();
        
        // Initialize CSP domains
        initializeDomains(request, service);
        
        // Load constraint data
        loadConstraintData(request);
        
        // Apply constraint propagation
        applyConstraintPropagation(request, service);
        
        // Solve using backtracking
        List<BookingAssignment> solutions = backtrackSolve(request, service);
        
        // Sort solutions by preference
        solutions = sortSolutionsByPreference(solutions, request);
        
        // Limit results
        if (solutions.size() > request.getMaxResults()) {
            solutions = solutions.subList(0, request.getMaxResults());
        }
        
        long endTime = System.currentTimeMillis();
        LOGGER.info(String.format("CSP solver completed in %d ms. Found %d solutions.", 
            endTime - startTime, solutions.size()));
        
        return solutions;
    }
    
    /**
     * Initialize CSP variable domains
     */
    private void initializeDomains(BookingCSPRequest request, Service service) throws SQLException {
        LOGGER.info("Initializing CSP domains");
        
        // Initialize time slot domain
        timeSlotDomain = generateTimeSlots(request, service.getDurationMinutes());
        
        // Initialize therapist domain
        therapistDomain = getQualifiedTherapists(request, service);
        
        // Initialize room domain (simplified - all active rooms)
        roomDomain = getAllActiveRooms();
        
        // Initialize bed domain (simplified - all active beds)
        bedDomain = getAllActiveBeds();
        
        LOGGER.info(String.format("Domains initialized: %d time slots, %d therapists, %d rooms, %d beds",
            timeSlotDomain.size(), therapistDomain.size(), roomDomain.size(), bedDomain.size()));
    }
    
    /**
     * Generate all possible time slots within the search range
     */
    private List<TimeSlot> generateTimeSlots(BookingCSPRequest request, int serviceDurationMinutes) {
        List<TimeSlot> slots = new ArrayList<>();
        
        LocalDate currentDate = request.getSearchStartDate();
        LocalDateTime earliestBooking = request.getEarliestBookingTime();
        
        while (!currentDate.isAfter(request.getSearchEndDate())) {
            // Skip weekends if not included
            if (!request.isIncludeWeekends() && !BUSINESS_DAYS.contains(currentDate.getDayOfWeek())) {
                currentDate = currentDate.plusDays(1);
                continue;
            }
            
            // Generate slots for this day
            LocalTime startTime = BUSINESS_START;
            LocalTime endTime = BUSINESS_END;
            
            // Apply time preferences
            if (request.hasTimePreferences()) {
                if (request.getPreferredStartTime() != null) {
                    startTime = request.getPreferredStartTime();
                }
                if (request.getPreferredEndTime() != null) {
                    endTime = request.getPreferredEndTime();
                }
            }
            
            LocalTime currentTime = startTime;
            while (currentTime.plusMinutes(serviceDurationMinutes).isBefore(endTime) ||
                   currentTime.plusMinutes(serviceDurationMinutes).equals(endTime)) {
                
                LocalDateTime slotStart = LocalDateTime.of(currentDate, currentTime);
                
                // Check minimum notice constraint
                if (slotStart.isAfter(earliestBooking)) {
                    TimeSlot slot = new TimeSlot(slotStart, serviceDurationMinutes);
                    slots.add(slot);
                }
                
                currentTime = currentTime.plusMinutes(TIME_SLOT_INTERVAL);
            }
            
            currentDate = currentDate.plusDays(1);
        }
        
        return slots;
    }
    
    /**
     * Get qualified therapists for the service
     */
    private List<Integer> getQualifiedTherapists(BookingCSPRequest request, Service service) throws SQLException {
        List<Integer> qualifiedTherapists = new ArrayList<>();
        
        if (request.hasPreferredTherapist()) {
            // Check if preferred therapist is qualified
            Optional<User> therapistOpt = userDAO.findById(request.getPreferredTherapistId());
            if (therapistOpt.isPresent() && therapistOpt.get().getRoleId() == 3) { // Role 3 = THERAPIST
                qualifiedTherapists.add(request.getPreferredTherapistId());
            }
        } else {
            // Get all therapists (simplified - in real implementation, check qualifications)
            List<User> therapists = userDAO.findByRoleId(3, 1, 100);
            qualifiedTherapists = therapists.stream()
                .map(User::getUserId)
                .collect(Collectors.toList());
        }
        
        return qualifiedTherapists;
    }
    
    /**
     * Get all active rooms (simplified implementation)
     */
    private List<Integer> getAllActiveRooms() {
        // In real implementation, query rooms table
        return Arrays.asList(1, 2, 3, 4); // Simplified
    }
    
    /**
     * Get all active beds (simplified implementation)
     */
    private List<Integer> getAllActiveBeds() {
        // In real implementation, query beds table
        return Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8); // Simplified
    }

    /**
     * Load constraint data from database
     */
    private void loadConstraintData(BookingCSPRequest request) throws SQLException {
        LOGGER.info("Loading constraint data");

        // Load existing bookings by date
        existingBookingsByDate = new HashMap<>();
        LocalDate currentDate = request.getSearchStartDate();

        while (!currentDate.isAfter(request.getSearchEndDate())) {
            List<Booking> dayBookings = bookingDAO.findByDate(currentDate);
            existingBookingsByDate.put(currentDate, dayBookings);
            currentDate = currentDate.plusDays(1);
        }

        // Initialize unavailable slot maps
        therapistUnavailableSlots = new HashMap<>();
        roomUnavailableSlots = new HashMap<>();
        bedUnavailableSlots = new HashMap<>();

        // Populate unavailable slots from existing bookings
        for (List<Booking> dayBookings : existingBookingsByDate.values()) {
            for (Booking booking : dayBookings) {
                if (booking.getBookingStatus() == Booking.BookingStatus.CONFIRMED ||
                    booking.getBookingStatus() == Booking.BookingStatus.IN_PROGRESS) {

                    LocalDateTime bookingStart = LocalDateTime.of(
                        booking.getAppointmentDate().toLocalDate(),
                        booking.getAppointmentTime().toLocalTime()
                    );
                    LocalDateTime bookingEnd = bookingStart.plusMinutes(booking.getDurationMinutes());

                    // Add buffer time
                    LocalDateTime bufferStart = bookingStart.minusMinutes(request.getBufferTimeMinutes());
                    LocalDateTime bufferEnd = bookingEnd.plusMinutes(request.getBufferTimeMinutes());

                    // Mark therapist unavailable
                    if (booking.getTherapistUserId() != null) {
                        therapistUnavailableSlots.computeIfAbsent(booking.getTherapistUserId(), k -> new HashSet<>())
                            .add(bufferStart);
                    }

                    // Mark room unavailable
                    if (booking.getRoomId() != null) {
                        roomUnavailableSlots.computeIfAbsent(booking.getRoomId(), k -> new HashSet<>())
                            .add(bufferStart);
                    }

                    // Mark bed unavailable (if bed info available)
                    // In simplified implementation, assume bed ID is room ID
                    if (booking.getRoomId() != null) {
                        bedUnavailableSlots.computeIfAbsent(booking.getRoomId(), k -> new HashSet<>())
                            .add(bufferStart);
                    }
                }
            }
        }
    }

    /**
     * Apply constraint propagation to reduce domain sizes
     */
    private void applyConstraintPropagation(BookingCSPRequest request, Service service) {
        LOGGER.info("Applying constraint propagation");

        int initialTimeSlots = timeSlotDomain.size();
        int initialTherapists = therapistDomain.size();
        int initialRooms = roomDomain.size();
        int initialBeds = bedDomain.size();

        // Remove time slots that have no available resources
        timeSlotDomain = timeSlotDomain.stream()
            .filter(slot -> hasAvailableResources(slot, request))
            .collect(Collectors.toList());

        // Remove therapists that have no available time slots
        therapistDomain = therapistDomain.stream()
            .filter(therapistId -> hasAvailableTimeSlots(therapistId, request))
            .collect(Collectors.toList());

        LOGGER.info(String.format("Constraint propagation reduced domains: " +
            "time slots %d->%d, therapists %d->%d, rooms %d->%d, beds %d->%d",
            initialTimeSlots, timeSlotDomain.size(),
            initialTherapists, therapistDomain.size(),
            initialRooms, roomDomain.size(),
            initialBeds, bedDomain.size()));
    }

    /**
     * Check if a time slot has available resources
     */
    private boolean hasAvailableResources(TimeSlot slot, BookingCSPRequest request) {
        // Check if any therapist is available
        boolean hasAvailableTherapist = therapistDomain.stream()
            .anyMatch(therapistId -> isTherapistAvailable(therapistId, slot, request));

        // Check if any room is available
        boolean hasAvailableRoom = roomDomain.stream()
            .anyMatch(roomId -> isRoomAvailable(roomId, slot, request));

        // Check if any bed is available
        boolean hasAvailableBed = bedDomain.stream()
            .anyMatch(bedId -> isBedAvailable(bedId, slot, request));

        return hasAvailableTherapist && hasAvailableRoom && hasAvailableBed;
    }

    /**
     * Check if a therapist has any available time slots
     */
    private boolean hasAvailableTimeSlots(Integer therapistId, BookingCSPRequest request) {
        return timeSlotDomain.stream()
            .anyMatch(slot -> isTherapistAvailable(therapistId, slot, request));
    }

    /**
     * Check if therapist is available for a time slot
     */
    private boolean isTherapistAvailable(Integer therapistId, TimeSlot slot, BookingCSPRequest request) {
        Set<LocalDateTime> unavailableSlots = therapistUnavailableSlots.get(therapistId);
        if (unavailableSlots == null) {
            return true;
        }

        // Check if slot conflicts with any unavailable time
        return unavailableSlots.stream()
            .noneMatch(unavailableTime -> slot.contains(unavailableTime) ||
                      slot.getStartTime().equals(unavailableTime));
    }

    /**
     * Check if room is available for a time slot
     */
    private boolean isRoomAvailable(Integer roomId, TimeSlot slot, BookingCSPRequest request) {
        Set<LocalDateTime> unavailableSlots = roomUnavailableSlots.get(roomId);
        if (unavailableSlots == null) {
            return true;
        }

        return unavailableSlots.stream()
            .noneMatch(unavailableTime -> slot.contains(unavailableTime) ||
                      slot.getStartTime().equals(unavailableTime));
    }

    /**
     * Check if bed is available for a time slot
     */
    private boolean isBedAvailable(Integer bedId, TimeSlot slot, BookingCSPRequest request) {
        Set<LocalDateTime> unavailableSlots = bedUnavailableSlots.get(bedId);
        if (unavailableSlots == null) {
            return true;
        }

        return unavailableSlots.stream()
            .noneMatch(unavailableTime -> slot.contains(unavailableTime) ||
                      slot.getStartTime().equals(unavailableTime));
    }

    /**
     * Backtracking algorithm to find all valid assignments
     */
    private List<BookingAssignment> backtrackSolve(BookingCSPRequest request, Service service) {
        List<BookingAssignment> solutions = new ArrayList<>();

        // Generate all possible assignments
        for (TimeSlot timeSlot : timeSlotDomain) {
            for (Integer therapistId : therapistDomain) {
                if (!isTherapistAvailable(therapistId, timeSlot, request)) {
                    continue;
                }

                for (Integer roomId : roomDomain) {
                    if (!isRoomAvailable(roomId, timeSlot, request)) {
                        continue;
                    }

                    for (Integer bedId : bedDomain) {
                        if (!isBedAvailable(bedId, timeSlot, request)) {
                            continue;
                        }

                        // Create valid assignment
                        BookingAssignment assignment = new BookingAssignment(timeSlot, therapistId, roomId, bedId);

                        // Set confidence level based on available alternatives
                        assignment.setConfidenceLevel(calculateConfidenceLevel(timeSlot, request));

                        solutions.add(assignment);

                        // Early termination if we have enough solutions
                        if (solutions.size() >= request.getMaxResults() * 2) {
                            return solutions;
                        }
                    }
                }
            }
        }

        return solutions;
    }

    /**
     * Calculate confidence level based on resource availability
     */
    private BookingAssignment.ConfidenceLevel calculateConfidenceLevel(TimeSlot timeSlot, BookingCSPRequest request) {
        int availableTherapists = (int) therapistDomain.stream()
            .filter(therapistId -> isTherapistAvailable(therapistId, timeSlot, request))
            .count();

        int availableRooms = (int) roomDomain.stream()
            .filter(roomId -> isRoomAvailable(roomId, timeSlot, request))
            .count();

        int availableBeds = (int) bedDomain.stream()
            .filter(bedId -> isBedAvailable(bedId, timeSlot, request))
            .count();

        int minAvailable = Math.min(Math.min(availableTherapists, availableRooms), availableBeds);

        if (minAvailable >= 3) {
            return BookingAssignment.ConfidenceLevel.HIGH;
        } else if (minAvailable >= 2) {
            return BookingAssignment.ConfidenceLevel.MEDIUM;
        } else {
            return BookingAssignment.ConfidenceLevel.LOW;
        }
    }

    /**
     * Sort solutions by preference (preferred therapist, date, time)
     */
    private List<BookingAssignment> sortSolutionsByPreference(List<BookingAssignment> solutions,
                                                             BookingCSPRequest request) {
        return solutions.stream()
            .sorted((a, b) -> {
                // Preferred therapist first
                if (request.hasPreferredTherapist()) {
                    boolean aHasPreferred = a.getTherapistId().equals(request.getPreferredTherapistId());
                    boolean bHasPreferred = b.getTherapistId().equals(request.getPreferredTherapistId());
                    if (aHasPreferred && !bHasPreferred) return -1;
                    if (!aHasPreferred && bHasPreferred) return 1;
                }

                // Preferred date second
                if (request.hasPreferredDate()) {
                    LocalDate aDate = a.getTimeSlot().getStartTime().toLocalDate();
                    LocalDate bDate = b.getTimeSlot().getStartTime().toLocalDate();
                    boolean aHasPreferredDate = aDate.equals(request.getPreferredDate());
                    boolean bHasPreferredDate = bDate.equals(request.getPreferredDate());
                    if (aHasPreferredDate && !bHasPreferredDate) return -1;
                    if (!aHasPreferredDate && bHasPreferredDate) return 1;
                }

                // Earlier dates first
                int dateComparison = a.getTimeSlot().getStartTime().toLocalDate()
                    .compareTo(b.getTimeSlot().getStartTime().toLocalDate());
                if (dateComparison != 0) return dateComparison;

                // Earlier times first
                return a.getTimeSlot().getStartTime().toLocalTime()
                    .compareTo(b.getTimeSlot().getStartTime().toLocalTime());
            })
            .collect(Collectors.toList());
    }

    /**
     * Validate CSP request
     */
    private boolean isValidRequest(BookingCSPRequest request) {
        return request != null &&
               request.getCustomerId() != null &&
               request.getServiceId() != null &&
               request.getSearchStartDate() != null &&
               request.getSearchEndDate() != null &&
               !request.getSearchStartDate().isAfter(request.getSearchEndDate());
    }
}
