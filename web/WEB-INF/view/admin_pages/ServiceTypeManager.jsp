<%-- 
    Document   : staff
    Created on : May 30, 2025, 5:03:57 PM
    Author     : Admin
--%>

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
                            <span class="text-md fw-medium text-secondary-light mb-0">Show</span>
                            <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px">
                                <option>1</option>
                                <option>2</option>
                                <option>3</option>
                                <option>4</option>
                                <option>5</option>
                                <option>6</option>
                                <option>7</option>
                                <option>8</option>
                                <option>9</option>
                                <option>10</option>
                            </select>
                            <form class="navbar-search" method="get" action="servicetype">
                                <input type="hidden" name="service" value="searchByKeyword">
                                <input type="text" class="bg-base h-40-px w-auto" name="keyword" placeholder="Search" value="${keyword}">
                            <iconify-icon icon="ion:search-outline" class="icon"></iconify-icon>
                        </form>

                        <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px">
                            <option>Status</option>
                            <option>Active</option>
                            <option>Inactive</option>
                        </select>
                    </div>
                    <a href="servicetype?service=pre-insert" class="btn btn-primary text-sm btn-sm px-12 py-12 radius-8 d-flex align-items-center gap-2"> 
                        <iconify-icon icon="ic:baseline-plus" class="icon text-xl line-height-1"></iconify-icon>
                        Add New Service Type
                    </a>
                </div>
                <div class="card-body p-24">
                    <div class="table-responsive scroll-sm">
                        <table class="table bordered-table sm-table mb-0">
                            <thead>
                                <tr>
                                    <th scope="col">
                                        <div class="d-flex align-items-center gap-10">
                                            <div class="form-check style-check d-flex align-items-center">
                                                <input class="form-check-input radius-4 border input-form-dark" type="checkbox" name="checkbox" id="selectAll">
                                            </div>
                                            ID
                                        </div>
                                    </th>
                                    <th scope="col">Name</th>
                                    <th scope="col">Description</th>
                                    <th scope="col">Image</th>
                                    <th scope="col" class="text-center">Status</th>
                                    <th scope="col">Created At</th>
                                    <th scope="col">Updated At</th>
                                    <th scope="col" class="text-center">Action</th>
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
                                        <td>${stype.description}</td>
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
                                        <td><fmt:formatDate value="${stype.createdAt}" pattern="dd MMM yyyy"/></td>
                                        <td><fmt:formatDate value="${stype.updatedAt}" pattern="dd MMM yyyy"/></td>
                                        <td class="text-center">
                                            <div class="d-flex align-items-center gap-10 justify-content-center">
                                                <!-- View button -->
                                                <a href="service?service=viewByServiceType&id=${stype.serviceTypeId}"
                                                   class="bg-info-focus bg-hover-info-200 text-info-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle">
                                                    <iconify-icon icon="majesticons:eye-line" class="icon text-xl"></iconify-icon>
                                                </a>
                                                <!-- Edit button -->
                                                <a href="servicetype?service=pre-update&id=${stype.serviceTypeId}" class="bg-success-focus text-success-600 bg-hover-success-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle">
                                                    <iconify-icon icon="lucide:edit" class="menu-icon"></iconify-icon>
                                                </a>

                                                <!-- Deactivate button (soft delete) -->
                                                <a href="servicetype?service=deactiveById&id=${stype.serviceTypeId}" 
                                                   class="remove-item-btn bg-danger-focus bg-hover-danger-200 text-danger-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle"
                                                   onclick="return confirm('Do you want to deactivate this Service Type?');">
                                                    <iconify-icon icon="mdi:block-helper" class="menu-icon"></iconify-icon>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>



                        </table>
                    </div>

                    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mt-24">
                        <span>
                            Showing ${(currentPage - 1) * 5 + 1}
                            to ${currentPage * 5 > totalEntries ? totalEntries : currentPage * 5}
                            of ${totalEntries} entries
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
                                        <a class="page-link" href="servicetype?service=list-all&page=${currentPage - 1}">
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
                                       href="servicetype?service=list-all&page=${i}">
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
                                        <a class="page-link" href="servicetype?service=list-all&page=${currentPage + 1}">
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

    </body>

    <!-- Mirrored from wowdash.wowtheme7.com/demo/users-list.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 03 Feb 2025 04:44:16 GMT -->
</html>