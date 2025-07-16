<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title><c:choose><c:when test="${formAction eq 'edit'}">Sửa nhà cung cấp</c:when><c:otherwise>Thêm nhà cung cấp mới</c:otherwise></c:choose></title>
</head>
<body>
<h2><c:choose><c:when test="${formAction eq 'edit'}">Sửa nhà cung cấp</c:when><c:otherwise>Thêm nhà cung cấp mới</c:otherwise></c:choose></h2>
<form method="post" action="<c:choose><c:when test='${formAction eq "edit"}'>edit?id=${supplier.supplierId}</c:when><c:otherwise>create</c:otherwise></c:choose>">
    <label>Tên nhà cung cấp: <input type="text" name="name" value="${supplier.name}" required /></label><br/>
    <label>Liên hệ: <input type="text" name="contactInfo" value="${supplier.contactInfo}" /></label><br/>
    <button type="submit">Lưu</button>
    <a href="../supplier">Quay lại</a>
</form>
</body>
</html> 