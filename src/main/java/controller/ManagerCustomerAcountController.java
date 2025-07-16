package controller;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.mindrot.jbcrypt.BCrypt;

import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;
import service.email.AsyncEmailService;

/**
 * ManagerCustomerAcountController - Handles customer account management for ADMIN role
 Focus: Account credentials, status, verification, password reset
 URL Pattern: /admin/customer-account/*
 */
@WebServlet(urlPatterns = { "/admin/customer-account/*" })
public class ManagerCustomerAcountController extends HttpServlet {

    private CustomerDAO customerDAO;
    private AsyncEmailService asyncEmailService;
    private static final Logger logger = Logger.getLogger(ManagerCustomerAcountController.class.getName());
    private static final int DEFAULT_PAGE_SIZE = 10;

    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAO();
        asyncEmailService = new AsyncEmailService();
        logger.info("AdminCustomerController initialized successfully");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        logger.info("AdminCustomerController GET request - PathInfo: " + pathInfo);

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
                    handleListCustomerAccounts(request, response);
                    break;
                case "status":
                    handleAccountStatusManagement(request, response);
                    break;
                case "verification":
                    handleEmailVerificationManagement(request, response);
                    break;
                case "reset-password":
                    handlePasswordResetManagement(request, response);
                    break;
                case "activate":
                    handleActivateAccount(request, response);
                    break;
                case "deactivate":
                    handleDeactivateAccount(request, response);
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
                case "verify-all":
                    handleVerifyAllEmails(request, response);
                    break;
                default:
                    logger.warning("Unknown GET action: " + action);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND,
                            "Không tìm thấy trang cho hành động: " + action);
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in AdminCustomerController GET", e);
            handleError(request, response, "Đã xảy ra lỗi: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
                case "reset-password":
                    handleProcessPasswordReset(request, response);
                    break;
                case "quick-reset-password":
                    handleQuickPasswordResetPost(request, response);
                    break;
                case "bulk-action":
                    handleBulkAccountAction(request, response);
                    break;
                case "activate":
                    handleActivateAccount(request, response);
                    break;
                case "deactivate":
                    handleDeactivateAccount(request, response);
                    break;
                case "verify":
                    handleVerifyEmail(request, response);
                    break;
                case "unverify":
                    handleUnverifyEmail(request, response);
                    break;
                default:
                    logger.warning("Invalid POST action: " + action);
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hành động không hợp lệ: " + action);
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in AdminCustomerController POST", e);
            handleError(request, response, "Đã xảy ra lỗi trong quá trình xử lý POST: " + e.getMessage());
        }
    }

    /**
     * Handle list customer accounts with focus on account status
     */
    private void handleListCustomerAccounts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int page = getIntParameter(request, "page", 1);
            int pageSize = getIntParameter(request, "pageSize", DEFAULT_PAGE_SIZE);
            String status = request.getParameter("status");
            String verification = request.getParameter("verification");
            String searchValue = request.getParameter("searchValue");

            // Get customers with pagination
            List<Customer> customers = customerDAO.getPaginatedCustomers(page, pageSize, searchValue, status, verification, "id", "asc");
            int totalCustomers = customerDAO.getTotalCustomerCount(searchValue, status, verification);
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
            request.setAttribute("status", status);
            request.setAttribute("verification", verification);
            request.setAttribute("searchValue", searchValue);

            request.getRequestDispatcher("/WEB-INF/view/admin_pages/CustomerAccount/account_list.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading customer account list", e);
            handleError(request, response, "Lỗi khi tải danh sách tài khoản khách hàng: " + e.getMessage());
        }
    }

    /**
     * Handle account status management page
     */
    private void handleAccountStatusManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get statistics for account status
            int activeAccounts = customerDAO.countCustomersByStatus(true);
            int inactiveAccounts = customerDAO.countCustomersByStatus(false);
            int verifiedAccounts = customerDAO.countCustomersByVerification(true);
            int unverifiedAccounts = customerDAO.countCustomersByVerification(false);

            request.setAttribute("activeAccounts", activeAccounts);
            request.setAttribute("inactiveAccounts", inactiveAccounts);
            request.setAttribute("verifiedAccounts", verifiedAccounts);
            request.setAttribute("unverifiedAccounts", unverifiedAccounts);

            request.getRequestDispatcher("/WEB-INF/view/admin_pages/CustomerAccount/status_management.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading account status management", e);
            handleError(request, response, "Lỗi khi tải trang quản lý trạng thái tài khoản: " + e.getMessage());
        }
    }

    /**
     * Handle email verification management
     */
    private void handleEmailVerificationManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get pagination parameters
            int page = getIntParameter(request, "page", 1);
            int pageSize = getIntParameter(request, "pageSize", 10);
            String search = request.getParameter("search");
            String sortBy = Optional.ofNullable(request.getParameter("sortBy")).orElse("created");
            String sortOrder = Optional.ofNullable(request.getParameter("sortOrder")).orElse("desc");

            // Log request parameters
            logger.info("Verification management - Page: " + page + ", PageSize: " + pageSize + 
                       ", Search: '" + search + "', SortBy: " + sortBy + ", SortOrder: " + sortOrder);

            // Get unverified customers with pagination
            List<Customer> unverifiedCustomers;
            int totalRecords;
            
            if (pageSize == 9999) { // Show all
                unverifiedCustomers = customerDAO.getPaginatedUnverifiedCustomers(1, pageSize, search, sortBy, sortOrder);
                totalRecords = unverifiedCustomers.size();
            } else {
                unverifiedCustomers = customerDAO.getPaginatedUnverifiedCustomers(page, pageSize, search, sortBy, sortOrder);
                totalRecords = customerDAO.getTotalUnverifiedCustomersWithSearch(search);
            }

            // Calculate pagination info
            int totalPages = pageSize == 9999 ? 1 : (int) Math.ceil((double) totalRecords / pageSize);
            int startItem = pageSize == 9999 ? 1 : (page - 1) * pageSize + 1;
            int endItem = pageSize == 9999 ? totalRecords : Math.min(page * pageSize, totalRecords);

            // Set attributes
            request.setAttribute("unverifiedCustomers", unverifiedCustomers);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("startItem", startItem);
            request.setAttribute("endItem", endItem);
            request.setAttribute("search", search);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);

            request.getRequestDispatcher("/WEB-INF/view/admin_pages/CustomerAccount/verification_management.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading email verification management", e);
            handleError(request, response, "Lỗi khi tải trang quản lý xác thực email: " + e.getMessage());
        }
    }

    /**
     * Handle verify all customers emails
     */
    private void handleVerifyAllEmails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int verifiedCount = customerDAO.verifyAllCustomers();
            
            if (verifiedCount > 0) {
                request.getSession().setAttribute("successMessage", 
                    "Đã xác thực email cho " + verifiedCount + " khách hàng thành công.");
            } else {
                request.getSession().setAttribute("infoMessage", 
                    "Không có khách hàng nào cần xác thực email.");
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error verifying all customer emails", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi xác thực tất cả email: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/customer-account/verification");
    }

    /**
     * Handle password reset management
     */
    private void handlePasswordResetManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int page = getIntParameter(request, "page", 1);
            int pageSize = getIntParameter(request, "pageSize", DEFAULT_PAGE_SIZE);
            String searchValue = request.getParameter("searchValue");

            // Get customers that need password reset - inactive accounts or unverified emails
            List<Customer> customersNeedingReset = customerDAO.getPaginatedCustomers(page, pageSize, searchValue, "false", "false", "id", "desc");
            int totalCustomers = customerDAO.getTotalCustomerCount(searchValue, "false", "false");
            int totalPages = (int) Math.ceil((double) totalCustomers / pageSize);
            
            // Calculate pagination display info
            int startItem = totalCustomers > 0 ? (page - 1) * pageSize + 1 : 0;
            int endItem = Math.min(page * pageSize, totalCustomers);

            // Get statistics
            int inactiveAccounts = customerDAO.countCustomersByStatus(false);
            int unverifiedAccounts = customerDAO.countCustomersByVerification(false);

            request.setAttribute("customers", customersNeedingReset);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("startItem", startItem);
            request.setAttribute("endItem", endItem);
            request.setAttribute("searchValue", searchValue);
            request.setAttribute("inactiveAccounts", inactiveAccounts);
            request.setAttribute("unverifiedAccounts", unverifiedAccounts);

            request.getRequestDispatcher("/WEB-INF/view/admin_pages/CustomerAccount/password_reset.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading password reset management", e);
            handleError(request, response, "Lỗi khi tải trang đặt lại mật khẩu: " + e.getMessage());
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
                response.sendRedirect(request.getContextPath() + "/admin/customer-account/list");
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

        response.sendRedirect(request.getContextPath() + "/admin/customer-account/list");
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
                response.sendRedirect(request.getContextPath() + "/admin/customer-account/list");
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

        response.sendRedirect(request.getContextPath() + "/admin/customer-account/list");
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
                response.sendRedirect(request.getContextPath() + "/admin/customer-account/verification");
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

        response.sendRedirect(request.getContextPath() + "/admin/customer-account/verification");
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
                response.sendRedirect(request.getContextPath() + "/admin/customer-account/verification");
                return;
            }

            if (customerDAO.unverifyCustomerEmail(customerId)) {
                request.getSession().setAttribute("successMessage", "Đã hủy xác thực email khách hàng.");
            } else {
                request.getSession().setAttribute("errorMessage", "Hủy xác thực email thất bại.");
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error unverifying customer email", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi hủy xác thực email: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/customer-account/verification");
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
                response.sendRedirect(request.getContextPath() + "/admin/customer-account/reset-password");
                return;
            }

            if (newPassword == null || newPassword.length() < 7) {
                request.getSession().setAttribute("errorMessage", "Mật khẩu mới phải có ít nhất 7 ký tự.");
                response.sendRedirect(request.getContextPath() + "/admin/customer-account/reset-password");
                return;
            }

            // Find customer by email and reset password
            List<Customer> customers = customerDAO.findByEmailContain(email.trim());
            if (customers.isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy khách hàng với email này.");
                response.sendRedirect(request.getContextPath() + "/admin/customer-account/reset-password");
                return;
            }

            Customer customer = customers.get(0);
            customer.setHashPassword(newPassword); // Note: Should hash the password
            customerDAO.update(customer);

            request.getSession().setAttribute("successMessage", "Đã đặt lại mật khẩu thành công cho khách hàng: " + email);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing password reset", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi đặt lại mật khẩu: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/customer-account/reset-password");
    }

    /**
     * Handle bulk account actions
     */
    private void handleBulkAccountAction(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            String[] customerIds = request.getParameterValues("customerIds");

            if (customerIds == null || customerIds.length == 0) {
                request.getSession().setAttribute("errorMessage", "Vui lòng chọn ít nhất một khách hàng.");
                response.sendRedirect(request.getContextPath() + "/admin/customer-account/list");
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
            logger.log(Level.SEVERE, "Error processing bulk account action", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi thực hiện hành động hàng loạt: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/customer-account/list");
    }

    /**
     * Handle quick password reset from customer list
     */
    private void handleQuickPasswordReset(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int customerId = getIntParameter(request, "id", 0);
            if (customerId <= 0) {
                request.getSession().setAttribute("errorMessage", "ID khách hàng không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/admin/customer-account/list");
                return;
            }

            // Find customer by ID to get email
            Optional<Customer> customerOpt = customerDAO.findById(customerId);
            if (!customerOpt.isPresent()) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy khách hàng với ID: " + customerId);
                response.sendRedirect(request.getContextPath() + "/admin/customer-account/list");
                return;
            }

            Customer customer = customerOpt.get();
            
            // Generate secure random password
            String newPassword = generateSecurePassword();
            
            // Hash password with BCrypt before storing
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            customer.setHashPassword(hashedPassword);
            customerDAO.update(customer);

            // Log password reset action
            logger.info("Password reset performed for customer ID: " + customerId + " by admin");

            // Send new password via email asynchronously
            asyncEmailService.sendNewPasswordEmailFireAndForget(customer.getEmail(), newPassword, request.getContextPath());

            // Show success message without revealing password
            request.getSession().setAttribute("successMessage", 
                "Đã đặt lại mật khẩu thành công cho khách hàng: " + customer.getEmail() + 
                ". Mật khẩu mới đã được gửi đến email của khách hàng. "
               );

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in quick password reset for customer ID: " + 
                      request.getParameter("id"), e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi đặt lại mật khẩu: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/customer-account/list");
    }

    @Override
    public void destroy() {
        if (asyncEmailService != null) {
            asyncEmailService.shutdown();
            logger.info("AdminCustomerController destroyed and email service shutdown");
        }
        super.destroy();
    }

    /**
     * Generate a secure random password
     * Format: 2 uppercase + 2 lowercase + 2 digits + 2 special chars = 8 chars
     */
    private String generateSecurePassword() {
        String uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        String lowercase = "abcdefghijklmnopqrstuvwxyz"; 
        String digits = "0123456789";
        String special = "!@#$%^&*";
        
        SecureRandom random = new SecureRandom();
        StringBuilder password = new StringBuilder();
        
        // Add 2 characters from each category
        for (int i = 0; i < 2; i++) {
            password.append(uppercase.charAt(random.nextInt(uppercase.length())));
            password.append(lowercase.charAt(random.nextInt(lowercase.length())));
            password.append(digits.charAt(random.nextInt(digits.length())));
            password.append(special.charAt(random.nextInt(special.length())));
        }
        
        // Shuffle the password characters
        return shuffleString(password.toString(), random);
    }

    /**
     * Shuffle string characters randomly
     */
    private String shuffleString(String string, SecureRandom random) {
        char[] chars = string.toCharArray();
        for (int i = chars.length - 1; i > 0; i--) {
            int j = random.nextInt(i + 1);
            char temp = chars[i];
            chars[i] = chars[j];
            chars[j] = temp;
        }
        return new String(chars);
    }

    // Utility methods
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("jakarta.servlet.error.status_code", 500);
        request.setAttribute("jakarta.servlet.error.message", errorMessage);
        request.setAttribute("jakarta.servlet.error.request_uri", request.getRequestURI());
        request.getRequestDispatcher("/WEB-INF/view/common/error/500.jsp").forward(request, response);
    }

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
     * Handle quick password reset for a single customer
     */
    private void handleQuickPasswordResetPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int customerId = getIntParameter(request, "id", 0);
            if (customerId <= 0) {
                request.getSession().setAttribute("errorMessage", "ID khách hàng không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/admin/customer-account/reset-password");
                return;
            }

            // Get customer info first
            Optional<Customer> customerOpt = customerDAO.findById(customerId);
            if (!customerOpt.isPresent()) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy khách hàng.");
                response.sendRedirect(request.getContextPath() + "/admin/customer-account/reset-password");
                return;
            }

            Customer customer = customerOpt.get();
            
            // Generate new random password
            String newPassword = generateRandomPassword(8);
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

            // Update password using customer email
            dao.AccountDAO accountDAO = new dao.AccountDAO();
            if (accountDAO.updateCustomerPassword(customer.getEmail(), hashedPassword)) {
                // Send simple notification email
                try {
                    request.getSession().setAttribute("successMessage", 
                        "Đã đặt lại mật khẩu thành công cho khách hàng: " + customer.getFullName() + 
                        ". Mật khẩu mới: " + newPassword + " (Vui lòng thông báo cho khách hàng)");
                } catch (Exception emailError) {
                    logger.warning("Could not send email notification: " + emailError.getMessage());
                    request.getSession().setAttribute("successMessage", 
                        "Đã đặt lại mật khẩu thành công. Mật khẩu mới: " + newPassword + " (Vui lòng thông báo cho khách hàng)");
                }
            } else {
                request.getSession().setAttribute("errorMessage", "Đặt lại mật khẩu thất bại.");
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in quick password reset", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi đặt lại mật khẩu: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/customer-account/reset-password");
    }

    // Hàm sinh mật khẩu ngẫu nhiên
    private String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder();
        java.util.Random random = new java.util.Random();
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }
} 