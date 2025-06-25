package controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import dao.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Fast API for checking time slot conflicts in real-time
 * Uses lightweight CSP constraint checking without full solver
 */
@WebServlet(name = "TimeConflictApiServlet", urlPatterns = { "/api/time-conflicts" })
public class TimeConflictApiServlet extends HttpServlet {

  private ServiceDAO serviceDAO;
  private Gson gson;
  private List<CSPConstraint> constraints;

  // Cache for performance optimization
  private final ConcurrentHashMap<String, JsonObject> conflictCache = new ConcurrentHashMap<>();
  private static final long CACHE_EXPIRY_MS = 30000; // 30 seconds

  @Override
  public void init() throws ServletException {
    super.init();
    serviceDAO = new ServiceDAO();
    gson = new Gson();

    // Initialize lightweight constraints (no database-heavy operations)
    constraints = Arrays.asList(
        new BookingSessionConflictConstraint()
    // Note: We'll handle customer/therapist conflicts separately for speed
    );
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.setHeader("Access-Control-Allow-Origin", "*");

    try (PrintWriter out = response.getWriter()) {
      String action = request.getParameter("action");

      if ("check-conflicts".equals(action)) {
        handleConflictCheck(request, response, out);
      } else {
        sendErrorResponse(out, "Invalid action", 400);
      }
    } catch (Exception e) {
      e.printStackTrace();
      response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      try (PrintWriter out = response.getWriter()) {
        sendErrorResponse(out, "Internal server error: " + e.getMessage(), 500);
      }
    }
  }

