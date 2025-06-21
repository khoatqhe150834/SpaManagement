# Booking Session Implementation Guide

## Overview

This guide provides step-by-step instructions for implementing the complete booking session functionality in your spa management system.

## 📋 Prerequisites

### 1. Database Setup

Ensure your database has the `booking_sessions` table:

```sql
CREATE TABLE `booking_sessions` (
  `session_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_id` int DEFAULT NULL,
  `session_data` json NOT NULL,
  `current_step` enum('SERVICES','THERAPISTS','TIME','REGISTRATION','PAYMENT') COLLATE utf8mb4_unicode_ci DEFAULT 'SERVICES',
  `expires_at` timestamp NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (`session_id`),
  KEY `idx_customer_id` (`customer_id`),
  KEY `idx_expires_at` (`expires_at`),
  CONSTRAINT `booking_sessions_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 2. Required Dependencies

Add these dependencies to your `pom.xml` or build system:

```xml
<!-- Jackson for JSON processing -->
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.15.2</version>
</dependency>
<dependency>
    <groupId>com.fasterxml.jackson.datatype</groupId>
    <artifactId>jackson-datatype-jsr310</artifactId>
    <version>2.15.2</version>
</dependency>
```

## 🚀 Implementation Steps

### Step 1: Core Components Setup

The following files have been created for you:

1. **`model/BookingSession.java`** - Core model with JSON serialization
2. **`dao/BookingSessionDAO.java`** - Database operations
3. **`service/BookingSessionService.java`** - Business logic layer

### Step 2: Integration with Existing Controllers

#### Option A: Enhance Existing BookingController

Add booking session support to your existing `BookingController.java`:

```java
// Add to your existing imports
import service.BookingSessionService;
import model.BookingSession;

// Add to your existing fields
private BookingSessionService bookingSessionService;

// Add to your init() method
bookingSessionService = new BookingSessionService();

// Update your service selection method
private void saveSelectedServices(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    BookingSession session = bookingSessionService.getOrCreateSession(request);

    // Parse service IDs from request
    String serviceIdsParam = request.getParameter("serviceIds");
    // ... existing logic to convert to Service objects

    // Save to session
    boolean success = bookingSessionService.addServicesToSession(session, selectedServices);

    if (success) {
        // Success response
        response.getWriter().write("{\"success\": true, \"nextStep\": \"/process-booking/therapists\"}");
    } else {
        // Error response
        response.getWriter().write("{\"success\": false, \"message\": \"Failed to save services\"}");
    }
}
```

#### Option B: Use the New EnhancedBookingController

Use the provided `EnhancedBookingController.java` which has complete integration.

### Step 3: Frontend Integration

#### Update your service selection JavaScript:

```javascript
// In your services-selection.js file
function saveSelectedServices() {
  const selectedServices = getSelectedServiceIds(); // Your existing method

  fetch("/booking/services", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: new URLSearchParams({
      serviceIds: selectedServices.join(","),
    }),
  })
    .then((response) => response.json())
    .then((data) => {
      if (data.success) {
        // Redirect to next step
        window.location.href = data.nextStep;
      } else {
        alert("Error: " + data.message);
      }
    })
    .catch((error) => {
      console.error("Error:", error);
      alert("An error occurred while saving services");
    });
}
```

### Step 4: Registration Integration

#### Update RegisterController to handle booking sessions:

```java
// In your RegisterController
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    // ... existing registration logic

    // After successful registration, check for booking session
    String bookingParam = request.getParameter("booking");
    if ("true".equals(bookingParam)) {
        // Convert guest session to customer session
        HttpSession httpSession = request.getSession();
        String sessionId = (String) httpSession.getAttribute("bookingSessionId");

        if (sessionId != null && customer != null) {
            BookingSessionService sessionService = new BookingSessionService();
            sessionService.convertGuestSessionToCustomer(sessionId, customer);
        }

        // Redirect to payment
        response.sendRedirect(request.getContextPath() + "/booking/payment");
        return;
    }

    // ... existing redirect logic
}
```

### Step 5: Session Cleanup

#### Add session cleanup job:

