/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nb://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AccountDAO;
import dao.CustomerDAO;
import dao.PasswordResetTokenDAO;
import dao.UserDAO;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import service.email.EmailService;
import service.email.AsyncEmailService;
import model.PasswordResetToken;
import org.mindrot.jbcrypt.BCrypt;
import com.google.gson.Gson;

/**
 * Extended ResetPasswordController that handles both Customer and User account
 * types
 * 
 * @author quang
 */

// password/reset: reset password get + post
// password/change/request: send email to reset password
@WebServlet(name = "ResetPasswordController", urlPatterns = {
        "/password-reset/new",
        "/password-reset/request",
        "/password-reset/edit",
        "/password-reset/update",
        "/password-reset/test-email"
})
public class ResetPasswordController extends HttpServlet {

    private AccountDAO accountDAO;
    private UserDAO userDAO;
    private CustomerDAO customerDAO;
    private PasswordResetTokenDAO passwordResetTokenDao;
    private EmailService emailService;
    private AsyncEmailService asyncEmailService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        accountDAO = new AccountDAO();
        customerDAO = new CustomerDAO();
        passwordResetTokenDao = new PasswordResetTokenDAO();
        emailService = new EmailService();
        asyncEmailService = new AsyncEmailService();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if (servletPath == null) {
            request.getRequestDispatcher("/").forward(request, response);
            return;
        }

        // Check if this is an AJAX request for email validation
        String ajaxCheck = request.getParameter("ajax");
        if ("checkEmail".equals(ajaxCheck)) {
            handleAjaxEmailCheck(request, response);
            return;
        }

