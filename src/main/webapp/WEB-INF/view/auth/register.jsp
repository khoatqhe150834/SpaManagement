<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@page
contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng ký - Spa Hương Sen</title>

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
    <div
      class="min-h-screen flex items-center justify-center pt-32 pb-12 px-4 sm:px-6 lg:px-8"
    >
      <div class="max-w-md w-full space-y-8">
        <!-- Header -->
        <div class="text-center">
         
          <h2 class="text-4xl font-serif text-spa-dark">Tạo tài khoản</h2>
          <p class="text-gray-600 mt-2">
            Trải nghiệm dịch vụ cao cấp ngay hôm nay
          </p>
        </div>

        <!-- Register Form -->
        <div class="bg-white rounded-lg shadow-lg p-8">
          <form id="register-form" class="space-y-6">
            <!-- Full Name -->
            <div>
              <label
                for="fullName"
                class="block text-sm font-medium text-gray-700 mb-2"
                >Họ và tên *</label
              >
              <div class="relative">
                <div
                  class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none"
                >
                  <i data-lucide="user" class="h-5 w-5 text-gray-400"></i>
                </div>
                <input
                  id="fullName"
                  name="fullName"
                  type="text"
                  class="form-input pl-11"
                  placeholder="Nhập họ và tên"
                  required
                />
              </div>
              <p class="mt-1 text-sm text-red-600 hidden" id="fullNameError"></p>
            </div>

            <!-- Phone Number -->
            <div>
              <label
                for="phone"
                class="block text-sm font-medium text-gray-700 mb-2"
                >Số điện thoại *</label
              >
              <div class="relative">
                <div
                  class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none"
                >
                  <i data-lucide="phone" class="h-5 w-5 text-gray-400"></i>
                </div>
                <input
                  id="phone"
                  name="phone"
                  type="tel"
                  class="form-input pl-11"
                  placeholder="Nhập số điện thoại"
                  required
                />
              </div>
              <p class="mt-1 text-sm text-red-600 hidden" id="phoneError"></p>
            </div>

            <!-- Email -->
            <div>
              <label
                for="email"
                class="block text-sm font-medium text-gray-700 mb-2"
                >Email *</label
              >
              <div class="relative">
                <div
                  class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none"
                >
                  <i data-lucide="mail" class="h-5 w-5 text-gray-400"></i>
                </div>
                <input
                  id="email"
                  name="email"
                  type="email"
                  class="form-input pl-11"
                  placeholder="Nhập email"
                  required
                />
              </div>
              <p class="mt-1 text-sm text-red-600 hidden" id="emailError"></p>
            </div>

            <!-- Password -->
            <div>
              <label
                for="password"
                class="block text-sm font-medium text-gray-700 mb-2"
                >Mật khẩu *</label
              >
              <div class="relative">
                <div
                  class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none"
                >
                  <i data-lucide="lock" class="h-5 w-5 text-gray-400"></i>
                </div>
                <input
                  id="password"
                  name="password"
                  type="password"
                  class="form-input pl-11 pr-11"
                  placeholder="Tạo mật khẩu"
                  required
                />
                <button
                  type="button"
                  id="toggle-password"
                  class="toggle-password absolute inset-y-0 right-0 flex items-center pr-3"
                >
                  <i
                    data-lucide="eye"
                    class="h-5 w-5 text-gray-400 hover:text-gray-600"
                  ></i>
                </button>
              </div>
              <p class="mt-1 text-sm text-red-600 hidden" id="passwordError"></p>
              <p class="text-xs text-gray-500 mt-2">
                Ít nhất 6 ký tự.
              </p>
            </div>

            <!-- Confirm Password -->
            <div>
              <label
                for="confirmPassword"
                class="block text-sm font-medium text-gray-700 mb-2"
                >Xác nhận mật khẩu *</label
              >
              <div class="relative">
                <div
                  class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none"
                >
                  <i data-lucide="lock" class="h-5 w-5 text-gray-400"></i>
                </div>
                <input
                  id="confirmPassword"
                  name="confirmPassword"
                  type="password"
                  class="form-input pl-11 pr-11"
                  placeholder="Nhập lại mật khẩu"
                  required
                />
                <button
                  type="button"
                  id="toggle-confirm-password"
                  class="toggle-password absolute inset-y-0 right-0 flex items-center pr-3"
                >
                  <i
                    data-lucide="eye"
                    class="h-5 w-5 text-gray-400 hover:text-gray-600"
                  ></i>
                </button>
              </div>
              <p class="mt-1 text-sm text-red-600 hidden" id="confirmPasswordError"></p>
            </div>

            <!-- Terms and Conditions -->
            <div class="flex items-start">
              <div class="flex items-center h-5">
                <input
                  id="agreeTerms"
                  name="agreeTerms"
                  type="checkbox"
                  class="h-4 w-4 text-primary focus:ring-primary border-gray-300 rounded"
                  required
                />
              </div>
              <div class="ml-3 text-sm">
                <label for="agreeTerms" class="font-medium text-gray-700"
                  >Tôi đồng ý với
                  <a href="#" id="terms-link" class="text-primary hover:text-primary-dark underline"
                    >Điều khoản sử dụng</a
                  ></label
                >
              </div>
            </div>
            <p id="agreeTermsError" class="mt-1 text-sm text-red-600 hidden"></p>

            <!-- Submit Button -->
            <div>
              <button
                type="submit"
                id="submit-btn"
                class="w-full flex justify-center py-3 px-4 border border-transparent rounded-full shadow-sm text-lg font-semibold text-white bg-primary hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-dark transition-all duration-300 transform hover:scale-105 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                <span class="btn-text">Đăng ký</span>
                <span class="btn-spinner hidden animate-spin mr-3">
                  <i data-lucide="loader-2"></i>
                </span>
              </button>
            </div>
          </form>

          <div class="mt-6 text-center">
            <p class="text-sm text-gray-600">
              Đã có tài khoản?
              <a
                href="<c:url value='/login'/>"
                class="font-medium text-primary hover:text-primary-dark"
                >Đăng nhập</a
              >
            </p>
          </div>
        </div>
      </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />

    <div id="terms-modal" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden items-center justify-center p-4">
        <div class="bg-white rounded-lg shadow-xl max-w-2xl w-full max-h-[90vh] flex flex-col">
            <div class="flex justify-between items-center p-4 border-b">
                <h3 class="text-2xl font-serif text-spa-dark">Điều khoản sử dụng</h3>
                <button id="close-modal-btn" class="text-gray-400 hover:text-gray-600">
                    <i data-lucide="x" class="h-6 w-6"></i>
                </button>
            </div>
            <div class="p-6 overflow-y-auto">
                <h4 class="font-semibold text-lg mb-2 text-spa-dark">1. Giới thiệu</h4>
                <p class="mb-4 text-gray-600">Chào mừng bạn đến với Spa Hương Sen. Bằng cách truy cập hoặc sử dụng trang web của chúng tôi, bạn đồng ý tuân thủ và bị ràng buộc bởi các điều khoản và điều kiện sử dụng sau đây. Vui lòng đọc kỹ các điều khoản này.</p>
                
                <h4 class="font-semibold text-lg mb-2 text-spa-dark">2. Quyền sở hữu trí tuệ</h4>
                <p class="mb-4 text-gray-600">Tất cả nội dung trên trang web này, bao gồm văn bản, đồ họa, logo, và hình ảnh, là tài sản của Spa Hương Sen và được bảo vệ bởi luật bản quyền. Mọi hành vi sao chép, phân phối, hoặc sử dụng lại nội dung mà không có sự cho phép bằng văn bản của chúng tôi đều bị nghiêm cấm.</p>

                <h4 class="font-semibold text-lg mb-2 text-spa-dark">3. Sử dụng Dịch vụ</h4>
                <p class="mb-4 text-gray-600">Bạn đồng ý chỉ sử dụng dịch vụ của chúng tôi cho các mục đích hợp pháp và theo cách không vi phạm quyền của bất kỳ ai khác. Bạn không được sử dụng trang web này để gửi hoặc truyền bất kỳ tài liệu nào có tính chất lừa đảo, phỉ báng, hoặc bất hợp pháp.</p>

                <h4 class="font-semibold text-lg mb-2 text-spa-dark">4. Đặt lịch và Hủy lịch</h4>
                <p class="mb-4 text-gray-600">Khi đặt lịch hẹn, bạn phải cung cấp thông tin chính xác và đầy đủ. Nếu bạn cần hủy hoặc thay đổi lịch hẹn, vui lòng thông báo cho chúng tôi ít nhất 24 giờ trước thời gian đã hẹn. Nếu không, bạn có thể phải chịu một khoản phí hủy lịch theo quy định của chúng tôi.</p>
                
                <h4 class="font-semibold text-lg mb-2 text-spa-dark">5. Giới hạn trách nhiệm</h4>
                <p class="mb-4 text-gray-600">Spa Hương Sen không chịu trách nhiệm cho bất kỳ thiệt hại trực tiếp, gián tiếp, ngẫu nhiên, hoặc do hậu quả nào phát sinh từ việc bạn sử dụng hoặc không thể sử dụng trang web hoặc dịch vụ của chúng tôi.</p>
                
                <h4 class="font-semibold text-lg mb-2 text-spa-dark">6. Thay đổi điều khoản</h4>
                <p class="mb-4 text-gray-600">Chúng tôi có quyền sửa đổi các điều khoản sử dụng này bất cứ lúc nào. Mọi thay đổi sẽ có hiệu lực ngay khi được đăng trên trang web. Việc bạn tiếp tục sử dụng trang web sau khi các thay đổi được đăng tải đồng nghĩa với việc bạn chấp nhận các điều khoản đã được sửa đổi.</p>
            </div>
            <div class="p-4 border-t text-right">
                 <button id="accept-terms-btn" class="btn btn-primary">Tôi đã hiểu</button>
            </div>
        </div>
    </div>
    <div id="notification" class="notification"></div>

    <script src="<c:url value='/js/app.js'/>"></script>
    <script src="<c:url value='/js/register.js'/>"></script>
  </body>
</html>
