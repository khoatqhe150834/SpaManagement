<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Tài Khoản - Admin Dashboard</title>
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
                            Danh sách tài khoản vai trò: 
                            <c:forEach var="role" items="${roles}">
                              <c:if test="${role.roleId == param.role}">${role.displayName != null ? role.displayName : role.name}</c:if>
                            </c:forEach>
                          </c:when>
                          <c:otherwise>Danh sách tài khoản nhân viên</c:otherwise>
                        </c:choose>
                    </h1>
                    <a href="${pageContext.request.contextPath}/admin/user/create"
                       class="inline-flex items-center gap-2 h-10 px-4 bg-primary text-white font-semibold rounded-lg hover:bg-primary-dark transition-colors">
                        <i data-lucide="plus" class="w-5 h-5"></i>
                        <span>Thêm Tài Khoản</span>
                    </a>
                </div>
            <c:if test="${not empty sessionScope.successMessage}">
    <div class="mb-4 p-4 rounded-lg bg-green-100 text-green-800 text-base font-semibold flex items-center gap-2">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" /></svg>
        <span>${sessionScope.successMessage}</span>
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
                <div class="bg-white rounded-2xl shadow-lg">
                    <div class="p-6 border-b border-gray-200 flex flex-wrap items-center justify-between gap-4">
                        <form class="flex flex-wrap items-center gap-3" method="get" action="${pageContext.request.contextPath}/admin/user/list">
                            <select class="w-auto h-10 pl-3 pr-8 text-base placeholder-gray-600 border rounded-lg appearance-none focus:shadow-outline-blue focus:border-blue-300" name="pageSize" onchange="this.form.submit()">
                                <option value="5" ${param.pageSize == '5' ? 'selected' : ''}>5/trang</option>
                                <option value="10" ${param.pageSize == '10' || empty param.pageSize ? 'selected' : ''}>10/trang</option>
                                <option value="20" ${param.pageSize == '20' ? 'selected' : ''}>20/trang</option>
                                <option value="9999" ${param.pageSize == '9999' ? 'selected' : ''}>Tất cả</option>
                            </select>
                            <input type="text" class="h-10 px-4 text-base placeholder-gray-600 border rounded-lg focus:shadow-outline" name="searchValue" placeholder="Tìm theo tên hoặc email" value="${param.searchValue}">
                            <select name="role" class="w-auto h-10 pl-3 pr-8 text-base placeholder-gray-600 border rounded-lg appearance-none focus:shadow-outline-blue focus:border-blue-300">
                                <option value="">Tất cả vai trò</option>
                                <c:forEach var="role" items="${roles}">
                                    <option value="${role.roleId}" ${param.role == role.roleId ? 'selected' : ''}>
                                        ${role.displayName != null ? role.displayName : role.name}
                                    </option>
                                </c:forEach>
                            </select>
                            <select class="w-auto h-10 pl-3 pr-8 text-base placeholder-gray-600 border rounded-lg appearance-none focus:shadow-outline-blue focus:border-blue-300" name="status">
                                <option value="">Tất cả trạng thái</option>
                                <option value="active" ${param.status == 'active' ? 'selected' : ''}>Active</option>
                                <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                            </select>
                            <select name="sortBy" class="w-auto h-10 pl-3 pr-8 text-base border rounded-lg appearance-none focus:shadow-outline-blue focus:border-blue-300">
                                <option value="id" ${param.sortBy == 'id' ? 'selected' : ''}>Sắp xếp theo ID</option>
                                <option value="name" ${param.sortBy == 'name' ? 'selected' : ''}>Sắp xếp theo tên</option>
                                <option value="email" ${param.sortBy == 'email' ? 'selected' : ''}>Sắp xếp theo email</option>
                                <option value="created" ${param.sortBy == 'created' ? 'selected' : ''}>Sắp xếp theo ngày tạo</option>
                            </select>
                            <select name="sortOrder" class="w-auto h-10 pl-3 pr-8 text-base border rounded-lg appearance-none focus:shadow-outline-blue focus:border-blue-300">
                                <option value="asc" ${param.sortOrder == 'asc' ? 'selected' : ''}>Tăng dần</option>
                                <option value="desc" ${param.sortOrder == 'desc' ? 'selected' : ''}>Giảm dần</option>
                            </select>
                            <input type="hidden" name="page" value="1">
                            <button type="submit" class="h-10 px-4 bg-primary text-white font-semibold rounded-lg hover:bg-primary-dark transition-colors">Tìm Kiếm</button>
                        </form>
                    </div>
                    
                    <!-- Pagination Top -->
                    <c:if test="${totalPages > 1}">
                        <div class="px-6 py-3 border-b border-gray-200">
                            <div class="flex items-center justify-between">
                                <span>
                                    <c:choose>
                                        <c:when test="${totalEntries == 0}">Hiển thị 0 mục</c:when>
                                        <c:otherwise>Hiển thị ${start} đến ${end} của ${totalEntries} mục</c:otherwise>
                                    </c:choose>
                                </span>
                                <ul class="inline-flex items-center -space-x-px text-sm">
                                    <c:if test="${currentPage > 1}">
                                        <li><a class="px-3 py-2 ml-0 leading-tight text-gray-500 bg-white border border-gray-300 rounded-l-lg hover:bg-gray-100 hover:text-gray-700" href="${pageContext.request.contextPath}/admin/user/list?page=${currentPage - 1}&pageSize=${param.pageSize}&searchValue=${param.searchValue}&role=${param.role}&status=${param.status}&sortBy=${param.sortBy}&sortOrder=${param.sortOrder}">&lt;</a></li>
                                    </c:if>
                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                        <li>
                                            <a class="px-3 py-2 leading-tight ${i == currentPage ? 'text-white bg-primary' : 'text-gray-500 bg-white'} border border-gray-300 hover:bg-gray-100 hover:text-gray-700" href="${pageContext.request.contextPath}/admin/user/list?page=${i}&pageSize=${param.pageSize}&searchValue=${param.searchValue}&role=${param.role}&status=${param.status}&sortBy=${param.sortBy}&sortOrder=${param.sortOrder}">${i}</a>
                                        </li>
                                    </c:forEach>
                                    <c:if test="${currentPage < totalPages}">
                                        <li><a class="px-3 py-2 leading-tight text-gray-500 bg-white border border-gray-300 rounded-r-lg hover:bg-gray-100 hover:text-gray-700" href="${pageContext.request.contextPath}/admin/user/list?page=${currentPage + 1}&pageSize=${param.pageSize}&searchValue=${param.searchValue}&role=${param.role}&status=${param.status}&sortBy=${param.sortBy}&sortOrder=${param.sortOrder}">&gt;</a></li>
                                    </c:if>
                                </ul>
                            </div>
                        </div>
                    </c:if>
                    
                    <div class="p-6">
                        <div class="overflow-x-auto">
                            <table id="userTable" class="w-full text-sm text-left text-gray-500">
                                <thead class="text-xs text-gray-700 uppercase bg-gray-50">
                                    <tr>
                                        <th scope="col" class="px-6 py-3">ID</th>
                                        <th scope="col" class="px-6 py-3">Họ Tên</th>
                                        <th scope="col" class="px-6 py-3">Email</th>
                                        <th scope="col" class="px-6 py-3">Vai Trò</th>
                                        <th scope="col" class="px-6 py-3 text-center">Trạng Thái</th>
                                        <!-- <th scope="col" class="px-6 py-3 text-center">Email Verified</th> -->
                                        <th scope="col" class="px-6 py-3 text-center">Ngày Tạo</th>
                                        <th scope="col" class="px-6 py-3 text-center">Quản Lý</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="user" items="${users}">
                                        <tr class="bg-white border-b hover:bg-gray-50">
                                            <td class="px-6 py-4 font-medium text-gray-900">${user.userId}</td>
                                            <td class="px-6 py-4 max-w-xs truncate" title="${user.fullName}">${user.fullName}</td>
                                            <td class="px-6 py-4">${user.email}</td>
                                            <td class="px-6 py-4">
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
                                            <td class="px-6 py-4 text-center">
                                                <c:choose>
                                                    <c:when test="${user.isActive}">
                                                        <span class="bg-green-100 text-green-800 text-xs font-medium px-2.5 py-0.5 rounded-full">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="bg-red-100 text-red-800 text-xs font-medium px-2.5 py-0.5 rounded-full">Inactive</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <!-- Email Verified Column - Disabled until database column is added
                                            <td class="px-6 py-4 text-center">
                                                <c:choose>
                                                    <c:when test="${user.isEmailVerified}">
                                                        <span class="bg-green-100 text-green-800 text-xs font-medium px-2.5 py-0.5 rounded-full">✓ Verified</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="bg-yellow-100 text-yellow-800 text-xs font-medium px-2.5 py-0.5 rounded-full">⚠ Unverified</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            -->
                                            <td class="px-6 py-4 text-center text-sm text-gray-900">
                                                <c:choose>
                                                    <c:when test="${not empty user.createdAt}">
                                                        <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-400">--</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                                                                        <td class="px-6 py-4 text-center">
                                                <div class="relative inline-block text-left">
                                                    <button type="button" class="inline-flex items-center justify-center w-8 h-8 text-gray-400 bg-transparent rounded-full hover:text-gray-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" onclick="toggleDropdown('dropdown-${user.userId}')">
                                                        <span class="sr-only">Tùy chọn</span>
                                                        <i data-lucide="settings" class="w-5 h-5"></i>
                                                    </button>
                                                    
                                                    <div id="dropdown-${user.userId}" class="hidden absolute right-0 z-10 mt-2 w-48 bg-white rounded-md shadow-lg ring-1 ring-black ring-opacity-5">
                                                        <div class="py-1" role="menu">
                                                            <div class="px-4 py-2 text-xs font-semibold text-gray-500 uppercase tracking-wide border-b">Tài khoản</div>
                                                            <a href="${pageContext.request.contextPath}/admin/user/view?id=${user.userId}" class="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" role="menuitem">
                                                                <i data-lucide="eye" class="mr-3 h-4 w-4"></i>
                                                                Xem chi tiết tài khoản
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/admin/user/edit?id=${user.userId}" class="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" role="menuitem">
                                                                <i data-lucide="user-cog" class="mr-3 h-4 w-4"></i>
                                                                Chỉnh sửa vai trò
                                                            </a>
                                                            
                                                            <div class="px-4 py-2 text-xs font-semibold text-gray-500 uppercase tracking-wide border-b border-t">Bảo mật</div>
                                                            <a href="${pageContext.request.contextPath}/admin/user/quick-reset-password?id=${user.userId}" class="flex items-center px-4 py-2 text-sm text-purple-700 hover:bg-purple-50" role="menuitem" onclick="return confirmAction('Bạn có chắc muốn đặt lại mật khẩu cho ${user.fullName}?')">
                                                                <i data-lucide="key" class="mr-3 h-4 w-4"></i>
                                                                Đặt lại mật khẩu
                                                            </a>
                                                            
                                                            <!-- Email Verification Actions - Disabled until database column is added
                                                            <c:choose>
                                                                <c:when test="${user.isEmailVerified}">
                                                                    <a href="${pageContext.request.contextPath}/admin/user/unverify-email?id=${user.userId}" class="flex items-center px-4 py-2 text-sm text-yellow-700 hover:bg-yellow-50" role="menuitem" onclick="return confirmAction('Bạn có chắc muốn hủy xác thực email?')">
                                                                        <i data-lucide="mail-x" class="mr-3 h-4 w-4"></i>
                                                                        Hủy xác thực email
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <a href="${pageContext.request.contextPath}/admin/user/verify-email?id=${user.userId}" class="flex items-center px-4 py-2 text-sm text-green-700 hover:bg-green-50" role="menuitem" onclick="return confirmAction('Bạn có chắc muốn xác thực email?')">
                                                                        <i data-lucide="mail-check" class="mr-3 h-4 w-4"></i>
                                                                        Xác thực email
                                                                    </a>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            -->
                                                            
                                                            <div class="px-4 py-2 text-xs font-semibold text-gray-500 uppercase tracking-wide border-b border-t">Trạng thái</div>
                                                            <c:choose>
                                                                <c:when test="${user.isActive}">
                                                                    <a href="${pageContext.request.contextPath}/admin/user/deactivate?id=${user.userId}" class="flex items-center px-4 py-2 text-sm text-red-700 hover:bg-red-50" role="menuitem" onclick="return confirmAction('Bạn có chắc muốn vô hiệu hóa tài khoản này?')">
                                                                        <i data-lucide="ban" class="mr-3 h-4 w-4"></i>
                                                                        Vô hiệu hóa tài khoản
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <a href="${pageContext.request.contextPath}/admin/user/activate?id=${user.userId}" class="flex items-center px-4 py-2 text-sm text-green-700 hover:bg-green-50" role="menuitem" onclick="return confirmAction('Bạn có chắc muốn kích hoạt lại tài khoản này?')">
                                                                        <i data-lucide="refresh-ccw" class="mr-3 h-4 w-4"></i>
                                                                        Kích hoạt tài khoản
                                                                    </a>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="flex items-center justify-between flex-wrap gap-2 p-6">
                     <span>
                            <c:choose>
                                <c:when test="${totalEntries == 0}">Hiển thị 0 mục</c:when>
                                <c:otherwise>Hiển thị ${start} đến ${end} của ${totalEntries} mục</c:otherwise>
                            </c:choose>
                    </span>
                        <ul class="inline-flex items-center -space-x-px text-sm">
                            <c:if test="${currentPage > 1}">
                                <li><a class="px-3 py-2 ml-0 leading-tight text-gray-500 bg-white border border-gray-300 rounded-l-lg hover:bg-gray-100 hover:text-gray-700" href="${pageContext.request.contextPath}/admin/user/list?page=${currentPage - 1}&pageSize=${param.pageSize}&searchValue=${param.searchValue}&role=${param.role}&status=${param.status}&sortBy=${param.sortBy}&sortOrder=${param.sortOrder}">&lt;</a></li>
                            </c:if>
                        <c:forEach var="i" begin="1" end="${totalPages}">
                                <li>
                                    <a class="px-3 py-2 leading-tight ${i == currentPage ? 'text-white bg-primary' : 'text-gray-500 bg-white'} border border-gray-300 hover:bg-gray-100 hover:text-gray-700" href="${pageContext.request.contextPath}/admin/user/list?page=${i}&pageSize=${param.pageSize}&searchValue=${param.searchValue}&role=${param.role}&status=${param.status}&sortBy=${param.sortBy}&sortOrder=${param.sortOrder}">${i}</a>
                            </li>
                        </c:forEach>
                             <c:if test="${currentPage < totalPages}">
                                <li><a class="px-3 py-2 leading-tight text-gray-500 bg-white border border-gray-300 rounded-r-lg hover:bg-gray-100 hover:text-gray-700" href="${pageContext.request.contextPath}/admin/user/list?page=${currentPage + 1}&pageSize=${param.pageSize}&searchValue=${param.searchValue}&role=${param.role}&status=${param.status}&sortBy=${param.sortBy}&sortOrder=${param.sortOrder}">&gt;</a></li>
                            </c:if>
                    </ul>
                    </div>
                </div>
            </div>
        </main>
        </div>
    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
    <script src="${pageContext.request.contextPath}/assets/admin/js/lib/dataTables.min.js"></script>
        <script>
        lucide.createIcons();
        document.addEventListener("DOMContentLoaded", function() {
            new DataTable('#userTable', {
                searching: false,
                paging: false,
                info: false,
                lengthChange: false,
                ordering: true 
            });
        });
        
        function confirmAction(message) {
            return confirm(message);
        }
        
        function toggleDropdown(dropdownId) {
            // Đóng tất cả dropdown khác
            document.querySelectorAll('[id^="dropdown-"]').forEach(function(dropdown) {
                if (dropdown.id !== dropdownId) {
                    dropdown.classList.add('hidden');
                }
            });
            
            // Toggle dropdown hiện tại
            var dropdown = document.getElementById(dropdownId);
            dropdown.classList.toggle('hidden');
        }
        
        // Đóng dropdown khi click ra ngoài
        document.addEventListener('click', function(event) {
            if (!event.target.closest('.relative')) {
                document.querySelectorAll('[id^="dropdown-"]').forEach(function(dropdown) {
                    dropdown.classList.add('hidden');
                });
            }
        });
        
        // Đóng dropdown khi nhấn ESC
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                document.querySelectorAll('[id^="dropdown-"]').forEach(function(dropdown) {
                    dropdown.classList.add('hidden');
                });
            }
        });
        </script>
    </body>
</html> 