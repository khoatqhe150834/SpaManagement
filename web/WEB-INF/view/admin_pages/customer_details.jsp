<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Details</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <div class="card">
            <div class="card-header">
                <h3>Customer Details</h3>
            </div>
            <div class="card-body">
                <c:if test="${not empty customer}">
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>Full Name:</strong> <c:out value="${customer.fullName}"/></p>
                            <p><strong>Email:</strong> <c:out value="${customer.email}"/></p>
                            <p><strong>Phone Number:</strong> <c:out value="${customer.phoneNumber}"/></p>
                            <p><strong>Gender:</strong> <c:out value="${customer.gender}"/></p>
                            <p><strong>Birthday:</strong> <c:out value="${customer.birthday}"/></p>
                            <p><strong>Address:</strong> <c:out value="${customer.address}"/></p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>Account Status:</strong> 
                                <c:if test="${customer.active}">
                                    <span class="badge bg-success">Active</span>
                                </c:if>
                                <c:if test="${not customer.active}">
                                    <span class="badge bg-danger">Inactive</span>
                                </c:if>
                            </p>
                            <p><strong>Verified Status:</strong> 
                                <c:if test="${customer.verified}">
                                    <span class="badge bg-info">Verified</span>
                                </c:if>
                                <c:if test="${not customer.verified}">
                                    <span class="badge bg-secondary">Not Verified</span>
                                </c:if>
                            </p>
                            <p><strong>Loyalty Points:</strong> <c:out value="${customer.loyaltyPoints}"/></p>
                            <p><strong>Created At:</strong> <c:out value="${customer.createdAt}"/></p>
                            <p><strong>Last Updated:</strong> <c:out value="${customer.updatedAt}"/></p>
                        </div>
                    </div>
                </c:if>
                <c:if test="${empty customer}">
                    <div class="alert alert-warning" role="alert">
                      Customer not found.
                    </div>
                </c:if>
            </div>
            <div class="card-footer">
                <a href="${pageContext.request.contextPath}/customer/list" class="btn btn-primary">Back to List</a>
            </div>
        </div>
    </div>
</body>
</html>
