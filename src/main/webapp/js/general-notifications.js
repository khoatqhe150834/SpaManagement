/**
 * General Notifications JavaScript
 * Handles notification interactions for all user types
 * 
 * @author SpaManagement
 */

class GeneralNotificationSystem {
    constructor() {
        this.contextPath = this.getContextPath();
        this.init();
    }
    
    init() {
        console.log('[NOTIFICATIONS] Initializing General Notification System...');
        this.setupEventListeners();
        this.checkForUpdates();
        console.log('[NOTIFICATIONS] System initialized');
    }
    
    getContextPath() {
        // Get context path from current URL
        const path = window.location.pathname;
        const contextPath = path.substring(0, path.indexOf('/', 1));
        return contextPath || '';
    }
    
    setupEventListeners() {
        // Auto-refresh notifications every 5 minutes
        setInterval(() => {
            this.checkForUpdates();
        }, 5 * 60 * 1000);
        
        // Handle page visibility change
        document.addEventListener('visibilitychange', () => {
            if (!document.hidden) {
                this.checkForUpdates();
            }
        });
    }
    
    checkForUpdates() {
        // Check for new notifications count
        this.getNotificationCount(true)
            .then(count => {
                this.updateUnreadCount(count);
            })
            .catch(error => {
                console.warn('[NOTIFICATIONS] Error checking for updates:', error);
            });
    }
    
    async getNotificationCount(unreadOnly = false) {
        try {
            const response = await fetch(`${this.contextPath}/api/notifications/count?unreadOnly=${unreadOnly}`);
            const data = await response.json();
            
            if (data.success) {
                return data.data;
            } else {
                throw new Error(data.message || 'Failed to get notification count');
            }
        } catch (error) {
            console.error('[API] Error getting notification count:', error);
            throw error;
        }
    }
    
    async getNotifications(unreadOnly = false) {
        try {
            const response = await fetch(`${this.contextPath}/api/notifications?unreadOnly=${unreadOnly}`);
            const data = await response.json();
            
            if (data.success) {
                return data.data;
            } else {
                throw new Error(data.message || 'Failed to get notifications');
            }
        } catch (error) {
            console.error('[API] Error getting notifications:', error);
            throw error;
        }
    }
    
    async markAsRead(notificationId) {
        try {
            const formData = new FormData();
            formData.append('action', 'mark_as_read');
            formData.append('notificationId', notificationId);
            
            const response = await fetch(`${this.contextPath}/notifications`, {
                method: 'POST',
                body: formData
            });
            
            const data = await response.json();
            
            if (data.success) {
                // Update UI
                const notificationCard = document.querySelector(`[data-notification-id="${notificationId}"]`);
                if (notificationCard) {
                    notificationCard.classList.remove('unread');
                    const newBadge = notificationCard.querySelector('.badge.bg-warning');
                    if (newBadge) {
                        newBadge.remove();
                    }
                    
                    // Remove the "mark as read" button
                    const readButton = notificationCard.querySelector('button[onclick*="markAsRead"]');
                    if (readButton) {
                        readButton.remove();
                    }
                }
                
                // Update unread count
                this.checkForUpdates();
                
                this.showNotification('Đã đánh dấu thông báo là đã đọc', 'success');
                return true;
            } else {
                throw new Error(data.message || 'Failed to mark as read');
            }
        } catch (error) {
            console.error('[API] Error marking as read:', error);
            this.showNotification('Lỗi khi đánh dấu thông báo', 'error');
            return false;
        }
    }
    
