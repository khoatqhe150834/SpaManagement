<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!-- meta tags and other links -->
<!DOCTYPE html>
<html lang="en" data-theme="light">

    <!-- Mirrored from wowdash.wowtheme7.com/demo/users-list.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 03 Feb 2025 04:44:16 GMT -->
    <head>
        <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Service Types - Admin Dashboard</title>
        <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
        <!-- CSS here -->
        <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp"></jsp:include>
        </head>
        <body>
            <!-- SIDEBAR here -->
        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp"></jsp:include>

            <!-- HEADER here -->
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp"></jsp:include>


            <style>
                .limit-description {
                    display: -webkit-box;
                    -webkit-box-orient: vertical;
                    -webkit-line-clamp: 4;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    max-height: 6.4em; /* 4 dÃ²ng x 1.6em */
                    min-width: 0;
                    width: 100%;
                    line-height: 1.6em;
                    word-break: break-word;
                    white-space: normal;
                }
            </style>
            <div class="dashboard-main-body">
                <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                    <h6 class="fw-semibold mb-0">Service Type List</h6>
                    <ul class="d-flex align-items-center gap-2">
                        <li class="fw-medium">
                            <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                                <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                                Dashboard
                            </a>
                        </li>
                        <li>-</li>
                        <li class="fw-medium">Service Type List</li>
                    </ul>
                </div>

                <div class="card h-100 p-0 radius-12">
                    <div class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center flex-wrap gap-3 justify-content-between">
                        <div class="d-flex align-items-center flex-wrap gap-3">
                            <form class="navbar-search d-flex gap-2 align-items-center" method="get" action="servicetype">
                                <input type="hidden" name="service" value="searchByKeywordAndStatus">
                                <input type="text" class="bg-base h-40-px w-auto" name="keyword" placeholder="Search" value="${keyword}">

                            <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="status">
                                <option value="">Status</option>
                                <option value="active" ${status == 'active' ? 'selected' : ''}>Active</option>
                                <option value="inactive" ${status == 'inactive' ? 'selected' : ''}>Inactive</option>
                            </select>

                            <button type="submit" class="btn btn-primary h-40-px radius-12">Search</button>
                        </form>
                    </div>
                    <a href="servicetype?service=pre-insert" class="btn btn-primary text-sm btn-sm px-12 py-12 radius-8 d-flex align-items-center gap-2"> 
                        <iconify-icon icon="ic:baseline-plus" class="icon text-xl line-height-1"></iconify-icon>
                        Add New Service Type
                    </a>
                </div>



                <c:if test="${not empty serviceTypes}">
                    <div class="card-body p-24">
                        <div class="table-responsive scroll-sm">
                            <table class="table bordered-table sm-table mb-0" style="table-layout: fixed;">
                                <thead>
                                    <tr>
                                        <th scope="col" style="width: 8%;">
                                            <div class="form-check d-flex align-items-center gap-2">
                                                <input class="form-check-input" type="checkbox" id="selectAll">
                                                <label class="form-check-label mb-0" for="selectAll">ID</label>
                                            </div>
                                        </th>
                                        <th scope="col" style="width: 15%;">Name</th>
                                        <th scope="col" style="width: 37%;" class="d-none d-md-table-cell">Description</th>
                                        <th scope="col" style="width: 15%;" class="text-center">Image</th>
                                        <th scope="col" style="width: 10%;" class="text-center">Status</th>
                                        <th scope="col" style="width: 10%;" class="text-center">Action</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <c:forEach var="stype" items="${serviceTypes}" varStatus="loop">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-10">
                                                    <div class="form-check style-check d-flex align-items-center">
                                                        <input class="form-check-input radius-4 border border-neutral-400" type="checkbox">
                                                    </div>
                                                    ${stype.serviceTypeId}
                                                </div>
                                            </td>
                                            <td>${stype.name}</td>
                                            <td class="limit-description" title="${stype.description}">
                                                ${stype.description}
                                            </td>
                                            <td><img src="${stype.imageUrl}" alt="Image" class="w-40-px h-40-px rounded" /></td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${stype.active}">
                                                        <span class="bg-success-focus text-success-600 border border-success-main px-24 py-4 radius-4 fw-medium text-sm">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="bg-neutral-200 text-neutral-600 border border-neutral-400 px-24 py-4 radius-4 fw-medium text-sm">Inactive</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <div class="d-flex align-items-center gap-10 justify-content-center">

                                                    <!-- Edit button -->
                                                    <a href="servicetype?service=pre-update&id=${stype.serviceTypeId}" class="bg-success-focus text-success-600 bg-hover-success-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle">
                                                        <iconify-icon icon="lucide:edit" class="menu-icon"></iconify-icon>
                                                    </a>

                                                    <!-- Deactivate button (soft delete) -->
                                                    <a href="servicetype?service=deactiveById&id=${stype.serviceTypeId}" 
                                                       class=" bg-danger-focus bg-hover-danger-200 text-danger-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle"
                                                       onclick="return confirmDelete(${stype.serviceTypeId})">
                                                        <iconify-icon icon="mdi:block-helper" class="menu-icon"></iconify-icon>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>



                            </table>
                        </div>


                    </c:if>
                    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mt-24">
                        <c:set var="start" value="${(currentPage - 1) * limit + 1}" />
                        <c:set var="end" value="${currentPage * limit > totalEntries ? totalEntries : currentPage * limit}" />
                        <span>
                            Showing ${start} to ${end} of ${totalEntries} entries
                        </span>

                        <ul class="pagination d-flex flex-wrap align-items-center gap-2 justify-content-center">
                            <!-- Previous -->
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <c:choose>
                                    <c:when test="${currentPage == 1}">
                                        <a class="page-link disabled">
                                            <iconify-icon icon="ep:d-arrow-left"></iconify-icon>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="page-link" href="servicetype?service=list-all&page=${currentPage - 1}&limit=${limit}">
                                            <iconify-icon icon="ep:d-arrow-left"></iconify-icon>
                                        </a>

                                    </c:otherwise>
                                </c:choose>
                            </li>

                            <!-- Page numbers -->
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px
                                       ${i == currentPage ? 'bg-primary-600 text-white' : 'bg-neutral-200 text-secondary-light'}"
                                       href="servicetype?service=list-all&page=${i}&limit=${limit}">
                                        ${i}
                                    </a>
                                </li>
                            </c:forEach>

                            <!-- Next -->
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <c:choose>
                                    <c:when test="${currentPage == totalPages}">
                                        <a class="page-link disabled">
                                            <iconify-icon icon="ep:d-arrow-right"></iconify-icon>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="page-link" href="servicetype?service=list-all&page=${currentPage + 1}&limit=${limit}">
                                            <iconify-icon icon="ep:d-arrow-right"></iconify-icon>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </li>

                        </ul>

                    </div>

                </div>
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
                    box-shadow: 0 4px 12px rgba(0,0,0,0.2);
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
            function confirmDelete(id) {
                return confirm("Are you sure you want to deactive this Service Type (ID = " + id + ") ?");
            }
        </script>


    </body>

    <!-- Mirrored from wowdash.wowtheme7.com/demo/users-list.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 03 Feb 2025 04:44:16 GMT -->
</html>