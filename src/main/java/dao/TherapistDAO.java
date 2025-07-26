package dao;

import db.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;

/**
 * Data Access Object for Therapist operations
 * 
 * @author SpaManagement
 */
public class TherapistDAO {
    
    private static final Logger LOGGER = Logger.getLogger(TherapistDAO.class.getName());
    
    /**
     * Find therapists by service type
     */
    public List<User> findByServiceType(Integer serviceTypeId) throws SQLException {
        List<User> therapists = new ArrayList<>();
        String sql = "SELECT u.user_id, u.full_name, u.email, u.phone_number, " +
                    "t.years_of_experience, t.bio, t.availability_status " +
                    "FROM users u " +
                    "JOIN therapists t ON u.user_id = t.user_id " +
                    "WHERE u.role_id = 3 AND u.is_active = 1 " +
                    "AND (t.service_type_id = ? OR t.service_type_id IS NULL) " +
                    "ORDER BY u.full_name";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, serviceTypeId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    User therapist = new User();
                    therapist.setUserId(rs.getInt("user_id"));
                    therapist.setFullName(rs.getString("full_name"));
                    therapist.setEmail(rs.getString("email"));
                    therapist.setPhoneNumber(rs.getString("phone_number"));
                    
                    therapists.add(therapist);
                }
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding therapists by service type: " + serviceTypeId, ex);
            throw ex;
        }
        
        return therapists;
    }
    
    /**
     * Find all active therapists
     */
    public List<User> findAllActive() throws SQLException {
        List<User> therapists = new ArrayList<>();
        String sql = "SELECT u.user_id, u.full_name, u.email, u.phone_number, " +
                    "t.years_of_experience, t.bio, t.availability_status " +
                    "FROM users u " +
                    "JOIN therapists t ON u.user_id = t.user_id " +
                    "WHERE u.role_id = 3 AND u.is_active = 1 " +
                    "ORDER BY u.full_name";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                User therapist = new User();
                therapist.setUserId(rs.getInt("user_id"));
                therapist.setFullName(rs.getString("full_name"));
                therapist.setEmail(rs.getString("email"));
                therapist.setPhoneNumber(rs.getString("phone_number"));
                
                therapists.add(therapist);
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding all active therapists", ex);
            throw ex;
        }
        
        return therapists;
    }
    
    /**
     * Find therapist by ID
     */
    public User findById(Integer therapistId) throws SQLException {
        String sql = "SELECT u.user_id, u.full_name, u.email, u.phone_number, " +
                    "t.years_of_experience, t.bio, t.availability_status " +
                    "FROM users u " +
                    "JOIN therapists t ON u.user_id = t.user_id " +
                    "WHERE u.user_id = ? AND u.role_id = 3 AND u.is_active = 1";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, therapistId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User therapist = new User();
                    therapist.setUserId(rs.getInt("user_id"));
                    therapist.setFullName(rs.getString("full_name"));
                    therapist.setEmail(rs.getString("email"));
                    therapist.setPhoneNumber(rs.getString("phone_number"));
                    
                    return therapist;
                }
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding therapist by ID: " + therapistId, ex);
            throw ex;
        }
        
        return null;
    }
}