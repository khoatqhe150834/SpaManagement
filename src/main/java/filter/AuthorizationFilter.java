package filter;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import model.RoleConstants;
import model.User;
import util.SecurityConfig;

/**
 * Authorization Filter
 * 
 * Purpose: Enforces role-based access control after authentication is confirmed
 * 
 * Features:
 * - Role-based URL access restrictions without hierarchical permissions
 * - Configurable URL-to-role mappings with support for wildcard patterns (e.g., /customer/*)
 * - Strict role matching for specified URLs and patterns
 * - Logs unauthorized access attempts
 * - Returns appropriate error pages based on user role
 * 
 * Order: Should run AFTER AuthenticationFilter in the filter chain
 */
public class AuthorizationFilter implements Filter {

    // URL patterns and their required roles (explicit mappings)
    private static final Map<String, Set<Integer>> URL_ROLE_MAPPINGS = new HashMap<>();

    // Pattern-based URL mappings (supports wildcards like /customer/*)
    private static final Map<String, Set<Integer>> PATTERN_ROLE_MAPPINGS = new HashMap<>();

    // URLs that require strict role matching (no other roles allowed)
    private static final Set<String> STRICT_ROLE_URLS = new HashSet<>();

    // Pattern-based strict role URLs (supports wildcards)
    private static final Set<String> STRICT_ROLE_PATTERNS = new HashSet<>();

    static {
        initializeUrlRoleMappings();
        initializePatternRoleMappings();
        initializeStrictRoleUrls();
    }

