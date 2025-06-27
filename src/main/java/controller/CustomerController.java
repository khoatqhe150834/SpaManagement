package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.AccountDAO;
import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;

/**
 * Complete CustomerController with proper error handling and validation URL
 * Pattern: /customer/* Actions: list, view, create, edit, delete, search
 *
 * @author Admin
 */
@WebServlet(urlPatterns = {"/customer/*"})
public class CustomerController extends HttpServlet {

    private CustomerDAO customerDAO;
    private static final Logger logger = Logger.getLogger(CustomerController.class.getName());
    private static final int DEFAULT_PAGE_SIZE = 10;

    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAO();
        logger.info("CustomerController initialized successfully");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        logger.info("CustomerController GET request - PathInfo: " + pathInfo);

        try {
            String action = "list"; // Mặc định là action "list"
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
                    handleViewCustomer(request, response);
                    break;
                case "create":
                    handleShowCreateForm(request, response);
                    break;
                case "edit":
                    handleShowEditForm(request, response);
                    break;
                case "deactivate":
                    handleDeactivateCustomer(request, response);
                    break;
                case "activate":
                    handleActivateCustomer(request, response);
                    break;
                case "search":
                    handleListCustomers(request, response);
                    break;
                case "api":
                    handleApiRequest(request, response);
                    break;
                default:
                    logger.warning("Unknown GET action: " + action);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Page not found for action: " + action);
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in CustomerController GET", e);
            handleError(request, response, "An error occurred: " + e.getMessage());
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
            if (action == null || action.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action for POST request.");
                return;
            }

            switch (action.toLowerCase()) {
                case "create":
                    handleProcessCreateForm(request, response);
                    break;
                case "update":
                    handleUpdateCustomer(request, response);
                    break;
                default:
                    logger.warning("Invalid POST action: " + action);
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action: " + action);
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in CustomerController POST", e);
            handleError(request, response, "An error occurred during POST action: " + e.getMessage());
        }
    }

    /**
     * Handle list customers with pagination and filtering
     */
    private void handleListCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int page = getIntParameter(request, "page", 1);
            String pageSizeParam = request.getParameter("pageSize");
            int pageSize = (pageSizeParam == null || pageSizeParam.isEmpty()) ? DEFAULT_PAGE_SIZE : Integer.parseInt(pageSizeParam);

            String status = request.getParameter("status");
            String sortBy = Optional.ofNullable(request.getParameter("sortBy")).orElse("id");
            String sortOrder = Optional.ofNullable(request.getParameter("sortOrder")).orElse("asc");
            String searchValue = request.getParameter("searchValue");

            if (page < 1) page = 1;
            if (pageSize < 1 && pageSize != -1) pageSize = DEFAULT_PAGE_SIZE; // -1 for ALL

            int actualPageSize = (pageSize == 9999) ? Integer.MAX_VALUE : pageSize;

            List<Customer> customers = customerDAO.getPaginatedCustomers(page, actualPageSize, searchValue, status, sortBy, sortOrder);
            int totalCustomers = customerDAO.getTotalCustomerCount(searchValue, status);

            int totalPages = 0;
            if (totalCustomers > 0) {
                totalPages = (int) Math.ceil((double) totalCustomers / actualPageSize);
            }
            if (totalPages < 1) totalPages = 1;
            if (page > totalPages) page = totalPages;

            request.setAttribute("customers", customers);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize); // Pass original pageSize (e.g., 9999) back to JSP
            request.setAttribute("totalpages", totalPages);
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("status", status);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);
            request.setAttribute("searchValue", searchValue);

            request.getRequestDispatcher("/WEB-INF/view/admin_pages/Customer/customer_list.jsp").forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading customer list", e);
            handleError(request, response, "Error loading customer list: " + e.getMessage());
        }
    }

    /**
     * Handle view single customer
     */
    private void handleViewCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int customerId = getIntParameter(request, "id", 0);
            if (customerId <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid customer ID");
                return;
            }

            Optional<Customer> customerOpt = customerDAO.findById(customerId);
            if (customerOpt.isPresent()) {
                request.setAttribute("customer", customerOpt.get());
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/Customer/customer_details.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Customer not found");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error viewing customer", e);
            handleError(request, response, "Error viewing customer: " + e.getMessage());
        }
    }

    /**
     * Shows the form for creating a new customer. (Handles GET requests)
     */
    private void handleShowCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
        String jspPath = "/WEB-INF/view/admin_pages/Customer/customer_add.jsp";
        request.getRequestDispatcher(jspPath).forward(request, response);
    }

    /**
     * Processes the submission of the new customer form. (Handles POST
     * requests)
     */
    
    

