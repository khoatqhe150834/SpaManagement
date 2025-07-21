package model;

import lombok.*;
import java.sql.Timestamp;

/**
 * Model class for notification recipients
 * Tracks read/delivery status for each recipient
 * 
 * @author SpaManagement
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class NotificationRecipient {
    
    private Integer recipientId;
    private Integer notificationId;
    private Integer userId;
    private Integer customerId;
    private Boolean isRead = false;
    private Timestamp readAt;
    private Boolean isDismissed = false;
    private Timestamp dismissedAt;
    private String deliveryStatus;
    private String deliveryMethod;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Additional fields from joins (not stored in database)
    private String userName;
    private String customerName;
    private String notificationTitle;
    private String notificationType;
    private String priority;
    
    /**
     * Delivery status enum
     */
    public enum DeliveryStatus {
        PENDING("PENDING", "Đang chờ"),
        DELIVERED("DELIVERED", "Đã gửi"),
        FAILED("FAILED", "Thất bại"),
        EXPIRED("EXPIRED", "Đã hết hạn");
        
        private final String value;
        private final String displayName;
        
        DeliveryStatus(String value, String displayName) {
            this.value = value;
            this.displayName = displayName;
        }
        
        public String getValue() { return value; }
        public String getDisplayName() { return displayName; }
        
        public static DeliveryStatus fromString(String value) {
            for (DeliveryStatus status : DeliveryStatus.values()) {
                if (status.value.equals(value)) {
                    return status;
                }
            }
            throw new IllegalArgumentException("Unknown delivery status: " + value);
        }
    }
    
    /**
     * Delivery method enum
     */
    public enum DeliveryMethod {
        WEB("WEB", "Web"),
        EMAIL("EMAIL", "Email"),
        SMS("SMS", "SMS"),
        PUSH("PUSH", "Push Notification");
        
        private final String value;
        private final String displayName;
        
        DeliveryMethod(String value, String displayName) {
            this.value = value;
            this.displayName = displayName;
        }
        
        public String getValue() { return value; }
        public String getDisplayName() { return displayName; }
        
        public static DeliveryMethod fromString(String value) {
            for (DeliveryMethod method : DeliveryMethod.values()) {
                if (method.value.equals(value)) {
                    return method;
                }
            }
            throw new IllegalArgumentException("Unknown delivery method: " + value);
        }
    }
    
    /**
     * Check if recipient is a user (staff)
     */
    public boolean isUser() {
        return userId != null && customerId == null;
    }
    
    /**
     * Check if recipient is a customer
     */
    public boolean isCustomer() {
        return customerId != null && userId == null;
    }
    
    /**
     * Get recipient ID (user or customer)
     */
    public Integer getRecipientEntityId() {
        return isUser() ? userId : customerId;
    }
    
    /**
     * Get recipient name
     */
    public String getRecipientName() {
        return isUser() ? userName : customerName;
    }
    
    /**
     * Get recipient type display text
     */
    public String getRecipientTypeDisplayText() {
        return isUser() ? "Nhân viên" : "Khách hàng";
    }
    
    /**
     * Get delivery status as enum
     */
    public DeliveryStatus getDeliveryStatusEnum() {
        return deliveryStatus != null ? DeliveryStatus.fromString(deliveryStatus) : DeliveryStatus.PENDING;
    }
    
    /**
     * Get delivery method as enum
     */
    public DeliveryMethod getDeliveryMethodEnum() {
        return deliveryMethod != null ? DeliveryMethod.fromString(deliveryMethod) : DeliveryMethod.WEB;
    }
    
    /**
     * Get delivery status display text
     */
    public String getDeliveryStatusDisplayText() {
        if (deliveryStatus == null) return "Đang chờ";
        return getDeliveryStatusEnum().getDisplayName();
    }
    
    /**
     * Get delivery method display text
     */
    public String getDeliveryMethodDisplayText() {
        if (deliveryMethod == null) return "Web";
        return getDeliveryMethodEnum().getDisplayName();
    }
    
    /**
     * Get CSS class for delivery status
     */
    public String getDeliveryStatusCssClass() {
        if (deliveryStatus == null) return "status-pending";
        
        switch (deliveryStatus) {
            case "PENDING":
                return "status-pending";
            case "DELIVERED":
                return "status-delivered";
            case "FAILED":
                return "status-failed";
            case "EXPIRED":
                return "status-expired";
            default:
                return "status-pending";
        }
    }
    
    /**
     * Check if notification is unread
     */
    public boolean isUnread() {
        return !Boolean.TRUE.equals(isRead);
    }
    
    /**
     * Check if notification is undismissed
     */
    public boolean isUndismissed() {
        return !Boolean.TRUE.equals(isDismissed);
    }
    
    /**
     * Check if delivery was successful
     */
    public boolean isDelivered() {
        return DeliveryStatus.DELIVERED.getValue().equals(deliveryStatus);
    }
    
    /**
     * Check if delivery failed
     */
    public boolean isDeliveryFailed() {
        return DeliveryStatus.FAILED.getValue().equals(deliveryStatus);
    }
    
    /**
     * Check if delivery is pending
     */
    public boolean isDeliveryPending() {
        return deliveryStatus == null || DeliveryStatus.PENDING.getValue().equals(deliveryStatus);
    }
    
    /**
     * Get time elapsed since read for display
     */
    public String getReadTimeElapsed() {
        if (readAt == null) return "";
        
        long now = System.currentTimeMillis();
        long read = readAt.getTime();
        long diff = now - read;
        
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
     * Get time elapsed since dismissed for display
     */
    public String getDismissedTimeElapsed() {
        if (dismissedAt == null) return "";
        
        long now = System.currentTimeMillis();
        long dismissed = dismissedAt.getTime();
        long diff = now - dismissed;
        
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
     * Get status summary text
     */
    public String getStatusSummary() {
        if (Boolean.TRUE.equals(isDismissed)) {
            return "Đã bỏ qua";
        } else if (Boolean.TRUE.equals(isRead)) {
            return "Đã đọc";
        } else if (isDelivered()) {
            return "Đã gửi";
        } else if (isDeliveryFailed()) {
            return "Gửi thất bại";
        } else {
            return "Đang chờ";
        }
    }
    
    /**
     * Get status summary CSS class
     */
    public String getStatusSummaryCssClass() {
        if (Boolean.TRUE.equals(isDismissed)) {
            return "status-dismissed";
        } else if (Boolean.TRUE.equals(isRead)) {
            return "status-read";
        } else if (isDelivered()) {
            return "status-delivered";
        } else if (isDeliveryFailed()) {
            return "status-failed";
        } else {
            return "status-pending";
        }
    }
    
    @Override
    public String toString() {
        return "NotificationRecipient{" +
                "recipientId=" + recipientId +
                ", notificationId=" + notificationId +
                ", userId=" + userId +
                ", customerId=" + customerId +
                ", isRead=" + isRead +
                ", isDismissed=" + isDismissed +
                ", deliveryStatus='" + deliveryStatus + '\'' +
                ", deliveryMethod='" + deliveryMethod + '\'' +
                '}';
    }
}
