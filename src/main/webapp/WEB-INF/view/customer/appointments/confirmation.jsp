<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <title>Xác Nhận Đặt Lịch - BeautyZone Spa</title>
    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp"></jsp:include>
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    
    <style>
        .confirmation-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .confirmation-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            overflow: hidden;
        }
        
        .confirmation-header {
            background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
            color: white;
            padding: 32px 24px;
            text-align: center;
        }
        
        .success-icon {
            font-size: 64px;
            margin-bottom: 16px;
            display: block;
        }
        
        .confirmation-content {
            padding: 32px 24px;
        }
        
        .btn {
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
            margin: 8px;
        }
        
        .btn-primary {
            background-color: #c8945f;
            color: white;
        }
        
        .btn-secondary {
            background-color: #6b7280;
            color: white;
        }
        
        .action-buttons {
            text-align: center;
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
                        <h1 class="text-white">Xác Nhận Đặt Lịch</h1>
                        <div class="breadcrumb-row">
                            <ul class="list-inline">
                                <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                                <li><a href="${pageContext.request.contextPath}/process-booking">Đặt lịch</a></li>
                                <li>Xác nhận</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Confirmation content -->
            <div class="section-full content-inner">
                <div class="container">
                    <div class="confirmation-container">
                        <div class="confirmation-card">
                            <div class="confirmation-header">
                                <iconify-icon icon="mdi:check-circle" class="success-icon"></iconify-icon>
                                <h1 style="margin: 0; font-size: 28px;">Đặt lịch thành công!</h1>
                                <p style="margin: 8px 0 0; font-size: 16px; opacity: 0.9;">
                                    Cảm ơn bạn đã tin tưởng dịch vụ của BeautyZone Spa
                                </p>
                            </div>
                            
                            <div class="confirmation-content">
                                <div style="border: 1px solid #e5e7eb; border-radius: 8px; padding: 24px; margin-bottom: 24px;">
                                    <h3 style="margin-bottom: 20px; color: #1f2937;">Chi tiết đặt lịch</h3>
                                    
                                    <div style="display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid #f3f4f6;">
                                        <span style="font-weight: 600;">Mã đặt lịch:</span>
                                        <span>#SPA2024001</span>
                                    </div>
                                    
                                    <div style="display: flex; justify-content: space-between; padding: 12px 0; border-bottom: none;">
                                        <span style="font-weight: 600;">Tổng thanh toán:</span>
                                        <span style="font-size: 18px; font-weight: 700; color: #c8945f;">
                                            <fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="" /> VND
                                        </span>
                                    </div>
                                </div>
                                
                                <div class="action-buttons">
                                    <button type="button" id="confirmBookingBtn" class="btn btn-primary">
                                        Xác nhận đặt lịch
                                    </button>
                                    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">
                                        Về trang chủ
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Footer -->
        <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
    </div>
    
    <!-- JavaScript -->
    <jsp:include page="/WEB-INF/view/common/home/js.jsp"></jsp:include>
    <script src="${pageContext.request.contextPath}/assets/home/js/booking-storage.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('confirmBookingBtn').addEventListener('click', function() {
                this.disabled = true;
                this.textContent = 'Đang xử lý...';
                
                fetch('${pageContext.request.contextPath}/process-booking/confirm-booking', {
                    method: 'POST',
                    credentials: 'same-origin'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        if (window.BookingStorage) {
                            window.BookingStorage.confirmBooking(data.appointmentId);
                        }
                        
                        this.textContent = '✓ Đã xác nhận';
                        this.style.backgroundColor = '#22c55e';
                        
                        alert('Đặt lịch đã được xác nhận thành công!');
                        
                        setTimeout(() => {
                            window.location.href = '${pageContext.request.contextPath}/';
                        }, 2000);
                        
                    } else {
                        alert('Lỗi xác nhận đặt lịch: ' + (data.message || 'Vui lòng thử lại'));
                        this.disabled = false;
                        this.textContent = 'Xác nhận đặt lịch';
                    }
                })
                .catch(error => {
                    console.error('Confirmation error:', error);
                    alert('Lỗi xác nhận đặt lịch. Vui lòng thử lại.');
                    this.disabled = false;
                    this.textContent = 'Xác nhận đặt lịch';
                });
            });
        });
    </script>
</body>
</html> 