<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, dao.*, model.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Customer Test</title>
</head>
<body>
    <h1>Customer Database Test</h1>
    
    <%
        try {
            CustomerDAO customerDAO = new CustomerDAO();
            
            // Test basic connection
            out.println("<h2>Database Connection Test:</h2>");
            
            // Test findAll method
            List<Customer> allCustomers = customerDAO.findAll();
            out.println("<p>Total customers found: " + allCustomers.size() + "</p>");
            
            if (allCustomers.size() > 0) {
                out.println("<h3>Customer List:</h3>");
                out.println("<ul>");
                for (Customer customer : allCustomers) {
                    out.println("<li>");
                    out.println("ID: " + customer.getCustomerId() + " - ");
                    out.println("Name: " + customer.getFullName() + " - ");
                    out.println("Email: " + customer.getEmail() + " - ");
                    out.println("Active: " + customer.getIsActive());
                    out.println("</li>");
                }
                out.println("</ul>");
            } else {
                out.println("<p style='color: red;'>No customers found in database!</p>");
            }
            
            // Test pagination method
            out.println("<h3>Pagination Test (Page 1, Size 10):</h3>");
            List<Customer> pagedCustomers = customerDAO.findAll(1, 10);
            out.println("<p>Paged customers found: " + pagedCustomers.size() + "</p>");
            
            // Test total count
            int totalCount = customerDAO.getTotalCustomers();
            out.println("<p>Total customer count: " + totalCount + "</p>");
            
        } catch (Exception e) {
            out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
            e.printStackTrace(new java.io.PrintWriter(out));
        }
    %>
    
    <hr>
    <a href="${pageContext.request.contextPath}/customer">Back to Customer List</a>
</body>
</html> 