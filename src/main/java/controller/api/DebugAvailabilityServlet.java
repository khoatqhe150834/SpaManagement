package controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
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

/**
 * Debug servlet to investigate availability calculation issues
 */
@WebServlet(name = "DebugAvailabilityServlet", urlPatterns = { "/api/debug-availability" })
public class DebugAvailabilityServlet extends HttpServlet {

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

    // Initialize CSP solver
    try {
      CSPDomain domain = new CSPDomain();
      List<CSPConstraint> constraints = Arrays.asList(
          new NoDoubleBookingConstraint(),
          new BufferTimeConstraint());
      cspSolver = new CSPSolver(domain, constraints);
    } catch (Exception e) {
      throw new ServletException("Failed to initialize CSP Solver", e);
    }
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.setHeader("Access-Control-Allow-Origin", "*");

    PrintWriter out = response.getWriter();

    try {
      String serviceIdParam = request.getParameter("serviceId");
      String dateParam = request.getParameter("date");

      if (serviceIdParam == null) {
        serviceIdParam = "1"; // Default to service ID 1
      }
      if (dateParam == null) {
        dateParam = LocalDate.now().plusDays(25).toString(); // Default to day 25
      }

      int serviceId = Integer.parseInt(serviceIdParam);
      LocalDate targetDate = LocalDate.parse(dateParam);

      JsonObject debugInfo = new JsonObject();
      debugInfo.addProperty("serviceId", serviceId);
      debugInfo.addProperty("targetDate", targetDate.toString());

      // Get service info
      Service service = serviceDAO.findById(serviceId).orElse(null);
      if (service == null) {
        debugInfo.addProperty("error", "Service not found");
        out.print(gson.toJson(debugInfo));
        return;
      }

      debugInfo.addProperty("serviceName", service.getName());
      debugInfo.addProperty("serviceTypeId", service.getServiceTypeId().getServiceTypeId());
      debugInfo.addProperty("serviceDuration", service.getDurationMinutes());

      // Get compatible therapists
      List<Staff> compatibleTherapists = staffDAO.findTherapistsByServiceType(
          service.getServiceTypeId().getServiceTypeId());
      debugInfo.addProperty("compatibleTherapistsCount", compatibleTherapists.size());

      List<String> therapistNames = new ArrayList<>();
      for (Staff therapist : compatibleTherapists) {
        therapistNames.add(therapist.getUser().getFullName() + " (" + therapist.getAvailabilityStatus() + ")");
      }
      debugInfo.add("therapistList", gson.toJsonTree(therapistNames));

      // Get all valid slots using CSP solver
      List<Assignment> allValidSlots = cspSolver.getAllValidSlots(service);
      debugInfo.addProperty("totalValidSlots", allValidSlots.size());

      // Filter slots for target date
      List<Assignment> slotsForDate = new ArrayList<>();
      for (Assignment slot : allValidSlots) {
        if (slot.getStartTime().toLocalDate().equals(targetDate)) {
          slotsForDate.add(slot);
        }
      }
      debugInfo.addProperty("slotsForTargetDate", slotsForDate.size());

      // Detailed slot breakdown
      List<String> slotDetails = new ArrayList<>();
      for (Assignment slot : slotsForDate) {
        String detail = slot.getStartTime().toString() + " - " +
            slot.getTherapist().getUser().getFullName();
        slotDetails.add(detail);
      }
      debugInfo.add("slotDetails", gson.toJsonTree(slotDetails));

      // Check domain info
      CSPDomain domain = new CSPDomain();
      List<LocalDateTime> allPossibleTimes = domain.getAllPossibleDateTimes();

      // Count times for target date
      int timeSlotsForDate = 0;
      for (LocalDateTime time : allPossibleTimes) {
        if (time.toLocalDate().equals(targetDate)) {
          timeSlotsForDate++;
        }
      }
      debugInfo.addProperty("possibleTimeSlotsForDate", timeSlotsForDate);

      // Check if date is holiday
      debugInfo.addProperty("isHoliday", isDateHoliday(targetDate));

      // Calculate expected vs actual slots
      int expectedSlots = compatibleTherapists.size() * timeSlotsForDate;
      debugInfo.addProperty("expectedSlots", expectedSlots);
      debugInfo.addProperty("actualSlots", slotsForDate.size());
      debugInfo.addProperty("constraintReduction", expectedSlots - slotsForDate.size());

      // Debug specific date: June 25, 2025
      LocalDate today = LocalDate.now();

      debugInfo.addProperty("serverToday", today.toString());
      debugInfo.addProperty("serverDateTime", LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
      debugInfo.addProperty("isPastLogic", targetDate.isBefore(today));
      debugInfo.addProperty("isToday", targetDate.equals(today));
      debugInfo.addProperty("isFuture", targetDate.isAfter(today));

      // Test CSP Domain for this date
      CSPDomain domainForTest = new CSPDomain();
      List<LocalDateTime> allSlots = domainForTest.getAllPossibleDateTimes();

      List<LocalDateTime> slotsForTargetDate = allSlots.stream()
          .filter(slot -> slot.toLocalDate().equals(targetDate))
          .collect(java.util.stream.Collectors.toList());

      debugInfo.addProperty("totalSlotsGenerated", allSlots.size());
      debugInfo.addProperty("slotsForTargetDate", slotsForTargetDate.size());
      debugInfo.addProperty("firstSlotOnTargetDate",
          slotsForTargetDate.isEmpty() ? "NONE" : slotsForTargetDate.get(0).toString());
      debugInfo.addProperty("lastSlotOnTargetDate",
          slotsForTargetDate.isEmpty() ? "NONE" : slotsForTargetDate.get(slotsForTargetDate.size() - 1).toString());

      // Test specific service availability
      Service testService = serviceDAO.findById(1).orElse(null);
      if (testService != null) {
        List<Assignment> validSlots = cspSolver.getAllValidSlots(testService);
        List<Assignment> slotsForDateTest = validSlots.stream()
            .filter(assignment -> assignment.getStartTime().toLocalDate().equals(targetDate))
            .collect(java.util.stream.Collectors.toList());

        debugInfo.addProperty("testServiceId", testService.getServiceId());
        debugInfo.addProperty("testServiceName", testService.getName());
        debugInfo.addProperty("validSlotsForService", slotsForDateTest.size());

        if (!slotsForDateTest.isEmpty()) {
          debugInfo.addProperty("firstValidSlot", slotsForDateTest.get(0).getStartTime().toString());
          debugInfo.addProperty("lastValidSlot",
              slotsForDateTest.get(slotsForDateTest.size() - 1).getStartTime().toString());
        }
      }

      // Test what the calendar API would return
      Map<String, Object> calendarResult = testCalendarAPILogic(targetDate);
      debugInfo.add("calendarAPIResult", gson.toJsonTree(calendarResult));

      out.print(gson.toJson(debugInfo));

    } catch (Exception e) {
      JsonObject errorResponse = new JsonObject();
      errorResponse.addProperty("error", "Debug error: " + e.getMessage());
      errorResponse.addProperty("stackTrace", e.toString());
      out.print(gson.toJson(errorResponse));
    } finally {
      out.flush();
      out.close();
    }
  }

