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
                        this.style.borderColor = '#586BB4';
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
