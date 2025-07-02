# Guide: Preventing Double Bookings in a Concurrent System

This guide provides a comprehensive approach to preventing double bookings in a beauty service application. It covers database schema design, concurrency-safe implementation patterns in Java/SQL, and best practices for handling simultaneous booking requests gracefully.

## 1. Core Problem: The Race Condition

When two customers (Customer A and Customer B) try to book the same therapist for the same time slot simultaneously, a "race condition" can occur:

1.  **Check Availability**: Both A and B's requests check the database and see that the time slot is available.
2.  **Attempt to Book**: Both requests proceed to insert a new booking into the database.
3.  **Conflict**: Without proper safeguards, one of two things might happen:
    - The second request fails with an error (if you're lucky).
    - Both bookings are created, leading to a double-booked therapist (a critical business logic failure).

Our goal is to design a system that handles this race condition gracefully and guarantees data integrity.

## 2. Database Schema Design

A robust database schema is the foundation for preventing double bookings. The key is to enforce uniqueness at the database level.

### Recommended Schema

Here's a recommended schema with tables for appointments, therapists, customers, and services.

```sql
-- Represents a therapist who provides services
CREATE TABLE Therapists (
    therapist_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    specialization VARCHAR(255)
);

-- Represents a customer
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20)
);

-- Represents an appointment
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    therapist_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status VARCHAR(50) DEFAULT 'SCHEDULED', -- e.g., SCHEDULED, COMPLETED, CANCELLED
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (therapist_id) REFERENCES Therapists(therapist_id),

    -- This is the most critical part!
    -- Enforces that a therapist cannot be booked more than once for the same date and overlapping time.
    -- Note: This simple constraint assumes fixed time slots. For variable-duration services,
    -- you might need more complex logic (e.g., triggers or application-level checks).
    UNIQUE (therapist_id, appointment_date, start_time)
);
```

### Key Schema Decisions

- **`UNIQUE` Constraint**: The `UNIQUE (therapist_id, appointment_date, start_time)` constraint is the most important part of this schema. It makes it impossible for the database to store two appointments for the same therapist at the exact same date and start time. The database itself will reject the second `INSERT` attempt, guaranteeing data integrity.

## 3. Concurrency-Safe Implementation (Java/SQL)

Even with a `UNIQUE` constraint, you need to handle concurrency gracefully in your application code. Otherwise, users might see confusing database errors. The best approach is to combine database transactions with pessimistic locking.

### Strategy: Pessimistic Locking with `SELECT ... FOR UPDATE`

This strategy involves locking the relevant rows in the database for the duration of a transaction. When one transaction holds a lock, other transactions must wait until the first one is finished.

Here's how it works:

1.  **Start Transaction**: Begin a new database transaction.
2.  **Lock the "Slot"**: Execute a `SELECT` query that attempts to find any existing appointments for the requested therapist and time slot. The key is to add `FOR UPDATE` to the end of the query.
    - If a row is found, the slot is already booked.
    - If no row is found, the database places a lock on the "gap" where a row _would_ be, preventing other transactions from inserting into that gap.
3.  **Insert New Booking**: If the slot is available, insert the new appointment record.
4.  **Commit Transaction**: Commit the transaction to save the changes and release the locks.

If another request comes in for the same slot while the first transaction is in progress, it will be blocked at the `SELECT ... FOR UPDATE` step and will have to wait until the first transaction completes.

### Example: Java DAO/Service Layer

Here is a conceptual example of how you might implement this in a `BookingService` class.

```java
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;

public class BookingService {

    private Connection getConnection() {
        // Your logic to get a database connection from a connection pool
        return new DBContext().getConnection();
    }

    public boolean createBooking(int customerId, int therapistId, LocalDate appointmentDate, LocalTime startTime) {
        Connection conn = null;
        boolean bookingCreated = false;

        try {
            conn = getConnection();
            // 1. Start Transaction
            conn.setAutoCommit(false);

            // 2. Lock the Slot and Check for Availability
            // We lock the therapist's schedule for this specific date and time.
            String lockQuery = "SELECT appointment_id FROM Appointments WHERE therapist_id = ? AND appointment_date = ? AND start_time = ? FOR UPDATE";

            try (PreparedStatement lockStmt = conn.prepareStatement(lockQuery)) {
                lockStmt.setInt(1, therapistId);
                lockStmt.setDate(2, java.sql.Date.valueOf(appointmentDate));
                lockStmt.setTime(3, java.sql.Time.valueOf(startTime));

                ResultSet rs = lockStmt.executeQuery();

                // If a row exists, it means the slot is already booked.
                if (rs.next()) {
                    System.out.println("Booking failed: Slot is already taken.");
                    conn.rollback(); // Release the lock
                    return false;
                }
            }

            // 3. Insert New Booking (if slot was available)
            String insertQuery = "INSERT INTO Appointments (customer_id, therapist_id, appointment_date, start_time, end_time) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                insertStmt.setInt(1, customerId);
                insertStmt.setInt(2, therapistId);
                insertStmt.setDate(3, java.sql.Date.valueOf(appointmentDate));
                insertStmt.setTime(4, java.sql.Time.valueOf(startTime));
                // Assuming a fixed duration for simplicity
                insertStmt.setTime(5, java.sql.Time.valueOf(startTime.plusHours(1)));

                int rowsAffected = insertStmt.executeUpdate();
                if (rowsAffected > 0) {
                    bookingCreated = true;
                }
            }

            // 4. Commit Transaction
            conn.commit();
            System.out.println("Booking successful!");

        } catch (SQLException e) {
            // This will catch the UNIQUE constraint violation if a race condition still somehow occurs.
            System.err.println("SQL Exception: " + e.getMessage());
            if (conn != null) {
                try {
                    conn.rollback();
                    System.err.println("Transaction rolled back.");
                } catch (SQLException ex) {
                    System.err.println("Error rolling back transaction: " + ex.getMessage());
                }
            }
            // You might want to throw a custom exception here
            // e.g., throw new BookingConflictException("The selected time slot was just booked by another user.");
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Reset auto-commit behavior
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("Error closing connection: " + e.getMessage());
                }
            }
        }
        return bookingCreated;
    }
}
```

## 4. Best Practices and Graceful Error Handling

### 1. Use a Connection Pool

Never create a new database connection for each request. Use a robust connection pool library like **HikariCP** or **c3p0**. This is critical for performance and scalability.

### 2. Set Appropriate Transaction Isolation Level

For this use case, the default `READ COMMITTED` isolation level is usually sufficient when combined with `SELECT ... FOR UPDATE`. If you face more complex scenarios, you might consider `REPEATABLE READ`, but be aware of the increased potential for deadlocks.

### 3. Handle `SQLException` Gracefully

Instead of just printing a stack trace, catch the `SQLException`. You can inspect the `SQLState` or error code to see if it's a unique constraint violation.

```java
// In your catch block
} catch (SQLException e) {
    if ("23000".equals(e.getSQLState())) { // "23000" is the SQL state for integrity constraint violation
        // This is a clear sign of a booking conflict
        throw new BookingConflictException("Sorry, this time slot has just been booked. Please choose another time.");
    } else {
        // Handle other potential SQL errors
        throw new RuntimeException("An unexpected database error occurred.", e);
    }
}
```

### 4. Provide Clear Feedback to the User

In your servlet or controller, catch the custom `BookingConflictException` and forward the user to a page that clearly explains what happened.

**On `booking.jsp`:**

```jsp
<c:if test="${not empty bookingError}">
    <div class="alert alert-danger">
        <strong>Booking Failed!</strong> ${bookingError}
    </div>
</c:if>

<!-- Maybe show the booking form again with alternative slots highlighted -->
```

**In your `BookingServlet`:**

```java
// In your doPost method
try {
    boolean success = bookingService.createBooking(...);
    if (success) {
        response.sendRedirect("booking-success.jsp");
    } else {
        request.setAttribute("bookingError", "The selected time slot is not available.");
        request.getRequestDispatcher("booking.jsp").forward(request, response);
    }
} catch (BookingConflictException e) {
    request.setAttribute("bookingError", e.getMessage());
    request.getRequestDispatcher("booking.jsp").forward(request, response);
}
```

### 5. Alternative: Optimistic Locking

For systems with very high throughput and infrequent conflicts, **optimistic locking** is an alternative. This involves adding a `version` column to your `Appointments` table. You read the version number when you check for availability and then include it in your `UPDATE` or `INSERT`'s `WHERE` clause. If the version has changed, it means another transaction modified it, and your update will fail. This approach is more complex to implement correctly and is generally not necessary for this use case.

## Conclusion

By combining a strong database schema with a `UNIQUE` constraint and using pessimistic locking (`SELECT ... FOR UPDATE`) within a transaction, you can create a robust and concurrency-safe booking system that prevents double bookings and provides a smooth user experience even under heavy load.