    /**
     * Configure explicit URL patterns and their required roles
     */
    private static void initializeUrlRoleMappings() {
        // Admin-only areas
        URL_ROLE_MAPPINGS.put("/admin", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID)));
        URL_ROLE_MAPPINGS.put("/user/", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID)));
        URL_ROLE_MAPPINGS.put("/system", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID)));

        // Manager areas
        URL_ROLE_MAPPINGS.put("/manager", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID)));
        URL_ROLE_MAPPINGS.put("/manager/scheduling", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID)));
        URL_ROLE_MAPPINGS.put("/manager/payment-edit", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID)));
        URL_ROLE_MAPPINGS.put("/manager/payment-add", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID)));
        URL_ROLE_MAPPINGS.put("/manager/payment-details", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID)));
        URL_ROLE_MAPPINGS.put("/manager/payments-management", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID)));
        URL_ROLE_MAPPINGS.put("/reports", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID)));
        URL_ROLE_MAPPINGS.put("/analytics", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID)));
        URL_ROLE_MAPPINGS.put("/staff", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID)));
        URL_ROLE_MAPPINGS.put("/servicetype", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID)));

        // Therapist areas
        URL_ROLE_MAPPINGS.put("/therapist", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.THERAPIST_ID)));
        URL_ROLE_MAPPINGS.put("/schedule", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.THERAPIST_ID, RoleConstants.RECEPTIONIST_ID)));
        URL_ROLE_MAPPINGS.put("/treatments", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.THERAPIST_ID)));
        URL_ROLE_MAPPINGS.put("/appointment", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.THERAPIST_ID, RoleConstants.RECEPTIONIST_ID)));

        // Receptionist areas
        URL_ROLE_MAPPINGS.put("/reception", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.RECEPTIONIST_ID)));
        URL_ROLE_MAPPINGS.put("/booking", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.THERAPIST_ID, RoleConstants.RECEPTIONIST_ID, RoleConstants.CUSTOMER_ID)));

        // Customer checkout URLs
        URL_ROLE_MAPPINGS.put("/booking-checkout", new HashSet<>(Arrays.asList(RoleConstants.CUSTOMER_ID)));
        URL_ROLE_MAPPINGS.put("/checkout/process", new HashSet<>(Arrays.asList(RoleConstants.CUSTOMER_ID)));

        // Marketing areas
        URL_ROLE_MAPPINGS.put("/marketing", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.MARKETING_ID)));
        URL_ROLE_MAPPINGS.put("/blog", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.MARKETING_ID)));
        
        // Promotion management (Admin/Manager/Marketing only)
        URL_ROLE_MAPPINGS.put("/promotion", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.MARKETING_ID)));
        
        // Customer promotions (Customer can access)
        URL_ROLE_MAPPINGS.put("/promotions", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.MARKETING_ID, RoleConstants.CUSTOMER_ID)));

        // Inventory Manager areas
        URL_ROLE_MAPPINGS.put("/inventory-manager", new HashSet<>(Arrays.asList(RoleConstants.INVENTORY_MANAGER_ID)));

        // Customer Management (Admin, Manager, Receptionist)
        URL_ROLE_MAPPINGS.put("/customer-management", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.RECEPTIONIST_ID)));

        // User Management (Admin, Manager, and staff can view their own info)
        URL_ROLE_MAPPINGS.put("/user-management", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.THERAPIST_ID, RoleConstants.RECEPTIONIST_ID, RoleConstants.MARKETING_ID, RoleConstants.INVENTORY_MANAGER_ID)));



        // Legacy customer paths (deprecated - for backward compatibility)
        URL_ROLE_MAPPINGS.put("/admin/customer-account", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID)));
        URL_ROLE_MAPPINGS.put("/manager/customer", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID)));
        

        // General authenticated user access
        Set<Integer> allAuthenticatedRoles = new HashSet<>(Arrays.asList(
            RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.THERAPIST_ID,
            RoleConstants.RECEPTIONIST_ID, RoleConstants.CUSTOMER_ID, RoleConstants.MARKETING_ID, RoleConstants.INVENTORY_MANAGER_ID));
        URL_ROLE_MAPPINGS.put("/dashboard", allAuthenticatedRoles);
        URL_ROLE_MAPPINGS.put("/password/change", allAuthenticatedRoles);
        URL_ROLE_MAPPINGS.put("/profile", allAuthenticatedRoles);
        URL_ROLE_MAPPINGS.put("/appointments", allAuthenticatedRoles);
    }

    /**
     * Configure pattern-based URL role mappings
     */
    private static void initializePatternRoleMappings() {
        // Customer area patterns - customer-only access
        PATTERN_ROLE_MAPPINGS.put("/customer/*", new HashSet<>(Arrays.asList(RoleConstants.CUSTOMER_ID)));

        // Manager area patterns
        PATTERN_ROLE_MAPPINGS.put("/manager/*", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID)));
        PATTERN_ROLE_MAPPINGS.put("/manager/payments/*", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID)));

        // Admin area patterns
        PATTERN_ROLE_MAPPINGS.put("/admin/*", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID)));

        // API patterns
        PATTERN_ROLE_MAPPINGS.put("/api/customer/*", new HashSet<>(Arrays.asList(RoleConstants.CUSTOMER_ID)));
        PATTERN_ROLE_MAPPINGS.put("/api/manager/*", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID)));
        PATTERN_ROLE_MAPPINGS.put("/api/admin/*", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID)));
        PATTERN_ROLE_MAPPINGS.put("/api/payments/*", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID)));
        PATTERN_ROLE_MAPPINGS.put("/api/payments", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID)));

        // Validation API patterns - accessible to all authenticated users
        Set<Integer> allAuthenticatedRoles = new HashSet<>(Arrays.asList(
            RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.THERAPIST_ID,
            RoleConstants.RECEPTIONIST_ID, RoleConstants.CUSTOMER_ID, RoleConstants.MARKETING_ID, RoleConstants.INVENTORY_MANAGER_ID));
        PATTERN_ROLE_MAPPINGS.put("/api/validate/*", allAuthenticatedRoles);

        // Therapist area patterns
        PATTERN_ROLE_MAPPINGS.put("/therapist/*", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.THERAPIST_ID)));

        // Receptionist area patterns
        PATTERN_ROLE_MAPPINGS.put("/receptionist/*", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.RECEPTIONIST_ID)));

        // Marketing area patterns
        PATTERN_ROLE_MAPPINGS.put("/marketing/*", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.MARKETING_ID)));

        // Promotion patterns (Admin/Manager/Marketing can manage, Customer can view)
        PATTERN_ROLE_MAPPINGS.put("/promotions/*", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.MARKETING_ID, RoleConstants.CUSTOMER_ID)));

        // Inventory area patterns
        PATTERN_ROLE_MAPPINGS.put("/inventory/*", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.INVENTORY_MANAGER_ID)));

        // User Management area patterns
        PATTERN_ROLE_MAPPINGS.put("/user-management/*", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.THERAPIST_ID, RoleConstants.RECEPTIONIST_ID, RoleConstants.MARKETING_ID, RoleConstants.INVENTORY_MANAGER_ID)));
    }

    /**
     * Initialize URLs and patterns that require strict role matching
     */
    private static void initializeStrictRoleUrls() {
        // Customer checkout URLs
        STRICT_ROLE_URLS.add("/booking-checkout");
        STRICT_ROLE_URLS.add("/checkout/process");

        // Pattern-based strict role URLs
        STRICT_ROLE_PATTERNS.add("/customer/*");
        STRICT_ROLE_PATTERNS.add("/api/customer/*");
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Filter initialization
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        System.out.println("--- [DEBUG] AuthorizationFilter is running! Path: " + ((HttpServletRequest) request).getRequestURI());

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Get request path
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());

        // Skip authorization for public resources and error pages
        if (SecurityConfig.isPublicResource(path) || isErrorPage(path)) {
            chain.doFilter(request, response);
            return;
        }

        // Check if path requires authorization
        if (!requiresAuthorization(path)) {
            System.out.println("[AuthorizationFilter] Path not found in authorization rules, forwarding to 404: " + path);
            request.getRequestDispatcher("/WEB-INF/view/common/error/404.jsp").forward(request, response);
            return;
        }

        // Get user role from session
        HttpSession session = httpRequest.getSession(false);
        Integer userRoleId = getUserRoleId(session);

        if (userRoleId == null) {
            httpResponse.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Authentication required");
            return;
        }

        // Check permission
        if (!hasPermission(path, userRoleId)) {
            logUnauthorizedAccess(httpRequest, userRoleId, path);
            handleUnauthorizedAccess(httpRequest, httpResponse, path, userRoleId);
            return;
        }

        // Add role information to request
        httpRequest.setAttribute("userRoleId", userRoleId);
        httpRequest.setAttribute("userRoleName", RoleConstants.getUserTypeFromRole(userRoleId));

        chain.doFilter(request, response);
    }

    /**
     * Check if the resource requires authorization
     */
    private boolean requiresAuthorization(String path) {
        // Check explicit URL patterns
        for (String urlPattern : URL_ROLE_MAPPINGS.keySet()) {
            if (path.startsWith(urlPattern)) {
                return true;
            }
        }

        // Check pattern-based URL mappings
        for (String pattern : PATTERN_ROLE_MAPPINGS.keySet()) {
            if (matchesPattern(path, pattern)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Check if a path matches a wildcard pattern
     */
    private boolean matchesPattern(String path, String pattern) {
        if (pattern.endsWith("/*")) {
            String prefix = pattern.substring(0, pattern.length() - 2);
            return path.startsWith(prefix + "/") || path.equals(prefix);
        }
        return path.equals(pattern);
    }

    /**
     * Get user role ID from session
     */
    private Integer getUserRoleId(HttpSession session) {
        if (session == null) {
            return null;
        }

        User user = (User) session.getAttribute("user");
        if (user != null) {
            return user.getRoleId();
        }

        Customer customer = (Customer) session.getAttribute("customer");
        if (customer != null) {
            return customer.getRoleId();
        }

        return null;
    }

    /**
     * Check if user has permission to access the requested path
     */
    private boolean hasPermission(String path, Integer userRoleId) {
        System.out.println("[DEBUG] hasPermission called: path=" + path + ", userRoleId=" + userRoleId);

        // Find the most specific matching URL pattern
        String matchedPattern = null;
        Set<Integer> allowedRoles = null;
        int maxMatchLength = 0;

        // Check explicit URL patterns first
        for (String urlPattern : URL_ROLE_MAPPINGS.keySet()) {
            if (path.startsWith(urlPattern) && urlPattern.length() > maxMatchLength) {
                matchedPattern = urlPattern;
                allowedRoles = URL_ROLE_MAPPINGS.get(urlPattern);
                maxMatchLength = urlPattern.length();
                System.out.println("[DEBUG] Explicit pattern matched: " + urlPattern + ", roles: " + allowedRoles);
            }
        }

        // Check pattern-based URL mappings if no explicit match or if pattern is more specific
        for (String pattern : PATTERN_ROLE_MAPPINGS.keySet()) {
            if (matchesPattern(path, pattern)) {
                int patternLength = pattern.endsWith("/*") ? pattern.length() - 2 : pattern.length();
                if (matchedPattern == null || patternLength > maxMatchLength) {
                    matchedPattern = pattern;
                    allowedRoles = PATTERN_ROLE_MAPPINGS.get(pattern);
                    maxMatchLength = patternLength;
                    System.out.println("[DEBUG] Pattern selected: " + pattern + ", roles: " + allowedRoles);
                }
            }
        }

        System.out.println("[DEBUG] Final matched pattern: " + matchedPattern + ", allowedRoles: " + allowedRoles);

        if (matchedPattern == null || allowedRoles == null) {
            System.out.println("[DEBUG] No pattern matched, allowing access");
            return true;
        }

        // Check if the URL requires strict role matching
        if (isStrictRoleUrl(path, matchedPattern)) {
            return allowedRoles.contains(userRoleId);
        }

        // Check direct role permission
        return allowedRoles.contains(userRoleId);
    }

    /**
     * Check if a URL requires strict role matching
     */
    private boolean isStrictRoleUrl(String path, String matchedPattern) {
        if (STRICT_ROLE_URLS.contains(matchedPattern)) {
            return true;
        }

        for (String strictPattern : STRICT_ROLE_PATTERNS) {
            if (matchesPattern(path, strictPattern)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Handle unauthorized access attempts
     */
    private void handleUnauthorizedAccess(HttpServletRequest request, HttpServletResponse response,
            String path, Integer userRoleId) throws IOException, ServletException {
        if (isAjaxRequest(request)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);

            String jsonResponse = "{" +
                "\"success\": false," +
                "\"error\": \"Access denied\"," +
                "\"message\": \"You don't have permission to access this resource\"," +
                "\"path\": \"" + path + "\"," +
                "\"userRole\": " + userRoleId +
                "}";

            System.out.println("[AuthorizationFilter] Sending JSON error response for unauthorized AJAX request: " + jsonResponse);
            response.getWriter().write(jsonResponse);
            return;
        }

        request.getRequestDispatcher("/WEB-INF/view/common/error/403.jsp").forward(request, response);
    }

    /**
     * Check if the request is an AJAX request
     */
    private boolean isAjaxRequest(HttpServletRequest request) {
        String xRequestedWith = request.getHeader("X-Requested-With");
        String accept = request.getHeader("Accept");
        String contentType = request.getContentType();
        String requestURI = request.getRequestURI();

        // Check standard AJAX headers
        boolean isAjax = "XMLHttpRequest".equals(xRequestedWith) ||
                (accept != null && accept.contains("application/json")) ||
                (contentType != null && contentType.contains("application/json"));

        // Also check if the request is to an API endpoint that should return JSON
        boolean isApiEndpoint = requestURI.contains("/api/") ||
                               requestURI.contains("action=") ||
                               requestURI.endsWith("/scheduling") ||
                               requestURI.contains("/manager/payments/") ||
                               requestURI.contains("/payment/") ||
                               (request.getParameter("action") != null);

        System.out.println("[AuthorizationFilter] AJAX detection - URI: " + requestURI +
                          ", X-Requested-With: " + xRequestedWith +
                          ", Accept: " + accept +
                          ", ContentType: " + contentType +
                          ", isAjax: " + isAjax +
                          ", isApiEndpoint: " + isApiEndpoint);

        return isAjax || isApiEndpoint;
    }

    /**
     * Log unauthorized access attempts
     */
    private void logUnauthorizedAccess(HttpServletRequest request, Integer userRoleId, String path) {
        String userInfo = "Unknown";
        HttpSession session = request.getSession(false);

        if (session != null) {
            User user = (User) session.getAttribute("user");
            Customer customer = (Customer) session.getAttribute("customer");

            if (user != null) {
                userInfo = "User(ID:" + user.getUserId() + ", Email:" + user.getEmail() + ")";
            } else if (customer != null) {
                userInfo = "Customer(ID:" + customer.getCustomerId() + ", Email:" + customer.getEmail() + ")";
            }
        }

        System.err.println("[SECURITY WARNING] Unauthorized access attempt: " +
                "User=" + userInfo +
                ", Role=" + RoleConstants.getUserTypeFromRole(userRoleId) +
                ", Path=" + path +
                ", IP=" + request.getRemoteAddr() +
                ", UserAgent=" + request.getHeader("User-Agent"));
    }

    /**
     * Check if the path is an error page
     */
    private boolean isErrorPage(String path) {
        return path.startsWith("/WEB-INF/view/common/error/") ||
                path.startsWith("/error/") ||
                path.equals("/404") ||
                path.equals("/500") ||
                path.equals("/403") ||
                path.equals("/401");
    }

    @Override
    public void destroy() {
        // Filter cleanup
    }
}