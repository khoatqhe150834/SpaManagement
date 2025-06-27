<%-- 
    Document   : sidebar.jsp
    Unified Dynamic Sidebar for All Roles - Matching Original Style
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>
<%@ page import="model.Customer" %>
<%@ page import="model.RoleConstants" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Determine user role and info
    User user = (User) request.getAttribute("user");
    Customer customer = (Customer) request.getAttribute("customer");
    String userRole = (String) request.getAttribute("userRole");
    
    // Fallback to session if not in request
    if (user == null && customer == null) {
        user = (User) session.getAttribute("user");
        customer = (Customer) session.getAttribute("customer");
    }
    
    if (userRole == null) {
        if (user != null) {
            Integer roleId = user.getRoleId();
            switch (roleId) {
                case RoleConstants.ADMIN_ID: userRole = "ADMIN"; break;
                case RoleConstants.MANAGER_ID: userRole = "MANAGER"; break;
                case RoleConstants.THERAPIST_ID: userRole = "THERAPIST"; break;
                case RoleConstants.RECEPTIONIST_ID: userRole = "RECEPTIONIST"; break;
                default: userRole = "USER"; break;
            }
        } else if (customer != null) {
            userRole = "CUSTOMER";
        } else {
            userRole = "GUEST";
        }
    }
    
    // Set context path and dashboard base
    String contextPath = request.getContextPath();
    String dashboardBase = "/" + userRole.toLowerCase() + "-dashboard";
%>

