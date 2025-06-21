# Spa Management System - Booking Session Architecture

## Table of Contents

1. [Overview](#overview)
2. [Database Design](#database-design)
3. [Session Management Strategy](#session-management-strategy)
4. [Implementation Guide](#implementation-guide)
5. [Guest vs Customer Flows](#guest-vs-customer-flows)
6. [Code Examples](#code-examples)
7. [Best Practices](#best-practices)
8. [Troubleshooting](#troubleshooting)

---

## Overview

### Problem Statement

The spa booking system needs to handle:

- **Multiple services per booking** (e.g., massage + facial + manicure)
- **Session persistence** across page reloads and browser crashes
- **Both guest and logged-in customer** booking flows
- **Multi-device session recovery** for customers
- **Temporary data storage** during the booking process
- **Clean separation** between booking process and final bookings

### Solution Architecture

A two-layer approach:

- **Temporary Layer**: `booking_sessions` table for in-progress bookings
- **Permanent Layer**: `booking_groups` + `booking_appointments` for confirmed bookings

---

## Database Design

### Current Table Issues

#### ❌ Problem with Single `appointments` Table

```sql
-- Current appointments table can only handle:
CREATE TABLE `appointments` (
  `therapist_user_id` int,  -- Only ONE therapist
  `start_time` datetime,    -- Only ONE time slot
  `end_time` datetime,      -- Only ONE end time
  -- Cannot handle multiple services with different therapists
);
```

**Issues:**

- Cannot represent 3 services with 3 different therapists
- Either creates confusion (3 separate "appointments") or data integrity issues
- No proper service-level tracking within a booking

### ✅ Recommended Database Architecture

#### 1. Booking Sessions Table (Temporary Process Data)

```sql
CREATE TABLE `booking_sessions` (
  `session_id` VARCHAR(255) PRIMARY KEY,
  `customer_id` INT NULL,                    -- NULL until registration
  `session_data` JSON NOT NULL,             -- All booking selections
  `current_step` ENUM('services', 'therapists', 'time', 'registration', 'payment') DEFAULT 'services',
  `expires_at` TIMESTAMP NOT NULL,          -- Auto-cleanup after 2 hours
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (`customer_id`) REFERENCES `customers`(`customer_id`) ON DELETE CASCADE,
  INDEX `idx_customer_id` (`customer_id`),
  INDEX `idx_expires_at` (`expires_at`)
);
```

#### 2. Booking Groups Table (Master Booking Record)

```sql
-- Use existing booking_groups table or enhance it:
CREATE TABLE `booking_groups` (
  `booking_group_id` INT AUTO_INCREMENT PRIMARY KEY,
  `customer_id` INT NOT NULL,
  `booking_date` DATE NOT NULL,
  `total_amount` DECIMAL(10,2) NOT NULL,
  `payment_status` ENUM('PENDING', 'PAID', 'REFUNDED') DEFAULT 'PENDING',
  `booking_status` ENUM('CONFIRMED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED') DEFAULT 'CONFIRMED',
  `payment_method` VARCHAR(50) DEFAULT 'cash',
  `special_notes` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (`customer_id`) REFERENCES `customers`(`customer_id`),
  INDEX `idx_customer_booking_date` (`customer_id`, `booking_date`),
  INDEX `idx_booking_status` (`booking_status`)
);
```

#### 3. Individual Service Appointments Table

```sql
CREATE TABLE `booking_appointments` (
  `appointment_id` INT AUTO_INCREMENT PRIMARY KEY,
  `booking_group_id` INT NOT NULL,
  `service_id` INT NOT NULL,
  `therapist_user_id` INT NOT NULL,
  `start_time` DATETIME NOT NULL,
  `end_time` DATETIME NOT NULL,
  `service_price` DECIMAL(8,2) NOT NULL,
  `appointment_order` TINYINT DEFAULT 1,  -- Sequence: 1st, 2nd, 3rd service
  `status` ENUM('SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED') DEFAULT 'SCHEDULED',
  `service_notes` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (`booking_group_id`) REFERENCES `booking_groups`(`booking_group_id`) ON DELETE CASCADE,
  FOREIGN KEY (`service_id`) REFERENCES `services`(`service_id`),
  FOREIGN KEY (`therapist_user_id`) REFERENCES `therapists`(`user_id`),

  INDEX `idx_booking_group` (`booking_group_id`),
  INDEX `idx_therapist_time` (`therapist_user_id`, `start_time`),
  INDEX `idx_service_status` (`service_id`, `status`)
);
```

### Session Data JSON Structure

```json
{
  "selectedServices": [
    {
      "serviceId": 5,
      "serviceName": "Swedish Massage",
      "therapistUserId": 101,
      "therapistName": "Alice Johnson",
      "estimatedPrice": 1200000,
      "estimatedDuration": 60,
      "scheduledTime": "2024-01-15T10:00:00",
      "serviceOrder": 1
    },
    {
      "serviceId": 8,
      "serviceName": "Deep Cleansing Facial",
      "therapistUserId": 102,
      "therapistName": "Bob Smith",
      "estimatedPrice": 950000,
      "estimatedDuration": 45,
      "scheduledTime": "2024-01-15T11:15:00",
      "serviceOrder": 2
    }
  ],
  "totalAmount": 2150000,
  "totalDuration": 105,
  "selectedDate": "2024-01-15",
  "paymentMethod": "cash",
  "specialNotes": "First time customer, allergic to lavender",
  "guestInfo": {
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "+84987654321",
    "address": "123 Main St, Ho Chi Minh City"
  }
}
```

---

## Session Management Strategy

### Data Lifecycle

#### Booking Process (TEMPORARY)

```
Customer browsing → Selecting services → Choosing therapists → Picking times → Payment
     ↓                    ↓                     ↓                   ↓           ↓
(Nothing saved)    (Save to session)    (Update session)    (Update session)  (Create final booking)
```

#### Final Booking (PERMANENT)

```
Payment completed → booking_groups + booking_appointments created → booking_sessions deleted
```

### Session Types

| Feature                   | Guest Sessions          | Customer Sessions       |
| ------------------------- | ----------------------- | ----------------------- |
| **Identifier**            | Browser session ID      | Customer ID             |
| **Cross-device Recovery** | ❌ No                   | ✅ Yes                  |
| **Data Persistence**      | Until browser closes    | Until completed/expired |
| **Contact Info**          | Required during booking | From customer profile   |
| **Session Recovery**      | Same browser only       | Any device after login  |
| **Conversion**            | Can become customer     | Already customer        |

### Session Flow Scenarios

#### Scenario 1: Guest User Booking

```
1. Guest visits → creates session with browser session ID
2. Guest selects services → saves to booking_sessions (customer_id = NULL)
3. Guest selects therapists → updates session JSON
4. Guest selects time → updates session JSON
5. Guest goes to payment → must provide contact info (guest_info step)
6. Guest completes booking → creates customer record + booking_groups + booking_appointments
7. Session deleted after successful booking
```

#### Scenario 2: Logged-in Customer Booking

```
1. Customer visits → creates session with customer_id
2. Customer selects services → saves to booking_sessions
3. Customer can switch devices → session recovered by customer_id
4. Customer completes booking → creates booking_groups + booking_appointments
5. Session deleted after successful booking
```

#### Scenario 3: Guest Logs In During Booking

```
1. Guest starts booking → session exists with guest data
2. Guest logs in during process → session converted to customer session
3. Guest data preserved, customer_id added to session
4. Continue booking as logged-in customer
```

---

## Implementation Guide

### 1. Enhanced BookingSession Model

```java
package model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.math.BigDecimal;

public class BookingSession {
    private String sessionId;
    private Integer customerId;
    private String guestIdentifier;
    private String guestEmail;
    private String guestPhone;
    private String guestName;
    private BookingSessionData sessionData;
    private SessionStep currentStep;
    private SessionType sessionType;
    private LocalDateTime expiresAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public enum SessionStep {
        SERVICES, THERAPISTS, TIME, PAYMENT, GUEST_INFO
    }

    public enum SessionType {
        GUEST, CUSTOMER
    }

    // Getters and setters...

    public boolean isExpired() {
        return expiresAt.isBefore(LocalDateTime.now());
    }

    public boolean isComplete() {
        return sessionData != null &&
               sessionData.getSelectedServices() != null &&
               !sessionData.getSelectedServices().isEmpty() &&
               sessionData.getSelectedDate() != null &&
               (sessionType == SessionType.CUSTOMER || sessionData.getGuestInfo() != null);
    }
}

public class BookingSessionData {
    private List<ServiceSelection> selectedServices;
    private LocalDate selectedDate;
    private String paymentMethod;
    private BigDecimal totalAmount = BigDecimal.ZERO;
    private int totalDurationMinutes = 0;
    private String specialNotes;
    private GuestInfo guestInfo;

    public static class ServiceSelection {
        private int serviceId;
        private String serviceName;
        private Integer therapistUserId;
        private String therapistName;
        private BigDecimal estimatedPrice;
        private int estimatedDuration;
        private LocalDateTime scheduledTime;
        private int serviceOrder;

        // Getters and setters...
    }

    public static class GuestInfo {
        private String name;
        private String email;
        private String phone;
        private String address;

        // Getters and setters...
    }

    // Getters and setters...
}
```

### 2. BookingSessionDAO

```java
package dao;

import model.BookingSession;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.Optional;

public class BookingSessionDAO {

    private Gson gson = new Gson();

    public BookingSession save(BookingSession session) {
        String sql = "INSERT INTO booking_sessions (session_id, customer_id, guest_identifier, " +
                    "guest_email, guest_phone, guest_name, session_data, current_step, " +
                    "session_type, expires_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, session.getSessionId());
            ps.setObject(2, session.getCustomerId());
            ps.setString(3, session.getGuestIdentifier());
            ps.setString(4, session.getGuestEmail());
            ps.setString(5, session.getGuestPhone());
            ps.setString(6, session.getGuestName());
            ps.setString(7, gson.toJson(session.getSessionData()));
            ps.setString(8, session.getCurrentStep().name().toLowerCase());
            ps.setString(9, session.getSessionType().name().toLowerCase());
            ps.setTimestamp(10, Timestamp.valueOf(session.getExpiresAt()));

            ps.executeUpdate();
            return session;

        } catch (SQLException e) {
            throw new RuntimeException("Error saving booking session", e);
        }
    }

    public BookingSession update(BookingSession session) {
        String sql = "UPDATE booking_sessions SET customer_id = ?, guest_email = ?, " +
                    "guest_phone = ?, guest_name = ?, session_data = ?, current_step = ?, " +
                    "session_type = ?, updated_at = CURRENT_TIMESTAMP WHERE session_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setObject(1, session.getCustomerId());
            ps.setString(2, session.getGuestEmail());
            ps.setString(3, session.getGuestPhone());
            ps.setString(4, session.getGuestName());
            ps.setString(5, gson.toJson(session.getSessionData()));
            ps.setString(6, session.getCurrentStep().name().toLowerCase());
            ps.setString(7, session.getSessionType().name().toLowerCase());
            ps.setString(8, session.getSessionId());

            ps.executeUpdate();
            return session;

        } catch (SQLException e) {
            throw new RuntimeException("Error updating booking session", e);
        }
    }

    public Optional<BookingSession> findBySessionId(String sessionId) {
        String sql = "SELECT * FROM booking_sessions WHERE session_id = ? AND expires_at > NOW()";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, sessionId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return Optional.of(mapResultSetToBookingSession(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error finding booking session", e);
        }

        return Optional.empty();
    }

    public Optional<BookingSession> findActiveByCustomerId(Integer customerId) {
        String sql = "SELECT * FROM booking_sessions WHERE customer_id = ? " +
                    "AND session_type = 'customer' AND expires_at > NOW() " +
                    "ORDER BY updated_at DESC LIMIT 1";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return Optional.of(mapResultSetToBookingSession(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error finding customer session", e);
        }

        return Optional.empty();
    }

    public Optional<BookingSession> findActiveByGuestIdentifier(String guestIdentifier) {
        String sql = "SELECT * FROM booking_sessions WHERE guest_identifier = ? " +
                    "AND session_type = 'guest' AND expires_at > NOW() " +
                    "ORDER BY updated_at DESC LIMIT 1";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, guestIdentifier);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return Optional.of(mapResultSetToBookingSession(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error finding guest session", e);
        }

        return Optional.empty();
    }

    public void delete(String sessionId) {
        String sql = "DELETE FROM booking_sessions WHERE session_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, sessionId);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Error deleting booking session", e);
        }
    }

    public int cleanupExpiredSessions() {
        String sql = "DELETE FROM booking_sessions WHERE expires_at < NOW()";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            return ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Error cleaning up expired sessions", e);
        }
    }

    private BookingSession mapResultSetToBookingSession(ResultSet rs) throws SQLException {
        BookingSession session = new BookingSession();
        session.setSessionId(rs.getString("session_id"));
        session.setCustomerId(rs.getObject("customer_id", Integer.class));
        session.setGuestIdentifier(rs.getString("guest_identifier"));
        session.setGuestEmail(rs.getString("guest_email"));
        session.setGuestPhone(rs.getString("guest_phone"));
        session.setGuestName(rs.getString("guest_name"));

        // Parse JSON session data
        String sessionDataJson = rs.getString("session_data");
        BookingSessionData sessionData = gson.fromJson(sessionDataJson, BookingSessionData.class);
        session.setSessionData(sessionData);

        session.setCurrentStep(BookingSession.SessionStep.valueOf(rs.getString("current_step").toUpperCase()));
        session.setSessionType(BookingSession.SessionType.valueOf(rs.getString("session_type").toUpperCase()));
        session.setExpiresAt(rs.getTimestamp("expires_at").toLocalDateTime());
        session.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        session.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());

        return session;
    }
}
```

### 3. BookingSessionService

```java
package service;

import model.BookingSession;
import model.Customer;
import model.BookingSessionData;
import dao.BookingSessionDAO;
import dao.CustomerDAO;
import jakarta.servlet.http.HttpServletRequest;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
public class BookingSessionService {

    private BookingSessionDAO sessionDAO;
    private CustomerDAO customerDAO;

    public BookingSessionService() {
        this.sessionDAO = new BookingSessionDAO();
        this.customerDAO = new CustomerDAO();
    }

    public BookingSession createOrGetSession(HttpServletRequest request) {
        String browserSessionId = request.getSession().getId();
        Customer customer = (Customer) request.getSession().getAttribute("customer");

        BookingSession existingSession = null;

        if (customer != null) {
            // Logged-in customer: try to find existing session by customer_id
            existingSession = sessionDAO.findActiveByCustomerId(customer.getCustomerId()).orElse(null);

            if (existingSession == null) {
                // Check if there's a guest session that should be converted
                BookingSession guestSession = sessionDAO.findActiveByGuestIdentifier(browserSessionId).orElse(null);
                if (guestSession != null) {
                    // Convert guest session to customer session
                    existingSession = convertGuestToCustomerSession(guestSession, customer);
                }
            }
        } else {
            // Guest user: find by browser session ID
            existingSession = sessionDAO.findActiveByGuestIdentifier(browserSessionId).orElse(null);
        }

        if (existingSession == null) {
            // Create new session
            existingSession = createNewSession(browserSessionId, customer);
        }

        return existingSession;
    }

    public BookingSession saveSessionProgress(String sessionId, BookingSessionData sessionData,
                                            BookingSession.SessionStep currentStep) {
        BookingSession session = sessionDAO.findBySessionId(sessionId)
                                          .orElseThrow(() -> new RuntimeException("Session not found"));

        session.setSessionData(sessionData);
        session.setCurrentStep(currentStep);

        return sessionDAO.update(session);
    }

    public BookingSession convertGuestToCustomerSession(BookingSession guestSession, Customer customer) {
        guestSession.setCustomerId(customer.getCustomerId());
        guestSession.setSessionType(BookingSession.SessionType.CUSTOMER);
        guestSession.setGuestIdentifier(null); // Clear guest identifier

        return sessionDAO.update(guestSession);
    }

    public void deleteSession(String sessionId) {
        sessionDAO.delete(sessionId);
    }

    public int cleanupExpiredSessions() {
        return sessionDAO.cleanupExpiredSessions();
    }

    private BookingSession createNewSession(String browserSessionId, Customer customer) {
        BookingSession session = new BookingSession();
        session.setSessionId(generateSessionId());
        session.setSessionData(new BookingSessionData());
        session.setCurrentStep(BookingSession.SessionStep.SERVICES);

        if (customer != null) {
            session.setCustomerId(customer.getCustomerId());
            session.setSessionType(BookingSession.SessionType.CUSTOMER);
        } else {
            session.setGuestIdentifier(browserSessionId);
            session.setSessionType(BookingSession.SessionType.GUEST);
        }

        session.setExpiresAt(calculateExpiryTime());

        return sessionDAO.save(session);
    }

    private String generateSessionId() {
        return "booking_" + System.currentTimeMillis() + "_" + UUID.randomUUID().toString().substring(0, 8);
    }

    private LocalDateTime calculateExpiryTime() {
        return LocalDateTime.now().plusHours(2); // Sessions expire after 2 hours
    }
}
```

### 4. Enhanced BookingController

```java
package controller;

import service.BookingSessionService;
import model.BookingSession;
import model.BookingSessionData;
import model.Customer;
import com.google.gson.Gson;

@WebServlet(name = "BookingController", urlPatterns = { "/process-booking/*" })
public class BookingController extends HttpServlet {

    private BookingSessionService sessionService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        sessionService = new BookingSessionService();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get or create booking session
        BookingSession session = sessionService.createOrGetSession(request);
        request.getSession().setAttribute("bookingSession", session);

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) pathInfo = "/services";

        switch (pathInfo) {
            case "/services":
            case "/service-selection":
                handleServiceSelection(request, response, session);
                break;
            case "/therapist-selection":
                handleTherapistSelection(request, response, session);
                break;
            case "/time-selection":
                handleTimeSelection(request, response, session);
                break;
            case "/guest-info":
                handleGuestInfo(request, response, session);
                break;
            case "/payment":
                handlePayment(request, response, session);
                break;
            case "/confirmation":
                handleConfirmation(request, response, session);
                break;
            default:
                handleServiceSelection(request, response, session);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        switch (pathInfo) {
            case "/save-services":
                saveSelectedServices(request, response);
                break;
            case "/save-therapists":
                saveSelectedTherapists(request, response);
                break;
            case "/save-time":
                saveSelectedTime(request, response);
                break;
            case "/save-guest-info":
                saveGuestInfo(request, response);
                break;
            case "/finalize-booking":
                finalizeBooking(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    private void handleServiceSelection(HttpServletRequest request, HttpServletResponse response,
                                      BookingSession session) throws ServletException, IOException {

        // Load session data if exists
        if (session.getSessionData() != null &&
            session.getSessionData().getSelectedServices() != null) {
            request.setAttribute("selectedServices", session.getSessionData().getSelectedServices());
        }

        request.setAttribute("bookingSession", session);
        request.getRequestDispatcher("/WEB-INF/view/customer/appointments/services-selection.jsp")
               .forward(request, response);
    }

    private void handleGuestInfo(HttpServletRequest request, HttpServletResponse response,
                               BookingSession session) throws ServletException, IOException {

        if (session.getSessionType() == BookingSession.SessionType.CUSTOMER) {
            // Logged-in customer, skip guest info
            response.sendRedirect(request.getContextPath() + "/process-booking/payment");
            return;
        }

        // Validate that services and time are selected
        if (!isBookingReadyForGuestInfo(session)) {
            response.sendRedirect(request.getContextPath() + "/process-booking/services");
            return;
        }

        request.setAttribute("bookingSession", session);
        request.getRequestDispatcher("/WEB-INF/view/customer/appointments/guest-info.jsp")
               .forward(request, response);
    }

    private void saveSelectedServices(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BookingSession session = (BookingSession) request.getSession().getAttribute("bookingSession");

        // Get selected service IDs
        String[] serviceIds = request.getParameterValues("serviceIds");

        if (serviceIds == null || serviceIds.length == 0) {
            sendJsonResponse(response, false, "No services selected");
            return;
        }

        try {
            // Create service selections
            List<BookingSessionData.ServiceSelection> selectedServices = new ArrayList<>();

            for (int i = 0; i < serviceIds.length; i++) {
                String serviceId = serviceIds[i];
                Service service = serviceDAO.findById(Integer.parseInt(serviceId)).orElse(null);

                if (service != null) {
                    BookingSessionData.ServiceSelection selection = new BookingSessionData.ServiceSelection();
                    selection.setServiceId(service.getServiceId());
                    selection.setServiceName(service.getName());
                    selection.setEstimatedPrice(service.getPrice());
                    selection.setEstimatedDuration(service.getDurationMinutes());
                    selection.setServiceOrder(i + 1);

                    selectedServices.add(selection);
                }
            }

            // Update session data
            BookingSessionData sessionData = session.getSessionData();
            if (sessionData == null) {
                sessionData = new BookingSessionData();
            }
            sessionData.setSelectedServices(selectedServices);
            sessionData.calculateTotals();

            // Save to database
            sessionService.saveSessionProgress(session.getSessionId(), sessionData,
                                             BookingSession.SessionStep.THERAPISTS);

            sendJsonResponse(response, true, "Services saved successfully");

        } catch (Exception e) {
            sendJsonResponse(response, false, "Error saving services: " + e.getMessage());
        }
    }

    private void saveGuestInfo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BookingSession session = (BookingSession) request.getSession().getAttribute("bookingSession");

        if (session.getSessionType() != BookingSession.SessionType.GUEST) {
            sendJsonResponse(response, false, "Not a guest session");
            return;
        }

        // Extract guest info from request
        String guestName = request.getParameter("guestName");
        String guestEmail = request.getParameter("guestEmail");
        String guestPhone = request.getParameter("guestPhone");
        String guestAddress = request.getParameter("guestAddress");

        // Validate required fields
        if (guestName == null || guestEmail == null || guestPhone == null) {
            sendJsonResponse(response, false, "Name, email, and phone are required");
            return;
        }

        // Update session with guest info
        BookingSessionData sessionData = session.getSessionData();
        BookingSessionData.GuestInfo guestInfo = new BookingSessionData.GuestInfo();
        guestInfo.setName(guestName);
        guestInfo.setEmail(guestEmail);
        guestInfo.setPhone(guestPhone);
        guestInfo.setAddress(guestAddress);
        sessionData.setGuestInfo(guestInfo);

        // Update session record
        session.setGuestEmail(guestEmail);
        session.setGuestName(guestName);
        session.setGuestPhone(guestPhone);

        // Save to database
        sessionService.saveSessionProgress(session.getSessionId(), sessionData,
                                         BookingSession.SessionStep.PAYMENT);

        sendJsonResponse(response, true, "Guest information saved");
    }

    private void finalizeBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BookingSession session = (BookingSession) request.getSession().getAttribute("bookingSession");

        if (!session.isComplete()) {
            sendJsonResponse(response, false, "Incomplete booking session");
            return;
        }

        try {
            Customer customer;

            if (session.getSessionType() == BookingSession.SessionType.GUEST) {
                // Create customer record for guest
                customer = createCustomerFromGuestInfo(session);
            } else {
                // Get existing customer
                customer = customerDAO.findById(session.getCustomerId()).orElse(null);
                if (customer == null) {
                    sendJsonResponse(response, false, "Customer not found");
                    return;
                }
            }

            // Create final booking
            BookingGroup bookingGroup = createBookingGroup(session, customer);
            createBookingAppointments(session, bookingGroup);

            // Clean up session
            sessionService.deleteSession(session.getSessionId());

            sendJsonResponse(response, true, "Booking confirmed successfully",
                           Map.of("bookingGroupId", bookingGroup.getBookingGroupId()));

        } catch (Exception e) {
            sendJsonResponse(response, false, "Error finalizing booking: " + e.getMessage());
        }
    }

    private Customer createCustomerFromGuestInfo(BookingSession session) {
        BookingSessionData.GuestInfo guestInfo = session.getSessionData().getGuestInfo();

        Customer customer = new Customer();
        customer.setFullName(guestInfo.getName());
        customer.setEmail(guestInfo.getEmail());
        customer.setPhoneNumber(guestInfo.getPhone());
        customer.setRegistrationDate(LocalDateTime.now());
        customer.setStatus("ACTIVE");

        return customerDAO.save(customer);
    }

    private BookingGroup createBookingGroup(BookingSession session, Customer customer) {
        BookingSessionData sessionData = session.getSessionData();

        BookingGroup group = new BookingGroup();
        group.setCustomerId(customer.getCustomerId());
        group.setBookingDate(sessionData.getSelectedDate());
        group.setTotalAmount(sessionData.getTotalAmount());
        group.setPaymentStatus("PAID");
        group.setBookingStatus("CONFIRMED");
        group.setPaymentMethod(sessionData.getPaymentMethod());
        group.setSpecialNotes(sessionData.getSpecialNotes());

        return bookingGroupDAO.save(group);
    }

    private void createBookingAppointments(BookingSession session, BookingGroup bookingGroup) {
        BookingSessionData sessionData = session.getSessionData();

        for (BookingSessionData.ServiceSelection serviceSelection : sessionData.getSelectedServices()) {
            BookingAppointment appointment = new BookingAppointment();
            appointment.setBookingGroupId(bookingGroup.getBookingGroupId());
            appointment.setServiceId(serviceSelection.getServiceId());
            appointment.setTherapistUserId(serviceSelection.getTherapistUserId());
            appointment.setStartTime(serviceSelection.getScheduledTime());
            appointment.setEndTime(serviceSelection.getScheduledTime().plusMinutes(serviceSelection.getEstimatedDuration()));
            appointment.setServicePrice(serviceSelection.getEstimatedPrice());
            appointment.setAppointmentOrder(serviceSelection.getServiceOrder());
            appointment.setStatus("SCHEDULED");

            bookingAppointmentDAO.save(appointment);
        }
    }

    private boolean isBookingReadyForGuestInfo(BookingSession session) {
        BookingSessionData sessionData = session.getSessionData();
        return sessionData != null &&
               sessionData.getSelectedServices() != null &&
               !sessionData.getSelectedServices().isEmpty() &&
               sessionData.getSelectedDate() != null;
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message)
            throws IOException {
        sendJsonResponse(response, success, message, null);
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message,
                                Map<String, Object> additionalData) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("success", success);
        jsonResponse.put("message", message);

        if (additionalData != null) {
            jsonResponse.putAll(additionalData);
        }

        response.getWriter().write(gson.toJson(jsonResponse));
    }
}
```

---

## Guest vs Customer Flows

### Guest User Flow

```
1. Visit spa website (not logged in)
   ↓
2. Start booking process
   ↓
3. Select services → Save to booking_sessions (guest session)
   ↓
4. Select therapists → Update session JSON
   ↓
5. Select date/time → Update session JSON
   ↓
6. Guest info form → Collect name, email, phone
   ↓
7. Payment page → Process payment
   ↓
8. Create customer record → Create booking_groups → Create booking_appointments
   ↓
9. Confirmation page → Send confirmation email
   ↓
10. Clean up booking_sessions record
```

### Customer User Flow

```
1. Visit spa website (logged in)
   ↓
2. Start booking process
   ↓
3. Select services → Save to booking_sessions (customer session)
   ↓
4. Select therapists → Update session JSON
   ↓
5. Select date/time → Update session JSON
   ↓
6. Payment page → Process payment (skip guest info)
   ↓
7. Create booking_groups → Create booking_appointments
   ↓
8. Confirmation page → Send confirmation email
   ↓
9. Clean up booking_sessions record
```

### Guest Login During Booking Flow

```
1. Guest starts booking → Guest session created
   ↓
2. Guest selects services → Session updated
   ↓
3. Guest decides to login → Authentication
   ↓
4. Convert guest session to customer session
   ↓
5. Continue booking as customer (skip guest info)
   ↓
6. Complete booking normally
```

---

## Best Practices

### Session Security

```java
// 1. Always validate session ownership
public boolean validateSessionOwnership(BookingSession session, HttpServletRequest request) {
    Customer customer = (Customer) request.getSession().getAttribute("customer");

    if (session.getSessionType() == BookingSession.SessionType.CUSTOMER) {
        return customer != null && customer.getCustomerId().equals(session.getCustomerId());
    } else {
        String browserSessionId = request.getSession().getId();
        return browserSessionId.equals(session.getGuestIdentifier());
    }
}

// 2. Sanitize guest input
public BookingSessionData.GuestInfo sanitizeGuestInfo(String name, String email, String phone) {
    BookingSessionData.GuestInfo guestInfo = new BookingSessionData.GuestInfo();
    guestInfo.setName(StringUtils.trim(StringUtils.substring(name, 0, 100)));
    guestInfo.setEmail(EmailValidator.validate(email));
    guestInfo.setPhone(PhoneValidator.validate(phone));
    return guestInfo;
}
```

### Performance Optimization

```java
// 1. Index optimization for session queries
CREATE INDEX idx_customer_active_sessions ON booking_sessions(customer_id, session_type, expires_at);
CREATE INDEX idx_guest_active_sessions ON booking_sessions(guest_identifier, session_type, expires_at);

// 2. Connection pooling for high concurrency
@Component
public class BookingSessionDAO {
    @Autowired
    private DataSource dataSource; // Use connection pooling

    // Use try-with-resources for automatic connection management
}

// 3. JSON data compression for large session data
public String compressSessionData(BookingSessionData sessionData) {
    String json = gson.toJson(sessionData);
    return CompressionUtils.compress(json);
}
```

### Session Cleanup Strategy

```java
// 1. Scheduled cleanup task
@Scheduled(fixedRate = 3600000) // Run every hour
public void cleanupExpiredSessions() {
    int deletedCount = sessionService.cleanupExpiredSessions();
    LOGGER.info("Cleaned up {} expired booking sessions", deletedCount);
}

// 2. Cleanup old completed sessions
@Scheduled(cron = "0 0 2 * * ?") // Run daily at 2 AM
public void cleanupOldCompletedSessions() {
    String sql = "DELETE FROM booking_sessions WHERE " +
                "created_at < DATE_SUB(NOW(), INTERVAL 7 DAY) AND " +
                "session_id IN (SELECT DISTINCT converted_session_id FROM booking_groups " +
                "WHERE converted_session_id IS NOT NULL)";
    // Execute cleanup...
}
```

### Error Handling

```java
// 1. Graceful session recovery
public BookingSession recoverOrCreateSession(HttpServletRequest request) {
    try {
        return sessionService.createOrGetSession(request);
    } catch (Exception e) {
        LOGGER.warn("Failed to recover session, creating new one", e);
        return sessionService.createNewSession(request.getSession().getId(), null);
    }
}

// 2. Partial data recovery
public void handlePartialDataLoss(BookingSession session) {
    BookingSessionData sessionData = session.getSessionData();

    if (sessionData.getSelectedServices() == null) {
        sessionData.setSelectedServices(new ArrayList<>());
    }

    if (sessionData.getTotalAmount() == null) {
        sessionData.calculateTotals();
    }
}
```

---

## Troubleshooting

### Common Issues

#### 1. Session Not Found

```java
// Problem: Session expires or gets deleted
// Solution: Graceful fallback to new session
if (session == null || session.isExpired()) {
    session = sessionService.createNewSession(browserSessionId, customer);
    request.getSession().setAttribute("bookingSession", session);
}
```

#### 2. Cross-Device Session Recovery Not Working

```sql
-- Problem: Multiple active sessions for same customer
-- Solution: Cleanup old sessions when creating new one
DELETE FROM booking_sessions
WHERE customer_id = ? AND session_id != ? AND session_type = 'customer';
```

#### 3. Guest Session Data Loss

```java
// Problem: Browser session changes, guest loses data
// Solution: Use browser fingerprinting as fallback
String guestIdentifier = request.getSession().getId() + "_" +
                        request.getHeader("User-Agent").hashCode();
```

#### 4. JSON Parsing Errors

```java
// Problem: Corrupted JSON in session_data
// Solution: Validate and recover
try {
    BookingSessionData sessionData = gson.fromJson(jsonString, BookingSessionData.class);
    return sessionData;
} catch (JsonSyntaxException e) {
    LOGGER.warn("Corrupted session data, creating new: {}", e.getMessage());
    return new BookingSessionData();
}
```

### Monitoring and Analytics

```sql
-- Monitor session conversion rates
SELECT
    session_type,
    COUNT(*) as total_sessions,
    COUNT(CASE WHEN EXISTS(SELECT 1 FROM booking_groups WHERE converted_session_id = bs.session_id) THEN 1 END) as converted_sessions,
    (COUNT(CASE WHEN EXISTS(SELECT 1 FROM booking_groups WHERE converted_session_id = bs.session_id) THEN 1 END) * 100.0 / COUNT(*)) as conversion_rate
FROM booking_sessions bs
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY session_type;

-- Monitor session abandonment by step
SELECT
    current_step,
    COUNT(*) as abandoned_sessions,
    AVG(TIMESTAMPDIFF(MINUTE, created_at, expires_at)) as avg_session_duration
FROM booking_sessions
WHERE expires_at < NOW()
AND NOT EXISTS(SELECT 1 FROM booking_groups WHERE converted_session_id = booking_sessions.session_id)
GROUP BY current_step;
```

---

## Summary

This booking session architecture provides:

✅ **Robust session persistence** across browser crashes and page reloads  
✅ **Support for both guest and customer** booking flows  
✅ **Multi-device session recovery** for logged-in customers  
✅ **Clean separation** between temporary process data and permanent bookings  
✅ **Scalable JSON-based** session data storage  
✅ **Automatic cleanup** of expired sessions  
✅ **Seamless guest-to-customer** session conversion  
✅ **Multiple service booking** support with proper data structure

The two-layer approach ensures excellent user experience while maintaining clean business data and system performance.
