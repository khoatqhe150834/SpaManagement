package service;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.BookingDAO;
import dao.CustomerDAO;
import dao.PaymentDAO;
import dao.PaymentItemDAO;
import dao.PaymentItemUsageDAO;
import dao.ServiceDAO;
import dao.SpaInformationDAO;
import model.Booking;
import model.Customer;
import model.Payment;
import model.PaymentItem;
import model.PaymentItemUsage;
import model.Service;

/**
 * Service class for cart-based payment processing
 * Integrates Payment, PaymentItem, PaymentItemUsage, and Booking DAOs
 * 
 * @author SpaManagement
 */
public class CartPaymentService {
    
    private static final Logger LOGGER = Logger.getLogger(CartPaymentService.class.getName());
    
    private final PaymentDAO paymentDAO;
    private final PaymentItemDAO paymentItemDAO;
    private final PaymentItemUsageDAO paymentItemUsageDAO;
    private final BookingDAO bookingDAO;
    private final CustomerDAO customerDAO;
    private final ServiceDAO serviceDAO;
    private final SpaInformationDAO spaInfoDAO;
    
    public CartPaymentService() {
        this.paymentDAO = new PaymentDAO();
        this.paymentItemDAO = new PaymentItemDAO();
        this.paymentItemUsageDAO = new PaymentItemUsageDAO();
        this.bookingDAO = new BookingDAO();
        this.customerDAO = new CustomerDAO();
        this.serviceDAO = new ServiceDAO();
        this.spaInfoDAO = new SpaInformationDAO();
    }
    
