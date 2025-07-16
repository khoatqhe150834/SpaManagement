package controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.RoleDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Role;
import model.User;
import service.email.EmailService;
import service.email.AsyncEmailService;

//@WebServlet(name = "UserController", urlPatterns = {"/user/*"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 5,   // 5MB
    maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class UserController extends HttpServlet {

    private UserDAO userDAO;
    private AsyncEmailService asyncEmailService;
    private static final Logger logger = Logger.getLogger(UserController.class.getName());

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        asyncEmailService = new AsyncEmailService();
    }
    
    @Override
    public void destroy() {
        super.destroy();
        if (asyncEmailService != null) {
            // Cleanup if needed
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String action = "";

        if (pathInfo != null && pathInfo.length() > 1) {
            action = pathInfo.substring(1);
        }

        try {
            switch (action) {
                case "list":
                    listUsers(request, response);
                    break;
                case "profile":
                    listUserProfiles(request, response);
                    break;
                case "create":
                    showCreateForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "view":
                    viewUser(request, response);
                    break;
                case "activate":
                    activateUser(request, response);
                    break;
                case "deactivate":
                    deactivateUser(request, response);
                    break;
                case "quick-reset-password":
                    quickResetPassword(request, response);
                    break;
                default:
                    listUsers(request, response);
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in UserController doGet", e);
            handleError(request, response, "An error occurred: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String action = "";

        if (pathInfo != null && pathInfo.length() > 1) {
            action = pathInfo.substring(1);
        }

        try {
            switch (action) {
                case "create":
                    createUser(request, response);
                    break;
                case "update":
                    updateUser(request, response);
                    break;
                case "delete":
                    deleteUser(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/user/list");
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in UserController doPost", e);
            handleError(request, response, "An error occurred: " + e.getMessage());
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get parameters
            int page = getIntParameter(request, "page", 1);
            int pageSize = getIntParameter(request, "pageSize", 10); // default 10
            String searchValue = request.getParameter("searchValue");
            String status = request.getParameter("status");
            String role = request.getParameter("role");
            String sortBy = request.getParameter("sortBy");
            String sortOrder = request.getParameter("sortOrder");

            // Get users with pagination and filtering
            List<User> users = userDAO.getPaginatedUsers(page, pageSize, searchValue, status, role, sortBy, sortOrder);
            int totalUsers = userDAO.getTotalUserCount(searchValue, status, role);
            int totalPages = (int) Math.ceil((double) totalUsers / pageSize);

            // Lấy danh sách role nhân viên (role_id = 2, 3, 4, 6), loại bỏ roleId = 5 (khách hàng)
            RoleDAO roleDAO = new RoleDAO();
            List<Role> allRoles = roleDAO.findAll();
            List<Role> staffRoles = new java.util.ArrayList<>();
            for (Role r : allRoles) {
                if ((r.getRoleId() == 2 || r.getRoleId() == 3 || r.getRoleId() == 4 || r.getRoleId() == 6) && r.getRoleId() != 5) {
                    staffRoles.add(r);
                }
            }
            request.setAttribute("roles", staffRoles);

            // Set attributes
            request.setAttribute("users", users);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("searchValue", searchValue);
            request.setAttribute("status", status);
            request.setAttribute("role", role);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);
            request.setAttribute("totalUsers", totalUsers);

            // Forward to JSP
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/User/user_Acount_List.jsp").forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error listing users", e);
            handleError(request, response, "Error loading user list: " + e.getMessage());
        }
    }

    private void listUserProfiles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get parameters
            int page = getIntParameter(request, "page", 1);
            int pageSize = getIntParameter(request, "pageSize", 10); // default 10
            String searchValue = request.getParameter("searchValue");
            String status = request.getParameter("status");
            String role = request.getParameter("role");
            String sortBy = request.getParameter("sortBy");
            String sortOrder = request.getParameter("sortOrder");

            // Get users with pagination and filtering
            List<User> users = userDAO.getPaginatedUsers(page, pageSize, searchValue, status, role, sortBy, sortOrder);
            int totalUsers = userDAO.getTotalUserCount(searchValue, status, role);
            int totalPages = (int) Math.ceil((double) totalUsers / pageSize);

            // Lấy danh sách role nhân viên (role_id = 2, 3, 4, 6), loại bỏ roleId = 5 (khách hàng)
            RoleDAO roleDAO = new RoleDAO();
            List<Role> allRoles = roleDAO.findAll();
            List<Role> staffRoles = new java.util.ArrayList<>();
            for (Role r : allRoles) {
                if ((r.getRoleId() == 2 || r.getRoleId() == 3 || r.getRoleId() == 4 || r.getRoleId() == 6) && r.getRoleId() != 5) {
                    staffRoles.add(r);
                }
            }
            request.setAttribute("roles", staffRoles);

            // Set attributes
            request.setAttribute("users", users);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("searchValue", searchValue);
            request.setAttribute("status", status);
            request.setAttribute("role", role);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);
            request.setAttribute("totalUsers", totalUsers);

            // Forward to profile-focused JSP
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/User/user_profile_list.jsp").forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error listing user profiles", e);
            handleError(request, response, "Error loading user profile list: " + e.getMessage());
        }
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy danh sách role nhân viên (role_id = 2, 3, 4, 6), loại bỏ roleId = 5 (khách hàng)
        RoleDAO roleDAO = new RoleDAO();
        List<Role> allRoles = roleDAO.findAll();
        List<Role> staffRoles = new java.util.ArrayList<>();
        for (Role r : allRoles) {
            if ((r.getRoleId() == 2 || r.getRoleId() == 3 || r.getRoleId() == 4 || r.getRoleId() == 6) && r.getRoleId() != 5) {
                staffRoles.add(r);
            }
        }
        request.setAttribute("roles", staffRoles);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/User/user_add.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userId = getIntParameter(request, "id", 0);
            if (userId <= 0) {
                handleError(request, response, "Invalid user ID");
                return;
            }

            Optional<User> userOpt = userDAO.findById(userId);
            if (userOpt.isPresent()) {
                // Lấy danh sách role nhân viên (role_id = 2, 3, 4, 6)
                RoleDAO roleDAO = new RoleDAO();
                List<Role> allRoles = roleDAO.findAll();
                List<Role> staffRoles = new java.util.ArrayList<>();
                for (Role r : allRoles) {
                    if (r.getRoleId() == 2 || r.getRoleId() == 3 || r.getRoleId() == 4 || r.getRoleId() == 6) {
                        staffRoles.add(r);
                    }
                }
                request.setAttribute("roles", staffRoles);
                request.setAttribute("user", userOpt.get());
                
                // Preserve returnTo parameter
                String returnTo = request.getParameter("returnTo");
                request.setAttribute("returnTo", returnTo);
                
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/User/user_edit.jsp").forward(request, response);
            } else {
                handleError(request, response, "User not found");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error showing edit form", e);
            handleError(request, response, "Error loading user: " + e.getMessage());
        }
    }

    private void viewUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userId = getIntParameter(request, "id", 0);
            if (userId <= 0) {
                handleError(request, response, "Invalid user ID");
                return;
            }

            Optional<User> userOpt = userDAO.findById(userId);
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                // Lấy tên vai trò
                String roleDisplayName = "";
                RoleDAO roleDAO = new RoleDAO();
                List<Role> allRoles = roleDAO.findAll();
                for (Role r : allRoles) {
                    if (r.getRoleId() != null && r.getRoleId().equals(user.getRoleId())) {
                        // Chỉ hiển thị tên vai trò nếu là nhân viên, quản lý, kỹ thuật viên, marketing
                        if (r.getRoleId() == 2 || r.getRoleId() == 3 || r.getRoleId() == 4 || r.getRoleId() == 6) {
                            roleDisplayName = r.getDisplayName() != null ? r.getDisplayName() : r.getName();
                        } else {
                            roleDisplayName = ""; // Không hiển thị gì
                        }
                        break;
                    }
                }
                request.setAttribute("user", user);
                request.setAttribute("roleDisplayName", roleDisplayName);
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/User/user_details.jsp").forward(request, response);
            } else {
                handleError(request, response, "User not found");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error viewing user", e);
            handleError(request, response, "Error loading user: " + e.getMessage());
        }
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get form data
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");
            String gender = request.getParameter("gender");
            String birthday = request.getParameter("birthday");
            String address = request.getParameter("address");
            String roleIdStr = request.getParameter("roleId");
            String isActiveStr = request.getParameter("isActive");

            // Generate random password
            String password = generateRandomPassword(10);

            // Validate required fields
            Map<String, String> errors = new HashMap<>();
            // Họ tên: required, chỉ chữ, nhiều nhất 1 khoảng trắng giữa các từ, không khoảng trắng đầu/cuối/liên tiếp
            if (fullName == null || fullName.trim().isEmpty()) {
                errors.put("fullName", "Họ tên không được để trống");
            } else if (!fullName.matches("^[A-Za-zÀ-ỹ]+( [A-Za-zÀ-ỹ]+)*$")) {
                errors.put("fullName", "Họ tên chỉ được chứa chữ cái, mỗi từ cách nhau 1 khoảng trắng, không số, không ký tự đặc biệt, không khoảng trắng đầu/cuối hoặc liên tiếp");
            }
            // Email: required, định dạng, không trùng
            if (email == null || email.trim().isEmpty()) {
                errors.put("email", "Email không được để trống");
            } else if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                errors.put("email", "Email không đúng định dạng");
            } else if (userDAO.isEmailExists(email)) {
                errors.put("email", "Email đã tồn tại");
            }
            // Số điện thoại: required, đúng định dạng, không trùng
            if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
                errors.put("phoneNumber", "Số điện thoại không được để trống");
            } else if (!phoneNumber.matches("^0\\d{9}$")) {
                errors.put("phoneNumber", "Số điện thoại phải bắt đầu bằng 0, đủ 10 số, không ký tự đặc biệt");
            } else if (userDAO.isPhoneExists(phoneNumber)) {
                errors.put("phoneNumber", "Số điện thoại đã tồn tại");
            }
            // Vai trò: required
            if (roleIdStr == null || roleIdStr.trim().isEmpty()) {
                errors.put("roleId", "Vai trò không được để trống");
            }
            // Giới tính, ngày sinh, địa chỉ: required
            if (gender == null || gender.trim().isEmpty()) {
                errors.put("gender", "Giới tính không được để trống");
            }
            if (birthday == null || birthday.trim().isEmpty()) {
                errors.put("birthday", "Ngày sinh không được để trống");
            } else {
                try {
                    java.sql.Date.valueOf(birthday);
                } catch (Exception ex) {
                    errors.put("birthday", "Ngày sinh không hợp lệ");
                }
            }
            if (address == null || address.trim().isEmpty()) {
                errors.put("address", "Địa chỉ không được để trống");
            }

            if (!errors.isEmpty()) {
                // Return to form with errors
                User userInput = new User();
                userInput.setFullName(fullName);
                userInput.setEmail(email);
                userInput.setPhoneNumber(phoneNumber);
                userInput.setGender(gender);
                userInput.setBirthday(birthday != null && !birthday.isEmpty() ? java.sql.Date.valueOf(birthday) : null);
                userInput.setAddress(address);
                userInput.setRoleId(roleIdStr != null && !roleIdStr.isEmpty() ? Integer.parseInt(roleIdStr) : null);
                userInput.setIsActive(isActiveStr != null && isActiveStr.equals("on"));
                request.setAttribute("errors", errors);
                request.setAttribute("userInput", userInput);
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/User/user_add.jsp").forward(request, response);
                return;
            }

            // Create user
            User user = new User();
            user.setFullName(fullName.trim());
            user.setEmail(email.trim().toLowerCase());
            user.setHashPassword(password); // Will be hashed in DAO
            user.setPhoneNumber(phoneNumber.trim());
            user.setGender(gender);
            user.setBirthday(java.sql.Date.valueOf(birthday));
            user.setAddress(address.trim());
            user.setRoleId(Integer.parseInt(roleIdStr));
            user.setIsActive(isActiveStr != null && isActiveStr.equals("on"));

            // Nếu không có avatarUrl, gán ảnh mặc định
            if (user.getAvatarUrl() == null || user.getAvatarUrl().trim().isEmpty()) {
                user.setAvatarUrl("/assets/admin/images/avatar/default-user.png");
            }

            User savedUser = null;
            try {
                savedUser = userDAO.save(user);
            } catch (Exception ex) {
                logger.log(Level.SEVERE, "Lỗi khi lưu user mới", ex);
            }
            if (savedUser != null && savedUser.getUserId() != null && savedUser.getUserId() > 0) {
                // Gửi email thông báo tài khoản và mật khẩu
                EmailService emailService = new EmailService();
                emailService.sendAutoPasswordEmail(email, fullName, password);
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "Tài khoản đã được tạo và gửi thông tin qua email!");
                response.sendRedirect(request.getContextPath() + "/admin/user/list");
                return;
            } else {
                request.setAttribute("errorMessage", "Lỗi khi lưu tài khoản. Vui lòng thử lại hoặc kiểm tra dữ liệu!");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/User/user_add.jsp").forward(request, response);
                return;
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error creating user", e);
            handleError(request, response, "Error creating user: " + e.getMessage());
        }
    }

    // Hàm sinh mật khẩu ngẫu nhiên
    private String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
        StringBuilder sb = new StringBuilder();
        java.util.Random random = new java.util.Random();
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userId = getIntParameter(request, "userId", 0);
            if (userId <= 0) {
                handleError(request, response, "Invalid user ID");
                return;
            }

            // Get form data
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");
            String gender = request.getParameter("gender");
            String birthday = request.getParameter("birthday");
            String address = request.getParameter("address");
            String roleIdStr = request.getParameter("roleId");
            String isActiveStr = request.getParameter("isActive");
            String password = request.getParameter("password");

            Map<String, String> errors = new HashMap<>();
            if (fullName == null || fullName.trim().isEmpty()) {
                errors.put("fullName", "Họ và tên không được để trống");
            }
            if (email == null || email.trim().isEmpty()) {
                errors.put("email", "Email không được để trống");
            } else if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                errors.put("email", "Email không đúng định dạng");
            } else {
                Optional<User> existingUser = userDAO.findUserByEmail(email);
                if (existingUser.isPresent() && existingUser.get().getUserId() != userId) {
                    errors.put("email", "Email đã tồn tại");
                }
            }
            if (phoneNumber != null && !phoneNumber.trim().isEmpty()) {
                if (!phoneNumber.matches("^0\\d{9}$")) {
                    errors.put("phoneNumber", "Số điện thoại phải gồm 10 số và bắt đầu bằng số 0");
                } else {
                    // Check duplicate phone (excluding current user)
                    List<User> usersWithPhone = userDAO.findByPhoneContain(phoneNumber);
                    for (User u : usersWithPhone) {
                        if (u.getUserId() != userId && phoneNumber.equals(u.getPhoneNumber())) {
                            errors.put("phoneNumber", "Số điện thoại đã tồn tại");
                            break;
                        }
                    }
                }
            }
            if (roleIdStr == null || roleIdStr.trim().isEmpty()) {
                errors.put("roleId", "Vai trò không được để trống");
            }
            if (birthday != null && !birthday.isEmpty()) {
                try {
                    java.sql.Date.valueOf(birthday);
                } catch (Exception ex) {
                    errors.put("birthday", "Ngày sinh không hợp lệ");
                }
            }
            if (!errors.isEmpty()) {
                User userInput = new User();
                userInput.setUserId(userId);
                userInput.setFullName(fullName);
                userInput.setEmail(email);
                userInput.setPhoneNumber(phoneNumber);
                userInput.setGender(gender);
                userInput.setBirthday(birthday != null && !birthday.isEmpty() ? java.sql.Date.valueOf(birthday) : null);
                userInput.setAddress(address);
                userInput.setRoleId(roleIdStr != null && !roleIdStr.isEmpty() ? Integer.parseInt(roleIdStr) : null);
                userInput.setIsActive(isActiveStr != null && isActiveStr.equals("on"));
                // Không set password
                request.setAttribute("errors", errors);
                request.setAttribute("user", userInput);
                
                // Preserve returnTo parameter
                String returnTo = request.getParameter("returnTo");
                request.setAttribute("returnTo", returnTo);
                
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/User/user_edit.jsp").forward(request, response);
                return;
            }

            // Xử lý upload file ảnh đại diện
            String avatarUrl = null;
            Part avatarPart = request.getPart("avatarFile");
            if (avatarPart != null && avatarPart.getSize() > 0) {
                String fileName = Paths.get(avatarPart.getSubmittedFileName()).getFileName().toString();
                String uploadDir = request.getServletContext().getRealPath("/uploads/avatars");
                File uploadDirFile = new File(uploadDir);
                if (!uploadDirFile.exists()) {
                    uploadDirFile.mkdirs();
                }
                String newFileName = "user_" + userId + "_" + System.currentTimeMillis() + fileName.substring(fileName.lastIndexOf('.'));
                String filePath = uploadDir + File.separator + newFileName;
                avatarPart.write(filePath);
                avatarUrl = request.getContextPath() + "/uploads/avatars/" + newFileName;
            } else {
                // Nếu không upload file mới, giữ nguyên avatarUrl cũ
                Optional<User> userOpt = userDAO.findById(userId);
                if (userOpt.isPresent()) {
                    avatarUrl = userOpt.get().getAvatarUrl();
                }
            }

            // Update user
            User user = new User();
            user.setUserId(userId);
            user.setFullName(fullName.trim());
            user.setEmail(email.trim().toLowerCase());
            user.setPhoneNumber(phoneNumber != null ? phoneNumber.trim() : null);
            user.setGender(gender);
            user.setBirthday(birthday != null && !birthday.isEmpty() ? java.sql.Date.valueOf(birthday) : null);
            user.setAddress(address != null ? address.trim() : null);
            user.setRoleId(Integer.parseInt(roleIdStr));
            user.setIsActive(isActiveStr != null && isActiveStr.equals("on"));
            user.setAvatarUrl(avatarUrl);

            // Update password if provided
            boolean passwordChanged = false;
            if (password != null && !password.trim().isEmpty()) {
                if (password.length() < 6) {
                    errors.put("password", "Password must be at least 6 characters");
                    request.setAttribute("errors", errors);
                    request.setAttribute("user", user);
                    
                    // Preserve returnTo parameter
                    String returnTo = request.getParameter("returnTo");
                    request.setAttribute("returnTo", returnTo);
                    
                    request.getRequestDispatcher("/WEB-INF/view/admin_pages/User/user_edit.jsp").forward(request, response);
                    return;
                }
                userDAO.updatePassword(userId, password);
                // Gửi email thông báo mật khẩu mới cho user
                EmailService emailService = new EmailService();
                emailService.sendAutoPasswordEmail(email, fullName, password);
                passwordChanged = true;
            }

            // Update profile
            boolean updated = userDAO.updateProfile(user);

            // Hiển thị thông báo ngay trên trang edit nếu cập nhật thành công
            if (updated || passwordChanged) {
                request.setAttribute("successMessage", "Cập nhật tài khoản thành công!");
                request.setAttribute("user", userDAO.findById(userId).orElse(user));
                
                // Preserve returnTo parameter
                String returnTo = request.getParameter("returnTo");
                request.setAttribute("returnTo", returnTo);
                
                // Lấy lại danh sách roles cho dropdown
                RoleDAO roleDAO = new RoleDAO();
                List<Role> allRoles = roleDAO.findAll();
                List<Role> staffRoles = new java.util.ArrayList<>();
                for (Role r : allRoles) {
                    if ((r.getRoleId() == 2 || r.getRoleId() == 3 || r.getRoleId() == 4 || r.getRoleId() == 6) && r.getRoleId() != 5) {
                        staffRoles.add(r);
                    }
                }
                request.setAttribute("roles", staffRoles);
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/User/user_edit.jsp").forward(request, response);
                return;
            }

            // Redirect with success message
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "User updated successfully!");
            
            // Check returnTo parameter to decide redirect destination
            String returnTo = request.getParameter("returnTo");
            if ("profile".equals(returnTo)) {
                response.sendRedirect(request.getContextPath() + "/admin/user/profile");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/user/list");
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating user", e);
            handleError(request, response, "Error updating user: " + e.getMessage());
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userId = getIntParameter(request, "id", 0);
            if (userId <= 0) {
                handleError(request, response, "Invalid user ID");
                return;
            }

            // For now, we'll deactivate instead of delete
            boolean success = userDAO.deactivateUser(userId);

            if (success) {
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "User deactivated successfully!");
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Failed to deactivate user");
            }

            response.sendRedirect(request.getContextPath() + "/admin/user/list");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error deleting user", e);
            handleError(request, response, "Error deleting user: " + e.getMessage());
        }
    }

    private void activateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userId = getIntParameter(request, "id", 0);
            if (userId <= 0) {
                handleError(request, response, "Invalid user ID");
                return;
            }

            boolean success = userDAO.activateUser(userId);

            if (success) {
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "User activated successfully!");
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Failed to activate user");
            }

            // Check if action was performed from details page
            String fromDetails = request.getParameter("fromDetails");
            if ("true".equals(fromDetails)) {
                // Redirect back to details page
                response.sendRedirect(request.getContextPath() + "/admin/user/view?id=" + userId);
            } else {
                // Redirect to list page
                response.sendRedirect(request.getContextPath() + "/admin/user/list");
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error activating user", e);
            handleError(request, response, "Error activating user: " + e.getMessage());
        }
    }

    private void deactivateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userId = getIntParameter(request, "id", 0);
            if (userId <= 0) {
                handleError(request, response, "Invalid user ID");
                return;
            }

            boolean success = userDAO.deactivateUser(userId);

            if (success) {
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "User deactivated successfully!");
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Failed to deactivate user");
            }

            // Check if action was performed from details page
            String fromDetails = request.getParameter("fromDetails");
            if ("true".equals(fromDetails)) {
                // Redirect back to details page
                response.sendRedirect(request.getContextPath() + "/admin/user/view?id=" + userId);
            } else {
                // Redirect to list page
                response.sendRedirect(request.getContextPath() + "/admin/user/list");
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error deactivating user", e);
            handleError(request, response, "Error deactivating user: " + e.getMessage());
        }
    }

    private User createUserFromRequest(HttpServletRequest request) {
        User user = new User();
        user.setFullName(request.getParameter("fullName"));
        user.setEmail(request.getParameter("email"));
        user.setPhoneNumber(request.getParameter("phoneNumber"));
        user.setGender(request.getParameter("gender"));
        user.setAddress(request.getParameter("address"));
        user.setAvatarUrl(request.getParameter("avatarUrl"));
        
        String roleIdStr = request.getParameter("roleId");
        if (roleIdStr != null && !roleIdStr.trim().isEmpty()) {
            user.setRoleId(Integer.parseInt(roleIdStr));
        }
        
        String birthday = request.getParameter("birthday");
        if (birthday != null && !birthday.isEmpty()) {
            user.setBirthday(java.sql.Date.valueOf(birthday));
        }
        
        user.setIsActive(request.getParameter("isActive") != null && request.getParameter("isActive").equals("on"));
        
        return user;
    }

    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        String value = request.getParameter(paramName);
        if (value != null && !value.trim().isEmpty()) {
            try {
                return Integer.parseInt(value.trim());
            } catch (NumberFormatException e) {
                logger.log(Level.WARNING, "Invalid integer parameter: " + paramName + " = " + value);
            }
        }
        return defaultValue;
    }

    private void quickResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userId = getIntParameter(request, "id", 0);
            if (userId <= 0) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "ID người dùng không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/admin/user/list");
                return;
            }

            // Get user info first
            Optional<User> userOpt = userDAO.findById(userId);
            if (!userOpt.isPresent()) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Không tìm thấy người dùng");
                response.sendRedirect(request.getContextPath() + "/admin/user/list");
                return;
            }

            User user = userOpt.get();
            
            // Generate and update new password
            String newPassword = userDAO.resetPassword(userId);
            if (newPassword == null) {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Không thể đặt lại mật khẩu. Vui lòng thử lại.");
                response.sendRedirect(request.getContextPath() + "/admin/user/list");
                return;
            }

            // Send email asynchronously
            try {
                asyncEmailService.sendNewPasswordEmailFireAndForget(
                    user.getEmail(), 
                    user.getFullName(), 
                    newPassword
                );
                logger.info("Password reset email sent for user: " + user.getEmail());
            } catch (Exception emailError) {
                logger.log(Level.WARNING, "Failed to send password reset email to: " + user.getEmail(), emailError);
                // Continue anyway since password was already reset
            }

            // Audit log
            logger.info("Password reset by admin for user ID: " + userId + " (" + user.getEmail() + ")");

            HttpSession session = request.getSession();
            session.setAttribute("successMessage", 
                "Đã đặt lại mật khẩu cho " + user.getFullName() + ". Thông tin đăng nhập mới đã được gửi qua email.");
            
            response.sendRedirect(request.getContextPath() + "/admin/user/list");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in quick password reset", e);
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/user/list");
        }
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
                    request.getRequestDispatcher("/WEB-INF/view/admin_pages/User/user_Acount_List.jsp").forward(request, response);
    }
} 