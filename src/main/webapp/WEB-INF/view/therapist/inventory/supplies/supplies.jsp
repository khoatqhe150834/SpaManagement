<%-- 
    Document   : supplies.jsp
    Created on : Therapist Inventory Supplies Page
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
    <title>Tình Trạng Vật Tư - Therapist Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />

</head>
<body>
    <jsp:include page="/WEB-INF/view/therapist/shared/sidebar.jsp" />

        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Tình Trạng Vật Tư</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/therapist-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Bảng Điều Khiển
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Tình Trạng Vật Tư</li>
                </ul>
            </div>

            <div class="row gy-4">
                <!-- Supply Items -->
                <div class="col-xl-4 col-md-6">
                    <div class="card border">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between mb-16">
                                <div class="d-flex align-items-center gap-12">
                                    <div class="w-50-px h-50-px bg-primary-focus text-primary-main rounded-circle d-flex justify-content-center align-items-center">
                                        <iconify-icon icon="solar:oil-outline" class="text-xl"></iconify-icon>
                                    </div>
                                    <div>
                                        <h6 class="mb-4">Tinh Dầu Lavender</h6>
                                        <span class="text-secondary-light text-sm">Aromatherapy</span>
                                    </div>
                                </div>
                                <span class="bg-success-focus text-success-main px-8 py-4 rounded-pill fw-medium text-sm">
                                    Đủ
                                </span>
                            </div>
                            <div class="mb-16">
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Số lượng:</span>
                                    <span class="fw-medium text-sm">15 chai</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Mức tối thiểu:</span>
                                    <span class="fw-medium text-sm">5 chai</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Hạn sử dụng:</span>
                                    <span class="fw-medium text-sm">15/08/2025</span>
                                </div>
                            </div>
                            <div class="progress-item">
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Mức sử dụng</span>
                                    <span class="text-secondary-light text-sm">75%</span>
                                </div>
                                <div class="progress" role="progressbar">
                                    <div class="progress-bar bg-success-main" style="width: 75%"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-4 col-md-6">
                    <div class="card border">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between mb-16">
                                <div class="d-flex align-items-center gap-12">
                                    <div class="w-50-px h-50-px bg-warning-focus text-warning-main rounded-circle d-flex justify-content-center align-items-center">
                                        <iconify-icon icon="solar:layers-outline" class="text-xl"></iconify-icon>
                                    </div>
                                    <div>
                                        <h6 class="mb-4">Khăn Massage</h6>
                                        <span class="text-secondary-light text-sm">Vật tư tiêu hao</span>
                                    </div>
                                </div>
                                <span class="bg-warning-focus text-warning-main px-8 py-4 rounded-pill fw-medium text-sm">
                                    Thấp
                                </span>
                            </div>
                            <div class="mb-16">
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Số lượng:</span>
                                    <span class="fw-medium text-sm">8 chiếc</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Mức tối thiểu:</span>
                                    <span class="fw-medium text-sm">15 chiếc</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Trạng thái:</span>
                                    <span class="fw-medium text-sm">Cần bổ sung</span>
                                </div>
                            </div>
                            <div class="progress-item">
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Mức tồn kho</span>
                                    <span class="text-secondary-light text-sm">35%</span>
                                </div>
                                <div class="progress" role="progressbar">
                                    <div class="progress-bar bg-warning-main" style="width: 35%"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-4 col-md-6">
                    <div class="card border">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between mb-16">
                                <div class="d-flex align-items-center gap-12">
                                    <div class="w-50-px h-50-px bg-danger-focus text-danger-main rounded-circle d-flex justify-content-center align-items-center">
                                        <iconify-icon icon="solar:bottle-outline" class="text-xl"></iconify-icon>
                                    </div>
                                    <div>
                                        <h6 class="mb-4">Kem Dưỡng Ẩm</h6>
                                        <span class="text-secondary-light text-sm">Sản phẩm chăm sóc</span>
                                    </div>
                                </div>
                                <span class="bg-danger-focus text-danger-main px-8 py-4 rounded-pill fw-medium text-sm">
                                    Hết
                                </span>
                            </div>
                            <div class="mb-16">
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Số lượng:</span>
                                    <span class="fw-medium text-sm text-danger-main">0 lọ</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Mức tối thiểu:</span>
                                    <span class="fw-medium text-sm">3 lọ</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Trạng thái:</span>
                                    <span class="fw-medium text-sm text-danger-main">Cần mua ngay</span>
                                </div>
                            </div>
                            <div class="progress-item">
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Mức tồn kho</span>
                                    <span class="text-secondary-light text-sm">0%</span>
                                </div>
                                <div class="progress" role="progressbar">
                                    <div class="progress-bar bg-danger-main" style="width: 0%"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-4 col-md-6">
                    <div class="card border">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between mb-16">
                                <div class="d-flex align-items-center gap-12">
                                    <div class="w-50-px h-50-px bg-info-focus text-info-main rounded-circle d-flex justify-content-center align-items-center">
                                        <iconify-icon icon="solar:mask-outline" class="text-xl"></iconify-icon>
                                    </div>
                                    <div>
                                        <h6 class="mb-4">Mặt Nạ Collagen</h6>
                                        <span class="text-secondary-light text-sm">Chăm sóc da mặt</span>
                                    </div>
                                </div>
                                <span class="bg-success-focus text-success-main px-8 py-4 rounded-pill fw-medium text-sm">
                                    Đủ
                                </span>
                            </div>
                            <div class="mb-16">
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Số lượng:</span>
                                    <span class="fw-medium text-sm">25 miếng</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Mức tối thiểu:</span>
                                    <span class="fw-medium text-sm">10 miếng</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Hạn sử dụng:</span>
                                    <span class="fw-medium text-sm">30/06/2025</span>
                                </div>
                            </div>
                            <div class="progress-item">
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Mức sử dụng</span>
                                    <span class="text-secondary-light text-sm">60%</span>
                                </div>
                                <div class="progress" role="progressbar">
                                    <div class="progress-bar bg-success-main" style="width: 60%"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h6 class="card-title mb-0">Thao Tác Nhanh</h6>
                        </div>
                        <div class="card-body">
                            <div class="row gy-3">
                                <div class="col-md-3 col-sm-6">
                                    <button type="button" class="btn btn-outline-primary w-100">
                                        <iconify-icon icon="solar:add-circle-outline" class="icon"></iconify-icon>
                                        Yêu Cầu Vật Tư
                                    </button>
                                </div>
                                <div class="col-md-3 col-sm-6">
                                    <button type="button" class="btn btn-outline-warning w-100">
                                        <iconify-icon icon="solar:refresh-outline" class="icon"></iconify-icon>
                                        Cập Nhật Tồn Kho
                                    </button>
                                </div>
                                <div class="col-md-3 col-sm-6">
                                    <button type="button" class="btn btn-outline-info w-100">
                                        <iconify-icon icon="solar:eye-outline" class="icon"></iconify-icon>
                                        Xem Báo Cáo
                                    </button>
                                </div>
                                <div class="col-md-3 col-sm-6">
                                    <button type="button" class="btn btn-outline-success w-100">
                                        <iconify-icon icon="solar:download-outline" class="icon"></iconify-icon>
                                        Xuất Danh Sách
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Empty State -->
                <div class="col-12" style="display: none;">
                    <div class="text-center py-5">
                        <iconify-icon icon="solar:box-outline" class="text-secondary-light mb-16" style="font-size: 64px;"></iconify-icon>
                        <h6 class="mb-8">Chưa có vật tư nào</h6>
                        <p class="text-secondary-light mb-0">Danh sách vật tư và thiết bị sẽ xuất hiện ở đây</p>
                    </div>
                </div>
            </div>
        </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html> 


