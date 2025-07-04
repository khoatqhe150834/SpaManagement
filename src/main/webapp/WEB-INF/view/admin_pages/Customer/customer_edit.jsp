<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Chỉnh sửa Khách hàng - Spa Management</title>
    
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
              "spa-gray": "#F3F4F6",
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
                <c:if test="${not empty customer}">
                    <div class="bg-white p-6 md:p-8 rounded-2xl shadow-lg">
                        <div class="mb-6">
                            <h1 class="text-3xl font-serif text-spa-dark font-bold">Chỉnh sửa Thông tin Khách hàng</h1>
                            <p class="text-gray-600 mt-1">Cập nhật chi tiết cho khách hàng <c:out value="${customer.fullName}"/>.</p>
                        </div>
                        <form action="${pageContext.request.contextPath}/customer/update" method="POST" novalidate>
                            <!-- Hidden fields -->
                            <input type="hidden" name="customerId" value="${customer.customerId}">
                            <input type="hidden" name="page" value="${param.page}" />
                            <input type="hidden" name="pageSize" value="${param.pageSize}" />
                            <input type="hidden" name="searchValue" value="${param.searchValue}" />
                            <input type="hidden" name="status" value="${param.status}" />

                            <div class="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-5">
                                <!-- Full Name -->
                                <div>
                                    <label for="fullName" class="block text-sm font-medium text-gray-700 mb-1">Họ và Tên</label>
                                    <input type="text" id="fullName" name="fullName" value="<c:out value="${customer.fullName}"/>" required
                                           class="form-input">
                                    <div class="error-text"></div>
                                </div>

                                <!-- Birthday -->
                                <div>
                                    <label for="birthday" class="block text-sm font-medium text-gray-700 mb-1">Ngày sinh</label>
                                    <input type="date" id="birthday" name="birthday" value="<fmt:formatDate value="${customer.birthday}" pattern="yyyy-MM-dd" />"
                                           class="form-input">
                                    <div class="error-text"></div>
                                </div>

                                <!-- Email -->
                                <div>
                                    <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Địa chỉ Email</label>
                                    <input type="email" id="email" name="email" value="<c:out value="${customer.email}"/>" required
                                           class="form-input">
                                    <div class="error-text"></div>
                                </div>

                                <!-- Phone Number -->
                                <div>
                                    <label for="phoneNumber" class="block text-sm font-medium text-gray-700 mb-1">Số điện thoại</label>
                                    <input type="tel" id="phoneNumber" name="phoneNumber" value="<c:out value="${customer.phoneNumber}"/>"
                                           class="form-input">
                                    <div class="error-text"></div>
                                </div>

                                <!-- Gender -->
                                <div>
                                    <label for="gender" class="block text-sm font-medium text-gray-700 mb-1">Giới tính</label>
                                    <select id="gender" name="gender"
                                            class="form-input">
                                        <option value="MALE" ${customer.gender == 'MALE' ? 'selected' : ''}>Nam</option>
                                        <option value="FEMALE" ${customer.gender == 'FEMALE' ? 'selected' : ''}>Nữ</option>
                                        <option value="OTHER" ${customer.gender == 'OTHER' ? 'selected' : ''}>Khác</option>
                                    </select>
                                </div>

                                <!-- Loyalty Points -->
                                <div>
                                    <label for="loyaltyPoints" class="block text-sm font-medium text-gray-700 mb-1">Điểm thân thiết</label>
                                    <input type="number" id="loyaltyPoints" name="loyaltyPoints" value="${customer.loyaltyPoints}" min="0"
                                           class="form-input">
                                </div>
                                
                                <!-- Address -->
                                <div class="md:col-span-2">
                                    <label for="address" class="block text-sm font-medium text-gray-700 mb-1">Địa chỉ</label>
                                    <textarea id="address" name="address" rows="3"
                                              class="form-input"><c:out value="${customer.address}"/></textarea>
                                </div>

                                <!-- Notes -->
                                <div class="md:col-span-2">
                                    <label for="notes" class="block text-sm font-medium text-gray-700 mb-1">Ghi chú</label>
                                    <textarea id="notes" name="notes" rows="3" maxlength="500"
                                              class="form-input"><c:out value="${customer.notes}"/></textarea>
                                    <div class="error-text"></div>
                                </div>
                                
                                <!-- Status Switches -->
                                <div class="md:col-span-2 grid grid-cols-1 sm:grid-cols-2 gap-4 mt-2">
                                    <div class="flex items-center p-3 border border-gray-200 rounded-md">
                                        <input id="isActive" name="active" type="checkbox" class="h-4 w-4 text-primary focus:ring-primary border-gray-300 rounded" ${customer.active ? 'checked' : ''}>
                                        <label for="isActive" class="ml-3 block text-sm font-medium text-gray-700">Tài khoản đang hoạt động</label>
                                    </div>
                                    <div class="flex items-center p-3 border border-gray-200 rounded-md">
                                        <input id="isVerified" name="verified" type="checkbox" class="h-4 w-4 text-primary focus:ring-primary border-gray-300 rounded" ${customer.verified ? 'checked' : ''}>
                                        <label for="isVerified" class="ml-3 block text-sm font-medium text-gray-700">Tài khoản đã xác minh</label>
                                    </div>
                                </div>
                            </div>

                            <div class="mt-8 flex justify-end gap-3">
                                <a href="${pageContext.request.contextPath}/customer/list" class="px-6 py-2.5 bg-gray-100 text-gray-800 font-semibold rounded-lg hover:bg-gray-200 transition-colors">Hủy</a>
                                <button type="submit" class="px-6 py-2.5 bg-primary text-white font-semibold rounded-lg hover:bg-primary-dark transition-colors">Cập nhật Khách hàng</button>
                            </div>
                        </form>
                    </div>
                </c:if>

                <c:if test="${empty customer}">
                    <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4" role="alert">
                        <p class="font-bold">Lỗi!</p>
                        <p>Không tìm thấy khách hàng để chỉnh sửa. Vui lòng quay lại danh sách.</p>
                    </div>
                </c:if>
            </div>
        </main>
    </div>
      
    <jsp:include page="/WEB-INF/view/common/footer.jsp" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
    $(document).ready(function() {
        let emailUnique = true;
        let phoneUnique = true;
        const initialEmail = $('#email').val().trim();
        const initialPhone = $('#phoneNumber').val().trim();

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
            if (email && email !== initialEmail) {
                $.get('${pageContext.request.contextPath}/api/check-email', { email: email }, function(data) {
                    if (data.exists) {
                        showError($('#email'), 'Email đã tồn tại.');
                        emailUnique = false;
                    } else {
                        clearError($('#email'));
                        emailUnique = true;
                    }
                });
            } else if (email === initialEmail) {
                clearError($('#email'));
                emailUnique = true;
            }
        });

        // AJAX check phone
        $('#phoneNumber').on('blur', function() {
            const phone = $(this).val().trim();
            if (phone && phone !== initialPhone) {
                $.get('${pageContext.request.contextPath}/api/check-phone', { phone: phone }, function(data) {
                    if (data.exists) {
                        showError($('#phoneNumber'), 'Số điện thoại đã tồn tại.');
                        phoneUnique = false;
                    } else {
                        clearError($('#phoneNumber'));
                        phoneUnique = true;
                    }
                });
            } else if (phone === initialPhone) {
                clearError($('#phoneNumber'));
                phoneUnique = true;
            }
        });

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
            const birthdayVal = birthday.val();
            if (birthdayVal) {
                const inputDate = new Date(birthdayVal);
                const today = new Date();
                today.setHours(0,0,0,0);
                if (inputDate > today) {
                    showError(birthday, 'Ngày sinh không được vượt quá ngày hiện tại.');
                    valid = false;
                } else {
                    clearError(birthday);
                }
            } else {
                clearError(birthday);
            }

            // --- Notes Validation ---
            const notes = $('#notes');
            const notesVal = notes.val();
            if (notesVal && notesVal.length > 500) {
                showError(notes, 'Ghi chú tối đa 500 ký tự.');
                valid = false;
            } else {
                clearError(notes);
            }

            if (!valid) {
                e.preventDefault();
            }
        });
    });
    </script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            if(window.lucide) {
                lucide.createIcons();
            }
        });
    </script>
</body>
</html>
