package model;

/**
 * Model class representing the result of a booking operation
 * Contains success status, message, and booking details
 * 
 * @author SpaManagement
 */
public class BookingResult {
    
    private boolean success;
    private String message;
    private BookingDetails bookingDetails;
    
    // Constructors
    public BookingResult() {}
    
    public BookingResult(boolean success, String message, BookingDetails bookingDetails) {
        this.success = success;
        this.message = message;
        this.bookingDetails = bookingDetails;
    }
    
    // Getters and Setters
    public boolean isSuccess() {
        return success;
    }
    
    public void setSuccess(boolean success) {
        this.success = success;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public BookingDetails getBookingDetails() {
        return bookingDetails;
    }
    
    public void setBookingDetails(BookingDetails bookingDetails) {
        this.bookingDetails = bookingDetails;
    }
    
    // Utility methods
    
    /**
     * Check if the booking operation was successful
     */
    public boolean wasSuccessful() {
        return success;
    }
    
    /**
     * Check if booking details are available
     */
    public boolean hasBookingDetails() {
        return bookingDetails != null;
    }
    
    /**
     * Get booking ID if available
     */
    public Integer getBookingId() {
        return bookingDetails != null ? bookingDetails.getBookingId() : null;
    }
    
    /**
     * Create a successful booking result
     */
    public static BookingResult success(String message, BookingDetails bookingDetails) {
        return new BookingResult(true, message, bookingDetails);
    }
    
    /**
     * Create a failed booking result
     */
    public static BookingResult failure(String message) {
        return new BookingResult(false, message, null);
    }
    
    /**
     * Create a failed booking result with partial booking details
     */
    public static BookingResult failure(String message, BookingDetails bookingDetails) {
        return new BookingResult(false, message, bookingDetails);
    }
    
    @Override
    public String toString() {
        return "BookingResult{" +
                "success=" + success +
                ", message='" + message + '\'' +
                ", hasBookingDetails=" + hasBookingDetails() +
                '}';
    }
}
