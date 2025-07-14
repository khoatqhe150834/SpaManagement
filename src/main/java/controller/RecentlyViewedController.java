package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.logging.Logger;

/**
 * Handles requests for the dedicated "Recently Viewed Services" page.
 * Service types are populated dynamically by JavaScript based on actual
 * recently viewed services.
 */
@WebServlet(name = "RecentlyViewedController", urlPatterns = { "/recently-viewed" })
public class RecentlyViewedController extends HttpServlet {

  private static final Logger LOGGER = Logger.getLogger(RecentlyViewedController.class.getName());

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

    LOGGER.info("Serving recently viewed page - service types will be populated dynamically");
    request.getRequestDispatcher("/WEB-INF/view/recently-viewed.jsp").forward(request, response);
  }
}