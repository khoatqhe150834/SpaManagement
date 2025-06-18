<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Category Details - Admin Dashboard</title>
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
                <h4 class="mb-0">Category Details</h4>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/category/edit?id=${category.categoryId}" class="btn btn-success text-sm btn-sm px-12 py-12 radius-8 d-flex align-items-center gap-2">
                        <iconify-icon icon="lucide:edit" class="icon text-xl line-height-1"></iconify-icon>
                        Edit Category
                    </a>
                    <a href="${pageContext.request.contextPath}/category/list" class="btn btn-secondary text-sm btn-sm px-12 py-12 radius-8 d-flex align-items-center gap-2">
                        <iconify-icon icon="ep:back" class="icon text-xl line-height-1"></iconify-icon>
                        Back to List
                    </a>
                </div>
            </div>

            <div class="card-body p-24">
                <div class="row">
                    <div class="col-md-4 text-center mb-4">
                        <img src="${not empty category.imageUrl ? category.imageUrl : 'https://placehold.co/300x300/7C3AED/FFFFFF?text=CAT'}" 
                             alt="${category.name}"
                             class="img-fluid rounded mb-3"
                             style="max-width: 300px; height: auto;">
                    </div>
                    <div class="col-md-8">
                        <table class="table table-bordered">
                            <tr>
                                <th style="width: 200px;">ID</th>
                                <td>${category.categoryId}</td>
                            </tr>
                            <tr>
                                <th>Name</th>
                                <td>${category.name}</td>
                            </tr>
                            <tr>
                                <th>Slug</th>
                                <td>${category.slug}</td>
                            </tr>
                            <tr>
                                <th>Description</th>
                                <td>${category.description}</td>
                            </tr>
                            <tr>
                                <th>Module Type</th>
                                <td>${category.moduleType}</td>
                            </tr>
                            <tr>
                                <th>Parent Category</th>
                                <td>${category.parentCategoryId != null ? category.parentCategoryId : 'None'}</td>
                            </tr>
                            <tr>
                                <th>Sort Order</th>
                                <td>${category.sortOrder}</td>
                            </tr>
                            <tr>
                                <th>Status</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${category.active}">
                                            <span class="bg-success-focus text-success-600 border border-success-main px-24 py-4 radius-4 fw-medium text-sm">Active</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="bg-neutral-200 text-neutral-600 border border-neutral-400 px-24 py-4 radius-4 fw-medium text-sm">Inactive</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <th>Created At</th>
                                <td><fmt:formatDate value="${category.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                            </tr>
                            <tr>
                                <th>Updated At</th>
                                <td><fmt:formatDate value="${category.updatedAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html> 