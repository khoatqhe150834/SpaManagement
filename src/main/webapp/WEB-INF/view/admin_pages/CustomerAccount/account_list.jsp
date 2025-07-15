<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Tài Khoản Khách Hàng - Admin Dashboard</title>

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
                    <h1 class="text-3xl font-serif text-spa-dark font-bold">Quản Lý Tài Khoản Khách Hàng</h1>
                    <div class="flex gap-2">
                        <a href="${pageContext.request.contextPath}/admin/customer-account/status" 
                           class="inline-flex items-center gap-2 h-10 px-4 bg-blue-100 text-blue-800 font-semibold rounded-lg hover:bg-blue-200 transition-colors">
                            <i data-lucide="activity" class="w-5 h-5"></i>
                            <span class="hidden sm:inline">Trạng thái tài khoản</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/customer-account/verification" 
                           class="inline-flex items-center gap-2 h-10 px-4 bg-green-100 text-green-800 font-semibold rounded-lg hover:bg-green-200 transition-colors">
                            <i data-lucide="mail-check" class="w-5 h-5"></i>
                            <span class="hidden sm:inline">Xác thực email</span>
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

                <!-- Card -->
                <div class="bg-white rounded-2xl shadow-lg">
                    <!-- Card Header: Filters, Pagination & Actions -->
                    <div class="p-6 border-b border-gray-200">
                        <!-- Search and Filter Form -->
                        <form method="GET" action="${pageContext.request.contextPath}/admin/customer-account/list" class="flex flex-wrap items-center gap-3 mb-4">
                            <select name="pageSize" class="w-auto h-10 pl-3 pr-8 text-base border rounded-lg" onchange="this.form.submit()">
                                <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                            </select>
                            <input type="text" name="searchValue" value="${searchValue}" placeholder="Email hoặc tên khách hàng..."
                                   class="h-10 px-4 text-base border rounded-lg focus:shadow-outline">
                            <select name="status" class="w-auto h-10 pl-3 pr-8 text-base border rounded-lg">
                                <option value="">Tất cả trạng thái</option>
                                <option value="active" ${status == 'active' ? 'selected' : ''}>Hoạt động</option>
                                <option value="inactive" ${status == 'inactive' ? 'selected' : ''}>Bị khóa</option>
                            </select>
                            <select name="verification" class="w-auto h-10 pl-3 pr-8 text-base border rounded-lg">
                                <option value="">Tất cả xác thực</option>
                                <option value="verified" ${verification == 'verified' ? 'selected' : ''}>Đã xác thực</option>
                                <option value="unverified" ${verification == 'unverified' ? 'selected' : ''}>Chưa xác thực</option>
                            </select>
                            <button type="submit" class="h-10 px-4 bg-primary text-white font-semibold rounded-lg hover:bg-primary-dark transition-colors">
                                Tìm Kiếm
                            </button>
                        </form>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <div class="flex items-center justify-between">
                                <span class="text-sm text-gray-700">Hiển thị ${startItem}-${endItem} trong tổng số ${totalCustomers} tài khoản</span>
                                <div class="flex">
                                    <ul class="inline-flex -space-x-px">
                                        <li>
                                            <c:choose>
                                                <c:when test="${currentPage == 1}">
                                                    <span class="px-3 py-2 ml-0 leading-tight text-gray-400 bg-white border border-gray-300 rounded-l-lg cursor-not-allowed">&lt;</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <a class="px-3 py-2 ml-0 leading-tight text-gray-500 bg-white border border-gray-300 rounded-l-lg hover:bg-gray-100 hover:text-gray-700" 
                                                       href="?page=${currentPage - 1}&pageSize=${pageSize}&searchValue=${searchValue}&status=${status}&verification=${verification}">&lt;</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                        <c:forEach var="i" begin="1" end="${totalPages}">
                                            <li>
                                                <c:choose>
                                                    <c:when test="${i == currentPage}">
                                                        <span class="px-3 py-2 leading-tight text-white bg-primary border border-gray-300">${i}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a class="px-3 py-2 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700" 
                                                           href="?page=${i}&pageSize=${pageSize}&searchValue=${searchValue}&status=${status}&verification=${verification}">${i}</a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </li>
                                        </c:forEach>
                                        <li>
                                            <c:choose>
                                                <c:when test="${currentPage == totalPages}">
                                                    <span class="px-3 py-2 leading-tight text-gray-400 bg-white border border-gray-300 rounded-r-lg cursor-not-allowed">&gt;</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <a class="px-3 py-2 leading-tight text-gray-500 bg-white border border-gray-300 rounded-r-lg hover:bg-gray-100 hover:text-gray-700" 
                                                       href="?page=${currentPage + 1}&pageSize=${pageSize}&searchValue=${searchValue}&status=${status}&verification=${verification}">&gt;</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <!-- Table -->
                    <div class="p-6">
                        <div class="overflow-x-auto">
                            <table class="w-full text-sm text-left text-gray-500">
                                <thead class="text-xs text-gray-700 uppercase bg-gray-50">
                                    <tr>
                                        <th scope="col" class="px-6 py-3">ID</th>
                                        <th scope="col" class="px-6 py-3">Khách hàng</th>
                                        <th scope="col" class="px-6 py-3">Email</th>
                                        <th scope="col" class="px-6 py-3 text-center">Trạng thái</th>
                                        <th scope="col" class="px-6 py-3 text-center">Xác thực</th>
                                        <th scope="col" class="px-6 py-3">Ngày tạo</th>
                                        <th scope="col" class="px-6 py-3 text-center">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="customer" items="${customers}">
                                        <tr class="bg-white border-b hover:bg-gray-50">
                                            <td class="px-6 py-4 font-medium text-gray-900">#${customer.customerId}</td>
                                            <td class="px-6 py-4">
                                                <div class="flex items-center">
                                                    <div class="flex-shrink-0 h-10 w-10">
                                                        <div class="h-10 w-10 rounded-full bg-primary flex items-center justify-center">
                                                            <span class="text-white font-medium">${customer.fullName.substring(0,1).toUpperCase()}</span>
                                                        </div>
                                                    </div>
                                                    <div class="ml-4">
                                                        <div class="text-sm font-medium text-gray-900">${customer.fullName}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="px-6 py-4 max-w-xs truncate" title="${customer.email}">${customer.email}</td>
                                            <td class="px-6 py-4 text-center">
                                                <c:choose>
                                                    <c:when test="${customer.isActive}">
                                                        <span class="bg-green-100 text-green-800 text-xs font-medium px-2.5 py-0.5 rounded-full">Hoạt động</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="bg-red-100 text-red-800 text-xs font-medium px-2.5 py-0.5 rounded-full">Bị khóa</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-4 text-center">
                                                <c:choose>
                                                    <c:when test="${customer.isVerified}">
                                                        <span class="bg-blue-100 text-blue-800 text-xs font-medium px-2.5 py-0.5 rounded-full">Đã xác thực</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="bg-yellow-100 text-yellow-800 text-xs font-medium px-2.5 py-0.5 rounded-full">Chưa xác thực</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-4">
                                                <c:choose>
                                                    <c:when test="${not empty customer.createdAt}">
                                                        ${customer.createdAt.toLocalDate()}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-400">--</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-4 text-center">
                                                <div class="flex items-center justify-center space-x-2">
                                                    <!-- Đặt lại mật khẩu -->
                                                    <a href="${pageContext.request.contextPath}/admin/customer-account/quick-reset-password?id=${customer.customerId}" 
                                                       class="inline-flex items-center justify-center p-2 text-sm text-purple-600 bg-purple-100 hover:bg-purple-200 rounded-md"
                                                       title="Đặt lại mật khẩu"
                                                       onclick="return confirm('Bạn có chắc muốn đặt lại mật khẩu cho khách hàng này?')">
                                                        <i data-lucide="key" class="w-4 h-4"></i>
                                                    </a>
                                                    
                                                    <!-- Quản lý email -->
                                                    <c:choose>
                                                        <c:when test="${customer.isVerified}">
                                                            <a href="${pageContext.request.contextPath}/admin/customer-account/unverify?id=${customer.customerId}" 
                                                               class="inline-flex items-center justify-center p-2 text-sm text-yellow-600 bg-yellow-100 hover:bg-yellow-200 rounded-md"
                                                               title="Hủy xác thực email"
                                                               onclick="return confirm('Bạn có chắc muốn hủy xác thực email?')">
                                                                <i data-lucide="mail-x" class="w-4 h-4"></i>
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/admin/customer-account/verify?id=${customer.customerId}" 
                                                               class="inline-flex items-center justify-center p-2 text-sm text-blue-600 bg-blue-100 hover:bg-blue-200 rounded-md"
                                                               title="Xác thực email"
                                                               onclick="return confirm('Bạn có chắc muốn xác thực email này?')">
                                                                <i data-lucide="mail-check" class="w-4 h-4"></i>
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    
                                                    <!-- Quản lý trạng thái tài khoản -->
                                                    <c:choose>
                                                        <c:when test="${customer.isActive}">
                                                            <a href="${pageContext.request.contextPath}/admin/customer-account/deactivate?id=${customer.customerId}" 
                                                               class="inline-flex items-center justify-center p-2 text-sm text-red-600 bg-red-100 hover:bg-red-200 rounded-md"
                                                               title="Vô hiệu hóa tài khoản"
                                                               onclick="return confirm('Bạn có chắc chắn muốn vô hiệu hóa tài khoản này?')">
                                                                <i data-lucide="ban" class="w-4 h-4"></i>
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/admin/customer-account/activate?id=${customer.customerId}" 
                                                               class="inline-flex items-center justify-center p-2 text-sm text-green-600 bg-green-100 hover:bg-green-200 rounded-md"
                                                               title="Kích hoạt tài khoản"
                                                               onclick="return confirm('Bạn có chắc chắn muốn kích hoạt lại tài khoản này?')">
                                                                <i data-lucide="refresh-ccw" class="w-4 h-4"></i>
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    
                                    <c:if test="${empty customers}">
                                        <tr>
                                            <td colspan="7" class="px-6 py-12 text-center text-gray-500">
                                                <i data-lucide="users" class="w-12 h-12 mx-auto mb-4 text-gray-300"></i>
                                                <p class="text-lg">Không tìm thấy tài khoản khách hàng nào</p>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
    
    <script>
        if (window.lucide) {
            lucide.createIcons();
        }
    </script>
</body>
</html> 