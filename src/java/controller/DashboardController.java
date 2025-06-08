package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;
import model.Customer;

/**
 * Dashboard Controller for admin/user dashboard
 */
@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard", "/", "/index"})
public class DashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || !Boolean.TRUE.equals(session.getAttribute("authenticated"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user from session
        User user = (User) session.getAttribute("user");
        Customer customer = (Customer) session.getAttribute("customer");

        if (user != null) {
            // Admin/Staff user - show admin dashboard
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/dashboard.jsp").forward(request, response);
        } else if (customer != null) {
            // Customer user - show customer dashboard  
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/WEB-INF/view/customer/dashboard.jsp").forward(request, response);
        } else {
            // No valid user found, redirect to login
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 