<%-- Document : test Created on : May 25, 2025, 9:30:00 PM Author : quang --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>JSP Page</title>
  </head>
  <body>
   
      <c:forEach items="${listCustomer}" var="c">
          <h1>Full name : ${c.fullName}</h1>
      </c:forEach>
  </body>
</html>
