package dao;

import model.NotificationRecipient;
import db.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Data Access Object for notification recipients
 * Handles read/delivery status tracking for notifications
 * 
 * @author SpaManagement
 */
public class NotificationRecipientDAO {
    
    private static final Logger LOGGER = Logger.getLogger(NotificationRecipientDAO.class.getName());
    
    // SQL Queries
    private static final String INSERT_RECIPIENT = 
        "INSERT INTO notification_recipients (notification_id, user_id, customer_id, " +
        "delivery_status, delivery_method) VALUES (?, ?, ?, ?, ?)";
    
    private static final String SELECT_BY_ID = 
        "SELECT nr.*, u.full_name as user_name, c.full_name as customer_name, " +
        "gn.title as notification_title, gn.notification_type, gn.priority " +
        "FROM notification_recipients nr " +
        "LEFT JOIN users u ON nr.user_id = u.user_id " +
        "LEFT JOIN customers c ON nr.customer_id = c.customer_id " +
        "LEFT JOIN general_notifications gn ON nr.notification_id = gn.notification_id " +
        "WHERE nr.recipient_id = ?";
    
    private static final String SELECT_BY_NOTIFICATION_ID = 
        "SELECT nr.*, u.full_name as user_name, c.full_name as customer_name, " +
        "gn.title as notification_title, gn.notification_type, gn.priority " +
        "FROM notification_recipients nr " +
        "LEFT JOIN users u ON nr.user_id = u.user_id " +
        "LEFT JOIN customers c ON nr.customer_id = c.customer_id " +
        "LEFT JOIN general_notifications gn ON nr.notification_id = gn.notification_id " +
        "WHERE nr.notification_id = ?";
    
    private static final String SELECT_BY_USER_ID = 
        "SELECT nr.*, u.full_name as user_name, c.full_name as customer_name, " +
        "gn.title as notification_title, gn.notification_type, gn.priority " +
        "FROM notification_recipients nr " +
        "LEFT JOIN users u ON nr.user_id = u.user_id " +
        "LEFT JOIN customers c ON nr.customer_id = c.customer_id " +
        "LEFT JOIN general_notifications gn ON nr.notification_id = gn.notification_id " +
        "WHERE nr.user_id = ? ORDER BY nr.created_at DESC";
    
    private static final String SELECT_BY_CUSTOMER_ID = 
        "SELECT nr.*, u.full_name as user_name, c.full_name as customer_name, " +
        "gn.title as notification_title, gn.notification_type, gn.priority " +
        "FROM notification_recipients nr " +
        "LEFT JOIN users u ON nr.user_id = u.user_id " +
        "LEFT JOIN customers c ON nr.customer_id = c.customer_id " +
        "LEFT JOIN general_notifications gn ON nr.notification_id = gn.notification_id " +
        "WHERE nr.customer_id = ? ORDER BY nr.created_at DESC";
    
    private static final String SELECT_UNREAD_BY_USER = 
        "SELECT nr.*, u.full_name as user_name, c.full_name as customer_name, " +
        "gn.title as notification_title, gn.notification_type, gn.priority " +
        "FROM notification_recipients nr " +
        "LEFT JOIN users u ON nr.user_id = u.user_id " +
        "LEFT JOIN customers c ON nr.customer_id = c.customer_id " +
        "LEFT JOIN general_notifications gn ON nr.notification_id = gn.notification_id " +
        "WHERE nr.user_id = ? AND nr.is_read = 0 ORDER BY nr.created_at DESC";
    
    private static final String SELECT_UNREAD_BY_CUSTOMER = 
        "SELECT nr.*, u.full_name as user_name, c.full_name as customer_name, " +
        "gn.title as notification_title, gn.notification_type, gn.priority " +
        "FROM notification_recipients nr " +
        "LEFT JOIN users u ON nr.user_id = u.user_id " +
        "LEFT JOIN customers c ON nr.customer_id = c.customer_id " +
        "LEFT JOIN general_notifications gn ON nr.notification_id = gn.notification_id " +
        "WHERE nr.customer_id = ? AND nr.is_read = 0 ORDER BY nr.created_at DESC";
    
    private static final String UPDATE_READ_STATUS = 
        "UPDATE notification_recipients SET is_read = 1, read_at = CURRENT_TIMESTAMP " +
        "WHERE recipient_id = ?";
    
    private static final String UPDATE_DISMISSED_STATUS = 
        "UPDATE notification_recipients SET is_dismissed = 1, dismissed_at = CURRENT_TIMESTAMP " +
        "WHERE recipient_id = ?";
    
    private static final String UPDATE_DELIVERY_STATUS = 
        "UPDATE notification_recipients SET delivery_status = ? " +
        "WHERE recipient_id = ?";
    
    private static final String COUNT_UNREAD_BY_USER = 
        "SELECT COUNT(*) FROM notification_recipients WHERE user_id = ? AND is_read = 0";
    
    private static final String COUNT_UNREAD_BY_CUSTOMER = 
        "SELECT COUNT(*) FROM notification_recipients WHERE customer_id = ? AND is_read = 0";
    
    private static final String DELETE_RECIPIENT = 
        "DELETE FROM notification_recipients WHERE recipient_id = ?";
    
