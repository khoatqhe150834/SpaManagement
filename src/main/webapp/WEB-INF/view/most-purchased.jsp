<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="context-path" content="${pageContext.request.contextPath}" />
    <title>Dịch vụ được mua nhiều nhất - Spa Hương Sen</title>
    
    <!-- Tailwind CSS, Google Fonts, Lucide Icons -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              primary: "#D4AF37", "primary-dark": "#B8941F",
              secondary: "#FADADD", "spa-cream": "#FFF8F0", "spa-dark": "#333333",
            },
            fontFamily: {
              serif: ["Playfair Display", "serif"],
              sans: ["Roboto", "sans-serif"],
            },
          },
        },
      };
    </script>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet"/>
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
    
    <style>
        /* Service card hover effects and stability */
        .service-card {
            transition: box-shadow 0.3s ease, transform 0.2s ease;
            min-height: 450px;
            position: relative;
            display: flex;
            flex-direction: column;
            background: white;
            border-radius: 0.5rem;
            overflow: hidden;
        }
        .service-card:hover {
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            transform: translateY(-2px);
        }
        
        /* Image container stability */
        .service-card .relative.h-48 {
            background-color: #f9fafb;
            height: 192px !important;
            min-height: 192px !important;
            max-height: 192px;
            overflow: hidden;
            position: relative;
            flex-shrink: 0;
        }
        
        /* Image stability */
        .service-card img {
            opacity: 1;
            width: 100%;
            height: 100%;
            object-fit: cover;
            position: relative;
            z-index: 2;
            transition: transform 0.3s ease;
        }
        
        /* Service content area stability */
        .service-card .p-5 {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        
        /* Price formatting */
        .price-display {
            font-family: 'Roboto', sans-serif;
            font-weight: 700;
        }
        
        /* Price Range Slider Styles */
        .slider-track {
            position: relative;
            background: #e5e7eb;
            border-radius: 9999px;
            height: 8px;
        }
        
        .slider-range {
            position: absolute;
            background: #D4AF37;
            border-radius: 9999px;
            height: 8px;
            top: 0;
        }
        
        .slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            pointer-events: none;
            height: 8px;
            background: transparent;
            border: none;
            outline: none;
        }
        
        .slider-thumb::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            pointer-events: auto;
            height: 20px;
            width: 20px;
            border-radius: 50%;
            background: #D4AF37;
            border: 2px solid white;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
            cursor: pointer;
            position: relative;
            z-index: 10;
        }
        
        .slider-thumb::-moz-range-thumb {
            pointer-events: auto;
            height: 20px;
            width: 20px;
            border-radius: 50%;
            background: #D4AF37;
            border: 2px solid white;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
            cursor: pointer;
            border: none;
            outline: none;
        }
        
        .slider-thumb::-moz-range-track {
            background: transparent;
            border: none;
        }
        
        /* Booking count badge styles - blue theme with icon */
        .service-card .booking-count-badge {
            background-color: #3b82f6 !important; /* bg-blue-500 */
            color: white !important;
            font-size: 0.75rem !important; /* text-xs */
            font-weight: 600 !important; /* font-semibold */
            padding: 4px 8px !important; /* px-2 py-1 */
            position: absolute !important;
            z-index: 9999 !important; /* Higher than z-10 for safety */
            border-radius: 9999px !important; /* rounded-full */
            top: 12px !important; /* top-3 */
            right: 12px !important; /* right-3 */
            display: flex !important;
            align-items: center !important;
            pointer-events: none !important;
            white-space: nowrap !important;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06) !important;
        }
        
        /* Icon styling within badge */
        .service-card .booking-count-badge svg {
            height: 0.75rem !important; /* h-3 w-3 */
            width: 0.75rem !important;
            margin-right: 4px !important; /* mr-1 */
            stroke: currentColor !important;
            stroke-width: 2 !important;
        }
        
        /* Ensure image doesn't cover the badge */
        .service-card .relative.h-48 {
            z-index: 1 !important;
        }
        
        .service-card img {
            z-index: 1 !important;
        }
    </style>
