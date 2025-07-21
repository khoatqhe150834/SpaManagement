package model.csp;

/**
 * Represents a complete assignment solution for booking a service
 * 
 * @author SpaManagement
 */
public class BookingAssignment {
    private TimeSlot timeSlot;
    private Integer therapistId;
    private Integer roomId;
    private Integer bedId;
    private ConfidenceLevel confidenceLevel;
    private String notes;
    
    public enum ConfidenceLevel {
        HIGH("High - Multiple options available"),
        MEDIUM("Medium - Limited options available"), 
        LOW("Low - Single option available");
        
        private final String description;
        
        ConfidenceLevel(String description) {
            this.description = description;
        }
        
        public String getDescription() {
            return description;
        }
    }
    
    public BookingAssignment() {}
    
    public BookingAssignment(TimeSlot timeSlot, Integer therapistId, Integer roomId, Integer bedId) {
        this.timeSlot = timeSlot;
        this.therapistId = therapistId;
        this.roomId = roomId;
        this.bedId = bedId;
        this.confidenceLevel = ConfidenceLevel.HIGH;
    }
    
    // Getters and Setters
    public TimeSlot getTimeSlot() {
        return timeSlot;
    }
    
    public void setTimeSlot(TimeSlot timeSlot) {
        this.timeSlot = timeSlot;
    }
    
    public Integer getTherapistId() {
        return therapistId;
    }
    
    public void setTherapistId(Integer therapistId) {
        this.therapistId = therapistId;
    }
    
    public Integer getRoomId() {
        return roomId;
    }
    
    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
    }
    
    public Integer getBedId() {
        return bedId;
    }
    
    public void setBedId(Integer bedId) {
        this.bedId = bedId;
    }
    
    public ConfidenceLevel getConfidenceLevel() {
        return confidenceLevel;
    }
    
    public void setConfidenceLevel(ConfidenceLevel confidenceLevel) {
        this.confidenceLevel = confidenceLevel;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    // Utility methods
    public boolean isComplete() {
        return timeSlot != null && therapistId != null && roomId != null && bedId != null;
    }
    
    public boolean hasConflictWith(BookingAssignment other) {
        if (other == null || !this.isComplete() || !other.isComplete()) {
            return false;
        }
        
        // Check time overlap
        if (!this.timeSlot.overlaps(other.timeSlot)) {
            return false;
        }
        
        // Check resource conflicts
        return this.therapistId.equals(other.therapistId) ||
               this.roomId.equals(other.roomId) ||
               this.bedId.equals(other.bedId);
    }
    
    @Override
    public String toString() {
        return String.format("BookingAssignment{timeSlot=%s, therapist=%d, room=%d, bed=%d, confidence=%s}",
                timeSlot, therapistId, roomId, bedId, confidenceLevel);
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        BookingAssignment that = (BookingAssignment) obj;
        return timeSlot.equals(that.timeSlot) &&
               therapistId.equals(that.therapistId) &&
               roomId.equals(that.roomId) &&
               bedId.equals(that.bedId);
    }
    
    @Override
    public int hashCode() {
        int result = timeSlot.hashCode();
        result = 31 * result + therapistId.hashCode();
        result = 31 * result + roomId.hashCode();
        result = 31 * result + bedId.hashCode();
        return result;
    }
}
