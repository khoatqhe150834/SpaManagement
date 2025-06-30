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
      class="min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8"
    >
      <div class="max-w-md w-full space-y-8">
        <!-- Header -->
        <div class="text-center">
          <a
            href="<c:url value='/index'/>"
            class="text-3xl font-serif font-bold text-primary mb-2 inline-block"
            >Spa Hương Sen</a
          >
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
              <p class="form-error-text"></p>
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
              <p class="form-error-text"></p>
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
                  class="toggle-password absolute inset-y-0 right-0 flex items-center pr-3"
                >
                  <i
                    data-lucide="eye"
                    class="h-5 w-5 text-gray-400 hover:text-gray-600"
                  ></i>
                </button>
              </div>
              <p class="form-error-text"></p>
              <p class="text-xs text-gray-500 mt-2">
                Ít nhất 8 ký tự, gồm chữ hoa, chữ thường và số.
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
                  class="toggle-password absolute inset-y-0 right-0 flex items-center pr-3"
                >
                  <i
                    data-lucide="eye"
                    class="h-5 w-5 text-gray-400 hover:text-gray-600"
                  ></i>
                </button>
              </div>
              <p class="form-error-text"></p>
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
                  <a href="#" class="text-primary hover:text-primary-dark"
                    >Điều khoản sử dụng</a
                  ></label
                >
              </div>
            </div>
            <p id="agreeTerms-error" class="form-error-text"></p>

            <!-- Submit Button -->
            <button
              type="submit"
              id="submit-btn"
              class="btn btn-primary w-full flex justify-center items-center"
            >
              <span class="btn-text">Đăng ký</span>
              <span class="btn-spinner hidden"></span>
            </button>
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
    <div id="notification" class="notification"></div>

    <script src="<c:url value='/js/app.js'/>"></script>
    <script src="<c:url value='/js/register.js'/>"></script>
  </body>
</html>
