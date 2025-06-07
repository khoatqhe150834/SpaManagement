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
        <meta name="description" content="BeautyZone : Xác thực email bắt buộc" />
        <meta property="og:title" content="BeautyZone : Xác thực email bắt buộc" />
        <meta property="og:description" content="BeautyZone : Xác thực email bắt buộc" />
        <meta name="format-detection" content="telephone=no" />

        <link rel="icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.png" />

        <title>Xác thực email bắt buộc | BeautyZone</title>

        <meta name="viewport" content="width=device-width, initial-scale=1" />

        <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp"></jsp:include>

        <style>
            .page-content {
                padding-top: 120px; /* Add space for fixed header */
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
            .warning-icon {
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
            .email-highlight {
                color: #007bff;
                font-weight: 600;
            }
            /* Match header button styles */
            .btn-custom {
                background: #6c7ae0;
                color: white;
                border: none;
                padding: 12px 25px;
                border-radius: 5px;
                text-decoration: none;
                display: inline-block;
                margin: 10px 5px;
                font-weight: 500;
                font-size: 14px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                transition: all 0.3s ease;
                min-width: 120px;
            }
            .btn-custom:hover {
                background: #5a6fd8;
                color: white;
                text-decoration: none;
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(108, 122, 224, 0.3);
            }
            .btn-outline-custom {
                background: transparent;
                color: #6c7ae0;
                border: 2px solid #6c7ae0;
                padding: 10px 23px;
                border-radius: 5px;
                text-decoration: none;
                display: inline-block;
                margin: 10px 5px;
                font-weight: 500;
                font-size: 14px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                transition: all 0.3s ease;
                min-width: 120px;
            }
            .btn-outline-custom:hover {
                background: #6c7ae0;
                color: white;
                text-decoration: none;
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(108, 122, 224, 0.3);
            }
            .countdown-timer {
                display: inline-block;
                background: #f8f9fa;
                border: 2px solid #6c7ae0;
                border-radius: 50px;
                padding: 15px 25px;
                margin: 10px 0;
                font-size: 1.2rem;
                font-weight: 600;
                color: #6c7ae0;
                box-shadow: 0 2px 10px rgba(108, 122, 224, 0.2);
            }
            .countdown-timer span {
                font-size: 1.5rem;
                font-weight: 700;
                color: #dc3545;
            }
            .alert.alert-success {
                background: #d4edda;
                border: 1px solid #c3e6cb;
                color: #155724;
                border-radius: 10px;
                margin-bottom: 20px;
            }
            .alert.alert-success h5 {
                color: #155724;
                margin-bottom: 10px;
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
                                <div class="warning-icon">
                                    ⚠
                                </div>
                                <h2 class="verification-title">Xác thực email bắt buộc</h2>
                                <div class="mt-4">
                                    <div id="initialButtons">
                                        <p class="text-center mb-3">Tài khoản <span class="email-highlight">${email}</span> chưa được xác thực</p>
                                        <div class="alert alert-info text-center mb-4" style="background: #e7f3ff; border: 1px solid #b8daff; color: #0c5460; border-radius: 10px; padding: 15px;">
                                            <i class="fa fa-info-circle"></i> Để đăng nhập và sử dụng hết tính năng của trang web, bạn phải xác thực tài khoản qua email.
                                        </div>
                                        <div class="text-center">
                                            <button class="btn-custom" id="sendVerificationBtn" data-email="${email}">
                                                <i class="fa fa-envelope"></i> Gửi email xác thực
                                            </button>
                                            <a href="${pageContext.request.contextPath}/login" 
                                               class="btn-outline-custom">
                                                <i class="fa fa-arrow-left"></i> Quay lại đăng nhập
                                            </a>
                                        </div>
                                    </div>
                                    
                                    <div id="emailSentSection" style="display: none;">
                                        <div class="alert alert-success text-center">
                                            <h5><i class="fa fa-check-circle"></i> Email đã được gửi!</h5>
                                            <p>Chúng tôi đã gửi email xác thực đến <strong>${email}</strong></p>
                                            <p>Vui lòng kiểm tra hộp thư của bạn và nhấp vào liên kết xác thực.</p>
                                        </div>
                                        
                                        <div class="text-center">
                                            <div id="countdownSection">
                                                <p class="mb-2">Bạn có thể gửi lại email sau:</p>
                                                <div class="countdown-timer">
                                                    <span id="countdownTimer">60</span> giây
                                                </div>
                                            </div>
                                            
                                            <div id="resendSection" style="display: none;">
                                                <p class="mb-3">Chưa nhận được email?</p>
                                                <button class="btn-custom" id="resendBtn" data-email="${email}">
                                                    <i class="fa fa-envelope"></i> Gửi lại email xác thực
                                                </button>
                                            </div>
                                            
                                            <div class="mt-3">
                                                <a href="${pageContext.request.contextPath}/login" 
                                                   class="btn-outline-custom">
                                                    <i class="fa fa-arrow-left"></i> Quay lại đăng nhập
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="mt-3">
                                        <p class="text-center">
                                            <small>Đã xác thực email? <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a></small>
                                        </p>
                                    </div>
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
                var countdownInterval;
                var email = '${email}';
                var COUNTDOWN_DURATION = 60; // seconds
                
                // Check for existing email send timestamp on page load
                checkEmailSentStatus();
                
                // Handle send verification email button click
                $("#sendVerificationBtn").click(function(e) {
                    e.preventDefault();
                    var email = $(this).data('email');
                    sendVerificationEmail(email);
                });
                
                // Handle resend verification email button click
                $("#resendBtn").click(function(e) {
                    e.preventDefault();
                    var email = $(this).data('email');
                    sendVerificationEmail(email, true);
                });
                
                function checkEmailSentStatus() {
                    var storageKey = 'email_sent_' + email;
                    var emailSentTime = localStorage.getItem(storageKey);
                    
                    if (emailSentTime) {
                        var sentTimestamp = parseInt(emailSentTime);
                        var currentTime = Date.now();
                        var elapsedSeconds = Math.floor((currentTime - sentTimestamp) / 1000);
                        var remainingSeconds = COUNTDOWN_DURATION - elapsedSeconds;
                        
                        if (remainingSeconds > 0) {
                            // Email was sent recently, show countdown
                            $("#initialButtons").hide();
                            $("#emailSentSection").show();
                            startCountdown(remainingSeconds);
                        } else {
                            // Countdown expired, show resend option
                            $("#initialButtons").hide();
                            $("#emailSentSection").show();
                            $("#countdownSection").hide();
                            $("#resendSection").show();
                        }
                    }
                    // If no stored timestamp, stay on initial state
                }
                
                function sendVerificationEmail(email, isResend = false) {
                    var $btn = isResend ? $("#resendBtn") : $("#sendVerificationBtn");
                    var originalText = $btn.html();
                    
                    // Show loading state
                    $btn.html('<i class="fa fa-spinner fa-spin"></i> Đang gửi...').prop('disabled', true);
                    
                    // Send AJAX request
                    $.get('${pageContext.request.contextPath}/resend-verification', {
                        email: email
                    })
                    .done(function(response) {
                        // Store email sent timestamp in localStorage
                        var storageKey = 'email_sent_' + email;
                        localStorage.setItem(storageKey, Date.now().toString());
                        
                        // Show email sent section
                        $("#initialButtons").hide();
                        $("#emailSentSection").show();
                        
                        // Start countdown from full duration
                        startCountdown(COUNTDOWN_DURATION);
                    })
                    .fail(function(xhr) {
                        // Handle error
                        alert('Có lỗi xảy ra khi gửi email. Vui lòng thử lại sau.');
                        $btn.html(originalText).prop('disabled', false);
                    });
                }
                
                function startCountdown(seconds = COUNTDOWN_DURATION) {
                    // Clear any existing interval
                    if (countdownInterval) {
                        clearInterval(countdownInterval);
                    }
                    
                    // Ensure seconds is at least 1
                    seconds = Math.max(1, seconds);
                    
                    $("#countdownSection").show();
                    $("#resendSection").hide();
                    $("#countdownTimer").text(seconds);
                    
                    countdownInterval = setInterval(function() {
                        seconds--;
                        $("#countdownTimer").text(seconds);
                        
                        if (seconds <= 0) {
                            clearInterval(countdownInterval);
                            $("#countdownSection").hide();
                            $("#resendSection").show();
                            
                            // Clean up localStorage when countdown expires
                            var storageKey = 'email_sent_' + email;
                            localStorage.removeItem(storageKey);
                        }
                    }, 1000);
                }
                
                // Clean up localStorage when user leaves the page after countdown expires
                $(window).on('beforeunload', function() {
                    var storageKey = 'email_sent_' + email;
                    var emailSentTime = localStorage.getItem(storageKey);
                    
                    if (emailSentTime) {
                        var sentTimestamp = parseInt(emailSentTime);
                        var currentTime = Date.now();
                        var elapsedSeconds = Math.floor((currentTime - sentTimestamp) / 1000);
                        
                        if (elapsedSeconds >= COUNTDOWN_DURATION) {
                            localStorage.removeItem(storageKey);
                        }
                    }
                });
                
                // Add hover effects for better UX
                $(document).on('mouseenter', '.btn-custom:not(:disabled), .btn-outline-custom', function() {
                    $(this).css('transform', 'translateY(-2px)');
                });
                
                $(document).on('mouseleave', '.btn-custom, .btn-outline-custom', function() {
                    $(this).css('transform', 'translateY(0px)');
                });
            });
        </script>
    </body>
</html> 