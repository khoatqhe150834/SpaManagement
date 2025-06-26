package controller.api;

import service.BookingSessionService;
import model.BookingSession;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import jakarta.servlet.ServletException;
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
      // Get booking session
      BookingSession bookingSession = bookingSessionService.getOrCreateSession(request);

      if (bookingSession == null) {
        sendErrorResponse(response, "No booking session found");
        return;
      }

      // Create response data
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
}