```java
// Create a scheduled task or servlet context listener
@WebListener
public class BookingSessionCleanupListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newScheduledThreadPool(1);

        // Clean up expired sessions every hour
        scheduler.scheduleAtFixedRate(() -> {
            try {
                BookingSessionService service = new BookingSessionService();
                int cleaned = service.cleanupExpiredSessions();
                System.out.println("Cleaned up " + cleaned + " expired booking sessions");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }, 1, 1, TimeUnit.HOURS);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) {
            scheduler.shutdown();
        }
    }
}
```

## 🔄 Booking Flow

### Complete Booking Process:

1. **Service Selection** (`/booking/services`)

   - User selects services
   - Creates guest or customer session
   - Stores service selections in JSON

2. **Therapist Selection** (`/booking/therapists`)

   - Validates session has services
   - Assigns therapists to services
   - Updates session data

3. **Time Selection** (`/booking/time`)

   - Validates therapist assignments
   - Schedules time slots for each service
   - Updates session data

4. **Registration** (if guest) (`/register?booking=true`)

   - Forces guest users to register
   - Converts guest session to customer session
   - Redirects to payment

5. **Payment** (`/booking/payment`)

   - Validates complete session
   - Processes payment
   - Creates final appointments

6. **Confirmation** (`/booking/confirmation`)
   - Shows booking confirmation
   - Cleans up session data

## 🔧 Configuration Options

### Session Expiry Settings:

```java
// In BookingSession.java constructor
this.expiresAt = LocalDateTime.now().plusDays(30); // 30 days default

// Or configure via application properties
public static final int SESSION_EXPIRY_DAYS =
    Integer.parseInt(System.getProperty("booking.session.expiry.days", "30"));
```

### Guest vs Customer Behavior:

```java
// Force registration before payment
if (session.getCustomerId() == null && session.hasTimeSlots()) {
    response.sendRedirect("/register?booking=true");
    return;
}
```

## 🧪 Testing

### Run Basic Tests:

```bash
cd src/main/java
java test.BookingSessionTest
```

### Test Database Operations:

```java
// Test session creation
BookingSessionDAO dao = new BookingSessionDAO();
BookingSession session = new BookingSession("test_123");
boolean created = dao.create(session);

// Test session retrieval
BookingSession retrieved = dao.findBySessionId("test_123");
```

## 🚨 Common Issues & Solutions

### Issue 1: JSON Serialization Errors

**Solution**: Ensure Jackson dependencies are included and properly configured.

### Issue 2: Session Not Persisting

**Solution**: Check that session IDs are properly stored in HTTP session for guests.

### Issue 3: Step Validation Failing

**Solution**: Use `bookingSessionService.canProceedToStep()` for validation.

### Issue 4: Database Connection Issues

**Solution**: Verify `DBContext.getConnection()` is working and database is accessible.

## 📊 Monitoring & Maintenance

### Session Statistics:

```java
BookingSessionService service = new BookingSessionService();
BookingSessionDAO.SessionStats stats = service.getSessionStats();
System.out.println("Total sessions: " + stats.totalSessions);
System.out.println("Guest sessions: " + stats.guestSessions);
System.out.println("Customer sessions: " + stats.customerSessions);
System.out.println("Expired sessions: " + stats.expiredSessions);
```

### Regular Cleanup:

```sql
-- Manual cleanup of expired sessions
DELETE FROM booking_sessions WHERE expires_at <= NOW();

-- Check session data sizes
SELECT session_id, LENGTH(session_data) as data_size
FROM booking_sessions
ORDER BY data_size DESC
LIMIT 10;
```

## 🎯 Next Steps

1. **Test the basic functionality** with the provided test class
2. **Integrate with your existing booking flow** step by step
3. **Add error handling and logging** for production use
4. **Implement session monitoring** for performance tracking
5. **Add customer notification features** for abandoned sessions

## 📝 Notes

- Sessions expire after 30 days by default
- Guest sessions are tied to HTTP session ID
- Customer sessions are tied to customer ID
- All booking data is stored as JSON for flexibility
- Registration is required before payment completion
- Sessions are automatically cleaned up on expiration

This implementation provides a robust, scalable booking session system that handles both guest and customer booking flows while maintaining data consistency and user experience.
