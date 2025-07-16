<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Xác Thực Email - Admin Dashboard</title>

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
</head>

<body class="bg-spa-cream font-sans min-h-screen">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />

    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

        <main class="flex-1 py-12 lg:py-20 ml-64">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">

                <!-- Success/Error/Info Messages -->
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

                <c:if test="${not empty sessionScope.infoMessage}">
                    <div class="bg-blue-100 border-l-4 border-blue-500 text-blue-700 p-4 mb-6 rounded-lg" role="alert">
                        <p>${sessionScope.infoMessage}</p>
                    </div>
                    <c:remove var="infoMessage" scope="session" />
                </c:if>

                <!-- Email Verification Management Card -->
                <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
                    
                    <!-- Card Header with Pagination -->
                    <div class="p-6 border-b border-gray-200 bg-gradient-to-r from-blue-50 to-indigo-50">
                        <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
                            <div>
                                <h1 class="text-2xl font-bold text-spa-dark mb-2">Quản Lý Xác Thực Email</h1>
                                <c:choose>
                                    <c:when test="${pageSize == 9999}">
                                        <p class="text-gray-600">Hiển thị tất cả ${totalRecords} khách hàng chưa xác thực</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-gray-600">Hiển thị ${startItem}-${endItem} của ${totalRecords} khách hàng chưa xác thực</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <!-- Pagination Info -->
                            <c:if test="${pageSize != 9999 && totalPages > 1}">
                                <div class="text-sm text-gray-500">
                                    Trang ${currentPage}/${totalPages}
                                </div>
                            </c:if>
                        </div>

                        <!-- Action Buttons and Search Form -->
                        <div class="mt-4 flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
                            <!-- Verify All Button -->
                            <div class="flex items-center gap-3">
                                <c:if test="${totalRecords > 0}">
                                    <a href="${pageContext.request.contextPath}/admin/customer-account/verify-all" 
                                       class="inline-flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition"
                                       onclick="return confirm('Bạn có chắc muốn xác thực email cho tất cả ${totalRecords} khách hàng chưa xác thực?')">
                                        <i data-lucide="check-circle" class="w-5 h-5"></i>
                                        Xác thực tất cả email
                                    </a>
                                </c:if>
                                
                                <a href="${pageContext.request.contextPath}/admin/customer-account/list" 
                                   class="inline-flex items-center gap-2 px-4 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition">
                                    <i data-lucide="list" class="w-5 h-5"></i>
                                    Danh sách tài khoản
                                </a>
                            </div>

                            <!-- Search and Page Size Form -->
                            <form method="GET" class="flex items-center gap-3">
                                <div class="flex items-center gap-2">
                                    <label class="text-sm text-gray-600">Hiển thị:</label>
                                    <select name="pageSize" onchange="this.form.submit()" class="border border-gray-300 rounded px-2 py-1 text-sm">
                                        <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                                        <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                        <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                        <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                        <option value="9999" ${pageSize == 9999 ? 'selected' : ''}>Tất cả</option>
                                    </select>
                                </div>

                                <div class="flex items-center gap-2">
                                    <input type="text" name="search" value="${param.search}" 
                                           placeholder="Tìm kiếm theo tên, email, điện thoại..." 
                                           class="border border-gray-300 rounded px-3 py-1 text-sm w-64" />
                                    <button type="submit" class="bg-blue-600 text-white px-3 py-1 rounded text-sm hover:bg-blue-700 transition">
                                        <i data-lucide="search" class="w-4 h-4"></i>
                                    </button>
                                    <c:if test="${not empty param.search}">
                                        <a href="?" class="bg-gray-500 text-white px-3 py-1 rounded text-sm hover:bg-gray-600 transition">
                                            <i data-lucide="x" class="w-4 h-4"></i>
                                        </a>
                                    </c:if>
                                </div>

                                <!-- Hidden inputs to preserve other parameters -->
                                <input type="hidden" name="sortBy" value="${param.sortBy}" />
                                <input type="hidden" name="sortOrder" value="${param.sortOrder}" />
                            </form>
                        </div>
                    </div>

                    <!-- Table -->
                    <c:choose>
                        <c:when test="${not empty unverifiedCustomers}">
                            <div class="overflow-x-auto">
                                <table class="w-full">
                                    <thead class="bg-gray-50">
                                        <tr>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                <input type="checkbox" id="selectAllUnverified" class="rounded border-gray-300">
                                            </th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                <a href="?search=${param.search}&pageSize=${param.pageSize}&sortBy=id&sortOrder=${param.sortBy == 'id' && param.sortOrder == 'asc' ? 'desc' : 'asc'}" 
                                                   class="flex items-center gap-1 hover:text-gray-700">
                                                    ID
                                                    <c:if test="${param.sortBy == 'id'}">
                                                        <i data-lucide="${param.sortOrder == 'asc' ? 'chevron-up' : 'chevron-down'}" class="w-3 h-3"></i>
                                                    </c:if>
                                                </a>
                                            </th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                <a href="?search=${param.search}&pageSize=${param.pageSize}&sortBy=fullname&sortOrder=${param.sortBy == 'fullname' && param.sortOrder == 'asc' ? 'desc' : 'asc'}" 
                                                   class="flex items-center gap-1 hover:text-gray-700">
                                                    Khách hàng
                                                    <c:if test="${param.sortBy == 'fullname'}">
                                                        <i data-lucide="${param.sortOrder == 'asc' ? 'chevron-up' : 'chevron-down'}" class="w-3 h-3"></i>
                                                    </c:if>
                                                </a>
                                            </th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                <a href="?search=${param.search}&pageSize=${param.pageSize}&sortBy=email&sortOrder=${param.sortBy == 'email' && param.sortOrder == 'asc' ? 'desc' : 'asc'}" 
                                                   class="flex items-center gap-1 hover:text-gray-700">
                                                    Email
                                                    <c:if test="${param.sortBy == 'email'}">
                                                        <i data-lucide="${param.sortOrder == 'asc' ? 'chevron-up' : 'chevron-down'}" class="w-3 h-3"></i>
                                                    </c:if>
                                                </a>
                                            </th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                <a href="?search=${param.search}&pageSize=${param.pageSize}&sortBy=created&sortOrder=${param.sortBy == 'created' && param.sortOrder == 'asc' ? 'desc' : 'asc'}" 
                                                   class="flex items-center gap-1 hover:text-gray-700">
                                                    Ngày đăng ký
                                                    <c:if test="${param.sortBy == 'created'}">
                                                        <i data-lucide="${param.sortOrder == 'asc' ? 'chevron-up' : 'chevron-down'}" class="w-3 h-3"></i>
                                                    </c:if>
                                                </a>
                                            </th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                Trạng thái tài khoản
                                            </th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                Thao tác
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody class="bg-white divide-y divide-gray-200">
                                        <c:forEach var="customer" items="${unverifiedCustomers}">
                                            <tr class="hover:bg-gray-50">
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <input type="checkbox" name="unverifiedIds" value="${customer.customerId}" class="rounded border-gray-300">
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <span class="text-sm font-medium text-gray-900">#${customer.customerId}</span>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <div class="flex items-center">
                                                        <div class="flex-shrink-0 h-10 w-10">
                                                            <div class="h-10 w-10 rounded-full bg-yellow-500 flex items-center justify-center">
                                                                <span class="text-white font-medium">${customer.fullName.substring(0,1).toUpperCase()}</span>
                                                            </div>
                                                        </div>
                                                        <div class="ml-4">
                                                            <div class="text-sm font-medium text-gray-900">${customer.fullName}</div>
                                                            <div class="text-sm text-gray-500">${customer.phoneNumber}</div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <div class="text-sm text-gray-900">${customer.email}</div>
                                                    <div class="text-sm text-yellow-600">
                                                        <i data-lucide="alert-triangle" class="w-3 h-3 inline mr-1"></i>
                                                        Chưa xác thực
                                                    </div>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                    <c:choose>
                                                        <c:when test="${not empty customer.createdAt}">
                                                            ${customer.createdAt.toLocalDate()}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-gray-400">--</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <c:choose>
                                                        <c:when test="${customer.isActive}">
                                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                                <i data-lucide="check-circle" class="w-3 h-3 mr-1"></i>
                                                                Hoạt động
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                                                <i data-lucide="ban" class="w-3 h-3 mr-1"></i>
                                                                Vô hiệu hóa
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                                    <div class="flex space-x-2">
                                                        <a href="${pageContext.request.contextPath}/admin/customer-account/verify?id=${customer.customerId}" 
                                                           class="inline-flex items-center justify-center w-8 h-8 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition"
                                                           title="Xác thực email"
                                                           onclick="return confirm('Bạn có chắc muốn xác thực email cho khách hàng này?')">
                                                            <i data-lucide="mail-check" class="w-4 h-4"></i>
                                                        </a>
                                                        
                                                        <a href="mailto:${customer.email}" 
                                                           class="inline-flex items-center justify-center w-8 h-8 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition"
                                                           title="Gửi email">
                                                            <i data-lucide="mail" class="w-4 h-4"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Bulk Actions -->
                            <div class="px-6 py-4 bg-gray-50 border-t border-gray-200">
                                <form id="bulkVerifyForm" method="POST" action="${pageContext.request.contextPath}/admin/customer-account/bulk-action">
                                    <input type="hidden" name="action" value="verify">
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center gap-4">
                                            <span class="text-sm text-gray-700">Với các mục đã chọn:</span>
                                            <button type="submit" class="bg-blue-600 text-white px-4 py-1 rounded text-sm hover:bg-blue-700 transition flex items-center gap-2">
                                                <i data-lucide="mail-check" class="w-4 h-4"></i>
                                                Xác thực email hàng loạt
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>

                            <!-- Pagination -->
                            <c:if test="${pageSize != 9999 && totalPages > 1}">
                                <div class="px-6 py-4 bg-white border-t border-gray-200">
                                    <div class="flex items-center justify-between">
                                        <div class="flex justify-center flex-1">
                                            <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
                                                <!-- First Page -->
                                                <c:if test="${currentPage > 1}">
                                                    <a href="?page=1&pageSize=${param.pageSize}&search=${param.search}&sortBy=${param.sortBy}&sortOrder=${param.sortOrder}" 
                                                       class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                                        <i data-lucide="chevrons-left" class="w-4 h-4"></i>
                                                    </a>
                                                    <a href="?page=${currentPage - 1}&pageSize=${param.pageSize}&search=${param.search}&sortBy=${param.sortBy}&sortOrder=${param.sortOrder}" 
                                                       class="relative inline-flex items-center px-2 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                                        <i data-lucide="chevron-left" class="w-4 h-4"></i>
                                                    </a>
                                                </c:if>

                                                <!-- Page Numbers -->
                                                <c:forEach begin="${currentPage > 3 ? currentPage - 2 : 1}" 
                                                          end="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}" 
                                                          var="i">
                                                    <c:choose>
                                                        <c:when test="${i == currentPage}">
                                                            <span class="relative inline-flex items-center px-4 py-2 border border-primary bg-primary text-sm font-medium text-white">
                                                                ${i}
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="?page=${i}&pageSize=${param.pageSize}&search=${param.search}&sortBy=${param.sortBy}&sortOrder=${param.sortOrder}" 
                                                               class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50">
                                                                ${i}
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>

                                                <!-- Ellipsis and Last Page -->
                                                <c:if test="${currentPage + 2 < totalPages}">
                                                    <span class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700">...</span>
                                                    <a href="?page=${totalPages}&pageSize=${param.pageSize}&search=${param.search}&sortBy=${param.sortBy}&sortOrder=${param.sortOrder}" 
                                                       class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50">
                                                        ${totalPages}
                                                    </a>
                                                </c:if>

                                                <!-- Next and Last Page -->
                                                <c:if test="${currentPage < totalPages}">
                                                    <a href="?page=${currentPage + 1}&pageSize=${param.pageSize}&search=${param.search}&sortBy=${param.sortBy}&sortOrder=${param.sortOrder}" 
                                                       class="relative inline-flex items-center px-2 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                                        <i data-lucide="chevron-right" class="w-4 h-4"></i>
                                                    </a>
                                                    <a href="?page=${totalPages}&pageSize=${param.pageSize}&search=${param.search}&sortBy=${param.sortBy}&sortOrder=${param.sortOrder}" 
                                                       class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                                        <i data-lucide="chevrons-right" class="w-4 h-4"></i>
                                                    </a>
                                                </c:if>
                                            </nav>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                        </c:when>
                        <c:otherwise>
                            <div class="px-6 py-12 text-center text-gray-500">
                                <i data-lucide="mail-check" class="w-12 h-12 mx-auto mb-4 text-gray-300"></i>
                                <p class="text-lg">Tất cả khách hàng đã xác thực email</p>
                                <p class="text-sm">Không có khách hàng nào cần xác thực email</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Instructions Card (Optional) -->
                <c:if test="${totalRecords > 0}">
                    <div class="bg-white rounded-2xl shadow-lg p-6 mt-8">
                        <h3 class="text-xl font-semibold text-spa-dark mb-6">Hướng Dẫn Xác Thực Email</h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div class="space-y-4">
                                <h4 class="font-medium text-gray-900">Xác thực từng cá nhân</h4>
                                <div class="space-y-3 text-sm text-gray-600">
                                    <div class="flex items-start gap-3">
                                        <div class="flex-shrink-0 w-6 h-6 bg-blue-100 rounded-full flex items-center justify-center mt-0.5">
                                            <span class="text-blue-600 text-xs font-medium">1</span>
                                        </div>
                                        <p>Nhấn biểu tượng <i data-lucide="mail-check" class="w-3 h-3 inline text-blue-600"></i> để xác thực email riêng lẻ</p>
                                    </div>
                                    <div class="flex items-start gap-3">
                                        <div class="flex-shrink-0 w-6 h-6 bg-blue-100 rounded-full flex items-center justify-center mt-0.5">
                                            <span class="text-blue-600 text-xs font-medium">2</span>
                                        </div>
                                        <p>Sử dụng khi muốn kiểm tra từng khách hàng cụ thể</p>
                                    </div>
                                </div>
                            </div>

                            <div class="space-y-4">
                                <h4 class="font-medium text-gray-900">Xác thực hàng loạt</h4>
                                <div class="space-y-3 text-sm text-gray-600">
                                    <div class="flex items-start gap-3">
                                        <div class="flex-shrink-0 w-6 h-6 bg-green-100 rounded-full flex items-center justify-center mt-0.5">
                                            <span class="text-green-600 text-xs font-medium">1</span>
                                        </div>
                                        <p>Chọn checkbox để chọn nhiều khách hàng</p>
                                    </div>
                                    <div class="flex items-start gap-3">
                                        <div class="flex-shrink-0 w-6 h-6 bg-green-100 rounded-full flex items-center justify-center mt-0.5">
                                            <span class="text-green-600 text-xs font-medium">2</span>
                                        </div>
                                        <p>Hoặc sử dụng nút "Xác thực tất cả email" để xử lý toàn bộ</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mt-6 p-4 bg-yellow-50 border border-yellow-200 rounded-lg">
                            <div class="flex items-start gap-3">
                                <i data-lucide="alert-triangle" class="w-5 h-5 text-yellow-600 mt-0.5"></i>
                                <div>
                                    <h5 class="font-medium text-yellow-800">Lưu ý quan trọng</h5>
                                    <p class="text-sm text-yellow-700 mt-1">
                                        Việc xác thực email thủ công chỉ nên thực hiện khi bạn đã xác nhận danh tính của khách hàng qua các kênh khác 
                                        (điện thoại, trực tiếp, v.v.). Điều này đảm bảo tính bảo mật và chính xác của thông tin.
                                    </p>
                                </div>
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
        
        // Select all unverified customers
        document.getElementById('selectAllUnverified').addEventListener('change', function() {
            const checkboxes = document.querySelectorAll('input[name="unverifiedIds"]');
            checkboxes.forEach(checkbox => {
                checkbox.checked = this.checked;
            });
        });
        
        // Bulk verify form submission
        document.getElementById('bulkVerifyForm').addEventListener('submit', function(e) {
            const selectedCheckboxes = document.querySelectorAll('input[name="unverifiedIds"]:checked');
            
            if (selectedCheckboxes.length === 0) {
                e.preventDefault();
                alert('Vui lòng chọn ít nhất một khách hàng để xác thực.');
                return;
            }
            
            if (!confirm(`Bạn có chắc muốn xác thực email cho ${selectedCheckboxes.length} khách hàng đã chọn?`)) {
                e.preventDefault();
            }
        });
    </script>
</body>
</html> 