        switch (servletPath) {
            case "/password-reset/new":
                // Show the form to request a password reset
                request.getRequestDispatcher("/WEB-INF/view/password/password-reset-new.jsp").forward(request,
                        response);
                break;

            case "/password-reset/edit":
                // Verify the token from the email link
                handleVerifyTokenAndShowForm(request, response);
                break;

            case "/password-reset/test-email":
                handleTestEmail(request, response);
                break;

            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if (servletPath == null) {
            request.getRequestDispatcher("/").forward(request, response);
            return;
        }

        switch (servletPath) {
            case "/password-reset/request":
                // Handle the submission of the email to send the reset link
                handleResetRequest(request, response);
                break;
            case "/password-reset/update":
                // Handle the submission of the new password
                handlePasswordUpdate(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles password reset and change functionality for both Customer and User accounts";
    }

    /**
     * Handle AJAX requests to check if email exists in the system
     */
    private void handleAjaxEmailCheck(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");

        try (java.io.PrintWriter out = response.getWriter()) {
            if (email == null || email.trim().isEmpty()) {
                out.print("{\"exists\": false, \"message\": \"Email không được để trống\"}");
                return;
            }

            email = email.trim();

            // Validate email format first
            if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                out.print("{\"exists\": false, \"message\": \"Định dạng email không hợp lệ\"}");
                return;
            }

            boolean emailExists = accountDAO.isEmailTakenInSystem(email);

            if (emailExists) {
                out.print("{\"exists\": true, \"message\": \"Email tồn tại trong hệ thống\"}");
            } else {
                out.print("{\"exists\": false, \"message\": \"Email không tồn tại trong hệ thống\"}");
            }

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (java.io.PrintWriter out = response.getWriter()) {
                out.print("{\"exists\": false, \"message\": \"Lỗi hệ thống, vui lòng thử lại\"}");
            }
        }
    }

    /**
     * Handles password reset requests
     * 
     * This method has been optimized for performance by using asynchronous email
     * sending.
     * Instead of blocking the request thread waiting for email delivery (which can
     * take 5-30 seconds),
     * the email is queued for background sending, allowing immediate response to
     * the user.
     * 
     * Benefits:
     * - Faster user experience (immediate feedback)
     * - Better server performance (no blocked threads)
     * - Improved scalability (can handle more concurrent requests)
     * - Better error isolation (email failures don't affect user experience)
     */
    private void handleResetRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Read email from request parameter, which works for x-www-form-urlencoded
        String email = request.getParameter("email");
        Gson gson = new Gson();
        java.util.Map<String, String> jsonResponse = new java.util.HashMap<>();

        // If it's null, it might be a raw JSON post, so we try reading the body.
        if (email == null) {
            try (java.io.BufferedReader reader = request.getReader()) {
                java.util.Map<String, String> body = gson.fromJson(reader, java.util.Map.class);
                if (body != null) {
                    email = body.get("email");
                }
            } catch (Exception e) {
                // Ignore parsing errors, we'll handle the null email case below
            }
        }

        if (email == null || email.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.put("message", "Vui lòng nhập địa chỉ email.");
            response.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        email = email.trim();
        boolean isEmailTakenInSystem = accountDAO.isEmailTakenInSystem(email);

        if (isEmailTakenInSystem) {
            try {
                // Fetch the user's full name for email personalization
                String userName = accountDAO.getFullNameByEmail(email);

                passwordResetTokenDao.deleteTokensByEmail(email);
                PasswordResetToken passwordResetToken = new PasswordResetToken(email);
                passwordResetTokenDao.save(passwordResetToken);

                // Pass the context path to the email service
                String contextPath = request.getContextPath();
                asyncEmailService.sendPasswordResetEmailFireAndForget(email, passwordResetToken.getToken(),
                        contextPath);

                response.setStatus(HttpServletResponse.SC_OK);
                jsonResponse.put("message", "Liên kết đặt lại mật khẩu đã được gửi đến email của bạn.");
                Logger.getLogger(ResetPasswordController.class.getName()).log(Level.INFO,
                        "Password reset email queued for: " + email);

            } catch (SQLException ex) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                jsonResponse.put("message", "Lỗi cơ sở dữ liệu. Vui lòng thử lại sau.");
                Logger.getLogger(ResetPasswordController.class.getName()).log(Level.SEVERE, "DB error for " + email,
                        ex);
            } catch (Exception ex) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                jsonResponse.put("message", "Lỗi hệ thống không xác định. Vui lòng thử lại sau.");
                Logger.getLogger(ResetPasswordController.class.getName()).log(Level.SEVERE,
                        "Unexpected error for " + email, ex);
            }
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            jsonResponse.put("message", "Email không tồn tại trong hệ thống.");
            Logger.getLogger(ResetPasswordController.class.getName()).log(Level.INFO,
                    "Reset attempt for non-existent email: " + email);
        }

