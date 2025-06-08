<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    </head>
    <body>
        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Service List</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Dashboard
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Service List</li>
                </ul>
            </div>

            <div class="card h-100 p-0 radius-12">
                <div class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center flex-wrap gap-3 justify-content-between">
                    <div class="d-flex align-items-center flex-wrap gap-3">
                        <form class="navbar-search d-flex gap-2 align-items-center" method="get" action="service">
                            <input type="hidden" name="service" value="searchByKeyword">
                            <input type="text" class="bg-base h-40-px w-auto" name="keyword" placeholder="Search" value="${keyword}" />
                            <button type="submit" class="btn btn-primary h-40-px radius-12">Search</button>
                        </form>
                    </div>
                    <a href="service?service=pre-insert" class="btn btn-primary text-sm btn-sm px-12 py-12 radius-8 d-flex align-items-center gap-2"> 
                        <iconify-icon icon="ic:baseline-plus" class="icon text-xl line-height-1"></iconify-icon>
                        Add New Service
                    </a>
                </div>

                <c:if test="${not empty services}">
                    <div class="card-body p-24">
                        <div class="table-responsive scroll-sm">
                            <table class="table bordered-table sm-table mb-0">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Type</th>
                                        <th>Price</th>
                                        <th>Duration</th>
                                        <th>Status</th>
                                        <th>Created At</th>
                                        <th>Updated At</th>
                                        <th class="text-center">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="service" items="${services}">
                                        <tr>
                                            <td>${service.serviceId}</td>
                                            <td>${service.name}</td>
                                            <td>${service.serviceTypeId.name}</td>
                                            <td><fmt:formatNumber value="${service.price}" type="currency" /></td>
                                            <td>${service.durationMinutes} min</td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${service.isActive}">
                                                        <span class="bg-success-focus text-success-600 border border-success-main px-24 py-4 radius-4 fw-medium text-sm">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="bg-neutral-200 text-neutral-600 border border-neutral-400 px-24 py-4 radius-4 fw-medium text-sm">Inactive</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><fmt:formatDate value="${service.createdAt}" pattern="dd MMM yyyy" /></td>
                                            <td><fmt:formatDate value="${service.updatedAt}" pattern="dd MMM yyyy" /></td>
                                            <td class="text-center">
                                                <div class="d-flex align-items-center gap-10 justify-content-center">
                                                    <a href="service?service=pre-update&id=${service.serviceId}" class="bg-success-focus text-success-600 bg-hover-success-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle">
                                                        <iconify-icon icon="lucide:edit"></iconify-icon>
                                                    </a>
                                                    <a href="service?service=deactivate&id=${service.serviceId}" class="bg-danger-focus text-danger-600 bg-hover-danger-200 w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" onclick="return confirmDelete(${service.serviceId})">
                                                        <iconify-icon icon="mdi:block-helper"></iconify-icon>
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
                            <span>
                                Showing ${start} to ${end} of ${totalEntries} entries
                            </span>

                            <ul class="pagination d-flex flex-wrap align-items-center gap-2 justify-content-center">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="service?service=list-all&page=${currentPage - 1}&limit=${limit}">
                                        <iconify-icon icon="ep:d-arrow-left"></iconify-icon>
                                    </a>
                                </li>
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="service?service=list-all&page=${i}&limit=${limit}">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="service?service=list-all&page=${currentPage + 1}&limit=${limit}">
                                        <iconify-icon icon="ep:d-arrow-right"></iconify-icon>
                                    </a>
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
                return confirm("Are you sure you want to deactivate this Service (ID = " + id + ")?");
            }
        </script>
    </body>
</html>
