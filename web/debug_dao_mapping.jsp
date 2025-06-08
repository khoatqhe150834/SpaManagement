<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBContext" %>
<%@ page import="model.Customer" %>
<%@ page import="dao.CustomerDAO" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>DAO Mapping Debug</title>
</head>
<body>
    <h1>DAO Mapping Debug</h1>
    
    <%
    try {
        out.println("<h2>Step 1: Raw SQL Query</h2>");
        Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM customers LIMIT 3");
        ResultSet rs = ps.executeQuery();
        
        out.println("<table border='1'>");
        out.println("<tr><th>customer_id</th><th>full_name</th><th>email</th><th>phone_number</th><th>gender</th><th>address</th><th>is_active</th></tr>");
        
        while (rs.next()) {
            out.println("<tr>");
            out.println("<td>" + rs.getObject("customer_id") + "</td>");
            out.println("<td>" + rs.getObject("full_name") + "</td>");
            out.println("<td>" + rs.getObject("email") + "</td>");
            out.println("<td>" + rs.getObject("phone_number") + "</td>");
            out.println("<td>" + rs.getObject("gender") + "</td>");
            out.println("<td>" + rs.getObject("address") + "</td>");
            out.println("<td>" + rs.getObject("is_active") + "</td>");
            out.println("</tr>");
        }
        out.println("</table>");
        rs.close();
        ps.close();
        conn.close();
        
        out.println("<h2>Step 2: DAO Method Test</h2>");
        CustomerDAO dao = new CustomerDAO();
        List<Customer> customers = dao.findAll();
        
        out.println("<p><strong>DAO returned:</strong> " + customers.size() + " customers</p>");
        
        if (customers.size() > 0) {
            Customer first = customers.get(0);
            out.println("<h3>First Customer Object:</h3>");
            out.println("<table border='1'>");
            out.println("<tr><th>Java Property</th><th>Value</th><th>Type</th></tr>");
            
            out.println("<tr><td>customerId</td><td>" + first.getCustomerId() + "</td><td>" + (first.getCustomerId() != null ? first.getCustomerId().getClass().getSimpleName() : "null") + "</td></tr>");
            out.println("<tr><td>fullName</td><td>" + first.getFullName() + "</td><td>" + (first.getFullName() != null ? first.getFullName().getClass().getSimpleName() : "null") + "</td></tr>");
            out.println("<tr><td>email</td><td>" + first.getEmail() + "</td><td>" + (first.getEmail() != null ? first.getEmail().getClass().getSimpleName() : "null") + "</td></tr>");
            out.println("<tr><td>phoneNumber</td><td>" + first.getPhoneNumber() + "</td><td>" + (first.getPhoneNumber() != null ? first.getPhoneNumber().getClass().getSimpleName() : "null") + "</td></tr>");
            out.println("<tr><td>gender</td><td>" + first.getGender() + "</td><td>" + (first.getGender() != null ? first.getGender().getClass().getSimpleName() : "null") + "</td></tr>");
            out.println("<tr><td>address</td><td>" + first.getAddress() + "</td><td>" + (first.getAddress() != null ? first.getAddress().getClass().getSimpleName() : "null") + "</td></tr>");
            out.println("<tr><td>isActive</td><td>" + first.getIsActive() + "</td><td>" + (first.getIsActive() != null ? first.getIsActive().getClass().getSimpleName() : "null") + "</td></tr>");
            out.println("<tr><td>loyaltyPoints</td><td>" + first.getLoyaltyPoints() + "</td><td>" + (first.getLoyaltyPoints() != null ? first.getLoyaltyPoints().getClass().getSimpleName() : "null") + "</td></tr>");
            out.println("<tr><td>roleId</td><td>" + first.getRoleId() + "</td><td>" + (first.getRoleId() != null ? first.getRoleId().getClass().getSimpleName() : "null") + "</td></tr>");
            out.println("<tr><td>createdAt</td><td>" + first.getCreatedAt() + "</td><td>" + (first.getCreatedAt() != null ? first.getCreatedAt().getClass().getSimpleName() : "null") + "</td></tr>");
            out.println("<tr><td>updatedAt</td><td>" + first.getUpdatedAt() + "</td><td>" + (first.getUpdatedAt() != null ? first.getUpdatedAt().getClass().getSimpleName() : "null") + "</td></tr>");
            out.println("<tr><td>birthday</td><td>" + first.getBirthday() + "</td><td>" + (first.getBirthday() != null ? first.getBirthday().getClass().getSimpleName() : "null") + "</td></tr>");
            
            out.println("</table>");
            
            out.println("<h3>Customer toString():</h3>");
            out.println("<p>" + first.toString() + "</p>");
        }
        
    } catch (Exception e) {
        out.println("<p style='color:red'><strong>Error:</strong> " + e.getMessage() + "</p>");
        e.printStackTrace(new java.io.PrintWriter(out));
    }
    %>
    
</body>
</html> 