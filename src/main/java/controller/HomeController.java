package controller;

import java.io.IOException;
import java.util.List;

import dao.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Service;

/**
 * Home Controller to handle the root path
 * Maps to "/" and "/index" to serve the main page
 */
public class HomeController extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    System.out.println("[HomeController] Reached the HomeController. Loading services with images.");

    try {
      // Load services with images for homepage sections
      ServiceDAO serviceDAO = new ServiceDAO();

      // Load featured services (limit to 8 for homepage)
      List<Service> featuredServices = serviceDAO.getPromotionalServicesWithImages(8);
      List<Service> mostPurchasedServices = serviceDAO.getMostPurchasedServicesWithImages(8);

      // Set attributes for JSP
      request.setAttribute("featuredServices", featuredServices);
      request.setAttribute("mostPurchasedServices", mostPurchasedServices);

      System.out.println("[HomeController] Loaded " + featuredServices.size() + " featured services and " +
                        mostPurchasedServices.size() + " most purchased services");

    } catch (Exception e) {
      System.err.println("[HomeController] Error loading services: " + e.getMessage());
      e.printStackTrace();
      // Continue without services data - JavaScript will handle loading
    }

    // Additional diagnostic attributes
    request.setAttribute("controller_reached", "HomeController");
    request.setAttribute("timestamp", System.currentTimeMillis());

    request.getRequestDispatcher("/index.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    doGet(request, response);
  }
}