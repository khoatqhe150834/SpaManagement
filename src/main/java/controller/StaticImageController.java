package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Controller for serving static images from external directory
 * Maps URLs like /services/service_71_79_full.png to
 * D:/spa-uploads/services/service_71_79_full.png
 */
@WebServlet(name = "StaticImageController", urlPatterns = { "/services/*" })
public class StaticImageController extends HttpServlet {

  private static final Logger LOGGER = Logger.getLogger(StaticImageController.class.getName());
  private static final String EXTERNAL_IMAGE_PATH = "D:/spa-uploads";

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    String pathInfo = request.getPathInfo();
    if (pathInfo == null || pathInfo.equals("/")) {
      response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found");
      return;
    }

    // Remove leading slash from pathInfo
    String imagePath = pathInfo.substring(1);

    // Construct full file path
    String fullPath = EXTERNAL_IMAGE_PATH + "/services/" + imagePath;
    Path imageFile = Paths.get(fullPath);

    LOGGER.info("Attempting to serve image: " + fullPath);

    // Security check - ensure the path is within our allowed directory
    if (!imageFile.normalize().startsWith(Paths.get(EXTERNAL_IMAGE_PATH).normalize())) {
      LOGGER.warning("Path traversal attempt detected: " + fullPath);
      response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
      return;
    }

    // Check if file exists
    if (!Files.exists(imageFile) || !Files.isRegularFile(imageFile)) {
      LOGGER.warning("Image file not found: " + fullPath);
      response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found");
      return;
    }

    // Get file extension and set content type
    String fileName = imageFile.getFileName().toString();
    String contentType = getContentType(fileName);

    if (contentType == null) {
      LOGGER.warning("Unsupported file type: " + fileName);
      response.sendError(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE, "Unsupported file type");
      return;
    }

    try {
      // Set response headers
      response.setContentType(contentType);
      response.setHeader("Cache-Control", "public, max-age=86400"); // Cache for 24 hours
      response.setContentLengthLong(Files.size(imageFile));

      // Copy file to response output stream
      try (OutputStream out = response.getOutputStream()) {
        Files.copy(imageFile, out);
      }

      LOGGER.info("Successfully served image: " + fullPath);

    } catch (IOException e) {
      LOGGER.log(Level.SEVERE, "Error serving image: " + fullPath, e);
      response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error serving image");
    }
  }

  /**
   * Get content type based on file extension
   */
  private String getContentType(String fileName) {
    String lowerFileName = fileName.toLowerCase();

    if (lowerFileName.endsWith(".jpg") || lowerFileName.endsWith(".jpeg")) {
      return "image/jpeg";
    } else if (lowerFileName.endsWith(".png")) {
      return "image/png";
    } else if (lowerFileName.endsWith(".gif")) {
      return "image/gif";
    } else if (lowerFileName.endsWith(".webp")) {
      return "image/webp";
    }

    return null;
  }

  @Override
  protected void doHead(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // Handle HEAD requests the same as GET but without body
    doGet(request, response);
  }
}