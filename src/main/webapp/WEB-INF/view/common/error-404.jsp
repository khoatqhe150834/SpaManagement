<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="keywords" content="">
    <meta name="author" content="">
    <meta name="robots" content="">
    <meta name="description" content="BeautyZone : Beauty Spa Salon HTML Template">
    <meta property="og:title" content="BeautyZone : Beauty Spa Salon HTML Template">
    <meta property="og:description" content="BeautyZone : Beauty Spa Salon HTML Template">
    <meta property="og:image" content="../../beautyzone.dexignzone.com/xhtml/social-image.png">
    <meta name="format-detection" content="telephone=no">
    
    <!-- FAVICONS ICON -->
    <link rel="icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.ico" type="image/x-icon">
    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.png">
    
    <!-- PAGE TITLE HERE -->
    <title>BeautyZone : Beauty Spa Salon HTML Template</title>
    
    <!-- MOBILE SPECIFIC -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- STYLESHEETS -->
    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp"></jsp:include>
</head>

<body id="bg">
<div class="page-wraper">
    <div id="loading-area"></div>
    <!-- Header -->
    <jsp:include page="/WEB-INF/view/common/home/header.jsp" />
    
    <!-- Content -->
    <div class="page-content">
       
        
        <!-- Error Page -->
        <div class="section-full content-inner-3 error-page" style="background-image:url(${pageContext.request.contextPath}/assets/home/images/background/bg6.jpg); background-size:cover;">
            <div class="container">
                <div class="row">
                    <div class="col-lg-6 col-md-6 col-sm-6 m-b30 align-self-center text-center">
                        <h2 class="dz_error text-secondry">404</h2>
                        <h3>OOPS!</h3>
                        <h4>Page Not Found</h4>
                        <a href="${pageContext.request.contextPath}/" class="site-button">Back To Home</a>
                    </div>
                    <div class="col-lg-6 col-md-6 col-sm-6">
                        <img src="${pageContext.request.contextPath}/assets/home/images/collage.png" alt="">
                    </div>
                </div>
            </div>
        </div>
        <!-- Error Page END -->
    </div>
    <!-- Content END -->
    
    <!-- Footer -->
    <jsp:include page="/WEB-INF/view/common/home/footer.jsp" />
    
    <button class="scroltop fa fa-chevron-up"></button>
</div>

<!-- JAVASCRIPT FILES -->
<jsp:include page="/WEB-INF/view/common/home/js.jsp"></jsp:include>

</body>
</html> 