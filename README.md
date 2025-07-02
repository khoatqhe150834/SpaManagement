# SpaOnline Management System

## Project Overview

SpaOnline is a comprehensive web-based spa management system designed to automate and streamline operations for spa businesses. The application provides features for appointment scheduling, customer management, service catalog, employee management, and reporting.

## Features

- **User Authentication & Authorization**
  - Role-based access control (Admin, Manager, Therapist, Receptionist, Customer)
  - Secure registration and login
- **Customer Management**
  - Customer profiles with contact information and preferences
  - Customer loyalty program
  - Service history tracking
- **Appointment Scheduling**
  - Online booking system
  - Availability calendar
  - Appointment notifications and reminders
- **Service Management**
  - Service catalog with descriptions and pricing
  - Special packages and promotions
- **Staff Management**
  - Employee scheduling
  - Therapist specialization and availability
- **Reports & Analytics**
  - Sales reports
  - Customer analytics
  - Service popularity metrics

## Technologies

- **Backend**
  - Java Servlets
  - JSP (JavaServer Pages)
  - JSTL (JavaServer Pages Standard Tag Library)
- **Frontend**
  - HTML5, CSS3, JavaScript
  - Bootstrap framework
  - Custom responsive design
- **Database**
  - MySQL
- **Security**
  - BCrypt password hashing
  - Input validation and sanitization
- **Development Tools**
  - NetBeans IDE
  - Git version control
  - Maven for dependency management

## Project Structure

```
SpaOnline/
├── src/
│   └── java/
│       ├── controller/  # Servlet controllers
│       ├── dao/         # Data Access Objects
│       ├── db/          # Database connection management
│       ├── model/       # Business models
│       ├── sql/         # SQL scripts
│       └── validation/  # Form validation logic
├── web/
│   ├── css/             # Stylesheets
│   ├── images/          # Image assets
│   ├── js/              # JavaScript files
│   ├── plugins/         # External libraries
│   └── WEB-INF/
│       └── view/        # JSP views
│           ├── auth/    # Authentication pages
│           ├── common/  # Shared components
│           └── template/ # Page templates
└── test/                # Unit tests
```

## Setup Instructions

1. **Prerequisites**

   - JDK 8 or higher
   - Apache Tomcat 9+
   - MySQL 8.0+
   - NetBeans IDE

2. **Database Setup**

   - Create a MySQL database
   - Execute the SQL scripts located in `src/java/sql/` in the following order:
     1. `spa_schema.sql`
     2. `spa_data.sql`

3. **Configure Database Connection**

   - Update the connection parameters in `src/java/db/DBContext.java`

4. **Build and Deploy**
   - Open the project in NetBeans
   - Resolve dependencies using Maven
   - Build the project and deploy to Tomcat

## Running the Application

1. Start the Tomcat server
2. Access the application at `http://localhost:8080/spa/`
3. Default admin login:
   - Email: admin@spa.com
   - Password: admin123

## Development

### Branching Strategy

- `master` - Production-ready code
- `develop` - Development integration branch
- `feature/*` - New features
- `bugfix/*` - Bug fixes

### Coding Conventions

- Follow Java code conventions
- Use camelCase for variables and methods
- Use PascalCase for class names
- Prefix interfaces with "I"
- Use meaningful names and add comments

## Contributors

- [Your Name] - Project Lead

# G1 Spa Management System - Filter Documentation

## 🛡️ Security Filter System Overview

This project implements a comprehensive middleware filter system for handling authentication, authorization, and security concerns in a Java Servlets/JSP web application. The filter system eliminates the need for repetitive security checks in individual controllers and provides centralized security management.

## 📋 Table of Contents

