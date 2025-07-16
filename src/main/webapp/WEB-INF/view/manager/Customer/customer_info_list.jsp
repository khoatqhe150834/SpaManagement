<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Thông Tin Khách Hàng - Manager Dashboard</title>

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
                        <a href="${pageContext.request.contextPath}/manager/customer/create" 
                           class="inline-flex items-center gap-2 h-10 px-4 bg-green-100 text-green-800 font-semibold rounded-lg hover:bg-green-200 transition-colors">
                            <i data-lucide="user-plus" class="w-5 h-5"></i>
                            <span class="hidden sm:inline">Thêm khách hàng</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/manager/customer/loyalty" 
                           class="inline-flex items-center gap-2 h-10 px-4 bg-blue-100 text-blue-800 font-semibold rounded-lg hover:bg-blue-200 transition-colors">
                            <i data-lucide="gift" class="w-5 h-5"></i>
                            <span class="hidden sm:inline">Quản lý điểm thưởng</span>
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
                        <form method="GET" action="${pageContext.request.contextPath}/manager/customer/list" class="flex flex-wrap items-center gap-3 mb-4">
                            <select name="pageSize" class="w-auto h-10 pl-3 pr-8 text-base border rounded-lg" onchange="this.form.submit()">
                                <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                <option value="9999" ${pageSize == 9999 ? 'selected' : ''}>Tất cả</option>
                            </select>
                            <input type="text" name="searchValue" value="${searchValue}" placeholder="Tên, địa chỉ, email..."
                                   class="h-10 px-4 text-base border rounded-lg focus:shadow-outline">
                            <select name="sortBy" class="w-auto h-10 pl-3 pr-8 text-base border rounded-lg">
                                <option value="fullName" ${sortBy == 'fullName' ? 'selected' : ''}>Tên khách hàng</option>
                                <option value="email" ${sortBy == 'email' ? 'selected' : ''}>Email</option>
                                <option value="loyaltyPoints" ${sortBy == 'loyaltyPoints' ? 'selected' : ''}>Điểm thưởng</option>
                                <option value="createdAt" ${sortBy == 'createdAt' ? 'selected' : ''}>Ngày tạo</option>
                            </select>
                            <select name="sortOrder" class="w-auto h-10 pl-3 pr-8 text-base border rounded-lg">
                                <option value="asc" ${sortOrder == 'asc' ? 'selected' : ''}>Tăng dần</option>
                                <option value="desc" ${sortOrder == 'desc' ? 'selected' : ''}>Giảm dần</option>
                            </select>
                            <button type="submit" class="h-10 px-4 bg-primary text-white font-semibold rounded-lg hover:bg-primary-dark transition-colors">
                                Tìm Kiếm
                            </button>
                        </form>

                        <!-- Pagination -->
                        <c:if test="${pageSize != 9999 && totalPages > 1}">
                            <div class="flex items-center justify-between">
                                <span class="text-sm text-gray-700">Hiển thị ${startItem}-${endItem} trong tổng số ${totalRecords} khách hàng</span>
                                <div class="flex">
                                    <ul class="inline-flex -space-x-px">
                                        <li>
                                            <c:choose>
                                                <c:when test="${currentPage == 1}">
                                                    <span class="px-3 py-2 ml-0 leading-tight text-gray-400 bg-white border border-gray-300 rounded-l-lg cursor-not-allowed">&lt;</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <a class="px-3 py-2 ml-0 leading-tight text-gray-500 bg-white border border-gray-300 rounded-l-lg hover:bg-gray-100 hover:text-gray-700" 
                                                       href="?page=${currentPage - 1}&pageSize=${pageSize}&searchValue=${searchValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">&lt;</a>
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
                                                           href="?page=${i}&pageSize=${pageSize}&searchValue=${searchValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">${i}</a>
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
                                                       href="?page=${currentPage + 1}&pageSize=${pageSize}&searchValue=${searchValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">&gt;</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <!-- Table -->
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        ID
                                    </th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Khách hàng
                                    </th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Thông tin liên hệ
                                    </th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Địa chỉ
                                    </th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Điểm thưởng
                                    </th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Ngày tạo
                                    </th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Thao tác
                                    </th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:choose>
                                    <c:when test="${not empty customers}">
                                        <c:forEach var="customer" items="${customers}">
                                            <tr class="hover:bg-gray-50">
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <span class="text-sm font-medium text-gray-900">#${customer.customerId}</span>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <div class="flex items-center">
                                                        <div class="flex-shrink-0 h-10 w-10">
                                                            <div class="h-10 w-10 rounded-full bg-primary flex items-center justify-center">
                                                                <span class="text-white font-medium">${customer.fullName.substring(0,1).toUpperCase()}</span>
                                                            </div>
                                                        </div>
                                                        <div class="ml-4">
                                                            <div class="text-sm font-medium text-gray-900">${customer.fullName}</div>
                                                            <div class="text-sm text-gray-500">
                                                                <c:choose>
                                                                    <c:when test="${customer.isVerified}">
                                                                        <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-green-100 text-green-800">
                                                                            <i data-lucide="check-circle" class="w-3 h-3 mr-1"></i>
                                                                            Đã xác thực
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-yellow-100 text-yellow-800">
                                                                            <i data-lucide="alert-triangle" class="w-3 h-3 mr-1"></i>
                                                                            Chưa xác thực
                                                                        </span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <div class="text-sm text-gray-900">${customer.email}</div>
                                                    <div class="text-sm text-gray-500">${customer.phoneNumber}</div>
                                                </td>
                                                <td class="px-6 py-4">
                                                    <div class="text-sm text-gray-900 max-w-xs truncate">
                                                        <c:choose>
                                                            <c:when test="${not empty customer.address}">
                                                                ${customer.address}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-gray-400">Chưa cập nhật</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <div class="text-sm font-medium text-primary">${customer.loyaltyPoints} điểm</div>
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
                                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                                    <div class="flex space-x-2">
                                                        <a href="${pageContext.request.contextPath}/manager/customer/profile?id=${customer.customerId}&page=${currentPage}&pageSize=${pageSize}<c:if test='${not empty searchValue}'>&searchValue=${searchValue}</c:if><c:if test='${not empty sortBy}'>&sortBy=${sortBy}</c:if><c:if test='${not empty sortOrder}'>&sortOrder=${sortOrder}</c:if>" 
                                                           class="p-2 bg-blue-100 hover:bg-blue-200 text-blue-700 rounded-full" 
                                                           title="Xem chi tiết khách hàng">
                                                            <i data-lucide="eye" class="w-5 h-5"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/manager/customer/edit?id=${customer.customerId}&page=${currentPage}&pageSize=${pageSize}<c:if test='${not empty searchValue}'>&searchValue=${searchValue}</c:if><c:if test='${not empty sortBy}'>&sortBy=${sortBy}</c:if><c:if test='${not empty sortOrder}'>&sortOrder=${sortOrder}</c:if>" 
                                                           class="p-2 bg-green-100 hover:bg-green-200 text-green-700 rounded-full" 
                                                           title="Chỉnh sửa thông tin">
                                                            <i data-lucide="edit" class="w-5 h-5"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" class="px-6 py-12 text-center text-gray-500">
                                                <i data-lucide="users" class="w-12 h-12 mx-auto mb-4 text-gray-300"></i>
                                                <p class="text-lg">Không tìm thấy khách hàng nào</p>
                                                <p class="text-sm">Thử thay đổi điều kiện tìm kiếm của bạn</p>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
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
        
        // Auto submit form when page size changes
        function changePageSize() {
            document.querySelector('form').submit();
        }
    </script>
</body>
</html> 