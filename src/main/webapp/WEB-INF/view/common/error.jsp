<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.StringWriter" %>
<!DOCTYPE html>
<html>
<head>
    <title>Lỗi Hệ Thống</title>
    <meta charset="UTF-8">
    <style>
        body { font-family: Arial, sans-serif; background: #f9f9f9; color: #333; line-height: 1.6; }
        .error-container { margin: 40px auto; max-width: 900px; background: #fff; border: 1px solid #ddd; border-radius: 8px; padding: 32px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        h1 { color: #d32f2f; border-bottom: 2px solid #d32f2f; padding-bottom: 10px; }
        h2 { color: #333; border-bottom: 1px solid #eee; padding-bottom: 8px; margin-top: 30px;}
        pre { background: #2d2d2d; color: #f8f8f2; padding: 20px; border-radius: 4px; white-space: pre-wrap; word-wrap: break-word; font-family: Consolas, 'Courier New', monospace; font-size: 14px; }
        a { color: #1976d2; text-decoration: none; font-weight: bold; }
        a:hover { text-decoration: underline; }
        .warning { background-color: #fff3cd; border: 1px solid #ffeeba; color: #856404; padding: 15px; border-radius: 4px; margin-bottom: 20px; text-align: center; }
        .message { background: #ffebee; border: 1px solid #ef9a9a; padding: 15px; border-radius: 4px; font-weight: bold;}
    </style>
</head>
<body>
    <div class="error-container">
        <div class="warning">
            <strong>Chú ý:</strong> Đây là trang gỡ lỗi chi tiết. Không sử dụng trong môi trường production.
        </div>

        <h1><i class="icon-bug"></i>Đã xảy ra lỗi hệ thống</h1>
        
        <p>
            <a href="${pageContext.request.contextPath}/">Quay về trang chủ</a>
        </p>

        <h2>Thông báo lỗi (Error Message):</h2>
        <pre class="message"><c:out value="${pageContext.exception.message}" default="Không có thông báo lỗi."/></pre>

        <h2>Nguồn gốc lỗi (Stack Trace):</h2>
        <pre><%
            if (exception != null) {
                StringWriter sw = new StringWriter();
                PrintWriter pw = new PrintWriter(sw);
                exception.printStackTrace(pw);
                out.print(sw.toString());
            } else if (request.getAttribute("jakarta.servlet.error.exception") != null) {
                Throwable e = (Throwable) request.getAttribute("jakarta.servlet.error.exception");
                StringWriter sw = new StringWriter();
                PrintWriter pw = new PrintWriter(sw);
                e.printStackTrace(pw);
                out.print(sw.toString());
            }
            else {
                out.print("Không có thông tin exception.");
            }
        %></pre>
    </div>
</body>
</html> 