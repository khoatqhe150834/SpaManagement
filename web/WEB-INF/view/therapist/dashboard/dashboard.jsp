<%-- 
    Document   : dashboard.jsp
    Created on : Therapist Main Dashboard
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
    <title>Bảng Điều Khiển - Therapist Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Chào mừng đến với Therapist Dashboard</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/therapist-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Tổng Quan</li>
            </ul>
        </div>

        <!-- Today's Overview Section -->
        <div class="row gy-4 mb-24">
            <div class="col-xxl-3 col-sm-6">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="mb-0 w-48-px h-48-px bg-primary-600 flex-shrink-0 text-white d-flex justify-content-center align-items-center rounded-circle h6">
                                <iconify-icon icon="solar:calendar-outline"></iconify-icon>
                            </span>
                            <div>
                                <span class="mb-2 fw-medium text-secondary-light text-sm">Lịch Hẹn Hôm Nay</span>
                                <h6 class="fw-semibold">8</h6>
                            </div>
                        </div>
                        <p class="text-sm mb-0">
                            <span class="text-warning-main fw-medium">2</span> đang chờ xác nhận
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-xxl-3 col-sm-6">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="mb-0 w-48-px h-48-px bg-success-main flex-shrink-0 text-white d-flex justify-content-center align-items-center rounded-circle h6">
                                <iconify-icon icon="solar:spa-outline"></iconify-icon>
                            </span>
                            <div>
                                <span class="mb-2 fw-medium text-secondary-light text-sm">Liệu Pháp Đang Thực Hiện</span>
                                <h6 class="fw-semibold">3</h6>
                            </div>
                        </div>
                        <p class="text-sm mb-0">
                            <span class="text-info-main fw-medium">5</span> đã hoàn thành hôm nay
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
                                <span class="mb-2 fw-medium text-secondary-light text-sm">Khách Hàng Được Phân</span>
                                <h6 class="fw-semibold">12</h6>
                            </div>
                        </div>
                        <p class="text-sm mb-0">
                            <span class="text-success-main fw-medium">2</span> khách VIP
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
                                <span class="mb-2 fw-medium text-secondary-light text-sm">Đánh Giá TB Tuần Này</span>
                                <h6 class="fw-semibold">4.9/5.0</h6>
                            </div>
                        </div>
                        <p class="text-sm mb-0">
                            Từ <span class="text-success-main fw-medium">28</span> đánh giá
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions and Schedule -->
        <div class="row gy-4 mb-24">
            <!-- Today's Schedule -->
            <div class="col-xxl-8">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">Lịch Trình Hôm Nay</h6>
                    </div>
                    <div class="card-body p-24">
                        <div class="d-flex flex-column gap-3">
                            <div class="d-flex align-items-center justify-content-between p-16 border radius-8">
                                <div class="d-flex align-items-center gap-3">
                                    <span class="text-primary-600 fw-semibold">09:00</span>
                                    <div>
                                        <h6 class="text-md fw-semibold mb-1">Nguyễn Thị Lan Anh</h6>
                                        <span class="text-sm text-secondary-light">Massage Toàn Thân (90 phút)</span>
                                    </div>
                                </div>
                                <span class="badge text-sm fw-semibold text-success-600 bg-success-100 px-20 py-9 radius-4">Xác Nhận</span>
                            </div>
                            <div class="d-flex align-items-center justify-content-between p-16 border radius-8">
                                <div class="d-flex align-items-center gap-3">
                                    <span class="text-primary-600 fw-semibold">11:00</span>
                                    <div>
                                        <h6 class="text-md fw-semibold mb-1">Trần Văn Minh</h6>
                                        <span class="text-sm text-secondary-light">Chăm Sóc Da Mặt (60 phút)</span>
                                    </div>
                                </div>
                                <span class="badge text-sm fw-semibold text-warning-600 bg-warning-100 px-20 py-9 radius-4">Chờ Xác Nhận</span>
                            </div>
                            <div class="d-flex align-items-center justify-content-between p-16 border radius-8">
                                <div class="d-flex align-items-center gap-3">
                                    <span class="text-primary-600 fw-semibold">14:00</span>
                                    <div>
                                        <h6 class="text-md fw-semibold mb-1">Lê Thị Mai</h6>
                                        <span class="text-sm text-secondary-light">Gói Spa Thư Giãn (120 phút)</span>
                                    </div>
                                </div>
                                <span class="badge text-sm fw-semibold text-success-600 bg-success-100 px-20 py-9 radius-4">Xác Nhận</span>
                            </div>
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
                            <a href="${pageContext.request.contextPath}/therapist-dashboard/appointments/today" class="btn btn-outline-primary d-flex align-items-center gap-2">
                                <iconify-icon icon="solar:calendar-outline"></iconify-icon>
                                Xem Lịch Hôm Nay
                            </a>
                            <a href="${pageContext.request.contextPath}/therapist-dashboard/treatments/active" class="btn btn-outline-success d-flex align-items-center gap-2">
                                <iconify-icon icon="solar:spa-outline"></iconify-icon>
                                Liệu Pháp Đang Thực Hiện
                            </a>
                            <a href="${pageContext.request.contextPath}/therapist-dashboard/clients/assigned" class="btn btn-outline-info d-flex align-items-center gap-2">
                                <iconify-icon icon="solar:users-group-rounded-outline"></iconify-icon>
                                Khách Hàng Của Tôi
                            </a>
                            <a href="${pageContext.request.contextPath}/therapist-dashboard/performance/stats" class="btn btn-outline-warning d-flex align-items-center gap-2">
                                <iconify-icon icon="solar:chart-outline"></iconify-icon>
                                Xem Hiệu Suất
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Activities and Notifications -->
        <div class="row gy-4">
            <!-- Recent Treatment Notes -->
            <div class="col-xxl-6">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center justify-content-between">
                        <h6 class="text-lg fw-semibold mb-0">Ghi Chú Liệu Pháp Gần Đây</h6>
                        <a href="${pageContext.request.contextPath}/therapist-dashboard/treatments/notes" class="text-primary-600 hover-text-primary fw-medium">Xem Tất Cả</a>
                    </div>
                    <div class="card-body p-24">
                        <div class="d-flex flex-column gap-3">
                            <div class="d-flex align-items-start gap-3 p-16 border radius-8">
                                <iconify-icon icon="solar:spa-outline" class="text-success-main text-xl mt-1"></iconify-icon>
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Nguyễn Thị Lan Anh</h6>
                                    <span class="text-sm text-secondary-light">Massage toàn thân với tinh dầu lavender. Khách hàng phản hồi tích cực.</span>
                                    <p class="text-xs text-secondary-light mb-0 mt-1">Hôm qua - Massage Thư Giãn</p>
                                </div>
                            </div>
                            <div class="d-flex align-items-start gap-3 p-16 border radius-8">
                                <iconify-icon icon="solar:spa-outline" class="text-primary-600 text-xl mt-1"></iconify-icon>
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Trần Văn Minh</h6>
                                    <span class="text-sm text-secondary-light">Liệu pháp chăm sóc da mặt. Khách yêu cầu tăng cường độ massage.</span>
                                    <p class="text-xs text-secondary-light mb-0 mt-1">2 ngày trước - Chăm Sóc Da</p>
                                </div>
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
                        <a href="${pageContext.request.contextPath}/therapist-dashboard/dashboard/notifications" class="text-primary-600 hover-text-primary fw-medium">Xem Tất Cả</a>
                    </div>
                    <div class="card-body p-24">
                        <div class="d-flex flex-column gap-3">
                            <div class="d-flex align-items-start gap-3 p-16 border radius-8">
                                <iconify-icon icon="solar:bell-outline" class="text-warning-main text-xl mt-1"></iconify-icon>
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Yêu Cầu Vật Tư</h6>
                                    <span class="text-sm text-secondary-light">Cần bổ sung tinh dầu massage trong phòng VIP</span>
                                    <p class="text-xs text-secondary-light mb-0 mt-1">2 giờ trước</p>
                                </div>
                            </div>
                            <div class="d-flex align-items-start gap-3 p-16 border radius-8">
                                <iconify-icon icon="solar:star-outline" class="text-success-main text-xl mt-1"></iconify-icon>
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Đánh Giá Tích Cực</h6>
                                    <span class="text-sm text-secondary-light">Khách hàng VIP đánh giá 5 sao cho dịch vụ của bạn</span>
                                    <p class="text-xs text-secondary-light mb-0 mt-1">1 ngày trước</p>
                                </div>
                            </div>
                            <div class="d-flex align-items-start gap-3 p-16 border radius-8">
                                <iconify-icon icon="solar:graduation-cap-outline" class="text-info-main text-xl mt-1"></iconify-icon>
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Khóa Đào Tạo Mới</h6>
                                    <span class="text-sm text-secondary-light">Khóa học "Massage Đá Nóng" sẽ bắt đầu tuần sau</span>
                                    <p class="text-xs text-secondary-light mb-0 mt-1">3 ngày trước</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html> 