<%-- 
    Document   : assigned.jsp
    Created on : Therapist Assigned Clients
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
    <title>Khách Hàng Được Phân - Therapist Dashboard</title>
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
            <h6 class="fw-semibold mb-0">Khách Hàng Được Phân</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/therapist-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Khách Hàng</li>
                <li>-</li>
                <li class="fw-medium">Được Phân</li>
            </ul>
        </div>

        <div class="card">
            <div class="card-header border-bottom bg-base py-16 px-24">
                <div class="d-flex align-items-center justify-content-between">
                    <h6 class="text-lg fw-semibold mb-0">Danh Sách Khách Hàng</h6>
                    <span class="badge text-sm fw-semibold text-primary-600 bg-primary-100 px-20 py-9 radius-4">12 Khách Hàng</span>
                </div>
            </div>
            <div class="card-body p-24">
                <div class="table-responsive">
                    <table class="table bordered-table mb-0">
                        <thead>
                            <tr>
                                <th scope="col">Khách Hàng</th>
                                <th scope="col">Phân Loại</th>
                                <th scope="col">Liệu Pháp Ưa Thích</th>
                                <th scope="col">Lần Cuối</th>
                                <th scope="col">Điểm Tích Lũy</th>
                                <th scope="col" class="text-center">Trạng Thái</th>
                                <th scope="col" class="text-center">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <img src="${pageContext.request.contextPath}/assets/admin/images/users/user1.png" alt="" class="w-40-px h-40-px rounded-circle flex-shrink-0 me-12 overflow-hidden">
                                        <div class="flex-grow-1">
                                            <h6 class="text-md fw-semibold mb-0">Nguyễn Thị Lan Anh</h6>
                                            <span class="text-sm text-secondary-light">lananh@gmail.com</span>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="badge text-sm fw-semibold text-warning-600 bg-warning-100 px-20 py-9 radius-4">VIP</span></td>
                                <td><span class="text-md fw-normal text-secondary-light">Massage Toàn Thân</span></td>
                                <td><span class="text-md fw-normal text-secondary-light">Hôm qua</span></td>
                                <td><span class="text-md fw-normal text-secondary-light">2,450 điểm</span></td>
                                <td class="text-center">
                                    <span class="badge text-sm fw-semibold text-success-600 bg-success-100 px-20 py-9 radius-4">Hoạt Động</span>
                                </td>
                                <td class="text-center">
                                    <div class="d-flex align-items-center gap-10 justify-content-center">
                                        <button type="button" class="bg-info-100 text-info-600 bg-hover-info-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Xem Chi Tiết">
                                            <iconify-icon icon="solar:eye-outline"></iconify-icon>
                                        </button>
                                        <button type="button" class="bg-success-100 text-success-600 bg-hover-success-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Ghi Chú">
                                            <iconify-icon icon="solar:pen-new-square-outline"></iconify-icon>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <img src="${pageContext.request.contextPath}/assets/admin/images/users/user2.png" alt="" class="w-40-px h-40-px rounded-circle flex-shrink-0 me-12 overflow-hidden">
                                        <div class="flex-grow-1">
                                            <h6 class="text-md fw-semibold mb-0">Trần Văn Minh</h6>
                                            <span class="text-sm text-secondary-light">vanminh@gmail.com</span>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="badge text-sm fw-semibold text-primary-600 bg-primary-100 px-20 py-9 radius-4">Thường</span></td>
                                <td><span class="text-md fw-normal text-secondary-light">Chăm Sóc Da Mặt</span></td>
                                <td><span class="text-md fw-normal text-secondary-light">3 ngày trước</span></td>
                                <td><span class="text-md fw-normal text-secondary-light">1,250 điểm</span></td>
                                <td class="text-center">
                                    <span class="badge text-sm fw-semibold text-success-600 bg-success-100 px-20 py-9 radius-4">Hoạt Động</span>
                                </td>
                                <td class="text-center">
                                    <div class="d-flex align-items-center gap-10 justify-content-center">
                                        <button type="button" class="bg-info-100 text-info-600 bg-hover-info-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Xem Chi Tiết">
                                            <iconify-icon icon="solar:eye-outline"></iconify-icon>
                                        </button>
                                        <button type="button" class="bg-success-100 text-success-600 bg-hover-success-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Ghi Chú">
                                            <iconify-icon icon="solar:pen-new-square-outline"></iconify-icon>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <img src="${pageContext.request.contextPath}/assets/admin/images/users/user3.png" alt="" class="w-40-px h-40-px rounded-circle flex-shrink-0 me-12 overflow-hidden">
                                        <div class="flex-grow-1">
                                            <h6 class="text-md fw-semibold mb-0">Lê Thị Mai</h6>
                                            <span class="text-sm text-secondary-light">thimai@gmail.com</span>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="badge text-sm fw-semibold text-info-600 bg-info-100 px-20 py-9 radius-4">Mới</span></td>
                                <td><span class="text-md fw-normal text-secondary-light">Gói Spa Thư Giãn</span></td>
                                <td><span class="text-md fw-normal text-secondary-light">1 tuần trước</span></td>
                                <td><span class="text-md fw-normal text-secondary-light">350 điểm</span></td>
                                <td class="text-center">
                                    <span class="badge text-sm fw-semibold text-success-600 bg-success-100 px-20 py-9 radius-4">Hoạt Động</span>
                                </td>
                                <td class="text-center">
                                    <div class="d-flex align-items-center gap-10 justify-content-center">
                                        <button type="button" class="bg-info-100 text-info-600 bg-hover-info-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Xem Chi Tiết">
                                            <iconify-icon icon="solar:eye-outline"></iconify-icon>
                                        </button>
                                        <button type="button" class="bg-success-100 text-success-600 bg-hover-success-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Ghi Chú">
                                            <iconify-icon icon="solar:pen-new-square-outline"></iconify-icon>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html> 


