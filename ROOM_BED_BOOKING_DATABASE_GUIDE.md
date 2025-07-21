# Room and Bed Management Database Implementation Guide
## G1_SpaManagement System

### Table of Contents
1. [Overview](#overview)
2. [Database Schema Analysis](#database-schema-analysis)
3. [Table Design Specifications](#table-design-specifications)
4. [Integration Requirements](#integration-requirements)
5. [Migration Guide](#migration-guide)
6. [DAO Implementation](#dao-implementation)
7. [Booking Workflow](#booking-workflow)
8. [Business Logic](#business-logic)
9. [Technical Considerations](#technical-considerations)
10. [Use Cases](#use-cases)

---

## 1. Overview

### System Benefits
The room and bed management system provides:
- **Resource Optimization**: Efficient allocation of spa rooms and treatment beds
- **Conflict Prevention**: Automated double-booking prevention for physical resources
- **Enhanced Scheduling**: Room-specific service assignments and therapist coordination
- **Operational Efficiency**: Real-time room/bed availability tracking and utilization reporting

### Architecture Integration
```
┌─────────────────┐    Booking    ┌─────────────────┐    Assignment    ┌─────────────────┐
│   Customer      │ ──────────────→ │   Services      │ ──────────────→ │   Rooms/Beds    │
│   Bookings      │                │   Scheduling    │                │   Management    │
└─────────────────┘                └─────────────────┘                └─────────────────┘
```

### Integration with Existing System
- Extends current booking architecture from `src/main/java/sql/schema_data_main.sql`
- Maintains compatibility with existing `bookings`, `services`, `customers`, and `payments` tables
- Preserves two-step booking process (payment → scheduling → room/bed assignment)
- Compatible with existing user roles and authentication system

---

## 2. Database Schema Analysis

### Current Booking System Structure
Based on `src/main/java/sql/schema_data_main.sql`:

#### Existing Bookings Table
```sql
CREATE TABLE bookings (
    booking_id INT NOT NULL AUTO_INCREMENT,
    customer_id INT NOT NULL,
    payment_item_id INT NOT NULL,
    service_id INT NOT NULL,
    therapist_user_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    duration_minutes INT NOT NULL,
    booking_status ENUM('SCHEDULED', 'CONFIRMED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'NO_SHOW') DEFAULT 'SCHEDULED',
    booking_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (booking_id)
);
```

#### Integration Points
- **Services Table**: Links to room requirements and service types
- **Customers Table**: Customer information and preferences
- **Payments/Payment_Items**: Financial validation before room assignment
- **Users Table**: Therapist assignments and room access permissions

---

## 3. Table Design Specifications

### Rooms Table
```sql
CREATE TABLE rooms (
    room_id INT NOT NULL AUTO_INCREMENT,
    room_number VARCHAR(20) NOT NULL UNIQUE COMMENT 'Số phòng (VD: R101, VIP-01)',
    room_name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên phòng',
    room_type ENUM('PRIVATE', 'SHARED', 'VIP', 'COUPLE', 'GROUP', 'TREATMENT', 'RELAXATION') NOT NULL COMMENT 'Loại phòng',
    floor_number INT NOT NULL DEFAULT 1 COMMENT 'Tầng',
    capacity INT NOT NULL DEFAULT 1 COMMENT 'Sức chứa tối đa',
    area_sqm DECIMAL(6,2) COMMENT 'Diện tích (m²)',
    room_status ENUM('AVAILABLE', 'OCCUPIED', 'MAINTENANCE', 'CLEANING', 'OUT_OF_ORDER') DEFAULT 'AVAILABLE' COMMENT 'Trạng thái phòng',
    amenities JSON COMMENT 'Tiện nghi phòng (JSON array)',
    pricing_modifier DECIMAL(5,2) DEFAULT 1.00 COMMENT 'Hệ số giá (1.0 = giá chuẩn, 1.5 = +50%)',
    description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Mô tả phòng',
    image_urls JSON COMMENT 'URLs hình ảnh phòng',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Phòng có hoạt động không',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (room_id),
    INDEX idx_room_type (room_type),
    INDEX idx_room_status (room_status),
    INDEX idx_floor_capacity (floor_number, capacity),
    INDEX idx_active_available (is_active, room_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng quản lý phòng spa';
```

### Beds Table
```sql
CREATE TABLE beds (
    bed_id INT NOT NULL AUTO_INCREMENT,
    room_id INT NOT NULL COMMENT 'Phòng chứa giường',
    bed_number VARCHAR(20) NOT NULL COMMENT 'Số giường (VD: B1, B2)',
    bed_name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Tên giường',
    bed_type ENUM('MASSAGE', 'TREATMENT', 'RELAXATION', 'FACIAL', 'BODY', 'COUPLE', 'VIP') NOT NULL COMMENT 'Loại giường',
    bed_status ENUM('AVAILABLE', 'OCCUPIED', 'RESERVED', 'MAINTENANCE', 'CLEANING', 'OUT_OF_ORDER') DEFAULT 'AVAILABLE' COMMENT 'Trạng thái giường',
    equipment JSON COMMENT 'Thiết bị đi kèm (JSON array)',
    features JSON COMMENT 'Tính năng đặc biệt (JSON array)',
    max_weight_kg INT DEFAULT 150 COMMENT 'Trọng lượng tối đa (kg)',
    is_adjustable BOOLEAN DEFAULT TRUE COMMENT 'Có thể điều chỉnh không',
    pricing_modifier DECIMAL(5,2) DEFAULT 1.00 COMMENT 'Hệ số giá giường',
    maintenance_schedule JSON COMMENT 'Lịch bảo trì (JSON object)',
    last_maintenance DATE COMMENT 'Lần bảo trì cuối',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Giường có hoạt động không',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (bed_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY unique_bed_per_room (room_id, bed_number),
    INDEX idx_bed_type (bed_type),
    INDEX idx_bed_status (bed_status),
    INDEX idx_room_bed (room_id, bed_status),
    INDEX idx_active_available (is_active, bed_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng quản lý giường spa';
```

### Room Service Compatibility Table
```sql
CREATE TABLE room_service_compatibility (
    compatibility_id INT NOT NULL AUTO_INCREMENT,
    room_id INT NOT NULL,
    service_id INT NOT NULL,
    is_compatible BOOLEAN DEFAULT TRUE COMMENT 'Phòng có phù hợp với dịch vụ không',
    setup_time_minutes INT DEFAULT 0 COMMENT 'Thời gian chuẩn bị (phút)',
    cleanup_time_minutes INT DEFAULT 0 COMMENT 'Thời gian dọn dẹp (phút)',
    special_requirements JSON COMMENT 'Yêu cầu đặc biệt (JSON object)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (compatibility_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(service_id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY unique_room_service (room_id, service_id),
    INDEX idx_room_compatible (room_id, is_compatible),
    INDEX idx_service_compatible (service_id, is_compatible)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng tương thích phòng-dịch vụ';
```

### Booking Room Assignment Table
```sql
CREATE TABLE booking_room_assignments (
    assignment_id INT NOT NULL AUTO_INCREMENT,
    booking_id INT NOT NULL,
    room_id INT NOT NULL,
    bed_id INT NULL COMMENT 'Giường cụ thể (nếu có)',
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    assignment_status ENUM('ASSIGNED', 'CONFIRMED', 'IN_USE', 'COMPLETED', 'CANCELLED') DEFAULT 'ASSIGNED',
    setup_completed_at TIMESTAMP NULL,
    service_started_at TIMESTAMP NULL,
    service_completed_at TIMESTAMP NULL,
    cleanup_completed_at TIMESTAMP NULL,
    assignment_notes TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (assignment_id),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (bed_id) REFERENCES beds(bed_id) ON DELETE SET NULL ON UPDATE CASCADE,
    UNIQUE KEY unique_booking_assignment (booking_id),
    INDEX idx_room_assignment (room_id, assignment_status),
    INDEX idx_bed_assignment (bed_id, assignment_status),
    INDEX idx_booking_status (booking_id, assignment_status),
    INDEX idx_assignment_timeline (assigned_at, assignment_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng phân công phòng cho booking';
```

---

## 4. Integration Requirements

### Modified Booking Workflow
1. **Payment Validation**: Customer pays for services (existing process)
2. **Service Selection**: Customer selects paid service for booking (existing process)
3. **Room Availability Check**: System checks compatible rooms for selected service
4. **Room/Bed Assignment**: Customer or staff assigns specific room/bed
5. **Booking Confirmation**: Final booking with room assignment
6. **Resource Management**: Real-time status updates for rooms/beds

### Database Relationships
```sql
-- Add room assignment reference to existing bookings table
ALTER TABLE bookings 
ADD COLUMN assigned_room_id INT NULL COMMENT 'Phòng được phân công',
ADD COLUMN assigned_bed_id INT NULL COMMENT 'Giường được phân công',
ADD FOREIGN KEY (assigned_room_id) REFERENCES rooms(room_id) ON DELETE SET NULL,
ADD FOREIGN KEY (assigned_bed_id) REFERENCES beds(bed_id) ON DELETE SET NULL,
ADD INDEX idx_booking_room (assigned_room_id, appointment_date, appointment_time),
ADD INDEX idx_booking_bed (assigned_bed_id, appointment_date, appointment_time);
```

---

## 5. Migration Guide

### Step 1: Create New Tables
```sql
-- Execute the CREATE TABLE statements above in order:
-- 1. rooms
-- 2. beds
-- 3. room_service_compatibility
-- 4. booking_room_assignments
```

### Step 2: Modify Existing Tables
```sql
-- Add room/bed references to bookings table
ALTER TABLE bookings 
ADD COLUMN assigned_room_id INT NULL COMMENT 'Phòng được phân công',
ADD COLUMN assigned_bed_id INT NULL COMMENT 'Giường được phân công';

-- Add foreign key constraints
ALTER TABLE bookings
ADD FOREIGN KEY fk_booking_room (assigned_room_id) REFERENCES rooms(room_id) ON DELETE SET NULL,
ADD FOREIGN KEY fk_booking_bed (assigned_bed_id) REFERENCES beds(bed_id) ON DELETE SET NULL;

-- Add indexes for performance
ALTER TABLE bookings
ADD INDEX idx_booking_room (assigned_room_id, appointment_date, appointment_time),
ADD INDEX idx_booking_bed (assigned_bed_id, appointment_date, appointment_time);
```

### Step 3: Insert Sample Data
```sql
-- Sample rooms
INSERT INTO rooms (room_number, room_name, room_type, floor_number, capacity, amenities, description) VALUES
('R101', 'Phòng Massage Thư Giãn 1', 'PRIVATE', 1, 1, '["Điều hòa", "Âm thanh thư giãn", "Đèn LED"]', 'Phòng massage riêng tư với không gian yên tĩnh'),
('R102', 'Phòng Massage Thư Giãn 2', 'PRIVATE', 1, 1, '["Điều hòa", "Âm thanh thư giãn", "Đèn LED"]', 'Phòng massage riêng tư với không gian yên tĩnh'),
('VIP01', 'Phòng VIP Couple', 'VIP', 2, 2, '["Jacuzzi", "Điều hòa", "Tivi", "Minibar", "Hoa tươi"]', 'Phòng VIP dành cho cặp đôi với tiện nghi cao cấp'),
('R201', 'Phòng Chăm Sóc Da', 'TREATMENT', 2, 1, '["Máy hút ẩm", "Đèn chuyên dụng", "Tủ lạnh mini"]', 'Phòng chuyên dụng cho các dịch vụ chăm sóc da mặt'),
('R301', 'Phòng Thư Giãn Nhóm', 'GROUP', 3, 4, '["Điều hòa trung tâm", "Âm thanh vòm", "Ghế massage"]', 'Phòng lớn dành cho nhóm khách hàng');

-- Sample beds
INSERT INTO beds (room_id, bed_number, bed_name, bed_type, equipment, features) VALUES
(1, 'B1', 'Giường Massage Cao Cấp', 'MASSAGE', '["Máy massage", "Đệm sưởi ấm"]', '["Điều chỉnh độ cao", "Massage tự động"]'),
(2, 'B1', 'Giường Massage Tiêu Chuẩn', 'MASSAGE', '["Máy massage cơ bản"]', '["Điều chỉnh độ cao"]'),
(3, 'B1', 'Giường Couple 1', 'COUPLE', '["Máy massage đôi", "Đệm sưởi ấm"]', '["Điều chỉnh độ cao", "Massage đồng bộ"]'),
(3, 'B2', 'Giường Couple 2', 'COUPLE', '["Máy massage đôi", "Đệm sưởi ấm"]', '["Điều chỉnh độ cao", "Massage đồng bộ"]'),
(4, 'B1', 'Giường Chăm Sóc Da', 'FACIAL', '["Đèn LED", "Máy phun sương"]', '["Điều chỉnh góc nghiêng", "Đệm memory foam"]');

-- Sample room-service compatibility
INSERT INTO room_service_compatibility (room_id, service_id, setup_time_minutes, cleanup_time_minutes) VALUES
(1, 1, 5, 10),  -- Room 1 compatible with service 1
(1, 2, 5, 10),  -- Room 1 compatible with service 2
(2, 1, 5, 10),  -- Room 2 compatible with service 1
(3, 3, 15, 20), -- VIP room compatible with couple service
(4, 4, 10, 15); -- Treatment room compatible with facial service
```
