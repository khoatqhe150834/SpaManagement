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
import model.RoleConstants;

/**
 * Unified Dashboard Controller
 * Handles all dashboard routes for different user roles
 * URL Patterns: /admin-dashboard/*, /manager-dashboard/*,
 * /therapist-dashboard/*,
 * /receptionist-dashboard/*, /customer-dashboard/*
 */
@WebServlet(name = "DashboardController", urlPatterns = {
        "/admin-dashboard/*",
        "/manager-dashboard/*",
        "/therapist-dashboard/*",
        "/receptionist-dashboard/*",
        "/customer-dashboard/*"
})
public class DashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || !Boolean.TRUE.equals(session.getAttribute("authenticated"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Determine user type and role
        User user = (User) session.getAttribute("user");
        Customer customer = (Customer) session.getAttribute("customer");

        String userRole = null;
        Integer roleId = null;
        String basePath = null;

        if (user != null) {
            roleId = user.getRoleId();
            userRole = getUserRoleFromId(roleId);
            basePath = userRole.toLowerCase();
            request.setAttribute("user", user);
            request.setAttribute("userDisplayName", user.getFullName());
        } else if (customer != null) {
            roleId = RoleConstants.CUSTOMER_ID;
            userRole = "CUSTOMER";
            basePath = "customer";
            request.setAttribute("customer", customer);
            request.setAttribute("userDisplayName", customer.getFullName());
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Set common attributes
        request.setAttribute("userRole", userRole);
        request.setAttribute("roleId", roleId);

        // Get servlet path to determine which dashboard
        String servletPath = request.getServletPath();
        String pathInfo = request.getPathInfo();

        // Validate user has access to this dashboard
        if (!isAuthorizedForDashboard(servletPath, userRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này");
            return;
        }

        try {
            // Route to appropriate handler based on role
            switch (userRole) {
                case "ADMIN":
                    handleAdminDashboard(request, response, pathInfo);
                    break;
                case "MANAGER":
                    handleManagerDashboard(request, response, pathInfo);
                    break;
                case "THERAPIST":
                    handleTherapistDashboard(request, response, pathInfo);
                    break;
                case "RECEPTIONIST":
                    handleReceptionistDashboard(request, response, pathInfo);
                    break;
                case "CUSTOMER":
                    handleCustomerDashboard(request, response, pathInfo);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Role không hợp lệ");
                    return;
            }
        } catch (Exception e) {
            request.setAttribute("error", "Đã xảy ra lỗi khi tải trang: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/common/error.jsp").forward(request, response);
        }
    }

    /**
     * Handle Admin Dashboard routes
     */
    private void handleAdminDashboard(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {

        if (path == null || path.equals("/") || path.equals("/dashboard")) {
            request.getRequestDispatcher("/WEB-INF/view/admin/dashboard/dashboard.jsp").forward(request, response);
        } else if (path.startsWith("/users")) {
            handleAdminUsers(request, response, path);
        } else if (path.startsWith("/customers")) {
            handleAdminCustomers(request, response, path);
        } else if (path.startsWith("/staff")) {
            handleAdminStaff(request, response, path);
        } else if (path.startsWith("/services")) {
            handleAdminServices(request, response, path);
        } else if (path.startsWith("/bookings")) {
            handleAdminBookings(request, response, path);
        } else if (path.startsWith("/financial")) {
            handleAdminFinancial(request, response, path);
        } else if (path.startsWith("/marketing")) {
            handleAdminMarketing(request, response, path);
        } else if (path.startsWith("/content")) {
            handleAdminContent(request, response, path);
        } else if (path.startsWith("/reports")) {
            handleAdminReports(request, response, path);
        } else if (path.startsWith("/security")) {
            handleAdminSecurity(request, response, path);
        } else if (path.startsWith("/system")) {
            handleAdminSystem(request, response, path);
        } else {
            request.getRequestDispatcher("/WEB-INF/view/admin/dashboard/dashboard.jsp").forward(request, response);
        }
    }

    /**
     * Handle Manager Dashboard routes
     */
    private void handleManagerDashboard(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {

        if (path == null || path.equals("/") || path.equals("/dashboard")) {
            request.getRequestDispatcher("/WEB-INF/view/manager/dashboard/dashboard.jsp").forward(request, response);
        } else if (path.startsWith("/customers")) {
            handleManagerCustomers(request, response, path);
        } else if (path.startsWith("/services")) {
            handleManagerServices(request, response, path);
        } else if (path.startsWith("/staff")) {
            handleManagerStaff(request, response, path);
        } else if (path.startsWith("/reports")) {
            handleManagerReports(request, response, path);
        } else if (path.startsWith("/dashboard")) {
            handleManagerDashboardSubPages(request, response, path);
        } else {
            request.getRequestDispatcher("/WEB-INF/view/manager/dashboard/dashboard.jsp").forward(request, response);
        }
    }

    /**
     * Handle Therapist Dashboard routes
     */
    private void handleTherapistDashboard(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {

        if (path == null || path.equals("/") || path.equals("/dashboard")) {
            request.getRequestDispatcher("/WEB-INF/view/therapist/dashboard/dashboard.jsp").forward(request, response);
        } else if (path.startsWith("/appointments")) {
            handleTherapistAppointments(request, response, path);
        } else if (path.startsWith("/treatments")) {
            handleTherapistTreatments(request, response, path);
        } else if (path.startsWith("/clients")) {
            handleTherapistClients(request, response, path);
        } else if (path.startsWith("/schedule")) {
            handleTherapistSchedule(request, response, path);
        } else if (path.startsWith("/performance")) {
            handleTherapistPerformance(request, response, path);
        } else if (path.startsWith("/training")) {
            handleTherapistTraining(request, response, path);
        } else if (path.startsWith("/inventory")) {
            handleTherapistInventory(request, response, path);
        } else {
            request.getRequestDispatcher("/WEB-INF/view/therapist/dashboard/dashboard.jsp").forward(request, response);
        }
    }

    /**
     * Handle Receptionist Dashboard routes
     */
    private void handleReceptionistDashboard(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {

        if (path == null || path.equals("/") || path.equals("/dashboard")) {
            request.getRequestDispatcher("/WEB-INF/view/receptionist/dashboard/dashboard.jsp").forward(request,
                    response);
        } else if (path.startsWith("/appointments")) {
            handleReceptionistAppointments(request, response, path);
        } else if (path.startsWith("/customers")) {
            handleReceptionistCustomers(request, response, path);
        } else if (path.startsWith("/checkin")) {
            handleReceptionistCheckin(request, response, path);
        } else if (path.startsWith("/communication")) {
            handleReceptionistCommunication(request, response, path);
        } else if (path.startsWith("/payments")) {
            handleReceptionistPayments(request, response, path);
        } else {
            request.getRequestDispatcher("/WEB-INF/view/receptionist/dashboard/dashboard.jsp").forward(request,
                    response);
        }
    }

    /**
     * Handle Customer Dashboard routes
     */
    private void handleCustomerDashboard(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {

        if (path == null || path.equals("/") || path.equals("/dashboard")) {
            request.getRequestDispatcher("/WEB-INF/view/customer/dashboard/dashboard.jsp").forward(request, response);
        } else if (path.startsWith("/appointments")) {
            handleCustomerAppointments(request, response, path);
        } else if (path.startsWith("/treatments")) {
            handleCustomerTreatments(request, response, path);
        } else if (path.startsWith("/rewards")) {
            handleCustomerRewards(request, response, path);
        } else if (path.startsWith("/recommendations")) {
            handleCustomerRecommendations(request, response, path);
        } else if (path.startsWith("/reviews")) {
            handleCustomerReviews(request, response, path);
        } else if (path.startsWith("/billing")) {
            handleCustomerBilling(request, response, path);
        } else {
            request.getRequestDispatcher("/WEB-INF/view/customer/dashboard/dashboard.jsp").forward(request, response);
        }
    }

    // Admin sub-handlers
    private void handleAdminUsers(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement admin user management
        request.getRequestDispatcher("/WEB-INF/view/admin/users/list.jsp").forward(request, response);
    }

    private void handleAdminCustomers(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement admin customer management
        request.getRequestDispatcher("/WEB-INF/view/admin/customers/list.jsp").forward(request, response);
    }

    private void handleAdminStaff(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement admin staff management
        request.getRequestDispatcher("/WEB-INF/view/admin/staff/list.jsp").forward(request, response);
    }

    private void handleAdminServices(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement admin service management
        request.getRequestDispatcher("/WEB-INF/view/admin/services/list.jsp").forward(request, response);
    }

    private void handleAdminBookings(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement admin booking management
        request.getRequestDispatcher("/WEB-INF/view/admin/bookings/list.jsp").forward(request, response);
    }

    private void handleAdminFinancial(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement admin financial management
        request.getRequestDispatcher("/WEB-INF/view/admin/financial/overview.jsp").forward(request, response);
    }

    private void handleAdminMarketing(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement admin marketing management
        request.getRequestDispatcher("/WEB-INF/view/admin/marketing/campaigns.jsp").forward(request, response);
    }

    private void handleAdminContent(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement admin content management
        request.getRequestDispatcher("/WEB-INF/view/admin/content/pages.jsp").forward(request, response);
    }

    private void handleAdminReports(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement admin reports
        request.getRequestDispatcher("/WEB-INF/view/admin/reports/dashboard.jsp").forward(request, response);
    }

    private void handleAdminSecurity(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement admin security management
        request.getRequestDispatcher("/WEB-INF/view/admin/security/overview.jsp").forward(request, response);
    }

    private void handleAdminSystem(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement admin system management
        request.getRequestDispatcher("/WEB-INF/view/admin/system/settings.jsp").forward(request, response);
    }

    // Manager sub-handlers
    private void handleManagerCustomers(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement manager customer management
        request.getRequestDispatcher("/WEB-INF/view/manager/customers/list.jsp").forward(request, response);
    }

    private void handleManagerServices(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement manager service management
        request.getRequestDispatcher("/WEB-INF/view/manager/services/packages.jsp").forward(request, response);
    }

    private void handleManagerStaff(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement manager staff management
        request.getRequestDispatcher("/WEB-INF/view/manager/staff/list.jsp").forward(request, response);
    }

    private void handleManagerReports(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement manager reports
        request.getRequestDispatcher("/WEB-INF/view/manager/reports/revenue.jsp").forward(request, response);
    }

    private void handleManagerDashboardSubPages(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement manager dashboard sub-pages
        request.getRequestDispatcher("/WEB-INF/view/manager/dashboard/dashboard.jsp").forward(request, response);
    }

    // Therapist sub-handlers
    private void handleTherapistAppointments(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement therapist appointment management
        request.getRequestDispatcher("/WEB-INF/view/therapist/appointments/today.jsp").forward(request, response);
    }

    private void handleTherapistTreatments(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement therapist treatment management
        request.getRequestDispatcher("/WEB-INF/view/therapist/treatments/active.jsp").forward(request, response);
    }

    private void handleTherapistClients(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement therapist client management
        request.getRequestDispatcher("/WEB-INF/view/therapist/clients/assigned.jsp").forward(request, response);
    }

    private void handleTherapistSchedule(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement therapist schedule management
        request.getRequestDispatcher("/WEB-INF/view/therapist/schedule/daily.jsp").forward(request, response);
    }

    private void handleTherapistPerformance(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement therapist performance tracking
        request.getRequestDispatcher("/WEB-INF/view/therapist/performance/stats.jsp").forward(request, response);
    }

    private void handleTherapistTraining(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement therapist training management
        request.getRequestDispatcher("/WEB-INF/view/therapist/training/courses.jsp").forward(request, response);
    }

    private void handleTherapistInventory(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement therapist inventory management
        request.getRequestDispatcher("/WEB-INF/view/therapist/inventory/supplies.jsp").forward(request, response);
    }

    // Receptionist sub-handlers
    private void handleReceptionistAppointments(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement receptionist appointment management
        request.getRequestDispatcher("/WEB-INF/view/receptionist/appointments/today.jsp").forward(request, response);
    }

    private void handleReceptionistCustomers(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement receptionist customer management
        request.getRequestDispatcher("/WEB-INF/view/receptionist/customers/list.jsp").forward(request, response);
    }

    private void handleReceptionistCheckin(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement receptionist check-in system
        request.getRequestDispatcher("/WEB-INF/view/receptionist/checkin/system.jsp").forward(request, response);
    }

    private void handleReceptionistCommunication(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement receptionist communication tools
        request.getRequestDispatcher("/WEB-INF/view/receptionist/communication/messages.jsp").forward(request,
                response);
    }

    private void handleReceptionistPayments(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement receptionist payment processing
        request.getRequestDispatcher("/WEB-INF/view/receptionist/payments/process.jsp").forward(request, response);
    }

    // Customer sub-handlers
    private void handleCustomerAppointments(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement customer appointment management
        request.getRequestDispatcher("/WEB-INF/view/customer/appointments/upcoming.jsp").forward(request, response);
    }

    private void handleCustomerTreatments(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement customer treatment history
        request.getRequestDispatcher("/WEB-INF/view/customer/treatments/history.jsp").forward(request, response);
    }

    private void handleCustomerRewards(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement customer rewards system
        request.getRequestDispatcher("/WEB-INF/view/customer/rewards/points.jsp").forward(request, response);
    }

    private void handleCustomerRecommendations(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement customer recommendations
        request.getRequestDispatcher("/WEB-INF/view/customer/recommendations/services.jsp").forward(request, response);
    }

    private void handleCustomerReviews(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement customer reviews
        request.getRequestDispatcher("/WEB-INF/view/customer/reviews/my-reviews.jsp").forward(request, response);
    }

    private void handleCustomerBilling(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        // TODO: Implement customer billing
        request.getRequestDispatcher("/WEB-INF/view/customer/billing/payments.jsp").forward(request, response);
    }

    /**
     * Check if user is authorized to access specific dashboard
     */
    private boolean isAuthorizedForDashboard(String servletPath, String userRole) {
        switch (servletPath) {
            case "/admin-dashboard":
                return "ADMIN".equals(userRole);
            case "/manager-dashboard":
                return "MANAGER".equals(userRole);
            case "/therapist-dashboard":
                return "THERAPIST".equals(userRole);
            case "/receptionist-dashboard":
                return "RECEPTIONIST".equals(userRole);
            case "/customer-dashboard":
                return "CUSTOMER".equals(userRole);
            default:
                return false;
        }
    }

    /**
     * Get user role string from role ID
     */
    private String getUserRoleFromId(Integer roleId) {
        if (roleId == null)
            return "GUEST";

        switch (roleId) {
            case RoleConstants.ADMIN_ID:
                return "ADMIN";
            case RoleConstants.MANAGER_ID:
                return "MANAGER";
            case RoleConstants.THERAPIST_ID:
                return "THERAPIST";
            case RoleConstants.RECEPTIONIST_ID:
                return "RECEPTIONIST";
            case RoleConstants.CUSTOMER_ID:
                return "CUSTOMER";
            default:
                return "GUEST";
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // For POST requests, delegate to GET for now
        // TODO: Implement specific POST handlers for form submissions
        doGet(request, response);
    }
}