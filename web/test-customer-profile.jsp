<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Test Customer Profile</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .info { background: #f0f0f0; padding: 15px; margin: 10px 0; border-radius: 5px; }
        .error { background: #ffcccb; padding: 15px; margin: 10px 0; border-radius: 5px; }
        .success { background: #c8e6c9; padding: 15px; margin: 10px 0; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>Test Customer Profile</h1>
    
    <h2>Authentication Status</h2>
    <div class="info">
        <strong>Authenticated:</strong> ${sessionScope.authenticated} <br>
        <strong>User Type:</strong> ${sessionScope.userType}
    </div>
    
    <h2>Session Check</h2>
    <c:choose>
        <c:when test="${empty sessionScope.customer and empty sessionScope.user}">
            <div class="error">
                <strong>ERROR:</strong> No user or customer in session! Please login first.
                <br><a href="${pageContext.request.contextPath}/login">Go to Login</a>
            </div>
        </c:when>
        <c:when test="${not empty sessionScope.customer}">
            <div class="success">
                <strong>SUCCESS:</strong> Customer found in session!
            </div>
            
            <h2>Customer Information</h2>
            <div class="info">
                <strong>Customer ID:</strong> ${sessionScope.customer.customerId} <br>
                <strong>Full Name:</strong> ${sessionScope.customer.fullName} <br>
                <strong>Email:</strong> ${sessionScope.customer.email} <br>
                <strong>Phone:</strong> ${sessionScope.customer.phoneNumber} <br>
                <strong>Role ID:</strong> ${sessionScope.customer.roleId} <br>
                <strong>Gender:</strong> ${sessionScope.customer.gender} <br>
                <strong>Address:</strong> ${sessionScope.customer.address} <br>
                <strong>Birthday:</strong> ${sessionScope.customer.birthday} <br>
                <strong>Is Active:</strong> ${sessionScope.customer.isActive} <br>
                <strong>Loyalty Points:</strong> ${sessionScope.customer.loyaltyPoints} <br>
                <strong>Created At:</strong> ${sessionScope.customer.createdAt} <br>
                <strong>Updated At:</strong> ${sessionScope.customer.updatedAt}
            </div>
        </c:when>
        <c:when test="${not empty sessionScope.user}">
            <div class="success">
                <strong>SUCCESS:</strong> User found in session!
            </div>
            
            <h2>User Information</h2>
            <div class="info">
                <strong>User ID:</strong> ${sessionScope.user.userId} <br>
                <strong>Full Name:</strong> ${sessionScope.user.fullName} <br>
                <strong>Email:</strong> ${sessionScope.user.email} <br>
                <strong>Phone:</strong> ${sessionScope.user.phoneNumber} <br>
                <strong>Role ID:</strong> ${sessionScope.user.roleId} <br>
                <strong>Gender:</strong> ${sessionScope.user.gender} <br>
                <strong>Birthday:</strong> ${sessionScope.user.birthday} <br>
                <strong>Is Active:</strong> ${sessionScope.user.isActive}
            </div>
        </c:when>
    </c:choose>
    
    <h2>Navigation</h2>
    <div class="info">
        <a href="${pageContext.request.contextPath}/profile">Go to Full Profile Page</a> | 
        <a href="${pageContext.request.contextPath}/">Go to Home</a> | 
        <a href="${pageContext.request.contextPath}/debug-session.jsp">Debug Session</a>
    </div>
    
</body>
</html> 