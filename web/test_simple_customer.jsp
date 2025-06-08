<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Simple Customer Test</title>
</head>
<body>
    <h1>Customer Test Page</h1>
    
    <p><strong>List Size:</strong> ${fn:length(listCustomer)}</p>
    <p><strong>Is Null:</strong> ${listCustomer == null}</p>
    <p><strong>Is Empty:</strong> ${empty listCustomer}</p>
    
    <hr>
    
    <h2>Raw Data Dump:</h2>
    <c:forEach var="customer" items="${listCustomer}" varStatus="status">
        <div style="border: 1px solid #ccc; margin: 10px; padding: 10px;">
            <p><strong>Index:</strong> ${status.index}</p>
            <p><strong>Customer ID:</strong> ${customer.customerId}</p>
            <p><strong>Full Name:</strong> ${customer.fullName}</p>
            <p><strong>Email:</strong> ${customer.email}</p>
            <p><strong>Phone:</strong> ${customer.phoneNumber}</p>
            <p><strong>Gender:</strong> ${customer.gender}</p>
            <p><strong>Address:</strong> ${customer.address}</p>
            <p><strong>Is Active:</strong> ${customer.isActive}</p>
            <p><strong>Loyalty Points:</strong> ${customer.loyaltyPoints}</p>
            <p><strong>Role ID:</strong> ${customer.roleId}</p>
            <p><strong>Created At:</strong> ${customer.createdAt}</p>
            <p><strong>Updated At:</strong> ${customer.updatedAt}</p>
            <p><strong>Birthday:</strong> ${customer.birthday}</p>
        </div>
    </c:forEach>
    
    <c:if test="${empty listCustomer}">
        <p style="color: red;">NO CUSTOMERS FOUND!</p>
    </c:if>
    
    <hr>
    <h2>Simple Table Test:</h2>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
        </tr>
        <c:forEach var="customer" items="${listCustomer}">
            <tr>
                <td>${customer.customerId}</td>
                <td>${customer.fullName}</td>
                <td>${customer.email}</td>
            </tr>
        </c:forEach>
    </table>
    
</body>
</html> 