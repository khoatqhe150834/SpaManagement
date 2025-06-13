<%-- 
    Document   : list.jsp
    Created on : Admin Users Management - List All Users
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
    <title>👥 Quản Lý Users - Admin Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
</head>
<body>
    <jsp:include page="/WEB-INF/view/admin/shared/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">👥 Quản Lý Tất Cả Users Hệ Thống</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/admin-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Admin Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Quản Lý Users</li>
                <li>-</li>
                <li class="fw-medium">Danh Sách Users</li>
            </ul>
        </div>

        <!-- Action Buttons -->
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <div class="d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/admin/users/create" class="btn btn-primary-600 d-flex align-items-center gap-2">
                    <iconify-icon icon="solar:user-plus-outline"></iconify-icon>
                    Tạo User Mới
                </a>
                <a href="${pageContext.request.contextPath}/admin/users/roles" class="btn btn-outline-warning d-flex align-items-center gap-2">
                    <iconify-icon icon="solar:shield-user-outline"></iconify-icon>
                    Quản Lý Roles
                </a>
            </div>
            <div class="d-flex align-items-center gap-3">
                <button class="btn btn-outline-danger d-flex align-items-center gap-2">
                    <iconify-icon icon="solar:download-outline"></iconify-icon>
                    Export Users
                </button>
            </div>
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
                    <span class="text-md fw-medium text-secondary-light mb-0">users</span>
                </div>
                <div class="navbar-search">
                    <input type="text" class="bg-base h-40-px w-auto" name="search" placeholder="Tìm kiếm user...">
                    <iconify-icon icon="ion:search-outline" class="icon"></iconify-icon>
                </div>
            </div>
            <div class="card-body p-24">
                <div class="table-responsive scroll-sm">
                    <table class="table bordered-table sm-table mb-0">
                        <thead>
                            <tr>
                                <th scope="col">ID</th>
                                <th scope="col">Thông Tin User</th>
                                <th scope="col">Email</th>
                                <th scope="col">Role</th>
                                <th scope="col">Trạng Thái</th>
                                <th scope="col">Đăng Nhập Cuối</th>
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
                                            <span class="text-md mb-0 fw-normal text-secondary-light">Nguyễn Văn Admin</span>
                                            <p class="text-xs mb-0 text-secondary-light">Super Administrator</p>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="text-md mb-0 fw-normal text-secondary-light">admin@spa.com</span></td>
                                <td><span class="badge text-sm fw-semibold text-danger-600 bg-danger-100 px-20 py-9 radius-4">SUPER_ADMIN</span></td>
                                <td><span class="badge text-sm fw-semibold text-success-600 bg-success-100 px-20 py-9 radius-4">Hoạt Động</span></td>
                                <td><span class="text-md mb-0 fw-normal text-secondary-light">2 phút trước</span></td>
                                <td class="text-center">
                                    <div class="d-flex align-items-center gap-10 justify-content-center">
                                        <button type="button" class="bg-info-100 text-info-600 bg-hover-info-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Xem Chi Tiết">
                                            <iconify-icon icon="solar:eye-outline"></iconify-icon>
                                        </button>
                                        <button type="button" class="bg-success-100 text-success-600 bg-hover-success-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Chỉnh Sửa">
                                            <iconify-icon icon="solar:pen-new-square-outline"></iconify-icon>
                                        </button>
                                        <button type="button" class="bg-warning-100 text-warning-600 bg-hover-warning-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Phân Quyền">
                                            <iconify-icon icon="solar:shield-user-outline"></iconify-icon>
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
                                            <span class="text-md mb-0 fw-normal text-secondary-light">Trần Thị Manager</span>
                                            <p class="text-xs mb-0 text-secondary-light">Chi Nhánh Quận 1</p>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="text-md mb-0 fw-normal text-secondary-light">manager@spa.com</span></td>
                                <td><span class="badge text-sm fw-semibold text-warning-600 bg-warning-100 px-20 py-9 radius-4">MANAGER</span></td>
                                <td><span class="badge text-sm fw-semibold text-success-600 bg-success-100 px-20 py-9 radius-4">Hoạt Động</span></td>
                                <td><span class="text-md mb-0 fw-normal text-secondary-light">1 giờ trước</span></td>
                                <td class="text-center">
                                    <div class="d-flex align-items-center gap-10 justify-content-center">
                                        <button type="button" class="bg-info-100 text-info-600 bg-hover-info-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Xem Chi Tiết">
                                            <iconify-icon icon="solar:eye-outline"></iconify-icon>
                                        </button>
                                        <button type="button" class="bg-success-100 text-success-600 bg-hover-success-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Chỉnh Sửa">
                                            <iconify-icon icon="solar:pen-new-square-outline"></iconify-icon>
                                        </button>
                                        <button type="button" class="bg-warning-100 text-warning-600 bg-hover-warning-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Phân Quyền">
                                            <iconify-icon icon="solar:shield-user-outline"></iconify-icon>
                                        </button>
                                        <button type="button" class="bg-danger-100 text-danger-600 bg-hover-danger-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Khóa Tài Khoản">
                                            <iconify-icon icon="solar:lock-outline"></iconify-icon>
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
                                            <span class="text-md mb-0 fw-normal text-secondary-light">Lê Văn Staff</span>
                                            <p class="text-xs mb-0 text-secondary-light">Nhân Viên Spa</p>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="text-md mb-0 fw-normal text-secondary-light">staff@spa.com</span></td>
                                <td><span class="badge text-sm fw-semibold text-primary-600 bg-primary-100 px-20 py-9 radius-4">STAFF</span></td>
                                <td><span class="badge text-sm fw-semibold text-secondary-600 bg-secondary-100 px-20 py-9 radius-4">Không Hoạt Động</span></td>
                                <td><span class="text-md mb-0 fw-normal text-secondary-light">2 ngày trước</span></td>
                                <td class="text-center">
                                    <div class="d-flex align-items-center gap-10 justify-content-center">
                                        <button type="button" class="bg-info-100 text-info-600 bg-hover-info-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Xem Chi Tiết">
                                            <iconify-icon icon="solar:eye-outline"></iconify-icon>
                                        </button>
                                        <button type="button" class="bg-success-100 text-success-600 bg-hover-success-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Chỉnh Sửa">
                                            <iconify-icon icon="solar:pen-new-square-outline"></iconify-icon>
                                        </button>
                                        <button type="button" class="bg-primary-100 text-primary-600 bg-hover-primary-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Kích Hoạt">
                                            <iconify-icon icon="solar:unlock-outline"></iconify-icon>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mt-24">
                    <span>Hiển thị 1 đến 3 trong tổng số 47 users</span>
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

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html> 