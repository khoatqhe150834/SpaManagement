package controller;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.math.BigDecimal;

import model.Service;
import model.ServiceType;
import model.Staff;
import model.BookingAppointment;
import model.BookingGroup;
import model.Customer;
import dao.ServiceDAO;
import dao.ServiceTypeDAO;
import dao.StaffDAO;
import dao.BookingAppointmentDAO;
import dao.CustomerDAO;
import dao.BookingAppointmentDAO;
import service.email.EmailService;
import util.QRCodeGenerator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import com.google.gson.Gson;
import java.util.logging.Logger;
import java.util.logging.Level;
import model.BookingSession;
import service.BookingSessionService;

@WebServlet(name = "BookingController", urlPatterns = { "/process-booking/*", "/booking/*" })
public class BookingController extends HttpServlet {

  private static final Logger LOGGER = Logger.getLogger(BookingController.class.getName());

  private ServiceDAO serviceDAO;
  private StaffDAO staffDAO;
  private ServiceTypeDAO serviceTypeDAO;
  private BookingAppointmentDAO bookingAppointmentDAO;
  private CustomerDAO customerDAO;
  private BookingAppointmentDAO bookingAppointmentDAO;
  private EmailService emailService;
  private QRCodeGenerator qrCodeGenerator;
  private BookingSessionService bookingSessionService;
  private Gson gson;

  // Booking session keys
  private static final String BOOKING_DATA_KEY = "bookingData";
  private static final String BOOKING_STEP_KEY = "bookingStep";

  // Booking steps
  public enum BookingStep {
    SERVICE_SELECTION,
    TIME_SELECTION,
    THERAPIST_SELECTION,
    PAYMENT,
    CONFIRMATION
  }

  // init methods here
  @Override
  public void init() throws ServletException {
    super.init();
    serviceDAO = new ServiceDAO();
    staffDAO = new StaffDAO();
    serviceTypeDAO = new ServiceTypeDAO();
    bookingAppointmentDAO = new BookingAppointmentDAO();
    customerDAO = new CustomerDAO();
    bookingAppointmentDAO = new BookingAppointmentDAO();
    emailService = new EmailService();
    qrCodeGenerator = new QRCodeGenerator();
    bookingSessionService = new BookingSessionService();
    gson = new Gson();
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String pathInfo = request.getPathInfo();
    
    // Handle appointment list and details via pathInfo
    if (pathInfo != null) {
      if (pathInfo.equals("/list")) {
        handleBookingList(request, response);
        return;
      } else if (pathInfo.startsWith("/details/")) {
        // Extract appointment ID from path: /details/{id}
        String[] pathParts = pathInfo.split("/");
        if (pathParts.length >= 3) {
          try {
            int appointmentId = Integer.parseInt(pathParts[2]);
            request.setAttribute("appointmentId", appointmentId);
            handleBookingDetails(request, response);
            return;
          } catch (NumberFormatException e) {
            // Invalid appointment ID, continue to default flow
          }
        }
      }
    }
    
    if (pathInfo == null) {
      // Default to individual booking flow
      processBookingIndividual(request, response);
      return;
    }

    // Handle different booking paths
    switch (pathInfo) {
      case "/services":
      case "/service-selection":
        handleServiceSelection(request, response);
        break;
      case "/therapists":
      case "/therapist-selection":
        handleTherapistSelection(request, response);
        break;
      case "/time":
      case "/time-selection":
        handleTimeSelection(request, response);
        break;
      case "/payment":
        handlePayment(request, response);
        break;
      case "/confirmation":
        handleConfirmation(request, response);
        break;
      case "/resume":
        handleResumeSession(request, response);
        break;
      case "/booking-summary":
        handleBookingSummary(request, response);
        break;
      case "/cancel":
        handleCancelBooking(request, response);
        break;
      case "/reschedule":
        handleRescheduleBooking(request, response);
        break;
      case "/status":
        handleBookingStatus(request, response);
        break;
      default:
        // Default to individual booking flow
        processBookingIndividual(request, response);
        break;
    }
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String bookingType = request.getParameter("bookingType");
    String pathInfo = request.getPathInfo();

    // Handle POST requests for different booking steps
    if (pathInfo != null) {
      switch (pathInfo) {
        case "/services":
        case "/save-services":
          saveSelectedServices(request, response);
          break;
        case "/therapists":
        case "/save-therapist":
          saveSelectedTherapist(request, response);
          break;
        case "/time":
        case "/save-time":
          saveSelectedTime(request, response);
          break;
        case "/payment":
        case "/process-payment":
          processPayment(request, response);
          break;
        case "/complete":
        case "/confirm-booking":
          confirmBooking(request, response);
          break;
        case "/update-status":
          updateBookingStatus(request, response);
          break;
        default:
          // Handle legacy booking type selection
          handleBookingTypeSelection(request, response, bookingType);
          break;
      }
      return;
    }

    // Handle legacy booking type selection
    handleBookingTypeSelection(request, response, bookingType);
  }

