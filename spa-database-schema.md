# Spa Management System Database Schema

## Overview

This database schema is designed for a spa management system that handles a two-step process:
1. **Payment Phase**: Customers pay for multiple services in a single transaction
2. **Booking Phase**: Customers schedule individual paid services at different times

## Business Flow

1. Customers add multiple services to their cart
2. Customers pay for all services in the cart at once (single payment transaction)
3. After payment, customers can schedule/book individual paid services at different times
4. System tracks which services have been booked vs. paid but not yet booked

## Database Tables

### 1. Payment Transaction Tables

#### payments
Main payment transactions table - stores one record per cart checkout.

```sql
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    tax_amount DECIMAL(10,2) DEFAULT 0.00,
    subtotal_amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('BANK_TRANSFER', 'CREDIT_CARD', 'VNPAY', 'MOMO', 'ZALOPAY', 'CASH') NOT NULL,
    payment_status ENUM('PENDING', 'PAID', 'REFUNDED', 'FAILED') NOT NULL DEFAULT 'PENDING',
    reference_number VARCHAR(50) UNIQUE NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_date TIMESTAMP NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE RESTRICT,
    INDEX idx_customer_payment (customer_id, payment_date),
    INDEX idx_payment_status (payment_status),
    INDEX idx_reference_number (reference_number),
    INDEX idx_transaction_date (transaction_date)
);
```

#### payment_items
Individual services included in each payment - links payments to specific services.

```sql
CREATE TABLE payment_items (
    payment_item_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_id INT NOT NULL,
    service_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    service_duration INT NOT NULL, -- Duration in minutes
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (payment_id) REFERENCES payments(payment_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(service_id) ON DELETE RESTRICT,
    INDEX idx_payment_items (payment_id),
    INDEX idx_service_payment (service_id),
    
    -- Ensure positive values
    CONSTRAINT chk_quantity_positive CHECK (quantity > 0),
    CONSTRAINT chk_unit_price_positive CHECK (unit_price > 0),
    CONSTRAINT chk_total_price_positive CHECK (total_price > 0),
    CONSTRAINT chk_duration_positive CHECK (service_duration > 0)
);
```

### 2. Booking/Appointment Tables

#### bookings
Main bookings/appointments table - stores individual service bookings linked to paid services.

```sql
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    payment_item_id INT NOT NULL,
    service_id INT NOT NULL,
    therapist_user_id INT NOT NULL,
    
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    duration_minutes INT NOT NULL,
    booking_status ENUM('SCHEDULED', 'CONFIRMED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'NO_SHOW') NOT NULL DEFAULT 'SCHEDULED',
    booking_notes TEXT,
    cancellation_reason TEXT,
    cancelled_at TIMESTAMP NULL DEFAULT NULL,
    cancelled_by INT NULL, -- User ID who cancelled
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (payment_item_id) REFERENCES payment_items(payment_item_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(service_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (therapist_user_id) REFERENCES users(user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (cancelled_by) REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    
    -- Indexes for performance
    INDEX idx_customer_bookings (customer_id, appointment_date),
    INDEX idx_therapist_schedule (therapist_user_id, appointment_date, appointment_time),
    INDEX idx_appointment_datetime (appointment_date, appointment_time),
    INDEX idx_booking_status (booking_status),
    INDEX idx_payment_item_booking (payment_item_id),
    
    -- Constraints
   
    CONSTRAINT chk_appointment_date CHECK (appointment_date >= '2000-01-01'),
    CONSTRAINT chk_appointment_time CHECK (appointment_time >= '00:00:00' AND appointment_time <= '23:59:59')
);
```

#### payment_item_usage
Tracks remaining bookable quantities for each payment item.

```sql
CREATE TABLE payment_item_usage (
    usage_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_item_id INT NOT NULL,
    total_quantity INT NOT NULL,
    booked_quantity INT NOT NULL DEFAULT 0,
    remaining_quantity INT GENERATED ALWAYS AS (total_quantity - booked_quantity) STORED,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (payment_item_id) REFERENCES payment_items(payment_item_id) ON DELETE CASCADE,
    UNIQUE KEY uk_payment_item (payment_item_id),
    
    -- Ensure quantities are valid
    CONSTRAINT chk_total_quantity_positive CHECK (total_quantity > 0),
    CONSTRAINT chk_booked_quantity_valid CHECK (booked_quantity >= 0 AND booked_quantity <= total_quantity)
);
```

### 3. Supporting Tables for Business Logic

#### therapist_availability
Therapist working hours and availability.

```sql
CREATE TABLE therapist_availability (
    availability_id INT PRIMARY KEY AUTO_INCREMENT,
    therapist_id INT NOT NULL,
    day_of_week TINYINT NOT NULL, -- 1=Monday, 7=Sunday
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (therapist_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_therapist_schedule (therapist_id, day_of_week),
    
    CONSTRAINT chk_day_of_week CHECK (day_of_week BETWEEN 1 AND 7),
    CONSTRAINT chk_time_order CHECK (start_time < end_time)
);
```

