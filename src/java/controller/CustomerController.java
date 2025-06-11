package controller;

import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Customer;
import java.util.Optional;

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
            // Handle root path or null path - show customer list
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
                handleListCustomers(request, response);
                return;
            }

            // Parse path to get action and parameters
            String[] pathParts = pathInfo.split("/");
            if (pathParts.length < 2) {
                handleListCustomers(request, response);
                return;
            }

            String action = pathParts[1].toLowerCase();

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
                    // Search is now handled in list method
                    handleListCustomers(request, response);
                    break;
                case "api":
                    handleApiRequest(request, response);
                    break;
                default:
                    logger.warning("Unknown action: " + action);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Unknown action: " + action);
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

        String action = request.getParameter("action");

        try {
            if (action == null || action.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action parameter");
                return;
            }

            switch (action.toLowerCase()) {
                case "create":
//                    handleCreateCustomer(request, response);
                    break;
                case "update":
//                    handleUpdateCustomer(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action: " + action);
                    break;
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in CustomerController POST", e);
            handleError(request, response, "An error occurred: " + e.getMessage());
        }
    }

    /**
     * Handle list customers with pagination and filtering
     */
    private void handleListCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get pagination parameters
            int page = getIntParameter(request, "page", 1);
            int pageSize = getIntParameter(request, "pageSize", DEFAULT_PAGE_SIZE);
            String status = request.getParameter("status");

            // Get sorting parameters
            String sortBy = request.getParameter("sortBy");
            String sortOrder = request.getParameter("sortOrder");

            // Get search parameters
            String searchType = request.getParameter("searchType");
            String searchValue = request.getParameter("search"); // Changed from "searchValue" to "search"
            if (searchValue == null) {
                searchValue = request.getParameter("searchValue"); // Fallback for backward compatibility
            }

            // Validate pagination parameters
            if (page < 1) {
                page = 1;
            }
            if (pageSize < 1) {
                pageSize = DEFAULT_PAGE_SIZE;
            }
            if (pageSize > 999999) {
                pageSize = 999999; // Allow "all" option
            }
            List<Customer> customers;
            int totalCustomers;

            // Get all customers first, then filter
            customers = customerDAO.findAll(1, Integer.MAX_VALUE);
            totalCustomers = customers.size();

            // Apply search filter if provided
            if (searchValue != null && !searchValue.trim().isEmpty()) {
                String searchTerm = searchValue.trim().toLowerCase();
                customers = customers.stream()
                        .filter(c
                                -> (c.getFullName() != null && c.getFullName().toLowerCase().contains(searchTerm))
                        || (c.getEmail() != null && c.getEmail().toLowerCase().contains(searchTerm))
                        || (c.getPhoneNumber() != null && c.getPhoneNumber().contains(searchTerm))
                        || String.valueOf(c.getCustomerId()).contains(searchTerm)
                        )
                        .collect(java.util.stream.Collectors.toList());
            }

            // Apply status filter if provided
            if (status != null && !status.trim().isEmpty()) {
                boolean isActive = "active".equalsIgnoreCase(status);
                customers = customers.stream()
                        .filter(c -> c.isActive() == isActive)
                        .collect(java.util.stream.Collectors.toList());
            }

            // Update total count after filtering
            totalCustomers = customers.size();

            // Apply sorting
            if (sortBy != null && "id".equals(sortBy) && sortOrder != null) {
                if ("asc".equals(sortOrder)) {
                    customers.sort(java.util.Comparator.comparing(Customer::getCustomerId));
                } else if ("desc".equals(sortOrder)) {
                    customers.sort(java.util.Comparator.comparing(Customer::getCustomerId).reversed());
                }
            }

            // Apply pagination to results
            int totalPages = (int) Math.ceil((double) totalCustomers / pageSize);
            if (totalPages < 1) {
                totalPages = 1;
            }
            if (page > totalPages) {
                page = totalPages;
            }

            int startIndex = (page - 1) * pageSize;
            int endIndex = Math.min(startIndex + pageSize, customers.size());
            if (startIndex < customers.size()) {
                customers = customers.subList(startIndex, endIndex);
            } else {
                customers = new java.util.ArrayList<>();
            }

            // Set request attributes
            request.setAttribute("customers", customers);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalpages", totalPages);
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("status", status);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);
            request.setAttribute("searchType", searchType);
            request.setAttribute("searchValue", searchValue);

            logger.info(String.format("Customer list loaded - Page: %d, Size: %d, Total: %d, Found: %d, Sort: %s %s",
                    page, pageSize, totalCustomers, customers.size(), sortBy, sortOrder));

            // Forward to JSP
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/customer_list.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading customer list", e);
            handleError(request, response, "Error loading customer list: " + e.getMessage());
        }
    }

    /**
     * Handle search customers
     */
    private void handleSearchCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String searchType = request.getParameter("searchType");
            String searchValue = request.getParameter("searchValue");
            int page = getIntParameter(request, "page", 1);
            int pageSize = getIntParameter(request, "pageSize", DEFAULT_PAGE_SIZE);

            List<Customer> customers;
            int totalCustomers;

            if (searchValue == null || searchValue.trim().isEmpty()) {
                // No search value, show all customers
                customers = customerDAO.findAll(page, pageSize);
                totalCustomers = customerDAO.getTotalCustomers();
            } else {
                // Perform search based on type
                switch (searchType != null ? searchType.toLowerCase() : "name") {
                    case "email":
                        customers = customerDAO.findByEmailContain(searchValue.trim());
                        break;
                    case "phone":
                        customers = customerDAO.findByPhoneContain(searchValue.trim());
                        break;
                    case "name":
                    default:
                        customers = customerDAO.findByNameContain(searchValue.trim());
                        break;
                }

                totalCustomers = customers.size();

                // Apply pagination to search results
                int startIndex = (page - 1) * pageSize;
                int endIndex = Math.min(startIndex + pageSize, customers.size());
                if (startIndex < customers.size()) {
                    customers = customers.subList(startIndex, endIndex);
                } else {
                    customers.clear();
                }
            }

            // Calculate pagination
            int totalPages = (int) Math.ceil((double) totalCustomers / pageSize);
            if (totalPages < 1) {
                totalPages = 1;
            }

            // Set request attributes
            request.setAttribute("customers", customers);
            request.setAttribute("searchType", searchType);
            request.setAttribute("searchValue", searchValue);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalpages", totalPages);
            request.setAttribute("totalCustomers", totalCustomers);

            logger.info(String.format("Customer search completed - Type: %s, Value: %s, Found: %d",
                    searchType, searchValue, totalCustomers));

            // Forward to JSP
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/customer_list.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error searching customers", e);
            handleError(request, response, "Error searching customers: " + e.getMessage());
        }
    }

    /**
     * Handle view single customer
     */
    private void handleViewCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
       

        try {
            String customerIdStr = request.getParameter("id");

            int customerId = Integer.parseInt(customerIdStr);
            
            request.setAttribute("customerId", customerId);
//            
            if (customerId <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid customer ID");
                return;
            }
            
//            request.setAttribute("here", "Doan nay chua loi");
           
            

            Optional<Customer> customerOpt = customerDAO.findById(customerId);
            
            
            if (customerOpt.isPresent()) {
                
                Customer customer =  customerOpt.get();

                request.setAttribute("customer", customer);

//                  request.setAttribute("here", "Doan nay chua loi");
                
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/customer_details.jsp")
                                    .forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Customer not found");
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error viewing customer", e);
            handleError(request, response, "Error viewing customer: " + e.getMessage());
        }
    }

    /**
     * Handle show create form
     */
    private void handleShowCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/view/customer/form.jsp")
                .forward(request, response);
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
                request.getRequestDispatcher("/WEB-INF/view/customer/form.jsp")
                        .forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Customer not found");
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error showing edit form", e);
            handleError(request, response, "Error loading customer for edit: " + e.getMessage());
        }
    }

    /**
     * Handle create customer
     */
