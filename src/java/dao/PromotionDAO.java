package dao;

import db.DBContext;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Promotion;

/**
 * Complete PromotionDAO implementation for promotion management
 * Includes CRUD operations: view, edit, delete, search, add, sort
 * @author Admin
 */
public class PromotionDAO implements BaseDAO<Promotion, Integer> {
    
    private static final Logger logger = Logger.getLogger(PromotionDAO.class.getName());
    
    /**
     * Build Promotion object from ResultSet
     */
    private Promotion buildPromotionFromResultSet(ResultSet rs) throws SQLException {
        Promotion promotion = new Promotion();
        promotion.setPromotionId(rs.getInt("promotion_id"));
        promotion.setTitle(rs.getString("title"));
        promotion.setDescription(rs.getString("description"));
        promotion.setPromotionCode(rs.getString("promotion_code"));
        promotion.setDiscountType(rs.getString("discount_type"));
        promotion.setDiscountValue(rs.getBigDecimal("discount_value"));
        
        // Handle nullable integer field
        int serviceId = rs.getInt("applies_to_service_id");
        if (!rs.wasNull()) {
            promotion.setAppliesToServiceId(serviceId);
        }
        
        promotion.setMinimumAppointmentValue(rs.getBigDecimal("minimum_appointment_value"));
        
        // Handle datetime fields
        Timestamp startDate = rs.getTimestamp("start_date");
        if (startDate != null) {
            promotion.setStartDate(startDate.toLocalDateTime());
        }
        
        Timestamp endDate = rs.getTimestamp("end_date");
        if (endDate != null) {
            promotion.setEndDate(endDate.toLocalDateTime());
        }
        
        promotion.setStatus(rs.getString("status"));
        
        // Handle nullable integer fields
        int usageLimitPerCustomer = rs.getInt("usage_limit_per_customer");
        if (!rs.wasNull()) {
            promotion.setUsageLimitPerCustomer(usageLimitPerCustomer);
        }
        
        int totalUsageLimit = rs.getInt("total_usage_limit");
        if (!rs.wasNull()) {
            promotion.setTotalUsageLimit(totalUsageLimit);
        }
        
        promotion.setCurrentUsageCount(rs.getInt("current_usage_count"));
        promotion.setApplicableScope(rs.getString("applicable_scope"));
        promotion.setApplicableServiceIdsJson(rs.getString("applicable_service_ids_json"));
        promotion.setImageUrl(rs.getString("image_url"));
        promotion.setTermsAndConditions(rs.getString("terms_and_conditions"));
        
        int createdByUserId = rs.getInt("created_by_user_id");
        if (!rs.wasNull()) {
            promotion.setCreatedByUserId(createdByUserId);
        }
        
        promotion.setIsAutoApply(rs.getBoolean("is_auto_apply"));
        
        // Handle timestamp fields
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            promotion.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            promotion.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        return promotion;
    }

