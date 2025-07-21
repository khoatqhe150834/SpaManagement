<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Nhân Viên - Dashboard</title>

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
        .status-badge {
            @apply inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium;
        }
        .status-active {
            @apply bg-green-100 text-green-800;
        }
        .status-inactive {
            @apply bg-red-100 text-red-800;
        }
        .role-badge {
            @apply inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium;
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
        .table-row:hover {
            @apply bg-gray-50 transition-colors;
        }
    </style>
</head>

<body class="bg-spa-cream font-sans min-h-screen">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    
    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

        <main class="flex-1 py-12 lg:py-20 ml-64">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">

                <!-- Page Header -->
                <div class="mb-8">
                    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between">
                        <div>
                            <h1 class="text-3xl font-bold text-spa-dark flex items-center gap-2">
                                <i data-lucide="users" class="w-8 h-8 text-primary"></i>
                                Quản Lý Nhân Viên
                            </h1>
                            <p class="mt-2 text-gray-600">Quản lý thông tin và quyền hạn của nhân viên trong hệ thống</p>
                        </div>
                        
                        <!-- Add User Button -->
                        <c:if test="${currentUser.roleId == 1 || currentUser.roleId == 2}">
                            <div class="mt-4 sm:mt-0">
                                <a href="${pageContext.request.contextPath}/user-management/add" 
                                   class="inline-flex items-center px-6 py-3 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors font-semibold shadow-lg">
                                    <i data-lucide="user-plus" class="w-5 h-5 mr-2"></i>
                                    Thêm Nhân Viên
                                </a>
                            </div>
                        </c:if>
                    </div>
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

                <!-- Search and Filter Section -->
                <div class="bg-white rounded-2xl shadow-lg p-6 mb-8">
                    <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
                        <!-- Search Form -->
                        <div class="flex-1 max-w-md">
                            <form method="get" class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i data-lucide="search" class="w-5 h-5 text-gray-400"></i>
                                </div>
                                <input type="text" 
                                       name="search" 
                                       placeholder="Tìm kiếm tên, email, SĐT..." 
                                       class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-colors"
                                       value="${param.search}">
                            </form>
                        </div>

                        <!-- Filter Options -->
                        <div class="flex flex-wrap gap-2">
                            <button onclick="filterByRole('all')" 
                                    class="filter-btn px-4 py-2 rounded-lg border border-gray-300 hover:bg-gray-50 transition-colors text-sm font-medium">
                                Tất cả
                            </button>
                            <button onclick="filterByRole('2')" 
                                    class="filter-btn px-4 py-2 rounded-lg border border-gray-300 hover:bg-gray-50 transition-colors text-sm font-medium">
                                Manager
                            </button>
                            <button onclick="filterByRole('3')" 
                                    class="filter-btn px-4 py-2 rounded-lg border border-gray-300 hover:bg-gray-50 transition-colors text-sm font-medium">
                                Therapist
                            </button>
                            <button onclick="filterByRole('4')" 
                                    class="filter-btn px-4 py-2 rounded-lg border border-gray-300 hover:bg-gray-50 transition-colors text-sm font-medium">
                                Receptionist
                            </button>
                            <button onclick="filterByRole('6')" 
                                    class="filter-btn px-4 py-2 rounded-lg border border-gray-300 hover:bg-gray-50 transition-colors text-sm font-medium">
                                Marketing
                            </button>
                            <button onclick="filterByRole('7')" 
                                    class="filter-btn px-4 py-2 rounded-lg border border-gray-300 hover:bg-gray-50 transition-colors text-sm font-medium">
                                Inventory
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Users Table -->
                <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
                    <div class="bg-gradient-to-r from-primary to-primary-dark p-6">
                        <h2 class="text-xl font-bold text-white flex items-center gap-2">
                            <i data-lucide="list" class="w-6 h-6"></i>
                            Danh Sách Nhân Viên
                        </h2>
                        <p class="text-white/90 mt-1">Tổng cộng có ${users.size()} nhân viên</p>
                    </div>

                    <c:choose>
                        <c:when test="${empty users}">
                            <div class="p-12 text-center">
                                <i data-lucide="users" class="w-16 h-16 text-gray-400 mx-auto mb-4"></i>
                                <h3 class="text-lg font-medium text-gray-900 mb-2">Không có nhân viên nào</h3>
                                <p class="text-gray-500 mb-6">Chưa có nhân viên nào trong hệ thống.</p>
                                <c:if test="${currentUser.roleId == 1 || currentUser.roleId == 2}">
                                    <a href="${pageContext.request.contextPath}/user-management/add" 
                                       class="inline-flex items-center px-6 py-3 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors font-semibold">
                                        <i data-lucide="user-plus" class="w-5 h-5 mr-2"></i>
                                        Thêm Nhân Viên Đầu Tiên
                                    </a>
                                </c:if>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="overflow-x-auto">
                                <table class="min-w-full divide-y divide-gray-200">
                                    <thead class="bg-gray-50">
                                        <tr>
                                            <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                <div class="flex items-center gap-2">
                                                    <span>Nhân viên</span>
                                                    <div class="flex flex-col">
                                                        <button onclick="sortTable('name', 'asc')" class="sort-btn ${sortBy == 'name' && sortOrder == 'asc' ? 'text-primary' : 'text-gray-400'} hover:text-primary">
                                                            <i data-lucide="chevron-up" class="w-3 h-3"></i>
                                                        </button>
                                                        <button onclick="sortTable('name', 'desc')" class="sort-btn ${sortBy == 'name' && sortOrder == 'desc' ? 'text-primary' : 'text-gray-400'} hover:text-primary">
                                                            <i data-lucide="chevron-down" class="w-3 h-3"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </th>
                                            <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                <div class="flex items-center gap-2">
                                                    <span>Liên hệ</span>
                                                    <div class="flex flex-col">
                                                        <button onclick="sortTable('email', 'asc')" class="sort-btn ${sortBy == 'email' && sortOrder == 'asc' ? 'text-primary' : 'text-gray-400'} hover:text-primary">
                                                            <i data-lucide="chevron-up" class="w-3 h-3"></i>
                                                        </button>
                                                        <button onclick="sortTable('email', 'desc')" class="sort-btn ${sortBy == 'email' && sortOrder == 'desc' ? 'text-primary' : 'text-gray-400'} hover:text-primary">
                                                            <i data-lucide="chevron-down" class="w-3 h-3"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </th>
                                            <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                <div class="flex items-center gap-2">
                                                    <span>Vai trò</span>
                                                    <div class="flex flex-col">
                                                        <button onclick="sortTable('role', 'asc')" class="sort-btn ${sortBy == 'role' && sortOrder == 'asc' ? 'text-primary' : 'text-gray-400'} hover:text-primary">
                                                            <i data-lucide="chevron-up" class="w-3 h-3"></i>
                                                        </button>
                                                        <button onclick="sortTable('role', 'desc')" class="sort-btn ${sortBy == 'role' && sortOrder == 'desc' ? 'text-primary' : 'text-gray-400'} hover:text-primary">
                                                            <i data-lucide="chevron-down" class="w-3 h-3"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </th>
                                            <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                Trạng thái
                                            </th>
                                            <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                <div class="flex items-center gap-2">
                                                    <span>Ngày tạo</span>
                                                    <div class="flex flex-col">
                                                        <button onclick="sortTable('created', 'asc')" class="sort-btn ${sortBy == 'created' && sortOrder == 'asc' ? 'text-primary' : 'text-gray-400'} hover:text-primary">
                                                            <i data-lucide="chevron-up" class="w-3 h-3"></i>
                                                        </button>
                                                        <button onclick="sortTable('created', 'desc')" class="sort-btn ${sortBy == 'created' && sortOrder == 'desc' ? 'text-primary' : 'text-gray-400'} hover:text-primary">
                                                            <i data-lucide="chevron-down" class="w-3 h-3"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </th>
                                            <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                                Thao tác
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody class="bg-white divide-y divide-gray-200">
                                        <c:forEach items="${users}" var="user">
                                            <tr class="table-row user-row" data-role="${user.roleId}">
                                                <!-- User Info -->
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <div class="flex items-center">
                                                        <div class="flex-shrink-0 h-12 w-12">
                                                            <div class="h-12 w-12 rounded-full bg-gradient-to-br from-primary to-primary-dark flex items-center justify-center">
                                                                <span class="text-white font-semibold text-lg">
                                                                    ${user.fullName.substring(0, 1).toUpperCase()}
                                                                </span>
                                                            </div>
                                                        </div>
                                                        <div class="ml-4">
                                                            <div class="text-sm font-medium text-gray-900">
                                                                ${user.fullName}
                                                            </div>
                                                            <div class="text-sm text-gray-500">
                                                                ID: ${user.userId}
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>

                                                <!-- Contact Info -->
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <div class="text-sm text-gray-900">${user.email}</div>
                                                    <div class="text-sm text-gray-500">
                                                        <c:choose>
                                                            <c:when test="${not empty user.phoneNumber}">
                                                                ${user.phoneNumber}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-gray-400">Chưa có SĐT</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>

                                                <!-- Role -->
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <c:choose>
                                                        <c:when test="${user.roleId == 1}">
                                                            <span class="role-badge role-admin">
                                                                <i data-lucide="crown" class="w-3 h-3 mr-1"></i>
                                                                Admin
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${user.roleId == 2}">
                                                            <span class="role-badge role-manager">
                                                                <i data-lucide="briefcase" class="w-3 h-3 mr-1"></i>
                                                                Manager
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${user.roleId == 3}">
                                                            <span class="role-badge role-therapist">
                                                                <i data-lucide="heart-handshake" class="w-3 h-3 mr-1"></i>
                                                                Therapist
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${user.roleId == 4}">
                                                            <span class="role-badge role-receptionist">
                                                                <i data-lucide="headphones" class="w-3 h-3 mr-1"></i>
                                                                Receptionist
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${user.roleId == 6}">
                                                            <span class="role-badge role-marketing">
                                                                <i data-lucide="megaphone" class="w-3 h-3 mr-1"></i>
                                                                Marketing
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${user.roleId == 7}">
                                                            <span class="role-badge role-inventory">
                                                                <i data-lucide="package" class="w-3 h-3 mr-1"></i>
                                                                Inventory
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="role-badge bg-gray-100 text-gray-800">
                                                                <i data-lucide="user" class="w-3 h-3 mr-1"></i>
                                                                Khác
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <!-- Status -->
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <c:choose>
                                                        <c:when test="${user.isActive}">
                                                            <span class="status-badge status-active">
                                                                <i data-lucide="check-circle" class="w-3 h-3 mr-1"></i>
                                                                Hoạt động
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-inactive">
                                                                <i data-lucide="x-circle" class="w-3 h-3 mr-1"></i>
                                                                Tạm khóa
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <!-- Created Date -->
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                    <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy" />
                                                </td>

                                                <!-- Actions -->
                                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                                    <div class="flex items-center space-x-2">
                                                        <!-- View Button -->
                                                        <a href="${pageContext.request.contextPath}/user-management/view?id=${user.userId}" 
                                                           class="text-blue-600 hover:text-blue-900 p-1 rounded-lg hover:bg-blue-50 transition-colors"
                                                           title="Xem chi tiết">
                                                            <i data-lucide="eye" class="w-4 h-4"></i>
                                                        </a>

                                                        <!-- Edit Button -->
                                                        <c:if test="${currentUser.roleId == 1 || (currentUser.roleId == 2 && user.roleId > 2) || user.userId == currentUser.userId}">
                                                            <a href="${pageContext.request.contextPath}/user-management/edit?id=${user.userId}" 
                                                               class="text-green-600 hover:text-green-900 p-1 rounded-lg hover:bg-green-50 transition-colors"
                                                               title="Chỉnh sửa">
                                                                <i data-lucide="edit" class="w-4 h-4"></i>
                                                            </a>
                                                        </c:if>

                                                        <!-- Activate/Deactivate Button -->
                                                        <c:if test="${currentUser.roleId == 1 || (currentUser.roleId == 2 && user.roleId > 2)}">
                                                            <c:choose>
                                                                <c:when test="${user.isActive}">
                                                                    <form method="post" action="${pageContext.request.contextPath}/user-management/deactivate" class="inline">
                                                                        <input type="hidden" name="userId" value="${user.userId}" />
                                                                        <button type="submit" 
                                                                                class="text-orange-600 hover:text-orange-900 p-1 rounded-lg hover:bg-orange-50 transition-colors"
                                                                                title="Tạm khóa"
                                                                                onclick="return confirm('Bạn có chắc muốn tạm khóa nhân viên này?')">
                                                                            <i data-lucide="user-x" class="w-4 h-4"></i>
                                                                        </button>
                                                                    </form>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <form method="post" action="${pageContext.request.contextPath}/user-management/activate" class="inline">
                                                                        <input type="hidden" name="userId" value="${user.userId}" />
                                                                        <button type="submit" 
                                                                                class="text-green-600 hover:text-green-900 p-1 rounded-lg hover:bg-green-50 transition-colors"
                                                                                title="Kích hoạt">
                                                                            <i data-lucide="user-check" class="w-4 h-4"></i>
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
                                                                        class="text-red-600 hover:text-red-900 p-1 rounded-lg hover:bg-red-50 transition-colors"
                                                                        title="Xóa nhân viên"
                                                                        onclick="return confirm('Bạn có chắc muốn xóa nhân viên này? Hành động này không thể hoàn tác!')">
                                                                    <i data-lucide="trash-2" class="w-4 h-4"></i>
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Quick Stats -->
                <div class="mt-8 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <div class="bg-white rounded-xl shadow-lg p-6">
                        <div class="flex items-center">
                            <div class="flex-shrink-0">
                                <div class="w-8 h-8 bg-green-100 rounded-lg flex items-center justify-center">
                                    <i data-lucide="users" class="w-5 h-5 text-green-600"></i>
                                </div>
                            </div>
                            <div class="ml-4">
                                <p class="text-sm font-medium text-gray-500">Tổng nhân viên</p>
                                <p class="text-2xl font-bold text-gray-900">${users.size()}</p>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-xl shadow-lg p-6">
                        <div class="flex items-center">
                            <div class="flex-shrink-0">
                                <div class="w-8 h-8 bg-green-100 rounded-lg flex items-center justify-center">
                                    <i data-lucide="check-circle" class="w-5 h-5 text-green-600"></i>
                                </div>
                            </div>
                            <div class="ml-4">
                                <p class="text-sm font-medium text-gray-500">Đang hoạt động</p>
                                <p class="text-2xl font-bold text-gray-900">
                                    <c:set var="activeCount" value="0" />
                                    <c:forEach items="${users}" var="user">
                                        <c:if test="${user.isActive}">
                                            <c:set var="activeCount" value="${activeCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${activeCount}
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-xl shadow-lg p-6">
                        <div class="flex items-center">
                            <div class="flex-shrink-0">
                                <div class="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center">
                                    <i data-lucide="briefcase" class="w-5 h-5 text-blue-600"></i>
                                </div>
                            </div>
                            <div class="ml-4">
                                <p class="text-sm font-medium text-gray-500">Manager</p>
                                <p class="text-2xl font-bold text-gray-900">
                                    <c:set var="managerCount" value="0" />
                                    <c:forEach items="${users}" var="user">
                                        <c:if test="${user.roleId == 2}">
                                            <c:set var="managerCount" value="${managerCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${managerCount}
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-xl shadow-lg p-6">
                        <div class="flex items-center">
                            <div class="flex-shrink-0">
                                <div class="w-8 h-8 bg-purple-100 rounded-lg flex items-center justify-center">
                                    <i data-lucide="heart-handshake" class="w-5 h-5 text-purple-600"></i>
                                </div>
                            </div>
                            <div class="ml-4">
                                <p class="text-sm font-medium text-gray-500">Therapist</p>
                                <p class="text-2xl font-bold text-gray-900">
                                    <c:set var="therapistCount" value="0" />
                                    <c:forEach items="${users}" var="user">
                                        <c:if test="${user.roleId == 3}">
                                            <c:set var="therapistCount" value="${therapistCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${therapistCount}
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Initialize Lucide icons
        lucide.createIcons();
        
        // Filter functionality
        function filterByRole(roleId) {
            const rows = document.querySelectorAll('.user-row');
            const filterButtons = document.querySelectorAll('.filter-btn');
            
            // Update button states
            filterButtons.forEach(btn => {
                btn.classList.remove('bg-primary', 'text-white');
                btn.classList.add('border-gray-300', 'hover:bg-gray-50');
            });
            
            // Highlight active button
            event.target.classList.remove('border-gray-300', 'hover:bg-gray-50');
            event.target.classList.add('bg-primary', 'text-white');
            
            // Filter rows
            rows.forEach(row => {
                if (roleId === 'all') {
                    row.style.display = '';
                } else {
                    const userRole = row.getAttribute('data-role');
                    row.style.display = userRole === roleId ? '' : 'none';
                }
            });
        }
        
        // Search functionality
        document.querySelector('input[name="search"]').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const rows = document.querySelectorAll('.user-row');
            
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchTerm) ? '' : 'none';
            });
        });
        
        // Auto-submit search form on Enter
        document.querySelector('input[name="search"]').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.target.form.submit();
            }
        });
        
        // Confirm delete actions
        document.querySelectorAll('form[action*="/delete"]').forEach(form => {
            form.addEventListener('submit', function(e) {
                if (!confirm('Bạn có chắc muốn xóa nhân viên này? Hành động này không thể hoàn tác!')) {
                    e.preventDefault();
                }
            });
        });
        
        // Confirm status change actions
        document.querySelectorAll('form[action*="/activate"], form[action*="/deactivate"]').forEach(form => {
            form.addEventListener('submit', function(e) {
                const action = form.action.includes('activate') ? 'kích hoạt' : 'tạm khóa';
                if (!confirm(`Bạn có chắc muốn ${action} nhân viên này?`)) {
                    e.preventDefault();
                }
            });
        });
        
        // Sort table function
        function sortTable(sortBy, sortOrder) {
            const currentUrl = new URL(window.location);
            currentUrl.searchParams.set('sortBy', sortBy);
            currentUrl.searchParams.set('sortOrder', sortOrder);
            window.location.href = currentUrl.toString();
        }
    </script>
</body>
</html> 