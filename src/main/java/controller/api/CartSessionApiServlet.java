package controller.api;

import dao.CartSessionDAO;
import dao.ServiceDAO;
import service.CartSessionService;
import model.CartSession;
import model.CartSession.CartItem;
import model.CartSession.ItemType;
import model.Service;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Map;
import java.util.Optional;

public class CartSessionApiServlet extends HttpServlet {
  private CartSessionService cartSessionService;
  private ServiceDAO serviceDAO;
  private ObjectMapper objectMapper;

  @Override
  public void init() throws ServletException {
    this.cartSessionService = new CartSessionService();
    this.serviceDAO = new ServiceDAO();
    this.objectMapper = new ObjectMapper().registerModule(new JavaTimeModule());
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    String pathInfo = request.getPathInfo();

    try {
      if (pathInfo == null || pathInfo.equals("/")) {
        // GET /api/cart-session/ - Get full cart contents
        handleGetCart(request, response);
      } else if (pathInfo.equals("/count")) {
        // GET /api/cart-session/count - Get cart item count
        handleGetCartCount(request, response);
      } else {
        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        response.getWriter().write("{\"success\":false,\"message\":\"Endpoint not found\"}");
      }
    } catch (Exception e) {
      e.printStackTrace();
      response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      response.getWriter().write("{\"success\":false,\"message\":\"Internal server error: " + e.getMessage() + "\"}");
    }
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    String pathInfo = request.getPathInfo();

    try {
      switch (pathInfo) {
        case "/add":
          handleAddItem(request, response);
          break;
        case "/remove":
          handleRemoveItem(request, response);
          break;
        case "/update":
          handleUpdateQuantity(request, response);
          break;
        case "/clear":
          handleClearCart(request, response);
          break;
        default:
          response.setStatus(HttpServletResponse.SC_NOT_FOUND);
          response.getWriter().write("{\"success\":false,\"message\":\"Endpoint not found\"}");
      }
    } catch (Exception e) {
      e.printStackTrace();
      response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      response.getWriter().write("{\"success\":false,\"message\":\"Internal server error: " + e.getMessage() + "\"}");
    }
  }

  private void handleGetCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
    CartSession cartSession = cartSessionService.getOrCreateCartSession(request, response);

    Map<String, Object> result = Map.of(
        "success", true,
        "data", Map.of(
            "sessionId", cartSession.getSessionId(),
            "items", cartSession.getData().getCartItems(),
            "totalItems", cartSession.getTotalItemCount(),
            "totalAmount", cartSession.getData().getTotalAmount(),
            "expiresAt", cartSession.getExpiresAt()));