//    private void handleCreateCustomer(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        
//        try {
//            // Validate required fields
//            String name = getStringParameter(request, "name");
//            String email = getStringParameter(request, "email");
//            String password = getStringParameter(request, "password");
//            
//            if (name == null || email == null || password == null) {
//                throw new IllegalArgumentException("Name, email, and password are required");
//            }
//            
//            // Validate email format
//            if (!isValidEmail(email)) {
//                throw new IllegalArgumentException("Invalid email format");
//            }
//            
//            // Get optional fields
//            String phone = request.getParameter("phone");
//            String gender = request.getParameter("gender");
//            String birthdayStr = request.getParameter("birthday");
//            String address = request.getParameter("address");
//            boolean isActive = "on".equals(request.getParameter("isActive"));
//            
//            // Validate phone if provided
//            if (phone != null && !phone.trim().isEmpty() && !isValidPhone(phone)) {
//                throw new IllegalArgumentException("Invalid phone number format");
//            }
//            
//            // Create customer object
//            Customer customer = new Customer();
//            customer.setFullName(name);
//            customer.setEmail(email.toLowerCase());
//            customer.setHashPassword(password); // Will be hashed in DAO
//            customer.setPhoneNumber(phone);
//            customer.setGender(gender);
//            customer.setAddress(address);
//            customer.setIsActive(isActive);
//            customer.setRoleId(1); // Default customer role
//            customer.setLoyaltyPoints(0);
//            customer.setIsVerified(false);
//            
//            // Parse birthday if provided
//            if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
//                try {
//                    customer.setBirthday(Date.valueOf(birthdayStr));
//                } catch (IllegalArgumentException e) {
//                    throw new IllegalArgumentException("Invalid birthday format");
//                }
//            }
//            
//            // Save customer
//            customerDAO.save(customer);
//            
//            logger.info("Customer created successfully: " + customer.getCustomerId());
//            
//            // Return success response for AJAX
//            response.setStatus(200);
//            response.getWriter().write("Customer created successfully");
//            
//        } catch (IllegalArgumentException e) {
//            logger.warning("Validation error creating customer: " + e.getMessage());
//            request.setAttribute("error", e.getMessage());
//            request.getRequestDispatcher("/WEB-INF/view/customer/form.jsp")
//                    .forward(request, response);
//        } catch (Exception e) {
//            logger.log(Level.SEVERE, "Error creating customer", e);
//            request.setAttribute("error", "Error creating customer: " + e.getMessage());
//            request.getRequestDispatcher("/WEB-INF/view/customer/form.jsp")
//                    .forward(request, response);
//        }
//    }
    /**
     * Handle update customer
     */
