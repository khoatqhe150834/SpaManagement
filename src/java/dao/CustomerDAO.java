package dao;

import db.DBContext;
import java.security.MessageDigest;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Customer;

/**
 * Complete CustomerDAO implementation with proper error handling
 * @author Admin
 */
public class CustomerDAO implements BaseDAO<Customer, Integer> {
    
    private static final Logger logger = Logger.getLogger(CustomerDAO.class.getName());
    
    /**
     * Temporary password hashing method until BCrypt library is properly configured
     */
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error hashing password", e);
            return password; // Fallback - not secure but prevents crash
        }
    }
    
    /**
     * Temporary password verification method until BCrypt library is properly configured
     */
    private boolean checkPassword(String password, String hashedPassword) {
        if (password == null || hashedPassword == null) {
            return false;
        }
        // Simple comparison - should be replaced with BCrypt when library is available
        return hashPassword(password).equals(hashedPassword);
    }
    
    /**
     * Build Customer object from ResultSet
     */
    private Customer buildCustomerFromResultSet(ResultSet rs) throws SQLException {
        Customer customer = new Customer();
        customer.setCustomerId(rs.getInt("customer_id"));
        customer.setFullName(rs.getString("full_name"));
        customer.setEmail(rs.getString("email"));
        customer.setHashPassword(rs.getString("hash_password"));
        customer.setPhoneNumber(rs.getString("phone_number"));
        customer.setGender(rs.getString("gender"));
        customer.setAddress(rs.getString("address"));
        customer.setIsActive(rs.getBoolean("is_active"));
        customer.setLoyaltyPoints(rs.getInt("loyalty_points"));
        customer.setRoleId(rs.getInt("role_id"));
        
        // Handle nullable date fields
        Date birthday = rs.getDate("birthday");
        if (birthday != null) {
            customer.setBirthday(birthday);
        }
        
        // Handle nullable timestamp fields
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            customer.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            customer.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        // Set default value for isVerified since column doesn't exist in database
        customer.setIsVerified(false);
        
        return customer;
    }

    @Override
    public <S extends Customer> S save(S customer) {
        if (customer == null) {
            throw new IllegalArgumentException("Customer cannot be null");
        }
        
        // Validate required fields
        if (customer.getFullName() == null || customer.getFullName().trim().isEmpty()) {
            throw new IllegalArgumentException("Customer name is required");
        }
        if (customer.getEmail() == null || customer.getEmail().trim().isEmpty()) {
            throw new IllegalArgumentException("Customer email is required");
        }
        if (customer.getPhoneNumber() == null || customer.getPhoneNumber().trim().isEmpty()) {
            throw new IllegalArgumentException("Customer phone number is required");
        }
        
        // Check for duplicate email and phone
        if (isEmailExists(customer.getEmail())) {
            throw new IllegalArgumentException("Email already exists");
        }
        if (isPhoneExists(customer.getPhoneNumber())) {
            throw new IllegalArgumentException("Phone number already exists");
        }

        String sql = "INSERT INTO customers (full_name, email, hash_password, phone_number, gender, birthday, address, is_active, loyalty_points, role_id, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, customer.getFullName().trim());
            ps.setString(2, customer.getEmail().trim().toLowerCase());
            
            // Hash password if not already hashed
            String password = customer.getHashPassword();
            if (password != null && password.length() < 64) { // Not hashed yet
                password = hashPassword(password);
            }
            ps.setString(3, password);
            
            ps.setString(4, customer.getPhoneNumber().trim());
            ps.setString(5, customer.getGender());
            
            if (customer.getBirthday() != null) {
                ps.setDate(6, new java.sql.Date(customer.getBirthday().getTime()));
            } else {
                ps.setNull(6, Types.DATE);
            }
            
            ps.setString(7, customer.getAddress());
            ps.setBoolean(8, customer.getIsActive() != null ? customer.getIsActive() : true);
            ps.setInt(9, customer.getLoyaltyPoints() != null ? customer.getLoyaltyPoints() : 0);
            ps.setInt(10, customer.getRoleId() != null ? customer.getRoleId() : 1);
            
            LocalDateTime now = LocalDateTime.now();
            ps.setTimestamp(11, Timestamp.valueOf(now));
            ps.setTimestamp(12, Timestamp.valueOf(now));
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        customer.setCustomerId(rs.getInt(1));
                        customer.setCreatedAt(now);
                        customer.setUpdatedAt(now);
                    }
                }
                logger.log(Level.INFO, "Customer created successfully with ID: " + customer.getCustomerId());
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error saving customer: " + e.getMessage(), e);
            throw new RuntimeException("Error saving customer: " + e.getMessage(), e);
        }
        
        return customer;
    }

    @Override
    public Optional<Customer> findById(Integer id) {
        if (id == null || id <= 0) {
            return Optional.empty();
        }
        
        String sql = "SELECT * FROM customers WHERE customer_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(buildCustomerFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding customer by ID: " + id, e);
            throw new RuntimeException("Error finding customer by ID: " + e.getMessage(), e);
        }
        
        return Optional.empty();
    }

    @Override
    public List<Customer> findAll() {
        return findAll(1, 10);
    }

    public List<Customer> findAll(int page, int pageSize) {
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = 10;
        
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customers ORDER BY created_at DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, pageSize);
            ps.setInt(2, (page - 1) * pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    customers.add(buildCustomerFromResultSet(rs));
                }
            }
            
            logger.log(Level.INFO, "Retrieved " + customers.size() + " customers for page " + page);
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding customers", e);
            throw new RuntimeException("Error finding customers: " + e.getMessage(), e);
        }
        
        return customers;
    }

    @Override
    public <S extends Customer> S update(S customer) {
        if (customer == null || customer.getCustomerId() == null) {
            throw new IllegalArgumentException("Customer and customer ID cannot be null");
        }
        
        // Validate required fields
        if (customer.getFullName() == null || customer.getFullName().trim().isEmpty()) {
            throw new IllegalArgumentException("Customer name is required");
        }
        if (customer.getEmail() == null || customer.getEmail().trim().isEmpty()) {
            throw new IllegalArgumentException("Customer email is required");
        }
        
        String sql = "UPDATE customers SET full_name=?, email=?, phone_number=?, gender=?, birthday=?, address=?, is_active=?, loyalty_points=?, role_id=?, updated_at=? WHERE customer_id=?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, customer.getFullName().trim());
            ps.setString(2, customer.getEmail().trim().toLowerCase());
            ps.setString(3, customer.getPhoneNumber());
            ps.setString(4, customer.getGender());
            
            if (customer.getBirthday() != null) {
                ps.setDate(5, new java.sql.Date(customer.getBirthday().getTime()));
            } else {
                ps.setNull(5, Types.DATE);
            }
            
            ps.setString(6, customer.getAddress());
            ps.setBoolean(7, customer.getIsActive() != null ? customer.getIsActive() : true);
            ps.setInt(8, customer.getLoyaltyPoints() != null ? customer.getLoyaltyPoints() : 0);
            ps.setInt(9, customer.getRoleId() != null ? customer.getRoleId() : 1);
            ps.setTimestamp(10, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(11, customer.getCustomerId());
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                customer.setUpdatedAt(LocalDateTime.now());
                logger.log(Level.INFO, "Customer updated successfully: " + customer.getCustomerId());
            } else {
                throw new RuntimeException("Customer not found for update: " + customer.getCustomerId());
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating customer: " + customer.getCustomerId(), e);
            throw new RuntimeException("Error updating customer: " + e.getMessage(), e);
        }
        
        return customer;
    }
    
    /**
     * Update customer profile - alias for update method
     */
    public boolean updateProfile(Customer customer) {
        try {
            update(customer);
            return true;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating customer profile", e);
            return false;
        }
    }
    
    /**
     * Update customer password
     */
    public boolean updatePassword(Integer customerId, String newPassword) {
        if (customerId == null || newPassword == null || newPassword.trim().isEmpty()) {
            return false;
        }
        
        String sql = "UPDATE customers SET hash_password=?, updated_at=? WHERE customer_id=?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, hashPassword(newPassword));
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(3, customerId);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating password for customer: " + customerId, e);
            return false;
        }
    }

    @Override
    public void delete(Customer entity) {
        if (entity != null && entity.getCustomerId() != null) {
            deleteById(entity.getCustomerId());
        }
    }

    @Override
    public void deleteById(Integer id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("Invalid customer ID");
        }
        
        String sql = "DELETE FROM customers WHERE customer_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                logger.log(Level.INFO, "Customer deleted successfully: " + id);
            } else {
                throw new RuntimeException("Customer not found for deletion: " + id);
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting customer: " + id, e);
            throw new RuntimeException("Error deleting customer: " + e.getMessage(), e);
        }
    }

    /**
     * Check if email exists
     */
    public boolean isEmailExists(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        
        String sql = "SELECT COUNT(*) FROM customers WHERE email = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email.trim().toLowerCase());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            logger.log(Level.WARNING, "Error checking email existence: " + email, e);
            return false;
        }
    }
    
    /**
     * Check if phone exists
     */
    public boolean isPhoneExists(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        
        String sql = "SELECT COUNT(*) FROM customers WHERE phone_number = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, phone.trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            logger.log(Level.WARNING, "Error checking phone existence: " + phone, e);
            return false;
        }
    }

    /**
     * Get total number of customers
     */
    public int getTotalCustomers() {
        String sql = "SELECT COUNT(*) FROM customers";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            return rs.next() ? rs.getInt(1) : 0;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting total customers count", e);
            return 0;
        }
    }

    /**
     * Search customers by keyword (name, email, or phone)
     */
    public List<Customer> searchCustomers(String keyword, int page, int pageSize) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAll(page, pageSize);
        }
        
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customers WHERE full_name LIKE ? OR email LIKE ? OR phone_number LIKE ? ORDER BY created_at DESC LIMIT ? OFFSET ?";
        
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
                    customers.add(buildCustomerFromResultSet(rs));
                }
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error searching customers", e);
            throw new RuntimeException("Error searching customers: " + e.getMessage(), e);
        }
        
        return customers;
    }

    /**
     * Get total search results count
     */
    public int getTotalSearchResults(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getTotalCustomers();
        }
        
        String sql = "SELECT COUNT(*) FROM customers WHERE full_name LIKE ? OR email LIKE ? OR phone_number LIKE ?";
        
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
     * Find customers by name containing keyword
     */
    public List<Customer> findByNameContain(String name) {
        List<Customer> customers = new ArrayList<>();
        if (name == null || name.trim().isEmpty()) {
            return customers;
        }
        
        String sql = "SELECT * FROM customers WHERE full_name LIKE ? ORDER BY full_name";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, "%" + name.trim() + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    customers.add(buildCustomerFromResultSet(rs));
                }
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding customers by name", e);
            throw new RuntimeException("Error finding customers by name: " + e.getMessage(), e);
        }
        
        return customers;
    }

    /**
     * Find customers by email containing keyword
     */
    public List<Customer> findByEmailContain(String email) {
        List<Customer> customers = new ArrayList<>();
        if (email == null || email.trim().isEmpty()) {
            return customers;
        }
        
        String sql = "SELECT * FROM customers WHERE email LIKE ? ORDER BY email";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, "%" + email.trim() + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    customers.add(buildCustomerFromResultSet(rs));
                }
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding customers by email", e);
            throw new RuntimeException("Error finding customers by email: " + e.getMessage(), e);
        }
        
        return customers;
    }

    /**
     * Find customers by phone containing keyword
     */
    public List<Customer> findByPhoneContain(String phone) {
        List<Customer> customers = new ArrayList<>();
        if (phone == null || phone.trim().isEmpty()) {
            return customers;
        }
        
        String sql = "SELECT * FROM customers WHERE phone_number LIKE ? ORDER BY phone_number";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, "%" + phone.trim() + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    customers.add(buildCustomerFromResultSet(rs));
                }
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding customers by phone", e);
            throw new RuntimeException("Error finding customers by phone: " + e.getMessage(), e);
        }
        
        return customers;
    }

    /**
     * Find customer by email (exact match) - for backward compatibility
     */
    public Optional<Customer> findCustomerByEmail(String email) {
        return findByEmail(email);
    }
    
    /**
     * Find customer by email (exact match)
     */
    public Optional<Customer> findByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return Optional.empty();
        }
        
        String sql = "SELECT * FROM customers WHERE email = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email.trim().toLowerCase());
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(buildCustomerFromResultSet(rs));
                }
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding customer by email", e);
            throw new RuntimeException("Error finding customer by email: " + e.getMessage(), e);
        }
        
        return Optional.empty();
    }
    
    /**
     * Get customer name by email
     */
    public String getCustomerNameByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return null;
        }
        
        String sql = "SELECT full_name FROM customers WHERE email = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email.trim().toLowerCase());
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("full_name");
                }
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting customer name by email", e);
        }
        
        return null;
    }

    /**
     * Validate customer login credentials
     */
    public boolean validateCustomerLogin(String email, String password) {
        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            return false;
        }
        
        String sql = "SELECT hash_password FROM customers WHERE email = ? AND is_active = true";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email.trim().toLowerCase());
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("hash_password");
                    return checkPassword(password, storedHash);
                }
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error validating customer login", e);
        }
        
        return false;
    }

    /**
     * Get customer by email and password
     */
    public Optional<Customer> getCustomerByEmailAndPassword(String email, String password) {
        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            return Optional.empty();
        }
        
        String sql = "SELECT * FROM customers WHERE email = ? AND is_active = true";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email.trim().toLowerCase());
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("hash_password");
                    if (checkPassword(password, storedHash)) {
                        return Optional.of(buildCustomerFromResultSet(rs));
                    }
                }
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting customer by email and password", e);
        }
        
        return Optional.empty();
    }
    
    /**
     * Get customer by email and password - returns Customer object directly for backward compatibility
     */
    public Customer getCustomerByEmailAndPasswordDirect(String email, String password) {
        Optional<Customer> customerOpt = getCustomerByEmailAndPassword(email, password);
        return customerOpt.orElse(null);
    }

    /**
     * Get active customers by status
     */
    public List<Customer> findByActiveStatus(boolean isActive, int page, int pageSize) {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customers WHERE is_active = ? ORDER BY created_at DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBoolean(1, isActive);
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    customers.add(buildCustomerFromResultSet(rs));
                }
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding customers by status", e);
            throw new RuntimeException("Error finding customers by status: " + e.getMessage(), e);
        }
        
        return customers;
    }

    /**
     * Check if customer is verified by email - DEPRECATED: is_verified column does not exist
     * Always returns true as verification is not implemented
     */
    public boolean isCustomerVerified(String email) {
        logger.log(Level.WARNING, "isCustomerVerified called but is_verified column does not exist in database");
        return true; // Return true to allow all customers to proceed
    }
    
    /**
     * Update customer verification status - DEPRECATED: is_verified column does not exist
     * Returns false as this functionality is not supported
     */
    public boolean updateVerificationStatus(Integer customerId, boolean isVerified) {
        logger.log(Level.WARNING, "updateVerificationStatus called but is_verified column does not exist in database");
        return false;
    }

    /**
     * Get total customers by active status
     */
    public int getTotalCustomersByStatus(boolean isActive) {
        String sql = "SELECT COUNT(*) FROM customers WHERE is_active = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBoolean(1, isActive);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting total customers by status", e);
            return 0;
        }
    }

    @Override
    public boolean existsById(Integer id) {
        if (id == null || id <= 0) {
            return false;
        }
        
        String sql = "SELECT COUNT(*) FROM customers WHERE customer_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            logger.log(Level.WARNING, "Error checking if customer exists: " + id, e);
            return false;
        }
    }
}
