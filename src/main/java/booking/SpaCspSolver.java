/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package booking;

/**
 *
 * @author quang
 */
// src/main/java/csp/SpaCspSolver.java

import dao.SchedulingConstraintDAO;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;


public class SpaCspSolver {
    private static final Logger LOGGER = Logger.getLogger(SpaCspSolver.class.getName());
    
    // Business hours constants
    private static final LocalTime BUSINESS_OPEN_TIME = LocalTime.of(8, 0);  // 8 AM
    private static final LocalTime BUSINESS_CLOSE_TIME = LocalTime.of(20, 0); // 8 PM
    private static final int TIME_SLOT_INTERVAL_MINUTES = 15;
    
    private final SchedulingConstraintDAO dao;
    private List<BookingConstraint> existingBookings;
    private Map<Integer, List<TherapistInfo>> therapistsByServiceType;
    private List<RoomBedInfo> roomBedCombinations;
    
    public SpaCspSolver() {
        this.dao = new SchedulingConstraintDAO();
        this.existingBookings = new ArrayList<>();
        this.therapistsByServiceType = new HashMap<>();
        this.roomBedCombinations = new ArrayList<>();
    }
    
    /**
     * Find available time slots for a specific service on a given date
     */
    public List<AvailableTimeSlot> findAvailableSlots(LocalDate targetDate, int serviceId, int maxResults) throws SQLException {
        LOGGER.info("Finding available slots for service ID: " + serviceId + " on date: " + targetDate);
        
        // Step 1: Load service information
        ServiceInfo service = dao.getServiceInfo(serviceId);
        if (service == null) {
            LOGGER.warning("Service not found with ID: " + serviceId);
            return new ArrayList<>();
        }
        
        LOGGER.info("Service: " + service.getName() + 
                   " (Duration: " + service.getDurationMinutes() + "min, Buffer: " + service.getBufferTimeAfterMinutes() + "min)");
        
        // Step 2: Load all constraints
        loadConstraints(targetDate);
        
        // Step 3: Get qualified therapists for this service
        List<TherapistInfo> qualifiedTherapists = dao.getQualifiedTherapists(serviceId);
        if (qualifiedTherapists.isEmpty()) {
            LOGGER.warning("No qualified therapists found for service ID: " + serviceId);
            return new ArrayList<>();
        }
        
        LOGGER.info("Found " + qualifiedTherapists.size() + " qualified therapists");
        
        // Step 4: Generate time slots
        List<TimeSlot> timeSlots = generateTimeSlots(targetDate, service.getTotalTimeMinutes());
        LOGGER.info("Generated " + timeSlots.size() + " possible time slots");
        
        // Step 5: Apply CSP constraints to find available slots
        List<AvailableTimeSlot> availableSlots = new ArrayList<>();
        
        for (TimeSlot timeSlot : timeSlots) {
            List<ResourceCombination> availableResources = findAvailableResources(
                timeSlot, service.getDurationMinutes(), qualifiedTherapists);
            
            if (!availableResources.isEmpty()) {
                availableSlots.add(new AvailableTimeSlot(timeSlot, availableResources));
                
                if (availableSlots.size() >= maxResults) {
                    break;
                }
            }
        }
        
        LOGGER.info("Found " + availableSlots.size() + " available time slots");
        return availableSlots;
    }
    
    /**
     * Load all constraints from database
     */
    private void loadConstraints(LocalDate targetDate) throws SQLException {
        // Load existing bookings
        existingBookings = dao.loadExistingBookings(targetDate);
        LOGGER.info("Loaded " + existingBookings.size() + " existing bookings");
        
        // Load therapists by service type
        therapistsByServiceType = dao.loadTherapistsByServiceType();
        LOGGER.info("Loaded therapists for " + therapistsByServiceType.size() + " service types");
        
        // Load room-bed combinations
        roomBedCombinations = dao.loadRoomsAndBeds();
        LOGGER.info("Loaded " + roomBedCombinations.size() + " room-bed combinations");
    }
    
    /**
     * Generate all possible time slots for the given date and service duration
     */
    private List<TimeSlot> generateTimeSlots(LocalDate targetDate, int totalServiceTimeMinutes) {
        List<TimeSlot> timeSlots = new ArrayList<>();
        
        LocalDateTime currentSlot = LocalDateTime.of(targetDate, BUSINESS_OPEN_TIME);
        LocalDateTime endOfDay = LocalDateTime.of(targetDate, BUSINESS_CLOSE_TIME);
        
        while (currentSlot.plusMinutes(totalServiceTimeMinutes).isBefore(endOfDay) || 
               currentSlot.plusMinutes(totalServiceTimeMinutes).equals(endOfDay)) {
            
            LocalDateTime slotEnd = currentSlot.plusMinutes(totalServiceTimeMinutes);
            timeSlots.add(new TimeSlot(currentSlot, slotEnd));
            
            currentSlot = currentSlot.plusMinutes(TIME_SLOT_INTERVAL_MINUTES);
        }
        
        return timeSlots;
    }
    
    /**
     * Find available resource combinations for a given time slot
     */
    private List<ResourceCombination> findAvailableResources(TimeSlot timeSlot, int serviceDurationMinutes, 
                                                           List<TherapistInfo> qualifiedTherapists) {
        List<ResourceCombination> availableResources = new ArrayList<>();
        
        // Check each combination of therapist, room, and bed
        for (TherapistInfo therapist : qualifiedTherapists) {
            for (RoomBedInfo roomBed : roomBedCombinations) {
                if (isResourceCombinationAvailable(timeSlot, therapist.getUserId(), 
                                                 roomBed.getRoomId(), roomBed.getBedId())) {
                    
                    ResourceCombination resource = new ResourceCombination(
                        therapist.getUserId(),
                        therapist.getFullName(),
                        roomBed.getRoomId(),
                        roomBed.getRoomName(),
                        roomBed.getBedId(),
                        roomBed.getBedName()
                    );
                    
                    availableResources.add(resource);
                }
            }
        }
        
        return availableResources;
    }
    
    /**
     * Check if a specific resource combination is available during the time slot
     */
    private boolean isResourceCombinationAvailable(TimeSlot timeSlot, int therapistId, 
                                                  int roomId, Integer bedId) {
        for (BookingConstraint booking : existingBookings) {
            if (booking.conflictsWith(timeSlot.getStartTime(), timeSlot.getEndTime(), 
                                    therapistId, roomId, bedId)) {
                return false;
            }
        }
        return true;
    }
    
    /**
     * Get a summary of constraints for debugging
     */
    public String getConstraintsSummary() {
        StringBuilder summary = new StringBuilder();
        summary.append("=== CSP Constraints Summary ===\n");
        summary.append("Existing Bookings: ").append(existingBookings.size()).append("\n");
        summary.append("Service Types with Therapists: ").append(therapistsByServiceType.size()).append("\n");
        summary.append("Room-Bed Combinations: ").append(roomBedCombinations.size()).append("\n");
        
        summary.append("\nExisting Bookings:\n");
        for (BookingConstraint booking : existingBookings) {
            summary.append("  ").append(booking.getStartTime().toLocalTime())
                   .append("-").append(booking.getEndTime().toLocalTime())
                   .append(" (until ").append(booking.getBufferEndTime().toLocalTime()).append(" with buffer)")
                   .append(" - Therapist: ").append(booking.getTherapistId())
                   .append(", Room: ").append(booking.getRoomId())
                   .append(", Bed: ").append(booking.getBedId()).append("\n");
        }
        
        return summary.toString();
    }
}