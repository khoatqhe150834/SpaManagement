package service;

import dao.ShoppingCartDAO;
import dao.CartItemDAO;
import dao.ServiceDAO;
import model.ShoppingCart;
import model.CartItem;
import model.Customer;
import model.Service;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CartService {
  private static final Logger logger = Logger.getLogger(CartService.class.getName());

  private final ShoppingCartDAO cartDAO;
  private final CartItemDAO cartItemDAO;
  private final ServiceDAO serviceDAO;

  public CartService() {
    this.cartDAO = new ShoppingCartDAO();
    this.cartItemDAO = new CartItemDAO();
    this.serviceDAO = new ServiceDAO();
  }

  /**
   * Get or create cart for current user/session
   */
  public ShoppingCart getOrCreateCart(HttpServletRequest request) {
    HttpSession session = request.getSession();
    Customer customer = (Customer) session.getAttribute("customer");

    ShoppingCart cart = null;

    if (customer != null) {
      // Logged-in customer
      Optional<ShoppingCart> existingCart = cartDAO.findActiveByCustomerId(customer.getCustomerId());
      if (existingCart.isPresent()) {
        cart = existingCart.get();
      } else {
        // Check if there's a guest cart to convert
        String sessionId = session.getId();
        Optional<ShoppingCart> guestCart = cartDAO.findActiveBySessionId(sessionId);
        if (guestCart.isPresent()) {
          // Convert guest cart to customer cart
          if (cartDAO.convertGuestCartToCustomer(sessionId, customer.getCustomerId())) {
            cart = cartDAO.findActiveByCustomerId(customer.getCustomerId()).orElse(null);
          }
        }

        if (cart == null) {
          // Create new customer cart
          cart = new ShoppingCart(customer.getCustomerId(), null);
          if (cartDAO.create(cart)) {
            logger.log(Level.INFO, "Created new customer cart: " + cart.getCartId());
          }
        }
      }
    } else {
      // Guest user
      String sessionId = session.getId();
      Optional<ShoppingCart> existingCart = cartDAO.findActiveBySessionId(sessionId);
      if (existingCart.isPresent()) {
        cart = existingCart.get();
      } else {
        // Create new guest cart
        cart = new ShoppingCart(null, sessionId);
        if (cartDAO.create(cart)) {
          logger.log(Level.INFO, "Created new guest cart: " + cart.getCartId());
        }
      }
    }

    return cart;
  }

  /**
   * Add service to cart
   */
  public boolean addServiceToCart(HttpServletRequest request, Integer serviceId, Integer quantity) {
    try {
      ShoppingCart cart = getOrCreateCart(request);
      if (cart == null) {
        return false;
      }

      // Get service information
      Optional<Service> serviceOpt = serviceDAO.findById(serviceId);
      if (!serviceOpt.isPresent()) {
        logger.log(Level.WARNING, "Service not found: " + serviceId);
        return false;
      }

      Service service = serviceOpt.get();

      // Check if service already exists in cart
      Optional<CartItem> existingItem = cartItemDAO.findByCartIdAndServiceId(cart.getCartId(), serviceId);
      if (existingItem.isPresent()) {
        // Update quantity
        CartItem item = existingItem.get();
        int newQuantity = item.getQuantity() + quantity;
        return cartItemDAO.updateQuantity(item.getCartItemId(), newQuantity);
      } else {
        // Add new item
        CartItem newItem = new CartItem(cart.getCartId(), serviceId, service.getPrice());
        newItem.setQuantity(quantity);
        newItem.setServiceName(service.getName());
        newItem.setServiceDescription(service.getDescription());

        return cartItemDAO.create(newItem);
      }
    } catch (Exception e) {
      logger.log(Level.SEVERE, "Error adding service to cart", e);
      return false;
    }
  }

  /**
   * Remove service from cart
   */
  public boolean removeServiceFromCart(HttpServletRequest request, Integer cartItemId) {
    try {
      return cartItemDAO.delete(cartItemId);
    } catch (Exception e) {
      logger.log(Level.SEVERE, "Error removing service from cart", e);
      return false;
    }
  }

  /**
   * Update cart item quantity
   */
  public boolean updateCartItemQuantity(Integer cartItemId, Integer quantity) {
    try {
      if (quantity <= 0) {
        return cartItemDAO.delete(cartItemId);
      } else {
        return cartItemDAO.updateQuantity(cartItemId, quantity);
      }
    } catch (Exception e) {
      logger.log(Level.SEVERE, "Error updating cart item quantity", e);
      return false;
    }
  }

  /**
   * Get cart item count for current user/session
   */
  public int getCartItemCount(HttpServletRequest request) {
    try {
      HttpSession session = request.getSession();
      Customer customer = (Customer) session.getAttribute("customer");

      if (customer != null) {
        return cartDAO.getCartItemCount(customer.getCustomerId());
      } else {
        String sessionId = session.getId();
        return cartDAO.getCartItemCount(sessionId);
      }
    } catch (Exception e) {
      logger.log(Level.SEVERE, "Error getting cart item count", e);
      return 0;
    }
  }

  /**
   * Clear cart
   */
  public boolean clearCart(HttpServletRequest request) {
    try {
      ShoppingCart cart = getOrCreateCart(request);
      if (cart != null) {
        return cartItemDAO.deleteByCartId(cart.getCartId());
      }
      return false;
    } catch (Exception e) {
      logger.log(Level.SEVERE, "Error clearing cart", e);
      return false;
    }
  }

  /**
   * Convert guest cart to customer cart after login
   */
  public boolean convertGuestCartToCustomer(String sessionId, Integer customerId) {
    try {
      return cartDAO.convertGuestCartToCustomer(sessionId, customerId);
    } catch (Exception e) {
      logger.log(Level.SEVERE, "Error converting guest cart to customer", e);
      return false;
    }
  }
}