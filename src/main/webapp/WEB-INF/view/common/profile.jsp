<%--
    Document   : profile.jsp
    Created on : Profile page for Spa Management System
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
    <title>Hồ Sơ Cá Nhân - Spa Hương Sen</title>

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

    <style>
        /* Custom styling to match payment history page */
        .profile-info-card {
            transition: all 0.3s ease;
        }

        .profile-info-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }

        .profile-stat-card {
            transition: all 0.3s ease;
        }

        .profile-stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }
    </style>
</head>

<body class="bg-spa-cream font-sans text-spa-dark">

    <!-- Include Sidebar -->
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

    <main class="w-full md:w-[calc(100%-256px)] md:ml-64 bg-white min-h-screen transition-all main">
        <!-- Modern Navbar -->
        <div class="h-16 px-6 bg-spa-cream flex items-center shadow-sm border-b border-primary/10 sticky top-0 left-0 z-30">
            <button type="button" class="text-lg text-spa-dark font-semibold sidebar-toggle hover:text-primary transition-colors duration-200 hidden">
                <i class="ri-menu-line"></i>
            </button>

            <ul class="ml-auto flex items-center">
                <li class="dropdown ml-3">
                    <button type="button" class="dropdown-toggle flex items-center hover:bg-primary/10 rounded-lg p-2 transition-all duration-200">
                        <div class="flex-shrink-0 w-10 h-10 relative">
                            <div class="p-1 bg-white rounded-full focus:outline-none focus:ring-2 focus:ring-primary/20">
                                <img class="w-8 h-8 rounded-full object-cover" src="https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=100" alt="User Avatar"/>
                                <div class="top-0 left-7 absolute w-3 h-3 bg-green-400 border-2 border-white rounded-full animate-ping"></div>
                                <div class="top-0 left-7 absolute w-3 h-3 bg-green-500 border-2 border-white rounded-full"></div>
                            </div>
                        </div>
                        <div class="p-2 md:block text-left">
                            <h2 class="text-sm font-semibold text-spa-dark">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user}">
                                        ${sessionScope.user.fullName}
                                    </c:when>
                                    <c:otherwise>
                                        ${sessionScope.customer.fullName}
                                    </c:otherwise>
                                </c:choose>
                            </h2>
                            <p class="text-xs text-primary/70">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user}">
                                        <c:choose>
                                            <c:when test="${sessionScope.user.roleId == 1}">Quản trị viên</c:when>
                                            <c:when test="${sessionScope.user.roleId == 2}">Quản lý</c:when>
                                            <c:when test="${sessionScope.user.roleId == 3}">Nhân viên</c:when>
                                            <c:when test="${sessionScope.user.roleId == 4}">Lễ tân</c:when>
                                            <c:when test="${sessionScope.user.roleId == 6}">Marketing</c:when>
                                            <c:when test="${sessionScope.user.roleId == 7}">Quản lý kho</c:when>
                                            <c:otherwise>Nhân viên</c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        Khách hàng
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </button>
                    <ul class="dropdown-menu shadow-lg shadow-black/10 z-30 hidden py-2 rounded-lg bg-white border border-primary/20 w-full max-w-[160px]">
                        <li>
                            <a href="${pageContext.request.contextPath}/profile/edit" class="flex items-center text-sm py-2 px-4 text-spa-dark hover:text-primary hover:bg-spa-cream transition-all duration-200">
                                <i data-lucide="edit-3" class="h-4 w-4 mr-2"></i>
                                Chỉnh sửa
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

        <!-- Content -->
        <div class="p-6 bg-spa-cream min-h-screen">

            <!-- Profile Information Card -->
            <div class="bg-white rounded-xl shadow-md border border-primary/10 overflow-hidden mb-6">
                <div class="p-6 border-b border-gray-200">
                    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                        <h2 class="text-xl font-semibold text-spa-dark flex items-center gap-2">
                            <i data-lucide="user-circle" class="h-6 w-6 text-primary"></i>
                            Thông tin cá nhân
                        </h2>
                        <div class="flex flex-wrap items-center gap-3">
                            <a href="${pageContext.request.contextPath}/profile/edit"
                               class="inline-flex items-center px-4 py-2 text-sm font-medium text-white bg-primary rounded-md hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-primary/20 transition-colors duration-200">
                                <i data-lucide="edit-3" class="h-4 w-4 mr-2"></i>
                                Chỉnh sửa hồ sơ
                            </a>
                        </div>
                    </div>
                </div>

                <div class="p-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Full Name -->
                        <div class="profile-info-card bg-spa-cream/50 border border-primary/10 rounded-lg p-4 hover:shadow-md transition-all duration-200">
                            <div class="flex items-center gap-3 mb-2">
                                <i data-lucide="user" class="h-5 w-5 text-primary"></i>
                                <span class="text-sm font-medium text-gray-600">Họ và tên</span>
                            </div>
                            <p class="text-lg font-semibold text-spa-dark">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user}">
                                        ${sessionScope.user.fullName}
                                    </c:when>
                                    <c:otherwise>
                                        ${sessionScope.customer.fullName}
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <!-- Email -->
                        <div class="profile-info-card bg-spa-cream/50 border border-primary/10 rounded-lg p-4 hover:shadow-md transition-all duration-200">
                            <div class="flex items-center gap-3 mb-2">
                                <i data-lucide="mail" class="h-5 w-5 text-green-600"></i>
                                <span class="text-sm font-medium text-gray-600">Email</span>
                            </div>
                            <p class="text-lg font-semibold text-spa-dark">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user}">
                                        ${sessionScope.user.email}
                                    </c:when>
                                    <c:otherwise>
                                        ${sessionScope.customer.email}
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <!-- Phone Number -->
                        <div class="profile-info-card bg-spa-cream/50 border border-primary/10 rounded-lg p-4 hover:shadow-md transition-all duration-200">
                            <div class="flex items-center gap-3 mb-2">
                                <i data-lucide="phone" class="h-5 w-5 text-blue-600"></i>
                                <span class="text-sm font-medium text-gray-600">Số điện thoại</span>
                            </div>
                            <p class="text-lg font-semibold text-spa-dark">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user}">
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.user.phoneNumber}">
                                                ${sessionScope.user.phoneNumber}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-gray-400">Chưa cập nhật</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.customer.phoneNumber}">
                                                ${sessionScope.customer.phoneNumber}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-gray-400">Chưa cập nhật</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <!-- Gender -->
                        <div class="profile-info-card bg-spa-cream/50 border border-primary/10 rounded-lg p-4 hover:shadow-md transition-all duration-200">
                            <div class="flex items-center gap-3 mb-2">
                                <i data-lucide="users" class="h-5 w-5 text-purple-600"></i>
                                <span class="text-sm font-medium text-gray-600">Giới tính</span>
                            </div>
                            <p class="text-lg font-semibold text-spa-dark">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user}">
                                        <c:choose>
                                            <c:when test="${sessionScope.user.gender == 'MALE'}">Nam</c:when>
                                            <c:when test="${sessionScope.user.gender == 'FEMALE'}">Nữ</c:when>
                                            <c:when test="${sessionScope.user.gender == 'OTHER'}">Khác</c:when>
                                            <c:when test="${sessionScope.user.gender == 'UNKNOWN'}">Chưa cập nhật</c:when>
                                            <c:when test="${empty sessionScope.user.gender}">Chưa cập nhật</c:when>
                                            <c:otherwise>Khác</c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <c:choose>
                                            <c:when test="${sessionScope.customer.gender == 'MALE'}">Nam</c:when>
                                            <c:when test="${sessionScope.customer.gender == 'FEMALE'}">Nữ</c:when>
                                            <c:when test="${sessionScope.customer.gender == 'OTHER'}">Khác</c:when>
                                            <c:when test="${sessionScope.customer.gender == 'UNKNOWN'}">Chưa cập nhật</c:when>
                                            <c:when test="${empty sessionScope.customer.gender}">Chưa cập nhật</c:when>
                                            <c:otherwise>Khác</c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <!-- Birthday -->
                        <div class="profile-info-card bg-spa-cream/50 border border-primary/10 rounded-lg p-4 hover:shadow-md transition-all duration-200">
                            <div class="flex items-center gap-3 mb-2">
                                <i data-lucide="calendar" class="h-5 w-5 text-orange-600"></i>
                                <span class="text-sm font-medium text-gray-600">Ngày sinh</span>
                            </div>
                            <p class="text-lg font-semibold text-spa-dark">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user}">
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.user.birthday}">
                                                <fmt:formatDate value="${sessionScope.user.birthday}" pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-gray-400">Chưa cập nhật</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.customer.birthday}">
                                                <fmt:formatDate value="${sessionScope.customer.birthday}" pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-gray-400">Chưa cập nhật</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <!-- Account Status -->
                        <div class="profile-info-card bg-spa-cream/50 border border-primary/10 rounded-lg p-4 hover:shadow-md transition-all duration-200">
                            <div class="flex items-center gap-3 mb-2">
                                <i data-lucide="shield-check" class="h-5 w-5 text-green-600"></i>
                                <span class="text-sm font-medium text-gray-600">Trạng thái tài khoản</span>
                            </div>
                            <p class="text-lg font-semibold text-spa-dark">
                                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-green-100 text-green-800">
                                    <i data-lucide="check-circle" class="h-4 w-4 mr-1"></i>
                                    Đang hoạt động
                                </span>
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Stats for Customers -->
            <c:if test="${not empty sessionScope.customer}">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <!-- Appointments Stats -->
                    <div class="profile-stat-card bg-white rounded-xl shadow-md border border-primary/10 p-6 text-center hover:shadow-lg transition-all duration-200">
                        <div class="flex flex-col items-center">
                            <div class="w-12 h-12 bg-primary/10 rounded-full flex items-center justify-center mb-3">
                                <i data-lucide="calendar" class="h-6 w-6 text-primary"></i>
                            </div>
                            <h3 class="text-2xl font-bold text-primary mb-1">0</h3>
                            <p class="text-sm text-gray-600">Lịch hẹn</p>
                        </div>
                    </div>

                    <!-- Loyalty Points Stats -->
                    <div class="profile-stat-card bg-white rounded-xl shadow-md border border-primary/10 p-6 text-center hover:shadow-lg transition-all duration-200">
                        <div class="flex flex-col items-center">
                            <div class="w-12 h-12 bg-yellow-100 rounded-full flex items-center justify-center mb-3">
                                <i data-lucide="star" class="h-6 w-6 text-yellow-600"></i>
                            </div>
                            <h3 class="text-2xl font-bold text-yellow-600 mb-1">0</h3>
                            <p class="text-sm text-gray-600">Điểm tích lũy</p>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Action Buttons -->
            <div class="bg-white rounded-xl shadow-md border border-primary/10 overflow-hidden">
                <div class="p-6 border-b border-gray-200">
                    <h2 class="text-xl font-semibold text-spa-dark flex items-center gap-2">
                        <i data-lucide="settings" class="h-6 w-6 text-primary"></i>
                        Hành động nhanh
                    </h2>
                </div>
                <div class="p-6 space-y-4">
                    <!-- Change Password -->
                    <a href="${pageContext.request.contextPath}/password/change"
                       class="w-full inline-flex items-center justify-center px-4 py-3 text-sm font-medium text-white bg-primary rounded-md hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-primary/20 transition-colors duration-200">
                        <i data-lucide="key" class="h-4 w-4 mr-2"></i>
                        Đổi mật khẩu
                    </a>

                    
                   
                </div>
            </div>
        </div>
    </main>

    <!-- JavaScript -->
    <script>
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

            // Add hover effects to profile cards
            const profileCards = document.querySelectorAll('.profile-info-card, .profile-stat-card');
            profileCards.forEach(function(card) {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-2px)';
                });

                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });
        });

        console.log('Profile Page Loaded Successfully');
    </script>

</body>
</html>
