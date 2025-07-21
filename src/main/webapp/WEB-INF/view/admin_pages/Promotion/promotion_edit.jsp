<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:choose><c:when test="${isEdit}">Chỉnh sửa khuyến mãi</c:when><c:otherwise>Thêm khuyến mãi</c:otherwise></c:choose></title>
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
                    <span class="text-primary font-semibold">
                        <c:choose>
                            <c:when test="${isEdit}">Chỉnh sửa khuyến mãi</c:when>
                            <c:otherwise>Thêm khuyến mãi</c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <div class="bg-white rounded-2xl shadow-lg p-8">
                    <c:choose>
                        <c:when test="${empty promotion}">
                            <div class="text-center py-8">
                                <i data-lucide="alert-circle" class="w-16 h-16 text-red-400 mx-auto mb-4"></i>
                                <h3 class="text-lg font-medium text-gray-900 mb-2">Không tìm thấy khuyến mãi</h3>
                                <p class="text-gray-500 mb-4">Khuyến mãi không tồn tại hoặc dữ liệu không hợp lệ.</p>
                                <a href="${pageContext.request.contextPath}/promotion/list" 
                                   class="inline-flex items-center px-4 py-2 bg-gray-500 text-white rounded-lg hover:bg-gray-600 transition-colors">
                                    <i data-lucide="arrow-left" class="w-4 h-4 mr-2"></i>
                                    Quay lại danh sách
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <form action="${pageContext.request.contextPath}/promotion" method="post" enctype="multipart/form-data" id="promotionForm">
                                <input type="hidden" name="action" value="<c:out value='${isEdit ? "update" : "create"}'/>" />
                                <c:if test="${isEdit}">
                                    <input type="hidden" name="id" value="${promotion.promotionId}" />
                                </c:if>

                                <!-- Thông tin cơ bản -->
                                <div class="mb-8">
                                    <h2 class="text-lg font-semibold text-primary mb-4 flex items-center gap-2">
                                        <i data-lucide="gift" class="w-5 h-5"></i> Thông tin khuyến mãi
                                    </h2>
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                        <div>
                                            <label for="title" class="block font-medium text-gray-700 mb-1">Tên khuyến mãi <span class="text-red-600">*</span></label>
                                            <input type="text" name="title" id="title" required maxlength="100"
                                                   value="<c:out value='${promotion.title}'/>"
                                                   class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary">
                                        </div>
                                        
                                        <div>
                                            <label for="promotionCode" class="block font-medium text-gray-700 mb-1">Mã khuyến mãi <span class="text-red-600">*</span></label>
                                            <input type="text" name="promotionCode" id="promotionCode" required maxlength="10"
                                                   value="<c:out value='${promotion.promotionCode}'/>"
                                                   class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary">
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
                                            <label for="discountType" class="block font-medium text-gray-700 mb-1">Loại giảm giá <span class="text-red-600">*</span></label>
                                            <select name="discountType" id="discountType" required class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary">
                                                <option value="PERCENTAGE" <c:if test="${promotion.discountType eq 'PERCENTAGE'}">selected</c:if>>Phần trăm (%)</option>
                                                <option value="FIXED" <c:if test="${promotion.discountType eq 'FIXED'}">selected</c:if>>Số tiền (VNĐ)</option>
                                            </select>
                                        </div>
                                        
                                        <div>
                                            <label for="discountValue" class="block font-medium text-gray-700 mb-1">Giá trị giảm giá <span class="text-red-600">*</span></label>
                                            <input type="number" name="discountValue" id="discountValue" required min="0" step="0.01"
                                                   value="<c:out value='${promotion.discountValue}'/>"
                                                   class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary">
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
                                                   value="${not empty promotion.startDate ? promotion.startDate.toString().substring(0,10) : ''}"
                                                   class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary">
                                        </div>
                                        
                                        <div>
                                            <label for="endDate" class="block font-medium text-gray-700 mb-1">Ngày kết thúc <span class="text-red-600">*</span></label>
                                            <input type="date" name="endDate" id="endDate" required
                                                   value="${not empty promotion.endDate ? promotion.endDate.toString().substring(0,10) : ''}"
                                                   class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary">
                                        </div>
                                    </div>
                                </div>

                                <!-- Cài đặt khác -->
                                <div class="mb-8">
                                    <h2 class="text-lg font-semibold text-primary mb-4 flex items-center gap-2">
                                        <i data-lucide="settings" class="w-5 h-5"></i> Cài đặt
                                    </h2>
                                    
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                        <div>
                                            <label for="status" class="block font-medium text-gray-700 mb-1">Trạng thái (tự động)</label>
                                            <input type="text" id="statusDisplay" readonly 
                                                   class="w-full border rounded-lg px-3 py-2 bg-gray-100 text-gray-600"
                                                   value="Đang tính toán trạng thái...">
                                            <input type="hidden" name="status" id="status" value="${promotion.status}">
                                            <p class="text-gray-500 text-xs mt-1">Trạng thái sẽ được tự động xác định dựa trên ngày bắt đầu và kết thúc</p>
                                        </div>

                                        <div>
                                            <label for="customerCondition" class="block font-medium text-gray-700 mb-1">Điều kiện khách hàng <span class="text-red-600">*</span></label>
                                            <select name="customerCondition" id="customerCondition" required class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary">
                                                <option value="ALL" <c:if test="${promotion.customerCondition eq 'ALL'}">selected</c:if>>Tất cả khách hàng</option>
                                                <option value="INDIVIDUAL" <c:if test="${promotion.customerCondition eq 'INDIVIDUAL'}">selected</c:if>>Khách hàng cá nhân</option>
                                                <option value="COUPLE" <c:if test="${promotion.customerCondition eq 'COUPLE'}">selected</c:if>>Khách hàng đi cặp</option>
                                                <option value="GROUP" <c:if test="${promotion.customerCondition eq 'GROUP'}">selected</c:if>>Khách hàng đi nhóm (3+)</option>
                                            </select>
                                            <p class="text-gray-500 text-xs mt-1">Điều kiện áp dụng khuyến mãi cho từng loại khách hàng</p>
                                        </div>
                                    </div>

                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mt-6">
                                        <div>
                                            <label for="minimumAppointmentValue" class="block font-medium text-gray-700 mb-1">Giá trị đơn hàng tối thiểu</label>
                                            <input type="number" name="minimumAppointmentValue" id="minimumAppointmentValue" min="0" step="0.01"
                                                   value="<c:out value='${promotion.minimumAppointmentValue}'/>"
                                                   class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary">
                                        </div>
                                    </div>

                                    <div class="mt-6">
                                        <label for="description" class="block font-medium text-gray-700 mb-1">Mô tả <span class="text-red-600">*</span></label>
                                        <textarea name="description" id="description" rows="4" required
                                                  class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary"><c:out value='${promotion.description}'/></textarea>
                                    </div>

                                    <div class="mt-6">
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
                                        <c:if test="${not empty promotion.imageUrl}">
                                            <div class="mt-2">
                                                <p class="text-sm text-gray-600 mb-2">Ảnh hiện tại:</p>
                                                <img src="${pageContext.request.contextPath}${promotion.imageUrl}" alt="Ảnh khuyến mãi hiện tại" 
                                                     class="w-32 h-32 object-cover rounded-lg border">
                                            </div>
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
                                        <i data-lucide="save" class="w-5 h-5"></i>
                                        <c:choose>
                                            <c:when test="${isEdit}">Cập nhật khuyến mãi</c:when>
                                            <c:otherwise>Tạo khuyến mãi</c:otherwise>
                                        </c:choose>
                                    </button>
                                </div>
                            </form>
                        </c:otherwise>
                    </c:choose>
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

        // Image preview functionality
        function previewImage(input) {
            const previewContainer = document.getElementById('imagePreview');
            const image = previewContainer.querySelector('img');

            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    image.src = e.target.result;
                    previewContainer.classList.remove('hidden');
                }
                reader.readAsDataURL(input.files[0]);
            } else {
                image.src = ''; // Clear preview if no file selected
                previewContainer.classList.add('hidden');
            }
        }

        // Auto uppercase promotion code
        document.getElementById('promotionCode').addEventListener('input', function(e) {
            this.value = this.value.toUpperCase();
        });

        // Form validation
        document.getElementById('promotionForm').addEventListener('submit', function(e) {
            const startDate = new Date(document.getElementById('startDate').value);
            const endDate = new Date(document.getElementById('endDate').value);
            
            if (endDate <= startDate) {
                e.preventDefault();
                alert('Ngày kết thúc phải sau ngày bắt đầu!');
                return false;
            }
        });

        // Initialize status on page load
        updateStatus();
    </script>
</body>
</html>
