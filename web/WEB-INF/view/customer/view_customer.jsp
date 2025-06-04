<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Details</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #333;
        }
        .customer-info {
            margin-bottom: 20px;
        }
        .customer-info p {
            margin: 10px 0;
            font-size: 16px;
        }
        .customer-info strong {
            display: inline-block;
            width: 150px;
        }
        .back-button {
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
            text-align: center;
        }
        .back-button:hover {
            background-color: #0056b3;
        }
        .error {
            color: red;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Customer Details</h1>

        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>

        <c:if test="${not empty customer}">
            <div class="customer-info">
                <p><strong>ID:</strong> ${customer.id}</p>
                <p><strong>Full Name:</strong> ${customer.fullName}</p>
                <p><strong>Email:</strong> ${customer.email}</p>
                <p><strong>Phone Number:</strong> ${customer.phoneNumber != null ? customer.phoneNumber : 'N/A'}</p>
                <p><strong>Gender:</strong> ${customer.gender != null ? customer.gender : 'N/A'}</p>
                <p><strong>Birthday:</strong> 
                    <c:choose>
                        <c:when test="${customer.birthday != null}">
                            <fmt:formatDate value="${customer.birthday}" pattern="dd/MM/yyyy"/>
                        </c:when>
                        <c:otherwise>N/A</c:otherwise>
                    </c:choose>
                </p>
                <p><strong>Address:</strong> ${customer.address != null ? customer.address : 'N/A'}</p>
                <p><strong>Active:</strong> ${customer.isActive ? 'Yes' : 'No'}</p>
                <p><strong>Loyalty Points:</strong> ${customer.loyaltyPoints}</p>
                <p><strong>Role ID:</strong> ${customer.roleId}</p>
                <p><strong>Created At:</strong> 
                    <c:choose>
                        <c:when test="${customer.createdAt != null}">
                            <fmt:formatDate value="${customer.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                        </c:when>
                        <c:otherwise>N/A</c:otherwise>
                    </c:choose>
                </p>
                <p><strong>Updated At:</strong> 
                    <c:choose>
                        <c:when test="${customer.updatedAt != null}">
                            <fmt:formatDate value="${customer.updatedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                        </c:when>
                        <c:otherwise>N/A</c:otherwise>
                    </c:choose>
                </p>
            </div>
        </c:if>

        <a href="${pageContext.request.contextPath}/customer" class="back-button">Back to Customer List</a>
    </div>
</body>
</html>