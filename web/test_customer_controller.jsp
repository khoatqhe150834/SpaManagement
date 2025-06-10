<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.CustomerDAO" %>
<%@ page import="model.Customer" %>
<%@ page import="java.util.List" %>

<html>
<head>
    <title>Customer Controller Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        .debug { background: #f5f5f5; padding: 10px; margin: 10px 0; border-left: 3px solid #ccc; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>

<h1>🧪 Customer Controller Test</h1>

<div class="debug">
    <h3>Request Attributes Debug:</h3>
    <p><strong>customers attribute:</strong> ${customers != null ? 'EXISTS' : 'NULL'}</p>
    <p><strong>customers empty:</strong> ${empty customers}</p>
    <c:if test="${customers != null}">
        <p><strong>customers size:</strong> ${customers.size()}</p>
    </c:if>
    <p><strong>currentPage:</strong> ${currentPage}</p>
    <p><strong>pageSize:</strong> ${pageSize}</p>
    <p><strong>totalpages:</strong> ${totalpages}</p>
    <p><strong>totalCustomers:</strong> ${totalCustomers}</p>
</div>

<div class="debug">
    <h3>Direct DAO Test:</h3>
    <%
        try {
            CustomerDAO dao = new CustomerDAO();
            List<Customer> directCustomers = dao.findAll(1, 5);
            request.setAttribute("directCustomers", directCustomers);
            int total = dao.getTotalCustomers();
            request.setAttribute("directTotal", total);
    %>
            <p class="success">✓ Direct DAO call successful!</p>
            <p><strong>Direct customers found:</strong> ${directCustomers.size()}</p>
            <p><strong>Direct total count:</strong> ${directTotal}</p>
    <%
        } catch (Exception e) {
    %>
            <p class="error">✗ Direct DAO call failed: <%= e.getMessage() %></p>
    <%
        }
    %>
</div>

<h3>Controller vs Direct Comparison:</h3>
<div class="debug">
    <p><strong>Controller customers:</strong> ${customers != null ? customers.size() : 'NULL'}</p>
    <p><strong>Direct DAO customers:</strong> ${directCustomers != null ? directCustomers.size() : 'NULL'}</p>
</div>

<c:if test="${customers != null && customers.size() > 0}">
    <h3>✓ Customers from Controller:</h3>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="customer" items="${customers}" varStatus="loop">
                <tr>
                    <td>${customer.customerId}</td>
                    <td>${customer.fullName}</td>
                    <td>${customer.email}</td>
                    <td>${customer.phoneNumber}</td>
                    <td>${customer.isActive ? 'Active' : 'Inactive'}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</c:if>

<c:if test="${directCustomers != null && directCustomers.size() > 0}">
    <h3>✓ Customers from Direct DAO:</h3>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="customer" items="${directCustomers}" varStatus="loop">
                <tr>
                    <td>${customer.customerId}</td>
                    <td>${customer.fullName}</td>
                    <td>${customer.email}</td>
                    <td>${customer.phoneNumber}</td>
                    <td>${customer.isActive ? 'Active' : 'Inactive'}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</c:if>

<div style="margin-top: 30px; padding: 15px; background: #e8f5e8; border-radius: 5px;">
    <h3>🔧 Test URLs:</h3>
    <ul>
        <li><a href="${pageContext.request.contextPath}/customer/list" target="_blank">Test Controller: /customer/list</a></li>
        <li><a href="${pageContext.request.contextPath}/customer" target="_blank">Test Controller: /customer</a></li>
        <li><a href="${pageContext.request.contextPath}/customer?action=list" target="_blank">Test Controller: /customer?action=list</a></li>
    </ul>
    <p><strong>Current URL:</strong> <%= request.getRequestURL() %></p>
    <p><strong>Context Path:</strong> <%= request.getContextPath() %></p>
</div>

</body>
</html> 