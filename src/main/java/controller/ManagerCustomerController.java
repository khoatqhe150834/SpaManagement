package controller;

import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;

/**
 * ManagerCustomerController - Handles customer information management for MANAGER role
 * Focus: Personal information, profile, loyalty points, notes
 * URL Pattern: /manager/customer/*
 */
@WebServlet(urlPatterns = { "/manager/customer/*" })
public class ManagerCustomerController extends HttpServlet {

    private CustomerDAO customerDAO;
    private static final Logger logger = Logger.getLogger(ManagerCustomerController.class.getName());
    private static final int DEFAULT_PAGE_SIZE = 10;

    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAO();
        logger.info("ManagerCustomerController initialized successfully");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        String queryString = request.getQueryString();
        logger.info("ManagerCustomerController GET request - PathInfo: " + pathInfo + ", QueryString: " + queryString);

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
                    handleListCustomerInfo(request, response);
                    break;
                case "view":
                case "profile":
                    handleViewCustomerProfile(request, response);
                    break;
                case "create":
                    handleShowCreateForm(request, response);
                    break;
                case "edit":
                case "update":
                    handleShowEditForm(request, response);
                    break;
                case "loyalty":
                    handleLoyaltyManagement(request, response);
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
            logger.log(Level.SEVERE, "Error in ManagerCustomerController GET", e);
            handleError(request, response, "Đã xảy ra lỗi: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();
        String queryString = request.getQueryString();
        logger.info("ManagerCustomerController POST request - PathInfo: " + pathInfo + ", QueryString: " + queryString);
        String action = "";

        if (pathInfo != null && pathInfo.startsWith("/")) {
            String[] pathParts = pathInfo.split("/");
            if (pathParts.length > 1) {
                action = pathParts[1];
            }
        }

        try {
            switch (action.toLowerCase()) {
                case "create":
                    handleProcessCreateForm(request, response);
                    break;
                case "update":
                    handleUpdateCustomerInfo(request, response);
                    break;
                case "loyalty":
                    handleUpdateLoyaltyPoints(request, response);
                    break;
                default:
                    logger.warning("Invalid POST action: " + action);
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hành động không hợp lệ: " + action);
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in ManagerCustomerController POST", e);
            handleError(request, response, "Đã xảy ra lỗi trong quá trình xử lý POST: " + e.getMessage());
        }
    }

    /**
     * Handle list customer information with focus on personal details
     */
    private void handleListCustomerInfo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int page = getIntParameter(request, "page", 1);
            int pageSize = getIntParameter(request, "pageSize", DEFAULT_PAGE_SIZE);

            String sortBy = Optional.ofNullable(request.getParameter("sortBy")).orElse("fullName");
            String sortOrder = Optional.ofNullable(request.getParameter("sortOrder")).orElse("asc");
            String searchValue = request.getParameter("searchValue");
            
            // Clean up parameters
            if (searchValue != null && searchValue.trim().isEmpty()) {
                searchValue = null;
            }

            // Map frontend sortBy values to database column names
            if ("fullName".equals(sortBy)) {
                sortBy = "fullname";
            } else if ("loyaltyPoints".equals(sortBy)) {
                sortBy = "loyaltypoints";
            } else if ("createdAt".equals(sortBy)) {
                sortBy = "createdat";
            }
            
            // Store original values for JSP
            String originalSortBy = request.getParameter("sortBy");
            if (originalSortBy == null) {
                originalSortBy = "fullName";
            }

            // Validate parameters
            if (page < 1) page = 1;
            if (pageSize < 1) pageSize = DEFAULT_PAGE_SIZE;
            
            // Handle "show all" case
            boolean showAll = (pageSize == 9999);
            int actualPageSize = showAll ? Integer.MAX_VALUE : pageSize;

            // Get data from database
            List<Customer> customers = customerDAO.getPaginatedCustomers(page, actualPageSize, searchValue, null, null, sortBy, sortOrder);
            int totalCustomers = customerDAO.getTotalCustomerCount(searchValue, null, null);

            // Calculate pagination info
            int totalPages = 1;
            int startItem = 0;
            int endItem = 0;
            
            if (totalCustomers > 0) {
                if (showAll) {
                    totalPages = 1;
                    page = 1;
                    startItem = 1;
                    endItem = totalCustomers;
                } else {
                    totalPages = (int) Math.ceil((double) totalCustomers / pageSize);
                    if (totalPages < 1) totalPages = 1;
                    if (page > totalPages) page = totalPages;
                    
                    startItem = ((page - 1) * pageSize) + 1;
                    endItem = Math.min(page * pageSize, totalCustomers);
                }
            }

            // Set attributes for JSP
            request.setAttribute("customers", customers);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("sortBy", originalSortBy); // Use original value for JSP
            request.setAttribute("sortOrder", sortOrder);
            request.setAttribute("searchValue", request.getParameter("searchValue")); // Use original value
            request.setAttribute("startItem", startItem);
            request.setAttribute("endItem", endItem);
            request.setAttribute("showAll", showAll);

            request.getRequestDispatcher("/WEB-INF/view/manager/Customer/customer_info_list.jsp").forward(request,
                    response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading customer information list - Page: " + 
                request.getParameter("page") + ", PageSize: " + request.getParameter("pageSize") + 
                ", SortBy: " + request.getParameter("sortBy"), e);
            handleError(request, response, "Lỗi khi tải danh sách thông tin khách hàng: " + e.getMessage());
        }
    }

    /**
     * Handle view customer profile with detailed information
     */
    private void handleViewCustomerProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            logger.info("Profile request - ID parameter: " + idParam);
            
            int customerId = getIntParameter(request, "id", 0);
            logger.info("Profile request - Parsed ID: " + customerId);
            
            if (customerId <= 0) {
                logger.warning("Profile request - Invalid ID: " + customerId);
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID khách hàng không hợp lệ. ID nhận được: " + idParam);
                return;
            }

            Optional<Customer> customerOpt = customerDAO.findById(customerId);
            if (customerOpt.isPresent()) {
                Customer customer = customerOpt.get();
                // Add additional profile information
                request.setAttribute("customer", customer);
                
                // Get customer statistics
                // Note: These would require additional DAO methods
                request.setAttribute("totalBookings", 0); // placeholder
                request.setAttribute("totalSpent", 0.0); // placeholder
                request.setAttribute("lastVisit", null); // placeholder

                request.getRequestDispatcher("/WEB-INF/view/manager/Customer/customer_profile.jsp").forward(request,
                        response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy khách hàng.");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error viewing customer profile", e);
            handleError(request, response, "Lỗi khi xem hồ sơ khách hàng: " + e.getMessage());
        }
    }

    /**
     * Shows the form for creating new customer information
     */
    private void handleShowCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/view/manager/Customer/customer_info_add.jsp").forward(request, response);
    }

    /**
     * Processes the submission of the new customer information form
     */
    private void handleProcessCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String formJspPath = "/WEB-INF/view/manager/Customer/customer_info_add.jsp";

        String name = request.getParameter("fullName");
        String phone = request.getParameter("phoneNumber");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");
        String birthdayStr = request.getParameter("birthday");
        String notes = request.getParameter("notes");

        Map<String, String> errors = new HashMap<>();

        // Validation for customer information (no email/password for manager)
        final String trimmedName = (name != null) ? name.trim() : "";
        final String namePattern = "^[\\p{L}\\s]+$";
        if (trimmedName.isEmpty()) {
            errors.put("fullName", "Tên là bắt buộc.");
        } else if (trimmedName.length() < 2 || trimmedName.length() > 100) {
            errors.put("fullName", "Tên phải có độ dài từ 2 đến 100 ký tự.");
        } else if (trimmedName.contains("  ")) {
            errors.put("fullName", "Tên không được có nhiều khoảng trắng liền kề.");
        } else if (!trimmedName.contains(" ")) {
            errors.put("fullName", "Tên đầy đủ cần có ít nhất hai từ.");
        } else if (!trimmedName.matches(namePattern)) {
            errors.put("fullName", "Tên chỉ được chứa chữ cái và khoảng trắng.");
        }

        if (phone != null && !phone.trim().isEmpty()) {
            if (!phone.matches("^0\\d{9}$")) {
                errors.put("phoneNumber", "Số điện thoại phải có 10 chữ số và bắt đầu bằng 0.");
            } else {
                try {
                    List<Customer> phoneList = customerDAO.findByPhoneContain(phone.trim());
                    if (!phoneList.isEmpty()) {
                        errors.put("phoneNumber", "Số điện thoại này đã được đăng ký.");
                    }
                } catch (Exception e) {
                    logger.log(Level.SEVERE, "Database error checking phone number uniqueness", e);
                    errors.put("phoneNumber", "Không thể xác minh số điện thoại. Vui lòng thử lại.");
                }
            }
        }

        Date birthday = null;
        if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
            try {
                birthday = Date.valueOf(birthdayStr);
                if (birthday.after(new java.util.Date())) {
                    errors.put("birthday", "Ngày sinh không thể ở trong tương lai.");
                }
            } catch (IllegalArgumentException e) {
                errors.put("birthday", "Định dạng ngày không hợp lệ.");
            }
        }

        if (notes != null && notes.length() > 500) {
            errors.put("notes", "Ghi chú tối đa 500 ký tự.");
        }

        if (address == null || address.trim().isEmpty()) {
            errors.put("address", "Địa chỉ là bắt buộc.");
        }

        Customer customerInput = new Customer();
        customerInput.setFullName(name);
        customerInput.setPhoneNumber(phone);
        customerInput.setGender(gender);
        customerInput.setAddress(address);
        customerInput.setNotes(notes);
        if (birthday != null) {
            customerInput.setBirthday(birthday);
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("customerInput", customerInput);
            request.getRequestDispatcher(formJspPath).forward(request, response);
            return;
        }

        try {
            Customer newCustomer = new Customer();
            newCustomer.setFullName(name.trim());
            newCustomer.setPhoneNumber(phone != null ? phone.trim() : null);
            newCustomer.setGender(gender);
            newCustomer.setAddress(address != null ? address.trim() : null);
            newCustomer.setBirthday(birthday);
            newCustomer.setIsActive(true);
            newCustomer.setLoyaltyPoints(0);
            newCustomer.setNotes(notes);
            // Note: Manager cannot set email/password, these would be set by admin or during registration

            customerDAO.save(newCustomer);

            request.getSession().setAttribute("successMessage", "Đã thêm thông tin khách hàng mới thành công!");
            response.sendRedirect(request.getContextPath() + "/manager/customer/list");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error saving new customer information", e);
            String userErrorMessage = "Đã có lỗi xảy ra khi lưu thông tin khách hàng. Chi tiết lỗi: " + e.getMessage();
            request.setAttribute("error", userErrorMessage);
            request.setAttribute("customerInput", customerInput);
            request.getRequestDispatcher(formJspPath).forward(request, response);
        }
    }

    /**
     * Handle show edit form for customer information
     */
    private void handleShowEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            logger.info("Edit form request - ID parameter: " + idParam);
            
            int customerId = getIntParameter(request, "id", 0);
            logger.info("Edit form request - Parsed ID: " + customerId);
            
            if (customerId <= 0) {
                logger.warning("Edit form request - Invalid ID: " + customerId);
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID khách hàng không hợp lệ. ID nhận được: " + idParam);
                return;
            }

            Optional<Customer> customerOpt = customerDAO.findById(customerId);
            if (customerOpt.isPresent()) {
                request.setAttribute("customer", customerOpt.get());
                request.getRequestDispatcher("/WEB-INF/view/manager/Customer/customer_edit.jsp").forward(request,
                        response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy khách hàng.");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error showing edit form", e);
            handleError(request, response, "Lỗi khi tải thông tin khách hàng để chỉnh sửa: " + e.getMessage());
        }
    }

    /**
     * Handle update customer information
     */
    private void handleUpdateCustomerInfo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String customerIdParam = request.getParameter("customerId");
            logger.info("Update request - CustomerID parameter: " + customerIdParam);
            
            int customerId = getIntParameter(request, "customerId", 0);
            logger.info("Update request - Parsed CustomerID: " + customerId);
            
            if (customerId <= 0) {
                logger.warning("Update request - Invalid CustomerID: " + customerId);
                handleError(request, response, "ID khách hàng không hợp lệ để cập nhật. ID nhận được: " + customerIdParam);
                return;
            }

            Optional<Customer> customerOpt = customerDAO.findById(customerId);
            if (!customerOpt.isPresent()) {
                handleError(request, response, "Không tìm thấy khách hàng để cập nhật.");
                return;
            }

            Customer customer = customerOpt.get();
            String name = request.getParameter("fullName");
            String phone = request.getParameter("phoneNumber");
            String gender = request.getParameter("gender");
            String address = request.getParameter("address");
            String birthdayStr = request.getParameter("birthday");
            String notes = request.getParameter("notes");
            String loyaltyPointsStr = request.getParameter("loyaltyPoints");

            // DEBUG LOGGING
            logger.info("=== UPDATE CUSTOMER DEBUG ===");
            logger.info("Customer ID: " + customerId);
            logger.info("Full Name: " + name);
            logger.info("Phone: " + phone);
            logger.info("Gender RECEIVED: '" + gender + "' (Length: " + (gender != null ? gender.length() : 0) + ")");
            logger.info("Gender CURRENT in DB: '" + customer.getGender() + "'");
            logger.info("Address: " + address);
            logger.info("Birthday: " + birthdayStr);
            logger.info("Notes: " + notes);
            logger.info("Loyalty Points: " + loyaltyPointsStr);
            logger.info("=== END DEBUG ===");

            Map<String, String> errors = new HashMap<>();

            // Validation (similar to create but for updates)
            final String trimmedName = (name != null) ? name.trim() : "";
            final String namePattern = "^[\\p{L}\\s]+$";
            
            if (trimmedName.isEmpty()) {
                errors.put("fullName", "Tên là bắt buộc.");
            } else if (trimmedName.length() < 2 || trimmedName.length() > 100) {
                errors.put("fullName", "Tên phải có độ dài từ 2 đến 100 ký tự.");
            } else if (trimmedName.contains("  ")) {
                errors.put("fullName", "Tên không được có nhiều khoảng trắng liền kề.");
            } else if (!trimmedName.contains(" ")) {
                errors.put("fullName", "Tên đầy đủ cần có ít nhất hai từ.");
            } else if (!trimmedName.matches(namePattern)) {
                errors.put("fullName", "Tên chỉ được chứa chữ cái và khoảng trắng.");
            }

            if (phone != null && !phone.trim().isEmpty()) {
                if (!phone.matches("^0\\d{9}$")) {
                    errors.put("phoneNumber", "Số điện thoại phải có 10 chữ số và bắt đầu bằng 0.");
                } else {
                    try {
                        List<Customer> phoneList = customerDAO.findByPhoneContain(phone.trim());
                        if (!phoneList.isEmpty()
                                && (phoneList.size() > 1 || !phoneList.get(0).getCustomerId().equals(customerId))) {
                            errors.put("phoneNumber", "Số điện thoại này đã được đăng ký.");
                        }
                    } catch (Exception e) {
                        logger.log(Level.SEVERE, "Database error checking phone number uniqueness", e);
                        errors.put("phoneNumber", "Không thể xác minh số điện thoại. Vui lòng thử lại.");
                    }
                }
            }

            Date birthday = null;
            if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
                try {
                    birthday = Date.valueOf(birthdayStr);
                    if (birthday.after(new java.util.Date())) {
                        errors.put("birthday", "Ngày sinh không thể vượt quá ngày hiện tại.");
                    }
                } catch (IllegalArgumentException e) {
                    errors.put("birthday", "Định dạng ngày không hợp lệ.");
                }
            }

            if (notes != null && notes.length() > 500) {
                errors.put("notes", "Ghi chú tối đa 500 ký tự.");
            }

            Integer loyaltyPoints = null;
            if (loyaltyPointsStr != null && !loyaltyPointsStr.isEmpty()) {
                try {
                    loyaltyPoints = Integer.parseInt(loyaltyPointsStr);
                    if (loyaltyPoints < 0) {
                        errors.put("loyaltyPoints", "Điểm thân thiết phải là số không âm.");
                    }
                } catch (NumberFormatException e) {
                    errors.put("loyaltyPoints", "Điểm thân thiết phải là một con số.");
                }
            }

            if (!errors.isEmpty()) {
                customer.setFullName(name);
                customer.setPhoneNumber(phone);
                customer.setGender(gender);
                customer.setAddress(address);
                customer.setBirthday(birthday);
                customer.setNotes(notes);
                if (loyaltyPoints != null) {
                    customer.setLoyaltyPoints(loyaltyPoints);
                }
                request.setAttribute("errors", errors);
                request.setAttribute("customer", customer);
                request.getRequestDispatcher("/WEB-INF/view/manager/Customer/customer_edit.jsp").forward(request,
                        response);
                return;
            }

            // Update customer information (no email/password updates for manager)
            customer.setFullName(name);
            customer.setPhoneNumber(phone);
            customer.setGender(gender);
            customer.setAddress(address);
            customer.setBirthday(birthday);
            customer.setNotes(notes);
            if (loyaltyPoints != null) {
                customer.setLoyaltyPoints(loyaltyPoints);
            }

            customerDAO.update(customer);
            request.getSession().setAttribute("successMessage", "Cập nhật thông tin khách hàng thành công!");

            // Redirect back to list with original pagination parameters
            String redirectUrl = request.getContextPath() + "/manager/customer/list";
            String page = request.getParameter("page");
            String pageSize = request.getParameter("pageSize");
            String searchValue = request.getParameter("searchValue");
            String sortBy = request.getParameter("sortBy");
            String sortOrder = request.getParameter("sortOrder");
            
            StringBuilder urlBuilder = new StringBuilder(redirectUrl);
            boolean hasParams = false;
            
            if (page != null && !page.isEmpty()) {
                urlBuilder.append("?page=").append(page);
                hasParams = true;
            }
            if (pageSize != null && !pageSize.isEmpty()) {
                urlBuilder.append(hasParams ? "&" : "?").append("pageSize=").append(pageSize);
                hasParams = true;
            }
            if (searchValue != null && !searchValue.isEmpty()) {
                urlBuilder.append(hasParams ? "&" : "?").append("searchValue=").append(searchValue);
                hasParams = true;
            }
            if (sortBy != null && !sortBy.isEmpty()) {
                urlBuilder.append(hasParams ? "&" : "?").append("sortBy=").append(sortBy);
                hasParams = true;
            }
            if (sortOrder != null && !sortOrder.isEmpty()) {
                urlBuilder.append(hasParams ? "&" : "?").append("sortOrder=").append(sortOrder);
            }
            
            response.sendRedirect(urlBuilder.toString());

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating customer information", e);
            handleError(request, response, "Lỗi khi cập nhật thông tin khách hàng: " + e.getMessage());
        }
    }

    /**
     * Handle loyalty points management
     */
    private void handleLoyaltyManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Customer> customersWithPoints = customerDAO.getCustomersWithLoyaltyPoints();
            request.setAttribute("customers", customersWithPoints);

            request.getRequestDispatcher("/WEB-INF/view/manager/Customer/loyalty_management.jsp").forward(request,
                    response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading loyalty management", e);
            handleError(request, response, "Lỗi khi tải trang quản lý điểm thưởng: " + e.getMessage());
        }
    }

    /**
     * Handle update loyalty points
     */
    private void handleUpdateLoyaltyPoints(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int customerId = getIntParameter(request, "customerId", 0);
            int points = getIntParameter(request, "points", 0);
            String action = request.getParameter("action"); // "add" or "set"

            if (customerId <= 0) {
                request.getSession().setAttribute("errorMessage", "ID khách hàng không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/manager/customer/loyalty");
                return;
            }

            Optional<Customer> customerOpt = customerDAO.findById(customerId);
            if (!customerOpt.isPresent()) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy khách hàng.");
                response.sendRedirect(request.getContextPath() + "/manager/customer/loyalty");
                return;
            }

            Customer customer = customerOpt.get();
            int currentPoints = customer.getLoyaltyPoints() != null ? customer.getLoyaltyPoints() : 0;

            if ("add".equals(action)) {
                customer.setLoyaltyPoints(currentPoints + points);
            } else {
                customer.setLoyaltyPoints(points);
            }

            customerDAO.update(customer);
            request.getSession().setAttribute("successMessage", "Cập nhật điểm thưởng thành công!");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating loyalty points", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi cập nhật điểm thưởng: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/manager/customer/loyalty");
    }

    /**
     * Handle search customers
     */
    private void handleSearchCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Delegate to list with search parameters
        handleListCustomerInfo(request, response);
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
} 