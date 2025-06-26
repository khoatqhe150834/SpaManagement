# CartSession Implementation Guide

## Overview

This implementation extends the existing **shopping_carts** and **cart_items** tables to provide cookie-scoped cart state management, similar to the BookingSession architecture. Instead of creating new tables, we enhance the existing cart infrastructure with session expiration and improved API capabilities.

## Architecture

### Database Schema Extensions

The implementation extends the existing cart tables:

#### Extended shopping_carts Table

- **New Column**: `expires_at TIMESTAMP` - Session expiration time for cookie-based carts
- **Enhanced**: `session_id VARCHAR(255)` - UUID-based session ID for cookie-scoped carts
- **Index**: Added `idx_expires_at` for efficient cleanup queries

#### Existing cart_items Table

- **Reused**: All existing columns (`cart_item_id`, `cart_id`, `service_id`, `quantity`, `price_at_addition`, etc.)
- **Enhanced Usage**: `notes` field stores additional CartItem metadata as JSON when needed

### Key Components

1. **CartSession.java** - Enhanced model class with JSON serialization
2. **CartSessionService.java** - Business logic and cookie management
3. **CartSessionDAO.java** - Database operations using existing tables
4. **CartSessionApiServlet.java** - REST API endpoints
5. **create_cart_sessions_table.sql** - Schema extension script

## Usage Examples

### API Endpoints

#### Get Cart Contents

```http
GET /api/cart-session/
Response:
{
  "success": true,
  "cartSession": {
    "sessionId": "cart_abc123",
    "totalItems": 3,
    "totalAmount": 1500000.00,
    "cartItems": [...]
  }
}
```

#### Get Cart Item Count (for header icon)

```http
GET /api/cart-session/count
Response:
{
  "success": true,
  "count": 3
}
```

#### Add Item to Cart

```http
POST /api/cart-session/add
Content-Type: application/x-www-form-urlencoded

itemId=5&itemType=SERVICE&quantity=2

Response:
{
  "success": true,
  "message": "Item added to cart successfully",
  "cartCount": 5,
  "totalAmount": 2500000.00
}
```

#### Remove Item from Cart

```http
POST /api/cart-session/remove
Content-Type: application/x-www-form-urlencoded

itemId=5&itemType=SERVICE

Response:
{
  "success": true,
  "message": "Item removed from cart successfully",
  "cartCount": 3
}
```

#### Update Item Quantity

```http
POST /api/cart-session/update
Content-Type: application/x-www-form-urlencoded

itemId=5&itemType=SERVICE&quantity=3

Response:
{
  "success": true,
  "message": "Cart updated successfully",
  "cartCount": 6
}
```

#### Clear Cart

```http
POST /api/cart-session/clear

Response:
{
  "success": true,
  "message": "Cart cleared successfully",
  "cartCount": 0
}
```

### Integration with Existing Code

#### Service Layer Integration

```java
// In your service classes
CartSessionService cartSessionService = new CartSessionService();

// Add service to cart
cartSessionService.addToCart(request, response,
    serviceId, ItemType.SERVICE, serviceName, price, quantity);

// Get cart count for header
int cartCount = cartSessionService.getCartItemCount(request);
```

#### JSP Integration

```jsp
<!-- In your JSP pages -->
<script>
// Update cart count in header
function updateCartCount() {
    fetch('/api/cart-session/count')
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                document.querySelector('.cart-count').textContent = data.count;
            }
        });
}

// Add item to cart
function addToCart(serviceId, quantity = 1) {
    const formData = new FormData();
    formData.append('itemId', serviceId);
    formData.append('itemType', 'SERVICE');
    formData.append('quantity', quantity);

    fetch('/api/cart-session/add', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            updateCartCount();
            showNotification('Item added to cart!');
        }
    });
}
</script>
```

#### JavaScript Integration for Header Cart Icon

```javascript
// assets/home/js/header-cart.js
class HeaderCart {
  constructor() {
    this.cartIcon = document.querySelector(".cart-icon");
    this.cartBadge = document.querySelector(".cart-badge");
    this.init();
  }

  init() {
    this.updateCartCount();
    // Update every 30 seconds or on focus
    setInterval(() => this.updateCartCount(), 30000);
    window.addEventListener("focus", () => this.updateCartCount());
  }

  async updateCartCount() {
    try {
      const response = await fetch("/api/cart-session/count");
      const data = await response.json();

      if (data.success) {
        this.cartBadge.textContent = data.count;
        this.cartBadge.style.display = data.count > 0 ? "inline" : "none";
      }
    } catch (error) {
      console.error("Error updating cart count:", error);
    }
  }

  async addToCart(itemId, itemType = "SERVICE", quantity = 1) {
    const formData = new FormData();
    formData.append("itemId", itemId);
    formData.append("itemType", itemType);
    formData.append("quantity", quantity);

    try {
      const response = await fetch("/api/cart-session/add", {
        method: "POST",
        body: formData,
      });

      const data = await response.json();
      if (data.success) {
        this.updateCartCount();
        this.showNotification("Item added to cart!");
      }

      return data;
    } catch (error) {
      console.error("Error adding to cart:", error);
      return { success: false, message: "Network error" };
    }
  }

  showNotification(message) {
    // Implement your notification system
    console.log(message);
  }
}

// Initialize when DOM is ready
document.addEventListener("DOMContentLoaded", () => {
  window.headerCart = new HeaderCart();
});
```

### User Login Integration

