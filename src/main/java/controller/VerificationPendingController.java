package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Customer;

/**
 * Controller for verification pending page
 */
@WebServlet(name = "VerificationPendingController", urlPatterns = { "/verification-pending" })
public class VerificationPendingController extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    HttpSession session = request.getSession();
    Customer customer = (Customer) session.getAttribute("customer");

    // If no customer in session, redirect to login
    if (customer == null) {
      response.sendRedirect(request.getContextPath() + "/login");
      return;
    }

    // Forward to verification pending page
    request.getRequestDispatcher("/WEB-INF/view/auth/verification-pending.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    doGet(request, response);
  }
}