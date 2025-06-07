<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="keywords" content="" />
        <meta name="author" content="" />
        <meta name="robots" content="" />
        <meta name="description" content="BeautyZone : Xác thực email" />
        <meta property="og:title" content="BeautyZone : Xác thực email" />
        <meta property="og:description" content="BeautyZone : Xác thực email" />
        <meta name="format-detection" content="telephone=no" />

        <link rel="icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.png" />

        <title>Xác thực email | BeautyZone</title>

        <meta name="viewport" content="width=device-width, initial-scale=1" />

        <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp"></jsp:include>

        <style>
            .page-content {
                padding-top: 120px;
            }
            .verification-container {
                min-height: 70vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 40px 0;
            }
            .verification-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                padding: 40px;
                max-width: 600px;
                width: 100%;
                text-align: center;
            }
            .pending-icon {
                width: 100px;
                height: 100px;
                background: #ffc107;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 30px;
                color: white;
                font-size: 50px;
                box-shadow: 0 5px 15px rgba(255, 193, 7, 0.3);
            }
            .verification-title {
                color: #333;
                font-size: 2.5rem;
                font-weight: 600;
                margin-bottom: 20px;
            }
            .warning-alert {
                background: #fff3cd;
                border: 1px solid #ffeaa7;
                color: #856404;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 30px;
            }
            .warning-alert h5 {
                font-weight: 600;
                margin-bottom: 15px;
                color: #856404;
            }
            .warning-alert p {
                margin-bottom: 10px;
                line-height: 1.6;
            }
            .email-highlight {
                color: #007bff;
                font-weight: 600;
            }
            .button-group {
                margin-top: 20px;
            }
            .button-group .site-button {
                margin: 5px;
            }
            .user-info {
                background: #e9ecef;
                border-radius: 10px;
                padding: 15px;
                margin-bottom: 20px;
            }
            .user-info strong {
                color: #495057;
            }
            .alert {
                margin-bottom: 20px;
                padding: 15px;
                border: 1px solid transparent;
                border-radius: 8px;
                position: relative;
            }
            .alert-success {
                color: #155724;
                background-color: #d4edda;
                border-color: #c3e6cb;
            }
            .alert-danger {
                color: #721c24;
                background-color: #f8d7da;
                border-color: #f5c6cb;
            }
            .alert .close {
                position: absolute;
                top: 10px;
                right: 15px;
                background: none;
                border: none;
                font-size: 20px;
                font-weight: bold;
                cursor: pointer;
                opacity: 0.5;
            }
            .alert .close:hover {
                opacity: 1;
            }
            .site-button:disabled {
                opacity: 0.6;
                cursor: not-allowed;
                pointer-events: none; /* Prevent clicking on disabled button */
            }
            #alertContainer {
                margin-bottom: 20px;
            }
            #alertContainer .alert {
                margin-bottom: 0;
            }
        </style>
    </head>

    <body id="bg">
        <div class="page-wraper">
            <div id="loading-area"></div>
            <jsp:include page="/WEB-INF/view/common/home/header.jsp"></jsp:include>
            
            <div class="page-content bg-white">
                <div class="section-full">
                    <div class="container">
                        <div class="verification-container">
                                                            <div class="verification-card">
                                    <!-- Alert container for messages -->
                                    <div id="alertContainer"></div>
                                    
                                <div class="pending-icon">
                                    ✉
                                </div>
                                <h2 class="verification-title">Vui lòng xác thực email</h2>
                                
                                <div class="user-info">
                                    <strong>Chào mừng:</strong> ${sessionScope.customer.fullName}<br>
                                    <strong>Email:</strong> <span class="email-highlight">${sessionScope.customer.email}</span>
                                </div>
                                
                                <div class="warning-alert">
                                    <h5>Tài khoản chưa được xác thực</h5>
                                    <p>Để sử dụng đầy đủ các tính năng của BeautyZone, bạn cần xác thực địa chỉ email của mình.</p>
                                    <p>Chúng tôi đã gửi một email xác thực đến <span class="email-highlight">${sessionScope.customer.email}</span>.</p>
                                    <p class="mb-0">Vui lòng kiểm tra hộp thư và nhấp vào liên kết xác thực.</p>
                                </div>
                                
                                <div class="button-group">
                                    <a href="#" id="resendVerification" class="site-button radius-no">Gửi lại email xác thực</a>
                                    <a href="${pageContext.request.contextPath}/logout" class="site-button radius-no">Đăng xuất</a>
                                </div>
                                
                              
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
            <button class="scroltop">↑</button>
        </div>

        <jsp:include page="/WEB-INF/view/common/home/js.jsp"></jsp:include>
        
        <script>
            jQuery(document).ready(function() {
                var isRequestInProgress = false; // Flag to prevent multiple requests
                var $button = $("#resendVerification");
                var originalText = $button.text();
                
                // Check if we're still in cooldown period from previous page load
                checkCooldownState();
                
                function checkCooldownState() {
                    var lastSentTime = localStorage.getItem('lastVerificationSent');
                    if (lastSentTime) {
                        var timeSinceLastSent = Math.floor((Date.now() - parseInt(lastSentTime)) / 1000);
                        var remainingTime = 60 - timeSinceLastSent;
                        
                        if (remainingTime > 0) {
                            // Still in cooldown period
                            isRequestInProgress = true;
                            $button.prop('disabled', true);
                            startCountdown(remainingTime);
                        }
                    }
                }
                
                function startCountdown(countdown) {
                    var interval = setInterval(function() {
                        $button.text('Gửi lại sau ' + countdown + 's');
                        countdown--;
                        if (countdown < 0) {
                            clearInterval(interval);
                            $button.prop('disabled', false).text(originalText);
                            isRequestInProgress = false;
                            localStorage.removeItem('lastVerificationSent'); // Clear the timestamp
                        }
                    }, 1000);
                }
                
                // Handle resend verification email
                $button.click(function(e) {
                    e.preventDefault();
                    
                    // Prevent multiple clicks
                    if (isRequestInProgress) {
                        return false;
                    }
                    

                    
                    // Immediately disable button and set flag
                    isRequestInProgress = true;
                    $button.prop('disabled', true).text('Đang gửi...');
                    
                    $.ajax({
                        url: '${pageContext.request.contextPath}/resend-verification',
                        type: 'POST',
                        dataType: 'json',
                        success: function(response) {
                            if (response.success) {
                                // Show success message
                                showMessage(response.message, 'success');
                                // Store timestamp in localStorage
                                localStorage.setItem('lastVerificationSent', Date.now().toString());
                                // Start 60 second countdown
                                $button.prop('disabled', true);
                                startCountdown(60);
                            } else {
                                showMessage(response.message, 'error');
                                $button.prop('disabled', false).text(originalText);
                                isRequestInProgress = false; // Reset flag on error
                            }
                        },
                        error: function(xhr, status, error) {
                            var message = 'Có lỗi xảy ra khi gửi email. Vui lòng thử lại sau.';
                            if (xhr.responseJSON && xhr.responseJSON.message) {
                                message = xhr.responseJSON.message;
                            }
                            showMessage(message, 'error');
                            $button.prop('disabled', false).text(originalText);
                            isRequestInProgress = false; // Reset flag on error
                        }
                    });
                });
                
                // Function to show messages
                function showMessage(message, type) {
                    var alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
                    var alertHtml = '<div class="alert ' + alertClass + ' alert-dismissible" role="alert">' +
                                   message +
                                   '<button type="button" class="close" onclick="this.parentElement.style.display=\'none\'" aria-label="Close">' +
                                   '<span aria-hidden="true">&times;</span>' +
                                   '</button>' +
                                   '</div>';
                    
                    // Clear existing alerts and add new one
                    $('#alertContainer').html(alertHtml);
                    
                    // Auto-hide success messages after 5 seconds
                    if (type === 'success') {
                        setTimeout(function() {
                            $('#alertContainer .alert-success').fadeOut(function() {
                                $(this).remove();
                            });
                        }, 5000);
                    }
                }
            });
        </script>
    </body>
</html> 