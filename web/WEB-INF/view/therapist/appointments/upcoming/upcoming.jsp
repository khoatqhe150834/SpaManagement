<%-- 
    Document   : upcoming.jsp
    Created on : Therapist Upcoming Appointments Page
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Hẹn Sắp Tới - Therapist Dashboard</title>
    
    <%@ include file="../../shared/head.jsp" %>
</head>
<body>
    <%@ include file="../../shared/sidebar.jsp" %>

    <main class="dashboard-main">
        <%@ include file="../../shared/header.jsp" %>

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Lịch Hẹn Sắp Tới</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/therapist-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Bảng Điều Khiển
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Lịch Hẹn Sắp Tới</li>
                </ul>
            </div>

            <div class="row gy-4">
                <!-- Upcoming Appointment Cards -->
                <div class="col-xxl-4 col-lg-6">
                    <div class="card border border-primary-200 radius-12">
                        <div class="card-body p-20">
                            <div class="d-flex align-items-center justify-content-between mb-16">
                                <span class="bg-primary-focus text-primary-main px-16 py-6 rounded-pill fw-medium text-sm">Sắp Tới</span>
                                <span class="text-secondary-light text-sm">18/12/2024</span>
                            </div>
                            <div class="d-flex align-items-center gap-12 mb-16">
                                <img src="${pageContext.request.contextPath}/assets/admin/images/avatar/avatar-1.png" alt="Avatar" class="w-44-px h-44-px rounded-circle flex-shrink-0">
                                <div class="flex-grow-1">
                                    <h6 class="text-lg fw-semibold mb-4">Nguyễn Thị Lan</h6>
                                    <span class="text-sm text-secondary-light">0987654321</span>
                                </div>
                            </div>
                            <div class="mb-16">
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light">Dịch vụ:</span>
                                    <span class="fw-medium">Massage Thư Giãn</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light">Thời gian:</span>
                                    <span class="fw-medium">14:00 - 15:30</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light">Phòng:</span>
                                    <span class="fw-medium">Phòng VIP 1</span>
                                </div>
                            </div>
                            <div class="d-flex align-items-center gap-8">
                                <button type="button" class="btn btn-primary text-sm btn-sm px-12 py-6 radius-8 flex-fill">
                                    <iconify-icon icon="solar:check-circle-outline" class="icon text-lg"></iconify-icon>
                                    Xác Nhận
                                </button>
                                <button type="button" class="btn btn-outline-info text-sm btn-sm px-12 py-6 radius-8 flex-fill">
                                    <iconify-icon icon="solar:phone-outline" class="icon text-lg"></iconify-icon>
                                    Liên Hệ
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xxl-4 col-lg-6">
                    <div class="card border border-warning-200 radius-12">
                        <div class="card-body p-20">
                            <div class="d-flex align-items-center justify-content-between mb-16">
                                <span class="bg-warning-focus text-warning-main px-16 py-6 rounded-pill fw-medium text-sm">Chờ Xác Nhận</span>
                                <span class="text-secondary-light text-sm">19/12/2024</span>
                            </div>
                            <div class="d-flex align-items-center gap-12 mb-16">
                                <img src="${pageContext.request.contextPath}/assets/admin/images/avatar/avatar-2.png" alt="Avatar" class="w-44-px h-44-px rounded-circle flex-shrink-0">
                                <div class="flex-grow-1">
                                    <h6 class="text-lg fw-semibold mb-4">Trần Văn Nam</h6>
                                    <span class="text-sm text-secondary-light">0123456789</span>
                                </div>
                            </div>
                            <div class="mb-16">
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light">Dịch vụ:</span>
                                    <span class="fw-medium">Chăm Sóc Da Mặt</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light">Thời gian:</span>
                                    <span class="fw-medium">10:00 - 11:00</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light">Phòng:</span>
                                    <span class="fw-medium">Phòng 2</span>
                                </div>
                            </div>
                            <div class="d-flex align-items-center gap-8">
                                <button type="button" class="btn btn-success text-sm btn-sm px-12 py-6 radius-8 flex-fill">
                                    <iconify-icon icon="solar:check-circle-outline" class="icon text-lg"></iconify-icon>
                                    Chấp Nhận
                                </button>
                                <button type="button" class="btn btn-outline-danger text-sm btn-sm px-12 py-6 radius-8 flex-fill">
                                    <iconify-icon icon="solar:close-circle-outline" class="icon text-lg"></iconify-icon>
                                    Từ Chối
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Empty State -->
                <div class="col-12">
                    <div class="text-center py-5">
                        <iconify-icon icon="solar:calendar-outline" class="text-secondary-light mb-16" style="font-size: 64px;"></iconify-icon>
                        <h6 class="mb-8">Không có lịch hẹn sắp tới</h6>
                        <p class="text-secondary-light mb-0">Các lịch hẹn trong tương lai sẽ xuất hiện ở đây</p>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="../../shared/footer.jsp" %>
    </main>

    <%@ include file="../../shared/js.jsp" %>
</body>
</html>
