<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="dao.ServiceDAO, model.Service, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test Most Purchased Services</title>
</head>
<body>
    <h1>Test Most Purchased Services</h1>
    
    <%
        try {
            ServiceDAO serviceDAO = new ServiceDAO();
            
            // Test getMostPurchasedServicesWithImages
            out.println("<h2>getMostPurchasedServicesWithImages(10):</h2>");
            List<Service> mostPurchased = serviceDAO.getMostPurchasedServicesWithImages(10);
            out.println("<p>Found " + mostPurchased.size() + " services</p>");
            
            for (Service service : mostPurchased) {
                out.println("<div style='border: 1px solid #ccc; margin: 10px; padding: 10px;'>");
                out.println("<h3>" + service.getName() + "</h3>");
                out.println("<p>ID: " + service.getServiceId() + "</p>");
                out.println("<p>Price: " + service.getPrice() + "</p>");
                out.println("<p>Purchase Count: " + service.getPurchaseCount() + "</p>");
                out.println("<p>Average Rating: " + service.getAverageRating() + "</p>");
                out.println("<p>Service Type: " + (service.getServiceTypeId() != null ? service.getServiceTypeId().getName() : "N/A") + "</p>");
                out.println("</div>");
            }
            
            // Test regular findAll
            out.println("<h2>All Active Services (first 5):</h2>");
            List<Service> allServices = serviceDAO.findAll();
            out.println("<p>Total active services: " + allServices.size() + "</p>");
            
            int count = 0;
            for (Service service : allServices) {
                if (count >= 5) break;
                out.println("<div style='border: 1px solid #ddd; margin: 5px; padding: 5px;'>");
                out.println("<p>" + service.getServiceId() + ". " + service.getName() + " - " + service.getPrice() + "</p>");
                out.println("</div>");
                count++;
            }
            
        } catch (Exception e) {
            out.println("<h2>Error:</h2>");
            out.println("<pre>" + e.getMessage() + "</pre>");
            e.printStackTrace();
        }
    %>
    
    <hr>
    <h2>Test API Call</h2>
    <button onclick="testApi()">Test /api/most-purchased</button>
    <div id="api-result"></div>
    
    <script>
        async function testApi() {
            try {
                const response = await fetch('/spa/api/most-purchased?limit=5');
                const data = await response.json();
                document.getElementById('api-result').innerHTML = '<pre>' + JSON.stringify(data, null, 2) + '</pre>';
            } catch (error) {
                document.getElementById('api-result').innerHTML = '<pre>Error: ' + error.message + '</pre>';
            }
        }
    </script>
</body>
</html> 