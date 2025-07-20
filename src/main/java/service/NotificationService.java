package service;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.CustomerDAO;
import dao.GeneralNotificationDAO;
import dao.NotificationRecipientDAO;
import dao.UserDAO;
import model.Customer;
import model.GeneralNotification;
import model.NotificationRecipient;
import model.User;

/**
 * Service class for managing general notifications
 * Handles business logic for notification creation, delivery, and management
 * 
 * @author SpaManagement
 */
public class NotificationService {
    
    private static final Logger LOGGER = Logger.getLogger(NotificationService.class.getName());
    
    private final GeneralNotificationDAO notificationDAO;
    private final NotificationRecipientDAO recipientDAO;
    private final UserDAO userDAO;
    private final CustomerDAO customerDAO;
    
    public NotificationService() {
        this.notificationDAO = new GeneralNotificationDAO();
        this.recipientDAO = new NotificationRecipientDAO();
        this.userDAO = new UserDAO();
        this.customerDAO = new CustomerDAO();
    }
    
    /**
     * Create and send a notification to all users
     */
    public boolean createSystemAnnouncement(String title, String message, String priority, int createdByUserId) {
        try {
            GeneralNotification notification = new GeneralNotification();
            notification.setTitle(title);
            notification.setMessage(message);
            notification.setNotificationType("SYSTEM_ANNOUNCEMENT");
            notification.setPriority(priority != null ? priority : "MEDIUM");
            notification.setTargetType("ALL_USERS");
            notification.setCreatedByUserId(createdByUserId);
            notification.setIsActive(true);
            
            int notificationId = notificationDAO.create(notification);
            if (notificationId > 0) {
                return createRecipientsForAllUsers(notificationId);
            }
            
            return false;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating system announcement", e);
            return false;
        }
    }
    
    /**
     * Create a notification for specific roles
     */
    public boolean createRoleBasedNotification(String title, String message, String notificationType, 
            String priority, List<Integer> roleIds, int createdByUserId) {
        try {
            GeneralNotification notification = new GeneralNotification();
            notification.setTitle(title);
            notification.setMessage(message);
            notification.setNotificationType(notificationType);
            notification.setPriority(priority != null ? priority : "MEDIUM");
            notification.setTargetType("ROLE_BASED");
            notification.setTargetRoleIds(roleIds);
            notification.setCreatedByUserId(createdByUserId);
            notification.setIsActive(true);
            
            int notificationId = notificationDAO.create(notification);
            if (notificationId > 0) {
                return createRecipientsForRoles(notificationId, roleIds);
            }
            
            return false;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating role-based notification", e);
            return false;
        }
    }
    
    /**
     * Create a notification for specific users
     */
    public boolean createIndividualNotification(String title, String message, String notificationType, 
            String priority, List<Integer> userIds, List<Integer> customerIds, int createdByUserId) {
        try {
            GeneralNotification notification = new GeneralNotification();
            notification.setTitle(title);
            notification.setMessage(message);
            notification.setNotificationType(notificationType);
            notification.setPriority(priority != null ? priority : "MEDIUM");
            notification.setTargetType("INDIVIDUAL");
            notification.setTargetUserIds(userIds);
            notification.setTargetCustomerIds(customerIds);
            notification.setCreatedByUserId(createdByUserId);
            notification.setIsActive(true);
            
            int notificationId = notificationDAO.create(notification);
            if (notificationId > 0) {
                return createRecipientsForIndividuals(notificationId, userIds, customerIds);
            }
            
            return false;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating individual notification", e);
            return false;
        }
    }
    
    /**
     * Create a promotion notification for customers
     */
    public boolean createPromotionNotification(String title, String message, String priority, 
            String imageUrl, String actionUrl, String actionText, int createdByUserId) {
        try {
            GeneralNotification notification = new GeneralNotification();
            notification.setTitle(title);
            notification.setMessage(message);
            notification.setNotificationType("PROMOTION");
            notification.setPriority(priority != null ? priority : "MEDIUM");
            notification.setTargetType("ROLE_BASED");
            notification.setTargetRoleIds(List.of(5)); // Customer role ID
            notification.setImageUrl(imageUrl);
            notification.setActionUrl(actionUrl);
            notification.setActionText(actionText);
            notification.setCreatedByUserId(createdByUserId);
            notification.setIsActive(true);
            
            int notificationId = notificationDAO.create(notification);
            if (notificationId > 0) {
                return createRecipientsForRoles(notificationId, List.of(5));
            }
            
            return false;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating promotion notification", e);
            return false;
        }
    }
    
