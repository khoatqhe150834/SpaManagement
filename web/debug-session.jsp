<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Session Debug</title>
</head>
<body>
    <h1>Session Debug Information</h1>
    
    <h2>Session Attributes:</h2>
    <ul>
        <li><strong>authenticated:</strong> ${sessionScope.authenticated}</li>
        <li><strong>userType:</strong> ${sessionScope.userType}</li>
    </ul>
    
    <h2>User Object:</h2>
    <c:choose>
        <c:when test="${not empty sessionScope.user}">
            <ul>
                <li><strong>User ID:</strong> ${sessionScope.user.userId}</li>
                <li><strong>Full Name:</strong> ${sessionScope.user.fullName}</li>
                <li><strong>Email:</strong> ${sessionScope.user.email}</li>
                <li><strong>Role ID:</strong> ${sessionScope.user.roleId}</li>
                <li><strong>Phone:</strong> ${sessionScope.user.phoneNumber}</li>
                <li><strong>Gender:</strong> ${sessionScope.user.gender}</li>
                <li><strong>Is Active:</strong> ${sessionScope.user.isActive}</li>
            </ul>
        </c:when>
        <c:otherwise>
            <p>No user object in session</p>
        </c:otherwise>
    </c:choose>
    
    <h2>Customer Object:</h2>
    <c:choose>
        <c:when test="${not empty sessionScope.customer}">
            <ul>
                <li><strong>Customer ID:</strong> ${sessionScope.customer.customerId}</li>
                <li><strong>Full Name:</strong> ${sessionScope.customer.fullName}</li>
                <li><strong>Email:</strong> ${sessionScope.customer.email}</li>
                <li><strong>Role ID:</strong> ${sessionScope.customer.roleId}</li>
                <li><strong>Phone:</strong> ${sessionScope.customer.phoneNumber}</li>
                <li><strong>Gender:</strong> ${sessionScope.customer.gender}</li>
                <li><strong>Address:</strong> ${sessionScope.customer.address}</li>
                <li><strong>Is Active:</strong> ${sessionScope.customer.isActive}</li>
                <li><strong>Loyalty Points:</strong> ${sessionScope.customer.loyaltyPoints}</li>
            </ul>
        </c:when>
        <c:otherwise>
            <p>No customer object in session</p>
        </c:otherwise>
    </c:choose>
    
    <h2>Actions:</h2>
    <p><a href="${pageContext.request.contextPath}/profile">Go to Profile</a></p>
    <p><a href="${pageContext.request.contextPath}/">Go to Home</a></p>
</body>
</html> 