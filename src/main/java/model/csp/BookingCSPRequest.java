package model.csp;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

/**
 * Request object for CSP booking solver
 * 
 * @author SpaManagement
 */
public class BookingCSPRequest {
    private Integer customerId;
    private Integer serviceId;
    private Integer preferredTherapistId;
    private LocalDate preferredDate;
    private LocalTime preferredStartTime;
    private LocalTime preferredEndTime;
    private LocalDate searchStartDate;
    private LocalDate searchEndDate;
    private int maxResults = 50; // Limit results for performance
    private boolean includeWeekends = true;
    private int minimumNoticeHours = 2;
    private int bufferTimeMinutes = 15;
    
    // Constructors
    public BookingCSPRequest() {
        // Set default search range to next 60 days
        this.searchStartDate = LocalDate.now();
        this.searchEndDate = LocalDate.now().plusDays(60);
    }
    
    public BookingCSPRequest(Integer customerId, Integer serviceId) {
        this();
        this.customerId = customerId;
        this.serviceId = serviceId;
    }
    
    // Getters and Setters
    public Integer getCustomerId() {
        return customerId;
    }
    
    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }
    
    public Integer getServiceId() {
        return serviceId;
    }
    
    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }
    
    public Integer getPreferredTherapistId() {
        return preferredTherapistId;
    }
    
    public void setPreferredTherapistId(Integer preferredTherapistId) {
        this.preferredTherapistId = preferredTherapistId;
    }
    
    public LocalDate getPreferredDate() {
        return preferredDate;
    }
    
    public void setPreferredDate(LocalDate preferredDate) {
        this.preferredDate = preferredDate;
    }
    
    public LocalTime getPreferredStartTime() {
        return preferredStartTime;
    }
    
    public void setPreferredStartTime(LocalTime preferredStartTime) {
        this.preferredStartTime = preferredStartTime;
    }
    
    public LocalTime getPreferredEndTime() {
        return preferredEndTime;
    }
    
    public void setPreferredEndTime(LocalTime preferredEndTime) {
        this.preferredEndTime = preferredEndTime;
    }
    
    public LocalDate getSearchStartDate() {
        return searchStartDate;
    }
    
    public void setSearchStartDate(LocalDate searchStartDate) {
        this.searchStartDate = searchStartDate;
    }
    
    public LocalDate getSearchEndDate() {
        return searchEndDate;
    }
    
    public void setSearchEndDate(LocalDate searchEndDate) {
        this.searchEndDate = searchEndDate;
    }
    
    public int getMaxResults() {
        return maxResults;
    }
    
    public void setMaxResults(int maxResults) {
        this.maxResults = maxResults;
    }
    
    public boolean isIncludeWeekends() {
        return includeWeekends;
    }
    
    public void setIncludeWeekends(boolean includeWeekends) {
        this.includeWeekends = includeWeekends;
    }
    
    public int getMinimumNoticeHours() {
        return minimumNoticeHours;
    }
    
    public void setMinimumNoticeHours(int minimumNoticeHours) {
        this.minimumNoticeHours = minimumNoticeHours;
    }
    
    public int getBufferTimeMinutes() {
        return bufferTimeMinutes;
    }
    
    public void setBufferTimeMinutes(int bufferTimeMinutes) {
        this.bufferTimeMinutes = bufferTimeMinutes;
    }
    
    // Utility methods
    public boolean hasPreferredTherapist() {
        return preferredTherapistId != null;
    }
    
    public boolean hasPreferredDate() {
        return preferredDate != null;
    }
    
    public boolean hasTimePreferences() {
        return preferredStartTime != null || preferredEndTime != null;
    }
    
    public LocalDateTime getEarliestBookingTime() {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime minimumTime = now.plusHours(minimumNoticeHours);
        LocalDateTime searchStart = searchStartDate.atTime(8, 0); // Business start time

        // FIXED: For future dates, use business start time instead of minimum notice
        // Only apply minimum notice constraint for same-day or next-day bookings
        if (searchStartDate.isAfter(now.toLocalDate().plusDays(1))) {
            // For dates more than 1 day in the future, start from business hours
            return searchStart;
        } else {
            // For same-day or next-day bookings, apply minimum notice constraint
            return minimumTime.isAfter(searchStart) ? minimumTime : searchStart;
        }
    }
    
    @Override
    public String toString() {
        return String.format("BookingCSPRequest{customerId=%d, serviceId=%d, preferredTherapist=%s, " +
                "searchRange=%s to %s, maxResults=%d}",
                customerId, serviceId, preferredTherapistId, searchStartDate, searchEndDate, maxResults);
    }
}
