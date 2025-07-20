package model;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

/**
 * Model class representing detailed booking information
 * Used for displaying comprehensive booking data in responses
 * 
 * @author SpaManagement
 */
public class BookingDetails {
    
    private Integer bookingId;
    private Integer customerId;
    private String customerName;
    private String customerPhone;
    private Integer serviceId;
    private String serviceName;
    private Integer therapistId;
    private String therapistName;
    private Date appointmentDate;
    private Time appointmentTime;
    private Integer durationMinutes;
    private String bookingStatus;
    private String bookingNotes;
    private Integer roomId;
    private String roomName;
    private Integer bedId;
    private String bedName;
    private Integer paymentItemId;
    private String referenceNumber;
    private Timestamp createdAt;
    
    // Constructors
    public BookingDetails() {}
    
    // Getters and Setters
    public Integer getBookingId() {
        return bookingId;
    }
    
    public void setBookingId(Integer bookingId) {
        this.bookingId = bookingId;
    }
    
    public Integer getCustomerId() {
        return customerId;
    }
    
    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }
    
    public String getCustomerName() {
        return customerName;
    }
    
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
    public String getCustomerPhone() {
        return customerPhone;
    }
    
    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }
    
    public Integer getServiceId() {
        return serviceId;
    }
    
    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }
    
    public String getServiceName() {
        return serviceName;
    }
    
    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }
    
    public Integer getTherapistId() {
        return therapistId;
    }
    
    public void setTherapistId(Integer therapistId) {
        this.therapistId = therapistId;
    }
    
    public String getTherapistName() {
        return therapistName;
    }
    
    public void setTherapistName(String therapistName) {
        this.therapistName = therapistName;
    }
    
    public Date getAppointmentDate() {
        return appointmentDate;
    }
    
    public void setAppointmentDate(Date appointmentDate) {
        this.appointmentDate = appointmentDate;
    }
    
    public Time getAppointmentTime() {
        return appointmentTime;
    }
    
    public void setAppointmentTime(Time appointmentTime) {
        this.appointmentTime = appointmentTime;
    }
    
    public Integer getDurationMinutes() {
        return durationMinutes;
    }
    
    public void setDurationMinutes(Integer durationMinutes) {
        this.durationMinutes = durationMinutes;
    }
    
    public String getBookingStatus() {
        return bookingStatus;
    }
    
    public void setBookingStatus(String bookingStatus) {
        this.bookingStatus = bookingStatus;
    }
    
    public String getBookingNotes() {
        return bookingNotes;
    }
    
    public void setBookingNotes(String bookingNotes) {
        this.bookingNotes = bookingNotes;
    }
    
    public Integer getRoomId() {
        return roomId;
    }
    
    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
    }
    
    public String getRoomName() {
        return roomName;
    }
    
    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }
    
    public Integer getBedId() {
        return bedId;
    }
    
    public void setBedId(Integer bedId) {
        this.bedId = bedId;
    }
    
    public String getBedName() {
        return bedName;
    }
    
    public void setBedName(String bedName) {
        this.bedName = bedName;
    }
    
    public Integer getPaymentItemId() {
        return paymentItemId;
    }
    
    public void setPaymentItemId(Integer paymentItemId) {
        this.paymentItemId = paymentItemId;
    }
    
    public String getReferenceNumber() {
        return referenceNumber;
    }
    
    public void setReferenceNumber(String referenceNumber) {
        this.referenceNumber = referenceNumber;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    // Utility methods
    
    /**
     * Get formatted appointment date and time
     */
    public String getFormattedAppointment() {
        if (appointmentDate == null || appointmentTime == null) {
            return "N/A";
        }
        return appointmentDate.toString() + " " + appointmentTime.toString();
    }
    
    /**
     * Get formatted duration
     */
    public String getFormattedDuration() {
        if (durationMinutes == null) {
            return "N/A";
        }
        
        int hours = durationMinutes / 60;
        int minutes = durationMinutes % 60;
        
        if (hours > 0 && minutes > 0) {
            return hours + "h " + minutes + "m";
        } else if (hours > 0) {
            return hours + "h";
        } else {
            return minutes + "m";
        }
    }
    
    /**
     * Get room and bed information
     */
    public String getRoomBedInfo() {
        StringBuilder info = new StringBuilder();
        
        if (roomName != null) {
            info.append(roomName);
        } else if (roomId != null) {
            info.append("Room ").append(roomId);
        }
        
        if (bedName != null) {
            if (info.length() > 0) info.append(" - ");
            info.append(bedName);
        } else if (bedId != null) {
            if (info.length() > 0) info.append(" - ");
            info.append("Bed ").append(bedId);
        }
        
        return info.length() > 0 ? info.toString() : "N/A";
    }
    
    @Override
    public String toString() {
        return "BookingDetails{" +
                "bookingId=" + bookingId +
                ", customerName='" + customerName + '\'' +
                ", serviceName='" + serviceName + '\'' +
                ", appointmentDate=" + appointmentDate +
                ", appointmentTime=" + appointmentTime +
                ", bookingStatus='" + bookingStatus + '\'' +
                '}';
    }
}
