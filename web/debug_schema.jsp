<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBContext" %>
<!DOCTYPE html>
<html>
<head>
    <title>Database Schema Debug</title>
</head>
<body>
    <h1>Database Schema Check</h1>
    
    <%
    try {
        Connection conn = DBContext.getConnection();
        out.println("<p><strong>Database connection:</strong> SUCCESS</p>");
        
        // Check table structure
        DatabaseMetaData meta = conn.getMetaData();
        ResultSet columns = meta.getColumns(null, null, "customers", null);
        
        out.println("<h2>Customers Table Schema:</h2>");
        out.println("<table border='1'>");
        out.println("<tr><th>Column Name</th><th>Data Type</th><th>Size</th><th>Nullable</th></tr>");
        
        while (columns.next()) {
            String columnName = columns.getString("COLUMN_NAME");
            String dataType = columns.getString("TYPE_NAME");
            int size = columns.getInt("COLUMN_SIZE");
            String nullable = columns.getString("IS_NULLABLE");
            
            out.println("<tr>");
            out.println("<td>" + columnName + "</td>");
            out.println("<td>" + dataType + "</td>");
            out.println("<td>" + size + "</td>");
            out.println("<td>" + nullable + "</td>");
            out.println("</tr>");
        }
        out.println("</table>");
        
        // Show actual data with column names
        out.println("<h2>Raw Data Sample (First Row):</h2>");
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM customers LIMIT 1");
        ResultSet rs = ps.executeQuery();
        ResultSetMetaData rsmd = rs.getMetaData();
        
        if (rs.next()) {
            out.println("<table border='1'>");
            out.println("<tr><th>Column Name</th><th>Value</th><th>Java Type</th></tr>");
            
            for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                String columnName = rsmd.getColumnName(i);
                Object value = rs.getObject(i);
                String javaType = value != null ? value.getClass().getSimpleName() : "null";
                
                out.println("<tr>");
                out.println("<td><strong>" + columnName + "</strong></td>");
                out.println("<td>" + value + "</td>");
                out.println("<td>" + javaType + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        } else {
            out.println("<p style='color:red'>No data found in customers table!</p>");
        }
        
        rs.close();
        ps.close();
        columns.close();
        conn.close();
        
    } catch (Exception e) {
        out.println("<p style='color:red'><strong>Error:</strong> " + e.getMessage() + "</p>");
        e.printStackTrace(new java.io.PrintWriter(out));
    }
    %>
    
</body>
</html> 