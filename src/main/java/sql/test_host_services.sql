-- SQL Script to Insert Sample Appointments for Testing "Hot Service Types"
-- This script will add 15 new completed appointments to your database.
-- The distribution is designed to make certain categories appear more frequently.

-- Make sure you're using the correct database
USE spamanagement;

-- Insert 6 appointments for 'Chăm Sóc Da Mặt' (Service Type ID: 2)
-- This will make it the HOTTEST category.
INSERT INTO `appointments` (`customer_id`, `therapist_user_id`, `service_id`, `start_time`, `end_time`, `original_service_price`, `final_price_after_discount`, `final_amount_payable`, `status`, `payment_status`, `notes_by_customer`) VALUES
(1, 4, 3, '2025-06-10 10:00:00', '2025-06-10 11:00:00', 400000.00, 400000.00, 400000.00, 'COMPLETED', 'PAID', 'Test data for hot services.'),
(2, 4, 3, '2025-06-11 11:00:00', '2025-06-11 12:00:00', 400000.00, 400000.00, 400000.00, 'COMPLETED', 'PAID', 'Test data for hot services.'),
(3, 4, 4, '2025-06-12 14:00:00', '2025-06-12 15:15:00', 650000.00, 650000.00, 650000.00, 'COMPLETED', 'PAID', 'Test data for hot services.'),
(5, 4, 3, '2025-06-13 15:00:00', '2025-06-13 16:00:00', 400000.00, 400000.00, 400000.00, 'COMPLETED', 'PAID', 'Test data for hot services.'),
(6, 4, 4, '2025-06-14 10:00:00', '2025-06-14 11:15:00', 650000.00, 650000.00, 650000.00, 'COMPLETED', 'PAID', 'Test data for hot services.'),
(7, 4, 3, '2025-06-15 13:00:00', '2025-06-15 14:00:00', 400000.00, 400000.00, 400000.00, 'CONFIRMED', 'UNPAID', 'Test data for hot services.');

-- Insert 5 appointments for 'Chăm Sóc Toàn Thân' (Service Type ID: 3)
-- This will be the 2nd hottest category.
INSERT INTO `appointments` (`customer_id`, `therapist_user_id`, `service_id`, `start_time`, `end_time`, `original_service_price`, `final_price_after_discount`, `final_amount_payable`, `status`, `payment_status`, `notes_by_customer`) VALUES
(1, 3, 5, '2025-06-10 12:00:00', '2025-06-10 12:45:00', 450000.00, 450000.00, 450000.00, 'COMPLETED', 'PAID', 'Test data for hot services.'),
(2, 3, 5, '2025-06-11 13:00:00', '2025-06-11 13:45:00', 450000.00, 450000.00, 450000.00, 'COMPLETED', 'PAID', 'Test data for hot services.'),
(3, 3, 5, '2025-06-12 16:00:00', '2025-06-12 16:45:00', 450000.00, 450000.00, 450000.00, 'COMPLETED', 'PAID', 'Test data for hot services.'),
(5, 3, 5, '2025-06-13 17:00:00', '2025-06-13 17:45:00', 450000.00, 450000.00, 450000.00, 'COMPLETED', 'PAID', 'Test data for hot services.'),
(8, 3, 5, '2025-06-14 12:00:00', '2025-06-14 12:45:00', 450000.00, 450000.00, 450000.00, 'CONFIRMED', 'UNPAID', 'Test data for hot services.');

-- Insert 4 appointments for 'Dịch Vụ Gội Đầu Dưỡng Sinh' (Service Type ID: 4)
-- This will be the 3rd hottest category.
INSERT INTO `appointments` (`customer_id`, `therapist_user_id`, `service_id`, `start_time`, `end_time`, `original_service_price`, `final_price_after_discount`, `final_amount_payable`, `status`, `payment_status`, `notes_by_customer`) VALUES
(1, 8, 6, '2025-06-10 18:00:00', '2025-06-10 19:00:00', 300000.00, 300000.00, 300000.00, 'COMPLETED', 'PAID', 'Test data for hot services.'),
(9, 8, 6, '2025-06-11 18:00:00', '2025-06-11 19:00:00', 300000.00, 300000.00, 300000.00, 'COMPLETED', 'PAID', 'Test data for hot services.'),
(10, 8, 6, '2025-06-12 18:00:00', '2025-06-12 19:00:00', 300000.00, 300000.00, 300000.00, 'COMPLETED', 'PAID', 'Test data for hot services.'),
(11, 8, 6, '2025-06-13 18:00:00', '2025-06-13 19:00:00', 300000.00, 300000.00, 300000.00, 'COMPLETED', 'PAID', 'Test data for hot services.');

SELECT '15 sample appointments have been successfully inserted.' AS message;
