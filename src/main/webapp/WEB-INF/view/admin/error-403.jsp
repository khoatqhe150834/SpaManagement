<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.RoleConstants" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Access Denied - Admin Panel</title>
    
    <!-- Bootstrap CSS -->
    <link href="${pageContext.request.contextPath}/assets/admin/css/lib/bootstrap.min.css" rel="stylesheet">
    
    <!-- RemixIcon CSS -->
    <link href="${pageContext.request.contextPath}/assets/admin/css/remixicon.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/assets/admin/css/style.css" rel="stylesheet">
    
    <style>
        .error-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 2rem;
        }
        
        .error-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            padding: 3rem;
            text-align: center;
            max-width: 600px;
            width: 100%;
            position: relative;
            overflow: hidden;
        }
        
        .error-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #ff6b6b, #ee5a52, #ffa726);
        }
        
        .error-icon {
            background: linear-gradient(135deg, #ff6b6b, #ee5a52);
            width: 120px;
            height: 120px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 2rem;
            box-shadow: 0 10px 30px rgba(255, 107, 107, 0.3);
        }
        
        .error-icon i {
            font-size: 3rem;
            color: white;
        }
        
        .error-code {
            font-size: 5rem;
            font-weight: 800;
            color: #2d3436;
            margin-bottom: 1rem;
            text-shadow: 0 5px 10px rgba(0,0,0,0.1);
        }
        
        .error-title {
            font-size: 1.8rem;
            color: #2d3436;
            margin-bottom: 1rem;
            font-weight: 600;
        }
        
        .error-subtitle {
            font-size: 1rem;
            color: #636e72;
            margin-bottom: 2rem;
            line-height: 1.6;
        }
        
        .btn-custom {
            padding: 12px 25px;
            border-radius: 25px;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            margin: 0 5px;
        }
        
        .btn-primary-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
        }
        
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
            color: white;
        }
        
        .btn-secondary-custom {
            background: transparent;
            color: #636e72;
            border: 2px solid #ddd;
        }
        
        .btn-secondary-custom:hover {
            background: #f8f9fa;
            border-color: #bbb;
            color: #636e72;
        }
        
        .user-info {
            background: #f8f9fa;
            padding: 1rem;
            border-radius: 10px;
            margin: 2rem 0;
            border-left: 4px solid #667eea;
        }
        
        .user-info small {
            color: #636e72;
        }
        
        .contact-info {
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid #eee;
        }
    </style>
</head>
<body>
    <div class="error-wrapper">
        <div class="error-card">
            <div class="error-icon">
                <i class="ri-shield-cross-line"></i>
            </div>
            
            <div class="error-code">403</div>
            <h1 class="error-title">Access Denied</h1>
            <p class="error-subtitle">
                <c:choose>
                    <c:when test="${not empty errorMessage}">
                        ${errorMessage}
                    </c:when>
                    <c:otherwise>
                        You don't have permission to access this resource. Please contact your administrator if you believe this is an error.
                    </c:otherwise>
                </c:choose>
            </p>
            
            <!-- User Info -->
            <c:if test="${not empty sessionScope.user}">
                <div class="user-info">
                    <div><strong>Current User:</strong> ${sessionScope.user.fullName}</div>
                    <div><strong>Email:</strong> ${sessionScope.user.email}</div>
                    <div><strong>Role:</strong> 
                        <c:set var="userRoleName" value="<%= RoleConstants.getUserTypeFromRole(((model.User)session.getAttribute(\"user\")).getRoleId()) %>" />
                        <span class="badge bg-primary">${userRoleName}</span>
                    </div>
                    <c:if test="${not empty requestedPath}">
                        <small class="text-muted">Requested Path: ${requestedPath}</small>
                    </c:if>
                </div>
            </c:if>
            
            <!-- Action Buttons -->
            <div class="d-flex justify-content-center flex-wrap mt-4">
                <a href="javascript:history.back()" class="btn-custom btn-secondary-custom">
                    <i class="ri-arrow-left-line"></i>Go Back
                </a>
                
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <c:set var="userRoleName" value="<%= RoleConstants.getUserTypeFromRole(((model.User)session.getAttribute(\"user\")).getRoleId()) %>" />
                        <c:choose>
                            <c:when test="${userRoleName == 'ADMIN'}">
                                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-custom btn-primary-custom">
                                    <i class="ri-dashboard-line"></i>Admin Dashboard
                                </a>
                            </c:when>
                            <c:when test="${userRoleName == 'MANAGER'}">
                                <a href="${pageContext.request.contextPath}/manager/dashboard" class="btn-custom btn-primary-custom">
                                    <i class="ri-dashboard-line"></i>Manager Dashboard
                                </a>
                            </c:when>
                            <c:when test="${userRoleName == 'THERAPIST'}">
                                <a href="${pageContext.request.contextPath}/therapist/dashboard" class="btn-custom btn-primary-custom">
                                    <i class="ri-dashboard-line"></i>Therapist Dashboard
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/dashboard" class="btn-custom btn-primary-custom">
                                    <i class="ri-dashboard-line"></i>Dashboard
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn-custom btn-primary-custom">
                            <i class="ri-login-box-line"></i>Login
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Contact Information -->
            <div class="contact-info">
                <small class="text-muted">
                    Need help? Contact IT Support: 
                    <a href="mailto:it@beautyzone.com" class="text-decoration-none">it@beautyzone.com</a>
                    <br>
                    Or call: <a href="tel:+84123456789" class="text-decoration-none">0123 456 789</a> (ext. 101)
                </small>
            </div>
            
            <c:if test="${not empty timestamp}">
                <div class="mt-3">
                    <small class="text-muted">Error occurred at: ${timestamp}</small>
                </div>
            </c:if>
        </div>
    </div>
</body>
</html> 