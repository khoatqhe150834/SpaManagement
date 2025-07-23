<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Cá Nhân</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <style>
        body { font-family: 'Roboto', sans-serif; background: #f8f6f2; }
    </style>
</head>
<body>
<div class="max-w-3xl mx-auto py-10 px-4">
    <div class="bg-white rounded-2xl shadow-lg overflow-hidden mb-8">
        <div class="bg-gradient-to-r from-yellow-400 to-yellow-600 p-8">
            <div class="flex flex-col md:flex-row items-center gap-6">
                <div class="relative">
                    <c:choose>
                        <c:when test="${not empty customer.avatarUrl}">
                            <img class="w-32 h-32 rounded-full object-cover border-4 border-white shadow-lg" 
                                 src="${customer.avatarUrl}" alt="${customer.fullName}">
                        </c:when>
                        <c:otherwise>
                            <div class="w-32 h-32 rounded-full bg-white flex items-center justify-center border-4 border-white shadow-lg">
                                <i data-lucide="user" class="w-16 h-16 text-gray-400"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="text-center md:text-left text-white flex-1">
                    <h1 class="text-3xl font-bold mb-2">${customer.fullName}</h1>
                    <div class="flex flex-wrap gap-3 justify-center md:justify-start mb-2">
                        <div class="flex items-center gap-2 bg-white/20 px-3 py-1 rounded-full">
                            <i data-lucide="gift" class="w-4 h-4"></i>
                            <span class="text-sm">${points} điểm</span>
                        </div>
                        <div class="flex items-center gap-2 bg-white/20 px-3 py-1 rounded-full">
                            <i data-lucide="star" class="w-4 h-4"></i>
                            <span class="text-sm">Hạng: <b>${tier}</b></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <c:if test="${not empty successMessage}">
        <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6 rounded-lg" role="alert">
            <p>${successMessage}</p>
        </div>
    </c:if>

    <div class="bg-white rounded-2xl shadow-lg p-8">
        <h2 class="text-xl font-bold text-gray-800 mb-6 flex items-center gap-2">
            <i data-lucide="user-circle" class="w-6 h-6 text-yellow-500"></i>
            Thông tin cá nhân
        </h2>
        <form class="space-y-6" method="post" action="${pageContext.request.contextPath}/customer/profile">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Họ tên</label>
                    <input type="text" name="fullName" value="${customer.fullName}" required class="w-full p-3 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-yellow-400" />
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Số điện thoại</label>
                    <input type="text" name="phone" value="${customer.phoneNumber}" class="w-full p-3 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-yellow-400" />
                </div>
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Email</label>
                    <input type="email" value="${customer.email}" readonly class="w-full p-3 border border-gray-200 rounded-lg bg-gray-100" />
                </div>
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Địa chỉ</label>
                    <input type="text" name="address" value="${customer.address}" class="w-full p-3 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-yellow-400" />
                </div>
            </div>
            <div class="flex justify-end">
                <button type="submit" class="bg-yellow-500 hover:bg-yellow-600 text-white font-bold py-2 px-8 rounded-lg transition-colors">Lưu thay đổi</button>
            </div>
        </form>
    </div>
</div>
<script>lucide.createIcons();</script>
</body>
</html> 