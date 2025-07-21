<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Khách Hàng Mới - Dashboard</title>

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
                    <span class="text-primary font-semibold">Thêm khách hàng mới</span>
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
                                <p class="text-sm font-medium">Lỗi khi thêm khách hàng:</p>
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

                <!-- Add Customer Form -->
                <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
                    <div class="bg-gradient-to-r from-primary to-primary-dark p-6">
                        <h1 class="text-2xl font-bold text-white flex items-center gap-2">
                            <i data-lucide="user-plus" class="w-6 h-6"></i>
                            Thêm Khách Hàng Mới
                        </h1>
                        <p class="text-white/90 mt-2">Nhập thông tin đầy đủ để tạo tài khoản khách hàng mới</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/customer-management/add" method="post" 
                          id="customer-form" class="p-6 space-y-8" novalidate>
                        
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
                                           value="${customerInput.fullName}"
                                           placeholder="Nhập họ tên đầy đủ"
                                           required>
                                    <c:if test="${errors.fullName != null}">
                                        <div class="invalid-feedback">${errors.fullName}</div>
                                    </c:if>
                                </div>
                                
                                <div>
                                    <label for="gender" class="form-label">Giới tính</label>
                                    <select id="gender" name="gender" class="form-input">
                                        <option value="UNKNOWN" ${customerInput.gender == 'UNKNOWN' ? 'selected' : ''}>Không xác định</option>
                                        <option value="MALE" ${customerInput.gender == 'MALE' ? 'selected' : ''}>Nam</option>
                                        <option value="FEMALE" ${customerInput.gender == 'FEMALE' ? 'selected' : ''}>Nữ</option>
                                        <option value="OTHER" ${customerInput.gender == 'OTHER' ? 'selected' : ''}>Khác</option>
                                    </select>
                                </div>
                                
                                <div>
                                    <label for="birthday" class="form-label">Ngày sinh</label>
                                    <input type="date" 
                                           id="birthday" 
                                           name="birthday" 
                                           class="form-input ${errors.birthday != null ? 'is-invalid' : ''}"
                                           value="${customerInput.birthday}">
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
                                           value="${customerInput.phoneNumber}"
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
                                           value="${customerInput.address}"
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
                                    <input type="email" 
                                           id="email" 
                                           name="email" 
                                           class="form-input ${errors.email != null ? 'is-invalid' : ''}"
                                           value="${customerInput.email}"
                                           placeholder="Email đăng nhập (tùy chọn)">
                                    <c:if test="${errors.email != null}">
                                        <div class="invalid-feedback">${errors.email}</div>
                                    </c:if>
                                    <div class="text-sm text-gray-500 mt-1">
                                        <i data-lucide="info" class="w-4 h-4 inline mr-1"></i>
                                        Nếu không cung cấp email, khách hàng có thể đăng ký sau
                                    </div>
                                </div>
                                
                                <div class="md:col-span-2">
                                    <label for="password" class="form-label">Mật khẩu</label>
                                    <input type="password" 
                                           id="password" 
                                           name="password" 
                                           class="form-input ${errors.password != null ? 'is-invalid' : ''}"
                                           placeholder="Mật khẩu (tùy chọn)">
                                    <c:if test="${errors.password != null}">
                                        <div class="invalid-feedback">${errors.password}</div>
                                    </c:if>
                                    <div class="text-sm text-gray-500 mt-1">
                                        <i data-lucide="info" class="w-4 h-4 inline mr-1"></i>
                                        Nếu không cung cấp mật khẩu, khách hàng có thể đặt lại sau
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Additional Information Section -->
                        <div>
                            <h2 class="text-lg font-semibold text-spa-dark mb-4 flex items-center gap-2">
                                <i data-lucide="sticky-note" class="w-5 h-5 text-primary"></i> 
                                Thông tin bổ sung
                            </h2>
                            
                            <div>
                                <label for="notes" class="form-label">Ghi chú</label>
                                <textarea id="notes" 
                                          name="notes" 
                                          rows="4" 
                                          class="form-input"
                                          placeholder="Ghi chú về khách hàng (tùy chọn)...">${customerInput.notes}</textarea>
                                <div class="text-sm text-gray-500 mt-1">
                                    <i data-lucide="info" class="w-4 h-4 inline mr-1"></i>
                                    Ghi chú sẽ giúp nhân viên hiểu rõ hơn về khách hàng
                                </div>
                            </div>
                        </div>
                        
                        <!-- Form Actions -->
                        <div class="flex flex-col sm:flex-row gap-4 pt-6 border-t border-gray-200">
                            <button type="submit" 
                                    class="flex-1 sm:flex-none px-6 py-3 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors font-semibold flex items-center justify-center gap-2">
                                <i data-lucide="save" class="w-4 h-4"></i>
                                Thêm khách hàng
                            </button>
                            
                            <a href="${pageContext.request.contextPath}/customer-management/list" 
                               class="flex-1 sm:flex-none px-6 py-3 bg-gray-500 text-white rounded-lg hover:bg-gray-600 transition-colors font-semibold text-center flex items-center justify-center gap-2">
                                <i data-lucide="x" class="w-4 h-4"></i>
                                Hủy bỏ
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
            
            // Validate password if provided
            const password = document.getElementById('password');
            if (password && password.value.trim() && password.value.length < 7) {
                showError(password, 'Mật khẩu phải có ít nhất 7 ký tự');
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
                } else if (this.id === 'password' && this.value.trim()) {
                    if (this.value.length < 7) {
                        showError(this, 'Mật khẩu phải có ít nhất 7 ký tự');
                    }
                } else if (this.id === 'phoneNumber' && this.value.trim()) {
                    if (!/^0[0-9]{9}$/.test(this.value.trim())) {
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