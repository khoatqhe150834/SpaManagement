<%-- 
    Document   : purchase.jsp
    Created on : Gift Card Purchase Page
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thẻ Quà Tặng - BeautyZone Spa</title>
    
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
                        <h1 class="text-white">Thẻ Quà Tặng</h1>
                        <!-- Breadcrumb row -->
                        <div class="breadcrumb-row">
                            <ul class="list-inline">
                                <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                                <li><a href="${pageContext.request.contextPath}/customer-dashboard">Bảng Điều Khiển</a></li>
                                <li><a href="${pageContext.request.contextPath}/appointments/booking-selection">Đặt Dịch Vụ</a></li>
                                <li>Thẻ Quà Tặng</li>
                            </ul>
                        </div>
                        <!-- Breadcrumb row END -->
                    </div>
                </div>
            </div>
            <!-- inner page banner END -->
            
            <!-- giftcard area -->
            <div class="section-full content-inner shop-account">
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-md-12 text-center">
                            <h3 class="font-weight-700 m-t0 m-b20">Thẻ Quà Tặng</h3>
                        </div>
                    </div>
                    <div class="row justify-content-center">
                        <div class="col-lg-8">
                            <div class="p-a30 border-1 seth">
                                <div class="text-center">
                                    <iconify-icon icon="solar:gift-outline" style="font-size: 64px; color: #059669; margin-bottom: 20px;"></iconify-icon>
                                    <h4 class="font-weight-700">THẺ QUÀ TẶNG</h4>
                                    <p class="font-weight-600">
                                        Tính năng thẻ quà tặng đang được phát triển.
                                    </p>
                                    <p class="text-muted">
                                        Tặng những người thân yêu những trải nghiệm thư giãn tuyệt vời tại spa của chúng tôi.
                                    </p>
                                    
                                    <div class="m-t30">
                                        <a href="${pageContext.request.contextPath}/appointments/booking-selection" 
                                           class="site-button m-r5 button-lg radius-no">
                                            <i class="fa fa-arrow-left m-r10"></i>Quay Lại
                                        </a>
                                        <a href="${pageContext.request.contextPath}/appointments/booking-individual" 
                                           class="site-button outline button-lg radius-no">
                                            Đặt Lịch Ngay
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- giftcard area END -->
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