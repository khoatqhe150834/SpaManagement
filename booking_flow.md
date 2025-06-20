# BeautyZone Spa - Complete Booking Process Flow

## Overview

This document outlines the complete end-to-end booking process for the BeautyZone Spa Management System, from initial service selection to final confirmation and notification.

## Complete Booking Flow

### 1. 📋 **Booking Selection**

- **URL**: `/appointments` or `/booking`
- **Controller**: `BookingController`
- **Description**: Customer initiates the booking process
- **Features**:
  - Landing page for booking appointments
  - Overview of available booking options
  - Introduction to the booking process

### 2. 🏷️ **Choose Service**

- **URL**: `/appointments/services` or `/services-selection`
- **Controller**: `BookingController.handleServicesSelection()`
- **JSP**: `/WEB-INF/view/customer/appointments/services-selection.jsp`
- **Description**: Customer selects spa services they want to book
- **Features**:
  - Dynamic service loading from database via REST API
  - Service filtering by category/type (dropdown with service types)
  - Price range filtering (0 - 10,000,000 VND with 100,000 VND steps)
  - Search functionality for service names
  - Maximum 6 services selection limit
  - Real-time price calculation
  - Service information with icons (spa, clock, price tag)
  - Vietnamese currency formatting
- **APIs Used**:
  - `/api/service-types` - Fetch all service categories
  - `/api/services` - Fetch filtered services
- **Technology**:
  - JavaScript with async/await for API calls
  - CSS with spa-themed design variables
  - Iconify icons for visual elements

### 3. 👨‍⚕️ **Choose Therapist**

- **URL**: `/appointments/therapist` or `/therapist-selection`
- **Controller**: `BookingController.handleTherapistSelection()`
- **Description**: Customer selects their preferred therapist/staff member
- **Features** (To be implemented):
  - Display available therapists for selected services
  - Show therapist profiles, ratings, and specializations
  - Filter by availability and expertise
  - Display therapist schedules and availability

### 4. ⏰ **Choose Time** _(Current Implementation)_

- **URL**: `/appointments/time-selection` or `/time-selection`
- **Controller**: `BookingController.handleTimeSelection()`
- **JSP**: `/WEB-INF/view/customer/appointments/time-selection.jsp`
- **CSS**: `/assets/home/css/time-selection.css`
- **JS**: `/assets/home/js/time-selection.js`
- **Description**: Customer selects their preferred appointment date and time
- **Features**:
  - Interactive calendar with Vietnamese month names
  - Date selection with visual feedback
  - Availability checking for selected therapist
  - User/therapist selector dropdown
  - Real-time availability status display
  - Alternative options (next available date, waitlist)
  - Order summary with business info and service details
  - Responsive design for mobile and desktop
- **Technology**:
  - Iconify icons for UI elements (`mdi:chevron-left`, `mdi:chevron-right`, `mdi:calendar`, `mdi:star`)
  - Spa-themed CSS with consistent color scheme
  - JavaScript for calendar navigation and date selection

### 5. 💳 **Process Payment**

- **URL**: `/appointments/payment` or `/payment`
- **Controller**: `PaymentController` (To be implemented)
- **Description**: Customer completes payment for their booking
- **Features** (To be implemented):
  - Multiple payment methods (credit card, bank transfer, cash)
  - Payment amount confirmation
  - Invoice generation
  - Payment security and validation
  - Integration with payment gateways (VNPay, MoMo, etc.)

### 6. ✅ **Booking Confirmation**

- **URL**: `/appointments/confirmation` or `/booking-confirmation`
- **Controller**: `BookingController.handleConfirmation()`
- **Description**: Final confirmation and booking creation in database
- **Features** (To be implemented):
  - Save complete booking details to database
  - Generate unique booking reference number
  - Display booking summary and confirmation details
  - Booking status updates

### 7. 📧 **Send Email and Notification**

- **Service**: `AsyncEmailService`, `EmailService`
- **Description**: Automated communication to customer and staff
- **Features**:
  - **Customer Email**: Booking confirmation with details
  - **Staff Notification**: Alert therapist about new appointment
  - **Calendar Integration**: Add appointment to calendars
  - **SMS Notifications**: Optional text message confirmations
  - **Reminder System**: Automated reminders before appointment

## Technical Architecture

### Backend Components

- **Controllers**: Handle HTTP requests and route to appropriate services
- **Services**: Business logic for booking, email, and notifications
- **DAOs**: Database access for appointments, services, customers, staff
- **Models**: Java entities for Appointment, Service, Customer, Staff
- **APIs**: REST endpoints for dynamic data loading

### Frontend Components

- **JSP Pages**: Server-side rendered pages with JSTL
- **CSS**: Spa-themed responsive design with CSS variables
- **JavaScript**: Interactive features and API integration
- **Icons**: Iconify for consistent and scalable icons

### Database Integration

- **MySQL Database**: Stores all booking and business data
- **Tables**: appointments, services, service_types, customers, staff, payments
- **Relationships**: Foreign keys linking appointments to services, customers, staff

### Email System

- **Asynchronous Processing**: Non-blocking email sending
- **Template System**: Professional email templates
- **Multi-recipient**: Customer and staff notifications
- **Error Handling**: Retry mechanisms and failure logging

## Key Features Implemented

### Service Selection Page

✅ **Complete Implementation**

- Database integration with REST APIs
- Dynamic service type filtering
- Price range with Vietnamese currency
- Service limit enforcement (max 6)
- Responsive design with professional UI
- Real-time search and filtering

### Time Selection Page

✅ **Complete Implementation**

- Calendar interface with Vietnamese localization
- Therapist availability checking
- Order summary and business information
- Mobile-responsive design
- Iconify icon integration

### Email System

✅ **Complete Implementation**

- Asynchronous email service
- Registration and verification emails
- Professional email templates

## Next Steps for Full Implementation

1. **Therapist Selection Page**

   - Create therapist-selection.jsp
   - Implement therapist availability API
   - Add therapist profile displays

2. **Payment Processing**

   - Integrate payment gateways
   - Create payment confirmation pages
   - Implement invoice generation

3. **Booking Confirmation**

   - Complete booking database operations
   - Generate booking reference numbers
   - Create confirmation pages

4. **Enhanced Notifications**
   - SMS notification integration
   - Calendar integration (iCal, Google Calendar)
   - Automated reminder system

## File Structure

```
src/main/webapp/
├── WEB-INF/view/customer/appointments/
│   ├── services-selection.jsp      ✅ Complete
│   ├── time-selection.jsp          ✅ Complete
│   ├── therapist-selection.jsp     ⏳ To be created
│   ├── payment.jsp                 ⏳ To be created
│   └── confirmation.jsp            ⏳ To be created
├── assets/home/css/
│   ├── sevices-selection.css       ✅ Complete
│   ├── time-selection.css          ✅ Complete
│   └── booking-common.css          ⏳ To be created
└── assets/home/js/
    ├── service-selection.js        ✅ Complete
    ├── time-selection.js           ✅ Complete
    └── booking-common.js           ⏳ To be created
```

## Status Summary

- **Service Selection**: ✅ Complete with database integration
- **Time Selection**: ✅ Complete with Iconify icons
- **Therapist Selection**: ⏳ Planned
- **Payment Processing**: ⏳ Planned
- **Email Notifications**: ✅ Complete infrastructure
- **Booking Confirmation**: ⏳ Planned

This comprehensive booking flow ensures a smooth, professional experience for customers booking spa services at BeautyZone.
