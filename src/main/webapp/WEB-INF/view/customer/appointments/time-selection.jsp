<%--
  Time Selection Page
  User: quang
  Date: 18/06/2025
  Time: 8:45 CH
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="keywords" content="" />
    <meta name="author" content="" />
    <meta name="robots" content="" />
    <meta
      name="description"
      content="BeautyZone : Beauty Spa Salon HTML Template"
    />
    <meta
      property="og:title"
      content="BeautyZone : Beauty Spa Salon HTML Template"
    />
    <meta
      property="og:description"
      content="BeautyZone : Beauty Spa Salon HTML Template"
    />
    <meta
      property="og:image"
      content="../../beautyzone.dexignzone.com/xhtml/social-image.png"
    />
    <meta name="format-detection" content="telephone=no" />

    <!-- FAVICONS ICON -->
    <link
      rel="icon"
      href="${pageContext.request.contextPath}/assets/home/images/favicon.ico"
      type="image/x-icon"
    />
    <link
      rel="shortcut icon"
      type="image/x-icon"
      href="${pageContext.request.contextPath}/assets/home/images/favicon.png"
    />
    <!-- PAGE TITLE HERE -->
    <title>Chọn Thời Gian - BeautyZone Spa</title>

    <!-- MOBILE SPECIFIC -->
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!--[if lt IE 9]>
      <script src="js/html5shiv.min.js"></script>
      <script src="js/respond.min.js"></script>
    <![endif]-->

    <!-- STYLESHEETS -->
    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp"></jsp:include>
    
    <!-- Iconify for icons -->
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    
    <!-- FullCalendar CSS -->
    <link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/main.min.css' rel='stylesheet' />
    
    <!-- Custom time selection styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/home/css/time-selection.css">
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
        <div
          class="dlab-bnr-inr overlay-primary bg-pt"
           style="
            background-image: url(${pageContext.request.contextPath}/assets/home/images/banner/bnr2.jpg);
          "
        >
          <div class="container">
            <div class="dlab-bnr-inr-entry">
              <h1 class="text-white">Chọn Thời Gian</h1>
              <!-- Breadcrumb row -->
              <div class="breadcrumb-row">
                <ul class="list-inline">
                  <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                  <li><a href="${pageContext.request.contextPath}/appointments">Đặt lịch</a></li>
                  <li><a href="${pageContext.request.contextPath}/appointments/services">Chọn dịch vụ</a></li>
                  <li>Chọn thời gian</li>
                </ul>
              </div>
              <!-- Breadcrumb row END -->
            </div>
          </div>
        </div>
        <!-- inner page banner END -->
        
        <!-- Time selection content -->
        <div class="section-full content-inner">
          <div class="container">
            <!-- Breadcrumbs -->
            <nav class="booking-breadcrumbs">
                <span>Dịch vụ</span>
                <span class="mx-2">&gt;</span>
                <span>Chuyên gia</span>
                <span class="mx-2">&gt;</span>
                <span class="font-semibold active">Thời gian</span>
                <span class="mx-2">&gt;</span>
                <span>Xác nhận</span>
            </nav>

            <div class="time-selection-grid">
                <!-- Left Column: Date Picker -->
                <div class="date-picker-section">
                    <h1 class="page-title">Chọn thời gian</h1>
                    
                    <!-- User Selector -->
                    <div class="user-selector">
                        <button class="user-selector-btn">
                            <img src="https://placehold.co/32x32/E2E8F0/4A5568?text=D" alt="Deni's avatar" class="user-avatar">
                            <span class="user-name">Deni</span>
                            <iconify-icon icon="mdi:chevron-down"></iconify-icon>
                        </button>
                    </div>
                    
                    <!-- FullCalendar -->
                    <div class="calendar-section">
                        <div id="fullcalendar"></div>
                    </div>
                    
                    <!-- Time Slots Section -->
                    <div class="time-slots-section" style="display: none;">
                        <h3 class="time-slots-title">Chọn giờ cho <span id="selectedDateDisplay"></span></h3>
                        <div id="timeSlotsList" class="time-slots-grid">
                            <!-- Time slots will be dynamically populated -->
                        </div>
                    </div>

                    <!-- Availability Message -->
                    <div class="availability-message">
                        <img src="https://placehold.co/64x64/E2E8F0/4A5568?text=D" alt="Deni's avatar" class="availability-avatar">
                        <h3 class="availability-title">Deni đã kín lịch vào ngày này</h3>
                        <p class="availability-subtitle">Trùng lịch từ Th 7, 21 thg 6</p>
                        <div class="availability-actions">
                            <button class="btn-next-available">Chuyển đến ngày còn trống tiếp theo</button>
                            <button class="btn-waitlist">Tham gia danh sách chờ</button>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Order Summary -->
                <div class="order-summary-section">
                    <div class="order-summary-card">
                        <!-- Business Info -->
                        <div class="business-info">
                            <img src="https://placehold.co/64x64/1A202C/FFFFFF?text=PY" alt="Perfect You logo" class="business-logo">
                            <div class="business-details">
                                <h3 class="business-name">Perfect You</h3>
                                <div class="business-rating">
                                    <span class="rating-score">4.9</span>
                                    <!-- Star Icons -->
                                    <iconify-icon icon="mdi:star" class="rating-star"></iconify-icon>
                                    <span class="rating-count">(1,655)</span>
                                </div>
                                <p class="business-address">101 Stanley Road, Teddington, England</p>
                            </div>
                        </div>

                        <!-- Service Details -->
                        <div class="service-details">
                            <div class="service-info">
                                <p class="service-name">UV Gel Nail Extensions & Infills (GEL FINISH ONLY)</p>
                                <p class="service-meta">1 giờ, 45 phút • Infill 2/3 weeks với <span class="therapist-name">Deni</span></p>
                            </div>
                            <p class="service-price">46 £</p>
                        </div>

                        <hr class="summary-divider">

                        <!-- Total -->
                        <div class="summary-total">
                            <p class="total-label">Tổng tiền</p>
                            <p class="total-amount">46 £</p>
                        </div>
                        
                        <!-- Continue Button -->
                        <button class="continue-btn">
                            Tiếp tục
                        </button>
                    </div>
                </div>
            </div>
          </div>
        </div>
        <!-- Time selection content END -->
      </div>
      <!-- Content END-->
      
      <!-- Footer -->
      <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
      <!-- Footer END -->
      
      <button class="scroltop fa fa-chevron-up"></button>
    </div>
    
    <!-- JAVASCRIPT FILES ========================================= -->
    <jsp:include page="/WEB-INF/view/common/home/js.jsp"></jsp:include>
    
    <!-- FullCalendar JS -->
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/main.min.js'></script>
    
    <!-- Custom time selection script -->
    <script src="${pageContext.request.contextPath}/assets/home/js/time-selection.js"></script>
</body>
</html> 