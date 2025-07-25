/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author quang
 */
package booking;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalTime;

public class BookingCustomerView {
    private Integer bookingId;
    private LocalDate appointmentDate;
    private LocalTime appointmentTime;
    private Integer durationMinutes;
    private String bookingStatus;
    private String bookingNotes;
    private String serviceName;
    private BigDecimal servicePrice;
    private String therapistName;
    private String roomName;
    private String paymentStatus;
    private BigDecimal totalAmount;
    private String referenceNumber;
    private Timestamp createdAt;
    
    // Constructors
    public BookingCustomerView() {}
    
    // Getters and Setters
    public Integer getBookingId() { return bookingId; }
    public void setBookingId(Integer bookingId) { this.bookingId = bookingId; }
    
    public LocalDate getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(LocalDate appointmentDate) { this.appointmentDate = appointmentDate; }
    
    public LocalTime getAppointmentTime() { return appointmentTime; }
    public void setAppointmentTime(LocalTime appointmentTime) { this.appointmentTime = appointmentTime; }
    
    public Integer getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(Integer durationMinutes) { this.durationMinutes = durationMinutes; }
    
    public String getBookingStatus() { return bookingStatus; }
    public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }
    
    public String getBookingNotes() { return bookingNotes; }
    public void setBookingNotes(String bookingNotes) { this.bookingNotes = bookingNotes; }
    
    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }
    
    public BigDecimal getServicePrice() { return servicePrice; }
    public void setServicePrice(BigDecimal servicePrice) { this.servicePrice = servicePrice; }
    
    public String getTherapistName() { return therapistName; }
    public void setTherapistName(String therapistName) { this.therapistName = therapistName; }
    
    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }
    
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    
    public String getReferenceNumber() { return referenceNumber; }
    public void setReferenceNumber(String referenceNumber) { this.referenceNumber = referenceNumber; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}