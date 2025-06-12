<%-- 
    Document   : sidebar.jsp
    Created on : Customer Dashboard Sidebar
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%-- Customer Dashboard Sidebar Navigation - Using Admin Framework Styles --%>
<aside class="sidebar">
    <button type="button" class="sidebar-close-btn">
        <iconify-icon icon="radix-icons:cross-2"></iconify-icon>
    </button>
    <div>
        <a href="${pageContext.request.contextPath}/customer-dashboard" class="sidebar-logo">
            <img src="${pageContext.request.contextPath}/assets/admin/images/logo.png" alt="BeautyZone Spa" class="light-logo">
            <img src="${pageContext.request.contextPath}/assets/admin/images/logo-light.png" alt="BeautyZone Spa" class="dark-logo">
            <img src="${pageContext.request.contextPath}/assets/admin/images/logo-icon.png" alt="BeautyZone Spa" class="logo-icon">
        </a>
    </div>
    <div class="sidebar-menu-area">
        <ul class="sidebar-menu" id="sidebar-menu">
            <li>
                <a href="${pageContext.request.contextPath}/dashboard/customer" class="active-page">
                    <iconify-icon icon="solar:home-smile-angle-outline" class="menu-icon"></iconify-icon>
                    <span>Bảng Điều Khiển</span>
                </a>
            </li>
            
            <li class="dropdown">
                <a href="javascript:void(0)">
                    <iconify-icon icon="solar:calendar-outline" class="menu-icon"></iconify-icon>
                    <span>Lịch Hẹn</span>
                </a>
                <ul class="sidebar-submenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/dashboard/customer/appointments/booking">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Đặt Lịch Hẹn
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/dashboard/customer/appointments/upcoming">
                            <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Lịch Hẹn Sắp Tới
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/dashboard/customer/appointments/history">
                            <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Lịch Sử Lịch Hẹn
                        </a>
                    </li>
                </ul>
            </li>
            
            <li>
                <a href="${pageContext.request.contextPath}/dashboard/customer/treatments/history">
                    <iconify-icon icon="solar:file-text-outline" class="menu-icon"></iconify-icon>
                    <span>Lịch Sử Liệu Pháp</span>
                </a>
            </li>
            
            <li class="dropdown">
                <a href="javascript:void(0)">
                    <iconify-icon icon="solar:gift-outline" class="menu-icon"></iconify-icon>
                    <span>Phần Thưởng & Điểm</span>
                </a>
                <ul class="sidebar-submenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/dashboard/customer/rewards/points">
                            <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Điểm Thưởng
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/dashboard/customer/rewards/rewards-list">
                            <i class="ri-circle-fill circle-icon text-danger-main w-auto"></i> Đổi Thưởng
                        </a>
                    </li>
                </ul>
            </li>
            
            <li>
                <a href="${pageContext.request.contextPath}/dashboard/customer/recommendations/services">
                    <iconify-icon icon="solar:bag-smile-outline" class="menu-icon"></iconify-icon>
                    <span>Đề Xuất Dành Cho Bạn</span>
                </a>
            </li>
            
            <li>
                <a href="${pageContext.request.contextPath}/dashboard/customer/reviews/my-reviews">
                    <iconify-icon icon="solar:star-outline" class="menu-icon"></iconify-icon>
                    <span>Đánh Giá Của Tôi</span>
                </a>
            </li>
            
            <li class="dropdown">
                <a href="javascript:void(0)">
                    <iconify-icon icon="solar:card-outline" class="menu-icon"></iconify-icon>
                    <span>Thanh Toán & Hóa Đơn</span>
                </a>
                <ul class="sidebar-submenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/dashboard/customer/billing/payments">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Lịch Sử Thanh Toán
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/dashboard/customer/billing/invoices">
                            <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Hóa Đơn
                        </a>
                    </li>
                </ul>
            </li>
            
            <li class="sidebar-menu-group-title">Tài Khoản</li>
            
            <li>
                <a href="${pageContext.request.contextPath}/dashboard/customer/dashboard/profile">
                    <iconify-icon icon="solar:user-outline" class="menu-icon"></iconify-icon>
                    <span>Thông Tin Cá Nhân</span>
                </a>
            </li>
            
            <li>
                <a href="${pageContext.request.contextPath}/dashboard/customer/dashboard/notifications">
                    <iconify-icon icon="solar:bell-outline" class="menu-icon"></iconify-icon>
                    <span>Thông Báo</span>
                </a>
            </li>
            
            <li>
                <a href="${pageContext.request.contextPath}/logout">
                    <iconify-icon icon="solar:logout-2-outline" class="menu-icon"></iconify-icon>
                    <span>Đăng Xuất</span>
                </a>
            </li>
        </ul>
    </div>
</aside>

 