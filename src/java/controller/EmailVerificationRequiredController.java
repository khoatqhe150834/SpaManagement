package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Controller for handling email verification required page
 * This page is shown when users try to login without email verification
 */
@WebServlet(name = "EmailVerificationRequiredController", urlPatterns = { "/email-verification-required" })
public class EmailVerificationRequiredController extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // Get email from request parameter
    String email = request.getParameter("email");

    // If no email provided, redirect to login
    if (email == null || email.trim().isEmpty()) {
      response.sendRedirect(request.getContextPath() + "/login");
      return;
    }

    // Set email attribute for the JSP
    request.setAttribute("email", email);

    // Forward to the email verification required page
    request.getRequestDispatcher("/WEB-INF/view/auth/email-verification-required.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // Redirect POST to GET
    doGet(request, response);
  }
}