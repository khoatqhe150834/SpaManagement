package service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.BookingDAO;
import dao.CustomerDAO;
import dao.PaymentDAO;
import dao.PaymentItemDAO;
import dao.PaymentSchedulingNotificationDAO;
import dao.ServiceDAO;
import dao.UserDAO;
import model.Booking;
import model.Customer;
import model.Payment;
import model.PaymentItem;
import model.PaymentSchedulingNotification;
import model.Service;
import model.User;

/**
 * Service class for payment scheduling workflow
 * Handles business logic for payment-to-scheduling notifications and booking creation
 * 
 * @author SpaManagement
 */
public class PaymentSchedulingService {
    
    private static final Logger LOGGER = Logger.getLogger(PaymentSchedulingService.class.getName());
    
    private final PaymentSchedulingNotificationDAO notificationDAO;
    private final PaymentDAO paymentDAO;
    private final PaymentItemDAO paymentItemDAO;
    private final BookingDAO bookingDAO;
    private final CustomerDAO customerDAO;
    private final UserDAO userDAO;
    private final ServiceDAO serviceDAO;
    
    public PaymentSchedulingService() {
        this.notificationDAO = new PaymentSchedulingNotificationDAO();
        this.paymentDAO = new PaymentDAO();
        this.paymentItemDAO = new PaymentItemDAO();
        this.bookingDAO = new BookingDAO();
        this.customerDAO = new CustomerDAO();
        this.userDAO = new UserDAO();
        this.serviceDAO = new ServiceDAO();
    }
    
    /**
     * Create notifications when payment is completed
     * This method should be called when payment status changes to PAID
     */
    public boolean createPaymentCompletedNotifications(int paymentId) {
        try {
            Optional<Payment> paymentOptional = paymentDAO.findById(paymentId);
            if (paymentOptional.isEmpty()) {
                LOGGER.warning("Payment not found: " + paymentId);
                return false;
            }
            Payment payment = paymentOptional.get();
            
            // Only create notifications for PAID payments
            if (!"PAID".equals(payment.getPaymentStatus())) {
                LOGGER.info("Payment not in PAID status, skipping notification creation: " + paymentId);
                return false;
            }
            
            Optional<Customer> customerOptional = customerDAO.findById(payment.getCustomerId());
            if (customerOptional.isEmpty()) {
                LOGGER.warning("Customer not found: " + payment.getCustomerId());
                return false;
            }
            Customer customer = customerOptional.get();
            
            // Get payment items to build service information
            List<PaymentItem> paymentItems = paymentItemDAO.findByPaymentId(paymentId);
            if (paymentItems.isEmpty()) {
                LOGGER.warning("No payment items found for payment: " + paymentId);
                return false;
            }
            
            // Build service list and count
            StringBuilder serviceListBuilder = new StringBuilder();
            int serviceCount = 0;
            for (PaymentItem item : paymentItems) {
                Optional<Service> serviceOptional = serviceDAO.findById(item.getServiceId());
                if (serviceOptional.isPresent()) {
                    Service service = serviceOptional.get();
                    if (serviceListBuilder.length() > 0) {
                        serviceListBuilder.append(", ");
                    }
                    serviceListBuilder.append(service.getName());
                    if (item.getQuantity() > 1) {
                        serviceListBuilder.append(" (x").append(item.getQuantity()).append(")");
                    }
                    serviceCount += item.getQuantity();
                }
            }
            
            String serviceList = serviceListBuilder.toString();
            
            // Create notifications for all managers and admins
            return createNotificationsForManagers(
                paymentId, 
                payment.getCustomerId(), 
                customer.getFullName(),
                payment.getTotalAmount().doubleValue(),
                payment.getPaymentMethod().name(),
                serviceCount,
                serviceList,
                payment.getReferenceNumber()
            );
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating payment completed notifications for payment: " + paymentId, e);
            return false;
        }
    }
    
    /**
     * Create notifications for all managers and admins
     */
    private boolean createNotificationsForManagers(int paymentId, int customerId, String customerName, 
            double paymentAmount, String paymentMethod, int serviceCount, String serviceList, String referenceNumber) {
        
        try {
            // Get all managers and admins
            List<User> managers = userDAO.findByRoleId(1, 1, 100); // Admin
            List<User> managerRole = userDAO.findByRoleId(2, 1, 100); // Manager
            managers.addAll(managerRole);
            
            if (managers.isEmpty()) {
                LOGGER.warning("No managers or admins found to send notifications");
                return false;
            }
            
            String title = "Thanh toán hoàn tất - " + customerName;
            String message = String.format(
                "Khách hàng %s đã thanh toán thành công số tiền %,.0f VND cho %d dịch vụ (%s). " +
                "Vui lòng lên lịch hẹn cho khách hàng.",
                customerName, paymentAmount, serviceCount, serviceList
            );
            
            String relatedDataJson = String.format(
                "{\"payment_amount\": %.2f, \"payment_method\": \"%s\", \"service_count\": %d, " +
                "\"service_list\": \"%s\", \"reference_number\": \"%s\", \"customer_name\": \"%s\"}",
                paymentAmount, paymentMethod, serviceCount, serviceList, referenceNumber, customerName
            );
            
            boolean success = true;
            for (User manager : managers) {
                if (manager.getIsActive()) {
                    PaymentSchedulingNotification notification = new PaymentSchedulingNotification();
                    notification.setPaymentId(paymentId);
                    notification.setCustomerId(customerId);
                    notification.setRecipientUserId(manager.getUserId());
                    notification.setNotificationType("PAYMENT_COMPLETED");
                    notification.setTitle(title);
                    notification.setMessage(message);
                    notification.setPriority("HIGH");
                    notification.setRelatedDataJson(relatedDataJson);
                    
                    if (notificationDAO.create(notification) == 0) {
                        success = false;
                        LOGGER.warning("Failed to create notification for manager: " + manager.getUserId());
                    }
                }
            }
            
            return success;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating notifications for managers", e);
            return false;
        }
    }
    
