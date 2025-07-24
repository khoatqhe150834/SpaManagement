// src/main/java/model/BookingConstraint.java
package booking;

import java.time.LocalDateTime;

public class BookingConstraint {
    private int therapistId;
    private int roomId;
    private Integer bedId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private LocalDateTime bufferEndTime; // Add buffer end time
    private String bookingStatus;
    private int serviceDurationMinutes;
    private int bufferTimeMinutes;
    
    // Constructor with all parameters including buffer
    public BookingConstraint(int therapistId, int roomId, Integer bedId, 
                           LocalDateTime startTime, LocalDateTime endTime, 
                           LocalDateTime bufferEndTime, String bookingStatus,
                           int serviceDurationMinutes, int bufferTimeMinutes) {
        this.therapistId = therapistId;
        this.roomId = roomId;
        this.bedId = bedId;
        this.startTime = startTime;
        this.endTime = endTime;
        this.bufferEndTime = bufferEndTime;
        this.bookingStatus = bookingStatus;
        this.serviceDurationMinutes = serviceDurationMinutes;
        this.bufferTimeMinutes = bufferTimeMinutes;
    }
    
    // Constructor for backward compatibility (assumes 15-minute buffer)
    public BookingConstraint(int therapistId, int roomId, Integer bedId, 
                           LocalDateTime startTime, LocalDateTime endTime, String bookingStatus) {
        this(therapistId, roomId, bedId, startTime, endTime, 
             endTime.plusMinutes(15), bookingStatus, 0, 15);
    }
    
    // Getters and setters
    public int getTherapistId() { return therapistId; }
    public void setTherapistId(int therapistId) { this.therapistId = therapistId; }
    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }
    public Integer getBedId() { return bedId; }
    public void setBedId(Integer bedId) { this.bedId = bedId; }
    public LocalDateTime getStartTime() { return startTime; }
    public void setStartTime(LocalDateTime startTime) { this.startTime = startTime; }
    public LocalDateTime getEndTime() { return endTime; }
    public void setEndTime(LocalDateTime endTime) { this.endTime = endTime; }
    public LocalDateTime getBufferEndTime() { return bufferEndTime; }
    public void setBufferEndTime(LocalDateTime bufferEndTime) { this.bufferEndTime = bufferEndTime; }
    public String getBookingStatus() { return bookingStatus; }
    public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }
    public int getServiceDurationMinutes() { return serviceDurationMinutes; }
    public void setServiceDurationMinutes(int serviceDurationMinutes) { this.serviceDurationMinutes = serviceDurationMinutes; }
    public int getBufferTimeMinutes() { return bufferTimeMinutes; }
    public void setBufferTimeMinutes(int bufferTimeMinutes) { this.bufferTimeMinutes = bufferTimeMinutes; }
    
    /**
     * Check if this booking conflicts with a given time slot (including buffer)
     * Returns true if there's a conflict, false otherwise
     */
    public boolean conflictsWith(LocalDateTime slotStart, LocalDateTime slotEnd, 
                                int therapistId, int roomId, Integer bedId) {
        // Check if resources match (either same therapist OR same room/bed combination)
        boolean resourceConflict = (this.therapistId == therapistId) || 
                                 (this.roomId == roomId && 
                                  ((this.bedId != null && this.bedId.equals(bedId)) || 
                                   (this.bedId == null && bedId == null)));
        
        if (!resourceConflict) {
            return false; // No resource conflict, so no overall conflict
        }
        
        // Check time overlap (including buffer time)
        // Conflict if: slot starts before our buffer ends AND slot ends after our start
        return (slotStart.isBefore(this.bufferEndTime) && slotEnd.isAfter(this.startTime));
    }
    
    /**
     * Check if this booking conflicts with another booking
     */
    public boolean conflictsWith(BookingConstraint other) {
        return this.conflictsWith(other.startTime, other.bufferEndTime, 
                                other.therapistId, other.roomId, other.bedId);
    }
    
    /**
     * Check if a time slot overlaps with this booking (service time only, no buffer)
     */
    public boolean overlapsServiceTime(LocalDateTime slotStart, LocalDateTime slotEnd) {
        return (slotStart.isBefore(this.endTime) && slotEnd.isAfter(this.startTime));
    }
    
    /**
     * Check if a time slot overlaps with this booking's buffer time
     */
    public boolean overlapsBufferTime(LocalDateTime slotStart, LocalDateTime slotEnd) {
        return (slotStart.isBefore(this.bufferEndTime) && slotEnd.isAfter(this.endTime));
    }
    
    /**
     * Get total blocked time (service + buffer)
     */
    public int getTotalBlockedMinutes() {
        return serviceDurationMinutes + bufferTimeMinutes;
    }
    
    @Override
    public String toString() {
        return "BookingConstraint{" +
               "therapistId=" + therapistId + 
               ", roomId=" + roomId + 
               ", bedId=" + bedId + 
               ", startTime=" + startTime + 
               ", endTime=" + endTime +
               ", bufferEndTime=" + bufferEndTime + 
               ", serviceDuration=" + serviceDurationMinutes +
               ", bufferTime=" + bufferTimeMinutes + 
               ", status='" + bookingStatus + '\'' +
               '}';
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        BookingConstraint that = (BookingConstraint) o;
        
        if (therapistId != that.therapistId) return false;
        if (roomId != that.roomId) return false;
        if (!startTime.equals(that.startTime)) return false;
        return bedId != null ? bedId.equals(that.bedId) : that.bedId == null;
    }
    
    @Override
    public int hashCode() {
        int result = therapistId;
        result = 31 * result + roomId;
        result = 31 * result + (bedId != null ? bedId.hashCode() : 0);
        result = 31 * result + startTime.hashCode();
        return result;
    }
}