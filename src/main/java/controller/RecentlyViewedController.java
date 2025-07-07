package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Handles requests for the dedicated "Recently Viewed Services" page.
 */
@WebServlet(name = "RecentlyViewedController", urlPatterns = { "/recently-viewed" })
public class RecentlyViewedController extends HttpServlet {

  /**
   * Forwards GET requests to the JSP page that displays all recently viewed
   * services.
   *
   * @param request  servlet request
   * @param response servlet response
   * @throws ServletException if a servlet-specific error occurs
   * @throws IOException      if an I/O error occurs
   */
  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    request.getRequestDispatcher("/WEB-INF/view/recently-viewed.jsp").forward(request, response);
  }
}