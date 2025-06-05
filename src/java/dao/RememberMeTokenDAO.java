package dao;

import db.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import model.RememberMeToken;

public class RememberMeTokenDAO {
    
    // Insert a new token into the database
    public void insertToken(RememberMeToken token) throws SQLException {
        String sql = "INSERT INTO remember_me_tokens (email, token, expiry_date) VALUES (?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token.getEmail());
            stmt.setString(2, token.getToken());
            stmt.setTimestamp(3, new java.sql.Timestamp(token.getExpiryDate().getTime()));
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error inserting token: " + e.getMessage());
            throw e;
        }
    }
    
    // Find a token by its value and return the associated RememberMeToken
    public RememberMeToken findToken(String tokenValue) throws SQLException {
        String sql = "SELECT id, email, token, expiry_date, created_at FROM remember_me_tokens " +
                     "WHERE token = ? AND expiry_date > NOW()";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, tokenValue);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new RememberMeToken(
                        rs.getInt("id"),
                        rs.getString("email"),
                        rs.getString("token"),
                        new Date(rs.getTimestamp("expiry_date").getTime()),
                        new Date(rs.getTimestamp("created_at").getTime())
                    );
                }
            }
        } catch (SQLException e) {
            System.out.println("Error finding token: " + e.getMessage());
            throw e;
        }
        return null; // Token not found or expired
    }
    
    // Delete a token from the database
    public void deleteToken(String tokenValue) throws SQLException {
        String sql = "DELETE FROM remember_me_tokens WHERE token = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, tokenValue);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error deleting token: " + e.getMessage());
            throw e;
        }
    }
    
    // Delete all tokens for a given email
    public void deleteTokensByEmail(String email) throws SQLException {
        String sql = "DELETE FROM remember_me_tokens WHERE email = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error deleting tokens by email: " + e.getMessage());
            throw e;
        }
    }
}