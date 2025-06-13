<%-- 
    Document   : create.jsp
    Created on : Admin Users Management - Create New User
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>➕ Tạo User Mới - Admin Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
</head>
<body>
    <jsp:include page="/WEB-INF/view/admin/shared/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">➕ Tạo User Mới</h6>
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
                <li class="fw-medium">Tạo User Mới</li>
            </ul>
        </div>

        <div class="card h-100 p-0 radius-12">
            <div class="card-header border-bottom bg-base py-16 px-24">
                <h6 class="text-lg fw-semibold mb-0">Thông Tin User Mới</h6>
            </div>
            <div class="card-body p-24">
                <form action="" method="post">
                    <div class="row gy-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-primary-light text-sm mb-8">Họ và Tên <span class="text-danger-600">*</span></label>
                            <input type="text" class="form-control radius-8" name="fullName" placeholder="Nhập họ và tên" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-primary-light text-sm mb-8">Email <span class="text-danger-600">*</span></label>
                            <input type="email" class="form-control radius-8" name="email" placeholder="user@spa.com" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-primary-light text-sm mb-8">Số Điện Thoại <span class="text-danger-600">*</span></label>
                            <input type="tel" class="form-control radius-8" name="phone" placeholder="0912345678" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold text-primary-light text-sm mb-8">Role <span class="text-danger-600">*</span></label>
                            <select class="form-select radius-8" name="role" required>
                                <option value="">Chọn role...</option>
                                <option value="ADMIN">Administrator</option>
                                <option value="MANAGER">Manager</option>
                                <option value="STAFF">Staff</option>
                                <option value="CUSTOMER">Customer</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold text-primary-light text-sm mb-8">Mật Khẩu Tạm Thời <span class="text-danger-600">*</span></label>
                            <input type="password" class="form-control radius-8" name="password" placeholder="Mật khẩu tạm thời" required>
                            <div class="text-sm text-secondary-light mt-2">User sẽ được yêu cầu đổi mật khẩu khi đăng nhập lần đầu</div>
                        </div>
                        <div class="col-12">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="sendEmail" id="sendEmail" checked>
                                <label class="form-check-label" for="sendEmail">
                                    Gửi email thông báo đến user
                                </label>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="d-flex align-items-center gap-3">
                                <button type="submit" class="btn btn-primary-600 px-20 py-11 radius-8">
                                    <iconify-icon icon="solar:user-plus-outline" class="icon text-xl line-height-1"></iconify-icon>
                                    Tạo User
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/users/list" class="btn btn-outline-secondary px-20 py-11 radius-8">
                                    <iconify-icon icon="solar:arrow-left-outline" class="icon text-xl line-height-1"></iconify-icon>
                                    Quay Lại
                                </a>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html> 