<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản lý Blog - Spa Hương Sen</title>
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
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
    <style>
      .line-clamp-2 { display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
      .line-clamp-3 { display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; }
    </style>
</head>
<body class="bg-spa-cream font-sans text-spa-dark min-h-screen">
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
    <main class="w-full md:w-[calc(100%-256px)] md:ml-64 bg-white min-h-screen transition-all">
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
        <div class="p-6 bg-spa-cream min-h-screen">
            <!-- Header & Breadcrumb -->
            <div class="flex items-center justify-between mb-8">
                <div>
                    <h1 class="text-2xl font-bold text-spa-dark">
                        <c:choose>
                            <c:when test="${sessionScope.user != null && sessionScope.user.roleId == 6}">Quản lý Blog (Marketing)</c:when>
                            <c:when test="${sessionScope.user != null && sessionScope.user.roleId == 2}">Duyệt Blog (Manager)</c:when>
                            <c:otherwise>Quản lý Blog</c:otherwise>
                        </c:choose>
                    </h1>
                    <nav class="text-sm text-gray-500 flex items-center space-x-2 mt-1">
                        <a href="${pageContext.request.contextPath}/dashboard" class="hover:text-primary">Dashboard</a>
                        <span>/</span>
                        <span>Blog</span>
                    </nav>
                </div>
                <!-- Marketing role can add blogs -->
                <c:if test="${sessionScope.user != null && sessionScope.user.roleId == 6}">
                    <a href="${pageContext.request.contextPath}${rolePrefix}/blog?action=add" class="px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark font-semibold flex items-center gap-2">
                        <i data-lucide="plus" class="h-5 w-5"></i> Thêm Blog
                    </a>
                </c:if>
            </div>
            <!-- Search & Filter -->
            <form class="flex flex-wrap gap-4 mb-8" method="GET" action="${pageContext.request.contextPath}${rolePrefix}/blog">
                <input type="hidden" name="action" value="list" />
                <input type="text" name="search" placeholder="Tìm tiêu đề..." value="${param.search}" class="px-4 py-2 border rounded-lg focus:ring-2 focus:ring-primary w-64" />
                <select name="status" class="px-4 py-2 border rounded-lg focus:ring-2 focus:ring-primary">
                    <option value="">Tất cả trạng thái</option>
                    <option value="DRAFT" ${param.status == 'DRAFT' ? 'selected' : ''}>Nháp</option>
                    <option value="PUBLISHED" ${param.status == 'PUBLISHED' ? 'selected' : ''}>Đã đăng</option>
                    <option value="ARCHIVED" ${param.status == 'ARCHIVED' ? 'selected' : ''}>Lưu trữ</option>
                </select>
                <select name="category" class="px-4 py-2 border rounded-lg focus:ring-2 focus:ring-primary">
                    <option value="">Tất cả danh mục</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.categoryId}" ${param.category == cat.categoryId ? 'selected' : ''}>${cat.name}</option>
                    </c:forEach>
                </select>
                <button type="submit" class="px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark font-semibold">Tìm kiếm</button>
            </form>
            <!-- Blog Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                <c:forEach var="blog" items="${blogs}">
                    <div class="bg-white rounded-xl shadow p-6 flex flex-col h-full">
                        <a href="${pageContext.request.contextPath}${rolePrefix}/blog?id=${blog.blogId}" class="block mb-4">
                            <img src="${pageContext.request.contextPath}/${empty blog.featureImageUrl ? 'assets/admin/images/blog/blog1.png' : blog.featureImageUrl}" alt="" class="w-full h-40 object-cover rounded-lg" />
                        </a>
                        <h2 class="text-lg font-semibold text-spa-dark mb-2 line-clamp-2 hover:text-primary transition">
                            <a href="${pageContext.request.contextPath}${rolePrefix}/blog?id=${blog.blogId}">${blog.title}</a>
                        </h2>
                        <div class="flex items-center text-gray-500 text-sm mb-2 gap-4">
                            <span class="flex items-center gap-1"><i data-lucide="eye" class="h-4 w-4"></i> ${blog.viewCount} lượt xem</span>
                            <span class="flex items-center gap-1"><i data-lucide="calendar" class="h-4 w-4"></i> <fmt:formatDate value="${blog.publishedAtDate != null ? blog.publishedAtDate : blog.createdAtDate}" pattern="dd/MM/yyyy"/></span>
                        </div>
                        <p class="text-gray-600 text-sm mb-4 line-clamp-3">${blog.summary}</p>
                        <div class="flex items-center justify-between mt-auto">
                            <span class="px-2 py-1 rounded text-xs font-semibold
                                <c:choose>
                                    <c:when test='${blog.status == "PUBLISHED"}'>bg-green-100 text-green-700</c:when>
                                    <c:when test='${blog.status == "DRAFT"}'>bg-gray-200 text-gray-700</c:when>
                                    <c:when test='${blog.status == "ARCHIVED"}'>bg-yellow-100 text-yellow-700</c:when>
                                    <c:otherwise>bg-gray-100 text-gray-700</c:otherwise>
                                </c:choose>
                            ">
                                ${blog.status}
                            </span>
                            <div class="flex items-center gap-2">
                                <a href="${pageContext.request.contextPath}${rolePrefix}/blog?id=${blog.blogId}" class="px-3 py-1 bg-primary text-white rounded hover:bg-primary-dark text-xs font-semibold">Xem chi tiết</a>
                                
                                <!-- Marketing role can edit blogs -->
                                <c:if test="${sessionScope.user != null && sessionScope.user.roleId == 6}">
                                    <a href="${pageContext.request.contextPath}${rolePrefix}/blog?action=edit&id=${blog.blogId}" class="px-3 py-1 bg-yellow-500 text-white rounded hover:bg-yellow-600 text-xs font-semibold">Sửa</a>
                                </c:if>
                                
                                <!-- Manager role can approve/reject blogs -->
                                <c:if test="${sessionScope.user != null && sessionScope.user.roleId == 2}">
                                    <c:choose>
                                        <c:when test="${blog.status == 'DRAFT'}">
                                            <form action="${pageContext.request.contextPath}${rolePrefix}/blog" method="post" class="inline">
                                                <input type="hidden" name="action" value="updateBlogStatus">
                                                <input type="hidden" name="blogId" value="${blog.blogId}">
                                                <input type="hidden" name="status" value="PUBLISHED">
                                                <button type="submit" class="px-3 py-1 bg-green-500 text-white rounded hover:bg-green-600 text-xs font-semibold">Duyệt</button>
                                            </form>
                                        </c:when>
                                        <c:when test="${blog.status == 'PUBLISHED'}">
                                            <form action="${pageContext.request.contextPath}${rolePrefix}/blog" method="post" class="inline">
                                                <input type="hidden" name="action" value="updateBlogStatus">
                                                <input type="hidden" name="blogId" value="${blog.blogId}">
                                                <input type="hidden" name="status" value="ARCHIVED">
                                                <button type="submit" class="px-3 py-1 bg-yellow-500 text-white rounded hover:bg-yellow-600 text-xs font-semibold">Lưu trữ</button>
                                            </form>
                                        </c:when>
                                        <c:when test="${blog.status == 'ARCHIVED'}">
                                            <form action="${pageContext.request.contextPath}${rolePrefix}/blog" method="post" class="inline">
                                                <input type="hidden" name="action" value="updateBlogStatus">
                                                <input type="hidden" name="blogId" value="${blog.blogId}">
                                                <input type="hidden" name="status" value="PUBLISHED">
                                                <button type="submit" class="px-3 py-1 bg-blue-500 text-white rounded hover:bg-blue-600 text-xs font-semibold">Khôi phục</button>
                                            </form>
                                        </c:when>
                                    </c:choose>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <!-- Pagination block -->
            <c:url value="${rolePrefix}/blog" var="paginationUrl">
                <c:param name="action" value="list" />
                <c:if test="${not empty param.search}">
                    <c:param name="search" value="${param.search}" />
                </c:if>
                <c:if test="${not empty param.status}">
                    <c:param name="status" value="${param.status}" />
                </c:if>
                <c:if test="${not empty param.category}">
                    <c:param name="category" value="${param.category}" />
                </c:if>
            </c:url>
            <div class="flex justify-center mt-8">
                <ul class="inline-flex items-center space-x-2">
                    <li>
                        <a href="${currentPage == 1 ? '#' : paginationUrl}" class="px-3 py-2 rounded border ${currentPage == 1 ? 'text-gray-400 border-gray-200' : 'text-primary border-primary hover:bg-primary hover:text-white'}">First</a>
                    </li>
                    <li>
                        <a href="${currentPage == 1 ? '#' : paginationUrl}&page=${currentPage - 1}" class="px-3 py-2 rounded border ${currentPage == 1 ? 'text-gray-400 border-gray-200' : 'text-primary border-primary hover:bg-primary hover:text-white'}">&lt;</a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li>
                            <a href="${paginationUrl}&page=${i}" class="px-3 py-2 rounded border ${currentPage == i ? 'bg-primary text-white border-primary' : 'text-primary border-primary hover:bg-primary hover:text-white'}">${i}</a>
                        </li>
                    </c:forEach>
                    <li>
                        <a href="${currentPage == totalPages ? '#' : paginationUrl}&page=${currentPage + 1}" class="px-3 py-2 rounded border ${currentPage == totalPages ? 'text-gray-400 border-gray-200' : 'text-primary border-primary hover:bg-primary hover:text-white'}">&gt;</a>
                    </li>
                    <li>
                        <a href="${currentPage == totalPages ? '#' : paginationUrl}&page=${totalPages}" class="px-3 py-2 rounded border ${currentPage == totalPages ? 'text-gray-400 border-gray-200' : 'text-primary border-primary hover:bg-primary hover:text-white'}">Last</a>
                    </li>
                </ul>
            </div>
        </div>
    </main>
    <script>
      if (typeof lucide !== 'undefined') {
        lucide.createIcons();
      }
    </script>
</body>
</html>
