<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khuyến Mãi Của Tôi - Spa Hương Sen</title>
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
<body class="bg-spa-cream font-sans">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Breadcrumb -->
        <nav class="flex mb-8" aria-label="Breadcrumb">
            <ol class="inline-flex items-center space-x-1 md:space-x-3">
                <li class="inline-flex items-center">
                    <a href="${pageContext.request.contextPath}/" class="inline-flex items-center text-sm font-medium text-gray-700 hover:text-primary">
                        <i data-lucide="home" class="w-4 h-4 mr-2"></i>
                        Trang chủ
                    </a>
                </li>
                <li>
                    <div class="flex items-center">
                        <i data-lucide="chevron-right" class="w-4 h-4 text-gray-400"></i>
                        <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2">Khuyến mãi của tôi</span>
                    </div>
                </li>
            </ol>
        </nav>
        <!-- Page Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-serif text-spa-dark font-bold mb-2">Khuyến Mãi Của Tôi</h1>
            <p class="text-gray-600">Xem các mã khuyến mãi bạn có thể sử dụng và lịch sử đã dùng</p>
        </div>
        <!-- Danh sách mã khuyến mãi còn dùng được -->
        <div class="bg-white rounded-2xl shadow-lg overflow-hidden mb-8">
            <div class="px-6 py-4 border-b border-gray-200">
                <h2 class="text-xl font-bold text-green-700 flex items-center gap-2">
                    <i data-lucide="gift" class="w-6 h-6 text-green-600"></i>
                    Khuyến mãi có thể sử dụng
                </h2>
            </div>
            <c:choose>
                <c:when test="${not empty customerPromotions}">
                    <div class="divide-y divide-gray-200">
                        <c:forEach var="promotion" items="${customerPromotions}">
                            <div class="p-6 hover:bg-gray-50 transition-colors">
                                <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
                                    <div class="flex-1">
                                        <div class="flex items-start justify-between mb-3">
                                            <div>
                                                <h3 class="text-lg font-semibold text-gray-900 mb-1">${promotion.title}</h3>
                                                <p class="text-sm text-gray-600 mb-2">
                                                    Mã: <span class="font-mono bg-gray-100 px-2 py-1 rounded text-primary">${promotion.promotionCode}</span>
                                                </p>
                                            </div>
                                            <!-- Badge trạng thái -->
                                            <div>
                                                <c:choose>
                                                    <c:when test="${promotion.usageLimitPerCustomer == 0 || promotion.remainingCount == null}">
                                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                                            <i data-lucide="infinity" class="w-3 h-3 mr-1"></i>
                                                            Không giới hạn
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${promotion.remainingCount > 0}">
                                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                            <i data-lucide="check-circle" class="w-3 h-3 mr-1"></i>
                                                            Còn ${promotion.remainingCount} lượt
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                                            <i data-lucide="x-circle" class="w-3 h-3 mr-1"></i>
                                                            Đã hết lượt
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="flex items-center gap-6 mb-3">
                                            <div class="flex items-center gap-2">
                                                <i data-lucide="percent" class="w-4 h-4 text-primary"></i>
                                                <span class="text-sm text-gray-700">
                                                    <c:choose>
                                                        <c:when test="${promotion.discountType == 'PERCENTAGE'}">
                                                            Giảm ${promotion.discountValue}%
                                                        </c:when>
                                                        <c:when test="${promotion.discountType == 'FIXED_AMOUNT'}">
                                                            Giảm <fmt:formatNumber value="${promotion.discountValue}" type="currency" currencySymbol="₫"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${promotion.discountType}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="flex items-center gap-2">
                                                <i data-lucide="calendar" class="w-4 h-4 text-gray-500"></i>
                                                <span class="text-sm text-gray-600">
                                                    Hiệu lực: <c:choose>
                                                        <c:when test="${not empty promotion.startDate}">
                                                            <fmt:formatDate value="${promotion.startDate}" pattern="dd/MM/yyyy"/>
                                                        </c:when>
                                                        <c:otherwise>Chưa xác định</c:otherwise>
                                                    </c:choose>
                                                    -
                                                    <c:choose>
                                                        <c:when test="${not empty promotion.endDate}">
                                                            <fmt:formatDate value="${promotion.endDate}" pattern="dd/MM/yyyy"/>
                                                        </c:when>
                                                        <c:otherwise>Chưa xác định</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                        </div>
                                        <div class="flex gap-2 mt-2">
                                            <button onclick="copyCode('${promotion.promotionCode}')" 
                                                    class="inline-flex items-center gap-1 px-3 py-2 bg-primary text-white text-sm font-medium rounded-lg hover:bg-primary-dark transition-colors">
                                                <i data-lucide="copy" class="w-4 h-4"></i>
                                                Sao chép mã
                                            </button>
                                            <a href="${pageContext.request.contextPath}/booking" 
                                               class="inline-flex items-center gap-1 px-3 py-2 bg-green-600 text-white text-sm font-medium rounded-lg hover:bg-green-700 transition-colors">
                                                <i data-lucide="shopping-cart" class="w-4 h-4"></i>
                                                Đặt dịch vụ
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="p-8 text-center text-gray-500">Bạn chưa có mã khuyến mãi nào khả dụng.</div>
                </c:otherwise>
            </c:choose>
        </div>
        <!-- Bảng lịch sử sử dụng khuyến mãi -->
        <h2 class="text-xl font-bold mt-8 mb-4">Lịch sử sử dụng khuyến mãi</h2>
        <c:choose>
            <c:when test="${not empty promotionUsageHistory}">
                <table class="table-auto w-full mb-8">
                    <thead>
                        <tr>
                            <th class="px-2 py-1">Mã</th>
                            <th class="px-2 py-1">Tên khuyến mãi</th>
                            <th class="px-2 py-1">Giảm</th>
                            <th class="px-2 py-1">Ngày dùng</th>
                            <th class="px-2 py-1">Số tiền giảm</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="usage" items="${promotionUsageHistory}">
                            <tr>
                                <td class="px-2 py-1 font-mono">${usage.promotionCode != null ? usage.promotionCode : '-'}</td>
                                <td class="px-2 py-1">${usage.promotion != null && usage.promotion.title != null ? usage.promotion.title : '-'}</td>
                                <td class="px-2 py-1">
                                    <c:choose>
                                        <c:when test="${usage.promotion != null && usage.promotion.discountType == 'PERCENTAGE'}">
                                            ${usage.promotion.discountValue}%
                                        </c:when>
                                        <c:when test="${usage.promotion != null && usage.promotion.discountType == 'FIXED_AMOUNT'}">
                                            <fmt:formatNumber value="${usage.promotion.discountValue}" type="currency" currencySymbol="₫"/>
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-2 py-1">
                                    <c:choose>
                                        <c:when test="${not empty usage.usedAt}">
                                            <fmt:formatDate value="${usage.usedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-2 py-1">
                                    <fmt:formatNumber value="${usage.discountAmount}" type="currency" currencySymbol="₫"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="text-gray-500 mb-8">Bạn chưa từng sử dụng mã khuyến mãi nào.</div>
            </c:otherwise>
        </c:choose>
    </div>
    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
    <script>lucide.createIcons();</script>
</body>
</html> 