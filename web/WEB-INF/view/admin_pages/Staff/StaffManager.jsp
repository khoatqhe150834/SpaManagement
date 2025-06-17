<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff - Admin Dashboard</title>
    <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp"></jsp:include>
    <style>
        .bio-wrap {
            white-space: pre-line;
            word-break: break-word;
            max-width: 260px;
            min-width: 120px;
        }
        .table td, .table th {
            white-space: normal !important;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp"></jsp:include>
<jsp:include page="/WEB-INF/view/common/admin/header.jsp"></jsp:include>
<div class="dashboard-main-body">
    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
        <h6 class="fw-semibold mb-0">Danh sách Nhân Viên</h6>
        <ul class="d-flex align-items-center gap-2">
            <li class="fw-medium">
                <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                    <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                    Dashboard
                </a>
            </li>
            <li>-</li>
            <li class="fw-medium">Danh sách Nhân Viên</li>
        </ul>
    </div>
    <div class="card h-100 p-0 radius-12">
        <div class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center flex-wrap gap-3 justify-content-between">
            <div class="d-flex align-items-center flex-wrap gap-3">
                <div class="d-flex align-items-center gap-2">
                    <span class="text-md fw-medium text-secondary-light mb-0">Hiển thị</span>
                    <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" id="limitSelect" onchange="changeLimit(this.value)">
                        <c:forEach var="i" begin="1" end="10">
                            <option value="${i}" ${limit == i ? 'selected' : ''}>${i}</option>
                        </c:forEach>
                    </select>
                </div>
                <form class="navbar-search d-flex gap-2 align-items-center" method="get" action="staff">
                    <input type="text" class="bg-base h-40-px w-auto" name="keyword" placeholder="Search" value="${keyword}">
                    <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="status">
                        <option value="">Trạng thái</option>
                        <option value="available" ${status=='available' ? 'selected' : '' }>Available</option>
                        <option value="busy" ${status=='busy' ? 'selected' : '' }>Busy</option>
                        <option value="offline" ${status=='offline' ? 'selected' : '' }>Offline</option>
                        <option value="on_leave" ${status=='on_leave' ? 'selected' : '' }>On Leave</option>
                    </select>
                    <input type="hidden" name="service" value="search">
                    <input type="hidden" name="limit" value="${limit}" />
                    <button type="submit" class="btn btn-primary h-40-px radius-12">Search</button>
                </form>
            </div>
            <a href="staff?service=pre-insert" class="btn btn-primary text-sm btn-sm px-12 py-12 radius-8 d-flex align-items-center gap-2">
                <iconify-icon icon="ic:baseline-plus" class="icon text-xl line-height-1"></iconify-icon>
                Thêm Nhân Viên Mới
            </a>
        </div>
        <div class="card-body p-24">
            <div class="table-responsive scroll-sm">
                <table class="table bordered-table sm-table mb-0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên</th>
                            <th>Loại Dịch Vụ</th>
                            <th>Tiểu Sử</th>
                            <th class="text-center">Trạng Thái</th>
                            <th>EXP (Năm)</th>
                            <th class="text-center">Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="therapist" items="${staffList}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td>${therapist.user.fullName}</td>
                                <td><c:if test="${not empty therapist.serviceType}">${therapist.serviceType.name}</c:if></td>
                                <td><div class="bio-wrap">${therapist.bio}</div></td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${therapist.availabilityStatus == 'AVAILABLE'}">
                                            <span class="bg-success-focus text-success-600 border border-success-main px-24 py-4 radius-4 fw-medium text-sm">Available</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="bg-neutral-200 text-neutral-600 border border-neutral-400 px-24 py-4 radius-4 fw-medium text-sm">${therapist.availabilityStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${therapist.yearsOfExperience}</td>
                                <td class="text-center">
                                    <div class="d-flex align-items-center gap-10 justify-content-center">
                                        <a href="staff?service=viewById&id=${therapist.user.userId}" class="bg-info-focus text-info-600 w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Xem chi tiết">
                                            <iconify-icon icon="majesticons:eye-line" class="icon text-xl"></iconify-icon>
                                        </a>
                                        <a href="staff?service=pre-update&id=${therapist.user.userId}" class="bg-success-focus text-success-600 w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Chỉnh sửa">
                                            <iconify-icon icon="lucide:edit" class="menu-icon"></iconify-icon>
                                        </a>
                                        <a href="staff?service=deactiveById&id=${therapist.user.userId}" class="bg-warning-focus text-warning-600 w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Vô hiệu hóa" onclick="return confirm('Bạn có chắc chắn muốn vô hiệu hóa nhân viên này?');">
                                            <iconify-icon icon="uil:calendar" class="menu-icon"></iconify-icon>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mt-24">
                <c:set var="start" value="${(currentPage - 1) * limit + 1}" />
                <c:set var="end" value="${currentPage * limit > totalEntries ? totalEntries : currentPage * limit}" />
                <span>Hiển thị từ ${start} đến ${end} của ${totalEntries} mục</span>
                <ul class="pagination d-flex flex-wrap align-items-center gap-2 justify-content-center">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="staff?service=list-all&page=${currentPage - 1}&limit=${limit}">
                            <iconify-icon icon="ep:d-arrow-left"></iconify-icon>
                        </a>
                    </li>
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <c:choose>
                            <c:when test="${i == currentPage - 3 || i == currentPage + 3}">
                                <li class="page-item disabled"><span class="page-link">...</span></li>
                            </c:when>
                            <c:when test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="staff?service=list-all&page=${i}&limit=${limit}">${i}</a>
                                </li>
                            </c:when>
                        </c:choose>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="staff?service=list-all&page=${currentPage + 1}&limit=${limit}">
                            <iconify-icon icon="ep:d-arrow-right"></iconify-icon>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>
<jsp:include page="/WEB-INF/view/common/admin/js.jsp"></jsp:include>
<c:if test="${not empty toastMessage}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const toast = document.createElement("div");
            toast.textContent = "${toastMessage}";
            toast.className = "toast-message ${toastType eq 'success' ? 'toast-success' : 'toast-error'}";
            document.body.appendChild(toast);
            setTimeout(() => toast.classList.add("show"), 100);
            setTimeout(() => toast.classList.remove("show"), 4000);
        });
    </script>
</c:if>
<script>
    function changeLimit(newLimit) {
        let currentUrl = new URL(window.location.href);
        let searchParams = currentUrl.searchParams;
        if (searchParams.has('keyword')) {
            searchParams.set('service', 'search');
        } else {
            searchParams.set('service', 'list-all');
        }
        searchParams.set('limit', newLimit);
        searchParams.set('page', '1');
        window.location.href = currentUrl.pathname + '?' + searchParams.toString();
    }
</script>
</body>
</html>
