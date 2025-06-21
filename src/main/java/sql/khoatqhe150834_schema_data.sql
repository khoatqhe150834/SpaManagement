# Spa Management System - Booking Session Architecture

## Table of Contents
1. [Overview](#overview)
2. [Database Design](#database-design)
3. [Session Management Strategy](#session-management-strategy)
4. [Implementation Guide](#implementation-guide)
5. [Registration-Required Flow](#registration-required-flow)
6. [Code Examples](#code-examples)
7. [Best Practices](#best-practices)
8. [Troubleshooting](#troubleshooting)

---

## Overview

### Problem Statement
The spa booking system needs to handle:
- **Multiple services per booking** (e.g., massage + facial + manicure)
- **Session persistence** across page reloads and browser crashes
- **Registration-required booking flow** for all users
- **Temporary data storage** during the booking process
- **Clean separation** between booking process and final bookings

### Solution Architecture
A simplified approach with registration-required flow:
- **Temporary Layer**: `booking_sessions` table for in-progress bookings
- **Permanent Layer**: `booking_groups` + `booking_appointments` for confirmed bookings
- **Registration Required**: All users must register before payment

---

## Database Design

### Implemented Database Architecture

#### 1. Booking Sessions Table (Temporary Process Data)
```sql
CREATE TABLE `booking_sessions` (
  `session_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_id` int DEFAULT NULL,                    -- NULL until customer registers
  `session_data` json NOT NULL,                     -- All booking selections
  `current_step` enum('services','therapists','time','registration','payment') COLLATE utf8mb4_unicode_ci DEFAULT 'services',
  `expires_at` timestamp NOT NULL,                  -- Session expiration
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  PRIMARY KEY (`session_id`),
  KEY `idx_customer_id` (`customer_id`),
  KEY `idx_expires_at` (`expires_at`),
  CONSTRAINT `booking_sessions_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### 2. Booking Groups Table (Master Booking Record)
```sql
CREATE TABLE `booking_groups` (
  `booking_group_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,                       -- Always required (after registration)
  `booking_date` date NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `payment_status` enum('PENDING','PAID') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `booking_status` enum('CONFIRMED','IN_PROGRESS','COMPLETED','CANCELLED') COLLATE utf8mb4_unicode_ci DEFAULT 'CONFIRMED',
  `payment_method` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'ONLINE_BANKING',
  `special_notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  PRIMARY KEY (`booking_group_id`),
  KEY `idx_customer_booking_date` (`customer_id`,`booking_date`),
  KEY `idx_booking_status` (`booking_status`),
  CONSTRAINT `booking_groups_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### 3. Individual Service Appointments Table
```sql
CREATE TABLE `booking_appointments` (
  `appointment_id` int NOT NULL AUTO_INCREMENT,
  `booking_group_id` int NOT NULL,
  `service_id` int NOT NULL,
  `therapist_user_id` int NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `service_price` decimal(8,2) NOT NULL,
  `status` enum('SCHEDULED','IN_PROGRESS','COMPLETED','CANCELLED') COLLATE utf8mb4_unicode_ci DEFAULT 'SCHEDULED',
  `service_notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  PRIMARY KEY (`appointment_id`),
  KEY `idx_booking_group` (`booking_group_id`),
  KEY `idx_therapist_time` (`therapist_user_id`,`start_time`),
  KEY `idx_service_status` (`service_id`,`status`),
  CONSTRAINT `booking_appointments_ibfk_1` FOREIGN KEY (`booking_group_id`) REFERENCES `booking_groups` (`booking_group_id`) ON DELETE CASCADE,
  CONSTRAINT `booking_appointments_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`),
  CONSTRAINT `booking_appointments_ibfk_3` FOREIGN KEY (`therapist_user_id`) REFERENCES `therapists` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Session Data JSON Structure
```json
{
  "selectedServices": [
    {
      "serviceId": 5,
      "serviceName": "Swedish Massage",
      "therapistUserId": 101,
      "therapistName": "Alice Johnson",
      "estimatedPrice": 1200000,
      "estimatedDuration": 60,
      "scheduledTime": "2024-01-15T10:00:00",
      "serviceOrder": 1
    },
    {
      "serviceId": 8,
      "serviceName": "Deep Cleansing Facial",
      "therapistUserId": 102,
      "therapistName": "Bob Smith",
      "estimatedPrice": 950000,
      "estimatedDuration": 45,
      "scheduledTime": "2024-01-15T11:15:00",
      "serviceOrder": 2
    }
  ],
  "totalAmount": 2150000,
  "totalDuration": 105,
  "selectedDate": "2024-01-15",
  "paymentMethod": "ONLINE_BANKING",
  "specialNotes": "First time customer, allergic to lavender"
}
```

---

## Session Management Strategy

### Registration-Required Flow

Both guests and existing customers follow a similar flow, but guests must register before payment:

#### Guest User Flow: