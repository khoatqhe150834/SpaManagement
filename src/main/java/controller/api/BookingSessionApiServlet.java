package controller.api;

import service.BookingSessionService;
import model.BookingSession;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;
import java.util.HashMap;

public class BookingSessionApiServlet extends HttpServlet {
  private BookingSessionService bookingSessionService;
  private ObjectMapper objectMapper;

  @Override
  public void init() throws ServletException {
    this.bookingSessionService = new BookingSessionService();
    this.objectMapper = new ObjectMapper().registerModule(new JavaTimeModule());
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    try {
      // Only get existing session, do NOT create new one
      BookingSession bookingSession = bookingSessionService.getSessionFromRequest(request);

      if (bookingSession == null) {
        // Return empty response instead of error when no session exists
        Map<String, Object> emptyData = new HashMap<>();
        emptyData.put("selectedServices", new java.util.ArrayList<>());
        emptyData.put("serviceCount", 0);
        emptyData.put("sessionId", null);
        emptyData.put("currentStep", "NONE");

        Map<String, Object> response_data = Map.of(
            "success", true,
            "data", emptyData);

        response.getWriter().write(objectMapper.writeValueAsString(response_data));

        // Handle cookie setting if session ID needs to be stored
        handleCookieSetting(request, response);

        return;
      }

      // Create response data for existing session
      Map<String, Object> sessionData = new HashMap<>();

      if (bookingSession.hasServices()) {
        sessionData.put("selectedServices", bookingSession.getData().getSelectedServices());
        sessionData.put("serviceCount", bookingSession.getData().getSelectedServices().size());
      } else {
        sessionData.put("selectedServices", new java.util.ArrayList<>());
        sessionData.put("serviceCount", 0);
      }

      sessionData.put("sessionId", bookingSession.getSessionId());
      sessionData.put("currentStep", bookingSession.getCurrentStep().toString());

      Map<String, Object> response_data = Map.of(
          "success", true,
          "data", sessionData);

      response.getWriter().write(objectMapper.writeValueAsString(response_data));

      // Handle cookie setting if session ID needs to be stored
      handleCookieSetting(request, response);

    } catch (Exception e) {
      e.printStackTrace();
      sendErrorResponse(response, "Internal server error: " + e.getMessage());
    }
  }

  private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    Map<String, Object> errorResponse = Map.of(
        "success", false,
        "message", message);
    response.getWriter().write(objectMapper.writeValueAsString(errorResponse));
  }

  /**
   * Handle setting cookies for persistent session storage
   */
  private void handleCookieSetting(HttpServletRequest request, HttpServletResponse response) {
    String sessionIdToSet = (String) request.getAttribute("BOOKING_SESSION_ID_TO_SET");
    if (sessionIdToSet != null) {
      Cookie cookie = new Cookie("BOOKING_SESSION_ID", sessionIdToSet);
      cookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
      cookie.setPath("/");
      cookie.setHttpOnly(true);
      cookie.setSecure(false); // Set to true in production with HTTPS
      response.addCookie(cookie);

      // Remove the attribute after setting the cookie
      request.removeAttribute("BOOKING_SESSION_ID_TO_SET");
    }
  }
}