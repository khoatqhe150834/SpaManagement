<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo sử dụng khuyến mãi</title>
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
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
</head>
<body class="bg-spa-cream font-sans min-h-screen">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        <main class="flex-1 py-12 lg:py-20 ml-64">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <!-- Breadcrumb -->
                <div class="flex flex-wrap items-center gap-2 mb-8 text-gray-500 text-sm">
                    <a href="${pageContext.request.contextPath}/promotion/list" class="flex items-center gap-1 hover:text-primary">
                        <i data-lucide="home" class="w-4 h-4"></i>
                        Danh sách khuyến mãi
                    </a>
                    <span>-</span>
                    <a href="${pageContext.request.contextPath}/promotion/view?id=${promotion.promotionId}" class="hover:text-primary">
                        Chi tiết khuyến mãi
                    </a>
                    <span>-</span>
                    <span class="text-primary font-semibold">Báo cáo sử dụng</span>
                </div>

                <!-- Header -->
                <div class="bg-white rounded-2xl shadow-lg mb-8 p-6">
                    <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                        <div>
                            <h1 class="text-2xl font-bold text-spa-dark mb-2">Báo cáo sử dụng khuyến mãi</h1>
                            <div class="flex items-center gap-4 text-sm text-gray-600">
                                <span class="font-medium">${promotion.title}</span>
                                <span class="px-2 py-1 bg-gray-100 rounded">${promotion.promotionCode}</span>
                                <span>Tổng lượt sử dụng: <strong class="text-primary">${totalUsage}</strong></span>
                            </div>
                        </div>
                        <div class="flex gap-2">
                            <a href="${pageContext.request.contextPath}/promotion/view?id=${promotion.promotionId}" 
                               class="inline-flex items-center gap-2 px-4 py-2 bg-gray-500 text-white rounded-lg hover:bg-gray-600 transition-colors">
                                <i data-lucide="arrow-left" class="w-4 h-4"></i>
                                Quay lại
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Usage Report Table -->
                <div class="bg-white rounded-lg shadow-md overflow-hidden">
                    <c:choose>
                        <c:when test="${not empty usageReportData}">
                            <div class="px-6 py-4 border-b border-gray-200">
                                <h3 class="text-lg font-semibold text-gray-900">
                                    Danh sách khách hàng đã sử dụng
                                    <span class="text-sm font-normal text-gray-500 ml-2">
                                        (${fn:length(usageReportData)} bản ghi trên trang ${currentPage}/${totalPages})
                                    </span>
                                </h3>
                            </div>

                            <div class="overflow-x-auto">
                                <table class="w-full">
                                    <thead class="bg-gray-50">
                                        <tr>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                Khách hàng
                                            </th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                Liên hệ
                                            </th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                Số tiền gốc
                                            </th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                Giảm giá
                                            </th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                Số tiền cuối
                                            </th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                Thời gian sử dụng
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody class="bg-white divide-y divide-gray-200">
                                        <c:forEach var="usage" items="${usageReportData}">
                                            <tr class="hover:bg-gray-50">
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <div class="flex items-center">
                                                        <div class="h-10 w-10 flex-shrink-0 bg-primary rounded-full flex items-center justify-center text-white font-semibold">
                                                            ${fn:substring(usage.customerName, 0, 1)}
                                                        </div>
                                                        <div class="ml-4">
                                                            <div class="text-sm font-medium text-gray-900">${usage.customerName}</div>
                                                            <div class="text-sm text-gray-500">ID: ${usage.customerId}</div>
                                                        </div>
                                                    </div>
                                                </td>
                                                
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <div class="text-sm text-gray-900">${usage.customerEmail}</div>
                                                    <div class="text-sm text-gray-500">${usage.customerPhone}</div>
                                                </td>
                                                
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                                    <fmt:formatNumber value="${usage.originalAmount}" type="currency" currencySymbol="₫"/>
                                                </td>
                                                
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                        -<fmt:formatNumber value="${usage.discountAmount}" type="currency" currencySymbol="₫"/>
                                                    </span>
                                                </td>
                                                
                                                <td class="px-6 py-4 whitespace-nowrap text-sm font-semibold text-gray-900">
                                                    <fmt:formatNumber value="${usage.finalAmount}" type="currency" currencySymbol="₫"/>
                                                </td>
                                                
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                    <fmt:formatDate value="${usage.usedAt}" pattern="dd/MM/yyyy HH:mm"/>
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
                                            <a href="?id=${promotion.promotionId}&page=${currentPage - 1}&pageSize=${pageSize}" 
                                               class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                                                Trước
                                            </a>
                                        </c:if>
                                        <c:if test="${currentPage < totalPages}">
                                            <a href="?id=${promotion.promotionId}&page=${currentPage + 1}&pageSize=${pageSize}" 
                                               class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                                                Sau
                                            </a>
                                        </c:if>
                                    </div>
                                    
                                    <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
                                        <div>
                                            <p class="text-sm text-gray-700">
                                                Hiển thị <span class="font-medium">${(currentPage - 1) * pageSize + 1}</span> 
                                                đến <span class="font-medium">${currentPage * pageSize > totalUsage ? totalUsage : currentPage * pageSize}</span>
                                                trên <span class="font-medium">${totalUsage}</span> kết quả
                                            </p>
                                        </div>
                                        <div>
                                            <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px">
                                                <c:if test="${currentPage > 1}">
                                                    <a href="?id=${promotion.promotionId}&page=${currentPage - 1}&pageSize=${pageSize}" 
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
                                                            <a href="?id=${promotion.promotionId}&page=${pageNum}&pageSize=${pageSize}" 
                                                               class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50">
                                                                ${pageNum}
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>

                                                <c:if test="${currentPage < totalPages}">
                                                    <a href="?id=${promotion.promotionId}&page=${currentPage + 1}&pageSize=${pageSize}" 
                                                       class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                                        <i data-lucide="chevron-right" class="w-5 h-5"></i>
                                                    </a>
                                                </c:if>
                                            </nav>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="p-8 text-center">
                                <i data-lucide="users" class="w-16 h-16 text-gray-400 mx-auto mb-4"></i>
                                <h3 class="text-lg font-medium text-gray-900 mb-2">Chưa có khách hàng sử dụng</h3>
                                <p class="text-gray-500">Khuyến mãi này chưa được khách hàng nào sử dụng.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
    
    <script>
        if (window.lucide) lucide.createIcons();
    </script>
</body>
</html> 
 
 