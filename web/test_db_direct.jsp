<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBContext" %>
<!DOCTYPE html>
<html>
<head>
    <title>Direct DB Test</title>
</head>
<body>
    <h1>Direct Database Test</h1>
    
    <%
    try {
        Connection conn = DBContext.getConnection();
        out.println("<p><strong>Database connection:</strong> SUCCESS</p>");
        
        // Test customers table
        String sql = "SELECT * FROM customers LIMIT 5";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        
        out.println("<h2>Direct SQL Query Results:</h2>");
        out.println("<table border='1'>");
        out.println("<tr><th>ID</th><th>Full Name</th><th>Email</th><th>Phone</th><th>Gender</th><th>Address</th><th>Active</th></tr>");
        
        int count = 0;
        while (rs.next()) {
            count++;
            out.println("<tr>");
            out.println("<td>" + rs.getInt("customer_id") + "</td>");
            out.println("<td>" + rs.getString("full_name") + "</td>");
            out.println("<td>" + rs.getString("email") + "</td>");
            out.println("<td>" + rs.getString("phone_number") + "</td>");
            out.println("<td>" + rs.getString("gender") + "</td>");
            out.println("<td>" + rs.getString("address") + "</td>");
            out.println("<td>" + rs.getBoolean("is_active") + "</td>");
            out.println("</tr>");
        }
        out.println("</table>");
        out.println("<p><strong>Total rows found:</strong> " + count + "</p>");
        
        // Count total
        sql = "SELECT COUNT(*) FROM customers";
        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();
        if (rs.next()) {
            out.println("<p><strong>Total customers in DB:</strong> " + rs.getInt(1) + "</p>");
        }
        
        rs.close();
        ps.close();
        conn.close();
        
    } catch (Exception e) {
        out.println("<p style='color:red'><strong>Database error:</strong> " + e.getMessage() + "</p>");
        e.printStackTrace(new java.io.PrintWriter(out));
    }
    %>
    
</body>
</html> 