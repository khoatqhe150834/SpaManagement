<%-- 
    Document   : dashboard.jsp
    Created on : Admin Reports Dashboard
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
    <title>📊 Dashboard Báo Cáo - Admin Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
</head>
<body>
    <jsp:include page="/WEB-INF/view/admin/shared/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">📊 Dashboard Báo Cáo Tổng Hợp</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/admin-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Admin Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Báo Cáo</li>
                <li>-</li>
                <li class="fw-medium">Dashboard</li>
            </ul>
        </div>

        <!-- Report Categories -->
        <div class="row gy-4 mb-24">
            <div class="col-xxl-3 col-sm-6">
                <div class="card">
                    <div class="card-body text-center">
                        <div class="mb-3">
                            <iconify-icon icon="solar:chart-2-outline" class="text-primary-600" style="font-size: 48px;"></iconify-icon>
                        </div>
                        <h6 class="fw-semibold mb-2">Báo Cáo Doanh Thu</h6>
                        <p class="text-sm text-secondary-light mb-3">Phân tích chi tiết doanh thu theo thời gian, dịch vụ, chi nhánh</p>
                        <a href="${pageContext.request.contextPath}/admin/reports/revenue" class="btn btn-primary-600 w-100">
                            Xem Báo Cáo
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-xxl-3 col-sm-6">
                <div class="card">
                    <div class="card-body text-center">
                        <div class="mb-3">
                            <iconify-icon icon="solar:users-group-rounded-outline" class="text-success-600" style="font-size: 48px;"></iconify-icon>
                        </div>
                        <h6 class="fw-semibold mb-2">Báo Cáo Khách Hàng</h6>
                        <p class="text-sm text-secondary-light mb-3">Thống kê khách hàng mới, quay lại, phân tích hành vi</p>
                        <a href="${pageContext.request.contextPath}/admin/reports/customers" class="btn btn-success-600 w-100">
                            Xem Báo Cáo
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-xxl-3 col-sm-6">
                <div class="card">
                    <div class="card-body text-center">
                        <div class="mb-3">
                            <iconify-icon icon="solar:user-heart-outline" class="text-info-600" style="font-size: 48px;"></iconify-icon>
                        </div>
                        <h6 class="fw-semibold mb-2">Báo Cáo Nhân Viên</h6>
                        <p class="text-sm text-secondary-light mb-3">Hiệu suất, doanh số, thời gian làm việc của nhân viên</p>
                        <a href="${pageContext.request.contextPath}/admin/reports/staff" class="btn btn-info-600 w-100">
                            Xem Báo Cáo
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-xxl-3 col-sm-6">
                <div class="card">
                    <div class="card-body text-center">
                        <div class="mb-3">
                            <iconify-icon icon="solar:spa-outline" class="text-warning-600" style="font-size: 48px;"></iconify-icon>
                        </div>
                        <h6 class="fw-semibold mb-2">Báo Cáo Dịch Vụ</h6>
                        <p class="text-sm text-secondary-light mb-3">Dịch vụ phổ biến, tỷ lệ booking, đánh giá khách hàng</p>
                        <a href="${pageContext.request.contextPath}/admin/reports/services" class="btn btn-warning-600 w-100">
                            Xem Báo Cáo
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Report Actions -->
        <div class="row gy-4 mb-24">
            <div class="col-xxl-8">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">🚀 Tạo Báo Cáo Nhanh</h6>
                    </div>
                    <div class="card-body p-24">
                        <div class="row gy-3">
                            <div class="col-md-4">
                                <div class="border radius-8 p-16 text-center">
                                    <iconify-icon icon="solar:calendar-outline" class="text-primary-600 mb-2" style="font-size: 32px;"></iconify-icon>
                                    <h6 class="fw-semibold mb-1">Báo Cáo Ngày</h6>
                                    <p class="text-xs text-secondary-light mb-2">Doanh thu, booking hôm nay</p>
                                    <button class="btn btn-outline-primary btn-sm w-100">Tạo Báo Cáo</button>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="border radius-8 p-16 text-center">
                                    <iconify-icon icon="solar:chart-square-outline" class="text-success-600 mb-2" style="font-size: 32px;"></iconify-icon>
                                    <h6 class="fw-semibold mb-1">Báo Cáo Tháng</h6>
                                    <p class="text-xs text-secondary-light mb-2">Tổng hợp dữ liệu tháng</p>
                                    <button class="btn btn-outline-success btn-sm w-100">Tạo Báo Cáo</button>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="border radius-8 p-16 text-center">
                                    <iconify-icon icon="solar:document-text-outline" class="text-info-600 mb-2" style="font-size: 32px;"></iconify-icon>
                                    <h6 class="fw-semibold mb-1">Báo Cáo Tùy Chỉnh</h6>
                                    <p class="text-xs text-secondary-light mb-2">Tạo báo cáo theo yêu cầu</p>
                                    <button class="btn btn-outline-info btn-sm w-100">Tùy Chỉnh</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Reports -->
            <div class="col-xxl-4">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">📋 Báo Cáo Gần Đây</h6>
                    </div>
                    <div class="card-body p-24">
                        <div class="d-flex flex-column gap-3">
                            <div class="d-flex align-items-center justify-content-between p-12 border radius-8">
                                <div>
                                    <h6 class="text-sm fw-semibold mb-0">Doanh Thu Tháng 12</h6>
                                    <span class="text-xs text-secondary-light">PDF - 2.4MB</span>
                                </div>
                                <button class="btn btn-outline-primary btn-sm">
                                    <iconify-icon icon="solar:download-outline"></iconify-icon>
                                </button>
                            </div>
                            <div class="d-flex align-items-center justify-content-between p-12 border radius-8">
                                <div>
                                    <h6 class="text-sm fw-semibold mb-0">KH Mới Quý 4</h6>
                                    <span class="text-xs text-secondary-light">Excel - 1.8MB</span>
                                </div>
                                <button class="btn btn-outline-success btn-sm">
                                    <iconify-icon icon="solar:download-outline"></iconify-icon>
                                </button>
                            </div>
                            <div class="d-flex align-items-center justify-content-between p-12 border radius-8">
                                <div>
                                    <h6 class="text-sm fw-semibold mb-0">Hiệu Suất NV</h6>
                                    <span class="text-xs text-secondary-light">PDF - 3.1MB</span>
                                </div>
                                <button class="btn btn-outline-info btn-sm">
                                    <iconify-icon icon="solar:download-outline"></iconify-icon>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Report Analytics -->
        <div class="row gy-4">
            <!-- Top Metrics -->
            <div class="col-xxl-8">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">📈 Chỉ Số Quan Trọng</h6>
                    </div>
                    <div class="card-body p-24">
                        <div class="row gy-4">
                            <div class="col-md-6">
                                <div class="border radius-8 p-20">
                                    <div class="d-flex align-items-center justify-content-between mb-3">
                                        <h6 class="fw-semibold mb-0">Tăng Trưởng Doanh Thu</h6>
                                        <span class="badge text-sm fw-semibold text-success-600 bg-success-100 px-12 py-6 radius-4">+15.2%</span>
                                    </div>
                                    <div class="progress-bar-container">
                                        <div class="progress-bar bg-success-100" style="height: 8px; border-radius: 4px;">
                                            <div class="progress-fill bg-success-600" style="width: 75%; height: 100%; border-radius: 4px;"></div>
                                        </div>
                                    </div>
                                    <p class="text-sm text-secondary-light mt-2 mb-0">So với cùng kỳ năm trước</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="border radius-8 p-20">
                                    <div class="d-flex align-items-center justify-content-between mb-3">
                                        <h6 class="fw-semibold mb-0">Khách Hàng Quay Lại</h6>
                                        <span class="badge text-sm fw-semibold text-primary-600 bg-primary-100 px-12 py-6 radius-4">68%</span>
                                    </div>
                                    <div class="progress-bar-container">
                                        <div class="progress-bar bg-primary-100" style="height: 8px; border-radius: 4px;">
                                            <div class="progress-fill bg-primary-600" style="width: 68%; height: 100%; border-radius: 4px;"></div>
                                        </div>
                                    </div>
                                    <p class="text-sm text-secondary-light mt-2 mb-0">Tỷ lệ khách hàng quay lại</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="border radius-8 p-20">
                                    <div class="d-flex align-items-center justify-content-between mb-3">
                                        <h6 class="fw-semibold mb-0">Mức Độ Hài Lòng</h6>
                                        <span class="badge text-sm fw-semibold text-warning-600 bg-warning-100 px-12 py-6 radius-4">4.8/5</span>
                                    </div>
                                    <div class="progress-bar-container">
                                        <div class="progress-bar bg-warning-100" style="height: 8px; border-radius: 4px;">
                                            <div class="progress-fill bg-warning-600" style="width: 96%; height: 100%; border-radius: 4px;"></div>
                                        </div>
                                    </div>
                                    <p class="text-sm text-secondary-light mt-2 mb-0">Đánh giá trung bình</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="border radius-8 p-20">
                                    <div class="d-flex align-items-center justify-content-between mb-3">
                                        <h6 class="fw-semibold mb-0">Hiệu Suất Nhân Viên</h6>
                                        <span class="badge text-sm fw-semibold text-info-600 bg-info-100 px-12 py-6 radius-4">92%</span>
                                    </div>
                                    <div class="progress-bar-container">
                                        <div class="progress-bar bg-info-100" style="height: 8px; border-radius: 4px;">
                                            <div class="progress-fill bg-info-600" style="width: 92%; height: 100%; border-radius: 4px;"></div>
                                        </div>
                                    </div>
                                    <p class="text-sm text-secondary-light mt-2 mb-0">Điểm hiệu suất trung bình</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Export Options -->
            <div class="col-xxl-4">
                <div class="card h-100">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">📤 Xuất Báo Cáo</h6>
                    </div>
                    <div class="card-body p-24">
                        <div class="d-flex flex-column gap-3">
                            <button class="btn btn-outline-danger d-flex align-items-center gap-2">
                                <iconify-icon icon="solar:document-outline"></iconify-icon>
                                Xuất PDF
                            </button>
                            <button class="btn btn-outline-success d-flex align-items-center gap-2">
                                <iconify-icon icon="solar:document-text-outline"></iconify-icon>
                                Xuất Excel
                            </button>
                            <button class="btn btn-outline-info d-flex align-items-center gap-2">
                                <iconify-icon icon="solar:clipboard-outline"></iconify-icon>
                                Xuất CSV
                            </button>
                            <button class="btn btn-outline-warning d-flex align-items-center gap-2">
                                <iconify-icon icon="solar:printer-outline"></iconify-icon>
                                In Báo Cáo
                            </button>
                            <hr>
                            <a href="${pageContext.request.contextPath}/admin/reports/custom" class="btn btn-primary-600 d-flex align-items-center gap-2">
                                <iconify-icon icon="solar:settings-outline"></iconify-icon>
                                Báo Cáo Tùy Chỉnh
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html> 