<%-- 
    Document   : booking-group.jsp
    Created on : Group Booking Page
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Đặt Lịch Hẹn Theo Nhóm - BeautyZone Spa</title>
    
    <!-- Include Home Framework Styles -->
    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp" />
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
            <div class="dlab-bnr-inr overlay-primary bg-pt" style="background-image: url(${pageContext.request.contextPath}/assets/home/images/banner/bnr2.jpg);">
                <div class="container">
                    <div class="dlab-bnr-inr-entry">
                        <h1 class="text-white">Đặt Lịch Hẹn Theo Nhóm</h1>
                        <!-- Breadcrumb row -->
                        <div class="breadcrumb-row">
                            <ul class="list-inline">
                                <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                                <li><a href="${pageContext.request.contextPath}/customer-dashboard">Bảng Điều Khiển</a></li>
                                <li><a href="${pageContext.request.contextPath}/appointments/booking-selection">Đặt Dịch Vụ</a></li>
                                <li>Đặt Lịch Hẹn Theo Nhóm</li>
                            </ul>
                        </div>
                        <!-- Breadcrumb row END -->
                    </div>
                </div>
            </div>
            <!-- inner page banner END -->
            
            <!-- booking area -->
            <div class="section-full content-inner shop-account">
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-md-12 text-center">
                            <h3 class="font-weight-700 m-t0 m-b20">Đặt Lịch Hẹn Theo Nhóm</h3>
                        </div>
                    </div>
                    <div class="row justify-content-center">
                        <div class="col-lg-8">
                            <div class="p-a30 border-1 seth">
                                <div class="text-center">
                                    <iconify-icon icon="solar:users-group-rounded-outline" style="font-size: 64px; color: #c8945f; margin-bottom: 20px;"></iconify-icon>
                                    <h4 class="font-weight-700">ĐẶT LỊCH HẸN THEO NHÓM</h4>
                                    <p class="font-weight-600">
                                        Tính năng đặt lịch hẹn theo nhóm đang được phát triển.
                                    </p>
                                    <p class="text-muted">
                                        Bạn có thể đặt lịch hẹn cho nhiều người cùng một lúc với các dịch vụ khác nhau hoặc cùng dịch vụ.
                                    </p>
                                    
                                    <div class="m-t30">
                                        <a href="${pageContext.request.contextPath}/appointments/booking-selection" 
                                           class="site-button m-r5 button-lg radius-no">
                                            <i class="fa fa-arrow-left m-r10"></i>Quay Lại
                                        </a>
                                        <a href="${pageContext.request.contextPath}/appointments/booking-individual" 
                                           class="site-button outline button-lg radius-no">
                                            Đặt Lịch Cá Nhân
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- booking area END -->
        </div>
        <!-- Content END-->
        
        <!-- Footer -->
        <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
        <!-- Footer END -->
        <button class="scroltop fa fa-chevron-up"></button>
    </div>
    
    <!-- Include Home Framework JavaScript -->
    <jsp:include page="/WEB-INF/view/common/home/js.jsp" />
</body>
</html> 