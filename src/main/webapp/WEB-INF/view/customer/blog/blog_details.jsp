<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setTimeZone value="Asia/Ho_Chi_Minh" />
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>${blog.title} - Spa Hương Sen</title>

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
            .blog-content img {
                max-width: 100%;
                height: auto;
                border-radius: 8px;
                margin: 1rem 0;
            }
            .blog-content p {
                margin-bottom: 1rem;
                line-height: 1.8;
            }
            .blog-content h1, .blog-content h2, .blog-content h3, .blog-content h4, .blog-content h5, .blog-content h6 {
                margin-top: 2rem;
                margin-bottom: 1rem;
                font-weight: 600;
                color: #333333;
            }
        </style>
    </head>

    <body class="bg-spa-cream">
        <jsp:include page="/WEB-INF/view/common/header.jsp" />

        <!-- ===== Banner & breadcrumb ===== -->
        <section class="relative py-32 bg-cover bg-center" 
                 style="background-image: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)), url('${pageContext.request.contextPath}/assets/home/images/banner/bnr1.jpg');">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center text-white">
                <h1 class="text-4xl md:text-5xl font-serif mb-4 line-clamp-2">${blog.title}</h1>
                <div class="flex items-center justify-center space-x-2 text-lg">
                    <a href="${pageContext.request.contextPath}/" class="hover:text-primary transition-colors">Trang chủ</a>
                    <i data-lucide="chevron-right" class="h-5 w-5"></i>
                    <a href="${pageContext.request.contextPath}/blog" class="hover:text-primary transition-colors">Blog</a>
                    <i data-lucide="chevron-right" class="h-5 w-5"></i>
                    <span class="line-clamp-1">${blog.title}</span>
                </div>
            </div>
        </section>

        <!-- ============== CONTENT ============== -->
        <section class="py-16 bg-spa-cream">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

                    <!-- ========== MAIN CONTENT ========== -->
                    <div class="lg:col-span-2 space-y-8">

                        <!-- Blog Article -->
                        <article class="bg-white rounded-xl shadow-lg overflow-hidden">
                            <!-- Meta info -->
                            <div class="p-6 border-b border-gray-100">
                                <div class="flex items-center space-x-4 text-sm text-gray-600 mb-4">
                                    <div class="flex items-center">
                                        <i data-lucide="calendar" class="h-4 w-4 mr-1"></i>
                                        <fmt:formatDate value="${blog.publishedAtDate != null ? blog.publishedAtDate : blog.createdAtDate}" 
                                                        pattern="dd/MM/yyyy"/>
                                    </div>
                                    <div class="flex items-center">
                                        <i data-lucide="user" class="h-4 w-4 mr-1"></i>
                                        <span>${blog.authorName}</span>
                                    </div>
                                    <div class="flex items-center">
                                        <i data-lucide="eye" class="h-4 w-4 mr-1"></i>
                                        <span>${blog.viewCount} lượt xem</span>
                                    </div>
                                </div>
                                
                                <!-- Title -->
                                <h1 class="text-3xl md:text-4xl font-serif font-semibold text-spa-dark mb-4">
                                    ${blog.title}
                                </h1>
                            </div>

                            <!-- Featured Image -->
                            <div class="relative">
                                <img src="${pageContext.request.contextPath}/${empty blog.featureImageUrl 
                                            ? 'assets/home/images/blog/default/thum1.jpg' 
                                            : blog.featureImageUrl}" 
                                     alt="${blog.title}"
                                     class="w-full h-64 md:h-96 object-cover">
                            </div>

                            <!-- Content -->
                            <div class="p-6">
                                <c:if test="${not empty blog.summary}">
                                    <div class="bg-spa-cream p-4 rounded-lg mb-6">
                                        <p class="text-lg font-medium text-spa-dark italic">
                                            "${blog.summary}"
                                        </p>
                                    </div>
                                </c:if>
                                
                                <div class="blog-content text-gray-700 leading-relaxed">
                                    <c:out value="${contentHtml}" escapeXml="false"/>
                                </div>
                            </div>
                        </article>

                        <!-- Comments Section -->
                        <div class="bg-white rounded-xl shadow-lg p-6">
                            <h2 class="text-2xl font-serif font-semibold text-spa-dark mb-6 flex items-center">
                                <i data-lucide="message-circle" class="h-6 w-6 mr-2 text-primary"></i>
                                ${fn:length(comments)} Bình luận
                            </h2>

                            <!-- Comments List -->
                            <div class="space-y-6 mb-8">
                                <c:forEach var="cmt" items="${comments}">
                                    <div class="flex space-x-4">
                                        <div class="flex-shrink-0">
                                            <img class="w-12 h-12 rounded-full object-cover" 
                                                 src="${empty cmt.avatarUrl 
                                                        ? pageContext.request.contextPath.concat('/assets/home/images/testimonials/pic1.jpg') 
                                                        : cmt.avatarUrl}" 
                                                 alt="Avatar">
                                        </div>
                                        <div class="flex-1">
                                            <div class="flex items-center space-x-2 mb-2">
                                                <h4 class="font-semibold text-spa-dark">
                                                    ${empty cmt.customerName ? cmt.guestName : cmt.customerName}
                                                </h4>
                                                <span class="text-sm text-gray-500">
                                                    <fmt:formatDate value="${cmt.createdAtDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                </span>
                                            </div>
                                            <p class="text-gray-700 leading-relaxed">
                                                ${cmt.commentText}
                                            </p>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <!-- Comment Form -->
                            <c:choose>
                                <c:when test="${not empty sessionScope.customer}">
                                    <div class="border-t border-gray-200 pt-6">
                                        <h3 class="text-xl font-serif font-semibold text-spa-dark mb-4">
                                            Viết bình luận
                                        </h3>
                                        <form class="space-y-4" method="post" action="${pageContext.request.contextPath}/blog" novalidate>
                                            <input type="hidden" name="action" value="submitComment" />
                                            <input type="hidden" name="id" value="${blog.blogId}" />
                                            
                                            <div>
                                                <label for="comment" class="block text-sm font-medium text-gray-700 mb-2">
                                                    Nội dung bình luận
                                                </label>
                                                <textarea 
                                                    id="comment"
                                                    name="commentText" 
                                                    rows="5" 
                                                    placeholder="Viết bình luận của bạn..."
                                                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent resize-none"
                                                    required></textarea>
                                            </div>
                                            
                                            <div class="text-right">
                                                <button type="submit" 
                                                        class="px-6 py-3 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors font-semibold">
                                                    Gửi bình luận
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-6 text-center">
                                        <i data-lucide="alert-circle" class="h-8 w-8 text-yellow-600 mx-auto mb-3"></i>
                                        <p class="text-yellow-800 mb-3">
                                            Bạn cần đăng nhập để bình luận
                                        </p>
                                        <a href='${pageContext.request.contextPath}/login?returnUrl=${pageContext.request.requestURI}?id=${blog.blogId}'
                                           class="inline-flex items-center px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors font-semibold">
                                            <i data-lucide="log-in" class="h-4 w-4 mr-2"></i>
                                            Đăng nhập
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                    </div>

                    <!-- ========== SIDEBAR ========== -->
                    <div class="space-y-8">
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
                                <a href="${pageContext.request.contextPath}/blog"
                                   class="flex items-center justify-between p-3 rounded-lg hover:bg-spa-cream transition-colors text-spa-dark">
                                    <span class="font-medium">Tất cả danh mục</span>
                                </a>
                                
                                <c:forEach var="cat" items="${categories}">
                                    <a href="${pageContext.request.contextPath}/blog?category=${cat.categoryId}"
                                       class="flex items-center justify-between p-3 rounded-lg hover:bg-spa-cream transition-colors text-spa-dark">
                                        <span class="font-medium">${cat.name}</span>
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
        <script src="<c:url value='/js/app.js'/>" defer></script>
        
        <script>
