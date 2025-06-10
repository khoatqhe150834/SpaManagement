<%-- 
    Document   : customer_list
    Created on : Jun 4, 2025
    Author     : Admin
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">

    <head>
        <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Customers - Admin Dashboard</title>
        <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
        <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
    </head>

    <body>
        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Customer List</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
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
                        <form class="navbar-search d-flex gap-2 align-items-center" method="get" action="${pageContext.request.contextPath}/customer">
                            <input type="hidden" name="action" value="list">
                            <input type="text" class="bg-base h-40-px w-auto" name="search" placeholder="Search by name, email, phone" value="${param.search}">

                            <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="status">
                                <option value="">All Status</option>
                                <option value="active" ${param.status == 'active' ? 'selected' : ''}>Active</option>
                                <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                            </select>

                            <button type="submit" class="btn btn-primary h-40-px radius-12">Search</button>
                        </form>
                    </div>
                    <a href="${pageContext.request.contextPath}/customer?action=pre-insert" class="btn btn-primary text-sm btn-sm px-12 py-12 radius-8 d-flex align-items-center gap-2"> 
                        <iconify-icon icon="ic:baseline-plus" class="icon text-xl line-height-1"></iconify-icon>
                        Add New Customer
                    </a>
                </div>

                <c:if test="${not empty customers}">
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
                                        <th scope="col">Full Name</th>
                                        <th scope="col">Email</th>
                                        <th scope="col">Phone</th>
                                        <th scope="col" class="text-center">Status</th>
                                        <th scope="col" class="text-center">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="customer" items="${customers}" varStatus="loop">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-10">
                                                    <div class="form-check style-check d-flex align-items-center">
                                                        <input class="form-check-input radius-4 border border-neutral-400" type="checkbox">
                                                    </div>
                                                    ${customer.customerId}
                                                </div>
                                            </td>
                                            <td>${customer.fullName}</td>
                                            <td>${customer.email}</td>
                                            <td>${customer.phoneNumber}</td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${customer.isActive}">
                                                        <span class="bg-success-focus text-success-600 border border-success-main px-24 py-4 radius-4 fw-medium text-sm">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="bg-neutral-200 text-neutral-600 border border-neutral-400 px-24 py-4 radius-4 fw-medium text-sm">Inactive</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <div class="d-flex align-items-center gap-10 justify-content-center">
                                                    <!-- View button -->
                                                    <a href="${pageContext.request.contextPath}/customer?action=view&id=${customer.customerId}" class="bg-info-focus text-info-600 bg-hover-info-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle">
                                                        <iconify-icon icon="majesticons:eye-line" class="menu-icon"></iconify-icon>
                                                    </a>

                                                    <!-- Edit button -->
                                                    <a href="${pageContext.request.contextPath}/customer?action=pre-update&id=${customer.customerId}" class="bg-success-focus text-success-600 bg-hover-success-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle">
                                                        <iconify-icon icon="lucide:edit" class="menu-icon"></iconify-icon>
                                                    </a>

                                                    <!-- Delete button -->
                                                    <a href="${pageContext.request.contextPath}/customer?action=delete&id=${customer.customerId}" 
                                                       class="bg-danger-focus bg-hover-danger-200 text-danger-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle"
                                                       onclick="return confirmDelete(${customer.customerId})">
                                                        <iconify-icon icon="mingcute:delete-2-line" class="menu-icon"></iconify-icon>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:if>

                <!-- Pagination Section -->
                <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mt-24">
                    <c:set var="start" value="${(currentPage - 1) * pageSize + 1}" />
                    <c:set var="end" value="${currentPage * pageSize > totalCustomers ? totalCustomers : currentPage * pageSize}" />
                    <span>
                        Showing ${start} to ${end} of ${totalCustomers} entries
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
                                    <a class="page-link" href="${pageContext.request.contextPath}/customer?action=list&page=${currentPage - 1}&pageSize=${pageSize}">
                                        <iconify-icon icon="ep:d-arrow-left"></iconify-icon>
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </li>

                        <!-- Page numbers -->
                        <c:forEach var="i" begin="1" end="${totalpages}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px
                                   ${i == currentPage ? 'bg-primary-600 text-white' : 'bg-neutral-200 text-secondary-light'}"
                                   href="${pageContext.request.contextPath}/customer?action=list&page=${i}&pageSize=${pageSize}">
                                    ${i}
                                </a>
                            </li>
                        </c:forEach>

                        <!-- Next -->
                        <li class="page-item ${currentPage == totalpages ? 'disabled' : ''}">
                            <c:choose>
                                <c:when test="${currentPage == totalpages}">
                                    <a class="page-link disabled">
                                        <iconify-icon icon="ep:d-arrow-right"></iconify-icon>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a class="page-link" href="${pageContext.request.contextPath}/customer?action=list&page=${currentPage + 1}&pageSize=${pageSize}">
                                        <iconify-icon icon="ep:d-arrow-right"></iconify-icon>
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </li>
                    </ul>
                </div>
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
                return confirm("Are you sure you want to delete customer with ID = " + id + " ?\n\nThis action cannot be undone.");
            }
        </script>
    </body>
</html>