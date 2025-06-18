package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import db.DBContext;
import java.sql.Timestamp;
import model.Category;

public class CategoryDAO {
    private static final Logger logger = Logger.getLogger(CategoryDAO.class.getName());

    public List<Category> findAll(String status, int page, int pageSize, String sortBy, String sortOrder) {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE 1=1";
        
        if (status != null && !status.isEmpty()) {
            sql += " AND is_active = ?";
        }
        
        // Add sorting
        if (sortBy != null && !sortBy.isEmpty()) {
            String sortColumn = switch (sortBy) {
                case "id" -> "category_id";
                case "name" -> "name";
                default -> "category_id";
            };
            sql += " ORDER BY " + sortColumn + " " + (sortOrder != null && sortOrder.equalsIgnoreCase("desc") ? "DESC" : "ASC");
        }
        
        sql += " LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            int paramIndex = 1;
            if (status != null && !status.isEmpty()) {
                ps.setBoolean(paramIndex++, status.equalsIgnoreCase("active"));
            }
            ps.setInt(paramIndex++, pageSize);
            ps.setInt(paramIndex, (page - 1) * pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    categories.add(mapResultSetToCategory(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding all categories", e);
        }
        return categories;
    }

    public List<Category> search(String searchValue, String status, int page, int pageSize, String sortBy, String sortOrder) {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE (name LIKE ? OR description LIKE ?)";
        
        if (status != null && !status.isEmpty()) {
            sql += " AND is_active = ?";
        }
        
        // Add sorting
        if (sortBy != null && !sortBy.isEmpty()) {
            String sortColumn = switch (sortBy) {
                case "id" -> "category_id";
                case "name" -> "name";
                default -> "category_id";
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
                ps.setBoolean(paramIndex++, status.equalsIgnoreCase("active"));
            }
            ps.setInt(paramIndex++, pageSize);
            ps.setInt(paramIndex, (page - 1) * pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    categories.add(mapResultSetToCategory(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error searching categories", e);
        }
        return categories;
    }

    public int countAll(String status) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM categories WHERE 1=1";
        
        if (status != null && !status.isEmpty()) {
            sql += " AND is_active = ?";
        }
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (status != null && !status.isEmpty()) {
                ps.setBoolean(1, status.equalsIgnoreCase("active"));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error counting categories", e);
        }
        return count;
    }

    public int countSearchResults(String searchValue, String status) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM categories WHERE (name LIKE ? OR description LIKE ?)";
        
        if (status != null && !status.isEmpty()) {
            sql += " AND is_active = ?";
        }
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + searchValue + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            
            if (status != null && !status.isEmpty()) {
                ps.setBoolean(3, status.equalsIgnoreCase("active"));
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

    public Optional<Category> findById(int id) {
        String sql = "SELECT * FROM categories WHERE category_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToCategory(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding category by ID", e);
        }
        return Optional.empty();
    }

    public boolean create(Category category) {
        String sql = "INSERT INTO categories (parent_category_id, name, slug, description, image_url, " +
                    "module_type, is_active, sort_order, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setObject(1, category.getParentCategoryId());
            ps.setString(2, category.getName());
            ps.setString(3, category.getSlug());
            ps.setString(4, category.getDescription());
            ps.setString(5, category.getImageUrl());
            ps.setString(6, category.getModuleType());
            ps.setBoolean(7, category.isActive());
            ps.setInt(8, category.getSortOrder());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error creating category", e);
            return false;
        }
    }

    public boolean update(Category category) {
        String sql = "UPDATE categories SET parent_category_id = ?, name = ?, slug = ?, " +
                    "description = ?, image_url = ?, module_type = ?, is_active = ?, " +
                    "sort_order = ?, updated_at = NOW() WHERE category_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setObject(1, category.getParentCategoryId());
            ps.setString(2, category.getName());
            ps.setString(3, category.getSlug());
            ps.setString(4, category.getDescription());
            ps.setString(5, category.getImageUrl());
            ps.setString(6, category.getModuleType());
            ps.setBoolean(7, category.isActive());
            ps.setInt(8, category.getSortOrder());
            ps.setInt(9, category.getCategoryId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating category", e);
            return false;
        }
    }

    public boolean deleteById(int id) {
        String sql = "DELETE FROM categories WHERE category_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting category", e);
            return false;
        }
    }
    
     public boolean deactivateCategory(int categoryId) {
        String sql = "UPDATE  categorys SET is_active = 0, updated_at = ? WHERE category_id = ?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setInt(2, categoryId);
            int rowsAffected = ps.executeUpdate();

            return rowsAffected > 0;
        } catch (SQLException e) {
            return false;
        }
    }

    public boolean activateCategory(int categoryId) {
        String sql = "UPDATE  categorys SET is_active = 1, updated_at = ? WHERE category_id = ?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setInt(2, categoryId);
            int rowsAffected = ps.executeUpdate();

            return rowsAffected > 0;
        } catch (SQLException e) {
            return false;
        }
    }


    private Category mapResultSetToCategory(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setCategoryId(rs.getInt("category_id"));
        category.setParentCategoryId(rs.getObject("parent_category_id", Integer.class));
        category.setName(rs.getString("name"));
        category.setSlug(rs.getString("slug"));
        category.setDescription(rs.getString("description"));
        category.setImageUrl(rs.getString("image_url"));
        category.setModuleType(rs.getString("module_type"));
        category.setActive(rs.getBoolean("is_active"));
        category.setSortOrder(rs.getInt("sort_order"));
        category.setCreatedAt(rs.getTimestamp("created_at"));
        category.setUpdatedAt(rs.getTimestamp("updated_at"));
        return category;
    }
} 