/**
 * Payment Scheduling Notifications JavaScript
 * Handles manager notifications for payment-to-scheduling workflow
 * 
 * @author SpaManagement
 */

class PaymentSchedulingNotificationSystem {
    constructor() {
        this.contextPath = this.getContextPath();
        this.websocket = null;
        this.autoRefreshInterval = null;
        this.soundEnabled = true;
        this.init();
    }
    
    init() {
        console.log('[PAYMENT-NOTIFICATIONS] Initializing Payment Scheduling Notification System...');
        this.setupEventListeners();
        this.initializeWebSocket();
        this.setupAutoRefresh();
        this.loadNotificationSound();
        console.log('[PAYMENT-NOTIFICATIONS] System initialized');
    }
    
    getContextPath() {
        const path = window.location.pathname;
        const contextPath = path.substring(0, path.indexOf('/', 1));
        return contextPath || '';
    }
    
    setupEventListeners() {
        // Auto refresh toggle
        const autoRefreshToggle = document.getElementById('autoRefresh');
        if (autoRefreshToggle) {
            autoRefreshToggle.addEventListener('change', (e) => {
                if (e.target.checked) {
                    this.setupAutoRefresh();
                } else {
                    this.clearAutoRefresh();
                }
            });
        }
        
        // Sound alerts toggle
        const soundToggle = document.getElementById('soundAlerts');
        if (soundToggle) {
            soundToggle.addEventListener('change', (e) => {
                this.soundEnabled = e.target.checked;
            });
        }
        
        // Page visibility change
        document.addEventListener('visibilitychange', () => {
            if (!document.hidden) {
                this.checkForUpdates();
            }
        });
    }
    
    initializeWebSocket() {
        try {
            const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
            const wsUrl = `${protocol}//${window.location.host}${this.contextPath}/booking-websocket`;
            
            this.websocket = new WebSocket(wsUrl);
            
            this.websocket.onopen = () => {
                console.log('[WEBSOCKET] Connected to payment scheduling notifications');
                this.updateWebSocketStatus('connected');
            };
            
            this.websocket.onmessage = (event) => {
                try {
                    const data = JSON.parse(event.data);
                    this.handleWebSocketMessage(data);
                } catch (error) {
                    console.error('[WEBSOCKET] Error parsing message:', error);
                }
            };
            
            this.websocket.onclose = () => {
                console.log('[WEBSOCKET] Connection closed, attempting to reconnect...');
                this.updateWebSocketStatus('disconnected');
                setTimeout(() => this.initializeWebSocket(), 5000);
            };
            
            this.websocket.onerror = (error) => {
                console.error('[WEBSOCKET] Error:', error);
                this.updateWebSocketStatus('error');
            };
            
        } catch (error) {
            console.error('[WEBSOCKET] Failed to initialize:', error);
            this.updateWebSocketStatus('error');
        }
    }
    
    handleWebSocketMessage(data) {
        if (data.type === 'PAYMENT_COMPLETED') {
            console.log('[WEBSOCKET] Received payment completed notification:', data);
            this.playNotificationSound();
            this.showBrowserNotification(data);
            this.refreshNotifications();
        }
    }
    
    updateWebSocketStatus(status) {
        const indicator = document.getElementById('websocketIndicator');
        const statusText = document.getElementById('websocketStatus');
        
        if (indicator && statusText) {
            indicator.className = 'websocket-indicator';
            
            switch (status) {
                case 'connected':
                    indicator.classList.add('websocket-connected');
                    statusText.textContent = 'Kết nối thành công';
                    setTimeout(() => indicator.style.display = 'none', 3000);
                    break;
                case 'disconnected':
                    indicator.classList.add('websocket-disconnected');
                    statusText.textContent = 'Mất kết nối';
                    indicator.style.display = 'block';
                    break;
                case 'error':
                    indicator.classList.add('websocket-disconnected');
                    statusText.textContent = 'Lỗi kết nối';
                    indicator.style.display = 'block';
                    break;
            }
        }
    }
    
    setupAutoRefresh() {
        this.clearAutoRefresh();
        this.autoRefreshInterval = setInterval(() => {
            this.checkForUpdates();
        }, 30000); // Refresh every 30 seconds
    }
    
    clearAutoRefresh() {
        if (this.autoRefreshInterval) {
            clearInterval(this.autoRefreshInterval);
            this.autoRefreshInterval = null;
        }
    }
    
