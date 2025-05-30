<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách Loại Dịch vụ</title>
        <style>
            table {
                width: 90%;
                margin: auto;
                border-collapse: collapse;
            }
            th, td {
                padding: 10px;
                border: 1px solid #999;
                text-align: left;
            }
            th {
                background-color: #f2f2f2;
            }
            h2, h3 {
                text-align: center;
            }
            form {
                width: 60%;
                margin: 20px auto;
                border: 1px solid #ccc;
                padding: 20px;
                background-color: #f9f9f9;
            }
            form input[type="text"],
            form textarea {
                width: 100%;
                padding: 8px;
                margin: 6px 0;
                box-sizing: border-box;
            }
            form label {
                font-weight: bold;
            }
            form input[type="submit"] {
                margin-top: 10px;
                padding: 8px 16px;
            }
        </style>
    </head>
    <body>
        <h2>Danh sách Loại Dịch vụ (Service Types)</h2>

        <h3>Thêm loại dịch vụ mới</h3>
        <form action="servicetype" method="post">
            <input type="hidden" name="service" value="insert" />

            <label for="name">Tên loại dịch vụ:</label>
            <input type="text" id="name" name="name" required />

            <label for="description">Mô tả:</label>
            <textarea id="description" name="description" rows="3"></textarea>

            <label for="image_url">URL ảnh (nếu có):</label>
            <input type="text" id="image_url" name="image_url" />

            <label>
                <input type="checkbox" name="is_active" checked />
                Đang hoạt động
            </label>

            <br/>
            <input type="submit" value="Thêm loại dịch vụ" />
        </form>

        <c:if test="${not empty serviceTypes}">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên</th>
                        <th>Mô tả</th>
                        <th>Ảnh</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                        <th>Ngày update</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="type" items="${serviceTypes}">
                        <tr>
                            <td>${type.serviceTypeId}</td>
                            <td>${type.name}</td>
                            <td>${type.description}</td>
                            <td>
                                <c:if test="${not empty type.imageUrl}">
                                    <img src="${type.imageUrl}" width="60" height="60" alt="image"/>
                                </c:if>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${type.active}">Đang hoạt động</c:when>
                                    <c:otherwise>Ngừng</c:otherwise>
                                </c:choose>
                            </td>
                            <td>${type.createdAt}</td>
                            <td>${type.updatedAt}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>

        <c:if test="${empty serviceTypes}">
            <p style="text-align:center;">Không có loại dịch vụ nào.</p>
        </c:if>
    </body>
</html>
