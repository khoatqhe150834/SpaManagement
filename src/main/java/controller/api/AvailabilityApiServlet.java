package controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import dao.BookingAppointmentDAO;
import dao.ServiceDAO;
import dao.StaffDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * API Servlet for checking appointment availability using CSPSolver
 * Provides calendar data showing which days have available slots
 */
@WebServlet(name = "AvailabilityApiServlet", urlPatterns = { "/api/availability", "/api/calendar-availability" })
public class AvailabilityApiServlet extends HttpServlet {

  private ServiceDAO serviceDAO;
  private StaffDAO staffDAO;
  private Gson gson;
  private CSPSolver cspSolver;

  @Override
  public void init() throws ServletException {
    super.init();
    serviceDAO = new ServiceDAO();
    staffDAO = new StaffDAO();
    gson = new Gson();

    // Initialize CSP solver with domain and constraints
    CSPDomain globalDomain = new CSPDomain();
    List<CSPConstraint> constraints = Arrays.asList(
        new NoDoubleBookingConstraint(),
        new BufferTimeConstraint(),
        new BookingSessionConflictConstraint());
    cspSolver = new CSPSolver(globalDomain, constraints);
    cspSolver.setUseForwardChecking(true);
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // Set response headers
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type");

    PrintWriter out = response.getWriter();

    try {
      String action = request.getParameter("action");
      if (action == null) {
        action = "calendar";
      }

      switch (action) {
        case "calendar":
          handleCalendarAvailability(request, response, out);
          break;
        case "time-slots":
          handleTimeSlotAvailability(request, response, out);
          break;
        case "service-availability":
          handleServiceAvailability(request, response, out);
          break;
        default:
          sendErrorResponse(out, "Invalid action parameter", HttpServletResponse.SC_BAD_REQUEST);
      }

    } catch (Exception e) {
      System.err.println("Error in AvailabilityApiServlet: " + e.getMessage());
      e.printStackTrace();
      sendErrorResponse(out, "Internal server error: " + e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    } finally {
      out.flush();
      out.close();
    }
  }

  /**
   * Handle calendar availability - returns availability status for each day in a
   * month
   */
  private void handleCalendarAvailability(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
      throws IOException {

    String serviceIdsParam = request.getParameter("serviceIds");
    String yearParam = request.getParameter("year");
    String monthParam = request.getParameter("month");

    // Default to current month if not specified
    LocalDate now = LocalDate.now();
    int year = yearParam != null ? Integer.parseInt(yearParam) : now.getYear();
    int month = monthParam != null ? Integer.parseInt(monthParam) : now.getMonthValue();

    JsonObject jsonResponse = new JsonObject();

    try {
      List<Integer> serviceIds = new ArrayList<>();
      if (serviceIdsParam != null && !serviceIdsParam.trim().isEmpty()) {
        serviceIds = Arrays.stream(serviceIdsParam.split(","))
            .map(String::trim)
            .map(Integer::parseInt)
            .collect(Collectors.toList());
      }

      // Generate calendar data for the month
      Map<String, Object> calendarData = generateMonthlyAvailability(serviceIds, year, month);

      jsonResponse.addProperty("success", true);
      jsonResponse.addProperty("year", year);
      jsonResponse.addProperty("month", month);
      jsonResponse.add("days", gson.toJsonTree(calendarData.get("days")));
      jsonResponse.add("summary", gson.toJsonTree(calendarData.get("summary")));

      out.print(gson.toJson(jsonResponse));

    } catch (Exception e) {
      sendErrorResponse(out, "Error generating calendar availability: " + e.getMessage(),
          HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
  }

  /**
   * Handle time slot availability for a specific date and service
   */
  private void handleTimeSlotAvailability(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
      throws IOException {

    String serviceIdParam = request.getParameter("serviceId");
    String dateParam = request.getParameter("date");

    if (serviceIdParam == null || dateParam == null) {
      sendErrorResponse(out, "serviceId and date parameters are required", HttpServletResponse.SC_BAD_REQUEST);
      return;
    }

    try {
      int serviceId = Integer.parseInt(serviceIdParam);
      LocalDate date = LocalDate.parse(dateParam);

      Service service = serviceDAO.findById(serviceId).orElse(null);
      if (service == null) {
        sendErrorResponse(out, "Service not found", HttpServletResponse.SC_NOT_FOUND);
        return;
      }

      List<Map<String, Object>> timeSlots = generateTimeSlotsForDate(service, date);

      JsonObject jsonResponse = new JsonObject();
      jsonResponse.addProperty("success", true);
      jsonResponse.addProperty("serviceId", serviceId);
      jsonResponse.addProperty("date", dateParam);
      jsonResponse.add("timeSlots", gson.toJsonTree(timeSlots));

      out.print(gson.toJson(jsonResponse));

    } catch (Exception e) {
      sendErrorResponse(out, "Error generating time slots: " + e.getMessage(),
          HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
  }

  /**
   * Handle service-specific availability checking
   */
  private void handleServiceAvailability(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
      throws IOException {

    String serviceIdParam = request.getParameter("serviceId");

    if (serviceIdParam == null) {
      sendErrorResponse(out, "serviceId parameter is required", HttpServletResponse.SC_BAD_REQUEST);
      return;
    }

    try {
      int serviceId = Integer.parseInt(serviceIdParam);
      Service service = serviceDAO.findById(serviceId).orElse(null);

      if (service == null) {
        sendErrorResponse(out, "Service not found", HttpServletResponse.SC_NOT_FOUND);
        return;
      }

      // Use CSPSolver to get all valid slots for this service
      List<Assignment> validSlots = cspSolver.getAllValidSlots(service);

      JsonObject jsonResponse = new JsonObject();
      jsonResponse.addProperty("success", true);
      jsonResponse.addProperty("serviceId", serviceId);
      jsonResponse.addProperty("totalAvailableSlots", validSlots.size());
      jsonResponse.add("availableSlots", gson.toJsonTree(convertAssignmentsToJson(validSlots)));

      out.print(gson.toJson(jsonResponse));

    } catch (Exception e) {
      sendErrorResponse(out, "Error checking service availability: " + e.getMessage(),
          HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
  }

  /**
   * Generate monthly availability data using CSPSolver
   */
  private Map<String, Object> generateMonthlyAvailability(List<Integer> serviceIds, int year, int month) {
    Map<String, Object> result = new HashMap<>();
    List<Map<String, Object>> dayData = new ArrayList<>();
    Map<String, Integer> summary = new HashMap<>();

    LocalDate firstDay = LocalDate.of(year, month, 1);
    LocalDate lastDay = firstDay.withDayOfMonth(firstDay.lengthOfMonth());

    int availableDays = 0;
    int fullyBookedDays = 0;
    int partiallyAvailableDays = 0;

    // Check availability for each day in the month
    for (LocalDate date = firstDay; !date.isAfter(lastDay); date = date.plusDays(1)) {
      Map<String, Object> dayInfo = new HashMap<>();
      dayInfo.put("date", date.toString());
      dayInfo.put("dayOfMonth", date.getDayOfMonth());
      dayInfo.put("dayOfWeek", date.getDayOfWeek().name());

      // Check if this is a past date (but allow today)
      LocalDate today = LocalDate.now();
      System.out
          .println("DEBUG: Checking date " + date + " against today " + today + " - isPast: " + date.isBefore(today));
      if (date.isBefore(today)) {
        dayInfo.put("status", "past");
        dayInfo.put("available", false);
        dayInfo.put("availableSlots", 0);
        System.out.println("DEBUG: Marking " + date + " as past");
      } else {
        DayAvailability availability = checkDayAvailability(serviceIds, date);
        dayInfo.put("status", availability.getStatus());
        dayInfo.put("available", availability.isAvailable());
        dayInfo.put("availableSlots", availability.getAvailableSlots());
        dayInfo.put("fullyBooked", availability.isFullyBooked());

        // Update summary counters
        if (availability.isFullyBooked()) {
          fullyBookedDays++;
        } else if (availability.isAvailable()) {
          if (availability.getAvailableSlots() > 5) {
            availableDays++;
          } else {
            partiallyAvailableDays++;
          }
        }
      }

      dayData.add(dayInfo);
    }

    summary.put("availableDays", availableDays);
    summary.put("fullyBookedDays", fullyBookedDays);
    summary.put("partiallyAvailableDays", partiallyAvailableDays);
    summary.put("totalDays", dayData.size());

    result.put("days", dayData);
    result.put("summary", summary);

    return result;
  }

  /**
   * Check availability for a specific day
   */
  private DayAvailability checkDayAvailability(List<Integer> serviceIds, LocalDate date) {
    int totalAvailableSlots = 0;
    boolean hasAnyAvailability = false;

    // If no specific services provided, check general availability
    if (serviceIds.isEmpty()) {
      // For general calendar view, show unique time slots instead of counting all
      // services
      // This prevents the "309 slots" issue where slots are counted multiple times
      Set<LocalDateTime> uniqueTimeSlots = new HashSet<>();

      // Get all services for general availability check
      List<Service> allServices = serviceDAO.findAll();

      for (Service service : allServices) {
        List<Assignment> validSlots = getValidSlotsForDate(service, date);
        for (Assignment slot : validSlots) {
          uniqueTimeSlots.add(slot.getStartTime());
        }
        if (!validSlots.isEmpty()) {
          hasAnyAvailability = true;
        }
      }

      totalAvailableSlots = uniqueTimeSlots.size();
    } else {
      // For specific service selection, count actual slots for those services
      for (Integer serviceId : serviceIds) {
        Service service = serviceDAO.findById(serviceId).orElse(null);
        if (service != null) {
          List<Assignment> validSlots = getValidSlotsForDate(service, date);
          totalAvailableSlots += validSlots.size();
          if (!validSlots.isEmpty()) {
            hasAnyAvailability = true;
          }
        }
      }
    }

    return new DayAvailability(hasAnyAvailability, totalAvailableSlots, totalAvailableSlots == 0);
  }

  /**
   * Get valid slots for a service on a specific date
   */
  private List<Assignment> getValidSlotsForDate(Service service, LocalDate date) {
    // Get all valid slots for the service using CSPSolver
    List<Assignment> allValidSlots = cspSolver.getAllValidSlots(service);

    // Filter slots for the specific date
    return allValidSlots.stream()
        .filter(assignment -> assignment.getStartTime().toLocalDate().equals(date))
        .collect(Collectors.toList());
  }

  /**
   * Generate time slots for a specific date and service
   */
  private List<Map<String, Object>> generateTimeSlotsForDate(Service service, LocalDate date) {
    List<Map<String, Object>> timeSlots = new ArrayList<>();
    List<Assignment> validSlots = getValidSlotsForDate(service, date);

    // Group by time and aggregate therapists
    Map<LocalDateTime, List<Assignment>> slotsByTime = validSlots.stream()
        .collect(Collectors.groupingBy(Assignment::getStartTime));

    // Convert to time slot format
    for (Map.Entry<LocalDateTime, List<Assignment>> entry : slotsByTime.entrySet()) {
      LocalDateTime time = entry.getKey();
      List<Assignment> assignments = entry.getValue();

      // Filter out assignments for therapists who are actually busy during this time
      List<Assignment> actuallyAvailableAssignments = filterActuallyAvailableTherapists(assignments, service);

      Map<String, Object> timeSlot = new HashMap<>();
      timeSlot.put("time", time.format(DateTimeFormatter.ofPattern("HH:mm")));
      timeSlot.put("dateTime", time.toString());
      timeSlot.put("available", !actuallyAvailableAssignments.isEmpty());
      timeSlot.put("therapistCount", actuallyAvailableAssignments.size()); // Count only genuinely free therapists

      List<Map<String, Object>> availableTherapists = actuallyAvailableAssignments.stream()
          .map(assignment -> {
            Map<String, Object> therapist = new HashMap<>();
            therapist.put("therapistId", assignment.getTherapist().getUser().getUserId());
            therapist.put("therapistName", assignment.getTherapist().getUser().getFullName());
            return therapist;
          })
          .collect(Collectors.toList());

      timeSlot.put("availableTherapists", availableTherapists);

      // Only add time slot if there are actually available therapists
      if (!actuallyAvailableAssignments.isEmpty()) {
        timeSlots.add(timeSlot);
      }
    }

    // Sort by time
    timeSlots.sort((a, b) -> ((String) a.get("time")).compareTo((String) b.get("time")));

    return timeSlots;
  }

  /**
   * Filter assignments to only include therapists who are genuinely available
   * during the time slot
   */
  private List<Assignment> filterActuallyAvailableTherapists(List<Assignment> assignments, Service service) {
    List<Assignment> actuallyAvailable = new ArrayList<>();
    BookingAppointmentDAO bookingDAO = new BookingAppointmentDAO(); // Create once outside the loop

    System.out.println("DEBUG: Filtering " + assignments.size() + " assignments for service " + service.getName());

    for (Assignment assignment : assignments) {
      LocalDateTime startTime = assignment.getStartTime();
      LocalDateTime endTime = startTime.plusMinutes(service.getDurationMinutes());
      int therapistId = assignment.getTherapist().getUser().getUserId();

      System.out.println("DEBUG: Checking therapist " + therapistId + " ("
          + assignment.getTherapist().getUser().getFullName() + ") for " + startTime);

      // Check if this therapist actually has conflicts during this time
      try {
        List<BookingAppointment> conflicts = bookingDAO.findByTherapistAndTimeRange(therapistId, startTime, endTime);

        System.out.println("DEBUG: Therapist " + therapistId + " has " + conflicts.size() + " conflicts");

        // Only include this assignment if the therapist has no conflicts
        if (conflicts.isEmpty()) {
          actuallyAvailable.add(assignment);
          System.out.println("DEBUG: ✅ Added therapist " + therapistId + " to available list");
        } else {
          System.out.println("DEBUG: ❌ Excluded therapist " + therapistId + " due to conflicts");
          for (BookingAppointment conflict : conflicts) {
            System.out.println("DEBUG:   - Conflict: " + conflict.getStartTime() + " to " + conflict.getEndTime());
          }
        }
      } catch (Exception e) {
        System.err
            .println("Error checking therapist availability for therapist " + therapistId + ": " + e.getMessage());
        e.printStackTrace();
        // In case of error, exclude the therapist for safety
      }
    }

    System.out.println(
        "DEBUG: Final result: " + actuallyAvailable.size() + " available therapists out of " + assignments.size());
    return actuallyAvailable;
  }

  /**
   * Convert Assignment objects to JSON-friendly format
   */
  private List<Map<String, Object>> convertAssignmentsToJson(List<Assignment> assignments) {
    return assignments.stream()
        .map(assignment -> {
          Map<String, Object> slot = new HashMap<>();
          slot.put("therapistId", assignment.getTherapist().getUser().getUserId());
          slot.put("therapistName", assignment.getTherapist().getUser().getFullName());
          slot.put("startTime", assignment.getStartTime().toString());
          slot.put("date", assignment.getStartTime().toLocalDate().toString());
          slot.put("time", assignment.getStartTime().format(DateTimeFormatter.ofPattern("HH:mm")));
          return slot;
        })
        .collect(Collectors.toList());
  }

  /**
   * Send error response
   */
  private void sendErrorResponse(PrintWriter out, String message, int statusCode) {
    JsonObject errorResponse = new JsonObject();
    errorResponse.addProperty("success", false);
    errorResponse.addProperty("message", message);
    errorResponse.addProperty("statusCode", statusCode);
    out.print(gson.toJson(errorResponse));
  }

  @Override
  protected void doOptions(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // Handle CORS preflight requests
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type");
    response.setStatus(HttpServletResponse.SC_OK);
  }

  /**
   * Helper class to represent day availability
   */
  private static class DayAvailability {
    private final boolean available;
    private final int availableSlots;
    private final boolean fullyBooked;

    public DayAvailability(boolean available, int availableSlots, boolean fullyBooked) {
      this.available = available;
      this.availableSlots = availableSlots;
      this.fullyBooked = fullyBooked;
    }

    public boolean isAvailable() {
      return available;
    }

    public int getAvailableSlots() {
      return availableSlots;
    }

    public boolean isFullyBooked() {
      return fullyBooked;
    }

    public String getStatus() {
      if (fullyBooked)
        return "fully-booked";
      if (available && availableSlots > 5)
        return "available";
      if (available)
        return "limited";
      return "unavailable";
    }
  }
}