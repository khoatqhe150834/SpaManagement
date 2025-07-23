package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import db.DBContext;
import model.Promotion;

public class PromotionDAO {
    private static final Logger logger = Logger.getLogger(PromotionDAO.class.getName());
    private static Boolean customerConditionColumnExists = null;
    
    // Utility method to check if customer_condition column exists
    private boolean hasCustomerConditionColumn() {
        if (customerConditionColumnExists != null) {
            return customerConditionColumnExists;
        }
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT customer_condition FROM promotions LIMIT 1")) {
            ps.executeQuery();
            customerConditionColumnExists = true;
            return true;
        } catch (SQLException e) {
            customerConditionColumnExists = false;
            logger.warning("Column 'customer_condition' not found in promotions table. Please run add_customer_condition_column.sql to add this column.");
            return false;
        }
    }

    private Promotion mapResultSet(ResultSet rs) throws SQLException {
        Promotion promotion = new Promotion();
        promotion.setPromotionId(rs.getInt("promotion_id"));
        promotion.setTitle(rs.getString("title") != null ? rs.getString("title") : "");
        promotion.setDescription(rs.getString("description") != null ? rs.getString("description") : "");
        promotion.setPromotionCode(rs.getString("promotion_code") != null ? rs.getString("promotion_code") : "");
        promotion.setDiscountType(rs.getString("discount_type") != null ? rs.getString("discount_type") : "");
        promotion.setDiscountValue(rs.getBigDecimal("discount_value") != null ? rs.getBigDecimal("discount_value") : java.math.BigDecimal.ZERO);
        promotion.setAppliesToServiceId((Integer) rs.getObject("applies_to_service_id"));
        promotion.setMinimumAppointmentValue(rs.getBigDecimal("minimum_appointment_value") != null ? rs.getBigDecimal("minimum_appointment_value") : java.math.BigDecimal.ZERO);
        if (rs.getTimestamp("start_date") != null) {
            promotion.setStartDate(rs.getTimestamp("start_date").toLocalDateTime());
        } else {
            promotion.setStartDate(null);
        }
        if (rs.getTimestamp("end_date") != null) {
            promotion.setEndDate(rs.getTimestamp("end_date").toLocalDateTime());
        } else {
            promotion.setEndDate(null);
        }
        promotion.setStatus(rs.getString("status") != null ? rs.getString("status") : "INACTIVE");
        promotion.setUsageLimitPerCustomer((Integer) rs.getObject("usage_limit_per_customer") != null ? rs.getInt("usage_limit_per_customer") : 0);
        promotion.setTotalUsageLimit((Integer) rs.getObject("total_usage_limit") != null ? rs.getInt("total_usage_limit") : 0);
        promotion.setCurrentUsageCount(rs.getObject("current_usage_count") != null ? rs.getInt("current_usage_count") : 0);
        promotion.setApplicableScope(rs.getString("applicable_scope") != null ? rs.getString("applicable_scope") : "ENTIRE_APPOINTMENT");
        try {
            promotion.setCustomerCondition(rs.getString("customer_condition") != null ? rs.getString("customer_condition") : "ALL");
        } catch (SQLException e) {
            promotion.setCustomerCondition("ALL");
        }
        promotion.setApplicableServiceIdsJson(rs.getString("applicable_service_ids_json"));
        promotion.setImageUrl(rs.getString("image_url"));
        promotion.setTermsAndConditions(rs.getString("terms_and_conditions"));
        promotion.setCreatedByUserId((Integer) rs.getObject("created_by_user_id"));
        promotion.setIsAutoApply(rs.getBoolean("is_auto_apply"));
        if (rs.getTimestamp("created_at") != null) {
            promotion.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        } else {
            promotion.setCreatedAt(null);
        }
        if (rs.getTimestamp("updated_at") != null) {
            promotion.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        } else {
            promotion.setUpdatedAt(null);
        }
        return promotion;
    }

    // Thêm khuyến mãi mới
    public boolean save(Promotion p) {
        String sql;
        boolean hasCustomerCondition = hasCustomerConditionColumn();
        
        if (hasCustomerCondition) {
            sql = "INSERT INTO promotions (title, promotion_code, discount_type, discount_value, description, status, start_date, end_date, current_usage_count, is_auto_apply, minimum_appointment_value, applicable_scope, customer_condition, image_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        } else {
            sql = "INSERT INTO promotions (title, promotion_code, discount_type, discount_value, description, status, start_date, end_date, current_usage_count, is_auto_apply, minimum_appointment_value, applicable_scope, image_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        }
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            logger.info("Saving promotion: " + p.getTitle() + " with code: " + p.getPromotionCode());
            
            ps.setString(1, p.getTitle());
            ps.setString(2, p.getPromotionCode());
            ps.setString(3, p.getDiscountType());
            ps.setBigDecimal(4, p.getDiscountValue());
            ps.setString(5, p.getDescription());
            ps.setString(6, p.getStatus());
            ps.setTimestamp(7, Timestamp.valueOf(p.getStartDate()));
            ps.setTimestamp(8, Timestamp.valueOf(p.getEndDate()));
            ps.setInt(9, p.getCurrentUsageCount() != null ? p.getCurrentUsageCount() : 0);
            ps.setBoolean(10, p.getIsAutoApply() != null ? p.getIsAutoApply() : false);
            ps.setBigDecimal(11, p.getMinimumAppointmentValue() != null ? p.getMinimumAppointmentValue() : BigDecimal.ZERO);
            ps.setString(12, p.getApplicableScope());
            
            if (hasCustomerCondition) {
                ps.setString(13, p.getCustomerCondition() != null ? p.getCustomerCondition() : "ALL");
                ps.setString(14, p.getImageUrl());
            } else {
                ps.setString(13, p.getImageUrl());
            }
            
            int row = ps.executeUpdate();
            logger.info("Rows affected: " + row);
            
            if (row > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int generatedId = rs.getInt(1);
                    p.setPromotionId(generatedId);
                    logger.info("Generated promotion ID: " + generatedId);
                }
                return true;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Save Promotion Error: " + e.getMessage(), e);
        }
        return false;
    }

    // Update khuyến mãi
    public boolean update(Promotion p) {
        String sql;
        boolean hasCustomerCondition = hasCustomerConditionColumn();
        
        if (hasCustomerCondition) {
            sql = "UPDATE promotions SET title=?, promotion_code=?, discount_type=?, discount_value=?, description=?, status=?, start_date=?, end_date=?, current_usage_count=?, is_auto_apply=?, minimum_appointment_value=?, applicable_scope=?, customer_condition=?, image_url=? WHERE promotion_id=?";
        } else {
            sql = "UPDATE promotions SET title=?, promotion_code=?, discount_type=?, discount_value=?, description=?, status=?, start_date=?, end_date=?, current_usage_count=?, is_auto_apply=?, minimum_appointment_value=?, applicable_scope=?, image_url=? WHERE promotion_id=?";
        }
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getTitle());
            ps.setString(2, p.getPromotionCode());
            ps.setString(3, p.getDiscountType());
            ps.setBigDecimal(4, p.getDiscountValue());
            ps.setString(5, p.getDescription());
            ps.setString(6, p.getStatus());
            ps.setTimestamp(7, Timestamp.valueOf(p.getStartDate()));
            ps.setTimestamp(8, Timestamp.valueOf(p.getEndDate()));
            ps.setInt(9, p.getCurrentUsageCount() != null ? p.getCurrentUsageCount() : 0);
            ps.setBoolean(10, p.getIsAutoApply() != null ? p.getIsAutoApply() : false);
            ps.setBigDecimal(11, p.getMinimumAppointmentValue() != null ? p.getMinimumAppointmentValue() : BigDecimal.ZERO);
            ps.setString(12, p.getApplicableScope());
            
            if (hasCustomerCondition) {
                ps.setString(13, p.getCustomerCondition() != null ? p.getCustomerCondition() : "ALL");
                ps.setString(14, p.getImageUrl());
                ps.setInt(15, p.getPromotionId());
            } else {
                ps.setString(13, p.getImageUrl());
                ps.setInt(14, p.getPromotionId());
            }
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Update Promotion Error", e);
        }
        return false;
    }

    // Xóa khuyến mãi theo ID
    public boolean deleteById(int id) {
        String sql = "DELETE FROM promotions WHERE promotion_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Delete Promotion Error", e);
        }
        return false;
    }

    // Lấy khuyến mãi theo ID
    public Optional<Promotion> findById(int id) {
        String sql = "SELECT * FROM promotions WHERE promotion_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Promotion promotion = mapResultSet(rs);
                
                // Đảm bảo các giá trị null được xử lý an toàn
                if (promotion.getCurrentUsageCount() == null) {
                    promotion.setCurrentUsageCount(0);
                }
                if (promotion.getUsageLimitPerCustomer() == null) {
                    promotion.setUsageLimitPerCustomer(0);
                }
                if (promotion.getTotalUsageLimit() == null) {
                    promotion.setTotalUsageLimit(0);
                }
                if (promotion.getMinimumAppointmentValue() == null) {
                    promotion.setMinimumAppointmentValue(BigDecimal.ZERO);
                }
                if (promotion.getCustomerCondition() == null) {
                    promotion.setCustomerCondition("ALL");
                }
                
                return Optional.of(promotion);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "FindById Promotion Error", e);
        }
        return Optional.empty();
    }

    // Lấy danh sách khuyến mãi (phân trang, sort)
    public List<Promotion> findAll(String status, int page, int pageSize, String sortBy, String sortOrder) {
        List<Promotion> promotions = new ArrayList<>();
        String sql = "SELECT * FROM promotions WHERE 1=1";
        
        if (status != null && !status.isEmpty()) {
            sql += " AND status = ?";
        }
        
        // Add sorting
        if (sortBy != null && !sortBy.isEmpty()) {
            String sortColumn = switch (sortBy) {
                case "id" -> "promotion_id";
                case "title" -> "title";
                case "status" -> "status";
                case "code" -> "promotion_code";
                case "discount" -> "discount_value";
                default -> "promotion_id";
            };
            sql += " ORDER BY " + sortColumn + " " + (sortOrder != null && sortOrder.equalsIgnoreCase("desc") ? "DESC" : "ASC");
        }
        
        sql += " LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            int paramIndex = 1;
            if (status != null && !status.isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            ps.setInt(paramIndex++, pageSize);
            ps.setInt(paramIndex, (page - 1) * pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    promotions.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding all promotions", e);
        }
        return promotions;
    }

    // Tìm kiếm khuyến mãi (search)
    public List<Promotion> search(String searchValue, String status, int page, int pageSize, String sortBy, String sortOrder) {
        List<Promotion> promotions = new ArrayList<>();
        String sql = "SELECT * FROM promotions WHERE (title LIKE ? OR promotion_code LIKE ?)";
        
        if (status != null && !status.isEmpty()) {
            sql += " AND status = ?";
        }
        
        // Add sorting
        if (sortBy != null && !sortBy.isEmpty()) {
            String sortColumn = switch (sortBy) {
                case "id" -> "promotion_id";
                case "title" -> "title";
                case "status" -> "status";
                case "code" -> "promotion_code";
                case "discount" -> "discount_value";
                default -> "promotion_id";
            };
            sql += " ORDER BY " + sortColumn + " " + (sortOrder != null && sortOrder.equalsIgnoreCase("desc") ? "DESC" : "ASC");
        }
        
        sql += " LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + searchValue + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            
            int paramIndex = 3;
            if (status != null && !status.isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            ps.setInt(paramIndex++, pageSize);
            ps.setInt(paramIndex, (page - 1) * pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    promotions.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error searching promotions", e);
        }
        return promotions;
    }

    // Lọc theo trạng thái (status)
    public List<Promotion> findByStatus(String status, int page, int pageSize, String sortBy, String sortOrder) {
        List<Promotion> list = new ArrayList<>();
        if (sortBy == null || sortBy.isBlank()) sortBy = "created_at";
        if (sortOrder == null || !(sortOrder.equalsIgnoreCase("ASC") || sortOrder.equalsIgnoreCase("DESC"))) sortOrder = "DESC";
        String sql = "SELECT * FROM promotions WHERE status = ? ORDER BY " + sortBy + " " + sortOrder + " LIMIT ? OFFSET ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status.toUpperCase());
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapResultSet(rs));
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "FindByStatus Promotion Error", e);
        }
        return list;
    }

    // Tổng số bản ghi cho phân trang
    public int getTotalPromotions() {
        String sql = "SELECT COUNT(*) FROM promotions";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "GetTotalPromotions Error", e);
        }
        return 0;
    }

    // Tổng số bản ghi theo search
    public int getTotalSearchResults(String keyword) {
        String sql = "SELECT COUNT(*) FROM promotions WHERE title LIKE ? OR description LIKE ? OR promotion_code LIKE ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "GetTotalSearchResults Error", e);
        }
        return 0;
    }

    // Tổng số bản ghi theo status
    public int getTotalPromotionsByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM promotions WHERE status = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "GetTotalPromotionsByStatus Error", e);
        }
        return 0;
    }
    
  public boolean deactivatePromotion(int promotionId) {
    String sql = "UPDATE promotions SET status = 'INACTIVE', updated_at = ? WHERE promotion_id = ?";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
        ps.setInt(2, promotionId);
        int rowsAffected = ps.executeUpdate();
        return rowsAffected > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}
    
     public boolean activatePromotion(int  promotionId) {
        String sql = "UPDATE promotions SET status = 'ACTIVE', updated_at = ? WHERE promotion_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setInt(2,  promotionId);
            int rowsAffected = ps.executeUpdate();
           
            return rowsAffected > 0;
        } catch (SQLException e) {
            return false;
        }
    }
      public boolean scheduledPromotion(int  promotionId) {
        String sql = "UPDATE promotions SET status = 'SCHEDULED', updated_at = ? WHERE promotion_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setInt(2,  promotionId);
            int rowsAffected = ps.executeUpdate();
           
            return rowsAffected > 0;
        } catch (SQLException e) {
            return false;
        }
    }

  public Optional<Promotion> findByCode(String promotionCode) {
        String sql = "SELECT * FROM promotions WHERE promotion_code = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, promotionCode);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Nếu tìm thấy, map dữ liệu từ ResultSet sang đối tượng Promotion
                    Promotion promotion = mapResultSet(rs);
                    return Optional.of(promotion);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error finding promotion by code: " + promotionCode, e);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "An unexpected error occurred finding promotion by code: " + promotionCode, e);
        }
        
        // Trả về Optional rỗng nếu không tìm thấy hoặc có lỗi xảy ra
        return Optional.empty();
    }

  // Tìm promotion theo tên (không phân biệt chữ hoa/thường)
  public Optional<Promotion> findByTitleIgnoreCase(String title) {
        String sql = "SELECT * FROM promotions WHERE LOWER(title) = LOWER(?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, title);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Nếu tìm thấy, map dữ liệu từ ResultSet sang đối tượng Promotion
                    Promotion promotion = mapResultSet(rs);
                    return Optional.of(promotion);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error finding promotion by title (ignore case): " + title, e);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "An unexpected error occurred finding promotion by title (ignore case): " + title, e);
        }
        
        // Trả về Optional rỗng nếu không tìm thấy hoặc có lỗi xảy ra
        return Optional.empty();
    }

  // Tìm promotion theo mã (không phân biệt chữ hoa/thường)
  public Optional<Promotion> findByCodeIgnoreCase(String promotionCode) {
        String sql = "SELECT * FROM promotions WHERE LOWER(promotion_code) = LOWER(?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, promotionCode);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Nếu tìm thấy, map dữ liệu từ ResultSet sang đối tượng Promotion
                    Promotion promotion = mapResultSet(rs);
                    return Optional.of(promotion);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error finding promotion by code (ignore case): " + promotionCode, e);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "An unexpected error occurred finding promotion by code (ignore case): " + promotionCode, e);
        }
        
        // Trả về Optional rỗng nếu không tìm thấy hoặc có lỗi xảy ra
        return Optional.empty();
    }


  
  

    
    
     public static void main(String[] args) {
        PromotionDAO promotionDAO = new PromotionDAO();
        
        
        Optional<Promotion> p = promotionDAO.findById(2);
        
        if (p.isPresent()) {
            System.out.println(p.get().toString());
        } else {
            System.out.println("Promotion is null");
        }
               
    }
     
    public int countAll(String status) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM promotions WHERE 1=1";
        
        if (status != null && !status.isEmpty()) {
            sql += " AND status = ?";
        }
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (status != null && !status.isEmpty()) {
                ps.setString(1, status);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error counting promotions", e);
        }
        return count;
    }

    public int countSearchResults(String searchValue, String status) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM promotions WHERE (title LIKE ? OR promotion_code LIKE ?)";
        
        if (status != null && !status.isEmpty()) {
            sql += " AND status = ?";
        }
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + searchValue + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            
            if (status != null && !status.isEmpty()) {
                ps.setString(3, status);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error counting search results", e);
        }
        return count;
    }

    /**
     * Auto update promotion status based on start and end dates
     */
    public void updatePromotionStatusByTime() {
        String updateActivePromotions = "UPDATE promotions SET status = 'ACTIVE', updated_at = ? " +
                                       "WHERE status = 'SCHEDULED' AND start_date <= ? AND end_date >= ?";
        
        String updateExpiredPromotions = "UPDATE promotions SET status = 'INACTIVE', updated_at = ? " +
                                        "WHERE status = 'ACTIVE' AND end_date < ?";
        
        try (Connection conn = DBContext.getConnection()) {
            Timestamp now = new Timestamp(System.currentTimeMillis());
            
            // Activate scheduled promotions that should start now
            try (PreparedStatement ps1 = conn.prepareStatement(updateActivePromotions)) {
                ps1.setTimestamp(1, now);
                ps1.setTimestamp(2, now);
                ps1.setTimestamp(3, now);
                int activated = ps1.executeUpdate();
                if (activated > 0) {
                    logger.info("Auto-activated " + activated + " promotions");
                }
            }
            
            // Deactivate expired promotions
            try (PreparedStatement ps2 = conn.prepareStatement(updateExpiredPromotions)) {
                ps2.setTimestamp(1, now);
                ps2.setTimestamp(2, now);
                int deactivated = ps2.executeUpdate();
                if (deactivated > 0) {
                    logger.info("Auto-deactivated " + deactivated + " expired promotions");
                }
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error auto-updating promotion status", e);
        }
    }

    /**
     * Get promotions that need status update
     */
    public List<Promotion> getPromotionsNeedingStatusUpdate() {
        List<Promotion> promotions = new ArrayList<>();
        String sql = "SELECT * FROM promotions WHERE " +
                    "(status = 'SCHEDULED' AND start_date <= ?) OR " +
                    "(status = 'ACTIVE' AND end_date < ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            Timestamp now = new Timestamp(System.currentTimeMillis());
            ps.setTimestamp(1, now);
            ps.setTimestamp(2, now);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    promotions.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting promotions needing update", e);
        }
        return promotions;
    }

    /**
     * Get promotion usage report with customer information
     */
    public List<java.util.Map<String, Object>> getPromotionUsageReport(int promotionId, int page, int pageSize) {
        List<java.util.Map<String, Object>> usageList = new ArrayList<>();
        String sql = "SELECT pu.*, c.first_name, c.last_name, c.email, c.phone, " +
                    "p.title as promotion_title, p.promotion_code " +
                    "FROM promotion_usage pu " +
                    "JOIN customers c ON pu.customer_id = c.customer_id " +
                    "JOIN promotions p ON pu.promotion_id = p.promotion_id " +
                    "WHERE pu.promotion_id = ? " +
                    "ORDER BY pu.used_at DESC " +
                    "LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, promotionId);
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    java.util.Map<String, Object> usage = new java.util.HashMap<>();
                    usage.put("usageId", rs.getInt("usage_id"));
                    usage.put("customerId", rs.getInt("customer_id"));
                    usage.put("customerName", rs.getString("first_name") + " " + rs.getString("last_name"));
                    usage.put("customerEmail", rs.getString("email"));
                    usage.put("customerPhone", rs.getString("phone"));
                    usage.put("promotionTitle", rs.getString("promotion_title"));
                    usage.put("promotionCode", rs.getString("promotion_code"));
                    usage.put("originalAmount", rs.getBigDecimal("original_amount"));
                    usage.put("discountAmount", rs.getBigDecimal("discount_amount"));
                    usage.put("finalAmount", rs.getBigDecimal("final_amount"));
                    usage.put("usedAt", rs.getTimestamp("used_at"));
                    usageList.add(usage);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting promotion usage report", e);
        }
        return usageList;
    }

    /**
     * Get total usage count for a promotion
     */
    public int getTotalUsageCount(int promotionId) {
        String sql = "SELECT COUNT(*) FROM promotion_usage WHERE promotion_id = ?";
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
}



