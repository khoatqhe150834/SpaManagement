package controller;

import service.CartSessionService;
import model.CartSession;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = { "/cart-session" })
public class CartSessionController extends HttpServlet {
  private CartSessionService cartSessionService;

  @Override
  public void init() throws ServletException {
    this.cartSessionService = new CartSessionService();
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // Get or create cart session
    CartSession cartSession = cartSessionService.getOrCreateCartSession(request, response);

    // If user is logged in, associate cart with their account
    HttpSession httpSession = request.getSession(false);
    if (httpSession != null) {
      User user = (User) httpSession.getAttribute("user");
      if (user != null && cartSession.getCustomerId() == null) {
        cartSession.setCustomerId(user.getUserId());
        cartSessionService.saveCartSession(cartSession);
      }
    }

    // Add cart session to request attributes for JSP
    request.setAttribute("cartSession", cartSession);
    request.setAttribute("cartItems", cartSession.getData().getCartItems());
    request.setAttribute("cartTotalAmount", cartSession.getData().getTotalAmount());
    request.setAttribute("cartTotalItems", cartSession.getData().getTotalItems());
    request.setAttribute("cartIsEmpty", cartSession.isEmpty());

    // Forward to cart page
    request.getRequestDispatcher("/WEB-INF/view/customer/cart.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    String action = request.getParameter("action");

    if ("transfer-to-booking".equals(action)) {
      handleTransferToBooking(request, response);
    } else {
      response.sendRedirect(request.getContextPath() + "/cart-session");
    }
  }

  /**
   * Transfer cart items to booking session
   */
  private void handleTransferToBooking(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    CartSession cartSession = cartSessionService.getOrCreateCartSession(request, response);

    if (cartSession.isEmpty()) {
      request.setAttribute("errorMessage", "Cart is empty. Please add services before proceeding to booking.");
      doGet(request, response);
      return;
    }

    if (!cartSession.hasServices()) {
      request.setAttribute("errorMessage", "Only services can be booked. Please add services to proceed.");
      doGet(request, response);
      return;
    }

    // Store cart session ID in HTTP session for booking process
    HttpSession httpSession = request.getSession();
    httpSession.setAttribute("cartSessionId", cartSession.getSessionId());

    // Redirect to booking process
    response.sendRedirect(request.getContextPath() + "/booking?step=time&from=cart");
  }
}

/*
 * Example JSP usage in cart.jsp:
 * 
 * <!-- Cart header with total -->
 * <div class="cart-header">
 * <h2>Shopping Cart</h2>
 * <div class="cart-total">
 * <span>Total: $${cartTotalAmount}</span>
 * <span>(${cartTotalItems} items)</span>
 * </div>
 * </div>
 * 
 * <!-- Cart items -->
 * <c:if test="${cartIsEmpty}">
 * <div class="empty-cart">
 * <p>Your cart is empty</p>
 * <a href="${pageContext.request.contextPath}/services"
 * class="btn btn-primary">Browse Services</a>
 * </div>
 * </c:if>
 * 
 * <c:if test="${!cartIsEmpty}">
 * <div class="cart-items">
 * <c:forEach items="${cartItems}" var="item">
 * <div class="cart-item" data-item-id="${item.itemId}"
 * data-item-type="${item.itemType}">
 * <div class="item-info">
 * <h4>${item.itemName}</h4>
 * <p>${item.description}</p>
 * <c:if test="${item.itemType == 'SERVICE' && item.duration != null}">
 * <span class="duration">${item.duration} minutes</span>
 * </c:if>
 * </div>
 * <div class="item-controls">
 * <div class="quantity-controls">
 * <button class="quantity-btn minus"
 * onclick="updateQuantity(${item.itemId}, '${item.itemType}', ${item.quantity - 1})"
 * >-</button>
 * <span class="quantity">${item.quantity}</span>
 * <button class="quantity-btn plus"
 * onclick="updateQuantity(${item.itemId}, '${item.itemType}', ${item.quantity + 1})"
 * >+</button>
 * </div>
 * <div class="item-price">$${item.totalPrice}</div>
 * <button class="remove-btn"
 * onclick="removeFromCart(${item.itemId}, '${item.itemType}')">Remove</button>
 * </div>
 * </div>
 * </c:forEach>
 * </div>
 * 
 * <!-- Cart actions -->
 * <div class="cart-actions">
 * <button onclick="clearCart()" class="btn btn-outline-danger">Clear
 * Cart</button>
 * <form method="post" style="display: inline;">
 * <input type="hidden" name="action" value="transfer-to-booking">
 * <button type="submit" class="btn btn-success">Proceed to Booking</button>
 * </form>
 * </div>
 * </c:if>
 * 
 * <script>
 * // JavaScript functions for cart interactions
 * function updateQuantity(itemId, itemType, quantity) {
 * fetch('/api/cart-session/update', {
 * method: 'POST',
 * headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
 * body: `itemId=${itemId}&itemType=${itemType}&quantity=${quantity}`
 * })
 * .then(response => response.json())
 * .then(data => {
 * if (data.success) {
 * location.reload();
 * }
 * });
 * }
 * 
 * function removeFromCart(itemId, itemType) {
 * fetch('/api/cart-session/remove', {
 * method: 'POST',
 * headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
 * body: `itemId=${itemId}&itemType=${itemType}`
 * })
 * .then(response => response.json())
 * .then(data => {
 * if (data.success) {
 * location.reload();
 * }
 * });
 * }
 * 
 * function clearCart() {
 * if (confirm('Are you sure you want to clear your cart?')) {
 * fetch('/api/cart-session/clear', { method: 'POST' })
 * .then(response => response.json())
 * .then(data => {
 * if (data.success) {
 * location.reload();
 * }
 * });
 * }
 * }
 * </script>
 */