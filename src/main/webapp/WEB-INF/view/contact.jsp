<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Liên hệ - Spa Hương Sen</title>

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
      <!-- Page Header -->
      <section class="py-16 bg-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 class="text-5xl md:text-6xl font-serif text-spa-dark mb-6">
            Liên hệ <span class="text-primary">với chúng tôi</span>
          </h1>
          <p class="text-xl text-gray-600 max-w-3xl mx-auto leading-relaxed">
            Chúng tôi luôn sẵn sàng lắng nghe và hỗ trợ bạn. Hãy liên hệ để được
            tư vấn và trải nghiệm dịch vụ tốt nhất
          </p>
        </div>
      </section>

      <!-- Contact Info Grid -->
      <section class="py-16 fade-in">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            <!-- Phone -->
            <div
              class="bg-white rounded-lg shadow-lg p-6 text-center hover:shadow-xl transition-shadow"
            >
              <div
                class="bg-secondary rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4"
              >
                <i data-lucide="phone" class="h-8 w-8 text-primary"></i>
              </div>
              <h3 class="text-xl font-semibold text-spa-dark mb-3">
                Điện thoại
              </h3>
              <div class="space-y-1 mb-3">
                <p class="text-primary font-medium">0901 234 567</p>
                <p class="text-primary font-medium">028 1234 5678</p>
              </div>
              <p class="text-sm text-gray-600">
                Thời gian: 8:00 - 21:00 hàng ngày
              </p>
            </div>
            <!-- Email -->
            <div
              class="bg-white rounded-lg shadow-lg p-6 text-center hover:shadow-xl transition-shadow"
            >
              <div
                class="bg-secondary rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4"
              >
                <i data-lucide="mail" class="h-8 w-8 text-primary"></i>
              </div>
              <h3 class="text-xl font-semibold text-spa-dark mb-3">Email</h3>
              <div class="space-y-1 mb-3">
                <p class="text-primary font-medium">info@spahuongsen.vn</p>
                <p class="text-primary font-medium">booking@spahuongsen.vn</p>
              </div>
              <p class="text-sm text-gray-600">Phản hồi trong vòng 2 giờ</p>
            </div>
            <!-- Address -->
            <div
              class="bg-white rounded-lg shadow-lg p-6 text-center hover:shadow-xl transition-shadow"
            >
              <div
                class="bg-secondary rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4"
              >
                <i data-lucide="map-pin" class="h-8 w-8 text-primary"></i>
              </div>
              <h3 class="text-xl font-semibold text-spa-dark mb-3">Địa chỉ</h3>
              <div class="space-y-1 mb-3">
                <p class="text-primary font-medium">123 Nguyễn Văn Linh</p>
                <p class="text-primary font-medium">Quận 7, TP. Hồ Chí Minh</p>
              </div>
              <p class="text-sm text-gray-600">
                Gần chợ Tân Mỹ, dễ dàng tìm thấy
              </p>
            </div>
            <!-- Opening Hours -->
            <div
              class="bg-white rounded-lg shadow-lg p-6 text-center hover:shadow-xl transition-shadow"
            >
              <div
                class="bg-secondary rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4"
              >
                <i data-lucide="clock" class="h-8 w-8 text-primary"></i>
              </div>
              <h3 class="text-xl font-semibold text-spa-dark mb-3">
                Giờ mở cửa
              </h3>
              <div class="space-y-1 mb-3">
                <p class="text-primary font-medium">Thứ 2 - CN: 8:00 - 21:00</p>
                <p class="text-primary font-medium">Ngày lễ: 9:00 - 20:00</p>
              </div>
              <p class="text-sm text-gray-600">Phục vụ 7 ngày trong tuần</p>
            </div>
          </div>
        </div>
      </section>

      <!-- Contact Form & Map -->
      <section class="py-20 bg-white fade-in">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">
            <!-- Form -->
            <div>
              <h2 class="text-3xl font-serif text-spa-dark mb-6">
                Gửi tin nhắn cho chúng tôi
              </h2>
              <form id="contact-form" class="space-y-6">
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
                    for="email"
                    class="block text-sm font-medium text-gray-700 mb-2"
                    >Email</label
                  >
                  <input
                    type="email"
                    id="email"
                    name="email"
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
                  />
                </div>
                <div>
                  <label
                    for="message"
                    class="block text-sm font-medium text-gray-700 mb-2"
                    >Lời nhắn</label
                  >
                  <textarea
                    id="message"
                    name="message"
                    rows="5"
                    class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                    required
                  ></textarea>
                </div>
                <div>
                  <button
                    type="submit"
                    class="w-full px-8 py-3 bg-primary text-white rounded-full hover:bg-primary-dark transition-colors font-semibold"
                  >
                    Gửi tin nhắn
                  </button>
                </div>
              </form>
            </div>
            <!-- Map -->
            <div>
              <h2 class="text-3xl font-serif text-spa-dark mb-6">
                Vị trí của chúng tôi
              </h2>
              <div class="aspect-w-16 aspect-h-9 rounded-lg overflow-hidden">
                <iframe
                  src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3919.954160533036!2d106.67564341528656!3d10.73800299234763!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31752f62a90e5dbd%3A0x674d5126513db295!2zMTIzIE5ndXnhu4VuIFbEg24gTGluaCwgVMOibiBQaG9uZywgUXXhuq1uIDcsIFRow6BuaCBwaOG7kSBI4buTIENow60gTWluaCwgVmnhu4d0IE5hbQ!5e0!3m2!1svi!2s!4v1684311129958!5m2!1svi!2s"
                  width="100%"
                  height="100%"
                  style="border: 0"
                  allowfullscreen=""
                  loading="lazy"
                  referrerpolicy="no-referrer-when-downgrade"
                ></iframe>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />

    <div id="notification" class="notification"></div>
    <script src="<c:url value='/js/app.js'/>"></script>
    <script src="<c:url value='/js/contact.js'/>"></script>
  </body>
