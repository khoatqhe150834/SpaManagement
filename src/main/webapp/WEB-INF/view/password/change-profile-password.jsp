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
        
        <!-- Password Pages Specific CSS -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/home/css/password-pages.css">
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
                                            value="${attemptedCurrentPassword != null ? attemptedCurrentPassword : ''}"
                                        />
                                        <div class="validation-message" id="currentPasswordMessage" style="display: none;"></div>
                                        <%-- <div class="input-help">
                                            <i class="fa fa-info-circle"></i>
                                            <span>Mật khẩu bạn đang sử dụng</span>
                                        </div> --%>
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
                                            value="${attemptedNewPassword != null ? attemptedNewPassword : ''}"
                                        />
                                        <div class="validation-message" id="newPasswordMessage" style="display: none;"></div>
                                        <%-- <div class="input-help">
                                            <i class="fa fa-info-circle"></i>
                                            <span>Mật khẩu phải có ít nhất 6 ký tự</span>
                                        </div> --%>
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
                                            value="${attemptedConfirmPassword != null ? attemptedConfirmPassword : ''}"
                                        />
                                        <div class="validation-message" id="confirmPasswordMessage" style="display: none;"></div>
                                        <%-- <div class="input-help">
                                            <i class="fa fa-info-circle"></i>
                                            <span>Nhập lại mật khẩu để xác nhận</span>
                                        </div> --%>
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
    
    <!-- Password Change Validation Script -->
    <script src="${pageContext.request.contextPath}/assets/home/js/password/change-password-validation.js"></script>
    
    <!-- Handle preserved values after error -->
    <c:if test="${not empty error && (not empty attemptedCurrentPassword || not empty attemptedNewPassword || not empty attemptedConfirmPassword)}">
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Add visual feedback for preserved values
                const currentPassword = document.getElementById('currentPassword');
                const newPassword = document.getElementById('newPassword');
                const confirmPassword = document.getElementById('confirmPassword');
                
                // Style preserved fields
                if (currentPassword && currentPassword.value) {
                    currentPassword.style.backgroundColor = '#fff8e1';
                    currentPassword.style.borderColor = '#ff9800';
                    currentPassword.style.boxShadow = '0 0 5px rgba(255, 152, 0, 0.3)';
                }
                
                if (newPassword && newPassword.value) {
                    newPassword.style.backgroundColor = '#fff8e1';
                    newPassword.style.borderColor = '#ff9800';
                    newPassword.style.boxShadow = '0 0 5px rgba(255, 152, 0, 0.3)';
                }
                
                if (confirmPassword && confirmPassword.value) {
                    confirmPassword.style.backgroundColor = '#fff8e1';
                    confirmPassword.style.borderColor = '#ff9800';
                    confirmPassword.style.boxShadow = '0 0 5px rgba(255, 152, 0, 0.3)';
                }
                
                // Focus on the field that likely has the error (current password for wrong password error)
                if (currentPassword) {
                    currentPassword.focus();
                    currentPassword.select(); // Select the text so user can easily replace it
                }
            });
        </script>
    </c:if>
    
    <style>
        /* Styling for preserved input values */
        .password-input.preserved {
            background-color: #fff8e1 !important;
            border-color: #ff9800 !important;
            box-shadow: 0 0 5px rgba(255, 152, 0, 0.3) !important;
        }
        
        /* Error state styling */
        .password-input.error {
            background-color: #ffebee !important;
            border-color: #f44336 !important;
            box-shadow: 0 0 5px rgba(244, 67, 54, 0.3) !important;
        }
    </style>
    </body>
</html>
