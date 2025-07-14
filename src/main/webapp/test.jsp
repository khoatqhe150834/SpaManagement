<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Upload Image to Cloudinary</title>
</head>
<body>
    <h1>Upload Image to Cloudinary</h1>
    
    <% if(request.getAttribute("error") != null) { %>
        <p style="color: red;">
            <%= request.getAttribute("error") %>
        </p>
    <% } %>
    
    <% if(request.getAttribute("fileUrl") != null) { %>
        <p style="color: green;">
            File uploaded successfully!
        </p>
        <img src="<%= request.getAttribute("fileUrl") %>" alt="Uploaded Image" style="max-width: 300px;">
    <% } %>
    
    <h2>Upload Image</h2>
    <form action="${pageContext.request.contextPath}/test" method="post" enctype="multipart/form-data">
        <input type="file" name="file" accept="image/*" required>
        <input type="submit" value="Upload">
    </form>
</body>
</html>
