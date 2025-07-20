-- =====================================================
-- GENERAL NOTIFICATION SYSTEM FOR SPA MANAGEMENT
-- Compatible with existing schema conventions
-- =====================================================

USE `spamanagement`;

-- =====================================================
-- DROP ALL TABLES IN CORRECT ORDER (CHILD TABLES FIRST)
-- =====================================================
-- Drop child tables first (tables with foreign keys)
DROP TABLE IF EXISTS `customer_appointment_notifications`;
DROP TABLE IF EXISTS `scheduling_sessions`;
DROP TABLE IF EXISTS `payment_scheduling_notifications`;
DROP TABLE IF EXISTS `notification_statistics`;
DROP TABLE IF EXISTS `notification_preferences`;
DROP TABLE IF EXISTS `notification_recipients`;
DROP TABLE IF EXISTS `notification_templates`;
-- Drop parent table last
DROP TABLE IF EXISTS `general_notifications`;

-- =====================================================
-- 1. GENERAL NOTIFICATIONS TABLE
-- =====================================================
CREATE TABLE `general_notifications` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tiêu đề thông báo',
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nội dung thông báo',
  `notification_type` enum('SYSTEM_ANNOUNCEMENT','PROMOTION','MAINTENANCE','POLICY_UPDATE','BOOKING_REMINDER','PAYMENT_NOTIFICATION','SERVICE_UPDATE','EMERGENCY','MARKETING_CAMPAIGN','INVENTORY_ALERT') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SYSTEM_ANNOUNCEMENT' COMMENT 'Loại thông báo',
  `priority` enum('LOW','MEDIUM','HIGH','URGENT') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MEDIUM' COMMENT 'Mức độ ưu tiên',
  `target_type` enum('ALL_USERS','ROLE_BASED','INDIVIDUAL','CUSTOMER_SEGMENT') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ALL_USERS' COMMENT 'Đối tượng nhận thông báo',
  `target_role_ids` json DEFAULT NULL COMMENT 'Danh sách role_id nhận thông báo (cho ROLE_BASED)',
  `target_user_ids` json DEFAULT NULL COMMENT 'Danh sách user_id cụ thể (cho INDIVIDUAL)',
  `target_customer_ids` json DEFAULT NULL COMMENT 'Danh sách customer_id cụ thể',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL hình ảnh đính kèm',
  `attachment_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL file đính kèm',
  `action_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL hành động khi click thông báo',
  `action_text` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Text nút hành động',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Thông báo có hoạt động không',
  `start_date` datetime DEFAULT NULL COMMENT 'Thời gian bắt đầu hiển thị',
  `end_date` datetime DEFAULT NULL COMMENT 'Thời gian kết thúc hiển thị',
  `created_by_user_id` int NOT NULL COMMENT 'User tạo thông báo',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  KEY `idx_notification_type` (`notification_type`),
  KEY `idx_priority` (`priority`),
  KEY `idx_target_type` (`target_type`),
  KEY `idx_active_dates` (`is_active`, `start_date`, `end_date`),
  KEY `idx_created_by` (`created_by_user_id`),
  CONSTRAINT `general_notifications_ibfk_1` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng thông báo chung cho tất cả user roles';

