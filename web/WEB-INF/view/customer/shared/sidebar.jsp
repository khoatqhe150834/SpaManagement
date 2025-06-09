<%-- 
    Document   : sidebar.jsp
    Created on : Customer Dashboard Sidebar
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<style>
/* Customer Dashboard Sidebar Styles */
.customer-dashboard-sidebar {
    background-color: #ffffff;
    box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
    width: 16rem; /* 256px */
    min-height: 100vh;
    border-right: 1px solid #e2e8f0;
}

.dashboard-nav {
    margin-top: 2rem;
    padding: 0 1rem;
}

.nav-items-container {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
}

.nav-item {
    width: 100%;
    display: flex;
    align-items: center;
    padding: 0.75rem 1rem;
    font-size: 0.875rem;
    font-weight: 500;
    border-radius: 0.5rem;
    text-decoration: none;
    color: #4a5568;
    transition: all 0.2s ease-in-out;
    border: none;
    background: none;
    cursor: pointer;
    text-align: left;
}

.nav-item:hover {
    background-color: #f7fafc;
    color: #2d3748;
}

.nav-item.active {
    background-color: #e6fffa;
    color: #234e52;
    border-right: 2px solid #38b2ac;
}

.nav-icon {
    margin-right: 0.75rem;
    width: 1.25rem;
    height: 1.25rem;
    flex-shrink: 0;
}

/* Icon styles using Unicode symbols */
.icon-home::before { content: "🏠"; }
.icon-calendar::before { content: "📅"; }
.icon-file::before { content: "📄"; }
.icon-gift::before { content: "🎁"; }
.icon-shopping::before { content: "🛍️"; }
.icon-star::before { content: "⭐"; }
.icon-credit-card::before { content: "💳"; }
.icon-user::before { content: "👤"; }
.icon-bell::before { content: "🔔"; }
</style>

<%-- Customer Dashboard Sidebar Navigation --%>
<div class="customer-dashboard-sidebar">
    <nav class="dashboard-nav">
        <div class="nav-items-container">
            <button class="nav-item active" data-tab="dashboard" onclick="changeTab('dashboard', this)">
                <span class="nav-icon icon-home"></span>
                Dashboard
            </button>
            
            <button class="nav-item" data-tab="appointments" onclick="changeTab('appointments', this)">
                <span class="nav-icon icon-calendar"></span>
                Appointments
            </button>
            
            <button class="nav-item" data-tab="history" onclick="changeTab('history', this)">
                <span class="nav-icon icon-file"></span>
                Treatment History
            </button>
            
            <button class="nav-item" data-tab="loyalty" onclick="changeTab('loyalty', this)">
                <span class="nav-icon icon-gift"></span>
                Rewards & Points
            </button>
            
            <button class="nav-item" data-tab="products" onclick="changeTab('products', this)">
                <span class="nav-icon icon-shopping"></span>
                Recommendations
            </button>
            
            <button class="nav-item" data-tab="reviews" onclick="changeTab('reviews', this)">
                <span class="nav-icon icon-star"></span>
                Reviews
            </button>
            
            <button class="nav-item" data-tab="payments" onclick="changeTab('payments', this)">
                <span class="nav-icon icon-credit-card"></span>
                Payments & Billing
            </button>
            
            <button class="nav-item" data-tab="profile" onclick="changeTab('profile', this)">
                <span class="nav-icon icon-user"></span>
                Profile Settings
            </button>
            
            <button class="nav-item" data-tab="notifications" onclick="changeTab('notifications', this)">
                <span class="nav-icon icon-bell"></span>
                Notifications
            </button>
        </div>
    </nav>
</div>

<script>
// JavaScript for sidebar functionality
function changeTab(tabId, clickedElement) {
    // Remove active class from all nav items
    const allNavItems = document.querySelectorAll('.nav-item');
    allNavItems.forEach(item => {
        item.classList.remove('active');
    });
    
    // Add active class to clicked item
    clickedElement.classList.add('active');
    
    // Store current active tab in sessionStorage (optional)
    sessionStorage.setItem('activeTab', tabId);
    
    // Handle tab content switching based on tab ID
    switch(tabId) {
        case 'dashboard':
            window.location.href = '${pageContext.request.contextPath}/customer/dashboard';
            break;
        case 'appointments':
            window.location.href = '${pageContext.request.contextPath}/customer/appointments';
            break;
        case 'history':
            window.location.href = '${pageContext.request.contextPath}/customer/treatments/history';
            break;
        case 'loyalty':
            window.location.href = '${pageContext.request.contextPath}/customer/rewards/points';
            break;
        case 'products':
            window.location.href = '${pageContext.request.contextPath}/customer/recommendations/services';
            break;
        case 'reviews':
            window.location.href = '${pageContext.request.contextPath}/customer/reviews/my-reviews';
            break;
        case 'payments':
            window.location.href = '${pageContext.request.contextPath}/customer/billing/payments';
            break;
        case 'profile':
            window.location.href = '${pageContext.request.contextPath}/customer/dashboard/profile';
            break;
        case 'notifications':
            window.location.href = '${pageContext.request.contextPath}/customer/dashboard/notifications';
            break;
        default:
            console.log('Unknown tab:', tabId);
    }
}

// Set active tab on page load based on current URL or sessionStorage
document.addEventListener('DOMContentLoaded', function() {
    const currentPath = window.location.pathname;
    const savedTab = sessionStorage.getItem('activeTab');
    
    // Determine active tab based on current URL
    let activeTabId = 'dashboard'; // default
    
    if (currentPath.includes('/appointments')) {
        activeTabId = 'appointments';
    } else if (currentPath.includes('/treatments')) {
        activeTabId = 'history';
    } else if (currentPath.includes('/rewards')) {
        activeTabId = 'loyalty';
    } else if (currentPath.includes('/recommendations')) {
        activeTabId = 'products';
    } else if (currentPath.includes('/reviews')) {
        activeTabId = 'reviews';
    } else if (currentPath.includes('/billing')) {
        activeTabId = 'payments';
    } else if (currentPath.includes('/profile')) {
        activeTabId = 'profile';
    } else if (currentPath.includes('/notifications')) {
        activeTabId = 'notifications';
    }
    
    // Set the active state
    const allNavItems = document.querySelectorAll('.nav-item');
    allNavItems.forEach(item => {
        item.classList.remove('active');
        if (item.dataset.tab === activeTabId) {
            item.classList.add('active');
        }
    });
});
</script> 