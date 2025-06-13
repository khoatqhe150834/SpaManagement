<%-- 
    Document   : settings.jsp
    Created on : Admin System Settings
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
    <title>⚙️ Cài Đặt Hệ Thống - Admin Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
</head>
<body>
    <jsp:include page="/WEB-INF/view/admin/shared/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">⚙️ Cài Đặt Hệ Thống</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/admin-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Admin Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Hệ Thống</li>
                <li>-</li>
                <li class="fw-medium">Cài Đặt</li>
            </ul>
        </div>

        <div class="row gy-4">
            <!-- General Settings -->
            <div class="col-lg-6">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">🏢 Cài Đặt Chung</h6>
                    </div>
                    <div class="card-body p-24">
                        <form>
                            <div class="mb-20">
                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">Tên Hệ Thống</label>
                                <input type="text" class="form-control radius-8" value="BeautyZone Spa Management" name="systemName">
                            </div>
                            <div class="mb-20">
                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">Email Hệ Thống</label>
                                <input type="email" class="form-control radius-8" value="admin@beautyzone.com" name="systemEmail">
                            </div>
                            <div class="mb-20">
                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">Múi Giờ</label>
                                <select class="form-select radius-8" name="timezone">
                                    <option value="Asia/Ho_Chi_Minh" selected>UTC+7 (Việt Nam)</option>
                                    <option value="UTC">UTC</option>
                                </select>
                            </div>
                            <div class="mb-20">
                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">Ngôn Ngữ Mặc Định</label>
                                <select class="form-select radius-8" name="defaultLanguage">
                                    <option value="vi" selected>Tiếng Việt</option>
                                    <option value="en">English</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary-600">
                                <iconify-icon icon="solar:diskette-outline" class="icon"></iconify-icon>
                                Lưu Cài Đặt
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Email Settings -->
            <div class="col-lg-6">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">📧 Cài Đặt Email</h6>
                    </div>
                    <div class="card-body p-24">
                        <form>
                            <div class="mb-20">
                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">SMTP Server</label>
                                <input type="text" class="form-control radius-8" placeholder="smtp.gmail.com" name="smtpServer">
                            </div>
                            <div class="mb-20">
                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">SMTP Port</label>
                                <input type="number" class="form-control radius-8" value="587" name="smtpPort">
                            </div>
                            <div class="mb-20">
                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">Email Username</label>
                                <input type="email" class="form-control radius-8" placeholder="noreply@beautyzone.com" name="emailUsername">
                            </div>
                            <div class="mb-20">
                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">Email Password</label>
                                <input type="password" class="form-control radius-8" placeholder="••••••••" name="emailPassword">
                            </div>
                            <div class="mb-20">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="enableSSL" checked>
                                    <label class="form-check-label" for="enableSSL">
                                        Bật SSL/TLS
                                    </label>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-success-600">
                                <iconify-icon icon="solar:letter-outline" class="icon"></iconify-icon>
                                Test & Lưu
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Security Settings -->
            <div class="col-lg-6">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">🔐 Cài Đặt Bảo Mật</h6>
                    </div>
                    <div class="card-body p-24">
                        <form>
                            <div class="mb-20">
                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">Session Timeout (phút)</label>
                                <input type="number" class="form-control radius-8" value="30" name="sessionTimeout">
                            </div>
                            <div class="mb-20">
                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">Số Lần Đăng Nhập Sai Tối Đa</label>
                                <input type="number" class="form-control radius-8" value="5" name="maxLoginAttempts">
                            </div>
                            <div class="mb-20">
                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">Thời Gian Khóa Tài Khoản (phút)</label>
                                <input type="number" class="form-control radius-8" value="15" name="lockoutDuration">
                            </div>
                            <div class="mb-20">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="require2FA">
                                    <label class="form-check-label" for="require2FA">
                                        Bắt buộc 2FA cho Admin
                                    </label>
                                </div>
                            </div>
                            <div class="mb-20">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="forcePasswordChange" checked>
                                    <label class="form-check-label" for="forcePasswordChange">
                                        Đổi mật khẩu định kỳ (90 ngày)
                                    </label>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-warning-600">
                                <iconify-icon icon="solar:shield-check-outline" class="icon"></iconify-icon>
                                Cập Nhật Bảo Mật
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Business Settings -->
            <div class="col-lg-6">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">💼 Cài Đặt Kinh Doanh</h6>
                    </div>
                    <div class="card-body p-24">
                        <form>
                            <div class="mb-20">
                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">Đơn Vị Tiền Tệ</label>
                                <select class="form-select radius-8" name="currency">
                                    <option value="VND" selected>VND (Việt Nam Đồng)</option>
                                    <option value="USD">USD (US Dollar)</option>
                                </select>
                            </div>
                            <div class="mb-20">
                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">Thuế VAT (%)</label>
                                <input type="number" class="form-control radius-8" value="10" step="0.1" name="vatRate">
                            </div>
                            <div class="mb-20">
                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">Giờ Mở Cửa</label>
                                <input type="time" class="form-control radius-8" value="08:00" name="openTime">
                            </div>
                            <div class="mb-20">
                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">Giờ Đóng Cửa</label>
                                <input type="time" class="form-control radius-8" value="22:00" name="closeTime">
                            </div>
                            <div class="mb-20">
                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">Thời Gian Booking Tối Thiểu (phút)</label>
                                <input type="number" class="form-control radius-8" value="30" name="minBookingDuration">
                            </div>
                            <button type="submit" class="btn btn-info-600">
                                <iconify-icon icon="solar:business-outline" class="icon"></iconify-icon>
                                Lưu Cài Đặt
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html> 