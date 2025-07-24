<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.CustomerDAO" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đồng bộ điểm thưởng</title>
</head>
<body>
    <h1>Đồng bộ điểm thưởng cho tất cả khách hàng</h1>
    
    <%
    if (request.getParameter("sync") != null) {
        try {
            CustomerDAO customerDAO = new CustomerDAO();
            customerDAO.syncAllLoyaltyPointsFromCustomerPoints();
            out.println("<p style='color: green;'>✅ Đã đồng bộ điểm thưởng thành công!</p>");
        } catch (Exception e) {
            out.println("<p style='color: red;'>❌ Lỗi: " + e.getMessage() + "</p>");
        }
    }
    %>
    
    <form method="post">
        <button type="submit" name="sync" value="1" style="padding: 10px 20px; background: blue; color: white; border: none; cursor: pointer;">
            Đồng bộ điểm thưởng
        </button>
    </form>
    
    <p><a href="javascript:history.back()">← Quay lại</a></p>
</body>
</html> 