<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Category - Admin Dashboard</title>
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
                <h4 class="mb-0">Add New Category</h4>
                <a href="${pageContext.request.contextPath}/category/list" class="btn btn-secondary text-sm btn-sm px-12 py-12 radius-8 d-flex align-items-center gap-2">
                    <iconify-icon icon="ep:back" class="icon text-xl line-height-1"></iconify-icon>
                    Back to List
                </a>
            </div>

            <div class="card-body p-24">
                <form action="${pageContext.request.contextPath}/category/create" method="post" class="needs-validation" novalidate>
                    <input type="hidden" name="action" value="create">
                    
                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <label for="name" class="form-label">Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="name" name="name" required>
                            <div class="invalid-feedback">Please enter a category name.</div>
                        </div>

                        <div class="col-md-6 mb-4">
                            <label for="slug" class="form-label">Slug <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="slug" name="slug" required>
                            <div class="invalid-feedback">Please enter a slug.</div>
                        </div>

                        <div class="col-md-6 mb-4">
                            <label for="moduleType" class="form-label">Module Type <span class="text-danger">*</span></label>
                            <select class="form-select" id="moduleType" name="moduleType" required>
                                <option value="">Select Module Type</option>
                                <option value="BLOG">Blog</option>
                                <option value="PRODUCT">Product</option>
                                <option value="SERVICE">Service</option>
                            </select>
                            <div class="invalid-feedback">Please select a module type.</div>
                        </div>

                        <div class="col-md-6 mb-4">
                            <label for="parentCategoryId" class="form-label">Parent Category</label>
                            <select class="form-select" id="parentCategoryId" name="parentCategoryId">
                                <option value="">None</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.categoryId}">${cat.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6 mb-4">
                            <label for="sortOrder" class="form-label">Sort Order</label>
                            <input type="number" class="form-control" id="sortOrder" name="sortOrder" value="0" min="0">
                        </div>

                        <div class="col-md-6 mb-4">
                            <label for="imageUrl" class="form-label">Image URL</label>
                            <input type="url" class="form-control" id="imageUrl" name="imageUrl">
                            <div class="invalid-feedback">Please enter a valid URL.</div>
                        </div>

                        <div class="col-md-12 mb-4">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="4"></textarea>
                        </div>

                        <div class="col-md-12 mb-4">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="isActive" name="isActive" value="true" checked>
                                <label class="form-check-label" for="isActive">Active</label>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex gap-3">
                        <button type="submit" class="btn btn-primary">Create Category</button>
                        <button type="reset" class="btn btn-secondary">Reset Form</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
    <script>
        // Form validation
        (function () {
            'use strict'
            var forms = document.querySelectorAll('.needs-validation')
            Array.prototype.slice.call(forms).forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }
                    form.classList.add('was-validated')
                }, false)
            })
        })()

        // Auto-generate slug from name
        document.getElementById('name').addEventListener('input', function() {
            let slug = this.value.toLowerCase()
                .replace(/[^a-z0-9]+/g, '-')
                .replace(/(^-|-$)/g, '');
            document.getElementById('slug').value = slug;
        });
    </script>
</body>
</html> 