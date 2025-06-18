<%-- 
    Document   : view
    Created on : Dec 25, 2024
    Author     : Admin
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Details - Spa Management</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp"></jsp:include>
    <style>
        .customer-avatar {
            width: 180px;
            height: 180px;
            border-radius: 50%;
            border: 4px solid #fff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            object-fit: cover;
        }
        .status-badge {
            position: absolute;
            bottom: 10px;
            right: 10px;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 500;
            font-size: 0.9rem;
        }
        .customer-info-card {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.05);
            padding: 30px;
        }
        .info-label {
            color: #6b7280;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 5px;
        }
        .info-value {
            color: #374151;
            font-size: 1rem;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp"></jsp:include>

    <div class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="page-title">Customer Details</h4>
                <a href="${pageContext.request.contextPath}/customer" class="btn btn-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Back to List
                </a>
            </div>

            <c:if test="${not empty customer}">
                <div class="customer-info-card">
                    <div class="row">
                        <div class="col-md-3 text-center position-relative">
                            <img src="${not empty customer.avatarUrl ? customer.avatarUrl : 'https://placehold.co/180x180/7C3AED/FFFFFF?text='.concat(fn:substring(customer.fullName,0,2))}" 
                                 alt="${customer.fullName}'s Avatar"
                                 class="customer-avatar mb-3">
                            
                            <div class="status-badge ${customer.isActive ? 'bg-success' : 'bg-danger'}">
                                <i class="fas fa-${customer.isActive ? 'check' : 'times'}-circle me-1"></i>
                                ${customer.isActive ? 'Active' : 'Inactive'}
                            </div>
                            
                            <h5 class="mt-3 mb-1">${customer.fullName}</h5>
                            <p class="text-muted mb-0">
                                <i class="fas fa-id-card me-1"></i>ID: #${customer.customerId}
                            </p>
                        </div>

                        <div class="col-md-9">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <div class="info-label">Email</div>
                                        <div class="info-value">
                                            <i class="fas fa-envelope me-2 text-primary"></i>
                                            ${not empty customer.email ? customer.email : 'N/A'}
                                            <c:if test="${customer.isVerified}">
                                                <span class="badge bg-success ms-2">Verified</span>
                                            </c:if>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <div class="info-label">Phone Number</div>
                                        <div class="info-value">
                                            <i class="fas fa-phone me-2 text-primary"></i>
                                            ${customer.phoneNumber}
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <div class="info-label">Gender</div>
                                        <div class="info-value">
                                            <i class="fas fa-${customer.gender == 'FEMALE' ? 'female' : customer.gender == 'MALE' ? 'male' : 'user'} me-2 text-primary"></i>
                                            ${customer.gender}
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <div class="info-label">Birthday</div>
                                        <div class="info-value">
                                            <i class="fas fa-birthday-cake me-2 text-primary"></i>
                                            <fmt:formatDate value="${customer.birthday}" pattern="dd/MM/yyyy"/>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <div class="info-label">Loyalty Points</div>
                                        <div class="info-value">
                                            <i class="fas fa-star me-2 text-warning"></i>
                                            ${customer.loyaltyPoints} points
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <div class="info-label">Member Since</div>
                                        <div class="info-value">
                                            <i class="fas fa-calendar me-2 text-primary"></i>
                                            <fmt:formatDate value="${customer.createdAt}" pattern="dd/MM/yyyy"/>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <div class="mb-3">
                                        <div class="info-label">Address</div>
                                        <div class="info-value">
                                            <i class="fas fa-map-marker-alt me-2 text-primary"></i>
                                            ${not empty customer.address ? customer.address : 'No address provided'}
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="mt-4">
                                <a href="${pageContext.request.contextPath}/customer/edit?id=${customer.customerId}" 
                                   class="btn btn-primary me-2">
                                    <i class="fas fa-edit me-2"></i>Edit Customer
                                </a>
                                <c:if test="${not customer.isActive}">
                                    <a href="${pageContext.request.contextPath}/customer/activate?id=${customer.customerId}" 
                                       class="btn btn-success me-2">
                                        <i class="fas fa-user-check me-2"></i>Activate Account
                                    </a>
                                </c:if>
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
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp"></jsp:include>
</body>
</html> 