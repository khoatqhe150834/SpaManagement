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
            /* Profile page integrated styling */
            .profile-banner {
                background: linear-gradient(135deg, #586BB4 0%, #455790 100%);
                position: relative;
                overflow: hidden;
                padding: 80px 0 60px;
                margin-bottom: 0;
            }
            
            .profile-banner:before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: url('${pageContext.request.contextPath}/assets/home/images/background/bg1.jpg') center/cover;
                opacity: 0.1;
                z-index: 1;
            }
            
            .profile-banner .container {
                position: relative;
                z-index: 2;
            }
            
            .profile-avatar {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.2);
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 20px;
                border: 4px solid rgba(255, 255, 255, 0.3);
                backdrop-filter: blur(10px);
            }
            
            .profile-avatar i {
                font-size: 48px;
                color: white;
                font-family: 'FontAwesome' !important;
            }
            
            .profile-banner h1 {
                color: white;
                font-size: 2.5rem;
                font-weight: 600;
                margin: 0 0 10px;
                text-align: center;
                text-shadow: 0 2px 10px rgba(0,0,0,0.3);
            }
            
            .profile-role {
                color: rgba(255, 255, 255, 0.9);
                font-size: 1.1rem;
                text-align: center;
                margin-bottom: 0;
            }
            
            .profile-content {
                padding: 60px 0;
                background: #f8f9fa;
            }
            
            .profile-info-card {
                background: white;
                border-radius: 15px;
                padding: 40px;
                box-shadow: 0 10px 40px rgba(0,0,0,0.1);
                margin-bottom: 30px;
                border-top: 4px solid #586BB4;
            }
            
            .profile-section-title {
                color: #586BB4;
                font-size: 1.5rem;
                font-weight: 600;
                margin-bottom: 30px;
                display: flex;
                align-items: center;
                padding-bottom: 15px;
                border-bottom: 2px solid #f0f0f0;
            }
            
            .profile-section-title i {
                font-size: 20px;
                margin-right: 10px;
                color: #586BB4;
                font-family: 'FontAwesome' !important;
            }
            
            .info-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 25px;
            }
            
            .info-item {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 10px;
                border-left: 4px solid #586BB4;
                transition: all 0.3s ease;
            }
            
            .info-item:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 20px rgba(88, 107, 180, 0.15);
            }
            
            .info-label {
                font-weight: 600;
                color: #586BB4;
                font-size: 0.9rem;
                margin-bottom: 5px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            
            .info-value {
                color: #333;
                font-size: 1.1rem;
                font-weight: 500;
            }
            
            .profile-actions {
                background: white;
                border-radius: 15px;
                padding: 30px;
                box-shadow: 0 10px 40px rgba(0,0,0,0.1);
                text-align: center;
            }
            
            .profile-actions .site-button {
                display: block;
                width: 100%;
                margin: 0 0 15px 0;
                padding: 15px 25px;
                font-weight: 600;
                letter-spacing: 0.5px;
                transition: all 0.3s ease;
                text-align: center;
                text-decoration: none;
                border: none;
                cursor: pointer;
                border-radius: 8px;
                font-size: 14px;
                text-transform: uppercase;
                position: relative;
                overflow: hidden;
            }
            
            /* Primary button (Change Password) */
            .profile-actions .site-button:not(.outline) {
                background: linear-gradient(135deg, #586BB4 0%, #455790 100%);
                color: white;
                border: 2px solid transparent;
                box-shadow: 0 4px 15px rgba(88, 107, 180, 0.3);
            }
            
            .profile-actions .site-button:not(.outline):hover {
                background: linear-gradient(135deg, #455790 0%, #3a4a7a 100%);
                transform: translateY(-3px);
                box-shadow: 0 6px 20px rgba(88, 107, 180, 0.4);
            }
            
            /* Outline buttons */
            .profile-actions .site-button.outline {
                background: transparent;
                color: #586BB4;
                border: 2px solid #586BB4;
                box-shadow: 0 2px 10px rgba(88, 107, 180, 0.1);
            }
            
            .profile-actions .site-button.outline:hover {
                background: #586BB4;
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(88, 107, 180, 0.3);
            }
            
            .profile-actions .site-button:last-child {
                margin-bottom: 0;
            }
            
            .profile-actions .site-button i {
                font-family: 'FontAwesome' !important;
                margin-right: 8px;
                font-size: 14px;
                vertical-align: middle;
            }
            
            /* Button active state */
            .profile-actions .site-button:active {
                transform: translateY(0);
            }
            
            /* Loading state for buttons */
            .profile-actions .site-button:focus {
                outline: none;
                box-shadow: 0 0 0 3px rgba(88, 107, 180, 0.2);
            }
            
            .stats-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
                margin-bottom: 30px;
            }
            
            .stat-card {
                background: white;
                padding: 25px;
                border-radius: 12px;
                text-align: center;
                box-shadow: 0 5px 20px rgba(0,0,0,0.08);
                border-top: 3px solid #586BB4;
            }
            
            .stat-number {
                font-size: 2rem;
                font-weight: 700;
                color: #586BB4;
                margin-bottom: 5px;
            }
            
            .stat-label {
                color: #666;
                font-size: 0.9rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            
            /* Responsive design */
            @media (max-width: 768px) {
                .profile-banner {
                    padding: 60px 0 40px;
                }
                
                .profile-banner h1 {
                    font-size: 2rem;
                }
                
                .profile-avatar {
                    width: 100px;
                    height: 100px;
                }
                
                .profile-avatar i {
                    font-size: 36px;
                }
                
                .profile-info-card {
                    padding: 25px;
                }
                
                .info-grid {
                    grid-template-columns: 1fr;
                }
                
                .profile-actions .site-button {
                    width: 100%;
                    margin: 0 0 12px 0;
                    padding: 12px 20px;
                    font-size: 13px;
                }
                
                .profile-actions .site-button i {
                    font-size: 13px;
                    margin-right: 6px;
                }
                
                .stats-grid {
                    grid-template-columns: 1fr 1fr;
                    margin-bottom: 30px;
                }
            }
            
            /* Fix Font Awesome icons */
            .fa,
            i[class^="fa-"], 
            i[class*=" fa-"] {
                font-family: 'FontAwesome' !important;
                font-weight: normal !important;
                font-style: normal !important;
            }
        </style>
    </head>

    <body id="bg">
        <div class="page-wraper">
            <div id="loading-area"></div>
            <jsp:include page="/WEB-INF/view/common/home/header.jsp"></jsp:include>
            
            <!-- Profile Banner Section -->
            <div class="profile-banner">
                <div class="container">
                    <div class="profile-avatar">
                        <i class="fa fa-user"></i>
                    </div>
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
                    <p class="profile-role">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                Nhân viên
                            </c:when>
                            <c:otherwise>
                                Khách hàng thân thiết
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>
            
            <!-- Profile Content Section -->
            <div class="profile-content">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-8 col-md-12">
                            <!-- Personal Information Card -->
                            <div class="profile-info-card">
                                <div class="profile-section-title">
                                    <i class="fa fa-user"></i>
                                    Thông tin cá nhân
                                </div>
                                
                                <div class="info-grid">
                                    <div class="info-item">
                                        <div class="info-label">Họ và tên</div>
                                        <div class="info-value">
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.user}">
                                                    ${sessionScope.user.fullName}
                                                </c:when>
                                                <c:otherwise>
                                                    ${sessionScope.customer.fullName}
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    
                                    <div class="info-item">
                                        <div class="info-label">Email</div>
                                        <div class="info-value">
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.user}">
                                                    ${sessionScope.user.email}
                                                </c:when>
                                                <c:otherwise>
                                                    ${sessionScope.customer.email}
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    
                                    <div class="info-item">
                                        <div class="info-label">Số điện thoại</div>
                                        <div class="info-value">
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.user}">
                                                    ${sessionScope.user.phoneNumber}
                                                </c:when>
                                                <c:otherwise>
                                                    ${sessionScope.customer.phoneNumber}
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    
                                    <div class="info-item">
                                        <div class="info-label">Giới tính</div>
                                        <div class="info-value">
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
                                        </div>
                                    </div>
                                    
                                    <div class="info-item">
                                        <div class="info-label">Ngày sinh</div>
                                        <div class="info-value">
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.user}">
                                                    <c:choose>
                                                        <c:when test="${not empty sessionScope.user.birthday}">
                                                            ${sessionScope.user.birthday}
                                                        </c:when>
                                                        <c:otherwise>
                                                            Chưa cập nhật
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:choose>
                                                        <c:when test="${not empty sessionScope.customer.birthday}">
                                                            ${sessionScope.customer.birthday}
                                                        </c:when>
                                                        <c:otherwise>
                                                            Chưa cập nhật
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    
                                    <div class="info-item">
                                        <div class="info-label">Trạng thái tài khoản</div>
                                        <div class="info-value" style="color: #28a745; font-weight: 600;">
                                            Đang hoạt động
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-lg-4 col-md-12">
                            <!-- Quick Stats -->
                            <c:if test="${not empty sessionScope.customer}">
                                <div class="stats-grid">
                                    <div class="stat-card">
                                        <div class="stat-number">0</div>
                                        <div class="stat-label">Lịch hẹn</div>
                                    </div>
                                    <div class="stat-card">
                                        <div class="stat-number">0</div>
                                        <div class="stat-label">Điểm tích lũy</div>
                                    </div>
                                </div>
                            </c:if>
                            
                            <!-- Action Buttons -->
                            <div class="profile-actions">
                                <div class="profile-section-title">
                                    <i class="fa fa-cog"></i>
                                    Hành động
                                </div>
                                
                                <a href="${pageContext.request.contextPath}/profile/change-password" 
                                   class="site-button radius-no">
                                    <i class="fa fa-lock" style="margin-right: 8px;"></i>
                                    ĐỔI MẬT KHẨU
                                </a>
                                
                                <c:if test="${not empty sessionScope.customer}">
                                    <a href="${pageContext.request.contextPath}/appointment" 
                                       class="site-button outline radius-no">
                                        <i class="fa fa-calendar" style="margin-right: 8px;"></i>
                                        ĐẶT LỊCH HẸN
                                    </a>
                                </c:if>
                                
                                <a href="${pageContext.request.contextPath}/" 
                                   class="site-button outline radius-no">
                                    <i class="fa fa-home" style="margin-right: 8px;"></i>
                                    TRANG CHỦ
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
            <button class="scroltop" style="color: #586BB4;">
                <i class="fa fa-chevron-up"></i>
            </button>
        </div>
        <jsp:include page="/WEB-INF/view/common/home/js.jsp"></jsp:include>
    </body>
</html>
