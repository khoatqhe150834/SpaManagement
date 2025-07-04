<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dịch vụ - Spa Hương Sen</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
</head>
<body class="bg-gray-50">
    <!-- Include header -->
    <jsp:include page="../common/header.jsp"/>
    
    <div class="container mx-auto px-4 py-8">
        <div class="flex justify-between items-center mb-8">
            <h1 class="text-3xl font-bold text-gray-900">Dịch vụ spa</h1>
            <button onclick="showWishlist()" class="flex items-center px-4 py-2 bg-[#D4AF37] text-white rounded-lg hover:bg-[#B8941F] transition-colors">
                <i data-lucide="heart" class="h-5 w-5 mr-2"></i>
                Danh sách yêu thích
            </button>
        </div>
        
        <!-- Service Cards Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <!-- Service Card 1 -->
            <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow">
                <div class="relative">
                    <img src="${pageContext.request.contextPath}/assets/home/images/our-services/massage.jpg" 
                         alt="Massage thư giãn" 
                         class="w-full h-48 object-cover">
                    <!-- Wishlist Button -->
                    <button class="wishlist-btn absolute top-3 right-3 p-2 rounded-full transition-all duration-300 bg-gray-100 text-gray-500 hover:bg-red-100 hover:text-red-500"
                            data-service-id="1"
                            data-service-name="Massage thư giãn"
                            data-service-image="${pageContext.request.contextPath}/assets/home/images/our-services/massage.jpg"
                            data-service-price="500000"
                            data-service-rating="4.8"
                            title="Thêm vào yêu thích">
                        <i data-lucide="heart" class="h-5 w-5"></i>
                    </button>
                </div>
                <div class="p-4">
                    <h3 class="text-lg font-semibold text-gray-900 mb-2">Massage thư giãn</h3>
                    <p class="text-gray-600 text-sm mb-3">Massage toàn thân giúp thư giãn và giảm stress</p>
                    <div class="flex items-center justify-between">
                        <span class="text-xl font-bold text-[#D4AF37]">500.000đ</span>
                        <div class="flex items-center">
                            <i data-lucide="star" class="h-4 w-4 text-yellow-400 fill-current"></i>
                            <span class="text-sm text-gray-600 ml-1">4.8</span>
                        </div>
                    </div>
                    <button class="w-full mt-4 px-4 py-2 bg-[#D4AF37] text-white rounded-lg hover:bg-[#B8941F] transition-colors">
                        Đặt lịch
                    </button>
                </div>
            </div>
            
            <!-- Service Card 2 -->
            <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow">
                <div class="relative">
                    <img src="${pageContext.request.contextPath}/assets/home/images/our-services/facial.jpg" 
                         alt="Chăm sóc da mặt" 
                         class="w-full h-48 object-cover">
                    <!-- Wishlist Button -->
                    <button class="wishlist-btn absolute top-3 right-3 p-2 rounded-full transition-all duration-300 bg-gray-100 text-gray-500 hover:bg-red-100 hover:text-red-500"
                            data-service-id="2"
                            data-service-name="Chăm sóc da mặt"
                            data-service-image="${pageContext.request.contextPath}/assets/home/images/our-services/facial.jpg"
                            data-service-price="300000"
                            data-service-rating="4.9"
                            title="Thêm vào yêu thích">
                        <i data-lucide="heart" class="h-5 w-5"></i>
                    </button>
                </div>
                <div class="p-4">
                    <h3 class="text-lg font-semibold text-gray-900 mb-2">Chăm sóc da mặt</h3>
                    <p class="text-gray-600 text-sm mb-3">Dịch vụ chăm sóc da mặt chuyên nghiệp</p>
                    <div class="flex items-center justify-between">
                        <span class="text-xl font-bold text-[#D4AF37]">300.000đ</span>
                        <div class="flex items-center">
                            <i data-lucide="star" class="h-4 w-4 text-yellow-400 fill-current"></i>
                            <span class="text-sm text-gray-600 ml-1">4.9</span>
                        </div>
                    </div>
                    <button class="w-full mt-4 px-4 py-2 bg-[#D4AF37] text-white rounded-lg hover:bg-[#B8941F] transition-colors">
                        Đặt lịch
                    </button>
                </div>
            </div>
            
            <!-- Service Card 3 -->
            <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow">
                <div class="relative">
                    <img src="${pageContext.request.contextPath}/assets/home/images/our-services/body-treatment.jpg" 
                         alt="Chăm sóc body" 
                         class="w-full h-48 object-cover">
                    <!-- Wishlist Button -->
                    <button class="wishlist-btn absolute top-3 right-3 p-2 rounded-full transition-all duration-300 bg-gray-100 text-gray-500 hover:bg-red-100 hover:text-red-500"
                            data-service-id="3"
                            data-service-name="Chăm sóc body"
                            data-service-image="${pageContext.request.contextPath}/assets/home/images/our-services/body-treatment.jpg"
                            data-service-price="400000"
                            data-service-rating="4.7"
                            title="Thêm vào yêu thích">
                        <i data-lucide="heart" class="h-5 w-5"></i>
                    </button>
                </div>
                <div class="p-4">
                    <h3 class="text-lg font-semibold text-gray-900 mb-2">Chăm sóc body</h3>
                    <p class="text-gray-600 text-sm mb-3">Dịch vụ chăm sóc toàn thân chuyên nghiệp</p>
                    <div class="flex items-center justify-between">
                        <span class="text-xl font-bold text-[#D4AF37]">400.000đ</span>
                        <div class="flex items-center">
                            <i data-lucide="star" class="h-4 w-4 text-yellow-400 fill-current"></i>
                            <span class="text-sm text-gray-600 ml-1">4.7</span>
                        </div>
                    </div>
                    <button class="w-full mt-4 px-4 py-2 bg-[#D4AF37] text-white rounded-lg hover:bg-[#B8941F] transition-colors">
                        Đặt lịch
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Include Wishlist Modal -->
    <jsp:include page="wishlist.jsp"/>

    <!-- User data for JavaScript -->
    <c:if test="${not empty userId}">
        <div id="userData" data-user-id="${userId}" data-user-type="${userType}" style="display: none;"></div>
    </c:if>

    <!-- Include footer -->
    <jsp:include page="../common/footer.jsp"/>

    <!-- Include the wishlist JavaScript -->
    <script src="${pageContext.request.contextPath}/js/wishlist.js"></script>
    
    <!-- Initialize Lucide icons -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            lucide.createIcons();
        });
    </script>
</body>
</html> 