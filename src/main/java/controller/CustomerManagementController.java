package controller;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.mindrot.jbcrypt.BCrypt;

import dao.AccountDAO;
import dao.BookingDAO;
import dao.CustomerDAO;
import dao.PaymentDAO;
import dao.PromotionUsageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;
import model.CustomerTier;
import model.RoleConstants;
import service.RewardPointService;
import service.email.AsyncEmailService;
import util.AuthenticationContext;

/**
 * CustomerManagementController - Unified customer management for Admin, Manager, and Receptionist roles
 * Combines account management and personal information management
 * URL Pattern: /customer-management/*
 */
@WebServlet(urlPatterns = { "/customer-management/*" })
public class CustomerManagementController extends HttpServlet {

    private CustomerDAO customerDAO;
    private AccountDAO accountDAO;
    private AsyncEmailService asyncEmailService;
    private static final Logger logger = Logger.getLogger(CustomerManagementController.class.getName());
    private static final int DEFAULT_PAGE_SIZE = 10;

    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAO();
        accountDAO = new AccountDAO();
        asyncEmailService = new AsyncEmailService();
        logger.info("CustomerManagementController initialized successfully");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check permissions
        if (!hasPermission(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập chức năng này.");
            return;
        }

        String pathInfo = request.getPathInfo();
        logger.info("CustomerManagementController GET request - PathInfo: " + pathInfo);

        try {
            String action = "list"; // Default action
            if (pathInfo != null && !pathInfo.equals("/")) {
                String[] pathParts = pathInfo.split("/");
                if (pathParts.length > 1) {
                    action = pathParts[1].toLowerCase();
                }
            }

            switch (action) {
                case "list":
                    handleListCustomers(request, response);
                    break;
                case "view":
                case "detail":
                    handleViewCustomerDetail(request, response);
                    break;
                case "add":
                case "create":
                    handleShowCreateForm(request, response);
                    break;
                case "edit":
                case "update":
                    handleShowEditForm(request, response);
                    break;
                case "activate":
                    handleActivateAccount(request, response);
                    break;
                case "deactivate":
                    handleDeactivateAccount(request, response);
                    break;
                case "reset-password":
                    handlePasswordResetManagement(request, response);
                    break;
                case "verify":
                    handleVerifyEmail(request, response);
                    break;
                case "unverify":
                    handleUnverifyEmail(request, response);
                    break;
                case "quick-reset-password":
                    handleQuickPasswordReset(request, response);
                    break;
                case "bulk-action":
                    handleBulkAction(request, response);
                    break;
                case "search":
                    handleSearchCustomers(request, response);
                    break;
                default:
                    logger.warning("Unknown GET action: " + action);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND,
                            "Không tìm thấy trang cho hành động: " + action);
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in CustomerManagementController GET", e);
            handleError(request, response, "Đã xảy ra lỗi: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check permissions
        if (!hasPermission(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập chức năng này.");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();
        String action = "";

        if (pathInfo != null && pathInfo.startsWith("/")) {
            String[] pathParts = pathInfo.split("/");
            if (pathParts.length > 1) {
                action = pathParts[1];
            }
        }

        try {
            switch (action.toLowerCase()) {
                case "add":
                case "create":
                    handleProcessCreateForm(request, response);
                    break;
                case "update":
                    handleUpdateCustomer(request, response);
                    break;
                case "activate":
                    handleActivateAccount(request, response);
                    break;
                case "deactivate":
                    handleDeactivateAccount(request, response);
                    break;
                case "reset-password":
                    handleProcessPasswordReset(request, response);
                    break;
                case "quick-reset-password":
                    handleQuickPasswordResetPost(request, response);
                    break;
                case "verify":
                    handleVerifyEmail(request, response);
                    break;
                case "unverify":
                    handleUnverifyEmail(request, response);
                    break;
                case "bulk-action":
                    handleBulkAccountAction(request, response);
                    break;
                case "delete":
                    handleDeleteCustomer(request, response);
                    break;
                default:
                    logger.warning("Invalid POST action: " + action);
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hành động không hợp lệ: " + action);
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in CustomerManagementController POST", e);
            handleError(request, response, "Đã xảy ra lỗi trong quá trình xử lý POST: " + e.getMessage());
        }
    }

    /**
     * Check if user has permission to access customer management
     */
    private boolean hasPermission(HttpServletRequest request) {
        return AuthenticationContext.hasAnyRole(request, 
            RoleConstants.ADMIN_ID, 
            RoleConstants.MANAGER_ID, 
            RoleConstants.RECEPTIONIST_ID);
    }

    /**
     * Handle list customers with combined account and personal info
     */
    private void handleListCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int page = getIntParameter(request, "page", 1);
            int pageSize = getIntParameter(request, "pageSize", DEFAULT_PAGE_SIZE);
            String status = request.getParameter("status");
            String verification = request.getParameter("verification");
            String searchValue = request.getParameter("searchValue");

            // Lấy sortBy và sortOrder trực tiếp từ form
            String sortBy = Optional.ofNullable(request.getParameter("sortBy")).orElse("fullName");
            String sortOrder = Optional.ofNullable(request.getParameter("sortOrder")).orElse("asc");

            // Clean up parameters
            if (searchValue != null && searchValue.trim().isEmpty()) {
                searchValue = null;
            }

            // Map frontend sortBy values to database column names
            String dbSortBy = mapSortByToDatabase(sortBy);

            // Get customers with pagination
            List<Customer> customers = customerDAO.getPaginatedCustomers(page, pageSize, searchValue, status, verification, dbSortBy, sortOrder);
            int totalCustomers = customerDAO.getTotalCustomerCount(searchValue, status, verification);
            int totalPages = (int) Math.ceil((double) totalCustomers / pageSize);

            // Calculate pagination display info
            int startItem = totalCustomers > 0 ? (page - 1) * pageSize + 1 : 0;
            int endItem = Math.min(page * pageSize, totalCustomers);

            // Get statistics
            int activeAccounts = customerDAO.countCustomersByStatus(true);
            int inactiveAccounts = customerDAO.countCustomersByStatus(false);
            int verifiedAccounts = customerDAO.countCustomersByVerification(true);
            int unverifiedAccounts = customerDAO.countCustomersByVerification(false);

            // Set attributes
            request.setAttribute("customers", customers);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("startItem", startItem);
            request.setAttribute("endItem", endItem);
            request.setAttribute("status", status);
            request.setAttribute("verification", verification);
            request.setAttribute("searchValue", searchValue);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);
            request.setAttribute("activeAccounts", activeAccounts);
            request.setAttribute("inactiveAccounts", inactiveAccounts);
            request.setAttribute("verifiedAccounts", verifiedAccounts);
            request.setAttribute("unverifiedAccounts", unverifiedAccounts);

            // Pass role information to JSP for conditional display
            request.setAttribute("isAdmin", AuthenticationContext.hasRole(request, RoleConstants.ADMIN_ID));
            request.setAttribute("isManager", AuthenticationContext.hasRole(request, RoleConstants.MANAGER_ID));
            request.setAttribute("isReceptionist", AuthenticationContext.hasRole(request, RoleConstants.RECEPTIONIST_ID));

            // Forward to appropriate view based on user role
            String viewPath = getViewPath("customer_list.jsp");
            request.getRequestDispatcher(viewPath).forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading customer list", e);
            handleError(request, response, "Lỗi khi tải danh sách khách hàng: " + e.getMessage());
        }
    }

    /**
     * Handle view customer detail (combines account and personal info)
     */
    private void handleViewCustomerDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int customerId = getIntParameter(request, "id", 0);
            if (customerId <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID khách hàng không hợp lệ.");
                return;
            }

            Optional<Customer> customerOpt = customerDAO.findById(customerId);
            if (customerOpt.isPresent()) {
                Customer customer = customerOpt.get();
                request.setAttribute("customer", customer);
                // Truyền ngày tạo đúng kiểu cho JSP
                if (customer.getCreatedAt() != null) {
                    request.setAttribute("createdAtDate", java.sql.Timestamp.valueOf(customer.getCreatedAt()));
                } else {
                    request.setAttribute("createdAtDate", null);
                }
                // Truyền ngày cập nhật đúng kiểu cho JSP
                if (customer.getUpdatedAt() != null) {
                    request.setAttribute("updatedAtDate", java.sql.Timestamp.valueOf(customer.getUpdatedAt()));
                } else {
                    request.setAttribute("updatedAtDate", null);
                }
                // Lấy thống kê booking
                BookingDAO bookingDAO = new BookingDAO();
                Map<String, Integer> bookingStats = bookingDAO.getBookingStatsByCustomerId(customerId);
                request.setAttribute("totalBookings", bookingStats.getOrDefault("total_bookings", 0));
                // Lấy thống kê chi tiêu
                PaymentDAO paymentDAO = new PaymentDAO();
                Map<String, Object> paymentStats = paymentDAO.getCustomerPaymentStatistics(customerId);
                request.setAttribute("totalSpent", paymentStats.getOrDefault("totalSpent", 0));
                request.setAttribute("lastVisit", paymentStats.get("lastPaymentDate"));

                // Get promotion usage information
                PromotionUsageDAO promotionUsageDAO = new PromotionUsageDAO();
                java.util.Map<String, Object> promotionSummary = promotionUsageDAO.getCustomerPromotionSummary(customerId);
                List<java.util.Map<String, Object>> customerPromotions = promotionUsageDAO.getCustomerPromotionsWithRemainingCount(customerId);
                
                request.setAttribute("promotionSummary", promotionSummary);
                request.setAttribute("customerPromotions", customerPromotions);

                // Ví dụ trong một method xử lý trang chi tiết khách hàng:
                RewardPointService rewardPointService = new RewardPointService();
                int points = rewardPointService.getPoints(customerId);
                CustomerTier tier = rewardPointService.getTier(customerId);
                request.setAttribute("points", points);
                request.setAttribute("tier", tier.getLabel());

                // Pass role information to JSP for conditional display
                request.setAttribute("isAdmin", AuthenticationContext.hasRole(request, RoleConstants.ADMIN_ID));
                request.setAttribute("isManager", AuthenticationContext.hasRole(request, RoleConstants.MANAGER_ID));
                request.setAttribute("isReceptionist", AuthenticationContext.hasRole(request, RoleConstants.RECEPTIONIST_ID));

                String viewPath = getViewPath("customer_detail.jsp");
                request.getRequestDispatcher(viewPath).forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy khách hàng.");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error viewing customer detail", e);
            handleError(request, response, "Lỗi khi xem chi tiết khách hàng: " + e.getMessage());
        }
    }

