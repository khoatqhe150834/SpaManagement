package model.csp;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Enhanced CSP Domain management for booking constraints
 * Manages separate domains for each booking variable with real-time validation
 */
public class CSPDomain {
    
    // Domain collections
    private List<TimeSlot> timeSlotDomain;
    private List<Integer> therapistDomain;
    private List<Integer> roomDomain;
    private List<Integer> bedDomain;
    private Map<String, Object> serviceDomain;
    
    // Constraint tracking
    private Map<Integer, Set<LocalDateTime>> therapistUnavailableSlots;
    private Map<Integer, Set<LocalDateTime>> roomUnavailableSlots;
    private Map<Integer, Set<LocalDateTime>> bedUnavailableSlots;
    
    // Availability cache for performance
    private Map<String, Boolean> availabilityCache;
    private long cacheTimestamp;
    private static final long CACHE_VALIDITY_MS = 30000; // 30 seconds
    
    public CSPDomain() {
        this.timeSlotDomain = new ArrayList<>();
        this.therapistDomain = new ArrayList<>();
        this.roomDomain = new ArrayList<>();
        this.bedDomain = new ArrayList<>();
        this.serviceDomain = new HashMap<>();
        
        this.therapistUnavailableSlots = new HashMap<>();
        this.roomUnavailableSlots = new HashMap<>();
        this.bedUnavailableSlots = new HashMap<>();
        
        this.availabilityCache = new HashMap<>();
        this.cacheTimestamp = System.currentTimeMillis();
    }
    
    /**
     * Initialize all domains with available values
     */
    public void initializeDomains(List<TimeSlot> timeSlots, List<Integer> therapists, 
                                 List<Integer> rooms, List<Integer> beds, Map<String, Object> service) {
        this.timeSlotDomain = new ArrayList<>(timeSlots);
        this.therapistDomain = new ArrayList<>(therapists);
        this.roomDomain = new ArrayList<>(rooms);
        this.bedDomain = new ArrayList<>(beds);
        this.serviceDomain = new HashMap<>(service);
        
        // Clear cache when domains are reinitialized
        clearCache();
    }
    
    /**
     * Apply constraint propagation to reduce domain sizes
     */
    public void applyConstraintPropagation(BookingCSPRequest request) {
        int initialTimeSlots = timeSlotDomain.size();
        int initialTherapists = therapistDomain.size();
        int initialRooms = roomDomain.size();
        int initialBeds = bedDomain.size();
        
        // Filter time slots based on availability
        timeSlotDomain = timeSlotDomain.stream()
            .filter(slot -> isSlotAvailable(slot, request))
            .collect(Collectors.toList());
        
        // Filter therapists based on availability and qualifications
        therapistDomain = therapistDomain.stream()
            .filter(therapistId -> isTherapistQualified(therapistId, request) && 
                                  hasAvailableTimeSlots(therapistId, request))
            .collect(Collectors.toList());
        
        // Filter rooms based on service requirements
        roomDomain = roomDomain.stream()
            .filter(roomId -> isRoomSuitable(roomId, request))
            .collect(Collectors.toList());
        
        // Filter beds based on room availability
        bedDomain = bedDomain.stream()
            .filter(bedId -> isBedAvailable(bedId, request))
            .collect(Collectors.toList());
        
        System.out.printf("CSP Domain reduction: TimeSlots %d->%d, Therapists %d->%d, Rooms %d->%d, Beds %d->%d%n",
            initialTimeSlots, timeSlotDomain.size(),
            initialTherapists, therapistDomain.size(),
            initialRooms, roomDomain.size(),
            initialBeds, bedDomain.size());
    }
    
    /**
     * Check if a time slot is available considering all constraints
     */
    public boolean isSlotAvailable(TimeSlot slot, BookingCSPRequest request) {
        String cacheKey = generateCacheKey(slot, request);
        
        // Check cache first
        if (isCacheValid() && availabilityCache.containsKey(cacheKey)) {
            return availabilityCache.get(cacheKey);
        }
        
        boolean available = checkSlotAvailability(slot, request);
        
        // Cache the result
        availabilityCache.put(cacheKey, available);
        
        return available;
    }
    
