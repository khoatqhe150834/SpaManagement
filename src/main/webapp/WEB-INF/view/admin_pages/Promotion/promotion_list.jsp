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
    <title>Promotions - Admin Dashboard</title>
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
        .pagination .page-item a {
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .pagination .page-item.active a {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }
        .pagination .page-item.disabled a {
            color: #6c757d;
            pointer-events: none;
            background-color: #fff;
            border-color: #dee2e6;
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
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Promotion List</li>
            </ul>
            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-primary ms-auto">
                <iconify-icon icon="mdi:arrow-left" class="me-1"></iconify-icon> Quay về trang chủ
            </a>
        </div>

        <%-- Hiển thị thông báo thành công --%>
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success mb-24" role="alert">
                ${sessionScope.successMessage}
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>

        <%-- Hiển thị thông báo lỗi --%>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger mb-24" role="alert">
                ${sessionScope.errorMessage}
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <div class="card h-100 p-0 radius-12">
            <div class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center flex-wrap gap-3 justify-content-between">
                <div class="d-flex align-items-center flex-wrap gap-3">
                    <form class="navbar-search d-flex gap-2 align-items-center" method="get" action="${pageContext.request.contextPath}/promotion/list">
                        <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="pageSize" onchange="this.form.submit()">
                            <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                            <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                            <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                            <option value="9999" ${pageSize == 9999 ? 'selected' : ''}>All</option>
                        </select>
                        <input type="text" class="bg-base h-40-px w-auto" name="searchValue" placeholder="Search by title, code..." value="${searchValue}">
                        <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="status">
                            <option value="">All Status</option>
                            <option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                            <option value="INACTIVE" ${status == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                            <option value="SCHEDULED" ${status == 'SCHEDULED' ? 'selected' : ''}>Scheduled</option>
                        </select>
                        <button type="submit" class="btn btn-primary h-40-px radius-12">Search</button>
                        <input type="hidden" name="page" value="1">
                    </form>
                </div>
                <a href="${pageContext.request.contextPath}/promotion/create" class="btn btn-primary text-sm btn-sm px-12 py-12 radius-8 d-flex align-items-center gap-2">
                    <iconify-icon icon="ic:baseline-plus" class="icon text-xl line-height-1"></iconify-icon>
                    Add New Promotion
                </a>
            </div>

            <c:if test="${not empty listPromotion}">
                <div class="card-body p-24">
                    <div class="table-responsive scroll-sm">
                        <table class="table bordered-table sm-table mb-0">
                            <thead>
                                <tr>
                                    <th scope="col">
                                        ID
                                        <a href="?sortBy=id&sortOrder=asc<c:if test='${not empty searchValue}'>&searchValue=${searchValue}</c:if><c:if test='${not empty status}'>&status=${status}</c:if>&page=${currentPage}" title="Sort Ascending">&#9650;</a>
                                        <a href="?sortBy=id&sortOrder=desc<c:if test='${not empty searchValue}'>&searchValue=${searchValue}</c:if><c:if test='${not empty status}'>&status=${status}</c:if>&page=${currentPage}" title="Sort Descending">&#9660;</a>
                                    </th>
                                    <th scope="col">
                                        Title
                                        <a href="?sortBy=name&sortOrder=asc<c:if test='${not empty searchValue}'>&searchValue=${searchValue}</c:if><c:if test='${not empty status}'>&status=${status}</c:if>&page=${currentPage}" title="Sort Name Ascending">&#9650;</a>
                                        <a href="?sortBy=name&sortOrder=desc<c:if test='${not empty searchValue}'>&searchValue=${searchValue}</c:if><c:if test='${not empty status}'>&status=${status}</c:if>&page=${currentPage}" title="Sort Name Descending">&#9660;</a>
                                    </th>
                                    <th scope="col">Code</th>
                                    <th scope="col">Value</th>
                                    <th scope="col" class="text-center">Status</th>
                                    <th scope="col" class="text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="promotion" items="${listPromotion}">
                                    <tr>
                                        <td>${promotion.promotionId}</td>
                                        <td>${promotion.title}</td>
                                        <td>${promotion.promotionCode}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${promotion.discountType eq 'PERCENTAGE'}">
                                                    ${promotion.discountValue}%
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${promotion.discountValue}" type="currency" currencyCode="VND"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${promotion.status eq 'ACTIVE'}">
                                                    <span class="bg-success-focus text-success-600 border border-success-main px-24 py-4 radius-4 fw-medium text-sm">Active</span>
                                                </c:when>
                                                <c:when test="${promotion.status eq 'SCHEDULED'}">
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
                                                <c:choose>
                                                    <c:when test="${promotion.status eq 'ACTIVE'}">
                                                        <c:url var="deactivateUrl" value="/promotion/deactivate">
                                                            <c:param name="id" value="${promotion.promotionId}" />
                                                            <c:param name="page" value="${currentPage}" />
                                                            <c:param name="search" value="${searchValue}" />
                                                            <c:param name="status" value="${status}" />
                                                        </c:url>
                                                        <a href="#" onclick="return confirmAction('${deactivateUrl}', 'Are you sure you want to deactivate this promotion?');" class="bg-warning-focus bg-hover-warning-200 text-warning-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Deactivate">
                                                            <iconify-icon icon="fluent:presence-available-24-filled" class="menu-icon"></iconify-icon>
                                                        </a>
                                                    </c:when>
                                                    <c:when test="${promotion.status eq 'INACTIVE'}">
                                                        <c:url var="activateUrl" value="/promotion/activate">
                                                            <c:param name="id" value="${promotion.promotionId}" />
                                                            <c:param name="page" value="${currentPage}" />
                                                            <c:param name="search" value="${searchValue}" />
                                                            <c:param name="status" value="${status}" />
                                                        </c:url>
                                                        <a href="#" onclick="return confirmAction('${activateUrl}', 'Are you sure you want to activate this promotion?');" class="bg-success-focus bg-hover-success-200 text-success-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Activate">
                                                            <iconify-icon icon="fluent:presence-blocked-20-regular" class="menu-icon"></iconify-icon>
                                                        </a>
                                                    </c:when>
                                                    <c:when test="${promotion.status eq 'SCHEDULED'}">
                                                        <c:url var="activateUrl" value="/promotion/activate">
                                                            <c:param name="id" value="${promotion.promotionId}" />
                                                            <c:param name="page" value="${currentPage}" />
                                                            <c:param name="search" value="${searchValue}" />
                                                            <c:param name="status" value="${status}" />
                                                        </c:url>
                                                        <a href="#" onclick="return confirmAction('${activateUrl}', 'Are you sure you want to activate this promotion?');" class="bg-success-focus bg-hover-success-200 text-success-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Activate">
                                                            <iconify-icon icon="material-symbols:schedule" class="menu-icon"></iconify-icon>
                                                        </a>
                                                    </c:when>
                                                </c:choose>
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
                <div class="p-24 text-center">No promotions found matching your criteria.</div>
            </c:if>

            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mt-24 p-24">
                <c:set var="start" value="${(currentPage - 1) * pageSize + 1}" />
                <c:set var="end" value="${start + fn:length(listPromotion) - 1}" />
                <span>
                    <c:if test="${totalPromotions > 0}">Showing ${start} to ${end} of ${totalPromotions} entries</c:if>
                    <c:if test="${totalPromotions == 0}">No entries found</c:if>
                </span>
                <ul class="pagination d-flex flex-wrap align-items-center gap-2 justify-content-center">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <c:url var="prevUrl" value="/promotion/list">
                            <c:param name="page" value="${currentPage - 1}"/>
                            <c:param name="searchValue" value="${searchValue}"/>
                            <c:param name="status" value="${status}"/>
                        </c:url>
                        <a class="page-link" href="${currentPage > 1 ? prevUrl : '#'}">
                            <iconify-icon icon="ep:d-arrow-left"></iconify-icon>
                        </a>
                    </li>
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <c:url var="pageUrl" value="/promotion/list">
                            <c:param name="page" value="${i}"/>
                            <c:param name="searchValue" value="${searchValue}"/>
                            <c:param name="status" value="${status}"/>
                        </c:url>
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px" href="${pageUrl}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <c:url var="nextUrl" value="/promotion/list">
                            <c:param name="page" value="${currentPage + 1}"/>
                            <c:param name="searchValue" value="${searchValue}"/>
                            <c:param name="status" value="${status}"/>
                        </c:url>
                        <a class="page-link" href="${currentPage < totalPages ? nextUrl : '#'}">
                            <iconify-icon icon="ep:d-arrow-right"></iconify-icon>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp"></jsp:include>
    <script>
        function confirmAction(url, message) {
            if (confirm(message)) {
                window.location.href = url;
            }
            return false;
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