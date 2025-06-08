<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="dao.CustomerDAO" %>
<%@ page import="model.Customer" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Controller Test</title>
</head>
<body>
    <h1>Controller DAO Test</h1>
    
    <%
    try {
        CustomerDAO dao = new CustomerDAO();
        
        // Test DAO methods
        out.println("<h2>DAO Test Results:</h2>");
        
        // Test findAll()
        List<Customer> customers = dao.findAll();
        out.println("<p><strong>DAO findAll() returned:</strong> " + customers.size() + " customers</p>");
        
        // Test getTotalCustomers()
        int total = dao.getTotalCustomers();
        out.println("<p><strong>DAO getTotalCustomers():</strong> " + total + "</p>");
        
        // Test findAll(page, size)
        List<Customer> pageCustomers = dao.findAll(1, 10);
        out.println("<p><strong>DAO findAll(1, 10):</strong> " + pageCustomers.size() + " customers</p>");
        
        // Display first few customers details
        out.println("<h3>First 3 customers details:</h3>");
        out.println("<table border='1'>");
        out.println("<tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Gender</th><th>Active</th></tr>");
        
        for (int i = 0; i < Math.min(3, customers.size()); i++) {
            Customer c = customers.get(i);
            out.println("<tr>");
            out.println("<td>" + c.getCustomerId() + "</td>");
            out.println("<td>" + c.getFullName() + "</td>");
            out.println("<td>" + c.getEmail() + "</td>");
            out.println("<td>" + c.getPhoneNumber() + "</td>");
            out.println("<td>" + c.getGender() + "</td>");
            out.println("<td>" + c.getIsActive() + "</td>");
            out.println("</tr>");
        }
        out.println("</table>");
        
    } catch (Exception e) {
        out.println("<p style='color:red'><strong>DAO error:</strong> " + e.getMessage() + "</p>");
        e.printStackTrace(new java.io.PrintWriter(out));
    }
    %>
    
</body>
</html> 