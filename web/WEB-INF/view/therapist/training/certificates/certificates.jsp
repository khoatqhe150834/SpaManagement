<%-- 
    Document   : certificates.jsp
    Created on : Therapist Training Certificates Page
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
    <title>Chứng Chỉ - Therapist Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />

</head>
<body>
    <jsp:include page="/WEB-INF/view/therapist/shared/sidebar.jsp" />

        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Chứng Chỉ</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/therapist-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Bảng Điều Khiển
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Chứng Chỉ</li>
                </ul>
            </div>

            <div class="row gy-4">
                <!-- Certificate Cards -->
                <div class="col-xl-4 col-md-6">
                    <div class="card border">
                        <div class="card-body">
                            <div class="text-center mb-16">
                                <div class="w-80-px h-80-px bg-success-focus text-success-main rounded-circle d-flex justify-content-center align-items-center mx-auto mb-12">
                                    <iconify-icon icon="solar:diploma-verified-outline" class="text-4xl"></iconify-icon>
                                </div>
                                <h6 class="mb-4">Chứng Chỉ Massage Thái</h6>
                                <span class="bg-success-focus text-success-main px-12 py-4 rounded-pill fw-medium text-sm">
                                    Đã Cấp
                                </span>
                            </div>
                            <div class="mb-16">
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Ngày cấp:</span>
                                    <span class="fw-medium text-sm">15/06/2023</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Có hiệu lực:</span>
                                    <span class="fw-medium text-sm">15/06/2026</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Cơ quan cấp:</span>
                                    <span class="fw-medium text-sm">Hiệp hội Spa VN</span>
                                </div>
                            </div>
                            <div class="d-flex align-items-center gap-8">
                                <button type="button" class="btn btn-primary btn-sm flex-fill">
                                    <iconify-icon icon="solar:eye-outline"></iconify-icon>
                                    Xem Chi Tiết
                                </button>
                                <button type="button" class="btn btn-outline-primary btn-sm flex-fill">
                                    <iconify-icon icon="solar:download-outline"></iconify-icon>
                                    Tải Xuống
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-4 col-md-6">
                    <div class="card border">
                        <div class="card-body">
                            <div class="text-center mb-16">
                                <div class="w-80-px h-80-px bg-warning-focus text-warning-main rounded-circle d-flex justify-content-center align-items-center mx-auto mb-12">
                                    <iconify-icon icon="solar:diploma-outline" class="text-4xl"></iconify-icon>
                                </div>
                                <h6 class="mb-4">Chứng Chỉ Aromatherapy</h6>
                                <span class="bg-warning-focus text-warning-main px-12 py-4 rounded-pill fw-medium text-sm">
                                    Sắp Hết Hạn
                                </span>
                            </div>
                            <div class="mb-16">
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Ngày cấp:</span>
                                    <span class="fw-medium text-sm">20/01/2022</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Có hiệu lực:</span>
                                    <span class="fw-medium text-sm text-warning-main">20/01/2025</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Cơ quan cấp:</span>
                                    <span class="fw-medium text-sm">Trung tâm Đào tạo Spa</span>
                                </div>
                            </div>
                            <div class="d-flex align-items-center gap-8">
                                <button type="button" class="btn btn-warning btn-sm flex-fill">
                                    <iconify-icon icon="solar:refresh-outline"></iconify-icon>
                                    Gia Hạn
                                </button>
                                <button type="button" class="btn btn-outline-primary btn-sm flex-fill">
                                    <iconify-icon icon="solar:download-outline"></iconify-icon>
                                    Tải Xuống
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-4 col-md-6">
                    <div class="card border">
                        <div class="card-body">
                            <div class="text-center mb-16">
                                <div class="w-80-px h-80-px bg-info-focus text-info-main rounded-circle d-flex justify-content-center align-items-center mx-auto mb-12">
                                    <iconify-icon icon="solar:clock-circle-outline" class="text-4xl"></iconify-icon>
                                </div>
                                <h6 class="mb-4">Chứng Chỉ Hot Stone</h6>
                                <span class="bg-info-focus text-info-main px-12 py-4 rounded-pill fw-medium text-sm">
                                    Đang Xử Lý
                                </span>
                            </div>
                            <div class="mb-16">
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Ngày nộp:</span>
                                    <span class="fw-medium text-sm">10/12/2024</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Dự kiến cấp:</span>
                                    <span class="fw-medium text-sm">25/12/2024</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between mb-8">
                                    <span class="text-secondary-light text-sm">Cơ quan cấp:</span>
                                    <span class="fw-medium text-sm">Hiệp hội Spa VN</span>
                                </div>
                            </div>
                            <div class="d-flex align-items-center gap-8">
                                <button type="button" class="btn btn-info btn-sm flex-fill">
                                    <iconify-icon icon="solar:refresh-outline"></iconify-icon>
                                    Kiểm Tra
                                </button>
                                <button type="button" class="btn btn-outline-secondary btn-sm flex-fill" disabled>
                                    <iconify-icon icon="solar:download-outline"></iconify-icon>
                                    Chưa Có
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Add Certificate Button -->
                <div class="col-xl-4 col-md-6">
                    <div class="card border-dashed border-2 h-100">
                        <div class="card-body d-flex flex-column justify-content-center align-items-center text-center">
                            <div class="w-80-px h-80-px bg-primary-focus text-primary-main rounded-circle d-flex justify-content-center align-items-center mx-auto mb-16">
                                <iconify-icon icon="solar:add-circle-outline" class="text-4xl"></iconify-icon>
                            </div>
                            <h6 class="mb-8">Thêm Chứng Chỉ Mới</h6>
                            <p class="text-secondary-light text-sm mb-16">Tải lên chứng chỉ đào tạo mới</p>
                            <button type="button" class="btn btn-primary btn-sm">
                                <iconify-icon icon="solar:upload-outline"></iconify-icon>
                                Tải Lên
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Empty State (when no certificates) -->
                <div class="col-12" style="display: none;">
                    <div class="text-center py-5">
                        <iconify-icon icon="solar:diploma-outline" class="text-secondary-light mb-16" style="font-size: 64px;"></iconify-icon>
                        <h6 class="mb-8">Chưa có chứng chỉ nào</h6>
                        <p class="text-secondary-light mb-16">Tải lên các chứng chỉ đào tạo của bạn</p>
                        <button type="button" class="btn btn-primary">
                            <iconify-icon icon="solar:upload-outline"></iconify-icon>
                            Tải Lên Chứng Chỉ
                        </button>
                    </div>
                </div>
            </div>
        </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html> 


