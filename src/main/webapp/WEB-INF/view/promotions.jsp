<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Khuyến mãi - Spa Hương Sen</title>

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
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
  </head>

  <body class="bg-spa-cream">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />

    <main class="py-12 px-4 md:px-8 pt-28">
        <div class="container mx-auto">
                          <div class="text-center mb-12">
            <h1 class="text-4xl md:text-5xl font-bold text-spa-dark">
              Ưu đãi & Khuyến mãi đặc biệt
            </h1>
            <p class="text-lg text-gray-600 mt-4">
                Tận hưởng những gói độc quyền và giảm giá theo mùa của chúng tôi.
            </p>
            <div class="mt-6">
                <a href="${pageContext.request.contextPath}/promotions/available" 
                   class="inline-block bg-primary text-white px-6 py-3 rounded-lg hover:bg-primary-dark transition-colors">
                    <i class="fas fa-tags mr-2"></i>
                    Xem Mã Khuyến Mãi Của Tôi
                </a>
            </div>
          </div>
  
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            <!-- Promotion Card 1: Seasonal Special -->
            <div
              class="bg-white rounded-lg shadow-lg overflow-hidden transform hover:scale-105 transition-transform duration-300"
            >
              <img
                src="https://images.unsplash.com/photo-1540555700478-4be289fbecef?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80"
                alt="Summer package"
                class="w-full h-56 object-cover"
              />
              <div class="p-6">
                <h3 class="text-2xl font-semibold text-spa-dark mb-2">
                    Gói Summer Glow
                </h3>
                <p class="text-gray-600 mb-4">
                    Hãy sẵn sàng cho mùa hè với liệu pháp chăm sóc da mặt sảng khoái, tẩy tế bào chết toàn thân và làm móng chân cổ điển.
                </p>
                <div class="text-3xl font-bold text-green-600 mb-4">
                  $150
                  <span class="text-lg text-gray-500 line-through">$180</span>
                </div>
                <button
                  class="w-full bg-green-500 text-white py-2 rounded-lg font-semibold hover:bg-green-600 transition-colors"
                >
                  Đặt ngay
                </button>
              </div>
            </div>
  
            <!-- Promotion Card 2: Couple's Retreat -->
            <div
              class="bg-white rounded-lg shadow-lg overflow-hidden transform hover:scale-105 transition-transform duration-300"
            >
              <img
                src="https://images.unsplash.com/photo-1596178065887-1198b6148b2b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80"
                alt="Couple's massage"
                class="w-full h-56 object-cover"
              />
              <div class="p-6">
                <h3 class="text-2xl font-semibold text-spa-dark mb-2">
                    Thiên đường đôi
                </h3>
                <p class="text-gray-600 mb-4">
                    Tận hưởng một cuộc trốn thoát lãng mạn với dịch vụ mát-xa cạnh nhau và phòng tắm riêng dành cho hai người.
                </p>
                <div class="text-3xl font-bold text-green-600 mb-4">
                  $250
                  <span class="text-lg text-gray-500 line-through">$300</span>
                </div>
                <button
                  class="w-full bg-green-500 text-white py-2 rounded-lg font-semibold hover:bg-green-600 transition-colors"
                >
                  Đặt ngay
                </button>
              </div>
            </div>
  
            <!-- Promotion Card 3: Loyalty Exclusive -->
            <div
              class="bg-white rounded-lg shadow-lg overflow-hidden transform hover:scale-105 transition-transform duration-300"
            >
              <img
                src="https://images.unsplash.com/photo-1512290923902-8a9f21dc26f5?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80"
                alt="Hot stone therapy"
                class="w-full h-56 object-cover"
              />
              <div class="p-6">
                <h3 class="text-2xl font-semibold text-spa-dark mb-2">
                    Ưu đãi đặc biệt dành cho thành viên
                </h3>
                <p class="text-gray-600 mb-4">
                    Các thành viên thân thiết được giảm giá 30% cho liệu pháp đá nóng đặc trưng của chúng tôi trong tháng này.
                </p>
                <div class="text-3xl font-bold text-green-600 mb-4">30% OFF</div>
                <button
                  class="w-full bg-green-500 text-white py-2 rounded-lg font-semibold hover:bg-green-600 transition-colors"
                >
                    Đăng nhập để nhận
                </button>
              </div>
            </div>
          </div>
        </div>
      </main>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />

    <!-- JavaScript -->
    <script src="<c:url value='/js/app.js'/>"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/flowbite/1.8.1/flowbite.min.js"></script>
  </body>
</html> 