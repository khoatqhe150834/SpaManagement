<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dịch vụ - Spa Hương Sen</title>

    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              primary: "#D4AF37",
              "primary-dark": "#B8941F",
              secondary: "#FADADD",
              "spa-cream": "#FFF8F0",
              "spa-dark": "#333333",
            },
            fontFamily: {
              serif: ["Playfair Display", "serif"],
              sans: ["Roboto", "sans-serif"],
            },
          },
        },
      };
    </script>

    <!-- Google Fonts -->
    <link
      href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap"
      rel="stylesheet"
    />

    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>

    <!-- Custom CSS -->
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
    
    <style>
      /* Line clamp utilities for text truncation */
      .line-clamp-2 {
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
      }
      .line-clamp-3 {
        display: -webkit-box;
        -webkit-line-clamp: 3;
        -webkit-box-orient: vertical;
        overflow: hidden;
      }
      
      /* Service card hover effects and stability */
      .service-card {
        transition: box-shadow 0.3s ease, transform 0.2s ease;
        min-height: 450px; /* Increased for better stability */
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
        background-color: #f9fafb; /* Slightly lighter gray */
        height: 192px !important; /* Force fixed height */
        min-height: 192px !important; /* Ensure minimum height */
        max-height: 192px; /* Prevent overflow */
        overflow: hidden;
        position: relative;
        flex-shrink: 0; /* Prevent shrinking */
      }
      
      /* Image stability - no transitions needed */
      .service-card img {
        opacity: 1; /* Always visible */
        width: 100%;
        height: 100%;
        object-fit: cover;
        position: relative;
        z-index: 2;
        transition: transform 0.3s ease; /* Only transition for hover effects */
      }
      .service-card img.loaded {
        opacity: 1; /* Ensure always visible */
      }
      
      /* Fallback and default image styles */
      .service-card .fallback-image {
        opacity: 1 !important; /* Always show fallback images */
      }
      .service-card .default-image {
        opacity: 1 !important; /* Always show default images */
      }
      
      /* Loading indicator enhancement */
      .image-loading {
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        z-index: 15;
        background-color: #f9fafb;
        display: flex !important;
        align-items: center;
        justify-content: center;
        opacity: 1;
        transition: opacity 0.3s ease;
      }
      .image-loading.hidden {
        opacity: 0;
        pointer-events: none;
      }
      
      /* Gradient placeholder */
      .service-card .bg-gradient-to-br {
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        z-index: 5;
        opacity: 0;
        transition: opacity 0.3s ease;
      }
      .service-card .bg-gradient-to-br.show {
        opacity: 1;
      }
      
      /* Service content area stability */
      .service-card .p-6 {
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
      
      /* Debug styles */
      .service-card[data-load-order] {
        border: 1px solid transparent; /* Maintain consistent border spacing */
      }
    </style>
  </head>

  <body class="bg-spa-cream" 
        data-default-image-url="<c:url value='/services/default.jpg'/>" 
        data-service-details-url="<c:url value='/service-details'/>">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />

    <!-- Main Content -->
    <main class="pt-20">
      <!-- Page Header -->
      <section
        class="bg-gradient-to-r from-primary to-primary-dark text-white py-16"
      >
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 class="text-4xl md:text-5xl font-serif font-bold mb-4">
            Dịch Vụ Spa
          </h1>
          <p class="text-xl opacity-90 max-w-2xl mx-auto">
            Khám phá các dịch vụ chăm sóc sắc đẹp cao cấp được thiết kế đặc biệt
            cho phụ nữ Việt Nam
          </p>
        </div>
      </section>

      <!-- Search and Filter Section -->
      <section class="bg-white py-8 border-b border-gray-200">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div
            class="flex flex-col md:flex-row gap-4 items-center justify-between"
          >
            <!-- Search Bar -->
            <div class="relative flex-1 max-w-md">
              <input
                type="text"
                id="search-input"
                placeholder="Tìm kiếm dịch vụ..."
                class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-full focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
              />
              <i
                data-lucide="search"
                class="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400"
              ></i>
            </div>

            <!-- Filter Toggle (Mobile) -->
            <button
              id="mobile-filter-btn"
              class="md:hidden flex items-center px-4 py-2 bg-primary text-white rounded-full"
            >
              <i data-lucide="filter" class="h-4 w-4 mr-2"></i>
              Bộ lọc
            </button>

            <!-- Results Info -->
            <div class="text-gray-600">
              <span id="results-count">Đang tải...</span>
            </div>
          </div>
        </div>
      </section>

      <!-- Services Content -->
      <section class="py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="flex gap-8">
            <!-- Sidebar Filters -->
            <aside
              id="filters-sidebar"
              class="hidden md:block w-64 flex-shrink-0"
            >
              <div class="bg-white rounded-lg p-6 shadow-lg sticky top-24">
                <div class="flex items-center justify-between mb-6">
                  <h3 class="text-lg font-semibold text-spa-dark">Bộ lọc</h3>
                  <button
                    id="clear-filters"
                    class="text-primary hover:text-primary-dark text-sm"
                  >
                    Xóa tất cả
                  </button>
                </div>

                <!-- Service Types -->
                <div class="mb-6">
                  <h4 class="font-medium text-spa-dark mb-3">Loại dịch vụ</h4>
                  <select
                    id="service-type-select"
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent text-sm"
                  >
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
                    <input
                      type="number"
                      id="min-price-input"
                      placeholder="100000"
                      class="w-full px-3 py-2 text-center border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent text-sm"
                    />
                    <span class="self-center text-gray-500">-</span>
                    <input
                      type="number"
                      id="max-price-input"
                      placeholder="1500000"
                      class="w-full px-3 py-2 text-center border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent text-sm"
                    />
                  </div>
                  
                  <!-- Price display -->
                  <div class="text-sm text-gray-600 text-center mb-3">
                    Giá từ <span id="min-price-display">100.000 ₫</span> - <span id="max-price-display">15.000.000 ₫</span>
                  </div>
                  
                  <!-- Dual range slider -->
                  <div class="relative mt-4">
                    <div class="slider-track h-2 bg-gray-200 rounded-full relative">
                      <div id="slider-range" class="slider-range h-2 bg-primary rounded-full absolute"></div>
                      <input
                        type="range"
                        id="min-price-slider"
                        min="100000"
                        max="15000000"
                        value="100000"
                        step="50000"
                        class="slider-thumb absolute w-full h-2 bg-transparent appearance-none cursor-pointer"
                      />
                      <input
                        type="range"
                        id="max-price-slider"
                        min="100000"
                        max="15000000"
                        value="15000000"
                        step="50000"
                        class="slider-thumb absolute w-full h-2 bg-transparent appearance-none cursor-pointer"
                      />
                    </div>
                  </div>
                  
                  <!-- Price range limits -->
                  <div class="flex justify-between text-xs text-gray-500 mt-2">
                    <span>Giá tối thiểu</span>
                    <span>Giá tối đa</span>
                  </div>
                  
                  <div class="flex justify-between text-xs text-gray-500">
                    <span id="price-min-limit">100K ₫</span>
                    <span id="price-max-limit">15.0M ₫</span>
                  </div>
                </div>
              </div>
            </aside>

            <!-- Services Grid -->
            <div class="flex-1">
              <!-- Sort Options -->
              <div class="flex justify-between items-center mb-6">
                <h2 class="text-2xl font-serif font-bold text-spa-dark">
                  Tất cả dịch vụ
                </h2>
                <select
                  id="sort-select"
                  class="border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary"
                >
                  <option value="default">Sắp xếp theo</option>
                  <option value="name-asc">Tên A-Z</option>
                  <option value="name-desc">Tên Z-A</option>
                  <option value="price-asc">Giá thấp đến cao</option>
                  <option value="price-desc">Giá cao đến thấp</option>
                  <option value="rating-desc">Đánh giá cao nhất</option>
                </select>
              </div>

              <!-- Services List -->
              <div
                id="services-grid"
                class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8"
              >
                <!-- Services will be loaded dynamically by JavaScript -->

                <!-- Error message -->
                <c:if test="${not empty errorMessage}">
                  <div class="col-span-full text-center py-12">
                    <i data-lucide="alert-circle" class="h-12 w-12 text-red-400 mx-auto mb-4"></i>
                    <h3 class="text-lg font-medium text-red-700 mb-2">Có lỗi xảy ra</h3>
                    <p class="text-red-500">${errorMessage}</p>
                    <button onclick="location.reload()" class="mt-4 bg-primary text-white px-4 py-2 rounded-lg hover:bg-primary-dark transition-colors">
                      Thử lại
                    </button>
                  </div>
                </c:if>

                <!-- No services message -->
                <c:if test="${empty services and empty errorMessage}">
                  <div class="col-span-full text-center py-12">
                    <i data-lucide="search" class="h-12 w-12 text-gray-400 mx-auto mb-4"></i>
                    <h3 class="text-lg font-medium text-gray-700 mb-2">Không tìm thấy dịch vụ</h3>
                    <p class="text-gray-500">Hãy thử điều chỉnh bộ lọc hoặc tìm kiếm với từ khóa khác.</p>
                  </div>
                </c:if>
              </div>

              <!-- Pagination -->
              <div
                id="pagination"
                class="flex justify-center items-center space-x-2"
              >
                <!-- Pagination will be dynamically loaded here -->
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

    <!-- Service Detail Modal -->
    <div id="service-modal" class="modal">
      <div
        class="modal-content bg-white rounded-lg max-w-4xl mx-4 max-h-[90vh] overflow-y-auto"
      >
        <div
          class="sticky top-0 bg-white border-b border-gray-200 p-4 flex justify-between items-center"
        >
          <h3
            id="modal-title"
            class="text-xl font-serif font-bold text-spa-dark"
          ></h3>
          <button id="close-modal" class="text-gray-500 hover:text-gray-700">
            <i data-lucide="x" class="h-6 w-6"></i>
          </button>
        </div>

        <div id="modal-body" class="p-6">
          <!-- Modal content will be dynamically loaded -->
        </div>
      </div>
    </div>

    <!-- Mobile Filter Modal -->
    <div id="mobile-filter-modal" class="modal">
      <div
        class="modal-content bg-white rounded-lg max-w-md mx-4 max-h-[90vh] overflow-y-auto"
      >
        <div
          class="sticky top-0 bg-white border-b border-gray-200 p-4 flex justify-between items-center"
        >
          <h3 class="text-lg font-semibold">Bộ lọc</h3>
          <button
            id="close-mobile-filter"
            class="text-gray-500 hover:text-gray-700"
          >
            <i data-lucide="x" class="h-6 w-6"></i>
          </button>
        </div>

        <div class="p-4">
          <!-- Mobile Service Type Filter -->
          <div class="mb-6">
            <h4 class="font-medium text-spa-dark mb-3">Loại dịch vụ</h4>
            <select
              id="mobile-service-type-select"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent text-sm"
            >
              <option value="all">Tất cả dịch vụ</option>
                    <c:forEach var="serviceType" items="${serviceTypes}">
                      <option value="${serviceType.serviceTypeId}">${serviceType.name}</option>
                    </c:forEach>
            </select>
          </div>



          <div class="flex gap-2 mt-6">
            <button
              id="clear-mobile-filters"
              class="w-full border border-gray-300 text-gray-700 py-2 rounded-lg"
            >
              Xóa bộ lọc
            </button>
          </div>
        </div>
      </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />

    <!-- JavaScript -->
    <script src="<c:url value='/js/app.js'/>"></script>
    <!-- cart.js is already included in header.jsp -->
    <script src="<c:url value='/js/service-tracker.js'/>"></script>
    <script src="<c:url value='/js/recently-viewed-services.js'/>"></script>
    <script src="<c:url value='/js/homepage-sections.js'/>"></script>
    <script src="<c:url value='/js/services-api.js'/>"></script>
    <script src="<c:url value='/js/services.js'/>"></script>
    
    <!-- Pass server-side data to JavaScript -->
    <script>
      // Pass server-side data to JavaScript (avoiding EL expression issues)
      window.servicesPageData = {
        contextPath: '<c:url value="/"/>',
        defaultImageUrl: '<c:url value="/services/default.jpg"/>',
        serviceDetailsUrl: '<c:url value="/service-details"/>',
        priceRange: {
          min: 100000,
          max: 15000000
        },
        totalServices: 0
      };

      // Initialize Services Page Manager when DOM is ready
      document.addEventListener('DOMContentLoaded', function() {
        console.log('Services page loading...');
        try {
          window.servicesManager = new ServicesPageManager();
          console.log('Services page loaded successfully');
        } catch (error) {
          console.error('Failed to initialize ServicesPageManager:', error);
        }
      });
    </script>
  </body>
</html>