    response.getWriter().write(objectMapper.writeValueAsString(result));
  }

  private void handleGetCartCount(HttpServletRequest request, HttpServletResponse response) throws IOException {
    CartSession cartSession = cartSessionService.getOrCreateCartSession(request, response);

    Map<String, Object> result = Map.of(
        "success", true,
        "count", cartSession.getTotalItemCount());

    response.getWriter().write(objectMapper.writeValueAsString(result));
  }

  private void handleAddItem(HttpServletRequest request, HttpServletResponse response) throws IOException {
    try {
      @SuppressWarnings("unchecked")
      Map<String, Object> requestData = objectMapper.readValue(request.getReader(), Map.class);

      String itemType = (String) requestData.get("itemType");
      Integer itemId = (Integer) requestData.get("itemId");
      Integer quantity = (Integer) requestData.get("quantity");

      // Validate required fields
      if (itemType == null || itemId == null || quantity == null) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter()
            .write("{\"success\":false,\"message\":\"Missing required fields: itemType, itemId, quantity\"}");
        return;
      }

      // Validate item type
      ItemType type;
      try {
        type = ItemType.valueOf(itemType.toUpperCase());
      } catch (IllegalArgumentException e) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write("{\"success\":false,\"message\":\"Invalid item type. Must be SERVICE or PRODUCT\"}");
        return;
      }

      // Validate quantity
      if (quantity <= 0) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write("{\"success\":false,\"message\":\"Quantity must be greater than 0\"}");
        return;
      }

      // Validate item exists and get details
      String itemName;
      BigDecimal itemPrice;

      if (type == ItemType.SERVICE) {
        Optional<Service> serviceOpt = serviceDAO.findById(itemId);
        if (!serviceOpt.isPresent()) {
          response.setStatus(HttpServletResponse.SC_NOT_FOUND);
          response.getWriter().write("{\"success\":false,\"message\":\"Service not found\"}");
          return;
        }
        Service service = serviceOpt.get();
        itemName = service.getName();
        itemPrice = service.getPrice();
      } else {
        // PRODUCT type - since ProductDAO doesn't exist, return error
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write("{\"success\":false,\"message\":\"Product items are not currently supported\"}");
        return;
      }

      // Add item to cart using correct method name
      CartSession cartSession = cartSessionService.addToCart(request, response, itemId, type, itemName, itemPrice,
          quantity);

      Map<String, Object> result = Map.of(
          "success", true,
          "message", "Item added to cart successfully",
          "data", Map.of(
              "totalItems", cartSession.getTotalItemCount(),
              "totalAmount", cartSession.getData().getTotalAmount()));
      response.getWriter().write(objectMapper.writeValueAsString(result));

    } catch (Exception e) {
      e.printStackTrace();
      response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      response.getWriter()
          .write("{\"success\":false,\"message\":\"Error processing request: " + e.getMessage() + "\"}");
    }
  }

  private void handleRemoveItem(HttpServletRequest request, HttpServletResponse response) throws IOException {
    try {
      @SuppressWarnings("unchecked")
      Map<String, Object> requestData = objectMapper.readValue(request.getReader(), Map.class);

      String itemType = (String) requestData.get("itemType");
      Integer itemId = (Integer) requestData.get("itemId");

      if (itemType == null || itemId == null) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write("{\"success\":false,\"message\":\"Missing required fields: itemType, itemId\"}");
        return;
      }

      ItemType type;
      try {
        type = ItemType.valueOf(itemType.toUpperCase());
      } catch (IllegalArgumentException e) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write("{\"success\":false,\"message\":\"Invalid item type\"}");
        return;
      }

      CartSession cartSession = cartSessionService.removeFromCart(request, response, itemId, type);

      Map<String, Object> result = Map.of(
          "success", true,
          "message", "Item removed from cart successfully",
          "data", Map.of(
              "totalItems", cartSession.getTotalItemCount(),
              "totalAmount", cartSession.getData().getTotalAmount()));
      response.getWriter().write(objectMapper.writeValueAsString(result));

    } catch (Exception e) {
      e.printStackTrace();
      response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      response.getWriter()
          .write("{\"success\":false,\"message\":\"Error processing request: " + e.getMessage() + "\"}");
    }
  }

  private void handleUpdateQuantity(HttpServletRequest request, HttpServletResponse response) throws IOException {
    try {
      @SuppressWarnings("unchecked")
      Map<String, Object> requestData = objectMapper.readValue(request.getReader(), Map.class);

      String itemType = (String) requestData.get("itemType");
      Integer itemId = (Integer) requestData.get("itemId");
      Integer quantity = (Integer) requestData.get("quantity");

      if (itemType == null || itemId == null || quantity == null) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter()
            .write("{\"success\":false,\"message\":\"Missing required fields: itemType, itemId, quantity\"}");
        return;
      }

      if (quantity <= 0) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write("{\"success\":false,\"message\":\"Quantity must be greater than 0\"}");
        return;
      }

      ItemType type;
      try {
        type = ItemType.valueOf(itemType.toUpperCase());
      } catch (IllegalArgumentException e) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write("{\"success\":false,\"message\":\"Invalid item type\"}");
        return;
      }

      CartSession cartSession = cartSessionService.updateCartItemQuantity(request, response, itemId, type, quantity);

      Map<String, Object> result = Map.of(
          "success", true,
          "message", "Item quantity updated successfully",
          "data", Map.of(
              "totalItems", cartSession.getTotalItemCount(),
              "totalAmount", cartSession.getData().getTotalAmount()));
      response.getWriter().write(objectMapper.writeValueAsString(result));

    } catch (Exception e) {
      e.printStackTrace();
      response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      response.getWriter()
          .write("{\"success\":false,\"message\":\"Error processing request: " + e.getMessage() + "\"}");
    }
  }

  private void handleClearCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
    try {
      CartSession cartSession = cartSessionService.clearCart(request, response);

      Map<String, Object> result = Map.of(
          "success", true,
          "message", "Cart cleared successfully",
          "data", Map.of(
              "totalItems", 0,
              "totalAmount", BigDecimal.ZERO));
      response.getWriter().write(objectMapper.writeValueAsString(result));

    } catch (Exception e) {
      e.printStackTrace();
      response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      response.getWriter()
          .write("{\"success\":false,\"message\":\"Error processing request: " + e.getMessage() + "\"}");
    }
  }
}