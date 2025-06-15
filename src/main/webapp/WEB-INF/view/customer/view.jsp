<%-- 
    Document   : view
    Created on : Dec 25, 2024
    Author     : Admin
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Details - Spa Management</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp"></jsp:include>
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp"></jsp:include>

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Customer Details</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/customer" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Back to Customer List
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Customer Profile</li>
            </ul>
        </div>

        <c:if test="${not empty customer}">
            <div class="card h-100 p-0 radius-12">
                <div class="card-body p-24">
                    <div class="row justify-content-center">
                        <div class="col-xxl-8 col-xl-10 col-lg-12">
                            <div class="card border">
                                <div class="card-body">
                                    <div class="customer-details">
                                        <div class="row">
                                            <!-- Customer Profile Image -->
                                            <div class="col-md-3 text-center">
                                                <img src="${pageContext.request.contextPath}/assets/images/avatar.png" 
                                                     alt="Customer Avatar" 
                                                     class="img-fluid rounded-circle w-150px h-150px">
                                                <br><br>
                                                <span class="badge bg-${customer.isActive ? 'success-focus text-success-600' : 'neutral-200 text-neutral-600'} px-16 py-8 radius-8 fw-medium">
                                                    ${customer.isActive ? 'Active' : 'Inactive'}
                                                </span>
                                            </div>
                                            
                                            <!-- Customer Information -->
                                            <div class="col-md-9">
                                                <h5 class="text-primary-600 mb-3">
                                                    <c:out value="${customer.fullName}" default="Unknown"/>
                                                </h5>
                                                
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <p><strong>Customer ID:</strong> #${customer.customerId}</p>
                                                        <p><strong>Email:</strong> <c:out value="${customer.email}" default="N/A"/></p>
                                                        <p><strong>Phone:</strong> <c:out value="${customer.phoneNumber}" default="N/A"/></p>
                                                        <p><strong>Gender:</strong> 
                                                            <c:choose>
                                                                <c:when test="${customer.gender == 'MALE'}">Male</c:when>
                                                                <c:when test="${customer.gender == 'FEMALE'}">Female</c:when>
                                                                <c:when test="${customer.gender == 'OTHER'}">Other</c:when>
                                                                <c:otherwise>Not specified</c:otherwise>
                                                            </c:choose>
                                                        </p>
                                                    </div>
                                                    
                                                    <div class="col-md-6">
                                                        <p><strong>Birthday:</strong> 
                                                            <c:choose>
                                                                <c:when test="${not empty customer.birthday}">
                                                                    <fmt:formatDate value="${customer.birthday}" pattern="dd/MM/yyyy"/>
                                                                </c:when>
                                                                <c:otherwise>Not provided</c:otherwise>
                                                            </c:choose>
                                                        </p>
                                                        <p><strong>Loyalty Points:</strong> ${customer.loyaltyPoints} points</p>
                                                        <p><strong>Verified:</strong> ${customer.isVerified ? 'Yes' : 'No'}</p>
                                                        <p><strong>Status:</strong> 
                                                            <span class="text-${customer.isActive ? 'success' : 'danger'}">
                                                                ${customer.isActive ? 'Active' : 'Inactive'}
                                                            </span>
                                                        </p>
                                                    </div>
                                                </div>
                                                
                                                <div class="row">
                                                    <div class="col-12">
                                                        <p><strong>Address:</strong> 
                                                            <c:out value="${customer.address}" default="Not provided"/>
                                                        </p>
                                                    </div>
                                                </div>
                                                
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <p><strong>Created At:</strong> 
                                                            <c:choose>
                                                                <c:when test="${not empty customer.createdAt}">
                                                                    <fmt:formatDate value="${customer.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                                </c:when>
                                                                <c:otherwise>Unknown</c:otherwise>
                                                            </c:choose>
                                                        </p>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <p><strong>Last Updated:</strong> 
                                                            <c:choose>
                                                                <c:when test="${not empty customer.updatedAt}">
                                                                    <fmt:formatDate value="${customer.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                                </c:when>
                                                                <c:otherwise>Never updated</c:otherwise>
                                                            </c:choose>
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="mt-4">
                                            <a href="${pageContext.request.contextPath}/customer/edit?id=${customer.customerId}" 
                                               class="btn btn-warning">Edit Customer</a>
                                            <a href="${pageContext.request.contextPath}/customer" 
                                               class="btn btn-secondary">Back to Customer List</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <c:if test="${empty customer}">
            <div class="card h-100 p-0 radius-12">
                <div class="card-body p-24">
                    <div class="text-center py-48">
                        <div style="font-size: 64px;">❌</div>
                        <h6 class="text-neutral-600 mb-8 mt-3">Customer Not Found</h6>
                        <p class="text-neutral-400 text-sm mb-24">The customer you are looking for does not exist or has been deleted.</p>
                        <a href="${pageContext.request.contextPath}/customer" 
                           class="btn btn-primary btn-sm px-20 py-11 radius-8">
                            Back to Customer List
                        </a>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp"></jsp:include>
</body>
</html> 