  private void handleBookingTypeSelection(HttpServletRequest request, HttpServletResponse response, String bookingType)
      throws ServletException, IOException {

    if (bookingType == null) {
      request.getRequestDispatcher("test.jsp").forward(request, response);
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

    // Initialize booking session
    HttpSession session = request.getSession();
    Map<String, Object> bookingData = new HashMap<>();
    bookingData.put("bookingType", "individual");
    bookingData.put("step", BookingStep.SERVICE_SELECTION.name());
    bookingData.put("startTime", LocalDateTime.now().toString());
    session.setAttribute(BOOKING_DATA_KEY, bookingData);
    session.setAttribute(BOOKING_STEP_KEY, BookingStep.SERVICE_SELECTION);

    // load necessary data here
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
        request, response);
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

  // Handle service selection - create booking session if needed
  private void handleServiceSelection(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // Use BookingSessionService to get or create database-persisted session
    BookingSession bookingSession = bookingSessionService.getOrCreateSession(request);

    if (bookingSession == null) {
      LOGGER.log(Level.SEVERE, "Failed to create booking session");
      response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to initialize booking session");
      return;
    }

    // Set persistent cookie if marked by service
    setPersistentCookieIfNeeded(request, response);

    // Load selected services from session if available
    if (bookingSession.hasServices()) {
      request.setAttribute("selectedServices", bookingSession.getData().getSelectedServices());
      LOGGER.log(Level.INFO,
          "Loaded " + bookingSession.getData().getSelectedServices().size() + " services from database session");
    }

    // Get price range for filtering
    try {
      double minPrice = serviceDAO.findMinPrice();
      double maxPrice = serviceDAO.findMaxPrice();
      request.setAttribute("minPrice", minPrice);
      request.setAttribute("maxPrice", maxPrice);
    } catch (Exception e) {
      LOGGER.log(Level.WARNING, "Could not fetch price range", e);
      request.setAttribute("minPrice", 0.0);
      request.setAttribute("maxPrice", 10000000.0);
    }

    request.setAttribute("bookingSession", bookingSession);
    request.setAttribute("currentStep", "services");
    request.getRequestDispatcher("/WEB-INF/view/customer/appointments/services-selection.jsp").forward(request,
        response);
  }

  // Handle therapist selection - load selected services from session
  private void handleTherapistSelection(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // Get booking session from database
    BookingSession bookingSession = bookingSessionService.getSessionFromRequest(request);

    if (bookingSession == null || !bookingSession.hasServices() || !bookingSession.hasTimeSlots()) {
      // No booking session, no services selected, or no time slots, redirect
      // appropriately
      if (bookingSession == null || !bookingSession.hasServices()) {
        response.sendRedirect(request.getContextPath() + "/process-booking/services");
      } else {
        response.sendRedirect(request.getContextPath() + "/process-booking/time");
      }
      return;
    }

    // Validate step progression
    if (!bookingSessionService.canProceedToStep(bookingSession, BookingSession.CurrentStep.THERAPISTS)) {
      response.sendRedirect(request.getContextPath() + "/process-booking/services");
      return;
    }

    // Pass selected services to JSP
    request.setAttribute("selectedServices", bookingSession.getData().getSelectedServices());
    request.setAttribute("bookingSession", bookingSession);
    request.setAttribute("currentStep", "therapists");
    request.getRequestDispatcher("/WEB-INF/view/customer/appointments/therapist-selection.jsp").forward(request,
        response);
  }

  // Handle time selection
  private void handleTimeSelection(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // Get booking session from database
    BookingSession bookingSession = bookingSessionService.getSessionFromRequest(request);

    if (bookingSession == null || !bookingSession.hasServices()) {
      // No booking session or no services selected, redirect to service selection
      response.sendRedirect(request.getContextPath() + "/process-booking/services");
      return;
    }

    // Validate step progression
    if (!bookingSessionService.canProceedToStep(bookingSession, BookingSession.CurrentStep.TIME)) {
      response.sendRedirect(request.getContextPath() + "/process-booking/services");
      return;
    }

    // Pass booking data to JSP
    request.setAttribute("selectedServices", bookingSession.getData().getSelectedServices());
    request.setAttribute("bookingSession", bookingSession);
    request.setAttribute("currentStep", "time");
    request.getRequestDispatcher("/WEB-INF/view/customer/appointments/time-selection.jsp").forward(request, response);
  }

  // Handle payment
  private void handlePayment(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    HttpSession session = request.getSession(false);

    if (session == null) {
      response.sendRedirect(request.getContextPath() + "/process-booking/services");
      return;
    }

    BookingSession bookingSession = (BookingSession) session.getAttribute("bookingSession");
    if (bookingSession == null || !bookingSession.isReadyForPayment()) {
      // Incomplete booking session, redirect to appropriate step
      if (bookingSession == null || !bookingSession.hasServices()) {
        response.sendRedirect(request.getContextPath() + "/process-booking/services");
      } else if (!bookingSession.hasTherapistAssignments()) {
        response.sendRedirect(request.getContextPath() + "/process-booking/therapist-selection");
      } else if (!bookingSession.hasTimeSlots()) {
        response.sendRedirect(request.getContextPath() + "/process-booking/time-selection");
      }
      return;
    }

    // Pass complete booking data to JSP
    request.setAttribute("bookingSession", bookingSession);
    request.getRequestDispatcher("/WEB-INF/view/customer/appointments/payment.jsp").forward(request, response);
  }

  // Handle confirmation
  private void handleConfirmation(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    HttpSession session = request.getSession(false);

    if (session == null) {
      response.sendRedirect(request.getContextPath() + "/process-booking/services");
      return;
    }

    BookingSession bookingSession = (BookingSession) session.getAttribute("bookingSession");
    if (bookingSession == null || !bookingSession.isReadyForPayment()) {
      response.sendRedirect(request.getContextPath() + "/process-booking/payment");
      return;
    }

    // Pass booking data to JSP
    request.setAttribute("bookingSession", bookingSession);
    request.getRequestDispatcher("/WEB-INF/view/customer/appointments/confirmation.jsp").forward(request, response);
  }

  private void confirmBooking(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    HttpSession session = request.getSession();

    // Try to get BookingSession instead of legacy bookingData
    String sessionId = (String) session.getAttribute("bookingSessionId");
    if (sessionId != null) {
      BookingSession bookingSession = bookingSessionService.findSessionById(sessionId);
      if (bookingSession != null) {
        try {
          // Create booking appointments from session
          List<BookingAppointment> appointments = createBookingAppointmentsFromSession(bookingSession, session);

          if (!appointments.isEmpty()) {
            // Clear booking session
            session.removeAttribute(BOOKING_DATA_KEY);
            session.removeAttribute(BOOKING_STEP_KEY);
            session.removeAttribute("bookingSessionId");

            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true, \"appointmentCount\": " + appointments.size() + "}");
            return;
          }
        } catch (Exception e) {
          LOGGER.log(Level.SEVERE, "Error confirming booking from session", e);
        }
      }
    }

    // Fallback: try legacy booking data approach
    @SuppressWarnings("unchecked")
    Map<String, Object> bookingData = (Map<String, Object>) session.getAttribute(BOOKING_DATA_KEY);

    if (bookingData == null) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No booking session found");
      return;
    }