//    private void handleUpdateCustomer(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        
//        try {
//            // Get customer ID
//            int customerId = getIntParameter(request, "id", 0);
//            if (customerId <= 0) {
//                throw new IllegalArgumentException("Invalid customer ID");
//            }
//            
//            // Check if customer exists
//            Optional<Customer> customerOpt = customerDAO.findById(customerId);
//            if (!customerOpt.isPresent()) {
//                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Customer not found");
//                return;
//            }
//            
//            Customer customer = customerOpt.get();
//            
//            // Validate required fields
//            String name = getStringParameter(request, "name");
//            String email = getStringParameter(request, "email");
//            
//            if (name == null || email == null) {
//                throw new IllegalArgumentException("Name and email are required");
//            }
//            
//            // Validate email format
//            if (!isValidEmail(email)) {
//                throw new IllegalArgumentException("Invalid email format");
//            }
//            
//            // Get optional fields
//            String phone = request.getParameter("phone");
//            String gender = request.getParameter("gender");
//            String birthdayStr = request.getParameter("birthday");
//            String address = request.getParameter("address");
//            String password = request.getParameter("password");
//            boolean isActive = "on".equals(request.getParameter("isActive"));
//            int loyaltyPoints = getIntParameter(request, "loyaltyPoints", customer.getLoyaltyPoints());
//            
//            // Validate phone if provided
//            if (phone != null && !phone.trim().isEmpty() && !isValidPhone(phone)) {
//                throw new IllegalArgumentException("Invalid phone number format");
//            }
//            
//            // Update customer fields
//            customer.setFullName(name);
//            customer.setEmail(email.toLowerCase());
//            customer.setPhoneNumber(phone);
//            customer.setGender(gender);
//            customer.setAddress(address);
//            customer.setIsActive(isActive);
//            customer.setLoyaltyPoints(loyaltyPoints);
//            
//            // Update password if provided
//            if (password != null && !password.trim().isEmpty()) {
//                customerDAO.updatePassword(customerId, password);
//            }
//            
//            // Parse birthday if provided
//            if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
//                try {
//                    customer.setBirthday(Date.valueOf(birthdayStr));
//                } catch (IllegalArgumentException e) {
//                    throw new IllegalArgumentException("Invalid birthday format");
//                }
//            }
//            
//            // Update customer
//            customerDAO.update(customer);
//            
//            logger.info("Customer updated successfully: " + customerId);
//            
//            // Return success response for AJAX
//            response.setStatus(200);
//            response.getWriter().write("Customer updated successfully");
//            
//        } catch (IllegalArgumentException e) {
//            logger.warning("Validation error updating customer: " + e.getMessage());
//            request.setAttribute("error", e.getMessage());
//            request.getRequestDispatcher("/WEB-INF/view/customer/form.jsp")
//                    .forward(request, response);
//        } catch (Exception e) {
//            logger.log(Level.SEVERE, "Error updating customer", e);
//            request.setAttribute("error", "Error updating customer: " + e.getMessage());
//            request.getRequestDispatcher("/WEB-INF/view/customer/form.jsp")
//                    .forward(request, response);
//        }
//    }
    /**
     * Handle delete customer
     */
    private void handleDeactivateCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String customerIdStr = request.getParameter("id");

            int customerId = Integer.parseInt(customerIdStr);
