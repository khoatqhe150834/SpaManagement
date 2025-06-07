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
        <meta name="description" content="BeautyZone : Đăng ký thành công" />
        <meta property="og:title" content="BeautyZone : Đăng ký thành công" />
        <meta property="og:description" content="BeautyZone : Đăng ký thành công" />
        <meta name="format-detection" content="telephone=no" />

        <link rel="icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.png" />

        <title>Đăng ký thành công | BeautyZone</title>

        <meta name="viewport" content="width=device-width, initial-scale=1" />

        <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp"></jsp:include>

        <style>
            .page-content {
                padding-top: 120px; /* Add space for fixed header */
            }
            .success-container {
                min-height: 70vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 40px 0;
            }
            .success-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                padding: 40px;
                max-width: 600px;
                width: 100%;
                text-align: center;
            }
            .success-icon {
                width: 100px;
                height: 100px;
                background: #28a745;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 30px;
                color: white;
                font-size: 50px;
                box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
            }
            .success-title {
                color: #333;
                font-size: 2.5rem;
                font-weight: 600;
                margin-bottom: 20px;
            }
            .success-alert {
                background: #d4edda;
                border: 1px solid #c3e6cb;
                color: #155724;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 30px;
            }
            .success-alert h5 {
                color: #155724;
                font-weight: 600;
                margin-bottom: 15px;
            }
            .success-alert p {
                margin-bottom: 10px;
                line-height: 1.6;
            }
            .success-alert hr {
                border-color: #c3e6cb;
                margin: 15px 0;
            }
            .email-highlight {
                color: #007bff;
                font-weight: 600;
            }
            .action-links {
                margin-top: 20px;
            }
            .action-links p {
                margin-bottom: 10px;
            }
            .action-links a {
                color: #007bff;
                text-decoration: none;
                font-weight: 500;
            }
            .action-links a:hover {
                text-decoration: underline;
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
        </style>
    </head>

    <body id="bg">
        <div class="page-wraper">
            <div id="loading-area"></div>
            <jsp:include page="/WEB-INF/view/common/home/header.jsp"></jsp:include>
            
            <div class="page-content bg-white">
                <div class="section-full">
                    <div class="container">
                        <div class="success-container">
                            <div class="success-card">
                                <div class="success-icon">
                                    ✓
                                </div>
                                <h2 class="success-title">Đăng ký thành công!</h2>
                                <div class="success-alert">
                                    <h5>Chào mừng bạn đến với BeautyZone!</h5>
                                    <p>Chúng tôi đã gửi một email xác thực đến địa chỉ email <span class="email-highlight">${email}</span>.</p>
                                    <hr>
                                    <p class="mb-0">Vui lòng kiểm tra hộp thư của bạn và nhấp vào liên kết xác thực để hoàn tất quá trình đăng ký.</p>
                                </div>
                                <div class="action-links">
                                    <p>Chưa nhận được email? <a href="#" id="resendEmail">Gửi lại email xác thực</a></p>
                                    <p>Hoặc <a href="${pageContext.request.contextPath}/login">đăng nhập</a> nếu bạn đã xác thực tài khoản.</p>
                                </div>
                                <div class="mt-4">
                                    <a href="${pageContext.request.contextPath}/login" class="site-button radius-no">Đăng nhập</a>
                                    <a href="${pageContext.request.contextPath}/" class="site-button radius-no">Về trang chủ</a>
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
                // Handle resend verification email
                $("#resendEmail").click(function(e) {
                    e.preventDefault();
                    alert("Chức năng gửi lại email xác thực sẽ được triển khai sau!");
                });
            });
        </script>
    </body>
</html> 