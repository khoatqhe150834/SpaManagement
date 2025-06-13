<%-- 
    Document   : overview.jsp
    Created on : Admin Security Overview
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
    <title>🔐 Tổng Quan Bảo Mật - Admin Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
</head>
<body>
    <jsp:include page="/WEB-INF/view/admin/shared/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">🔐 Tổng Quan Bảo Mật Hệ Thống</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/admin-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Admin Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Bảo Mật</li>
                <li>-</li>
                <li class="fw-medium">Tổng Quan</li>
            </ul>
        </div>

        <!-- Security Status Cards -->
        <div class="row gy-4 mb-24">
            <div class="col-xxl-3 col-sm-6">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="mb-0 w-48-px h-48-px bg-success-main flex-shrink-0 text-white d-flex justify-content-center align-items-center rounded-circle h6">
                                <iconify-icon icon="solar:shield-check-outline"></iconify-icon>
                            </span>
                            <div>
                                <span class="mb-2 fw-medium text-secondary-light text-sm">Mức Độ Bảo Mật</span>
                                <h6 class="fw-semibold text-success-600">Cao</h6>
                            </div>
                        </div>
                        <p class="text-sm mb-0">
                            <span class="text-success-main fw-medium">95%</span> điểm bảo mật
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-xxl-3 col-sm-6">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="mb-0 w-48-px h-48-px bg-warning-main flex-shrink-0 text-white d-flex justify-content-center align-items-center rounded-circle h6">
                                <iconify-icon icon="solar:danger-outline"></iconify-icon>
                            </span>
                            <div>
                                <span class="mb-2 fw-medium text-secondary-light text-sm">Cảnh Báo Hôm Nay</span>
                                <h6 class="fw-semibold">3</h6>
                            </div>
                        </div>
                        <p class="text-sm mb-0">
                            <span class="text-warning-main fw-medium">2</span> đã xử lý
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-xxl-3 col-sm-6">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="mb-0 w-48-px h-48-px bg-info-main flex-shrink-0 text-white d-flex justify-content-center align-items-center rounded-circle h6">
                                <iconify-icon icon="solar:users-group-rounded-outline"></iconify-icon>
                            </span>
                            <div>
                                <span class="mb-2 fw-medium text-secondary-light text-sm">Users Online</span>
                                <h6 class="fw-semibold">47</h6>
                            </div>
                        </div>
                        <p class="text-sm mb-0">
                            <span class="text-info-main fw-medium">8</span> admin sessions
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-xxl-3 col-sm-6">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="mb-0 w-48-px h-48-px bg-danger-main flex-shrink-0 text-white d-flex justify-content-center align-items-center rounded-circle h6">
                                <iconify-icon icon="solar:lock-outline"></iconify-icon>
                            </span>
                            <div>
                                <span class="mb-2 fw-medium text-secondary-light text-sm">Tài Khoản Bị Khóa</span>
                                <h6 class="fw-semibold">2</h6>
                            </div>
                        </div>
                        <p class="text-sm mb-0">
                            Trong <span class="text-danger-main fw-medium">24h</span> qua
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Security Actions and Monitoring -->
        <div class="row gy-4 mb-24">
            <!-- Security Actions -->
            <div class="col-xxl-6">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">⚡ Thao Tác Bảo Mật</h6>
                    </div>
                    <div class="card-body p-24">
                        <div class="row gy-3">
                            <div class="col-md-6">
                                <a href="${pageContext.request.contextPath}/admin/security/access" class="btn btn-outline-primary w-100 d-flex align-items-center justify-content-center gap-2 py-3">
                                    <iconify-icon icon="solar:key-outline"></iconify-icon>
                                    Kiểm Soát Truy Cập
                                </a>
                            </div>
                            <div class="col-md-6">
                                <a href="${pageContext.request.contextPath}/admin/security/audit" class="btn btn-outline-warning w-100 d-flex align-items-center justify-content-center gap-2 py-3">
                                    <iconify-icon icon="solar:document-text-outline"></iconify-icon>
                                    Nhật Ký Audit
                                </a>
                            </div>
                            <div class="col-md-6">
                                <a href="${pageContext.request.contextPath}/admin/security/permissions" class="btn btn-outline-success w-100 d-flex align-items-center justify-content-center gap-2 py-3">
                                    <iconify-icon icon="solar:shield-user-outline"></iconify-icon>
                                    Phân Quyền
                                </a>
                            </div>
                            <div class="col-md-6">
                                <a href="${pageContext.request.contextPath}/admin/security/sessions" class="btn btn-outline-info w-100 d-flex align-items-center justify-content-center gap-2 py-3">
                                    <iconify-icon icon="solar:clock-circle-outline"></iconify-icon>
                                    Quản Lý Session
                                </a>
                            </div>
                            <div class="col-md-6">
                                <a href="${pageContext.request.contextPath}/admin/security/policies" class="btn btn-outline-purple w-100 d-flex align-items-center justify-content-center gap-2 py-3">
                                    <iconify-icon icon="solar:document-outline"></iconify-icon>
                                    Chính Sách Bảo Mật
                                </a>
                            </div>
                            <div class="col-md-6">
                                <button class="btn btn-outline-danger w-100 d-flex align-items-center justify-content-center gap-2 py-3">
                                    <iconify-icon icon="solar:refresh-outline"></iconify-icon>
                                    Quét Bảo Mật
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Real-time Monitoring -->
            <div class="col-xxl-6">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">👁️ Giám Sát Thời Gian Thực</h6>
                    </div>
                    <div class="card-body p-24">
                        <div class="d-flex flex-column gap-3">
                            <div class="d-flex align-items-center justify-content-between p-12 border radius-8">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="w-8-px h-8-px bg-success-main rounded-circle"></div>
                                    <span class="text-sm fw-medium">Firewall Status</span>
                                </div>
                                <span class="badge text-xs fw-semibold text-success-600 bg-success-100 px-12 py-4 radius-4">Active</span>
                            </div>
                            <div class="d-flex align-items-center justify-content-between p-12 border radius-8">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="w-8-px h-8-px bg-success-main rounded-circle"></div>
                                    <span class="text-sm fw-medium">SSL Certificate</span>
                                </div>
                                <span class="badge text-xs fw-semibold text-success-600 bg-success-100 px-12 py-4 radius-4">Valid</span>
                            </div>
                            <div class="d-flex align-items-center justify-content-between p-12 border radius-8">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="w-8-px h-8-px bg-warning-main rounded-circle"></div>
                                    <span class="text-sm fw-medium">Antivirus Scan</span>
                                </div>
                                <span class="badge text-xs fw-semibold text-warning-600 bg-warning-100 px-12 py-4 radius-4">Running</span>
                            </div>
                            <div class="d-flex align-items-center justify-content-between p-12 border radius-8">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="w-8-px h-8-px bg-success-main rounded-circle"></div>
                                    <span class="text-sm fw-medium">Intrusion Detection</span>
                                </div>
                                <span class="badge text-xs fw-semibold text-success-600 bg-success-100 px-12 py-4 radius-4">Active</span>
                            </div>
                            <div class="d-flex align-items-center justify-content-between p-12 border radius-8">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="w-8-px h-8-px bg-success-main rounded-circle"></div>
                                    <span class="text-sm fw-medium">Backup Encryption</span>
                                </div>
                                <span class="badge text-xs fw-semibold text-success-600 bg-success-100 px-12 py-4 radius-4">Enabled</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Security Events and Threats -->
        <div class="row gy-4">
            <!-- Recent Security Events -->
            <div class="col-xxl-6">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center justify-content-between">
                        <h6 class="text-lg fw-semibold mb-0">🚨 Sự Kiện Bảo Mật Gần Đây</h6>
                        <a href="${pageContext.request.contextPath}/admin/security/audit" class="text-primary-600 hover-text-primary fw-medium">Xem Tất Cả</a>
                    </div>
                    <div class="card-body p-24">
                        <div class="d-flex flex-column gap-3">
                            <div class="d-flex align-items-start gap-3 p-16 border radius-8 border-danger">
                                <iconify-icon icon="solar:danger-outline" class="text-danger-main text-xl mt-1"></iconify-icon>
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Đăng Nhập Bất Thường</h6>
                                    <span class="text-sm text-secondary-light">IP: 192.168.1.100 thử đăng nhập admin 5 lần</span>
                                    <p class="text-xs text-secondary-light mb-0 mt-1">5 phút trước</p>
                                </div>
                            </div>
                            <div class="d-flex align-items-start gap-3 p-16 border radius-8 border-warning">
                                <iconify-icon icon="solar:info-circle-outline" class="text-warning-main text-xl mt-1"></iconify-icon>
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Thay Đổi Quyền</h6>
                                    <span class="text-sm text-secondary-light">Admin cấp quyền MANAGER cho user ID: 1234</span>
                                    <p class="text-xs text-secondary-light mb-0 mt-1">1 giờ trước</p>
                                </div>
                            </div>
                            <div class="d-flex align-items-start gap-3 p-16 border radius-8 border-success">
                                <iconify-icon icon="solar:check-circle-outline" class="text-success-main text-xl mt-1"></iconify-icon>
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Backup Thành Công</h6>
                                    <span class="text-sm text-secondary-light">Sao lưu dữ liệu hệ thống hoàn tất</span>
                                    <p class="text-xs text-secondary-light mb-0 mt-1">3 giờ trước</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Threat Analysis -->
            <div class="col-xxl-6">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">🛡️ Phân Tích Mối Đe Dọa</h6>
                    </div>
                    <div class="card-body p-24">
                        <div class="d-flex flex-column gap-3">
                            <div class="d-flex align-items-center justify-content-between p-16 border radius-8">
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Brute Force Attacks</h6>
                                    <span class="text-sm text-secondary-light">Số lần thử trong 24h</span>
                                </div>
                                <span class="badge text-sm fw-semibold text-danger-600 bg-danger-100 px-20 py-9 radius-4">15</span>
                            </div>
                            <div class="d-flex align-items-center justify-content-between p-16 border radius-8">
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">SQL Injection Attempts</h6>
                                    <span class="text-sm text-secondary-light">Bị chặn bởi WAF</span>
                                </div>
                                <span class="badge text-sm fw-semibold text-warning-600 bg-warning-100 px-20 py-9 radius-4">3</span>
                            </div>
                            <div class="d-flex align-items-center justify-content-between p-16 border radius-8">
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Suspicious File Uploads</h6>
                                    <span class="text-sm text-secondary-light">Đã bị quarantine</span>
                                </div>
                                <span class="badge text-sm fw-semibold text-info-600 bg-info-100 px-20 py-9 radius-4">1</span>
                            </div>
                            <div class="d-flex align-items-center justify-content-between p-16 border radius-8">
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">DDoS Attempts</h6>
                                    <span class="text-sm text-secondary-light">Trong tuần này</span>
                                </div>
                                <span class="badge text-sm fw-semibold text-success-600 bg-success-100 px-20 py-9 radius-4">0</span>
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