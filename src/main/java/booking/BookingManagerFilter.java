/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package booking;

/**
 *
 * @author quang
 */

import java.time.LocalDate;

public class BookingManagerFilter {
    private LocalDate startDate;
    private LocalDate endDate;
    private Integer therapistId;
    private String bookingStatus;
    private Integer serviceTypeId;
    private Integer limit;
    private Integer offset;
    
    // Constructors
    public BookingManagerFilter() {}
    
    public BookingManagerFilter(LocalDate startDate, LocalDate endDate) {
        this.startDate = startDate;
        this.endDate = endDate;
    }
    
    // Getters and Setters
    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }
    
    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }
    
    public Integer getTherapistId() { return therapistId; }
    public void setTherapistId(Integer therapistId) { this.therapistId = therapistId; }
    
    public String getBookingStatus() { return bookingStatus; }
    public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }
    
    public Integer getServiceTypeId() { return serviceTypeId; }
    public void setServiceTypeId(Integer serviceTypeId) { this.serviceTypeId = serviceTypeId; }
    
    public Integer getLimit() { return limit; }
    public void setLimit(Integer limit) { this.limit = limit; }
    
    public Integer getOffset() { return offset; }
    public void setOffset(Integer offset) { this.offset = offset; }
    
    // Helper method for pagination
    public void setPagination(int page, int pageSize) {
        this.limit = pageSize;
        this.offset = (page - 1) * pageSize;
    }
}