<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add New Promotion</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/style.css"/>
    <style>
        .container { max-width: 500px; margin-top: 40px; }
        .form-label { font-weight: 500; }
        .error-text { width: 100%; margin-top: .25rem; font-size: 80%; color: #dc3545; }
        .is-invalid { border-color: #dc3545 !important; }
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
    <form action="${pageContext.request.contextPath}/promotion" method="post" novalidate>
        <input type="hidden" name="action" value="create" />
        <!-- Title -->
        <div class="form-group">
            <label class="form-label" for="title">Promotion Title <span class="text-danger">*</span></label>
            <input type="text" class="form-control ${not empty errors.title ? 'is-invalid' : ''}" 
                   id="title" name="title" required maxlength="100" 
                   value="${not empty promotionInput.title ? promotionInput.title : ''}">
            <div class="error-text">${errors.title}</div>
        </div>
        <!-- Promotion Code -->
        <div class="form-group">
            <label class="form-label" for="promotionCode">Promotion Code <span class="text-danger">*</span></label>
            <input type="text" class="form-control ${not empty errors.promotionCode ? 'is-invalid' : ''}" 
                   id="promotionCode" name="promotionCode" required maxlength="10" 
                   value="${not empty promotionInput.promotionCode ? promotionInput.promotionCode : ''}">
            <div class="error-text">${errors.promotionCode}</div>
        </div>
        <!-- Discount Type -->
        <div class="form-group">
            <label class="form-label" for="discountType">Discount Type <span class="text-danger">*</span></label>
            <select class="form-control ${not empty errors.discountType ? 'is-invalid' : ''}" id="discountType" name="discountType" required>
                <option value="">-- Select --</option>
                <option value="PERCENTAGE" ${promotionInput.discountType == 'PERCENTAGE' ? 'selected' : ''}>Percentage (%)</option>
                <option value="FIXED" ${promotionInput.discountType == 'FIXED' ? 'selected' : ''}>Fixed Amount (VND)</option>
            </select>
            <div class="error-text">${errors.discountType}</div>
        </div>
        <!-- Discount Value -->
        <div class="form-group">
            <label class="form-label" for="discountValue">Discount Value <span class="text-danger">*</span></label>
            <input type="number" class="form-control ${not empty errors.discountValue ? 'is-invalid' : ''}" 
                   id="discountValue" name="discountValue" required min="1" step="0.01"
                   value="${not empty promotionInput.discountValue ? promotionInput.discountValue : ''}">
            <div class="error-text">${errors.discountValue}</div>
        </div>
        <!-- Description -->
        <div class="form-group">
            <label class="form-label" for="description">Description <span class="text-danger">*</span></label>
            <textarea class="form-control ${not empty errors.description ? 'is-invalid' : ''}" 
                      id="description" name="description" rows="3" required>${promotionInput.description}</textarea>
            <div class="error-text">${errors.description}</div>
        </div>
        <!-- Status -->
        <div class="form-group">
            <label class="form-label" for="status">Status</label>
            <select class="form-control" id="status" name="status">
                <option value="SCHEDULED" ${promotionInput.status == 'SCHEDULED' ? 'selected' : ''}>Scheduled</option>
                <option value="ACTIVE" ${promotionInput.status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                <option value="INACTIVE" ${promotionInput.status == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
            </select>
        </div>
        <!-- Start Date -->
        <div class="form-group">
            <label class="form-label" for="startDate">Start Date <span class="text-danger">*</span></label>
            <input type="date" class="form-control ${not empty errors.startDate ? 'is-invalid' : ''}" 
                   id="startDate" name="startDate" required
                   value="${promotionInput.startDate}">
            <div class="error-text">${errors.startDate}</div>
        </div>
        <!-- End Date -->
        <div class="form-group">
            <label class="form-label" for="endDate">End Date <span class="text-danger">*</span></label>
            <input type="date" class="form-control ${not empty errors.endDate ? 'is-invalid' : ''}" 
                   id="endDate" name="endDate" required
                   value="${promotionInput.endDate}">
            <div class="error-text">${errors.endDate}</div>
        </div>
        <button type="submit" class="btn btn-primary btn-block">Add Promotion</button>
        <a href="${pageContext.request.contextPath}/promotion/list" class="btn btn-secondary btn-block mt-2">Back to Promotion List</a>
    </form>
</div>
<jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html>
