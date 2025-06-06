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
import service.email.PasswordResetToken;

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
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập địa chỉ email");
            request.getRequestDispatcher("/WEB-INF/view/password/reset-password.jsp").forward(request, response);
            return;
        }

        email = email.trim();

        // Use AccountDAO to check if email exists in either table
        boolean isEmailTakenInSystem = accountDAO.isEmailTakenInSystem(email);

        if (isEmailTakenInSystem) {
            try {
                passwordResetTokenDao.deleteTokensByEmail(email);
                PasswordResetToken passwordResetToken = new PasswordResetToken(email);
                passwordResetTokenDao.save(passwordResetToken);

                // Send email asynchronously to avoid blocking the request
                asyncEmailService.sendPasswordResetEmailFireAndForget(email, passwordResetToken.getToken(),
                        request.getContextPath());

                // Immediately show success message to user without waiting for email
                String successMessage = "Liên kết đặt lại mật khẩu đã được gửi đến email của bạn. " +
                        "Vui lòng kiểm tra hộp thư và làm theo hướng dẫn. " +
                        "Nếu không thấy email, vui lòng kiểm tra thư mục spam.";
                request.setAttribute("success", successMessage);

                Logger.getLogger(ResetPasswordController.class.getName()).log(
                        Level.INFO, "Password reset email queued for sending to: " + email);
            } catch (SQLException ex) {
                Logger.getLogger(ResetPasswordController.class.getName()).log(Level.SEVERE,
                        "Database error while processing password reset for email: " + email, ex);
                request.setAttribute("error", "Có lỗi hệ thống xảy ra. Vui lòng thử lại sau.");
            } catch (Exception ex) {
                Logger.getLogger(ResetPasswordController.class.getName()).log(Level.SEVERE,
                        "Unexpected error while processing password reset for email: " + email, ex);
                request.setAttribute("error", "Có lỗi không xác định xảy ra. Vui lòng thử lại sau.");
            }
        } else {
            String error = "Email không tồn tại trong hệ thống. Vui lòng kiểm tra lại địa chỉ email.";
            request.setAttribute("error", error);
            Logger.getLogger(ResetPasswordController.class.getName()).log(
                    Level.INFO, "Password reset attempted for non-existent email: " + email);
        }

        request.getRequestDispatcher("/WEB-INF/view/password/reset-password.jsp").forward(request, response);
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
            boolean updated = false;

            // Update password based on account type
            if (accountDAO.isCustomerEmailExists(email)) {
                updated = accountDAO.updateCustomerPassword(email, newPassword);
            } else if (accountDAO.isUserEmailExists(email)) {
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