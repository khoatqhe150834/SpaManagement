-- Test data for booking appointments - Simple Sequential Approach
-- This approach inserts one booking group at a time and uses LAST_INSERT_ID() immediately
-- to avoid foreign key constraint issues

-- Day 1 - Customer 1
INSERT INTO `booking_groups` (`customer_id`, `booking_date`, `total_amount`, `payment_status`, `booking_status`, `payment_method`, `special_notes`, `created_at`) 
VALUES (1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), 1650000.00, 'PAID', 'CONFIRMED', 'ONLINE_BANKING', 'Khách VIP, ưu tiên phòng riêng', NOW());

INSERT INTO `booking_appointments` (`booking_group_id`, `service_id`, `therapist_user_id`, `start_time`, `end_time`, `service_price`, `status`, `service_notes`) VALUES
(LAST_INSERT_ID(), 2, 3, CONCAT(DATE_ADD(CURDATE(), INTERVAL 1 DAY), ' 09:00:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 1 DAY), ' 10:30:00'), 700000.00, 'SCHEDULED', 'Massage đá nóng - phòng VIP'),
(LAST_INSERT_ID(), 8, 12, CONCAT(DATE_ADD(CURDATE(), INTERVAL 1 DAY), ' 11:00:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 1 DAY), ' 12:15:00'), 750000.00, 'SCHEDULED', 'Massage Shiatsu'),
(LAST_INSERT_ID(), 27, 15, CONCAT(DATE_ADD(CURDATE(), INTERVAL 1 DAY), ' 14:00:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 1 DAY), ' 14:45:00'), 200000.00, 'SCHEDULED', 'Manicure cơ bản');

-- Day 1 - Customer 2
INSERT INTO `booking_groups` (`customer_id`, `booking_date`, `total_amount`, `payment_status`, `booking_status`, `payment_method`, `special_notes`, `created_at`) 
VALUES (2, DATE_ADD(CURDATE(), INTERVAL 1 DAY), 900000.00, 'PAID', 'CONFIRMED', 'ONLINE_BANKING', null, NOW());

INSERT INTO `booking_appointments` (`booking_group_id`, `service_id`, `therapist_user_id`, `start_time`, `end_time`, `service_price`, `status`, `service_notes`) VALUES
(LAST_INSERT_ID(), 1, 16, CONCAT(DATE_ADD(CURDATE(), INTERVAL 1 DAY), ' 10:00:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 1 DAY), ' 11:00:00'), 500000.00, 'SCHEDULED', 'Massage Thụy Điển'),
(LAST_INSERT_ID(), 3, 4, CONCAT(DATE_ADD(CURDATE(), INTERVAL 1 DAY), ' 15:00:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 1 DAY), ' 16:00:00'), 400000.00, 'SCHEDULED', 'Chăm sóc da cơ bản');

-- Day 1 - Customer 3
INSERT INTO `booking_groups` (`customer_id`, `booking_date`, `total_amount`, `payment_status`, `booking_status`, `payment_method`, `special_notes`, `created_at`) 
VALUES (3, DATE_ADD(CURDATE(), INTERVAL 1 DAY), 1300000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'Đặt cho 2 người', NOW());

INSERT INTO `booking_appointments` (`booking_group_id`, `service_id`, `therapist_user_id`, `start_time`, `end_time`, `service_price`, `status`, `service_notes`) VALUES
(LAST_INSERT_ID(), 7, 18, CONCAT(DATE_ADD(CURDATE(), INTERVAL 1 DAY), ' 13:00:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 1 DAY), ' 14:30:00'), 650000.00, 'SCHEDULED', 'Massage Thái cổ truyền'),
(LAST_INSERT_ID(), 5, 14, CONCAT(DATE_ADD(CURDATE(), INTERVAL 1 DAY), ' 16:00:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 1 DAY), ' 16:45:00'), 450000.00, 'SCHEDULED', 'Tẩy tế bào chết'),
(LAST_INSERT_ID(), 27, 15, CONCAT(DATE_ADD(CURDATE(), INTERVAL 1 DAY), ' 17:00:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 1 DAY), ' 17:45:00'), 200000.00, 'SCHEDULED', 'Manicure');

-- Day 2 - Customer 5
INSERT INTO `booking_groups` (`customer_id`, `booking_date`, `total_amount`, `payment_status`, `booking_status`, `payment_method`, `special_notes`, `created_at`) 
VALUES (5, DATE_ADD(CURDATE(), INTERVAL 2 DAY), 1250000.00, 'PAID', 'CONFIRMED', 'CASH', null, NOW());

INSERT INTO `booking_appointments` (`booking_group_id`, `service_id`, `therapist_user_id`, `start_time`, `end_time`, `service_price`, `status`, `service_notes`) VALUES
(LAST_INSERT_ID(), 1, 3, CONCAT(DATE_ADD(CURDATE(), INTERVAL 2 DAY), ' 10:00:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 2 DAY), ' 11:00:00'), 500000.00, 'SCHEDULED', 'Massage Thụy Điển'),
(LAST_INSERT_ID(), 9, 16, CONCAT(DATE_ADD(CURDATE(), INTERVAL 2 DAY), ' 15:30:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 2 DAY), ' 16:15:00'), 400000.00, 'SCHEDULED', 'Massage foot reflexology'),
(LAST_INSERT_ID(), 28, 15, CONCAT(DATE_ADD(CURDATE(), INTERVAL 2 DAY), ' 17:00:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 2 DAY), ' 18:15:00'), 350000.00, 'SCHEDULED', 'Pedicure deluxe');

-- Day 2 - Customer 6
INSERT INTO `booking_groups` (`customer_id`, `booking_date`, `total_amount`, `payment_status`, `booking_status`, `payment_method`, `special_notes`, `created_at`) 
VALUES (6, DATE_ADD(CURDATE(), INTERVAL 2 DAY), 650000.00, 'PAID', 'CONFIRMED', 'ONLINE_BANKING', null, NOW());

INSERT INTO `booking_appointments` (`booking_group_id`, `service_id`, `therapist_user_id`, `start_time`, `end_time`, `service_price`, `status`, `service_notes`) VALUES
(LAST_INSERT_ID(), 4, 17, CONCAT(DATE_ADD(CURDATE(), INTERVAL 2 DAY), ' 11:00:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 2 DAY), ' 12:15:00'), 650000.00, 'SCHEDULED', 'Trị mụn chuyên sâu');

-- Day 2 - Customer 7
INSERT INTO `booking_groups` (`customer_id`, `booking_date`, `total_amount`, `payment_status`, `booking_status`, `payment_method`, `special_notes`, `created_at`) 
VALUES (7, DATE_ADD(CURDATE(), INTERVAL 2 DAY), 950000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', null, NOW());

INSERT INTO `booking_appointments` (`booking_group_id`, `service_id`, `therapist_user_id`, `start_time`, `end_time`, `service_price`, `status`, `service_notes`) VALUES
(LAST_INSERT_ID(), 4, 13, CONCAT(DATE_ADD(CURDATE(), INTERVAL 2 DAY), ' 09:30:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 2 DAY), ' 10:45:00'), 650000.00, 'SCHEDULED', 'Trị mụn chuyên sâu'),
(LAST_INSERT_ID(), 6, 19, CONCAT(DATE_ADD(CURDATE(), INTERVAL 2 DAY), ' 14:00:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 2 DAY), ' 15:00:00'), 300000.00, 'SCHEDULED', 'Gội đầu thảo dược');

-- Day 3 - Customer 8
INSERT INTO `booking_groups` (`customer_id`, `booking_date`, `total_amount`, `payment_status`, `booking_status`, `payment_method`, `special_notes`, `created_at`) 
VALUES (8, DATE_ADD(CURDATE(), INTERVAL 3 DAY), 1750000.00, 'PAID', 'CONFIRMED', 'ONLINE_BANKING', null, NOW());

INSERT INTO `booking_appointments` (`booking_group_id`, `service_id`, `therapist_user_id`, `start_time`, `end_time`, `service_price`, `status`, `service_notes`) VALUES
(LAST_INSERT_ID(), 2, 12, CONCAT(DATE_ADD(CURDATE(), INTERVAL 3 DAY), ' 08:30:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 3 DAY), ' 10:00:00'), 700000.00, 'SCHEDULED', 'Massage đá nóng'),
(LAST_INSERT_ID(), 8, 18, CONCAT(DATE_ADD(CURDATE(), INTERVAL 3 DAY), ' 11:00:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 3 DAY), ' 12:15:00'), 750000.00, 'SCHEDULED', 'Massage Shiatsu'),
(LAST_INSERT_ID(), 6, 15, CONCAT(DATE_ADD(CURDATE(), INTERVAL 3 DAY), ' 15:00:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 3 DAY), ' 16:00:00'), 300000.00, 'SCHEDULED', 'Gội đầu thảo dược');

-- Day 3 - Customer 9
INSERT INTO `booking_groups` (`customer_id`, `booking_date`, `total_amount`, `payment_status`, `booking_status`, `payment_method`, `special_notes`, `created_at`) 
VALUES (9, DATE_ADD(CURDATE(), INTERVAL 3 DAY), 1050000.00, 'PAID', 'CONFIRMED', 'ONLINE_BANKING', null, NOW());

INSERT INTO `booking_appointments` (`booking_group_id`, `service_id`, `therapist_user_id`, `start_time`, `end_time`, `service_price`, `status`, `service_notes`) VALUES
(LAST_INSERT_ID(), 3, 4, CONCAT(DATE_ADD(CURDATE(), INTERVAL 3 DAY), ' 09:00:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 3 DAY), ' 10:00:00'), 400000.00, 'SCHEDULED', 'Chăm sóc da cơ bản'),
(LAST_INSERT_ID(), 7, 18, CONCAT(DATE_ADD(CURDATE(), INTERVAL 3 DAY), ' 13:30:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 3 DAY), ' 15:00:00'), 650000.00, 'SCHEDULED', 'Massage Thái');

-- Day 3 - Customer 10
INSERT INTO `booking_groups` (`customer_id`, `booking_date`, `total_amount`, `payment_status`, `booking_status`, `payment_method`, `special_notes`, `created_at`) 
VALUES (10, DATE_ADD(CURDATE(), INTERVAL 3 DAY), 950000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', null, NOW());

INSERT INTO `booking_appointments` (`booking_group_id`, `service_id`, `therapist_user_id`, `start_time`, `end_time`, `service_price`, `status`, `service_notes`) VALUES
(LAST_INSERT_ID(), 1, 3, CONCAT(DATE_ADD(CURDATE(), INTERVAL 3 DAY), ' 16:00:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 3 DAY), ' 17:00:00'), 500000.00, 'SCHEDULED', 'Massage Thụy Điển'),
(LAST_INSERT_ID(), 5, 14, CONCAT(DATE_ADD(CURDATE(), INTERVAL 3 DAY), ' 17:30:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 3 DAY), ' 18:15:00'), 450000.00, 'SCHEDULED', 'Tẩy tế bào chết');

-- Day 4 - Customer 11
INSERT INTO `booking_groups` (`customer_id`, `booking_date`, `total_amount`, `payment_status`, `booking_status`, `payment_method`, `special_notes`, `created_at`) 
VALUES (11, DATE_ADD(CURDATE(), INTERVAL 4 DAY), 1200000.00, 'PAID', 'CONFIRMED', 'ONLINE_BANKING', 'Đặt trước 1 tuần', NOW());

INSERT INTO `booking_appointments` (`booking_group_id`, `service_id`, `therapist_user_id`, `start_time`, `end_time`, `service_price`, `status`, `service_notes`) VALUES
(LAST_INSERT_ID(), 2, 12, CONCAT(DATE_ADD(CURDATE(), INTERVAL 4 DAY), ' 09:00:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 4 DAY), ' 10:30:00'), 700000.00, 'SCHEDULED', 'Massage đá nóng'),
(LAST_INSERT_ID(), 1, 16, CONCAT(DATE_ADD(CURDATE(), INTERVAL 4 DAY), ' 14:00:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 4 DAY), ' 15:00:00'), 500000.00, 'SCHEDULED', 'Massage Thụy Điển');

-- Day 4 - Customer 12
INSERT INTO `booking_groups` (`customer_id`, `booking_date`, `total_amount`, `payment_status`, `booking_status`, `payment_method`, `special_notes`, `created_at`) 
VALUES (12, DATE_ADD(CURDATE(), INTERVAL 4 DAY), 850000.00, 'PAID', 'CONFIRMED', 'CASH', null, NOW());

INSERT INTO `booking_appointments` (`booking_group_id`, `service_id`, `therapist_user_id`, `start_time`, `end_time`, `service_price`, `status`, `service_notes`) VALUES
(LAST_INSERT_ID(), 3, 4, CONCAT(DATE_ADD(CURDATE(), INTERVAL 4 DAY), ' 16:00:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 4 DAY), ' 17:00:00'), 400000.00, 'SCHEDULED', 'Chăm sóc da'),
(LAST_INSERT_ID(), 5, 14, CONCAT(DATE_ADD(CURDATE(), INTERVAL 4 DAY), ' 17:30:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 4 DAY), ' 18:15:00'), 450000.00, 'SCHEDULED', 'Tẩy tế bào chết');

-- Day 5 - Customer 14
INSERT INTO `booking_groups` (`customer_id`, `booking_date`, `total_amount`, `payment_status`, `booking_status`, `payment_method`, `special_notes`, `created_at`) 
VALUES (14, DATE_ADD(CURDATE(), INTERVAL 5 DAY), 1650000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', null, NOW());

INSERT INTO `booking_appointments` (`booking_group_id`, `service_id`, `therapist_user_id`, `start_time`, `end_time`, `service_price`, `status`, `service_notes`) VALUES
(LAST_INSERT_ID(), 8, 18, CONCAT(DATE_ADD(CURDATE(), INTERVAL 5 DAY), ' 10:00:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 5 DAY), ' 11:15:00'), 750000.00, 'SCHEDULED', 'Massage Shiatsu'),
(LAST_INSERT_ID(), 7, 12, CONCAT(DATE_ADD(CURDATE(), INTERVAL 5 DAY), ' 15:00:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 5 DAY), ' 16:30:00'), 650000.00, 'SCHEDULED', 'Massage Thái'),
(LAST_INSERT_ID(), 27, 15, CONCAT(DATE_ADD(CURDATE(), INTERVAL 5 DAY), ' 17:00:00'), CONCAT(DATE_ADD(CURDATE(), INTERVAL 5 DAY), ' 17:45:00'), 250000.00, 'SCHEDULED', 'Manicure cao cấp');

-- Summary
SELECT 'Test data insertion completed successfully!' as message;
SELECT COUNT(*) as 'Total Booking Groups Added' FROM booking_groups WHERE booking_date >= CURDATE();
SELECT COUNT(*) as 'Total Appointments Added' FROM booking_appointments ba 
JOIN booking_groups bg ON ba.booking_group_id = bg.booking_group_id 
WHERE bg.booking_date >= CURDATE();

-- Show sample data
SELECT 
    bg.booking_group_id,
    bg.customer_id,
    bg.booking_date,
    COUNT(ba.booking_appointment_id) as appointment_count,
    bg.total_amount
FROM booking_groups bg 
LEFT JOIN booking_appointments ba ON bg.booking_group_id = ba.booking_group_id
WHERE bg.booking_date >= CURDATE()
GROUP BY bg.booking_group_id
ORDER BY bg.booking_date, bg.booking_group_id; 