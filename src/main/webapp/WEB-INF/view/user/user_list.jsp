<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    // Validate pageSize để tránh HTML lỗi trong dropdown
    Object pageSizeObj = request.getAttribute("pageSize");
    String pageSizeStr = pageSizeObj != null ? pageSizeObj.toString() : "10";
    if (!pageSizeStr.matches("5|10|20|50|100|all")) {
        pageSizeStr = "10";
    }
    request.setAttribute("pageSize", pageSizeStr);
%>

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
                <div class="flex flex-wrap items-center justify-between gap-4 mb-8">
                    <h1 class="text-3xl font-serif text-spa-dark font-bold">Quản Lý Nhân Viên</h1>
                    <div class="flex gap-2">
                        <a href="${pageContext.request.contextPath}/user-management/add" 
                           class="inline-flex items-center gap-2 h-10 px-4 bg-green-100 text-green-800 font-semibold rounded-lg hover:bg-green-200 transition-colors">
                            <i data-lucide="user-plus" class="w-5 h-5"></i>
                            <span class="hidden sm:inline">Thêm nhân viên</span>
                        </a>
                    </div>
                </div>

                <!-- Success/Error Messages -->
                <c:if test="${not empty sessionScope.flash_success}">
                    <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6 rounded-lg" role="alert">
                        <p>${sessionScope.flash_success}</p>
                    </div>
                    <c:remove var="flash_success" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.flash_error}">
                    <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-lg" role="alert">
                        <p>${sessionScope.flash_error}</p>
                    </div>
                    <c:remove var="flash_error" scope="session" />
                </c:if>
                <c:if test="${not empty error}">
                    <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-lg" role="alert">
                        <p>${error}</p>
                    </div>
                </c:if>

                <!-- Statistics Cards -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                    <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm text-gray-600">Tổng nhân viên</p>
                                <p class="text-2xl font-bold text-spa-dark">${users.size()}</p>
                            </div>
                            <div class="p-3 bg-blue-100 rounded-lg">
                                <i data-lucide="users" class="w-6 h-6 text-blue-600"></i>
                            </div>
                        </div>
                    </div>
                    <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm text-gray-600">Đang hoạt động</p>
                                <p class="text-2xl font-bold text-green-600">
                                    <c:set var="activeCount" value="0" />
                                    <c:forEach items="${users}" var="user">
                                        <c:if test="${user.isActive}">
                                            <c:set var="activeCount" value="${activeCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${activeCount}
                                </p>
                            </div>
                            <div class="p-3 bg-green-100 rounded-lg">
                                <i data-lucide="user-check" class="w-6 h-6 text-green-600"></i>
                            </div>
                        </div>
                    </div>
                    <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm text-gray-600">Bị khóa</p>
                                <p class="text-2xl font-bold text-red-600">
                                    <c:set var="inactiveCount" value="0" />
                                    <c:forEach items="${users}" var="user">
                                        <c:if test="${!user.isActive}">
                                            <c:set var="inactiveCount" value="${inactiveCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${inactiveCount}
                                </p>
                            </div>
                            <div class="p-3 bg-red-100 rounded-lg">
                                <i data-lucide="user-x" class="w-6 h-6 text-red-600"></i>
                            </div>
                        </div>
                    </div>
                    <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm text-gray-600">Manager</p>
                                <p class="text-2xl font-bold text-blue-600">
                                    <c:set var="managerCount" value="0" />
                                    <c:forEach items="${users}" var="user">
                                        <c:if test="${user.roleId == 2}">
                                            <c:set var="managerCount" value="${managerCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${managerCount}
                                </p>
                            </div>
                            <div class="p-3 bg-blue-100 rounded-lg">
                                <i data-lucide="briefcase" class="w-6 h-6 text-blue-600"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Main Content Card -->
                <div class="bg-white rounded-2xl shadow-lg">
                    <!-- Card Header: Filters and Search -->
                    <div class="p-6 border-b border-gray-200">
                        <form method="GET" action="${pageContext.request.contextPath}/user-management/list" class="flex flex-wrap items-center gap-3 mb-4">
                            <select name="pageSize" class="w-auto h-10 pl-3 pr-8 text-base border rounded-lg" onchange="this.form.submit()">
                                <option value="5" ${pageSize == 5 || pageSize == '5' ? 'selected' : ''}>5</option>
                                <option value="10" ${pageSize == 10 || pageSize == '10' ? 'selected' : ''}>10</option>
                                <option value="20" ${pageSize == 20 || pageSize == '20' ? 'selected' : ''}>20</option>
                                <option value="50" ${pageSize == 50 || pageSize == '50' ? 'selected' : ''}>50</option>
                                <option value="100" ${pageSize == 100 || pageSize == '100' ? 'selected' : ''}>100</option>
                                <option value="all" ${pageSize == 'all' ? 'selected' : ''}>Tất cả</option>
                            </select>
                            <input type="text" name="search" value="${param.search}" placeholder="Tìm kiếm nhân viên..."
                                   class="h-10 px-4 text-base border rounded-lg focus:shadow-outline flex-1 min-w-64">
                            <select name="status" class="h-10 pl-3 pr-8 text-base border rounded-lg">
                                <option value="">Tất cả trạng thái</option>
                                <option value="true">Đang hoạt động</option>
                                <option value="false">Bị khóa</option>
                            </select>
                            <select name="role" class="h-10 pl-3 pr-8 text-base border rounded-lg">
                                <option value="">Tất cả vai trò</option>
                                <option value="2">Manager</option>
                                <option value="3">Therapist</option>
                                <option value="4">Receptionist</option>
                                <option value="6">Marketing</option>
                                <option value="7">Inventory</option>
                            </select>
                            <button type="submit" class="h-10 px-6 bg-primary text-white rounded-lg hover:bg-primary-dark font-medium">
                                <i data-lucide="search" class="w-4 h-4 mr-2 inline"></i>
                                Tìm kiếm
                            </button>
                        </form>
                    </div>
                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="flex justify-center mt-6 gap-1">
                            <c:if test="${currentPage > 1}">
                                <a href="?page=${currentPage - 1}&pageSize=${pageSize}" class="px-3 py-1 bg-gray-200 rounded-l">Trước</a>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a href="?page=${i}&pageSize=${pageSize}" class="px-3 py-1 ${i == currentPage ? 'bg-primary text-white' : 'bg-gray-200'}">${i}</a>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <a href="?page=${currentPage + 1}&pageSize=${pageSize}" class="px-3 py-1 bg-gray-200 rounded-r">Sau</a>
                            </c:if>
                        </div>
                    </c:if>
                    <!-- Table Content -->
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        <input type="checkbox" id="selectAll" class="rounded border-gray-300">
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Thông tin nhân viên
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Liên hệ
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Vai trò
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Trạng thái
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Ngày tạo
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Hành động
                                    </th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach items="${users}" var="user">
                                    <c:if test="${user.roleId != 1}">
                                    <tr class="hover:bg-gray-50">
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <input type="checkbox" name="userIds" value="${user.userId}" class="rounded border-gray-300">
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="flex items-center">
                                                <div class="h-10 w-10 flex-shrink-0">
                                                    <div class="h-10 w-10 rounded-full bg-gradient-to-br from-primary to-primary-dark flex items-center justify-center">
                                                        <span class="text-white font-bold text-lg">${user.fullName.substring(0, 1).toUpperCase()}</span>
                                                    </div>
                                                </div>
                                                <div class="ml-4">
                                                    <div class="text-sm font-medium text-gray-900">${user.fullName}</div>
                                                    <div class="text-sm text-gray-500">ID: ${user.userId}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="text-sm text-gray-900">
                                                <c:if test="${not empty user.email}">
                                                    <div class="flex items-center">
                                                        <i data-lucide="mail" class="w-4 h-4 mr-2 text-gray-400"></i>
                                                        ${user.email}
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty user.phoneNumber}">
                                                    <div class="flex items-center mt-1">
                                                        <i data-lucide="phone" class="w-4 h-4 mr-2 text-gray-400"></i>
                                                        ${user.phoneNumber}
                                                    </div>
                                                </c:if>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <c:choose>
                                                <c:when test="${user.roleId == 2}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                                        <i data-lucide="briefcase" class="w-3 h-3 mr-1"></i>Manager
                                                    </span>
                                                </c:when>
                                                <c:when test="${user.roleId == 3}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                        <i data-lucide="heart-handshake" class="w-3 h-3 mr-1"></i>Therapist
                                                    </span>
                                                </c:when>
                                                <c:when test="${user.roleId == 4}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                                                        <i data-lucide="headphones" class="w-3 h-3 mr-1"></i>Receptionist
                                                    </span>
                                                </c:when>
                                                <c:when test="${user.roleId == 6}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-pink-100 text-pink-800">
                                                        <i data-lucide="megaphone" class="w-3 h-3 mr-1"></i>Marketing
                                                    </span>
                                                </c:when>
                                                <c:when test="${user.roleId == 7}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-orange-100 text-orange-800">
                                                        <i data-lucide="package" class="w-3 h-3 mr-1"></i>Inventory
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                                        <i data-lucide="user" class="w-3 h-3 mr-1"></i>Khác
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <c:choose>
                                                <c:when test="${user.isActive}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                        <i data-lucide="check-circle" class="w-3 h-3 mr-1"></i>Hoạt động
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                                        <i data-lucide="x-circle" class="w-3 h-3 mr-1"></i>Bị khóa
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            <c:choose>
                                                <c:when test="${not empty user.createdAt}">
                                                    <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy" />
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400 italic">Chưa cập nhật</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                            <div class="flex items-center space-x-2">
                                                <a href="${pageContext.request.contextPath}/user-management/view?id=${user.userId}" 
                                                   class="text-blue-600 hover:text-blue-900 p-1 rounded-lg hover:bg-blue-50 transition-colors"
                                                   title="Xem chi tiết">
                                                    <i data-lucide="eye" class="w-4 h-4"></i>
                                                </a>
                                                <c:if test="${currentUser.roleId == 1 || (currentUser.roleId == 2 && user.roleId > 2) || user.userId == currentUser.userId}">
                                                    <a href="${pageContext.request.contextPath}/user-management/edit?id=${user.userId}" 
                                                       class="text-green-600 hover:text-green-900 p-1 rounded-lg hover:bg-green-50 transition-colors"
                                                       title="Chỉnh sửa">
                                                        <i data-lucide="edit" class="w-4 h-4"></i>
                                                    </a>
                                                </c:if>
                                                <c:if test="${(currentUser.roleId == 1 || (currentUser.roleId == 2 && user.roleId > 2)) && user.userId != currentUser.userId}">
                                                    <form method="post" action="${pageContext.request.contextPath}/user-management/reset-password" class="inline">
                                                        <input type="hidden" name="userId" value="${user.userId}" />
                                                        <button type="submit" 
                                                                class="text-yellow-600 hover:text-yellow-900 p-1 rounded-lg hover:bg-yellow-50 transition-colors"
                                                                title="Đặt lại mật khẩu"
                                                                onclick="return confirm('Bạn có chắc muốn đặt lại mật khẩu cho nhân viên này?')">
                                                            <i data-lucide="key" class="w-4 h-4"></i>
                                                        </button>
                                                    </form>
                                                </c:if>
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
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
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