
package filter;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import model.RoleConstants;
import model.User;

/**
 * Exception Handling Filter
 * 
 * Purpose: Provides global exception handling and user-friendly error responses
 * 
 * Features:
 * - Catches unhandled exceptions throughout the application
 * - Provides role-appropriate error pages
 * - Logs detailed error information for debugging
 * - Prevents sensitive error details from being exposed to users
 * - Handles both AJAX and regular HTTP requests
 * 
 * Order: Should run LAST in the filter chain (lowest priority)
 */
@WebFilter(filterName = "ExceptionHandlingFilter", urlPatterns = "/*")
public class ExceptionHandlingFilter implements Filter {

  // File extensions that should be excluded from exception handling
  private static final Set<String> EXCLUDED_EXTENSIONS = new HashSet<>(Arrays.asList(
      ".css", ".js", ".png", ".jpg", ".jpeg", ".gif", ".ico", ".svg",
      ".woff", ".woff2", ".ttf", ".eot", ".map", ".txt", ".xml"));

  // URL patterns that should be excluded
  private static final Set<String> EXCLUDED_PATTERNS = new HashSet<>(Arrays.asList(
      "/assets/", "/css/", "/js/", "/images/", "/favicon"));

  @Override
  public void init(FilterConfig filterConfig) throws ServletException {
    System.out.println("[EXCEPTION_HANDLER] ExceptionHandlingFilter initialized at " + LocalDateTime.now());
  }

  @Override
  public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
      throws IOException, ServletException {

    HttpServletRequest httpRequest = (HttpServletRequest) request;
    HttpServletResponse httpResponse = (HttpServletResponse) response;

    // Get request path
    String path = getRequestPath(httpRequest);

    // Skip exception handling for static resources
    if (shouldExcludeFromHandling(path)) {
      chain.doFilter(request, response);
      return;
    }

    try {
      // Continue with the request
      chain.doFilter(request, response);

    } catch (Exception e) {
      // Handle the exception
      handleException(httpRequest, httpResponse, e);
    }
  }

  /**
   * Get the request path without context path
   */
  private String getRequestPath(HttpServletRequest request) {
    String requestURI = request.getRequestURI();
    String contextPath = request.getContextPath();
    return requestURI.substring(contextPath.length());
  }

  /**
   * Check if the request should be excluded from exception handling
   */
  private boolean shouldExcludeFromHandling(String path) {
    // Check file extensions
    for (String extension : EXCLUDED_EXTENSIONS) {
      if (path.toLowerCase().endsWith(extension)) {
        return true;
      }
    }

    // Check URL patterns
    for (String pattern : EXCLUDED_PATTERNS) {
      if (path.startsWith(pattern)) {
        return true;
      }
    }

    return false;
  }

  /**
   * Handle exceptions that occur during request processing
   */
  private void handleException(HttpServletRequest request, HttpServletResponse response, Exception e)
      throws IOException, ServletException {

    // Log the exception details
    logException(request, e);

    // Determine the type of exception and appropriate response
    ExceptionInfo exceptionInfo = analyzeException(e);

    // Handle AJAX requests differently
    if (isAjaxRequest(request)) {
      handleAjaxException(response, exceptionInfo);
    } else {
      handleWebException(request, response, exceptionInfo);
    }
  }

  /**
   * Analyze the exception to determine appropriate response
   */
  private ExceptionInfo analyzeException(Exception e) {
    ExceptionInfo info = new ExceptionInfo();

    if (e instanceof SecurityException) {
      info.setStatusCode(HttpServletResponse.SC_FORBIDDEN);
      info.setUserMessage("Bạn không có quyền truy cập vào tài nguyên này.");
      info.setErrorType("SECURITY_ERROR");
    } else if (e instanceof IllegalArgumentException) {
      info.setStatusCode(HttpServletResponse.SC_BAD_REQUEST);
      info.setUserMessage("Dữ liệu yêu cầu không hợp lệ.");
      info.setErrorType("VALIDATION_ERROR");
    } else if (e instanceof ServletException && e.getCause() instanceof IOException) {
      info.setStatusCode(HttpServletResponse.SC_BAD_REQUEST);
      info.setUserMessage("Yêu cầu không hợp lệ.");
      info.setErrorType("REQUEST_ERROR");
    } else if (e.getMessage() != null && e.getMessage().contains("SQL")) {
      info.setStatusCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      info.setUserMessage("Đã xảy ra lỗi khi xử lý dữ liệu. Vui lòng thử lại sau.");
      info.setErrorType("DATABASE_ERROR");
    } else {
      info.setStatusCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      info.setUserMessage("Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau.");
      info.setErrorType("SYSTEM_ERROR");
    }

    info.setTechnicalMessage(e.getMessage());
    info.setException(e);

    return info;
  }

  /**
   * Handle exceptions for AJAX requests
   */
  private void handleAjaxException(HttpServletResponse response, ExceptionInfo exceptionInfo)
      throws IOException {

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.setStatus(exceptionInfo.getStatusCode());

    // Create JSON error response
    StringBuilder jsonResponse = new StringBuilder();
    jsonResponse.append("{");
    jsonResponse.append("\"error\": true,");
    jsonResponse.append("\"errorType\": \"").append(exceptionInfo.getErrorType()).append("\",");
    jsonResponse.append("\"message\": \"").append(escapeJson(exceptionInfo.getUserMessage())).append("\",");
    jsonResponse.append("\"statusCode\": ").append(exceptionInfo.getStatusCode());
    jsonResponse.append("}");

    PrintWriter out = response.getWriter();
    out.print(jsonResponse.toString());
    out.flush();
  }

