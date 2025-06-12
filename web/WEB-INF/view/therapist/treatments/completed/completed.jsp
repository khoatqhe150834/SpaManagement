<%-- 
    Document   : completed.jsp
    Created on : Therapist Completed Treatments Page
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liệu Pháp Đã Hoàn Thành - Therapist Dashboard</title>
    
    <%@ include file="../../shared/head.jsp" %>
</head>
<body>
    <%@ include file="../../shared/sidebar.jsp" %>

    <main class="dashboard-main">
        <%@ include file="../../shared/header.jsp" %>

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Liệu Pháp Đã Hoàn Thành</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/therapist-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Bảng Điều Khiển
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Liệu Pháp Đã Hoàn Thành</li>
                </ul>
            </div>

            <div class="card h-100 p-0 radius-12">
                <div class="card-header border-bottom bg-base py-16 px-24">
                    <h6 class="text-lg fw-semibold mb-0">Danh Sách Liệu Pháp Đã Hoàn Thành</h6>
                </div>
                <div class="card-body p-24">
                    <div class="row gy-4">
                        <!-- Sample completed treatment cards -->
                        <div class="col-xxl-6 col-lg-6">
                            <div class="card border border-gray-200 radius-12 p-20">
                                <div class="d-flex align-items-center justify-content-between mb-16">
                                    <span class="bg-success-focus text-success-main px-16 py-6 rounded-pill fw-medium text-sm">Hoàn Thành</span>
                                    <span class="text-secondary-light text-sm">15/12/2024</span>
                                </div>
                                <div class="d-flex align-items-center gap-12 mb-16">
                                    <img src="${pageContext.request.contextPath}/assets/admin/images/avatar/avatar-1.png" alt="Avatar" class="w-44-px h-44-px rounded-circle flex-shrink-0">
                                    <div class="flex-grow-1">
                                        <h6 class="text-lg fw-semibold mb-4">Nguyễn Thị Lan</h6>
                                        <span class="text-sm text-secondary-light">Massage Thư Giãn</span>
                                    </div>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-12">
                                    <span class="text-secondary-light">Thời gian:</span>
                                    <span class="fw-medium">90 phút</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-12">
                                    <span class="text-secondary-light">Giờ bắt đầu:</span>
                                    <span class="fw-medium">09:00 - 10:30</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-16">
                                    <span class="text-secondary-light">Đánh giá:</span>
                                    <div class="d-flex align-items-center gap-4">
                                        <div class="d-flex align-items-center gap-1">
                                            <iconify-icon icon="solar:star-bold" class="text-warning-main text-sm"></iconify-icon>
                                            <iconify-icon icon="solar:star-bold" class="text-warning-main text-sm"></iconify-icon>
                                            <iconify-icon icon="solar:star-bold" class="text-warning-main text-sm"></iconify-icon>
                                            <iconify-icon icon="solar:star-bold" class="text-warning-main text-sm"></iconify-icon>
                                            <iconify-icon icon="solar:star-bold" class="text-warning-main text-sm"></iconify-icon>
                                        </div>
                                        <span class="text-sm fw-medium">(5.0)</span>
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

                        <!-- Empty state -->
                        <div class="col-12">
                            <div class="text-center py-5">
                                <iconify-icon icon="solar:spa-outline" class="text-secondary-light mb-16" style="font-size: 64px;"></iconify-icon>
                                <h6 class="mb-8">Chưa có liệu pháp nào hoàn thành</h6>
                                <p class="text-secondary-light mb-0">Các liệu pháp đã hoàn thành sẽ xuất hiện ở đây</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="../../shared/footer.jsp" %>
    </main>

    <%@ include file="../../shared/js.jsp" %>
</body>
</html> 