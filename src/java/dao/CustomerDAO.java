/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBContext;
import static db.DBContext.getConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import model.Customer;
import org.mindrot.jbcrypt.BCrypt;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author quang
 */
public class CustomerDAO implements BaseDAO<Customer, Integer> {

    @Override
    public <S extends Customer> S save(S customer) {

        String sql = "INSERT INTO customers (full_name, email, hash_password, phone_number, role_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getEmail());
            ps.setString(3, customer.getHashPassword());
            ps.setString(4, customer.getPhoneNumber());
            ps.setInt(5, customer.getRoleId());
            int rows = ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();

        }

        return customer;

    }// cai nay kh fix nhé

    @Override
    public Optional<Customer> findById(Integer id) {
        String sql = "SELECT * FROM Customers WHERE customer_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setFullName(rs.getString("full_name"));
                customer.setEmail(rs.getString("email"));
                customer.setPhoneNumber(rs.getString("phone_number"));
                customer.setHashPassword(rs.getString("hash_password"));
                customer.setGender(rs.getString("gender"));
                customer.setBirthday(rs.getDate("birthday"));
                customer.setAddress(rs.getString("address"));
                customer.setIsActive(rs.getBoolean("is_active"));
                customer.setLoyaltyPoints(rs.getInt("loyalty_points"));
                customer.setRoleId(rs.getInt("role_id"));
                customer.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                customer.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());

                return Optional.of(customer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    public List<Customer> findByNameContain(String name) {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM Customers WHERE full_name LIKE ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + name + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setFullName(rs.getString("full_name"));
                customer.setEmail(rs.getString("email"));
                customer.setPhoneNumber(rs.getString("phone_number"));
                customer.setHashPassword(rs.getString("hash_password"));
                customer.setGender(rs.getString("gender"));
                customer.setBirthday(rs.getDate("birthday"));
                customer.setAddress(rs.getString("address"));
                customer.setIsActive(rs.getBoolean("is_active"));
                customer.setLoyaltyPoints(rs.getInt("loyalty_points"));
                customer.setRoleId(rs.getInt("role_id"));
                customer.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                customer.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                customers.add(customer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    public List<Customer> findByPhoneContain(String phone) {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM Customers WHERE phone_number LIKE ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + phone + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setFullName(rs.getString("full_name"));
                customer.setEmail(rs.getString("email"));
                customer.setPhoneNumber(rs.getString("phone_number"));
                customer.setHashPassword(rs.getString("hash_password"));
                customer.setGender(rs.getString("gender"));
                customer.setBirthday(rs.getDate("birthday"));
                customer.setAddress(rs.getString("address"));
                customer.setIsActive(rs.getBoolean("is_active"));
                customer.setLoyaltyPoints(rs.getInt("loyalty_points"));
                customer.setRoleId(rs.getInt("role_id"));
                customer.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                customer.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                customers.add(customer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    public List<Customer> findByEmailContain(String email) {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM Customers WHERE email LIKE ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + email + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setFullName(rs.getString("full_name"));
                customer.setEmail(rs.getString("email"));
                customer.setPhoneNumber(rs.getString("phone_number"));
                customer.setHashPassword(rs.getString("hash_password"));
                customer.setGender(rs.getString("gender"));
                customer.setBirthday(rs.getDate("birthday"));
                customer.setAddress(rs.getString("address"));
                customer.setIsActive(rs.getBoolean("is_active"));
                customer.setLoyaltyPoints(rs.getInt("loyalty_points"));
                customer.setRoleId(rs.getInt("role_id"));
                customer.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                customer.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                customers.add(customer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    @Override
    public boolean existsById(Integer id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from
        // nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void deleteById(Integer id) {
        String sql = "DELETE FROM customers WHERE customer_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public <S extends Customer> S update(S customer) {
        String sql = "UPDATE Customers SET full_name=?, email=?, phone_number=?, gender=?, birthday=?, address=?, is_active=?, loyalty_points=?, role_id=?, updated_at=? WHERE customer_id=?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getEmail());
            ps.setString(3, customer.getPhoneNumber());
            ps.setString(4, customer.getGender());
            ps.setDate(6, new java.sql.Date(customer.getBirthday().getTime()));
            ps.setString(6, customer.getAddress());
            ps.setBoolean(7, customer.getIsActive());
            ps.setInt(8, customer.getLoyaltyPoints());
            ps.setInt(9, customer.getRoleId());
            ps.setTimestamp(10, Timestamp.valueOf(java.time.LocalDateTime.now()));
            ps.setInt(11, customer.getCustomerId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customer;
    }

    @Override
    public void delete(Customer entity) {
        String sql = "DELETE FROM Customers WHERE customer_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, entity.getCustomerId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean isExistsByEmail(String email) {
        boolean isExists = false;
        // Validate input
        if (email == null || email.trim().isEmpty()) {
            return false; // or throw an IllegalArgumentException based on requirements
        }

        try (Connection connection = DBContext.getConnection();
                PreparedStatement ps = connection.prepareStatement(
                        "SELECT 1 FROM customers WHERE email = ? " +
                                "UNION " +
                                "SELECT 1 FROM users WHERE email = ? " +
                                "LIMIT 1")) {

            ps.setString(1, email);
            ps.setString(2, email);
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
                PreparedStatement ps = connection.prepareStatement(
                        "SELECT 1 FROM customers WHERE phone_number = ? " +
                                "UNION " +
                                "SELECT 1 FROM users WHERE phone_number = ? " +
                                "LIMIT 1")) {
            ps.setString(1, phone);
            ps.setString(2, phone);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
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

    public Optional<Customer> findCustomerByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return Optional.empty();
        }

        try (Connection connection = DBContext.getConnection();
                PreparedStatement ps = connection.prepareStatement("SELECT * FROM customers WHERE email = ?")) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setFullName(rs.getString("full_name"));
                customer.setEmail(rs.getString("email"));
                customer.setHashPassword(rs.getString("hash_password"));
                customer.setPhoneNumber(rs.getString("phone_number"));
                customer.setGender(rs.getString("gender"));
                customer.setBirthday(rs.getDate("birthday"));
                customer.setAddress(rs.getString("address"));
                customer.setIsActive(rs.getBoolean("is_active"));
                customer.setLoyaltyPoints(rs.getInt("loyalty_points"));
                customer.setRoleId(rs.getInt("role_id"));
                customer.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                customer.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());

                return Optional.of(customer);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return Optional.empty();
    }

    public Customer getCustomerByEmailAndPassword(String email, String password) {

        Customer customer = null;
        try (Connection connection = DBContext.getConnection();
                PreparedStatement ps = connection
                        .prepareStatement("SELECT * FROM Customers WHERE email = ?")) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("hash_password");
                if (BCrypt.checkpw(password, storedHash)) {
                    customer = new Customer();
                    customer.setCustomerId(rs.getInt("customer_id"));
                    customer.setFullName(rs.getString("full_name"));
                    customer.setEmail(rs.getString("email"));
                    customer.setHashPassword(rs.getString("hash_password"));
                    customer.setPhoneNumber(rs.getString("phone_number"));
                    customer.setRoleId(rs.getInt("role_id"));
                    customer.setIsActive(rs.getBoolean("is_active"));
                    customer.setGender(rs.getString("gender"));
                    customer.setAddress(rs.getString("address"));
                    customer.setBirthday(rs.getDate("birthday"));
                    customer.setLoyaltyPoints(rs.getInt("loyalty_points"));
                    // Handle optional timestamp fields
                    Timestamp createdAt = rs.getTimestamp("created_at");
                    if (createdAt != null) {
                        customer.setCreatedAt(createdAt.toLocalDateTime());
                    }
                    Timestamp updatedAt = rs.getTimestamp("updated_at");
                    if (updatedAt != null) {
                        customer.setUpdatedAt(updatedAt.toLocalDateTime());
                    }
                }
            }

        } catch (SQLException e) {
            return null; // or throw an exception based on requirements
        }

        return customer;
    }

    public static void main(String[] args) {
        CustomerDAO customerDAO = new CustomerDAO();
        // List<Customer> customers = customerDAO.findAll();
        // for (Customer customer : customers) {
        // System.out.println(customer.toString());
        // }
        //
        // System.out.println("Hejtrtrt");

        System.out.println(customerDAO.isExistsByEmail("quangkhoa5112@gmail.com"));
    }

    @Override
    public List<Customer> findAll() {

        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM customers";
        try (Connection conn = getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Customer c = new Customer();
                c.setCustomerId(rs.getInt("customer_id"));
                c.setFullName(rs.getString("full_name"));
                c.setEmail(rs.getString("email"));
                c.setHashPassword(rs.getString("hash_password"));
                c.setPhoneNumber(rs.getString("phone_number"));
                c.setGender(rs.getString("gender"));
                c.setBirthday(rs.getDate("birthday"));
                c.setAddress(rs.getString("address"));
                c.setIsActive(rs.getBoolean("is_active"));
                c.setLoyaltyPoints(rs.getInt("loyalty_points"));
                c.setRoleId(rs.getInt("role_id"));
                c.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                c.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Updates the password for a customer with the given email
     * 
     * @param email       The customer's email
     * @param newPassword The new plain text password (will be hashed)
     * @return true if password was updated successfully, false otherwise
     * @throws SQLException if database error occurs
     */
    public boolean updatePassword(String email, String newPassword) throws SQLException {
        if (email == null || email.trim().isEmpty() || newPassword == null || newPassword.trim().isEmpty()) {
            return false;
        }

        String sql = "UPDATE customers SET hash_password = ?, updated_at = ? WHERE email = ?";

        try (Connection connection = DBContext.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {

            // Hash the password using BCrypt (same as used in registration)
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

            stmt.setString(1, hashedPassword);
            stmt.setTimestamp(2, java.sql.Timestamp.valueOf(java.time.LocalDateTime.now()));
            stmt.setString(3, email);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Gets customer name by email for personalized emails
     * 
     * @param email The customer's email
     * @return The customer's full name, or null if not found
     */
    public String getCustomerNameByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return null;
        }

        String sql = "SELECT full_name FROM customers WHERE email = ?";

        try (Connection connection = DBContext.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("full_name");
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.WARNING,
                    "Error getting customer name for email: " + email, e);
        }

        return null;
    }

    /**
     * Updates customer profile information
     * 
     * @param customer Customer object with updated information
     * @return true if update was successful, false otherwise
     * @throws SQLException if database error occurs
     */
    public boolean updateProfile(Customer customer) throws SQLException {
        if (customer == null || customer.getCustomerId() == null) {
            return false;
        }

        String sql = "UPDATE customers SET full_name = ?, phone_number = ?, gender = ?, birthday = ?, address = ?, updated_at = ? WHERE customer_id = ?";

        try (Connection connection = DBContext.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, customer.getFullName());
            stmt.setString(2, customer.getPhoneNumber());
            stmt.setString(3, customer.getGender());
            stmt.setDate(4,
                    customer.getBirthday() != null ? new java.sql.Date(customer.getBirthday().getTime()) : null);
            stmt.setString(5, customer.getAddress());
            stmt.setTimestamp(6, java.sql.Timestamp.valueOf(java.time.LocalDateTime.now()));
            stmt.setInt(7, customer.getCustomerId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

}