  /**
   * Handle exceptions for regular web requests
   */
  private void handleWebException(HttpServletRequest request, HttpServletResponse response,
      ExceptionInfo exceptionInfo) throws ServletException, IOException {

    // Set error attributes for the error page
    request.setAttribute("errorMessage", exceptionInfo.getUserMessage());
    request.setAttribute("errorType", exceptionInfo.getErrorType());
    request.setAttribute("statusCode", exceptionInfo.getStatusCode());
    request.setAttribute("requestPath", getRequestPath(request));
    request.setAttribute("timestamp", LocalDateTime.now());

    // Set response status
    response.setStatus(exceptionInfo.getStatusCode());

    // Determine appropriate error page based on user role and error type
    String errorPage = getErrorPageForUser(request, exceptionInfo);

    try {
      request.getRequestDispatcher(errorPage).forward(request, response);
    } catch (Exception e) {
      // If error page forwarding fails, use fallback
      handleFallbackError(response, exceptionInfo);
    }
  }

  /**
   * Get appropriate error page based on user context
   */
  private String getErrorPageForUser(HttpServletRequest request, ExceptionInfo exceptionInfo) {
    HttpSession session = request.getSession(false);
    Integer userRoleId = getUserRoleId(session);

    // For security errors, always use 403 page
    if (exceptionInfo.getStatusCode() == HttpServletResponse.SC_FORBIDDEN) {
      if (userRoleId != null && !userRoleId.equals(RoleConstants.CUSTOMER_ID)) {
        return "/WEB-INF/view/admin/error-403.jsp";
      } else {
        return "/WEB-INF/view/common/error-403.jsp";
      }
    }

    // For other errors, use role-appropriate error page
    if (userRoleId != null && !userRoleId.equals(RoleConstants.CUSTOMER_ID)) {
      // Staff/Admin error page
      return "/WEB-INF/view/admin/error.jsp";
    } else {
      // Customer/Public error page
      return "/WEB-INF/view/common/error.jsp";
    }
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
   * Handle fallback error when error page forwarding fails
   */
  private void handleFallbackError(HttpServletResponse response, ExceptionInfo exceptionInfo)
      throws IOException {

    response.setContentType("text/html");
    response.setCharacterEncoding("UTF-8");

    PrintWriter out = response.getWriter();
    out.println("<!DOCTYPE html>");
    out.println("<html>");
    out.println("<head>");
    out.println("<title>Lỗi hệ thống</title>");
    out.println("<meta charset='UTF-8'>");
    out.println("<style>");
    out.println("body { font-family: Arial, sans-serif; margin: 40px; }");
    out.println(".error-container { max-width: 600px; margin: 0 auto; text-align: center; }");
    out.println(".error-code { font-size: 48px; color: #dc3545; margin-bottom: 20px; }");
    out.println(".error-message { font-size: 18px; margin-bottom: 30px; }");
    out.println(".back-link { color: #007bff; text-decoration: none; }");
    out.println("</style>");
    out.println("</head>");
    out.println("<body>");
    out.println("<div class='error-container'>");
    out.println("<div class='error-code'>" + exceptionInfo.getStatusCode() + "</div>");
    out.println("<div class='error-message'>" + exceptionInfo.getUserMessage() + "</div>");
    out.println("<a href='javascript:history.back()' class='back-link'>Quay lại</a>");
    out.println("</div>");
    out.println("</body>");
    out.println("</html>");
    out.flush();
  }

  /**
   * Check if the request is an AJAX request
   */
  private boolean isAjaxRequest(HttpServletRequest request) {
    String xRequestedWith = request.getHeader("X-Requested-With");
    String accept = request.getHeader("Accept");
    String contentType = request.getContentType();

    return "XMLHttpRequest".equals(xRequestedWith)
        || (accept != null && accept.contains("application/json"))
        || (contentType != null && contentType.contains("application/json"));
  }

  /**
   * Escape JSON special characters
   */
  private String escapeJson(String str) {
    if (str == null)
      return "";
    return str.replace("\\", "\\\\")
        .replace("\"", "\\\"")
        .replace("\n", "\\n")
        .replace("\r", "\\r")
        .replace("\t", "\\t");
  }

  /**
   * Log exception details for debugging
   */
  private void logException(HttpServletRequest request, Exception e) {
    String userInfo = "Anonymous";
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

    System.err.println("[EXCEPTION] " + LocalDateTime.now() +
        " | Path: " + getRequestPath(request) +
        " | User: " + userInfo +
        " | IP: " + request.getRemoteAddr() +
        " | Exception: " + e.getClass().getSimpleName() +
        " | Message: " + e.getMessage());

    // Print stack trace for debugging (you might want to disable this in
    // production)
    if (System.getProperty("debug.mode", "false").equals("true")) {
      e.printStackTrace();
    }
  }

  @Override
  public void destroy() {
    System.out.println("[EXCEPTION_HANDLER] ExceptionHandlingFilter destroyed at " + LocalDateTime.now());
  }

  /**
   * Data class to hold exception information
   */
  private static class ExceptionInfo {
    private int statusCode;
    private String userMessage;
    private String technicalMessage;
    private String errorType;
    private Exception exception;

    // Getters and setters
    public int getStatusCode() {
      return statusCode;
    }

    public void setStatusCode(int statusCode) {
      this.statusCode = statusCode;
    }

    public String getUserMessage() {
      return userMessage;
    }

    public void setUserMessage(String userMessage) {
      this.userMessage = userMessage;
    }

    public String getTechnicalMessage() {
      return technicalMessage;
    }

    public void setTechnicalMessage(String technicalMessage) {
      this.technicalMessage = technicalMessage;
    }

    public String getErrorType() {
      return errorType;
    }

    public void setErrorType(String errorType) {
      this.errorType = errorType;
    }

    public Exception getException() {
      return exception;
    }

    public void setException(Exception exception) {
      this.exception = exception;
    }
  }
}