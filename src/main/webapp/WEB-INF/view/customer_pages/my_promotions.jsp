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
            <p class="text-gray-600">Xem các mã khuyến mãi bạn có thể sử dụng và số lượt còn lại</p>
        </div>

        <!-- Promotion Summary -->
        <c:if test="${not empty promotionSummary}">
            <div class="bg-white rounded-2xl shadow-lg p-6 mb-8">
                <h2 class="text-xl font-bold text-spa-dark mb-4 flex items-center gap-2">
                    <i data-lucide="bar-chart-3" class="w-6 h-6 text-primary"></i>
                    Tổng quan khuyến mãi
                </h2>
                
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div class="text-center p-4 bg-primary/10 rounded-lg">
                        <div class="text-3xl font-bold text-primary mb-2">${promotionSummary.totalPromotions}</div>
                        <div class="text-sm text-gray-600">Tổng mã khuyến mãi</div>
                    </div>
                    <div class="text-center p-4 bg-green-100 rounded-lg">
                        <div class="text-3xl font-bold text-green-600 mb-2">${promotionSummary.unlimitedPromotions}</div>
                        <div class="text-sm text-gray-600">Mã không giới hạn</div>
                    </div>
                    <div class="text-center p-4 bg-blue-100 rounded-lg">
                        <div class="text-3xl font-bold text-blue-600 mb-2">${promotionSummary.totalRemainingUses}</div>
                        <div class="text-sm text-gray-600">Lượt còn lại</div>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Promotion List -->
        <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-200">
                <h2 class="text-xl font-bold text-spa-dark flex items-center gap-2">
                    <i data-lucide="gift" class="w-6 h-6 text-primary"></i>
                    Danh sách khuyến mãi có thể sử dụng
                </h2>
            </div>
            
            <c:choose>
                <c:when test="${not empty customerPromotions}">
                    <div class="divide-y divide-gray-200">
                        <c:forEach var="promotion" items="${customerPromotions}">
                            <div class="p-6 hover:bg-gray-50 transition-colors">
                                <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
                                    <!-- Promotion Info -->
                                    <div class="flex-1">
                                        <div class="flex items-start justify-between mb-3">
                                            <div>
                                                <h3 class="text-lg font-semibold text-gray-900 mb-1">${promotion.title}</h3>
                                                <p class="text-sm text-gray-600 mb-2">
                                                    Mã: <span class="font-mono bg-gray-100 px-2 py-1 rounded text-primary">${promotion.promotionCode}</span>
                                                </p>
                                            </div>
                                            
                                            <!-- Status Badge -->
                                            <c:choose>
                                                <c:when test="${promotion.status == 'ACTIVE'}">
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                        Có thể sử dụng
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                                                        Sắp áp dụng
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        
                                        <!-- Discount Info -->
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
                                                    Hết hạn: <fmt:formatDate value="${promotion.endDate}" pattern="dd/MM/yyyy"/>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Usage Info -->
                                    <div class="flex flex-col items-end gap-3">
                                        <!-- Status Badge -->
                                        <div class="text-right">
                                            <c:set var="now" value="<%= java.time.LocalDateTime.now() %>" />
                                            <c:choose>
                                                <c:when test="${promotion.status != 'ACTIVE'}">
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                                        <i data-lucide="x-circle" class="w-3 h-3 mr-1"></i>
                                                        Không khả dụng
                                                    </span>
                                                </c:when>
                                                <c:when test="${promotion.endDate < now}">
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                                        <i data-lucide="clock" class="w-3 h-3 mr-1"></i>
                                                        Đã hết hạn
                                                    </span>
                                                </c:when>
                                                <c:when test="${promotion.startDate > now}">
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                                                        <i data-lucide="calendar" class="w-3 h-3 mr-1"></i>
                                                        Sắp có hiệu lực
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <!-- Remaining Count -->
                                                    <c:choose>
                                                        <c:when test="${promotion.remainingCount == null}">
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
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        
                                        <!-- Usage Progress -->
                                        <c:if test="${promotion.usageLimitPerCustomer != null}">
                                            <div class="w-32">
                                                <div class="flex justify-between text-xs text-gray-600 mb-1">
                                                    <span>Đã dùng: ${promotion.usedCount}</span>
                                                    <span>Giới hạn: ${promotion.usageLimitPerCustomer}</span>
                                                </div>
                                                <div class="w-full bg-gray-200 rounded-full h-2">
                                                    <c:set var="usagePercentage" value="${(promotion.usedCount * 100) / promotion.usageLimitPerCustomer}" />
                                                    <div class="bg-primary h-2 rounded-full transition-all duration-300" 
                                                         style="width: ${usagePercentage > 100 ? 100 : usagePercentage}%"></div>
                                                </div>
                                            </div>
                                        </c:if>
                                        
                                        <!-- Action Buttons -->
                                        <div class="flex gap-2">
                                            <c:set var="canUse" value="${promotion.status == 'ACTIVE' && promotion.startDate <= now && promotion.endDate >= now && (promotion.remainingCount == null || promotion.remainingCount > 0)}" />
                                            <c:if test="${canUse}">
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
                                            </c:if>
                                        </div>
                                    </div>
                                
                                <!-- Điều kiện sử dụng -->
                                <div class="mt-4 p-3 bg-gray-50 rounded-lg">
                                    <h4 class="text-sm font-medium text-gray-900 mb-2">Điều kiện sử dụng:</h4>
                                    <ul class="text-xs text-gray-600 space-y-1">
                                        <c:if test="${promotion.minimumAppointmentValue != null && promotion.minimumAppointmentValue > 0}">
                                            <li class="flex items-center gap-2">
                                                <i data-lucide="dollar-sign" class="w-3 h-3 text-orange-500"></i>
                                                Đơn hàng tối thiểu: <fmt:formatNumber value="${promotion.minimumAppointmentValue}" type="currency" currencySymbol="₫"/>
                                            </li>
                                        </c:if>
                                        <li class="flex items-center gap-2">
                                            <i data-lucide="users" class="w-3 h-3 text-blue-500"></i>
                                            <c:choose>
                                                <c:when test="${promotion.customerCondition eq 'INDIVIDUAL'}">Khách hàng cá nhân (1 người)</c:when>
                                                <c:when test="${promotion.customerCondition eq 'COUPLE'}">Khách hàng đi cặp (2 người)</c:when>
                                                <c:when test="${promotion.customerCondition eq 'GROUP'}">Khách hàng đi nhóm (3+ người)</c:when>
                                                <c:otherwise>Tất cả khách hàng</c:otherwise>
                                            </c:choose>
                                        </li>
                                        <li class="flex items-center gap-2">
                                            <i data-lucide="calendar" class="w-3 h-3 text-green-500"></i>
                                            Hiệu lực: <fmt:formatDate value="${promotion.startDate}" pattern="dd/MM/yyyy"/> - <fmt:formatDate value="${promotion.endDate}" pattern="dd/MM/yyyy"/>
                                        </li>
                                        <c:if test="${promotion.usageLimitPerCustomer != null}">
                                            <li class="flex items-center gap-2">
                                                <i data-lucide="repeat" class="w-3 h-3 text-purple-500"></i>
                                                Giới hạn: ${promotion.usageLimitPerCustomer} lần/khách hàng
                                            </li>
                                        </c:if>
                                        <c:if test="${promotion.totalUsageLimit != null}">
                                            <li class="flex items-center gap-2">
                                                <i data-lucide="globe" class="w-3 h-3 text-indigo-500"></i>
                                                Tổng giới hạn: ${promotion.totalUsageLimit} lần
                                            </li>
                                        </c:if>
                                    </ul>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="p-12 text-center">
                        <i data-lucide="gift" class="w-16 h-16 text-gray-400 mx-auto mb-4"></i>
                        <h3 class="text-lg font-medium text-gray-900 mb-2">Chưa có khuyến mãi nào</h3>
                        <p class="text-gray-600 mb-6">Hiện tại bạn chưa có mã khuyến mãi nào có thể sử dụng.</p>
                        <a href="${pageContext.request.contextPath}/promotions/available" 
                           class="inline-flex items-center gap-2 px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors">
                            <i data-lucide="eye" class="w-4 h-4"></i>
                            Xem tất cả khuyến mãi
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Help Section -->
        <div class="mt-8 bg-blue-50 rounded-2xl p-6">
            <h3 class="text-lg font-semibold text-blue-900 mb-3 flex items-center gap-2">
                <i data-lucide="help-circle" class="w-5 h-5"></i>
                Hướng dẫn sử dụng
            </h3>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm text-blue-800">
                <div>
                    <h4 class="font-medium mb-2">Cách sử dụng mã khuyến mãi:</h4>
                    <ul class="space-y-1">
                        <li>• Sao chép mã khuyến mãi</li>
                        <li>• Đặt dịch vụ và nhập mã khi thanh toán</li>
                        <li>• Mã sẽ tự động áp dụng giảm giá</li>
                    </ul>
                </div>
                <div>
                    <h4 class="font-medium mb-2">Lưu ý:</h4>
                    <ul class="space-y-1">
                        <li>• Mỗi mã có giới hạn sử dụng riêng</li>
                        <li>• Mã chỉ có hiệu lực trong thời gian quy định</li>
                        <li>• Một số mã có điều kiện giá trị đơn hàng tối thiểu</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
    
    <script>
        // Initialize Lucide icons
        lucide.createIcons();
        
        // Copy promotion code to clipboard
        function copyCode(code) {
            navigator.clipboard.writeText(code).then(function() {
                // Show success message
                const button = event.target.closest('button');
                const originalText = button.innerHTML;
                button.innerHTML = '<i data-lucide="check" class="w-4 h-4"></i> Đã sao chép';
                button.classList.remove('bg-primary', 'hover:bg-primary-dark');
                button.classList.add('bg-green-600', 'hover:bg-green-700');
                
                setTimeout(() => {
                    button.innerHTML = originalText;
                    button.classList.remove('bg-green-600', 'hover:bg-green-700');
                    button.classList.add('bg-primary', 'hover:bg-primary-dark');
                    lucide.createIcons();
                }, 2000);
            }).catch(function(err) {
                console.error('Could not copy text: ', err);
                alert('Không thể sao chép mã. Vui lòng thử lại.');
            });
        }
    </script>
</body>
</html> 