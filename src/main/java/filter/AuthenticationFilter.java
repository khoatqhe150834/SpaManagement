package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Customer;
import model.RoleConstants;
import model.User;
import jakarta.servlet.annotation.WebFilter;
import util.SecurityConfig;

/**
 * Authentication Filter
 * Purpose: Ensures users are authenticated for protected resources
 * Features:
 * - Checks session-based authentication
 * - Allows public URLs and static resources without authentication
 * - Redirects unauthenticated users to /login
 * - Handles AJAX requests with JSON responses
 * - Sets security headers for authenticated requests
 * Order: Runs FIRST in the filter chain
 */
@WebFilter(filterName = "AuthenticationFilter", urlPatterns = "/*")
public class AuthenticationFilter implements Filter {

  @Override
  public void init(FilterConfig filterConfig) throws ServletException {
    System.out.println("[AuthenticationFilter] Initializing filter. PUBLIC_URLS: " + SecurityConfig.PUBLIC_URLS);
  }

  @Override
  public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
      throws IOException, ServletException {
    HttpServletRequest httpRequest = (HttpServletRequest) request;
    HttpServletResponse httpResponse = (HttpServletResponse) response;

    // Get request path
    String requestURI = httpRequest.getRequestURI();
    String contextPath = httpRequest.getContextPath();
    String path = requestURI.startsWith(contextPath) ? requestURI.substring(contextPath.length()) : requestURI;

    // Normalize path
    if (path.endsWith("/")) {
      path = path.substring(0, path.length() - 1);
    }
    if (path.isEmpty()) {
      path = "/";
    }

    // Log request details
    System.out.println("[AuthenticationFilter] Processing request: " + requestURI +
        " | Path: " + path + " | Context: " + contextPath +
        " | Dispatcher: " + httpRequest.getDispatcherType());

    // Check if resource is public using SecurityConfig
    if (SecurityConfig.isPublicResource(path)) {
      System.out.println("[AuthenticationFilter] Public resource detected, skipping authentication: " + path);
      chain.doFilter(request, response);
      return;
    }

    // Prevent redirect loop for /login
    if (path.equals("/login")) {
      System.out.println("[AuthenticationFilter] Login page requested, allowing access: " + path);
      chain.doFilter(request, response);
      return;
    }

    // Check authentication
    HttpSession session = httpRequest.getSession(false);
    boolean isAuthenticated = isUserAuthenticated(session);

    System.out.println("[AuthenticationFilter] Authentication status for path " + path + ": " + isAuthenticated);

    if (!isAuthenticated) {
      // Store original URL for post-login redirect
      String originalUrl = httpRequest.getRequestURL().toString();
      String queryString = httpRequest.getQueryString();
      if (queryString != null) {
        originalUrl += "?" + queryString;
      }

      // Handle AJAX requests
      if (isAjaxRequest(httpRequest)) {
        httpResponse.setContentType("application/json");
        httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        httpResponse.getWriter().write("{\"error\":\"Authentication required\",\"redirectUrl\":\""
            + contextPath + "/login\"}");
        return;
      }

      // Create session for storing original URL
      HttpSession newSession = httpRequest.getSession(true);
      newSession.setAttribute("originalUrl", originalUrl);

      // Redirect to login
      String redirectUrl = contextPath + "/login";
      System.out.println("[AuthenticationFilter] Redirecting to login: " + redirectUrl);
      httpResponse.sendRedirect(redirectUrl);
      return;
    }

    // Add security headers
    addSecurityHeaders(httpResponse);

    // Set user context
    setUserContext(httpRequest, session);

    // Continue with the request
    chain.doFilter(request, response);
  }

  /**
   * Check if user is authenticated
   */
  private boolean isUserAuthenticated(HttpSession session) {
    if (session == null) {
      return false;
    }

    Boolean authenticated = (Boolean) session.getAttribute("authenticated");
    if (authenticated == null || !authenticated) {
      return false;
    }

    User user = (User) session.getAttribute("user");
    Customer customer = (Customer) session.getAttribute("customer");
    return user != null || customer != null;
  }

  /**
   * Check if the request is AJAX
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
   * Add security headers
   */
  private void addSecurityHeaders(HttpServletResponse response) {
    response.setHeader("X-Frame-Options", "DENY");
    response.setHeader("X-XSS-Protection", "1; mode=block");
    response.setHeader("X-Content-Type-Options", "nosniff");
    response.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
  }

  /**
   * Set user context for downstream components
   */
  private void setUserContext(HttpServletRequest request, HttpSession session) {
    User user = (User) session.getAttribute("user");
    Customer customer = (Customer) session.getAttribute("customer");

    if (user != null) {
      request.setAttribute("currentUser", user);
      request.setAttribute("userRoleId", user.getRoleId());
      request.setAttribute("userType", RoleConstants.getUserTypeFromRole(user.getRoleId()));
    } else if (customer != null) {
      request.setAttribute("currentCustomer", customer);
      request.setAttribute("userRoleId", customer.getRoleId());
      request.setAttribute("userType", RoleConstants.getUserTypeFromRole(customer.getRoleId()));
    }

    request.setAttribute("isAuthenticated", true);
  }

  @Override
  public void destroy() {
    System.out.println("[AuthenticationFilter] Destroying filter");
  }
}
