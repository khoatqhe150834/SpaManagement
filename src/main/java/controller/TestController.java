package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Map;
import java.util.UUID;
import util.CloudinaryConfig;

/**
 * Controller for handling image uploads to Cloudinary
 */
@WebServlet(name = "TestController")
@MultipartConfig(maxFileSize = 10485760, maxRequestSize = 20971520, fileSizeThreshold = 1048576)
public class TestController extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // Forward to the test.jsp page for image upload
    request.getRequestDispatcher("/test.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    response.setContentType("text/html");

    // Process the uploaded file
    for (Part part : request.getParts()) {
      String fileName = extractFileName(part);
      if (fileName != null && !fileName.isEmpty()) {
        // Validate file type (only images)
        if (!part.getContentType().startsWith("image/")) {
          request.setAttribute("error", "Error: Only image files are allowed!");
          request.getRequestDispatcher("/error.jsp").forward(request, response);
          return;
        }

        // Generate a unique public ID
        String publicId = UUID.randomUUID().toString() + "_" + fileName;

        // Convert InputStream to byte array
        try (InputStream inputStream = part.getInputStream();
            ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
          byte[] buffer = new byte[8192];
          int bytesRead;
          while ((bytesRead = inputStream.read(buffer)) != -1) {
            baos.write(buffer, 0, bytesRead);
          }
          byte[] fileBytes = baos.toByteArray();

          // Upload to Cloudinary using CloudinaryConfig
          Map<String, Object> uploadResult = CloudinaryConfig.uploadImage(fileBytes, publicId);

          // Get the secure URL
          String fileUrl = (String) uploadResult.get("secure_url");
          request.setAttribute("fileUrl", fileUrl);
          request.getRequestDispatcher("/result.jsp").forward(request, response);
        } catch (Exception e) {
          request.setAttribute("error", "Upload failed: " + e.getMessage());
          request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
      }
    }
  }

  /**
   * Extracts file name from HTTP header content-disposition
   */
  private String extractFileName(Part part) {
    String contentDisp = part.getHeader("content-disposition");
    String[] items = contentDisp.split(";");
    for (String s : items) {
      if (s.trim().startsWith("filename")) {
        return s.substring(s.indexOf("=") + 2, s.length() - 1);
      }
    }
    return "";
  }
}