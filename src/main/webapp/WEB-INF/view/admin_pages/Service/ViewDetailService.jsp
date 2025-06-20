<%-- 
    Document   : ViewDetailService
    Created on : Jun 20, 2025, 11:24:09 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết dịch vụ - ${service.name}</title>
        <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
        <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
        <style>
            .detail-gallery-img {
                width: 100%;
                height: 300px;
                object-fit: cover;
                border-radius: 12px;
                border: 1px solid #eee;
            }
            .detail-gallery-thumb {
                width: 80px;
                height: 80px;
                object-fit: cover;
                border-radius: 8px;
                cursor: pointer;
                border: 2px solid transparent;
                transition: border-color .2s;
            }
            .detail-gallery-thumb:hover, .detail-gallery-thumb.active {
                border-color: var(--primary-600);
            }
            .detail-icon {
                color: var(--primary-600);
                width: 20px;
                height: 20px;
                margin-right: 12px;
            }
            .list-group-item-detail {
                background-color: transparent;
                border: 0;
                padding-left: 0;
                padding-right: 0;
            }
            .rating-stars {
                color: #ffc107;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Chi tiết dịch vụ: ${service.name}</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="service?service=list-all&page=${page}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}${not empty serviceTypeId ? '&serviceTypeId='.concat(serviceTypeId) : ''}" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Danh sách dịch vụ
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Chi tiết dịch vụ</li>
                </ul>
            </div>

            <div class="card h-100 p-0 radius-12">
                <div class="card-body p-24">
                    <div class="row">
                        <!-- Left Column - Details -->
                        <div class="col-lg-7">
                            <div class="d-flex justify-content-between align-items-start mb-24">
                                <div>
                                    <h4 class="fw-bold">${service.name}</h4>
                                    <p class="text-muted mb-0">Loại dịch vụ: 
                                        <c:choose>
                                            <c:when test="${not empty service.serviceTypeId}">
                                                <span class="text-primary fw-medium">${service.serviceTypeId.name}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-danger-600">Không xác định</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                                <c:if test="${service.isActive}">
                                    <span class="badge bg-success-focus text-success-600 border border-success-main">Active</span>
                                </c:if>
                                <c:if test="${not service.isActive}">
                                    <span class="badge bg-neutral-200 text-neutral-600 border border-neutral-400">Inactive</span>
                                </c:if>
                            </div>
                            
                            <div class="mb-24">
                                <h6 class="fw-semibold mb-12">Mô tả</h6>
                                <p class="text-secondary-light">${service.description}</p>
                            </div>

                            <ul class="list-group list-group-flush mb-24">
                                <li class="list-group-item list-group-item-detail d-flex justify-content-between align-items-center">
                                    <span class="d-flex align-items-center"><iconify-icon icon="solar:tag-price-outline" class="detail-icon"></iconify-icon>Giá dịch vụ</span>
                                    <strong class="text-primary-light"><fmt:formatNumber value="${service.price}" type="number" maxFractionDigits="0" /> VND</strong>
                                </li>
                                <li class="list-group-item list-group-item-detail d-flex justify-content-between align-items-center">
                                    <span class="d-flex align-items-center"><iconify-icon icon="solar:clock-circle-outline" class="detail-icon"></iconify-icon>Thời lượng thực hiện</span>
                                    <strong class="text-primary-light">${service.durationMinutes} phút</strong>
                                </li>
                                <li class="list-group-item list-group-item-detail d-flex justify-content-between align-items-center">
                                    <span class="d-flex align-items-center"><iconify-icon icon="solar:history-outline" class="detail-icon"></iconify-icon>Thời gian chờ sau dịch vụ</span>
                                    <strong class="text-primary-light">${service.bufferTimeAfterMinutes} phút</strong>
                                </li>
                                <li class="list-group-item list-group-item-detail d-flex justify-content-between align-items-center">
                                    <span class="d-flex align-items-center"><iconify-icon icon="solar:star-bold" class="detail-icon rating-stars"></iconify-icon>Đánh giá trung bình</span>
                                    <strong class="text-primary-light rating-stars">${service.averageRating} / 5</strong>
                                </li>
                            </ul>

                            <h6 class="fw-semibold mb-12">Cài đặt</h6>
                            <div class="list-group">
                                 <div class="list-group-item d-flex justify-content-between align-items-center">
                                    <span>Cho phép đặt online</span>
                                    <c:if test="${service.bookableOnline}"><iconify-icon icon="solar:check-circle-bold" class="text-success text-xl"></iconify-icon></c:if>
                                    <c:if test="${not service.bookableOnline}"><iconify-icon icon="solar:close-circle-bold" class="text-danger text-xl"></iconify-icon></c:if>
                                </div>
                                <div class="list-group-item d-flex justify-content-between align-items-center">
                                    <span>Yêu cầu tư vấn</span>
                                    <c:if test="${service.requiresConsultation}"><iconify-icon icon="solar:check-circle-bold" class="text-success text-xl"></iconify-icon></c:if>
                                    <c:if test="${not service.requiresConsultation}"><iconify-icon icon="solar:close-circle-bold" class="text-danger text-xl"></iconify-icon></c:if>
                                </div>
                            </div>

                        </div>

                        <!-- Right Column - Images -->
                        <div class="col-lg-5">
                            <c:if test="${not empty serviceImages}">
                                <img src="${pageContext.request.contextPath}${serviceImages[0].imageUrl}" alt="Service Image" class="detail-gallery-img mb-16" id="mainImage">
                                <div class="d-flex flex-wrap gap-2">
                                    <c:forEach var="img" items="${serviceImages}" varStatus="loop">
                                        <img src="${pageContext.request.contextPath}${img.imageUrl}" alt="Thumbnail" class="detail-gallery-thumb ${loop.index == 0 ? 'active' : ''}" onclick="changeImage('${pageContext.request.contextPath}${img.imageUrl}', this)">
                                    </c:forEach>
                                </div>
                            </c:if>
                            <c:if test="${empty serviceImages}">
                                <div class="d-flex align-items-center justify-content-center h-100 border radius-12 bg-neutral-50">
                                    <p class="text-muted">Chưa có hình ảnh</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
                <div class="card-footer bg-base d-flex justify-content-end gap-3">
                     <a href="service?service=list-all&page=${page}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}${not empty serviceTypeId ? '&serviceTypeId='.concat(serviceTypeId) : ''}" class="btn btn-secondary">Quay lại</a>
                     <a href="service?service=pre-update&id=${service.serviceId}&page=${page}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}${not empty serviceTypeId ? '&serviceTypeId='.concat(serviceTypeId) : ''}" class="btn btn-primary">Chỉnh sửa dịch vụ</a>
                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
        <script>
            function changeImage(src, thumbElement) {
                document.getElementById('mainImage').src = src;
                // Handle active class for thumbs
                document.querySelectorAll('.detail-gallery-thumb').forEach(thumb => thumb.classList.remove('active'));
                thumbElement.classList.add('active');
            }
        </script>
    </body>
</html>
