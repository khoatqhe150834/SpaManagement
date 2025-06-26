<%--
  Services Selection Page
  User: quang
  Date: 18/06/2025
  Time: 6:56 CH
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
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
    <title>Chọn Dịch Vụ - BeautyZone Spa</title>

    <!-- MOBILE SPECIFIC -->
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!--[if lt IE 9]>
      <script src="js/html5shiv.min.js"></script>
      <script src="js/respond.min.js"></script>
    <![endif]-->

    <!-- STYLESHEETS -->
    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp"></jsp:include>
    
    <!-- FontAwesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Custom service selection styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/home/css/services-selection.css">
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
              <h1 class="text-white">Chọn Dịch Vụ</h1>
              <!-- Breadcrumb row -->
              <div class="breadcrumb-row">
                <ul class="list-inline">
                  <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                  <li><a href="${pageContext.request.contextPath}/appointments">Đặt lịch</a></li>
                  <li>Chọn dịch vụ</li>
                </ul>
                </div>
              <!-- Breadcrumb row END -->
            </div>
            </div>
        </div>
        <!-- inner page banner END -->

        <!-- Service selection content -->
        <div class="section-full content-inner">
    <main class="main">
        <div class="container">
            <!-- Step Indicator -->
            <c:set var="currentStep" value="services" />
            <jsp:include page="/WEB-INF/view/common/booking/step-indicator.jsp">
                <jsp:param name="currentStep" value="${currentStep}" />
                <jsp:param name="bookingSession" value="${bookingSession}" />
            </jsp:include>
            
            <div class="content-grid">
                <!-- Main Content -->
                <div class="main-content">
                    <h1 class="page-title">Dịch vụ</h1>
                    
                    <!-- Top Section: Category and Search Bar -->
                    <div class="top-controls-section">
                        <!-- Category Navigation -->
                        <div class="category-nav">
                            <div class="category-dropdown" id="categoryDropdown">
                                <button class="category-dropdown-button" id="categoryDropdownButton">
                                    <span class="category-dropdown-text">Tất cả</span>
                                    <i class="fas fa-chevron-down category-dropdown-icon"></i>
                                </button>
                                <div class="category-dropdown-menu" id="categoryDropdownMenu">
                                    <button class="category-dropdown-item active" data-category="all">
                                        <i class="fas fa-star"></i>
                                        Tất cả
                                    </button>
                                    <!-- Service type items will be populated by JavaScript -->
                                </div>
                            </div>
                        </div>

                        <!-- Search Bar -->
                        <div class="search-container">
                            <i class="fas fa-search search-icon"></i>
                            <input type="text" id="searchInput" placeholder="Tìm kiếm dịch vụ..." class="search-input">
                        </div>
                    </div>

                    <!-- Price Range Filter -->
                    <div class="filter-card">
                        <h3 class="filter-title">Khoảng giá</h3>
                        <div class="price-inputs">
                            <div class="price-input-group">
                                <label class="price-label">Giá tối thiểu</label>
                                <div class="price-input-wrapper">
                                    <input type="text" id="minPriceInput" class="price-input" placeholder="0">
                                    <span class="currency">VND</span>
                                </div>
                            </div>
                            <div class="price-input-group">
                                <label class="price-label">Giá tối đa</label>
                                <div class="price-input-wrapper">
                                    <input type="text" id="maxPriceInput" class="price-input" placeholder="10.000.000">
                                    <span class="currency">VND</span>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Dual Range Slider -->
                        <div class="slider-container">
                            <div class="slider-labels">
                                <span>0 VND</span>
                                <span>10.000.000 VND</span>
                            </div>
                            <div class="slider-step-info">
                                <small>Bước: 100.000 VND</small>
                            </div>
                            <div class="slider-wrapper">
                                <div class="slider-track"></div>
                                <div class="slider-range" id="sliderRange"></div>
                                <input type="range" id="minSlider" min="0" max="10000000" value="0" step="100000" class="slider slider-min">
                                <input type="range" id="maxSlider" min="0" max="10000000" value="10000000" step="100000" class="slider slider-max">
                            </div>
                            <div class="slider-values">
                                <span id="minValue">0 VND</span>
                                <span id="maxValue">10.000.000 VND</span>
                            </div>
                        </div>
                    </div>

                    <!-- Services Section -->
                    <div class="services-section">
                        <div class="services-header">
                            <h2 class="services-title" id="servicesTitle">Tất cả</h2>
                            <button class="reset-filters" id="resetFilters" style="display: none;">Xóa bộ lọc</button>
                        </div>
                        
                        <div class="services-list" id="servicesList">
                            <!-- Services will be populated by JavaScript -->
                        </div>

                        <div class="no-results" id="noResults" style="display: none;">
                            <i class="fas fa-search no-results-icon"></i>
                            <h3 class="no-results-title">Không tìm thấy dịch vụ</h3>
                            <p class="no-results-text">Thử điều chỉnh bộ lọc hoặc từ khóa tìm kiếm</p>
                        </div>
                    </div>
                </div>

                <!-- Sidebar -->
                <div class="sidebar">
                    <div class="sidebar-card">
                        <!-- Selected Services -->
                        <div class="selected-services">
                            <div class="selected-services-header">
                                <h3>Dịch vụ đã chọn</h3>
                                <span class="service-counter" id="serviceCounter">0/6</span>
                            </div>
                            <div class="selected-services-content" id="selectedServicesContent">
                                <p class="no-services">Không có dịch vụ nào được chọn</p>
                            </div>
                        </div>

                        <!-- Pricing Summary -->
                        <div class="pricing-summary">
                            <span class="total-label">Tổng tiền</span>
                            <span class="total-amount" id="totalAmount">miễn phí</span>
                        </div>

                        <!-- Continue Button -->
                        <button class="continue-btn" id="continueBtn" disabled>Tiếp tục</button>
                    </div>
                </div>
            </div>
        </div>
    </main>
        </div>
        <!-- Service selection content END -->
      </div>
      <!-- Content END-->
      
      <!-- Footer -->
      <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
      <!-- Footer END -->
      
      <button class="scroltop fa fa-chevron-up"></button>
    </div>
    
    <!-- JAVASCRIPT FILES ========================================= -->
    <jsp:include page="/WEB-INF/view/common/home/js.jsp"></jsp:include>
    
    <!-- Pass server data to JavaScript -->
    <script type="text/javascript">
        // Pass saved booking session data to JavaScript
        window.savedBookingData = {
            selectedServices: <c:choose>
                <c:when test="${not empty selectedServices}">
                    [
                        <c:forEach var="service" items="${selectedServices}" varStatus="status">
                        {
                            serviceId: ${service.serviceId},
                            serviceName: "${service.serviceName}",
                            estimatedPrice: ${service.estimatedPrice},
                            estimatedDuration: ${service.estimatedDuration}
                        }<c:if test="${!status.last}">,</c:if>
                        </c:forEach>
                    ]
                </c:when>
                <c:otherwise>[]</c:otherwise>
            </c:choose>
        };
        
        console.log('📦 Server-side saved booking data:', window.savedBookingData);
    </script>
    
    <!-- Custom service selection script -->
    <script src="${pageContext.request.contextPath}/assets/home/js/service-selection.js?v=<%=System.currentTimeMillis()%>"></script>
</body>
</html>