<%-- Unified Sidebar Navigation - Using Admin Framework Styles --%>
<aside class="sidebar">
    <button type="button" class="sidebar-close-btn">
        <iconify-icon icon="radix-icons:cross-2"></iconify-icon>
    </button>
    <div>
        <a href="<%= contextPath + dashboardBase %>" class="sidebar-logo">
            <img src="<%= contextPath %>/assets/admin/images/logo.png" alt="BeautyZone Spa" class="light-logo">
            <img src="<%= contextPath %>/assets/admin/images/logo-light.png" alt="BeautyZone Spa" class="dark-logo">
            <img src="<%= contextPath %>/assets/admin/images/logo-icon.png" alt="BeautyZone Spa" class="logo-icon">
        </a>
    </div>
    <div class="sidebar-menu-area">
        <ul class="sidebar-menu" id="sidebar-menu">
            
            <% if ("ADMIN".equals(userRole)) { %>
                <!-- ADMIN MENU -->
                <li>
                    <a href="<%= contextPath %>/admin-dashboard" class="active-page">
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
                            <a href="<%= contextPath %>/admin/users/list">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Danh Sách Users
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/admin/users/create">
                                <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Tạo User Mới
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/admin/users/roles">
                                <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Quản Lý Roles
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/admin/users/permissions">
                                <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Phân Quyền
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
                            <a href="<%= contextPath %>/admin/customers/list">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Danh Sách Khách Hàng
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/admin/customers/analytics">
                                <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Phân Tích Khách Hàng
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/admin/customers/loyalty">
                                <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Chương Trình Loyalty
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
                            <a href="<%= contextPath %>/admin/staff/list">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Danh Sách Nhân Viên
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/admin/staff/roles">
                                <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Phân Quyền Staff
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/admin/staff/schedules">
                                <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Lịch Làm Việc
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/admin/staff/payroll">
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
                            <a href="<%= contextPath %>/admin/services/list">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Danh Sách Dịch Vụ
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/admin/services/categories">
                                <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Danh Mục Dịch Vụ
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/admin/services/pricing">
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
                            <a href="<%= contextPath %>/admin/bookings/list">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Tất Cả Booking
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/admin/bookings/calendar">
                                <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Lịch Booking
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/admin/bookings/settings">
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
                            <a href="<%= contextPath %>/admin/financial/overview">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Tổng Quan Tài Chính
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/admin/financial/revenue">
                                <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Doanh Thu
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/admin/financial/expenses">
                                <i class="ri-circle-fill circle-icon text-danger-main w-auto"></i> Chi Phí
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/admin/financial/invoices">
                                <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Hóa Đơn
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
                            <a href="<%= contextPath %>/admin/reports/dashboard">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Dashboard Báo Cáo
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/admin/reports/revenue">
                                <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Báo Cáo Doanh Thu
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/admin/reports/customers">
                                <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Báo Cáo Khách Hàng
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
                            <a href="<%= contextPath %>/admin/security/overview">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Tổng Quan Bảo Mật
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/admin/security/access">
                                <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Kiểm Soát Truy Cập
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/admin/security/audit">
                                <i class="ri-circle-fill circle-icon text-danger-main w-auto"></i> Nhật Ký Audit
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
                            <a href="<%= contextPath %>/admin/system/settings">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Cài Đặt Hệ Thống
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/admin/system/backup">
                                <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Sao Lưu Dữ Liệu
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/admin/system/maintenance">
                                <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Bảo Trì Hệ Thống
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/admin/system/logs">
                                <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Nhật Ký Hệ Thống
                            </a>
                        </li>
                    </ul>
                </li>
                
                <li>
                    <a href="<%= contextPath %>/admin/inventory/products">
                        <iconify-icon icon="solar:box-outline" class="menu-icon"></iconify-icon>
                        <span>Quản Lý Kho</span>
                    </a>
                </li>
                
                <li>
                    <a href="<%= contextPath %>/admin/communication/messages">
                        <iconify-icon icon="solar:chat-round-outline" class="menu-icon"></iconify-icon>
                        <span>Giao Tiếp</span>
                    </a>
                </li>
                
            <% } else if ("MANAGER".equals(userRole)) { %>
                <!-- MANAGER MENU -->
                <li>
                    <a href="<%= contextPath %>/manager-dashboard" class="active-page">
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
                            <a href="<%= contextPath %>/manager-dashboard/customers/list">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Danh Sách Khách Hàng
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/manager-dashboard/customers/categories">
                                <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Phân Loại Khách Hàng
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/manager-dashboard/customers/history">
                                <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Lịch Sử Sử Dụng
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/manager-dashboard/customers/notes">
                                <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Ghi Chú Đặc Biệt
                            </a>
                        </li>
                    </ul>
                </li>
                
                <li class="dropdown">
                    <a href="javascript:void(0)">
                        <iconify-icon icon="solar:settings-outline" class="menu-icon"></iconify-icon>
                        <span>Quản Lý Dịch Vụ</span>
                    </a>
                    <ul class="sidebar-submenu">
                        <li>
                            <a href="<%= contextPath %>/servicetype">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Quản lí loại dịch vụ
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/manager-dashboard/services/pricing">
                                <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Giá & Khuyến Mãi
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/manager-dashboard/services/media">
                                <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Hình Ảnh & Mô Tả
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/manager-dashboard/services/analytics">
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
                            <a href="<%= contextPath %>/manager-dashboard/staff/list">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Danh Sách Nhân Viên
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/manager-dashboard/staff/schedules">
                                <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Lịch Làm Việc
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/manager-dashboard/staff/performance">
                                <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Thống Kê Hiệu Suất
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/manager-dashboard/staff/assignments">
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
                            <a href="<%= contextPath %>/manager-dashboard/reports/revenue">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Báo Cáo Chi Tiết
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/manager-dashboard/dashboard/revenue">
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
                            <a href="<%= contextPath %>/manager-dashboard/reports/customers">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Thống Kê Khách Hàng
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/manager-dashboard/reports/trends">
                                <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Xu Hướng Dịch Vụ
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/manager-dashboard/dashboard/appointments">
                                <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Thống Kê Đặt Lịch
                            </a>
                        </li>
                    </ul>
                </li>
                
                <li>
                    <a href="<%= contextPath %>/manager-dashboard/reports/reviews">
                        <iconify-icon icon="solar:star-outline" class="menu-icon"></iconify-icon>
                        <span>Đánh Giá Khách Hàng</span>
                    </a>
                </li>
                
                <li class="sidebar-menu-group-title">Hệ Thống</li>
                
                <li>
                    <a href="<%= contextPath %>/manager-dashboard/dashboard/notifications">
                        <iconify-icon icon="solar:bell-outline" class="menu-icon"></iconify-icon>
                        <span>Thông Báo Quan Trọng</span>
                    </a>
                </li>
                
            <% } else if ("THERAPIST".equals(userRole)) { %>
                <!-- THERAPIST MENU -->
                <li>
                    <a href="<%= contextPath %>/therapist-dashboard" class="active-page">
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
                            <a href="<%= contextPath %>/therapist-dashboard/appointments/today">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Lịch Hôm Nay
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/therapist-dashboard/appointments/upcoming">
                                <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Lịch Sắp Tới
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/therapist-dashboard/appointments/history">
                                <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Lịch Sử Lịch Hẹn
                            </a>
                        </li>
                    </ul>
                </li>
                
                <li class="dropdown">
                    <a href="javascript:void(0)">
                        <iconify-icon icon="solar:heart-outline" class="menu-icon"></iconify-icon>
                        <span>Liệu Pháp</span>
                    </a>
                    <ul class="sidebar-submenu">
                        <li>
                            <a href="<%= contextPath %>/therapist-dashboard/treatments/active">
                                <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Đang Thực Hiện
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/therapist-dashboard/treatments/completed">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Đã Hoàn Thành
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/therapist-dashboard/treatments/notes">
                                <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Ghi Chú Liệu Pháp
                            </a>
                        </li>
                    </ul>
                </li>
                
                <li class="dropdown">
                    <a href="javascript:void(0)">
                        <iconify-icon icon="solar:users-group-rounded-outline" class="menu-icon"></iconify-icon>
                        <span>Khách Hàng</span>
                    </a>
                    <ul class="sidebar-submenu">
                        <li>
                            <a href="<%= contextPath %>/therapist-dashboard/clients/assigned">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Khách Được Phân
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/therapist-dashboard/clients/history">
                                <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Lịch Sử Khách Hàng
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/therapist-dashboard/clients/notes">
                                <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Ghi Chú Khách Hàng
                            </a>
                        </li>
                    </ul>
                </li>
                
                <li class="dropdown">
                    <a href="javascript:void(0)">
                        <iconify-icon icon="solar:clock-circle-outline" class="menu-icon"></iconify-icon>
                        <span>Lịch Làm Việc</span>
                    </a>
                    <ul class="sidebar-submenu">
                        <li>
                            <a href="<%= contextPath %>/therapist-dashboard/schedule/daily">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Lịch Hàng Ngày
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/therapist-dashboard/schedule/weekly">
                                <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Lịch Hàng Tuần
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/therapist-dashboard/schedule/requests">
                                <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Yêu Cầu Thay Đổi
                            </a>
                        </li>
                    </ul>
                </li>
                
                <li class="sidebar-menu-group-title">Hiệu Suất & Phát Triển</li>
                
                <li class="dropdown">
                    <a href="javascript:void(0)">
                        <iconify-icon icon="solar:chart-outline" class="menu-icon"></iconify-icon>
                        <span>Hiệu Suất Làm Việc</span>
                    </a>
                    <ul class="sidebar-submenu">
                        <li>
                            <a href="<%= contextPath %>/therapist-dashboard/performance/stats">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Thống Kê Hiệu Suất
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/therapist-dashboard/performance/feedback">
                                <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Phản Hồi Khách Hàng
                            </a>
                        </li>
                    </ul>
                </li>
                
                <li class="dropdown">
                    <a href="javascript:void(0)">
                        <iconify-icon icon="solar:book-outline" class="menu-icon"></iconify-icon>
                        <span>Đào Tạo</span>
                    </a>
                    <ul class="sidebar-submenu">
                        <li>
                            <a href="<%= contextPath %>/therapist-dashboard/training/courses">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Khóa Học
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/therapist-dashboard/training/certificates">
                                <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Chứng Chỉ
                            </a>
                        </li>
                    </ul>
                </li>
                
                <li class="dropdown">
                    <a href="javascript:void(0)">
                        <iconify-icon icon="solar:box-outline" class="menu-icon"></iconify-icon>
                        <span>Vật Tư & Thiết Bị</span>
                    </a>
                    <ul class="sidebar-submenu">
                        <li>
                            <a href="<%= contextPath %>/therapist-dashboard/inventory/supplies">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Tình Trạng Vật Tư
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/therapist-dashboard/inventory/requests">
                                <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Yêu Cầu Vật Tư
                            </a>
                        </li>
                    </ul>
                </li>
                
                <li class="sidebar-menu-group-title">Tài Khoản</li>
                
                <li>
                    <a href="<%= contextPath %>/therapist-dashboard/dashboard/profile">
                        <iconify-icon icon="solar:user-outline" class="menu-icon"></iconify-icon>
                        <span>Thông Tin Cá Nhân</span>
                    </a>
                </li>
                
                <li>
                    <a href="<%= contextPath %>/therapist-dashboard/dashboard/notifications">
                        <iconify-icon icon="solar:bell-outline" class="menu-icon"></iconify-icon>
                        <span>Thông Báo</span>
                    </a>
                </li>
                
            <% } else if ("CUSTOMER".equals(userRole)) { %>
                <!-- CUSTOMER MENU -->
                <li>
                    <a href="<%= contextPath %>/customer-dashboard" class="active-page">
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
                            <a href="<%= contextPath %>/customer-dashboard/appointments/booking">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Đặt Lịch Hẹn
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/customer-dashboard/appointments/upcoming">
                                <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Lịch Hẹn Sắp Tới
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/customer-dashboard/appointments/history">
                                <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Lịch Sử Lịch Hẹn
                            </a>
                        </li>
                    </ul>
                </li>
                
                <li>
                    <a href="<%= contextPath %>/customer-dashboard/treatments/history">
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
                            <a href="<%= contextPath %>/customer-dashboard/rewards/points">
                                <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Điểm Thưởng
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/customer-dashboard/rewards/rewards-list">
                                <i class="ri-circle-fill circle-icon text-danger-main w-auto"></i> Đổi Thưởng
                            </a>
                        </li>
                    </ul>
                </li>
                
                <li>
                    <a href="<%= contextPath %>/customer-dashboard/recommendations/services">
                        <iconify-icon icon="solar:bag-smile-outline" class="menu-icon"></iconify-icon>
                        <span>Đề Xuất Dành Cho Bạn</span>
                    </a>
                </li>
                
                <li>
                    <a href="<%= contextPath %>/customer-dashboard/reviews/my-reviews">
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
                            <a href="<%= contextPath %>/customer-dashboard/billing/payments">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Lịch Sử Thanh Toán
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/customer-dashboard/billing/invoices">
                                <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Hóa Đơn
                            </a>
                        </li>
                    </ul>
                </li>
                
                <li class="sidebar-menu-group-title">Tài Khoản</li>
                
                <li>
                    <a href="<%= contextPath %>/customer-dashboard/dashboard/profile">
                        <iconify-icon icon="solar:user-outline" class="menu-icon"></iconify-icon>
                        <span>Thông Tin Cá Nhân</span>
                    </a>
                </li>
                
                <li>
                    <a href="<%= contextPath %>/customer-dashboard/dashboard/notifications">
                        <iconify-icon icon="solar:bell-outline" class="menu-icon"></iconify-icon>
                        <span>Thông Báo</span>
                    </a>
                </li>
                
            <% } else if ("RECEPTIONIST".equals(userRole)) { %>
                <!-- RECEPTIONIST MENU -->
                <li>
                    <a href="<%= contextPath %>/receptionist-dashboard" class="active-page">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="menu-icon"></iconify-icon>
                        <span>Bảng Điều Khiển</span>
                    </a>
                </li>
                
                <li class="dropdown">
                    <a href="javascript:void(0)">
                        <iconify-icon icon="solar:calendar-outline" class="menu-icon"></iconify-icon>
                        <span>Quản Lý Lịch Hẹn</span>
                    </a>
                    <ul class="sidebar-submenu">
                        <li>
                            <a href="<%= contextPath %>/receptionist-dashboard/appointments/today">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Lịch Hôm Nay
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/receptionist-dashboard/appointments/upcoming">
                                <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Lịch Sắp Tới
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/receptionist-dashboard/appointments/booking">
                                <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Đặt Lịch Mới
                            </a>
                        </li>
                    </ul>
                </li>
                
                <li class="dropdown">
                    <a href="javascript:void(0)">
                        <iconify-icon icon="solar:users-group-two-rounded-outline" class="menu-icon"></iconify-icon>
                        <span>Dịch Vụ Khách Hàng</span>
                    </a>
                    <ul class="sidebar-submenu">
                        <li>
                            <a href="<%= contextPath %>/receptionist-dashboard/customers/checkin">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Check-in Khách Hàng
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/receptionist-dashboard/customers/support">
                                <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Hỗ Trợ Khách Hàng
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/receptionist-dashboard/customers/feedback">
                                <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Thu Thập Phản Hồi
                            </a>
                        </li>
                    </ul>
                </li>
                
                <li class="dropdown">
                    <a href="javascript:void(0)">
                        <iconify-icon icon="solar:card-outline" class="menu-icon"></iconify-icon>
                        <span>Thanh Toán</span>
                    </a>
                    <ul class="sidebar-submenu">
                        <li>
                            <a href="<%= contextPath %>/receptionist-dashboard/billing/process">
                                <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Xử Lý Thanh Toán
                            </a>
                        </li>
                        <li>
                            <a href="<%= contextPath %>/receptionist-dashboard/billing/invoices">
                                <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Tạo Hóa Đơn
                            </a>
                        </li>
                    </ul>
                </li>
                
                <li>
                    <a href="<%= contextPath %>/receptionist-dashboard/communication/messages">
                        <iconify-icon icon="solar:chat-round-outline" class="menu-icon"></iconify-icon>
                        <span>Tin Nhắn & Thông Báo</span>
                    </a>
                </li>
                
            <% } %>
            
            <!-- Common Menu Items for All Roles -->
            <li>
                <a href="<%= contextPath %>/profile">
                    <iconify-icon icon="solar:user-outline" class="menu-icon"></iconify-icon>
                    <span>Thông Tin Cá Nhân</span>
                </a>
            </li>
            
            <li>
                <a href="<%= contextPath %>/logout">
                    <iconify-icon icon="solar:logout-2-outline" class="menu-icon"></iconify-icon>
                    <span>Đăng Xuất</span>
                </a>
            </li>
        </ul>
    </div>
</aside>



 