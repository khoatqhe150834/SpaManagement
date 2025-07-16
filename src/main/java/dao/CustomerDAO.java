package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
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

        if (accountDAO.isEmailTakenInSystem(customer.getEmail())) {
            throw new IllegalArgumentException("Email already exists");
        }
        if (accountDAO.isPhoneTakenInSystem(customer.getPhoneNumber())) {
            throw new IllegalArgumentException("Phone number already exists");
        }

        String sql = "INSERT INTO customers (full_name, email, hash_password, phone_number, role_id, is_active, loyalty_points, is_verified, created_at, updated_at, notes, gender, birthday, address, avatar_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getEmail());
            ps.setString(3, BCrypt.hashpw(customer.getHashPassword(), BCrypt.gensalt()));
            ps.setString(4, customer.getPhoneNumber());
            ps.setInt(5, customer.getRoleId());
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
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error saving customer: " + e.getMessage(), e);
        }
        return customer;
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
        String sql = "UPDATE customers SET full_name=?, email=?, phone_number=?, gender=?, birthday=?, address=?, is_active=?, loyalty_points=?, role_id=?, is_verified=?, updated_at=?, avatar_url=?, notes=? WHERE customer_id=?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getEmail());
            ps.setString(3, customer.getPhoneNumber());
            ps.setString(4, customer.getGender());
            ps.setDate(5, customer.getBirthday() != null ? new java.sql.Date(customer.getBirthday().getTime()) : null);
            ps.setString(6, customer.getAddress());
            ps.setBoolean(7, customer.getIsActive());
            ps.setInt(8, customer.getLoyaltyPoints());
            ps.setInt(9, customer.getRoleId());
            ps.setBoolean(10, customer.getIsVerified() != null ? customer.getIsVerified() : false);
            ps.setTimestamp(11, Timestamp.valueOf(java.time.LocalDateTime.now()));
            ps.setString(12, customer.getAvatarUrl());
            ps.setString(13, customer.getNotes());
            ps.setInt(14, customer.getCustomerId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating customer: " + e.getMessage(), e);
        }
        return customer;
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
        int newLoyaltyPoints = customerToUpdate.getLoyaltyPoints() + 100;
        customerToUpdate.setAddress(newAddress);
        customerToUpdate.setLoyaltyPoints(newLoyaltyPoints);

        System.out.println("\n... Attempting to update address to '" + newAddress + "' and loyalty points to "
                + newLoyaltyPoints + " ...");

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
            ps.setInt(9, customer.getLoyaltyPoints());
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
            params.add("active".equalsIgnoreCase(status));
        }

        if (verification != null && !verification.trim().isEmpty()) {
            sql.append(" AND is_verified = ?");
            params.add("verified".equalsIgnoreCase(verification));
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
                orderBy = "loyalty_points";
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
            params.add("active".equalsIgnoreCase(status));
        }

        if (verification != null && !verification.trim().isEmpty()) {
            sql.append(" AND is_verified = ?");
            params.add("verified".equalsIgnoreCase(verification));
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

    /**
     * Get customers with loyalty points (for manager loyalty management)
     */
    public List<Customer> getCustomersWithLoyaltyPoints() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customers WHERE loyalty_points > 0 ORDER BY loyalty_points DESC";
        
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    customers.add(buildCustomerFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, "Error getting customers with loyalty points", e);
        }
        return customers;
    }

    private static final Logger logger = Logger.getLogger(CustomerDAO.class.getName());
}
