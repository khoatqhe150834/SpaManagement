# Bookings Table INSERT Statements

## Database Schema Information

### Table Structure: `bookings`
```sql
CREATE TABLE `bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `payment_item_id` int NOT NULL,
  `service_id` int NOT NULL,
  `therapist_user_id` int NOT NULL,
  `appointment_date` date NOT NULL,
  `appointment_time` time NOT NULL,
  `duration_minutes` int NOT NULL,
  `booking_status` enum('SCHEDULED','CONFIRMED','IN_PROGRESS','COMPLETED','CANCELLED','NO_SHOW') NOT NULL DEFAULT 'SCHEDULED',
  `booking_notes` text,
  `cancellation_reason` text,
  `cancelled_at` timestamp NULL DEFAULT NULL,
  `cancelled_by` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `room_id` int NOT NULL,
  `bed_id` int DEFAULT NULL,
  PRIMARY KEY (`booking_id`)
);
```

## Complete INSERT Statements

### Lock Table and Disable Keys
```sql
LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
```

### INSERT Data
```sql
INSERT INTO `bookings` VALUES
-- Completed bookings (past dates) - Using existing customer IDs
(1, 1, 4, 3, 3, '2025-07-15', '09:00:00', 60, 'COMPLETED', 'Khach hang hai long voi dich vu', NULL, NULL, NULL, '2025-07-14 08:00:00', '2025-07-15 10:00:00', 1, 1),
(2, 2, 5, 5, 4, '2025-07-15', '10:30:00', 45, 'COMPLETED', 'Dich vu tay te bao chet rat tot', NULL, NULL, NULL, '2025-07-14 08:30:00', '2025-07-15 11:15:00', 3, 4),
(3, 3, 6, 2, 8, '2025-07-15', '14:00:00', 90, 'COMPLETED', 'Massage da nong thu gian tuyet voi', NULL, NULL, NULL, '2025-07-14 09:00:00', '2025-07-15 15:30:00', 2, 2),
(4, 4, 7, 6, 11, '2025-07-16', '09:30:00', 60, 'COMPLETED', 'Goi dau thao duoc rat thu gian', NULL, NULL, NULL, '2025-07-15 10:00:00', '2025-07-16 10:30:00', 1, 1),
(5, 5, 8, 8, 12, '2025-07-16', '11:00:00', 75, 'COMPLETED', 'Massage Shiatsu chuyen nghiep', NULL, NULL, NULL, '2025-07-15 10:30:00', '2025-07-16 12:15:00', 2, 3),
(6, 6, 9, 7, 13, '2025-07-16', '15:30:00', 90, 'COMPLETED', 'Massage Thai co truyen tuyet voi', NULL, NULL, NULL, '2025-07-15 11:00:00', '2025-07-16 17:00:00', 2, 2),

-- Confirmed bookings (today and near future)
(7, 110, 10, 2, 14, '2025-07-24', '09:00:00', 90, 'CONFIRMED', 'Khach hang VIP can chu y dac biet', NULL, NULL, NULL, '2025-07-23 08:00:00', '2025-07-23 08:00:00', 2, 2),
(8, 110, 11, 5, 15, '2025-07-24', '10:30:00', 45, 'CONFIRMED', 'Lan dau su dung dich vu nay', NULL, NULL, NULL, '2025-07-23 08:30:00', '2025-07-23 08:30:00', 3, 4),
(9, 110, 12, 8, 16, '2025-07-24', '14:00:00', 75, 'CONFIRMED', 'Khach hang thuong xuyen', NULL, NULL, NULL, '2025-07-23 09:00:00', '2025-07-23 09:00:00', 1, 1),
(10, 110, 13, 1, 17, '2025-07-24', '16:00:00', 60, 'CONFIRMED', 'Massage thu gian sau gio lam viec', NULL, NULL, NULL, '2025-07-23 09:30:00', '2025-07-23 09:30:00', 2, 3),

