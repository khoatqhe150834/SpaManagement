<%--
    Document   : booking-checkout.jsp
    Created on : Booking Checkout Page
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.RoleConstants" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    boolean showBookingFeatures = true; // Default to show for guests

    if (session.getAttribute("authenticated") != null
            && Boolean.TRUE.equals(session.getAttribute("authenticated"))) {

        if (session.getAttribute("customer") != null) {
            showBookingFeatures = true;
        } else if (session.getAttribute("user") != null) {
            showBookingFeatures = false; // Hide for staff/admin roles
        }
    }

    pageContext.setAttribute("showBookingFeatures", showBookingFeatures);

    String pendingPromotionCode = (String) session.getAttribute("pendingPromotionCode");
%>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Thanh toán - Spa Hương Sen</title>

    <!-- Tailwind CSS -->
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

    <!-- Google Fonts -->
    <link
      href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap"
      rel="stylesheet"
    />

    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>

    <!-- Custom CSS -->
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />

    <!-- Custom styles for animations and components -->
    <style>
      @keyframes fadeIn {
        from {
          opacity: 0;
          transform: translateY(20px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }

      @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
      }

      .animate-fadeIn {
        animation: fadeIn 0.6s ease-out forwards;
      }

      .notification {
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 1000;
        padding: 12px 24px;
        border-radius: 8px;
        color: white;
        font-weight: 500;
        transform: translateX(400px);
        transition: transform 0.3s ease;
      }

      .notification.show {
        transform: translateX(0);
      }

      .notification.success {
        background-color: #10b981;
      }

      .notification.error {
        background-color: #ef4444;
      }

      .notification.info {
        background-color: #3b82f6;
      }

      .loading-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 9999;
      }

      .loading-spinner {
        width: 40px;
        height: 40px;
        border: 4px solid #f3f3f3;
        border-top: 4px solid #D4AF37;
        border-radius: 50%;
        animation: spin 1s linear infinite;
      }

      .cart-item-card {
        transition: all 0.3s ease;
      }

      .cart-item-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
      }

      .quantity-btn {
        transition: all 0.2s ease;
      }

      .quantity-btn:hover {
        transform: scale(1.05);
      }

      .payment-timer {
        background: linear-gradient(135deg, #D4AF37, #B8941F);
        color: white;
        border-radius: 12px;
        padding: 20px;
        text-align: center;
        margin-bottom: 24px;
      }

      .qr-container {
        background: #f8f9fa;
        border-radius: 12px;
        padding: 32px;
        text-align: center;
      }

      .payment-info-card {
        background: white;
        border-radius: 12px;
        padding: 24px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      }
    </style>
</head>

<body class="bg-spa-cream">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />

    <!-- Main Content -->
    <div class="min-h-screen bg-spa-cream pt-20">
            <!-- Checkout Step -->
            <div id="checkoutStep" class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 animate-fadeIn">
                <!-- Header -->
                <div class="text-center mb-12">
                    <h1 class="text-3xl md:text-4xl font-serif text-spa-dark mb-4">
                        Thanh toán
                    </h1>
                    <p class="text-lg text-gray-600">
                        Xem lại đơn hàng và hoàn tất thanh toán
                    </p>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                    <!-- Services List -->
                    <div class="lg:col-span-2">
                        <div class="bg-white rounded-xl shadow-lg p-8 max-h-[600px] overflow-y-auto">
                            <h2 class="text-xl font-serif font-semibold text-spa-dark mb-6">
                                Dịch vụ đã chọn
                            </h2>

                            <!-- Empty Cart Message -->
                            <div id="emptyCartMessage" class="text-center py-16" style="display: none;">
                                <div class="text-gray-400 mb-6">
                                    <i data-lucide="credit-card" class="h-20 w-20 mx-auto"></i>
                                </div>
                                <h3 class="text-lg font-semibold text-spa-dark mb-3">
                                    Giỏ hàng trống
                                </h3>
                                <p class="text-sm text-gray-600 mb-6">
                                    Thêm dịch vụ vào giỏ hàng để tiếp tục
                                </p>
                                <a href="<c:url value='/services'/>" class="inline-flex items-center px-4 py-2 bg-primary text-white rounded-full hover:bg-primary-dark transition-all duration-300 font-medium text-sm">
                                    Khám phá dịch vụ
                                    <i data-lucide="arrow-right" class="ml-2 h-4 w-4"></i>
                                </a>

                                <!-- Debug Panel (only show in development) -->
                                <div class="mt-6 p-4 bg-gray-100 rounded-lg text-sm">
                                    <h4 class="font-semibold mb-2">Debug Panel:</h4>
                                    <div class="space-y-2">
                                        <button onclick="window.debugCart()" class="px-3 py-1 bg-blue-500 text-white rounded text-xs">Debug Cart</button>
                                        <button onclick="window.addTestCartItems()" class="px-3 py-1 bg-green-500 text-white rounded text-xs">Add Test Items</button>
                                        <button onclick="window.clearAllCartData()" class="px-3 py-1 bg-red-500 text-white rounded text-xs">Clear All Cart</button>
                                        <button onclick="window.refreshCart()" class="px-3 py-1 bg-purple-500 text-white rounded text-xs">Refresh Cart</button>
                                    </div>
                                </div>
                            </div>

                            <!-- Loading State -->
                            <div id="cartLoadingState" class="text-center py-12">
                                <div class="loading-spinner mx-auto mb-4"></div>
                                <p class="text-sm text-gray-600">Đang tải giỏ hàng...</p>
                            </div>

                            <!-- Cart Items Container -->
                            <div id="cartItemsContainer" class="space-y-6" style="display: none;">
                                <!-- Cart items will be dynamically inserted here -->
                            </div>
                        </div>
                    </div>

                    <!-- Summary Section -->
                    <div class="lg:col-span-1">
                        <div class="bg-white rounded-xl shadow-lg p-8 sticky top-24">
                            <h2 class="text-xl font-serif font-semibold text-spa-dark mb-6">
                                Tóm tắt đơn hàng
                            </h2>

                            <div class="space-y-3 mb-6">
                                <div class="flex justify-between text-base">
                                    <span class="text-gray-600">Tạm tính:</span>
                                    <span class="font-semibold text-spa-dark" id="subtotalAmount">0đ</span>
                                </div>
                                <div class="flex justify-between text-base">
                                    <span class="text-gray-600">VAT (10%):</span>
                                    <span class="font-semibold text-spa-dark" id="taxAmount">0đ</span>
                                </div>
                                <!-- Mã giảm giá (đặt ở đây) -->
                                <div class="mb-2">
                                    <label for="promotionCode" class="block text-sm font-medium text-gray-700 mb-1">Mã giảm giá</label>
                                    <div class="flex items-center gap-2">
                                        <input type="text" id="promotionCode" name="promotionCode"
                                               value="<%= pendingPromotionCode != null ? pendingPromotionCode : "" %>"
                                               placeholder="Nhập mã giảm giá..."
                                               class="flex-1 px-3 py-2 border rounded focus:outline-none focus:ring-2 focus:ring-primary" />
                                        <button id="applyPromoBtn" type="button" class="px-3 py-2 bg-primary text-white rounded hover:bg-primary-dark transition-colors whitespace-nowrap">Áp dụng</button>
                                        <button id="removePromoBtn" type="button" class="px-3 py-2 bg-gray-300 text-gray-700 rounded hover:bg-gray-400 transition-colors whitespace-nowrap" style="display:none;">Bỏ mã</button>
                                    </div>
                                </div>
                                <!-- Dòng giảm giá động (JS sẽ cập nhật) -->
                                <div class="flex justify-between text-base text-green-600" id="discountRow" style="display:none;">
                                    <span>Giảm giá:</span>
                                    <span id="discountAmount">-0đ</span>
                                </div>
                                <div class="border-t border-gray-200 pt-3">
                                    <div class="flex justify-between text-lg font-bold">
                                        <span class="text-spa-dark">Tổng cộng:</span>
                                        <span class="text-primary" id="totalAmount">0đ</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Payment Method -->
                            <div class="mb-6">
                                <h3 class="text-base font-semibold text-spa-dark mb-3">
                                    Phương thức thanh toán
                                </h3>
                                <div class="border border-primary rounded-xl p-3 bg-spa-cream">
                                    <div class="flex items-center">
                                        <i data-lucide="qr-code" class="h-5 w-5 text-primary mr-2"></i>
                                        <span class="font-medium text-spa-dark text-sm">Chuyển khoản QR Code</span>
                                    </div>
                                    <p class="text-xs text-gray-600 mt-1">
                                        Thanh toán nhanh chóng và an toàn
                                    </p>
                                </div>
                            </div>

                            <!-- Checkout Button -->
                            <button id="checkoutBtn" class="w-full flex items-center justify-center px-6 py-3 bg-primary text-white rounded-full hover:bg-primary-dark transition-all duration-300 font-medium text-base transform hover:scale-105">
                                <i data-lucide="credit-card" class="h-5 w-5 mr-2"></i>
                                Thanh toán
                            </button>

                            <!-- Security Notice -->
                            <div class="mt-4 text-center">
                                <div class="flex items-center justify-center text-xs text-gray-500">
                                    <i data-lucide="shield-check" class="h-4 w-4 mr-1 text-green-500"></i>
                                    Thanh toán được bảo mật 100%
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Payment Step -->
            <div id="paymentStep" class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12 animate-fadeIn" style="display: none;">
                <!-- Header -->
                <div class="text-center mb-12">
                    <div class="bg-primary rounded-full w-20 h-20 flex items-center justify-center mx-auto mb-6">
                        <i data-lucide="qr-code" class="h-10 w-10 text-white"></i>
                    </div>
                    <h1 class="text-2xl md:text-3xl font-serif text-spa-dark mb-4">
                        Thanh toán QR Code
                    </h1>
                    <p class="text-base text-gray-600">
                        Quét mã QR bên dưới để hoàn tất thanh toán
                    </p>
                </div>

                <!-- Timer -->
                <div class="payment-timer">
                    <div class="flex items-center justify-center mb-2">
                        <i data-lucide="timer" class="h-5 w-5 mr-2"></i>
                        <span class="text-sm">Thời gian còn lại:</span>
                    </div>
                    <div class="text-2xl font-bold" id="paymentTimer">
                        15:00
                    </div>
                    <p id="timerWarning" class="text-red-200 text-xs mt-2" style="display: none;">
                        ⚠️ Vui lòng hoàn tất thanh toán trong 5 phút
                    </p>
                </div>

                <!-- QR Code -->
                <div class="bg-white rounded-xl shadow-lg p-10 mb-8">
                    <div class="qr-container">
                        <div class="bg-spa-cream rounded-xl p-8 mb-6 inline-block">
                            <img id="qrCodeImage" src="" alt="QR Code thanh toán" class="w-56 h-56 mx-auto">
                        </div>
                        <p class="text-sm text-gray-600 mb-4">
                            Sử dụng ứng dụng ngân hàng để quét mã QR
                        </p>
                    </div>
                </div>

                <!-- Payment Details -->
                <div class="payment-info-card mb-8">
                    <h3 class="text-lg font-serif font-semibold text-spa-dark mb-4">
                        Thông tin thanh toán
                    </h3>
                    <div class="space-y-3">
                        <div class="flex justify-between text-sm">
                            <span class="text-gray-600">Ngân hàng:</span>
                            <span class="font-medium text-spa-dark" id="bankName">Vietcombank</span>
                        </div>
                        <div class="flex justify-between text-sm">
                            <span class="text-gray-600">Số tài khoản:</span>
                            <span class="font-medium text-spa-dark" id="accountNumber">1234567890</span>
                        </div>
                        <div class="flex justify-between text-sm">
                            <span class="text-gray-600">Chủ tài khoản:</span>
                            <span class="font-medium text-spa-dark" id="accountName">SPA HUONG SEN</span>
                        </div>
                        <div class="flex justify-between items-center text-sm">
                            <span class="text-gray-600">Mã tham chiếu:</span>
                            <div class="flex items-center">
                                <span class="font-medium text-spa-dark mr-2" id="referenceNumber"></span>
                                <button id="copyRefBtn" class="p-1 text-primary hover:text-primary-dark transition-colors rounded-full hover:bg-spa-cream" title="Sao chép mã">
                                    <i data-lucide="copy" class="h-4 w-4"></i>
                                </button>
                            </div>
                        </div>
                        <div class="flex justify-between text-base font-bold text-primary pt-3 border-t border-gray-200">
                            <span>Tổng tiền:</span>
                            <span id="paymentTotalAmount">0đ</span>
                        </div>
                    </div>
                </div>

                <!-- Instructions -->
                <div class="bg-gradient-to-br from-blue-50 to-indigo-50 border border-blue-200 rounded-xl p-6 mb-8">
                    <h4 class="font-serif font-medium text-blue-800 mb-3 text-base">Hướng dẫn thanh toán:</h4>
                    <ol class="text-blue-700 space-y-1 text-sm">
                        <li class="flex items-start">
                            <span class="bg-blue-600 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs font-bold mr-2 mt-0.5">1</span>
                            Mở ứng dụng ngân hàng trên điện thoại
                        </li>
                        <li class="flex items-start">
                            <span class="bg-blue-600 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs font-bold mr-2 mt-0.5">2</span>
                            Chọn chức năng "Quét QR Code" hoặc "Chuyển khoản QR"
                        </li>
                        <li class="flex items-start">
                            <span class="bg-blue-600 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs font-bold mr-2 mt-0.5">3</span>
                            Quét mã QR ở trên
                        </li>
                        <li class="flex items-start">
                            <span class="bg-blue-600 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs font-bold mr-2 mt-0.5">4</span>
                            Kiểm tra thông tin và xác nhận thanh toán
                        </li>
                        <li class="flex items-start">
                            <span class="bg-blue-600 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs font-bold mr-2 mt-0.5">5</span>
                            Lưu lại biên lai để đối chiếu
                        </li>
                    </ol>
                </div>

                <!-- Actions -->
                <div class="flex flex-col sm:flex-row gap-4">
                    <button id="backToCheckoutBtn" class="flex-1 flex items-center justify-center px-6 py-3 border-2 border-gray-300 text-gray-700 rounded-full hover:bg-gray-50 transition-all duration-300 font-medium text-base">
                        <i data-lucide="arrow-left" class="h-4 w-4 mr-2"></i>
                        Quay lại
                    </button>
                    <button id="paymentCompleteBtn" class="flex-1 px-6 py-3 bg-primary text-white rounded-full hover:bg-primary-dark transition-all duration-300 font-medium text-base transform hover:scale-105">
                        Tôi đã thanh toán
                    </button>
                </div>
            </div>
        </div>

    </div>

    <!-- Loading Overlay -->
    <div id="loadingOverlay" class="loading-overlay" style="display: none;">
        <div class="loading-spinner"></div>
    </div>

    <!-- Notification Container -->
    <div id="notification" class="notification"></div>

    <!-- JavaScript -->
    <script>
        // Global configuration
        window.spaConfig = {
            contextPath: '${pageContext.request.contextPath}',
            apiEndpoint: '${pageContext.request.contextPath}/api'
        };

        // Debug information
        console.log('Booking checkout page loaded');
        console.log('Context path:', window.spaConfig.contextPath);
        console.log('Show booking features:', '${showBookingFeatures}');

        // Debug localStorage
        console.log('=== INITIAL LOCALSTORAGE DEBUG ===');
        console.log('All localStorage keys:', Object.keys(localStorage));
        Object.keys(localStorage).forEach(key => {
            if (key.includes('cart') || key.includes('Cart')) {
                console.log(`${key}:`, localStorage.getItem(key));
            }
        });
        console.log('=== END INITIAL DEBUG ===');
    </script>

    <c:choose>
        <c:when test="${sessionScope.user != null}">
            <script>
                console.log('User authenticated: ${sessionScope.user.fullName}');
                sessionStorage.setItem('user', JSON.stringify({
                    id: '${sessionScope.user.userId}',
                    fullName: '${sessionScope.user.fullName}',
                    roleId: '${sessionScope.user.roleId}'
                }));
            </script>
        </c:when>
        <c:when test="${sessionScope.customer != null}">
            <script>
                console.log('Customer authenticated: ${sessionScope.customer.fullName}');
                sessionStorage.setItem('user', JSON.stringify({
                    id: '${sessionScope.customer.customerId}',
                    fullName: '${sessionScope.customer.fullName}',
                    roleId: '${sessionScope.customer.roleId}'
                }));
            </script>
        </c:when>
        <c:otherwise>
            <script>
                console.log('No authenticated user found');
            </script>
        </c:otherwise>
    </c:choose>

    <script>
window.addEventListener('DOMContentLoaded', function() {
    var input = document.getElementById('promotionCode');
    if (!input) return;
    if (input.value && input.value.trim().length > 0) return;
    var urlParams = new URLSearchParams(window.location.search);
    var promoCode = urlParams.get('promotionCode');
    if (promoCode) {
        input.value = promoCode;
        input.focus();
        return;
    }
    var pending = localStorage.getItem('pendingPromotionCode');
    if (pending) {
        input.value = pending;
        input.focus();
        localStorage.removeItem('pendingPromotionCode');
    }
});
</script>

    <!-- Core JavaScript -->
    <script src="<c:url value='/js/app.js'/>"></script>

    <!-- Booking Checkout JavaScript -->
    <script src="<c:url value='/js/booking-checkout.js'/>"></script>

   

    <!-- Footer -->
    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
</body>
</html>