        response.getWriter().write(gson.toJson(jsonResponse));
    }

    /**
     * Verifies the token from the email link and shows the password change form.
     * Renamed from handleVerifyResetToken for clarity.
     */
    private void handleVerifyTokenAndShowForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");

        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Token không hợp lệ hoặc bị thiếu.");
            request.getRequestDispatcher("/WEB-INF/view/password/password-reset-new.jsp").forward(request,
                    response);
            return;
        }

        try {
            // Verify token
            PasswordResetToken resetToken = passwordResetTokenDao.findByToken(token.trim());
            if (resetToken == null || resetToken.isExpired()) {
                request.setAttribute("error", "Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
                request.getRequestDispatcher("/WEB-INF/view/password/password-reset-new.jsp").forward(request,
                        response);
                return;
            }

            // Determine account type and store both email and account type in session
            String email = resetToken.getUserEmail();

            boolean isEmailTakenInSystem = accountDAO.isEmailTakenInSystem(email);

            if (!isEmailTakenInSystem) {
                request.setAttribute("error", "Tài khoản không tồn tại trong hệ thống.");
                request.getRequestDispatcher("/WEB-INF/view/password/password-reset-new.jsp").forward(request,
                        response);
                return;
            }

            // Store both email and account type in session
            request.getSession().setAttribute("resetEmail", email);

            request.getRequestDispatcher("/WEB-INF/view/password/password-reset-edit.jsp").forward(request, response);

        } catch (SQLException ex) {
            Logger.getLogger(ResetPasswordController.class.getName()).log(Level.SEVERE,
                    "Database error while verifying token: " + token, ex);
            request.setAttribute("error", "Có lỗi hệ thống xảy ra. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/WEB-INF/view/password/password-reset-new.jsp").forward(request,
                    response);
        }
    }

    /**
     * Handles the submission of the new password.
     * Renamed from handleChangePassword for clarity.
     */
    private void handlePasswordUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Gson gson = new Gson();
        java.util.Map<String, String> jsonResponse = new java.util.HashMap<>();

        String email = (String) request.getSession().getAttribute("resetEmail");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (email == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.put("error", "Phiên đặt lại mật khẩu không hợp lệ. Vui lòng thử lại.");
            jsonResponse.put("redirect", "/spa/password/reset");
            response.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.put("error", "Mật khẩu mới và xác nhận mật khẩu không khớp.");
            response.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        // Validate password length
        if (newPassword.length() < 6) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.put("error", "Mật khẩu phải có ít nhất 6 ký tự.");
            response.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        try {
            // Validate that new password is different from current password
            String currentPasswordHash = accountDAO.getPasswordHashByEmail(email);

            if (currentPasswordHash != null && !currentPasswordHash.isEmpty()) {
                if (BCrypt.checkpw(newPassword, currentPasswordHash)) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    jsonResponse.put("error", "Mật khẩu mới phải khác với mật khẩu hiện tại.");
                    response.getWriter().write(gson.toJson(jsonResponse));
                    return;
                }
            }

            // Update password for the user. The DAO method should handle both customers and
            // users.
            boolean updated = accountDAO.updatePassword(email, newPassword);

            if (updated) {
                // Clean up: remove tokens and session data
                passwordResetTokenDao.deleteTokensByEmail(email);
                request.getSession().removeAttribute("resetEmail");

                String successMessage = "Mật khẩu đã được thay đổi thành công. Vui lòng đăng nhập bằng mật khẩu mới.";
                jsonResponse.put("success", successMessage);
                jsonResponse.put("redirect", "/spa/login");

                Logger.getLogger(ResetPasswordController.class.getName()).log(
                        Level.INFO, "Password successfully reset for email: " + email);

                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(gson.toJson(jsonResponse));
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                jsonResponse.put("error", "Có lỗi khi cập nhật mật khẩu. Vui lòng thử lại.");
                response.getWriter().write(gson.toJson(jsonResponse));
            }
        } catch (SQLException ex) {
            Logger.getLogger(ResetPasswordController.class.getName()).log(Level.SEVERE,
                    "Database error while changing password for email: " + email, ex);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.put("error", "Có lỗi hệ thống xảy ra. Vui lòng thử lại sau.");
            response.getWriter().write(gson.toJson(jsonResponse));
        }
    }

    private void handleTestEmail(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Gson gson = new Gson();
        java.util.Map<String, String> jsonResponse = new java.util.HashMap<>();

        String testEmail = request.getParameter("email");
        if (testEmail == null || testEmail.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.put("error", "Please provide an 'email' parameter for testing.");
            response.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        try {
            String userName = accountDAO.getFullNameByEmail(testEmail);
            if (userName == null) {
                userName = "Test User"; // Fallback name
            }

            // Use the synchronous service for direct feedback
            boolean success = emailService.sendPasswordResetEmail(testEmail, "test-token-12345", userName);

            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
                jsonResponse.put("message", "Test email sent successfully to " + testEmail);
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                jsonResponse.put("error", "Failed to send test email. Check server logs for details.");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.put("error", "An exception occurred: " + e.getMessage());
            Logger.getLogger(ResetPasswordController.class.getName()).log(Level.SEVERE, "Error sending test email", e);
        }

        response.getWriter().write(gson.toJson(jsonResponse));
    }
}