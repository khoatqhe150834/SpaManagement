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
import model.Customer;
import model.Payment;

/**
 * Data Access Object for Payment entity
 * Handles CRUD operations for cart-based payments
 * 
 * @author SpaManagement
 */
public class PaymentDAO implements BaseDAO<Payment, Integer> {
    
    private static final Logger LOGGER = Logger.getLogger(PaymentDAO.class.getName());
    
    @Override
    public <S extends Payment> S save(S payment) throws SQLException {
        String sql = "INSERT INTO payments (customer_id, total_amount, tax_amount, subtotal_amount, " +
                    "payment_method, payment_status, reference_number, transaction_date, payment_date, notes) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, payment.getCustomerId());
            stmt.setBigDecimal(2, payment.getTotalAmount());
            stmt.setBigDecimal(3, payment.getTaxAmount());
            stmt.setBigDecimal(4, payment.getSubtotalAmount());
            stmt.setString(5, payment.getPaymentMethod().name());
            stmt.setString(6, payment.getPaymentStatus().name());
            stmt.setString(7, payment.getReferenceNumber());
            stmt.setTimestamp(8, payment.getTransactionDate());
            stmt.setTimestamp(9, payment.getPaymentDate());
            stmt.setString(10, payment.getNotes());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating payment failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    payment.setPaymentId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating payment failed, no ID obtained.");
                }
            }
            
            LOGGER.log(Level.INFO, "Payment saved successfully with ID: {0}", payment.getPaymentId());
            return payment;
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error saving payment", ex);
            throw ex;
        }
    }
    
    @Override
    public Optional<Payment> findById(Integer id) throws SQLException {
        String sql = "SELECT p.*, c.full_name, c.email, c.phone_number " +
                    "FROM payments p " +
                    "LEFT JOIN customers c ON p.customer_id = c.customer_id " +
                    "WHERE p.payment_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToPayment(rs));
                }
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding payment by ID: " + id, ex);
            throw ex;
        }
        
        return Optional.empty();
    }
    
    @Override
    public List<Payment> findAll() throws SQLException {
        return findAll(1, 50); // Default pagination
    }
    
    @Override
    public List<Payment> findAll(int page, int pageSize) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, c.full_name, c.email, c.phone_number " +
                    "FROM payments p " +
                    "LEFT JOIN customers c ON p.customer_id = c.customer_id " +
                    "ORDER BY p.created_at DESC " +
                    "LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, pageSize);
            stmt.setInt(2, (page - 1) * pageSize);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding all payments", ex);
            throw ex;
        }
        
        return payments;
    }
    
    @Override
    public <S extends Payment> S update(S payment) throws SQLException {
        String sql = "UPDATE payments SET customer_id = ?, total_amount = ?, tax_amount = ?, " +
                    "subtotal_amount = ?, payment_method = ?, payment_status = ?, " +
                    "reference_number = ?, payment_date = ?, notes = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE payment_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, payment.getCustomerId());
            stmt.setBigDecimal(2, payment.getTotalAmount());
            stmt.setBigDecimal(3, payment.getTaxAmount());
            stmt.setBigDecimal(4, payment.getSubtotalAmount());
            stmt.setString(5, payment.getPaymentMethod().name());
            stmt.setString(6, payment.getPaymentStatus().name());
            stmt.setString(7, payment.getReferenceNumber());
            stmt.setTimestamp(8, payment.getPaymentDate());
            stmt.setString(9, payment.getNotes());
            stmt.setInt(10, payment.getPaymentId());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Updating payment failed, no rows affected.");
            }
            
            LOGGER.log(Level.INFO, "Payment updated successfully with ID: {0}", payment.getPaymentId());
            return payment;
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating payment", ex);
            throw ex;
        }
    }
    
    @Override
    public void deleteById(Integer id) throws SQLException {
        String sql = "DELETE FROM payments WHERE payment_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Deleting payment failed, no rows affected.");
            }
            
            LOGGER.log(Level.INFO, "Payment deleted successfully with ID: {0}", id);
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting payment by ID: " + id, ex);
            throw ex;
        }
    }
    
    @Override
    public void delete(Payment payment) throws SQLException {
        deleteById(payment.getPaymentId());
    }
    
    @Override
    public boolean existsById(Integer id) throws SQLException {
        String sql = "SELECT 1 FROM payments WHERE payment_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error checking payment existence by ID: " + id, ex);
            throw ex;
        }
    }
    
    @Override
    public int count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM payments";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error counting payments", ex);
            throw ex;
        }
        
        return 0;
    }
    
    // Business logic methods
    
    /**
     * Find payments by customer ID
     */
    public List<Payment> findByCustomerId(Integer customerId) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, c.full_name, c.email, c.phone_number " +
                    "FROM payments p " +
                    "LEFT JOIN customers c ON p.customer_id = c.customer_id " +
                    "WHERE p.customer_id = ? " +
                    "ORDER BY p.created_at DESC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, customerId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding payments by customer ID: " + customerId, ex);
            throw ex;
        }
        
        return payments;
    }
    
    /**
     * Find payment by reference number
     */
    public Optional<Payment> findByReferenceNumber(String referenceNumber) throws SQLException {
        String sql = "SELECT p.*, c.full_name, c.email, c.phone_number " +
                    "FROM payments p " +
                    "LEFT JOIN customers c ON p.customer_id = c.customer_id " +
                    "WHERE p.reference_number = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, referenceNumber);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToPayment(rs));
                }
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding payment by reference number: " + referenceNumber, ex);
            throw ex;
        }
        
        return Optional.empty();
    }

    /**
     * Find payments by status
     */
    public List<Payment> findByStatus(Payment.PaymentStatus status) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, c.full_name, c.email, c.phone_number " +
                    "FROM payments p " +
                    "LEFT JOIN customers c ON p.customer_id = c.customer_id " +
                    "WHERE p.payment_status = ? " +
                    "ORDER BY p.created_at DESC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status.name());

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding payments by status: " + status, ex);
            throw ex;
        }

        return payments;
    }

    /**
     * Update payment status
     */
    public boolean updatePaymentStatus(Integer paymentId, Payment.PaymentStatus status) throws SQLException {
        String sql = "UPDATE payments SET payment_status = ?, updated_at = CURRENT_TIMESTAMP";

        // If marking as PAID, also set payment_date
        if (status == Payment.PaymentStatus.PAID) {
            sql += ", payment_date = CURRENT_TIMESTAMP";
        }

        sql += " WHERE payment_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status.name());
            stmt.setInt(2, paymentId);

            int affectedRows = stmt.executeUpdate();
            boolean success = affectedRows > 0;

            if (success) {
                LOGGER.log(Level.INFO, "Payment status updated to {0} for ID: {1}",
                          new Object[]{status, paymentId});
            }

            return success;

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating payment status", ex);
            throw ex;
        }
    }

    /**
     * Get payment statistics
     */
    public Map<String, Object> getPaymentStatistics() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT " +
                    "COUNT(*) as total_payments, " +
                    "SUM(CASE WHEN payment_status = 'PAID' THEN total_amount ELSE 0 END) as total_revenue, " +
                    "COUNT(CASE WHEN payment_status = 'PAID' THEN 1 END) as paid_payments, " +
                    "COUNT(CASE WHEN payment_status = 'PENDING' THEN 1 END) as pending_payments, " +
                    "COUNT(CASE WHEN payment_status = 'FAILED' THEN 1 END) as failed_payments, " +
                    "COUNT(CASE WHEN payment_status = 'REFUNDED' THEN 1 END) as refunded_payments " +
                    "FROM payments";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                stats.put("totalPayments", rs.getInt("total_payments"));
                stats.put("totalRevenue", rs.getBigDecimal("total_revenue"));
                stats.put("paidPayments", rs.getInt("paid_payments"));
                stats.put("pendingPayments", rs.getInt("pending_payments"));
                stats.put("failedPayments", rs.getInt("failed_payments"));
                stats.put("refundedPayments", rs.getInt("refunded_payments"));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting payment statistics", ex);
            throw ex;
        }

        return stats;
    }

    /**
     * Map ResultSet to Payment object
     */
    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();

        payment.setPaymentId(rs.getInt("payment_id"));
        payment.setCustomerId(rs.getInt("customer_id"));
        payment.setTotalAmount(rs.getBigDecimal("total_amount"));
        payment.setTaxAmount(rs.getBigDecimal("tax_amount"));
        payment.setSubtotalAmount(rs.getBigDecimal("subtotal_amount"));
        payment.setPaymentMethod(Payment.PaymentMethod.valueOf(rs.getString("payment_method")));
        payment.setPaymentStatus(Payment.PaymentStatus.valueOf(rs.getString("payment_status")));
        payment.setReferenceNumber(rs.getString("reference_number"));
        payment.setTransactionDate(rs.getTimestamp("transaction_date"));
        payment.setPaymentDate(rs.getTimestamp("payment_date"));
        payment.setNotes(rs.getString("notes"));
        payment.setCreatedAt(rs.getTimestamp("created_at"));
        payment.setUpdatedAt(rs.getTimestamp("updated_at"));

        // Map customer information if available
        String customerName = rs.getString("full_name");
        if (customerName != null) {
            Customer customer = new Customer();
            customer.setCustomerId(payment.getCustomerId());
            customer.setFullName(customerName);
            customer.setEmail(rs.getString("email"));
            customer.setPhoneNumber(rs.getString("phone_number"));
            payment.setCustomer(customer);
        }

        return payment;
    }
}
