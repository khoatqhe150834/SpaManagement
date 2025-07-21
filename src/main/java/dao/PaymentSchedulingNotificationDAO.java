package dao;

import model.PaymentSchedulingNotification;
import db.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Data Access Object for payment scheduling notifications
 * Handles specialized notifications for payment-to-scheduling workflow
 * 
 * @author SpaManagement
 */
public class PaymentSchedulingNotificationDAO {
    
    private static final Logger LOGGER = Logger.getLogger(PaymentSchedulingNotificationDAO.class.getName());
    
    // SQL Queries
    private static final String INSERT_NOTIFICATION = 
        "INSERT INTO payment_scheduling_notifications (payment_id, customer_id, recipient_user_id, " +
        "notification_type, title, message, priority, related_data) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    
    private static final String SELECT_BY_ID = 
        "SELECT psn.*, c.full_name as customer_name, u.full_name as recipient_user_name, " +
        "u2.full_name as acknowledged_by_user_name " +
        "FROM payment_scheduling_notifications psn " +
        "LEFT JOIN customers c ON psn.customer_id = c.customer_id " +
        "LEFT JOIN users u ON psn.recipient_user_id = u.user_id " +
        "LEFT JOIN users u2 ON psn.acknowledged_by = u2.user_id " +
        "WHERE psn.notification_id = ?";
    
    private static final String SELECT_BY_USER_ID = 
        "SELECT psn.*, c.full_name as customer_name, u.full_name as recipient_user_name, " +
        "u2.full_name as acknowledged_by_user_name " +
        "FROM payment_scheduling_notifications psn " +
        "LEFT JOIN customers c ON psn.customer_id = c.customer_id " +
        "LEFT JOIN users u ON psn.recipient_user_id = u.user_id " +
        "LEFT JOIN users u2 ON psn.acknowledged_by = u2.user_id " +
        "WHERE psn.recipient_user_id = ? " +
        "ORDER BY psn.created_at DESC";
    
    private static final String SELECT_UNREAD_BY_USER_ID = 
        "SELECT psn.*, c.full_name as customer_name, u.full_name as recipient_user_name, " +
        "u2.full_name as acknowledged_by_user_name " +
        "FROM payment_scheduling_notifications psn " +
        "LEFT JOIN customers c ON psn.customer_id = c.customer_id " +
        "LEFT JOIN users u ON psn.recipient_user_id = u.user_id " +
        "LEFT JOIN users u2 ON psn.acknowledged_by = u2.user_id " +
        "WHERE psn.recipient_user_id = ? AND psn.is_read = 0 " +
        "ORDER BY psn.priority DESC, psn.created_at DESC";
    
    private static final String SELECT_BY_PAYMENT_ID = 
        "SELECT psn.*, c.full_name as customer_name, u.full_name as recipient_user_name, " +
        "u2.full_name as acknowledged_by_user_name " +
        "FROM payment_scheduling_notifications psn " +
        "LEFT JOIN customers c ON psn.customer_id = c.customer_id " +
        "LEFT JOIN users u ON psn.recipient_user_id = u.user_id " +
        "LEFT JOIN users u2 ON psn.acknowledged_by = u2.user_id " +
        "WHERE psn.payment_id = ? " +
        "ORDER BY psn.created_at DESC";
    
    private static final String SELECT_HIGH_PRIORITY_UNREAD = 
        "SELECT psn.*, c.full_name as customer_name, u.full_name as recipient_user_name, " +
        "u2.full_name as acknowledged_by_user_name " +
        "FROM payment_scheduling_notifications psn " +
        "LEFT JOIN customers c ON psn.customer_id = c.customer_id " +
        "LEFT JOIN users u ON psn.recipient_user_id = u.user_id " +
        "LEFT JOIN users u2 ON psn.acknowledged_by = u2.user_id " +
        "WHERE psn.is_read = 0 AND psn.priority IN ('HIGH', 'URGENT') " +
        "ORDER BY psn.priority DESC, psn.created_at DESC";
    
    private static final String UPDATE_READ_STATUS = 
        "UPDATE payment_scheduling_notifications SET is_read = 1, read_at = CURRENT_TIMESTAMP " +
        "WHERE notification_id = ?";
    
    private static final String UPDATE_ACKNOWLEDGED_STATUS = 
        "UPDATE payment_scheduling_notifications SET is_acknowledged = 1, acknowledged_at = CURRENT_TIMESTAMP, " +
        "acknowledged_by = ? WHERE notification_id = ?";
    
    private static final String UPDATE_WEBSOCKET_SENT = 
        "UPDATE payment_scheduling_notifications SET websocket_sent = 1 WHERE notification_id = ?";
    
    private static final String UPDATE_EMAIL_SENT = 
        "UPDATE payment_scheduling_notifications SET email_sent = 1 WHERE notification_id = ?";
    
    private static final String COUNT_UNREAD_BY_USER = 
        "SELECT COUNT(*) FROM payment_scheduling_notifications WHERE recipient_user_id = ? AND is_read = 0";
    
    private static final String COUNT_UNACKNOWLEDGED_BY_USER = 
        "SELECT COUNT(*) FROM payment_scheduling_notifications WHERE recipient_user_id = ? AND is_acknowledged = 0";
    
    private static final String DELETE_NOTIFICATION = 
        "DELETE FROM payment_scheduling_notifications WHERE notification_id = ?";
    
