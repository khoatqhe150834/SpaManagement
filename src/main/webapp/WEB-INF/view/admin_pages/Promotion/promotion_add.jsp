<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm khuyến mãi mới</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              primary: "#D4AF37",
              "primary-dark": "#B8941F",
              secondary: "#FADADD",
              "spa-cream": "#FFF8F0",
              "spa-dark": "#333333",
            },
            fontFamily: {
              serif: ["Playfair Display", "serif"],
              sans: ["Roboto", "sans-serif"],
            },
          },
        },
      };
    </script>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
</head>
<body class="bg-spa-cream font-sans min-h-screen">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    <div class="flex">
     <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        <main class="flex-1 py-12 lg:py-20 ml-64">
            <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex flex-wrap items-center gap-2 mb-8 text-gray-500 text-sm">
                    <a href="${pageContext.request.contextPath}/promotion/list" class="flex items-center gap-1 hover:text-primary">
                        <i data-lucide="home" class="w-4 h-4"></i>
                        Danh sách khuyến mãi
                    </a>
                    <span>-</span>
                    <span class="text-primary font-semibold">Thêm khuyến mãi mới</span>
                </div>

                <!-- Success/Error Messages -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="mb-6 p-4 bg-green-50 border border-green-200 rounded-lg">
                        <div class="flex items-center">
                            <i data-lucide="check-circle" class="w-5 h-5 text-green-600 mr-2"></i>
                            <span class="text-green-700">${sessionScope.successMessage}</span>
                        </div>
                    </div>
                    <c:remove var="successMessage" scope="session"/>
                </c:if>

                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg">
                        <div class="flex items-center">
                            <i data-lucide="alert-circle" class="w-5 h-5 text-red-600 mr-2"></i>
                            <span class="text-red-700">${sessionScope.errorMessage}</span>
                        </div>
                    </div>
                    <c:remove var="errorMessage" scope="session"/>
                </c:if>

                <div class="bg-white rounded-2xl shadow-lg p-8">
                    <form action="${pageContext.request.contextPath}/promotion" method="post" enctype="multipart/form-data" id="promotionForm">
                        <input type="hidden" name="action" value="create" />
                        
                        <!-- Thông tin cơ bản -->
                        <div class="mb-8">
                            <h2 class="text-lg font-semibold text-primary mb-4 flex items-center gap-2">
                                <i data-lucide="gift" class="w-5 h-5"></i> Thông tin khuyến mãi
                            </h2>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                    <label for="title" class="block font-medium text-gray-700 mb-1">Tiêu đề <span class="text-red-600">*</span></label>
                                    <input type="text" name="title" id="title" maxlength="100" required 
                                           placeholder="Nhập tiêu đề khuyến mãi" 
                                           value="${not empty promotionInput.title ? promotionInput.title : ''}"
                                           class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary ${not empty errors.title ? 'border-red-500' : ''}" />
                                    <c:if test="${not empty errors.title}">
                                        <p class="text-red-500 text-sm mt-1">${errors.title}</p>
                                    </c:if>
                                </div>
                                
                                <div>
                                    <label for="promotionCode" class="block font-medium text-gray-700 mb-1">Mã khuyến mãi <span class="text-red-600">*</span></label>
                                    <input type="text" name="promotionCode" id="promotionCode" maxlength="10" required 
                                           placeholder="VD: SUMMER2024" 
                                           value="${not empty promotionInput.promotionCode ? promotionInput.promotionCode : ''}"
                                           class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary ${not empty errors.promotionCode ? 'border-red-500' : ''}" />
                                    <p class="text-gray-500 text-xs mt-1">3-10 ký tự, chỉ chữ hoa và số</p>
                                    <c:if test="${not empty errors.promotionCode}">
                                        <p class="text-red-500 text-sm mt-1">${errors.promotionCode}</p>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- Thông tin giảm giá -->
                        <div class="mb-8">
                            <h2 class="text-lg font-semibold text-primary mb-4 flex items-center gap-2">
                                <i data-lucide="percent" class="w-5 h-5"></i> Thông tin giảm giá
                            </h2>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                    <label for="discountType" class="block font-medium text-gray-700 mb-1">Hình thức giảm <span class="text-red-600">*</span></label>
                                    <select name="discountType" id="discountType" required class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary ${not empty errors.discountType ? 'border-red-500' : ''}">
                                        <option value="">-- Chọn hình thức --</option>
                                        <option value="PERCENTAGE" ${promotionInput.discountType == 'PERCENTAGE' ? 'selected' : ''}>Phần trăm (%)</option>
                                        <option value="FIXED" ${promotionInput.discountType == 'FIXED' ? 'selected' : ''}>Số tiền cố định (VND)</option>
                                    </select>
                                    <c:if test="${not empty errors.discountType}">
                                        <p class="text-red-500 text-sm mt-1">${errors.discountType}</p>
                                    </c:if>
                                </div>
                                
                                <div>
                                    <label for="discountValue" class="block font-medium text-gray-700 mb-1">Giá trị giảm <span class="text-red-600">*</span></label>
                                    <input type="number" name="discountValue" id="discountValue" required min="1" step="0.01"
                                           placeholder="Nhập giá trị giảm"
                                           value="${not empty promotionInput.discountValue ? promotionInput.discountValue : ''}"
                                           class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary ${not empty errors.discountValue ? 'border-red-500' : ''}" />
                                    <c:if test="${not empty errors.discountValue}">
                                        <p class="text-red-500 text-sm mt-1">${errors.discountValue}</p>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- Thời gian áp dụng -->
                        <div class="mb-8">
                            <h2 class="text-lg font-semibold text-primary mb-4 flex items-center gap-2">
                                <i data-lucide="calendar" class="w-5 h-5"></i> Thời gian áp dụng
                            </h2>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                    <label for="startDate" class="block font-medium text-gray-700 mb-1">Ngày bắt đầu <span class="text-red-600">*</span></label>
                                    <input type="datetime-local" name="startDate" id="startDate" required 
                                           class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary ${not empty errors.startDate ? 'border-red-500' : ''}" />
                                    <c:if test="${not empty errors.startDate}">
                                        <p class="text-red-500 text-sm mt-1">${errors.startDate}</p>
                                    </c:if>
                                </div>
                                
                                <div>
                                    <label for="endDate" class="block font-medium text-gray-700 mb-1">Ngày kết thúc <span class="text-red-600">*</span></label>
                                    <input type="datetime-local" name="endDate" id="endDate" required 
                                           class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary ${not empty errors.endDate ? 'border-red-500' : ''}" />
                                    <c:if test="${not empty errors.endDate}">
                                        <p class="text-red-500 text-sm mt-1">${errors.endDate}</p>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- Cài đặt khác -->
                        <div class="mb-8">
                            <h2 class="text-lg font-semibold text-primary mb-4 flex items-center gap-2">
                                <i data-lucide="settings" class="w-5 h-5"></i> Cài đặt
                            </h2>
                            
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-4">
                                <div>
                                    <label for="status" class="block font-medium text-gray-700 mb-1">Trạng thái (tự động)</label>
                                    <input type="text" id="statusDisplay" readonly 
                                           class="w-full border rounded-lg px-3 py-2 bg-gray-100 text-gray-600"
                                           value="Vui lòng chọn ngày để xác định trạng thái">
                                    <input type="hidden" name="status" id="status" value="SCHEDULED">
                                    <p class="text-gray-500 text-xs mt-1">Trạng thái sẽ được tự động xác định dựa trên ngày bắt đầu và kết thúc</p>
                                </div>

                                <div>
                                    <label for="customerCondition" class="block font-medium text-gray-700 mb-1">Điều kiện khách hàng <span class="text-red-600">*</span></label>
                                    <select name="customerCondition" id="customerCondition" required class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary ${not empty errors.customerCondition ? 'border-red-500' : ''}">
                                        <option value="">-- Chọn điều kiện --</option>
                                        <option value="ALL" ${promotionInput.customerCondition == 'ALL' ? 'selected' : ''}>Tất cả khách hàng</option>
                                        <option value="INDIVIDUAL" ${promotionInput.customerCondition == 'INDIVIDUAL' ? 'selected' : ''}>Khách hàng cá nhân</option>
                                        <option value="COUPLE" ${promotionInput.customerCondition == 'COUPLE' ? 'selected' : ''}>Khách hàng đi cặp</option>
                                        <option value="GROUP" ${promotionInput.customerCondition == 'GROUP' ? 'selected' : ''}>Khách hàng đi nhóm (3+)</option>
                                    </select>
                                    <p class="text-gray-500 text-xs mt-1">Điều kiện áp dụng khuyến mãi cho từng loại khách hàng</p>
                                    <c:if test="${not empty errors.customerCondition}">
                                        <p class="text-red-500 text-sm mt-1">${errors.customerCondition}</p>
                                    </c:if>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label for="imageUrl" class="block font-medium text-gray-700 mb-1">Ảnh khuyến mãi</label>
                                <input type="file" name="imageUrl" id="imageUrl" accept="image/*" 
                                       class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary" />
                                <p class="text-gray-500 text-sm mt-1">Chọn ảnh cho khuyến mãi (không bắt buộc, tối đa 10MB)</p>
                                <c:if test="${not empty errors.imageUrl}">
                                    <p class="text-red-500 text-sm mt-1">${errors.imageUrl}</p>
                                </c:if>
                            </div>

                            <div>
                                <label for="description" class="block font-medium text-gray-700 mb-1">Mô tả <span class="text-red-600">*</span></label>
                                <textarea name="description" id="description" rows="4" required 
                                          placeholder="Nhập mô tả chi tiết về khuyến mãi..."
                                          class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary ${not empty errors.description ? 'border-red-500' : ''}">${not empty promotionInput.description ? promotionInput.description : ''}</textarea>
                                <c:if test="${not empty errors.description}">
                                    <p class="text-red-500 text-sm mt-1">${errors.description}</p>
                                </c:if>
                            </div>
                        </div>

                        <div class="flex justify-end gap-3 mt-8">
                            <a href="${pageContext.request.contextPath}/promotion/list" 
                               class="inline-flex items-center gap-2 px-6 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition">
                                <i data-lucide="arrow-left" class="w-5 h-5"></i> Hủy
                            </a>
                            <button type="submit" 
                                    class="inline-flex items-center gap-2 px-6 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition">
                                <i data-lucide="save" class="w-5 h-5"></i> Lưu khuyến mãi
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
    
    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
    
    <script>
        if (window.lucide) lucide.createIcons();

        // Auto update status based on dates
        function updateStatus() {
            const startDateInput = document.getElementById('startDate');
            const endDateInput = document.getElementById('endDate');
            const statusDisplay = document.getElementById('statusDisplay');
            const statusHidden = document.getElementById('status');

            if (!startDateInput.value || !endDateInput.value) {
                statusDisplay.value = 'Vui lòng chọn ngày để xác định trạng thái';
                statusHidden.value = 'SCHEDULED';
                return;
            }

            const now = new Date();
            const startDate = new Date(startDateInput.value);
            const endDate = new Date(endDateInput.value);

            let status, statusText, statusClass;

            if (startDate > now) {
                status = 'SCHEDULED';
                statusText = 'Lên lịch (sẽ bắt đầu vào ' + startDate.toLocaleDateString('vi-VN') + ')';
                statusClass = 'bg-blue-100 text-blue-800';
            } else if (startDate <= now && endDate >= now) {
                status = 'ACTIVE';
                statusText = 'Đang hoạt động (kết thúc vào ' + endDate.toLocaleDateString('vi-VN') + ')';
                statusClass = 'bg-green-100 text-green-800';
            } else {
                status = 'INACTIVE';
                statusText = 'Không hoạt động (đã kết thúc vào ' + endDate.toLocaleDateString('vi-VN') + ')';
                statusClass = 'bg-gray-100 text-gray-800';
            }

            statusDisplay.value = statusText;
            statusDisplay.className = 'w-full border rounded-lg px-3 py-2 ' + statusClass;
            statusHidden.value = status;
        }

        // Add event listeners for date changes
        document.getElementById('startDate').addEventListener('change', updateStatus);
        document.getElementById('endDate').addEventListener('change', updateStatus);

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
                        container.innerHTML = '<img src="' + e.target.result + '" alt="Preview" class="w-32 h-32 object-cover rounded-lg border">';
                        document.getElementById('imageUrl').parentNode.appendChild(container);
                    } else {
                        previewContainer.innerHTML = '<img src="' + e.target.result + '" alt="Preview" class="w-32 h-32 object-cover rounded-lg border">';
                    }
                };
                reader.readAsDataURL(file);
            } else {
                if (previewContainer) {
                    previewContainer.remove();
                }
            }
        });

        // Validation
        document.getElementById('promotionForm').addEventListener('submit', function(e) {
            const startDate = new Date(document.getElementById('startDate').value);
            const endDate = new Date(document.getElementById('endDate').value);
            
            if (endDate <= startDate) {
                e.preventDefault();
                alert('Ngày kết thúc phải sau ngày bắt đầu!');
                return false;
            }
        });

        // Auto uppercase promotion code
        document.getElementById('promotionCode').addEventListener('input', function(e) {
            this.value = this.value.toUpperCase();
        });

        // Initialize status on page load
        updateStatus();
    </script>
</body>
</html>

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
