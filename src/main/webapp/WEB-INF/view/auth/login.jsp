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
          <form id="login-form" 
                class="space-y-6" 
                action="<c:url value='/login'/>" 
                method="POST" 
                novalidate
                data-remembered-email="<c:out value='${rememberedEmail}'/>"
                data-remembered-password="<c:out value='${rememberedPassword}'/>"
                data-remember-me-checked="${rememberMeChecked}">
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
