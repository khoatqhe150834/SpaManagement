/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.CustomerDAO;
import dao.UserDAO;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import model.Customer;
import model.User;

/**
 * Controller for changing password in user profile
 * Requires user to be authenticated and provide current password
 */
@WebServlet(name = "ChangePasswordController", urlPatterns = { "/profile/change-password" })
public class ChangePasswordController extends HttpServlet {

    private CustomerDAO customerDAO;
    private UserDAO userDAO;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        customerDAO = new CustomerDAO();
        userDAO = new UserDAO();
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     * Shows the change password form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is authenticated
        HttpSession session = request.getSession(false);
        if (session == null || !Boolean.TRUE.equals(session.getAttribute("authenticated"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Forward to change password page
        request.getRequestDispatcher("/WEB-INF/view/password/change-profile-password.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * Processes the password change request
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is authenticated
        HttpSession session = request.getSession(false);
        if (session == null || !Boolean.TRUE.equals(session.getAttribute("authenticated"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get form parameters
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate input
        if (currentPassword == null || currentPassword.trim().isEmpty() ||
                newPassword == null || newPassword.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "Tất cả các trường đều bắt buộc.");
            request.getRequestDispatcher("/WEB-INF/view/password/change-profile-password.jsp").forward(request,
                    response);
            return;
        }

        // Check if new passwords match
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu mới và xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("/WEB-INF/view/password/change-profile-password.jsp").forward(request,
                    response);
            return;
        }

        // Validate new password length
        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự.");
            request.getRequestDispatcher("/WEB-INF/view/password/change-profile-password.jsp").forward(request,
                    response);
            return;
        }

        try {
            // Determine if user is staff or customer (similar to LoginController logic)
            User user = (User) session.getAttribute("user");
            Customer customer = (Customer) session.getAttribute("customer");

            if (user != null) {
                // Handle staff/admin password change
                if (handleUserPasswordChange(user, currentPassword, newPassword, request)) {
                    request.setAttribute("success", "Mật khẩu đã được thay đổi thành công!");
                }
            } else if (customer != null) {
                // Handle customer password change
                if (handleCustomerPasswordChange(customer, currentPassword, newPassword, request)) {
                    request.setAttribute("success", "Mật khẩu đã được thay đổi thành công!");
                }
            } else {
                // No valid user found in session
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

        } catch (SQLException e) {
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau.");
            e.printStackTrace();
        }

        request.getRequestDispatcher("/WEB-INF/view/password/change-profile-password.jsp").forward(request, response);
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
        boolean success = userDAO.updatePassword(user.getEmail(), newPassword);
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
        boolean success = customerDAO.updatePassword(customer.getEmail(), newPassword);
        if (!success) {
            request.setAttribute("error", "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
            return false;
        }

        return true;
    }

    @Override
    public String getServletInfo() {
        return "Profile Password Change Controller";
    }
}