    /**
     * Create a new notification recipient
     */
    public int create(NotificationRecipient recipient) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_RECIPIENT, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, recipient.getNotificationId());
            
            if (recipient.getUserId() != null) {
                stmt.setInt(2, recipient.getUserId());
                stmt.setNull(3, Types.INTEGER);
            } else {
                stmt.setNull(2, Types.INTEGER);
                stmt.setInt(3, recipient.getCustomerId());
            }
            
            stmt.setString(4, recipient.getDeliveryStatus() != null ? recipient.getDeliveryStatus() : "PENDING");
            stmt.setString(5, recipient.getDeliveryMethod() != null ? recipient.getDeliveryMethod() : "WEB");
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int recipientId = generatedKeys.getInt(1);
                        recipient.setRecipientId(recipientId);
                        LOGGER.info("Created notification recipient with ID: " + recipientId);
                        return recipientId;
                    }
                }
            }
            
            return 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating notification recipient", e);
            return 0;
        }
    }
    
    /**
     * Find recipient by ID
     */
    public NotificationRecipient findById(int recipientId) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_BY_ID)) {
            
            stmt.setInt(1, recipientId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToRecipient(rs);
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding recipient by ID: " + recipientId, e);
        }
        
        return null;
    }
    
    /**
     * Find recipients by notification ID
     */
    public List<NotificationRecipient> findByNotificationId(int notificationId) {
        List<NotificationRecipient> recipients = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_BY_NOTIFICATION_ID)) {
            
            stmt.setInt(1, notificationId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    recipients.add(mapResultSetToRecipient(rs));
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding recipients by notification ID: " + notificationId, e);
        }
        
        return recipients;
    }
    
    /**
     * Find recipients by user ID
     */
    public List<NotificationRecipient> findByUserId(int userId) {
        List<NotificationRecipient> recipients = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_BY_USER_ID)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    recipients.add(mapResultSetToRecipient(rs));
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding recipients by user ID: " + userId, e);
        }
        
        return recipients;
    }
    
    /**
     * Find recipients by customer ID
     */
    public List<NotificationRecipient> findByCustomerId(int customerId) {
        List<NotificationRecipient> recipients = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_BY_CUSTOMER_ID)) {
            
            stmt.setInt(1, customerId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    recipients.add(mapResultSetToRecipient(rs));
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding recipients by customer ID: " + customerId, e);
        }
        
        return recipients;
    }
    
    /**
     * Find unread notifications for user
     */
    public List<NotificationRecipient> findUnreadByUserId(int userId) {
        List<NotificationRecipient> recipients = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_UNREAD_BY_USER)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    recipients.add(mapResultSetToRecipient(rs));
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding unread notifications for user: " + userId, e);
        }
        
        return recipients;
    }
    
    /**
     * Find unread notifications for customer
     */
    public List<NotificationRecipient> findUnreadByCustomerId(int customerId) {
        List<NotificationRecipient> recipients = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_UNREAD_BY_CUSTOMER)) {
            
            stmt.setInt(1, customerId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    recipients.add(mapResultSetToRecipient(rs));
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding unread notifications for customer: " + customerId, e);
        }
        
        return recipients;
    }

    /**
     * Mark notification as read
     */
    public boolean markAsRead(int recipientId) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_READ_STATUS)) {

            stmt.setInt(1, recipientId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking notification as read: " + recipientId, e);
            return false;
        }
    }

    /**
     * Mark notification as dismissed
     */
    public boolean markAsDismissed(int recipientId) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_DISMISSED_STATUS)) {

            stmt.setInt(1, recipientId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking notification as dismissed: " + recipientId, e);
            return false;
        }
    }

    /**
     * Update delivery status
     */
    public boolean updateDeliveryStatus(int recipientId, String deliveryStatus) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_DELIVERY_STATUS)) {

            stmt.setString(1, deliveryStatus);
            stmt.setInt(2, recipientId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating delivery status: " + recipientId, e);
            return false;
        }
    }

    /**
     * Count unread notifications for user
     */
    public int countUnreadByUserId(int userId) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(COUNT_UNREAD_BY_USER)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting unread notifications for user: " + userId, e);
        }

        return 0;
    }

    /**
     * Count unread notifications for customer
     */
    public int countUnreadByCustomerId(int customerId) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(COUNT_UNREAD_BY_CUSTOMER)) {

            stmt.setInt(1, customerId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting unread notifications for customer: " + customerId, e);
        }

        return 0;
    }

    /**
     * Delete recipient
     */
    public boolean delete(int recipientId) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(DELETE_RECIPIENT)) {

            stmt.setInt(1, recipientId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting recipient: " + recipientId, e);
            return false;
        }
    }

    /**
     * Map ResultSet to NotificationRecipient object
     */
    private NotificationRecipient mapResultSetToRecipient(ResultSet rs) throws SQLException {
        NotificationRecipient recipient = new NotificationRecipient();

        recipient.setRecipientId(rs.getInt("recipient_id"));
        recipient.setNotificationId(rs.getInt("notification_id"));

        // Handle nullable user_id and customer_id
        int userId = rs.getInt("user_id");
        if (!rs.wasNull()) {
            recipient.setUserId(userId);
        }

        int customerId = rs.getInt("customer_id");
        if (!rs.wasNull()) {
            recipient.setCustomerId(customerId);
        }

        recipient.setIsRead(rs.getBoolean("is_read"));
        recipient.setReadAt(rs.getTimestamp("read_at"));
        recipient.setIsDismissed(rs.getBoolean("is_dismissed"));
        recipient.setDismissedAt(rs.getTimestamp("dismissed_at"));
        recipient.setDeliveryStatus(rs.getString("delivery_status"));
        recipient.setDeliveryMethod(rs.getString("delivery_method"));
        recipient.setCreatedAt(rs.getTimestamp("created_at"));
        recipient.setUpdatedAt(rs.getTimestamp("updated_at"));

        // Set additional fields from joins
        recipient.setUserName(rs.getString("user_name"));
        recipient.setCustomerName(rs.getString("customer_name"));
        recipient.setNotificationTitle(rs.getString("notification_title"));
        recipient.setNotificationType(rs.getString("notification_type"));
        recipient.setPriority(rs.getString("priority"));

        return recipient;
    }
}
