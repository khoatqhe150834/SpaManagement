/**
 * Header Notifications JavaScript
 * Handles notification bell icon and dropdown in the header for managers and admins
 * 
 * @author SpaManagement
 */

class HeaderNotificationSystem {
    constructor() {
        this.contextPath = this.getContextPath();
        this.init();
    }
    
    init() {
        console.log('[HEADER-NOTIFICATIONS] Initializing Header Notification System...');
        this.setupEventListeners();
        this.loadInitialData();
        this.setupAutoRefresh();
        console.log('[HEADER-NOTIFICATIONS] System initialized');
    }
    
    getContextPath() {
        // Get context path from current URL
        const path = window.location.pathname;
        const contextPath = path.substring(0, path.indexOf('/', 1));
        return contextPath || '';
    }
    
    setupEventListeners() {
        const notificationBell = document.getElementById('notification-bell-btn');
        const notificationDropdown = document.getElementById('notification-dropdown');
        
        if (!notificationBell || !notificationDropdown) {
            console.warn('[HEADER-NOTIFICATIONS] Notification elements not found');
            return;
        }
        
        // Toggle notification dropdown
        notificationBell.addEventListener('click', (e) => {
            e.stopPropagation();
            notificationDropdown.classList.toggle('hidden');
            
            if (!notificationDropdown.classList.contains('hidden')) {
                this.loadNotifications();
            }
        });
        
        // Close dropdown when clicking outside
        document.addEventListener('click', (event) => {
            if (!notificationBell.contains(event.target) && !notificationDropdown.contains(event.target)) {
                notificationDropdown.classList.add('hidden');
            }
        });
        
        // Handle page visibility change
        document.addEventListener('visibilitychange', () => {
            if (!document.hidden) {
                this.updateNotificationCount();
            }
        });
    }
    
    loadInitialData() {
        this.updateNotificationCount();
    }
    
    setupAutoRefresh() {
        // Auto-refresh notification count every 30 seconds
        setInterval(() => {
            this.updateNotificationCount();
        }, 30000);
    }
    
    async updateNotificationCount() {
        try {
            const response = await fetch(`${this.contextPath}/api/notifications/count?unreadOnly=true`);
            const data = await response.json();
            
            if (data.success) {
                this.updateNotificationBadge(data.data);
            }
        } catch (error) {
            console.warn('[HEADER-NOTIFICATIONS] Error fetching notification count:', error);
        }
    }
    
    updateNotificationBadge(count) {
        const badge = document.getElementById('notification-badge');
        if (!badge) return;
        
        const numericCount = parseInt(count) || 0;
        
        if (numericCount > 0) {
            badge.textContent = numericCount > 99 ? '99+' : numericCount.toString();
            badge.style.display = 'inline-flex';
            
            // Add pulse animation for new notifications
            badge.classList.add('animate-pulse');
            setTimeout(() => badge.classList.remove('animate-pulse'), 2000);
        } else {
            badge.style.display = 'none';
        }
        
        // Update page title with notification count
        this.updatePageTitle(numericCount);
    }
    
    updatePageTitle(count) {
        const currentTitle = document.title;
        const cleanTitle = currentTitle.replace(/^\(\d+\)\s*/, '');
        
        if (count > 0) {
            document.title = `(${count}) ${cleanTitle}`;
        } else {
            document.title = cleanTitle;
        }
    }
    
    async loadNotifications() {
        const notificationList = document.getElementById('notification-list');
        if (!notificationList) return;
        
        notificationList.innerHTML = '<div class="px-4 py-3 text-sm text-gray-500 text-center">Đang tải...</div>';
        
        try {
            const response = await fetch(`${this.contextPath}/api/notifications?unreadOnly=true&limit=5`);
            const data = await response.json();
            
            if (data.success && data.data && data.data.length > 0) {
                this.displayNotifications(data.data);
            } else {
                notificationList.innerHTML = '<div class="px-4 py-3 text-sm text-gray-500 text-center">Không có thông báo mới</div>';
            }
        } catch (error) {
            console.error('[HEADER-NOTIFICATIONS] Error loading notifications:', error);
            notificationList.innerHTML = '<div class="px-4 py-3 text-sm text-red-500 text-center">Lỗi tải thông báo</div>';
        }
    }
    
    displayNotifications(notifications) {
        const notificationList = document.getElementById('notification-list');
        if (!notificationList) return;
        
        let html = '';
        notifications.forEach(notification => {
            const timeElapsed = this.formatTimeElapsed(notification.createdAt);
            const priorityColor = this.getPriorityColor(notification.priority);
            
            html += `
                <div class="px-4 py-3 hover:bg-gray-50 border-b border-gray-100 cursor-pointer" onclick="headerNotificationSystem.markAsReadAndRedirect(${notification.notificationId})">
                    <div class="flex items-start">
                        <div class="flex-shrink-0">
                            <div class="w-2 h-2 ${priorityColor} rounded-full mt-2"></div>
                        </div>
                        <div class="ml-3 flex-1">
                            <p class="text-sm font-medium text-spa-dark line-clamp-2">${this.escapeHtml(notification.title)}</p>
                            <p class="text-xs text-gray-500 mt-1">${timeElapsed}</p>
                        </div>
                    </div>
                </div>
            `;
        });
        
        notificationList.innerHTML = html;
    }
    
    formatTimeElapsed(timestamp) {
        const now = new Date();
        const created = new Date(timestamp);
        const diff = now - created;
        
        const minutes = Math.floor(diff / (1000 * 60));
        const hours = Math.floor(diff / (1000 * 60 * 60));
        const days = Math.floor(diff / (1000 * 60 * 60 * 24));
        
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
    
    getPriorityColor(priority) {
        switch (priority) {
            case 'URGENT': return 'bg-red-500';
            case 'HIGH': return 'bg-orange-500';
            case 'MEDIUM': return 'bg-yellow-500';
            case 'LOW': return 'bg-green-500';
            default: return 'bg-blue-500';
        }
    }
    
    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
    
    async markAsReadAndRedirect(notificationId) {
        try {
            // Mark as read
            const formData = new FormData();
            formData.append('action', 'mark_as_read');
            formData.append('notificationId', notificationId);
            
            await fetch(`${this.contextPath}/notifications`, {
                method: 'POST',
                body: formData
            });
            
            // Redirect to notifications page
            window.location.href = `${this.contextPath}/notifications`;
        } catch (error) {
            console.error('[HEADER-NOTIFICATIONS] Error marking notification as read:', error);
            // Still redirect even if marking as read fails
            window.location.href = `${this.contextPath}/notifications`;
        }
    }
    
    // Public method to manually refresh notifications
    refresh() {
        this.updateNotificationCount();
    }
    
    // Public method to show a temporary notification count (for testing)
    showTestNotification(count = 1) {
        this.updateNotificationBadge(count);
        console.log(`[HEADER-NOTIFICATIONS] Test notification badge shown with count: ${count}`);
    }
}

// Initialize the header notification system when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.headerNotificationSystem = new HeaderNotificationSystem();
});

// Also initialize if DOM is already loaded
if (document.readyState === 'loading') {
    // DOM is still loading, wait for DOMContentLoaded
} else {
    // DOM is already loaded, initialize immediately
    setTimeout(() => {
        if (!window.headerNotificationSystem) {
            window.headerNotificationSystem = new HeaderNotificationSystem();
        }
    }, 100);
}