//            
//            request.setAttribute("customerId", customerId);
//            request.getRequestDispatcher("/test.jsp").forward(request, response);

            if (customerId <= 0) {
                handleError(request, response, "Invalid customer ID provided.");
                return;
            }

            boolean success = customerDAO.deactivateCustomer(customerId);

            if (success) {
                logger.info("Customer deactivated successfully: " + customerId);
                request.getSession().setAttribute("successMessage", "Customer has been deactivated successfully.");
            } else {
                logger.warning("Failed to deactivate customer: " + customerId);
                request.getSession().setAttribute("errorMessage", "Failed to deactivate the customer.");
            }

            response.sendRedirect(request.getContextPath() + "/customer/list");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error deactivating customer", e);
            handleError(request, response, "Error deactivating customer: " + e.getMessage());
        }
    }

   
    
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {

        request.setAttribute("error", errorMessage);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/customer_list.jsp")
                .forward(request, response);
    }

    /**
     * Utility method to get integer parameter with default value
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
     * Utility method to get string parameter with trimming and null check
     */
    private String getStringParameter(HttpServletRequest request, String paramName) {
        String paramValue = request.getParameter(paramName);
        return (paramValue != null && !paramValue.trim().isEmpty()) ? paramValue.trim() : null;
    }

    /**
     * Validate email format
     */
    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }

    /**
     * Validate phone format
     */
    private boolean isValidPhone(String phone) {
        return phone != null && phone.matches("^[0-9]{10,11}$");
    }

    /**
     * Get total customers by status
     */
    private int getTotalByStatus(boolean isActive) {
        try {
            // This could be optimized with a dedicated DAO method
            List<Customer> customers = customerDAO.findByActiveStatus(isActive, 1, Integer.MAX_VALUE);
            return customers.size();
        } catch (Exception e) {
            logger.log(Level.WARNING, "Error getting total by status", e);
            return 0;
        }
    }

    /**
     * Handle API requests
     */
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

    /**
     * Handle refresh customer API
     */
    private void handleRefreshCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int customerId = getIntParameter(request, "id", 0);
            if (customerId <= 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"Invalid customer ID\"}");
                return;
            }

            // Fetch latest customer data from database
            Optional<Customer> customerOpt = customerDAO.findById(customerId);
            if (!customerOpt.isPresent()) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"success\": false, \"message\": \"Customer not found\"}");
                return;
            }

            Customer customer = customerOpt.get();

            // Build JSON response
            StringBuilder json = new StringBuilder();
            json.append("{\n");
            json.append("  \"success\": true,\n");
            json.append("  \"customer\": {\n");
            json.append("    \"customerId\": ").append(customer.getCustomerId()).append(",\n");
            json.append("    \"fullName\": \"").append(escapeJson(customer.getFullName())).append("\",\n");
            json.append("    \"email\": \"").append(escapeJson(customer.getEmail())).append("\",\n");
            json.append("    \"phoneNumber\": \"").append(escapeJson(customer.getPhoneNumber())).append("\",\n");
            json.append("    \"gender\": \"").append(escapeJson(customer.getGender())).append("\",\n");
            json.append("    \"birthday\": ").append(customer.getBirthday() != null ? "\"" + customer.getBirthday().toString() + "\"" : "null").append(",\n");
            json.append("    \"address\": \"").append(escapeJson(customer.getAddress())).append("\",\n");
            json.append("    \"isActive\": ").append(customer.getIsActive()).append(",\n");
            json.append("    \"loyaltyPoints\": ").append(customer.getLoyaltyPoints()).append(",\n");
            json.append("    \"createdAt\": \"").append(customer.getCreatedAt() != null ? customer.getCreatedAt().toString() : "").append("\",\n");
            json.append("    \"updatedAt\": \"").append(customer.getUpdatedAt() != null ? customer.getUpdatedAt().toString() : "").append("\"\n");
            json.append("  }\n");
            json.append("}");

            response.getWriter().write(json.toString());
            logger.info("Customer data refreshed for ID: " + customerId);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error refreshing customer data", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"Internal server error\"}");
        }
    }

    /**
     * Escape JSON string values
     */
    private String escapeJson(String str) {
        if (str == null) {
            return "";
        }
        return str.replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");
    }

    private void handleActivateCustomer(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            String customerIdStr = request.getParameter("id");

            int customerId = Integer.parseInt(customerIdStr);
//            
//            request.setAttribute("customerId", customerId);
//            request.getRequestDispatcher("/test.jsp").forward(request, response);

            if (customerId <= 0) {
                handleError(request, response, "Invalid customer ID provided.");
                return;
            }

            boolean success = customerDAO.activateCustomer(customerId);

            if (success) {
                logger.info("Customer deactivated successfully: " + customerId);
                request.getSession().setAttribute("successMessage", "Customer has been activated successfully.");
            } else {
                logger.warning("Failed to deactivate customer: " + customerId);
                request.getSession().setAttribute("errorMessage", "Failed to activate the customer.");
            }

            response.sendRedirect(request.getContextPath() + "/customer/list");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error activating customer", e);
            handleError(request, response, "Error activating customer: " + e.getMessage());
        }
    }
}
