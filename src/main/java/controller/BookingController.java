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
import model.Appointment;
import model.Customer;
import dao.ServiceDAO;
import dao.ServiceTypeDAO;
import dao.StaffDAO;
import dao.AppointmentDAO;
import dao.CustomerDAO;
import service.email.EmailService;
import util.QRCodeGenerator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import com.google.gson.Gson;
import java.util.logging.Logger;
import java.util.logging.Level;
import model.BookingSession;

@WebServlet(name = "BookingController", urlPatterns = { "/process-booking/*" })
public class BookingController extends HttpServlet {

  private static final Logger LOGGER = Logger.getLogger(BookingController.class.getName());

  private ServiceDAO serviceDAO;
  private StaffDAO staffDAO;
  private ServiceTypeDAO serviceTypeDAO;
  private AppointmentDAO appointmentDAO;
  private CustomerDAO customerDAO;
  private EmailService emailService;
  private QRCodeGenerator qrCodeGenerator;
  private Gson gson;

  // Booking session keys
  private static final String BOOKING_DATA_KEY = "bookingData";
  private static final String BOOKING_STEP_KEY = "bookingStep";

  // Booking steps
  public enum BookingStep {
    SERVICE_SELECTION,
    THERAPIST_SELECTION,
    TIME_SELECTION,
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
    appointmentDAO = new AppointmentDAO();
    customerDAO = new CustomerDAO();
    emailService = new EmailService();
    qrCodeGenerator = new QRCodeGenerator();
    gson = new Gson();
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String pathInfo = request.getPathInfo();
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
      case "/therapist-selection":
        handleTherapistSelection(request, response);
        break;
      case "/time-selection":
        handleTimeSelection(request, response);
        break;
      case "/payment":
        handlePayment(request, response);
        break;
      case "/confirmation":
        handleConfirmation(request, response);
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
        case "/save-services":
          saveSelectedServices(request, response);
          break;
        case "/save-therapist":
          saveSelectedTherapist(request, response);
          break;
        case "/save-time":
          saveSelectedTime(request, response);
          break;
        case "/process-payment":
          processPayment(request, response);
          break;
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
    HttpSession session = request.getSession(true);

    // Create or retrieve booking session
    BookingSession bookingSession = (BookingSession) session.getAttribute("bookingSession");
    if (bookingSession == null) {
      bookingSession = new BookingSession();
      session.setAttribute("bookingSession", bookingSession);
      LOGGER.log(Level.INFO, "Created new booking session for service selection");
    }

    // Load selected services from session if available
    List<Service> selectedServices = bookingSession.getSelectedServices();
    if (selectedServices != null && !selectedServices.isEmpty()) {
      request.setAttribute("selectedServices", selectedServices);
      LOGGER.log(Level.INFO, "Loaded " + selectedServices.size() + " services from session");
    }

    // Get price range for filtering
    ServiceDAO serviceDAO = new ServiceDAO();
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

    request.getRequestDispatcher("/WEB-INF/view/customer/appointments/services-selection.jsp").forward(request,
        response);
  }

  // Handle therapist selection - load selected services from session
  private void handleTherapistSelection(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    HttpSession session = request.getSession(false);

    if (session == null) {
      // No session, redirect to service selection
      response.sendRedirect(request.getContextPath() + "/process-booking/services");
      return;
    }

    BookingSession bookingSession = (BookingSession) session.getAttribute("bookingSession");
    if (bookingSession == null || bookingSession.getSelectedServices() == null
        || bookingSession.getSelectedServices().isEmpty()) {
      // No booking session or no services selected, redirect to service selection
      response.sendRedirect(request.getContextPath() + "/process-booking/services");
      return;
    }

    // Pass selected services to JSP
    request.setAttribute("selectedServices", bookingSession.getSelectedServices());
    request.getRequestDispatcher("/WEB-INF/view/customer/appointments/therapist-selection.jsp").forward(request,
        response);
  }