    async markAsDismissed(notificationId) {
        try {
            const formData = new FormData();
            formData.append('action', 'mark_as_dismissed');
            formData.append('notificationId', notificationId);
            
            const response = await fetch(`${this.contextPath}/notifications`, {
                method: 'POST',
                body: formData
            });
            
            const data = await response.json();
            
            if (data.success) {
                // Update UI
                const notificationCard = document.querySelector(`[data-notification-id="${notificationId}"]`);
                if (notificationCard) {
                    // Add dismissed styling
                    notificationCard.style.opacity = '0.6';
                    notificationCard.style.pointerEvents = 'none';
                    
                    // Remove action buttons
                    const actionButtons = notificationCard.querySelectorAll('.notification-actions button');
                    actionButtons.forEach(button => button.remove());
                    
                    // Add dismissed label
                    const metaDiv = notificationCard.querySelector('.notification-meta');
                    if (metaDiv) {
                        metaDiv.innerHTML += ' <span class="mx-2">•</span><i class="fas fa-check-circle me-1"></i>Đã bỏ qua';
                    }
                }
                
                // Update unread count
                this.checkForUpdates();
                
                this.showNotification('Đã bỏ qua thông báo', 'success');
                return true;
            } else {
                throw new Error(data.message || 'Failed to mark as dismissed');
            }
        } catch (error) {
            console.error('[API] Error marking as dismissed:', error);
            this.showNotification('Lỗi khi bỏ qua thông báo', 'error');
            return false;
        }
    }
    
    updateUnreadCount(count) {
        // Update unread count in summary
        const unreadElement = document.querySelector('.summary-number.text-warning');
        if (unreadElement) {
            unreadElement.textContent = count;
        }
        
        // Update filter button
        const unreadFilterButton = document.querySelector('a[href*="filter=unread"]');
        if (unreadFilterButton) {
            unreadFilterButton.innerHTML = `<i class="fas fa-envelope me-1"></i>Chưa đọc (${count})`;
        }
        
        // Update page title if there are unread notifications
        if (count > 0) {
            document.title = `(${count}) Thông Báo - Spa Hương Sen`;
        } else {
            document.title = 'Thông Báo - Spa Hương Sen';
        }
    }
    
