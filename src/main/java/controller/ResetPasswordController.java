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
@WebServlet(name = "ResetPasswordController", urlPatterns = { "/reset-password", "/change-password",
        "/verify-reset-token" })
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
            case "/reset-password":
                request.getRequestDispatcher("/WEB-INF/view/password/reset-password.jsp").forward(request, response);
                break;
            case "/change-password":
                request.getRequestDispatcher("/WEB-INF/view/password/change-password.jsp").forward(request, response);
                break;
            case "/verify-reset-token":
                handleVerifyResetToken(request, response);
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
            case "/reset-password":
                handleResetPassword(request, response);
                break;
            case "/change-password":
                handleChangePassword(request, response);
                break;
            default:
                throw new AssertionError();
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
    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        Gson gson = new Gson();
        java.util.Map<String, String> jsonResponse = new java.util.HashMap<>();

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
                passwordResetTokenDao.deleteTokensByEmail(email);
                PasswordResetToken passwordResetToken = new PasswordResetToken(email);
                passwordResetTokenDao.save(passwordResetToken);

                asyncEmailService.sendPasswordResetEmailFireAndForget(email, passwordResetToken.getToken(),
                        request.getContextPath());

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

    private void handleVerifyResetToken(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");

        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Token không hợp lệ hoặc bị thiếu.");
            request.getRequestDispatcher("/WEB-INF/view/password/reset-password.jsp").forward(request, response);
            return;
        }

        try {
            // Verify token
            PasswordResetToken resetToken = passwordResetTokenDao.findByToken(token.trim());
            if (resetToken == null || resetToken.isExpired()) {
                request.setAttribute("error", "Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
                request.getRequestDispatcher("/WEB-INF/view/password/reset-password.jsp").forward(request, response);
                return;
            }

            // Determine account type and store both email and account type in session
            String email = resetToken.getUserEmail();

            boolean isEmailTakenInSystem = accountDAO.isEmailTakenInSystem(email);

            if (!isEmailTakenInSystem) {
                request.setAttribute("error", "Tài khoản không tồn tại trong hệ thống.");
                request.getRequestDispatcher("/WEB-INF/view/password/reset-password.jsp").forward(request, response);
                return;
            }

            // Store both email and account type in session
            request.getSession().setAttribute("resetEmail", email);

            request.getRequestDispatcher("/WEB-INF/view/password/change-password.jsp").forward(request, response);

        } catch (SQLException ex) {
            Logger.getLogger(ResetPasswordController.class.getName()).log(Level.SEVERE,
                    "Database error while verifying token: " + token, ex);
            request.setAttribute("error", "Có lỗi hệ thống xảy ra. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/WEB-INF/view/password/reset-password.jsp").forward(request, response);
        }
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = (String) request.getSession().getAttribute("resetEmail");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (email == null) {
            request.setAttribute("error", "Phiên đặt lại mật khẩu không hợp lệ. Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/view/password/reset-password.jsp").forward(request, response);
            return;
        }

        if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu mới và xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("/WEB-INF/view/password/change-password.jsp").forward(request, response);
            return;
        }

        // Validate password length
        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự.");
            request.getRequestDispatcher("/WEB-INF/view/password/change-password.jsp").forward(request, response);
            return;
        }

        try {
            // Validate that new password is different from current password
            String currentPasswordHash = null;
            boolean isCustomer = false;

            if (accountDAO.isCustomerEmailExists(email)) {
                currentPasswordHash = accountDAO.getCustomerPasswordHash(email);
                isCustomer = true;
            } else if (accountDAO.isUserEmailExists(email)) {
                currentPasswordHash = accountDAO.getUserPasswordHash(email);
                isCustomer = false;
            }

            // Check if new password is the same as current password
            if (currentPasswordHash != null && BCrypt.checkpw(newPassword, currentPasswordHash)) {
                request.setAttribute("error",
                        "Mật khẩu mới phải khác với mật khẩu hiện tại. Vui lòng chọn mật khẩu khác.");
                request.getRequestDispatcher("/WEB-INF/view/password/change-password.jsp").forward(request, response);
                return;
            }

            boolean updated = false;

            // Update password based on account type
            if (isCustomer) {
                updated = accountDAO.updateCustomerPassword(email, newPassword);
            } else {
                updated = accountDAO.updateUserPassword(email, newPassword);
            }

            if (updated) {
                // Clean up: remove tokens and session data
                passwordResetTokenDao.deleteTokensByEmail(email);
                request.getSession().removeAttribute("resetEmail");

                String successMessage = "Mật khẩu đã được thay đổi thành công. Vui lòng đăng nhập bằng mật khẩu mới.";
                request.setAttribute("success", successMessage);

                Logger.getLogger(ResetPasswordController.class.getName()).log(
                        Level.INFO, "Password successfully reset for email: " + email);

                // Redirect to login page
                request.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Có lỗi khi cập nhật mật khẩu. Vui lòng thử lại.");
                request.getRequestDispatcher("/WEB-INF/view/password/change-password.jsp").forward(request, response);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ResetPasswordController.class.getName()).log(Level.SEVERE,
                    "Database error while changing password for email: " + email, ex);
            request.setAttribute("error", "Có lỗi hệ thống xảy ra. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/WEB-INF/view/password/change-password.jsp").forward(request, response);
        }
    }
}