    /**
     * Handle show create form
     */
    private void handleShowCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Pass role information to JSP for conditional display
        request.setAttribute("isAdmin", AuthenticationContext.hasRole(request, RoleConstants.ADMIN_ID));
        request.setAttribute("isManager", AuthenticationContext.hasRole(request, RoleConstants.MANAGER_ID));
        request.setAttribute("isReceptionist", AuthenticationContext.hasRole(request, RoleConstants.RECEPTIONIST_ID));

        String viewPath = getViewPath("customer_add.jsp");
        request.getRequestDispatcher(viewPath).forward(request, response);
    }

    /**
     * Handle process create form
     */
    private void handleProcessCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String formJspPath = getViewPath("customer_add.jsp");

        String name = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phoneNumber");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");
        String birthdayStr = request.getParameter("birthday");
        String notes = request.getParameter("notes");

        Map<String, String> errors = new HashMap<>();
        Map<String, String> customerInput = new HashMap<>();

        // Store input for redisplay
        customerInput.put("fullName", name);
        customerInput.put("email", email);
        customerInput.put("phoneNumber", phone);
        customerInput.put("gender", gender);
        customerInput.put("address", address);
        customerInput.put("birthday", birthdayStr);
        customerInput.put("notes", notes);

        // Validation
        validateCustomerInput(name, email, password, phone, gender, address, birthdayStr, errors);

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("customerInput", customerInput);
            request.getRequestDispatcher(formJspPath).forward(request, response);
            return;
        }

        try {
            // Parse birthday
            Date birthday = null;
            if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
                birthday = Date.valueOf(birthdayStr);
            }

            Customer newCustomer = new Customer();
            newCustomer.setFullName(name.trim());
            newCustomer.setPhoneNumber(phone != null && !phone.trim().isEmpty() ? phone.trim() : null);
            newCustomer.setGender(gender != null && !gender.trim().isEmpty() ? gender : "UNKNOWN");
            newCustomer.setAddress(address != null && !address.trim().isEmpty() ? address.trim() : null);
            newCustomer.setBirthday(birthday);
            newCustomer.setIsActive(true);
            newCustomer.setLoyaltyPoints(0);
            newCustomer.setNotes(notes != null && !notes.trim().isEmpty() ? notes.trim() : null);
            newCustomer.setRoleId(RoleConstants.CUSTOMER_ID);

            // Set email and password if provided (Admin/Manager can set, Receptionist might not)
            if (email != null && !email.trim().isEmpty()) {
                newCustomer.setEmail(email.trim().toLowerCase());
                newCustomer.setIsVerified(false);
            }
            if (password != null && !password.trim().isEmpty()) {
                newCustomer.setHashPassword(password);
            }

            customerDAO.save(newCustomer);

            request.getSession().setAttribute("successMessage", "Đã thêm khách hàng mới thành công!");
            response.sendRedirect(request.getContextPath() + "/customer-management/list");

        } catch (IllegalArgumentException e) {
            logger.log(Level.WARNING, "Validation error when saving customer", e);
            request.setAttribute("error", e.getMessage());
            request.setAttribute("customerInput", customerInput);
            request.getRequestDispatcher(formJspPath).forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error saving new customer", e);
            request.setAttribute("error", "Đã có lỗi xảy ra khi lưu thông tin khách hàng: " + e.getMessage());
            request.setAttribute("customerInput", customerInput);
            request.getRequestDispatcher(formJspPath).forward(request, response);
        }
    }

    /**
     * Handle show edit form
     */
    private void handleShowEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int customerId = getIntParameter(request, "id", 0);
            if (customerId <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID khách hàng không hợp lệ.");
                return;
            }

            Optional<Customer> customerOpt = customerDAO.findById(customerId);
            if (customerOpt.isPresent()) {
                Customer customer = customerOpt.get();
                request.setAttribute("customer", customer);
                // Truyền ngày tạo đúng kiểu cho JSP
                if (customer.getCreatedAt() != null) {
                    request.setAttribute("createdAtDate", java.sql.Timestamp.valueOf(customer.getCreatedAt()));
                } else {
                    request.setAttribute("createdAtDate", null);
                }
                // Truyền ngày cập nhật đúng kiểu cho JSP
                if (customer.getUpdatedAt() != null) {
                    request.setAttribute("updatedAtDate", java.sql.Timestamp.valueOf(customer.getUpdatedAt()));
                } else {
                    request.setAttribute("updatedAtDate", null);
                }
                // Pass role information to JSP for conditional display
                request.setAttribute("isAdmin", AuthenticationContext.hasRole(request, RoleConstants.ADMIN_ID));
                request.setAttribute("isManager", AuthenticationContext.hasRole(request, RoleConstants.MANAGER_ID));
                request.setAttribute("isReceptionist", AuthenticationContext.hasRole(request, RoleConstants.RECEPTIONIST_ID));
                
                String viewPath = getViewPath("customer_edit.jsp");
                request.getRequestDispatcher(viewPath).forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy khách hàng.");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error showing edit form", e);
            handleError(request, response, "Lỗi khi hiển thị form chỉnh sửa: " + e.getMessage());
        }
    }

    /**
     * Handle update customer
     */
    private void handleUpdateCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String formJspPath = getViewPath("customer_edit.jsp");
        
        try {
            int customerId = getIntParameter(request, "id", 0);
            if (customerId <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID khách hàng không hợp lệ.");
                return;
            }

            Optional<Customer> customerOpt = customerDAO.findById(customerId);
            if (!customerOpt.isPresent()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy khách hàng.");
                return;
            }

            Customer customer = customerOpt.get();
            
            // Get update parameters
            String name = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phoneNumber");
            String gender = request.getParameter("gender");
            String address = request.getParameter("address");
            String birthdayStr = request.getParameter("birthday");
            String notes = request.getParameter("notes");

            Map<String, String> errors = new HashMap<>();
            Map<String, String> customerInput = new HashMap<>();

            // Store input for redisplay
            customerInput.put("fullName", name);
            customerInput.put("email", email);
            customerInput.put("phoneNumber", phone);
            customerInput.put("gender", gender);
            customerInput.put("address", address);
            customerInput.put("birthday", birthdayStr);
            customerInput.put("notes", notes);

            // Validation for update
            validateCustomerInputForUpdate(customerId, name, email, phone, gender, address, birthdayStr, errors);

            if (!errors.isEmpty()) {
                // Set the current customer data for redisplay
                customer.setFullName(name);
                customer.setEmail(email);
                customer.setPhoneNumber(phone);
                customer.setGender(gender);
                customer.setAddress(address);
                customer.setNotes(notes);
                
                request.setAttribute("errors", errors);
                request.setAttribute("customer", customer);
                request.setAttribute("customerInput", customerInput);
                
                // Pass role information to JSP for conditional display
                request.setAttribute("isAdmin", AuthenticationContext.hasRole(request, RoleConstants.ADMIN_ID));
                request.setAttribute("isManager", AuthenticationContext.hasRole(request, RoleConstants.MANAGER_ID));
                request.setAttribute("isReceptionist", AuthenticationContext.hasRole(request, RoleConstants.RECEPTIONIST_ID));
                
                request.getRequestDispatcher(formJspPath).forward(request, response);
                return;
            }

            // Update customer fields
            customer.setFullName(name.trim());
            
            if (email != null && !email.trim().isEmpty()) {
                customer.setEmail(email.trim().toLowerCase());
            } else {
                customer.setEmail(null);
            }
            
            if (phone != null && !phone.trim().isEmpty()) {
                customer.setPhoneNumber(phone.trim());
            } else {
                customer.setPhoneNumber(null);
            }
            
            customer.setGender(gender != null && !gender.trim().isEmpty() ? gender : "UNKNOWN");
            customer.setAddress(address != null && !address.trim().isEmpty() ? address.trim() : null);
            customer.setNotes(notes != null && !notes.trim().isEmpty() ? notes.trim() : null);
            
            // Handle birthday
            if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
                customer.setBirthday(Date.valueOf(birthdayStr));
            } else {
                customer.setBirthday(null);
            }

            customerDAO.update(customer);

            request.getSession().setAttribute("successMessage", "Đã cập nhật thông tin khách hàng thành công!");
            response.sendRedirect(request.getContextPath() + "/customer-management/list");

        } catch (IllegalArgumentException e) {
            logger.log(Level.WARNING, "Validation error when updating customer", e);
            request.getSession().setAttribute("errorMessage", "Lỗi validation: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/customer-management/edit?id=" + request.getParameter("id"));
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating customer", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi cập nhật thông tin khách hàng: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/customer-management/edit?id=" + request.getParameter("id"));
        }
    }

    /**
     * Handle activate customer account
     */
    private void handleActivateAccount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int customerId = getIntParameter(request, "id", 0);
            if (customerId <= 0) {
                request.getSession().setAttribute("errorMessage", "ID khách hàng không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/customer-management/list");
                return;
            }

            if (customerDAO.activateCustomer(customerId)) {
                request.getSession().setAttribute("successMessage", "Đã kích hoạt tài khoản khách hàng thành công.");
            } else {
                request.getSession().setAttribute("errorMessage", "Kích hoạt tài khoản thất bại.");
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error activating customer account", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi kích hoạt tài khoản: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/customer-management/list");
    }

    /**
     * Handle deactivate customer account
     */
    private void handleDeactivateAccount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int customerId = getIntParameter(request, "id", 0);
            if (customerId <= 0) {
                request.getSession().setAttribute("errorMessage", "ID khách hàng không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/customer-management/list");
                return;
            }

            if (customerDAO.deactivateCustomer(customerId)) {
                request.getSession().setAttribute("successMessage", "Đã vô hiệu hóa tài khoản khách hàng thành công.");
            } else {
                request.getSession().setAttribute("errorMessage", "Vô hiệu hóa tài khoản thất bại.");
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error deactivating customer account", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi vô hiệu hóa tài khoản: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/customer-management/list");
    }

    /**
     * Handle password reset management page
     */
    private void handlePasswordResetManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int page = getIntParameter(request, "page", 1);
            int pageSize = getIntParameter(request, "pageSize", DEFAULT_PAGE_SIZE);
            String searchValue = request.getParameter("searchValue");

            // Get all customers for password reset
            List<Customer> customers = customerDAO.getPaginatedCustomers(page, pageSize, searchValue, null, null, "fullName", "asc");
            int totalCustomers = customerDAO.getTotalCustomerCount(searchValue, null, null);
            int totalPages = (int) Math.ceil((double) totalCustomers / pageSize);

            // Calculate pagination display info
            int startItem = totalCustomers > 0 ? (page - 1) * pageSize + 1 : 0;
            int endItem = Math.min(page * pageSize, totalCustomers);

            request.setAttribute("customers", customers);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("startItem", startItem);
            request.setAttribute("endItem", endItem);
            request.setAttribute("searchValue", searchValue);

            String viewPath = getViewPath("password_reset.jsp");
            request.getRequestDispatcher(viewPath).forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading password reset management", e);
            handleError(request, response, "Lỗi khi tải trang đặt lại mật khẩu: " + e.getMessage());
        }
    }

    /**
     * Handle process password reset
     */
    private void handleProcessPasswordReset(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = request.getParameter("email");
            String newPassword = request.getParameter("newPassword");

            if (email == null || email.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Email là bắt buộc.");
                response.sendRedirect(request.getContextPath() + "/customer-management/reset-password");
                return;
            }

            if (newPassword == null || newPassword.length() < 7) {
                request.getSession().setAttribute("errorMessage", "Mật khẩu mới phải có ít nhất 7 ký tự.");
                response.sendRedirect(request.getContextPath() + "/customer-management/reset-password");
                return;
            }

            // Find customer by email and reset password
            List<Customer> customers = customerDAO.findByEmailContain(email.trim());
            if (customers.isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy khách hàng với email này.");
                response.sendRedirect(request.getContextPath() + "/customer-management/reset-password");
                return;
            }

            Customer customer = customers.get(0);
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            customer.setHashPassword(hashedPassword);
            customerDAO.update(customer);

            request.getSession().setAttribute("successMessage", "Đã đặt lại mật khẩu thành công cho khách hàng: " + email);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing password reset", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi đặt lại mật khẩu: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/customer-management/reset-password");
    }

    /**
     * Handle quick password reset
     */
    private void handleQuickPasswordReset(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int customerId = getIntParameter(request, "id", 0);
            if (customerId <= 0) {
                request.getSession().setAttribute("errorMessage", "ID khách hàng không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/customer-management/list");
                return;
            }

            // Find customer by ID
            Optional<Customer> customerOpt = customerDAO.findById(customerId);
            if (!customerOpt.isPresent()) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy khách hàng với ID: " + customerId);
                response.sendRedirect(request.getContextPath() + "/customer-management/list");
                return;
            }

            Customer customer = customerOpt.get();

            // Generate secure random password
            String newPassword = generateSecurePassword();

            // Hash password with BCrypt before storing
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            customer.setHashPassword(hashedPassword);
            customerDAO.update(customer);

            // Send email with new password (if email exists)
            if (customer.getEmail() != null && !customer.getEmail().trim().isEmpty()) {
                try {
                    asyncEmailService.sendNewPasswordEmailFireAndForget(customer.getEmail(), newPassword, request.getContextPath());
                } catch (Exception emailError) {
                    logger.log(Level.WARNING, "Failed to send password reset email", emailError);
                }
            }

            request.getSession().setAttribute("successMessage", 
                "Đã đặt lại mật khẩu thành công cho khách hàng: " + customer.getFullName() + 
                (customer.getEmail() != null ? " (Email đã được gửi)" : " (Mật khẩu mới: " + newPassword + ")"));

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in quick password reset", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi đặt lại mật khẩu: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/customer-management/list");
    }

    /**
     * Handle quick password reset POST
     */
    private void handleQuickPasswordResetPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleQuickPasswordReset(request, response);
    }

    /**
     * Handle verify customer email
     */
    private void handleVerifyEmail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int customerId = getIntParameter(request, "id", 0);
            if (customerId <= 0) {
                request.getSession().setAttribute("errorMessage", "ID khách hàng không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/customer-management/list");
                return;
            }

            if (customerDAO.verifyCustomerEmail(customerId)) {
                request.getSession().setAttribute("successMessage", "Đã xác thực email khách hàng thành công.");
            } else {
                request.getSession().setAttribute("errorMessage", "Xác thực email thất bại.");
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error verifying customer email", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi xác thực email: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/customer-management/list");
    }

    /**
     * Handle unverify customer email
     */
    private void handleUnverifyEmail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int customerId = getIntParameter(request, "id", 0);
            if (customerId <= 0) {
                request.getSession().setAttribute("errorMessage", "ID khách hàng không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/customer-management/list");
                return;
            }

            if (customerDAO.unverifyCustomerEmail(customerId)) {
                request.getSession().setAttribute("successMessage", "Đã hủy xác thực email khách hàng thành công.");
            } else {
                request.getSession().setAttribute("errorMessage", "Hủy xác thực email thất bại.");
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error unverifying customer email", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi hủy xác thực email: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/customer-management/list");
    }

    /**
     * Handle bulk actions on customers
     */
    private void handleBulkAccountAction(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            String[] customerIds = request.getParameterValues("customerIds");

            if (customerIds == null || customerIds.length == 0) {
                request.getSession().setAttribute("errorMessage", "Vui lòng chọn ít nhất một khách hàng.");
                response.sendRedirect(request.getContextPath() + "/customer-management/list");
                return;
            }

            int successCount = 0;
            for (String idStr : customerIds) {
                try {
                    int customerId = Integer.parseInt(idStr);
                    boolean success = false;

                    switch (action) {
                        case "activate":
                            success = customerDAO.activateCustomer(customerId);
                            break;
                        case "deactivate":
                            success = customerDAO.deactivateCustomer(customerId);
                            break;
                        case "verify":
                            success = customerDAO.verifyCustomerEmail(customerId);
                            break;
                        case "unverify":
                            success = customerDAO.unverifyCustomerEmail(customerId);
                            break;
                    }

                    if (success) {
                        successCount++;
                    }
                } catch (NumberFormatException e) {
                    logger.warning("Invalid customer ID: " + idStr);
                }
            }

            request.getSession().setAttribute("successMessage", 
                "Đã thực hiện thành công cho " + successCount + "/" + customerIds.length + " khách hàng.");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing bulk action", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi thực hiện hành động hàng loạt: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/customer-management/list");
    }

    /**
     * Handle bulk action (GET method)
     */
    private void handleBulkAction(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleBulkAccountAction(request, response);
    }

    /**
     * Handle search customers
     */
    private void handleSearchCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleListCustomers(request, response);
    }

    // Helper methods

    /**
     * Get appropriate view path based on user role
     */
    private String getViewPath(String fileName) {
        // For now, use common view path - can be customized per role later
        return "/WEB-INF/view/common/CustomerManagement/" + fileName;
    }

    /**
     * Map frontend sort parameter to database column
     */
    private String mapSortByToDatabase(String sortBy) {
        switch (sortBy) {
            case "fullName":
                return "full_name";
            case "loyaltyPoints":
                return "loyalty_points";
            case "createdAt":
                return "created_at";
            case "email":
                return "email";
            case "phoneNumber":
                return "phone_number";
            default:
                return "full_name";
        }
    }

    /**
     * Validate customer input
     */
    private void validateCustomerInput(String name, String email, String password, String phone, 
                                     String gender, String address, String birthdayStr, 
                                     Map<String, String> errors) {
        // Validate name
        if (name == null || name.trim().isEmpty()) {
            errors.put("fullNameRequired", "Họ tên là bắt buộc.");
        }
        if (name != null && !name.trim().isEmpty()) {
            if (name.trim().length() < 2 || name.trim().length() > 100) {
                errors.put("fullNameLength", "Họ tên phải có độ dài từ 2 đến 100 ký tự.");
            }
            if (!name.trim().matches("^[\\p{L}\\s]+$")) {
                errors.put("fullNameFormat", "Họ tên chỉ được chứa chữ cái và khoảng trắng, không chứa số hoặc ký tự đặc biệt.");
            }
        }

        // Validate email if provided
        if (email != null && !email.trim().isEmpty()) {
            if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
                errors.put("emailFormat", "Email không hợp lệ.");
            }
            if (email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$") && accountDAO.isEmailTakenInSystem(email.trim())) {
                errors.put("emailDuplicate", "Email đã tồn tại trong hệ thống.");
            }
        }

        // Validate password if provided
        if (password != null && !password.trim().isEmpty()) {
            if (password.length() < 7) {
                errors.put("passwordLength", "Mật khẩu phải có ít nhất 7 ký tự.");
            }
        }

        // Validate phone if provided
        if (phone != null && !phone.trim().isEmpty()) {
            String phoneTrim = phone.trim();
            boolean hasSpecialChar = !phoneTrim.matches("^[0-9]+$");
            boolean hasLengthError = phoneTrim.length() != 10;
            boolean notStartWith0 = !phoneTrim.startsWith("0");
            boolean isDuplicate = accountDAO.isPhoneTakenInSystem(phoneTrim);
            if (hasSpecialChar) {
                errors.put("phoneNumberFormat", "Số điện thoại không được chứa ký tự đặc biệt, chỉ gồm số.");
            }
            if (hasLengthError) {
                errors.put("phoneNumberLength", "Số điện thoại phải gồm đúng 10 chữ số.");
            }
            if (notStartWith0) {
                errors.put("phoneNumberStart", "Số điện thoại phải bắt đầu bằng số 0.");
            }
            if (!hasSpecialChar && !hasLengthError && !notStartWith0 && isDuplicate) {
                errors.put("phoneNumberDuplicate", "Số điện thoại đã tồn tại trong hệ thống.");
            }
        }

        // Validate birthday if provided
        if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
            try {
                java.sql.Date birthday = java.sql.Date.valueOf(birthdayStr);
                java.time.LocalDate birthDate = birthday.toLocalDate();
                java.time.LocalDate today = java.time.LocalDate.now();
                if (birthDate.isAfter(today)) {
                    errors.put("birthdayFuture", "Ngày sinh không được vượt quá ngày hiện tại.");
                }
                if (java.time.Period.between(birthDate, today).getYears() < 14) {
                    errors.put("birthdayAge", "Khách hàng phải đủ 14 tuổi trở lên mới đăng ký tài khoản.");
                }
            } catch (IllegalArgumentException e) {
                errors.put("birthdayFormat", "Ngày sinh không hợp lệ.");
            }
        }
    }

    /**
     * Validate customer input for update
     */
    private void validateCustomerInputForUpdate(int customerId, String name, String email, String phone, String gender, String address, String birthdayStr, Map<String, String> errors) {
        // Validate name
        if (name == null || name.trim().isEmpty()) {
            errors.put("fullNameRequired", "Họ tên là bắt buộc.");
        }
        if (name != null && !name.trim().isEmpty()) {
            if (name.trim().length() < 2 || name.trim().length() > 100) {
                errors.put("fullNameLength", "Họ tên phải có độ dài từ 2 đến 100 ký tự.");
            }
            if (!name.trim().matches("^[\\p{L}\\s]+$")) {
                errors.put("fullNameFormat", "Họ tên chỉ được chứa chữ cái và khoảng trắng, không chứa số hoặc ký tự đặc biệt.");
            }
        }
        // Validate email if provided
        if (email != null && !email.trim().isEmpty()) {
            if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
                errors.put("emailFormat", "Email không hợp lệ.");
            }
            if (email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
                Optional<Customer> existingCustomer = customerDAO.findCustomerByEmail(email.trim());
                if (existingCustomer.isPresent() && !existingCustomer.get().getCustomerId().equals(customerId)) {
                    errors.put("emailDuplicate", "Email đã tồn tại trong hệ thống.");
                }
            }
        }
        // Validate phone if provided
        if (phone != null && !phone.trim().isEmpty()) {
            String phoneTrim = phone.trim();
            boolean hasSpecialChar = !phoneTrim.matches("^[0-9]+$");
            boolean hasLengthError = phoneTrim.length() != 10;
            boolean notStartWith0 = !phoneTrim.startsWith("0");
            boolean isDuplicate = false;
            try {
                List<Customer> allCustomers = customerDAO.getPaginatedCustomers(1, Integer.MAX_VALUE, phoneTrim, null, null, "id", "asc");
                isDuplicate = allCustomers.stream().anyMatch(c -> c.getPhoneNumber() != null && c.getPhoneNumber().equals(phoneTrim) && !c.getCustomerId().equals(customerId));
            } catch (Exception e) {
                logger.log(Level.WARNING, "Error checking phone uniqueness for update", e);
            }
            if (hasSpecialChar) {
                errors.put("phoneNumberFormat", "Số điện thoại không được chứa ký tự đặc biệt, chỉ gồm số.");
            }
            if (hasLengthError) {
                errors.put("phoneNumberLength", "Số điện thoại phải gồm đúng 10 chữ số.");
            }
            if (notStartWith0) {
                errors.put("phoneNumberStart", "Số điện thoại phải bắt đầu bằng số 0.");
            }
            if (!hasSpecialChar && !hasLengthError && !notStartWith0 && isDuplicate) {
                errors.put("phoneNumberDuplicate", "Số điện thoại đã tồn tại trong hệ thống.");
            }
        }
        // Validate birthday if provided
        if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
            try {
                java.sql.Date birthday = java.sql.Date.valueOf(birthdayStr);
                java.time.LocalDate birthDate = birthday.toLocalDate();
                java.time.LocalDate today = java.time.LocalDate.now();
                if (birthDate.isAfter(today)) {
                    errors.put("birthdayFuture", "Ngày sinh không được vượt quá ngày hiện tại.");
                }
                if (java.time.Period.between(birthDate, today).getYears() < 14) {
                    errors.put("birthdayAge", "Khách hàng phải đủ 14 tuổi trở lên mới đăng ký tài khoản.");
                }
            } catch (IllegalArgumentException e) {
                errors.put("birthdayFormat", "Ngày sinh không hợp lệ.");
            }
        }
    }

    /**
     * Generate secure random password
     */
    private String generateSecurePassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
        SecureRandom random = new SecureRandom();
        StringBuilder password = new StringBuilder();
        
        for (int i = 0; i < 12; i++) {
            password.append(chars.charAt(random.nextInt(chars.length())));
        }
        
        return password.toString();
    }

    /**
     * Get integer parameter with default value
     */
    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        String paramValue = request.getParameter(paramName);
        if (paramValue != null && !paramValue.trim().isEmpty()) {
            try {
                return Integer.parseInt(paramValue.trim());
            } catch (NumberFormatException e) {
                logger.warning("Invalid integer parameter " + paramName + ": " + paramValue);
            }
        }
        return defaultValue;
    }

    /**
     * Handle delete customer (Admin only)
     */
    private void handleDeleteCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Check if user is Admin
            if (!AuthenticationContext.hasRole(request, RoleConstants.ADMIN_ID)) {
                request.getSession().setAttribute("errorMessage", "Chỉ có Admin mới được xóa tài khoản khách hàng.");
                response.sendRedirect(request.getContextPath() + "/customer-management/list");
                return;
            }

            int customerId = getIntParameter(request, "id", 0);
            if (customerId <= 0) {
                request.getSession().setAttribute("errorMessage", "ID khách hàng không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/customer-management/list");
                return;
            }

            // Get customer info before deletion for logging
            Optional<Customer> customerOpt = customerDAO.findById(customerId);
            if (!customerOpt.isPresent()) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy khách hàng với ID: " + customerId);
                response.sendRedirect(request.getContextPath() + "/customer-management/list");
                return;
            }

            Customer customer = customerOpt.get();

            // Check if customer has related data
            if (customerDAO.hasRelatedData(customerId)) {
                Map<String, Integer> relatedData = customerDAO.getRelatedDataSummary(customerId);
                StringBuilder errorMessage = new StringBuilder();
                errorMessage.append("Không thể xóa khách hàng '").append(customer.getFullName()).append("' vì còn có dữ liệu liên quan: ");

                int payments = relatedData.getOrDefault("payments", 0);
                int bookings = relatedData.getOrDefault("bookings", 0);
                int carts = relatedData.getOrDefault("shopping_carts", 0);
                int checkins = relatedData.getOrDefault("checkins", 0);

                if (payments > 0) {
                    errorMessage.append(payments).append(" thanh toán, ");
                }
                if (bookings > 0) {
                    errorMessage.append(bookings).append(" lịch hẹn, ");
                }
                if (carts > 0) {
                    errorMessage.append(carts).append(" giỏ hàng, ");
                }
                if (checkins > 0) {
                    errorMessage.append(checkins).append(" lần check-in, ");
                }

                // Remove trailing comma and space
                String message = errorMessage.toString().replaceAll(", $", "");
                message += ". Vui lòng khóa tài khoản thay vì xóa.";

                request.getSession().setAttribute("errorMessage", message);
                response.sendRedirect(request.getContextPath() + "/customer-management/list");
                return;
            }

            // Safe delete customer
            boolean deleteSuccess = customerDAO.safeDeleteCustomer(customerId);
            
            if (deleteSuccess) {
                request.getSession().setAttribute("successMessage", 
                    "Đã xóa khách hàng thành công: " + customer.getFullName());
                logger.info("Admin deleted customer: " + customer.getFullName() + " (ID: " + customerId + ")");
            } else {
                request.getSession().setAttribute("errorMessage", 
                    "Không thể xóa khách hàng '" + customer.getFullName() + "'. Vui lòng thử lại sau.");
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error deleting customer", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi xóa khách hàng: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/customer-management/list");
    }

    /**
     * Handle error display
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("/WEB-INF/view/common/error.jsp").forward(request, response);
    }
} 