#### therapist_time_off
Therapist time-off and special schedules.

```sql
CREATE TABLE therapist_time_off (
    time_off_id INT PRIMARY KEY AUTO_INCREMENT,
    therapist_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    start_time TIME NULL, -- NULL means full day
    end_time TIME NULL,   -- NULL means full day
    reason VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (therapist_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_therapist_timeoff (therapist_id, start_date, end_date),
    
    CONSTRAINT chk_date_order CHECK (start_date <= end_date),
    CONSTRAINT chk_time_consistency CHECK (
        (start_time IS NULL AND end_time IS NULL) OR 
        (start_time IS NOT NULL AND end_time IS NOT NULL AND start_time < end_time)
    )
);
```

## 4. Triggers for Data Integrity

### Initialize payment_item_usage when payment_items are created

```sql
DELIMITER //
CREATE TRIGGER tr_payment_item_usage_insert
    AFTER INSERT ON payment_items
    FOR EACH ROW
BEGIN
    INSERT INTO payment_item_usage (payment_item_id, total_quantity)
    VALUES (NEW.payment_item_id, NEW.quantity);
END//
```

### Update booked_quantity when bookings are created

```sql
CREATE TRIGGER tr_booking_insert_update_usage
    AFTER INSERT ON bookings
    FOR EACH ROW
BEGIN
    UPDATE payment_item_usage
    SET booked_quantity = booked_quantity + 1
    WHERE payment_item_id = NEW.payment_item_id;
END//
```

### Update booked_quantity when bookings are cancelled

```sql
CREATE TRIGGER tr_booking_cancel_update_usage
    AFTER UPDATE ON bookings
    FOR EACH ROW
BEGIN
    -- If booking status changed to cancelled, decrease booked_quantity
    IF OLD.booking_status NOT IN ('cancelled', 'no_show')
       AND NEW.booking_status IN ('cancelled', 'no_show') THEN
        UPDATE payment_item_usage
        SET booked_quantity = booked_quantity - 1
        WHERE payment_item_id = NEW.payment_item_id;
    END IF;

    -- If booking status changed from cancelled to active, increase booked_quantity
    IF OLD.booking_status IN ('cancelled', 'no_show')
       AND NEW.booking_status NOT IN ('cancelled', 'no_show') THEN
        UPDATE payment_item_usage
        SET booked_quantity = booked_quantity + 1
        WHERE payment_item_id = NEW.payment_item_id;
    END IF;
END//
```

### Prevent booking more than paid quantity

```sql
CREATE TRIGGER tr_booking_quantity_check
    BEFORE INSERT ON bookings
    FOR EACH ROW
BEGIN
    DECLARE remaining_qty INT;

    SELECT remaining_quantity INTO remaining_qty
    FROM payment_item_usage
    WHERE payment_item_id = NEW.payment_item_id;

    IF remaining_qty <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot book: No remaining quantity for this paid service';
    END IF;
END//

DELIMITER ;
```

## 5. Useful Views for Business Logic

### Payment Summary View
Shows payment summary with booking status.

```sql
CREATE VIEW v_payment_summary AS
SELECT
    p.payment_id,
    p.customer_id,
    c.full_name as customer_name,
    p.total_amount,
    p.payment_status,
    p.payment_date,
    p.reference_number,
    COUNT(pi.payment_item_id) as total_services,
    SUM(pi.quantity) as total_service_quantity,
    COALESCE(SUM(piu.booked_quantity), 0) as total_booked,
    COALESCE(SUM(piu.remaining_quantity), 0) as total_remaining
FROM payments p
JOIN customers c ON p.customer_id = c.customer_id
LEFT JOIN payment_items pi ON p.payment_id = pi.payment_id
LEFT JOIN payment_item_usage piu ON pi.payment_item_id = piu.payment_item_id
GROUP BY p.payment_id;
```

### Available Services for Booking View
Shows paid but not fully booked services.

```sql
CREATE VIEW v_available_for_booking AS
SELECT
    pi.payment_item_id,
    pi.payment_id,
    p.customer_id,
    c.full_name as customer_name,
    pi.service_id,
    s.service_name,
    pi.unit_price,
    pi.service_duration,
    piu.total_quantity,
    piu.booked_quantity,
    piu.remaining_quantity,
    p.payment_date
FROM payment_items pi
JOIN payments p ON pi.payment_id = p.payment_id
JOIN customers c ON p.customer_id = c.customer_id
JOIN services s ON pi.service_id = s.service_id
JOIN payment_item_usage piu ON pi.payment_item_id = piu.payment_item_id
WHERE p.payment_status = 'completed'
  AND piu.remaining_quantity > 0;
```

