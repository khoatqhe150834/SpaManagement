<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4" id="cartModal" style="display: none;">
    <div class="bg-white rounded-lg max-w-2xl w-full h-[90vh] flex flex-col overflow-hidden">
        <!-- Header -->
        <div class="flex items-center justify-between p-6 border-b flex-shrink-0">
            <div class="flex items-center">
                <i data-lucide="shopping-cart" class="h-6 w-6 text-[#D4AF37] mr-2"></i>
                <h2 class="text-2xl font-serif text-[#333333]">
                    Giỏ hàng
                </h2>
                <span class="ml-2 bg-[#D4AF37] text-white text-sm px-2 py-1 rounded-full" id="cartItemCount">
                    0
                </span>
            </div>
            <button onclick="closeCart()" class="text-gray-500 hover:text-gray-700 transition-colors">
                <i data-lucide="x" class="h-6 w-6"></i>
            </button>
        </div>

        <!-- Content - Scrollable -->
        <div class="flex-1 overflow-y-auto" id="cartContent">
            <div id="loadingIndicator" class="text-center py-12" style="display: none;">
                <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-[#D4AF37] mx-auto mb-4"></div>
                <p class="text-gray-600">Đang tải...</p>
            </div>

            <div id="emptyCartMessage" class="text-center py-12 px-6">
                <i data-lucide="shopping-cart" class="h-16 w-16 text-gray-300 mx-auto mb-4"></i>
                <h3 class="text-lg font-medium text-gray-900 mb-2">
                    Giỏ hàng trống
                </h3>
                <p class="text-gray-500 mb-6">
                    Thêm dịch vụ vào giỏ hàng để đặt lịch
                </p>
                <a href="${pageContext.request.contextPath}/services" onclick="closeCart()" class="inline-block px-6 py-3 bg-[#D4AF37] text-white rounded-lg hover:bg-[#B8941F] transition-colors font-semibold">
                    Khám phá dịch vụ
                </a>
            </div>

            <div id="cartItems" class="p-6 space-y-4">
                <!-- Cart items will be dynamically inserted here -->
            </div>
        </div>

        <!-- Footer - Fixed at bottom -->
        <div id="cartFooter" class="border-t p-6 flex-shrink-0 bg-white" style="display: none;">
            <div class="space-y-4">
                <!-- Summary -->
                <div class="bg-[#FFF8F0] rounded-lg p-4">
                    <div class="flex justify-between items-center mb-2">
                        <span class="text-gray-600">Tổng thời gian:</span>
                        <span class="font-medium" id="totalDuration">0 phút</span>
                    </div>
                    <div class="flex justify-between items-center mb-2">
                        <span class="text-gray-600">Số lượng dịch vụ:</span>
                        <span class="font-medium" id="totalItems">0</span>
                    </div>
                    <div class="flex justify-between items-center text-lg font-bold">
                        <span>Tổng cộng:</span>
                        <span class="text-[#D4AF37]" id="totalPrice">0đ</span>
                    </div>
                </div>

                <!-- Actions -->
                <div class="flex space-x-3">
                    <button onclick="clearCart()" class="flex-1 px-4 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">
                        Xóa tất cả
                    </button>
                    <button onclick="window.location.href='${pageContext.request.contextPath}/booking-checkout'" class="flex-2 flex items-center justify-center px-6 py-3 bg-[#D4AF37] text-white rounded-lg hover:bg-[#B8941F] transition-colors font-semibold">
                        <i data-lucide="credit-card" class="h-5 w-5 mr-2"></i>
                        Thanh toán
                    </button>
                </div>

                <!-- Guest user notice -->
                <c:if test="${empty sessionScope.user}">
                    <div class="bg-blue-50 border border-blue-200 rounded-lg p-4">
                        <p class="text-blue-800 text-sm">
                            💡 <strong>Mẹo:</strong> Đăng nhập để lưu giỏ hàng và nhận ưu đãi thành viên
                        </p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>