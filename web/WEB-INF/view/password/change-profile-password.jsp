<%-- 
    Document   : change-profile-password
    Created on : Jun 4, 2025, 8:35:44 AM
    Author     : quang
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="keywords" content="" />
        <meta name="author" content="" />
        <meta name="robots" content="" />
        <meta name="description" content="BeautyZone : Đổi Mật Khẩu Tài Khoản" />
        <meta property="og:title" content="BeautyZone : Đổi Mật Khẩu Tài Khoản" />
        <meta property="og:description" content="BeautyZone : Đổi Mật Khẩu Tài Khoản" />
        <meta property="og:image" content="../../beautyzone.dexignzone.com/xhtml/social-image.png" />
        <meta name="format-detection" content="telephone=no" />

        <!-- FAVICONS ICON -->
        <link rel="icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.png" />
        
        <!-- PAGE TITLE HERE -->
        <title>Đổi Mật Khẩu - BeautyZone Spa</title>

        <!-- MOBILE SPECIFIC -->
        <meta name="viewport" content="width=device-width, initial-scale=1" />

        <!--[if lt IE 9]>
          <script src="js/html5shiv.min.js"></script>
          <script src="js/respond.min.js"></script>
        <![endif]-->

        <!-- STYLESHEETS -->
        <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp"></jsp:include>
        
        <style>
            /* Custom styles for change password page */
            .page-content {
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }
            
            .section-full {
                flex: 1;
                padding: 60px 0;
            }
            
            /* Main container */
            .change-password-container {
                max-width: 600px;
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
                background: linear-gradient(135deg, #c59952, #b8893b);
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
                font-family: 'Montserrat', sans-serif;
            }
            
            .change-password-header p {
                margin: 0;
                opacity: 0.9;
                font-size: 16px;
            }
            
            /* Form container */
            .change-password-form-container {
                padding: 40px 30px;
            }
            
            /* User info section */
            .user-info-section {
                background: linear-gradient(135deg, #f8f4e6, #faf7ed);
                border: 1px solid #e6d7b3;
                border-radius: 8px;
                padding: 25px;
                margin-bottom: 30px;
                position: relative;
            }
            
            .user-info-section::before {
                content: "\f007";
                font-family: "FontAwesome";
                position: absolute;
                top: 25px;
                left: 25px;
                color: #c59952;
                font-size: 18px;
            }
            
            .user-info-content {
                margin-left: 35px;
            }
            
            .user-info-content h6 {
                color: #8b6914;
                margin: 0 0 10px;
                font-weight: 600;
                font-size: 16px;
                font-family: 'Montserrat', sans-serif;
            }
            
            .user-info-content p {
                color: #6d5a2e;
                margin: 5px 0;
                font-size: 14px;
            }
            
            .user-email, .user-name {
                color: #c59952;
                font-weight: 600;
            }
            
            /* Alert styles */
            .alert {
                border-radius: 8px;
                padding: 20px 25px;
                margin-bottom: 25px;
                border: 1px solid;
                display: flex;
                align-items: flex-start;
                font-family: 'Montserrat', sans-serif;
            }
            
            .alert i {
                margin-right: 10px;
                margin-top: 2px;
                flex-shrink: 0;
                font-size: 18px;
            }
            
            .alert-danger {
                background-color: #ffebee;
                border-color: #ffcdd2;
                color: #c62828;
            }
            
            .alert-success {
                background-color: #e8f5e9;
                border-color: #a5d6a7;
                color: #2e7d32;
            }
            
            /* Form styles */
            .form-section h4 {
                color: #333;
                margin-bottom: 20px;
                font-size: 22px;
                font-weight: 600;
                display: flex;
                align-items: center;
                font-family: 'Montserrat', sans-serif;
                text-transform: uppercase;
            }
            
            .form-section h4 i {
                margin-right: 10px;
                color: #c59952;
            }
            
            .form-description {
                color: #666;
                margin-bottom: 30px;
                font-size: 15px;
                line-height: 1.6;
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
                text-transform: uppercase;
                font-family: 'Montserrat', sans-serif;
            }
            
            .input-label i {
                margin-right: 8px;
                color: #c59952;
            }
            
            .password-input {
                width: 100%;
                padding: 15px 20px;
                border: 2px solid #e6d7b3;
                border-radius: 8px;
                font-size: 16px;
                transition: all 0.3s ease;
                background-color: #fafafa;
                box-sizing: border-box;
                font-family: inherit;
            }
            
            .password-input:focus {
                outline: none;
                border-color: #c59952;
                background-color: white;
                box-shadow: 0 0 0 3px rgba(197, 153, 82, 0.15);
            }
            
            .input-help {
                font-size: 13px;
                color: #666;
                margin-top: 5px;
                display: block;
            }
            
            /* Button styles */
            .submit-section {
                margin-top: 30px;
                text-align: center;
            }
            
            .change-password-button {
                background: linear-gradient(135deg, #c59952, #b8893b);
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-height: 54px;
                padding: 15px 30px;
                text-transform: uppercase;
                font-family: 'Montserrat', sans-serif;
                letter-spacing: 1px;
            }
            
            .change-password-button:hover:not(:disabled) {
                background: linear-gradient(135deg, #b8893b, #a67829);
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(197, 153, 82, 0.4);
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
            
            /* Back link */
            .back-link {
                text-align: center;
                margin-top: 25px;
                padding-top: 20px;
                border-top: 1px solid #f0f0f0;
            }
            
            .back-link a {
                color: #c59952;
                text-decoration: none;
                font-size: 14px;
                transition: color 0.3s ease;
                display: inline-flex;
                align-items: center;
                font-weight: 500;
            }
            
            .back-link a:hover {
                color: #b8893b;
            }
            
            .back-link a i {
                margin-right: 5px;
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
                    padding: 30px 20px;
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
                        <h1 class="text-white">Đổi Mật Khẩu</h1>
                        <!-- Breadcrumb row -->
                        <div class="breadcrumb-row">
                            <ul class="list-inline">
                                <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                                <li><a href="#" onclick="history.back()">Tài khoản</a></li>
                                <li>Đổi mật khẩu</li>
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
                            <h3>Đổi Mật Khẩu Tài Khoản</h3>
                            <p>Cập nhật mật khẩu mới cho tài khoản của bạn</p>
                        </div>
                        
                        <!-- Form Container -->
                        <div class="change-password-form-container">
                            <!-- User Info Section -->
                            <div class="user-info-section">
                                <div class="user-info-content">
                                    <h6>Thông Tin Tài Khoản</h6>
                                    <p><strong>Loại tài khoản:</strong> 
                                        <span class="text-primary">
                                            <c:choose>
                                                <c:when test="${sessionScope.userType == 'ADMIN'}">Quản trị viên</c:when>
                                                <c:when test="${sessionScope.userType == 'MANAGER'}">Quản lý</c:when>
                                                <c:when test="${sessionScope.userType == 'THERAPIST'}">Kỹ thuật viên</c:when>
                                                <c:when test="${sessionScope.userType == 'RECEPTIONIST'}">Lễ tân</c:when>
                                                <c:when test="${sessionScope.userType == 'CUSTOMER'}">Khách hàng</c:when>
                                                <c:otherwise>${sessionScope.userType}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </p>
                                    
                                    <!-- Display user/customer name and email -->
                                    <c:if test="${not empty sessionScope.user}">
                                        <p><strong>Tên:</strong> <span class="user-name">${sessionScope.user.fullName}</span></p>
                                        <p><strong>Email:</strong> <span class="user-email">${sessionScope.user.email}</span></p>
                                    </c:if>
                                    <c:if test="${not empty sessionScope.customer}">
                                        <p><strong>Tên:</strong> <span class="user-name">${sessionScope.customer.fullName}</span></p>
                                        <p><strong>Email:</strong> <span class="user-email">${sessionScope.customer.email}</span></p>
                                    </c:if>
                                </div>
                            </div>
                            
                            <!-- Display Success Message -->
                            <c:if test="${not empty success}">
                                <div class="alert alert-success">
                                    <i class="fa fa-check-circle"></i>
                                    <span><strong>Thành công!</strong> ${success}</span>
                                </div>
                            </c:if>
                            
                            <!-- Display Error Message -->
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger">
                                    <i class="fa fa-exclamation-triangle"></i>
                                    <span><strong>Lỗi!</strong> ${error}</span>
                                </div>
                            </c:if>
                            
                            <!-- Form Section -->
                            <div class="form-section">
                                <h4>
                                    <i class="fa fa-lock"></i>
                                    Cập Nhật Mật Khẩu
                                </h4>
                                <p class="form-description">
                                    Nhập mật khẩu hiện tại và mật khẩu mới để cập nhật bảo mật tài khoản.
                                </p>
                                
                                <form id="passwordChangeForm" method="post" action="${pageContext.request.contextPath}/profile/change-password">
                                    <!-- Current Password Field -->
                                    <div class="input-group">
                                        <label class="input-label">
                                            <i class="fa fa-unlock-alt"></i>
                                            Mật khẩu hiện tại *
                                        </label>
                                        <input
                                            type="password"
                                            id="currentPassword"
                                            name="currentPassword"
                                            required
                                            class="password-input"
                                            placeholder="Nhập mật khẩu hiện tại"
                                        />
                                        <div class="input-help">
                                            <i class="fa fa-info-circle"></i>
                                            <span>Mật khẩu bạn đang sử dụng</span>
                                        </div>
                                    </div>
                                    
                                    <!-- New Password Field -->
                                    <div class="input-group">
                                        <label class="input-label">
                                            <i class="fa fa-key"></i>
                                            Mật khẩu mới *
                                        </label>
                                        <input
                                            type="password"
                                            id="newPassword"
                                            name="newPassword"
                                            required
                                            minlength="6"
                                            class="password-input"
                                            placeholder="Nhập mật khẩu mới"
                                        />
                                        <div class="input-help">
                                            <i class="fa fa-info-circle"></i>
                                            <span>Mật khẩu phải có ít nhất 6 ký tự</span>
                                        </div>
                                    </div>
                                    
                                    <!-- Confirm Password Field -->
                                    <div class="input-group">
                                        <label class="input-label">
                                            <i class="fa fa-check"></i>
                                            Xác nhận mật khẩu mới *
                                        </label>
                                        <input
                                            type="password"
                                            id="confirmPassword"
                                            name="confirmPassword"
                                            required
                                            minlength="6"
                                            class="password-input"
                                            placeholder="Nhập lại mật khẩu mới"
                                        />
                                        <div class="input-help">
                                            <i class="fa fa-info-circle"></i>
                                            <span>Nhập lại mật khẩu để xác nhận</span>
                                        </div>
                                    </div>
                                    
                                    <div class="submit-section">
                                        <button type="submit" class="change-password-button" id="submitBtn">
                                            <i class="fa fa-save"></i>
                                            Cập Nhật Mật Khẩu
                                        </button>
                                    </div>
                                </form>
                            </div>
                            
                            <div class="back-link">
                                <a href="${pageContext.request.contextPath}/">
                                    <i class="fa fa-arrow-left"></i>
                                    Quay lại trang chủ
                                </a>
                            </div>
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
            
            if (form) {
                // Focus on current password field
                document.getElementById('currentPassword').focus();
                
                // Form submission validation
                form.addEventListener('submit', function(e) {
                    const currentPassword = document.getElementById('currentPassword').value;
                    const newPassword = document.getElementById('newPassword').value;
                    const confirmPassword = document.getElementById('confirmPassword').value;
                    
                    if (!currentPassword || !newPassword || !confirmPassword) {
                        e.preventDefault();
                        alert('Vui lòng điền đầy đủ tất cả các trường!');
                        return;
                    }
                    
                    if (newPassword !== confirmPassword) {
                        e.preventDefault();
                        alert('Mật khẩu mới và xác nhận mật khẩu không khớp!');
                        document.getElementById('confirmPassword').focus();
                        return;
                    }
                    
                    if (newPassword.length < 6) {
                        e.preventDefault();
                        alert('Mật khẩu mới phải có ít nhất 6 ký tự!');
                        document.getElementById('newPassword').focus();
                        return;
                    }
                    
                    // Show loading state
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> ĐANG XỬ LÝ...';
                });
                
                // Real-time password confirmation validation
                document.getElementById('confirmPassword').addEventListener('input', function() {
                    const newPassword = document.getElementById('newPassword').value;
                    const confirmPassword = this.value;
                    
                    if (confirmPassword && newPassword !== confirmPassword) {
                        this.style.borderColor = '#f44336';
                    } else {
                        this.style.borderColor = '#c59952';
                    }
                });
            }
            
            // Auto-hide alerts after 8 seconds
            setTimeout(function() {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(function(alert) {
                    alert.style.transition = 'opacity 0.5s ease';
                    alert.style.opacity = '0';
                    setTimeout(() => alert.remove(), 500);
                });
            }, 8000);
        });
    </script>
    </body>
</html>
