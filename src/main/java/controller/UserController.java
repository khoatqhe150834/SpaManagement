package controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "UserController", urlPatterns = {"/user/*"})
public class UserController extends HttpServlet {

    private UserDAO userDAO;
    private static final Logger logger = Logger.getLogger(UserController.class.getName());

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
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
                    response.sendRedirect(request.getContextPath() + "/user/list");
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
            int pageSize = getIntParameter(request, "pageSize", 1000); // Show all users by default
            String searchValue = request.getParameter("searchValue");
            String status = request.getParameter("status");
            String role = request.getParameter("role");
            String sortBy = request.getParameter("sortBy");
            String sortOrder = request.getParameter("sortOrder");

            // Get users with pagination and filtering
            List<User> users = userDAO.getPaginatedUsers(page, pageSize, searchValue, status, role, sortBy, sortOrder);
            int totalUsers = userDAO.getTotalUserCount(searchValue, status, role);
            int totalPages = (int) Math.ceil((double) totalUsers / pageSize);

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
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/User/user_list.jsp").forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error listing users", e);
            handleError(request, response, "Error loading user list: " + e.getMessage());
        }
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
                request.setAttribute("user", userOpt.get());
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
                request.setAttribute("user", userOpt.get());
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
            String password = request.getParameter("password");
            String phoneNumber = request.getParameter("phoneNumber");
            String gender = request.getParameter("gender");
            String birthday = request.getParameter("birthday");
            String address = request.getParameter("address");
            String roleIdStr = request.getParameter("roleId");
            String isActiveStr = request.getParameter("isActive");

            // Validate required fields
            Map<String, String> errors = new HashMap<>();
            if (fullName == null || fullName.trim().isEmpty()) {
                errors.put("fullName", "Full name is required");
            }
            if (email == null || email.trim().isEmpty()) {
                errors.put("email", "Email is required");
            } else if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                errors.put("email", "Invalid email format");
            }
            if (password == null || password.trim().isEmpty()) {
                errors.put("password", "Password is required");
            } else if (password.length() < 6) {
                errors.put("password", "Password must be at least 6 characters");
            }
            if (roleIdStr == null || roleIdStr.trim().isEmpty()) {
                errors.put("roleId", "Role is required");
            }

            // Check for duplicate email
            if (userDAO.isEmailExists(email)) {
                errors.put("email", "Email already exists");
            }

            // Check for duplicate phone
            if (phoneNumber != null && !phoneNumber.trim().isEmpty() && userDAO.isPhoneExists(phoneNumber)) {
                errors.put("phoneNumber", "Phone number already exists");
            }

            if (!errors.isEmpty()) {
                // Return to form with errors
                request.setAttribute("errors", errors);
                request.setAttribute("userInput", createUserFromRequest(request));
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/User/user_add.jsp").forward(request, response);
                return;
            }

            // Create user
            User user = new User();
            user.setFullName(fullName.trim());
            user.setEmail(email.trim().toLowerCase());
            user.setHashPassword(password); // Will be hashed in DAO
            user.setPhoneNumber(phoneNumber != null ? phoneNumber.trim() : null);
            user.setGender(gender);
            user.setBirthday(birthday != null && !birthday.isEmpty() ? java.sql.Date.valueOf(birthday) : null);
            user.setAddress(address != null ? address.trim() : null);
            user.setRoleId(Integer.parseInt(roleIdStr));
            user.setIsActive(isActiveStr != null && isActiveStr.equals("on"));

            userDAO.save(user);

            // Redirect with success message
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "User created successfully!");
            response.sendRedirect(request.getContextPath() + "/user/list");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error creating user", e);
            handleError(request, response, "Error creating user: " + e.getMessage());
        }
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

            // Validate required fields
            Map<String, String> errors = new HashMap<>();
            if (fullName == null || fullName.trim().isEmpty()) {
                errors.put("fullName", "Full name is required");
            }
            if (email == null || email.trim().isEmpty()) {
                errors.put("email", "Email is required");
            } else if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                errors.put("email", "Invalid email format");
            }
            if (roleIdStr == null || roleIdStr.trim().isEmpty()) {
                errors.put("roleId", "Role is required");
            }

            // Check for duplicate email (excluding current user)
            Optional<User> existingUser = userDAO.findUserByEmail(email);
            if (existingUser.isPresent() && existingUser.get().getUserId() != userId) {
                errors.put("email", "Email already exists");
            }

            // Check for duplicate phone (excluding current user)
            if (phoneNumber != null && !phoneNumber.trim().isEmpty()) {
                // This would need a method to check phone excluding current user
                // For now, we'll skip this validation
            }

            if (!errors.isEmpty()) {
                // Return to form with errors
                request.setAttribute("errors", errors);
                request.setAttribute("user", createUserFromRequest(request));
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/User/user_edit.jsp").forward(request, response);
                return;
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

            // Update password if provided
            if (password != null && !password.trim().isEmpty()) {
                if (password.length() < 6) {
                    errors.put("password", "Password must be at least 6 characters");
                    request.setAttribute("errors", errors);
                    request.setAttribute("user", user);
                    request.getRequestDispatcher("/WEB-INF/view/admin_pages/User/user_edit.jsp").forward(request, response);
                    return;
                }
                userDAO.updatePassword(userId, password);
            }

            // Update profile
            userDAO.updateProfile(user);

            // Redirect with success message
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "User updated successfully!");
            response.sendRedirect(request.getContextPath() + "/user/list");

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

            response.sendRedirect(request.getContextPath() + "/user/list");

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
                response.sendRedirect(request.getContextPath() + "/user/view?id=" + userId);
            } else {
                // Redirect to list page
                response.sendRedirect(request.getContextPath() + "/user/list");
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
                response.sendRedirect(request.getContextPath() + "/user/view?id=" + userId);
            } else {
                // Redirect to list page
                response.sendRedirect(request.getContextPath() + "/user/list");
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

    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/User/user_list.jsp").forward(request, response);
    }
} 