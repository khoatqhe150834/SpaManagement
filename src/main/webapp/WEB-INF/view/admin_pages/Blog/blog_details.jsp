<%-- Document : blog_details Created on : Jun 18, 2025, 2:22:55 PM Author : ADMIN --%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Chi tiết Blog - Spa Hương Sen</title>
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
      .blog-content img { max-width: 100%; height: auto; border-radius: 8px; margin: 1rem 0; }
      .blog-content p { margin-bottom: 1rem; line-height: 1.8; }
      .blog-content h1, .blog-content h2, .blog-content h3, .blog-content h4, .blog-content h5, .blog-content h6 { margin-top: 2rem; margin-bottom: 1rem; font-weight: 600; color: #333333; }
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
                    <h1 class="text-2xl font-bold text-spa-dark">Chi tiết Blog</h1>
                    <nav class="text-sm text-gray-500 flex items-center space-x-2 mt-1">
                        <a href="${pageContext.request.contextPath}/dashboard" class="hover:text-primary">Dashboard</a>
                        <span>/</span>
                        <a href="${pageContext.request.contextPath}${rolePrefix}/blog" class="hover:text-primary">Blog</a>
                        <span>/</span>
                        <span>Chi tiết</span>
                    </nav>
                </div>
                <a href="${pageContext.request.contextPath}${rolePrefix}/blog" class="px-4 py-2 bg-gray-200 text-spa-dark rounded-lg hover:bg-primary hover:text-white font-semibold flex items-center gap-2">
                    <i data-lucide="arrow-left" class="h-5 w-5"></i> Quay lại
                </a>
            </div>
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                <!-- Main Blog Content -->
                <div class="lg:col-span-2 flex flex-col space-y-8">
                    <div class="bg-white rounded-xl shadow p-6">
                        <div class="mb-6">
                            <c:set var="blogImgUrl" value="${empty blog.featureImageUrl ? 'assets/admin/images/blog/blog-details.png' : blog.featureImageUrl}" />
                            <img src="${pageContext.request.contextPath}/${blogImgUrl}"
                                 alt="" class="w-full h-64 md:h-96 object-cover rounded-lg" />
                        </div>
                        <div class="flex flex-wrap items-center justify-between mb-6 gap-4">
                            <div class="flex items-center gap-4">
                                <img src="${pageContext.request.contextPath}/assets/admin/images/user-list/user-list1.png" alt="" class="w-12 h-12 rounded-full object-cover" />
                                <div>
                                    <h6 class="text-base font-semibold text-spa-dark mb-1">${blog.authorName}</h6>
                                    <span class="text-sm text-gray-500">
                                        <fmt:formatDate value="${blog.publishedAtDate != null ? blog.publishedAtDate : blog.createdAtDate}" pattern="dd/MM/yyyy" />
                                    </span>
                                </div>
                            </div>
                            <div class="flex items-center gap-4 flex-wrap">
                                <span class="flex items-center gap-1 text-gray-500 text-sm"><i data-lucide="eye" class="h-4 w-4"></i> ${blog.viewCount} lượt xem</span>
                                <span class="flex items-center gap-1 text-gray-500 text-sm"><i data-lucide="calendar" class="h-4 w-4"></i> <fmt:formatDate value="${blog.publishedAtDate != null ? blog.publishedAtDate : blog.createdAtDate}" pattern="dd/MM/yyyy" /></span>
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
                            </div>
                        </div>
                        <h2 class="text-2xl font-bold text-spa-dark mb-4">${blog.title}</h2>
                        <p class="text-gray-700 text-lg mb-6">${blog.summary}</p>
                        <div class="blog-content text-gray-700 leading-relaxed">
                            <c:out value="${contentHtml}" escapeXml="false" />
                        </div>
                    </div>
                    <!-- Comments Section (if admin) -->
                    <c:if test="${sessionScope.user != null && sessionScope.user.roleId == 6}">
                        <div class="bg-white rounded-xl shadow p-6 mt-4">
                            <h3 class="text-xl font-semibold text-spa-dark mb-6 flex items-center gap-2">
                                <i data-lucide="message-circle" class="h-6 w-6 text-primary"></i> Bình luận
                            </h3>
                            <div class="space-y-6">
                                <c:choose>
                                    <c:when test="${empty comments}">
                                        <div class="text-gray-500">Chưa có bình luận nào.</div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="comment" items="${comments}">
                                            <c:choose>
                                                <c:when test="${not empty comment.avatarUrl && fn:startsWith(comment.avatarUrl, 'http')}">
                                                    <c:set var="avatarUrl" value="${comment.avatarUrl}" />
                                                </c:when>
                                                <c:when test="${not empty comment.avatarUrl}">
                                                    <c:set var="avatarUrl" value="${pageContext.request.contextPath}${comment.avatarUrl}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="avatarUrl" value="${pageContext.request.contextPath}/assets/admin/images/user-list/user-list1.png" />
                                                </c:otherwise>
                                            </c:choose>
                                            <div class="flex items-start gap-4 border-b border-dashed pb-4 mb-4">
                                                <img src="${avatarUrl}" class="w-12 h-12 rounded-full object-cover" alt="" />
                                                <div class="flex-1">
                                                    <div class="flex items-center gap-2 mb-1">
                                                        <span class="font-semibold text-spa-dark">${empty comment.customerName ? comment.guestName : comment.customerName}</span>
                                                        <span class="text-xs text-gray-500">
                                                            <fmt:formatDate value="${comment.createdAtDate}" pattern="dd/MM/yyyy HH:mm" />
                                                        </span>
                                                    </div>
                                                    <p class="text-gray-700 mb-2">${comment.commentText}</p>
                                                    <form method="post" action="${pageContext.request.contextPath}${rolePrefix}/blog" class="inline">
                                                        <input type="hidden" name="action" value="rejectComment" />
                                                        <input type="hidden" name="commentId" value="${comment.commentId}" />
                                                        <input type="hidden" name="id" value="${blog.blogId}" />
                                                        <button type="submit" class="px-3 py-1 bg-red-500 text-white rounded hover:bg-red-600 text-xs font-semibold">Từ chối</button>
                                                    </form>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:if>
                </div>
                <!-- Sidebar -->
                <div class="flex flex-col gap-8">
                    <!-- Latest Blog -->
                    <div class="bg-white rounded-xl shadow p-6">
                        <h3 class="text-lg font-semibold text-spa-dark mb-4">Bài viết mới</h3>
                        <div class="flex flex-col gap-4">
                            <c:choose>
                                <c:when test="${empty recentBlogs}">
                                    <div class="text-gray-500 text-sm">Chưa có bài viết nào.</div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="recent" items="${recentBlogs}">
                                        <div class="flex gap-4 items-start">
                                            <c:set var="recentImgUrl" value="${empty recent.featureImageUrl ? 'assets/admin/images/blog/blog5.png' : recent.featureImageUrl}" />
                                            <a href="${pageContext.request.contextPath}${rolePrefix}/blog?id=${recent.blogId}" class="block w-24 h-16 rounded-lg overflow-hidden flex-shrink-0">
                                                <img src="${pageContext.request.contextPath}/${recentImgUrl}"
                                                     alt="${recent.title}" class="w-full h-full object-cover" />
                                            </a>
                                            <div class="flex-1 min-w-0">
                                                <h4 class="text-sm font-semibold text-spa-dark line-clamp-2 hover:text-primary transition mb-1">
                                                    <a href="${pageContext.request.contextPath}${rolePrefix}/blog?id=${recent.blogId}">${recent.title}</a>
                                                </h4>
                                                <p class="text-xs text-gray-500 line-clamp-2 mb-0">${recent.summary}</p>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <!-- Action Buttons -->
                    <c:if test="${sessionScope.user != null && sessionScope.user.roleId == 6}">
                        <a href="${pageContext.request.contextPath}${rolePrefix}/blog?action=edit&id=${blog.blogId}"
                           class="px-4 py-2 bg-yellow-400 text-white rounded-lg hover:bg-yellow-500 font-semibold text-center">Chỉnh sửa Blog</a>
                    </c:if>
                    <c:if test="${sessionScope.user != null && sessionScope.user.roleId == 2}">
                        <div class="bg-white rounded-xl shadow p-6">
                            <h3 class="text-lg font-semibold text-spa-dark mb-4">Thao tác Blog</h3>
                            <div class="flex flex-col gap-2">
                                <c:choose>
                                    <c:when test="${blog.status == 'DRAFT'}">
                                        <form action="${pageContext.request.contextPath}${rolePrefix}/blog" method="post">
                                            <input type="hidden" name="action" value="updateBlogStatus">
                                            <input type="hidden" name="blogId" value="${blog.blogId}">
                                            <input type="hidden" name="status" value="PUBLISHED">
                                            <input type="hidden" name="id" value="${blog.blogId}" />
                                            <button type="submit" class="w-full px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 font-semibold flex items-center gap-2 justify-center">
                                                <i data-lucide="check" class="h-5 w-5"></i> Duyệt Blog
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:when test="${blog.status == 'PUBLISHED'}">
                                        <form action="${pageContext.request.contextPath}${rolePrefix}/blog" method="post">
                                            <input type="hidden" name="action" value="updateBlogStatus">
                                            <input type="hidden" name="blogId" value="${blog.blogId}">
                                            <input type="hidden" name="status" value="ARCHIVED">
                                            <input type="hidden" name="id" value="${blog.blogId}" />
                                            <button type="submit" class="w-full px-4 py-2 bg-yellow-400 text-white rounded-lg hover:bg-yellow-500 font-semibold flex items-center gap-2 justify-center">
                                                <i data-lucide="archive" class="h-5 w-5"></i> Lưu trữ Blog
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:when test="${blog.status == 'ARCHIVED'}">
                                        <form action="${pageContext.request.contextPath}${rolePrefix}/blog" method="post">
                                            <input type="hidden" name="action" value="updateBlogStatus">
                                            <input type="hidden" name="blogId" value="${blog.blogId}">
                                            <input type="hidden" name="status" value="PUBLISHED">
                                            <input type="hidden" name="id" value="${blog.blogId}" />
                                            <button type="submit" class="w-full px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 font-semibold flex items-center gap-2 justify-center">
                                                <i data-lucide="rotate-ccw" class="h-5 w-5"></i> Khôi phục Blog
                                            </button>
                                        </form>
                                    </c:when>
                                </c:choose>
                            </div>
                        </div>
                    </c:if>
                </div>
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