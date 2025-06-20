<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <!DOCTYPE html>
            <html lang="en" data-theme="light">

            <head>
                <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Services - Admin Dashboard</title>
                <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
                <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />

                <style>
                    .limit-description {
                        display: -webkit-box;
                        -webkit-box-orient: vertical;
                        -webkit-line-clamp: 3;
                        overflow: hidden;
                        text-overflow: ellipsis;
                        max-height: 4.8em;
                        min-width: 0;
                        width: 100%;
                        line-height: 1.6em;
                        word-break: break-word;
                        white-space: normal;
                    }

                    .service-img-wrapper {
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        height: 70px;
                    }

                    .service-img {
                        width: 64px;
                        height: 64px;
                        object-fit: cover;
                        border-radius: 12px;
                        border: 1px solid #e0e0e0;
                        background: #fafafa;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
                    }

                    .rating-stars {
                        color: #ffc107;
                    }

                    .rating-stars .far {
                        color: #e0e0e0;
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

                    .table td,
                    .table th {
                        white-space: nowrap;
                        text-overflow: ellipsis;
                        overflow: hidden;
                        max-width: 220px;
                    }

                    .table td.limit-description {
                        white-space: normal;
                        max-width: 350px;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
                <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

                <div class="dashboard-main-body">
                    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                        <h6 class="fw-semibold mb-0">Danh Sách Dịch Vụ</h6>
                        <ul class="d-flex align-items-center gap-2">
                            <li class="fw-medium">
                                <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                                    <iconify-icon icon="solar:home-smile-angle-outline"
                                        class="icon text-lg"></iconify-icon>
                                    Trang Chủ
                                </a>
                            </li>
                            <li>-</li>
                            <li class="fw-medium">Danh Sách Dịch Vụ</li>
                        </ul>
                    </div>

                    <div class="card h-100 p-0 radius-12">
                        <div
                            class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center flex-wrap gap-3 justify-content-between">
                            <div class="d-flex align-items-center flex-wrap gap-3">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="text-md fw-medium text-secondary-light mb-0">Hiển thị</span>
                                    <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px"
                                        id="limitSelect" onchange="changeLimit(this.value)">
                                        <c:forEach var="i" begin="1" end="10">
                                            <option value="${i}" ${limit==i ? 'selected' : '' }>${i}</option>
                                        </c:forEach>
                                    </select>
                                    <span class="text-md fw-medium text-secondary-light mb-0">mục</span>
                                </div>
                                <form class="navbar-search d-flex gap-2 align-items-center" method="get"
                                    action="service">
                                    <input type="text" class="bg-base h-40-px w-auto" name="keyword"
                                        placeholder="Tìm kiếm" value="${keyword}">
                                    <select name="serviceTypeId" class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px">
                                        <option value="">Tất cả loại dịch vụ</option>
                                        <c:forEach var="stype" items="${serviceTypes}">
                                            <option value="${stype.serviceTypeId}" <c:if test="${param.serviceTypeId == stype.serviceTypeId}">selected</c:if>>
                                                ${stype.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px"
                                        name="status">
                                        <option value="">Tất cả trạng Thái</option>
                                        <option value="active" ${status=='active' ? 'selected' : '' }>Active
                                        </option>
                                        <option value="inactive" ${status=='inactive' ? 'selected' : '' }>Inactive</option>
                                    </select>
                                    <input type="hidden" name="service" value="search">
                                    <input type="hidden" name="limit" value="${limit}" />
                                    <button type="submit" class="btn btn-primary h-40-px radius-12">Tìm Kiếm</button>
                                </form>
                            </div>
                            <a href="service?service=pre-insert&page=${currentPage}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}${not empty serviceTypeId ? '&serviceTypeId='.concat(serviceTypeId) : ''}"
                                class="btn btn-primary text-sm btn-sm px-12 py-12 radius-8 d-flex align-items-center gap-2">
                                <iconify-icon icon="ic:baseline-plus" class="icon text-xl line-height-1"></iconify-icon>
                                Thêm Dịch Vụ Mới
                            </a>
                        </div>

                        <c:if test="${not empty services}">
                            <c:set var="searchParams" value=""/>
                            <c:if test="${not empty keyword}">
                                <c:set var="searchParams" value="${searchParams}&keyword=${keyword}"/>
                            </c:if>
                            <c:if test="${not empty status}">
                                <c:set var="searchParams" value="${searchParams}&status=${status}"/>
                            </c:if>
                            <c:if test="${not empty serviceTypeId}">
                                <c:set var="searchParams" value="${searchParams}&serviceTypeId=${serviceTypeId}"/>
                            </c:if>
                            <div class="card-body p-24">
                                <div class="table-responsive">
                                    <table class="table bordered-table sm-table mb-0" style="table-layout: fixed;">
                                        <thead>
                                            <tr>
                                                <th scope="col" style="width: 4%; text-align: center;">Mã</th>
                                                <th scope="col" style="width: 10%; text-align: center;">Hình Ảnh</th>
                                                <th scope="col" style="width: 18%;">Tên Dịch Vụ</th>
                                                <th scope="col" style="width: 16%;">Loại Dịch Vụ</th>
                                                <th scope="col" style="width: 10%; text-align: center;">Thời Gian</th>
                                                <th scope="col" style="width: 10%; text-align: center;">Đánh Giá</th>
                                                <th scope="col" style="width: 10%; text-align: right;">Giá</th>
                                                <th scope="col" style="width: 10%; text-align: center;">Trạng Thái</th>
                                                <th scope="col" style="width: 12%; text-align: center;">Thao Tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="service" items="${services}">
                                                <tr>
                                                    <td class="text-center">${service.serviceId}</td>
                                                    <td class="text-center">
                                                        <div class="service-img-wrapper">
                                                            <img src="${pageContext.request.contextPath}${serviceThumbnails[service.serviceId]}" alt="Service Image" style="width: 60px; height: 60px; object-fit: cover;">
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="limit-description"
                                                             data-bs-toggle="tooltip"
                                                             data-bs-title="${service.name}">
                                                            ${service.name}
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="limit-description"
                                                             data-bs-toggle="tooltip"
                                                             data-bs-title="${service.serviceTypeId.name}">
                                                            ${service.serviceTypeId.name}
                                                        </div>
                                                    </td>
                                                    <td class="text-center">${service.durationMinutes} phút</td>
                                                    <td class="text-center">
                                                        <span style="color: #ffc107; font-weight: 500;">(${service.averageRating})</span>
                                                    </td>
                                                    <td style="text-align: right;">
                                                        <fmt:formatNumber value="${service.price}" type="number"
                                                            maxFractionDigits="0" /> VND
                                                    </td>
                                                    <td class="text-center">
                                                        <c:choose>
                                                            <c:when test="${service.isActive}">
                                                                <span
                                                                    class="bg-success-focus text-success-600 border border-success-main px-24 py-4 radius-4 fw-medium text-sm">Active</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span
                                                                    class="bg-neutral-200 text-neutral-600 border border-neutral-400 px-24 py-4 radius-4 fw-medium text-sm">Inactive</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-center">
                                                        <div
                                                            class="d-flex align-items-center gap-10 justify-content-center">

                                                            <!-- View detail button -->
                                                            <a href="service?service=view-detail&id=${service.serviceId}&page=${currentPage}&limit=${limit}${searchParams}"
                                                                class="bg-info-focus bg-hover-info-200 text-info-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle"
                                                                data-bs-toggle="tooltip"
                                                                data-bs-title="Xem chi tiết dịch vụ">
                                                                <iconify-icon icon="majesticons:eye-line"
                                                                    class="icon text-xl"></iconify-icon>
                                                            </a>

                                                            <!-- Edit button -->
                                                            <a href="service?service=pre-update&id=${service.serviceId}&page=${currentPage}&limit=${limit}${searchParams}"
                                                                class="bg-success-focus text-success-600 bg-hover-success-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle"
                                                                data-bs-toggle="tooltip"
                                                                data-bs-title="Chỉnh sửa dịch vụ">
                                                                <iconify-icon icon="lucide:edit"
                                                                    class="menu-icon"></iconify-icon>
                                                            </a>

                                                            <!-- Deactivate/Activate button -->
                                                            <c:choose>
                                                                <c:when test="${service.isActive}">
                                                                    <a href="service?service=deactivate&id=${service.serviceId}&page=${currentPage}&limit=${limit}${searchParams}"
                                                                        class="bg-danger-focus bg-hover-danger-200 text-danger-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle"
                                                                        data-bs-toggle="tooltip"
                                                                        data-bs-title="Vô hiệu hóa dịch vụ"
                                                                        onclick="return confirmAction('Bạn có chắc chắn muốn vô hiệu hóa dịch vụ này?')">
                                                                        <iconify-icon icon="mdi:block-helper"
                                                                            class="menu-icon"></iconify-icon>
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <a href="service?service=activate&id=${service.serviceId}&page=${currentPage}&limit=${limit}${searchParams}"
                                                                        class="bg-success-focus bg-hover-success-200 text-success-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle"
                                                                        data-bs-toggle="tooltip"
                                                                        data-bs-title="Kích hoạt lại dịch vụ"
                                                                        onclick="return confirmAction('Bạn có chắc chắn muốn kích hoạt lại dịch vụ này?')">
                                                                        <iconify-icon icon="mdi:check-circle-outline" class="menu-icon"></iconify-icon>
                                                                    </a>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Pagination -->
                                <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mt-24">
                                    <c:set var="start" value="${(currentPage - 1) * limit + 1}" />
                                    <c:set var="end"
                                        value="${currentPage * limit > totalEntries ? totalEntries : currentPage * limit}" />
                                    <span>
                                        Hiển thị ${start} đến ${end} của ${totalEntries} mục
                                    </span>
                                    <ul
                                        class="pagination d-flex flex-wrap align-items-center gap-2 justify-content-center">
                                        <!-- Previous -->
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <c:choose>
                                                <c:when test="${currentPage == 1}">
                                                    <a class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px disabled">
                                                        <iconify-icon icon="ep:d-arrow-left"></iconify-icon>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px"
                                                        href="service?service=${param.service != null && param.service != '' ? param.service : 'list-all'}&page=${currentPage - 1}&limit=${limit}${searchParams}">
                                                        <iconify-icon icon="ep:d-arrow-left"></iconify-icon>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>

                                        <!-- Page numbers -->
                                        <c:forEach var="i" begin="1" end="${totalPages}">
                                            <c:choose>
                                                <%-- Hiển thị trang đầu tiên --%>
                                                <c:when test="${i == 1}">
                                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                        <a class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px
                                                            ${i == currentPage ? 'bg-primary-600 text-white' : 'bg-neutral-200 text-secondary-light'}"
                                                            href="service?service=${param.service != null && param.service != '' ? param.service : 'list-all'}&page=${i}&limit=${limit}${searchParams}">
                                                            ${i}
                                                        </a>
                                                    </li>
                                                </c:when>
                                                
                                                <%-- Hiển thị trang cuối cùng --%>
                                                <c:when test="${i == totalPages}">
                                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                        <a class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px
                                                            ${i == currentPage ? 'bg-primary-600 text-white' : 'bg-neutral-200 text-secondary-light'}"
                                                            href="service?service=${param.service != null && param.service != '' ? param.service : 'list-all'}&page=${i}&limit=${limit}${searchParams}">
                                                            ${i}
                                                        </a>
                                                    </li>
                                                </c:when>
                                                
                                                <%-- Hiển thị các trang xung quanh trang hiện tại --%>
                                                <c:when test="${i >= currentPage - 2 && i <= currentPage + 2}">
                                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                        <a class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px
                                                            ${i == currentPage ? 'bg-primary-600 text-white' : 'bg-neutral-200 text-secondary-light'}"
                                                            href="service?service=${param.service != null && param.service != '' ? param.service : 'list-all'}&page=${i}&limit=${limit}${searchParams}">
                                                            ${i}
                                                        </a>
                                                    </li>
                                                </c:when>
                                                
                                                <%-- Hiển thị dấu ... khi cần --%>
                                                <c:when test="${i == currentPage - 3 || i == currentPage + 3}">
                                                    <li class="page-item disabled">
                                                        <span class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px bg-neutral-200 text-secondary-light">
                                                            ...
                                                        </span>
                                                    </li>
                                                </c:when>
                                            </c:choose>
                                        </c:forEach>

                                        <!-- Next -->
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <c:choose>
                                                <c:when test="${currentPage == totalPages}">
                                                    <a class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px disabled">
                                                        <iconify-icon icon="ep:d-arrow-right"></iconify-icon>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px"
                                                        href="service?service=${param.service != null && param.service != '' ? param.service : 'list-all'}&page=${currentPage + 1}&limit=${limit}${searchParams}">
                                                        <iconify-icon icon="ep:d-arrow-right"></iconify-icon>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>

                <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />

                <c:if test="${not empty toastMessage}">
                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            const toast = document.createElement("div");
                            toast.textContent = "${toastMessage}";
                            toast.className = "toast-message ${toastType eq 'success' ? 'toast-success' : 'toast-error'}";

                            document.body.appendChild(toast);

                            setTimeout(() => {
                                toast.classList.add("show");
                            }, 100);

                            setTimeout(() => {
                                toast.classList.remove("show");
                                setTimeout(() => toast.remove(), 300);
                            }, 4000);
                        });
                    </script>
                    <style>
                        .toast-message {
                            position: fixed;
                            top: 20px;
                            right: -300px;
                            z-index: 9999;
                            padding: 12px 20px;
                            border-radius: 8px;
                            font-weight: 500;
                            color: white;
                            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
                            transition: right 0.3s ease;
                            max-width: 300px;
                        }

                        .toast-success {
                            background-color: #4CAF50;
                        }

                        .toast-error {
                            background-color: #f44336;
                        }

                        .toast-message.show {
                            right: 20px;
                        }
                    </style>
                </c:if>

                <script>
                    function confirmAction(message) {
                        return confirm(message);
                    }

                    function changeLimit(newLimit) {
                        let currentUrl = new URL(window.location.href);
                        let searchParams = currentUrl.searchParams;

                        // Giữ lại các tham số tìm kiếm nếu có
                        if (searchParams.has('keyword') || searchParams.has('status') || searchParams.has('serviceTypeId')) {
                            searchParams.set('service', 'search');
                        } else {
                            searchParams.set('service', 'list-all');
                        }

                        searchParams.set('limit', newLimit);
                        searchParams.set('page', '1'); // Reset về trang 1

                        window.location.href = currentUrl.pathname + '?' + searchParams.toString();
                    }

                    document.addEventListener('DOMContentLoaded', function () {
                        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                            return new bootstrap.Tooltip(tooltipTriggerEl, {
                                trigger: 'hover'
                            });
                        });
                    });
                </script>
            </body>

            </html>