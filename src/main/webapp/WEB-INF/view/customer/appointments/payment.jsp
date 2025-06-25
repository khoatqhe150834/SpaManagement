<%-- 
    Document   : payment.jsp
    Created on : Payment Page for Booking Flow
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Thanh Toán - BeautyZone Spa</title>
    
    <!-- FAVICONS ICON -->
    <link rel="icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.ico" type="image/x-icon" />
    
    <!-- STYLESHEETS -->
    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp"></jsp:include>
    
    <!-- Iconify for icons -->
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    
    <style>
        .payment-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .payment-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            overflow: hidden;
        }
        
        .payment-header {
            background: linear-gradient(135deg, #c8945f 0%, #a67c4a 100%);
            color: white;
            padding: 24px;
            text-align: center;
        }
        
        .payment-content {
            padding: 24px;
        }
        
        .booking-summary {
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 24px;
        }
        
        .service-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #f3f4f6;
        }
        
        .service-item:last-child {
            border-bottom: none;
        }
        
        .total-section {
            border-top: 2px solid #c8945f;
            padding-top: 16px;
            margin-top: 16px;
        }
        
        .total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }
        
        .payment-method-option {
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .payment-method-option.selected {
            border-color: #c8945f;
            background-color: #fcf8f1;
        }
        
        .btn {
            flex: 1;
            padding: 16px 24px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
            display: inline-block;
        }
        
        .btn-primary {
            background-color: #c8945f;
            color: white;
        }
        
        .btn-secondary {
            background-color: #6b7280;
            color: white;
        }
        
        .btn-group {
            display: flex;
            gap: 16px;
            margin-top: 32px;
        }
    </style>
</head>

<body id="bg">
    <div class="page-wraper">
        <div id="loading-area"></div>
        
        <!-- header -->
        <jsp:include page="/WEB-INF/view/common/home/header.jsp"></jsp:include>
        <!-- header END -->
        
        <!-- Content -->
        <div class="page-content bg-white">
            <!-- inner page banner -->
            <div class="dlab-bnr-inr overlay-primary bg-pt" 
                 style="background-image: url(${pageContext.request.contextPath}/assets/home/images/banner/bnr2.jpg);">
                <div class="container">
                    <div class="dlab-bnr-inr-entry">
                        <h1 class="text-white">Thanh Toán</h1>
                        <!-- Breadcrumb row -->
                        <div class="breadcrumb-row">
                            <ul class="list-inline">
                                <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                                <li><a href="${pageContext.request.contextPath}/process-booking">Đặt lịch</a></li>
                                <li>Thanh toán</li>
                            </ul>
                        </div>
                        <!-- Breadcrumb row END -->
                    </div>
                </div>
            </div>
            <!-- inner page banner END -->
            
            <!-- Payment content -->
            <div class="section-full content-inner">
                <div class="container">
                    <!-- Step Indicator -->
                    <c:set var="currentStep" value="payment" />
                    <jsp:include page="/WEB-INF/view/common/booking/step-indicator.jsp">
                        <jsp:param name="currentStep" value="${currentStep}" />
                        <jsp:param name="bookingSession" value="${bookingSession}" />
                    </jsp:include>
                    
                    <div class="payment-container">
                        <div class="row">
                            <!-- Payment Form -->
                            <div class="col-lg-8">
                                <div class="payment-card">
                                    <div class="payment-header">
                                        <h2>Phương thức thanh toán</h2>
                                    </div>
                                    <div class="payment-content">
                                        <div class="payment-method-option selected" data-method="cash">
                                            <div style="display: flex; align-items: center;">
                                                <iconify-icon icon="mdi:cash" style="font-size: 24px; margin-right: 12px;"></iconify-icon>
                                                <span style="font-weight: 600;">Thanh toán tại spa</span>
                                                <input type="radio" name="paymentMethod" value="cash" checked style="margin-left: auto;">
                                            </div>
                                            <p style="color: #6b7280; margin-top: 8px;">Thanh toán bằng tiền mặt khi đến spa</p>
                                        </div>
                                        
                                        <div class="payment-method-option" data-method="vnpay">
                                            <div style="display: flex; align-items: center;">
                                                <iconify-icon icon="mdi:credit-card" style="font-size: 24px; margin-right: 12px; color: #1e40af;"></iconify-icon>
                                                <span style="font-weight: 600;">Thanh toán online qua VNPay</span>
                                                <input type="radio" name="paymentMethod" value="vnpay" style="margin-left: auto;">
                                            </div>
                                            <p style="color: #6b7280; margin-top: 8px;">Thanh toán qua Internet Banking, QR Code hoặc thẻ ATM</p>
                                            <div style="margin-top: 8px; display: flex; gap: 8px; flex-wrap: wrap;">
                                                <span style="background: #f3f4f6; padding: 4px 8px; border-radius: 4px; font-size: 12px;">Vietcombank</span>
                                                <span style="background: #f3f4f6; padding: 4px 8px; border-radius: 4px; font-size: 12px;">Techcombank</span>
                                                <span style="background: #f3f4f6; padding: 4px 8px; border-radius: 4px; font-size: 12px;">BIDV</span>
                                                <span style="background: #f3f4f6; padding: 4px 8px; border-radius: 4px; font-size: 12px;">ACB</span>
                                                <span style="background: #f3f4f6; padding: 4px 8px; border-radius: 4px; font-size: 12px;">MBBank</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Booking Summary -->
                            <div class="col-lg-4">
                                <div class="payment-card">
                                    <div class="payment-header">
                                        <h3>Tóm tắt đặt lịch</h3>
                                    </div>
                                    <div class="payment-content">
                                        <div class="booking-summary">
                                            <!-- Booking Details -->
                                            <h4 style="margin-bottom: 16px;">Chi tiết đặt lịch</h4>
                                            
                                            <!-- Time and Date -->
                                            <c:if test="${not empty bookingSession and not empty bookingSession.data.selectedDate}">
                                                <div class="service-item">
                                                    <div>
                                                        <h5>Ngày & Giờ hẹn</h5>
                                                        <p>
                                                            <fmt:formatDate value="${bookingSession.data.selectedDate}" pattern="dd/MM/yyyy" />
                                                            <c:if test="${not empty bookingSession.data.selectedServices and not empty bookingSession.data.selectedServices[0].scheduledTime}">
                                                                lúc <fmt:formatDate value="${bookingSession.data.selectedServices[0].scheduledTime}" pattern="HH:mm" />
                                                            </c:if>
                                                        </p>
                                                    </div>
                                                    <div>
                                                        <iconify-icon icon="mdi:calendar-clock" style="color: #c8945f; font-size: 20px;"></iconify-icon>
                                                    </div>
                                                </div>
                                            </c:if>
                                            
                                            <!-- Services with Therapists -->
                                            <h4 style="margin-bottom: 16px; margin-top: 24px;">Dịch vụ đã chọn</h4>
                                            <c:choose>
                                                <c:when test="${not empty bookingSession and not empty bookingSession.data.selectedServices}">
                                                    <c:forEach var="serviceSelection" items="${bookingSession.data.selectedServices}">
                                                        <div class="service-item">
                                                            <div>
                                                                <h5>${serviceSelection.serviceName}</h5>
                                                                <p>${serviceSelection.estimatedDuration} phút</p>
                                                                <c:if test="${not empty serviceSelection.therapistName}">
                                                                    <p style="color: #6b7280; font-size: 14px;">
                                                                        <iconify-icon icon="mdi:account" style="margin-right: 4px;"></iconify-icon>
                                                                        Nhân viên: ${serviceSelection.therapistName}
                                                                    </p>
                                                                </c:if>
                                                            </div>
                                                            <div style="font-weight: 600; color: #c8945f;">
                                                                <fmt:formatNumber value="${serviceSelection.estimatedPrice}" type="currency" currencySymbol="" /> VND
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <!-- Fallback to old format if bookingSession is not available -->
                                                    <c:forEach var="service" items="${selectedServices}">
                                                        <div class="service-item">
                                                            <div>
                                                                <h5>${service.name}</h5>
                                                                <p>${service.durationMinutes} phút</p>
                                                            </div>
                                                            <div style="font-weight: 600; color: #c8945f;">
                                                                <fmt:formatNumber value="${service.price}" type="currency" currencySymbol="" /> VND
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                            
                                            <!-- Total -->
                                            <div class="total-section">
                                                <div class="total-row" style="font-size: 18px; font-weight: 700;">
                                                    <span>Tổng thanh toán:</span>
                                                    <span>
                                                        <c:choose>
                                                            <c:when test="${not empty bookingSession and not empty bookingSession.data.totalAmount}">
                                                                <fmt:formatNumber value="${bookingSession.data.totalAmount}" type="currency" currencySymbol="" /> VND
                                                            </c:when>
                                                            <c:otherwise>
                                                                <fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="" /> VND
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Action Buttons -->
                                        <div class="btn-group">
                                            <a href="${pageContext.request.contextPath}/process-booking/time-therapists-selection" class="btn btn-secondary">
                                                Quay lại
                                            </a>
                                            <button type="button" id="processPaymentBtn" class="btn btn-primary">
                                                Thanh toán
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Footer -->
        <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
        <!-- Footer End -->
    </div>
    
    <!-- JavaScript -->
    <jsp:include page="/WEB-INF/view/common/home/js.jsp"></jsp:include>
    
    <!-- Booking Storage -->
    <script src="${pageContext.request.contextPath}/assets/home/js/booking-storage.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Handle payment method selection
            const paymentOptions = document.querySelectorAll('.payment-method-option');
            const paymentBtn = document.getElementById('processPaymentBtn');
            
            paymentOptions.forEach(option => {
                option.addEventListener('click', function() {
                    // Remove selected class from all options
                    paymentOptions.forEach(opt => opt.classList.remove('selected'));
                    // Add selected class to clicked option
                    this.classList.add('selected');
                    // Update radio button
                    const radio = this.querySelector('input[type="radio"]');
                    radio.checked = true;
                    
                    // Update button text based on payment method
                    const method = this.getAttribute('data-method');
                    if (method === 'vnpay') {
                        paymentBtn.textContent = 'Thanh toán qua VNPay';
                    } else {
                        paymentBtn.textContent = 'Thanh toán';
                    }
                });
            });
            
            // Process payment
            paymentBtn.addEventListener('click', function() {
                const selectedPaymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
                
                this.disabled = true;
                this.textContent = 'Đang xử lý...';
                
                if (selectedPaymentMethod === 'vnpay') {
                    // Process VNPay payment
                    processVNPayPayment();
                } else {
                    // Process cash payment (existing logic)
                    processCashPayment();
                }
            });
            
            function processCashPayment() {
                const formData = new FormData();
                formData.append('paymentMethod', 'cash');
                formData.append('paymentAmount', '${not empty bookingSession.data.totalAmount ? bookingSession.data.totalAmount : totalAmount}');
                
                fetch('${pageContext.request.contextPath}/process-booking/process-payment', {
                    method: 'POST',
                    body: formData,
                    credentials: 'same-origin'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Save payment data to storage
                        if (window.BookingStorage) {
                            window.BookingStorage.savePaymentData({
                                method: 'cash',
                                status: 'PAID'
                            });
                        }
                        
                        // Redirect to confirmation
                        window.location.href = '${pageContext.request.contextPath}/process-booking/confirmation';
                    } else {
                        alert('Lỗi xử lý thanh toán: ' + (data.message || 'Vui lòng thử lại'));
                        resetPaymentButton();
                    }
                })
                .catch(error => {
                    console.error('Payment error:', error);
                    alert('Lỗi xử lý thanh toán. Vui lòng thử lại.');
                    resetPaymentButton();
                });
            }
            
            function processVNPayPayment() {
                fetch('${pageContext.request.contextPath}/process-booking/vnpay-payment', {
                    method: 'POST',
                    credentials: 'same-origin'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.paymentUrl) {
                        // Save payment method to storage
                        if (window.BookingStorage) {
                            window.BookingStorage.savePaymentData({
                                method: 'vnpay',
                                status: 'PENDING'
                            });
                        }
                        
                        // Redirect to VNPay payment page
                        window.location.href = data.paymentUrl;
                    } else {
                        alert('Lỗi khởi tạo thanh toán VNPay: ' + (data.message || 'Vui lòng thử lại'));
                        resetPaymentButton();
                    }
                })
                .catch(error => {
                    console.error('VNPay payment error:', error);
                    alert('Lỗi kết nối VNPay. Vui lòng thử lại.');
                    resetPaymentButton();
                });
            }
            
            function resetPaymentButton() {
                const btn = document.getElementById('processPaymentBtn');
                btn.disabled = false;
                const selectedMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
                btn.textContent = selectedMethod === 'vnpay' ? 'Thanh toán qua VNPay' : 'Thanh toán';
            }
            
            // Handle error messages from URL parameters (for VNPay returns)
            const urlParams = new URLSearchParams(window.location.search);
            const error = urlParams.get('error');
            const message = urlParams.get('message');
            
            if (error) {
                let errorMessage = 'Có lỗi xảy ra trong quá trình thanh toán.';
                switch(error) {
                    case 'payment_failed':
                        errorMessage = 'Thanh toán thất bại: ' + (message || 'Vui lòng thử lại.');
                        break;
                    case 'verification_failed':
                        errorMessage = 'Xác thực thanh toán thất bại. Vui lòng liên hệ hỗ trợ.';
                        break;
                    case 'system_error':
                        errorMessage = 'Lỗi hệ thống. Vui lòng thử lại sau.';
                        break;
                }
                alert(errorMessage);
                
                // Clear URL parameters
                window.history.replaceState({}, document.title, window.location.pathname);
            }
        });
    </script>
</body>
</html> 