    /**
     * Create a new payment scheduling notification
     */
    public int create(PaymentSchedulingNotification notification) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_NOTIFICATION, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, notification.getPaymentId());
            stmt.setInt(2, notification.getCustomerId());
            stmt.setInt(3, notification.getRecipientUserId());
            stmt.setString(4, notification.getNotificationType());
            stmt.setString(5, notification.getTitle());
            stmt.setString(6, notification.getMessage());
            stmt.setString(7, notification.getPriority());
            stmt.setString(8, notification.getRelatedDataJson());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int notificationId = generatedKeys.getInt(1);
                        notification.setNotificationId(notificationId);
                        LOGGER.info("Created payment scheduling notification with ID: " + notificationId);
                        return notificationId;
                    }
                }
            }
            
            return 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating payment scheduling notification", e);
            return 0;
        }
    }
    
    /**
     * Find notification by ID
     */
    public PaymentSchedulingNotification findById(int notificationId) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_BY_ID)) {
            
            stmt.setInt(1, notificationId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToNotification(rs);
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding notification by ID: " + notificationId, e);
        }
        
        return null;
    }
    
    /**
     * Find notifications by user ID
     */
    public List<PaymentSchedulingNotification> findByUserId(int userId) {
        List<PaymentSchedulingNotification> notifications = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_BY_USER_ID)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapResultSetToNotification(rs));
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding notifications by user ID: " + userId, e);
        }
        
        return notifications;
    }
    
    /**
     * Find unread notifications by user ID
     */
    public List<PaymentSchedulingNotification> findUnreadByUserId(int userId) {
        List<PaymentSchedulingNotification> notifications = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_UNREAD_BY_USER_ID)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapResultSetToNotification(rs));
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding unread notifications by user ID: " + userId, e);
        }
        
        return notifications;
    }
    
    /**
     * Find notifications by payment ID
     */
    public List<PaymentSchedulingNotification> findByPaymentId(int paymentId) {
        List<PaymentSchedulingNotification> notifications = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_BY_PAYMENT_ID)) {
            
            stmt.setInt(1, paymentId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapResultSetToNotification(rs));
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding notifications by payment ID: " + paymentId, e);
        }
        
        return notifications;
    }
    
    /**
     * Find high priority unread notifications
     */
    public List<PaymentSchedulingNotification> findHighPriorityUnread() {
        List<PaymentSchedulingNotification> notifications = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_HIGH_PRIORITY_UNREAD)) {
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapResultSetToNotification(rs));
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding high priority unread notifications", e);
        }
        
        return notifications;
    }
    
    /**
     * Mark notification as read
     */
    public boolean markAsRead(int notificationId) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_READ_STATUS)) {
            
            stmt.setInt(1, notificationId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking notification as read: " + notificationId, e);
            return false;
        }
    }
    
    /**
     * Mark notification as acknowledged
     */
    public boolean markAsAcknowledged(int notificationId, int acknowledgedByUserId) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_ACKNOWLEDGED_STATUS)) {
            
            stmt.setInt(1, acknowledgedByUserId);
            stmt.setInt(2, notificationId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking notification as acknowledged: " + notificationId, e);
            return false;
        }
    }

    /**
     * Mark notification as WebSocket sent
     */
    public boolean markWebSocketSent(int notificationId) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_WEBSOCKET_SENT)) {

            stmt.setInt(1, notificationId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking notification as WebSocket sent: " + notificationId, e);
            return false;
        }
    }

    /**
     * Mark notification as email sent
     */
    public boolean markEmailSent(int notificationId) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_EMAIL_SENT)) {

            stmt.setInt(1, notificationId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking notification as email sent: " + notificationId, e);
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
     * Count unacknowledged notifications for user
     */
    public int countUnacknowledgedByUserId(int userId) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(COUNT_UNACKNOWLEDGED_BY_USER)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting unacknowledged notifications for user: " + userId, e);
        }

        return 0;
    }

    /**
     * Delete notification
     */
    public boolean delete(int notificationId) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(DELETE_NOTIFICATION)) {

            stmt.setInt(1, notificationId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting notification: " + notificationId, e);
            return false;
        }
    }

    /**
     * Map ResultSet to PaymentSchedulingNotification object
     */
    private PaymentSchedulingNotification mapResultSetToNotification(ResultSet rs) throws SQLException {
        PaymentSchedulingNotification notification = new PaymentSchedulingNotification();

        notification.setNotificationId(rs.getInt("notification_id"));
        notification.setPaymentId(rs.getInt("payment_id"));
        notification.setCustomerId(rs.getInt("customer_id"));
        notification.setRecipientUserId(rs.getInt("recipient_user_id"));
        notification.setNotificationType(rs.getString("notification_type"));
        notification.setTitle(rs.getString("title"));
        notification.setMessage(rs.getString("message"));
        notification.setPriority(rs.getString("priority"));
        notification.setIsRead(rs.getBoolean("is_read"));
        notification.setIsAcknowledged(rs.getBoolean("is_acknowledged"));
        notification.setRelatedDataJson(rs.getString("related_data"));
        notification.setWebsocketSent(rs.getBoolean("websocket_sent"));
        notification.setEmailSent(rs.getBoolean("email_sent"));
        notification.setCreatedAt(rs.getTimestamp("created_at"));
        notification.setUpdatedAt(rs.getTimestamp("updated_at"));
        notification.setReadAt(rs.getTimestamp("read_at"));
        notification.setAcknowledgedAt(rs.getTimestamp("acknowledged_at"));

        // Handle nullable acknowledged_by
        int acknowledgedBy = rs.getInt("acknowledged_by");
        if (!rs.wasNull()) {
            notification.setAcknowledgedBy(acknowledgedBy);
        }

        // Set additional fields from joins
        notification.setCustomerName(rs.getString("customer_name"));
        notification.setRecipientUserName(rs.getString("recipient_user_name"));
        notification.setAcknowledgedByUserName(rs.getString("acknowledged_by_user_name"));

        return notification;
    }
}
