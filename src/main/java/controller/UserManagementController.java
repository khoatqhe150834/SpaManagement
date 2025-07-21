package controller;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.logging.Logger;

import org.mindrot.jbcrypt.BCrypt;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

public class UserManagementController extends HttpServlet {
    private UserDAO userDAO;
    private static final Logger logger = Logger.getLogger(UserManagementController.class.getName());

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String action = "list";
        if (pathInfo != null && !pathInfo.equals("/")) {
            String[] pathParts = pathInfo.split("/");
            if (pathParts.length > 1) {
                action = pathParts[1].toLowerCase();
            }
        }
        
        // Lấy user hiện tại và role
        User currentUser = (User) request.getSession().getAttribute("user");
        Integer currentRole = (currentUser != null) ? currentUser.getRoleId() : null;
        
        if (currentRole == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        switch (action) {
            case "list":
                handleListUsers(request, response, currentUser);
                break;
            case "view":
                handleViewUserDetail(request, response, currentUser);
                break;
            case "add":
                if (currentRole != 1 && currentRole != 2) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền thêm user.");
                    return;
                }
                handleShowAddForm(request, response, currentUser);
                break;
            case "edit":
                handleShowEditForm(request, response, currentUser);
                break;
            case "activate":
                handleActivateUser(request, response, currentUser);
                break;
            case "deactivate":
                handleDeactivateUser(request, response, currentUser);
                break;
            case "delete":
                if (currentRole != 1) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ Admin mới có quyền xóa user.");
                    return;
                }
                handleDeleteUser(request, response, currentUser);
                break;
            case "reset-password":
                if (currentRole != 1 && currentRole != 2) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền đặt lại mật khẩu.");
                    return;
                }
                handleResetPassword(request, response, currentUser);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy chức năng: " + action);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String action = "";
        if (pathInfo != null && pathInfo.startsWith("/")) {
            String[] pathParts = pathInfo.split("/");
            if (pathParts.length > 1) {
                action = pathParts[1];
            }
        }
        
        User currentUser = (User) request.getSession().getAttribute("user");
        Integer currentRole = (currentUser != null) ? currentUser.getRoleId() : null;
        
        if (currentRole == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        switch (action.toLowerCase()) {
            case "add":
                if (currentRole != 1 && currentRole != 2) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền thêm user.");
                    return;
                }
                handleProcessAddForm(request, response, currentUser);
                break;
            case "edit":
                handleProcessEditForm(request, response, currentUser);
                break;
            case "activate":
                handleActivateUser(request, response, currentUser);
                break;
            case "deactivate":
                handleDeactivateUser(request, response, currentUser);
                break;
            case "delete":
                if (currentRole != 1) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ Admin mới có quyền xóa user.");
                    return;
                }
                handleDeleteUser(request, response, currentUser);
                break;
            case "reset-password":
                if (currentRole != 1 && currentRole != 2) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền đặt lại mật khẩu.");
                    return;
                }
                handleResetPassword(request, response, currentUser);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hành động không hợp lệ: " + action);
        }
    }

    private void handleListUsers(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        int page = 1;
        int pageSize = 10;
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");
        
        // Validate page parameter
        if (pageParam != null) {
            try { 
                page = Integer.parseInt(pageParam); 
                if (page < 1) page = 1;
            } catch (Exception e) {
                page = 1;
            }
        }
        
        // Validate pageSize parameter
        if (pageSizeParam != null) {
            if ("all".equals(pageSizeParam)) {
                pageSize = Integer.MAX_VALUE;
            } else {
                try { 
                    int tempPageSize = Integer.parseInt(pageSizeParam);
                    // Chỉ cho phép các giá trị hợp lệ
                    if (tempPageSize == 5 || tempPageSize == 10 || tempPageSize == 20 || 
                        tempPageSize == 50 || tempPageSize == 100) {
                        pageSize = tempPageSize;
                    } else {
                        pageSize = 10; // Default fallback
                    }
                } catch (Exception e) {
                    pageSize = 10; // Default fallback
                }
            }
        }
        try {
            List<Integer> adminRoles = Arrays.asList(2,3,4,6,7);
            List<Integer> managerRoles = Arrays.asList(3,4,6,7);
            List<User> users;
            int totalUsers;
            
            if (currentUser.getRoleId() == 1) { // Admin
                totalUsers = userDAO.countStaffByRoles(adminRoles);
                users = userDAO.findStaffByRoles(adminRoles, page, pageSize);
            } else if (currentUser.getRoleId() == 2) { // Manager
                totalUsers = userDAO.countStaffByRoles(managerRoles);
                users = userDAO.findStaffByRoles(managerRoles, page, pageSize);
            } else { // Nhân viên - chỉ xem chính mình
                users = List.of(currentUser);
                totalUsers = 1;
            }
            
            int totalPages = (int) Math.ceil((double) totalUsers / (pageSize == Integer.MAX_VALUE ? totalUsers : pageSize));
            
            request.setAttribute("users", users);
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize == Integer.MAX_VALUE ? "all" : pageSize);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalPages", totalPages);
            
        } catch (Exception e) {
            logger.severe("Error in handleListUsers: " + e.getMessage());
            // Set default values on error
            request.setAttribute("users", List.of());
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("currentPage", 1);
            request.setAttribute("pageSize", 10);
            request.setAttribute("totalUsers", 0);
            request.setAttribute("totalPages", 1);
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách nhân viên.");
        }
        
        request.getRequestDispatcher("/WEB-INF/view/user/user_list.jsp").forward(request, response);
    }
    
    private void sortUsers(List<User> users, String sortBy, String sortOrder) {
        boolean ascending = !"desc".equalsIgnoreCase(sortOrder);
        
        switch (sortBy.toLowerCase()) {
            case "id":
                users.sort((u1, u2) -> {
                    int result = Integer.compare(u1.getUserId(), u2.getUserId());
                    return ascending ? result : -result;
                });
                break;
            case "name":
                users.sort((u1, u2) -> {
                    String name1 = u1.getFullName() != null ? u1.getFullName() : "";
                    String name2 = u2.getFullName() != null ? u2.getFullName() : "";
                    int result = name1.compareToIgnoreCase(name2);
                    return ascending ? result : -result;
                });
                break;
            case "email":
                users.sort((u1, u2) -> {
                    String email1 = u1.getEmail() != null ? u1.getEmail() : "";
                    String email2 = u2.getEmail() != null ? u2.getEmail() : "";
                    int result = email1.compareToIgnoreCase(email2);
                    return ascending ? result : -result;
                });
                break;
            case "role":
                users.sort((u1, u2) -> {
                    int result = Integer.compare(u1.getRoleId(), u2.getRoleId());
                    return ascending ? result : -result;
                });
                break;
            case "created":
                users.sort((u1, u2) -> {
                    if (u1.getCreatedAt() == null && u2.getCreatedAt() == null) return 0;
                    if (u1.getCreatedAt() == null) return ascending ? 1 : -1;
                    if (u2.getCreatedAt() == null) return ascending ? -1 : 1;
                    int result = u1.getCreatedAt().compareTo(u2.getCreatedAt());
                    return ascending ? result : -result;
                });
                break;
        }
    }

    private void handleViewUserDetail(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        int userId = 0;
        
        // Handle "self" parameter for personal info access
        if ("self".equals(idParam)) {
            userId = currentUser.getUserId();
        } else {
            userId = getIntParameter(request, "id", 0);
        }
        
        Optional<User> userOpt = userDAO.findById(userId);
        
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            
            // Kiểm tra quyền xem
            if (!canViewUser(currentUser, user)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem thông tin user này.");
                return;
            }
            
            request.setAttribute("user", user);
            request.setAttribute("currentUser", currentUser);
            request.getRequestDispatcher("/WEB-INF/view/user/user_detail.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy user.");
        }
    }

    private void handleShowAddForm(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        request.setAttribute("currentUser", currentUser);
        request.getRequestDispatcher("/WEB-INF/view/user/user_add.jsp").forward(request, response);
    }

    private void handleShowEditForm(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        int userId = 0;
        
        // Handle "self" parameter for personal info access
        if ("self".equals(idParam)) {
            userId = currentUser.getUserId();
        } else {
            userId = getIntParameter(request, "id", 0);
        }
        
        Optional<User> userOpt = userDAO.findById(userId);
        
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            
            // Kiểm tra quyền sửa
            if (!canEditUser(currentUser, user)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền sửa thông tin user này.");
                return;
            }
            
            request.setAttribute("user", user);
            request.setAttribute("currentUser", currentUser);
            request.getRequestDispatcher("/WEB-INF/view/user/user_edit.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy user.");
        }
    }

    private void handleProcessAddForm(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        // Lấy dữ liệu từ form
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phoneNumber = request.getParameter("phoneNumber");
        String gender = request.getParameter("gender");
        String birthdayStr = request.getParameter("birthday");
        String address = request.getParameter("address");
        String roleIdStr = request.getParameter("roleId");
        String isActiveStr = request.getParameter("isActive");

        Map<String, String> errors = validateUserData(fullName, email, password, phoneNumber, 
                                                      birthdayStr, roleIdStr, 0, currentUser);

        int roleId = 3; // Default: Nhân viên
        try {
            roleId = Integer.parseInt(roleIdStr);
        } catch (Exception e) {}

        // Kiểm tra quyền tạo role
        if (!canCreateRole(currentUser, roleId)) {
            errors.put("roleId", "Bạn không có quyền tạo user với vai trò này.");
        }

        // Nếu có lỗi, trả lại form
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("userInput", request.getParameterMap());
            request.setAttribute("currentUser", currentUser);
            request.getRequestDispatcher("/WEB-INF/view/user/user_add.jsp").forward(request, response);
            return;
        }

        // Tạo user mới
        User newUser = new User();
        newUser.setFullName(fullName.trim());
        newUser.setEmail(email.trim());
        newUser.setHashPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
        newUser.setPhoneNumber(phoneNumber != null ? phoneNumber.trim() : null);
        newUser.setGender(gender);
        newUser.setAddress(address != null ? address.trim() : null);
        newUser.setRoleId(roleId);
        newUser.setIsActive("true".equals(isActiveStr));
        
        if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
            try {
                newUser.setBirthday(Date.valueOf(birthdayStr));
            } catch (Exception e) {
                // Ignore invalid date
            }
        }

        // Lưu vào database
        boolean success = userDAO.saveUser(newUser);
        if (success) {
            request.getSession().setAttribute("flash_success", "Thêm user thành công!");
        } else {
            request.getSession().setAttribute("flash_error", "Có lỗi xảy ra khi thêm user.");
        }

        response.sendRedirect(request.getContextPath() + "/user-management/list");
    }

    private void handleProcessEditForm(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        // Lấy dữ liệu từ form
        String userIdStr = request.getParameter("userId");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phoneNumber = request.getParameter("phoneNumber");
        String gender = request.getParameter("gender");
        String birthdayStr = request.getParameter("birthday");
        String address = request.getParameter("address");
        String roleIdStr = request.getParameter("roleId");
        String isActiveStr = request.getParameter("isActive");

        int userId = 0;
        try { 
            userId = Integer.parseInt(userIdStr); 
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID user không hợp lệ.");
            return;
        }

        Optional<User> userOpt = userDAO.findById(userId);
        if (!userOpt.isPresent()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy user.");
            return;
        }

        User user = userOpt.get();

        // Kiểm tra quyền sửa
        if (!canEditUser(currentUser, user)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền sửa thông tin user này.");
            return;
        }

        Map<String, String> errors = validateUserData(fullName, email, password, phoneNumber, 
                                                      birthdayStr, roleIdStr, userId, currentUser);

        int roleId = user.getRoleId();
        try {
            roleId = Integer.parseInt(roleIdStr);
        } catch (Exception e) {}

        // Kiểm tra quyền thay đổi role (chỉ Admin)
        if (user.getRoleId() != roleId && currentUser.getRoleId() != 1) {
            errors.put("roleId", "Chỉ Admin mới có quyền thay đổi vai trò.");
        }

        // Kiểm tra quyền tạo role mới
        if (user.getRoleId() != roleId && !canCreateRole(currentUser, roleId)) {
            errors.put("roleId", "Bạn không có quyền gán vai trò này.");
        }

        // Nếu có lỗi, trả lại form
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("userInput", request.getParameterMap());
            request.setAttribute("user", user);
            request.setAttribute("currentUser", currentUser);
            request.getRequestDispatcher("/WEB-INF/view/user/user_edit.jsp").forward(request, response);
            return;
        }

        // Cập nhật user
        user.setFullName(fullName.trim());
        user.setEmail(email.trim());
        if (password != null && !password.isEmpty()) {
            user.setHashPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
        }
        user.setPhoneNumber(phoneNumber != null ? phoneNumber.trim() : null);
        user.setGender(gender);
        user.setAddress(address != null ? address.trim() : null);
        user.setRoleId(roleId);
        user.setIsActive("true".equals(isActiveStr));
        
        if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
            try {
                user.setBirthday(Date.valueOf(birthdayStr));
            } catch (Exception e) {
                // Ignore invalid date
            }
        }

        // Lưu vào database
        boolean success = userDAO.updateUser(user);
        if (success) {
            request.getSession().setAttribute("flash_success", "Cập nhật user thành công!");
        } else {
            request.getSession().setAttribute("flash_error", "Có lỗi xảy ra khi cập nhật user.");
        }

        response.sendRedirect(request.getContextPath() + "/user-management/list");
    }

    private void handleActivateUser(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        int userId = getIntParameter(request, "id", 0);
        Optional<User> userOpt = userDAO.findById(userId);
        
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            
            // Kiểm tra quyền activate
            if (!canActivateDeactivateUser(currentUser, user)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền kích hoạt user này.");
                return;
            }
            
            if (userDAO.activateUser(userId)) {
                request.getSession().setAttribute("flash_success", "Kích hoạt user thành công!");
            } else {
                request.getSession().setAttribute("flash_error", "Có lỗi xảy ra khi kích hoạt user.");
            }
        } else {
            request.getSession().setAttribute("flash_error", "Không tìm thấy user.");
        }
        
        response.sendRedirect(request.getContextPath() + "/user-management/list");
    }

    private void handleDeactivateUser(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        int userId = getIntParameter(request, "id", 0);
        Optional<User> userOpt = userDAO.findById(userId);
        
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            
            // Kiểm tra quyền deactivate
            if (!canActivateDeactivateUser(currentUser, user)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền khóa user này.");
                return;
            }
            
            if (userDAO.deactivateUser(userId)) {
                request.getSession().setAttribute("flash_success", "Khóa user thành công!");
            } else {
                request.getSession().setAttribute("flash_error", "Có lỗi xảy ra khi khóa user.");
            }
        } else {
            request.getSession().setAttribute("flash_error", "Không tìm thấy user.");
        }
        
        response.sendRedirect(request.getContextPath() + "/user-management/list");
    }

    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        int userId = getIntParameter(request, "id", 0);
        
        // Không cho phép xóa chính mình
        if (userId == currentUser.getUserId()) {
            request.getSession().setAttribute("flash_error", "Không thể xóa chính mình.");
            response.sendRedirect(request.getContextPath() + "/user-management/list");
            return;
        }
        
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            if (userDAO.deleteUser(userId)) {
                request.getSession().setAttribute("flash_success", "Xóa user thành công!");
            } else {
                request.getSession().setAttribute("flash_error", "Có lỗi xảy ra khi xóa user.");
            }
        } else {
            request.getSession().setAttribute("flash_error", "Không tìm thấy user.");
        }
        
        response.sendRedirect(request.getContextPath() + "/user-management/list");
    }

    // Đặt lại mật khẩu cho user dưới quyền
    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        int userId = getIntParameter(request, "userId", 0);
        Optional<User> userOpt = userDAO.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            // Chỉ admin hoặc manager quản lý user này mới được reset
            if (currentUser.getRoleId() == 1 || (currentUser.getRoleId() == 2 && userDAO.isManagedBy(userId, currentUser.getUserId()))) {
                String newPassword = userDAO.resetPassword(userId);
                if (newPassword != null) {
                    request.getSession().setAttribute("flash_success", "Đã đặt lại mật khẩu thành công! Mật khẩu mới: " + newPassword);
                } else {
                    request.getSession().setAttribute("flash_error", "Có lỗi khi đặt lại mật khẩu.");
                }
            } else {
                request.getSession().setAttribute("flash_error", "Bạn không có quyền đặt lại mật khẩu cho user này.");
            }
        } else {
            request.getSession().setAttribute("flash_error", "Không tìm thấy user.");
        }
        response.sendRedirect(request.getContextPath() + "/user-management/list");
    }

    // Helper methods for permission checking
    private boolean canViewUser(User currentUser, User targetUser) {
        if (currentUser.getRoleId() == 1) { // Admin - xem tất cả
            return true;
        } else if (currentUser.getRoleId() == 2) { // Manager - xem cấp dưới và chính mình
            return targetUser.getUserId().equals(currentUser.getUserId()) || 
                   userDAO.isManagedBy(targetUser.getUserId(), currentUser.getUserId());
        } else { // Nhân viên - chỉ xem chính mình
            return targetUser.getUserId().equals(currentUser.getUserId());
        }
    }

    private boolean canEditUser(User currentUser, User targetUser) {
        if (currentUser.getRoleId() == 1) { // Admin - sửa tất cả
            return true;
        } else if (currentUser.getRoleId() == 2) { // Manager - sửa cấp dưới và chính mình
            return targetUser.getUserId().equals(currentUser.getUserId()) || 
                   userDAO.isManagedBy(targetUser.getUserId(), currentUser.getUserId());
        } else { // Nhân viên - chỉ sửa chính mình
            return targetUser.getUserId().equals(currentUser.getUserId());
        }
    }

    private boolean canActivateDeactivateUser(User currentUser, User targetUser) {
        if (currentUser.getRoleId() == 1) { // Admin - activate/deactivate tất cả
            return true;
        } else if (currentUser.getRoleId() == 2) { // Manager - chỉ activate/deactivate cấp dưới
            return userDAO.isManagedBy(targetUser.getUserId(), currentUser.getUserId());
        } else { // Nhân viên - không có quyền
            return false;
        }
    }

    private boolean canCreateRole(User currentUser, int roleId) {
        if (currentUser.getRoleId() == 1) { // Admin - tạo tất cả role
            return true;
        } else if (currentUser.getRoleId() == 2) { // Manager - chỉ tạo các role dưới quyền
            return roleId == 3 || roleId == 4 || roleId == 6 || roleId == 7;
        } else { // Nhân viên - không có quyền tạo
            return false;
        }
    }

    private Map<String, String> validateUserData(String fullName, String email, String password, 
                                                String phoneNumber, String birthdayStr, String roleIdStr, 
                                                int userId, User currentUser) {
        Map<String, String> errors = new HashMap<>();
        
        // Validate họ tên
        if (fullName == null || fullName.trim().isEmpty()) {
            errors.put("fullName", "Họ tên là bắt buộc.");
        } else if (!fullName.trim().matches("^[\\p{L}\\s]+$")) {
            errors.put("fullName", "Họ tên chỉ được chứa chữ cái và khoảng trắng.");
        } else if (fullName.trim().length() < 2 || fullName.trim().length() > 100) {
            errors.put("fullName", "Họ tên phải từ 2 đến 100 ký tự.");
        }
        
        // Validate email
        if (email == null || email.trim().isEmpty()) {
            errors.put("email", "Email là bắt buộc.");
        } else if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            errors.put("email", "Email không hợp lệ.");
        } else if (userId == 0 && userDAO.existsByEmail(email.trim())) {
            errors.put("email", "Email đã tồn tại trong hệ thống.");
        } else if (userId > 0 && userDAO.existsByEmailExceptId(email.trim(), userId)) {
            errors.put("email", "Email đã tồn tại trong hệ thống.");
        }
        
        // Validate password
        if (userId == 0 && (password == null || password.length() < 7)) {
            errors.put("password", "Mật khẩu phải có ít nhất 7 ký tự.");
        } else if (userId > 0 && password != null && !password.isEmpty() && password.length() < 7) {
            errors.put("password", "Mật khẩu phải có ít nhất 7 ký tự.");
        }
        
        // Validate SĐT
        if (phoneNumber != null && !phoneNumber.trim().isEmpty()) {
            if (!phoneNumber.matches("^0[0-9]{9}$")) {
                errors.put("phoneNumber", "Số điện thoại phải bắt đầu bằng 0 và có đúng 10 chữ số.");
            } else if (userId == 0 && userDAO.existsByPhone(phoneNumber.trim())) {
                errors.put("phoneNumber", "Số điện thoại đã tồn tại trong hệ thống.");
            } else if (userId > 0 && userDAO.existsByPhoneExceptId(phoneNumber.trim(), userId)) {
                errors.put("phoneNumber", "Số điện thoại đã tồn tại trong hệ thống.");
            }
        }
        
        // Validate ngày sinh
        if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
            try {
                LocalDate birthDate = LocalDate.parse(birthdayStr);
                LocalDate today = LocalDate.now();
                if (birthDate.isAfter(today)) {
                    errors.put("birthday", "Ngày sinh không được vượt quá ngày hiện tại.");
                } else if (birthDate.plusYears(14).isAfter(today)) {
                    errors.put("birthday", "Phải đủ 14 tuổi trở lên.");
                }
            } catch (Exception e) {
                errors.put("birthday", "Ngày sinh không hợp lệ.");
            }
        }
        
        // Validate role
        int roleId = 3;
        try {
            roleId = Integer.parseInt(roleIdStr);
        } catch (Exception e) {}
        if (roleId < 1 || roleId > 3) {
            errors.put("roleId", "Vai trò không hợp lệ.");
        }
        
        return errors;
    }

    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        try {
            String value = request.getParameter(paramName);
            if (value != null) {
                return Integer.parseInt(value);
            }
        } catch (Exception e) {
            // ignore
        }
        return defaultValue;
    }
} 