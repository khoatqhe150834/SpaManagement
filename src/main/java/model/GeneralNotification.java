package model;

import lombok.*;
import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

/**
 * Model class for general notifications system
 * Supports all user roles in the spa management system
 * 
 * @author SpaManagement
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class GeneralNotification {
    
    private Integer notificationId;
    private String title;
    private String message;
    private String notificationType;
    private String priority;
    private String targetType;
    private List<Integer> targetRoleIds;
    private List<Integer> targetUserIds;
    private List<Integer> targetCustomerIds;
    private String imageUrl;
    private String attachmentUrl;
    private String actionUrl;
    private String actionText;
    private Boolean isActive = true;
    private Timestamp startDate;
    private Timestamp endDate;
    private Integer createdByUserId;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Additional fields from joins (not stored in database)
    private String createdByUserName;
    private Integer totalRecipients = 0;
    private Integer readCount = 0;
    private Integer unreadCount = 0;
    private Double readRate = 0.0;
    private Boolean isReadByCurrentUser = false;
    private Boolean isDismissedByCurrentUser = false;
    
    /**
     * Notification types enum for type safety
     */
    public enum NotificationType {
        SYSTEM_ANNOUNCEMENT("SYSTEM_ANNOUNCEMENT", "Thông báo hệ thống"),
        PROMOTION("PROMOTION", "Khuyến mãi"),
        MAINTENANCE("MAINTENANCE", "Bảo trì"),
        POLICY_UPDATE("POLICY_UPDATE", "Cập nhật chính sách"),
        BOOKING_REMINDER("BOOKING_REMINDER", "Nhắc nhở lịch hẹn"),
        PAYMENT_NOTIFICATION("PAYMENT_NOTIFICATION", "Thông báo thanh toán"),
        SERVICE_UPDATE("SERVICE_UPDATE", "Cập nhật dịch vụ"),
        EMERGENCY("EMERGENCY", "Khẩn cấp"),
        MARKETING_CAMPAIGN("MARKETING_CAMPAIGN", "Chiến dịch marketing"),
        INVENTORY_ALERT("INVENTORY_ALERT", "Cảnh báo kho");
        
        private final String value;
        private final String displayName;
        
        NotificationType(String value, String displayName) {
            this.value = value;
            this.displayName = displayName;
        }
        
        public String getValue() { return value; }
        public String getDisplayName() { return displayName; }
        
        public static NotificationType fromString(String value) {
            for (NotificationType type : NotificationType.values()) {
                if (type.value.equals(value)) {
                    return type;
                }
            }
            throw new IllegalArgumentException("Unknown notification type: " + value);
        }
    }
    
    /**
     * Priority levels enum for type safety
     */
    public enum Priority {
        LOW("LOW", "Thấp", 1),
        MEDIUM("MEDIUM", "Bình thường", 2),
        HIGH("HIGH", "Cao", 3),
        URGENT("URGENT", "Khẩn cấp", 4);
        
        private final String value;
        private final String displayName;
        private final int level;
        
        Priority(String value, String displayName, int level) {
            this.value = value;
            this.displayName = displayName;
            this.level = level;
        }
        
        public String getValue() { return value; }
        public String getDisplayName() { return displayName; }
        public int getLevel() { return level; }
        
        public static Priority fromString(String value) {
            for (Priority priority : Priority.values()) {
                if (priority.value.equals(value)) {
                    return priority;
                }
            }
            throw new IllegalArgumentException("Unknown priority: " + value);
        }
    }
    
    /**
     * Target types enum
     */
    public enum TargetType {
        ALL_USERS("ALL_USERS", "Tất cả người dùng"),
        ROLE_BASED("ROLE_BASED", "Theo vai trò"),
        INDIVIDUAL("INDIVIDUAL", "Cá nhân"),
        CUSTOMER_SEGMENT("CUSTOMER_SEGMENT", "Nhóm khách hàng");
        
        private final String value;
        private final String displayName;
        
        TargetType(String value, String displayName) {
            this.value = value;
            this.displayName = displayName;
        }
        
        public String getValue() { return value; }
        public String getDisplayName() { return displayName; }
        
        public static TargetType fromString(String value) {
            for (TargetType type : TargetType.values()) {
                if (type.value.equals(value)) {
                    return type;
                }
            }
            throw new IllegalArgumentException("Unknown target type: " + value);
        }
    }
    
    /**
     * Check if notification is currently active
     */
    public boolean isCurrentlyActive() {
        if (!Boolean.TRUE.equals(isActive)) {
            return false;
        }
        
        Timestamp now = new Timestamp(System.currentTimeMillis());
        
        if (startDate != null && now.before(startDate)) {
            return false;
        }
        
        if (endDate != null && now.after(endDate)) {
            return false;
        }
        
        return true;
    }
    
    /**
     * Check if notification is high priority or above
     */
    public boolean isHighPriority() {
        if (priority == null) return false;
        Priority p = Priority.fromString(priority);
        return p.getLevel() >= Priority.HIGH.getLevel();
    }
    
    /**
     * Check if notification is urgent
     */
    public boolean isUrgent() {
        return Priority.URGENT.getValue().equals(priority);
    }
    
    /**
     * Get priority as enum
     */
    public Priority getPriorityEnum() {
        return priority != null ? Priority.fromString(priority) : Priority.MEDIUM;
    }
    
    /**
     * Get notification type as enum
     */
    public NotificationType getNotificationTypeEnum() {
        return notificationType != null ? NotificationType.fromString(notificationType) : NotificationType.SYSTEM_ANNOUNCEMENT;
    }
    
    /**
     * Get target type as enum
     */
    public TargetType getTargetTypeEnum() {
        return targetType != null ? TargetType.fromString(targetType) : TargetType.ALL_USERS;
    }
    
    /**
     * Get CSS class for priority styling
     */
    public String getPriorityCssClass() {
        if (priority == null) return "priority-medium";
        
        switch (priority) {
            case "LOW":
                return "priority-low";
            case "MEDIUM":
                return "priority-medium";
            case "HIGH":
                return "priority-high";
            case "URGENT":
                return "priority-urgent";
            default:
                return "priority-medium";
        }
    }
    
    /**
     * Get icon class for notification type
     */
    public String getTypeIconClass() {
        if (notificationType == null) return "fas fa-bell";
        
        switch (notificationType) {
            case "SYSTEM_ANNOUNCEMENT":
                return "fas fa-bullhorn";
            case "PROMOTION":
                return "fas fa-tags";
            case "MAINTENANCE":
                return "fas fa-tools";
            case "POLICY_UPDATE":
                return "fas fa-file-contract";
            case "BOOKING_REMINDER":
                return "fas fa-calendar-check";
            case "PAYMENT_NOTIFICATION":
                return "fas fa-credit-card";
            case "SERVICE_UPDATE":
                return "fas fa-spa";
            case "EMERGENCY":
                return "fas fa-exclamation-triangle";
            case "MARKETING_CAMPAIGN":
                return "fas fa-megaphone";
            case "INVENTORY_ALERT":
                return "fas fa-boxes";
            default:
                return "fas fa-bell";
        }
    }
    
    /**
     * Get display text for notification type
     */
    public String getTypeDisplayText() {
        if (notificationType == null) return "Thông báo";
        return getNotificationTypeEnum().getDisplayName();
    }
    
    /**
     * Get display text for priority
     */
    public String getPriorityDisplayText() {
        if (priority == null) return "Bình thường";
        return getPriorityEnum().getDisplayName();
    }
    
    /**
     * Get display text for target type
     */
    public String getTargetTypeDisplayText() {
        if (targetType == null) return "Tất cả người dùng";
        return getTargetTypeEnum().getDisplayName();
    }
    
    /**
     * Get time elapsed since creation for display
     */
    public String getTimeElapsed() {
        if (createdAt == null) return "";
        
        long now = System.currentTimeMillis();
        long created = createdAt.getTime();
        long diff = now - created;
        
        long seconds = diff / 1000;
        long minutes = seconds / 60;
        long hours = minutes / 60;
        long days = hours / 24;
        
        if (days > 0) {
            return days + " ngày trước";
        } else if (hours > 0) {
            return hours + " giờ trước";
        } else if (minutes > 0) {
            return minutes + " phút trước";
        } else {
            return "Vừa xong";
        }
    }
    
    /**
     * Check if notification has action
     */
    public boolean hasAction() {
        return actionUrl != null && !actionUrl.trim().isEmpty();
    }
    
    /**
     * Check if notification has attachment
     */
    public boolean hasAttachment() {
        return attachmentUrl != null && !attachmentUrl.trim().isEmpty();
    }
    
    /**
     * Check if notification has image
     */
    public boolean hasImage() {
        return imageUrl != null && !imageUrl.trim().isEmpty();
    }
    
    /**
     * Get formatted read rate
     */
    public String getFormattedReadRate() {
        if (readRate == null) return "0%";
        return String.format("%.1f%%", readRate);
    }
    
    /**
     * Check if notification is expired
     */
    public boolean isExpired() {
        if (endDate == null) return false;
        return new Timestamp(System.currentTimeMillis()).after(endDate);
    }
    
    /**
     * Check if notification is scheduled for future
     */
    public boolean isScheduled() {
        if (startDate == null) return false;
        return new Timestamp(System.currentTimeMillis()).before(startDate);
    }
    
    /**
     * Get status text
     */
    public String getStatusText() {
        if (!Boolean.TRUE.equals(isActive)) {
            return "Không hoạt động";
        } else if (isExpired()) {
            return "Đã hết hạn";
        } else if (isScheduled()) {
            return "Đã lên lịch";
        } else {
            return "Đang hoạt động";
        }
    }
    
    /**
     * Get status CSS class
     */
    public String getStatusCssClass() {
        if (!Boolean.TRUE.equals(isActive)) {
            return "status-inactive";
        } else if (isExpired()) {
            return "status-expired";
        } else if (isScheduled()) {
            return "status-scheduled";
        } else {
            return "status-active";
        }
    }
    
    @Override
    public String toString() {
        return "GeneralNotification{" +
                "notificationId=" + notificationId +
                ", title='" + title + '\'' +
                ", notificationType='" + notificationType + '\'' +
                ", priority='" + priority + '\'' +
                ", targetType='" + targetType + '\'' +
                ", isActive=" + isActive +
                ", createdAt=" + createdAt +
                '}';
    }
}
