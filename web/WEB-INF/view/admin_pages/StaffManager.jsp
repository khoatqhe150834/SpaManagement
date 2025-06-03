<%-- 
    Document   : staff
    Created on : May 30, 2025, 5:03:57 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- meta tags and other links -->
<!DOCTYPE html>
<html lang="en" data-theme="light">

    <!-- Mirrored from wowdash.wowtheme7.com/demo/users-list.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 03 Feb 2025 04:44:16 GMT -->
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Wowdash - Bootstrap 5 Admin Dashboard HTML Template</title>
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
                    <h6 class="fw-semibold mb-0">Users Grid</h6>
                    <ul class="d-flex align-items-center gap-2">
                        <li class="fw-medium">
                            <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                                <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                                Dashboard
                            </a>
                        </li>
                        <li>-</li>
                        <li class="fw-medium">Users Grid</li>
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
                            <form class="navbar-search">
                                <input type="text" class="bg-base h-40-px w-auto" name="search" placeholder="Search">
                                <iconify-icon icon="ion:search-outline" class="icon"></iconify-icon>
                            </form>
                            <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px">
                                <option>Status</option>
                                <option>Active</option>
                                <option>Inactive</option>
                            </select>
                        </div>
                        <a href="add-user.html" class="btn btn-primary text-sm btn-sm px-12 py-12 radius-8 d-flex align-items-center gap-2"> 
                            <iconify-icon icon="ic:baseline-plus" class="icon text-xl line-height-1"></iconify-icon>
                            Add New User
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
                                        <th scope="col">Join Date</th> 
                                        <th scope="col">Name</th>      
                                        <th scope="col">Service Type</th> 
                                        <th scope="col">Bio</th>       
                                        <th scope="col" class="text-center">Status</th>  
                                        <th scope="col">Experience (Years)</th> 
                                        <th scope="col" class="text-center">Action</th>
                                    </tr>
                                </thead>

                                <tbody>
                                <c:forEach var="therapist" items="${therapists}">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center gap-10">
                                            <div class="form-check style-check d-flex align-items-center">
                                                <input class="form-check-input radius-4 border input-form-dark" type="checkbox" name="checkbox" value="${therapist.user_id}">
                                            </div>
                                            ${therapist.user_id}
                                        </div>
                                    </td>
                                    <td>
                                <fmt:formatDate value="${therapist.created_at}" pattern="dd MMM yyyy"/>
                                </td>
                                <td>
                                    <!-- Giả sử bạn đã có tên kỹ thuật viên trong therapist.fullName -->
                                    ${therapist.fullName}
                                </td>
                                <td>
                                <c:forEach var="stype" items="${serviceTypes}">
                                    <c:if test="${stype.serviceTypeId == therapist.service_type_id}">
                                        ${stype.name}
                                    </c:if>
                                </c:forEach>
                                </td>
                                <td>${therapist.bio}</td>
                                <td class="text-center">
                                <c:choose>
                                    <c:when test="${therapist.availability_status == 'AVAILABLE'}">
                                        <span class="bg-success-focus text-success-600 border border-success-main px-24 py-4 radius-4 fw-medium text-sm">Available</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="bg-neutral-200 text-neutral-600 border border-neutral-400 px-24 py-4 radius-4 fw-medium text-sm">
                                            ${therapist.availability_status}
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                                </td>
                                <td>${therapist.years_of_experience}</td>
                                <td class="text-center">
                                    <div class="d-flex align-items-center gap-10 justify-content-center">
                                        <!-- View button -->
                                        <button type="button" class="bg-info-focus bg-hover-info-200 text-info-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="View">
                                            <iconify-icon icon="majesticons:eye-line" class="icon text-xl"></iconify-icon>
                                        </button>

                                        <!-- Edit button -->
                                        <a href="therapist?service=pre-update&id=${therapist.user_id}" class="bg-success-focus text-success-600 bg-hover-success-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Edit">
                                            <iconify-icon icon="lucide:edit" class="menu-icon"></iconify-icon>
                                        </a>

                                        <!-- Delete button -->
                                        <a href="therapist?service=delete&id=${therapist.user_id}" class="remove-item-btn bg-danger-focus bg-hover-danger-200 text-danger-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Delete" onclick="return confirm('Delete this Therapist?');">
                                            <iconify-icon icon="fluent:delete-24-regular" class="menu-icon"></iconify-icon>
                                        </a>
                                    </div>
                                </td>
                                </tr>
                            </c:forEach>
                            </tbody>

                        </table>
                    </div>

                    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mt-24">
                        <span>Showing 1 to 10 of 12 entries</span>
                        <ul class="pagination d-flex flex-wrap align-items-center gap-2 justify-content-center">
                            <li class="page-item">
                                <a class="page-link bg-neutral-200 text-secondary-light fw-semibold radius-8 border-0 d-flex align-items-center justify-content-center h-32-px w-32-px text-md" href="javascript:void(0)"><iconify-icon icon="ep:d-arrow-left" class=""></iconify-icon></a>
                            </li>
                            <li class="page-item">
                                <a class="page-link text-secondary-light fw-semibold radius-8 border-0 d-flex align-items-center justify-content-center h-32-px w-32-px text-md bg-primary-600 text-white" href="javascript:void(0)">1</a>
                            </li>
                            <li class="page-item">
                                <a class="page-link bg-neutral-200 text-secondary-light fw-semibold radius-8 border-0 d-flex align-items-center justify-content-center h-32-px w-32-px" href="javascript:void(0)">2</a>
                            </li>
                            <li class="page-item">
                                <a class="page-link bg-neutral-200 text-secondary-light fw-semibold radius-8 border-0 d-flex align-items-center justify-content-center h-32-px w-32-px text-md" href="javascript:void(0)">3</a>
                            </li>
                            <li class="page-item">
                                <a class="page-link bg-neutral-200 text-secondary-light fw-semibold radius-8 border-0 d-flex align-items-center justify-content-center h-32-px w-32-px text-md" href="javascript:void(0)">4</a>
                            </li>
                            <li class="page-item">
                                <a class="page-link bg-neutral-200 text-secondary-light fw-semibold radius-8 border-0 d-flex align-items-center justify-content-center h-32-px w-32-px text-md" href="javascript:void(0)">5</a>
                            </li>
                            <li class="page-item">
                                <a class="page-link bg-neutral-200 text-secondary-light fw-semibold radius-8 border-0 d-flex align-items-center justify-content-center h-32-px w-32-px text-md" href="javascript:void(0)"> <iconify-icon icon="ep:d-arrow-right" class=""></iconify-icon> </a>
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

