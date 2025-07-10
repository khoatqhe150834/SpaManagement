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
              sans: ["Roboto", "sans-serif"],
            },
          },
        },
      };
    </script>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;600;700&display=swap" rel="stylesheet" />

    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>

    <!-- Box Icons and Remix Icons for backward compatibility -->
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />

    <style>
      @keyframes fadeIn {
        from {
          opacity: 0;
          transform: translateY(20px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }
      .animate-fadeIn {
        animation: fadeIn 0.6s ease-out forwards;
      }
      .line-clamp-2 {
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
      }
      .notification-tab > .active{
        --tw-border-opacity: 1;
        border-bottom-color: rgb(212 175 55 / var(--tw-border-opacity));
        --tw-text-opacity: 1;
        color: rgb(212 175 55 / var(--tw-text-opacity));
      }
      .notification-tab > .active:hover{
        --tw-text-opacity: 1;
        color: rgb(212 175 55 / var(--tw-text-opacity));
      }
      .order-tab > .active{
        --tw-bg-opacity: 1;
        background-color: rgb(212 175 55 / var(--tw-bg-opacity));
        --tw-text-opacity: 1;
        color: rgb(255 255 255 / var(--tw-text-opacity));
      }
      .order-tab > .active:hover{
        --tw-text-opacity: 1;
        color: rgb(255 255 255 / var(--tw-text-opacity));
      }
    </style>
</head>
  <body class="bg-spa-cream font-sans text-spa-dark">
    
    <!-- Include Modernized Admin Sidebar -->
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

    <main class="w-full md:w-[calc(100%-256px)] md:ml-64 bg-white min-h-screen transition-all main">
        <!-- Modern Navbar -->
        <div class="h-16 px-6 bg-spa-cream flex items-center shadow-sm border-b border-primary/10 sticky top-0 left-0 z-30">
            <button type="button" class="text-lg text-spa-dark font-semibold sidebar-toggle hover:text-primary transition-colors duration-200 hidden">
                <i class="ri-menu-line"></i>
            </button>

            <ul class="ml-auto flex items-center">
                <li class="mr-1 dropdown">
                    <button type="button" class="dropdown-toggle text-primary/60 hover:text-primary mr-4 w-8 h-8 rounded-lg flex items-center justify-center hover:bg-primary/10 transition-all duration-200">
                        <i data-lucide="search" class="h-5 w-5"></i>                   
                    </button>
                    <div class="dropdown-menu shadow-lg shadow-black/10 z-30 hidden max-w-xs w-full bg-white rounded-lg border border-primary/20">
                        <form action="" class="p-4 border-b border-primary/10">
                            <div class="relative w-full">
                                <input type="text" class="py-2 pr-4 pl-10 bg-spa-cream w-full outline-none border border-primary/20 rounded-lg text-sm focus:border-primary focus:ring-2 focus:ring-primary/20" placeholder="Tìm kiếm...">
                                <i data-lucide="search" class="absolute top-1/2 left-3 -translate-y-1/2 text-primary/60 h-4 w-4"></i>
                            </div>
                        </form>
                    </div>
                </li>
                
                <!-- User Profile Dropdown -->
                <li class="dropdown ml-3">
                    <button type="button" class="dropdown-toggle flex items-center hover:bg-primary/10 rounded-lg p-2 transition-all duration-200">
                        <div class="flex-shrink-0 w-10 h-10 relative">
                            <div class="p-1 bg-white rounded-full focus:outline-none focus:ring-2 focus:ring-primary/20">
                                <img class="w-8 h-8 rounded-full object-cover" src="https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=100" alt="Admin Avatar"/>
                                <div class="top-0 left-7 absolute w-3 h-3 bg-green-400 border-2 border-white rounded-full animate-ping"></div>
                                <div class="top-0 left-7 absolute w-3 h-3 bg-green-500 border-2 border-white rounded-full"></div>
                            </div>
                        </div>
                        <div class="p-2 md:block text-left">
                            <h2 class="text-sm font-semibold text-spa-dark">${sessionScope.user.fullName != null ? sessionScope.user.fullName : sessionScope.customer.fullName}</h2>
                            <p class="text-xs text-primary/70">
                                <c:choose>
                                    <c:when test="${sessionScope.userType == 'ADMIN'}">Quản trị viên</c:when>
                                    <c:when test="${sessionScope.userType == 'MANAGER'}">Quản lý</c:when>
                                    <c:when test="${sessionScope.userType == 'THERAPIST'}">Nhân viên</c:when>
                                    <c:when test="${sessionScope.userType == 'CUSTOMER'}">Khách hàng</c:when>
                                    <c:otherwise>Người dùng</c:otherwise>
                                </c:choose>
                            </p>
                        </div>                
                    </button>
                    <ul class="dropdown-menu shadow-lg shadow-black/10 z-30 hidden py-2 rounded-lg bg-white border border-primary/20 w-full max-w-[160px]">
                        <li>
                            <a href="${pageContext.request.contextPath}/profile" class="flex items-center text-sm py-2 px-4 text-spa-dark hover:text-primary hover:bg-spa-cream transition-all duration-200">
                                <i data-lucide="user" class="h-4 w-4 mr-2"></i>
                                Hồ sơ
                            </a>
                        </li>
                        <li>
                            <a href="#" class="flex items-center text-sm py-2 px-4 text-spa-dark hover:text-primary hover:bg-spa-cream transition-all duration-200">
                                <i data-lucide="settings" class="h-4 w-4 mr-2"></i>
                                Cài đặt
                            </a>
                        </li>
                        <li class="border-t border-primary/10 mt-1 pt-1">
                            <a href="${pageContext.request.contextPath}/logout" class="flex items-center text-sm py-2 px-4 text-red-600 hover:bg-red-50 cursor-pointer transition-all duration-200">
                                <i data-lucide="log-out" class="h-4 w-4 mr-2"></i>
                                Đăng xuất
                            </a>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
        <!-- end navbar -->

        <!-- Content with Role-based Conditional Rendering -->
        <div class="p-6 bg-spa-cream min-h-screen">
            <c:choose>
                <%-- ============================ ADMIN/MANAGER DASHBOARD ============================ --%>
                <c:when test="${sessionScope.userType == 'ADMIN' || sessionScope.userType == 'MANAGER'}">
                    <!-- Page Header -->
                    <div class="mb-8">
                        <h1 class="text-3xl font-bold text-spa-dark mb-2">
                <c:choose>
                                <c:when test="${sessionScope.userType == 'ADMIN'}">Dashboard Quản Trị</c:when>
                                <c:otherwise>Dashboard Quản Lý</c:otherwise>
                            </c:choose>
                        </h1>
                        <p class="text-primary/70">Chào mừng bạn đến với hệ thống quản lý Spa Hương Sen</p>
                    </div>

                    <!-- Stats Cards -->
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
                        <div class="bg-white rounded-xl border border-primary/10 p-6 shadow-sm hover:shadow-md transition-all duration-200">
                            <div class="flex justify-between mb-6">
                                <div>
                                    <div class="flex items-center mb-1">
                                        <div class="text-3xl font-bold text-spa-dark">156</div>
                                    </div>
                                    <div class="text-sm font-medium text-primary/70">Khách hàng</div>
                                </div>
                                <div class="dropdown">
                                    <button type="button" class="dropdown-toggle text-primary/60 hover:text-primary p-2 rounded-lg hover:bg-primary/10 transition-all duration-200">
                                        <i class="ri-more-fill"></i>
                                    </button>
                                    <ul class="dropdown-menu shadow-lg shadow-black/10 z-30 hidden py-2 rounded-lg bg-white border border-primary/20 w-full max-w-[140px]">
                                        <li>
                                            <a href="#" class="flex items-center text-sm py-2 px-4 text-spa-dark hover:text-primary hover:bg-spa-cream transition-all duration-200">Xem chi tiết</a>
                                        </li>
                                        <li>
                                            <a href="#" class="flex items-center text-sm py-2 px-4 text-spa-dark hover:text-primary hover:bg-spa-cream transition-all duration-200">Thêm mới</a>
                                        </li>
                                    </ul>
                                </div> 
                            </div>
                            <a href="${pageContext.request.contextPath}/user/list" class="inline-flex items-center text-primary font-medium text-sm hover:text-primary-dark transition-colors duration-200">
                                Xem chi tiết
                                <i data-lucide="arrow-right" class="ml-2 h-4 w-4"></i>
                            </a>
                        </div>
                        
                        <!-- Dịch vụ Card -->
                        <div class="bg-white rounded-xl border border-primary/10 p-6 shadow-sm hover:shadow-md transition-all duration-200">
                            <div class="flex justify-between mb-6">
                                <div>
                                    <div class="flex items-center mb-1">
                                        <div class="text-3xl font-bold text-spa-dark">48</div>
                                        <div class="p-1 rounded-full bg-green-100 text-green-600 text-xs font-semibold leading-none ml-2 px-2">+12%</div>
                                    </div>
                                    <div class="text-sm font-medium text-primary/70">Dịch vụ</div>
                                </div>
                                <div class="bg-primary/10 rounded-lg p-3">
                                    <i data-lucide="sparkles" class="h-6 w-6 text-primary"></i>
                                </div> 
                            </div>
                            <a href="${pageContext.request.contextPath}/manager/service" class="inline-flex items-center text-primary font-medium text-sm hover:text-primary-dark transition-colors duration-200">
                                Quản lý dịch vụ
                                <i data-lucide="arrow-right" class="ml-2 h-4 w-4"></i>
                            </a>
                        </div>
                        
                        <!-- Lịch hẹn Card -->
                        <div class="bg-white rounded-xl border border-primary/10 p-6 shadow-sm hover:shadow-md transition-all duration-200">
                            <div class="flex justify-between mb-6">
                                <div>
                                    <div class="flex items-center mb-1">
                                        <div class="text-3xl font-bold text-spa-dark">89</div>
                                        <div class="p-1 rounded-full bg-blue-100 text-blue-600 text-xs font-semibold leading-none ml-2 px-2">Hôm nay</div>
                                    </div>
                                    <div class="text-sm font-medium text-primary/70">Lịch hẹn</div>
                                </div>
                                <div class="bg-secondary/20 rounded-lg p-3">
                                    <i data-lucide="calendar" class="h-6 w-6 text-primary"></i>
                                </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/appointment" class="inline-flex items-center text-primary font-medium text-sm hover:text-primary-dark transition-colors duration-200">
                                Xem lịch hẹn
                                <i data-lucide="arrow-right" class="ml-2 h-4 w-4"></i>
                            </a>
                        </div>
                    </div>
                    
                    <!-- Recent Activities Section -->
                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
                        <!-- Recent Bookings -->
                        <div class="bg-white border border-primary/10 shadow-sm p-6 rounded-xl">
                            <div class="flex justify-between mb-6 items-start">
                                <div>
                                    <h3 class="font-semibold text-lg text-spa-dark">Lịch hẹn gần đây</h3>
                                    <p class="text-primary/70 text-sm">Những lịch hẹn mới nhất</p>
                                </div>
                                <a href="#" class="text-primary hover:text-primary-dark text-sm font-medium transition-colors duration-200">
                                    Xem tất cả
                                </a>
                            </div>
                            <div class="space-y-4">
                                <div class="flex items-center p-3 bg-spa-cream rounded-lg">
                                    <div class="w-10 h-10 bg-primary/20 rounded-full flex items-center justify-center mr-3">
                                        <i data-lucide="user" class="h-5 w-5 text-primary"></i>
                                    </div>
                                    <div class="flex-1">
                                        <p class="font-medium text-spa-dark">Nguyễn Thị Lan</p>
                                        <p class="text-sm text-primary/70">Chăm sóc da mặt - 14:00</p>
                                    </div>
                                    <span class="text-xs bg-green-100 text-green-700 px-2 py-1 rounded-full">Xác nhận</span>
                                </div>
                                <div class="flex items-center p-3 bg-spa-cream rounded-lg">
                                    <div class="w-10 h-10 bg-secondary/40 rounded-full flex items-center justify-center mr-3">
                                        <i data-lucide="user" class="h-5 w-5 text-primary"></i>
                                    </div>
                                    <div class="flex-1">
                                        <p class="font-medium text-spa-dark">Trần Thị Mai</p>
                                        <p class="text-sm text-primary/70">Massage thư giãn - 16:30</p>
                                    </div>
                                    <span class="text-xs bg-yellow-100 text-yellow-700 px-2 py-1 rounded-full">Chờ xác nhận</span>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Stats -->
                        <div class="bg-white border border-primary/10 shadow-sm p-6 rounded-xl">
                            <div class="flex justify-between mb-6 items-start">
                                <div>
                                    <h3 class="font-semibold text-lg text-spa-dark">Thống kê hôm nay</h3>
                                    <p class="text-primary/70 text-sm">Tình hình hoạt động trong ngày</p>
                                </div>
                            </div>
                            <div class="space-y-4">
                                <div class="flex justify-between items-center p-3 bg-spa-cream rounded-lg">
                                    <div class="flex items-center">
                                        <div class="w-8 h-8 bg-primary/20 rounded-lg flex items-center justify-center mr-3">
                                            <i data-lucide="calendar-check" class="h-4 w-4 text-primary"></i>
                                        </div>
                                        <span class="font-medium text-spa-dark">Lịch hẹn hoàn thành</span>
                                    </div>
                                    <span class="font-bold text-spa-dark">12</span>
                                </div>
                                <div class="flex justify-between items-center p-3 bg-spa-cream rounded-lg">
                                    <div class="flex items-center">
                                        <div class="w-8 h-8 bg-green-100 rounded-lg flex items-center justify-center mr-3">
                                            <i data-lucide="dollar-sign" class="h-4 w-4 text-green-600"></i>
                                        </div>
                                        <span class="font-medium text-spa-dark">Doanh thu</span>
                                    </div>
                                    <span class="font-bold text-spa-dark">2.450.000đ</span>
                                </div>
                                <div class="flex justify-between items-center p-3 bg-spa-cream rounded-lg">
                                    <div class="flex items-center">
                                        <div class="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center mr-3">
                                            <i data-lucide="users" class="h-4 w-4 text-blue-600"></i>
                                        </div>
                                        <span class="font-medium text-spa-dark">Khách hàng mới</span>
                                    </div>
                                    <span class="font-bold text-spa-dark">3</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Welcome Message -->
                    <div class="bg-gradient-to-r from-primary to-primary-dark text-white p-8 rounded-xl">
                        <h2 class="font-bold text-2xl mb-4">Chào mừng đến với Spa Hương Sen!</h2>
                        <p class="text-white/90 mb-6">Hệ thống quản lý spa hiện đại giúp bạn theo dõi và quản lý mọi hoạt động một cách hiệu quả.</p>
                        <div class="flex flex-wrap gap-4">
                            <a href="${pageContext.request.contextPath}/booking" class="bg-white text-primary px-6 py-2 rounded-lg font-medium hover:bg-gray-50 transition-colors duration-200">
                                Tạo lịch hẹn mới
                            </a>
                            <a href="#" class="border border-white text-white px-6 py-2 rounded-lg font-medium hover:bg-white/10 transition-colors duration-200">
                                Xem báo cáo
                            </a>
                        </div>
                    </div>
                </c:when>
                    
                    <%-- ============================ CUSTOMER DASHBOARD ============================ --%>
                    <c:when test="${sessionScope.userType == 'CUSTOMER'}">
                        <div class="space-y-8">
                            <!-- Welcome Section -->
                            <div class="bg-gradient-to-r from-[#D4AF37] to-[#B8941F] rounded-xl shadow-lg p-6 text-white">
                                <div class="flex items-center justify-between">
                                    <div>
                                    <h1 class="text-2xl md:text-3xl font-bold mb-2">Chào mừng trở lại, ${sessionScope.customer.fullName}!</h1>
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
                                    <a href="${pageContext.request.contextPath}/customer/view" class="text-primary hover:text-primary-dark font-medium text-sm">Xem tất cả</a>
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
                                <a href="${pageContext.request.contextPath}/booking" class="p-4 border border-gray-200 rounded-lg hover:border-primary hover:bg-spa-cream transition-all text-center group">
                                        <div class="mb-3 flex justify-center"><i data-lucide="calendar" class="h-8 w-8 text-primary"></i></div>
                                        <h4 class="font-semibold text-gray-900 group-hover:text-primary transition-colors">Đặt lịch mới</h4>
                                </a>
                                <a href="${pageContext.request.contextPath}/customer/history" class="p-4 border border-gray-200 rounded-lg hover:border-primary hover:bg-spa-cream transition-all text-center group">
                                        <div class="mb-3 flex justify-center"><i data-lucide="file-text" class="h-8 w-8 text-blue-500"></i></div>
                                        <h4 class="font-semibold text-gray-900 group-hover:text-primary transition-colors">Xem lịch sử</h4>
                                </a>
                                <a href="${pageContext.request.contextPath}/customer/loyalty" class="p-4 border border-gray-200 rounded-lg hover:border-primary hover:bg-spa-cream transition-all text-center group">
                                        <div class="mb-3 flex justify-center"><i data-lucide="gift" class="h-8 w-8 text-green-500"></i></div>
                                        <h4 class="font-semibold text-gray-900 group-hover:text-primary transition-colors">Đổi điểm thưởng</h4>
                                </a>
                                <a href="#" class="p-4 border border-gray-200 rounded-lg hover:border-primary hover:bg-spa-cream transition-all text-center group">
                                        <div class="mb-3 flex justify-center"><i data-lucide="message-circle" class="h-8 w-8 text-purple-500"></i></div>
                                        <h4 class="font-semibold text-gray-900 group-hover:text-primary transition-colors">Liên hệ hỗ trợ</h4>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:when>

                <%-- ============================ THERAPIST DASHBOARD ============================ --%>
                <c:when test="${sessionScope.userType == 'THERAPIST'}">
                    <div class="space-y-8">
                        <!-- Welcome Section -->
                        <div class="bg-gradient-to-r from-[#D4AF37] to-[#B8941F] rounded-xl shadow-lg p-6 text-white">
                            <div class="flex items-center justify-between">
                                <div>
                                    <h1 class="text-2xl md:text-3xl font-bold mb-2">Chào mừng, ${sessionScope.user.fullName}!</h1>
                                    <p class="opacity-90">Hôm nay bạn có 8 lịch hẹn cần thực hiện. Chúc bạn làm việc hiệu quả!</p>
                                </div>
                                <i data-lucide="user-round" class="h-12 w-12 opacity-80 hidden md:block"></i>
                            </div>
                        </div>

                        <!-- Therapist Quick Stats -->
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                            <div class="bg-white p-5 rounded-xl shadow-md flex items-center space-x-4 transition-transform hover:scale-105">
                                <div class="bg-blue-100 p-3 rounded-full"><i data-lucide="clock" class="h-6 w-6 text-blue-600"></i></div>
                                <div>
                                    <p class="text-sm text-gray-500">Lịch hôm nay</p>
                                    <p class="text-2xl font-semibold text-spa-dark">8</p>
                                </div>
                            </div>
                            <div class="bg-white p-5 rounded-xl shadow-md flex items-center space-x-4 transition-transform hover:scale-105">
                                <div class="bg-green-100 p-3 rounded-full"><i data-lucide="check-circle" class="h-6 w-6 text-green-600"></i></div>
                                <div>
                                    <p class="text-sm text-gray-500">Hoàn thành</p>
                                    <p class="text-2xl font-semibold text-spa-dark">3</p>
                                </div>
                            </div>
                            <div class="bg-white p-5 rounded-xl shadow-md flex items-center space-x-4 transition-transform hover:scale-105">
                                <div class="bg-yellow-100 p-3 rounded-full"><i data-lucide="calendar" class="h-6 w-6 text-yellow-600"></i></div>
                                <div>
                                    <p class="text-sm text-gray-500">Tiếp theo</p>
                                    <p class="text-2xl font-semibold text-spa-dark">5</p>
                                </div>
                            </div>
                            <div class="bg-white p-5 rounded-xl shadow-md flex items-center space-x-4 transition-transform hover:scale-105">
                                <div class="bg-primary/20 p-3 rounded-full"><i data-lucide="star" class="h-6 w-6 text-primary"></i></div>
                                <div>
                                    <p class="text-sm text-gray-500">Đánh giá TB</p>
                                    <p class="text-2xl font-semibold text-spa-dark">4.8</p>
                                </div>
                            </div>
                        </div>

                        <!-- Today's Schedule -->
                        <div class="bg-white rounded-xl shadow-md border border-gray-200 p-6">
                            <div class="flex items-center justify-between mb-6">
                                <h3 class="text-lg font-semibold text-spa-dark">Lịch làm việc hôm nay</h3>
                                <a href="${pageContext.request.contextPath}/therapist/schedule" class="text-primary hover:text-primary-dark font-medium text-sm">Xem chi tiết</a>
                            </div>
                            <div class="space-y-4">
                                <div class="p-4 border-l-4 border-green-500 bg-green-50 rounded-lg">
                                    <div class="flex items-center justify-between mb-2">
                                        <span class="font-medium text-gray-800">09:00 - 10:30</span>
                                        <span class="px-2 py-1 bg-green-100 text-green-800 text-xs rounded-full">Hoàn thành</span>
                                    </div>
                                    <p class="font-medium text-gray-900">Massage thư giãn - Chị Nguyễn Thị Lan</p>
                                </div>
                                <div class="p-4 border-l-4 border-blue-500 bg-blue-50 rounded-lg">
                                    <div class="flex items-center justify-between mb-2">
                                        <span class="font-medium text-gray-800">14:00 - 15:00</span>
                                        <span class="px-2 py-1 bg-blue-100 text-blue-800 text-xs rounded-full">Tiếp theo</span>
                                    </div>
                                    <p class="font-medium text-gray-900">Chăm sóc da mặt - Chị Trần Thị Mai</p>
                                </div>
                                </div>
                            </div>
                        </div>
                    </c:when>

                <%-- ============================ DEFAULT DASHBOARD ============================ --%>
                    <c:otherwise>
                        <div class="bg-white p-8 rounded-xl shadow-md text-center">
                            <i data-lucide="layout-dashboard" class="h-16 w-16 text-primary mx-auto mb-4"></i>
                        <h1 class="text-3xl font-bold text-spa-dark mb-2">Welcome to your Dashboard</h1>
                            <p class="text-gray-600">Select an item from the sidebar to get started.</p>
                            <c:if test="${sessionScope.userType == null or sessionScope.userType == 'GUEST'}">
                                <p class="mt-4">Please <a href="${pageContext.request.contextPath}/login" class="text-primary hover:underline">log in</a> to access your dashboard.</p>
                            </c:if>
                        </div>
                    </c:otherwise>
                </c:choose>
        </div>
        <!-- End Content -->
    </main>

    <div id="notification" class="notification"></div>

    <!-- JavaScript -->
    <script src="https://unpkg.com/@popperjs/core@2"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="<c:url value='/js/app.js'/>"></script>

    <script>
        // Sidebar functionality
        const sidebarToggle = document.querySelector('.sidebar-toggle')
        const sidebarOverlay = document.querySelector('.sidebar-overlay')
        const sidebarMenu = document.querySelector('.sidebar-menu')
        const main = document.querySelector('.main')
        
        if (sidebarToggle) {
            sidebarToggle.addEventListener('click', function (e) {
                e.preventDefault()
                main.classList.toggle('active')
                sidebarOverlay.classList.toggle('hidden')
                sidebarMenu.classList.toggle('-translate-x-full')
            })
        }
        
        if (sidebarOverlay) {
            sidebarOverlay.addEventListener('click', function (e) {
                e.preventDefault()
                main.classList.add('active')
                sidebarOverlay.classList.add('hidden')
                sidebarMenu.classList.add('-translate-x-full')
            })
        }
        
        // Initialize Lucide icons
        if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }
        
        // Dropdown functionality
        document.addEventListener('DOMContentLoaded', function() {
            // Toggle dropdowns
            document.querySelectorAll('.dropdown-toggle').forEach(function(item) {
                item.addEventListener('click', function(e) {
                    e.preventDefault();
                    const dropdown = item.closest('.dropdown');
                    const menu = dropdown.querySelector('.dropdown-menu');
                    
                    // Close other dropdowns
                    document.querySelectorAll('.dropdown-menu').forEach(function(otherMenu) {
                        if (otherMenu !== menu) {
                            otherMenu.classList.add('hidden');
                        }
                    });
                    
                    // Toggle current dropdown
                    menu.classList.toggle('hidden');
                });
            });
            
            // Close dropdowns when clicking outside
            document.addEventListener('click', function(e) {
                if (!e.target.closest('.dropdown')) {
                    document.querySelectorAll('.dropdown-menu').forEach(function(menu) {
                        menu.classList.add('hidden');
                    });
                }
            });
        });
        
        console.log('Spa Hương Sen Dashboard Loaded Successfully');
    </script>
</body>
</html>