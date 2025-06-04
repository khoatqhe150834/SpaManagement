<%--
    Document   : spa-info
    Created on : Jun 4, 2025, 4:43:43 PM
    Author     : quang
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="keywords" content="" />
        <meta name="author" content="" />
        <meta name="robots" content="" />
        <meta name="description" content="BeautyZone : Thông Tin Spa ${spa.name}" />
        <meta property="og:title" content="BeautyZone : Thông Tin Spa ${spa.name}" />
        <meta property="og:description" content="BeautyZone : Thông Tin Spa ${spa.name}" />
        <meta name="format-detection" content="telephone=no" />

        <link rel="icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.ico" type="image/x-icon" />
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.png" />

        <title>Thông Tin Spa - ${spa.name}</title>
        <meta name="viewport" content="width=device-width, initial-scale=1" />

        <!--[if lt IE 9]>
            <script src="js/html5shiv.min.js"></script>
            <script src="js/respond.min.js"></script>
        <![endif]-->

        <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp"></jsp:include>

        <style>
            .spa-logo {
                max-width: 200px;
                height: auto;
                border-radius: 8px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }
            .info-section {
                margin-bottom: 2rem;
            }
            .contact-info i {
                width: 25px;
                color: #c59952;
            }
            .spa-info-header {
                background: linear-gradient(rgba(0,0,0,0.4), rgba(0,0,0,0.4)), url('${pageContext.request.contextPath}/assets/home/images/main-slider/slide6.jpg') center center/cover no-repeat;
                color: #fff;
                padding: 80px 0;
                text-align: center;
                margin-bottom: 0;
            }
            .spa-info-header h1 {
                font-size: 3.5rem;
                font-weight: 700;
                color: #fff;
                margin-bottom: 1rem;
                text-shadow: 0 2px 8px rgba(0,0,0,0.3);
            }
            .spa-info-header .spa-subtitle {
                font-size: 1.2rem;
                color: #fff;
                opacity: 0.9;
                text-shadow: 0 2px 8px rgba(0,0,0,0.3);
            }
            .section-head {
                margin-bottom: 3rem;
            }
            .section-head h2 {
                font-size: 2.5rem;
                font-weight: 600;
                color: #333;
            }
            .card {
                border: none;
                box-shadow: 0 4px 15px rgba(0,0,0,0.08);
                border-radius: 8px;
                overflow: hidden;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }
            .card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            }
            .card-header {
                background: linear-gradient(135deg, #c59952 0%, #d4a762 100%);
                border-bottom: none;
                padding: 1.25rem 1.5rem;
            }
            .card-header h3 {
                font-size: 1.1rem;
                font-weight: 600;
                margin: 0;
            }
            .card-body {
                padding: 1.5rem;
            }
            .spa-highlight {
                color: #c59952;
                font-weight: 600;
            }
            .content-inner-2 {
                padding: 80px 0;
            }
            .bg-spa-light {
                background-color: #f8f9fa;
            }
        </style>
    </head>
    <body id="bg">
        <div class="page-wraper">
            <div id="loading-area"></div>
            <jsp:include page="/WEB-INF/view/common/home/header.jsp"></jsp:include>
            
            <div class="page-content bg-white">
                        <!-- inner page banner -->
        <div
          class="dlab-bnr-inr overlay-primary bg-pt"
          style="
            background-image: url(${pageContext.request.contextPath}/assets/home/images/banner/bnr2.jpg);
          "
        >
          <div class="container">
            <div class="dlab-bnr-inr-entry">
              <h1 class="text-white">Thông Tin Spa</h1>
              <!-- Breadcrumb row -->
              <div class="breadcrumb-row">
                <ul class="list-inline">
                  <li>
                    <a href="${pageContext.request.contextPath}/">Trang chủ</a>
                  </li>
                  <li>Thông Tin Spa</li>
                </ul>
              </div>
              <!-- Breadcrumb row END -->
            </div>
          </div>
        </div>
        <!-- inner page banner END -->

                <!-- Contact & Business Info Section -->
                <div class="section-full content-inner-2 bg-white">
                    <div class="container">
                        <div class="section-head text-center">
                            <h2 class="m-b10">Thông Tin Liên Hệ & Doanh Nghiệp</h2>
                        </div>
                        <div class="row">
                            <!-- Contact Information -->
                            <div class="col-lg-6 col-md-6 info-section">
                                <div class="card h-100">
                                    <div class="card-header text-white">
                                        <h3 class="card-title mb-0"><i class="ti-info-alt m-r5"></i>Thông Tin Liên Hệ</h3>
                                    </div>
                                    <div class="card-body contact-info">
                                        <p><i class="ti-location-pin"></i> <strong>Địa chỉ:</strong><br>
                                            ${spa.addressLine1}<br>
                                            <c:if test="${not empty spa.addressLine2}">${spa.addressLine2}<br></c:if>
                                            ${spa.city}, ${spa.postalCode}<br>
                                            ${spa.country}
                                        </p>
                                        <p><i class="ti-mobile"></i> <strong>Điện thoại:</strong><br>
                                            Chính: <span class="spa-highlight">${spa.phoneNumberMain}</span><br>
                                            <c:if test="${not empty spa.phoneNumberSecondary}">
                                                Phụ: <span class="spa-highlight">${spa.phoneNumberSecondary}</span>
                                            </c:if>
                                        </p>
                                        <p><i class="ti-email"></i> <strong>Email:</strong><br>
                                            Chính: <span class="spa-highlight">${spa.emailMain}</span><br>
                                            <c:if test="${not empty spa.emailSecondary}">
                                                Phụ: <span class="spa-highlight">${spa.emailSecondary}</span>
                                            </c:if>
                                        </p>
                                        <c:if test="${not empty spa.websiteUrl}">
                                            <p><i class="ti-world"></i> <strong>Website:</strong><br>
                                                <a href="${spa.websiteUrl}" target="_blank" class="spa-highlight">${spa.websiteUrl}</a>
                                            </p>
                                        </c:if>
                                    </div>
                                </div>
                            </div>

                            <!-- Business Information -->
                            <div class="col-lg-6 col-md-6 info-section">
                                <div class="card h-100">
                                    <div class="card-header text-white">
                                        <h3 class="card-title mb-0"><i class="ti-home m-r5"></i>Thông Tin Doanh Nghiệp</h3>
                                    </div>
                                    <div class="card-body">
                                        <c:if test="${not empty spa.taxIdentificationNumber}">
                                            <p><i class="ti-id-badge text-muted m-r10"></i><strong>Mã số thuế:</strong> <span class="spa-highlight">${spa.taxIdentificationNumber}</span></p>
                                        </c:if>
                                        <p><i class="ti-receipt text-muted m-r10"></i><strong>VAT:</strong> <span class="spa-highlight">${spa.vatPercentage}%</span></p>
                                        <p><i class="ti-alarm-clock text-muted m-r10"></i><strong>Thời gian đệm lịch hẹn:</strong> <span class="spa-highlight">${spa.defaultAppointmentBufferMinutes} phút</span></p>
                                        <c:if test="${not empty spa.createdAt}">
                                            <p><i class="ti-calendar text-muted m-r10"></i><strong>Ngày thành lập:</strong> <span class="spa-highlight">${spa.createdAt}</span></p>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- About Us Section -->
                <div class="section-full content-inner-2 bg-spa-light">
                    <div class="container">
                        <div class="section-head text-center">
                            <h2 class="m-b10">Về Chúng Tôi</h2>
                        </div>
                        <div class="row">
                            <div class="col-md-12 info-section">
                                <div class="card">
                                    <div class="card-header text-white">
                                        <h3 class="card-title mb-0"><i class="ti-info-alt m-r5"></i>Giới Thiệu Spa</h3>
                                    </div>
                                    <div class="card-body">
                                        <c:if test="${not empty spa.aboutUsShort}">
                                            <div class="mb-4">
                                                <h4 class="spa-highlight">Mô tả ngắn</h4>
                                                <p class="lead">${spa.aboutUsShort}</p>
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty spa.aboutUsLong}">
                                            <div>
                                                <h4 class="spa-highlight">Thông tin chi tiết</h4>
                                                <p>${spa.aboutUsLong}</p>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Policies Section -->
                <div class="section-full content-inner-2 bg-white">
                    <div class="container">
                        <div class="section-head text-center">
                            <h2 class="m-b10">Chính Sách & Điều Khoản</h2>
                        </div>
                        <div class="row">
                            <div class="col-lg-6 col-md-6 info-section">
                                <div class="card h-100">
                                    <div class="card-header text-white">
                                        <h3 class="card-title mb-0"><i class="ti-calendar m-r5"></i>Chính Sách Hủy Lịch</h3>
                                    </div>
                                    <div class="card-body">
                                        <p>${spa.cancellationPolicy}</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-6 col-md-6 info-section">
                                <div class="card h-100">
                                    <div class="card-header text-white">
                                        <h3 class="card-title mb-0"><i class="ti-files m-r5"></i>Điều Khoản Đặt Lịch</h3>
                                    </div>
                                    <div class="card-body">
                                        <p>${spa.bookingTerms}</p>
                                    </div>
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
    </body>
</html>
