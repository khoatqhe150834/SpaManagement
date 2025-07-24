<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Đảm bảo các biến không null để tránh lỗi JSP --%>
<c:set var="currentPage" value="${currentPage != null ? currentPage : 1}" />
<c:set var="pageSize" value="${pageSize != null ? pageSize : 10}" />
<c:set var="totalPages" value="${totalPages != null ? totalPages : 1}" />
<c:set var="search" value="${search != null ? search : ''}" />
<c:set var="tierFilter" value="${tierFilter != null ? tierFilter : ''}" />
<c:set var="sortBy" value="${sortBy != null ? sortBy : ''}" />
<c:set var="sortOrder" value="${sortOrder != null ? sortOrder : 'desc'}" />

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Điểm Thưởng Khách Hàng - Dashboard</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        // Custom theme configuration for Tailwind CSS
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: "#D4AF37", // A rich gold color
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
    <%-- Sidebar --%>
    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        <%-- Main content area --%>
        <main class="flex-1 py-12 lg:py-20 lg:ml-64">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                
                <div class="flex flex-wrap items-center justify-between gap-4 mb-8">
                    <h1 class="text-3xl font-serif text-spa-dark font-bold">Quản lý điểm thưởng khách hàng</h1>
                    <div class="flex gap-2">
                        <a href="${pageContext.request.contextPath}/manager/loyalty-points/sync"
                           class="inline-flex items-center gap-2 h-10 px-4 bg-blue-100 text-blue-800 font-semibold rounded-lg hover:bg-blue-200 transition-colors">
                            <i data-lucide="sync" class="w-5 h-5"></i>
                            <span class="hidden sm:inline">Đồng bộ điểm & hạng</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/manager/loyalty-points/rules"
                           class="inline-flex items-center gap-2 h-10 px-4 bg-green-100 text-green-800 font-semibold rounded-lg hover:bg-green-200 transition-colors">
                            <i data-lucide="scale" class="w-5 h-5"></i>
                            <span class="hidden sm:inline">Quy tắc quy đổi</span>
                        </a>
                    </div>
                </div>

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

                <div class="bg-white rounded-2xl shadow-lg">
                    <div class="p-6 border-b border-gray-200">
                        <form method="GET" class="flex flex-wrap items-center gap-3">
                             <input type="text" name="search" value="${search}" placeholder="Tìm tên hoặc email..."
                                   class="h-10 px-4 text-base border rounded-lg focus:shadow-outline flex-1 min-w-64">
                            
                            <select name="tierFilter" class="h-10 pl-3 pr-8 text-base border rounded-lg" onchange="this.form.submit()">
                                <option value="">-- Lọc theo hạng --</option>
                                <option value="Đồng" ${tierFilter == 'Đồng' ? 'selected' : ''}>Đồng</option>
                                <option value="Bạc" ${tierFilter == 'Bạc' ? 'selected' : ''}>Bạc</option>
                                <option value="Vàng" ${tierFilter == 'Vàng' ? 'selected' : ''}>Vàng</option>
                                <option value="Kim Cương" ${tierFilter == 'Kim Cương' ? 'selected' : ''}>Kim Cương</option>
                            </select>

                            <select name="sortBy" class="h-10 pl-3 pr-8 text-base border rounded-lg" onchange="this.form.submit()">
                                <option value="name" ${sortBy == 'name' ? 'selected' : ''}>Tên</option>
                                <option value="email" ${sortBy == 'email' ? 'selected' : ''}>Email</option>
                                <option value="loyaltyPoints" ${sortBy == 'loyaltyPoints' ? 'selected' : ''}>Điểm thưởng</option>
                                <option value="tier" ${sortBy == 'tier' ? 'selected' : ''}>Hạng</option>
                            </select>

                            <select name="sortOrder" class="h-10 pl-3 pr-8 text-base border rounded-lg" onchange="this.form.submit()">
                                <option value="desc" ${sortOrder == 'desc' ? 'selected' : ''}>Giảm dần</option>
                                <option value="asc" ${sortOrder == 'asc' ? 'selected' : ''}>Tăng dần</option>
                            </select>
                            
                            <button type="submit" class="h-10 px-6 bg-primary text-white rounded-lg hover:bg-primary-dark font-medium">
                                <i data-lucide="search" class="w-4 h-4 mr-2 inline"></i>
                                Lọc
                            </button>
                        </form>
                    </div>

                    <!-- Thanh phân trang trên, căn phải -->
                    <div class="p-6 flex flex-wrap items-center justify-end gap-4 mb-4">
                        <form method="get" class="flex items-center gap-2">
                            <label for="pageSize" class="text-sm text-gray-600">Hiển thị</label>
                            <select name="pageSize" id="pageSize" class="h-9 px-2 border rounded-lg" onchange="this.form.submit()">
                                <c:forEach var="size" begin="5" end="30" step="5">
                                    <option value="${size}" ${pageSize == size ? 'selected' : ''}>${size}</option>
                                </c:forEach>
                            </select>
                            <input type="hidden" name="search" value="${search}" />
                            <input type="hidden" name="tierFilter" value="${tierFilter}" />
                            <input type="hidden" name="sortBy" value="${sortBy}" />
                            <input type="hidden" name="sortOrder" value="${sortOrder}" />
                            <button type="submit" class="h-9 px-4 bg-primary text-white rounded-lg hover:bg-primary-dark font-medium">Áp dụng</button>
                        </form>
                        <c:if test="${totalPages > 1}">
                            <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
                                <c:if test="${currentPage > 1}">
                                    <a href="?page=1&pageSize=${pageSize}&search=${search}&tierFilter=${tierFilter}&sortBy=${sortBy}&sortOrder=${sortOrder}"
                                       class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                        <i data-lucide="chevrons-left" class="w-5 h-5"></i>
                                    </a>
                                    <a href="?page=${currentPage - 1}&pageSize=${pageSize}&search=${search}&tierFilter=${tierFilter}&sortBy=${sortBy}&sortOrder=${sortOrder}"
                                       class="relative inline-flex items-center px-2 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                        <i data-lucide="chevron-left" class="w-5 h-5"></i>
                                    </a>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                    <c:choose>
                                        <c:when test="${pageNum == currentPage}">
                                            <span aria-current="page" class="relative inline-flex items-center px-4 py-2 border border-primary bg-primary text-sm font-medium text-white">${pageNum}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="?page=${pageNum}&pageSize=${pageSize}&search=${search}&tierFilter=${tierFilter}&sortBy=${sortBy}&sortOrder=${sortOrder}"
                                               class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50">${pageNum}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="?page=${currentPage + 1}&pageSize=${pageSize}&search=${search}&tierFilter=${tierFilter}&sortBy=${sortBy}&sortOrder=${sortOrder}"
                                       class="relative inline-flex items-center px-2 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                        <i data-lucide="chevron-right" class="w-5 h-5"></i>
                                    </a>
                                    <a href="?page=${totalPages}&pageSize=${pageSize}&search=${search}&tierFilter=${tierFilter}&sortBy=${sortBy}&sortOrder=${sortOrder}"
                                       class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                        <i data-lucide="chevrons-right" class="w-5 h-5"></i>
                                    </a>
                                </c:if>
                            </nav>
                        </c:if>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Thông tin khách hàng</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Điểm thưởng</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Hạng</th>
                                    <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Hành động</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach items="${customers}" var="c">
                                    <tr class="hover:bg-gray-50">
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="flex items-center">
                                                <div class="h-10 w-10 flex-shrink-0 bg-gray-200 rounded-full flex items-center justify-center">
                                                     <i data-lucide="user" class="w-5 h-5 text-gray-600"></i>
                                                </div>
                                                <div class="ml-4">
                                                    <div class="text-sm font-medium text-gray-900">${c.fullName}</div>
                                                    <div class="text-sm text-gray-500">${c.email}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                            <div class="flex items-center font-semibold">
                                                <i data-lucide="gem" class="w-4 h-4 mr-2 text-primary"></i>
                                                <fmt:formatNumber value="${c.loyaltyPoints}" type="number"/>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <c:choose>
                                                <c:when test="${c.tier == 'Kim Cương'}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">Kim Cương</span>
                                                </c:when>
                                                <c:when test="${c.tier == 'Vàng'}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">Vàng</span>
                                                </c:when>
                                                <c:when test="${c.tier == 'Bạc'}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-200 text-gray-800">Bạc</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-orange-100 text-orange-800">Đồng</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                            <div class="flex items-center justify-center gap-2">
                                                <a href="${pageContext.request.contextPath}/manager/loyalty-points/edit?customerId=${c.customerId}"
                                                   class="p-2 bg-yellow-100 hover:bg-yellow-200 text-yellow-700 rounded-full transition-colors" title="Cộng/Trừ điểm">
                                                    <i data-lucide="plus-minus" class="w-5 h-5"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/manager/loyalty-points/history?customerId=${c.customerId}"
                                                   class="p-2 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-full transition-colors" title="Lịch sử điểm">
                                                    <i data-lucide="history" class="w-5 h-5"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Initialize Lucide icons
        lucide.createIcons();
    </script>
</body>
</html>