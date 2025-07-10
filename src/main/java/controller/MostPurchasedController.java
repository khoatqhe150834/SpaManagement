package controller;

import java.io.IOException;
import java.util.List;

import dao.ServiceDAO;
import dao.ServiceTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Service;
import model.ServiceType;

@WebServlet(name = "MostPurchasedController", urlPatterns = { "/most-purchased" })
public class MostPurchasedController extends HttpServlet {

  private final ServiceDAO serviceDAO = new ServiceDAO();
  private final ServiceTypeDAO serviceTypeDAO = new ServiceTypeDAO();

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    try {
      // Load all service types for filtering
      List<ServiceType> serviceTypes = serviceTypeDAO.findAll();
      request.setAttribute("serviceTypes", serviceTypes);

      // Get price range for the slider
      double minPrice = serviceDAO.findMinPrice();
      double maxPrice = serviceDAO.findMaxPrice();
      request.setAttribute("minPrice", minPrice);
      request.setAttribute("maxPrice", maxPrice);

    } catch (Exception e) {
      e.printStackTrace();
      request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải dữ liệu. Vui lòng thử lại sau.");
    }

    // Forward to the most purchased services page
    request.getRequestDispatcher("/WEB-INF/view/most-purchased.jsp").forward(request, response);
  }
}