    /**
     * Actual slot availability checking logic
     */
    private boolean checkSlotAvailability(TimeSlot slot, BookingCSPRequest request) {
        // Check if any qualified therapist is available
        boolean hasAvailableTherapist = therapistDomain.stream()
            .anyMatch(therapistId -> isTherapistAvailableForSlot(therapistId, slot));
        
        // Check if any suitable room is available
        boolean hasAvailableRoom = roomDomain.stream()
            .anyMatch(roomId -> isRoomAvailableForSlot(roomId, slot));
        
        // Check if any bed is available
        boolean hasAvailableBed = bedDomain.stream()
            .anyMatch(bedId -> isBedAvailableForSlot(bedId, slot));
        
        return hasAvailableTherapist && hasAvailableRoom && hasAvailableBed;
    }
    
    /**
     * Check therapist availability for specific slot
     */
    private boolean isTherapistAvailableForSlot(Integer therapistId, TimeSlot slot) {
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
     * Check room availability for specific slot
     */
    private boolean isRoomAvailableForSlot(Integer roomId, TimeSlot slot) {
        Set<LocalDateTime> unavailableSlots = roomUnavailableSlots.get(roomId);
        if (unavailableSlots == null) {
            return true;
        }
        
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
     * Check bed availability for specific slot
     */
    private boolean isBedAvailableForSlot(Integer bedId, TimeSlot slot) {
        Set<LocalDateTime> unavailableSlots = bedUnavailableSlots.get(bedId);
        if (unavailableSlots == null) {
            return true;
        }
        
        LocalDateTime current = slot.getStartTime();
        while (!current.isAfter(slot.getEndTime().minusMinutes(15))) {
            if (unavailableSlots.contains(current)) {
                return false;
            }
            current = current.plusMinutes(15);
        }
        
        return true;
    }
    
    // Placeholder methods for constraint checking
    private boolean isTherapistQualified(Integer therapistId, BookingCSPRequest request) {
        // TODO: Check therapist qualifications against service requirements
        return true;
    }
    
    private boolean hasAvailableTimeSlots(Integer therapistId, BookingCSPRequest request) {
        return timeSlotDomain.stream()
            .anyMatch(slot -> isTherapistAvailableForSlot(therapistId, slot));
    }
    
    private boolean isRoomSuitable(Integer roomId, BookingCSPRequest request) {
        // TODO: Check room suitability for service type
        return true;
    }
    
    private boolean isBedAvailable(Integer bedId, BookingCSPRequest request) {
        return timeSlotDomain.stream()
            .anyMatch(slot -> isBedAvailableForSlot(bedId, slot));
    }
    
    // Cache management
    private String generateCacheKey(TimeSlot slot, BookingCSPRequest request) {
        return String.format("%s_%d_%d", 
            slot.getStartTime().toString(), 
            request.getCustomerId(), 
            request.getServiceId());
    }
    
    private boolean isCacheValid() {
        return (System.currentTimeMillis() - cacheTimestamp) < CACHE_VALIDITY_MS;
    }
    
    public void clearCache() {
        availabilityCache.clear();
        cacheTimestamp = System.currentTimeMillis();
    }
    
    // Getters and setters
    public List<TimeSlot> getTimeSlotDomain() { return timeSlotDomain; }
    public List<Integer> getTherapistDomain() { return therapistDomain; }
    public List<Integer> getRoomDomain() { return roomDomain; }
    public List<Integer> getBedDomain() { return bedDomain; }
    
    public void setTherapistUnavailableSlots(Map<Integer, Set<LocalDateTime>> slots) {
        this.therapistUnavailableSlots = slots;
        clearCache();
    }
    
    public void setRoomUnavailableSlots(Map<Integer, Set<LocalDateTime>> slots) {
        this.roomUnavailableSlots = slots;
        clearCache();
    }
    
    public void setBedUnavailableSlots(Map<Integer, Set<LocalDateTime>> slots) {
        this.bedUnavailableSlots = slots;
        clearCache();
    }
}
