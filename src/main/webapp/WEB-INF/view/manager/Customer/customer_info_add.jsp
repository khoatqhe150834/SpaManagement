<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Thêm Khách Hàng Mới - Manager Dashboard</title>

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
            @apply w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary;
        }
        .is-invalid {
            border: 1px solid #dc2626 !important; /* red-600 */
        }
        .invalid-feedback {
            color: #dc2626; /* red-600 */
            font-size: 0.875rem; /* text-sm */
            margin-top: 0.25rem; /* mt-1 */
            min-height: 1.25rem; /* h-5 */
        }
    </style>
</head>

<body class="bg-spa-cream font-sans min-h-screen">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

        <main class="flex-1 py-12 lg:py-20 ml-64">
            <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">

                <!-- Breadcrumb -->
                <div class="flex flex-wrap items-center gap-2 mb-8 text-gray-500 text-sm">
                    <a href="${pageContext.request.contextPath}/manager/customer/list" class="flex items-center gap-1 hover:text-primary">
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

                <!-- Add Customer Form -->
                <div class="bg-white rounded-2xl shadow-lg p-8">
                    <div class="mb-6">
                        <h1 class="text-2xl font-bold text-spa-dark">Thêm Khách Hàng Mới</h1>
                        <p class="text-gray-600 mt-2">Nhập thông tin cá nhân của khách hàng mới</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/manager/customer/create" method="post" id="customer-form" novalidate>
                        
                        <!-- Personal Information -->
                        <div class="mb-8">
                            <h2 class="text-lg font-semibold text-primary mb-4 flex items-center gap-2">
                                <i data-lucide="user-circle" class="w-5 h-5"></i> 
                                Thông tin cá nhân
                            </h2>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                    <label for="fullName" class="block font-medium text-gray-700 mb-1">
                                        Họ tên <span class="text-red-600">*</span>
                                    </label>
                                    <input type="text" name="fullName" id="fullName" value="${param.fullName}" required 
                                           class="form-input ${not empty errors.fullName ? 'is-invalid' : ''}" />
                                    <div class="invalid-feedback">${errors.fullName}</div>
                                </div>
                                <div>
                                    <label for="phoneNumber" class="block font-medium text-gray-700 mb-1">
                                        Số điện thoại <span class="text-red-600">*</span>
                                    </label>
                                    <input type="tel" name="phoneNumber" id="phoneNumber" value="${param.phoneNumber}" required 
                                           class="form-input ${not empty errors.phoneNumber ? 'is-invalid' : ''}" 
                                           pattern="^0\d{9}$" placeholder="0xxxxxxxxx" />
                                    <div class="invalid-feedback">${errors.phoneNumber}</div>
                                </div>
                                <div>
                                    <label for="birthday" class="block font-medium text-gray-700 mb-1">
                                        Ngày sinh <span class="text-red-600">*</span>
                                    </label>
                                    <input type="date" name="birthday" id="birthday" value="${param.birthday}" required 
                                           class="form-input ${not empty errors.birthday ? 'is-invalid' : ''}" 
                                           max="2010-12-31" />
                                    <div class="invalid-feedback">${errors.birthday}</div>
                                </div>
                                <div>
                                    <label for="gender" class="block font-medium text-gray-700 mb-1">Giới tính</label>
                                    <select name="gender" id="gender" class="form-input">
                                        <option value="Male" ${param.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                        <option value="Female" ${param.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                                        <option value="Other" ${param.gender == 'Other' ? 'selected' : ''}>Khác</option>
                                    </select>
                                </div>
                                <div class="md:col-span-2">
                                    <label for="address" class="block font-medium text-gray-700 mb-1">
                                        Địa chỉ <span class="text-red-600">*</span>
                                    </label>
                                    <input type="text" name="address" id="address" value="${param.address}" required 
                                           class="form-input ${not empty errors.address ? 'is-invalid' : ''}" 
                                           placeholder="Địa chỉ đầy đủ của khách hàng" />
                                    <div class="invalid-feedback">${errors.address}</div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Customer Management -->
                        <div class="mb-8">
                            <h2 class="text-lg font-semibold text-primary mb-4 flex items-center gap-2">
                                <i data-lucide="settings" class="w-5 h-5"></i> 
                                Thông tin quản lý
                            </h2>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                    <label for="loyaltyPoints" class="block font-medium text-gray-700 mb-1">
                                        Điểm thân thiết ban đầu
                                    </label>
                                    <input type="number" name="loyaltyPoints" id="loyaltyPoints" 
                                           value="${param.loyaltyPoints != null ? param.loyaltyPoints : '0'}" 
                                           min="0" class="form-input ${not empty errors.loyaltyPoints ? 'is-invalid' : ''}" />
                                    <div class="invalid-feedback">${errors.loyaltyPoints}</div>
                                    <div class="text-xs text-gray-500 mt-1">
                                        Mặc định là 0 điểm cho khách hàng mới
                                    </div>
                                </div>
                                <div>
                                    <label class="block font-medium text-gray-700 mb-1">
                                        Trạng thái ban đầu
                                    </label>
                                    <div class="bg-gray-50 border rounded-lg px-3 py-2">
                                        <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-green-100 text-green-800">
                                            <i data-lucide="user-check" class="w-3 h-3 mr-1"></i>
                                            Khách hàng mới
                                        </span>
                                    </div>
                                    <div class="text-xs text-gray-500 mt-1">
                                        Khách hàng sẽ cần đăng ký tài khoản để sử dụng dịch vụ online
                                    </div>
                                </div>
                                <div class="md:col-span-2">
                                    <label for="notes" class="block font-medium text-gray-700 mb-1">
                                        Ghi chú của Manager
                                    </label>
                                    <textarea name="notes" id="notes" rows="4" 
                                              class="form-input" 
                                              placeholder="Thêm ghi chú về khách hàng: sở thích, yêu cầu đặc biệt, nguồn giới thiệu...">${param.notes}</textarea>
                                    <div class="invalid-feedback">${errors.notes}</div>
                                    <div class="text-xs text-gray-500 mt-1">
                                        Ghi chú này sẽ giúp cải thiện dịch vụ chăm sóc khách hàng
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Form Instructions -->
                        <div class="mb-8 bg-blue-50 border border-blue-200 rounded-lg p-4">
                            <div class="flex items-start gap-3">
                                <i data-lucide="info" class="w-5 h-5 text-blue-600 mt-0.5"></i>
                                <div>
                                    <h5 class="font-medium text-blue-800">Lưu ý quan trọng</h5>
                                    <ul class="text-sm text-blue-700 mt-1 space-y-1">
                                        <li>• Thông tin khách hàng này chỉ dành cho quản lý nội bộ</li>
                                        <li>• Khách hàng cần đăng ký tài khoản riêng để đặt lịch online</li>
                                        <li>• Số điện thoại phải là số Việt Nam hợp lệ (10 số, bắt đầu bằng 0)</li>
                                        <li>• Tất cả thông tin có dấu (*) là bắt buộc</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="flex justify-end gap-3 mt-8 pt-6 border-t border-gray-200">
                            <a href="${pageContext.request.contextPath}/manager/customer/list" 
                               class="inline-flex items-center gap-2 px-6 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition">
                                <i data-lucide="arrow-left" class="w-5 h-5"></i> 
                                Hủy và quay lại
                            </a>
                            <button type="submit" 
                                    class="inline-flex items-center gap-2 px-6 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition">
                                <i data-lucide="user-plus" class="w-5 h-5"></i> 
                                Thêm khách hàng
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
    <script>
        if (window.lucide) {
            lucide.createIcons();
        }

        // Form validation
        document.getElementById('customer-form').addEventListener('submit', function(e) {
            let isValid = true;
            
            // Validate required fields
            const requiredFields = ['fullName', 'phoneNumber', 'birthday', 'address'];
            requiredFields.forEach(field => {
                const input = document.getElementById(field);
                if (!input.value.trim()) {
                    input.classList.add('is-invalid');
                    isValid = false;
                } else {
                    input.classList.remove('is-invalid');
                }
            });
            
            // Validate phone number format
            const phoneInput = document.getElementById('phoneNumber');
            const phonePattern = /^0\d{9}$/;
            if (!phonePattern.test(phoneInput.value)) {
                phoneInput.classList.add('is-invalid');
                isValid = false;
            }
            
            // Validate date (must be at least 14 years old)
            const birthdayInput = document.getElementById('birthday');
            const birthday = new Date(birthdayInput.value);
            const today = new Date();
            const age = today.getFullYear() - birthday.getFullYear();
            const monthDiff = today.getMonth() - birthday.getMonth();
            
            if (age < 14 || (age === 14 && monthDiff < 0)) {
                birthdayInput.classList.add('is-invalid');
                alert('Khách hàng phải từ 14 tuổi trở lên.');
                isValid = false;
            }
            
            if (!isValid) {
                e.preventDefault();
                alert('Vui lòng kiểm tra và điền đầy đủ thông tin bắt buộc.');
            }
        });

        // Real-time phone validation
        document.getElementById('phoneNumber').addEventListener('input', function() {
            const phonePattern = /^0\d{9}$/;
            if (this.value && !phonePattern.test(this.value)) {
                this.classList.add('is-invalid');
            } else {
                this.classList.remove('is-invalid');
            }
        });
    </script>
</body>
</html> 