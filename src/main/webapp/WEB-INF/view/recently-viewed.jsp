<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="context-path" content="${pageContext.request.contextPath}" />
    <title>Dịch vụ đã xem - Spa Hương Sen</title>
    
    <!-- Tailwind CSS, Google Fonts, Lucide Icons -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              primary: "#D4AF37", "primary-dark": "#B8941F",
              secondary: "#FADADD", "spa-cream": "#FFF8F0", "spa-dark": "#333333",
            },
            fontFamily: {
              serif: ["Playfair Display", "serif"],
              sans: ["Roboto", "sans-serif"],
            },
          },
        },
      };
    </script>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet"/>
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
</head>
<body class="bg-spa-cream">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    
    <main class="pt-20 min-h-screen">
        <!-- Page Header -->
        <section class="bg-gradient-to-r from-primary to-primary-dark text-white py-16">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
                <h1 class="text-4xl md:text-5xl font-serif font-bold mb-4">Dịch Vụ Đã Xem Gần Đây</h1>
                <p class="text-xl opacity-90 max-w-2xl mx-auto">Các dịch vụ bạn đã quan tâm, được sắp xếp theo thứ tự xem gần nhất.</p>
            </div>
        </section>

        <!-- Search and Filter Section -->
        <section class="bg-white py-8 border-b border-gray-200">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex flex-col md:flex-row gap-4 items-center justify-between">
                    <div class="relative flex-1 max-w-md">
                        <input type="text" id="search-input" placeholder="Tìm trong các mục đã xem..." class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-full focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"/>
                        <i data-lucide="search" class="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400"></i>
                    </div>
                    <div class="text-gray-600">
                        <span id="results-count">Hiển thị 0 kết quả</span>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- Services Content -->
        <section class="py-12">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <!-- Loading Indicator -->
                <div id="loading-indicator" class="text-center py-12">
                    <div class="flex justify-center items-center"><div class="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div><p class="text-gray-600 ml-3">Đang tải dịch vụ...</p></div>
                </div>

                <div id="content-wrapper" class="hidden">
                    <div class="flex gap-8">
                        <!-- Filters Sidebar -->
                        <aside id="filters-sidebar" class="hidden md:block w-64 flex-shrink-0">
                            <div class="bg-white rounded-lg p-6 shadow-lg sticky top-24">
                                <div class="flex items-center justify-between mb-6">
                                    <h3 class="text-lg font-semibold text-spa-dark">Bộ lọc</h3>
                                    <button id="clear-filters" class="text-primary hover:text-primary-dark text-sm">Xóa tất cả</button>
                                </div>
                                <div class="mb-6">
                                    <h4 class="font-medium text-spa-dark mb-3">Loại dịch vụ</h4>
                                    <select id="service-type-select" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary text-sm"><option value="all">Tất cả</option></select>
                                </div>
                                <!-- Price range slider will be inserted here by JS -->
                            </div>
                        </aside>

                        <!-- Services Grid -->
                        <div class="flex-1">
                            <div class="flex justify-between items-center mb-6">
                                <h2 class="text-2xl font-serif font-bold text-spa-dark">Dịch vụ đã xem</h2>
                                <select id="sort-select" class="border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary">
                                    <option value="default">Sắp xếp mặc định</option>
                                    <option value="name-asc">Tên A-Z</option><option value="name-desc">Tên Z-A</option>
                                    <option value="price-asc">Giá thấp đến cao</option><option value="price-desc">Giá cao đến thấp</option>
                                    <option value="rating-desc">Đánh giá cao nhất</option>
                                </select>
                            </div>
                            <div id="services-grid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8"></div>
                            <div id="pagination" class="flex justify-center items-center space-x-2"></div>
                        </div>
                    </div>
                </div>
                
                <!-- No Results State -->
                <div id="no-results" class="text-center py-12 hidden">
                    <i data-lucide="history" class="h-16 w-16 mx-auto mb-4 text-gray-400"></i>
                    <p class="text-gray-600 text-lg">Bạn chưa xem dịch vụ nào.</p>
                    <a href="<c:url value='/services'/>" class="mt-4 inline-block px-6 py-3 bg-primary text-white rounded-full hover:bg-primary-dark transition-colors">Khám phá dịch vụ</a>
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