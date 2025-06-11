<%-- 
    Document   : promotion_list
    Created on : Jun 11, 2025
    Author     : Admin
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Promotion List - Wowdash</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp"></jsp:include>
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
        .table-responsive {
            overflow-x: auto;
        }
        .form-select-sm {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp"></jsp:include>

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Promotion List</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Promotion List</li>
            </ul>
        </div>

        <div class="card h-100 p-0 radius-12">
            <div class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center flex-wrap gap-3 justify-content-between">
                <div class="d-flex align-items-center flex-wrap gap-3">
                    <form class="navbar-search d-flex gap-2 align-items-center" method="get" action="${pageContext.request.contextPath}/promotion/search">
                        <input type="text" class="bg-base h-40-px w-auto" name="searchValue" placeholder="Search by title, code, or description" value="${searchValue}">
                        
                        <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="status">
                            <option value="">All statuses</option>
                            <option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                            <option value="INACTIVE" ${status == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                            <option value="SCHEDULED" ${status == 'SCHEDULED' ? 'selected' : ''}>Scheduled</option>
                           
                        </select>
                        <button type="submit" class="btn btn-primary h-40-px radius-12">Search</button>
                        <input type="hidden" name="page" value="1">
                        <input type="hidden" name="pageSize" value="${pageSize}">
                    </form>
                </div>
                <a href="${pageContext.request.contextPath}/promotion/create" class="btn btn-primary text-sm btn-sm px-12 py-12 radius-8 d-flex align-items-center gap-2">
                    <iconify-icon icon="ic:baseline-plus" class="icon text-xl line-height-1"></iconify-icon>
                    Add Promotion
                </a>
            </div>

            <c:if test="${not empty toastMessage}">
                <div class="alert alert-${toastType eq 'success' ? 'success' : 'danger'} mx-24 mt-16">
                    <c:out value="${toastMessage}"/>
                </div>
            </c:if>

            <c:if test="${not empty listPromotion}">
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
                                    <th scope="col">Title</th>
                                    <th scope="col">Code</th>
                                    <th scope="col">Value</th>
                                    <th scope="col" class="text-center">Status</th>
                                    <th scope="col" class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="promotion" items="${listPromotion}">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center gap-10">
                                                <div class="form-check style-check d-flex align-items-center">
                                                    <input class="form-check-input radius-4 border border-neutral-400" type="checkbox">
                                                </div>
                                                ${promotion.promotionId}
                                            </div>
                                        </td>
                                        <td>${promotion.title}</td>
                                        <td><code class="bg-light px-2 py-1 rounded">${promotion.promotionCode}</code></td>
                                        <td>
                                            ${promotion.discountValue}
                                            <c:if test="${promotion.discountType == 'PERCENTAGE'}">%</c:if>
                                            <c:if test="${promotion.discountType == 'FIXED'}">VND</c:if>
                                        <td class="text-center">
    <c:choose>
        <c:when test="${promotion.status == 'ACTIVE'}">
            <span class="bg-success-focus text-success-600 border border-success-main px-24 py-4 radius-4 fw-medium text-sm">Active</span>
        </c:when>
        <c:when test="${promotion.status == 'SCHEDULED'}">
            <span class="bg-warning-focus text-warning-600 border border-warning-main px-24 py-4 radius-4 fw-medium text-sm">Scheduled</span>
        </c:when>
        <c:otherwise>
            <span class="bg-neutral-200 text-neutral-600 border border-neutral-400 px-24 py-4 radius-4 fw-medium text-sm">Inactive</span>
        </c:otherwise>
    </c:choose>
</td>


                                        <td class="text-center">
                                            <div class="d-flex align-items-center gap-10 justify-content-center">
                                                <a href="${pageContext.request.contextPath}/promotion/view?id=${promotion.promotionId}" class="bg-info-focus text-info-600 bg-hover-info-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle">
                                                    <iconify-icon icon="majesticons:eye-line" class="menu-icon"></iconify-icon>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/promotion/edit?id=${promotion.promotionId}" class="bg-success-focus text-success-600 bg-hover-success-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle">
                                                    <iconify-icon icon="lucide:edit" class="menu-icon"></iconify-icon>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/promotion/delete?id=${promotion.promotionId}" class="bg-danger-focus bg-hover-danger-200 text-danger-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" onclick="return confirmDelete(${promotion.promotionId}, '${promotion.title}')">
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

            <c:if test="${empty listPromotion}">
                <div class="card-body p-24 text-center">
                    <div>
                        <iconify-icon icon="solar:gift-outline" class="icon text-4xl"></iconify-icon>
                        <h6 class="mt-3">No promotions found</h6>
                        <p class="text-muted">Try adjusting the filters or add a new promotion</p>
                    </div>
                </div>
            </c:if>

            <c:if test="${totalPages > 1}">
                <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mt-24">
                    <span>Showing ${(currentPage - 1) * pageSize + 1} to ${fn:length(listPromotion) + (currentPage - 1) * pageSize} of ${totalPromotions} entries</span>
                    <ul class="pagination d-flex flex-wrap align-items-center gap-2 justify-content-center">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <c:choose>
                                <c:when test="${currentPage == 1}">
                                    <a class="page-link disabled">
                                        <iconify-icon icon="ep:d-arrow-left"></iconify-icon>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a class="page-link" href="${pageContext.request.contextPath}/promotion?page=${currentPage - 1}&pageSize=${pageSize}&searchType=${searchType}&searchValue=${searchValue}&status=${status}&sortBy=${sortBy}&sortOrder=${sortOrder}">
                                        <iconify-icon icon="ep:d-arrow-left"></iconify-icon>
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </li>
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px ${i == currentPage ? 'bg-primary-600 text-white' : 'bg-neutral-200 text-secondary-light'}" href="${pageContext.request.contextPath}/promotion?page=${i}&pageSize=${pageSize}&searchType=${searchType}&searchValue=${searchValue}&status=${status}&sortBy=${sortBy}&sortOrder=${sortOrder}">
                                    ${i}
                                </a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <c:choose>
                                <c:when test="${currentPage == totalPages}">
                                    <a class="page-link disabled">
                                        <iconify-icon icon="ep:d-arrow-right"></iconify-icon>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a class="page-link" href="${pageContext.request.contextPath}/promotion?page=${currentPage + 1}&pageSize=${pageSize}&searchType=${searchType}&searchValue=${searchValue}&status=${status}&sortBy=${sortBy}&sortOrder=${sortOrder}">
                                        <iconify-icon icon="ep:d-arrow-right"></iconify-icon>
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </li>
                    </ul>
                </div>
            </c:if>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp"></jsp:include>
    <script>
        function confirmDelete(id, title) {
            return confirm("Are you sure you want to delete the promotion with ID = " + id + " (" + title + ")?\n\nThis action cannot be undone.");
        }

        document.addEventListener("DOMContentLoaded", function () {
            const selectAll = document.getElementById("selectAll");
            const checkboxes = document.querySelectorAll(".form-check-input:not(#selectAll)");
            
            selectAll.addEventListener("change", function () {
                checkboxes.forEach(checkbox => {
                    checkbox.checked = selectAll.checked;
                });
            });

            // Display toast message if present
            <c:if test="${not empty toastMessage}">
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
            </c:if>
        });
    </script>
</body>
</html>