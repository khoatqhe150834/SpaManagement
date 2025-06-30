<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Xác thực email - Spa Hương Sen</title>

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

        <div class="min-h-screen flex items-center justify-center pt-32 pb-12 px-4 sm:px-6 lg:px-8">
            <div class="max-w-md w-full space-y-8">
                <!-- Header -->
                <div class="text-center">
                    <h1 class="text-4xl font-serif text-spa-dark mb-2">
                        Xác thực email
                    </h1>
                    <p class="text-gray-600">
                        Vui lòng xác thực email để hoàn tất đăng ký
                    </p>
                                </div>

                <!-- Email Sent Message -->
                <div class="bg-white rounded-lg shadow-lg p-8 text-center">
                    <div class="bg-yellow-50 rounded-full w-20 h-20 flex items-center justify-center mx-auto mb-6">
                        <i data-lucide="mail" class="h-10 w-10 text-primary"></i>
                                        </div>
                    
                    <h2 class="text-2xl font-serif text-spa-dark mb-4">
                        Đăng ký thành công!
                    </h2>
                    
                    <p class="text-gray-600 mb-6">
                        Chúng tôi đã gửi email xác thực đến <span id="userEmail" class="font-semibold text-primary">${email}</span>
                    </p>
                    
                    <div class="bg-spa-cream rounded-lg p-4 mb-6 text-left">
                        <h3 class="font-semibold text-spa-dark mb-2 flex items-center">
                            <i data-lucide="info" class="h-5 w-5 mr-2 text-primary"></i>
                            Hướng dẫn
                        </h3>
                        <ol class="space-y-2 text-sm text-gray-600 list-decimal list-inside">
                            <li>Kiểm tra hộp thư đến của bạn</li>
                            <li>Tìm email có tiêu đề "Xác thực tài khoản - Spa Hương Sen"</li>
                            <li>Kiểm tra cả thư mục spam nếu không thấy trong hộp thư đến</li>
                            <li>Nhấp vào nút "Xác thực tài khoản" trong email</li>
                        </ol>
                                    </div>
                                    
                    <div class="mb-6">
                        <p class="text-gray-600 mb-2">Chưa nhận được email?</p>
                        
                        <!-- Countdown Section -->
                        <div id="countdownSection" class="text-sm text-gray-500 mb-2">
                            Có thể gửi lại sau: <span id="countdownTimer">60</span> giây
                                        </div>
                                        
                        <!-- Resend Section -->
                        <div id="resendSection" style="display: none;">
                            <button id="resendEmailBtn" class="px-4 py-2 border border-primary text-primary rounded-lg hover:bg-primary hover:text-white transition-all duration-300 font-medium disabled:opacity-50 disabled:cursor-not-allowed">
                                Gửi lại email
                            </button>
                                                </div>
                                            </div>
                                            
                    <button onclick="navigateTo('login')" class="w-full flex justify-center items-center py-3 px-4 bg-primary text-white rounded-lg hover:bg-primary-dark transition-all duration-300 font-semibold">
                        <i data-lucide="arrow-left" class="mr-2 h-5 w-5"></i>
                        Quay lại đăng nhập
                                                </button>
                                            </div>
                                            
                <!-- Help Section -->
                <div class="bg-white rounded-lg shadow-lg p-6">
                    <h3 class="text-lg font-semibold text-spa-dark mb-4 flex items-center">
                        <i data-lucide="help-circle" class="h-5 w-5 mr-2 text-primary"></i>
                        Cần hỗ trợ?
                    </h3>
                    <p class="text-gray-600 mb-4">
                        Nếu bạn gặp vấn đề trong quá trình xác thực email, vui lòng liên hệ với chúng tôi qua:
                    </p>
                    <div class="flex items-center justify-between">
                        <a href="tel:0901234567" class="flex items-center text-primary hover:text-primary-dark transition-colors">
                            <i data-lucide="phone" class="h-4 w-4 mr-2"></i>
                            0901 234 567
                        </a>
                        <a href="mailto:support@spahuongsen.vn" class="flex items-center text-primary hover:text-primary-dark transition-colors">
                            <i data-lucide="mail" class="h-4 w-4 mr-2"></i>
                            support@spahuongsen.vn
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/view/common/footer.jsp" />
        
        <script>
            window.spaConfig = {
                contextPath: '${pageContext.request.contextPath}',
                email: '${email}'
            };
        </script>
        <script src="<c:url value='/js/countdown-manager.js'/>"></script>
        <script src="<c:url value='/js/email-verification-required.js'/>"></script>
    </body>
</html> 