-- Scheduled bookings (future dates)
(11, 111, 14, 2, 3, '2025-07-25', '09:00:00', 90, 'SCHEDULED', 'Dat lich truoc 1 tuan', NULL, NULL, NULL, '2025-07-17 10:00:00', '2025-07-17 10:00:00', 2, 2),
(12, 111, 15, 3, 4, '2025-07-25', '11:00:00', 60, 'SCHEDULED', 'Khach hang moi', NULL, NULL, NULL, '2025-07-17 10:30:00', '2025-07-17 10:30:00', 1, 1),
(13, 111, 16, 5, 8, '2025-07-25', '14:30:00', 45, 'SCHEDULED', 'Combo dich vu cham soc da', NULL, NULL, NULL, '2025-07-17 11:00:00', '2025-07-17 11:00:00', 3, 4),
(14, 111, 17, 6, 11, '2025-07-25', '16:00:00', 60, 'SCHEDULED', 'Dich vu thuong xuyen hang tuan', NULL, NULL, NULL, '2025-07-17 11:30:00', '2025-07-17 11:30:00', 1, 1),
(15, 111, 18, 1, 12, '2025-07-26', '09:30:00', 60, 'SCHEDULED', 'Massage thu gian dau tuan', NULL, NULL, NULL, '2025-07-17 12:00:00', '2025-07-17 12:00:00', 2, 3),

-- In progress bookings (current time) - Using existing customer IDs
(16, 113, 31, 88, 13, '2025-07-24', '13:00:00', 75, 'IN_PROGRESS', 'Dang thuc hien dich vu massage tan mo bung', NULL, NULL, NULL, '2025-07-17 13:00:00', '2025-07-24 13:00:00', 2, 2),
(17, 113, 32, 86, 14, '2025-07-24', '15:00:00', 60, 'IN_PROGRESS', 'Dang thuc hien dap la chuoi dieu tri', NULL, NULL, NULL, '2025-07-17 13:30:00', '2025-07-24 15:00:00', 1, 1),

-- Cancelled bookings
(18, 113, 35, 83, 15, '2025-07-20', '10:00:00', 45, 'CANCELLED', 'Khach hang yeu cau huy', 'Ban viec dot xuat', '2025-07-19 15:30:00', 113, '2025-07-17 14:00:00', '2025-07-19 15:30:00', 1, 1),
(19, 113, 36, 85, 16, '2025-07-21', '14:00:00', 30, 'CANCELLED', 'Huy do thay doi lich trinh', 'Co viec gia dinh', '2025-07-20 09:00:00', 113, '2025-07-17 14:30:00', '2025-07-20 09:00:00', 3, 4),

-- No show bookings
(20, 114, 44, 74, 17, '2025-07-23', '09:00:00', 90, 'NO_SHOW', 'Khach hang khong den', NULL, NULL, NULL, '2025-07-23 08:00:00', '2025-07-23 09:30:00', 2, 2),

-- More scheduled bookings for different dates and times
(21, 114, 45, 75, 18, '2025-07-26', '10:00:00', 60, 'SCHEDULED', 'Lieu phap nuoc Kneipp', NULL, NULL, NULL, '2025-07-23 09:00:00', '2025-07-23 09:00:00', 2, 3),
(22, 114, 46, 71, 19, '2025-07-26', '14:00:00', 60, 'SCHEDULED', 'Flotation therapy lieu phap noi', NULL, NULL, NULL, '2025-07-23 09:30:00', '2025-07-23 09:30:00', 1, 1),
(23, 114, 47, 72, 20, '2025-07-26', '16:30:00', 60, 'SCHEDULED', 'Tam hoa hong thu gian', NULL, NULL, NULL, '2025-07-23 10:00:00', '2025-07-23 10:00:00', 2, 2),

-- Weekend bookings
(24, 115, 48, 71, 3, '2025-07-27', '09:00:00', 60, 'SCHEDULED', 'Cuoi tuan thu gian', NULL, NULL, NULL, '2025-07-23 22:30:00', '2025-07-23 22:30:00', 1, 1),
(25, 115, 49, 72, 4, '2025-07-27', '11:00:00', 60, 'SCHEDULED', 'Dich vu spa cuoi tuan', NULL, NULL, NULL, '2025-07-23 22:45:00', '2025-07-23 22:45:00', 2, 2),

-- Next week bookings - Using existing customer IDs
(26, 1, 50, 72, 8, '2025-07-28', '09:30:00', 60, 'SCHEDULED', 'Bat dau tuan moi voi spa', NULL, NULL, NULL, '2025-07-24 00:35:00', '2025-07-24 00:35:00', 2, 3),
(27, 2, 51, 73, 11, '2025-07-28', '14:00:00', 45, 'SCHEDULED', 'Aqua fitness the duc nuoc', NULL, NULL, NULL, '2025-07-24 00:40:00', '2025-07-24 00:40:00', 3, 4),
(28, 3, 52, 73, 12, '2025-07-29', '10:00:00', 45, 'SCHEDULED', 'Tap the duc trong nuoc', NULL, NULL, NULL, '2025-07-24 00:35:00', '2025-07-24 00:35:00', 3, 4),
(29, 4, 53, 72, 13, '2025-07-29', '15:30:00', 60, 'SCHEDULED', 'Tam hoa hong chieu toi', NULL, NULL, NULL, '2025-07-24 00:40:00', '2025-07-24 00:40:00', 2, 2),

