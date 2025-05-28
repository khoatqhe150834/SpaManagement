
-- -----------------------------------------------------
-- Bước 1: Sử dụng cơ sở dữ liệu
-- -----------------------------------------------------
USE `spamanagement`;

-- -----------------------------------------------------
-- Bước 2: Chèn dữ liệu vào các bảng
-- -----------------------------------------------------

-- 1. Bảng Spa_Information (Thông tin Spa)
-- Chỉ chèn 1 bản ghi vì đây là thông tin của spa (thường chỉ có 1 spa hoặc chi nhánh)
INSERT INTO `Spa_Information` (
    `name`, `address_line1`, `address_line2`, `city`, `postal_code`, `country`, 
    `phone_number_main`, `phone_number_secondary`, `email_main`, `email_secondary`, 
    `website_url`, `logo_url`, `tax_identification_number`, `cancellation_policy`, 
    `booking_terms`, `about_us_short`, `about_us_long`, `vat_percentage`, 
    `default_appointment_buffer_minutes`
) VALUES (
    'Hương Sắc Spa', 
    '123 Đường Láng Hạ', 
    'Tòa nhà A1', 
    'Hà Nội', 
    '100000', 
    'Việt Nam', 
    '0909123456', 
    '0987654321', 
    'contact@huongsacspa.vn', 
    'support@huongsacspa.vn', 
    'https://huongsacspa.vn', 
    'https://huongsacspa.vn/logo.png', 
    '123456789', 
    'Hủy lịch hẹn trước 24 giờ để được hoàn tiền 100%.', 
    'Đặt lịch trước ít nhất 2 giờ và thanh toán trước 50% cho nhóm trên 3 người.', 
    'Hương Sắc Spa - Nơi thư giãn và làm đẹp tuyệt vời.', 
    'Hương Sắc Spa cung cấp các dịch vụ làm đẹp và thư giãn chuyên nghiệp với đội ngũ kỹ thuật viên giàu kinh nghiệm.', 
    10.00, 
    15
) ON DUPLICATE KEY UPDATE 
    `name` = VALUES(`name`), 
    `address_line1` = VALUES(`address_line1`), 
    `city` = VALUES(`city`), 
    `country` = VALUES(`country`), 
    `phone_number_main` = VALUES(`phone_number_main`), 
    `email_main` = VALUES(`email_main`);

-- 2. Bảng Roles (Vai trò)
INSERT INTO `Roles` (`name`, `display_name`, `description`) VALUES
('ADMIN', 'Quản trị viên cấp cao', 'Toàn quyền quản lý hệ thống'),
('MANAGER', 'Quản lý Spa', 'Quản lý lịch hẹn, nhân viên, và báo cáo'),
('THERAPIST', 'Kỹ thuật viên', 'Thực hiện các dịch vụ spa'),
('RECEPTIONIST', 'Lễ tân', 'Tiếp nhận khách hàng và quản lý lịch hẹn')
ON DUPLICATE KEY UPDATE 
    `display_name` = VALUES(`display_name`), 
    `description` = VALUES(`description`);

-- 3. Bảng Users (Người dùng - Nhân viên)
INSERT INTO `Users` (
    `role_id`, `full_name`, `email`, `password_hash`, `phone_number`, 
    `gender`, `birthday`, `avatar_url`, `is_active`, `last_login_at`
) VALUES
(1, 'Nguyễn Văn Hùng', 'hung.nguyen@huongsacspa.vn', 'hashed_password_1', '0912345678', 'MALE', '1985-05-20', NULL, TRUE, '2025-05-24 08:00:00'),
(2, 'Trần Thị Mai', 'mai.tran@huongsacspa.vn', 'hashed_password_2', '0923456789', 'FEMALE', '1990-03-15', NULL, TRUE, '2025-05-23 09:00:00'),
(3, 'Lê Thị Hồng', 'hong.le@huongsacspa.vn', 'hashed_password_3', '0934567890', 'FEMALE', '1995-07-10', 'https://huongsacspa.vn/avatars/hong.jpg', TRUE, NULL),
(4, 'Phạm Quốc Anh', 'anh.pham@huongsacspa.vn', 'hashed_password_4', '0945678901', 'MALE', '1992-11-25', NULL, TRUE, NULL);

