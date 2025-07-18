<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Lại Mật Khẩu Khách Hàng - Dashboard</title>

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

<body class="bg-spa-cream font-sans">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />

    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

        <main class="flex-1 py-12 lg:py-20 ml-64">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                
                <!-- Page Header -->
                <div class="flex flex-wrap items-center justify-between gap-4 mb-8">
                    <div>
                        <h1 class="text-3xl font-serif text-spa-dark font-bold">Đặt Lại Mật Khẩu Khách Hàng</h1>
                        <p class="text-gray-600 mt-2">Quản lý việc đặt lại mật khẩu cho khách hàng</p>
                    </div>
                    <div class="flex gap-2">
                        <a href="${pageContext.request.contextPath}/customer-management/list" 
                           class="inline-flex items-center gap-2 h-10 px-4 bg-blue-100 text-blue-800 font-semibold rounded-lg hover:bg-blue-200 transition-colors">
                            <i data-lucide="arrow-left" class="w-5 h-5"></i>
                            <span class="hidden sm:inline">Quay lại danh sách</span>
                        </a>
                    </div>
                </div>

                <!-- Breadcrumb -->
                <div class="flex flex-wrap items-center gap-2 mb-8 text-gray-500 text-sm">
                    <a href="${pageContext.request.contextPath}/customer-management/list" class="flex items-center gap-1 hover:text-primary">
                        <i data-lucide="users" class="w-4 h-4"></i>
                        Danh sách khách hàng
                    </a>
                    <span>-</span>
                    <span class="text-primary font-semibold">Đặt lại mật khẩu</span>
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

                <!-- Quick Password Reset Form -->
                <div class="bg-white rounded-2xl shadow-lg mb-8">
                    <div class="p-6 border-b border-gray-200">
                        <h2 class="text-xl font-bold text-spa-dark mb-2 flex items-center gap-2">
                            <i data-lucide="key" class="w-5 h-5 text-primary"></i>
                            Đặt Lại Mật Khẩu Nhanh
                        </h2>
                        <p class="text-gray-600">Nhập email để đặt lại mật khẩu cho khách hàng</p>
                    </div>
                    
                    <form action="${pageContext.request.contextPath}/customer-management/reset-password" method="post" class="p-6">
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                            <div class="md:col-span-2">
                                <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
                                    Email khách hàng <span class="text-red-500">*</span>
                                </label>
                                <input type="email" 
                                       id="email" 
                                       name="email" 
                                       class="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-primary focus:border-primary transition-colors"
                                       placeholder="Nhập email khách hàng"
                                       required>
                            </div>
                            
                            <div>
                                <label for="newPassword" class="block text-sm font-medium text-gray-700 mb-2">
                                    Mật khẩu mới <span class="text-red-500">*</span>
                                </label>
                                <div class="relative">
                                    <input type="password" 
                                           id="newPassword" 
                                           name="newPassword" 
                                           class="w-full border border-gray-300 rounded-lg px-3 py-2 pr-10 focus:ring-2 focus:ring-primary focus:border-primary transition-colors"
                                           placeholder="Mật khẩu mới"
                                           required>
                                    <button type="button" 
                                            onclick="generatePassword()"
                                            class="absolute right-2 top-2 p-1 text-gray-400 hover:text-primary"
                                            title="Tạo mật khẩu ngẫu nhiên">
                                        <i data-lucide="refresh-cw" class="w-4 h-4"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mt-4 flex gap-3">
                            <button type="submit" 
                                    class="px-6 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors font-semibold flex items-center gap-2">
                                <i data-lucide="key" class="w-4 h-4"></i>
                                Đặt lại mật khẩu
                            </button>
                            
                            <button type="button" 
                                    onclick="generatePassword()"
                                    class="px-6 py-2 bg-gray-500 text-white rounded-lg hover:bg-gray-600 transition-colors font-semibold flex items-center gap-2">
                                <i data-lucide="shuffle" class="w-4 h-4"></i>
                                Tạo mật khẩu ngẫu nhiên
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Customer List for Password Reset -->
                <div class="bg-white rounded-2xl shadow-lg">
                    <div class="p-6 border-b border-gray-200">
                        <h2 class="text-xl font-bold text-spa-dark mb-4 flex items-center gap-2">
                            <i data-lucide="users" class="w-5 h-5 text-primary"></i>
                            Danh Sách Khách Hàng
                        </h2>
                        
                        <!-- Search Form -->
                        <form method="GET" action="${pageContext.request.contextPath}/customer-management/reset-password" class="flex flex-wrap items-center gap-3 mb-4">
                            <input type="text" 
                                   name="searchValue" 
                                   value="${searchValue}" 
                                   placeholder="Tìm kiếm khách hàng..."
                                   class="flex-1 min-w-64 h-10 px-4 text-base border rounded-lg focus:ring-2 focus:ring-primary focus:border-primary">
                            
                            <select name="pageSize" class="w-auto h-10 pl-3 pr-8 text-base border rounded-lg" onchange="this.form.submit()">
                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                <option value="100" ${pageSize == 100 ? 'selected' : ''}>100</option>
                            </select>
                            
                            <button type="submit" class="h-10 px-6 bg-primary text-white rounded-lg hover:bg-primary-dark font-medium">
                                <i data-lucide="search" class="w-4 h-4 mr-2 inline"></i>
                                Tìm kiếm
                            </button>
                        </form>
                    </div>

                    <!-- Customer Table -->
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        <input type="checkbox" id="selectAll" class="rounded border-gray-300" onchange="toggleAllCheckboxes()">
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Khách hàng
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Email
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Số điện thoại
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Trạng thái
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Hành động
                                    </th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach items="${customers}" var="customer">
                                    <tr class="hover:bg-gray-50">
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <c:if test="${not empty customer.email}">
                                                <input type="checkbox" name="customerIds" value="${customer.customerId}" class="rounded border-gray-300">
                                            </c:if>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="flex items-center">
                                                <div class="h-10 w-10 flex-shrink-0">
                                                    <c:choose>
                                                        <c:when test="${not empty customer.avatarUrl}">
                                                            <img class="h-10 w-10 rounded-full object-cover" src="${customer.avatarUrl}" alt="${customer.fullName}">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="h-10 w-10 rounded-full bg-gray-300 flex items-center justify-center">
                                                                <i data-lucide="user" class="w-5 h-5 text-gray-600"></i>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="ml-4">
                                                    <div class="text-sm font-medium text-gray-900">${customer.fullName}</div>
                                                    <div class="text-sm text-gray-500">ID: ${customer.customerId}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <c:choose>
                                                <c:when test="${not empty customer.email}">
                                                    <div class="text-sm text-gray-900">${customer.email}</div>
                                                    <c:if test="${customer.isVerified}">
                                                        <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                            <i data-lucide="check-circle" class="w-3 h-3 mr-1"></i>
                                                            Đã xác thực
                                                        </span>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-sm text-gray-500 italic">Chưa có email</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                            <c:choose>
                                                <c:when test="${not empty customer.phoneNumber}">
                                                    ${customer.phoneNumber}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-500 italic">Chưa có SĐT</span>
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
                                                        <i data-lucide="x-circle" class="w-3 h-3 mr-1"></i>
                                                        Bị khóa
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                            <div class="flex items-center gap-2">
                                                <c:choose>
                                                    <c:when test="${not empty customer.email}">
                                                        <a href="${pageContext.request.contextPath}/customer-management/quick-reset-password?id=${customer.customerId}" 
                                                           class="text-primary hover:text-primary-dark p-1 rounded" 
                                                           title="Đặt lại mật khẩu"
                                                           onclick="return confirm('Bạn có chắc muốn đặt lại mật khẩu cho khách hàng ${customer.fullName}?')">
                                                            <i data-lucide="key" class="w-4 h-4"></i>
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-400 p-1 rounded" title="Không có email">
                                                            <i data-lucide="key" class="w-4 h-4"></i>
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                                
                                                <a href="${pageContext.request.contextPath}/customer-management/view?id=${customer.customerId}" 
                                                   class="text-blue-600 hover:text-blue-900 p-1 rounded" title="Xem chi tiết">
                                                    <i data-lucide="eye" class="w-4 h-4"></i>
                                                </a>
                                                
                                                <a href="${pageContext.request.contextPath}/customer-management/edit?id=${customer.customerId}" 
                                                   class="text-green-600 hover:text-green-900 p-1 rounded" title="Chỉnh sửa">
                                                    <i data-lucide="edit" class="w-4 h-4"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Bulk Actions -->
                    <div class="p-6 border-t border-gray-200">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center gap-3">
                                <span class="text-sm text-gray-600">Đã chọn: <span id="selectedCount">0</span> khách hàng</span>
                                <button onclick="bulkPasswordReset()" 
                                        class="px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors font-semibold text-sm disabled:opacity-50"
                                        id="bulkResetBtn" disabled>
                                    <i data-lucide="key" class="w-4 h-4 mr-2 inline"></i>
                                    Đặt lại mật khẩu hàng loạt
                                </button>
                            </div>
                            
                            <div class="text-sm text-gray-700">
                                Hiển thị <span class="font-medium">${startItem}</span> đến <span class="font-medium">${endItem}</span> 
                                của <span class="font-medium">${totalCustomers}</span> khách hàng
                            </div>
                        </div>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="px-6 py-4 bg-gray-50 border-t border-gray-200">
                            <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px">
                                <c:if test="${currentPage > 1}">
                                    <a href="?page=${currentPage - 1}&pageSize=${pageSize}&searchValue=${searchValue}" 
                                       class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                        <i data-lucide="chevron-left" class="w-4 h-4"></i>
                                    </a>
                                </c:if>
                                
                                <c:forEach begin="1" end="${totalPages}" var="page">
                                    <c:choose>
                                        <c:when test="${page == currentPage}">
                                            <span class="relative inline-flex items-center px-4 py-2 border border-primary bg-primary text-sm font-medium text-white">
                                                ${page}
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="?page=${page}&pageSize=${pageSize}&searchValue=${searchValue}" 
                                               class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50">
                                                ${page}
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                
                                <c:if test="${currentPage < totalPages}">
                                    <a href="?page=${currentPage + 1}&pageSize=${pageSize}&searchValue=${searchValue}" 
                                       class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                        <i data-lucide="chevron-right" class="w-4 h-4"></i>
                                    </a>
                                </c:if>
                            </nav>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Initialize Lucide icons
        lucide.createIcons();
        
        // Generate random password
        function generatePassword() {
            const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*';
            let password = '';
            for (let i = 0; i < 12; i++) {
                password += chars.charAt(Math.floor(Math.random() * chars.length));
            }
            document.getElementById('newPassword').value = password;
        }
        
        // Toggle all checkboxes
        function toggleAllCheckboxes() {
            const selectAll = document.getElementById('selectAll');
            const checkboxes = document.querySelectorAll('input[name="customerIds"]');
            
            checkboxes.forEach(checkbox => {
                checkbox.checked = selectAll.checked;
            });
            
            updateSelectedCount();
        }
        
        // Update selected count
        function updateSelectedCount() {
            const checkboxes = document.querySelectorAll('input[name="customerIds"]:checked');
            const count = checkboxes.length;
            document.getElementById('selectedCount').textContent = count;
            document.getElementById('bulkResetBtn').disabled = count === 0;
        }
        
        // Bulk password reset
        function bulkPasswordReset() {
            const checkboxes = document.querySelectorAll('input[name="customerIds"]:checked');
            
            if (checkboxes.length === 0) {
                alert('Vui lòng chọn ít nhất một khách hàng.');
                return;
            }
            
            if (confirm(`Bạn có chắc muốn đặt lại mật khẩu cho ${checkboxes.length} khách hàng đã chọn?`)) {
                const customerIds = Array.from(checkboxes).map(cb => cb.value);
                
                // Create form and submit
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/customer-management/bulk-action';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'reset-password';
                form.appendChild(actionInput);
                
                customerIds.forEach(id => {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'customerIds';
                    input.value = id;
                    form.appendChild(input);
                });
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Initialize event listeners
        document.addEventListener('DOMContentLoaded', function() {
            // Add change event listeners to checkboxes
            document.querySelectorAll('input[name="customerIds"]').forEach(checkbox => {
                checkbox.addEventListener('change', updateSelectedCount);
            });
            
            // Initial count update
            updateSelectedCount();
        });
    </script>
</body>
</html> 