-- -----------------------------------------------------
-- Sử dụng Cơ sở dữ liệu
-- -----------------------------------------------------
USE `spamanagement`;

-- -----------------------------------------------------
-- Bước 4: Chèn Dữ liệu Mẫu (Sample Data)
-- -----------------------------------------------------

-- 1. Bảng `roles` (Vai trò)
INSERT INTO `roles` (`role_id`, `name`, `display_name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'ADMIN', 'Quản trị viên', 'Quản lý toàn bộ hệ thống', NOW(), NOW()),
(2, 'MANAGER', 'Quản lý Spa', 'Quản lý hoạt động hàng ngày của spa', NOW(), NOW()),
(3, 'THERAPIST', 'Kỹ thuật viên', 'Thực hiện các dịch vụ cho khách hàng', NOW(), NOW()),
(4, 'RECEPTIONIST', 'Lễ tân', 'Tiếp đón khách, đặt lịch, thu ngân', NOW(), NOW()),
(5, 'CUSTOMER_REGISTERED', 'Khách hàng đã đăng ký', 'Khách hàng có tài khoản trên hệ thống', NOW(), NOW());

-- 2. Bảng `users` (Người dùng hệ thống - Nhân viên)
INSERT INTO `users` (`user_id`, `role_id`, `full_name`, `email`, `password_hash`, `phone_number`, `gender`, `birthday`, `avatar_url`, `is_active`, `last_login_at`, `created_at`, `updated_at`) VALUES
(1, 1, 'Nguyễn Văn An', 'admin@spademo.com', '$2b$10$abcdefghijklmnopqrstuv', '0912345678', 'MALE', '1980-01-15', 'https://placehold.co/100x100/E6E6FA/333333?text=NVAn', 1, NOW(), NOW(), NOW()),
(2, 2, 'Trần Thị Bình', 'manager@spademo.com', '$2b$10$abcdefghijklmnopqrstuv', '0987654321', 'FEMALE', '1985-05-20', 'https://placehold.co/100x100/FFF0F5/333333?text=TTBinh', 1, NOW(), NOW(), NOW()),
(3, 3, 'Lê Minh Cường', 'therapist1@spademo.com', '$2b$10$abcdefghijklmnopqrstuv', '0905112233', 'MALE', '1990-09-10', 'https://placehold.co/100x100/F0FFF0/333333?text=LMCuong', 1, NOW(), NOW(), NOW()),
(4, 3, 'Phạm Thị Dung', 'therapist2@spademo.com', '$2b$10$abcdefghijklmnopqrstuv', '0905445566', 'FEMALE', '1992-12-01', 'https://placehold.co/100x100/FAFAD2/333333?text=PTDung', 1, NOW(), NOW(), NOW()),
(5, 4, 'Hoàng Văn Em', 'receptionist@spademo.com', '$2b$10$abcdefghijklmnopqrstuv', '0918778899', 'MALE', '1995-03-25', 'https://placehold.co/100x100/ADD8E6/333333?text=HVEm', 1, NOW(), NOW(), NOW());

-- 3. Bảng `customers` (Khách hàng)
INSERT INTO `customers` (`customer_id`, `full_name`, `email`, `phone_number`, `hash_password`, `is_active`, `gender`, `birthday`, `address`, `loyalty_points`, `notes`, `role_id`, `created_at`, `updated_at`, `avatar_url`) VALUES
(1, 'Nguyễn Thị Mai', 'mai.nguyen@email.com', '0988111222', '$2b$10$abcdefghijklmnopqrstu', 1, 'FEMALE', '1990-07-15', '123 Đường Hoa, Quận 1, TP. HCM', 150, 'Khách hàng VIP, thích trà gừng.', 5, NOW(), NOW(), 'https://placehold.co/100x100/FFC0CB/333333?text=NTHMai'),
(2, 'Trần Văn Nam', 'nam.tran@email.com', '0977333444', '$2b$10$abcdefghijklmnopqrstu', 1, 'MALE', '1988-02-20', '456 Đường Cây, Quận 3, TP. HCM', 75, 'Thường đặt dịch vụ massage chân.', 5, NOW(), NOW(), 'https://placehold.co/100x100/B0E0E6/333333?text=TVNam'),
(3, 'Lê Thị Lan', 'lan.le@email.com', '0966555666', '$2b$10$abcdefghijklmnopqrstu', 1, 'FEMALE', '1995-11-30', '789 Đường Lá, Quận Bình Thạnh, TP. HCM', 200, 'Hay đi cùng bạn bè.', 5, NOW(), NOW(), 'https://placehold.co/100x100/98FB98/333333?text=LTLan'),
(4, 'Phạm Văn Hùng', 'hung.pham@email.com', '0955777888', '$2b$10$abcdefghijklmnopqrstu', 0, 'MALE', '1985-01-01', '101 Đường Sông, Quận 2, TP. HCM', 10, 'Tài khoản không hoạt động.', 5, NOW(), NOW(), 'https://placehold.co/100x100/D3D3D3/333333?text=PVHung'),
(5, 'Võ Thị Kim Chi', 'kimchi.vo@email.com', '0944999000', '$2b$10$abcdefghijklmnopqrstu', 1, 'FEMALE', '2000-10-10', '202 Đường Núi, Quận 7, TP. HCM', 50, NULL, 5, NOW(), NOW(), 'https://placehold.co/100x100/FFE4E1/333333?text=VTKChi'),
(6, 'Khách Vãng Lai A', NULL, '0912345001', NULL, 1, 'UNKNOWN', NULL, NULL, 0, 'Khách đặt qua điện thoại', NULL, NOW(), NOW(), NULL);


-- 4. Bảng `service_types` (Loại dịch vụ)
INSERT INTO `service_types` (`service_type_id`, `name`, `description`, `image_url`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Massage Thư Giãn', 'Các liệu pháp massage giúp thư giãn cơ thể và tinh thần.', 'https://placehold.co/300x200/E0FFFF/333333?text=Massage', 1, NOW(), NOW()),
(2, 'Chăm Sóc Da Mặt', 'Dịch vụ chăm sóc và cải thiện làn da mặt.', 'https://placehold.co/300x200/FFFACD/333333?text=Facial', 1, NOW(), NOW()),
(3, 'Chăm Sóc Toàn Thân', 'Các liệu pháp chăm sóc cơ thể toàn diện.', 'https://placehold.co/300x200/F5FFFA/333333?text=BodyCare', 1, NOW(), NOW()),
(4, 'Dịch Vụ Gội Đầu Dưỡng Sinh', 'Gội đầu kết hợp massage cổ vai gáy.', 'https://placehold.co/300x200/FFEBCD/333333?text=HairWash', 1, NOW(), NOW());

-- 5. Bảng `services` (Dịch vụ)
INSERT INTO `services` (`service_id`, `service_type_id`, `name`, `description`, `price`, `duration_minutes`, `buffer_time_after_minutes`, `image_url`, `is_active`, `average_rating`, `bookable_online`, `requires_consultation`, `created_at`, `updated_at`) VALUES
(1, 1, 'Massage Thụy Điển', 'Massage cổ điển giúp giảm căng thẳng, tăng cường lưu thông máu.', 500000.00, 60, 15, 'https://placehold.co/300x200/ADD8E6/333333?text=SwedishMassage', 1, 4.50, 1, 0, NOW(), NOW()),
(2, 1, 'Massage Đá Nóng', 'Sử dụng đá nóng bazan giúp thư giãn sâu các cơ bắp.', 700000.00, 90, 15, 'https://placehold.co/300x200/F0E68C/333333?text=HotStone', 1, 4.80, 1, 0, NOW(), NOW()),
(3, 2, 'Chăm Sóc Da Cơ Bản', 'Làm sạch sâu, tẩy tế bào chết, đắp mặt nạ dưỡng ẩm.', 400000.00, 60, 10, 'https://placehold.co/300x200/E6E6FA/333333?text=BasicFacial', 1, 4.20, 1, 0, NOW(), NOW()),
(4, 2, 'Trị Mụn Chuyên Sâu', 'Liệu trình trị mụn, giảm viêm, ngăn ngừa tái phát.', 650000.00, 75, 20, 'https://placehold.co/300x200/FFDAB9/333333?text=AcneTreatment', 1, 4.00, 1, 1, NOW(), NOW()),
(5, 3, 'Tẩy Tế Bào Chết Toàn Thân', 'Loại bỏ tế bào chết, giúp da mịn màng, tươi sáng.', 450000.00, 45, 10, 'https://placehold.co/300x200/90EE90/333333?text=BodyScrub', 1, 4.60, 1, 0, NOW(), NOW()),
(6, 4, 'Gội Đầu Thảo Dược', 'Gội đầu bằng thảo dược thiên nhiên, massage thư giãn.', 300000.00, 60, 10, 'https://placehold.co/300x200/FFE4B5/333333?text=HerbalHairWash', 1, 4.70, 1, 0, NOW(), NOW());

-- 6. Bảng `therapists` (Thông tin Kỹ thuật viên - mở rộng từ Users)
INSERT INTO `therapists` (`user_id`, `service_type_id`, `bio`, `availability_status`, `years_of_experience`, `created_at`, `updated_at`) VALUES
(3, 1, 'Chuyên gia massage trị liệu với 5 năm kinh nghiệm. Am hiểu các kỹ thuật massage Thụy Điển và đá nóng.', 'AVAILABLE', 5, NOW(), NOW()), -- Lê Minh Cường
(4, 2, 'Kỹ thuật viên chăm sóc da mặt, đặc biệt có kinh nghiệm trong điều trị mụn và trẻ hóa da.', 'AVAILABLE', 3, NOW(), NOW()); -- Phạm Thị Dung

-- 7. Bảng `categories` (Danh mục cho Dịch vụ và Blog)
INSERT INTO `categories` (`category_id`, `parent_category_id`, `name`, `slug`, `description`, `image_url`, `module_type`, `is_active`, `sort_order`, `created_at`, `updated_at`) VALUES
(1, NULL, 'Massage', 'massage', 'Các dịch vụ massage thư giãn và trị liệu', 'https://placehold.co/200x150/AFEEEE/333333?text=MassageCat', 'SERVICE', 1, 1, NOW(), NOW()),
(2, NULL, 'Chăm Sóc Da', 'cham-soc-da', 'Dịch vụ chăm sóc da mặt và toàn thân', 'https://placehold.co/200x150/FFEFD5/333333?text=SkinCareCat', 'SERVICE', 1, 2, NOW(), NOW()),
(3, 2, 'Da Mặt', 'da-mat', 'Chăm sóc chuyên sâu cho da mặt', 'https://placehold.co/200x150/FFE4E1/333333?text=FacialCat', 'SERVICE', 1, 1, NOW(), NOW()),
(4, NULL, 'Mẹo Chăm Sóc Sức Khỏe', 'meo-cham-soc-suc-khoe', 'Bài viết về cách chăm sóc sức khỏe và sắc đẹp', 'https://placehold.co/200x150/F5DEB3/333333?text=HealthTips', 'BLOG_POST', 1, 1, NOW(), NOW()),
(5, NULL, 'Tin Tức Spa', 'tin-tuc-spa', 'Cập nhật thông tin mới nhất từ spa', 'https://placehold.co/200x150/D2B48C/333333?text=SpaNews', 'BLOG_POST', 1, 2, NOW(), NOW());

-- 8. Bảng `service_categories` (Liên kết Dịch vụ - Danh mục)
INSERT INTO `service_categories` (`service_id`, `category_id`) VALUES
(1, 1), -- Massage Thụy Điển -> Massage
(2, 1), -- Massage Đá Nóng -> Massage
(3, 2), -- Chăm Sóc Da Cơ Bản -> Chăm Sóc Da
(3, 3), -- Chăm Sóc Da Cơ Bản -> Da Mặt
(4, 2), -- Trị Mụn Chuyên Sâu -> Chăm Sóc Da
(4, 3), -- Trị Mụn Chuyên Sâu -> Da Mặt
(5, 2), -- Tẩy Tế Bào Chết Toàn Thân -> Chăm Sóc Da
(6, 1); -- Gội Đầu Thảo Dược -> Massage (có thể thêm category riêng nếu cần)

-- 9. Bảng `blogs` (Bài viết Blog)
INSERT INTO `blogs` (`blog_id`, `author_user_id`, `title`, `slug`, `summary`, `content`, `feature_image_url`, `status`, `published_at`, `view_count`, `created_at`, `updated_at`) VALUES
(1, 2, '5 Lợi Ích Tuyệt Vời Của Massage Thường Xuyên', '5-loi-ich-tuyet-voi-cua-massage-thuong-xuyen', 'Khám phá những lợi ích sức khỏe không ngờ tới từ việc massage định kỳ.', 'Nội dung chi tiết về 5 lợi ích của massage... (HTML/Markdown)', 'https://placehold.co/600x400/B2DFEE/333333?text=BlogMassage', 'PUBLISHED', NOW(), 150, NOW(), NOW()),
(2, 2, 'Bí Quyết Sở Hữu Làn Da Căng Bóng Mùa Hè', 'bi-quyet-so-huu-lan-da-cang-bong-mua-he', 'Những mẹo chăm sóc da đơn giản mà hiệu quả giúp bạn tự tin tỏa sáng trong mùa hè.', 'Nội dung chi tiết về bí quyết chăm sóc da mùa hè... (HTML/Markdown)', 'https://placehold.co/600x400/FFDAB9/333333?text=BlogSkincare', 'PUBLISHED', NOW(), 220, NOW(), NOW()),
(3, 1, 'Chương Trình Khuyến Mãi Mới Tại Spa', 'chuong-trinh-khuyen-mai-moi-tai-spa', 'Thông báo về các gói ưu đãi hấp dẫn sắp ra mắt.', 'Nội dung chi tiết về chương trình khuyến mãi... (HTML/Markdown)', 'https://placehold.co/600x400/98FB98/333333?text=BlogPromo', 'DRAFT', NULL, 0, NOW(), NOW());

-- 10. Bảng `blog_categories` (Liên kết Blog - Danh mục)
INSERT INTO `blog_categories` (`blog_id`, `category_id`) VALUES
(1, 4), -- Blog Massage -> Mẹo Chăm Sóc Sức Khỏe
(2, 4), -- Blog Skincare -> Mẹo Chăm Sóc Sức Khỏe
(3, 5); -- Blog Promo -> Tin Tức Spa

-- 11. Bảng `spa_information` (Thông tin Spa)
INSERT INTO `spa_information` (`spa_id`, `name`, `address_line1`, `address_line2`, `city`, `postal_code`, `country`, `phone_number_main`, `phone_number_secondary`, `email_main`, `email_secondary`, `website_url`, `logo_url`, `tax_identification_number`, `cancellation_policy`, `booking_terms`, `about_us_short`, `about_us_long`, `vat_percentage`, `default_appointment_buffer_minutes`, `created_at`, `updated_at`) VALUES
(1, 'An nhiên Spa', 'Số 10 Đường An Bình', 'Phường Yên Hòa', 'Hà Nội', '100000', 'Việt Nam', '02412345678', '0912345678', 'contact@annhienspa.vn', 'support@annhienspa.vn', 'https://annhienspa.vn', 'https://placehold.co/200x100/E6F2FF/333333?text=AnNhienLogo', '0123456789', 'Vui lòng hủy lịch trước 24 giờ để tránh phí hủy. Chi tiết xem tại website.', 'Điều khoản đặt lịch chi tiết có tại quầy lễ tân và website của spa.', 'Nơi bạn tìm thấy sự thư giãn và tái tạo năng lượng.', 'An nhiên Spa cung cấp các dịch vụ chăm sóc sức khỏe và sắc đẹp hàng đầu với đội ngũ chuyên nghiệp và không gian yên tĩnh.', 8.00, 15, NOW(), NOW());

-- 12. Bảng `business_hours` (Giờ làm việc)
INSERT INTO `business_hours` (`business_hour_id`, `day_of_week`, `open_time`, `close_time`, `is_closed`, `notes`) VALUES
(1, 'MONDAY', '09:00:00', '21:00:00', 0, NULL),
(2, 'TUESDAY', '09:00:00', '21:00:00', 0, NULL),
(3, 'WEDNESDAY', '09:00:00', '21:00:00', 0, NULL),
(4, 'THURSDAY', '09:00:00', '21:00:00', 0, NULL),
(5, 'FRIDAY', '09:00:00', '22:00:00', 0, 'Mở cửa muộn hơn'),
(6, 'SATURDAY', '09:00:00', '22:00:00', 0, 'Mở cửa muộn hơn'),
(7, 'SUNDAY', '10:00:00', '20:00:00', 0, NULL);

-- 13. Bảng `promotions` (Khuyến mãi)
INSERT INTO `promotions` (`promotion_id`, `title`, `description`, `promotion_code`, `discount_type`, `discount_value`, `applies_to_service_id`, `minimum_appointment_value`, `start_date`, `end_date`, `status`, `usage_limit_per_customer`, `total_usage_limit`, `current_usage_count`, `applicable_scope`, `applicable_service_ids_json`, `image_url`, `terms_and_conditions`, `created_by_user_id`, `is_auto_apply`, `created_at`, `updated_at`) VALUES
(1, 'Chào Hè Rực Rỡ - Giảm 20%', 'Giảm giá 20% cho tất cả dịch vụ massage.', 'SUMMER20', 'PERCENTAGE', 20.00, NULL, 500000.00, '2025-06-01 00:00:00', '2025-08-31 23:59:59', 'ACTIVE', 1, 100, 10, 'SPECIFIC_SERVICES', '[1, 2]', 'https://placehold.co/400x200/FFD700/333333?text=SummerPromo', 'Áp dụng cho các dịch vụ massage. Không áp dụng cùng KM khác.', 1, 0, NOW(), NOW()),
(2, 'Tri Ân Khách Hàng - Tặng Voucher 100K', 'Tặng voucher 100.000 VNĐ cho hóa đơn từ 1.000.000 VNĐ.', 'THANKS100K', 'FIXED_AMOUNT', 100000.00, NULL, 1000000.00, '2025-07-01 00:00:00', '2025-07-31 23:59:59', 'SCHEDULED', 1, 200, 0, 'ENTIRE_APPOINTMENT', NULL, 'https://placehold.co/400x200/E6E6FA/333333?text=VoucherPromo', 'Mỗi khách hàng được sử dụng 1 lần.', 2, 0, NOW(), NOW()),
(3, 'Đi Cùng Bạn Bè - Miễn Phí 1 Dịch Vụ Gội Đầu', 'Khi đặt 2 dịch vụ bất kỳ, tặng 1 dịch vụ gội đầu thảo dược.', 'FRIENDSFREE', 'FREE_SERVICE', 6, NULL, 800000.00, '2025-06-15 00:00:00', '2025-07-15 23:59:59', 'ACTIVE', 1, 50, 5, 'ENTIRE_APPOINTMENT', NULL, 'https://placehold.co/400x200/B0C4DE/333333?text=FriendsPromo', 'Dịch vụ tặng kèm là Gội Đầu Thảo Dược (ID: 6).', 1, 0, NOW(), NOW());

-- 14. Bảng `shopping_carts` (Giỏ hàng)
INSERT INTO `shopping_carts` (`cart_id`, `customer_id`, `session_id`, `created_at`, `updated_at`, `status`) VALUES
(1, 1, NULL, NOW(), NOW(), 'ACTIVE'), -- Giỏ hàng của Nguyễn Thị Mai
(2, NULL, 'sess_abc123xyz789', NOW(), NOW(), 'ACTIVE'), -- Giỏ hàng của khách vãng lai
(3, 2, NULL, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY), 'ABANDONED'); -- Giỏ hàng bị bỏ quên của Trần Văn Nam

-- 15. Bảng `cart_items` (Các mục trong giỏ hàng)
INSERT INTO `cart_items` (`cart_item_id`, `cart_id`, `service_id`, `quantity`, `price_at_addition`, `therapist_user_id_preference`, `preferred_start_time_slot`, `notes`, `added_at`, `is_converted_to_appointment`) VALUES
(1, 1, 2, 1, 700000.00, 3, '2025-06-10 14:00:00', 'Xin phòng riêng nếu có thể.', NOW(), 0), -- Massage Đá Nóng cho Nguyễn Thị Mai
(2, 1, 6, 1, 300000.00, NULL, '2025-06-10 16:00:00', NULL, NOW(), 0), -- Gội Đầu Thảo Dược cho Nguyễn Thị Mai
(3, 2, 1, 1, 500000.00, NULL, NULL, 'Đặt cho buổi chiều.', NOW(), 0), -- Massage Thụy Điển cho khách vãng lai
(4, 3, 3, 2, 400000.00, 4, '2025-05-28 10:00:00', 'Cho 2 người.', DATE_SUB(NOW(), INTERVAL 2 DAY), 0); -- Chăm Sóc Da Cơ Bản cho Trần Văn Nam (bỏ quên)


-- 16. Bảng `booking_groups` (Nhóm đặt lịch)
INSERT INTO `booking_groups` (`booking_group_id`, `represent_customer_id`, `group_name`, `expected_pax`, `group_notes`, `status`, `created_at`, `updated_at`) VALUES
(1, 3, 'Sinh nhật Lan', 4, 'Nhóm bạn thân, muốn các phòng gần nhau.', 'PENDING_CONFIRMATION', NOW(), NOW()), -- Lê Thị Lan đại diện
(2, 1, 'Thư giãn cuối tuần', 2, 'Cặp đôi, yêu cầu phòng đôi.', 'PENDING_CONFIRMATION', NOW(), NOW()); -- Nguyễn Thị Mai đại diện

-- 17. Bảng `appointments` (Lịch hẹn)
-- Appointment 1: Nguyễn Thị Mai, Massage Đá Nóng, KTV Cường, đã xác nhận, chưa thanh toán
INSERT INTO `appointments` (`customer_id`, `booking_group_id`, `therapist_user_id`, `service_id`, `start_time`, `end_time`, `original_service_price`, `discount_amount_applied`, `final_price_after_discount`, `points_redeemed_value`, `final_amount_payable`, `promotion_id`, `status`, `payment_status`, `notes_by_customer`, `notes_by_staff`, `cancel_reason`, `created_from_cart_item_id`, `created_at`, `updated_at`) VALUES
(1, NULL, 3, 2, '2025-06-05 14:00:00', '2025-06-05 15:30:00', 700000.00, 0.00, 700000.00, 0.00, 700000.00, NULL, 'CONFIRMED', 'UNPAID', 'Mong được thư giãn tốt nhất.', 'Khách quen, đã chuẩn bị phòng VIP.', NULL, 1, NOW(), NOW());
SET @last_appointment_id_1 = LAST_INSERT_ID();

-- Appointment 2: Trần Văn Nam, Chăm Sóc Da Cơ Bản, KTV Dung, đã hoàn thành, đã thanh toán
INSERT INTO `appointments` (`customer_id`, `booking_group_id`, `therapist_user_id`, `service_id`, `start_time`, `end_time`, `original_service_price`, `discount_amount_applied`, `final_price_after_discount`, `points_redeemed_value`, `final_amount_payable`, `promotion_id`, `status`, `payment_status`, `notes_by_customer`, `notes_by_staff`, `cancel_reason`, `created_from_cart_item_id`, `created_at`, `updated_at`) VALUES
(2, NULL, 4, 3, '2025-06-03 10:00:00', '2025-06-03 11:00:00', 400000.00, 0.00, 400000.00, 50000.00, 350000.00, NULL, 'COMPLETED', 'PAID', 'Da tôi hơi nhạy cảm.', 'Sử dụng sản phẩm dịu nhẹ.', NULL, NULL, NOW(), NOW());
SET @last_appointment_id_2 = LAST_INSERT_ID();

-- Appointment 3: Lê Thị Lan (đại diện nhóm 1), Massage Thụy Điển, KTV Cường, đang chờ xác nhận
INSERT INTO `appointments` (`customer_id`, `booking_group_id`, `therapist_user_id`, `service_id`, `start_time`, `end_time`, `original_service_price`, `discount_amount_applied`, `final_price_after_discount`, `points_redeemed_value`, `final_amount_payable`, `promotion_id`, `status`, `payment_status`, `notes_by_customer`, `notes_by_staff`, `cancel_reason`, `created_from_cart_item_id`, `created_at`, `updated_at`) VALUES
(3, 1, 3, 1, '2025-06-12 15:00:00', '2025-06-12 16:00:00', 500000.00, 100000.00, 400000.00, 0.00, 400000.00, 1, 'PENDING_CONFIRMATION', 'UNPAID', 'Đây là 1 trong 4 suất của nhóm.', NULL, NULL, NULL, NOW(), NOW());
SET @last_appointment_id_3 = LAST_INSERT_ID();

-- Appointment 4: Khách Vãng Lai A, Gội Đầu Thảo Dược, chưa có KTV, đã hủy bởi khách
INSERT INTO `appointments` (`customer_id`, `booking_group_id`, `therapist_user_id`, `service_id`, `start_time`, `end_time`, `original_service_price`, `discount_amount_applied`, `final_price_after_discount`, `points_redeemed_value`, `final_amount_payable`, `promotion_id`, `status`, `payment_status`, `notes_by_customer`, `notes_by_staff`, `cancel_reason`, `created_from_cart_item_id`, `created_at`, `updated_at`) VALUES
(6, NULL, NULL, 6, '2025-06-04 11:00:00', '2025-06-04 12:00:00', 300000.00, 0.00, 300000.00, 0.00, 300000.00, NULL, 'CANCELLED_BY_CUSTOMER', 'UNPAID', 'Đặt qua điện thoại.', NULL, 'Khách báo bận đột xuất', NULL, NOW(), NOW());
SET @last_appointment_id_4 = LAST_INSERT_ID();


-- 18. Bảng `payments` (Thanh toán Online)
-- Payment cho Appointment 2 (Trần Văn Nam)
INSERT INTO `payments` (`appointment_id`, `customer_id`, `amount_paid`, `payment_method`, `payment_date`, `transaction_id_gateway`, `status`, `notes`, `created_at`, `updated_at`) VALUES
(@last_appointment_id_2, 2, 350000.00, 'VNPAY', '2025-06-03 11:05:00', 'VNPAY_TRN001', 'COMPLETED', 'Thanh toán thành công cho dịch vụ Chăm Sóc Da Cơ Bản.', NOW(), NOW());
SET @last_payment_id_1 = LAST_INSERT_ID();

-- Payment đang chờ cho Appointment 1 (Nguyễn Thị Mai)
INSERT INTO `payments` (`appointment_id`, `customer_id`, `amount_paid`, `payment_method`, `payment_date`, `transaction_id_gateway`, `status`, `notes`, `created_at`, `updated_at`) VALUES
(@last_appointment_id_1, 1, 700000.00, 'MOMO', '2025-06-05 13:00:00', 'MOMO_TRN002', 'PENDING', 'Khách hàng đã tạo yêu cầu thanh toán qua Momo.', NOW(), NOW());
SET @last_payment_id_2 = LAST_INSERT_ID();


-- 19. Bảng `general_transactions_log` (Nhật ký giao dịch chung)
-- Giao dịch cho thanh toán của Appointment 2
INSERT INTO `general_transactions_log` (`payment_id`, `user_id`, `customer_id`, `related_entity_type`, `related_entity_id`, `transaction_code_internal`, `type`, `amount`, `currency_code`, `description`, `status`, `transaction_date`) VALUES
(@last_payment_id_1, NULL, 2, 'APPOINTMENT_PAYMENT', @last_appointment_id_2, 'SPA_PAY_00001', 'CREDIT_SPA', 350000.00, 'VND', CONCAT('Thu tiền dịch vụ Chăm Sóc Da Cơ Bản (ID: 3) cho lịch hẹn ID: ', @last_appointment_id_2), 'COMPLETED', '2025-06-03 11:05:00');

-- Giao dịch đổi điểm của Appointment 2
INSERT INTO `general_transactions_log` (`payment_id`, `user_id`, `customer_id`, `related_entity_type`, `related_entity_id`, `transaction_code_internal`, `type`, `amount`, `currency_code`, `description`, `status`, `transaction_date`) VALUES
(NULL, NULL, 2, 'POINT_REDEMPTION', @last_appointment_id_2, 'SPA_POINT_RD_00001', 'DEBIT_SPA', 50000.00, 'VND', CONCAT('Khách hàng Trần Văn Nam đổi 50 điểm (tương đương 50.000 VND) cho lịch hẹn ID: ', @last_appointment_id_2), 'COMPLETED', '2025-06-03 11:00:00');

-- Giao dịch cho thanh toán đang chờ của Appointment 1
INSERT INTO `general_transactions_log` (`payment_id`, `user_id`, `customer_id`, `related_entity_type`, `related_entity_id`, `transaction_code_internal`, `type`, `amount`, `currency_code`, `description`, `status`, `transaction_date`) VALUES
(@last_payment_id_2, NULL, 1, 'APPOINTMENT_PAYMENT', @last_appointment_id_1, 'SPA_PAY_00002', 'CREDIT_SPA', 700000.00, 'VND', CONCAT('Ghi nhận yêu cầu thanh toán cho dịch vụ Massage Đá Nóng (ID: 2) cho lịch hẹn ID: ', @last_appointment_id_1), 'PENDING', '2025-06-05 13:00:00');


-- 20. Bảng `loyalty_point_transactions` (Giao dịch điểm thưởng)
-- Kiếm điểm từ Appointment 2 (sau khi hoàn thành và thanh toán)
INSERT INTO `loyalty_point_transactions` (`customer_id`, `transaction_type`, `points_changed`, `balance_after_transaction`, `related_appointment_id`, `related_payment_id`, `description`, `transaction_date`, `admin_user_id`) VALUES
(2, 'EARNED_APPOINTMENT', 35, (SELECT loyalty_points FROM customers WHERE customer_id = 2) + 35, @last_appointment_id_2, @last_payment_id_1, 'Tích điểm từ lịch hẹn hoàn thành (10.000 VND = 1 điểm)', '2025-06-03 11:10:00', NULL);
-- Cập nhật điểm cho khách hàng 2
UPDATE `customers` SET `loyalty_points` = `loyalty_points` + 35 WHERE `customer_id` = 2;

-- Đổi điểm cho Appointment 2
INSERT INTO `loyalty_point_transactions` (`customer_id`, `transaction_type`, `points_changed`, `balance_after_transaction`, `related_appointment_id`, `related_payment_id`, `description`, `transaction_date`, `admin_user_id`) VALUES
(2, 'REDEEMED_PAYMENT', -50, (SELECT loyalty_points FROM customers WHERE customer_id = 2) - 50, @last_appointment_id_2, NULL, 'Đổi 50 điểm trừ vào thanh toán lịch hẹn', '2025-06-03 11:00:00', NULL);
-- Cập nhật điểm cho khách hàng 2
UPDATE `customers` SET `loyalty_points` = `loyalty_points` - 50 WHERE `customer_id` = 2;


-- Admin điều chỉnh điểm cho khách hàng 1
INSERT INTO `loyalty_point_transactions` (`customer_id`, `transaction_type`, `points_changed`, `balance_after_transaction`, `related_appointment_id`, `related_payment_id`, `description`, `transaction_date`, `admin_user_id`) VALUES
(1, 'ADMIN_ADJUSTMENT', 100, (SELECT loyalty_points FROM customers WHERE customer_id = 1) + 100, NULL, NULL, 'Tặng điểm tri ân khách hàng VIP.', NOW(), 1);
-- Cập nhật điểm cho khách hàng 1
UPDATE `customers` SET `loyalty_points` = `loyalty_points` + 100 WHERE `customer_id` = 1;


-- 21. Bảng `service_reviews` (Đánh giá dịch vụ)
-- Đánh giá cho Appointment 2
INSERT INTO `service_reviews` (`service_id`, `customer_id`, `appointment_id`, `rating`, `title`, `comment`, `created_at`, `updated_at`) VALUES
(3, 2, @last_appointment_id_2, 5, 'Rất hài lòng!', 'Dịch vụ chăm sóc da rất tốt, da tôi cải thiện rõ rệt. Kỹ thuật viên Dung rất nhiệt tình.', NOW(), NOW());
-- Cập nhật rating trung bình cho service 3
UPDATE `services` SET `average_rating` = (SELECT AVG(rating) FROM `service_reviews` WHERE `service_id` = 3) WHERE `service_id` = 3;

-- Thêm một đánh giá khác cho dịch vụ khác (giả sử đã có lịch hẹn trước đó)
-- Giả sử có một lịch hẹn ID 100 cho service_id 1, customer_id 1 đã hoàn thành
-- INSERT INTO `appointments` (appointment_id, customer_id, ...) VALUES (100, 1, ...);
-- INSERT INTO `service_reviews` (`service_id`, `customer_id`, `appointment_id`, `rating`, `title`, `comment`, `created_at`, `updated_at`) VALUES
-- (1, 1, 100, 4, 'Khá tốt', 'Massage Thụy Điển giúp tôi thư giãn, nhưng phòng hơi ồn.', NOW(), NOW());
-- UPDATE `services` SET `average_rating` = (SELECT AVG(rating) FROM `service_reviews` WHERE `service_id` = 1) WHERE `service_id` = 1;


-- 22. Bảng `therapist_schedules` (Lịch làm việc của KTV)
-- KTV Cường (ID: 3)
INSERT INTO `therapist_schedules` (`therapist_user_id`, `start_datetime`, `end_datetime`, `is_available`, `notes`, `created_at`, `updated_at`) VALUES
(3, '2025-06-05 09:00:00', '2025-06-05 18:00:00', 1, 'Ca làm việc ngày 05/06', NOW(), NOW()),
(3, '2025-06-06 09:00:00', '2025-06-06 12:00:00', 1, 'Ca sáng ngày 06/06', NOW(), NOW()),
(3, '2025-06-06 12:00:00', '2025-06-06 13:00:00', 0, 'Nghỉ trưa', NOW(), NOW()),
(3, '2025-06-06 13:00:00', '2025-06-06 18:00:00', 1, 'Ca chiều ngày 06/06', NOW(), NOW());

-- KTV Dung (ID: 4)
INSERT INTO `therapist_schedules` (`therapist_user_id`, `start_datetime`, `end_datetime`, `is_available`, `notes`, `created_at`, `updated_at`) VALUES
(4, '2025-06-05 13:00:00', '2025-06-05 21:00:00', 1, 'Ca làm việc ngày 05/06', NOW(), NOW());


-- 23. Bảng `notification_types` (Loại thông báo)
INSERT INTO `notification_types` (`notification_type_id`, `name`, `description`, `template_email_subject`, `template_email_body`, `template_sms_message`, `template_in_app_message`, `icon_class`, `is_customer_facing`, `is_staff_facing`, `created_at`, `updated_at`) VALUES
(1, 'APPOINTMENT_CONFIRMATION', 'Xác nhận lịch hẹn thành công', 'Xác nhận lịch hẹn tại An nhiên Spa', 'Kính chào {{customer_name}}, Lịch hẹn của bạn cho dịch vụ {{service_name}} vào lúc {{start_time}} đã được xác nhận. Mã lịch hẹn: {{appointment_id}}.', 'AnNhienSpa: Lich hen {{service_name}} luc {{start_time}} da duoc xac nhan. Ma LH: {{appointment_id}}. Cam on!', 'Lịch hẹn #{{appointment_id}} cho {{service_name}} đã được xác nhận!', 'fas fa-calendar-check', 1, 1, NOW(), NOW()),
(2, 'APPOINTMENT_REMINDER', 'Nhắc nhở lịch hẹn sắp tới', 'Nhắc nhở: Lịch hẹn của bạn tại An nhiên Spa sắp diễn ra', 'Kính chào {{customer_name}}, Nhắc bạn lịch hẹn dịch vụ {{service_name}} vào lúc {{start_time}} ngày mai. Vui lòng có mặt trước 10 phút. Trân trọng!', 'AnNhienSpa: Nhac ban lich hen {{service_name}} vao {{start_time}} ngay mai. Hotline: 02412345678.', 'Đừng quên! Lịch hẹn #{{appointment_id}} cho {{service_name}} vào {{start_time}} ngày mai.', 'fas fa-bell', 1, 0, NOW(), NOW()),
(3, 'NEW_APPOINTMENT_FOR_THERAPIST', 'Thông báo lịch hẹn mới cho KTV', 'Bạn có lịch hẹn mới', 'Chào {{therapist_name}}, Bạn có lịch hẹn mới: KH {{customer_name}}, Dịch vụ {{service_name}}, Thời gian {{start_time}} - {{end_time}}. Chi tiết xem tại hệ thống.', NULL, 'Lịch hẹn mới: KH {{customer_name}} - {{service_name}} lúc {{start_time}}', 'fas fa-user-clock', 0, 1, NOW(), NOW());

-- 24. Bảng `notifications_master` (Template thông báo gốc)
INSERT INTO `notifications_master` (`master_notification_id`, `notification_type_id`, `title_template`, `content_template`, `link_url_template`, `related_entity_type_context`, `created_by_user_id`, `trigger_event`, `created_at`, `updated_at`) VALUES
(1, 1, 'Xác nhận lịch hẹn #{{appointment_id}}', 'Lịch hẹn của bạn cho dịch vụ {{service_name}} với KTV {{therapist_name}} vào lúc {{start_time}} ngày {{appointment_date}} đã được XÁC NHẬN.', '/appointments/view/{{appointment_id}}', 'APPOINTMENT', NULL, 'APPOINTMENT_STATUS_CONFIRMED', NOW(), NOW()),
(2, 2, 'Nhắc lịch hẹn #{{appointment_id}} ngày mai', 'Đừng quên lịch hẹn của bạn cho dịch vụ {{service_name}} vào {{start_time}} ngày mai ({{appointment_date}}).', '/appointments/view/{{appointment_id}}', 'APPOINTMENT', NULL, 'APPOINTMENT_REMINDER_24H', NOW(), NOW()),
(3, 3, 'Lịch hẹn mới: {{service_name}} - {{customer_name}}', 'Bạn được chỉ định thực hiện dịch vụ {{service_name}} cho khách hàng {{customer_name}} (SĐT: {{customer_phone}}) vào lúc {{start_time}} ngày {{appointment_date}}.', '/staff/schedule/view/{{appointment_id}}', 'APPOINTMENT', NULL, 'APPOINTMENT_ASSIGNED_TO_THERAPIST', NOW(), NOW());

-- 25. Bảng `customer_sent_notifications` (Thông báo đã gửi cho khách hàng)
-- Thông báo xác nhận cho Appointment 1
INSERT INTO `customer_sent_notifications` (`master_notification_id`, `recipient_customer_id`, `actual_title`, `actual_content`, `actual_link_url`, `related_entity_id`, `is_read`, `read_at`, `delivery_channel`, `delivery_status`, `scheduled_send_at`, `actually_sent_at`, `created_at`) VALUES
(1, 1, CONCAT('Xác nhận lịch hẹn #', @last_appointment_id_1), 'Lịch hẹn của bạn cho dịch vụ Massage Đá Nóng với KTV Lê Minh Cường vào lúc 14:00:00 ngày 2025-06-05 đã được XÁC NHẬN.', CONCAT('/appointments/view/', @last_appointment_id_1), @last_appointment_id_1, 0, NULL, 'EMAIL', 'SENT', NOW(), NOW(), NOW());

-- Thông báo nhắc nhở cho Appointment 2 (giả sử đã gửi hôm qua)
INSERT INTO `customer_sent_notifications` (`master_notification_id`, `recipient_customer_id`, `actual_title`, `actual_content`, `actual_link_url`, `related_entity_id`, `is_read`, `read_at`, `delivery_channel`, `delivery_status`, `scheduled_send_at`, `actually_sent_at`, `created_at`) VALUES
(2, 2, CONCAT('Nhắc lịch hẹn #', @last_appointment_id_2, ' ngày mai'), 'Đừng quên lịch hẹn của bạn cho dịch vụ Chăm Sóc Da Cơ Bản vào 10:00:00 ngày mai (2025-06-03).', CONCAT('/appointments/view/', @last_appointment_id_2), @last_appointment_id_2, 1, '2025-06-02 10:05:00', 'SMS', 'DELIVERED', '2025-06-02 10:00:00', '2025-06-02 10:00:05', '2025-06-02 10:00:00');


-- 26. Bảng `user_sent_notifications` (Thông báo đã gửi cho nhân viên)
-- Thông báo lịch hẹn mới cho KTV Cường (Appointment 1)
INSERT INTO `user_sent_notifications` (`master_notification_id`, `recipient_user_id`, `actual_title`, `actual_content`, `actual_link_url`, `related_entity_id`, `is_read`, `read_at`, `delivery_channel`, `delivery_status`, `scheduled_send_at`, `actually_sent_at`, `created_at`) VALUES
(3, 3, 'Lịch hẹn mới: Massage Đá Nóng - Nguyễn Thị Mai', 'Bạn được chỉ định thực hiện dịch vụ Massage Đá Nóng cho khách hàng Nguyễn Thị Mai (SĐT: 0988111222) vào lúc 14:00:00 ngày 2025-06-05.', CONCAT('/staff/schedule/view/', @last_appointment_id_1), @last_appointment_id_1, 0, NULL, 'IN_APP', 'VIEWED_IN_APP', NOW(), NOW(), NOW());

-- Thông báo lịch hẹn mới cho KTV Dung (Appointment 2)
INSERT INTO `user_sent_notifications` (`master_notification_id`, `recipient_user_id`, `actual_title`, `actual_content`, `actual_link_url`, `related_entity_id`, `is_read`, `read_at`, `delivery_channel`, `delivery_status`, `scheduled_send_at`, `actually_sent_at`, `created_at`) VALUES
(3, 4, 'Lịch hẹn mới: Chăm Sóc Da Cơ Bản - Trần Văn Nam', 'Bạn được chỉ định thực hiện dịch vụ Chăm Sóc Da Cơ Bản cho khách hàng Trần Văn Nam (SĐT: 0977333444) vào lúc 10:00:00 ngày 2025-06-03.', CONCAT('/staff/schedule/view/', @last_appointment_id_2), @last_appointment_id_2, 1, '2025-06-02 09:30:00', 'EMAIL', 'SENT', '2025-06-02 09:25:00', '2025-06-02 09:25:05', '2025-06-02 09:25:00');

-- Cập nhật lại cart_item_id cho appointment 1 nếu nó được tạo từ cart_item
UPDATE `appointments` SET `created_from_cart_item_id` = 1 WHERE `appointment_id` = @last_appointment_id_1;
UPDATE `cart_items` SET `is_converted_to_appointment` = 1 WHERE `cart_item_id` = 1;

-- Hoàn tất chèn dữ liệu mẫu
