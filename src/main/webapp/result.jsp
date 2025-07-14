<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ page import="java.util.List" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Service Image Upload Results</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        margin: 20px;
        line-height: 1.6;
        background-color: #f5f5f5;
      }
      .container {
        max-width: 900px;
        margin: 0 auto;
        padding: 30px;
        border-radius: 10px;
        background-color: white;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      }
      .success-message {
        background-color: #d4edda;
        border: 1px solid #c3e6cb;
        color: #155724;
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 20px;
      }
      .error-message {
        background-color: #f8d7da;
        border: 1px solid #f5c6cb;
        color: #721c24;
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 20px;
      }
      .info-section {
        background-color: #e7f3ff;
        border: 1px solid #b3d9ff;
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 20px;
      }
      .image-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
        margin: 20px 0;
      }
      .image-item {
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 15px;
        background-color: #fafafa;
      }
      .image-item img {
        width: 100%;
        height: 200px;
        object-fit: cover;
        border-radius: 5px;
        margin-bottom: 10px;
      }
      .image-url {
        font-size: 12px;
        color: #666;
        word-break: break-all;
        background-color: #f8f9fa;
        padding: 5px;
        border-radius: 3px;
        margin-top: 5px;
      }
      .back-link {
        margin-top: 30px;
        text-align: center;
      }
      .back-link a {
        background-color: #007bff;
        color: white;
        padding: 10px 20px;
        text-decoration: none;
        border-radius: 5px;
        display: inline-block;
      }
      .back-link a:hover {
        background-color: #0056b3;
      }
      .stats {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 15px;
        margin: 20px 0;
      }
      .stat-item {
        background-color: #f8f9fa;
        padding: 15px;
        border-radius: 5px;
        text-align: center;
      }
      .stat-number {
        font-size: 24px;
        font-weight: bold;
        color: #007bff;
      }
      .stat-label {
        color: #666;
        font-size: 14px;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h1>🖼️ Service Image Upload Results</h1>

        <c:if test="${not empty successMessage}">
            <div class="success-message">
                <strong>✅ Success!</strong> ${successMessage}
            </div>
        </c:if>

        <c:if test="${not empty uploadErrors}">
            <div class="error-message">
                <strong>❌ Errors occurred:</strong>
                <ul>
                    <c:forEach var="error" items="${uploadErrors}">
                        <li>${error}</li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>

        <div class="info-section">
            <h3>📊 Upload Summary</h3>
            <div class="stats">
                <div class="stat-item">
                    <div class="stat-number">${serviceId}</div>
                    <div class="stat-label">Service ID</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">${totalImagesProcessed}</div>
                    <div class="stat-label">Images Uploaded</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">${uploadErrors.size()}</div>
                    <div class="stat-label">Errors</div>
                </div>
            </div>
        </div>

        <c:if test="${not empty uploadedUrls}">
            <h3>🎉 Successfully Uploaded Images</h3>
            <div class="image-grid">
                <c:forEach var="imageUrl" items="${uploadedUrls}" varStatus="status">
                    <div class="image-item">
                        <img src="${imageUrl}" alt="Service Image ${status.index + 1}"
                             onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSIjZGRkIi8+PHRleHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtZmFtaWx5PSJBcmlhbCIgZm9udC1zaXplPSIxNCIgZmlsbD0iIzk5OSIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZHk9Ii4zZW0iPkltYWdlIEVycm9yPC90ZXh0Pjwvc3ZnPg==';">
                        <div>
                            <strong>Image ${status.index + 1}</strong>
                            <c:if test="${status.index == 0}">
                                <span style="background-color: #28a745; color: white; padding: 2px 6px; border-radius: 3px; font-size: 11px; margin-left: 5px;">PRIMARY</span>
                            </c:if>
                        </div>
                        <div class="image-url">
                            <strong>Cloudinary URL:</strong><br>
                            <a href="${imageUrl}" target="_blank">${imageUrl}</a>
                        </div>
                        <div style="margin-top: 10px; font-size: 12px; color: #666;">
                            <strong>Database Info:</strong><br>
                            • Saved to service_images table<br>
                            • Service ID: ${serviceId}<br>
                            • Sort Order: ${status.index + 1}<br>
                            • Status: Active<br>
                            • Primary: ${status.index == 0 ? 'Yes' : 'No'}
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <div class="info-section">
            <h3>🔍 What was saved to the database:</h3>
            <ul>
                <li><strong>Table:</strong> service_images</li>
                <li><strong>Service ID:</strong> ${serviceId}</li>
                <li><strong>Image URLs:</strong> Cloudinary secure URLs</li>
                <li><strong>Alt Text:</strong> Generated descriptions</li>
                <li><strong>Primary Image:</strong> First uploaded image</li>
                <li><strong>Sort Order:</strong> Based on upload sequence</li>
                <li><strong>Status:</strong> All images set to active</li>
                <li><strong>Caption:</strong> "Uploaded via TestController"</li>
            </ul>
        </div>

        <div class="back-link">
            <a href="${pageContext.request.contextPath}/TestController">🔄 Upload More Images</a>
            <a href="${pageContext.request.contextPath}/service-details?id=${serviceId}" style="margin-left: 10px;">👁️ View Service Details</a>
        </div>
    </div>
  </body>
</html>