</head>
<body class="bg-spa-cream">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    
    <main class="pt-20 min-h-screen">
        <!-- Page Header -->
        <section class="bg-gradient-to-r from-primary to-primary-dark text-white py-16">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
                <h1 class="text-4xl md:text-5xl font-serif font-bold mb-4">Dịch Vụ Được Mua Nhiều Nhất</h1>
                <p class="text-xl opacity-90 max-w-2xl mx-auto">Những dịch vụ được khách hàng yêu thích và đặt mua nhiều nhất tại Spa Hương Sen.</p>
            </div>
        </section>

        <!-- Search and Filter Section -->
        <section class="bg-white py-8 border-b border-gray-200">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex flex-col md:flex-row gap-4 items-center justify-between">
                    <div class="relative flex-1 max-w-md">
                        <input type="text" id="search-input" placeholder="Tìm trong các dịch vụ phổ biến..." class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-full focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"/>
                        <i data-lucide="search" class="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400"></i>
                    </div>
                    <div class="text-gray-600">
                        <span id="results-count">Hiển thị 0 kết quả</span>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- Services Content -->
        <section class="py-12">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <!-- Loading Indicator -->
                <div id="loading-indicator" class="text-center py-12">
                    <div class="flex justify-center items-center"><div class="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div><p class="text-gray-600 ml-3">Đang tải dịch vụ...</p></div>
                </div>

                <div id="content-wrapper" class="hidden">
                    <div class="flex gap-8">
                        <!-- Filters Sidebar -->
                        <aside id="filters-sidebar" class="hidden md:block w-64 flex-shrink-0">
                            <div class="bg-white rounded-lg p-6 shadow-lg sticky top-24">
                                <div class="flex items-center justify-between mb-6">
                                    <h3 class="text-lg font-semibold text-spa-dark">Bộ lọc</h3>
                                    <button id="clear-filters" class="text-primary hover:text-primary-dark text-sm">Xóa tất cả</button>
                                </div>
                                <div class="mb-6">
                                    <h4 class="font-medium text-spa-dark mb-3">Loại dịch vụ</h4>
                                    <select id="service-type-select" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary text-sm">
                                        <option value="all">Tất cả dịch vụ</option>
                                        <c:forEach var="serviceType" items="${serviceTypes}">
                                            <option value="${serviceType.serviceTypeId}">${serviceType.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                
                                <!-- Price Range -->
                                <div class="mb-6">
                                    <h4 class="font-medium text-spa-dark mb-3">Khoảng giá</h4>
                                    
                                    <!-- Price input fields -->
                                    <div class="flex gap-2 mb-4">
                                        <input type="number" id="min-price-input" placeholder="100000" class="w-full px-3 py-2 text-center border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent text-sm">
                                        <span class="self-center text-gray-500">-</span>
                                        <input type="number" id="max-price-input" placeholder="15000000" class="w-full px-3 py-2 text-center border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent text-sm">
                                    </div>
                                    
                                    <!-- Price display -->
                                    <div class="text-sm text-gray-600 text-center mb-3">
                                        Giá từ <span id="min-price-display">100.000 ₫</span> - <span id="max-price-display">15.000.000 ₫</span>
                                    </div>
                                    
                                    <!-- Dual range slider -->
                                    <div class="relative mt-4">
                                        <div class="slider-track h-2 bg-gray-200 rounded-full relative">
                                            <div id="slider-range" class="slider-range h-2 bg-primary rounded-full absolute" style="left: 0%; width: 100%;"></div>
                                            <input type="range" id="min-price-slider" min="100000" max="15000000" value="100000" step="50000" class="slider-thumb absolute w-full h-2 bg-transparent appearance-none cursor-pointer">
                                            <input type="range" id="max-price-slider" min="100000" max="15000000" value="15000000" step="50000" class="slider-thumb absolute w-full h-2 bg-transparent appearance-none cursor-pointer">
                                        </div>
                                    </div>
                                    
                                    <!-- Price range limits -->
                                    <div class="flex justify-between text-xs text-gray-500 mt-2">
                                        <span>Giá tối thiểu</span>
                                        <span>Giá tối đa</span>
                                    </div>
                                    
                                    <div class="flex justify-between text-xs text-gray-500">
                                        <span id="price-min-limit">100.000 ₫</span>
                                        <span id="price-max-limit">15.000.000 ₫</span>
                                    </div>
                                </div>
                            </div>
                        </aside>

                        <!-- Services Grid -->
                        <div class="flex-1">
                            <div class="flex justify-between items-center mb-6">
                                <h2 class="text-2xl font-serif font-bold text-spa-dark">Dịch vụ phổ biến</h2>
                                <select id="sort-select" class="border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
                                    <option value="purchase-desc">Được mua nhiều nhất</option>
                                    <option value="name-asc">Tên A-Z</option><option value="name-desc">Tên Z-A</option>
                                    <option value="price-asc">Giá thấp đến cao</option><option value="price-desc">Giá cao đến thấp</option>
                                    <option value="rating-desc">Đánh giá cao nhất</option>
                                </select>
                            </div>
                            <div id="services-grid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8"></div>
                            <div id="pagination" class="flex justify-center items-center space-x-2"></div>
                        </div>
                    </div>
                </div>
                
                <!-- No Results State -->
                <div id="no-results" class="text-center py-12 hidden">
                    <i data-lucide="trending-up" class="h-16 w-16 mx-auto mb-4 text-gray-400"></i>
                    <p class="text-gray-600 text-lg">Không tìm thấy dịch vụ phổ biến nào.</p>
                    <a href="<c:url value='/services'/>" class="mt-4 inline-block px-6 py-3 bg-primary text-white rounded-full hover:bg-primary-dark transition-colors">Khám phá tất cả dịch vụ</a>
                </div>
            </div>
        </section>
    </main>
    
    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
    
    <!-- AI Chatbot -->
    
    
    <div id="notification" class="notification"></div>
    
    <!-- JavaScript -->
    <script src="<c:url value='/js/app.js'/>"></script>

    <script src="<c:url value='/js/most-purchased.js'/>"></script>
</body>
</html> 