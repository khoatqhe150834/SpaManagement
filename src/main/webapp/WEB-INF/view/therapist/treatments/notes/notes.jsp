<%-- 
    Document   : notes.jsp
    Created on : Therapist Treatment Notes Page
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
    <title>Ghi Chú Liệu Pháp - Therapist Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />

</head>
<body>
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Ghi Chú Liệu Pháp</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/therapist-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Bảng Điều Khiển
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Ghi Chú Liệu Pháp</li>
                </ul>
            </div>

            <div class="row gy-4">
                <!-- Create New Note Card -->
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h6 class="card-title mb-0">Tạo Ghi Chú Mới</h6>
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
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Dịch Vụ</label>
                                        <select class="form-select">
                                            <option>Chọn dịch vụ...</option>
                                            <option>Massage Thư Giãn</option>
                                            <option>Chăm Sóc Da Mặt</option>
                                        </select>
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label">Ghi Chú</label>
                                        <textarea class="form-control" rows="4" placeholder="Nhập ghi chú về liệu pháp..."></textarea>
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

                <!-- Notes List -->
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h6 class="card-title mb-0">Danh Sách Ghi Chú</h6>
                        </div>
                        <div class="card-body">
                            <div class="row gy-4">
                                <!-- Sample Note -->
                                <div class="col-lg-6">
                                    <div class="card border">
                                        <div class="card-body">
                                            <div class="d-flex align-items-center justify-content-between mb-12">
                                                <h6 class="card-title mb-0">Nguyễn Thị Lan</h6>
                                                <span class="text-secondary-light text-sm">15/12/2024</span>
                                            </div>
                                            <div class="mb-12">
                                                <span class="bg-primary-focus text-primary-main px-12 py-4 rounded-pill fw-medium text-sm">
                                                    Massage Thư Giãn
                                                </span>
                                            </div>
                                            <p class="text-secondary-light mb-16">
                                                Khách hàng có phản ứng tốt với liệu pháp massage. 
                                                Lưu ý tránh vùng vai trái do có chấn thương cũ.
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
                                        <iconify-icon icon="solar:document-text-outline" class="text-secondary-light mb-16" style="font-size: 64px;"></iconify-icon>
                                        <h6 class="mb-8">Chưa có ghi chú nào</h6>
                                        <p class="text-secondary-light mb-0">Các ghi chú liệu pháp sẽ xuất hiện ở đây</p>
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


