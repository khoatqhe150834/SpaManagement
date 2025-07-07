<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
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
  </head>

  <body class="bg-spa-cream">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />

    <!-- Main Content -->
    <main class="pt-20">
      <!-- Breadcrumb -->
      <section class="bg-white py-4 border-b border-gray-200">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <nav class="flex items-center space-x-2 text-sm">
            <a
              href="<c:url value='/'/>"
              class="text-gray-500 hover:text-primary"
              >Trang chủ</a
            >
            <i data-lucide="chevron-right" class="h-4 w-4 text-gray-400"></i>
            <a
              href="<c:url value='/services'/>"
              class="text-gray-500 hover:text-primary"
              >Dịch vụ</a
            >
            <i data-lucide="chevron-right" class="h-4 w-4 text-gray-400"></i>
            <span class="text-spa-dark font-medium" id="breadcrumb-service-name"
              >Chi tiết dịch vụ</span
            >
          </nav>
        </div>
      </section>

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
              <!-- Service Image -->
              <div class="space-y-4">
                <div
                  class="aspect-w-4 aspect-h-3 rounded-lg overflow-hidden shadow-lg"
                >
                  <img
                    id="service-image"
                    src=""
                    alt=""
                    class="w-full h-96 object-cover"
                  />
                </div>
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
                  <c:choose>
                    <c:when test="${isAuthenticated}">
                      <button
                        id="add-to-cart-btn"
                        class="w-full bg-primary text-white py-4 px-6 rounded-full hover:bg-primary-dark transition-all duration-300 font-semibold text-lg flex items-center justify-center shadow-lg hover:shadow-xl transform hover:scale-105"
                      >
                        <i data-lucide="shopping-cart" class="h-5 w-5 mr-2"></i>
                        Thêm vào giỏ hàng
                      </button>
                    </c:when>
                    <c:otherwise>
                      <a
                        href="<c:url value='/login'/>"
                        class="w-full bg-primary text-white py-4 px-6 rounded-full hover:bg-primary-dark transition-all duration-300 font-semibold text-lg flex items-center justify-center shadow-lg hover:shadow-xl transform hover:scale-105"
                      >
                        <i data-lucide="user" class="h-5 w-5 mr-2"></i>
                        Đăng nhập để đặt dịch vụ
                      </a>
                    </c:otherwise>
                  </c:choose>
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

    <!-- Include cart modal -->
    <jsp:include page="/WEB-INF/view/common/cart-modal.jsp" />

    <!-- JavaScript -->
    <script src="<c:url value='/js/app.js'/>"></script>
    <script src="<c:url value='/js/cart.js'/>"></script>
    <script src="<c:url value='/js/service-tracker.js'/>"></script>
    <script src="<c:url value='/js/recently-viewed-services.js'/>"></script>
    <script src="<c:url value='/js/service-details.js'/>"></script>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
  </body>
</html>