-- 4. Bảng Customers (Khách hàng)
INSERT INTO `Customers` (
    `full_name`, `email`, `phone_number`, `gender`, `birthday`, 
    `address`, `loyalty_points`, `notes`
) VALUES
('Phạm Thị Lan', 'lan.pham@gmail.com', '0945678902', 'FEMALE', '1992-11-25', '456 Đường Nguyễn Trãi, Hà Nội', 100, 'Khách hàng VIP'),
('Ngô Quốc Anh', 'anh.ngo@gmail.com', '0956789013', 'MALE', '1988-04-12', '789 Đường Láng, Hà Nội', 50, NULL),
('Trần Thị Ngọc', 'ngoc.tran@gmail.com', '0967890123', 'FEMALE', '1995-06-30', '12 Đường Cầu Giấy, Hà Nội', 200, 'Thích massage thư giãn'),
('Lê Văn Minh', 'minh.le@gmail.com', '0978901234', 'MALE', '1990-09-15', '34 Đường Kim Mã, Hà Nội', 0, NULL);

-- 5. Bảng Categories (Danh mục)
INSERT INTO `Categories` (
    `parent_category_id`, `name`, `slug`, `description`, 
    `image_url`, `module_type`, `is_active`, `sort_order`
) VALUES
(NULL, 'Massage', 'massage', 'Các dịch vụ massage thư giãn', NULL, 'SERVICE', TRUE, 1),
(NULL, 'Chăm sóc Da', 'cham-soc-da', 'Dịch vụ chăm sóc da mặt', NULL, 'SERVICE', TRUE, 2),
(NULL, 'Chăm sóc Móng', 'cham-soc-mong', 'Dịch vụ chăm sóc móng tay, móng chân', NULL, 'SERVICE', TRUE, 3),
(NULL, 'Tin tức Spa', 'tin-tuc-spa', 'Bài viết về spa và làm đẹp', NULL, 'BLOG_POST', TRUE, 1);

-- 6. Bảng Service_Types (Loại Dịch vụ)
INSERT INTO `Service_Types` (
    `name`, `description`, `image_url`, `is_active`
) VALUES
('Massage Trị Liệu', 'Massage giúp thư giãn và giảm đau', NULL, TRUE),
('Chăm sóc Da Mặt', 'Liệu trình làm đẹp da chuyên sâu', NULL, TRUE),
('Chăm sóc Móng', 'Dịch vụ làm đẹp móng tay, móng chân', NULL, TRUE),
('Gội Đầu Dưỡng Sinh', 'Gội đầu kết hợp massage thư giãn', NULL, TRUE);

-- 7. Bảng Business_Hours (Giờ Hoạt Động)
INSERT INTO `Business_Hours` (
    `day_of_week`, `open_time`, `close_time`, `is_closed`, `notes`
) VALUES
('MONDAY', '09:00:00', '20:00:00', FALSE, NULL),
('TUESDAY', '09:00:00', '20:00:00', FALSE, NULL),
('WEDNESDAY', '09:00:00', '20:00:00', FALSE, NULL),
('THURSDAY', '09:00:00', '20:00:00', FALSE, NULL),
('FRIDAY', '09:00:00', '20:00:00', FALSE, NULL),
('SATURDAY', '09:00:00', '21:00:00', FALSE, 'Mở cửa muộn hơn'),
('SUNDAY', NULL, NULL, TRUE, 'Đóng cửa cả ngày');

-- 8. Bảng Therapists (Kỹ thuật viên)
INSERT INTO `Therapists` (
    `user_id`, `service_type_id`, `bio`, `availability_status`, `years_of_experience`
) VALUES
(3, 1, 'Kỹ thuật viên massage chuyên nghiệp', 'AVAILABLE', 5),
(4, 2, 'Chuyên gia chăm sóc da mặt', 'AVAILABLE', 3);

