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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/remixicon.css"/>
    <style>
        .container { max-width: 500px; margin-top: 40px; }
        .form-label { font-weight: 500; }
        .error-text { 
            width: 100%;
            margin-top: .25rem;
            font-size: 80%;
            color: #dc3545;
        }
        .is-invalid {
             border-color: #dc3545 !important;
        }
    </style>
</head>
<body>
     <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
     <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

<div class="container">
    <h3 class="mb-4 text-center text-primary">Add New Promotion</h3>
    
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/promotion/create" method="post" novalidate>
        <!-- Promotion Name -->
        <div class="form-group">
            <label class="form-label" for="promotionName">Promotion Name <span class="text-danger">*</span></label>
            <input type="text" class="form-control<c:if test='${not empty errors.promotionName}'> is-invalid</c:if>" 
                   id="promotionName" name="promotionName" required maxlength="100" 
                   value="${promotionInput.promotionName}">
            <div class="error-text">${errors.promotionName}</div>
        </div>
        <!-- Description -->
        <div class="form-group">
            <label class="form-label" for="description">Description</label>
            <textarea class="form-control<c:if test='${not empty errors.description}'> is-invalid</c:if>" 
                      id="description" name="description" rows="3">${promotionInput.description}</textarea>
            <div class="error-text">${errors.description}</div>
        </div>
        <!-- Discount -->
        <div class="form-group">
            <label class="form-label" for="discount">Discount (%) <span class="text-danger">*</span></label>
            <input type="number" class="form-control<c:if test='${not empty errors.discount}'> is-invalid</c:if>" 
                   id="discount" name="discount" required min="1" max="100"
                   value="${promotionInput.discount}">
            <div class="error-text">${errors.discount}</div>
        </div>
        <!-- Start Date -->
        <div class="form-group">
            <label class="form-label" for="startDate">Start Date <span class="text-danger">*</span></label>
            <input type="date" class="form-control<c:if test='${not empty errors.startDate}'> is-invalid</c:if>" 
                   id="startDate" name="startDate" required
                   value="${promotionInput.startDate}">
            <div class="error-text">${errors.startDate}</div>
        </div>
        <!-- End Date -->
        <div class="form-group">
            <label class="form-label" for="endDate">End Date <span class="text-danger">*</span></label>
            <input type="date" class="form-control<c:if test='${not empty errors.endDate}'> is-invalid</c:if>" 
                   id="endDate" name="endDate" required
                   value="${promotionInput.endDate}">
            <div class="error-text">${errors.endDate}</div>
        </div>
        <!-- Status -->
        <div class="form-group">
            <label class="form-label" for="status">Status</label>
            <select class="form-control" id="status" name="status">
                <option value="Active" <c:if test='${promotionInput.status == "Active"}'>selected</c:if>>Active</option>
                <option value="Inactive" <c:if test='${promotionInput.status == "Inactive"}'>selected</c:if>>Inactive</option>
            </select>
        </div>
        <button type="submit" class="btn btn-primary btn-block">Add Promotion</button>
        <a href="${pageContext.request.contextPath}/promotion/list" class="btn btn-secondary btn-block mt-2">Back to Promotion List</a>
    </form>
</div>
     <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html>
