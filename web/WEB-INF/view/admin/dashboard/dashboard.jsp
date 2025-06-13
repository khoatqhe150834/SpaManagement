<%-- 
    Document   : dashboard.jsp
    Created on : Admin Main Dashboard
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
    <title>Admin Dashboard - Spa Management System</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
</head>
<body>
    <jsp:include page="/WEB-INF/view/admin/shared/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">🏛️ Admin Dashboard - Tổng Quan Hệ Thống</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/admin-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Admin Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Tổng Quan</li>
            </ul>
        </div>

        <!-- System Metrics Overview -->
        <div class="row gy-4 mb-24">
            <div class="col-xxl-3 col-sm-6">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="mb-0 w-48-px h-48-px bg-primary-600 flex-shrink-0 text-white d-flex justify-content-center align-items-center rounded-circle h6">
                                <iconify-icon icon="solar:users-group-rounded-outline"></iconify-icon>
                            </span>
                            <div>
                                <span class="mb-2 fw-medium text-secondary-light text-sm">Tổng Users Hệ Thống</span>
                                <h6 class="fw-semibold">1,247</h6>
                            </div>
                        </div>
                        <p class="text-sm mb-0">
                            <span class="text-success-main fw-medium">+15%</span> so với tháng trước
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-xxl-3 col-sm-6">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="mb-0 w-48-px h-48-px bg-success-main flex-shrink-0 text-white d-flex justify-content-center align-items-center rounded-circle h6">
                                <iconify-icon icon="solar:dollar-outline"></iconify-icon>
                            </span>
                            <div>
                                <span class="mb-2 fw-medium text-secondary-light text-sm">Doanh Thu Tháng</span>
                                <h6 class="fw-semibold">850,000,000 VNĐ</h6>
                            </div>
                        </div>
                        <p class="text-sm mb-0">
                            <span class="text-success-main fw-medium">+8.5%</span> tăng trưởng
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-xxl-3 col-sm-6">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="mb-0 w-48-px h-48-px bg-info-main flex-shrink-0 text-white d-flex justify-content-center align-items-center rounded-circle h6">
                                <iconify-icon icon="solar:calendar-outline"></iconify-icon>
                            </span>
                            <div>
                                <span class="mb-2 fw-medium text-secondary-light text-sm">Booking Hôm Nay</span>
                                <h6 class="fw-semibold">156</h6>
                            </div>
                        </div>
                        <p class="text-sm mb-0">
                            <span class="text-warning-main fw-medium">12</span> chờ xác nhận
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-xxl-3 col-sm-6">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="mb-0 w-48-px h-48-px bg-warning-main flex-shrink-0 text-white d-flex justify-content-center align-items-center rounded-circle h6">
                                <iconify-icon icon="solar:shield-check-outline"></iconify-icon>
                            </span>
                            <div>
                                <span class="mb-2 fw-medium text-secondary-light text-sm">System Health</span>
                                <h6 class="fw-semibold">99.8%</h6>
                            </div>
                        </div>
                        <p class="text-sm mb-0">
                            <span class="text-success-main fw-medium">Excellent</span> uptime
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Admin Actions -->
        <div class="row gy-4 mb-24">
            <div class="col-xxl-8">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">🚀 Thao Tác Quản Trị Nhanh</h6>
                    </div>
                    <div class="card-body p-24">
                        <div class="row gy-3">
                            <div class="col-xxl-4 col-md-6">
                                <a href="${pageContext.request.contextPath}/admin/users/list" class="btn btn-outline-primary w-100 d-flex align-items-center justify-content-center gap-2 py-3">
                                    <iconify-icon icon="solar:users-group-rounded-outline"></iconify-icon>
                                    Quản Lý Users
                                </a>
                            </div>
                            <div class="col-xxl-4 col-md-6">
                                <a href="${pageContext.request.contextPath}/admin/system/settings" class="btn btn-outline-success w-100 d-flex align-items-center justify-content-center gap-2 py-3">
                                    <iconify-icon icon="solar:settings-outline"></iconify-icon>
                                    Cài Đặt Hệ Thống
                                </a>
                            </div>
                            <div class="col-xxl-4 col-md-6">
                                <a href="${pageContext.request.contextPath}/admin/security/overview" class="btn btn-outline-warning w-100 d-flex align-items-center justify-content-center gap-2 py-3">
                                    <iconify-icon icon="solar:shield-check-outline"></iconify-icon>
                                    Bảo Mật Hệ Thống
                                </a>
                            </div>
                            <div class="col-xxl-4 col-md-6">
                                <a href="${pageContext.request.contextPath}/admin/financial/overview" class="btn btn-outline-info w-100 d-flex align-items-center justify-content-center gap-2 py-3">
                                    <iconify-icon icon="solar:dollar-outline"></iconify-icon>
                                    Tài Chính Tổng Thể
                                </a>
                            </div>
                            <div class="col-xxl-4 col-md-6">
                                <a href="${pageContext.request.contextPath}/admin/reports/dashboard" class="btn btn-outline-danger w-100 d-flex align-items-center justify-content-center gap-2 py-3">
                                    <iconify-icon icon="solar:chart-2-outline"></iconify-icon>
                                    Báo Cáo Tổng Hợp
                                </a>
                            </div>
                            <div class="col-xxl-4 col-md-6">
                                <a href="${pageContext.request.contextPath}/admin/system/backup" class="btn btn-outline-purple w-100 d-flex align-items-center justify-content-center gap-2 py-3">
                                    <iconify-icon icon="solar:download-outline"></iconify-icon>
                                    Sao Lưu Dữ Liệu
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- System Status -->
            <div class="col-xxl-4">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">🖥️ Trạng Thái Hệ Thống</h6>
                    </div>
                    <div class="card-body p-24">
                        <div class="d-flex flex-column gap-3">
                            <div class="d-flex align-items-center justify-content-between p-16 border radius-8">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="w-12-px h-12-px bg-success-main rounded-circle"></div>
                                    <span class="text-sm fw-medium">Database</span>
                                </div>
                                <span class="badge text-xs fw-semibold text-success-600 bg-success-100 px-12 py-6 radius-4">Online</span>
                            </div>
                            <div class="d-flex align-items-center justify-content-between p-16 border radius-8">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="w-12-px h-12-px bg-success-main rounded-circle"></div>
                                    <span class="text-sm fw-medium">Web Server</span>
                                </div>
                                <span class="badge text-xs fw-semibold text-success-600 bg-success-100 px-12 py-6 radius-4">Running</span>
                            </div>
                            <div class="d-flex align-items-center justify-content-between p-16 border radius-8">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="w-12-px h-12-px bg-warning-main rounded-circle"></div>
                                    <span class="text-sm fw-medium">Backup Service</span>
                                </div>
                                <span class="badge text-xs fw-semibold text-warning-600 bg-warning-100 px-12 py-6 radius-4">Scheduled</span>
                            </div>
                            <div class="d-flex align-items-center justify-content-between p-16 border radius-8">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="w-12-px h-12-px bg-success-main rounded-circle"></div>
                                    <span class="text-sm fw-medium">Email Service</span>
                                </div>
                                <span class="badge text-xs fw-semibold text-success-600 bg-success-100 px-12 py-6 radius-4">Active</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Activities and System Alerts -->
        <div class="row gy-4">
            <!-- Recent Admin Activities -->
            <div class="col-xxl-6">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center justify-content-between">
                        <h6 class="text-lg fw-semibold mb-0">📝 Hoạt Động Quản Trị Gần Đây</h6>
                        <a href="${pageContext.request.contextPath}/admin/users/activity" class="text-primary-600 hover-text-primary fw-medium">Xem Tất Cả</a>
                    </div>
                    <div class="card-body p-24">
                        <div class="d-flex flex-column gap-3">
                            <div class="d-flex align-items-start gap-3 p-16 border radius-8">
                                <iconify-icon icon="solar:user-plus-outline" class="text-success-main text-xl mt-1"></iconify-icon>
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Tạo User Mới</h6>
                                    <span class="text-sm text-secondary-light">Admin tạo tài khoản manager mới cho chi nhánh</span>
                                    <p class="text-xs text-secondary-light mb-0 mt-1">10 phút trước</p>
                                </div>
                            </div>
                            <div class="d-flex align-items-start gap-3 p-16 border radius-8">
                                <iconify-icon icon="solar:settings-outline" class="text-info-main text-xl mt-1"></iconify-icon>
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Cập Nhật Cấu Hình</h6>
                                    <span class="text-sm text-secondary-light">Thay đổi cài đặt email và notification</span>
                                    <p class="text-xs text-secondary-light mb-0 mt-1">1 giờ trước</p>
                                </div>
                            </div>
                            <div class="d-flex align-items-start gap-3 p-16 border radius-8">
                                <iconify-icon icon="solar:shield-check-outline" class="text-warning-main text-xl mt-1"></iconify-icon>
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Cập Nhật Bảo Mật</h6>
                                    <span class="text-sm text-secondary-light">Thêm quy tắc firewall mới</span>
                                    <p class="text-xs text-secondary-light mb-0 mt-1">3 giờ trước</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- System Alerts -->
            <div class="col-xxl-6">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center justify-content-between">
                        <h6 class="text-lg fw-semibold mb-0">⚠️ Cảnh Báo Hệ Thống</h6>
                        <a href="${pageContext.request.contextPath}/admin/dashboard/alerts" class="text-primary-600 hover-text-primary fw-medium">Xem Tất Cả</a>
                    </div>
                    <div class="card-body p-24">
                        <div class="d-flex flex-column gap-3">
                            <div class="d-flex align-items-start gap-3 p-16 border radius-8 border-warning">
                                <iconify-icon icon="solar:info-circle-outline" class="text-warning-main text-xl mt-1"></iconify-icon>
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Disk Space Warning</h6>
                                    <span class="text-sm text-secondary-light">Dung lượng đĩa còn 15GB (85% đã sử dụng)</span>
                                    <p class="text-xs text-secondary-light mb-0 mt-1">30 phút trước</p>
                                </div>
                            </div>
                            <div class="d-flex align-items-start gap-3 p-16 border radius-8 border-info">
                                <iconify-icon icon="solar:download-outline" class="text-info-main text-xl mt-1"></iconify-icon>
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Backup Scheduled</h6>
                                    <span class="text-sm text-secondary-light">Sao lưu tự động sẽ chạy lúc 2:00 AM</span>
                                    <p class="text-xs text-secondary-light mb-0 mt-1">5 giờ trước</p>
                                </div>
                            </div>
                            <div class="d-flex align-items-start gap-3 p-16 border radius-8 border-success">
                                <iconify-icon icon="solar:check-circle-outline" class="text-success-main text-xl mt-1"></iconify-icon>
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Security Update Complete</h6>
                                    <span class="text-sm text-secondary-light">Cập nhật bảo mật hoàn tất thành công</span>
                                    <p class="text-xs text-secondary-light mb-0 mt-1">1 ngày trước</p>
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