</html> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Liên hệ - Spa Hương Sen</title>

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
      <!-- Page Header -->
      <section class="py-16 bg-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 class="text-5xl md:text-6xl font-serif text-spa-dark mb-6">
            Liên hệ <span class="text-primary">với chúng tôi</span>
          </h1>
          <p class="text-xl text-gray-600 max-w-3xl mx-auto leading-relaxed">
            Chúng tôi luôn sẵn sàng lắng nghe và hỗ trợ bạn. Hãy liên hệ để được
            tư vấn và trải nghiệm dịch vụ tốt nhất
          </p>
        </div>
      </section>

      <!-- Contact Info Grid -->
      <section class="py-16 fade-in">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            <!-- Phone -->
            <div
              class="bg-white rounded-lg shadow-lg p-6 text-center hover:shadow-xl transition-shadow"
            >
              <div
                class="bg-secondary rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4"
              >
                <i data-lucide="phone" class="h-8 w-8 text-primary"></i>
              </div>
              <h3 class="text-xl font-semibold text-spa-dark mb-3">
                Điện thoại
              </h3>
              <div class="space-y-1 mb-3">
                <p class="text-primary font-medium">0901 234 567</p>
                <p class="text-primary font-medium">028 1234 5678</p>
              </div>
              <p class="text-sm text-gray-600">
                Thời gian: 8:00 - 21:00 hàng ngày
              </p>
            </div>
            <!-- Email -->
            <div
              class="bg-white rounded-lg shadow-lg p-6 text-center hover:shadow-xl transition-shadow"
            >
              <div
                class="bg-secondary rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4"
              >
                <i data-lucide="mail" class="h-8 w-8 text-primary"></i>
              </div>
              <h3 class="text-xl font-semibold text-spa-dark mb-3">Email</h3>
              <div class="space-y-1 mb-3">
                <p class="text-primary font-medium">info@spahuongsen.vn</p>
                <p class="text-primary font-medium">booking@spahuongsen.vn</p>
              </div>
              <p class="text-sm text-gray-600">Phản hồi trong vòng 2 giờ</p>
            </div>
            <!-- Address -->
            <div
              class="bg-white rounded-lg shadow-lg p-6 text-center hover:shadow-xl transition-shadow"
            >
              <div
                class="bg-secondary rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4"
              >
                <i data-lucide="map-pin" class="h-8 w-8 text-primary"></i>
              </div>
              <h3 class="text-xl font-semibold text-spa-dark mb-3">Địa chỉ</h3>
              <div class="space-y-1 mb-3">
                <p class="text-primary font-medium">123 Nguyễn Văn Linh</p>
                <p class="text-primary font-medium">Quận 7, TP. Hồ Chí Minh</p>
              </div>
              <p class="text-sm text-gray-600">
                Gần chợ Tân Mỹ, dễ dàng tìm thấy
              </p>
            </div>
            <!-- Opening Hours -->
            <div
              class="bg-white rounded-lg shadow-lg p-6 text-center hover:shadow-xl transition-shadow"
            >
              <div
                class="bg-secondary rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4"
              >
                <i data-lucide="clock" class="h-8 w-8 text-primary"></i>
              </div>
              <h3 class="text-xl font-semibold text-spa-dark mb-3">
                Giờ mở cửa
              </h3>
              <div class="space-y-1 mb-3">
                <p class="text-primary font-medium">Thứ 2 - CN: 8:00 - 21:00</p>
                <p class="text-primary font-medium">Ngày lễ: 9:00 - 20:00</p>
              </div>
              <p class="text-sm text-gray-600">Phục vụ 7 ngày trong tuần</p>
            </div>
          </div>
        </div>
      </section>

      <!-- Contact Form & Map -->
      <section class="py-20 bg-white fade-in">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">
            <!-- Form -->
            <div>
              <h2 class="text-3xl font-serif text-spa-dark mb-6">
                Gửi tin nhắn cho chúng tôi
              </h2>
              <form id="contact-form" class="space-y-6">
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
                    for="email"
                    class="block text-sm font-medium text-gray-700 mb-2"
                    >Email</label
                  >
                  <input
                    type="email"
                    id="email"
                    name="email"
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
                  />
                </div>
                <div>
                  <label
                    for="message"
                    class="block text-sm font-medium text-gray-700 mb-2"
                    >Lời nhắn</label
                  >
                  <textarea
                    id="message"
                    name="message"
                    rows="5"
                    class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                    required
                  ></textarea>
                </div>
                <div>
                  <button
                    type="submit"
                    class="w-full px-8 py-3 bg-primary text-white rounded-full hover:bg-primary-dark transition-colors font-semibold"
                  >
                    Gửi tin nhắn
                  </button>
                </div>
              </form>
            </div>
            <!-- Map -->
            <div>
              <h2 class="text-3xl font-serif text-spa-dark mb-6">
                Vị trí của chúng tôi
              </h2>
              <div class="aspect-w-16 aspect-h-9 rounded-lg overflow-hidden">
                <iframe
                  src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3919.954160533036!2d106.67564341528656!3d10.73800299234763!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31752f62a90e5dbd%3A0x674d5126513db295!2zMTIzIE5ndXnhu4VuIFbEg24gTGluaCwgVMOibiBQaG9uZywgUXXhuq1uIDcsIFRow6BuaCBwaOG7kSBI4buTIENow60gTWluaCwgVmnhu4d0IE5hbQ!5e0!3m2!1svi!2s!4v1684311129958!5m2!1svi!2s"
                  width="100%"
                  height="100%"
                  style="border: 0"
                  allowfullscreen=""
                  loading="lazy"
                  referrerpolicy="no-referrer-when-downgrade"
                ></iframe>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />

    <div id="notification" class="notification"></div>
    <script src="<c:url value='/js/app.js'/>"></script>
    <script src="<c:url value='/js/contact.js'/>"></script>
  </body>
</html> 
 