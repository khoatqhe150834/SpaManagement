<%-- 
    Document   : test-booking-checkout-security.jsp
    Created on : Security Test Page for Booking Checkout
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Booking Checkout Security Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .test-section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .success { background-color: #d4edda; border-color: #c3e6cb; color: #155724; }
        .error { background-color: #f8d7da; border-color: #f5c6cb; color: #721c24; }
        .info { background-color: #d1ecf1; border-color: #bee5eb; color: #0c5460; }
        .test-link { display: inline-block; margin: 10px; padding: 10px 15px; background: #007bff; color: white; text-decoration: none; border-radius: 3px; }
        .test-link:hover { background: #0056b3; }
    </style>
</head>
<body>
    <h1>Booking Checkout Security Test</h1>
    
    <div class="test-section info">
        <h2>Current Session Information</h2>
        <p><strong>Session ID:</strong> <%= session.getId() %></p>
        <p><strong>Session Created:</strong> <%= new java.util.Date(session.getCreationTime()) %></p>
        <p><strong>User in Session:</strong> 
            <c:choose>
                <c:when test="${sessionScope.user != null}">
                    ${sessionScope.user.fullName} (Role ID: ${sessionScope.user.roleId})
                </c:when>
                <c:when test="${sessionScope.customer != null}">
                    ${sessionScope.customer.fullName} (Role ID: ${sessionScope.customer.roleId})
                </c:when>
                <c:otherwise>
                    No authenticated user found
                </c:otherwise>
            </c:choose>
        </p>
        <p><strong>Request Attributes:</strong></p>
        <ul>
            <li>userType: ${requestScope.userType}</li>
            <li>isAuthenticated: ${requestScope.isAuthenticated}</li>
            <li>userRoleId: ${requestScope.userRoleId}</li>
            <li>userRoleName: ${requestScope.userRoleName}</li>
        </ul>
    </div>

    <div class="test-section">
        <h2>Security Test Links</h2>
        <p>Test access to different endpoints with current authentication:</p>
        
        <a href="${pageContext.request.contextPath}/booking-checkout" class="test-link">
            Test Booking Checkout Access
        </a>
        
        <a href="${pageContext.request.contextPath}/booking" class="test-link">
            Test Booking Access (Public)
        </a>
        
        <a href="${pageContext.request.contextPath}/customer/" class="test-link">
            Test Customer Area Access
        </a>
        
        <a href="${pageContext.request.contextPath}/admin" class="test-link">
            Test Admin Access (Should Fail for Customers)
        </a>
    </div>

    <div class="test-section">
        <h2>Expected Behavior</h2>
        <ul>
            <li><strong>Authenticated Customers (Role ID: 5):</strong> Should be able to access /booking-checkout</li>
            <li><strong>Unauthenticated Users:</strong> Should be redirected to login page</li>
            <li><strong>Other Roles:</strong> Admin, Manager, Therapist, Receptionist should also have access</li>
            <li><strong>Authorization Filter:</strong> Should properly validate role permissions</li>
        </ul>
    </div>

    <div class="test-section">
        <h2>Role Constants Reference</h2>
        <ul>
            <li>ADMIN_ID = 1</li>
            <li>MANAGER_ID = 2</li>
            <li>THERAPIST_ID = 3</li>
            <li>RECEPTIONIST_ID = 4</li>
            <li>CUSTOMER_ID = 5</li>
            <li>MARKETING_ID = 6</li>
        </ul>
    </div>

    <div class="test-section">
        <h2>Quick Actions</h2>
        <a href="${pageContext.request.contextPath}/login" class="test-link">Go to Login</a>
        <a href="${pageContext.request.contextPath}/logout" class="test-link">Logout</a>
        <a href="${pageContext.request.contextPath}/" class="test-link">Home</a>
    </div>

    <script>
        // Add some client-side testing
        console.log('Security Test Page Loaded');
        console.log('Context Path:', '${pageContext.request.contextPath}');
        console.log('Session Info:', {
            user: '${sessionScope.user}',
            customer: '${sessionScope.customer}',
            userType: '${requestScope.userType}',
            isAuthenticated: '${requestScope.isAuthenticated}'
        });
    </script>
</body>
</html>
