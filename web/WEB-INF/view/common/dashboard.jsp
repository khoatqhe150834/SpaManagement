<%-- 
    Document   : dashboard.jsp (Common Dashboard)
    Created on : Common Dashboard for all roles
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <c:choose>
        <c:when test="${sessionScope.userType == 'ADMIN'}">
            <title>Admin Dashboard - Spa Management</title>
        </c:when>
        <c:when test="${sessionScope.userType == 'MANAGER'}">
            <title>Manager Dashboard - Spa Management</title>
        </c:when>
        <c:when test="${sessionScope.userType == 'THERAPIST'}">
            <title>Therapist Dashboard - Spa Management</title>
        </c:when>
        <c:when test="${sessionScope.userType == 'RECEPTIONIST'}">
            <title>Receptionist Dashboard - Spa Management</title>
        </c:when>
        <c:when test="${sessionScope.userType == 'CUSTOMER'}">
            <title>Customer Dashboard - Spa Management</title>
        </c:when>
        <c:otherwise>
            <title>Dashboard - Spa Management</title>
        </c:otherwise>
    </c:choose>
    
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
</head>
<body>
    <!-- Include Sidebar (common for all roles but content differs based on userType) -->
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
    
    <!-- Include Header (common for all roles) -->
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

    <!-- Conditional Dashboard Content Based on User Type -->
    <c:choose>
        <c:when test="${sessionScope.userType == 'ADMIN'}">
            <!-- Admin Dashboard Content -->
            <div class="dashboard-main-body">
                <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                    <h6 class="fw-semibold mb-0">Admin Dashboard</h6>
                    <ul class="d-flex align-items-center gap-2">
                        <li class="fw-medium">
                            <a href="${pageContext.request.contextPath}/admin-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                                <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                                Dashboard
                            </a>
                        </li>
                        <li>-</li>
                        <li class="fw-medium">Admin Overview</li>
                    </ul>
                </div>
                
                <!-- Admin-specific content -->
                <div class="row gy-4 mb-24">
                    <div class="col-xxl-3 col-sm-6">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex align-items-center gap-2 mb-2">
                                    <span class="mb-0 w-48-px h-48-px bg-primary-600 flex-shrink-0 text-white d-flex justify-content-center align-items-center rounded-circle h6">
                                        <iconify-icon icon="solar:users-group-rounded-outline"></iconify-icon>
                                    </span>
                                    <div>
                                        <span class="mb-2 fw-medium text-secondary-light text-sm">Total Users</span>
                                        <h6 class="fw-semibold">1,247</h6>
                                    </div>
                                </div>
                                <p class="text-sm mb-0">
                                    <span class="text-success-main fw-medium">+8%</span> this month
                                </p>
                            </div>
                        </div>
                    </div>
                    <!-- Add more admin cards here -->
                </div>
            </div>
        </c:when>
        
        <c:when test="${sessionScope.userType == 'MANAGER'}">
            <!-- Manager Dashboard Content -->
            <div class="dashboard-main-body">
                <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                    <h6 class="fw-semibold mb-0">Tổng Quan Manager</h6>
                    <ul class="d-flex align-items-center gap-2">
                        <li class="fw-medium">
                            <a href="${pageContext.request.contextPath}/manager-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                                <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                                Dashboard
                            </a>
                        </li>
                        <li>-</li>
                        <li class="fw-medium">Tổng Quan</li>
                    </ul>
                </div>

                <!-- Revenue Overview Section -->
                <div class="row gy-4 mb-24">
                    <div class="col-xxl-3 col-sm-6">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex align-items-center gap-2 mb-2">
                                    <span class="mb-0 w-48-px h-48-px bg-primary-600 flex-shrink-0 text-white d-flex justify-content-center align-items-center rounded-circle h6">
                                        <iconify-icon icon="solar:dollar-outline"></iconify-icon>
                                    </span>
                                    <div>
                                        <span class="mb-2 fw-medium text-secondary-light text-sm">Doanh Thu Hôm Nay</span>
                                        <h6 class="fw-semibold">25,000,000 VNĐ</h6>
                                    </div>
                                </div>
                                <p class="text-sm mb-0">
                                    <span class="text-success-main fw-medium">+12%</span> so với hôm qua
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="col-xxl-3 col-sm-6">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex align-items-center gap-2 mb-2">
                                    <span class="mb-0 w-48-px h-48-px bg-success-main flex-shrink-0 text-white d-flex justify-content-center align-items-center rounded-circle h6">
                                        <iconify-icon icon="solar:calendar-outline"></iconify-icon>
                                    </span>
                                    <div>
                                        <span class="mb-2 fw-medium text-secondary-light text-sm">Lịch Hẹn Hôm Nay</span>
                                        <h6 class="fw-semibold">18</h6>
                                    </div>
                                </div>
                                <p class="text-sm mb-0">
                                    <span class="text-warning-main fw-medium">3</span> đang chờ xác nhận
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="col-xxl-3 col-sm-6">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex align-items-center gap-2 mb-2">
                                    <span class="mb-0 w-48-px h-48-px bg-info-main flex-shrink-0 text-white d-flex justify-content-center align-items-center rounded-circle h6">
                                        <iconify-icon icon="solar:users-group-rounded-outline"></iconify-icon>
                                    </span>
                                    <div>
                                        <span class="mb-2 fw-medium text-secondary-light text-sm">Khách Hàng Mới</span>
                                        <h6 class="fw-semibold">7</h6>
                                    </div>
                                </div>
                                <p class="text-sm mb-0">
                                    <span class="text-success-main fw-medium">+23%</span> so với tuần trước
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="col-xxl-3 col-sm-6">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex align-items-center gap-2 mb-2">
                                    <span class="mb-0 w-48-px h-48-px bg-warning-main flex-shrink-0 text-white d-flex justify-content-center align-items-center rounded-circle h6">
                                        <iconify-icon icon="solar:star-outline"></iconify-icon>
                                    </span>
                                    <div>
                                        <span class="mb-2 fw-medium text-secondary-light text-sm">Đánh Giá TB</span>
                                        <h6 class="fw-semibold">4.8/5.0</h6>
                                    </div>
                                </div>
                                <p class="text-sm mb-0">
                                    Từ <span class="text-success-main fw-medium">142</span> đánh giá
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Charts and Quick Actions Row -->
                <div class="row gy-4 mb-24">
                    <!-- Revenue Chart -->
                    <div class="col-xxl-8">
                        <div class="card h-100">
                            <div class="card-header border-bottom bg-base py-16 px-24">
                                <h6 class="text-lg fw-semibold mb-0">Biểu Đồ Doanh Thu 7 Ngày Qua</h6>
                            </div>
                            <div class="card-body p-24">
                                <div class="d-flex justify-content-center align-items-center" style="height: 300px;">
                                    <p class="text-secondary-light">Biểu đồ doanh thu sẽ được hiển thị tại đây</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="col-xxl-4">
                        <div class="card h-100">
                            <div class="card-header border-bottom bg-base py-16 px-24">
                                <h6 class="text-lg fw-semibold mb-0">Thao Tác Nhanh</h6>
                            </div>
                            <div class="card-body p-24">
                                <div class="d-flex flex-column gap-3">
                                    <a href="${pageContext.request.contextPath}/manager-dashboard/customers/list" class="btn btn-outline-primary d-flex align-items-center gap-2">
                                        <iconify-icon icon="solar:users-group-two-rounded-outline"></iconify-icon>
                                        Quản Lý Khách Hàng
                                    </a>
                                    <a href="${pageContext.request.contextPath}/manager-dashboard/services/packages" class="btn btn-outline-success d-flex align-items-center gap-2">
                                        <iconify-icon icon="solar:spa-outline"></iconify-icon>
                                        Quản Lý Dịch Vụ
                                    </a>
                                    <a href="${pageContext.request.contextPath}/manager-dashboard/staff/list" class="btn btn-outline-info d-flex align-items-center gap-2">
                                        <iconify-icon icon="solar:users-group-rounded-outline"></iconify-icon>
                                        Quản Lý Nhân Viên
                                    </a>
                                    <a href="${pageContext.request.contextPath}/manager-dashboard/reports/revenue" class="btn btn-outline-warning d-flex align-items-center gap-2">
                                        <iconify-icon icon="solar:chart-2-outline"></iconify-icon>
                                        Báo Cáo Doanh Thu
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Activities and Notifications -->
                <div class="row gy-4">
                    <!-- Recent Appointments -->
                    <div class="col-xxl-6">
                        <div class="card h-100">
                            <div class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center justify-content-between">
                                <h6 class="text-lg fw-semibold mb-0">Lịch Hẹn Gần Đây</h6>
                                <a href="${pageContext.request.contextPath}/manager-dashboard/dashboard/appointments" class="text-primary-600 hover-text-primary fw-medium">Xem Tất Cả</a>
                            </div>
                            <div class="card-body p-24">
                                <div class="d-flex flex-column gap-3">
                                    <div class="d-flex align-items-center justify-content-between p-16 border radius-8">
                                        <div>
                                            <h6 class="text-md fw-semibold mb-1">Nguyễn Thị Lan Anh</h6>
                                            <span class="text-sm text-secondary-light">Massage Toàn Thân - 10:00</span>
                                        </div>
                                        <span class="badge text-sm fw-semibold text-success-600 bg-success-100 px-20 py-9 radius-4">Đã Xác Nhận</span>
                                    </div>
                                    <div class="d-flex align-items-center justify-content-between p-16 border radius-8">
                                        <div>
                                            <h6 class="text-md fw-semibold mb-1">Trần Văn Minh</h6>
                                            <span class="text-sm text-secondary-light">Chăm Sóc Da Mặt - 14:30</span>
                                        </div>
                                        <span class="badge text-sm fw-semibold text-warning-600 bg-warning-100 px-20 py-9 radius-4">Chờ Xác Nhận</span>
                                    </div>
                                    <div class="d-flex align-items-center justify-content-between p-16 border radius-8">
                                        <div>
                                            <h6 class="text-md fw-semibold mb-1">Lê Thị Mai</h6>
                                            <span class="text-sm text-secondary-light">Gói Spa Trọn Gói - 16:00</span>
                                        </div>
                                        <span class="badge text-sm fw-semibold text-success-600 bg-success-100 px-20 py-9 radius-4">Đã Xác Nhận</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Important Notifications -->
                    <div class="col-xxl-6">
                        <div class="card h-100">
                            <div class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center justify-content-between">
                                <h6 class="text-lg fw-semibold mb-0">Thông Báo Quan Trọng</h6>
                                <a href="${pageContext.request.contextPath}/manager-dashboard/dashboard/notifications" class="text-primary-600 hover-text-primary fw-medium">Xem Tất Cả</a>
                            </div>
                            <div class="card-body p-24">
                                <div class="d-flex flex-column gap-3">
                                    <div class="d-flex align-items-start gap-3 p-16 border radius-8">
                                        <iconify-icon icon="solar:bell-outline" class="text-warning-main text-xl mt-1"></iconify-icon>
                                        <div>
                                            <h6 class="text-md fw-semibold mb-1">Thiết Bị Cần Bảo Trì</h6>
                                            <span class="text-sm text-secondary-light">Máy massage phòng VIP 2 cần được bảo trì định kỳ</span>
                                            <p class="text-xs text-secondary-light mb-0 mt-1">2 giờ trước</p>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-start gap-3 p-16 border radius-8">
                                        <iconify-icon icon="solar:info-circle-outline" class="text-info-main text-xl mt-1"></iconify-icon>
                                        <div>
                                            <h6 class="text-md fw-semibold mb-1">Nhân Viên Xin Nghỉ</h6>
                                            <span class="text-sm text-secondary-light">Thu Hương xin nghỉ phép ngày mai</span>
                                            <p class="text-xs text-secondary-light mb-0 mt-1">5 giờ trước</p>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-start gap-3 p-16 border radius-8">
                                        <iconify-icon icon="solar:star-outline" class="text-success-main text-xl mt-1"></iconify-icon>
                                        <div>
                                            <h6 class="text-md fw-semibold mb-1">Đánh Giá 5 Sao</h6>
                                            <span class="text-sm text-secondary-light">Khách hàng VIP đánh giá 5 sao dịch vụ massage</span>
                                            <p class="text-xs text-secondary-light mb-0 mt-1">1 ngày trước</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>
        
        <c:when test="${sessionScope.userType == 'THERAPIST'}">
            <!-- Therapist Dashboard Content -->
            <div class="dashboard-main-body">
                <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                    <h6 class="fw-semibold mb-0">Therapist Dashboard</h6>
                    <ul class="d-flex align-items-center gap-2">
                        <li class="fw-medium">
                            <a href="${pageContext.request.contextPath}/therapist-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                                <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                                Dashboard
                            </a>
                        </li>
                        <li>-</li>
                        <li class="fw-medium">My Schedule</li>
                    </ul>
                </div>
                
                <!-- Therapist-specific content -->
                <div class="row gy-4 mb-24">
                    <div class="col-xxl-3 col-sm-6">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex align-items-center gap-2 mb-2">
                                    <span class="mb-0 w-48-px h-48-px bg-success-main flex-shrink-0 text-white d-flex justify-content-center align-items-center rounded-circle h6">
                                        <iconify-icon icon="solar:calendar-outline"></iconify-icon>
                                    </span>
                                    <div>
                                        <span class="mb-2 fw-medium text-secondary-light text-sm">Today's Appointments</span>
                                        <h6 class="fw-semibold">8</h6>
                                    </div>
                                </div>
                                <p class="text-sm mb-0">
                                    <span class="text-info-main fw-medium">2</span> upcoming
                                </p>
                            </div>
                        </div>
                    </div>
                    <!-- Add more therapist cards here -->
                </div>
            </div>
        </c:when>
        
        <c:when test="${sessionScope.userType == 'RECEPTIONIST'}">
            <!-- Receptionist Dashboard Content -->
            <div class="dashboard-main-body">
                <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                    <h6 class="fw-semibold mb-0">Receptionist Dashboard</h6>
                    <ul class="d-flex align-items-center gap-2">
                        <li class="fw-medium">
                            <a href="${pageContext.request.contextPath}/receptionist-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                                <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                                Dashboard
                            </a>
                        </li>
                        <li>-</li>
                        <li class="fw-medium">Front Desk</li>
                    </ul>
                </div>
                
                <!-- Receptionist-specific content -->
                <div class="row gy-4 mb-24">
                    <div class="col-xxl-3 col-sm-6">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex align-items-center gap-2 mb-2">
                                    <span class="mb-0 w-48-px h-48-px bg-info-main flex-shrink-0 text-white d-flex justify-content-center align-items-center rounded-circle h6">
                                        <iconify-icon icon="solar:user-check-rounded-outline"></iconify-icon>
                                    </span>
                                    <div>
                                        <span class="mb-2 fw-medium text-secondary-light text-sm">Check-ins Today</span>
                                        <h6 class="fw-semibold">15</h6>
                                    </div>
                                </div>
                                <p class="text-sm mb-0">
                                    <span class="text-warning-main fw-medium">3</span> waiting
                                </p>
                            </div>
                        </div>
                    </div>
                    <!-- Add more receptionist cards here -->
                </div>
            </div>
        </c:when>
        
        <c:when test="${sessionScope.userType == 'CUSTOMER'}">
            <!-- Customer Dashboard Content -->
            <div class="dashboard-main-body">
                <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                    <h6 class="fw-semibold mb-0">Welcome, ${userDisplayName}!</h6>
                    <ul class="d-flex align-items-center gap-2">
                        <li class="fw-medium">
                            <a href="${pageContext.request.contextPath}/customer-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                                <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                                Dashboard
                            </a>
                        </li>
                        <li>-</li>
                        <li class="fw-medium">My Account</li>
                    </ul>
                </div>
                
                <!-- Customer-specific content -->
                <div class="row gy-4 mb-24">
                    <div class="col-xxl-3 col-sm-6">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex align-items-center gap-2 mb-2">
                                    <span class="mb-0 w-48-px h-48-px bg-primary-600 flex-shrink-0 text-white d-flex justify-content-center align-items-center rounded-circle h6">
                                        <iconify-icon icon="solar:calendar-mark-outline"></iconify-icon>
                                    </span>
                                    <div>
                                        <span class="mb-2 fw-medium text-secondary-light text-sm">Next Appointment</span>
                                        <h6 class="fw-semibold">Tomorrow 2:00 PM</h6>
                                    </div>
                                </div>
                                <p class="text-sm mb-0">
                                    <span class="text-info-main fw-medium">Facial Treatment</span>
                                </p>
                            </div>
                        </div>
                    </div>
                    <!-- Add more customer cards here -->
                </div>
            </div>
        </c:when>
        
        <c:otherwise>
            <!-- Default/Guest Dashboard Content -->
            <div class="dashboard-main-body">
                <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                    <h6 class="fw-semibold mb-0">Dashboard</h6>
                </div>
                
                <div class="row gy-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-body text-center p-40">
                                <iconify-icon icon="solar:user-outline" class="text-secondary-light" style="font-size: 4rem;"></iconify-icon>
                                <h4 class="mt-3 mb-2">Access Denied</h4>
                                <p class="text-secondary-light">You don't have permission to access this dashboard.</p>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                                    Login to Continue
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>

    <!-- Include common JavaScript -->
    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html>