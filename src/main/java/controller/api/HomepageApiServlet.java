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
import model.Service;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

/**
 * API Servlet for homepage sections data
 * Provides endpoints for recently viewed, promotional, and most purchased
 * services
 */
@WebServlet(name = "HomepageApiServlet", urlPatterns = { "/api/homepage" })
public class HomepageApiServlet extends HttpServlet {

  private ServiceDAO serviceDAO;
  private Gson gson;
  private NumberFormat currencyFormatter;

  @Override
  public void init() throws ServletException {
    super.init();
    serviceDAO = new ServiceDAO();
    gson = new Gson();
    currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    currencyFormatter.setMinimumFractionDigits(0);
    currencyFormatter.setMaximumFractionDigits(0);
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
        sendErrorResponse(out, "Action parameter is required", HttpServletResponse.SC_BAD_REQUEST);
        return;
      }

      switch (action) {
        case "recently-viewed":
          handleRecentlyViewed(request, response, out);
          break;
        case "promotional":
          handlePromotional(request, response, out);
          break;
        case "most-purchased":
          handleMostPurchased(request, response, out);
          break;
        case "all-sections":
          handleAllSections(request, response, out);
          break;
        default:
          sendErrorResponse(out, "Invalid action parameter", HttpServletResponse.SC_BAD_REQUEST);
      }

    } catch (Exception e) {
      System.err.println("Error in HomepageApiServlet: " + e.getMessage());
      e.printStackTrace();
      sendErrorResponse(out, "Internal server error: " + e.getMessage(),
          HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    } finally {
      out.flush();
      out.close();
    }
  }

  /**
   * Handle recently viewed services request
   */
  private void handleRecentlyViewed(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
      throws IOException {

    String serviceIdsParam = request.getParameter("serviceIds");

    if (serviceIdsParam == null || serviceIdsParam.trim().isEmpty()) {
      JsonObject jsonResponse = new JsonObject();
      jsonResponse.addProperty("success", true);
      jsonResponse.add("services", new JsonArray());
      jsonResponse.addProperty("count", 0);
      out.print(gson.toJson(jsonResponse));
      return;
    }

    try {
      List<Integer> serviceIds = Arrays.stream(serviceIdsParam.split(","))
          .map(String::trim)
          .filter(s -> !s.isEmpty())
          .map(Integer::parseInt)
          .collect(Collectors.toList());

      List<Service> services = serviceDAO.getServicesByIds(serviceIds);
      JsonArray servicesArray = convertServicesToJson(services);

      JsonObject jsonResponse = new JsonObject();
      jsonResponse.addProperty("success", true);
      jsonResponse.add("services", servicesArray);
      jsonResponse.addProperty("count", services.size());

      out.print(gson.toJson(jsonResponse));

    } catch (NumberFormatException e) {
      sendErrorResponse(out, "Invalid service ID format", HttpServletResponse.SC_BAD_REQUEST);
    } catch (Exception e) {
      sendErrorResponse(out, "Error retrieving recently viewed services: " + e.getMessage(),
          HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
  }

  /**
   * Handle promotional services request
   */
  private void handlePromotional(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
      throws IOException {

    try {
      String limitParam = request.getParameter("limit");
      int limit = limitParam != null ? Integer.parseInt(limitParam) : 8;

      List<Service> services = serviceDAO.getPromotionalServices(limit);
      JsonArray servicesArray = convertServicesToJson(services);

      JsonObject jsonResponse = new JsonObject();
      jsonResponse.addProperty("success", true);
      jsonResponse.add("services", servicesArray);
      jsonResponse.addProperty("count", services.size());

      out.print(gson.toJson(jsonResponse));

    } catch (NumberFormatException e) {
      sendErrorResponse(out, "Invalid limit parameter", HttpServletResponse.SC_BAD_REQUEST);
    } catch (Exception e) {
      sendErrorResponse(out, "Error retrieving promotional services: " + e.getMessage(),
          HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
  }

  /**
   * Handle most purchased services request
   */
  private void handleMostPurchased(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
      throws IOException {

    try {
      String limitParam = request.getParameter("limit");
      int limit = limitParam != null ? Integer.parseInt(limitParam) : 8;

      List<Service> services = serviceDAO.getMostPurchasedServices(limit);
      JsonArray servicesArray = convertServicesToJson(services);

      JsonObject jsonResponse = new JsonObject();
      jsonResponse.addProperty("success", true);
      jsonResponse.add("services", servicesArray);
      jsonResponse.addProperty("count", services.size());

      out.print(gson.toJson(jsonResponse));

    } catch (NumberFormatException e) {
      sendErrorResponse(out, "Invalid limit parameter", HttpServletResponse.SC_BAD_REQUEST);
    } catch (Exception e) {
      sendErrorResponse(out, "Error retrieving most purchased services: " + e.getMessage(),
          HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
  }

  /**
   * Handle request for all sections data at once
   */
  private void handleAllSections(HttpServletRequest request, HttpServletResponse response, PrintWriter out)
      throws IOException {

    try {
      String limitParam = request.getParameter("limit");
      int limit = limitParam != null ? Integer.parseInt(limitParam) : 8;

      String serviceIdsParam = request.getParameter("recentlyViewedIds");

      // Get promotional services
      List<Service> promotionalServices = serviceDAO.getPromotionalServices(limit);

      // Get most purchased services
      List<Service> mostPurchasedServices = serviceDAO.getMostPurchasedServices(limit);

      // Get recently viewed services
      List<Service> recentlyViewedServices = new ArrayList<>();
      if (serviceIdsParam != null && !serviceIdsParam.trim().isEmpty()) {
        List<Integer> serviceIds = Arrays.stream(serviceIdsParam.split(","))
            .map(String::trim)
            .filter(s -> !s.isEmpty())
            .map(Integer::parseInt)
            .collect(Collectors.toList());
        recentlyViewedServices = serviceDAO.getServicesByIds(serviceIds);
      }

      JsonObject jsonResponse = new JsonObject();
      jsonResponse.addProperty("success", true);

      JsonObject sectionsData = new JsonObject();
      sectionsData.add("promotional", convertServicesToJson(promotionalServices));
      sectionsData.add("mostPurchased", convertServicesToJson(mostPurchasedServices));
      sectionsData.add("recentlyViewed", convertServicesToJson(recentlyViewedServices));

      jsonResponse.add("sections", sectionsData);

      JsonObject counts = new JsonObject();
      counts.addProperty("promotional", promotionalServices.size());
      counts.addProperty("mostPurchased", mostPurchasedServices.size());
      counts.addProperty("recentlyViewed", recentlyViewedServices.size());

      jsonResponse.add("counts", counts);

      out.print(gson.toJson(jsonResponse));

    } catch (NumberFormatException e) {
      sendErrorResponse(out, "Invalid parameter format", HttpServletResponse.SC_BAD_REQUEST);
    } catch (Exception e) {
      sendErrorResponse(out, "Error retrieving homepage sections: " + e.getMessage(),
          HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
  }

  /**
   * Convert list of services to JSON array with formatted data
   */
  private JsonArray convertServicesToJson(List<Service> services) {
    JsonArray servicesArray = new JsonArray();

    for (Service service : services) {
      JsonObject serviceJson = new JsonObject();
      serviceJson.addProperty("serviceId", service.getServiceId());
      serviceJson.addProperty("name", service.getName());
      serviceJson.addProperty("description", service.getDescription());
      serviceJson.addProperty("price", service.getPrice().doubleValue());
      serviceJson.addProperty("formattedPrice", formatPrice(service.getPrice()));
      serviceJson.addProperty("durationMinutes", service.getDurationMinutes());
      serviceJson.addProperty("imageUrl", service.getImageUrl());
      serviceJson.addProperty("averageRating",
          service.getAverageRating() != null ? service.getAverageRating().doubleValue() : 0.0);
      serviceJson.addProperty("purchaseCount", service.getPurchaseCount());

      // Service type information
      if (service.getServiceTypeId() != null) {
        JsonObject serviceType = new JsonObject();
        serviceType.addProperty("serviceTypeId", service.getServiceTypeId().getServiceTypeId());
        serviceType.addProperty("name", service.getServiceTypeId().getName());
        serviceJson.add("serviceType", serviceType);
      }

      servicesArray.add(serviceJson);
    }

    return servicesArray;
  }

  /**
   * Format price to Vietnamese currency format
   */
  private String formatPrice(BigDecimal price) {
    if (price == null)
      return "0đ";

    // Simple format for Vietnamese currency
    NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
    return formatter.format(price.longValue()) + "đ";
  }

  /**
   * Send error response in JSON format
   */
  private void sendErrorResponse(PrintWriter out, String message, int statusCode) {
    JsonObject errorResponse = new JsonObject();
    errorResponse.addProperty("success", false);
    errorResponse.addProperty("error", message);
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
}