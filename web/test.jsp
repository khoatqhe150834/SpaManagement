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
        <h1>${customerId}</h1>
    </body>
</html>