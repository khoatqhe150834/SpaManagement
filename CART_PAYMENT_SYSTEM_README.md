# Cart-Based Payment System for Spa Management

## Overview

This document describes the cart-based payment system that extends the existing spa management system. The system implements a two-step process:

1. **Payment Phase**: Customers pay for multiple services in a single transaction
2. **Booking Phase**: Customers schedule individual paid services at different times

## Architecture

### Database Tables

The system adds the following new tables to the existing spa management database:

- **`payments`** - Main payment transactions for cart-based purchases
- **`payment_items`** - Individual services included in each payment
- **`payment_item_usage`** - Tracks remaining bookable quantities for each payment item
- **Enhanced `bookings`** - Extended to link with payment items

### Java Classes

#### Model Classes
- **`Payment`** - Represents a cart payment transaction
- **`PaymentItem`** - Represents individual services in a payment
- **`PaymentItemUsage`** - Tracks usage of paid services
- **`Booking`** - Enhanced booking model with payment item integration

#### DAO Classes
- **`PaymentDAO`** - Data access for payment operations
- **`PaymentItemDAO`** - Data access for payment item operations
- **`PaymentItemUsageDAO`** - Data access for usage tracking
- **`BookingDAO`** - Enhanced booking data access

#### Service Classes
- **`CartPaymentService`** - Main service class integrating all payment operations

## Key Features

### 1. Cart Payment Processing
- Process multiple services in a single payment transaction
- Automatic tax calculation (8% VAT)
- Support for multiple payment methods (VNPay, MoMo, Credit Card, Cash, etc.)
- Transaction integrity with rollback support

### 2. Service Booking Management
- Book individual services from paid payment items
- Therapist availability checking
- Automatic usage quantity tracking
- Booking cancellation with usage restoration

### 3. Payment Status Management
- Real-time payment status updates
- Payment gateway integration support
- Reference number tracking

### 4. Comprehensive Reporting
- Customer payment history
- Available services for booking
- Dashboard statistics
- Usage analytics

## Usage Examples

### 1. Process a Cart Payment

```java
CartPaymentService service = new CartPaymentService();

// Create cart items
List<CartItem> cartItems = Arrays.asList(
    new CartItem(1, 2), // Service ID 1, Quantity 2
    new CartItem(3, 1)  // Service ID 3, Quantity 1
);

// Process payment
Payment payment = service.processCartPayment(
    143, // Customer ID
    cartItems,
    Payment.PaymentMethod.VNPAY,
    "Cart payment for multiple services"
);
```

### 2. Update Payment Status (Payment Gateway Callback)

```java
boolean updated = service.updatePaymentStatus(
    "SPA202501151234", // Reference number from gateway
    Payment.PaymentStatus.PAID
);
```

### 3. Get Available Services for Booking

```java
List<AvailableServiceForBooking> availableServices = 
    service.getAvailableServicesForBooking(143); // Customer ID

for (AvailableServiceForBooking available : availableServices) {
    System.out.println("Service: " + available.getService().getName());
    System.out.println("Remaining: " + available.getUsage().getRemainingQuantity());
}
```

### 4. Book a Paid Service

```java
Booking booking = service.bookPaidService(
    143, // Customer ID
    456, // Payment Item ID
    3,   // Therapist User ID
    Date.valueOf("2025-01-20"), // Appointment date
    Time.valueOf("14:00:00"),   // Appointment time
    "First massage session"     // Notes
);
```

### 5. Cancel a Booking

```java
boolean cancelled = service.cancelBooking(
    123, // Booking ID
    "Customer requested cancellation",
    1    // Admin user ID
);
```

## Database Integration

### Required Database Changes

1. **Create new tables** (see `spa-database-schema.md` for complete SQL)
2. **Add database triggers** for automatic usage tracking
3. **Create views** for business logic queries
4. **Add indexes** for performance optimization

### Migration Steps

1. Run the table creation scripts
2. Create triggers and views
3. Add performance indexes
4. Test with sample data

## Integration with Existing System

### Existing Tables Used
- **`customers`** - Customer information
- **`services`** - Service catalog
- **`users`** - Therapist information
- **`therapist_schedules`** - Therapist availability
- **`spa_information`** - VAT percentage configuration

### Backward Compatibility
- Existing booking system remains functional
- New payment system works alongside existing direct bookings
- No changes required to existing customer or service management

## Error Handling

### Transaction Management
- All payment operations use database transactions
- Automatic rollback on errors
- Comprehensive logging for debugging

### Validation
- Customer existence validation
- Service availability validation
- Therapist availability checking
- Payment item quantity validation

### Exception Handling
- SQLException handling with proper logging
- IllegalArgumentException for business rule violations
- Graceful degradation for non-critical errors

## Performance Considerations

### Database Optimization
- Composite indexes on frequently queried columns
- Efficient JOIN queries for related data
- Pagination support for large result sets

### Caching Opportunities
- Service catalog caching
- Customer information caching
- Therapist schedule caching

## Security Considerations

### Payment Security
- Reference number generation for tracking
- Payment status validation
- Transaction integrity protection

### Access Control
- User-based cancellation tracking
- Admin-only operations identification
- Customer data protection

## Testing

### Unit Testing
- Individual DAO method testing
- Service layer business logic testing
- Model validation testing

### Integration Testing
- End-to-end payment flow testing
- Database transaction testing
- Error scenario testing

### Example Test Data
```sql
-- Sample customer
INSERT INTO customers (customer_id, full_name, email, phone_number) 
VALUES (143, 'John Doe', 'john@example.com', '0123456789');

-- Sample services
INSERT INTO services (service_id, name, price, duration_minutes) 
VALUES (1, 'Swedish Massage', 500000.00, 60),
       (3, 'Basic Facial', 400000.00, 60);
```

## Monitoring and Maintenance

### Key Metrics to Monitor
- Payment success rates
- Booking completion rates
- Service utilization rates
- Customer satisfaction metrics

### Regular Maintenance Tasks
- Database performance optimization
- Log file cleanup
- Payment reconciliation
- Usage statistics analysis

## Future Enhancements

### Potential Features
- Loyalty points integration
- Package deals and discounts
- Recurring payment support
- Mobile app integration
- Advanced reporting dashboard

### Scalability Considerations
- Database sharding for high volume
- Caching layer implementation
- Microservice architecture migration
- Real-time notification system

## Support and Documentation

### Additional Resources
- Database schema documentation: `spa-database-schema.md`
- API documentation: Generated from JavaDoc comments
- Example usage: `CartPaymentExample.java`

### Contact Information
- Development Team: SpaManagement Development Team
- Documentation: This README and inline code comments
- Support: Check logs and error messages for troubleshooting