-- 9. Bảng Therapist_Schedules (Lịch làm việc của Kỹ thuật viên)
INSERT INTO `Therapist_Schedules` (
    `therapist_user_id`, `start_datetime`, `end_datetime`, `is_available`, `notes`
) VALUES
(3, '2025-05-25 09:00:00', '2025-05-25 17:00:00', TRUE, 'Ca sáng và chiều'),
(3, '2025-05-26 09:00:00', '2025-05-26 17:00:00', TRUE, 'Ca sáng và chiều'),
(4, '2025-05-25 10:00:00', '2025-05-25 18:00:00', TRUE, 'Ca toàn ngày'),
(4, '2025-05-26 10:00:00', '2025-05-26 18:00:00', TRUE, 'Ca toàn ngày');

-- 10. Bảng Services (Dịch vụ)
INSERT INTO `Services` (
    `service_type_id`, `name`, `description`, `price`, `duration_minutes`, 
    `buffer_time_after_minutes`, `image_url`, `is_active`, `average_rating`, 
    `bookable_online`, `requires_consultation`
) VALUES
(1, 'Massage Toàn Thân', 'Massage thư giãn toàn thân 60 phút', 300000.00, 60, 15, NULL, TRUE, 4.50, TRUE, FALSE),
(1, 'Massage Đá Nóng', 'Massage với đá nóng thư giãn sâu', 400000.00, 90, 15, NULL, TRUE, 4.80, TRUE, FALSE),
(2, 'Chăm sóc Da Cơ Bản', 'Làm sạch và dưỡng da mặt', 200000.00, 45, 10, NULL, TRUE, 4.00, TRUE, TRUE),
(3, 'Sơn Móng Gel', 'Sơn móng tay với gel bền màu', 150000.00, 30, 5, NULL, TRUE, 4.20, TRUE, FALSE);

-- 11. Bảng Service_Categories (Dịch vụ và Danh mục)
INSERT INTO `Service_Categories` (`service_id`, `category_id`) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 3);

-- 12. Bảng Promotions (Khuyến mãi)
INSERT INTO `Promotions` (
    `title`, `description`, `promotion_code`, `discount_type`, `discount_value`, 
    `applies_to_service_id`, `minimum_appointment_value`, `start_date`, `end_date`, 
    `status`, `usage_limit_per_customer`, `total_usage_limit`, `current_usage_count`, 
    `applicable_scope`, `applicable_service_ids_json`, `image_url`, `terms_and_conditions`, 
    `created_by_user_id`, `is_auto_apply`
) VALUES
('Giảm 20% Massage', 'Giảm 20% cho dịch vụ massage', 'MASSAGE20', 'PERCENTAGE', 20.00, NULL, 200000.00, '2025-05-24 00:00:00', '2025-06-24 23:59:59', 'ACTIVE', 1, 100, 0, 'SPECIFIC_SERVICES', '[1,2]', NULL, 'Áp dụng cho lịch hẹn trên 200k', 1, TRUE),
('Tặng Sơn Móng', 'Tặng dịch vụ sơn móng khi đặt chăm sóc da', 'FREEGEL', 'FREE_SERVICE', 0.00, 4, 200000.00, '2025-05-24 00:00:00', '2025-06-24 23:59:59', 'ACTIVE', 1, 50, 0, 'SPECIFIC_SERVICES', '[3]', NULL, 'Áp dụng khi đặt chăm sóc da', 1, FALSE),
('Giảm 50k', 'Giảm 50k cho mọi lịch hẹn', 'DISCOUNT50K', 'FIXED_AMOUNT', 50000.00, NULL, 150000.00, '2025-05-24 00:00:00', '2025-06-30 23:59:59', 'ACTIVE', 2, 200, 0, 'ENTIRE_APPOINTMENT', NULL, NULL, 'Áp dụng cho mọi dịch vụ', 1, TRUE);

-- 13. Bảng Shopping_Carts (Giỏ hàng)
INSERT INTO `Shopping_Carts` (
    `customer_id`, `session_id`, `status`
) VALUES
(1, NULL, 'ACTIVE'),
(2, NULL, 'ACTIVE'),
(3, 'session_789', 'ACTIVE'),
(4, NULL, 'ABANDONED');

