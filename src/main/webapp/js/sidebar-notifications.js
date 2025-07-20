/**
 * Sidebar Notifications JavaScript
 * Handles notification badge updates in the sidebar for managers and admins
 * 
 * @author SpaManagement
 */

class SidebarNotificationSystem {
    constructor() {
        this.contextPath = this.getContextPath();
        this.init();
    }
    
    init() {
        console.log('[SIDEBAR-NOTIFICATIONS] Initializing Sidebar Notification System...');
        this.setupAutoRefresh();
        this.loadInitialCounts();
        console.log('[SIDEBAR-NOTIFICATIONS] System initialized');
    }
    
    getContextPath() {
        // Get context path from current URL
        const path = window.location.pathname;
        const contextPath = path.substring(0, path.indexOf('/', 1));
        return contextPath || '';
    }
    
    setupAutoRefresh() {
        // Auto-refresh notification counts every 30 seconds
        setInterval(() => {
            this.updateAllNotificationCounts();
        }, 30000);
        
        // Handle page visibility change
        document.addEventListener('visibilitychange', () => {
            if (!document.hidden) {
                this.updateAllNotificationCounts();
            }
        });
    }
    
    loadInitialCounts() {
        // Load initial counts after a short delay to ensure DOM is ready
        setTimeout(() => {
            this.updateAllNotificationCounts();
        }, 500);
    }
    
    async updateAllNotificationCounts() {
        try {
            // Update general notifications count
            await this.updateGeneralNotificationCount();
            
            // Update payment notifications count
            await this.updatePaymentNotificationCount();
            
        } catch (error) {
            console.warn('[SIDEBAR-NOTIFICATIONS] Error updating notification counts:', error);
        }
    }
    
    async updateGeneralNotificationCount() {
        try {
            const response = await fetch(`${this.contextPath}/api/notifications/count?unreadOnly=true`);
            const data = await response.json();
            
            if (data.success) {
                this.updateSidebarBadge('Thông báo', data.data);
            }
        } catch (error) {
            console.warn('[SIDEBAR-NOTIFICATIONS] Error fetching general notification count:', error);
        }
    }
    
    async updatePaymentNotificationCount() {
        try {
            const response = await fetch(`${this.contextPath}/api/manager/payment-notifications/count?unreadOnly=true`);
            const data = await response.json();
            
            if (data.success) {
                this.updateSidebarBadge('Thông báo thanh toán', data.data);
            }
        } catch (error) {
            console.warn('[SIDEBAR-NOTIFICATIONS] Error fetching payment notification count:', error);
        }
    }
    
    updateSidebarBadge(menuLabel, count) {
        // Find the menu item by its text content
        const menuItems = document.querySelectorAll('.sidebar-nav-container a');
        
        menuItems.forEach(menuItem => {
            const textSpan = menuItem.querySelector('span');
            if (textSpan && textSpan.textContent.trim() === menuLabel) {
                this.updateMenuItemBadge(menuItem, count);
            }
        });
    }
    
    updateMenuItemBadge(menuItem, count) {
        const numericCount = parseInt(count) || 0;
        
        // Find existing badge or create new one
        let badge = menuItem.querySelector('.notification-badge');
        
        if (numericCount > 0) {
            if (!badge) {
                // Create new badge
                badge = document.createElement('span');
                badge.className = 'notification-badge md:block px-2 py-0.5 ml-auto text-xs font-medium tracking-wide text-white bg-red-500 rounded-full animate-pulse';
                menuItem.appendChild(badge);
            }
            
            // Update badge content and styling
            badge.textContent = numericCount > 99 ? '99+' : numericCount.toString();
            badge.className = 'notification-badge md:block px-2 py-0.5 ml-auto text-xs font-medium tracking-wide text-white bg-red-500 rounded-full';
            
            // Add pulse animation for new notifications
            badge.classList.add('animate-pulse');
            setTimeout(() => {
                if (badge) {
                    badge.classList.remove('animate-pulse');
                }
            }, 2000);
            
        } else if (badge) {
            // Remove badge if count is 0
            badge.remove();
        }
    }
    
    // Public method to manually refresh all counts
    refresh() {
        this.updateAllNotificationCounts();
    }
    
    // Public method to update a specific menu item badge (for testing)
    updateSpecificBadge(menuLabel, count) {
        this.updateSidebarBadge(menuLabel, count);
        console.log(`[SIDEBAR-NOTIFICATIONS] Updated badge for "${menuLabel}" with count: ${count}`);
    }
    
    // Public method to show test notifications
    showTestNotifications() {
        this.updateSidebarBadge('Thông báo', 5);
        this.updateSidebarBadge('Thông báo thanh toán', 3);
        console.log('[SIDEBAR-NOTIFICATIONS] Test notifications shown');
    }
    
    // Public method to clear all notification badges
    clearAllBadges() {
        const badges = document.querySelectorAll('.notification-badge');
        badges.forEach(badge => badge.remove());
        console.log('[SIDEBAR-NOTIFICATIONS] All notification badges cleared');
    }
}

// Initialize the sidebar notification system when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    // Only initialize if we're on a page with sidebar (dashboard pages)
    if (document.querySelector('.sidebar-nav-container')) {
        window.sidebarNotificationSystem = new SidebarNotificationSystem();
    }
});

// Also initialize if DOM is already loaded
if (document.readyState === 'loading') {
    // DOM is still loading, wait for DOMContentLoaded
} else {
    // DOM is already loaded, initialize immediately if sidebar exists
    setTimeout(() => {
        if (document.querySelector('.sidebar-nav-container') && !window.sidebarNotificationSystem) {
            window.sidebarNotificationSystem = new SidebarNotificationSystem();
        }
    }, 100);
}

// Export for global access
window.SidebarNotificationSystem = SidebarNotificationSystem;
