<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="context-path" content="${pageContext.request.contextPath}" />
    <title>Dịch vụ đã xem - Spa Hương Sen</title>
    
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
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet"/>
    
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
</head>
<body class="bg-spa-cream">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    
    <main class="pt-20 min-h-screen">
        <!-- Page Header -->
        <section class="bg-gradient-to-r from-primary to-primary-dark text-white py-16">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
                <h1 class="text-4xl md:text-5xl font-serif font-bold mb-4">Dịch Vụ Đã Xem Gần Đây</h1>
                <p class="text-xl opacity-90 max-w-2xl mx-auto">Danh sách các dịch vụ bạn đã quan tâm, được sắp xếp theo thứ tự xem gần nhất.</p>
            </div>
        </section>
        
        <!-- Services Grid Section -->
        <section class="py-12">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <!-- Loading State -->
                <div id="loading-indicator" class="text-center py-12">
                    <div class="flex justify-center items-center">
                        <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
                        <p class="text-gray-600 ml-3">Đang tải dịch vụ...</p>
                    </div>
                </div>

                <!-- Services Grid -->
                <div id="recently-viewed-full-grid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8" style="display: none;">
                    <!-- Services will be dynamically loaded here -->
                </div>

                <!-- No Results State -->
                <div id="no-results" class="text-center py-12" style="display: none;">
                    <i data-lucide="history" class="h-16 w-16 mx-auto mb-4 text-gray-400"></i>
                    <p class="text-gray-600 text-lg">Bạn chưa xem dịch vụ nào gần đây.</p>
                    <a href="<c:url value='/services'/>" class="mt-4 inline-block px-6 py-3 bg-primary text-white rounded-full hover:bg-primary-dark transition-colors">
                        Khám phá dịch vụ
                    </a>
                </div>
            </div>
        </section>
    </main>
    
    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
    
    <div id="notification" class="notification"></div>
    
    <!-- JavaScript -->
    <script src="<c:url value='/js/app.js'/>"></script>
    <script src="<c:url value='/js/cart.js'/>"></script>
    <script src="<c:url value='/js/recently-viewed.js'/>"></script>
</body>
</html> 