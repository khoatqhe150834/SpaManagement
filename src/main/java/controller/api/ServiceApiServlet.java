package controller.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dao.ServiceDAO;
import dao.ServiceTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Service;
import model.ServiceType;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * API Servlet for fetching, searching, and filtering services and service
 * types.
 * This servlet follows RESTful principles, using query parameters for
 * filtering.
 * It returns data in JSON format.
 *
 * @author G1_SpaManagement
 */
@WebServlet(name = "ServiceApiServlet", urlPatterns = { "/api/services", "/api/service-types" })
public class ServiceApiServlet extends HttpServlet {

  private final ServiceDAO serviceDAO = new ServiceDAO();
  private final ServiceTypeDAO serviceTypeDAO = new ServiceTypeDAO();
  private final Gson gson = new GsonBuilder().serializeNulls().create();

  /**
   * Handles GET requests to provide service and service type data.
   * It routes requests based on the servlet path.
   * - /api/services: For filtering and searching services.
   * - /api/service-types: For fetching all service types.
   *
   * @param request  the servlet request
   * @param response the servlet response
   * @throws ServletException if a servlet-specific error occurs
   * @throws IOException      if an I/O error occurs
   */
  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    String servletPath = request.getServletPath();

    try (PrintWriter out = response.getWriter()) {
      switch (servletPath) {
        case "/api/services":
          handleFilterServices(request, response, out);
          break;
        case "/api/service-types":
          handleGetServiceTypes(request, response, out);
          break;
        default:
          response.setStatus(HttpServletResponse.SC_NOT_FOUND);
          Map<String, String> error = new HashMap<>();
          error.put("error", "Endpoint not found");
          out.print(gson.toJson(error));
          break;
      }
    } catch (Exception e) {
      // Log the exception for debugging purposes
      e.printStackTrace();
      response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      PrintWriter out = response.getWriter();
      Map<String, String> error = new HashMap<>();
      error.put("error", "An internal server error occurred: " + e.getMessage());
      out.print(gson.toJson(error));
      out.flush();
    }
  }

  /**
   * Handles filtering and searching services based on query parameters.
   *
   * @param request  the servlet request
   * @param response the servlet response
   * @param out      the PrintWriter to write the response
   * @throws IOException if an I/O error occurs
   */
  private void handleFilterServices(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
      throws IOException {
    // Extract filter parameters from the request
    String category = request.getParameter("category");
    String searchQuery = request.getParameter("search");
    String minPriceStr = request.getParameter("minPrice");
    String maxPriceStr = request.getParameter("maxPrice");
    // String orderBy = request.getParameter("orderBy");
    // String orderDirection = request.getParameter("orderDirection");

    Integer minPrice = null;
    if (minPriceStr != null) {
      try {
        minPrice = Integer.parseInt(minPriceStr);
      } catch (NumberFormatException e) {
        // Ignore invalid format
      }
    }

    Integer maxPrice = null;
    if (maxPriceStr != null) {
      try {
        maxPrice = Integer.parseInt(maxPriceStr);
      } catch (NumberFormatException e) {
        // Ignore invalid format
      }
    }

    // Fetch filtered services from the DAO
    // Note: You will need to create this getFilteredServices method in your
    // ServiceDAO
    List<Service> services = serviceDAO.getFilteredServices(category, searchQuery, minPrice, maxPrice);

    // Send the response
    Map<String, Object> responseData = new HashMap<>();
    responseData.put("services", services);
    out.print(gson.toJson(responseData));
  }

  /**
   * Handles fetching all service types.
   *
   * @param request  the servlet request
   * @param response the servlet response
   * @param out      the PrintWriter to write the response
   * @throws IOException if an I/O error occurs
   */
  private void handleGetServiceTypes(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
      throws IOException {
    // Note: You will need a findAll() method in your ServiceTypeDAO
    List<ServiceType> serviceTypes = serviceTypeDAO.findAll();
    out.print(gson.toJson(serviceTypes));
  }

  /**
   * Returns a short description of the servlet.
   *
   * @return a String containing servlet description
   */
  @Override
  public String getServletInfo() {
    return "API Servlet for fetching, filtering, and searching services and their types.";
  }
}