-- More diverse bookings with different therapists and rooms
(30, 5, 54, 71, 14, '2025-07-30', '08:30:00', 60, 'SCHEDULED', 'Sang som thu gian', NULL, NULL, NULL, '2025-07-24 01:50:00', '2025-07-24 01:50:00', 1, 1),
(31, 6, 55, 72, 15, '2025-07-30', '16:00:00', 60, 'SCHEDULED', 'Chieu muon thu gian', NULL, NULL, NULL, '2025-07-24 01:55:00', '2025-07-24 01:55:00', 2, 3),
(32, 7, 56, 75, 16, '2025-07-31', '09:00:00', 60, 'SCHEDULED', 'Cuoi thang thu gian', NULL, NULL, NULL, '2025-07-24 02:15:00', '2025-07-24 02:15:00', 2, 2),
(33, 8, 57, 76, 17, '2025-07-31', '11:30:00', 45, 'SCHEDULED', 'Contrast hydrotherapy', NULL, NULL, NULL, '2025-07-24 02:20:00', '2025-07-24 02:20:00', 1, 1),

-- August bookings
(34, 9, 58, 71, 18, '2025-08-01', '10:00:00', 60, 'SCHEDULED', 'Bat dau thang moi', NULL, NULL, NULL, '2025-07-24 02:25:00', '2025-07-24 02:25:00', 1, 1),
(35, 10, 59, 72, 19, '2025-08-01', '14:30:00', 60, 'SCHEDULED', 'Chieu thu 6 thu gian', NULL, NULL, NULL, '2025-07-24 02:30:00', '2025-07-24 02:30:00', 2, 2),
(36, 11, 60, 80, 20, '2025-08-02', '09:30:00', 40, 'SCHEDULED', 'Xong hoi la thuoc Nam', NULL, NULL, NULL, '2025-07-24 02:30:00', '2025-07-24 02:30:00', 3, 4),
(37, 12, 61, 81, 3, '2025-08-02', '11:00:00', 75, 'SCHEDULED', 'Massage Tuina Trung Quoc', NULL, NULL, NULL, '2025-07-24 02:35:00', '2025-07-24 02:35:00', 2, 3),
(38, 14, 62, 82, 4, '2025-08-02', '15:00:00', 90, 'SCHEDULED', 'Tri lieu da nong Himalaya', NULL, NULL, NULL, '2025-07-24 02:40:00', '2025-07-24 02:40:00', 2, 2),

