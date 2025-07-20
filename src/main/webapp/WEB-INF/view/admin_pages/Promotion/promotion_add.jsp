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
                    <!-- Thông báo lỗi tổng quát -->
                    <c:if test="${not empty errors.general}">
                        <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg">
                            <div class="flex items-center gap-2">
                                <i data-lucide="alert-circle" class="w-5 h-5 text-red-500"></i>
                                <p class="text-red-700 font-medium">${errors.general}</p>
                            </div>
                        </div>
                    </c:if>
                    
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
                                    <p class="text-gray-500 text-xs mt-1">Tối thiểu 3 ký tự, tối đa 100 ký tự. Không được trùng với tên khuyến mãi khác</p>
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
                                    <p class="text-gray-500 text-xs mt-1">3-10 ký tự, chỉ chữ hoa và số. Hệ thống sẽ tự động chuyển thành chữ hoa</p>
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
                                        <option value="FIXED_AMOUNT" ${promotionInput.discountType == 'FIXED_AMOUNT' ? 'selected' : ''}>Số tiền cố định (VND)</option>
                                        <option value="FREE_SERVICE" ${promotionInput.discountType == 'FREE_SERVICE' ? 'selected' : ''}>Miễn phí dịch vụ</option>
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
                                    <input type="date" name="startDate" id="startDate" required 
                                           class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary ${not empty errors.startDate ? 'border-red-500' : ''}" />
                                    <c:if test="${not empty errors.startDate}">
                                        <p class="text-red-500 text-sm mt-1">${errors.startDate}</p>
                                    </c:if>
                                </div>
                                
                                <div>
                                    <label for="endDate" class="block font-medium text-gray-700 mb-1">Ngày kết thúc <span class="text-red-600">*</span></label>
                                    <input type="date" name="endDate" id="endDate" required 
                                           class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary ${not empty errors.endDate ? 'border-red-500' : ''}" />
                                    <c:if test="${not empty errors.endDate}">
                                        <p class="text-red-500 text-sm mt-1">${errors.endDate}</p>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- Cài đặt -->
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
                                <div class="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-lg hover:border-primary transition-colors">
                                    <div class="space-y-1 text-center">
                                        <i data-lucide="upload" class="mx-auto h-12 w-12 text-gray-400"></i>
                                        <div class="flex text-sm text-gray-600">
                                            <label for="imageUrl" class="relative cursor-pointer bg-white rounded-md font-medium text-primary hover:text-primary-dark focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-primary">
                                                <span>Tải ảnh lên</span>
                                                <input id="imageUrl" name="imageUrl" type="file" class="sr-only" accept="image/*" onchange="previewImage(this)">
                                            </label>
                                            <p class="pl-1">hoặc kéo thả vào đây</p>
                                        </div>
                                        <p class="text-xs text-gray-500">PNG, JPG, GIF, WEBP tối đa 10MB</p>
                                    </div>
                                </div>
                                <div id="imagePreview" class="mt-2 hidden">
                                    <img src="" alt="Preview" class="w-32 h-32 object-cover rounded-lg border">
                                </div>
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

        // Auto convert promotion code to uppercase and validate
        document.getElementById('promotionCode').addEventListener('input', function(e) {
            this.value = this.value.toUpperCase();
            validatePromotionCode(this.value);
        });

        // Validate promotion code
        function validatePromotionCode(code) {
            const promotionCodeInput = document.getElementById('promotionCode');
            const errorElement = promotionCodeInput.parentNode.querySelector('.promotion-code-error');
            
            // Remove existing error message
            if (errorElement) {
                errorElement.remove();
            }
            
            // Check for Vietnamese characters
            const vietnameseRegex = /[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]/i;
            if (vietnameseRegex.test(code)) {
                showPromotionCodeError('Mã khuyến mãi không được chứa ký tự tiếng Việt!');
                return false;
            }
            
            // Check format (only uppercase letters and numbers)
            const formatRegex = /^[A-Z0-9]*$/;
            if (code && !formatRegex.test(code)) {
                showPromotionCodeError('Mã khuyến mãi chỉ được chứa chữ hoa và số!');
                return false;
            }
            
            // Check length
            if (code.length > 0 && (code.length < 3 || code.length > 10)) {
                showPromotionCodeError('Mã khuyến mãi phải từ 3-10 ký tự!');
                return false;
            }
            
            return true;
        }

        // Show promotion code error
        function showPromotionCodeError(message) {
            const promotionCodeInput = document.getElementById('promotionCode');
            const errorDiv = document.createElement('p');
            errorDiv.className = 'text-red-500 text-sm mt-1 promotion-code-error';
            errorDiv.textContent = message;
            
            // Remove existing error
            const existingError = promotionCodeInput.parentNode.querySelector('.promotion-code-error');
            if (existingError) {
                existingError.remove();
            }
            
            promotionCodeInput.parentNode.appendChild(errorDiv);
            promotionCodeInput.classList.add('border-red-500');
        }

        // Validate dates
        function validateDates() {
            const startDateInput = document.getElementById('startDate');
            const endDateInput = document.getElementById('endDate');
            const startDate = new Date(startDateInput.value);
            const endDate = new Date(endDateInput.value);
            
            // Remove existing error messages
            removeDateError('startDate');
            removeDateError('endDate');
            
            if (startDateInput.value && endDateInput.value) {
                if (endDate <= startDate) {
                    showDateError('endDate', 'Ngày kết thúc phải sau ngày bắt đầu!');
                    return false;
                }
            }
            
            return true;
        }

        // Show date error
        function showDateError(fieldId, message) {
            const field = document.getElementById(fieldId);
            const errorDiv = document.createElement('p');
            errorDiv.className = 'text-red-500 text-sm mt-1 date-error';
            errorDiv.textContent = message;
            
            field.parentNode.appendChild(errorDiv);
            field.classList.add('border-red-500');
        }

        // Remove date error
        function removeDateError(fieldId) {
            const field = document.getElementById(fieldId);
            const errorElement = field.parentNode.querySelector('.date-error');
            if (errorElement) {
                errorElement.remove();
            }
            field.classList.remove('border-red-500');
        }

        // Add date validation listeners
        document.getElementById('startDate').addEventListener('change', function() {
            validateDates();
            updateStatus();
        });
        
        document.getElementById('endDate').addEventListener('change', function() {
            validateDates();
            updateStatus();
        });

        // Xem trước ảnh
        function previewImage(input) {
            const file = input.files[0];
            const previewContainer = document.getElementById('imagePreview');
            
            if (file) {
                // Kiểm tra định dạng ảnh
                if (!file.type.startsWith('image/')) {
                    alert('Vui lòng chọn đúng file ảnh!');
                    input.value = '';
                    previewContainer.classList.add('hidden');
                    return;
                }
                
                // Kiểm tra dung lượng (tối đa 10MB)
                if (file.size > 10 * 1024 * 1024) {
                    alert('Dung lượng ảnh phải nhỏ hơn 10MB!');
                    input.value = '';
                    previewContainer.classList.add('hidden');
                    return;
                }
                
                const reader = new FileReader();
                reader.onload = function(e) {
                    previewContainer.src = e.target.result;
                    previewContainer.classList.remove('hidden');
                };
                reader.readAsDataURL(file);
            } else {
                previewContainer.classList.add('hidden');
            }
        }

        // Form validation
        document.getElementById('promotionForm').addEventListener('submit', function(e) {
            let isValid = true;
            
            // Validate promotion code
            const promotionCode = document.getElementById('promotionCode').value;
            if (!validatePromotionCode(promotionCode)) {
                isValid = false;
            }
            
            // Validate dates
            if (!validateDates()) {
                isValid = false;
            }
            
            // Check if promotion code is empty
            if (!promotionCode.trim()) {
                showPromotionCodeError('Mã khuyến mãi không được để trống!');
                isValid = false;
            }
            
            // Check if dates are empty
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            
            if (!startDate) {
                showDateError('startDate', 'Vui lòng chọn ngày bắt đầu!');
                isValid = false;
            }
            
            if (!endDate) {
                showDateError('endDate', 'Vui lòng chọn ngày kết thúc!');
                isValid = false;
            }
            
            if (!isValid) {
                e.preventDefault();
                return false;
            }
        });

        // Initialize status on page load
        updateStatus();
    </script>
</body>
</html>


