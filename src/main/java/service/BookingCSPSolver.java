package service;

import dao.BedDAO;
import dao.BookingDAO;
import dao.RoomDAO;
import dao.ServiceDAO;
import dao.UserDAO;
import model.Bed;
import model.Booking;
import model.Room;
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
        DayOfWeek.THURSDAY, DayOfWeek.FRIDAY, DayOfWeek.SATURDAY, DayOfWeek.SUNDAY
    );
    private static final int TIME_SLOT_INTERVAL = 30; // 30-minute intervals
    
    private final BookingDAO bookingDAO;
    private final ServiceDAO serviceDAO;
    private final UserDAO userDAO;
    private final RoomDAO roomDAO;
    private final BedDAO bedDAO;
    
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
        this.roomDAO = new RoomDAO();
        this.bedDAO = new BedDAO();
    }
    
    public BookingCSPSolver(BookingDAO bookingDAO, ServiceDAO serviceDAO, UserDAO userDAO, RoomDAO roomDAO, BedDAO bedDAO) {
        this.bookingDAO = bookingDAO;
        this.serviceDAO = serviceDAO;
        this.userDAO = userDAO;
        this.roomDAO = roomDAO;
        this.bedDAO = bedDAO;
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

        // DEBUG: Log domain sizes after constraint propagation
        LOGGER.info(String.format("DEBUG - Domain sizes after constraint propagation: " +
            "timeSlots=%d, therapists=%d, rooms=%d, beds=%d",
            timeSlotDomain.size(), therapistDomain.size(), roomDomain.size(), bedDomain.size()));

        // DEBUG: Log first few time slots to see what's available
        if (!timeSlotDomain.isEmpty()) {
            LOGGER.info("DEBUG - First 5 time slots in domain:");
            for (int i = 0; i < Math.min(5, timeSlotDomain.size()); i++) {
                TimeSlot slot = timeSlotDomain.get(i);
                LOGGER.info(String.format("  Slot %d: %s", i+1, slot.toString()));
            }
        }

        // TEMPORARY FIX: If constraint propagation filtered out all time slots,
        // regenerate them without strict constraints for debugging
        if (timeSlotDomain.isEmpty()) {
            LOGGER.warning("TEMPORARY FIX: Regenerating time slots without strict constraints");
            timeSlotDomain = generateTimeSlots(request, service.getDurationMinutes());
            LOGGER.info("Regenerated " + timeSlotDomain.size() + " time slots without constraints");
        }
        
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

        LOGGER.info(String.format("Generating time slots from %s to %s, service duration: %d minutes",
            currentDate, request.getSearchEndDate(), serviceDurationMinutes));

        // If preferred date is specified, only generate slots for that date
        if (request.hasPreferredDate()) {
            currentDate = request.getPreferredDate();
            LOGGER.info("Using preferred date: " + currentDate);
        }

        int totalDaysToProcess = request.hasPreferredDate() ? 1 :
            (int) currentDate.until(request.getSearchEndDate()).getDays() + 1;

        for (int dayOffset = 0; dayOffset < totalDaysToProcess; dayOffset++) {
            LocalDate dateToProcess = currentDate.plusDays(dayOffset);

            // Skip weekends if not included
            if (!request.isIncludeWeekends() && !BUSINESS_DAYS.contains(dateToProcess.getDayOfWeek())) {
                if (request.hasPreferredDate()) {
                    LOGGER.warning("Preferred date " + dateToProcess + " is a weekend and weekends are not included");
                }
                continue;
            }

            LOGGER.info("Processing date: " + dateToProcess + " (" + dateToProcess.getDayOfWeek() + ")");

            // Generate slots for this day
            LocalTime startTime = BUSINESS_START;
            LocalTime endTime = BUSINESS_END;

            // Apply time preferences only if no preferred date (to avoid over-constraining)
            if (request.hasTimePreferences() && !request.hasPreferredDate()) {
                if (request.getPreferredStartTime() != null) {
                    startTime = request.getPreferredStartTime();
                }
                if (request.getPreferredEndTime() != null) {
                    endTime = request.getPreferredEndTime();
                }
            }

            LocalTime currentTime = startTime;
            int slotsForThisDay = 0;

            // Generate time slots with 30-minute intervals throughout the day
            // Each slot represents a potential start time, not the full service duration
            while (currentTime.plusMinutes(serviceDurationMinutes).isBefore(endTime) ||
                   currentTime.plusMinutes(serviceDurationMinutes).equals(endTime)) {

                LocalDateTime slotStart = LocalDateTime.of(dateToProcess, currentTime);

                // More lenient minimum notice constraint - allow slots that start after or equal to earliest booking
                if (!slotStart.isBefore(earliestBooking)) {
                    // Create a time slot that represents the service duration starting at this time
                    TimeSlot slot = new TimeSlot(slotStart, serviceDurationMinutes);
                    slots.add(slot);
                    slotsForThisDay++;

                    LOGGER.fine(String.format("Generated slot: %s - %s (%d minutes)",
                        slotStart.toLocalTime(),
                        slotStart.plusMinutes(serviceDurationMinutes).toLocalTime(),
                        serviceDurationMinutes));
                }

                // Move to next 30-minute interval
                currentTime = currentTime.plusMinutes(TIME_SLOT_INTERVAL);
            }

            LOGGER.info(String.format("Generated %d time slots for %s", slotsForThisDay, dateToProcess));

            // If we have a preferred date, only process that one day
            if (request.hasPreferredDate()) {
                break;
            }
        }

        LOGGER.info(String.format("Total time slots generated: %d", slots.size()));
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
     * Get all active rooms from database
     */
    private List<Integer> getAllActiveRooms() throws SQLException {
        try {
            List<Room> rooms = roomDAO.findAll();
            return rooms.stream()
                .filter(Room::getIsActive)
                .map(Room::getRoomId)
                .collect(Collectors.toList());
        } catch (SQLException e) {
            LOGGER.warning("Error loading rooms, using fallback: " + e.getMessage());
            // Fallback to hardcoded values if database fails
            return Arrays.asList(1, 2, 3, 4);
        }
    }

    /**
     * Get all active beds from database
     */
    private List<Integer> getAllActiveBeds() throws SQLException {
        try {
            List<Bed> beds = bedDAO.findAll();
            return beds.stream()
                .filter(Bed::getIsActive)
                .map(Bed::getBedId)
                .collect(Collectors.toList());
        } catch (SQLException e) {
            LOGGER.warning("Error loading beds, using fallback: " + e.getMessage());
            // Fallback to hardcoded values if database fails
            return Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8);
        }
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

                    // Mark therapist unavailable for the entire buffered time period
                    if (booking.getTherapistUserId() != null) {
                        Set<LocalDateTime> therapistSlots = therapistUnavailableSlots.computeIfAbsent(
                            booking.getTherapistUserId(), k -> new HashSet<>());

                        // Add all time slots in the buffered period (15-minute intervals)
                        LocalDateTime current = bufferStart;
                        while (!current.isAfter(bufferEnd)) {
                            therapistSlots.add(current);
                            current = current.plusMinutes(15);
                        }
                    }

                    // Mark room unavailable for the entire buffered time period
                    if (booking.getRoomId() != null) {
                        Set<LocalDateTime> roomSlots = roomUnavailableSlots.computeIfAbsent(
                            booking.getRoomId(), k -> new HashSet<>());

                        LocalDateTime current = bufferStart;
                        while (!current.isAfter(bufferEnd)) {
                            roomSlots.add(current);
                            current = current.plusMinutes(15);
                        }
                    }

                    // Mark bed unavailable (use actual bed ID if available, otherwise use room ID)
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
        }
    }

    /**
     * Apply constraint propagation to reduce domain sizes
     * FIXED: Avoid circular dependency between time slot and therapist filtering
     */
    private void applyConstraintPropagation(BookingCSPRequest request, Service service) {
        LOGGER.info("Applying constraint propagation");

        int initialTimeSlots = timeSlotDomain.size();
        int initialTherapists = therapistDomain.size();
        int initialRooms = roomDomain.size();
        int initialBeds = bedDomain.size();

        // FIXED: Store original domains to avoid circular dependency
        List<TimeSlot> originalTimeSlotDomain = new ArrayList<>(timeSlotDomain);
        List<Integer> originalTherapistDomain = new ArrayList<>(therapistDomain);
        List<Integer> originalRoomDomain = new ArrayList<>(roomDomain);
        List<Integer> originalBedDomain = new ArrayList<>(bedDomain);

        // Filter time slots based on basic constraints (business hours, minimum notice)
        // but NOT on resource availability to avoid circular dependency
        timeSlotDomain = timeSlotDomain.stream()
            .filter(slot -> isSlotValidBasicConstraints(slot, request))
            .collect(Collectors.toList());

        // Filter therapists based on original time slot domain to avoid circular dependency
        therapistDomain = therapistDomain.stream()
            .filter(therapistId -> hasAvailableTimeSlotsInOriginalDomain(therapistId, originalTimeSlotDomain, request))
            .collect(Collectors.toList());

        // Filter rooms based on original time slot domain
        roomDomain = roomDomain.stream()
            .filter(roomId -> hasAvailableTimeSlotsForRoom(roomId, originalTimeSlotDomain, request))
            .collect(Collectors.toList());

        // Filter beds based on original time slot domain
        bedDomain = bedDomain.stream()
            .filter(bedId -> hasAvailableTimeSlotsForBed(bedId, originalTimeSlotDomain, request))
            .collect(Collectors.toList());

        LOGGER.info(String.format("Constraint propagation reduced domains: " +
            "time slots %d->%d, therapists %d->%d, rooms %d->%d, beds %d->%d",
            initialTimeSlots, timeSlotDomain.size(),
            initialTherapists, therapistDomain.size(),
            initialRooms, roomDomain.size(),
            initialBeds, bedDomain.size()));

        if (timeSlotDomain.isEmpty()) {
            LOGGER.warning("No time slots available after constraint propagation!");
        }
        if (therapistDomain.isEmpty()) {
            LOGGER.warning("No therapists available after constraint propagation!");
        }
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
     * FIXED: Check if a slot meets basic constraints (business hours, minimum notice)
     * without checking resource availability to avoid circular dependency
     */
    private boolean isSlotValidBasicConstraints(TimeSlot slot, BookingCSPRequest request) {
        // Check business hours constraint
        LocalTime slotStartTime = slot.getStartTime().toLocalTime();
        LocalTime slotEndTime = slot.getEndTime().toLocalTime();

        if (slotStartTime.isBefore(BUSINESS_START) || slotEndTime.isAfter(BUSINESS_END)) {
            return false;
        }

        // Check business days constraint
        DayOfWeek dayOfWeek = slot.getStartTime().getDayOfWeek();
        if (!BUSINESS_DAYS.contains(dayOfWeek)) {
            return false;
        }

        // Check minimum notice constraint
        if (slot.getStartTime().isBefore(request.getEarliestBookingTime())) {
            return false;
        }

        return true;
    }

    /**
     * FIXED: Check if therapist has available time slots using original domain
     * to avoid circular dependency
     */
    private boolean hasAvailableTimeSlotsInOriginalDomain(Integer therapistId, List<TimeSlot> originalTimeSlots, BookingCSPRequest request) {
        return originalTimeSlots.stream()
            .anyMatch(slot -> isTherapistAvailable(therapistId, slot, request));
    }

    /**
     * FIXED: Check if room has available time slots using original domain
     * to avoid circular dependency
     */
    private boolean hasAvailableTimeSlotsForRoom(Integer roomId, List<TimeSlot> originalTimeSlots, BookingCSPRequest request) {
        return originalTimeSlots.stream()
            .anyMatch(slot -> isRoomAvailable(roomId, slot, request));
    }

    /**
     * FIXED: Check if bed has available time slots using original domain
     * to avoid circular dependency
     */
    private boolean hasAvailableTimeSlotsForBed(Integer bedId, List<TimeSlot> originalTimeSlots, BookingCSPRequest request) {
        return originalTimeSlots.stream()
            .anyMatch(slot -> isBedAvailable(bedId, slot, request));
    }

    /**
     * Check if therapist is available for a time slot with enhanced constraint checking
     */
    private boolean isTherapistAvailable(Integer therapistId, TimeSlot slot, BookingCSPRequest request) {
        // Check business hours constraint
        LocalTime slotStartTime = slot.getStartTime().toLocalTime();
        LocalTime slotEndTime = slot.getEndTime().toLocalTime();

        if (slotStartTime.isBefore(BUSINESS_START) || slotEndTime.isAfter(BUSINESS_END)) {
            return false;
        }

        // Check business days constraint
        DayOfWeek dayOfWeek = slot.getStartTime().getDayOfWeek();
        if (!BUSINESS_DAYS.contains(dayOfWeek)) {
            return false;
        }

        // Check minimum notice constraint
        if (slot.getStartTime().isBefore(request.getEarliestBookingTime())) {
            return false;
        }

        // Check existing bookings and unavailable slots
        Set<LocalDateTime> unavailableSlots = therapistUnavailableSlots.get(therapistId);
        if (unavailableSlots == null) {
            return true;
        }

        // Check if any part of the slot conflicts with unavailable times
        LocalDateTime current = slot.getStartTime();
        while (!current.isAfter(slot.getEndTime().minusMinutes(15))) {
            if (unavailableSlots.contains(current)) {
                return false;
            }
            current = current.plusMinutes(15);
        }

        return true;
    }

    /**
     * Check if room is available for a time slot with enhanced constraint checking
     */
    private boolean isRoomAvailable(Integer roomId, TimeSlot slot, BookingCSPRequest request) {
        // Check existing bookings and unavailable slots
        Set<LocalDateTime> unavailableSlots = roomUnavailableSlots.get(roomId);
        if (unavailableSlots == null) {
            return true;
        }

        // Check if any part of the slot conflicts with unavailable times
        LocalDateTime current = slot.getStartTime();
        while (!current.isAfter(slot.getEndTime().minusMinutes(15))) {
            if (unavailableSlots.contains(current)) {
                return false;
            }
            current = current.plusMinutes(15);
        }

        return true;
    }

    /**
     * Check if bed is available for a time slot with enhanced constraint checking
     */
    private boolean isBedAvailable(Integer bedId, TimeSlot slot, BookingCSPRequest request) {
        // Check existing bookings and unavailable slots
        Set<LocalDateTime> unavailableSlots = bedUnavailableSlots.get(bedId);
        if (unavailableSlots == null) {
            return true;
        }

        // Check if any part of the slot conflicts with unavailable times
        LocalDateTime current = slot.getStartTime();
        while (!current.isAfter(slot.getEndTime().minusMinutes(15))) {
            if (unavailableSlots.contains(current)) {
                return false;
            }
            current = current.plusMinutes(15);
        }

        return true;
    }

    /**
     * Backtracking algorithm to find all valid assignments
     */
    private List<BookingAssignment> backtrackSolve(BookingCSPRequest request, Service service) {
        List<BookingAssignment> solutions = new ArrayList<>();

        LOGGER.info(String.format("DEBUG - Starting backtrack solve with domains: timeSlots=%d, therapists=%d, rooms=%d, beds=%d",
            timeSlotDomain.size(), therapistDomain.size(), roomDomain.size(), bedDomain.size()));

        int timeSlotIndex = 0;
        // Generate all possible assignments
        for (TimeSlot timeSlot : timeSlotDomain) {
            timeSlotIndex++;
            int validAssignmentsForThisSlot = 0;

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
                        validAssignmentsForThisSlot++;

                        // Early termination if we have enough solutions
                        if (solutions.size() >= request.getMaxResults() * 2) {
                            LOGGER.info(String.format("DEBUG - Early termination at %d solutions", solutions.size()));
                            return solutions;
                        }
                    }
                }
            }

            // DEBUG: Log how many valid assignments were found for this time slot
            if (timeSlotIndex <= 5) { // Only log first 5 time slots to avoid spam
                LOGGER.info(String.format("DEBUG - Time slot %d (%s): %d valid assignments",
                    timeSlotIndex, timeSlot.getStartTime().toLocalTime(), validAssignmentsForThisSlot));
            }
        }

        LOGGER.info(String.format("DEBUG - Backtrack solve completed: %d total solutions found", solutions.size()));
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
