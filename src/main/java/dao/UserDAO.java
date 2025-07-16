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
import model.User;

public class UserDAO implements BaseDAO<User, Integer> {
    
    private static final Logger logger = Logger.getLogger(UserDAO.class.getName());

    // Helper method to build User from ResultSet
    private User buildUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setRoleId(rs.getInt("role_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setHashPassword(rs.getString("hash_password"));
        user.setPhoneNumber(rs.getString("phone_number"));
        user.setIsActive(rs.getBoolean("is_active"));
        user.setGender(rs.getString("gender"));
        user.setBirthday(rs.getDate("birthday"));
        user.setAddress(rs.getString("address"));
        user.setAvatarUrl(rs.getString("avatar_url"));
        
        // Handle email verification field (may not exist in old database)
        try {
            user.setIsEmailVerified(rs.getBoolean("is_email_verified"));
        } catch (SQLException e) {
            // Column doesn't exist yet, set default value
            user.setIsEmailVerified(false);
        }
        
        user.setLastLoginAt(rs.getDate("last_login_at"));
        user.setCreatedAt(rs.getDate("created_at"));
        user.setUpdatedAt(rs.getDate("updated_at"));
        return user;
    }

    public List<User> findByActiveStatus(boolean isActive, int page, int pageSize) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE is_active = ? ORDER BY user_id ASC LIMIT ? OFFSET ?";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, isActive);
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(buildUserFromResultSet(rs));
                }
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding users by status", e);
            throw new RuntimeException("Error finding users by status: " + e.getMessage(), e);
        }

        return users;
    }

    public int getTotalSearchResults(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getTotalUsers();
        }

        String sql = "SELECT COUNT(*) FROM users WHERE full_name LIKE ? OR email LIKE ? OR phone_number LIKE ?";

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
            logger.log(Level.SEVERE, "Error getting total search results", e);
            return 0;
        }
    }

    public List<User> findByNameContain(String name) {
        List<User> users = new ArrayList<>();
        if (name == null || name.trim().isEmpty()) {
            return users;
        }

        String sql = "SELECT * FROM users WHERE full_name LIKE ? ORDER BY full_name";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + name.trim() + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(buildUserFromResultSet(rs));
                }
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding users by name", e);
            throw new RuntimeException("Error finding users by name: " + e.getMessage(), e);
        }

        return users;
    }

    public List<User> findByEmailContain(String email) {
        List<User> users = new ArrayList<>();
        if (email == null || email.trim().isEmpty()) {
            return users;
        }

        String sql = "SELECT * FROM users WHERE email LIKE ? ORDER BY email";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + email.trim() + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(buildUserFromResultSet(rs));
                }
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding users by email", e);
            throw new RuntimeException("Error finding users by email: " + e.getMessage(), e);
        }

        return users;
    }

    public List<User> findByPhoneContain(String phone) {
        List<User> users = new ArrayList<>();
        if (phone == null || phone.trim().isEmpty()) {
            return users;
        }

        String sql = "SELECT * FROM users WHERE phone_number LIKE ? ORDER BY phone_number";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + phone.trim() + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(buildUserFromResultSet(rs));
                }
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding users by phone", e);
            throw new RuntimeException("Error finding users by phone: " + e.getMessage(), e);
        }

        return users;
    }

    public List<User> findByRoleId(int roleId, int page, int pageSize) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role_id = ? ORDER BY user_id ASC LIMIT ? OFFSET ?";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roleId);
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(buildUserFromResultSet(rs));
                }
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding users by role", e);
            throw new RuntimeException("Error finding users by role: " + e.getMessage(), e);
        }

        return users;
    }

    public int getTotalUsersByRole(int roleId) {
        String sql = "SELECT COUNT(*) FROM users WHERE role_id = ?";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roleId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting total users by role", e);
            return 0;
        }
    }

    public int getTotalUsersByStatus(boolean isActive) {
        String sql = "SELECT COUNT(*) FROM users WHERE is_active = ?";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, isActive);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting total users by status", e);
            return 0;
        }
    }

    public List<User> findAll(int page, int pageSize) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY user_id ASC LIMIT ? OFFSET ?";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, pageSize);
            ps.setInt(2, (page - 1) * pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(buildUserFromResultSet(rs));
                }
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error finding all users with pagination", e);
            throw new RuntimeException("Error finding all users: " + e.getMessage(), e);
        }

        return users;
    }

    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM users";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            return rs.next() ? rs.getInt(1) : 0;

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting total users", e);
            return 0;
        }
    }

    public boolean deactivateUser(int userId) {
        String sql = "UPDATE users SET is_active = false, updated_at = ? WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setInt(2, userId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deactivating user", e);
            return false;
        }
    }

    public boolean activateUser(int userId) {
        String sql = "UPDATE users SET is_active = true, updated_at = ? WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setInt(2, userId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error activating user", e);
            return false;
        }
    }

    public List<User> getPaginatedUsers(int page, int pageSize, String searchValue, String status, String role, String sortBy, String sortOrder) {
        List<User> users = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM users WHERE 1=1");
        List<Object> parameters = new ArrayList<>();

        // Add search condition
        if (searchValue != null && !searchValue.trim().isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ? OR phone_number LIKE ?)");
            String searchPattern = "%" + searchValue.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        // Add status condition
        if (status != null && !status.trim().isEmpty()) {
            if ("active".equalsIgnoreCase(status)) {
                sql.append(" AND is_active = true");
            } else if ("inactive".equalsIgnoreCase(status)) {
                sql.append(" AND is_active = false");
            }
        }

        // Loại bỏ admin (1) và khách hàng (5) nếu không truyền role (chỉ lấy nhân viên: 2,3,4,6)
        if (role == null || role.trim().isEmpty()) {
            sql.append(" AND role_id IN (2,3,4,6)");
        }

        // Add role condition
        if (role != null && !role.trim().isEmpty()) {
            int roleId = Integer.parseInt(role.trim());
            if (roleId != 5) { // Không lấy khách hàng
                sql.append(" AND role_id = ?");
                parameters.add(roleId);
            } else {
                // Nếu là role khách hàng thì không lấy user nào
                sql.append(" AND 1=0");
            }
        }

        // Add sorting
        if (sortBy != null && !sortBy.trim().isEmpty()) {
            String sortColumn = switch (sortBy.toLowerCase()) {
                case "id" -> "user_id";
                case "name" -> "full_name";
                case "email" -> "email";
                case "created" -> "created_at";
                default -> "user_id";
            };
            sql.append(" ORDER BY ").append(sortColumn).append(" ").append("desc".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC");
        } else {
            sql.append(" ORDER BY user_id ASC");
        }

        sql.append(" LIMIT ? OFFSET ?");
        parameters.add(pageSize);
        parameters.add((page - 1) * pageSize);

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(buildUserFromResultSet(rs));
                }
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting paginated users", e);
            throw new RuntimeException("Error getting paginated users: " + e.getMessage(), e);
        }

        return users;
    }

    public int getTotalUserCount(String searchValue, String status, String role) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users WHERE 1=1");
        List<Object> parameters = new ArrayList<>();

        // Add search condition
        if (searchValue != null && !searchValue.trim().isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ? OR phone_number LIKE ?)");
            String searchPattern = "%" + searchValue.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        // Add status condition
        if (status != null && !status.trim().isEmpty()) {
            if ("active".equalsIgnoreCase(status)) {
                sql.append(" AND is_active = true");
            } else if ("inactive".equalsIgnoreCase(status)) {
                sql.append(" AND is_active = false");
            }
        }

        // Loại bỏ admin và customer nếu không truyền role (chỉ lấy nhân viên)
        if (role == null || role.trim().isEmpty()) {
            sql.append(" AND role_id != 1 AND role_id != 5");
        }

        // Add role condition
        if (role != null && !role.trim().isEmpty()) {
            sql.append(" AND role_id = ?");
            parameters.add(Integer.parseInt(role.trim()));
        }

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting total user count", e);
            return 0;
        }
    }

    // New methods for Profile Management (only Manager role)
    public List<User> getPaginatedUsersForProfile(int page, int pageSize, String searchValue, String role) {
        List<User> users = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM users WHERE 1=1");
        List<Object> parameters = new ArrayList<>();

        // Add search condition
        if (searchValue != null && !searchValue.trim().isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ? OR phone_number LIKE ?)");
            String searchPattern = "%" + searchValue.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        // Force role to be Manager only (role_id = 2)
        sql.append(" AND role_id = 2");

        sql.append(" ORDER BY user_id ASC");
        sql.append(" LIMIT ? OFFSET ?");
        parameters.add(pageSize);
        parameters.add((page - 1) * pageSize);

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(buildUserFromResultSet(rs));
                }
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting paginated users for profile", e);
            throw new RuntimeException("Error getting paginated users for profile: " + e.getMessage(), e);
        }

        return users;
    }

    public int getTotalUserCountForProfile(String searchValue, String role) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users WHERE 1=1");
        List<Object> parameters = new ArrayList<>();

        // Add search condition
        if (searchValue != null && !searchValue.trim().isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ? OR phone_number LIKE ?)");
            String searchPattern = "%" + searchValue.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        // Force role to be Manager only (role_id = 2)
        sql.append(" AND role_id = 2");

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting total user count for profile", e);
            return 0;
        }
    }

    public boolean updateLastLogin(int userId) {
        String sql = "UPDATE users SET last_login_at = ? WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setInt(2, userId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating last login", e);
            return false;
        }
    }

    public String getUserNameByEmail(String email) {
        String sql = "SELECT full_name FROM users WHERE email = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("full_name");
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting user name by email", e);
        }
        return null;
    }

    public boolean updateProfile(User user) {
        String sql = "UPDATE users SET full_name = ?, phone_number = ?, gender = ?, birthday = ?, address = ?, avatar_url = ?, updated_at = ?, email = ?, role_id = ?, is_active = ? WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhoneNumber());
            ps.setString(3, user.getGender());
            ps.setDate(4, user.getBirthday() != null ? new java.sql.Date(user.getBirthday().getTime()) : null);
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getAvatarUrl());
            ps.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
            ps.setString(8, user.getEmail());
            ps.setInt(9, user.getRoleId());
            ps.setBoolean(10, user.getIsActive());
            ps.setInt(11, user.getUserId());
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating user profile", e);
            return false;
        }
    }

    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET hash_password = ?, updated_at = ? WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            ps.setString(1, hashedPassword);
            ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            ps.setInt(3, userId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating password", e);
            return false;
        }
    }

    /**
     * Generate secure random password for user reset
     * @return randomly generated password with mixed characters
     */
    public String generateSecurePassword() {
        java.security.SecureRandom random = new java.security.SecureRandom();
        
        // Character sets
        String upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        String lowerCase = "abcdefghijklmnopqrstuvwxyz";
        String digits = "0123456789";
        String special = "!@#$%";
        
        StringBuilder password = new StringBuilder();
        
        // Ensure at least 2 characters from each category (8 total)
        for (int i = 0; i < 2; i++) {
            password.append(upperCase.charAt(random.nextInt(upperCase.length())));
            password.append(lowerCase.charAt(random.nextInt(lowerCase.length())));
            password.append(digits.charAt(random.nextInt(digits.length())));
            password.append(special.charAt(random.nextInt(special.length())));
        }
        
        // Shuffle the password characters
        char[] chars = password.toString().toCharArray();
        for (int i = chars.length - 1; i > 0; i--) {
            int j = random.nextInt(i + 1);
            char temp = chars[i];
            chars[i] = chars[j];
            chars[j] = temp;
        }
        
        return new String(chars);
    }

    /**
     * Reset password for a user and return the new password
     * @param userId user ID to reset password for
     * @return new password if successful, null if failed
     */
    public String resetPassword(int userId) {
        try {
            String newPassword = generateSecurePassword();
            boolean updated = updatePassword(userId, newPassword);
            if (updated) {
                logger.info("Password reset successful for user ID: " + userId);
                return newPassword;
            } else {
                logger.warning("Password reset failed for user ID: " + userId);
                return null;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error resetting password for user ID: " + userId, e);
            return null;
        }
    }

    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking email existence", e);
            return false;
        }
    }

    public boolean isPhoneExists(String phone) {
        String sql = "SELECT COUNT(*) FROM users WHERE phone_number = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking phone existence", e);
            return false;
        }
    }

    // Existing methods remain unchanged
    @Override
    public <S extends User> S save(S user) {
        String sql = "INSERT INTO users (role_id, full_name, email, hash_password, phone_number, gender, birthday, avatar_url, is_active, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, user.getRoleId());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getHashPassword());
            ps.setString(5, user.getPhoneNumber());
            ps.setString(6, user.getGender());
            ps.setDate(7, user.getBirthday() != null ? new java.sql.Date(user.getBirthday().getTime()) : null);
            ps.setString(8, user.getAvatarUrl());
            ps.setBoolean(9, user.getIsActive());
            ps.setTimestamp(10, new Timestamp(System.currentTimeMillis()));

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        user.setUserId(rs.getInt(1));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public Optional<User> findById(int userId) {
        try (Connection connection = DBContext.getConnection();
             PreparedStatement ps = connection.prepareStatement("SELECT * FROM users WHERE user_id = ?")) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setRoleId(rs.getInt("role_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setHashPassword(rs.getString("hash_password"));
                user.setPhoneNumber(rs.getString("phone_number"));
                user.setIsActive(rs.getBoolean("is_active"));
                user.setGender(rs.getString("gender"));
                user.setBirthday(rs.getDate("birthday"));
                user.setAddress(rs.getString("address"));
                user.setAvatarUrl(rs.getString("avatar_url"));
                
                // Handle email verification field (may not exist in old database)
                try {
                    user.setIsEmailVerified(rs.getBoolean("is_email_verified"));
                } catch (SQLException e) {
                    // Column doesn't exist yet, set default value
                    user.setIsEmailVerified(false);
                }
                
                user.setLastLoginAt(rs.getDate("last_login_at"));
                user.setCreatedAt(rs.getDate("created_at"));
                user.setUpdatedAt(rs.getDate("updated_at"));
                return Optional.of(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    @Override
    public List<User> findAll() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users"; // Thay đổi nếu bảng của bạn có tên khác

        try (Connection connection = DBContext.getConnection(); PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setRoleId(rs.getInt("role_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setHashPassword(rs.getString("hash_password"));
                user.setPhoneNumber(rs.getString("phone_number"));
                user.setIsActive(rs.getBoolean("is_active"));
                user.setGender(rs.getString("gender"));
                user.setBirthday(rs.getDate("birthday"));
                user.setAvatarUrl(rs.getString("avatar_url"));
                
                // Handle email verification field (may not exist in old database)
                try {
                    user.setIsEmailVerified(rs.getBoolean("is_email_verified"));
                } catch (SQLException e) {
                    // Column doesn't exist yet, set default value
                    user.setIsEmailVerified(false);
                }
                
                user.setLastLoginAt(rs.getDate("last_login_at"));
                user.setCreatedAt(rs.getDate("created_at"));
                user.setUpdatedAt(rs.getDate("updated_at"));

                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return users;
    }

    @Override
    public boolean existsById(Integer id) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void deleteById(Integer id) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public <S extends User> S update(S entity) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void delete(User entity) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    // User-specific methods - only check users table
    public boolean validateAccount(String email, String password) {
        try (Connection connection = DBContext.getConnection(); PreparedStatement ps = connection.prepareStatement("SELECT hash_password FROM users WHERE email = ?")) {
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

    public Optional<User> findUserByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return Optional.empty();
        }

        try (Connection connection = DBContext.getConnection(); PreparedStatement ps = connection.prepareStatement("SELECT * FROM users WHERE email = ?")) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setRoleId(rs.getInt("role_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setHashPassword(rs.getString("hash_password"));
                user.setPhoneNumber(rs.getString("phone_number"));
                user.setIsActive(rs.getBoolean("is_active"));
                user.setGender(rs.getString("gender"));
                user.setBirthday(rs.getDate("birthday"));
                user.setAvatarUrl(rs.getString("avatar_url"));
                
                // Handle email verification field (may not exist in old database)
                try {
                    user.setIsEmailVerified(rs.getBoolean("is_email_verified"));
                } catch (SQLException e) {
                    // Column doesn't exist yet, set default value
                    user.setIsEmailVerified(false);
                }
                
                user.setLastLoginAt(rs.getDate("last_login_at"));
                user.setCreatedAt(rs.getDate("created_at"));
                user.setUpdatedAt(rs.getDate("updated_at"));

                return Optional.of(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    public User getUserByEmailAndPassword(String email, String password) {
        User user = null;
        try (Connection connection = DBContext.getConnection(); PreparedStatement ps = connection.prepareStatement("SELECT * FROM users WHERE email = ?")) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("hash_password");
                if (BCrypt.checkpw(password, storedHash)) {
                    user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setRoleId(rs.getInt("role_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhoneNumber(rs.getString("phone_number"));
                    user.setIsActive(rs.getBoolean("is_active"));
                    user.setGender(rs.getString("gender"));
                    user.setBirthday(rs.getDate("birthday"));
                    user.setAvatarUrl(rs.getString("avatar_url"));
                }
            }
        } catch (SQLException e) {
            return null;
        }
        return user;
    }

    @Override
    public Optional<User> findById(Integer id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
