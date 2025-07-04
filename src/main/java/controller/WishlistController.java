package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller for handling wishlist-related requests
 */
@WebServlet(name = "WishlistController", urlPatterns = { "/wishlist" })
public class WishlistController extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    HttpSession session = request.getSession();

    // Check if user is logged in
    Object userType = session.getAttribute("userType");
    Object userId = session.getAttribute("userId");

    if (userType == null || userId == null) {
      // Redirect to login if not authenticated
      response.sendRedirect(request.getContextPath() + "/login");
      return;
    }

    // Add user information to request for JavaScript access
    request.setAttribute("userId", userId);
    request.setAttribute("userType", userType);

    // Forward to wishlist JSP
    request.getRequestDispatcher("/WEB-INF/view/customer/wishlist.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // Handle AJAX requests for wishlist operations
    String action = request.getParameter("action");

    if (action == null) {
      response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      return;
    }

    HttpSession session = request.getSession();
    Object userId = session.getAttribute("userId");

    if (userId == null) {
      response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
      return;
    }

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    switch (action) {
      case "add":
        handleAddToWishlist(request, response);
        break;
      case "remove":
        handleRemoveFromWishlist(request, response);
        break;
      case "list":
        handleGetWishlist(request, response);
        break;
      default:
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write("{\"success\": false, \"message\": \"Invalid action\"}");
    }
  }

  private void handleAddToWishlist(HttpServletRequest request, HttpServletResponse response)
      throws IOException {

    String serviceId = request.getParameter("serviceId");
    String serviceName = request.getParameter("serviceName");
    String serviceImage = request.getParameter("serviceImage");
    String servicePriceStr = request.getParameter("servicePrice");
    String serviceRatingStr = request.getParameter("serviceRating");

    if (serviceId == null || serviceName == null || servicePriceStr == null) {
      response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      response.getWriter().write("{\"success\": false, \"message\": \"Missing required parameters\"}");
      return;
    }

    try {
      // In a real application, you would save this to database
      // For now, we'll just return success and let the frontend handle localStorage

      response.getWriter().write("{\"success\": true, \"message\": \"Đã thêm vào danh sách yêu thích\"}");

    } catch (Exception e) {
      response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      response.getWriter().write("{\"success\": false, \"message\": \"Có lỗi xảy ra\"}");
    }
  }

  private void handleRemoveFromWishlist(HttpServletRequest request, HttpServletResponse response)
      throws IOException {

    String itemId = request.getParameter("itemId");

    if (itemId == null) {
      response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      response.getWriter().write("{\"success\": false, \"message\": \"Missing item ID\"}");
      return;
    }

    try {
      // In a real application, you would remove from database
      // For now, we'll just return success and let the frontend handle localStorage

      response.getWriter().write("{\"success\": true, \"message\": \"Đã xóa khỏi danh sách yêu thích\"}");

    } catch (Exception e) {
      response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      response.getWriter().write("{\"success\": false, \"message\": \"Có lỗi xảy ra\"}");
    }
  }

  private void handleGetWishlist(HttpServletRequest request, HttpServletResponse response)
      throws IOException {

    try {
      // In a real application, you would fetch from database
      // For now, we'll return empty array and let frontend handle localStorage

      response.getWriter().write("{\"success\": true, \"data\": []}");

    } catch (Exception e) {
      response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      response.getWriter().write("{\"success\": false, \"message\": \"Có lỗi xảy ra\"}");
    }
  }
}