    checkForUpdates() {
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
            const response = await fetch(`${this.contextPath}/api/manager/payment-notifications/count?unreadOnly=${unreadOnly}`);
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
    
    async markAsRead(notificationId) {
        try {
            const formData = new FormData();
            formData.append('action', 'mark_as_read');
            formData.append('notificationId', notificationId);
            
            const response = await fetch(`${this.contextPath}/manager/payment-notifications`, {
                method: 'POST',
                body: formData
            });
            
            const data = await response.json();
            
            if (data.success) {
                // Update UI
                const notificationCard = document.querySelector(`[data-notification-id="${notificationId}"]`);
                if (notificationCard) {
                    notificationCard.classList.remove('unread');
                    const statusBadge = notificationCard.querySelector('.status-badge');
                    if (statusBadge) {
                        statusBadge.className = 'status-badge status-read';
                        statusBadge.textContent = 'Đã đọc';
                    }
                    
                    // Remove the "mark as read" button
                    const readButton = notificationCard.querySelector('button[onclick*="markAsRead"]');
                    if (readButton) {
                        readButton.remove();
                    }
                }
                
                this.checkForUpdates();
                this.showToast('Đã đánh dấu thông báo là đã đọc', 'success');
                return true;
            } else {
                throw new Error(data.message || 'Failed to mark as read');
            }
        } catch (error) {
            console.error('[API] Error marking as read:', error);
            this.showToast('Lỗi khi đánh dấu thông báo', 'error');
            return false;
        }
    }
    
    async markAsAcknowledged(notificationId) {
        try {
            const formData = new FormData();
            formData.append('action', 'mark_as_acknowledged');
            formData.append('notificationId', notificationId);
            
            const response = await fetch(`${this.contextPath}/manager/payment-notifications`, {
                method: 'POST',
                body: formData
            });
            
            const data = await response.json();
            
            if (data.success) {
                // Update UI
                const notificationCard = document.querySelector(`[data-notification-id="${notificationId}"]`);
                if (notificationCard) {
                    const statusBadge = notificationCard.querySelector('.status-badge');
                    if (statusBadge) {
                        statusBadge.className = 'status-badge status-acknowledged';
                        statusBadge.textContent = 'Đã xử lý';
                    }
                    
                    // Remove action buttons
                    const actionButtons = notificationCard.querySelectorAll('.notification-actions button[onclick*="markAsAcknowledged"], .notification-actions button[onclick*="openSchedulingModal"]');
                    actionButtons.forEach(button => button.remove());
                }
                
                this.checkForUpdates();
                this.showToast('Đã đánh dấu thông báo là đã xử lý', 'success');
                return true;
            } else {
                throw new Error(data.message || 'Failed to mark as acknowledged');
            }
        } catch (error) {
            console.error('[API] Error marking as acknowledged:', error);
            this.showToast('Lỗi khi đánh dấu thông báo', 'error');
            return false;
        }
    }
    
    openSchedulingModal(paymentId, notificationId) {
        // Load scheduling interface
        const modalBody = document.getElementById('schedulingModalBody');
        modalBody.innerHTML = `
            <div class="text-center">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Đang tải...</span>
                </div>
                <p class="mt-2">Đang tải giao diện lên lịch...</p>
            </div>
        `;
        
        // Show modal
        const modal = new bootstrap.Modal(document.getElementById('schedulingModal'));
        modal.show();
        
        // Load scheduling form (this would be implemented separately)
        setTimeout(() => {
            modalBody.innerHTML = `
                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i>
                    Giao diện lên lịch hẹn sẽ được tích hợp ở đây.
                    <br>Payment ID: ${paymentId}, Notification ID: ${notificationId}
                </div>
                <div class="text-center">
                    <button class="btn btn-success" onclick="markAsAcknowledged(${notificationId}); bootstrap.Modal.getInstance(document.getElementById('schedulingModal')).hide();">
                        <i class="fas fa-check me-1"></i>Đánh dấu đã xử lý
                    </button>
                </div>
            `;
        }, 1000);
    }
    
    viewPaymentDetails(paymentId) {
        // Open payment details in new tab/window
        window.open(`${this.contextPath}/manager/payments/${paymentId}`, '_blank');
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
            document.title = `(${count}) Thông Báo Thanh Toán - Spa Hương Sen`;
        } else {
            document.title = 'Thông Báo Thanh Toán - Spa Hương Sen';
        }
    }
    
    refreshNotifications() {
        window.location.reload();
    }
    
    markAllAsRead() {
        if (confirm('Bạn có chắc chắn muốn đánh dấu tất cả thông báo là đã đọc?')) {
            // This would require a batch API endpoint
            this.showToast('Tính năng này sẽ được triển khai sau', 'info');
        }
    }
    
    loadNotificationSound() {
        this.notificationSound = new Audio(`${this.contextPath}/sounds/notification.mp3`);
        this.notificationSound.volume = 0.5;
    }
    
    playNotificationSound() {
        if (this.soundEnabled && this.notificationSound) {
            this.notificationSound.play().catch(error => {
                console.warn('[SOUND] Could not play notification sound:', error);
            });
        }
    }
    
    showBrowserNotification(data) {
        if ('Notification' in window && Notification.permission === 'granted') {
            new Notification('Thanh toán mới hoàn tất', {
                body: data.message || 'Có thanh toán mới cần lên lịch hẹn',
                icon: `${this.contextPath}/images/spa-icon.png`,
                tag: 'payment-notification'
            });
        } else if ('Notification' in window && Notification.permission !== 'denied') {
            Notification.requestPermission().then(permission => {
                if (permission === 'granted') {
                    this.showBrowserNotification(data);
                }
            });
        }
    }
    
    showToast(message, type = 'info', duration = 3000) {
        // Create toast notification
        const toast = document.createElement('div');
        toast.className = `alert alert-${type === 'error' ? 'danger' : type} alert-dismissible fade show position-fixed`;
        toast.style.cssText = 'top: 80px; right: 20px; z-index: 9999; min-width: 300px;';
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
}

// Global functions for JSP onclick handlers
function markAsRead(notificationId) {
    window.paymentNotificationSystem.markAsRead(notificationId);
}

function markAsAcknowledged(notificationId) {
    window.paymentNotificationSystem.markAsAcknowledged(notificationId);
}

function openSchedulingModal(paymentId, notificationId) {
    window.paymentNotificationSystem.openSchedulingModal(paymentId, notificationId);
}

function viewPaymentDetails(paymentId) {
    window.paymentNotificationSystem.viewPaymentDetails(paymentId);
}

function refreshNotifications() {
    window.paymentNotificationSystem.refreshNotifications();
}

function markAllAsRead() {
    window.paymentNotificationSystem.markAllAsRead();
}

// Initialize the notification system when page loads
document.addEventListener('DOMContentLoaded', () => {
    window.paymentNotificationSystem = new PaymentSchedulingNotificationSystem();
});
