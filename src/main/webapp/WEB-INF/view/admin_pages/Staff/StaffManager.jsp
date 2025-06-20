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
                    max-width: 180px;
                    min-width: 120px;
                }
                .table td, .table th {
                    white-space: normal !important;
                }
                /* Toast Styles */
                .toast {
                    min-width: 300px;
                    background-color: white;
                    border: none;
                    box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
                }

                .toast-header {
                    border-bottom: none;
                }

                .toast-body {
                    padding: 1rem;
                    font-size: 0.9rem;
                }

                /* Animation for toast */
                .toast.show {
                    animation: slideIn 0.5s ease-in-out;
                }

                @keyframes slideIn {
                    from {
                        transform: translateX(100%);
                        opacity: 0;
                    }
                    to {
                        transform: translateX(0);
                        opacity: 1;
                    }
                }

                .pagination .page-item .page-link {
                    border-radius: 8px !important;
                    border: 1px solid #e0e0e0;
                    color: #1976d2;
                    background: #fff;
                    min-width: 40px;
                    min-height: 40px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-weight: 500;
                    transition: background 0.2s, color 0.2s;
                }
                .pagination .page-item.active .page-link {
                    background: #1976d2;
                    color: #fff;
                    border-color: #1976d2;
                }
                .pagination .page-item.disabled .page-link {
                    color: #bdbdbd;
                    background: #f5f5f5;
                    border-color: #e0e0e0;
                    pointer-events: none;
                }
                .pagination .page-link:hover {
                    background: #e3f2fd;
                    color: #1976d2;
                }

                @media (min-width: 1024px) {
                    .dashboard-main-body,
                    .card-body,
                    .table-responsive {
                        overflow-x: visible !important;
                        max-width: 100% !important;
                    }
                    .table {
                        width: 100% !important;
                        min-width: 900px;
                        table-layout: auto !important;
                    }
                }
                .table td, .table th {
                    white-space: nowrap;
                    text-overflow: ellipsis;
                    overflow: hidden;
                    max-width: 180px;
                }
                .table td.bio-wrap, .table td.wrap-text {
                    white-space: normal;
                    max-width: 140px;
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
                                <span class="text-md fw-medium text-secondary-light mb-0">Hiển thị số mục</span>
                                <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" id="limitSelect" onchange="changeLimit(this.value)">
                                <c:forEach var="i" begin="1" end="10">
                                    <option value="${i}" ${limit == i ? 'selected' : ''}>${i}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <form class="navbar-search d-flex gap-2 align-items-center" method="get" action="staff">
                            <input type="text" class="bg-base h-40-px w-auto" name="keyword" placeholder="Search" value="${keyword}">
                            <select name="serviceTypeId" class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px">
                                <option value="">Tất cả loại dịch vụ</option>
                                <c:forEach var="stype" items="${serviceTypes}">
                                    <option value="${stype.serviceTypeId}" <c:if test="${serviceTypeId == stype.serviceTypeId}">selected</c:if>>
                                        ${stype.name}
                                    </option>
                                </c:forEach>
                            </select>
                            <select name="status" class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px">
                                <option value="">Trạng thái</option>
                                <c:forEach var="s" items="${statusList}">
                                    <option value="${s}" <c:if test="${status == s}">selected</c:if>>
                                        <c:choose>
                                            <c:when test="${s == 'AVAILABLE'}">Available</c:when>
                                            <c:when test="${s == 'BUSY'}">Busy</c:when>
                                            <c:when test="${s == 'OFFLINE'}">Offline</c:when>
                                            <c:when test="${s == 'ON_LEAVE'}">On Leave</c:when>
                                            <c:otherwise>${s}</c:otherwise>
                                        </c:choose>
                                    </option>
                                </c:forEach>
                            </select>
                            <input type="hidden" name="service" value="search">
                            <input type="hidden" name="limit" value="${limit}" />
                            <button type="submit" class="btn btn-primary h-40-px radius-12">Search</button>
                        </form>
                    </div>
                    <a href="staff?service=pre-insert" class="btn btn-primary text-sm btn-sm px-12 py-12 radius-8 d-flex align-items-center gap-2">
                        <iconify-icon icon="ic:baseline-plus" class="icon text-xl line-height-1"></iconify-icon>
                        Thêm Nhân Viên
                    </a>
                </div>
                <div class="card-body p-24">
                    <div class="table-responsive scroll-sm">
                        <table class="table bordered-table sm-table mb-0" style="table-layout: auto; width: 100%;">
                            <thead>
                                <tr>
                                    <th class="text-center">STT</th>
                                    <th class="text-center">Tên</th>
                                    <th class="text-center">Loại Dịch Vụ</th>
                                    <th class="text-center">Tiểu Sử</th>
                                    <th class="text-center">Trạng Thái</th>
                                    <th class="text-center">EXP (Năm)</th>
                                    <th class="text-center">Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="therapist" items="${staffList}" varStatus="status">
                                    <tr>
                                        <td class="text-center">${status.index + 1}</td>
                                        <td class="text-center"><div class="wrap-text">${therapist.user.fullName}</div></td>
                                        <td class="text-center">
                                            <c:if test="${not empty therapist.serviceType}">
                                                <div class="wrap-text">${therapist.serviceType.name}</div>
                                            </c:if>
                                        </td>
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
                                        <td class="text-center">${therapist.yearsOfExperience}</td>
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
                                <a class="page-link" href="staff?service=list-all&page=1&limit=${limit}">
                                    <iconify-icon icon="ic:round-keyboard-double-arrow-left"></iconify-icon>
                                </a>
                            </li>
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="staff?service=list-all&page=${currentPage - 1}&limit=${limit}">
                                    <iconify-icon icon="ep:d-arrow-left"></iconify-icon>
                                </a>
                            </li>
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <c:if test="${i >= currentPage - 2 && i <= currentPage + 2}">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link"
                                           href="staff?service=list-all&page=${i}&limit=${limit}
                                           ${not empty keyword ? '&keyword='.concat(keyword) : ''}
                                           ${not empty status ? '&status='.concat(status) : ''}
                                           ${not empty serviceTypeId ? '&serviceTypeId='.concat(serviceTypeId) : ''}">
                                            ${i}
                                        </a>
                                    </li>
                                </c:if>
                                <c:if test="${i == currentPage - 3 || i == currentPage + 3}">
                                    <li class="page-item disabled"><span class="page-link">...</span></li>
                                </c:if>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="staff?service=list-all&page=${currentPage + 1}&limit=${limit}">
                                    <iconify-icon icon="ep:d-arrow-right"></iconify-icon>
                                </a>
                            </li>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="staff?service=list-all&page=${totalPages}&limit=${limit}">
                                    <iconify-icon icon="ic:round-keyboard-double-arrow-right"></iconify-icon>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="/WEB-INF/view/common/admin/js.jsp"></jsp:include>

            <!-- Add Toast Container -->
            <div class="position-fixed top-0 end-0 p-3" style="z-index: 11">
            <c:if test="${not empty toastMessage}">
                <div class="toast show" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="toast-header ${toastType eq 'success' ? 'bg-success' : 'bg-danger'} text-white">
                        <strong class="me-auto">${toastType eq 'success' ? 'Success' : 'Error'}</strong>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                    <div class="toast-body">
                        ${toastMessage}
                    </div>
                </div>
            </c:if>
        </div>

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

            // Auto hide toast after 3 seconds
            document.addEventListener("DOMContentLoaded", function () {
                const toast = document.querySelector('.toast');
                if (toast) {
                    setTimeout(() => {
                        toast.classList.remove('show');
                        setTimeout(() => toast.remove(), 500);
                    }, 3000);
                }
            });
        </script>
    </body>
</html>
