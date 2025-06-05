<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Basic Test</title>
</head>
<body>
    <h1>Basic Data Test</h1>
    
    <h3>Simple Checks:</h3>
    <p>listCustomer exists: ${listCustomer != null}</p>
    <p>listCustomer empty: ${empty listCustomer}</p>
    
    <c:if test="${listCustomer != null}">
        <p>List size: ${listCustomer.size()}</p>
        
        <h3>Customer Loop Test:</h3>
        <c:forEach var="customer" items="${listCustomer}" varStatus="status" begin="0" end="2">
            <p>Customer ${status.index}: ${customer != null ? 'NOT NULL' : 'NULL'}</p>
        </c:forEach>
    </c:if>
    
    <c:if test="${listCustomer == null}">
        <p style="color: red;">listCustomer is NULL!</p>
    </c:if>
    
    <h3>Other Attributes:</h3>
    <p>currentPage: ${currentPage}</p>
    <p>totalCustomers: ${totalCustomers}</p>
</body>
</html> 