<%-- 
    Document   : notes.jsp
    Created on : Therapist Client Notes Page
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
    <title>Ghi Chú Khách Hàng - Therapist Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />

</head>
<body>
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Ghi Chú Khách Hàng</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/therapist-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Bảng Điều Khiển
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Ghi Chú Khách Hàng</li>
                </ul>
            </div>

            <div class="row gy-4">
                <!-- Create New Client Note -->
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h6 class="card-title mb-0">Tạo Ghi Chú Khách Hàng</h6>
                        </div>
                        <div class="card-body">
                            <form>
                                <div class="row gy-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Khách Hàng</label>
                                        <select class="form-select">
                                            <option>Chọn khách hàng...</option>
                                            <option>Nguyễn Thị Lan</option>
                                            <option>Trần Văn Nam</option>
                                            <option>Lê Thị Hoa</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Loại Ghi Chú</label>
                                        <select class="form-select">
                                            <option>Chọn loại ghi chú...</option>
                                            <option>Sở thích cá nhân</option>
                                            <option>Dị ứng / Lưu ý sức khỏe</option>
                                            <option>Phản hồi</option>
                                            <option>Khác</option>
                                        </select>
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label">Nội Dung Ghi Chú</label>
                                        <textarea class="form-control" rows="4" placeholder="Nhập ghi chú về khách hàng..."></textarea>
                                    </div>
                                    <div class="col-12">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="importantNote">
                                            <label class="form-check-label" for="importantNote">
                                                Đánh dấu là ghi chú quan trọng
                                            </label>
                                        </div>
                                    </div>
                                    <div class="col-12">
                                        <button type="submit" class="btn btn-primary">
                                            <iconify-icon icon="solar:add-circle-outline" class="icon"></iconify-icon>
                                            Lưu Ghi Chú
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Client Notes List -->
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h6 class="card-title mb-0">Danh Sách Ghi Chú Khách Hàng</h6>
                        </div>
                        <div class="card-body">
                            <div class="row gy-4">
                                <!-- Sample Client Note -->
                                <div class="col-lg-6">
                                    <div class="card border">
                                        <div class="card-body">
                                            <div class="d-flex align-items-start justify-content-between mb-12">
                                                <div class="d-flex align-items-center gap-8">
                                                    <img src="${pageContext.request.contextPath}/assets/admin/images/avatar/avatar-1.png" alt="Avatar" class="w-40-px h-40-px rounded-circle flex-shrink-0">
                                                    <div>
                                                        <h6 class="card-title mb-0">Nguyễn Thị Lan</h6>
                                                        <span class="text-secondary-light text-sm">0987654321</span>
                                                    </div>
                                                </div>
                                                <div class="d-flex align-items-center gap-8">
                                                    <span class="bg-danger-focus text-danger-main px-8 py-4 rounded-pill fw-medium text-xs">
                                                        <iconify-icon icon="solar:danger-circle-outline" class="icon text-sm"></iconify-icon>
                                                        Quan trọng
                                                    </span>
                                                    <span class="text-secondary-light text-sm">15/12/2024</span>
                                                </div>
                                            </div>
                                            <div class="mb-12">
                                                <span class="bg-warning-focus text-warning-main px-12 py-4 rounded-pill fw-medium text-sm">
                                                    Dị ứng / Lưu ý sức khỏe
                                                </span>
                                            </div>
                                            <p class="text-secondary-light mb-16">
                                                Khách hàng bị dị ứng với tinh dầu lavender. 
                                                Tránh sử dụng các sản phẩm có chứa lavender trong liệu trình.
                                            </p>
                                            <div class="d-flex align-items-center gap-8">
                                                <button type="button" class="btn btn-outline-primary btn-sm">
                                                    <iconify-icon icon="solar:pen-outline"></iconify-icon>
                                                    Chỉnh Sửa
                                                </button>
                                                <button type="button" class="btn btn-outline-danger btn-sm">
                                                    <iconify-icon icon="solar:trash-bin-trash-outline"></iconify-icon>
                                                    Xóa
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Another Sample Note -->
                                <div class="col-lg-6">
                                    <div class="card border">
                                        <div class="card-body">
                                            <div class="d-flex align-items-start justify-content-between mb-12">
                                                <div class="d-flex align-items-center gap-8">
                                                    <img src="${pageContext.request.contextPath}/assets/admin/images/avatar/avatar-2.png" alt="Avatar" class="w-40-px h-40-px rounded-circle flex-shrink-0">
                                                    <div>
                                                        <h6 class="card-title mb-0">Trần Văn Nam</h6>
                                                        <span class="text-secondary-light text-sm">0123456789</span>
                                                    </div>
                                                </div>
                                                <span class="text-secondary-light text-sm">14/12/2024</span>
                                            </div>
                                            <div class="mb-12">
                                                <span class="bg-info-focus text-info-main px-12 py-4 rounded-pill fw-medium text-sm">
                                                    Sở thích cá nhân
                                                </span>
                                            </div>
                                            <p class="text-secondary-light mb-16">
                                                Khách hàng thích massage với áp lực nhẹ và ưa thích mùi hương bạc hà.
                                                Thường đặt lịch vào buổi tối.
                                            </p>
                                            <div class="d-flex align-items-center gap-8">
                                                <button type="button" class="btn btn-outline-primary btn-sm">
                                                    <iconify-icon icon="solar:pen-outline"></iconify-icon>
                                                    Chỉnh Sửa
                                                </button>
                                                <button type="button" class="btn btn-outline-danger btn-sm">
                                                    <iconify-icon icon="solar:trash-bin-trash-outline"></iconify-icon>
                                                    Xóa
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Empty State -->
                                <div class="col-12">
                                    <div class="text-center py-5">
                                        <iconify-icon icon="solar:notes-outline" class="text-secondary-light mb-16" style="font-size: 64px;"></iconify-icon>
                                        <h6 class="mb-8">Chưa có ghi chú khách hàng nào</h6>
                                        <p class="text-secondary-light mb-0">Các ghi chú về khách hàng sẽ xuất hiện ở đây</p>
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


