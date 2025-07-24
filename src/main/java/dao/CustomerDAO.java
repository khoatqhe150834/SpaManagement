package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.mindrot.jbcrypt.BCrypt;

import db.DBContext;
import model.Customer;

/**
 * @author quang
 */
public class CustomerDAO implements BaseDAO<Customer, Integer> {

    // Helper method to build Customer from ResultSet
    private Customer buildCustomerFromResultSet(ResultSet rs) throws SQLException {
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
        // Handle nullable role_id field
        customer.setRoleId(rs.getObject("role_id") != null ? rs.getInt("role_id") : null);
        // Handle nullable timestamp fields
        java.sql.Timestamp createdAtTs = rs.getTimestamp("created_at");
        customer.setCreatedAt(createdAtTs != null ? createdAtTs.toLocalDateTime() : null);
        
        java.sql.Timestamp updatedAtTs = rs.getTimestamp("updated_at");
        customer.setUpdatedAt(updatedAtTs != null ? updatedAtTs.toLocalDateTime() : null);
        customer.setIsVerified(rs.getObject("is_verified") != null ? rs.getBoolean("is_verified") : false);
        customer.setAvatarUrl(rs.getString("avatar_url"));
        customer.setNotes(rs.getString("notes"));
        
        // Đọc cột tier nếu có
        try {
            customer.setTier(rs.getString("tier"));
        } catch (SQLException e) {
            // Cột tier chưa tồn tại, đặt giá trị mặc định
            customer.setTier("DONG");
        }
        
        return customer;
    }

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
            throw new RuntimeException("Error finding customers by status: " + e.getMessage(), e);
        }

        return customers;
    }

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

        String sql = "SELECT * FROM customers WHERE email LIKE ?";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + email.trim() + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    customers.add(buildCustomerFromResultSet(rs));
                }
            }

        } catch (SQLException e) {
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

        String sql = "SELECT * FROM customers WHERE phone_number LIKE ?";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + phone.trim() + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    customers.add(buildCustomerFromResultSet(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error finding customers by phone: " + e.getMessage(), e);
        }

        return customers;
    }

    @Override
    public <S extends Customer> S save(S customer) {
        AccountDAO accountDAO = new AccountDAO();

        // Validate required fields
        if (customer.getFullName() == null || customer.getFullName().trim().isEmpty()) {
            throw new IllegalArgumentException("Tên khách hàng là bắt buộc");
        }

        // Validate email if provided
        if (customer.getEmail() != null && !customer.getEmail().trim().isEmpty()) {
            if (accountDAO.isEmailTakenInSystem(customer.getEmail())) {
                throw new IllegalArgumentException("Email đã tồn tại trong hệ thống");
            }
        }
        
        // Validate phone if provided
        if (customer.getPhoneNumber() != null && !customer.getPhoneNumber().trim().isEmpty()) {
            if (accountDAO.isPhoneTakenInSystem(customer.getPhoneNumber())) {
                throw new IllegalArgumentException("Số điện thoại đã tồn tại trong hệ thống");
            }
        }

        String sql = "INSERT INTO customers (full_name, email, hash_password, phone_number, role_id, is_active, loyalty_points, is_verified, created_at, updated_at, notes, gender, birthday, address, avatar_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getEmail());
            
            // Handle password - only hash if not null and not empty
            if (customer.getHashPassword() != null && !customer.getHashPassword().trim().isEmpty()) {
                ps.setString(3, BCrypt.hashpw(customer.getHashPassword(), BCrypt.gensalt()));
            } else {
                ps.setString(3, null);
            }
            
            ps.setString(4, customer.getPhoneNumber());
            ps.setObject(5, customer.getRoleId());
            ps.setBoolean(6, customer.getIsActive() != null ? customer.getIsActive() : true);
            ps.setInt(7, customer.getLoyaltyPoints() != null ? customer.getLoyaltyPoints() : 0);
            ps.setBoolean(8, customer.getIsVerified() != null ? customer.getIsVerified() : false);
            ps.setTimestamp(9, Timestamp.valueOf(java.time.LocalDateTime.now()));
            ps.setTimestamp(10, Timestamp.valueOf(java.time.LocalDateTime.now()));
            ps.setString(11, customer.getNotes());
            ps.setString(12, customer.getGender());
            ps.setDate(13, customer.getBirthday() != null ? new java.sql.Date(customer.getBirthday().getTime()) : null);
            ps.setString(14, customer.getAddress());
            ps.setString(15, customer.getAvatarUrl());
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    customer.setCustomerId(rs.getInt(1));
                }
                Logger.getLogger(CustomerDAO.class.getName()).log(Level.INFO, 
                    "Successfully saved customer with ID: " + customer.getCustomerId());
                return customer;
            } else {
                throw new RuntimeException("Không thể lưu khách hàng - không có dòng nào được tạo");
            }
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, 
                "SQL Error saving customer: " + e.getMessage(), e);
            throw new RuntimeException("Lỗi database khi lưu khách hàng: " + e.getMessage(), e);
        }
    }

    @Override
    public Optional<Customer> findById(Integer id) {
        String sql = "SELECT * FROM customers WHERE customer_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(buildCustomerFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding customer by ID: " + e.getMessage(), e);
        }
        return Optional.empty();
    }

    @Override
    public List<Customer> findAll() {
        return findAll(1, 10); // Default to first page with 10 items
    }

    /**
     * Find all customers without pagination (for dropdowns and filters)
     */
    public List<Customer> findAllCustomers() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM customers ORDER BY full_name ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(buildCustomerFromResultSet(rs));
            }
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.INFO,
                    "Retrieved " + list.size() + " customers (all)");
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, "Error finding all customers", e);
            throw new RuntimeException("Error finding all customers: " + e.getMessage(), e);
        }
        return list;
    }

    public List<Customer> findAll(int page, int pageSize) {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM customers LIMIT ? OFFSET ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pageSize);
            ps.setInt(2, (page - 1) * pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(buildCustomerFromResultSet(rs));
                }
                Logger.getLogger(CustomerDAO.class.getName()).log(Level.INFO,
                        "Retrieved " + list.size() + " customers for page " + page);
            }
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, "Error finding customers", e);
            throw new RuntimeException("Error finding customers: " + e.getMessage(), e);
        }
        return list;
    }

    public int getTotalCustomers() {
        String sql = "SELECT COUNT(*) FROM customers";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting customers: " + e.getMessage(), e);
        }
        return 0;
    }

    @Override
    public void deleteById(Integer id) {
        String sql = "DELETE FROM customers WHERE customer_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting customer: " + e.getMessage(), e);
        }
    }

    public boolean deactivateCustomer(int customerId) {
        String sql = "UPDATE customers SET is_active = false WHERE customer_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, "Error deactivating customer", e);
            return false;
        }
    }

    public boolean activateCustomer(int customerId) {
        String sql = "UPDATE customers SET is_active = true WHERE customer_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, "Error activating customer", e);
            return false;
        }
    }

    @Override
    public <S extends Customer> S update(S customer) {
        // Validate required fields
        if (customer.getCustomerId() == null || customer.getCustomerId() <= 0) {
            throw new IllegalArgumentException("ID khách hàng không hợp lệ");
        }
        
        if (customer.getFullName() == null || customer.getFullName().trim().isEmpty()) {
            throw new IllegalArgumentException("Tên khách hàng là bắt buộc");
        }

        String sql = "UPDATE customers SET full_name=?, email=?, phone_number=?, gender=?, birthday=?, address=?, is_active=?, loyalty_points=?, role_id=?, is_verified=?, updated_at=?, avatar_url=?, notes=? WHERE customer_id=?";
        
        // DEBUG LOGGING
        Logger.getLogger(CustomerDAO.class.getName()).log(Level.INFO, "=== DAO UPDATE DEBUG ===");
        Logger.getLogger(CustomerDAO.class.getName()).log(Level.INFO, "Customer ID: " + customer.getCustomerId());
        Logger.getLogger(CustomerDAO.class.getName()).log(Level.INFO, "Full Name: " + customer.getFullName());
        Logger.getLogger(CustomerDAO.class.getName()).log(Level.INFO, "Gender: " + customer.getGender());
        Logger.getLogger(CustomerDAO.class.getName()).log(Level.INFO, "Phone: " + customer.getPhoneNumber());
        Logger.getLogger(CustomerDAO.class.getName()).log(Level.INFO, "=== END DAO DEBUG ===");
        
        try (Connection conn = DBContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getEmail());
            ps.setString(3, customer.getPhoneNumber());
            ps.setString(4, customer.getGender());
            ps.setDate(5, customer.getBirthday() != null ? new java.sql.Date(customer.getBirthday().getTime()) : null);
            ps.setString(6, customer.getAddress());
            ps.setBoolean(7, customer.getIsActive() != null ? customer.getIsActive() : true);
            ps.setInt(8, customer.getLoyaltyPoints() != null ? customer.getLoyaltyPoints() : 0);
            ps.setObject(9, customer.getRoleId());
            ps.setBoolean(10, customer.getIsVerified() != null ? customer.getIsVerified() : false);
            ps.setTimestamp(11, Timestamp.valueOf(java.time.LocalDateTime.now()));
            ps.setString(12, customer.getAvatarUrl());
            ps.setString(13, customer.getNotes());
            ps.setInt(14, customer.getCustomerId());
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                Logger.getLogger(CustomerDAO.class.getName()).log(Level.INFO, 
                    "Successfully updated customer with ID: " + customer.getCustomerId());
                return customer;
            } else {
                throw new RuntimeException("Không thể cập nhật khách hàng - không tìm thấy khách hàng với ID: " + customer.getCustomerId());
            }
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, 
                "SQL Error updating customer: " + e.getMessage(), e);
            throw new RuntimeException("Lỗi database khi cập nhật khách hàng: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Customer entity) {
        deleteById(entity.getCustomerId());
    }

    public boolean validateAccount(String email, String password) {
        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            return false;
        }
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement("SELECT hash_password FROM customers WHERE email = ?")) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("hash_password");
                    return BCrypt.checkpw(password, storedHash);
                }
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
        String sql = "SELECT * FROM customers WHERE email = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(buildCustomerFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding customer by email: " + e.getMessage(), e);
        }
        return Optional.empty();
    }

    public Customer getCustomerByEmailAndPassword(String email, String password) {
        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            return null;
        }
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM customers WHERE email = ?")) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("hash_password");
                if (BCrypt.checkpw(password, storedHash)) {
                    Customer customer = new Customer();
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
                    customer.setNotes(rs.getString("notes"));
                    return customer; // <- THIS WAS MISSING!
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error getting customer by email and password: " + e.getMessage(), e);
        }
        return null;
    }

    public String getCustomerNameByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return null;
        }
        String sql = "SELECT full_name FROM customers WHERE email = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
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

    /**
     * Checks if a customer is verified by their email address.
     * 
     * @param email The customer's email
     * @return true if the customer exists and is_verified is true, false otherwise
     */
    public boolean isCustomerVerified(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        String sql = "SELECT is_verified FROM customers WHERE email = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBoolean("is_verified");
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking if customer is verified: " + e.getMessage(), e);
        }
        return false;
    }

    /**
     * Updates the verification status of a customer by email address.
     * 
     * @param email      The customer's email
     * @param isVerified The new verification status
     * @return true if the update was successful, false otherwise
     */
    public boolean updateCustomerVerificationStatus(String email, boolean isVerified) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        String sql = "UPDATE customers SET is_verified = ?, updated_at = ? WHERE email = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isVerified);
            ps.setTimestamp(2, Timestamp.valueOf(java.time.LocalDateTime.now()));
            ps.setString(3, email);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating customer verification status: " + e.getMessage(), e);
        }
    }

    public static void main(String[] args) {
        CustomerDAO customerDAO = new CustomerDAO();

        // --- Test for update method ---
        int customerIdToUpdate = 2; // Use an ID that exists in your test data
        System.out.println("--- Starting update test for customer ID: " + customerIdToUpdate + " ---");

        // 1. Fetch the customer's data before the update
        Optional<Customer> beforeUpdateOpt = customerDAO.findById(customerIdToUpdate);
        if (!beforeUpdateOpt.isPresent()) {
            System.out.println("TEST FAILED: Cannot find customer with ID " + customerIdToUpdate + " to update.");
            return;
        }
        Customer customerToUpdate = beforeUpdateOpt.get();
        System.out.println("DATA BEFORE UPDATE:");
        System.out.println(customerToUpdate);

        // 2. Modify the customer's data
        String newAddress = "123 Đường Cập Nhật, Quận Hoàn Kiếm, Hà Nội";
        customerToUpdate.setAddress(newAddress);

        System.out.println("\n... Attempting to update address to '" + newAddress + " ...");

        // 3. Call the update method to save changes
        customerDAO.update(customerToUpdate);
        System.out.println("... Update method executed ...");

        // 4. Fetch the data again to verify the changes
        Optional<Customer> afterUpdateOpt = customerDAO.findById(customerIdToUpdate);
        if (afterUpdateOpt.isPresent()) {
            System.out.println("\nDATA AFTER UPDATE:");
            System.out.println(afterUpdateOpt.get());
        } else {
            System.out.println("TEST FAILED: Could not retrieve customer after update.");
        }

        // --- Other tests from user request ---
        System.out.println("\n--- Running other tests ---");
        List<Customer> customers = customerDAO.findAll(1, 5);
        System.out.println("\nListing first 5 customers:");
        for (Customer c : customers) {
            System.out.println(c);
        }

        System.out.println("\nDeactivating customer with ID 1...");
        customerDAO.deactivateCustomer(1);
        System.out.println("Deactivation call finished.");
    }

    public int getTotalCustomersByStatus(boolean isActive) {
        String sql = "SELECT COUNT(*) FROM customers WHERE is_active = ?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, isActive);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }

        } catch (SQLException e) {
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
            return false;
        }
    }

    public void updateCustomer(Customer customer) {
        // SQL statement to update all editable fields for a customer.
        // The updated_at field is set to the current timestamp automatically.
        String sql = "UPDATE customers SET " +
                "full_name = ?, " +
                "email = ?, " +
                "phone_number = ?, " +
                "gender = ?, " +
                "birthday = ?, " +
                "address = ?, " +
                "is_active = ?, " +
                "is_verified = ?, " +
                "loyalty_points = ?, " +
                "updated_at = ? " +
                "WHERE customer_id = ?";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            // Set parameters for the prepared statement from the customer object.
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getEmail());
            ps.setString(3, customer.getPhoneNumber());
            ps.setString(4, customer.getGender());

            // Handle nullable birthday field
            if (customer.getBirthday() != null) {
                ps.setDate(5, new java.sql.Date(customer.getBirthday().getTime()));
            } else {
                ps.setNull(5, java.sql.Types.DATE);
            }

            ps.setString(6, customer.getAddress());
            ps.setBoolean(7, customer.isActive());
            ps.setBoolean(8, customer.isVerified());
            ps.setInt(9, customer.getLoyaltyPoints() != null ? customer.getLoyaltyPoints() : 0);
            ps.setTimestamp(10, new Timestamp(System.currentTimeMillis())); // Set updated_at to the current time
            ps.setInt(11, customer.getCustomerId());

            // Execute the update and log the result.
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Successfully updated customer with ID: " + customer.getCustomerId());
            } else {
                System.out.println(
                        "Failed to update customer with ID: " + customer.getCustomerId() + ". Customer may not exist.");
            }

        } catch (SQLException e) {
            // Log any errors that occur during the database operation.
            System.out.println("Error updating customer with ID: " + customer.getCustomerId());
        }
    }

    public List<Customer> getPaginatedCustomers(int page, int pageSize, String searchValue, String status,
            String verification, String sortBy, String sortOrder) {
        List<Customer> customers = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM customers WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (searchValue != null && !searchValue.trim().isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ? OR phone_number LIKE ?)");
            String searchPattern = "%" + searchValue.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND is_active = ?");
            params.add("true".equalsIgnoreCase(status));
        }

        if (verification != null && !verification.trim().isEmpty()) {
            sql.append(" AND is_verified = ?");
            params.add("true".equalsIgnoreCase(verification));
        }

        // Validate sortBy parameter to prevent SQL injection
        String orderBy;
        switch (sortBy.toLowerCase()) {
            case "name":
            case "fullname":
                orderBy = "full_name";
                break;
            case "email":
                orderBy = "email";
                break;
            case "phone":
            case "phonenumber":
                orderBy = "phone_number";
                break;
            case "loyalty":
            case "loyaltypoints":
                orderBy = "COALESCE(loyalty_points, 0)";
                break;
            case "createdat":
            case "created":
                orderBy = "created_at";
                break;
            case "updatedat":
            case "updated":
                orderBy = "updated_at";
                break;
            case "id":
            case "customerid":
            default:
                orderBy = "customer_id";
                break;
        }
        sql.append(" ORDER BY ").append(orderBy).append(" ").append("asc".equalsIgnoreCase(sortOrder) ? "ASC" : "DESC");

        if (pageSize != Integer.MAX_VALUE) {
            sql.append(" LIMIT ? OFFSET ?");
            params.add(pageSize);
            params.add((page - 1) * pageSize);
        }

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    customers.add(buildCustomerFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, "Error in getPaginatedCustomers", e);
            throw new RuntimeException("Error fetching paginated customers: " + e.getMessage(), e);
        }

        return customers;
    }

    public int getTotalCustomerCount(String searchValue, String status, String verification) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM customers WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (searchValue != null && !searchValue.trim().isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ? OR phone_number LIKE ?)");
            String searchPattern = "%" + searchValue.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND is_active = ?");
            params.add("true".equalsIgnoreCase(status));
        }

        if (verification != null && !verification.trim().isEmpty()) {
            sql.append(" AND is_verified = ?");
            params.add("true".equalsIgnoreCase(verification));
        }

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, "Error in getTotalCustomerCount", e);
            throw new RuntimeException("Error counting customers: " + e.getMessage(), e);
        }

        return 0;
    }

    // Deprecated - kept for backward compatibility, but recommend using more
    // specific methods above

    /**
     * Count customers by status (active/inactive)
     */
    public int countCustomersByStatus(boolean isActive) {
        String sql = "SELECT COUNT(*) FROM customers WHERE is_active = ?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, "Error counting customers by status", e);
            return 0;
        }
    }

    /**
     * Count customers by verification status
     */
    public int countCustomersByVerification(boolean isVerified) {
        String sql = "SELECT COUNT(*) FROM customers WHERE is_verified = ?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isVerified);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, "Error counting customers by verification", e);
            return 0;
        }
    }

    /**
     * Get list of unverified customers
     */
    public List<Customer> getUnverifiedCustomers() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customers WHERE is_verified = false ORDER BY created_at DESC";
        
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    customers.add(buildCustomerFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, "Error getting unverified customers", e);
        }
        return customers;
    }

    /**
     * Get paginated list of unverified customers with search and sorting
     */
    public List<Customer> getPaginatedUnverifiedCustomers(int page, int pageSize, String search, 
                                                          String sortBy, String sortOrder) {
        List<Customer> customers = new ArrayList<>();
        
        // Build WHERE clause for search
        StringBuilder whereClause = new StringBuilder("WHERE is_verified = false");
        if (search != null && !search.trim().isEmpty()) {
            whereClause.append(" AND (full_name LIKE ? OR email LIKE ? OR phone LIKE ?)");
        }
        
        // Build ORDER BY clause
        String orderByClause = "";
        if (sortBy != null && !sortBy.isEmpty()) {
            String column = mapSortParameter(sortBy);
            String order = "desc".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC";
            orderByClause = " ORDER BY " + column + " " + order;
        } else {
            orderByClause = " ORDER BY created_at DESC";
        }
        
        // Build LIMIT clause
        String limitClause = "";
        if (pageSize != 9999) { // 9999 means show all
            limitClause = " LIMIT ? OFFSET ?";
        }
        
        String sql = "SELECT * FROM customers " + whereClause + orderByClause + limitClause;
        
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            
            int paramIndex = 1;
            
            // Set search parameters
            if (search != null && !search.trim().isEmpty()) {
                String searchPattern = "%" + search.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            
            // Set pagination parameters
            if (pageSize != 9999) {
                ps.setInt(paramIndex++, pageSize);
                ps.setInt(paramIndex++, (page - 1) * pageSize);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    customers.add(buildCustomerFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, 
                "Error getting paginated unverified customers", e);
        }
        return customers;
    }

    /**
     * Get total count of unverified customers
     */
    public int getTotalUnverifiedCustomers() {
        String sql = "SELECT COUNT(*) FROM customers WHERE is_verified = false";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, 
                "Error getting total unverified customers count", e);
        }
        return 0;
    }

    /**
     * Get total count of unverified customers with search filter
     */
    public int getTotalUnverifiedCustomersWithSearch(String search) {
        StringBuilder whereClause = new StringBuilder("WHERE is_verified = false");
        if (search != null && !search.trim().isEmpty()) {
            whereClause.append(" AND (full_name LIKE ? OR email LIKE ? OR phone LIKE ?)");
        }
        
        String sql = "SELECT COUNT(*) FROM customers " + whereClause;
        
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (search != null && !search.trim().isEmpty()) {
                String searchPattern = "%" + search.trim() + "%";
                ps.setString(1, searchPattern);
                ps.setString(2, searchPattern);
                ps.setString(3, searchPattern);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, 
                "Error getting total unverified customers with search", e);
        }
        return 0;
    }

    /**
     * Verify all unverified customers' emails
     */
    public int verifyAllCustomers() {
        String sql = "UPDATE customers SET is_verified = true, updated_at = ? WHERE is_verified = false";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(java.time.LocalDateTime.now()));
            return ps.executeUpdate();
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, "Error verifying all customers", e);
            return 0;
        }
    }

    /**
     * Map sort parameter to database column name to prevent SQL injection
     */
    private String mapSortParameter(String sortBy) {
        if (sortBy == null || sortBy.trim().isEmpty()) {
            return "customer_id";
        }
        
        switch (sortBy.toLowerCase()) {
            case "name":
            case "fullname":
                return "full_name";
            case "email":
                return "email";
            case "phone":
            case "phonenumber":
                return "phone_number";
            case "loyalty":
            case "loyaltypoints":
                return "loyalty_points";
            case "createdat":
            case "created":
                return "created_at";
            case "updatedat":
            case "updated":
                return "updated_at";
            case "id":
            case "customerid":
            default:
                return "customer_id";
        }
    }

    /**
     * Verify customer email by customer ID
     */
    public boolean verifyCustomerEmail(int customerId) {
        String sql = "UPDATE customers SET is_verified = true, updated_at = ? WHERE customer_id = ?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(java.time.LocalDateTime.now()));
            ps.setInt(2, customerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, "Error verifying customer email", e);
            return false;
        }
    }

    /**
     * Unverify customer email by customer ID
     */
    public boolean unverifyCustomerEmail(int customerId) {
        String sql = "UPDATE customers SET is_verified = false, updated_at = ? WHERE customer_id = ?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(java.time.LocalDateTime.now()));
            ps.setInt(2, customerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, "Error unverifying customer email", e);
            return false;
        }
    }



    private static final Logger logger = Logger.getLogger(CustomerDAO.class.getName());

    // ===== ADDITIONAL METHODS FOR UNIFIED CUSTOMER MANAGEMENT =====

    /**
     * Validate customer data before saving or updating
     */
    public void validateCustomerData(Customer customer) throws IllegalArgumentException {
        if (customer == null) {
            throw new IllegalArgumentException("Customer cannot be null");
        }
        
        if (customer.getFullName() == null || customer.getFullName().trim().isEmpty()) {
            throw new IllegalArgumentException("Full name is required");
        }
        
        if (customer.getFullName().trim().length() < 2) {
            throw new IllegalArgumentException("Full name must be at least 2 characters long");
        }
        
        if (customer.getFullName().trim().length() > 100) {
            throw new IllegalArgumentException("Full name must be less than 100 characters");
        }
        
        // Validate email format if provided
        if (customer.getEmail() != null && !customer.getEmail().trim().isEmpty()) {
            String email = customer.getEmail().trim();
            if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
                throw new IllegalArgumentException("Invalid email format");
            }
        }
        
        // Validate phone format if provided
        if (customer.getPhoneNumber() != null && !customer.getPhoneNumber().trim().isEmpty()) {
            String phone = customer.getPhoneNumber().trim();
            if (!phone.matches("^[0-9+\\-\\s()]{10,15}$")) {
                throw new IllegalArgumentException("Invalid phone number format");
            }
        }
    }

    /**
     * Save customer with validation
     */
    public <S extends Customer> S saveWithValidation(S customer) {
        validateCustomerData(customer);
        return save(customer);
    }

    /**
     * Update customer with validation
     */
    public <S extends Customer> S updateWithValidation(S customer) {
        validateCustomerData(customer);
        return update(customer);
    }

    /**
     * Bulk activate customers
     */
    public int bulkActivateCustomers(List<Integer> customerIds) {
        if (customerIds == null || customerIds.isEmpty()) {
            return 0;
        }
        
        String sql = "UPDATE customers SET is_active = true, updated_at = ? WHERE customer_id = ?";
        int successCount = 0;
        
        try (Connection conn = DBContext.getConnection()) {
            conn.setAutoCommit(false); // Start transaction
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                Timestamp now = Timestamp.valueOf(java.time.LocalDateTime.now());
                
                for (Integer customerId : customerIds) {
                    ps.setTimestamp(1, now);
                    ps.setInt(2, customerId);
                    ps.addBatch();
                }
                
                int[] results = ps.executeBatch();
                for (int result : results) {
                    if (result > 0) {
                        successCount++;
                    }
                }
                
                conn.commit(); // Commit transaction
                logger.info("Bulk activated " + successCount + " customers");
                
            } catch (SQLException e) {
                conn.rollback(); // Rollback on error
                throw e;
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error in bulk activate customers", e);
            throw new RuntimeException("Error in bulk activate customers: " + e.getMessage(), e);
        }
        
        return successCount;
    }

    /**
     * Bulk deactivate customers
     */
    public int bulkDeactivateCustomers(List<Integer> customerIds) {
        if (customerIds == null || customerIds.isEmpty()) {
            return 0;
        }
        
        String sql = "UPDATE customers SET is_active = false, updated_at = ? WHERE customer_id = ?";
        int successCount = 0;
        
        try (Connection conn = DBContext.getConnection()) {
            conn.setAutoCommit(false); // Start transaction
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                Timestamp now = Timestamp.valueOf(java.time.LocalDateTime.now());
                
                for (Integer customerId : customerIds) {
                    ps.setTimestamp(1, now);
                    ps.setInt(2, customerId);
                    ps.addBatch();
                }
                
                int[] results = ps.executeBatch();
                for (int result : results) {
                    if (result > 0) {
                        successCount++;
                    }
                }
                
                conn.commit(); // Commit transaction
                logger.info("Bulk deactivated " + successCount + " customers");
                
            } catch (SQLException e) {
                conn.rollback(); // Rollback on error
                throw e;
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error in bulk deactivate customers", e);
            throw new RuntimeException("Error in bulk deactivate customers: " + e.getMessage(), e);
        }
        
        return successCount;
    }

    /**
     * Bulk verify customer emails
     */
    public int bulkVerifyCustomerEmails(List<Integer> customerIds) {
        if (customerIds == null || customerIds.isEmpty()) {
            return 0;
        }
        
        String sql = "UPDATE customers SET is_verified = true, updated_at = ? WHERE customer_id = ? AND email IS NOT NULL";
        int successCount = 0;
        
        try (Connection conn = DBContext.getConnection()) {
            conn.setAutoCommit(false); // Start transaction
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                Timestamp now = Timestamp.valueOf(java.time.LocalDateTime.now());
                
                for (Integer customerId : customerIds) {
                    ps.setTimestamp(1, now);
                    ps.setInt(2, customerId);
                    ps.addBatch();
                }
                
                int[] results = ps.executeBatch();
                for (int result : results) {
                    if (result > 0) {
                        successCount++;
                    }
                }
                
                conn.commit(); // Commit transaction
                logger.info("Bulk verified " + successCount + " customer emails");
                
            } catch (SQLException e) {
                conn.rollback(); // Rollback on error
                throw e;
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error in bulk verify customer emails", e);
            throw new RuntimeException("Error in bulk verify customer emails: " + e.getMessage(), e);
        }
        
        return successCount;
    }

    /**
     * Bulk unverify customer emails
     */
    public int bulkUnverifyCustomerEmails(List<Integer> customerIds) {
        if (customerIds == null || customerIds.isEmpty()) {
            return 0;
        }
        
        String sql = "UPDATE customers SET is_verified = false, updated_at = ? WHERE customer_id = ? AND email IS NOT NULL";
        int successCount = 0;
        
        try (Connection conn = DBContext.getConnection()) {
            conn.setAutoCommit(false); // Start transaction
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                Timestamp now = Timestamp.valueOf(java.time.LocalDateTime.now());
                
                for (Integer customerId : customerIds) {
                    ps.setTimestamp(1, now);
                    ps.setInt(2, customerId);
                    ps.addBatch();
                }
                
                int[] results = ps.executeBatch();
                for (int result : results) {
                    if (result > 0) {
                        successCount++;
                    }
                }
                
                conn.commit(); // Commit transaction
                logger.info("Bulk unverified " + successCount + " customer emails");
                
            } catch (SQLException e) {
                conn.rollback(); // Rollback on error
                throw e;
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error in bulk unverify customer emails", e);
            throw new RuntimeException("Error in bulk unverify customer emails: " + e.getMessage(), e);
        }
        
        return successCount;
    }

    /**
     * Bulk reset passwords for customers (generates secure random passwords)
     */
    public int bulkResetPasswords(List<Integer> customerIds) {
        if (customerIds == null || customerIds.isEmpty()) {
            return 0;
        }
        
        String sql = "UPDATE customers SET hash_password = ?, updated_at = ? WHERE customer_id = ? AND email IS NOT NULL";
        int successCount = 0;
        
        try (Connection conn = DBContext.getConnection()) {
            conn.setAutoCommit(false); // Start transaction
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                Timestamp now = Timestamp.valueOf(java.time.LocalDateTime.now());
                
                for (Integer customerId : customerIds) {
                    // Generate secure random password
                    String newPassword = generateSecureRandomPassword();
                    String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                    
                    ps.setString(1, hashedPassword);
                    ps.setTimestamp(2, now);
                    ps.setInt(3, customerId);
                    ps.addBatch();
                }
                
                int[] results = ps.executeBatch();
                for (int result : results) {
                    if (result > 0) {
                        successCount++;
                    }
                }
                
                conn.commit(); // Commit transaction
                logger.info("Bulk reset passwords for " + successCount + " customers");
                
            } catch (SQLException e) {
                conn.rollback(); // Rollback on error
                throw e;
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error in bulk reset passwords", e);
            throw new RuntimeException("Error in bulk reset passwords: " + e.getMessage(), e);
        }
        
        return successCount;
    }

    /**
     * Generate secure random password
     */
    private String generateSecureRandomPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
        StringBuilder password = new StringBuilder();
        java.security.SecureRandom random = new java.security.SecureRandom();
        
        for (int i = 0; i < 12; i++) {
            password.append(chars.charAt(random.nextInt(chars.length())));
        }
        
        return password.toString();
    }

    /**
     * Get customers by role ID
     */
    public List<Customer> getCustomersByRole(int roleId) {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customers WHERE role_id = ? ORDER BY full_name";
        
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    customers.add(buildCustomerFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting customers by role", e);
            throw new RuntimeException("Error getting customers by role: " + e.getMessage(), e);
        }
        
        return customers;
    }

    /**
     * Get customer statistics
     */
    public Map<String, Integer> getCustomerStatistics() {
        Map<String, Integer> stats = new HashMap<>();
        
        // Get total customers
        stats.put("total", getTotalCustomers());
        
        // Get active/inactive counts
        stats.put("active", countCustomersByStatus(true));
        stats.put("inactive", countCustomersByStatus(false));
        
        // Get verified/unverified counts
        stats.put("verified", countCustomersByVerification(true));
        stats.put("unverified", countCustomersByVerification(false));
        
        // Get customers with email
        String sqlWithEmail = "SELECT COUNT(*) FROM customers WHERE email IS NOT NULL AND email != ''";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sqlWithEmail);
                ResultSet rs = ps.executeQuery()) {
            stats.put("withEmail", rs.next() ? rs.getInt(1) : 0);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting customers with email count", e);
            stats.put("withEmail", 0);
        }
        
        // Get customers with phone
        String sqlWithPhone = "SELECT COUNT(*) FROM customers WHERE phone_number IS NOT NULL AND phone_number != ''";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sqlWithPhone);
                ResultSet rs = ps.executeQuery()) {
            stats.put("withPhone", rs.next() ? rs.getInt(1) : 0);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting customers with phone count", e);
            stats.put("withPhone", 0);
        }
        
        return stats;
    }

    /**
     * Check if customer exists by email
     */
    public boolean existsByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        
        String sql = "SELECT COUNT(*) FROM customers WHERE email = ?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking if customer exists by email", e);
            return false;
        }
    }

    /**
     * Check if customer exists by phone
     */
    public boolean existsByPhone(String phone) {
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
            logger.log(Level.SEVERE, "Error checking if customer exists by phone", e);
            return false;
        }
    }

    /**
     * Update customer password by ID
     */
    public boolean updateCustomerPassword(int customerId, String newPassword) {
        if (newPassword == null || newPassword.trim().isEmpty()) {
            return false;
        }
        
        String sql = "UPDATE customers SET hash_password = ?, updated_at = ? WHERE customer_id = ?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, BCrypt.hashpw(newPassword, BCrypt.gensalt()));
            ps.setTimestamp(2, Timestamp.valueOf(java.time.LocalDateTime.now()));
            ps.setInt(3, customerId);
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                logger.info("Successfully updated password for customer ID: " + customerId);
                return true;
            }
            
            return false;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating customer password", e);
            return false;
        }
    }

    /**
     * Get customers needing password reset (inactive or unverified)
     */
    public List<Customer> getCustomersNeedingPasswordReset() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customers WHERE (is_active = false OR is_verified = false) AND email IS NOT NULL ORDER BY created_at DESC";
        
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    customers.add(buildCustomerFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting customers needing password reset", e);
            throw new RuntimeException("Error getting customers needing password reset: " + e.getMessage(), e);
        }
        
        return customers;
    }

    /**
     * Delete multiple customers by IDs (for admin use only)
     */
    public int bulkDeleteCustomers(List<Integer> customerIds) {
        if (customerIds == null || customerIds.isEmpty()) {
            return 0;
        }
        
        String sql = "DELETE FROM customers WHERE customer_id = ?";
        int successCount = 0;
        
        try (Connection conn = DBContext.getConnection()) {
            conn.setAutoCommit(false); // Start transaction
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                for (Integer customerId : customerIds) {
                    ps.setInt(1, customerId);
                    ps.addBatch();
                }
                
                int[] results = ps.executeBatch();
                for (int result : results) {
                    if (result > 0) {
                        successCount++;
                    }
                }
                
                conn.commit(); // Commit transaction
                logger.info("Bulk deleted " + successCount + " customers");
                
            } catch (SQLException e) {
                conn.rollback(); // Rollback on error
                throw e;
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error in bulk delete customers", e);
            throw new RuntimeException("Error in bulk delete customers: " + e.getMessage(), e);
        }
        
        return successCount;
    }

    /**
     * Check if customer has related data that prevents deletion
     */
    public boolean hasRelatedData(int customerId) {
        String[] queries = {
            "SELECT COUNT(*) FROM payments WHERE customer_id = ?",
            "SELECT COUNT(*) FROM bookings WHERE customer_id = ?",
            "SELECT COUNT(*) FROM checkins WHERE customer_id = ?"
        };
        
        try (Connection conn = DBContext.getConnection()) {
            for (String query : queries) {
                try (PreparedStatement ps = conn.prepareStatement(query)) {
                    ps.setInt(1, customerId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            return true;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking related data for customer: " + customerId, e);
            return true; // Return true to prevent deletion on error
        }
        
        return false;
    }
    
    /**
     * Get related data summary for a customer
     */
    public Map<String, Integer> getRelatedDataSummary(int customerId) {
        Map<String, Integer> summary = new HashMap<>();
        
        String[] queries = {
            "SELECT COUNT(*) FROM payments WHERE customer_id = ?",
            "SELECT COUNT(*) FROM bookings WHERE customer_id = ?", 
            "SELECT COUNT(*) FROM checkins WHERE customer_id = ?"
        };
        
        String[] keys = {"payments", "bookings", "checkins"};
        
        try (Connection conn = DBContext.getConnection()) {
            for (int i = 0; i < queries.length; i++) {
                try (PreparedStatement ps = conn.prepareStatement(queries[i])) {
                    ps.setInt(1, customerId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            summary.put(keys[i], rs.getInt(1));
                        }
                    }
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting related data summary for customer: " + customerId, e);
        }
        
        return summary;
    }
    
    /**
     * Safe delete customer with related data check
     */
    public boolean safeDeleteCustomer(int customerId) {
        // Check if customer has related data
        if (hasRelatedData(customerId)) {
            return false;
        }
        
        try {
            deleteById(customerId);
            logger.info("Successfully deleted customer with ID: " + customerId);
            return true;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error deleting customer: " + customerId, e);
            return false;
        }
    }

    // Cập nhật tier cho khách hàng
    public void updateTier(int customerId, String tier) {
        // Kiểm tra xem cột tier có tồn tại không, nếu không thì thêm vào
        try {
            String checkColumnSql = "SHOW COLUMNS FROM customers LIKE 'tier'";
            try (Connection conn = db.DBContext.getConnection();
                 PreparedStatement ps = conn.prepareStatement(checkColumnSql);
                 ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    // Cột tier chưa tồn tại, thêm vào
                    String addColumnSql = "ALTER TABLE customers ADD COLUMN tier VARCHAR(20) DEFAULT 'DONG'";
                    try (PreparedStatement addPs = conn.prepareStatement(addColumnSql)) {
                        addPs.executeUpdate();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Cập nhật tier
        String sql = "UPDATE customers SET tier = ? WHERE customer_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tier);
            ps.setInt(2, customerId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy loyalty_points hiện tại của khách hàng
    public int getLoyaltyPoints(int customerId) {
        String sql = "SELECT loyalty_points FROM customers WHERE customer_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("loyalty_points");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0; // Trả về 0 nếu không tìm thấy hoặc lỗi
    }

    // Cập nhật loyalty_points cho khách hàng
    public void updateLoyaltyPoints(int customerId, int points) {
        String sql = "UPDATE customers SET loyalty_points = ? WHERE customer_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, points);
            ps.setInt(2, customerId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Đồng bộ loyalty_points từ customer_points cho một khách hàng cụ thể
    public void syncLoyaltyPointsFromCustomerPoints(int customerId) {
        String sql = "UPDATE customers c " +
                    "JOIN customer_points cp ON c.customer_id = cp.customer_id " +
                    "SET c.loyalty_points = cp.points " +
                    "WHERE c.customer_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Đồng bộ loyalty_points cho tất cả khách hàng dựa trên tổng chi tiêu (payments) + điểm thủ công (customer_points)
    public void syncLoyaltyPointsByTotalSpent() {
        String sql = "UPDATE customers c " +
                "LEFT JOIN (" +
                "  SELECT p.customer_id, " +
                "         COALESCE(FLOOR(SUM(p.total_amount) / 100000), 0) AS points_from_payments " +
                "  FROM payments p " +
                "  WHERE p.payment_status = 'PAID' " +
                "  GROUP BY p.customer_id" +
                ") pay ON c.customer_id = pay.customer_id " +
                "LEFT JOIN (" +
                "  SELECT cp.customer_id, COALESCE(SUM(cp.points), 0) AS points_manual " +
                "  FROM customer_points cp " +
                "  GROUP BY cp.customer_id" +
                ") manual ON c.customer_id = manual.customer_id " +
                "SET c.loyalty_points = COALESCE(pay.points_from_payments, 0) + COALESCE(manual.points_manual, 0)";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Đồng bộ loyalty_points từ customer_points cho tất cả khách hàng
    public void syncAllLoyaltyPointsFromCustomerPoints() {
        String sql = "UPDATE customers c " +
                    "JOIN customer_points cp ON c.customer_id = cp.customer_id " +
                    "SET c.loyalty_points = cp.points " +
                    "WHERE c.customer_id IS NOT NULL";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Đồng bộ tier cho toàn bộ khách hàng dựa trên loyalty_points
     * (Chạy sau khi đồng bộ điểm hoặc khi cần đảm bảo dữ liệu chuẩn)
     */
    public void syncAllCustomerTiers() {
        // Đảm bảo cột tier đã tồn tại
        try {
            String checkColumnSql = "SHOW COLUMNS FROM customers LIKE 'tier'";
            try (Connection conn = db.DBContext.getConnection();
                 PreparedStatement ps = conn.prepareStatement(checkColumnSql);
                 ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    String addColumnSql = "ALTER TABLE customers ADD COLUMN tier VARCHAR(20) DEFAULT 'DONG'";
                    try (PreparedStatement addPs = conn.prepareStatement(addColumnSql)) {
                        addPs.executeUpdate();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // Cập nhật tier cho toàn bộ khách hàng
        String sql = "UPDATE customers SET tier = CASE " +
                "WHEN loyalty_points >= 1500 THEN 'Kim Cương' " +
                "WHEN loyalty_points >= 1000 THEN 'Vàng' " +
                "WHEN loyalty_points >= 500 THEN 'Bạc' " +
                "ELSE 'Đồng' END";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy danh sách khách hàng có tìm kiếm, lọc hạng, sắp xếp, phân trang
    public List<Customer> getPaginatedCustomersWithFilter(int page, int pageSize, String search, String tierFilter, String sortBy, String sortOrder) {
        List<Customer> customers = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM customers WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ?)");
            String pattern = "%" + search.trim() + "%";
            params.add(pattern);
            params.add(pattern);
        }
        if (tierFilter != null && !tierFilter.trim().isEmpty()) {
            sql.append(" AND tier = ?");
            params.add(tierFilter);
        }
        String orderBy = "customer_id";
        if (sortBy != null) {
            switch (sortBy) {
                case "name": orderBy = "full_name"; break;
                case "email": orderBy = "email"; break;
                case "loyaltyPoints": orderBy = "loyalty_points"; break;
                case "tier": orderBy = "tier"; break;
            }
        }
        sql.append(" ORDER BY ").append(orderBy).append(" DESC");
        if (sortOrder != null && sortOrder.equalsIgnoreCase("asc")) {
            sql = new StringBuilder(sql.toString().replace("DESC", "ASC"));
        }
        sql.append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    customers.add(buildCustomerFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    // Đếm tổng khách hàng theo điều kiện tìm kiếm, lọc hạng
    public int countCustomersWithFilter(String search, String tierFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM customers WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ?)");
            String pattern = "%" + search.trim() + "%";
            params.add(pattern);
            params.add(pattern);
        }
        if (tierFilter != null && !tierFilter.trim().isEmpty()) {
            sql.append(" AND tier = ?");
            params.add(tierFilter);
        }
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }


}
