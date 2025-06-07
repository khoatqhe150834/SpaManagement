package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller for register success page
 * Implements POST-redirect-GET pattern to prevent form resubmission on refresh
 */
@WebServlet(name = "RegisterSuccessController", urlPatterns = { "/register-success" })
public class RegisterSuccessController extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    HttpSession session = request.getSession();
    String email = null;
    String fullName = null;

    // First check if email is provided as URL parameter (for page refreshes)
    String emailParam = request.getParameter("email");
    if (emailParam != null && !emailParam.trim().isEmpty()) {
      email = emailParam;
      // We don't need fullName for refreshes, countdown functionality works without
      // it
    } else {
      // Check if this is a valid registration success request from session
      Boolean registrationSuccess = (Boolean) session.getAttribute("registrationSuccess");
      if (registrationSuccess == null || !registrationSuccess) {
        // No valid registration in session and no email parameter, redirect to
        // registration page
        response.sendRedirect(request.getContextPath() + "/register");
        return;
      }

      // Get registration data from session
      email = (String) session.getAttribute("registrationEmail");
      fullName = (String) session.getAttribute("registrationFullName");

      // Clear registration data from session to prevent reuse
      session.removeAttribute("registrationSuccess");
      session.removeAttribute("registrationEmail");
      session.removeAttribute("registrationFullName");
    }

    // Set attributes for JSP
    request.setAttribute("email", email);
    if (fullName != null) {
      request.setAttribute("fullName", fullName);
    }

    // Forward to register success page
    request.getRequestDispatcher("/WEB-INF/view/auth/register-success.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // POST not allowed for this endpoint
    response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST method not allowed");
  }

  @Override
  public String getServletInfo() {
    return "Register Success Controller - implements POST-redirect-GET pattern";
  }
}