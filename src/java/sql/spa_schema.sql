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

CREATE DATABASE  IF NOT EXISTS `spamanagement` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `spamanagement`;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: spamanagement
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `appointments`
--

DROP TABLE IF EXISTS `appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointments` (
  `appointment_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL COMMENT 'ID khách hàng nhận dịch vụ cho lịch hẹn cụ thể này',
  `booking_group_id` int DEFAULT NULL COMMENT 'Liên kết đến nhóm đặt lịch nếu đây là một phần của đặt lịch nhóm',
  `therapist_user_id` int DEFAULT NULL COMMENT 'ID kỹ thuật viên từ bảng Users',
  `service_id` int NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `original_service_price` decimal(12,2) NOT NULL,
  `discount_amount_applied` decimal(12,2) DEFAULT '0.00',
  `final_price_after_discount` decimal(12,2) NOT NULL,
  `points_redeemed_value` decimal(12,2) DEFAULT '0.00',
  `final_amount_payable` decimal(12,2) NOT NULL,
  `promotion_id` int DEFAULT NULL,
  `status` enum('PENDING_CONFIRMATION','CONFIRMED','IN_PROGRESS','COMPLETED','CANCELLED_BY_CUSTOMER','CANCELLED_BY_SPA','NO_SHOW') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING_CONFIRMATION',
  `payment_status` enum('UNPAID','PARTIALLY_PAID','PAID','REFUNDED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UNPAID',
  `notes_by_customer` text COLLATE utf8mb4_unicode_ci,
  `notes_by_staff` text COLLATE utf8mb4_unicode_ci,
  `cancel_reason` text COLLATE utf8mb4_unicode_ci,
  `created_from_cart_item_id` int DEFAULT NULL COMMENT 'Nếu lịch hẹn được tạo từ một mục trong giỏ hàng',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`appointment_id`),
  KEY `customer_id` (`customer_id`),
  KEY `booking_group_id` (`booking_group_id`),
  KEY `therapist_user_id` (`therapist_user_id`),
  KEY `service_id` (`service_id`),
  KEY `promotion_id` (`promotion_id`),
  KEY `created_from_cart_item_id` (`created_from_cart_item_id`),
  KEY `idx_appointment_times` (`start_time`,`end_time`),
  KEY `idx_appointment_status` (`status`),
  CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE,
  CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`booking_group_id`) REFERENCES `booking_groups` (`booking_group_id`) ON DELETE SET NULL,
  CONSTRAINT `appointments_ibfk_3` FOREIGN KEY (`therapist_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `appointments_ibfk_4` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`) ON DELETE RESTRICT,
  CONSTRAINT `appointments_ibfk_5` FOREIGN KEY (`promotion_id`) REFERENCES `promotions` (`promotion_id`) ON DELETE SET NULL,
  CONSTRAINT `appointments_ibfk_6` FOREIGN KEY (`created_from_cart_item_id`) REFERENCES `cart_items` (`cart_item_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `blog_categories`
--

DROP TABLE IF EXISTS `blog_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blog_categories` (
  `blog_id` int NOT NULL,
  `category_id` int NOT NULL,
  PRIMARY KEY (`blog_id`,`category_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `blog_categories_ibfk_1` FOREIGN KEY (`blog_id`) REFERENCES `blogs` (`blog_id`) ON DELETE CASCADE,
  CONSTRAINT `blog_categories_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `blogs`
--

DROP TABLE IF EXISTS `blogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blogs` (
  `blog_id` int NOT NULL AUTO_INCREMENT,
  `author_user_id` int NOT NULL COMMENT 'User nhân viên viết bài',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci,
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `feature_image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('DRAFT','PUBLISHED','SCHEDULED','ARCHIVED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
  `published_at` datetime DEFAULT NULL,
  `view_count` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`blog_id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `author_user_id` (`author_user_id`),
  CONSTRAINT `blogs_ibfk_1` FOREIGN KEY (`author_user_id`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `booking_groups`
--

DROP TABLE IF EXISTS `booking_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_groups` (
  `booking_group_id` int NOT NULL AUTO_INCREMENT,
  `represent_customer_id` int NOT NULL COMMENT 'ID của khách hàng đứng ra đại diện đặt lịch cho nhóm',
  `group_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tên gợi nhớ cho nhóm đặt lịch (ví dụ: Sinh nhật bạn A)',
  `expected_pax` int NOT NULL DEFAULT '1' COMMENT 'Số lượng người dự kiến trong nhóm',
  `group_notes` text COLLATE utf8mb4_unicode_ci COMMENT 'Ghi chú chung cho cả nhóm đặt lịch',
  `status` enum('PENDING_CONFIRMATION','FULLY_CONFIRMED','PARTIALLY_CONFIRMED','CANCELLED') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING_CONFIRMATION' COMMENT 'Trạng thái của toàn bộ nhóm đặt lịch',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`booking_group_id`),
  KEY `represent_customer_id` (`represent_customer_id`),
  CONSTRAINT `booking_groups_ibfk_1` FOREIGN KEY (`represent_customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `business_hours`
--

DROP TABLE IF EXISTS `business_hours`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_hours` (
  `business_hour_id` int NOT NULL AUTO_INCREMENT,
  `day_of_week` enum('MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY','SUNDAY') COLLATE utf8mb4_unicode_ci NOT NULL,
  `open_time` time DEFAULT NULL COMMENT 'Giờ mở cửa, NULL nếu ngày đó đóng cửa hoặc áp dụng quy tắc đặc biệt',
  `close_time` time DEFAULT NULL COMMENT 'Giờ đóng cửa, NULL nếu ngày đó đóng cửa hoặc áp dụng quy tắc đặc biệt',
  `is_closed` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'TRUE nếu spa đóng cửa cả ngày vào ngày này trong tuần',
  `notes` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Ghi chú ví dụ: giờ hoạt động đặc biệt cho ngày lễ',
  PRIMARY KEY (`business_hour_id`),
  UNIQUE KEY `uq_day_of_week` (`day_of_week`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_items` (
  `cart_item_id` int NOT NULL AUTO_INCREMENT,
  `cart_id` int NOT NULL,
  `service_id` int NOT NULL COMMENT 'ID của dịch vụ được thêm vào giỏ',
  `quantity` int NOT NULL DEFAULT '1' COMMENT 'Số lượng dịch vụ này (ví dụ: 2 suất massage cho 2 người)',
  `price_at_addition` decimal(12,2) NOT NULL COMMENT 'Giá dịch vụ tại thời điểm thêm vào giỏ',
  `therapist_user_id_preference` int DEFAULT NULL COMMENT 'Ưu tiên kỹ thuật viên cho dịch vụ',
  `preferred_start_time_slot` datetime DEFAULT NULL COMMENT 'Ưu tiên thời gian cho dịch vụ (cần kiểm tra lại khi đặt lịch)',
  `notes` text COLLATE utf8mb4_unicode_ci COMMENT 'Ghi chú của khách hàng cho mục này',
  `added_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_converted_to_appointment` tinyint(1) DEFAULT '0' COMMENT 'Đánh dấu nếu mục này đã được chuyển thành lịch hẹn',
  PRIMARY KEY (`cart_item_id`),
  KEY `cart_id` (`cart_id`),
  KEY `service_id` (`service_id`),
  KEY `therapist_user_id_preference` (`therapist_user_id_preference`),
  CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `shopping_carts` (`cart_id`) ON DELETE CASCADE,
  CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`) ON DELETE CASCADE,
  CONSTRAINT `cart_items_ibfk_3` FOREIGN KEY (`therapist_user_id_preference`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `parent_category_id` int DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `module_type` enum('SERVICE','BLOG_POST') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Loại module mà category này thuộc về',
  `is_active` tinyint(1) DEFAULT '1',
  `sort_order` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `parent_category_id` (`parent_category_id`),
  CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_category_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `customer_sent_notifications`
--

DROP TABLE IF EXISTS `customer_sent_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_sent_notifications` (
  `sent_notification_id` int NOT NULL AUTO_INCREMENT,
  `master_notification_id` int NOT NULL,
  `recipient_customer_id` int NOT NULL COMMENT 'Customer nhận thông báo',
  `actual_title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `actual_content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `actual_link_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `related_entity_id` int DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT '0' COMMENT 'Chỉ áp dụng nếu khách hàng có giao diện xem thông báo',
  `read_at` timestamp NULL DEFAULT NULL,
  `delivery_channel` enum('EMAIL','SMS') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Kênh gửi chính cho khách hàng không có tài khoản',
  `delivery_status` enum('PENDING','SENT','DELIVERED','FAILED') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `scheduled_send_at` timestamp NULL DEFAULT NULL,
  `actually_sent_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`sent_notification_id`),
  UNIQUE KEY `uq_customer_notification` (`recipient_customer_id`,`master_notification_id`,`related_entity_id`,`created_at`),
  KEY `master_notification_id` (`master_notification_id`),
  CONSTRAINT `customer_sent_notifications_ibfk_1` FOREIGN KEY (`master_notification_id`) REFERENCES `notifications_master` (`master_notification_id`) ON DELETE CASCADE,
  CONSTRAINT `customer_sent_notifications_ibfk_2` FOREIGN KEY (`recipient_customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Email có thể không bắt buộc. Nếu cung cấp, nên là duy nhất.',
  `phone_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Số điện thoại thường là định danh chính cho khách hàng không có tài khoản',
  `hash_password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Lưu mật khẩu đã được hash cho khách hàng',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Tài khoản khách hàng có hoạt động không',
  `gender` enum('MALE','FEMALE','OTHER','UNKNOWN') COLLATE utf8mb4_unicode_ci DEFAULT 'UNKNOWN',
  `birthday` date DEFAULT NULL,
  `address` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Địa chỉ liên hệ',
  `loyalty_points` int DEFAULT '0',
  `notes` text COLLATE utf8mb4_unicode_ci COMMENT 'Ghi chú về khách hàng',
  `role_id` int DEFAULT NULL COMMENT 'Vai trò của khách hàng, liên kết với bảng Roles',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `avatar_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `phone_number` (`phone_number`),
  UNIQUE KEY `email` (`email`),
  KEY `role_id` (`role_id`),
  KEY `idx_customer_phone` (`phone_number`),
  KEY `idx_customer_email` (`email`),
  CONSTRAINT `customers_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `general_transactions_log`
--

DROP TABLE IF EXISTS `general_transactions_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `general_transactions_log` (
  `transaction_log_id` int NOT NULL AUTO_INCREMENT,
  `payment_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL COMMENT 'User (nhân viên) liên quan đến giao dịch này (ví dụ: admin điều chỉnh)',
  `customer_id` int DEFAULT NULL COMMENT 'Khách hàng liên quan đến giao dịch này',
  `related_entity_type` enum('APPOINTMENT_PAYMENT','POINT_REDEMPTION','REFUND_ONLINE','OTHER_EXPENSE','OTHER_REVENUE') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `related_entity_id` int DEFAULT NULL,
  `transaction_code_internal` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('DEBIT_SPA','CREDIT_SPA') COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency_code` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT 'VND',
  `description` text COLLATE utf8mb4_unicode_ci,
  `status` enum('PENDING','COMPLETED','FAILED','CANCELLED','PARTIALLY_PAID') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'COMPLETED',
  `transaction_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`transaction_log_id`),
  UNIQUE KEY `transaction_code_internal` (`transaction_code_internal`),
  UNIQUE KEY `payment_id` (`payment_id`),
  KEY `user_id` (`user_id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `general_transactions_log_ibfk_1` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`payment_id`) ON DELETE SET NULL,
  CONSTRAINT `general_transactions_log_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `general_transactions_log_ibfk_3` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `loyalty_point_transactions`
--

DROP TABLE IF EXISTS `loyalty_point_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loyalty_point_transactions` (
  `point_transaction_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `transaction_type` enum('EARNED_APPOINTMENT','REDEEMED_PAYMENT','ADMIN_ADJUSTMENT','EXPIRED','REFUND_POINTS','MANUAL_ADD') COLLATE utf8mb4_unicode_ci NOT NULL,
  `points_changed` int NOT NULL,
  `balance_after_transaction` int NOT NULL,
  `related_appointment_id` int DEFAULT NULL,
  `related_payment_id` int DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `transaction_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `admin_user_id` int DEFAULT NULL COMMENT 'User admin thực hiện điều chỉnh điểm (nếu có)',
  PRIMARY KEY (`point_transaction_id`),
  KEY `customer_id` (`customer_id`),
  KEY `related_appointment_id` (`related_appointment_id`),
  KEY `related_payment_id` (`related_payment_id`),
  KEY `admin_user_id` (`admin_user_id`),
  CONSTRAINT `loyalty_point_transactions_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE,
  CONSTRAINT `loyalty_point_transactions_ibfk_2` FOREIGN KEY (`related_appointment_id`) REFERENCES `appointments` (`appointment_id`) ON DELETE SET NULL,
  CONSTRAINT `loyalty_point_transactions_ibfk_3` FOREIGN KEY (`related_payment_id`) REFERENCES `payments` (`payment_id`) ON DELETE SET NULL,
  CONSTRAINT `loyalty_point_transactions_ibfk_4` FOREIGN KEY (`admin_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notification_types`
--

DROP TABLE IF EXISTS `notification_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_types` (
  `notification_type_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên mã của loại thông báo, e.g., APPOINTMENT_CONFIRMED, BIRTHDAY_WISH',
  `description` text COLLATE utf8mb4_unicode_ci,
  `template_email_subject` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `template_email_body` text COLLATE utf8mb4_unicode_ci,
  `template_sms_message` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `template_in_app_message` text COLLATE utf8mb4_unicode_ci,
  `icon_class` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_customer_facing` tinyint(1) DEFAULT '1',
  `is_staff_facing` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_type_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notifications_master`
--

DROP TABLE IF EXISTS `notifications_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications_master` (
  `master_notification_id` int NOT NULL AUTO_INCREMENT,
  `notification_type_id` int NOT NULL,
  `title_template` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tiêu đề có thể chứa placeholder',
  `content_template` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nội dung có thể chứa placeholder',
  `link_url_template` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `related_entity_type_context` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'e.g., APPOINTMENT, PROMOTION, CUSTOMER, USER, BOOKING_GROUP',
  `created_by_user_id` int DEFAULT NULL COMMENT 'User (staff/admin) tạo thông báo thủ công',
  `trigger_event` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Sự kiện kích hoạt thông báo tự động',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`master_notification_id`),
  KEY `notification_type_id` (`notification_type_id`),
  KEY `created_by_user_id` (`created_by_user_id`),
  CONSTRAINT `notifications_master_ibfk_1` FOREIGN KEY (`notification_type_id`) REFERENCES `notification_types` (`notification_type_id`) ON DELETE CASCADE,
  CONSTRAINT `notifications_master_ibfk_2` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `appointment_id` int NOT NULL COMMENT 'Liên kết với lịch hẹn đang được thanh toán',
  `customer_id` int NOT NULL COMMENT 'Khách hàng thực hiện thanh toán',
  `amount_paid` decimal(12,2) NOT NULL,
  `payment_method` enum('CREDIT_CARD','BANK_TRANSFER','VNPAY','MOMO','LOYALTY_POINTS','OTHER_ONLINE') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Chỉ các phương thức online và điểm',
  `payment_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `transaction_id_gateway` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Mã giao dịch từ cổng thanh toán',
  `status` enum('PENDING','COMPLETED','FAILED','REFUNDED','PARTIALLY_PAID') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING' COMMENT 'Trạng thái thanh toán online',
  `notes` text COLLATE utf8mb4_unicode_ci COMMENT 'Ghi chú về thanh toán, ví dụ: mã lỗi cổng thanh toán',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `transaction_id_gateway` (`transaction_id_gateway`),
  KEY `appointment_id` (`appointment_id`),
  KEY `customer_id` (`customer_id`),
  KEY `idx_payment_date` (`payment_date`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`appointment_id`) ON DELETE RESTRICT,
  CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `promotions`
--

DROP TABLE IF EXISTS `promotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotions` (
  `promotion_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `promotion_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discount_type` enum('PERCENTAGE','FIXED_AMOUNT','FREE_SERVICE') COLLATE utf8mb4_unicode_ci NOT NULL,
  `discount_value` decimal(12,2) NOT NULL COMMENT 'Giá trị giảm (%), số tiền. Nếu FREE_SERVICE, có thể lưu service_id ở đây.',
  `applies_to_service_id` int DEFAULT NULL COMMENT 'Nếu FREE_SERVICE hoặc KM cho dịch vụ cụ thể.',
  `minimum_appointment_value` decimal(12,2) DEFAULT '0.00' COMMENT 'Giá trị tối thiểu của lịch hẹn để áp dụng KM',
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `status` enum('SCHEDULED','ACTIVE','INACTIVE','EXPIRED','ARCHIVED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SCHEDULED',
  `usage_limit_per_customer` int DEFAULT NULL,
  `total_usage_limit` int DEFAULT NULL,
  `current_usage_count` int DEFAULT '0',
  `applicable_scope` enum('ALL_SERVICES','SPECIFIC_SERVICES','ENTIRE_APPOINTMENT') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ENTIRE_APPOINTMENT',
  `applicable_service_ids_json` json DEFAULT NULL COMMENT 'Mảng JSON chứa IDs của services được áp dụng',
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `terms_and_conditions` text COLLATE utf8mb4_unicode_ci,
  `created_by_user_id` int DEFAULT NULL COMMENT 'User (staff/admin) tạo khuyến mãi',
  `is_auto_apply` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`promotion_id`),
  UNIQUE KEY `promotion_code` (`promotion_code`),
  KEY `created_by_user_id` (`created_by_user_id`),
  KEY `applies_to_service_id` (`applies_to_service_id`),
  CONSTRAINT `promotions_ibfk_1` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `promotions_ibfk_2` FOREIGN KEY (`applies_to_service_id`) REFERENCES `services` (`service_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên vai trò (system name, e.g., ADMIN, MANAGER, THERAPIST)',
  `display_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên hiển thị của vai trò',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT 'Mô tả vai trò',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_categories`
--

DROP TABLE IF EXISTS `service_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_categories` (
  `service_id` int NOT NULL,
  `category_id` int NOT NULL,
  PRIMARY KEY (`service_id`,`category_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `service_categories_ibfk_1` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`) ON DELETE CASCADE,
  CONSTRAINT `service_categories_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_reviews`
--

DROP TABLE IF EXISTS `service_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_reviews` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `service_id` int NOT NULL COMMENT 'ID dịch vụ được đánh giá (để tiện truy vấn)',
  `customer_id` int NOT NULL COMMENT 'ID khách hàng đánh giá (để tiện truy vấn)',
  `appointment_id` int NOT NULL COMMENT 'ID của lịch hẹn đã hoàn thành mà review này dành cho.',
  `rating` tinyint unsigned NOT NULL COMMENT 'Điểm đánh giá (1-5)',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  UNIQUE KEY `appointment_id` (`appointment_id`),
  KEY `service_id` (`service_id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `service_reviews_ibfk_1` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`) ON DELETE CASCADE,
  CONSTRAINT `service_reviews_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE,
  CONSTRAINT `service_reviews_ibfk_3` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`appointment_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_types`
--

DROP TABLE IF EXISTS `service_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_types` (
  `service_type_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên loại dịch vụ',
  `description` text COLLATE utf8mb4_unicode_ci,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`service_type_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `services` (
  `service_id` int NOT NULL AUTO_INCREMENT,
  `service_type_id` int NOT NULL COMMENT 'Loại dịch vụ mà dịch vụ này thuộc về',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `price` decimal(12,2) NOT NULL,
  `duration_minutes` int NOT NULL COMMENT 'Thời gian thực hiện dịch vụ (phút)',
  `buffer_time_after_minutes` int DEFAULT '0' COMMENT 'Thời gian đệm sau dịch vụ (phút), ví dụ dọn dẹp',
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `average_rating` decimal(3,2) DEFAULT '0.00',
  `bookable_online` tinyint(1) DEFAULT '1' COMMENT 'Dịch vụ này có thể đặt online qua giỏ hàng/hệ thống không',
  `requires_consultation` tinyint(1) DEFAULT '0' COMMENT 'Dịch vụ này có cần tư vấn trước khi đặt không',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`service_id`),
  KEY `service_type_id` (`service_type_id`),
  CONSTRAINT `services_ibfk_1` FOREIGN KEY (`service_type_id`) REFERENCES `service_types` (`service_type_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shopping_carts`
--

DROP TABLE IF EXISTS `shopping_carts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shopping_carts` (
  `cart_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int DEFAULT NULL COMMENT 'Liên kết với khách hàng nếu đã đăng nhập/xác định',
  `session_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Dùng cho khách vãng lai chưa đăng nhập',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` enum('ACTIVE','ABANDONED','CONVERTED') COLLATE utf8mb4_unicode_ci DEFAULT 'ACTIVE' COMMENT 'CONVERTED khi các mục đã được chuyển thành lịch hẹn/yêu cầu',
  PRIMARY KEY (`cart_id`),
  UNIQUE KEY `uq_customer_active_cart` (`customer_id`,`status`),
  KEY `idx_cart_session_id` (`session_id`),
  CONSTRAINT `shopping_carts_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spa_information`
--

DROP TABLE IF EXISTS `spa_information`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `spa_information` (
  `spa_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên Spa',
  `address_line1` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Địa chỉ dòng 1',
  `address_line2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Địa chỉ dòng 2',
  `city` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Thành phố',
  `postal_code` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Mã bưu điện',
  `country` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Quốc gia',
  `phone_number_main` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Số điện thoại chính',
  `phone_number_secondary` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Số điện thoại phụ',
  `email_main` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Email liên hệ chính',
  `email_secondary` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Email phụ',
  `website_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Địa chỉ website',
  `logo_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL của logo',
  `tax_identification_number` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Mã số thuế',
  `cancellation_policy` text COLLATE utf8mb4_unicode_ci COMMENT 'Chính sách hủy lịch hẹn',
  `booking_terms` text COLLATE utf8mb4_unicode_ci COMMENT 'Điều khoản đặt lịch',
  `about_us_short` text COLLATE utf8mb4_unicode_ci COMMENT 'Mô tả ngắn về spa',
  `about_us_long` text COLLATE utf8mb4_unicode_ci COMMENT 'Mô tả chi tiết về spa',
  `vat_percentage` decimal(5,2) DEFAULT '0.00' COMMENT 'Phần trăm thuế VAT nếu có',
  `default_appointment_buffer_minutes` int DEFAULT '15' COMMENT 'Thời gian đệm mặc định giữa các lịch hẹn',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`spa_id`),
  UNIQUE KEY `uq_spa_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `therapist_schedules`
--

DROP TABLE IF EXISTS `therapist_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `therapist_schedules` (
  `schedule_id` int NOT NULL AUTO_INCREMENT,
  `therapist_user_id` int NOT NULL COMMENT 'FK đến Users.user_id của kỹ thuật viên',
  `start_datetime` datetime NOT NULL COMMENT 'Thời gian bắt đầu của ca làm việc hoặc khoảng thời gian cụ thể',
  `end_datetime` datetime NOT NULL COMMENT 'Thời gian kết thúc của ca làm việc hoặc khoảng thời gian cụ thể',
  `is_available` tinyint(1) DEFAULT '1' COMMENT 'TRUE nếu làm việc, FALSE nếu là giờ nghỉ đã đăng ký trong ca',
  `notes` text COLLATE utf8mb4_unicode_ci COMMENT 'Ví dụ: Ca sáng, Ca chiều, Nghỉ đột xuất, Họp',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`schedule_id`),
  KEY `idx_therapist_schedule_datetimes` (`therapist_user_id`,`start_datetime`,`end_datetime`),
  CONSTRAINT `therapist_schedules_ibfk_1` FOREIGN KEY (`therapist_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `therapists`
--

DROP TABLE IF EXISTS `therapists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `therapists` (
  `user_id` int NOT NULL COMMENT 'Liên kết với Users.user_id',
  `service_type_id` int DEFAULT NULL COMMENT 'Loại dịch vụ chính mà kỹ thuật viên chuyên trách',
  `bio` text COLLATE utf8mb4_unicode_ci COMMENT 'Tiểu sử ngắn',
  `availability_status` enum('AVAILABLE','BUSY','OFFLINE','ON_LEAVE') COLLATE utf8mb4_unicode_ci DEFAULT 'AVAILABLE' COMMENT 'Trạng thái tổng quan, không phải lịch chi tiết',
  `years_of_experience` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  KEY `service_type_id` (`service_type_id`),
  CONSTRAINT `therapists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `therapists_ibfk_2` FOREIGN KEY (`service_type_id`) REFERENCES `service_types` (`service_type_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_sent_notifications`
--

DROP TABLE IF EXISTS `user_sent_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_sent_notifications` (
  `sent_notification_id` int NOT NULL AUTO_INCREMENT,
  `master_notification_id` int NOT NULL,
  `recipient_user_id` int NOT NULL COMMENT 'User nhân viên nhận thông báo',
  `actual_title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `actual_content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `actual_link_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `related_entity_id` int DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `read_at` timestamp NULL DEFAULT NULL,
  `delivery_channel` enum('IN_APP','EMAIL','SMS','PUSH_NOTIFICATION') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_status` enum('PENDING','SENT','DELIVERED','FAILED','VIEWED_IN_APP') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `scheduled_send_at` timestamp NULL DEFAULT NULL,
  `actually_sent_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`sent_notification_id`),
  UNIQUE KEY `uq_user_notification` (`recipient_user_id`,`master_notification_id`,`related_entity_id`,`created_at`),
  KEY `master_notification_id` (`master_notification_id`),
  CONSTRAINT `user_sent_notifications_ibfk_1` FOREIGN KEY (`master_notification_id`) REFERENCES `notifications_master` (`master_notification_id`) ON DELETE CASCADE,
  CONSTRAINT `user_sent_notifications_ibfk_2` FOREIGN KEY (`recipient_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `role_id` int NOT NULL,
  `full_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Lưu mật khẩu đã được hash',
  `phone_number` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gender` enum('MALE','FEMALE','OTHER') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `avatar_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1' COMMENT 'Tài khoản có hoạt động không',
  `last_login_at` timestamp NULL DEFAULT NULL COMMENT 'Thời điểm đăng nhập cuối',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone_number` (`phone_number`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-30  9:53:30
