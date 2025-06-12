package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

/**
 * Manager Dashboard Controller
 * Handles all manager dashboard related routes and pages
 * URL Pattern: /manager-dashboard/*
 */
@WebServlet(name = "ManagerDashboardController", urlPatterns = { "/manager-dashboard/*" })
public class ManagerDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in and has manager role
        HttpSession session = request.getSession(false);
        if (session == null || !Boolean.TRUE.equals(session.getAttribute("authenticated"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user from session and check role
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // TODO: Add proper role checking for manager access
        // For now, allow any authenticated user

        // Set user attribute for JSP access
        request.setAttribute("user", user);

        // Get the path info to determine which page to show
        String path = request.getPathInfo();

        try {
            if (path == null || path.equals("/") || path.equals("/dashboard")) {
                // Main dashboard page
                handleMainDashboard(request, response);
            } else if (path.startsWith("/customers")) {
                // Customer management pages
                handleCustomerManagement(request, response, path);
            } else if (path.startsWith("/services")) {
                // Service management pages
                handleServiceManagement(request, response, path);
            } else if (path.startsWith("/staff")) {
                // Staff management pages
                handleStaffManagement(request, response, path);
            } else if (path.startsWith("/reports")) {
                // Reports pages
                handleReports(request, response, path);
            } else if (path.startsWith("/dashboard")) {
                // Dashboard sub-pages
                handleDashboardSubPages(request, response, path);
            } else {
                // Default to main dashboard
                handleMainDashboard(request, response);
            }
        } catch (Exception e) {
            // Log error and show error page
            request.setAttribute("error", "Đã xảy ra lỗi khi tải trang: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/common/error.jsp").forward(request, response);
        }
    }

    /**
     * Handle main dashboard page
     */
    private void handleMainDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: Load dashboard data (revenue overview, appointment statistics,
        // notifications)
        request.getRequestDispatcher("/WEB-INF/view/manager/dashboard/dashboard.jsp").forward(request, response);
    }

    /**
     * Handle customer management pages
     */
    private void handleCustomerManagement(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        if (path.equals("/customers/list")) {
            // TODO: Load customer list with manager-specific data
            request.getRequestDispatcher("/WEB-INF/view/manager/customers/list.jsp").forward(request, response);
        } else if (path.equals("/customers/categories")) {
            // TODO: Load customer categories (VIP, regular, new)
            request.getRequestDispatcher("/WEB-INF/view/manager/customers/categories.jsp").forward(request, response);
        } else if (path.equals("/customers/history")) {
            // TODO: Load customer service usage history
            request.getRequestDispatcher("/WEB-INF/view/manager/customers/history.jsp").forward(request, response);
        } else if (path.equals("/customers/notes")) {
            // TODO: Load customer special notes
            request.getRequestDispatcher("/WEB-INF/view/manager/customers/notes.jsp").forward(request, response);
        } else {
            // Default to customer list
            request.getRequestDispatcher("/WEB-INF/view/manager/customers/list.jsp").forward(request, response);
        }
    }

    /**
     * Handle service management pages
     */
    private void handleServiceManagement(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        if (path.equals("/services/packages")) {
            // TODO: Load service packages management
            request.getRequestDispatcher("/WEB-INF/view/manager/services/packages.jsp").forward(request, response);
        } else if (path.equals("/services/pricing")) {
            // TODO: Load pricing and promotions management
            request.getRequestDispatcher("/WEB-INF/view/manager/services/pricing.jsp").forward(request, response);
        } else if (path.equals("/services/media")) {
            // TODO: Load media and descriptions management
            request.getRequestDispatcher("/WEB-INF/view/manager/services/media.jsp").forward(request, response);
        } else if (path.equals("/services/analytics")) {
            // TODO: Load service analytics and popular services
            request.getRequestDispatcher("/WEB-INF/view/manager/services/analytics.jsp").forward(request, response);
        } else {
            // Default to packages
            request.getRequestDispatcher("/WEB-INF/view/manager/services/packages.jsp").forward(request, response);
        }
    }

    /**
     * Handle staff management pages
     */
    private void handleStaffManagement(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        if (path.equals("/staff/list")) {
            // TODO: Load staff list and details
            request.getRequestDispatcher("/WEB-INF/view/manager/staff/list.jsp").forward(request, response);
        } else if (path.equals("/staff/schedules")) {
            // TODO: Load work schedules management
            request.getRequestDispatcher("/WEB-INF/view/manager/staff/schedules.jsp").forward(request, response);
        } else if (path.equals("/staff/performance")) {
            // TODO: Load performance statistics
            request.getRequestDispatcher("/WEB-INF/view/manager/staff/performance.jsp").forward(request, response);
        } else if (path.equals("/staff/assignments")) {
            // TODO: Load work assignments
            request.getRequestDispatcher("/WEB-INF/view/manager/staff/assignments.jsp").forward(request, response);
        } else {
            // Default to staff list
            request.getRequestDispatcher("/WEB-INF/view/manager/staff/list.jsp").forward(request, response);
        }
    }

    /**
     * Handle reports pages
     */
    private void handleReports(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        if (path.equals("/reports/revenue")) {
            // TODO: Load detailed revenue reports
            request.getRequestDispatcher("/WEB-INF/view/manager/reports/revenue.jsp").forward(request, response);
        } else if (path.equals("/reports/customers")) {
            // TODO: Load customer statistics
            request.getRequestDispatcher("/WEB-INF/view/manager/reports/customers.jsp").forward(request, response);
        } else if (path.equals("/reports/trends")) {
            // TODO: Load service trend analysis
            request.getRequestDispatcher("/WEB-INF/view/manager/reports/trends.jsp").forward(request, response);
        } else if (path.equals("/reports/reviews")) {
            // TODO: Load customer reviews analysis
            request.getRequestDispatcher("/WEB-INF/view/manager/reports/reviews.jsp").forward(request, response);
        } else {
            // Default to revenue reports
            request.getRequestDispatcher("/WEB-INF/view/manager/reports/revenue.jsp").forward(request, response);
        }
    }

    /**
     * Handle dashboard sub-pages
     */
    private void handleDashboardSubPages(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        if (path.equals("/dashboard/revenue")) {
            // TODO: Load revenue overview
            request.getRequestDispatcher("/WEB-INF/view/manager/dashboard/revenue.jsp").forward(request, response);
        } else if (path.equals("/dashboard/appointments")) {
            // TODO: Load appointment statistics
            request.getRequestDispatcher("/WEB-INF/view/manager/dashboard/appointments.jsp").forward(request, response);
        } else if (path.equals("/dashboard/notifications")) {
            // TODO: Load important notifications
            request.getRequestDispatcher("/WEB-INF/view/manager/dashboard/notifications.jsp").forward(request,
                    response);
        } else {
            // Default to main dashboard
            handleMainDashboard(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in and has manager role
        HttpSession session = request.getSession(false);
        if (session == null || !Boolean.TRUE.equals(session.getAttribute("authenticated"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user from session
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Set user attribute for JSP access
        request.setAttribute("user", user);

        // Get the path info to determine which action to handle
        String path = request.getPathInfo();

        try {
            if (path != null && path.startsWith("/services")) {
                // Handle service management updates
                handleServiceUpdates(request, response, path);
            } else if (path != null && path.startsWith("/staff")) {
                // Handle staff management updates
                handleStaffUpdates(request, response, path);
            } else if (path != null && path.startsWith("/customers")) {
                // Handle customer management updates
                handleCustomerUpdates(request, response, path);
            } else {
                // For other POST requests, redirect to GET
                doGet(request, response);
            }
        } catch (Exception e) {
            // Log error and show error page
            request.setAttribute("error", "Đã xảy ra lỗi khi xử lý yêu cầu: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/common/error.jsp").forward(request, response);
        }
    }

    /**
     * Handle service management updates
     */
    private void handleServiceUpdates(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement service updates (packages, pricing, media)
        // For now, redirect back to the appropriate page
        doGet(request, response);
    }

    /**
     * Handle staff management updates
     */
    private void handleStaffUpdates(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement staff updates (schedules, assignments, performance)
        // For now, redirect back to the appropriate page
        doGet(request, response);
    }

    /**
     * Handle customer management updates
     */
    private void handleCustomerUpdates(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement customer updates (notes, categories)
        // For now, redirect back to the appropriate page
        doGet(request, response);
    }
}
