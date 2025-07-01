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
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy trang cho hành động: " + action);
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in CustomerController GET", e);
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
            if (action == null || action.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu hành động cho yêu cầu POST.");
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
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hành động không hợp lệ: " + action);
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in CustomerController POST", e);
            handleError(request, response, "Đã xảy ra lỗi trong quá trình xử lý POST: " + e.getMessage());
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

            if (page < 1) {
                page = 1;
            }
            if (pageSize < 1 && pageSize != -1) {
                pageSize = DEFAULT_PAGE_SIZE; // -1 for ALL
            }
            int actualPageSize = (pageSize == 9999) ? Integer.MAX_VALUE : pageSize;

            List<Customer> customers = customerDAO.getPaginatedCustomers(page, actualPageSize, searchValue, status, sortBy, sortOrder);
            int totalCustomers = customerDAO.getTotalCustomerCount(searchValue, status);

            int totalPages = 0;
            if (totalCustomers > 0) {
                totalPages = (int) Math.ceil((double) totalCustomers / actualPageSize);
            }
            if (totalPages < 1) {
                totalPages = 1;
            }
            if (page > totalPages) {
                page = totalPages;
            }

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
            handleError(request, response, "Lỗi khi tải danh sách khách hàng: " + e.getMessage());
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
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID khách hàng không hợp lệ.");
                return;
            }

            Optional<Customer> customerOpt = customerDAO.findById(customerId);
            if (customerOpt.isPresent()) {
                request.setAttribute("customer", customerOpt.get());
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/Customer/customer_details.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy khách hàng.");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error viewing customer", e);
            handleError(request, response, "Lỗi khi xem thông tin khách hàng: " + e.getMessage());
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
        String notes = request.getParameter("notes");

        Map<String, String> errors = new HashMap<>();

        // --- VALIDATION ---
        // 1. Full Name (Đồng bộ validate, KHÔNG cho phép dấu nháy đơn và gạch nối)
        final String trimmedName = (name != null) ? name.trim() : "";
        final String namePattern = "^[\\p{L}\\s]+$";
        if (trimmedName.isEmpty()) {
            errors.put("fullName", "Tên là bắt buộc.");
        } else if (trimmedName.length() < 2 || trimmedName.length() > 100) {
            errors.put("fullName", "Tên phải có độ dài từ 2 đến 100 ký tự.");
        } else if (trimmedName.contains("  ")) {
            errors.put("fullName", "Tên không được có nhiều khoảng trắng liền kề.");
        } else if (!trimmedName.contains(" ")) {
            errors.put("fullName", "Tên đầy đủ cần có ít nhất hai từ (ví dụ: An Nguyen).");
        } else if (!trimmedName.matches(namePattern)) {
            errors.put("fullName", "Tên chỉ được chứa chữ cái và khoảng trắng, không được chứa số hoặc ký tự đặc biệt.");
        }

        // 2. Email
        if (email == null || email.trim().isEmpty()) {
            errors.put("email", "Email là bắt buộc.");
        } else if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            errors.put("email", "Định dạng email không hợp lệ.");
        } else {
            try {
                if (!customerDAO.findByEmailContain(email.trim()).isEmpty()) {
                    errors.put("email", "Email này đã được đăng ký.");
                }
            } catch (Exception e) {
                logger.log(Level.SEVERE, "Database error checking email uniqueness", e);
                errors.put("email", "Không thể xác minh email. Vui lòng thử lại.");
            }
        }

        // 3. Password
        if (password == null || password.isEmpty()) {
            errors.put("password", "Mật khẩu là bắt buộc.");
        } else if (password.length() < 7) {
            errors.put("password", "Mật khẩu phải có ít nhất 7 ký tự.");
        }

        // 4. Phone Number
        if (phone != null && !phone.trim().isEmpty()) {
            if (!phone.matches("^0\\d{9}$")) {
                errors.put("phoneNumber", "Số điện thoại phải có 10 chữ số và bắt đầu bằng 0.");
            } else {
                try {
                    if (accountDao.isPhoneTakenInSystem(phone.trim())) {
                        errors.put("phoneNumber", "Số điện thoại này đã được đăng ký.");
                    }
                } catch (Exception e) {
                    logger.log(Level.SEVERE, "Database error checking phone number uniqueness", e);
                    errors.put("phoneNumber", "Không thể xác minh số điện thoại. Vui lòng thử lại.");
                }
            }
        }

        // 5. Birthday
        Date birthday = null;
        if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
            try {
                birthday = Date.valueOf(birthdayStr);
                if (birthday.after(new java.util.Date())) {
                    errors.put("birthday", "Ngày sinh không thể ở trong tương lai.");
                }
            } catch (IllegalArgumentException e) {
                errors.put("birthday", "Định dạng ngày không hợp lệ. Vui lòng sử dụng yyyy-MM-dd.");
            }
        }

        // 6. Notes
        if (notes != null && notes.length() > 500) {
            errors.put("notes", "Ghi chú tối đa 500 ký tự.");
        }

        Customer customerInput = new Customer();
        customerInput.setFullName(name);
        customerInput.setEmail(email);
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
            newCustomer.setEmail(email.trim().toLowerCase());
            newCustomer.setHashPassword(password); // NOTE: Cần mã hóa mật khẩu ở đây
            newCustomer.setPhoneNumber(phone != null ? phone.trim() : null);
            newCustomer.setGender(gender);
            newCustomer.setAddress(address != null ? address.trim() : null);
            newCustomer.setBirthday(birthday);
            newCustomer.setIsActive(true);
            newCustomer.setIsVerified(false);
            newCustomer.setLoyaltyPoints(0);
            newCustomer.setRoleId(1);
            newCustomer.setNotes(notes);

            customerDAO.save(newCustomer);

            request.getSession().setAttribute("successMessage", "Đã thêm khách hàng mới thành công!");
            response.sendRedirect(request.getContextPath() + "/customer/list");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error saving new customer to database", e);
            String userErrorMessage = "Đã có lỗi xảy ra khi lưu khách hàng. Vui lòng thử lại. Chi tiết lỗi: " + e.getMessage();
            request.setAttribute("error", userErrorMessage);
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
                request.setAttribute("customer", customerOpt.get());
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/Customer/customer_edit.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy khách hàng.");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error showing edit form", e);
            handleError(request, response, "Lỗi khi tải thông tin khách hàng để chỉnh sửa: " + e.getMessage());
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
            String name = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phoneNumber");
            String gender = request.getParameter("gender");
            String address = request.getParameter("address");
            String birthdayStr = request.getParameter("birthday");
            String notes = request.getParameter("notes");
            String loyaltyPointsStr = request.getParameter("loyaltyPoints");
            String password = request.getParameter("password");

            Map<String, String> errors = new HashMap<>();

            // Lấy và trim chuỗi một lần để xóa khoảng trắng thừa ở đầu và cuối
            final String trimmedName = (name != null) ? name.trim() : "";

            // Regex cho phép chữ cái (mọi ngôn ngữ), dấu nháy đơn, gạch nối và khoảng trắng
            final String namePattern = "^[\\p{L}'\\-\\s]+$";

            // Bắt đầu chuỗi kiểm tra logic
            if (trimmedName.isEmpty()) {
                errors.put("fullName", "Tên là bắt buộc.");
            } else if (trimmedName.length() < 2 || trimmedName.length() > 100) {
                errors.put("fullName", "Tên phải có độ dài từ 2 đến 100 ký tự.");
            } else if (trimmedName.contains("  ")) {
                // 1. Kiểm tra có 2 hoặc nhiều khoảng trắng liền kề không
                errors.put("fullName", "Tên không được có nhiều khoảng trắng liền kề.");
            } else if (!trimmedName.contains(" ")) {
                // 2. Bắt buộc tên phải có ít nhất một khoảng trắng (tức là có họ và tên)
                errors.put("fullName", "Tên đầy đủ cần có ít nhất hai từ (ví dụ: An Nguyen).");
            } else if (!trimmedName.matches(namePattern)) {
                // 3. Kiểm tra không chứa số và các ký tự đặc biệt không mong muốn
                errors.put("fullName", "Tên chỉ được chứa chữ cái và khoảng trắng.");
            }
            if (email == null || email.trim().isEmpty()) {
                errors.put("email", "Email là bắt buộc.");
            } else if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
                errors.put("email", "Định dạng email không hợp lệ.");
            } else {
                try {
                    List<Customer> emailList = customerDAO.findByEmailContain(email.trim());
                    if (!emailList.isEmpty() && (emailList.size() > 1 || !emailList.get(0).getCustomerId().equals(customerId))) {
                        errors.put("email", "Email này đã được đăng ký.");
                    }
                } catch (Exception e) {
                    logger.log(Level.SEVERE, "Database error checking email uniqueness", e);
                    errors.put("email", "Không thể xác minh email. Vui lòng thử lại.");
                }
            }
            if (phone != null && !phone.trim().isEmpty()) {
                if (!phone.matches("^0\\d{9}$")) {
                    errors.put("phoneNumber", "Số điện thoại phải có 10 chữ số và bắt đầu bằng 0.");
                } else {
                    try {
                        AccountDAO accountDao = new AccountDAO();
                        if (accountDao.isPhoneTakenInSystem(phone.trim())) {
                            List<Customer> phoneList = customerDAO.findByPhoneContain(phone.trim());
                            if (!phoneList.isEmpty() && (phoneList.size() > 1 || !phoneList.get(0).getCustomerId().equals(customerId))) {
                                errors.put("phoneNumber", "Số điện thoại này đã được đăng ký.");
                            }
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
                    errors.put("birthday", "Định dạng ngày không hợp lệ. Vui lòng sử dụng yyyy-MM-dd.");
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
                customer.setEmail(email);
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
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/Customer/customer_edit.jsp").forward(request, response);
                return;
            }
            customer.setFullName(name);
            customer.setEmail(email);
            customer.setPhoneNumber(phone);
            customer.setGender(gender);
            customer.setAddress(address);
            customer.setBirthday(birthday);
            customer.setNotes(notes);
            if (loyaltyPoints != null) {
                customer.setLoyaltyPoints(loyaltyPoints);
            }
            customer.setIsActive(request.getParameter("active") != null);
            customer.setIsVerified(request.getParameter("verified") != null);

            // Xử lý cập nhật mật khẩu nếu có
            if (password != null && !password.isEmpty()) {
                // Thêm validation cho mật khẩu nếu cần
                // customer.setHashPassword(PasswordUtil.hash(password)); // Mã hóa mật khẩu mới
            }

            customerDAO.update(customer);
            request.getSession().setAttribute("successMessage", "Cập nhật khách hàng thành công!");

            String page = request.getParameter("page");
            String pageSize = request.getParameter("pageSize");
            String searchValue = request.getParameter("searchValue");
            String status = request.getParameter("status");
            StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/customer/list");
            List<String> params = new ArrayList<>();
            if (page != null && !page.isEmpty()) {
                params.add("page=" + page);
            }
            if (pageSize != null && !pageSize.isEmpty()) {
                params.add("pageSize=" + pageSize);
            }
            if (searchValue != null && !searchValue.isEmpty()) {
                params.add("searchValue=" + java.net.URLEncoder.encode(searchValue, "UTF-8"));
            }
            if (status != null && !status.isEmpty()) {
                params.add("status=" + status);
            }
            if (!params.isEmpty()) {
                redirectUrl.append("?" + String.join("&", params));
            }

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
                request.getSession().setAttribute("errorMessage", "ID khách hàng được cung cấp không hợp lệ.");
                response.sendRedirect(redirectUrl);
                return;
            }

            if (customerDAO.deactivateCustomer(customerId)) {
                request.getSession().setAttribute("successMessage", "Đã vô hiệu hóa khách hàng thành công.");
            } else {
                request.getSession().setAttribute("errorMessage", "Vô hiệu hóa khách hàng thất bại.");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error deactivating customer", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi vô hiệu hóa khách hàng: " + e.getMessage());
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
                request.getSession().setAttribute("errorMessage", "ID khách hàng được cung cấp không hợp lệ.");
                response.sendRedirect(redirectUrl);
                return;
            }

            if (customerDAO.activateCustomer(customerId)) {
                request.getSession().setAttribute("successMessage", "Đã kích hoạt khách hàng thành công.");
            } else {
                request.getSession().setAttribute("errorMessage", "Kích hoạt khách hàng thất bại.");
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error activating customer", e);
            request.getSession().setAttribute("errorMessage", "Lỗi khi kích hoạt khách hàng: " + e.getMessage());
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
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu điểm cuối API.");
            return;
        }

        String apiAction = pathInfo.substring(5); // Remove "/api/"

        switch (apiAction) {
            case "refresh":
                handleRefreshCustomer(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Điểm cuối API không xác định.");
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
                params.add("search=" + URLEncoder.encode(search, StandardCharsets.UTF_8.toString()));
            } catch (Exception e) {
                logger.warning("Không thể mã hóa tham số tìm kiếm: " + e.getMessage());
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
