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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beauty Salon Booking Interface</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/home/css/sevices-selection.css">
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="header-left">
                    <button class="icon-btn">
                        <i class="fas fa-arrow-left"></i>
                    </button>
                    <nav class="breadcrumb">
                        <span class="breadcrumb-item">Dịch vụ</span>
                        <i class="fas fa-chevron-right"></i>
                        <span class="breadcrumb-item">Chuyên nghiệp</span>
                        <i class="fas fa-chevron-right"></i>
                        <span class="breadcrumb-item">Thời gian</span>
                        <i class="fas fa-chevron-right"></i>
                        <span class="breadcrumb-item active">Xác nhận</span>
                    </nav>
                </div>
                <button class="icon-btn">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>
    </header>

    <main class="main">
        <div class="container">
            <div class="content-grid">
                <!-- Main Content -->
                <div class="main-content">
                    <h1 class="page-title">Dịch vụ</h1>
                    
                    <!-- Search Bar -->
                    <div class="search-container">
                        <i class="fas fa-search search-icon"></i>
                        <input type="text" id="searchInput" placeholder="Tìm kiếm dịch vụ..." class="search-input">
                    </div>

                    <!-- Price Range Filter -->
                    <div class="filter-card">
                        <h3 class="filter-title">Khoảng giá</h3>
                        <div class="price-inputs">
                            <div class="price-input-group">
                                <label class="price-label">Giá tối thiểu</label>
                                <div class="price-input-wrapper">
                                    <span class="currency">£</span>
                                    <input type="number" id="minPriceInput" min="0" max="100" value="0" class="price-input">
                                </div>
                            </div>
                            <div class="price-input-group">
                                <label class="price-label">Giá tối đa</label>
                                <div class="price-input-wrapper">
                                    <span class="currency">£</span>
                                    <input type="number" id="maxPriceInput" min="0" max="100" value="100" class="price-input">
                                </div>
                            </div>
                        </div>
                        
                        <!-- Dual Range Slider -->
                        <div class="slider-container">
                            <div class="slider-labels">
                                <span>£0</span>
                                <span>£100</span>
                            </div>
                            <div class="slider-wrapper">
                                <div class="slider-track"></div>
                                <div class="slider-range" id="sliderRange"></div>
                                <input type="range" id="minSlider" min="0" max="100" value="0" class="slider slider-min">
                                <input type="range" id="maxSlider" min="0" max="100" value="100" class="slider slider-max">
                            </div>
                            <div class="slider-values">
                                <span id="minValue">£0</span>
                                <span id="maxValue">£100</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Category Navigation -->
                    <div class="category-nav">
                        <button class="category-btn active" data-category="featured">Nổi bật</button>
                        <button class="category-btn" data-category="manicures">Manicures</button>
                        <button class="category-btn" data-category="pedicures">Pedicures</button>
                        <button class="category-btn" data-category="brows">Brows & Lashes - Eye mak...</button>
                        <button class="category-btn" data-category="eyebrows">Eyebrows</button>
                    </div>

                    <!-- Services Section -->
                    <div class="services-section">
                        <div class="services-header">
                            <h2 class="services-title" id="servicesTitle">Nổi bật</h2>
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
                        <!-- Salon Info -->
                        <div class="salon-info">
                            <div class="salon-image">
                                <img src="https://images.pexels.com/photos/3993449/pexels-photo-3993449.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2" alt="Perfect You Salon">
                            </div>
                            <div class="salon-details">
                                <h3 class="salon-name">Perfect You</h3>
                                <div class="salon-rating">
                                    <div class="stars">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                    </div>
                                    <span class="rating-score">4.9</span>
                                    <span class="rating-count">(1,655)</span>
                                </div>
                                <div class="salon-address">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <span>101 Stanley Road, Teddington, England</span>
                                </div>
                            </div>
                        </div>

                        <!-- Selected Services -->
                        <div class="selected-services">
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


    <script src="${pageContext.request.contextPath}/assets/home/js/service-selection.js"></script>
</body>
</html>