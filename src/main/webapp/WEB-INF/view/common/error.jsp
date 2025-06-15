<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Lỗi Hệ Thống</title>
    <meta charset="UTF-8">
    <style>
        body { font-family: Arial, sans-serif; background: #fff3f3; color: #b71c1c; }
        .error-container { margin: 100px auto; max-width: 500px; background: #fff; border: 1px solid #f8bbd0; border-radius: 8px; padding: 32px; text-align: center; }
        h1 { color: #b71c1c; }
        a { color: #1976d2; text-decoration: none; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>Đã xảy ra lỗi!</h1>
        <p>
            <c:out value="${error}" default="Trang bạn yêu cầu không tồn tại hoặc đã xảy ra lỗi hệ thống."/>
        </p>
        <a href="${pageContext.request.contextPath}/">Quay về trang chủ</a>
    </div>
</body>
</html> 