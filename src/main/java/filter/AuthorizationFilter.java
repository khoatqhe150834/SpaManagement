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
 * - Role-based URL access restrictions with hierarchical permissions
 * - Configurable URL-to-role mappings
 * - Admin can access all areas, managers can access therapist/receptionist
 * areas, etc.
 * - Logs unauthorized access attempts
 * - Returns appropriate error pages based on user role
 * 
 * Order: Should run AFTER AuthenticationFilter in the filter chain
 */
public class AuthorizationFilter implements Filter {

  // URL patterns and their required roles
  private static final Map<String, Set<Integer>> URL_ROLE_MAPPINGS = new HashMap<>();

  // Role hierarchy - higher roles can access lower role resources
  private static final Map<Integer, Set<Integer>> ROLE_HIERARCHY = new HashMap<>();

  static {
    initializeUrlRoleMappings();
    initializeRoleHierarchy();
  }

  /**
   * Configure URL patterns and their required roles
   */
  private static void initializeUrlRoleMappings() {
    // Admin-only areas
    URL_ROLE_MAPPINGS.put("/admin", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID)));
    URL_ROLE_MAPPINGS.put("/user/", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID)));
    URL_ROLE_MAPPINGS.put("/system", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID)));

    // Manager areas (Admin + Manager access)
    URL_ROLE_MAPPINGS.put("/manager", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID)));
    URL_ROLE_MAPPINGS.put("/reports", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID)));
    URL_ROLE_MAPPINGS.put("/analytics", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID)));
    URL_ROLE_MAPPINGS.put("/staff", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID)));
    URL_ROLE_MAPPINGS.put("/servicetype",
        new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID)));

    // Therapist areas (Admin + Manager + Therapist access)
    URL_ROLE_MAPPINGS.put("/therapist", new HashSet<>(Arrays.asList(
        RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.THERAPIST_ID)));
    URL_ROLE_MAPPINGS.put("/schedule", new HashSet<>(Arrays.asList(
        RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.THERAPIST_ID, RoleConstants.RECEPTIONIST_ID)));
    URL_ROLE_MAPPINGS.put("/treatments", new HashSet<>(Arrays.asList(
        RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.THERAPIST_ID)));
    URL_ROLE_MAPPINGS.put("/appointment", new HashSet<>(Arrays.asList(
        RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.THERAPIST_ID,
        RoleConstants.RECEPTIONIST_ID)));

    // Receptionist areas
    URL_ROLE_MAPPINGS.put("/reception", new HashSet<>(Arrays.asList(
        RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.RECEPTIONIST_ID)));
    URL_ROLE_MAPPINGS.put("/booking", new HashSet<>(Arrays.asList(
        RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.THERAPIST_ID,
        RoleConstants.RECEPTIONIST_ID, RoleConstants.CUSTOMER_ID)));
    URL_ROLE_MAPPINGS.put("/booking-checkout", new HashSet<>(Arrays.asList(
         RoleConstants.CUSTOMER_ID)));

    // Marketing areas
    URL_ROLE_MAPPINGS.put("/marketing", new HashSet<>(Arrays.asList(
        RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.MARKETING_ID)));
    URL_ROLE_MAPPINGS.put("/blog", new HashSet<>(Arrays.asList(
        RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.MARKETING_ID)));
    URL_ROLE_MAPPINGS.put("/promotions", new HashSet<>(Arrays.asList(
        RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.MARKETING_ID)));
    URL_ROLE_MAPPINGS.put("/promotion", new HashSet<>(Arrays.asList(
        RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.MARKETING_ID)));

    // Customer Management - Role-based separation
    // Admin manages customer accounts (login credentials, account status)
    URL_ROLE_MAPPINGS.put("/admin/customer-account", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID)));
    
    // Manager manages customer information (personal details, profile)
    URL_ROLE_MAPPINGS.put("/manager/customer", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID)));
    
    // Legacy customer path (deprecated - use specific paths above)
    URL_ROLE_MAPPINGS.put("/customer/", new HashSet<>(Arrays.asList(RoleConstants.MANAGER_ID)));
    
    // Customer profile and appointment access
    URL_ROLE_MAPPINGS.put("/profile", new HashSet<>(Arrays.asList(
        RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.THERAPIST_ID,
        RoleConstants.RECEPTIONIST_ID, RoleConstants.CUSTOMER_ID)));
    URL_ROLE_MAPPINGS.put("/appointments", new HashSet<>(Arrays.asList(
        RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.THERAPIST_ID,
        RoleConstants.RECEPTIONIST_ID, RoleConstants.CUSTOMER_ID)));

    // Paths accessible to any authenticated user
    Set<Integer> allAuthenticatedRoles = new HashSet<>(Arrays.asList(
        RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.THERAPIST_ID,
        RoleConstants.RECEPTIONIST_ID, RoleConstants.CUSTOMER_ID, RoleConstants.MARKETING_ID));
    URL_ROLE_MAPPINGS.put("/dashboard", allAuthenticatedRoles);
    URL_ROLE_MAPPINGS.put("/password/change", allAuthenticatedRoles);
  }

  /**
   * Define role hierarchy for inherited permissions
   */
  private static void initializeRoleHierarchy() {
    // Admin can access everything
    ROLE_HIERARCHY.put(RoleConstants.ADMIN_ID, new HashSet<>(Arrays.asList(
        RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.THERAPIST_ID,
        RoleConstants.RECEPTIONIST_ID, RoleConstants.CUSTOMER_ID, RoleConstants.MARKETING_ID)));

    // Manager can access manager, therapist, receptionist, and customer areas
    ROLE_HIERARCHY.put(RoleConstants.MANAGER_ID, new HashSet<>(Arrays.asList(
        RoleConstants.MANAGER_ID, RoleConstants.THERAPIST_ID,
        RoleConstants.RECEPTIONIST_ID, RoleConstants.CUSTOMER_ID, RoleConstants.MARKETING_ID)));

    // Therapist can access therapist and customer areas
    ROLE_HIERARCHY.put(RoleConstants.THERAPIST_ID, new HashSet<>(Arrays.asList(
        RoleConstants.THERAPIST_ID, RoleConstants.CUSTOMER_ID)));

    // Receptionist can access receptionist and customer areas
    ROLE_HIERARCHY.put(RoleConstants.RECEPTIONIST_ID, new HashSet<>(Arrays.asList(
        RoleConstants.RECEPTIONIST_ID, RoleConstants.CUSTOMER_ID)));

    // Marketing can only access marketing areas
    ROLE_HIERARCHY.put(RoleConstants.MARKETING_ID, new HashSet<>(Arrays.asList(
        RoleConstants.MARKETING_ID)));

    // Customer can only access customer areas
    ROLE_HIERARCHY.put(RoleConstants.CUSTOMER_ID, new HashSet<>(Arrays.asList(
        RoleConstants.CUSTOMER_ID)));
  }

  @Override
  public void init(FilterConfig filterConfig) throws ServletException {
    // Filter initialization if needed
  }

  @Override
  public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
      throws IOException, ServletException {

    System.out
        .println("--- [DEBUG] AuthorizationFilter is running! Path: " + ((HttpServletRequest) request).getRequestURI());

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

    // If path requires no authorization and is not public, it's an unknown path
    if (!requiresAuthorization(path)) {
      System.out.println("[AuthorizationFilter] Path not found in authorization rules, forwarding to 404: " + path);
      request.getRequestDispatcher("/WEB-INF/view/common/error/404.jsp").forward(request, response);
      return;
    }

    // Get user role from session
    HttpSession session = httpRequest.getSession(false);
    Integer userRoleId = getUserRoleId(session);

    if (userRoleId == null) {
      // This shouldn't happen if AuthenticationFilter is working correctly
      httpResponse.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Authentication required");
      return;
    }

    // Check if user has permission to access the requested resource
    if (!hasPermission(path, userRoleId)) {
      // Log unauthorized access attempt
      logUnauthorizedAccess(httpRequest, userRoleId, path);

      // Handle unauthorized access
      handleUnauthorizedAccess(httpRequest, httpResponse, path, userRoleId);
      return;
    }

    // Add role information to request for downstream use
    httpRequest.setAttribute("userRoleId", userRoleId);
    httpRequest.setAttribute("userRoleName", RoleConstants.getUserTypeFromRole(userRoleId));

    // Continue with the request
    chain.doFilter(request, response);
  }

  /**
   * Check if the resource requires authorization
   */
  private boolean requiresAuthorization(String path) {
    // Check if any URL pattern matches the current path
    for (String urlPattern : URL_ROLE_MAPPINGS.keySet()) {
      if (path.startsWith(urlPattern)) {
        return true;
      }
    }
    return false;
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
    // Find the most specific matching URL pattern
    String matchedPattern = null;
    int maxMatchLength = 0;

    for (String urlPattern : URL_ROLE_MAPPINGS.keySet()) {
      if (path.startsWith(urlPattern) && urlPattern.length() > maxMatchLength) {
        matchedPattern = urlPattern;
        maxMatchLength = urlPattern.length();
      }
    }

    if (matchedPattern == null) {
      // No specific pattern found, allow access (default allow)
      return true;
    }

    Set<Integer> allowedRoles = URL_ROLE_MAPPINGS.get(matchedPattern);

    // Check direct role permission
    if (allowedRoles.contains(userRoleId)) {
      return true;
    }

    // Check hierarchical permissions
    Set<Integer> inheritedRoles = ROLE_HIERARCHY.get(userRoleId);
    if (inheritedRoles != null) {
      for (Integer allowedRole : allowedRoles) {
        if (inheritedRoles.contains(allowedRole)) {
          return true;
        }
      }
    }

    return false;
  }

  /**
   * Handle unauthorized access attempts
   */
  private void handleUnauthorizedAccess(HttpServletRequest request, HttpServletResponse response,
      String path, Integer userRoleId) throws IOException, ServletException {

    // Check if it's an AJAX request
    if (isAjaxRequest(request)) {
      response.setContentType("application/json");
      response.setStatus(HttpServletResponse.SC_FORBIDDEN);
      response.getWriter()
          .write("{\"error\":\"Access denied\",\"message\":\"You don't have permission to access this resource\"}");
      return;
    }

    // For regular requests, forward to appropriate error page
    if (userRoleId != null && userRoleId <= RoleConstants.RECEPTIONIST_ID) {
      // Staff error page
      request.getRequestDispatcher("/WEB-INF/view/common/error/403.jsp").forward(request, response);
    } else {
      // Customer error page
      request.getRequestDispatcher("/WEB-INF/view/common/error/403.jsp").forward(request, response);
    }
  }

  /**
   * Check if the request is an AJAX request
   */
  private boolean isAjaxRequest(HttpServletRequest request) {
    String xRequestedWith = request.getHeader("X-Requested-With");
    String accept = request.getHeader("Accept");
    String contentType = request.getContentType();

    return "XMLHttpRequest".equals(xRequestedWith) ||
        (accept != null && accept.contains("application/json")) ||
        (contentType != null && contentType.contains("application/json"));
  }

  /**
   * Log unauthorized access attempts for security monitoring
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
    // Filter cleanup if needed
  }
}
