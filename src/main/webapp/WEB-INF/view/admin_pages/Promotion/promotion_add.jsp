 <%-- 
    Document   : promotion_add
    Created on : Jun 13, 2025, 1:03:04 AM
    Author     : Admin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add New Promotion</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"/>
    <!-- Admin theme CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/remixicon.css"/>
    <!-- Custom CSS -->
    <style>
        body {
            background-color: #f5f6fa !important;
        }
        .form-container {
            padding: 2rem;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            margin: 2rem auto;
            max-width: 800px;
            position: relative;
            z-index: 1;
        }
        .form-label { 
            font-weight: 500; 
            margin-bottom: 0.5rem;
            color: #374151;
            display: block;
        }
        .error-text { 
            width: 100%;
            margin-top: .25rem;
            font-size: 80%;
            color: #dc3545;
            display: block;
        }
        .is-invalid {
            border-color: #dc3545 !important;
        }
        .main-content {
            margin-left: 280px;
            padding: 20px;
            transition: margin-left .3s ease-in-out;
            min-height: 100vh;
            background-color: #f5f6fa;
            position: relative;
            z-index: 0;
        }
        .form-group {
            margin-bottom: 1.5rem;
        }
        .form-control {
            display: block;
            width: 100%;
            height: calc(1.5em + 0.75rem + 2px);
            padding: 0.375rem 0.75rem;
            font-size: 1rem;
            font-weight: 400;
            line-height: 1.5;
            color: #495057;
            background-color: #fff;
            background-clip: padding-box;
            border: 1px solid #ced4da;
            border-radius: 0.25rem;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }
        .form-control:focus {
            color: #495057;
            background-color: #fff;
            border-color: #80bdff;
            outline: 0;
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
        }
        textarea.form-control {
            height: auto;
        }
        @media (max-width: 1199px) {
            .main-content {
                margin-left: 0;
            }
        }
    </style>
</head>
<body class="bg-neutral-50">
    <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

    <div class="main-content">
        <div class="form-container">
            <h3 class="mb-4 text-center text-primary">Add New Promotion</h3>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/promotion/create" method="post" novalidate>
                <!-- Promotion Name -->
                <div class="form-group">
                    <label class="form-label" for="promotionName">Promotion Name <span class="text-danger">*</span></label>
                    <input type="text" class="form-control ${not empty errors.promotionName ? 'is-invalid' : ''}" 
                           id="promotionName" name="promotionName" required maxlength="100" 
                           value="${promotionInput.promotionName}">
                    <div class="error-text">${errors.promotionName}</div>
                </div>

                <!-- Description -->
                <div class="form-group">
                    <label class="form-label" for="description">Description</label>
                    <textarea class="form-control ${not empty errors.description ? 'is-invalid' : ''}" 
                              id="description" name="description" rows="3">${promotionInput.description}</textarea>
                    <div class="error-text">${errors.description}</div>
                </div>

                <!-- Discount -->
                <div class="form-group">
                    <label class="form-label" for="discount">Discount (%) <span class="text-danger">*</span></label>
                    <input type="number" class="form-control ${not empty errors.discount ? 'is-invalid' : ''}" 
                           id="discount" name="discount" required min="1" max="100"
                           value="${promotionInput.discount}">
                    <div class="error-text">${errors.discount}</div>
                </div>

                <div class="row">
                    <!-- Start Date -->
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label" for="startDate">Start Date <span class="text-danger">*</span></label>
                            <input type="date" class="form-control ${not empty errors.startDate ? 'is-invalid' : ''}" 
                                   id="startDate" name="startDate" required
                                   value="${promotionInput.startDate}">
                            <div class="error-text">${errors.startDate}</div>
                        </div>
                    </div>

                    <!-- End Date -->
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label" for="endDate">End Date <span class="text-danger">*</span></label>
                            <input type="date" class="form-control ${not empty errors.endDate ? 'is-invalid' : ''}" 
                                   id="endDate" name="endDate" required
                                   value="${promotionInput.endDate}">
                            <div class="error-text">${errors.endDate}</div>
                        </div>
                    </div>
                </div>

                <!-- Status -->
                <div class="form-group">
                    <label class="form-label" for="status">Status</label>
                    <select class="form-control" id="status" name="status">
                        <option value="Active" ${promotionInput.status == 'Active' ? 'selected' : ''}>Active</option>
                        <option value="Inactive" ${promotionInput.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>

                <div class="form-group mt-4">
                    <button type="submit" class="btn btn-primary">Add Promotion</button>
                    <a href="${pageContext.request.contextPath}/promotion/list" class="btn btn-secondary ml-2">Back to Promotion List</a>
                </div>
            </form>
        </div>
    </div>

    <!-- jQuery -->
    <script src="${pageContext.request.contextPath}/assets/admin/js/lib/jquery-3.7.1.min.js"></script>
    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/assets/admin/js/lib/bootstrap.bundle.min.js"></script>
    <!-- Iconify -->
    <script src="${pageContext.request.contextPath}/assets/admin/js/lib/iconify-icon.min.js"></script>
    <!-- Main JS -->
    <script src="${pageContext.request.contextPath}/assets/admin/js/app.js"></script>
</body>
</html>
