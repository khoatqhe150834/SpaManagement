package controller.api;

import service.CartService;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(urlPatterns = { "/api/cart/*" })
public class CartApiServlet extends HttpServlet {
  private static final Logger logger = Logger.getLogger(CartApiServlet.class.getName());
  private CartService cartService;
  private Gson gson;

  @Override
  public void init() throws ServletException {
    this.cartService = new CartService();
    this.gson = new Gson();
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    String pathInfo = request.getPathInfo();
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    try {
      if (pathInfo == null || pathInfo.equals("/count")) {
        handleGetCartCount(request, response);
      } else {
        sendErrorResponse(response, "Invalid endpoint", HttpServletResponse.SC_NOT_FOUND);
      }
    } catch (Exception e) {
      logger.log(Level.SEVERE, "Error in cart API GET request", e);
      sendErrorResponse(response, "Internal server error", HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    String pathInfo = request.getPathInfo();
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    try {
      if (pathInfo == null || pathInfo.equals("/add")) {
        handleAddToCart(request, response);
      } else if (pathInfo.equals("/remove")) {
        handleRemoveFromCart(request, response);
      } else if (pathInfo.equals("/update")) {
        handleUpdateCartItem(request, response);
      } else if (pathInfo.equals("/clear")) {
        handleClearCart(request, response);
      } else {
        sendErrorResponse(response, "Invalid endpoint", HttpServletResponse.SC_NOT_FOUND);
      }
    } catch (Exception e) {
      logger.log(Level.SEVERE, "Error in cart API POST request", e);
      sendErrorResponse(response, "Internal server error", HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
  }

  /**
   * Get current cart item count
   */
  private void handleGetCartCount(HttpServletRequest request, HttpServletResponse response)
      throws IOException {

    int count = cartService.getCartItemCount(request);

    JsonObject jsonResponse = new JsonObject();
    jsonResponse.addProperty("success", true);
    jsonResponse.addProperty("count", count);

    response.getWriter().write(gson.toJson(jsonResponse));
  }

  /**
   * Add service to cart
   */
  private void handleAddToCart(HttpServletRequest request, HttpServletResponse response)
      throws IOException {

    try {
      String serviceIdParam = request.getParameter("serviceId");
      String quantityParam = request.getParameter("quantity");

      if (serviceIdParam == null || serviceIdParam.trim().isEmpty()) {
        sendErrorResponse(response, "Service ID is required", HttpServletResponse.SC_BAD_REQUEST);
        return;
      }

      int serviceId = Integer.parseInt(serviceIdParam);
      int quantity = quantityParam != null ? Integer.parseInt(quantityParam) : 1;

      if (quantity <= 0) {
        sendErrorResponse(response, "Quantity must be greater than 0", HttpServletResponse.SC_BAD_REQUEST);
        return;
      }

      boolean success = cartService.addServiceToCart(request, serviceId, quantity);

      JsonObject jsonResponse = new JsonObject();
      jsonResponse.addProperty("success", success);

      if (success) {
        int newCount = cartService.getCartItemCount(request);
        jsonResponse.addProperty("message", "Service added to cart successfully");
        jsonResponse.addProperty("cartCount", newCount);
      } else {
        jsonResponse.addProperty("message", "Failed to add service to cart");
      }

      response.getWriter().write(gson.toJson(jsonResponse));

    } catch (NumberFormatException e) {
      sendErrorResponse(response, "Invalid service ID or quantity", HttpServletResponse.SC_BAD_REQUEST);
    }
  }

  /**
   * Remove item from cart
   */
  private void handleRemoveFromCart(HttpServletRequest request, HttpServletResponse response)
      throws IOException {

    try {
      String cartItemIdParam = request.getParameter("cartItemId");

      if (cartItemIdParam == null || cartItemIdParam.trim().isEmpty()) {
        sendErrorResponse(response, "Cart item ID is required", HttpServletResponse.SC_BAD_REQUEST);
        return;
      }

      int cartItemId = Integer.parseInt(cartItemIdParam);
      boolean success = cartService.removeServiceFromCart(request, cartItemId);

      JsonObject jsonResponse = new JsonObject();
      jsonResponse.addProperty("success", success);

      if (success) {
        int newCount = cartService.getCartItemCount(request);
        jsonResponse.addProperty("message", "Item removed from cart successfully");
        jsonResponse.addProperty("cartCount", newCount);
      } else {
        jsonResponse.addProperty("message", "Failed to remove item from cart");
      }

      response.getWriter().write(gson.toJson(jsonResponse));

    } catch (NumberFormatException e) {
      sendErrorResponse(response, "Invalid cart item ID", HttpServletResponse.SC_BAD_REQUEST);
    }
  }

  /**
   * Update cart item quantity
   */
  private void handleUpdateCartItem(HttpServletRequest request, HttpServletResponse response)
      throws IOException {

    try {
      String cartItemIdParam = request.getParameter("cartItemId");
      String quantityParam = request.getParameter("quantity");

      if (cartItemIdParam == null || quantityParam == null) {
        sendErrorResponse(response, "Cart item ID and quantity are required", HttpServletResponse.SC_BAD_REQUEST);
        return;
      }

      int cartItemId = Integer.parseInt(cartItemIdParam);
      int quantity = Integer.parseInt(quantityParam);

      boolean success = cartService.updateCartItemQuantity(cartItemId, quantity);

      JsonObject jsonResponse = new JsonObject();
      jsonResponse.addProperty("success", success);

      if (success) {
        int newCount = cartService.getCartItemCount(request);
        jsonResponse.addProperty("message", "Cart item updated successfully");
        jsonResponse.addProperty("cartCount", newCount);
      } else {
        jsonResponse.addProperty("message", "Failed to update cart item");
      }

      response.getWriter().write(gson.toJson(jsonResponse));

    } catch (NumberFormatException e) {
      sendErrorResponse(response, "Invalid cart item ID or quantity", HttpServletResponse.SC_BAD_REQUEST);
    }
  }

  /**
   * Clear cart
   */
  private void handleClearCart(HttpServletRequest request, HttpServletResponse response)
      throws IOException {

    boolean success = cartService.clearCart(request);

    JsonObject jsonResponse = new JsonObject();
    jsonResponse.addProperty("success", success);

    if (success) {
      jsonResponse.addProperty("message", "Cart cleared successfully");
      jsonResponse.addProperty("cartCount", 0);
    } else {
      jsonResponse.addProperty("message", "Failed to clear cart");
    }

    response.getWriter().write(gson.toJson(jsonResponse));
  }

  /**
   * Send error response
   */
  private void sendErrorResponse(HttpServletResponse response, String message, int statusCode)
      throws IOException {

    response.setStatus(statusCode);

    JsonObject jsonResponse = new JsonObject();
    jsonResponse.addProperty("success", false);
    jsonResponse.addProperty("message", message);

    response.getWriter().write(gson.toJson(jsonResponse));
  }
}