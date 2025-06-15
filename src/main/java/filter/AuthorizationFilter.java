package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Customer;
import model.RoleConstants;

/**
 * Authorization filter that handles both role-based access control and email
 * verification requirements.
 * 
 * This filter:
 * 1. Checks if users are authenticated
 * 2. For customers accessing sensitive pages, ensures they have verified their
 * email
 * 3. Enforces role-based authorization for admin, manager, therapist, and
 * receptionist areas
 * 
 * Email verification is required for customers accessing:
 * - Profile pages (/profile/*)
 * - Appointment pages (/appointment/*)
 * - Booking pages (/booking/*)
 * 
 * Unverified customers will be redirected to /verification-pending
 */
@WebFilter(filterName = "AuthorizationFilter", urlPatterns = { "/admin/*", "/manager/*", "/therapist/*",
        "/receptionist/*", "/customer/*", "/profile", "/profile/*", "/appointment", "/appointment/*", "/booking",
        "/booking/*" })
public class AuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // Get the requested URL path
        String requestPath = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        // Check if user is authenticated
        boolean isAuthenticated = (session != null && session.getAttribute("authenticated") != null
                && (Boolean) session.getAttribute("authenticated"));

        if (!isAuthenticated) {
            // Redirect to login page if not authenticated
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        // Get user type from session
        String userType = (String) session.getAttribute("userType");
        if (userType == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        // Note: Email verification is now enforced at login time, so authenticated
        // customers are already verified
        // No need to check verification status here anymore

        // Check authorization based on URL path and user type
        if (!isAuthorized(requestPath, userType)) {
            // Redirect to unauthorized page or show error
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        // Continue with the request if authorized
        chain.doFilter(request, response);
    }

    private boolean requiresVerification(String requestPath) {
        // Define which pages require email verification for customers
        // Allow browsing services, reading info, but block transactional features
        return requestPath.startsWith("/profile") ||
                requestPath.startsWith("/appointment") ||
                requestPath.startsWith("/booking") ||
                requestPath.startsWith("/payment") ||
                requestPath.startsWith("/loyalty") ||
                requestPath.startsWith("/order") ||
                requestPath.equals("/profile") ||
                requestPath.equals("/appointment") ||
                requestPath.equals("/booking") ||
                requestPath.equals("/payment") ||
                requestPath.equals("/checkout");
    }

    private boolean isAuthorized(String requestPath, String userType) {
        // Admin all rights
        if ("admin".equals(userType)) {
            return true;
        }

        // Check access based on URL path and user type
        if (requestPath.startsWith("/admin") || requestPath.startsWith("/customer")) {
            return "admin".equals(userType);
        } else if (requestPath.startsWith("/manager")) {
            return "manager".equals(userType) || "admin".equals(userType);
        } else if (requestPath.startsWith("/therapist")) {
            return "therapist".equals(userType) || "admin".equals(userType) || "manager".equals(userType);
        } else if (requestPath.startsWith("/receptionist")) {
            return "receptionist".equals(userType) || "admin".equals(userType) || "manager".equals(userType);
        } else if (requestPath.startsWith("/profile") || requestPath.startsWith("/appointment")
                || requestPath.startsWith("/booking")) {
            // Allow customers and staff to access profile, appointment, and booking pages
            return "customer".equals(userType) || "admin".equals(userType) ||
                    "manager".equals(userType) || "therapist".equals(userType) ||
                    "receptionist".equals(userType);
        }

        // Default to denying access
        return false;
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}