  private boolean isDateHoliday(LocalDate date) {
    // Check if date falls on known holidays that might affect availability
    int year = date.getYear();
    int month = date.getMonthValue();
    int day = date.getDayOfMonth();

    // Vietnam holidays
    if (month == 1 && day == 1)
      return true; // New Year
    if (month == 4 && day == 30)
      return true; // Liberation Day
    if (month == 5 && day == 1)
      return true; // Labour Day
    if (month == 9 && day == 2)
      return true; // National Day

    // Tet holidays 2025
    if (year == 2025 && month == 1 && day >= 28)
      return true;
    if (year == 2025 && month == 2 && day <= 3)
      return true;

    return false;
  }

  private Map<String, Object> testCalendarAPILogic(LocalDate date) {
    Map<String, Object> result = new HashMap<>();

    LocalDate today = LocalDate.now();
    result.put("inputDate", date.toString());
    result.put("serverToday", today.toString());
    result.put("isPastCheck", date.isBefore(today));

    if (date.isBefore(today)) {
      result.put("status", "past");
      result.put("available", false);
      result.put("availableSlots", 0);
      result.put("reason", "Date is before today according to date.isBefore(today)");
    } else {
      // This mimics the actual calendar API logic
      try {
        int totalAvailableSlots = 0;
        boolean hasAnyAvailability = false;

        // Get all services for general availability check (same as API)
        List<Service> allServices = serviceDAO.findAll();
        Set<LocalDateTime> uniqueTimeSlots = new HashSet<>();

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

        result.put("hasAnyAvailability", hasAnyAvailability);
        result.put("totalAvailableSlots", totalAvailableSlots);
        result.put("isFullyBooked", totalAvailableSlots == 0);

        if (totalAvailableSlots == 0) {
          result.put("status", "fully-booked");
        } else if (hasAnyAvailability && totalAvailableSlots > 5) {
          result.put("status", "available");
        } else if (hasAnyAvailability) {
          result.put("status", "limited");
        } else {
          result.put("status", "unavailable");
        }

        result.put("available", hasAnyAvailability);
        result.put("availableSlots", totalAvailableSlots);

      } catch (Exception e) {
        result.put("error", e.getMessage());
        result.put("status", "error");
      }
    }

    return result;
  }

  private List<Assignment> getValidSlotsForDate(Service service, LocalDate date) {
    // Get all valid slots for the service using CSPSolver
    List<Assignment> allValidSlots = cspSolver.getAllValidSlots(service);

    // Filter slots for the specific date
    return allValidSlots.stream()
        .filter(assignment -> assignment.getStartTime().toLocalDate().equals(date))
        .collect(java.util.stream.Collectors.toList());
  }
}