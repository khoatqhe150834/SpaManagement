<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Khách Hàng - ${customer.fullName}</title>
    
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

<body class="bg-spa-cream font-sans min-h-screen">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

        <main class="flex-1 py-12 lg:py-20 ml-64">
            <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
                
                <!-- Breadcrumb -->
                <div class="flex flex-wrap items-center gap-2 mb-8 text-gray-500 text-sm">
                    <a href="${pageContext.request.contextPath}/manager/customer/list<c:if test='${not empty param.page or not empty param.pageSize or not empty param.searchValue or not empty param.sortBy or not empty param.sortOrder}'>?<c:if test='${not empty param.page}'>page=${param.page}</c:if><c:if test='${not empty param.pageSize}'><c:if test='${not empty param.page}'>&</c:if>pageSize=${param.pageSize}</c:if><c:if test='${not empty param.searchValue}'><c:if test='${not empty param.page or not empty param.pageSize}'>&</c:if>searchValue=${param.searchValue}</c:if><c:if test='${not empty param.sortBy}'><c:if test='${not empty param.page or not empty param.pageSize or not empty param.searchValue}'>&</c:if>sortBy=${param.sortBy}</c:if><c:if test='${not empty param.sortOrder}'><c:if test='${not empty param.page or not empty param.pageSize or not empty param.searchValue or not empty param.sortBy}'>&</c:if>sortOrder=${param.sortOrder}</c:if></c:if>" class="flex items-center gap-1 hover:text-primary">
                        <i data-lucide="users" class="w-4 h-4"></i>
                        Danh sách khách hàng
                    </a>
                    <span>-</span>
                    <span class="text-primary font-semibold">Hồ sơ khách hàng</span>
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

                <c:if test="${not empty customer}">
                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                        
                        <!-- Left Column: Customer Information -->
                        <div class="lg:col-span-2 space-y-6">
                            
                            <!-- Customer Header -->
                            <div class="bg-white rounded-2xl shadow-lg p-8">
                                <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
                                    <div class="flex items-center gap-4">
                                        <div class="w-16 h-16 rounded-full bg-primary flex items-center justify-center">
                                            <span class="text-white font-bold text-xl">${customer.fullName.substring(0,1).toUpperCase()}</span>
                                        </div>
                                        <div>
                                            <h1 class="text-2xl font-bold text-spa-dark">${customer.fullName}</h1>
                                            <p class="text-gray-600">ID: #${customer.customerId}</p>
                                            <div class="flex items-center gap-2 mt-2">
                                                <c:choose>
                                                    <c:when test="${customer.isVerified}">
                                                        <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-green-100 text-green-800">
                                                            <i data-lucide="check-circle" class="w-3 h-3 mr-1"></i>
                                                            Đã xác thực email
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-yellow-100 text-yellow-800">
                                                            <i data-lucide="alert-triangle" class="w-3 h-3 mr-1"></i>
                                                            Chưa xác thực email
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="flex gap-2">
                                        <a href="${pageContext.request.contextPath}/manager/customer/edit?id=${customer.customerId}&page=${param.page}&pageSize=${param.pageSize}<c:if test='${not empty param.searchValue}'>&searchValue=${param.searchValue}</c:if><c:if test='${not empty param.sortBy}'>&sortBy=${param.sortBy}</c:if><c:if test='${not empty param.sortOrder}'>&sortOrder=${param.sortOrder}</c:if>" 
                                           class="inline-flex items-center gap-2 px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition">
                                            <i data-lucide="edit" class="w-4 h-4"></i>
                                            Chỉnh sửa
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <!-- Contact Information -->
                            <div class="bg-white rounded-2xl shadow-lg p-8">
                                <h2 class="text-xl font-semibold text-spa-dark mb-6 flex items-center gap-2">
                                    <i data-lucide="contact" class="w-5 h-5"></i>
                                    Thông tin liên hệ
                                </h2>
                                <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                                    <div class="flex items-center gap-3 bg-gray-50 rounded-lg p-4">
                                        <i data-lucide="mail" class="w-6 h-6 text-primary flex-shrink-0"></i>
                                        <div>
                                            <div class="text-xs text-gray-500 uppercase tracking-wide">Email</div>
                                            <div class="font-semibold text-gray-800 break-all">${customer.email}</div>
                                        </div>
                                    </div>
                                    <div class="flex items-center gap-3 bg-gray-50 rounded-lg p-4">
                                        <i data-lucide="phone" class="w-6 h-6 text-primary flex-shrink-0"></i>
                                        <div>
                                            <div class="text-xs text-gray-500 uppercase tracking-wide">Số điện thoại</div>
                                            <div class="font-semibold text-gray-800">
                                                <c:choose>
                                                    <c:when test="${not empty customer.phoneNumber}">
                                                        ${customer.phoneNumber}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-400 italic">Chưa cập nhật</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="flex items-center gap-3 bg-gray-50 rounded-lg p-4 sm:col-span-2">
                                        <i data-lucide="map-pin" class="w-6 h-6 text-primary flex-shrink-0"></i>
                                        <div>
                                            <div class="text-xs text-gray-500 uppercase tracking-wide">Địa chỉ</div>
                                            <div class="font-semibold text-gray-800">
                                                <c:choose>
                                                    <c:when test="${not empty customer.address}">
                                                        ${customer.address}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-400 italic">Chưa cập nhật</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Personal Information -->
                            <div class="bg-white rounded-2xl shadow-lg p-8">
                                <h2 class="text-xl font-semibold text-spa-dark mb-6 flex items-center gap-2">
                                    <i data-lucide="user" class="w-5 h-5"></i>
                                    Thông tin cá nhân
                                </h2>
                                <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                                    <div class="flex items-center gap-3 bg-gray-50 rounded-lg p-4">
                                        <i data-lucide="calendar" class="w-6 h-6 text-primary flex-shrink-0"></i>
                                        <div>
                                            <div class="text-xs text-gray-500 uppercase tracking-wide">Ngày sinh</div>
                                            <div class="font-semibold text-gray-800">
                                                <c:choose>
                                                    <c:when test="${not empty customer.birthday}">
                                                        <fmt:formatDate value="${customer.birthday}" pattern="dd/MM/yyyy" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-400 italic">Chưa cập nhật</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="flex items-center gap-3 bg-gray-50 rounded-lg p-4">
                                        <i data-lucide="users" class="w-6 h-6 text-primary flex-shrink-0"></i>
                                        <div>
                                            <div class="text-xs text-gray-500 uppercase tracking-wide">Giới tính</div>
                                            <div class="font-semibold text-gray-800">
                                                <c:choose>
                                                    <c:when test="${customer.gender == 'Male'}">Nam</c:when>
                                                    <c:when test="${customer.gender == 'Female'}">Nữ</c:when>
                                                    <c:when test="${customer.gender == 'Other'}">Khác</c:when>
                                                    <c:otherwise><span class="text-gray-400 italic">Chưa cập nhật</span></c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Customer Notes -->
                            <c:if test="${not empty customer.notes}">
                                <div class="bg-white rounded-2xl shadow-lg p-8">
                                    <h2 class="text-xl font-semibold text-spa-dark mb-6 flex items-center gap-2">
                                        <i data-lucide="sticky-note" class="w-5 h-5"></i>
                                        Ghi chú của Manager
                                    </h2>
                                    <div class="bg-amber-50 border border-amber-200 rounded-lg p-4">
                                        <p class="text-gray-700 whitespace-pre-wrap">${customer.notes}</p>
                                    </div>
                                </div>
                            </c:if>
                        </div>

                        <!-- Right Column: Stats & Actions -->
                        <div class="space-y-6">
                            
                            <!-- Customer Statistics -->
                            <div class="bg-white rounded-2xl shadow-lg p-6">
                                <h3 class="text-lg font-semibold text-spa-dark mb-4 flex items-center gap-2">
                                    <i data-lucide="bar-chart-3" class="w-5 h-5"></i>
                                    Thống kê khách hàng
                                </h3>
                                <div class="space-y-4">
                                    <div class="flex items-center justify-between p-3 bg-primary/10 rounded-lg">
                                        <div class="flex items-center gap-2">
                                            <i data-lucide="gift" class="w-4 h-4 text-primary"></i>
                                            <span class="text-sm font-medium">Điểm thưởng</span>
                                        </div>
                                        <span class="font-bold text-primary">${customer.loyaltyPoints}</span>
                                    </div>
                                    
                                    <div class="flex items-center justify-between p-3 bg-blue-50 rounded-lg">
                                        <div class="flex items-center gap-2">
                                            <i data-lucide="calendar-plus" class="w-4 h-4 text-blue-600"></i>
                                            <span class="text-sm font-medium">Ngày tham gia</span>
                                        </div>
                                        <span class="font-medium text-blue-700">
                                            <c:choose>
                                                <c:when test="${not empty customer.createdAt}">
                                                    ${customer.createdAt.toLocalDate()}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400">--</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>

                                    <div class="flex items-center justify-between p-3 bg-green-50 rounded-lg">
                                        <div class="flex items-center gap-2">
                                            <i data-lucide="clock" class="w-4 h-4 text-green-600"></i>
                                            <span class="text-sm font-medium">Cập nhật cuối</span>
                                        </div>
                                        <span class="font-medium text-green-700">
                                            <c:choose>
                                                <c:when test="${not empty customer.updatedAt}">
                                                    ${customer.updatedAt.toLocalDate()}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400">--</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <!-- Quick Actions -->
                            <div class="bg-white rounded-2xl shadow-lg p-6">
                                <h3 class="text-lg font-semibold text-spa-dark mb-4 flex items-center gap-2">
                                    <i data-lucide="zap" class="w-5 h-5"></i>
                                    Thao tác nhanh
                                </h3>
                                <div class="space-y-3">
                                    <a href="${pageContext.request.contextPath}/manager/customer/edit?id=${customer.customerId}&page=${param.page}&pageSize=${param.pageSize}<c:if test='${not empty param.searchValue}'>&searchValue=${param.searchValue}</c:if><c:if test='${not empty param.sortBy}'>&sortBy=${param.sortBy}</c:if><c:if test='${not empty param.sortOrder}'>&sortOrder=${param.sortOrder}</c:if>" 
                                       class="flex items-center gap-3 p-3 rounded-lg border border-gray-200 hover:bg-gray-50 transition">
                                        <i data-lucide="edit" class="w-4 h-4 text-blue-600"></i>
                                        <span class="text-sm font-medium">Chỉnh sửa thông tin</span>
                                    </a>
                                    
                                    <a href="mailto:${customer.email}" 
                                       class="flex items-center gap-3 p-3 rounded-lg border border-gray-200 hover:bg-gray-50 transition">
                                        <i data-lucide="mail" class="w-4 h-4 text-primary"></i>
                                        <span class="text-sm font-medium">Gửi email</span>
                                    </a>
                                    
                                    <c:if test="${not empty customer.phoneNumber}">
                                        <a href="tel:${customer.phoneNumber}" 
                                           class="flex items-center gap-3 p-3 rounded-lg border border-gray-200 hover:bg-gray-50 transition">
                                            <i data-lucide="phone" class="w-4 h-4 text-green-600"></i>
                                            <span class="text-sm font-medium">Gọi điện thoại</span>
                                        </a>
                                    </c:if>
                                    
                                    <a href="${pageContext.request.contextPath}/manager/customer/loyalty" 
                                       class="flex items-center gap-3 p-3 rounded-lg border border-gray-200 hover:bg-gray-50 transition">
                                        <i data-lucide="gift" class="w-4 h-4 text-purple-600"></i>
                                        <span class="text-sm font-medium">Quản lý điểm thưởng</span>
                                    </a>
                                </div>
                            </div>

                            <!-- Customer Tips -->
                            <div class="bg-gradient-to-br from-primary/10 to-primary/5 rounded-2xl p-6 border border-primary/20">
                                <h3 class="text-lg font-semibold text-spa-dark mb-3 flex items-center gap-2">
                                    <i data-lucide="lightbulb" class="w-5 h-5 text-primary"></i>
                                    Gợi ý chăm sóc khách hàng
                                </h3>
                                <div class="space-y-2 text-sm text-gray-700">
                                    <c:if test="${customer.loyaltyPoints > 100}">
                                        <p class="flex items-center gap-2">
                                            <i data-lucide="star" class="w-3 h-3 text-yellow-500"></i>
                                            Khách hàng thân thiết với ${customer.loyaltyPoints} điểm
                                        </p>
                                    </c:if>
                                    <c:if test="${not customer.isVerified}">
                                        <p class="flex items-center gap-2">
                                            <i data-lucide="alert-circle" class="w-3 h-3 text-yellow-500"></i>
                                            Hỗ trợ khách hàng xác thực email
                                        </p>
                                    </c:if>
                                    <c:if test="${empty customer.phoneNumber}">
                                        <p class="flex items-center gap-2">
                                            <i data-lucide="phone-off" class="w-3 h-3 text-gray-400"></i>
                                            Khuyến khích cập nhật số điện thoại
                                        </p>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
                
                <c:if test="${empty customer}">
                    <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded-lg" role="alert">
                        <div class="flex items-start gap-3">
                            <i data-lucide="alert-triangle" class="w-5 h-5 mt-0.5"></i>
                            <div>
                                <p class="font-bold">Lỗi!</p>
                                <p>Không tìm thấy thông tin khách hàng. Vui lòng quay lại danh sách.</p>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </main>
    </div>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
    <script>
        if (window.lucide) {
            lucide.createIcons();
        }
    </script>
</body>
</html> 