package controller;

import java.util.List;

import model.Service;
import model.ServiceType;
import dao.ServiceDAO;
import dao.ServiceTypeDAO;
import dao.StaffDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "BookingController", urlPatterns = { "/process-booking/*" })
public class BookingController extends HttpServlet {

  private ServiceDAO serviceDAO;
  private StaffDAO staffDAO;
  private ServiceTypeDAO serviceTypeDAO;

  // init methods here
  @Override
  public void init() throws ServletException {
    super.init();
    serviceDAO = new ServiceDAO();
    staffDAO = new StaffDAO();
    serviceTypeDAO = new ServiceTypeDAO();

  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String pathInfo = request.getPathInfo();
    if (pathInfo == null) {
      request.getRequestDispatcher("/WEB-INF/view/customer/appointments/booking-selection.jsp").forward(request,
          response);
      return;
    }

    // Handle different booking paths
    switch (pathInfo) {
      case "/therapist-selection":
        handleTherapistSelection(request, response);
        break;
      case "/time-selection":
        handleTimeSelection(request, response);
        break;
      default:
        request.getRequestDispatcher("/WEB-INF/view/customer/appointments/booking-selection.jsp").forward(request,
            response);
        break;
    }
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String bookingType = request.getParameter("bookingType");

    if (bookingType == null) {
      request.getRequestDispatcher("test.jsp").forward(request,
          response);
      return;
    }

    switch (bookingType) {

      case "individual":
        processBookingIndividual(request, response);
        break;
      case "group":
        processBookingGroup(request, response);
        break;
      case "giftcard":
        processBookingGiftcard(request, response);
        break;
      default:
        request.getRequestDispatcher("/WEB-INF/view/customer/appointments/booking-selection.jsp").forward(request,
            response);
        break;
    }
  }

  private void processBookingIndividual(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // load necessary data here

    // load all services types
    List<ServiceType> serviceTypes = serviceTypeDAO.findAll();
    request.setAttribute("serviceTypes", serviceTypes);
    // load min and max price
    double minPrice = serviceDAO.findMinPrice();
    double maxPrice = serviceDAO.findMaxPrice();
    request.setAttribute("minPrice", minPrice);
    request.setAttribute("maxPrice", maxPrice);

    // load all services
    List<Service> services = serviceDAO.findAll();
    request.setAttribute("services", services);
    request.getRequestDispatcher("/WEB-INF/view/customer/appointments/services-selection.jsp").forward(
        request,
        response);
  }

  private void processBookingGroup(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    String serviceId = request.getParameter("serviceId");
    String therapistId = request.getParameter("therapistId");
    String date = request.getParameter("date");
    String time = request.getParameter("time");
    String notes = request.getParameter("notes");
    request.getRequestDispatcher("/WEB-INF/view/customer/appointments/services-selection.jsp").forward(request,
        response);
  }

  private void processBookingGiftcard(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    String serviceId = request.getParameter("serviceId");
    String therapistId = request.getParameter("therapistId");
    String date = request.getParameter("date");
    String time = request.getParameter("time");
    String notes = request.getParameter("notes");
    request.getRequestDispatcher("/WEB-INF/view/customer/appointments/booking-giftcard.jsp").forward(request, response);
  }

  private void handleTherapistSelection(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // TODO: Load selected services from session or parameter
    // TODO: Load available therapists based on selected services
    // TODO: Load recent therapists for the customer (if logged in)

    // For now, just forward to the therapist selection page
    request.getRequestDispatcher("/WEB-INF/view/customer/appointments/therapist-selection.jsp").forward(request,
        response);
  }

  private void handleTimeSelection(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // TODO: Load selected services from session or parameter
    // TODO: Load available therapists/staff
    // TODO: Load available time slots for selected date

    // For now, just forward to the time selection page
    request.getRequestDispatcher("/WEB-INF/view/customer/appointments/time-selection.jsp").forward(request, response);
  }

}