package dao;

import java.math.BigDecimal;
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

import db.DBContext;
import model.PromotionUsage;

public class PromotionUsageDAO {
    private static final Logger logger = Logger.getLogger(PromotionUsageDAO.class.getName());

    /**
     * Map ResultSet to PromotionUsage object
     */
    private PromotionUsage mapResultSet(ResultSet rs) throws SQLException {
        PromotionUsage usage = new PromotionUsage();
        usage.setUsageId(rs.getInt("usage_id"));
        usage.setPromotionId(rs.getInt("promotion_id"));
        usage.setCustomerId(rs.getInt("customer_id"));
        
        Integer paymentId = (Integer) rs.getObject("payment_id");
        usage.setPaymentId(paymentId);
        
        Integer bookingId = (Integer) rs.getObject("booking_id");
        usage.setBookingId(bookingId);
        
        usage.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        usage.setOriginalAmount(rs.getBigDecimal("original_amount"));
        usage.setFinalAmount(rs.getBigDecimal("final_amount"));
        usage.setUsedAt(rs.getTimestamp("used_at"));
        usage.setCreatedAt(rs.getTimestamp("created_at"));
        usage.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        return usage;
    }

    /**
     * Save promotion usage record
     */
    public boolean save(PromotionUsage usage) {
        String sql = "INSERT INTO promotion_usage_history (promotion_id, customer_id, payment_id, booking_id, " +
                    "discount_amount, original_amount, final_amount, used_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, usage.getPromotionId());
            ps.setInt(2, usage.getCustomerId());
            
            if (usage.getPaymentId() != null) {
                ps.setInt(3, usage.getPaymentId());
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            
            if (usage.getBookingId() != null) {
                ps.setInt(4, usage.getBookingId());
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            
            ps.setBigDecimal(5, usage.getDiscountAmount());
            ps.setBigDecimal(6, usage.getOriginalAmount());
            ps.setBigDecimal(7, usage.getFinalAmount());
            ps.setTimestamp(8, usage.getUsedAt());
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        usage.setUsageId(rs.getInt(1));
                    }
                }
                return true;
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error saving promotion usage", e);
        }
        return false;
    }

    /**
     * Check if customer has already used this promotion
     */
    public boolean hasCustomerUsedPromotion(Integer promotionId, Integer customerId) {
        String sql = "SELECT COUNT(*) FROM promotion_usage_history WHERE promotion_id = ? AND customer_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, promotionId);
            ps.setInt(2, customerId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking promotion usage", e);
        }
        return false;
    }

    /**
     * Get number of times customer has used this promotion
     */
    public int getCustomerUsageCount(Integer promotionId, Integer customerId) {
        String sql = "SELECT COUNT(*) FROM promotion_usage_history WHERE promotion_id = ? AND customer_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, promotionId);
            ps.setInt(2, customerId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting customer usage count", e);
        }
        return 0;
    }

    /**
     * Get total promotion usage count
     */
    public int getTotalUsageCount(Integer promotionId) {
        String sql = "SELECT COUNT(*) FROM promotion_usage_history WHERE promotion_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, promotionId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting total usage count", e);
        }
        return 0;
    }

    /**
     * Get promotion usage history for a customer
     */
    public List<PromotionUsage> getCustomerUsageHistory(Integer customerId, int page, int pageSize) {
        List<PromotionUsage> usageHistory = new ArrayList<>();
        String sql = "SELECT * FROM promotion_usage_history WHERE customer_id = ? ORDER BY used_at DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, customerId);
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    usageHistory.add(mapResultSet(rs));
                }
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting customer usage history", e);
        }
        return usageHistory;
    }

    /**
     * Get usage history for a specific promotion
     */
    public List<PromotionUsage> getPromotionUsageHistory(Integer promotionId, int page, int pageSize) {
        List<PromotionUsage> usageHistory = new ArrayList<>();
        String sql = "SELECT * FROM promotion_usage_history WHERE promotion_id = ? ORDER BY used_at DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, promotionId);
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    usageHistory.add(mapResultSet(rs));
                }
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting promotion usage history", e);
        }
        return usageHistory;
    }

    /**
     * Get promotion usage with detailed info (with joins)
     */
    public List<PromotionUsage> getPromotionUsageWithDetails(Integer promotionId, int page, int pageSize) {
        List<PromotionUsage> usageHistory = new ArrayList<>();
        String sql = "SELECT pu.*, p.title as promotion_title, p.promotion_code, " +
                    "c.full_name as customer_name, c.email as customer_email " +
                    "FROM promotion_usage_history pu " +
                    "JOIN promotions p ON pu.promotion_id = p.promotion_id " +
                    "JOIN customers c ON pu.customer_id = c.customer_id " +
                    "WHERE pu.promotion_id = ? " +
                    "ORDER BY pu.used_at DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, promotionId);
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PromotionUsage usage = mapResultSet(rs);
                    // You can add additional mapping for joined fields here if needed
                    usageHistory.add(usage);
                }
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting promotion usage with details", e);
        }
        return usageHistory;
    }

    /**
     * Calculate total discount amount for a promotion
     */
    public BigDecimal getTotalDiscountAmount(Integer promotionId) {
        String sql = "SELECT SUM(discount_amount) FROM promotion_usage_history WHERE promotion_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, promotionId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BigDecimal total = rs.getBigDecimal(1);
                    return total != null ? total : BigDecimal.ZERO;
                }
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error calculating total discount amount", e);
        }
        return BigDecimal.ZERO;
    }

    /**
     * Delete promotion usage record
     */
    public boolean deleteById(Integer usageId) {
        String sql = "DELETE FROM promotion_usage_history WHERE usage_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, usageId);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting promotion usage", e);
        }
        return false;
    }

    /**
     * Find promotion usage by ID
     */
    public Optional<PromotionUsage> findById(Integer usageId) {
        String sql = "SELECT * FROM promotion_usage_history WHERE usage_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, usageId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSet(rs));
                }
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding promotion usage by ID", e);
        }
        return Optional.empty();
    }

    /**
     * Get remaining usage count for a customer for a specific promotion
     * @param promotionId The promotion ID
     * @param customerId The customer ID
     * @return Remaining usage count (null if unlimited, 0 if used up, positive number if still available)
     */
    public Integer getRemainingUsageCount(Integer promotionId, Integer customerId) {
        String sql = "SELECT p.usage_limit_per_customer, COUNT(pu.usage_id) as used_count " +
                    "FROM promotions p " +
                    "LEFT JOIN promotion_usage_history pu ON p.promotion_id = pu.promotion_id AND pu.customer_id = ? " +
                    "WHERE p.promotion_id = ? " +
                    "GROUP BY p.promotion_id, p.usage_limit_per_customer";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, customerId);
            ps.setInt(2, promotionId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Integer usageLimit = (Integer) rs.getObject("usage_limit_per_customer");
                    int usedCount = rs.getInt("used_count");
                    
                    if (usageLimit == null) {
                        return null; // Unlimited
                    } else {
                        return Math.max(0, usageLimit - usedCount);
                    }
                }
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting remaining usage count", e);
        }
        return 0;
    }

    /**
     * Get all promotions with remaining usage count for a customer
     * @param customerId The customer ID
     * @return List of maps containing promotion info and remaining usage
     */
    public List<java.util.Map<String, Object>> getCustomerPromotionsWithRemainingCount(Integer customerId) {
        List<java.util.Map<String, Object>> promotions = new ArrayList<>();
        String sql = "SELECT p.promotion_id, p.title, p.promotion_code, p.discount_type, " +
                    "p.discount_value, p.usage_limit_per_customer, p.status, p.start_date, p.end_date, " +
                    "COUNT(pu.usage_id) as used_count, " +
                    "CASE " +
                    "  WHEN p.usage_limit_per_customer IS NULL THEN NULL " +
                    "  ELSE GREATEST(0, p.usage_limit_per_customer - COUNT(pu.usage_id)) " +
                    "END as remaining_count " +
                    "FROM promotions p " +
                    "LEFT JOIN promotion_usage_history pu ON p.promotion_id = pu.promotion_id AND pu.customer_id = ? " +
                    "WHERE p.status = 'ACTIVE' " +
                    "GROUP BY p.promotion_id, p.title, p.promotion_code, p.discount_type, " +
                    "p.discount_value, p.usage_limit_per_customer, p.status, p.start_date, p.end_date " +
                    "ORDER BY p.start_date DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    java.util.Map<String, Object> promotion = new java.util.HashMap<>();
                    promotion.put("promotionId", rs.getInt("promotion_id"));
                    promotion.put("title", rs.getString("title"));
                    promotion.put("promotionCode", rs.getString("promotion_code"));
                    promotion.put("discountType", rs.getString("discount_type"));
                    promotion.put("discountValue", rs.getBigDecimal("discount_value"));
                    promotion.put("usageLimitPerCustomer", rs.getObject("usage_limit_per_customer"));
                    promotion.put("status", rs.getString("status"));
                    promotion.put("startDate", rs.getTimestamp("start_date"));
                    promotion.put("endDate", rs.getTimestamp("end_date"));
                    promotion.put("usedCount", rs.getInt("used_count"));
                    Object remaining = rs.getObject("remaining_count");
                    promotion.put("remainingCount", remaining != null ? remaining : 0);
                    promotions.add(promotion);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting customer promotions with remaining count", e);
        } catch (Exception ex) {
            logger.log(Level.SEVERE, "Unexpected error in getCustomerPromotionsWithRemainingCount", ex);
        }
        return promotions;
    }

    public java.util.Map<String, Object> getCustomerPromotionSummary(Integer customerId) {
        java.util.Map<String, Object> summary = new java.util.HashMap<>();
        String sql = "SELECT " +
                    "COUNT(DISTINCT p.promotion_id) as total_promotions, " +
                    "SUM(CASE WHEN p.usage_limit_per_customer IS NULL THEN 1 ELSE 0 END) as unlimited_promotions, " +
                    "SUM(CASE " +
                    "  WHEN p.usage_limit_per_customer IS NULL THEN 0 " +
                    "  ELSE GREATEST(0, p.usage_limit_per_customer - COALESCE(pu.used_count, 0)) " +
                    "END) as total_remaining_uses " +
                    "FROM promotions p " +
                    "LEFT JOIN ( " +
                    "  SELECT promotion_id, COUNT(*) as used_count " +
                    "  FROM promotion_usage_history " +
                    "  WHERE customer_id = ? " +
                    "  GROUP BY promotion_id " +
                    ") pu ON p.promotion_id = pu.promotion_id " +
                    "WHERE p.status = 'ACTIVE'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    summary.put("totalPromotions", rs.getInt("total_promotions"));
                    summary.put("unlimitedPromotions", rs.getInt("unlimited_promotions"));
                    summary.put("totalRemainingUses", rs.getInt("total_remaining_uses"));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting customer promotion summary", e);
        } catch (Exception ex) {
            logger.log(Level.SEVERE, "Unexpected error in getCustomerPromotionSummary", ex);
        }
        // Đảm bảo luôn trả về giá trị mặc định nếu thiếu
        if (!summary.containsKey("totalPromotions")) summary.put("totalPromotions", 0);
        if (!summary.containsKey("unlimitedPromotions")) summary.put("unlimitedPromotions", 0);
        if (!summary.containsKey("totalRemainingUses")) summary.put("totalRemainingUses", 0);
        return summary;
    }
} 
 
 