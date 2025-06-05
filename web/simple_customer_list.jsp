<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Simple Customer List</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .debug { background-color: #e7f3ff; padding: 10px; margin: 10px 0; }
    </style>
</head>
<body>
    <h1>Simple Customer List Test</h1>
    
    <div class="debug">
        <h3>Debug Information:</h3>
        <p><strong>listCustomer is null:</strong> ${listCustomer == null}</p>
        <p><strong>listCustomer is empty:</strong> ${empty listCustomer}</p>
        <p><strong>listCustomer size:</strong> ${listCustomer.size()}</p>
        <p><strong>currentPage:</strong> ${currentPage}</p>
        <p><strong>pageSize:</strong> ${pageSize}</p>
        <p><strong>totalCustomers:</strong> ${totalCustomers}</p>
        <p><strong>totalPages:</strong> ${totalPages}</p>
    </div>

    <h3>Customer Data:</h3>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Gender</th>
                <th>Active</th>
                <th>Created At</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="customer" items="${listCustomer}" varStatus="status">
                <tr>
                    <td>
                        <c:choose>
                            <c:when test="${customer != null && customer.customerId != null}">
                                ${customer.customerId}
                            </c:when>
                            <c:otherwise><em style="color: red;">NULL</em></c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty customer.fullName}">
                                <c:out value="${customer.fullName}"/>
                            </c:when>
                            <c:otherwise><em style="color: red;">NULL or EMPTY</em></c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty customer.email}">
                                <c:out value="${customer.email}"/>
                            </c:when>
                            <c:otherwise><em style="color: red;">NULL or EMPTY</em></c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty customer.phoneNumber}">
                                <c:out value="${customer.phoneNumber}"/>
                            </c:when>
                            <c:otherwise><em style="color: red;">NULL or EMPTY</em></c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty customer.gender}">
                                <c:out value="${customer.gender}"/>
                            </c:when>
                            <c:otherwise><em style="color: red;">NULL or EMPTY</em></c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${customer.isActive != null}">
                                ${customer.isActive ? 'Active' : 'Inactive'}
                            </c:when>
                            <c:otherwise><em style="color: red;">NULL</em></c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${customer.createdAt != null}">
                                <fmt:formatDate value="${customer.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </c:when>
                            <c:otherwise><em style="color: red;">NULL</em></c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <!-- Debug: Customer object toString: ${customer} -->
            </c:forEach>
            
            <c:if test="${empty listCustomer}">
                <tr>
                    <td colspan="7" style="text-align: center; color: red; font-weight: bold;">
                        NO CUSTOMERS FOUND
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>
    
    <h3>Raw Data Test:</h3>
    <div class="debug">
        <h4>Customer List Contents:</h4>
        <c:choose>
            <c:when test="${listCustomer != null}">
                <c:forEach var="customer" items="${listCustomer}" varStatus="status">
                    <p><strong>Customer ${status.index + 1}:</strong></p>
                    <c:choose>
                        <c:when test="${customer != null}">
                            <ul>
                                <li>Customer ID: <code>${customer.customerId}</code></li>
                                <li>Full Name: <code>"${customer.fullName}"</code></li>
                                <li>Email: <code>"${customer.email}"</code></li>
                                <li>Phone: <code>"${customer.phoneNumber}"</code></li>
                                <li>Gender: <code>"${customer.gender}"</code></li>
                                <li>Is Active: <code>${customer.isActive}</code></li>
                                <li>Created At: <code>${customer.createdAt}</code></li>
                                <li>Object toString: <code>${customer}</code></li>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <p style="color: red;">Customer object is NULL</p>
                        </c:otherwise>
                    </c:choose>
                    <hr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p style="color: red; font-weight: bold;">listCustomer is NULL</p>
            </c:otherwise>
        </c:choose>
    </div>
    
    <p><a href="${pageContext.request.contextPath}/customer">← Back to Original Customer List</a></p>
</body>
</html> 