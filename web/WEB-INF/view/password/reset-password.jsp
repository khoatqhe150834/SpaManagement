<%-- 
    Document   : reset-password
    Created on : Jun 2, 2025, 10:25:49 AM
    Author     : quang
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="keywords" content="" />
    <meta name="author" content="" />
    <meta name="robots" content="" />
    <meta name="description" content="BeautyZone : Beauty Spa Salon HTML Template" />
    <meta property="og:title" content="BeautyZone : Beauty Spa Salon HTML Template" />
    <meta property="og:description" content="BeautyZone : Beauty Spa Salon HTML Template" />
    <meta property="og:image" content="../../beautyzone.dexignzone.com/xhtml/social-image.png" />
    <meta name="format-detection" content="telephone=no" />

    <!-- FAVICONS ICON -->
    <link rel="icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.ico" type="image/x-icon" />
    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.png" />
    
    <!-- PAGE TITLE HERE -->
    <title>Đặt Lại Mật Khẩu - BeautyZone Spa</title>

    <!-- MOBILE SPECIFIC -->
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!--[if lt IE 9]>
      <script src="js/html5shiv.min.js"></script>
      <script src="js/respond.min.js"></script>
    <![endif]-->

    <!-- STYLESHEETS -->
    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp"></jsp:include>
    
    <style>
        /* Roboto font for password pages */
        * {
            font-family: 'Roboto', sans-serif;
        }
        
        /* Reset and base styles */
        .page-content {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: 'Roboto', sans-serif;
        }
        
        .section-full {
            flex: 1;
            padding: 60px 0;
        }
        
        /* Main container improvements */
        .reset-container {
            max-width: 500px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        /* Header section */
        .reset-header {
            text-align: center;
            padding: 40px 30px 30px;
            background: linear-gradient(135deg, #586BB4, #4a5aa3);
            color: white;
        }
        
        .reset-header .lock-icon {
            font-size: 48px;
            margin-bottom: 15px;
            opacity: 0.9;
        }
        
        .reset-header h3 {
            margin: 0 0 10px;
            font-size: 28px;
            font-weight: 500;
        }
        
        .reset-header p {
            margin: 0;
            opacity: 0.9;
            font-size: 16px;
            font-weight: 400;
        }
        
        /* Form container */
        .reset-form-container {
            padding: 30px;
        }
        
        /* Security notice */
        .security-notice {
            background: linear-gradient(135deg, #e8eaf6, #f3f4f9);
            border: 1px solid #9fa8da;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
            position: relative;
        }
        
        .security-notice::before {
            content: "\f132";
            font-family: "FontAwesome";
            position: absolute;
            top: 20px;
            left: 20px;
            color: #586BB4;
            font-size: 18px;
        }
        
        .security-notice-content {
            margin-left: 35px;
        }
        
        .security-notice h6 {
            color: #3f51b5;
            margin: 0 0 8px;
            font-weight: 600;
            font-size: 16px;
        }
        
        .security-notice p {
            color: #303f9f;
            margin: 0;
            font-size: 14px;
            line-height: 1.5;
        }
        
        /* Form styles */
        .form-section h4 {
            color: #333;
            margin-bottom: 15px;
            font-size: 20px;
            font-weight: 600;
            display: flex;
            align-items: center;
        }
        
        .form-section h4 i {
            margin-right: 10px;
            color: #586BB4;
        }
        
        .form-description {
            color: #666;
            margin-bottom: 25px;
            font-size: 15px;
            line-height: 1.5;
            font-weight: 400;
        }
        
        /* Input group */
        .input-group {
            margin-bottom: 25px;
        }
        
        .input-label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
            font-size: 14px;
        }
        
        .input-label i {
            margin-right: 5px;
            color: #586BB4;
        }
        
        .email-input {
            width: 100%;
            padding: 15px 20px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s ease;
            background-color: #fafafa;
            font-weight: 400;
        }
        
        .email-input:focus {
            outline: none;
            border-color: #586BB4;
            background-color: white;
            box-shadow: 0 0 0 3px rgba(88, 107, 180, 0.15);
        }
        
        .input-help {
            margin-top: 8px;
            font-size: 13px;
            color: #666;
            display: flex;
            align-items: center;
            font-weight: 400;
        }
        
        .input-help i {
            margin-right: 5px;
            color: #586BB4;
        }
        
        /* Button styles */
        .submit-section {
            margin-top: 30px;
        }
        
        .reset-button {
            width: 100%;
            padding: 15px 25px;
            background: linear-gradient(135deg, #586BB4, #4a5aa3);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 54px;
            font-family: 'Roboto', sans-serif;
        }
        
        .reset-button:hover {
            background: linear-gradient(135deg, #4a5aa3, #3f4d8a);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(88, 107, 180, 0.4);
        }
        
        .reset-button:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }
        
        .reset-button i {
            margin-right: 8px;
        }
        
        .loading-spinner {
            width: 20px;
            height: 20px;
            border: 2px solid transparent;
            border-top: 2px solid white;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-right: 10px;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        /* Back link */
        .back-link {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #f0f0f0;
        }
        
        .back-link a {
            color: #666;
            text-decoration: none;
            font-size: 14px;
            transition: color 0.3s ease;
            display: inline-flex;
            align-items: center;
        }
        
        .back-link a:hover {
            color: #586BB4;
        }
        
        .back-link a i {
            margin-right: 5px;
        }
        
        /* Alert styles */
        .alert {
            border-radius: 8px;
            padding: 15px 20px;
            margin-bottom: 25px;
            border: 1px solid;
            display: flex;
            align-items: flex-start;
            font-weight: 400;
        }
        
        .alert i {
            margin-right: 10px;
            margin-top: 2px;
            flex-shrink: 0;
        }
        
        .alert-danger {
            background-color: #ffebee;
            border-color: #ffcdd2;
            color: #c62828;
        }
        
        .alert-success {
            background-color: #e8f4fd;
            border-color: #b3d9f2;
            color: #1976d2;
            text-align: center;
            flex-direction: column;
            align-items: center;
        }
        
        .success-icon {
            font-size: 48px;
            color: #586BB4;
            margin-bottom: 15px;
        }
        
        .success-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 10px;
            color: #1976d2;
        }
        
        .success-message {
            font-size: 15px;
            line-height: 1.5;
            margin-bottom: 15px;
        }
        
        .success-note {
            font-size: 13px;
            color: #1565c0;
            margin-top: 15px;
        }
        
        /* Success actions */
        .success-actions {
            margin-top: 30px;
            text-align: center;
        }
        
        .success-actions .btn {
            display: inline-block;
            padding: 12px 25px;
            margin: 0 5px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background-color: #586BB4;
            color: white;
            border: 2px solid #586BB4;
        }
        
        .btn-primary:hover {
            background-color: #4a5aa3;
            border-color: #4a5aa3;
            color: white;
        }
        
        .btn-outline {
            background-color: transparent;
            color: #586BB4;
            border: 2px solid #586BB4;
        }
        
        .btn-outline:hover {
            background-color: #586BB4;
            color: white;
        }
        
        /* Responsive design */
        @media (max-width: 576px) {
            .reset-container {
                margin: 20px;
                border-radius: 8px;
            }
            
            .reset-header {
                padding: 30px 20px 25px;
            }
            
            .reset-header h3 {
                font-size: 24px;
            }
            
            .reset-form-container {
                padding: 25px 20px;
            }
            
            .success-actions .btn {
                display: block;
                margin: 10px 0;
                width: 100%;
            }
        }
        
        /* Additional accent colors with #586BB4 theme */
        .text-primary {
            color: #586BB4 !important;
        }
        
        .border-primary {
            border-color: #586BB4 !important;
        }
        
        .bg-primary {
            background-color: #586BB4 !important;
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
            <div class="dlab-bnr-inr overlay-primary bg-pt" style="background-image: url(${pageContext.request.contextPath}/assets/home/images/banner/bnr2.jpg)">
                <div class="container">
                    <div class="dlab-bnr-inr-entry">
                        <h1 class="text-white">Đặt Lại Mật Khẩu</h1>
                        <!-- Breadcrumb row -->
                        <div class="breadcrumb-row">
                            <ul class="list-inline">
                                <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                                <li><a href="${pageContext.request.contextPath}/login">Đăng nhập</a></li>
                                <li>Đặt lại mật khẩu</li>
                            </ul>
                        </div>
                        <!-- Breadcrumb row END -->
                    </div>
                </div>
            </div>
            <!-- inner page banner END -->
            
            <!-- Reset Password area -->
            <div class="section-full content-inner shop-account">
                <!-- Product -->
                <div class="container">
                    <div class="reset-container">
                        <!-- Header -->
                        <div class="reset-header">
                            <i class="fa fa-lock lock-icon"></i>
                            <h3>Quên Mật Khẩu?</h3>
                            <p>Đừng lo lắng! Chúng tôi sẽ giúp bạn lấy lại mật khẩu</p>
                        </div>
                        
                        <!-- Form Container -->
                        <div class="reset-form-container">
                            <!-- Error Messages -->
        <c:if test="${not empty error}">
                                <div class="alert alert-danger">
                                    <i class="fa fa-exclamation-triangle"></i>
                                    <span>${error}</span>
                                </div>
        </c:if>
                            
                            <!-- Success Messages -->
                            <c:if test="${not empty success}">
                                <div class="alert alert-success">
                                    <i class="fa fa-check-circle success-icon"></i>
                                    <div class="success-title">Email Đã Được Gửi!</div>
                                    <div class="success-message">${success}</div>
                                    <div class="success-note">
                                        <i class="fa fa-info-circle"></i>
                                        Vui lòng kiểm tra cả thư mục spam nếu không thấy email.
                                    </div>
                                </div>
                                
                                <div class="success-actions">
                                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                                        <i class="fa fa-sign-in"></i> Đăng Nhập
                                    </a>
                                    <a href="${pageContext.request.contextPath}/reset-password" class="btn btn-outline">
                                        <i class="fa fa-refresh"></i> Gửi Lại Email
                                    </a>
                                </div>
        </c:if>
                            
                            <!-- Reset Password Form -->
                            <c:if test="${empty success}">
                                <!-- Security Notice -->
                                <div class="security-notice">
                                    <div class="security-notice-content">
                                        <h6>Thông Tin Bảo Mật</h6>
                                        <p>Chúng tôi sẽ gửi một liên kết đặt lại mật khẩu đến email của bạn. Liên kết này chỉ có hiệu lực trong 1 giờ vì lý do bảo mật.</p>
                                    </div>
                                </div>
                                
                                <!-- Form Section -->
                                <div class="form-section">
                                    <h4>
                                        <i class="fa fa-envelope-o"></i>
                                        NHẬP EMAIL CỦA BẠN
                                    </h4>
                                    <p class="form-description">
                                        Nhập địa chỉ email mà bạn đã sử dụng để đăng ký tài khoản.
                                    </p>
                                    
                                    <form id="resetPasswordForm" method="post" action="reset-password">
                                        <div class="input-group">
                                            <label class="input-label">
                                                <i class="fa fa-envelope"></i>
                                                ĐỊA CHỈ EMAIL *
                                            </label>
                                            <input
                                                name="email"
                                                id="emailInput"
                                                required="true"
                                                class="email-input"
                                                placeholder="Nhập email của bạn (ví dụ: john@example.com)"
                                                type="email"
                                                value="${param.email}"
                                            />
                                            <div class="input-help">
                                                <i class="fa fa-info-circle"></i>
                                                Email phải đã được đăng ký trong hệ thống của chúng tôi
                                            </div>
                                        </div>
                                        
                                        <div class="submit-section">
                                            <button type="submit" class="reset-button" id="submitBtn">
                                                <i class="fa fa-paper-plane"></i>
                                                GỬI LIÊN KẾT ĐẶT LẠI
                                            </button>
                                        </div>
                                        
                                        <div class="back-link">
                                            <a href="${pageContext.request.contextPath}/login">
                                                <i class="fa fa-arrow-left"></i>
                                                Quay lại đăng nhập
                                            </a>
                                        </div>
        </form>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
                <!-- Product END -->
            </div>
            <!-- Reset Password area END -->
        </div>
        <!-- Content END-->
        
        <!-- Footer -->
        <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
        <!-- Footer END -->
        
        <button class="scroltop fa fa-chevron-up"></button>
    </div>
    
    <!-- JAVASCRIPT FILES ========================================= -->
    <jsp:include page="/WEB-INF/view/common/home/js.jsp"></jsp:include>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('resetPasswordForm');
            const submitBtn = document.getElementById('submitBtn');
            const emailInput = document.getElementById('emailInput');
            
            if (form) {
                emailInput.focus();
                
                form.addEventListener('submit', function(e) {
                    const email = emailInput.value.trim();
                    
                    if (!email || !isValidEmail(email)) {
                        e.preventDefault();
                        alert('Vui lòng nhập địa chỉ email hợp lệ.');
                        emailInput.focus();
                        return;
                    }
                    
                    // Show loading state
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<div class="loading-spinner"></div><i class="fa fa-spinner fa-spin"></i> ĐANG GỬI...';
                });
                
                emailInput.addEventListener('input', function() {
                    const email = this.value.trim();
                    if (email && !isValidEmail(email)) {
                        this.style.borderColor = '#f44336';
                    } else {
                        this.style.borderColor = '#e0e0e0';
                    }
                });
            }
            
            function isValidEmail(email) {
                return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
            }
            
            // Auto-hide alerts
            setTimeout(function() {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(function(alert) {
                    if (!alert.classList.contains('alert-success')) {
                        alert.style.transition = 'opacity 0.5s ease';
                        alert.style.opacity = '0';
                        setTimeout(() => alert.remove(), 500);
                    }
                });
            }, 8000);
        });
    </script>
    </body>
</html>
