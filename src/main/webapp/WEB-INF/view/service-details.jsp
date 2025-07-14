<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %> <%@ taglib prefix="fn"
uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set
  var="isAuthenticated"
  value="${sessionScope.authenticated != null && sessionScope.authenticated}"
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

      /* Notification styles */
      .notification {
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 12px 24px;
        border-radius: 8px;
        color: white;
        font-weight: 500;
        transform: translateX(400px);
        transition: transform 0.3s ease;
        z-index: 1000;
      }

      .notification.show {
        transform: translateX(0);
      }

      .notification.success {
        background-color: #10b981;
      }

      .notification.error {
        background-color: #ef4444;
      }

      .notification.info {
        background-color: #3b82f6;
      }

      /* Zoom modal styles */
      #image-zoom-modal {
        backdrop-filter: blur(4px);
      }

      #zoom-image-container {
        max-width: 90vw;
        max-height: 90vh;
      }

      /* Smooth transitions for buttons */
      button {
        transition: all 0.2s ease;
      }

      /* Related services scroll behavior */
      #related-services-grid {
        scroll-behavior: smooth;
      }

      /* Enhanced hover effects */
      .transform:hover {
        transform: scale(1.02);
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
          <div id="loading-state" class="text-center py-12">
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
          <div id="service-content" class="hidden">
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
                        src="https://placehold.co/800x600/FFB6C1/333333?text=${service.name}"
                        alt="${service.name}"
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
                    ></span>
                    <div class="flex items-center ml-4">
                      <div class="flex items-center">
                        <i
                          data-lucide="star"
                          class="h-4 w-4 text-primary fill-current mr-1"
                        ></i>
                        <span id="service-rating" class="text-sm font-medium"
                          >4.5</span
                        >
                      </div>
                    </div>
                  </div>
                  <h1
                    id="service-name"
                    class="text-3xl md:text-4xl font-serif text-spa-dark mb-4"
                  ></h1>
                  <p
                    id="service-description"
                    class="text-gray-600 text-lg leading-relaxed"
                  ></p>
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
                      ></p>
                    </div>
                  </div>
                  <div class="flex items-center">
                    <i data-lucide="tag" class="h-5 w-5 text-primary mr-3"></i>
                    <div>
                      <p class="text-sm text-gray-500">Giá dịch vụ</p>
                      <p
                        id="service-price"
                        class="font-bold text-2xl text-primary"
                      ></p>
                    </div>
                  </div>
                </div>

                <!-- Action Buttons -->
                <div class="space-y-4">
                  <!-- Add to Cart Button (Available for all users) -->
                  <button
                    id="add-to-cart-btn"
                    class="w-full bg-primary text-white py-4 px-6 rounded-full hover:bg-primary-dark transition-all duration-300 font-semibold text-lg flex items-center justify-center shadow-lg hover:shadow-xl transform hover:scale-105"
                    data-service-id="${service.serviceId}"
                  >
                    <i data-lucide="shopping-cart" class="h-5 w-5 mr-2"></i>
                    Thêm vào giỏ hàng
                  </button>

                  <!-- Add to Wishlist Button (Only for authenticated users) -->
                  <c:if test="${isAuthenticated}">
                    <button
                      id="add-to-wishlist-btn"
                      class="w-full bg-pink-500 text-white py-3 px-6 rounded-full hover:bg-pink-600 transition-all duration-300 font-semibold flex items-center justify-center shadow-lg hover:shadow-xl transform hover:scale-105"
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

            <!-- Related Services Section -->
            <div class="mt-16">
              <div class="bg-white rounded-lg shadow-lg p-8">
                <h2 class="text-2xl font-serif text-spa-dark mb-6">
                  Dịch vụ liên quan
                </h2>
                <div id="related-services-container" class="relative">
                  <div
                    id="related-services-grid"
                    class="flex space-x-4 overflow-x-auto pb-4 scrollbar-hide"
                  >
                    <!-- Related services will be loaded here -->
                    <div class="flex space-x-4 animate-pulse">
                      <c:forEach begin="1" end="5">
                        <div
                          class="flex-shrink-0 w-64 bg-gray-200 rounded-lg h-80"
                        ></div>
                      </c:forEach>
                    </div>
                  </div>
                  <!-- Navigation arrows for related services -->
                  <button
                    id="related-prev"
                    class="absolute left-0 top-1/2 transform -translate-y-1/2 bg-white shadow-lg rounded-full p-2 hover:bg-gray-50 transition-all z-10 hidden"
                  >
                    <i
                      data-lucide="chevron-left"
                      class="h-5 w-5 text-gray-600"
                    ></i>
                  </button>
                  <button
                    id="related-next"
                    class="absolute right-0 top-1/2 transform -translate-y-1/2 bg-white shadow-lg rounded-full p-2 hover:bg-gray-50 transition-all z-10 hidden"
                  >
                    <i
                      data-lucide="chevron-right"
                      class="h-5 w-5 text-gray-600"
                    ></i>
                  </button>
                </div>
              </div>
            </div>

            <!-- Additional Information -->
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
                    Thông tin chi tiết về dịch vụ sẽ được hiển thị tại đây...
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

    <!-- Notification -->
    <div id="notification" class="notification"></div>

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

    <script src="<c:url value='/js/service-tracker.js'/>"></script>
    <script src="<c:url value='/js/recently-viewed-services.js'/>"></script>
    <script src="<c:url value='/js/service-details.js'/>"></script>

    <!-- Initialize Service Details Data -->
    <script>
      // Set up data for the external JavaScript
      window.serviceDetailsData = {
        serviceData: {
          serviceId: <c:out value="${service.serviceId}"/>,
          serviceTypeId: <c:out value="${service.serviceTypeId.serviceTypeId}"/>,
          name: "<c:out value='${service.name}'/>",
          price: <c:out value="${service.price}"/>
        },
        serviceImages: [
          <c:forEach var="image" items="${serviceImages}" varStatus="status">
            {
              url: "<c:out value='${image.url}'/>",
              altText: "<c:out value='${image.altText != null ? image.altText : service.name}'/>",
              isPrimary: ${image.isPrimary}
            }<c:if test="${!status.last}">,</c:if>
          </c:forEach>
        ]
      };

      console.log('[SERVICE_DETAILS] Data initialized:', window.serviceDetailsData);
    </script>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
  </body>
</html>
