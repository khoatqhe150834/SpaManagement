<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %> <%@ taglib prefix="fn"
uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set
  var="isAuthenticated"
  value="${sessionScope.authenticated != null and sessionScope.authenticated eq true}"
/>
<c:set var="isCustomer" value="${sessionScope.customer != null}" />
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Chi tiết dịch vụ - Spa Hương Sen</title>

    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="<c:url value='/js/tailwind-config.js'/>"></script>

    <!-- Google Fonts -->
    <link
      href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap"
      rel="stylesheet"
    />

    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>

    <!-- Custom CSS -->
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />

    <!-- Enhanced Service Details Styles -->
    <style>
      /* Hide scrollbar for related services */
      .scrollbar-hide {
        -ms-overflow-style: none;
        scrollbar-width: none;
      }
      .scrollbar-hide::-webkit-scrollbar {
        display: none;
      }

      /* Zoom cursor styles */
      .cursor-zoom-in {
        cursor: zoom-in;
      }

      /* Line clamp utilities */
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

      /* Zoom modal styles */
      #image-zoom-modal {
        backdrop-filter: blur(4px);
      }

      #zoom-image-container {
        max-width: 90vw;
        max-height: 90vh;
      }

      /* Related services scroll behavior */
      #related-services-grid {
        scroll-behavior: smooth;
      }

      /* Service card hover effects and stability - MATCHING services.jsp */
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
      
      /* Image container stability - MATCHING services.jsp */
      .service-card .relative.h-48 {
        background-color: #f9fafb; /* Slightly lighter gray */
        height: 192px !important; /* Force fixed height */
        min-height: 192px !important; /* Ensure minimum height */
        max-height: 192px; /* Prevent overflow */
        overflow: hidden;
        position: relative;
        flex-shrink: 0; /* Prevent shrinking */
      }
      
      /* Image stability - no transitions needed - MATCHING services.jsp */
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
      
      /* Fallback and default image styles - MATCHING services.jsp */
      .service-card .fallback-image {
        opacity: 1 !important; /* Always show fallback images */
      }
      .service-card .default-image {
        opacity: 1 !important; /* Always show default images */
      }
      
      /* Loading indicator enhancement - MATCHING services.jsp */
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
      
      /* Gradient placeholder - MATCHING services.jsp */
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
      
      /* Service content area stability - MATCHING services.jsp */
      .service-card .p-6 {
        flex-grow: 1;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
      }
      
      /* Price formatting - MATCHING services.jsp */
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
      <!-- Service Details -->
      <section class="py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <!-- Loading State -->
          <div id="loading-state" class="text-center py-12 ${service != null ? 'hidden' : ''}">
            <div
              class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"
            ></div>
            <p class="text-gray-600">Đang tải thông tin dịch vụ...</p>
          </div>

          <!-- Error State -->
          <div id="error-state" class="text-center py-12 hidden">
            <i
              data-lucide="alert-circle"
              class="h-16 w-16 text-red-500 mx-auto mb-4"
            ></i>
            <h2 class="text-2xl font-serif text-spa-dark mb-4">
              Không tìm thấy dịch vụ
            </h2>
            <p class="text-gray-600 mb-6">
              Dịch vụ bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.
            </p>
            <a
              href="<c:url value='/services'/>"
              class="inline-flex items-center px-6 py-3 bg-primary text-white rounded-full hover:bg-primary-dark transition-all duration-300 font-semibold"
            >
              <i data-lucide="arrow-left" class="h-4 w-4 mr-2"></i>
              Quay lại danh sách dịch vụ
            </a>
          </div>

          <!-- Service Content -->
          <div id="service-content" class="${service != null ? '' : 'hidden'}">
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">
              <!-- Service Images -->
              <div class="space-y-4">
                <!-- Main Image Display -->
                <div class="relative rounded-lg overflow-hidden shadow-lg">
                  <c:choose>
                    <c:when test="${not empty serviceImages}">
                      <!-- Display first image (primary or first in sort order) -->
                      <c:set var="primaryImage" value="${serviceImages[0]}" />
                      <img
                        id="main-service-image"
                        src="${primaryImage.url}"
                        alt="${primaryImage.altText != null ? primaryImage.altText : service.name}"
                        class="w-full h-96 object-cover cursor-zoom-in"
                      />

                      <!-- Image Navigation (if multiple images) -->
                      <c:if test="${serviceImages.size() > 1}">
                        <button
                          id="prev-btn"
                          class="absolute left-4 top-1/2 transform -translate-y-1/2 bg-black bg-opacity-50 text-white p-2 rounded-full hover:bg-opacity-75 transition-all"
                        >
                          <i data-lucide="chevron-left" class="h-5 w-5"></i>
                        </button>
                        <button
                          id="next-btn"
                          class="absolute right-4 top-1/2 transform -translate-y-1/2 bg-black bg-opacity-50 text-white p-2 rounded-full hover:bg-opacity-75 transition-all"
                        >
                          <i data-lucide="chevron-right" class="h-5 w-5"></i>
                        </button>

                        <!-- Image Counter -->
                        <div
                          class="absolute bottom-4 right-4 bg-black bg-opacity-50 text-white px-3 py-1 rounded-full text-sm"
                        >
                          <span id="current-image">1</span> /
                          ${serviceImages.size()}
                        </div>
                      </c:if>
                    </c:when>
                    <c:otherwise>
                      <!-- Fallback placeholder image -->
                      <img
                        id="main-service-image"
                        src="https://placehold.co/800x600/FFB6C1/333333?text=<c:out value='${fn:replace(service.name, " ", "+")}'/>"
                        alt="<c:out value='${service.name}'/>"
                        class="w-full h-96 object-cover"
                      />
                    </c:otherwise>
                  </c:choose>
                </div>

                <!-- Thumbnail Gallery (if multiple images) -->
                <c:if test="${serviceImages.size() > 1}">
                  <div class="flex space-x-2 overflow-x-auto pb-2">
                    <c:forEach
                      var="image"
                      items="${serviceImages}"
                      varStatus="status"
                    >
                      <button
                        class="thumbnail-item flex-shrink-0 w-20 h-20 rounded-lg overflow-hidden border-2 ${status.index == 0 ? 'border-primary' : 'border-transparent'} hover:border-primary transition-all"
                        data-image-index="${status.index}"
                      >
                        <img
                          src="${image.url}"
                          alt="${image.altText != null ? image.altText : service.name}"
                          class="w-full h-full object-cover cursor-zoom-in"
                        />
                      </button>
                    </c:forEach>
                  </div>
                </c:if>
              </div>

              <!-- Service Information -->
              <div class="space-y-6">
                <!-- Service Header -->
                <div>
                  <div class="flex items-center mb-2">
                    <span
                      id="service-type"
                      class="text-xs text-primary font-medium bg-secondary px-3 py-1 rounded-full"
                    >${service.serviceTypeId != null && service.serviceTypeId.name != null ? service.serviceTypeId.name : 'Dịch vụ spa'}</span>
                    <div class="flex items-center ml-4">
                      <div class="flex items-center">
                        <i
                          data-lucide="star"
                          class="h-4 w-4 text-primary fill-current mr-1"
                        ></i>
                        <span id="service-rating" class="text-sm font-medium"
                          ><fmt:formatNumber value="${service.averageRating != null ? service.averageRating : 4.5}" type="number" minFractionDigits="1" maxFractionDigits="1" /></span
                        >
                      </div>
                    </div>
                  </div>
                  <h1
                    id="service-name"
                    class="text-3xl md:text-4xl font-sans font-semibold text-spa-dark mb-4"
                    style="font-family: 'Roboto', sans-serif;"
                  >${service.name}</h1>
                  <p
                    id="service-description"
                    class="text-gray-600 text-lg leading-relaxed"
                  >${service.description != null && !empty service.description ? service.description : 'Dịch vụ chăm sóc sắc đẹp chuyên nghiệp'}</p>
                </div>

                <!-- Service Details -->
                <div class="grid grid-cols-2 gap-4">
                  <div class="flex items-center">
                    <i
                      data-lucide="clock"
                      class="h-5 w-5 text-primary mr-3"
                    ></i>
                    <div>
                      <p class="text-sm text-gray-500">Thời gian</p>
                      <p
                        id="service-duration"
                        class="font-medium text-spa-dark"
                      >${service.durationMinutes != null ? service.durationMinutes : 60} phút</p>
                    </div>
                  </div>
                  <div class="flex items-center">
                    <i data-lucide="tag" class="h-5 w-5 text-primary mr-3"></i>
                    <div>
                      <p class="text-sm text-gray-500">Giá dịch vụ</p>
                      <p
                        id="service-price"
                        class="font-bold text-2xl text-primary"
                      ><fmt:formatNumber value="${service.price}" type="number" groupingUsed="true" /> ₫</p>
                    </div>
                  </div>
                </div>

                <!-- Action Buttons -->
                <div class="space-y-4">
                  <!-- Add to Cart Button (Available for all users) -->
                  <button
                    id="add-to-cart-btn"
                    class="w-full bg-primary text-white py-4 px-6 rounded-full hover:bg-primary-dark transition-all duration-300 font-semibold text-lg flex items-center justify-center shadow-lg"
                    data-service-id="${service.serviceId}"
                  >
                    <i data-lucide="shopping-cart" class="h-5 w-5 mr-2"></i>
                    Thêm vào giỏ hàng
                  </button>

                  <!-- Add to Wishlist Button (Only for authenticated users) -->
                  <c:if test="${isAuthenticated}">
                    <button
                      id="add-to-wishlist-btn"
                      class="w-full bg-pink-500 text-white py-3 px-6 rounded-full hover:bg-pink-600 transition-all duration-300 font-semibold flex items-center justify-center shadow-lg"
                      data-service-id="${service.serviceId}"
                    >
                      <i data-lucide="heart" class="h-5 w-5 mr-2"></i>
                      Thêm vào yêu thích
                    </button>
                  </c:if>
                  <div class="grid grid-cols-2 gap-4">
                    <a
                      href="<c:url value='/services'/>"
                      class="flex items-center justify-center px-6 py-3 border-2 border-primary text-primary rounded-full hover:bg-primary hover:text-white transition-all duration-300 font-semibold"
                    >
                      <i data-lucide="arrow-left" class="h-4 w-4 mr-2"></i>
                      Quay lại
                    </a>
                    <c:choose>
                      <c:when test="${isAuthenticated && isCustomer}">
                        <a
                          href="<c:url value='/booking'/>"
                          class="flex items-center justify-center px-6 py-3 bg-secondary text-spa-dark rounded-full hover:bg-primary hover:text-white transition-all duration-300 font-semibold"
                        >
                          <i data-lucide="calendar" class="h-4 w-4 mr-2"></i>
                          Đặt lịch
                        </a>
                      </c:when>
                      <c:otherwise>
                        <a
                          href="<c:url value='/contact'/>"
                          class="flex items-center justify-center px-6 py-3 bg-secondary text-spa-dark rounded-full hover:bg-primary hover:text-white transition-all duration-300 font-semibold"
                        >
                          <i data-lucide="phone" class="h-4 w-4 mr-2"></i>
                          Liên hệ
                        </a>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </div>
              </div>
            </div>

            <!-- Thông tin chi tiết -->
            <div class="mt-16">
              <div class="bg-white rounded-lg shadow-lg p-8">
                <h2 class="text-2xl font-serif text-spa-dark mb-6">
                  Thông tin chi tiết
                </h2>
                <div class="prose prose-lg max-w-none">
                  <p
                    id="service-detailed-description"
                    class="text-gray-700 leading-relaxed"
                  >
                    <c:choose>
                      <c:when test="${service.description != null && !empty service.description}">
                        ${service.description}
                      </c:when>
                      <c:otherwise>
                        ${service.name} là một trong những dịch vụ chăm sóc sắc đẹp cao cấp tại Spa Hương Sen.
                        Với đội ngũ chuyên viên giàu kinh nghiệm và sử dụng các sản phẩm chất lượng cao,
                        chúng tôi cam kết mang đến cho bạn trải nghiệm thư giãn và làm đẹp tuyệt vời nhất.
                      </c:otherwise>
                    </c:choose>
                  </p>
                </div>
              </div>
            </div>
            <!-- Dịch vụ liên quan -->
            <div class="mt-16">
              <div class="bg-white rounded-lg shadow-lg p-8">
                <h2 class="text-2xl font-serif text-spa-dark mb-6">
                  Dịch vụ liên quan
                </h2>
                <div id="related-services-container">
                  <div
                    id="related-services-grid"
                    class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"
                  >
                    <!-- Related services will be loaded here -->
                    <!-- Skeleton Loading -->
                    <div id="related-skeleton-loading" class="contents">
                      <!-- Skeleton card 1 -->
                      <div class="bg-white rounded-lg shadow-lg overflow-hidden animate-pulse">
                        <div class="h-48 bg-gray-300"></div>
                        <div class="p-6">
                          <div class="h-4 bg-gray-300 rounded mb-3"></div>
                          <div class="h-6 bg-gray-300 rounded mb-4"></div>
                          <div class="h-4 bg-gray-300 rounded w-3/4 mb-4"></div>
                          <div class="flex justify-between items-center">
                            <div class="h-6 bg-gray-300 rounded w-20"></div>
                            <div class="h-10 bg-gray-300 rounded w-24"></div>
                          </div>
                        </div>
                      </div>
                      <!-- Skeleton card 2 -->
                      <div class="bg-white rounded-lg shadow-lg overflow-hidden animate-pulse">
                        <div class="h-48 bg-gray-300"></div>
                        <div class="p-6">
                          <div class="h-4 bg-gray-300 rounded mb-3"></div>
                          <div class="h-6 bg-gray-300 rounded mb-4"></div>
                          <div class="h-4 bg-gray-300 rounded w-3/4 mb-4"></div>
                          <div class="flex justify-between items-center">
                            <div class="h-6 bg-gray-300 rounded w-20"></div>
                            <div class="h-10 bg-gray-300 rounded w-24"></div>
                          </div>
                        </div>
                      </div>
                      <!-- Skeleton card 3 -->
                      <div class="bg-white rounded-lg shadow-lg overflow-hidden animate-pulse">
                        <div class="h-48 bg-gray-300"></div>
                        <div class="p-6">
                          <div class="h-4 bg-gray-300 rounded mb-3"></div>
                          <div class="h-6 bg-gray-300 rounded mb-4"></div>
                          <div class="h-4 bg-gray-300 rounded w-3/4 mb-4"></div>
                          <div class="flex justify-between items-center">
                            <div class="h-6 bg-gray-300 rounded w-20"></div>
                            <div class="h-10 bg-gray-300 rounded w-24"></div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>



    <!-- Image Zoom Modal -->
    <div
      id="image-zoom-modal"
      class="fixed inset-0 bg-black bg-opacity-90 z-50 hidden flex items-center justify-center"
    >
      <div class="relative max-w-7xl max-h-full p-4">
        <!-- Close button -->
        <button
          id="zoom-close-btn"
          class="absolute top-4 right-4 text-white hover:text-gray-300 z-10"
        >
          <i data-lucide="x" class="h-8 w-8"></i>
        </button>

        <!-- Zoom controls -->
        <div class="absolute top-4 left-4 flex space-x-2 z-10">
          <button
            id="zoom-in-btn"
            class="bg-black bg-opacity-50 text-white p-2 rounded-full hover:bg-opacity-75"
          >
            <i data-lucide="zoom-in" class="h-5 w-5"></i>
          </button>
          <button
            id="zoom-out-btn"
            class="bg-black bg-opacity-50 text-white p-2 rounded-full hover:bg-opacity-75"
          >
            <i data-lucide="zoom-out" class="h-5 w-5"></i>
          </button>
          <button
            id="zoom-reset-btn"
            class="bg-black bg-opacity-50 text-white p-2 rounded-full hover:bg-opacity-75"
          >
            <i data-lucide="maximize" class="h-5 w-5"></i>
          </button>
        </div>

        <!-- Navigation arrows (if multiple images) -->
        <button
          id="zoom-prev-btn"
          class="absolute left-4 top-1/2 transform -translate-y-1/2 bg-black bg-opacity-50 text-white p-3 rounded-full hover:bg-opacity-75 hidden"
        >
          <i data-lucide="chevron-left" class="h-6 w-6"></i>
        </button>
        <button
          id="zoom-next-btn"
          class="absolute right-4 top-1/2 transform -translate-y-1/2 bg-black bg-opacity-50 text-white p-3 rounded-full hover:bg-opacity-75 hidden"
        >
          <i data-lucide="chevron-right" class="h-6 w-6"></i>
        </button>

        <!-- Image container -->
        <div id="zoom-image-container" class="overflow-hidden cursor-move">
          <img
            id="zoom-image"
            class="max-w-full max-h-full object-contain transition-transform duration-200"
          />
        </div>

        <!-- Image counter -->
        <div
          id="zoom-counter"
          class="absolute bottom-4 right-4 bg-black bg-opacity-50 text-white px-3 py-1 rounded-full text-sm hidden"
        >
          <span id="zoom-current">1</span> / <span id="zoom-total">1</span>
        </div>
      </div>
    </div>

    <!-- Include cart modal -->
    <jsp:include page="/WEB-INF/view/common/cart-modal.jsp" />

    <!-- JavaScript -->
    <script src="<c:url value='/js/app.js'/>"></script>
    <!-- Make sure cart.js is properly initialized -->
    <script>
      // Check if cart functions are already defined
      if (typeof window.addToCart !== 'function') {
        console.log('Cart functions not found, loading cart.js...');
        // Only load cart.js if it's not already loaded
        document.write('<script src="<c:url value="/js/cart.js"/>"><\/script>');
      } else {
        console.log('Cart functions already available, skipping cart.js load');
      }
    </script>
    
    <script src="<c:url value='/js/service-tracker.js'/>"></script>
    <script src="<c:url value='/js/recently-viewed-services.js'/>"></script>
    <script src="<c:url value='/js/service-details.js'/>"></script>

    <!-- Initialize Service Details Data -->
    <script>
      // Set up basic data for the external JavaScript
      window.serviceDetailsData = {
        serviceData: {
          serviceId: <c:out value="${service.serviceId}"/>,
          name: "<c:out value='${service.name}' escapeXml='false'/>",
          price: <c:out value="${service.price}"/>,
          durationMinutes: <c:out value="${service.durationMinutes != null ? service.durationMinutes : 60}"/>,
          description: "<c:out value='${service.description != null && !empty service.description ? service.description : \"Dịch vụ chăm sóc sắc đẹp chuyên nghiệp\"}' escapeXml='false'/>",
          averageRating: <c:out value="${service.averageRating != null ? service.averageRating : 4.5}"/>,
          serviceTypeId: {
            name: "<c:out value='${service.serviceTypeId != null && service.serviceTypeId.name != null ? service.serviceTypeId.name : \"Dịch vụ spa\"}' escapeXml='false'/>"
          }
        },
        serviceImages: [
          <c:forEach var="image" items="${serviceImages}" varStatus="status">
          {
            url: "<c:out value='${image.url}' escapeXml='false'/>",
            altText: "<c:out value='${image.altText != null ? image.altText : service.name}' escapeXml='false'/>",
            isPrimary: <c:out value="${image.isPrimary}"/>,
            sortOrder: <c:out value="${image.sortOrder}"/>,
            caption: "<c:out value='${image.caption != null ? image.caption : ""}' escapeXml='false'/>",
            isActive: <c:out value="${image.isActive}"/>
          }<c:if test="${!status.last}">,</c:if>
          </c:forEach>
        ]
      };

      console.log('[SERVICE_DETAILS] Data initialized:', window.serviceDetailsData);
      console.log('[SERVICE_DETAILS] Service images count:', window.serviceDetailsData.serviceImages.length);
      console.log('[SERVICE_DETAILS] Service loaded successfully');
    </script>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
  </body>
</html>
