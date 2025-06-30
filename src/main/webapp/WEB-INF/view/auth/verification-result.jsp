<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Kết quả xác thực - Spa Hương Sen</title>

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

        <div class="min-h-screen pt-20 pb-12 px-4 sm:px-6 lg:px-8">
            <div class="flex items-center justify-center min-h-[calc(100vh-140px)]">
                <div class="w-full max-w-sm sm:max-w-lg md:max-w-2xl lg:max-w-4xl xl:max-w-5xl">
                    
                    <!-- Main Success Content -->
                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 lg:gap-8 lg:items-stretch">
                        
                        <!-- Left Column: Success Message (Mobile: full width, Desktop: 2 columns) -->
                        <div class="lg:col-span-2 flex">
                            <div class="bg-white rounded-xl shadow-lg p-6 sm:p-8 w-full flex flex-col">
                                <!-- Success Icon and Animation -->
                                <div class="text-center mb-8">
                                    <div class="bg-primary rounded-full w-16 h-16 sm:w-20 sm:h-20 lg:w-24 lg:h-24 flex items-center justify-center mx-auto">
                                        <i data-lucide="check" class="h-8 w-8 sm:h-10 sm:w-10 lg:h-12 lg:w-12 text-white"></i>
                                    </div>
                                </div>
                                
                                <!-- Title and Welcome Message -->
                                <div class="text-center mb-8">
                                    <h1 class="text-2xl sm:text-3xl lg:text-4xl font-serif text-spa-dark mb-4">
                                        Xác thực thành công!
                                    </h1>
                                    
                                    <p class="text-lg sm:text-xl text-gray-600 mb-2">
                                        Chào mừng <span id="userName" class="font-semibold text-primary">${email != null ? email : 'bạn'}</span>
                                    </p>
                                    <p class="text-base text-gray-500">
                                        đến với Spa Hương Sen
                                    </p>
                                </div>
                                
                                <!-- Next Steps -->
                                <div class="bg-spa-cream rounded-lg p-4 sm:p-6 mb-8 flex-grow">
                                    <h3 class="font-semibold text-spa-dark mb-4 text-center lg:text-left text-lg">
                                        Các bước tiếp theo:
                                    </h3>
                                    <div class="space-y-4">
                                        <div class="flex items-start">
                                            <div class="bg-primary rounded-full w-8 h-8 flex items-center justify-center text-white font-bold flex-shrink-0 mt-1">
                                                1
                                            </div>
                                            <div class="ml-4">
                                                <h4 class="font-medium text-spa-dark">Hoàn thiện hồ sơ</h4>
                                                <p class="text-sm text-gray-600">Cập nhật thông tin cá nhân để nhận ưu đãi phù hợp</p>
                                            </div>
                                        </div>
                                        <div class="flex items-start">
                                            <div class="bg-primary rounded-full w-8 h-8 flex items-center justify-center text-white font-bold flex-shrink-0 mt-1">
                                                2
                                            </div>
                                            <div class="ml-4">
                                                <h4 class="font-medium text-spa-dark">Khám phá dịch vụ</h4>
                                                <p class="text-sm text-gray-600">Tìm hiểu các dịch vụ spa cao cấp của chúng tôi</p>
                                            </div>
                                        </div>
                                        <div class="flex items-start">
                                            <div class="bg-primary rounded-full w-8 h-8 flex items-center justify-center text-white font-bold flex-shrink-0 mt-1">
                                                3
                                            </div>
                                            <div class="ml-4">
                                                <h4 class="font-medium text-spa-dark">Đặt lịch đầu tiên</h4>
                                                <p class="text-sm text-gray-600">Nhận ưu đãi 30% cho lần đặt lịch đầu tiên</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Action Buttons -->
                                <div class="space-y-3 sm:space-y-4 lg:flex lg:space-y-0 lg:space-x-4 mt-auto">
                                    <button onclick="navigateToHome()" class="w-full lg:flex-1 flex justify-center items-center py-3 px-4 bg-primary text-white rounded-lg hover:bg-primary-dark transition-all duration-300 font-semibold">
                                        <i data-lucide="home" class="mr-2 h-5 w-5"></i>
                                        Về trang chủ
                                    </button>
                                    
                                    <button onclick="navigateToLogin()" class="w-full lg:flex-1 flex justify-center items-center py-3 px-4 border-2 border-primary text-primary rounded-lg hover:bg-primary hover:text-white transition-all duration-300 font-semibold">
                                        <i data-lucide="log-in" class="mr-2 h-5 w-5"></i>
                                        Đăng nhập ngay
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Right Column: Offers and Social (Mobile: full width, Desktop: 1 column) -->
                        <div class="lg:col-span-1 flex">
                            <div class="space-y-6 w-full flex flex-col">
                            
                                <!-- Welcome Offer -->
                                <div class="bg-gradient-to-br from-primary via-primary to-primary-dark rounded-xl shadow-lg p-6 text-white">
                                    <div class="flex items-center justify-between mb-4">
                                        <h3 class="text-lg sm:text-xl font-semibold">Ưu đãi chào mừng</h3>
                                        <i data-lucide="gift" class="h-6 w-6 sm:h-8 sm:w-8"></i>
                                    </div>
                                    <p class="mb-4 text-sm sm:text-base">
                                        Nhận ngay <span class="font-bold text-lg sm:text-xl">30% giảm giá</span> cho lần đặt lịch đầu tiên!
                                    </p>
                                    <div class="bg-white/20 rounded-lg p-3 text-sm">
                                        <p class="font-semibold">Mã ưu đãi: <span class="font-bold">WELCOME30</span></p>
                                        <p class="text-xs mt-1 opacity-80">Có hiệu lực trong 30 ngày</p>
                                    </div>
                                </div>

                                <!-- Quick Actions -->
                                <div class="bg-white rounded-xl shadow-lg p-6 flex-grow">
                                    <h3 class="text-lg font-semibold text-spa-dark mb-4 text-center">
                                        Hành động nhanh
                                    </h3>
                                    <div class="space-y-3">
                                        <button onclick="navigateToServices()" class="w-full flex items-center justify-center py-2.5 px-4 bg-secondary text-spa-dark rounded-lg hover:bg-primary hover:text-white transition-all duration-300 font-medium text-sm">
                                            <i data-lucide="sparkles" class="mr-2 h-4 w-4"></i>
                                            Xem dịch vụ
                                        </button>
                                        <button onclick="navigateToProfile()" class="w-full flex items-center justify-center py-2.5 px-4 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-all duration-300 font-medium text-sm">
                                            <i data-lucide="user" class="mr-2 h-4 w-4"></i>
                                            Cập nhật hồ sơ
                                        </button>
                                    </div>
                                </div>

                                <!-- Social Sharing -->
                                <div class="bg-white rounded-xl shadow-lg p-6">
                                    <h3 class="text-lg font-semibold text-spa-dark mb-3 text-center">
                                        Chia sẻ với bạn bè
                                    </h3>
                                    <p class="text-sm text-gray-600 mb-4 text-center">
                                        Giới thiệu bạn bè và cả hai cùng nhận ưu đãi 15%
                                    </p>
                                    <div class="flex justify-center space-x-3">
                                        <button class="p-2.5 bg-[#3b5998] text-white rounded-full hover:opacity-90 transition-opacity">
                                            <i data-lucide="facebook" class="h-4 w-4"></i>
                                        </button>
                                        <button class="p-2.5 bg-[#25D366] text-white rounded-full hover:opacity-90 transition-opacity">
                                            <i data-lucide="message-circle" class="h-4 w-4"></i>
                                        </button>
                                        <button class="p-2.5 bg-[#0088cc] text-white rounded-full hover:opacity-90 transition-opacity">
                                            <i data-lucide="send" class="h-4 w-4"></i>
                                        </button>
                                        <button class="p-2.5 bg-[#c13584] text-white rounded-full hover:opacity-90 transition-opacity">
                                            <i data-lucide="instagram" class="h-4 w-4"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/view/common/footer.jsp" />

        <script>
            // Pass JSP variables to the global window object for external scripts
            window.spaConfig = {
                contextPath: '${pageContext.request.contextPath}',
                email: '${email}',
                password: '${sessionScope.verificationLoginPassword}'
            };
        </script>
        <script src="<c:url value='/js/verification-result.js'/>"></script>
    </body>
</html> 