    showNotification(message, type = 'info', duration = 3000) {
        // Create toast notification
        const toast = document.createElement('div');
        toast.className = `alert alert-${type === 'error' ? 'danger' : type} alert-dismissible fade show position-fixed`;
        toast.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
        toast.innerHTML = `
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        
        document.body.appendChild(toast);
        
        // Auto remove after duration
        setTimeout(() => {
            if (toast.parentNode) {
                toast.remove();
            }
        }, duration);
    }
    
    refreshNotifications() {
        window.location.reload();
    }
    
    // Utility method to format time elapsed
    formatTimeElapsed(timestamp) {
        const now = new Date();
        const created = new Date(timestamp);
        const diff = now - created;
        
        const seconds = Math.floor(diff / 1000);
        const minutes = Math.floor(seconds / 60);
        const hours = Math.floor(minutes / 60);
        const days = Math.floor(hours / 24);
        
        if (days > 0) {
            return `${days} ngày trước`;
        } else if (hours > 0) {
            return `${hours} giờ trước`;
        } else if (minutes > 0) {
            return `${minutes} phút trước`;
        } else {
            return 'Vừa xong';
        }
    }
    
    // Method to create notification card HTML (for dynamic updates)
    createNotificationCardHtml(notification) {
        const priorityClass = notification.priority ? notification.priority.toLowerCase() : 'medium';
        const typeClass = notification.notificationType ? notification.notificationType.toLowerCase().replace('_', '-') : 'system-announcement';
        const timeElapsed = this.formatTimeElapsed(notification.createdAt);
        
        return `
            <div class="notification-card ${notification.isReadByCurrentUser ? '' : 'unread'} priority-${priorityClass}" 
                 data-notification-id="${notification.notificationId}">
                <div class="row align-items-start">
                    <div class="col-auto">
                        <div class="notification-icon ${typeClass}">
                            <i class="${this.getTypeIconClass(notification.notificationType)}"></i>
                        </div>
                    </div>
                    <div class="col">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <h6 class="mb-1">${notification.title}</h6>
                            <div class="d-flex gap-2 align-items-center">
                                <span class="priority-badge priority-${priorityClass}">
                                    ${this.getPriorityDisplayText(notification.priority)}
                                </span>
                                ${!notification.isReadByCurrentUser ? '<span class="badge bg-warning">Mới</span>' : ''}
                            </div>
                        </div>
                        
                        <p class="mb-2">${notification.message}</p>
                        
                        ${notification.imageUrl ? `<img src="${notification.imageUrl}" alt="Notification Image" class="notification-image">` : ''}
                        
                        <div class="notification-meta">
                            <i class="fas fa-clock me-1"></i>${timeElapsed}
                            <span class="mx-2">•</span>
                            <i class="fas fa-tag me-1"></i>${this.getTypeDisplayText(notification.notificationType)}
                        </div>
                        
                        ${notification.actionUrl ? `<a href="${notification.actionUrl}" class="action-button" target="_blank">${notification.actionText || 'Xem chi tiết'}</a>` : ''}
                        
                        <div class="notification-actions">
                            ${!notification.isReadByCurrentUser ? `<button class="btn btn-outline-primary btn-sm" onclick="markAsRead(${notification.notificationId})"><i class="fas fa-eye me-1"></i>Đánh dấu đã đọc</button>` : ''}
                            ${!notification.isDismissedByCurrentUser ? `<button class="btn btn-outline-secondary btn-sm" onclick="markAsDismissed(${notification.notificationId})"><i class="fas fa-times me-1"></i>Bỏ qua</button>` : ''}
                        </div>
                    </div>
                </div>
            </div>
        `;
    }
    
    getTypeIconClass(notificationType) {
        switch (notificationType) {
            case 'SYSTEM_ANNOUNCEMENT': return 'fas fa-bullhorn';
            case 'PROMOTION': return 'fas fa-tags';
            case 'MAINTENANCE': return 'fas fa-tools';
            case 'POLICY_UPDATE': return 'fas fa-file-contract';
            case 'BOOKING_REMINDER': return 'fas fa-calendar-check';
            case 'PAYMENT_NOTIFICATION': return 'fas fa-credit-card';
            case 'SERVICE_UPDATE': return 'fas fa-spa';
            case 'EMERGENCY': return 'fas fa-exclamation-triangle';
            case 'MARKETING_CAMPAIGN': return 'fas fa-megaphone';
            case 'INVENTORY_ALERT': return 'fas fa-boxes';
            default: return 'fas fa-bell';
        }
    }
    
    getPriorityDisplayText(priority) {
        switch (priority) {
            case 'LOW': return 'Thấp';
            case 'MEDIUM': return 'Bình thường';
            case 'HIGH': return 'Cao';
            case 'URGENT': return 'Khẩn cấp';
            default: return 'Bình thường';
        }
    }
    
    getTypeDisplayText(notificationType) {
        switch (notificationType) {
            case 'SYSTEM_ANNOUNCEMENT': return 'Thông báo hệ thống';
            case 'PROMOTION': return 'Khuyến mãi';
            case 'MAINTENANCE': return 'Bảo trì';
            case 'POLICY_UPDATE': return 'Cập nhật chính sách';
            case 'BOOKING_REMINDER': return 'Nhắc nhở lịch hẹn';
            case 'PAYMENT_NOTIFICATION': return 'Thông báo thanh toán';
            case 'SERVICE_UPDATE': return 'Cập nhật dịch vụ';
            case 'EMERGENCY': return 'Khẩn cấp';
            case 'MARKETING_CAMPAIGN': return 'Chiến dịch marketing';
            case 'INVENTORY_ALERT': return 'Cảnh báo kho';
            default: return 'Thông báo';
        }
    }
}

// Global functions for JSP onclick handlers
function markAsRead(notificationId) {
    window.notificationSystem.markAsRead(notificationId);
}

function markAsDismissed(notificationId) {
    window.notificationSystem.markAsDismissed(notificationId);
}

function refreshNotifications() {
    window.notificationSystem.refreshNotifications();
}

// Initialize the notification system when page loads
document.addEventListener('DOMContentLoaded', () => {
    window.notificationSystem = new GeneralNotificationSystem();
});