```java
// In your login controller
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    // ... existing login logic ...

    if (loginSuccessful) {
        // Transfer guest cart to customer account
        CartSessionService cartSessionService = new CartSessionService();
        String guestSessionId = getCartSessionIdFromCookie(request);

        if (guestSessionId != null) {
            CartSession mergedCart = cartSessionService.mergeWithCustomerCart(
                guestSessionId, customer.getCustomerId());

            // Remove guest session cookie
            cartSessionService.removeCartSessionCookie(response);
        }

        // ... rest of login logic ...
    }
}
```

### Integration with Booking System

```java
// In your booking controller
public class BookingController {
    private CartSessionService cartSessionService = new CartSessionService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get current cart session
        CartSession cartSession = cartSessionService.getOrCreateCartSession(request, response);

        // Convert cart items to booking appointments
        for (CartItem item : cartSession.getServiceItems()) {
            BookingAppointment appointment = new BookingAppointment();
            appointment.setServiceId(item.getItemId());
            appointment.setQuantity(item.getQuantity());
            // ... set other appointment fields ...

            bookingService.createAppointment(appointment);
        }

        // Clear cart after successful booking
        cartSessionService.clearCart(request, response);

        // Redirect to confirmation page
        response.sendRedirect("/booking-confirmation");
    }
}
```

## Database Migration

### Running the Schema Extension

```sql
-- Execute the schema extension script
source create_cart_sessions_table.sql;

-- Or run individual commands:
ALTER TABLE shopping_carts
ADD COLUMN IF NOT EXISTS expires_at TIMESTAMP NULL;

ALTER TABLE shopping_carts
ADD INDEX IF NOT EXISTS idx_expires_at (expires_at);
```

### Cleanup and Maintenance

```java
// Schedule this to run daily
@Scheduled(cron = "0 0 2 * * ?") // Run at 2 AM daily
public void cleanupExpiredSessions() {
    CartSessionService cartSessionService = new CartSessionService();
    int deletedCount = cartSessionService.cleanupExpiredSessions();
    logger.info("Cleaned up {} expired cart sessions", deletedCount);
}
```

## Features

### Core Features

- ✅ **Cookie-based sessions** - 30-day expiration
- ✅ **Service and Product support** - Extensible item types
- ✅ **Automatic cart merging** - Guest to customer conversion
- ✅ **JSON serialization** - Efficient data storage
- ✅ **RESTful API** - Complete CRUD operations
- ✅ **Existing schema reuse** - No new tables required

### Advanced Features

- ✅ **Session expiration** - Automatic cleanup
- ✅ **Cart persistence** - Survives browser restarts
- ✅ **User association** - Links to customer accounts
- ✅ **Quantity management** - Add, update, remove items
- ✅ **Price tracking** - Stores price at time of addition
- ✅ **Integration ready** - Works with existing cart system

### Business Logic

- ✅ **Duplicate handling** - Merges quantities for same items
- ✅ **Cart validation** - Ensures data integrity
- ✅ **Error handling** - Comprehensive error responses
- ✅ **Performance optimized** - Efficient database queries

## API Reference

### CartSessionApiServlet Endpoints

| Method | Endpoint                   | Description            | Parameters                       |
| ------ | -------------------------- | ---------------------- | -------------------------------- |
| GET    | `/api/cart-session/`       | Get full cart contents | -                                |
| GET    | `/api/cart-session/count`  | Get cart item count    | -                                |
| POST   | `/api/cart-session/add`    | Add item to cart       | `itemId`, `itemType`, `quantity` |
| POST   | `/api/cart-session/remove` | Remove item from cart  | `itemId`, `itemType`             |
| POST   | `/api/cart-session/update` | Update item quantity   | `itemId`, `itemType`, `quantity` |
| POST   | `/api/cart-session/clear`  | Clear entire cart      | -                                |

### Response Format

All endpoints return JSON responses with this structure:

```json
{
  "success": boolean,
  "message": "string",
  "cartCount": number,
  "totalAmount": number,
  "cartSession": object
}
```

## Integration Checklist

### Backend Integration

- [x] Add CartSession.java model
- [x] Add CartSessionService.java service
- [x] Add CartSessionDAO.java data access
- [x] Add CartSessionApiServlet.java API endpoints
- [x] Run schema extension script
- [x] Configure servlet mapping in web.xml

### Frontend Integration

- [ ] Update header cart icon to use new API
- [ ] Modify service pages to use cart session
- [ ] Update cart page to use new endpoints
- [ ] Integrate with booking flow
- [ ] Add cart session JavaScript utilities

### Testing

- [ ] Test cookie persistence across browser sessions
- [ ] Test guest to customer cart merging
- [ ] Test API endpoints functionality
- [ ] Test session expiration and cleanup
- [ ] Test integration with existing cart system

## Configuration

### Cookie Settings

```java
// In CartSessionService.java
private static final String CART_SESSION_COOKIE_NAME = "cart_session_id";
private static final int COOKIE_MAX_AGE = 30 * 24 * 60 * 60; // 30 days
private static final String COOKIE_PATH = "/";
```

### Session Expiration

```java
// In CartSession.java constructor
this.expiresAt = LocalDateTime.now().plusDays(30); // 30 days
```

This implementation provides a robust, cookie-scoped cart system that extends your existing database schema while maintaining compatibility with the current cart functionality. The design allows for seamless user experience across sessions and provides a solid foundation for future enhancements.
