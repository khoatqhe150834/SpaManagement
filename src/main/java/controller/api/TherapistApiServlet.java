package controller.api;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;
import dao.StaffDAO;
import dao.ServiceDAO;
import model.Staff;
import model.Service;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Arrays;
import java.util.stream.Collectors;

@WebServlet(name = "TherapistApiServlet", urlPatterns = { "/api/therapists" })
public class TherapistApiServlet extends HttpServlet {

  private StaffDAO staffDAO;
  private ServiceDAO serviceDAO;
  private Gson gson;

  @Override
  public void init() throws ServletException {
    super.init();
    staffDAO = new StaffDAO();
    serviceDAO = new ServiceDAO();
    gson = new Gson();
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
      String serviceIds = request.getParameter("serviceIds");
      String availableOnly = request.getParameter("availableOnly");
      String customerId = request.getParameter("customerId");

      JsonObject jsonResponse = new JsonObject();

      if (serviceIds != null && !serviceIds.trim().isEmpty()) {
        // Get therapists for specific services
        List<Integer> serviceIdList = Arrays.stream(serviceIds.split(","))
            .map(String::trim)
            .map(Integer::parseInt)
            .collect(Collectors.toList());

        List<Staff> therapists = getTherapistsForServices(serviceIdList);
        jsonResponse.add("therapists", gson.toJsonTree(therapists));
        jsonResponse.addProperty("serviceIds", serviceIds);

      } else {
        // Get all available therapists
        List<Staff> allTherapists = staffDAO.findAll();

        // Filter for available only if requested
        if ("true".equals(availableOnly)) {
          // Filter by availability status
          allTherapists = allTherapists.stream()
              .filter(therapist -> therapist.getAvailabilityStatus() == Staff.AvailabilityStatus.AVAILABLE)
              .collect(Collectors.toList());
        }

        jsonResponse.add("therapists", gson.toJsonTree(allTherapists));
      }

      // Get recent therapists for customer if logged in
      if (customerId != null && !customerId.trim().isEmpty()) {
        try {
          int customerIdInt = Integer.parseInt(customerId);
          List<Staff> recentTherapists = getRecentTherapistsForCustomer(customerIdInt);
          jsonResponse.add("recentTherapists", gson.toJsonTree(recentTherapists));
        } catch (NumberFormatException e) {
          System.err.println("Invalid customer ID: " + customerId);
        }
      }

      jsonResponse.addProperty("success", true);
      jsonResponse.addProperty("message", "Therapists retrieved successfully");

      out.print(gson.toJson(jsonResponse));

    } catch (Exception e) {
      System.err.println("Error in TherapistApiServlet: " + e.getMessage());
      e.printStackTrace();

      JsonObject errorResponse = new JsonObject();
      errorResponse.addProperty("success", false);
      errorResponse.addProperty("message", "Error retrieving therapists: " + e.getMessage());
      errorResponse.add("therapists", new JsonArray());

      response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      out.print(gson.toJson(errorResponse));
    } finally {
      out.flush();
      out.close();
    }
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
   * Get therapists who can perform the specified services
   */
  private List<Staff> getTherapistsForServices(List<Integer> serviceIds) {
    // For now, return all active therapists
    // TODO: Implement service-specific therapist filtering based on specializations
    List<Staff> allTherapists = staffDAO.findAll();

    return allTherapists.stream()
        .filter(therapist -> therapist.getAvailabilityStatus() == Staff.AvailabilityStatus.AVAILABLE)
        .collect(Collectors.toList());
  }

  /**
   * Get therapists that the customer has recently booked with
   */
  private List<Staff> getRecentTherapistsForCustomer(int customerId) {
    // TODO: Implement query to get therapists from customer's recent appointments
    // For now, return empty list
    return List.of();
  }
}
