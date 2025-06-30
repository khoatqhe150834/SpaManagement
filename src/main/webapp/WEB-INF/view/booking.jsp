<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đặt lịch - Spa Hương Sen</title>

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
        <!-- Confirmation View (Initially Hidden) -->
        <div
          id="confirmation-view"
          class="hidden min-h-screen flex items-center justify-center"
        >
          <div class="max-w-2xl mx-auto px-4 text-center">
            <div class="bg-white rounded-lg shadow-lg p-8">
              <i
                data-lucide="check-circle"
                class="h-16 w-16 text-green-500 mx-auto mb-6"
              ></i>
              <h1 class="text-3xl font-serif text-spa-dark mb-4">
                Đặt lịch thành công!
              </h1>
              <p class="text-lg text-gray-600 mb-6">
                Cảm ơn bạn đã đặt lịch tại Spa Hương Sen. Chúng tôi sẽ liên hệ với
                bạn trong vòng 30 phút để xác nhận lịch hẹn.
              </p>
              <div id="booking-summary" class="bg-spa-cream rounded-lg p-6 mb-6">
                <!-- Summary will be populated by JS -->
              </div>
              <button
                id="new-booking-btn"
                class="px-8 py-3 bg-primary text-white rounded-full hover:bg-primary-dark transition-colors font-semibold"
              >
                Đặt lịch mới
              </button>
            </div>
          </div>
        </div>
  
        <!-- Booking Form View -->
        <div id="booking-form-view">
          <!-- Page Header -->
          <section class="py-16 bg-white">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
              <h1 class="text-5xl md:text-6xl font-serif text-spa-dark mb-6">
                Đặt lịch <span class="text-primary">trải nghiệm</span>
              </h1>
              <p class="text-xl text-gray-600 max-w-3xl mx-auto leading-relaxed">
                Chỉ cần vài bước đơn giản để đặt lịch và bắt đầu hành trình chăm
                sóc sắc đẹp của bạn
              </p>
            </div>
          </section>
  
          <!-- Booking Form -->
          <section class="py-16">
            <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
              <form id="booking-form" class="bg-white rounded-lg shadow-lg p-8">
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                  <!-- Service Selection -->
                  <div class="lg:col-span-2">
                    <h2
                      class="text-2xl font-serif text-spa-dark mb-6 flex items-center"
                    >
                      <i data-lucide="user" class="h-6 w-6 mr-2 text-primary"></i>
                      1. Chọn dịch vụ
                    </h2>
                    <div
                      id="services-container"
                      class="grid grid-cols-1 md:grid-cols-2 gap-4"
                    >
                      <!-- Services loaded by JS -->
                    </div>
                  </div>
  
                  <!-- Date Selection -->
                  <div>
                    <h2
                      class="text-2xl font-serif text-spa-dark mb-6 flex items-center"
                    >
                      <i
                        data-lucide="calendar"
                        class="h-6 w-6 mr-2 text-primary"
                      ></i>
                      2. Chọn ngày
                    </h2>
                    <select
                      id="date-select"
                      name="date"
                      class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                      required
                    >
                      <!-- Dates loaded by JS -->
                    </select>
                  </div>
  
                  <!-- Time Selection -->
                  <div>
                    <h2
                      class="text-2xl font-serif text-spa-dark mb-6 flex items-center"
                    >
                      <i
                        data-lucide="clock"
                        class="h-6 w-6 mr-2 text-primary"
                      ></i>
                      3. Chọn giờ
                    </h2>
                    <select
                      id="time-select"
                      name="time"
                      class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                      required
                    >
                      <!-- Times loaded by JS -->
                    </select>
                  </div>
  
                  <!-- Personal Information -->
                  <div class="lg:col-span-2">
                    <h2
                      class="text-2xl font-serif text-spa-dark mb-6 flex items-center"
                    >
                      <i
                        data-lucide="user"
                        class="h-6 w-6 mr-2 text-primary"
                      ></i>
                      4. Thông tin cá nhân
                    </h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                      <div>
                        <label
                          for="name"
                          class="block text-sm font-medium text-gray-700 mb-2"
                          >Họ và tên</label
                        >
                        <input
                          type="text"
                          id="name"
                          name="name"
                          class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                          required
                        />
                      </div>
                      <div>
                        <label
                          for="phone"
                          class="block text-sm font-medium text-gray-700 mb-2"
                          >Số điện thoại</label
                        >
                        <input
                          type="tel"
                          id="phone"
                          name="phone"
                          class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                          required
                        />
                      </div>
                      <div class="md:col-span-2">
                        <label
                          for="email"
                          class="block text-sm font-medium text-gray-700 mb-2"
                          >Email</label
                        >
                        <input
                          type="email"
                          id="email"
                          name="email"
                          class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                        />
                      </div>
                      <div class="md:col-span-2">
                        <label
                          for="notes"
                          class="block text-sm font-medium text-gray-700 mb-2"
                          >Ghi chú</label
                        >
                        <textarea
                          id="notes"
                          name="notes"
                          rows="4"
                          class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                        ></textarea>
                      </div>
                    </div>
                  </div>
                </div>
  
                <!-- Submit Button -->
                <div class="lg:col-span-2 text-center mt-8">
                  <button
                    type="submit"
                    class="px-12 py-4 bg-primary text-white rounded-full hover:bg-primary-dark transition-colors font-semibold text-lg"
                  >
                    Xác nhận đặt lịch
                  </button>
                </div>
              </form>
            </div>
          </section>
        </div>
      </main>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />

    <!-- JavaScript -->
    <script src="<c:url value='/js/app.js'/>"></script>
    <script src="<c:url value='/js/booking.js'/>"></script>
  </body>
</html>
 