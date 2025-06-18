<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="keywords" content="">
    <meta name="author" content="">
    <meta name="robots" content="">
    <meta name="description" content="BeautyZone : Beauty Spa Salon HTML Template">
    <meta property="og:title" content="BeautyZone : Beauty Spa Salon HTML Template">
    <meta property="og:description" content="BeautyZone : Beauty Spa Salon HTML Template">
    <meta property="og:image" content="${pageContext.request.contextPath}/assets/home/images/social-image.png">
    <meta name="format-detection" content="telephone=no">

    <link rel="icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.ico" type="image/x-icon">
    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/home/images/favicon.png">

    <title>Blog List</title>

    <meta name="viewport" content="width=device-width, initial-scale=1">
    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp"/>
</head>

<body id="bg">
<div class="page-wraper">
    <div id="loading-area"></div>
    <jsp:include page="/WEB-INF/view/common/home/header.jsp"/>

    <!-- CONTENT -->
    <div class="page-content bg-white">
        <!-- inner banner -->
        <div class="dlab-bnr-inr dlab-bnr-inr overlay-primary bg-pt"
             style="background-image:url(${pageContext.request.contextPath}/assets/home/images/banner/bnr1.jpg);">
            <div class="container">
                <div class="dlab-bnr-inr-entry">
                    <h1 class="text-white">Blog List Right Sidebar</h1>
                    <div class="breadcrumb-row">
                        <ul class="list-inline">
                            <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                            <li>Blog List</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <!-- inner banner END -->

        <!-- blog area -->
        <div class="content-area">
            <div class="container">
                <div class="row justify-content-center">
                    <!-- MAIN LIST -->
                    <div class="col-lg-8 col-md-12 m-b10">

                        <c:forEach var="b" items="${blogs}">
                            <div class="blog-post blog-md clearfix">
                                <div class="dlab-post-media dlab-img-effect zoom-slow radius-sm">
                                    <a href="${pageContext.request.contextPath}/blog-detail?slug=${b.slug}">
                                        <img src="${b.featureImageUrl}" alt="">
                                    </a>
                                </div>

                                <div class="dlab-post-info">
                                    <div class="dlab-post-meta">
                                        <ul class="d-flex align-items-center">
                                            <li class="post-date">
                                                <c:choose>
                                                    <c:when test="${b.publishedAtDate != null}">
                                                        <fmt:formatDate value="${b.publishedAtDate}" pattern="MMMM dd, yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <fmt:formatDate value="${b.createdAtDate}" pattern="MMMM dd, yyyy"/>
                                                    </c:otherwise>
                                                </c:choose>
                                            </li>
                                            <li class="post-author">
                                                By <a href="javascript:void(0);">${b.authorName}</a>
                                            </li>
                                            <li class="post-comment">
                                                <a href="javascript:void(0);">${b.viewCount}</a>
                                            </li>
                                        </ul>
                                    </div>

                                    <div class="dlab-post-title ">
                                        <h4 class="post-title font-24">
                                            <a href="${pageContext.request.contextPath}/blog-detail?slug=${b.slug}">
                                                ${b.title}
                                            </a>
                                        </h4>
                                    </div>

                                    <div class="dlab-post-text">
                                        <p>
                                            <c:choose>
                                                <c:when test="${fn:length(b.summary) > 200}">
                                                    ${fn:substring(b.summary,0,197)}...
                                                </c:when>
                                                <c:otherwise>${b.summary}</c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>

                                    <div class="dlab-post-readmore blog-share">
                                        <a href="${pageContext.request.contextPath}/blog-detail?slug=${b.slug}"
                                           class="site-button-link border-link black">READ MORE</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                        <!-- PAGINATION -->
                        <div class="pagination-bx clearfix text-center">
                            <ul class="pagination justify-content-center">

                                <li class="previous <c:if test='${currentPage == 1}'>disabled</c:if>">
                                    <a href="${pageContext.request.contextPath}/blog?page=${currentPage-1}&search=${search}">
                                        <i class="ti-arrow-left"></i> Prev
                                    </a>
                                </li>

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="<c:if test='${i == currentPage}'>active</c:if>">
                                        <a href="${pageContext.request.contextPath}/blog?page=${i}&search=${search}">
                                            ${i}
                                        </a>
                                    </li>
                                </c:forEach>

                                <li class="next <c:if test='${currentPage == totalPages}'>disabled</c:if>">
                                    <a href="${pageContext.request.contextPath}/blog?page=${currentPage+1}&search=${search}">
                                        Next <i class="ti-arrow-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <!-- MAIN LIST END -->

                    <!-- SIDEBAR -->
                    <div class="col-lg-4 col-md-12 sticky-top">
                        <aside class="side-bar">
                            <!-- Search widget -->
                            <div class="widget">
                                <h6 class="widget-title style-1">Search</h6>
                                <div class="search-bx style-1">
                                    <form method="post" action="${pageContext.request.contextPath}/blog">
                                        <div class="input-group">
                                            <input name="text" class="form-control"
                                                   placeholder="Enter your keywords..."
                                                   value="${search}" type="text">
                                            <span class="input-group-btn">
                                                <button type="submit" class="fa fa-search text-primary"></button>
                                            </span>
                                        </div>
                                    </form>
                                </div>
                            </div>


                        </aside>
                    </div>
                    <!-- SIDEBAR END -->
                </div>
            </div>
        </div>
    </div>
    <!-- CONTENT END -->

    <jsp:include page="/WEB-INF/view/common/home/footer.jsp"/>
    <button class="scroltop fa fa-chevron-up"></button>
</div>

<jsp:include page="/WEB-INF/view/common/home/js.jsp"/>
</body>
</html>
