<%-- 
    Document   : customer_list
    Created on : Jun 4, 2025
    Author     : Admin
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer List - Wowdash</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png" sizes="16x16">
    <!-- CSS -->
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp"></jsp:include>
</head>
<body>
    <!-- SIDEBAR -->
    <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp"></jsp:include>

    <!-- HEADER -->
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp"></jsp:include>

    <div class="dashboard-main-body">
        <!-- Breadcrumb -->
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Customer List</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Customer List</li>
            </ul>
        </div>

        <div class="card h-100 p-0 radius-12">
            <div class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center flex-wrap gap-3 justify-content-between">
                <div class="d-flex align-items-center flex-wrap gap-3">
                    <!-- Page Size -->
                    <span class="text-md fw-medium text-secondary-light mb-0">Show</span>
                    <form action="${pageContext.request.contextPath}/customer" method="get" class="d-inline">
                        <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="pageSize" onchange="this.form.submit()">
                            <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                            <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                        </select>
                        <input type="hidden" name="page" value="1">
                        <c:if test="${not empty searchType}">
                            <input type="hidden" name="searchType" value="${searchType}"/>
                            <input type="hidden" name="searchValue" value="${searchValue}"/>
                        </c:if>
                    </form>

                    <!-- Search Form -->
                    <form class="navbar-search" action="${pageContext.request.contextPath}/customer/search" method="get">
                        <input type="text" class="bg-base h-40-px w-auto" name="searchValue" value="${searchValue}" placeholder="Search by Name, Email, or Phone">
                        <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="searchType">
                            <option value="name" ${searchType == 'name' ? 'selected' : ''}>Name</option>
                            <option value="email" ${searchType == 'email' ? 'selected' : ''}>Email</option>
                            <option value="phone" ${searchType == 'phone' ? 'selected' : ''}>Phone</option>
                        </select>
                        <input type="hidden" name="page" value="1">
                        <input type="hidden" name="pageSize" value="${pageSize}">
                        <button type="submit" class="border-0 bg-transparent p-0">
                            <iconify-icon icon="ion:search-outline" class="icon"></iconify-icon>
                        </button>
                    </form>

                    <!-- Status Filter (Optional) -->
                    <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px">
                        <option>Status</option>
                        <option>Active</option>
                        <option>Inactive</option>
                    </select>
                </div>

                <!-- Add New Customer -->
                <a href="${pageContext.request.contextPath}/customer/create" class="btn btn-primary btn-primary-light text-sm btn-sm px-3 py-2 radius-8 d-flex align-items-center gap-2">
                    <iconify-icon icon="ic:baseline-plus" class="icon text-xl"></iconify-icon>
                    Add New Customer
                </a>
            </div>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger mx-24 mt-16">
                    ${error}
                </div>
            </c:if>

            <!-- Customer Table -->
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
                                <th scope="col">Email</th>
                                <th scope="col">Phone</th>
                                <th scope="col">Gender</th>
                                <th scope="col">Birthday</th>
                                <th scope="col">Address</th>
                                <th scope="col" class="text-center">Status</th>
                                <th scope="col" class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="customer" items="${listCustomer}" varStatus="loop">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center gap-10">
                                            <div class="form-check style-check d-flex align-items-center">
                                                <input class="form-check-input radius-4 border border-neutral-400" type="checkbox" name="checkbox">
                                            </div>
                                            ${customer.customerId}
                                        </div>
                                    </td>
                                    <td><fmt:formatDate value="${customer.createdAt}" pattern="dd MMM yyyy"/></td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="${pageContext.request.contextPath}/assets/images/user-list/user-list${loop.index % 10 + 1}.png" alt="" class="w-40-px h-40-px rounded-circle flex-shrink-0 me-12 overflow-hidden">
                                            <div class="flex-grow-1">
                                                <span class="text-md mb-0 fw-normal text-secondary-light"><c:out value="${customer.fullName}"/></span>
                                            </div>
                                        </div>
                                    </td>
                                    <td><span class="text-md mb-0 fw-normal text-secondary-light"><c:out value="${customer.email}"/></span></td>
                                    <td><c:out value="${customer.phoneNumber}"/></td>
                                    <td><c:out value="${customer.gender}"/></td>
                                    <td><fmt:formatDate value="${customer.birthday}" pattern="dd MMM yyyy" default="-"/></td>
                                    <td><c:out value="${customer.address}"/></td>
                                    <td class="text-center">
                                        <span class="bg-${customer.isActive ? 'success-focus text-success-600 border border-success-main' : 'neutral-200 text-neutral-600 border border-neutral-400'} px-24 py-4 radius-4 fw-medium text-sm">
                                            ${customer.isActive ? 'Active' : 'Inactive'}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex align-items-center gap-10 justify-content-center">
                                            <button type="button" class="bg-info-focus bg-hover-info-200 text-info-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle">
                                                <iconify-icon icon="majesticons:eye-line" class="icon text-xl"></iconify-icon>
                                            </button>
                                            <a href="${pageContext.request.contextPath}/customer/edit?id=${customer.customerId}" class="bg-success-focus text-success-600 bg-hover-success-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle">
                                                <iconify-icon icon="lucide:edit" class="menu-icon"></iconify-icon>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/customer/delete?id=${customer.customerId}" class="remove-item-btn bg-danger-focus bg-hover-danger-200 text-danger-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle">
                                                <iconify-icon icon="fluent:delete-24-regular" class="menu-icon"></iconify-icon>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listCustomer}">
                                <tr>
                                    <td colspan="10" class="text-center">No customers found</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mt-24">
                    <span>Showing ${(currentPage - 1) * pageSize + 1} to ${Math.min(currentPage * pageSize, totalCustomers)} of ${totalCustomers} entries</span>
                    <ul class="pagination d-flex flex-wrap align-items-center gap-2 justify-content-center">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link bg-neutral-200 text-secondary-light fw-semibold radius-8 border-0 d-flex align-items-center justify-content-center h-32-px w-32-px text-md" href="${pageContext.request.contextPath}/customer?page=${currentPage - 1}&pageSize=${pageSize}${not empty searchType ? '&searchType=' += searchType += '&searchValue=' += searchValue : ''}">
                                <iconify-icon icon="ep:d-arrow-left"></iconify-icon>
                            </a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link text-secondary-light fw-semibold radius-8 border-0 d-flex align-items-center justify-content-center h-32-px w-32-px text-md ${i == currentPage ? 'bg-primary-600 text-white' : 'bg-neutral-200'}" href="${pageContext.request.contextPath}/customer?page=${i}&pageSize=${pageSize}${not empty searchType ? '&searchType=' += searchType += '&searchValue=' += searchValue : ''}">
                                    ${i}
                                </a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link bg-neutral-200 text-secondary-light fw-semibold radius-8 border-0 d-flex align-items-center justify-content-center h-32-px w-32-px text-md" href="${pageContext.request.contextPath}/customer?page=${currentPage + 1}&pageSize=${pageSize}${not empty searchType ? '&searchType=' += searchType += '&searchValue=' += searchValue : ''}">
                                <iconify-icon icon="ep:d-arrow-right"></iconify-icon>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <!-- JS -->
    <jsp:include page="/WEB-INF/view/common/admin/js.jsp"></jsp:include>

    <script>
        $(document).ready(function() {
            // Xử lý checkbox "select all"
            $('#selectAll').on('change', function() {
                $('input[name="checkbox"]').prop('checked', $(this).prop('checked'));
            });

            // Xử lý nút xóa
            $('.remove-item-btn').on('click', function(e) {
                e.preventDefault();
                if (confirm('Are you sure you want to delete this customer?')) {
                    window.location.href = $(this).attr('href');
                }
            });

            // Xử lý nút View (tùy chọn, hiện tại chưa có action trong controller)
            $('.bg-info-focus').on('click', function() {
                alert('View functionality is not implemented yet.');
            });
        });
    </script>
</body>
</html>