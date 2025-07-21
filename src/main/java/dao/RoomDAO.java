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
import model.Room;

/**
 * Data Access Object for Room entity
 * Handles CRUD operations for room management
 * 
 * @author SpaManagement
 */
public class RoomDAO implements BaseDAO<Room, Integer> {
    
    private static final Logger LOGGER = Logger.getLogger(RoomDAO.class.getName());
    
    @Override
    public <S extends Room> S save(S room) throws SQLException {
        String sql = "INSERT INTO rooms (name, description, capacity, is_active) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, room.getName());
            stmt.setString(2, room.getDescription());
            stmt.setInt(3, room.getCapacity());
            stmt.setBoolean(4, room.getIsActive());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating room failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    room.setRoomId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating room failed, no ID obtained.");
                }
            }
            
            LOGGER.log(Level.INFO, "Room saved successfully with ID: {0}", room.getRoomId());
            return room;
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error saving room", ex);
            throw ex;
        }
    }
    
    @Override
    public Optional<Room> findById(Integer id) throws SQLException {
        String sql = "SELECT room_id, name, description, capacity, is_active, created_at, updated_at " +
                    "FROM rooms WHERE room_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Room room = mapResultSetToRoom(rs);
                    return Optional.of(room);
                }
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding room by ID: " + id, ex);
            throw ex;
        }
        
        return Optional.empty();
    }
    
    @Override
    public List<Room> findAll() throws SQLException {
        String sql = "SELECT room_id, name, description, capacity, is_active, created_at, updated_at " +
                    "FROM rooms ORDER BY room_id";
        
        List<Room> rooms = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                rooms.add(mapResultSetToRoom(rs));
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding all rooms", ex);
            throw ex;
        }
        
        return rooms;
    }
    
    @Override
    public <S extends Room> S update(S room) throws SQLException {
        String sql = "UPDATE rooms SET name = ?, description = ?, capacity = ?, is_active = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE room_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, room.getName());
            stmt.setString(2, room.getDescription());
            stmt.setInt(3, room.getCapacity());
            stmt.setBoolean(4, room.getIsActive());
            stmt.setInt(5, room.getRoomId());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Updating room failed, no rows affected.");
            }
            
            room.updateTimestamp();
            LOGGER.log(Level.INFO, "Room updated successfully with ID: {0}", room.getRoomId());
            return room;
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating room", ex);
            throw ex;
        }
    }
    
    @Override
    public void deleteById(Integer id) throws SQLException {
        String sql = "DELETE FROM rooms WHERE room_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Deleting room failed, no rows affected.");
            }
            
            LOGGER.log(Level.INFO, "Room deleted successfully with ID: {0}", id);
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting room by ID: " + id, ex);
            throw ex;
        }
    }
    
    @Override
    public void delete(Room room) throws SQLException {
        if (room.getRoomId() != null) {
            deleteById(room.getRoomId());
        }
    }
    
    @Override
    public boolean existsById(Integer id) throws SQLException {
        String sql = "SELECT 1 FROM rooms WHERE room_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error checking if room exists by ID: " + id, ex);
            throw ex;
        }
    }
    
    @Override
    public int count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM rooms";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error counting rooms", ex);
            throw ex;
        }
        
        return 0;
    }
    
    // Custom methods for room management
    
    /**
     * Get rooms by status (active/inactive)
     * @param isActive true for active rooms, false for inactive
     * @return List of rooms with specified status
     */
    public List<Room> getRoomsByStatus(boolean isActive) throws SQLException {
        String sql = "SELECT room_id, name, description, capacity, is_active, created_at, updated_at " +
                    "FROM rooms WHERE is_active = ? ORDER BY room_id";
        
        List<Room> rooms = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setBoolean(1, isActive);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    rooms.add(mapResultSetToRoom(rs));
                }
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding rooms by status: " + isActive, ex);
            throw ex;
        }
        
        return rooms;
    }
    
    /**
     * Get count of active rooms
     * @return Number of active rooms
     */
    public int getActiveRoomCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM rooms WHERE is_active = true";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error counting active rooms", ex);
            throw ex;
        }
        
        return 0;
    }
    
    /**
     * Get count of inactive rooms
     * @return Number of inactive rooms
     */
    public int getInactiveRoomCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM rooms WHERE is_active = false";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error counting inactive rooms", ex);
            throw ex;
        }
        
        return 0;
    }
    
    /**
     * Maps a ResultSet row to a Room object
     * @param rs ResultSet positioned at a room row
     * @return Room object
     */
    private Room mapResultSetToRoom(ResultSet rs) throws SQLException {
        Room room = new Room();
        room.setRoomId(rs.getInt("room_id"));
        room.setName(rs.getString("name"));
        room.setDescription(rs.getString("description"));
        room.setCapacity(rs.getInt("capacity"));
        room.setIsActive(rs.getBoolean("is_active"));
        room.setCreatedAt(rs.getTimestamp("created_at"));
        room.setUpdatedAt(rs.getTimestamp("updated_at"));
        return room;
    }
}
