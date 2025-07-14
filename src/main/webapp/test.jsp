<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Service Image Upload Test</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        max-width: 800px;
        margin: 0 auto;
        padding: 20px;
        background-color: #f5f5f5;
      }
      .container {
        background: white;
        padding: 30px;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      }
      h1 {
        color: #333;
        text-align: center;
        margin-bottom: 30px;
      }
      .form-group {
        margin-bottom: 20px;
      }
      label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
        color: #555;
      }
      input[type="number"],
      input[type="file"] {
        width: 100%;
        padding: 10px;
        border: 2px solid #ddd;
        border-radius: 5px;
        font-size: 16px;
      }
      input[type="file"] {
        padding: 8px;
      }
      button {
        background-color: #007bff;
        color: white;
        padding: 12px 30px;
        border: none;
        border-radius: 5px;
        font-size: 16px;
        cursor: pointer;
        width: 100%;
      }
      button:hover {
        background-color: #0056b3;
      }
      .info {
        background-color: #e7f3ff;
        border: 1px solid #b3d9ff;
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 20px;
      }
      .warning {
        background-color: #fff3cd;
        border: 1px solid #ffeaa7;
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 20px;
        color: #856404;
      }
      .error {
        background-color: #f8d7da;
        border: 1px solid #f5c6cb;
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 20px;
        color: #721c24;
      }
      .success {
        background-color: #d4edda;
        border: 1px solid #c3e6cb;
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 20px;
        color: #155724;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h1>🖼️ Service Image Upload Test</h1>

      <% if(request.getAttribute("error") != null) { %>
      <div class="error">
        <strong>❌ Error:</strong> <%= request.getAttribute("error") %>
      </div>
      <% } %>

      <div class="info">
        <strong>📋 Instructions:</strong>
        <ul>
          <li>
            Enter a valid Service ID (check your database for existing services)
          </li>
          <li>Select one or more image files (JPG, PNG, GIF)</li>
          <li>
            Images will be uploaded to Cloudinary and saved to the database
          </li>
          <li>The first image uploaded will be marked as primary</li>
        </ul>
      </div>

      <div class="warning">
        <strong>⚠️ Note:</strong> Make sure the Service ID exists in your
        database before uploading images.
      </div>

      <form action="TestController" method="post" enctype="multipart/form-data">
        <div class="form-group">
          <label for="serviceId">Service ID:</label>
          <input
            type="number"
            id="serviceId"
            name="serviceId"
            required
            placeholder="Enter service ID (e.g., 1, 2, 3...)"
            min="1"
          />
        </div>

        <div class="form-group">
          <label for="images">Select Images:</label>
          <input
            type="file"
            id="images"
            name="images"
            multiple
            accept="image/*"
            required
          />
          <small style="color: #666; font-size: 14px">
            You can select multiple images at once. Supported formats: JPG, PNG,
            GIF
          </small>
        </div>

        <button type="submit">🚀 Upload Images to Cloudinary & Database</button>
      </form>

      <div
        style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee"
      >
        <h3>🔍 What happens when you submit:</h3>
        <ol>
          <li>
            <strong>Validation:</strong> Checks if Service ID exists in database
          </li>
          <li><strong>File Processing:</strong> Validates image files</li>
          <li>
            <strong>Cloudinary Upload:</strong> Uploads images to cloud storage
          </li>
          <li>
            <strong>Database Save:</strong> Saves image URLs to service_images
            table with metadata:
            <ul>
              <li>service_id: Links to your service</li>
              <li>url: Cloudinary secure URL</li>
              <li>alt_text: Generated description</li>
              <li>is_primary: First image marked as primary</li>
              <li>sort_order: Order of upload</li>
              <li>is_active: Set to true</li>
              <li>caption: "Uploaded via TestController"</li>
            </ul>
          </li>
          <li><strong>Results:</strong> Shows success/error messages</li>
        </ol>
      </div>
    </div>
  </body>
</html>
