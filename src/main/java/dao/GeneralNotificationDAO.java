package dao;

import model.GeneralNotification;
import db.DBContext;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Data Access Object for general notifications
 * Handles all database operations for the notification system
 * 
 * @author SpaManagement
 */
public class GeneralNotificationDAO {
    
    private static final Logger LOGGER = Logger.getLogger(GeneralNotificationDAO.class.getName());
    private final Gson gson = new Gson();
    
    // SQL Queries for notifications
    private static final String INSERT_NOTIFICATION = 
        "INSERT INTO general_notifications (title, message, notification_type, priority, target_type, " +
        "target_role_ids, target_user_ids, target_customer_ids, image_url, attachment_url, " +
        "action_url, action_text, is_active, start_date, end_date, created_by_user_id) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    private static final String SELECT_BY_ID = 
        "SELECT gn.*, u.full_name as created_by_user_name " +
        "FROM general_notifications gn " +
        "LEFT JOIN users u ON gn.created_by_user_id = u.user_id " +
        "WHERE gn.notification_id = ?";
    
    private static final String SELECT_ACTIVE_NOTIFICATIONS = 
        "SELECT gn.*, u.full_name as created_by_user_name " +
        "FROM general_notifications gn " +
        "LEFT JOIN users u ON gn.created_by_user_id = u.user_id " +
        "WHERE gn.is_active = 1 " +
        "AND (gn.start_date IS NULL OR gn.start_date <= NOW()) " +
        "AND (gn.end_date IS NULL OR gn.end_date >= NOW()) " +
        "ORDER BY gn.priority DESC, gn.created_at DESC";
    
    private static final String SELECT_ALL_PAGINATED = 
        "SELECT gn.*, u.full_name as created_by_user_name " +
        "FROM general_notifications gn " +
        "LEFT JOIN users u ON gn.created_by_user_id = u.user_id " +
        "ORDER BY gn.created_at DESC " +
        "LIMIT ? OFFSET ?";
    
    private static final String SELECT_BY_TYPE = 
        "SELECT gn.*, u.full_name as created_by_user_name " +
        "FROM general_notifications gn " +
        "LEFT JOIN users u ON gn.created_by_user_id = u.user_id " +
        "WHERE gn.notification_type = ? " +
        "ORDER BY gn.created_at DESC";
    
    private static final String SELECT_BY_PRIORITY = 
        "SELECT gn.*, u.full_name as created_by_user_name " +
        "FROM general_notifications gn " +
        "LEFT JOIN users u ON gn.created_by_user_id = u.user_id " +
        "WHERE gn.priority = ? " +
        "ORDER BY gn.created_at DESC";
    
    private static final String UPDATE_NOTIFICATION = 
        "UPDATE general_notifications SET title = ?, message = ?, notification_type = ?, " +
        "priority = ?, target_type = ?, target_role_ids = ?, target_user_ids = ?, " +
        "target_customer_ids = ?, image_url = ?, attachment_url = ?, action_url = ?, " +
        "action_text = ?, is_active = ?, start_date = ?, end_date = ? " +
        "WHERE notification_id = ?";
    
    private static final String DELETE_NOTIFICATION = 
        "DELETE FROM general_notifications WHERE notification_id = ?";
    
    private static final String COUNT_ALL = 
        "SELECT COUNT(*) FROM general_notifications";
    
    private static final String COUNT_BY_TYPE = 
        "SELECT COUNT(*) FROM general_notifications WHERE notification_type = ?";
    
    private static final String COUNT_ACTIVE = 
        "SELECT COUNT(*) FROM general_notifications WHERE is_active = 1 " +
        "AND (start_date IS NULL OR start_date <= NOW()) " +
        "AND (end_date IS NULL OR end_date >= NOW())";
    
