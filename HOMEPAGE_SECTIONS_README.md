# Homepage Dynamic Sections Documentation

## Overview

This document covers three dynamic homepage sections that have been converted from React components to plain HTML (JSP) and JavaScript, following separation of concerns principles:

1. **Recently Viewed Services** - Tracks and displays services users have recently viewed
2. **Promotional Services** - Shows services with special discounts and time-limited offers
3. **Most Purchased Services** - Displays the most popular services based on purchase data

## Architecture

### HTML Markup (JSP)

- **Location**: `src/main/webapp/index.jsp`
- **Conditional Display**: Only shown when `${showBookingFeatures}` is true (guests and customers)

### JavaScript Logic

- **Recently Viewed**: `src/main/webapp/js/recently-viewed-services.js`
- **Promotional & Popular**: `src/main/webapp/js/promotional-services.js`
- **Service Tracking Utility**: `src/main/webapp/js/service-tracker.js`

## HTML Structure

### 1. Recently Viewed Services Section

```html
<section
  id="recently-viewed-section"
  class="py-16 bg-spa-cream opacity-0 translate-y-8 transition-all duration-1000 ease-out hidden"
>
  <div
    id="recently-viewed-grid"
    class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6"
  >
    <!-- Services dynamically inserted here -->
  </div>
</section>
```

### 2. Promotional Services Section

```html
<section
  id="promotional-services-section"
  class="py-16 bg-gradient-to-br from-spa-cream to-secondary"
>
  <div
    id="promotional-services-grid"
    class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6"
  >
    <!-- Promotional services dynamically inserted here -->
  </div>
</section>
```

### 3. Most Purchased Services Section

```html
<section id="most-purchased-section" class="py-16 bg-white">
  <div
    id="most-purchased-grid"
    class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6"
  >
    <!-- Most purchased services dynamically inserted here -->
  </div>
</section>
```

## JavaScript Functionality

### Recently Viewed Services (`RecentlyViewedServices` class)

**Key Features:**

- localStorage-based service tracking
- Automatic show/hide based on available data
- Smooth fade-in animations with staggered delays
- Automatic demo data for development

**Key Methods:**

- `trackServiceView(serviceId, serviceName, serviceImage, servicePrice)` - Track a service view
- `loadRecentlyViewedServices()` - Load and display from localStorage
- `showSection()` / `hideSection()` - Animate section visibility

### Promotional Services (`PromotionalServicesManager` class)

**Key Features:**

- Displays services with discount information
- Shows discount percentages and expiry dates
- Category badges and promotional pricing
- Demo promotional data

**Service Data Structure:**

```javascript
{
  id: 'promo-1',
  name: 'Service Name',
  image: 'image-url.jpg',
  category: 'Category',
  rating: 4.8,
  duration: 90,
  originalPrice: 800000,
  discountPrice: 600000,
  discountPercent: 25,
  validUntil: '31/12/2024'
}
```

### Most Purchased Services (`PromotionalServicesManager` class)

**Key Features:**

- Popularity ranking badges (1st = gold, 2nd = silver, 3rd = bronze)
- "Best Seller" badges for top performers
- Purchase count statistics
- Trending indicators

**Service Data Structure:**

```javascript
{
  id: 'popular-1',
  name: 'Service Name',
  image: 'image-url.jpg',
  rating: 4.8,
  duration: 60,
  price: 500000,
  totalPurchases: 1250,
  popularityRank: 1,
  isBestSeller: true
}
```

## Visual Components

### Recently Viewed Services

- **Eye icon**: Indicates service was previously viewed
- **View date**: Shows when service was last viewed
- **"Đã xem" badge**: Appears on hover
- **Staggered animations**: 150ms delay between cards

### Promotional Services

- **Discount badge**: Red circular badge with percentage off
- **Category badge**: Top-right corner category indicator
- **Strikethrough pricing**: Shows original vs. discounted price
- **Expiry date**: "Có hiệu lực đến" with end date

### Most Purchased Services

- **Rank badges**: Numbered badges with rank-appropriate colors
  - 1st place: `bg-yellow-500` (Gold)
  - 2nd place: `bg-gray-400` (Silver)
  - 3rd place: `bg-amber-600` (Bronze)
  - Others: `bg-primary` (Theme color)
- **Best Seller badge**: Red badge with award icon
- **Purchase statistics**: Green trending icon with purchase count

## User Interactions

### Navigation

- **Service cards**: Click → Navigate to `/services` (+ track view)
- **Book buttons**: Click → Navigate to `/booking`
- **"Xem tất cả" buttons**: Navigate to respective listing pages

### Service Tracking

- **Auto-tracking**: Services clicked are automatically added to recently viewed
- **Persistence**: localStorage maintains history across sessions
- **Limit**: Maximum 10 services stored, 4 displayed

## Responsive Design

All sections use the same responsive grid system:

