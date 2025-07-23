# Spa Management System - Actors Documentation

## Table of Contents
1. [Human Actors](#human-actors)
2. [System Actors](#system-actors)
3. [External System Actors](#external-system-actors)
4. [Automated System Actors](#automated-system-actors)

---

## Human Actors

### 1. Administrator
**Role ID:** 1  
**System Name:** ADMIN  
**Display Name:** Quản trị viên

**Description:**  
The Administrator is the system's superuser with full access privileges across all modules and functionalities. They have complete control over the spa management system and are responsible for overall system governance.

**Key Responsibilities:**
- Complete system administration and configuration
- Managing all user accounts and role assignments
- Full access to all modules (manager, therapist, receptionist, marketing, inventory)
- System monitoring and maintenance oversight
- Managing lower-level users (Managers, Marketing staff, etc.)
- Blog content management and customer feedback oversight
- Database administration and system security

**Access Permissions:**
- All system URLs and API endpoints
- User management for all roles
- Complete CRUD operations on all entities
- System configuration and settings
- Analytics and reporting access
- Payment management and financial oversight

---

### 2. Manager
**Role ID:** 2  
**System Name:** MANAGER  
**Display Name:** Quản lý Spa

**Description:**  
The Manager is responsible for day-to-day spa operations and has extensive administrative privileges. They oversee staff, services, and business operations while reporting to the Administrator.

**Key Responsibilities:**
- Daily spa operations management
- Staff scheduling and work assignment monitoring
- Service catalog management (services, service types)
- Customer management and relationship oversight
- Analytics and reporting review
- Payment processing and financial management
- Staff performance monitoring
- Customer feedback review and response

**Access Permissions:**
- Manager dashboard and analytics
- Staff management (therapists, receptionists)
- Service and service type management
- Customer management interface
- Appointment and booking oversight
- Payment management and statistics
- Scheduling and resource allocation
- Reports and business analytics

---

### 3. Therapist
**Role ID:** 3  
**System Name:** THERAPIST  
**Display Name:** Kỹ thuật viên

**Description:**  
Therapists are the service providers who directly interact with customers to deliver spa treatments and services. They manage their schedules and update service statuses.

**Key Responsibilities:**
- Providing spa services and treatments to customers
- Managing personal work schedules and availability
- Updating appointment and service status
- Maintaining treatment records and customer notes
- Ensuring service quality and customer satisfaction
- Following spa protocols and safety procedures

**Access Permissions:**
- Personal schedule management
- Appointment viewing and status updates
- Treatment history access
- Customer service records
- Personal profile management
- Service-related documentation access

---

### 4. Receptionist
**Role ID:** 4  
**System Name:** RECEPTIONIST  
**Display Name:** Lễ tân

**Description:**  
Receptionists are the front-line staff responsible for customer service, appointment management, and basic administrative tasks. They serve as the primary point of contact for customers.

**Key Responsibilities:**
- Customer check-in and check-out processes
- Appointment booking and scheduling
- Customer inquiry handling and support
- Payment processing and transaction management
- Customer database maintenance
- Front desk operations and customer service
- Problem resolution and conflict management

**Access Permissions:**
- Appointment booking and management
- Customer database access
- Payment processing interface
- Schedule viewing and basic modifications
- Customer service tools
- Basic reporting access

---

### 5. Customer
**Role ID:** 5  
**System Name:** CUSTOMER  
**Display Name:** Khách hàng đã đăng ký

**Description:**  
Registered customers with accounts in the system. They can book services, manage their profiles, view history, and access personalized features that guests cannot.

**Key Responsibilities:**
- Booking and managing appointments
- Maintaining personal profile information
- Making payments for services
- Providing feedback and reviews
- Managing loyalty points and rewards
- Communicating with spa staff

**Access Permissions:**
- Personal dashboard and profile management
- Service booking and appointment management
- Payment history and transaction records
- Loyalty points and rewards tracking
- Feedback and review submission
- Personal communication with staff

---

### 6. Marketing Personnel
**Role ID:** 6  
**System Name:** MARKETING  
**Display Name:** Quản trị marketing

**Description:**  
Marketing staff handle promotional activities, customer engagement, and marketing communications. They focus on customer acquisition and retention through various marketing initiatives.

**Key Responsibilities:**
- Creating and managing promotional campaigns
- Discount coupon creation and management
- Customer communication and email marketing
- Social media and digital marketing activities
- Customer feedback analysis for marketing insights
- Promotional event planning and execution
- Customer engagement and retention strategies

**Access Permissions:**
- Marketing dashboard and tools
- Promotion and coupon management
- Customer communication systems
- Marketing analytics and reports
- Customer feedback review
- Campaign management tools

---

### 7. Inventory Manager
**Role ID:** 7  
**System Name:** INVENTORY_MANAGER  
**Display Name:** Quản lý kho

**Description:**  
Inventory Managers are responsible for managing spa supplies, products, and inventory levels. They ensure adequate stock levels and manage procurement processes.

**Key Responsibilities:**
- Inventory tracking and management
- Stock level monitoring and replenishment
- Supplier relationship management
- Product catalog maintenance
- Inventory reporting and analytics
- Cost management and budgeting
- Quality control for spa products

**Access Permissions:**
- Inventory management system
- Product catalog administration
- Supplier management interface
- Inventory reports and analytics
- Stock level monitoring tools
- Procurement management system

---

## System Actors

### 8. Guest User
**System Name:** GUEST  
**Display Name:** Khách

**Description:**  
Unregistered users who can browse the spa website and explore services without creating an account. They have limited access but can initiate booking processes.

**Key Responsibilities:**
- Browsing publicly available spa information
- Viewing service catalogs and pricing
- Initiating booking processes (with session management)
- Exploring spa facilities and offerings
- Accessing basic contact information

**Access Permissions:**
- Public website content
- Service catalog viewing
- Basic booking initiation
- Contact information access
- Public promotional content

**Technical Implementation:**
- Session-based temporary data storage
- Browser session identification
- Conversion tracking to registered customers
- Limited booking session management

---

## External System Actors

### 9. VNPAY Payment Gateway
**System Name:** VNPAY  
**Integration Type:** Third-party Payment Processor

**Description:**  
VNPAY is a third-party payment gateway that processes online transactions for the spa management system. It handles secure payment processing and returns transaction results.

**Key Responsibilities:**
- Processing online payment transactions
- Secure handling of payment information
- Transaction verification and validation
- Payment status reporting (success/failure)
- Refund processing when required
- Compliance with financial regulations

**Integration Points:**
- Payment processing API
- Transaction callback handling
- Payment status updates
- Refund processing interface
- Security token management

**Supported Payment Methods:**
- Bank transfers
- Credit/debit cards
- Digital wallet payments
- QR code payments

---

### 10. Email Service (Gmail/SMTP)
**System Name:** EMAIL_SERVICE  
**Integration Type:** Email Communication System

**Description:**  
The automated email service handles all system-generated communications with customers and staff. It processes various types of notifications and confirmations.

**Key Responsibilities:**
- Sending appointment confirmations
- Email verification for new accounts
- Password reset notifications
- Promotional email campaigns
- Payment confirmation emails
- System notifications to staff
- Customer communication delivery

**Email Types Handled:**
- Account verification emails
- Appointment confirmations and reminders
- Payment receipts and confirmations
- Password reset instructions
- Promotional campaigns
- System notifications
- Customer service communications

---

## Automated System Actors

### 11. Chatbot AI
**System Name:** CHATBOT_AI  
**Integration Type:** AI-Powered Customer Service

**Description:**  
An AI-powered chatbot that provides automated customer support, answers frequently asked questions, and assists with basic spa inquiries and booking guidance.

**Key Responsibilities:**
- Providing 24/7 customer support
- Answering frequently asked questions
- Assisting with service information
- Guiding customers through booking processes
- Handling basic customer inquiries
- Escalating complex issues to human staff
- Collecting customer feedback

**Capabilities:**
- Natural language processing
- Service information retrieval
- Basic booking assistance
- FAQ responses
- Customer inquiry routing
- Multi-language support (Vietnamese)

---

### 12. Notification System
**System Name:** NOTIFICATION_SYSTEM  
**Integration Type:** Automated Notification Engine

**Description:**  
An automated system that generates and manages notifications based on various triggers and events within the spa management system.

**Key Responsibilities:**
- Payment completion notifications
- Booking confirmation alerts
- Appointment reminders
- System status notifications
- Staff assignment alerts
- Customer communication triggers
- Administrative notifications

**Trigger Events:**
- Payment status changes
- Booking creations and modifications
- Appointment scheduling
- System events and errors
- User account activities
- Promotional campaign launches

---

### 13. Promotion Scheduler
**System Name:** PROMOTION_SCHEDULER  
**Integration Type:** Automated Task Scheduler

**Description:**  
An automated background service that manages promotional campaigns, updates promotion statuses, and handles time-based promotional activities.

**Key Responsibilities:**
- Automatic promotion status updates
- Time-based promotion activation/deactivation
- Promotional campaign scheduling
- Discount code management
- Promotional analytics tracking
- Campaign performance monitoring

**Scheduling Features:**
- Runs every 5 minutes for status updates
- Automatic promotion lifecycle management
- Time-based activation and expiration
- Campaign performance tracking
- Promotional rule enforcement

---

### 14. Database Triggers
**System Name:** DATABASE_TRIGGERS  
**Integration Type:** Database Automation

**Description:**  
Automated database triggers that respond to data changes and maintain system consistency, generate notifications, and enforce business rules.

**Key Responsibilities:**
- Payment completion notification generation
- Booking creation notifications
- Data consistency maintenance
- Automatic timestamp updates
- Business rule enforcement
- Audit trail generation

**Trigger Types:**
- Payment status change triggers
- Booking creation triggers
- User activity triggers
- Data validation triggers
- Notification generation triggers
- Audit logging triggers

---

*This document provides a comprehensive overview of all actors that interact with the Spa Management System, including their roles, responsibilities, and access permissions.*
