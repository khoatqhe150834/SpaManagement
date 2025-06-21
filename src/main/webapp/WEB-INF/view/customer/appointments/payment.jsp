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
                                            <!-- Services -->
                                            <h4 style="margin-bottom: 16px;">Dịch vụ đã chọn</h4>
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
                                            
                                            <!-- Total -->
                                            <div class="total-section">
                                                <div class="total-row" style="font-size: 18px; font-weight: 700;">
                                                    <span>Tổng thanh toán:</span>
                                                    <span><fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="" /> VND</span>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Action Buttons -->
                                        <div class="btn-group">
                                            <a href="${pageContext.request.contextPath}/process-booking/time-selection" class="btn btn-secondary">
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
            // Process payment
            document.getElementById('processPaymentBtn').addEventListener('click', function() {
                this.disabled = true;
                this.textContent = 'Đang xử lý...';
                
                const formData = new FormData();
                formData.append('paymentMethod', 'cash');
                formData.append('paymentAmount', '${totalAmount}');
                
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
                        this.disabled = false;
                        this.textContent = 'Thanh toán';
                    }
                })
                .catch(error => {
                    console.error('Payment error:', error);
                    alert('Lỗi xử lý thanh toán. Vui lòng thử lại.');
                    this.disabled = false;
                    this.textContent = 'Thanh toán';
                });
            });
        });
    </script>
</body>
</html> 