- **Mobile**: 1 column (`grid-cols-1`)
- **Tablet**: 2 columns (`md:grid-cols-2`)
- **Desktop**: 4 columns (`lg:grid-cols-4`)

### Breakpoint Behavior

- **< 768px**: Single column stack
- **768px - 1024px**: Two-column layout
- **> 1024px**: Four-column grid

## Styling & Animations

### CSS Classes Used

- **Layout**: Tailwind grid system with responsive classes
- **Colors**: Spa theme (primary: `#D4AF37`, spa-cream: `#FFF8F0`)
- **Animations**: CSS transforms and transitions
- **Interactive states**: Hover effects, scale transforms

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

### Hover Effects

- **Image scaling**: `group-hover:scale-105`
- **Shadow enhancement**: `hover:shadow-xl`
- **Color transitions**: Text and background color changes
- **Transform scaling**: Button and card hover states

## Data Management

### localStorage Structure (Recently Viewed)

```json
[
  {
    "id": "123",
    "name": "Service Name",
    "image": "image-url.jpg",
    "price": 500000,
    "viewedAt": "2024-01-15T10:30:00.000Z"
  }
]
```

### Demo Data Initialization

All sections include demo data for development:

- **Recently Viewed**: 3 sample services with timestamps
- **Promotional**: 4 services with various discount percentages
- **Most Purchased**: 4 services with ranking and purchase data

## Integration Points

### Context Path Detection

All sections automatically detect the JSP context path:

```javascript
getContextPath() {
  const metaContextPath = document.querySelector('meta[name="context-path"]');
  if (metaContextPath) {
    return metaContextPath.getAttribute('content');
  }
  // Fallback logic...
}
```

### Service Tracking Integration

Global utility functions available:

```javascript
// Manual tracking
trackServiceView("123", "Service Name", "image.jpg", 500000);

// Auto-track from meta tags
autoTrackCurrentService();

// Setup click tracking
setupServiceLinkTracking(".service-link");
```

## Performance Considerations

### Optimization Strategies

- **Lazy loading**: Sections only show when data is available
- **Event delegation**: Efficient handling of dynamic content
- **Icon management**: Lucide icons re-initialized after content updates
- **Storage limits**: Automatic cleanup of old data

### Memory Management

- **localStorage limits**: Maximum 10 recently viewed services
- **Demo data**: Can be disabled in production
- **Event cleanup**: Proper event listener management

## Error Handling

### Graceful Degradation

- **Missing elements**: Console warnings, no crashes
- **Image failures**: Fallback to placeholder images
- **localStorage issues**: Try-catch blocks around storage operations
- **Missing data**: Validation of required parameters

### Fallback Mechanisms

```javascript
// Image error handling
onerror =
  "this.src='${contextPath}/assets/home/images/placeholder-service.jpg'";

// localStorage fallback
try {
  localStorage.setItem(key, value);
} catch (error) {
  console.error("Failed to save to localStorage:", error);
}
```

## Browser Compatibility

### Modern Features Used

- **ES6+ Syntax**: Arrow functions, template literals, destructuring
- **CSS Grid**: Modern layout system
- **CSS Custom Properties**: Tailwind CSS variables
- **LocalStorage**: HTML5 storage API

### Fallback Support

- **Basic functionality**: Works without advanced features
- **Progressive enhancement**: Enhanced experience for modern browsers
- **Icon fallbacks**: Text alternatives for missing icons

## Usage Examples

### Track Service View from JSP

```html
<script>
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

### Update Services Programmatically

```javascript
// Update promotional services
promotionalServicesManagerInstance.updatePromotionalServices(newServices);

// Update most purchased services
promotionalServicesManagerInstance.updateMostPurchasedServices(newServices);
```

### Access Service Data

```javascript
// Get current promotional services
const promoServices =
  promotionalServicesManagerInstance.getPromotionalServices();

// Get recently viewed services
const recentServices = recentlyViewedServicesInstance.getRecentlyViewed();
```

## Development Notes

### Demo Data Removal

For production, remove demo data initialization:

```javascript
// Remove this method in production
initializeDemoData() {
  // Demo data initialization
}
```

### API Integration Points

Replace demo data with API calls:

```javascript
// Example API integration
async loadPromotionalServices() {
  try {
    const response = await fetch('/api/services/promotional');
    const services = await response.json();
    this.updatePromotionalServices(services);
  } catch (error) {
    console.error('Failed to load promotional services:', error);
  }
}
```

## Future Enhancements

1. **Backend Integration**: Replace demo data with real API calls
2. **Analytics**: Track user interactions and service performance
3. **Personalization**: Customized recommendations based on user behavior
4. **A/B Testing**: Different layouts and promotional strategies
5. **Real-time Updates**: WebSocket integration for live promotional updates
6. **Social Proof**: User reviews and testimonials integration
7. **Advanced Filtering**: Category-based filtering and search
8. **Accessibility**: Enhanced ARIA labels and keyboard navigation