-- =====================================================
-- 2. NOTIFICATION RECIPIENTS TABLE
-- =====================================================
CREATE TABLE `notification_recipients` (
  `recipient_id` int NOT NULL AUTO_INCREMENT,
  `notification_id` int NOT NULL,
  `user_id` int DEFAULT NULL COMMENT 'User nhận thông báo (staff)',
  `customer_id` int DEFAULT NULL COMMENT 'Customer nhận thông báo',
  `is_read` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Đã đọc chưa',
  `read_at` timestamp NULL DEFAULT NULL COMMENT 'Thời gian đọc',
  `is_dismissed` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Đã dismiss chưa',
  `dismissed_at` timestamp NULL DEFAULT NULL COMMENT 'Thời gian dismiss',
  `delivery_status` enum('PENDING','DELIVERED','FAILED','EXPIRED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING' COMMENT 'Trạng thái gửi',
  `delivery_method` enum('WEB','EMAIL','SMS','PUSH') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'WEB' COMMENT 'Phương thức gửi',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`recipient_id`),
  UNIQUE KEY `unique_notification_recipient` (`notification_id`, `user_id`, `customer_id`),
  KEY `idx_notification_id` (`notification_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_customer_id` (`customer_id`),
  KEY `idx_read_status` (`is_read`, `read_at`),
  KEY `idx_delivery_status` (`delivery_status`),
  CONSTRAINT `notification_recipients_ibfk_1` FOREIGN KEY (`notification_id`) REFERENCES `general_notifications` (`notification_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `notification_recipients_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `notification_recipients_ibfk_3` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`),
  CONSTRAINT `chk_recipient_type` CHECK (((`user_id` IS NOT NULL) AND (`customer_id` IS NULL)) OR ((`user_id` IS NULL) AND (`customer_id` IS NOT NULL)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng theo dõi người nhận thông báo và trạng thái đọc';

-- =====================================================
-- 3. NOTIFICATION TEMPLATES TABLE
-- =====================================================
CREATE TABLE `notification_templates` (
  `template_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên template',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Mô tả template',
  `notification_type` enum('SYSTEM_ANNOUNCEMENT','PROMOTION','MAINTENANCE','POLICY_UPDATE','BOOKING_REMINDER','PAYMENT_NOTIFICATION','SERVICE_UPDATE','EMERGENCY','MARKETING_CAMPAIGN','INVENTORY_ALERT') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Loại thông báo',
  `title_template` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Template tiêu đề với placeholders',
  `message_template` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Template nội dung với placeholders',
  `default_priority` enum('LOW','MEDIUM','HIGH','URGENT') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MEDIUM',
  `default_target_type` enum('ALL_USERS','ROLE_BASED','INDIVIDUAL','CUSTOMER_SEGMENT') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ALL_USERS',
  `default_role_ids` json DEFAULT NULL COMMENT 'Role mặc định cho template',
  `placeholders` json DEFAULT NULL COMMENT 'Danh sách placeholders và mô tả',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_by_user_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`template_id`),
  UNIQUE KEY `name` (`name`),
  KEY `idx_notification_type` (`notification_type`),
  KEY `idx_active` (`is_active`),
  KEY `idx_created_by` (`created_by_user_id`),
  CONSTRAINT `notification_templates_ibfk_1` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Templates cho thông báo có thể tái sử dụng';

-- =====================================================
-- 4. NOTIFICATION PREFERENCES TABLE
-- =====================================================
CREATE TABLE `notification_preferences` (
  `preference_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL COMMENT 'User preferences (staff)',
  `customer_id` int DEFAULT NULL COMMENT 'Customer preferences',
  `notification_type` enum('SYSTEM_ANNOUNCEMENT','PROMOTION','MAINTENANCE','POLICY_UPDATE','BOOKING_REMINDER','PAYMENT_NOTIFICATION','SERVICE_UPDATE','EMERGENCY','MARKETING_CAMPAIGN','INVENTORY_ALERT') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `web_enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Nhận thông báo trên web',
  `email_enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Nhận thông báo qua email',
  `sms_enabled` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Nhận thông báo qua SMS',
  `push_enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Nhận push notification',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`preference_id`),
  UNIQUE KEY `unique_user_notification_type` (`user_id`, `notification_type`),
  UNIQUE KEY `unique_customer_notification_type` (`customer_id`, `notification_type`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_customer_id` (`customer_id`),
  CONSTRAINT `notification_preferences_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `notification_preferences_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`),
  CONSTRAINT `chk_preference_type` CHECK (((`user_id` IS NOT NULL) AND (`customer_id` IS NULL)) OR ((`user_id` IS NULL) AND (`customer_id` IS NOT NULL)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Cài đặt thông báo của từng user/customer';

-- =====================================================
-- 5. NOTIFICATION STATISTICS TABLE
-- =====================================================
CREATE TABLE `notification_statistics` (
  `stat_id` int NOT NULL AUTO_INCREMENT,
  `notification_id` int NOT NULL,
  `total_recipients` int NOT NULL DEFAULT '0' COMMENT 'Tổng số người nhận',
  `delivered_count` int NOT NULL DEFAULT '0' COMMENT 'Số lượng đã gửi thành công',
  `read_count` int NOT NULL DEFAULT '0' COMMENT 'Số lượng đã đọc',
  `dismissed_count` int NOT NULL DEFAULT '0' COMMENT 'Số lượng đã dismiss',
  `failed_count` int NOT NULL DEFAULT '0' COMMENT 'Số lượng gửi thất bại',
  `click_count` int NOT NULL DEFAULT '0' COMMENT 'Số lượng click action',
  `delivery_rate` decimal(5,2) DEFAULT '0.00' COMMENT 'Tỷ lệ gửi thành công (%)',
  `read_rate` decimal(5,2) DEFAULT '0.00' COMMENT 'Tỷ lệ đọc (%)',
  `engagement_rate` decimal(5,2) DEFAULT '0.00' COMMENT 'Tỷ lệ tương tác (%)',
  `last_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`stat_id`),
  UNIQUE KEY `notification_id` (`notification_id`),
  CONSTRAINT `notification_statistics_ibfk_1` FOREIGN KEY (`notification_id`) REFERENCES `general_notifications` (`notification_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Thống kê hiệu quả thông báo';

-- =====================================================
-- 6. INSERT DEFAULT NOTIFICATION TEMPLATES
-- =====================================================
INSERT INTO `notification_templates` (`name`, `description`, `notification_type`, `title_template`, `message_template`, `default_priority`, `default_target_type`, `default_role_ids`, `placeholders`, `created_by_user_id`) VALUES
('system_maintenance', 'Thông báo bảo trì hệ thống', 'MAINTENANCE', 'Thông Báo Bảo Trì Hệ Thống - {maintenance_date}', 'Hệ thống sẽ được bảo trì vào {maintenance_date} từ {start_time} đến {end_time}. Trong thời gian này, một số chức năng có thể bị gián đoạn. Xin lỗi vì sự bất tiện này.', 'HIGH', 'ALL_USERS', NULL, '{"maintenance_date": "Ngày bảo trì", "start_time": "Giờ bắt đầu", "end_time": "Giờ kết thúc"}', 1),

('new_promotion', 'Thông báo khuyến mãi mới', 'PROMOTION', 'Khuyến Mãi Mới: {promotion_title}', 'Chúng tôi vui mừng thông báo chương trình khuyến mãi mới: {promotion_title}. Giảm giá {discount_percent}% cho {service_names}. Thời gian áp dụng: {start_date} - {end_date}. Đặt lịch ngay!', 'MEDIUM', 'ROLE_BASED', '[5]', '{"promotion_title": "Tên chương trình", "discount_percent": "Phần trăm giảm giá", "service_names": "Tên dịch vụ", "start_date": "Ngày bắt đầu", "end_date": "Ngày kết thúc"}', 1),

('booking_reminder', 'Nhắc nhở lịch hẹn', 'BOOKING_REMINDER', 'Nhắc Nhở: Lịch Hẹn Của Bạn Vào {appointment_date}', 'Xin chào {customer_name}, bạn có lịch hẹn {service_name} vào {appointment_date} lúc {appointment_time} với {therapist_name}. Vui lòng đến đúng giờ. Cảm ơn!', 'MEDIUM', 'INDIVIDUAL', NULL, '{"customer_name": "Tên khách hàng", "service_name": "Tên dịch vụ", "appointment_date": "Ngày hẹn", "appointment_time": "Giờ hẹn", "therapist_name": "Tên kỹ thuật viên"}', 1),

('payment_success', 'Thông báo thanh toán thành công', 'PAYMENT_NOTIFICATION', 'Thanh Toán Thành Công - Đơn Hàng #{order_id}', 'Cảm ơn {customer_name} đã thanh toán thành công đơn hàng #{order_id} với số tiền {amount}. Chúng tôi sẽ liên hệ để sắp xếp lịch hẹn sớm nhất.', 'MEDIUM', 'INDIVIDUAL', NULL, '{"customer_name": "Tên khách hàng", "order_id": "Mã đơn hàng", "amount": "Số tiền"}', 1),

('inventory_low_stock', 'Cảnh báo hết hàng', 'INVENTORY_ALERT', 'Cảnh Báo: Sản Phẩm {product_name} Sắp Hết', 'Sản phẩm {product_name} chỉ còn {quantity} {unit} trong kho. Vui lòng nhập thêm hàng để đảm bảo hoạt động kinh doanh.', 'HIGH', 'ROLE_BASED', '[1,2,7]', '{"product_name": "Tên sản phẩm", "quantity": "Số lượng còn lại", "unit": "Đơn vị"}', 1),

('emergency_alert', 'Thông báo khẩn cấp', 'EMERGENCY', 'KHẨN CẤP: {alert_title}', '{alert_message}. Vui lòng thực hiện ngay các biện pháp cần thiết. Liên hệ quản lý nếu cần hỗ trợ.', 'URGENT', 'ALL_USERS', NULL, '{"alert_title": "Tiêu đề cảnh báo", "alert_message": "Nội dung cảnh báo"}', 1);

-- =====================================================
-- 7. CREATE INDEXES FOR PERFORMANCE
-- =====================================================
CREATE INDEX `idx_notifications_active_priority` ON `general_notifications` (`is_active`, `priority`, `created_at`);
CREATE INDEX `idx_recipients_unread` ON `notification_recipients` (`user_id`, `customer_id`, `is_read`, `created_at`);
CREATE INDEX `idx_recipients_delivery` ON `notification_recipients` (`delivery_status`, `delivery_method`, `created_at`);

-- =====================================================
-- 8. CREATE TRIGGERS FOR AUTOMATIC STATISTICS UPDATE
-- =====================================================
DELIMITER $$

CREATE TRIGGER `tr_notification_recipients_insert` 
AFTER INSERT ON `notification_recipients`
FOR EACH ROW
BEGIN
    INSERT INTO `notification_statistics` (`notification_id`, `total_recipients`)
    VALUES (NEW.notification_id, 1)
    ON DUPLICATE KEY UPDATE 
        `total_recipients` = `total_recipients` + 1,
        `delivered_count` = CASE WHEN NEW.delivery_status = 'DELIVERED' THEN `delivered_count` + 1 ELSE `delivered_count` END;
END$$

CREATE TRIGGER `tr_notification_recipients_update`
AFTER UPDATE ON `notification_recipients`
FOR EACH ROW
BEGIN
    DECLARE delivered_change INT DEFAULT 0;
    DECLARE read_change INT DEFAULT 0;
    DECLARE dismissed_change INT DEFAULT 0;
    
    -- Calculate changes
    IF OLD.delivery_status != NEW.delivery_status THEN
        IF NEW.delivery_status = 'DELIVERED' THEN SET delivered_change = 1; END IF;
        IF OLD.delivery_status = 'DELIVERED' THEN SET delivered_change = -1; END IF;
    END IF;
    
    IF OLD.is_read != NEW.is_read AND NEW.is_read = 1 THEN
        SET read_change = 1;
    END IF;
    
    IF OLD.is_dismissed != NEW.is_dismissed AND NEW.is_dismissed = 1 THEN
        SET dismissed_change = 1;
    END IF;
    
    -- Update statistics
    UPDATE `notification_statistics` 
    SET 
        `delivered_count` = `delivered_count` + delivered_change,
        `read_count` = `read_count` + read_change,
        `dismissed_count` = `dismissed_count` + dismissed_change,
        `delivery_rate` = CASE WHEN `total_recipients` > 0 THEN (`delivered_count` * 100.0 / `total_recipients`) ELSE 0 END,
        `read_rate` = CASE WHEN `delivered_count` > 0 THEN (`read_count` * 100.0 / `delivered_count`) ELSE 0 END,
        `engagement_rate` = CASE WHEN `delivered_count` > 0 THEN ((`read_count` + `click_count`) * 100.0 / `delivered_count`) ELSE 0 END
    WHERE `notification_id` = NEW.notification_id;
END$$

DELIMITER ;

-- =====================================================
-- 9. INSERT SAMPLE DATA FOR TESTING
-- =====================================================
INSERT INTO `general_notifications` (`title`, `message`, `notification_type`, `priority`, `target_type`, `target_role_ids`, `created_by_user_id`, `start_date`, `end_date`) VALUES
('Chào Mừng Hệ Thống Thông Báo Mới', 'Chúng tôi vui mừng giới thiệu hệ thống thông báo mới giúp bạn cập nhật thông tin kịp thời. Hãy kiểm tra thông báo thường xuyên để không bỏ lỡ thông tin quan trọng!', 'SYSTEM_ANNOUNCEMENT', 'MEDIUM', 'ALL_USERS', NULL, 1, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),

('Khuyến Mãi Tháng 8 - Giảm 30% Massage', 'Chương trình khuyến mãi đặc biệt tháng 8! Giảm 30% cho tất cả dịch vụ massage. Áp dụng từ 01/08 đến 31/08. Đặt lịch ngay để nhận ưu đãi!', 'PROMOTION', 'HIGH', 'ROLE_BASED', '[5]', 1, NOW(), DATE_ADD(NOW(), INTERVAL 15 DAY)),

('Bảo Trì Hệ Thống Cuối Tuần', 'Hệ thống sẽ được bảo trì vào Chủ nhật từ 2:00 - 6:00 sáng. Một số chức năng có thể bị gián đoạn. Xin lỗi vì sự bất tiện.', 'MAINTENANCE', 'HIGH', 'ROLE_BASED', '[1,2,3,4]', 1, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY)),

('Cập Nhật Chính Sách Mới', 'Chính sách hủy lịch hẹn đã được cập nhật. Khách hàng có thể hủy miễn phí trước 24 giờ. Vui lòng thông báo cho khách hàng.', 'POLICY_UPDATE', 'MEDIUM', 'ROLE_BASED', '[2,3,4]', 1, NOW(), DATE_ADD(NOW(), INTERVAL 60 DAY));

-- =====================================================
-- 10. PAYMENT SCHEDULING NOTIFICATIONS (SPECIALIZED)
-- =====================================================
CREATE TABLE `payment_scheduling_notifications` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `payment_id` int NOT NULL COMMENT 'Links to payments table',
  `customer_id` int NOT NULL COMMENT 'Customer who made the payment',
  `recipient_user_id` int NOT NULL COMMENT 'Manager/Admin who receives notification',
  `notification_type` enum('PAYMENT_COMPLETED','SCHEDULING_REQUIRED','BOOKING_REMINDER','PAYMENT_UPDATED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PAYMENT_COMPLETED',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` enum('LOW','MEDIUM','HIGH','URGENT') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'HIGH',
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `is_acknowledged` tinyint(1) NOT NULL DEFAULT '0',
  `related_data` json DEFAULT NULL COMMENT 'Payment details, services, amounts, etc.',
  `websocket_sent` tinyint(1) NOT NULL DEFAULT '0',
  `email_sent` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `read_at` timestamp NULL DEFAULT NULL,
  `acknowledged_at` timestamp NULL DEFAULT NULL,
  `acknowledged_by` int DEFAULT NULL COMMENT 'User who acknowledged the notification',
  PRIMARY KEY (`notification_id`),
  KEY `idx_payment_id` (`payment_id`),
  KEY `idx_customer_id` (`customer_id`),
  KEY `idx_recipient_user_id` (`recipient_user_id`),
  KEY `idx_notification_type` (`notification_type`),
  KEY `idx_priority` (`priority`),
  KEY `idx_read_status` (`is_read`, `read_at`),
  KEY `idx_acknowledged_status` (`is_acknowledged`, `acknowledged_at`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `payment_scheduling_notifications_ibfk_1` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`payment_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `payment_scheduling_notifications_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `payment_scheduling_notifications_ibfk_3` FOREIGN KEY (`recipient_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `payment_scheduling_notifications_ibfk_4` FOREIGN KEY (`acknowledged_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Specialized notifications for payment-to-scheduling workflow';

-- =====================================================
-- 11. SCHEDULING SESSIONS TABLE
-- =====================================================
CREATE TABLE `scheduling_sessions` (
  `session_id` int NOT NULL AUTO_INCREMENT,
  `payment_id` int NOT NULL COMMENT 'Payment being scheduled',
  `manager_user_id` int NOT NULL COMMENT 'Manager handling the scheduling',
  `session_status` enum('ACTIVE','COMPLETED','ABANDONED','EXPIRED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVE',
  `total_services` int NOT NULL DEFAULT '0' COMMENT 'Total services to schedule',
  `scheduled_services` int NOT NULL DEFAULT '0' COMMENT 'Services already scheduled',
  `remaining_services` int GENERATED ALWAYS AS ((`total_services` - `scheduled_services`)) STORED,
  `session_data` json DEFAULT NULL COMMENT 'Temporary scheduling data',
  `started_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL COMMENT 'Session expiration time',
  `last_activity` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`session_id`),
  UNIQUE KEY `unique_active_payment_session` (`payment_id`, `manager_user_id`),
  KEY `idx_payment_id` (`payment_id`),
  KEY `idx_manager_user_id` (`manager_user_id`),
  KEY `idx_session_status` (`session_status`),
  KEY `idx_expires_at` (`expires_at`),
  CONSTRAINT `scheduling_sessions_ibfk_1` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`payment_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `scheduling_sessions_ibfk_2` FOREIGN KEY (`manager_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Track scheduling sessions to prevent conflicts';

-- =====================================================
-- 12. CUSTOMER APPOINTMENT NOTIFICATIONS
-- =====================================================
CREATE TABLE `customer_appointment_notifications` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `booking_id` int NOT NULL,
  `notification_type` enum('APPOINTMENT_CONFIRMED','APPOINTMENT_REMINDER','APPOINTMENT_CANCELLED','APPOINTMENT_RESCHEDULED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `delivery_method` enum('WEB','EMAIL','SMS') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'WEB',
  `delivery_status` enum('PENDING','SENT','FAILED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `scheduled_send_time` timestamp NULL DEFAULT NULL COMMENT 'For reminder notifications',
  `sent_at` timestamp NULL DEFAULT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  KEY `idx_customer_id` (`customer_id`),
  KEY `idx_booking_id` (`booking_id`),
  KEY `idx_notification_type` (`notification_type`),
  KEY `idx_delivery_status` (`delivery_status`),
  KEY `idx_scheduled_send_time` (`scheduled_send_time`),
  CONSTRAINT `customer_appointment_notifications_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `customer_appointment_notifications_ibfk_2` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Notifications sent to customers about their appointments';

-- =====================================================
-- 13. CREATE TRIGGERS FOR AUTOMATIC NOTIFICATIONS
-- =====================================================
DELIMITER $$

-- Trigger to create notifications when payment status changes to PAID
CREATE TRIGGER `tr_payment_completed_notification`
AFTER UPDATE ON `payments`
FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE manager_id INT;
    DECLARE customer_name VARCHAR(255);
    DECLARE payment_amount DECIMAL(10,2);
    DECLARE service_count INT;
    DECLARE service_list TEXT;
    DECLARE notification_title VARCHAR(255);
    DECLARE notification_message TEXT;
    DECLARE related_data_json JSON;

    -- Cursor to get all managers and admins
    DECLARE manager_cursor CURSOR FOR
        SELECT user_id FROM users WHERE role_id IN (1, 2) AND is_active = 1;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Only trigger when payment status changes to PAID
    IF OLD.payment_status != 'PAID' AND NEW.payment_status = 'PAID' THEN

        -- Get customer information
        SELECT full_name INTO customer_name
        FROM customers
        WHERE customer_id = NEW.customer_id;

        -- Get payment details
        SET payment_amount = NEW.total_amount;

        -- Get service information
        SELECT COUNT(*), GROUP_CONCAT(s.name SEPARATOR ', ')
        INTO service_count, service_list
        FROM payment_items pi
        JOIN services s ON pi.service_id = s.service_id
        WHERE pi.payment_id = NEW.payment_id;

        -- Create notification content
        SET notification_title = CONCAT('Thanh toán hoàn tất - ', customer_name);
        SET notification_message = CONCAT(
            'Khách hàng ', customer_name, ' đã thanh toán thành công số tiền ',
            FORMAT(payment_amount, 0), ' VND cho ', service_count, ' dịch vụ. ',
            'Vui lòng lên lịch hẹn cho khách hàng.'
        );

        -- Create related data JSON
        SET related_data_json = JSON_OBJECT(
            'payment_amount', payment_amount,
            'payment_method', NEW.payment_method,
            'service_count', service_count,
            'service_list', service_list,
            'reference_number', NEW.reference_number,
            'customer_name', customer_name
        );

        -- Create notifications for all managers and admins
        OPEN manager_cursor;
        manager_loop: LOOP
            FETCH manager_cursor INTO manager_id;
            IF done THEN
                LEAVE manager_loop;
            END IF;

            INSERT INTO payment_scheduling_notifications (
                payment_id, customer_id, recipient_user_id, notification_type,
                title, message, priority, related_data
            ) VALUES (
                NEW.payment_id, NEW.customer_id, manager_id, 'PAYMENT_COMPLETED',
                notification_title, notification_message, 'HIGH', related_data_json
            );
        END LOOP;
        CLOSE manager_cursor;

    END IF;
END$$

-- Trigger to create customer notifications when booking is created
CREATE TRIGGER `tr_booking_created_customer_notification`
AFTER INSERT ON `bookings`
FOR EACH ROW
BEGIN
    DECLARE customer_name VARCHAR(255);
    DECLARE service_name VARCHAR(255);
    DECLARE therapist_name VARCHAR(255);
    DECLARE notification_title VARCHAR(255);
    DECLARE notification_message TEXT;

    -- Get customer, service, and therapist information
    SELECT c.full_name, s.name, u.full_name
    INTO customer_name, service_name, therapist_name
    FROM customers c, services s, users u
    WHERE c.customer_id = NEW.customer_id
    AND s.service_id = NEW.service_id
    AND u.user_id = NEW.therapist_user_id;

    -- Create notification content
    SET notification_title = 'Lịch hẹn đã được xác nhận';
    SET notification_message = CONCAT(
        'Xin chào ', customer_name, ', lịch hẹn dịch vụ ', service_name,
        ' của bạn đã được xác nhận vào ngày ', DATE_FORMAT(NEW.appointment_date, '%d/%m/%Y'),
        ' lúc ', TIME_FORMAT(NEW.appointment_time, '%H:%i'),
        ' với kỹ thuật viên ', therapist_name, '. Vui lòng đến đúng giờ.'
    );

    -- Create customer notification
    INSERT INTO customer_appointment_notifications (
        customer_id, booking_id, notification_type, title, message
    ) VALUES (
        NEW.customer_id, NEW.booking_id, 'APPOINTMENT_CONFIRMED',
        notification_title, notification_message
    );
END$$

DELIMITER ;

-- =====================================================
-- 14. CREATE INDEXES FOR PERFORMANCE
-- =====================================================
CREATE INDEX `idx_payment_scheduling_active` ON `payment_scheduling_notifications` (`is_read`, `is_acknowledged`, `created_at`);
CREATE INDEX `idx_scheduling_sessions_active` ON `scheduling_sessions` (`session_status`, `expires_at`);
CREATE INDEX `idx_customer_notifications_unread` ON `customer_appointment_notifications` (`customer_id`, `is_read`, `created_at`);

-- =====================================================
-- END OF SCHEMA
-- =====================================================
