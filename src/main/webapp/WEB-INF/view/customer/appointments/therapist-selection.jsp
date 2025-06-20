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
                  <li><a href="${pageContext.request.contextPath}/appointments">Đặt lịch</a></li>
                  <li><a href="${pageContext.request.contextPath}/appointments/services">Chọn dịch vụ</a></li>
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
                <span>Dịch vụ</span>
                <span class="mx-2">&gt;</span>
                <span class="font-semibold active">Chuyên gia</span>
                <span class="mx-2">&gt;</span>
                <span>Thời gian</span>
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
                            <div class="recent-therapist-card" data-therapist-id="1">
                                <div class="therapist-avatar">
                                    <img src="https://placehold.co/80x80/E2E8F0/4A5568?text=AN" alt="An Nguyen">
                                    <div class="therapist-rating">
                                        <iconify-icon icon="mdi:star"></iconify-icon>
                                        <span>4.9</span>
                                    </div>
                                </div>
                                <div class="therapist-info">
                                    <h3 class="therapist-name">An Nguyễn</h3>
                                    <p class="therapist-specialty">Chuyên gia massage</p>
                                    <p class="last-visit">Lần cuối: 15/05/2025</p>
                                </div>
                                <button class="quick-rebook-btn">
                                    <iconify-icon icon="mdi:lightning-bolt"></iconify-icon>
                                    Đặt lại
                                </button>
                            </div>
                            
                            <div class="recent-therapist-card" data-therapist-id="3">
                                <div class="therapist-avatar">
                                    <img src="https://placehold.co/80x80/E2E8F0/4A5568?text=DN" alt="Deni">
                                    <div class="therapist-rating">
                                        <iconify-icon icon="mdi:star"></iconify-icon>
                                        <span>4.8</span>
                                    </div>
                                </div>
                                <div class="therapist-info">
                                    <h3 class="therapist-name">Deni</h3>
                                    <p class="therapist-specialty">Chuyên gia da</p>
                                    <p class="last-visit">Lần cuối: 10/05/2025</p>
                                </div>
                                <button class="quick-rebook-btn">
                                    <iconify-icon icon="mdi:lightning-bolt"></iconify-icon>
                                    Đặt lại
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Service-specific Therapist Selection -->
                    <div class="service-therapist-section">
                        <h2 class="section-title">
                            <iconify-icon icon="mdi:account-group"></iconify-icon>
                            Chọn chuyên gia cho từng dịch vụ
                        </h2>
                        <p class="section-subtitle">Bạn có thể chọn chuyên gia khác nhau cho mỗi dịch vụ</p>
                        
                        <!-- Selected Services List -->
                        <div class="selected-services-list" id="selectedServicesList">
                            <!-- Services will be loaded from previous step -->
                            <!-- Sample service items -->
                            <div class="service-therapist-item" data-service-id="1">
                                <div class="service-info">
                                    <h3 class="service-name">
                                        <iconify-icon icon="mdi:spa"></iconify-icon>
                                        Massage toàn thân thư giãn
                                    </h3>
                                    <div class="service-details">
                                        <span class="service-duration">
                                            <iconify-icon icon="mdi:clock-outline"></iconify-icon>
                                            90 phút
                                        </span>
                                        <span class="service-price">
                                            <iconify-icon icon="mdi:tag"></iconify-icon>
                                            1,200,000 VND
                                        </span>
                                    </div>
                                </div>
                                
                                <div class="therapist-selection">
                                    <label class="selection-label">Chọn chuyên gia:</label>
                                    <div class="therapist-options">
                                        <button class="therapist-option auto-assign active" data-selection="auto">
                                            <iconify-icon icon="mdi:auto-fix"></iconify-icon>
                                            <span>Tự động chọn</span>
                                            <small>Hệ thống sẽ chọn chuyên gia phù hợp nhất</small>
                                        </button>
                                        <button class="therapist-option manual-select" data-selection="manual">
                                            <iconify-icon icon="mdi:account-search"></iconify-icon>
                                            <span>Chọn thủ công</span>
                                            <small>Tự chọn chuyên gia ưa thích</small>
                                        </button>
                                    </div>
                                    
                                    <!-- Therapist Cards (hidden by default) -->
                                    <div class="therapist-cards" style="display: none;">
                                        <div class="therapist-grid" id="therapistGrid1">
                                            <!-- Therapist cards will be loaded here -->
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="service-therapist-item" data-service-id="2">
                                <div class="service-info">
                                    <h3 class="service-name">
                                        <iconify-icon icon="mdi:leaf"></iconify-icon>
                                        Chăm sóc da mặt cơ bản
                                    </h3>
                                    <div class="service-details">
                                        <span class="service-duration">
                                            <iconify-icon icon="mdi:clock-outline"></iconify-icon>
                                            60 phút
                                        </span>
                                        <span class="service-price">
                                            <iconify-icon icon="mdi:tag"></iconify-icon>
                                            800,000 VND
                                        </span>
                                    </div>
                                </div>
                                
                                <div class="therapist-selection">
                                    <label class="selection-label">Chọn chuyên gia:</label>
                                    <div class="therapist-options">
                                        <button class="therapist-option auto-assign active" data-selection="auto">
                                            <iconify-icon icon="mdi:auto-fix"></iconify-icon>
                                            <span>Tự động chọn</span>
                                            <small>Hệ thống sẽ chọn chuyên gia phù hợp nhất</small>
                                        </button>
                                        <button class="therapist-option manual-select" data-selection="manual">
                                            <iconify-icon icon="mdi:account-search"></iconify-icon>
                                            <span>Chọn thủ công</span>
                                            <small>Tự chọn chuyên gia ưa thích</small>
                                        </button>
                                    </div>
                                    
                                    <!-- Therapist Cards (hidden by default) -->
                                    <div class="therapist-cards" style="display: none;">
                                        <div class="therapist-grid" id="therapistGrid2">
                                            <!-- Therapist cards will be loaded here -->
                                        </div>
                                    </div>
                                </div>
                            </div>
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
                            <div class="summary-service-item">
                                <div class="service-summary">
                                    <h4 class="service-name">Massage toàn thân thư giãn</h4>
                                    <p class="service-meta">90 phút • 1,200,000 VND</p>
                                </div>
                                <div class="therapist-summary">
                                    <div class="therapist-selection-status auto">
                                        <iconify-icon icon="mdi:auto-fix"></iconify-icon>
                                        <span>Tự động chọn chuyên gia</span>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="summary-service-item">
                                <div class="service-summary">
                                    <h4 class="service-name">Chăm sóc da mặt cơ bản</h4>
                                    <p class="service-meta">60 phút • 800,000 VND</p>
                                </div>
                                <div class="therapist-summary">
                                    <div class="therapist-selection-status auto">
                                        <iconify-icon icon="mdi:auto-fix"></iconify-icon>
                                        <span>Tự động chọn chuyên gia</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <hr class="summary-divider">

                        <!-- Total Summary -->
                        <div class="summary-total">
                            <div class="total-services">
                                <span class="total-label">Tổng số dịch vụ:</span>
                                <span class="total-count">2</span>
                            </div>
                            <div class="total-amount">
                                <span class="total-label">Tổng tiền:</span>
                                <span class="total-price">2,000,000 VND</span>
                            </div>
                        </div>
                        
                        <!-- Continue Button -->
                        <button class="continue-btn" id="continueBtn">
                            <iconify-icon icon="mdi:arrow-right"></iconify-icon>
                            Tiếp tục chọn thời gian
                        </button>

                        <!-- Additional Options -->
                        <div class="additional-options">
                            <button class="option-btn" id="addMoreServices">
                                <iconify-icon icon="mdi:plus"></iconify-icon>
                                Thêm dịch vụ
                            </button>
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
    
    <!-- Custom therapist selection script -->
    <script src="${pageContext.request.contextPath}/assets/home/js/therapist-selection.js"></script>
</body>
</html> 