<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Lại Mật Khẩu - Admin Dashboard</title>

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
                    <h1 class="text-3xl font-serif text-spa-dark font-bold">Đặt Lại Mật Khẩu</h1>
                    <div class="flex gap-2">
                        <a href="${pageContext.request.contextPath}/admin/customer-account/list" 
                           class="px-4 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors">
                            <i data-lucide="arrow-left" class="w-4 h-4 inline mr-2"></i>
                            Quay lại danh sách
                        </a>
                    </div>
                </div>

                <!-- Success/Error Messages -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="mb-6 p-4 bg-green-50 border border-green-200 rounded-lg">
                        <div class="flex items-center">
                            <i data-lucide="check-circle" class="w-5 h-5 text-green-600 mr-2"></i>
                            <span class="text-green-700">${sessionScope.successMessage}</span>
                        </div>
                    </div>
                    <c:remove var="successMessage" scope="session"/>
                </c:if>

                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg">
                        <div class="flex items-center">
                            <i data-lucide="alert-circle" class="w-5 h-5 text-red-600 mr-2"></i>
                            <span class="text-red-700">${sessionScope.errorMessage}</span>
                        </div>
                    </div>
                    <c:remove var="errorMessage" scope="session"/>
                </c:if>

                <!-- Statistics Cards -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                    <div class="bg-white rounded-lg shadow-md p-6">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">Tài khoản bị khóa</p>
                                <p class="text-2xl font-bold text-red-600">${inactiveAccounts}</p>
                            </div>
                            <div class="bg-red-100 p-3 rounded-full">
                                <i data-lucide="user-x" class="w-6 h-6 text-red-600"></i>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-lg shadow-md p-6">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">Email chưa xác thực</p>
                                <p class="text-2xl font-bold text-orange-600">${unverifiedAccounts}</p>
                            </div>
                            <div class="bg-orange-100 p-3 rounded-full">
                                <i data-lucide="mail-x" class="w-6 h-6 text-orange-600"></i>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-lg shadow-md p-6">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">Cần reset password</p>
                                <p class="text-2xl font-bold text-yellow-600">${totalCustomers}</p>
                            </div>
                            <div class="bg-yellow-100 p-3 rounded-full">
                                <i data-lucide="key" class="w-6 h-6 text-yellow-600"></i>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-lg shadow-md p-6">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-medium text-gray-600">Hiển thị trang</p>
                                <p class="text-2xl font-bold text-blue-600">${currentPage}/${totalPages}</p>
                            </div>
                            <div class="bg-blue-100 p-3 rounded-full">
                                <i data-lucide="file-text" class="w-6 h-6 text-blue-600"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Search and Filter -->
                <div class="bg-white rounded-lg shadow-md p-6 mb-8">
                    <form method="GET" action="${pageContext.request.contextPath}/admin/customer-account/reset-password" class="space-y-4">
                        <div class="flex flex-wrap gap-4">
                            <div class="flex-1 min-w-64">
                                <label for="searchValue" class="block text-sm font-medium text-gray-700 mb-2">
                                    Tìm kiếm khách hàng
                                </label>
                                <input type="text" 
                                       id="searchValue" 
                                       name="searchValue" 
                                       value="${searchValue}"
                                       placeholder="Tên, email, số điện thoại..."
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary">
                            </div>
                            
                            <div class="flex items-end">
                                <button type="submit" 
                                        class="px-6 py-2 bg-primary text-white rounded-md hover:bg-primary-dark transition-colors">
                                    <i data-lucide="search" class="w-4 h-4 inline mr-2"></i>
                                    Tìm kiếm
                                </button>
                            </div>

                            <div class="flex items-end">
                                <a href="${pageContext.request.contextPath}/admin/customer-account/reset-password" 
                                   class="px-6 py-2 bg-gray-500 text-white rounded-md hover:bg-gray-600 transition-colors">
                                    <i data-lucide="refresh-cw" class="w-4 h-4 inline mr-2"></i>
                                    Làm mới
                                </a>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Customer List -->
                <div class="bg-white rounded-lg shadow-md overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-200">
                        <h3 class="text-lg font-semibold text-gray-900">
                            Danh sách tài khoản cần đặt lại mật khẩu
                            <span class="text-sm font-normal text-gray-500 ml-2">
                                (${startItem}-${endItem} trên ${totalCustomers} tài khoản)
                            </span>
                        </h3>
                    </div>

                    <c:choose>
                        <c:when test="${empty customers}">
                            <div class="p-8 text-center">
                                <i data-lucide="users" class="w-16 h-16 text-gray-400 mx-auto mb-4"></i>
                                <h3 class="text-lg font-medium text-gray-900 mb-2">Không có tài khoản cần reset</h3>
                                <p class="text-gray-500">Hiện tại không có tài khoản khách hàng nào cần đặt lại mật khẩu.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="overflow-x-auto">
                                <table class="w-full">
                                    <thead class="bg-gray-50">
                                        <tr>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Thông tin</th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Liên hệ</th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Trạng thái</th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Lý do cần reset</th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody class="bg-white divide-y divide-gray-200">
                                        <c:forEach var="customer" items="${customers}">
                                            <tr class="hover:bg-gray-50">
                                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                                    #${customer.customerId}
                                                </td>
                                                
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <div class="flex items-center">
                                                        <div class="ml-4">
                                                            <div class="text-sm font-medium text-gray-900">${customer.fullName}</div>
                                                            <div class="text-sm text-gray-500">
                                                                <fmt:formatDate value="${customer.createdAt}" pattern="dd/MM/yyyy"/>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                                
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <div class="text-sm text-gray-900">${customer.email}</div>
                                                    <div class="text-sm text-gray-500">${customer.phoneNumber}</div>
                                                </td>
                                                
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <div class="flex flex-col space-y-1">
                                                        <c:choose>
                                                            <c:when test="${customer.isActive}">
                                                                <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800">
                                                                    Hoạt động
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-800">
                                                                    Bị khóa
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        
                                                        <c:choose>
                                                            <c:when test="${customer.isVerified}">
                                                                <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-blue-100 text-blue-800">
                                                                    Đã xác thực
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-orange-100 text-orange-800">
                                                                    Chưa xác thực
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                                
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                    <div class="flex flex-col space-y-1">
                                                        <c:if test="${!customer.isActive}">
                                                            <span class="text-red-600">• Tài khoản bị khóa</span>
                                                        </c:if>
                                                        <c:if test="${!customer.isVerified}">
                                                            <span class="text-orange-600">• Email chưa xác thực</span>
                                                        </c:if>
                                                    </div>
                                                </td>
                                                
                                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                                    <div class="flex space-x-2">
                                                        <form method="POST" action="${pageContext.request.contextPath}/admin/customer-account/quick-reset-password" class="inline">
                                                            <input type="hidden" name="id" value="${customer.customerId}">
                                                            <button type="submit" 
                                                                    class="text-yellow-600 hover:text-yellow-900 bg-yellow-100 hover:bg-yellow-200 px-3 py-1 rounded transition-colors"
                                                                    onclick="return confirm('Bạn có chắc muốn đặt lại mật khẩu cho khách hàng này?')">
                                                                <i data-lucide="key" class="w-4 h-4 inline mr-1"></i>
                                                                Reset
                                                            </button>
                                                        </form>
                                                        
                                                        <c:if test="${!customer.isActive}">
                                                            <form method="POST" action="${pageContext.request.contextPath}/admin/customer-account/activate" class="inline">
                                                                <input type="hidden" name="id" value="${customer.customerId}">
                                                                <button type="submit" 
                                                                        class="text-green-600 hover:text-green-900 bg-green-100 hover:bg-green-200 px-3 py-1 rounded transition-colors"
                                                                        onclick="return confirm('Bạn có chắc muốn kích hoạt tài khoản này?')">
                                                                    <i data-lucide="user-check" class="w-4 h-4 inline mr-1"></i>
                                                                    Kích hoạt
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                        
                                                        <c:if test="${!customer.isVerified}">
                                                            <form method="POST" action="${pageContext.request.contextPath}/admin/customer-account/verify" class="inline">
                                                                <input type="hidden" name="id" value="${customer.customerId}">
                                                                <button type="submit" 
                                                                        class="text-blue-600 hover:text-blue-900 bg-blue-100 hover:bg-blue-200 px-3 py-1 rounded transition-colors"
                                                                        onclick="return confirm('Bạn có chắc muốn xác thực email cho khách hàng này?')">
                                                                    <i data-lucide="mail-check" class="w-4 h-4 inline mr-1"></i>
                                                                    Xác thực
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Pagination -->
                            <div class="bg-white px-4 py-3 border-t border-gray-200 sm:px-6">
                                <div class="flex items-center justify-between">
                                    <div class="flex-1 flex justify-between sm:hidden">
                                        <c:if test="${currentPage > 1}">
                                            <a href="?page=${currentPage - 1}&searchValue=${searchValue}" 
                                               class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                                                Trước
                                            </a>
                                        </c:if>
                                        <c:if test="${currentPage < totalPages}">
                                            <a href="?page=${currentPage + 1}&searchValue=${searchValue}" 
                                               class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                                                Sau
                                            </a>
                                        </c:if>
                                    </div>
                                    
                                    <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
                                        <div>
                                            <p class="text-sm text-gray-700">
                                                Hiển thị <span class="font-medium">${startItem}</span> đến <span class="font-medium">${endItem}</span>
                                                trên <span class="font-medium">${totalCustomers}</span> kết quả
                                            </p>
                                        </div>
                                        <div>
                                            <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px">
                                                <c:if test="${currentPage > 1}">
                                                    <a href="?page=${currentPage - 1}&searchValue=${searchValue}" 
                                                       class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                                        <i data-lucide="chevron-left" class="w-5 h-5"></i>
                                                    </a>
                                                </c:if>

                                                <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                                    <c:choose>
                                                        <c:when test="${pageNum == currentPage}">
                                                            <span class="relative inline-flex items-center px-4 py-2 border border-primary bg-primary text-sm font-medium text-white">
                                                                ${pageNum}
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="?page=${pageNum}&searchValue=${searchValue}" 
                                                               class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50">
                                                                ${pageNum}
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>

                                                <c:if test="${currentPage < totalPages}">
                                                    <a href="?page=${currentPage + 1}&searchValue=${searchValue}" 
                                                       class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                                        <i data-lucide="chevron-right" class="w-5 h-5"></i>
                                                    </a>
                                                </c:if>
                                            </nav>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>

    <script>
        lucide.createIcons();
    </script>
</body>
</html> 