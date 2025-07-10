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
      
      /* Service card hover effects */
      .service-card {
        transition: all 0.3s ease;
      }
      .service-card:hover {
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
      }
      
      /* Image loading skeleton */
      .service-card img {
        transition: opacity 0.3s ease;
      }
      .service-card img[src=""] {
        opacity: 0;
      }
      
      /* Price formatting */
      .price-display {
        font-family: 'Roboto', sans-serif;
        font-weight: 700;
      }
    </style>
  </head>

  <body class="bg-spa-cream">
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
              <span id="results-count">Hiển thị ${services != null ? services.size() : 0} kết quả</span>
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

                <!-- Price Range - Dynamic double slider will be inserted here -->
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
                <!-- Server-side rendered services -->
                <c:forEach var="service" items="${services}">
                  <div class="bg-white rounded-lg shadow-lg overflow-hidden transition-transform hover:scale-105 service-card" 
                       data-service-id="${service.serviceId}"
                       data-service-name="${service.name}"
                       data-service-price="${service.price}"
                       data-service-type="${service.serviceTypeId.serviceTypeId}">
                    
                    <!-- Service Image -->
                    <div class="relative h-48 overflow-hidden">
                      <c:choose>
                        <c:when test="${not empty service.imageUrl}">
                          <img 
                            src="<c:url value='${service.imageUrl}'/>" 
                            alt="${service.name}"
                            class="w-full h-full object-cover transition-transform hover:scale-110"
                            loading="lazy"
                            onerror="this.src='<c:url value='/services/default.jpg'/>'; this.onerror=null;"
                          />
                        </c:when>
                        <c:otherwise>
                          <!-- Default image for services without images -->
                          <img 
                            src="<c:url value='/services/default.jpg'/>" 
                            alt="Default service image"
                            class="w-full h-full object-cover transition-transform hover:scale-110"
                            loading="lazy"
                            onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';"
                          />
                          <!-- Ultimate fallback: gradient placeholder -->
                          <div class="w-full h-full bg-gradient-to-br from-primary/20 to-secondary/30 flex items-center justify-center" style="display: none;">
                            <i data-lucide="image" class="h-12 w-12 text-primary/50"></i>
                          </div>
                        </c:otherwise>
                      </c:choose>
                      
                      <!-- Image count badge for multiple images -->
                      <c:if test="${serviceImageCounts[service.serviceId] > 1}">
                        <div class="absolute top-2 right-2 bg-black/70 text-white text-xs px-2 py-1 rounded-full">
                          <i data-lucide="images" class="h-3 w-3 inline mr-1"></i>
                          ${serviceImageCounts[service.serviceId]}
                        </div>
                      </c:if>
                    </div>

                    <!-- Service Content -->
                    <div class="p-6">
                      <!-- Service Category -->
                      <div class="text-primary text-sm font-medium mb-2">
                        ${service.serviceTypeId.name}
                      </div>

                      <!-- Service Name -->
                      <h3 class="font-serif font-bold text-lg text-spa-dark mb-2 line-clamp-2">
                        ${service.name}
                      </h3>

                      <!-- Service Description -->
                      <p class="text-gray-600 text-sm mb-4 line-clamp-3">
                        ${service.description}
                      </p>

                      <!-- Service Details -->
                      <div class="flex items-center justify-between mb-4">
                        <!-- Duration -->
                        <div class="flex items-center text-gray-500 text-sm">
                          <i data-lucide="clock" class="h-4 w-4 mr-1"></i>
                          ${service.durationMinutes} phút
                        </div>
                        
                        <!-- Rating -->
                        <div class="flex items-center">
                          <div class="flex text-yellow-400">
                            <c:forEach begin="1" end="5" var="star">
                              <c:choose>
                                <c:when test="${star <= service.averageRating}">
                                  <i data-lucide="star" class="h-4 w-4 fill-current"></i>
                                </c:when>
                                <c:otherwise>
                                  <i data-lucide="star" class="h-4 w-4"></i>
                                </c:otherwise>
                              </c:choose>
                            </c:forEach>
                          </div>
                          <span class="text-gray-600 text-sm ml-1">
                            (<fmt:formatNumber value="${service.averageRating}" maxFractionDigits="1"/>)
                          </span>
                        </div>
                      </div>

                      <!-- Price and Action -->
                      <div class="flex items-center justify-between">
                        <div class="text-primary font-bold text-xl">
                          <fmt:formatNumber value="${service.price}" type="currency" currencyCode="VND" pattern="###,###" />₫
                        </div>
                        
                        <button 
                          class="bg-primary text-white px-4 py-2 rounded-lg hover:bg-primary-dark transition-colors service-detail-btn"
                          data-service-id="${service.serviceId}"
                        >
                          Chi tiết
                        </button>
                      </div>
                    </div>
                  </div>
                </c:forEach>

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
    <script src="<c:url value='/js/cart.js'/>"></script>
    <script src="<c:url value='/js/service-tracker.js'/>"></script>
    <script src="<c:url value='/js/recently-viewed-services.js'/>"></script>
    <script src="<c:url value='/js/homepage-sections.js'/>"></script>
    <script src="<c:url value='/js/services-api.js'/>"></script>
    
    <script>
      // Initialize services page with server-side data
      document.addEventListener('DOMContentLoaded', function() {
        // Initialize Lucide icons
        if (typeof lucide !== 'undefined') {
          lucide.createIcons();
        }
        
        // Handle service detail buttons
        document.querySelectorAll('.service-detail-btn').forEach(button => {
          button.addEventListener('click', function(e) {
            e.preventDefault();
            const serviceId = this.getAttribute('data-service-id');
            window.location.href = '<c:url value="/service-details"/>?id=' + serviceId;
          });
        });
        
        // Handle filtering (client-side for now, can be enhanced with AJAX)
        const searchInput = document.getElementById('search-input');
        const serviceTypeSelect = document.getElementById('service-type-select');
        const sortSelect = document.getElementById('sort-select');
        const serviceCards = document.querySelectorAll('.service-card');
        
        function filterServices() {
          const searchTerm = searchInput.value.toLowerCase();
          const selectedType = serviceTypeSelect.value;
          
          let visibleCount = 0;
          
          serviceCards.forEach(card => {
            const serviceName = card.getAttribute('data-service-name').toLowerCase();
            const serviceType = card.getAttribute('data-service-type');
            
            const matchesSearch = !searchTerm || serviceName.includes(searchTerm);
            const matchesType = selectedType === 'all' || serviceType === selectedType;
            
            if (matchesSearch && matchesType) {
              card.style.display = 'block';
              visibleCount++;
            } else {
              card.style.display = 'none';
            }
          });
          
          // Update results count
          document.getElementById('results-count').textContent = `Hiển thị ${visibleCount} kết quả`;
        }
        
        function sortServices() {
          const sortValue = sortSelect.value;
          const servicesGrid = document.getElementById('services-grid');
          const cards = Array.from(serviceCards);
          
          if (sortValue === 'default') return;
          
          cards.sort((a, b) => {
            const nameA = a.getAttribute('data-service-name');
            const nameB = b.getAttribute('data-service-name');
            const priceA = parseFloat(a.getAttribute('data-service-price'));
            const priceB = parseFloat(b.getAttribute('data-service-price'));
            
            switch (sortValue) {
              case 'name-asc':
                return nameA.localeCompare(nameB);
              case 'name-desc':
                return nameB.localeCompare(nameA);
              case 'price-asc':
                return priceA - priceB;
              case 'price-desc':
                return priceB - priceA;
              default:
                return 0;
            }
          });
          
          // Re-append sorted cards
          cards.forEach(card => servicesGrid.appendChild(card));
        }
        
        // Event listeners
        if (searchInput) {
          searchInput.addEventListener('input', filterServices);
        }
        
        if (serviceTypeSelect) {
          serviceTypeSelect.addEventListener('change', filterServices);
        }
        
        if (sortSelect) {
          sortSelect.addEventListener('change', sortServices);
        }
        
        // Initialize filter placeholders if price range data exists
        <c:if test="${priceRange != null}">
          const priceRange = {
            min: ${priceRange.min},
            max: ${priceRange.max}
          };
          console.log('Price range:', priceRange);
        </c:if>
      });
    </script>
  </body>
</html>
