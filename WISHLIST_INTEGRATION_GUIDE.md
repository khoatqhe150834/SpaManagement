# Wishlist System Integration Guide

## Overview

The Wishlist system has been successfully converted from React to JSP + JavaScript. It provides a complete wishlist functionality with modal interface, localStorage persistence, and seamless integration with the existing spa management system.

## Files Created

### 1. JSP Files

- **`src/main/webapp/WEB-INF/view/customer/wishlist.jsp`** - Main wishlist modal page
- **`src/main/webapp/WEB-INF/view/customer/services-with-wishlist.jsp`** - Demo page showing wishlist integration

### 2. JavaScript Files

- **`src/main/webapp/js/wishlist.js`** - Complete wishlist functionality

### 3. Controller Files

- **`src/main/java/controller/WishlistController.java`** - Backend controller for wishlist operations

## How to Use

### 1. Include Wishlist in Your JSP Pages

#### Option A: Include the Complete Modal

```jsp
<!-- Include the wishlist modal -->
<jsp:include page="wishlist.jsp"/>

<!-- Include the JavaScript -->
<script src="${pageContext.request.contextPath}/js/wishlist.js"></script>
```

#### Option B: Manual Integration

```jsp
<!-- Add wishlist button to show modal -->
<button onclick="showWishlist()" class="wishlist-trigger-btn">
    <i data-lucide="heart"></i>
    Danh sách yêu thích
</button>

<!-- Include the modal and JavaScript -->
<jsp:include page="../customer/wishlist.jsp"/>
<script src="${pageContext.request.contextPath}/js/wishlist.js"></script>
```

### 2. Add Wishlist Buttons to Service Cards

```jsp
<!-- Service Card with Wishlist Button -->
<div class="service-card">
    <div class="relative">
        <img src="service-image.jpg" alt="Service Name">
        <!-- Wishlist Button -->
        <button class="wishlist-btn absolute top-3 right-3"
                data-service-id="1"
                data-service-name="Massage thư giãn"
                data-service-image="path/to/image.jpg"
                data-service-price="500000"
                data-service-rating="4.8"
                title="Thêm vào yêu thích">
            <i data-lucide="heart" class="h-5 w-5"></i>
        </button>
    </div>
    <!-- Rest of service card content -->
</div>
```

### 3. Required Data Attributes

For wishlist buttons to work properly, include these data attributes:

- `data-service-id` - Unique service identifier
- `data-service-name` - Service name
- `data-service-image` - Service image URL
- `data-service-price` - Service price (numeric)
- `data-service-rating` - Service rating (optional, defaults to 5.0)

### 4. User Authentication Integration

The system checks for authenticated users in multiple ways:

```jsp
<!-- Method 1: Include user data in JSP -->
<c:if test="${not empty userId}">
    <div id="userData" data-user-id="${userId}" data-user-type="${userType}" style="display: none;"></div>
</c:if>
```

```javascript
// Method 2: Set user data in JavaScript
sessionStorage.setItem(
  "currentUser",
  JSON.stringify({
    id: "user123",
    userType: "customer",
  })
);
```

## Features

### 1. Modal Interface

- **Responsive Design**: Works on desktop and mobile
- **Multiple States**: Loading, empty, not authenticated, populated
- **Smooth Animations**: CSS transitions and animations

### 2. Wishlist Management

- **Add to Wishlist**: Click heart button on service cards
- **Remove from Wishlist**: Click X button on wishlist items
- **View Details**: Click eye button to view service details
- **Add to Cart**: Move items from wishlist to cart

### 3. Persistence

- **localStorage**: Wishlist data persists across browser sessions
- **User-specific**: Each user has their own wishlist
- **Real-time Updates**: UI updates immediately on changes

### 4. Notifications

- **Success Messages**: "Đã thêm vào danh sách yêu thích"
- **Error Messages**: "Vui lòng đăng nhập để sử dụng tính năng này"
- **Auto-dismiss**: Notifications disappear after 3 seconds

