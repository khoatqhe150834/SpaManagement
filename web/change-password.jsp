<%-- 
    Document   : change-password
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
        /* Reset and base styles */
        .page-content {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .section-full {
            flex: 1;
            padding: 60px 0;
        }
        
        /* Main container improvements */
        .change-password-container {
            max-width: 500px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        /* Header section */
        .change-password-header {
            text-align: center;
            padding: 40px 30px 30px;
            background: linear-gradient(135deg, #586BB4, #4a5aa3);
            color: white;
        }
        
        .change-password-header .key-icon {
            font-size: 48px;
            margin-bottom: 15px;
            opacity: 0.9;
        }
        
        .change-password-header h3 {
            margin: 0 0 10px;
            font-size: 28px;
            font-weight: 700;
        }
        
        .change-password-header p {
            margin: 0;
            opacity: 0.9;
            font-size: 16px;
        }
        
        /* Form container */
        .change-password-form-container {
            padding: 30px;
        }
        
        /* User info section */
        .user-info-section {
            background: linear-gradient(135deg, #e8f4fd, #f3f4f9);
            border: 1px solid #9fa8da;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
            position: relative;
        }
        
        .user-info-section::before {
            content: "\f007";
            font-family: "FontAwesome";
            position: absolute;
            top: 20px;
            left: 20px;
            color: #586BB4;
            font-size: 18px;
        }
        
        .user-info-content {
            margin-left: 35px;
        }
        
        .user-info-content h6 {
            color: #3f51b5;
            margin: 0 0 8px;
            font-weight: 600;
            font-size: 16px;
        }
        
        .user-info-content p {
            color: #303f9f;
            margin: 0;
            font-size: 14px;
        }
        
        .user-email {
            color: #586BB4;
            font-weight: 600;
        }
        
        /* Session expired notice */
        .session-expired {
            background: linear-gradient(135deg, #ffebee, #fce4ec);
            border: 1px solid #ffab91;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
            position: relative;
        }
        
        .session-expired::before {
            content: "\f071";
            font-family: "FontAwesome";
            position: absolute;
            top: 20px;
            left: 20px;
            color: #f44336;
            font-size: 18px;
        }
        
        .session-expired-content {
            margin-left: 35px;
        }
        
        .session-expired h6 {
            color: #d32f2f;
            margin: 0 0 8px;
            font-weight: 600;
            font-size: 16px;
        }
        
        .session-expired p {
            color: #c62828;
            margin: 0;
            font-size: 14px;
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
        }
        
        /* Input group spacing */
        .input-group {
            margin-bottom: 25px;
        }
        
        .input-label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }
        
        .input-label i {
            margin-right: 5px;
            color: #586BB4;
        }
        
        .password-input {
            width: 100%;
            padding: 15px 20px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s ease;
            background-color: #fafafa;
            box-sizing: border-box;
            margin-bottom: 8px;
        }
        
        .password-input:focus {
            outline: none;
            border-color: #586BB4;
            background-color: white;
            box-shadow: 0 0 0 3px rgba(88, 107, 180, 0.15);
        }
        
        /* FIXED: Input help text - ensure block display */
        .input-help {
            font-size: 13px;
            color: #666;
            display: block;
            line-height: 1.4;
            margin-bottom: 0;
            padding-bottom: 8px;
        }
        
        .input-help i {
            margin-right: 5px;
            color: #586BB4;
        }
        
        /* FIXED: Password match indicator - Force new line with better separation */
        .validation-message {
            font-size: 13px;
            line-height: 1.4;
            min-height: 20px;
            display: block;
            margin-top: 0;
            margin-bottom: 0;
            padding-top: 0;
            width: 100%;
            clear: both;
            float: none;
        }
        
        .valid { 
            color: #4caf50; 
            font-weight: 500;
            display: block;
            margin-top: 5px;
        }
        
        .invalid { 
            color: #f44336; 
            font-weight: 500;
            display: block;
            margin-top: 5px;
        }
        
        .valid i, .invalid i {
            margin-right: 5px;
            font-size: 14px;
        }
        
        /* Ensure input feedback container forces block layout */
        .input-feedback-container {
            display: block;
            width: 100%;
            clear: both;
        }
        
        /* Button styles */
        .submit-section {
            margin-top: 30px;
        }
        
        .change-password-button {
            width: 100%;
            padding: 15px 25px;
            background: linear-gradient(135deg, #586BB4, #4a5aa3);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 54px;
        }
        
        .change-password-button:hover:not(:disabled) {
            background: linear-gradient(135deg, #4a5aa3, #3f4d8a);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(88, 107, 180, 0.4);
        }
        
        .change-password-button:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
            background: #cccccc !important;
        }
        
        .change-password-button i {
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
        
        /* Security tips */
        .security-tips {
            background: linear-gradient(135deg, #e8f5e9, #f1f8e9);
            border: 1px solid #a5d6a7;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
            position: relative;
        }
        
        .security-tips::before {
            content: "\f132";
            font-family: "FontAwesome";
            position: absolute;
            top: 20px;
            left: 20px;
            color: #4caf50;
            font-size: 18px;
        }
        
        .security-tips-content {
            margin-left: 35px;
        }
        
        .security-tips h6 {
            color: #2e7d32;
            margin: 0 0 10px;
            font-weight: 600;
            font-size: 16px;
        }
        
        .security-tips ul {
            color: #388e3c;
            margin: 0;
            padding-left: 20px;
            font-size: 14px;
            line-height: 1.5;
        }
        
        .security-tips li {
            margin-bottom: 5px;
        }
        
        /* Responsive design */
        @media (max-width: 576px) {
            .change-password-container {
                margin: 20px;
                border-radius: 8px;
            }
            
            .change-password-header {
                padding: 30px 20px 25px;
            }
            
            .change-password-header h3 {
                font-size: 24px;
            }
            
            .change-password-form-container {
                padding: 25px 20px;
            }
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
            
            <!-- Change Password area -->
            <div class="section-full content-inner shop-account">
                <!-- Product -->
                <div class="container">
                    <div class="change-password-container">
                        <!-- Header -->
                        <div class="change-password-header">
                            <i class="fa fa-key key-icon"></i>
                            <h3>Đặt Lại Mật Khẩu</h3>
                            <p>Tạo mật khẩu mới an toàn cho tài khoản của bạn</p>
                        </div>
                        
                        <!-- Form Container -->
                        <div class="change-password-form-container">
                            <!-- Session Expired Check -->
                            <c:if test="${empty sessionScope.resetEmail}">
                                <div class="session-expired">
                                    <div class="session-expired-content">
                                        <h6>Phiên Làm Việc Hết Hạn</h6>
                                        <p>Phiên đặt lại mật khẩu đã hết hạn. Vui lòng yêu cầu đặt lại mật khẩu mới.</p>
                                    </div>
                                </div>
                                
                                <div class="back-link">
                                    <a href="${pageContext.request.contextPath}/reset-password">
                                        <i class="fa fa-arrow-left"></i>
                                        Quay lại yêu cầu đặt lại mật khẩu
                                    </a>
                                </div>
                            </c:if>
                            
                            <!-- Valid Session - Show Form -->
                            <c:if test="${not empty sessionScope.resetEmail}">
                                <!-- User Info Section -->
                                <div class="user-info-section">
                                    <div class="user-info-content">
                                        <h6>Thông Tin Tài Khoản</h6>
                                        <p>Đặt lại mật khẩu cho: <span class="user-email">${sessionScope.resetEmail}</span></p>
                                    </div>
                                </div>
                                
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
                                        <div class="success-title">Thành Công!</div>
                                        <div class="success-message">${success}</div>
                                    </div>
                                </c:if>
                                
                                <!-- Security Tips -->
                                <div class="security-tips">
                                    <div class="security-tips-content">
                                        <h6>Mẹo Bảo Mật</h6>
                                        <ul>
                                            <li>Sử dụng ít nhất 6 ký tự</li>
                                            <li>Kết hợp chữ hoa, chữ thường, số và ký tự đặc biệt</li>
                                            <li>Không sử dụng thông tin cá nhân dễ đoán</li>
                                            <li>Không chia sẻ mật khẩu với ai</li>
                                        </ul>
                                    </div>
                                </div>
                                
                                <!-- Form Section -->
                                <div class="form-section">
                                    <h4>
                                        <i class="fa fa-lock"></i>
                                        TẠO MẬT KHẨU MỚI
                                    </h4>
                                    <p class="form-description">
                                        Nhập mật khẩu mới an toàn cho tài khoản của bạn.
                                    </p>
                                    
                                    <form id="passwordChangeForm" method="post" action="change-password">
                                        <!-- New Password Field -->
                                        <div class="input-group">
                                            <label class="input-label">
                                                <i class="fa fa-key"></i>
                                                MẬT KHẨU MỚI *
                                            </label>
                                            <input
                                                name="newPassword"
                                                id="newPassword"
                                                required="true"
                                                class="password-input"
                                                placeholder="Nhập mật khẩu mới"
                                                type="password"
                                                minlength="6"
                                            />
                                            <div class="input-help">
                                                <i class="fa fa-info-circle"></i>
                                                <span>Mật khẩu phải có ít nhất 6 ký tự</span>
                                            </div>
                                        </div>
                                        
                                        <!-- Confirm Password Field - UPDATED HTML STRUCTURE -->
                                        <div class="input-group">
                                            <label class="input-label">
                                                <i class="fa fa-check"></i>
                                                XÁC NHẬN MẬT KHẨU *
                                            </label>
                                            <input
                                                name="confirmPassword"
                                                id="confirmPassword"
                                                required="true"
                                                class="password-input"
                                                placeholder="Nhập lại mật khẩu mới"
                                                type="password"
                                                minlength="6"
                                            />
                                            <div class="input-feedback-container">
                                                <div class="input-help">
                                                    <i class="fa fa-info-circle"></i>
                                                    <span>Nhập lại mật khẩu để xác nhận</span>
                                                </div>
                                                <div id="passwordMatch" class="validation-message"></div>
                                            </div>
                                        </div>
                                        
                                        <div class="submit-section">
                                            <button type="submit" class="change-password-button" id="submitBtn" disabled>
                                                <i class="fa fa-save"></i>
                                                ĐẶT LẠI MẬT KHẨU
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
            <!-- Change Password area END -->
        </div>
        <!-- Content END-->
        
        <!-- Footer -->
        <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
        <!-- Footer END -->
        
        <button class="scroltop fa fa-chevron-up"></button>
    </div>
    
    <!-- JAVASCRIPT FILES -->
    <jsp:include page="/WEB-INF/view/common/home/js.jsp"></jsp:include>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('passwordChangeForm');
            const submitBtn = document.getElementById('submitBtn');
            const newPassword = document.getElementById('newPassword');
            const confirmPassword = document.getElementById('confirmPassword');
            const passwordMatch = document.getElementById('passwordMatch');
            
            if (form) {
                newPassword.focus();
                
                // Check password match
                function checkPasswordMatch() {
                    const password = newPassword.value;
                    const confirm = confirmPassword.value;
                    
                    if (confirm.length === 0) {
                        passwordMatch.innerHTML = '';
                        return false;
                    }
                    
                    if (password === confirm) {
                        passwordMatch.innerHTML = '<span class="valid"><i class="fa fa-check"></i> Mật khẩu khớp</span>';
                        return true;
                    } else {
                        passwordMatch.innerHTML = '<span class="invalid"><i class="fa fa-times"></i> Mật khẩu không khớp</span>';
                        return false;
                    }
                }
                
                // Validate form
                function validateForm() {
                    const password = newPassword.value;
                    const confirm = confirmPassword.value;
                    const isPasswordValid = password.length >= 6;
                    const isPasswordMatch = password === confirm && confirm.length > 0;
                    
                    submitBtn.disabled = !(isPasswordValid && isPasswordMatch);
                }
                
                // Event listeners
                newPassword.addEventListener('input', function() {
                    if (confirmPassword.value.length > 0) {
                        checkPasswordMatch();
                    }
                    validateForm();
                });
                
                confirmPassword.addEventListener('input', function() {
                    checkPasswordMatch();
                    validateForm();
                });
                
                // Form submission
                form.addEventListener('submit', function(e) {
                    const password = newPassword.value;
                    const confirm = confirmPassword.value;
                    
                    if (password !== confirm) {
                        e.preventDefault();
                        alert('Mật khẩu xác nhận không khớp. Vui lòng kiểm tra lại.');
                        confirmPassword.focus();
                        return;
                    }
                    
                    if (password.length < 6) {
                        e.preventDefault();
                        alert('Mật khẩu phải có ít nhất 6 ký tự.');
                        newPassword.focus();
                        return;
                    }
                    
                    // Show loading state
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<div class="loading-spinner"></div>ĐANG XỬ LÝ...';
                });
                
                // Initial validation
                validateForm();
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
