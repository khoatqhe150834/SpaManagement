<%--
    Document   : sidebar.jsp
    Refactored to match the main site's visual style (Tailwind CSS & Lucide Icons)
    Author     : G1_SpaManagement Team
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User, model.Customer, model.RoleConstants, java.util.List, model.MenuService, model.MenuService.MenuItem" %>

<%
    // --- User and Role Detection ---
    String userRole = "GUEST"; // Default role
    Object userObject = null;
    
    // Fallback to session attributes if request attributes are not set
    if (session.getAttribute("user") != null) {
        userObject = session.getAttribute("user");
    } else if (session.getAttribute("customer") != null) {
        userObject = session.getAttribute("customer");
    }

    String fullName = "Guest User";
    String email = "guest@example.com";
    String avatarUrl = null; // Initialize as null to handle empty case better

    if (userObject instanceof User) {
        User user = (User) userObject;
        userRole = RoleConstants.getUserTypeFromRole(user.getRoleId());
        fullName = user.getFullName();
        email = user.getEmail();
        String userAvatar = user.getAvatarUrl();
        if (userAvatar != null && !userAvatar.trim().isEmpty()) {
            // Handle both absolute URLs and relative paths
            if (userAvatar.startsWith("http://") || userAvatar.startsWith("https://")) {
                avatarUrl = userAvatar;
            } else {
                avatarUrl = request.getContextPath() + (userAvatar.startsWith("/") ? "" : "/") + userAvatar;
            }
        }
    } else if (userObject instanceof Customer) {
        Customer customer = (Customer) userObject;
        userRole = "CUSTOMER";
        fullName = customer.getFullName();
        email = customer.getEmail();
        String customerAvatar = customer.getAvatarUrl();
        if (customerAvatar != null && !customerAvatar.trim().isEmpty()) {
            // Handle both absolute URLs and relative paths
            if (customerAvatar.startsWith("http://") || customerAvatar.startsWith("https://")) {
                avatarUrl = customerAvatar;
            } else {
                avatarUrl = request.getContextPath() + (customerAvatar.startsWith("/") ? "" : "/") + customerAvatar;
            }
        }
    }

    // Set default avatar if none is provided
    if (avatarUrl == null || avatarUrl.trim().isEmpty()) {
        avatarUrl = request.getContextPath() + "/assets/home/images/default-avatar.png";
    }

    pageContext.setAttribute("userRole", userRole);
    pageContext.setAttribute("contextPath", request.getContextPath());
    pageContext.setAttribute("fullName", fullName);
    pageContext.setAttribute("email", email);
    pageContext.setAttribute("avatarUrl", avatarUrl);
%>

<!-- Mobile overlay -->
<div id="sidebar-overlay" class="fixed inset-0 bg-black bg-opacity-50 z-40 lg:hidden hidden"></div>

