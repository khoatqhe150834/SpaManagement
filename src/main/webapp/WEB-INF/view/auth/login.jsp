<%-- Document : login Created on : May 27, 2025, 7:34:53 AM Author : quang --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@page
contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng nhập - Spa Hương Sen</title>

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
         
          <h2 class="text-4xl font-serif text-spa-dark">Đăng nhập</h2>
          <p class="text-gray-600 mt-2">Chào mừng bạn trở lại!</p>
        </div>

      

        <!-- Login Form -->
        <div class="bg-white rounded-lg shadow-lg p-8">
          <form id="login-form" class="space-y-6" action="<c:url value='/login'/>" method="POST" novalidate>
            <div
              id="error-message"
              class="hidden bg-red-50 border border-red-200 rounded-lg p-3"
            >
              <p class="text-sm text-red-600"></p>
            </div>

            <!-- Email Field -->
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
                  placeholder="Nhập email của bạn"
                  required
                />
              </div>

                   
              <p class="mt-1 text-sm text-red-600 hidden" id="emailError"></p>
            </div>

            

            <!-- Password Field -->
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
                  placeholder="Nhập mật khẩu"
                  required
                />

           
                <button
                  type="button"
                  id="toggle-password"
                  class="absolute inset-y-0 right-0 flex items-center pr-3"
                >
                  <i
                    data-lucide="eye"
                    class="h-5 w-5 text-gray-400 hover:text-gray-600"
                  ></i>
                </button>
              </div>
              <p class="mt-1 text-sm text-red-600 hidden" id="passwordError"></p>
            </div>

            <!-- Remember Me & Forgot Password -->
            <div class="flex items-center justify-between">
              <div class="flex items-center">
                <input
                  id="remember-me"
                  name="remember-me"
                  type="checkbox"
                  class="h-4 w-4 text-primary focus:ring-primary border-gray-300 rounded"
                />
                <label
                  for="remember-me"
                  class="ml-2 block text-sm text-gray-700"
                  >Ghi nhớ đăng nhập</label
                >
              </div>
              <a
                href="<c:url value='/password-reset/new'/>"
                class="text-sm text-primary hover:text-primary-dark"
                >Quên mật khẩu?</a
              >
            </div>

            <!-- Submit Button -->
            <button
              type="submit"
              id="submit-btn"
              class="btn btn-primary w-full flex justify-center items-center"
            >
              <span class="btn-text">Đăng nhập</span>
              <span class="btn-spinner hidden"></span>
            </button>
          </form>

          <div class="mt-6 text-center">
            <p class="text-sm text-gray-600">
              Chưa có tài khoản?
              <a
                href="<c:url value='/register'/>"
                class="font-medium text-primary hover:text-primary-dark"
                >Đăng ký ngay</a
              >
            </p>
          </div>


           <!-- Social Login -->
                        <div class="bg-white rounded-lg shadow-lg p-6">
                            <div class="text-center mb-4">
                                <span class="text-gray-500 text-sm">Hoặc đăng nhập bằng</span>
                            </div>
                            <div class="space-y-3">
                                <button class="w-full flex items-center justify-center px-4 py-3 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors">
                                    <svg class="w-5 h-5 mr-3" viewBox="0 0 24 24">
                                        <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                                        <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                                        <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                                        <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                                    </svg>
                                    Đăng nhập với Google
                                </button>
                                <button class="w-full flex items-center justify-center px-4 py-3 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors">
                                    <svg class="w-5 h-5 mr-3" fill="#1877F2" viewBox="0 0 24 24">
                                        <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
                                    </svg>
                                    Đăng nhập với Facebook
                                </button>
                            </div>
                        </div>
        </div>
      </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
    <div id="notification" class="notification"></div>

    <script src="<c:url value='/js/app.js'/>"></script>
    <script src="<c:url value='/js/utils/prefill-handler.js'/>"></script>
    <script src="<c:url value='/js/login.js'/>"></script>
  </body>
</html>
