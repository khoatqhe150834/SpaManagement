<%-- Document : blog_details Created on : Jun 18, 2025, 2:22:55 PM Author : ADMIN --%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- meta tags and other links -->
<!DOCTYPE html>
<html lang="en" data-theme="light">

    <!-- Mirrored from wowdash.wowtheme7.com/demo/blog-details.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 03 Feb 2025 04:44:34 GMT -->

    <head>
        <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />

    <body>
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />
        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <div class="d-flex align-items-center gap-2">
                    <a href="${pageContext.request.contextPath}/blog"
                       class="btn btn-secondary radius-8 d-flex align-items-center gap-1">
                        <iconify-icon icon="ep:back" class="text-lg"></iconify-icon>
                        Thoát
                    </a>
                    <h6 class="fw-semibold mb-0 ms-3">Blog Details</h6>
                </div>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/admin-dashboard"
                           class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline"
                                          class="icon text-lg"></iconify-icon>
                            Dashboard
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Blog Details</li>
                </ul>
            </div>

            <div class="row gy-4">
                <div class="col-lg-8">
                    <div class="card p-0 radius-12 overflow-hidden">
                        <div class="card-body p-0">
                            <div style="aspect-ratio: 16/9; width: 100%; overflow: hidden;">
                                <img src="${pageContext.request.contextPath}/${empty blog.featureImageUrl ? 'assets/admin/images/blog/blog-details.png' : blog.featureImageUrl}"
                                     alt="" class="w-100 h-100 object-fit-cover"
                                     style="object-fit: cover; width: 100%; height: 100%;" />
                            </div>
                            <div class="p-32">
                                <div
                                    class="d-flex align-items-center gap-16 justify-content-between flex-wrap mb-24">
                                    <div class="d-flex align-items-center gap-8">
                                        <img src="${pageContext.request.contextPath}/assets/admin/images/user-list/user-list1.png"
                                             alt=""
                                             class="w-48-px h-48-px rounded-circle object-fit-cover">
                                        <div class="d-flex flex-column">
                                            <h6 class="text-lg mb-0">${blog.authorName}</h6>
                                            <span class="text-sm text-neutral-500">
                                                <fmt:formatDate
                                                    value="${blog.publishedAtDate != null ? blog.publishedAtDate : blog.createdAtDate}"
                                                    pattern="MMM dd, yyyy" />
                                            </span>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center gap-md-3 gap-2 flex-wrap">
                                        <div
                                            class="d-flex align-items-center gap-8 text-neutral-500 text-lg fw-medium">
                                            <i class="ri-eye-line"></i>
                                            ${blog.viewCount} views
                                        </div>
                                        <div
                                            class="d-flex align-items-center gap-8 text-neutral-500 text-lg fw-medium">
                                            <i class="ri-calendar-2-line"></i>
                                            <fmt:formatDate
                                                value="${blog.publishedAtDate != null ? blog.publishedAtDate : blog.createdAtDate}"
                                                pattern="MMM dd, yyyy" />
                                        </div>
                                    </div>
                                </div>
                                <h3 class="mb-16">${blog.title}</h3>
                                <p class="text-neutral-500 mb-16">${blog.summary}</p>
                                <div class="text-neutral-500 mb-16">
                                    <c:out value="${contentHtml}" escapeXml="false" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <c:if test="${sessionScope.user != null && sessionScope.user.roleId == 6}">
                            <div class="card mt-24" id="comments">
                                <div class="card-header border-bottom">
                                    <h6 class="text-xl mb-0">Comments</h6>
                                </div>
                                <div class="card-body p-24">
                                    <div class="comment-list d-flex flex-column">
                                        <c:choose>
                                            <c:when test="${empty comments}">
                                                <div class="text-neutral-500">No comments yet.</div>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="comment" items="${comments}">
                                                    <div class="comment-list__item">
                                                        <div class="d-flex align-items-start gap-16">
                                                            <div class="flex-shrink-0">
                                                                <img src="
                                                                     <c:choose>
                                                                         <c:when test='${not empty comment.avatarUrl && fn:startsWith(comment.avatarUrl, "http")}'>
                                                                             ${comment.avatarUrl}
                                                                         </c:when>
                                                                         <c:when test='${not empty comment.avatarUrl}'>
                                                                             ${pageContext.request.contextPath}${comment.avatarUrl}
                                                                         </c:when>
                                                                         <c:otherwise>
                                                                             ${pageContext.request.contextPath}/assets/admin/images/user-list/user-list1.png
                                                                         </c:otherwise>
                                                                     </c:choose>"
                                                                     class="w-60-px h-60-px rounded-circle object-fit-cover" alt="" />
                                                            </div>
                                                            <div
                                                                class="flex-grow-1 border-bottom pb-40 mb-40 border-dashed d-flex align-items-center justify-content-between">
                                                                <div>
                                                                    <h6 class="text-lg mb-4 mb-lg-0">${empty comment.customerName ?
                                                                                                           comment.guestName : comment.customerName}</h6>
                                                                    <span class="text-neutral-500 text-sm">
                                                                        <fmt:formatDate value="${comment.createdAtDate}"
                                                                                        pattern="MMM dd, yyyy 'at' HH:mm" />
                                                                    </span>
                                                                    <p class="text-neutral-600 text-md my-16">${comment.commentText}</p>
                                                                </div>
                                                                <form method="post" action="${pageContext.request.contextPath}/blog"
                                                                      style="display:inline; margin-left: 12px;">
                                                                    <input type="hidden" name="action" value="rejectComment" />
                                                                    <input type="hidden" name="commentId"
                                                                           value="${comment.commentId}" />
                                                                    <input type="hidden" name="id" value="${blog.blogId}" />
                                                                    <button type="submit"
                                                                            class="btn btn-sm btn-danger radius-8">Reject
                                                                        Comment</button>
                                                                </form>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                </div>

                <!-- Sidebar Start -->
                <div class="col-lg-4">
                    <div class="d-flex flex-column gap-24">

                        <!-- Latest Blog -->
                        <div class="card">
                            <div class="card-header border-bottom">
                                <h6 class="text-xl mb-0">Latest Posts</h6>
                            </div>
                            <div class="card-body d-flex flex-column gap-24 p-24">
                                <c:forEach var="recent" items="${recentBlogs}">
                                    <div class="d-flex flex-wrap mb-16">
                                        <a href="${pageContext.request.contextPath}/blog?slug=${recent.slug}"
                                           class="blog__thumb w-100 radius-12 overflow-hidden"
                                           style="aspect-ratio: 16/9; display: block;">
                                            <img src="${pageContext.request.contextPath}/${empty recent.featureImageUrl ? 'assets/admin/images/blog/blog5.png' : recent.featureImageUrl}"
                                                 alt="" class="w-100 h-100 object-fit-cover"
                                                 style="object-fit: cover; width: 100%; height: 100%;" />
                                        </a>
                                        <div class="blog__content">
                                            <h6 class="mb-8">
                                                <a href="${pageContext.request.contextPath}/blog?slug=${recent.slug}"
                                                   class="text-line-2 text-hover-primary-600 text-md transition-2">${recent.title}</a>
                                            </h6>
                                            <p class="text-line-2 text-sm text-neutral-500 mb-0">
                                                ${recent.summary}</p>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                        
                        <!-- Action Buttons -->
                        <c:if test="${sessionScope.user != null && sessionScope.user.roleId == 6}">
                            <div class="card">
                                <div class="card-body p-24">
                                    <a href="${pageContext.request.contextPath}/blog?action=edit&slug=${blog.slug}"
                                       class="btn btn-warning-600 radius-8 px-20 py-11 w-100">Edit Blog</a>
                                </div>
                            </div>
                        </c:if>
                        
                        <c:if test="${sessionScope.user != null && sessionScope.user.roleId == 2}">
                            <div class="card">
                                <div class="card-header border-bottom">
                                    <h6 class="text-xl mb-0">Blog Actions</h6>
                                </div>
                                <div class="card-body p-24">
                                    <c:choose>
                                        <c:when test="${blog.status == 'DRAFT'}">
                                            <form action="${pageContext.request.contextPath}/blog" method="post" class="mb-2">
                                                <input type="hidden" name="action" value="updateBlogStatus">
                                                <input type="hidden" name="blogId" value="${blog.blogId}">
                                                <input type="hidden" name="status" value="PUBLISHED">
                                                <input type="hidden" name="id" value="${blog.blogId}" />
                                                <button type="submit" style="width:100%; background:#28a745; color:#fff; border:none; border-radius:16px; padding:20px 0; font-size:1.2rem; font-weight:600; display:flex; align-items:center; justify-content:center; gap:12px; transition:background 0.2s;" onmouseover="this.style.background='#218838'" onmouseout="this.style.background='#28a745'">
                                                    <iconify-icon icon="mdi:check" style="font-size:1.5rem;"></iconify-icon>
                                                    Approve Blog
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:when test="${blog.status == 'PUBLISHED'}">
                                            <form action="${pageContext.request.contextPath}/blog" method="post" class="mb-2">
                                                <input type="hidden" name="action" value="updateBlogStatus">
                                                <input type="hidden" name="blogId" value="${blog.blogId}">
                                                <input type="hidden" name="status" value="ARCHIVED">
                                                <input type="hidden" name="id" value="${blog.blogId}" />
                                                <button type="submit" style="width:100%; background:#ffc107; color:#212529; border:none; border-radius:16px; padding:20px 0; font-size:1.2rem; font-weight:600; display:flex; align-items:center; justify-content:center; gap:12px; transition:background 0.2s;" onmouseover="this.style.background='#e0a800'" onmouseout="this.style.background='#ffc107'">
                                                    <iconify-icon icon="mdi:archive" style="font-size:1.5rem;"></iconify-icon>
                                                    Archive Blog
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:when test="${blog.status == 'ARCHIVED'}">
                                            <form action="${pageContext.request.contextPath}/blog" method="post" class="mb-2">
                                                <input type="hidden" name="action" value="updateBlogStatus">
                                                <input type="hidden" name="blogId" value="${blog.blogId}">
                                                <input type="hidden" name="status" value="PUBLISHED">
                                                <input type="hidden" name="id" value="${blog.blogId}" />
                                                <button type="submit" style="width:100%; background:#17a2b8; color:#fff; border:none; border-radius:16px; padding:20px 0; font-size:1.2rem; font-weight:600; display:flex; align-items:center; justify-content:center; gap:12px; transition:background 0.2s;" onmouseover="this.style.background='#117a8b'" onmouseout="this.style.background='#17a2b8'">
                                                    <iconify-icon icon="mdi:restore" style="font-size:1.5rem;"></iconify-icon>
                                                    Restore Blog
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



            <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
            <script src="${pageContext.request.contextPath}/assets/admin/js/lib/iconify-icon.min.js"></script>

        </body>

        <!-- Mirrored from wowdash.wowtheme7.com/demo/blog-details.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 03 Feb 2025 04:44:35 GMT -->

    </html>