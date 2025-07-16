<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title><c:choose><c:when test="${formAction eq 'edit'}">Sửa vật tư</c:when><c:otherwise>Thêm vật tư mới</c:otherwise></c:choose></title>
</head>
<body>
<h2><c:choose><c:when test="${formAction eq 'edit'}">Sửa vật tư</c:when><c:otherwise>Thêm vật tư mới</c:otherwise></c:choose></h2>
<form method="post" action="<c:choose><c:when test='${formAction eq "edit"}'>edit?id=${item.inventoryItemId}</c:when><c:otherwise>create</c:otherwise></c:choose>">
    <label>Tên vật tư: <input type="text" name="name" value="${item.name}" required /></label><br/>
    <label>Loại vật tư:
        <select name="inventoryCategoryId">
            <c:forEach var="cat" items="${categories}">
                <option value="${cat.inventoryCategoryId}" <c:if test="${cat.inventoryCategoryId == item.inventoryCategoryId}">selected</c:if>>${cat.name}</option>
            </c:forEach>
        </select>
    </label><br/>
    <label>Nhà cung cấp:
        <select name="supplierId">
            <c:forEach var="sup" items="${suppliers}">
                <option value="${sup.supplierId}" <c:if test="${sup.supplierId == item.supplierId}">selected</c:if>>${sup.name}</option>
            </c:forEach>
        </select>
    </label><br/>
    <label>Đơn vị: <input type="text" name="unit" value="${item.unit}" /></label><br/>
    <label>Số lượng: <input type="number" name="quantity" value="${item.quantity}" min="0" /></label><br/>
    <label>Tối thiểu: <input type="number" name="minQuantity" value="${item.minQuantity}" min="0" /></label><br/>
    <label>Mô tả: <textarea name="description">${item.description}</textarea></label><br/>
    <button type="submit">Lưu</button>
    <a href="../item">Quay lại</a>
</form>
</body>
</html> 