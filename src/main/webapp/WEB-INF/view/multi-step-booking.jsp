<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đặt lịch - Spa Hương Sen</title>

    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              primary: "#D4AF37",
              "primary-dark": "#B8941F",
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
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet" />

    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
</head>

<body class="bg-spa-cream">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />

    <main class="pt-20">
        <div class="min-h-screen bg-spa-cream pt-8">
            <!-- Header -->
            <div class="bg-white shadow-sm">
                <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <h1 class="text-3xl font-serif text-spa-dark">Đặt lịch spa</h1>
                            <p class="text-gray-600 mt-1" id="step-title">Chọn dịch vụ từ giỏ hàng</p>
                        </div>
                        <div class="text-sm text-gray-500" id="step-indicator">Bước 1 / 5</div>
                    </div>
                    
                    <!-- Progress Bar -->
                    <div class="mt-6">
                        <div class="flex items-center" id="progress-bar"></div>
                    </div>
                </div>
            </div>

            <!-- Main Content -->
            <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                
                <!-- Step 1: Service Selection from Cart -->
                <div id="step-1" class="step-content">
                    <div class="space-y-8">
                        <div>
                            <h2 class="text-2xl font-semibold text-spa-dark mb-2">Chọn dịch vụ từ giỏ hàng</h2>
                            <p class="text-gray-600 mb-6">Chọn các dịch vụ từ giỏ hàng của bạn để đặt lịch (tối đa 6 dịch vụ mỗi lần)</p>
                        </div>

                        <!-- Empty cart message -->
                        <div id="empty-cart-message" class="bg-white rounded-lg shadow-lg p-12 text-center" style="display: none;">
                            <i data-lucide="shopping-cart" class="h-16 w-16 text-gray-300 mx-auto mb-4"></i>
                            <h3 class="text-xl font-semibold text-gray-900 mb-2">Giỏ hàng trống</h3>
                            <p class="text-gray-600 mb-6">Bạn cần thêm dịch vụ vào giỏ hàng trước khi đặt lịch</p>
                            <button onclick="window.history.back()" class="px-6 py-3 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors font-semibold">
                                Quay lại chọn dịch vụ
                            </button>
                        </div>

                        <!-- Cart Items -->
                        <div id="cart-items-container" class="bg-white rounded-lg shadow-lg p-6">
                            <div class="flex items-center justify-between mb-6">
                                <h3 class="text-lg font-semibold text-spa-dark flex items-center">
                                    <i data-lucide="package" class="h-5 w-5 mr-2 text-primary"></i>
                                    Dịch vụ trong giỏ hàng (<span id="cart-count">0</span>)
                                </h3>
                                <div class="text-sm text-gray-600">Đã chọn: <span id="selected-count">0</span>/6</div>
                            </div>

                            <!-- Service limit warning -->
                            <div id="service-limit-warning" class="mb-4 p-3 bg-yellow-50 border border-yellow-200 rounded-lg" style="display: none;">
                                <div class="flex items-center">
                                    <i data-lucide="alert-circle" class="h-5 w-5 text-yellow-600 mr-2"></i>
                                    <p class="text-yellow-800 text-sm font-medium">Bạn chỉ có thể đặt lịch tối đa 6 dịch vụ mỗi lần.</p>
                                </div>
                            </div>

                            <div id="cart-services-grid" class="grid grid-cols-1 md:grid-cols-2 gap-4"></div>

                            <div id="services-error" class="mt-4 flex items-center text-red-600" style="display: none;">
                                <i data-lucide="alert-circle" class="h-5 w-5 mr-2"></i>
                                <span>Vui lòng chọn ít nhất một dịch vụ</span>
                            </div>
                        </div>

                        <!-- Selected Services Summary -->
                        <div id="selected-summary" class="bg-white rounded-lg shadow-lg p-6" style="display: none;">
                            <h3 class="text-lg font-semibold text-spa-dark mb-4">Tóm tắt dịch vụ đã chọn</h3>
                            <div id="selected-services-list" class="space-y-4"></div>
                            <div id="selected-totals" class="border-t pt-4 mt-4"></div>
                        </div>
                    </div>
                </div>

                <!-- Step 2: Schedule Appointment -->
                <div id="step-2" class="step-content" style="display: none;">
                    <div class="space-y-8">
                        <div>
                            <h2 class="text-2xl font-semibold text-spa-dark mb-2">Lên lịch hẹn</h2>
                            <p class="text-gray-600 mb-6">Xem lại dịch vụ đã chọn và chọn thời gian phù hợp</p>
                        </div>

                        <div class="bg-white rounded-lg shadow-lg p-6">
                            <h3 class="text-lg font-semibold text-spa-dark mb-4">Dịch vụ đã chọn</h3>
                            <div id="step2-services-list" class="space-y-4"></div>
                            
                            <div class="border-t pt-4 flex items-center justify-between">
                                <div id="step2-totals"></div>
                                
                                <div class="text-right">
                                    <div class="mb-2"><span class="text-sm text-gray-600">Thời gian:</span></div>
                                    <div id="selected-time-display" style="display: none;">
                                        <div class="flex items-center space-x-2">
                                            <div class="bg-primary text-white px-4 py-2 rounded-lg">
                                                <div class="text-sm font-medium" id="selected-date-text"></div>
                                                <div class="text-lg font-bold" id="selected-time-text"></div>
                                            </div>
                                            <button id="change-time-btn" class="p-2 border border-primary text-primary rounded-lg hover:bg-spa-cream transition-colors">
                                                <i data-lucide="calendar" class="h-5 w-5"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <button id="choose-time-btn" class="flex items-center px-4 py-2 border-2 border-dashed border-primary text-primary rounded-lg hover:bg-spa-cream transition-colors">
                                        <i data-lucide="calendar" class="h-5 w-5 mr-2"></i>
                                        Chọn thời gian
                                    </button>
                                </div>
                            </div>
                            
                            <div id="timeslot-error" class="mt-4 flex items-center text-red-600" style="display: none;">
                                <i data-lucide="alert-circle" class="h-5 w-5 mr-2"></i>
                                <span>Vui lòng chọn thời gian</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Step 3: Choose Therapist -->
                <div id="step-3" class="step-content" style="display: none;">
                    <div class="space-y-8">
                        <div>
                            <h2 class="text-2xl font-semibold text-spa-dark mb-2">Chọn nhân viên</h2>
                            <p class="text-gray-600 mb-6">Chọn nhân viên phù hợp với dịch vụ đã chọn</p>
                        </div>

                        <div class="bg-white rounded-lg shadow-lg p-6">
                            <h3 class="text-lg font-semibold text-spa-dark mb-4">Thông tin đã chọn</h3>
                            <div id="step3-summary" class="grid grid-cols-1 md:grid-cols-2 gap-4"></div>
                        </div>

                        <div class="bg-white rounded-lg shadow-lg p-6">
                            <h3 class="text-lg font-semibold text-spa-dark mb-6">Chọn nhân viên</h3>
                            <div id="therapists-grid" class="grid grid-cols-1 md:grid-cols-2 gap-6"></div>
                            
                            <div id="therapist-error" class="mt-4 flex items-center text-red-600" style="display: none;">
                                <i data-lucide="alert-circle" class="h-5 w-5 mr-2"></i>
                                <span>Vui lòng chọn nhân viên</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Step 4: Payment Information -->
                <div id="step-4" class="step-content" style="display: none;">
                    <div class="space-y-8">
                        <div>
                            <h2 class="text-2xl font-semibold text-spa-dark mb-2">Thông tin thanh toán</h2>
                            <p class="text-gray-600 mb-6">Điền thông tin chi tiết thanh toán của bạn</p>
                        </div>

                        <!-- Guest Information Form -->
                        <div id="guest-info-form" class="bg-white rounded-lg shadow-lg p-6">
                            <h3 class="text-lg font-semibold text-spa-dark mb-6">Thông tin khách hàng</h3>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Họ và tên *</label>
                                    <input type="text" id="guest-name" class="w-full p-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary" placeholder="Nhập họ và tên đầy đủ">
                                    <div class="fullName-error error-message" style="display: none;"></div>
                                </div>
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Email *</label>
                                    <input type="email" id="guest-email" class="w-full p-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary" placeholder="Nhập địa chỉ email">
                                    <div class="email-error error-message" style="display: none;"></div>
                                </div>
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Số điện thoại *</label>
                                    <input type="tel" id="guest-phone" class="w-full p-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary" placeholder="Nhập số điện thoại">
                                    <div class="phone-error error-message" style="display: none;"></div>
                                </div>
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Địa chỉ *</label>
                                    <input type="text" id="guest-address" class="w-full p-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary" placeholder="Nhập địa chỉ đầy đủ">
                                    <div class="address-error error-message" style="display: none;"></div>
                                </div>
                                <div class="md:col-span-2">
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Ghi chú</label>
                                    <textarea id="guest-notes" rows="3" class="w-full p-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary" placeholder="Ghi chú thêm (tùy chọn)"></textarea>
                                </div>
                            </div>
                        </div>

                        <!-- User Information Display -->
                        <div id="user-info-display" class="bg-white rounded-lg shadow-lg p-6" style="display: none;">
                            <h3 class="text-lg font-semibold text-spa-dark mb-4">Thông tin thanh toán</h3>
                            <div id="user-details" class="grid grid-cols-1 md:grid-cols-2 gap-4"></div>
                        </div>

                        <!-- Booking Summary -->
                        <div id="step4-booking-summary" class="bg-white rounded-lg shadow-lg p-6">
                            <h3 class="text-lg font-semibold text-spa-dark mb-4">Tóm tắt đặt lịch</h3>
                            <div id="step4-summary-content" class="space-y-4"></div>
                        </div>
                    </div>
                </div>

                <!-- Step 5: Complete Payment -->
                <div id="step-5" class="step-content" style="display: none;">
                    <div class="space-y-8">
                        <div>
                            <h2 class="text-2xl font-semibold text-spa-dark mb-2">Hoàn tất thanh toán</h2>
                            <p class="text-gray-600 mb-6">Xem lại đặt lịch và chọn phương thức thanh toán</p>
                        </div>

                        <div class="bg-white rounded-lg shadow-lg p-6">
                            <h3 class="text-lg font-semibold text-spa-dark mb-4">Xem lại đặt lịch</h3>
                            <div id="step5-booking-review" class="space-y-4"></div>
                        </div>

                        <div class="bg-white rounded-lg shadow-lg p-6">
                            <h3 class="text-lg font-semibold text-spa-dark mb-6">Chọn phương thức thanh toán</h3>
                            <div id="payment-methods" class="grid grid-cols-1 md:grid-cols-2 gap-4"></div>
                            
                            <div id="payment-error" class="mt-4 flex items-center text-red-600" style="display: none;">
                                <i data-lucide="alert-circle" class="h-5 w-5 mr-2"></i>
                                <span>Vui lòng chọn phương thức thanh toán</span>
                            </div>
                        </div>

                        <div id="qr-payment-section" class="bg-white rounded-lg shadow-lg p-6 text-center" style="display: none;">
                            <h3 class="text-lg font-semibold text-spa-dark mb-4">Quét mã QR để thanh toán</h3>
                            <div class="bg-gray-100 w-48 h-48 mx-auto rounded-lg flex items-center justify-center mb-4">
                                <i data-lucide="qr-code" class="h-24 w-24 text-gray-400"></i>
                            </div>
                            <p class="text-sm text-gray-600 mb-4" id="qr-instructions">Quét mã QR bằng ứng dụng</p>
                            <button id="copy-qr-btn" class="flex items-center justify-center mx-auto px-4 py-2 border border-primary text-primary rounded-lg hover:bg-spa-cream transition-colors">
                                <i data-lucide="copy" class="h-4 w-4 mr-2"></i>
                                <span>Sao chép thông tin</span>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Step 6: Success -->
                <div id="step-6" class="step-content" style="display: none;">
                    <div class="text-center py-12">
                        <i data-lucide="check-circle" class="h-20 w-20 text-green-500 mx-auto mb-6"></i>
                        <h2 class="text-3xl font-semibold text-spa-dark mb-4">Đặt lịch thành công!</h2>
                        <p class="text-lg text-gray-600 mb-8">
                            Cảm ơn bạn đã đặt lịch tại Spa Hương Sen. Chúng tôi sẽ liên hệ với bạn trong vòng 30 phút để xác nhận.
                        </p>
                        
                        <div class="bg-white rounded-lg shadow-lg p-8 max-w-md mx-auto mb-8">
                            <h3 class="text-lg font-semibold text-spa-dark mb-4">Mã đặt lịch</h3>
                            <div class="text-3xl font-bold text-primary mb-4" id="booking-code"></div>
                            <p class="text-sm text-gray-600 mb-4">Vui lòng lưu mã này để tra cứu lịch hẹn</p>
                            
                            <div id="success-booking-details" class="text-left space-y-2 border-t pt-4"></div>
                        </div>

                        <div class="flex flex-col sm:flex-row gap-4 justify-center">
                            <button onclick="window.location.reload()" class="px-8 py-3 bg-primary text-white rounded-full hover:bg-primary-dark transition-colors font-semibold">
                                Đặt lịch mới
                            </button>
                            <button onclick="window.location.href = '/'" class="px-8 py-3 border-2 border-primary text-primary rounded-full hover:bg-spa-cream transition-colors font-semibold">
                                Về trang chủ
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Navigation Buttons -->
                <div id="navigation-buttons" class="flex items-center justify-between mt-12 pt-8 border-t">
                    <div>
                        <button id="prev-btn" class="flex items-center px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors" style="display: none;">
                            <i data-lucide="arrow-left" class="h-4 w-4 mr-2"></i>
                            Quay lại
                        </button>
                    </div>
                    <div>
                        <button id="next-btn" class="flex items-center px-8 py-3 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors font-semibold">
                            Tiếp tục
                            <i data-lucide="arrow-right" class="h-4 w-4 ml-2"></i>
                        </button>
                        <button id="submit-btn" class="flex items-center px-8 py-3 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors font-semibold disabled:opacity-50" style="display: none;">
                            <i data-lucide="credit-card" class="h-4 w-4 mr-2"></i>
                            <span>Xác nhận thanh toán</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Calendar Modal -->
        <div id="calendar-modal" class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4" style="display: none;">
            <div class="bg-white rounded-lg max-w-4xl w-full max-h-[90vh] overflow-hidden">
                <div class="flex">
                    <div class="flex-1 p-6 border-r">
                        <div class="flex items-center justify-between mb-6">
                            <h3 class="text-xl font-semibold text-spa-dark">Chọn ngày</h3>
                            <button id="close-calendar-btn" class="text-gray-500 hover:text-gray-700">
                                <i data-lucide="x" class="h-6 w-6"></i>
                            </button>
                        </div>
                        <div class="flex items-center justify-between mb-4">
                            <button id="prev-month-btn" class="p-2 hover:bg-gray-100 rounded-lg">
                                <i data-lucide="chevron-left" class="h-5 w-5"></i>
                            </button>
                            <h4 id="calendar-month-year" class="text-lg font-semibold"></h4>
                            <button id="next-month-btn" class="p-2 hover:bg-gray-100 rounded-lg">
                                <i data-lucide="chevron-right" class="h-5 w-5"></i>
                            </button>
                        </div>
                        <div class="grid grid-cols-7 gap-1 mb-2">
                            <div class="p-2 text-center text-sm font-medium text-gray-500">CN</div>
                            <div class="p-2 text-center text-sm font-medium text-gray-500">T2</div>
                            <div class="p-2 text-center text-sm font-medium text-gray-500">T3</div>
                            <div class="p-2 text-center text-sm font-medium text-gray-500">T4</div>
                            <div class="p-2 text-center text-sm font-medium text-gray-500">T5</div>
                            <div class="p-2 text-center text-sm font-medium text-gray-500">T6</div>
                            <div class="p-2 text-center text-sm font-medium text-gray-500">T7</div>
                        </div>
                        <div id="calendar-days" class="grid grid-cols-7 gap-1"></div>
                    </div>
                    <div class="flex-1 p-6">
                        <h3 class="text-xl font-semibold text-spa-dark mb-6">Chọn giờ</h3>
                        <div id="calendar-no-date" class="text-center text-gray-500 py-12">
                            <i data-lucide="calendar" class="h-12 w-12 mx-auto mb-4 opacity-50"></i>
                            <p>Vui lòng chọn ngày trước</p>
                        </div>
                        <div id="calendar-time-slots" style="display: none;">
                            <div id="selected-date-display" class="mb-4 p-3 bg-spa-cream rounded-lg">
                                <div class="text-sm text-gray-600">Ngày đã chọn:</div>
                                <div class="font-semibold text-primary" id="selected-date-text-modal"></div>
                            </div>
                            <div id="time-slots-grid" class="grid grid-cols-3 gap-3 max-h-80 overflow-y-auto"></div>
                            <div id="confirm-time-section" class="mt-6 p-4 bg-green-50 border border-green-200 rounded-lg" style="display: none;">
                                <div class="flex items-center justify-between">
                                    <div>
                                        <p class="text-sm text-green-800 font-medium">Đã chọn:</p>
                                        <p class="text-green-900 font-semibold" id="confirm-datetime-text"></p>
                                    </div>
                                    <button id="confirm-time-btn" class="px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors">Xác nhận</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />

    <script src="<c:url value='/js/app.js'/>"></script>
    <script src="<c:url value='/js/cart.js'/>"></script>
    <script src="<c:url value='/js/multi-step-booking.js'/>"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            lucide.createIcons();
        });
    </script>

    <style>
        .step-content { min-height: 400px; }
        .error-message { color: #DC2626; font-size: 0.875rem; margin-top: 0.25rem; }
        .service-card { cursor: pointer; transition: all 0.2s; }
        .service-card.selected { border-color: #D4AF37 !important; background-color: #FFF8F0 !important; box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1); }
        .therapist-card { cursor: pointer; transition: all 0.2s; }
        .therapist-card.selected { border-color: #D4AF37 !important; background-color: #FFF8F0 !important; box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1); }
        .payment-method { cursor: pointer; transition: all 0.2s; }
        .payment-method.selected { border-color: #D4AF37 !important; background-color: #FFF8F0 !important; }
        .calendar-day { cursor: pointer; transition: all 0.2s; }
        .calendar-day.available:hover { background-color: #FFF8F0; }
        .calendar-day.selected { background-color: #D4AF37 !important; color: white !important; }
        .calendar-day.today { background-color: #D4AF37; color: white; font-weight: bold; }
        .time-slot { cursor: pointer; transition: all 0.2s; }
        .time-slot.available:hover { border-color: #D4AF37; background-color: #FFF8F0; }
        .time-slot.selected { border-color: #D4AF37 !important; background-color: #D4AF37 !important; color: white !important; }
        .loading-spinner { border: 2px solid #f3f3f3; border-top: 2px solid #D4AF37; border-radius: 50%; width: 20px; height: 20px; animation: spin 1s linear infinite; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
    </style>
</body>
</html> 