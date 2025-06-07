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
                                            <%-- <div class="input-help">
                                                <i class="fa fa-info-circle"></i>
                                                Email phải đã được đăng ký trong hệ thống của chúng tôi
                                            </div> --%>
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