-- 14. Bảng Cart_Items (Các mục trong Giỏ hàng)
INSERT INTO `Cart_Items` (
    `cart_id`, `service_id`, `quantity`, `price_at_addition`, 
    `therapist_user_id_preference`, `preferred_start_time_slot`, `notes`
) VALUES
(1, 1, 1, 300000.00, 3, '2025-05-25 10:00:00', 'Ưu tiên kỹ thuật viên nữ'),
(2, 3, 1, 200000.00, 4, '2025-05-25 11:00:00', NULL),
(3, 2, 1, 400000.00, 3, '2025-05-26 14:00:00', 'Massage đá nóng'),
(4, 4, 2, 150000.00, NULL, NULL, 'Sơn móng cho 2 người');

-- 15. Bảng Booking_Groups (Nhóm Đặt Lịch)
INSERT INTO `Booking_Groups` (
    `represent_customer_id`, `group_name`, `expected_pax`, `group_notes`, `status`
) VALUES
(1, 'Nhóm Sinh Nhật', 3, 'Đặt lịch cho tiệc sinh nhật', 'PENDING_CONFIRMATION'),
(2, 'Nhóm Bạn Bè', 4, 'Đi spa cùng bạn bè', 'FULLY_CONFIRMED'),
(3, 'Gia đình Nguyễn', 2, 'Đặt lịch cho vợ chồng', 'PARTIALLY_CONFIRMED');

-- 16. Bảng Appointments (Lịch hẹn)
INSERT INTO `Appointments` (
    `customer_id`, `booking_group_id`, `therapist_user_id`, `service_id`, 
    `start_time`, `end_time`, `original_service_price`, `discount_amount_applied`, 
    `final_price_after_discount`, `points_redeemed_value`, `final_amount_payable`, 
    `promotion_id`, `status`, `payment_status`, `notes_by_customer`, `notes_by_staff`, 
    `created_from_cart_item_id`
) VALUES
(1, 1, 3, 1, '2025-05-25 10:00:00', '2025-05-25 11:00:00', 300000.00, 60000.00, 240000.00, 0.00, 240000.00, 1, 'CONFIRMED', 'PAID', 'Thư giãn sau giờ làm', 'Khách hàng yêu cầu nhẹ nhàng', 1),
(2, 2, 4, 3, '2025-05-25 11:00:00', '2025-05-25 11:45:00', 200000.00, 0.00, 200000.00, 0.00, 200000.00, NULL, 'CONFIRMED', 'UNPAID', NULL, 'Kiểm tra da trước khi thực hiện', 2),
(3, 2, 3, 2, '2025-05-26 14:00:00', '2025-05-26 15:30:00', 400000.00, 80000.00, 320000.00, 0.00, 320000.00, 1, 'PENDING_CONFIRMATION', 'UNPAID', 'Massage đá nóng', NULL, 3),
(4, 3, NULL, 4, '2025-05-25 09:00:00', '2025-05-25 09:30:00', 150000.00, 0.00, 150000.00, 0.00, 150000.00, NULL, 'CONFIRMED', 'PAID', NULL, NULL, 4);

-- 17. Bảng Service_Reviews (Đánh giá Dịch vụ)
INSERT INTO `Service_Reviews` (
    `service_id`, `customer_id`, `appointment_id`, `rating`, `title`, `comment`
) VALUES
(1, 1, 1, 5, 'Rất tuyệt vời', 'Dịch vụ massage rất thư giãn, kỹ thuật viên chuyên nghiệp'),
(3, 2, 2, 4, 'Tốt nhưng hơi ngắn', 'Chăm sóc da tốt nhưng thời gian hơi ngắn'),
(4, 4, 4, 5, 'Móng đẹp', 'Sơn móng gel rất bền màu');

-- 18. Bảng Payments (Thanh toán)
INSERT INTO `Payments` (
    `appointment_id`, `customer_id`, `amount_paid`, `payment_method`, 
    `transaction_id_gateway`, `status`, `notes`
) VALUES
(1, 1, 240000.00, 'VNPAY', 'TX123456789', 'COMPLETED', 'Thanh toán online'),
(4, 4, 150000.00, 'MOMO', 'TX987654321', 'COMPLETED', 'Thanh toán qua MoMo'),
(2, 2, 100000.00, 'VNPAY', 'TX456789123', 'PARTIALLY_PAID', 'Thanh toán một phần');

