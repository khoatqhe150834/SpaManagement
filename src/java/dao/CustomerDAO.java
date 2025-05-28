/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBContext;
import java.sql.*;
import java.util.List;
import java.util.Optional;
import model.Customer;
import org.mindrot.jbcrypt.BCrypt;
/**
 *
 * @author quang
 */
public class CustomerDAO implements BaseDAO<Customer, Integer> {

    @Override
    public <S extends Customer> S save(S customer) {

        String sql = "INSERT INTO customers (full_name, email, hash_password, phone_number) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getEmail());
            ps.setString(3, customer.getHashPassword());
            ps.setString(4, customer.getPhoneNumber());
            int rows = ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();

        }

        return customer;

    }

    @Override
    public Optional<Customer> findById(Integer id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from
                                                                       // nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<Customer> findAll() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from
                                                                       // nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean existsById(Integer id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from
                                                                       // nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void deleteById(Integer id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from
                                                                       // nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public <S extends Customer> S update(S entity) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from
                                                                       // nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void delete(Customer entity) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from
                                                                       // nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public boolean isExistsByEmail(String email) {
        boolean isExists = false;
        // Validate input
        if (email == null || email.trim().isEmpty()) {
            return false; // or throw an IllegalArgumentException based on requirements
        }

        try (Connection connection = DBContext.getConnection();
                PreparedStatement ps = connection.prepareStatement("SELECT * FROM Customers WHERE email = ?")) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                isExists = true;
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error checking email existence: " + e.getMessage(), e);
        }

        return isExists;

    }

    public boolean isExistsByPhone(String phone) {
        boolean isExists = false;
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        try (Connection connection = DBContext.getConnection();
                PreparedStatement ps = connection
                        .prepareStatement("SELECT COUNT(*) FROM Customers WHERE phone_number = ?")) {
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                isExists = true;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking phone existence: " + e.getMessage(), e);
        }
        return isExists;
    }

    public boolean validateAccount(String email, String password) {
        try (Connection connection = DBContext.getConnection();
                PreparedStatement ps = connection
                        .prepareStatement("SELECT hash_password FROM Customers WHERE email = ?")) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("hash_password");
                return BCrypt.checkpw(password, storedHash);
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error validating account: " + e.getMessage(), e);
        }

        return false;
    }

}
