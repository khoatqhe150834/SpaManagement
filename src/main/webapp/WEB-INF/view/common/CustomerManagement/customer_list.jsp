<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Thông Tin Khách Hàng - Dashboard</title>

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
                    <h1 class="text-3xl font-serif text-spa-dark font-bold">Quản Lý Thông Tin Khách Hàng</h1>
                    <div class="flex gap-2">
                        <a href="${pageContext.request.contextPath}/customer-management/add" 
                           class="inline-flex items-center gap-2 h-10 px-4 bg-green-100 text-green-800 font-semibold rounded-lg hover:bg-green-200 transition-colors">
                            <i data-lucide="user-plus" class="w-5 h-5"></i>
                            <span class="hidden sm:inline">Thêm khách hàng</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/customer-management/reset-password" 
                           class="inline-flex items-center gap-2 h-10 px-4 bg-blue-100 text-blue-800 font-semibold rounded-lg hover:bg-blue-200 transition-colors">
                            <i data-lucide="key" class="w-5 h-5"></i>
                            <span class="hidden sm:inline">Đặt lại mật khẩu</span>
                        </a>
                    </div>
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

                <!-- Statistics Cards -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                    <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm text-gray-600">Tổng khách hàng</p>
                                <p class="text-2xl font-bold text-spa-dark">${totalCustomers}</p>
                            </div>
                            <div class="p-3 bg-blue-100 rounded-lg">
                                <i data-lucide="users" class="w-6 h-6 text-blue-600"></i>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm text-gray-600">Tài khoản hoạt động</p>
                                <p class="text-2xl font-bold text-green-600">${activeAccounts}</p>
                            </div>
                            <div class="p-3 bg-green-100 rounded-lg">
                                <i data-lucide="user-check" class="w-6 h-6 text-green-600"></i>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm text-gray-600">Tài khoản bị khóa</p>
                                <p class="text-2xl font-bold text-red-600">${inactiveAccounts}</p>
                            </div>
                            <div class="p-3 bg-red-100 rounded-lg">
                                <i data-lucide="user-x" class="w-6 h-6 text-red-600"></i>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm text-gray-600">Email đã xác thực</p>
                                <p class="text-2xl font-bold text-purple-600">${verifiedAccounts}</p>
                            </div>
                            <div class="p-3 bg-purple-100 rounded-lg">
                                <i data-lucide="mail-check" class="w-6 h-6 text-purple-600"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Main Content Card -->
                <div class="bg-white rounded-2xl shadow-lg">
                    <!-- Card Header: Filters and Search -->
                    <div class="p-6 border-b border-gray-200">
                        <form method="GET" action="${pageContext.request.contextPath}/customer-management/list" class="flex flex-wrap items-center gap-3 mb-4">
                            <select name="pageSize" class="w-auto h-10 pl-3 pr-8 text-base border rounded-lg" onchange="this.form.submit()">
                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                <option value="100" ${pageSize == 100 ? 'selected' : ''}>100</option>
                            </select>
                            
                            <input type="text" name="searchValue" value="${searchValue}" placeholder="Tìm kiếm khách hàng..."
                                   class="h-10 px-4 text-base border rounded-lg focus:shadow-outline flex-1 min-w-64">
                            
                            <select name="status" class="h-10 pl-3 pr-8 text-base border rounded-lg" onchange="this.form.submit()">
                                <option value="">Tất cả trạng thái</option>
                                <option value="true" ${status == 'true' ? 'selected' : ''}>Đang hoạt động</option>
                                <option value="false" ${status == 'false' ? 'selected' : ''}>Bị khóa</option>
                            </select>
                            
                            <select name="verification" class="h-10 pl-3 pr-8 text-base border rounded-lg" onchange="this.form.submit()">
                                <option value="">Tất cả xác thực</option>
                                <option value="true" ${verification == 'true' ? 'selected' : ''}>Đã xác thực</option>
                                <option value="false" ${verification == 'false' ? 'selected' : ''}>Chưa xác thực</option>
                            </select>
                            
                            <button type="submit" class="h-10 px-6 bg-primary text-white rounded-lg hover:bg-primary-dark font-medium">
                                <i data-lucide="search" class="w-4 h-4 mr-2 inline"></i>
                                Tìm kiếm
                            </button>
                        </form>

                        <!-- Bulk Actions -->
                        <div class="flex items-center gap-3">
                            <button onclick="toggleAllCheckboxes()" class="text-sm text-primary hover:text-primary-dark font-medium">
                                <i data-lucide="check-square" class="w-4 h-4 mr-1 inline"></i>
                                Chọn tất cả
                            </button>
                            
                            <div class="flex gap-2">
                                                        <c:if test="${isAdmin || isManager}">
                            <button onclick="bulkAction('activate')" class="px-3 py-1 bg-green-100 text-green-800 rounded-lg text-sm hover:bg-green-200">
                                Kích hoạt
                            </button>
                            <button onclick="bulkAction('deactivate')" class="px-3 py-1 bg-red-100 text-red-800 rounded-lg text-sm hover:bg-red-200">
                                Khóa tài khoản
                            </button>
                        </c:if>
                                <button onclick="bulkAction('verify')" class="px-3 py-1 bg-blue-100 text-blue-800 rounded-lg text-sm hover:bg-blue-200">
                                    Xác thực email
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Table Content -->
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        <input type="checkbox" id="selectAll" class="rounded border-gray-300">
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        <div class="flex items-center gap-2">
                                            <span>Thông tin khách hàng</span>
                                            <div class="flex flex-col">
                                                <button onclick="sortTable('fullName', 'asc')" class="sort-btn ${sortBy == 'fullName' && sortOrder == 'asc' ? 'text-primary' : 'text-gray-400'} hover:text-primary">
                                                    <i data-lucide="chevron-up" class="w-3 h-3"></i>
                                                </button>
                                                <button onclick="sortTable('fullName', 'desc')" class="sort-btn ${sortBy == 'fullName' && sortOrder == 'desc' ? 'text-primary' : 'text-gray-400'} hover:text-primary">
                                                    <i data-lucide="chevron-down" class="w-3 h-3"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        <div class="flex items-center gap-2">
                                            <span>Liên hệ</span>
                                            <div class="flex flex-col">
                                                <button onclick="sortTable('email', 'asc')" class="sort-btn ${sortBy == 'email' && sortOrder == 'asc' ? 'text-primary' : 'text-gray-400'} hover:text-primary">
                                                    <i data-lucide="chevron-up" class="w-3 h-3"></i>
                                                </button>
                                                <button onclick="sortTable('email', 'desc')" class="sort-btn ${sortBy == 'email' && sortOrder == 'desc' ? 'text-primary' : 'text-gray-400'} hover:text-primary">
                                                    <i data-lucide="chevron-down" class="w-3 h-3"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Trạng thái
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        <div class="flex items-center gap-2">
                                            <span>Điểm tích lũy</span>
                                            <div class="flex flex-col">
                                                <button onclick="sortTable('loyaltyPoints', 'asc')" class="sort-btn ${sortBy == 'loyaltyPoints' && sortOrder == 'asc' ? 'text-primary' : 'text-gray-400'} hover:text-primary">
                                                    <i data-lucide="chevron-up" class="w-3 h-3"></i>
                                                </button>
                                                <button onclick="sortTable('loyaltyPoints', 'desc')" class="sort-btn ${sortBy == 'loyaltyPoints' && sortOrder == 'desc' ? 'text-primary' : 'text-gray-400'} hover:text-primary">
                                                    <i data-lucide="chevron-down" class="w-3 h-3"></i>
                                                </button>
                                            </div>
                                        </div>
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
                                            <input type="checkbox" name="customerIds" value="${customer.customerId}" class="rounded border-gray-300">
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
                                            <div class="text-sm text-gray-900">
                                                <c:if test="${not empty customer.email}">
                                                    <div class="flex items-center">
                                                        <i data-lucide="mail" class="w-4 h-4 mr-2 text-gray-400"></i>
                                                        ${customer.email}
                                                        <c:if test="${customer.isVerified}">
                                                            <i data-lucide="check-circle" class="w-4 h-4 ml-1 text-green-500"></i>
                                                        </c:if>
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty customer.phoneNumber}">
                                                    <div class="flex items-center mt-1">
                                                        <i data-lucide="phone" class="w-4 h-4 mr-2 text-gray-400"></i>
                                                        ${customer.phoneNumber}
                                                    </div>
                                                </c:if>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="flex flex-col gap-1">
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
                                                
                                                <c:if test="${not empty customer.email}">
                                                    <c:choose>
                                                        <c:when test="${customer.isVerified}">
                                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                                                <i data-lucide="mail-check" class="w-3 h-3 mr-1"></i>
                                                                Đã xác thực
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                                                                <i data-lucide="mail-x" class="w-3 h-3 mr-1"></i>
                                                                Chưa xác thực
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                            <div class="flex items-center">
                                                <i data-lucide="gift" class="w-4 h-4 mr-2 text-primary"></i>
                                                <fmt:formatNumber value="${customer.loyaltyPoints}" type="number"/> điểm
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                            <div class="flex items-center gap-2">
                                                <!-- View Details -->
                                                <a href="${pageContext.request.contextPath}/customer-management/view?id=${customer.customerId}" 
                                                   class="text-blue-600 hover:text-blue-900 p-1 rounded" title="Xem chi tiết">
                                                    <i data-lucide="eye" class="w-4 h-4"></i>
                                                </a>
                                                
                                                <!-- Edit -->
                                                <a href="${pageContext.request.contextPath}/customer-management/edit?id=${customer.customerId}" 
                                                   class="text-green-600 hover:text-green-900 p-1 rounded" title="Chỉnh sửa">
                                                    <i data-lucide="edit" class="w-4 h-4"></i>
                                                </a>
                                                
                                                <!-- Quick Actions Dropdown -->
                                                <div class="relative" x-data="{ open: false }">
                                                    <button @click="open = !open" class="text-gray-600 hover:text-gray-900 p-1 rounded" title="Thêm hành động">
                                                        <i data-lucide="more-vertical" class="w-4 h-4"></i>
                                                    </button>
                                                    
                                                    <div x-show="open" @click.away="open = false" 
                                                         class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg z-10 border border-gray-200">
                                                        <div class="py-1">
                                                            <c:if test="${isAdmin || isManager}">
                                                                <c:choose>
                                                                    <c:when test="${customer.isActive}">
                                                                        <a href="${pageContext.request.contextPath}/customer-management/deactivate?id=${customer.customerId}" 
                                                                           class="block px-4 py-2 text-sm text-red-700 hover:bg-red-50" 
                                                                           onclick="return confirm('Bạn có chắc muốn khóa tài khoản này?')">
                                                                            <i data-lucide="user-x" class="w-4 h-4 mr-2 inline"></i>
                                                                            Khóa tài khoản
                                                                        </a>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <a href="${pageContext.request.contextPath}/customer-management/activate?id=${customer.customerId}" 
                                                                           class="block px-4 py-2 text-sm text-green-700 hover:bg-green-50">
                                                                            <i data-lucide="user-check" class="w-4 h-4 mr-2 inline"></i>
                                                                            Kích hoạt tài khoản
                                                                        </a>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:if>
                                                            
                                                            <c:if test="${not empty customer.email}">
                                                                <c:choose>
                                                                    <c:when test="${customer.isVerified}">
                                                                        <a href="${pageContext.request.contextPath}/customer-management/unverify?id=${customer.customerId}" 
                                                                           class="block px-4 py-2 text-sm text-orange-700 hover:bg-orange-50">
                                                                            <i data-lucide="mail-x" class="w-4 h-4 mr-2 inline"></i>
                                                                            Hủy xác thực email
                                                                        </a>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <a href="${pageContext.request.contextPath}/customer-management/verify?id=${customer.customerId}" 
                                                                           class="block px-4 py-2 text-sm text-blue-700 hover:bg-blue-50">
                                                                            <i data-lucide="mail-check" class="w-4 h-4 mr-2 inline"></i>
                                                                            Xác thực email
                                                                        </a>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:if>
                                                            
                                                            <a href="${pageContext.request.contextPath}/customer-management/quick-reset-password?id=${customer.customerId}" 
                                                               class="block px-4 py-2 text-sm text-purple-700 hover:bg-purple-50" 
                                                               onclick="return confirm('Bạn có chắc muốn đặt lại mật khẩu cho khách hàng này?')">
                                                                <i data-lucide="key" class="w-4 h-4 mr-2 inline"></i>
                                                                Đặt lại mật khẩu
                                                            </a>
                                                            
                                                            <c:if test="${isAdmin}">
                                                                <hr class="my-1">
                                                                <form action="${pageContext.request.contextPath}/customer-management/delete" method="post" class="inline">
                                                                    <input type="hidden" name="id" value="${customer.customerId}">
                                                                    <button type="submit" class="block w-full text-left px-4 py-2 text-sm text-red-700 hover:bg-red-50" 
                                                                            onclick="return confirm('Bạn có chắc muốn XÓA VĨNH VIỄN khách hàng này? Hành động này không thể hoàn tác!')">
                                                                        <i data-lucide="trash-2" class="w-4 h-4 mr-2 inline"></i>
                                                                        Xóa khách hàng
                                                                    </button>
                                                                </form>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <div class="px-6 py-4 bg-gray-50 border-t border-gray-200">
                        <div class="flex flex-col sm:flex-row justify-between items-center gap-4">
                            <div class="text-sm text-gray-700">
                                Hiển thị <span class="font-medium">${startItem}</span> đến <span class="font-medium">${endItem}</span> 
                                của <span class="font-medium">${totalCustomers}</span> khách hàng
                            </div>
                            
                            <c:if test="${totalPages > 1}">
                                <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px">
                                    <c:if test="${currentPage > 1}">
                                        <a href="?page=${currentPage - 1}&pageSize=${pageSize}&searchValue=${searchValue}&status=${status}&verification=${verification}&sortBy=${sortBy}&sortOrder=${sortOrder}" 
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
                                                <a href="?page=${page}&pageSize=${pageSize}&searchValue=${searchValue}&status=${status}&verification=${verification}&sortBy=${sortBy}&sortOrder=${sortOrder}" 
                                                   class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50">
                                                    ${page}
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    
                                    <c:if test="${currentPage < totalPages}">
                                        <a href="?page=${currentPage + 1}&pageSize=${pageSize}&searchValue=${searchValue}&status=${status}&verification=${verification}&sortBy=${sortBy}&sortOrder=${sortOrder}" 
                                           class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                            <i data-lucide="chevron-right" class="w-4 h-4"></i>
                                        </a>
                                    </c:if>
                                </nav>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Hidden form for bulk actions -->
    <form id="bulkActionForm" method="POST" action="${pageContext.request.contextPath}/customer-management/bulk-action" style="display: none;">
        <input type="hidden" name="action" id="bulkActionType">
        <div id="bulkActionCustomers"></div>
    </form>

    <script src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <script>
        // Initialize Lucide icons
        lucide.createIcons();
        
        // Toggle all checkboxes
        function toggleAllCheckboxes() {
            const selectAll = document.getElementById('selectAll');
            const checkboxes = document.querySelectorAll('input[name="customerIds"]');
            
            checkboxes.forEach(checkbox => {
                checkbox.checked = selectAll.checked;
            });
        }
        
        // Handle bulk actions
        function bulkAction(actionType) {
            const checkboxes = document.querySelectorAll('input[name="customerIds"]:checked');
            
            if (checkboxes.length === 0) {
                alert('Vui lòng chọn ít nhất một khách hàng.');
                return;
            }
            
            let confirmMessage = '';
            switch (actionType) {
                case 'activate':
                    confirmMessage = 'Bạn có chắc muốn kích hoạt các tài khoản đã chọn?';
                    break;
                case 'deactivate':
                    confirmMessage = 'Bạn có chắc muốn khóa các tài khoản đã chọn?';
                    break;
                case 'verify':
                    confirmMessage = 'Bạn có chắc muốn xác thực email cho các tài khoản đã chọn?';
                    break;
                default:
                    return;
            }
            
            if (confirm(confirmMessage)) {
                document.getElementById('bulkActionType').value = actionType;
                
                const bulkActionCustomers = document.getElementById('bulkActionCustomers');
                bulkActionCustomers.innerHTML = '';
                
                checkboxes.forEach(checkbox => {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'customerIds';
                    input.value = checkbox.value;
                    bulkActionCustomers.appendChild(input);
                });
                
                document.getElementById('bulkActionForm').submit();
            }
        }
        
        // Update select all checkbox state
        document.addEventListener('DOMContentLoaded', function() {
            const selectAll = document.getElementById('selectAll');
            const checkboxes = document.querySelectorAll('input[name="customerIds"]');
            
            selectAll.addEventListener('change', toggleAllCheckboxes);
            
            checkboxes.forEach(checkbox => {
                checkbox.addEventListener('change', function() {
                    const checkedCount = document.querySelectorAll('input[name="customerIds"]:checked').length;
                    selectAll.checked = checkedCount === checkboxes.length;
                    selectAll.indeterminate = checkedCount > 0 && checkedCount < checkboxes.length;
                });
            });
        });
        
        // Sort table function
        function sortTable(sortBy, sortOrder) {
            const currentUrl = new URL(window.location);
            currentUrl.searchParams.set('sortBy', sortBy);
            currentUrl.searchParams.set('sortOrder', sortOrder);
            window.location.href = currentUrl.toString();
        }
    </script>
</body>
</html> 