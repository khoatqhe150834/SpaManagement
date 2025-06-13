<%-- 
    Document   : sidebar.jsp
    Created on : Admin Dashboard Sidebar
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%-- Admin Dashboard Sidebar Navigation - Using Admin Framework Styles --%>
<aside class="sidebar">
    <button type="button" class="sidebar-close-btn">
        <iconify-icon icon="radix-icons:cross-2"></iconify-icon>
    </button>
    <div>
        <a href="${pageContext.request.contextPath}/admin-dashboard" class="sidebar-logo">
            <img src="${pageContext.request.contextPath}/assets/admin/images/logo.png" alt="BeautyZone Spa" class="light-logo">
            <img src="${pageContext.request.contextPath}/assets/admin/images/logo-light.png" alt="BeautyZone Spa" class="dark-logo">
            <img src="${pageContext.request.contextPath}/assets/admin/images/logo-icon.png" alt="BeautyZone Spa" class="logo-icon">
        </a>
    </div>
    <div class="sidebar-menu-area">
        <ul class="sidebar-menu" id="sidebar-menu">
            <li>
                <a href="${pageContext.request.contextPath}/admin-dashboard" class="active-page">
                    <iconify-icon icon="solar:widget-6-outline" class="menu-icon"></iconify-icon>
                    <span>Tổng Quan Hệ Thống</span>
                </a>
            </li>
            
            <li class="sidebar-menu-group-title">Quản Lý Người Dùng</li>
            
            <li class="dropdown">
                <a href="javascript:void(0)">
                    <iconify-icon icon="solar:users-group-two-rounded-outline" class="menu-icon"></iconify-icon>
                    <span>Quản Lý Users</span>
                </a>
                <ul class="sidebar-submenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/users/list">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Danh Sách Users
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/users/create">
                            <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Tạo User Mới
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/users/roles">
                            <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Quản Lý Roles
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/users/permissions">
                            <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Phân Quyền
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/users/activity">
                            <i class="ri-circle-fill circle-icon text-danger-main w-auto"></i> Hoạt Động Users
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/users/sessions">
                            <i class="ri-circle-fill circle-icon text-purple-main w-auto"></i> Phiên Đăng Nhập
                        </a>
                    </li>
                </ul>
            </li>
            
            <li class="dropdown">
                <a href="javascript:void(0)">
                    <iconify-icon icon="solar:user-heart-outline" class="menu-icon"></iconify-icon>
                    <span>Quản Lý Khách Hàng</span>
                </a>
                <ul class="sidebar-submenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/customers/list">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Danh Sách Khách Hàng
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/customers/create">
                            <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Thêm Khách Hàng
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/customers/analytics">
                            <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Phân Tích Khách Hàng
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/customers/loyalty">
                            <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Chương Trình Loyalty
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/customers/feedback">
                            <i class="ri-circle-fill circle-icon text-purple-main w-auto"></i> Feedback & Đánh Giá
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
                        <a href="${pageContext.request.contextPath}/admin/staff/list">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Danh Sách Nhân Viên
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/staff/create">
                            <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Thêm Nhân Viên
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/staff/roles">
                            <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Phân Quyền Staff
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/staff/schedules">
                            <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Lịch Làm Việc
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/staff/performance">
                            <i class="ri-circle-fill circle-icon text-purple-main w-auto"></i> Đánh Giá Hiệu Suất
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/staff/payroll">
                            <i class="ri-circle-fill circle-icon text-danger-main w-auto"></i> Quản Lý Lương
                        </a>
                    </li>
                </ul>
            </li>
            
            <li class="sidebar-menu-group-title">Quản Lý Kinh Doanh</li>
            
            <li class="dropdown">
                <a href="javascript:void(0)">
                    <iconify-icon icon="solar:spa-outline" class="menu-icon"></iconify-icon>
                    <span>Quản Lý Dịch Vụ</span>
                </a>
                <ul class="sidebar-submenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/services/list">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Danh Sách Dịch Vụ
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/services/categories">
                            <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Danh Mục Dịch Vụ
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/services/packages">
                            <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Gói Dịch Vụ
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/services/pricing">
                            <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Quản Lý Giá
                        </a>
                    </li>
                </ul>
            </li>
            
            <li class="dropdown">
                <a href="javascript:void(0)">
                    <iconify-icon icon="solar:calendar-outline" class="menu-icon"></iconify-icon>
                    <span>Quản Lý Booking</span>
                </a>
                <ul class="sidebar-submenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/bookings/list">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Tất Cả Booking
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/bookings/calendar">
                            <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Lịch Booking
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/bookings/pending">
                            <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Chờ Xác Nhận
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/bookings/settings">
                            <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Cài Đặt Booking
                        </a>
                    </li>
                </ul>
            </li>
            
            <li class="dropdown">
                <a href="javascript:void(0)">
                    <iconify-icon icon="solar:dollar-outline" class="menu-icon"></iconify-icon>
                    <span>Tài Chính</span>
                </a>
                <ul class="sidebar-submenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/financial/overview">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Tổng Quan Tài Chính
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/financial/revenue">
                            <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Doanh Thu
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/financial/expenses">
                            <i class="ri-circle-fill circle-icon text-danger-main w-auto"></i> Chi Phí
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/financial/invoices">
                            <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Hóa Đơn
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/financial/budgets">
                            <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Ngân Sách
                        </a>
                    </li>
                </ul>
            </li>
            
            <li class="sidebar-menu-group-title">Marketing & Nội Dung</li>
            
            <li class="dropdown">
                <a href="javascript:void(0)">
                    <iconify-icon icon="solar:megaphone-outline" class="menu-icon"></iconify-icon>
                    <span>Marketing</span>
                </a>
                <ul class="sidebar-submenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/marketing/campaigns">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Chiến Dích Marketing
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/marketing/promotions">
                            <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Khuyến Mãi
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/marketing/newsletters">
                            <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Newsletter
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/marketing/analytics">
                            <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Phân Tích Marketing
                        </a>
                    </li>
                </ul>
            </li>
            
            <li class="dropdown">
                <a href="javascript:void(0)">
                    <iconify-icon icon="solar:document-text-outline" class="menu-icon"></iconify-icon>
                    <span>Quản Lý Nội Dung</span>
                </a>
                <ul class="sidebar-submenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/content/pages">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Trang Web
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/content/blogs">
                            <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Blog
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/content/media">
                            <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Thư Viện Media
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/content/testimonials">
                            <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Testimonials
                        </a>
                    </li>
                </ul>
            </li>
            
            <li class="sidebar-menu-group-title">Báo Cáo & Hệ Thống</li>
            
            <li class="dropdown">
                <a href="javascript:void(0)">
                    <iconify-icon icon="solar:chart-2-outline" class="menu-icon"></iconify-icon>
                    <span>Báo Cáo</span>
                </a>
                <ul class="sidebar-submenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/reports/dashboard">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Dashboard Báo Cáo
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/reports/revenue">
                            <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Báo Cáo Doanh Thu
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/reports/customers">
                            <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Báo Cáo Khách Hàng
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/reports/custom">
                            <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Báo Cáo Tùy Chỉnh
                        </a>
                    </li>
                </ul>
            </li>
            
            <li class="dropdown">
                <a href="javascript:void(0)">
                    <iconify-icon icon="solar:shield-check-outline" class="menu-icon"></iconify-icon>
                    <span>Bảo Mật</span>
                </a>
                <ul class="sidebar-submenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/security/overview">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Tổng Quan Bảo Mật
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/security/access">
                            <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Kiểm Soát Truy Cập
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/security/audit">
                            <i class="ri-circle-fill circle-icon text-danger-main w-auto"></i> Nhật Ký Audit
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/security/policies">
                            <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Chính Sách Bảo Mật
                        </a>
                    </li>
                </ul>
            </li>
            
            <li class="dropdown">
                <a href="javascript:void(0)">
                    <iconify-icon icon="solar:settings-outline" class="menu-icon"></iconify-icon>
                    <span>Hệ Thống</span>
                </a>
                <ul class="sidebar-submenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/system/settings">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Cài Đặt Hệ Thống
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/system/backup">
                            <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Sao Lưu Dữ Liệu
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/system/maintenance">
                            <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Bảo Trì Hệ Thống
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/system/logs">
                            <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Nhật Ký Hệ Thống
                        </a>
                    </li>
                </ul>
            </li>
            
            <li>
                <a href="${pageContext.request.contextPath}/admin/inventory/products">
                    <iconify-icon icon="solar:box-outline" class="menu-icon"></iconify-icon>
                    <span>Quản Lý Kho</span>
                </a>
            </li>
            
            <li>
                <a href="${pageContext.request.contextPath}/admin/communication/messages">
                    <iconify-icon icon="solar:chat-round-outline" class="menu-icon"></iconify-icon>
                    <span>Giao Tiếp</span>
                </a>
            </li>
            
            <li>
                <a href="${pageContext.request.contextPath}/admin/profile/account">
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