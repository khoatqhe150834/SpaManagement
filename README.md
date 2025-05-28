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
