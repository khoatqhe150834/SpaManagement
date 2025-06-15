<%-- 
    Document   : history.jsp
    Created on : Therapist Appointment History Page
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
    <title>Lịch Sử Lịch Hẹn - Therapist Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
</head>
<body>
    <jsp:include page="/WEB-INF/view/therapist/shared/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Lịch Sử Lịch Hẹn</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/therapist-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Bảng Điều Khiển
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Lịch Sử Lịch Hẹn</li>
            </ul>
        </div>

        <div class="card h-100 p-0 radius-12">
            <div class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center flex-wrap gap-3 justify-content-between">
                <div class="d-flex align-items-center flex-wrap gap-3">
                    <span class="text-md fw-medium text-secondary-light mb-0">Hiển thị</span>
                    <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px">
                        <option>10</option>
                        <option>15</option>
                        <option>20</option>
                    </select>
                    <span class="text-md fw-medium text-secondary-light mb-0">kết quả</span>
                </div>
                <div class="navbar-search">
                    <input type="text" class="bg-base h-40-px w-auto" name="search" placeholder="Tìm kiếm lịch hẹn...">
                    <iconify-icon icon="ion:search-outline" class="icon"></iconify-icon>
                </div>
            </div>
            <div class="card-body p-24">
                <div class="table-responsive scroll-sm">
                    <table class="table bordered-table sm-table mb-0">
                        <thead>
                            <tr>
                                <th scope="col">Ngày Giờ</th>
                                <th scope="col">Khách Hàng</th>
                                <th scope="col">Dịch Vụ</th>
                                <th scope="col">Thời Gian</th>
                                <th scope="col">Trạng Thái</th>
                                <th scope="col">Đánh Giá</th>
                                <th scope="col" class="text-center">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>15/12/2024 09:00</td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <img src="${pageContext.request.contextPath}/assets/admin/images/avatar/avatar-1.png" alt="Avatar" class="w-40-px h-40-px rounded-circle flex-shrink-0 me-12 overflow-hidden">
                                        <div class="flex-grow-1">
                                            <span class="text-md mb-0 fw-medium text-primary-light d-block">Nguyễn Thị Lan</span>
                                            <span class="text-sm text-secondary-light fw-medium">0987654321</span>
                                        </div>
                                    </div>
                                </td>
                                <td>Massage Thư Giãn</td>
                                <td>90 phút</td>
                                <td>
                                    <span class="bg-success-focus text-success-main px-24 py-4 rounded-pill fw-medium text-sm">Hoàn Thành</span>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="d-flex align-items-center gap-1">
                                            <iconify-icon icon="solar:star-bold" class="text-warning-main text-md"></iconify-icon>
                                            <iconify-icon icon="solar:star-bold" class="text-warning-main text-md"></iconify-icon>
                                            <iconify-icon icon="solar:star-bold" class="text-warning-main text-md"></iconify-icon>
                                            <iconify-icon icon="solar:star-bold" class="text-warning-main text-md"></iconify-icon>
                                            <iconify-icon icon="solar:star-bold" class="text-warning-main text-md"></iconify-icon>
                                        </div>
                                        <span class="text-sm text-secondary-light">(5.0)</span>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <div class="d-flex align-items-center gap-10 justify-content-center">
                                        <button type="button" class="bg-info-focus bg-hover-info-200 text-info-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle">
                                            <iconify-icon icon="solar:eye-outline" class="icon text-xl"></iconify-icon>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <!-- Additional sample rows would go here -->
                            <tr>
                                <td colspan="7" class="text-center py-4">
                                    <p class="text-secondary-light">Chưa có dữ liệu lịch sử lịch hẹn</p>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mt-24">
                    <span>Hiển thị 1 đến 10 của 0 kết quả</span>
                    <ul class="pagination d-flex flex-wrap align-items-center gap-2 justify-content-center">
                        <li class="page-item">
                            <a class="page-link bg-neutral-200 text-secondary-light fw-semibold radius-8 border-0 d-flex align-items-center justify-content-center h-32-px w-32-px text-md" href="#">
                                <iconify-icon icon="ep:d-arrow-left" class=""></iconify-icon>
                            </a>
                        </li>
                        <li class="page-item">
                            <a class="page-link text-secondary-light fw-semibold radius-8 border-0 d-flex align-items-center justify-content-center h-32-px w-32-px" href="#">1</a>
                        </li>
                        <li class="page-item">
                            <a class="page-link bg-neutral-200 text-secondary-light fw-semibold radius-8 border-0 d-flex align-items-center justify-content-center h-32-px w-32-px text-md" href="#">
                                <iconify-icon icon="ep:d-arrow-right" class=""></iconify-icon>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html> 


