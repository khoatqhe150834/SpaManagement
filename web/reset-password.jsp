<%-- 
    Document   : reset-password
    Created on : Jun 2, 2025, 10:25:49 AM
    Author     : quang
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Reset password</h1>
        <h2>Email typed : ${email}</h2>
        <h2>OTP : ${OTP}</h2>
        
        <c:if test="${not empty error}">
            <h1>${error}</h1>
        </c:if>
        <c:if test="${not empty message}">
            <h1>${message}</h1>
        </c:if>
        <form action="reset-password" method="POST">
            <h2>Nhap email </h2>
            <label>Email</label>
            <input type="email" name="email" id="email" required="true">
            <input type="submit" value="Gui email" />
        </form>
    </body>
</html>
