<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add New Customer</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"/>
    <style>
        .container { max-width: 500px; margin-top: 40px; }
        .form-label { font-weight: 500; }
        .error-message { color: #dc3545; }
    </style>
</head>
<body>
<div class="container">
    <h3 class="mb-4 text-center text-primary">Add New Customer</h3>
    <c:if test="${not empty error}">
        <div class="alert alert-danger error-message">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/customer/create" method="post" autocomplete="off">
        <!-- Full Name -->
        <div class="form-group">
            <label class="form-label" for="fullName">Full Name <span class="text-danger">*</span></label>
            <input type="text" class="form-control" id="fullName" name="fullName" required value="${param.fullName}">
        </div>
        <!-- Email -->
        <div class="form-group">
            <label class="form-label" for="email">Email <span class="text-danger">*</span></label>
            <input type="email" class="form-control" id="email" name="email" required value="${param.email}">
        </div>
        <!-- Password -->
        <div class="form-group">
            <label class="form-label" for="password">Password <span class="text-danger">*</span></label>
            <input type="password" class="form-control" id="password" name="password" required>
        </div>
        <!-- Phone Number -->
        <div class="form-group">
            <label class="form-label" for="phoneNumber">Phone Number</label>
            <input type="text" class="form-control" id="phoneNumber" name="phoneNumber" value="${param.phoneNumber}">
        </div>
        <!-- Gender -->
        <div class="form-group">
            <label class="form-label">Gender</label>
            <select class="form-control" name="gender">
                <option value="">-- Select --</option>
                <option value="Male" ${param.gender == 'Male' ? 'selected' : ''}>Male</option>
                <option value="Female" ${param.gender == 'Female' ? 'selected' : ''}>Female</option>
                <option value="Other" ${param.gender == 'Other' ? 'selected' : ''}>Other</option>
            </select>
        </div>
        <!-- Birthday -->
        <div class="form-group">
            <label class="form-label" for="birthday">Birthday</label>
            <input type="date" class="form-control" id="birthday" name="birthday" value="${param.birthday}">
        </div>
        <!-- Address -->
        <div class="form-group">
            <label class="form-label" for="address">Address</label>
            <input type="text" class="form-control" id="address" name="address" value="${param.address}">
        </div>
        <button type="submit" class="btn btn-primary btn-block">Add Customer</button>
        <a href="${pageContext.request.contextPath}/customer/list" class="btn btn-secondary btn-block">Back to Customer List</a>
    </form>
</div>
</body>
</html>
