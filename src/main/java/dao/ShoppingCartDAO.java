package dao;

import db.DBContext;
import model.ShoppingCart;
import model.CartItem;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ShoppingCartDAO {
  private static final Logger logger = Logger.getLogger(ShoppingCartDAO.class.getName());
  private final CartItemDAO cartItemDAO;

  public ShoppingCartDAO() {
    this.cartItemDAO = new CartItemDAO();
  }

  /**
   * Find active cart by customer ID
   */
  public Optional<ShoppingCart> findActiveByCustomerId(Integer customerId) {
    String sql = "SELECT * FROM shopping_carts WHERE customer_id = ? AND status = 'ACTIVE'";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {

      ps.setInt(1, customerId);

      try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
          ShoppingCart cart = mapResultSetToCart(rs);
          // Load cart items
          cart.setCartItems(cartItemDAO.findByCartId(cart.getCartId()));
          return Optional.of(cart);
        }
      }
    } catch (SQLException e) {
      logger.log(Level.SEVERE, "Error finding cart by customer ID: " + customerId, e);
    }

    return Optional.empty();
  }

  /**
   * Find active cart by session ID (for guest users)
   */
  public Optional<ShoppingCart> findActiveBySessionId(String sessionId) {
    String sql = "SELECT * FROM shopping_carts WHERE session_id = ? AND status = 'ACTIVE'";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {

      ps.setString(1, sessionId);

      try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
          ShoppingCart cart = mapResultSetToCart(rs);
          // Load cart items
          cart.setCartItems(cartItemDAO.findByCartId(cart.getCartId()));
          return Optional.of(cart);
        }
      }
    } catch (SQLException e) {
      logger.log(Level.SEVERE, "Error finding cart by session ID: " + sessionId, e);
    }

    return Optional.empty();
  }

  /**
   * Create a new shopping cart
   */
  public boolean create(ShoppingCart cart) {
    String sql = "INSERT INTO shopping_carts (customer_id, session_id, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?)";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

      ps.setObject(1, cart.getCustomerId());
      ps.setString(2, cart.getSessionId());
      ps.setString(3, cart.getStatus());
      ps.setTimestamp(4, Timestamp.valueOf(cart.getCreatedAt()));
      ps.setTimestamp(5, Timestamp.valueOf(cart.getUpdatedAt()));

      int rowsAffected = ps.executeUpdate();
      if (rowsAffected > 0) {
        try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
          if (generatedKeys.next()) {
            cart.setCartId(generatedKeys.getInt(1));
            return true;
          }
        }
      }
    } catch (SQLException e) {
      logger.log(Level.SEVERE, "Error creating shopping cart", e);
    }

    return false;
  }

  /**
   * Update shopping cart
   */
  public boolean update(ShoppingCart cart) {
    String sql = "UPDATE shopping_carts SET customer_id = ?, session_id = ?, status = ?, updated_at = ? WHERE cart_id = ?";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {

      ps.setObject(1, cart.getCustomerId());
      ps.setString(2, cart.getSessionId());
      ps.setString(3, cart.getStatus());
      ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
      ps.setInt(5, cart.getCartId());

      return ps.executeUpdate() > 0;
    } catch (SQLException e) {
      logger.log(Level.SEVERE, "Error updating shopping cart: " + cart.getCartId(), e);
    }

    return false;
  }

  /**
   * Delete shopping cart
   */
  public boolean delete(Integer cartId) {
    String sql = "DELETE FROM shopping_carts WHERE cart_id = ?";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {

      ps.setInt(1, cartId);
      return ps.executeUpdate() > 0;
    } catch (SQLException e) {
      logger.log(Level.SEVERE, "Error deleting shopping cart: " + cartId, e);
    }

    return false;
  }

  /**
   * Get cart item count for a customer
   */
  public int getCartItemCount(Integer customerId) {
    Optional<ShoppingCart> cart = findActiveByCustomerId(customerId);
    return cart.map(ShoppingCart::getTotalItemCount).orElse(0);
  }

  /**
   * Get cart item count for a session (guest user)
   */
  public int getCartItemCount(String sessionId) {
    Optional<ShoppingCart> cart = findActiveBySessionId(sessionId);
    return cart.map(ShoppingCart::getTotalItemCount).orElse(0);
  }

  /**
   * Convert guest cart to customer cart
   */
  public boolean convertGuestCartToCustomer(String sessionId, Integer customerId) {
    String sql = "UPDATE shopping_carts SET customer_id = ?, session_id = NULL, updated_at = ? WHERE session_id = ? AND status = 'ACTIVE'";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {

      ps.setInt(1, customerId);
      ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
      ps.setString(3, sessionId);

      return ps.executeUpdate() > 0;
    } catch (SQLException e) {
      logger.log(Level.SEVERE, "Error converting guest cart to customer cart", e);
    }

    return false;
  }

  /**
   * Clean up abandoned carts (older than 30 days)
   */
  public int cleanupAbandonedCarts() {
    String sql = "DELETE FROM shopping_carts WHERE status = 'ABANDONED' AND updated_at < DATE_SUB(NOW(), INTERVAL 30 DAY)";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {

      return ps.executeUpdate();
    } catch (SQLException e) {
      logger.log(Level.SEVERE, "Error cleaning up abandoned carts", e);
    }

    return 0;
  }

  /**
   * Map ResultSet to ShoppingCart object
   */
  private ShoppingCart mapResultSetToCart(ResultSet rs) throws SQLException {
    ShoppingCart cart = new ShoppingCart();
    cart.setCartId(rs.getInt("cart_id"));
    cart.setCustomerId(rs.getObject("customer_id", Integer.class));
    cart.setSessionId(rs.getString("session_id"));
    cart.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
    cart.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
    cart.setStatus(rs.getString("status"));
    return cart;
  }
}