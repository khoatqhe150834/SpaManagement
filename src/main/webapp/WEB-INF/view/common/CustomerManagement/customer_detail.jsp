<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Khách Hàng - ${customer.fullName}</title>

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

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
</head>

<body class="bg-spa-cream font-sans">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />

    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

        <main class="flex-1 py-12 lg:py-20 ml-64">
            <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
                
                <!-- Breadcrumb -->
                <div class="flex flex-wrap items-center gap-2 mb-8 text-gray-500 text-sm">
                    <a href="${pageContext.request.contextPath}/customer-management/list" class="flex items-center gap-1 hover:text-primary">
                        <i data-lucide="users" class="w-4 h-4"></i>
                        Danh sách khách hàng
                    </a>
                    <span>-</span>
                    <span class="text-primary font-semibold">Chi tiết khách hàng</span>
                </div>

                <!-- Success/Error Messages -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6 rounded-lg" role="alert">
                        <p>${sessionScope.successMessage}</p>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>

                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-lg" role="alert">
                        <p>${sessionScope.errorMessage}</p>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <!-- Customer Profile Header -->
                <div class="bg-white rounded-2xl shadow-lg overflow-hidden mb-8">
                    <div class="bg-gradient-to-r from-primary to-primary-dark p-8">
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
                                
                                <!-- Status badge -->
                                <div class="absolute -bottom-2 -right-2">
                                    <c:choose>
                                        <c:when test="${customer.isActive}">
                                            <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800 border-2 border-white">
                                                <i data-lucide="check-circle" class="w-3 h-3 mr-1"></i>
                                                Hoạt động
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-red-100 text-red-800 border-2 border-white">
                                                <i data-lucide="x-circle" class="w-3 h-3 mr-1"></i>
                                                Bị khóa
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <div class="text-center md:text-left text-white">
                                <h1 class="text-3xl font-bold mb-2">${customer.fullName}</h1>
                                <p class="text-xl opacity-90 mb-4">ID: ${customer.customerId}</p>
                                
                                <div class="flex flex-wrap gap-3 justify-center md:justify-start">
                                    <c:if test="${not empty customer.email}">
                                        <div class="flex items-center gap-2 bg-white/20 px-3 py-1 rounded-full">
                                            <i data-lucide="mail" class="w-4 h-4"></i>
                                            <span class="text-sm">${customer.email}</span>
                                            <c:if test="${customer.isVerified}">
                                                <i data-lucide="check-circle" class="w-4 h-4 text-green-300"></i>
                                            </c:if>
                                        </div>
                                    </c:if>
                                    
                                    <c:if test="${not empty customer.phoneNumber}">
                                        <div class="flex items-center gap-2 bg-white/20 px-3 py-1 rounded-full">
                                            <i data-lucide="phone" class="w-4 h-4"></i>
                                            <span class="text-sm">${customer.phoneNumber}</span>
                                        </div>
                                    </c:if>
                                    
                                    <div class="flex items-center gap-2 bg-white/20 px-3 py-1 rounded-full">
                                        <i data-lucide="gift" class="w-4 h-4"></i>
                                        <span class="text-sm"><fmt:formatNumber value="${customer.loyaltyPoints}" type="number"/> điểm</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="flex flex-wrap gap-3 mb-8">
                    <a href="${pageContext.request.contextPath}/customer-management/edit?id=${customer.customerId}" 
                       class="inline-flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors">
                        <i data-lucide="edit" class="w-4 h-4"></i>
                        Chỉnh sửa thông tin
                    </a>
                    
                    <c:if test="${isAdmin || isManager}">
                        <c:choose>
                            <c:when test="${customer.isActive}">
                                <a href="${pageContext.request.contextPath}/customer-management/deactivate?id=${customer.customerId}" 
                                   class="inline-flex items-center gap-2 px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors"
                                   onclick="return confirm('Bạn có chắc muốn khóa tài khoản này?')">
                                    <i data-lucide="user-x" class="w-4 h-4"></i>
                                    Khóa tài khoản
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/customer-management/activate?id=${customer.customerId}" 
                                   class="inline-flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors">
                                    <i data-lucide="user-check" class="w-4 h-4"></i>
                                    Kích hoạt tài khoản
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                    
                    <c:if test="${not empty customer.email}">
                        <c:choose>
                            <c:when test="${customer.isVerified}">
                                <a href="${pageContext.request.contextPath}/customer-management/unverify?id=${customer.customerId}" 
                                   class="inline-flex items-center gap-2 px-4 py-2 bg-orange-600 text-white rounded-lg hover:bg-orange-700 transition-colors">
                                    <i data-lucide="mail-x" class="w-4 h-4"></i>
                                    Hủy xác thực email
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/customer-management/verify?id=${customer.customerId}" 
                                   class="inline-flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                                    <i data-lucide="mail-check" class="w-4 h-4"></i>
                                    Xác thực email
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                    
                    <a href="${pageContext.request.contextPath}/customer-management/quick-reset-password?id=${customer.customerId}" 
                       class="inline-flex items-center gap-2 px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors"
                       onclick="return confirm('Bạn có chắc muốn đặt lại mật khẩu cho khách hàng này?')">
                        <i data-lucide="key" class="w-4 h-4"></i>
                        Đặt lại mật khẩu
                    </a>
                    
                    <c:if test="${isAdmin}">
                        <form action="${pageContext.request.contextPath}/customer-management/delete" method="post" class="inline">
                            <input type="hidden" name="id" value="${customer.customerId}">
                            <button type="submit" class="inline-flex items-center gap-2 px-4 py-2 bg-red-800 text-white rounded-lg hover:bg-red-900 transition-colors" 
                                    onclick="return confirm('Bạn có chắc muốn XÓA VĨNH VIỄN khách hàng này? Hành động này không thể hoàn tác!')">
                                <i data-lucide="trash-2" class="w-4 h-4"></i>
                                Xóa khách hàng
                            </button>
                        </form>
                    </c:if>
                </div>

                <!-- Main Content Grid -->
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                    <!-- Personal Information -->
                    <div class="lg:col-span-2">
                        <div class="bg-white rounded-2xl shadow-lg p-6 mb-6">
                            <h2 class="text-xl font-bold text-spa-dark mb-6 flex items-center gap-2">
                                <i data-lucide="user-circle" class="w-6 h-6 text-primary"></i>
                                Thông tin cá nhân
                            </h2>
                            
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Họ và tên</label>
                                    <div class="flex items-center gap-2 p-3 bg-gray-50 rounded-lg">
                                        <i data-lucide="user" class="w-4 h-4 text-gray-400"></i>
                                        <span class="text-gray-900">${customer.fullName}</span>
                                    </div>
                                </div>
                                
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Giới tính</label>
                                    <div class="flex items-center gap-2 p-3 bg-gray-50 rounded-lg">
                                        <i data-lucide="user" class="w-4 h-4 text-gray-400"></i>
                                        <span class="text-gray-900">
                                            <c:choose>
                                                <c:when test="${customer.gender == 'MALE'}">Nam</c:when>
                                                <c:when test="${customer.gender == 'FEMALE'}">Nữ</c:when>
                                                <c:when test="${customer.gender == 'OTHER'}">Khác</c:when>
                                                <c:otherwise>Không xác định</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                                
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Ngày sinh</label>
                                    <div class="flex items-center gap-2 p-3 bg-gray-50 rounded-lg">
                                        <i data-lucide="calendar" class="w-4 h-4 text-gray-400"></i>
                                        <span class="text-gray-900">
                                            <c:choose>
                                                <c:when test="${not empty customer.birthday}">
                                                    <fmt:formatDate value="${customer.birthday}" pattern="dd/MM/yyyy"/>
                                                </c:when>
                                                <c:otherwise>Chưa cập nhật</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                                
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Số điện thoại</label>
                                    <div class="flex items-center gap-2 p-3 bg-gray-50 rounded-lg">
                                        <i data-lucide="phone" class="w-4 h-4 text-gray-400"></i>
                                        <span class="text-gray-900">
                                            <c:choose>
                                                <c:when test="${not empty customer.phoneNumber}">
                                                    ${customer.phoneNumber}
                                                </c:when>
                                                <c:otherwise>Chưa cập nhật</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                                
                                <div class="md:col-span-2">
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Email</label>
                                    <div class="flex items-center gap-2 p-3 bg-gray-50 rounded-lg">
                                        <i data-lucide="mail" class="w-4 h-4 text-gray-400"></i>
                                        <span class="text-gray-900">
                                            <c:choose>
                                                <c:when test="${not empty customer.email}">
                                                    ${customer.email}
                                                </c:when>
                                                <c:otherwise>Chưa cập nhật</c:otherwise>
                                            </c:choose>
                                        </span>
                                        <c:if test="${customer.isVerified}">
                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                <i data-lucide="check-circle" class="w-3 h-3 mr-1"></i>
                                                Đã xác thực
                                            </span>
                                        </c:if>
                                    </div>
                                </div>
                                
                                <div class="md:col-span-2">
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Địa chỉ</label>
                                    <div class="flex items-center gap-2 p-3 bg-gray-50 rounded-lg">
                                        <i data-lucide="map-pin" class="w-4 h-4 text-gray-400"></i>
                                        <span class="text-gray-900">
                                            <c:choose>
                                                <c:when test="${not empty customer.address}">
                                                    ${customer.address}
                                                </c:when>
                                                <c:otherwise>Chưa cập nhật</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Notes Section -->
                        <div class="bg-white rounded-2xl shadow-lg p-6">
                            <h2 class="text-xl font-bold text-spa-dark mb-6 flex items-center gap-2">
                                <i data-lucide="sticky-note" class="w-6 h-6 text-primary"></i>
                                Ghi chú
                            </h2>
                            
                            <div class="p-4 bg-gray-50 rounded-lg">
                                <c:choose>
                                    <c:when test="${not empty customer.notes}">
                                        <p class="text-gray-900 whitespace-pre-wrap">${customer.notes}</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-gray-500 italic">Chưa có ghi chú nào</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Account Information & Statistics -->
                    <div class="lg:col-span-1">
                        <!-- Account Status -->
                        <div class="bg-white rounded-2xl shadow-lg p-6 mb-6">
                            <h2 class="text-xl font-bold text-spa-dark mb-6 flex items-center gap-2">
                                <i data-lucide="shield" class="w-6 h-6 text-primary"></i>
                                Trạng thái tài khoản
                            </h2>
                            
                            <div class="space-y-4">
                                <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                    <span class="text-gray-700">Trạng thái:</span>
                                    <c:choose>
                                        <c:when test="${customer.isActive}">
                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                <i data-lucide="check-circle" class="w-3 h-3 mr-1"></i>
                                                Hoạt động
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                                <i data-lucide="x-circle" class="w-3 h-3 mr-1"></i>
                                                Bị khóa
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <c:if test="${not empty customer.email}">
                                    <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                        <span class="text-gray-700">Email:</span>
                                        <c:choose>
                                            <c:when test="${customer.isVerified}">
                                                <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                    <i data-lucide="mail-check" class="w-3 h-3 mr-1"></i>
                                                    Đã xác thực
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                                                    <i data-lucide="mail-x" class="w-3 h-3 mr-1"></i>
                                                    Chưa xác thực
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:if>
                                
                                <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                    <span class="text-gray-700">Điểm tích lũy:</span>
                                    <span class="font-semibold text-primary">
                                        <fmt:formatNumber value="${customer.loyaltyPoints}" type="number"/> điểm
                                    </span>
                                </div>
                                
                                <!-- Promotion Usage Summary -->
                                <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                    <span class="text-gray-700">Khuyến mãi có sẵn:</span>
                                    <span class="font-semibold text-primary">
                                        <c:choose>
                                            <c:when test="${not empty promotionSummary}">
                                                ${promotionSummary.totalPromotions} mã
                                                <c:if test="${promotionSummary.totalRemainingUses > 0}">
                                                    (${promotionSummary.totalRemainingUses} lượt còn lại)
                                                </c:if>
                                            </c:when>
                                            <c:otherwise>0 mã</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                
                                <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                    <span class="text-gray-700">Ngày tạo:</span>
                                    <span class="text-gray-900">
                                        <c:choose>
                                            <c:when test="${not empty createdAtDate}">
                                                <fmt:formatDate value="${createdAtDate}" pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>Không xác định</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                    <span class="text-gray-700">Lần cập nhật cuối:</span>
                                    <span class="text-gray-900">
                                        <c:choose>
                                            <c:when test="${not empty updatedAtDate}">
                                                <fmt:formatDate value="${updatedAtDate}" pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>Không xác định</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="flex items-center gap-2 p-3 bg-gray-50 rounded-lg">
                                    <i data-lucide="calendar" class="w-4 h-4 text-gray-400"></i>
                                    <span class="text-gray-900">
                                        <c:choose>
                                            <c:when test="${not empty customer.birthday}">
                                                <fmt:formatDate value="${customer.birthday}" pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>Chưa cập nhật</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                    <span class="text-gray-700">Lần cuối sử dụng:</span>
                                    <span class="text-gray-900">
                                        <c:choose>
                                            <c:when test="${not empty lastVisit}">
                                                <fmt:formatDate value="${lastVisit}" pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>Chưa có</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Statistics -->
                        <div class="bg-white rounded-2xl shadow-lg p-6">
                            <h2 class="text-xl font-bold text-spa-dark mb-6 flex items-center gap-2">
                                <i data-lucide="bar-chart" class="w-6 h-6 text-primary"></i>
                                Thống kê
                            </h2>
                            
                            <div class="space-y-4">
                                <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                    <span class="text-gray-700">Tổng booking:</span>
                                    <span class="font-semibold text-blue-600">
                                        <fmt:formatNumber value="${totalBookings}" type="number"/>
                                    </span>
                                </div>
                                
                                <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                    <span class="text-gray-700">Tổng chi tiêu:</span>
                                    <span class="font-semibold text-green-600">
                                        <fmt:formatNumber value="${totalSpent}" type="currency" currencySymbol="₫"/>
                                    </span>
                                </div>
                                
                                <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                    <span class="text-gray-700">Lần cuối sử dụng:</span>
                                    <span class="text-gray-900">
                                        <c:choose>
                                            <c:when test="${not empty lastVisit}">
                                                <fmt:formatDate value="${lastVisit}" pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>Chưa có</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Promotion Usage Details -->
    <c:if test="${not empty customerPromotions}">
        <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 mb-8">
            <div class="bg-white rounded-2xl shadow-lg p-6">
                <h2 class="text-xl font-bold text-spa-dark mb-6 flex items-center gap-2">
                    <i data-lucide="gift" class="w-6 h-6 text-primary"></i>
                    Chi tiết khuyến mãi có thể sử dụng
                </h2>
                
                <div class="space-y-4">
                    <c:forEach var="promotion" items="${customerPromotions}">
                        <div class="border border-gray-200 rounded-lg p-4 hover:bg-gray-50 transition-colors">
                            <div class="flex justify-between items-start mb-3">
                                <div class="flex-1">
                                    <h3 class="font-semibold text-gray-900 mb-1">${promotion.title}</h3>
                                    <p class="text-sm text-gray-600 mb-2">Mã: <span class="font-mono bg-gray-100 px-2 py-1 rounded">${promotion.promotionCode}</span></p>
                                    <div class="flex items-center gap-4 text-sm text-gray-600">
                                        <span>
                                            <i data-lucide="percent" class="w-4 h-4 inline mr-1"></i>
                                            <c:choose>
                                                <c:when test="${promotion.discountType == 'PERCENTAGE'}">
                                                    Giảm ${promotion.discountValue}%
                                                </c:when>
                                                <c:when test="${promotion.discountType == 'FIXED_AMOUNT'}">
                                                    Giảm <fmt:formatNumber value="${promotion.discountValue}" type="currency" currencySymbol="₫"/>
                                                </c:when>
                                                <c:otherwise>
                                                    ${promotion.discountType}
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                        <span>
                                            <i data-lucide="calendar" class="w-4 h-4 inline mr-1"></i>
                                            <fmt:formatDate value="${promotion.endDate}" pattern="dd/MM/yyyy"/>
                                        </span>
                                    </div>
                                </div>
                                
                                <div class="text-right">
                                    <c:choose>
                                        <c:when test="${promotion.remainingCount == null}">
                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                <i data-lucide="infinity" class="w-3 h-3 mr-1"></i>
                                                Không giới hạn
                                            </span>
                                        </c:when>
                                        <c:when test="${promotion.remainingCount > 0}">
                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                                <i data-lucide="check-circle" class="w-3 h-3 mr-1"></i>
                                                Còn ${promotion.remainingCount} lượt
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                                <i data-lucide="x-circle" class="w-3 h-3 mr-1"></i>
                                                Đã hết lượt
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <c:if test="${promotion.usageLimitPerCustomer != null}">
                                        <div class="text-xs text-gray-500 mt-1">
                                            Đã dùng: ${promotion.usedCount}/${promotion.usageLimitPerCustomer}
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <c:if test="${promotion.remainingCount != null && promotion.remainingCount > 0}">
                                <div class="w-full bg-gray-200 rounded-full h-2">
                                    <c:set var="usagePercentage" value="${(promotion.usedCount / promotion.usageLimitPerCustomer) * 100}" />
                                    <div class="bg-primary h-2 rounded-full" style="width: ${usagePercentage}%"></div>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
                
                <c:if test="${not empty promotionSummary}">
                    <div class="mt-6 p-4 bg-primary/10 rounded-lg">
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 text-center">
                            <div>
                                <div class="text-2xl font-bold text-primary">${promotionSummary.totalPromotions}</div>
                                <div class="text-sm text-gray-600">Tổng mã khuyến mãi</div>
                            </div>
                            <div>
                                <div class="text-2xl font-bold text-green-600">${promotionSummary.unlimitedPromotions}</div>
                                <div class="text-sm text-gray-600">Mã không giới hạn</div>
                            </div>
                            <div>
                                <div class="text-2xl font-bold text-blue-600">${promotionSummary.totalRemainingUses}</div>
                                <div class="text-sm text-gray-600">Lượt còn lại</div>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </c:if>

    <script>
        // Initialize Lucide icons
        lucide.createIcons();
    </script>
</body>
</html> 