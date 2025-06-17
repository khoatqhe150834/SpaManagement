package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.QRCodeGenerator;
import com.google.zxing.WriterException;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Controller for generating and serving QR codes for appointments
 * 
 * @author quang
 */
@WebServlet(name = "QRCodeController", urlPatterns = { "/qr/*" })
public class QRCodeController extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    String pathInfo = request.getPathInfo();

    if (pathInfo == null || pathInfo.equals("/")) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing QR code path");
      return;
    }

    // Remove leading slash
    pathInfo = pathInfo.substring(1);

    if (pathInfo.startsWith("generate/")) {
      handleQRGeneration(request, response, pathInfo);
    } else if (pathInfo.startsWith("appointment/")) {
      handleAppointmentQR(request, response, pathInfo);
    } else {
      response.sendError(HttpServletResponse.SC_NOT_FOUND, "QR code not found");
    }
  }

  private void handleQRGeneration(HttpServletRequest request, HttpServletResponse response, String pathInfo)
      throws IOException, ServletException {

    try {
      // Extract appointment ID from path: generate/{appointmentId}
      String[] pathParts = pathInfo.split("/");
      if (pathParts.length < 2) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing appointment ID");
        return;
      }

      Integer appointmentId = Integer.parseInt(pathParts[1]);

      // Generate QR code
      String qrPath = QRCodeGenerator.generateAndSaveAppointmentQR(appointmentId);
      String fullPath = getServletContext().getRealPath("/" + qrPath);

      // Serve the generated QR code image
      Path imagePath = Paths.get(fullPath);
      if (Files.exists(imagePath)) {
        response.setContentType("image/png");
        response.setHeader("Content-Disposition", "inline; filename=appointment_" + appointmentId + "_qr.png");
        Files.copy(imagePath, response.getOutputStream());
      } else {
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to generate QR code");
      }

    } catch (NumberFormatException e) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid appointment ID");
    } catch (WriterException e) {
      response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "QR code generation failed: " + e.getMessage());
    }
  }

  private void handleAppointmentQR(HttpServletRequest request, HttpServletResponse response, String pathInfo)
      throws IOException, ServletException {

    try {
      // Extract appointment ID from path: appointment/{appointmentId}
      String[] pathParts = pathInfo.split("/");
      if (pathParts.length < 2) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing appointment ID");
        return;
      }

      Integer appointmentId = Integer.parseInt(pathParts[1]);

      // Check if QR code already exists
      String fileName = "appointment_" + appointmentId + "_qr.png";
      String relativePath = "assets/qr/" + fileName;
      String fullPath = getServletContext().getRealPath("/" + relativePath);

      Path imagePath = Paths.get(fullPath);

      // Generate if doesn't exist
      if (!Files.exists(imagePath)) {
        try {
          QRCodeGenerator.generateAndSaveAppointmentQR(appointmentId);
          // Update the full path after generation
          fullPath = getServletContext().getRealPath("/" + relativePath);
          imagePath = Paths.get(fullPath);
        } catch (WriterException e) {
          response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
              "QR code generation failed: " + e.getMessage());
          return;
        }
      }

      // Serve the QR code image
      if (Files.exists(imagePath)) {
        response.setContentType("image/png");
        response.setHeader("Content-Disposition", "inline; filename=" + fileName);
        response.setHeader("Cache-Control", "public, max-age=3600"); // Cache for 1 hour
        Files.copy(imagePath, response.getOutputStream());
      } else {
        response.sendError(HttpServletResponse.SC_NOT_FOUND, "QR code not found");
      }

    } catch (NumberFormatException e) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid appointment ID");
    }
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    doGet(request, response);
  }

  @Override
  public String getServletInfo() {
    return "QR Code Generator and Server for Appointments";
  }
}