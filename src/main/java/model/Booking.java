package model;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalTime;
import lombok.ToString;

/**
 * Booking model class for individual service bookings linked to paid services
 * Represents the bookings table in the database
 * 
 * @author SpaManagement
 */
@ToString
public class Booking {
    private Integer bookingId;
    private Integer customerId;
    private Integer paymentItemId;
    private Integer serviceId;
    private Integer therapistUserId;
    private Date appointmentDate;
    private Time appointmentTime;
    private Integer durationMinutes;
    private BookingStatus bookingStatus;
    private String bookingNotes;
    private String cancellationReason;
    private Timestamp cancelledAt;
    private Integer cancelledBy; // User ID who cancelled
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Integer roomId; // Room assignment
    private Integer bedId; // Bed assignment (nullable)
    
    // Related entities (for joins)
    private Customer customer;
    private PaymentItem paymentItem;
    private Service service;
    private User therapist;
    private User cancelledByUser;
    
    // Enum for booking status
    public enum BookingStatus {
        SCHEDULED, CONFIRMED, IN_PROGRESS, COMPLETED, CANCELLED, NO_SHOW;

        public String getDisplayName() {
            throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
        }
    }
    
    // Constructors
    public Booking() {
        this.bookingStatus = BookingStatus.SCHEDULED;
        this.createdAt = new Timestamp(System.currentTimeMillis());
        this.updatedAt = new Timestamp(System.currentTimeMillis());
    }
    
    public Booking(Integer customerId, Integer paymentItemId, Integer serviceId, 
                   Integer therapistUserId, Date appointmentDate, Time appointmentTime, 
                   Integer durationMinutes) {
        this();
        this.customerId = customerId;
        this.paymentItemId = paymentItemId;
        this.serviceId = serviceId;
        this.therapistUserId = therapistUserId;
        this.appointmentDate = appointmentDate;
        this.appointmentTime = appointmentTime;
        this.durationMinutes = durationMinutes;
    }
    
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
    
    public Integer getPaymentItemId() {
        return paymentItemId;
    }
    
    public void setPaymentItemId(Integer paymentItemId) {
        this.paymentItemId = paymentItemId;
    }
    
    public Integer getServiceId() {
        return serviceId;
    }
    
    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }
    
    public Integer getTherapistUserId() {
        return therapistUserId;
    }
    
    public void setTherapistUserId(Integer therapistUserId) {
        this.therapistUserId = therapistUserId;
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
    
    public BookingStatus getBookingStatus() {
        return bookingStatus;
    }
    
    public void setBookingStatus(BookingStatus bookingStatus) {
        this.bookingStatus = bookingStatus;
        this.updatedAt = new Timestamp(System.currentTimeMillis());
    }
    
    public String getBookingNotes() {
        return bookingNotes;
    }
    
    public void setBookingNotes(String bookingNotes) {
        this.bookingNotes = bookingNotes;
    }
    
    public String getCancellationReason() {
        return cancellationReason;
    }
    
    public void setCancellationReason(String cancellationReason) {
        this.cancellationReason = cancellationReason;
    }
    
    public Timestamp getCancelledAt() {
        return cancelledAt;
    }
    
    public void setCancelledAt(Timestamp cancelledAt) {
        this.cancelledAt = cancelledAt;
    }
    
    public Integer getCancelledBy() {
        return cancelledBy;
    }
    
    public void setCancelledBy(Integer cancelledBy) {
        this.cancelledBy = cancelledBy;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    // Related entity getters and setters
    public Customer getCustomer() {
        return customer;
    }
    
    public void setCustomer(Customer customer) {
        this.customer = customer;
    }
    
    public PaymentItem getPaymentItem() {
        return paymentItem;
    }
    
    public void setPaymentItem(PaymentItem paymentItem) {
        this.paymentItem = paymentItem;
    }
    
    public Service getService() {
        return service;
    }
    
    public void setService(Service service) {
        this.service = service;
    }
    
    public User getTherapist() {
        return therapist;
    }
    
    public void setTherapist(User therapist) {
        this.therapist = therapist;
    }
    
    public User getCancelledByUser() {
        return cancelledByUser;
    }
    
    public void setCancelledByUser(User cancelledByUser) {
        this.cancelledByUser = cancelledByUser;
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

    // Utility methods
    
    /**
     * Check if booking is active (not cancelled or no-show)
     * @return true if active, false otherwise
     */
    public boolean isActive() {
        return bookingStatus != BookingStatus.CANCELLED && bookingStatus != BookingStatus.NO_SHOW;
    }
    
    /**
     * Check if booking is completed
     * @return true if completed, false otherwise
     */
    public boolean isCompleted() {
        return BookingStatus.COMPLETED.equals(bookingStatus);
    }
    
    /**
     * Check if booking can be cancelled
     * @return true if can be cancelled, false otherwise
     */
    public boolean canBeCancelled() {
        return bookingStatus == BookingStatus.SCHEDULED || bookingStatus == BookingStatus.CONFIRMED;
    }
    
    /**
     * Cancel the booking with reason and canceller
     * @param reason Cancellation reason
     * @param cancelledByUserId User ID who cancelled
     */
    public void cancel(String reason, Integer cancelledByUserId) {
        this.bookingStatus = BookingStatus.CANCELLED;
        this.cancellationReason = reason;
        this.cancelledBy = cancelledByUserId;
        this.cancelledAt = new Timestamp(System.currentTimeMillis());
        this.updatedAt = new Timestamp(System.currentTimeMillis());
    }
    
    /**
     * Get end time of the appointment
     * @return Time when appointment ends
     */
    public Time getEndTime() {
        if (appointmentTime != null && durationMinutes != null) {
            LocalTime startTime = appointmentTime.toLocalTime();
            LocalTime endTime = startTime.plusMinutes(durationMinutes);
            return Time.valueOf(endTime);
        }
        return null;
    }
    
    /**
     * Check if booking is for a specific date
     * @param date Date to check
     * @return true if booking is on the specified date
     */
    public boolean isOnDate(LocalDate date) {
        return appointmentDate != null && appointmentDate.toLocalDate().equals(date);
    }
    
    /**
     * Validate booking data
     * @return true if valid, false otherwise
     */
    public boolean isValid() {
        return customerId != null && customerId > 0 &&
               paymentItemId != null && paymentItemId > 0 &&
               serviceId != null && serviceId > 0 &&
               therapistUserId != null && therapistUserId > 0 &&
               appointmentDate != null &&
               appointmentTime != null &&
               durationMinutes != null && durationMinutes > 0;
    }
}
