package util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import model.RoleConstants;
import model.User;

/**
 * Authentication Context Utility
 * 
 * Purpose: Provides convenient methods to access authentication and
 * authorization
 * information from the current request context.
 * 
 * This utility class works with the filter chain to provide easy access to:
 * - Current user information
 * - User roles and permissions
 * - Authentication status
 * 
 * Usage in Servlets:
 * - Use AuthenticationContext.getCurrentUser(request) instead of
 * session.getAttribute()
 * - Use AuthenticationContext.hasRole(request, RoleConstants.ADMIN_ID) for
 * permission checks
 * - Use AuthenticationContext.requireRole(request, response,
 * RoleConstants.MANAGER_ID) for enforcement
 */
public class AuthenticationContext {

  /**
   * Get the current authenticated user (staff/admin)
   * Returns null if current user is a customer or not authenticated
   */
  public static User getCurrentUser(HttpServletRequest request) {
    // Try to get from request attributes first (set by AuthenticationFilter)
    User user = (User) request.getAttribute("currentUser");
    if (user != null) {
      return user;
    }

    // Fallback to session
    HttpSession session = request.getSession(false);
    if (session != null) {
      return (User) session.getAttribute("user");
    }

    return null;
  }

  /**
   * Get the current authenticated customer
   * Returns null if current user is staff/admin or not authenticated
   */
  public static Customer getCurrentCustomer(HttpServletRequest request) {
    // Try to get from request attributes first (set by AuthenticationFilter)
    Customer customer = (Customer) request.getAttribute("currentCustomer");
    if (customer != null) {
      return customer;
    }

    // Fallback to session
    HttpSession session = request.getSession(false);
    if (session != null) {
      return (Customer) session.getAttribute("customer");
    }

    return null;
  }

  /**
   * Get the current user's role ID (works for both staff and customers)
   */
  public static Integer getCurrentUserRoleId(HttpServletRequest request) {
    // Try to get from request attributes first (set by AuthenticationFilter)
    Integer roleId = (Integer) request.getAttribute("currentUserRoleId");
    if (roleId != null) {
      return roleId;
    }

    // Try user
    User user = getCurrentUser(request);
    if (user != null) {
      return user.getRoleId();
    }

    // Try customer
    Customer customer = getCurrentCustomer(request);
    if (customer != null) {
      return customer.getRoleId();
    }

    return null;
  }

  /**
   * Get the current user's role name (ADMIN, MANAGER, THERAPIST, etc.)
   */
  public static String getCurrentUserRole(HttpServletRequest request) {
    // Try to get from request attributes first (set by AuthorizationFilter)
    String roleName = (String) request.getAttribute("userRoleName");
    if (roleName != null) {
      return roleName;
    }

    Integer roleId = getCurrentUserRoleId(request);
    return RoleConstants.getUserTypeFromRole(roleId);
  }

  /**
   * Get the current user's display name (works for both staff and customers)
   */
  public static String getCurrentUserDisplayName(HttpServletRequest request) {
    User user = getCurrentUser(request);
    if (user != null) {
      return user.getFullName();
    }

    Customer customer = getCurrentCustomer(request);
    if (customer != null) {
      return customer.getFullName();
    }

    return null;
  }

  /**
   * Get the current user's email (works for both staff and customers)
   */
  public static String getCurrentUserEmail(HttpServletRequest request) {
    User user = getCurrentUser(request);
    if (user != null) {
      return user.getEmail();
    }

    Customer customer = getCurrentCustomer(request);
    if (customer != null) {
      return customer.getEmail();
    }

    return null;
  }

  /**
   * Get the current user's ID (works for both staff and customers)
   */
  public static Integer getCurrentUserId(HttpServletRequest request) {
    User user = getCurrentUser(request);
    if (user != null) {
      return user.getUserId();
    }

    Customer customer = getCurrentCustomer(request);
    if (customer != null) {
      return customer.getCustomerId();
    }

    return null;
  }

  /**
   * Check if the current user is authenticated
   */
  public static boolean isAuthenticated(HttpServletRequest request) {
    HttpSession session = request.getSession(false);
    if (session == null) {
      return false;
    }

    Boolean authenticated = (Boolean) session.getAttribute("authenticated");
    return authenticated != null && authenticated;
  }

  /**
   * Check if the current user has a specific role
   */
  public static boolean hasRole(HttpServletRequest request, Integer requiredRoleId) {
    Integer currentRoleId = getCurrentUserRoleId(request);
    return currentRoleId != null && currentRoleId.equals(requiredRoleId);
  }

  /**
   * Check if the current user has any of the specified roles
   */
  public static boolean hasAnyRole(HttpServletRequest request, Integer... roleIds) {
    Integer currentRoleId = getCurrentUserRoleId(request);
    if (currentRoleId == null) {
      return false;
    }

    for (Integer roleId : roleIds) {
      if (currentRoleId.equals(roleId)) {
        return true;
      }
    }

    return false;
  }

  /**
   * Check if the current user is an admin
   */
  public static boolean isAdmin(HttpServletRequest request) {
    return hasRole(request, RoleConstants.ADMIN_ID);
  }

  /**
   * Check if the current user is a manager (or admin)
   */
  public static boolean isManagerOrAbove(HttpServletRequest request) {
    return hasAnyRole(request, RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID);
  }

  /**
   * Check if the current user is staff (not a customer)
   */
  public static boolean isStaff(HttpServletRequest request) {
    return hasAnyRole(request,
        RoleConstants.ADMIN_ID,
        RoleConstants.MANAGER_ID,
        RoleConstants.THERAPIST_ID,
        RoleConstants.RECEPTIONIST_ID);
  }

  /**
   * Check if the current user is a customer
   */
  public static boolean isCustomer(HttpServletRequest request) {
    return hasRole(request, RoleConstants.CUSTOMER_ID);
  }

  /**
   * Get user type string for display purposes
   */
  public static String getUserTypeDisplayName(HttpServletRequest request) {
    String role = getCurrentUserRole(request);
    if (role == null) {
      return "Guest";
    }

    switch (role) {
      case "ADMIN":
        return "Administrator";
      case "MANAGER":
        return "Manager";
      case "THERAPIST":
        return "Therapist";
      case "RECEPTIONIST":
        return "Receptionist";
      case "CUSTOMER":
        return "Customer";
      default:
        return "User";
    }
  }

  /**
   * Check if the current user can access a specific resource
   * This method checks both authentication and authorization
   */
  public static boolean canAccess(HttpServletRequest request, String resourcePath) {
    if (!isAuthenticated(request)) {
      return false;
    }

    // Add your resource-specific authorization logic here
    // This is a simplified example - you might want to implement
    // more sophisticated permission checking

    if (resourcePath.startsWith("/admin")) {
      return isAdmin(request);
    }

    if (resourcePath.startsWith("/manager")) {
      return isManagerOrAbove(request);
    }

    if (resourcePath.startsWith("/staff")) {
      return isStaff(request);
    }

    // Default: allow access if authenticated
    return true;
  }

  /**
   * Get a descriptive string about the current user for logging
   */
  public static String getUserDescription(HttpServletRequest request) {
    if (!isAuthenticated(request)) {
      return "Anonymous User";
    }

    String email = getCurrentUserEmail(request);
    String role = getCurrentUserRole(request);
    Integer userId = getCurrentUserId(request);

    return String.format("%s (ID: %d, Email: %s)", role, userId, email);
  }
}