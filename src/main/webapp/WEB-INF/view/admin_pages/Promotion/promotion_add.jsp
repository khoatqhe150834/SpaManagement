<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi" data-theme="light">
<head>
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm khuyến mãi mới - Quản trị</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp"></jsp:include>
    <style>
        .form-label { font-weight: 500; }
        .error-text { width: 100%; margin-top: .25rem; font-size: 80%; color: #dc3545; }
        .is-invalid { border-color: #dc3545 !important; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />
    
    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h4 class="fw-bold mb-0">Thêm khuyến mãi mới</h4>
            <a href="${pageContext.request.contextPath}/promotion/list" class="btn btn-outline-primary">
                <iconify-icon icon="solar:arrow-left-linear" class="icon text-lg me-8"></iconify-icon>
                Quay lại danh sách
            </a>
        </div>
        
        <div class="card h-100 p-0 radius-12">
            <div class="card-header border-bottom bg-base py-16 px-24">
                <h5 class="card-title mb-0">Thông tin khuyến mãi</h5>
            </div>
            
            <div class="card-body p-24">
    <c:if test="${not empty error}">
                    <div class="alert alert-danger mb-24">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        ${error}
                    </div>
    </c:if>
                
    <form action="${pageContext.request.contextPath}/promotion" method="post" enctype="multipart/form-data" novalidate>
        <input type="hidden" name="action" value="create" />
                    
                    <div class="row">
                        <div class="col-md-6 mb-4">
            <label for="title" class="form-label">Tiêu đề <span class="text-danger">*</span></label>
            <input type="text" class="form-control ${not empty errors.title ? 'is-invalid' : ''}" 
                   id="title" name="title" required maxlength="100" 
                   value="${not empty promotionInput.title ? promotionInput.title : ''}" placeholder="Nhập tiêu đề">
            <div class="error-text"></div>
        </div>
                        
                        <div class="col-md-6 mb-4">
            <label for="promotionCode" class="form-label">Mã khuyến mãi <span class="text-danger">*</span></label>
            <input type="text" class="form-control ${not empty errors.promotionCode ? 'is-invalid' : ''}" 
                   id="promotionCode" name="promotionCode" required maxlength="10" 
                   value="${not empty promotionInput.promotionCode ? promotionInput.promotionCode : ''}" placeholder="Nhập mã khuyến mãi">
            <div class="error-text"></div>
        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <label class="form-label" for="discountType">Hình thức giảm <span class="text-danger">*</span></label>
                            <select class="form-select ${not empty errors.discountType ? 'is-invalid' : ''}" id="discountType" name="discountType" required>
                                <option value="">-- Chọn --</option>
                                <option value="PERCENTAGE" ${promotionInput.discountType == 'PERCENTAGE' ? 'selected' : ''}>Phần trăm (%)</option>
                                <option value="FIXED" ${promotionInput.discountType == 'FIXED' ? 'selected' : ''}>Số tiền cố định (VND)</option>
                            </select>
                            <div class="error-text"></div>
                        </div>
                        
                        <div class="col-md-6 mb-4">
                            <label for="discountValue" class="form-label">Giá trị giảm <span class="text-danger">*</span></label>
                            <input type="number" class="form-control ${not empty errors.discountValue ? 'is-invalid' : ''}" 
                                   id="discountValue" name="discountValue" required min="1" step="0.01"
                                   value="${not empty promotionInput.discountValue ? promotionInput.discountValue : ''}" placeholder="Nhập giá trị giảm">
                            <div class="error-text"></div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <label class="form-label" for="startDate">Ngày bắt đầu <span class="text-danger">*</span></label>
                            <input type="datetime-local" class="form-control" id="startDate" name="startDate" required>
                            <div class="error-text"></div>
                        </div>
                        
                        <div class="col-md-6 mb-4">
                            <label class="form-label" for="endDate">Ngày kết thúc <span class="text-danger">*</span></label>
                            <input type="datetime-local" class="form-control" id="endDate" name="endDate" required>
                            <div class="error-text"></div>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label class="form-label" for="status">Trạng thái</label>
                        <select class="form-select" id="status" name="status">
                            <option value="SCHEDULED" ${promotionInput.status == 'SCHEDULED' ? 'selected' : ''}>Chưa áp dụng</option>
                            <option value="ACTIVE" ${promotionInput.status == 'ACTIVE' ? 'selected' : ''}>Đang áp dụng</option>
                            <option value="INACTIVE" ${promotionInput.status == 'INACTIVE' ? 'selected' : ''}>Không áp dụng</option>
                        </select>
                    </div>
                    
                    <div class="mb-4">
            <label class="form-label" for="imageUrl">Ảnh khuyến mãi</label>
            <input type="file" class="form-control ${not empty errors.imageUrl ? 'is-invalid' : ''}" 
                   id="imageUrl" name="imageUrl" accept="image/*">
            <small class="form-text text-muted">Chọn ảnh cho khuyến mãi (không bắt buộc)</small>
            <div class="error-text">${errors.imageUrl}</div>
            <c:if test="${not empty promotionInput.imageUrl}">
                <div class="mt-2">
                    <img src="${promotionInput.imageUrl}" alt="Ảnh khuyến mãi hiện tại" 
                         class="img-thumbnail" style="max-width: 200px;">
                </div>
            </c:if>
        </div>
                    
                    <div class="mb-4">
            <label class="form-label" for="description">Mô tả <span class="text-danger">*</span></label>
            <textarea class="form-control" id="description" name="description" rows="3" placeholder="Nhập mô tả"></textarea>
            <div class="error-text"></div>
        </div>
                    
                    <div class="d-flex gap-16 justify-content-end mt-24">
                        <a href="${pageContext.request.contextPath}/promotion/list" class="btn btn-outline-secondary btn-sm px-20 py-11 radius-8">
                            <iconify-icon icon="solar:arrow-left-linear" class="icon text-lg me-8"></iconify-icon>
                            Hủy bỏ
                        </a>
                        <button type="submit" class="btn btn-primary btn-sm px-20 py-11 radius-8">
                            <iconify-icon icon="solar:check-circle-bold" class="icon text-lg me-8"></iconify-icon>
                            Thêm khuyến mãi
                        </button>
        </div>
                </form>
        </div>
        </div>
</div>
    
<jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
<script>
    // Xem trước ảnh
    document.getElementById('imageUrl').addEventListener('change', function(e) {
        const file = e.target.files[0];
        const previewContainer = document.getElementById('imagePreview');
        
        if (file) {
            // Kiểm tra định dạng ảnh
            if (!file.type.startsWith('image/')) {
                alert('Vui lòng chọn đúng file ảnh!');
                this.value = '';
                return;
            }
            
            // Kiểm tra dung lượng (tối đa 10MB)
            if (file.size > 10 * 1024 * 1024) {
                alert('Dung lượng ảnh phải nhỏ hơn 10MB!');
                this.value = '';
                return;
            }
            
            const reader = new FileReader();
            reader.onload = function(e) {
                if (!previewContainer) {
                    const container = document.createElement('div');
                    container.id = 'imagePreview';
                    container.className = 'mt-2';
                    container.innerHTML = '<img src="' + e.target.result + '" alt="Preview" class="img-thumbnail" style="max-width: 200px;">';
                    document.getElementById('imageUrl').parentNode.appendChild(container);
                } else {
                    previewContainer.innerHTML = '<img src="' + e.target.result + '" alt="Preview" class="img-thumbnail" style="max-width: 200px;">';
                }
            };
            reader.readAsDataURL(file);
        } else {
            if (previewContainer) {
                previewContainer.remove();
            }
        }
    });

$(document).ready(function() {
    function showError(input, message) {
        input.addClass('is-invalid');
        input.next('.error-text').text(message);
    }
    function clearError(input) {
        input.removeClass('is-invalid');
        input.next('.error-text').text('');
    }
    // Khi submit: kiểm tra tất cả trường
    $('form').on('submit', function(e) {
        let valid = true;
        // Tiêu đề
        const title = $('#title').val().trim();
        if (!title) {
            showError($('#title'), 'Vui lòng nhập tiêu đề!');
            valid = false;
        } else if (title.length > 100) {
            showError($('#title'), 'Tiêu đề tối đa 100 ký tự!');
            valid = false;
        } else {
            clearError($('#title'));
        }
        // Mã khuyến mãi
        const code = $('#promotionCode').val().trim();
        if (!code) {
            showError($('#promotionCode'), 'Vui lòng nhập mã khuyến mãi!');
            valid = false;
        } else if (code.length > 10) {
            showError($('#promotionCode'), 'Mã tối đa 10 ký tự!');
            valid = false;
        } else {
            clearError($('#promotionCode'));
        }
        // Hình thức giảm
        const discountType = $('#discountType').val();
        if (!discountType) {
            showError($('#discountType'), 'Vui lòng chọn hình thức giảm!');
            valid = false;
        } else {
            clearError($('#discountType'));
        }
        // Giá trị giảm
        const discountValue = $('#discountValue').val();
        if (!discountValue) {
            showError($('#discountValue'), 'Vui lòng nhập giá trị giảm!');
            valid = false;
        } else if (isNaN(discountValue) || Number(discountValue) <= 0) {
            showError($('#discountValue'), 'Giá trị giảm phải là số dương!');
            valid = false;
        } else {
            clearError($('#discountValue'));
        }
        // Ngày bắt đầu
        const startDate = $('#startDate').val();
        if (!startDate) {
            showError($('#startDate'), 'Vui lòng chọn ngày bắt đầu!');
            valid = false;
        } else {
            clearError($('#startDate'));
        }
        // Ngày kết thúc
        const endDate = $('#endDate').val();
        if (!endDate) {
            showError($('#endDate'), 'Vui lòng chọn ngày kết thúc!');
            valid = false;
        } else if (startDate && endDate < startDate) {
            showError($('#endDate'), 'Ngày kết thúc phải sau ngày bắt đầu!');
            valid = false;
        } else {
            clearError($('#endDate'));
        }
        // Mô tả
        const description = $('#description').val().trim();
        if (!description) {
            showError($('#description'), 'Vui lòng nhập mô tả!');
            valid = false;
        } else {
            clearError($('#description'));
        }
        if (!valid) e.preventDefault();
    });
});
</script>
</body>
</html>
