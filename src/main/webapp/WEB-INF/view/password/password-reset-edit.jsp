<%-- 
    Document   : change-password
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
    <title>Tạo Mật Khẩu Mới - Spa Hương Sen</title>

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

    <div class="min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
        <div class="max-w-md w-full space-y-8">
            <!-- Form Card -->
            <div class="bg-white rounded-lg shadow-lg p-8">
                <!-- Header -->
                <div class="text-center mb-8">
                    <i data-lucide="key-round" class="mx-auto h-12 w-12 text-primary"></i>
                    <h2 class="mt-6 text-4xl font-serif text-spa-dark">Tạo Mật Khẩu Mới</h2>
                    <p class="mt-2 text-gray-600">Mật khẩu mới của bạn phải an toàn và dễ nhớ.</p>
                </div>

                <!-- Session Expired Message -->
                <c:if test="${empty sessionScope.resetEmail}">
                    <div class="bg-red-50 border-l-4 border-red-400 p-4 mb-6 rounded-r-lg">
                        <div class="flex">
                            <div class="py-1"><i data-lucide="alert-triangle" class="h-6 w-6 text-red-500 mr-4"></i></div>
                            <div>
                                <p class="font-bold text-red-800">Phiên đã hết hạn</p>
                                <p class="text-sm text-red-700">Liên kết đặt lại mật khẩu đã hết hạn hoặc không hợp lệ. Vui lòng yêu cầu một liên kết mới.</p>
            </div>
                        </div>
                                    </div>
                    <a href="<c:url value='/reset-password'/>" class="btn btn-primary w-full flex justify-center items-center mt-4">
                        Yêu cầu liên kết mới
                    </a>
                            </c:if>
                            
                <!-- Change Password Form -->
                            <c:if test="${not empty sessionScope.resetEmail}">
                    <!-- User Info -->
                    <div class="bg-secondary/30 border border-primary/40 rounded-lg p-3 mb-6 text-center">
                        <p class="text-sm text-spa-dark">
                            Bạn đang đặt lại mật khẩu cho: <strong class="font-medium text-primary-dark">${sessionScope.resetEmail}</strong>
                        </p>
                                </div>
                                
                    <!-- General Error Message Area -->
                    <div id="form-error-message"
                         class="hidden bg-red-50 border border-red-200 rounded-lg p-3 mb-6">
                        <p class="text-sm text-red-600"></p>
                    </div>

                    <!-- Error Message -->
                                <c:if test="${not empty error}">
                        <div class="bg-red-50 border border-red-200 rounded-lg p-3 mb-6">
                            <p class="text-sm text-red-600">${error}</p>
                                    </div>
                                </c:if>
                                
                    <form id="reset-password-form" class="space-y-6" action="<c:url value='/password-reset/update'/>" method="POST" novalidate>
                        <!-- New Password Field -->
                        <div>
                            <label for="newPassword" class="block text-sm font-medium text-gray-700 mb-2">Mật khẩu mới *</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
                                    <i data-lucide="lock" class="h-5 w-5 text-gray-400"></i>
                                </div>
                                <input id="newPassword" name="newPassword" type="password" 
                                       class="form-input pl-11 pr-11" 
                                       placeholder="Nhập mật khẩu mới" 
                                       required minlength="6">
                                <button type="button" id="toggle-new-password" class="toggle-password absolute inset-y-0 right-0 flex items-center pr-3">
                                    <i data-lucide="eye" class="h-5 w-5 text-gray-400 hover:text-gray-600"></i>
                                </button>
                            </div>
                            <p class="mt-1 text-sm text-gray-500">Mật khẩu phải có ít nhất 6 ký tự.</p>
                            <p class="mt-1 text-sm text-red-600 hidden" id="newPasswordError"></p>
                        </div>
                                        
                        <!-- Confirm Password Field -->
                        <div>
                            <label for="confirmPassword" class="block text-sm font-medium text-gray-700 mb-2">Xác nhận mật khẩu *</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
                                    <i data-lucide="lock-keyhole" class="h-5 w-5 text-gray-400"></i>
                                </div>
                                <input id="confirmPassword" name="confirmPassword" type="password" 
                                       class="form-input pl-11 pr-11" 
                                       placeholder="Nhập lại mật khẩu mới" 
                                       required>
                                <button type="button" id="toggle-confirm-password" class="toggle-password absolute inset-y-0 right-0 flex items-center pr-3">
                                    <i data-lucide="eye" class="h-5 w-5 text-gray-400 hover:text-gray-600"></i>
                                </button>
                            </div>
                            <p class="mt-1 text-sm text-red-600 hidden" id="confirmPasswordError"></p>
                        </div>

                        <button type="submit" id="submit-btn" 
                                class="w-full flex justify-center py-3 px-4 border border-transparent rounded-full shadow-sm text-lg font-semibold text-white bg-primary hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-dark transition-all duration-300 transform hover:scale-105 disabled:opacity-50 disabled:cursor-not-allowed">
                            <span class="btn-text">Đặt Lại Mật Khẩu</span>
                            <span class="btn-spinner hidden animate-spin mr-3">
                                <i data-lucide="loader-2"></i>
                            </span>
                        </button>
                    </form>
                </c:if>

            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
    <div id="notification" class="notification"></div>
    
    <script src="<c:url value='/js/app.js'/>"></script>
    <script src="<c:url value='/js/reset-password-validation.js'/>"></script>
    <script>
        // Initialize Lucide icons
        lucide.createIcons();
    </script>
    </body>
</html>
