<%-- 
    Document   : blog_details
    Created on : Jun 18, 2025, 2:23:40 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
                                        <c:out value="${blog.content}" escapeXml="false"/>
                                    </div>
                                </div>
                                <div class="clear" id="comment-list">
                                    <div class="comments-area" id="comments">
                                        <h2 class="comments-title">8 Comments</h2>
                                        <div class="clearfix m-b20">
                                            <!-- comment list END -->
                                            <ol class="comment-list">
                                                <li class="comment">
                                                    <div class="comment-body">
                                                        <div class="comment-author vcard">
                                                            <img  class="avatar photo" src="${pageContext.request.contextPath}/assets/home/images/testimonials/pic1.jpg" alt=""> 
                                                            <cite class="fn">Stacy poe</cite> 
                                                            <span class="says">says:</span>
                                                        </div>
                                                        <div class="comment-meta">
                                                            <a href="javascript:void(0);">October 6, 2024 at 7:15 am</a>
                                                        </div>
                                                        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam vitae neqnsectetur adipiscing elit. Nam viae neqnsectetur adipiscing elit. Nam vitae neque vitae sapien malesuada aliquet.</p>
                                                        <div class="reply">
                                                            <a href="javascript:void(0);" class="comment-reply-link">Reply</a>
                                                        </div>
                                                    </div>
                                                    <ol class="children">
                                                        <li class="comment odd parent">
                                                            <div class="comment-body">
                                                                <div class="comment-author vcard">
                                                                    <img  class="avatar photo" src="${pageContext.request.contextPath}/assets/home/images/testimonials/pic2.jpg" alt="">
                                                                    <cite class="fn">Stacy poe</cite>
                                                                    <span class="says">says:</span>
                                                                </div>
                                                                <div class="comment-meta">
                                                                    <a href="javascript:void(0);">October 6, 2024 at 7:15 am</a>
                                                                </div>
                                                                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam vitae neque vitae sapien malesuada aliquet. In viverra dictum justo in vehicula. Fusce et massa eu ante ornare molestie. Sed vestibulum sem felis, ac elementum ligula blandit ac.</p>
                                                                <div class="reply">
                                                                    <a href="javascript:void(0);" class="comment-reply-link">Reply</a>
                                                                </div>
                                                            </div>
                                                            <ol class="children">
                                                                <li class="comment odd parent">
                                                                    <div class="comment-body">
                                                                        <div class="comment-author vcard">
                                                                            <img  class="avatar photo" src="${pageContext.request.contextPath}/assets/home/images/testimonials/pic3.jpg" alt="">
                                                                            <cite class="fn">Stacy poe</cite>
                                                                            <span class="says">says:</span>
                                                                        </div>
                                                                        <div class="comment-meta">
                                                                            <a href="javascript:void(0);">October 6, 2024 at 7:15 am</a>
                                                                        </div>
                                                                        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam vitae neque vitae sapien malesuada aliquet. In viverra dictum justo in vehicula. Fusce et massa eu ante ornare molestie. Sed vestibulum sem felis, ac elementum ligula blandit ac.</p>
                                                                        <div class="reply">
                                                                            <a href="javascript:void(0);" class="comment-reply-link">Reply</a>
                                                                        </div>
                                                                    </div>
                                                                </li>
                                                            </ol>
                                                            <!-- list END -->
                                                        </li>
                                                    </ol>
                                                    <!-- list END -->
                                                </li>
                                                <li class="comment">
                                                    <div class="comment-body">
                                                        <div class="comment-author vcard">
                                                            <img  class="avatar photo" src="${pageContext.request.contextPath}/assets/home/images/testimonials/pic1.jpg" alt="">
                                                            <cite class="fn">Stacy poe</cite>
                                                            <span class="says">says:</span>
                                                        </div>
                                                        <div class="comment-meta">
                                                            <a href="javascript:void(0);">October 6, 2024 at 7:15 am</a>
                                                        </div>
                                                        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam vitae neque vitae sapien malesuada aliquet. In viverra dictum justo in vehicula. Fusce et massa eu ante ornare molestie. Sed vestibulum sem felis, ac elementum ligula blandit ac.</p>
                                                        <div class="reply">
                                                            <a href="javascript:void(0);" class="comment-reply-link">Reply</a>
                                                        </div>
                                                    </div>
                                                </li>
                                                <li class="comment">
                                                    <div class="comment-body">
                                                        <div class="comment-author vcard">
                                                            <img  class="avatar photo" src="${pageContext.request.contextPath}/assets/home/images/testimonials/pic2.jpg" alt="">
                                                            <cite class="fn">Stacy poe</cite>
                                                            <span class="says">says:</span>
                                                        </div>
                                                        <div class="comment-meta">
                                                            <a href="javascript:void(0);">October 6, 2024 at 7:15 am</a>
                                                        </div>
                                                        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam vitae neque vitae sapien malesuada aliquet. In viverra dictum justo in vehicula. Fusce et massa eu ante ornare molestie. Sed vestibulum sem felis, ac elementum ligula blandit ac.</p>
                                                        <div class="reply">
                                                            <a href="javascript:void(0);" class="comment-reply-link">Reply</a>
                                                        </div>
                                                    </div>
                                                </li>
                                                <li class="comment">
                                                    <div class="comment-body">
                                                        <div class="comment-author vcard">
                                                            <img  class="avatar photo" src="${pageContext.request.contextPath}/assets/home/images/testimonials/pic3.jpg" alt="">
                                                            <cite class="fn">Stacy poe</cite>
                                                            <span class="says">says:</span>
                                                        </div>
                                                        <div class="comment-meta">
                                                            <a href="javascript:void(0);">October 6, 2024 at 7:15 am</a>
                                                        </div>
                                                        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam vitae neque vitae sapien malesuada aliquet. In viverra dictum justo in vehicula. Fusce et massa eu ante ornare molestie. Sed vestibulum sem felis, ac elementum ligula blandit ac.</p>
                                                        <div class="reply">
                                                            <a href="javascript:void(0);" class="comment-reply-link">Reply</a>
                                                        </div>
                                                    </div>
                                                </li>
                                            </ol>
                                            <!-- comment list END -->
                                            <!-- Form -->
                                            <div class="comment-respond" id="respond">
                                                <h4 class="comment-reply-title" id="reply-title">Leave a Reply <small> <a style="display:none;" href="javascript:void(0);" id="cancel-comment-reply-link" rel="nofollow">Cancel reply</a> </small> </h4>
                                                <form class="comment-form" id="commentform" method="post">
                                                    <p class="comment-form-author">
                                                        <label for="author">Name <span class="required">*</span></label>
                                                        <input type="text" value="Author" name="Author"  placeholder="Author" id="author">
                                                    </p>
                                                    <p class="comment-form-email">
                                                        <label for="email">Email <span class="required">*</span></label>
                                                        <input type="text" value="email" placeholder="Email" name="email" id="email">
                                                    </p>
                                                    <p class="comment-form-url">
                                                        <label for="url">Website</label>
                                                        <input type="text"  value="url"  placeholder="Website"  name="url" id="url">
                                                    </p>
                                                    <p class="comment-form-comment">
                                                        <label for="comment">Comment</label>
                                                        <textarea rows="8" name="comment" placeholder="Comment" id="comment"></textarea>
                                                    </p>
                                                    <p class="form-submit">
                                                        <input type="submit" value="Post Comment" class="submit" id="submit" name="submit">
                                                    </p>
                                                </form>
                                            </div>
                                            <!-- Form -->
                                        </div>
                                    </div>
                                </div>
                                <!-- blog END -->
                            </div>
                            <!-- Left part END -->
                            <!-- Side bar start -->
                            <div class="col-lg-4 col-md-12 sticky-top">
                                <aside  class="side-bar">
                                    <div class="widget">
                                        <h6 class="widget-title style-1">Search</h6>
                                        <div class="search-bx style-1">
                                            <form role="search" method="post">
                                                <div class="input-group">
                                                    <input name="text" class="form-control" placeholder="Enter your keywords..." type="text">
                                                    <span class="input-group-btn">
                                                        <button type="submit" class="fa fa-search text-primary"></button>
                                                    </span> 
                                                </div>
                                            </form>
                                        </div>
                                    </div>
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
                                                                <a href="${pageContext.request.contextPath}/blog-detail?slug=${rb.slug}">${rb.title}</a>
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
                                    <div class="widget widget-newslatter">
                                        <h6 class="widget-title style-1">Newsletter</h6>
                                        <div class="news-box">
                                            <p>Enter your e-mail and subscribe to our newsletter.</p>
                                            <form class="dzSubscribe" action="https://www.beautyzone.dexignzone.com/xhtml/script/mailchamp.php" method="post">
                                                <div class="dzSubscribeMsg"></div>
                                                <div class="input-group">
                                                    <input name="dzEmail" required="required" type="email" class="form-control" placeholder="Your Email">
                                                    <button name="submit" value="Submit" type="submit" class="site-button btn-block radius-no">Subscribe Now</button>
                                                </div>
                                            </form>
                                        </div>
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
    </body>

    <!-- Mirrored from www.beautyzone.dexignzone.com/xhtml/post-right-sidebar.html by HTTrack Website Copier/3.x [XR&CO'2014], Sat, 24 May 2025 16:40:33 GMT -->
</html>
