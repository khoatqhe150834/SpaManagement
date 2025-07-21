package model;

/**
 * Model class representing the result of an availability check
 * Used for checking therapist, room, or time slot availability
 * 
 * @author SpaManagement
 */
public class AvailabilityResult {
    
    private boolean available;
    private String reason;
    private Booking conflictingBooking;
    
    // Constructors
    public AvailabilityResult() {}
    
    public AvailabilityResult(boolean available, String reason, Booking conflictingBooking) {
        this.available = available;
        this.reason = reason;
        this.conflictingBooking = conflictingBooking;
    }
    
    // Getters and Setters
    public boolean isAvailable() {
        return available;
    }
    
    public void setAvailable(boolean available) {
        this.available = available;
    }
    
    public String getReason() {
        return reason;
    }
    
    public void setReason(String reason) {
        this.reason = reason;
    }
    
    public Booking getConflictingBooking() {
        return conflictingBooking;
    }
    
    public void setConflictingBooking(Booking conflictingBooking) {
        this.conflictingBooking = conflictingBooking;
    }
    
    // Utility methods
    
    /**
     * Check if this result indicates availability
     */
    public boolean hasAvailability() {
        return available;
    }
    
    /**
     * Check if there's a conflicting booking
     */
    public boolean hasConflict() {
        return conflictingBooking != null;
    }
    
    /**
     * Get conflict details if available
     */
    public String getConflictDetails() {
        if (conflictingBooking == null) {
            return null;
        }
        
        return String.format("Booking ID: %d, Time: %s-%s", 
            conflictingBooking.getBookingId(),
            conflictingBooking.getAppointmentTime(),
            conflictingBooking.getAppointmentTime().toLocalTime()
                .plusMinutes(conflictingBooking.getDurationMinutes()));
    }
    
    /**
     * Create a successful availability result
     */
    public static AvailabilityResult available(String reason) {
        return new AvailabilityResult(true, reason, null);
    }
    
    /**
     * Create an unavailable result with reason
     */
    public static AvailabilityResult unavailable(String reason) {
        return new AvailabilityResult(false, reason, null);
    }
    
    /**
     * Create an unavailable result with conflicting booking
     */
    public static AvailabilityResult unavailable(String reason, Booking conflictingBooking) {
        return new AvailabilityResult(false, reason, conflictingBooking);
    }
    
    @Override
    public String toString() {
        return "AvailabilityResult{" +
                "available=" + available +
                ", reason='" + reason + '\'' +
                ", hasConflict=" + hasConflict() +
                '}';
    }
}
