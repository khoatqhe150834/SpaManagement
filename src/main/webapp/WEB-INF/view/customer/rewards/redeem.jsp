<%-- 
    Document   : redeem.jsp
    Created on : Redeem Rewards
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi điểm lấy mã giảm giá - BeautyZone Spa</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-spa-cream font-sans">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        <main class="flex-1 py-12 lg:py-20 ml-64">
            <div class="max-w-xl mx-auto bg-white rounded-2xl shadow-lg p-8">
                <h1 class="text-2xl font-serif font-bold text-spa-dark mb-6">Đổi điểm lấy mã giảm giá</h1>
                <c:if test="${not empty message}">
                    <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-4 rounded-lg">${message}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-4 rounded-lg">${error}</div>
                </c:if>
                <form method="post" class="space-y-6">
                    <div>
                        <label class="block text-gray-700 font-medium mb-2">Số điểm muốn đổi <span class="text-red-500">*</span></label>
                        <input type="number" name="pointsToUse" min="1" required class="w-full h-12 px-4 border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary" placeholder="Nhập số điểm muốn đổi">
                    </div>
                    <div>
                        <label class="block text-gray-700 font-medium mb-2">Mã giảm giá muốn nhận <span class="text-red-500">*</span></label>
                        <input type="text" name="rewardValue" required class="w-full h-12 px-4 border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary" placeholder="Nhập mã giảm giá hoặc chọn từ danh sách">
                        <input type="hidden" name="rewardType" value="DISCOUNT_CODE" />
                    </div>
                    <div>
                        <label class="block text-gray-700 font-medium mb-2">Ghi chú (tuỳ chọn)</label>
                        <textarea name="note" rows="2" class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary" placeholder="Ghi chú thêm nếu có..."></textarea>
                    </div>
                    <button type="submit" class="w-full h-12 bg-primary text-white rounded-lg font-semibold hover:bg-primary-dark transition-colors">Đổi điểm ngay</button>
                </form>
                <div class="mt-6 text-center">
                    <a href="${pageContext.request.contextPath}/redeem/history" class="text-primary hover:underline">Xem lịch sử đổi điểm</a>
                </div>
            </div>
        </main>
    </div>
</body>
</html> 