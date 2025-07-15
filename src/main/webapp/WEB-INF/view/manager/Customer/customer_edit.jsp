<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Chỉnh Sửa Thông Tin Khách Hàng - ${customer.fullName}</title>

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

                <div class="flex flex-wrap items-center gap-2 mb-8 text-gray-500 text-sm">
                    <a href="${pageContext.request.contextPath}/manager/customer/list" class="flex items-center gap-1 hover:text-primary">
                        <i data-lucide="users" class="w-4 h-4"></i>
                        Danh sách khách hàng
                    </a>
                    <span>-</span>
                    <span class="text-primary font-semibold">Chỉnh sửa thông tin khách hàng</span>
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
                
                <c:if test="${not empty customer}">
                    <div class="bg-white rounded-2xl shadow-lg p-8">
                        <div class="mb-6">
                            <h1 class="text-2xl font-bold text-spa-dark">Chỉnh Sửa Thông Tin Khách Hàng</h1>
                            <p class="text-gray-600 mt-2">Cập nhật thông tin cá nhân và ghi chú khách hàng</p>
                        </div>

                        <form action="${pageContext.request.contextPath}/manager/customer/update" method="post" id="customer-form" novalidate>
                            <input type="hidden" name="customerId" value="${customer.customerId}" />
                            <input type="hidden" name="page" value="${param.page}" />
                            <input type="hidden" name="pageSize" value="${param.pageSize}" />
                            <input type="hidden" name="searchValue" value="${param.searchValue}" />
                            <input type="hidden" name="sortBy" value="${param.sortBy}" />
                            <input type="hidden" name="sortOrder" value="${param.sortOrder}" />

                            <!-- Customer ID & Email Display -->
                            <div class="mb-8 bg-gray-50 rounded-lg p-4">
                                <h2 class="text-lg font-semibold text-spa-dark mb-4 flex items-center gap-2">
                                    <i data-lucide="user-check" class="w-5 h-5"></i> 
                                    Thông tin tài khoản
                                </h2>
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div>
                                        <label class="block font-medium text-gray-700 mb-1">ID Khách hàng</label>
                                        <div class="bg-white border rounded-lg px-3 py-2 text-gray-800 font-medium">#${customer.customerId}</div>
                                    </div>
                                    <div>
                                        <label class="block font-medium text-gray-700 mb-1">Email</label>
                                        <div class="bg-white border rounded-lg px-3 py-2 text-gray-800">${customer.email}</div>
                                    </div>
                                </div>
                                <p class="text-xs text-gray-500 mt-2">
                                    <i data-lucide="info" class="w-3 h-3 inline mr-1"></i>
                                    Thông tin tài khoản chỉ có thể chỉnh sửa bởi Admin
                                </p>
                            </div>

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
                                        <input type="text" name="fullName" id="fullName" value="${customer.fullName}" required 
                                               class="form-input ${not empty errors.fullName ? 'is-invalid' : ''}" />
                                        <div class="invalid-feedback">${errors.fullName}</div>
                                    </div>
                                    <div>
                                        <label for="phoneNumber" class="block font-medium text-gray-700 mb-1">
                                            Số điện thoại <span class="text-red-600">*</span>
                                        </label>
                                        <input type="tel" name="phoneNumber" id="phoneNumber" value="${customer.phoneNumber}" required 
                                               class="form-input ${not empty errors.phoneNumber ? 'is-invalid' : ''}" pattern="^0\d{9}$" />
                                        <div class="invalid-feedback">${errors.phoneNumber}</div>
                                    </div>
                                    <div>
                                        <label for="birthday" class="block font-medium text-gray-700 mb-1">
                                            Ngày sinh <span class="text-red-600">*</span>
                                        </label>
                                        <input type="date" name="birthday" id="birthday" 
                                               value="<fmt:formatDate value='${customer.birthday}' pattern='yyyy-MM-dd' />" 
                                               required class="form-input ${not empty errors.birthday ? 'is-invalid' : ''}" />
                                        <div class="invalid-feedback">${errors.birthday}</div>
                                    </div>
                                    <div>
                                        <label for="gender" class="block font-medium text-gray-700 mb-1">Giới tính</label>
                                        <select name="gender" id="gender" class="form-input">
                                            <option value="Male" ${customer.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                            <option value="Female" ${customer.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                                            <option value="Other" ${customer.gender == 'Other' ? 'selected' : ''}>Khác</option>
                                        </select>
                                    </div>
                                    <div class="md:col-span-2">
                                        <label for="address" class="block font-medium text-gray-700 mb-1">
                                            Địa chỉ <span class="text-red-600">*</span>
                                        </label>
                                        <input type="text" name="address" id="address" value="${customer.address}" required 
                                               class="form-input ${not empty errors.address ? 'is-invalid' : ''}" />
                                        <div class="invalid-feedback">${errors.address}</div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Customer Management -->
                            <div class="mb-8">
                                <h2 class="text-lg font-semibold text-primary mb-4 flex items-center gap-2">
                                    <i data-lucide="settings" class="w-5 h-5"></i> 
                                    Quản lý khách hàng
                                </h2>
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    <div>
                                        <label for="loyaltyPoints" class="block font-medium text-gray-700 mb-1">
                                            Điểm thân thiết
                                        </label>
                                        <input type="number" name="loyaltyPoints" id="loyaltyPoints" 
                                               value="${customer.loyaltyPoints}" min="0" required 
                                               class="form-input ${not empty errors.loyaltyPoints ? 'is-invalid' : ''}" />
                                        <div class="invalid-feedback">${errors.loyaltyPoints}</div>
                                        <div class="text-xs text-gray-500 mt-1">
                                            Điểm thưởng tích lũy của khách hàng
                                        </div>
                                    </div>
                                    <div>
                                        <label class="block font-medium text-gray-700 mb-1">Trạng thái xác thực</label>
                                        <div class="bg-gray-50 border rounded-lg px-3 py-2">
                                            <c:choose>
                                                <c:when test="${customer.isVerified}">
                                                    <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-green-100 text-green-800">
                                                        <i data-lucide="check-circle" class="w-3 h-3 mr-1"></i>
                                                        Đã xác thực email
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-yellow-100 text-yellow-800">
                                                        <i data-lucide="alert-triangle" class="w-3 h-3 mr-1"></i>
                                                        Chưa xác thực email
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="text-xs text-gray-500 mt-1">
                                            Trạng thái xác thực email của khách hàng
                                        </div>
                                    </div>
                                    <div class="md:col-span-2">
                                        <label for="notes" class="block font-medium text-gray-700 mb-1">
                                            Ghi chú của Manager
                                        </label>
                                        <textarea name="notes" id="notes" rows="4" 
                                                  class="form-input" 
                                                  placeholder="Thêm ghi chú về khách hàng: sở thích, lịch sử dịch vụ, yêu cầu đặc biệt...">${customer.notes}</textarea>
                                        <div class="invalid-feedback">${errors.notes}</div>
                                        <div class="text-xs text-gray-500 mt-1">
                                            Ghi chú này sẽ giúp cải thiện dịch vụ chăm sóc khách hàng
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="flex justify-end gap-3 mt-8 pt-6 border-t border-gray-200">
                                <a href="${pageContext.request.contextPath}/manager/customer/list<c:if test='${not empty param.page or not empty param.pageSize or not empty param.searchValue or not empty param.sortBy or not empty param.sortOrder}'>?<c:if test='${not empty param.page}'>page=${param.page}</c:if><c:if test='${not empty param.pageSize}'><c:if test='${not empty param.page}'>&</c:if>pageSize=${param.pageSize}</c:if><c:if test='${not empty param.searchValue}'><c:if test='${not empty param.page or not empty param.pageSize}'>&</c:if>searchValue=${param.searchValue}</c:if><c:if test='${not empty param.sortBy}'><c:if test='${not empty param.page or not empty param.pageSize or not empty param.searchValue}'>&</c:if>sortBy=${param.sortBy}</c:if><c:if test='${not empty param.sortOrder}'><c:if test='${not empty param.page or not empty param.pageSize or not empty param.searchValue or not empty param.sortBy}'>&</c:if>sortOrder=${param.sortOrder}</c:if></c:if>" 
                                   class="inline-flex items-center gap-2 px-6 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition">
                                    <i data-lucide="arrow-left" class="w-5 h-5"></i> 
                                    Hủy và quay lại
                                </a>
                                <button type="submit" 
                                        class="inline-flex items-center gap-2 px-6 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition">
                                    <i data-lucide="save" class="w-5 h-5"></i> 
                                    Cập nhật thông tin
                                </button>
                            </div>
                        </form>
                    </div>
                </c:if>
                
                <c:if test="${empty customer}">
                    <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded-lg" role="alert">
                        <div class="flex items-start gap-3">
                            <i data-lucide="alert-triangle" class="w-5 h-5 mt-0.5"></i>
                            <div>
                                <p class="font-bold">Lỗi!</p>
                                <p>Không tìm thấy thông tin khách hàng để chỉnh sửa. Vui lòng quay lại danh sách.</p>
                            </div>
                        </div>
                    </div>
                </c:if>
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
            
            if (!isValid) {
                e.preventDefault();
                alert('Vui lòng kiểm tra và điền đầy đủ thông tin bắt buộc.');
            }
        });
    </script>
</body>
</html> 