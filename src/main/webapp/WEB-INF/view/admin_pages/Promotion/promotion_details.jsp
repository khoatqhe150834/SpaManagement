<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Promotion, java.time.format.DateTimeFormatter, java.text.NumberFormat, java.util.Locale" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết khuyến mãi</title>
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
            <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex flex-wrap items-center gap-2 mb-8 text-gray-500 text-sm">
                    <a href="${pageContext.request.contextPath}/promotion/list" class="flex items-center gap-1 hover:text-primary">
                        <i data-lucide="home" class="w-4 h-4"></i>
                        Danh sách khuyến mãi
                    </a>
                    <span>-</span>
                    <span class="text-primary font-semibold">Chi tiết khuyến mãi</span>
                </div>

                <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
                    <%-- Hiển thị thông báo lỗi nếu có --%>
                    <c:if test="${not empty errorMessage}">
                        <div class="bg-red-50 border-l-4 border-red-400 p-4 mb-6">
                            <div class="flex">
                                <div class="flex-shrink-0">
                                    <i data-lucide="alert-circle" class="h-5 w-5 text-red-400"></i>
                                </div>
                                <div class="ml-3">
                                    <p class="text-sm text-red-700">
                                        ${errorMessage}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty promotion}">
                        <%-- Header with image and basic info --%>
                        <div class="bg-gradient-to-r from-primary to-primary-dark p-8 text-white">
                            <div class="flex flex-col md:flex-row gap-6">
                                <div class="flex-shrink-0">
                                    <c:choose>
                                        <c:when test="${not empty promotion.imageUrl}">
                                            <img src="${pageContext.request.contextPath}${promotion.imageUrl}?v=${System.currentTimeMillis()}" 
                                                 alt="${promotion.title}"
                                                 class="w-48 h-48 object-cover rounded-lg shadow-lg border-4 border-white">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://placehold.co/300x300/D4AF37/FFFFFF?text=PROMO" 
                                                 alt="${promotion.title}"
                                                 class="w-48 h-48 object-cover rounded-lg shadow-lg border-4 border-white">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="flex-1">
                                    <h1 class="text-3xl font-bold mb-4">${promotion.title}</h1>
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                        <div class="flex items-center gap-2">
                                            <i data-lucide="tag" class="w-5 h-5"></i>
                                            <span class="text-lg font-mono bg-white/20 px-3 py-1 rounded-full">${promotion.promotionCode}</span>
                                        </div>
                                        <div class="flex items-center gap-2">
                                            <i data-lucide="circle-dollar-sign" class="w-5 h-5"></i>
                                            <span class="text-lg">
                                                <c:choose>
                                                    <c:when test="${promotion.discountType == 'PERCENTAGE'}">
                                                        Giảm ${promotion.discountValue}%
                                                    </c:when>
                                                    <c:otherwise>
                                                        Giảm <fmt:formatNumber value="${promotion.discountValue}" type="currency" currencySymbol="₫"/>
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="flex items-center gap-2">
                                            <i data-lucide="activity" class="w-5 h-5"></i>
                                            <c:choose>
                                                <c:when test="${promotion.status == 'ACTIVE'}">
                                                    <span class="bg-green-500 text-white px-3 py-1 rounded-full text-sm">Đang áp dụng</span>
                                                </c:when>
                                                <c:when test="${promotion.status == 'SCHEDULED'}">
                                                    <span class="bg-blue-500 text-white px-3 py-1 rounded-full text-sm">Lên lịch</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="bg-gray-500 text-white px-3 py-1 rounded-full text-sm">Không hoạt động</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="flex items-center gap-2">
                                            <i data-lucide="calendar" class="w-5 h-5"></i>
                                            <span class="text-sm">
                                                <c:if test="${not empty promotion.startDate}">
                                                    ${promotion.startDate.toString().substring(0,10)}
                                                </c:if>
                                                - 
                                                <c:if test="${not empty promotion.endDate}">
                                                    ${promotion.endDate.toString().substring(0,10)}
                                                </c:if>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- Description section --%>
                        <div class="p-8 border-b border-gray-200">
                            <h2 class="text-xl font-semibold text-gray-900 mb-4 flex items-center gap-2">
                                <i data-lucide="file-text" class="w-5 h-5 text-primary"></i>
                                Mô tả khuyến mãi
                            </h2>
                            <div class="prose prose-gray max-w-none">
                                <p class="text-gray-700 leading-relaxed">${promotion.description}</p>
                            </div>
                        </div>

                        <%-- Details section --%>
                        <div class="p-8">
                            <h2 class="text-xl font-semibold text-gray-900 mb-6 flex items-center gap-2">
                                <i data-lucide="info" class="w-5 h-5 text-primary"></i>
                                Thông tin chi tiết
                            </h2>
                            
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                                <%-- Left column --%>
                                <div class="space-y-6">
                                    <div class="bg-gray-50 rounded-lg p-4">
                                        <h3 class="font-semibold text-gray-900 mb-3 flex items-center gap-2">
                                            <i data-lucide="percent" class="w-4 h-4 text-primary"></i>
                                            Thông tin giảm giá
                                        </h3>
                                        <div class="space-y-2">
                                            <div class="flex justify-between">
                                                <span class="text-gray-600">Loại giảm giá:</span>
                                                <span class="font-medium">
                                                    <c:choose>
                                                        <c:when test="${promotion.discountType == 'PERCENTAGE'}">Phần trăm (%)</c:when>
                                                        <c:otherwise>Số tiền cố định (VNĐ)</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="flex justify-between">
                                                <span class="text-gray-600">Giá trị giảm:</span>
                                                <span class="font-medium text-green-600">
                                                    <c:choose>
                                                        <c:when test="${promotion.discountType == 'PERCENTAGE'}">
                                                            ${promotion.discountValue}%
                                                        </c:when>
                                                        <c:otherwise>
                                                            <fmt:formatNumber value="${promotion.discountValue}" type="currency" currencySymbol="₫"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="flex justify-between">
                                                <span class="text-gray-600">Giá trị đơn tối thiểu:</span>
                                                <span class="font-medium">
                                                    <c:choose>
                                                        <c:when test="${not empty promotion.minimumAppointmentValue and promotion.minimumAppointmentValue > 0}">
                                                            <fmt:formatNumber value="${promotion.minimumAppointmentValue}" type="currency" currencySymbol="₫"/>
                                                        </c:when>
                                                        <c:otherwise>Không giới hạn</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="bg-gray-50 rounded-lg p-4">
                                        <h3 class="font-semibold text-gray-900 mb-3 flex items-center gap-2">
                                            <i data-lucide="calendar-days" class="w-4 h-4 text-primary"></i>
                                            Thời gian hiệu lực
                                        </h3>
                                        <div class="space-y-2">
                                            <div class="flex justify-between">
                                                <span class="text-gray-600">Ngày bắt đầu:</span>
                                                <span class="font-medium">
                                                    <c:if test="${not empty promotion.startDate}">
                                                        ${promotion.startDate.toString().replace('T', ' ').substring(0,16)}
                                                    </c:if>
                                                </span>
                                            </div>
                                            <div class="flex justify-between">
                                                <span class="text-gray-600">Ngày kết thúc:</span>
                                                <span class="font-medium">
                                                    <c:if test="${not empty promotion.endDate}">
                                                        ${promotion.endDate.toString().replace('T', ' ').substring(0,16)}
                                                    </c:if>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <%-- Right column --%>
                                <div class="space-y-6">
                                    <div class="bg-gray-50 rounded-lg p-4">
                                        <h3 class="font-semibold text-gray-900 mb-3 flex items-center gap-2">
                                            <i data-lucide="users" class="w-4 h-4 text-primary"></i>
                                            Thống kê sử dụng mã khuyến mãi
                                        </h3>
                                        <div class="space-y-3">
                                            <div class="flex justify-between items-center">
                                                <div class="flex flex-col">
                                                    <span class="text-gray-600 text-sm">Lượt sử dụng hiện tại:</span>
                                                    <span class="text-xs text-gray-500">Số lần mã đã được áp dụng</span>
                                                </div>
                                                <span class="font-medium text-blue-600 text-lg">${promotion.currentUsageCount != null ? promotion.currentUsageCount : 0}</span>
                                            </div>
                                            <div class="flex justify-between items-center">
                                                <div class="flex flex-col">
                                                    <span class="text-gray-600 text-sm">Giới hạn mỗi khách hàng:</span>
                                                    <span class="text-xs text-gray-500">Số lần tối đa 1 khách có thể dùng</span>
                                                </div>
                                                <span class="font-medium ${promotion.usageLimitPerCustomer != null ? 'text-orange-600' : 'text-green-600'}">
                                                    ${promotion.usageLimitPerCustomer != null ? promotion.usageLimitPerCustomer + ' lần' : 'Không giới hạn'}
                                                </span>
                                            </div>
                                            <div class="flex justify-between items-center">
                                                <div class="flex flex-col">
                                                    <span class="text-gray-600 text-sm">Tổng giới hạn sử dụng:</span>
                                                    <span class="text-xs text-gray-500">Tổng số lần tối đa có thể sử dụng</span>
                                                </div>
                                                <span class="font-medium ${promotion.totalUsageLimit != null ? 'text-red-600' : 'text-green-600'}">
                                                    ${promotion.totalUsageLimit != null ? promotion.totalUsageLimit + ' lần' : 'Không giới hạn'}
                                                </span>
                                            </div>
                                            <c:if test="${promotion.totalUsageLimit != null && promotion.totalUsageLimit > 0}">
                                                <div class="mt-3 pt-3 border-t border-gray-200">
                                                    <div class="flex justify-between text-sm">
                                                        <span class="text-gray-600">Tỷ lệ sử dụng:</span>
                                                        <span class="font-medium text-purple-600">
                                                            <c:choose>
                                                                <c:when test="${promotion.currentUsageCount != null && promotion.totalUsageLimit != null && promotion.totalUsageLimit > 0}">
                                                                    <fmt:formatNumber value="${(promotion.currentUsageCount / promotion.totalUsageLimit) * 100}" maxFractionDigits="1"/>%
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-orange-600">0%</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                    <div class="w-full bg-gray-200 rounded-full h-2 mt-1">
                                                        <div class="bg-purple-600 h-2 rounded-full" style="width: 0%"></div>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>

                                    <div class="bg-gray-50 rounded-lg p-4">
                                        <h3 class="font-semibold text-gray-900 mb-3 flex items-center gap-2">
                                            <i data-lucide="settings" class="w-4 h-4 text-primary"></i>
                                            Cài đặt và quy tắc áp dụng
                                        </h3>
                                        <div class="space-y-3">
                                            <div class="flex justify-between items-center">
                                                <div class="flex flex-col">
                                                    <span class="text-gray-600 text-sm">Tự động áp dụng:</span>
                                                    <span class="text-xs text-gray-500">Tự động giảm giá khi đủ điều kiện</span>
                                                </div>
                                                <span class="font-medium">
                                                    <c:choose>
                                                        <c:when test="${promotion.isAutoApply}">
                                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs bg-green-100 text-green-800">
                                                                <i data-lucide="check" class="w-3 h-3 mr-1"></i>
                                                                Tự động
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs bg-gray-100 text-gray-800">
                                                                <i data-lucide="hand" class="w-3 h-3 mr-1"></i>
                                                                Nhập mã thủ công
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="flex justify-between items-center">
                                                <div class="flex flex-col">
                                                    <span class="text-gray-600 text-sm">Phạm vi áp dụng:</span>
                                                    <span class="text-xs text-gray-500">Dịch vụ nào được áp dụng khuyến mãi</span>
                                                </div>
                                                <span class="font-medium text-blue-600">
                                                    <c:choose>
                                                        <c:when test="${promotion.applicableScope eq 'ENTIRE_APPOINTMENT'}">
                                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs bg-blue-100 text-blue-800">
                                                                <i data-lucide="calendar-check" class="w-3 h-3 mr-1"></i>
                                                                Toàn bộ cuộc hẹn
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${promotion.applicableScope eq 'SPECIFIC_SERVICE'}">
                                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs bg-purple-100 text-purple-800">
                                                                <i data-lucide="target" class="w-3 h-3 mr-1"></i>
                                                                Dịch vụ cụ thể
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs bg-green-100 text-green-800">
                                                                <i data-lucide="globe" class="w-3 h-3 mr-1"></i>
                                                                Tất cả dịch vụ
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="flex justify-between items-center">
                                                <div class="flex flex-col">
                                                    <span class="text-gray-600 text-sm">Điều kiện khách hàng:</span>
                                                    <span class="text-xs text-gray-500">Loại khách hàng được phép sử dụng</span>
                                                </div>
                                                <span class="font-medium">
                                                    <c:choose>
                                                        <c:when test="${promotion.customerCondition eq 'ALL'}">
                                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs bg-green-100 text-green-800">
                                                                <i data-lucide="users" class="w-3 h-3 mr-1"></i>
                                                                Tất cả khách hàng
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${promotion.customerCondition eq 'INDIVIDUAL'}">
                                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs bg-blue-100 text-blue-800">
                                                                <i data-lucide="user" class="w-3 h-3 mr-1"></i>
                                                                Khách hàng cá nhân
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${promotion.customerCondition eq 'COUPLE'}">
                                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs bg-pink-100 text-pink-800">
                                                                <i data-lucide="heart" class="w-3 h-3 mr-1"></i>
                                                                Khách hàng đi cặp
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${promotion.customerCondition eq 'GROUP'}">
                                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs bg-purple-100 text-purple-800">
                                                                <i data-lucide="users" class="w-3 h-3 mr-1"></i>
                                                                Khách hàng đi nhóm (3+)
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs bg-gray-100 text-gray-800">
                                                                <i data-lucide="help-circle" class="w-3 h-3 mr-1"></i>
                                                                Chưa xác định
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="flex justify-between items-center">
                                                <div class="flex flex-col">
                                                    <span class="text-gray-600 text-sm">Ngày tạo khuyến mãi:</span>
                                                    <span class="text-xs text-gray-500">Thời điểm khuyến mãi được tạo</span>
                                                </div>
                                                <span class="font-medium text-gray-700">
                                                    <c:choose>
                                                        <c:when test="${not empty promotion.createdAt}">
                                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs bg-gray-100 text-gray-800">
                                                                <i data-lucide="calendar" class="w-3 h-3 mr-1"></i>
                                                                ${promotion.createdAt.toString().substring(0,10)}
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-gray-500 text-xs">Chưa có thông tin</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- Terms section --%>
                        <c:if test="${not empty promotion.termsAndConditions}">
                            <div class="p-8 bg-yellow-50 border-t border-yellow-200">
                                <h2 class="text-xl font-semibold text-gray-900 mb-4 flex items-center gap-2">
                                    <i data-lucide="alert-triangle" class="w-5 h-5 text-yellow-600"></i>
                                    Điều kiện và điều khoản
                                </h2>
                                <div class="bg-white rounded-lg p-4 border border-yellow-200">
                                    <p class="text-gray-700 leading-relaxed">${promotion.termsAndConditions}</p>
                                </div>
                            </div>
                        </c:if>

                        <%-- Action buttons --%>
                        <div class="p-8 bg-gray-50 border-t border-gray-200">
                            <div class="flex justify-between items-center">
                                <a href="${pageContext.request.contextPath}/promotion/list" 
                                   class="inline-flex items-center gap-2 px-6 py-2 bg-gray-500 text-white rounded-lg hover:bg-gray-600 transition-colors">
                                    <i data-lucide="arrow-left" class="w-5 h-5"></i>
                                    Quay lại danh sách
                                </a>
                                
                                <div class="flex gap-3">
                                    <a href="${pageContext.request.contextPath}/promotion/usage-report?id=${promotion.promotionId}" 
                                       class="inline-flex items-center gap-2 px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                                        <i data-lucide="users" class="w-5 h-5"></i>
                                        Báo cáo sử dụng
                                    </a>
                                    
                                    <a href="${pageContext.request.contextPath}/promotion/edit?id=${promotion.promotionId}" 
                                       class="inline-flex items-center gap-2 px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors">
                                        <i data-lucide="edit" class="w-5 h-5"></i>
                                        Chỉnh sửa
                                    </a>
                                    
                                    <c:choose>
                                        <c:when test="${promotion.status == 'ACTIVE'}">
                                            <a href="${pageContext.request.contextPath}/promotion/deactivate?id=${promotion.promotionId}" 
                                               onclick="return confirm('Bạn có chắc muốn vô hiệu hóa khuyến mãi này?')"
                                               class="inline-flex items-center gap-2 px-6 py-2 bg-orange-600 text-white rounded-lg hover:bg-orange-700 transition-colors">
                                                <i data-lucide="pause" class="w-5 h-5"></i>
                                                Vô hiệu hóa
                                            </a>
                                        </c:when>
                                        <c:when test="${promotion.status == 'INACTIVE'}">
                                            <a href="${pageContext.request.contextPath}/promotion/activate?id=${promotion.promotionId}" 
                                               onclick="return confirm('Bạn có chắc muốn kích hoạt khuyến mãi này?')"
                                               class="inline-flex items-center gap-2 px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors">
                                                <i data-lucide="play" class="w-5 h-5"></i>
                                                Kích hoạt
                                            </a>
                                        </c:when>
                                        <c:when test="${promotion.status == 'SCHEDULED'}">
                                            <a href="${pageContext.request.contextPath}/promotion/activate?id=${promotion.promotionId}" 
                                               onclick="return confirm('Bạn có chắc muốn kích hoạt ngay khuyến mãi này?')"
                                               class="inline-flex items-center gap-2 px-6 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors">
                                                <i data-lucide="fast-forward" class="w-5 h-5"></i>
                                                Kích hoạt ngay
                                            </a>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:if>
                    
                    <c:if test="${empty promotion}">
                        <div class="p-8 text-center">
                            <i data-lucide="alert-circle" class="w-16 h-16 text-red-400 mx-auto mb-4"></i>
                            <h3 class="text-lg font-medium text-gray-900 mb-2">Không tìm thấy khuyến mãi</h3>
                            <p class="text-gray-500 mb-4">Khuyến mãi không tồn tại hoặc đã bị xóa.</p>
                            <a href="${pageContext.request.contextPath}/promotion/list" 
                               class="inline-flex items-center px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors">
                                <i data-lucide="arrow-left" class="w-4 h-4 mr-2"></i>
                                Quay lại danh sách
                            </a>
                        </div>
                    </c:if>
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