  // Handle time selection
  private void handleTimeSelection(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    HttpSession session = request.getSession(false);

    if (session == null) {
      response.sendRedirect(request.getContextPath() + "/process-booking/services");
      return;
    }

    BookingSession bookingSession = (BookingSession) session.getAttribute("bookingSession");
    if (bookingSession == null || bookingSession.getSelectedServices() == null
        || bookingSession.getSelectedTherapist() == null) {
      // Incomplete booking session, redirect appropriately
      if (bookingSession == null || bookingSession.getSelectedServices() == null) {
        response.sendRedirect(request.getContextPath() + "/process-booking/services");
      } else {
        response.sendRedirect(request.getContextPath() + "/process-booking/therapist-selection");
      }
      return;
    }

    // Pass booking data to JSP
    request.setAttribute("selectedServices", bookingSession.getSelectedServices());
    request.setAttribute("selectedTherapist", bookingSession.getSelectedTherapist());
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
    if (bookingSession == null || !bookingSession.isComplete()) {
      // Incomplete booking session, redirect to appropriate step
      if (bookingSession == null || bookingSession.getSelectedServices() == null) {
        response.sendRedirect(request.getContextPath() + "/process-booking/services");
      } else if (bookingSession.getSelectedTherapist() == null) {
        response.sendRedirect(request.getContextPath() + "/process-booking/therapist-selection");
      } else if (bookingSession.getSelectedDate() == null || bookingSession.getSelectedTime() == null) {
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
    if (bookingSession == null || !bookingSession.isComplete()) {
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
    @SuppressWarnings("unchecked")
    Map<String, Object> bookingData = (Map<String, Object>) session.getAttribute(BOOKING_DATA_KEY);

    if (bookingData == null) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No booking session found");
      return;
    }

    try {
      // Create appointment in database
      Appointment appointment = createAppointmentFromBookingData(bookingData, request);

      if (appointment != null && appointment.getAppointmentId() != null) {
        // Generate QR code for check-in
        generateQRCodeForAppointment(appointment);

        // Send confirmation email with QR code
        sendConfirmationEmail(appointment, request);

        // Send notification to therapist
        sendTherapistNotification(appointment);

        // Clear booking session
        session.removeAttribute(BOOKING_DATA_KEY);
        session.removeAttribute(BOOKING_STEP_KEY);

        response.setContentType("application/json");
        response.getWriter().write("{\"success\": true, \"appointmentId\": " + appointment.getAppointmentId() + "}");
      } else {
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to create appointment");
      }

    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error confirming booking", e);
      response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error confirming booking: " + e.getMessage());
    }
  }

  private Appointment createAppointmentFromBookingData(Map<String, Object> bookingData, HttpServletRequest request) {
    try {
      Appointment appointment = new Appointment();

      // Get customer ID from session (assume user is logged in)
      HttpSession session = request.getSession();
      Integer customerId = (Integer) session.getAttribute("customerId");
      if (customerId == null) {
        // For demo purposes, use a default customer ID
        customerId = 1;
      }

      appointment.setCustomerId(customerId);
      appointment.setTherapistUserId((Integer) bookingData.get("selectedTherapistId"));

      // Parse date and time
      String selectedDate = (String) bookingData.get("selectedDate");
      String selectedTime = (String) bookingData.get("selectedTime");
      LocalDateTime appointmentDateTime = LocalDateTime.parse(selectedDate + "T" + selectedTime);
      appointment.setStartTime(appointmentDateTime);

      // Calculate end time based on service duration
      @SuppressWarnings("unchecked")
      List<Integer> serviceIds = (List<Integer>) bookingData.get("selectedServiceIds");
      int totalDuration = 0;
      for (Integer serviceId : serviceIds) {
        Service service = serviceDAO.findById(serviceId).orElse(null);
        if (service != null) {
          totalDuration += service.getDurationMinutes();
        }
      }
      appointment.setEndTime(appointmentDateTime.plusMinutes(totalDuration));

      // Set financial details
      appointment.setTotalOriginalPrice(new BigDecimal((String) bookingData.get("totalAmount")));
      appointment.setTotalDiscountAmount(BigDecimal.ZERO);
      appointment.setPointsRedeemedValue(BigDecimal.ZERO);
      appointment.setTotalFinalPrice(new BigDecimal((String) bookingData.get("totalAmount")));

      // Set status
      appointment.setStatus("PENDING_CONFIRMATION");
      appointment.setPaymentStatus((String) bookingData.get("paymentStatus"));

      appointment.setCreatedAt(LocalDateTime.now());
      appointment.setUpdatedAt(LocalDateTime.now());

      // Save appointment
      Appointment savedAppointment = appointmentDAO.save(appointment);
      return savedAppointment;

    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error creating appointment from booking data", e);
      return null;
    }
  }

  private void generateQRCodeForAppointment(Appointment appointment) {
    try {
      // TODO: Implement QR code generation
      // String qrCodePath =
      // qrCodeGenerator.generateAppointmentQR(appointment.getAppointmentId());
      LOGGER.info("QR code generated for appointment: " + appointment.getAppointmentId());
    } catch (Exception e) {
      LOGGER.log(Level.WARNING, "Failed to generate QR code for appointment: " + appointment.getAppointmentId(), e);
    }
  }

  private void sendConfirmationEmail(Appointment appointment, HttpServletRequest request) {
    try {
      // Get customer details
      Customer customer = customerDAO.findById(appointment.getCustomerId()).orElse(null);
      if (customer != null) {
        // TODO: Implement booking confirmation email
        // emailService.sendBookingConfirmationEmail(customer.getEmail(), appointment);
        LOGGER.info("Confirmation email sent for appointment: " + appointment.getAppointmentId());
      }
    } catch (Exception e) {
      LOGGER.log(Level.WARNING, "Failed to send confirmation email for appointment: " + appointment.getAppointmentId(),
          e);
    }
  }

  private void sendTherapistNotification(Appointment appointment) {
    try {
      // Get therapist details
      Staff therapist = staffDAO.findById(appointment.getTherapistUserId()).orElse(null);
      if (therapist != null) {
        // TODO: Implement therapist notification email
        // emailService.sendTherapistNotificationEmail(therapist.getUser().getEmail(),
        // appointment);
        LOGGER.info("Therapist notification sent for appointment: " + appointment.getAppointmentId());
      }
    } catch (Exception e) {
      LOGGER.log(Level.WARNING,
          "Failed to send therapist notification for appointment: " + appointment.getAppointmentId(), e);
    }
  }

  // Additional booking management methods

  private void handleBookingSummary(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    String appointmentId = request.getParameter("appointmentId");
    if (appointmentId != null) {
      try {
        Appointment appointment = appointmentDAO.findById(Integer.parseInt(appointmentId)).orElse(null);
        if (appointment != null) {
          request.setAttribute("appointment", appointment);
          request.getRequestDispatcher("/WEB-INF/view/customer/appointments/booking-summary.jsp").forward(request,
              response);
          return;
        }
      } catch (NumberFormatException e) {
        // Invalid appointment ID
      }
    }

    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Appointment not found");
  }

  private void handleCancelBooking(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    String appointmentId = request.getParameter("appointmentId");
    String cancelReason = request.getParameter("cancelReason");

    if (appointmentId != null) {
      try {
        boolean success = appointmentDAO.updateStatus(Integer.parseInt(appointmentId), "CANCELLED_BY_CUSTOMER");
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

    // TODO: Implement rescheduling logic
    response.setContentType("application/json");
    response.getWriter().write("{\"success\": false, \"message\": \"Rescheduling not yet implemented\"}");
  }

  private void handleBookingStatus(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    String appointmentId = request.getParameter("appointmentId");
    if (appointmentId != null) {
      try {
        Appointment appointment = appointmentDAO.findById(Integer.parseInt(appointmentId)).orElse(null);
        if (appointment != null) {
          response.setContentType("application/json");
          String jsonResponse = gson.toJson(Map.of(
              "success", true,
              "appointmentId", appointment.getAppointmentId(),
              "status", appointment.getStatus(),
              "paymentStatus", appointment.getPaymentStatus(),
              "startTime", appointment.getStartTime().toString()));
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

    String appointmentId = request.getParameter("appointmentId");
    String newStatus = request.getParameter("status");

    if (appointmentId != null && newStatus != null) {
      try {
        boolean success = appointmentDAO.updateStatus(Integer.parseInt(appointmentId), newStatus);
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

    HttpSession session = request.getSession(true);
    BookingSession bookingSession = (BookingSession) session.getAttribute("bookingSession");

    // Create booking session if it doesn't exist
    if (bookingSession == null) {
      LOGGER.log(Level.WARNING, "No booking session found, creating new one");
      bookingSession = new BookingSession();
      session.setAttribute("bookingSession", bookingSession);
    }

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

      // Store in booking session
      bookingSession.setSelectedServices(selectedServices);
      session.setAttribute("bookingSession", bookingSession);

      LOGGER.log(Level.INFO, "Successfully saved " + selectedServices.size() + " services");

      // Return success response
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": true, \"nextStep\": \"therapist-selection\"}");

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

    HttpSession session = request.getSession(false);
    if (session == null) {
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": false, \"message\": \"No session found\"}");
      return;
    }

    BookingSession bookingSession = (BookingSession) session.getAttribute("bookingSession");
    if (bookingSession == null) {
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": false, \"message\": \"No booking session found\"}");
      return;
    }

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

      // Store in booking session
      bookingSession.setSelectedTherapist(therapist);
      session.setAttribute("bookingSession", bookingSession);

      response.setContentType("application/json");
      response.getWriter().write("{\"success\": true, \"nextStep\": \"time-selection\"}");

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

    HttpSession session = request.getSession(false);
    if (session == null) {
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": false, \"message\": \"No session found\"}");
      return;
    }

    BookingSession bookingSession = (BookingSession) session.getAttribute("bookingSession");
    if (bookingSession == null) {
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": false, \"message\": \"No booking session found\"}");
      return;
    }

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

      // Store in booking session
      bookingSession.setSelectedDate(date);
      bookingSession.setSelectedTime(time);
      session.setAttribute("bookingSession", bookingSession);

      response.setContentType("application/json");
      response.getWriter().write("{\"success\": true, \"nextStep\": \"payment\"}");

    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error saving date/time", e);
      response.setContentType("application/json");
      response.getWriter()
          .write("{\"success\": false, \"message\": \"Error saving date/time: " + e.getMessage() + "\"}");
    }
  }

  private void processPayment(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    HttpSession session = request.getSession(false);
    if (session == null) {
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": false, \"message\": \"No session found\"}");
      return;
    }

    BookingSession bookingSession = (BookingSession) session.getAttribute("bookingSession");
    if (bookingSession == null || !bookingSession.isComplete()) {
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": false, \"message\": \"Incomplete booking session\"}");
      return;
    }

    // Process payment logic here
    String paymentMethod = request.getParameter("paymentMethod");
    String notes = request.getParameter("notes");

    // For now, simulate successful payment (cash at spa)
    bookingSession.setPaymentMethod(paymentMethod != null ? paymentMethod : "cash");
    bookingSession.setNotes(notes);

    try {
      // Create the actual appointment
      Appointment appointment = createAppointmentFromBookingSession(bookingSession, session);

      if (appointment != null) {
        // Clear booking session after successful booking
        session.removeAttribute("bookingSession");

        response.setContentType("application/json");
        response.getWriter().write("{\"success\": true, \"appointmentId\": " + appointment.getAppointmentId()
            + ", \"nextStep\": \"confirmation\"}");
      } else {
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": false, \"message\": \"Failed to create appointment\"}");
      }

    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error processing payment", e);
      response.setContentType("application/json");
      response.getWriter()
          .write("{\"success\": false, \"message\": \"Error processing payment: " + e.getMessage() + "\"}");
    }
  }

