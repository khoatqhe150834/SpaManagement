package model.csp;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Represents a time slot in the CSP domain
 * 
 * @author SpaManagement
 */
public class TimeSlot {
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private int durationMinutes;
    
    public TimeSlot(LocalDateTime startTime, int durationMinutes) {
        this.startTime = startTime;
        this.durationMinutes = durationMinutes;
        this.endTime = startTime.plusMinutes(durationMinutes);
    }
    
    public TimeSlot(LocalDateTime startTime, LocalDateTime endTime) {
        this.startTime = startTime;
        this.endTime = endTime;
        this.durationMinutes = (int) java.time.Duration.between(startTime, endTime).toMinutes();
    }
    
    // Getters
    public LocalDateTime getStartTime() {
        return startTime;
    }
    
    public LocalDateTime getEndTime() {
        return endTime;
    }
    
    public int getDurationMinutes() {
        return durationMinutes;
    }
    
    // Utility methods
    public boolean overlaps(TimeSlot other) {
        return this.startTime.isBefore(other.endTime) && this.endTime.isAfter(other.startTime);
    }
    
    public boolean overlapsWith(LocalDateTime otherStart, LocalDateTime otherEnd) {
        return this.startTime.isBefore(otherEnd) && this.endTime.isAfter(otherStart);
    }
    
    public boolean contains(LocalDateTime time) {
        return !time.isBefore(startTime) && time.isBefore(endTime);
    }
    
    public TimeSlot withBuffer(int bufferMinutes) {
        return new TimeSlot(
            startTime.minusMinutes(bufferMinutes),
            endTime.plusMinutes(bufferMinutes)
        );
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        TimeSlot timeSlot = (TimeSlot) obj;
        return startTime.equals(timeSlot.startTime) && endTime.equals(timeSlot.endTime);
    }
    
    @Override
    public int hashCode() {
        return startTime.hashCode() * 31 + endTime.hashCode();
    }
    
    @Override
    public String toString() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        return String.format("TimeSlot{%s - %s (%d min)}", 
            startTime.format(formatter), 
            endTime.format(formatter), 
            durationMinutes);
    }
}
