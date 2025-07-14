<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Upload Success</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            line-height: 1.6;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        .success-message {
            color: #28a745;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .image-container {
            margin: 20px 0;
        }
        .image-container img {
            max-width: 100%;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 5px;
        }
        .back-link {
            margin-top: 20px;
        }
        .back-link a {
            color: #007bff;
            text-decoration: none;
        }
        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Upload Successful</h1>
        
        <div class="success-message">
            Your image has been successfully uploaded to Cloudinary!
        </div>
        
        <div class="image-container">
            <h3>Uploaded Image:</h3>
            <img src="${fileUrl}" alt="Uploaded Image">
            <p>Image URL: <a href="${fileUrl}" target="_blank">${fileUrl}</a></p>
        </div>
        
        <div class="back-link">
            <a href="${pageContext.request.contextPath}/test">Upload Another Image</a>
        </div>
    </div>
</body>
</html>
