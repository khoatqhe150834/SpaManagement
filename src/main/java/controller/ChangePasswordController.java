/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.AccountDAO;
import dao.CustomerDAO;
import dao.RememberMeTokenDAO;
import dao.UserDAO;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import model.Customer;
import model.User;
import model.RememberMeToken;

/**
 * Controller for changing password in user profile
 * Requires user to be authenticated and provide current password
 */
@WebServlet(name = "ChangePasswordController", urlPatterns = { "/password/change" })
public class ChangePasswordController extends HttpServlet {

    private CustomerDAO customerDAO;
    private UserDAO userDAO;
    private AccountDAO accountDAO;
    private RememberMeTokenDAO rememberMeTokenDAO;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        customerDAO = new CustomerDAO();
        userDAO = new UserDAO();
        accountDAO = new AccountDAO();
        rememberMeTokenDAO = new RememberMeTokenDAO();
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     * Shows the change password form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Direct access to GET is not intended for this logic, redirect to reset form
        request.getRequestDispatcher("/WEB-INF/view/password/change-password-form.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * Processes the password change request
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get user info from request attributes (set by AuthenticationFilter)
        User user = (User) request.getAttribute("currentUser");
        Customer customer = (Customer) request.getAttribute("currentCustomer");

        // AuthenticationFilter ensures user is authenticated, so either user or
        // customer will be non-null
        Object account = customer != null ? customer : user;

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Basic validation
        if (currentPassword == null || currentPassword.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mật khẩu hiện tại.");
            request.getRequestDispatcher("/WEB-INF/view/password/change-password-form.jsp").forward(request,
                    response);
            return;
        }

        if (newPassword == null || newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự.");
            request.getRequestDispatcher("/WEB-INF/view/password/change-password-form.jsp").forward(request,
                    response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("/WEB-INF/view/password/change-password-form.jsp").forward(request,
                    response);
            return;
        }

        try {
            // Get the authenticated user's email and type
            String userEmail = null;
            boolean isCustomer = customer != null;

            if (isCustomer) {
                userEmail = customer.getEmail();
            } else {
                userEmail = user.getEmail();
            }

            boolean success = false;
            if (isCustomer) {
                success = handleCustomerPasswordChange(customer, currentPassword, newPassword, request);
            } else {
                success = handleUserPasswordChange(user, currentPassword, newPassword, request);
            }

            if (success) {
                // update up remember me data
                updateRememberMeData(userEmail, request, response);

                // Set success message and redirect
                HttpSession session = request.getSession();
                session.setAttribute("flash_success", "Mật khẩu của bạn đã được thay đổi thành công!");

                request.getRequestDispatcher("/WEB-INF/view/common/dashboard.jsp").forward(request, response);

            } else {
                // Error message is set by the handle methods
                request.getRequestDispatcher("/WEB-INF/view/password/change-password-form.jsp").forward(request,
                        response);
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Có lỗi xảy ra khi thay đổi mật khẩu. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/WEB-INF/view/password/change-password-form.jsp").forward(request,
                    response);
        }
    }

    /**
     * Handle password change for staff/admin users
     */
    private boolean handleUserPasswordChange(User user, String currentPassword, String newPassword,
            HttpServletRequest request) throws SQLException {
        // Verify current password by attempting login (similar to LoginController)
        User verifyUser = userDAO.getUserByEmailAndPassword(user.getEmail(), currentPassword);
        if (verifyUser == null) {
            request.setAttribute("error", "Mật khẩu hiện tại không đúng.");
            return false;
        }

        // Update password
        boolean success = accountDAO.updateUserPassword(user.getEmail(), newPassword);
        if (!success) {
            request.setAttribute("error", "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
            return false;
        }

        return true;
    }

    private boolean handleCustomerPasswordChange(Customer customer, String currentPassword, String newPassword,
            HttpServletRequest request) throws SQLException {
        // Verify current password by attempting login (similar to LoginController)
        Customer verifyCustomer = customerDAO.getCustomerByEmailAndPassword(customer.getEmail(), currentPassword);
        if (verifyCustomer == null) {
            request.setAttribute("error", "Mật khẩu hiện tại không đúng.");
            return false;
        }

        // Update password
        boolean success = accountDAO.updateCustomerPassword(customer.getEmail(), newPassword);
        if (!success) {
            request.setAttribute("error", "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
            return false;
        }

        return true;
    }

    /**
     * Update or clean up remember me tokens and cookies when password is changed
     * If user has Remember Me enabled, update the token with new password
     * Otherwise, delete the token
     */
    private void updateRememberMeData(String email, HttpServletRequest request, HttpServletResponse response) {
        try {
            Cookie rememberMeCookie = null;
            String existingToken = null;

            // Find existing remember me cookie
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("rememberedUser".equals(cookie.getName())) {
                        rememberMeCookie = cookie;
                        existingToken = cookie.getValue();
                        break;
                    }
                }
            }

            // If user has an active remember me cookie
            if (rememberMeCookie != null && existingToken != null && !existingToken.isEmpty()) {
                try {
                    // Get the existing token from database
                    RememberMeToken token = rememberMeTokenDAO.findToken(existingToken);
                    if (token != null) {
                        // Update the token with the new password
                        token.setPassword(request.getParameter("newPassword"));
                        rememberMeTokenDAO.deleteToken(existingToken); // Delete old token
                        rememberMeTokenDAO.insertToken(token); // Insert updated token
                        return; // Token updated successfully, no need to delete
                    }
                } catch (SQLException ex) {
                    // Log error but continue with deletion as fallback
                    System.out.println("Error updating remember me token: " + ex.getMessage());
                }
            }

            // If no active token or update failed, delete all tokens
            rememberMeTokenDAO.deleteTokensByEmail(email);

            // Remove cookie if it exists
            if (rememberMeCookie != null) {
                Cookie deleteCookie = new Cookie("rememberedUser", "");
                deleteCookie.setMaxAge(0);
                deleteCookie.setPath("/");
                deleteCookie.setHttpOnly(true);
                deleteCookie.setSecure(request.isSecure());
                response.addCookie(deleteCookie);
            }

        } catch (Exception e) {
            // Log error but don't break the password change process
            System.out.println("Error handling remember me data: " + e.getMessage());
        }
    }

    @Override
    public String getServletInfo() {
        return "Profile Password Change Controller";
    }
}
