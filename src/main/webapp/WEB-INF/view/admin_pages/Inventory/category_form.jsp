<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title><c:choose><c:when test="${formAction eq 'edit'}">Sửa loại vật tư</c:when><c:otherwise>Thêm loại vật tư mới</c:otherwise></c:choose></title>
</head>
<body>
<h2><c:choose><c:when test="${formAction eq 'edit'}">Sửa loại vật tư</c:when><c:otherwise>Thêm loại vật tư mới</c:otherwise></c:choose></h2>
<form method="post" action="<c:choose><c:when test='${formAction eq "edit"}'>edit?id=${category.inventoryCategoryId}</c:when><c:otherwise>create</c:otherwise></c:choose>">
    <label>Tên loại vật tư: <input type="text" name="name" value="${category.name}" required /></label><br/>
    <label>Mô tả: <textarea name="description">${category.description}</textarea></label><br/>
    <button type="submit">Lưu</button>
    <a href="../category">Quay lại</a>
</form>
</body>
</html> 