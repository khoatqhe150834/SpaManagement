package dao;

import db.DBContext;
import model.Promotion;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PromotionDAO {
    private static final Logger logger = Logger.getLogger(PromotionDAO.class.getName());

    private Promotion mapResultSet(ResultSet rs) throws SQLException {
        Promotion p = new Promotion();
        p.setPromotionId(rs.getInt("promotion_id"));
        p.setTitle(rs.getString("title"));
        p.setPromotionCode(rs.getString("promotion_code"));
        p.setDiscountType(rs.getString("discount_type"));
        p.setDiscountValue(rs.getBigDecimal("discount_value"));
        p.setDescription(rs.getString("description"));
        p.setStatus(rs.getString("status"));
        p.setCurrentUsageCount(rs.getInt("current_usage_count"));
        p.setIsAutoApply(rs.getBoolean("is_auto_apply"));
        p.setMinimumAppointmentValue(rs.getBigDecimal("minimum_appointment_value"));
        p.setApplicableScope(rs.getString("applicable_scope"));

        Timestamp start = rs.getTimestamp("start_date");
        if (start != null) p.setStartDate(start.toLocalDateTime());
        Timestamp end = rs.getTimestamp("end_date");
        if (end != null) p.setEndDate(end.toLocalDateTime());
        // Thêm các trường khác nếu Model có
        return p;
    }

    // Thêm khuyến mãi mới
    public boolean save(Promotion p) {
        String sql = "INSERT INTO promotions (title, promotion_code, discount_type, discount_value, description, status, start_date, end_date, current_usage_count, is_auto_apply, minimum_appointment_value, applicable_scope) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
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
            int row = ps.executeUpdate();
            if (row > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) p.setPromotionId(rs.getInt(1));
                return true;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Save Promotion Error", e);
        }
        return false;
    }

    // Update khuyến mãi
    public boolean update(Promotion p) {
        String sql = "UPDATE promotions SET title=?, promotion_code=?, discount_type=?, discount_value=?, description=?, status=?, start_date=?, end_date=?, current_usage_count=?, is_auto_apply=?, minimum_appointment_value=?, applicable_scope=? WHERE promotion_id=?";
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
            ps.setInt(13, p.getPromotionId());
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
            if (rs.next()) return Optional.of(mapResultSet(rs));
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "FindById Promotion Error", e);
        }
        return Optional.empty();
    }

    // Lấy danh sách khuyến mãi (phân trang, sort)
    public List<Promotion> findAll(int page, int pageSize, String sortBy, String sortOrder) {
        List<Promotion> list = new ArrayList<>();
        if (sortBy == null || sortBy.isBlank()) sortBy = "created_at";
        if (sortOrder == null || !(sortOrder.equalsIgnoreCase("ASC") || sortOrder.equalsIgnoreCase("DESC"))) sortOrder = "DESC";
        String sql = "SELECT * FROM promotions ORDER BY " + sortBy + " " + sortOrder + " LIMIT ? OFFSET ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pageSize);
            ps.setInt(2, (page - 1) * pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapResultSet(rs));
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "FindAll Promotion Error", e);
        }
        return list;
    }

    // Tìm kiếm khuyến mãi (search)
    public List<Promotion> searchPromotions(String keyword, int page, int pageSize, String sortBy, String sortOrder) {
        List<Promotion> list = new ArrayList<>();
        if (sortBy == null || sortBy.isBlank()) sortBy = "created_at";
        if (sortOrder == null || !(sortOrder.equalsIgnoreCase("ASC") || sortOrder.equalsIgnoreCase("DESC"))) sortOrder = "DESC";
        String sql = "SELECT * FROM promotions WHERE title LIKE ? OR description LIKE ? OR promotion_code LIKE ? ORDER BY " + sortBy + " " + sortOrder + " LIMIT ? OFFSET ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ps.setInt(4, pageSize);
            ps.setInt(5, (page - 1) * pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapResultSet(rs));
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Search Promotion Error", e);
        }
        return list;
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
    
        public boolean deactivatePromotion(int  promotionId) {
        String sql = "UPDATE promotions SET is_active = 0, updated_at = ? WHERE promotion_id = ?";
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
    
    
     public boolean activatePromotion(int  promotionId) {
        String sql = "UPDATE promotions SET is_active = 1, updated_at = ? WHERE promotion_id = ?";
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
        String sql = "UPDATE promotions SET is_active = 1, updated_at = ? WHERE promotion_id = ?";
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
        String sql = "SELECT * FROM Promotions WHERE PromotionCode = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, promotionCode);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Nếu tìm thấy, map dữ liệu từ ResultSet sang đối tượng Promotion
                    Promotion promotion = mapRowToPromotion(rs);
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

    /**
     * Helper method to map a ResultSet row to a Promotion object.
     * This avoids code duplication.
     * * @param rs The ResultSet to map from.
     * @return A populated Promotion object.
     * @throws SQLException if a database access error occurs.
     */
    private Promotion mapRowToPromotion(ResultSet rs) throws SQLException {
        Promotion promotion = new Promotion();
        promotion.setPromotionId(rs.getInt("PromotionID"));
        promotion.setTitle(rs.getString("Title"));
        promotion.setDescription(rs.getString("Description"));
        promotion.setPromotionCode(rs.getString("PromotionCode"));
        promotion.setDiscountType(rs.getString("DiscountType"));
        promotion.setDiscountValue(rs.getBigDecimal("DiscountValue"));
        
        // Dùng getObject để tránh lỗi nếu giá trị trong CSDL là NULL
        promotion.setAppliesToServiceId((Integer) rs.getObject("AppliesToServiceID"));
        promotion.setMinimumAppointmentValue(rs.getBigDecimal("MinimumAppointmentValue"));
        
        // Chuyển đổi Timestamp từ SQL sang LocalDateTime
        if (rs.getTimestamp("StartDate") != null) {
            promotion.setStartDate(rs.getTimestamp("StartDate").toLocalDateTime());
        }
        if (rs.getTimestamp("EndDate") != null) {
            promotion.setEndDate(rs.getTimestamp("EndDate").toLocalDateTime());
        }
        
        promotion.setStatus(rs.getString("Status"));
        promotion.setUsageLimitPerCustomer((Integer) rs.getObject("UsageLimitPerCustomer"));
        promotion.setTotalUsageLimit((Integer) rs.getObject("TotalUsageLimit"));
        promotion.setCurrentUsageCount(rs.getInt("CurrentUsageCount"));
        promotion.setApplicableScope(rs.getString("ApplicableScope"));
        promotion.setApplicableServiceIdsJson(rs.getString("ApplicableServiceIDsJson"));
        promotion.setImageUrl(rs.getString("ImageURL"));
        promotion.setTermsAndConditions(rs.getString("TermsAndConditions"));
        promotion.setCreatedByUserId((Integer) rs.getObject("CreatedByUserID"));
        promotion.setIsAutoApply(rs.getBoolean("IsAutoApply"));
        
        if (rs.getTimestamp("CreatedAt") != null) {
            promotion.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
        }
        if (rs.getTimestamp("UpdatedAt") != null) {
            promotion.setUpdatedAt(rs.getTimestamp("UpdatedAt").toLocalDateTime());
        }

        return promotion;
    }
     
}