    /**
     * Get notifications for a manager/admin user
     */
    public List<PaymentSchedulingNotification> getNotificationsForUser(int userId, boolean unreadOnly) {
        try {
            if (unreadOnly) {
                return notificationDAO.findUnreadByUserId(userId);
            } else {
                return notificationDAO.findByUserId(userId);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting notifications for user: " + userId, e);
            return new ArrayList<>();
        }
    }
    
    /**
     * Get unread notification count for user
     */
    public int getUnreadCountForUser(int userId) {
        try {
            return notificationDAO.countUnreadByUserId(userId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting unread count for user: " + userId, e);
            return 0;
        }
    }
    
    /**
     * Get unacknowledged notification count for user
     */
    public int getUnacknowledgedCountForUser(int userId) {
        try {
            return notificationDAO.countUnacknowledgedByUserId(userId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting unacknowledged count for user: " + userId, e);
            return 0;
        }
    }
    
    /**
     * Mark notification as read
     */
    public boolean markAsRead(int notificationId) {
        try {
            return notificationDAO.markAsRead(notificationId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error marking notification as read: " + notificationId, e);
            return false;
        }
    }
    
    /**
     * Mark notification as acknowledged (handled)
     */
    public boolean markAsAcknowledged(int notificationId, int acknowledgedByUserId) {
        try {
            return notificationDAO.markAsAcknowledged(notificationId, acknowledgedByUserId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error marking notification as acknowledged: " + notificationId, e);
            return false;
        }
    }
    
    /**
     * Get notification by ID
     */
    public PaymentSchedulingNotification getNotificationById(int notificationId) {
        try {
            return notificationDAO.findById(notificationId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting notification by ID: " + notificationId, e);
            return null;
        }
    }
    
    /**
     * Get notifications by payment ID
     */
    public List<PaymentSchedulingNotification> getNotificationsByPaymentId(int paymentId) {
        try {
            return notificationDAO.findByPaymentId(paymentId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting notifications by payment ID: " + paymentId, e);
            return new ArrayList<>();
        }
    }
    
    /**
     * Get high priority unread notifications
     */
    public List<PaymentSchedulingNotification> getHighPriorityUnreadNotifications() {
        try {
            return notificationDAO.findHighPriorityUnread();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting high priority unread notifications", e);
            return new ArrayList<>();
        }
    }
    
    /**
     * Create booking from payment item
     * This method is called when manager schedules a service from a payment
     */
    public boolean createBookingFromPaymentItem(int paymentItemId, int therapistUserId, 
            String appointmentDate, String appointmentTime, int roomId, Integer bedId, String notes) {
        try {
            Optional<PaymentItem> paymentItemOptional = paymentItemDAO.findById(paymentItemId);
            if (paymentItemOptional.isEmpty()) {
                LOGGER.warning("Payment item not found: " + paymentItemId);
                return false;
            }
            PaymentItem paymentItem = paymentItemOptional.get();

            Optional<Payment> paymentOptional = paymentDAO.findById(paymentItem.getPaymentId());
            if (paymentOptional.isEmpty()) {
                LOGGER.warning("Payment not found: " + paymentItem.getPaymentId());
                return false;
            }
            Payment payment = paymentOptional.get();
            
            // Create booking
            Booking booking = new Booking();
            booking.setCustomerId(payment.getCustomerId());
            booking.setPaymentItemId(paymentItemId);
            booking.setServiceId(paymentItem.getServiceId());
            booking.setTherapistUserId(therapistUserId);
            booking.setAppointmentDate(java.sql.Date.valueOf(appointmentDate));
            booking.setAppointmentTime(java.sql.Time.valueOf(appointmentTime + ":00"));
            booking.setDurationMinutes(paymentItem.getServiceDuration());
            booking.setBookingStatus(Booking.BookingStatus.SCHEDULED);
            booking.setBookingNotes(notes);
            booking.setRoomId(roomId);
            booking.setBedId(bedId);
            
            Booking savedBooking = bookingDAO.save(booking);
            if (savedBooking != null && savedBooking.getBookingId() != null) {
                LOGGER.info("Created booking " + savedBooking.getBookingId() + " from payment item " + paymentItemId);
                return true;
            }
            
            return false;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating booking from payment item: " + paymentItemId, e);
            return false;
        }
    }
    
    /**
     * Check if payment has any unscheduled services
     */
    public boolean hasUnscheduledServices(int paymentId) {
        try {
            List<PaymentItem> paymentItems = paymentItemDAO.findByPaymentId(paymentId);
            for (PaymentItem item : paymentItems) {
                // Check if this payment item has any bookings
                List<Booking> bookings = bookingDAO.findByPaymentItemId(item.getPaymentItemId());
                if (bookings.size() < item.getQuantity()) {
                    return true; // Has unscheduled services
                }
            }
            return false; // All services are scheduled
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking unscheduled services for payment: " + paymentId, e);
            return true; // Assume there are unscheduled services on error
        }
    }
    
    /**
     * Get payment details for scheduling interface
     */
    public Payment getPaymentForScheduling(int paymentId) {
        try {
            Optional<Payment> paymentOptional = paymentDAO.findById(paymentId);
            if (paymentOptional.isPresent()) {
                Payment payment = paymentOptional.get();
                if (Payment.PaymentStatus.PAID.equals(payment.getPaymentStatus())) {
                    return payment;
                }
            }
            return null;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting payment for scheduling: " + paymentId, e);
            return null;
        }
    }
}
