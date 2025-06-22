/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import dao.EmailVerificationTokenDAO;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Customer;
import model.EmailVerificationToken;
import service.email.AsyncEmailService;
import validation.RegisterValidator;

/**
 * Consolidated controller for all registration-related functionality
 * Handles: registration, success page, email verification, resend verification
 */
@WebServlet(name = "RegisterController", urlPatterns = {
        "/register",
        "/register-success",
        "/email-verification-required",
        "/resend-verification",
        "/verify-email"
})
public class RegisterController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RegisterController.class.getName());

    private CustomerDAO customerDAO;
    private AsyncEmailService asyncEmailService;
    private EmailVerificationTokenDAO verificationTokenDAO;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        this.customerDAO = new CustomerDAO();
        this.asyncEmailService = new AsyncEmailService();
        this.verificationTokenDAO = new EmailVerificationTokenDAO();
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SignUpController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Hello at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/register":
                handleRegisterGet(request, response);
                break;
            case "/register-success":
                handleRegisterSuccessGet(request, response);
                break;
            case "/email-verification-required":
                handleEmailVerificationRequiredGet(request, response);
                break;
            case "/resend-verification":
                handleResendVerificationGet(request, response);
                break;
            case "/verify-email":
                handleEmailVerificationGet(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/register":
                handleRegisterPost(request, response);
                break;
            case "/register-success":
                // POST not allowed for register-success
                response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST method not allowed");
                break;
            case "/email-verification-required":
                handleEmailVerificationRequiredGet(request, response);
                break;
            case "/resend-verification":
                handleResendVerificationPost(request, response);
                break;
            case "/verify-email":
                handleEmailVerificationGet(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ==================== REGISTER HANDLERS ====================

    private void handleRegisterGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if this is an AJAX validation request
        String validateType = request.getParameter("validate");
        String value = request.getParameter("value");

        if (validateType != null && value != null) {
            handleAjaxValidation(request, response, validateType, value);
            return;
        }

        request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
    }

    /**
     * Handle AJAX validation requests for duplicate checking
     */
    private void handleAjaxValidation(HttpServletRequest request, HttpServletResponse response,
            String validateType, String value) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        RegisterValidator validator = new RegisterValidator();
        boolean isDuplicate = false;
        String message = "";

        try (PrintWriter out = response.getWriter()) {
            if (value.trim().isEmpty()) {
                out.print("{\"valid\": false, \"message\": \"Giá trị không được để trống\"}");
                return;
            }

            switch (validateType.toLowerCase()) {
                case "email":
                    isDuplicate = validator.isEmailDuplicate(value.trim());
                    if (isDuplicate) {
                        message = "Email đã tồn tại trong hệ thống.";
                    } else {
                        message = "Email có thể sử dụng.";
                    }
                    break;

                case "phone":
                    isDuplicate = validator.isPhoneDuplicate(value.trim());
                    if (isDuplicate) {
                        message = "Số điện thoại đã tồn tại trong hệ thống.";
                    } else {
                        message = "Số điện thoại có thể sử dụng.";
                    }
                    break;

                default:
                    out.print("{\"valid\": false, \"message\": \"Loại validation không hỗ trợ\"}");
                    return;
            }

            // Return JSON response
            out.print("{\"valid\": " + !isDuplicate + ", \"isDuplicate\": " + isDuplicate + ", \"message\": \""
                    + message + "\"}");

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"valid\": false, \"message\": \"Lỗi hệ thống, vui lòng thử lại.\"}");
            }
        }
    }

    private void handleRegisterPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // retrieve form data and trim whitespace
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Trim all input fields to remove leading/trailing spaces
        if (fullName != null)
            fullName = fullName.trim();
        if (phone != null)
            phone = phone.trim();
        if (email != null)
            email = email.trim();
        // Note: Don't trim password as spaces might be intentional
        if (confirmPassword != null)
            confirmPassword = confirmPassword.trim();

        // Create validator instance
        RegisterValidator validator = new RegisterValidator();

        // Validate full name (match JavaScript validation)
        if (fullName == null || fullName.isBlank() || fullName.isEmpty()) {
            request.setAttribute("error", "Họ tên không được để trống.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
            return;
        } else if (fullName.length() < 6) {
            request.setAttribute("error", "Họ tên phải có ít nhất 6 ký tự.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
            return;
        } else if (fullName.length() > 100) {
            request.setAttribute("error", "Họ tên không được vượt quá 100 ký tự.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
            return;
        } else if (!fullName.matches(
                "^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\\s]{6,100}$")) {
            request.setAttribute("error", "Họ tên chỉ được chứa chữ cái và khoảng trắng.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
            return;
        }

        // Validate phone
        if (phone == null || !phone.matches("^0[1-9][0-9]{8}$")) {
            request.setAttribute("error", "Số điện thoại phải bắt đầu bằng 0, và có đúng 10 chữ số.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
            return;
        }

        // Validate email (match JavaScript validation)
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email không được để trống.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
            return;
        } else if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            request.setAttribute("error", "Định dạng email không hợp lệ.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
            return;
        } else if (email.length() > 255) {
            request.setAttribute("error", "Email không được vượt quá 255 ký tự.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
            return;
        }

        // Validate password (match JavaScript validation)
        if (password == null || password.isEmpty()) {
            request.setAttribute("error", "Mật khẩu không được để trống.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
            return;
        } else if (password.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
            return;
        } else if (password.length() > 30) {
            request.setAttribute("error", "Mật khẩu không được vượt quá 30 ký tự.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
            return;
        }

        // Validate confirm password (match JavaScript validation)
        if (confirmPassword == null || confirmPassword.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập lại mật khẩu.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
            return;
        } else if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu nhập lại không khớp.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
            return;
        }

        // Check for duplicate email
        if (validator.isEmailDuplicate(email)) {
            request.setAttribute("error", "Email đã tồn tại.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
            return;
        }

        // Check for duplicate phone
        if (validator.isPhoneDuplicate(phone)) {
            request.setAttribute("error", "Số điện thoại đã tồn tại.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
            return;
        }

        // create new customer to store form data - pass plain password, it will be
        // hashed in DAO
        Customer newCustomer = new Customer(fullName, email, password, phone);

        // Set default values
        newCustomer.setIsActive(true);
        newCustomer.setLoyaltyPoints(0);

        // save data to database
        customerDAO.save(newCustomer);

        // Use POST-redirect-GET pattern to prevent refresh issues
        // Store success data in session temporarily
        HttpSession session = request.getSession();
        session.setAttribute("registrationEmail", email);
        session.setAttribute("registrationFullName", fullName);
        session.setAttribute("registrationPassword", password); // Store password for login pre-filling
        session.setAttribute("registrationSuccess", true);

        // Redirect to register success page with email parameter for refresh-proof
        // access
        response.sendRedirect(request.getContextPath() + "/register-success?email=" +
                java.net.URLEncoder.encode(email, "UTF-8"));
    }

    // ==================== REGISTER SUCCESS HANDLERS ====================

    private void handleRegisterSuccessGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = null;
        String fullName = null;

        // First check if email is provided as URL parameter (for page refreshes)
        String emailParam = request.getParameter("email");
        if (emailParam != null && !emailParam.trim().isEmpty()) {
            email = emailParam;
            // We don't need fullName for refreshes, countdown functionality works without
            // it
        } else {
            // Check if this is a valid registration success request from session
            Boolean registrationSuccess = (Boolean) session.getAttribute("registrationSuccess");
            if (registrationSuccess == null || !registrationSuccess) {
                // No valid registration in session and no email parameter, redirect to
                // registration page
                response.sendRedirect(request.getContextPath() + "/register");
                return;
            }

            // Get registration data from session
            email = (String) session.getAttribute("registrationEmail");
            fullName = (String) session.getAttribute("registrationFullName");
            String password = (String) session.getAttribute("registrationPassword");

            // Store for email verification login flow
            if (email != null && password != null) {
                session.setAttribute("verificationLoginEmail", email);
                session.setAttribute("verificationLoginPassword", password);
            }

            // Clear registration data from session to prevent reuse
            session.removeAttribute("registrationSuccess");
            session.removeAttribute("registrationEmail");
            session.removeAttribute("registrationFullName");
            session.removeAttribute("registrationPassword");
        }

        // Set attributes for JSP
        request.setAttribute("email", email);
        if (fullName != null) {
            request.setAttribute("fullName", fullName);
        }

        // Forward to register success page
        request.getRequestDispatcher("/WEB-INF/view/auth/register-success.jsp").forward(request, response);
    }

    // ==================== EMAIL VERIFICATION REQUIRED HANDLERS
    // ====================

    private void handleEmailVerificationRequiredGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get email parameter from request
        String email = request.getParameter("email");

        // Set email attribute for JSP
        if (email != null && !email.trim().isEmpty()) {
            request.setAttribute("email", email.trim());
        }

        // Forward to email verification required page
        request.getRequestDispatcher("/WEB-INF/view/auth/email-verification-required.jsp").forward(request, response);
    }

    // ==================== EMAIL VERIFICATION HANDLERS ====================

    private void handleEmailVerificationGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");

        if (token == null || token.trim().isEmpty()) {
            LOGGER.warning("Email verification attempted without token");
            request.setAttribute("error", "Token xác thực không hợp lệ hoặc bị thiếu.");
            forwardToVerificationResult(request, response);
            return;
        }

        try {
            // Find the token in database
            EmailVerificationToken verificationToken = verificationTokenDAO.findByToken(token);

            if (verificationToken == null) {
                LOGGER.warning("Token not found: " + token);
                request.setAttribute("error", "Token xác thực không tồn tại hoặc đã hết hạn.");
                forwardToVerificationResult(request, response);
                return;
            }

            // Check if token is valid (not expired and not used)
            if (!verificationTokenDAO.isValid(token)) {
                LOGGER.warning("Invalid or expired token: " + token);
                request.setAttribute("error",
                        "Token xác thực đã hết hạn hoặc đã được sử dụng. Vui lòng yêu cầu gửi lại email xác thực.");
                forwardToVerificationResult(request, response);
                return;
            }

            // Find the customer by email
            String userEmail = verificationToken.getUserEmail();
            Optional<Customer> customerOpt = customerDAO.findCustomerByEmail(userEmail);
            Customer customer = customerOpt.orElse(null);

            if (customer == null) {
                LOGGER.warning("Customer not found for email: " + userEmail);
                request.setAttribute("error", "Không tìm thấy tài khoản khách hàng tương ứng với email này.");
                forwardToVerificationResult(request, response);
                return;
            }

            // Check if customer is already verified
            if (customer.getIsVerified() != null && customer.getIsVerified()) {
                LOGGER.info("Customer already verified: " + userEmail);
                request.setAttribute("success",
                        "Email của bạn đã được xác thực trước đó. Bạn có thể đăng nhập và sử dụng dịch vụ.");
                request.setAttribute("email", userEmail);
                forwardToVerificationResult(request, response);
                return;
            }

            // Update customer verification status
            boolean updateSuccess = customerDAO.updateCustomerVerificationStatus(userEmail, true);

            if (!updateSuccess) {
                LOGGER.severe("Failed to update customer verification status for: " + userEmail);
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật trạng thái xác thực. Vui lòng thử lại sau.");
                forwardToVerificationResult(request, response);
                return;
            }

            // Mark token as used
            verificationTokenDAO.markAsUsed(token);

            LOGGER.info("Successfully verified email for customer: " + userEmail);
            request.setAttribute("success",
                    "Email của bạn đã được xác thực thành công! Bạn có thể đăng nhập và sử dụng tất cả các dịch vụ của chúng tôi.");
            request.setAttribute("email", userEmail);

            // Store login data in session for auto-prefill after verification
            HttpSession session = request.getSession();
            session.setAttribute("verificationLoginEmail", userEmail);
            // Don't store password here as it's not available in verification flow

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during email verification for token: " + token, e);
            request.setAttribute("error", "Có lỗi hệ thống xảy ra. Vui lòng thử lại sau hoặc liên hệ hỗ trợ.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error during email verification for token: " + token, e);
            request.setAttribute("error", "Có lỗi không mong đợi xảy ra. Vui lòng thử lại sau.");
        }

        forwardToVerificationResult(request, response);
    }

    /**
     * Forward request to verification result page
     */
    private void forwardToVerificationResult(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/view/auth/verification-result.jsp").forward(request, response);
    }

    // ==================== RESEND VERIFICATION HANDLERS ====================

    private void handleResendVerificationPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            HttpSession session = request.getSession();
            Customer customer = (Customer) session.getAttribute("customer");

            // Check if customer is logged in
            if (customer == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("{\"success\": false, \"message\": \"Bạn cần đăng nhập để thực hiện chức năng này.\"}");
                return;
            }

            try {
                // Check if customer is already verified
                if (customerDAO.isCustomerVerified(customer.getEmail())) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"success\": false, \"message\": \"Email của bạn đã được xác thực.\"}");
                    return;
                }

                // Check rate limiting - prevent sending emails within 60 seconds
                String lastSentKey = "lastVerificationSent_" + customer.getEmail();
                Long lastSentTime = (Long) session.getAttribute(lastSentKey);
                if (lastSentTime != null) {
                    long timeSinceLastSent = (System.currentTimeMillis() - lastSentTime) / 1000;
                    if (timeSinceLastSent < 60) {
                        long remainingTime = 60 - timeSinceLastSent;
                        out.print("{\"success\": false, \"message\": \"Vui lòng đợi " + remainingTime
                                + " giây trước khi gửi lại email.\"}");
                        return;
                    }
                }

                // Delete any existing tokens for this email
                verificationTokenDAO.deleteTokensByEmail(customer.getEmail());

                // Create new verification token
                EmailVerificationToken token = new EmailVerificationToken(customer.getEmail());
                verificationTokenDAO.save(token);

                // Send verification email asynchronously
                String customerName = customerDAO.getCustomerNameByEmail(customer.getEmail());
                if (customerName == null) {
                    customerName = customer.getFullName();
                }
                asyncEmailService.sendVerificationEmailAsync(customer.getEmail(), token.getToken(), customerName);

                // Store timestamp to prevent rapid resending
                session.setAttribute(lastSentKey, System.currentTimeMillis());

                // Return success response
                out.print("{\"success\": true, \"message\": \"Email xác thực đã được gửi lại thành công!\"}");

            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error resending verification email", ex);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra khi gửi email. Vui lòng thử lại sau.\"}");
            } catch (Exception ex) {
                LOGGER.log(Level.SEVERE, "Unexpected error resending verification email", ex);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(
                        "{\"success\": false, \"message\": \"Có lỗi không mong muốn xảy ra. Vui lòng thử lại sau.\"}");
            }
        }
    }

    private void handleResendVerificationGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle resend verification from login page for unverified customers
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Check if customer exists
            Optional<Customer> customerOpt = customerDAO.findCustomerByEmail(email);
            Customer customer = customerOpt.orElse(null);
            if (customer == null) {
                request.setAttribute("error", "Không tìm thấy tài khoản với email này.");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Check if customer is already verified
            if (customerDAO.isCustomerVerified(email)) {
                request.setAttribute("error", "Email của bạn đã được xác thực. Vui lòng đăng nhập.");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Check rate limiting using session
            HttpSession session = request.getSession();
            String lastSentKey = "lastVerificationSent_" + email;
            Long lastSentTime = (Long) session.getAttribute(lastSentKey);
            if (lastSentTime != null) {
                long timeSinceLastSent = (System.currentTimeMillis() - lastSentTime) / 1000;
                if (timeSinceLastSent < 60) {
                    long remainingTime = 60 - timeSinceLastSent;
                    request.setAttribute("error", "Vui lòng đợi " + remainingTime + " giây trước khi gửi lại email.");
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
            }

            // Delete any existing tokens for this email
            verificationTokenDAO.deleteTokensByEmail(email);

            // Create new verification token
            EmailVerificationToken token = new EmailVerificationToken(email);
            verificationTokenDAO.save(token);

            // Send verification email asynchronously
            String customerName = customer.getFullName();
            asyncEmailService.sendVerificationEmailAsync(email, token.getToken(), customerName);

            // Store timestamp to prevent rapid resending
            session.setAttribute(lastSentKey, System.currentTimeMillis());

            // Check if this is an AJAX request (from register-success page)
            String ajaxHeader = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(ajaxHeader) || request.getParameter("ajax") != null) {
                // Return JSON response for AJAX
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                try (PrintWriter out = response.getWriter()) {
                    out.print("{\"success\": true, \"message\": \"Email xác thực đã được gửi thành công!\"}");
                }
                return;
            }

            // Redirect to login with success message (for non-AJAX requests)
            response.sendRedirect(request.getContextPath() + "/login?resent=true");

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error resending verification email", ex);

            // Check if this is an AJAX request
            String ajaxHeader = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(ajaxHeader) || request.getParameter("ajax") != null) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                try (PrintWriter out = response.getWriter()) {
                    out.print(
                            "{\"success\": false, \"message\": \"Có lỗi xảy ra khi gửi email. Vui lòng thử lại sau.\"}");
                }
                return;
            }

            request.setAttribute("error", "Có lỗi xảy ra khi gửi email. Vui lòng thử lại sau.");
            response.sendRedirect(request.getContextPath() + "/login");
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Unexpected error resending verification email", ex);

            // Check if this is an AJAX request
            String ajaxHeader = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(ajaxHeader) || request.getParameter("ajax") != null) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                try (PrintWriter out = response.getWriter()) {
                    out.print(
                            "{\"success\": false, \"message\": \"Có lỗi không mong muốn xảy ra. Vui lòng thử lại sau.\"}");
                }
                return;
            }

            request.setAttribute("error", "Có lỗi không mong muốn xảy ra. Vui lòng thử lại sau.");
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Consolidated Register Controller - handles all registration workflow";
    }
}
