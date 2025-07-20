package controller;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.logging.Logger;

import dao.ServiceDAO;
import dao.ServiceImageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.ServiceImage;
import util.CloudinaryConfig;

/**
 * Controller for handling image uploads to Cloudinary
 */
@WebServlet(name = "TestController", urlPatterns = {"/test", "/TestController"})
@MultipartConfig(maxFileSize = 10485760, maxRequestSize = 20971520, fileSizeThreshold = 1048576)
public class TestController extends HttpServlet {

  private static final Logger LOGGER = Logger.getLogger(TestController.class.getName());
  private ServiceImageDAO serviceImageDAO;
  private ServiceDAO serviceDAO;

  @Override
  public void init() throws ServletException {
    super.init();
    serviceImageDAO = new ServiceImageDAO();
    serviceDAO = new ServiceDAO();
  }

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

    // You would get the serviceId from the request, perhaps as a parameter from
    // your form
    String serviceIdStr = request.getParameter("serviceId");
    if (serviceIdStr == null || serviceIdStr.trim().isEmpty()) {
      request.setAttribute("error", "Error: Service ID is required.");
      request.getRequestDispatcher("/error.jsp").forward(request, response);
      return;
    }

    int serviceId;
    try {
      serviceId = Integer.parseInt(serviceIdStr);
    } catch (NumberFormatException e) {
      request.setAttribute("error", "Error: Invalid Service ID format.");
      request.getRequestDispatcher("/error.jsp").forward(request, response);
      return;
    }

    // Verify that the service exists
    try {
      if (!serviceDAO.findById(serviceId).isPresent()) {
        request.setAttribute("error", "Error: Service with ID " + serviceId + " not found.");
        request.getRequestDispatcher("/error.jsp").forward(request, response);
        return;
      }
    } catch (Exception e) {
      LOGGER.log(java.util.logging.Level.SEVERE, "Error checking service existence", e);
      request.setAttribute("error", "Error: Database error while checking service.");
      request.getRequestDispatcher("/error.jsp").forward(request, response);
      return;
    }

    List<String> uploadedUrls = new ArrayList<>();
    List<String> uploadErrors = new ArrayList<>();

    // Process all uploaded files from the request
    for (Part part : request.getParts()) {
      String fileName = extractFileName(part);
      if (fileName != null && !fileName.isEmpty()) {
        // Validate file type (only images)
        if (!part.getContentType().startsWith("image/")) {
          uploadErrors.add("File '" + fileName + "' is not an image and was skipped.");
          continue; // Skip to the next part
        }

        try {
          // Generate a unique public ID for better organization in Cloudinary
          String publicId = "services/" + serviceIdStr + "/" + UUID.randomUUID().toString();

          // Convert InputStream to byte array
          byte[] fileBytes;
          try (InputStream inputStream = part.getInputStream();
              ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
              baos.write(buffer, 0, bytesRead);
            }
            fileBytes = baos.toByteArray();
          }

          // Upload to Cloudinary using CloudinaryConfig
          Map<String, Object> uploadResult = CloudinaryConfig.uploadImage(fileBytes, publicId);

          // Get the secure URL
          String fileUrl = (String) uploadResult.get("secure_url");
          uploadedUrls.add(fileUrl);

          // ================= DATABASE LOGIC =================
          // Save the image URL to the database
          try {
            ServiceImage serviceImage = new ServiceImage();
            serviceImage.setServiceId(serviceId);
            serviceImage.setUrl(fileUrl);
            serviceImage.setAltText("Service image for " + fileName);
            serviceImage.setIsPrimary(uploadedUrls.size() == 1); // First image is primary
            serviceImage.setSortOrder(uploadedUrls.size());
            serviceImage.setIsActive(true);
            serviceImage.setCaption("Uploaded via TestController");

            ServiceImage savedImage = serviceImageDAO.save(serviceImage);
            if (savedImage != null && savedImage.getImageId() != null) {
              LOGGER.info("✅ Successfully saved image URL to database: " + fileUrl);
              System.out.println("✅ Database: Saved image for service " + serviceId + " with ID " + savedImage.getImageId() + ": " + fileUrl);
            } else {
              LOGGER.warning("❌ Failed to save image URL to database: " + fileUrl);
              System.out.println("❌ Database: Failed to save image for service " + serviceId + ": " + fileUrl);
            }
          } catch (Exception dbException) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Database error while saving image", dbException);
            System.out.println("❌ Database Error: " + dbException.getMessage());
            // Continue processing - don't fail the entire upload if database save fails
          }
          // ==================================================
        } catch (Exception e) {
          e.printStackTrace(); // Good for debugging
          uploadErrors.add("Upload failed for '" + fileName + "': " + e.getMessage());
        }
      }
    }

    // After processing all files, forward to a results page
    request.setAttribute("uploadedUrls", uploadedUrls);
    request.setAttribute("uploadErrors", uploadErrors);
    request.setAttribute("serviceId", serviceId);
    request.setAttribute("totalImagesProcessed", uploadedUrls.size());

    // Add success message
    if (!uploadedUrls.isEmpty()) {
      request.setAttribute("successMessage",
        "Successfully uploaded " + uploadedUrls.size() + " image(s) to Cloudinary and saved to database for Service ID: " + serviceId);
    }

    request.getRequestDispatcher("/result.jsp").forward(request, response);
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