    try {
      // Legacy booking confirmation - just return success for now
      // TODO: Implement proper legacy booking confirmation if needed
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": true, \"message\": \"Booking confirmed (legacy mode)\"}");

    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error confirming booking", e);
      response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error confirming booking: " + e.getMessage());
    }
  }

  // LEGACY METHODS - COMMENTED OUT DUE TO DELETED Appointment CLASS
  // These methods reference the deleted Appointment model class
  // The system now uses BookingAppointment + BookingGroup + BookingSession
  // pattern

  /*
   * private Appointment createAppointmentFromBookingData(Map<String, Object>
   * bookingData, HttpServletRequest request) {
   * // Legacy method - disabled due to deleted Appointment class
   * return null;
   * }
   * 
   * private void generateQRCodeForAppointment(Appointment appointment) {
   * // Legacy method - disabled due to deleted Appointment class
   * }
   * 
   * private void sendConfirmationEmail(Appointment appointment,
   * HttpServletRequest request) {
   * // Legacy method - disabled due to deleted Appointment class
   * }
   * 
   * private void sendTherapistNotification(Appointment appointment) {
   * // Legacy method - disabled due to deleted Appointment class
   * }
   */

  // Additional booking management methods

  // LEGACY BOOKING MANAGEMENT METHODS - COMMENTED OUT DUE TO DELETED Appointment
  // CLASS

  private void handleBookingSummary(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // Legacy method - now using BookingAppointment instead of Appointment
    response.sendError(HttpServletResponse.SC_NOT_IMPLEMENTED, "Booking summary not yet implemented for new system");
  }

  private void handleCancelBooking(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // Legacy method - now using BookingAppointment instead of Appointment
    String appointmentId = request.getParameter("appointmentId");
    if (appointmentId != null) {
      try {
        boolean success = bookingAppointmentDAO.updateStatus(Integer.parseInt(appointmentId), "CANCELLED");
        if (success) {
          response.setContentType("application/json");
          response.getWriter().write("{\"success\": true, \"message\": \"Booking cancelled successfully\"}");
          return;
        }
      } catch (NumberFormatException e) {
        // Invalid appointment ID
      }
    }
    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Failed to cancel booking");
  }

  private void handleRescheduleBooking(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // TODO: Implement rescheduling logic for BookingAppointment
    response.setContentType("application/json");
    response.getWriter().write("{\"success\": false, \"message\": \"Rescheduling not yet implemented\"}");
  }

  private void handleBookingStatus(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // Legacy method - now using BookingAppointment instead of Appointment
    String appointmentId = request.getParameter("appointmentId");
    if (appointmentId != null) {
      try {
        var appointment = bookingAppointmentDAO.findById(Integer.parseInt(appointmentId));
        if (appointment.isPresent()) {
          BookingAppointment bookingAppointment = appointment.get();
          response.setContentType("application/json");
          String jsonResponse = gson.toJson(Map.of(
              "success", true,
              "appointmentId", bookingAppointment.getAppointmentId(),
              "status", bookingAppointment.getStatus(),
              "startTime", bookingAppointment.getStartTime().toString()));
          response.getWriter().write(jsonResponse);
          return;
        }
      } catch (NumberFormatException e) {
        // Invalid appointment ID
      }
    }
    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Appointment not found");
  }

  private void updateBookingStatus(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // Updated to use BookingAppointment instead of Appointment
    String appointmentId = request.getParameter("appointmentId");
    String newStatus = request.getParameter("status");

    if (appointmentId != null && newStatus != null) {
      try {
        boolean success = bookingAppointmentDAO.updateStatus(Integer.parseInt(appointmentId), newStatus);
        if (success) {
          response.setContentType("application/json");
          response.getWriter().write("{\"success\": true, \"message\": \"Status updated successfully\"}");
          return;
        }
      } catch (NumberFormatException e) {
        // Invalid appointment ID
      }
    }
    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Failed to update status");
  }

  // POST request handlers for saving data

  private void saveSelectedServices(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // Debug: Log all request parameters
    LOGGER.log(Level.INFO, "=== saveSelectedServices DEBUG ===");
    LOGGER.log(Level.INFO, "Request method: " + request.getMethod());
    LOGGER.log(Level.INFO, "Content type: " + request.getContentType());
    LOGGER.log(Level.INFO, "Request URI: " + request.getRequestURI());

    // Use BookingSessionService to get or create database-persisted session
    BookingSession bookingSession = bookingSessionService.getOrCreateSession(request);

    if (bookingSession == null) {
      LOGGER.log(Level.SEVERE, "Failed to create booking session");
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": false, \"message\": \"Failed to initialize booking session\"}");
      return;
    }

    // Set persistent cookie if marked by service
    setPersistentCookieIfNeeded(request, response);

    // Get selected service IDs
    String[] serviceIds = request.getParameterValues("serviceIds");
    LOGGER.log(Level.INFO, "serviceIds parameter: " + java.util.Arrays.toString(serviceIds));

    if (serviceIds == null || serviceIds.length == 0) {
      LOGGER.log(Level.WARNING, "No services selected in request");
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": false, \"message\": \"No services selected\"}");
      return;
    }

    try {
      // Load selected services from database
      List<Service> selectedServices = new ArrayList<>();
      for (String serviceId : serviceIds) {
        LOGGER.log(Level.INFO, "Processing service ID: " + serviceId);
        Service service = serviceDAO.findById(Integer.parseInt(serviceId)).orElse(null);
        if (service != null) {
          selectedServices.add(service);
        }
      }

      // Use BookingSessionService to save services to database
      boolean success = bookingSessionService.addServicesToSession(bookingSession, selectedServices);

      if (success) {
        LOGGER.log(Level.INFO, "Successfully saved " + selectedServices.size() + " services to database");
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": true, \"nextStep\": \"therapist-selection\"}");
      } else {
        LOGGER.log(Level.SEVERE, "Failed to save services to database");
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": false, \"message\": \"Failed to save services to database\"}");
      }

    } catch (NumberFormatException e) {
      LOGGER.log(Level.SEVERE, "Error parsing service IDs", e);
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": false, \"message\": \"Invalid service ID format\"}");
    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error saving services", e);
      response.setContentType("application/json");
      response.getWriter()
          .write("{\"success\": false, \"message\": \"Error saving services: " + e.getMessage() + "\"}");
    }
  }

  private void saveSelectedTherapist(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // Get booking session from database
    BookingSession bookingSession = bookingSessionService.getSessionFromRequest(request);
    if (bookingSession == null) {
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": false, \"message\": \"No booking session found\"}");
      return;
    }

    // Set persistent cookie if marked by service
    setPersistentCookieIfNeeded(request, response);

    String therapistId = request.getParameter("therapistId");
    if (therapistId == null || therapistId.trim().isEmpty()) {
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": false, \"message\": \"No therapist selected\"}");
      return;
    }

    try {
      // Load therapist from database
      Staff therapist = staffDAO.findById(Integer.parseInt(therapistId)).orElse(null);
      if (therapist == null) {
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": false, \"message\": \"Therapist not found\"}");
        return;
      }

      // Use BookingSessionService to assign therapist to services
      boolean success = false;
      if (bookingSession.hasServices()) {
        // Assign therapist to all selected services (simplified approach)
        for (BookingSession.ServiceSelection serviceSelection : bookingSession.getData().getSelectedServices()) {
          success = bookingSessionService.assignTherapistToService(
              bookingSession,
              serviceSelection.getServiceId(),
              therapist.getUser().getUserId(),
              therapist.getUser().getFullName());
          if (!success) {
            break; // Stop if any assignment fails
          }
        }
      }

      if (success) {
        LOGGER.log(Level.INFO, "Successfully assigned therapist to services in database");
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": true, \"nextStep\": \"time-selection\"}");
      } else {
        LOGGER.log(Level.SEVERE, "Failed to assign therapist to services in database");
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": false, \"message\": \"Failed to assign therapist\"}");
      }

    } catch (NumberFormatException e) {
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": false, \"message\": \"Invalid therapist ID format\"}");
    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error saving therapist", e);
      response.setContentType("application/json");
      response.getWriter()
          .write("{\"success\": false, \"message\": \"Error saving therapist: " + e.getMessage() + "\"}");
    }
  }

  private void saveSelectedTime(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // Get booking session from database
    BookingSession bookingSession = bookingSessionService.getSessionFromRequest(request);
    if (bookingSession == null) {
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": false, \"message\": \"No booking session found\"}");
      return;
    }

    // Set persistent cookie if marked by service
    setPersistentCookieIfNeeded(request, response);

    String selectedDate = request.getParameter("selectedDate");
    String selectedTime = request.getParameter("selectedTime");

    if (selectedDate == null || selectedTime == null) {
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": false, \"message\": \"Date and time must be selected\"}");
      return;
    }

    try {
      // Parse date and time
      LocalDate date = LocalDate.parse(selectedDate);
      LocalTime time = LocalTime.parse(selectedTime);

      // Store date/time in booking session using the new approach
      LocalDateTime selectedDateTime = LocalDateTime.of(date, time);

      // Use BookingSessionService to schedule all services
      boolean success = true;
      if (bookingSession.hasServices()) {
        LocalDateTime currentTime = selectedDateTime;

        for (BookingSession.ServiceSelection serviceSelection : bookingSession.getData().getSelectedServices()) {
          success = bookingSessionService.scheduleService(bookingSession, serviceSelection.getServiceId(), currentTime);
          if (!success) {
            break; // Stop if any scheduling fails
          }
          // Next service starts after current service ends
          currentTime = currentTime.plusMinutes(serviceSelection.getEstimatedDuration());
        }

        // Set the selected date in the session data if all scheduling was successful
        if (success) {
          bookingSession.getData().setSelectedDate(date);
          bookingSessionService.updateSession(bookingSession);
        }
      }

      if (success) {
        LOGGER.log(Level.INFO, "Successfully scheduled all services in database");
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": true, \"nextStep\": \"therapists\"}");
      } else {
        LOGGER.log(Level.SEVERE, "Failed to schedule services in database");
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": false, \"message\": \"Failed to schedule services\"}");
      }

    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error saving date/time", e);
      response.setContentType("application/json");
      response.getWriter()
          .write("{\"success\": false, \"message\": \"Error saving date/time: " + e.getMessage() + "\"}");
    }
  }

  private void processPayment(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // Get booking session from database
    BookingSession bookingSession = bookingSessionService.getSessionFromRequest(request);
    if (bookingSession == null || !bookingSessionService.isSessionReadyForPayment(bookingSession)) {
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": false, \"message\": \"Incomplete booking session\"}");
      return;
    }

    // Process payment logic here
    String paymentMethod = request.getParameter("paymentMethod");
    String notes = request.getParameter("notes");

    // Use BookingSessionService to update payment details
    boolean success = bookingSessionService.updatePaymentDetails(
        bookingSession,
        paymentMethod != null ? paymentMethod : "ONLINE_BANKING",
        notes);

    if (!success) {
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": false, \"message\": \"Failed to update payment details\"}");
      return;
    }

    try {
      // Create the actual appointments using new approach
      HttpSession httpSession = request.getSession();
      List<BookingAppointment> appointments = createBookingAppointmentsFromSession(bookingSession, httpSession);

      if (!appointments.isEmpty()) {
        // Clear booking session from database and HTTP session after successful booking
        bookingSessionService.completeAndDeleteSession(bookingSession.getSessionId());
        httpSession.removeAttribute("bookingSessionId");

        response.setContentType("application/json");
        response.getWriter().write("{\"success\": true, \"appointmentId\": " + appointments.get(0).getAppointmentId()
            + ", \"appointmentCount\": " + appointments.size() + ", \"nextStep\": \"confirmation\"}");
      } else {
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": false, \"message\": \"Failed to create appointments\"}");
      }

    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error processing payment", e);
      response.setContentType("application/json");
      response.getWriter()
          .write("{\"success\": false, \"message\": \"Error processing payment: " + e.getMessage() + "\"}");
    }
  }

  // Helper method to create BookingAppointments from booking session
  private List<BookingAppointment> createBookingAppointmentsFromSession(BookingSession bookingSession,
      HttpSession session) {
    List<BookingAppointment> appointments = new ArrayList<>();

    try {
      // Get customer from session (assuming user is logged in)
      Customer customer = (Customer) session.getAttribute("customer");
      if (customer == null) {
        LOGGER.log(Level.WARNING, "No customer found in session");
        return appointments;
      }

      // First, create the booking group (master record)
      BookingGroup bookingGroup = new BookingGroup();
      bookingGroup.setCustomerId(customer.getCustomerId());
      bookingGroup.setBookingDate(bookingSession.getData().getSelectedDate());
      bookingGroup.setTotalAmount(bookingSession.getData().getTotalAmount());
      bookingGroup.setPaymentStatus(BookingGroup.PaymentStatus.PAID.name());
      bookingGroup.setBookingStatus(BookingGroup.BookingStatus.CONFIRMED.name());
      bookingGroup.setPaymentMethod(bookingSession.getData().getPaymentMethod());
      bookingGroup.setSpecialNotes(bookingSession.getData().getSpecialNotes());
      bookingGroup.setCreatedAt(LocalDateTime.now());
      bookingGroup.setUpdatedAt(LocalDateTime.now());

      // TODO: Save booking group and get the generated ID
      // BookingGroup savedGroup = bookingGroupDAO.save(bookingGroup);
      // For now, assume we get an ID back
      Integer bookingGroupId = 1; // This should come from the saved booking group

      // Then create individual appointments for each service
      for (BookingSession.ServiceSelection serviceSelection : bookingSession.getData().getSelectedServices()) {
        BookingAppointment appointment = new BookingAppointment();

        appointment.setBookingGroupId(bookingGroupId);
        appointment.setServiceId(serviceSelection.getServiceId());
        appointment.setTherapistUserId(serviceSelection.getTherapistUserId());
        appointment.setStartTime(serviceSelection.getScheduledTime());

        // Calculate end time
        LocalDateTime endTime = serviceSelection.getScheduledTime()
            .plusMinutes(serviceSelection.getEstimatedDuration());
        appointment.setEndTime(endTime);

        appointment.setServicePrice(serviceSelection.getEstimatedPrice());
        appointment.setStatus(BookingAppointment.Status.SCHEDULED.name());
        appointment.setServiceNotes(bookingSession.getData().getSpecialNotes());
        appointment.setCreatedAt(LocalDateTime.now());
        appointment.setUpdatedAt(LocalDateTime.now());

        // TODO: Save appointment using proper DAO
        // BookingAppointment savedAppointment =
        // bookingAppointmentDAO.save(appointment);
        // For now, just add to list (this is placeholder code)
        appointment.setAppointmentId(appointments.size() + 1); // Temporary ID
        appointments.add(appointment);

        LOGGER.log(Level.INFO, "Created BookingAppointment for service: " + serviceSelection.getServiceName());
      }

    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error creating booking appointments", e);
    }

    return appointments;
  }

  // ========================= ENHANCED BOOKING METHODS =========================

  /**
   * Resume existing booking session
   */
  private void handleResumeSession(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    BookingSession session = bookingSessionService.getSessionFromRequest(request);

    if (session == null || session.isExpired()) {
      // No existing session, start fresh
      response.sendRedirect(request.getContextPath() + "/process-booking/services");
      return;
    }

    // Set persistent cookie to ensure session persistence
    setPersistentCookieIfNeeded(request, response);

    LOGGER.log(Level.INFO, "Resuming booking session: {0}, current step: {1}",
        new Object[] { session.getSessionId(), session.getCurrentStep() });

    // Based on the current step and data, redirect to the appropriate step
    switch (session.getCurrentStep()) {
      case SERVICES:
        response.sendRedirect(request.getContextPath() + "/process-booking/services");
        break;
      case TIME:
        if (session.hasServices()) {
          response.sendRedirect(request.getContextPath() + "/process-booking/time");
        } else {
          response.sendRedirect(request.getContextPath() + "/process-booking/services");
        }
        break;
      case THERAPISTS:
        if (session.hasServices() && session.hasTimeSlots()) {
          response.sendRedirect(request.getContextPath() + "/process-booking/therapists");
        } else if (session.hasServices()) {
          response.sendRedirect(request.getContextPath() + "/process-booking/time");
        } else {
          response.sendRedirect(request.getContextPath() + "/process-booking/services");
        }
        break;
      case REGISTRATION:
        if (session.hasServices() && session.hasTimeSlots() && session.hasTherapistAssignments()) {
          response.sendRedirect(request.getContextPath() + "/register?booking=true");
        } else {
          // Incomplete data, go back to where we need to continue
          String redirectUrl = bookingSessionService.getRedirectUrl(session);
          response.sendRedirect(request.getContextPath() + redirectUrl);
        }
        break;
      case PAYMENT:
        if (session.isReadyForPayment()) {
          response.sendRedirect(request.getContextPath() + "/process-booking/payment");
        } else {
          // Incomplete data, go back to where we need to continue
          String redirectUrl = bookingSessionService.getRedirectUrl(session);
          response.sendRedirect(request.getContextPath() + redirectUrl);
        }
        break;
      default:
        response.sendRedirect(request.getContextPath() + "/process-booking/services");
        break;
    }
  }

  /**
   * Enhanced service selection using BookingSessionService
   */
  private void handleEnhancedServiceSelection(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    BookingSession session = bookingSessionService.getOrCreateSession(request);

    if (session == null) {
      LOGGER.log(Level.SEVERE, "Failed to create booking session");
      response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to initialize booking session");
      return;
    }

    // Ensure persistent cookie is set for this session
    bookingSessionService.ensurePersistentStorage(request, session);
    setPersistentCookieIfNeeded(request, response);

    // Load service data
    List<ServiceType> serviceTypes = serviceTypeDAO.findAll();
    request.setAttribute("serviceTypes", serviceTypes);

    // Load current selections if any
    if (session.hasServices()) {
      request.setAttribute("selectedServices", session.getData().getSelectedServices());
    }

    // Load price range for filtering
    try {
      double minPrice = serviceDAO.findMinPrice();
      double maxPrice = serviceDAO.findMaxPrice();
      request.setAttribute("minPrice", minPrice);
      request.setAttribute("maxPrice", maxPrice);
    } catch (Exception e) {
      LOGGER.log(Level.WARNING, "Could not fetch price range", e);
      request.setAttribute("minPrice", 0.0);
      request.setAttribute("maxPrice", 10000000.0);
    }

    request.setAttribute("currentStep", "services");
    request.setAttribute("bookingSession", session);
    request.getRequestDispatcher("/WEB-INF/view/customer/appointments/services-selection.jsp")
        .forward(request, response);
  }

  /**
   * Enhanced therapist selection using BookingSessionService
   */
  private void handleEnhancedTherapistSelection(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    BookingSession session = bookingSessionService.getSessionFromRequest(request);

    if (session == null || !session.hasServices()) {
      response.sendRedirect(request.getContextPath() + "/booking/services");
      return;
    }

    // Set persistent cookie if session exists
    bookingSessionService.ensurePersistentStorage(request, session);
    setPersistentCookieIfNeeded(request, response);

    // Validate step progression
    if (!bookingSessionService.canProceedToStep(session, BookingSession.CurrentStep.THERAPISTS)) {
      response.sendRedirect(request.getContextPath() + "/booking/services");
      return;
    }

    request.setAttribute("selectedServices", session.getData().getSelectedServices());
    request.setAttribute("currentStep", "therapists");
    request.setAttribute("bookingSession", session);
    request.getRequestDispatcher("/WEB-INF/view/customer/appointments/therapist-selection.jsp")
        .forward(request, response);
  }

  /**
   * Enhanced time selection using BookingSessionService
   */
  private void handleEnhancedTimeSelection(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    BookingSession session = bookingSessionService.getSessionFromRequest(request);

    if (session == null || !session.hasServices() || !session.hasTherapistAssignments()) {
      String redirectUrl = bookingSessionService.getRedirectUrl(session);
      response.sendRedirect(request.getContextPath() + redirectUrl);
      return;
    }

    // Set persistent cookie if session exists
    bookingSessionService.ensurePersistentStorage(request, session);
    setPersistentCookieIfNeeded(request, response);

    // Validate step progression
    if (!bookingSessionService.canProceedToStep(session, BookingSession.CurrentStep.TIME)) {
      response.sendRedirect(request.getContextPath() + "/booking/therapists");
      return;
    }

    request.setAttribute("selectedServices", session.getData().getSelectedServices());
    request.setAttribute("currentStep", "time");
    request.setAttribute("bookingSession", session);
    request.getRequestDispatcher("/WEB-INF/view/customer/appointments/time-selection.jsp")
        .forward(request, response);
  }

  /**
   * Enhanced payment using BookingSessionService
   */
  private void handleEnhancedPayment(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    BookingSession session = bookingSessionService.getSessionFromRequest(request);

    if (session == null || !bookingSessionService.isSessionReadyForPayment(session)) {
      // Check if guest needs to register
      if (session != null && session.getCustomerId() == null && session.hasTimeSlots()) {
        response.sendRedirect(request.getContextPath() + "/register?booking=true");
        return;
      }

      String redirectUrl = bookingSessionService.getRedirectUrl(session);
      response.sendRedirect(request.getContextPath() + redirectUrl);
      return;
    }

    // Set persistent cookie if session exists
    bookingSessionService.ensurePersistentStorage(request, session);
    setPersistentCookieIfNeeded(request, response);

    // Load customer information
    Customer customer = (Customer) request.getSession().getAttribute("customer");
    request.setAttribute("customer", customer);
    request.setAttribute("bookingSession", session);
    request.setAttribute("currentStep", "payment");
    request.getRequestDispatcher("/WEB-INF/view/customer/appointments/payment.jsp")
        .forward(request, response);
  }

  /**
   * Enhanced service saving using BookingSessionService
   */
  private void saveEnhancedServices(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    response.setContentType("application/json");
    com.google.gson.JsonObject jsonResponse = new com.google.gson.JsonObject();

    try {
      BookingSession session = bookingSessionService.getOrCreateSession(request);

      if (session == null) {
        jsonResponse.addProperty("success", false);
        jsonResponse.addProperty("message", "Failed to initialize booking session");
        response.getWriter().write(gson.toJson(jsonResponse));
        return;
      }

      // Parse selected service IDs
      String serviceIdsParam = request.getParameter("serviceIds");
      if (serviceIdsParam == null || serviceIdsParam.trim().isEmpty()) {
        jsonResponse.addProperty("success", false);
        jsonResponse.addProperty("message", "No services selected");
        response.getWriter().write(gson.toJson(jsonResponse));
        return;
      }

      // Convert service IDs to Service objects
      List<Service> selectedServices = new ArrayList<>();
      String[] serviceIdArray = serviceIdsParam.split(",");

      for (String serviceIdStr : serviceIdArray) {
        try {
          int serviceId = Integer.parseInt(serviceIdStr.trim());
          Service service = serviceDAO.findById(serviceId).orElse(null);
          if (service != null) {
            selectedServices.add(service);
          }
        } catch (NumberFormatException e) {
          LOGGER.log(Level.WARNING, "Invalid service ID: " + serviceIdStr);
        }
      }

      if (selectedServices.isEmpty()) {
        jsonResponse.addProperty("success", false);
        jsonResponse.addProperty("message", "No valid services selected");
        response.getWriter().write(gson.toJson(jsonResponse));
        return;
      }

      // Save services to session
      boolean success = bookingSessionService.addServicesToSession(session, selectedServices);

      if (success) {
        jsonResponse.addProperty("success", true);
        jsonResponse.addProperty("message", "Services saved successfully");
        jsonResponse.addProperty("nextStep", "/booking/therapists");
      } else {
        jsonResponse.addProperty("success", false);
        jsonResponse.addProperty("message", "Failed to save services");
      }

    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error saving service selection", e);
      jsonResponse.addProperty("success", false);
      jsonResponse.addProperty("message", "Internal server error");
    }

    response.getWriter().write(gson.toJson(jsonResponse));
  }

  /**
   * Create appointments from booking session using new models
   */
  private List<BookingAppointment> createAppointmentsFromSession(BookingSession session) {
    List<BookingAppointment> appointments = new ArrayList<>();

    try {
      // First, create the booking group (master record)
      BookingGroup bookingGroup = new BookingGroup();
      bookingGroup.setCustomerId(session.getCustomerId());
      bookingGroup.setBookingDate(session.getData().getSelectedDate());
      bookingGroup.setTotalAmount(session.getData().getTotalAmount());
      bookingGroup.setPaymentStatus(BookingGroup.PaymentStatus.PAID.name());
      bookingGroup.setBookingStatus(BookingGroup.BookingStatus.CONFIRMED.name());
      bookingGroup.setPaymentMethod(session.getData().getPaymentMethod());
      bookingGroup.setSpecialNotes(session.getData().getSpecialNotes());
      bookingGroup.setCreatedAt(LocalDateTime.now());
      bookingGroup.setUpdatedAt(LocalDateTime.now());

      // TODO: Save booking group and get the generated ID
      // BookingGroup savedGroup = bookingGroupDAO.save(bookingGroup);
      // For now, assume we get an ID back
      Integer bookingGroupId = 1; // This should come from the saved booking group

      // Then create individual appointments for each service
      for (BookingSession.ServiceSelection serviceSelection : session.getData().getSelectedServices()) {
        BookingAppointment appointment = new BookingAppointment();

        appointment.setBookingGroupId(bookingGroupId);
        appointment.setServiceId(serviceSelection.getServiceId());
        appointment.setTherapistUserId(serviceSelection.getTherapistUserId());
        appointment.setStartTime(serviceSelection.getScheduledTime());

        // Calculate end time
        LocalDateTime endTime = serviceSelection.getScheduledTime()
            .plusMinutes(serviceSelection.getEstimatedDuration());
        appointment.setEndTime(endTime);

        appointment.setServicePrice(serviceSelection.getEstimatedPrice());
        appointment.setStatus(BookingAppointment.Status.SCHEDULED.name());
        appointment.setServiceNotes(session.getData().getSpecialNotes());
        appointment.setCreatedAt(LocalDateTime.now());
        appointment.setUpdatedAt(LocalDateTime.now());

        // TODO: Save appointment using proper DAO
        // BookingAppointment savedAppointment =
        // bookingAppointmentDAO.save(appointment);
        // For now, just add to list (this is placeholder code)
        appointment.setAppointmentId(appointments.size() + 1); // Temporary ID
        appointments.add(appointment);
      }

    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error creating appointments from session", e);
    }

    return appointments;
  }

  /**
   * Set persistent booking session cookie if marked by the service
   */
  private void setPersistentCookieIfNeeded(HttpServletRequest request, HttpServletResponse response) {
    String sessionIdToSet = (String) request.getAttribute("BOOKING_SESSION_ID_TO_SET");
    if (sessionIdToSet != null) {
      Cookie cookie = new Cookie("BOOKING_SESSION_ID", sessionIdToSet);
      cookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
      cookie.setPath("/");
      cookie.setHttpOnly(true);
      response.addCookie(cookie);
      LOGGER.log(Level.INFO, "✅ Set persistent booking session cookie: {0} (30-day expiry)", sessionIdToSet);

      // Remove the attribute so it's not processed again
      request.removeAttribute("BOOKING_SESSION_ID_TO_SET");
    } else {
      LOGGER.log(Level.FINE, "No session ID marked for cookie setting");
    }
  }

  /**
   * Handle booking list for customer
   */
  private void handleBookingList(HttpServletRequest request, HttpServletResponse response) 
      throws ServletException, IOException {
    try {
      // Get customer from session
      HttpSession session = request.getSession();
      Customer customer = (Customer) session.getAttribute("customer");
      
      if (customer == null) {
        // Redirect to login if not logged in
        response.sendRedirect(request.getContextPath() + "/login");
        return;
      }
      
      // Get search parameter
      String search = request.getParameter("search");
      
      // Get booking groups with appointments
      List<Map<String, Object>> bookingGroups = bookingAppointmentDAO.findBookingGroupsWithAppointments(customer.getCustomerId());
      
      // Filter by search if provided
      if (search != null && !search.trim().isEmpty()) {
        bookingGroups = filterBookingGroupsBySearch(bookingGroups, search.trim());
      }
      
      request.setAttribute("bookingGroups", bookingGroups);
      request.setAttribute("search", search);
      
      request.getRequestDispatcher("/WEB-INF/view/customer/appointments/booking_list.jsp").forward(request, response);
      
    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error handling booking list", e);
      request.setAttribute("errorMessage", "Error loading appointments: " + e.getMessage());
      request.getRequestDispatcher("/WEB-INF/view/customer/appointments/booking_list.jsp").forward(request, response);
    }
  }

  /**
   * Handle booking details for customer
   */
  private void handleBookingDetails(HttpServletRequest request, HttpServletResponse response) 
      throws ServletException, IOException {
    try {
      // Get customer from session
      HttpSession session = request.getSession();
      Customer customer = (Customer) session.getAttribute("customer");
      
      if (customer == null) {
        // Redirect to login if not logged in
        response.sendRedirect(request.getContextPath() + "/login");
        return;
      }
      
      // Get appointment ID from request attribute (set by pathInfo parsing)
      Integer appointmentId = (Integer) request.getAttribute("appointmentId");
      if (appointmentId == null) {
        request.setAttribute("errorMessage", "Appointment ID is required");
        request.getRequestDispatcher("/WEB-INF/view/customer/appointments/booking_details.jsp").forward(request, response);
        return;
      }
      
      // Get appointment details
      Map<String, Object> appointmentDetails = bookingAppointmentDAO.findAppointmentWithDetails(appointmentId);
      
      if (appointmentDetails.isEmpty()) {
        request.setAttribute("errorMessage", "Appointment not found");
        request.getRequestDispatcher("/WEB-INF/view/customer/appointments/booking_details.jsp").forward(request, response);
        return;
      }
      
      // Verify that the appointment belongs to the logged-in customer
      @SuppressWarnings("unchecked")
      Map<String, Object> bookingGroup = (Map<String, Object>) appointmentDetails.get("bookingGroup");
      if (bookingGroup == null || !customer.getCustomerId().equals(bookingGroup.get("customerId"))) {
        request.setAttribute("errorMessage", "Access denied: This appointment does not belong to you");
        request.getRequestDispatcher("/WEB-INF/view/customer/appointments/booking_details.jsp").forward(request, response);
        return;
      }
      // Convert LocalDateTime to java.util.Date for JSTL compatibility
      BookingAppointment appointment = (BookingAppointment) appointmentDetails.get("appointment");
      if (appointment != null) {
        java.util.Date startTimeDate = java.util.Date.from(appointment.getStartTime().atZone(java.time.ZoneId.systemDefault()).toInstant());
        java.util.Date endTimeDate = java.util.Date.from(appointment.getEndTime().atZone(java.time.ZoneId.systemDefault()).toInstant());
        appointmentDetails.put("startTimeDate", startTimeDate);
        appointmentDetails.put("endTimeDate", endTimeDate);
      }
      request.setAttribute("appointmentDetails", appointmentDetails);
      request.getRequestDispatcher("/WEB-INF/view/customer/appointments/booking_details.jsp").forward(request, response);
      
    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error handling booking details", e);
      request.setAttribute("errorMessage", "Error loading appointment details: " + e.getMessage());
      request.getRequestDispatcher("/WEB-INF/view/customer/appointments/booking_details.jsp").forward(request, response);
    }
  }

  /**
   * Filter booking groups by search term
   */
  private List<Map<String, Object>> filterBookingGroupsBySearch(List<Map<String, Object>> bookingGroups, String search) {
    List<Map<String, Object>> filteredGroups = new ArrayList<>();
    String searchLower = search.toLowerCase();
    
    for (Map<String, Object> group : bookingGroups) {
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> appointments = (List<Map<String, Object>>) group.get("appointments");
        List<Map<String, Object>> filteredAppointments = new ArrayList<>();
        
        for (Map<String, Object> appointment : appointments) {
            String serviceName = (String) appointment.get("serviceName");
            String therapistName = (String) appointment.get("therapistName");
            if ((serviceName != null && serviceName.toLowerCase().contains(searchLower)) ||
                (therapistName != null && therapistName.toLowerCase().contains(searchLower))) {
                filteredAppointments.add(appointment);
            }
        }
        if (!filteredAppointments.isEmpty()) {
            // Tạo bản sao group và chỉ giữ lại các appointment khớp search
            Map<String, Object> groupCopy = new java.util.HashMap<>(group);
            groupCopy.put("appointments", filteredAppointments);
            filteredGroups.add(groupCopy);
        }
    }
    return filteredGroups;
  }
}