### Therapist Schedule View
Shows therapist schedule with bookings.

```sql
CREATE VIEW v_therapist_schedule AS
SELECT
    b.booking_id,
    b.therapist_id,
    u.full_name as therapist_name,
    b.appointment_date,
    b.appointment_time,
    b.duration_minutes,
    TIME_ADD(b.appointment_time, INTERVAL b.duration_minutes MINUTE) as end_time,
    b.booking_status,
    b.customer_id,
    c.full_name as customer_name,
    s.service_name
FROM bookings b
JOIN users u ON b.therapist_id = u.user_id
JOIN customers c ON b.customer_id = c.customer_id
JOIN services s ON b.service_id = s.service_id
WHERE b.booking_status NOT IN ('cancelled', 'no_show');
```

## 6. Performance Optimization Indexes

Additional composite indexes for common queries:

```sql
-- Additional composite indexes for common queries
CREATE INDEX idx_payments_customer_status_date ON payments(customer_id, payment_status, payment_date);
CREATE INDEX idx_bookings_date_status ON bookings(appointment_date, booking_status);
CREATE INDEX idx_bookings_therapist_date_time ON bookings(therapist_id, appointment_date, appointment_time);
CREATE INDEX idx_payment_items_service_payment ON payment_items(service_id, payment_id);
```

## Key Features of This Design

### Data Integrity
- **Foreign key constraints** ensure referential integrity between all related tables
- **Check constraints** prevent invalid data (negative quantities, invalid dates, etc.)
- **Triggers** automatically maintain booking quantities and prevent overbooking
- **Generated columns** for calculated fields (remaining_quantity)
- **Unique constraints** on critical fields (reference_number)

### Business Logic Support
- **Prevents booking unpaid services** through foreign key relationships
- **Tracks remaining bookable quantities** via payment_item_usage table
- **Supports partial booking** of paid services over time
- **Handles cancellations and rebooking** with proper quantity tracking
- **Maintains audit trail** for all operations

### Performance Optimization
- **Strategic indexes** for common query patterns (customer lookups, date ranges, therapist schedules)
- **Composite indexes** for multi-column queries
- **Views** for complex business queries to avoid repeated joins
- **Efficient data types** and storage optimization

### Flexibility and Extensibility
- **Supports multiple services per payment** with individual quantities
- **Allows quantity-based bookings** (e.g., 3 massages from one payment)
- **Handles various payment methods** with extensible enum
- **Extensible status enums** for payments and bookings
- **Therapist scheduling system** with availability and time-off tracking

### Audit Trail and Tracking
- **Timestamps** for all major operations (created_at, updated_at)
- **Cancellation tracking** with reasons and timestamps
- **Payment reference numbers** for reconciliation
- **User tracking** for who performed cancellations
- **Status history** through status changes

## Usage Examples

### 1. Process a Payment
```sql
-- Insert payment
INSERT INTO payments (customer_id, total_amount, tax_amount, subtotal_amount, payment_method, reference_number)
VALUES (123, 1100.00, 100.00, 1000.00, 'qr_code', 'SPA202501151234');

-- Insert payment items
INSERT INTO payment_items (payment_id, service_id, quantity, unit_price, total_price, service_duration)
VALUES
(LAST_INSERT_ID(), 1, 2, 300.00, 600.00, 60),
(LAST_INSERT_ID(), 2, 1, 400.00, 400.00, 90);
```

### 2. Book a Service
```sql
-- Check available services for customer
SELECT * FROM v_available_for_booking WHERE customer_id = 123;

-- Create booking
INSERT INTO bookings (customer_id, payment_item_id, service_id, therapist_id, appointment_date, appointment_time, duration_minutes)
VALUES (123, 456, 1, 789, '2025-01-20', '14:00:00', 60);
```

### 3. Check Therapist Schedule
```sql
-- View therapist schedule for a specific date
SELECT * FROM v_therapist_schedule
WHERE therapist_id = 789
AND appointment_date = '2025-01-20'
ORDER BY appointment_time;
```

### 4. Payment and Booking Summary
```sql
-- Get payment summary with booking status
SELECT * FROM v_payment_summary WHERE customer_id = 123;
```

## Database Relationships Summary

```
customers (1) ←→ (M) payments
payments (1) ←→ (M) payment_items
payment_items (1) ←→ (1) payment_item_usage
payment_items (1) ←→ (M) bookings
services (1) ←→ (M) payment_items
services (1) ←→ (M) bookings
users/therapists (1) ←→ (M) bookings
users/therapists (1) ←→ (M) therapist_availability
users/therapists (1) ←→ (M) therapist_time_off
```

This comprehensive database schema provides a robust foundation for your spa management system's payment and booking workflow while maintaining data integrity, supporting complex business requirements, and ensuring optimal performance.