    /**
     * Create a new notification
     */
    public int create(GeneralNotification notification) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_NOTIFICATION, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, notification.getTitle());
            stmt.setString(2, notification.getMessage());
            stmt.setString(3, notification.getNotificationType());
            stmt.setString(4, notification.getPriority());
            stmt.setString(5, notification.getTargetType());
            
            // Convert lists to JSON
            stmt.setString(6, notification.getTargetRoleIds() != null ? gson.toJson(notification.getTargetRoleIds()) : null);
            stmt.setString(7, notification.getTargetUserIds() != null ? gson.toJson(notification.getTargetUserIds()) : null);
            stmt.setString(8, notification.getTargetCustomerIds() != null ? gson.toJson(notification.getTargetCustomerIds()) : null);
            
            stmt.setString(9, notification.getImageUrl());
            stmt.setString(10, notification.getAttachmentUrl());
            stmt.setString(11, notification.getActionUrl());
            stmt.setString(12, notification.getActionText());
            stmt.setBoolean(13, notification.getIsActive());
            stmt.setTimestamp(14, notification.getStartDate());
            stmt.setTimestamp(15, notification.getEndDate());
            stmt.setInt(16, notification.getCreatedByUserId());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int notificationId = generatedKeys.getInt(1);
                        notification.setNotificationId(notificationId);
                        LOGGER.info("Created notification with ID: " + notificationId);
                        return notificationId;
                    }
                }
            }
            
            return 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating notification", e);
            return 0;
        }
    }
    
    /**
     * Find notification by ID
     */
    public GeneralNotification findById(int notificationId) {
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
     * Find all active notifications
     */
    public List<GeneralNotification> findActiveNotifications() {
        List<GeneralNotification> notifications = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ACTIVE_NOTIFICATIONS)) {
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapResultSetToNotification(rs));
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding active notifications", e);
        }
        
        return notifications;
    }
    
    /**
     * Find notifications with pagination
     */
    public List<GeneralNotification> findWithPagination(int page, int pageSize) {
        List<GeneralNotification> notifications = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ALL_PAGINATED)) {

            stmt.setInt(1, pageSize);
            stmt.setInt(2, offset);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapResultSetToNotification(rs));
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding notifications with pagination", e);
        }

        return notifications;
    }

    /**
     * Find notifications by type
     */
    public List<GeneralNotification> findByType(String notificationType) {
        List<GeneralNotification> notifications = new ArrayList<>();

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_BY_TYPE)) {

            stmt.setString(1, notificationType);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapResultSetToNotification(rs));
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding notifications by type: " + notificationType, e);
        }

        return notifications;
    }

    /**
     * Find notifications by priority
     */
    public List<GeneralNotification> findByPriority(String priority) {
        List<GeneralNotification> notifications = new ArrayList<>();

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_BY_PRIORITY)) {
            
            stmt.setString(1, priority);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapResultSetToNotification(rs));
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding notifications by priority: " + priority, e);
        }
        
        return notifications;
    }
    
    /**
     * Update notification
     */
    public boolean update(GeneralNotification notification) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_NOTIFICATION)) {
            
            stmt.setString(1, notification.getTitle());
            stmt.setString(2, notification.getMessage());
            stmt.setString(3, notification.getNotificationType());
            stmt.setString(4, notification.getPriority());
            stmt.setString(5, notification.getTargetType());
            
            // Convert lists to JSON
            stmt.setString(6, notification.getTargetRoleIds() != null ? gson.toJson(notification.getTargetRoleIds()) : null);
            stmt.setString(7, notification.getTargetUserIds() != null ? gson.toJson(notification.getTargetUserIds()) : null);
            stmt.setString(8, notification.getTargetCustomerIds() != null ? gson.toJson(notification.getTargetCustomerIds()) : null);
            
            stmt.setString(9, notification.getImageUrl());
            stmt.setString(10, notification.getAttachmentUrl());
            stmt.setString(11, notification.getActionUrl());
            stmt.setString(12, notification.getActionText());
            stmt.setBoolean(13, notification.getIsActive());
            stmt.setTimestamp(14, notification.getStartDate());
            stmt.setTimestamp(15, notification.getEndDate());
            stmt.setInt(16, notification.getNotificationId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating notification: " + notification.getNotificationId(), e);
            return false;
        }
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
     * Count all notifications
     */
    public int countAll() {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(COUNT_ALL)) {

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting all notifications", e);
        }

        return 0;
    }

    /**
     * Count notifications by type
     */
    public int countByType(String notificationType) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(COUNT_BY_TYPE)) {

            stmt.setString(1, notificationType);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting notifications by type: " + notificationType, e);
        }

        return 0;
    }

    /**
     * Count active notifications
     */
    public int countActive() {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(COUNT_ACTIVE)) {

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting active notifications", e);
        }

        return 0;
    }

    /**
     * Map ResultSet to GeneralNotification object
     */
    private GeneralNotification mapResultSetToNotification(ResultSet rs) throws SQLException {
        GeneralNotification notification = new GeneralNotification();

        notification.setNotificationId(rs.getInt("notification_id"));
        notification.setTitle(rs.getString("title"));
        notification.setMessage(rs.getString("message"));
        notification.setNotificationType(rs.getString("notification_type"));
        notification.setPriority(rs.getString("priority"));
        notification.setTargetType(rs.getString("target_type"));

        // Parse JSON arrays
        String targetRoleIdsJson = rs.getString("target_role_ids");
        if (targetRoleIdsJson != null && !targetRoleIdsJson.trim().isEmpty()) {
            try {
                List<Integer> roleIds = gson.fromJson(targetRoleIdsJson, new TypeToken<List<Integer>>(){}.getType());
                notification.setTargetRoleIds(roleIds);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error parsing target_role_ids JSON", e);
            }
        }

        String targetUserIdsJson = rs.getString("target_user_ids");
        if (targetUserIdsJson != null && !targetUserIdsJson.trim().isEmpty()) {
            try {
                List<Integer> userIds = gson.fromJson(targetUserIdsJson, new TypeToken<List<Integer>>(){}.getType());
                notification.setTargetUserIds(userIds);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error parsing target_user_ids JSON", e);
            }
        }

        String targetCustomerIdsJson = rs.getString("target_customer_ids");
        if (targetCustomerIdsJson != null && !targetCustomerIdsJson.trim().isEmpty()) {
            try {
                List<Integer> customerIds = gson.fromJson(targetCustomerIdsJson, new TypeToken<List<Integer>>(){}.getType());
                notification.setTargetCustomerIds(customerIds);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error parsing target_customer_ids JSON", e);
            }
        }

        notification.setImageUrl(rs.getString("image_url"));
        notification.setAttachmentUrl(rs.getString("attachment_url"));
        notification.setActionUrl(rs.getString("action_url"));
        notification.setActionText(rs.getString("action_text"));
        notification.setIsActive(rs.getBoolean("is_active"));
        notification.setStartDate(rs.getTimestamp("start_date"));
        notification.setEndDate(rs.getTimestamp("end_date"));
        notification.setCreatedByUserId(rs.getInt("created_by_user_id"));
        notification.setCreatedAt(rs.getTimestamp("created_at"));
        notification.setUpdatedAt(rs.getTimestamp("updated_at"));

        // Set additional fields from joins
        notification.setCreatedByUserName(rs.getString("created_by_user_name"));

        return notification;
    }
}
