<%-- 
    Document   : profile
    Created on : Jun 4, 2025, 10:16:41 AM
    Author     : quang
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <title>BeautyZone : Hồ Sơ Cá Nhân</title>
        
        <!-- Include theme stylesheets like index.jsp -->
        <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp"></jsp:include>
        
        <!-- Font Awesome CDN fallback -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        
        <style>
            .profile-container {
                max-width: 600px;
                margin: 50px auto;
                padding: 30px;
                background: white;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                font-family: 'Inter', sans-serif !important;
                position: relative;
                z-index: 1;
            }
            
            /* Ensure proper spacing with header/footer */
            .page-content {
                min-height: calc(100vh - 200px);
                padding-top: 50px;
                padding-bottom: 50px;
            }
            
            .profile-header {
                background: #586BB4;
                color: white;
                padding: 30px;
                border-radius: 10px;
                margin-bottom: 30px;
                text-align: center;
            }
            
            .profile-header h1 {
                font-family: 'Inter', sans-serif !important;
                font-weight: 600;
                margin: 0;
                font-size: 2rem;
                line-height: 1.3;
            }
            
            .profile-container h3 {
                font-family: 'Inter', sans-serif !important;
                font-weight: 600;
                color: #333;
                margin-bottom: 20px;
                font-size: 1.5rem;
            }
            
            .info-item {
                display: flex;
                padding: 15px 0;
                border-bottom: 1px solid #eee;
                font-family: 'Inter', sans-serif !important;
            }
            
            .info-label {
                font-family: 'Inter', sans-serif !important;
                font-weight: 600;
                min-width: 150px;
                color: #333;
                font-size: 0.95rem;
            }
            
            .info-value {
                font-family: 'Inter', sans-serif !important;
                font-weight: 400;
                color: #666;
                font-size: 0.95rem;
                line-height: 1.6;
            }
            
            /* Ensure all text uses Inter font */
            * {
                font-family: 'Inter', sans-serif !important;
            }
            
            /* Fix Font Awesome icons - override Inter font for icons */
            .fa,
            i[class^="fa-"], 
            i[class*=" fa-"],
            .avatar-dropdown i,
            .header i {
                font-family: 'FontAwesome' !important;
                font-weight: normal !important;
                font-style: normal !important;
                text-decoration: none !important;
                display: inline-block !important;
                width: auto !important;
                line-height: 1 !important;
                vertical-align: baseline !important;
                speak: none !important;
                text-rendering: auto !important;
                -webkit-font-smoothing: antialiased !important;
                -moz-osx-font-smoothing: grayscale !important;
            }
            
            /* Force Font Awesome to work */
            .fa:before,
            i[class^="fa-"]:before, 
            i[class*=" fa-"]:before {
                font-family: 'FontAwesome' !important;
                font-weight: normal !important;
                display: inline-block !important;
            }
            
            /* Test icon visibility */
            .avatar-dropdown .fa {
                color: #333 !important;
                font-size: 14px !important;
                margin-right: 8px !important;
                width: 16px !important;
                text-align: center !important;
            }
            
            /* Debug: Add a test icon */
            .test-icon:before {
                content: "\f007" !important; /* fa-user */
                font-family: 'FontAwesome' !important;
                font-weight: normal !important;
                color: red !important;
            }
        </style>
    </head>

    <body id="bg">
        <div class="page-wraper">
            <div id="loading-area"></div>
            <jsp:include page="/WEB-INF/view/common/home/header.jsp"></jsp:include>
            <div class="page-content bg-white">
                <div class="profile-container">
            
            <!-- Profile Header -->
            <div class="profile-header">
                <h1>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            ${sessionScope.user.fullName}
                        </c:when>
                        <c:otherwise>
                            ${sessionScope.customer.fullName}
                        </c:otherwise>
                    </c:choose>
                </h1>
                <!-- Debug test icon -->
                <div style="color: white; margin-top: 10px;">
                    Test Icon: <i class="fa fa-user test-icon"></i> <span class="test-icon"></span>
                </div>
            </div>
            
            <!-- Basic Information -->
            <h3>Thông tin cá nhân</h3>
            
            <div class="info-item">
                <span class="info-label">Họ và tên:</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            ${sessionScope.user.fullName}
                        </c:when>
                        <c:otherwise>
                            ${sessionScope.customer.fullName}
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
            
            <div class="info-item">
                <span class="info-label">Email:</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            ${sessionScope.user.email}
                        </c:when>
                        <c:otherwise>
                            ${sessionScope.customer.email}
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
            
            <div class="info-item">
                <span class="info-label">Số điện thoại:</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            ${sessionScope.user.phoneNumber}
                        </c:when>
                        <c:otherwise>
                            ${sessionScope.customer.phoneNumber}
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
            
            <div class="info-item">
                <span class="info-label">Giới tính:</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <c:choose>
                                <c:when test="${sessionScope.user.gender == 'MALE'}">Nam</c:when>
                                <c:when test="${sessionScope.user.gender == 'FEMALE'}">Nữ</c:when>
                                <c:when test="${sessionScope.user.gender == 'OTHER'}">Khác</c:when>
                                <c:when test="${sessionScope.user.gender == 'UNKNOWN'}">Chưa cập nhật</c:when>
                                <c:when test="${empty sessionScope.user.gender}">Chưa cập nhật</c:when>
                                <c:otherwise>Khác</c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${sessionScope.customer.gender == 'MALE'}">Nam</c:when>
                                <c:when test="${sessionScope.customer.gender == 'FEMALE'}">Nữ</c:when>
                                <c:when test="${sessionScope.customer.gender == 'OTHER'}">Khác</c:when>
                                <c:when test="${sessionScope.customer.gender == 'UNKNOWN'}">Chưa cập nhật</c:when>
                                <c:when test="${empty sessionScope.customer.gender}">Chưa cập nhật</c:when>
                                <c:otherwise>Khác</c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
            
            <div class="info-item">
                <span class="info-label">Ngày sinh:</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            ${sessionScope.user.birthday}
                        </c:when>
                        <c:otherwise>
                            ${sessionScope.customer.birthday}
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
            
            <!-- Change Password Button -->
            <div style="margin-top: 30px; text-align: center;">
                <button onclick="window.location.href='${pageContext.request.contextPath}/profile/change-password'" 
                class="site-button   radius-no">ĐỔI MẬT KHẨU</button>


                <%-- <button onclick="window.location.href='${pageContext.request.contextPath}/profile/update-info'" 
                class="site-button  button-md radius-no">CẬP NHẬT THÔNG TIN</button> --%>
                
                <button onclick="window.location.href='${pageContext.request.contextPath}/'" 
                class="site-button   radius-no">QUAY VỀ TRANG CHỦ</button>
            </div>
            
                </div>
            </div>
            <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
            <button class="scroltop">↑</button>
        </div>
        <jsp:include page="/WEB-INF/view/common/home/js.jsp"></jsp:include>
    </body>
</html>