    /**
     * Process a complete cart payment transaction
     * This method handles the entire payment flow including:
     * 1. Creating payment record
     * 2. Creating payment items
     * 3. Creating usage tracking records
     * 4. Calculating taxes
     */
    public Payment processCartPayment(Integer customerId, List<CartItem> cartItems, 
                                    Payment.PaymentMethod paymentMethod, String notes) throws SQLException {
        
        Connection conn = null;
        try {
            conn = db.DBContext.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // 1. Validate customer exists
            Optional<Customer> customerOpt = customerDAO.findById(customerId);
            if (!customerOpt.isPresent()) {
                throw new IllegalArgumentException("Customer not found with ID: " + customerId);
            }
            
            // 2. Validate and calculate totals
            BigDecimal subtotal = BigDecimal.ZERO;
            List<PaymentItem> paymentItems = new ArrayList<>();
            
            for (CartItem cartItem : cartItems) {
                Optional<Service> serviceOpt = serviceDAO.findById(cartItem.getServiceId());
                if (!serviceOpt.isPresent()) {
                    throw new IllegalArgumentException("Service not found with ID: " + cartItem.getServiceId());
                }
                
                Service service = serviceOpt.get();
                PaymentItem paymentItem = PaymentItem.fromService(service, cartItem.getQuantity());
                paymentItems.add(paymentItem);
                
                subtotal = subtotal.add(paymentItem.getTotalPrice());
            }
            
            // 3. Calculate tax
            BigDecimal taxPercentage = getTaxPercentage();
            BigDecimal taxAmount = subtotal.multiply(taxPercentage.divide(BigDecimal.valueOf(100)));
            BigDecimal totalAmount = subtotal.add(taxAmount);
            
            // 4. Create payment record
            Payment payment = new Payment(customerId, totalAmount, subtotal, paymentMethod, 
                                        Payment.generateReferenceNumber());
            payment.setTaxAmount(taxAmount);
            payment.setNotes(notes);
            
            payment = paymentDAO.save(payment);
            
            // 5. Create payment items
            for (PaymentItem item : paymentItems) {
                item.setPaymentId(payment.getPaymentId());
            }
            paymentItems = paymentItemDAO.saveAll(paymentItems);
            
            // 6. Create usage tracking records
            for (PaymentItem item : paymentItems) {
                PaymentItemUsage usage = PaymentItemUsage.fromPaymentItem(item);
                paymentItemUsageDAO.save(usage);
            }
            
            conn.commit(); // Commit transaction
            
            LOGGER.log(Level.INFO, "Cart payment processed successfully. Payment ID: {0}, Total: {1}", 
                      new Object[]{payment.getPaymentId(), totalAmount});
            
            return payment;
            
        } catch (Exception ex) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction", rollbackEx);
                }
            }
            LOGGER.log(Level.SEVERE, "Error processing cart payment", ex);
            throw new SQLException("Failed to process cart payment: " + ex.getMessage(), ex);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ex) {
                    LOGGER.log(Level.WARNING, "Error closing connection", ex);
                }
            }
        }
    }
    
    /**
     * Book a service from a paid payment item
     */
    public Booking bookPaidService(Integer customerId, Integer paymentItemId, Integer therapistUserId,
                                 java.sql.Date appointmentDate, Time appointmentTime, String notes) throws SQLException {
        
        Connection conn = null;
        try {
            conn = db.DBContext.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // 1. Validate payment item and check remaining quantity
            Optional<PaymentItemUsage> usageOpt = paymentItemUsageDAO.findByPaymentItemId(paymentItemId);
            if (!usageOpt.isPresent()) {
                throw new IllegalArgumentException("Payment item usage not found for ID: " + paymentItemId);
            }
            
            PaymentItemUsage usage = usageOpt.get();
            if (!usage.hasRemainingQuantity()) {
                throw new IllegalArgumentException("No remaining quantity available for booking");
            }
            
            // 2. Get payment item details
            Optional<PaymentItem> paymentItemOpt = paymentItemDAO.findById(paymentItemId);
            if (!paymentItemOpt.isPresent()) {
                throw new IllegalArgumentException("Payment item not found with ID: " + paymentItemId);
            }
            
            PaymentItem paymentItem = paymentItemOpt.get();
            
            // 3. Check therapist availability
            if (!bookingDAO.isTherapistAvailable(therapistUserId, appointmentDate, 
                                               appointmentTime, paymentItem.getServiceDuration())) {
                throw new IllegalArgumentException("Therapist is not available at the requested time");
            }
            
            // 4. Create booking
            Booking booking = new Booking(customerId, paymentItemId, paymentItem.getServiceId(),
                                        therapistUserId, appointmentDate, appointmentTime, 
                                        paymentItem.getServiceDuration());
            booking.setBookingNotes(notes);
            
            booking = bookingDAO.save(booking);
            
            // 5. Update usage tracking (this will be handled by database triggers)
            // But we can also do it manually for safety
            paymentItemUsageDAO.incrementBookedQuantity(paymentItemId);
            
            conn.commit(); // Commit transaction
            
            LOGGER.log(Level.INFO, "Service booked successfully. Booking ID: {0}", booking.getBookingId());
            
            return booking;
            
        } catch (Exception ex) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction", rollbackEx);
                }
            }
            LOGGER.log(Level.SEVERE, "Error booking paid service", ex);
            throw new SQLException("Failed to book paid service: " + ex.getMessage(), ex);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ex) {
                    LOGGER.log(Level.WARNING, "Error closing connection", ex);
                }
            }
        }
    }
    
    /**
     * Cancel a booking and restore payment item usage
     */
    public boolean cancelBooking(Integer bookingId, String reason, Integer cancelledByUserId) throws SQLException {
        
        Connection conn = null;
        try {
            conn = db.DBContext.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // 1. Get booking details
            Optional<Booking> bookingOpt = bookingDAO.findById(bookingId);
            if (!bookingOpt.isPresent()) {
                throw new IllegalArgumentException("Booking not found with ID: " + bookingId);
            }
            
            Booking booking = bookingOpt.get();
            if (!booking.canBeCancelled()) {
                throw new IllegalArgumentException("Booking cannot be cancelled in current status: " + booking.getBookingStatus());
            }
            
            // 2. Cancel the booking
            boolean cancelled = bookingDAO.cancelBooking(bookingId, reason, cancelledByUserId);
            
            if (cancelled) {
                // 3. Restore payment item usage (this will be handled by database triggers)
                // But we can also do it manually for safety
                if (booking.getPaymentItemId() != null) {
                    paymentItemUsageDAO.decrementBookedQuantity(booking.getPaymentItemId());
                }
            }
            
            conn.commit(); // Commit transaction
            
            LOGGER.log(Level.INFO, "Booking cancelled successfully. Booking ID: {0}", bookingId);
            
            return cancelled;
            
        } catch (Exception ex) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction", rollbackEx);
                }
            }
            LOGGER.log(Level.SEVERE, "Error cancelling booking", ex);
            throw new SQLException("Failed to cancel booking: " + ex.getMessage(), ex);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ex) {
                    LOGGER.log(Level.WARNING, "Error closing connection", ex);
                }
            }
        }
    }

    /**
     * Get available services for booking for a customer
     */
    public List<AvailableServiceForBooking> getAvailableServicesForBooking(Integer customerId) throws SQLException {
        List<AvailableServiceForBooking> availableServices = new ArrayList<>();

        // Get all payments for customer
        List<Payment> payments = paymentDAO.findByCustomerId(customerId);

        for (Payment payment : payments) {
            if (payment.isPaid()) {
                List<PaymentItem> paymentItems = paymentItemDAO.findByPaymentId(payment.getPaymentId());

                for (PaymentItem item : paymentItems) {
                    Optional<PaymentItemUsage> usageOpt = paymentItemUsageDAO.findByPaymentItemId(item.getPaymentItemId());

                    if (usageOpt.isPresent() && usageOpt.get().hasRemainingQuantity()) {
                        Optional<Service> serviceOpt = serviceDAO.findById(item.getServiceId());

                        if (serviceOpt.isPresent()) {
                            AvailableServiceForBooking available = new AvailableServiceForBooking();
                            available.setPaymentItem(item);
                            available.setUsage(usageOpt.get());
                            available.setService(serviceOpt.get());
                            available.setPayment(payment);

                            availableServices.add(available);
                        }
                    }
                }
            }
        }

        return availableServices;
    }

    /**
     * Update payment status (e.g., after payment gateway callback)
     */
    public boolean updatePaymentStatus(String referenceNumber, Payment.PaymentStatus status) throws SQLException {
        Optional<Payment> paymentOpt = paymentDAO.findByReferenceNumber(referenceNumber);

        if (paymentOpt.isPresent()) {
            return paymentDAO.updatePaymentStatus(paymentOpt.get().getPaymentId(), status);
        }

        return false;
    }

    /**
     * Get customer payment history with booking details
     */
    public List<PaymentWithBookings> getCustomerPaymentHistory(Integer customerId) throws SQLException {
        List<PaymentWithBookings> paymentHistory = new ArrayList<>();
        List<Payment> payments = paymentDAO.findByCustomerId(customerId);

        for (Payment payment : payments) {
            PaymentWithBookings paymentWithBookings = new PaymentWithBookings();
            paymentWithBookings.setPayment(payment);

            List<PaymentItem> paymentItems = paymentItemDAO.findByPaymentId(payment.getPaymentId());
            paymentWithBookings.setPaymentItems(paymentItems);

            List<Booking> bookings = new ArrayList<>();
            for (PaymentItem item : paymentItems) {
                List<Booking> itemBookings = bookingDAO.findByPaymentItemId(item.getPaymentItemId());
                bookings.addAll(itemBookings);
            }
            paymentWithBookings.setBookings(bookings);

            paymentHistory.add(paymentWithBookings);
        }

        return paymentHistory;
    }

    /**
     * Get comprehensive dashboard statistics
     */
    public Map<String, Object> getDashboardStatistics() throws SQLException {
        Map<String, Object> dashboard = new HashMap<>();

        // Payment statistics
        Map<String, Object> paymentStats = paymentDAO.getPaymentStatistics();
        dashboard.put("payments", paymentStats);

        // Booking statistics
        Map<String, Object> bookingStats = bookingDAO.getBookingStatistics();
        dashboard.put("bookings", bookingStats);

        // Usage statistics
        Map<String, Object> usageStats = paymentItemUsageDAO.getUsageStatistics();
        dashboard.put("usage", usageStats);

        return dashboard;
    }

    /**
     * Get tax percentage from spa information
     */
    private BigDecimal getTaxPercentage() throws SQLException {
        try {
            // Assuming SpaInformationDAO has a method to get VAT percentage
            // This would need to be implemented based on your existing SpaInformation structure
            return new BigDecimal("8.00"); // Default 8% VAT as mentioned in schema
        } catch (Exception ex) {
            LOGGER.log(Level.WARNING, "Could not retrieve tax percentage, using default 8%", ex);
            return new BigDecimal("8.00");
        }
    }

    // Inner classes for data transfer

    /**
     * Represents a cart item for payment processing
     */
    public static class CartItem {
        private Integer serviceId;
        private Integer quantity;

        public CartItem() {}

        public CartItem(Integer serviceId, Integer quantity) {
            this.serviceId = serviceId;
            this.quantity = quantity;
        }

        public Integer getServiceId() { return serviceId; }
        public void setServiceId(Integer serviceId) { this.serviceId = serviceId; }

        public Integer getQuantity() { return quantity; }
        public void setQuantity(Integer quantity) { this.quantity = quantity; }
    }

    /**
     * Represents an available service for booking
     */
    public static class AvailableServiceForBooking {
        private PaymentItem paymentItem;
        private PaymentItemUsage usage;
        private Service service;
        private Payment payment;

        // Getters and setters
        public PaymentItem getPaymentItem() { return paymentItem; }
        public void setPaymentItem(PaymentItem paymentItem) { this.paymentItem = paymentItem; }

        public PaymentItemUsage getUsage() { return usage; }
        public void setUsage(PaymentItemUsage usage) { this.usage = usage; }

        public Service getService() { return service; }
        public void setService(Service service) { this.service = service; }

        public Payment getPayment() { return payment; }
        public void setPayment(Payment payment) { this.payment = payment; }
    }

    /**
     * Represents payment with associated bookings
     */
    public static class PaymentWithBookings {
        private Payment payment;
        private List<PaymentItem> paymentItems;
        private List<Booking> bookings;

        // Getters and setters
        public Payment getPayment() { return payment; }
        public void setPayment(Payment payment) { this.payment = payment; }

        public List<PaymentItem> getPaymentItems() { return paymentItems; }
        public void setPaymentItems(List<PaymentItem> paymentItems) { this.paymentItems = paymentItems; }

        public List<Booking> getBookings() { return bookings; }
        public void setBookings(List<Booking> bookings) { this.bookings = bookings; }
    }
}
