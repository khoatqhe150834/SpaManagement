package dao;

import db.DBContext;
import model.CartItem;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CartItemDAO {
  private static final Logger logger = Logger.getLogger(CartItemDAO.class.getName());

  /**
   * Find all cart items by cart ID
   */
  public List<CartItem> findByCartId(Integer cartId) {
    List<CartItem> cartItems = new ArrayList<>();
    String sql = "SELECT ci.*, s.name as service_name, s.description as service_description " +
        "FROM cart_items ci " +
        "LEFT JOIN services s ON ci.service_id = s.service_id " +
        "WHERE ci.cart_id = ? " +
        "ORDER BY ci.added_at DESC";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {

      ps.setInt(1, cartId);

      try (ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
          cartItems.add(mapResultSetToCartItem(rs));
        }
      }
    } catch (SQLException e) {
      logger.log(Level.SEVERE, "Error finding cart items by cart ID: " + cartId, e);
    }

    return cartItems;
  }

  /**
   * Add item to cart
   */
  public boolean create(CartItem cartItem) {
    String sql = "INSERT INTO cart_items (cart_id, service_id, quantity, price_at_addition, " +
        "therapist_user_id_preference, preferred_start_time_slot, notes, added_at, is_converted_to_appointment) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

      ps.setInt(1, cartItem.getCartId());
      ps.setInt(2, cartItem.getServiceId());
      ps.setInt(3, cartItem.getQuantity());
      ps.setBigDecimal(4, cartItem.getPriceAtAddition());
      ps.setObject(5, cartItem.getTherapistUserIdPreference());
      ps.setObject(6,
          cartItem.getPreferredStartTimeSlot() != null ? Timestamp.valueOf(cartItem.getPreferredStartTimeSlot())
              : null);
      ps.setString(7, cartItem.getNotes());
      ps.setTimestamp(8, Timestamp.valueOf(cartItem.getAddedAt()));
      ps.setBoolean(9, cartItem.getIsConvertedToAppointment());

      int rowsAffected = ps.executeUpdate();
      if (rowsAffected > 0) {
        try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
          if (generatedKeys.next()) {
            cartItem.setCartItemId(generatedKeys.getInt(1));
            return true;
          }
        }
      }
    } catch (SQLException e) {
      logger.log(Level.SEVERE, "Error creating cart item", e);
    }

    return false;
  }

  /**
   * Update cart item quantity
   */
  public boolean updateQuantity(Integer cartItemId, Integer quantity) {
    String sql = "UPDATE cart_items SET quantity = ? WHERE cart_item_id = ?";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {

      ps.setInt(1, quantity);
      ps.setInt(2, cartItemId);

      return ps.executeUpdate() > 0;
    } catch (SQLException e) {
      logger.log(Level.SEVERE, "Error updating cart item quantity: " + cartItemId, e);
    }

    return false;
  }

  /**
   * Remove item from cart
   */
  public boolean delete(Integer cartItemId) {
    String sql = "DELETE FROM cart_items WHERE cart_item_id = ?";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {

      ps.setInt(1, cartItemId);
      return ps.executeUpdate() > 0;
    } catch (SQLException e) {
      logger.log(Level.SEVERE, "Error deleting cart item: " + cartItemId, e);
    }

    return false;
  }

  /**
   * Remove all items from cart
   */
  public boolean deleteByCartId(Integer cartId) {
    String sql = "DELETE FROM cart_items WHERE cart_id = ?";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {

      ps.setInt(1, cartId);
      return ps.executeUpdate() > 0;
    } catch (SQLException e) {
      logger.log(Level.SEVERE, "Error deleting cart items by cart ID: " + cartId, e);
    }

    return false;
  }

  /**
   * Check if service already exists in cart
   */
  public Optional<CartItem> findByCartIdAndServiceId(Integer cartId, Integer serviceId) {
    String sql = "SELECT ci.*, s.name as service_name, s.description as service_description " +
        "FROM cart_items ci " +
        "LEFT JOIN services s ON ci.service_id = s.service_id " +
        "WHERE ci.cart_id = ? AND ci.service_id = ?";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {

      ps.setInt(1, cartId);
      ps.setInt(2, serviceId);

      try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
          return Optional.of(mapResultSetToCartItem(rs));
        }
      }
    } catch (SQLException e) {
      logger.log(Level.SEVERE, "Error finding cart item by cart and service ID", e);
    }

    return Optional.empty();
  }

  /**
   * Map ResultSet to CartItem object
   */
  private CartItem mapResultSetToCartItem(ResultSet rs) throws SQLException {
    CartItem cartItem = new CartItem();
    cartItem.setCartItemId(rs.getInt("cart_item_id"));
    cartItem.setCartId(rs.getInt("cart_id"));
    cartItem.setServiceId(rs.getInt("service_id"));
    cartItem.setQuantity(rs.getInt("quantity"));
    cartItem.setPriceAtAddition(rs.getBigDecimal("price_at_addition"));
    cartItem.setTherapistUserIdPreference(rs.getObject("therapist_user_id_preference", Integer.class));

    Timestamp preferredTimeSlot = rs.getTimestamp("preferred_start_time_slot");
    if (preferredTimeSlot != null) {
      cartItem.setPreferredStartTimeSlot(preferredTimeSlot.toLocalDateTime());
    }

    cartItem.setNotes(rs.getString("notes"));
    cartItem.setAddedAt(rs.getTimestamp("added_at").toLocalDateTime());
    cartItem.setIsConvertedToAppointment(rs.getBoolean("is_converted_to_appointment"));

    // Set service information if available
    cartItem.setServiceName(rs.getString("service_name"));
    cartItem.setServiceDescription(rs.getString("service_description"));

    return cartItem;
  }
}