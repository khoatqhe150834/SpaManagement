package controller.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dao.ServiceDAO;
import dao.ServiceTypeDAO;
import model.Service;
import model.ServiceType;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ServiceApiServlet", urlPatterns = { "/api/services" })
public class ServiceApiServlet extends HttpServlet {

  private static final Logger LOGGER = Logger.getLogger(ServiceApiServlet.class.getName());
  private final ServiceDAO serviceDAO = new ServiceDAO();
  private final ServiceTypeDAO serviceTypeDAO = new ServiceTypeDAO();
  private final Gson gson = new GsonBuilder()
      .setDateFormat("yyyy-MM-dd HH:mm:ss")
      .create();

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.setHeader("Cache-Control", "no-cache");

    try {
      // Check if this is a price range request
      String action = request.getParameter("action");
      if ("price-range".equals(action)) {
        handlePriceRangeRequest(response);
        return;
      }

      // Parse request parameters
      String searchQuery = request.getParameter("name");
      String categoryParam = request.getParameter("category");
      String minPriceParam = request.getParameter("minPrice");
      String maxPriceParam = request.getParameter("maxPrice");
      String pageParam = request.getParameter("page");
      String sizeParam = request.getParameter("size");
      String order = request.getParameter("order");

      // Set defaults
      int page = parseIntParameter(pageParam, 1);
      int size = parseIntParameter(sizeParam, 12);
      Integer minPrice = parseIntegerParameter(minPriceParam);
      Integer maxPrice = parseIntegerParameter(maxPriceParam);

      // Handle category parameter - if "all" or empty, pass null
      String category = null;
      if (categoryParam != null && !categoryParam.trim().isEmpty() && !"all".equalsIgnoreCase(categoryParam.trim())) {
        // Check if it's a service type ID
        try {
          int serviceTypeId = Integer.parseInt(categoryParam);
          ServiceType serviceType = serviceTypeDAO.findById(serviceTypeId).orElse(null);
          if (serviceType != null) {
            category = serviceType.getName();
          }
        } catch (NumberFormatException e) {
          // If not a number, treat as category name
          category = categoryParam.trim();
        }
      }

      LOGGER.info(String.format(
          "Service API request - searchQuery: %s, category: %s, minPrice: %s, maxPrice: %s, page: %d, size: %d, order: %s",
          searchQuery, category, minPrice, maxPrice, page, size, order));

      // Get services using the DAO method
      List<Service> services = serviceDAO.getServicesByCriteria(category, searchQuery, minPrice, maxPrice, page, size,
          order);

      // Calculate total count for pagination (you might need to add this method to
      // your DAO)
      int totalCount = getTotalCount(category, searchQuery, minPrice, maxPrice);
      int totalPages = (int) Math.ceil((double) totalCount / size);

      // Build response
      Map<String, Object> responseData = new HashMap<>();
      responseData.put("services", services);
      responseData.put("pagination", Map.of(
          "currentPage", page,
          "pageSize", size,
          "totalCount", totalCount,
          "totalPages", totalPages,
          "hasNext", page < totalPages,
          "hasPrevious", page > 1));
      responseData.put("success", true);

      String jsonResponse = gson.toJson(responseData);
      response.getWriter().write(jsonResponse);

    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error processing service API request", e);

      Map<String, Object> errorResponse = new HashMap<>();
      errorResponse.put("success", false);
      errorResponse.put("error", "Internal server error: " + e.getMessage());

      response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      response.getWriter().write(gson.toJson(errorResponse));
    }
  }

  private int parseIntParameter(String param, int defaultValue) {
    if (param == null || param.trim().isEmpty()) {
      return defaultValue;
    }
    try {
      return Integer.parseInt(param.trim());
    } catch (NumberFormatException e) {
      return defaultValue;
    }
  }

  private Integer parseIntegerParameter(String param) {
    if (param == null || param.trim().isEmpty()) {
      return null;
    }
    try {
      return Integer.parseInt(param.trim());
    } catch (NumberFormatException e) {
      return null;
    }
  }

  /**
   * Handle price range request to get min and max prices from database
   */
  private void handlePriceRangeRequest(HttpServletResponse response) throws IOException {
    try {
      List<Service> allServices = serviceDAO.getServicesByCriteria(null, null, null, null, 1, Integer.MAX_VALUE, null);

      BigDecimal minPrice = BigDecimal.valueOf(0);
      BigDecimal maxPrice = BigDecimal.valueOf(0);

      if (!allServices.isEmpty()) {
        minPrice = allServices.stream()
            .map(Service::getPrice)
            .min(BigDecimal::compareTo)
            .orElse(BigDecimal.valueOf(0));

        maxPrice = allServices.stream()
            .map(Service::getPrice)
            .max(BigDecimal::compareTo)
            .orElse(BigDecimal.valueOf(1000000));
      }

      Map<String, Object> priceRange = new HashMap<>();
      priceRange.put("success", true);
      priceRange.put("minPrice", minPrice.intValue());
      priceRange.put("maxPrice", maxPrice.intValue());

      response.getWriter().write(gson.toJson(priceRange));

    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error getting price range", e);

      Map<String, Object> errorResponse = new HashMap<>();
      errorResponse.put("success", false);
      errorResponse.put("error", "Error getting price range: " + e.getMessage());

      response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      response.getWriter().write(gson.toJson(errorResponse));
    }
  }

  /**
   * Get total count of services matching the criteria
   * You might need to add this method to your ServiceDAO
   */
  private int getTotalCount(String category, String searchQuery, Integer minPrice, Integer maxPrice) {
    try {
      // For now, get all matching services and count them
      // In production, you should add a dedicated count method to your DAO
      List<Service> allServices = serviceDAO.getServicesByCriteria(category, searchQuery, minPrice, maxPrice, 1,
          Integer.MAX_VALUE, null);
      return allServices.size();
    } catch (Exception e) {
      LOGGER.log(Level.WARNING, "Error getting total count", e);
      return 0;
    }
  }

  @Override
  protected void doOptions(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type");
    response.setStatus(HttpServletResponse.SC_OK);
  }
}