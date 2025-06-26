package service;

import dao.CartSessionDAO;
import model.CartSession;
import model.CartSession.CartItem;
import model.CartSession.ItemType;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

public class CartSessionService {
  private static final String CART_SESSION_COOKIE_NAME = "cart_session_id";
  private static final int COOKIE_MAX_AGE = 30 * 24 * 60 * 60; // 30 days in seconds to match model
  private static final String COOKIE_PATH = "/";

  private final CartSessionDAO cartSessionDAO;

  public CartSessionService() {
    this.cartSessionDAO = new CartSessionDAO();
  }

  /**
   * Get or create cart session from cookie
   */
  public CartSession getOrCreateCartSession(HttpServletRequest request, HttpServletResponse response) {
    String sessionId = getCartSessionIdFromCookie(request);
    CartSession cartSession;

    if (sessionId != null) {
      // Try to load existing session
      cartSession = cartSessionDAO.getCartSession(sessionId);
      if (cartSession != null && !cartSession.isExpired()) {
        return cartSession;
      }
    }

    // Create new session if none exists or expired
    cartSession = createNewCartSession();
    setCartSessionCookie(response, cartSession.getSessionId());
    cartSessionDAO.saveCartSession(cartSession);

    return cartSession;
  }

  /**
   * Get cart session by session ID
   */
  public CartSession getCartSession(String sessionId) {
    if (sessionId == null || sessionId.trim().isEmpty()) {
      return null;
    }
    return cartSessionDAO.getCartSession(sessionId);
  }

  /**
   * Save cart session to database
   */
  public void saveCartSession(CartSession cartSession) {
    if (cartSession == null)
      return;

    cartSessionDAO.saveCartSession(cartSession);
  }

  /**
   * Add item to cart
   */
  public CartSession addToCart(HttpServletRequest request, HttpServletResponse response,
      int itemId, ItemType itemType, String itemName,
      BigDecimal price, int quantity) {
    CartSession cartSession = getOrCreateCartSession(request, response);

    CartItem item = new CartItem(itemId, itemType, itemName, price, quantity);
    cartSession.addCartItem(item);

    saveCartSession(cartSession);
    return cartSession;
  }

  /**
   * Remove item from cart
   */
  public CartSession removeFromCart(HttpServletRequest request, HttpServletResponse response,
      int itemId, ItemType itemType) {
    CartSession cartSession = getOrCreateCartSession(request, response);
    cartSession.removeCartItem(itemId, itemType);

    saveCartSession(cartSession);
    return cartSession;
  }

  /**
   * Update item quantity in cart
   */
  public CartSession updateCartItemQuantity(HttpServletRequest request, HttpServletResponse response,
      int itemId, ItemType itemType, int quantity) {
    CartSession cartSession = getOrCreateCartSession(request, response);
    cartSession.updateItemQuantity(itemId, itemType, quantity);

    saveCartSession(cartSession);
    return cartSession;
  }

  /**
   * Clear entire cart
   */
  public CartSession clearCart(HttpServletRequest request, HttpServletResponse response) {
    CartSession cartSession = getOrCreateCartSession(request, response);
    cartSession.clearCart();

    saveCartSession(cartSession);
    return cartSession;
  }

  /**
   * Get cart item count
   */
  public int getCartItemCount(HttpServletRequest request) {
    String sessionId = getCartSessionIdFromCookie(request);
    if (sessionId == null)
      return 0;

    CartSession cartSession = cartSessionDAO.getCartSession(sessionId);
    if (cartSession == null || cartSession.isExpired())
      return 0;

    return cartSession.getTotalItemCount();
  }

  /**
   * Transfer cart to user account when they log in
   */
  public void transferCartToUser(String sessionId, Integer customerId) {
    if (sessionId == null || customerId == null) {
      return;
    }

    // Associate the session cart with customer account
    cartSessionDAO.associateSessionWithCustomer(sessionId, customerId);
  }

  /**
   * Merge guest cart with existing customer cart (if any)
   */
  public CartSession mergeWithCustomerCart(String guestSessionId, Integer customerId) {
    CartSession guestCart = cartSessionDAO.getCartSession(guestSessionId);
    CartSession customerCart = cartSessionDAO.getCartSessionByCustomerId(customerId);

    if (guestCart == null) {
      return customerCart;
    }

    if (customerCart == null) {
      // No existing customer cart, just transfer the guest cart
      cartSessionDAO.associateSessionWithCustomer(guestSessionId, customerId);
      return cartSessionDAO.getCartSessionByCustomerId(customerId);
    }

    // Merge guest cart items into customer cart
    if (guestCart.getData().getCartItems() != null) {
      for (CartItem guestItem : guestCart.getData().getCartItems()) {
        customerCart.addCartItem(guestItem);
      }
    }

    // Save merged cart and delete guest cart
    cartSessionDAO.saveCartSession(customerCart);
    cartSessionDAO.deleteCartSession(guestSessionId);

    return customerCart;
  }

  /**
   * Create new cart session
   */
  private CartSession createNewCartSession() {
    String sessionId = generateSessionId();
    CartSession cartSession = new CartSession(sessionId);
    cartSession.setCreatedAt(LocalDateTime.now());
    cartSession.setUpdatedAt(LocalDateTime.now());
    return cartSession;
  }

  /**
   * Generate unique session ID
   */
  private String generateSessionId() {
    return "cart_" + UUID.randomUUID().toString().replace("-", "");
  }

  /**
   * Get cart session ID from cookie
   */
  private String getCartSessionIdFromCookie(HttpServletRequest request) {
    if (request.getCookies() != null) {
      for (Cookie cookie : request.getCookies()) {
        if (CART_SESSION_COOKIE_NAME.equals(cookie.getName())) {
          return cookie.getValue();
        }
      }
    }
    return null;
  }

  /**
   * Set cart session cookie
   */
  private void setCartSessionCookie(HttpServletResponse response, String sessionId) {
    Cookie cookie = new Cookie(CART_SESSION_COOKIE_NAME, sessionId);
    cookie.setMaxAge(COOKIE_MAX_AGE);
    cookie.setPath(COOKIE_PATH);
    cookie.setHttpOnly(true);
    // cookie.setSecure(true); // Enable in production with HTTPS
    response.addCookie(cookie);
  }

  /**
   * Remove cart session cookie
   */
  public void removeCartSessionCookie(HttpServletResponse response) {
    Cookie cookie = new Cookie(CART_SESSION_COOKIE_NAME, "");
    cookie.setMaxAge(0);
    cookie.setPath(COOKIE_PATH);
    response.addCookie(cookie);
  }

  /**
   * Clean up expired sessions
   */
  public int cleanupExpiredSessions() {
    return cartSessionDAO.deleteExpiredSessions();
  }
}