<!-- Sidebar -->
<aside id="main-sidebar" class="sticky top-[4.5rem] h-[calc(100vh-7rem)] my-4 z-40 w-80 bg-white shadow-xl transform transition-transform duration-300 ease-in-out lg:translate-x-0 -translate-x-full flex flex-col">
    <!-- Header -->
    <div class="flex items-center justify-between h-16 px-6 border-b border-gray-200 bg-[#D4AF37] flex-shrink-0">
        <a href="${pageContext.request.contextPath}/dashboard" class="flex items-center" title="Go to Dashboard">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" data-lucide="heart" class="lucide lucide-heart h-8 w-8 text-white mr-3"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"></path></svg>
            <div class="text-white">
                <div class="text-lg font-bold font-serif">Spa Hương Sen</div>
                <div class="text-xs opacity-90 uppercase tracking-wider">${userRole} PORTAL</div>
            </div>
        </a>
        <button id="close-sidebar-btn" class="lg:hidden text-white hover:text-gray-200 transition-colors">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" data-lucide="x" class="lucide lucide-x h-6 w-6"><path d="M18 6 6 18"></path><path d="m6 6 12 12"></path></svg>
        </button>
    </div>

    <!-- Navigation -->
    <nav class="flex-1 px-4 py-4 overflow-y-auto">
        <h3 class="px-4 pb-2 text-sm font-semibold uppercase text-gray-400 tracking-wider">Tổng quan</h3>
        <div class="space-y-1">
            <c:choose>
                <c:when test="${userRole == 'CUSTOMER'}">
                    <!-- Customer Portal -->
                    <div class="nav-item">
                        <button class="nav-button nav-expandable w-full flex items-center justify-between px-4 py-2.5 rounded-lg transition-all duration-200 group text-gray-700 hover:bg-[#FFF8F0]" 
                                data-item-id="customer-portal">
                            <div class="flex items-center">
                                <i data-lucide="user" class="h-5 w-5 mr-3 text-gray-500 group-hover:text-[#D4AF37]"></i>
                                <span class="font-medium text-base">Khách hàng</span>
                            </div>
                            <i data-lucide="chevron-right" class="h-5 w-5 transition-transform duration-200"></i>
                        </button>
                        
                        <div class="submenu ml-4 mt-1 space-y-1 pl-4 hidden">
                            <a href="${pageContext.request.contextPath}/customer/view" class="nav-button w-full flex items-center justify-between px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                    data-item-id="my-appointments">
                                <div class="flex items-center">
                                    <i data-lucide="calendar" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                                    <span>Lịch hẹn của tôi</span>
                                </div>
                                <span class="text-sm font-semibold px-2.5 py-1 rounded-full bg-yellow-400 text-yellow-900">3</span>
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/booking" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                    data-item-id="book-services">
                                <i data-lucide="calendar-plus" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                                <span>Đặt dịch vụ</span>
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/customer/history" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                    data-item-id="treatment-history">
                                <i data-lucide="history" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                                <span>Lịch sử điều trị</span>
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/profile" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                    data-item-id="personal-profile">
                                <i data-lucide="user-cog" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                                <span>Hồ sơ cá nhân</span>
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/password/change" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                    data-item-id="change-password">
                                <i data-lucide="key" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                                <span>Đổi mật khẩu</span>
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/customer/payments" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                    data-item-id="payment-history">
                                <i data-lucide="credit-card" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                                <span>Lịch sử thanh toán</span>
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/customer/loyalty" class="nav-button w-full flex items-center justify-between px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                    data-item-id="loyalty-points">
                                <div class="flex items-center">
                                    <i data-lucide="gift" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                                    <span>Điểm tích lũy</span>
                                </div>
                                <span class="text-sm font-semibold px-2.5 py-1 rounded-full bg-yellow-400 text-yellow-900">2,450</span>
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/promotions" class="nav-button w-full flex items-center justify-between px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                    data-item-id="special-offers">
                                <div class="flex items-center">
                                    <i data-lucide="star" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                                    <span>Ưu đãi đặc biệt</span>
                                </div>
                                <span class="bg-red-500 text-white text-sm font-semibold px-2.5 py-1 rounded-full animate-pulse">Mới</span>
                            </a>
                        </div>
                    </div>
                </c:when>

                <c:when test="${userRole == 'MANAGER' || userRole == 'ADMIN'}">
                    <!-- Manager Dashboard -->
                    <a href="${pageContext.request.contextPath}/dashboard" class="nav-button w-full flex items-center px-4 py-2.5 rounded-lg transition-all duration-200 group text-gray-700 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                        data-item-id="dashboard">
                        <i data-lucide="layout-dashboard" class="h-5 w-5 mr-3 text-gray-500 group-hover:text-[#D4AF37]"></i>
                        <span class="font-medium text-base">Dashboard</span>
                    </a>
                    <div class="nav-item">
                        <button class="nav-button nav-expandable w-full flex items-center justify-between px-4 py-2.5 rounded-lg transition-all duration-200 group text-gray-700 hover:bg-[#FFF8F0]" 
                                data-item-id="manager-dashboard">
                            <div class="flex items-center">
                                <i data-lucide="briefcase" class="h-5 w-5 mr-3 text-gray-500 group-hover:text-[#D4AF37]"></i>
                                <span class="font-medium text-base">Quản lý</span>
                            </div>
                            <i data-lucide="chevron-right" class="h-5 w-5 transition-transform duration-200"></i>
                        </button>
                        
                        <div class="submenu ml-4 mt-1 space-y-1 pl-4 hidden">
                            <a href="${pageContext.request.contextPath}/manager/service" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                    data-item-id="service-management">
                                <i data-lucide="list-checks" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                                <span>Quản lý dịch vụ</span>
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/manager/servicetype" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                    data-item-id="servicetype-management">
                                <i data-lucide="tag" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                                <span>Quản lý loại dịch vụ</span>
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/staff" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                    data-item-id="staff-management">
                                <i data-lucide="users" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                                <span>Quản lý nhân viên</span>
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/user/list" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                    data-item-id="user-management">
                                <i data-lucide="user-check" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                                <span>Quản lý người dùng</span>
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/category/list" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                    data-item-id="category-management">
                                <i data-lucide="folder" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                                <span>Quản lý danh mục</span>
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/blog" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                    data-item-id="blog-management">
                                <i data-lucide="edit" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                                <span>Quản lý blog</span>
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/spa-info" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                    data-item-id="spa-info">
                                <i data-lucide="info" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                                <span>Thông tin Spa</span>
                            </a>
                        </div>
                    </div>
                </c:when>
                
                <c:when test="${userRole == 'MARKETING' || userRole == 'ADMIN' || userRole == 'MANAGER'}">
                     <!-- Marketing Portal -->
                    <div class="nav-item">
                        <button class="nav-button nav-expandable w-full flex items-center justify-between px-4 py-2.5 rounded-lg transition-all duration-200 group text-gray-700 hover:bg-[#FFF8F0]" 
                                data-item-id="marketing-portal">
                            <div class="flex items-center">
                                <i data-lucide="megaphone" class="h-5 w-5 mr-3 text-gray-500 group-hover:text-[#D4AF37]"></i>
                                <span class="font-medium text-base">Marketing</span>
                            </div>
                            <i data-lucide="chevron-right" class="h-5 w-5 transition-transform duration-200"></i>
                        </button>
                        
                        <div class="submenu ml-4 mt-1 space-y-1 pl-4 hidden">
                            <a href="${pageContext.request.contextPath}/promotion/list" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                    data-item-id="promotion-management">
                                <i data-lucide="gift" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                                <span>Quản lý khuyến mãi</span>
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/promotions" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                    data-item-id="promotion-display">
                                <i data-lucide="star" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                                <span>Xem khuyến mãi</span>
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/service-review" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                    data-item-id="service-reviews">
                                <i data-lucide="message-circle" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                                <span>Đánh giá dịch vụ</span>
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/qr/generate" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                    data-item-id="qr-codes">
                                <i data-lucide="qr-code" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                                <span>Tạo mã QR</span>
                            </a>
                        </div>
                    </div>
                </c:when>
            </c:choose>

            <c:if test="${userRole == 'ADMIN'}">
                <!-- Admin Panel -->
                <div class="nav-item">
                    <button class="nav-button nav-expandable w-full flex items-center justify-between px-4 py-2.5 rounded-lg transition-all duration-200 group text-gray-700 hover:bg-[#FFF8F0]" 
                            data-item-id="admin-panel">
                        <div class="flex items-center">
                            <i data-lucide="shield" class="h-5 w-5 mr-3 text-gray-500 group-hover:text-[#D4AF37]"></i>
                            <span class="font-medium text-base">Quản trị hệ thống</span>
                        </div>
                        <i data-lucide="chevron-right" class="h-5 w-5 transition-transform duration-200"></i>
                    </button>
                    
                    <div class="submenu ml-4 mt-1 space-y-1 pl-4 hidden">
                        <a href="${pageContext.request.contextPath}/customer/list" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                data-item-id="customer-management">
                            <i data-lucide="users" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                            <span>Quản lý khách hàng</span>
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/test" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                data-item-id="system-test">
                            <i data-lucide="test-tube" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                            <span>Kiểm tra hệ thống</span>
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/autocheckin" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                data-item-id="auto-checkin">
                            <i data-lucide="clock" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                            <span>Tự động check-in</span>
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/admin/settings" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                data-item-id="system-settings">
                            <i data-lucide="settings" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                            <span>Cài đặt hệ thống</span>
                        </a>
                    </div>
                </div>
            </c:if>

            <c:if test="${userRole == 'THERAPIST' || userRole == 'MANAGER' || userRole == 'ADMIN'}">
                <!-- Therapist Interface -->
                <div class="nav-item">
                    <button class="nav-button nav-expandable w-full flex items-center justify-between px-4 py-2.5 rounded-lg transition-all duration-200 group text-gray-700 hover:bg-[#FFF8F0]" 
                            data-item-id="therapist-interface">
                        <div class="flex items-center">
                            <i data-lucide="user-round" class="h-5 w-5 mr-3 text-gray-500 group-hover:text-[#D4AF37]"></i>
                            <span class="font-medium text-base">Nhân viên</span>
                        </div>
                        <i data-lucide="chevron-right" class="h-5 w-5 transition-transform duration-200"></i>
                    </button>
                    
                    <div class="submenu ml-4 mt-1 space-y-1 pl-4 hidden">
                        <a href="${pageContext.request.contextPath}/therapist/schedule" class="nav-button w-full flex items-center justify-between px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                data-item-id="daily-schedule">
                            <div class="flex items-center">
                                <i data-lucide="clock" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                                <span>Lịch làm việc hôm nay</span>
                            </div>
                            <span class="text-xs font-semibold px-2 py-0.5 rounded-full bg-yellow-400 text-yellow-900">8</span>
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/appointment" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                data-item-id="appointment-management">
                            <i data-lucide="calendar" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                            <span>Quản lý lịch hẹn</span>
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/therapist/clients" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                data-item-id="client-records">
                            <i data-lucide="file-text" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                            <span>Hồ sơ khách hàng</span>
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/therapist/notes" class="nav-button w-full flex items-center px-3 py-2.5 rounded-md transition-all duration-200 text-base group text-gray-600 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                                data-item-id="treatment-notes">
                            <i data-lucide="book-open" class="h-5 w-5 mr-3 text-gray-400 group-hover:text-[#D4AF37]"></i>
                            <span>Ghi chú điều trị</span>
                        </a>
                    </div>
                </div>
            </c:if>

            <div class="px-4 pt-2 pb-2">
                <div class="border-t border-gray-200"></div>
            </div>
            
            <!-- Common Pages (All roles) -->
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/services" class="nav-button w-full flex items-center px-4 py-2.5 rounded-lg transition-all duration-200 group text-gray-700 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                        data-item-id="services">
                    <i data-lucide="sparkles" class="h-5 w-5 mr-3 text-gray-500 group-hover:text-[#D4AF37]"></i>
                    <span class="font-medium text-base">Dịch vụ</span>
                </a>
            </div>
            
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/about" class="nav-button w-full flex items-center px-4 py-2.5 rounded-lg transition-all duration-200 group text-gray-700 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                        data-item-id="about">
                    <i data-lucide="info" class="h-5 w-5 mr-3 text-gray-500 group-hover:text-[#D4AF37]"></i>
                    <span class="font-medium text-base">Về chúng tôi</span>
                </a>
            </div>
            
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/contact" class="nav-button w-full flex items-center px-4 py-2.5 rounded-lg transition-all duration-200 group text-gray-700 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                        data-item-id="contact">
                    <i data-lucide="phone" class="h-5 w-5 mr-3 text-gray-500 group-hover:text-[#D4AF37]"></i>
                    <span class="font-medium text-base">Liên hệ</span>
                </a>
            </div>
            
            <!-- Settings (All roles) -->
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/profile" class="nav-button w-full flex items-center px-4 py-2.5 rounded-lg transition-all duration-200 group text-gray-700 hover:bg-[#FFF8F0] hover:text-[#D4AF37]" 
                        data-item-id="settings">
                    <i data-lucide="settings" class="h-5 w-5 mr-3 text-gray-500 group-hover:text-[#D4AF37]"></i>
                    <span class="font-medium text-base">Cài đặt</span>
                </a>
            </div>
        </div>
    </nav>

    <!-- User Profile & Logout -->
    <div class="border-t border-gray-200 p-2">
        <a href="${pageContext.request.contextPath}/profile" class="block w-full p-2 hover:bg-[#FFF8F0] rounded-lg mb-1 group">
            <div class="flex items-center">
                <div class="flex-1 min-w-0">
                    <p class="text-base font-semibold text-gray-800 truncate group-hover:text-[#D4AF37] transition-colors">${fullName}</p>
                    <p class="text-sm text-gray-500 capitalize">${userRole.toLowerCase()}</p>
                </div>
            </div>
        </a>
        
        <button id="logout-btn" class="flex items-center w-full px-2 py-2.5 text-base text-gray-600 hover:text-red-600 hover:bg-red-50 rounded-lg transition-all duration-200 group">
            <i data-lucide="log-out" class="h-5 w-5 mr-3 group-hover:scale-110 transition-transform"></i>
            <span class="font-medium">Đăng xuất</span>
        </button>
    </div>
</aside>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        class SidebarManager {
            constructor(userRole) {
                this.sidebar = document.getElementById('main-sidebar');
                if (!this.sidebar) {
                    console.error("Sidebar element #main-sidebar not found.");
                    return;
                }

                this.overlay = document.getElementById('sidebar-overlay');
                this.closeSidebarBtn = document.getElementById('close-sidebar-btn');
                this.logoutBtn = document.getElementById('logout-btn');
                this.navButtons = this.sidebar.querySelectorAll('.nav-button');
                
                this.userRole = userRole;
                this.activeItem = null;
                this.expandedItems = new Set();
                
                this.init();
            }

            init() {
                this.autoExpandRoleMenu();
                this.initEventListeners();
                this.detectActiveItem();

                // Make toggle function globally available
                window.toggleSidebar = () => this.toggleSidebar();
                
                if (window.lucide) {
                    lucide.createIcons();
                }
            }

            autoExpandRoleMenu() {
                let roleMenuId = '';
                switch (this.userRole) {
                    case 'CUSTOMER': roleMenuId = 'customer-portal'; break;
                    case 'MANAGER': roleMenuId = 'manager-dashboard'; break;
                    case 'ADMIN': roleMenuId = 'admin-panel'; break;
                    case 'THERAPIST': roleMenuId = 'therapist-interface'; break;
                    case 'MARKETING': roleMenuId = 'marketing-portal'; break;
                }
                
                if (roleMenuId) {
                    this.expandedItems.add(roleMenuId);
                }
            }
            
            detectActiveItem() {
                const currentPath = window.location.pathname;
                let bestMatch = null;

                this.navButtons.forEach(button => {
                    const buttonPath = button.getAttribute('href');
                    if (buttonPath && currentPath.includes(buttonPath)) {
                        if (!bestMatch || buttonPath.length > (bestMatch.getAttribute('href') || '').length) {
                            bestMatch = button;
                        }
                    }
                });
                
                if (bestMatch) {
                    const itemId = bestMatch.dataset.itemId;
                    this.setActiveItem(itemId);

                    // Auto-expand parent menu if a child is active
                    const parentMenu = bestMatch.closest('.submenu');
                    if (parentMenu) {
                        const parentButton = parentMenu.previousElementSibling;
                        if(parentButton && parentButton.dataset.itemId) {
                            this.expandedItems.add(parentButton.dataset.itemId);
                        }
                    }
                } else if (currentPath.endsWith('/dashboard')) {
                    this.setActiveItem('dashboard');
                }
                this.updateExpandedState();
                this.updateActiveState();
            }

            initEventListeners() {
                this.sidebar.addEventListener('click', (e) => {
                    const button = e.target.closest('.nav-button');
                    if (!button) return;

                    // For expandable buttons, prevent navigation and toggle submenu
                    if (button.classList.contains('nav-expandable')) {
                        e.preventDefault();
                        const itemId = button.dataset.itemId;
                        this.toggleExpanded(itemId);
                    }
                });

                this.closeSidebarBtn?.addEventListener('click', () => this.closeSidebar());
                this.overlay?.addEventListener('click', () => this.closeSidebar());
                
                this.logoutBtn?.addEventListener('click', () => {
                    if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
                        const contextPath = '${pageContext.request.contextPath}';
                        window.location.href = `${pageContext.request.contextPath}/logout`;
                    }
                });
            }

            toggleSidebar() {
                if (this.sidebar.classList.contains('-translate-x-full')) {
                    this.openSidebar();
                } else {
                    this.closeSidebar();
                }
            }

            openSidebar() {
                this.sidebar.classList.remove('-translate-x-full');
                this.overlay?.classList.remove('hidden');
            }

            closeSidebar() {
                this.sidebar.classList.add('-translate-x-full');
                this.overlay?.classList.add('hidden');
            }

            toggleExpanded(itemId) {
                if (this.expandedItems.has(itemId)) {
                    this.expandedItems.delete(itemId);
                } else {
                    this.expandedItems.add(itemId);
                }
                this.updateExpandedState();
            }
            
            updateExpandedState() {
                this.sidebar.querySelectorAll('.nav-expandable').forEach(button => {
                    const itemId = button.dataset.itemId;
                    const submenu = button.nextElementSibling;
                    const chevron = button.querySelector('[data-lucide="chevron-right"]');

                    if (this.expandedItems.has(itemId)) {
                        submenu?.classList.remove('hidden');
                        chevron?.classList.add('rotate-90');
                        button.classList.add('bg-[#FFF8F0]', 'text-[#D4AF37]');
                    } else {
                        submenu?.classList.add('hidden');
                        chevron?.classList.remove('rotate-90');
                        button.classList.remove('bg-[#FFF8F0]', 'text-[#D4AF37]');
                    }
                });
            }

            setActiveItem(itemId) {
                if (!itemId) return;
                this.activeItem = itemId;
                this.updateActiveState();
            }

            updateActiveState() {
                this.navButtons.forEach(btn => {
                    const icon = btn.querySelector('i[data-lucide]');
                    if (btn.dataset.itemId === this.activeItem && !btn.classList.contains('nav-expandable')) {
                        btn.classList.add('bg-[#D4AF37]', 'text-white', 'shadow-inner');
                        btn.classList.remove('text-gray-600', 'hover:bg-[#FFF8F0]', 'hover:text-[#D4AF37]');
                        icon?.classList.add('text-white');
                        icon?.classList.remove('text-gray-400', 'text-gray-500');
                    }
                });
            }
        }

        new SidebarManager('${userRole}');
    });
</script> 