    @Override
    public <S extends Promotion> S save(S promotion) {
        if (promotion == null) {
            throw new IllegalArgumentException("Promotion cannot be null");
        }
        
        // Validate required fields
        if (promotion.getTitle() == null || promotion.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Promotion title is required");
        }
        if (promotion.getDiscountType() == null || promotion.getDiscountType().trim().isEmpty()) {
            throw new IllegalArgumentException("Discount type is required");
        }
        if (promotion.getDiscountValue() == null || promotion.getDiscountValue().compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Discount value must be positive");
        }
        if (promotion.getStartDate() == null || promotion.getEndDate() == null) {
            throw new IllegalArgumentException("Start date and end date are required");
        }
        if (promotion.getStartDate().isAfter(promotion.getEndDate())) {
            throw new IllegalArgumentException("Start date must be before end date");
        }
        
        // Check for duplicate promotion code if provided
        if (promotion.getPromotionCode() != null && !promotion.getPromotionCode().trim().isEmpty()) {
            if (isPromotionCodeExists(promotion.getPromotionCode())) {
                throw new IllegalArgumentException("Promotion code already exists");
            }
        }

        String sql = "INSERT INTO promotions (title, description, promotion_code, discount_type, discount_value, " +
                     "applies_to_service_id, minimum_appointment_value, start_date, end_date, status, " +
                     "usage_limit_per_customer, total_usage_limit, current_usage_count, applicable_scope, " +
                     "applicable_service_ids_json, image_url, terms_and_conditions, created_by_user_id, " +
                     "is_auto_apply, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, promotion.getTitle().trim());
            ps.setString(2, promotion.getDescription());
            
            // Handle nullable promotion code
            if (promotion.getPromotionCode() != null && !promotion.getPromotionCode().trim().isEmpty()) {
                ps.setString(3, promotion.getPromotionCode().trim().toUpperCase());
            } else {
                ps.setNull(3, Types.VARCHAR);
            }
            
            ps.setString(4, promotion.getDiscountType());
            ps.setBigDecimal(5, promotion.getDiscountValue());
            
            // Handle nullable service ID
            if (promotion.getAppliesToServiceId() != null) {
                ps.setInt(6, promotion.getAppliesToServiceId());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            
            ps.setBigDecimal(7, promotion.getMinimumAppointmentValue() != null ? 
                             promotion.getMinimumAppointmentValue() : BigDecimal.ZERO);
            ps.setTimestamp(8, Timestamp.valueOf(promotion.getStartDate()));
            ps.setTimestamp(9, Timestamp.valueOf(promotion.getEndDate()));
            ps.setString(10, promotion.getStatus() != null ? promotion.getStatus() : "SCHEDULED");
            
            // Handle nullable usage limits
            if (promotion.getUsageLimitPerCustomer() != null) {
                ps.setInt(11, promotion.getUsageLimitPerCustomer());
            } else {
                ps.setNull(11, Types.INTEGER);
            }
            
            if (promotion.getTotalUsageLimit() != null) {
                ps.setInt(12, promotion.getTotalUsageLimit());
            } else {
                ps.setNull(12, Types.INTEGER);
            }
            
            ps.setInt(13, promotion.getCurrentUsageCount() != null ? promotion.getCurrentUsageCount() : 0);
            ps.setString(14, promotion.getApplicableScope() != null ? promotion.getApplicableScope() : "ENTIRE_APPOINTMENT");
            ps.setString(15, promotion.getApplicableServiceIdsJson());
            ps.setString(16, promotion.getImageUrl());
            ps.setString(17, promotion.getTermsAndConditions());
            
            if (promotion.getCreatedByUserId() != null) {
                ps.setInt(18, promotion.getCreatedByUserId());
            } else {
                ps.setNull(18, Types.INTEGER);
            }
            
            ps.setBoolean(19, promotion.getIsAutoApply() != null ? promotion.getIsAutoApply() : false);
            
            LocalDateTime now = LocalDateTime.now();
            ps.setTimestamp(20, Timestamp.valueOf(now));
            ps.setTimestamp(21, Timestamp.valueOf(now));
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        promotion.setPromotionId(rs.getInt(1));
                        promotion.setCreatedAt(now);
                        promotion.setUpdatedAt(now);
                    }
                }
                logger.log(Level.INFO, "Promotion created successfully with ID: " + promotion.getPromotionId());
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error saving promotion: " + e.getMessage(), e);
            throw new RuntimeException("Error saving promotion: " + e.getMessage(), e);
        }
        
        return promotion;
    }

    @Override
    public Optional<Promotion> findById(Integer id) {
        if (id == null || id <= 0) {
            return Optional.empty();
        }
        
        String sql = "SELECT * FROM promotions WHERE promotion_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(buildPromotionFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding promotion by ID: " + id, e);
            throw new RuntimeException("Error finding promotion by ID: " + e.getMessage(), e);
        }
        
        return Optional.empty();
    }

    @Override
    public List<Promotion> findAll() {
        return findAll(1, 10, "created_at", "DESC");
    }

    /**
     * Get all promotions with pagination and sorting
     */
    public List<Promotion> findAll(int page, int pageSize, String sortBy, String sortDirection) {
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = 10;
        if (sortBy == null || sortBy.trim().isEmpty()) sortBy = "created_at";
        if (sortDirection == null || (!sortDirection.equalsIgnoreCase("ASC") && !sortDirection.equalsIgnoreCase("DESC"))) {
            sortDirection = "DESC";
        }
        
        // Validate sortBy field to prevent SQL injection
        List<String> allowedSortFields = List.of("promotion_id", "title", "discount_value", "start_date", 
                                                 "end_date", "status", "created_at", "updated_at");
        if (!allowedSortFields.contains(sortBy.toLowerCase())) {
            sortBy = "created_at";
        }
        
        List<Promotion> promotions = new ArrayList<>();
        String sql = "SELECT * FROM promotions ORDER BY " + sortBy + " " + sortDirection + " LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, pageSize);
            ps.setInt(2, (page - 1) * pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    promotions.add(buildPromotionFromResultSet(rs));
                }
            }
            
            logger.log(Level.INFO, "Retrieved " + promotions.size() + " promotions for page " + page);
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding promotions", e);
            throw new RuntimeException("Error finding promotions: " + e.getMessage(), e);
        }
        
        return promotions;
    }

    @Override
    public <S extends Promotion> S update(S promotion) {
        if (promotion == null || promotion.getPromotionId() == null) {
            throw new IllegalArgumentException("Promotion and promotion ID cannot be null");
        }
        
        // Validate required fields
        if (promotion.getTitle() == null || promotion.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Promotion title is required");
        }
        if (promotion.getDiscountType() == null || promotion.getDiscountType().trim().isEmpty()) {
            throw new IllegalArgumentException("Discount type is required");
        }
        if (promotion.getDiscountValue() == null || promotion.getDiscountValue().compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Discount value must be positive");
        }
        if (promotion.getStartDate() == null || promotion.getEndDate() == null) {
            throw new IllegalArgumentException("Start date and end date are required");
        }
        if (promotion.getStartDate().isAfter(promotion.getEndDate())) {
            throw new IllegalArgumentException("Start date must be before end date");
        }

        String sql = "UPDATE promotions SET title=?, description=?, promotion_code=?, discount_type=?, " +
                     "discount_value=?, applies_to_service_id=?, minimum_appointment_value=?, start_date=?, " +
                     "end_date=?, status=?, usage_limit_per_customer=?, total_usage_limit=?, " +
                     "applicable_scope=?, applicable_service_ids_json=?, image_url=?, terms_and_conditions=?, " +
                     "created_by_user_id=?, is_auto_apply=?, updated_at=? WHERE promotion_id=?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, promotion.getTitle().trim());
            ps.setString(2, promotion.getDescription());
            
            // Handle nullable promotion code
            if (promotion.getPromotionCode() != null && !promotion.getPromotionCode().trim().isEmpty()) {
                ps.setString(3, promotion.getPromotionCode().trim().toUpperCase());
            } else {
                ps.setNull(3, Types.VARCHAR);
            }
            
            ps.setString(4, promotion.getDiscountType());
            ps.setBigDecimal(5, promotion.getDiscountValue());
            
            // Handle nullable service ID
            if (promotion.getAppliesToServiceId() != null) {
                ps.setInt(6, promotion.getAppliesToServiceId());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            
            ps.setBigDecimal(7, promotion.getMinimumAppointmentValue() != null ? 
                             promotion.getMinimumAppointmentValue() : BigDecimal.ZERO);
            ps.setTimestamp(8, Timestamp.valueOf(promotion.getStartDate()));
            ps.setTimestamp(9, Timestamp.valueOf(promotion.getEndDate()));
            ps.setString(10, promotion.getStatus() != null ? promotion.getStatus() : "SCHEDULED");
            
            // Handle nullable usage limits
            if (promotion.getUsageLimitPerCustomer() != null) {
                ps.setInt(11, promotion.getUsageLimitPerCustomer());
            } else {
                ps.setNull(11, Types.INTEGER);
            }
            
            if (promotion.getTotalUsageLimit() != null) {
                ps.setInt(12, promotion.getTotalUsageLimit());
            } else {
                ps.setNull(12, Types.INTEGER);
            }
            
            ps.setString(13, promotion.getApplicableScope() != null ? promotion.getApplicableScope() : "ENTIRE_APPOINTMENT");
            ps.setString(14, promotion.getApplicableServiceIdsJson());
            ps.setString(15, promotion.getImageUrl());
            ps.setString(16, promotion.getTermsAndConditions());
            
            if (promotion.getCreatedByUserId() != null) {
                ps.setInt(17, promotion.getCreatedByUserId());
            } else {
                ps.setNull(17, Types.INTEGER);
            }
            
            ps.setBoolean(18, promotion.getIsAutoApply() != null ? promotion.getIsAutoApply() : false);
            ps.setTimestamp(19, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(20, promotion.getPromotionId());
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                promotion.setUpdatedAt(LocalDateTime.now());
                logger.log(Level.INFO, "Promotion updated successfully: " + promotion.getPromotionId());
            } else {
                throw new RuntimeException("Promotion not found for update: " + promotion.getPromotionId());
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating promotion: " + promotion.getPromotionId(), e);
            throw new RuntimeException("Error updating promotion: " + e.getMessage(), e);
        }
        
        return promotion;
    }

    @Override
    public void delete(Promotion entity) {
        if (entity != null && entity.getPromotionId() != null) {
            deleteById(entity.getPromotionId());
        }
    }

    @Override
    public void deleteById(Integer id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("Invalid promotion ID");
        }
        
        String sql = "DELETE FROM promotions WHERE promotion_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                logger.log(Level.INFO, "Promotion deleted successfully: " + id);
            } else {
                throw new RuntimeException("Promotion not found for deletion: " + id);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting promotion: " + id, e);
            throw new RuntimeException("Error deleting promotion: " + e.getMessage(), e);
        }
    }

    @Override
    public boolean existsById(Integer id) {
        if (id == null || id <= 0) {
            return false;
        }
        
        String sql = "SELECT COUNT(*) FROM promotions WHERE promotion_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            logger.log(Level.WARNING, "Error checking if promotion exists: " + id, e);
            return false;
        }
    }

    /**
     * Search promotions by keyword (title, description, or promotion code)
     */
    public List<Promotion> searchPromotions(String keyword, int page, int pageSize, String sortBy, String sortDirection) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAll(page, pageSize, sortBy, sortDirection);
        }
        
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = 10;
        if (sortBy == null || sortBy.trim().isEmpty()) sortBy = "created_at";
        if (sortDirection == null || (!sortDirection.equalsIgnoreCase("ASC") && !sortDirection.equalsIgnoreCase("DESC"))) {
            sortDirection = "DESC";
        }
        
        // Validate sortBy field to prevent SQL injection
        List<String> allowedSortFields = List.of("promotion_id", "title", "discount_value", "start_date", 
                                                 "end_date", "status", "created_at", "updated_at");
        if (!allowedSortFields.contains(sortBy.toLowerCase())) {
            sortBy = "created_at";
        }
        
        List<Promotion> promotions = new ArrayList<>();
        String sql = "SELECT * FROM promotions WHERE title LIKE ? OR description LIKE ? OR promotion_code LIKE ? " +
                     "ORDER BY " + sortBy + " " + sortDirection + " LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword.trim() + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setInt(4, pageSize);
            ps.setInt(5, (page - 1) * pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    promotions.add(buildPromotionFromResultSet(rs));
                }
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error searching promotions", e);
            throw new RuntimeException("Error searching promotions: " + e.getMessage(), e);
        }
        
        return promotions;
    }

    /**
     * Get promotions by status
     */
    public List<Promotion> findByStatus(String status, int page, int pageSize, String sortBy, String sortDirection) {
        if (status == null || status.trim().isEmpty()) {
            return findAll(page, pageSize, sortBy, sortDirection);
        }
        
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = 10;
        if (sortBy == null || sortBy.trim().isEmpty()) sortBy = "created_at";
        if (sortDirection == null || (!sortDirection.equalsIgnoreCase("ASC") && !sortDirection.equalsIgnoreCase("DESC"))) {
            sortDirection = "DESC";
        }
        
        // Validate sortBy field to prevent SQL injection
        List<String> allowedSortFields = List.of("promotion_id", "title", "discount_value", "start_date", 
                                                 "end_date", "status", "created_at", "updated_at");
        if (!allowedSortFields.contains(sortBy.toLowerCase())) {
            sortBy = "created_at";
        }
        
        List<Promotion> promotions = new ArrayList<>();
        String sql = "SELECT * FROM promotions WHERE status = ? ORDER BY " + sortBy + " " + sortDirection + " LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status.trim().toUpperCase());
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    promotions.add(buildPromotionFromResultSet(rs));
                }
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding promotions by status", e);
            throw new RuntimeException("Error finding promotions by status: " + e.getMessage(), e);
        }
        
        return promotions;
    }

    /**
     * Get active promotions (status = ACTIVE and within date range)
     */
    public List<Promotion> findActivePromotions() {
        List<Promotion> promotions = new ArrayList<>();
        String sql = "SELECT * FROM promotions WHERE status = 'ACTIVE' AND start_date <= NOW() AND end_date >= NOW() ORDER BY start_date DESC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                promotions.add(buildPromotionFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding active promotions", e);
            throw new RuntimeException("Error finding active promotions: " + e.getMessage(), e);
        }
        
        return promotions;
    }

    /**
     * Find promotion by promotion code
     */
    public Optional<Promotion> findByPromotionCode(String promotionCode) {
        if (promotionCode == null || promotionCode.trim().isEmpty()) {
            return Optional.empty();
        }
        
        String sql = "SELECT * FROM promotions WHERE promotion_code = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, promotionCode.trim().toUpperCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(buildPromotionFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding promotion by code: " + promotionCode, e);
            throw new RuntimeException("Error finding promotion by code: " + e.getMessage(), e);
        }
        
        return Optional.empty();
    }

    /**
     * Check if promotion code exists
     */
    public boolean isPromotionCodeExists(String promotionCode) {
        if (promotionCode == null || promotionCode.trim().isEmpty()) {
            return false;
        }
        
        String sql = "SELECT COUNT(*) FROM promotions WHERE promotion_code = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, promotionCode.trim().toUpperCase());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            logger.log(Level.WARNING, "Error checking promotion code existence: " + promotionCode, e);
            return false;
        }
    }

    /**
     * Get total number of promotions
     */
    public int getTotalPromotions() {
        String sql = "SELECT COUNT(*) FROM promotions";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            return rs.next() ? rs.getInt(1) : 0;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting total promotions count", e);
            return 0;
        }
    }

    /**
     * Get total search results count
     */
    public int getTotalSearchResults(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getTotalPromotions();
        }
        
        String sql = "SELECT COUNT(*) FROM promotions WHERE title LIKE ? OR description LIKE ? OR promotion_code LIKE ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword.trim() + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting search results count", e);
            return 0;
        }
    }

    /**
     * Get total promotions by status
     */
    public int getTotalPromotionsByStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            return getTotalPromotions();
        }
        
        String sql = "SELECT COUNT(*) FROM promotions WHERE status = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status.trim().toUpperCase());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting total promotions by status", e);
            return 0;
        }
    }

    /**
     * Update promotion status
     */
    public boolean updatePromotionStatus(Integer promotionId, String newStatus) {
        if (promotionId == null || newStatus == null || newStatus.trim().isEmpty()) {
            return false;
        }
        
        String sql = "UPDATE promotions SET status = ?, updated_at = ? WHERE promotion_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, newStatus.trim().toUpperCase());
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(3, promotionId);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating promotion status: " + promotionId, e);
            return false;
        }
    }

    /**
     * Increment promotion usage count
     */
    public boolean incrementUsageCount(Integer promotionId) {
        if (promotionId == null) {
            return false;
        }
        
        String sql = "UPDATE promotions SET current_usage_count = current_usage_count + 1, updated_at = ? WHERE promotion_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(2, promotionId);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error incrementing usage count for promotion: " + promotionId, e);
            return false;
        }
    }

    /**
     * Get promotions expiring soon (within next 7 days)
     */
    public List<Promotion> findPromotionsExpiringSoon() {
        List<Promotion> promotions = new ArrayList<>();
        String sql = "SELECT * FROM promotions WHERE status = 'ACTIVE' AND end_date BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 7 DAY) ORDER BY end_date ASC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                promotions.add(buildPromotionFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding promotions expiring soon", e);
            throw new RuntimeException("Error finding promotions expiring soon: " + e.getMessage(), e);
        }
        
        return promotions;
    }

    /**
     * Get promotion statistics
     */
    public java.util.Map<String, Integer> getPromotionStatistics() {
        java.util.Map<String, Integer> stats = new java.util.HashMap<>();
        
        String sql = "SELECT status, COUNT(*) as count FROM promotions GROUP BY status";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                stats.put(rs.getString("status"), rs.getInt("count"));
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting promotion statistics", e);
        }
        
        return stats;
    }
} 