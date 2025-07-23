<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khuyến Mãi Dành Cho Bạn - Spa Hương Sen</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
</head>
<body class="bg-spa-cream font-sans">
<jsp:include page="/WEB-INF/view/common/header.jsp" />
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
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
                    <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2">Tất cả khuyến mãi</span>
                </div>
            </li>
        </ol>
    </nav>
    <div class="text-center mb-8">
        <h1 class="text-3xl font-serif text-spa-dark font-bold mb-2">Khuyến Mãi Dành Cho Bạn</h1>
        <p class="text-gray-600">Các mã giảm giá bạn có thể sử dụng khi đặt dịch vụ spa</p>
    </div>
    <c:if test="${not empty message}">
        <div class="max-w-4xl mx-auto mb-8">
            <div class="bg-blue-50 border border-blue-200 rounded-xl p-4 flex items-center gap-3">
                <i data-lucide="info" class="w-5 h-5 text-blue-600"></i>
                <span class="text-blue-800">${message}</span>
            </div>
        </div>
    </c:if>
    <div class="max-w-6xl mx-auto">
        <c:choose>
            <c:when test="${not empty availablePromotions}">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <c:forEach var="promotion" items="${availablePromotions}">
                        <div class="bg-white rounded-2xl shadow-lg overflow-hidden hover:shadow-xl transition-shadow duration-300">
                            <div class="bg-gradient-to-r from-primary to-primary-dark text-white p-6 text-center">
                                <h3 class="text-xl font-semibold mb-3">
                                    <c:out value="${promotion.title}" default="Khuyến mãi"/>
                                </h3>
                                <div class="bg-white text-primary px-4 py-2 rounded-full text-sm font-mono font-bold inline-block">
                                    <c:out value="${promotion.promotionCode}" default="N/A"/>
                                </div>
                            </div>
                            <div class="p-6">
                                <div class="text-center mb-4">
                                    <span class="inline-flex items-center gap-2 bg-green-100 text-green-800 px-4 py-2 rounded-full font-semibold">
                                        <i data-lucide="percent" class="w-4 h-4"></i>
                                        <c:choose>
                                            <c:when test="${promotion.discountType == 'PERCENTAGE'}">
                                                Giảm <c:out value="${promotion.discountValue}"/>%
                                            </c:when>
                                            <c:otherwise>
                                                Giảm ₫<fmt:formatNumber value="${promotion.discountValue}" type="currency" currencySymbol=""/>
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <p class="text-gray-600 text-center mb-6">
                                    <c:out value="${promotion.description}" default="Không có mô tả"/>
                                </p>
                                <div class="space-y-3 mb-6">
                                    <h4 class="font-semibold text-gray-900 flex items-center gap-2">
                                        <i data-lucide="list-check" class="w-4 h-4 text-primary"></i>
                                        Điều kiện áp dụng
                                    </h4>
                                    <div class="space-y-2">
                                        <div class="flex items-center gap-2 text-sm text-gray-600">
                                            <i data-lucide="check-circle" class="w-4 h-4 text-green-500"></i>
                                            <span>Đơn hàng tối thiểu: 
                                                <c:choose>
                                                    <c:when test="${promotion.minimumAppointmentValue != null && promotion.minimumAppointmentValue > 0}">
                                                        ₫<fmt:formatNumber value="${promotion.minimumAppointmentValue}" type="currency" currencySymbol=""/>
                                                    </c:when>
                                                    <c:otherwise>Không có</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="flex items-center gap-2 text-sm text-gray-600">
                                            <i data-lucide="calendar" class="w-4 h-4 text-orange-500"></i>
                                            <span>Từ 
                                                <c:choose>
                                                    <c:when test="${not empty promotion.startDate}">
                                                        <fmt:formatDate value="${promotion.startDate}" pattern="dd/MM/yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>Không xác định</c:otherwise>
                                                </c:choose>
                                                đến 
                                                <c:choose>
                                                    <c:when test="${not empty promotion.endDate}">
                                                        <fmt:formatDate value="${promotion.endDate}" pattern="dd/MM/yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>Không xác định</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="flex items-center gap-2 text-sm text-gray-600">
                                            <i data-lucide="repeat" class="w-4 h-4 text-purple-500"></i>
                                            <span>
                                                <c:choose>
                                                    <c:when test="${promotion.usageLimitPerCustomer != null && promotion.usageLimitPerCustomer > 0}">
                                                        Tối đa ${promotion.usageLimitPerCustomer} lần/khách hàng
                                                    </c:when>
                                                    <c:otherwise>
                                                        Không giới hạn số lần
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="flex flex-col sm:flex-row items-center justify-between gap-3 pt-4 border-t border-gray-200">
                                    <c:choose>
                                        <c:when test="${promotion.status == 'ACTIVE'}">
                                            <span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                <i data-lucide="check-circle" class="w-3 h-3"></i>
                                                Có thể sử dụng
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                                                <i data-lucide="clock" class="w-3 h-3"></i>
                                                Sắp áp dụng
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                    <c:if test="${promotion.status == 'ACTIVE'}">
                                        <form action="${pageContext.request.contextPath}/promotions/use-now" method="post" style="display:inline;">
                                            <input type="hidden" name="promotionCode" value="${promotion.promotionCode}" />
                                            <button type="submit" class="inline-flex items-center gap-2 bg-green-600 text-white px-4 py-2 rounded-lg text-sm font-semibold hover:bg-green-700 transition-colors">
                                                <i data-lucide="shopping-cart" class="w-4 h-4"></i>
                                                Dùng ngay
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="max-w-2xl mx-auto text-center py-12">
                    <div class="bg-white rounded-2xl shadow-lg p-8">
                        <i data-lucide="tags" class="w-16 h-16 text-gray-400 mx-auto mb-4"></i>
                        <h3 class="text-xl font-semibold text-gray-900 mb-2">Chưa có khuyến mãi nào</h3>
                        <p class="text-gray-600 mb-6">Hiện tại không có khuyến mãi nào phù hợp với bạn. Hãy quay lại sau nhé!</p>
                        <a href="${pageContext.request.contextPath}/services" 
                           class="inline-flex items-center gap-2 bg-primary text-white px-6 py-3 rounded-lg font-semibold hover:bg-primary-dark transition-colors">
                            <i data-lucide="search" class="w-5 h-5"></i>
                            Xem dịch vụ
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    <div class="max-w-4xl mx-auto mt-12">
        <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
            <div class="bg-gradient-to-r from-blue-50 to-indigo-50 p-6 border-b border-blue-200">
                <h2 class="text-xl font-semibold text-gray-900 flex items-center gap-2">
                    <i data-lucide="help-circle" class="w-6 h-6 text-blue-600"></i>
                    Cách sử dụng mã khuyến mãi
                </h2>
            </div>
            <div class="p-6">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div class="text-center">
                        <div class="w-12 h-12 bg-primary text-white rounded-full flex items-center justify-center mx-auto mb-4">
                            <span class="font-bold text-lg">1</span>
                        </div>
                        <h3 class="font-semibold text-gray-900 mb-2">Chọn dịch vụ spa</h3>
                        <p class="text-gray-600 text-sm">Chọn các dịch vụ spa bạn muốn sử dụng và thêm vào giỏ hàng</p>
                    </div>
                    <div class="text-center">
                        <div class="w-12 h-12 bg-primary text-white rounded-full flex items-center justify-center mx-auto mb-4">
                            <span class="font-bold text-lg">2</span>
                        </div>
                        <h3 class="font-semibold text-gray-900 mb-2">Nhập mã khuyến mãi</h3>
                        <p class="text-gray-600 text-sm">Tại trang thanh toán, nhập mã khuyến mãi vào ô "Mã giảm giá"</p>
                    </div>
                    <div class="text-center">
                        <div class="w-12 h-12 bg-primary text-white rounded-full flex items-center justify-center mx-auto mb-4">
                            <span class="font-bold text-lg">3</span>
                        </div>
                        <h3 class="font-semibold text-gray-900 mb-2">Áp dụng và thanh toán</h3>
                        <p class="text-gray-600 text-sm">Nhấn "Áp dụng" để sử dụng mã giảm giá và hoàn tất thanh toán</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:include page="/WEB-INF/view/common/footer.jsp" />
<script>lucide.createIcons();</script>
</body>
</html> 
