package controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.logging.Logger;
import java.util.logging.Level;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.ServiceDAO;
import dao.ServiceTypeDAO;
import dao.ServiceImageDAO;
import model.Service;
import model.ServiceType;

@WebServlet(name = "ServicesController", urlPatterns = { "/services" })
public class ServicesController extends HttpServlet {

  private static final Logger LOGGER = Logger.getLogger(ServicesController.class.getName());

  private ServiceDAO serviceDAO;
  private ServiceTypeDAO serviceTypeDAO;
  private ServiceImageDAO serviceImageDAO;

  @Override
  public void init() throws ServletException {
    super.init();
    serviceDAO = new ServiceDAO();
    serviceTypeDAO = new ServiceTypeDAO();
    serviceImageDAO = new ServiceImageDAO();
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    try {
      // Load services with their first available images using the optimized batch
      // method
      List<Service> services = serviceDAO.findAllWithImages();
      LOGGER.info("Successfully loaded " + services.size() + " services");

      // Load service types for filtering with error handling
      List<ServiceType> serviceTypes;
      try {
        serviceTypes = serviceTypeDAO.findAll();
        LOGGER.info("Successfully loaded " + serviceTypes.size() + " service types");
      } catch (Exception e) {
        LOGGER.log(Level.WARNING, "Failed to load service types, using empty list", e);
        serviceTypes = new java.util.ArrayList<>();
      }

      // Get price range for filtering with error handling
      double minPrice = 0;
      double maxPrice = 1000000; // Default reasonable max price
      try {
        minPrice = serviceDAO.findMinPrice();
        maxPrice = serviceDAO.findMaxPrice();
        LOGGER.info("Price range: " + minPrice + " - " + maxPrice);
      } catch (Exception e) {
        LOGGER.log(Level.WARNING, "Failed to load price range, using defaults", e);
      }

      // Prepare additional image data for services that have multiple images
      // (optimized batch query) with error handling
      Map<Integer, Integer> serviceImageCounts = new HashMap<>();
      try {
        List<Integer> serviceIds = services.stream()
            .map(Service::getServiceId)
            .collect(java.util.stream.Collectors.toList());
        serviceImageCounts = serviceImageDAO.getImageCountsByServiceIds(serviceIds);
        LOGGER.info("Successfully loaded image counts for " + serviceImageCounts.size() + " services");
      } catch (Exception e) {
        LOGGER.log(Level.WARNING, "Failed to load image counts, using empty map", e);
        // Initialize with default counts (0 for all services)
        for (Service service : services) {
          serviceImageCounts.put(service.getServiceId(), 0);
        }
      }

      // Set attributes for JSP
      request.setAttribute("services", services);
      request.setAttribute("serviceTypes", serviceTypes);
      request.setAttribute("priceRange", Map.of("min", minPrice, "max", maxPrice));
      request.setAttribute("serviceImageCounts", serviceImageCounts);

      // Forward to JSP
      request.getRequestDispatcher("/WEB-INF/view/services.jsp").forward(request, response);

    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Critical error in ServicesController", e);

      // Set minimal attributes to prevent JSP errors
      request.setAttribute("services", new java.util.ArrayList<>());
      request.setAttribute("serviceTypes", new java.util.ArrayList<>());
      request.setAttribute("priceRange", Map.of("min", 0.0, "max", 1000000.0));
      request.setAttribute("serviceImageCounts", new HashMap<>());
      request.setAttribute("errorMessage", "Đã xảy ra lỗi khi tải dịch vụ. Vui lòng thử lại sau.");

      // Still forward to JSP to show error message gracefully
      request.getRequestDispatcher("/WEB-INF/view/services.jsp").forward(request, response);
    }
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    doGet(request, response);
  }
}