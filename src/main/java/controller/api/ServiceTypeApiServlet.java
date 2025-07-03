package controller.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dao.ServiceTypeDAO;
import model.ServiceType;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ServiceTypeApiServlet", urlPatterns = { "/api/service-types" })
public class ServiceTypeApiServlet extends HttpServlet {

  private static final Logger LOGGER = Logger.getLogger(ServiceTypeApiServlet.class.getName());
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
      LOGGER.info("Service Types API request received");

      // Get all service types
      List<ServiceType> serviceTypes = serviceTypeDAO.findAll();

      // Build response
      Map<String, Object> responseData = new HashMap<>();
      responseData.put("serviceTypes", serviceTypes);
      responseData.put("success", true);
      responseData.put("count", serviceTypes.size());

      String jsonResponse = gson.toJson(responseData);
      response.getWriter().write(jsonResponse);

      LOGGER.info(String.format("Returned %d service types", serviceTypes.size()));

    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error processing service types API request", e);

      Map<String, Object> errorResponse = new HashMap<>();
      errorResponse.put("success", false);
      errorResponse.put("error", "Internal server error: " + e.getMessage());

      response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      response.getWriter().write(gson.toJson(errorResponse));
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