// ...
   // ... (các phương thức khác giữ nguyên)

/**
 * Processes the submission of the new customer form with validation.
 * (Handles POST requests)
 */
private void handleProcessCreateForm(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    AccountDAO accountDao = new AccountDAO();
    
    String formJspPath = "/WEB-INF/view/admin_pages/Customer/customer_add.jsp";

    String name = request.getParameter("fullName");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String phone = request.getParameter("phoneNumber");
    String gender = request.getParameter("gender");
    String address = request.getParameter("address");
    String birthdayStr = request.getParameter("birthday");

    Map<String, String> errors = new HashMap<>();

    // --- VALIDATION ---
    // 1. Full Name
    if (name == null || name.trim().isEmpty()) {
        errors.put("fullName", "Full name is required.");
    } else if (name.trim().length() > 100) {
        // FIXED: Sửa thông báo lỗi để khớp với logic (100 ký tự)
        errors.put("fullName", "Full name must not exceed 100 characters.");
    }

    // 2. Email
    if (email == null || email.trim().isEmpty()) {
        errors.put("email", "Email is required.");
    } else if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
        errors.put("email", "Invalid email format.");
    } else {
        // IMPROVEMENT: Đặt kiểm tra email tồn tại trong try-catch để xử lý lỗi DB
        try {
            if (!customerDAO.findByEmailContain(email.trim()).isEmpty()) {
                errors.put("email", "This email is already registered.");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Database error checking email uniqueness", e);
            errors.put("email", "Could not verify email. Please try again.");
        }
    }

    // 3. Password
    if (password == null || password.isEmpty()) {
        errors.put("password", "Password is required.");
    } else if (password.length() < 6) {
        // FIXED: Sửa thông báo lỗi để khớp với logic và HTML (minlength="7")
        errors.put("password", "Password must be at least 6 characters long.");
    }

    // 4. Phone Number
     if (phone != null && !phone.trim().isEmpty()) {
        if (!phone.matches("^0\\d{9}$")) {
            errors.put("phoneNumber", "Phone number must be 10 digits starting with 0.");
        } else {
            // --- THÊM LOGIC KIỂM TRA TỒN TẠI VÀO ĐÂY ---
            try {
                if (accountDao.isPhoneTakenInSystem(phone.trim())) {
                    errors.put("phoneNumber", "This phone number is already registered.");
                }
            } catch (Exception e) {
                logger.log(Level.SEVERE, "Database error checking phone number uniqueness", e);
                errors.put("phoneNumber", "Could not verify phone number. Please try again.");
            }
        }
    }

    // 5. Birthday
    Date birthday = null;
    if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
        try {
            birthday = Date.valueOf(birthdayStr);
            if (birthday.after(new java.util.Date())) {
                errors.put("birthday", "Birthday cannot be in the future.");
            }
        } catch (IllegalArgumentException e) {
            errors.put("birthday", "Invalid date format. Please use YYYY-MM-DD.");
        }
    }

    // Tạo đối tượng customerInput để giữ lại dữ liệu đã nhập trên form
    Customer customerInput = new Customer();
    customerInput.setFullName(name);
    customerInput.setEmail(email);
    customerInput.setPhoneNumber(phone);
    customerInput.setGender(gender);
    customerInput.setAddress(address);
    if (birthday != null) {
        customerInput.setBirthday(birthday);
    }
    // Không set password vào customerInput để gửi lại view vì lý do bảo mật

    // Nếu có lỗi validation, gửi lại form với các lỗi và dữ liệu đã nhập
    if (!errors.isEmpty()) {
        request.setAttribute("errors", errors);
        request.setAttribute("customerInput", customerInput);
        request.getRequestDispatcher(formJspPath).forward(request, response);
        return;
    }

    
    try {
        Customer newCustomer = new Customer();
        newCustomer.setFullName(name.trim());
        newCustomer.setEmail(email.trim().toLowerCase());
        // SECURITY NOTE: Luôn mã hóa mật khẩu trước khi lưu.
        // Ví dụ: newCustomer.setHashPassword(PasswordUtil.hash(password));
        newCustomer.setHashPassword(password);
        newCustomer.setPhoneNumber(phone != null ? phone.trim() : null);
        newCustomer.setGender(gender);
        newCustomer.setAddress(address != null ? address.trim() : null);
        newCustomer.setBirthday(birthday);
        newCustomer.setIsActive(true);
        newCustomer.setIsVerified(false); // Mặc định là chưa xác thực
        newCustomer.setLoyaltyPoints(0);
        newCustomer.setRoleId(1); // Giả sử 1 là vai trò khách hàng

        customerDAO.save(newCustomer);

        request.getSession().setAttribute("successMessage", "Đã thêm khách hàng mới thành công!");
        response.sendRedirect(request.getContextPath() + "/customer/list");

    } catch (Exception e) {
        // --- IMPROVED ERROR HANDLING ---
        // Ghi lại lỗi đầy đủ để debug
        logger.log(Level.SEVERE, "Error saving new customer to database", e);

        // Đặt một thông báo lỗi cụ thể hơn để hiển thị cho người dùng
        // Hiển thị e.getMessage() sẽ giúp bạn tìm ra lỗi nhanh hơn trong quá trình phát triển
        String userErrorMessage = "An unexpected error occurred while saving the customer. Please check the server logs for details. Error: " + e.getMessage();
        request.setAttribute("error", userErrorMessage);
        
        // Gửi lại dữ liệu đã nhập để người dùng không phải nhập lại
        request.setAttribute("customerInput", customerInput);
        
        // Chuyển tiếp lại trang thêm mới
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
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid customer ID");
                return;
            }

            Optional<Customer> customerOpt = customerDAO.findById(customerId);
            if (customerOpt.isPresent()) {
                request.setAttribute("customer", customerOpt.get());
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/Customer/customer_edit.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Customer not found");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error showing edit form", e);
            handleError(request, response, "Error loading customer for edit: " + e.getMessage());
        }
    }

    /**
     * Handle update customer
     */
    private void handleUpdateCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int customerId = getIntParameter(request, "customerId", 0);
            if (customerId <= 0) {
                handleError(request, response, "ID khách hàng không hợp lệ để cập nhật.");
                return;
            }

            Optional<Customer> customerOpt = customerDAO.findById(customerId);
            if (!customerOpt.isPresent()) {
                handleError(request, response, "Không tìm thấy khách hàng để cập nhật.");
                return;
            }

            Customer customer = customerOpt.get();
            customer.setFullName(request.getParameter("fullName"));
            customer.setEmail(request.getParameter("email"));
            customer.setPhoneNumber(request.getParameter("phoneNumber"));
            customer.setGender(request.getParameter("gender"));
            customer.setAddress(request.getParameter("address"));

            String birthdayStr = request.getParameter("birthday");
            if (birthdayStr != null && !birthdayStr.isEmpty()) {
                customer.setBirthday(Date.valueOf(birthdayStr));
            } else {
                customer.setBirthday(null);
            }

            customer.setLoyaltyPoints(getIntParameter(request, "loyaltyPoints", customer.getLoyaltyPoints()));
            customer.setIsActive(request.getParameter("active") != null);
            customer.setIsVerified(request.getParameter("verified") != null);

            customerDAO.update(customer);

            request.setAttribute("toastMessage", "Customer updated successfully!");
            request.setAttribute("toastType", "success");
            // Lấy lại các tham số tìm kiếm
            String page = request.getParameter("page");
            String pageSize = request.getParameter("pageSize");
            String searchValue = request.getParameter("searchValue");
            String status = request.getParameter("status");
            StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/customer/list");
            List<String> params = new ArrayList<>();
            if (page != null && !page.isEmpty()) params.add("page=" + page);
            if (pageSize != null && !pageSize.isEmpty()) params.add("pageSize=" + pageSize);
            if (searchValue != null && !searchValue.isEmpty()) params.add("searchValue=" + java.net.URLEncoder.encode(searchValue, "UTF-8"));
            if (status != null && !status.isEmpty()) params.add("status=" + status);
            if (!params.isEmpty()) redirectUrl.append("?" + String.join("&", params));
            response.sendRedirect(redirectUrl.toString());

        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid number format while updating customer.", e);
            handleError(request, response, "Lỗi định dạng số. Vui lòng kiểm tra lại điểm thân thiết.");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating customer", e);
            handleError(request, response, "Lỗi khi cập nhật thông tin khách hàng: " + e.getMessage());
        }
    }

    /**
     * Handle deactivate customer
     */
    private void handleDeactivateCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String redirectUrl = buildListRedirectUrl(request);

        try {
            int customerId = getIntParameter(request, "id", 0);
            if (customerId <= 0) {
                request.getSession().setAttribute("errorMessage", "Invalid customer ID provided.");
                response.sendRedirect(redirectUrl);
                return;
            }

            if (customerDAO.deactivateCustomer(customerId)) {
                request.getSession().setAttribute("successMessage", "Customer has been deactivated successfully.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to deactivate the customer.");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error deactivating customer", e);
            request.getSession().setAttribute("errorMessage", "Error deactivating customer: " + e.getMessage());
        }

        response.sendRedirect(redirectUrl);
    }

    /**
     * Handle activate customer
     */
    private void handleActivateCustomer(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String redirectUrl = buildListRedirectUrl(request);

        try {
            int customerId = getIntParameter(request, "id", 0);
            if (customerId <= 0) {
                request.getSession().setAttribute("errorMessage", "Invalid customer ID provided.");
                response.sendRedirect(redirectUrl);
                return;
            }

            if (customerDAO.activateCustomer(customerId)) {
                request.getSession().setAttribute("successMessage", "Customer has been activated successfully.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to activate the customer.");
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error activating customer", e);
            request.getSession().setAttribute("errorMessage", "Error activating customer: " + e.getMessage());
        }

        response.sendRedirect(redirectUrl);
    }

    // UTILITY AND OTHER METHODS
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("error", errorMessage);
        request.getRequestDispatcher("/WEB-INF/view/common/error.jsp").forward(request, response);
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

    private void handleApiRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 5) { // "/api/" length is 5
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing API endpoint");
            return;
        }

        String apiAction = pathInfo.substring(5); // Remove "/api/"

        switch (apiAction) {
            case "refresh":
                handleRefreshCustomer(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Unknown API endpoint");
                break;
        }
    }

    private void handleRefreshCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementation remains the same...
    }

    /**
     * Builds the redirect URL to the customer list, preserving pagination and
     * filters.
     */
    private String buildListRedirectUrl(HttpServletRequest request) {
        String page = request.getParameter("page");
        String search = request.getParameter("search");
        String status = request.getParameter("status");

        List<String> params = new ArrayList<>();
        if (page != null && !page.isEmpty()) {
            params.add("page=" + page);
        }
        if (search != null && !search.isEmpty()) {
            try {
                // Quan trọng: Mã hóa giá trị tìm kiếm để tránh lỗi URL
                params.add("search=" + URLEncoder.encode(search, StandardCharsets.UTF_8.toString()));
            } catch (Exception e) {
                logger.warning("Could not encode search parameter: " + e.getMessage());
            }
        }
        if (status != null && !status.isEmpty()) {
            params.add("status=" + status);
        }

        String queryString = String.join("&", params);
        if (queryString.isEmpty()) {
            return request.getContextPath() + "/customer/list";
        } else {
            return request.getContextPath() + "/customer/list?" + queryString;
        }
    }

    private String escapeJson(String str) {
        if (str == null) {
            return "";
        }
        return str.replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");
    }

}
