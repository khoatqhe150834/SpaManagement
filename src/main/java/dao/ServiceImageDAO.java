/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import db.DBContext;
import model.ServiceImage;

/**
 * Data Access Object for ServiceImage
 * Provides CRUD operations for service_images table
 *
 * @author ADMIN
 */
public class ServiceImageDAO implements BaseDAO<ServiceImage, Integer> {

    private static final Logger LOGGER = Logger.getLogger(ServiceImageDAO.class.getName());

    @Override
    public <S extends ServiceImage> S save(S entity) {
        String sql = "INSERT INTO service_images (service_id, url, alt_text, is_primary, sort_order, caption, is_active, file_size) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, entity.getServiceId());
            stmt.setString(2, entity.getUrl() != null ? entity.getUrl() : "");
            stmt.setString(3, entity.getAltText() != null ? entity.getAltText() : "");
            stmt.setBoolean(4, entity.getIsPrimary() != null ? entity.getIsPrimary() : false);
            stmt.setInt(5, entity.getSortOrder() != null ? entity.getSortOrder() : 0);
            stmt.setString(6, entity.getCaption() != null ? entity.getCaption() : "");
            stmt.setBoolean(7, entity.getIsActive() != null ? entity.getIsActive() : true);
            if (entity.getFileSize() != null) {
                stmt.setInt(8, entity.getFileSize());
            } else {
                stmt.setNull(8, java.sql.Types.INTEGER);
            }

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        entity.setImageId(generatedKeys.getInt(1));
                    }
                }
            }
            return entity;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error saving ServiceImage", ex);
            return null;
        }
    }

    @Override
    public Optional<ServiceImage> findById(Integer id) {
        String sql = "SELECT image_id, service_id, url, alt_text, is_primary, sort_order, caption, is_active, file_size, uploaded_at, updated_at FROM service_images WHERE image_id = ?";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToServiceImage(rs));
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding ServiceImage by ID: " + id, ex);
        }
        return Optional.empty();
    }

    @Override
    public List<ServiceImage> findAll() {
        List<ServiceImage> images = new ArrayList<>();
        String sql = "SELECT image_id, service_id, url, alt_text, is_primary, sort_order, caption, is_active, file_size, uploaded_at, updated_at FROM service_images ORDER BY service_id, sort_order";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                images.add(mapResultSetToServiceImage(rs));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding all ServiceImages", ex);
        }
        return images;
    }

    @Override
    public <S extends ServiceImage> S update(S entity) {
        String sql = "UPDATE service_images SET service_id = ?, url = ?, alt_text = ?, is_primary = ?, sort_order = ?, caption = ?, is_active = ?, file_size = ? WHERE image_id = ?";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, entity.getServiceId());
            stmt.setString(2, entity.getUrl());
            stmt.setString(3, entity.getAltText());
            stmt.setBoolean(4, entity.getIsPrimary() != null ? entity.getIsPrimary() : false);
            stmt.setInt(5, entity.getSortOrder() != null ? entity.getSortOrder() : 0);
            stmt.setString(6, entity.getCaption());
            stmt.setBoolean(7, entity.getIsActive() != null ? entity.getIsActive() : true);
            if (entity.getFileSize() != null) {
                stmt.setInt(8, entity.getFileSize());
            } else {
                stmt.setNull(8, Types.INTEGER);
            }
            stmt.setInt(9, entity.getImageId());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                return entity;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating ServiceImage", ex);
        }
        return null;
    }

    @Override
    public void deleteById(Integer id) {
        String sql = "DELETE FROM service_images WHERE image_id = ?";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting ServiceImage by ID: " + id, ex);
        }
    }

    @Override
    public void delete(ServiceImage entity) {
        if (entity.getImageId() != null) {
            deleteById(entity.getImageId());
        }
    }

    @Override
    public boolean existsById(Integer id) {
        String sql = "SELECT 1 FROM service_images WHERE image_id = ?";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error checking existence of ServiceImage by ID: " + id, ex);
        }
        return false;
    }

    // Custom methods for ServiceImage-specific operations

    /**
     * Find all images for a specific service
     * 
     * @param serviceId the service ID
     * @return list of service images ordered by sort_order
     */
    public List<ServiceImage> findByServiceId(Integer serviceId) {
        List<ServiceImage> images = new ArrayList<>();
        String sql = "SELECT image_id, service_id, url, alt_text, is_primary, sort_order, caption, is_active, file_size, uploaded_at, updated_at FROM service_images WHERE service_id = ? ORDER BY sort_order ASC, image_id ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, serviceId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    images.add(mapResultSetToServiceImage(rs));
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding images by service ID: " + serviceId, ex);
        }
        return images;
    }

    /**
     * Find the primary image for a service
     * 
     * @param serviceId the service ID
     * @return Optional containing the primary image if found
     */
    public Optional<ServiceImage> findPrimaryByServiceId(Integer serviceId) {
        String sql = "SELECT image_id, service_id, url, alt_text, is_primary, sort_order, caption, is_active, file_size, uploaded_at, updated_at FROM service_images WHERE service_id = ? AND is_primary = 1 AND is_active = 1";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, serviceId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToServiceImage(rs));
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding primary ServiceImage by service ID: " + serviceId, ex);
        }
        return Optional.empty();
    }

    /**
     * Delete all images for a specific service
     * 
     * @param serviceId the service ID
     */
    public void deleteByServiceId(Integer serviceId) {
        String sql = "DELETE FROM service_images WHERE service_id = ?";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, serviceId);
            stmt.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting ServiceImages by service ID: " + serviceId, ex);
        }
    }

    /**
     * Set an image as primary for a service (and unset others)
     * 
     * @param imageId   the image ID to set as primary
     * @param serviceId the service ID
     */
    public void setPrimaryImage(Integer imageId, Integer serviceId) {
        String unsetSql = "UPDATE service_images SET is_primary = 0 WHERE service_id = ?";
        String setSql = "UPDATE service_images SET is_primary = 1 WHERE image_id = ? AND service_id = ?";

        try (Connection conn = DBContext.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement unsetStmt = conn.prepareStatement(unsetSql);
                    PreparedStatement setStmt = conn.prepareStatement(setSql)) {

                // First, unset all primary flags for this service
                unsetStmt.setInt(1, serviceId);
                unsetStmt.executeUpdate();

                // Then set the specified image as primary
                setStmt.setInt(1, imageId);
                setStmt.setInt(2, serviceId);
                setStmt.executeUpdate();

                // Update services table with this primary image URL
                try (PreparedStatement urlStmt = conn.prepareStatement(
                        "UPDATE services SET image_url = (SELECT url FROM service_images WHERE image_id = ?) WHERE service_id = ?")) {
                    urlStmt.setInt(1, imageId);
                    urlStmt.setInt(2, serviceId);
                    urlStmt.executeUpdate();
                }

                conn.commit();
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error setting primary image: " + imageId + " for service: " + serviceId, ex);
        }
    }

    /**
     * Update sort order for multiple images
     * 
     * @param imageIds list of image IDs in the desired order
     */
    public void updateSortOrder(List<Integer> imageIds) {
        String sql = "UPDATE service_images SET sort_order = ? WHERE image_id = ?";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            conn.setAutoCommit(false);

            for (int i = 0; i < imageIds.size(); i++) {
                stmt.setInt(1, i);
                stmt.setInt(2, imageIds.get(i));
                stmt.addBatch();
            }

            stmt.executeBatch();
            conn.commit();
            conn.setAutoCommit(true);
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating sort order for images", ex);
        }
    }

    /**
     * Update sort order and primary flag for a single image
     * 
     * @param imageId   the image ID to update
     * @param sortOrder the new sort order
     * @param isPrimary the new primary flag
     */
    public void updateSortOrderAndPrimary(int imageId, int sortOrder, boolean isPrimary) {
        String sql = "UPDATE service_images SET sort_order = ?, is_primary = ? WHERE image_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sortOrder);
            ps.setBoolean(2, isPrimary);
            ps.setInt(3, imageId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Update sort order only for a single image
     * 
     * @param imageId   the image ID to update
     * @param sortOrder the new sort order
     */
    public void updateSortOrderOnly(int imageId, int sortOrder) {
        String sql = "UPDATE service_images SET sort_order = ? WHERE image_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sortOrder);
            ps.setInt(2, imageId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Map ResultSet to ServiceImage object
     * 
     * @param rs the ResultSet
     * @return ServiceImage object
     * @throws SQLException if database access error occurs
     */
    private ServiceImage mapResultSetToServiceImage(ResultSet rs) throws SQLException {
        ServiceImage image = new ServiceImage();
        image.setImageId(rs.getInt("image_id"));
        image.setServiceId(rs.getInt("service_id"));
        image.setUrl(rs.getString("url"));
        image.setAltText(rs.getString("alt_text"));
        image.setIsPrimary(rs.getBoolean("is_primary"));
        image.setSortOrder(rs.getInt("sort_order"));
        image.setCaption(rs.getString("caption"));
        image.setIsActive(rs.getBoolean("is_active"));

        // Handle nullable integer
        int fileSize = rs.getInt("file_size");
        if (!rs.wasNull()) {
            image.setFileSize(fileSize);
        }

        image.setUploadedAt(rs.getTimestamp("uploaded_at"));
        image.setUpdatedAt(rs.getTimestamp("updated_at"));

        return image;
    }

    /**
     * Get the first available image for each service (primary first, then by
     * sort_order/image_id)
     * 
     * @param serviceIds list of service IDs to get images for
     * @return Map of service ID to first available image URL
     */
    public Map<Integer, String> getFirstImageUrlsByServiceIds(List<Integer> serviceIds) {
        Map<Integer, String> imageMap = new HashMap<>();

        if (serviceIds == null || serviceIds.isEmpty()) {
            return imageMap;
        }

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT si.service_id, si.url ");
        sql.append("FROM service_images si ");
        sql.append("WHERE si.service_id IN (");

        // Build placeholders for IN clause
        for (int i = 0; i < serviceIds.size(); i++) {
            sql.append("?");
            if (i < serviceIds.size() - 1) {
                sql.append(",");
            }
        }

        sql.append(") AND si.is_active = 1 ");
        sql.append("ORDER BY si.service_id, si.is_primary DESC, si.sort_order ASC, si.image_id ASC");

        try (Connection conn = DBContext.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            // Set the service ID parameters
            for (int i = 0; i < serviceIds.size(); i++) {
                stmt.setInt(i + 1, serviceIds.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Integer serviceId = rs.getInt("service_id");
                    String imageUrl = rs.getString("url");

                    // Only add the first image for each service (due to ordering)
                    if (!imageMap.containsKey(serviceId)) {
                        imageMap.put(serviceId, imageUrl);
                    }
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting first image URLs by service IDs", ex);
        }

        return imageMap;
    }

    /**
     * Get the first available image for a single service
     * 
     * @param serviceId the service ID
     * @return Optional containing the first image URL if found
     */
    public Optional<String> getFirstImageUrlByServiceId(Integer serviceId) {
        String sql = "SELECT url FROM service_images WHERE service_id = ? AND is_active = 1 ORDER BY is_primary DESC, sort_order ASC, image_id ASC LIMIT 1";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, serviceId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(rs.getString("url"));
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting first image URL by service ID: " + serviceId, ex);
        }
        return Optional.empty();
    }

    /**
     * Get image counts for multiple services in a single query for better
     * performance
     * 
     * @param serviceIds list of service IDs to get image counts for
     * @return Map of service ID to image count
     */
    public Map<Integer, Integer> getImageCountsByServiceIds(List<Integer> serviceIds) {
        Map<Integer, Integer> imageCounts = new HashMap<>();

        if (serviceIds == null || serviceIds.isEmpty()) {
            return imageCounts;
        }

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT service_id, COUNT(*) as image_count ");
        sql.append("FROM service_images ");
        sql.append("WHERE service_id IN (");

        // Build placeholders for IN clause
        for (int i = 0; i < serviceIds.size(); i++) {
            sql.append("?");
            if (i < serviceIds.size() - 1) {
                sql.append(",");
            }
        }

        sql.append(") AND is_active = 1 ");
        sql.append("GROUP BY service_id");

        try (Connection conn = DBContext.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            // Set the service ID parameters
            for (int i = 0; i < serviceIds.size(); i++) {
                stmt.setInt(i + 1, serviceIds.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Integer serviceId = rs.getInt("service_id");
                    Integer imageCount = rs.getInt("image_count");
                    imageCounts.put(serviceId, imageCount);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting image counts by service IDs", ex);
        }

        // Ensure all service IDs have a count (default to 0 for services with no
        // images)
        for (Integer serviceId : serviceIds) {
            imageCounts.putIfAbsent(serviceId, 0);
        }

        return imageCounts;
    }

    public void resetPrimaryByServiceId(int serviceId) {
        String sql = "UPDATE service_images SET is_primary = 0 WHERE service_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}