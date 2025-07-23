<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông Báo Khuyến Mãi - Spa Hương Sen</title>
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
                        <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2">Thông báo khuyến mãi</span>
                    </div>
                </li>
            </ol>
        </nav>

        <!-- Page Header -->
        <div class="text-center mb-8">
            <h1 class="text-3xl font-serif text-spa-dark font-bold mb-2">Thông Báo Khuyến Mãi</h1>
            <p class="text-gray-600">Những ưu đãi đặc biệt dành riêng cho bạn</p>
        </div>

        <!-- Main Notification Card -->
        <div class="max-w-4xl mx-auto">
            <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
                <!-- Header -->
                <div class="bg-gradient-to-r from-primary to-primary-dark text-white p-8 text-center">
                    <i data-lucide="gift" class="w-16 h-16 mx-auto mb-4"></i>
                    <h2 class="text-2xl font-serif font-bold mb-2">🎉 Bạn Có Mã Giảm Giá Mới!</h2>
                    <p class="text-lg opacity-90">Spa Hương Sen dành tặng những ưu đãi đặc biệt cho bạn</p>
                    </div>

                <!-- Content -->
                <div class="p-8">
                        <c:choose>
                            <c:when test="${not empty newPromotions}">
                            <!-- Có khuyến mãi mới -->
                            <div class="text-center mb-8">
                                <div class="inline-flex items-center gap-2 bg-blue-100 text-blue-800 px-4 py-2 rounded-full">
                                    <i data-lucide="star" class="w-5 h-5"></i>
                                    <span class="font-semibold">Chúc mừng! Bạn có ${fn:length(newPromotions)} mã khuyến mãi mới</span>
                                </div>
                                </div>

                            <!-- Danh sách khuyến mãi -->
                            <div class="space-y-6">
                                <c:forEach var="promotion" items="${newPromotions}">
                                    <div class="bg-gradient-to-r from-blue-50 to-indigo-50 border border-blue-200 rounded-xl p-6">
                                        <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
                                            <div class="flex-1">
                                                <h3 class="text-xl font-semibold text-gray-900 mb-2">
                                                    <c:choose>
                                                        <c:when test="${not empty promotion.title}">
                                                            ${promotion.title}
                                                        </c:when>
                                                        <c:otherwise>
                                                            Khuyến mãi
                                                        </c:otherwise>
                                                    </c:choose>
                                                </h3>
                                                <!-- Điều kiện áp dụng -->
                                                <ul class="text-sm text-gray-700 mb-2 list-disc pl-5">
                                                    <c:if test="${not empty promotion.startDate || not empty promotion.endDate}">
                                                        <li>
                                                            Hiệu lực:
                                                            <c:if test="${not empty promotion.startDate}">
                                                                từ ${promotion.startDate}
                                                            </c:if>
                                                            <c:if test="${not empty promotion.endDate}">
                                                                đến ${promotion.endDate}
                                                            </c:if>
                                                        </li>
                                                    </c:if>
                                                    <c:if test="${promotion.minimumAppointmentValue != null && promotion.minimumAppointmentValue > 0}">
                                                        <li>Đơn tối thiểu: <fmt:formatNumber value="${promotion.minimumAppointmentValue}" type="currency" currencySymbol="₫"/></li>
                                                    </c:if>
                                                    <c:if test="${promotion.usageLimitPerCustomer != null && promotion.usageLimitPerCustomer > 0}">
                                                        <li>Mỗi khách dùng tối đa: ${promotion.usageLimitPerCustomer} lần</li>
                                                    </c:if>
                                                    <c:if test="${promotion.totalUsageLimit != null && promotion.totalUsageLimit > 0}">
                                                        <li>Tổng số lượt sử dụng: ${promotion.totalUsageLimit}</li>
                                                    </c:if>
                                                    <c:if test="${not empty promotion.applicableScope && promotion.applicableScope != 'ALL_SERVICES'}">
                                                        <li>Chỉ áp dụng cho dịch vụ/sản phẩm chỉ định</li>
                                                    </c:if>
                                                    <c:if test="${not empty promotion.customerCondition && promotion.customerCondition != 'ALL'}">
                                                        <li>Chỉ dành cho: 
                                                            <c:choose>
                                                                <c:when test="${promotion.customerCondition == 'VIP'}">Khách VIP</c:when>
                                                                <c:when test="${promotion.customerCondition == 'NEW'}">Khách mới</c:when>
                                                                <c:when test="${promotion.customerCondition == 'GROUP'}">Đặt nhóm</c:when>
                                                                <c:when test="${promotion.customerCondition == 'COUPLE'}">Cặp đôi</c:when>
                                                                <c:otherwise>Đối tượng đặc biệt</c:otherwise>
                                                            </c:choose>
                                                        </li>
                                                    </c:if>
                                                </ul>
                                                <div class="flex items-center gap-3 mb-3">
                                                    <span class="bg-primary text-white px-3 py-1 rounded-full text-sm font-mono">
                                                        <c:choose>
                                                            <c:when test="${not empty promotion.promotionCode}">
                                                                ${promotion.promotionCode}
                                                            </c:when>
                                                            <c:otherwise>
                                                                N/A
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <span class="bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm font-semibold">
                                                        <c:choose>
                                                            <c:when test="${promotion.discountType == 'PERCENTAGE'}">
                                                                Giảm 
                                                                <c:choose>
                                                                    <c:when test="${not empty promotion.discountValue}">
                                                                        ${promotion.discountValue}%
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        0%
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:when>
                                                            <c:otherwise>
                                                                Giảm 
                                                                <c:choose>
                                                                    <c:when test="${not empty promotion.discountValue}">
                                                                        ₫<c:out value="${promotion.discountValue}"/>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        ₫0
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>
                                            </div>
                                                <p class="text-gray-600 mb-3">
                                                    <c:choose>
                                                        <c:when test="${not empty promotion.description}">
                                                            ${promotion.description}
                                                        </c:when>
                                                        <c:otherwise>
                                                            Không có mô tả
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                                <div class="flex items-center gap-2 text-sm text-blue-600">
                                                    <i data-lucide="calendar" class="w-4 h-4"></i>
                                                    <span>Có hiệu lực đến: 
                                                        <c:choose>
                                                            <c:when test="${not empty promotion.endDate}">
                                                                <c:out value="${promotion.endDate}"/>
                                                            </c:when>
                                                            <c:otherwise>
                                                                Chưa xác định
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                                </div>
                                            </div>
                                            <!-- Nút Dùng Ngay -->
                                            <div class="flex flex-col items-center gap-2 mt-4 lg:mt-0">
                                                <button class="inline-flex items-center gap-2 bg-primary text-white px-5 py-2 rounded-lg font-semibold hover:bg-primary-dark transition-colors"
                                                        onclick="usePromotion('${promotion.promotionCode}')">
                                                    <i data-lucide="zap"></i> Dùng ngay
                                                </button>
                                                <span class="text-xs text-gray-500">Tự động copy mã & chuyển đến dịch vụ</span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                            </c:when>
                            <c:otherwise>
                            <!-- Không có khuyến mãi mới -->
                            <div class="text-center mb-8">
                                <div class="inline-flex items-center gap-2 bg-green-100 text-green-800 px-4 py-2 rounded-full">
                                    <i data-lucide="heart" class="w-5 h-5"></i>
                                    <span class="font-semibold">Cảm ơn bạn đã tin tưởng Spa Hương Sen!</span>
                                </div>
                                <p class="text-gray-600 mt-2">Chúng tôi có những ưu đãi đặc biệt đang chờ bạn</p>
                                </div>

                            <!-- Lợi ích -->
                            <div class="bg-gradient-to-r from-green-50 to-emerald-50 border border-green-200 rounded-xl p-6">
                                <h3 class="text-xl font-semibold text-gray-900 mb-4 flex items-center gap-2">
                                    <i data-lucide="sparkles" class="w-6 h-6 text-primary"></i>
                                    Những lợi ích dành cho bạn
                                </h3>
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div class="flex items-center gap-3">
                                        <i data-lucide="check-circle" class="w-5 h-5 text-green-500"></i>
                                        <span class="text-gray-700">Giảm giá lên đến 30% cho dịch vụ spa</span>
                                    </div>
                                    <div class="flex items-center gap-3">
                                        <i data-lucide="check-circle" class="w-5 h-5 text-green-500"></i>
                                        <span class="text-gray-700">Ưu đãi đặc biệt cho khách hàng thân thiết</span>
                                    </div>
                                    <div class="flex items-center gap-3">
                                        <i data-lucide="check-circle" class="w-5 h-5 text-green-500"></i>
                                        <span class="text-gray-700">Quà tặng miễn phí khi sử dụng dịch vụ</span>
                                    </div>
                                    <div class="flex items-center gap-3">
                                        <i data-lucide="check-circle" class="w-5 h-5 text-green-500"></i>
                                        <span class="text-gray-700">Thông báo sớm về các chương trình mới</span>
                                    </div>
                                </div>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <!-- Call to Action -->
                    <div class="text-center mt-8">
                        <h3 class="text-xl font-semibold text-gray-900 mb-6 flex items-center justify-center gap-2">
                            <i data-lucide="rocket" class="w-6 h-6 text-primary"></i>
                            Hành động ngay để không bỏ lỡ ưu đãi!
                        </h3>
                            
                        <div class="flex flex-col sm:flex-row gap-4 justify-center">
                            <a href="${pageContext.request.contextPath}/promotions/available" 
                               class="inline-flex items-center gap-2 bg-primary text-white px-6 py-3 rounded-lg font-semibold hover:bg-primary-dark transition-colors">
                                <i data-lucide="tags" class="w-5 h-5"></i>
                                Xem Tất Cả Khuyến Mãi
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/services" 
                               class="inline-flex items-center gap-2 bg-green-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-green-700 transition-colors">
                                <i data-lucide="spa" class="w-5 h-5"></i>
                                Đặt Dịch Vụ Ngay
                            </a>
                        </div>
                        </div>

                        <!-- Tips -->
                    <div class="mt-8 bg-yellow-50 border border-yellow-200 rounded-xl p-6">
                        <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center gap-2">
                            <i data-lucide="lightbulb" class="w-5 h-5 text-yellow-600"></i>
                            Mẹo sử dụng mã khuyến mãi
                        </h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
                            <div class="flex items-start gap-2">
                                <i data-lucide="check" class="w-4 h-4 text-green-500 mt-0.5"></i>
                                <span class="text-gray-700">Sao chép mã khuyến mãi trước khi đặt dịch vụ</span>
                            </div>
                            <div class="flex items-start gap-2">
                                <i data-lucide="check" class="w-4 h-4 text-green-500 mt-0.5"></i>
                                <span class="text-gray-700">Kiểm tra điều kiện áp dụng (giá trị tối thiểu, thời hạn)</span>
                            </div>
                            <div class="flex items-start gap-2">
                                <i data-lucide="check" class="w-4 h-4 text-green-500 mt-0.5"></i>
                                <span class="text-gray-700">Áp dụng mã tại bước thanh toán</span>
                            </div>
                            <div class="flex items-start gap-2">
                                <i data-lucide="check" class="w-4 h-4 text-green-500 mt-0.5"></i>
                                <span class="text-gray-700">Một đơn hàng chỉ sử dụng được 1 mã khuyến mãi</span>
                            </div>
                        </div>
                        </div>

                        <!-- Contact Info -->
                    <div class="mt-8 pt-6 border-t border-gray-200 text-center">
                        <p class="text-gray-600 mb-4 flex items-center justify-center gap-2">
                            <i data-lucide="help-circle" class="w-5 h-5"></i>
                                Cần hỗ trợ? Liên hệ ngay với chúng tôi
                            </p>
                        <div class="flex flex-col sm:flex-row gap-4 justify-center text-sm">
                            <div class="flex items-center gap-2 text-green-600">
                                <i data-lucide="phone" class="w-4 h-4"></i>
                                <span>Hotline: <strong>1900-xxxx</strong></span>
                            </div>
                            <div class="flex items-center gap-2 text-blue-600">
                                <i data-lucide="mail" class="w-4 h-4"></i>
                                <span>Email: <strong>info@spahuongsen.com</strong></span>
                            </div>
                        </div>
                        </div>
                    </div>
                </div>

                <!-- Additional Actions -->
            <div class="flex flex-col sm:flex-row gap-4 justify-center mt-6">
                <a href="${pageContext.request.contextPath}/" 
                   class="inline-flex items-center gap-2 bg-gray-100 text-gray-700 px-6 py-3 rounded-lg font-semibold hover:bg-gray-200 transition-colors">
                    <i data-lucide="home" class="w-5 h-5"></i>
                    Về Trang Chủ
                    </a>
                    
                <button onclick="sharePromotion()" 
                        class="inline-flex items-center gap-2 bg-blue-100 text-blue-700 px-6 py-3 rounded-lg font-semibold hover:bg-blue-200 transition-colors">
                    <i data-lucide="share-2" class="w-5 h-5"></i>
                    Chia Sẻ Với Bạn Bè
                    </button>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />

    <script>
        function sharePromotion() {
            var text = 'Spa Hương Sen đang có khuyến mãi đặc biệt! Cùng nhau đến trải nghiệm dịch vụ spa tuyệt vời nhé! 🌸';
            var url = window.location.origin + '${pageContext.request.contextPath}/promotions/available';
            
            if (navigator.share) {
                // Sử dụng Web Share API nếu có
                navigator.share({
                    title: 'Khuyến Mãi Spa Hương Sen',
                    text: text,
                    url: url
                }).catch(console.error);
            } else {
                // Fallback: copy to clipboard
                var fullText = text + ' ' + url;
                navigator.clipboard.writeText(fullText).then(function() {
                    // Hiển thị toast notification
                    showToast('Đã sao chép link chia sẻ! Hãy gửi cho bạn bè nhé 😊', 'success');
                }).catch(function() {
                    // Fallback cuối cùng
                    prompt('Sao chép link này để chia sẻ:', fullText);
                });
            }
        }

        function showToast(message, type) {
            if (!type) type = 'info';
            var toast = document.createElement('div');
            var bgClass = type === 'success' ? 'bg-green-500 text-white' : 'bg-blue-500 text-white';
            var iconName = type === 'success' ? 'check-circle' : 'info';
            
            toast.className = 'fixed top-4 right-4 z-50 p-4 rounded-lg shadow-lg max-w-sm ' + bgClass;
            toast.innerHTML = '<div class="flex items-center gap-2">' +
                '<i data-lucide="' + iconName + '" class="w-5 h-5"></i>' +
                '<span>' + message + '</span>' +
                '</div>';
            document.body.appendChild(toast);
            
            // Auto remove after 3 seconds
            setTimeout(function() {
                if (toast.parentNode) {
                    toast.parentNode.removeChild(toast);
                }
            }, 3000);
        }

        function usePromotion(code) {
            if (!code) return;
            // Lưu mã vào localStorage
            localStorage.setItem('pendingPromotionCode', code);
            // Chuyển hướng sang trang dịch vụ
            window.location.href = `${pageContext.request.contextPath}/services`;
        }

        // Initialize Lucide icons
        lucide.createIcons();
    </script>
</body>
</html> 
 
 