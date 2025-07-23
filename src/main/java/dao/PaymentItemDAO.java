package dao;

import db.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.PaymentItem;
import model.Service;

/**
 * Data Access Object for PaymentItem entity
 * Handles CRUD operations for payment items (services in cart payments)
 * 
 * @author SpaManagement
 */
public class PaymentItemDAO implements BaseDAO<PaymentItem, Integer> {
    
    private static final Logger LOGGER = Logger.getLogger(PaymentItemDAO.class.getName());
    
    @Override
    public <S extends PaymentItem> S save(S paymentItem) throws SQLException {
        String sql = "INSERT INTO payment_items (payment_id, service_id, quantity, unit_price, " +
                    "total_price, service_duration) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, paymentItem.getPaymentId());
            stmt.setInt(2, paymentItem.getServiceId());
            stmt.setInt(3, paymentItem.getQuantity());
            stmt.setBigDecimal(4, paymentItem.getUnitPrice());
            stmt.setBigDecimal(5, paymentItem.getTotalPrice());
            stmt.setInt(6, paymentItem.getServiceDuration());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating payment item failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    paymentItem.setPaymentItemId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating payment item failed, no ID obtained.");
                }
            }
            
            LOGGER.log(Level.INFO, "Payment item saved successfully with ID: {0}", paymentItem.getPaymentItemId());
            return paymentItem;
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error saving payment item", ex);
            throw ex;
        }
    }
    
    @Override
    public Optional<PaymentItem> findById(Integer id) throws SQLException {
        String sql = "SELECT pi.*, s.name as service_name, s.description as service_description " +
                    "FROM payment_items pi " +
                    "LEFT JOIN services s ON pi.service_id = s.service_id " +
                    "WHERE pi.payment_item_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToPaymentItem(rs));
                }
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding payment item by ID: " + id, ex);
            throw ex;
        }
        
        return Optional.empty();
    }
    
    @Override
    public List<PaymentItem> findAll() throws SQLException {
        return findAll(1, 100); // Default pagination
    }
    
    @Override
    public List<PaymentItem> findAll(int page, int pageSize) throws SQLException {
        List<PaymentItem> paymentItems = new ArrayList<>();
        String sql = "SELECT pi.*, s.name as service_name, s.description as service_description " +
                    "FROM payment_items pi " +
                    "LEFT JOIN services s ON pi.service_id = s.service_id " +
                    "ORDER BY pi.created_at DESC " +
                    "LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, pageSize);
            stmt.setInt(2, (page - 1) * pageSize);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    paymentItems.add(mapResultSetToPaymentItem(rs));
                }
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding all payment items", ex);
            throw ex;
        }
        
        return paymentItems;
    }
    
    @Override
    public <S extends PaymentItem> S update(S paymentItem) throws SQLException {
        String sql = "UPDATE payment_items SET payment_id = ?, service_id = ?, quantity = ?, " +
                    "unit_price = ?, total_price = ?, service_duration = ? " +
                    "WHERE payment_item_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, paymentItem.getPaymentId());
            stmt.setInt(2, paymentItem.getServiceId());
            stmt.setInt(3, paymentItem.getQuantity());
            stmt.setBigDecimal(4, paymentItem.getUnitPrice());
            stmt.setBigDecimal(5, paymentItem.getTotalPrice());
            stmt.setInt(6, paymentItem.getServiceDuration());
            stmt.setInt(7, paymentItem.getPaymentItemId());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Updating payment item failed, no rows affected.");
            }
            
            LOGGER.log(Level.INFO, "Payment item updated successfully with ID: {0}", paymentItem.getPaymentItemId());
            return paymentItem;
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating payment item", ex);
            throw ex;
        }
    }
    
    @Override
    public void deleteById(Integer id) throws SQLException {
        String sql = "DELETE FROM payment_items WHERE payment_item_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Deleting payment item failed, no rows affected.");
            }
            
            LOGGER.log(Level.INFO, "Payment item deleted successfully with ID: {0}", id);
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting payment item by ID: " + id, ex);
            throw ex;
        }
    }
    
    @Override
    public void delete(PaymentItem paymentItem) throws SQLException {
        deleteById(paymentItem.getPaymentItemId());
    }
    
    @Override
    public boolean existsById(Integer id) throws SQLException {
        String sql = "SELECT 1 FROM payment_items WHERE payment_item_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error checking payment item existence by ID: " + id, ex);
            throw ex;
        }
    }
    
    @Override
    public int count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM payment_items";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error counting payment items", ex);
            throw ex;
        }
        
        return 0;
    }
    
    // Business logic methods
    
    /**
     * Find payment items by payment ID
     */
    public List<PaymentItem> findByPaymentId(Integer paymentId) throws SQLException {
        List<PaymentItem> paymentItems = new ArrayList<>();
        String sql = "SELECT pi.*, s.name as service_name, s.description as service_description " +
                    "FROM payment_items pi " +
                    "LEFT JOIN services s ON pi.service_id = s.service_id " +
                    "WHERE pi.payment_id = ? " +
                    "ORDER BY pi.created_at ASC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, paymentId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    paymentItems.add(mapResultSetToPaymentItem(rs));
                }
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding payment items by payment ID: " + paymentId, ex);
            throw ex;
        }
        
        return paymentItems;
    }
    
    /**
     * Find payment items by customer ID (through payments table)
     */
    public List<PaymentItem> findByCustomerId(Integer customerId) throws SQLException {
        List<PaymentItem> paymentItems = new ArrayList<>();
        String sql = "SELECT pi.*, s.name as service_name, s.description as service_description, " +
                    "p.customer_id, p.payment_status " +
                    "FROM payment_items pi " +
                    "LEFT JOIN services s ON pi.service_id = s.service_id " +
                    "LEFT JOIN payments p ON pi.payment_id = p.payment_id " +
                    "WHERE p.customer_id = ? AND p.payment_status IN ('PAID', 'PENDING') " +
                    "ORDER BY pi.created_at DESC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PaymentItem item = mapResultSetToPaymentItem(rs);
                    paymentItems.add(item);
                }
            }
        }

        return paymentItems;
    }

    /**
     * Find payment items by service ID
     */
    public List<PaymentItem> findByServiceId(Integer serviceId) throws SQLException {
        List<PaymentItem> paymentItems = new ArrayList<>();
        String sql = "SELECT pi.*, s.name as service_name, s.description as service_description " +
                    "FROM payment_items pi " +
                    "LEFT JOIN services s ON pi.service_id = s.service_id " +
                    "WHERE pi.service_id = ? " +
                    "ORDER BY pi.created_at DESC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, serviceId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    paymentItems.add(mapResultSetToPaymentItem(rs));
                }
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding payment items by service ID: " + serviceId, ex);
            throw ex;
        }
        
        return paymentItems;
    }

    /**
     * Save multiple payment items in a batch (for cart checkout)
     */
    public List<PaymentItem> saveAll(List<PaymentItem> paymentItems) throws SQLException {
        if (paymentItems == null || paymentItems.isEmpty()) {
            return new ArrayList<>();
        }

        String sql = "INSERT INTO payment_items (payment_id, service_id, quantity, unit_price, " +
                    "total_price, service_duration) VALUES (?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false); // Start transaction

            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            for (PaymentItem item : paymentItems) {
                stmt.setInt(1, item.getPaymentId());
                stmt.setInt(2, item.getServiceId());
                stmt.setInt(3, item.getQuantity());
                stmt.setBigDecimal(4, item.getUnitPrice());
                stmt.setBigDecimal(5, item.getTotalPrice());
                stmt.setInt(6, item.getServiceDuration());
                stmt.addBatch();
            }

            stmt.executeBatch();

            // Get generated keys
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                int index = 0;
                while (generatedKeys.next() && index < paymentItems.size()) {
                    paymentItems.get(index).setPaymentItemId(generatedKeys.getInt(1));
                    index++;
                }
            }

            conn.commit(); // Commit transaction

            LOGGER.log(Level.INFO, "Saved {0} payment items successfully", paymentItems.size());
            return paymentItems;

        } catch (SQLException ex) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on error
                } catch (SQLException rollbackEx) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction", rollbackEx);
                }
            }
            LOGGER.log(Level.SEVERE, "Error saving payment items batch", ex);
            throw ex;
        } finally {
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException ex) {
                    LOGGER.log(Level.WARNING, "Error closing statement", ex);
                }
            }
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Reset auto-commit
                    conn.close();
                } catch (SQLException ex) {
                    LOGGER.log(Level.WARNING, "Error closing connection", ex);
                }
            }
        }
    }

    /**
     * Get total amount for a payment
     */
    public java.math.BigDecimal getTotalAmountByPaymentId(Integer paymentId) throws SQLException {
        String sql = "SELECT SUM(total_price) as total_amount FROM payment_items WHERE payment_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, paymentId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    java.math.BigDecimal total = rs.getBigDecimal("total_amount");
                    return total != null ? total : java.math.BigDecimal.ZERO;
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting total amount by payment ID: " + paymentId, ex);
            throw ex;
        }

        return java.math.BigDecimal.ZERO;
    }

    /**
     * Map ResultSet to PaymentItem object
     */
    private PaymentItem mapResultSetToPaymentItem(ResultSet rs) throws SQLException {
        PaymentItem paymentItem = new PaymentItem();

        paymentItem.setPaymentItemId(rs.getInt("payment_item_id"));
        paymentItem.setPaymentId(rs.getInt("payment_id"));
        paymentItem.setServiceId(rs.getInt("service_id"));
        paymentItem.setQuantity(rs.getInt("quantity"));
        paymentItem.setUnitPrice(rs.getBigDecimal("unit_price"));
        paymentItem.setTotalPrice(rs.getBigDecimal("total_price"));
        paymentItem.setServiceDuration(rs.getInt("service_duration"));
        paymentItem.setCreatedAt(rs.getTimestamp("created_at"));

        // Map service information if available
        String serviceName = rs.getString("service_name");
        if (serviceName != null) {
            Service service = new Service();
            service.setServiceId(paymentItem.getServiceId());
            service.setName(serviceName);
            service.setDescription(rs.getString("service_description"));
            paymentItem.setService(service);
        }

        return paymentItem;
    }

    public void deleteByPaymentId(int paymentId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
