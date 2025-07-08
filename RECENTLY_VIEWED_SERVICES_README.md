# Recently Viewed Services Feature

## Overview

This feature has been converted from a React component to plain HTML (JSP) and JavaScript, following the separation of concerns principle. The feature tracks and displays services that users have recently viewed, encouraging them to revisit or book those services.

## Architecture

### HTML Markup (JSP)

- **Location**: `src/main/webapp/index.jsp`
- **Section ID**: `recently-viewed-section`
- **Grid Container**: `recently-viewed-grid`

### JavaScript Logic

- **Main Script**: `src/main/webapp/js/recently-viewed-services.js`
- **Utility Script**: `src/main/webapp/js/service-tracker.js`

## HTML Structure

The HTML markup in `index.jsp` includes:

```html
<!-- Recently Viewed Services Section -->
<section
  id="recently-viewed-section"
  class="py-16 bg-spa-cream opacity-0 translate-y-8 transition-all duration-1000 ease-out hidden"
>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex items-center justify-between mb-12">
      <!-- Header with title and "View All" button -->
    </div>
    <div
      id="recently-viewed-grid"
      class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6"
    >
      <!-- Services will be dynamically inserted here -->
    </div>
  </div>
</section>
```

## JavaScript Functionality

### Main Class: `RecentlyViewedServices`

**Key Features:**

- Manages localStorage for service tracking
- Dynamically renders service cards
- Handles user interactions (clicks, bookings)
- Provides smooth animations and transitions

**Key Methods:**

- `trackServiceView(serviceId, serviceName, serviceImage, servicePrice)` - Adds/updates a service in the recently viewed list
- `loadRecentlyViewedServices()` - Loads services from localStorage and displays them
- `renderServices(services)` - Creates HTML for service cards
- `showSection()` / `hideSection()` - Animates section visibility

### Service Tracking Utility

**Functions Available:**

- `trackServiceView(serviceId, serviceName, serviceImage, servicePrice)` - Global function to track service views
- `autoTrackCurrentService()` - Automatically tracks current service based on meta tags
- `setupServiceLinkTracking(selector)` - Sets up click tracking for service links
- `trackServiceFromElement(element)` - Tracks service from element data attributes

## Usage Examples

### 1. Track Service View Manually

```javascript
// When user views a service
trackServiceView("123", "Massage thư giãn", "image-url.jpg", 500000);
```

### 2. Auto-track from Meta Tags

Add meta tags to your service detail pages:

```html
<meta name="service-id" content="123" />
<meta name="service-name" content="Massage thư giãn" />
<meta name="service-image" content="image-url.jpg" />
<meta name="service-price" content="500000" />
```

The script will automatically track the service when the page loads.

### 3. Track from Data Attributes

Add data attributes to service links:

```html
<a
  href="/service/123"
  class="service-link"
  data-service-id="123"
  data-service-name="Massage thư giãn"
  data-service-image="image-url.jpg"
  data-service-price="500000"
>
  View Service
</a>
```

### 4. Track from JSP/Controller

In your JSP files, you can track service views like this:

```html
<script>
  // Track when user views service details
  window.addEventListener('load', function() {
      trackServiceView(
          '${service.id}',
          '${service.name}',
          '${service.imageUrl}',
          ${service.price}
      );
  });
</script>
```

## Data Storage

### LocalStorage Structure

Services are stored in localStorage under the key `recently_viewed_services`:

```json
[
  {
    "id": "123",
    "name": "Massage thư giãn toàn thân",
    "image": "https://example.com/image.jpg",
    "price": 500000,
    "viewedAt": "2024-01-15T10:30:00.000Z"
  }
]
```

- **Maximum Storage**: 10 services
- **Display Limit**: 4 services on homepage
- **Sorting**: Most recently viewed first

## Styling

### CSS Classes Used

- **Layout**: Tailwind CSS grid system (`grid-cols-1 md:grid-cols-2 lg:grid-cols-4`)
- **Animations**: Custom CSS animations (`animate-fadeIn`, transitions)
- **Interactive States**: Hover effects, transform scales, shadow changes
- **Colors**: Spa theme colors (primary: `#D4AF37`, spa-cream: `#FFF8F0`)

### Custom Animations

```css
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fadeIn {
  animation: fadeIn 0.6s ease-out forwards;
}
```

## Integration Points

### 1. Header Navigation

- "View All" button links to `/services` page

### 2. Service Cards

- Clicking card navigates to `/services` (and tracks the view)
- "Đặt ngay" button navigates to `/booking`

### 3. Context Path Handling

- Automatically detects JSP context path
- Supports both relative and absolute URL routing

## Responsive Design

- **Mobile (1 col)**: Single column layout
- **Tablet (2 cols)**: Two column layout
- **Desktop (4 cols)**: Four column layout
- **Animation Delays**: Staggered animations (150ms intervals)

## Error Handling

- **Missing Elements**: Graceful degradation if DOM elements not found
- **Image Loading**: Fallback to placeholder image on error
- **LocalStorage**: Try-catch blocks around storage operations
- **Missing Data**: Validation of required parameters

## Performance Considerations

- **Lazy Loading**: Section only shows when services are available
- **Animation Optimization**: CSS transforms for smooth animations
- **Storage Limits**: Automatic cleanup of old services (max 10)
- **Event Delegation**: Efficient event handling for dynamic content

## Development Notes

### Demo Data

The system includes demo data initialization for development/testing:

```javascript
// Remove this in production
initializeDemoData() {
  // Creates sample services if localStorage is empty
}
```

### Browser Compatibility

- **Modern Browsers**: ES6+ features used (arrow functions, template literals)
- **Fallbacks**: Basic functionality works without advanced features
- **LocalStorage**: Graceful degradation if not available

## Future Enhancements

1. **Analytics Integration**: Track service view analytics
2. **Personalization**: Recommend similar services
3. **Sync with Backend**: Store viewing history in database
4. **Social Features**: Share recently viewed services
5. **Categories**: Group services by type/category
