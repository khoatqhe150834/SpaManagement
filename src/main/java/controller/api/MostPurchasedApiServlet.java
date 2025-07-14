package controller.api;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import dao.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Service;

@WebServlet(name = "MostPurchasedApiServlet", urlPatterns = { "/api/most-purchased" })
public class MostPurchasedApiServlet extends HttpServlet {

  private static final Logger LOGGER = Logger.getLogger(MostPurchasedApiServlet.class.getName());
  private final ServiceDAO serviceDAO = new ServiceDAO();
  private final Gson gson = new GsonBuilder()
      .setDateFormat("yyyy-MM-dd HH:mm:ss")
      .create();

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type");

    try {
      // Parse limit parameter
      String limitParam = request.getParameter("limit");
      int limit = parseIntParameter(limitParam, 100); // Default to 100

      LOGGER.info(String.format("Most purchased services API request - limit: %d", limit));

      // Get most purchased services with images using the dedicated DAO method
      List<Service> services = serviceDAO.getMostPurchasedServicesWithImages(limit);

      // Build response
      Map<String, Object> responseData = new HashMap<>();
      responseData.put("services", services);
      responseData.put("count", services.size());
      responseData.put("success", true);

      String jsonResponse = gson.toJson(responseData);
      response.getWriter().write(jsonResponse);

      LOGGER.info(String.format("Successfully returned %d most purchased services", services.size()));

    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error processing most purchased services API request", e);

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

  @Override
  protected void doOptions(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type");
    response.setStatus(HttpServletResponse.SC_OK);
  }
}