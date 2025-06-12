<%-- 
    Document   : active.jsp
    Created on : Therapist Active Treatments
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liệu Pháp Đang Thực Hiện - Therapist Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
</head>
<body>
    <jsp:include page="/WEB-INF/view/therapist/shared/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Liệu Pháp Đang Thực Hiện</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/therapist-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Liệu Pháp</li>
                <li>-</li>
                <li class="fw-medium">Đang Thực Hiện</li>
            </ul>
        </div>

        <div class="card">
            <div class="card-header border-bottom bg-base py-16 px-24">
                <h6 class="text-lg fw-semibold mb-0">Các Liệu Pháp Đang Thực Hiện</h6>
            </div>
            <div class="card-body p-24">
                <div class="row gy-4">
                    <div class="col-md-6">
                        <div class="card border">
                            <div class="card-body p-20">
                                <div class="d-flex align-items-center justify-content-between mb-3">
                                    <span class="badge text-sm fw-semibold text-success-600 bg-success-100 px-20 py-9 radius-4">Đang Thực Hiện</span>
                                    <span class="text-sm text-secondary-light">Bắt đầu: 09:00</span>
                                </div>
                                <h6 class="text-lg fw-semibold mb-2">Nguyễn Thị Lan Anh</h6>
                                <p class="text-sm text-secondary-light mb-3">Massage Toàn Thân với Tinh Dầu Lavender</p>
                                <div class="row gy-2 mb-3">
                                    <div class="col-6">
                                        <span class="text-xs text-secondary-light">Thời gian:</span>
                                        <div class="text-sm fw-medium">90 phút</div>
                                    </div>
                                    <div class="col-6">
                                        <span class="text-xs text-secondary-light">Phòng:</span>
                                        <div class="text-sm fw-medium">VIP 1</div>
                                    </div>
                                    <div class="col-6">
                                        <span class="text-xs text-secondary-light">Đã thực hiện:</span>
                                        <div class="text-sm fw-medium text-primary-600">45 phút</div>
                                    </div>
                                    <div class="col-6">
                                        <span class="text-xs text-secondary-light">Còn lại:</span>
                                        <div class="text-sm fw-medium text-warning-main">45 phút</div>
                                    </div>
                                </div>
                                <div class="progress mb-3" style="height: 8px;">
                                    <div class="progress-bar bg-primary-600" role="progressbar" style="width: 50%" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                                <div class="d-flex gap-2">
                                    <button class="btn btn-outline-primary btn-sm">Ghi Chú</button>
                                    <button class="btn btn-success btn-sm">Hoàn Thành</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="card border">
                            <div class="card-body p-20">
                                <div class="d-flex align-items-center justify-content-between mb-3">
                                    <span class="badge text-sm fw-semibold text-warning-600 bg-warning-100 px-20 py-9 radius-4">Chuẩn Bị</span>
                                    <span class="text-sm text-secondary-light">Dự kiến: 11:00</span>
                                </div>
                                <h6 class="text-lg fw-semibold mb-2">Trần Văn Minh</h6>
                                <p class="text-sm text-secondary-light mb-3">Chăm Sóc Da Mặt Nam Giới</p>
                                <div class="row gy-2 mb-3">
                                    <div class="col-6">
                                        <span class="text-xs text-secondary-light">Thời gian:</span>
                                        <div class="text-sm fw-medium">60 phút</div>
                                    </div>
                                    <div class="col-6">
                                        <span class="text-xs text-secondary-light">Phòng:</span>
                                        <div class="text-sm fw-medium">Phòng 2</div>
                                    </div>
                                    <div class="col-12">
                                        <span class="text-xs text-secondary-light">Ghi chú đặc biệt:</span>
                                        <div class="text-sm fw-medium">Da nhạy cảm, tránh sản phẩm có cồn</div>
                                    </div>
                                </div>
                                <div class="d-flex gap-2">
                                    <button class="btn btn-outline-info btn-sm">Xem Chi Tiết</button>
                                    <button class="btn btn-primary btn-sm">Bắt Đầu</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="card border">
                            <div class="card-body p-20">
                                <div class="d-flex align-items-center justify-content-between mb-3">
                                    <span class="badge text-sm fw-semibold text-info-600 bg-info-100 px-20 py-9 radius-4">Tạm Dừng</span>
                                    <span class="text-sm text-secondary-light">Dừng lúc: 10:30</span>
                                </div>
                                <h6 class="text-lg fw-semibold mb-2">Lê Thị Mai</h6>
                                <p class="text-sm text-secondary-light mb-3">Liệu Pháp Đá Nóng</p>
                                <div class="row gy-2 mb-3">
                                    <div class="col-6">
                                        <span class="text-xs text-secondary-light">Thời gian:</span>
                                        <div class="text-sm fw-medium">75 phút</div>
                                    </div>
                                    <div class="col-6">
                                        <span class="text-xs text-secondary-light">Phòng:</span>
                                        <div class="text-sm fw-medium">VIP 2</div>
                                    </div>
                                    <div class="col-6">
                                        <span class="text-xs text-secondary-light">Đã thực hiện:</span>
                                        <div class="text-sm fw-medium text-primary-600">30 phút</div>
                                    </div>
                                    <div class="col-6">
                                        <span class="text-xs text-secondary-light">Lý do dừng:</span>
                                        <div class="text-sm fw-medium text-warning-main">Khách nghỉ 10 phút</div>
                                    </div>
                                </div>
                                <div class="progress mb-3" style="height: 8px;">
                                    <div class="progress-bar bg-info-main" role="progressbar" style="width: 40%" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                                <div class="d-flex gap-2">
                                    <button class="btn btn-outline-warning btn-sm">Ghi Chú</button>
                                    <button class="btn btn-info btn-sm">Tiếp Tục</button>
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


