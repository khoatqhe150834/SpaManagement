# Servlet Controllers Summary

## Overview

This document provides a comprehensive summary of all servlet controllers in the G1_SpaManagement project and their corresponding URL mappings that have been implemented in the sidebar navigation.

## Core Controllers

### 1. HomeController

- **URL Pattern**: `/` (from web.xml)
- **Purpose**: Main homepage controller
- **Navigation**: Home link in header/main navigation

### 2. DashboardController

- **URL Pattern**: `/dashboard/*`
- **Purpose**: Unified dashboard for all user roles
- **Navigation**: Main dashboard link for all authenticated users

### 3. LoginController

- **URL Pattern**: `/login`
- **Purpose**: User authentication
- **Navigation**: Login page (not in sidebar, accessed via header)

### 4. RegisterController

- **URL Patterns**:
  - `/register`
  - `/register-success`
  - `/email-verification-required`
  - `/resend-verification`
  - `/verify-email`
- **Purpose**: User registration and email verification
- **Navigation**: Registration page (not in sidebar, accessed via login page)

### 5. LogOutController

- **URL Pattern**: `/logout`
- **Purpose**: User logout functionality
- **Navigation**: Logout button in sidebar footer

## Profile & Settings Controllers

### 6. ProfileController

- **URL Patterns**: `/profile`, `/profile/edit`
- **Purpose**: User profile management
- **Navigation**:
  - Settings link in sidebar
  - Personal profile link in customer submenu
  - User profile section in sidebar footer

### 7. ChangePasswordController

- **URL Pattern**: `/password/change`
- **Purpose**: Password change functionality
- **Navigation**: Change password link in customer submenu

### 8. ResetPasswordController

- **URL Patterns**:
  - `/password-reset/new`
  - `/password-reset/request`
  - `/password-reset/edit`
  - `/password-reset/update`
- **Purpose**: Password reset functionality
- **Navigation**: Accessed via login page (forgot password link)

## Management Controllers

### 9. ServiceController

- **URL Pattern**: `/manager/service`
- **Purpose**: Service management for managers
- **Navigation**: Service management link in manager submenu

### 10. ServiceTypeController

- **URL Pattern**: `/manager/servicetype`
- **Purpose**: Service type management
- **Navigation**: Service type management link in manager submenu

### 11. StaffController

- **URL Pattern**: `/staff`
- **Purpose**: Staff management
- **Navigation**: Staff management link in manager submenu

### 12. UserController

- **URL Pattern**: `/user/*`
- **Purpose**: User management
- **Navigation**: User management link in manager submenu (`/user/list`)

### 13. CustomerController

- **URL Pattern**: `/customer/*` (from web.xml)
- **Purpose**: Customer management
- **Navigation**:
  - Customer management link in admin panel (`/customer/list`)
  - Customer appointments link (`/customer/view`)

## Content & Marketing Controllers

### 14. BlogController

- **URL Pattern**: `/blog`
- **Purpose**: Blog management
- **Navigation**: Blog management link in manager submenu

### 15. CategoryController

- **URL Pattern**: `/category/*`
- **Purpose**: Category management
- **Navigation**: Category management link in manager submenu (`/category/list`)

### 16. PromotionController

- **URL Pattern**: `/promotion/*`
- **Purpose**: Promotion management
- **Navigation**: Promotion management link in marketing submenu (`/promotion/list`)

### 17. PromotionsController

- **URL Pattern**: `/promotions`
- **Purpose**: Display promotions to users
- **Navigation**:
  - Special offers link in customer submenu
  - View promotions link in marketing submenu

### 18. ServiceReviewController

- **URL Pattern**: `/service-review`
- **Purpose**: Service review management
- **Navigation**: Service reviews link in marketing submenu

## Public Pages Controllers

### 19. AboutController

- **URL Pattern**: `/about`
- **Purpose**: About us page
- **Navigation**: About us link in common pages section

### 20. ContactController

- **URL Pattern**: `/contact`
- **Purpose**: Contact page
- **Navigation**: Contact link in common pages section

### 21. ServicesController

- **URL Pattern**: `/services`
- **Purpose**: Public services page
- **Navigation**: Services link in common pages section

## Booking & Appointments

### 22. BookingController

- **URL Pattern**: `/booking`
- **Purpose**: Service booking functionality
- **Navigation**: Book services link in customer submenu

### 23. AutoCheckInController

