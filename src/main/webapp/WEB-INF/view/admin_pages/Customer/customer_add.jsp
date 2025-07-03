<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Khách Hàng Mới - Spa Hương Sen</title>

    <!-- Tailwind CSS -->
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

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet" />

    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>

    <!-- Custom CSS -->
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
    <style>
        .content-centered-with-sidebar {
            transform: translateX(calc(-20rem / 2));
        }
        .form-input {
            @apply w-full px-3 py-2 bg-white border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary;
        }
        .form-label {
            @apply block text-sm font-medium text-gray-700 mb-1;
        }
        .form-label.required::after {
            content: " *";
            color: #dc2626; /* red-600 */
        }
        .error-text {
            @apply text-red-600 text-sm mt-1;
        }
        .form-input.is-invalid {
            @apply border-red-500 focus:ring-red-500 focus:border-red-500;
        }
    </style>
</head>
<body class="bg-spa-cream font-sans">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />

    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

        <main class="flex-1 py-12 lg:py-20">
            <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 content-centered-with-sidebar">
                <div class="bg-white p-6 md:p-8 rounded-2xl shadow-lg">
                    <div class="mb-6">
                        <h1 class="text-3xl font-serif text-spa-dark font-bold">Thêm khách hàng mới</h1>
                        <p class="text-gray-600 mt-1">Điền thông tin chi tiết để tạo tài khoản cho khách hàng.</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6" role="alert">
                            <p>${error}</p>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/customer/create" method="post" novalidate>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-5">
                            <!-- Full Name -->
                            <div>
                                <label class="form-label required" for="fullName">Họ và tên</label>
                                <input type="text" class="form-input ${not empty errors.fullName ? 'is-invalid' : ''}" id="fullName" name="fullName" required maxlength="100" value="${not empty customerInput.fullName ? customerInput.fullName : ''}" placeholder="Nhập họ và tên">
                                <div class="error-text">${errors.fullName}</div>
                            </div>
                            
                            <!-- Email -->
                            <div>
                                <label class="form-label required" for="email">Email</label>
                                <input type="email" class="form-input ${not empty errors.email ? 'is-invalid' : ''}" id="email" name="email" required value="${not empty customerInput.email ? customerInput.email : ''}" placeholder="Nhập email">
                                <div class="error-text">${errors.email}</div>
                            </div>

                            <!-- Phone Number -->
                            <div>
                                <label class="form-label required" for="phoneNumber">Số điện thoại</label>
                                <input type="tel" class="form-input ${not empty errors.phoneNumber ? 'is-invalid' : ''}" id="phoneNumber" name="phoneNumber" required pattern="^0\d{9}$" title="Số điện thoại phải gồm 10 số và bắt đầu bằng số 0." value="${not empty customerInput.phoneNumber ? customerInput.phoneNumber : ''}" placeholder="Nhập số điện thoại">
                                <div class="error-text">${errors.phoneNumber}</div>
                            </div>

                            <!-- Password -->
                            <div>
                                <label class="form-label required" for="password">Mật khẩu</label>
                                <input type="password" class="form-input ${not empty errors.password ? 'is-invalid' : ''}" id="password" name="password" required minlength="7" placeholder="Nhập mật khẩu (tối thiểu 7 ký tự)">
                                <div class="error-text">${errors.password}</div>
                            </div>
                            
                            <!-- Birthday -->
                            <div>
                                <label class="form-label required" for="birthday">Ngày sinh</label>
                                <input type="date" class="form-input ${not empty errors.birthday ? 'is-invalid' : ''}" id="birthday" name="birthday" required value="${customerInput.birthday}">
                                <div class="error-text">${errors.birthday}</div>
                            </div>
                            
                            <!-- Gender -->
                            <div>
                                <label class="form-label" for="gender">Giới tính</label>
                                <select class="form-input" name="gender" id="gender">
                                    <option value="">-- Chọn giới tính --</option>
                                    <option value="Male" ${customerInput.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                    <option value="Female" ${customerInput.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                                    <option value="Other" ${customerInput.gender == 'Other' ? 'selected' : ''}>Khác</option>
                                </select>
                            </div>

                            <!-- Address -->
                            <div class="md:col-span-2">
                                <label class="form-label required" for="address">Địa chỉ</label>
                                <input type="text" class="form-input ${not empty errors.address ? 'is-invalid' : ''}" id="address" name="address" required value="${not empty customerInput.address ? customerInput.address : ''}" placeholder="Nhập địa chỉ">
                                <div class="error-text">${errors.address}</div>
                            </div>

                            <!-- Notes -->
                            <div class="md:col-span-2">
                                <label class="form-label" for="notes">Ghi chú</label>
                                <textarea class="form-input" id="notes" name="notes" rows="3" maxlength="500" placeholder="Thêm ghi chú về khách hàng...">${not empty customerInput.notes ? customerInput.notes : ''}</textarea>
                                <div class="error-text"></div>
                            </div>
                        </div>

                        <div class="mt-8 flex justify-end gap-3">
                            <a href="${pageContext.request.contextPath}/customer/list" class="px-6 py-2.5 bg-gray-100 text-gray-800 font-semibold rounded-lg hover:bg-gray-200 transition-colors">
                                Hủy
                            </a>
                            <button type="submit" class="px-6 py-2.5 bg-primary text-white font-semibold rounded-lg hover:bg-primary-dark transition-colors">
                                <i data-lucide="plus" class="inline-block w-4 h-4 mr-1"></i>
                                Thêm khách hàng
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
    $(document).ready(function() {
        let emailUnique = true;
        let phoneUnique = true;

        function showError(input, message) {
            input.addClass('is-invalid');
            input.closest('div').find('.error-text').html(message);
        }

        function clearError(input) {
            input.removeClass('is-invalid');
            input.closest('div').find('.error-text').html('');
        }
        
        // AJAX check email
        $('#email').on('blur', function() {
            const email = $(this).val().trim();
            if (email) {
                $.get('${pageContext.request.contextPath}/api/check-email', { email: email }, function(data) {
                    if (data.exists) {
                        showError($('#email'), 'Email đã tồn tại.');
                        emailUnique = false;
                    } else {
                        clearError($('#email'));
                        emailUnique = true;
                    }
                });
            }
        });

        // AJAX check phone
        $('#phoneNumber').on('blur', function() {
            const phone = $(this).val().trim();
            if (phone) {
                $.get('${pageContext.request.contextPath}/api/check-phone', { phone: phone }, function(data) {
                    if (data.exists) {
                        showError($('#phoneNumber'), 'Số điện thoại đã tồn tại.');
                        phoneUnique = false;
                    } else {
                        clearError($('#phoneNumber'));
                        phoneUnique = true;
                    }
                });
            }
        });

        // On submit: check all
        $('form').on('submit', function(e) {
            let valid = true;

            // --- Full Name Validation ---
            const fullName = $('#fullName');
            const fullNameVal = fullName.val().trim();
            let nameErrors = [];
            if (!fullNameVal) {
                nameErrors.push('Tên là bắt buộc.');
            }
            if (/[^\\p{L}\\s]/u.test(fullNameVal)) {
                nameErrors.push('Tên chỉ được chứa chữ cái và khoảng trắng.');
            }
            if (fullNameVal.length < 2 || fullNameVal.length > 100) {
                nameErrors.push('Tên phải có độ dài từ 2 đến 100 ký tự.');
            }
            if (fullNameVal.includes('  ')) {
                nameErrors.push('Tên không được có nhiều khoảng trắng liền kề.');
            }
            if (!fullNameVal.includes(' ') && fullNameVal.length > 0) {
                nameErrors.push('Tên đầy đủ cần có ít nhất hai từ.');
            }
            if (nameErrors.length > 0) {
                showError(fullName, nameErrors.join('<br>'));
                valid = false;
            } else {
                clearError(fullName);
            }

            // --- Email Validation ---
            const email = $('#email');
            const emailVal = email.val().trim();
            let emailErrors = [];
            const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$/;
            if (!emailVal) {
                emailErrors.push('Email là bắt buộc.');
            }
            if (emailVal && !emailRegex.test(emailVal)) {
                emailErrors.push('Email không đúng định dạng.');
            }
            if (!emailUnique) {
                emailErrors.push('Email đã tồn tại.');
            }
            if (emailErrors.length > 0) {
                showError(email, emailErrors.join('<br>'));
                valid = false;
            } else {
                clearError(email);
            }

            // --- Password Validation ---
            const password = $('#password');
            if (!password.val()) {
                showError(password, 'Mật khẩu là bắt buộc.');
                valid = false;
            } else if (password.val().length < 7) {
                showError(password, 'Mật khẩu phải có ít nhất 7 ký tự.');
                valid = false;
            } else {
                clearError(password);
            }

            // --- Phone Number Validation ---
            const phone = $('#phoneNumber');
            const phoneVal = phone.val().trim();
            let phoneErrors = [];
            if (!phoneVal) {
                phoneErrors.push('Số điện thoại là bắt buộc.');
            }
            if (phoneVal && !/^0\\d{9}$/.test(phoneVal)) {
                phoneErrors.push('Số điện thoại phải gồm 10 số, bắt đầu bằng số 0.');
            }
            if (!phoneUnique) {
                phoneErrors.push('Số điện thoại đã tồn tại.');
            }
            if (phoneErrors.length > 0) {
                showError(phone, phoneErrors.join('<br>'));
                valid = false;
            } else {
                clearError(phone);
            }

            // --- Birthday Validation ---
            const birthday = $('#birthday');
            if (!birthday.val()) {
                showError(birthday, 'Ngày sinh là bắt buộc.');
                valid = false;
            } else {
                const inputDate = new Date(birthday.val());
                const today = new Date();
                today.setHours(0, 0, 0, 0);
                if (inputDate > today) {
                    showError(birthday, 'Ngày sinh không thể ở trong tương lai.');
                    valid = false;
                } else {
                    clearError(birthday);
                }
            }
            
            // --- Address Validation ---
            const address = $('#address');
            if (!address.val().trim()) {
                showError(address, 'Địa chỉ là bắt buộc.');
                valid = false;
            } else {
                clearError(address);
            }
            
            if (!valid) {
                e.preventDefault();
            }
        });
    });
    
    document.addEventListener('DOMContentLoaded', () => {
        if(window.lucide) {
            lucide.createIcons();
        }
    });
    </script>
</body>
</html>