## JavaScript API

### Global Functions

```javascript
// Show wishlist modal
showWishlist();

// Add service to wishlist
addToWishlist({
  serviceId: "1",
  serviceName: "Massage thư giãn",
  serviceImage: "path/to/image.jpg",
  servicePrice: 500000,
  serviceRating: 4.8,
});

// Remove service from wishlist
removeFromWishlist("serviceId");

// Check if service is in wishlist
isInWishlist("serviceId"); // returns boolean
```

### WishlistManager Class

```javascript
// Access the global wishlist manager
const wishlistManager = window.wishlistManager;

// Check authentication status
wishlistManager.isAuthenticated;

// Get current user
wishlistManager.currentUser;

// Get wishlist items
wishlistManager.wishlistItems;
```

## Styling

### CSS Classes

```css
/* Wishlist button states */
.wishlist-btn {
  /* Default state */
}

.wishlist-btn.in-wishlist {
  /* When item is in wishlist */
  background-color: #fee2e2;
  color: #ef4444;
}

/* Modal states */
.wishlist-modal {
  display: none;
}

.wishlist-modal.active {
  display: flex;
}

/* Notifications */
.notification {
  /* Notification styling */
}

.notification.success {
  background-color: #10b981;
}

.notification.error {
  background-color: #ef4444;
}
```

## Backend Integration

### Controller Endpoints

```java
// GET /wishlist - Show wishlist page
@WebServlet("/wishlist")
public class WishlistController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        // Handle wishlist page display
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        // Handle AJAX operations: add, remove, list
    }
}
```

### AJAX Operations

```javascript
// Add to wishlist via AJAX
fetch("/wishlist", {
  method: "POST",
  headers: {
    "Content-Type": "application/x-www-form-urlencoded",
  },
  body: "action=add&serviceId=1&serviceName=Massage&servicePrice=500000",
});
```

## Database Integration (Optional)

For persistent storage, you can extend the system to save wishlist data to database:

```sql
-- Wishlist table structure
CREATE TABLE wishlists (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    service_id INT NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (service_id) REFERENCES services(id),
    UNIQUE KEY unique_wishlist (user_id, service_id)
);
```

## Troubleshooting

### Common Issues

1. **Wishlist buttons not working**

   - Check if `wishlist.js` is loaded
   - Verify data attributes are present
   - Check browser console for errors

2. **Modal not showing**

   - Ensure modal HTML is included
   - Check if `showWishlist()` function is available
   - Verify CSS classes are applied

3. **User authentication issues**

   - Check if user data is available
   - Verify session/localStorage data
   - Ensure authentication check is working

4. **Items not persisting**
   - Check localStorage permissions
   - Verify user ID is consistent
   - Check for localStorage quota limits

### Debug Mode

Enable debug mode by adding to your JSP:

```javascript
<script>// Enable debug logging window.wishlistDebug = true;</script>
```

## Browser Compatibility

- **Modern Browsers**: Chrome 60+, Firefox 55+, Safari 12+, Edge 79+
- **Features Used**: ES6 classes, localStorage, Fetch API, CSS Grid
- **Fallbacks**: Graceful degradation for older browsers

## Performance Considerations

- **Lazy Loading**: Modal content loads only when opened
- **Efficient DOM Updates**: Uses templates for dynamic content
- **Minimal Dependencies**: Only requires Lucide icons and Tailwind CSS
- **localStorage Optimization**: Efficient JSON serialization

## Security Considerations

- **Input Validation**: All service data is validated
- **XSS Prevention**: Proper escaping of user input
- **CSRF Protection**: Can be integrated with existing CSRF tokens
- **Authentication**: Proper user authentication checks

## Future Enhancements

1. **Database Persistence**: Save wishlist to database
2. **Sharing**: Share wishlist with others
3. **Categories**: Organize wishlist by service categories
4. **Notifications**: Email notifications for wishlist updates
5. **Analytics**: Track wishlist usage and popular services
