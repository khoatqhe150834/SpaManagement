<%-- 
    Document   : dashboard.jsp (Common Dashboard)
    Created on : Common Dashboard for all roles
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    
    <c:choose>
        <c:when test="${sessionScope.userType == 'ADMIN'}"><title>Admin Dashboard - Spa Hương Sen</title></c:when>
        <c:when test="${sessionScope.userType == 'MANAGER'}"><title>Manager Dashboard - Spa Hương Sen</title></c:when>
        <c:when test="${sessionScope.userType == 'THERAPIST'}"><title>Therapist Dashboard - Spa Hương Sen</title></c:when>
        <c:when test="${sessionScope.userType == 'CUSTOMER'}"><title>Customer Dashboard - Spa Hương Sen</title></c:when>
        <c:otherwise><title>Dashboard - Spa Hương Sen</title></c:otherwise>
    </c:choose>
    
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
              "spa-gray": "#F3F4F6",
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
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet" />

    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>

    <!-- Custom CSS -->
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
</head>
<body class="bg-spa-gray font-sans">
    
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    
    <div class="flex pt-16">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

        <div class="flex-1">
            <main class="p-8">
                <c:choose>
                    <%-- ============================ MANAGER DASHBOARD ============================ --%>
                    <c:when test="${sessionScope.userType == 'MANAGER'}">
                        <h1 class="text-3xl font-serif text-spa-dark mb-2">Manager Dashboard</h1>
                        <p class="text-gray-600 mb-8">Welcome back! Here's your spa's performance overview.</p>
                        
                        <!-- Manager content here... -->
                        
                    </c:when>
                    
                    <%-- ============================ CUSTOMER DASHBOARD ============================ --%>
                    <c:when test="${sessionScope.userType == 'CUSTOMER'}">
                        <div class="space-y-8">
                            <!-- Welcome Section -->
                            <div class="bg-gradient-to-r from-[#D4AF37] to-[#B8941F] rounded-xl shadow-lg p-6 text-white">
                                <div class="flex items-center justify-between">
                                    <div>
                                        <h1 class="text-2xl md:text-3xl font-serif mb-2">Chào mừng trở lại, Chị Hoàng Thị!</h1>
                                        <p class="opacity-90">Hôm nay là ngày tuyệt vời để chăm sóc bản thân. Bạn có 2 lịch hẹn sắp tới.</p>
                                    </div>
                                    <i data-lucide="heart" class="h-12 w-12 opacity-80 hidden md:block"></i>
                                </div>
                            </div>

                            <!-- Customer Metrics -->
                            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                                <div class="bg-white p-5 rounded-xl shadow-md flex items-center space-x-4 transition-transform hover:scale-105">
                                    <div class="bg-blue-100 p-3 rounded-full"><i data-lucide="calendar" class="h-6 w-6 text-blue-600"></i></div>
                                    <div>
                                        <p class="text-sm text-gray-500">Lịch hẹn tháng này</p>
                                        <p class="text-2xl font-semibold text-spa-dark">4</p>
                                    </div>
                                </div>
                                <div class="bg-white p-5 rounded-xl shadow-md flex items-center space-x-4 transition-transform hover:scale-105">
                                    <div class="bg-primary/20 p-3 rounded-full"><i data-lucide="gift" class="h-6 w-6 text-primary"></i></div>
                                    <div>
                                        <p class="text-sm text-gray-500">Điểm tích lũy</p>
                                        <p class="text-2xl font-semibold text-spa-dark">2,450</p>
                                    </div>
                                </div>
                                <div class="bg-white p-5 rounded-xl shadow-md flex items-center space-x-4 transition-transform hover:scale-105">
                                    <div class="bg-green-100 p-3 rounded-full"><i data-lucide="trending-up" class="h-6 w-6 text-green-600"></i></div>
                                    <div>
                                        <p class="text-sm text-gray-500">Tiết kiệm được</p>
                                        <p class="text-2xl font-semibold text-spa-dark">850K VNĐ</p>
                                    </div>
                                </div>
                                 <div class="bg-white p-5 rounded-xl shadow-md flex items-center space-x-4 transition-transform hover:scale-105">
                                    <div class="bg-amber-100 p-3 rounded-full"><i data-lucide="award" class="h-6 w-6 text-amber-600"></i></div>
                                    <div>
                                        <p class="text-sm text-gray-500">Hạng thành viên</p>
                                        <p class="text-2xl font-semibold text-spa-dark">Gold</p>
                                    </div>
                                </div>
                            </div>

                            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                                <!-- Upcoming Appointments -->
                                <div class="lg:col-span-2 bg-white rounded-xl shadow-md border border-gray-200 p-6">
                                    <div class="flex items-center justify-between mb-6">
                                        <h3 class="text-lg font-semibold text-spa-dark">Lịch hẹn sắp tới</h3>
                                        <a href="#" class="text-primary hover:text-primary-dark font-medium text-sm">Xem tất cả</a>
                                    </div>
                                    <div class="space-y-4">
                                        <div class="p-4 border border-gray-200 rounded-lg hover:border-primary transition-colors">
                                            <div class="flex flex-wrap items-center justify-between gap-2 mb-3">
                                                <div class="flex items-center space-x-3">
                                                    <i data-lucide="calendar" class="h-5 w-5 text-primary"></i>
                                                    <span class="font-medium text-gray-800">22/12/2024 - 14:00</span>
                                                    <span class="px-2 py-1 bg-green-100 text-green-800 text-xs rounded-full font-medium">Đã xác nhận</span>
                                                </div>
                                                <span class="font-bold text-primary">499,000 VNĐ</span>
                                            </div>
                                            <div class="space-y-1 ml-8">
                                                <p class="font-medium text-gray-900">Massage thư giãn toàn thân</p>
                                                <p class="text-sm text-gray-600">Nhân viên: Chị Nguyễn Thị Hương</p>
                                            </div>
                                        </div>
                                        <div class="p-4 border border-gray-200 rounded-lg hover:border-primary transition-colors">
                                            <div class="flex flex-wrap items-center justify-between gap-2 mb-3">
                                                <div class="flex items-center space-x-3">
                                                    <i data-lucide="calendar" class="h-5 w-5 text-primary"></i>
                                                    <span class="font-medium text-gray-800">28/12/2024 - 10:30</span>
                                                    <span class="px-2 py-1 bg-green-100 text-green-800 text-xs rounded-full font-medium">Đã xác nhận</span>
                                                </div>
                                                <span class="font-bold text-primary">599,000 VNĐ</span>
                                            </div>
                                            <div class="space-y-1 ml-8">
                                                <p class="font-medium text-gray-900">Chăm sóc da mặt cao cấp</p>
                                                <p class="text-sm text-gray-600">Nhân viên: Chị Trần Thị Lan</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Recent Activity -->
                                <div class="bg-white rounded-xl shadow-md border border-gray-200 p-6">
                                    <h3 class="text-lg font-semibold text-spa-dark mb-6">Hoạt động gần đây</h3>
                                    <div class="space-y-5">
                                        <div class="flex items-start space-x-4">
                                            <div class="flex-shrink-0 pt-1"><i data-lucide="check-circle" class="h-5 w-5 text-green-500"></i></div>
                                            <div class="flex-1 min-w-0">
                                                <p class="text-sm font-medium text-gray-900">Hoàn thành dịch vụ Tắm trắng</p>
                                                <p class="text-xs text-gray-500 mt-1">2 ngày trước</p>
                                            </div>
                                        </div>
                                        <div class="flex items-start space-x-4">
                                            <div class="flex-shrink-0 pt-1"><i data-lucide="gift" class="h-5 w-5 text-primary"></i></div>
                                            <div class="flex-1 min-w-0">
                                                <p class="text-sm font-medium text-gray-900">Nhận 150 điểm tích lũy</p>
                                                <p class="text-xs text-gray-500 mt-1">1 tuần trước</p>
                                            </div>
                                        </div>
                                        <div class="flex items-start space-x-4">
                                            <div class="flex-shrink-0 pt-1"><i data-lucide="star" class="h-5 w-5 text-blue-500"></i></div>
                                            <div class="flex-1 min-w-0">
                                                <p class="text-sm font-medium text-gray-900">Ưu đãi đặc biệt cho thành viên Gold</p>
                                                <p class="text-xs text-gray-500 mt-1">3 ngày trước</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Quick Actions -->
                            <div class="bg-white rounded-xl shadow-md border border-gray-200 p-6">
                                <h3 class="text-lg font-semibold text-spa-dark mb-6">Thao tác nhanh</h3>
                                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                                    <button class="p-4 border border-gray-200 rounded-lg hover:border-primary hover:bg-spa-cream transition-all text-center group">
                                        <div class="mb-3 flex justify-center"><i data-lucide="calendar" class="h-8 w-8 text-primary"></i></div>
                                        <h4 class="font-semibold text-gray-900 group-hover:text-primary transition-colors">Đặt lịch mới</h4>
                                    </button>
                                    <button class="p-4 border border-gray-200 rounded-lg hover:border-primary hover:bg-spa-cream transition-all text-center group">
                                        <div class="mb-3 flex justify-center"><i data-lucide="file-text" class="h-8 w-8 text-blue-500"></i></div>
                                        <h4 class="font-semibold text-gray-900 group-hover:text-primary transition-colors">Xem lịch sử</h4>
                                    </button>
                                    <button class="p-4 border border-gray-200 rounded-lg hover:border-primary hover:bg-spa-cream transition-all text-center group">
                                        <div class="mb-3 flex justify-center"><i data-lucide="gift" class="h-8 w-8 text-green-500"></i></div>
                                        <h4 class="font-semibold text-gray-900 group-hover:text-primary transition-colors">Đổi điểm thưởng</h4>
                                    </button>
                                    <button class="p-4 border border-gray-200 rounded-lg hover:border-primary hover:bg-spa-cream transition-all text-center group">
                                        <div class="mb-3 flex justify-center"><i data-lucide="message-circle" class="h-8 w-8 text-purple-500"></i></div>
                                        <h4 class="font-semibold text-gray-900 group-hover:text-primary transition-colors">Liên hệ hỗ trợ</h4>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:when>

                    <%-- ============================ OTHER DASHBOARDS (Placeholders) ============================ --%>
                    <c:otherwise>
                        <div class="bg-white p-8 rounded-xl shadow-md text-center">
                            <i data-lucide="layout-dashboard" class="h-16 w-16 text-primary mx-auto mb-4"></i>
                            <h1 class="text-3xl font-serif text-spa-dark mb-2">Welcome to your Dashboard</h1>
                            <p class="text-gray-600">Select an item from the sidebar to get started.</p>
                            <c:if test="${sessionScope.userType == null or sessionScope.userType == 'GUEST'}">
                                <p class="mt-4">Please <a href="${pageContext.request.contextPath}/login" class="text-primary hover:underline">log in</a> to access your dashboard.</p>
                            </c:if>
                        </div>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>
    </div>

    <div id="notification" class="notification"></div>

    <!-- JavaScript -->
    <script src="<c:url value='/js/app.js'/>"></script>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            if(window.lucide) {
                lucide.createIcons();
            }
        });
    </script>
</body>
</html>