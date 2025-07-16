<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin nhân viên - Admin Dashboard</title>
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
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/lib/dataTables.min.css">
    </head>
<body class="bg-spa-cream font-sans">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        <main class="flex-1 py-12 lg:py-20 ml-64">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex flex-wrap items-center justify-between gap-4 mb-8">
                    <h1 class="text-3xl font-serif text-spa-dark font-bold">
                        <c:choose>
                          <c:when test="${not empty param.role}">
                            Thông tin cá nhân vai trò: 
                            <c:forEach var="role" items="${roles}">
                              <c:if test="${role.roleId == param.role}">${role.displayName != null ? role.displayName : role.name}</c:if>
                            </c:forEach>
                          </c:when>
                          <c:otherwise>Thông tin cá nhân nhân viên</c:otherwise>
                        </c:choose>
                    </h1>
                </div>

                <!-- Search and Filter Section -->
                <div class="bg-white rounded-lg shadow-md p-6 mb-8">
                    <form method="GET" action="${pageContext.request.contextPath}/admin/user/profile" class="space-y-4 md:space-y-0 md:flex md:items-end md:space-x-4">
                        <div class="flex-1">
                            <label class="block text-sm font-medium text-gray-700 mb-2">Tìm kiếm theo tên</label>
                            <input 
                                type="text" 
                                name="searchValue" 
                                value="${searchValue}" 
                                placeholder="Nhập tên nhân viên..."
                                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary focus:border-primary"
                            />
                        </div>
                        
                        <div class="w-full md:w-48">
                            <label class="block text-sm font-medium text-gray-700 mb-2">Vai trò</label>
                            <select name="role" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary focus:border-primary">
                                <option value="">Tất cả vai trò</option>
                                <c:forEach var="roleItem" items="${roles}">
                                    <option value="${roleItem.roleId}" ${role == roleItem.roleId ? 'selected' : ''}>
                                        ${roleItem.displayName != null ? roleItem.displayName : roleItem.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="w-full md:w-32">
                            <label class="block text-sm font-medium text-gray-700 mb-2">Số dòng</label>
                            <select name="pageSize" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary focus:border-primary">
                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                <option value="25" ${pageSize == 25 ? 'selected' : ''}>25</option>
                                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                            </select>
                        </div>

                        <div class="flex space-x-2">
                            <button type="submit" class="px-4 py-2 bg-primary text-white rounded-md hover:bg-primary-dark transition-colors">
                                <i data-lucide="search" class="w-4 h-4 mr-2 inline"></i>
                                Tìm kiếm
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/user/profile" class="px-4 py-2 bg-gray-500 text-white rounded-md hover:bg-gray-600 transition-colors">
                                <i data-lucide="x" class="w-4 h-4 mr-2 inline"></i>
                                Xóa bộ lọc
                            </a>
                        </div>
                    </form>
                </div>

                <!-- Success/Error Messages -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
                        ${sessionScope.successMessage}
                    </div>
                    <%-- Remove message after displaying --%>
                    <c:remove var="successMessage" scope="session" />
                </c:if>

                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                        ${sessionScope.errorMessage}
                    </div>
                    <%-- Remove message after displaying --%>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <!-- Pagination Top -->
                <c:if test="${totalPages > 1}">
                    <div class="bg-white px-4 py-3 border-b border-gray-200 sm:px-6 rounded-t-lg">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center">
                                <p class="text-sm text-gray-700">
                                    Trang <span class="font-medium">${currentPage}</span> 
                                    trong tổng số <span class="font-medium">${totalPages}</span> trang
                                </p>
                            </div>
                            <div class="flex items-center space-x-2">
                                <c:if test="${currentPage > 1}">
                                    <a href="?page=${currentPage - 1}&pageSize=${pageSize}&searchValue=${searchValue}&role=${role}" 
                                       class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50">
                                        Trước
                                    </a>
                                </c:if>
                                
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <c:choose>
                                        <c:when test="${i == currentPage}">
                                            <span class="px-3 py-2 text-sm font-medium text-white bg-primary border border-primary rounded-md">
                                                ${i}
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="?page=${i}&pageSize=${pageSize}&searchValue=${searchValue}&role=${role}" 
                                               class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50">
                                                ${i}
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                
                                <c:if test="${currentPage < totalPages}">
                                    <a href="?page=${currentPage + 1}&pageSize=${pageSize}&searchValue=${searchValue}&role=${role}" 
                                       class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50">
                                        Sau
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- Results Summary and Table -->
                <div class="bg-white rounded-lg shadow-md overflow-hidden">
                    <c:if test="${totalPages <= 1}">
                        <div class="px-6 py-4 border-b border-gray-200">
                            <div class="flex items-center justify-between">
                                <p class="text-sm text-gray-700">
                                    Hiển thị <span class="font-medium">${(currentPage - 1) * pageSize + 1}</span> 
                                    đến <span class="font-medium">${currentPage * pageSize > totalUsers ? totalUsers : currentPage * pageSize}</span> 
                                    trong tổng số <span class="font-medium">${totalUsers}</span> nhân viên
                                </p>
                            </div>
                        </div>
                    </c:if>

                    <!-- Table -->
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Nhân viên
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Vai trò
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Giới tính
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Ngày sinh
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Số điện thoại
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Địa chỉ
                                    </th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                        Thao tác
                                    </th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach var="user" items="${users}">
                                    <tr class="hover:bg-gray-50">
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="flex items-center">
                                                <div class="flex-shrink-0 h-10 w-10">
                                                    <c:choose>
                                                        <c:when test="${not empty user.avatarUrl}">
                                                            <img class="h-10 w-10 rounded-full object-cover" src="${user.avatarUrl}" alt="${user.fullName}">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="h-10 w-10 rounded-full bg-primary flex items-center justify-center">
                                                                <span class="text-white font-medium">${user.fullName.substring(0,1).toUpperCase()}</span>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="ml-4">
                                                    <div class="text-sm font-medium text-gray-900">${user.fullName}</div>
                                                    <div class="text-sm text-gray-500">ID: ${user.userId}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <c:forEach var="roleItem" items="${roles}">
                                                <c:if test="${roleItem.roleId == user.roleId}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium 
                                                        <c:choose>
                                                            <c:when test="${roleItem.roleId == 2}">bg-purple-100 text-purple-800</c:when>
                                                            <c:when test="${roleItem.roleId == 3}">bg-blue-100 text-blue-800</c:when>
                                                            <c:when test="${roleItem.roleId == 4}">bg-green-100 text-green-800</c:when>
                                                            <c:when test="${roleItem.roleId == 6}">bg-pink-100 text-pink-800</c:when>
                                                            <c:otherwise>bg-gray-100 text-gray-800</c:otherwise>
                                                        </c:choose>">
                                                        ${roleItem.displayName != null ? roleItem.displayName : roleItem.name}
                                                    </span>
                                                </c:if>
                                            </c:forEach>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                            <c:choose>
                                                <c:when test="${user.gender == 'M'}">Nam</c:when>
                                                <c:when test="${user.gender == 'F'}">Nữ</c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400">--</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                            <c:choose>
                                                <c:when test="${not empty user.birthday}">
                                                    <fmt:formatDate value="${user.birthday}" pattern="dd/MM/yyyy"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400">--</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                            <c:choose>
                                                <c:when test="${not empty user.phoneNumber}">
                                                    ${user.phoneNumber}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400">--</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 text-sm text-gray-900">
                                            <c:choose>
                                                <c:when test="${not empty user.address}">
                                                    <div class="max-w-xs truncate" title="${user.address}">${user.address}</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400">--</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                            <div class="flex items-center space-x-2">
                                                <a href="${pageContext.request.contextPath}/admin/user/view?id=${user.userId}" 
                                                   class="inline-flex items-center justify-center p-2 text-sm text-blue-600 bg-blue-100 hover:bg-blue-200 rounded-md"
                                                   title="Xem chi tiết thông tin cá nhân">
                                                    <i data-lucide="eye" class="w-4 h-4"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/user/edit?id=${user.userId}&returnTo=profile" 
                                                   class="inline-flex items-center justify-center p-2 text-sm text-green-600 bg-green-100 hover:bg-green-200 rounded-md"
                                                   title="Chỉnh sửa thông tin cá nhân">
                                                    <i data-lucide="edit" class="w-4 h-4"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                
                                <c:if test="${empty users}">
                                    <tr>
                                        <td colspan="7" class="px-6 py-12 text-center text-gray-500">
                                            <i data-lucide="users" class="w-12 h-12 mx-auto mb-4 text-gray-300"></i>
                                            <p class="text-lg">Không tìm thấy nhân viên nào</p>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
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