- [Filter Architecture](#filter-architecture)
- [Filter Execution Order](#filter-execution-order)
- [Authentication Filter](#authentication-filter)
- [Authorization Filter](#authorization-filter)
- [Exception Handling Filter](#exception-handling-filter)
- [Configuration](#configuration)
- [Usage in Controllers](#usage-in-controllers)
- [Role-Based Access Control](#role-based-access-control)
- [Error Handling](#error-handling)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## 🏗️ Filter Architecture

The system consists of multiple filters that work together to provide comprehensive security:

```
HTTP Request
    ↓
┌─────────────────────┐
│ AuthenticationFilter │ ← Checks if user is logged in
└─────────────────────┘
    ↓
┌─────────────────────┐
│ AuthorizationFilter  │ ← Checks if user has permission
└─────────────────────┘
    ↓
┌─────────────────────┐
│ExceptionHandlingFilter│ ← Handles global exceptions
└─────────────────────┘
    ↓
┌─────────────────────┐
│    Your Servlet     │ ← Clean business logic only
└─────────────────────┘
```

## ⚡ Filter Execution Order

Filters are executed in the following order (configured in `web.xml`):

1. **AuthenticationFilter** - Ensures user is logged in
2. **AuthorizationFilter** - Checks role-based permissions
3. **ExceptionHandlingFilter** - Handles any exceptions globally

This order is **critical** for proper security and functionality.

## 🔐 Authentication Filter

### Purpose

Ensures users are authenticated before accessing protected resources.

### Key Features

- ✅ Session-based authentication checking
- ✅ Automatic redirection to login for unauthenticated users
- ✅ Excludes public resources (CSS, JS, images, login pages)
- ✅ Sets security headers for authenticated requests
- ✅ AJAX-aware responses (JSON for AJAX, redirects for regular requests)
- ✅ Sets user context in request attributes

### Public Resources (No Authentication Required)

```java
// URLs that don't require authentication
/login, /register, /logout, /, /home, /index
/verify-email, /email-verification-required, /resend-verification
/password/reset, /password/reset-form, /password/change-password
/about, /contact, /services, /blog, /spa, /error

// File extensions that are always public
.css, .js, .png, .jpg, .jpeg, .gif, .ico, .svg
.woff, .woff2, .ttf, .eot, .html, .txt, .xml

// URL patterns that are public
/assets/, /uploads/, /css/, /js/, /images/, /favicon
```

### What It Sets in Request Attributes

```java
// For Staff/Admin users
request.setAttribute("currentUser", user);
request.setAttribute("userRoleId", user.getRoleId());
request.setAttribute("userType", "ADMIN" | "MANAGER" | "THERAPIST" | "RECEPTIONIST");

// For Customers
request.setAttribute("currentCustomer", customer);
request.setAttribute("userRoleId", customer.getRoleId());
request.setAttribute("userType", "CUSTOMER");

// For all authenticated users
request.setAttribute("isAuthenticated", true);
```

### AJAX Support

For AJAX requests, returns JSON instead of redirects:

```json
{
  "error": "Authentication required",
  "redirectUrl": "/context/login"
}
```

## 🎯 Authorization Filter

### Purpose

Enforces role-based access control after authentication is confirmed.

### Role Hierarchy

The system implements a hierarchical permission model:

```
ADMIN (Role ID: 1)
├── Can access EVERYTHING
│
MANAGER (Role ID: 2)
├── Can access: Manager, Therapist, Receptionist areas
├── Cannot access: Admin-specific areas
│
THERAPIST (Role ID: 3)
├── Can access: Therapist areas only
│
RECEPTIONIST (Role ID: 4)
├── Can access: Receptionist areas only
│
CUSTOMER (Role ID: 5)
├── Can access: Customer areas only
│
MARKETING (Role ID: 6)
├── Can access: Marketing areas only
```

### URL-to-Role Mappings

```java
// Admin areas (Role ID: 1)
/admin-dashboard/**, /admin/**
/users/**, /customers/manage/**
/staff/**, /financial/**, /reports/admin/**

// Manager areas (Role ID: 1, 2)
/manager-dashboard/**, /manager/**
/reports/manager/**, /inventory/manage/**

// Therapist areas (Role ID: 1, 2, 3)
/therapist-dashboard/**, /therapist/**
/appointments/therapist/**, /treatments/**

// Receptionist areas (Role ID: 1, 2, 4)
/receptionist-dashboard/**, /receptionist/**
/appointments/receptionist/**, /checkin/**

// Customer areas (Role ID: 1, 2, 5)
/customer-dashboard/**, /customer/**
/booking/**, /profile/**

// Marketing areas (Role ID: 1, 6)
/marketing/**, /promotions/manage/**
```

### Access Denied Handling

- **403 Error Pages**: Different error pages based on user role
  - Staff: `/WEB-INF/view/admin/error-403.jsp`
  - Customers: `/WEB-INF/view/common/error-403.jsp`
- **Security Logging**: Logs all unauthorized access attempts
- **AJAX Support**: Returns JSON error responses for AJAX requests

## ⚠️ Exception Handling Filter

### Purpose

Provides global exception handling with user-friendly error responses.

### Exception Types Handled

- **Security Exceptions**: Authentication/authorization failures
- **Validation Exceptions**: Input validation errors
- **Database Exceptions**: SQL errors, connection issues
- **System Exceptions**: Unexpected runtime errors

### Features

- ✅ Different handling for AJAX vs regular requests
- ✅ Role-appropriate error pages
- ✅ Detailed logging for debugging
- ✅ User-friendly error messages
- ✅ Prevents sensitive information leakage

## ⚙️ Configuration

### web.xml Configuration

```xml
<!-- Authentication Filter -->
<filter>
    <filter-name>AuthenticationFilter</filter-name>
    <filter-class>filter.AuthenticationFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>AuthenticationFilter</filter-name>
    <url-pattern>/*</url-pattern>
    <dispatcher>REQUEST</dispatcher>
    <dispatcher>FORWARD</dispatcher>
    <dispatcher>ERROR</dispatcher>
</filter-mapping>

<!-- Authorization Filter -->
<filter>
    <filter-name>AuthorizationFilter</filter-name>
    <filter-class>filter.AuthorizationFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>AuthorizationFilter</filter-name>
    <url-pattern>/*</url-pattern>
    <dispatcher>REQUEST</dispatcher>
    <dispatcher>FORWARD</dispatcher>
    <dispatcher>ERROR</dispatcher>
</filter-mapping>

<!-- Exception Handling Filter -->
<filter>
    <filter-name>ExceptionHandlingFilter</filter-name>
    <filter-class>filter.ExceptionHandlingFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>ExceptionHandlingFilter</filter-name>
    <url-pattern>/*</url-pattern>
    <dispatcher>REQUEST</dispatcher>
    <dispatcher>FORWARD</dispatcher>
    <dispatcher>ERROR</dispatcher>
</filter-mapping>

<!-- Error Page Configuration -->
<error-page>
    <error-code>403</error-code>
    <location>/WEB-INF/view/common/error-403.jsp</location>
</error-page>
```

### Required Dependencies

Ensure these classes exist in your project:

- `model.User` - Staff/Admin user model
- `model.Customer` - Customer user model
- `model.RoleConstants` - Role constants and utilities
- `util.AuthenticationContext` - Authentication utility class

## 💻 Usage in Controllers

### Before (Old Way) ❌

```java
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) {
    // Lots of repetitive authentication code
    HttpSession session = request.getSession(false);
    if (session == null || !Boolean.TRUE.equals(session.getAttribute("authenticated"))) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    User user = (User) session.getAttribute("user");
    Customer customer = (Customer) session.getAttribute("customer");

    if (user == null && customer == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    // Role checking logic...
    // Finally, business logic
}
```

### After (New Way) ✅

```java
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) {
    // Clean and simple - filters handle all security concerns
    User user = (User) request.getAttribute("currentUser");
    Customer customer = (Customer) request.getAttribute("currentCustomer");
    String userType = (String) request.getAttribute("userType");
    Integer userRoleId = (Integer) request.getAttribute("userRoleId");

    // Pure business logic only!
    // User is GUARANTEED to be authenticated and authorized
}
```

### Available Request Attributes

All controllers can access these attributes set by the filters:

```java
// User objects (one will be null, the other will have the current user)
User currentUser = (User) request.getAttribute("currentUser");
Customer currentCustomer = (Customer) request.getAttribute("currentCustomer");

// User metadata
Integer userRoleId = (Integer) request.getAttribute("userRoleId");
String userType = (String) request.getAttribute("userType");
Boolean isAuthenticated = (Boolean) request.getAttribute("isAuthenticated");
```

## 👥 Role-Based Access Control

### Role Constants

```java
public class RoleConstants {
    public static final int ADMIN_ID = 1;
    public static final int MANAGER_ID = 2;
    public static final int THERAPIST_ID = 3;
    public static final int RECEPTIONIST_ID = 4;
    public static final int CUSTOMER_ID = 5;
    public static final int MARKETING_ID = 6;
}
```

### Permission Matrix

| URL Pattern        | Admin | Manager | Therapist | Receptionist | Customer | Marketing |
| ------------------ | ----- | ------- | --------- | ------------ | -------- | --------- |
| `/admin/**`        | ✅    | ❌      | ❌        | ❌           | ❌       | ❌        |
| `/manager/**`      | ✅    | ✅      | ❌        | ❌           | ❌       | ❌        |
| `/therapist/**`    | ✅    | ✅      | ✅        | ❌           | ❌       | ❌        |
| `/receptionist/**` | ✅    | ✅      | ❌        | ✅           | ❌       | ❌        |
| `/customer/**`     | ✅    | ✅      | ❌        | ❌           | ✅       | ❌        |
| `/marketing/**`    | ✅    | ❌      | ❌        | ❌           | ❌       | ✅        |
| `/profile/**`      | ✅    | ✅      | ✅        | ✅           | ✅       | ✅        |

### Adding New Protected URLs

To add new protected URLs, update the `URL_ROLE_MAPPINGS` in `AuthorizationFilter.java`:

```java
URL_ROLE_MAPPINGS.put("/new-feature", new HashSet<>(Arrays.asList(
    RoleConstants.ADMIN_ID,
    RoleConstants.MANAGER_ID
)));
```

## 🚨 Error Handling

### Custom Error Pages

The system provides role-appropriate error pages:

**Staff Error Page** (`/WEB-INF/view/admin/error-403.jsp`):

- Professional admin-style layout
- Links to admin dashboard
- Contact information for support

**Customer Error Page** (`/WEB-INF/view/common/error-403.jsp`):

- Customer-friendly design
- Links to homepage and customer areas
- Helpful suggestions

### AJAX Error Responses

For AJAX requests, the system returns JSON responses:

```json
{
  "error": "Access denied",
  "message": "You don't have permission to access this resource",
  "redirectUrl": "/appropriate-error-page"
}
```

### Security Logging

All security events are logged:

```
[SECURITY WARNING] Unauthorized access attempt:
User=Customer(ID:123, Email:user@example.com),
Role=CUSTOMER, Path=/admin/users,
IP=192.168.1.100, UserAgent=Mozilla/5.0...
```

## ✅ Best Practices

### 1. Controller Design

```java
// ✅ DO: Keep controllers clean
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) {
    User user = (User) request.getAttribute("currentUser");
    // Business logic only
}

// ❌ DON'T: Add authentication checks in controllers
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) {
    HttpSession session = request.getSession(false);
    if (session == null) { /* ... */ } // Filters handle this!
}
```

### 2. Adding New Public URLs

To make a URL public (no authentication required), add it to `AuthenticationFilter.java`:

```java
private static final Set<String> PUBLIC_URLS = new HashSet<>(Arrays.asList(
    "/login", "/register", "/your-new-public-url"
));
```

### 3. Security Headers

The filters automatically add security headers:

- `X-Frame-Options: DENY`
- `X-Content-Type-Options: nosniff`
- `X-XSS-Protection: 1; mode=block`

### 4. Session Management

- Sessions are handled centrally by filters
- Controllers don't need to manage session creation/validation
- Automatic session cleanup on logout

## 🔧 Troubleshooting

### Common Issues

#### 1. Filter Order Problems

**Symptom**: User gets authenticated but authorization fails
**Solution**: Check `web.xml` filter order - AuthenticationFilter must come before AuthorizationFilter

#### 2. Infinite Redirect Loops

**Symptom**: Page keeps redirecting to login
**Solution**: Ensure login page (`/login`) is in the PUBLIC_URLS list

#### 3. Static Resources Not Loading

**Symptom**: CSS/JS files return 401/403 errors
**Solution**: Check that file extensions are in PUBLIC_EXTENSIONS list

#### 4. AJAX Requests Failing

**Symptom**: AJAX calls get HTML login page instead of JSON
**Solution**: Ensure AJAX requests include proper headers (`X-Requested-With: XMLHttpRequest`)

#### 5. Role-Based Access Not Working

**Symptom**: Users can access areas they shouldn't
**Solution**: Verify URL patterns in `URL_ROLE_MAPPINGS` and check role constants

### Debug Tips

1. **Enable Filter Logging**: Add logging statements to see filter execution
2. **Check Request Attributes**: Print request attributes in controllers to verify filter data
3. **Test Role Mappings**: Create test cases for each role/URL combination
4. **Monitor Security Logs**: Watch for unauthorized access attempts

### Performance Considerations

- Filters run on **every request** - keep them lightweight
- Static resources are excluded to avoid unnecessary processing
- Session validation is cached per request
- Database queries are minimized in filters

## 📚 Additional Resources

### Related Files

- `src/main/java/filter/AuthenticationFilter.java` - Authentication logic
- `src/main/java/filter/AuthorizationFilter.java` - Authorization logic
- `src/main/java/filter/ExceptionHandlingFilter.java` - Exception handling
- `src/main/java/util/AuthenticationContext.java` - Utility methods
- `src/main/java/model/RoleConstants.java` - Role definitions
- `src/main/webapp/WEB-INF/web.xml` - Filter configuration

### Security Best Practices

1. Always use HTTPS in production
2. Set secure session cookies
3. Implement CSRF protection for forms
4. Regular security audits of filter logic
5. Keep role mappings up to date

---

## 🎯 Summary

This filter system provides:

- ✅ **Centralized Security**: All authentication/authorization in one place
- ✅ **Clean Controllers**: No more repetitive security code
- ✅ **Role-Based Access**: Hierarchical permission system
- ✅ **AJAX Support**: Modern web application compatibility
- ✅ **Error Handling**: User-friendly error pages and responses
- ✅ **Performance**: Optimized for minimal overhead
- ✅ **Maintainability**: Easy to update and extend

Your controllers can now focus purely on business logic while the filter system handles all cross-cutting security concerns automatically!
