<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <!-- meta tags and other links -->
            <!DOCTYPE html>
            <html lang="en" data-theme="light">

            <head>
                <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Service Types - Admin Dashboard</title>
                <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
                <!-- CSS here -->
                <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp"></jsp:include>

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

                    .service-type-img-wrapper {
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        height: 70px;
                        /* hoặc 80px nếu muốn cao hơn */
                    }

                    .service-type-img {
                        width: 64px;
                        /* hoặc 72px nếu muốn to hơn nữa */
                        height: 64px;
                        object-fit: cover;
                        border-radius: 12px;
                        border: 1px solid #e0e0e0;
                        background: #fafafa;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
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
                            /* hoặc lớn hơn nếu cần */
                            table-layout: auto !important;
                        }
                    }

                    .table td,
                    .table th {
                        white-space: nowrap;
                        text-overflow: ellipsis;
                        overflow: hidden;
                        max-width: 220px;
                        /* hoặc giá trị phù hợp */
                    }

                    .table td.limit-description {
                        white-space: normal;
                        max-width: 350px;
                    }

                    /* Ẩn một số cột khi ở màn hình nhỏ (dưới 768px) */
                    @media (max-width: 767.98px) {
                        .responsive-table th:nth-child(3),
                        .responsive-table td:nth-child(3),
                        /* Mô tả */
                        .responsive-table th:nth-child(4),
                        .responsive-table td:nth-child(4),
                        /* Hình ảnh */
                        .responsive-table th:nth-child(5),
                        .responsive-table td:nth-child(5)

                        /* Trạng thái */
                            {
                            display: none;
                        }

                        .responsive-table td,
                        .responsive-table th {
                            font-size: 14px;
                            padding: 8px;
                        }
                    }
                </style>

            </head>

            <body>
                <!-- SIDEBAR here -->
                <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp"></jsp:include>

                <!-- HEADER here -->
                <jsp:include page="/WEB-INF/view/common/admin/header.jsp"></jsp:include>

                <div class="dashboard-main-body">
                    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                        <h6 class="fw-semibold mb-0">Service Type List</h6>
                        <ul class="d-flex align-items-center gap-2">
                            <li class="fw-medium">
                                <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                                    <iconify-icon icon="solar:home-smile-angle-outline"
                                        class="icon text-lg"></iconify-icon>
                                    Dashboard
                                </a>
                            </li>
                            <li>-</li>
                            <li class="fw-medium">Service Type List</li>
                        </ul>
                    </div>

                    <div class="card h-100 p-0 radius-12">
                        <div
                            class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center flex-wrap gap-3 justify-content-between">
                            <div class="d-flex align-items-center flex-wrap gap-3">
                                
                                <div class="d-flex align-items-center gap-2">
                                    <span class="text-md fw-medium text-secondary-light mb-0">Show</span>
                                    <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" id="limitSelect" onchange="changeLimit(this.value)">
                                        <c:forEach var="i" begin="1" end="10">
                                            <option value="${i}" ${limit == i ? 'selected' : ''}>${i}</option>
                                        </c:forEach>
                                    </select>
                                    <span class="text-md fw-medium text-secondary-light mb-0">entries</span>
                                </div>
                                <form class="navbar-search d-flex gap-2 align-items-center" method="get"
                                    action="servicetype">
                                    <input type="text" class="bg-base h-40-px w-auto" name="keyword"
                                        placeholder="Search" value="${keyword}">

                                    <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px"
                                        name="status">
                                        <option value="">Trạng thái</option>
                                        <option value="active" ${status=='active' ? 'selected' : '' }>Active</option>
                                        <option value="inactive" ${status=='inactive' ? 'selected' : '' }>Inactive
                                        </option>
                                    </select>
                                    <input type="hidden" name="service" value="searchByKeywordAndStatus">
                                    <input type="hidden" name="limit" value="${limit}" />
                                    <button type="submit" class="btn btn-primary h-40-px radius-12">Search</button>
                                </form>
                            </div>
                            <a href="servicetype?service=pre-insert"
                                class="btn btn-primary text-sm btn-sm px-12 py-12 radius-8 d-flex align-items-center gap-2">
                                <iconify-icon icon="ic:baseline-plus" class="icon text-xl line-height-1"></iconify-icon>
                                Add New Service Type
                            </a>
                        </div>



                        <c:if test="${not empty serviceTypes}">
                            <div class="card-body p-24">
                                <div class="table-responsive ">
                                    <table class="table bordered-table sm-table mb-0 responsive-table">
                                        <thead>
                                            <tr>
                                                <th scope="col" style="width: 8%;">ID</th>
                                                <th scope="col" style="width: 15%;">Tên Loại Dịch Vụ</th>
                                                <th scope="col" style="width: 37%;" class="d-none d-md-table-cell">Mô Tả
                                                </th>
                                                <th scope="col" style="width: 15%;" class="text-center align-middle">
                                                    Hình Ảnh</th>
                                                <th scope="col" style="width: 10%;" class="text-center">Trạng Thái</th>
                                                <th scope="col" style="width: 10%;" class="text-center">Thao Tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="stype" items="${serviceTypes}" varStatus="loop">
                                                <tr>
                                                    <td>${stype.serviceTypeId}</td>
                                                    <td>${stype.name}</td>
                                                    <td>
                                                        <div class="limit-description" data-bs-toggle="tooltip"
                                                            data-bs-title="${stype.description}">
                                                            ${stype.description}
                                                        </div>
                                                    </td>
                                                    <td class="text-center align-middle">
                                                        <div class="service-type-img-wrapper">
                                                            <img src="${stype.imageUrl}" alt="Hình ảnh loại dịch vụ"
                                                                class="service-type-img" />
                                                        </div>
                                                    </td>
                                                    <td class="text-center">
                                                        <c:choose>
                                                            <c:when test="${stype.active}">
                                                                <span
                                                                    class="bg-success-focus text-success-600 border border-success-main px-24 py-4 radius-4 fw-medium text-sm">Active
                                                                    </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span
                                                                    class="bg-neutral-200 text-neutral-600 border border-neutral-400 px-24 py-4 radius-4 fw-medium text-sm">Inactive
                                                                    </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-center">
                                                        <div
                                                            class="d-flex align-items-center gap-10 justify-content-center">

                                                            <!-- Edit button -->
                                                            <a href="servicetype?service=pre-update&id=${stype.serviceTypeId}"
                                                                class="bg-success-focus text-success-600 bg-hover-success-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle"
                                                                data-bs-toggle="tooltip"
                                                                data-bs-title="Chỉnh sửa loại dịch vụ">
                                                                <iconify-icon icon="lucide:edit"
                                                                    class="menu-icon"></iconify-icon>
                                                            </a>

                                                            <!-- Deactivate button -->
                                                            <a href="servicetype?service=deactiveById&id=${stype.serviceTypeId}"
                                                                class="bg-danger-focus bg-hover-danger-200 text-danger-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle"
                                                                data-bs-toggle="tooltip"
                                                                data-bs-title="Vô hiệu hóa loại dịch vụ"
                                                                onclick="return confirmAction('Bạn có chắc chắn muốn vô hiệu hóa loại dịch vụ này?')">
                                                                <iconify-icon icon="mdi:block-helper"
                                                                    class="menu-icon"></iconify-icon>
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
                                                       href="servicetype?service=${param.service != null && param.service != '' ? param.service : 'list-all'}&page=${currentPage - 1}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}">
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
                                                           href="servicetype?service=${param.service != null && param.service != '' ? param.service : 'list-all'}&page=${i}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}">
                                                            ${i}
                                                        </a>
                                                    </li>
                                                </c:when>
                                                
                                                <%-- Hiển thị trang cuối cùng --%>
                                                <c:when test="${i == totalPages}">
                                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                        <a class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px
                                                            ${i == currentPage ? 'bg-primary-600 text-white' : 'bg-neutral-200 text-secondary-light'}"
                                                           href="servicetype?service=${param.service != null && param.service != '' ? param.service : 'list-all'}&page=${i}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}">
                                                            ${i}
                                                        </a>
                                                    </li>
                                                </c:when>
                                                
                                                <%-- Hiển thị các trang xung quanh trang hiện tại --%>
                                                <c:when test="${i >= currentPage - 2 && i <= currentPage + 2}">
                                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                        <a class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px
                                                            ${i == currentPage ? 'bg-primary-600 text-white' : 'bg-neutral-200 text-secondary-light'}"
                                                           href="servicetype?service=${param.service != null && param.service != '' ? param.service : 'list-all'}&page=${i}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}">
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
                                                       href="servicetype?service=${param.service != null && param.service != '' ? param.service : 'list-all'}&page=${currentPage + 1}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}">
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

                <!-- JS here -->
                <jsp:include page="/WEB-INF/view/common/admin/js.jsp"></jsp:include>

                <c:if test="${not empty toastMessage}">
                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            const toast = document.createElement("div");
                            toast.textContent = "${toastMessage}";
                            toast.className = "toast-message ${toastType eq 'success' ? 'toast-success' : 'toast-error'}";

                            document.body.appendChild(toast);

                            setTimeout(() => {
                                toast.classList.add("show");
                            }, 100); // Show after small delay

                            setTimeout(() => {
                                toast.classList.remove("show");
                                setTimeout(() => toast.remove(), 300); // remove after transition
                            }, 4000); // auto hide after 4s
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





                <!-- Thêm script cho tooltip và xác nhận -->
                <script>
                    // Khởi tạo tooltips
                    document.addEventListener('DOMContentLoaded', function () {
                        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                            return new bootstrap.Tooltip(tooltipTriggerEl, {
                                trigger: 'hover'
                            });
                        });
                    });

                    // Hàm xác nhận thao tác
                    function confirmAction(message) {
                        return confirm(message);
                    }

                    function changeLimit(newLimit) {
                        let currentUrl = new URL(window.location.href);
                        let searchParams = currentUrl.searchParams;
                        
                        // Giữ lại các tham số tìm kiếm nếu có
                        if (searchParams.has('keyword')) {
                            searchParams.set('service', 'searchByKeywordAndStatus');
                        } else {
                            searchParams.set('service', 'list-all');
                        }
                        
                        searchParams.set('limit', newLimit);
                        searchParams.set('page', '1'); // Reset về trang 1
                        
                        window.location.href = currentUrl.pathname + '?' + searchParams.toString();
                    }
                </script>

                <!-- Thêm style cho tooltip -->
                <style>
                    .tooltip {
                        font-size: 0.875rem;
                    }

                    .tooltip-inner {
                        max-width: 200px;
                        padding: 0.5rem 1rem;
                        background-color: #333;
                        border-radius: 4px;
                    }
                </style>


            </body>

            </html>