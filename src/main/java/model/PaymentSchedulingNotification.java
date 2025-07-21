package model;

import lombok.*;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.sql.Timestamp;
import java.util.Map;

/**
 * Model class for payment scheduling notifications
 * Specialized for payment-to-scheduling workflow
 * 
 * @author SpaManagement
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class PaymentSchedulingNotification {
    
    private Integer notificationId;
    private Integer paymentId;
    private Integer customerId;
    private Integer recipientUserId;
    private String notificationType;
    private String title;
    private String message;
    private String priority;
    private Boolean isRead = false;
    private Boolean isAcknowledged = false;
    private String relatedDataJson;
    private Boolean websocketSent = false;
    private Boolean emailSent = false;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp readAt;
    private Timestamp acknowledgedAt;
    private Integer acknowledgedBy;
    
    // Additional fields from joins (not stored in database)
    private String customerName;
    private String recipientUserName;
    private String acknowledgedByUserName;
    private Double paymentAmount;
    private String paymentMethod;
    private Integer serviceCount;
    private String serviceList;
    private String referenceNumber;
    
    // Parsed related data
    private Map<String, Object> relatedData;
    
    /**
     * Notification types enum
     */
    public enum NotificationType {
        PAYMENT_COMPLETED("PAYMENT_COMPLETED", "Thanh toán hoàn tất"),
        SCHEDULING_REQUIRED("SCHEDULING_REQUIRED", "Cần lên lịch"),
        BOOKING_REMINDER("BOOKING_REMINDER", "Nhắc nhở đặt lịch"),
        PAYMENT_UPDATED("PAYMENT_UPDATED", "Cập nhật thanh toán");
        
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
     * Priority levels enum
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
     * Parse related data JSON
     */
    public Map<String, Object> getRelatedData() {
        if (relatedData == null && relatedDataJson != null && !relatedDataJson.trim().isEmpty()) {
            try {
                Gson gson = new Gson();
                relatedData = gson.fromJson(relatedDataJson, new TypeToken<Map<String, Object>>(){}.getType());
            } catch (Exception e) {
                relatedData = new java.util.HashMap<>();
            }
        }
        return relatedData != null ? relatedData : new java.util.HashMap<>();
    }
    
    /**
     * Get related data value as string
     */
    public String getRelatedDataString(String key) {
        Map<String, Object> data = getRelatedData();
        Object value = data.get(key);
        return value != null ? value.toString() : "";
    }
    
    /**
     * Get related data value as double
     */
    public Double getRelatedDataDouble(String key) {
        Map<String, Object> data = getRelatedData();
        Object value = data.get(key);
        if (value instanceof Number) {
            return ((Number) value).doubleValue();
        }
        try {
            return Double.parseDouble(value.toString());
        } catch (Exception e) {
            return 0.0;
        }
    }
    
    /**
     * Get related data value as integer
     */
    public Integer getRelatedDataInteger(String key) {
        Map<String, Object> data = getRelatedData();
        Object value = data.get(key);
        if (value instanceof Number) {
            return ((Number) value).intValue();
        }
        try {
            return Integer.parseInt(value.toString());
        } catch (Exception e) {
            return 0;
        }
    }
    
    /**
     * Check if notification has related data
     */
    public boolean hasRelatedData() {
        return relatedDataJson != null && !relatedDataJson.trim().isEmpty();
    }
    
    /**
     * Get notification type as enum
     */
    public NotificationType getNotificationTypeEnum() {
        return notificationType != null ? NotificationType.fromString(notificationType) : NotificationType.PAYMENT_COMPLETED;
    }
    
    /**
     * Get priority as enum
     */
    public Priority getPriorityEnum() {
        return priority != null ? Priority.fromString(priority) : Priority.HIGH;
    }
    
    /**
     * Get notification type display text
     */
    public String getTypeDisplayText() {
        return getNotificationTypeEnum().getDisplayName();
    }
    
    /**
     * Get priority display text
     */
    public String getPriorityDisplayText() {
        return getPriorityEnum().getDisplayName();
    }
    
    /**
     * Get CSS class for priority styling
     */
    public String getPriorityCssClass() {
        if (priority == null) return "priority-high";
        
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
                return "priority-high";
        }
    }
    
    /**
     * Get icon class for notification type
     */
    public String getTypeIconClass() {
        if (notificationType == null) return "fas fa-credit-card";
        
        switch (notificationType) {
            case "PAYMENT_COMPLETED":
                return "fas fa-credit-card";
            case "SCHEDULING_REQUIRED":
                return "fas fa-calendar-plus";
            case "BOOKING_REMINDER":
                return "fas fa-bell";
            case "PAYMENT_UPDATED":
                return "fas fa-edit";
            default:
                return "fas fa-credit-card";
        }
    }
    
    /**
     * Check if notification is high priority or above
     */
    public boolean isHighPriority() {
        if (priority == null) return true; // Default to high priority
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
     * Get formatted payment amount
     */
    public String getFormattedPaymentAmount() {
        Double amount = getRelatedDataDouble("payment_amount");
        if (amount == null || amount == 0.0) {
            return "0 VND";
        }
        return String.format("%,.0f VND", amount);
    }
    
    /**
     * Get service count from related data
     */
    public Integer getServiceCountFromData() {
        return getRelatedDataInteger("service_count");
    }
    
    /**
     * Get service list from related data
     */
    public String getServiceListFromData() {
        return getRelatedDataString("service_list");
    }
    
    /**
     * Get payment method from related data
     */
    public String getPaymentMethodFromData() {
        return getRelatedDataString("payment_method");
    }
    
    /**
     * Get reference number from related data
     */
    public String getReferenceNumberFromData() {
        return getRelatedDataString("reference_number");
    }
    
    /**
     * Check if notification needs immediate attention
     */
    public boolean needsImmediateAttention() {
        return isUrgent() || (!Boolean.TRUE.equals(isRead) && isHighPriority());
    }
    
    /**
     * Get status text
     */
    public String getStatusText() {
        if (Boolean.TRUE.equals(isAcknowledged)) {
            return "Đã xử lý";
        } else if (Boolean.TRUE.equals(isRead)) {
            return "Đã đọc";
        } else {
            return "Chưa đọc";
        }
    }
    
    /**
     * Get status CSS class
     */
    public String getStatusCssClass() {
        if (Boolean.TRUE.equals(isAcknowledged)) {
            return "status-acknowledged";
        } else if (Boolean.TRUE.equals(isRead)) {
            return "status-read";
        } else {
            return "status-unread";
        }
    }
    
    @Override
    public String toString() {
        return "PaymentSchedulingNotification{" +
                "notificationId=" + notificationId +
                ", paymentId=" + paymentId +
                ", customerId=" + customerId +
                ", recipientUserId=" + recipientUserId +
                ", notificationType='" + notificationType + '\'' +
                ", priority='" + priority + '\'' +
                ", isRead=" + isRead +
                ", isAcknowledged=" + isAcknowledged +
                ", createdAt=" + createdAt +
                '}';
    }
}
