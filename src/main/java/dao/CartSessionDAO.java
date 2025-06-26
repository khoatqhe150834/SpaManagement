package dao;

import db.DBContext;
import model.CartSession;
import model.CartSession.CartItem;
import model.CartSession.ItemType;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class CartSessionDAO {

  private static final ObjectMapper objectMapper = new ObjectMapper()
      .registerModule(new JavaTimeModule());

  public CartSessionDAO() {
  }

  /**
   * Save or update cart session using existing shopping_carts table
   */
  public void saveCartSession(CartSession cartSession) {
    // First, save/update the shopping cart record
    saveShoppingCart(cartSession);

    // Then save/update cart items
    saveCartItems(cartSession);
  }

  /**
   * Save shopping cart record
   */
  private void saveShoppingCart(CartSession cartSession) {
    // First, try with expires_at column (new schema)
    String sqlWithExpires = """
        INSERT INTO shopping_carts (session_id, customer_id, status, expires_at, created_at, updated_at)
        VALUES (?, ?, 'ACTIVE', ?, ?, ?)
        ON DUPLICATE KEY UPDATE
            customer_id = VALUES(customer_id),
            expires_at = VALUES(expires_at),
            updated_at = VALUES(updated_at)
        """;

    // Fallback SQL without expires_at column (old schema)
    String sqlWithoutExpires = """
        INSERT INTO shopping_carts (session_id, customer_id, status, created_at, updated_at)
        VALUES (?, ?, 'ACTIVE', ?, ?)
        ON DUPLICATE KEY UPDATE
            customer_id = VALUES(customer_id),
            updated_at = VALUES(updated_at)
        """;

    try (Connection conn = new DBContext().getConnection()) {

      LocalDateTime now = LocalDateTime.now();
      boolean useExpiresColumn = true;

      try (PreparedStatement ps = conn.prepareStatement(sqlWithExpires, Statement.RETURN_GENERATED_KEYS)) {
        ps.setString(1, cartSession.getSessionId());
        ps.setObject(2, cartSession.getCustomerId());
        ps.setTimestamp(3, Timestamp.valueOf(cartSession.getExpiresAt()));
        ps.setTimestamp(4,
            cartSession.getCreatedAt() != null ? Timestamp.valueOf(cartSession.getCreatedAt())
                : Timestamp.valueOf(now));
        ps.setTimestamp(5, Timestamp.valueOf(now));

        ps.executeUpdate();

        // Get the cart_id for the session
        if (cartSession.getCartId() == null) {
          try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
            if (generatedKeys.next()) {
              cartSession.setCartId(generatedKeys.getInt(1));
            } else {
              // If no generated key, find existing cart
              cartSession.setCartId(findCartIdBySessionId(cartSession.getSessionId()));
            }
          }
        }

      } catch (SQLException e) {
        // If expires_at column doesn't exist, try without it
        if (e.getMessage().contains("expires_at") || e.getMessage().contains("Unknown column")) {
          System.out.println(
              "NOTICE: expires_at column not found, using fallback. Run create_cart_sessions_table.sql to add this column.");
          useExpiresColumn = false;

          try (PreparedStatement ps2 = conn.prepareStatement(sqlWithoutExpires, Statement.RETURN_GENERATED_KEYS)) {
            ps2.setString(1, cartSession.getSessionId());
            ps2.setObject(2, cartSession.getCustomerId());
            ps2.setTimestamp(3,
                cartSession.getCreatedAt() != null ? Timestamp.valueOf(cartSession.getCreatedAt())
                    : Timestamp.valueOf(now));
            ps2.setTimestamp(4, Timestamp.valueOf(now));

            ps2.executeUpdate();

            // Get the cart_id for the session
            if (cartSession.getCartId() == null) {
              try (ResultSet generatedKeys = ps2.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                  cartSession.setCartId(generatedKeys.getInt(1));
                } else {
                  // If no generated key, find existing cart
                  cartSession.setCartId(findCartIdBySessionId(cartSession.getSessionId()));
                }
              }
            }
          }
        } else {
          throw e;
        }
      }

      // Set timestamps if they were null
      if (cartSession.getCreatedAt() == null) {
        cartSession.setCreatedAt(now);
      }
      cartSession.setUpdatedAt(now);

    } catch (SQLException e) {
      e.printStackTrace();
      throw new RuntimeException("Error saving cart session: " + e.getMessage(), e);
    }
  }

  /**
   * Save cart items to cart_items table
   */
  private void saveCartItems(CartSession cartSession) {
    if (cartSession.getCartId() == null || cartSession.getData().getCartItems() == null) {
      return;
    }

    // First, remove existing items
    clearCartItems(cartSession.getCartId());

    // Then add current items
    String insertSql = """
        INSERT INTO cart_items (cart_id, service_id, quantity, price_at_addition, notes, added_at, is_converted_to_appointment)
        VALUES (?, ?, ?, ?, ?, ?, ?)
        """;

    try (Connection conn = new DBContext().getConnection();
        PreparedStatement ps = conn.prepareStatement(insertSql)) {

      for (CartItem item : cartSession.getData().getCartItems()) {
        if (item.getItemType() == ItemType.SERVICE) {
          ps.setInt(1, cartSession.getCartId());
          ps.setInt(2, item.getItemId());
          ps.setInt(3, item.getQuantity());
          ps.setBigDecimal(4, item.getPrice());
          ps.setString(5, createItemNotes(item));
          ps.setTimestamp(6, Timestamp.valueOf(item.getAddedAt()));
          ps.setBoolean(7, false);
          ps.addBatch();
        }
        // Note: Products would need separate handling if product table exists
      }

      ps.executeBatch();

    } catch (SQLException e) {
      e.printStackTrace();
      throw new RuntimeException("Error saving cart items: " + e.getMessage(), e);
    }
  }

  /**
   * Create notes field containing extra CartItem data
   */
  private String createItemNotes(CartItem item) {
    try {
      // Store additional cart item data as JSON in notes field
      return objectMapper.writeValueAsString(item);
    } catch (JsonProcessingException e) {
      return item.getDescription() != null ? item.getDescription() : "";
    }
  }

  /**
   * Clear existing cart items
   */
  private void clearCartItems(Integer cartId) {
    String sql = "DELETE FROM cart_items WHERE cart_id = ?";

    try (Connection conn = new DBContext().getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {

      ps.setInt(1, cartId);
      ps.executeUpdate();

    } catch (SQLException e) {
      e.printStackTrace();
      throw new RuntimeException("Error clearing cart items: " + e.getMessage(), e);
    }
  }

  /**
   * Find cart ID by session ID
   */
  private Integer findCartIdBySessionId(String sessionId) {
    String sql = "SELECT cart_id FROM shopping_carts WHERE session_id = ?";

    try (Connection conn = new DBContext().getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {

      ps.setString(1, sessionId);

      try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
          return rs.getInt("cart_id");
        }
      }

    } catch (SQLException e) {
      e.printStackTrace();
    }

    return null;
  }

  /**
   * Get cart session by session ID
   */
  public CartSession getCartSession(String sessionId) {
    // Try with expires_at column first (new schema)
    String sqlWithExpires = """
        SELECT sc.*,
               ci.cart_item_id, ci.service_id, ci.quantity, ci.price_at_addition,
               ci.notes, ci.added_at, s.name as service_name, s.description as service_description,
               s.duration_minutes, s.category_id
        FROM shopping_carts sc
        LEFT JOIN cart_items ci ON sc.cart_id = ci.cart_id
        LEFT JOIN services s ON ci.service_id = s.service_id
        WHERE sc.session_id = ? AND (sc.expires_at IS NULL OR sc.expires_at > NOW())
        """;

    // Fallback without expires_at column (old schema)
    String sqlWithoutExpires = """
        SELECT sc.*,
               ci.cart_item_id, ci.service_id, ci.quantity, ci.price_at_addition,
               ci.notes, ci.added_at, s.name as service_name, s.description as service_description,
               s.duration_minutes, s.category_id
        FROM shopping_carts sc
        LEFT JOIN cart_items ci ON sc.cart_id = ci.cart_id
        LEFT JOIN services s ON ci.service_id = s.service_id
        WHERE sc.session_id = ?
        """;

    try (Connection conn = new DBContext().getConnection()) {

      try (PreparedStatement ps = conn.prepareStatement(sqlWithExpires)) {
        ps.setString(1, sessionId);
        try (ResultSet rs = ps.executeQuery()) {
          return mapResultSetToCartSession(rs);
        }
      } catch (SQLException e) {
        // If expires_at column doesn't exist, try without it
        if (e.getMessage().contains("expires_at") || e.getMessage().contains("Unknown column")) {
          try (PreparedStatement ps2 = conn.prepareStatement(sqlWithoutExpires)) {
            ps2.setString(1, sessionId);
            try (ResultSet rs = ps2.executeQuery()) {
              return mapResultSetToCartSession(rs);
            }
          }
        } else {
          throw e;
        }
      }

    } catch (SQLException e) {
      e.printStackTrace();
    }

    return null;
  }

  /**
   * Get cart session by customer ID
   */
  public CartSession getCartSessionByCustomerId(Integer customerId) {
    String sql = """
        SELECT sc.*,
               ci.cart_item_id, ci.service_id, ci.quantity, ci.price_at_addition,
               ci.notes, ci.added_at, s.name as service_name, s.description as service_description,
               s.duration_minutes, s.category_id
        FROM shopping_carts sc
        LEFT JOIN cart_items ci ON sc.cart_id = ci.cart_id
        LEFT JOIN services s ON ci.service_id = s.service_id
        WHERE sc.customer_id = ? AND sc.status = 'ACTIVE'
              AND (sc.expires_at IS NULL OR sc.expires_at > NOW())
        ORDER BY sc.updated_at DESC
        LIMIT 1
        """;

    try (Connection conn = new DBContext().getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {

      ps.setInt(1, customerId);

      try (ResultSet rs = ps.executeQuery()) {
        return mapResultSetToCartSession(rs);
      }

    } catch (SQLException e) {
      e.printStackTrace();
    }

    return null;
  }

  /**
   * Delete cart session
   */
  public void deleteCartSession(String sessionId) {
    // First delete cart items (due to foreign key)
    String deleteItemsSql = """
        DELETE ci FROM cart_items ci
        INNER JOIN shopping_carts sc ON ci.cart_id = sc.cart_id
        WHERE sc.session_id = ?
        """;

    // Then delete shopping cart
    String deleteCartSql = "DELETE FROM shopping_carts WHERE session_id = ?";

    try (Connection conn = new DBContext().getConnection()) {
      conn.setAutoCommit(false);

      try (PreparedStatement ps1 = conn.prepareStatement(deleteItemsSql);
          PreparedStatement ps2 = conn.prepareStatement(deleteCartSql)) {

        ps1.setString(1, sessionId);
        ps1.executeUpdate();

        ps2.setString(1, sessionId);
        ps2.executeUpdate();

        conn.commit();
      } catch (SQLException e) {
        conn.rollback();
        throw e;
      }

    } catch (SQLException e) {
      e.printStackTrace();
      throw new RuntimeException("Error deleting cart session: " + e.getMessage(), e);
    }
  }

  /**
   * Delete expired cart sessions
   */
  public int deleteExpiredSessions() {
    try (Connection conn = new DBContext().getConnection()) {
      try (CallableStatement cs = conn.prepareCall("{CALL CleanupExpiredCartSessions()}")) {
        cs.execute();
        try (ResultSet rs = cs.getResultSet()) {
          if (rs.next()) {
            return rs.getInt("deleted_sessions");
          }
        }
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }

    return 0;
  }

  /**
   * Associate session with customer
   */
  public void associateSessionWithCustomer(String sessionId, Integer customerId) {
    String sql = "UPDATE shopping_carts SET customer_id = ?, session_id = NULL WHERE session_id = ?";

    try (Connection conn = new DBContext().getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {

      ps.setInt(1, customerId);
      ps.setString(2, sessionId);
      ps.executeUpdate();

    } catch (SQLException e) {
      e.printStackTrace();
      throw new RuntimeException("Error associating session with customer: " + e.getMessage(), e);
    }
  }

  /**
   * Map ResultSet to CartSession object
   */
  private CartSession mapResultSetToCartSession(ResultSet rs) throws SQLException {
    CartSession cartSession = null;
    List<CartItem> cartItems = new ArrayList<>();

    while (rs.next()) {
      if (cartSession == null) {
        // Create CartSession from first row
        cartSession = new CartSession();
        cartSession.setSessionId(rs.getString("session_id"));
        cartSession.setCustomerId(rs.getObject("customer_id", Integer.class));
        cartSession.setCartId(rs.getInt("cart_id"));
        cartSession.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        cartSession.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());

        Timestamp expiresAt = rs.getTimestamp("expires_at");
        if (expiresAt != null) {
          cartSession.setExpiresAt(expiresAt.toLocalDateTime());
        } else {
          cartSession.setExpiresAt(LocalDateTime.now().plusDays(30));
        }
      }

      // Add cart item if exists
      if (rs.getObject("cart_item_id") != null) {
        CartItem item = new CartItem();
        item.setItemId(rs.getInt("service_id"));
        item.setItemType(ItemType.SERVICE);
        item.setItemName(rs.getString("service_name"));
        item.setDescription(rs.getString("service_description"));
        item.setPrice(rs.getBigDecimal("price_at_addition"));
        item.setQuantity(rs.getInt("quantity"));
        item.setAddedAt(rs.getTimestamp("added_at").toLocalDateTime());
        item.setDuration(rs.getObject("duration_minutes", Integer.class));
        item.setCategoryId(rs.getObject("category_id", Integer.class));

        cartItems.add(item);
      }
    }

    if (cartSession != null) {
      cartSession.getData().setCartItems(cartItems);
      cartSession.getData().setTotalItems(cartItems.stream().mapToInt(CartItem::getQuantity).sum());
      cartSession.getData().setTotalAmount(
          cartItems.stream()
              .map(item -> item.getPrice().multiply(java.math.BigDecimal.valueOf(item.getQuantity())))
              .reduce(java.math.BigDecimal.ZERO, java.math.BigDecimal::add));
    }

    return cartSession;
  }
}