    /**
     * Create recipients for all users (staff and customers)
     */
    private boolean createRecipientsForAllUsers(int notificationId) {
        try {
            boolean success = true;
            
            // Create recipients for all staff users
            List<User> users = userDAO.findAll();
            for (User user : users) {
                if (user.getIsActive()) {
                    NotificationRecipient recipient = new NotificationRecipient();
                    recipient.setNotificationId(notificationId);
                    recipient.setUserId(user.getUserId());
                    recipient.setDeliveryStatus("PENDING");
                    recipient.setDeliveryMethod("WEB");
                    
                    if (recipientDAO.create(recipient) == 0) {
                        success = false;
                        LOGGER.warning("Failed to create recipient for user: " + user.getUserId());
                    }
                }
            }
            
            // Create recipients for all customers
            List<Customer> customers = customerDAO.findAll();
            for (Customer customer : customers) {
                if (customer.getIsActive()) {
                    NotificationRecipient recipient = new NotificationRecipient();
                    recipient.setNotificationId(notificationId);
                    recipient.setCustomerId(customer.getCustomerId());
                    recipient.setDeliveryStatus("PENDING");
                    recipient.setDeliveryMethod("WEB");
                    
                    if (recipientDAO.create(recipient) == 0) {
                        success = false;
                        LOGGER.warning("Failed to create recipient for customer: " + customer.getCustomerId());
                    }
                }
            }
            
            return success;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating recipients for all users", e);
            return false;
        }
    }
    
    /**
     * Create recipients for specific roles
     */
    private boolean createRecipientsForRoles(int notificationId, List<Integer> roleIds) {
        try {
            boolean success = true;
            
            for (Integer roleId : roleIds) {
                if (roleId == 5) { // Customer role
                    List<Customer> customers = customerDAO.findAll();
                    for (Customer customer : customers) {
                        if (customer.getIsActive()) {
                            NotificationRecipient recipient = new NotificationRecipient();
                            recipient.setNotificationId(notificationId);
                            recipient.setCustomerId(customer.getCustomerId());
                            recipient.setDeliveryStatus("PENDING");
                            recipient.setDeliveryMethod("WEB");
                            
                            if (recipientDAO.create(recipient) == 0) {
                                success = false;
                                LOGGER.warning("Failed to create recipient for customer: " + customer.getCustomerId());
                            }
                        }
                    }
                } else { // Staff roles
                    List<User> users = userDAO.findByRoleId(roleId, 1, 1000); // Get up to 1000 users
                    for (User user : users) {
                        if (user.getIsActive()) {
                            NotificationRecipient recipient = new NotificationRecipient();
                            recipient.setNotificationId(notificationId);
                            recipient.setUserId(user.getUserId());
                            recipient.setDeliveryStatus("PENDING");
                            recipient.setDeliveryMethod("WEB");
                            
                            if (recipientDAO.create(recipient) == 0) {
                                success = false;
                                LOGGER.warning("Failed to create recipient for user: " + user.getUserId());
                            }
                        }
                    }
                }
            }
            
            return success;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating recipients for roles", e);
            return false;
        }
    }
    
    /**
     * Create recipients for specific individuals
     */
    private boolean createRecipientsForIndividuals(int notificationId, List<Integer> userIds, List<Integer> customerIds) {
        try {
            boolean success = true;
            
            // Create recipients for specified users
            if (userIds != null) {
                for (Integer userId : userIds) {
                    NotificationRecipient recipient = new NotificationRecipient();
                    recipient.setNotificationId(notificationId);
                    recipient.setUserId(userId);
                    recipient.setDeliveryStatus("PENDING");
                    recipient.setDeliveryMethod("WEB");
                    
                    if (recipientDAO.create(recipient) == 0) {
                        success = false;
                        LOGGER.warning("Failed to create recipient for user: " + userId);
                    }
                }
            }
            
            // Create recipients for specified customers
            if (customerIds != null) {
                for (Integer customerId : customerIds) {
                    NotificationRecipient recipient = new NotificationRecipient();
                    recipient.setNotificationId(notificationId);
                    recipient.setCustomerId(customerId);
                    recipient.setDeliveryStatus("PENDING");
                    recipient.setDeliveryMethod("WEB");
                    
                    if (recipientDAO.create(recipient) == 0) {
                        success = false;
                        LOGGER.warning("Failed to create recipient for customer: " + customerId);
                    }
                }
            }
            
            return success;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating recipients for individuals", e);
            return false;
        }
    }

    /**
     * Get notifications for a user with read status
     */
    public List<GeneralNotification> getNotificationsForUser(int userId, boolean unreadOnly) {
        try {
            List<NotificationRecipient> recipients;
            if (unreadOnly) {
                recipients = recipientDAO.findUnreadByUserId(userId);
            } else {
                recipients = recipientDAO.findByUserId(userId);
            }

            List<GeneralNotification> notifications = new ArrayList<>();
            for (NotificationRecipient recipient : recipients) {
                GeneralNotification notification = notificationDAO.findById(recipient.getNotificationId());
                if (notification != null && notification.isCurrentlyActive()) {
                    notification.setIsReadByCurrentUser(recipient.getIsRead());
                    notification.setIsDismissedByCurrentUser(recipient.getIsDismissed());
                    notifications.add(notification);
                }
            }

            return notifications;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting notifications for user: " + userId, e);
            return new ArrayList<>();
        }
    }

