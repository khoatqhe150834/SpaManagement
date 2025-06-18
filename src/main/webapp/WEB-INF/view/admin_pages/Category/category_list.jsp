<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Categories - Admin Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/toast.jsp" />

    <div class="dashboard-main-body">
        <div class="card h-100 p-0 radius-12">
            <div class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center flex-wrap gap-3 justify-content-between">
                <div class="d-flex align-items-center flex-wrap gap-3">
                    <form class="navbar-search d-flex gap-2 align-items-center" method="get" action="${pageContext.request.contextPath}/category/list">
                        <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="pageSize" onchange="this.form.submit()">
                            <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                            <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                            <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                            <option value="9999" ${pageSize == 9999 ? 'selected' : ''}>All</option>
                        </select>
                        <input type="text" class="bg-base h-40-px w-auto" name="searchValue" placeholder="Search by name..." value="${searchValue}">
                        <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="status">
                            <option value="">All Status</option>
                            <option value="active" ${status == 'active' ? 'selected' : ''}>Active</option>
                            <option value="inactive" ${status == 'inactive' ? 'selected' : ''}>Inactive</option>
                        </select>
                        <button type="submit" class="btn btn-primary h-40-px radius-12">Search</button>
                        <input type="hidden" name="page" value="1">
                    </form>
                </div>
                
                <a href="${pageContext.request.contextPath}/category/create" class="btn btn-primary text-sm btn-sm px-12 py-12 radius-8 d-flex align-items-center gap-2">
                    <iconify-icon icon="ic:baseline-plus" class="icon text-xl line-height-1"></iconify-icon>
                    Add New Category
                </a>
            </div>

            <c:if test="${not empty categories}">
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
                                    <th scope="col">Image</th>
                                    <th scope="col">
                                        Name
                                        <a href="?sortBy=name&sortOrder=asc<c:if test='${not empty searchValue}'>&searchValue=${searchValue}</c:if><c:if test='${not empty status}'>&status=${status}</c:if>&page=${currentPage}" title="Sort Ascending">&#9650;</a>
                                        <a href="?sortBy=name&sortOrder=desc<c:if test='${not empty searchValue}'>&searchValue=${searchValue}</c:if><c:if test='${not empty status}'>&status=${status}</c:if>&page=${currentPage}" title="Sort Descending">&#9660;</a>
                                    </th>
                                    <th scope="col">Module Type</th>
                                    <th scope="col">Sort Order</th>
                                    <th scope="col" class="text-center">Status</th>
                                    <th scope="col" class="text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="category" items="${categories}">
                                    <tr>
                                        <td>${category.categoryId}</td>
                                        <td>
                                            <img src="${not empty category.imageUrl ? category.imageUrl : 'https://placehold.co/50x50/7C3AED/FFFFFF?text=CAT'}" 
                                                 alt="${category.name}"
                                                 class="rounded"
                                                 style="width: 50px; height: 50px; object-fit: cover;">
                                        </td>
                                        <td>${category.name}</td>
                                        <td>${category.moduleType}</td>
                                        <td>${category.sortOrder}</td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${category.active}">
                                                    <span class="bg-success-focus text-success-600 border border-success-main px-24 py-4 radius-4 fw-medium text-sm">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="bg-neutral-200 text-neutral-600 border border-neutral-400 px-24 py-4 radius-4 fw-medium text-sm">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-flex align-items-center gap-10 justify-content-center">
                                                <a href="${pageContext.request.contextPath}/category/view?id=${category.categoryId}" class="bg-info-focus text-info-600 bg-hover-info-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle">
                                                    <iconify-icon icon="majesticons:eye-line" class="menu-icon"></iconify-icon>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/category/edit?id=${category.categoryId}" class="bg-success-focus text-success-600 bg-hover-success-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle">
                                                    <iconify-icon icon="lucide:edit" class="menu-icon"></iconify-icon>
                                                </a>
                                                <a href="#" onclick="return confirmDelete(${category.categoryId});" class="bg-danger-focus text-danger-600 bg-hover-danger-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle">
                                                    <iconify-icon icon="lucide:trash-2" class="menu-icon"></iconify-icon>
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

            <c:if test="${empty categories}">
                <div class="p-24 text-center">No categories found matching your criteria.</div>
            </c:if>

            <div class="card-footer border-top bg-base py-16 px-24">
                <ul class="pagination mb-0 justify-content-center">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <c:url var="prevUrl" value="/category/list">
                            <c:param name="page" value="${currentPage - 1}"/>
                            <c:param name="searchValue" value="${searchValue}"/>
                            <c:param name="status" value="${status}"/>
                        </c:url>
                        <a class="page-link" href="${currentPage > 1 ? prevUrl : '#'}">
                            <iconify-icon icon="ep:d-arrow-left"></iconify-icon>
                        </a>
                    </li>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:url var="pageUrl" value="/category/list">
                            <c:param name="page" value="${i}"/>
                            <c:param name="searchValue" value="${searchValue}"/>
                            <c:param name="status" value="${status}"/>
                        </c:url>
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="${pageUrl}">${i}</a>
                        </li>
                    </c:forEach>

                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <c:url var="nextUrl" value="/category/list">
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

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
    <script>
        function confirmDelete(id) {
            if (confirm('Are you sure you want to delete this category?')) {
                window.location.href = '${pageContext.request.contextPath}/category/delete?id=' + id;
            }
            return false;
        }
    </script>
</body>
</html> 