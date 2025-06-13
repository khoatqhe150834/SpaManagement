<%-- 
    Document   : overview.jsp
    Created on : Admin Financial Overview
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
    <title>💰 Tổng Quan Tài Chính - Admin Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
</head>
<body>
    <jsp:include page="/WEB-INF/view/admin/shared/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">💰 Tổng Quan Tài Chính Toàn Hệ Thống</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/admin-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Admin Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Tài Chính</li>
                <li>-</li>
                <li class="fw-medium">Tổng Quan</li>
            </ul>
        </div>

        <!-- Financial Metrics -->
        <div class="row gy-4 mb-24">
            <div class="col-xxl-3 col-sm-6">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="mb-0 w-48-px h-48-px bg-success-main flex-shrink-0 text-white d-flex justify-content-center align-items-center rounded-circle h6">
                                <iconify-icon icon="solar:chart-2-outline"></iconify-icon>
                            </span>
                            <div>
                                <span class="mb-2 fw-medium text-secondary-light text-sm">Tổng Doanh Thu Năm</span>
                                <h6 class="fw-semibold">8,500,000,000 VNĐ</h6>
                            </div>
                        </div>
                        <p class="text-sm mb-0">
                            <span class="text-success-main fw-medium">+12.5%</span> so với năm trước
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-xxl-3 col-sm-6">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="mb-0 w-48-px h-48-px bg-primary-600 flex-shrink-0 text-white d-flex justify-content-center align-items-center rounded-circle h6">
                                <iconify-icon icon="solar:dollar-outline"></iconify-icon>
                            </span>
                            <div>
                                <span class="mb-2 fw-medium text-secondary-light text-sm">Lợi Nhuận Tháng</span>
                                <h6 class="fw-semibold">180,000,000 VNĐ</h6>
                            </div>
                        </div>
                        <p class="text-sm mb-0">
                            <span class="text-success-main fw-medium">+8.2%</span> tăng trưởng
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-xxl-3 col-sm-6">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="mb-0 w-48-px h-48-px bg-danger-main flex-shrink-0 text-white d-flex justify-content-center align-items-center rounded-circle h6">
                                <iconify-icon icon="solar:bill-list-outline"></iconify-icon>
                            </span>
                            <div>
                                <span class="mb-2 fw-medium text-secondary-light text-sm">Chi Phí Tháng</span>
                                <h6 class="fw-semibold">520,000,000 VNĐ</h6>
                            </div>
                        </div>
                        <p class="text-sm mb-0">
                            <span class="text-warning-main fw-medium">+2.1%</span> so với tháng trước
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-xxl-3 col-sm-6">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="mb-0 w-48-px h-48-px bg-info-main flex-shrink-0 text-white d-flex justify-content-center align-items-center rounded-circle h6">
                                <iconify-icon icon="solar:wallet-outline"></iconify-icon>
                            </span>
                            <div>
                                <span class="mb-2 fw-medium text-secondary-light text-sm">Dòng Tiền</span>
                                <h6 class="fw-semibold">+45,000,000 VNĐ</h6>
                            </div>
                        </div>
                        <p class="text-sm mb-0">
                            <span class="text-success-main fw-medium">Tích cực</span> cash flow
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts and Quick Actions -->
        <div class="row gy-4 mb-24">
            <!-- Revenue Chart -->
            <div class="col-xxl-8">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center justify-content-between">
                        <h6 class="text-lg fw-semibold mb-0">📈 Biểu Đồ Doanh Thu 12 Tháng</h6>
                        <div class="d-flex align-items-center gap-3">
                            <select class="form-select form-select-sm w-auto">
                                <option>2024</option>
                                <option>2023</option>
                            </select>
                        </div>
                    </div>
                    <div class="card-body p-24">
                        <div class="d-flex justify-content-center align-items-center" style="height: 350px;">
                            <div class="text-center">
                                <iconify-icon icon="solar:chart-2-outline" class="text-secondary-light" style="font-size: 80px;"></iconify-icon>
                                <p class="text-secondary-light mt-3">Biểu đồ doanh thu sẽ được hiển thị tại đây</p>
                                <small class="text-secondary-light">Tích hợp với Chart.js hoặc ApexCharts</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Financial Quick Actions -->
            <div class="col-xxl-4">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">⚡ Thao Tác Nhanh</h6>
                    </div>
                    <div class="card-body p-24">
                        <div class="d-flex flex-column gap-3">
                            <a href="${pageContext.request.contextPath}/admin/financial/revenue" class="btn btn-outline-success d-flex align-items-center gap-2">
                                <iconify-icon icon="solar:chart-2-outline"></iconify-icon>
                                Báo Cáo Doanh Thu
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/financial/expenses" class="btn btn-outline-danger d-flex align-items-center gap-2">
                                <iconify-icon icon="solar:bill-list-outline"></iconify-icon>
                                Quản Lý Chi Phí
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/financial/invoices" class="btn btn-outline-warning d-flex align-items-center gap-2">
                                <iconify-icon icon="solar:document-text-outline"></iconify-icon>
                                Hóa Đơn & Thanh Toán
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/financial/budgets" class="btn btn-outline-info d-flex align-items-center gap-2">
                                <iconify-icon icon="solar:calculator-outline"></iconify-icon>
                                Lập Ngân Sách
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/financial/taxes" class="btn btn-outline-purple d-flex align-items-center gap-2">
                                <iconify-icon icon="solar:library-outline"></iconify-icon>
                                Quản Lý Thuế
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Financial Breakdown -->
        <div class="row gy-4">
            <!-- Revenue Sources -->
            <div class="col-xxl-4">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">🎯 Nguồn Doanh Thu</h6>
                    </div>
                    <div class="card-body p-24">
                        <div class="d-flex flex-column gap-3">
                            <div class="d-flex align-items-center justify-content-between p-16 border radius-8">
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Dịch Vụ Spa</h6>
                                    <span class="text-sm text-secondary-light">65% tổng doanh thu</span>
                                </div>
                                <span class="badge text-sm fw-semibold text-primary-600 bg-primary-100 px-16 py-8 radius-4">520M VNĐ</span>
                            </div>
                            <div class="d-flex align-items-center justify-content-between p-16 border radius-8">
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Gói Combo</h6>
                                    <span class="text-sm text-secondary-light">25% tổng doanh thu</span>
                                </div>
                                <span class="badge text-sm fw-semibold text-success-600 bg-success-100 px-16 py-8 radius-4">200M VNĐ</span>
                            </div>
                            <div class="d-flex align-items-center justify-content-between p-16 border radius-8">
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Sản Phẩm</h6>
                                    <span class="text-sm text-secondary-light">10% tổng doanh thu</span>
                                </div>
                                <span class="badge text-sm fw-semibold text-info-600 bg-info-100 px-16 py-8 radius-4">80M VNĐ</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Expense Categories -->
            <div class="col-xxl-4">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">💸 Chi Phí Chính</h6>
                    </div>
                    <div class="card-body p-24">
                        <div class="d-flex flex-column gap-3">
                            <div class="d-flex align-items-center justify-content-between p-16 border radius-8">
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Lương Nhân Viên</h6>
                                    <span class="text-sm text-secondary-light">45% tổng chi phí</span>
                                </div>
                                <span class="badge text-sm fw-semibold text-danger-600 bg-danger-100 px-16 py-8 radius-4">234M VNĐ</span>
                            </div>
                            <div class="d-flex align-items-center justify-content-between p-16 border radius-8">
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Thuê Mặt Bằng</h6>
                                    <span class="text-sm text-secondary-light">25% tổng chi phí</span>
                                </div>
                                <span class="badge text-sm fw-semibold text-warning-600 bg-warning-100 px-16 py-8 radius-4">130M VNĐ</span>
                            </div>
                            <div class="d-flex align-items-center justify-content-between p-16 border radius-8">
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Vật Tư & Thiết Bị</h6>
                                    <span class="text-sm text-secondary-light">20% tổng chi phí</span>
                                </div>
                                <span class="badge text-sm fw-semibold text-purple-600 bg-purple-100 px-16 py-8 radius-4">104M VNĐ</span>
                            </div>
                            <div class="d-flex align-items-center justify-content-between p-16 border radius-8">
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Marketing</h6>
                                    <span class="text-sm text-secondary-light">10% tổng chi phí</span>
                                </div>
                                <span class="badge text-sm fw-semibold text-info-600 bg-info-100 px-16 py-8 radius-4">52M VNĐ</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Financial Alerts -->
            <div class="col-xxl-4">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">⚠️ Cảnh Báo Tài Chính</h6>
                    </div>
                    <div class="card-body p-24">
                        <div class="d-flex flex-column gap-3">
                            <div class="d-flex align-items-start gap-3 p-16 border radius-8 border-warning">
                                <iconify-icon icon="solar:info-circle-outline" class="text-warning-main text-xl mt-1"></iconify-icon>
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Chi Phí Cao Bất Thường</h6>
                                    <span class="text-sm text-secondary-light">Chi phí tháng này cao hơn 15% so với ngân sách</span>
                                </div>
                            </div>
                            <div class="d-flex align-items-start gap-3 p-16 border radius-8 border-success">
                                <iconify-icon icon="solar:check-circle-outline" class="text-success-main text-xl mt-1"></iconify-icon>
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Doanh Thu Đạt Mục Tiêu</h6>
                                    <span class="text-sm text-secondary-light">Đã đạt 105% mục tiêu doanh thu tháng</span>
                                </div>
                            </div>
                            <div class="d-flex align-items-start gap-3 p-16 border radius-8 border-info">
                                <iconify-icon icon="solar:bell-outline" class="text-info-main text-xl mt-1"></iconify-icon>
                                <div>
                                    <h6 class="text-md fw-semibold mb-1">Báo Cáo Thuế Sắp Đến Hạn</h6>
                                    <span class="text-sm text-secondary-light">Báo cáo thuế Q4 cần nộp trong 10 ngày</span>
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