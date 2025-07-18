<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Nhân Viên - Dashboard</title>

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
    
    <style>
        .info-card {
            @apply bg-white rounded-xl shadow-lg p-6 border border-gray-100;
        }
        .info-label {
            @apply text-sm font-medium text-gray-500 mb-2 block;
        }
        .info-value {
            @apply text-lg font-semibold text-gray-900;
        }
        .status-badge {
            @apply inline-flex items-center px-3 py-1 rounded-full text-sm font-medium;
        }
        .status-active {
            @apply bg-green-100 text-green-800;
        }
        .status-inactive {
            @apply bg-red-100 text-red-800;
        }
        .role-badge {
            @apply inline-flex items-center px-3 py-1 rounded-full text-sm font-medium;
        }
        .role-admin {
            @apply bg-purple-100 text-purple-800;
        }
        .role-manager {
            @apply bg-blue-100 text-blue-800;
        }
        .role-therapist {
            @apply bg-green-100 text-green-800;
        }
        .role-receptionist {
            @apply bg-yellow-100 text-yellow-800;
        }
        .role-marketing {
            @apply bg-pink-100 text-pink-800;
        }
        .role-inventory {
            @apply bg-orange-100 text-orange-800;
        }
    </style>
</head>

<body class="bg-spa-cream font-sans min-h-screen">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    
    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

        <main class="flex-1 py-12 lg:py-20 ml-64">
            <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">

                <!-- Breadcrumb -->
                <div class="flex flex-wrap items-center gap-2 mb-8 text-gray-500 text-sm">
                    <a href="${pageContext.request.contextPath}/user-management/list" class="flex items-center gap-1 hover:text-primary">
                        <i data-lucide="users" class="w-4 h-4"></i>
                        Danh sách nhân viên
                    </a>
                    <span>-</span>
                    <span class="text-primary font-semibold">${user.fullName}</span>
                </div>

                <!-- Flash Messages -->
                <c:if test="${not empty sessionScope.flash_success}">
                    <div class="mb-6 bg-green-100 border-l-4 border-green-500 text-green-700 p-4 rounded-lg" role="alert">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <i data-lucide="check-circle" class="w-5 h-5 text-green-500"></i>
                            </div>
                            <div class="ml-3">
                                <p class="text-sm font-medium">${sessionScope.flash_success}</p>
                            </div>
                        </div>
                    </div>
                    <c:remove var="flash_success" scope="session" />
                </c:if>

                <c:if test="${not empty sessionScope.flash_error}">
                    <div class="mb-6 bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded-lg" role="alert">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <i data-lucide="alert-circle" class="w-5 h-5 text-red-500"></i>
                            </div>
                            <div class="ml-3">
                                <p class="text-sm font-medium">${sessionScope.flash_error}</p>
                            </div>
                        </div>
                    </div>
                    <c:remove var="flash_error" scope="session" />
                </c:if>

                <!-- User Profile Header -->
                <div class="bg-white rounded-2xl shadow-lg overflow-hidden mb-8">
                    <div class="bg-gradient-to-r from-primary to-primary-dark p-8">
                        <div class="flex items-center space-x-6">
                            <!-- Avatar -->
                            <div class="flex-shrink-0">
                                <div class="w-24 h-24 rounded-full bg-white/20 flex items-center justify-center">
                                    <span class="text-white font-bold text-3xl">
                                        ${user.fullName.substring(0, 1).toUpperCase()}
                                    </span>
                                </div>
                            </div>
                            
                            <!-- User Info -->
                            <div class="flex-1">
                                <h1 class="text-3xl font-bold text-white mb-2">${user.fullName}</h1>
                                <div class="flex items-center space-x-4 text-white/90">
                                    <div class="flex items-center">
                                        <i data-lucide="mail" class="w-5 h-5 mr-2"></i>
                                        ${user.email}
                                    </div>
                                    <c:if test="${not empty user.phoneNumber}">
                                        <div class="flex items-center">
                                            <i data-lucide="phone" class="w-5 h-5 mr-2"></i>
                                            ${user.phoneNumber}
                                        </div>
                                    </c:if>
                                </div>
                                <div class="flex items-center space-x-4 mt-4">
                                    <!-- Role Badge -->
                                    <c:choose>
                                        <c:when test="${user.roleId == 1}">
                                            <span class="role-badge role-admin">
                                                <i data-lucide="crown" class="w-4 h-4 mr-2"></i>
                                                Admin
                                            </span>
                                        </c:when>
                                        <c:when test="${user.roleId == 2}">
                                            <span class="role-badge role-manager">
                                                <i data-lucide="briefcase" class="w-4 h-4 mr-2"></i>
                                                Manager
                                            </span>
                                        </c:when>
                                        <c:when test="${user.roleId == 3}">
                                            <span class="role-badge role-therapist">
                                                <i data-lucide="heart-handshake" class="w-4 h-4 mr-2"></i>
                                                Therapist
                                            </span>
                                        </c:when>
                                        <c:when test="${user.roleId == 4}">
                                            <span class="role-badge role-receptionist">
                                                <i data-lucide="headphones" class="w-4 h-4 mr-2"></i>
                                                Receptionist
                                            </span>
                                        </c:when>
                                        <c:when test="${user.roleId == 6}">
                                            <span class="role-badge role-marketing">
                                                <i data-lucide="megaphone" class="w-4 h-4 mr-2"></i>
                                                Marketing
                                            </span>
                                        </c:when>
                                        <c:when test="${user.roleId == 7}">
                                            <span class="role-badge role-inventory">
                                                <i data-lucide="package" class="w-4 h-4 mr-2"></i>
                                                Inventory Manager
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="role-badge bg-gray-100 text-gray-800">
                                                <i data-lucide="user" class="w-4 h-4 mr-2"></i>
                                                Khác
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <!-- Status Badge -->
                                    <c:choose>
                                        <c:when test="${user.isActive}">
                                            <span class="status-badge status-active">
                                                <i data-lucide="check-circle" class="w-4 h-4 mr-2"></i>
                                                Hoạt động
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-inactive">
                                                <i data-lucide="x-circle" class="w-4 h-4 mr-2"></i>
                                                Tạm khóa
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- User Details Grid -->
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                    
                    <!-- Personal Information -->
                    <div class="lg:col-span-2">
                        <div class="info-card">
                            <h2 class="text-xl font-bold text-spa-dark mb-6 flex items-center gap-2">
                                <i data-lucide="user-circle" class="w-6 h-6 text-primary"></i>
                                Thông tin cá nhân
                            </h2>
                            
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                    <label class="info-label">Mã nhân viên</label>
                                    <p class="info-value">#${user.userId}</p>
                                </div>
                                
                                <div>
                                    <label class="info-label">Họ và tên</label>
                                    <p class="info-value">${user.fullName}</p>
                                </div>
                                
                                <div>
                                    <label class="info-label">Email</label>
                                    <p class="info-value">${user.email}</p>
                                </div>
                                
                                <div>
                                    <label class="info-label">Số điện thoại</label>
                                    <p class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty user.phoneNumber}">
                                                ${user.phoneNumber}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-gray-400 italic">Chưa cập nhật</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                                
                                <div>
                                    <label class="info-label">Giới tính</label>
                                    <p class="info-value">
                                        <c:choose>
                                            <c:when test="${user.gender == 'MALE'}">Nam</c:when>
                                            <c:when test="${user.gender == 'FEMALE'}">Nữ</c:when>
                                            <c:when test="${user.gender == 'OTHER'}">Khác</c:when>
                                            <c:otherwise>Không xác định</c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                                
                                <div>
                                    <label class="info-label">Ngày sinh</label>
                                    <p class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty user.birthday}">
                                                <fmt:formatDate value="${user.birthday}" pattern="dd/MM/yyyy" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-gray-400 italic">Chưa cập nhật</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                                
                                <div class="md:col-span-2">
                                    <label class="info-label">Địa chỉ</label>
                                    <p class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty user.address}">
                                                ${user.address}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-gray-400 italic">Chưa cập nhật</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- System Information -->
                    <div class="space-y-6">
                        <!-- Account Status -->
                        <div class="info-card">
                            <h3 class="text-lg font-bold text-spa-dark mb-4 flex items-center gap-2">
                                <i data-lucide="activity" class="w-5 h-5 text-primary"></i>
                                Trạng thái tài khoản
                            </h3>
                            
                            <div class="space-y-4">
                                <div>
                                    <label class="info-label">Trạng thái</label>
                                    <c:choose>
                                        <c:when test="${user.isActive}">
                                            <span class="status-badge status-active">
                                                <i data-lucide="check-circle" class="w-4 h-4 mr-2"></i>
                                                Hoạt động
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-inactive">
                                                <i data-lucide="x-circle" class="w-4 h-4 mr-2"></i>
                                                Tạm khóa
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div>
                                    <label class="info-label">Ngày tạo</label>
                                    <p class="info-value">
                                        <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                    </p>
                                </div>
                                
                                <div>
                                    <label class="info-label">Cập nhật lần cuối</label>
                                    <p class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty user.updatedAt}">
                                                <fmt:formatDate value="${user.updatedAt}" pattern="dd/MM/yyyy HH:mm" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-gray-400 italic">Chưa cập nhật</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Role Information -->
                        <div class="info-card">
                            <h3 class="text-lg font-bold text-spa-dark mb-4 flex items-center gap-2">
                                <i data-lucide="shield" class="w-5 h-5 text-primary"></i>
                                Vai trò & Quyền hạn
                            </h3>
                            
                            <div class="space-y-4">
                                <div>
                                    <label class="info-label">Vai trò</label>
                                    <c:choose>
                                        <c:when test="${user.roleId == 1}">
                                            <span class="role-badge role-admin">
                                                <i data-lucide="crown" class="w-4 h-4 mr-2"></i>
                                                Admin
                                            </span>
                                        </c:when>
                                        <c:when test="${user.roleId == 2}">
                                            <span class="role-badge role-manager">
                                                <i data-lucide="briefcase" class="w-4 h-4 mr-2"></i>
                                                Manager
                                            </span>
                                        </c:when>
                                        <c:when test="${user.roleId == 3}">
                                            <span class="role-badge role-therapist">
                                                <i data-lucide="heart-handshake" class="w-4 h-4 mr-2"></i>
                                                Therapist
                                            </span>
                                        </c:when>
                                        <c:when test="${user.roleId == 4}">
                                            <span class="role-badge role-receptionist">
                                                <i data-lucide="headphones" class="w-4 h-4 mr-2"></i>
                                                Receptionist
                                            </span>
                                        </c:when>
                                        <c:when test="${user.roleId == 6}">
                                            <span class="role-badge role-marketing">
                                                <i data-lucide="megaphone" class="w-4 h-4 mr-2"></i>
                                                Marketing
                                            </span>
                                        </c:when>
                                        <c:when test="${user.roleId == 7}">
                                            <span class="role-badge role-inventory">
                                                <i data-lucide="package" class="w-4 h-4 mr-2"></i>
                                                Inventory Manager
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="role-badge bg-gray-100 text-gray-800">
                                                <i data-lucide="user" class="w-4 h-4 mr-2"></i>
                                                Khác
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div>
                                    <label class="info-label">Mô tả quyền hạn</label>
                                    <p class="text-sm text-gray-600">
                                        <c:choose>
                                            <c:when test="${user.roleId == 1}">
                                                Quản trị viên hệ thống với quyền hạn cao nhất
                                            </c:when>
                                            <c:when test="${user.roleId == 2}">
                                                Quản lý spa, có quyền quản lý nhân viên và hoạt động
                                            </c:when>
                                            <c:when test="${user.roleId == 3}">
                                                Chuyên viên trị liệu, thực hiện các dịch vụ spa
                                            </c:when>
                                            <c:when test="${user.roleId == 4}">
                                                Nhân viên lễ tân, tiếp đón và hỗ trợ khách hàng
                                            </c:when>
                                            <c:when test="${user.roleId == 6}">
                                                Nhân viên marketing, quản lý quảng cáo và khuyến mãi
                                            </c:when>
                                            <c:when test="${user.roleId == 7}">
                                                Quản lý kho, theo dõi và quản lý tồn kho
                                            </c:when>
                                            <c:otherwise>
                                                Vai trò không xác định
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="mt-8 flex flex-col sm:flex-row gap-4 justify-center">
                    <!-- Edit Button -->
                    <c:if test="${currentUser.roleId == 1 || (currentUser.roleId == 2 && user.roleId > 2) || user.userId == currentUser.userId}">
                        <a href="${pageContext.request.contextPath}/user-management/edit?id=${user.userId}" 
                           class="inline-flex items-center px-6 py-3 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors font-semibold shadow-lg">
                            <i data-lucide="edit" class="w-5 h-5 mr-2"></i>
                            Chỉnh sửa thông tin
                        </a>
                    </c:if>

                    <!-- Activate/Deactivate Button -->
                    <c:if test="${currentUser.roleId == 1 || (currentUser.roleId == 2 && user.roleId > 2)}">
                        <c:choose>
                            <c:when test="${user.isActive}">
                                <form method="post" action="${pageContext.request.contextPath}/user-management/deactivate" class="inline">
                                    <input type="hidden" name="userId" value="${user.userId}" />
                                    <button type="submit" 
                                            class="inline-flex items-center px-6 py-3 bg-orange-600 text-white rounded-lg hover:bg-orange-700 transition-colors font-semibold shadow-lg"
                                            onclick="return confirm('Bạn có chắc muốn tạm khóa nhân viên này?')">
                                        <i data-lucide="user-x" class="w-5 h-5 mr-2"></i>
                                        Tạm khóa
                                    </button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <form method="post" action="${pageContext.request.contextPath}/user-management/activate" class="inline">
                                    <input type="hidden" name="userId" value="${user.userId}" />
                                    <button type="submit" 
                                            class="inline-flex items-center px-6 py-3 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors font-semibold shadow-lg">
                                        <i data-lucide="user-check" class="w-5 h-5 mr-2"></i>
                                        Kích hoạt
                                    </button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </c:if>

                    <!-- Delete Button (Admin only) -->
                    <c:if test="${currentUser.roleId == 1 && user.userId != currentUser.userId}">
                        <form method="post" action="${pageContext.request.contextPath}/user-management/delete" class="inline">
                            <input type="hidden" name="userId" value="${user.userId}" />
                            <button type="submit" 
                                    class="inline-flex items-center px-6 py-3 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors font-semibold shadow-lg"
                                    onclick="return confirm('Bạn có chắc muốn xóa nhân viên này? Hành động này không thể hoàn tác!')">
                                <i data-lucide="trash-2" class="w-5 h-5 mr-2"></i>
                                Xóa nhân viên
                            </button>
                        </form>
                    </c:if>

                    <!-- Back Button -->
                    <a href="${pageContext.request.contextPath}/user-management/list" 
                       class="inline-flex items-center px-6 py-3 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors font-semibold shadow-lg">
                        <i data-lucide="arrow-left" class="w-5 h-5 mr-2"></i>
                        Quay lại danh sách
                    </a>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Initialize Lucide icons
        lucide.createIcons();
        
        // Confirm actions
        document.querySelectorAll('form[action*="/activate"], form[action*="/deactivate"]').forEach(form => {
            form.addEventListener('submit', function(e) {
                const action = form.action.includes('activate') ? 'kích hoạt' : 'tạm khóa';
                if (!confirm(`Bạn có chắc muốn ${action} nhân viên này?`)) {
                    e.preventDefault();
                }
            });
        });
        
        document.querySelectorAll('form[action*="/delete"]').forEach(form => {
            form.addEventListener('submit', function(e) {
                if (!confirm('Bạn có chắc muốn xóa nhân viên này? Hành động này không thể hoàn tác!')) {
                    e.preventDefault();
                }
            });
        });
    </script>
</body>
</html> 