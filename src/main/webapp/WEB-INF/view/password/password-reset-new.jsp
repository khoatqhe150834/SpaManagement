<%-- 
    Document   : reset-password
    Created on : Jun 2, 2025, 10:25:49 AM
    Author     : quang
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đặt Lại Mật Khẩu - Spa Hương Sen</title>

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
    <style>
      /* Custom focus ring for invalid email input */
      .border-red-500.focus\:ring-primary:focus {
        --tw-ring-color: theme('colors.red.500');
      }
    </style>
    </head>

<body class="bg-spa-cream">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />

    <main class="min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
        <div class="max-w-md w-full space-y-8">
            <!-- Header -->
            <div class="text-center">
                <h1 class="text-4xl font-serif text-spa-dark mb-2">
                    Quên mật khẩu?
                </h1>
                <p class="text-gray-600">
                    Nhập email của bạn để nhận hướng dẫn đặt lại mật khẩu.
                </p>
            </div>

            <!-- Main Content Area -->
            <div id="reset-container" class="bg-white rounded-lg shadow-lg p-8">
                <!-- Form View -->
                <div id="reset-form-view">
                    <form id="forgotPasswordForm" class="space-y-6" action="#" method="POST" novalidate
                        data-reset-url="<c:url value='/password-reset/request'/>"
                        data-validate-email-url="<c:url value='/password-reset/new?ajax=checkEmail'/>">
                        <div id="form-error-container" class="bg-red-50 border border-red-200 text-red-600 rounded-lg p-3 hidden">
                            <p id="form-error-message"></p>
                        </div>

                        <!-- Email Field -->
                        <div>
                            <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
                                Email đã đăng ký
                            </label>
                            <div class="relative">
                                <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                                    <i data-lucide="mail" class="h-5 w-5 text-gray-400"></i>
                                </span>
                                <input id="email" name="email" type="email" required
                                    class="block w-full pl-10 pr-3 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary transition-colors"
                                    placeholder="your.email@example.com"
                                    autocomplete="email">
                                <div class="absolute inset-y-0 right-0 flex items-center pr-3 transition-opacity duration-200 opacity-0" id="email-validation-icon">
                                    <i data-lucide="check-circle" class="h-5 w-5 text-green-500 hidden" id="email-valid-icon"></i>
                                    <i data-lucide="x-circle" class="h-5 w-5 text-red-500 hidden" id="email-invalid-icon"></i>
                                </div>
                            </div>
                            <p id="email-error" class="mt-1 text-sm text-red-600 hidden"></p>
                            <p id="email-success" class="mt-1 text-sm text-green-600 hidden"></p>
                        </div>

                        <!-- Submit Button -->
                        <button type="submit" id="submit-button"
                            class="w-full flex justify-center items-center py-3 px-4 border border-transparent rounded-lg shadow-sm text-white bg-primary hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary transition-all duration-300 font-semibold disabled:bg-gray-400 disabled:cursor-not-allowed">
                            <span id="button-text">Gửi email đặt lại</span>
                            <div id="loading-spinner" class="animate-spin rounded-full h-5 w-5 border-b-2 border-white ml-2 hidden"></div>
                        </button>
                    </form>
                    <div class="mt-6 text-center">
                        <a href="<c:url value='/login'/>" class="inline-flex items-center text-primary hover:text-primary-dark font-semibold transition-colors">
                            <i data-lucide="arrow-left" class="mr-2 h-4 w-4"></i>
                            Quay lại đăng nhập
                        </a>
                    </div>
                </div>

                <!-- Success View -->
                <div id="success-view" class="text-center hidden">
                    <i data-lucide="check-circle" class="h-16 w-16 text-green-500 mx-auto mb-6"></i>
                    <h2 class="text-2xl font-serif text-spa-dark mb-4">
                        Email đã được gửi!
                    </h2>
                    <p class="text-gray-600 mb-6">
                        Chúng tôi đã gửi hướng dẫn đặt lại mật khẩu tới <strong id="sent-email-address" class="text-spa-dark"></strong>. Vui lòng kiểm tra hộp thư của bạn.
                    </p>
                    <p class="text-sm text-gray-500 mb-8">
                        Link đặt lại mật khẩu sẽ hết hạn sau 15 phút.
                    </p>
                    <div class="space-y-4">
                         <!-- Countdown Section -->
                        <div id="countdown-section" style="display: none;">
                            <button id="resend-button-countdown" disabled
                                class="w-full py-3 px-4 border rounded-lg font-semibold bg-gray-100 text-gray-500 cursor-wait">
                                Gửi lại sau (<span id="countdown-timer">60</span>s)
                            </button>
                        </div>

                        <!-- Resend Section -->
                        <div id="resend-section">
                             <button id="resend-button"
                                class="w-full py-3 px-4 border border-primary text-primary rounded-lg hover:bg-primary hover:text-white transition-all duration-300 font-semibold disabled:bg-gray-200 disabled:text-gray-500 disabled:cursor-wait">
                                Gửi lại email
                            </button>
                        </div>
                        <a href="<c:url value='/login'/>" class="w-full flex justify-center items-center py-3 px-4 bg-primary text-white rounded-lg hover:bg-primary-dark transition-all duration-300 font-semibold">
                             <i data-lucide="arrow-left" class="mr-2 h-5 w-5"></i>
                            Quay lại đăng nhập
                        </a>
                    </div>
                </div>
            </div>

            <!-- Help Section -->
           
    </main>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />

    <script src="<c:url value='/js/countdown-manager.js'/>"></script>
    <script src="<c:url value='/js/reset-password.js'/>"></script>
    <script>
        // Initialize Lucide icons
        lucide.createIcons();
    </script>
</body>
</html>
