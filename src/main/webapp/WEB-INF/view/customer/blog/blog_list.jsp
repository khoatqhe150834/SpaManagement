<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Blog List</title>
        <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp"/>
    </head>

    <body id="bg">
        <div class="page-wraper">
            <jsp:include page="/WEB-INF/view/common/home/header.jsp"/>

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
            <div class="dlab-bnr-inr dlab-bnr-inr overlay-primary bg-pt"
                 style="background-image:url(${pageContext.request.contextPath}/assets/home/images/banner/bnr1.jpg);">
                <div class="container">
                    <div class="dlab-bnr-inr-entry">
                        <h1 class="text-white">Blog</h1>
                        <div class="breadcrumb-row">
                            <ul class="list-inline">
                                <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                                <li>Blog</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div><!-- /banner -->

            <!-- ============== CONTENT ============== -->
            <div class="content-area">
                <div class="container">
                    <div class="row justify-content-center">

                        <!-- ========== MAIN LIST ========== -->
                        <div class="col-lg-8 col-md-12 m-b10">

                            <c:forEach var="b" items="${blogs}">
                                <div class="blog-post blog-md clearfix">

                                    <!-- thumbnail -->
                                    <div class="dlab-post-media dlab-img-effect zoom-slow radius-sm">
                                        <a href="${pageContext.request.contextPath}/blog-detail?slug=${b.slug}">
                                            <img src="${pageContext.request.contextPath}/${empty b.featureImageUrl
                                                        ? 'assets/home/images/blog/default/thum1.jpg'
                                                        : b.featureImageUrl}" alt="">
                                        </a>
                                    </div>

                                    <!-- info -->
                                    <div class="dlab-post-info">
                                        <div class="dlab-post-meta">
                                            <ul class="d-flex align-items-center">
                                                <li class="post-date">
                                                    <fmt:formatDate value="${b.publishedAtDate != null ? b.publishedAtDate : b.createdAtDate}"
                                                                    pattern="MMMM dd, yyyy"/>
                                                </li>
                                                <li class="post-author">By <a href="javascript:void(0);">${b.authorName}</a></li>
                                                <li class="post-comment">${b.viewCount} views</li>
                                            </ul>
                                        </div>

                                        <div class="dlab-post-title ">
                                            <h4 class="post-title font-24">
                                                <a href="${pageContext.request.contextPath}/blog-detail?slug=${b.slug}">
                                                    ${b.title}
                                                </a>
                                            </h4>
                                        </div>

                                        <div class="dlab-post-text"><p>${b.summary}</p></div>

                                        <div class="dlab-post-readmore blog-share">
                                            <a href="${pageContext.request.contextPath}/blog-detail?slug=${b.slug}"
                                               class="site-button-link border-link black">ĐỌC THÊM</a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>


                            <!-- ===== Pagination ===== -->
                            <div class="pagination-bx clearfix text-center">
                                <ul class="pagination justify-content-center">
                                    <!-- Prev -->
                                    <li class="previous <c:if test='${currentPage>1}'>disabled</c:if>'">
                                        <a href="${paginationUrl}&page=${currentPage-1}">
                                            <i class="ti-arrow-left"></i> Prev
                                        </a>
                                    </li>

                                    <!-- page numbers -->
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="<c:if test='${i==currentPage}'>active</c:if>">
                                            <a href="${paginationUrl}&page=${i}">${i}</a>
                                        </li>
                                    </c:forEach>

                                    <!-- Next -->
                                    <li class="next <c:if test='${currentPage<totalPages}'>disabled</c:if>'">
                                        <a href="${paginationUrl}&page=${currentPage+1}">
                                            Next <i class="ti-arrow-right"></i>
                                        </a>
                                    </li>
                                </ul>
                            </div><!-- /pagination -->
                        </div><!-- /MAIN -->

                        <!-- ========== SIDEBAR ========== -->
                        <div class="col-lg-4 col-md-12 sticky-top">
                            <aside class="side-bar">

                                <!-- SEARCH widget (name=search) -->
                                <div class="widget">
                                    <h6 class="widget-title style-1">Tìm Kiếm</h6>
                                    <form class="dlab-search-form" method="get"
                                          action="${pageContext.request.contextPath}/blog">
                                        <div class="input-group">
                                            <input type="text" name="search"
                                                   value="${param.search != null ? param.search : ''}"
                                                   class="form-control border-end-0 shadow-none"
                                                   placeholder="Enter your keywords…">
                                            <button type="submit"
                                                    class="btn bg-primary text-white px-3 border-0">
                                                <i class="fa fa-search"></i>
                                            </button>
                                        </div>
                                    </form>
                                </div>

                                <!-- Recent Posts -->
                                <div class="widget recent-posts-entry">
                                    <h6 class="widget-title style-1">Blog Gần Đây</h6>
                                    <div class="widget-post-bx">
                                        <c:forEach var="rb" items="${recentBlogs}">
                                            <div class="widget-post clearfix">
                                                <div class="dlab-post-media">
                                                    <img src="${pageContext.request.contextPath}/${empty rb.featureImageUrl
                                                                ? 'assets/home/images/blog/default/thum1.jpg'
                                                                : rb.featureImageUrl}"
                                                         width="200" height="143" alt="">
                                                </div>
                                                <div class="dlab-post-info">
                                                    <div class="dlab-post-header">
                                                        <h6 class="post-title">
                                                            <a href="${pageContext.request.contextPath}/blog-detail?slug=${rb.slug}">
                                                                ${rb.title}
                                                            </a>
                                                        </h6>
                                                    </div>
                                                    <div class="dlab-post-meta">
                                                        <ul class="d-flex align-items-center">
                                                            <li class="post-date">
                                                                <fmt:formatDate value="${rb.publishedAtDate != null ? rb.publishedAtDate : rb.createdAtDate}"
                                                                                pattern="MMM dd, yyyy"/>
                                                            </li>
                                                            <li class="post-comment">${rb.viewCount} views</li>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Gallery (tĩnh) -->
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

                                <!-- Categories (động, chỉ lấy từ blog_categories) -->
                                <div class="widget widget_archive">
                                    <h6 class="widget-title style-1">Danh Mục Blog</h6>
                                    <ul>
                                        <!-- Dòng 'Tất cả danh mục' -->
                                        <li>
                                            <a href="${pageContext.request.contextPath}/blog${not empty param.search ? '?search=' : ''}${param.search}">
                                                Tất cả danh mục
                                                <c:if test="${empty selectedCategory}"><span style="color:#007bff;"> (đã chọn)</span></c:if>
                                            </a>
                                        </li>
                                        <!-- Các category động -->
                                        <c:forEach var="cat" items="${categories}">
                                            <li>
                                                <a href="${pageContext.request.contextPath}/blog?category=${cat.categoryId}${not empty param.search ? '&search=' : ''}${param.search}">
                                                    ${cat.name}
                                                    <c:if test="${selectedCategory == cat.categoryId}"><span style="color:#007bff;"> (đã chọn)</span></c:if>
                                                </a>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>

                            </aside>
                        </div><!-- /SIDEBAR -->

                    </div>
                </div>
            </div><!-- /content-area -->

            <jsp:include page="/WEB-INF/view/common/home/footer.jsp"/>
        </div><!-- /wraper -->

        <jsp:include page="/WEB-INF/view/common/home/js.jsp"/>
        <script>
        $(document).ready(function() {
            $('.gallery-lightbox').magnificPopup({
                type: 'image',
                gallery: { enabled: true }
            });
        });
        </script>
    </body>
</html>
