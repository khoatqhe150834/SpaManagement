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
@WebServlet(name = "StaticImageController", urlPatterns = { "/image" })
public class StaticImageController extends HttpServlet {

  private static final Logger LOGGER = Logger.getLogger(StaticImageController.class.getName());
  private static final String EXTERNAL_IMAGE_PATH = "D:/spa-uploads";

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    String type = request.getParameter("type");
    String name = request.getParameter("name");
    if (type == null || name == null || name.contains("..") || name.contains("/")) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid image request");
      return;
    }
    String folder;
    if ("service_type".equals(type)) {
      folder = "service-types";
    } else if ("service".equals(type)) {
      folder = "services";
    } else {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid type");
      return;
    }
    String fullPath = EXTERNAL_IMAGE_PATH + "/" + folder + "/" + name;
    Path imageFile = Paths.get(fullPath);
    if (!imageFile.normalize().startsWith(Paths.get(EXTERNAL_IMAGE_PATH).normalize())) {
      response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
      return;
    }
    if (!Files.exists(imageFile) || !Files.isRegularFile(imageFile)) {
      response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found");
      return;
    }
    String fileName = imageFile.getFileName().toString();
    String contentType = getContentType(fileName);
    if (contentType == null) {
      response.sendError(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE, "Unsupported file type");
      return;
    }
    response.setContentType(contentType);
    response.setHeader("Cache-Control", "public, max-age=86400");
    response.setContentLengthLong(Files.size(imageFile));
    try (OutputStream out = response.getOutputStream()) {
      Files.copy(imageFile, out);
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