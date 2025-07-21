package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
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
     * Find payments by customer ID with pagination and filtering
     * Enhanced method for payment history feature
     */
    public List<Payment> findByCustomerIdWithFilters(Integer customerId, int page, int pageSize,
            String statusFilter, String paymentMethodFilter, java.util.Date startDate,
            java.util.Date endDate, String searchQuery) throws SQLException {

        List<Payment> payments = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.*, c.full_name, c.email, c.phone_number " +
            "FROM payments p " +
            "LEFT JOIN customers c ON p.customer_id = c.customer_id " +
            "WHERE p.customer_id = ?");

        List<Object> parameters = new ArrayList<>();
        parameters.add(customerId);

        // Add status filter
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equals(statusFilter)) {
            sql.append(" AND p.payment_status = ?");
            parameters.add(statusFilter);
        }

        // Add payment method filter
        if (paymentMethodFilter != null && !paymentMethodFilter.trim().isEmpty() && !"ALL".equals(paymentMethodFilter)) {
            sql.append(" AND p.payment_method = ?");
            parameters.add(paymentMethodFilter);
        }

        // Add date range filter
        if (startDate != null) {
            sql.append(" AND DATE(p.payment_date) >= ?");
            parameters.add(new java.sql.Date(startDate.getTime()));
        }

        if (endDate != null) {
            sql.append(" AND DATE(p.payment_date) <= ?");
            parameters.add(new java.sql.Date(endDate.getTime()));
        }

        // Add search query (search in reference number or notes)
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append(" AND (p.reference_number LIKE ? OR p.notes LIKE ?)");
            String searchPattern = "%" + searchQuery.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        sql.append(" ORDER BY p.created_at DESC LIMIT ? OFFSET ?");
        parameters.add(pageSize);
        parameters.add((page - 1) * pageSize);

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding payments by customer ID with filters", ex);
            throw ex;
        }

        return payments;
    }

    /**
     * Count payments by customer ID with filtering
     * Used for pagination in payment history
     */
    public int countByCustomerIdWithFilters(Integer customerId, String statusFilter,
            String paymentMethodFilter, java.util.Date startDate, java.util.Date endDate,
            String searchQuery) throws SQLException {

        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM payments p WHERE p.customer_id = ?");

        List<Object> parameters = new ArrayList<>();
        parameters.add(customerId);

        // Add same filters as in findByCustomerIdWithFilters
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equals(statusFilter)) {
            sql.append(" AND p.payment_status = ?");
            parameters.add(statusFilter);
        }

        if (paymentMethodFilter != null && !paymentMethodFilter.trim().isEmpty() && !"ALL".equals(paymentMethodFilter)) {
            sql.append(" AND p.payment_method = ?");
            parameters.add(paymentMethodFilter);
        }

        if (startDate != null) {
            sql.append(" AND DATE(p.payment_date) >= ?");
            parameters.add(new java.sql.Date(startDate.getTime()));
        }

        if (endDate != null) {
            sql.append(" AND DATE(p.payment_date) <= ?");
            parameters.add(new java.sql.Date(endDate.getTime()));
        }

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append(" AND (p.reference_number LIKE ? OR p.notes LIKE ?)");
            String searchPattern = "%" + searchQuery.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error counting payments by customer ID with filters", ex);
            throw ex;
        }

        return 0;
    }

    /**
     * Find recent payments by customer ID (for dashboard preview)
     */
    public List<Payment> findRecentByCustomerId(Integer customerId, int limit) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, c.full_name, c.email, c.phone_number " +
                    "FROM payments p " +
                    "LEFT JOIN customers c ON p.customer_id = c.customer_id " +
                    "WHERE p.customer_id = ? " +
                    "ORDER BY p.created_at DESC " +
                    "LIMIT ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);
            stmt.setInt(2, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding recent payments by customer ID: " + customerId, ex);
            throw ex;
        }

        return payments;
    }

    /**
     * Find payments by date range
     */
    public List<Payment> findByDateRange(java.util.Date startDate, java.util.Date endDate) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, c.full_name, c.email, c.phone_number " +
                    "FROM payments p " +
                    "LEFT JOIN customers c ON p.customer_id = c.customer_id " +
                    "WHERE DATE(p.payment_date) >= ? AND DATE(p.payment_date) <= ? " +
                    "ORDER BY p.created_at DESC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setDate(1, new java.sql.Date(startDate.getTime()));
            stmt.setDate(2, new java.sql.Date(endDate.getTime()));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding payments by date range", ex);
            throw ex;
        }

        return payments;
    }

    /**
     * Find payments by customer ID and date range
     */
    public List<Payment> findByCustomerIdAndDateRange(Integer customerId, java.util.Date startDate,
            java.util.Date endDate) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, c.full_name, c.email, c.phone_number " +
                    "FROM payments p " +
                    "LEFT JOIN customers c ON p.customer_id = c.customer_id " +
                    "WHERE p.customer_id = ? AND DATE(p.payment_date) >= ? AND DATE(p.payment_date) <= ? " +
                    "ORDER BY p.created_at DESC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);
            stmt.setDate(2, new java.sql.Date(startDate.getTime()));
            stmt.setDate(3, new java.sql.Date(endDate.getTime()));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding payments by customer ID and date range", ex);
            throw ex;
        }

        return payments;
    }

    /**
     * Get customer payment statistics
     */
    public Map<String, Object> getCustomerPaymentStatistics(Integer customerId) throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT " +
                    "COUNT(*) as total_payments, " +
                    "SUM(CASE WHEN payment_status = 'PAID' THEN total_amount ELSE 0 END) as total_spent, " +
                    "COUNT(CASE WHEN payment_status = 'PAID' THEN 1 END) as paid_payments, " +
                    "COUNT(CASE WHEN payment_status = 'PENDING' THEN 1 END) as pending_payments, " +
                    "AVG(CASE WHEN payment_status = 'PAID' THEN total_amount ELSE NULL END) as avg_payment_amount, " +
                    "MAX(payment_date) as last_payment_date " +
                    "FROM payments WHERE customer_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalPayments", rs.getInt("total_payments"));
                    stats.put("totalSpent", rs.getBigDecimal("total_spent"));
                    stats.put("paidPayments", rs.getInt("paid_payments"));
                    stats.put("pendingPayments", rs.getInt("pending_payments"));
                    stats.put("avgPaymentAmount", rs.getBigDecimal("avg_payment_amount"));
                    stats.put("lastPaymentDate", rs.getTimestamp("last_payment_date"));
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting customer payment statistics for customer: " + customerId, ex);
            throw ex;
        }

        return stats;
    }

    // ==================== MANAGER-SPECIFIC METHODS ====================

    /**
     * Find all payments across all customers with pagination and filtering (for managers)
     */
    public List<Payment> findAllWithFilters(int page, int pageSize, String statusFilter,
            String paymentMethodFilter, java.util.Date startDate, java.util.Date endDate,
            String searchQuery, String customerFilter) throws SQLException {

        List<Payment> payments = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.*, c.full_name, c.email, c.phone_number " +
            "FROM payments p " +
            "LEFT JOIN customers c ON p.customer_id = c.customer_id " +
            "WHERE 1=1");

        List<Object> parameters = new ArrayList<>();

        // Add filters
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
            sql.append(" AND p.payment_status = ?");
            parameters.add(statusFilter);
        }

        if (paymentMethodFilter != null && !paymentMethodFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(paymentMethodFilter)) {
            sql.append(" AND p.payment_method = ?");
            parameters.add(paymentMethodFilter);
        }

        if (startDate != null) {
            sql.append(" AND p.payment_date >= ?");
            parameters.add(new java.sql.Timestamp(startDate.getTime()));
        }

        if (endDate != null) {
            sql.append(" AND p.payment_date <= ?");
            parameters.add(new java.sql.Timestamp(endDate.getTime()));
        }

        if (customerFilter != null && !customerFilter.trim().isEmpty()) {
            sql.append(" AND (c.full_name LIKE ? OR c.email LIKE ? OR c.phone_number LIKE ?)");
            String customerPattern = "%" + customerFilter.trim() + "%";
            parameters.add(customerPattern);
            parameters.add(customerPattern);
            parameters.add(customerPattern);
        }

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append(" AND (p.reference_number LIKE ? OR p.notes LIKE ? OR CAST(p.payment_id AS CHAR) LIKE ?)");
            String searchPattern = "%" + searchQuery.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        sql.append(" ORDER BY p.created_at DESC LIMIT ? OFFSET ?");
        parameters.add(pageSize);
        parameters.add((page - 1) * pageSize);

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding all payments with filters", ex);
            throw ex;
        }

        return payments;
    }

    /**
     * Count all payments across all customers with filtering (for managers)
     */
    public int countAllWithFilters(String statusFilter, String paymentMethodFilter,
            java.util.Date startDate, java.util.Date endDate, String searchQuery,
            String customerFilter) throws SQLException {

        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM payments p " +
            "LEFT JOIN customers c ON p.customer_id = c.customer_id " +
            "WHERE 1=1");

        List<Object> parameters = new ArrayList<>();

        // Add filters (same logic as findAllWithFilters)
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
            sql.append(" AND p.payment_status = ?");
            parameters.add(statusFilter);
        }

        if (paymentMethodFilter != null && !paymentMethodFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(paymentMethodFilter)) {
            sql.append(" AND p.payment_method = ?");
            parameters.add(paymentMethodFilter);
        }

        if (startDate != null) {
            sql.append(" AND p.payment_date >= ?");
            parameters.add(new java.sql.Timestamp(startDate.getTime()));
        }

        if (endDate != null) {
            sql.append(" AND p.payment_date <= ?");
            parameters.add(new java.sql.Timestamp(endDate.getTime()));
        }

        if (customerFilter != null && !customerFilter.trim().isEmpty()) {
            sql.append(" AND (c.full_name LIKE ? OR c.email LIKE ? OR c.phone_number LIKE ?)");
            String customerPattern = "%" + customerFilter.trim() + "%";
            parameters.add(customerPattern);
            parameters.add(customerPattern);
            parameters.add(customerPattern);
        }

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append(" AND (p.reference_number LIKE ? OR p.notes LIKE ? OR CAST(p.payment_id AS CHAR) LIKE ?)");
            String searchPattern = "%" + searchQuery.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error counting all payments with filters", ex);
            throw ex;
        }

        return 0;
    }

    /**
     * Simple method to get all payments without filters (for debugging)
     */
    public List<Payment> findAllPaymentsSimple() throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, c.full_name, c.email, c.phone_number " +
                    "FROM payments p " +
                    "LEFT JOIN customers c ON p.customer_id = c.customer_id " +
                    "ORDER BY p.created_at DESC LIMIT 50";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding all payments simple", ex);
            throw ex;
        }

        return payments;
    }

    /**
     * Get overall payment statistics for manager dashboard
     */
    public Map<String, Object> getOverallPaymentStatistics() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT " +
                    "COUNT(*) as total_payments, " +
                    "SUM(CASE WHEN payment_status = 'PAID' THEN total_amount ELSE 0 END) as total_revenue, " +
                    "SUM(CASE WHEN payment_status = 'PENDING' THEN total_amount ELSE 0 END) as pending_amount, " +
                    "SUM(CASE WHEN payment_status IN ('FAILED', 'REFUNDED') THEN total_amount ELSE 0 END) as failed_refunded_amount, " +
                    "COUNT(CASE WHEN payment_status = 'PAID' THEN 1 END) as paid_payments, " +
                    "COUNT(CASE WHEN payment_status = 'PENDING' THEN 1 END) as pending_payments, " +
                    "COUNT(CASE WHEN payment_status = 'FAILED' THEN 1 END) as failed_payments, " +
                    "COUNT(CASE WHEN payment_status = 'REFUNDED' THEN 1 END) as refunded_payments, " +
                    "AVG(CASE WHEN payment_status = 'PAID' THEN total_amount ELSE NULL END) as avg_payment_amount, " +
                    "COUNT(DISTINCT customer_id) as unique_customers " +
                    "FROM payments";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalPayments", rs.getInt("total_payments"));
                    stats.put("totalRevenue", rs.getBigDecimal("total_revenue"));
                    stats.put("pendingAmount", rs.getBigDecimal("pending_amount"));
                    stats.put("failedRefundedAmount", rs.getBigDecimal("failed_refunded_amount"));
                    stats.put("paidPayments", rs.getInt("paid_payments"));
                    stats.put("pendingPayments", rs.getInt("pending_payments"));
                    stats.put("failedPayments", rs.getInt("failed_payments"));
                    stats.put("refundedPayments", rs.getInt("refunded_payments"));
                    stats.put("avgPaymentAmount", rs.getBigDecimal("avg_payment_amount"));
                    stats.put("uniqueCustomers", rs.getInt("unique_customers"));
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting overall payment statistics", ex);
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
        if (rs.getBigDecimal("total_amount") != null)
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

    /**
     * Get payment statistics by date range
     */
    public Map<String, Object> getPaymentStatisticsByDateRange(Date startDate, Date endDate) throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT " +
                    "COUNT(*) as total_payments, " +
                    "SUM(CASE WHEN payment_status = 'PAID' THEN total_amount ELSE 0 END) as total_revenue, " +
                    "SUM(CASE WHEN payment_status = 'PENDING' THEN total_amount ELSE 0 END) as pending_amount, " +
                    "SUM(CASE WHEN payment_status IN ('FAILED', 'REFUNDED') THEN total_amount ELSE 0 END) as failed_refunded_amount, " +
                    "COUNT(CASE WHEN payment_status = 'PAID' THEN 1 END) as paid_count, " +
                    "COUNT(CASE WHEN payment_status = 'PENDING' THEN 1 END) as pending_count, " +
                    "COUNT(CASE WHEN payment_status IN ('FAILED', 'REFUNDED') THEN 1 END) as failed_refunded_count, " +
                    "AVG(CASE WHEN payment_status = 'PAID' THEN total_amount END) as avg_payment_amount " +
                    "FROM payments " +
                    "WHERE payment_date BETWEEN ? AND ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setDate(1, new java.sql.Date(startDate.getTime()));
            stmt.setDate(2, new java.sql.Date(endDate.getTime()));

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("total_payments", rs.getInt("total_payments"));
                    stats.put("total_revenue", rs.getBigDecimal("total_revenue"));
                    stats.put("pending_amount", rs.getBigDecimal("pending_amount"));
                    stats.put("failed_refunded_amount", rs.getBigDecimal("failed_refunded_amount"));
                    stats.put("paid_count", rs.getInt("paid_count"));
                    stats.put("pending_count", rs.getInt("pending_count"));
                    stats.put("failed_refunded_count", rs.getInt("failed_refunded_count"));
                    stats.put("avg_payment_amount", rs.getBigDecimal("avg_payment_amount"));
                }
            }
        }

        return stats;
    }

    /**
     * Get payment method statistics
     */
    public Map<String, Object> getPaymentMethodStatistics(Date startDate, Date endDate) throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT " +
                    "payment_method, " +
                    "COUNT(*) as method_count, " +
                    "SUM(CASE WHEN payment_status = 'PAID' THEN total_amount ELSE 0 END) as method_revenue, " +
                    "ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM payments WHERE payment_date BETWEEN ? AND ?), 2) as percentage " +
                    "FROM payments " +
                    "WHERE payment_date BETWEEN ? AND ? " +
                    "GROUP BY payment_method " +
                    "ORDER BY method_revenue DESC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            java.sql.Date sqlStartDate = new java.sql.Date(startDate.getTime());
            java.sql.Date sqlEndDate = new java.sql.Date(endDate.getTime());

            stmt.setDate(1, sqlStartDate);
            stmt.setDate(2, sqlEndDate);
            stmt.setDate(3, sqlStartDate);
            stmt.setDate(4, sqlEndDate);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String method = rs.getString("payment_method");
                    Map<String, Object> methodData = new HashMap<>();
                    methodData.put("count", rs.getInt("method_count"));
                    methodData.put("revenue", rs.getBigDecimal("method_revenue"));
                    methodData.put("percentage", rs.getDouble("percentage"));
                    stats.put(method, methodData);
                }
            }
        }

        return stats;
    }

    /**
     * Get daily payment statistics
     */
    public List<Map<String, Object>> getDailyPaymentStatistics(Date startDate, Date endDate) throws SQLException {
        List<Map<String, Object>> dailyStats = new ArrayList<>();
        String sql = "SELECT " +
                    "DATE(payment_date) as payment_day, " +
                    "COUNT(*) as daily_count, " +
                    "SUM(CASE WHEN payment_status = 'PAID' THEN total_amount ELSE 0 END) as daily_revenue " +
                    "FROM payments " +
                    "WHERE payment_date BETWEEN ? AND ? " +
                    "GROUP BY DATE(payment_date) " +
                    "ORDER BY payment_day";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setDate(1, new java.sql.Date(startDate.getTime()));
            stmt.setDate(2, new java.sql.Date(endDate.getTime()));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> dayData = new HashMap<>();
                    dayData.put("date", rs.getDate("payment_day"));
                    dayData.put("count", rs.getInt("daily_count"));
                    dayData.put("revenue", rs.getBigDecimal("daily_revenue"));
                    dailyStats.add(dayData);
                }
            }
        }

        return dailyStats;
    }

    /**
     * Get service revenue statistics
     */
    public List<Map<String, Object>> getServiceRevenueStatistics(Date startDate, Date endDate) throws SQLException {
        List<Map<String, Object>> serviceStats = new ArrayList<>();
        String sql = "SELECT " +
                    "s.service_id, " +
                    "s.name as service_name, " +
                    "COUNT(pi.payment_item_id) as item_count, " +
                    "SUM(pi.quantity) as total_quantity, " +
                    "SUM(pi.unit_price * pi.quantity) as total_revenue " +
                    "FROM services s " +
                    "JOIN payment_items pi ON s.service_id = pi.service_id " +
                    "JOIN payments p ON pi.payment_id = p.payment_id " +
                    "WHERE p.payment_date BETWEEN ? AND ? AND p.payment_status = 'PAID' " +
                    "GROUP BY s.service_id, s.name " +
                    "ORDER BY total_revenue DESC " +
                    "LIMIT 10";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setDate(1, new java.sql.Date(startDate.getTime()));
            stmt.setDate(2, new java.sql.Date(endDate.getTime()));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> serviceData = new HashMap<>();
                    serviceData.put("service_id", rs.getInt("service_id"));
                    serviceData.put("service_name", rs.getString("service_name"));
                    serviceData.put("item_count", rs.getInt("item_count"));
                    serviceData.put("total_quantity", rs.getInt("total_quantity"));
                    serviceData.put("total_revenue", rs.getBigDecimal("total_revenue"));
                    serviceStats.add(serviceData);
                }
            }
        }

        return serviceStats;
    }

    /**
     * Get customer payment statistics (overloaded for date range)
     */
    public Map<String, Object> getCustomerPaymentStatistics(Date startDate, Date endDate) throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT " +
                    "COUNT(DISTINCT p.customer_id) as unique_customers, " +
                    "COUNT(*) as total_payments, " +
                    "AVG(p.total_amount) as avg_payment_amount, " +
                    "MAX(p.total_amount) as max_payment_amount, " +
                    "MIN(p.total_amount) as min_payment_amount, " +
                    "SUM(CASE WHEN p.payment_status = 'PAID' THEN p.total_amount ELSE 0 END) as total_revenue " +
                    "FROM payments p " +
                    "WHERE p.payment_date BETWEEN ? AND ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setDate(1, new java.sql.Date(startDate.getTime()));
            stmt.setDate(2, new java.sql.Date(endDate.getTime()));

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("unique_customers", rs.getInt("unique_customers"));
                    stats.put("total_payments", rs.getInt("total_payments"));
                    stats.put("avg_payment_amount", rs.getBigDecimal("avg_payment_amount"));
                    stats.put("max_payment_amount", rs.getBigDecimal("max_payment_amount"));
                    stats.put("min_payment_amount", rs.getBigDecimal("min_payment_amount"));
                    stats.put("total_revenue", rs.getBigDecimal("total_revenue"));
                }
            }
        }

        return stats;
    }

    // ==================== STATISTICS CONTROLLER METHODS ====================

    /**
     * Get comprehensive revenue statistics for the revenue statistics page
     */
    public Map<String, Object> getRevenueStatistics() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT " +
                    "SUM(CASE WHEN payment_status = 'PAID' THEN total_amount ELSE 0 END) as total_revenue, " +
                    "SUM(CASE WHEN payment_status = 'PAID' AND MONTH(payment_date) = MONTH(CURRENT_DATE) " +
                    "    AND YEAR(payment_date) = YEAR(CURRENT_DATE) THEN total_amount ELSE 0 END) as monthly_revenue, " +
                    "AVG(CASE WHEN payment_status = 'PAID' THEN total_amount ELSE NULL END) as average_transaction, " +
                    "COUNT(CASE WHEN payment_status = 'PAID' THEN 1 END) as total_transactions, " +
                    "((SUM(CASE WHEN payment_status = 'PAID' AND MONTH(payment_date) = MONTH(CURRENT_DATE) " +
                    "    AND YEAR(payment_date) = YEAR(CURRENT_DATE) THEN total_amount ELSE 0 END) - " +
                    "  SUM(CASE WHEN payment_status = 'PAID' AND MONTH(payment_date) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH) " +
                    "    AND YEAR(payment_date) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH) THEN total_amount ELSE 0 END)) / " +
                    "  NULLIF(SUM(CASE WHEN payment_status = 'PAID' AND MONTH(payment_date) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH) " +
                    "    AND YEAR(payment_date) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH) THEN total_amount ELSE 0 END), 0) * 100) as growth_percentage " +
                    "FROM payments";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                stats.put("totalRevenue", rs.getBigDecimal("total_revenue"));
                stats.put("monthlyRevenue", rs.getBigDecimal("monthly_revenue"));
                stats.put("averageTransaction", rs.getBigDecimal("average_transaction"));
                stats.put("totalTransactions", rs.getInt("total_transactions"));
                stats.put("growthPercentage", rs.getDouble("growth_percentage"));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting revenue statistics", ex);
            throw ex;
        }

        return stats;
    }

    /**
     * Get monthly revenue data for charts
     */
    public Map<String, Double> getMonthlyRevenue() throws SQLException {
        Map<String, Double> monthlyRevenue = new HashMap<>();
        String sql = "SELECT " +
                    "DATE_FORMAT(payment_date, '%Y-%m') as month_year, " +
                    "SUM(CASE WHEN payment_status = 'PAID' THEN total_amount ELSE 0 END) as revenue " +
                    "FROM payments " +
                    "WHERE payment_date >= DATE_SUB(CURRENT_DATE, INTERVAL 12 MONTH) " +
                    "GROUP BY DATE_FORMAT(payment_date, '%Y-%m') " +
                    "ORDER BY month_year";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                monthlyRevenue.put(rs.getString("month_year"), rs.getDouble("revenue"));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting monthly revenue", ex);
            throw ex;
        }

        return monthlyRevenue;
    }

    /**
     * Get daily revenue data for the last 30 days
     */
    public Map<String, Double> getDailyRevenue() throws SQLException {
        Map<String, Double> dailyRevenue = new HashMap<>();
        String sql = "SELECT " +
                    "DATE(payment_date) as payment_day, " +
                    "SUM(CASE WHEN payment_status = 'PAID' THEN total_amount ELSE 0 END) as revenue " +
                    "FROM payments " +
                    "WHERE payment_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY) " +
                    "GROUP BY DATE(payment_date) " +
                    "ORDER BY payment_day";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                dailyRevenue.put(rs.getString("payment_day"), rs.getDouble("revenue"));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting daily revenue", ex);
            throw ex;
        }

        return dailyRevenue;
    }

    /**
     * Get top services by revenue
     */
    public List<Map<String, Object>> getTopServicesByRevenue(int limit) throws SQLException {
        List<Map<String, Object>> topServices = new ArrayList<>();
        String sql = "SELECT " +
                    "s.service_id, " +
                    "s.name as service_name, " +
                    "SUM(pi.unit_price * pi.quantity) as revenue, " +
                    "COUNT(pi.payment_item_id) as transaction_count " +
                    "FROM services s " +
                    "JOIN payment_items pi ON s.service_id = pi.service_id " +
                    "JOIN payments p ON pi.payment_id = p.payment_id " +
                    "WHERE p.payment_status = 'PAID' " +
                    "GROUP BY s.service_id, s.name " +
                    "ORDER BY revenue DESC " +
                    "LIMIT ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> service = new HashMap<>();
                    service.put("serviceId", rs.getInt("service_id"));
                    service.put("serviceName", rs.getString("service_name"));
                    service.put("revenue", rs.getBigDecimal("revenue"));
                    service.put("transactionCount", rs.getInt("transaction_count"));
                    topServices.add(service);
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting top services by revenue", ex);
            throw ex;
        }

        return topServices;
    }

    /**
     * Get revenue breakdown by payment status
     */
    public Map<String, Double> getRevenueByStatus() throws SQLException {
        Map<String, Double> revenueByStatus = new HashMap<>();
        String sql = "SELECT " +
                    "payment_status, " +
                    "SUM(total_amount) as status_revenue " +
                    "FROM payments " +
                    "GROUP BY payment_status";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                revenueByStatus.put(rs.getString("payment_status"), rs.getDouble("status_revenue"));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting revenue by status", ex);
            throw ex;
        }

        return revenueByStatus;
    }

    /**
     * Get payment method counts
     */
    public Map<String, Integer> getPaymentMethodCounts() throws SQLException {
        Map<String, Integer> methodCounts = new HashMap<>();
        String sql = "SELECT " +
                    "payment_method, " +
                    "COUNT(*) as method_count " +
                    "FROM payments " +
                    "GROUP BY payment_method " +
                    "ORDER BY method_count DESC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                methodCounts.put(rs.getString("payment_method"), rs.getInt("method_count"));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting payment method counts", ex);
            throw ex;
        }

        return methodCounts;
    }

    /**
     * Get payment method revenue
     */
    public Map<String, Double> getPaymentMethodRevenue() throws SQLException {
        Map<String, Double> methodRevenue = new HashMap<>();
        String sql = "SELECT " +
                    "payment_method, " +
                    "SUM(CASE WHEN payment_status = 'PAID' THEN total_amount ELSE 0 END) as method_revenue " +
                    "FROM payments " +
                    "GROUP BY payment_method " +
                    "ORDER BY method_revenue DESC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                methodRevenue.put(rs.getString("payment_method"), rs.getDouble("method_revenue"));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting payment method revenue", ex);
            throw ex;
        }

        return methodRevenue;
    }

    /**
     * Get payment method trends over time
     */
    public Map<String, Map<String, Integer>> getPaymentMethodTrends() throws SQLException {
        Map<String, Map<String, Integer>> methodTrends = new HashMap<>();
        String sql = "SELECT " +
                    "payment_method, " +
                    "DATE_FORMAT(payment_date, '%Y-%m') as month_year, " +
                    "COUNT(*) as method_count " +
                    "FROM payments " +
                    "WHERE payment_date >= DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH) " +
                    "GROUP BY payment_method, DATE_FORMAT(payment_date, '%Y-%m') " +
                    "ORDER BY payment_method, month_year";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                String method = rs.getString("payment_method");
                String monthYear = rs.getString("month_year");
                int count = rs.getInt("method_count");

                methodTrends.computeIfAbsent(method, k -> new HashMap<>()).put(monthYear, count);
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting payment method trends", ex);
            throw ex;
        }

        return methodTrends;
    }

    /**
     * Get average transaction amount by payment method
     */
    public Map<String, Double> getAverageAmountByMethod() throws SQLException {
        Map<String, Double> avgAmountByMethod = new HashMap<>();
        String sql = "SELECT " +
                    "payment_method, " +
                    "AVG(CASE WHEN payment_status = 'PAID' THEN total_amount ELSE NULL END) as avg_amount " +
                    "FROM payments " +
                    "GROUP BY payment_method";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                avgAmountByMethod.put(rs.getString("payment_method"), rs.getDouble("avg_amount"));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting average amount by method", ex);
            throw ex;
        }

        return avgAmountByMethod;
    }

    /**
     * Get daily transaction counts for the last 30 days
     */
    public Map<String, Integer> getDailyTransactionCounts() throws SQLException {
        Map<String, Integer> dailyTransactions = new HashMap<>();
        String sql = "SELECT " +
                    "DATE(payment_date) as payment_day, " +
                    "COUNT(*) as transaction_count " +
                    "FROM payments " +
                    "WHERE payment_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY) " +
                    "GROUP BY DATE(payment_date) " +
                    "ORDER BY payment_day";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                dailyTransactions.put(rs.getString("payment_day"), rs.getInt("transaction_count"));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting daily transaction counts", ex);
            throw ex;
        }

        return dailyTransactions;
    }

    /**
     * Get monthly transaction counts for the last 12 months
     */
    public Map<String, Integer> getMonthlyTransactionCounts() throws SQLException {
        Map<String, Integer> monthlyTransactions = new HashMap<>();
        String sql = "SELECT " +
                    "DATE_FORMAT(payment_date, '%Y-%m') as month_year, " +
                    "COUNT(*) as transaction_count " +
                    "FROM payments " +
                    "WHERE payment_date >= DATE_SUB(CURRENT_DATE, INTERVAL 12 MONTH) " +
                    "GROUP BY DATE_FORMAT(payment_date, '%Y-%m') " +
                    "ORDER BY month_year";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                monthlyTransactions.put(rs.getString("month_year"), rs.getInt("transaction_count"));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting monthly transaction counts", ex);
            throw ex;
        }

        return monthlyTransactions;
    }

    /**
     * Get hourly transaction counts
     */
    public Map<String, Integer> getHourlyTransactionCounts() throws SQLException {
        Map<String, Integer> hourlyTransactions = new HashMap<>();
        String sql = "SELECT " +
                    "HOUR(payment_date) as payment_hour, " +
                    "COUNT(*) as transaction_count " +
                    "FROM payments " +
                    "WHERE payment_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY) " +
                    "GROUP BY HOUR(payment_date) " +
                    "ORDER BY payment_hour";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                hourlyTransactions.put(rs.getString("payment_hour"), rs.getInt("transaction_count"));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting hourly transaction counts", ex);
            throw ex;
        }

        return hourlyTransactions;
    }

    /**
     * Get peak time analysis
     */
    public Map<String, Object> getPeakTimeAnalysis() throws SQLException {
        Map<String, Object> peakAnalysis = new HashMap<>();

        // Get peak hour
        String peakHourSql = "SELECT " +
                           "HOUR(payment_date) as peak_hour, " +
                           "COUNT(*) as hour_transactions " +
                           "FROM payments " +
                           "WHERE payment_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY) " +
                           "GROUP BY HOUR(payment_date) " +
                           "ORDER BY hour_transactions DESC " +
                           "LIMIT 1";

        // Get peak day of week
        String peakDaySql = "SELECT " +
                          "DAYNAME(payment_date) as peak_day, " +
                          "COUNT(*) as day_transactions " +
                          "FROM payments " +
                          "WHERE payment_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY) " +
                          "GROUP BY DAYNAME(payment_date) " +
                          "ORDER BY day_transactions DESC " +
                          "LIMIT 1";

        try (Connection conn = DBContext.getConnection()) {

            // Get peak hour
            try (PreparedStatement stmt = conn.prepareStatement(peakHourSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    peakAnalysis.put("peakHour", rs.getInt("peak_hour"));
                    peakAnalysis.put("peakHourTransactions", rs.getInt("hour_transactions"));
                }
            }

            // Get peak day
            try (PreparedStatement stmt = conn.prepareStatement(peakDaySql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    peakAnalysis.put("peakDay", rs.getString("peak_day"));
                    peakAnalysis.put("peakDayTransactions", rs.getInt("day_transactions"));
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting peak time analysis", ex);
            throw ex;
        }

        return peakAnalysis;
    }

    /**
     * Get growth trends
     */
    public Map<String, Double> getGrowthTrends() throws SQLException {
        Map<String, Double> growthTrends = new HashMap<>();
        String sql = "SELECT " +
                    "((SUM(CASE WHEN MONTH(payment_date) = MONTH(CURRENT_DATE) " +
                    "    AND YEAR(payment_date) = YEAR(CURRENT_DATE) THEN total_amount ELSE 0 END) - " +
                    "  SUM(CASE WHEN MONTH(payment_date) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH) " +
                    "    AND YEAR(payment_date) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH) THEN total_amount ELSE 0 END)) / " +
                    "  NULLIF(SUM(CASE WHEN MONTH(payment_date) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH) " +
                    "    AND YEAR(payment_date) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH) THEN total_amount ELSE 0 END), 0) * 100) as monthly_growth, " +
                    "((SUM(CASE WHEN YEAR(payment_date) = YEAR(CURRENT_DATE) THEN total_amount ELSE 0 END) - " +
                    "  SUM(CASE WHEN YEAR(payment_date) = YEAR(CURRENT_DATE - INTERVAL 1 YEAR) THEN total_amount ELSE 0 END)) / " +
                    "  NULLIF(SUM(CASE WHEN YEAR(payment_date) = YEAR(CURRENT_DATE - INTERVAL 1 YEAR) THEN total_amount ELSE 0 END), 0) * 100) as yearly_growth " +
                    "FROM payments " +
                    "WHERE payment_status = 'PAID'";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                growthTrends.put("monthlyGrowth", rs.getDouble("monthly_growth"));
                growthTrends.put("yearlyGrowth", rs.getDouble("yearly_growth"));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting growth trends", ex);
            throw ex;
        }

        return growthTrends;
    }

    /**
     * Get top customers by revenue
     */
    public List<Map<String, Object>> getTopCustomersByRevenue(int limit) throws SQLException {
        List<Map<String, Object>> topCustomers = new ArrayList<>();
        String sql = "SELECT " +
                    "c.customer_id, " +
                    "c.full_name as customer_name, " +
                    "c.email, " +
                    "SUM(CASE WHEN p.payment_status = 'PAID' THEN p.total_amount ELSE 0 END) as total_spent, " +
                    "COUNT(p.payment_id) as transaction_count, " +
                    "AVG(CASE WHEN p.payment_status = 'PAID' THEN p.total_amount ELSE NULL END) as average_spent, " +
                    "MAX(p.payment_date) as last_visit " +
                    "FROM customers c " +
                    "LEFT JOIN payments p ON c.customer_id = p.customer_id " +
                    "GROUP BY c.customer_id, c.full_name, c.email " +
                    "HAVING total_spent > 0 " +
                    "ORDER BY total_spent DESC " +
                    "LIMIT ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> customer = new HashMap<>();
                    customer.put("customerId", rs.getInt("customer_id"));
                    customer.put("customerName", rs.getString("customer_name"));
                    customer.put("email", rs.getString("email"));
                    customer.put("totalSpent", rs.getBigDecimal("total_spent"));
                    customer.put("transactionCount", rs.getInt("transaction_count"));
                    customer.put("averageSpent", rs.getBigDecimal("average_spent"));
                    customer.put("lastVisit", rs.getTimestamp("last_visit"));
                    topCustomers.add(customer);
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting top customers by revenue", ex);
            throw ex;
        }

        return topCustomers;
    }

    /**
     * Get customer segments
     */
    public Map<String, Integer> getCustomerSegments() throws SQLException {
        Map<String, Integer> segments = new HashMap<>();
        String sql = "SELECT " +
                    "CASE " +
                    "    WHEN total_spent >= 5000000 THEN 'VIP' " +
                    "    WHEN total_spent >= 2000000 THEN 'Premium' " +
                    "    WHEN total_spent >= 500000 THEN 'Regular' " +
                    "    ELSE 'New' " +
                    "END as segment, " +
                    "COUNT(*) as segment_count " +
                    "FROM ( " +
                    "    SELECT " +
                    "        c.customer_id, " +
                    "        SUM(CASE WHEN p.payment_status = 'PAID' THEN p.total_amount ELSE 0 END) as total_spent " +
                    "    FROM customers c " +
                    "    LEFT JOIN payments p ON c.customer_id = p.customer_id " +
                    "    GROUP BY c.customer_id " +
                    ") customer_totals " +
                    "GROUP BY segment " +
                    "ORDER BY segment_count DESC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                segments.put(rs.getString("segment"), rs.getInt("segment_count"));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting customer segments", ex);
            throw ex;
        }

        return segments;
    }

    /**
     * Get customer behavior analysis
     */
    public Map<String, Object> getCustomerBehaviorAnalysis() throws SQLException {
        Map<String, Object> behavior = new HashMap<>();
        String sql = "SELECT " +
                    "COUNT(DISTINCT c.customer_id) as total_customers, " +
                    "AVG(customer_totals.total_spent) as average_ltv, " +
                    "AVG(customer_totals.transaction_count) as avg_transactions_per_customer, " +
                    "AVG(DATEDIFF(customer_totals.last_payment, customer_totals.first_payment)) as avg_customer_lifespan " +
                    "FROM customers c " +
                    "LEFT JOIN ( " +
                    "    SELECT " +
                    "        customer_id, " +
                    "        SUM(CASE WHEN payment_status = 'PAID' THEN total_amount ELSE 0 END) as total_spent, " +
                    "        COUNT(payment_id) as transaction_count, " +
                    "        MIN(payment_date) as first_payment, " +
                    "        MAX(payment_date) as last_payment " +
                    "    FROM payments " +
                    "    GROUP BY customer_id " +
                    ") customer_totals ON c.customer_id = customer_totals.customer_id";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                behavior.put("totalCustomers", rs.getInt("total_customers"));
                behavior.put("averageLTV", rs.getBigDecimal("average_ltv"));
                behavior.put("avgTransactionsPerCustomer", rs.getDouble("avg_transactions_per_customer"));
                behavior.put("avgCustomerLifespan", rs.getInt("avg_customer_lifespan"));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting customer behavior analysis", ex);
            throw ex;
        }

        return behavior;
    }

    /**
     * Get new vs returning customers
     */
    public Map<String, Integer> getNewVsReturningCustomers() throws SQLException {
        Map<String, Integer> customerTypes = new HashMap<>();
        String sql = "SELECT " +
                    "SUM(CASE WHEN MONTH(first_payment) = MONTH(CURRENT_DATE) " +
                    "    AND YEAR(first_payment) = YEAR(CURRENT_DATE) THEN 1 ELSE 0 END) as new_customers, " +
                    "SUM(CASE WHEN MONTH(first_payment) < MONTH(CURRENT_DATE) " +
                    "    OR YEAR(first_payment) < YEAR(CURRENT_DATE) THEN 1 ELSE 0 END) as returning_customers " +
                    "FROM ( " +
                    "    SELECT " +
                    "        customer_id, " +
                    "        MIN(payment_date) as first_payment " +
                    "    FROM payments " +
                    "    WHERE payment_status = 'PAID' " +
                    "    GROUP BY customer_id " +
                    ") customer_first_payments";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                customerTypes.put("newCustomers", rs.getInt("new_customers"));
                customerTypes.put("returningCustomers", rs.getInt("returning_customers"));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting new vs returning customers", ex);
            throw ex;
        }

        return customerTypes;
    }

    /**
     * Get customer lifetime value analysis
     */
    public List<Map<String, Object>> getCustomerLifetimeValue() throws SQLException {
        List<Map<String, Object>> ltvAnalysis = new ArrayList<>();
        String sql = "SELECT " +
                    "segment, " +
                    "COUNT(*) as customer_count, " +
                    "AVG(total_spent) as average_ltv, " +
                    "ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers), 2) as percentage " +
                    "FROM ( " +
                    "    SELECT " +
                    "        c.customer_id, " +
                    "        SUM(CASE WHEN p.payment_status = 'PAID' THEN p.total_amount ELSE 0 END) as total_spent, " +
                    "        CASE " +
                    "            WHEN SUM(CASE WHEN p.payment_status = 'PAID' THEN p.total_amount ELSE 0 END) >= 5000000 THEN 'VIP' " +
                    "            WHEN SUM(CASE WHEN p.payment_status = 'PAID' THEN p.total_amount ELSE 0 END) >= 2000000 THEN 'Premium' " +
                    "            WHEN SUM(CASE WHEN p.payment_status = 'PAID' THEN p.total_amount ELSE 0 END) >= 500000 THEN 'Regular' " +
                    "            ELSE 'New' " +
                    "        END as segment " +
                    "    FROM customers c " +
                    "    LEFT JOIN payments p ON c.customer_id = p.customer_id " +
                    "    GROUP BY c.customer_id " +
                    ") customer_segments " +
                    "GROUP BY segment " +
                    "ORDER BY average_ltv DESC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> segment = new HashMap<>();
                segment.put("segmentName", rs.getString("segment"));
                segment.put("customerCount", rs.getInt("customer_count"));
                segment.put("averageLTV", rs.getBigDecimal("average_ltv"));
                segment.put("percentage", rs.getDouble("percentage"));
                ltvAnalysis.add(segment);
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting customer lifetime value", ex);
            throw ex;
        }

        return ltvAnalysis;
    }

    /**
     * Get service performance data
     */
    public List<Map<String, Object>> getServicePerformanceData() throws SQLException {
        List<Map<String, Object>> servicePerformance = new ArrayList<>();
        String sql = "SELECT " +
                    "s.service_id, " +
                    "s.name as service_name, " +
                    "COUNT(pi.payment_item_id) as booking_count, " +
                    "SUM(pi.unit_price * pi.quantity) as total_revenue, " +
                    "AVG(pi.unit_price * pi.quantity) as average_revenue, " +
                    "SUM(pi.quantity) as total_quantity, " +
                    "COALESCE(growth.growth_rate, 0) as growth_rate " +
                    "FROM services s " +
                    "LEFT JOIN payment_items pi ON s.service_id = pi.service_id " +
                    "LEFT JOIN payments p ON pi.payment_id = p.payment_id AND p.payment_status = 'PAID' " +
                    "LEFT JOIN ( " +
                    "    SELECT " +
                    "        s2.service_id, " +
                    "        ROUND(((current_month.revenue - previous_month.revenue) / " +
                    "               NULLIF(previous_month.revenue, 0) * 100), 2) as growth_rate " +
                    "    FROM services s2 " +
                    "    LEFT JOIN ( " +
                    "        SELECT " +
                    "            pi2.service_id, " +
                    "            SUM(pi2.unit_price * pi2.quantity) as revenue " +
                    "        FROM payment_items pi2 " +
                    "        JOIN payments p2 ON pi2.payment_id = p2.payment_id " +
                    "        WHERE p2.payment_status = 'PAID' " +
                    "            AND MONTH(p2.payment_date) = MONTH(CURRENT_DATE) " +
                    "            AND YEAR(p2.payment_date) = YEAR(CURRENT_DATE) " +
                    "        GROUP BY pi2.service_id " +
                    "    ) current_month ON s2.service_id = current_month.service_id " +
                    "    LEFT JOIN ( " +
                    "        SELECT " +
                    "            pi3.service_id, " +
                    "            SUM(pi3.unit_price * pi3.quantity) as revenue " +
                    "        FROM payment_items pi3 " +
                    "        JOIN payments p3 ON pi3.payment_id = p3.payment_id " +
                    "        WHERE p3.payment_status = 'PAID' " +
                    "            AND MONTH(p3.payment_date) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH) " +
                    "            AND YEAR(p3.payment_date) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH) " +
                    "        GROUP BY pi3.service_id " +
                    "    ) previous_month ON s2.service_id = previous_month.service_id " +
                    ") growth ON s.service_id = growth.service_id " +
                    "GROUP BY s.service_id, s.name, growth.growth_rate " +
                    "ORDER BY total_revenue DESC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> service = new HashMap<>();
                service.put("serviceId", rs.getInt("service_id"));
                service.put("serviceName", rs.getString("service_name"));
                service.put("bookingCount", rs.getInt("booking_count"));
                service.put("totalRevenue", rs.getBigDecimal("total_revenue"));
                service.put("averageRevenue", rs.getBigDecimal("average_revenue"));
                service.put("totalQuantity", rs.getInt("total_quantity"));
                service.put("growthRate", rs.getDouble("growth_rate"));
                servicePerformance.add(service);
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting service performance data", ex);
            throw ex;
        }

        return servicePerformance;
    }

    /**
     * Get service popularity trends
     */
    public Map<String, Map<String, Integer>> getServicePopularityTrends() throws SQLException {
        Map<String, Map<String, Integer>> serviceTrends = new HashMap<>();
        String sql = "SELECT " +
                    "s.name as service_name, " +
                    "DATE_FORMAT(p.payment_date, '%Y-%m') as month_year, " +
                    "COUNT(pi.payment_item_id) as booking_count " +
                    "FROM services s " +
                    "JOIN payment_items pi ON s.service_id = pi.service_id " +
                    "JOIN payments p ON pi.payment_id = p.payment_id " +
                    "WHERE p.payment_status = 'PAID' " +
                    "    AND p.payment_date >= DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH) " +
                    "GROUP BY s.service_id, s.name, DATE_FORMAT(p.payment_date, '%Y-%m') " +
                    "ORDER BY s.name, month_year";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                String serviceName = rs.getString("service_name");
                String monthYear = rs.getString("month_year");
                int bookingCount = rs.getInt("booking_count");

                serviceTrends.computeIfAbsent(serviceName, k -> new HashMap<>()).put(monthYear, bookingCount);
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting service popularity trends", ex);
            throw ex;
        }

        return serviceTrends;
    }

    /**
     * Get service revenue breakdown
     */
    public Map<String, Double> getServiceRevenueBreakdown() throws SQLException {
        Map<String, Double> serviceRevenue = new HashMap<>();
        String sql = "SELECT " +
                    "s.name as service_name, " +
                    "SUM(pi.unit_price * pi.quantity) as service_revenue " +
                    "FROM services s " +
                    "JOIN payment_items pi ON s.service_id = pi.service_id " +
                    "JOIN payments p ON pi.payment_id = p.payment_id " +
                    "WHERE p.payment_status = 'PAID' " +
                    "GROUP BY s.service_id, s.name " +
                    "ORDER BY service_revenue DESC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                serviceRevenue.put(rs.getString("service_name"), rs.getDouble("service_revenue"));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting service revenue breakdown", ex);
            throw ex;
        }

        return serviceRevenue;
    }

    /**
     * Get service utilization rates
     */
    public Map<String, Double> getServiceUtilizationRates() throws SQLException {
        Map<String, Double> utilizationRates = new HashMap<>();
        String sql = "SELECT " +
                    "s.name as service_name, " +
                    "ROUND((COUNT(pi.payment_item_id) * 100.0 / " +
                    "       (SELECT COUNT(*) FROM payment_items pi2 " +
                    "        JOIN payments p2 ON pi2.payment_id = p2.payment_id " +
                    "        WHERE p2.payment_status = 'PAID')), 2) as utilization_rate " +
                    "FROM services s " +
                    "LEFT JOIN payment_items pi ON s.service_id = pi.service_id " +
                    "LEFT JOIN payments p ON pi.payment_id = p.payment_id AND p.payment_status = 'PAID' " +
                    "GROUP BY s.service_id, s.name " +
                    "ORDER BY utilization_rate DESC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                utilizationRates.put(rs.getString("service_name"), rs.getDouble("utilization_rate"));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting service utilization rates", ex);
            throw ex;
        }

        return utilizationRates;
    }

    /**
     * Get seasonal service analysis
     */
    public Map<String, Map<String, Integer>> getSeasonalServiceAnalysis() throws SQLException {
        Map<String, Map<String, Integer>> seasonalAnalysis = new HashMap<>();
        String sql = "SELECT " +
                    "s.name as service_name, " +
                    "CASE " +
                    "    WHEN MONTH(p.payment_date) IN (3, 4, 5) THEN 'Spring' " +
                    "    WHEN MONTH(p.payment_date) IN (6, 7, 8) THEN 'Summer' " +
                    "    WHEN MONTH(p.payment_date) IN (9, 10, 11) THEN 'Fall' " +
                    "    ELSE 'Winter' " +
                    "END as season, " +
                    "COUNT(pi.payment_item_id) as booking_count " +
                    "FROM services s " +
                    "JOIN payment_items pi ON s.service_id = pi.service_id " +
                    "JOIN payments p ON pi.payment_id = p.payment_id " +
                    "WHERE p.payment_status = 'PAID' " +
                    "    AND p.payment_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR) " +
                    "GROUP BY s.service_id, s.name, season " +
                    "ORDER BY s.name, season";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                String serviceName = rs.getString("service_name");
                String season = rs.getString("season");
                int bookingCount = rs.getInt("booking_count");

                seasonalAnalysis.computeIfAbsent(serviceName, k -> new HashMap<>()).put(season, bookingCount);
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting seasonal service analysis", ex);
            throw ex;
        }

        return seasonalAnalysis;
    }

}
