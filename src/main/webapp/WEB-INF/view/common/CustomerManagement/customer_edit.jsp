<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh Sửa Khách Hàng - ${customer.fullName}</title>

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
    
    <style>
        .form-input {
            @apply w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-primary focus:border-primary transition-colors;
        }
        .form-input:focus {
            outline: none;
        }
        .is-invalid {
            @apply border-red-500 focus:ring-red-500 focus:border-red-500;
        }
        .invalid-feedback {
            @apply text-red-600 text-sm mt-1 block;
        }
        .form-label {
            @apply block text-sm font-medium text-gray-700 mb-2;
        }
        .form-required {
            @apply text-red-500;
        }
    </style>
</head>

<body class="bg-spa-cream font-sans min-h-screen">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    
    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

        <main class="flex-1 py-12 lg:py-20 ml-64">
            <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">

                <!-- Breadcrumb -->
                <div class="flex flex-wrap items-center gap-2 mb-8 text-gray-500 text-sm">
                    <a href="${pageContext.request.contextPath}/customer-management/list" class="flex items-center gap-1 hover:text-primary">
                        <i data-lucide="users" class="w-4 h-4"></i>
                        Danh sách khách hàng
                    </a>
                    <span>-</span>
                    <span class="text-primary font-semibold">Chỉnh sửa khách hàng</span>
                </div>

                <!-- Success/Error Messages -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6 rounded-lg" role="alert">
                        <p>${sessionScope.successMessage}</p>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>

                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-lg" role="alert">
                        <p>${sessionScope.errorMessage}</p>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <!-- Form Errors -->
                <c:if test="${not empty error}">
                    <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-lg" role="alert">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <i data-lucide="alert-circle" class="w-5 h-5 text-red-500"></i>
                            </div>
                            <div class="ml-3">
                                <p class="text-sm font-medium">Lỗi khi cập nhật khách hàng:</p>
                                <p class="text-sm">${error}</p>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- Validation Errors Summary -->
                <c:if test="${not empty errors}">
                    <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-lg" role="alert">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <i data-lucide="alert-triangle" class="w-5 h-5 text-red-500"></i>
                            </div>
                            <div class="ml-3">
                                <p class="text-sm font-medium">Vui lòng kiểm tra lại thông tin:</p>
                                <ul class="mt-2 text-sm list-disc list-inside">
                                    <c:forEach items="${errors}" var="error">
                                        <li>${error.value}</li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- Edit Customer Form -->
                <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
                    <div class="bg-gradient-to-r from-primary to-primary-dark p-6">
                        <h1 class="text-2xl font-bold text-white flex items-center gap-2">
                            <i data-lucide="edit" class="w-6 h-6"></i>
                            Chỉnh Sửa Khách Hàng
                        </h1>
                        <p class="text-white/90 mt-2">Cập nhật thông tin khách hàng: ${customer.fullName}</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/customer-management/update" method="post" 
                          id="customer-form" class="p-6 space-y-8" novalidate>
                        
                        <input type="hidden" name="id" value="${customer.customerId}">
                        
                        <!-- Personal Information Section -->
                        <div>
                            <h2 class="text-lg font-semibold text-spa-dark mb-4 flex items-center gap-2">
                                <i data-lucide="user-circle" class="w-5 h-5 text-primary"></i> 
                                Thông tin cá nhân
                            </h2>
                            
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                    <label for="fullName" class="form-label">
                                        Họ và tên <span class="form-required">*</span>
                                    </label>
                                    <input type="text" 
                                           id="fullName" 
                                           name="fullName" 
                                           class="form-input ${errors.fullName != null ? 'is-invalid' : ''}"
                                           value="${customer.fullName}"
                                           placeholder="Nhập họ tên đầy đủ"
                                           required>
                                    <c:if test="${errors.fullName != null}">
                                        <div class="invalid-feedback">${errors.fullName}</div>
                                    </c:if>
                                </div>
                                
                                <div>
                                    <label for="gender" class="form-label">Giới tính</label>
                                    <select id="gender" name="gender" class="form-input">
                                        <option value="UNKNOWN" ${customer.gender == 'UNKNOWN' ? 'selected' : ''}>Không xác định</option>
                                        <option value="MALE" ${customer.gender == 'MALE' ? 'selected' : ''}>Nam</option>
                                        <option value="FEMALE" ${customer.gender == 'FEMALE' ? 'selected' : ''}>Nữ</option>
                                        <option value="OTHER" ${customer.gender == 'OTHER' ? 'selected' : ''}>Khác</option>
                                    </select>
                                </div>
                                
                                <div>
                                    <label for="birthday" class="form-label">Ngày sinh</label>
                                    <input type="date" 
                                           id="birthday" 
                                           name="birthday" 
                                           class="form-input ${errors.birthday != null ? 'is-invalid' : ''}"
                                           value="<fmt:formatDate value='${customer.birthday}' pattern='yyyy-MM-dd' />">
                                    <c:if test="${errors.birthday != null}">
                                        <div class="invalid-feedback">${errors.birthday}</div>
                                    </c:if>
                                </div>
                                
                                <div>
                                    <label for="phoneNumber" class="form-label">Số điện thoại</label>
                                    <input type="tel" 
                                           id="phoneNumber" 
                                           name="phoneNumber" 
                                           class="form-input ${errors.phoneNumber != null ? 'is-invalid' : ''}"
                                           value="${customer.phoneNumber}"
                                           placeholder="Số điện thoại">
                                    <c:if test="${errors.phoneNumber != null}">
                                        <div class="invalid-feedback">${errors.phoneNumber}</div>
                                    </c:if>
                                </div>
                                
                                <div class="md:col-span-2">
                                    <label for="address" class="form-label">Địa chỉ</label>
                                    <input type="text" 
                                           id="address" 
                                           name="address" 
                                           class="form-input"
                                           value="${customer.address}"
                                           placeholder="Địa chỉ liên hệ">
                                </div>
                            </div>
                        </div>
                        
                        <!-- Account Information Section -->
                        <div>
                            <h2 class="text-lg font-semibold text-spa-dark mb-4 flex items-center gap-2">
                                <i data-lucide="mail" class="w-5 h-5 text-primary"></i> 
                                Thông tin tài khoản
                            </h2>
                            
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div class="md:col-span-2">
                                    <label for="email" class="form-label">Email</label>
                                    <div class="flex items-center gap-2">
                                        <input type="email" 
                                               id="email" 
                                               name="email" 
                                               class="form-input ${errors.email != null ? 'is-invalid' : ''}"
                                               value="${customer.email}"
                                               placeholder="Email đăng nhập">
                                        <c:if test="${customer.isVerified}">
                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                <i data-lucide="check-circle" class="w-3 h-3 mr-1"></i>
                                                Đã xác thực
                                            </span>
                                        </c:if>
                                    </div>
                                    <c:if test="${errors.email != null}">
                                        <div class="invalid-feedback">${errors.email}</div>
                                    </c:if>
                                </div>
                                
                                <div class="md:col-span-2">
                                    <div class="flex items-center justify-between mb-2">
                                        <label class="form-label mb-0">Mật khẩu</label>
                                        <a href="${pageContext.request.contextPath}/customer-management/quick-reset-password?id=${customer.customerId}" 
                                           class="text-sm text-primary hover:text-primary-dark"
                                           onclick="return confirm('Bạn có chắc muốn đặt lại mật khẩu cho khách hàng này?')">
                                            <i data-lucide="key" class="w-4 h-4 inline mr-1"></i>
                                            Đặt lại mật khẩu
                                        </a>
                                    </div>
                                    <div class="p-3 bg-gray-50 rounded-lg">
                                        <p class="text-sm text-gray-600">
                                            <i data-lucide="info" class="w-4 h-4 inline mr-1"></i>
                                            Sử dụng chức năng "Đặt lại mật khẩu" để tạo mật khẩu mới cho khách hàng
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Account Status Section -->
                        <div>
                            <h2 class="text-lg font-semibold text-spa-dark mb-4 flex items-center gap-2">
                                <i data-lucide="shield" class="w-5 h-5 text-primary"></i> 
                                Trạng thái tài khoản
                            </h2>
                            
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div class="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                                    <div>
                                        <p class="font-medium text-gray-900">Trạng thái tài khoản</p>
                                        <p class="text-sm text-gray-500">Kích hoạt hoặc khóa tài khoản</p>
                                    </div>
                                    <div class="flex gap-2">
                                        <c:choose>
                                            <c:when test="${customer.isActive}">
                                                <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                    <i data-lucide="check-circle" class="w-3 h-3 mr-1"></i>
                                                    Hoạt động
                                                </span>
                                                <a href="${pageContext.request.contextPath}/customer-management/deactivate?id=${customer.customerId}" 
                                                   class="px-3 py-1 bg-red-100 text-red-800 rounded-lg text-sm hover:bg-red-200"
                                                   onclick="return confirm('Bạn có chắc muốn khóa tài khoản này?')">
                                                    Khóa
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                                    <i data-lucide="x-circle" class="w-3 h-3 mr-1"></i>
                                                    Bị khóa
                                                </span>
                                                <a href="${pageContext.request.contextPath}/customer-management/activate?id=${customer.customerId}" 
                                                   class="px-3 py-1 bg-green-100 text-green-800 rounded-lg text-sm hover:bg-green-200">
                                                    Kích hoạt
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <c:if test="${not empty customer.email}">
                                    <div class="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                                        <div>
                                            <p class="font-medium text-gray-900">Xác thực email</p>
                                            <p class="text-sm text-gray-500">Trạng thái xác thực email</p>
                                        </div>
                                        <div class="flex gap-2">
                                            <c:choose>
                                                <c:when test="${customer.isVerified}">
                                                    <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                        <i data-lucide="mail-check" class="w-3 h-3 mr-1"></i>
                                                        Đã xác thực
                                                    </span>
                                                    <a href="${pageContext.request.contextPath}/customer-management/unverify?id=${customer.customerId}" 
                                                       class="px-3 py-1 bg-orange-100 text-orange-800 rounded-lg text-sm hover:bg-orange-200">
                                                        Hủy xác thực
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                                                        <i data-lucide="mail-x" class="w-3 h-3 mr-1"></i>
                                                        Chưa xác thực
                                                    </span>
                                                    <a href="${pageContext.request.contextPath}/customer-management/verify?id=${customer.customerId}" 
                                                       class="px-3 py-1 bg-blue-100 text-blue-800 rounded-lg text-sm hover:bg-blue-200">
                                                        Xác thực
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                        
                        <!-- Additional Information Section -->
                        <div>
                            <h2 class="text-lg font-semibold text-spa-dark mb-4 flex items-center gap-2">
                                <i data-lucide="sticky-note" class="w-5 h-5 text-primary"></i> 
                                Thông tin bổ sung
                            </h2>
                            
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                    <label for="notes" class="form-label">Ghi chú</label>
                                    <textarea id="notes" 
                                              name="notes" 
                                              rows="4" 
                                              class="form-input"
                                              placeholder="Ghi chú về khách hàng...">${customer.notes}</textarea>
                                </div>
                                
                                <div>
                                    <label class="form-label">Thống kê</label>
                                    <div class="space-y-3">
                                        <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                            <span class="text-sm text-gray-600">Điểm tích lũy:</span>
                                            <span class="font-semibold text-primary">
                                                <fmt:formatNumber value="${customer.loyaltyPoints}" type="number"/> điểm
                                            </span>
                                        </div>
                                        <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                            <span class="text-sm text-gray-600">Ngày tạo:</span>
                                            <span class="text-sm text-gray-900">
                                                <c:choose>
                                                    <c:when test="${not empty customer.createdAt}">
                                                        <fmt:formatDate value="${customer.createdAt}" pattern="dd/MM/yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>Không xác định</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                            <span class="text-sm text-gray-600">Lần cập nhật cuối:</span>
                                            <span class="text-sm text-gray-900">
                                                <c:choose>
                                                    <c:when test="${not empty customer.updatedAt}">
                                                        <fmt:formatDate value="${customer.updatedAt}" pattern="dd/MM/yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>Không xác định</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Form Actions -->
                        <div class="flex flex-col sm:flex-row gap-4 pt-6 border-t border-gray-200">
                            <button type="submit" 
                                    class="flex-1 sm:flex-none px-6 py-3 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors font-semibold flex items-center justify-center gap-2">
                                <i data-lucide="save" class="w-4 h-4"></i>
                                Lưu thay đổi
                            </button>
                            
                            <a href="${pageContext.request.contextPath}/customer-management/view?id=${customer.customerId}" 
                               class="flex-1 sm:flex-none px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors font-semibold text-center flex items-center justify-center gap-2">
                                <i data-lucide="eye" class="w-4 h-4"></i>
                                Xem chi tiết
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/customer-management/list" 
                               class="flex-1 sm:flex-none px-6 py-3 bg-gray-500 text-white rounded-lg hover:bg-gray-600 transition-colors font-semibold text-center flex items-center justify-center gap-2">
                                <i data-lucide="arrow-left" class="w-4 h-4"></i>
                                Quay lại
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Initialize Lucide icons
        lucide.createIcons();
        
        // Form validation
        document.getElementById('customer-form').addEventListener('submit', function(e) {
            let isValid = true;
            
            // Reset previous errors
            document.querySelectorAll('.form-input').forEach(input => {
                input.classList.remove('is-invalid');
            });
            document.querySelectorAll('.invalid-feedback').forEach(feedback => {
                feedback.remove();
            });
            
            // Validate required fields
            const fullName = document.getElementById('fullName');
            if (!fullName.value.trim()) {
                showError(fullName, 'Họ tên là bắt buộc');
                isValid = false;
            } else if (fullName.value.trim().length < 2) {
                showError(fullName, 'Họ tên phải có ít nhất 2 ký tự');
                isValid = false;
            } else if (fullName.value.trim().length > 100) {
                showError(fullName, 'Họ tên không được vượt quá 100 ký tự');
                isValid = false;
            } else if (!/^[\p{L}\s]+$/u.test(fullName.value.trim())) {
                showError(fullName, 'Họ tên chỉ được chứa chữ cái và khoảng trắng, không chứa số hoặc ký tự đặc biệt.');
                isValid = false;
            }

            // Validate email if provided
            const email = document.getElementById('email');
            if (email.value.trim() && !isValidEmail(email.value)) {
                showError(email, 'Email không hợp lệ');
                isValid = false;
            }

            // Validate phone if provided
            const phoneNumber = document.getElementById('phoneNumber');
            if (phoneNumber.value.trim()) {
                if (!/^0[0-9]{9}$/.test(phoneNumber.value.trim())) {
                    showError(phoneNumber, 'Số điện thoại phải bắt đầu bằng 0, gồm đúng 10 chữ số và không chứa ký tự đặc biệt.');
                    isValid = false;
                }
            }

            // Validate birthday if provided
            const birthday = document.getElementById('birthday');
            if (birthday.value.trim()) {
                if (!isValidBirthday(birthday.value)) {
                    showError(birthday, 'Ngày sinh không hợp lệ, phải đủ 14 tuổi trở lên và không vượt quá ngày hiện tại.');
                    isValid = false;
                }
            }
            
            if (!isValid) {
                e.preventDefault();
                // Scroll to first error
                const firstError = document.querySelector('.is-invalid');
                if (firstError) {
                    firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    firstError.focus();
                }
            }
        });
        
        function showError(input, message) {
            input.classList.add('is-invalid');
            
            // Create error message
            const errorDiv = document.createElement('div');
            errorDiv.className = 'invalid-feedback';
            errorDiv.textContent = message;
            
            // Insert error message after input
            input.parentNode.insertBefore(errorDiv, input.nextSibling);
        }
        
        function isValidEmail(email) {
            const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
            return emailRegex.test(email);
        }
        
        function isValidPhone(phone) {
            const phoneRegex = /^[0-9+\-\s()]{10,15}$/;
            return phoneRegex.test(phone);
        }
        
        function isValidBirthday(birthday) {
            try {
                const date = new Date(birthday);
                const today = new Date();
                if (date > today) return false;
                const age = today.getFullYear() - date.getFullYear();
                const m = today.getMonth() - date.getMonth();
                if (m < 0 || (m === 0 && today.getDate() < date.getDate())) {
                    return age - 1 >= 14;
                }
                return age >= 14;
            } catch (e) {
                return false;
            }
        }
        
        // Real-time validation feedback
        document.querySelectorAll('.form-input').forEach(input => {
            input.addEventListener('input', function() {
                if (this.classList.contains('is-invalid')) {
                    this.classList.remove('is-invalid');
                    const errorDiv = this.parentNode.querySelector('.invalid-feedback');
                    if (errorDiv) {
                        errorDiv.remove();
                    }
                }
            });
            
            input.addEventListener('blur', function() {
                // Validate on blur for better UX
                if (this.id === 'fullName' && this.value.trim()) {
                    if (this.value.trim().length < 2) {
                        showError(this, 'Họ tên phải có ít nhất 2 ký tự');
                    } else if (this.value.trim().length > 100) {
                        showError(this, 'Họ tên không được vượt quá 100 ký tự');
                    } else if (!/^[\p{L}\s]+$/u.test(this.value.trim())) {
                        showError(this, 'Họ tên chỉ được chứa chữ cái và khoảng trắng, không chứa số hoặc ký tự đặc biệt.');
                    }
                } else if (this.id === 'email' && this.value.trim()) {
                    if (!isValidEmail(this.value)) {
                        showError(this, 'Email không hợp lệ');
                    }
                } else if (this.id === 'phoneNumber' && this.value.trim()) {
                    if (!isValidPhone(this.value)) {
                        showError(this, 'Số điện thoại không hợp lệ (10-15 số)');
                    } else if (!/^0[0-9]{9}$/.test(this.value.trim())) {
                        showError(this, 'Số điện thoại phải bắt đầu bằng 0, gồm đúng 10 chữ số và không chứa ký tự đặc biệt.');
                    }
                } else if (this.id === 'birthday' && this.value.trim()) {
                    if (!isValidBirthday(this.value)) {
                        showError(this, 'Ngày sinh không hợp lệ, phải đủ 14 tuổi trở lên và không vượt quá ngày hiện tại.');
                    }
                }
            });
        });
    </script>
</body>
</html> 