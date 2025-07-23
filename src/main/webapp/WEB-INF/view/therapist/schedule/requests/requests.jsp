<%-- 
    Document   : requests.jsp
    Created on : Therapist Schedule Requests
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
    <title>Yêu Cầu Lịch Trình - Therapist Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Yêu Cầu Lịch Trình</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/therapist-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Lịch Trình</li>
                <li>-</li>
                <li class="fw-medium">Yêu Cầu</li>
            </ul>
        </div>

        <!-- Summary Cards -->
        <div class="row gy-4 mb-24">
            <div class="col-md-4">
                <div class="card shadow-none border bg-gradient-start-1 h-100">
                    <div class="card-body p-20">
                        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
                            <div>
                                <p class="fw-medium text-primary-light mb-1">Yêu Cầu Chờ Duyệt</p>
                                <h6 class="mb-0">5</h6>
                            </div>
                            <div class="w-50-px h-50-px bg-warning-main rounded-circle d-flex justify-content-center align-items-center">
                                <iconify-icon icon="material-symbols:pending" class="text-white text-2xl mb-0"></iconify-icon>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card shadow-none border bg-gradient-start-2 h-100">
                    <div class="card-body p-20">
                        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
                            <div>
                                <p class="fw-medium text-primary-light mb-1">Đã Chấp Nhận</p>
                                <h6 class="mb-0">12</h6>
                            </div>
                            <div class="w-50-px h-50-px bg-success-main rounded-circle d-flex justify-content-center align-items-center">
                                <iconify-icon icon="material-symbols:check-circle" class="text-white text-2xl mb-0"></iconify-icon>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card shadow-none border bg-gradient-start-3 h-100">
                    <div class="card-body p-20">
                        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
                            <div>
                                <p class="fw-medium text-primary-light mb-1">Đã Từ Chối</p>
                                <h6 class="mb-0">3</h6>
                            </div>
                            <div class="w-50-px h-50-px bg-danger-main rounded-circle d-flex justify-content-center align-items-center">
                                <iconify-icon icon="material-symbols:cancel" class="text-white text-2xl mb-0"></iconify-icon>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Pending Requests -->
        <div class="card">
            <div class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center justify-content-between">
                <h6 class="text-lg fw-semibold mb-0">Yêu Cầu Chờ Duyệt</h6>
                <div class="d-flex gap-2">
                    <button class="btn btn-outline-primary btn-sm">
                        <iconify-icon icon="material-symbols:filter-list" class="icon"></iconify-icon>
                        Lọc
                    </button>
                    <button class="btn btn-outline-secondary btn-sm">
                        <iconify-icon icon="material-symbols:refresh" class="icon"></iconify-icon>
                        Làm Mới
                    </button>
                </div>
            </div>
            <div class="card-body p-24">
                <div class="row gy-4">
                    <!-- Request 1 -->
                    <div class="col-12">
                        <div class="card border border-warning-200">
                            <div class="card-body p-20">
                                <div class="d-flex align-items-start justify-content-between gap-3 mb-3">
                                    <div class="flex-grow-1">
                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <span class="badge text-sm fw-semibold text-warning-600 bg-warning-100 px-12 py-6 radius-4">Chờ Duyệt</span>
                                            <span class="text-sm text-secondary-light">Yêu cầu #YC001</span>
                                        </div>
                                        <h6 class="text-lg fw-semibold mb-2">Nguyễn Thị Hương</h6>
                                        <p class="text-sm text-secondary-light mb-3">Massage Thư Giãn Toàn Thân</p>
                                    </div>
                                    <div class="text-end">
                                        <span class="text-xs text-secondary-light">Yêu cầu lúc</span>
                                        <div class="text-sm fw-medium">14:30 - 25/12/2024</div>
                                    </div>
                                </div>
                                
                                <div class="row gy-2 mb-3">
                                    <div class="col-md-3">
                                        <span class="text-xs text-secondary-light">Ngày hẹn:</span>
                                        <div class="text-sm fw-medium">28/12/2024</div>
                                    </div>
                                    <div class="col-md-3">
                                        <span class="text-xs text-secondary-light">Thời gian:</span>
                                        <div class="text-sm fw-medium">10:00 - 11:30</div>
                                    </div>
                                    <div class="col-md-3">
                                        <span class="text-xs text-secondary-light">Loại dịch vụ:</span>
                                        <div class="text-sm fw-medium">Massage (90 phút)</div>
                                    </div>
                                    <div class="col-md-3">
                                        <span class="text-xs text-secondary-light">Phòng mong muốn:</span>
                                        <div class="text-sm fw-medium">VIP 1</div>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <span class="text-xs text-secondary-light">Ghi chú đặc biệt:</span>
                                    <div class="text-sm">Khách hàng VIP, yêu cầu dịch vụ tận tình. Tránh tinh dầu có mùi nồng.</div>
                                </div>

                                <div class="d-flex justify-content-end gap-2">
                                    <button class="btn btn-outline-info btn-sm">
                                        <iconify-icon icon="material-symbols:info" class="icon"></iconify-icon>
                                        Chi Tiết
                                    </button>
                                    <button class="btn btn-outline-danger btn-sm">
                                        <iconify-icon icon="material-symbols:close" class="icon"></iconify-icon>
                                        Từ Chối
                                    </button>
                                    <button class="btn btn-success btn-sm">
                                        <iconify-icon icon="material-symbols:check" class="icon"></iconify-icon>
                                        Chấp Nhận
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Request 2 -->
                    <div class="col-12">
                        <div class="card border border-warning-200">
                            <div class="card-body p-20">
                                <div class="d-flex align-items-start justify-content-between gap-3 mb-3">
                                    <div class="flex-grow-1">
                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <span class="badge text-sm fw-semibold text-warning-600 bg-warning-100 px-12 py-6 radius-4">Chờ Duyệt</span>
                                            <span class="text-sm text-secondary-light">Yêu cầu #YC002</span>
                                        </div>
                                        <h6 class="text-lg fw-semibold mb-2">Trần Minh Khang</h6>
                                        <p class="text-sm text-secondary-light mb-3">Chăm Sóc Da Mặt Nam</p>
                                    </div>
                                    <div class="text-end">
                                        <span class="text-xs text-secondary-light">Yêu cầu lúc</span>
                                        <div class="text-sm fw-medium">16:15 - 25/12/2024</div>
                                    </div>
                                </div>
                                
                                <div class="row gy-2 mb-3">
                                    <div class="col-md-3">
                                        <span class="text-xs text-secondary-light">Ngày hẹn:</span>
                                        <div class="text-sm fw-medium">29/12/2024</div>
                                    </div>
                                    <div class="col-md-3">
                                        <span class="text-xs text-secondary-light">Thời gian:</span>
                                        <div class="text-sm fw-medium">14:00 - 15:00</div>
                                    </div>
                                    <div class="col-md-3">
                                        <span class="text-xs text-secondary-light">Loại dịch vụ:</span>
                                        <div class="text-sm fw-medium">Facial (60 phút)</div>
                                    </div>
                                    <div class="col-md-3">
                                        <span class="text-xs text-secondary-light">Phòng mong muốn:</span>
                                        <div class="text-sm fw-medium">Phòng 3</div>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <span class="text-xs text-secondary-light">Ghi chú đặc biệt:</span>
                                    <div class="text-sm">Da nhạy cảm, tránh sản phẩm có cồn. Lần đầu sử dụng dịch vụ.</div>
                                </div>

                                <div class="d-flex justify-content-end gap-2">
                                    <button class="btn btn-outline-info btn-sm">
                                        <iconify-icon icon="material-symbols:info" class="icon"></iconify-icon>
                                        Chi Tiết
                                    </button>
                                    <button class="btn btn-outline-danger btn-sm">
                                        <iconify-icon icon="material-symbols:close" class="icon"></iconify-icon>
                                        Từ Chối
                                    </button>
                                    <button class="btn btn-success btn-sm">
                                        <iconify-icon icon="material-symbols:check" class="icon"></iconify-icon>
                                        Chấp Nhận
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Request 3 -->
                    <div class="col-12">
                        <div class="card border border-warning-200">
                            <div class="card-body p-20">
                                <div class="d-flex align-items-start justify-content-between gap-3 mb-3">
                                    <div class="flex-grow-1">
                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <span class="badge text-sm fw-semibold text-warning-600 bg-warning-100 px-12 py-6 radius-4">Chờ Duyệt</span>
                                            <span class="text-sm text-secondary-light">Yêu cầu #YC003</span>
                                        </div>
                                        <h6 class="text-lg fw-semibold mb-2">Lê Thị Nga</h6>
                                        <p class="text-sm text-secondary-light mb-3">Liệu Pháp Đá Nóng</p>
                                    </div>
                                    <div class="text-end">
                                        <span class="text-xs text-secondary-light">Yêu cầu lúc</span>
                                        <div class="text-sm fw-medium">17:45 - 25/12/2024</div>
                                    </div>
                                </div>
                                
                                <div class="row gy-2 mb-3">
                                    <div class="col-md-3">
                                        <span class="text-xs text-secondary-light">Ngày hẹn:</span>
                                        <div class="text-sm fw-medium">30/12/2024</div>
                                    </div>
                                    <div class="col-md-3">
                                        <span class="text-xs text-secondary-light">Thời gian:</span>
                                        <div class="text-sm fw-medium">09:00 - 10:15</div>
                                    </div>
                                    <div class="col-md-3">
                                        <span class="text-xs text-secondary-light">Loại dịch vụ:</span>
                                        <div class="text-sm fw-medium">Hot Stone (75 phút)</div>
                                    </div>
                                    <div class="col-md-3">
                                        <span class="text-xs text-secondary-light">Phòng mong muốn:</span>
                                        <div class="text-sm fw-medium">VIP 2</div>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <span class="text-xs text-secondary-light">Ghi chú đặc biệt:</span>
                                    <div class="text-sm">Khách hàng thường xuyên. Nhiệt độ đá vừa phải, không quá nóng.</div>
                                </div>

                                <div class="d-flex justify-content-end gap-2">
                                    <button class="btn btn-outline-info btn-sm">
                                        <iconify-icon icon="material-symbols:info" class="icon"></iconify-icon>
                                        Chi Tiết
                                    </button>
                                    <button class="btn btn-outline-danger btn-sm">
                                        <iconify-icon icon="material-symbols:close" class="icon"></iconify-icon>
                                        Từ Chối
                                    </button>
                                    <button class="btn btn-success btn-sm">
                                        <iconify-icon icon="material-symbols:check" class="icon"></iconify-icon>
                                        Chấp Nhận
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Pagination -->
                <div class="d-flex justify-content-between align-items-center mt-4">
                    <span class="text-sm text-secondary-light">Hiển thị 3 trong tổng số 5 yêu cầu</span>
                    <nav aria-label="Page navigation">
                        <ul class="pagination pagination-sm mb-0">
                            <li class="page-item disabled">
                                <span class="page-link">Trước</span>
                            </li>
                            <li class="page-item active">
                                <span class="page-link">1</span>
                            </li>
                            <li class="page-item">
                                <a class="page-link" href="#">2</a>
                            </li>
                            <li class="page-item">
                                <a class="page-link" href="#">Sau</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html> 