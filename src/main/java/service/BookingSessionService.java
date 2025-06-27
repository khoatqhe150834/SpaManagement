package service;

import dao.BookingSessionDAO;
import model.BookingSession;
import model.BookingSession.ServiceSelection;
import model.Customer;
import model.Service;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BookingSessionService {
  private static final Logger LOGGER = Logger.getLogger(BookingSessionService.class.getName());
  private final BookingSessionDAO bookingSessionDAO;

  public BookingSessionService() {
    this.bookingSessionDAO = new BookingSessionDAO();
  }

  public BookingSessionService(BookingSessionDAO bookingSessionDAO) {
    this.bookingSessionDAO = bookingSessionDAO;
  }

  /**
   * Get or create a booking session for the current user
   * Handles both guest and logged-in customer scenarios
   * NOTE: This method creates sessions and should only be called when user
   * explicitly starts booking
   */
  public BookingSession getOrCreateSession(HttpServletRequest request) {
    Customer customer = (Customer) request.getSession().getAttribute("customer");

    BookingSession bookingSession = null;

    if (customer != null) {
      // Logged-in customer: find existing session or create new one
      bookingSession = bookingSessionDAO.findByCustomerId(customer.getCustomerId());

      if (bookingSession == null) {
        bookingSession = createCustomerSession(customer, request);
      }
    } else {
      // Guest user: check cookie for session ID only (no HTTP session)
      String sessionId = getPersistentSessionIdFromRequest(request);

      if (sessionId != null) {
        bookingSession = bookingSessionDAO.findBySessionId(sessionId);
      }

      if (bookingSession == null) {
        bookingSession = createGuestSession(request);
      }
    }

    // Update expiry time to extend session
    if (bookingSession != null) {
      bookingSession.setExpiresAt(LocalDateTime.now().plusDays(30));
      updateSession(bookingSession);
    }

    return bookingSession;
  }

  /**
   * Start a new booking session explicitly (for when users click "Đặt lịch ngay")
   * This always creates a new session, replacing any existing one
   */
  public BookingSession startNewBookingSession(HttpServletRequest request) {
    Customer customer = (Customer) request.getSession().getAttribute("customer");

    // Clean up any existing session first
    if (customer != null) {
      BookingSession existingSession = bookingSessionDAO.findByCustomerId(customer.getCustomerId());
      if (existingSession != null) {
        bookingSessionDAO.delete(existingSession.getSessionId());
        LOGGER.log(Level.INFO, "Deleted existing customer session before creating new one: {0}",
            existingSession.getSessionId());
      }
    } else {
      String existingSessionId = getPersistentSessionIdFromRequest(request);
      if (existingSessionId != null) {
        bookingSessionDAO.delete(existingSessionId);
        LOGGER.log(Level.INFO, "Deleted existing guest session before creating new one: {0}", existingSessionId);
      }
    }

    // Create fresh session
    if (customer != null) {
      return createCustomerSession(customer, request);
    } else {
      return createGuestSession(request);
    }
  }

  /**
   * Create a new guest session (cookie-only, no HTTP session)
   */
  private BookingSession createGuestSession(HttpServletRequest request) {
    String sessionId = generateSessionId();
    BookingSession bookingSession = new BookingSession(sessionId);
    bookingSession.setCustomerId(null); // Guest session
    bookingSession.setCurrentStep(BookingSession.CurrentStep.SERVICES);

    if (bookingSessionDAO.create(bookingSession)) {
      // Store in cookie only (no HTTP session)
      setPersistentSessionId(request, sessionId);

      LOGGER.log(Level.INFO, "Created guest booking session (cookie-only): {0}", sessionId);
      return bookingSession;
    }

    LOGGER.log(Level.SEVERE, "Failed to create guest booking session");
    return null;
  }

  /**
   * Create a new customer session (cookie-only)
   */
  private BookingSession createCustomerSession(Customer customer, HttpServletRequest request) {
    String sessionId = generateSessionId();
    BookingSession bookingSession = new BookingSession(sessionId);
    bookingSession.setCustomerId(customer.getCustomerId());
    bookingSession.setCurrentStep(BookingSession.CurrentStep.SERVICES);

    if (bookingSessionDAO.create(bookingSession)) {
      // Store in cookie only
      setPersistentSessionId(request, sessionId);

      LOGGER.log(Level.INFO, "Created customer booking session (cookie-only): {0} for customer: {1}",
          new Object[] { sessionId, customer.getCustomerId() });
      return bookingSession;
    }

    LOGGER.log(Level.SEVERE, "Failed to create customer booking session for customer: {0}", customer.getCustomerId());
    return null;
  }

  /**
   * Convert guest session to customer session after registration/login
   */
  public boolean convertGuestSessionToCustomer(String sessionId, Customer customer) {
    if (sessionId == null || customer == null) {
      return false;
    }

    boolean success = bookingSessionDAO.convertToCustomerSession(sessionId, customer.getCustomerId());

    if (success) {
      LOGGER.log(Level.INFO, "Converted guest session {0} to customer {1}",
          new Object[] { sessionId, customer.getCustomerId() });
    }

    return success;
  }

  /**
   * Add services to booking session
   */
  public boolean addServicesToSession(BookingSession session, List<Service> services) {
    try {
      // Clear existing services
      session.getData().getSelectedServices().clear();

      // Add new services
      for (int i = 0; i < services.size(); i++) {
        Service service = services.get(i);
        ServiceSelection selection = new ServiceSelection(
            service.getServiceId(),
            service.getName(),
            service.getPrice(),
            service.getDurationMinutes());
        selection.setServiceOrder(i + 1);
        session.addSelectedService(selection);
      }

      session.setCurrentStep(BookingSession.CurrentStep.TIME);
      return updateSession(session);

    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error adding services to session: " + session.getSessionId(), e);
      return false;
    }
  }

  /**
   * Assign therapist to a service in the session
   */
  public boolean assignTherapistToService(BookingSession session, int serviceId,
      int therapistUserId, String therapistName) {
    try {
      session.assignTherapistToService(serviceId, therapistUserId, therapistName);

      // Check if all services have therapists assigned
      if (session.hasTherapistAssignments()) {
        if (session.getCustomerId() != null) {
          session.setCurrentStep(BookingSession.CurrentStep.PAYMENT);
        } else {
          session.setCurrentStep(BookingSession.CurrentStep.REGISTRATION);
        }
      }

      return updateSession(session);

    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error assigning therapist to service in session: " + session.getSessionId(), e);
      return false;
    }
  }

  /**
   * Schedule a service in the session
   */
  public boolean scheduleService(BookingSession session, int serviceId, LocalDateTime scheduledTime) {
    try {
      session.scheduleService(serviceId, scheduledTime);

      // Check if all services have time slots
      if (session.hasTimeSlots()) {
        session.setCurrentStep(BookingSession.CurrentStep.THERAPISTS);
      }

      return updateSession(session);

    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error scheduling service in session: " + session.getSessionId(), e);
      return false;
    }
  }

  /**
   * Update session payment details
   */
  public boolean updatePaymentDetails(BookingSession session, String paymentMethod, String specialNotes) {
    try {
      session.getData().setPaymentMethod(paymentMethod);
      session.getData().setSpecialNotes(specialNotes);
      session.setCurrentStep(BookingSession.CurrentStep.PAYMENT);

      return updateSession(session);

    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error updating payment details in session: " + session.getSessionId(), e);
      return false;
    }
  }

  /**
   * Check if session is ready for payment
   */
  public boolean isSessionReadyForPayment(BookingSession session) {
    return session != null && session.isReadyForPayment();
  }

  /**
   * Validate session step progression
   */
  public boolean canProceedToStep(BookingSession session, BookingSession.CurrentStep targetStep) {
    if (session == null)
      return false;

    switch (targetStep) {
      case SERVICES:
        return true; // Can always start with services

      case TIME:
        return session.hasServices();

      case THERAPISTS:
        return session.hasServices() && session.hasTimeSlots();

      case REGISTRATION:
        return session.hasServices() && session.hasTimeSlots() &&
            session.hasTherapistAssignments() && session.getCustomerId() == null;

      case PAYMENT:
        return session.hasServices() && session.hasTimeSlots() &&
            session.hasTherapistAssignments() && session.getCustomerId() != null;

      default:
        return false;
    }
  }

  /**
   * Update existing session
   */
  public boolean updateSession(BookingSession session) {
    return bookingSessionDAO.update(session);
  }

  /**
   * Delete session after successful booking completion
   */
  public boolean completeAndDeleteSession(String sessionId) {
    return bookingSessionDAO.delete(sessionId);
  }

  /**
   * Clean up expired sessions
   */
  public int cleanupExpiredSessions() {
    return bookingSessionDAO.deleteExpiredSessions();
  }

  /**
   * Get session statistics
   */
  public BookingSessionDAO.SessionStats getSessionStats() {
    return bookingSessionDAO.getSessionStats();
  }

  /**
   * Find session by ID
   */
  public BookingSession findSessionById(String sessionId) {
    return bookingSessionDAO.findBySessionId(sessionId);
  }

  /**
   * Find active session for customer
   */
  public BookingSession findActiveSessionForCustomer(Integer customerId) {
    return bookingSessionDAO.findByCustomerId(customerId);
  }

  /**
   * Generate unique session ID
   */
  private String generateSessionId() {
    return "bs_" + UUID.randomUUID().toString().replace("-", "");
  }

  /**
   * Redirect users to appropriate step based on session state
   */
  public String getRedirectUrl(BookingSession session) {
    if (session == null || session.isExpired()) {
      return "/process-booking/services";
    }

    switch (session.getCurrentStep()) {
      case SERVICES:
        return "/process-booking/services";
      case TIME:
        return "/process-booking/time";
      case THERAPISTS:
        return "/process-booking/therapists";
      case REGISTRATION:
        return "/register?booking=true";
      case PAYMENT:
        return "/process-booking/payment";
      default:
        return "/process-booking/services";
    }
  }

  /**
   * Get session from HTTP request (cookies only - does NOT create sessions)
   * This method only retrieves existing sessions and will not create new ones
   */
  public BookingSession getSessionFromRequest(HttpServletRequest request) {
    Customer customer = (Customer) request.getSession().getAttribute("customer");

    // Priority 1: Check for logged-in customer session
    if (customer != null) {
      BookingSession session = bookingSessionDAO.findByCustomerId(customer.getCustomerId());
      if (session != null && !session.isExpired()) {
        // Ensure cookie is set for persistence (but don't store in HTTP session)
        setPersistentSessionId(request, session.getSessionId());
        return session;
      }
    }

    // Priority 2: Check cookie for persistent session ID (no HTTP session check)
    String persistentSessionId = getPersistentSessionIdFromRequest(request);
    if (persistentSessionId != null) {
      BookingSession session = bookingSessionDAO.findBySessionId(persistentSessionId);
      if (session != null && !session.isExpired()) {
        // Refresh cookie but do NOT store in HTTP session
        setPersistentSessionId(request, persistentSessionId);
        LOGGER.log(Level.INFO, "Retrieved existing booking session from cookie: {0}", persistentSessionId);
        return session;
      } else if (session != null && session.isExpired()) {
        LOGGER.log(Level.INFO, "Found expired booking session in cookie: {0}", persistentSessionId);
        // Don't return expired sessions
      }
    }

    // No existing session found - do NOT create one
    return null;
  }

  /**
   * Set persistent session ID in browser storage (via response mechanism)
   * Since we can't directly access HttpServletResponse here, we'll store it as a
   * request attribute
   * for the controller to set as a cookie
   */
  private void setPersistentSessionId(HttpServletRequest request, String sessionId) {
    // Store session ID as request attribute so controller can set it as a cookie
    request.setAttribute("BOOKING_SESSION_ID_TO_SET", sessionId);
    LOGGER.log(Level.INFO, "Marked session ID for persistent storage: {0}", sessionId);
  }

  /**
   * Public method for controllers to explicitly mark session for cookie setting
   * This ensures cookies are set whenever a session is accessed
   */
  public void ensurePersistentStorage(HttpServletRequest request, BookingSession session) {
    if (session != null) {
      setPersistentSessionId(request, session.getSessionId());
    }
  }

  /**
   * Extract persistent session ID from request (cookies or headers)
   */
  private String getPersistentSessionIdFromRequest(HttpServletRequest request) {
    // Check cookies first
    if (request.getCookies() != null) {
      for (Cookie cookie : request.getCookies()) {
        if ("BOOKING_SESSION_ID".equals(cookie.getName())) {
          return cookie.getValue();
        }
      }
    }

    // Check custom header (for AJAX requests)
    String headerSessionId = request.getHeader("X-Booking-Session-Id");
    if (headerSessionId != null && !headerSessionId.trim().isEmpty()) {
      return headerSessionId.trim();
    }

    // Check request parameter (fallback)
    String paramSessionId = request.getParameter("bookingSessionId");
    if (paramSessionId != null && !paramSessionId.trim().isEmpty()) {
      return paramSessionId.trim();
    }

    return null;
  }
}