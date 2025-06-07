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
        
        <!-- Validation Message Styles -->
        <style>
            .validation-message {
                color: #f44336;
                font-size: 14px;
                margin-top: 5px;
                padding: 5px 0;
                display: flex;
                align-items: center;
                gap: 5px;
            }
            
            .validation-message.success {
                color: #4CAF50;
            }
            
            .validation-message i {
                font-size: 12px;
            }
            
            .password-input.error {
                border-color: #f44336 !important;
                box-shadow: 0 0 5px rgba(244, 67, 54, 0.3);
            }
            
            .password-input.success {
                border-color: #4CAF50 !important;
                box-shadow: 0 0 5px rgba(76, 175, 80, 0.3);
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
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('passwordChangeForm');
            const submitBtn = document.getElementById('submitBtn');
            
            // Validation message utility functions
            function showErrorMessage(fieldId, message) {
                const field = document.getElementById(fieldId);
                const messageElement = document.getElementById(fieldId + 'Message');
                
                field.classList.remove('success');
                field.classList.add('error');
                messageElement.innerHTML = '<i class="fa fa-exclamation-circle"></i>' + message;
                messageElement.className = 'validation-message';
                messageElement.style.display = 'flex';
            }
            
            function showSuccessMessage(fieldId, message) {
                const field = document.getElementById(fieldId);
                const messageElement = document.getElementById(fieldId + 'Message');
                
                field.classList.remove('error');
                field.classList.add('success');
                messageElement.innerHTML = '<i class="fa fa-check-circle"></i>' + message;
                messageElement.className = 'validation-message success';
                messageElement.style.display = 'flex';
            }
            
            function hideMessage(fieldId) {
                const field = document.getElementById(fieldId);
                const messageElement = document.getElementById(fieldId + 'Message');
                
                field.classList.remove('error', 'success');
                messageElement.style.display = 'none';
            }
            
            if (form) {
                // Focus on current password field
                document.getElementById('currentPassword').focus();
                
                // Real-time validation for current password
                document.getElementById('currentPassword').addEventListener('input', function() {
                    const currentPassword = this.value.trim();
                    
                    if (currentPassword === '') {
                        hideMessage('currentPassword');
                    } else if (currentPassword.length < 6) {
                        showErrorMessage('currentPassword', 'Mật khẩu hiện tại phải có ít nhất 6 ký tự');
                    } else {
                        hideMessage('currentPassword');
                    }
                });
                
                // Real-time validation for new password
                document.getElementById('newPassword').addEventListener('input', function() {
                    const currentPassword = document.getElementById('currentPassword').value;
                    const newPassword = this.value.trim();
                    
                    if (newPassword === '') {
                        hideMessage('newPassword');
                    } else if (newPassword.length < 6) {
                        showErrorMessage('newPassword', 'Mật khẩu mới phải có ít nhất 6 ký tự');
                    } else if (currentPassword && newPassword === currentPassword) {
                        showErrorMessage('newPassword', 'Mật khẩu mới phải khác với mật khẩu hiện tại');
                    } else {
                        showSuccessMessage('newPassword', 'Mật khẩu mới hợp lệ');
                    }
                    
                    // Re-validate confirm password if it has value
                    const confirmPassword = document.getElementById('confirmPassword').value;
                    if (confirmPassword) {
                        validateConfirmPassword();
                    }
                });
                
                // Real-time validation for confirm password
                function validateConfirmPassword() {
                    const newPassword = document.getElementById('newPassword').value;
                    const confirmPassword = document.getElementById('confirmPassword').value;
                    
                    if (confirmPassword === '') {
                        hideMessage('confirmPassword');
                    } else if (confirmPassword.length < 6) {
                        showErrorMessage('confirmPassword', 'Xác nhận mật khẩu phải có ít nhất 6 ký tự');
                    } else if (newPassword !== confirmPassword) {
                        showErrorMessage('confirmPassword', 'Xác nhận mật khẩu không khớp với mật khẩu mới');
                    } else {
                        showSuccessMessage('confirmPassword', 'Xác nhận mật khẩu khớp');
                    }
                }
                
                document.getElementById('confirmPassword').addEventListener('input', validateConfirmPassword);
                
                // Form submission validation
                form.addEventListener('submit', function(e) {
                    const currentPassword = document.getElementById('currentPassword').value.trim();
                    const newPassword = document.getElementById('newPassword').value.trim();
                    const confirmPassword = document.getElementById('confirmPassword').value.trim();
                    
                    let hasErrors = false;
                    
                    // Validate current password
                    if (!currentPassword) {
                        showErrorMessage('currentPassword', 'Vui lòng nhập mật khẩu hiện tại');
                        hasErrors = true;
                    } else if (currentPassword.length < 6) {
                        showErrorMessage('currentPassword', 'Mật khẩu hiện tại phải có ít nhất 6 ký tự');
                        hasErrors = true;
                    }
                    
                    // Validate new password
                    if (!newPassword) {
                        showErrorMessage('newPassword', 'Vui lòng nhập mật khẩu mới');
                        hasErrors = true;
                    } else if (newPassword.length < 6) {
                        showErrorMessage('newPassword', 'Mật khẩu mới phải có ít nhất 6 ký tự');
                        hasErrors = true;
                    } else if (currentPassword === newPassword) {
                        showErrorMessage('newPassword', 'Mật khẩu mới phải khác với mật khẩu hiện tại');
                        hasErrors = true;
                    }
                    
                    // Validate confirm password
                    if (!confirmPassword) {
                        showErrorMessage('confirmPassword', 'Vui lòng nhập xác nhận mật khẩu');
                        hasErrors = true;
                    } else if (confirmPassword.length < 6) {
                        showErrorMessage('confirmPassword', 'Xác nhận mật khẩu phải có ít nhất 6 ký tự');
                        hasErrors = true;
                    } else if (newPassword !== confirmPassword) {
                        showErrorMessage('confirmPassword', 'Xác nhận mật khẩu không khớp với mật khẩu mới');
                        hasErrors = true;
                    }
                    
                    if (hasErrors) {
                        e.preventDefault();
                        // Focus on first error field
                        const firstErrorField = document.querySelector('.password-input.error');
                        if (firstErrorField) {
                            firstErrorField.focus();
                        }
                        return;
                    }
                    
                    // Show loading state
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> ĐANG XỬ LÝ...';
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