window.addEventListener('DOMContentLoaded', function() {
    var form = document.querySelector('form[action*="blog"]');
    var textarea = document.getElementById('comment');
    if (!form || !textarea) return;

    // Tạo counter
    var counter = document.createElement('div');
    counter.className = 'text-sm mt-1 text-right';
    textarea.parentNode.appendChild(counter);

    function updateCounter() {
        var len = textarea.value.length;
        var remain = 500 - len;
        if (remain < 0) {
            counter.textContent = `Quá ${-remain} ký tự`;
            counter.className = 'text-sm text-red-500 mt-1 text-right';
        } else if (remain <= 50) {
            counter.textContent = `Còn ${remain} ký tự`;
            counter.className = 'text-sm text-yellow-500 mt-1 text-right';
        } else {
            counter.textContent = `${len}/500 ký tự`;
            counter.className = 'text-sm text-gray-500 mt-1 text-right';
        }
    }
    textarea.addEventListener('input', updateCounter);
    updateCounter();

    // Toast
    function showToast(msg, type) {
        var old = document.querySelector('.toast-notification');
        if (old) old.remove();
        var toast = document.createElement('div');
        toast.className = 'toast-notification fixed top-4 right-4 z-50 px-6 py-3 rounded-lg text-white font-medium shadow-lg ' + (type==='error'?'bg-red-500':'bg-green-500');
        toast.textContent = msg;
        document.body.appendChild(toast);
        setTimeout(function(){ toast.remove(); }, 3500);
    }

    // Validation logic
    function validate() {
        var val = textarea.value.trim();
        if (!val) {
            showToast('Vui lòng nhập nội dung bình luận.', 'error');
            textarea.classList.remove('border-green-500');
            textarea.classList.add('border-red-500');
            return false;
        }
        if (val.length < 10) {
            showToast('Bình luận phải có ít nhất 10 ký tự.', 'error');
            textarea.classList.remove('border-green-500');
            textarea.classList.add('border-red-500');
            return false;
        }
        if (val.length > 500) {
            showToast('Bình luận không được vượt quá 500 ký tự.', 'error');
            textarea.classList.remove('border-green-500');
            textarea.classList.add('border-red-500');
            return false;
        }
        textarea.classList.remove('border-red-500');
        textarea.classList.add('border-green-500');
        return true;
    }

    textarea.addEventListener('blur', validate);
    textarea.addEventListener('input', function() {
        // realtime feedback
        var val = textarea.value.trim();
        if (val.length > 500 || (val && val.length < 10)) {
            textarea.classList.remove('border-green-500');
            textarea.classList.add('border-red-500');
        } else if (val.length >= 10 && val.length <= 500) {
            textarea.classList.remove('border-red-500');
            textarea.classList.add('border-green-500');
        } else {
            textarea.classList.remove('border-red-500','border-green-500');
        }
    });
    form.addEventListener('submit', function(e) {
        if (!validate()) {
            textarea.focus();
            e.preventDefault();
            return false;
        }
    });
});
</script>
    </body>
</html>
