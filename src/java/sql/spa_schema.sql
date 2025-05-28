-- -----------------------------------------------------
-- Bước 1: Tạo Cơ sở dữ liệu (Database) - Nếu chưa có
-- -----------------------------------------------------
DROP DATABASE IF EXISTS `spamanagement`;
CREATE DATABASE IF NOT EXISTS `spamanagement`
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Bước 2: Sử dụng Cơ sở dữ liệu vừa tạo
-- -----------------------------------------------------
USE `spamanagement`;

-- -----------------------------------------------------
-- Bước 3: Tạo các Bảng (Tables)
-- -----------------------------------------------------

-- Bảng: Thông tin Spa (Spa Information)
CREATE TABLE IF NOT EXISTS `Spa_Information` (
  `spa_id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL COMMENT 'Tên Spa',
  `address_line1` VARCHAR(255) NOT NULL COMMENT 'Địa chỉ dòng 1',
  `address_line2` VARCHAR(255) NULL COMMENT 'Địa chỉ dòng 2',
  `city` VARCHAR(100) NOT NULL COMMENT 'Thành phố',
  `postal_code` VARCHAR(20) NULL COMMENT 'Mã bưu điện',
  `country` VARCHAR(100) NOT NULL COMMENT 'Quốc gia',
  `phone_number_main` VARCHAR(30) NOT NULL COMMENT 'Số điện thoại chính',
  `phone_number_secondary` VARCHAR(30) NULL COMMENT 'Số điện thoại phụ',
  `email_main` VARCHAR(255) NOT NULL COMMENT 'Email liên hệ chính',
  `email_secondary` VARCHAR(255) NULL COMMENT 'Email phụ',
  `website_url` VARCHAR(255) NULL COMMENT 'Địa chỉ website',
  `logo_url` VARCHAR(255) NULL COMMENT 'URL của logo',
  `tax_identification_number` VARCHAR(50) NULL COMMENT 'Mã số thuế',
  `cancellation_policy` TEXT NULL COMMENT 'Chính sách hủy lịch hẹn',
  `booking_terms` TEXT NULL COMMENT 'Điều khoản đặt lịch',
  `about_us_short` TEXT NULL COMMENT 'Mô tả ngắn về spa',
  `about_us_long` TEXT NULL COMMENT 'Mô tả chi tiết về spa',
  `vat_percentage` DECIMAL(5,2) DEFAULT 0.00 COMMENT 'Phần trăm thuế VAT nếu có',
  `default_appointment_buffer_minutes` INT DEFAULT 15 COMMENT 'Thời gian đệm mặc định giữa các lịch hẹn',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `uq_spa_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Vai trò (Roles) - Dành cho Users (nhân viên)
CREATE TABLE IF NOT EXISTS `Roles` (
  `role_id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(50) NOT NULL UNIQUE COMMENT 'Tên vai trò (system name, e.g., ADMIN, MANAGER, THERAPIST)',
  `display_name` VARCHAR(100) NOT NULL COMMENT 'Tên hiển thị của vai trò',
  `description` TEXT NULL COMMENT 'Mô tả vai trò',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Người dùng (Users) - Chủ yếu cho nhân viên hệ thống
CREATE TABLE IF NOT EXISTS `Users` (
  `user_id` INT AUTO_INCREMENT PRIMARY KEY,
  `role_id` INT NOT NULL,
  `full_name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL UNIQUE,
  `password_hash` VARCHAR(255) NOT NULL COMMENT 'Lưu mật khẩu đã được hash',
  `phone_number` VARCHAR(20) NULL UNIQUE,
  `gender` ENUM('MALE', 'FEMALE', 'OTHER') NULL,
  `birthday` DATE NULL,
  `avatar_url` VARCHAR(255) NULL,
  `is_active` BOOLEAN DEFAULT TRUE COMMENT 'Tài khoản có hoạt động không',
  `last_login_at` TIMESTAMP NULL COMMENT 'Thời điểm đăng nhập cuối',
  `registered_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`role_id`) REFERENCES `Roles`(`role_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Khách hàng (Customers) - ĐỘC LẬP VỚI USERS
CREATE TABLE IF NOT EXISTS `Customers` (
  `customer_id` INT AUTO_INCREMENT PRIMARY KEY,
  `full_name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NULL UNIQUE COMMENT 'Email có thể không bắt buộc. Nếu cung cấp, nên là duy nhất.',
  `phone_number` VARCHAR(20) NOT NULL UNIQUE COMMENT 'Số điện thoại thường là định danh chính cho khách hàng không có tài khoản',
  `hash_password` VARCHAR(255) NULL COMMENT 'Lưu mật khẩu đã được hash cho khách hàng',
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE COMMENT 'Tài khoản khách hàng có hoạt động không',
  `gender` ENUM('MALE', 'FEMALE', 'OTHER', 'UNKNOWN') DEFAULT 'UNKNOWN',
  `birthday` DATE NULL,
  `address` VARCHAR(500) NULL COMMENT 'Địa chỉ liên hệ',
  `loyalty_points` INT DEFAULT 0,
  `notes` TEXT NULL COMMENT 'Ghi chú về khách hàng',
  `role_id` INT NULL COMMENT 'Vai trò của khách hàng, liên kết với bảng Roles',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`role_id`) REFERENCES `Roles`(`role_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_customer_phone ON `Customers`(`phone_number`);
CREATE INDEX idx_customer_email ON `Customers`(`email`);

-- Bảng Danh mục (Categories) - Cho Services, Blogs
CREATE TABLE IF NOT EXISTS `Categories` (
  `category_id` INT AUTO_INCREMENT PRIMARY KEY,
  `parent_category_id` INT NULL,
  `name` VARCHAR(100) NOT NULL,
  `slug` VARCHAR(100) NOT NULL UNIQUE,
  `description` TEXT NULL,
  `image_url` VARCHAR(255) NULL,
  `module_type` ENUM('SERVICE', 'BLOG_POST') NOT NULL COMMENT 'Loại module mà category này thuộc về',
  `is_active` BOOLEAN DEFAULT TRUE,
  `sort_order` INT DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`parent_category_id`) REFERENCES `Categories`(`category_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Loại Dịch vụ (Service Types)
CREATE TABLE IF NOT EXISTS `Service_Types` (
  `service_type_id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL UNIQUE COMMENT 'Tên loại dịch vụ',
  `description` TEXT NULL,
  `image_url` VARCHAR(255) NULL,
  `is_active` BOOLEAN DEFAULT TRUE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Giờ Hoạt Động của Spa (Business Hours)
CREATE TABLE IF NOT EXISTS `Business_Hours` (
  `business_hour_id` INT AUTO_INCREMENT PRIMARY KEY,
  `day_of_week` ENUM('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY') NOT NULL,
  `open_time` TIME NULL COMMENT 'Giờ mở cửa, NULL nếu ngày đó đóng cửa hoặc áp dụng quy tắc đặc biệt',
  `close_time` TIME NULL COMMENT 'Giờ đóng cửa, NULL nếu ngày đó đóng cửa hoặc áp dụng quy tắc đặc biệt',
  `is_closed` BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'TRUE nếu spa đóng cửa cả ngày vào ngày này trong tuần',
  `notes` VARCHAR(255) NULL COMMENT 'Ghi chú ví dụ: giờ hoạt động đặc biệt cho ngày lễ',
  UNIQUE KEY `uq_day_of_week` (`day_of_week`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Hồ sơ Kỹ thuật viên (Therapists) - Liên kết với Users
CREATE TABLE IF NOT EXISTS `Therapists` (
  `user_id` INT PRIMARY KEY COMMENT 'Liên kết với Users.user_id',
  `service_type_id` INT NULL COMMENT 'Loại dịch vụ chính mà kỹ thuật viên chuyên trách',
  `bio` TEXT NULL COMMENT 'Tiểu sử ngắn',
  `availability_status` ENUM('AVAILABLE', 'BUSY', 'OFFLINE', 'ON_LEAVE') DEFAULT 'AVAILABLE' COMMENT 'Trạng thái tổng quan, không phải lịch chi tiết',
  `years_of_experience` INT DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `Users`(`user_id`) ON DELETE CASCADE,
  FOREIGN KEY (`service_type_id`) REFERENCES `Service_Types`(`service_type_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Lịch Làm Việc của Kỹ Thuật Viên (Therapist Schedules)
CREATE TABLE IF NOT EXISTS `Therapist_Schedules` (
  `schedule_id` INT AUTO_INCREMENT PRIMARY KEY,
  `therapist_user_id` INT NOT NULL COMMENT 'FK đến Users.user_id của kỹ thuật viên',
  `start_datetime` DATETIME NOT NULL COMMENT 'Thời gian bắt đầu của ca làm việc hoặc khoảng thời gian cụ thể',
  `end_datetime` DATETIME NOT NULL COMMENT 'Thời gian kết thúc của ca làm việc hoặc khoảng thời gian cụ thể',
  `is_available` BOOLEAN DEFAULT TRUE COMMENT 'TRUE nếu làm việc, FALSE nếu là giờ nghỉ đã đăng ký trong ca',
  `notes` TEXT NULL COMMENT 'Ví dụ: Ca sáng, Ca chiều, Nghỉ đột xuất, Họp',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`therapist_user_id`) REFERENCES `Users`(`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE INDEX idx_therapist_schedule_datetimes ON `Therapist_Schedules`(`therapist_user_id`, `start_datetime`, `end_datetime`);

-- Bảng Dịch vụ (Services)
CREATE TABLE IF NOT EXISTS `Services` (
  `service_id` INT AUTO_INCREMENT PRIMARY KEY,
  `service_type_id` INT NOT NULL COMMENT 'Loại dịch vụ mà dịch vụ này thuộc về',
  `name` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `price` DECIMAL(12,2) NOT NULL,
  `duration_minutes` INT NOT NULL COMMENT 'Thời gian thực hiện dịch vụ (phút)',
  `buffer_time_after_minutes` INT DEFAULT 0 COMMENT 'Thời gian đệm sau dịch vụ (phút), ví dụ dọn dẹp',
  `image_url` VARCHAR(255) NULL,
  `is_active` BOOLEAN DEFAULT TRUE,
  `average_rating` DECIMAL(3,2) DEFAULT 0.00,
  `bookable_online` BOOLEAN DEFAULT TRUE COMMENT 'Dịch vụ này có thể đặt online qua giỏ hàng/hệ thống không',
  `requires_consultation` BOOLEAN DEFAULT FALSE COMMENT 'Dịch vụ này có cần tư vấn trước khi đặt không',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`service_type_id`) REFERENCES `Service_Types`(`service_type_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng nối Dịch vụ và Danh mục (Service Categories)
CREATE TABLE IF NOT EXISTS `Service_Categories` (
  `service_id` INT NOT NULL,
  `category_id` INT NOT NULL,
  PRIMARY KEY (`service_id`, `category_id`),
  FOREIGN KEY (`service_id`) REFERENCES `Services`(`service_id`) ON DELETE CASCADE,
  FOREIGN KEY (`category_id`) REFERENCES `Categories`(`category_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Khuyến mãi (Promotions)
CREATE TABLE IF NOT EXISTS `Promotions` (
  `promotion_id` INT AUTO_INCREMENT PRIMARY KEY,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `promotion_code` VARCHAR(50) NULL UNIQUE,
  `discount_type` ENUM('PERCENTAGE', 'FIXED_AMOUNT', 'FREE_SERVICE') NOT NULL,
  `discount_value` DECIMAL(12,2) NOT NULL COMMENT 'Giá trị giảm (%), số tiền. Nếu FREE_SERVICE, có thể lưu service_id ở đây.',
  `applies_to_service_id` INT NULL COMMENT 'Nếu FREE_SERVICE hoặc KM cho dịch vụ cụ thể.',
  `minimum_appointment_value` DECIMAL(12,2) NULL DEFAULT 0.00 COMMENT 'Giá trị tối thiểu của lịch hẹn để áp dụng KM',
  `start_date` DATETIME NOT NULL,
  `end_date` DATETIME NOT NULL,
  `status` ENUM('SCHEDULED', 'ACTIVE', 'INACTIVE', 'EXPIRED', 'ARCHIVED') NOT NULL DEFAULT 'SCHEDULED',
  `usage_limit_per_customer` INT NULL,
  `total_usage_limit` INT NULL,
  `current_usage_count` INT DEFAULT 0,
  `applicable_scope` ENUM('ALL_SERVICES', 'SPECIFIC_SERVICES', 'ENTIRE_APPOINTMENT') NOT NULL DEFAULT 'ENTIRE_APPOINTMENT',
  `applicable_service_ids_json` JSON NULL COMMENT 'Mảng JSON chứa IDs của services được áp dụng',
  `image_url` VARCHAR(255) NULL,
  `terms_and_conditions` TEXT NULL,
  `created_by_user_id` INT NULL COMMENT 'User (staff/admin) tạo khuyến mãi',
  `is_auto_apply` BOOLEAN DEFAULT FALSE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`created_by_user_id`) REFERENCES `Users`(`user_id`) ON DELETE SET NULL,
  FOREIGN KEY (`applies_to_service_id`) REFERENCES `Services`(`service_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Giỏ hàng (Shopping Carts)
CREATE TABLE IF NOT EXISTS `Shopping_Carts` (
  `cart_id` INT AUTO_INCREMENT PRIMARY KEY,
  `customer_id` INT NULL COMMENT 'Liên kết với khách hàng nếu đã đăng nhập/xác định',
  `session_id` VARCHAR(255) NULL COMMENT 'Dùng cho khách vãng lai chưa đăng nhập',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` ENUM('ACTIVE', 'ABANDONED', 'CONVERTED') DEFAULT 'ACTIVE' COMMENT 'CONVERTED khi các mục đã được chuyển thành lịch hẹn/yêu cầu',
  FOREIGN KEY (`customer_id`) REFERENCES `Customers`(`customer_id`) ON DELETE CASCADE,
  UNIQUE KEY `uq_customer_active_cart` (`customer_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE INDEX idx_cart_session_id ON `Shopping_Carts`(`session_id`);

-- Trigger để đảm bảo mỗi customer_id chỉ có một giỏ hàng ACTIVE
DELIMITER //
CREATE TRIGGER `restrict_active_cart_insert`
BEFORE INSERT ON `Shopping_Carts`
FOR EACH ROW
BEGIN
    IF NEW.status = 'ACTIVE' AND NEW.customer_id IS NOT NULL THEN
        IF EXISTS (
            SELECT 1 
            FROM `Shopping_Carts` 
            WHERE `customer_id` = NEW.customer_id 
            AND `status` = 'ACTIVE'
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Mỗi khách hàng chỉ được có một giỏ hàng ACTIVE.';
        END IF;
    END IF;
END//

CREATE TRIGGER `restrict_active_cart_update`
BEFORE UPDATE ON `Shopping_Carts`
FOR EACH ROW
BEGIN
    IF NEW.status = 'ACTIVE' AND NEW.customer_id IS NOT NULL THEN
        IF EXISTS (
            SELECT 1 
            FROM `Shopping_Carts` 
            WHERE `customer_id` = NEW.customer_id 
            AND `status` = 'ACTIVE'
            AND `cart_id` != NEW.cart_id
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Mỗi khách hàng chỉ được có một giỏ hàng ACTIVE.';
        END IF;
    END IF;
END//
DELIMITER ;

-- Bảng Các mục trong Giỏ hàng (Cart Items) - Chỉ dành cho Dịch vụ
CREATE TABLE IF NOT EXISTS `Cart_Items` (
  `cart_item_id` INT AUTO_INCREMENT PRIMARY KEY,
  `cart_id` INT NOT NULL,
  `service_id` INT NOT NULL COMMENT 'ID của dịch vụ được thêm vào giỏ',
  `quantity` INT NOT NULL DEFAULT 1 COMMENT 'Số lượng dịch vụ này (ví dụ: 2 suất massage cho 2 người)',
  `price_at_addition` DECIMAL(12,2) NOT NULL COMMENT 'Giá dịch vụ tại thời điểm thêm vào giỏ',
  `therapist_user_id_preference` INT NULL COMMENT 'Ưu tiên kỹ thuật viên cho dịch vụ',
  `preferred_start_time_slot` DATETIME NULL COMMENT 'Ưu tiên thời gian cho dịch vụ (cần kiểm tra lại khi đặt lịch)',
  `notes` TEXT NULL COMMENT 'Ghi chú của khách hàng cho mục này',
  `added_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `is_converted_to_appointment` BOOLEAN DEFAULT FALSE COMMENT 'Đánh dấu nếu mục này đã được chuyển thành lịch hẹn',
  FOREIGN KEY (`cart_id`) REFERENCES `Shopping_Carts`(`cart_id`) ON DELETE CASCADE,
  FOREIGN KEY (`service_id`) REFERENCES `Services`(`service_id`) ON DELETE CASCADE,
  FOREIGN KEY (`therapist_user_id_preference`) REFERENCES `Users`(`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Nhóm Đặt Lịch (Booking Groups)
CREATE TABLE IF NOT EXISTS `Booking_Groups` (
  `booking_group_id` INT AUTO_INCREMENT PRIMARY KEY,
  `represent_customer_id` INT NOT NULL COMMENT 'ID của khách hàng đứng ra đại diện đặt lịch cho nhóm',
  `group_name` VARCHAR(255) NULL COMMENT 'Tên gợi nhớ cho nhóm đặt lịch (ví dụ: Sinh nhật bạn A)',
  `expected_pax` INT NOT NULL DEFAULT 1 COMMENT 'Số lượng người dự kiến trong nhóm',
  `group_notes` TEXT NULL COMMENT 'Ghi chú chung cho cả nhóm đặt lịch',
  `status` ENUM('PENDING_CONFIRMATION', 'FULLY_CONFIRMED', 'PARTIALLY_CONFIRMED', 'CANCELLED') DEFAULT 'PENDING_CONFIRMATION' COMMENT 'Trạng thái của toàn bộ nhóm đặt lịch',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`represent_customer_id`) REFERENCES `Customers`(`customer_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Lịch hẹn (Appointments)
CREATE TABLE IF NOT EXISTS `Appointments` (
  `appointment_id` INT AUTO_INCREMENT PRIMARY KEY,
  `customer_id` INT NOT NULL COMMENT 'ID khách hàng nhận dịch vụ cho lịch hẹn cụ thể này',
  `booking_group_id` INT NULL COMMENT 'Liên kết đến nhóm đặt lịch nếu đây là một phần của đặt lịch nhóm',
  `therapist_user_id` INT NULL COMMENT 'ID kỹ thuật viên từ bảng Users',
  `service_id` INT NOT NULL,
  `start_time` DATETIME NOT NULL,
  `end_time` DATETIME NOT NULL,
  `original_service_price` DECIMAL(12,2) NOT NULL,
  `discount_amount_applied` DECIMAL(12,2) DEFAULT 0.00,
  `final_price_after_discount` DECIMAL(12,2) NOT NULL,
  `points_redeemed_value` DECIMAL(12,2) DEFAULT 0.00,
  `final_amount_payable` DECIMAL(12,2) NOT NULL,
  `promotion_id` INT NULL,
  `status` ENUM('PENDING_CONFIRMATION', 'CONFIRMED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED_BY_CUSTOMER', 'CANCELLED_BY_SPA', 'NO_SHOW') NOT NULL DEFAULT 'PENDING_CONFIRMATION',
  `payment_status` ENUM('UNPAID', 'PARTIALLY_PAID', 'PAID', 'REFUNDED') NOT NULL DEFAULT 'UNPAID',
  `notes_by_customer` TEXT NULL,
  `notes_by_staff` TEXT NULL,
  `cancel_reason` TEXT NULL,
  `created_from_cart_item_id` INT NULL COMMENT 'Nếu lịch hẹn được tạo từ một mục trong giỏ hàng',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`customer_id`) REFERENCES `Customers`(`customer_id`) ON DELETE CASCADE,
  FOREIGN KEY (`booking_group_id`) REFERENCES `Booking_Groups`(`booking_group_id`) ON DELETE SET NULL,
  FOREIGN KEY (`therapist_user_id`) REFERENCES `Users`(`user_id`) ON DELETE SET NULL,
  FOREIGN KEY (`service_id`) REFERENCES `Services`(`service_id`) ON DELETE RESTRICT,
  FOREIGN KEY (`promotion_id`) REFERENCES `Promotions`(`promotion_id`) ON DELETE SET NULL,
  FOREIGN KEY (`created_from_cart_item_id`) REFERENCES `Cart_Items`(`cart_item_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE INDEX idx_appointment_times ON `Appointments`(`start_time`, `end_time`);
CREATE INDEX idx_appointment_status ON `Appointments`(`status`);

-- Bảng Đánh giá Dịch vụ (Service Reviews)
CREATE TABLE IF NOT EXISTS `Service_Reviews` (
  `review_id` INT AUTO_INCREMENT PRIMARY KEY,
  `service_id` INT NOT NULL COMMENT 'ID dịch vụ được đánh giá (để tiện truy vấn)',
  `customer_id` INT NOT NULL COMMENT 'ID khách hàng đánh giá (để tiện truy vấn)',
  `appointment_id` INT NOT NULL UNIQUE COMMENT 'ID của lịch hẹn đã hoàn thành mà review này dành cho.',
  `rating` TINYINT UNSIGNED NOT NULL COMMENT 'Điểm đánh giá (1-5)',
  `title` VARCHAR(255) NULL,
  `comment` TEXT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`service_id`) REFERENCES `Services`(`service_id`) ON DELETE CASCADE,
  FOREIGN KEY (`customer_id`) REFERENCES `Customers`(`customer_id`) ON DELETE CASCADE,
  FOREIGN KEY (`appointment_id`) REFERENCES `Appointments`(`appointment_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Trigger để thay thế CHECK (rating >= 1 AND rating <= 5)
DELIMITER //
CREATE TRIGGER `restrict_review_rating_insert`
BEFORE INSERT ON `Service_Reviews`
FOR EACH ROW
BEGIN
    IF NEW.rating < 1 OR NEW.rating > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Điểm đánh giá phải từ 1 đến 5.';
    END IF;
END//

CREATE TRIGGER `restrict_review_rating_update`
BEFORE UPDATE ON `Service_Reviews`
FOR EACH ROW
BEGIN
    IF NEW.rating < 1 OR NEW.rating > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Điểm đánh giá phải từ 1 đến 5.';
    END IF;
END//
DELIMITER ;

-- Bảng Thanh toán (Payments)
CREATE TABLE IF NOT EXISTS `Payments` (
  `payment_id` INT AUTO_INCREMENT PRIMARY KEY,
  `appointment_id` INT NOT NULL COMMENT 'Liên kết với lịch hẹn đang được thanh toán',
  `customer_id` INT NOT NULL COMMENT 'Khách hàng thực hiện thanh toán',
  `amount_paid` DECIMAL(12,2) NOT NULL,
  `payment_method` ENUM('CREDIT_CARD', 'BANK_TRANSFER', 'VNPAY', 'MOMO', 'LOYALTY_POINTS', 'OTHER_ONLINE') NOT NULL COMMENT 'Chỉ các phương thức online và điểm',
  `payment_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `transaction_id_gateway` VARCHAR(255) NULL UNIQUE COMMENT 'Mã giao dịch từ cổng thanh toán',
  `status` ENUM('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED', 'PARTIALLY_PAID') NOT NULL DEFAULT 'PENDING' COMMENT 'Trạng thái thanh toán online',
  `notes` TEXT NULL COMMENT 'Ghi chú về thanh toán, ví dụ: mã lỗi cổng thanh toán',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`appointment_id`) REFERENCES `Appointments`(`appointment_id`) ON DELETE RESTRICT,
  FOREIGN KEY (`customer_id`) REFERENCES `Customers`(`customer_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE INDEX idx_payment_date ON `Payments`(`payment_date`);

-- Bảng Lịch sử Giao dịch Điểm Thưởng (Loyalty Point Transactions)
CREATE TABLE IF NOT EXISTS `Loyalty_Point_Transactions` (
  `point_transaction_id` INT AUTO_INCREMENT PRIMARY KEY,
  `customer_id` INT NOT NULL,
  `transaction_type` ENUM('EARNED_APPOINTMENT', 'REDEEMED_PAYMENT', 'ADMIN_ADJUSTMENT', 'EXPIRED', 'REFUND_POINTS', 'MANUAL_ADD') NOT NULL,
  `points_changed` INT NOT NULL,
  `balance_after_transaction` INT NOT NULL,
  `related_appointment_id` INT NULL,
  `related_payment_id` INT NULL,
  `description` TEXT NULL,
  `transaction_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `admin_user_id` INT NULL COMMENT 'User admin thực hiện điều chỉnh điểm (nếu có)',
  FOREIGN KEY (`customer_id`) REFERENCES `Customers`(`customer_id`) ON DELETE CASCADE,
  FOREIGN KEY (`related_appointment_id`) REFERENCES `Appointments`(`appointment_id`) ON DELETE SET NULL,
  FOREIGN KEY (`related_payment_id`) REFERENCES `Payments`(`payment_id`) ON DELETE SET NULL,
  FOREIGN KEY (`admin_user_id`) REFERENCES `Users`(`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Giao dịch chung (General_Transactions_Log)
CREATE TABLE IF NOT EXISTS `General_Transactions_Log` (
  `transaction_log_id` INT AUTO_INCREMENT PRIMARY KEY,
  `payment_id` INT NULL UNIQUE,
  `user_id` INT NULL COMMENT 'User (nhân viên) liên quan đến giao dịch này (ví dụ: admin điều chỉnh)',
  `customer_id` INT NULL COMMENT 'Khách hàng liên quan đến giao dịch này',
  `related_entity_type` ENUM('APPOINTMENT_PAYMENT', 'POINT_REDEMPTION', 'REFUND_ONLINE', 'OTHER_EXPENSE', 'OTHER_REVENUE') NULL,
  `related_entity_id` INT NULL,
  `transaction_code_internal` VARCHAR(100) NOT NULL UNIQUE,
  `type` ENUM('DEBIT_SPA', 'CREDIT_SPA') NOT NULL,
  `amount` DECIMAL(12,2) NOT NULL,
  `currency_code` VARCHAR(3) DEFAULT 'VND',
  `description` TEXT NULL,
  `status` ENUM('PENDING', 'COMPLETED', 'FAILED', 'CANCELLED', 'PARTIALLY_PAID') NOT NULL DEFAULT 'COMPLETED',
  `transaction_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`payment_id`) REFERENCES `Payments`(`payment_id`) ON DELETE SET NULL,
  FOREIGN KEY (`user_id`) REFERENCES `Users`(`user_id`) ON DELETE SET NULL,
  FOREIGN KEY (`customer_id`) REFERENCES `Customers`(`customer_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Blog (Bài viết)
CREATE TABLE IF NOT EXISTS `Blogs` (
  `blog_id` INT AUTO_INCREMENT PRIMARY KEY,
  `author_user_id` INT NOT NULL COMMENT 'User nhân viên viết bài',
  `title` VARCHAR(255) NOT NULL,
  `slug` VARCHAR(255) NOT NULL UNIQUE,
  `summary` TEXT NULL,
  `content` LONGTEXT NOT NULL,
  `feature_image_url` VARCHAR(255) NULL,
  `status` ENUM('DRAFT', 'PUBLISHED', 'SCHEDULED', 'ARCHIVED') NOT NULL DEFAULT 'DRAFT',
  `published_at` DATETIME NULL,
  `view_count` INT DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`author_user_id`) REFERENCES `Users`(`user_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng nối Blog và Danh mục (Blog Categories)
CREATE TABLE IF NOT EXISTS `Blog_Categories` (
  `blog_id` INT NOT NULL,
  `category_id` INT NOT NULL,
  PRIMARY KEY (`blog_id`, `category_id`),
  FOREIGN KEY (`blog_id`) REFERENCES `Blogs`(`blog_id`) ON DELETE CASCADE,
  FOREIGN KEY (`category_id`) REFERENCES `Categories`(`category_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Loại Thông báo (Notification Types)
CREATE TABLE IF NOT EXISTS `Notification_Types` (
  `notification_type_id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL UNIQUE COMMENT 'Tên mã của loại thông báo, e.g., APPOINTMENT_CONFIRMED, BIRTHDAY_WISH',
  `description` TEXT NULL,
  `template_email_subject` VARCHAR(255) NULL,
  `template_email_body` TEXT NULL,
  `template_sms_message` VARCHAR(500) NULL,
  `template_in_app_message` TEXT NULL,
  `icon_class` VARCHAR(50) NULL,
  `is_customer_facing` BOOLEAN DEFAULT TRUE,
  `is_staff_facing` BOOLEAN DEFAULT FALSE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Thông báo (Notifications) - Bản ghi thông báo gốc
CREATE TABLE IF NOT EXISTS `Notifications_Master` (
  `master_notification_id` INT AUTO_INCREMENT PRIMARY KEY,
  `notification_type_id` INT NOT NULL,
  `title_template` VARCHAR(255) NOT NULL COMMENT 'Tiêu đề có thể chứa placeholder',
  `content_template` TEXT NOT NULL COMMENT 'Nội dung có thể chứa placeholder',
  `link_url_template` VARCHAR(255) NULL,
  `related_entity_type_context` VARCHAR(50) NULL COMMENT 'e.g., APPOINTMENT, PROMOTION, CUSTOMER, USER, BOOKING_GROUP',
  `created_by_user_id` INT NULL COMMENT 'User (staff/admin) tạo thông báo thủ công',
  `trigger_event` VARCHAR(100) NULL COMMENT 'Sự kiện kích hoạt thông báo tự động',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`notification_type_id`) REFERENCES `Notification_Types`(`notification_type_id`) ON DELETE CASCADE,
  FOREIGN KEY (`created_by_user_id`) REFERENCES `Users`(`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Thông báo Gửi đến Người dùng (User Sent Notifications) - DÀNH CHO USERS (NHÂN VIÊN)
CREATE TABLE IF NOT EXISTS `User_Sent_Notifications` (
  `sent_notification_id` INT AUTO_INCREMENT PRIMARY KEY,
  `master_notification_id` INT NOT NULL,
  `recipient_user_id` INT NOT NULL COMMENT 'User nhân viên nhận thông báo',
  `actual_title` VARCHAR(255) NOT NULL,
  `actual_content` TEXT NOT NULL,
  `actual_link_url` VARCHAR(255) NULL,
  `related_entity_id` INT NULL,
  `is_read` BOOLEAN DEFAULT FALSE,
  `read_at` TIMESTAMP NULL,
  `delivery_channel` ENUM('IN_APP', 'EMAIL', 'SMS', 'PUSH_NOTIFICATION') NULL,
  `delivery_status` ENUM('PENDING', 'SENT', 'DELIVERED', 'FAILED', 'VIEWED_IN_APP') DEFAULT 'PENDING',
  `scheduled_send_at` TIMESTAMP NULL,
  `actually_sent_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`master_notification_id`) REFERENCES `Notifications_Master`(`master_notification_id`) ON DELETE CASCADE,
  FOREIGN KEY (`recipient_user_id`) REFERENCES `Users`(`user_id`) ON DELETE CASCADE,
  UNIQUE KEY `uq_user_notification` (`recipient_user_id`, `master_notification_id`, `related_entity_id`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bảng Thông báo Gửi đến Khách hàng (Customer Sent Notifications) - DÀNH CHO CUSTOMERS
CREATE TABLE IF NOT EXISTS `Customer_Sent_Notifications` (
  `sent_notification_id` INT AUTO_INCREMENT PRIMARY KEY,
  `master_notification_id` INT NOT NULL,
  `recipient_customer_id` INT NOT NULL COMMENT 'Customer nhận thông báo',
  `actual_title` VARCHAR(255) NOT NULL,
  `actual_content` TEXT NOT NULL,
  `actual_link_url` VARCHAR(255) NULL,
  `related_entity_id` INT NULL,
  `is_read` BOOLEAN DEFAULT FALSE COMMENT 'Chỉ áp dụng nếu khách hàng có giao diện xem thông báo',
  `read_at` TIMESTAMP NULL,
  `delivery_channel` ENUM('EMAIL', 'SMS') NOT NULL COMMENT 'Kênh gửi chính cho khách hàng không có tài khoản',
  `delivery_status` ENUM('PENDING', 'SENT', 'DELIVERED', 'FAILED') DEFAULT 'PENDING',
  `scheduled_send_at` TIMESTAMP NULL,
  `actually_sent_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`master_notification_id`) REFERENCES `Notifications_Master`(`master_notification_id`) ON DELETE CASCADE,
  FOREIGN KEY (`recipient_customer_id`) REFERENCES `Customers`(`customer_id`) ON DELETE CASCADE,
  UNIQUE KEY `uq_customer_notification` (`recipient_customer_id`, `master_notification_id`, `related_entity_id`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------

-- Bước 5: Xác nhận tạo cơ sở dữ liệu
-- -----------------------------------------------------
SELECT 'Database schema created successfully for spa_management_system_v10_online_payment.' AS message;


