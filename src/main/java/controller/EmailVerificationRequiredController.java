package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Controller for email verification required page
 * Displays a page prompting users to verify their email address
 */
@WebServlet(name = "EmailVerificationRequiredController", urlPatterns = { "/email-verification-required" })
public class EmailVerificationRequiredController extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // Get email parameter from request
    String email = request.getParameter("email");

    // Set email attribute for JSP
    if (email != null && !email.trim().isEmpty()) {
      request.setAttribute("email", email.trim());
    }

    // Forward to email verification required page
    request.getRequestDispatcher("/WEB-INF/view/auth/email-verification-required.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    doGet(request, response);
  }
}