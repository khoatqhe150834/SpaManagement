package util;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

/**
 * Centralized security configuration for the application.
 * Contains shared constants and configurations used by security filters.
 */
public class SecurityConfig {

  // Public URLs that don't require authentication
  public static final Set<String> PUBLIC_URLS = new HashSet<>(Arrays.asList(
      "/login", "/register", "/logout", "/", "/index.jsp",
      "/verify-email", "/email-verification-required", "/resend-verification",
      "/password/reset", "/password-reset-form",
      "/about", "/contact", "/services", "/service-details", "/blog", "/password-reset/new",
      "/password-reset/request", "/recently-viewed", "/most-purchased",
      "/password-reset/edit",
      "/password-reset/update",
      "/test", "/TestController", "/api/booking-session", "/api/services", "/api/most-purchased",
      "/api/service-types", "/error", "/api/homepage", "/result.jsp", "/test.jsp",
      "/chatbot", "/chat", "/api/chat", "/api/chatbot", "/test-chatbot.jsp", "/debug-chatbot.jsp", "/test-security.jsp", "/test-direct-api.jsp", "/simple-api-test.jsp", "/image",
      "/test/booking", "/test-booking.jsp", "/api/therapist-schedule"));

  // File extensions that don't require authentication
  public static final Set<String> PUBLIC_EXTENSIONS = new HashSet<>(Arrays.asList(
      ".css", ".js", ".png", ".jpg", ".jpeg", ".gif", ".ico", ".svg",
      ".woff", ".woff2", ".ttf", ".eot", ".html", ".txt", ".xml", ".jsp"));

  // URL patterns that don't require authentication
  public static final Set<String> PUBLIC_PATTERNS = new HashSet<>(Arrays.asList(
      "/assets/", "/uploads/", "/services/", "/css/", "/js/", "/images/", "/favicon", "/debug/", "/test/*",
      "/api/booking-session", "/api/services", "/api/services/*", "/api/most-purchased", "/api/service-types",
      "/api/homepage", "/api/chat", "/api/chatbot", "/api/therapist-schedule", "/api/csp-booking/*"));

  /**
   * Check if the given path is a public resource
   * 
   * @param path The path to check
   * @return true if the path is public, false otherwise
   */
  public static boolean isPublicResource(String path) {
    // Check exact URLs
    if (PUBLIC_URLS.contains(path)) {
      return true;
    }

    // Check file extensions
    for (String extension : PUBLIC_EXTENSIONS) {
      if (path.toLowerCase().endsWith(extension)) {
        return true;
      }
    }

    // Check URL patterns
    for (String pattern : PUBLIC_PATTERNS) {
      if (path.startsWith(pattern)) {
        return true;
      }
    }

    return false;
  }
}