<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách yêu thích - Spa Hương Sen</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
    <style>
        .wishlist-modal {
            display: none;
        }
        .wishlist-modal.active {
            display: flex;
        }
        .notification {
            position: fixed;
            top: 1rem;
            right: 1rem;
            z-index: 60;
            padding: 1rem;
            border-radius: 0.5rem;
            color: white;
            font-weight: 500;
            transform: translateX(100%);
            transition: transform 0.3s ease;
        }
        .notification.show {
            transform: translateX(0);
        }
        .notification.success {
            background-color: #10B981;
        }
        .notification.error {
            background-color: #EF4444;
        }
        .loading-spinner {
            border: 2px solid #f3f3f3;
            border-top: 2px solid #D4AF37;
            border-radius: 50%;
            width: 3rem;
            height: 3rem;
            animation: spin 1s linear infinite;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <!-- Wishlist Modal -->
    <div id="wishlistModal" class="wishlist-modal fixed inset-0 bg-black bg-opacity-50 z-50 items-center justify-center p-4">
        <div class="bg-white rounded-lg max-w-4xl w-full max-h-[90vh] overflow-hidden">
            <!-- Header -->
            <div class="flex items-center justify-between p-6 border-b">
                <div class="flex items-center">
                    <i data-lucide="heart" class="h-6 w-6 text-[#D4AF37] mr-2"></i>
                    <h2 class="text-2xl font-serif text-[#333333]">
                        Danh sách yêu thích
                    </h2>
                    <span id="wishlistCount" class="ml-2 bg-[#D4AF37] text-white text-sm px-2 py-1 rounded-full">
                        0
                    </span>
                </div>
                <button id="closeWishlistBtn" class="text-gray-500 hover:text-gray-700 transition-colors">
                    <i data-lucide="x" class="h-6 w-6"></i>
                </button>
            </div>

            <!-- Content -->
            <div class="p-6 overflow-y-auto max-h-[calc(90vh-120px)]">
                <!-- Not authenticated state -->
                <div id="notAuthenticatedState" class="text-center py-12 hidden">
                    <i data-lucide="heart" class="h-16 w-16 text-gray-300 mx-auto mb-4"></i>
                    <h3 class="text-lg font-medium text-gray-900 mb-2">
                        Đăng nhập để xem danh sách yêu thích
                    </h3>
                    <p class="text-gray-500 mb-6">
                        Đăng nhập để lưu và quản lý các dịch vụ yêu thích của bạn
                    </p>
                    <button onclick="window.location.href='${pageContext.request.contextPath}/login'" 
                            class="px-6 py-3 bg-[#D4AF37] text-white rounded-lg hover:bg-[#B8941F] transition-colors font-semibold">
                        Đăng nhập
                    </button>
                </div>

                <!-- Loading state -->
                <div id="loadingState" class="text-center py-12 hidden">
                    <div class="loading-spinner mx-auto mb-4"></div>
                    <p class="text-gray-600">Đang tải...</p>
                </div>

                <!-- Empty state -->
                <div id="emptyState" class="text-center py-12 hidden">
                    <i data-lucide="heart" class="h-16 w-16 text-gray-300 mx-auto mb-4"></i>
                    <h3 class="text-lg font-medium text-gray-900 mb-2">
                        Danh sách yêu thích trống
                    </h3>
                    <p class="text-gray-500 mb-6">
                        Thêm các dịch vụ yêu thích để dễ dàng đặt lịch sau này
                    </p>
                    <button id="exploreServicesBtn" class="px-6 py-3 bg-[#D4AF37] text-white rounded-lg hover:bg-[#B8941F] transition-colors font-semibold">
                        Khám phá dịch vụ
                    </button>
                </div>

                <!-- Wishlist items -->
                <div id="wishlistItems" class="grid grid-cols-1 md:grid-cols-2 gap-6 hidden">
                    <!-- Items will be populated by JavaScript -->
                </div>
            </div>

            <!-- Footer -->
            <div id="wishlistFooter" class="border-t p-6 hidden">
                <div class="flex items-center justify-between">
                    <span id="totalItemsText" class="text-gray-600">
                        Tổng 0 dịch vụ yêu thích
                    </span>
                    <div class="flex space-x-3">
                        <button id="closeFooterBtn" class="px-6 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">
                            Đóng
                        </button>
                        <button id="addAllToCartBtn" class="px-6 py-2 bg-[#D4AF37] text-white rounded-lg hover:bg-[#B8941F] transition-colors font-semibold">
                            Thêm tất cả vào giỏ
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Wishlist Button Template (for service cards) -->
    <template id="wishlistButtonTemplate">
        <button class="wishlist-btn p-2 rounded-full transition-all duration-300 bg-gray-100 text-gray-500 hover:bg-red-100 hover:text-red-500" 
                title="Thêm vào yêu thích">
            <i data-lucide="heart" class="h-5 w-5"></i>
        </button>
    </template>

    <!-- Wishlist Item Template -->
    <template id="wishlistItemTemplate">
        <div class="wishlist-item bg-white border border-gray-200 rounded-lg overflow-hidden hover:shadow-lg transition-shadow">
            <div class="relative">
                <img class="service-image w-full h-48 object-cover" src="" alt="">
                <button class="remove-btn absolute top-3 right-3 bg-white bg-opacity-90 p-2 rounded-full hover:bg-opacity-100 transition-all">
                    <i data-lucide="x" class="h-4 w-4 text-gray-600"></i>
                </button>
            </div>

            <div class="p-4">
                <h3 class="service-name text-lg font-semibold text-[#333333] mb-2"></h3>

                <div class="flex items-center mb-3">
                    <div class="flex items-center mr-3">
                        <i data-lucide="star" class="h-4 w-4 text-[#D4AF37] fill-current mr-1"></i>
                        <span class="service-rating text-sm font-medium"></span>
                    </div>
                    <span class="added-date text-sm text-gray-500"></span>
                </div>

                <div class="flex items-center justify-between">
                    <span class="service-price text-xl font-bold text-[#D4AF37]"></span>
                    <div class="flex space-x-2">
                        <button class="view-details-btn p-2 text-gray-500 hover:text-[#D4AF37] transition-colors" title="Xem chi tiết">
                            <i data-lucide="eye" class="h-4 w-4"></i>
                        </button>
                        <button class="add-to-cart-btn flex items-center px-4 py-2 bg-[#D4AF37] text-white rounded-lg hover:bg-[#B8941F] transition-colors text-sm font-medium">
                            <i data-lucide="shopping-cart" class="h-4 w-4 mr-1"></i>
                            Thêm vào giỏ
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </template>

    <!-- Notification Container -->
    <div id="notificationContainer"></div>

    <!-- User data for JavaScript -->
    <c:if test="${not empty userId}">
        <div id="userData" data-user-id="${userId}" data-user-type="${userType}" style="display: none;"></div>
    </c:if>
    
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