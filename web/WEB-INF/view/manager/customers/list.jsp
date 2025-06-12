<%-- 
    Document   : list.jsp
    Created on : Manager Customer List
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Khách Hàng - Manager Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
</head>
<body>
    <jsp:include page="/WEB-INF/view/manager/shared/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Danh Sách Khách Hàng</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/manager-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Quản Lý Khách Hàng</li>
                <li>-</li>
                <li class="fw-medium">Danh Sách</li>
            </ul>
        </div>

        <div class="card h-100 p-0 radius-12">
            <div class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center flex-wrap gap-3 justify-content-between">
                <div class="d-flex align-items-center flex-wrap gap-3">
                    <span class="text-md fw-medium text-secondary-light mb-0">Hiển thị</span>
                    <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px">
                        <option>10</option>
                        <option>25</option>
                        <option>50</option>
                        <option>100</option>
                    </select>
                    <span class="text-md fw-medium text-secondary-light mb-0">khách hàng</span>
                </div>
                <div class="navbar-search">
                    <input type="text" class="bg-base h-40-px w-auto" name="search" placeholder="Tìm kiếm khách hàng...">
                    <iconify-icon icon="ion:search-outline" class="icon"></iconify-icon>
                </div>
            </div>
            <div class="card-body p-24">
                <div class="table-responsive scroll-sm">
                    <table class="table bordered-table sm-table mb-0">
                        <thead>
                            <tr>
                                <th scope="col">ID</th>
                                <th scope="col">Họ Tên</th>
                                <th scope="col">Email</th>
                                <th scope="col">Số Điện Thoại</th>
                                <th scope="col">Phân Loại</th>
                                <th scope="col">Điểm Tích Lũy</th>
                                <th scope="col">Ngày Tham Gia</th>
                                <th scope="col" class="text-center">Trạng Thái</th>
                                <th scope="col" class="text-center">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><span class="text-md mb-0 fw-normal text-secondary-light">#001</span></td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <img src="${pageContext.request.contextPath}/assets/admin/images/users/user1.png" alt="" class="w-40-px h-40-px rounded-circle flex-shrink-0 me-12 overflow-hidden">
                                        <div class="flex-grow-1">
                                            <span class="text-md mb-0 fw-normal text-secondary-light">Nguyễn Thị Lan Anh</span>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="text-md mb-0 fw-normal text-secondary-light">lananh@gmail.com</span></td>
                                <td><span class="text-md mb-0 fw-normal text-secondary-light">0912345678</span></td>
                                <td><span class="badge text-sm fw-semibold text-warning-600 bg-warning-100 px-20 py-9 radius-4">VIP</span></td>
                                <td><span class="text-md mb-0 fw-normal text-secondary-light">2,450</span></td>
                                <td><span class="text-md mb-0 fw-normal text-secondary-light">15/01/2024</span></td>
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
                                <td><span class="text-md mb-0 fw-normal text-secondary-light">#002</span></td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <img src="${pageContext.request.contextPath}/assets/admin/images/users/user2.png" alt="" class="w-40-px h-40-px rounded-circle flex-shrink-0 me-12 overflow-hidden">
                                        <div class="flex-grow-1">
                                            <span class="text-md mb-0 fw-normal text-secondary-light">Trần Văn Minh</span>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="text-md mb-0 fw-normal text-secondary-light">vanminh@gmail.com</span></td>
                                <td><span class="text-md mb-0 fw-normal text-secondary-light">0923456789</span></td>
                                <td><span class="badge text-sm fw-semibold text-primary-600 bg-primary-100 px-20 py-9 radius-4">Thường</span></td>
                                <td><span class="text-md mb-0 fw-normal text-secondary-light">1,250</span></td>
                                <td><span class="text-md mb-0 fw-normal text-secondary-light">22/02/2024</span></td>
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
                                <td><span class="text-md mb-0 fw-normal text-secondary-light">#003</span></td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <img src="${pageContext.request.contextPath}/assets/admin/images/users/user3.png" alt="" class="w-40-px h-40-px rounded-circle flex-shrink-0 me-12 overflow-hidden">
                                        <div class="flex-grow-1">
                                            <span class="text-md mb-0 fw-normal text-secondary-light">Lê Thị Mai</span>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="text-md mb-0 fw-normal text-secondary-light">thimai@gmail.com</span></td>
                                <td><span class="text-md mb-0 fw-normal text-secondary-light">0934567890</span></td>
                                <td><span class="badge text-sm fw-semibold text-info-600 bg-info-100 px-20 py-9 radius-4">Mới</span></td>
                                <td><span class="text-md mb-0 fw-normal text-secondary-light">350</span></td>
                                <td><span class="text-md mb-0 fw-normal text-secondary-light">10/03/2024</span></td>
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

                <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mt-24">
                    <span>Hiển thị 1 đến 3 trong tổng số 3 khách hàng</span>
                    <ul class="pagination d-flex flex-wrap align-items-center gap-2 justify-content-center">
                        <li class="page-item">
                            <a class="page-link bg-neutral-200 text-secondary-light fw-semibold radius-8 border-0 d-flex align-items-center justify-content-center h-32-px w-32-px text-md" href="javascript:void(0)">
                                <iconify-icon icon="ep:d-arrow-left" class=""></iconify-icon>
                            </a>
                        </li>
                        <li class="page-item">
                            <a class="page-link text-secondary-light fw-semibold radius-8 border-0 d-flex align-items-center justify-content-center h-32-px w-32-px text-md bg-primary-600 text-white" href="javascript:void(0)">1</a>
                        </li>
                        <li class="page-item">
                            <a class="page-link bg-neutral-200 text-secondary-light fw-semibold radius-8 border-0 d-flex align-items-center justify-content-center h-32-px w-32-px" href="javascript:void(0)">
                                <iconify-icon icon="ep:d-arrow-right" class=""></iconify-icon>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/javascript.jsp" />
</body>
</html> 