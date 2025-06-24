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
-- Dumping data for table `blog_categories`
--

LOCK TABLES `blog_categories` WRITE;
/*!40000 ALTER TABLE `blog_categories` DISABLE KEYS */;
INSERT INTO `blog_categories` VALUES (1,4),(2,4),(3,5);
/*!40000 ALTER TABLE `blog_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blogs`
--

DROP TABLE IF EXISTS `blogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blogs` (
  `blog_id` int NOT NULL AUTO_INCREMENT,
  `author_user_id` int NOT NULL COMMENT 'User nhân viên viết bài',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `feature_image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('DRAFT','PUBLISHED','SCHEDULED','ARCHIVED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
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
-- Dumping data for table `blogs`
--

LOCK TABLES `blogs` WRITE;
/*!40000 ALTER TABLE `blogs` DISABLE KEYS */;
INSERT INTO `blogs` VALUES (1,2,'5 Lợi Ích Tuyệt Vời Của Massage Thường Xuyên','5-loi-ich-tuyet-voi-cua-massage-thuong-xuyen','Khám phá những lợi ích sức khỏe không ngờ tới từ việc massage định kỳ.','Nội dung chi tiết về 5 lợi ích của massage... (HTML/Markdown)','https://placehold.co/600x400/B2DFEE/333333?text=BlogMassage','PUBLISHED','2025-06-01 16:40:23',150,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(2,2,'Bí Quyết Sở Hữu Làn Da Căng Bóng Mùa Hè','bi-quyet-so-huu-lan-da-cang-bong-mua-he','Những mẹo chăm sóc da đơn giản mà hiệu quả giúp bạn tự tin tỏa sáng trong mùa hè.','Nội dung chi tiết về bí quyết chăm sóc da mùa hè... (HTML/Markdown)','https://placehold.co/600x400/FFDAB9/333333?text=BlogSkincare','PUBLISHED','2025-06-01 16:40:23',220,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(3,1,'Chương Trình Khuyến Mãi Mới Tại Spa','chuong-trinh-khuyen-mai-moi-tai-spa','Thông báo về các gói ưu đãi hấp dẫn sắp ra mắt.','Nội dung chi tiết về chương trình khuyến mãi... (HTML/Markdown)','https://placehold.co/600x400/98FB98/333333?text=BlogPromo','DRAFT',NULL,0,'2025-06-01 09:40:23','2025-06-01 09:40:23');
/*!40000 ALTER TABLE `blogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_appointments`
--

DROP TABLE IF EXISTS `booking_appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_appointments` (
  `appointment_id` int NOT NULL AUTO_INCREMENT,
  `booking_group_id` int NOT NULL,
  `service_id` int NOT NULL,
  `therapist_user_id` int NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `service_price` decimal(8,2) NOT NULL,
  `status` enum('SCHEDULED','IN_PROGRESS','COMPLETED','CANCELLED') COLLATE utf8mb4_unicode_ci DEFAULT 'SCHEDULED',
  `service_notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`appointment_id`),
  KEY `idx_booking_group` (`booking_group_id`),
  KEY `idx_therapist_time` (`therapist_user_id`,`start_time`),
  KEY `idx_service_status` (`service_id`,`status`),
  CONSTRAINT `booking_appointments_ibfk_1` FOREIGN KEY (`booking_group_id`) REFERENCES `booking_groups` (`booking_group_id`) ON DELETE CASCADE,
  CONSTRAINT `booking_appointments_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`),
  CONSTRAINT `booking_appointments_ibfk_3` FOREIGN KEY (`therapist_user_id`) REFERENCES `therapists` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=171 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_appointments`
--

LOCK TABLES `booking_appointments` WRITE;
/*!40000 ALTER TABLE `booking_appointments` DISABLE KEYS */;
INSERT INTO `booking_appointments` VALUES (143,185,2,3,'2025-06-25 09:00:00','2025-06-25 10:30:00',700000.00,'SCHEDULED','Massage đá nóng - phòng VIP','2025-06-24 04:54:32','2025-06-24 04:54:32'),(144,185,8,12,'2025-06-25 11:00:00','2025-06-25 12:15:00',750000.00,'SCHEDULED','Massage Shiatsu','2025-06-24 04:54:32','2025-06-24 04:54:32'),(145,185,27,15,'2025-06-25 14:00:00','2025-06-25 14:45:00',200000.00,'SCHEDULED','Manicure cơ bản','2025-06-24 04:54:32','2025-06-24 04:54:32'),(146,186,1,16,'2025-06-25 10:00:00','2025-06-25 11:00:00',500000.00,'SCHEDULED','Massage Thụy Điển','2025-06-24 04:54:32','2025-06-24 04:54:32'),(147,186,3,4,'2025-06-25 15:00:00','2025-06-25 16:00:00',400000.00,'SCHEDULED','Chăm sóc da cơ bản','2025-06-24 04:54:32','2025-06-24 04:54:32'),(148,187,7,18,'2025-06-25 13:00:00','2025-06-25 14:30:00',650000.00,'SCHEDULED','Massage Thái cổ truyền','2025-06-24 04:54:32','2025-06-24 04:54:32'),(149,187,5,14,'2025-06-25 16:00:00','2025-06-25 16:45:00',450000.00,'SCHEDULED','Tẩy tế bào chết','2025-06-24 04:54:32','2025-06-24 04:54:32'),(150,187,27,15,'2025-06-25 17:00:00','2025-06-25 17:45:00',200000.00,'SCHEDULED','Manicure','2025-06-24 04:54:32','2025-06-24 04:54:32'),(151,188,1,3,'2025-06-26 10:00:00','2025-06-26 11:00:00',500000.00,'SCHEDULED','Massage Thụy Điển','2025-06-24 04:54:32','2025-06-24 04:54:32'),(152,188,9,16,'2025-06-26 15:30:00','2025-06-26 16:15:00',400000.00,'SCHEDULED','Massage foot reflexology','2025-06-24 04:54:32','2025-06-24 04:54:32'),(153,188,28,15,'2025-06-26 17:00:00','2025-06-26 18:15:00',350000.00,'SCHEDULED','Pedicure deluxe','2025-06-24 04:54:32','2025-06-24 04:54:32'),(154,189,4,17,'2025-06-26 11:00:00','2025-06-26 12:15:00',650000.00,'SCHEDULED','Trị mụn chuyên sâu','2025-06-24 04:54:32','2025-06-24 04:54:32'),(155,190,4,13,'2025-06-26 09:30:00','2025-06-26 10:45:00',650000.00,'SCHEDULED','Trị mụn chuyên sâu','2025-06-24 04:54:32','2025-06-24 04:54:32'),(156,190,6,19,'2025-06-26 14:00:00','2025-06-26 15:00:00',300000.00,'SCHEDULED','Gội đầu thảo dược','2025-06-24 04:54:32','2025-06-24 04:54:32'),(157,191,2,12,'2025-06-27 08:30:00','2025-06-27 10:00:00',700000.00,'SCHEDULED','Massage đá nóng','2025-06-24 04:54:32','2025-06-24 04:54:32'),(158,191,8,18,'2025-06-27 11:00:00','2025-06-27 12:15:00',750000.00,'SCHEDULED','Massage Shiatsu','2025-06-24 04:54:32','2025-06-24 04:54:32'),(159,191,6,15,'2025-06-27 15:00:00','2025-06-27 16:00:00',300000.00,'SCHEDULED','Gội đầu thảo dược','2025-06-24 04:54:32','2025-06-24 04:54:32'),(160,192,3,4,'2025-06-27 09:00:00','2025-06-27 10:00:00',400000.00,'SCHEDULED','Chăm sóc da cơ bản','2025-06-24 04:54:32','2025-06-24 04:54:32'),(161,192,7,18,'2025-06-27 13:30:00','2025-06-27 15:00:00',650000.00,'SCHEDULED','Massage Thái','2025-06-24 04:54:32','2025-06-24 04:54:32'),(162,193,1,3,'2025-06-27 16:00:00','2025-06-27 17:00:00',500000.00,'SCHEDULED','Massage Thụy Điển','2025-06-24 04:54:32','2025-06-24 04:54:32'),(163,193,5,14,'2025-06-27 17:30:00','2025-06-27 18:15:00',450000.00,'SCHEDULED','Tẩy tế bào chết','2025-06-24 04:54:32','2025-06-24 04:54:32'),(164,194,2,12,'2025-06-28 09:00:00','2025-06-28 10:30:00',700000.00,'SCHEDULED','Massage đá nóng','2025-06-24 04:54:32','2025-06-24 04:54:32'),(165,194,1,16,'2025-06-28 14:00:00','2025-06-28 15:00:00',500000.00,'SCHEDULED','Massage Thụy Điển','2025-06-24 04:54:32','2025-06-24 04:54:32'),(166,195,3,4,'2025-06-28 16:00:00','2025-06-28 17:00:00',400000.00,'SCHEDULED','Chăm sóc da','2025-06-24 04:54:32','2025-06-24 04:54:32'),(167,195,5,14,'2025-06-28 17:30:00','2025-06-28 18:15:00',450000.00,'SCHEDULED','Tẩy tế bào chết','2025-06-24 04:54:32','2025-06-24 04:54:32'),(168,196,8,18,'2025-06-29 10:00:00','2025-06-29 11:15:00',750000.00,'SCHEDULED','Massage Shiatsu','2025-06-24 04:54:32','2025-06-24 04:54:32'),(169,196,7,12,'2025-06-29 15:00:00','2025-06-29 16:30:00',650000.00,'SCHEDULED','Massage Thái','2025-06-24 04:54:32','2025-06-24 04:54:32'),(170,196,27,15,'2025-06-29 17:00:00','2025-06-29 17:45:00',250000.00,'SCHEDULED','Manicure cao cấp','2025-06-24 04:54:32','2025-06-24 04:54:32');
/*!40000 ALTER TABLE `booking_appointments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_groups`
--

DROP TABLE IF EXISTS `booking_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_groups` (
  `booking_group_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `booking_date` date NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `payment_status` enum('PENDING','PAID') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `booking_status` enum('CONFIRMED','IN_PROGRESS','COMPLETED','CANCELLED') COLLATE utf8mb4_unicode_ci DEFAULT 'CONFIRMED',
  `payment_method` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'ONLINE_BANKING',
  `special_notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`booking_group_id`),
  KEY `idx_customer_booking_date` (`customer_id`,`booking_date`),
  KEY `idx_booking_status` (`booking_status`),
  CONSTRAINT `booking_groups_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=197 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_groups`
--

LOCK TABLES `booking_groups` WRITE;
/*!40000 ALTER TABLE `booking_groups` DISABLE KEYS */;
INSERT INTO `booking_groups` VALUES (185,1,'2025-06-25',1650000.00,'PAID','CONFIRMED','ONLINE_BANKING','Khách VIP, ưu tiên phòng riêng','2025-06-24 04:54:32','2025-06-24 04:54:32'),(186,2,'2025-06-25',900000.00,'PAID','CONFIRMED','ONLINE_BANKING',NULL,'2025-06-24 04:54:32','2025-06-24 04:54:32'),(187,3,'2025-06-25',1300000.00,'PENDING','CONFIRMED','ONLINE_BANKING','Đặt cho 2 người','2025-06-24 04:54:32','2025-06-24 04:54:32'),(188,5,'2025-06-26',1250000.00,'PAID','CONFIRMED','CASH',NULL,'2025-06-24 04:54:32','2025-06-24 04:54:32'),(189,6,'2025-06-26',650000.00,'PAID','CONFIRMED','ONLINE_BANKING',NULL,'2025-06-24 04:54:32','2025-06-24 04:54:32'),(190,7,'2025-06-26',950000.00,'PENDING','CONFIRMED','ONLINE_BANKING',NULL,'2025-06-24 04:54:32','2025-06-24 04:54:32'),(191,8,'2025-06-27',1750000.00,'PAID','CONFIRMED','ONLINE_BANKING',NULL,'2025-06-24 04:54:32','2025-06-24 04:54:32'),(192,9,'2025-06-27',1050000.00,'PAID','CONFIRMED','ONLINE_BANKING',NULL,'2025-06-24 04:54:32','2025-06-24 04:54:32'),(193,10,'2025-06-27',950000.00,'PENDING','CONFIRMED','ONLINE_BANKING',NULL,'2025-06-24 04:54:32','2025-06-24 04:54:32'),(194,11,'2025-06-28',1200000.00,'PAID','CONFIRMED','ONLINE_BANKING','Đặt trước 1 tuần','2025-06-24 04:54:32','2025-06-24 04:54:32'),(195,12,'2025-06-28',850000.00,'PAID','CONFIRMED','CASH',NULL,'2025-06-24 04:54:32','2025-06-24 04:54:32'),(196,14,'2025-06-29',1650000.00,'PENDING','CONFIRMED','ONLINE_BANKING',NULL,'2025-06-24 04:54:32','2025-06-24 04:54:32');
/*!40000 ALTER TABLE `booking_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_sessions`
--

DROP TABLE IF EXISTS `booking_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_sessions` (
  `session_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_id` int DEFAULT NULL,
  `session_data` json NOT NULL,
  `current_step` enum('services','therapists','time','registration','payment') COLLATE utf8mb4_unicode_ci DEFAULT 'services',
  `expires_at` timestamp NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`session_id`),
  KEY `idx_customer_id` (`customer_id`),
  KEY `idx_expires_at` (`expires_at`),
  CONSTRAINT `booking_sessions_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_sessions`
--

LOCK TABLES `booking_sessions` WRITE;
/*!40000 ALTER TABLE `booking_sessions` DISABLE KEYS */;
INSERT INTO `booking_sessions` VALUES ('bs_1b7dc658c9514de3bfb98c739c367a10',NULL,'{\"totalAmount\": 1750000.0, \"selectedDate\": null, \"specialNotes\": null, \"paymentMethod\": \"ONLINE_BANKING\", \"totalDuration\": 225, \"selectedServices\": [{\"serviceId\": 2, \"serviceName\": \"Massage Đá Nóng\", \"serviceOrder\": 1, \"scheduledTime\": null, \"therapistName\": null, \"estimatedPrice\": 700000.0, \"therapistUserId\": null, \"estimatedDuration\": 90}, {\"serviceId\": 4, \"serviceName\": \"Trị Mụn Chuyên Sâu\", \"serviceOrder\": 2, \"scheduledTime\": null, \"therapistName\": null, \"estimatedPrice\": 650000.0, \"therapistUserId\": null, \"estimatedDuration\": 75}, {\"serviceId\": 3, \"serviceName\": \"Chăm Sóc Da Cơ Bản\", \"serviceOrder\": 3, \"scheduledTime\": null, \"therapistName\": null, \"estimatedPrice\": 400000.0, \"therapistUserId\": null, \"estimatedDuration\": 60}]}','time','2025-07-21 11:55:16','2025-06-21 11:55:11','2025-06-21 11:55:16'),('bs_6cb1f07921a14c87b042f590c3aaa8ab',NULL,'{\"totalAmount\": 1800000.0, \"selectedDate\": null, \"specialNotes\": null, \"paymentMethod\": \"ONLINE_BANKING\", \"totalDuration\": 210, \"selectedServices\": [{\"serviceId\": 7, \"serviceName\": \"Massage Thái Cổ Truyền\", \"serviceOrder\": 1, \"scheduledTime\": null, \"therapistName\": null, \"estimatedPrice\": 650000.0, \"therapistUserId\": null, \"estimatedDuration\": 90}, {\"serviceId\": 8, \"serviceName\": \"Massage Shiatsu Nhật Bản\", \"serviceOrder\": 2, \"scheduledTime\": null, \"therapistName\": null, \"estimatedPrice\": 750000.0, \"therapistUserId\": null, \"estimatedDuration\": 75}, {\"serviceId\": 9, \"serviceName\": \"Massage Foot Reflexology\", \"serviceOrder\": 3, \"scheduledTime\": null, \"therapistName\": null, \"estimatedPrice\": 400000.0, \"therapistUserId\": null, \"estimatedDuration\": 45}]}','time','2025-07-21 12:00:11','2025-06-21 12:00:02','2025-06-21 12:00:11'),('bs_7e91bf4bfa1e43a69e76cca8548db527',NULL,'{\"totalAmount\": 0, \"selectedDate\": null, \"specialNotes\": null, \"paymentMethod\": \"ONLINE_BANKING\", \"totalDuration\": 0, \"selectedServices\": []}','services','2025-07-22 11:50:10','2025-06-22 11:50:10','2025-06-22 11:50:10'),('bs_8225a03323bd46a8be8d0aa1fb12f3fb',NULL,'{\"totalAmount\": 0, \"selectedDate\": null, \"specialNotes\": null, \"paymentMethod\": \"ONLINE_BANKING\", \"totalDuration\": 0, \"selectedServices\": []}','services','2025-07-21 11:56:45','2025-06-21 11:56:45','2025-06-21 11:56:45'),('bs_8f51510fcc1e4fe08b739ac93006853e',NULL,'{\"totalAmount\": 1600000.0, \"selectedDate\": null, \"specialNotes\": null, \"paymentMethod\": \"ONLINE_BANKING\", \"totalDuration\": 210, \"selectedServices\": [{\"serviceId\": 1, \"serviceName\": \"Massage Thụy Điển\", \"serviceOrder\": 1, \"scheduledTime\": null, \"therapistName\": null, \"estimatedPrice\": 500000.0, \"therapistUserId\": null, \"estimatedDuration\": 60}, {\"serviceId\": 2, \"serviceName\": \"Massage Đá Nóng\", \"serviceOrder\": 2, \"scheduledTime\": null, \"therapistName\": null, \"estimatedPrice\": 700000.0, \"therapistUserId\": null, \"estimatedDuration\": 90}, {\"serviceId\": 3, \"serviceName\": \"Chăm Sóc Da Cơ Bản\", \"serviceOrder\": 3, \"scheduledTime\": null, \"therapistName\": null, \"estimatedPrice\": 400000.0, \"therapistUserId\": null, \"estimatedDuration\": 60}]}','therapists','2025-07-21 11:19:47','2025-06-21 11:19:47','2025-06-21 11:19:47'),('bs_91b1c74bbceb4cf88f9fe2139160c5f9',NULL,'{\"totalAmount\": 2150000.0, \"selectedDate\": \"2025-06-25\", \"specialNotes\": null, \"paymentMethod\": \"ONLINE_BANKING\", \"totalDuration\": 270, \"selectedServices\": [{\"serviceId\": 5, \"serviceName\": \"Tẩy Tế Bào Chết Toàn Thân\", \"serviceOrder\": 1, \"scheduledTime\": \"2025-06-25T12:30:00\", \"therapistName\": null, \"estimatedPrice\": 450000.0, \"therapistUserId\": null, \"estimatedDuration\": 45}, {\"serviceId\": 4, \"serviceName\": \"Trị Mụn Chuyên Sâu\", \"serviceOrder\": 2, \"scheduledTime\": \"2025-06-25T13:15:00\", \"therapistName\": null, \"estimatedPrice\": 650000.0, \"therapistUserId\": null, \"estimatedDuration\": 75}, {\"serviceId\": 7, \"serviceName\": \"Massage Thái Cổ Truyền\", \"serviceOrder\": 3, \"scheduledTime\": \"2025-06-25T14:30:00\", \"therapistName\": null, \"estimatedPrice\": 650000.0, \"therapistUserId\": null, \"estimatedDuration\": 90}, {\"serviceId\": 3, \"serviceName\": \"Chăm Sóc Da Cơ Bản\", \"serviceOrder\": 4, \"scheduledTime\": \"2025-06-25T16:00:00\", \"therapistName\": null, \"estimatedPrice\": 400000.0, \"therapistUserId\": null, \"estimatedDuration\": 60}]}','therapists','2025-07-21 15:40:19','2025-06-21 12:07:14','2025-06-21 15:46:37'),('bs_a7c1a9c463394f74bfc1f678eb85477d',NULL,'{\"totalAmount\": 1350000.0, \"selectedDate\": null, \"specialNotes\": null, \"paymentMethod\": \"ONLINE_BANKING\", \"totalDuration\": 165, \"selectedServices\": [{\"serviceId\": 3, \"serviceName\": \"Chăm Sóc Da Cơ Bản\", \"serviceOrder\": 1, \"scheduledTime\": null, \"therapistName\": null, \"estimatedPrice\": 400000.0, \"therapistUserId\": null, \"estimatedDuration\": 60}, {\"serviceId\": 5, \"serviceName\": \"Tẩy Tế Bào Chết Toàn Thân\", \"serviceOrder\": 2, \"scheduledTime\": null, \"therapistName\": null, \"estimatedPrice\": 450000.0, \"therapistUserId\": null, \"estimatedDuration\": 45}, {\"serviceId\": 1, \"serviceName\": \"Massage Thụy Điển\", \"serviceOrder\": 3, \"scheduledTime\": null, \"therapistName\": null, \"estimatedPrice\": 500000.0, \"therapistUserId\": null, \"estimatedDuration\": 60}]}','time','2025-07-21 11:36:40','2025-06-21 11:36:31','2025-06-21 11:36:40'),('bs_b42fcda116524debb2443d0311af167f',NULL,'{\"totalAmount\": 1200000.0, \"selectedDate\": null, \"specialNotes\": null, \"paymentMethod\": \"ONLINE_BANKING\", \"totalDuration\": 180, \"selectedServices\": [{\"serviceId\": 1, \"serviceName\": \"Massage Thụy Điển\", \"serviceOrder\": 1, \"scheduledTime\": null, \"therapistName\": null, \"estimatedPrice\": 500000.0, \"therapistUserId\": null, \"estimatedDuration\": 60}, {\"serviceId\": 3, \"serviceName\": \"Chăm Sóc Da Cơ Bản\", \"serviceOrder\": 2, \"scheduledTime\": null, \"therapistName\": null, \"estimatedPrice\": 400000.0, \"therapistUserId\": null, \"estimatedDuration\": 60}, {\"serviceId\": 6, \"serviceName\": \"Gội Đầu Thảo Dược\", \"serviceOrder\": 3, \"scheduledTime\": null, \"therapistName\": null, \"estimatedPrice\": 300000.0, \"therapistUserId\": null, \"estimatedDuration\": 60}]}','time','2025-07-21 11:34:03','2025-06-21 11:33:40','2025-06-21 11:34:03'),('bs_b63d51cd41504445ac79c6e5b531f84a',NULL,'{\"totalAmount\": 1600000.0, \"selectedDate\": null, \"specialNotes\": null, \"paymentMethod\": \"ONLINE_BANKING\", \"totalDuration\": 180, \"selectedServices\": [{\"serviceId\": 1, \"serviceName\": \"Massage Thụy Điển\", \"serviceOrder\": 1, \"scheduledTime\": null, \"therapistName\": null, \"estimatedPrice\": 500000.0, \"therapistUserId\": null, \"estimatedDuration\": 60}, {\"serviceId\": 4, \"serviceName\": \"Trị Mụn Chuyên Sâu\", \"serviceOrder\": 2, \"scheduledTime\": null, \"therapistName\": null, \"estimatedPrice\": 650000.0, \"therapistUserId\": null, \"estimatedDuration\": 75}, {\"serviceId\": 5, \"serviceName\": \"Tẩy Tế Bào Chết Toàn Thân\", \"serviceOrder\": 3, \"scheduledTime\": null, \"therapistName\": null, \"estimatedPrice\": 450000.0, \"therapistUserId\": null, \"estimatedDuration\": 45}]}','time','2025-07-24 04:34:02','2025-06-24 04:33:54','2025-06-24 04:34:01'),('bs_e14df198af2948bfa480cd0c315d2775',NULL,'{\"totalAmount\": 1400000.0, \"selectedDate\": null, \"specialNotes\": null, \"paymentMethod\": \"ONLINE_BANKING\", \"totalDuration\": 180, \"selectedServices\": [{\"serviceId\": 6, \"serviceName\": \"Gội Đầu Thảo Dược\", \"serviceOrder\": 1, \"scheduledTime\": null, \"therapistName\": null, \"estimatedPrice\": 300000.0, \"therapistUserId\": null, \"estimatedDuration\": 60}, {\"serviceId\": 5, \"serviceName\": \"Tẩy Tế Bào Chết Toàn Thân\", \"serviceOrder\": 2, \"scheduledTime\": null, \"therapistName\": null, \"estimatedPrice\": 450000.0, \"therapistUserId\": null, \"estimatedDuration\": 45}, {\"serviceId\": 4, \"serviceName\": \"Trị Mụn Chuyên Sâu\", \"serviceOrder\": 3, \"scheduledTime\": null, \"therapistName\": null, \"estimatedPrice\": 650000.0, \"therapistUserId\": null, \"estimatedDuration\": 75}]}','time','2025-07-21 11:28:10','2025-06-21 11:24:32','2025-06-21 11:28:10');
/*!40000 ALTER TABLE `booking_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_hours`
--

DROP TABLE IF EXISTS `business_hours`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_hours` (
  `business_hour_id` int NOT NULL AUTO_INCREMENT,
  `day_of_week` enum('MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY','SUNDAY') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `open_time` time DEFAULT NULL COMMENT 'Giờ mở cửa, NULL nếu ngày đó đóng cửa hoặc áp dụng quy tắc đặc biệt',
  `close_time` time DEFAULT NULL COMMENT 'Giờ đóng cửa, NULL nếu ngày đó đóng cửa hoặc áp dụng quy tắc đặc biệt',
  `is_closed` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'TRUE nếu spa đóng cửa cả ngày vào ngày này trong tuần',
  `notes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Ghi chú ví dụ: giờ hoạt động đặc biệt cho ngày lễ',
  PRIMARY KEY (`business_hour_id`),
  UNIQUE KEY `uq_day_of_week` (`day_of_week`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_hours`
--

LOCK TABLES `business_hours` WRITE;
/*!40000 ALTER TABLE `business_hours` DISABLE KEYS */;
INSERT INTO `business_hours` VALUES (1,'MONDAY','09:00:00','21:00:00',0,NULL),(2,'TUESDAY','09:00:00','21:00:00',0,NULL),(3,'WEDNESDAY','09:00:00','21:00:00',0,NULL),(4,'THURSDAY','09:00:00','21:00:00',0,NULL),(5,'FRIDAY','09:00:00','22:00:00',0,'Mở cửa muộn hơn'),(6,'SATURDAY','09:00:00','22:00:00',0,'Mở cửa muộn hơn'),(7,'SUNDAY','10:00:00','20:00:00',0,NULL);
/*!40000 ALTER TABLE `business_hours` ENABLE KEYS */;
UNLOCK TABLES;

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
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Ghi chú của khách hàng cho mục này',
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
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
INSERT INTO `cart_items` VALUES (1,1,2,1,700000.00,3,'2025-06-10 14:00:00','Xin phòng riêng nếu có thể.','2025-06-01 09:40:23',1),(2,1,6,1,300000.00,NULL,'2025-06-10 16:00:00',NULL,'2025-06-01 09:40:23',0),(3,2,1,1,500000.00,NULL,NULL,'Đặt cho buổi chiều.','2025-06-01 09:40:23',0),(4,3,3,2,400000.00,4,'2025-05-28 10:00:00','Cho 2 người.','2025-05-30 09:40:23',0);
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `parent_category_id` int DEFAULT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `module_type` enum('SERVICE','BLOG_POST') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Loại module mà category này thuộc về',
  `is_active` tinyint(1) DEFAULT '1',
  `sort_order` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `parent_category_id` (`parent_category_id`),
  CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_category_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,NULL,'Massage','massage','Các dịch vụ massage thư giãn và trị liệu','https://placehold.co/200x150/AFEEEE/333333?text=MassageCat','SERVICE',1,1,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(2,NULL,'Chăm Sóc Da','cham-soc-da','Dịch vụ chăm sóc da mặt và toàn thân','https://placehold.co/200x150/FFEFD5/333333?text=SkinCareCat','SERVICE',1,2,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(3,2,'Da Mặt','da-mat','Chăm sóc chuyên sâu cho da mặt','https://placehold.co/200x150/FFE4E1/333333?text=FacialCat','SERVICE',1,1,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(4,NULL,'Mẹo Chăm Sóc Sức Khỏe','meo-cham-soc-suc-khoe','Bài viết về cách chăm sóc sức khỏe và sắc đẹp','https://placehold.co/200x150/F5DEB3/333333?text=HealthTips','BLOG_POST',1,1,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(5,NULL,'Tin Tức Spa','tin-tuc-spa','Cập nhật thông tin mới nhất từ spa','https://placehold.co/200x150/D2B48C/333333?text=SpaNews','BLOG_POST',1,2,'2025-06-01 09:40:23','2025-06-01 09:40:23');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `checkins`
--

DROP TABLE IF EXISTS `checkins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `checkins` (
  `checkin_id` int NOT NULL AUTO_INCREMENT,
  `appointment_id` int NOT NULL COMMENT 'Links to the appointment being checked in',
  `customer_id` int NOT NULL COMMENT 'Customer who checked in',
  `checkin_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp of check-in',
  `status` enum('SUCCESS','FAILED','PENDING') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SUCCESS' COMMENT 'Status of the check-in attempt',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Additional notes, e.g., reason for failed check-in',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`checkin_id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `checkins_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checkins`
--

LOCK TABLES `checkins` WRITE;
/*!40000 ALTER TABLE `checkins` DISABLE KEYS */;
/*!40000 ALTER TABLE `checkins` ENABLE KEYS */;
UNLOCK TABLES;

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
  `actual_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `actual_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `actual_link_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `related_entity_id` int DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT '0' COMMENT 'Chỉ áp dụng nếu khách hàng có giao diện xem thông báo',
  `read_at` timestamp NULL DEFAULT NULL,
  `delivery_channel` enum('EMAIL','SMS') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Kênh gửi chính cho khách hàng không có tài khoản',
  `delivery_status` enum('PENDING','SENT','DELIVERED','FAILED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `scheduled_send_at` timestamp NULL DEFAULT NULL,
  `actually_sent_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`sent_notification_id`),
  UNIQUE KEY `uq_customer_notification` (`recipient_customer_id`,`master_notification_id`,`related_entity_id`,`created_at`),
  KEY `master_notification_id` (`master_notification_id`),
  CONSTRAINT `customer_sent_notifications_ibfk_1` FOREIGN KEY (`master_notification_id`) REFERENCES `notifications_master` (`master_notification_id`) ON DELETE CASCADE,
  CONSTRAINT `customer_sent_notifications_ibfk_2` FOREIGN KEY (`recipient_customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_sent_notifications`
--

LOCK TABLES `customer_sent_notifications` WRITE;
/*!40000 ALTER TABLE `customer_sent_notifications` DISABLE KEYS */;
INSERT INTO `customer_sent_notifications` VALUES (4,1,1,'Xác nhận lịch hẹn #5','Lịch hẹn của bạn cho dịch vụ Massage Đá Nóng với KTV Lê Minh Cường vào lúc 14:00:00 ngày 2025-06-05 đã được XÁC NHẬN.','/appointments/view/5',5,0,NULL,'EMAIL','SENT','2025-06-01 09:40:23','2025-06-01 09:40:23','2025-06-01 09:40:23'),(5,2,2,'Nhắc lịch hẹn #6 ngày mai','Đừng quên lịch hẹn của bạn cho dịch vụ Chăm Sóc Da Cơ Bản vào 10:00:00 ngày mai (2025-06-03).','/appointments/view/6',6,1,'2025-06-02 03:05:00','SMS','DELIVERED','2025-06-02 03:00:00','2025-06-02 03:00:05','2025-06-02 03:00:00');
/*!40000 ALTER TABLE `customer_sent_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Email có thể không bắt buộc. Nếu cung cấp, nên là duy nhất.',
  `phone_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Số điện thoại thường là định danh chính cho khách hàng không có tài khoản',
  `hash_password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Lưu mật khẩu đã được hash cho khách hàng',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Tài khoản khách hàng có hoạt động không',
  `gender` enum('MALE','FEMALE','OTHER','UNKNOWN') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'UNKNOWN',
  `birthday` date DEFAULT NULL,
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Địa chỉ liên hệ',
  `loyalty_points` int DEFAULT '0',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Ghi chú về khách hàng',
  `role_id` int DEFAULT NULL COMMENT 'Vai trò của khách hàng, liên kết với bảng Roles',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_verified` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'TRUE = Email verified, FALSE = Not verified',
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `phone_number` (`phone_number`),
  UNIQUE KEY `email` (`email`),
  KEY `role_id` (`role_id`),
  KEY `idx_customer_phone` (`phone_number`),
  KEY `idx_customer_email` (`email`),
  CONSTRAINT `customers_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'Nguyễn Thị Mai','mai.nguyen@email.com','0988111222','$2b$10$abcdefghijklmnopqrstu',1,'FEMALE','1990-07-15','123 Đường Hoa, Quận 1, TP. HCM',250,'Khách hàng VIP, thích trà gừng.',5,'2025-06-01 09:40:23','2025-06-01 09:40:23','https://placehold.co/100x100/FFC0CB/333333?text=NTHMai',0),(2,'Trần Văn Nam','nam.tran@email.com','0977333444','$2b$10$abcdefghijklmnopqrstu',1,'MALE','1988-02-20','456 Đường Cây, Quận 3, TP. HCM',60,'Thường đặt dịch vụ massage chân.',5,'2025-06-01 09:40:23','2025-06-01 09:40:23','https://placehold.co/100x100/B0E0E6/333333?text=TVNam',0),(3,'Lê Thị Lan','lan.le@email.com','0966555666','$2b$10$abcdefghijklmnopqrstu',1,'FEMALE','1995-11-30','789 Đường Lá, Quận Bình Thạnh, TP. HCM',200,'Hay đi cùng bạn bè.',5,'2025-06-01 09:40:23','2025-06-01 09:40:23','https://placehold.co/100x100/98FB98/333333?text=LTLan',0),(4,'Phạm Văn Hùng','hung.pham@email.com','0955777888','$2b$10$abcdefghijklmnopqrstu',0,'MALE','1985-01-01','101 Đường Sông, Quận 2, TP. HCM',10,'Tài khoản không hoạt động.',5,'2025-06-01 09:40:23','2025-06-01 09:40:23','https://placehold.co/100x100/D3D3D3/333333?text=PVHung',0),(5,'Võ Thị Kim Chi','kimchi.vo@email.com','0944999000','$2b$10$abcdefghijklmnopqrstu',1,'FEMALE','2000-10-10','202 Đường Núi, Quận 7, TP. HCM',50,NULL,5,'2025-06-01 09:40:23','2025-06-01 09:40:23','https://placehold.co/100x100/FFE4E1/333333?text=VTKChi',0),(6,'Khách Vãng Lai A',NULL,'0912345001',NULL,1,'UNKNOWN',NULL,NULL,0,'Khách đặt qua điện thoại',NULL,'2025-06-01 09:40:23','2025-06-01 09:40:23',NULL,0),(7,'Clementine Shields','qaxyb@mailinator.com','0075252946','$2a$10$Mg7a1qbG3Wpt5/LL1hJXdORgyMD8WFuuFS49lZKuEpf33xp6wDM0G',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-01 09:44:15','2025-06-01 09:44:15',NULL,0),(8,'Preston Reeves','wogelyvi@mailinator.com','0621707951','$2a$10$LfSiDBEkpBQh9uWhQwnW1.iG3TrMf3w0ucvWyw9GisHH.LNU63Oyy',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-02 02:37:54','2025-06-02 02:37:54',NULL,0),(9,'Hector Gill','qepem@mailinator.com','0488215435','$2a$10$.GhDdGMtOZGoZsZlikXXA..J3OjZ4ka4t8iEEGEWQhRg5HXi9yESi',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-02 02:40:08','2025-06-02 02:40:08',NULL,0),(10,'John Walters','hybux@mailinator.com','0764611157','$2a$10$FIUJAcV5Tp4IGs9CD8jr5ePKbM28eoPYtMxj2egfVCtU/W8wnFQX2',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-02 02:44:44','2025-06-02 02:44:44',NULL,0),(11,'Gregory Jacobs','fetoryby@mailinator.com','0868681648','$2a$10$kZUd1FfHe9.C/KOzKJZcxOL.uShM946L30qhvxDyRp39Ga0IlKj..',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-02 02:47:15','2025-06-02 02:47:15',NULL,0),(12,'Taylor Gross','jygemi@mailinator.com','0370784956','$2a$10$xfj9S0w1KsRoYkxlCK7wveQVequmL7r6bN5KifZG6m5TUO89zWata',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-02 02:49:28','2025-06-02 02:49:28',NULL,0),(14,'Kameko Leach','vadyrud@mailinator.com','0575726427','$2a$10$Ry4BL4CuoaI7Djki6.jD0eawqu/iEUt1aG/uHBqFO.yBuuiNb/Eiq',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-05 02:53:25','2025-06-05 02:53:25',NULL,0),(15,'Geoffrey White','hudyq@mailinator.com','0838898566','$2a$10$I7NizmxcWCvvsCUQGGoFqOdtwNAWE3oaFJuakQXtCsU9/rGtI1qkq',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-05 05:26:40','2025-06-05 05:26:40',NULL,0),(16,'Denton Holder','quangkhoa51123@gmail.com','0367449306','$2a$10$aUaZEiTGhy28V9UQF/Rj0O.MuR08s.ohvt6lflBvZA1bVxRi.H6eC',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-06 15:07:09','2025-06-06 15:07:09',NULL,0),(17,'Thieu Quang Khoa','begig@mailinator.com','0770634550','$2a$10$vEkr7YHufIaNKugswSNrwekQdXqrVjhGR4nnM6qhLBK1V9UCuy9di',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-06 15:07:35','2025-06-06 15:07:35',NULL,0),(18,'Eleanor Tran','sopehoxyq@mailinator.com','0863647205','$2a$10$1i8Jd7VQrkQk/vP/UU4A3eCfkEHF2lloVQISSj0tftLyvGruTnTBu',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-06 15:27:31','2025-06-06 15:27:31',NULL,0),(19,'Bert Keller','gimibokuk@mailinator.com','0315448491','$2a$10$ZKeSAojzxiFnpDVz6eiG1etPVrRM9vO56mjHhebgvMafG1opIeasK',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-06 15:29:58','2025-06-06 15:29:58',NULL,0),(20,'Ian Schwartz','kuwidozata@mailinator.com','0981727583','$2a$10$OiABUyWOj5psL9dnXsfOsOgFIu5tb7Si/oJwlUFsmBV5T11gbAHl2',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-06 15:36:55','2025-06-06 15:36:55',NULL,0),(21,'Ian Bradshaw','hyjoz@mailinator.com','0994918210','$2a$10$k5F5H8URCFl8J.DE8XRUT.sm7jVcIBbzFhgYwy4aDbuDf80YIZIsy',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-06 15:47:51','2025-06-06 15:47:51',NULL,0),(22,'Alea Compton','xapymabo@mailinator.com','0526799608','$2a$10$bqPlpJK5LWK0kKJ6LyMzlOuHepBWUuSIpQn7eJGR8hsRuNMszQRx6',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-06 16:41:35','2025-06-06 16:41:35',NULL,0),(60,'Emmanuel Garcia','quangkhoa51132@5dulieu.com','0567692940','$2a$10$FwTfR.8kjEt7RPzwtkneu.HUXHOLmk9DOSYsvTZPrsLfJ1YdZyv/a',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-07 13:13:13','2025-06-07 13:13:13',NULL,0),(83,'Melanie Lancaster','quangkhoa5112@gmail.com','0722572791','$2a$10$dk3nFuHy7aguUb5SHCTaD.C9cMT2n13/HdnWlmOQcVqJTUaQaIYTa',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-10 01:36:30','2025-06-15 15:43:52',NULL,1),(109,'Odessa Stanton','khoatqhe150834@gmail.com','0543516697','$2a$10$wLyfcWxNKIkEwN/W3u1theFrzvYchPdtnP6CYzPofLBjl9blWwLVW',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-22 12:35:41','2025-06-22 13:04:02',NULL,1);
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_verification_tokens`
--

DROP TABLE IF EXISTS `email_verification_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_verification_tokens` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `token` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` timestamp NOT NULL,
  `is_used` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `idx_user_email` (`user_email`),
  KEY `idx_token` (`token`)
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_verification_tokens`
--

LOCK TABLES `email_verification_tokens` WRITE;
/*!40000 ALTER TABLE `email_verification_tokens` DISABLE KEYS */;
INSERT INTO `email_verification_tokens` VALUES (81,'c216559d-da40-447e-b38a-a5e88f1c3b0e','quangkhoa51132@5dulieu.com','2025-06-07 13:13:15','2025-06-08 13:13:15',0),(99,'0a27e432-4208-483b-8ebf-d0214ed8cbea','quangkhoa5112@gmail.com','2025-06-10 01:36:32','2025-06-11 01:36:32',1),(118,'7b75cfe9-c519-475b-a133-d5adb8764a72','khoatqhe150834@fpt.edu.vn','2025-06-16 01:24:40','2025-06-17 01:24:41',1),(129,'63df4db1-b921-47f3-93bf-c088ff4e76af','khoatqhe150834@gmail.com','2025-06-22 12:35:41','2025-06-23 12:35:42',1);
/*!40000 ALTER TABLE `email_verification_tokens` ENABLE KEYS */;
UNLOCK TABLES;

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
  `related_entity_type` enum('APPOINTMENT_PAYMENT','POINT_REDEMPTION','REFUND_ONLINE','OTHER_EXPENSE','OTHER_REVENUE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `related_entity_id` int DEFAULT NULL,
  `transaction_code_internal` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('DEBIT_SPA','CREDIT_SPA') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency_code` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'VND',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `status` enum('PENDING','COMPLETED','FAILED','CANCELLED','PARTIALLY_PAID') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'COMPLETED',
  `transaction_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`transaction_log_id`),
  UNIQUE KEY `transaction_code_internal` (`transaction_code_internal`),
  UNIQUE KEY `payment_id` (`payment_id`),
  KEY `user_id` (`user_id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `general_transactions_log_ibfk_1` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`payment_id`) ON DELETE SET NULL,
  CONSTRAINT `general_transactions_log_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `general_transactions_log_ibfk_3` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `general_transactions_log`
--

LOCK TABLES `general_transactions_log` WRITE;
/*!40000 ALTER TABLE `general_transactions_log` DISABLE KEYS */;
INSERT INTO `general_transactions_log` VALUES (5,4,NULL,2,'APPOINTMENT_PAYMENT',6,'SPA_PAY_00001','CREDIT_SPA',350000.00,'VND','Thu tiền dịch vụ Chăm Sóc Da Cơ Bản (ID: 3) cho lịch hẹn ID: 6','COMPLETED','2025-06-03 04:05:00'),(6,NULL,NULL,2,'POINT_REDEMPTION',6,'SPA_POINT_RD_00001','DEBIT_SPA',50000.00,'VND','Khách hàng Trần Văn Nam đổi 50 điểm (tương đương 50.000 VND) cho lịch hẹn ID: 6','COMPLETED','2025-06-03 04:00:00'),(7,5,NULL,1,'APPOINTMENT_PAYMENT',5,'SPA_PAY_00002','CREDIT_SPA',700000.00,'VND','Ghi nhận yêu cầu thanh toán cho dịch vụ Massage Đá Nóng (ID: 2) cho lịch hẹn ID: 5','PENDING','2025-06-05 06:00:00');
/*!40000 ALTER TABLE `general_transactions_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loyalty_point_transactions`
--

DROP TABLE IF EXISTS `loyalty_point_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loyalty_point_transactions` (
  `point_transaction_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `transaction_type` enum('EARNED_APPOINTMENT','REDEEMED_PAYMENT','ADMIN_ADJUSTMENT','EXPIRED','REFUND_POINTS','MANUAL_ADD') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `points_changed` int NOT NULL,
  `balance_after_transaction` int NOT NULL,
  `related_appointment_id` int DEFAULT NULL,
  `related_payment_id` int DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `transaction_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `admin_user_id` int DEFAULT NULL COMMENT 'User admin thực hiện điều chỉnh điểm (nếu có)',
  PRIMARY KEY (`point_transaction_id`),
  KEY `customer_id` (`customer_id`),
  KEY `related_payment_id` (`related_payment_id`),
  KEY `admin_user_id` (`admin_user_id`),
  CONSTRAINT `loyalty_point_transactions_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE,
  CONSTRAINT `loyalty_point_transactions_ibfk_3` FOREIGN KEY (`related_payment_id`) REFERENCES `payments` (`payment_id`) ON DELETE SET NULL,
  CONSTRAINT `loyalty_point_transactions_ibfk_4` FOREIGN KEY (`admin_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loyalty_point_transactions`
--

LOCK TABLES `loyalty_point_transactions` WRITE;
/*!40000 ALTER TABLE `loyalty_point_transactions` DISABLE KEYS */;
INSERT INTO `loyalty_point_transactions` VALUES (5,2,'EARNED_APPOINTMENT',35,110,6,4,'Tích điểm từ lịch hẹn hoàn thành (10.000 VND = 1 điểm)','2025-06-03 04:10:00',NULL),(6,2,'REDEEMED_PAYMENT',-50,60,6,NULL,'Đổi 50 điểm trừ vào thanh toán lịch hẹn','2025-06-03 04:00:00',NULL),(7,1,'ADMIN_ADJUSTMENT',100,250,NULL,NULL,'Tặng điểm tri ân khách hàng VIP.','2025-06-01 09:40:23',1);
/*!40000 ALTER TABLE `loyalty_point_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_types`
--

DROP TABLE IF EXISTS `notification_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_types` (
  `notification_type_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên mã của loại thông báo, e.g., APPOINTMENT_CONFIRMED, BIRTHDAY_WISH',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `template_email_subject` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `template_email_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `template_sms_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `template_in_app_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `icon_class` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_customer_facing` tinyint(1) DEFAULT '1',
  `is_staff_facing` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_type_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_types`
--

LOCK TABLES `notification_types` WRITE;
/*!40000 ALTER TABLE `notification_types` DISABLE KEYS */;
INSERT INTO `notification_types` VALUES (1,'APPOINTMENT_CONFIRMATION','Xác nhận lịch hẹn thành công','Xác nhận lịch hẹn tại An nhiên Spa','Kính chào {{customer_name}}, Lịch hẹn của bạn cho dịch vụ {{service_name}} vào lúc {{start_time}} đã được xác nhận. Mã lịch hẹn: {{appointment_id}}.','AnNhienSpa: Lich hen {{service_name}} luc {{start_time}} da duoc xac nhan. Ma LH: {{appointment_id}}. Cam on!','Lịch hẹn #{{appointment_id}} cho {{service_name}} đã được xác nhận!','fas fa-calendar-check',1,1,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(2,'APPOINTMENT_REMINDER','Nhắc nhở lịch hẹn sắp tới','Nhắc nhở: Lịch hẹn của bạn tại An nhiên Spa sắp diễn ra','Kính chào {{customer_name}}, Nhắc bạn lịch hẹn dịch vụ {{service_name}} vào lúc {{start_time}} ngày mai. Vui lòng có mặt trước 10 phút. Trân trọng!','AnNhienSpa: Nhac ban lich hen {{service_name}} vao {{start_time}} ngay mai. Hotline: 02412345678.','Đừng quên! Lịch hẹn #{{appointment_id}} cho {{service_name}} vào {{start_time}} ngày mai.','fas fa-bell',1,0,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(3,'NEW_APPOINTMENT_FOR_THERAPIST','Thông báo lịch hẹn mới cho KTV','Bạn có lịch hẹn mới','Chào {{therapist_name}}, Bạn có lịch hẹn mới: KH {{customer_name}}, Dịch vụ {{service_name}}, Thời gian {{start_time}} - {{end_time}}. Chi tiết xem tại hệ thống.',NULL,'Lịch hẹn mới: KH {{customer_name}} - {{service_name}} lúc {{start_time}}','fas fa-user-clock',0,1,'2025-06-01 09:40:23','2025-06-01 09:40:23');
/*!40000 ALTER TABLE `notification_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications_master`
--

DROP TABLE IF EXISTS `notifications_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications_master` (
  `master_notification_id` int NOT NULL AUTO_INCREMENT,
  `notification_type_id` int NOT NULL,
  `title_template` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tiêu đề có thể chứa placeholder',
  `content_template` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nội dung có thể chứa placeholder',
  `link_url_template` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `related_entity_type_context` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'e.g., APPOINTMENT, PROMOTION, CUSTOMER, USER, BOOKING_GROUP',
  `created_by_user_id` int DEFAULT NULL COMMENT 'User (staff/admin) tạo thông báo thủ công',
  `trigger_event` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Sự kiện kích hoạt thông báo tự động',
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
-- Dumping data for table `notifications_master`
--

LOCK TABLES `notifications_master` WRITE;
/*!40000 ALTER TABLE `notifications_master` DISABLE KEYS */;
INSERT INTO `notifications_master` VALUES (1,1,'Xác nhận lịch hẹn #{{appointment_id}}','Lịch hẹn của bạn cho dịch vụ {{service_name}} với KTV {{therapist_name}} vào lúc {{start_time}} ngày {{appointment_date}} đã được XÁC NHẬN.','/appointments/view/{{appointment_id}}','APPOINTMENT',NULL,'APPOINTMENT_STATUS_CONFIRMED','2025-06-01 09:40:23','2025-06-01 09:40:23'),(2,2,'Nhắc lịch hẹn #{{appointment_id}} ngày mai','Đừng quên lịch hẹn của bạn cho dịch vụ {{service_name}} vào {{start_time}} ngày mai ({{appointment_date}}).','/appointments/view/{{appointment_id}}','APPOINTMENT',NULL,'APPOINTMENT_REMINDER_24H','2025-06-01 09:40:23','2025-06-01 09:40:23'),(3,3,'Lịch hẹn mới: {{service_name}} - {{customer_name}}','Bạn được chỉ định thực hiện dịch vụ {{service_name}} cho khách hàng {{customer_name}} (SĐT: {{customer_phone}}) vào lúc {{start_time}} ngày {{appointment_date}}.','/staff/schedule/view/{{appointment_id}}','APPOINTMENT',NULL,'APPOINTMENT_ASSIGNED_TO_THERAPIST','2025-06-01 09:40:23','2025-06-01 09:40:23');
/*!40000 ALTER TABLE `notifications_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `token` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` timestamp NOT NULL,
  `is_used` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `idx_user_email` (`user_email`),
  KEY `idx_token` (`token`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
INSERT INTO `password_reset_tokens` VALUES (4,'8c09d300-9181-435b-b1e4-5c6d2faee0f1','qaxyb@mailinator.com','2025-06-03 02:10:37','2025-06-04 02:10:38',0),(37,'d115a86d-ba92-4781-9004-4a4fc169a92d','quangkhoa5112@5dulieu.com','2025-06-06 16:04:19','2025-06-07 16:04:19',0),(44,'0d3a0b97-fa55-4ab7-bf77-855bbb8bd4c1','quangkhoa51123@gmail.com','2025-06-07 14:13:13','2025-06-08 14:13:14',0);
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

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
  `payment_method` enum('CREDIT_CARD','BANK_TRANSFER','VNPAY','MOMO','LOYALTY_POINTS','OTHER_ONLINE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Chỉ các phương thức online và điểm',
  `payment_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `transaction_id_gateway` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Mã giao dịch từ cổng thanh toán',
  `status` enum('PENDING','COMPLETED','FAILED','REFUNDED','PARTIALLY_PAID') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING' COMMENT 'Trạng thái thanh toán online',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Ghi chú về thanh toán, ví dụ: mã lỗi cổng thanh toán',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `transaction_id_gateway` (`transaction_id_gateway`),
  KEY `customer_id` (`customer_id`),
  KEY `idx_payment_date` (`payment_date`),
  CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (4,6,2,350000.00,'VNPAY','2025-06-03 04:05:00','VNPAY_TRN001','COMPLETED','Thanh toán thành công cho dịch vụ Chăm Sóc Da Cơ Bản.','2025-06-01 09:40:23','2025-06-01 09:40:23'),(5,5,1,700000.00,'MOMO','2025-06-05 06:00:00','MOMO_TRN002','PENDING','Khách hàng đã tạo yêu cầu thanh toán qua Momo.','2025-06-01 09:40:23','2025-06-01 09:40:23');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promotions`
--

DROP TABLE IF EXISTS `promotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotions` (
  `promotion_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `promotion_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discount_type` enum('PERCENTAGE','FIXED_AMOUNT','FREE_SERVICE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `discount_value` decimal(12,2) NOT NULL COMMENT 'Giá trị giảm (%), số tiền. Nếu FREE_SERVICE, có thể lưu service_id ở đây.',
  `applies_to_service_id` int DEFAULT NULL COMMENT 'Nếu FREE_SERVICE hoặc KM cho dịch vụ cụ thể.',
  `minimum_appointment_value` decimal(12,2) DEFAULT '0.00' COMMENT 'Giá trị tối thiểu của lịch hẹn để áp dụng KM',
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `status` enum('SCHEDULED','ACTIVE','INACTIVE','EXPIRED','ARCHIVED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SCHEDULED',
  `usage_limit_per_customer` int DEFAULT NULL,
  `total_usage_limit` int DEFAULT NULL,
  `current_usage_count` int DEFAULT '0',
  `applicable_scope` enum('ALL_SERVICES','SPECIFIC_SERVICES','ENTIRE_APPOINTMENT') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ENTIRE_APPOINTMENT',
  `applicable_service_ids_json` json DEFAULT NULL COMMENT 'Mảng JSON chứa IDs của services được áp dụng',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `terms_and_conditions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
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
-- Dumping data for table `promotions`
--

LOCK TABLES `promotions` WRITE;
/*!40000 ALTER TABLE `promotions` DISABLE KEYS */;
INSERT INTO `promotions` VALUES (1,'Chào Hè Rực Rỡ - Giảm 20%','Giảm giá 20% cho tất cả dịch vụ massage.','SUMMER20','PERCENTAGE',20.00,NULL,500000.00,'2025-06-01 00:00:00','2025-08-31 23:59:59','ACTIVE',1,100,10,'SPECIFIC_SERVICES','[1, 2]','https://placehold.co/400x200/FFD700/333333?text=SummerPromo','Áp dụng cho các dịch vụ massage. Không áp dụng cùng KM khác.',1,0,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(2,'Tri Ân Khách Hàng - Tặng Voucher 100K','Tặng voucher 100.000 VNĐ cho hóa đơn từ 1.000.000 VNĐ.','THANKS100K','FIXED_AMOUNT',100000.00,NULL,1000000.00,'2025-07-01 00:00:00','2025-07-31 23:59:59','SCHEDULED',1,200,0,'ENTIRE_APPOINTMENT',NULL,'https://placehold.co/400x200/E6E6FA/333333?text=VoucherPromo','Mỗi khách hàng được sử dụng 1 lần.',2,0,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(3,'Đi Cùng Bạn Bè - Miễn Phí 1 Dịch Vụ Gội Đầu','Khi đặt 2 dịch vụ bất kỳ, tặng 1 dịch vụ gội đầu thảo dược.','FRIENDSFREE','FREE_SERVICE',6.00,NULL,800000.00,'2025-06-15 00:00:00','2025-07-15 23:59:59','ACTIVE',1,50,5,'ENTIRE_APPOINTMENT',NULL,'https://placehold.co/400x200/B0C4DE/333333?text=FriendsPromo','Dịch vụ tặng kèm là Gội Đầu Thảo Dược (ID: 6).',1,0,'2025-06-01 09:40:23','2025-06-01 09:40:23');
/*!40000 ALTER TABLE `promotions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `remember_me_tokens`
--

DROP TABLE IF EXISTS `remember_me_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `remember_me_tokens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiry_date` datetime NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`)
) ENGINE=InnoDB AUTO_INCREMENT=170 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `remember_me_tokens`
--

LOCK TABLES `remember_me_tokens` WRITE;
/*!40000 ALTER TABLE `remember_me_tokens` DISABLE KEYS */;
INSERT INTO `remember_me_tokens` VALUES (11,'quangkhoa5112@5dulieu.com','123456789','0cb51cb5-2380-4033-acdc-f3cd9fa385ce','2025-07-06 09:36:14','2025-06-06 09:36:13'),(24,'xapymabo@mailinator.com','A123456a@','aae04773-83ea-47ae-b622-9712d48c53f8','2025-07-07 08:05:55','2025-06-07 08:05:54'),(97,'therapist@beautyzone.com','123456','fc4ac81a-adca-4486-b47d-1ecb4d2a1a0b','2025-07-14 17:58:55','2025-06-14 17:58:55'),(137,'admin@beautyzone.com','123456','20bc9af0-032b-4a4e-ade7-034ee9d2e80b','2025-07-16 20:52:51','2025-06-16 20:52:51'),(143,'manager@beautyzone.com','123456','1b641335-57c4-4c99-b47c-171089f0e0a1','2025-07-16 22:52:52','2025-06-16 22:52:51'),(149,'khoatqhe150834@fpt.edu.vn','123456','8bb29688-a91f-4ff6-b85f-6b0fcee17e56','2025-07-17 20:17:45','2025-06-17 20:17:44'),(164,'quangkhoa5112@gmail.com','123456','6908a27a-ae0c-48d4-bdfc-55473045e53a','2025-07-21 20:45:11','2025-06-21 20:45:11'),(169,'khoatqhe150834@gmail.com','123456','00458c2a-e7b6-4ccb-9414-41f99596f080','2025-07-22 20:04:06','2025-06-22 20:04:06');
/*!40000 ALTER TABLE `remember_me_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên vai trò (system name, e.g., ADMIN, MANAGER, THERAPIST)',
  `display_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên hiển thị của vai trò',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Mô tả vai trò',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'ADMIN','Quản trị viên','Quản lý toàn bộ hệ thống','2025-06-01 09:40:23','2025-06-01 09:40:23'),(2,'MANAGER','Quản lý Spa','Quản lý hoạt động hàng ngày của spa','2025-06-01 09:40:23','2025-06-01 09:40:23'),(3,'THERAPIST','Kỹ thuật viên','Thực hiện các dịch vụ cho khách hàng','2025-06-01 09:40:23','2025-06-01 09:40:23'),(4,'RECEPTIONIST','Lễ tân','Tiếp đón khách, đặt lịch, thu ngân','2025-06-01 09:40:23','2025-06-01 09:40:23'),(5,'CUSTOMER','Khách hàng đã đăng ký','Khách hàng có tài khoản trên hệ thống','2025-06-01 09:40:23','2025-06-04 04:20:04');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `service_categories`
--

LOCK TABLES `service_categories` WRITE;
/*!40000 ALTER TABLE `service_categories` DISABLE KEYS */;
INSERT INTO `service_categories` VALUES (1,1),(2,1),(6,1),(3,2),(4,2),(5,2),(3,3),(4,3);
/*!40000 ALTER TABLE `service_categories` ENABLE KEYS */;
UNLOCK TABLES;

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
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  KEY `service_id` (`service_id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `service_reviews_ibfk_1` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`) ON DELETE CASCADE,
  CONSTRAINT `service_reviews_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_reviews`
--

LOCK TABLES `service_reviews` WRITE;
/*!40000 ALTER TABLE `service_reviews` DISABLE KEYS */;
INSERT INTO `service_reviews` VALUES (4,3,2,6,5,'Rất hài lòng!','Dịch vụ chăm sóc da rất tốt, da tôi cải thiện rõ rệt. Kỹ thuật viên Dung rất nhiệt tình.','2025-06-01 09:40:23','2025-06-01 09:40:23'),(5,2,1,50,5,'Tuyệt vời!','Anh Cường massage rất chuyên nghiệp.','2025-06-18 09:04:30','2025-06-18 09:04:30'),(6,1,2,51,4,'Hài lòng','Dịch vụ tốt, sẽ quay lại.','2025-06-18 09:04:30','2025-06-18 09:04:30'),(7,3,3,52,4,'Khá tốt','Chị Dung làm da rất cẩn thận.','2025-06-18 09:04:30','2025-06-18 09:04:30'),(8,7,5,53,5,'Rất thư giãn','Massage Thái đúng chuẩn.','2025-06-18 09:04:30','2025-06-18 09:04:30'),(9,11,6,54,3,'Tạm được','Hiệu quả chưa rõ rệt lắm.','2025-06-18 09:04:30','2025-06-18 09:04:30'),(10,12,7,55,5,'Da sáng mịn','Rất thích liệu trình vitamin C này.','2025-06-18 09:04:30','2025-06-18 09:04:30'),(11,1,8,56,4,'Tốt','Anh Long tay nghề tốt.','2025-06-18 09:04:30','2025-06-18 09:04:30'),(12,2,9,57,5,'Trên cả tuyệt vời!','Đá nóng rất hiệu quả, cảm ơn anh Huy.','2025-06-18 09:04:30','2025-06-18 09:04:30');
/*!40000 ALTER TABLE `service_reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_types`
--

DROP TABLE IF EXISTS `service_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_types` (
  `service_type_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên loại dịch vụ',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`service_type_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_types`
--

LOCK TABLES `service_types` WRITE;
/*!40000 ALTER TABLE `service_types` DISABLE KEYS */;
INSERT INTO `service_types` VALUES (1,'Massage Thư Giãn','Các liệu pháp massage giúp thư giãn cơ thể và tinh thần.','https://placehold.co/300x200/E0FFFF/333333?text=Massage',1,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(2,'Chăm Sóc Da Mặt','Dịch vụ chăm sóc và cải thiện làn da mặt.','https://placehold.co/300x200/FFFACD/333333?text=Facial',1,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(3,'Chăm Sóc Toàn Thân','Các liệu pháp chăm sóc cơ thể toàn diện.','https://placehold.co/300x200/F5FFFA/333333?text=BodyCare',1,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(4,'Dịch Vụ Gội Đầu Dưỡng Sinh','Gội đầu kết hợp massage cổ vai gáy.','https://placehold.co/300x200/FFEBCD/333333?text=HairWash',1,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(5,'Chăm Sóc Móng','Dịch vụ làm đẹp móng tay và móng chân chuyên nghiệp','https://placehold.co/300x200/FFB6C1/333333?text=NailCare',1,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(6,'Tẩy Lông & Waxing','Các phương pháp tẩy lông an toàn và hiệu quả','https://placehold.co/300x200/DDA0DD/333333?text=Waxing',1,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(7,'Chăm Sóc Lông Mi & Lông Mày','Dịch vụ làm đẹp mắt và định hình lông mày','https://placehold.co/300x200/F0E68C/333333?text=EyeCare',1,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(8,'Liệu Pháp Thơm','Trị liệu bằng tinh dầu thiên nhiên và hương thơm','https://placehold.co/300x200/E6E6FA/333333?text=Aromatherapy',1,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(9,'Liệu Pháp Nước','Các liệu pháp sử dụng nước khoáng và thủy trị liệu','https://placehold.co/300x200/AFEEEE/333333?text=Hydrotherapy',1,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(10,'Y Học Cổ Truyền Việt Nam','Các phương pháp chữa bệnh truyền thống của Việt Nam','https://placehold.co/300x200/90EE90/333333?text=TraditionalMedicine',1,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(11,'Giảm Cân & Định Hình Cơ Thể','Các liệu pháp hỗ trợ giảm cân và tạo vóc dáng','https://placehold.co/300x200/FFA07A/333333?text=Slimming',1,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(12,'Dịch Vụ Cặp Đôi','Các gói dịch vụ đặc biệt dành cho cặp đôi','https://placehold.co/300x200/FFDAB9/333333?text=Couples',1,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(13,'Chống Lão Hóa','Các liệu pháp chống lão hóa và trẻ hóa làn da','https://placehold.co/300x200/F5DEB3/333333?text=AntiAging',1,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(14,'Thải Độc & Thanh Lọc','Các liệu pháp thanh lọc cơ thể và thải độc tự nhiên','https://placehold.co/300x200/98FB98/333333?text=Detox',1,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(15,'Massage Trị Liệu','Các phương pháp massage chuyên sâu cho điều trị','https://placehold.co/300x200/B0E0E6/333333?text=TherapeuticMassage',1,'2025-06-17 16:05:28','2025-06-17 16:05:28');
/*!40000 ALTER TABLE `service_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `services` (
  `service_id` int NOT NULL AUTO_INCREMENT,
  `service_type_id` int NOT NULL COMMENT 'Loại dịch vụ mà dịch vụ này thuộc về',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `price` decimal(12,2) NOT NULL,
  `duration_minutes` int NOT NULL COMMENT 'Thời gian thực hiện dịch vụ (phút)',
  `buffer_time_after_minutes` int DEFAULT '0' COMMENT 'Thời gian đệm sau dịch vụ (phút), ví dụ dọn dẹp',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `average_rating` decimal(3,2) DEFAULT '0.00',
  `bookable_online` tinyint(1) DEFAULT '1' COMMENT 'Dịch vụ này có thể đặt online qua giỏ hàng/hệ thống không',
  `requires_consultation` tinyint(1) DEFAULT '0' COMMENT 'Dịch vụ này có cần tư vấn trước khi đặt không',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`service_id`),
  KEY `service_type_id` (`service_type_id`),
  CONSTRAINT `services_ibfk_1` FOREIGN KEY (`service_type_id`) REFERENCES `service_types` (`service_type_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=137 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (1,1,'Massage Thụy Điển','Massage cổ điển giúp giảm căng thẳng, tăng cường lưu thông máu.',500000.00,60,15,'https://placehold.co/300x200/ADD8E6/333333?text=SwedishMassage',1,4.50,1,0,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(2,1,'Massage Đá Nóng','Sử dụng đá nóng bazan giúp thư giãn sâu các cơ bắp.',700000.00,90,15,'https://placehold.co/300x200/F0E68C/333333?text=HotStone',1,4.80,1,0,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(3,2,'Chăm Sóc Da Cơ Bản','Làm sạch sâu, tẩy tế bào chết, đắp mặt nạ dưỡng ẩm.',400000.00,60,10,'https://placehold.co/300x200/E6E6FA/333333?text=BasicFacial',1,5.00,1,0,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(4,2,'Trị Mụn Chuyên Sâu','Liệu trình trị mụn, giảm viêm, ngăn ngừa tái phát.',650000.00,75,20,'https://placehold.co/300x200/FFDAB9/333333?text=AcneTreatment',1,4.00,1,1,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(5,3,'Tẩy Tế Bào Chết Toàn Thân','Loại bỏ tế bào chết, giúp da mịn màng, tươi sáng.',450000.00,45,10,'https://placehold.co/300x200/90EE90/333333?text=BodyScrub',1,4.60,1,0,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(6,4,'Gội Đầu Thảo Dược','Gội đầu bằng thảo dược thiên nhiên, massage thư giãn.',300000.00,60,10,'https://placehold.co/300x200/FFE4B5/333333?text=HerbalHairWash',1,4.70,1,0,'2025-06-01 09:40:23','2025-06-01 09:40:23'),(7,1,'Massage Thái Cổ Truyền','Massage theo phong cách Thái Lan với các động tác duỗi giãn cơ thể',650000.00,90,15,'https://placehold.co/300x200/DEB887/333333?text=ThaiMassage',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(8,1,'Massage Shiatsu Nhật Bản','Kỹ thuật massage bấm huyệt theo phong cách Nhật Bản',750000.00,75,15,'https://placehold.co/300x200/F4A460/333333?text=Shiatsu',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(9,1,'Massage Foot Reflexology','Massage phản xạ bàn chân kích thích các huyệt đạo',400000.00,45,10,'https://placehold.co/300x200/CD853F/333333?text=FootReflexology',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(10,1,'Massage Toàn Thân Dầu Dừa','Massage thư giãn toàn thân với dầu dừa nguyên chất',550000.00,60,15,'https://placehold.co/300x200/DDA0DD/333333?text=CoconutMassage',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(11,2,'Điều Trị Nám & Tàn Nhang','Liệu trình chuyên sâu điều trị nám melasma và tàn nhang',800000.00,90,20,'https://placehold.co/300x200/FFEFD5/333333?text=MelesmaTreatment',1,0.00,1,1,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(12,2,'Facial Vitamin C Brightening','Chăm sóc da với vitamin C giúp da sáng mịn',550000.00,75,15,'https://placehold.co/300x200/FFF8DC/333333?text=VitaminCFacial',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(13,2,'Microdermabrasion','Lột da mặt bằng tinh thể kim cương loại bỏ lớp da chết',700000.00,60,20,'https://placehold.co/300x200/F0FFFF/333333?text=Microdermabrasion',1,0.00,1,1,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(14,2,'Hydrafacial Deep Cleansing','Làm sạch sâu và cấp ẩm chuyên sâu cho da mặt',900000.00,90,15,'https://placehold.co/300x200/E0FFFF/333333?text=Hydrafacial',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(15,2,'Collagen Boost Facial','Liệu trình kích thích collagen tự nhiên chống lão hóa',850000.00,80,15,'https://placehold.co/300x200/F5FFFA/333333?text=CollagenFacial',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(16,2,'Oxygen Infusion Treatment','Truyền oxy tinh khiết giúp da tươi sáng và khỏe mạnh',750000.00,70,15,'https://placehold.co/300x200/F0F8FF/333333?text=OxygenFacial',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(17,3,'Body Wrap Bùn Khoáng','Đắp bùn khoáng toàn thân giúp thải độc và làm mềm da',600000.00,75,20,'https://placehold.co/300x200/D2B48C/333333?text=MudWrap',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(18,3,'Tắm Trắng Toàn Thân','Liệu trình tắm trắng an toàn với thành phần tự nhiên',800000.00,90,25,'https://placehold.co/300x200/FFF5EE/333333?text=BodyWhitening',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(19,3,'Massage Giảm Cellulite','Massage chuyên sâu giúp giảm cellulite và săn chắc da',700000.00,75,15,'https://placehold.co/300x200/FFE4E1/333333?text=CelluliteMassage',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(20,3,'Body Polish & Moisturizing','Tẩy tế bào chết và dưỡng ẩm toàn thân chuyên sâu',500000.00,60,15,'https://placehold.co/300x200/F0FFF0/333333?text=BodyPolish',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(21,3,'Chocolate Body Treatment','Liệu pháp chocolate tươi giúp nuôi dưỡng và thư giãn',650000.00,80,20,'https://placehold.co/300x200/D2691E/333333?text=ChocolateTreatment',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(22,3,'Seaweed Body Wrap','Đắp rong biển giàu khoáng chất cho da toàn thân',580000.00,70,20,'https://placehold.co/300x200/2E8B57/333333?text=SeaweedWrap',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(23,4,'Massage Da Đầu Tinh Dầu','Massage da đầu chuyên sâu với tinh dầu thảo mộc',350000.00,45,10,'https://placehold.co/300x200/DDA0DD/333333?text=ScalpMassage',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(24,4,'Điều Trị Gàu & Ngứa Da Đầu','Liệu trình chuyên trị gàu và các vấn đề về da đầu',450000.00,60,15,'https://placehold.co/300x200/F0E68C/333333?text=DandruffTreatment',1,0.00,1,1,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(25,4,'Hair Mask Keratin Phục Hồi','Ủ tóc keratin giúp phục hồi tóc hư tổn',400000.00,75,15,'https://placehold.co/300x200/FFE4B5/333333?text=KeratinMask',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(26,4,'Gội Đầu Bằng Lá Bồ Kết','Gội đầu theo phương pháp dân gian với lá bồ kết',250000.00,40,10,'https://placehold.co/300x200/9ACD32/333333?text=HerbalWash',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(27,5,'Manicure Cơ Bản','Làm móng tay cơ bản với cắt, giũa và sơn móng',200000.00,45,10,'https://placehold.co/300x200/FFB6C1/333333?text=BasicManicure',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(28,5,'Pedicure Deluxe','Chăm sóc móng chân cao cấp với ngâm chân và massage',350000.00,75,15,'https://placehold.co/300x200/DDA0DD/333333?text=DeluxePedicure',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(29,5,'Gel Polish Manicure','Sơn gel bền màu lên đến 3 tuần',300000.00,60,10,'https://placehold.co/300x200/FF69B4/333333?text=GelManicure',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(30,5,'Nail Art Design','Vẽ móng nghệ thuật theo yêu cầu',400000.00,90,15,'https://placehold.co/300x200/FF1493/333333?text=NailArt',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(31,5,'French Manicure','Kiểu móng Pháp cổ điển thanh lịch',250000.00,50,10,'https://placehold.co/300x200/FFF0F5/333333?text=FrenchManicure',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(32,5,'Spa Pedicure Thảo Dược','Chăm sóc chân với thảo dược thiên nhiên',450000.00,90,20,'https://placehold.co/300x200/E6E6FA/333333?text=HerbalPedicure',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(33,5,'Paraffin Treatment','Ngâm tay chân trong sáp ấm để dưỡng ẩm',300000.00,45,10,'https://placehold.co/300x200/FFEFD5/333333?text=ParaffinTreatment',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(34,5,'Callus Removal','Loại bỏ vết chai cứng ở bàn chân',200000.00,30,10,'https://placehold.co/300x200/F5DEB3/333333?text=CallusRemoval',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(35,5,'Acrylic Nail Extension','Nối móng acrylic theo độ dài mong muốn',500000.00,120,20,'https://placehold.co/300x200/DA70D6/333333?text=AcrylicNails',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(36,5,'Cuticle Care Treatment','Chăm sóc da quanh móng chuyên sâu',150000.00,30,5,'https://placehold.co/300x200/FAFAD2/333333?text=CuticleCare',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(37,6,'Waxing Chân Toàn Phần','Tẩy lông toàn bộ đôi chân bằng sáp nóng',400000.00,60,15,'https://placehold.co/300x200/DDA0DD/333333?text=FullLegWax',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(38,6,'Waxing Tay Toàn Phần','Tẩy lông toàn bộ đôi tay bằng sáp nóng',300000.00,45,10,'https://placehold.co/300x200/F0E68C/333333?text=FullArmWax',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(39,6,'Waxing Nách','Tẩy lông vùng nách sạch sẽ và an toàn',150000.00,20,10,'https://placehold.co/300x200/FFB6C1/333333?text=UnderarmWax',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(40,6,'Waxing Mặt','Tẩy lông mặt nhẹ nhàng cho da nhạy cảm',200000.00,30,10,'https://placehold.co/300x200/FFEFD5/333333?text=FacialWax',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(41,6,'Brazilian Wax','Tẩy lông vùng bikini theo kiểu Brazil',500000.00,45,20,'https://placehold.co/300x200/FF69B4/333333?text=BrazilianWax',1,0.00,1,1,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(42,6,'Bikini Line Wax','Tẩy lông đường bikini cơ bản',300000.00,30,15,'https://placehold.co/300x200/DA70D6/333333?text=BikiniWax',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(43,6,'Tẩy Lông Laser IPL','Tẩy lông vĩnh viễn bằng công nghệ IPL',800000.00,60,20,'https://placehold.co/300x200/E6E6FA/333333?text=IPLHairRemoval',1,0.00,1,1,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(44,6,'Waxing Bụng','Tẩy lông vùng bụng sạch sẽ',250000.00,25,10,'https://placehold.co/300x200/F5DEB3/333333?text=AbdomenWax',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(45,6,'Waxing Lưng Nam','Tẩy lông lưng dành cho nam giới',350000.00,40,15,'https://placehold.co/300x200/D2B48C/333333?text=BackWaxMen',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(46,6,'Sugar Wax Tự Nhiên','Tẩy lông bằng sáp đường tự nhiên, ít đau',320000.00,45,10,'https://placehold.co/300x200/F0FFF0/333333?text=SugarWax',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(47,7,'Nối Mi Classic','Nối mi từng sợi theo phong cách tự nhiên',500000.00,90,15,'https://placehold.co/300x200/F0E68C/333333?text=ClassicLashes',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(48,7,'Nối Mi Volume','Nối mi nhiều tầng tạo độ dày đặc',700000.00,120,20,'https://placehold.co/300x200/FFB6C1/333333?text=VolumeLashes',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(49,7,'Uốn Mi Tự Nhiên','Uốn mi tạo độ cong tự nhiên không cần mascara',300000.00,45,10,'https://placehold.co/300x200/FFEFD5/333333?text=LashLift',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(50,7,'Nhuộm Mi & Lông Mày','Nhuộm màu tự nhiên cho mi và lông mày',200000.00,30,10,'https://placehold.co/300x200/DDA0DD/333333?text=TintingService',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(51,7,'Tạo Dáng Lông Mày Threading','Tạo dáng lông mày bằng chỉ theo kiểu Ấn Độ',150000.00,25,5,'https://placehold.co/300x200/D2B48C/333333?text=BrowThreading',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(52,7,'Phun Xăm Lông Mày 3D','Phun xăm lông mày tự nhiên công nghệ 3D',2000000.00,150,30,'https://placehold.co/300x200/F5DEB3/333333?text=3DBrowTattoo',1,0.00,1,1,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(53,7,'Lamination Lông Mày','Uốn và cố định lông mày tạo dáng hoàn hảo',350000.00,45,10,'https://placehold.co/300x200/E6E6FA/333333?text=BrowLamination',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(54,7,'Làm Sạch Lông Mày','Nhổ sạch lông mày thừa tạo dáng gọn gàng',100000.00,20,5,'https://placehold.co/300x200/F0FFF0/333333?text=BrowCleaning',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(55,7,'Cấy Mi Vĩnh Viễn','Cấy mi tự thân tạo mi dài vĩnh viễn',15000000.00,240,60,'https://placehold.co/300x200/FF69B4/333333?text=LashImplant',1,0.00,1,1,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(56,7,'Chăm Sóc Mi Sau Nối','Dưỡng và chăm sóc mi sau khi nối',200000.00,30,10,'https://placehold.co/300x200/FAFAD2/333333?text=LashCare',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(57,8,'Aromatherapy Massage Lavender','Massage thư giãn với tinh dầu oải hương',600000.00,75,15,'https://placehold.co/300x200/E6E6FA/333333?text=LavenderAroma',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(58,8,'Trị Liệu Tinh Dầu Bạch Đàn','Liệu pháp tinh dầu bạch đàn cho hệ hô hấp',450000.00,60,15,'https://placehold.co/300x200/98FB98/333333?text=EucalyptusTherapy',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(59,8,'Xông Hơi Tinh Dầu','Xông hơi với các loại tinh dầu thiên nhiên',350000.00,45,15,'https://placehold.co/300x200/AFEEEE/333333?text=AromaSteam',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(60,8,'Massage Tinh Dầu Sả Chanh','Massage với tinh dầu sả chanh thư giãn',500000.00,60,15,'https://placehold.co/300x200/F0FFF0/333333?text=LemongrassAroma',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(61,8,'Điều Trị Stress Aromatherapy','Liệu pháp tinh dầu chuyên trị stress',550000.00,75,20,'https://placehold.co/300x200/FFE4E1/333333?text=StressRelief',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(62,8,'Thơm Phòng Trị Liệu','Trị liệu tâm lý với hương thơm tự nhiên',400000.00,45,10,'https://placehold.co/300x200/F5FFFA/333333?text=RoomAromatherapy',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(63,8,'Ngâm Chân Tinh Dầu','Ngâm chân thư giãn với tinh dầu thảo mộc',300000.00,40,10,'https://placehold.co/300x200/DDA0DD/333333?text=FootAromaSoak',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(64,8,'Hít Thở Liệu Pháp','Liệu pháp hít thở với tinh dầu',250000.00,30,10,'https://placehold.co/300x200/F0E68C/333333?text=BreathingTherapy',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(65,8,'Massage Đầu Tinh Dầu Bưởi','Massage da đầu với tinh dầu bưởi kích thích mọc tóc',350000.00,45,10,'https://placehold.co/300x200/FFA07A/333333?text=GrapefruitScalp',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(66,8,'Aromatherapy Facial','Chăm sóc da mặt kết hợp tinh dầu',650000.00,80,15,'https://placehold.co/300x200/FFEFD5/333333?text=AromaFacial',1,0.00,1,0,'2025-06-17 16:05:28','2025-06-17 16:05:28'),(67,9,'Jacuzzi Massage Nước Ấm','Massage trong bồn jacuzzi với nước khoáng ấm',800000.00,60,20,'https://placehold.co/300x200/AFEEEE/333333?text=JacuzziMassage',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(68,9,'Tắm Khoáng Nóng Onsen','Tắm khoáng nóng theo phong cách Nhật Bản',600000.00,45,15,'https://placehold.co/300x200/B0E0E6/333333?text=OnsenBath',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(69,9,'Vichy Shower Treatment','Tắm massage với vòi sen Vichy',700000.00,50,15,'https://placehold.co/300x200/E0FFFF/333333?text=VichyShower',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(70,9,'Tắm Sữa Dê Cleopatra','Tắm sữa dê giàu dưỡng chất như nữ hoàng Ai Cập',900000.00,75,20,'https://placehold.co/300x200/FFF8DC/333333?text=MilkBath',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(71,9,'Flotation Therapy','Liệu pháp nổi trên mặt nước muối Epsom',1200000.00,60,30,'https://placehold.co/300x200/F0F8FF/333333?text=FloatTherapy',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(72,9,'Tắm Hoa Hồng','Tắm thư giãn với cánh hoa hồng tươi',650000.00,60,15,'https://placehold.co/300x200/FFB6C1/333333?text=RosePetalBath',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(73,9,'Aqua Fitness','Tập thể dục trong nước để thư giãn cơ bắp',400000.00,45,15,'https://placehold.co/300x200/40E0D0/333333?text=AquaFitness',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(74,9,'Thalassotherapy','Liệu pháp nước biển và tảo biển',850000.00,90,20,'https://placehold.co/300x200/20B2AA/333333?text=Thalassotherapy',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(75,9,'Kneipp Water Therapy','Liệu pháp nước Kneipp chữa bệnh',550000.00,60,15,'https://placehold.co/300x200/87CEEB/333333?text=KneippTherapy',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(76,9,'Contrast Hydrotherapy','Liệu pháp tương phản nóng lạnh',500000.00,45,15,'https://placehold.co/300x200/F0FFFF/333333?text=ContrastTherapy',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(77,10,'Bấm Huyệt Chữa Bệnh','Bấm huyệt theo y học cổ truyền Việt Nam',400000.00,60,15,'https://placehold.co/300x200/90EE90/333333?text=AcupressureVN',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(78,10,'Châm Cứu Điều Trị','Châm cứu chữa bệnh bằng kim',500000.00,75,20,'https://placehold.co/300x200/32CD32/333333?text=Acupuncture',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(79,10,'Giác Hơi Thảo Dược','Giác hơi kết hợp với thảo dược',350000.00,45,15,'https://placehold.co/300x200/228B22/333333?text=Cupping',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(80,10,'Xông Hơi Lá Thuốc Nam','Xông hơi với lá thuốc Nam truyền thống',300000.00,40,15,'https://placehold.co/300x200/9ACD32/333333?text=HerbalSteam',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(81,10,'Massage Tuina Trung Quốc','Massage Tuina theo phong cách Trung Quốc',450000.00,75,15,'https://placehold.co/300x200/6B8E23/333333?text=TuinaMassage',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(82,10,'Trị Liệu Đá Nóng Himalaya','Massage với đá nóng Himalaya',650000.00,90,20,'https://placehold.co/300x200/8FBC8F/333333?text=HimalayaStone',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(83,10,'Xoa Bóp Gù Truyền Thống','Xoa bóp gù theo phương pháp dân gian',300000.00,45,10,'https://placehold.co/300x200/ADFF2F/333333?text=TraditionalMassage',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(84,10,'Ngâm Chân Thuốc Bắc','Ngâm chân với thuốc Bắc quý hiếm',250000.00,30,10,'https://placehold.co/300x200/98FB98/333333?text=HerbalFootSoak',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(85,10,'Cạo Gió Chữa Bệnh','Cạo gió theo phương pháp y học dân gian',200000.00,30,10,'https://placehold.co/300x200/F0E68C/333333?text=CaoGio',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(86,10,'Đắp Lá Chuối Điều Trị','Đắp lá chuối non chữa viêm khớp',350000.00,60,15,'https://placehold.co/300x200/7CFC00/333333?text=BananaLeafTreatment',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(87,11,'Máy Giảm Béo RF','Giảm béo bằng sóng radio tần số cao',1500000.00,60,20,'https://placehold.co/300x200/FFA07A/333333?text=RFSlimming',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(88,11,'Massage Tan Mỡ Bụng','Massage chuyên sâu giúp tan mỡ bụng',600000.00,75,15,'https://placehold.co/300x200/FF7F50/333333?text=BellyFatMassage',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(89,11,'Liposuction Không Phẫu Thuật','Hút mỡ không xâm lấn bằng công nghệ cao',3000000.00,120,30,'https://placehold.co/300x200/CD5C5C/333333?text=NonSurgicalLipo',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(90,11,'Body Contouring','Định hình cơ thể với máy móc hiện đại',2000000.00,90,20,'https://placehold.co/300x200/F08080/333333?text=BodyContouring',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(91,11,'Cryolipolysis Đông Lạnh Mỏ','Giảm mỡ bằng công nghệ đông lạnh',2500000.00,60,30,'https://placehold.co/300x200/4682B4/333333?text=CoolSculpting',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(92,11,'EMS Điện Kích Thích Cơ','Kích thích cơ bắp bằng xung điện',800000.00,45,15,'https://placehold.co/300x200/FFB347/333333?text=EMSTraining',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(93,11,'Bandage Quấn Thảo Dược','Quấn băng thảo dược giảm size',700000.00,90,20,'https://placehold.co/300x200/DEB887/333333?text=HerbalWrap',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(94,11,'Infrared Sauna Giảm Cân','Xông hơi hồng ngoại giúp đốt cháy mỡ',500000.00,45,15,'https://placehold.co/300x200/FF6347/333333?text=InfraredSauna',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(95,11,'Lymphatic Drainage','Massage dẫn lưu bạch huyết giảm phù nề',650000.00,60,15,'https://placehold.co/300x200/20B2AA/333333?text=LymphaticMassage',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(96,11,'Pressotherapy Ép Khí','Máy ép khí giúp lưu thông máu',750000.00,45,15,'https://placehold.co/300x200/87CEEB/333333?text=Pressotherapy',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(97,12,'Couples Massage Suite','Massage đôi trong phòng riêng romantic',1200000.00,90,30,'https://placehold.co/300x200/FFDAB9/333333?text=CouplesMassage',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(98,12,'Private Jacuzzi for Two','Jacuzzi riêng tư dành cho hai người',1500000.00,60,30,'https://placehold.co/300x200/FFE4E1/333333?text=PrivateJacuzzi',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(99,12,'Wine & Dine Spa Package','Gói spa kết hợp với rượu vang và ăn tối',2500000.00,180,30,'https://placehold.co/300x200/F5DEB3/333333?text=WineDineSpa',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(100,12,'Couples Facial Treatment','Chăm sóc da mặt cho cặp đôi',1000000.00,75,20,'https://placehold.co/300x200/FFF8DC/333333?text=CouplesFacial',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(101,12,'Romantic Rose Package','Gói dịch vụ lãng mạn với hoa hồng',1800000.00,120,30,'https://placehold.co/300x200/FFB6C1/333333?text=RomanticPackage',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(102,12,'Sunset Beach Massage','Massage trên bãi biển lúc hoàng hôn',2000000.00,90,30,'https://placehold.co/300x200/FF7F50/333333?text=BeachMassage',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(103,12,'Couples Yoga Session','Lớp yoga dành cho cặp đôi',800000.00,60,15,'https://placehold.co/300x200/98FB98/333333?text=CouplesYoga',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(104,12,'Anniversary Celebration','Gói kỷ niệm ngày cưới đặc biệt',3000000.00,240,60,'https://placehold.co/300x200/DDA0DD/333333?text=Anniversary',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(105,12,'Honeymoon Bliss Package','Gói tuần trăng mật hoàn hảo',2800000.00,180,45,'https://placehold.co/300x200/F0E68C/333333?text=Honeymoon',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(106,12,'Couples Meditation','Thiền đôi trong không gian yên tĩnh',600000.00,45,15,'https://placehold.co/300x200/E6E6FA/333333?text=CouplesMeditation',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(107,13,'Anti-Aging Facial Premium','Chăm sóc da chống lão hóa cao cấp',1200000.00,90,20,'https://placehold.co/300x200/F5DEB3/333333?text=AntiAgingFacial',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(108,13,'Botox Treatment','Tiêm botox giảm nếp nhăn',5000000.00,30,30,'https://placehold.co/300x200/FFE4E1/333333?text=BotoxTreatment',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(109,13,'Collagen Infusion','Truyền collagen tươi vào da',2000000.00,75,20,'https://placehold.co/300x200/FFF0F5/333333?text=CollagenInfusion',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(110,13,'LED Light Therapy','Liệu pháp ánh sáng LED chống lão hóa',800000.00,45,15,'https://placehold.co/300x200/E0FFFF/333333?text=LEDTherapy',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(111,13,'Peptide Facial Mask','Mặt nạ peptide chống nhăn',900000.00,60,15,'https://placehold.co/300x200/F0F8FF/333333?text=PeptideMask',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(112,13,'Stem Cell Treatment','Liệu pháp tế bào gốc trẻ hóa',8000000.00,120,30,'https://placehold.co/300x200/F5FFFA/333333?text=StemCellTreatment',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(113,13,'Retinol Peel','Lột da bằng retinol chống lão hóa',1500000.00,60,20,'https://placehold.co/300x200/FFEFD5/333333?text=RetinolPeel',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(114,13,'Ultrasound Lifting','Nâng cơ mặt bằng sóng siêu âm',3000000.00,90,30,'https://placehold.co/300x200/F0FFF0/333333?text=UltrasoundLifting',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(115,13,'Vampire Facial','Chăm sóc da bằng huyết thanh tự thân',6000000.00,90,30,'https://placehold.co/300x200/DC143C/333333?text=VampireFacial',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(116,13,'Gold Facial Treatment','Liệu pháp vàng 24k chống lão hóa',2500000.00,75,20,'https://placehold.co/300x200/FFD700/333333?text=GoldFacial',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(117,14,'Full Body Detox Program','Chương trình thải độc toàn diện',1800000.00,120,30,'https://placehold.co/300x200/98FB98/333333?text=FullDetox',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(118,14,'Colon Hydrotherapy','Thủy trị liệu ruột già',1200000.00,60,30,'https://placehold.co/300x200/40E0D0/333333?text=ColonHydrotherapy',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(119,14,'Lymphatic Detox Massage','Massage thải độc hệ bạch huyết',800000.00,75,15,'https://placehold.co/300x200/20B2AA/333333?text=LymphaticDetox',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(120,14,'Infrared Sauna Detox','Xông hơi hồng ngoại thải độc',600000.00,45,15,'https://placehold.co/300x200/FF6347/333333?text=InfraredDetox',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(121,14,'Green Tea Detox Wrap','Đắp trà xanh thải độc toàn thân',700000.00,90,20,'https://placehold.co/300x200/9ACD32/333333?text=GreenTeaWrap',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(122,14,'Ionic Foot Detox','Thải độc qua bàn chân bằng ion',500000.00,45,15,'https://placehold.co/300x200/87CEEB/333333?text=IonicFootDetox',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(123,14,'Juice Cleanse Program','Chương trình thanh lọc bằng nước ép',900000.00,60,15,'https://placehold.co/300x200/32CD32/333333?text=JuiceCleanse',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(124,14,'Clay Detox Facial','Chăm sóc mặt thải độc bằng đất sét',650000.00,75,15,'https://placehold.co/300x200/8FBC8F/333333?text=ClayDetoxFacial',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(125,14,'Oxygen Detox Treatment','Liệu pháp oxy thải độc',850000.00,60,15,'https://placehold.co/300x200/F0F8FF/333333?text=OxygenDetox',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(126,14,'Herbal Steam Detox','Xông hơi thảo dược thải độc',400000.00,40,15,'https://placehold.co/300x200/ADFF2F/333333?text=HerbalSteamDetox',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(127,15,'Deep Tissue Massage','Massage mô sâu điều trị đau cơ',700000.00,75,15,'https://placehold.co/300x200/B0E0E6/333333?text=DeepTissue',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(128,15,'Sports Massage Therapy','Massage thể thao phục hồi cơ bắp',650000.00,60,15,'https://placehold.co/300x200/4682B4/333333?text=SportsMassage',1,0.00,1,0,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(129,15,'Trigger Point Therapy','Điều trị các điểm kích hoạt đau',600000.00,60,15,'https://placehold.co/300x200/5F9EA0/333333?text=TriggerPoint',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(130,15,'Myofascial Release','Giải phóng cân mạc cơ',750000.00,75,20,'https://placehold.co/300x200/708090/333333?text=MyofascialRelease',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(131,15,'Craniosacral Therapy','Liệu pháp cột sống cổ',800000.00,60,20,'https://placehold.co/300x200/778899/333333?text=CraniosacralTherapy',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(132,15,'Orthopedic Massage','Massage chỉnh hình',900000.00,90,20,'https://placehold.co/300x200/2F4F4F/333333?text=OrthopedicMassage',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(133,15,'Prenatal Massage','Massage cho phụ nữ mang thai',550000.00,60,15,'https://placehold.co/300x200/FFB6C1/333333?text=PrenatalMassage',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(134,15,'Geriatric Massage','Massage cho người cao tuổi',500000.00,45,15,'https://placehold.co/300x200/D3D3D3/333333?text=GeriatricMassage',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(135,15,'Scar Tissue Massage','Massage điều trị scar tích',650000.00,60,20,'https://placehold.co/300x200/A9A9A9/333333?text=ScarTissueMassage',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57'),(136,15,'Neuromuscular Therapy','Liệu pháp thần kinh cơ',850000.00,75,20,'https://placehold.co/300x200/696969/333333?text=NeuroMuscularTherapy',1,0.00,1,1,'2025-06-17 16:05:57','2025-06-17 16:05:57');
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shopping_carts`
--

DROP TABLE IF EXISTS `shopping_carts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shopping_carts` (
  `cart_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int DEFAULT NULL COMMENT 'Liên kết với khách hàng nếu đã đăng nhập/xác định',
  `session_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Dùng cho khách vãng lai chưa đăng nhập',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` enum('ACTIVE','ABANDONED','CONVERTED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'ACTIVE' COMMENT 'CONVERTED khi các mục đã được chuyển thành lịch hẹn/yêu cầu',
  PRIMARY KEY (`cart_id`),
  UNIQUE KEY `uq_customer_active_cart` (`customer_id`,`status`),
  KEY `idx_cart_session_id` (`session_id`),
  CONSTRAINT `shopping_carts_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shopping_carts`
--

LOCK TABLES `shopping_carts` WRITE;
/*!40000 ALTER TABLE `shopping_carts` DISABLE KEYS */;
INSERT INTO `shopping_carts` VALUES (1,1,NULL,'2025-06-01 09:40:23','2025-06-01 09:40:23','ACTIVE'),(2,NULL,'sess_abc123xyz789','2025-06-01 09:40:23','2025-06-01 09:40:23','ACTIVE'),(3,2,NULL,'2025-05-30 09:40:23','2025-05-30 09:40:23','ABANDONED');
/*!40000 ALTER TABLE `shopping_carts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spa_information`
--

DROP TABLE IF EXISTS `spa_information`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `spa_information` (
  `spa_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên Spa',
  `address_line1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Địa chỉ dòng 1',
  `address_line2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Địa chỉ dòng 2',
  `city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Thành phố',
  `postal_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Mã bưu điện',
  `country` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Quốc gia',
  `phone_number_main` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Số điện thoại chính',
  `phone_number_secondary` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Số điện thoại phụ',
  `email_main` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Email liên hệ chính',
  `email_secondary` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Email phụ',
  `website_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Địa chỉ website',
  `logo_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL của logo',
  `tax_identification_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Mã số thuế',
  `cancellation_policy` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Chính sách hủy lịch hẹn',
  `booking_terms` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Điều khoản đặt lịch',
  `about_us_short` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Mô tả ngắn về spa',
  `about_us_long` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Mô tả chi tiết về spa',
  `vat_percentage` decimal(5,2) DEFAULT '0.00' COMMENT 'Phần trăm thuế VAT nếu có',
  `default_appointment_buffer_minutes` int DEFAULT '15' COMMENT 'Thời gian đệm mặc định giữa các lịch hẹn',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`spa_id`),
  UNIQUE KEY `uq_spa_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spa_information`
--

LOCK TABLES `spa_information` WRITE;
/*!40000 ALTER TABLE `spa_information` DISABLE KEYS */;
INSERT INTO `spa_information` VALUES (1,'BeautyZone','Số 10 Đường An Bình','Phường Yên Hòa','Hà Nội','100000','Việt Nam','02412345678','0912345678','contact@annhienspa.vn','support@annhienspa.vn','https://annhienspa.vn','https://placehold.co/200x100/E6F2FF/333333?text=AnNhienLogo','0123456789','Vui lòng hủy lịch trước 24 giờ để tránh phí hủy. Chi tiết xem tại website.','Điều khoản đặt lịch chi tiết có tại quầy lễ tân và website của spa.','Nơi bạn tìm thấy sự thư giãn và tái tạo năng lượng.','An nhiên Spa cung cấp các dịch vụ chăm sóc sức khỏe và sắc đẹp hàng đầu với đội ngũ chuyên nghiệp và không gian yên tĩnh.',8.00,15,'2025-06-01 09:40:23','2025-06-04 15:18:58');
/*!40000 ALTER TABLE `spa_information` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `therapist_assignments`
--

DROP TABLE IF EXISTS `therapist_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `therapist_assignments` (
  `assignment_id` int NOT NULL AUTO_INCREMENT,
  `therapist_user_id` int NOT NULL COMMENT 'FK to therapists.user_id',
  `service_id` int NOT NULL COMMENT 'FK to services.service_id',
  `booking_group_id` int NOT NULL COMMENT 'FK to booking_groups.booking_group_id',
  `assignment_date` date NOT NULL COMMENT 'Date when service will be performed',
  `start_time` time NOT NULL COMMENT 'Start time for this service',
  `end_time` time NOT NULL COMMENT 'End time for this service',
  `assignment_status` enum('SCHEDULED','IN_PROGRESS','COMPLETED','CANCELLED','NO_SHOW') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'SCHEDULED',
  `workload_balance_score` decimal(5,2) DEFAULT '0.00' COMMENT 'Work balancer score for this assignment (0.00-100.00)',
  `estimated_duration_minutes` int NOT NULL COMMENT 'Expected duration from service duration',
  `actual_duration_minutes` int DEFAULT NULL COMMENT 'Actual time taken, filled after completion',
  `buffer_time_minutes` int DEFAULT '10' COMMENT 'Buffer time after this service',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Special instructions or notes',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`assignment_id`),
  UNIQUE KEY `uq_therapist_datetime` (`therapist_user_id`,`assignment_date`,`start_time`),
  KEY `idx_therapist_date_time` (`therapist_user_id`,`assignment_date`,`start_time`),
  KEY `idx_booking_group` (`booking_group_id`),
  KEY `idx_service` (`service_id`),
  KEY `idx_date_time_range` (`assignment_date`,`start_time`,`end_time`),
  KEY `idx_workload_balance` (`workload_balance_score`),
  CONSTRAINT `fk_assignment_booking_group` FOREIGN KEY (`booking_group_id`) REFERENCES `booking_groups` (`booking_group_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_assignment_service` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_assignment_therapist` FOREIGN KEY (`therapist_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `therapist_assignments`
--

LOCK TABLES `therapist_assignments` WRITE;
/*!40000 ALTER TABLE `therapist_assignments` DISABLE KEYS */;
/*!40000 ALTER TABLE `therapist_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `therapists`
--

DROP TABLE IF EXISTS `therapists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `therapists` (
  `user_id` int NOT NULL COMMENT 'Liên kết với Users.user_id',
  `service_type_id` int DEFAULT NULL COMMENT 'Loại dịch vụ chính mà kỹ thuật viên chuyên trách',
  `bio` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Tiểu sử ngắn',
  `availability_status` enum('AVAILABLE','BUSY','OFFLINE','ON_LEAVE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'AVAILABLE' COMMENT 'Trạng thái tổng quan, không phải lịch chi tiết',
  `years_of_experience` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `average_rating` decimal(3,2) NOT NULL DEFAULT '0.00' COMMENT 'Computed average rating from service_reviews, updated by triggers.',
  PRIMARY KEY (`user_id`),
  KEY `service_type_id` (`service_type_id`),
  CONSTRAINT `therapists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `therapists_ibfk_2` FOREIGN KEY (`service_type_id`) REFERENCES `service_types` (`service_type_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `therapists`
--

LOCK TABLES `therapists` WRITE;
/*!40000 ALTER TABLE `therapists` DISABLE KEYS */;
INSERT INTO `therapists` VALUES (3,1,'Chuyên gia massage trị liệu với 5 năm kinh nghiệm. Am hiểu các kỹ thuật massage Thụy Điển và đá nóng.','AVAILABLE',5,'2025-06-01 09:40:23','2025-06-18 09:04:30',4.50),(4,2,'Kỹ thuật viên chăm sóc da mặt, đặc biệt có kinh nghiệm trong điều trị mụn và trẻ hóa da.','AVAILABLE',3,'2025-06-01 09:40:23','2025-06-18 09:04:30',4.50),(12,1,'Chuyên gia massage Thái và bấm huyệt.','AVAILABLE',4,'2025-06-18 01:49:35','2025-06-18 09:04:30',5.00),(13,2,'Chuyên về các liệu trình trẻ hóa da và trị nám.','AVAILABLE',3,'2025-06-18 01:49:35','2025-06-18 09:04:30',4.00),(14,3,'Kinh nghiệm lâu năm về ủ dưỡng thể và tắm trắng.','AVAILABLE',5,'2025-06-18 01:49:35','2025-06-18 01:49:35',0.00),(15,4,'Bàn tay vàng trong làng gội đầu thư giãn.','AVAILABLE',2,'2025-06-18 01:49:35','2025-06-18 01:49:35',0.00),(16,1,'Chuyên gia về massage thể thao và phục hồi chấn thương.','AVAILABLE',6,'2025-06-18 01:49:35','2025-06-18 09:04:30',4.00),(17,2,'Có chứng chỉ quốc tế về chăm sóc da chuyên sâu.','AVAILABLE',4,'2025-06-18 01:49:35','2025-06-18 01:49:35',0.00),(18,1,'Kỹ thuật massage đá nóng điêu luyện.','AVAILABLE',2,'2025-06-18 01:49:35','2025-06-18 09:04:30',5.00),(19,4,'Am hiểu về các loại thảo dược gội đầu.','AVAILABLE',3,'2025-06-18 01:49:35','2025-06-18 01:49:35',0.00),(20,3,'Chuyên viên trẻ, nhiệt tình với các liệu pháp tẩy tế bào chết.','ON_LEAVE',1,'2025-06-18 01:49:35','2025-06-18 01:53:45',0.00),(21,2,'Chuyên gia về các liệu pháp chống lão hóa.','ON_LEAVE',5,'2025-06-18 01:49:35','2025-06-18 01:49:35',0.00);
/*!40000 ALTER TABLE `therapists` ENABLE KEYS */;
UNLOCK TABLES;

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
  `actual_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `actual_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `actual_link_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `related_entity_id` int DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `read_at` timestamp NULL DEFAULT NULL,
  `delivery_channel` enum('IN_APP','EMAIL','SMS','PUSH_NOTIFICATION') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_status` enum('PENDING','SENT','DELIVERED','FAILED','VIEWED_IN_APP') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `scheduled_send_at` timestamp NULL DEFAULT NULL,
  `actually_sent_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`sent_notification_id`),
  UNIQUE KEY `uq_user_notification` (`recipient_user_id`,`master_notification_id`,`related_entity_id`,`created_at`),
  KEY `master_notification_id` (`master_notification_id`),
  CONSTRAINT `user_sent_notifications_ibfk_1` FOREIGN KEY (`master_notification_id`) REFERENCES `notifications_master` (`master_notification_id`) ON DELETE CASCADE,
  CONSTRAINT `user_sent_notifications_ibfk_2` FOREIGN KEY (`recipient_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_sent_notifications`
--

LOCK TABLES `user_sent_notifications` WRITE;
/*!40000 ALTER TABLE `user_sent_notifications` DISABLE KEYS */;
INSERT INTO `user_sent_notifications` VALUES (3,3,3,'Lịch hẹn mới: Massage Đá Nóng - Nguyễn Thị Mai','Bạn được chỉ định thực hiện dịch vụ Massage Đá Nóng cho khách hàng Nguyễn Thị Mai (SĐT: 0988111222) vào lúc 14:00:00 ngày 2025-06-05.','/staff/schedule/view/5',5,0,NULL,'IN_APP','VIEWED_IN_APP','2025-06-01 09:40:23','2025-06-01 09:40:23','2025-06-01 09:40:23'),(4,3,4,'Lịch hẹn mới: Chăm Sóc Da Cơ Bản - Trần Văn Nam','Bạn được chỉ định thực hiện dịch vụ Chăm Sóc Da Cơ Bản cho khách hàng Trần Văn Nam (SĐT: 0977333444) vào lúc 10:00:00 ngày 2025-06-03.','/staff/schedule/view/6',6,1,'2025-06-02 02:30:00','EMAIL','SENT','2025-06-02 02:25:00','2025-06-02 02:25:05','2025-06-02 02:25:00');
/*!40000 ALTER TABLE `user_sent_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `role_id` int NOT NULL,
  `full_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `hash_password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Lưu mật khẩu đã được hash',
  `phone_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gender` enum('MALE','FEMALE','OTHER') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `address` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1' COMMENT 'Tài khoản có hoạt động không',
  `last_login_at` timestamp NULL DEFAULT NULL COMMENT 'Thời điểm đăng nhập cuối',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone_number` (`phone_number`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,1,'Nguyễn Văn An','quangkhoa5112@5dulieu.com','$2a$10$Q8m8OY5RIEWeo1alSpOx1up8kZLEz.QDkfiKfyBlbO3GN0ySqwEm.','0912345678','MALE','1980-01-15',NULL,'https://placehold.co/100x100/E6E6FA/333333?text=NVAn',1,'2025-06-01 09:40:23','2025-06-01 09:40:23','2025-06-05 02:51:26'),(2,2,'Trần Thị Bình','manager@spademo.com','$2b$10$abcdefghijklmnopqrstuv','0987654321','FEMALE','1985-05-20',NULL,'https://placehold.co/100x100/FFF0F5/333333?text=TTBinh',1,'2025-06-01 09:40:23','2025-06-01 09:40:23','2025-06-01 09:40:23'),(3,3,'Lê Minh Cường','therapist1@spademo.com','$2b$10$abcdefghijklmnopqrstuv','0905112233','MALE','1990-09-10',NULL,'https://placehold.co/100x100/F0FFF0/333333?text=LMCuong',1,'2025-06-01 09:40:23','2025-06-01 09:40:23','2025-06-01 09:40:23'),(4,3,'Phạm Thị Dung','therapist2@spademo.com','$2b$10$abcdefghijklmnopqrstuv','0905445566','FEMALE','1992-12-01',NULL,'https://placehold.co/100x100/FAFAD2/333333?text=PTDung',1,'2025-06-01 09:40:23','2025-06-01 09:40:23','2025-06-01 09:40:23'),(5,4,'Hoàng Văn Em','receptionist@spademo.com','$2b$10$abcdefghijklmnopqrstuv','0918778899','MALE','1995-03-25',NULL,'https://placehold.co/100x100/ADD8E6/333333?text=HVEm',1,'2025-06-01 09:40:23','2025-06-01 09:40:23','2025-06-01 09:40:23'),(6,1,'Nguyễn Văn Admin','admin@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234567','MALE','1985-01-15',NULL,'/assets/avatars/admin.jpg',1,NULL,'2025-06-04 03:47:10','2025-06-04 03:47:10'),(7,2,'Trần Thị Manager','manager@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234568','FEMALE','1988-03-20',NULL,'/assets/avatars/manager.jpg',1,NULL,'2025-06-04 03:57:48','2025-06-04 03:57:48'),(8,3,'Lê Văn Therapist','therapist@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234569','MALE','1990-07-10',NULL,'/assets/avatars/therapist.jpg',1,NULL,'2025-06-04 03:57:48','2025-06-04 03:57:48'),(9,4,'Phạm Thị Receptionist','receptionist@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234570','FEMALE','1992-11-25',NULL,'/assets/avatars/receptionist.jpg',1,NULL,'2025-06-04 03:57:48','2025-06-04 03:57:48'),(10,1,'Hoàng Minh Quản Trị','admin2@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234571','MALE','1987-05-12',NULL,'/assets/avatars/admin2.jpg',1,NULL,'2025-06-04 03:57:48','2025-06-04 03:57:48'),(11,3,'Nguyễn Thị Spa Master','therapist2@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234572','FEMALE','1989-09-18',NULL,'/assets/avatars/therapist2.jpg',1,NULL,'2025-06-04 03:57:48','2025-06-04 03:57:48'),(12,3,'Mai Anh Tuấn','therapist3@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234573','MALE','1991-04-12',NULL,'/assets/admin/images/avatar/avatar-1.jpg',1,NULL,'2025-06-18 01:49:35','2025-06-18 01:49:35'),(13,3,'Trần Ngọc Bích','therapist4@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234574','FEMALE','1993-08-22',NULL,'/assets/admin/images/avatar/avatar-2.jpg',1,NULL,'2025-06-18 01:49:35','2025-06-18 01:49:35'),(14,3,'Vũ Minh Đức','therapist5@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234575','MALE','1989-11-05',NULL,'/assets/admin/images/avatar/avatar-3.jpg',1,NULL,'2025-06-18 01:49:35','2025-06-18 01:49:35'),(15,3,'Hoàng Thị Thu','therapist6@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234576','FEMALE','1995-02-18',NULL,'/assets/admin/images/avatar/avatar-4.jpg',1,NULL,'2025-06-18 01:49:35','2025-06-18 01:49:35'),(16,3,'Đặng Văn Long','therapist7@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234577','MALE','1988-06-30',NULL,'/assets/admin/images/avatar/avatar-5.jpg',1,NULL,'2025-06-18 01:49:35','2025-06-18 01:49:35'),(17,3,'Ngô Mỹ Linh','therapist8@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234578','FEMALE','1992-07-21',NULL,'/assets/admin/images/avatar/avatar-6.jpg',1,NULL,'2025-06-18 01:49:35','2025-06-18 01:49:35'),(18,3,'Bùi Quang Huy','therapist9@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234579','MALE','1996-01-09',NULL,'/assets/admin/images/avatar/avatar-7.jpg',1,NULL,'2025-06-18 01:49:35','2025-06-18 01:49:35'),(19,3,'Đỗ Phương Thảo','therapist10@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234580','FEMALE','1994-03-14',NULL,'/assets/admin/images/avatar/avatar-8.jpg',1,NULL,'2025-06-18 01:49:35','2025-06-18 01:49:35'),(20,3,'Lương Thế Vinh','therapist11@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234581','MALE','1998-10-25',NULL,'/assets/admin/images/avatar/avatar-9.jpg',1,NULL,'2025-06-18 01:49:35','2025-06-18 01:49:35'),(21,3,'Phan Thị Diễm','therapist12@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234582','FEMALE','1990-12-03',NULL,'/assets/admin/images/avatar/avatar-10.jpg',1,NULL,'2025-06-18 01:49:35','2025-06-18 01:49:35');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-24 12:13:25
