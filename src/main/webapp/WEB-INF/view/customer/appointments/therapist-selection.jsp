<%--
  Therapist Selection Page
  User: quang
  Date: 18/06/2025
  Time: 9:15 CH
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
    <title>Chọn Chuyên Gia - BeautyZone Spa</title>

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
    
    <!-- Custom therapist selection styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/home/css/therapist-selection.css">
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
              <h1 class="text-white">Chọn Chuyên Gia</h1>
              <!-- Breadcrumb row -->
              <div class="breadcrumb-row">
                <ul class="list-inline">
                  <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                  <li><a href="${pageContext.request.contextPath}/process-booking">Đặt lịch</a></li>
                  <li>Chọn chuyên gia</li>
                </ul>
              </div>
              <!-- Breadcrumb row END -->
            </div>
          </div>
        </div>
        <!-- inner page banner END -->
        
        <!-- Therapist selection content -->
        <div class="section-full content-inner">
          <div class="container">
            <!-- Breadcrumbs -->
            <nav class="booking-breadcrumbs">
                <span>✓ Dịch vụ</span>
                <span class="mx-2">&gt;</span>
                <span class="font-semibold active">Chuyên gia</span>
                <span class="mx-2">&gt;</span>
                <span>Thời gian</span>
                <span class="mx-2">&gt;</span>
                <span>Thanh toán</span>
                <span class="mx-2">&gt;</span>
                <span>Xác nhận</span>
            </nav>

            <div class="therapist-selection-grid">
                <!-- Left Column: Therapist Selection -->
                <div class="therapist-selection-section">
                    <h1 class="page-title">Chọn chuyên gia cho dịch vụ</h1>
                    
                    <!-- Quick Rebook Section -->
                    <div class="rebook-section">
                        <h2 class="section-title">
                            <iconify-icon icon="mdi:clock-fast"></iconify-icon>
                            Đặt lại lịch nhanh
                        </h2>
                        <p class="section-subtitle">Chọn chuyên gia từ lịch hẹn gần đây của bạn</p>
                        
                        <div class="recent-therapists" id="recentTherapists">
                            <!-- Recent therapists will be loaded here -->
                            <div class="no-recent-message" style="text-align: center; color: #6b7280; padding: 2rem;">
                                <iconify-icon icon="mdi:calendar-clock" style="font-size: 3rem; margin-bottom: 1rem;"></iconify-icon>
                                <p>Chưa có lịch hẹn gần đây</p>
                                <small>Lịch hẹn gần đây sẽ hiển thị ở đây để bạn đặt lại nhanh chóng</small>
                            </div>
                        </div>
                    </div>

                    <!-- Service-specific Therapist Selection -->
                    <div class="service-therapist-section">
                        <h2 class="section-title">
                            <iconify-icon icon="mdi:account-group"></iconify-icon>
                            Chọn chuyên gia cho từng dịch vụ
                        </h2>
                        <p class="section-subtitle">Bạn có thể chọn chuyên gia khác nhau cho mỗi dịch vụ hoặc để hệ thống tự động chọn</p>
                        
                        <!-- Selected Services List -->
                        <div class="selected-services-list" id="selectedServicesList">
                            <!-- Services will be loaded from server data -->
                            <c:forEach var="service" items="${selectedServices}" varStatus="status">
                                <div class="service-therapist-item" data-service-id="${service.serviceId}">
                                    <div class="service-info">
                                        <h3 class="service-name">
                                            <iconify-icon icon="mdi:spa"></iconify-icon>
                                            ${service.name}
                                        </h3>
                                        <div class="service-details">
                                            <span class="service-duration">
                                                <iconify-icon icon="mdi:clock-outline"></iconify-icon>
                                                ${service.durationMinutes} phút
                                            </span>
                                            <span class="service-price">
                                                <iconify-icon icon="mdi:tag"></iconify-icon>
                                                <fmt:formatNumber value="${service.price}" type="number" groupingUsed="true"/> VND
                                            </span>
                                        </div>
                                    </div>
                                    
                                    <div class="therapist-selection">
                                        <label class="selection-label">Chọn chuyên gia:</label>
                                        <div class="therapist-options">
                                            <button class="therapist-option auto-assign active" 
                                                    data-service-id="${service.serviceId}" data-selection="auto">
                                                <iconify-icon icon="mdi:auto-fix"></iconify-icon>
                                                <span>Tự động chọn</span>
                                                <small>Hệ thống sẽ chọn chuyên gia phù hợp nhất</small>
                                            </button>
                                            <button class="therapist-option manual-select" 
                                                    data-service-id="${service.serviceId}" data-selection="manual">
                                                <iconify-icon icon="mdi:account-search"></iconify-icon>
                                                <span>Chọn thủ công</span>
                                                <small>Tự chọn chuyên gia ưa thích</small>
                                            </button>
                                        </div>
                                        
                                        <!-- Therapist Cards (hidden by default) -->
                                        <div class="therapist-cards" style="display: none;">
                                            <div class="therapist-grid" id="therapistGrid${service.serviceId}">
                                                <!-- Therapist cards will be loaded here -->
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            
                            <!-- Fallback if no services (shouldn't happen in normal flow) -->
                            <c:if test="${empty selectedServices}">
                                <div class="no-services-message" style="text-align: center; color: #6b7280; padding: 2rem;">
                                    <iconify-icon icon="mdi:alert-circle" style="font-size: 3rem; margin-bottom: 1rem;"></iconify-icon>
                                    <p>Không có dịch vụ nào được chọn</p>
                                    <a href="${pageContext.request.contextPath}/process-booking" class="btn btn-primary">
                                        Quay lại chọn dịch vụ
                                    </a>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- All Available Therapists Section -->
                    <div class="all-therapists-section" style="display: none;">
                        <h2 class="section-title">
                            <iconify-icon icon="mdi:account-multiple"></iconify-icon>
                            Tất cả chuyên gia
                        </h2>
                        
                        <!-- Filter Options -->
                        <div class="therapist-filters">
                            <div class="filter-group">
                                <label>Chuyên môn:</label>
                                <select id="specialtyFilter" class="filter-select">
                                    <option value="">Tất cả</option>
                                    <option value="massage">Massage</option>
                                    <option value="facial">Chăm sóc da</option>
                                    <option value="nails">Nail</option>
                                    <option value="hair">Tóc</option>
                                </select>
                            </div>
                            
                            <div class="filter-group">
                                <label>Đánh giá:</label>
                                <select id="ratingFilter" class="filter-select">
                                    <option value="">Tất cả</option>
                                    <option value="5">5 sao</option>
                                    <option value="4">4+ sao</option>
                                    <option value="3">3+ sao</option>
                                </select>
                            </div>
                            
                            <div class="filter-group">
                                <label>Sắp xếp:</label>
                                <select id="sortBy" class="filter-select">
                                    <option value="rating">Đánh giá cao nhất</option>
                                    <option value="experience">Kinh nghiệm</option>
                                    <option value="name">Tên A-Z</option>
                                </select>
                            </div>
                        </div>
                        
                        <!-- All Therapists Grid -->
                        <div class="all-therapists-grid" id="allTherapistsGrid">
                            <!-- All therapists will be loaded here -->
                        </div>
                    </div>
                </div>

                <!-- Right Column: Selection Summary -->
                <div class="selection-summary-section">
                    <div class="selection-summary-card">
                        <!-- Service Summary -->
                        <div class="summary-header">
                            <h3 class="summary-title">Tóm tắt lựa chọn</h3>
                            <p class="summary-subtitle">Dịch vụ và chuyên gia đã chọn</p>
                        </div>

                        <!-- Selected Services & Therapists -->
                        <div class="summary-services" id="summaryServices">
                            <c:forEach var="service" items="${selectedServices}" varStatus="status">
                                <div class="summary-service-item" data-service-id="${service.serviceId}">
                                    <div class="service-summary">
                                        <h4 class="service-name">${service.name}</h4>
                                        <p class="service-meta">${service.durationMinutes} phút • <fmt:formatNumber value="${service.price}" type="number" groupingUsed="true"/> VND</p>
                                    </div>
                                    <div class="therapist-summary">
                                        <div class="therapist-selection-status auto">
                                            <iconify-icon icon="mdi:auto-fix"></iconify-icon>
                                            <span>Tự động chọn chuyên gia</span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <hr class="summary-divider">

                        <!-- Total Summary -->
                        <div class="summary-total">
                            <div class="total-services">
                                <span class="total-label">Tổng số dịch vụ:</span>
                                <span class="total-count">${selectedServices.size()}</span>
                            </div>
                            <div class="total-amount">
                                <span class="total-label">Tổng tiền:</span>
                                <span class="total-price" id="totalPrice">
                                    <c:set var="total" value="0"/>
                                    <c:forEach var="service" items="${selectedServices}">
                                        <c:set var="total" value="${total + service.price}"/>
                                    </c:forEach>
                                    <fmt:formatNumber value="${total}" type="number" groupingUsed="true"/> VND
                                </span>
                            </div>
                        </div>
                        
                        <!-- Continue Button -->
                        <button class="continue-btn" id="continueBtn">
                            <iconify-icon icon="mdi:arrow-right"></iconify-icon>
                            Tiếp tục chọn thời gian
                        </button>

                        <!-- Additional Options -->
                        <div class="additional-options">
                            <a href="${pageContext.request.contextPath}/process-booking" class="option-btn">
                                <iconify-icon icon="mdi:arrow-left"></iconify-icon>
                                Quay lại chọn dịch vụ
                            </a>
                            <button class="option-btn" id="viewAllTherapists">
                                <iconify-icon icon="mdi:account-multiple"></iconify-icon>
                                Xem tất cả chuyên gia
                            </button>
                        </div>
                    </div>
                </div>
            </div>
          </div>
        </div>
        <!-- Therapist selection content END -->
      </div>
      <!-- Content END-->
      
      <!-- Footer -->
      <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
      <!-- Footer END -->
      
      <button class="scroltop fa fa-chevron-up"></button>
    </div>
    
    <!-- JAVASCRIPT FILES ========================================= -->
    <jsp:include page="/WEB-INF/view/common/home/js.jsp"></jsp:include>
    
    <!-- Booking storage script -->
    <script src="${pageContext.request.contextPath}/assets/home/js/booking-storage.js"></script>
    
    <!-- Custom therapist selection script -->
    <script src="${pageContext.request.contextPath}/assets/home/js/therapist-selection.js"></script>
</body>
</html> 