  // Helper method to create appointment from booking session
  private Appointment createAppointmentFromBookingSession(BookingSession bookingSession, HttpSession session) {
    try {
      // Get customer from session (assuming user is logged in)
      Customer customer = (Customer) session.getAttribute("customer");
      if (customer == null) {
        LOGGER.log(Level.WARNING, "No customer found in session");
        return null;
      }

      // Create appointment
      Appointment appointment = new Appointment();
      appointment.setCustomerId(customer.getCustomerId());
      appointment.setTherapistUserId(bookingSession.getSelectedTherapist().getUser().getUserId());

      // Set appointment date/time
      LocalDateTime appointmentDateTime = LocalDateTime.of(
          bookingSession.getSelectedDate(),
          bookingSession.getSelectedTime());
      appointment.setStartTime(appointmentDateTime);

      // Calculate end time based on total duration
      LocalDateTime endTime = appointmentDateTime.plusMinutes(bookingSession.getTotalDurationMinutes());
      appointment.setEndTime(endTime);

      // Set total amount
      appointment.setTotalFinalPrice(bookingSession.getTotalAmount());
      appointment.setTotalOriginalPrice(bookingSession.getTotalAmount());
      appointment.setStatus("CONFIRMED");
      appointment.setPaymentStatus("PAID");

      // Save appointment
      Appointment savedAppointment = appointmentDAO.save(appointment);

      if (savedAppointment != null) {
        // TODO: Generate QR code for appointment
        // TODO: Send confirmation email
        LOGGER.log(Level.INFO, "Appointment created successfully with ID: " + savedAppointment.getAppointmentId());
      }

      return savedAppointment;

    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error creating appointment", e);
      return null;
    }
  }
}