<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Property Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .test { background-color: #f0f0f0; padding: 10px; margin: 5px 0; }
        .success { color: green; }
        .error { color: red; }
    </style>
</head>
<body>
    <h1>Customer Property Access Test</h1>
    
    <c:if test="${listCustomer != null && listCustomer.size() > 0}">
        <c:set var="firstCustomer" value="${listCustomer[0]}" />
        
        <h3>Testing First Customer Properties:</h3>
        
        <div class="test">
            <strong>Customer Object:</strong> ${firstCustomer != null ? 'EXISTS' : 'NULL'}
        </div>
        
        <div class="test">
            <strong>Customer ID:</strong> 
            <c:choose>
                <c:when test="${firstCustomer.customerId != null}">
                    <span class="success">${firstCustomer.customerId}</span>
                </c:when>
                <c:otherwise><span class="error">NULL</span></c:otherwise>
            </c:choose>
        </div>
        
        <div class="test">
            <strong>Full Name:</strong> 
            <c:choose>
                <c:when test="${firstCustomer.fullName != null}">
                    <span class="success">"${firstCustomer.fullName}"</span>
                </c:when>
                <c:otherwise><span class="error">NULL</span></c:otherwise>
            </c:choose>
        </div>
        
        <div class="test">
            <strong>Email:</strong> 
            <c:choose>
                <c:when test="${firstCustomer.email != null}">
                    <span class="success">"${firstCustomer.email}"</span>
                </c:when>
                <c:otherwise><span class="error">NULL</span></c:otherwise>
            </c:choose>
        </div>
        
        <div class="test">
            <strong>Phone Number:</strong> 
            <c:choose>
                <c:when test="${firstCustomer.phoneNumber != null}">
                    <span class="success">"${firstCustomer.phoneNumber}"</span>
                </c:when>
                <c:otherwise><span class="error">NULL</span></c:otherwise>
            </c:choose>
        </div>
        
        <div class="test">
            <strong>Gender:</strong> 
            <c:choose>
                <c:when test="${firstCustomer.gender != null}">
                    <span class="success">"${firstCustomer.gender}"</span>
                </c:when>
                <c:otherwise><span class="error">NULL</span></c:otherwise>
            </c:choose>
        </div>
        
        <div class="test">
            <strong>Is Active:</strong> 
            <c:choose>
                <c:when test="${firstCustomer.isActive != null}">
                    <span class="success">${firstCustomer.isActive}</span>
                </c:when>
                <c:otherwise><span class="error">NULL</span></c:otherwise>
            </c:choose>
        </div>
        
        <div class="test">
            <strong>Created At:</strong> 
            <c:choose>
                <c:when test="${firstCustomer.createdAt != null}">
                    <span class="success">${firstCustomer.createdAt}</span>
                </c:when>
                <c:otherwise><span class="error">NULL</span></c:otherwise>
            </c:choose>
        </div>
        
        <div class="test">
            <strong>toString():</strong> 
            <code>${firstCustomer}</code>
        </div>
        
        <h3>Testing Multiple Customers:</h3>
        <c:forEach var="customer" items="${listCustomer}" varStatus="status" begin="0" end="2">
            <div class="test">
                <strong>Customer ${status.index + 1}:</strong> 
                ID=${customer.customerId}, 
                Name="${customer.fullName}", 
                Email="${customer.email}"
            </div>
        </c:forEach>
        
    </c:if>
    
    <c:if test="${listCustomer == null || listCustomer.size() == 0}">
        <p class="error">No customers to test!</p>
    </c:if>
    
    <p><a href="${pageContext.request.contextPath}/customer">← Back</a></p>
</body>
</html> 