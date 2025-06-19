<%--
  Created by IntelliJ IDEA.
  User: quang
  Date: 18/06/2025
  Time: 6:56 CH
  To change this template use File | Settings | File Templates.
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
    <meta name="description" content="BeautyZone : Beauty Spa Salon HTML Template" />
    <meta property="og:title" content="BeautyZone : Beauty Spa Salon HTML Template" />
    <meta property="og:description" content="BeautyZone : Beauty Spa Salon HTML Template" />
    <meta property="og:image" content="../../beautyzone.dexignzone.com/xhtml/social-image.png" />
    <meta name="format-detection" content="telephone=no" />

    <!-- FAVICONS ICON -->
    <link rel="icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.ico" type="image/x-icon" />
    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.png" />
    
    <!-- PAGE TITLE HERE -->
    <title>Chọn Dịch Vụ - BeautyZone Spa</title>

    <!-- MOBILE SPECIFIC -->
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- STYLESHEETS -->
    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp"></jsp:include>
    
    <!-- Custom styles for services selection -->
    <style>
        .services-selection-container {
            background-color: #f8f9fa;
            min-height: 100vh;
            padding: 60px 0;
        }
        
        .selection-header {
            text-align: center;
            margin-bottom: 50px;
        }
        
        .selection-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 15px;
        }
        
        .selection-header p {
            font-size: 1.1rem;
            color: #6c757d;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .filters-section {
            background: #fff;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 40px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        
        .search-container {
            margin-bottom: 30px;
        }
        
        .search-input-group {
            position: relative;
            max-width: 500px;
            margin: 0 auto;
        }
        
        .search-input-group input {
            padding: 15px 50px 15px 20px;
            border: 2px solid #e9ecef;
            border-radius: 50px;
            font-size: 16px;
            width: 100%;
            transition: all 0.3s ease;
        }
        
        .search-input-group input:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
            outline: none;
        }
        
        .search-clear-btn {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            border: none;
            background: none;
            color: #6c757d;
            font-size: 18px;
            cursor: pointer;
            transition: color 0.3s ease;
        }
        
        .search-clear-btn:hover {
            color: #dc3545;
        }
        
        .service-types-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }
        
        .service-type-btn {
            padding: 12px 20px;
            border: 2px solid #e9ecef;
            background: #fff;
            color: #495057;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
            cursor: pointer;
            text-align: center;
        }
        
        .service-type-btn:hover {
            background: #007bff;
            color: #fff;
            border-color: #007bff;
            transform: translateY(-2px);
        }
        
        .service-type-btn.active {
            background: #007bff;
            color: #fff;
            border-color: #007bff;
        }
        
        .price-range-container {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 10px;
            border: 1px solid #e9ecef;
        }
        
        .price-range-title {
            font-weight: 600;
            color: #495057;
            margin-bottom: 20px;
            text-align: center;
        }
        
        .price-slider-group {
            display: flex;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
            justify-content: center;
        }
        
        .price-slider-item {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .price-slider {
            width: 150px;
            height: 5px;
            border-radius: 5px;
            background: #e9ecef;
            outline: none;
            -webkit-appearance: none;
        }
        
        .price-slider::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: #007bff;
            cursor: pointer;
        }
        
        .price-slider::-moz-range-thumb {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: #007bff;
            cursor: pointer;
            border: none;
        }
        
        .price-value {
            font-weight: 600;
            color: #007bff;
            min-width: 120px;
            text-align: center;
            background: #fff;
            padding: 8px 15px;
            border-radius: 20px;
            border: 1px solid #e9ecef;
        }
        
        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        
        .service-card {
            background: #fff;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            border: 3px solid transparent;
            position: relative;
        }
        
        .service-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
        
        .service-card.selected {
            border-color: #28a745;
            transform: translateY(-3px);
        }
        
        .service-card-header {
            position: relative;
            height: 200px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .service-card-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .service-card-content {
            padding: 25px;
        }
        
        .service-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .service-description {
            color: #6c757d;
            font-size: 0.95rem;
            line-height: 1.5;
            margin-bottom: 15px;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .service-details {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .service-price {
            font-size: 1.4rem;
            font-weight: 700;
            color: #28a745;
        }
        
        .service-duration {
            background: #e3f2fd;
            color: #1976d2;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        
        .service-select-checkbox {
            position: absolute;
            top: 15px;
            right: 15px;
            width: 25px;
            height: 25px;
            cursor: pointer;
        }
        
        .service-select-indicator {
            position: absolute;
            top: 15px;
            right: 15px;
            width: 30px;
            height: 30px;
            background: rgba(255,255,255,0.9);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            color: #28a745;
            opacity: 0;
            transition: all 0.3s ease;
        }
        
        .service-card.selected .service-select-indicator {
            opacity: 1;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        .loading-state {
            text-align: center;
            padding: 60px 20px;
            color: #007bff;
        }
        
        .loading-spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #007bff;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .continue-section {
            background: #fff;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .selected-services-summary {
            margin-bottom: 25px;
        }
        
        .selected-count {
            font-size: 1.1rem;
            color: #495057;
            margin-bottom: 15px;
        }
        
        .total-price {
            font-size: 1.5rem;
            font-weight: 700;
            color: #28a745;
        }
        
        .continue-btn {
            background: linear-gradient(135deg, #28a745, #20c997);
            border: none;
            color: #fff;
            padding: 15px 40px;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 50px;
            transition: all 0.3s ease;
            min-width: 200px;
        }
        
        .continue-btn:hover {
            background: linear-gradient(135deg, #218838, #1aa085);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40,167,69,0.3);
        }
        
        .continue-btn:disabled {
            background: #6c757d;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        
        @media (max-width: 768px) {
            .selection-header h1 {
                font-size: 2rem;
            }
            
            .services-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .service-types-grid {
                grid-template-columns: 1fr;
            }
            
            .price-slider-group {
                flex-direction: column;
                gap: 20px;
            }
            
            .price-slider {
                width: 100%;
            }
        }
    </style>
</head>
<body id="bg">
    <div class="page-wraper">
        <div id="loading-area"></div>

        <!-- Header -->
        <jsp:include page="/WEB-INF/view/common/home/header.jsp"></jsp:include>
        <!-- Header END -->
        
        <!-- Content -->
        <div class="page-content bg-white">
            <!-- Inner page banner -->
            <div class="dlab-bnr-inr overlay-primary bg-pt" 
                 style="background-image: url(${pageContext.request.contextPath}/assets/home/images/banner/bnr2.jpg);">
                <div class="container">
                    <div class="dlab-bnr-inr-entry">
                        <h1 class="text-white">Chọn Dịch Vụ</h1>
                        <!-- Breadcrumb row -->
                        <div class="breadcrumb-row">
                            <ul class="list-inline">
                                <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                                <li><a href="${pageContext.request.contextPath}/process-booking">Đặt lịch</a></li>
                                <li>Chọn dịch vụ</li>
                            </ul>
                        </div>
                        <!-- Breadcrumb row END -->
                    </div>
                </div>
            </div>
            <!-- Inner page banner END -->
            
            <!-- Services Selection Area -->
            <div class="section-full services-selection-container">
                <div class="container">
                    <!-- Selection Header -->
                    <div class="selection-header">
                        <h1>Chọn Dịch Vụ Yêu Thích</h1>
                        <p>Khám phá và lựa chọn những dịch vụ spa tốt nhất phù hợp với nhu cầu của bạn</p>
                    </div>

    <!-- Service booking form -->
                    <form id="serviceSelectionForm" action="${pageContext.request.contextPath}/process-booking" method="post">
                        <input type="hidden" name="bookingType" value="individual" />
    
                        <!-- Filters Section -->
                        <div class="filters-section">
    <!-- Search functionality -->
                            <div class="search-container">
                                <h5 class="font-weight-700 m-b20 text-center">Tìm Kiếm Dịch Vụ</h5>
                                <div class="search-input-group">
                                    <input type="search" 
                                           id="searchInput" 
                                           name="search" 
                                           placeholder="Nhập tên dịch vụ để tìm kiếm..." 
                                           oninput="handleSearchInput()">
                                    <button type="button" class="search-clear-btn" onclick="clearSearch()">
                                        <i class="fa fa-times"></i>
                                    </button>
                                </div>
    </div>

    <!-- Service type filter buttons -->
                            <div class="service-types-section">
                                <h5 class="font-weight-700 m-b20 text-center">Danh Mục Dịch Vụ</h5>
                                <div class="service-types-container service-types-grid">
                                    <!-- Service types will be loaded here by JavaScript -->
                                    <c:forEach var="serviceType" items="${serviceTypes}">
                                        <button type="button" 
                                                class="service-type-btn" 
                                                onclick="selectCategory(${serviceType.serviceTypeId})"
                                                data-type-id="${serviceType.serviceTypeId}">
                                            ${serviceType.name}
                                        </button>
                                    </c:forEach>
                                </div>
    </div>

    <!-- Price range filter -->
                            <div class="price-range-container">
                                <h5 class="price-range-title">Lọc Theo Giá</h5>
                                <div class="price-slider-group">
                                    <div class="price-slider-item">
                                        <label>Từ:</label>
                                        <input type="range" 
                                               id="minPriceSlider" 
                                               name="minPrice" 
                                               class="price-slider"
                                               step="100000" 
                                               value="${minPrice}" 
                                               min="${minPrice}" 
                                               max="${maxPrice}" 
                                               oninput="updatePriceRange()">
                                        <span id="minPriceValue" class="price-value">
                                            <fmt:formatNumber value="${minPrice}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/>
                                        </span>
                                    </div>
                                    
                                    <div class="price-slider-item">
                                        <label>Đến:</label>
                                        <input type="range" 
                                               id="maxPriceSlider" 
                                               name="maxPrice" 
                                               class="price-slider"
                                               step="100000" 
                                               value="${maxPrice}" 
                                               min="${minPrice}" 
                                               max="${maxPrice}" 
                                               oninput="updatePriceRange()">
                                        <span id="maxPriceValue" class="price-value">
                                            <fmt:formatNumber value="${maxPrice}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/>
                                        </span>
                                    </div>
                                </div>
                            </div>
    </div>

    <!-- Main services display area -->
                        <div class="services-display-section">
                            <div class="services-container services-grid">
                                <!-- Services will be loaded here by JavaScript -->
                                <c:choose>
                                    <c:when test="${not empty services}">
                                        <c:forEach var="service" items="${services}">
                                            <div class="service-card" data-service-id="${service.serviceId}">
                                                <input type="checkbox" 
                                                       name="selectedServices" 
                                                       value="${service.serviceId}" 
                                                       class="service-select-checkbox" 
                                                       id="service_${service.serviceId}"
                                                       onchange="updateServiceSelection(this)">
                                                
                                                <div class="service-select-indicator">
                                                    <i class="fa fa-check"></i>
                                                </div>
                                                
                                                <div class="service-card-header">
                                                    <c:choose>
                                                        <c:when test="${not empty service.imageUrl}">
                                                            <img src="${service.imageUrl}" 
                                                                 alt="${service.name}" 
                                                                 class="service-card-image">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="service-card-image" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 3rem;">
                                                                <i class="fa fa-spa"></i>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                
                                                <div class="service-card-content">
                                                    <h3 class="service-title">${service.name}</h3>
                                                    <p class="service-description">${service.description}</p>
                                                    
                                                    <div class="service-details">
                                                        <div class="service-price">
                                                            <fmt:formatNumber value="${service.price}" type="currency" currencySymbol="₫" pattern="#,##0 ₫"/>
                                                        </div>
                                                        <div class="service-duration">
                                                            <i class="fa fa-clock-o"></i> ${service.durationMinutes} phút
                                                        </div>
                                                    </div>
                                                    
                                                    <c:if test="${service.averageRating != null && service.averageRating > 0}">
                                                        <div class="service-rating">
                                                            <c:forEach begin="1" end="5" var="star">
                                                                <i class="fa fa-star${star <= service.averageRating ? '' : '-o'}"></i>
                                                            </c:forEach>
                                                            <span>(${service.averageRating})</span>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state">
                                            <i class="fa fa-search"></i>
                                            <h4>Không tìm thấy dịch vụ</h4>
                                            <p>Vui lòng thử lại với từ khóa khác hoặc điều chỉnh bộ lọc</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Continue Section -->
                        <div class="continue-section">
                            <div class="selected-services-summary">
                                <div class="selected-count">
                                    Đã chọn: <span id="selectedCount">0</span> dịch vụ
                                </div>
                                <div class="total-price">
                                    Tổng cộng: <span id="totalPrice">0 ₫</span>
                                </div>
    </div>

                            <button type="submit" id="continueBtn" class="continue-btn" disabled>
                                <i class="fa fa-arrow-right"></i> Tiếp Tục Đặt Lịch
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            <!-- Services Selection Area END -->
        </div>
        <!-- Content END -->
        
        <!-- Footer -->
        <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
        <!-- Footer END -->
        
        <button class="scroltop fa fa-chevron-up"></button>
    </div>

    <!-- JAVASCRIPT FILES -->
    <jsp:include page="/WEB-INF/view/common/home/js.jsp"></jsp:include>
    
    <!-- Pass server data to external JavaScript -->
    <script>
        // Configuration for external JavaScript
        window.serviceSelectionConfig = {
            minPrice: ${minPrice},
            maxPrice: ${maxPrice}
        };
    </script>
    
    <!-- Enhanced Services Selection JavaScript -->
    <script src="${pageContext.request.contextPath}/assets/home/js/services-selection.js"></script>
</body>
</html>