-- 19. Bảng Loyalty_Point_Transactions (Giao dịch Điểm Thưởng)
INSERT INTO `Loyalty_Point_Transactions` (
    `customer_id`, `transaction_type`, `points_changed`, `balance_after_transaction`, 
    `related_appointment_id`, `related_payment_id`, `description`, `admin_user_id`
) VALUES
(1, 'EARNED_APPOINTMENT', 50, 150, 1, 1, 'Nhận điểm từ lịch hẹn #1', 1),
(2, 'EARNED_APPOINTMENT', 30, 80, 2, 3, 'Nhận điểm từ lịch hẹn #2', 1),
(4, 'EARNED_APPOINTMENT', 20, 20, 4, 2, 'Nhận điểm từ lịch hẹn #4', 1),
(3, 'MANUAL_ADD', 100, 300, NULL, NULL, 'Thêm điểm khuyến mãi', 1);

-- 20. Bảng General_Transactions_Log (Lịch sử Giao dịch Chung)
INSERT INTO `General_Transactions_Log` (
    `payment_id`, `user_id`, `customer_id`, `related_entity_type`, 
    `related_entity_id`, `transaction_code_internal`, `type`, `amount`, 
    `currency_code`, `description`, `status`
) VALUES
(1, 2, 1, 'APPOINTMENT_PAYMENT', 1, 'TXN202505240001', 'CREDIT_SPA', 240000.00, 'VND', 'Thanh toán lịch hẹn #1', 'COMPLETED'),
(2, 2, 4, 'APPOINTMENT_PAYMENT', 4, 'TXN202505240002', 'CREDIT_SPA', 150000.00, 'VND', 'Thanh toán lịch hẹn #4', 'COMPLETED'),
(3, NULL, 2, 'APPOINTMENT_PAYMENT', 2, 'TXN202505240003', 'CREDIT_SPA', 100000.00, 'VND', 'Thanh toán một phần lịch hẹn #2', 'PARTIALLY_PAID'),
(NULL, 1, NULL, 'OTHER_EXPENSE', NULL, 'TXN202505240004', 'DEBIT_SPA', 500000.00, 'VND', 'Chi phí mua thiết bị spa', 'COMPLETED');

-- 21. Bảng Blogs (Bài viết)
INSERT INTO `Blogs` (
    `author_user_id`, `title`, `slug`, `summary`, `content`, 
    `feature_image_url`, `status`, `published_at`, `view_count`
) VALUES
(1, 'Lợi ích của Massage Thư Giãn', 'loi-ich-massage', 'Tìm hiểu lợi ích của massage', 'Nội dung chi tiết về massage...', NULL, 'PUBLISHED', '2025-05-24 08:00:00', 100),
(2, 'Cách Chăm sóc Da Mặt Hiệu Quả', 'cham-soc-da-mat', 'Hướng dẫn chăm sóc da tại nhà', 'Nội dung chi tiết về chăm sóc da...', NULL, 'PUBLISHED', '2025-05-23 09:00:00', 150),
(1, 'Khuyến mãi Tháng 5', 'khuyen-mai-thang-5', 'Cập nhật các ưu đãi mới', 'Thông tin chi tiết về khuyến mãi...', NULL, 'SCHEDULED', '2025-05-25 08:00:00', 0);

-- 22. Bảng Blog_Categories (Blog và Danh mục)
INSERT INTO `Blog_Categories` (`blog_id`, `category_id`) VALUES
(1, 4),
(2, 4),
(3, 4);

-- 23. Bảng Notification_Types (Loại Thông báo)
INSERT INTO `Notification_Types` (
    `name`, `description`, `template_email_subject`, `template_email_body`, 
    `template_sms_message`, `template_in_app_message`, `icon_class`, 
    `is_customer_facing`, `is_staff_facing`
) VALUES
('APPOINTMENT_CONFIRMED', 'Thông báo xác nhận lịch hẹn', 'Xác nhận lịch hẹn của bạn', 'Kính gửi {customer_name}, lịch hẹn của bạn đã được xác nhận.', 'Lịch hẹn của bạn vào {appointment_time} đã được xác nhận.', 'Lịch hẹn của bạn đã được xác nhận.', 'fa-check', TRUE, FALSE),
('APPOINTMENT_CANCELLED', 'Thông báo hủy lịch hẹn', 'Hủy lịch hẹn', 'Kính gửi {customer_name}, lịch hẹn của bạn đã bị hủy.', 'Lịch hẹn vào {appointment_time} đã bị hủy.', 'Lịch hẹn đã bị hủy.', 'fa-times', TRUE, FALSE),
('NEW_PROMOTION', 'Thông báo khuyến mãi mới', 'Ưu đãi mới từ Hương Sắc Spa', 'Kính gửi {customer_name}, chúng tôi có khuyến mãi mới: {promotion_title}.', 'Khuyến mãi mới: {promotion_title}.', 'Khuyến mãi mới: {promotion_title}.', 'fa-gift', TRUE, FALSE);

