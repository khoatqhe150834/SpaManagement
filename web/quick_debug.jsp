<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBContext" %>
<%@ page import="dao.CustomerDAO" %>
<%@ page import="model.Customer" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quick Debug</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .error { color: red; }
        .success { color: green; }
    </style>
</head>
<body>
    <h1>Quick Debug - Customer Data</h1>
    
    <h2>1. Direct Database Query</h2>
    <%
    try {
        Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement("SELECT customer_id, full_name, email, phone_number, gender, address, is_active FROM customers LIMIT 3");
        ResultSet rs = ps.executeQuery();
        
        %>
        <table>
            <tr><th>customer_id</th><th>full_name</th><th>email</th><th>phone_number</th><th>gender</th><th>address</th><th>is_active</th></tr>
        <%
        
        boolean hasData = false;
        while (rs.next()) {
            hasData = true;
            %>
            <tr>
                <td><%= rs.getObject("customer_id") %></td>
                <td><%= rs.getObject("full_name") %></td>
                <td><%= rs.getObject("email") %></td>
                <td><%= rs.getObject("phone_number") %></td>
                <td><%= rs.getObject("gender") %></td>
                <td><%= rs.getObject("address") %></td>
                <td><%= rs.getObject("is_active") %></td>
            </tr>
            <%
        }
        
        if (!hasData) {
            out.println("<tr><td colspan='7' class='error'>NO DATA FOUND IN DATABASE!</td></tr>");
        }
        
        %>
        </table>
        <%
        
        rs.close();
        ps.close();
        conn.close();
        
    } catch (Exception e) {
        out.println("<p class='error'>Database Error: " + e.getMessage() + "</p>");
    }
    %>
    
    <h2>2. DAO Method Test</h2>
    <%
    try {
        CustomerDAO dao = new CustomerDAO();
        List<Customer> customers = dao.findAll();
        
        out.println("<p><strong>DAO findAll() returned:</strong> " + customers.size() + " customers</p>");
        
        if (customers.size() > 0) {
            %>
            <table>
                <tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Gender</th><th>Address</th><th>Active</th></tr>
            <%
            
            for (int i = 0; i < Math.min(3, customers.size()); i++) {
                Customer c = customers.get(i);
                %>
                <tr>
                    <td><%= c.getCustomerId() %></td>
                    <td><%= c.getFullName() %></td>
                    <td><%= c.getEmail() %></td>
                    <td><%= c.getPhoneNumber() %></td>
                    <td><%= c.getGender() %></td>
                    <td><%= c.getAddress() %></td>
                    <td><%= c.getIsActive() %></td>
                </tr>
                <%
            }
            %>
            </table>
            <%
        } else {
            out.println("<p class='error'>DAO returned empty list!</p>");
        }
        
    } catch (Exception e) {
        out.println("<p class='error'>DAO Error: " + e.getMessage() + "</p>");
        e.printStackTrace(new java.io.PrintWriter(out));
    }
    %>
    
    <h2>3. JSP Expression Test</h2>
    <%
    // Simulate what controller does
    try {
        CustomerDAO dao = new CustomerDAO();
        List<Customer> testList = dao.findAll();
        request.setAttribute("testListCustomer", testList);
        
        out.println("<p><strong>Set testListCustomer attribute with " + testList.size() + " customers</strong></p>");
    } catch (Exception e) {
        out.println("<p class='error'>Setup Error: " + e.getMessage() + "</p>");
    }
    %>
    
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    
    <p><strong>JSP EL Test:</strong></p>
    <p>testListCustomer size: ${fn:length(testListCustomer)}</p>
    <p>testListCustomer empty: ${empty testListCustomer}</p>
    
    <c:if test="${not empty testListCustomer}">
        <table>
            <tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th></tr>
            <c:forEach var="customer" items="${testListCustomer}" begin="0" end="2">
                <tr>
                    <td>${customer.customerId}</td>
                    <td>${customer.fullName}</td>
                    <td>${customer.email}</td>
                    <td>${customer.phoneNumber}</td>
                </tr>
            </c:forEach>
        </table>
    </c:if>
    
    <c:if test="${empty testListCustomer}">
        <p class="error">JSP EL shows testListCustomer is empty!</p>
    </c:if>
    
</body>
</html> 