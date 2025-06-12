<%-- 
    Document   : sidebar.jsp
    Created on : Manager Dashboard Sidebar
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%-- Manager Dashboard Sidebar Navigation - Using Admin Framework Styles --%>
<aside class="sidebar">
    <button type="button" class="sidebar-close-btn">
        <iconify-icon icon="radix-icons:cross-2"></iconify-icon>
    </button>
    <div>
        <a href="${pageContext.request.contextPath}/manager-dashboard" class="sidebar-logo">
            <img src="${pageContext.request.contextPath}/assets/admin/images/logo.png" alt="BeautyZone Spa" class="light-logo">
            <img src="${pageContext.request.contextPath}/assets/admin/images/logo-light.png" alt="BeautyZone Spa" class="dark-logo">
            <img src="${pageContext.request.contextPath}/assets/admin/images/logo-icon.png" alt="BeautyZone Spa" class="logo-icon">
        </a>
    </div>
    <div class="sidebar-menu-area">
        <ul class="sidebar-menu" id="sidebar-menu">
            <li>
                <a href="${pageContext.request.contextPath}/manager-dashboard" class="active-page">
                    <iconify-icon icon="solar:widget-6-outline" class="menu-icon"></iconify-icon>
                    <span>Tổng Quan</span>
                </a>
            </li>
            
            <li class="sidebar-menu-group-title">Quản Lý Chính</li>
            
            <li class="dropdown">
                <a href="javascript:void(0)">
                    <iconify-icon icon="solar:users-group-two-rounded-outline" class="menu-icon"></iconify-icon>
                    <span>Quản Lý Khách Hàng</span>
                </a>
                <ul class="sidebar-submenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/manager-dashboard/customers/list">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Danh Sách Khách Hàng
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/manager-dashboard/customers/categories">
                            <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Phân Loại Khách Hàng
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/manager-dashboard/customers/history">
                            <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Lịch Sử Sử Dụng
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/manager-dashboard/customers/notes">
                            <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Ghi Chú Đặc Biệt
                        </a>
                    </li>
                </ul>
            </li>
            
            <li class="dropdown">
                <a href="javascript:void(0)">
                    <iconify-icon icon="solar:spa-outline" class="menu-icon"></iconify-icon>
                    <span>Quản Lý Dịch Vụ</span>
                </a>
                <ul class="sidebar-submenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/manager-dashboard/services/packages">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Gói Dịch Vụ
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/manager-dashboard/services/pricing">
                            <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Giá & Khuyến Mãi
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/manager-dashboard/services/media">
                            <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Hình Ảnh & Mô Tả
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/manager-dashboard/services/analytics">
                            <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Phân Tích Dịch Vụ
                        </a>
                    </li>
                </ul>
            </li>
            
            <li class="dropdown">
                <a href="javascript:void(0)">
                    <iconify-icon icon="solar:users-group-rounded-outline" class="menu-icon"></iconify-icon>
                    <span>Quản Lý Nhân Viên</span>
                </a>
                <ul class="sidebar-submenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/manager-dashboard/staff/list">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Danh Sách Nhân Viên
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/manager-dashboard/staff/schedules">
                            <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Lịch Làm Việc
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/manager-dashboard/staff/performance">
                            <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Thống Kê Hiệu Suất
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/manager-dashboard/staff/assignments">
                            <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Phân Công Công Việc
                        </a>
                    </li>
                </ul>
            </li>
            
            <li class="sidebar-menu-group-title">Báo Cáo & Thống Kê</li>
            
            <li class="dropdown">
                <a href="javascript:void(0)">
                    <iconify-icon icon="solar:chart-2-outline" class="menu-icon"></iconify-icon>
                    <span>Báo Cáo Doanh Thu</span>
                </a>
                <ul class="sidebar-submenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/manager-dashboard/reports/revenue">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Báo Cáo Chi Tiết
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/manager-dashboard/dashboard/revenue">
                            <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Tổng Quan Doanh Thu
                        </a>
                    </li>
                </ul>
            </li>
            
            <li class="dropdown">
                <a href="javascript:void(0)">
                    <iconify-icon icon="solar:graph-up-outline" class="menu-icon"></iconify-icon>
                    <span>Phân Tích & Thống Kê</span>
                </a>
                <ul class="sidebar-submenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/manager-dashboard/reports/customers">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Thống Kê Khách Hàng
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/manager-dashboard/reports/trends">
                            <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Xu Hướng Dịch Vụ
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/manager-dashboard/dashboard/appointments">
                            <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Thống Kê Đặt Lịch
                        </a>
                    </li>
                </ul>
            </li>
            
            <li>
                <a href="${pageContext.request.contextPath}/manager-dashboard/reports/reviews">
                    <iconify-icon icon="solar:star-outline" class="menu-icon"></iconify-icon>
                    <span>Đánh Giá Khách Hàng</span>
                </a>
            </li>
            
            <li class="sidebar-menu-group-title">Hệ Thống</li>
            
            <li>
                <a href="${pageContext.request.contextPath}/manager-dashboard/dashboard/notifications">
                    <iconify-icon icon="solar:bell-outline" class="menu-icon"></iconify-icon>
                    <span>Thông Báo Quan Trọng</span>
                </a>
            </li>
            
            <li>
                <a href="${pageContext.request.contextPath}/profile">
                    <iconify-icon icon="solar:user-outline" class="menu-icon"></iconify-icon>
                    <span>Thông Tin Cá Nhân</span>
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