- **URL Pattern**: `/autocheckin`
- **Purpose**: Automatic check-in functionality
- **Navigation**: Auto check-in link in admin panel

## Utility Controllers

### 24. TestController

- **URL Pattern**: `/test`
- **Purpose**: System testing
- **Navigation**: System test link in admin panel

### 25. QRCodeController

- **URL Pattern**: `/qr/*`
- **Purpose**: QR code generation
- **Navigation**: QR code generation link in marketing submenu (`/qr/generate`)

### 26. SpaInfoController

- **URL Pattern**: `/spa-info`
- **Purpose**: Spa information management
- **Navigation**: Spa info link in manager submenu

### 27. UserAjaxController

- **URL Pattern**: `/ajax/user-fullname`
- **Purpose**: AJAX user data retrieval
- **Navigation**: Not in sidebar (AJAX endpoint)

## API Controllers

### 28. AvailabilityApiServlet

- **URL Patterns**: `/api/availability`, `/api/calendar-availability`
- **Purpose**: Availability checking API
- **Navigation**: Not in sidebar (API endpoint)

### 29. BookingSessionApiServlet

- **URL Pattern**: `/api/booking-session` (from web.xml)
- **Purpose**: Booking session management API
- **Navigation**: Not in sidebar (API endpoint)

### 30. CartApiServlet

- **URL Pattern**: `/api/cart/*`
- **Purpose**: Shopping cart API
- **Navigation**: Not in sidebar (API endpoint)

### 31. DebugAvailabilityServlet

- **URL Pattern**: `/api/debug-availability`
- **Purpose**: Availability debugging API
- **Navigation**: Not in sidebar (API endpoint)

### 32. ServiceApiServlet

- **URL Pattern**: `/api/services`
- **Purpose**: Services API
- **Navigation**: Not in sidebar (API endpoint)

### 33. ServiceTypeApiServlet

- **URL Pattern**: `/api/service-types`
- **Purpose**: Service types API
- **Navigation**: Not in sidebar (API endpoint)

### 34. TimeConflictApiServlet

- **URL Pattern**: `/api/time-conflicts`
- **Purpose**: Time conflict checking API
- **Navigation**: Not in sidebar (API endpoint)

## Role-Based Navigation Structure

### Customer Portal

- My appointments (`/customer/view`)
- Book services (`/booking`)
- Treatment history (`/customer/history`)
- Personal profile (`/profile`)
- Change password (`/password/change`)
- Payment history (`/customer/payments`)
- Loyalty points (`/customer/loyalty`)
- Special offers (`/promotions`)

### Manager Dashboard

- Dashboard (`/dashboard`)
- Service management (`/manager/service`)
- Service type management (`/manager/servicetype`)
- Staff management (`/staff`)
- User management (`/user/list`)
- Category management (`/category/list`)
- Blog management (`/blog`)
- Spa info (`/spa-info`)

### Marketing Portal

- Promotion management (`/promotion/list`)
- View promotions (`/promotions`)
- Service reviews (`/service-review`)
- QR code generation (`/qr/generate`)

### Admin Panel

- Customer management (`/customer/list`)
- System test (`/test`)
- Auto check-in (`/autocheckin`)
- System settings (`/admin/settings`)

### Therapist Interface

- Daily schedule (`/therapist/schedule`)
- Appointment management (`/appointment`)
- Client records (`/therapist/clients`)
- Treatment notes (`/therapist/notes`)

### Common Pages (All Roles)

- Services (`/services`)
- About us (`/about`)
- Contact (`/contact`)
- Settings/Profile (`/profile`)

## Notes

1. **Commented Controllers**: `CustomerController` has its `@WebServlet` annotation commented out but is mapped in web.xml instead.

2. **Missing Controllers**: Some URLs in the original sidebar don't have corresponding controllers yet (e.g., `/therapist/*`, `/admin/*` specific routes).

3. **API Endpoints**: All `/api/*` endpoints are not included in sidebar navigation as they are backend services.

4. **Role-Based Access**: The sidebar dynamically shows different navigation options based on user roles (CUSTOMER, MANAGER, ADMIN, THERAPIST, MARKETING).

5. **Authentication Required**: Most controllers require authentication except for public pages like `/about`, `/contact`, `/services`, `/login`, and `/register`.

## Updated Sidebar Implementation

The sidebar has been updated to include only the controllers that actually exist in the codebase, ensuring all navigation links point to valid endpoints. Placeholder links for non-existent controllers have been removed to prevent 404 errors.
