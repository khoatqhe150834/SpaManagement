<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Service Reviews - Admin Dashboard</title>
</head>
<body>
<jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
<jsp:include page="/WEB-INF/view/common/admin/header.jsp" />
<div class="dashboard-main-body">
    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
        <h6 class="fw-semibold mb-0">Danh Sách Đánh Giá Dịch Vụ</h6>
        <a href="/admin/review?action=add" class="btn btn-primary text-sm btn-sm px-12 py-12 radius-8 d-flex align-items-center gap-2">
            <iconify-icon icon="ic:baseline-plus" class="icon text-xl line-height-1"></iconify-icon>
            Thêm Đánh Giá Mới
        </a>
    </div>
    <div class="card h-100 p-0 radius-12">
        <div class="card-body p-24">
            <div class="table-responsive">
                <table class="table bordered-table sm-table mb-0" style="table-layout: fixed;">
                    <thead>
                        <tr>
                            <th style="width: 4%; text-align: center;">ID</th>
                            <th style="width: 15%;">Dịch vụ</th>
                            <th style="width: 15%;">Khách hàng</th>
                            <th style="width: 8%; text-align: center;">Rating</th>
                            <th style="width: 18%;">Tiêu đề</th>
                            <th style="width: 25%;">Nội dung</th>
                            <th style="width: 10%;">Ngày tạo</th>
                            <th style="width: 13%; text-align: center;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="review" items="${reviews}">
                            <tr>
                                <td class="text-center">${review.reviewId}</td>
                                <td>${review.serviceId.name}</td>
                                <td>${review.customerId.fullName}</td>
                                <td class="text-center">
                                    <span style="color: #ffc107; font-weight: 500;">${review.rating}</span>
                                </td>
                                <td>${review.title}</td>
                                <td>${review.comment}</td>
                                <td><fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy"/></td>
                                <td class="text-center">
                                    <a href="/admin/review?action=edit&id=${review.reviewId}" class="btn btn-sm btn-success radius-8 px-2 py-1"><iconify-icon icon="lucide:edit"></iconify-icon></a>
                                    <a href="/admin/review?action=delete&id=${review.reviewId}" class="btn btn-sm btn-danger radius-8 px-2 py-1" onclick="return confirm('Bạn có chắc chắn muốn xóa đánh giá này?')"><iconify-icon icon="mdi:delete"></iconify-icon></a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <!-- Pagination -->
            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mt-24">
                <c:set var="start" value="${(currentPage - 1) * limit + 1}" />
                <c:set var="end" value="${currentPage * limit > totalEntries ? totalEntries : currentPage * limit}" />
                <span>Hiển thị ${start} đến ${end} của ${totalEntries} mục</span>
                <ul class="pagination d-flex flex-wrap align-items-center gap-2 justify-content-center">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px ${currentPage == 1 ? 'disabled' : ''}" href="/admin/review?page=${currentPage - 1}&limit=${limit}"><iconify-icon icon="ep:d-arrow-left"></iconify-icon></a>
                    </li>
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px ${i == currentPage ? 'bg-primary-600 text-white' : 'bg-neutral-200 text-secondary-light'}" href="/admin/review?page=${i}&limit=${limit}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px ${currentPage == totalPages ? 'disabled' : ''}" href="/admin/review?page=${currentPage + 1}&limit=${limit}"><iconify-icon icon="ep:d-arrow-right"></iconify-icon></a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>
<jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html> 