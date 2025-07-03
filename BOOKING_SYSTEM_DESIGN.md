# Beauty Service Booking System Design

## Table of Contents

- [Overview](#overview)
- [Booking Process Flow](#booking-process-flow)
- [Database Design](#database-design)
- [Concurrency Handling](#concurrency-handling)
- [Implementation Details](#implementation-details)
- [User Experience Guidelines](#user-experience-guidelines)

## Overview

This document outlines the design of a booking system for a beauty service website using Java Servlets/JSP. The system handles the entire booking process from service selection to payment confirmation while managing concurrency and providing a smooth user experience.

## Booking Process Flow

### 1. Service Selection & Cart

1. Customer browses available services
2. Views service details (duration, price, description)
3. Selects desired services
4. Adds services to cart
5. Can modify cart (add/remove services)

### 2. Appointment Scheduling

1. Customer selects preferred date
2. System shows available time slots based on:
   - Service duration
   - Therapist availability
   - Business hours
3. Customer selects preferred time slot
4. System holds the slot temporarily (15 minutes)

### 3. Therapist Assignment

1. System shows available therapists for selected services
2. Customer can choose specific therapist or let system assign
3. System verifies therapist availability
4. Temporary hold on therapist's time slot

### 4. Customer Details

1. Customer logs in or provides contact information
2. Enters any special requests/notes
3. Reviews booking summary

### 5. Payment Processing

1. Shows total amount with breakdown
2. Customer selects payment method
3. Processes payment
4. Confirms booking upon successful payment

### 6. Confirmation

1. Generates booking confirmation
2. Sends email confirmation
3. Creates calendar invite
4. Shows booking in customer's account

## Database Design

### Entity Relationship Diagram

```sql
-- Core Tables
CREATE TABLE services (
    service_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    description TEXT,
    duration INT,  -- in minutes
    price DECIMAL(10,2),
    active BOOLEAN DEFAULT true
);

CREATE TABLE therapists (
    therapist_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    specialties TEXT,
    working_hours JSON,  -- stores weekly schedule
    active BOOLEAN DEFAULT true
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    password_hash VARCHAR(255)
);

-- Booking Related Tables
CREATE TABLE booking_sessions (
    session_id VARCHAR(36) PRIMARY KEY,  -- UUID
    customer_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    status ENUM('active', 'completed', 'expired'),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE cart_items (
    cart_id INT PRIMARY KEY AUTO_INCREMENT,
    session_id VARCHAR(36),
    service_id INT,
    quantity INT DEFAULT 1,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id) REFERENCES booking_sessions(session_id),
    FOREIGN KEY (service_id) REFERENCES services(service_id)
);

CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    therapist_id INT,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    status ENUM('pending', 'confirmed', 'completed', 'cancelled'),
    total_amount DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (therapist_id) REFERENCES therapists(therapist_id)
);

CREATE TABLE appointment_services (
    appointment_id INT,
    service_id INT,
    price_at_booking DECIMAL(10,2),
    PRIMARY KEY (appointment_id, service_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id),
    FOREIGN KEY (service_id) REFERENCES services(service_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    appointment_id INT,
    amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    status ENUM('pending', 'completed', 'failed'),
    transaction_id VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

-- Concurrency Control Tables
CREATE TABLE time_slots (
    slot_id INT PRIMARY KEY AUTO_INCREMENT,
    therapist_id INT,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    status ENUM('available', 'held', 'booked'),
    held_by VARCHAR(36),  -- session_id
    held_until TIMESTAMP,
    FOREIGN KEY (therapist_id) REFERENCES therapists(therapist_id),
    UNIQUE KEY unique_therapist_slot (therapist_id, start_time, end_time)
);
```

## Concurrency Handling

### 1. Pessimistic Locking Strategy

```java
@Transaction(isolation = Connection.TRANSACTION_SERIALIZABLE)
public boolean holdTimeSlot(int therapistId, LocalDateTime startTime, LocalDateTime endTime, String sessionId) {
    // Check if slot is available
    String checkSql = """
        SELECT status
        FROM time_slots
        WHERE therapist_id = ?
        AND start_time = ?
        AND end_time = ?
        FOR UPDATE
        """;

    // Update slot if available
    String updateSql = """
        UPDATE time_slots
        SET status = 'held',
            held_by = ?,
            held_until = NOW() + INTERVAL 15 MINUTE
        WHERE therapist_id = ?
        AND start_time = ?
        AND end_time = ?
        AND status = 'available'
        """;

    try (Connection conn = getConnection()) {
        conn.setAutoCommit(false);

        try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
            checkStmt.setInt(1, therapistId);
            checkStmt.setTimestamp(2, Timestamp.valueOf(startTime));
            checkStmt.setTimestamp(3, Timestamp.valueOf(endTime));

            ResultSet rs = checkStmt.executeQuery();
            if (!rs.next() || !"available".equals(rs.getString("status"))) {
                conn.rollback();
                return false;
            }

            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setString(1, sessionId);
                updateStmt.setInt(2, therapistId);
                updateStmt.setTimestamp(3, Timestamp.valueOf(startTime));
                updateStmt.setTimestamp(4, Timestamp.valueOf(endTime));

                int updated = updateStmt.executeUpdate();
                if (updated == 1) {
                    conn.commit();
                    return true;
                }
                conn.rollback();
                return false;
            }
        }
    }
}
```

### 2. Automatic Slot Release

```java
@Scheduled(fixedRate = 60000)  // Run every minute
public void releaseExpiredHolds() {
    String sql = """
        UPDATE time_slots
        SET status = 'available',
            held_by = NULL,
            held_until = NULL
        WHERE status = 'held'
        AND held_until < NOW()
        """;

    try (Connection conn = getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.executeUpdate();
    }
}
```

## Implementation Details

### 1. Shopping Cart Management

```java
@WebServlet("/api/cart")
public class CartApiServlet extends HttpServlet {
    private final BookingSessionService bookingService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        String sessionId = getOrCreateBookingSession(req);
        CartItem item = parseCartItem(req);

        try {
            // Validate service availability
            if (!bookingService.isServiceAvailable(item.getServiceId())) {
                sendError(resp, "Service not available");
                return;
            }

            // Add to cart
            bookingService.addToCart(sessionId, item);

            // Return updated cart
            Cart cart = bookingService.getCart(sessionId);
            sendJsonResponse(resp, cart);

        } catch (Exception e) {
            sendError(resp, "Failed to add item to cart");
        }
    }
}
```

### 2. Booking Confirmation

```java
@Transactional
public Appointment confirmBooking(String sessionId) {
    BookingSession session = getSession(sessionId);
    if (session == null || session.isExpired()) {
        throw new BookingException("Invalid or expired session");
    }

    // 1. Validate all services are still available
    validateServices(session.getCartItems());

    // 2. Verify therapist availability
    verifyTherapistAvailability(session.getTherapistId(),
                              session.getStartTime(),
                              session.getEndTime());

    // 3. Create appointment
    Appointment appointment = createAppointment(session);

    // 4. Process payment
    Payment payment = processPayment(session, appointment);

    if (payment.isSuccessful()) {
        // 5. Confirm booking
        appointment.setStatus(AppointmentStatus.CONFIRMED);
        appointmentDAO.update(appointment);

        // 6. Send confirmation
        sendConfirmationEmail(appointment);

        // 7. Clear session
        session.complete();

        return appointment;
    } else {
        throw new PaymentException("Payment failed");
    }
}
```

### 3. Payment Integration (VNPay Example)

```java
public class VNPayService {
    private static final String VNP_VERSION = "2.1.0";
    private static final String VNP_COMMAND = "pay";

    public String createPaymentUrl(Appointment appointment, String returnUrl) {
        String vnp_TxnRef = String.valueOf(appointment.getId());
        String vnp_IpAddr = request.getRemoteAddr();
        String vnp_TmnCode = ConfigLoader.getVNPayTmnCode();

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", VNP_VERSION);
        vnp_Params.put("vnp_Command", VNP_COMMAND);
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang:" + vnp_TxnRef);
        vnp_Params.put("vnp_ReturnUrl", returnUrl);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);
        vnp_Params.put("vnp_CreateDate", generateCreateDate());

        String signData = String.join("|", vnp_Params.values());
        String vnp_SecureHash = hmacSHA512(ConfigLoader.getVNPayHashSecret(), signData);

        vnp_Params.put("vnp_SecureHash", vnp_SecureHash);

        return buildQueryUrl(ConfigLoader.getVNPayUrl(), vnp_Params);
    }
}
```

## User Experience Guidelines

### 1. Clear Progress Indication

- Show booking steps progress bar
- Highlight current step
- Enable step navigation for editing

### 2. Real-time Feedback

- Show service availability instantly
- Update cart totals immediately
- Display time slot conflicts clearly

### 3. Helpful Validation

- Validate date/time selection
- Show clear error messages
- Suggest alternatives when slots unavailable

### 4. Mobile-Friendly Design

- Touch-friendly buttons
- Responsive calendar
- Easy form filling

### 5. Booking Summary

- Show clear price breakdown
- Display appointment details
- List selected services

### 6. Confirmation & Follow-up

- Send immediate confirmation
- Provide booking reference
- Enable easy cancellation/modification

### 7. Loading States

- Show progress indicators
- Disable submit during processing
- Provide feedback on actions

## Implementation Tips

1. Use WebSocket for real-time availability updates
2. Implement request throttling for API endpoints
3. Cache frequently accessed data (services, therapists)
4. Log all booking attempts for debugging
5. Implement retry mechanism for payment processing
6. Use prepared statements for all database queries
7. Regular cleanup of expired sessions
8. Implement proper error handling and recovery

## Security Considerations

1. Validate all user inputs
2. Use CSRF tokens for forms
3. Implement rate limiting
4. Secure payment information
5. Encrypt sensitive data
6. Use secure session management
7. Implement proper access control

## Monitoring & Maintenance

1. Log booking failures
2. Monitor session expiry
3. Track payment success rates
4. Monitor database performance
5. Regular backup of booking data
6. Audit trail of changes
7. Monitor system resources
