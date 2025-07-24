<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Blog - Spa Hương Sen</title>

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
        <link
            href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap"
            rel="stylesheet"
        />

        <!-- Lucide Icons -->
        <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>

        <!-- Custom CSS -->
        <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />

        <!-- Custom styles for animations -->
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
            .line-clamp-3 {
                display: -webkit-box;
                -webkit-line-clamp: 3;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }
        </style>
    </head>

    <body class="bg-spa-cream">
        <jsp:include page="/WEB-INF/view/common/header.jsp" />

        <!-- ====== paginationUrl build ====== -->
        <c:url value="/blog" var="paginationUrl">
            <c:param name="action" value="list"/>
            <c:if test="${not empty param.search}">
                <c:param name="search" value="${param.search}"/>
            </c:if>
            <c:if test="${not empty param.category}">
                <c:param name="category" value="${param.category}"/>
            </c:if>
        </c:url>

        <!-- ===== Banner & breadcrumb ===== -->
        <section class="relative py-32 bg-cover bg-center" 
                 style="background-image: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)), url('${pageContext.request.contextPath}/assets/home/images/banner/bnr1.jpg');">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center text-white">
                <h1 class="text-5xl md:text-6xl font-serif mb-4">Blog</h1>
                <div class="flex items-center justify-center space-x-2 text-lg">
                    <a href="${pageContext.request.contextPath}/" class="hover:text-primary transition-colors">Trang chủ</a>
                    <i data-lucide="chevron-right" class="h-5 w-5"></i>
                    <span>Blog</span>
                </div>
            </div>
        </section>

        <!-- ============== CONTENT ============== -->
        <section class="py-16 bg-spa-cream">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

                    <!-- ========== MAIN LIST ========== -->
                    <div class="lg:col-span-2 space-y-8">

                        <c:forEach var="b" items="${blogs}">
                            <article class="bg-white rounded-xl shadow-lg overflow-hidden hover:shadow-2xl transition-all duration-300 group">
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-0">
                                    <!-- thumbnail -->
                                    <div class="relative overflow-hidden">
                                        <img src="${pageContext.request.contextPath}/${empty b.featureImageUrl
                                                    ? 'assets/home/images/blog/default/thum1.jpg'
                                                    : b.featureImageUrl}" 
                                             alt="${b.title}"
                                             class="w-full h-64 md:h-full object-cover transition-transform duration-300 group-hover:scale-105">
                                        <div class="absolute inset-0 bg-gradient-to-t from-black/30 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                                    </div>

                                    <!-- content -->
                                    <div class="p-6 flex flex-col justify-between">
                                        <div>
                                            <!-- meta info -->
                                            <div class="flex items-center space-x-4 text-sm text-gray-600 mb-4">
                                                <div class="flex items-center">
                                                    <i data-lucide="calendar" class="h-4 w-4 mr-1"></i>
                                                    <fmt:formatDate value="${b.publishedAtDate != null ? b.publishedAtDate : b.createdAtDate}"
                                                                    pattern="dd/MM/yyyy"/>
                                                </div>
                                                <div class="flex items-center">
                                                    <i data-lucide="user" class="h-4 w-4 mr-1"></i>
                                                    <span>${b.authorName}</span>
                                                </div>
                                                <div class="flex items-center">
                                                    <i data-lucide="eye" class="h-4 w-4 mr-1"></i>
                                                    <span>${b.viewCount} lượt xem</span>
                                                </div>
                                            </div>

                                            <!-- title -->
                                            <h3 class="text-xl font-serif font-semibold text-spa-dark mb-3 line-clamp-2 group-hover:text-primary transition-colors">
                                                <a href="${pageContext.request.contextPath}/blog?id=${b.blogId}">
                                                    ${b.title}
                                                </a>
                                            </h3>

                                            <!-- summary -->
                                            <p class="text-gray-600 leading-relaxed line-clamp-3 mb-4">
                                                ${b.summary}
                                            </p>
                                        </div>

                                        <!-- read more -->
                                        <div class="mt-auto">
                                            <a href="${pageContext.request.contextPath}/blog?id=${b.blogId}"
                                               class="inline-flex items-center text-primary hover:text-primary-dark font-semibold transition-colors group-hover:translate-x-1 duration-300">
                                                Đọc thêm
                                                <i data-lucide="arrow-right" class="ml-2 h-4 w-4"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </article>
                        </c:forEach>

                        <!-- ===== Pagination ===== -->
                        <c:if test="${totalPages > 1}">
                            <div class="flex justify-center mt-12">
                                <nav class="flex items-center space-x-2">
                                    <!-- Prev -->
                                    <c:if test="${currentPage > 1}">
                                        <a href="${paginationUrl}&page=${currentPage-1}"
                                           class="px-4 py-2 bg-white border border-gray-300 rounded-lg hover:bg-primary hover:text-white transition-colors">
                                            <i data-lucide="chevron-left" class="h-4 w-4"></i>
                                        </a>
                                    </c:if>

                                    <!-- page numbers -->
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <c:choose>
                                            <c:when test="${i == currentPage}">
                                                <span class="px-4 py-2 bg-primary text-white rounded-lg">${i}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${paginationUrl}&page=${i}"
                                                   class="px-4 py-2 bg-white border border-gray-300 rounded-lg hover:bg-primary hover:text-white transition-colors">
                                                    ${i}
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>

                                    <!-- Next -->
                                    <c:if test="${currentPage < totalPages}">
                                        <a href="${paginationUrl}&page=${currentPage+1}"
                                           class="px-4 py-2 bg-white border border-gray-300 rounded-lg hover:bg-primary hover:text-white transition-colors">
                                            <i data-lucide="chevron-right" class="h-4 w-4"></i>
                                        </a>
                                    </c:if>
                                </nav>
                            </div>
                        </c:if>
                    </div>

                    <!-- ========== SIDEBAR ========== -->
                    <div class="space-y-8">
                        <!-- SEARCH widget -->
                        <div class="bg-white rounded-xl shadow-lg p-6">
                            <h3 class="text-xl font-serif font-semibold text-spa-dark mb-4 flex items-center">
                                <i data-lucide="search" class="h-5 w-5 mr-2 text-primary"></i>
                                Tìm Kiếm
                            </h3>
                            <form class="space-y-4" method="get" action="${pageContext.request.contextPath}/blog">
                                <div class="relative">
                                    <input type="text" name="search"
                                           value="${param.search != null ? param.search : ''}"
                                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent"
                                           placeholder="Nhập từ khóa tìm kiếm...">
                                    <button type="submit"
                                            class="absolute right-2 top-1/2 transform -translate-y-1/2 bg-primary text-white p-2 rounded-md hover:bg-primary-dark transition-colors">
                                        <i data-lucide="search" class="h-4 w-4"></i>
                                    </button>
                                </div>
                            </form>
                        </div>

                        <!-- Recent Posts -->
                        <div class="bg-white rounded-xl shadow-lg p-6">
                            <h3 class="text-xl font-serif font-semibold text-spa-dark mb-6 flex items-center">
                                <i data-lucide="clock" class="h-5 w-5 mr-2 text-primary"></i>
                                Blog Gần Đây
                            </h3>
                            <div class="space-y-4">
                                <c:forEach var="rb" items="${recentBlogs}">
                                    <article class="flex space-x-4 group">
                                        <div class="flex-shrink-0">
                                            <img src="${pageContext.request.contextPath}/${empty rb.featureImageUrl
                                                        ? 'assets/home/images/blog/default/thum1.jpg'
                                                        : rb.featureImageUrl}"
                                                 alt="${rb.title}"
                                                 class="w-20 h-16 object-cover rounded-lg">
                                        </div>
                                        <div class="flex-1 min-w-0">
                                            <h4 class="text-sm font-semibold text-spa-dark line-clamp-2 group-hover:text-primary transition-colors">
                                                <a href="${pageContext.request.contextPath}/blog?id=${rb.blogId}">
                                                    ${rb.title}
                                                </a>
                                            </h4>
                                            <div class="flex items-center text-xs text-gray-500 mt-1">
                                                <fmt:formatDate value="${rb.publishedAtDate != null ? rb.publishedAtDate : rb.createdAtDate}"
                                                                pattern="dd/MM/yyyy"/>
                                                <span class="mx-2">•</span>
                                                <span>${rb.viewCount} lượt xem</span>
                                            </div>
                                        </div>
                                    </article>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Gallery -->
                        <div class="bg-white rounded-xl shadow-lg p-6">
                            <h3 class="text-xl font-serif font-semibold text-spa-dark mb-6 flex items-center">
                                <i data-lucide="image" class="h-5 w-5 mr-2 text-primary"></i>
                                Bộ Sưu Tập
                            </h3>
                            <div class="grid grid-cols-3 gap-2">
                                <c:forEach begin="1" end="6" var="i">
                                    <div class="aspect-square overflow-hidden rounded-lg">
                                        <a href="${pageContext.request.contextPath}/assets/home/images/gallery/pic${i}.jpg" 
                                           class="gallery-lightbox block w-full h-full">
                                            <img src="${pageContext.request.contextPath}/assets/home/images/gallery/pic${i}.jpg" 
                                                 alt="Ảnh ${i}"
                                                 class="w-full h-full object-cover hover:scale-110 transition-transform duration-300">
                                        </a>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Categories -->
                        <div class="bg-white rounded-xl shadow-lg p-6">
                            <h3 class="text-xl font-serif font-semibold text-spa-dark mb-6 flex items-center">
                                <i data-lucide="folder" class="h-5 w-5 mr-2 text-primary"></i>
                                Danh Mục Blog
                            </h3>
                            <div class="space-y-2">
                                <!-- Tất cả danh mục -->
                                <a href="${pageContext.request.contextPath}/blog${not empty param.search ? '?search=' : ''}${param.search}"
                                   class="flex items-center justify-between p-3 rounded-lg hover:bg-spa-cream transition-colors ${empty selectedCategory ? 'bg-primary text-white' : 'text-spa-dark'}">
                                    <span class="font-medium">Tất cả danh mục</span>
                                    <c:if test="${empty selectedCategory}">
                                        <i data-lucide="check" class="h-4 w-4"></i>
                                    </c:if>
                                </a>
                                
                                <!-- Các category động -->
                                <c:forEach var="cat" items="${categories}">
                                    <a href="${pageContext.request.contextPath}/blog?category=${cat.categoryId}${not empty param.search ? '&search=' : ''}${param.search}"
                                       class="flex items-center justify-between p-3 rounded-lg hover:bg-spa-cream transition-colors ${selectedCategory == cat.categoryId ? 'bg-primary text-white' : 'text-spa-dark'}">
                                        <span class="font-medium">${cat.name}</span>
                                        <c:if test="${selectedCategory == cat.categoryId}">
                                            <i data-lucide="check" class="h-4 w-4"></i>
                                        </c:if>
                                    </a>
                                </c:forEach>
                            </div>
                        </div>

                    </div>

                </div>
            </div>
        </section>

        <jsp:include page="/WEB-INF/view/common/footer.jsp" />

        <!-- JavaScript -->
        <script src="<c:url value='/js/app.js'/>"></script>
        <script>
            // Initialize Lucide icons
            lucide.createIcons();

            // Initialize gallery lightbox
            $(document).ready(function() {
                $('.gallery-lightbox').magnificPopup({
                    type: 'image',
                    gallery: { enabled: true }
                });
            });
        </script>
    </body>
</html>
