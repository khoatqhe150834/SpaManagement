package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import db.DBContext;
import model.PaymentItemUsage;

/**
 * Data Access Object for PaymentItemUsage entity
 * Handles CRUD operations for payment item usage tracking
 * 
 * @author SpaManagement
 */
public class PaymentItemUsageDAO implements BaseDAO<PaymentItemUsage, Integer> {
    
    private static final Logger LOGGER = Logger.getLogger(PaymentItemUsageDAO.class.getName());
    
    @Override
    public <S extends PaymentItemUsage> S save(S usage) throws SQLException {
        String sql = "INSERT INTO payment_item_usage (payment_item_id, total_quantity, booked_quantity) " +
                    "VALUES (?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, usage.getPaymentItemId());
            stmt.setInt(2, usage.getTotalQuantity());
            stmt.setInt(3, usage.getBookedQuantity());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating payment item usage failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    usage.setUsageId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating payment item usage failed, no ID obtained.");
                }
            }
            
            LOGGER.log(Level.INFO, "Payment item usage saved successfully with ID: {0}", usage.getUsageId());
            return usage;
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error saving payment item usage", ex);
            throw ex;
        }
    }
    
    @Override
    public Optional<PaymentItemUsage> findById(Integer id) throws SQLException {
        String sql = "SELECT * FROM payment_item_usage WHERE usage_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToUsage(rs));
                }
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding payment item usage by ID: " + id, ex);
            throw ex;
        }
        
        return Optional.empty();
    }
    
    @Override
    public List<PaymentItemUsage> findAll() throws SQLException {
        return findAll(1, 100); // Default pagination
    }
    
    @Override
    public List<PaymentItemUsage> findAll(int page, int pageSize) throws SQLException {
        List<PaymentItemUsage> usages = new ArrayList<>();
        String sql = "SELECT * FROM payment_item_usage ORDER BY last_updated DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, pageSize);
            stmt.setInt(2, (page - 1) * pageSize);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    usages.add(mapResultSetToUsage(rs));
                }
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding all payment item usages", ex);
            throw ex;
        }
        
        return usages;
    }
    
    @Override
    public <S extends PaymentItemUsage> S update(S usage) throws SQLException {
        String sql = "UPDATE payment_item_usage SET payment_item_id = ?, total_quantity = ?, " +
                    "booked_quantity = ? WHERE usage_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usage.getPaymentItemId());
            stmt.setInt(2, usage.getTotalQuantity());
            stmt.setInt(3, usage.getBookedQuantity());
            stmt.setInt(4, usage.getUsageId());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Updating payment item usage failed, no rows affected.");
            }
            
            LOGGER.log(Level.INFO, "Payment item usage updated successfully with ID: {0}", usage.getUsageId());
            return usage;
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating payment item usage", ex);
            throw ex;
        }
    }
    
    @Override
    public void deleteById(Integer id) throws SQLException {
        String sql = "DELETE FROM payment_item_usage WHERE usage_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Deleting payment item usage failed, no rows affected.");
            }
            
            LOGGER.log(Level.INFO, "Payment item usage deleted successfully with ID: {0}", id);
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting payment item usage by ID: " + id, ex);
            throw ex;
        }
    }
    
    @Override
    public void delete(PaymentItemUsage usage) throws SQLException {
        deleteById(usage.getUsageId());
    }
    
    @Override
    public boolean existsById(Integer id) throws SQLException {
        String sql = "SELECT 1 FROM payment_item_usage WHERE usage_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error checking payment item usage existence by ID: " + id, ex);
            throw ex;
        }
    }
    
    @Override
    public int count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM payment_item_usage";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error counting payment item usages", ex);
            throw ex;
        }
        
        return 0;
    }
    
    // Business logic methods
    
    /**
     * Find usage by payment item ID
     */
    public Optional<PaymentItemUsage> findByPaymentItemId(Integer paymentItemId) throws SQLException {
        String sql = "SELECT * FROM payment_item_usage WHERE payment_item_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, paymentItemId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToUsage(rs));
                }
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding usage by payment item ID: " + paymentItemId, ex);
            throw ex;
        }
        
        return Optional.empty();
    }
    
    /**
     * Find all usages with remaining quantity > 0 (available for booking)
     */
    public List<PaymentItemUsage> findAvailableForBooking() throws SQLException {
        List<PaymentItemUsage> usages = new ArrayList<>();
        String sql = "SELECT * FROM payment_item_usage WHERE remaining_quantity > 0 " +
                    "ORDER BY last_updated DESC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                usages.add(mapResultSetToUsage(rs));
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding available usages for booking", ex);
            throw ex;
        }
        
        return usages;
    }
    
    /**
     * Increment booked quantity for a payment item
     */
    public boolean incrementBookedQuantity(Integer paymentItemId) throws SQLException {
        String sql = "UPDATE payment_item_usage SET booked_quantity = booked_quantity + 1 " +
                    "WHERE payment_item_id = ? AND remaining_quantity > 0";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, paymentItemId);
            
            int affectedRows = stmt.executeUpdate();
            boolean success = affectedRows > 0;
            
            if (success) {
                LOGGER.log(Level.INFO, "Incremented booked quantity for payment item ID: {0}", paymentItemId);
            } else {
                LOGGER.log(Level.WARNING, "Could not increment booked quantity - no remaining quantity for payment item ID: {0}", paymentItemId);
            }
            
            return success;
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error incrementing booked quantity for payment item ID: " + paymentItemId, ex);
            throw ex;
        }
    }
    
    /**
     * Decrement booked quantity for a payment item (for cancellations)
     */
    public boolean decrementBookedQuantity(Integer paymentItemId) throws SQLException {
        String sql = "UPDATE payment_item_usage SET booked_quantity = booked_quantity - 1 " +
                    "WHERE payment_item_id = ? AND booked_quantity > 0";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, paymentItemId);
            
            int affectedRows = stmt.executeUpdate();
            boolean success = affectedRows > 0;
            
            if (success) {
                LOGGER.log(Level.INFO, "Decremented booked quantity for payment item ID: {0}", paymentItemId);
            } else {
                LOGGER.log(Level.WARNING, "Could not decrement booked quantity - already at 0 for payment item ID: {0}", paymentItemId);
            }
            
            return success;
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error decrementing booked quantity for payment item ID: " + paymentItemId, ex);
            throw ex;
        }
    }

    /**
     * Get usage statistics
     */
    public Map<String, Object> getUsageStatistics() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT " +
                    "COUNT(*) as total_items, " +
                    "SUM(total_quantity) as total_services_paid, " +
                    "SUM(booked_quantity) as total_services_booked, " +
                    "SUM(remaining_quantity) as total_services_remaining, " +
                    "COUNT(CASE WHEN remaining_quantity > 0 THEN 1 END) as items_with_remaining " +
                    "FROM payment_item_usage";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                stats.put("totalItems", rs.getInt("total_items"));
                stats.put("totalServicesPaid", rs.getInt("total_services_paid"));
                stats.put("totalServicesBooked", rs.getInt("total_services_booked"));
                stats.put("totalServicesRemaining", rs.getInt("total_services_remaining"));
                stats.put("itemsWithRemaining", rs.getInt("items_with_remaining"));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting usage statistics", ex);
            throw ex;
        }

        return stats;
    }

    /**
     * Map ResultSet to PaymentItemUsage object
     */
    private PaymentItemUsage mapResultSetToUsage(ResultSet rs) throws SQLException {
        PaymentItemUsage usage = new PaymentItemUsage();

        usage.setUsageId(rs.getInt("usage_id"));
        usage.setPaymentItemId(rs.getInt("payment_item_id"));
        usage.setTotalQuantity(rs.getInt("total_quantity"));
        usage.setBookedQuantity(rs.getInt("booked_quantity"));
        usage.setRemainingQuantity(rs.getInt("remaining_quantity"));
        usage.setLastUpdated(rs.getTimestamp("last_updated"));

        return usage;
    }
}
