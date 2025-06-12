<%-- 
    Document   : today.jsp
    Created on : Therapist Today's Appointments
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Hôm Nay - Therapist Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
</head>
<body>
    <jsp:include page="/WEB-INF/view/therapist/shared/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Lịch Hẹn Hôm Nay</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/therapist-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Lịch Hẹn</li>
                <li>-</li>
                <li class="fw-medium">Hôm Nay</li>
            </ul>
        </div>

        <div class="card">
            <div class="card-header border-bottom bg-base py-16 px-24">
                <div class="d-flex align-items-center justify-content-between">
                    <h6 class="text-lg fw-semibold mb-0">Lịch Trình Hôm Nay</h6>
                    <span class="badge text-sm fw-semibold text-primary-600 bg-primary-100 px-20 py-9 radius-4">8 Lịch Hẹn</span>
                </div>
            </div>
            <div class="card-body p-24">
                <div class="d-flex flex-column gap-3">
                    <div class="d-flex align-items-center justify-content-between p-20 border radius-8">
                        <div class="d-flex align-items-center gap-4">
                            <span class="text-primary-600 fw-bold text-lg">09:00</span>
                            <div>
                                <h6 class="text-md fw-semibold mb-1">Nguyễn Thị Lan Anh</h6>
                                <span class="text-sm text-secondary-light">Massage Toàn Thân • 90 phút • Phòng VIP 1</span>
                                <div class="mt-1">
                                    <span class="badge text-xs fw-semibold text-warning-600 bg-warning-100 px-12 py-4 radius-4">VIP</span>
                                </div>
                            </div>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge text-sm fw-semibold text-success-600 bg-success-100 px-20 py-9 radius-4">Xác Nhận</span>
                            <button class="btn btn-outline-primary btn-sm">Chi Tiết</button>
                        </div>
                    </div>
                    
                    <div class="d-flex align-items-center justify-content-between p-20 border radius-8">
                        <div class="d-flex align-items-center gap-4">
                            <span class="text-primary-600 fw-bold text-lg">11:00</span>
                            <div>
                                <h6 class="text-md fw-semibold mb-1">Trần Văn Minh</h6>
                                <span class="text-sm text-secondary-light">Chăm Sóc Da Mặt • 60 phút • Phòng 2</span>
                                <div class="mt-1">
                                    <span class="badge text-xs fw-semibold text-info-600 bg-info-100 px-12 py-4 radius-4">Thường</span>
                                </div>
                            </div>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge text-sm fw-semibold text-warning-600 bg-warning-100 px-20 py-9 radius-4">Chờ Xác Nhận</span>
                            <button class="btn btn-outline-primary btn-sm">Chi Tiết</button>
                        </div>
                    </div>

                    <div class="d-flex align-items-center justify-content-between p-20 border radius-8">
                        <div class="d-flex align-items-center gap-4">
                            <span class="text-primary-600 fw-bold text-lg">14:00</span>
                            <div>
                                <h6 class="text-md fw-semibold mb-1">Lê Thị Mai</h6>
                                <span class="text-sm text-secondary-light">Gói Spa Thư Giãn • 120 phút • Phòng VIP 2</span>
                                <div class="mt-1">
                                    <span class="badge text-xs fw-semibold text-primary-600 bg-primary-100 px-12 py-4 radius-4">Mới</span>
                                </div>
                            </div>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge text-sm fw-semibold text-success-600 bg-success-100 px-20 py-9 radius-4">Xác Nhận</span>
                            <button class="btn btn-outline-primary btn-sm">Chi Tiết</button>
                        </div>
                    </div>

                    <div class="d-flex align-items-center justify-content-between p-20 border radius-8 bg-light">
                        <div class="d-flex align-items-center gap-4">
                            <span class="text-secondary-light fw-bold text-lg">12:30</span>
                            <div>
                                <h6 class="text-md fw-semibold mb-1 text-secondary-light">Nghỉ Trưa</h6>
                                <span class="text-sm text-secondary-light">60 phút nghỉ ngơi</span>
                            </div>
                        </div>
                        <span class="badge text-sm fw-semibold text-secondary-light bg-neutral-200 px-20 py-9 radius-4">Nghỉ</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html> 


