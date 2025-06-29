<%-- 
    Document   : blog_details
    Created on : Jun 18, 2025, 2:23:40 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setTimeZone value="Asia/Ho_Chi_Minh" />
<!DOCTYPE html>
<html lang="en">

    <!-- Mirrored from www.beautyzone.dexignzone.com/xhtml/post-right-sidebar.html by HTTrack Website Copier/3.x [XR&CO'2014], Sat, 24 May 2025 16:40:33 GMT -->
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="keywords" content="">
        <meta name="author" content="">
        <meta name="robots" content="">
        <meta name="description" content="BeautyZone : Beauty Spa Salon HTML Template">
        <meta property="og:title" content="BeautyZone : Beauty Spa Salon HTML Template">
        <meta property="og:description" content="BeautyZone : Beauty Spa Salon HTML Template">
        <meta property="og:image" content="../../beautyzone.dexignzone.com/xhtml/social-image.png">
        <meta name="format-detection" content="telephone=no">

        <!-- FAVICONS ICON -->
        <link rel="icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.ico" type="image/x-icon">
        <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.png">

        <!-- PAGE TITLE HERE -->
        <title>${blog.title} - Blog Details</title>

        <!-- MOBILE SPECIFIC -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!--[if lt IE 9]>
        <script src="js/html5shiv.min.js"></script>
        <script src="js/respond.min.js"></script>
        <![endif]-->

        <!-- STYLESHEETS -->
        <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp" />

    </head>
    <body id="bg">
        <div class="page-wraper">
            <div id="loading-area"></div>

            <!-- header -->
            <jsp:include page="/WEB-INF/view/common/home/header.jsp"></jsp:include>
            <!-- header END -->
            <!-- Content -->
            <div class="page-content bg-white">
                <!-- inner page banner -->
                    <div class="dlab-bnr-inr dlab-bnr-inr overlay-primary bg-pt" style="background-image:url(${pageContext.request.contextPath}/assets/home/images/banner/bnr1.jpg);">
                        <div class="container">
                            <div class="dlab-bnr-inr-entry">
                                <h1 class="text-white">${blog.title}</h1>
                                <!-- Breadcrumb row -->
                                <div class="breadcrumb-row">
                                    <ul class="list-inline">
                                        <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                                        <li><a href="${pageContext.request.contextPath}/blog">Blog</a></li>
                                        <li>${blog.title}</li>
                                    </ul>
                                </div>
                                <!-- Breadcrumb row END -->
                            </div>
                        </div>
                    </div>
                    <!-- inner page banner END -->
                <div class="content-area">
                    <div class="container">
                        <div class="row">
                            <!-- Left part start -->
                            <div class="col-lg-8 col-md-12 m-b10">
                                <!-- blog start -->
                                <div class="blog-post blog-single blog-style-1">
                                    <div class="dlab-post-meta">
                                        <ul class="d-flex align-items-center">
                                            <li class="post-date">
                                                <fmt:formatDate value="${blog.publishedAtDate != null ? blog.publishedAtDate : blog.createdAtDate}" pattern="MMMM dd, yyyy"/>
                                            </li>
                                            <li class="post-author">By <a href="javascript:void(0);">${blog.authorName}</a></li>
                                            <li class="post-comment">${blog.viewCount} views</li>
                                        </ul>
                                    </div>
                                    <div class="dlab-post-title">
                                        <h1 class="post-title m-t0">${blog.title}</h1>
                                    </div>
                                    <div class="dlab-post-media dlab-img-effect zoom-slow m-t20">
                                        <img src="${pageContext.request.contextPath}/${empty blog.featureImageUrl ? 'assets/home/images/blog/default/thum1.jpg' : blog.featureImageUrl}" alt="">
                                    </div>
                                    <div class="dlab-post-text">
                                        <c:if test="${not empty blog.summary}">
                                            <p><b>${blog.summary}</b></p>
                                        </c:if>
                                        <c:out value="${contentHtml}" escapeXml="false"/>
                                    </div>
                                </div>
                                <div class="clear" id="comment-list">
                                    <div class="comments-area" id="comments">
                                        <h2 class="comments-title">${fn:length(comments)} Bình luận</h2>
                                        <div class="clearfix m-b20">
                                            <!-- comment list START -->
                                            <ol class="comment-list">
                                                <c:forEach var="cmt" items="${comments}">
                                                <li class="comment">
                                                    <div class="comment-body">
                                                        <div class="comment-author vcard">
                                                                <img class="avatar photo" src="${empty cmt.avatarUrl ? pageContext.request.contextPath.concat('/assets/home/images/testimonials/pic1.jpg') : cmt.avatarUrl}" alt="">
                                                                <cite class="fn">${empty cmt.customerName ? cmt.guestName : cmt.customerName}</cite>
                                                            <span class="says">says:</span>
                                                        </div>
                                                        <div class="comment-meta">
                                                                <fmt:formatDate value="${cmt.createdAtDate}" pattern="MMMM dd, yyyy HH:mm"/>
                                                            </div>
                                                            <p>${cmt.commentText}</p>
                                                        </div>
                                                    </li>
                                                </c:forEach>
                                            </ol>
                                            <!-- comment list END -->
                                                        </div>
                                        <!-- Form gửi comment -->
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.customer}">
                                                <div class="comment-respond" id="respond">
                                                    <h4 class="comment-reply-title" id="reply-title">Leave a Reply <small> <a style="display:none;" href="javascript:void(0);" id="cancel-comment-reply-link" rel="nofollow">Cancel reply</a> </small> </h4>
                                                    <form class="comment-form" id="commentform" method="post" action="${pageContext.request.contextPath}/blog" novalidate>
                                                        <input type="hidden" name="slug" value="${blog.slug}"/>
                                                        <div class="mb-3">
                                                            <div class="input-group">
                                                                <span class="input-group-text"><iconify-icon icon="mdi:comment-outline"></iconify-icon></span>
                                                                <textarea rows="5" name="commentText" placeholder="Comment" id="comment" class="form-control" required></textarea>
                                                            </div>
                                                        </div>
                                                        <div class="text-center">
                                                            <input type="submit" value="Post Comment" class="submit btn btn-primary" id="submit" name="submit">
                                                        </div>
                                                    </form>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="alert alert-warning text-center mt-4 mb-4">
                                                    Bạn cần <a href='${pageContext.request.contextPath}/login?returnUrl=${pageContext.request.requestURI}?slug=${blog.slug}'>đăng nhập</a> để bình luận.
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <!-- blog END -->
                            </div>
                            <!-- Left part END -->
                            <!-- Side bar start -->
                            <div class="col-lg-4 col-md-12 sticky-top">
                                <aside  class="side-bar">
                                    <div class="widget recent-posts-entry">
                                        <h6 class="widget-title style-1">Blog Gần Đây</h6>
                                        <div class="widget-post-bx">
                                            <c:forEach var="rb" items="${recentBlogs}">
                                            <div class="widget-post clearfix">
                                                    <div class="dlab-post-media">
                                                        <img src="${pageContext.request.contextPath}/${empty rb.featureImageUrl ? 'assets/home/images/blog/default/thum1.jpg' : rb.featureImageUrl}" width="200" height="143" alt="">
                                                    </div>
                                                <div class="dlab-post-info">
                                                    <div class="dlab-post-header">
                                                            <h6 class="post-title">
                                                                <a href="${pageContext.request.contextPath}/blog?slug=${rb.slug}">${rb.title}</a>
                                                            </h6>
                                                    </div>
                                                    <div class="dlab-post-meta">
                                                        <ul class="d-flex align-items-center">
                                                                <li class="post-date">
                                                                    <fmt:formatDate value="${rb.publishedAtDate != null ? rb.publishedAtDate : rb.createdAtDate}" pattern="MMM dd, yyyy"/>
                                                                </li>
                                                                <li class="post-comment">${rb.viewCount} views</li>
                                                        </ul>
                                                    </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <div class="widget widget_gallery gallery-grid-3">
                                        <h6 class="widget-title style-1">Bộ Sưu Tập</h6>
                                        <ul>
                                            <c:forEach begin="1" end="6" var="i">
                                                <li>
                                                    <div class="dlab-post-thum">
                                                        <a href="${pageContext.request.contextPath}/assets/home/images/gallery/pic${i}.jpg" class="gallery-lightbox" title="Ảnh ${i}">
                                                            <img src="${pageContext.request.contextPath}/assets/home/images/gallery/pic${i}.jpg" alt="">
                                                        </a>
                                                    </div>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                    <div class="widget widget_archive">
                                        <h6 class="widget-title style-1">Danh Mục Blog</h6>
                                        <ul>
                                            <li>
                                                <a href="${pageContext.request.contextPath}/blog">
                                                    Tất cả danh mục
                                                </a>
                                            </li>
                                            <c:forEach var="cat" items="${categories}">
                                                <li>
                                                    <a href="${pageContext.request.contextPath}/blog?category=${cat.categoryId}">
                                                        ${cat.name}
                                                    </a>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </aside>
                            </div>
                            <!-- Side bar END -->
                        </div>
                    </div>
                </div>
            </div>
            <!-- Content END-->
            <!-- Footer -->
            <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
            <!-- Footer END -->
            <button class="scroltop fa fa-chevron-up" ></button>
        </div>
        <!-- JAVASCRIPT FILES ========================================= -->
        <jsp:include page="/WEB-INF/view/common/home/js.jsp" />
        <script>
        $(document).ready(function() {
            $('.gallery-lightbox').magnificPopup({
                type: 'image',
                gallery: { enabled: true }
            });
        });
        </script>
        <script src="${pageContext.request.contextPath}/assets/admin/js/lib/iconify-icon.min.js"></script>
        <!-- Toast notification container -->
        <div id="toast-container" style="position: fixed; top: 90px; right: 30px; z-index: 9999;"></div>
        <script>
        // Validate client-side for comment form (toast notification)
        const form = document.getElementById('commentform');
        const author = document.getElementById('author');
        const email = document.getElementById('email');
        const comment = document.getElementById('comment');
        const toastContainer = document.getElementById('toast-container');

        function validateEmail(email) {
            return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
        }
        function validateName(name) {
            return /^[A-Za-zÀ-ỹ\s]{2,}$/.test(name);
        }
        function validateComment(text) {
            return text.length >= 10 && text.length <= 500;
        }

        function showToast(message) {
            // Xóa toast cũ nếu có
            toastContainer.innerHTML = '';
            const toast = document.createElement('div');
            toast.textContent = message;
            toast.style.background = 'rgba(220,53,69,0.95)';
            toast.style.color = '#fff';
            toast.style.padding = '12px 24px';
            toast.style.borderRadius = '6px';
            toast.style.boxShadow = '0 2px 8px rgba(0,0,0,0.15)';
            toast.style.fontSize = '1rem';
            toast.style.marginBottom = '10px';
            toast.style.minWidth = '220px';
            toast.style.textAlign = 'center';
            toast.style.animation = 'fadeIn 0.3s';
            toastContainer.appendChild(toast);
            setTimeout(() => {
                toastContainer.innerHTML = '';
            }, 3000);
        }

        // Xóa class lỗi khi nhập lại
        function clearInputError(input) {
            input.classList.remove('is-invalid');
        }

        author.addEventListener('blur', function() {
            const val = author.value.trim();
            if (!val) {
                showToast('Vui lòng nhập tên của bạn.');
                author.classList.add('is-invalid');
            } else if (val.length < 2) {
                showToast('Tên phải có ít nhất 2 ký tự.');
                author.classList.add('is-invalid');
            } else if (!validateName(val)) {
                showToast('Tên chỉ được chứa chữ cái và khoảng trắng.');
                author.classList.add('is-invalid');
            } else {
                clearInputError(author);
            }
        });

        email.addEventListener('blur', function() {
            const val = email.value.trim();
            if (!val) {
                showToast('Vui lòng nhập email.');
                email.classList.add('is-invalid');
            } else if (!validateEmail(val)) {
                showToast('Email không hợp lệ.');
                email.classList.add('is-invalid');
            } else {
                clearInputError(email);
            }
        });

        comment.addEventListener('blur', function() {
            const val = comment.value.trim();
            if (!val) {
                showToast('Vui lòng nhập nội dung bình luận.');
                comment.classList.add('is-invalid');
            } else if (val.length < 10) {
                showToast('Bình luận phải có ít nhất 10 ký tự.');
                comment.classList.add('is-invalid');
            } else if (val.length > 500) {
                showToast('Bình luận không được vượt quá 500 ký tự.');
                comment.classList.add('is-invalid');
            } else {
                clearInputError(comment);
            }
        });

        form.addEventListener('submit', function(e) {
            let valid = true;
            const nameVal = author.value.trim();
            const emailVal = email.value.trim();
            const commentVal = comment.value.trim();
            if (!nameVal) {
                showToast('Vui lòng nhập tên của bạn.');
                author.classList.add('is-invalid');
                valid = false;
            } else if (nameVal.length < 2) {
                showToast('Tên phải có ít nhất 2 ký tự.');
                author.classList.add('is-invalid');
                valid = false;
            } else if (!validateName(nameVal)) {
                showToast('Tên chỉ được chứa chữ cái và khoảng trắng.');
                author.classList.add('is-invalid');
                valid = false;
            } else {
                clearInputError(author);
            }
            if (!emailVal) {
                showToast('Vui lòng nhập email.');
                email.classList.add('is-invalid');
                valid = false;
            } else if (!validateEmail(emailVal)) {
                showToast('Email không hợp lệ.');
                email.classList.add('is-invalid');
                valid = false;
            } else {
                clearInputError(email);
            }
            if (!commentVal) {
                showToast('Vui lòng nhập nội dung bình luận.');
                comment.classList.add('is-invalid');
                valid = false;
            } else if (commentVal.length < 10) {
                showToast('Bình luận phải có ít nhất 10 ký tự.');
                comment.classList.add('is-invalid');
                valid = false;
            } else if (commentVal.length > 500) {
                showToast('Bình luận không được vượt quá 500 ký tự.');
                comment.classList.add('is-invalid');
                valid = false;
            } else {
                clearInputError(comment);
            }
            if (!valid) {
                e.preventDefault();
            }
        });
        </script>
    </body>

    <!-- Mirrored from www.beautyzone.dexignzone.com/xhtml/post-right-sidebar.html by HTTrack Website Copier/3.x [XR&CO'2014], Sat, 24 May 2025 16:40:33 GMT -->
</html>
