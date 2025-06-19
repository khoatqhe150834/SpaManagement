-- This script generates test data for appointments and service_reviews
-- to verify the functionality of the therapist rating triggers.

-- For each therapist, we will:
-- 1. Insert a new completed appointment.
-- 2. Insert a corresponding service review for that appointment using LAST_INSERT_ID().
-- This will trigger 'trg_after_service_reviews_insert' to update the therapist's average rating.

-- To check the results after running this script, use the following query:
-- SELECT u.full_name, t.user_id, t.average_rating 
-- FROM therapists t 
-- JOIN users u ON t.user_id = u.user_id
-- ORDER BY u.full_name;

-- Note: This script assumes customer IDs (1-10) and service IDs (1-10) exist.
-- It uses hardcoded prices for simplicity.

-- --- Test Data for Therapist ID 3 (Lê Minh Cường) ---
INSERT INTO `appointments` (customer_id, therapist_user_id, service_id, start_time, end_time, original_service_price, final_price_after_discount, final_amount_payable, status, payment_status) 
VALUES (1, 3, 2, '2025-06-20 10:00:00', '2025-06-20 11:30:00', 700000.00, 700000.00, 700000.00, 'COMPLETED', 'PAID');
INSERT INTO `service_reviews` (service_id, customer_id, appointment_id, rating, title, comment)
VALUES (2, 1, LAST_INSERT_ID(), 5, 'Tuyệt vời!', 'Anh Cường massage rất chuyên nghiệp.');

INSERT INTO `appointments` (customer_id, therapist_user_id, service_id, start_time, end_time, original_service_price, final_price_after_discount, final_amount_payable, status, payment_status) 
VALUES (2, 3, 1, '2025-06-21 14:00:00', '2025-06-21 15:00:00', 500000.00, 500000.00, 500000.00, 'COMPLETED', 'PAID');
INSERT INTO `service_reviews` (service_id, customer_id, appointment_id, rating, title, comment)
VALUES (1, 2, LAST_INSERT_ID(), 4, 'Hài lòng', 'Dịch vụ tốt, sẽ quay lại.');


-- --- Test Data for Therapist ID 4 (Phạm Thị Dung) ---
-- Note: This therapist already has one 5-star review from the initial data.
INSERT INTO `appointments` (customer_id, therapist_user_id, service_id, start_time, end_time, original_service_price, final_price_after_discount, final_amount_payable, status, payment_status) 
VALUES (3, 4, 3, '2025-06-20 11:00:00', '2025-06-20 12:00:00', 400000.00, 400000.00, 400000.00, 'COMPLETED', 'PAID');
INSERT INTO `service_reviews` (service_id, customer_id, appointment_id, rating, title, comment)
VALUES (3, 3, LAST_INSERT_ID(), 4, 'Khá tốt', 'Chị Dung làm da rất cẩn thận.');


-- --- Test Data for Therapist ID 12 (Mai Anh Tuấn) ---
INSERT INTO `appointments` (customer_id, therapist_user_id, service_id, start_time, end_time, original_service_price, final_price_after_discount, final_amount_payable, status, payment_status) 
VALUES (5, 12, 7, '2025-06-22 09:00:00', '2025-06-22 10:30:00', 650000.00, 650000.00, 650000.00, 'COMPLETED', 'PAID');
INSERT INTO `service_reviews` (service_id, customer_id, appointment_id, rating, title, comment)
VALUES (7, 5, LAST_INSERT_ID(), 5, 'Rất thư giãn', 'Massage Thái đúng chuẩn.');


-- --- Test Data for Therapist ID 13 (Trần Ngọc Bích) ---
INSERT INTO `appointments` (customer_id, therapist_user_id, service_id, start_time, end_time, original_service_price, final_price_after_discount, final_amount_payable, status, payment_status) 
VALUES (6, 13, 11, '2025-06-22 10:00:00', '2025-06-22 11:30:00', 800000.00, 800000.00, 800000.00, 'COMPLETED', 'PAID');
INSERT INTO `service_reviews` (service_id, customer_id, appointment_id, rating, title, comment)
VALUES (11, 6, LAST_INSERT_ID(), 3, 'Tạm được', 'Hiệu quả chưa rõ rệt lắm.');

INSERT INTO `appointments` (customer_id, therapist_user_id, service_id, start_time, end_time, original_service_price, final_price_after_discount, final_amount_payable, status, payment_status) 
VALUES (7, 13, 12, '2025-06-23 11:00:00', '2025-06-23 12:15:00', 550000.00, 550000.00, 550000.00, 'COMPLETED', 'PAID');
INSERT INTO `service_reviews` (service_id, customer_id, appointment_id, rating, title, comment)
VALUES (12, 7, LAST_INSERT_ID(), 5, 'Da sáng mịn', 'Rất thích liệu trình vitamin C này.');


-- --- Test Data for Therapist ID 16 (Đặng Văn Long) ---
INSERT INTO `appointments` (customer_id, therapist_user_id, service_id, start_time, end_time, original_service_price, final_price_after_discount, final_amount_payable, status, payment_status) 
VALUES (8, 16, 1, '2025-06-24 16:00:00', '2025-06-24 17:00:00', 500000.00, 500000.00, 500000.00, 'COMPLETED', 'PAID');
INSERT INTO `service_reviews` (service_id, customer_id, appointment_id, rating, title, comment)
VALUES (1, 8, LAST_INSERT_ID(), 4, 'Tốt', 'Anh Long tay nghề tốt.');


-- --- Test Data for Therapist ID 18 (Bùi Quang Huy) ---
INSERT INTO `appointments` (customer_id, therapist_user_id, service_id, start_time, end_time, original_service_price, final_price_after_discount, final_amount_payable, status, payment_status) 
VALUES (9, 18, 2, '2025-06-24 18:00:00', '2025-06-24 19:30:00', 700000.00, 700000.00, 700000.00, 'COMPLETED', 'PAID');
INSERT INTO `service_reviews` (service_id, customer_id, appointment_id, rating, title, comment)
VALUES (2, 9, LAST_INSERT_ID(), 5, 'Trên cả tuyệt vời!', 'Đá nóng rất hiệu quả, cảm ơn anh Huy.');

-- You can add more INSERT statements for other therapists following the same pattern.
-- --- END OF SCRIPT --- 