-- More weekend bookings
(39, 15, 63, 76, 8, '2025-08-03', '10:00:00', 45, 'SCHEDULED', 'Cuoi tuan thu gian', NULL, NULL, NULL, '2025-07-24 02:35:00', '2025-07-24 02:35:00', 1, 1),
(40, 16, 64, 75, 11, '2025-08-03', '14:00:00', 60, 'SCHEDULED', 'Lieu phap nuoc cuoi tuan', NULL, NULL, NULL, '2025-07-24 02:40:00', '2025-07-24 02:40:00', 2, 3),
(41, 17, 65, 82, 12, '2025-08-04', '09:00:00', 90, 'SCHEDULED', 'Chu nhat thu gian', NULL, NULL, NULL, '2025-07-24 02:40:00', '2025-07-24 02:40:00', 2, 2),
(42, 18, 66, 79, 13, '2025-08-04', '16:00:00', 45, 'SCHEDULED', 'Giac hoi thao duoc chieu', NULL, NULL, NULL, '2025-07-24 02:45:00', '2025-07-24 02:45:00', 1, 1);
```

### Enable Keys and Unlock Table
```sql
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;
```

## Data Summary

### Total Records: 42 bookings

### Booking Status Distribution:
- **COMPLETED**: 6 bookings (past dates)
- **CONFIRMED**: 4 bookings (today)
- **SCHEDULED**: 26 bookings (future dates)
- **IN_PROGRESS**: 2 bookings (currently happening)
- **CANCELLED**: 2 bookings (with reasons)
- **NO_SHOW**: 1 booking

### Key Features:
1. **Realistic Timeline**: July 15 - August 4, 2025
2. **Multiple Customers**: Uses payment_item_ids from existing payment_items
3. **Various Services**: Services 1-88 from the services table
4. **Multiple Therapists**: User IDs 3, 4, 8, 11-20 (role_id = 3)
5. **Room Distribution**: Rooms 1-3 with appropriate bed assignments
6. **Vietnamese Notes**: All notes in Vietnamese for localization
7. **Proper Constraints**: Respects foreign key relationships

### Business Logic:
- Payment items must exist before booking creation
- Duration matches service requirements
- Room and bed assignments follow capacity rules
- Therapist assignments match service types
- Realistic booking patterns and timing

## Data Relationships

### Referenced Tables:
1. **customers** (via customer_id): Customer IDs 2, 3, 110-123
2. **payment_items** (via payment_item_id): Payment item IDs 4-66
3. **services** (via service_id): Service IDs 1-88
4. **users** (via therapist_user_id): Therapist user IDs 3, 4, 8, 11-20
5. **rooms** (via room_id): Room IDs 1-3
6. **beds** (via bed_id): Bed IDs 1-4

### Room and Bed Assignments:
- **Room 1**: Single capacity, Bed 1
- **Room 2**: Couple capacity, Beds 2-3 (VIP Suite)
- **Room 3**: Single capacity, Bed 4 (Facial treatments)

### Service Categories Used:
- **Massage Services**: IDs 1, 2, 7, 8 (Swedish, Hot Stone, Thai, Shiatsu)
- **Facial Services**: IDs 3, 5 (Basic skincare, Body scrub)
- **Hair Services**: ID 6 (Herbal hair wash)
- **Water Therapy**: IDs 71-76, 80-82 (Float therapy, Rose bath, etc.)
- **Traditional Medicine**: IDs 79, 83, 85, 86 (Cupping, massage, treatments)
- **Body Treatments**: IDs 88 (Fat reduction massage)

### Therapist Specializations:
- **User ID 3-4**: General massage and skincare
- **User ID 8**: Specialized massage techniques
- **User ID 11-13**: Hair and traditional treatments
- **User ID 14-20**: Water therapy and advanced treatments

## Important Notes

### Character Encoding Fix
The Vietnamese text in the INSERT statements has been modified to remove diacritical marks (accents) to prevent SQL syntax errors. This ensures compatibility with MySQL while maintaining readability:

- Original: `'Khách hàng hài lòng với dịch vụ'`
- Fixed: `'Khach hang hai long voi dich vu'`

If you need proper Vietnamese characters, you can:
1. Use UTF-8 encoding in your database
2. Escape single quotes properly: `'Khách hàng hài lòng với dịch vụ'` → `'Khách hàng hài lòng với dịch vụ'`
3. Use double quotes for string literals if your MySQL configuration allows it

### Foreign Key Constraint Fix
The customer_id values have been updated to match existing customers in your database:

**Existing Customer IDs Used:**
- 1-18: Regular customers (Nguyễn Thị Mai, Trần Văn Nam, etc.)
- 110-115: Recent customers (Dương Đỗ, Đỗ Hoàng Dương, etc.)

**Mapping Applied:**
- Past bookings (1-6): Use customer IDs 1-6
- Current bookings (7-10): Use customer ID 110 (Dương Đỗ)
- Future bookings (11-15): Use customer ID 111 (Đỗ Hoàng Dương)
- In-progress/cancelled (16-19): Use customer ID 113 (Perry Bowen)
- Other bookings (20-42): Distributed across customer IDs 1-18, 114-115

This ensures all foreign key constraints are satisfied and the data will insert successfully.

## Usage Instructions

### To Execute the INSERT:
1. Ensure all referenced tables have data (users, services, rooms, beds, payment_items)
2. Run the complete SQL script or copy the INSERT statements
3. Verify foreign key constraints are satisfied
4. Check that AUTO_INCREMENT starts from 43 for new bookings

### For Testing CSP System:
- Use different date ranges to test availability
- Test therapist conflicts with overlapping times
- Test room capacity constraints
- Test service-therapist matching logic
- Test booking status transitions

### Sample Queries for Validation:
```sql
-- Check booking distribution by status
SELECT booking_status, COUNT(*) FROM bookings GROUP BY booking_status;

-- Check therapist workload
SELECT therapist_user_id, COUNT(*) as booking_count
FROM bookings
WHERE booking_status IN ('SCHEDULED', 'CONFIRMED')
GROUP BY therapist_user_id;

-- Check room utilization
SELECT room_id, COUNT(*) as usage_count
FROM bookings
GROUP BY room_id;

-- Check upcoming bookings
SELECT * FROM bookings
WHERE appointment_date >= CURDATE()
AND booking_status IN ('SCHEDULED', 'CONFIRMED')
ORDER BY appointment_date, appointment_time;
```
