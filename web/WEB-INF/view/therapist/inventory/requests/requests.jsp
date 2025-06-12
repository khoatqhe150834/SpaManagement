<%-- 
    Document   : requests.jsp
    Created on : Therapist Inventory Requests Page
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
    <title>Yêu Cầu Vật Tư - Therapist Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />

</head>
<body>
    <jsp:include page="/WEB-INF/view/therapist/shared/sidebar.jsp" />

        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Yêu Cầu Vật Tư</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/therapist-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Bảng Điều Khiển
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Yêu Cầu Vật Tư</li>
                </ul>
            </div>

            <div class="row gy-4">
                <!-- Create New Request -->
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h6 class="card-title mb-0">Tạo Yêu Cầu Vật Tư Mới</h6>
                        </div>
                        <div class="card-body">
                            <form>
                                <div class="row gy-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Loại Vật Tư</label>
                                        <select class="form-select">
                                            <option>Chọn loại vật tư...</option>
                                            <option>Tinh dầu và sản phẩm chăm sóc</option>
                                            <option>Khăn và vật dụng massage</option>
                                            <option>Thiết bị và dụng cụ</option>
                                            <option>Vật tư tiêu hao</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Tên Vật Tư</label>
                                        <input type="text" class="form-control" placeholder="Nhập tên vật tư cần yêu cầu">
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">Số Lượng</label>
                                        <input type="number" class="form-control" placeholder="0" min="1">
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">Mức Độ Ưu Tiên</label>
                                        <select class="form-select">
                                            <option>Chọn mức độ...</option>
                                            <option value="low">Thấp</option>
                                            <option value="medium">Trung bình</option>
                                            <option value="high">Cao</option>
                                            <option value="urgent">Khẩn cấp</option>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">Ngày Cần</label>
                                        <input type="date" class="form-control">
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label">Lý Do / Ghi Chú</label>
                                        <textarea class="form-control" rows="3" placeholder="Nhập lý do yêu cầu vật tư này..."></textarea>
                                    </div>
                                    <div class="col-12">
                                        <button type="submit" class="btn btn-primary">
                                            <iconify-icon icon="solar:add-circle-outline" class="icon"></iconify-icon>
                                            Gửi Yêu Cầu
                                        </button>
                                        <button type="reset" class="btn btn-outline-secondary ms-2">
                                            <iconify-icon icon="solar:refresh-outline" class="icon"></iconify-icon>
                                            Làm Mới
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Requests List -->
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h6 class="card-title mb-0">Danh Sách Yêu Cầu</h6>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Ngày Tạo</th>
                                            <th>Vật Tư</th>
                                            <th>Số Lượng</th>
                                            <th>Ưu Tiên</th>
                                            <th>Ngày Cần</th>
                                            <th>Trạng Thái</th>
                                            <th>Thao Tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>15/12/2024</td>
                                            <td>
                                                <div class="d-flex align-items-center gap-8">
                                                    <div class="w-32-px h-32-px bg-primary-focus text-primary-main rounded-circle d-flex justify-content-center align-items-center">
                                                        <iconify-icon icon="solar:oil-outline" class="text-sm"></iconify-icon>
                                                    </div>
                                                    <div>
                                                        <span class="fw-medium">Tinh Dầu Lavender</span><br>
                                                        <small class="text-secondary-light">Aromatherapy</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>5 chai</td>
                                            <td>
                                                <span class="bg-danger-focus text-danger-main px-8 py-4 rounded-pill fw-medium text-sm">
                                                    Khẩn cấp
                                                </span>
                                            </td>
                                            <td>18/12/2024</td>
                                            <td>
                                                <span class="bg-warning-focus text-warning-main px-8 py-4 rounded-pill fw-medium text-sm">
                                                    Chờ duyệt
                                                </span>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-8">
                                                    <button type="button" class="btn btn-outline-info btn-sm">
                                                        <iconify-icon icon="solar:eye-outline"></iconify-icon>
                                                    </button>
                                                    <button type="button" class="btn btn-outline-danger btn-sm">
                                                        <iconify-icon icon="solar:trash-bin-trash-outline"></iconify-icon>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>12/12/2024</td>
                                            <td>
                                                <div class="d-flex align-items-center gap-8">
                                                    <div class="w-32-px h-32-px bg-warning-focus text-warning-main rounded-circle d-flex justify-content-center align-items-center">
                                                        <iconify-icon icon="solar:layers-outline" class="text-sm"></iconify-icon>
                                                    </div>
                                                    <div>
                                                        <span class="fw-medium">Khăn Massage</span><br>
                                                        <small class="text-secondary-light">Vật tư tiêu hao</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>20 chiếc</td>
                                            <td>
                                                <span class="bg-warning-focus text-warning-main px-8 py-4 rounded-pill fw-medium text-sm">
                                                    Cao
                                                </span>
                                            </td>
                                            <td>20/12/2024</td>
                                            <td>
                                                <span class="bg-success-focus text-success-main px-8 py-4 rounded-pill fw-medium text-sm">
                                                    Đã duyệt
                                                </span>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-8">
                                                    <button type="button" class="btn btn-outline-info btn-sm">
                                                        <iconify-icon icon="solar:eye-outline"></iconify-icon>
                                                    </button>
                                                    <span class="text-success-main text-sm fw-medium">Đã xử lý</span>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>10/12/2024</td>
                                            <td>
                                                <div class="d-flex align-items-center gap-8">
                                                    <div class="w-32-px h-32-px bg-info-focus text-info-main rounded-circle d-flex justify-content-center align-items-center">
                                                        <iconify-icon icon="solar:mask-outline" class="text-sm"></iconify-icon>
                                                    </div>
                                                    <div>
                                                        <span class="fw-medium">Mặt Nạ Collagen</span><br>
                                                        <small class="text-secondary-light">Chăm sóc da mặt</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>10 miếng</td>
                                            <td>
                                                <span class="bg-info-focus text-info-main px-8 py-4 rounded-pill fw-medium text-sm">
                                                    Trung bình
                                                </span>
                                            </td>
                                            <td>25/12/2024</td>
                                            <td>
                                                <span class="bg-danger-focus text-danger-main px-8 py-4 rounded-pill fw-medium text-sm">
                                                    Từ chối
                                                </span>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-8">
                                                    <button type="button" class="btn btn-outline-info btn-sm">
                                                        <iconify-icon icon="solar:eye-outline"></iconify-icon>
                                                    </button>
                                                    <button type="button" class="btn btn-outline-primary btn-sm">
                                                        <iconify-icon icon="solar:refresh-outline"></iconify-icon>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Empty State -->
                            <div class="text-center py-5" style="display: none;">
                                <iconify-icon icon="solar:document-add-outline" class="text-secondary-light mb-16" style="font-size: 64px;"></iconify-icon>
                                <h6 class="mb-8">Chưa có yêu cầu nào</h6>
                                <p class="text-secondary-light mb-0">Các yêu cầu vật tư sẽ xuất hiện ở đây</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html> 


