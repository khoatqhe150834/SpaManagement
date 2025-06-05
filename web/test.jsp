<%-- 
    Document   : test
    Created on : Jun 5, 2025, 10:17:45 AM
    Author     : quang
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dao.CustomerDAO" %>
<%@ page import="model.Customer" %>
<%@ page import="java.util.List" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Customer Test Page</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 20px; }
            .error { color: red; }
            .success { color: green; }
        </style>
    </head>
    <body>
        <h1>Customer Full Names Test</h1>
        
        <%
            try {
                CustomerDAO customerDAO = new CustomerDAO();
                List<Customer> customers = customerDAO.findAll(1, 10);
                
                out.println("<div class='success'>");
                out.println("<h3>✓ Found " + customers.size() + " customers:</h3>");
                out.println("<ol>");
                
                for (Customer customer : customers) {
                    String fullName = customer.getFullName();
                    if (fullName != null && !fullName.trim().isEmpty()) {
                        out.println("<li>" + fullName + "</li>");
                    } else {
                        out.println("<li>Customer ID: " + customer.getCustomerId() + " (No name)</li>");
                    }
                }
                
                out.println("</ol>");
                out.println("</div>");
                
            } catch (Exception e) {
                out.println("<div class='error'>");
                out.println("<h3>Error:</h3>");
                out.println("<p>" + e.getMessage() + "</p>");
                out.println("</div>");
            }
        %>
        
        <hr>
        <p><a href="<%= request.getContextPath() %>/test.jsp">Reload Test</a></p>
    </body>
</html>