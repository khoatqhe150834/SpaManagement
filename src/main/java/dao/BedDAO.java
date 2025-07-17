package dao;

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
import model.Bed;
import model.Room;

/**
 * Data Access Object for Bed entity
 * Handles CRUD operations for bed management
 * 
 * @author SpaManagement
 */
public class BedDAO implements BaseDAO<Bed, Integer> {
    
    private static final Logger LOGGER = Logger.getLogger(BedDAO.class.getName());
    
    @Override
    public <S extends Bed> S save(S bed) throws SQLException {
        String sql = "INSERT INTO beds (room_id, name, description, is_active) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, bed.getRoomId());
            stmt.setString(2, bed.getName());
            stmt.setString(3, bed.getDescription());
            stmt.setBoolean(4, bed.getIsActive());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating bed failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    bed.setBedId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating bed failed, no ID obtained.");
                }
            }
            
            LOGGER.log(Level.INFO, "Bed saved successfully with ID: {0}", bed.getBedId());
            return bed;
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error saving bed", ex);
            throw ex;
        }
    }
    
    @Override
    public Optional<Bed> findById(Integer id) throws SQLException {
        String sql = "SELECT b.bed_id, b.room_id, b.name, b.description, b.is_active, b.created_at, b.updated_at, " +
                    "r.name as room_name, r.description as room_description, r.capacity, r.is_active as room_is_active, " +
                    "r.created_at as room_created_at, r.updated_at as room_updated_at " +
                    "FROM beds b " +
                    "LEFT JOIN rooms r ON b.room_id = r.room_id " +
                    "WHERE b.bed_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Bed bed = mapResultSetToBed(rs);
                    return Optional.of(bed);
                }
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding bed by ID: " + id, ex);
            throw ex;
        }
        
        return Optional.empty();
    }
    
    @Override
    public List<Bed> findAll() throws SQLException {
        String sql = "SELECT b.bed_id, b.room_id, b.name, b.description, b.is_active, b.created_at, b.updated_at, " +
                    "r.name as room_name, r.description as room_description, r.capacity, r.is_active as room_is_active, " +
                    "r.created_at as room_created_at, r.updated_at as room_updated_at " +
                    "FROM beds b " +
                    "LEFT JOIN rooms r ON b.room_id = r.room_id " +
                    "ORDER BY b.bed_id";
        
        List<Bed> beds = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                beds.add(mapResultSetToBed(rs));
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding all beds", ex);
            throw ex;
        }
        
        return beds;
    }
    
    @Override
    public <S extends Bed> S update(S bed) throws SQLException {
        String sql = "UPDATE beds SET room_id = ?, name = ?, description = ?, is_active = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE bed_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, bed.getRoomId());
            stmt.setString(2, bed.getName());
            stmt.setString(3, bed.getDescription());
            stmt.setBoolean(4, bed.getIsActive());
            stmt.setInt(5, bed.getBedId());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Updating bed failed, no rows affected.");
            }
            
            bed.updateTimestamp();
            LOGGER.log(Level.INFO, "Bed updated successfully with ID: {0}", bed.getBedId());
            return bed;
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating bed", ex);
            throw ex;
        }
    }
    
    @Override
    public void deleteById(Integer id) throws SQLException {
        String sql = "DELETE FROM beds WHERE bed_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Deleting bed failed, no rows affected.");
            }
            
            LOGGER.log(Level.INFO, "Bed deleted successfully with ID: {0}", id);
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting bed by ID: " + id, ex);
            throw ex;
        }
    }
    
    @Override
    public void delete(Bed bed) throws SQLException {
        if (bed.getBedId() != null) {
            deleteById(bed.getBedId());
        }
    }
    
    @Override
    public boolean existsById(Integer id) throws SQLException {
        String sql = "SELECT 1 FROM beds WHERE bed_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error checking if bed exists by ID: " + id, ex);
            throw ex;
        }
    }
    
    @Override
    public int count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM beds";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error counting beds", ex);
            throw ex;
        }
        
        return 0;
    }
    
    // Custom methods for bed management
    
    /**
     * Get beds by room ID
     * @param roomId ID of the room
     * @return List of beds in the specified room
     */
    public List<Bed> getBedsByRoomId(int roomId) throws SQLException {
        String sql = "SELECT b.bed_id, b.room_id, b.name, b.description, b.is_active, b.created_at, b.updated_at, " +
                    "r.name as room_name, r.description as room_description, r.capacity, r.is_active as room_is_active, " +
                    "r.created_at as room_created_at, r.updated_at as room_updated_at " +
                    "FROM beds b " +
                    "LEFT JOIN rooms r ON b.room_id = r.room_id " +
                    "WHERE b.room_id = ? ORDER BY b.bed_id";
        
        List<Bed> beds = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, roomId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    beds.add(mapResultSetToBed(rs));
                }
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding beds by room ID: " + roomId, ex);
            throw ex;
        }
        
        return beds;
    }
    
    /**
     * Get beds by status (active/inactive)
     * @param isActive true for active beds, false for inactive
     * @return List of beds with specified status
     */
    public List<Bed> getBedsByStatus(boolean isActive) throws SQLException {
        String sql = "SELECT b.bed_id, b.room_id, b.name, b.description, b.is_active, b.created_at, b.updated_at, " +
                    "r.name as room_name, r.description as room_description, r.capacity, r.is_active as room_is_active, " +
                    "r.created_at as room_created_at, r.updated_at as room_updated_at " +
                    "FROM beds b " +
                    "LEFT JOIN rooms r ON b.room_id = r.room_id " +
                    "WHERE b.is_active = ? ORDER BY b.bed_id";
        
        List<Bed> beds = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setBoolean(1, isActive);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    beds.add(mapResultSetToBed(rs));
                }
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding beds by status: " + isActive, ex);
            throw ex;
        }
        
        return beds;
    }
    
    /**
     * Get bed count for a specific room
     * @param roomId ID of the room
     * @return Number of beds in the room
     */
    public int getBedCountByRoom(int roomId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM beds WHERE room_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, roomId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error counting beds by room ID: " + roomId, ex);
            throw ex;
        }
        
        return 0;
    }
    
    /**
     * Maps a ResultSet row to a Bed object with Room information
     * @param rs ResultSet positioned at a bed row
     * @return Bed object with associated Room
     */
    private Bed mapResultSetToBed(ResultSet rs) throws SQLException {
        Bed bed = new Bed();
        bed.setBedId(rs.getInt("bed_id"));
        bed.setRoomId(rs.getInt("room_id"));
        bed.setName(rs.getString("name"));
        bed.setDescription(rs.getString("description"));
        bed.setIsActive(rs.getBoolean("is_active"));
        bed.setCreatedAt(rs.getTimestamp("created_at"));
        bed.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Map associated room if available
        if (rs.getString("room_name") != null) {
            Room room = new Room();
            room.setRoomId(rs.getInt("room_id"));
            room.setName(rs.getString("room_name"));
            room.setDescription(rs.getString("room_description"));
            room.setCapacity(rs.getInt("capacity"));
            room.setIsActive(rs.getBoolean("room_is_active"));
            room.setCreatedAt(rs.getTimestamp("room_created_at"));
            room.setUpdatedAt(rs.getTimestamp("room_updated_at"));
            bed.setRoom(room);
        }
        
        return bed;
    }
}