  /**
   * Fast conflict checking for real-time validation
   * Input: current service selections + new time selection
   * Output: list of conflicting time slots
   */
  private void handleConflictCheck(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
      throws IOException {

    // Parse request parameters
    String serviceIdStr = request.getParameter("serviceId");
    String dateStr = request.getParameter("date");
    String currentSelectionsJson = request.getParameter("currentSelections");

    if (serviceIdStr == null || dateStr == null) {
      sendErrorResponse(out, "Missing required parameters: serviceId, date", 400);
      return;
    }

    try {
      int serviceId = Integer.parseInt(serviceIdStr);

      // Create cache key for performance
      String cacheKey = serviceId + ":" + dateStr + ":"
          + (currentSelectionsJson != null ? currentSelectionsJson.hashCode() : "empty");

      // Check cache first
      JsonObject cachedResult = conflictCache.get(cacheKey);
      if (cachedResult != null) {
        out.write(gson.toJson(cachedResult));
        return;
      }

      // Get service details
      Service service = serviceDAO.findById(serviceId).orElse(null);
      if (service == null) {
        sendErrorResponse(out, "Service not found", 404);
        return;
      }

      // Parse current selections
      List<ServiceSelection> currentSelections = parseCurrentSelections(currentSelectionsJson);

      // Use async processing for better performance
      CompletableFuture<JsonObject> conflictCheck = CompletableFuture.supplyAsync(() -> {
        return checkTimeConflictsForDate(service, dateStr, currentSelections);
      });

      // Get result with timeout (max 2 seconds)
      JsonObject result = conflictCheck.get(2, java.util.concurrent.TimeUnit.SECONDS);

      // Cache the result
      conflictCache.put(cacheKey, result);

      // Clean old cache entries periodically
      if (conflictCache.size() > 100) {
        cleanCache();
      }

      out.write(gson.toJson(result));

    } catch (Exception e) {
      System.err.println("Error in conflict check: " + e.getMessage());
      e.printStackTrace();
      sendErrorResponse(out, "Error checking conflicts: " + e.getMessage(), 500);
    }
  }

  /**
   * Lightweight conflict checking for a specific date
   */
  private JsonObject checkTimeConflictsForDate(Service service, String dateStr,
      List<ServiceSelection> currentSelections) {
    JsonObject result = new JsonObject();
    JsonArray conflictingSlots = new JsonArray();

    try {
      // Generate time slots for the date (7:00 AM to 7:00 PM, 30-minute intervals)
      List<String> allTimeSlots = generateTimeSlots();

      for (String timeSlot : allTimeSlots) {
        LocalDateTime proposedDateTime = LocalDateTime.parse(dateStr + "T" + timeSlot);

        // Check if this time conflicts with current selections
        boolean hasConflict = checkConflictWithCurrentSelections(
            service, proposedDateTime, currentSelections);

        if (hasConflict) {
          JsonObject conflict = new JsonObject();
          conflict.addProperty("time", timeSlot);
          conflict.addProperty("dateTime", proposedDateTime.toString());
          conflict.addProperty("reason", "Overlaps with selected services");
          conflictingSlots.add(conflict);
        }
      }

      result.addProperty("success", true);
      result.addProperty("serviceId", service.getServiceId());
      result.addProperty("date", dateStr);
      result.addProperty("conflictCount", conflictingSlots.size());
      result.add("conflictingSlots", conflictingSlots);

    } catch (Exception e) {
      result.addProperty("success", false);
      result.addProperty("error", e.getMessage());
    }

    return result;
  }

  /**
   * Fast conflict checking using CSP constraints
   */
  private boolean checkConflictWithCurrentSelections(Service service, LocalDateTime proposedTime,
      List<ServiceSelection> currentSelections) {

    if (currentSelections == null || currentSelections.isEmpty()) {
      return false; // No conflicts if no current selections
    }

    // Create CSP variables for current selections + proposed selection
    List<CSPVariable> variables = new ArrayList<>();

    // Add current selections as variables
    for (ServiceSelection selection : currentSelections) {
      if (selection.getScheduledTime() != null && selection.getServiceId() != service.getServiceId()) {
        Service selectionService = serviceDAO.findById(selection.getServiceId()).orElse(null);
        if (selectionService != null) {
          CSPVariable var = new CSPVariable(selectionService, selection.getScheduledTime(), null, true);
          variables.add(var);
        }
      }
    }

    // Add proposed selection as variable
    CSPVariable proposedVariable = new CSPVariable(service, proposedTime, null, true);
    variables.add(proposedVariable);

    // Check constraints (only session conflicts for speed)
    for (CSPConstraint constraint : constraints) {
      if (constraint.isApplicable(variables) && !constraint.isSatisfied(variables)) {
        return true; // Conflict found
      }
    }

    return false; // No conflicts
  }

  /**
   * Generate all possible time slots for a day
   */
  private List<String> generateTimeSlots() {
    List<String> timeSlots = new ArrayList<>();

    // Business hours: 7:00 AM to 7:00 PM, 30-minute intervals
    int startHour = 7;
    int endHour = 19;
    int intervalMinutes = 30;

    for (int hour = startHour; hour < endHour; hour++) {
      for (int minute = 0; minute < 60; minute += intervalMinutes) {
        timeSlots.add(String.format("%02d:%02d", hour, minute));
      }
    }

    return timeSlots;
  }

  /**
   * Parse current selections from JSON
   */
  private List<ServiceSelection> parseCurrentSelections(String json) {
    List<ServiceSelection> selections = new ArrayList<>();

    if (json == null || json.trim().isEmpty()) {
      return selections;
    }

    try {
      // Parse the JSON structure from frontend
      JsonObject selectionsObj = gson.fromJson(json, JsonObject.class);

      for (String serviceId : selectionsObj.keySet()) {
        JsonObject selection = selectionsObj.getAsJsonObject(serviceId);

        ServiceSelection serviceSelection = new ServiceSelection();
        serviceSelection.setServiceId(Integer.parseInt(serviceId));

        if (selection.has("date") && selection.has("time")) {
          String date = selection.get("date").getAsString();
          String time = selection.get("time").getAsString();
          serviceSelection.setScheduledTime(LocalDateTime.parse(date + "T" + time));
        }

        selections.add(serviceSelection);
      }
    } catch (Exception e) {
      System.err.println("Error parsing current selections: " + e.getMessage());
    }

    return selections;
  }

  /**
   * Clean expired cache entries
   */
  private void cleanCache() {
    // Simple cache cleanup - remove half the entries
    int targetSize = conflictCache.size() / 2;
    Iterator<String> iterator = conflictCache.keySet().iterator();
    int removed = 0;

    while (iterator.hasNext() && removed < targetSize) {
      iterator.next();
      iterator.remove();
      removed++;
    }
  }

  /**
   * Send error response
   */
  private void sendErrorResponse(PrintWriter out, String message, int statusCode) {
    JsonObject error = new JsonObject();
    error.addProperty("success", false);
    error.addProperty("error", message);
    error.addProperty("statusCode", statusCode);
    out.write(gson.toJson(error));
  }

  /**
   * Simple service selection class for parsing
   */
  private static class ServiceSelection {
    private int serviceId;
    private LocalDateTime scheduledTime;

    public int getServiceId() {
      return serviceId;
    }

    public void setServiceId(int serviceId) {
      this.serviceId = serviceId;
    }

    public LocalDateTime getScheduledTime() {
      return scheduledTime;
    }

    public void setScheduledTime(LocalDateTime scheduledTime) {
      this.scheduledTime = scheduledTime;
    }
  }
}