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
        <meta name="description" content="BeautyZone : Kết quả xác thực email" />
        <meta property="og:title" content="BeautyZone : Kết quả xác thực email" />
        <meta property="og:description" content="BeautyZone : Kết quả xác thực email" />
        <meta name="format-detection" content="telephone=no" />

        <link rel="icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.png" />

        <title>Kết quả xác thực | BeautyZone</title>

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
            .error-icon {
                width: 100px;
                height: 100px;
                background: #dc3545;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 30px;
                color: white;
                font-size: 50px;
                box-shadow: 0 5px 15px rgba(220, 53, 69, 0.3);
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
            .success-alert {
                background: #d4edda;
                border: 1px solid #c3e6cb;
                color: #155724;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 30px;
            }
            .error-alert {
                background: #f8d7da;
                border: 1px solid #f5c6cb;
                color: #721c24;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 30px;
            }
            .warning-alert {
                background: #fff3cd;
                border: 1px solid #ffeaa7;
                color: #856404;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 30px;
            }
            .verification-alert h5 {
                font-weight: 600;
                margin-bottom: 15px;
            }
            .verification-alert p {
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
                                <% if (request.getAttribute("success") != null) { %>
                                    <div class="success-icon">
                                        ✓
                                    </div>
                                    <h2 class="verification-title text-success">Xác thực thành công!</h2>
                                    <div class="success-alert verification-alert">
                                        <h5>Chúc mừng!</h5>
                                        <p><%= request.getAttribute("success") %></p>
                                        <% if (request.getAttribute("email") != null) { %>
                                            <p class="mb-0">Email: <span class="email-highlight"><%= request.getAttribute("email") %></span></p>
                                        <% } %>
                                    </div>
                                    <div class="button-group">
                                        <a href="${pageContext.request.contextPath}/" class="site-button radius-no">Quay về trang chủ</a>
                                    </div>
                                <% } else if (request.getAttribute("error") != null) { %>
                                    <div class="error-icon">
                                        ✗
                                    </div>
                                    <h2 class="verification-title text-danger">Xác thực thất bại!</h2>
                                    <div class="error-alert verification-alert">
                                        <h5>Có lỗi xảy ra</h5>
                                        <p><%= request.getAttribute("error") %></p>
                                    </div>
                                    <div class="button-group">
                                        <a href="${pageContext.request.contextPath}/register" class="site-button radius-no">Đăng ký lại</a>
                                        <a href="${pageContext.request.contextPath}/" class="site-button radius-no">Về trang chủ</a>
                                    </div>
                                <% } else { %>
                                    <div class="warning-icon">
                                        ?
                                    </div>
                                    <h2 class="verification-title">Không có thông tin</h2>
                                    <div class="warning-alert verification-alert">
                                        <p>Không có thông tin xác thực.</p>
                                    </div>
                                    <div class="button-group">
                                        <a href="${pageContext.request.contextPath}/" class="site-button radius-no">Về trang chủ</a>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
            <button class="scroltop">↑</button>
        </div>

        <jsp:include page="/WEB-INF/view/common/home/js.jsp"></jsp:include>
    </body>
</html> 