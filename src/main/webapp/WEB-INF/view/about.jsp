<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Về chúng tôi - Spa Hương Sen</title>

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
            Về <span class="text-primary">chúng tôi</span>
          </h1>
          <p class="text-xl text-gray-600 max-w-3xl mx-auto leading-relaxed">
            Spa Hương Sen - Nơi vẻ đẹp tự nhiên của phụ nữ Việt được tôn vinh và
            nâng niu bằng những liệu pháp chăm sóc tinh tế nhất
          </p>
        </div>
      </section>

      <!-- Story Section -->
      <section class="py-20 fade-in">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
            <div>
              <h2 class="text-4xl md:text-5xl font-serif text-spa-dark mb-6">
                Câu chuyện <span class="text-primary">của chúng tôi</span>
              </h2>
              <div class="space-y-6 text-lg text-gray-700 leading-relaxed">
                <p>
                  Spa Hương Sen được thành lập năm 2021 với sứ mệnh mang đến cho
                  phụ nữ Việt Nam một không gian thư giãn hoàn hảo, nơi vẻ đẹp
                  tự nhiên được chăm sóc và nuôi dưỡng.
                </p>
                <p>
                  Chúng tôi tin rằng mỗi người phụ nữ đều xứng đáng có những
                  giây phút thư giãn, chăm sóc bản thân và tìm lại sự cân bằng
                  trong cuộc sống hiện đại đầy bận rộn.
                </p>
                <p>
                  Với triết lý "Vẻ đẹp tự nhiên là vẻ đẹp bền vững", chúng tôi
                  chỉ sử dụng những sản phẩm thiên nhiên, an toàn và các liệu
                  pháp truyền thống kết hợp với công nghệ hiện đại.
                </p>
              </div>
            </div>
            <div class="relative">
              <img
                src="https://images.pexels.com/photos/3985254/pexels-photo-3985254.jpeg?auto=compress&cs=tinysrgb&w=800"
                alt="Spa Story"
                class="rounded-lg shadow-2xl"
              />
              <div
                class="absolute -bottom-6 -right-6 bg-primary text-white p-6 rounded-lg shadow-lg"
              >
                <p class="font-bold text-2xl">3+</p>
                <p class="text-sm">Năm kinh nghiệm</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Values Section -->
      <section class="py-20 bg-white fade-in">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center mb-16">
            <h2 class="text-4xl md:text-5xl font-serif text-spa-dark mb-6">
              Giá trị <span class="text-primary">cốt lõi</span>
            </h2>
            <p class="text-xl text-gray-600 max-w-3xl mx-auto">
              Những giá trị mà chúng tôi luôn theo đuổi trong từng dịch vụ
            </p>
          </div>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            <div class="text-center">
              <div
                class="bg-secondary rounded-full w-20 h-20 flex items-center justify-center mx-auto mb-6"
              >
                <i data-lucide="award" class="h-8 w-8 text-primary"></i>
              </div>
              <h3 class="text-xl font-semibold text-spa-dark mb-4">
                Giải thưởng Spa tốt nhất
              </h3>
              <p class="text-gray-600 leading-relaxed">
                Được vinh danh "Spa chăm sóc sắc đẹp tốt nhất TP.HCM 2023"
              </p>
            </div>
            <div class="text-center">
              <div
                class="bg-secondary rounded-full w-20 h-20 flex items-center justify-center mx-auto mb-6"
              >
                <i data-lucide="users" class="h-8 w-8 text-primary"></i>
              </div>
              <h3 class="text-xl font-semibold text-spa-dark mb-4">
                5000+ Khách hàng hài lòng
              </h3>
              <p class="text-gray-600 leading-relaxed">
                Phục vụ hơn 5000 khách hàng với tỷ lệ hài lòng 98%
              </p>
            </div>
            <div class="text-center">
              <div
                class="bg-secondary rounded-full w-20 h-20 flex items-center justify-center mx-auto mb-6"
              >
                <i data-lucide="heart" class="h-8 w-8 text-primary"></i>
              </div>
              <h3 class="text-xl font-semibold text-spa-dark mb-4">
                Cam kết chất lượng
              </h3>
              <p class="text-gray-600 leading-relaxed">
                Sử dụng 100% sản phẩm tự nhiên, an toàn cho da
              </p>
            </div>
            <div class="text-center">
              <div
                class="bg-secondary rounded-full w-20 h-20 flex items-center justify-center mx-auto mb-6"
              >
                <i data-lucide="sparkles" class="h-8 w-8 text-primary"></i>
              </div>
              <h3 class="text-xl font-semibold text-spa-dark mb-4">
                Công nghệ hiện đại
              </h3>
              <p class="text-gray-600 leading-relaxed">
                Trang bị máy móc và công nghệ chăm sóc da tiên tiến nhất
              </p>
            </div>
          </div>
        </div>
      </section>

      <!-- Team Section -->
      <section class="py-20 bg-spa-cream fade-in">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center mb-16">
            <h2 class="text-4xl md:text-5xl font-serif text-spa-dark mb-6">
              Đội ngũ <span class="text-primary">chuyên gia</span>
            </h2>
            <p class="text-xl text-gray-600 max-w-3xl mx-auto">
              Những chuyên gia giàu kinh nghiệm với tấm lòng tận tâm chăm sóc
              sắc đẹp cho bạn
            </p>
          </div>
          <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div class="bg-white rounded-lg shadow-lg overflow-hidden card">
              <img
                src="https://images.pexels.com/photos/3985263/pexels-photo-3985263.jpeg?auto=compress&cs=tinysrgb&w=600"
                alt="Chị Nguyễn Thị Hương"
                class="w-full h-64 object-cover"
              />
              <div class="p-6">
                <h3 class="text-xl font-semibold text-spa-dark mb-2">
                  Chị Nguyễn Thị Hương
                </h3>
                <p class="text-primary font-medium mb-2">
                  Giám đốc & Chuyên gia chăm sóc da
                </p>
                <p class="text-sm text-gray-500 mb-3">15 năm kinh nghiệm</p>
                <p class="text-gray-600 leading-relaxed">
                  Chuyên gia hàng đầu về chăm sóc da với chứng chỉ quốc tế
                </p>
              </div>
            </div>
            <div class="bg-white rounded-lg shadow-lg overflow-hidden card">
              <img
                src="https://images.pexels.com/photos/3997991/pexels-photo-3997991.jpeg?auto=compress&cs=tinysrgb&w=600"
                alt="Chị Trần Thị Lan"
                class="w-full h-64 object-cover"
              />
              <div class="p-6">
                <h3 class="text-xl font-semibold text-spa-dark mb-2">
                  Chị Trần Thị Lan
                </h3>
                <p class="text-primary font-medium mb-2">Chuyên viên Massage</p>
                <p class="text-sm text-gray-500 mb-3">8 năm kinh nghiệm</p>
                <p class="text-gray-600 leading-relaxed">
                  Thành thạo các kỹ thuật massage truyền thống và hiện đại
                </p>
              </div>
            </div>
            <div class="bg-white rounded-lg shadow-lg overflow-hidden card">
              <img
                src="https://images.pexels.com/photos/3985254/pexels-photo-3985254.jpeg?auto=compress&cs=tinysrgb&w=600"
                alt="Chị Lê Thị Mai"
                class="w-full h-64 object-cover"
              />
              <div class="p-6">
                <h3 class="text-xl font-semibold text-spa-dark mb-2">
                  Chị Lê Thị Mai
                </h3>
                <p class="text-primary font-medium mb-2">
                  Chuyên viên Tắm trắng
                </p>
                <p class="text-sm text-gray-500 mb-3">6 năm kinh nghiệm</p>
                <p class="text-gray-600 leading-relaxed">
                  Chuyên về các liệu pháp làm trắng da tự nhiên
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Mission & Vision Section -->
      <section
        class="py-20 bg-gradient-to-br from-primary to-primary-dark text-white fade-in"
      >
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
            <div>
              <h2 class="text-4xl md:text-5xl font-serif mb-6">
                Sứ mệnh của chúng tôi
              </h2>
              <div class="space-y-6 text-lg leading-relaxed">
                <p>
                  Mang đến cho mỗi khách hàng trải nghiệm thư giãn tuyệt vời
                  nhất, giúp họ tìm lại sự cân bằng và tự tin trong cuộc sống.
                </p>
                <p>
                  Chúng tôi cam kết không ngừng nâng cao chất lượng dịch vụ, đào
                  tạo đội ngũ chuyên nghiệp và cập nhật những xu hướng chăm sóc
                  sắc đẹp mới nhất.
                </p>
              </div>
            </div>
            <div>
              <h2 class="text-4xl md:text-5xl font-serif mb-6">
                Tầm nhìn tương lai
              </h2>
              <div class="space-y-6 text-lg leading-relaxed">
                <p>
                  Trở thành chuỗi spa hàng đầu tại Việt Nam, là biểu tượng của
                  vẻ đẹp tự nhiên và sự thư giãn đẳng cấp.
                </p>
                <p>
                  Mở rộng hệ thống trên toàn quốc, mang trải nghiệm Spa Hương
                  Sen đến với tất cả phụ nữ Việt.
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />

    <!-- JavaScript -->
    <script src="<c:url value='/js/app.js'/>"></script>
  </body>
</html>