-- 24. Bảng Notifications_Master (Thông báo Gốc)
INSERT INTO `Notifications_Master` (
    `notification_type_id`, `title_template`, `content_template`, 
    `link_url_template`, `related_entity_type_context`, `created_by_user_id`, 
    `trigger_event`
) VALUES
(1, 'Xác nhận lịch hẹn #{appointment_id}', 'Kính gửi {customer_name}, lịch hẹn của bạn vào {appointment_time} đã được xác nhận.', '/appointments/{appointment_id}', 'APPOINTMENT', 1, 'APPOINTMENT_CONFIRMED'),
(2, 'Hủy lịch hẹn #{appointment_id}', 'Kính gửi {customer_name}, lịch hẹn của bạn vào {appointment_time} đã bị hủy.', '/appointments/{appointment_id}', 'APPOINTMENT', 1, 'APPOINTMENT_CANCELLED'),
(3, 'Khuyến mãi mới: {promotion_title}', 'Kính gửi {customer_name}, chúng tôi có ưu đãi mới: {promotion_title}.', '/promotions/{promotion_id}', 'PROMOTION', 1, 'NEW_PROMOTION');

-- 25. Bảng User_Sent_Notifications (Thông báo gửi đến Nhân viên)
INSERT INTO `User_Sent_Notifications` (
    `master_notification_id`, `recipient_user_id`, `actual_title`, 
    `actual_content`, `actual_link_url`, `related_entity_id`, 
    `delivery_channel`, `delivery_status`, `scheduled_send_at`
) VALUES
(1, 2, 'Xác nhận lịch hẹn #1', 'Lịch hẹn của khách hàng Phạm Thị Lan vào 2025-05-25 10:00 đã được xác nhận.', '/appointments/1', 1, 'IN_APP', 'SENT', '2025-05-24 10:00:00'),
(1, 2, 'Xác nhận lịch hẹn #4', 'Lịch hẹn của khách hàng Lê Văn Minh vào 2025-05-25 09:00 đã được xác nhận.', '/appointments/4', 4, 'EMAIL', 'SENT', '2025-05-24 08:30:00');

-- 26. Bảng Customer_Sent_Notifications (Thông báo gửi đến Khách hàng)
INSERT INTO `Customer_Sent_Notifications` (
    `master_notification_id`, `recipient_customer_id`, `actual_title`, 
    `actual_content`, `actual_link_url`, `related_entity_id`, 
    `delivery_channel`, `delivery_status`, `scheduled_send_at`
) VALUES
(1, 1, 'Xác nhận lịch hẹn #1', 'Kính gửi Phạm Thị Lan, lịch hẹn của bạn vào 2025-05-25 10:00 đã được xác nhận.', '/appointments/1', 1, 'EMAIL', 'SENT', '2025-05-24 10:00:00'),
(1, 2, 'Xác nhận lịch hẹn #2', 'Kính gửi Ngô Quốc Anh, lịch hẹn của bạn vào 2025-05-25 11:00 đã được xác nhận.', '/appointments/2', 2, 'SMS', 'SENT', '2025-05-24 10:00:00'),
(3, 3, 'Khuyến mãi mới: Giảm 20% Massage', 'Kính gửi Trần Thị Ngọc, chúng tôi có ưu đãi mới: Giảm 20% Massage.', '/promotions/1', 1, 'EMAIL', 'SENT', '2025-05-24 09:00:00');

-- -----------------------------------------------------
-- Bước 3: Xác nhận chèn dữ liệu
-- -----------------------------------------------------
SELECT 'Sample data inserted successfully into all tables of spa_management_system_v10_online_payment.' AS message;
