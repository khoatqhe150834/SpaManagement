<%-- 
    Document   : sidebar.jsp
    Created on : Therapist Dashboard Sidebar
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%-- Therapist Dashboard Sidebar Navigation - Using Admin Framework Styles --%>
<aside class="sidebar">
    <button type="button" class="sidebar-close-btn">
        <iconify-icon icon="radix-icons:cross-2"></iconify-icon>
    </button>
    <div>
        <a href="${pageContext.request.contextPath}/therapist-dashboard" class="sidebar-logo">
            <img src="${pageContext.request.contextPath}/assets/admin/images/logo.png" alt="BeautyZone Spa" class="light-logo">
            <img src="${pageContext.request.contextPath}/assets/admin/images/logo-light.png" alt="BeautyZone Spa" class="dark-logo">
            <img src="${pageContext.request.contextPath}/assets/admin/images/logo-icon.png" alt="BeautyZone Spa" class="logo-icon">
        </a>
    </div>
    <div class="sidebar-menu-area">
        <ul class="sidebar-menu" id="sidebar-menu">
            <li>
                <a href="${pageContext.request.contextPath}/therapist-dashboard" class="active-page">
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
                        <a href="${pageContext.request.contextPath}/therapist-dashboard/appointments/today">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Lịch Hôm Nay
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/therapist-dashboard/appointments/upcoming">
                            <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Lịch Sắp Tới
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/therapist-dashboard/appointments/history">
                            <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Lịch Sử Lịch Hẹn
                        </a>
                    </li>
                </ul>
            </li>
            
            <li class="dropdown">
                <a href="javascript:void(0)">
                    <iconify-icon icon="solar:spa-outline" class="menu-icon"></iconify-icon>
                    <span>Liệu Pháp</span>
                </a>
                <ul class="sidebar-submenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/therapist-dashboard/treatments/active">
                            <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Đang Thực Hiện
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/therapist-dashboard/treatments/completed">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Đã Hoàn Thành
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/therapist-dashboard/treatments/notes">
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
                        <a href="${pageContext.request.contextPath}/therapist-dashboard/clients/assigned">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Khách Được Phân
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/therapist-dashboard/clients/history">
                            <i class="ri-circle-fill circle-icon text-info-main w-auto"></i> Lịch Sử Khách Hàng
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/therapist-dashboard/clients/notes">
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
                        <a href="${pageContext.request.contextPath}/therapist-dashboard/schedule/daily">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Lịch Hàng Ngày
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/therapist-dashboard/schedule/weekly">
                            <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Lịch Hàng Tuần
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/therapist-dashboard/schedule/requests">
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
                        <a href="${pageContext.request.contextPath}/therapist-dashboard/performance/stats">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Thống Kê Hiệu Suất
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/therapist-dashboard/performance/feedback">
                            <i class="ri-circle-fill circle-icon text-success-main w-auto"></i> Phản Hồi Khách Hàng
                        </a>
                    </li>
                </ul>
            </li>
            
            <li class="dropdown">
                <a href="javascript:void(0)">
                    <iconify-icon icon="solar:graduation-cap-outline" class="menu-icon"></iconify-icon>
                    <span>Đào Tạo</span>
                </a>
                <ul class="sidebar-submenu">
                    <li>
                        <a href="${pageContext.request.contextPath}/therapist-dashboard/training/courses">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Khóa Học
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/therapist-dashboard/training/certificates">
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
                        <a href="${pageContext.request.contextPath}/therapist-dashboard/inventory/supplies">
                            <i class="ri-circle-fill circle-icon text-primary-600 w-auto"></i> Tình Trạng Vật Tư
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/therapist-dashboard/inventory/requests">
                            <i class="ri-circle-fill circle-icon text-warning-main w-auto"></i> Yêu Cầu Vật Tư
                        </a>
                    </li>
                </ul>
            </li>
            
            <li class="sidebar-menu-group-title">Tài Khoản</li>
            
            <li>
                <a href="${pageContext.request.contextPath}/therapist-dashboard/dashboard/profile">
                    <iconify-icon icon="solar:user-outline" class="menu-icon"></iconify-icon>
                    <span>Thông Tin Cá Nhân</span>
                </a>
            </li>
            
            <li>
                <a href="${pageContext.request.contextPath}/therapist-dashboard/dashboard/notifications">
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