/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nb://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import dao.PasswordResetTokenDAO;
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
import service.email.PasswordResetToken;

/**
 *
 * @author quang
 */
@WebServlet(name = "PasswordController", urlPatterns = { "/reset-password", "/change-password", "/verify-reset-token" })
public class PasswordController extends HttpServlet {

    private CustomerDAO customerDAO;
    private PasswordResetTokenDAO passwordResetTokenDao;
    private EmailService emailService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        customerDAO = new CustomerDAO();
        passwordResetTokenDao = new PasswordResetTokenDAO();
        emailService = new EmailService();
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
                request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
                break;
            case "/change-password":
                request.getRequestDispatcher("/change-password.jsp").forward(request, response);
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
        return "Handles password reset and change functionality";
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập địa chỉ email");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }

        email = email.trim();

        boolean isExistsByEmail = customerDAO.isExistsByEmail(email);

        if (isExistsByEmail) {
            try {
                passwordResetTokenDao.deleteTokensByEmail(email);
                PasswordResetToken passwordResetToken = new PasswordResetToken(email);
                passwordResetTokenDao.save(passwordResetToken);

                // Generate the full reset link

                boolean emailSent = emailService.sendPasswordResetEmail(email, passwordResetToken.getToken(), null);

                if (emailSent) {
                    String successMessage = "Liên kết đặt lại mật khẩu đã được gửi đến email của bạn. " +
                            "Vui lòng kiểm tra hộp thư và làm theo hướng dẫn.";
                    request.setAttribute("success", successMessage);
                    Logger.getLogger(PasswordController.class.getName()).log(
                            Level.INFO, "Password reset email sent successfully to: " + email);
                } else {
                    String errorMessage = "Có lỗi xảy ra khi gửi email. Vui lòng thử lại sau hoặc liên hệ hỗ trợ.";
                    request.setAttribute("error", errorMessage);
                    Logger.getLogger(PasswordController.class.getName()).log(
                            Level.WARNING, "Failed to send password reset email to: " + email);
                }
            } catch (SQLException ex) {
                Logger.getLogger(PasswordController.class.getName()).log(Level.SEVERE,
                        "Database error while processing password reset for email: " + email, ex);
                request.setAttribute("error", "Có lỗi hệ thống xảy ra. Vui lòng thử lại sau.");
            } catch (Exception ex) {
                Logger.getLogger(PasswordController.class.getName()).log(Level.SEVERE,
                        "Unexpected error while processing password reset for email: " + email, ex);
                request.setAttribute("error", "Có lỗi không xác định xảy ra. Vui lòng thử lại sau.");
            }
        } else {
            String error = "Email không tồn tại trong hệ thống. Vui lòng kiểm tra lại địa chỉ email.";
            request.setAttribute("error", error);
            Logger.getLogger(PasswordController.class.getName()).log(
                    Level.INFO, "Password reset attempted for non-existent email: " + email);
        }

        request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
    }

    private void handleVerifyResetToken(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");

        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Token không hợp lệ hoặc bị thiếu.");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }

        try {
            // Verify token
            PasswordResetToken resetToken = passwordResetTokenDao.findByToken(token.trim());
            if (resetToken == null || resetToken.isExpired()) {
                request.setAttribute("error", "Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
                request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
                return;
            }

            // Token valid, store email in session and redirect to change password page
            request.getSession().setAttribute("resetEmail", resetToken.getUserEmail());
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);

        } catch (SQLException ex) {
            Logger.getLogger(PasswordController.class.getName()).log(Level.SEVERE,
                    "Database error while verifying token: " + token, ex);
            request.setAttribute("error", "Có lỗi hệ thống xảy ra. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
        }
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = (String) request.getSession().getAttribute("resetEmail");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (email == null) {
            request.setAttribute("error", "Phiên đặt lại mật khẩu không hợp lệ. Vui lòng thử lại.");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }

        if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu mới và xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }

        try {
            // Update password in database
            boolean updated = customerDAO.updatePassword(email, newPassword);
            if (updated) {
                // Clean up tokens and session
                passwordResetTokenDao.deleteTokensByEmail(email);
                request.getSession().removeAttribute("resetEmail");

                request.setAttribute("success", "Mật khẩu đã được thay đổi thành công. Vui lòng đăng nhập.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Có lỗi khi cập nhật mật khẩu. Vui lòng thử lại.");
                request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            }
        } catch (SQLException ex) {
            Logger.getLogger(PasswordController.class.getName()).log(Level.SEVERE,
                    "Database error while changing password for email: " + email, ex);
            request.setAttribute("error", "Có lỗi hệ thống xảy ra. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
        }
    }
}