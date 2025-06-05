<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer List</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; font-weight: bold; }
        .active { color: green; font-weight: bold; }
        .inactive { color: red; font-weight: bold; }
        .btn { padding: 5px 10px; margin: 2px; text-decoration: none; border-radius: 3px; }
        .btn-view { background-color: #17a2b8; color: white; }
        .btn-edit { background-color: #28a745; color: white; }
        .btn-delete { background-color: #dc3545; color: white; }
    </style>
</head>
<body>
    <h1>Customer List</h1>
    
    <p><strong>Total Customers:</strong> ${totalCustomers}</p>
    <p><strong>Current Page:</strong> ${currentPage} of ${totalPages}</p>
    <p><strong>Page Size:</strong> ${pageSize}</p>
    
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Gender</th>
                <th>Status</th>
                <th>Created At</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="customer" items="${listCustomer}" varStatus="loop">
                <tr>
                    <td>${customer.customerId}</td>
                    <td><c:out value="${customer.fullName}"/></td>
                    <td><c:out value="${customer.email}"/></td>
                    <td><c:out value="${customer.phoneNumber}"/></td>
                    <td><c:out value="${customer.gender}"/></td>
                    <td>
                        <span class="${customer.isActive ? 'active' : 'inactive'}">
                            ${customer.isActive ? 'Active' : 'Inactive'}
                        </span>
                    </td>
                    <td>${customer.createdAt}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/customer/view?id=${customer.customerId}" class="btn btn-view">View</a>
                        <a href="${pageContext.request.contextPath}/customer/edit?id=${customer.customerId}" class="btn btn-edit">Edit</a>
                        <a href="${pageContext.request.contextPath}/customer/delete?id=${customer.customerId}" class="btn btn-delete" onclick="return confirm('Are you sure?')">Delete</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty listCustomer}">
                <tr>
                    <td colspan="8" style="text-align: center; color: red;">No customers found</td>
                </tr>
            </c:if>
        </tbody>
    </table>
    
    <div style="margin-top: 20px;">
        <c:if test="${currentPage > 1}">
            <a href="${pageContext.request.contextPath}/customer?page=${currentPage - 1}&pageSize=${pageSize}" class="btn btn-view">← Previous</a>
        </c:if>
        
        <c:forEach begin="1" end="${totalPages}" var="i">
            <c:choose>
                <c:when test="${i == currentPage}">
                    <strong>${i}</strong>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/customer?page=${i}&pageSize=${pageSize}" class="btn btn-view">${i}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>
        
        <c:if test="${currentPage < totalPages}">
            <a href="${pageContext.request.contextPath}/customer?page=${currentPage + 1}&pageSize=${pageSize}" class="btn btn-view">Next →</a>
        </c:if>
    </div>
    
</body>
</html> 