    /**
     * Get notifications for a customer with read status
     */
    public List<GeneralNotification> getNotificationsForCustomer(int customerId, boolean unreadOnly) {
        try {
            List<NotificationRecipient> recipients;
            if (unreadOnly) {
                recipients = recipientDAO.findUnreadByCustomerId(customerId);
            } else {
                recipients = recipientDAO.findByCustomerId(customerId);
            }

            List<GeneralNotification> notifications = new ArrayList<>();
            for (NotificationRecipient recipient : recipients) {
                GeneralNotification notification = notificationDAO.findById(recipient.getNotificationId());
                if (notification != null && notification.isCurrentlyActive()) {
                    notification.setIsReadByCurrentUser(recipient.getIsRead());
                    notification.setIsDismissedByCurrentUser(recipient.getIsDismissed());
                    notifications.add(notification);
                }
            }

            return notifications;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting notifications for customer: " + customerId, e);
            return new ArrayList<>();
        }
    }

    /**
     * Mark notification as read for a user
     */
    public boolean markAsReadForUser(int notificationId, int userId) {
        try {
            List<NotificationRecipient> recipients = recipientDAO.findByNotificationId(notificationId);
            for (NotificationRecipient recipient : recipients) {
                if (recipient.getUserId() != null && recipient.getUserId().equals(userId)) {
                    return recipientDAO.markAsRead(recipient.getRecipientId());
                }
            }
            return false;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error marking notification as read for user", e);
            return false;
        }
    }

    /**
     * Mark notification as read for a customer
     */
    public boolean markAsReadForCustomer(int notificationId, int customerId) {
        try {
            List<NotificationRecipient> recipients = recipientDAO.findByNotificationId(notificationId);
            for (NotificationRecipient recipient : recipients) {
                if (recipient.getCustomerId() != null && recipient.getCustomerId().equals(customerId)) {
                    return recipientDAO.markAsRead(recipient.getRecipientId());
                }
            }
            return false;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error marking notification as read for customer", e);
            return false;
        }
    }

    /**
     * Mark notification as dismissed for a user
     */
    public boolean markAsDismissedForUser(int notificationId, int userId) {
        try {
            List<NotificationRecipient> recipients = recipientDAO.findByNotificationId(notificationId);
            for (NotificationRecipient recipient : recipients) {
                if (recipient.getUserId() != null && recipient.getUserId().equals(userId)) {
                    return recipientDAO.markAsDismissed(recipient.getRecipientId());
                }
            }
            return false;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error marking notification as dismissed for user", e);
            return false;
        }
    }

    /**
     * Mark notification as dismissed for a customer
     */
    public boolean markAsDismissedForCustomer(int notificationId, int customerId) {
        try {
            List<NotificationRecipient> recipients = recipientDAO.findByNotificationId(notificationId);
            for (NotificationRecipient recipient : recipients) {
                if (recipient.getCustomerId() != null && recipient.getCustomerId().equals(customerId)) {
                    return recipientDAO.markAsDismissed(recipient.getRecipientId());
                }
            }
            return false;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error marking notification as dismissed for customer", e);
            return false;
        }
    }

    /**
     * Get unread notification count for user
     */
    public int getUnreadCountForUser(int userId) {
        try {
            return recipientDAO.countUnreadByUserId(userId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting unread count for user: " + userId, e);
            return 0;
        }
    }

    /**
     * Get unread notification count for customer
     */
    public int getUnreadCountForCustomer(int customerId) {
        try {
            return recipientDAO.countUnreadByCustomerId(customerId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting unread count for customer: " + customerId, e);
            return 0;
        }
    }

    /**
     * Get all active notifications (for admin management)
     */
    public List<GeneralNotification> getAllActiveNotifications() {
        try {
            return notificationDAO.findActiveNotifications();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting all active notifications", e);
            return new ArrayList<>();
        }
    }

    /**
     * Get notifications with pagination (for admin management)
     */
    public List<GeneralNotification> getNotificationsWithPagination(int page, int pageSize) {
        try {
            return notificationDAO.findWithPagination(page, pageSize);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting notifications with pagination", e);
            return new ArrayList<>();
        }
    }

    /**
     * Update notification
     */
    public boolean updateNotification(GeneralNotification notification) {
        try {
            return notificationDAO.update(notification);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating notification", e);
            return false;
        }
    }

    /**
     * Delete notification
     */
    public boolean deleteNotification(int notificationId) {
        try {
            return notificationDAO.delete(notificationId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting notification", e);
            return false;
        }
    }

    /**
     * Get notification by ID
     */
    public GeneralNotification getNotificationById(int notificationId) {
        try {
            return notificationDAO.findById(notificationId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting notification by ID", e);
            return null;
        }
    }
}
