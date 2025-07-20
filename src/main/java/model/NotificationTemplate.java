package model;

import lombok.*;
import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

/**
 * Model class for notification templates
 * Provides reusable templates for common notification types
 * 
 * @author SpaManagement
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class NotificationTemplate {
    
    private Integer templateId;
    private String name;
    private String description;
    private String notificationType;
    private String titleTemplate;
    private String messageTemplate;
    private String defaultPriority;
    private String defaultTargetType;
    private List<Integer> defaultRoleIds;
    private Map<String, String> placeholders;
    private Boolean isActive = true;
    private Integer createdByUserId;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Additional fields from joins (not stored in database)
    private String createdByUserName;
    private Integer usageCount = 0;
    
    /**
     * Get notification type as enum
     */
    public GeneralNotification.NotificationType getNotificationTypeEnum() {
        return notificationType != null ? 
            GeneralNotification.NotificationType.fromString(notificationType) : 
            GeneralNotification.NotificationType.SYSTEM_ANNOUNCEMENT;
    }
    
    /**
     * Get default priority as enum
     */
    public GeneralNotification.Priority getDefaultPriorityEnum() {
        return defaultPriority != null ? 
            GeneralNotification.Priority.fromString(defaultPriority) : 
            GeneralNotification.Priority.MEDIUM;
    }
    
    /**
     * Get default target type as enum
     */
    public GeneralNotification.TargetType getDefaultTargetTypeEnum() {
        return defaultTargetType != null ? 
            GeneralNotification.TargetType.fromString(defaultTargetType) : 
            GeneralNotification.TargetType.ALL_USERS;
    }
    
    /**
     * Get notification type display text
     */
    public String getNotificationTypeDisplayText() {
        return getNotificationTypeEnum().getDisplayName();
    }
    
    /**
     * Get default priority display text
     */
    public String getDefaultPriorityDisplayText() {
        return getDefaultPriorityEnum().getDisplayName();
    }
    
    /**
     * Get default target type display text
     */
    public String getDefaultTargetTypeDisplayText() {
        return getDefaultTargetTypeEnum().getDisplayName();
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
     * Check if template has placeholders
     */
    public boolean hasPlaceholders() {
        return placeholders != null && !placeholders.isEmpty();
    }
    
    /**
     * Get placeholder count
     */
    public int getPlaceholderCount() {
        return placeholders != null ? placeholders.size() : 0;
    }
    
    /**
     * Replace placeholders in title template
     */
    public String generateTitle(Map<String, String> values) {
        if (titleTemplate == null) return "";
        
        String result = titleTemplate;
        if (values != null) {
            for (Map.Entry<String, String> entry : values.entrySet()) {
                String placeholder = "{" + entry.getKey() + "}";
                String value = entry.getValue() != null ? entry.getValue() : "";
                result = result.replace(placeholder, value);
            }
        }
        return result;
    }
    
    /**
     * Replace placeholders in message template
     */
    public String generateMessage(Map<String, String> values) {
        if (messageTemplate == null) return "";
        
        String result = messageTemplate;
        if (values != null) {
            for (Map.Entry<String, String> entry : values.entrySet()) {
                String placeholder = "{" + entry.getKey() + "}";
                String value = entry.getValue() != null ? entry.getValue() : "";
                result = result.replace(placeholder, value);
            }
        }
        return result;
    }
    
    /**
     * Get list of placeholder keys from templates
     */
    public List<String> extractPlaceholderKeys() {
        java.util.Set<String> keys = new java.util.HashSet<>();
        
        // Extract from title template
        if (titleTemplate != null) {
            java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("\\{([^}]+)\\}");
            java.util.regex.Matcher matcher = pattern.matcher(titleTemplate);
            while (matcher.find()) {
                keys.add(matcher.group(1));
            }
        }
        
        // Extract from message template
        if (messageTemplate != null) {
            java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("\\{([^}]+)\\}");
            java.util.regex.Matcher matcher = pattern.matcher(messageTemplate);
            while (matcher.find()) {
                keys.add(matcher.group(1));
            }
        }
        
        return new java.util.ArrayList<>(keys);
    }
    
    /**
     * Validate that all required placeholders have values
     */
    public boolean validatePlaceholders(Map<String, String> values) {
        if (!hasPlaceholders()) return true;
        
        List<String> requiredKeys = extractPlaceholderKeys();
        if (values == null) return requiredKeys.isEmpty();
        
        for (String key : requiredKeys) {
            if (!values.containsKey(key) || values.get(key) == null || values.get(key).trim().isEmpty()) {
                return false;
            }
        }
        
        return true;
    }
    
    /**
     * Get missing placeholder keys
     */
    public List<String> getMissingPlaceholders(Map<String, String> values) {
        List<String> missing = new java.util.ArrayList<>();
        List<String> requiredKeys = extractPlaceholderKeys();
        
        for (String key : requiredKeys) {
            if (values == null || !values.containsKey(key) || 
                values.get(key) == null || values.get(key).trim().isEmpty()) {
                missing.add(key);
            }
        }
        
        return missing;
    }
    
    /**
     * Create a GeneralNotification from this template
     */
    public GeneralNotification createNotification(Map<String, String> placeholderValues, Integer createdByUserId) {
        GeneralNotification notification = new GeneralNotification();
        
        notification.setTitle(generateTitle(placeholderValues));
        notification.setMessage(generateMessage(placeholderValues));
        notification.setNotificationType(this.notificationType);
        notification.setPriority(this.defaultPriority);
        notification.setTargetType(this.defaultTargetType);
        notification.setTargetRoleIds(this.defaultRoleIds);
        notification.setCreatedByUserId(createdByUserId);
        notification.setIsActive(true);
        
        return notification;
    }
    
    /**
     * Get template preview with sample data
     */
    public String getTitlePreview() {
        Map<String, String> sampleData = new java.util.HashMap<>();
        List<String> keys = extractPlaceholderKeys();
        
        for (String key : keys) {
            sampleData.put(key, "[" + key + "]");
        }
        
        return generateTitle(sampleData);
    }
    
    /**
     * Get message preview with sample data
     */
    public String getMessagePreview() {
        Map<String, String> sampleData = new java.util.HashMap<>();
        List<String> keys = extractPlaceholderKeys();
        
        for (String key : keys) {
            sampleData.put(key, "[" + key + "]");
        }
        
        return generateMessage(sampleData);
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
     * Get status text
     */
    public String getStatusText() {
        return Boolean.TRUE.equals(isActive) ? "Hoạt động" : "Không hoạt động";
    }
    
    /**
     * Get status CSS class
     */
    public String getStatusCssClass() {
        return Boolean.TRUE.equals(isActive) ? "status-active" : "status-inactive";
    }
    
    @Override
    public String toString() {
        return "NotificationTemplate{" +
                "templateId=" + templateId +
                ", name='" + name + '\'' +
                ", notificationType='" + notificationType + '\'' +
                ", defaultPriority='" + defaultPriority + '\'' +
                ", defaultTargetType='" + defaultTargetType + '\'' +
                ", isActive=" + isActive +
                '}';
    }
}
