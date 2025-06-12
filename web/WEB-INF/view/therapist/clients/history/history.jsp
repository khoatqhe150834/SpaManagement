<%-- 
    Document   : history.jsp
    Created on : Therapist Client History Page
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi" data-theme="light">
<head>
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Sử Khách Hàng - Therapist Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
</head>
<body>
    <jsp:include page="/WEB-INF/view/therapist/shared/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Lịch Sử Khách Hàng</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/therapist-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Bảng Điều Khiển
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Lịch Sử Khách Hàng</li>
            </ul>
        </div>

        <div class="card h-100 p-0 radius-12">
            <div class="card-body p-24">
                <div class="row gy-4">
                    <!-- Client History Cards -->
                    <div class="col-xl-4 col-sm-6">
                        <div class="card border border-gray-200 radius-12 p-20">
                            <div class="d-flex align-items-center gap-12 mb-16">
                                <img src="${pageContext.request.contextPath}/assets/admin/images/avatar/avatar-1.png" alt="Avatar" class="w-60-px h-60-px rounded-circle flex-shrink-0">
                                <div class="flex-grow-1">
                                    <h6 class="text-lg fw-semibold mb-4">Nguyễn Thị Lan</h6>
                                    <span class="text-sm text-secondary-light">Khách hàng VIP</span>
                                </div>
                            </div>
                            
                            <div class="mb-16">
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Tổng lần điều trị:</span>
                                    <span class="fw-medium text-sm">15 lần</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Lần cuối:</span>
                                    <span class="fw-medium text-sm">15/12/2024</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Đánh giá trung bình:</span>
                                    <div class="d-flex align-items-center gap-4">
                                        <div class="d-flex align-items-center gap-1">
                                            <iconify-icon icon="solar:star-bold" class="text-warning-main text-xs"></iconify-icon>
                                            <iconify-icon icon="solar:star-bold" class="text-warning-main text-xs"></iconify-icon>
                                            <iconify-icon icon="solar:star-bold" class="text-warning-main text-xs"></iconify-icon>
                                            <iconify-icon icon="solar:star-bold" class="text-warning-main text-xs"></iconify-icon>
                                            <iconify-icon icon="solar:star-bold" class="text-warning-main text-xs"></iconify-icon>
                                        </div>
                                        <span class="text-xs fw-medium">(4.8)</span>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-16">
                                <h6 class="text-sm fw-semibold mb-8">Dịch vụ thường dùng:</h6>
                                <div class="d-flex flex-wrap gap-4">
                                    <span class="bg-primary-focus text-primary-main px-8 py-2 rounded-pill fw-medium text-xs">Massage Thư Giãn</span>
                                    <span class="bg-success-focus text-success-main px-8 py-2 rounded-pill fw-medium text-xs">Chăm Sóc Da</span>
                                </div>
                            </div>

                            <div class="d-flex align-items-center gap-8">
                                <button type="button" class="btn btn-primary text-sm btn-sm px-12 py-6 radius-8 flex-fill">
                                    <iconify-icon icon="solar:eye-outline" class="icon text-lg"></iconify-icon>
                                    Xem Chi Tiết
                                </button>
                                <button type="button" class="btn btn-info text-sm btn-sm px-12 py-6 radius-8 flex-fill">
                                    <iconify-icon icon="solar:document-text-outline" class="icon text-lg"></iconify-icon>
                                    Ghi Chú
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- More client cards would go here -->

                    <!-- Empty State -->
                    <div class="col-12">
                        <div class="text-center py-5">
                            <iconify-icon icon="solar:users-group-rounded-outline" class="text-secondary-light mb-16" style="font-size: 64px;"></iconify-icon>
                            <h6 class="mb-8">Chưa có lịch sử khách hàng</h6>
                            <p class="text-secondary-light mb-0">Lịch sử điều trị khách hàng sẽ xuất hiện ở đây</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html> 