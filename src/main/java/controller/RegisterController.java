/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import com.google.gson.Gson;
import dao.AccountDAO;
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
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
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
    private Gson gson = new Gson();
    private AccountDAO accountDAO;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        this.customerDAO = new CustomerDAO();
        this.asyncEmailService = new AsyncEmailService();
        this.verificationTokenDAO = new EmailVerificationTokenDAO();
        this.accountDAO = new AccountDAO();
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

        Map<String, Object> jsonResponse = new HashMap<>();

        try {
            if (value == null || value.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                jsonResponse.put("valid", false);
                jsonResponse.put("isDuplicate", false);
                jsonResponse.put("message", "Giá trị không được để trống.");
            } else {
                RegisterValidator validator = new RegisterValidator();
                boolean isDuplicate = false;
                String message = "";
                boolean supportedType = true;

                switch (validateType.toLowerCase()) {
                    case "email":
                        isDuplicate = validator.isEmailDuplicate(value.trim());
                        message = isDuplicate ? "Email đã tồn tại trong hệ thống." : "Email có thể sử dụng.";
                        break;
                    case "phone":
                        isDuplicate = validator.isPhoneDuplicate(value.trim());
                        message = isDuplicate ? "Số điện thoại đã tồn tại trong hệ thống."
                                : "Số điện thoại có thể sử dụng.";
                        break;
                    default:
                        supportedType = false;
                        break;
                }

                if (supportedType) {
                    jsonResponse.put("valid", !isDuplicate);
                    jsonResponse.put("isDuplicate", isDuplicate);
                    jsonResponse.put("message", message);
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    jsonResponse.put("valid", false);
                    jsonResponse.put("message", "Loại validation không hỗ trợ.");
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during AJAX validation for type '" + validateType + "'", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.clear();
            jsonResponse.put("valid", false);
            // Fail safe: assume it is a duplicate to prevent user from proceeding on error
            jsonResponse.put("isDuplicate", true);
            jsonResponse.put("message", "Lỗi hệ thống, vui lòng thử lại sau.");
        }

        response.getWriter().write(gson.toJson(jsonResponse));
    }

    private void handleRegisterPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> jsonResponse = new HashMap<>();

        try {
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String agreeTerms = request.getParameter("agreeTerms");

            // --- Server-side validation ---
            if (fullName == null || fullName.trim().isEmpty() ||
                    phone == null || phone.trim().isEmpty() ||
                    email == null || email.trim().isEmpty() ||
                    password == null || password.isEmpty() ||
                    !"on".equals(agreeTerms)) {

                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Vui lòng điền đầy đủ thông tin bắt buộc.");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            if (accountDAO.isEmailTakenInSystem(email)) {
                response.setStatus(HttpServletResponse.SC_CONFLICT);
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Email này đã được sử dụng.");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            if (accountDAO.isPhoneTakenInSystem(phone)) {
                response.setStatus(HttpServletResponse.SC_CONFLICT);
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Số điện thoại này đã được sử dụng.");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            // --- Create and save customer ---
            Customer newCustomer = new Customer(fullName, email, password, phone);

            customerDAO.save(newCustomer);

            try {
                // Create verification token for email verification
                EmailVerificationToken token = new EmailVerificationToken(email);
                verificationTokenDAO.save(token);

                // Send verification email asynchronously
                asyncEmailService.sendVerificationEmailAsync(email, token.getToken(), fullName);

                // Store timestamp to prevent rapid resending
                HttpSession session = request.getSession();
                String lastSentKey = "lastVerificationSent_" + email;
                session.setAttribute(lastSentKey, System.currentTimeMillis());

                // Temporarily store the plain-text password for the post-verification prefill.
                // This is a trade-off for user convenience. It will be cleared after use.
                session.setAttribute("password_for_prefill_" + email, password);

                LOGGER.info("Verification email sent successfully for new registration: " + email);

            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error creating verification token for: " + email, ex);
                // Continue with registration process even if email fails
            } catch (Exception ex) {
                LOGGER.log(Level.SEVERE, "Error sending verification email for: " + email, ex);
                // Continue with registration process even if email fails
            }

            // --- Set flash message and send success response ---
            request.getSession().setAttribute("flash_success",
                    "Đăng ký thành công! Vui lòng kiểm tra email để xác thực tài khoản.");

            jsonResponse.put("success", true);
            jsonResponse.put("redirectUrl", request.getContextPath() + "/email-verification-required?email="
                    + java.net.URLEncoder.encode(email, "UTF-8"));
            response.getWriter().write(gson.toJson(jsonResponse));

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during customer registration", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Đã có lỗi xảy ra phía máy chủ. Vui lòng thử lại sau.");
            response.getWriter().write(gson.toJson(jsonResponse));
        }
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
            EmailVerificationToken verificationToken = verificationTokenDAO.findByToken(token);

            if (verificationToken == null) {
                LOGGER.warning("Token not found: " + token);
                request.setAttribute("error", "Token xác thực không tồn tại hoặc đã hết hạn.");
                forwardToVerificationResult(request, response);
                return;
            }

            if (!verificationTokenDAO.isValid(token)) {
                LOGGER.warning("Invalid or expired token: " + token);
                request.setAttribute("error",
                        "Token xác thực đã hết hạn hoặc đã được sử dụng. Vui lòng yêu cầu gửi lại email xác thực.");
                forwardToVerificationResult(request, response);
                return;
            }

            String userEmail = verificationToken.getUserEmail();
            Optional<Customer> customerOpt = customerDAO.findCustomerByEmail(userEmail);
            Customer customer = customerOpt.orElse(null);

            if (customer == null) {
                LOGGER.warning("Customer not found for email: " + userEmail);
                request.setAttribute("error", "Không tìm thấy tài khoản khách hàng tương ứng với email này.");
                forwardToVerificationResult(request, response);
                return;
            }

            if (customer.getIsVerified() != null && customer.getIsVerified()) {
                LOGGER.info("Customer already verified: " + userEmail);
                request.setAttribute("success",
                        "Email của bạn đã được xác thực trước đó. Bạn có thể đăng nhập và sử dụng dịch vụ.");
                request.setAttribute("email", userEmail);
                forwardToVerificationResult(request, response);
                return;
            }

            boolean updateSuccess = customerDAO.updateCustomerVerificationStatus(userEmail, true);

            if (!updateSuccess) {
                LOGGER.severe("Failed to update customer verification status for: " + userEmail);
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật trạng thái xác thực. Vui lòng thử lại sau.");
                forwardToVerificationResult(request, response);
                return;
            }

            verificationTokenDAO.markAsUsed(token);

            LOGGER.info("Successfully verified email for customer: " + userEmail);
            request.setAttribute("success",
                    "Email của bạn đã được xác thực thành công! Bạn có thể đăng nhập và sử dụng tất cả các dịch vụ của chúng tôi.");
            request.setAttribute("email", userEmail);

            HttpSession session = request.getSession();
            session.setAttribute("verificationLoginEmail", userEmail);

            String tempPasswordKey = "password_for_prefill_" + userEmail;
            String passwordForPrefill = (String) session.getAttribute(tempPasswordKey);

            if (passwordForPrefill != null) {
                session.setAttribute("verificationLoginPassword", passwordForPrefill);
                session.removeAttribute(tempPasswordKey);
            }

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
        // Handle resend verification from email verification page
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            // Return JSON error response for AJAX requests
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"success\": false, \"message\": \"Email không hợp lệ.\"}");
            }
            return;
        }

        try {
            // Check if customer exists
            Optional<Customer> customerOpt = customerDAO.findCustomerByEmail(email);
            Customer customer = customerOpt.orElse(null);
            if (customer == null) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                try (PrintWriter out = response.getWriter()) {
                    out.print("{\"success\": false, \"message\": \"Không tìm thấy tài khoản với email này.\"}");
                }
                return;
            }

            // Check if customer is already verified
            if (customerDAO.isCustomerVerified(email)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                try (PrintWriter out = response.getWriter()) {
                    out.print(
                            "{\"success\": false, \"message\": \"Email của bạn đã được xác thực. Vui lòng đăng nhập.\"}");
                }
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
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.setStatus(429); // Too Many Requests
                    try (PrintWriter out = response.getWriter()) {
                        out.print("{\"success\": false, \"message\": \"Vui lòng đợi " + remainingTime
                                + " giây trước khi gửi lại email.\"}");
                    }
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

            // Return JSON success response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"success\": true, \"message\": \"Email xác thực đã được gửi thành công!\"}");
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error resending verification email", ex);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra khi gửi email. Vui lòng thử lại sau.\"}");
            }
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Unexpected error resending verification email", ex);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (PrintWriter out = response.getWriter()) {
                out.print(
                        "{\"success\": false, \"message\": \"Có lỗi không mong muốn xảy ra. Vui lòng thử lại sau.\"}");
            }
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
