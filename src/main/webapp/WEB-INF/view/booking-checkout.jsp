<%-- 
    Document   : booking-checkout.jsp
    Created on : Booking Checkout Page
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thanh toán - BeautyZone Spa</title>
    
    <!-- Include Home Framework Styles -->
    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp" />
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
    
    <style>
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
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
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
<body id="bg">
    <div class="page-wraper">
        <div id="loading-area"></div>
        
        <!-- Header -->
        <jsp:include page="/WEB-INF/view/common/home/header.jsp"></jsp:include>
        
        <!-- Main Content -->
        <div class="min-h-screen bg-[#FFF8F0] pt-8">
            <!-- Checkout Step -->
            <div id="checkoutStep" class="max-w-[1200px] mx-auto px-4 sm:px-6 md:px-8 lg:px-12 xl:px-16 py-6 sm:py-8 md:py-10 lg:py-12">
                <!-- Header -->
                <div class="text-center mb-8">
                    <h1 class="text-4xl font-serif text-[#333333] mb-2">
                        Thanh toán
                    </h1>
                    <p class="text-gray-600">
                        Xem lại đơn hàng và hoàn tất thanh toán
                    </p>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                    <!-- Services List -->
                    <div class="lg:col-span-2">
                        <div class="bg-white rounded-lg shadow-sm p-6 max-h-[600px] overflow-y-auto">
                            <h2 class="text-xl font-semibold text-[#333333] mb-6">
                                Dịch vụ đã chọn
                            </h2>

                            <!-- Empty Cart Message -->
                            <div id="emptyCartMessage" class="text-center py-12" style="display: none;">
                                <div class="text-gray-400 mb-4">
                                    <i data-lucide="credit-card" class="h-16 w-16 mx-auto"></i>
                                </div>
                                <h3 class="text-lg font-medium text-gray-900 mb-2">
                                    Giỏ hàng trống
                                </h3>
                                <p class="text-gray-500">
                                    Thêm dịch vụ vào giỏ hàng để tiếp tục
                                </p>
                            </div>

                            <!-- Cart Items Container -->
                            <div id="cartItemsContainer" class="space-y-6">
                                <!-- Cart items will be dynamically inserted here -->
                            </div>
                        </div>
                    </div>

                    <!-- Summary Section -->
                    <div class="lg:col-span-1">
                        <div class="bg-white rounded-lg shadow-sm p-6 sticky top-8">
                            <h2 class="text-xl font-semibold text-[#333333] mb-6">
                                Tóm tắt đơn hàng
                            </h2>

                            <div class="space-y-4 mb-6">
                                <div class="flex justify-between">
                                    <span class="text-gray-600">Tạm tính:</span>
                                    <span class="font-medium" id="subtotalAmount">0đ</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-gray-600">VAT (10%):</span>
                                    <span class="font-medium" id="taxAmount">0đ</span>
                                </div>
                                <div class="border-t pt-4">
                                    <div class="flex justify-between text-lg font-bold">
                                        <span>Tổng cộng:</span>
                                        <span class="text-[#D4AF37]" id="totalAmount">0đ</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Payment Method -->
                            <div class="mb-6">
                                <h3 class="font-semibold text-[#333333] mb-3">
                                    Phương thức thanh toán
                                </h3>
                                <div class="border border-[#D4AF37] rounded-lg p-3 bg-[#FFF8F0]">
                                    <div class="flex items-center">
                                        <i data-lucide="qr-code" class="h-5 w-5 text-[#D4AF37] mr-2"></i>
                                        <span class="font-medium">Chuyển khoản QR Code</span>
                                    </div>
                                    <p class="text-sm text-gray-600 mt-1">
                                        Thanh toán nhanh chóng và an toàn
                                    </p>
                                </div>
                            </div>

                            <!-- Checkout Button -->
                            <button id="checkoutBtn" class="w-full flex items-center justify-center px-6 py-4 bg-[#D4AF37] text-white rounded-lg hover:bg-[#B8941F] transition-colors font-semibold text-lg">
                                <i data-lucide="credit-card" class="h-5 w-5 mr-2"></i>
                                Thanh toán
                            </button>

                            <!-- Security Notice -->
                            <div class="mt-4 text-center">
                                <div class="flex items-center justify-center text-sm text-gray-500">
                                    <i data-lucide="check-circle" class="h-4 w-4 mr-1 text-green-500"></i>
                                    Thanh toán được bảo mật 100%
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Payment Step -->
            <div id="paymentStep" class="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8 py-8" style="display: none;">
                <!-- Header -->
                <div class="text-center mb-8">
                    <div class="bg-[#D4AF37] rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4">
                        <i data-lucide="qr-code" class="h-8 w-8 text-white"></i>
                    </div>
                    <h1 class="text-3xl font-serif text-[#333333] mb-2">
                        Thanh toán QR Code
                    </h1>
                    <p class="text-gray-600">
                        Quét mã QR bên dưới để hoàn tất thanh toán
                    </p>
                </div>

                <!-- Timer -->
                <div class="payment-timer">
                    <div class="flex items-center justify-center mb-2">
                        <i data-lucide="timer" class="h-5 w-5 mr-2"></i>
                        <span class="text-sm">Thời gian còn lại:</span>
                    </div>
                    <div class="text-3xl font-bold" id="paymentTimer">
                        15:00
                    </div>
                    <p id="timerWarning" class="text-red-200 text-sm mt-2" style="display: none;">
                        ⚠️ Vui lòng hoàn tất thanh toán trong 5 phút
                    </p>
                </div>

                <!-- QR Code -->
                <div class="bg-white rounded-lg shadow-sm p-8 mb-6">
                    <div class="qr-container">
                        <div class="bg-gray-100 rounded-lg p-6 mb-4 inline-block">
                            <img id="qrCodeImage" src="" alt="QR Code thanh toán" class="w-48 h-48 mx-auto">
                        </div>
                        <p class="text-gray-600 mb-4">
                            Sử dụng ứng dụng ngân hàng để quét mã QR
                        </p>
                    </div>
                </div>

                <!-- Payment Details -->
                <div class="payment-info-card mb-6">
                    <h3 class="text-lg font-semibold text-[#333333] mb-4">
                        Thông tin thanh toán
                    </h3>
                    <div class="space-y-3">
                        <div class="flex justify-between">
                            <span class="text-gray-600">Ngân hàng:</span>
                            <span class="font-medium" id="bankName">Vietcombank</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-gray-600">Số tài khoản:</span>
                            <span class="font-medium" id="accountNumber">1234567890</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-gray-600">Chủ tài khoản:</span>
                            <span class="font-medium" id="accountName">SPA HUONG SEN</span>
                        </div>
                        <div class="flex justify-between items-center">
                            <span class="text-gray-600">Mã tham chiếu:</span>
                            <div class="flex items-center">
                                <span class="font-medium mr-2" id="referenceNumber"></span>
                                <button id="copyRefBtn" class="p-1 text-[#D4AF37] hover:text-[#B8941F] transition-colors" title="Sao chép mã">
                                    <i data-lucide="copy" class="h-4 w-4"></i>
                                </button>
                            </div>
                        </div>
                        <div class="flex justify-between text-lg font-bold text-[#D4AF37] pt-2 border-t">
                            <span>Tổng tiền:</span>
                            <span id="paymentTotalAmount">0đ</span>
                        </div>
                    </div>
                </div>

                <!-- Instructions -->
                <div class="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6">
                    <h4 class="font-semibold text-blue-800 mb-2">Hướng dẫn thanh toán:</h4>
                    <ol class="text-sm text-blue-700 space-y-1">
                        <li>1. Mở ứng dụng ngân hàng trên điện thoại</li>
                        <li>2. Chọn chức năng "Quét QR Code" hoặc "Chuyển khoản QR"</li>
                        <li>3. Quét mã QR ở trên</li>
                        <li>4. Kiểm tra thông tin và xác nhận thanh toán</li>
                        <li>5. Lưu lại biên lai để đối chiếu</li>
                    </ol>
                </div>

                <!-- Actions -->
                <div class="flex space-x-4">
                    <button id="backToCheckoutBtn" class="flex-1 flex items-center justify-center px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">
                        <i data-lucide="arrow-left" class="h-5 w-5 mr-2"></i>
                        Quay lại
                    </button>
                    <button id="paymentCompleteBtn" class="flex-1 px-6 py-3 bg-[#D4AF37] text-white rounded-lg hover:bg-[#B8941F] transition-colors font-semibold">
                        Tôi đã thanh toán
                    </button>
                </div>
            </div>
        </div>

        <!-- Loading Overlay -->
        <div id="loadingOverlay" class="loading-overlay" style="display: none;">
            <div class="loading-spinner"></div>
        </div>

        <!-- Notification Container -->
        <div id="notification" class="notification"></div>

        <!-- Footer -->
        <jsp:include page="/WEB-INF/view/common/footer.jsp" />

        <!-- JavaScript -->
        <script>
            // Global configuration
            window.spaConfig = {
                contextPath: '${pageContext.request.contextPath}',
                apiEndpoint: '${pageContext.request.contextPath}/api'
            };
        </script>

        <!-- Include Home Framework Scripts -->
        <jsp:include page="/WEB-INF/view/common/home/js.jsp" />

        <!-- Booking Checkout JavaScript -->
        <script src="${pageContext.request.contextPath}/js/booking-checkout.js"></script>

        <!-- Initialize Lucide Icons -->
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                lucide.createIcons();
            });
        </script>
    </div>
</body>
</html>
