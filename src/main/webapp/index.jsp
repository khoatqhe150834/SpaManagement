<%-- Document : index.jsp Created on : May 29, 2025, 10:45:37 AM Author : quang
--%> <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib
prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <%@ page
import="model.RoleConstants" %> <%@page contentType="text/html"
pageEncoding="UTF-8"%> 
<%
// Set showBookingFeatures based on user role
boolean showBookingFeatures = true; // Default to show for guests

if (session.getAttribute("authenticated") != null && (Boolean)session.getAttribute("authenticated")) {
    if (session.getAttribute("customer") != null) {
        showBookingFeatures = true; // Show for customers
    } else if (session.getAttribute("user") != null) {
        showBookingFeatures = false; // Hide for staff/admin roles
    }
}

pageContext.setAttribute("showBookingFeatures", showBookingFeatures);
%>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Spa Hương Sen - Nâng Niu Vẻ Đẹp Tự Nhiên</title>

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

    <!-- Custom styles for animations -->
    <style>
      @keyframes fadeIn {
        from {
          opacity: 0;
          transform: translateY(20px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }
      .animate-fadeIn {
        animation: fadeIn 0.6s ease-out forwards;
      }
      .line-clamp-2 {
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
      }
    </style>
  </head>

  <body class="bg-spa-cream">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />

    <!-- Hero Slider Section -->
    <section
      class="relative min-h-screen flex items-center justify-center overflow-hidden"
    >
      <!-- Slider Container -->
      <div id="hero-slider" class="absolute inset-0">
        <!-- Slide 1 -->
        <div
          class="hero-slide active absolute inset-0 bg-cover bg-center"
          style="
            background-image: url('https://images.pexels.com/photos/3985254/pexels-photo-3985254.jpeg?auto=compress&cs=tinysrgb&w=1920');
          "
        >
          <div class="absolute inset-0 bg-black/40"></div>
        </div>

        <!-- Slide 2 -->
        <div
          class="hero-slide inactive absolute inset-0 bg-cover bg-center"
          style="
            background-image: url('https://images.pexels.com/photos/3997991/pexels-photo-3997991.jpeg?auto=compress&cs=tinysrgb&w=1920');
          "
        >
          <div class="absolute inset-0 bg-black/40"></div>
        </div>

        <!-- Slide 3 -->
        <div
          class="hero-slide inactive absolute inset-0 bg-cover bg-center"
          style="
            background-image: url('https://images.pexels.com/photos/3985263/pexels-photo-3985263.jpeg?auto=compress&cs=tinysrgb&w=1920');
          "
        >
          <div class="absolute inset-0 bg-black/40"></div>
        </div>

        <!-- Slide 4 -->
        <div
          class="hero-slide inactive absolute inset-0 bg-cover bg-center"
          style="
            background-image: url('https://images.pexels.com/photos/3997989/pexels-photo-3997989.jpeg?auto=compress&cs=tinysrgb&w=1920');
          "
        >
          <div class="absolute inset-0 bg-black/40"></div>
        </div>
      </div>

      <!-- Content Overlay -->
      <div
        class="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center text-white"
      >
        <h1
          id="hero-title"
          class="text-5xl md:text-6xl lg:text-7xl font-serif mb-6 leading-tight"
        >
          Spa Cao Cấp
          <br />
          <span class="text-primary">Nâng Niu Vẻ Đẹp</span>
          <br />
          Tự Nhiên
        </h1>
        <p
          id="hero-description"
          class="text-xl md:text-2xl mb-8 leading-relaxed max-w-4xl mx-auto"
        >
          Trải nghiệm không gian thư giãn đẳng cấp với các liệu pháp chăm sóc
          sắc đẹp dành riêng cho phụ nữ Việt Nam
        </p>

        <!-- Show booking buttons only for guests and customers -->
        <c:if test="${showBookingFeatures}">
          <div class="flex flex-col sm:flex-row gap-4 justify-center">
            <a
              href="<c:url value='/booking'/>"
              class="px-8 py-4 bg-primary text-white rounded-full hover:bg-primary-dark transition-all duration-300 font-semibold text-lg transform hover:scale-105"
            >
              Đặt lịch ngay
            </a>
            <a
              href="<c:url value='/services'/>"
              class="px-8 py-4 border-2 border-white text-white rounded-full hover:bg-white hover:text-spa-dark transition-all duration-300 font-semibold text-lg transform hover:scale-105"
            >
              Xem dịch vụ
            </a>
          </div>
        </c:if>

        <!-- For staff users, show different actions -->
        <c:if test="${not showBookingFeatures}">
          <div class="flex flex-col sm:flex-row gap-4 justify-center">
            <a
              href="<c:url value='/dashboard'/>"
              class="px-8 py-4 bg-primary text-white rounded-full hover:bg-primary-dark transition-all duration-300 font-semibold text-lg transform hover:scale-105"
            >
              Vào Dashboard
            </a>
            <a
              href="<c:url value='/services'/>"
              class="px-8 py-4 border-2 border-white text-white rounded-full hover:bg-white hover:text-spa-dark transition-all duration-300 font-semibold text-lg transform hover:scale-105"
            >
              Xem dịch vụ
            </a>
          </div>
        </c:if>
      </div>

      <!-- Slider Controls -->
      <div class="absolute bottom-8 left-1/2 transform -translate-x-1/2 z-20">
        <div class="flex space-x-2">
          <button
            class="slider-dot w-3 h-3 rounded-full bg-white hover:bg-white transition-colors"
            data-slide="0"
          ></button>
          <button
            class="slider-dot w-3 h-3 rounded-full bg-white/50 hover:bg-white transition-colors"
            data-slide="1"
          ></button>
          <button
            class="slider-dot w-3 h-3 rounded-full bg-white/50 hover:bg-white transition-colors"
            data-slide="2"
          ></button>
          <button
            class="slider-dot w-3 h-3 rounded-full bg-white/50 hover:bg-white transition-colors"
            data-slide="3"
          ></button>
        </div>
      </div>

      <!-- Navigation Arrows -->
      <button
        id="prev-slide"
        class="absolute left-4 top-1/2 transform -translate-y-1/2 z-20 bg-white/20 hover:bg-white/40 rounded-full p-2 transition-colors"
      >
        <i data-lucide="chevron-left" class="h-6 w-6 text-white"></i>
      </button>
      <button
        id="next-slide"
        class="absolute right-4 top-1/2 transform -translate-y-1/2 z-20 bg-white/20 hover:bg-white/40 rounded-full p-2 transition-colors"
      >
        <i data-lucide="chevron-right" class="h-6 w-6 text-white"></i>
      </button>
    </section>

    <!-- About Section -->
    <section class="py-20 bg-spa-cream fade-in">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          <div>
            <h2 class="text-4xl md:text-5xl font-serif text-spa-dark mb-6">
              Chào mừng đến với
              <span class="text-primary"> Spa Hương Sen</span>
            </h2>
            <p class="text-lg text-gray-700 mb-6 leading-relaxed">
              Spa Hương Sen là không gian dành riêng cho phụ nữ Việt Nam, nơi vẻ
              đẹp tự nhiên được nâng niu và chăm sóc bằng những liệu pháp tinh
              tế nhất.
            </p>
            <p class="text-lg text-gray-700 mb-8 leading-relaxed">
              Chúng tôi kết hợp giữa truyền thống và hiện đại, mang đến trải
              nghiệm thư giãn hoàn hảo trong không gian sang trọng và ấm cúng.
            </p>
            <a
              href="${pageContext.request.contextPath}/about"
              class="inline-flex items-center px-6 py-3 bg-primary text-white rounded-full hover:bg-primary-dark transition-all duration-300 font-semibold"
            >
              Tìm hiểu thêm
              <i data-lucide="arrow-right" class="ml-2 h-5 w-5"></i>
            </a>
          </div>
          <div class="relative">
            <img
              src="https://images.pexels.com/photos/3997991/pexels-photo-3997991.jpeg?auto=compress&cs=tinysrgb&w=800"
              alt="Spa Interior"
              class="rounded-lg shadow-2xl w-full h-auto"
            />
            <div
              class="absolute -bottom-6 -left-6 bg-white p-6 rounded-lg shadow-lg"
            >
              <div class="flex items-center">
                <i data-lucide="gift" class="h-8 w-8 text-primary mr-3"></i>
                <div>
                  <p class="font-semibold text-spa-dark">Ưu đãi đặc biệt</p>
                  <p class="text-sm text-gray-600">Giảm 20% lần đầu</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Recently Viewed Services Section -->
    <c:if test="${showBookingFeatures}">
      <section
        id="recently-viewed-section"
        class="py-16 bg-spa-cream opacity-0 translate-y-8 transition-all duration-1000 ease-out hidden"
      >
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="flex items-center justify-between mb-12">
            <div>
              <div class="flex items-center mb-2">
                <i data-lucide="history" class="h-8 w-8 text-primary mr-3"></i>
                <h2 class="text-3xl md:text-4xl font-serif text-spa-dark">
                  Dịch vụ vừa xem
                </h2>
              </div>
              <p class="text-gray-600">Các dịch vụ bạn đã xem gần đây</p>
            </div>
            <a
              href="<c:url value='/recently-viewed'/>"
              id="view-all-services-btn"
              class="flex items-center text-primary hover:text-primary-dark font-semibold transition-colors"
            >
              Xem tất cả
              <i data-lucide="arrow-right" class="ml-2 h-4 w-4"></i>
            </a>
          </div>

          <!-- Responsive Grid: 4 cols desktop, 2 cols tablet, 1 col mobile -->
          <div
            id="recently-viewed-grid"
            class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6"
          >
            <!-- Services will be dynamically inserted here -->
          </div>
        </div>
      </section>
    </c:if>

    <!-- Promotional Services Section -->
    <c:if test="${showBookingFeatures}">
      <section
        id="promotional-services-section"
        class="py-16 bg-gradient-to-br from-spa-cream to-secondary"
      >
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="flex items-center justify-between mb-12">
            <div>
              <h2 class="text-3xl md:text-4xl font-serif text-spa-dark mb-2">
                Dịch vụ <span class="text-primary">khuyến mãi</span>
              </h2>
              <p class="text-gray-600">Ưu đãi đặc biệt có thời hạn</p>
            </div>
            <button
              id="view-all-promotions-btn"
              class="flex items-center text-primary hover:text-primary-dark font-semibold transition-colors"
            >
              Xem tất cả
              <i data-lucide="arrow-right" class="ml-2 h-4 w-4"></i>
            </button>
          </div>

          <div
            id="promotional-services-grid"
            class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6"
          >
            <!-- Promotional services will be dynamically inserted here -->
          </div>
        </div>
      </section>
    </c:if>

    <!-- Most Purchased Services Section -->
    <c:if test="${showBookingFeatures}">
      <section id="most-purchased-section" class="py-16 bg-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="flex items-center justify-between mb-12">
            <div>
              <h2 class="text-3xl md:text-4xl font-serif text-spa-dark mb-2">
                Dịch vụ <span class="text-primary">đặt mua nhiều</span>
              </h2>
              <p class="text-gray-600">
                Những dịch vụ được khách hàng yêu thích nhất
              </p>
            </div>
            <a
              href="${pageContext.request.contextPath}/most-purchased"
              id="view-all-popular-btn"
              class="flex items-center text-primary hover:text-primary-dark font-semibold transition-colors"
            >
              Xem tất cả
              <i data-lucide="arrow-right" class="ml-2 h-4 w-4"></i>
            </a>
          </div>

          <div
            id="most-purchased-grid"
            class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6"
          >
            <!-- Most purchased services will be dynamically inserted here -->
          </div>
        </div>
      </section>
    </c:if>

    <!-- Stats Section -->
    <section class="py-16 bg-white fade-in">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
          <div class="text-center">
            <div
              class="bg-spa-cream rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4"
            >
              <i data-lucide="users" class="h-8 w-8 text-primary"></i>
            </div>
            <h3 class="text-3xl font-bold text-spa-dark mb-2">5000+</h3>
            <p class="text-gray-600">Khách hàng tin tưởng</p>
          </div>
          <div class="text-center">
            <div
              class="bg-spa-cream rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4"
            >
              <i data-lucide="award" class="h-8 w-8 text-primary"></i>
            </div>
            <h3 class="text-3xl font-bold text-spa-dark mb-2">50+</h3>
            <p class="text-gray-600">Dịch vụ chuyên nghiệp</p>
          </div>
          <div class="text-center">
            <div
              class="bg-spa-cream rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4"
            >
              <i data-lucide="star" class="h-8 w-8 text-primary"></i>
            </div>
            <h3 class="text-3xl font-bold text-spa-dark mb-2">4.9/5</h3>
            <p class="text-gray-600">Đánh giá trung bình</p>
          </div>
          <div class="text-center">
            <div
              class="bg-spa-cream rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4"
            >
              <i data-lucide="calendar" class="h-8 w-8 text-primary"></i>
            </div>
            <h3 class="text-3xl font-bold text-spa-dark mb-2">3</h3>
            <p class="text-gray-600">Năm kinh nghiệm</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Services Section -->
    <%--
    <section class="py-20 bg-spa-cream fade-in">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-16">
          <h2 class="text-4xl md:text-5xl font-serif text-spa-dark mb-4">
            Dịch vụ <span class="text-primary">nổi bật</span>
          </h2>
          <p class="text-xl text-gray-600 max-w-3xl mx-auto">
            Khám phá các dịch vụ chăm sóc sắc đẹp cao cấp được thiết kế đặc biệt
            cho phụ nữ Việt Nam
          </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <!-- Service 1 -->
          <div
            class="group cursor-pointer bg-white rounded-xl overflow-hidden shadow-lg hover:shadow-2xl transition-all duration-300"
          >
            <div class="relative overflow-hidden">
              <img
                src="https://images.pexels.com/photos/3985263/pexels-photo-3985263.jpeg?auto=compress&cs=tinysrgb&w=600"
                alt="Chăm sóc da mặt"
                class="w-full h-64 object-cover transition-transform duration-300 group-hover:scale-105"
              />
              <div
                class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              ></div>
              <div
                class="absolute bottom-4 left-4 text-white opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              >
                <p class="font-semibold">Từ 299.000đ</p>
              </div>
            </div>
            <div class="p-6">
              <h3 class="text-xl font-semibold text-spa-dark mb-3">
                Chăm sóc da mặt
              </h3>
              <p class="text-gray-600 leading-relaxed mb-4">
                Phục hồi và nuôi dưỡng làn da tự nhiên với các liệu pháp cao cấp
              </p>
              <a
                href="<c:url value='/services?name=Chăm sóc da mặt'/>"
                class="text-primary hover:text-primary-dark font-semibold"
              >
                Xem chi tiết →
              </a>
            </div>
          </div>

          <!-- Service 2 -->
          <div
            class="group cursor-pointer bg-white rounded-xl overflow-hidden shadow-lg hover:shadow-2xl transition-all duration-300"
          >
            <div class="relative overflow-hidden">
              <img
                src="https://images.pexels.com/photos/3997989/pexels-photo-3997989.jpeg?auto=compress&cs=tinysrgb&w=600"
                alt="Massage thư giãn"
                class="w-full h-64 object-cover transition-transform duration-300 group-hover:scale-105"
              />
              <div
                class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              ></div>
              <div
                class="absolute bottom-4 left-4 text-white opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              >
                <p class="font-semibold">Từ 399.000đ</p>
              </div>
            </div>
            <div class="p-6">
              <h3 class="text-xl font-semibold text-spa-dark mb-3">
                Massage thư giãn
              </h3>
              <p class="text-gray-600 leading-relaxed mb-4">
                Thư giãn toàn thân với kỹ thuật massage truyền thống Việt Nam
              </p>
              <a
                href="<c:url value='/services?name=Massage thư giãn'/>"
                class="text-primary hover:text-primary-dark font-semibold"
              >
                Xem chi tiết →
              </a>
            </div>
          </div>

          <!-- Service 3 -->
          <div
            class="group cursor-pointer bg-white rounded-xl overflow-hidden shadow-lg hover:shadow-2xl transition-all duration-300"
          >
            <div class="relative overflow-hidden">
              <img
                src="https://images.pexels.com/photos/3985254/pexels-photo-3985254.jpeg?auto=compress&cs=tinysrgb&w=600"
                alt="Tắm trắng thảo dược"
                class="w-full h-64 object-cover transition-transform duration-300 group-hover:scale-105"
              />
              <div
                class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              ></div>
              <div
                class="absolute bottom-4 left-4 text-white opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              >
                <p class="font-semibold">Từ 199.000đ</p>
              </div>
            </div>
            <div class="p-6">
              <h3 class="text-xl font-semibold text-spa-dark mb-3">
                Tắm trắng thảo dược
              </h3>
              <p class="text-gray-600 leading-relaxed mb-4">
                Làm trắng da tự nhiên với các thảo dược quý hiếm
              </p>
              <a
                href="<c:url value='/services?name=Tắm trắng thảo dược'/>"
                class="text-primary hover:text-primary-dark font-semibold"
              >
                Xem chi tiết →
              </a>
            </div>
          </div>
        </div>

        <div class="text-center mt-12">
          <a
            href="${pageContext.request.contextPath}/services"
            class="inline-flex items-center px-8 py-3 bg-secondary text-spa-dark rounded-full hover:bg-primary hover:text-white transition-all duration-300 font-semibold"
          >
            Xem tất cả dịch vụ
            <i data-lucide="arrow-right" class="ml-2 h-5 w-5"></i>
          </a>
        </div>
      </div>
    </section>
    --%>

    <!-- Promotional Services Section -->
    <%--
    <section
      id="promotional-section"
      class="py-20 bg-gradient-to-br from-red-50 to-pink-50 fade-in"
    >
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-12">
          <h2 class="text-4xl md:text-5xl font-serif text-spa-dark mb-4">
            Ưu đãi <span class="text-primary">đặc biệt</span>
          </h2>
          <p class="text-xl text-gray-600 mb-8">
            Các dịch vụ đang có chương trình khuyến mãi hấp dẫn
          </p>
        </div>

        <!-- Services Grid -->
        <div
          id="promotional-grid"
          class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 mb-12"
        >
          <!-- Services will be loaded here -->
        </div>

        <!-- View All Button -->
        <div class="text-center">
          <a
            href="<c:url value='/services'/>"
            class="inline-flex items-center px-8 py-4 bg-red-600 text-white rounded-full hover:bg-red-700 transition-all duration-300 font-semibold text-lg"
          >
            Xem tất cả ưu đãi
            <i data-lucide="arrow-right" class="ml-2 h-5 w-5"></i>
          </a>
        </div>
      </div>
    </section>
    --%>

    <!-- Most Purchased Services Section -->
    <%--
    <section id="most-purchased-section" class="py-20 bg-white fade-in">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-12">
          <h2 class="text-4xl md:text-5xl font-serif text-spa-dark mb-4">
            Dịch vụ <span class="text-primary">phổ biến</span>
          </h2>
          <p class="text-xl text-gray-600 mb-8">
            Những dịch vụ được khách hàng lựa chọn nhiều nhất
          </p>
        </div>

        <!-- Services Grid -->
        <div
          id="most-purchased-grid"
          class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 mb-12"
        >
          <!-- Services will be loaded here -->
        </div>

        <!-- View All Button -->
        <div class="text-center">
          <a
            href="<c:url value='/services'/>"
            class="inline-flex items-center px-8 py-4 bg-primary text-white rounded-full hover:bg-primary-dark transition-all duration-300 font-semibold text-lg"
          >
            Xem tất cả dịch vụ
            <i data-lucide="arrow-right" class="ml-2 h-5 w-5"></i>
          </a>
        </div>
      </div>
    </section>
    --%>

    <!-- About Section -->
    <%--
    <section class="py-20 bg-spa-cream fade-in">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          <div>
            <h2 class="text-4xl md:text-5xl font-serif text-spa-dark mb-6">
              Chào mừng đến với
              <span class="text-primary"> Spa Hương Sen</span>
            </h2>
            <p class="text-lg text-gray-700 mb-6 leading-relaxed">
              Spa Hương Sen là không gian dành riêng cho phụ nữ Việt Nam, nơi vẻ
              đẹp tự nhiên được nâng niu và chăm sóc bằng những liệu pháp tinh
              tế nhất.
            </p>
            <p class="text-lg text-gray-700 mb-8 leading-relaxed">
              Chúng tôi kết hợp giữa truyền thống và hiện đại, mang đến trải
              nghiệm thư giãn hoàn hảo trong không gian sang trọng và ấm cúng.
            </p>
            <a
              href="about.html"
              class="inline-flex items-center px-6 py-3 bg-primary text-white rounded-full hover:bg-primary-dark transition-all duration-300 font-semibold"
            >
              Tìm hiểu thêm
              <i data-lucide="arrow-right" class="ml-2 h-5 w-5"></i>
            </a>
          </div>
          <div class="relative">
            <img
              src="https://images.pexels.com/photos/3997991/pexels-photo-3997991.jpeg?auto=compress&cs=tinysrgb&w=800"
              alt="Spa Interior"
              class="rounded-lg shadow-2xl w-full h-auto"
            />
            <div
              class="absolute -bottom-6 -left-6 bg-white p-6 rounded-lg shadow-lg"
            >
              <div class="flex items-center">
                <i data-lucide="gift" class="h-8 w-8 text-primary mr-3"></i>
                <div>
                  <p class="font-semibold text-spa-dark">Ưu đãi đặc biệt</p>
                  <p class="text-sm text-gray-600">Giảm 20% lần đầu</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    --%>

    <!-- Testimonials Section -->
    <section class="py-20 bg-white fade-in">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-16">
          <h2 class="text-4xl md:text-5xl font-serif text-spa-dark mb-4">
            Khách hàng <span class="text-primary">nói gì</span>
          </h2>
          <p class="text-xl text-gray-600">
            Những chia sẻ chân thật từ khách hàng đã trải nghiệm dịch vụ
          </p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <!-- Testimonial 1 -->
          <div class="bg-white p-8 rounded-lg shadow-lg">
            <div class="flex mb-4">
              <i
                data-lucide="star"
                class="h-5 w-5 text-primary fill-current"
              ></i>
              <i
                data-lucide="star"
                class="h-5 w-5 text-primary fill-current"
              ></i>
              <i
                data-lucide="star"
                class="h-5 w-5 text-primary fill-current"
              ></i>
              <i
                data-lucide="star"
                class="h-5 w-5 text-primary fill-current"
              ></i>
              <i
                data-lucide="star"
                class="h-5 w-5 text-primary fill-current"
              ></i>
            </div>
            <p class="text-gray-700 mb-6 leading-relaxed italic">
              "Spa Hương Sen là nơi tôi tin tưởng để chăm sóc sắc đẹp. Dịch vụ
              chuyên nghiệp, không gian thư giãn tuyệt vời."
            </p>
            <div>
              <p class="font-semibold text-spa-dark">Chị Mai Anh</p>
              <p class="text-sm text-gray-500">Quận 1, TP.HCM</p>
            </div>
          </div>

          <!-- Testimonial 2 -->
          <div class="bg-white p-8 rounded-lg shadow-lg">
            <div class="flex mb-4">
              <i
                data-lucide="star"
                class="h-5 w-5 text-primary fill-current"
              ></i>
              <i
                data-lucide="star"
                class="h-5 w-5 text-primary fill-current"
              ></i>
              <i
                data-lucide="star"
                class="h-5 w-5 text-primary fill-current"
              ></i>
              <i
                data-lucide="star"
                class="h-5 w-5 text-primary fill-current"
              ></i>
              <i
                data-lucide="star"
                class="h-5 w-5 text-primary fill-current"
              ></i>
            </div>
            <p class="text-gray-700 mb-6 leading-relaxed italic">
              "Sau khi sử dụng dịch vụ chăm sóc da tại đây, làn da tôi trở nên
              mịn màng và sáng khỏe hơn rất nhiều."
            </p>
            <div>
              <p class="font-semibold text-spa-dark">Chị Thanh Hương</p>
              <p class="text-sm text-gray-500">Quận 7, TP.HCM</p>
            </div>
          </div>

          <!-- Testimonial 3 -->
          <div class="bg-white p-8 rounded-lg shadow-lg">
            <div class="flex mb-4">
              <i
                data-lucide="star"
                class="h-5 w-5 text-primary fill-current"
              ></i>
              <i
                data-lucide="star"
                class="h-5 w-5 text-primary fill-current"
              ></i>
              <i
                data-lucide="star"
                class="h-5 w-5 text-primary fill-current"
              ></i>
              <i
                data-lucide="star"
                class="h-5 w-5 text-primary fill-current"
              ></i>
              <i
                data-lucide="star"
                class="h-5 w-5 text-primary fill-current"
              ></i>
            </div>
            <p class="text-gray-700 mb-6 leading-relaxed italic">
              "Nhân viên rất chu đáo, tận tình. Giá cả hợp lý cho chất lượng
              dịch vụ cao cấp như thế này."
            </p>
            <div>
              <p class="font-semibold text-spa-dark">Chị Phương Linh</p>
              <p class="text-sm text-gray-500">Quận 3, TP.HCM</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <c:if test="${showBookingFeatures}">
      <section class="py-20 bg-primary fade-in">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 class="text-4xl md:text-5xl font-serif text-white mb-6">
            Sẵn sàng trải nghiệm?
          </h2>
          <p class="text-xl text-white/90 mb-8 max-w-2xl mx-auto">
            Đặt lịch ngay hôm nay để nhận ưu đãi đặc biệt dành cho khách hàng
            mới
          </p>
          <div class="flex flex-col sm:flex-row gap-4 justify-center">
            <a
              href="<c:url value='/booking'/>"
              class="px-8 py-4 bg-white text-primary rounded-full hover:bg-gray-100 transition-all duration-300 font-semibold text-lg"
            >
              Đặt lịch ngay
            </a>
            <a
              href="<c:url value='/services'/>"
              class="px-8 py-4 border-2 border-white text-white rounded-full hover:bg-white hover:text-primary transition-all duration-300 font-semibold text-lg"
            >
              Xem ưu đãi
            </a>
          </div>
        </div>
      </section>
    </c:if>

    <div id="notification" class="notification"></div>

    <!-- JavaScript -->
    <script src="<c:url value='/js/app.js'/>"></script>
    <script src="<c:url value='/js/service-tracker.js'/>"></script>
    <script src="<c:url value='/js/recently-viewed-services.js'/>"></script>
    <script src="<c:url value='/js/homepage-sections.js'/>"></script>


    <!-- Footer -->
    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
  </body>
</html>
