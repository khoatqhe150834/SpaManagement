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
-- Table structure for table `beds`
--

DROP TABLE IF EXISTS `beds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `beds` (
  `bed_id` int NOT NULL AUTO_INCREMENT,
  `room_id` int NOT NULL COMMENT 'Links to rooms.room_id to indicate which room this bed belongs to',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Bed identifier (e.g., Bed 1, VIP Bed)',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Description of the bed (e.g., type, features)',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 if bed is available for use, 0 if under maintenance or unavailable',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`bed_id`),
  KEY `idx_room_id` (`room_id`),
  CONSTRAINT `beds_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Stores information about beds within rooms for spa services';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `beds`
--

LOCK TABLES `beds` WRITE;
/*!40000 ALTER TABLE `beds` DISABLE KEYS */;
INSERT INTO `beds` VALUES (1,1,'Bed 1','Standard massage table',1,'2025-07-17 16:22:20','2025-07-17 16:22:20'),(2,2,'VIP Bed 1','Luxury bed for couples massage',1,'2025-07-17 16:22:20','2025-07-17 16:22:20'),(3,2,'VIP Bed 2','Luxury bed for couples massage',1,'2025-07-17 16:22:20','2025-07-17 16:22:20'),(4,3,'Bed 1','Reclining bed for facial treatments',1,'2025-07-17 16:22:20','2025-07-17 16:22:20');
/*!40000 ALTER TABLE `beds` ENABLE KEYS */;
UNLOCK TABLES;

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
INSERT INTO `blog_categories` VALUES (1,4),(2,4),(7,4),(8,4),(9,4),(10,4),(12,4),(14,4),(15,4),(16,4),(17,4),(3,5),(4,5),(5,5),(6,5),(11,5),(13,5);
/*!40000 ALTER TABLE `blog_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blog_comments`
--

DROP TABLE IF EXISTS `blog_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blog_comments` (
  `comment_id` int NOT NULL AUTO_INCREMENT,
  `blog_id` int NOT NULL,
  `customer_id` int DEFAULT NULL,
  `guest_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `guest_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comment_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('APPROVED','REJECTED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'APPROVED',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`comment_id`),
  KEY `idx_blog_id` (`blog_id`),
  KEY `idx_customer_id` (`customer_id`),
  CONSTRAINT `fk_blogcomments_blog` FOREIGN KEY (`blog_id`) REFERENCES `blogs` (`blog_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_blogcomments_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blog_comments`
--

LOCK TABLES `blog_comments` WRITE;
/*!40000 ALTER TABLE `blog_comments` DISABLE KEYS */;
INSERT INTO `blog_comments` VALUES (1,4,1,NULL,NULL,'Bài viết quá chi tiết, cảm ơn BeautyZone!','APPROVED','2025-06-02 12:00:00','2025-06-02 12:00:00'),(2,4,2,NULL,NULL,'Đúng vậy, mình đã thử và móng khỏe hơn hẳn.','APPROVED','2025-06-02 12:10:00','2025-06-02 12:10:00'),(3,5,NULL,'Lan Anh','lananh@example.com','Yoga buổi sáng giúp mình tỉnh táo cả ngày!','APPROVED','2025-06-02 12:20:00','2025-06-02 12:20:00'),(4,5,NULL,'Minh','minh@gmail.com','Bạn tập theo video của bài hay riêng PT?','APPROVED','2025-06-02 12:25:00','2025-06-02 12:25:00'),(5,6,3,NULL,NULL,'Mình thích uống trà gừng, thảo mộc số 2 cũng rất tốt!','APPROVED','2025-06-02 12:30:00','2025-06-02 12:30:00'),(6,7,2,NULL,NULL,'Video hướng dẫn dễ hiểu, cảm ơn spa.','APPROVED','2025-06-02 12:35:00','2025-06-02 12:35:00'),(7,7,NULL,'Hạnh','hanh@yahoo.com','Mình làm xong thấy cổ nhẹ hẳn!','APPROVED','2025-06-02 12:40:00','2025-06-02 12:40:00'),(8,8,4,NULL,NULL,'10 thói quen này rất hữu ích, nhất là uống đủ nước.','APPROVED','2025-06-02 12:45:00','2025-06-02 12:45:00'),(9,9,NULL,'Khách Vãng Lai','guest@abc.com','Mong chờ ngày khai trương để nhận ưu đãi!','APPROVED','2025-06-02 12:50:00','2025-06-02 12:50:00'),(10,10,5,NULL,NULL,'Chúc mừng BeautyZone nhận giải thưởng!','APPROVED','2025-06-02 12:55:00','2025-06-02 12:55:00'),(11,12,1,NULL,NULL,'Ưu đãi hấp dẫn quá, đặt lịch ngay thôi.','APPROVED','2025-06-02 13:00:00','2025-06-02 13:00:00'),(12,13,NULL,'Phong','phong@mail.com','Chạy bộ xong được massage chuẩn bài!','APPROVED','2025-06-02 13:05:00','2025-06-02 13:05:00'),(13,14,2,NULL,NULL,'Mặt nạ bột yến mạch cực kỳ dịu nhẹ, mình đã thử.','APPROVED','2025-06-02 13:10:00','2025-06-02 13:10:00'),(14,15,NULL,'Thuỳ Trang','trang@example.com','Tinh dầu lavender thơm dễ ngủ lắm!','APPROVED','2025-06-02 13:15:00','2025-06-02 13:15:00'),(15,15,3,NULL,NULL,'Đồng ý, mình cũng hay dùng mùi này.','APPROVED','2025-06-02 13:18:00','2025-06-02 13:18:00'),(16,16,1,NULL,NULL,'Combo mới giá tốt thật!','APPROVED','2025-06-02 13:20:00','2025-06-02 13:20:00'),(17,17,NULL,'Đức','duc@mail.com','Da mình khô quanh mũi – đúng là thiếu nước!','REJECTED','2025-06-02 13:25:00','2025-06-22 10:13:16'),(19,17,NULL,'Dương','dohoangduong2708@gmail.com','Nội dung thật hữu ích!','REJECTED','2025-06-20 09:23:55','2025-06-22 10:33:51'),(20,16,NULL,'Dương','dohoangduong2708@gmail.com','Giá quá tốt đi!','APPROVED','2025-06-20 09:26:51','2025-06-20 09:26:51'),(21,16,NULL,'Hưng','cgpt8371@gmail.com','wowwwwwwwwwwww\r\n','REJECTED','2025-06-20 09:54:00','2025-06-22 10:34:07'),(23,16,NULL,'Dương','dohoangduong2708@gmail.com','Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay quá!Hay ','REJECTED','2025-06-20 14:45:40','2025-06-22 10:34:09'),(24,16,NULL,'Dương','dohoangduong2708@gmail.com','3','REJECTED','2025-06-20 14:50:54','2025-06-22 10:34:32'),(27,16,NULL,'Anh','manager@beautyzone.com','Nội dung bổ ích quá đi!!!!','APPROVED','2025-06-24 10:52:39','2025-06-24 10:52:39'),(28,13,NULL,'Dương','dohoangduong2708@gmail.com','Nội dung quá hay!!!!','APPROVED','2025-06-24 10:57:29','2025-06-24 10:57:29');
/*!40000 ALTER TABLE `blog_comments` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blogs`
--

LOCK TABLES `blogs` WRITE;
/*!40000 ALTER TABLE `blogs` DISABLE KEYS */;
INSERT INTO `blogs` VALUES (1,2,'5 Lợi Ích Tuyệt Vời Của Massage Thường Xuyên','5-loi-ich-tuyet-voi-cua-massage-thuong-xuyen','Khám phá những lợi ích sức khỏe không ngờ tới từ việc massage định kỳ.','<p>Nội dung chi tiết về 5 lợi ích của massage... (HTML/Markdown)</p>','assets/home/images/blog/1750817522317.jpg','ARCHIVED',NULL,150,'2025-06-01 09:40:23','2025-06-25 02:14:21'),(2,2,'Bí Quyết Sở Hữu Làn Da Căng Bóng Mùa Hè','bi-quyet-so-huu-lan-da-cang-bong-mua-he','Những mẹo chăm sóc da đơn giản mà hiệu quả giúp bạn tự tin tỏa sáng trong mùa hè.','<p>Nội dung chi tiết về bí quyết chăm sóc da mùa hè... (HTML/Markdown)</p>','assets/home/images/blog/1750817583283.jpg','SCHEDULED',NULL,220,'2025-06-01 09:40:23','2025-06-25 02:14:03'),(3,1,'Chương Trình Khuyến Mãi Mới Tại Spa','chuong-trinh-khuyen-mai-moi-tai-spa','Thông báo về các gói ưu đãi hấp dẫn sắp ra mắt.','<p>Nội dung chi tiết về chương trình khuyến mãi... (HTML/Markdown)</p>','assets/home/images/blog/1750817553426.jpg','DRAFT',NULL,0,'2025-06-01 09:40:23','2025-06-25 02:12:33'),(4,2,'Cách Chăm Sóc Móng Tay Tại Nhà','cach-cham-soc-mong-tay-tai-nha','Những mẹo đơn giản tại nhà giúp móng tay chắc khỏe, giảm gãy và tăng độ bóng mượt chỉ sau vài tuần chăm sóc đúng cách.','Móng tay yếu, dễ gãy thường do thiếu dưỡng chất và môi trường tiếp xúc hóa chất. Để có bộ móng khỏe đẹp, hãy bắt đầu bằng việc cắt tỉa gọn gàng và đeo găng tay khi làm việc nhà.\n\nSử dụng **dầu *cuticle*** (dưỡng da quanh móng) để kích thích mọc móng và dưỡng ẩm; đồng thời bổ sung *biotin* từ thực phẩm như trứng, óc chó, hạnh nhân.\n\nCuối cùng, áp dụng “mặt nạ” móng tự nhiên từ dầu dừa + mật ong mỗi tuần để tăng độ bóng và ngăn nứt gãy. Thực hiện 2–3 lần/tuần, bạn sẽ thấy khác biệt rõ rệt chỉ sau 2 tuần.','assets/home/images/blog/default/thum4.jpg','PUBLISHED','2025-06-02 10:00:00',76,'2025-06-02 03:00:00','2025-06-22 14:23:53'),(5,2,'Yoga Buổi Sáng: Khởi Đầu Hoàn Hảo','yoga-buoi-sang','Chuỗi bài tập yoga buổi sáng giúp cơ thể linh hoạt, tâm trí thư thái và năng lượng tràn đầy ngay từ khi thức dậy.','Bắt đầu ngày mới với yoga giúp bạn dẻo dai và kích hoạt hệ thần kinh.\n\n1. **Surya Namaskar** (Chào mặt trời) – Lặp lại 5-8 vòng để đánh thức toàn thân.\n2. **Tree Pose** & **Warrior II** – Rèn sức mạnh chân, cải thiện thăng bằng.\n3. Kết thúc bằng **Child’s Pose** và **Savasana** để thư giãn sâu.\n\nToàn bộ chu trình chỉ 20–30 phút nhưng mang lại năng lượng tích cực suốt cả ngày.','assets/home/images/blog/grid/bridal/pic1.jpg','PUBLISHED','2025-06-02 10:05:00',93,'2025-06-02 03:05:00','2025-06-22 15:02:41'),(6,2,'5 Loại Thảo Mộc Giải Độc Cơ Thể','5-loai-thao-moc-giai-doc-co-the','Khám phá 5 loại thảo mộc tự nhiên hỗ trợ giải độc cơ thể, giảm stress và tăng cường sức đề kháng.','Các thảo mộc thiên nhiên như **atí so**, **nhân trần**, **tầm xuân** chứa dược tính giúp thanh lọc gan, cải thiện tiêu hóa và chống oxy hóa.\n\n### Top 5 thảo mộc\n1. **Atiso** – Giàu *cynarin*, hỗ trợ sản xuất mật.\n2. **Nhân trần** – Thanh nhiệt, lợi tiểu.\n3. **Tầm xuân** – Bổ sung vitamin C.\n4. **Gừng** – Kháng viêm, ấm cơ thể.\n5. **Bạc hà** – Thư giãn, giảm đầy hơi.\n\n**Cách pha trà**: 1 thìa atiso + 1 thìa hoa nhài, hãm 90 ℃ / 10 phút. Uống 1–2 cốc/ngày, kèm chế độ ăn lành mạnh để đạt hiệu quả.','assets/home/images/blog/grid/bridal/pic2.jpg','PUBLISHED','2025-06-02 10:10:00',64,'2025-06-02 03:10:00','2025-06-22 14:23:53'),(7,3,'Hướng Dẫn Massage Cổ – Vai – Gáy Tại Nhà','huong-dan-massage-co-vai-gay','Hướng dẫn chi tiết kỹ thuật massage cổ – vai – gáy tại nhà giúp giảm đau mỏi, cải thiện tuần hoàn và thư giãn tối đa.','Đau mỏi cổ-vai-gáy thường xuất hiện khi ngồi lâu trước máy tính.\n\n**Bước 1:** Chườm ấm 5 phút.\n\n**Bước 2:** Dùng đầu ngón tay ấn vòng tròn ở huyệt *phong trì*, *hợp cốc*.\n\n**Bước 3:** Kéo dọc cơ cổ, lắc nhẹ vai (10-15 lần). Kết thúc bằng việc ấn huyệt *bách hội*.\n\nThực hiện hằng ngày để giảm đau mỏi và cải thiện tuần hoàn.','assets/home/images/blog/grid/bridal/pic3.jpg','PUBLISHED','2025-06-02 10:15:00',111,'2025-06-02 03:15:00','2025-06-22 15:02:35'),(8,3,'10 Thói Quen Đẹp Cho Làn Da Căng Mịn','10-thoi-quen-dep-cho-lan-da','10 thói quen dưỡng da đơn giản mỗi ngày giúp bạn duy trì làn da sáng mịn, đầy sức sống.','Muốn có làn da rạng rỡ, hãy duy trì 10 thói quen “vàng”:\n\n1. Uống **2-2,5 L** nước mỗi ngày.\n2. Ngủ đủ **7-8 giờ**.\n3. Rửa mặt **2 lần/ngày**.\n4. ... _(xem chi tiết từng thói quen và sản phẩm gợi ý trong bài)_\n\nKiên trì 4 tuần, bạn sẽ cảm nhận làn da căng mịn, đầy sức sống.','assets/home/images/blog/grid/bridal/pic4.jpg','PUBLISHED','2025-06-02 10:20:00',132,'2025-06-02 03:20:00','2025-06-22 15:53:21'),(9,6,'Khai Trương Cơ Sở Mới Tại Quận 2','khai-truong-co-so-moi-quan-2','BeautyZone chính thức khai trương cơ sở thứ 3 tại Quận 2 – không gian sang trọng, dịch vụ đa dạng và ưu đãi hấp dẫn.','BeautyZone hân hạnh khai trương cơ sở mới tại **123 Nguyễn Ư Dĩ, Quận 2**.\n\n- Không gian hiện đại, 15+ liệu trình chuyên sâu.\n- Ưu đãi **-30 %** tất cả dịch vụ (05-10 / 07).\n\nLiên hệ **028-1234-5678** hoặc website BeautyZone.vn để đặt chỗ ngay.','assets/home/images/blog/grid/hair/pic1.jpg','PUBLISHED','2025-06-02 10:25:00',57,'2025-06-02 03:25:00','2025-06-22 15:02:20'),(10,6,'BeautyZone Đạt Giải Thưởng Chất Lượng 2025','spa-beautyzone-dat-giai-thuong-2025','Vinh danh BeautyZone tại Spa Awards 2025 – giải thưởng uy tín quốc tế khẳng định chất lượng dịch vụ hàng đầu.','<p><span class=\"ql-font-serif\">Tại lễ **Spa Awards 2025** (Bangkok), BeautyZone đã giành giải “**Spa Chất Lượng Việt Nam**”.\r\n\r\nGiải thưởng ghi nhận:\r\n- Quy trình chăm sóc da toàn diện.\r\n- Đội ngũ kỹ thuật viên chuyên nghiệp.\r\n- Trải nghiệm khách hàng luôn đổi mới.\r\n\r\nChúng tôi trân trọng cảm ơn sự tin yêu của quý khách!</span></p>','assets/home/images/blog/grid/hair/pic2.jpg','PUBLISHED','2025-06-02 10:30:00',41,'2025-06-02 03:30:00','2025-06-23 17:43:00'),(11,6,'Lịch Làm Việc Tết Dương Lịch 2026','lich-lam-viec-tet-duong-lich-2026','Tặng 1 hoa hồng Ecuador và phiếu giảm 20 % cho phái đẹp khi sử dụng bất kỳ gói dịch vụ nào từ 01 – 08 / 03.','<p>Ngày 08-03, BeautyZone ra mắt gói quà **“Queen for a Day”**:\r\n\r\n- Massage Aroma toàn thân 60’\r\n- Chăm sóc da mặt cấp ẩm 45’\r\n- Trà hoa cúc mật ong &amp; bánh mousse dâu\r\n\r\nGiá ưu đãi **1 090 000 đ** _(tiết kiệm 400 000 đ)_. Đặt trước 3 ngày để chọn khung giờ mong muốn.</p>','assets/home/images/blog/grid/hair/pic3.jpg','PUBLISHED','2025-06-23 23:34:29',33,'2025-06-02 03:35:00','2025-07-03 05:21:10'),(12,2,'Ưu Đãi Thành Viên Vàng Tháng 7','uu-dai-thanh-vien-vang-thang-7','Chương trình ưu đãi vàng dành riêng cho hội viên Gold – giảm giá đến 40% và điểm thưởng gấp đôi.','Tháng 7, chủ thẻ **Gold** nhận ngay:\n\n- Giảm **40 %** cho mọi liệu trình *massage*.\n- Nhân **đôi điểm tích lũy**.\n\nĐiểm thưởng đổi thành voucher 100 000 đ cho lần sử dụng tiếp theo. Đăng ký trước 30 / 07 để không bỏ lỡ!','assets/home/images/blog/grid/hair/pic4.jpg','PUBLISHED','2025-06-02 10:40:00',41,'2025-06-02 03:40:00','2025-06-25 02:04:08'),(13,3,'Chạy Bộ Và Massage – Bộ Đôi Hoàn Hảo','chay-bo-va-massage-bo-doi-hoan-hao','Kết hợp chạy bộ và massage giúp phục hồi cơ bắp nhanh chóng, giảm đau mỏi và tăng hiệu suất luyện tập.','<p>Chạy bộ cường độ cao dễ gây đau mỏi cơ. Massage sau khi chạy:\r\n\r\n- Kích thích lưu thông máu.\r\n- Giảm acid lactic, ngăn chuột rút.\r\n\r\nChu trình khuyến nghị: *foam roller* 5’, day ấn huyệt 10’, thoa tinh dầu giảm viêm. Áp dụng **2-3 lần/tuần**, hiệu quả phục hồi tăng rõ rệt.</p>','assets/home/images/blog/recent-blog/pic1.jpg','PUBLISHED','2025-06-02 10:45:00',62,'2025-06-02 03:45:00','2025-06-24 11:00:39'),(14,3,'3 Công Thức Mặt Nạ Cho Da Dầu','3-cong-thuc-mat-na-da-dau','3 công thức mặt nạ thiên nhiên cho da dầu giúp kiểm soát nhờn, se khít lỗ chân lông và ngăn ngừa mụn hiệu quả.','Da dầu cần được “giải cứu” khỏi bã nhờn:\n\n### Công thức 1 – Yến mạch & Mật ong\nTrộn 1 muỗng yến mạch mịn + 1 muỗng mật ong, đắp 15’ rồi rửa.\n\n### Công thức 2 – Trà xanh & Sữa chua\nTương tự, thay mật ong bằng 2 muỗng sữa chua không đường.\n\n### Công thức 3 – Đất sét khoáng & Nước chanh\nTỷ lệ 2:1, đắp 10’.\n\nThực hiện 1-2 lần/tuần, rửa lại bằng nước mát và luôn dưỡng ẩm sau đó.','assets/home/images/blog/recent-blog/pic2.jpg','PUBLISHED','2025-06-02 10:50:00',87,'2025-06-02 03:50:00','2025-06-26 04:25:26'),(15,2,'Thư Giãn Với Hương Aroma Trong Không Gian Sống','thu-gian-voi-huong-aroma','Hương thơm tinh dầu lavender mang đến không gian thư giãn, giảm căng thẳng và hỗ trợ giấc ngủ chất lượng.','Tinh dầu **lavender** giúp xoa dịu thần kinh, cải thiện giấc ngủ.\n\n- Đèn xông: 5-7 giọt / 100 mL nước.\n- Xịt phòng: 10 giọt lavender + 50 mL nước cất + 1 muỗng cồn thực phẩm.\n- Massage: 3-5 giọt lavender + 10 mL dầu nền.\n\nĐiều chỉnh nồng độ cho phù hợp để tận hưởng không gian thư giãn trọn vẹn.','assets/home/images/blog/recent-blog/pic3.jpg','PUBLISHED','2025-06-02 10:55:00',47,'2025-06-02 03:55:00','2025-06-23 19:25:53'),(16,6,'Giới Thiệu Combo Chăm Sóc Toàn Thân Mới','combo-cham-soc-toan-than-moi','Combo “Toàn Thân Thư Giãn” – gói trọn vẹn chăm sóc cơ thể, từ massage đá nóng đến tẩy tế bào chết toàn thân, với giá ưu đãi chỉ 999.000đ.','**Combo “Toàn Thân Thư Giãn”** _(chỉ 999 000 đ – đến 31 / 07)_\n\n- 60’ Massage **đá nóng**\n- 30’ **Tẩy tế bào chết** toàn thân\n- 15’ **Đắp mặt nạ** dưỡng ẩm\n\nTổng 1 h 45’. Đặt ngay để giữ chỗ và nhận thêm quà tặng bất ngờ!','assets/home/images/blog/grid/hair/pic1.jpg','PUBLISHED','2025-06-02 11:00:00',35,'2025-06-02 04:00:00','2025-06-25 02:04:13'),(17,3,'5 Dấu Hiệu Da Đang Thiếu Nước','5-dau-hieu-da-thieu-nuoc','5 dấu hiệu cảnh báo da đang thiếu nước, kèm gợi ý cách chăm sóc ngay tại nhà để cấp ẩm kịp thời.','### 5 dấu hiệu da thiếu nước\n1. Nếp nhăn li ti xuất hiện nhanh.\n2. Vùng mũi/ má bong tróc.\n3. Lỗ chân lông to.\n4. Da sạm xỉn màu.\n5. Căng rát sau bước rửa mặt.\n\n**Giải pháp 7 ngày:** Xịt khoáng, serum H.A, kem dưỡng chứa ceramides và uống đủ 2 L nước mỗi ngày.','assets/home/images/blog/grid/bridal/pic2.jpg','PUBLISHED','2025-06-02 11:05:00',80,'2025-06-02 04:05:00','2025-06-24 10:50:28');
/*!40000 ALTER TABLE `blogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `payment_item_id` int NOT NULL,
  `service_id` int NOT NULL,
  `therapist_user_id` int NOT NULL,
  `appointment_date` date NOT NULL,
  `appointment_time` time NOT NULL,
  `duration_minutes` int NOT NULL,
  `booking_status` enum('SCHEDULED','CONFIRMED','IN_PROGRESS','COMPLETED','CANCELLED','NO_SHOW') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SCHEDULED',
  `booking_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `cancellation_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `cancelled_at` timestamp NULL DEFAULT NULL,
  `cancelled_by` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `room_id` int NOT NULL COMMENT 'Links to rooms.room_id for the assigned room',
  `bed_id` int DEFAULT NULL COMMENT 'Links to beds.bed_id for the assigned bed, nullable if not applicable',
  PRIMARY KEY (`booking_id`),
  KEY `service_id` (`service_id`),
  KEY `cancelled_by` (`cancelled_by`),
  KEY `idx_customer_bookings` (`customer_id`,`appointment_date`),
  KEY `idx_therapist_schedule` (`therapist_user_id`,`appointment_date`,`appointment_time`),
  KEY `idx_appointment_datetime` (`appointment_date`,`appointment_time`),
  KEY `idx_booking_status` (`booking_status`),
  KEY `idx_payment_item_booking` (`payment_item_id`),
  KEY `idx_room_id` (`room_id`),
  KEY `idx_bed_id` (`bed_id`),
  CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`payment_item_id`) REFERENCES `payment_items` (`payment_item_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `bookings_ibfk_3` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `bookings_ibfk_4` FOREIGN KEY (`therapist_user_id`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `bookings_ibfk_5` FOREIGN KEY (`cancelled_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `bookings_ibfk_6` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `bookings_ibfk_7` FOREIGN KEY (`bed_id`) REFERENCES `beds` (`bed_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_appointment_date` CHECK ((`appointment_date` >= _utf8mb4'2000-01-01')),
  CONSTRAINT `chk_appointment_time` CHECK (((`appointment_time` >= _utf8mb3'00:00:00') and (`appointment_time` <= _utf8mb3'23:59:59')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
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
-- Table structure for table `customer_appointment_notifications`
--

DROP TABLE IF EXISTS `customer_appointment_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_appointment_notifications`
--

LOCK TABLES `customer_appointment_notifications` WRITE;
/*!40000 ALTER TABLE `customer_appointment_notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_appointment_notifications` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'Nguyễn Thị Mai','mai.nguyen@email.com','0988111222','$10$lyJgp/pjXtmmrRz1.ec29Osep5i8YluhNCFWj.8ckoU5qUHhQCaeG',1,'MALE','1990-07-15','123 Đường Hoa, Quận 1, TP. HCM',250,'Khách hàng VIP, thích trà gừng.',5,'2025-06-01 09:40:23','2025-07-21 19:33:17','',1),(2,'Trần Văn Nam','nam.tran@email.com','0977333444','$2b$10$abcdefghijklmnopqrstu',1,'MALE','1988-02-20','456 Đường Cây, Quận 3, TP. HCM',60,'Thường đặt dịch vụ massage chân.',5,'2025-06-01 09:40:23','2025-07-19 19:56:46','https://placehold.co/100x100/B0E0E6/333333?text=TVNam',1),(3,'Lê Thị Lan','lan.le@email.com','0966555666','$2b$10$abcdefghijklmnopqrstu',1,'FEMALE','1995-11-30','789 Đường Lá, Quận Bình Thạnh, TP. HCM',200,'Hay đi cùng bạn bè.',5,'2025-06-01 09:40:23','2025-07-19 19:56:46','https://placehold.co/100x100/98FB98/333333?text=LTLan',1),(4,'Phạm Văn Hùng','hung.pham@email.com','0955777888','$2b$10$abcdefghijklmnopqrstu',1,'MALE','1985-01-01','101 Đường Sông, Quận 2, TP. HCM',10,'Tài khoản không hoạt động.',5,'2025-06-01 09:40:23','2025-07-21 00:59:48','https://placehold.co/100x100/D3D3D3/333333?text=PVHung',1),(5,'Võ Thị Kim Chi','kimchi.vo@email.com','0944999000','$2b$10$abcdefghijklmnopqrstu',1,'FEMALE','2000-10-10','202 Đường Núi, Quận 7, TP. HCM',50,NULL,5,'2025-06-01 09:40:23','2025-07-19 19:56:46','https://placehold.co/100x100/FFE4E1/333333?text=VTKChi',1),(6,'Khách Vãng Lai A',NULL,'0912345001',NULL,1,'UNKNOWN',NULL,NULL,0,'Khách đặt qua điện thoại',NULL,'2025-06-01 09:40:23','2025-07-19 19:56:46',NULL,1),(7,'Clementine Shields','qaxyb@mailinator.com','0075252946','$2a$10$Mg7a1qbG3Wpt5/LL1hJXdORgyMD8WFuuFS49lZKuEpf33xp6wDM0G',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-01 09:44:15','2025-07-19 19:56:46',NULL,1),(8,'Preston Reeves','wogelyvi@mailinator.com','0621707951','$2a$10$LfSiDBEkpBQh9uWhQwnW1.iG3TrMf3w0ucvWyw9GisHH.LNU63Oyy',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-02 02:37:54','2025-07-19 19:56:46',NULL,1),(9,'Hector Gill','qepem@mailinator.com','0488215435','$2a$10$.GhDdGMtOZGoZsZlikXXA..J3OjZ4ka4t8iEEGEWQhRg5HXi9yESi',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-02 02:40:08','2025-07-19 19:56:46',NULL,1),(10,'John Walters','hybux@mailinator.com','0764611157','$2a$10$FIUJAcV5Tp4IGs9CD8jr5ePKbM28eoPYtMxj2egfVCtU/W8wnFQX2',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-02 02:44:44','2025-07-19 19:56:46',NULL,1),(11,'Gregory Jacobs','fetoryby@mailinator.com','0868681648','$2a$10$kZUd1FfHe9.C/KOzKJZcxOL.uShM946L30qhvxDyRp39Ga0IlKj..',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-02 02:47:15','2025-07-21 19:18:46',NULL,1),(12,'Taylor Gross','jygemi@mailinator.com','0370784956','$2a$10$xfj9S0w1KsRoYkxlCK7wveQVequmL7r6bN5KifZG6m5TUO89zWata',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-02 02:49:28','2025-07-21 19:18:46',NULL,1),(14,'Kameko Leach','vadyrud@mailinator.com','0575726427','$2a$10$Ry4BL4CuoaI7Djki6.jD0eawqu/iEUt1aG/uHBqFO.yBuuiNb/Eiq',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-05 02:53:25','2025-07-21 19:18:46',NULL,1),(15,'Geoffrey White','hudyq@mailinator.com','0838898566','$2a$10$I7NizmxcWCvvsCUQGGoFqOdtwNAWE3oaFJuakQXtCsU9/rGtI1qkq',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-05 05:26:40','2025-07-21 19:18:46',NULL,1),(16,'Denton Holder','quangkhoa51123@gmail.com','0367449306','$2a$10$aUaZEiTGhy28V9UQF/Rj0O.MuR08s.ohvt6lflBvZA1bVxRi.H6eC',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-06 15:07:09','2025-07-21 19:18:46',NULL,1),(17,'Thieu Quang Khoa','begig@mailinator.com','0770634550','$2a$10$vEkr7YHufIaNKugswSNrwekQdXqrVjhGR4nnM6qhLBK1V9UCuy9di',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-06 15:07:35','2025-07-21 19:18:46',NULL,1),(18,'Eleanor Tran','sopehoxyq@mailinator.com','0863647205','$2a$10$1i8Jd7VQrkQk/vP/UU4A3eCfkEHF2lloVQISSj0tftLyvGruTnTBu',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-06 15:27:31','2025-07-21 19:18:46',NULL,1),(19,'Bert Keller','gimibokuk@mailinator.com','0315448491','$2a$10$ZKeSAojzxiFnpDVz6eiG1etPVrRM9vO56mjHhebgvMafG1opIeasK',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-06 15:29:58','2025-07-21 19:18:46',NULL,1),(20,'Ian Schwartz','kuwidozata@mailinator.com','0981727583','$2a$10$OiABUyWOj5psL9dnXsfOsOgFIu5tb7Si/oJwlUFsmBV5T11gbAHl2',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-06 15:36:55','2025-07-21 19:18:46',NULL,1),(21,'Ian Bradshaw','hyjoz@mailinator.com','0994918210','$2a$10$k5F5H8URCFl8J.DE8XRUT.sm7jVcIBbzFhgYwy4aDbuDf80YIZIsy',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-06 15:47:51','2025-07-21 19:18:46',NULL,1),(22,'Alea Compton','xapymabo@mailinator.com','0526799608','$2a$10$bqPlpJK5LWK0kKJ6LyMzlOuHepBWUuSIpQn7eJGR8hsRuNMszQRx6',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-06 16:41:35','2025-07-19 19:56:29',NULL,1),(60,'Emmanuel Garcia','quangkhoa51132@5dulieu.com','0567692940','$2a$10$FwTfR.8kjEt7RPzwtkneu.HUXHOLmk9DOSYsvTZPrsLfJ1YdZyv/a',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-07 13:13:13','2025-07-22 07:02:28',NULL,1),(83,'Melanie Lancaster','quangkhoa5112@gmail.com','0722572791','$2a$10$TKn/I4MP1IRuqwZwJVqVIeOc7X2AK8RK4Xo2G5prcL8ywFYCz4BNS',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-10 01:36:30','2025-07-19 19:56:29',NULL,1),(110,'Dương Đỗ','abc@gmail.com','0782376648','$2a$10$2Zfcb/2y9j8CeGq049nu0Ojx9/dDBGn6zS9Bsl9NFF7m7au6eyccq',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-25 11:38:25','2025-07-19 19:56:29',NULL,1),(111,'Đỗ Hoàng Dương','dohoangduong2708@gmail.com','0705711546','$2a$10$OW1/RQ9tWxbUozfeeU1rV.gjz1FHtTv5uaGq3MAJ1AbCizmH5NdJS',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-06-25 11:39:32','2025-07-19 19:56:29',NULL,1),(113,'Perry Bowen','khoatqhe150834@gmail.com','0899339325','$2a$10$2Wlq1YkUUUmluzUfxcAZY.NZu1TlSCOsEl4K.4EGmswu9LUm1cXfq',1,'UNKNOWN',NULL,NULL,0,NULL,5,'2025-07-15 05:58:17','2025-07-19 19:56:29',NULL,1),(114,'Nguyen Dat','vucongdat28032003@gmail.com','0908098943','$2a$10$0aQE0V18caOPiSZSpiFlseisnW.C3XNj8aY2.IrXy1Pxo6XzoJtDi',1,'UNKNOWN',NULL,'thanh xuyen 4 , pho yen ,thai nguyen thai nguyen123',0,'đẹp trai',5,'2025-07-18 00:32:50','2025-07-22 07:03:28',NULL,1),(115,'Nguyen Dat','khachhang123@beautyzone.com','0908098978','$2a$10$/teD7FqAjxDhtqAb4zKTVefEMIlZRwMSIsZtXzFM3TE0gOWftYvt.',1,'MALE',NULL,'thanh xuyen 4 ,Thai Nguyen,Pho yen123',0,NULL,5,'2025-07-22 07:06:03','2025-07-22 07:06:03',NULL,0);
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `database_change_log`
--

DROP TABLE IF EXISTS `database_change_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `database_change_log` (
  `change_id` int NOT NULL AUTO_INCREMENT,
  `table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `operation` enum('INSERT','UPDATE','DELETE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `record_id` int NOT NULL,
  `old_data` json DEFAULT NULL,
  `new_data` json DEFAULT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `processed` tinyint(1) DEFAULT '0',
  `processed_at` timestamp NULL DEFAULT NULL,
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`change_id`),
  KEY `idx_table_operation` (`table_name`,`operation`),
  KEY `idx_processed` (`processed`),
  KEY `idx_timestamp` (`timestamp`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `database_change_log`
--

LOCK TABLES `database_change_log` WRITE;
/*!40000 ALTER TABLE `database_change_log` DISABLE KEYS */;
INSERT INTO `database_change_log` VALUES (1,'services','INSERT',137,NULL,'{\"name\": \"Trigger Test Service 07:57:45\", \"price\": 50.0, \"image_url\": null, \"is_active\": 1, \"created_at\": \"2025-07-18 07:57:45.000000\", \"service_id\": 137, \"updated_at\": \"2025-07-18 07:57:45.000000\", \"description\": \"Test service to verify database triggers work\", \"average_rating\": 0.0, \"bookable_online\": 1, \"service_type_id\": 1, \"duration_minutes\": 30, \"requires_consultation\": 0, \"buffer_time_after_minutes\": 0}','2025-07-18 00:57:45',1,'2025-07-18 00:57:52',NULL),(2,'services','UPDATE',137,'{\"name\": \"Trigger Test Service 07:57:45\", \"price\": 50.0, \"image_url\": null, \"is_active\": 1, \"created_at\": \"2025-07-18 07:57:45.000000\", \"service_id\": 137, \"updated_at\": \"2025-07-18 07:57:45.000000\", \"description\": \"Test service to verify database triggers work\", \"average_rating\": 0.0, \"bookable_online\": 1, \"service_type_id\": 1, \"duration_minutes\": 30, \"requires_consultation\": 0, \"buffer_time_after_minutes\": 0}','{\"name\": \"Trigger Test Service 07:57:45\", \"price\": 75.0, \"image_url\": null, \"is_active\": 1, \"created_at\": \"2025-07-18 07:57:45.000000\", \"service_id\": 137, \"updated_at\": \"2025-07-18 07:57:46.000000\", \"description\": \"Updated test service description\", \"average_rating\": 0.0, \"bookable_online\": 1, \"service_type_id\": 1, \"duration_minutes\": 30, \"requires_consultation\": 0, \"buffer_time_after_minutes\": 0}','2025-07-18 00:57:46',1,'2025-07-18 00:57:53',NULL),(3,'services','DELETE',137,'{\"name\": \"Trigger Test Service 07:57:45\", \"price\": 75.0, \"image_url\": null, \"is_active\": 1, \"created_at\": \"2025-07-18 07:57:45.000000\", \"service_id\": 137, \"updated_at\": \"2025-07-18 07:57:46.000000\", \"description\": \"Updated test service description\", \"average_rating\": 0.0, \"bookable_online\": 1, \"service_type_id\": 1, \"duration_minutes\": 30, \"requires_consultation\": 0, \"buffer_time_after_minutes\": 0}',NULL,'2025-07-18 00:57:47',1,'2025-07-18 00:57:53',NULL),(4,'services','INSERT',138,NULL,'{\"name\": \"Luxury Diamond Facial Treatment\", \"price\": 299.99, \"image_url\": null, \"is_active\": 1, \"created_at\": \"2025-07-18 08:00:25.000000\", \"service_id\": 138, \"updated_at\": \"2025-07-18 08:00:25.000000\", \"description\": \"Indulge in our premium diamond facial treatment featuring:\\n            - Deep cleansing with diamond microdermabrasion\\n            - Hydrating collagen mask with 24k gold essence\\n            - Anti-aging serum with vitamin C and hyaluronic acid\\n            - Relaxing facial massage with hot stones\\n            - Perfect for special occasions and skin rejuvenation\", \"average_rating\": 0.0, \"bookable_online\": 1, \"service_type_id\": 1, \"duration_minutes\": 90, \"requires_consultation\": 0, \"buffer_time_after_minutes\": 15}','2025-07-18 01:00:25',1,'2025-07-18 01:00:32',NULL),(5,'services','UPDATE',138,'{\"name\": \"Luxury Diamond Facial Treatment\", \"price\": 299.99, \"image_url\": null, \"is_active\": 1, \"created_at\": \"2025-07-18 08:00:25.000000\", \"service_id\": 138, \"updated_at\": \"2025-07-18 08:00:25.000000\", \"description\": \"Indulge in our premium diamond facial treatment featuring:\\n            - Deep cleansing with diamond microdermabrasion\\n            - Hydrating collagen mask with 24k gold essence\\n            - Anti-aging serum with vitamin C and hyaluronic acid\\n            - Relaxing facial massage with hot stones\\n            - Perfect for special occasions and skin rejuvenation\", \"average_rating\": 0.0, \"bookable_online\": 1, \"service_type_id\": 1, \"duration_minutes\": 90, \"requires_consultation\": 0, \"buffer_time_after_minutes\": 15}','{\"name\": \"Luxury Diamond Facial Treatment\", \"price\": 249.99, \"image_url\": null, \"is_active\": 1, \"created_at\": \"2025-07-18 08:00:25.000000\", \"service_id\": 138, \"updated_at\": \"2025-07-18 08:00:55.000000\", \"description\": \"Indulge in our premium diamond facial treatment featuring:\\n            - Deep cleansing with diamond microdermabrasion\\n            - Hydrating collagen mask with 24k gold essence\\n            - Anti-aging serum with vitamin C and hyaluronic acid\\n            - Relaxing facial massage with hot stones\\n            - Perfect for special occasions and skin rejuvenation\\n\\n? SPECIAL PROMOTION: Save $50 this month!\", \"average_rating\": 0.0, \"bookable_online\": 1, \"service_type_id\": 1, \"duration_minutes\": 90, \"requires_consultation\": 0, \"buffer_time_after_minutes\": 15}','2025-07-18 01:00:55',1,'2025-07-18 01:01:03',NULL),(6,'services','DELETE',138,'{\"name\": \"Luxury Diamond Facial Treatment\", \"price\": 249.99, \"image_url\": null, \"is_active\": 1, \"created_at\": \"2025-07-18 08:00:25.000000\", \"service_id\": 138, \"updated_at\": \"2025-07-18 08:00:55.000000\", \"description\": \"Indulge in our premium diamond facial treatment featuring:\\n            - Deep cleansing with diamond microdermabrasion\\n            - Hydrating collagen mask with 24k gold essence\\n            - Anti-aging serum with vitamin C and hyaluronic acid\\n            - Relaxing facial massage with hot stones\\n            - Perfect for special occasions and skin rejuvenation\\n\\n? SPECIAL PROMOTION: Save $50 this month!\", \"average_rating\": 0.0, \"bookable_online\": 1, \"service_type_id\": 1, \"duration_minutes\": 90, \"requires_consultation\": 0, \"buffer_time_after_minutes\": 15}',NULL,'2025-07-18 01:01:58',1,'2025-07-18 01:02:03',NULL),(7,'services','INSERT',139,NULL,'{\"name\": \"Liệu Pháp Collagen Vàng 24K Test 081013\", \"price\": 1299000.0, \"image_url\": null, \"is_active\": 1, \"created_at\": \"2025-07-18 08:10:13.000000\", \"service_id\": 139, \"updated_at\": \"2025-07-18 08:10:13.000000\", \"description\": \"Liệu pháp chăm sóc da mặt cao cấp với collagen vàng 24K được tạo lúc 2025-07-18 08:10:13:\\n            \\n            ✨ Đặc điểm nổi bật:\\n            - Sử dụng collagen vàng 24K nguyên chất từ Thụy Sĩ\\n            - Công nghệ nano giúp thẩm thấu sâu vào da\\n            - Kích thích tái tạo tế bào da tự nhiên\\n            - Giảm nếp nhăn và tăng độ đàn hồi\\n            - Làm sáng và đều màu da\\n            \\n            ? Phù hợp cho:\\n            - Da lão hóa, xuất hiện nếp nhăn\\n            - Da thiếu sức sống, xỉn màu\\n            - Da cần phục hồi sau stress\\n            \\n            ⏰ Quy trình điều trị:\\n            1. Làm sạch da chuyên sâu (15 phút)\\n            2. Tẩy tế bào chết nhẹ nhàng (10 phút)\\n            3. Đắp mặt nạ collagen vàng 24K (30 phút)\\n            4. Massage kích thích tuần hoàn (15 phút)\\n            5. Dưỡng ẩm và chống nắng (10 phút)\\n            \\n            ? Cam kết: Da sáng mịn ngay sau liệu trình đầu tiên!\", \"average_rating\": 0.0, \"bookable_online\": 1, \"service_type_id\": 2, \"duration_minutes\": 90, \"requires_consultation\": 0, \"buffer_time_after_minutes\": 20}','2025-07-18 01:10:13',1,'2025-07-18 01:10:36',NULL),(8,'promotions','UPDATE',2,'{\"title\": \"Tri Ân Khách Hàng - Tặng Voucher 100K\", \"status\": \"SCHEDULED\", \"end_date\": \"2025-07-31 23:59:59.000000\", \"image_url\": \"https://placehold.co/400x200/E6E6FA/333333?text=VoucherPromo\", \"created_at\": \"2025-06-01 16:40:23.000000\", \"start_date\": \"2025-07-01 00:00:00.000000\", \"updated_at\": \"2025-06-01 16:40:23.000000\", \"description\": \"Tặng voucher 100.000 VNĐ cho hóa đơn từ 1.000.000 VNĐ.\", \"promotion_id\": 2, \"discount_type\": \"FIXED_AMOUNT\", \"is_auto_apply\": 0, \"discount_value\": 100000.0, \"promotion_code\": \"THANKS100K\", \"applicable_scope\": \"ENTIRE_APPOINTMENT\", \"total_usage_limit\": 200, \"created_by_user_id\": 2, \"current_usage_count\": 0, \"terms_and_conditions\": \"Mỗi khách hàng được sử dụng 1 lần.\", \"applies_to_service_id\": null, \"usage_limit_per_customer\": 1, \"minimum_appointment_value\": 1000000.0, \"applicable_service_ids_json\": null}','{\"title\": \"Tri Ân Khách Hàng - Tặng Voucher 100K\", \"status\": \"ACTIVE\", \"end_date\": \"2025-07-31 23:59:59.000000\", \"image_url\": \"https://placehold.co/400x200/E6E6FA/333333?text=VoucherPromo\", \"created_at\": \"2025-06-01 16:40:23.000000\", \"start_date\": \"2025-07-01 00:00:00.000000\", \"updated_at\": \"2025-07-20 00:39:35.000000\", \"description\": \"Tặng voucher 100.000 VNĐ cho hóa đơn từ 1.000.000 VNĐ.\", \"promotion_id\": 2, \"discount_type\": \"FIXED_AMOUNT\", \"is_auto_apply\": 0, \"discount_value\": 100000.0, \"promotion_code\": \"THANKS100K\", \"applicable_scope\": \"ENTIRE_APPOINTMENT\", \"total_usage_limit\": 200, \"created_by_user_id\": 2, \"current_usage_count\": 0, \"terms_and_conditions\": \"Mỗi khách hàng được sử dụng 1 lần.\", \"applies_to_service_id\": null, \"usage_limit_per_customer\": 1, \"minimum_appointment_value\": 1000000.0, \"applicable_service_ids_json\": null}','2025-07-20 00:39:35',0,NULL,NULL),(9,'promotions','UPDATE',3,'{\"title\": \"Đi Cùng Bạn Bè - Miễn Phí 1 Dịch Vụ Gội Đầu\", \"status\": \"ACTIVE\", \"end_date\": \"2025-07-15 23:59:59.000000\", \"image_url\": \"https://placehold.co/400x200/B0C4DE/333333?text=FriendsPromo\", \"created_at\": \"2025-06-01 16:40:23.000000\", \"start_date\": \"2025-06-15 00:00:00.000000\", \"updated_at\": \"2025-06-01 16:40:23.000000\", \"description\": \"Khi đặt 2 dịch vụ bất kỳ, tặng 1 dịch vụ gội đầu thảo dược.\", \"promotion_id\": 3, \"discount_type\": \"FREE_SERVICE\", \"is_auto_apply\": 0, \"discount_value\": 6.0, \"promotion_code\": \"FRIENDSFREE\", \"applicable_scope\": \"ENTIRE_APPOINTMENT\", \"total_usage_limit\": 50, \"created_by_user_id\": 1, \"current_usage_count\": 5, \"terms_and_conditions\": \"Dịch vụ tặng kèm là Gội Đầu Thảo Dược (ID: 6).\", \"applies_to_service_id\": null, \"usage_limit_per_customer\": 1, \"minimum_appointment_value\": 800000.0, \"applicable_service_ids_json\": null}','{\"title\": \"Đi Cùng Bạn Bè - Miễn Phí 1 Dịch Vụ Gội Đầu\", \"status\": \"INACTIVE\", \"end_date\": \"2025-07-15 23:59:59.000000\", \"image_url\": \"https://placehold.co/400x200/B0C4DE/333333?text=FriendsPromo\", \"created_at\": \"2025-06-01 16:40:23.000000\", \"start_date\": \"2025-06-15 00:00:00.000000\", \"updated_at\": \"2025-07-20 00:39:35.000000\", \"description\": \"Khi đặt 2 dịch vụ bất kỳ, tặng 1 dịch vụ gội đầu thảo dược.\", \"promotion_id\": 3, \"discount_type\": \"FREE_SERVICE\", \"is_auto_apply\": 0, \"discount_value\": 6.0, \"promotion_code\": \"FRIENDSFREE\", \"applicable_scope\": \"ENTIRE_APPOINTMENT\", \"total_usage_limit\": 50, \"created_by_user_id\": 1, \"current_usage_count\": 5, \"terms_and_conditions\": \"Dịch vụ tặng kèm là Gội Đầu Thảo Dược (ID: 6).\", \"applies_to_service_id\": null, \"usage_limit_per_customer\": 1, \"minimum_appointment_value\": 800000.0, \"applicable_service_ids_json\": null}','2025-07-20 00:39:35',0,NULL,NULL);
/*!40000 ALTER TABLE `database_change_log` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=137 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_verification_tokens`
--

LOCK TABLES `email_verification_tokens` WRITE;
/*!40000 ALTER TABLE `email_verification_tokens` DISABLE KEYS */;
INSERT INTO `email_verification_tokens` VALUES (81,'c216559d-da40-447e-b38a-a5e88f1c3b0e','quangkhoa51132@5dulieu.com','2025-06-07 13:13:15','2025-06-08 13:13:15',0),(99,'0a27e432-4208-483b-8ebf-d0214ed8cbea','quangkhoa5112@gmail.com','2025-06-10 01:36:32','2025-06-11 01:36:32',1),(118,'7b75cfe9-c519-475b-a133-d5adb8764a72','khoatqhe150834@fpt.edu.vn','2025-06-16 01:24:40','2025-06-17 01:24:41',1),(129,'63df4db1-b921-47f3-93bf-c088ff4e76af','khoatqhe150834@gmail.com','2025-06-22 12:35:41','2025-06-23 12:35:42',1),(131,'a7e5c4f4-0933-4c00-9d7c-75748172217e','abc@gmail.com','2025-06-25 11:38:30','2025-06-26 11:38:31',0),(134,'945e4624-40d4-48e2-a8ba-a4bc5ab8dc1b','dohoangduong2708@gmail.com','2025-06-25 11:41:16','2025-06-26 11:41:16',0),(135,'9103a486-0b60-47bc-901f-7925909d0293','khoatqhe150834@gmail.com','2025-07-03 11:11:21','2025-07-04 04:11:21',1),(136,'3cead5ea-d921-4ae2-80e4-ff1b3823c99b','khoatqhe150834@gmail.com','2025-07-15 12:58:16','2025-07-16 05:58:17',1);
/*!40000 ALTER TABLE `email_verification_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `general_notifications`
--

DROP TABLE IF EXISTS `general_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
  KEY `idx_active_dates` (`is_active`,`start_date`,`end_date`),
  KEY `idx_created_by` (`created_by_user_id`),
  KEY `idx_notifications_active_priority` (`is_active`,`priority`,`created_at`),
  CONSTRAINT `general_notifications_ibfk_1` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng thông báo chung cho tất cả user roles';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `general_notifications`
--

LOCK TABLES `general_notifications` WRITE;
/*!40000 ALTER TABLE `general_notifications` DISABLE KEYS */;
INSERT INTO `general_notifications` VALUES (1,'Chào Mừng Hệ Thống Thông Báo Mới','Chúng tôi vui mừng giới thiệu hệ thống thông báo mới giúp bạn cập nhật thông tin kịp thời. Hãy kiểm tra thông báo thường xuyên để không bỏ lỡ thông tin quan trọng!','SYSTEM_ANNOUNCEMENT','MEDIUM','ALL_USERS',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2025-07-20 15:27:42','2025-08-19 15:27:42',1,'2025-07-20 08:27:42','2025-07-20 08:27:42'),(2,'Khuyến Mãi Tháng 8 - Giảm 30% Massage','Chương trình khuyến mãi đặc biệt tháng 8! Giảm 30% cho tất cả dịch vụ massage. Áp dụng từ 01/08 đến 31/08. Đặt lịch ngay để nhận ưu đãi!','PROMOTION','HIGH','ROLE_BASED','[5]',NULL,NULL,NULL,NULL,NULL,NULL,1,'2025-07-20 15:27:42','2025-08-04 15:27:42',1,'2025-07-20 08:27:42','2025-07-20 08:27:42'),(3,'Bảo Trì Hệ Thống Cuối Tuần','Hệ thống sẽ được bảo trì vào Chủ nhật từ 2:00 - 6:00 sáng. Một số chức năng có thể bị gián đoạn. Xin lỗi vì sự bất tiện.','MAINTENANCE','HIGH','ROLE_BASED','[1, 2, 3, 4]',NULL,NULL,NULL,NULL,NULL,NULL,1,'2025-07-20 15:27:42','2025-07-27 15:27:42',1,'2025-07-20 08:27:42','2025-07-20 08:27:42'),(4,'Cập Nhật Chính Sách Mới','Chính sách hủy lịch hẹn đã được cập nhật. Khách hàng có thể hủy miễn phí trước 24 giờ. Vui lòng thông báo cho khách hàng.','POLICY_UPDATE','MEDIUM','ROLE_BASED','[2, 3, 4]',NULL,NULL,NULL,NULL,NULL,NULL,1,'2025-07-20 15:27:42','2025-09-18 15:27:42',1,'2025-07-20 08:27:42','2025-07-20 08:27:42');
/*!40000 ALTER TABLE `general_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_category`
--

DROP TABLE IF EXISTS `inventory_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_category` (
  `inventory_category_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`inventory_category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_category`
--

LOCK TABLES `inventory_category` WRITE;
/*!40000 ALTER TABLE `inventory_category` DISABLE KEYS */;
INSERT INTO `inventory_category` VALUES (1,'Hóa chất','Các loại hóa chất sử dụng trong spa',1),(2,'Dụng cụ','Dụng cụ phục vụ dịch vụ spa',1),(3,'Tiêu hao','Vật tư tiêu hao hàng ngày',1),(4,'Khác','Vật tư khác',1);
/*!40000 ALTER TABLE `inventory_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_issue`
--

DROP TABLE IF EXISTS `inventory_issue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_issue` (
  `inventory_issue_id` int NOT NULL AUTO_INCREMENT,
  `issue_date` datetime NOT NULL,
  `booking_id` int DEFAULT NULL,
  `requested_by` int DEFAULT NULL,
  `approved_by` int DEFAULT NULL,
  `status` enum('PENDING','APPROVED','REJECTED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`inventory_issue_id`),
  KEY `booking_id` (`booking_id`),
  KEY `requested_by` (`requested_by`),
  KEY `approved_by` (`approved_by`),
  CONSTRAINT `inventory_issue_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`),
  CONSTRAINT `inventory_issue_ibfk_2` FOREIGN KEY (`requested_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `inventory_issue_ibfk_3` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_issue`
--

LOCK TABLES `inventory_issue` WRITE;
/*!40000 ALTER TABLE `inventory_issue` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_issue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_issue_detail`
--

DROP TABLE IF EXISTS `inventory_issue_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_issue_detail` (
  `inventory_issue_detail_id` int NOT NULL AUTO_INCREMENT,
  `inventory_issue_id` int NOT NULL,
  `inventory_item_id` int NOT NULL,
  `quantity` int NOT NULL,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`inventory_issue_detail_id`),
  KEY `inventory_issue_id` (`inventory_issue_id`),
  KEY `inventory_item_id` (`inventory_item_id`),
  CONSTRAINT `inventory_issue_detail_ibfk_1` FOREIGN KEY (`inventory_issue_id`) REFERENCES `inventory_issue` (`inventory_issue_id`) ON DELETE CASCADE,
  CONSTRAINT `inventory_issue_detail_ibfk_2` FOREIGN KEY (`inventory_item_id`) REFERENCES `inventory_item` (`inventory_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_issue_detail`
--

LOCK TABLES `inventory_issue_detail` WRITE;
/*!40000 ALTER TABLE `inventory_issue_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_issue_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_item`
--

DROP TABLE IF EXISTS `inventory_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_item` (
  `inventory_item_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `inventory_category_id` int DEFAULT NULL,
  `supplier_id` int DEFAULT NULL,
  `unit` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int DEFAULT '0',
  `min_quantity` int DEFAULT '0',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`inventory_item_id`),
  KEY `inventory_category_id` (`inventory_category_id`),
  KEY `supplier_id` (`supplier_id`),
  CONSTRAINT `inventory_item_ibfk_1` FOREIGN KEY (`inventory_category_id`) REFERENCES `inventory_category` (`inventory_category_id`),
  CONSTRAINT `inventory_item_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`supplier_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_item`
--

LOCK TABLES `inventory_item` WRITE;
/*!40000 ALTER TABLE `inventory_item` DISABLE KEYS */;
INSERT INTO `inventory_item` VALUES (1,'Dầu massage lavender',1,1,'ml',5000,500,'Dầu massage hương lavender dùng cho các dịch vụ massage','2025-07-16 06:53:25','2025-07-16 06:53:25',1),(2,'Khăn spa',2,2,'cái',200,20,'Khăn cotton dùng cho khách','2025-07-16 06:53:25','2025-07-16 06:53:25',1),(3,'Mặt nạ dưỡng da',1,1,'gói',100,10,'Mặt nạ giấy dưỡng da cho dịch vụ facial','2025-07-16 06:53:25','2025-07-16 06:53:25',1),(4,'Găng tay y tế',3,3,'đôi',300,30,'Găng tay dùng 1 lần cho kỹ thuật viên','2025-07-16 06:53:25','2025-07-16 06:53:25',1),(5,'Tinh dầu sả chanh',1,1,'ml',1500,100,'Tinh dầu dùng cho xông phòng','2025-07-16 06:53:25','2025-07-16 06:53:25',1),(6,'Bông tẩy trang',3,3,'bịch',80,10,'Bông tẩy trang dùng cho facial','2025-07-16 06:53:25','2025-07-16 06:53:25',1),(7,'Bộ dụng cụ nail',2,2,'bộ',20,5,'Bộ dụng cụ làm móng','2025-07-16 06:53:25','2025-07-16 06:53:25',1),(8,'Khẩu trang y tế',3,3,'hộp',50,10,'Khẩu trang dùng cho nhân viên','2025-07-16 06:53:25','2025-07-16 06:53:25',1);
/*!40000 ALTER TABLE `inventory_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_receipt`
--

DROP TABLE IF EXISTS `inventory_receipt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_receipt` (
  `inventory_receipt_id` int NOT NULL AUTO_INCREMENT,
  `receipt_date` datetime NOT NULL,
  `supplier_id` int DEFAULT NULL,
  `created_by` int DEFAULT NULL,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`inventory_receipt_id`),
  KEY `supplier_id` (`supplier_id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `inventory_receipt_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`supplier_id`),
  CONSTRAINT `inventory_receipt_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_receipt`
--

LOCK TABLES `inventory_receipt` WRITE;
/*!40000 ALTER TABLE `inventory_receipt` DISABLE KEYS */;
INSERT INTO `inventory_receipt` VALUES (1,'2025-06-20 09:00:00',1,7,'Nhập dầu massage, mặt nạ, tinh dầu','2025-07-16 06:53:25'),(2,'2025-06-21 10:00:00',2,7,'Nhập khăn spa, bộ dụng cụ nail','2025-07-16 06:53:25'),(3,'2025-06-22 11:00:00',3,7,'Nhập găng tay, bông tẩy trang, khẩu trang','2025-07-16 06:53:25');
/*!40000 ALTER TABLE `inventory_receipt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_receipt_detail`
--

DROP TABLE IF EXISTS `inventory_receipt_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_receipt_detail` (
  `inventory_receipt_detail_id` int NOT NULL AUTO_INCREMENT,
  `inventory_receipt_id` int NOT NULL,
  `inventory_item_id` int NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(12,2) DEFAULT '0.00',
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`inventory_receipt_detail_id`),
  KEY `inventory_receipt_id` (`inventory_receipt_id`),
  KEY `inventory_item_id` (`inventory_item_id`),
  CONSTRAINT `inventory_receipt_detail_ibfk_1` FOREIGN KEY (`inventory_receipt_id`) REFERENCES `inventory_receipt` (`inventory_receipt_id`) ON DELETE CASCADE,
  CONSTRAINT `inventory_receipt_detail_ibfk_2` FOREIGN KEY (`inventory_item_id`) REFERENCES `inventory_item` (`inventory_item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_receipt_detail`
--

LOCK TABLES `inventory_receipt_detail` WRITE;
/*!40000 ALTER TABLE `inventory_receipt_detail` DISABLE KEYS */;
INSERT INTO `inventory_receipt_detail` VALUES (1,1,1,2000,1.50,'Nhập dầu massage'),(2,1,3,50,10.00,'Nhập mặt nạ'),(3,1,5,500,2.00,'Nhập tinh dầu sả chanh'),(4,2,2,100,20.00,'Nhập khăn spa'),(5,2,7,10,50.00,'Nhập bộ dụng cụ nail'),(6,3,4,100,2.00,'Nhập găng tay'),(7,3,6,30,5.00,'Nhập bông tẩy trang'),(8,3,8,20,10.00,'Nhập khẩu trang');
/*!40000 ALTER TABLE `inventory_receipt_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_transaction`
--

DROP TABLE IF EXISTS `inventory_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_transaction` (
  `inventory_transaction_id` int NOT NULL AUTO_INCREMENT,
  `inventory_item_id` int NOT NULL,
  `type` enum('IN','OUT','ADJUST') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int NOT NULL,
  `transaction_date` datetime NOT NULL,
  `user_id` int DEFAULT NULL,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`inventory_transaction_id`),
  KEY `inventory_item_id` (`inventory_item_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `inventory_transaction_ibfk_1` FOREIGN KEY (`inventory_item_id`) REFERENCES `inventory_item` (`inventory_item_id`),
  CONSTRAINT `inventory_transaction_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_transaction`
--

LOCK TABLES `inventory_transaction` WRITE;
/*!40000 ALTER TABLE `inventory_transaction` DISABLE KEYS */;
INSERT INTO `inventory_transaction` VALUES (1,1,'IN',2000,'2025-06-20 09:00:00',7,'Nhập dầu massage'),(2,3,'IN',50,'2025-06-20 09:00:00',7,'Nhập mặt nạ'),(3,5,'IN',500,'2025-06-20 09:00:00',7,'Nhập tinh dầu sả chanh'),(4,2,'IN',100,'2025-06-21 10:00:00',7,'Nhập khăn spa'),(5,7,'IN',10,'2025-06-21 10:00:00',7,'Nhập bộ dụng cụ nail'),(6,4,'IN',100,'2025-06-22 11:00:00',7,'Nhập găng tay'),(7,6,'IN',30,'2025-06-22 11:00:00',7,'Nhập bông tẩy trang'),(8,8,'IN',20,'2025-06-22 11:00:00',7,'Nhập khẩu trang'),(9,1,'OUT',100,'2025-06-25 08:30:00',5,'Xuất dầu massage cho booking 143'),(10,2,'OUT',5,'2025-06-25 08:30:00',5,'Xuất khăn cho booking 143'),(11,5,'OUT',20,'2025-06-25 08:30:00',5,'Xuất tinh dầu cho booking 143'),(12,2,'OUT',2,'2025-06-25 14:00:00',5,'Xuất khăn cho booking 145'),(13,7,'OUT',1,'2025-06-25 14:00:00',5,'Xuất bộ dụng cụ nail cho booking 145'),(14,3,'OUT',2,'2025-06-26 09:00:00',12,'Xuất mặt nạ cho booking 147'),(15,6,'OUT',1,'2025-06-26 09:00:00',12,'Xuất bông tẩy trang cho booking 147'),(16,5,'OUT',10,'2025-06-27 10:00:00',7,'Xuất tinh dầu cho phòng xông hơi'),(17,8,'OUT',2,'2025-06-27 10:00:00',7,'Xuất khẩu trang cho phòng xông hơi');
/*!40000 ALTER TABLE `inventory_transaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loyalty_point_history`
--

DROP TABLE IF EXISTS `loyalty_point_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loyalty_point_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `change_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` int NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `loyalty_point_history_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loyalty_point_history`
--

LOCK TABLES `loyalty_point_history` WRITE;
/*!40000 ALTER TABLE `loyalty_point_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `loyalty_point_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loyalty_points`
--

DROP TABLE IF EXISTS `loyalty_points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loyalty_points` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `points` int NOT NULL DEFAULT '0',
  `rank` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'BRONZE',
  `last_login_date` date DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `loyalty_points_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loyalty_points`
--

LOCK TABLES `loyalty_points` WRITE;
/*!40000 ALTER TABLE `loyalty_points` DISABLE KEYS */;
/*!40000 ALTER TABLE `loyalty_points` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_preferences`
--

DROP TABLE IF EXISTS `notification_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
  UNIQUE KEY `unique_user_notification_type` (`user_id`,`notification_type`),
  UNIQUE KEY `unique_customer_notification_type` (`customer_id`,`notification_type`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_customer_id` (`customer_id`),
  CONSTRAINT `notification_preferences_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `notification_preferences_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`),
  CONSTRAINT `chk_preference_type` CHECK ((((`user_id` is not null) and (`customer_id` is null)) or ((`user_id` is null) and (`customer_id` is not null))))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Cài đặt thông báo của từng user/customer';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_preferences`
--

LOCK TABLES `notification_preferences` WRITE;
/*!40000 ALTER TABLE `notification_preferences` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_preferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_recipients`
--

DROP TABLE IF EXISTS `notification_recipients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
  UNIQUE KEY `unique_notification_recipient` (`notification_id`,`user_id`,`customer_id`),
  KEY `idx_notification_id` (`notification_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_customer_id` (`customer_id`),
  KEY `idx_read_status` (`is_read`,`read_at`),
  KEY `idx_delivery_status` (`delivery_status`),
  KEY `idx_recipients_unread` (`user_id`,`customer_id`,`is_read`,`created_at`),
  KEY `idx_recipients_delivery` (`delivery_status`,`delivery_method`,`created_at`),
  CONSTRAINT `notification_recipients_ibfk_1` FOREIGN KEY (`notification_id`) REFERENCES `general_notifications` (`notification_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `notification_recipients_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `notification_recipients_ibfk_3` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`),
  CONSTRAINT `chk_recipient_type` CHECK ((((`user_id` is not null) and (`customer_id` is null)) or ((`user_id` is null) and (`customer_id` is not null))))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng theo dõi người nhận thông báo và trạng thái đọc';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_recipients`
--

LOCK TABLES `notification_recipients` WRITE;
/*!40000 ALTER TABLE `notification_recipients` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_recipients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_statistics`
--

DROP TABLE IF EXISTS `notification_statistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_statistics`
--

LOCK TABLES `notification_statistics` WRITE;
/*!40000 ALTER TABLE `notification_statistics` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_statistics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_templates`
--

DROP TABLE IF EXISTS `notification_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Templates cho thông báo có thể tái sử dụng';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_templates`
--

LOCK TABLES `notification_templates` WRITE;
/*!40000 ALTER TABLE `notification_templates` DISABLE KEYS */;
INSERT INTO `notification_templates` VALUES (1,'system_maintenance','Thông báo bảo trì hệ thống','MAINTENANCE','Thông Báo Bảo Trì Hệ Thống - {maintenance_date}','Hệ thống sẽ được bảo trì vào {maintenance_date} từ {start_time} đến {end_time}. Trong thời gian này, một số chức năng có thể bị gián đoạn. Xin lỗi vì sự bất tiện này.','HIGH','ALL_USERS',NULL,'{\"end_time\": \"Giờ kết thúc\", \"start_time\": \"Giờ bắt đầu\", \"maintenance_date\": \"Ngày bảo trì\"}',1,1,'2025-07-20 08:27:42','2025-07-20 08:27:42'),(2,'new_promotion','Thông báo khuyến mãi mới','PROMOTION','Khuyến Mãi Mới: {promotion_title}','Chúng tôi vui mừng thông báo chương trình khuyến mãi mới: {promotion_title}. Giảm giá {discount_percent}% cho {service_names}. Thời gian áp dụng: {start_date} - {end_date}. Đặt lịch ngay!','MEDIUM','ROLE_BASED','[5]','{\"end_date\": \"Ngày kết thúc\", \"start_date\": \"Ngày bắt đầu\", \"service_names\": \"Tên dịch vụ\", \"promotion_title\": \"Tên chương trình\", \"discount_percent\": \"Phần trăm giảm giá\"}',1,1,'2025-07-20 08:27:42','2025-07-20 08:27:42'),(3,'booking_reminder','Nhắc nhở lịch hẹn','BOOKING_REMINDER','Nhắc Nhở: Lịch Hẹn Của Bạn Vào {appointment_date}','Xin chào {customer_name}, bạn có lịch hẹn {service_name} vào {appointment_date} lúc {appointment_time} với {therapist_name}. Vui lòng đến đúng giờ. Cảm ơn!','MEDIUM','INDIVIDUAL',NULL,'{\"service_name\": \"Tên dịch vụ\", \"customer_name\": \"Tên khách hàng\", \"therapist_name\": \"Tên kỹ thuật viên\", \"appointment_date\": \"Ngày hẹn\", \"appointment_time\": \"Giờ hẹn\"}',1,1,'2025-07-20 08:27:42','2025-07-20 08:27:42'),(4,'payment_success','Thông báo thanh toán thành công','PAYMENT_NOTIFICATION','Thanh Toán Thành Công - Đơn Hàng #{order_id}','Cảm ơn {customer_name} đã thanh toán thành công đơn hàng #{order_id} với số tiền {amount}. Chúng tôi sẽ liên hệ để sắp xếp lịch hẹn sớm nhất.','MEDIUM','INDIVIDUAL',NULL,'{\"amount\": \"Số tiền\", \"order_id\": \"Mã đơn hàng\", \"customer_name\": \"Tên khách hàng\"}',1,1,'2025-07-20 08:27:42','2025-07-20 08:27:42'),(5,'inventory_low_stock','Cảnh báo hết hàng','INVENTORY_ALERT','Cảnh Báo: Sản Phẩm {product_name} Sắp Hết','Sản phẩm {product_name} chỉ còn {quantity} {unit} trong kho. Vui lòng nhập thêm hàng để đảm bảo hoạt động kinh doanh.','HIGH','ROLE_BASED','[1, 2, 7]','{\"unit\": \"Đơn vị\", \"quantity\": \"Số lượng còn lại\", \"product_name\": \"Tên sản phẩm\"}',1,1,'2025-07-20 08:27:42','2025-07-20 08:27:42'),(6,'emergency_alert','Thông báo khẩn cấp','EMERGENCY','KHẨN CẤP: {alert_title}','{alert_message}. Vui lòng thực hiện ngay các biện pháp cần thiết. Liên hệ quản lý nếu cần hỗ trợ.','URGENT','ALL_USERS',NULL,'{\"alert_title\": \"Tiêu đề cảnh báo\", \"alert_message\": \"Nội dung cảnh báo\"}',1,1,'2025-07-20 08:27:42','2025-07-20 08:27:42');
/*!40000 ALTER TABLE `notification_templates` ENABLE KEYS */;
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
  `token` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` timestamp NOT NULL,
  `is_used` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `idx_user_email` (`user_email`),
  KEY `idx_token` (`token`)
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
-- Table structure for table `payment_item_usage`
--

DROP TABLE IF EXISTS `payment_item_usage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_item_usage` (
  `usage_id` int NOT NULL AUTO_INCREMENT,
  `payment_item_id` int NOT NULL,
  `total_quantity` int NOT NULL,
  `booked_quantity` int NOT NULL DEFAULT '0',
  `remaining_quantity` int GENERATED ALWAYS AS ((`total_quantity` - `booked_quantity`)) STORED,
  `last_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`usage_id`),
  UNIQUE KEY `uk_payment_item` (`payment_item_id`),
  CONSTRAINT `payment_item_usage_ibfk_1` FOREIGN KEY (`payment_item_id`) REFERENCES `payment_items` (`payment_item_id`) ON DELETE CASCADE,
  CONSTRAINT `chk_booked_quantity_valid` CHECK (((`booked_quantity` >= 0) and (`booked_quantity` <= `total_quantity`))),
  CONSTRAINT `chk_total_quantity_positive` CHECK ((`total_quantity` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_item_usage`
--

LOCK TABLES `payment_item_usage` WRITE;
/*!40000 ALTER TABLE `payment_item_usage` DISABLE KEYS */;
INSERT INTO `payment_item_usage` (`usage_id`, `payment_item_id`, `total_quantity`, `booked_quantity`, `last_updated`) VALUES (4,4,1,0,'2025-07-16 04:14:56'),(5,5,1,0,'2025-07-16 04:14:56'),(6,6,1,0,'2025-07-16 04:14:56'),(7,7,2,0,'2025-07-16 04:26:07'),(8,8,1,0,'2025-07-16 04:26:07'),(9,9,1,0,'2025-07-16 04:26:07'),(10,10,1,0,'2025-07-16 18:00:06'),(11,11,1,0,'2025-07-16 18:00:06'),(12,12,1,0,'2025-07-16 18:00:06'),(13,13,1,0,'2025-07-16 18:00:06'),(14,14,1,0,'2025-07-17 04:00:38'),(15,15,1,0,'2025-07-17 04:00:38'),(16,16,1,0,'2025-07-17 04:00:38'),(17,17,1,0,'2025-07-17 04:00:38'),(18,18,1,0,'2025-07-17 04:00:38'),(19,19,1,0,'2025-07-17 04:00:38'),(20,20,1,0,'2025-07-17 04:00:38'),(21,21,1,0,'2025-07-17 04:00:38'),(22,22,1,0,'2025-07-17 04:00:38'),(23,23,1,0,'2025-07-17 04:00:38'),(24,24,1,0,'2025-07-17 04:00:38'),(25,25,1,0,'2025-07-17 04:00:38'),(26,26,1,0,'2025-07-17 04:00:38'),(27,27,1,0,'2025-07-17 04:00:38'),(28,28,1,0,'2025-07-17 04:00:38'),(29,29,1,0,'2025-07-17 04:00:38'),(30,30,1,0,'2025-07-17 04:00:38'),(31,31,2,0,'2025-07-17 10:50:46'),(32,32,1,0,'2025-07-17 10:50:46'),(33,33,4,0,'2025-07-17 10:50:46'),(34,34,1,0,'2025-07-17 10:50:46'),(35,35,1,0,'2025-07-17 14:20:34'),(36,36,1,0,'2025-07-17 14:20:34'),(37,37,1,0,'2025-07-17 14:20:34'),(38,38,1,0,'2025-07-17 14:20:34'),(39,39,1,0,'2025-07-17 14:20:34'),(40,40,1,0,'2025-07-17 14:20:34'),(41,41,1,0,'2025-07-17 14:20:34'),(42,42,1,0,'2025-07-17 14:20:34'),(43,43,1,0,'2025-07-17 14:20:34');
/*!40000 ALTER TABLE `payment_item_usage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_items`
--

DROP TABLE IF EXISTS `payment_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_items` (
  `payment_item_id` int NOT NULL AUTO_INCREMENT,
  `payment_id` int NOT NULL,
  `service_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `unit_price` decimal(10,2) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `service_duration` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_item_id`),
  KEY `idx_payment_items` (`payment_id`),
  KEY `idx_service_payment` (`service_id`),
  CONSTRAINT `payment_items_ibfk_1` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`payment_id`) ON DELETE CASCADE,
  CONSTRAINT `payment_items_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`) ON DELETE RESTRICT,
  CONSTRAINT `chk_duration_positive` CHECK ((`service_duration` > 0)),
  CONSTRAINT `chk_quantity_positive` CHECK ((`quantity` > 0)),
  CONSTRAINT `chk_total_price_positive` CHECK ((`total_price` > 0)),
  CONSTRAINT `chk_unit_price_positive` CHECK ((`unit_price` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_items`
--

LOCK TABLES `payment_items` WRITE;
/*!40000 ALTER TABLE `payment_items` DISABLE KEYS */;
INSERT INTO `payment_items` VALUES (4,2,3,1,400000.00,400000.00,60,'2025-07-16 04:14:56'),(5,2,5,1,450000.00,450000.00,45,'2025-07-16 04:14:56'),(6,2,2,1,700000.00,700000.00,90,'2025-07-16 04:14:56'),(7,3,6,2,300000.00,600000.00,60,'2025-07-16 04:26:07'),(8,3,8,1,750000.00,750000.00,75,'2025-07-16 04:26:07'),(9,3,7,1,650000.00,650000.00,90,'2025-07-16 04:26:07'),(10,110,2,1,700000.00,700000.00,90,'2025-07-16 18:00:06'),(11,110,5,1,450000.00,450000.00,45,'2025-07-16 18:00:06'),(12,110,8,1,750000.00,750000.00,75,'2025-07-16 18:00:06'),(13,110,1,1,500000.00,500000.00,60,'2025-07-16 18:00:06'),(14,111,2,1,700000.00,700000.00,90,'2025-07-17 04:00:38'),(15,111,3,1,400000.00,400000.00,60,'2025-07-17 04:00:38'),(16,111,5,1,450000.00,450000.00,45,'2025-07-17 04:00:38'),(17,111,6,1,300000.00,300000.00,60,'2025-07-17 04:00:38'),(18,111,1,1,500000.00,500000.00,60,'2025-07-17 04:00:38'),(19,111,4,1,650000.00,650000.00,75,'2025-07-17 04:00:38'),(20,111,7,1,650000.00,650000.00,90,'2025-07-17 04:00:38'),(21,111,8,1,750000.00,750000.00,75,'2025-07-17 04:00:38'),(22,111,83,1,300000.00,300000.00,45,'2025-07-17 04:00:38'),(23,111,84,1,250000.00,250000.00,30,'2025-07-17 04:00:38'),(24,111,85,1,200000.00,200000.00,30,'2025-07-17 04:00:38'),(25,111,86,1,350000.00,350000.00,60,'2025-07-17 04:00:38'),(26,111,88,1,600000.00,600000.00,75,'2025-07-17 04:00:38'),(27,111,87,1,1500000.00,1500000.00,60,'2025-07-17 04:00:38'),(28,111,89,1,3000000.00,3000000.00,120,'2025-07-17 04:00:38'),(29,111,90,1,2000000.00,2000000.00,90,'2025-07-17 04:00:38'),(30,111,91,1,2500000.00,2500000.00,60,'2025-07-17 04:00:38'),(31,112,88,2,600000.00,1200000.00,75,'2025-07-17 10:50:46'),(32,112,86,1,350000.00,350000.00,60,'2025-07-17 10:50:46'),(33,112,85,4,200000.00,800000.00,30,'2025-07-17 10:50:46'),(34,112,84,1,250000.00,250000.00,30,'2025-07-17 10:50:46'),(35,113,83,1,300000.00,300000.00,45,'2025-07-17 14:20:34'),(36,113,85,1,200000.00,200000.00,30,'2025-07-17 14:20:34'),(37,113,84,1,250000.00,250000.00,30,'2025-07-17 14:20:34'),(38,113,87,1,1500000.00,1500000.00,60,'2025-07-17 14:20:34'),(39,113,88,1,600000.00,600000.00,75,'2025-07-17 14:20:34'),(40,113,86,1,350000.00,350000.00,60,'2025-07-17 14:20:34'),(41,113,89,1,3000000.00,3000000.00,120,'2025-07-17 14:20:34'),(42,113,90,1,2000000.00,2000000.00,90,'2025-07-17 14:20:34'),(43,113,91,1,2500000.00,2500000.00,60,'2025-07-17 14:20:34');
/*!40000 ALTER TABLE `payment_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_scheduling_notifications`
--

DROP TABLE IF EXISTS `payment_scheduling_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
  KEY `idx_read_status` (`is_read`,`read_at`),
  KEY `idx_acknowledged_status` (`is_acknowledged`,`acknowledged_at`),
  KEY `idx_created_at` (`created_at`),
  KEY `payment_scheduling_notifications_ibfk_4` (`acknowledged_by`),
  CONSTRAINT `payment_scheduling_notifications_ibfk_1` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`payment_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `payment_scheduling_notifications_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `payment_scheduling_notifications_ibfk_3` FOREIGN KEY (`recipient_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `payment_scheduling_notifications_ibfk_4` FOREIGN KEY (`acknowledged_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Specialized notifications for payment-to-scheduling workflow';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_scheduling_notifications`
--

LOCK TABLES `payment_scheduling_notifications` WRITE;
/*!40000 ALTER TABLE `payment_scheduling_notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment_scheduling_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `tax_amount` decimal(10,2) DEFAULT '0.00',
  `subtotal_amount` decimal(10,2) NOT NULL,
  `payment_method` enum('BANK_TRANSFER','CREDIT_CARD','VNPAY','MOMO','ZALOPAY','CASH') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_status` enum('PENDING','PAID','REFUNDED','FAILED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `reference_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `transaction_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `payment_date` timestamp NULL DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `reference_number` (`reference_number`),
  KEY `idx_customer_payment` (`customer_id`,`payment_date`),
  KEY `idx_payment_status` (`payment_status`),
  KEY `idx_reference_number` (`reference_number`),
  KEY `idx_transaction_date` (`transaction_date`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (2,113,1705000.00,155000.00,1550000.00,'BANK_TRANSFER','PENDING','SPA969268652','2025-07-15 21:14:57',NULL,'Thanh toán qua QR Code','2025-07-16 04:14:56','2025-07-16 04:14:56'),(3,113,2200000.00,200000.00,2000000.00,'BANK_TRANSFER','PENDING','SPA679758887','2025-07-15 21:26:08',NULL,'Thanh toán qua QR Code','2025-07-16 04:26:07','2025-07-16 04:26:07'),(4,1,500000.00,50000.00,450000.00,'CASH','PAID','TEST_REF_001','2025-07-16 08:16:48','2025-07-16 08:16:48','Test payment for debugging','2025-07-16 15:16:47','2025-07-16 15:16:47'),(5,1,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752679007634001','2025-07-16 08:16:48','2025-07-16 08:16:48','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 15:16:47','2025-07-16 15:16:47'),(6,1,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752679007641002','2025-07-16 08:16:48',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 15:16:47','2025-07-16 15:16:47'),(8,113,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752679007656002','2025-07-16 08:16:48',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 15:16:47','2025-07-16 16:29:53'),(11,1,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752679234854001','2025-07-16 08:20:35','2025-07-16 08:20:35','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 15:20:34','2025-07-16 15:20:34'),(12,1,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752679234878002','2025-07-16 08:20:35',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 15:20:34','2025-07-16 15:20:34'),(15,1,500000.00,50000.00,450000.00,'CASH','PAID','TEST_REF_1752679576136','2025-07-16 08:26:16','2025-07-16 08:26:16','Test payment for debugging','2025-07-16 15:26:16','2025-07-16 15:26:16'),(16,1,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752679576195001','2025-07-16 08:26:16','2025-07-16 08:26:16','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 15:26:16','2025-07-16 15:26:16'),(17,1,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752679576201002','2025-07-16 08:26:16',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 15:26:16','2025-07-16 15:26:16'),(20,1,500000.00,50000.00,450000.00,'CASH','PAID','TEST_REF_1752679723131','2025-07-16 08:28:43','2025-07-16 08:28:43','Test payment for debugging','2025-07-16 15:28:43','2025-07-16 15:28:43'),(21,1,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752679723188001','2025-07-16 08:28:43','2025-07-16 08:28:43','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 15:28:43','2025-07-16 15:28:43'),(22,1,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752679723194002','2025-07-16 08:28:43',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 15:28:43','2025-07-16 15:28:43'),(25,1,500000.00,50000.00,450000.00,'CASH','PAID','TEST_REF_1752679854914','2025-07-16 08:30:55','2025-07-16 08:30:55','Test payment for debugging','2025-07-16 15:30:54','2025-07-16 15:30:54'),(26,1,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752679854967001','2025-07-16 08:30:55','2025-07-16 08:30:55','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 15:30:54','2025-07-16 15:30:54'),(27,1,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752679854974002','2025-07-16 08:30:55',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 15:30:54','2025-07-16 15:30:54'),(30,1,500000.00,50000.00,450000.00,'CASH','PAID','TEST_REF_1752680333592','2025-07-16 08:38:54','2025-07-16 08:38:54','Test payment for debugging','2025-07-16 15:38:53','2025-07-16 15:38:53'),(31,1,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752680333641001','2025-07-16 08:38:54','2025-07-16 08:38:54','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 15:38:53','2025-07-16 15:38:53'),(32,1,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752680333646002','2025-07-16 08:38:54',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 15:38:53','2025-07-16 15:38:53'),(35,1,500000.00,50000.00,450000.00,'CASH','PAID','TEST_REF_1752680746245','2025-07-16 08:45:46','2025-07-16 08:45:46','Test payment for debugging','2025-07-16 15:45:46','2025-07-16 15:45:46'),(36,1,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752680746293001','2025-07-16 08:45:46','2025-07-16 08:45:46','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 15:45:46','2025-07-16 15:45:46'),(37,1,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752680746298002','2025-07-16 08:45:46',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 15:45:46','2025-07-16 15:45:46'),(40,1,500000.00,50000.00,450000.00,'CASH','PAID','TEST_REF_1752681025907','2025-07-16 08:50:26','2025-07-16 08:50:26','Test payment for debugging','2025-07-16 15:50:25','2025-07-16 15:50:25'),(41,1,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752681025962001','2025-07-16 08:50:26','2025-07-16 08:50:26','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 15:50:25','2025-07-16 15:50:25'),(42,1,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752681025967002','2025-07-16 08:50:26',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 15:50:25','2025-07-16 15:50:25'),(44,2,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752681025975002','2025-07-16 08:50:26',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 15:50:25','2025-07-16 15:50:25'),(45,1,500000.00,50000.00,450000.00,'CASH','PAID','TEST_REF_1752681115196','2025-07-16 08:51:55','2025-07-16 08:51:55','Test payment for debugging','2025-07-16 15:51:55','2025-07-16 15:51:55'),(46,1,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752681115248001','2025-07-16 08:51:55','2025-07-16 08:51:55','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 15:51:55','2025-07-16 15:51:55'),(47,1,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752681115254002','2025-07-16 08:51:55',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 15:51:55','2025-07-16 15:51:55'),(48,2,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752681115259001','2025-07-16 08:51:55','2025-07-16 08:51:55','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 15:51:55','2025-07-16 15:51:55'),(49,2,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752681115264002','2025-07-16 08:51:55',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 15:51:55','2025-07-16 15:51:55'),(50,1,500000.00,50000.00,450000.00,'CASH','PAID','TEST_REF_1752681262762','2025-07-16 08:54:23','2025-07-16 08:54:23','Test payment for debugging','2025-07-16 15:54:22','2025-07-16 15:54:22'),(51,1,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752681262810001','2025-07-16 08:54:23','2025-07-16 08:54:23','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 15:54:22','2025-07-16 15:54:22'),(52,1,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752681262816002','2025-07-16 08:54:23',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 15:54:22','2025-07-16 15:54:22'),(53,2,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752681262820001','2025-07-16 08:54:23','2025-07-16 08:54:23','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 15:54:22','2025-07-16 15:54:22'),(54,2,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752681262824002','2025-07-16 08:54:23',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 15:54:22','2025-07-16 15:54:22'),(55,1,500000.00,50000.00,450000.00,'CASH','PAID','TEST_REF_1752681305259','2025-07-16 08:55:05','2025-07-16 08:55:05','Test payment for debugging','2025-07-16 15:55:05','2025-07-16 15:55:05'),(56,1,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752681305308001','2025-07-16 08:55:05','2025-07-16 08:55:05','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 15:55:05','2025-07-16 15:55:05'),(57,1,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752681305313002','2025-07-16 08:55:05',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 15:55:05','2025-07-16 15:55:05'),(58,2,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752681305316001','2025-07-16 08:55:05','2025-07-16 08:55:05','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 15:55:05','2025-07-16 15:55:05'),(59,2,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752681305321002','2025-07-16 08:55:05',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 15:55:05','2025-07-16 15:55:05'),(60,1,500000.00,50000.00,450000.00,'CASH','PAID','TEST_REF_1752681646994','2025-07-16 09:00:47','2025-07-16 09:00:47','Test payment for debugging','2025-07-16 16:00:47','2025-07-16 16:00:47'),(61,1,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752681647039001','2025-07-16 09:00:47','2025-07-16 09:00:47','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 16:00:47','2025-07-16 16:00:47'),(62,1,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752681647044002','2025-07-16 09:00:47',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 16:00:47','2025-07-16 16:00:47'),(63,2,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752681647049001','2025-07-16 09:00:47','2025-07-16 09:00:47','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 16:00:47','2025-07-16 16:00:47'),(64,2,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752681647053002','2025-07-16 09:00:47',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 16:00:47','2025-07-16 16:00:47'),(65,1,500000.00,50000.00,450000.00,'CASH','PAID','TEST_REF_1752681699806','2025-07-16 09:01:40','2025-07-16 09:01:40','Test payment for debugging','2025-07-16 16:01:39','2025-07-16 16:01:39'),(66,1,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752681699855001','2025-07-16 09:01:40','2025-07-16 09:01:40','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 16:01:39','2025-07-16 16:01:39'),(67,1,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752681699861002','2025-07-16 09:01:40',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 16:01:39','2025-07-16 16:01:39'),(68,2,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752681699866001','2025-07-16 09:01:40','2025-07-16 09:01:40','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 16:01:39','2025-07-16 16:01:39'),(69,2,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752681699871002','2025-07-16 09:01:40',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 16:01:39','2025-07-16 16:01:39'),(70,1,500000.00,50000.00,450000.00,'CASH','PAID','TEST_REF_1752682069165','2025-07-16 09:07:49','2025-07-16 09:07:49','Test payment for debugging','2025-07-16 16:07:49','2025-07-16 16:07:49'),(71,1,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752682069220001','2025-07-16 09:07:49','2025-07-16 09:07:49','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 16:07:49','2025-07-16 16:07:49'),(72,1,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752682069226002','2025-07-16 09:07:49',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 16:07:49','2025-07-16 16:07:49'),(73,2,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752682069232001','2025-07-16 09:07:49','2025-07-16 09:07:49','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 16:07:49','2025-07-16 16:07:49'),(74,2,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752682069242002','2025-07-16 09:07:49',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 16:07:49','2025-07-16 16:07:49'),(75,1,500000.00,50000.00,450000.00,'CASH','PAID','TEST_REF_1752682487592','2025-07-16 09:14:48','2025-07-16 09:14:48','Test payment for debugging','2025-07-16 16:14:47','2025-07-16 16:14:47'),(76,1,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752682487640001','2025-07-16 09:14:48','2025-07-16 09:14:48','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 16:14:47','2025-07-16 16:14:47'),(77,1,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752682487647002','2025-07-16 09:14:48',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 16:14:47','2025-07-16 16:14:47'),(78,2,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752682487653001','2025-07-16 09:14:48','2025-07-16 09:14:48','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 16:14:47','2025-07-16 16:14:47'),(79,2,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752682487658002','2025-07-16 09:14:48',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 16:14:47','2025-07-16 16:14:47'),(80,1,500000.00,50000.00,450000.00,'CASH','PAID','TEST_REF_1752682960252','2025-07-16 09:22:40','2025-07-16 09:22:40','Test payment for debugging','2025-07-16 16:22:40','2025-07-16 16:22:40'),(81,1,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752682960305001','2025-07-16 09:22:40','2025-07-16 09:22:40','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 16:22:40','2025-07-16 16:22:40'),(82,1,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752682960311002','2025-07-16 09:22:40',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 16:22:40','2025-07-16 16:22:40'),(83,2,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752682960315001','2025-07-16 09:22:40','2025-07-16 09:22:40','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 16:22:40','2025-07-16 16:22:40'),(84,2,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752682960319002','2025-07-16 09:22:40',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 16:22:40','2025-07-16 16:22:40'),(85,1,500000.00,50000.00,450000.00,'CASH','PAID','TEST_REF_1752683783625','2025-07-16 09:36:24','2025-07-16 09:36:24','Test payment for debugging','2025-07-16 16:36:23','2025-07-16 16:36:23'),(86,1,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752683783671001','2025-07-16 09:36:24','2025-07-16 09:36:24','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 16:36:23','2025-07-16 16:36:23'),(87,1,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752683783676002','2025-07-16 09:36:24',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 16:36:23','2025-07-16 16:36:23'),(88,2,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752683783679001','2025-07-16 09:36:24','2025-07-16 09:36:24','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 16:36:23','2025-07-16 16:36:23'),(89,2,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752683783683002','2025-07-16 09:36:24',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 16:36:23','2025-07-16 16:36:23'),(90,1,500000.00,50000.00,450000.00,'CASH','PAID','TEST_REF_1752684119871','2025-07-16 09:42:00','2025-07-16 09:42:00','Test payment for debugging','2025-07-16 16:41:59','2025-07-16 16:41:59'),(91,1,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752684119911001','2025-07-16 09:42:00','2025-07-16 09:42:00','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 16:41:59','2025-07-16 16:41:59'),(92,1,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752684119916002','2025-07-16 09:42:00',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 16:41:59','2025-07-16 16:41:59'),(93,2,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752684119919001','2025-07-16 09:42:00','2025-07-16 09:42:00','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 16:41:59','2025-07-16 16:41:59'),(94,2,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752684119923002','2025-07-16 09:42:00',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 16:41:59','2025-07-16 16:41:59'),(95,1,500000.00,50000.00,450000.00,'CASH','PAID','TEST_REF_1752684291820','2025-07-16 09:44:52','2025-07-16 09:44:52','Test payment for debugging','2025-07-16 16:44:51','2025-07-16 16:44:51'),(96,1,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752684291872001','2025-07-16 09:44:52','2025-07-16 09:44:52','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 16:44:51','2025-07-16 16:44:51'),(97,1,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752684291882002','2025-07-16 09:44:52',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 16:44:51','2025-07-16 16:44:51'),(98,2,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752684291887001','2025-07-16 09:44:52','2025-07-16 09:44:52','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 16:44:51','2025-07-16 16:44:51'),(99,2,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752684291892002','2025-07-16 09:44:52',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 16:44:51','2025-07-16 16:44:51'),(100,1,500000.00,50000.00,450000.00,'CASH','PAID','TEST_REF_1752685668382','2025-07-16 10:07:48','2025-07-16 10:07:48','Test payment for debugging','2025-07-16 17:07:48','2025-07-16 17:07:48'),(101,1,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752685668428001','2025-07-16 10:07:48','2025-07-16 10:07:48','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 17:07:48','2025-07-16 17:07:48'),(102,1,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752685668434002','2025-07-16 10:07:48',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 17:07:48','2025-07-16 17:07:48'),(103,2,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752685668439001','2025-07-16 10:07:48','2025-07-16 10:07:48','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 17:07:48','2025-07-16 17:07:48'),(104,2,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752685668444002','2025-07-16 10:07:48',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 17:07:48','2025-07-16 17:07:48'),(105,1,500000.00,50000.00,450000.00,'CASH','PAID','TEST_REF_1752685825653','2025-07-16 10:10:26','2025-07-16 10:10:26','Test payment for debugging','2025-07-16 17:10:25','2025-07-16 17:10:25'),(106,1,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752685825699001','2025-07-16 10:10:26','2025-07-16 10:10:26','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 17:10:25','2025-07-16 17:10:25'),(107,1,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752685825704002','2025-07-16 10:10:26',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 17:10:25','2025-07-16 17:10:25'),(108,2,850000.00,85000.00,765000.00,'CASH','PAID','SPA1752685825708001','2025-07-16 10:10:26','2025-07-16 10:10:26','Thanh toán dịch vụ massage và chăm sóc da','2025-07-16 17:10:25','2025-07-16 17:10:25'),(109,2,650000.00,65000.00,585000.00,'BANK_TRANSFER','PENDING','SPA1752685825713002','2025-07-16 10:10:26',NULL,'Chờ xác nhận chuyển khoản','2025-07-16 17:10:25','2025-07-16 17:10:25'),(110,113,2640000.00,240000.00,2400000.00,'BANK_TRANSFER','PENDING','SPA067217234','2025-07-16 11:00:07',NULL,'Thanh toán qua QR Code','2025-07-16 18:00:06','2025-07-16 18:00:06'),(111,113,16610000.00,1510000.00,15100000.00,'BANK_TRANSFER','PENDING','SPA383023916','2025-07-16 21:00:38',NULL,'Thanh toán qua QR Code','2025-07-17 04:00:38','2025-07-17 04:00:38'),(112,113,2860000.00,260000.00,2600000.00,'BANK_TRANSFER','PAID','SPA469611316','2025-07-17 03:50:47','2025-07-17 03:50:47','Thanh toán qua QR Code','2025-07-17 10:50:46','2025-07-17 10:50:46'),(113,113,11770000.00,1070000.00,10700000.00,'BANK_TRANSFER','PAID','SPA348251767','2025-07-17 07:20:35','2025-07-17 07:20:35','Thanh toán qua QR Code','2025-07-17 14:20:34','2025-07-17 14:20:34');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promotion_usage_history`
--

DROP TABLE IF EXISTS `promotion_usage_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotion_usage_history` (
  `usage_id` int NOT NULL AUTO_INCREMENT,
  `promotion_id` int NOT NULL,
  `customer_id` int NOT NULL,
  `payment_id` int NOT NULL COMMENT 'Liên kết đến hóa đơn đã áp dụng mã',
  `used_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`usage_id`),
  KEY `idx_promotion_customer` (`promotion_id`,`customer_id`),
  KEY `fk_usage_customer` (`customer_id`),
  KEY `fk_usage_payment` (`payment_id`),
  CONSTRAINT `fk_usage_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`),
  CONSTRAINT `fk_usage_payment` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`payment_id`),
  CONSTRAINT `fk_usage_promotion` FOREIGN KEY (`promotion_id`) REFERENCES `promotions` (`promotion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Lịch sử khách hàng sử dụng mã khuyến mãi.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotion_usage_history`
--

LOCK TABLES `promotion_usage_history` WRITE;
/*!40000 ALTER TABLE `promotion_usage_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `promotion_usage_history` ENABLE KEYS */;
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
  `customer_condition` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'ALL' COMMENT 'Điều kiện khách hàng: ALL, INDIVIDUAL, COUPLE, GROUP',
  PRIMARY KEY (`promotion_id`),
  UNIQUE KEY `promotion_code` (`promotion_code`),
  KEY `created_by_user_id` (`created_by_user_id`),
  KEY `applies_to_service_id` (`applies_to_service_id`),
  CONSTRAINT `promotions_ibfk_1` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `promotions_ibfk_2` FOREIGN KEY (`applies_to_service_id`) REFERENCES `services` (`service_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotions`
--

LOCK TABLES `promotions` WRITE;
/*!40000 ALTER TABLE `promotions` DISABLE KEYS */;
INSERT INTO `promotions` VALUES (1,'Chào Hè Rực Rỡ - Giảm 20%','Giảm giá 20% cho tất cả dịch vụ massage.','SUMMER20','PERCENTAGE',20.00,NULL,500000.00,'2025-05-31 17:00:00','2025-09-01 16:59:59','ACTIVE',1,100,10,'SPECIFIC_SERVICES','[1, 2]','/uploads/promotions/1753019216785_promotion.jpg','Áp dụng cho các dịch vụ massage. Không áp dụng cùng KM khác.',1,0,'2025-06-01 09:40:23','2025-07-20 13:46:56','ALL'),(2,'Tri Ân Khách Hàng - Tặng Voucher 100K','Tặng voucher 100.000 VNĐ cho hóa đơn từ 1.000.000 VNĐ.','THANKS100K','FIXED_AMOUNT',100000.00,NULL,1000000.00,'2025-07-01 00:00:00','2025-07-31 23:59:59','ACTIVE',1,200,0,'ENTIRE_APPOINTMENT',NULL,'https://placehold.co/400x200/E6E6FA/333333?text=VoucherPromo','Mỗi khách hàng được sử dụng 1 lần.',2,0,'2025-06-01 09:40:23','2025-07-17 22:03:38','ALL'),(3,'Đi Cùng Bạn Bè - Miễn Phí 1 Dịch Vụ Gội Đầu','Khi đặt 2 dịch vụ bất kỳ, tặng 1 dịch vụ gội đầu thảo dược.','FRIENDSFREE','FREE_SERVICE',6.00,NULL,800000.00,'2025-06-15 00:00:00','2025-07-15 23:59:59','INACTIVE',1,50,5,'ENTIRE_APPOINTMENT',NULL,'https://placehold.co/400x200/B0C4DE/333333?text=FriendsPromo','Dịch vụ tặng kèm là Gội Đầu Thảo Dược (ID: 6).',1,0,'2025-06-01 09:40:23','2025-07-17 22:03:38','ALL'),(4,'Giảm 50K cho hóa đơn trên 300K','Giảm trực tiếp 50,000đ cho tất cả các dịch vụ khi tổng hóa đơn của bạn từ 300,000đ trở lên.','BIGSALE5OK','FIXED_AMOUNT',50000.00,NULL,0.00,'2025-07-22 17:00:00','2025-08-09 16:59:59','ACTIVE',NULL,NULL,0,'ENTIRE_APPOINTMENT',NULL,'/uploads/promotions/1753022591204_promotion.png',NULL,NULL,0,'2025-07-20 14:43:11','2025-07-22 19:18:34','ALL'),(5,'Đi 4 tính tiền 3','Rủ hội bạn thân đi làm đẹp! Khi đặt lịch cho nhóm 4 người, bạn sẽ được miễn phí 1 suất có giá trị thấp nhất.','BUY4FREE1','PERCENTAGE',25.00,NULL,0.00,'2025-07-26 17:00:00','2025-08-20 16:59:59','SCHEDULED',NULL,NULL,0,'ENTIRE_APPOINTMENT',NULL,'/uploads/promotions/1753022968018_promotion.png',NULL,NULL,0,'2025-07-20 14:49:28','2025-07-20 14:49:28','GROUP'),(6,'Tự động giảm 30K cho khách hàng thân thiết','Tri ân khách hàng đã gắn bó, tự động giảm 30,000đ cho lần đặt lịch tiếp theo.','AUTO30K','FIXED_AMOUNT',30000.00,NULL,0.00,'2025-07-19 17:00:00','2025-07-31 16:59:59','ACTIVE',NULL,NULL,0,'ENTIRE_APPOINTMENT',NULL,'/uploads/promotions/1753023097242_promotion.png',NULL,NULL,0,'2025-07-20 14:51:37','2025-07-20 14:51:37','INDIVIDUAL'),(7,'Giảm 20% cho lần massage đầu tiên','Ưu đãi chào mừng khách hàng mới! Giảm ngay 20% cho bất kỳ liệu trình massage nào khi bạn đặt lịch lần đầu tiên tại spa.','BIGSALE50','PERCENTAGE',20.00,NULL,0.00,'2025-07-30 17:00:00','2025-08-07 16:59:59','SCHEDULED',NULL,NULL,0,'ENTIRE_APPOINTMENT',NULL,'/uploads/promotions/1753023305186_promotion.png',NULL,NULL,0,'2025-07-20 14:55:05','2025-07-20 14:55:05','ALL'),(8,'Giảm 50K cho hóa đơn trên 500K','Thư giãn nhiều hơn, trả tiền ít hơn. Giảm ngay 50,000đ khi tổng giá trị hóa đơn của bạn từ 500,000đ trở lên.','RELAX50','FIXED_AMOUNT',50000.00,NULL,0.00,'2025-07-07 17:00:00','2025-08-09 16:59:59','ACTIVE',NULL,NULL,0,'ENTIRE_APPOINTMENT',NULL,NULL,NULL,NULL,0,'2025-07-20 14:57:45','2025-07-20 14:57:45','ALL'),(9,'Giảm 15% Massage đá nóng','Trải nghiệm liệu pháp massage đá nóng giúp thư giãn sâu và giảm căng cơ với ưu đãi đặc biệt giảm 15%','HOTSTONE15','PERCENTAGE',15.00,NULL,0.00,'2025-07-14 17:00:00','2025-08-05 16:59:59','ACTIVE',NULL,NULL,0,'ENTIRE_APPOINTMENT',NULL,'/uploads/promotions/1753023677731_promotion.png',NULL,NULL,0,'2025-07-20 15:01:17','2025-07-20 15:01:17','ALL'),(10,'Tự động giảm 30K tri ân','Cảm ơn bạn đã luôn tin tưởng! Spa tự động giảm 30,000đ cho lần đặt lịch tiếp theo như một lời tri ân.','HOTSTONE16','FIXED_AMOUNT',30000.00,NULL,0.00,'2025-07-22 17:00:00','2025-08-08 16:59:59','ACTIVE',NULL,NULL,0,'ENTIRE_APPOINTMENT',NULL,'/uploads/promotions/1753023814297_promotion.png',NULL,NULL,0,'2025-07-20 15:03:34','2025-07-22 19:18:34','ALL');
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
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiry_date` datetime NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`)
) ENGINE=InnoDB AUTO_INCREMENT=528 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `remember_me_tokens`
--

LOCK TABLES `remember_me_tokens` WRITE;
/*!40000 ALTER TABLE `remember_me_tokens` DISABLE KEYS */;
INSERT INTO `remember_me_tokens` VALUES (11,'quangkhoa5112@5dulieu.com','123456789','0cb51cb5-2380-4033-acdc-f3cd9fa385ce','2025-07-06 09:36:14','2025-06-06 09:36:13'),(24,'xapymabo@mailinator.com','A123456a@','aae04773-83ea-47ae-b622-9712d48c53f8','2025-07-07 08:05:55','2025-06-07 08:05:54'),(97,'therapist@beautyzone.com','123456','fc4ac81a-adca-4486-b47d-1ecb4d2a1a0b','2025-07-14 17:58:55','2025-06-14 17:58:55'),(149,'khoatqhe150834@fpt.edu.vn','123456','8bb29688-a91f-4ff6-b85f-6b0fcee17e56','2025-07-17 20:17:45','2025-06-17 20:17:44'),(520,'vucongdat28032003@gmail.com','123456789','90568a4e-25a6-49d2-802d-fd3cf27007d8','2025-08-21 12:00:48','2025-07-22 19:00:48'),(526,'admin@beautyzone.com','123456','aed481de-eb7c-41ae-8c02-ed0e75648e47','2025-08-21 14:04:34','2025-07-22 21:04:34'),(527,'manager@beautyzone.com','123456','57c809e2-2bb2-48e6-891e-d26e5a09c34f','2025-08-22 02:36:42','2025-07-23 09:36:42');
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'ADMIN','Quản trị viên','Quản lý toàn bộ hệ thống','2025-06-01 09:40:23','2025-06-01 09:40:23'),(2,'MANAGER','Quản lý Spa','Quản lý hoạt động hàng ngày của spa','2025-06-01 09:40:23','2025-06-01 09:40:23'),(3,'THERAPIST','Kỹ thuật viên','Thực hiện các dịch vụ cho khách hàng','2025-06-01 09:40:23','2025-06-01 09:40:23'),(4,'RECEPTIONIST','Lễ tân','Tiếp đón khách, đặt lịch, thu ngân','2025-06-01 09:40:23','2025-06-01 09:40:23'),(5,'CUSTOMER','Khách hàng đã đăng ký','Khách hàng có tài khoản trên hệ thống','2025-06-01 09:40:23','2025-06-04 04:20:04'),(6,'MARKETING','Quản trị marketing','Quản lý hoạt động marketing của spa','2025-06-25 02:07:59','2025-06-25 02:07:59'),(7,'INVENTORY_MANAGER','Quản lý kho','Quản lý vật tư, nhập xuất kho, kiểm kê','2025-07-16 06:45:56','2025-07-16 06:45:56');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rooms` (
  `room_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Room name or identifier (e.g., Room A, VIP Suite)',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Description of the room (e.g., features, ambiance)',
  `capacity` int NOT NULL DEFAULT '1' COMMENT 'Number of beds the room can accommodate',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 if room is available for use, 0 if decommissioned or under maintenance',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`room_id`),
  CONSTRAINT `chk_capacity_positive` CHECK ((`capacity` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Stores information about physical rooms in the spa';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES (1,'Room A','Standard room for individual treatments',1,1,'2025-07-17 16:22:20','2025-07-17 16:22:20'),(2,'VIP Suite','Luxury suite for couples with two beds',2,1,'2025-07-17 16:22:20','2025-07-17 16:22:20'),(3,'Room B','Room for facial or massage treatments',1,1,'2025-07-17 16:22:20','2025-07-17 16:22:20'),(4,'Maintenance Room','Under maintenance, not available',1,0,'2025-07-17 16:22:20','2025-07-17 16:22:20');
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scheduling_sessions`
--

DROP TABLE IF EXISTS `scheduling_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
  UNIQUE KEY `unique_active_payment_session` (`payment_id`,`manager_user_id`),
  KEY `idx_payment_id` (`payment_id`),
  KEY `idx_manager_user_id` (`manager_user_id`),
  KEY `idx_session_status` (`session_status`),
  KEY `idx_expires_at` (`expires_at`),
  CONSTRAINT `scheduling_sessions_ibfk_1` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`payment_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `scheduling_sessions_ibfk_2` FOREIGN KEY (`manager_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Track scheduling sessions to prevent conflicts';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scheduling_sessions`
--

LOCK TABLES `scheduling_sessions` WRITE;
/*!40000 ALTER TABLE `scheduling_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `scheduling_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_images`
--

DROP TABLE IF EXISTS `service_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_images` (
  `image_id` int NOT NULL AUTO_INCREMENT,
  `service_id` int NOT NULL,
  `url` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Relative path or URL to the image file (e.g., /images/services/service_1_1.jpg)',
  `alt_text` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Alternative text for accessibility and SEO',
  `is_primary` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 if this is the primary image for the service, 0 otherwise',
  `sort_order` int DEFAULT '0' COMMENT 'Order for displaying images (0 = highest priority)',
  `caption` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'Short description or title of the image',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 if image is visible, 0 if hidden',
  `file_size` int DEFAULT NULL COMMENT 'File size of the image in bytes',
  `uploaded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Time the image was uploaded',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last update time for the image record',
  PRIMARY KEY (`image_id`),
  KEY `idx_service_id` (`service_id`),
  KEY `idx_is_active` (`is_active`),
  CONSTRAINT `service_images_ibfk_1` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Stores multiple images for each service with metadata';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_images`
--

LOCK TABLES `service_images` WRITE;
/*!40000 ALTER TABLE `service_images` DISABLE KEYS */;
INSERT INTO `service_images` VALUES (87,1,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752471576/services/1/9f14d87e-91ca-473b-b76f-7420383810aa.jpg','Service image for massage.jpg',1,1,'Uploaded via TestController',1,NULL,'2025-07-14 05:39:37','2025-07-14 05:39:37'),(88,1,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752471578/services/1/bc71c550-2dab-4b25-af30-cc8f3967dba9.jpg','Service image for sakura-massage-spa.jpg',0,2,'Uploaded via TestController',1,NULL,'2025-07-14 05:39:39','2025-07-14 05:39:39'),(89,2,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752471688/services/2/c861d4ba-158d-42a3-919c-92f9cb7a2a31.jpg','Service image for Adult-woman-having-hot-stone-m-1024x768.jpg',1,1,'Uploaded via TestController',1,NULL,'2025-07-14 05:41:28','2025-07-14 05:41:28'),(90,2,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752471690/services/2/ea59b084-d37b-4053-9ba3-3e2e4aef1382.jpg','Service image for hot-stone-massage.jpg',0,2,'Uploaded via TestController',1,NULL,'2025-07-14 05:41:30','2025-07-14 05:41:30'),(91,3,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752471805/services/3/f48e022f-5332-44f2-a4a4-b76804f0c9d0.jpg','Service image for 20201107_cach-cham-soc-da-mat-hang-ngay-1.jpg',1,1,'Uploaded via TestController',1,NULL,'2025-07-14 05:43:25','2025-07-14 05:43:25'),(92,3,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752471806/services/3/c1b57e77-2e27-4790-a6d8-f42c22a6e8ec.webp','Service image for nganh-cham-soc-da-mo-ra-nhieu-co-hoi-nghe-nghiep-9fea782b-c3da-4e97-a9b8-7dc3da79eb26.webp',0,2,'Uploaded via TestController',1,NULL,'2025-07-14 05:43:27','2025-07-14 05:43:27'),(93,4,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752471974/services/4/b27dbde2-258c-4859-b137-a9d5bb8958aa.jpg','Service image for 20240424140334.jpg',1,1,'Uploaded via TestController',1,NULL,'2025-07-14 05:46:14','2025-07-14 05:46:14'),(94,4,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752471976/services/4/2d0d900e-5b42-4727-8642-5406c7e6d894.png','Service image for tri-mun-dung-nguyen-spa1.png',0,2,'Uploaded via TestController',1,NULL,'2025-07-14 05:46:17','2025-07-14 05:46:17'),(95,5,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752472121/services/5/b7aa6723-d9a0-4f6c-91c2-8da732aa10a6.jpg','Service image for tay-da-chet-1.jpg',1,1,'Uploaded via TestController',1,NULL,'2025-07-14 05:48:42','2025-07-14 05:48:42'),(96,5,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752472124/services/5/b9bb999d-6aa6-4df6-9174-3a9db2274433.png','Service image for tay-te-bao-chet-da-mat-06.png',0,2,'Uploaded via TestController',1,NULL,'2025-07-14 05:48:44','2025-07-14 05:48:44'),(97,6,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752472169/services/6/cb0739e0-2760-49e2-8d0c-fc2ffa772625.webp','Service image for Mot_so_dieu_can_biet_khi_goi_dau_bang_thao_duoc_thien_nhien_1_6e9385774c.webp',1,1,'Uploaded via TestController',1,NULL,'2025-07-14 05:49:29','2025-07-14 05:49:29'),(98,6,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752472170/services/6/217bda47-5405-4701-9a67-1ba276a2d3fd.jpg','Service image for tai-sao-nen-goi-dau-duong-sinh-thao-duoc-1.jpg',0,2,'Uploaded via TestController',1,NULL,'2025-07-14 05:49:31','2025-07-14 05:49:31'),(99,7,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752472253/services/7/bae4c82c-49ba-4487-a0b6-307f1bf49a21.webp','Service image for dia-chi-massage-tphcm-3.webp',1,1,'Uploaded via TestController',1,NULL,'2025-07-14 05:50:54','2025-07-14 05:50:54'),(100,7,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752472256/services/7/43f92a2b-5783-4c4d-a899-b36b75dc7568.jpg','Service image for -Massage-bam-huyet-ap-la-thuoc-ong-Y-tri-lieu-Cot-song-That-lung.jpeg',0,2,'Uploaded via TestController',1,NULL,'2025-07-14 05:50:57','2025-07-14 05:50:57'),(101,7,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752472336/services/7/bf035931-2a3b-4ede-90e6-4ac651d81438.avif','Service image for 67aae87b-b7d8-4bd6-975b-06103831f6e2_eee40472.avif',1,1,'Uploaded via TestController',1,NULL,'2025-07-14 05:52:16','2025-07-14 05:52:16'),(102,7,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752472337/services/7/0cc2707f-7236-491e-afef-84ba4fa06859.webp','Service image for big-ticket-image-6098b643490c8295174682-cropped600-400.jpg.webp',0,2,'Uploaded via TestController',1,NULL,'2025-07-14 05:52:18','2025-07-14 05:52:18'),(103,8,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752472362/services/8/cdfa8097-bd32-45f7-bf4e-470a07885aad.avif','Service image for 67aae87b-b7d8-4bd6-975b-06103831f6e2_eee40472.avif',1,1,'Uploaded via TestController',1,NULL,'2025-07-14 05:52:42','2025-07-14 05:52:42'),(104,8,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752472363/services/8/38fa657a-220d-4164-9d99-73e66418ec1c.webp','Service image for big-ticket-image-6098b643490c8295174682-cropped600-400.jpg.webp',0,2,'Uploaded via TestController',1,NULL,'2025-07-14 05:52:43','2025-07-14 05:52:43'),(105,9,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752472450/services/9/8daabb6c-f3de-465c-baa4-57791a486b94.jpg','Service image for massage-foot-2386.jpg',1,1,'Uploaded via TestController',1,NULL,'2025-07-14 05:54:10','2025-07-14 05:54:10'),(106,9,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752472452/services/9/b5c47954-1918-45be-ab3c-71f52cb26787.jpg','Service image for top-10-dia-chi-massage-chan-gan-day-tot-nhat-tai-tphcm-20230530111507-276043.jpg',0,2,'Uploaded via TestController',1,NULL,'2025-07-14 05:54:12','2025-07-14 05:54:12'),(107,10,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752472569/services/10/d79b21e5-8d0e-404d-8dcf-b2ec70076636.jpg','Service image for massage (1).jpg',1,1,'Uploaded via TestController',1,NULL,'2025-07-14 05:56:09','2025-07-14 05:56:09'),(108,10,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752472570/services/10/13662bb5-789e-4819-9acd-624bfbc2ec07.webp','Service image for n2.webp',0,2,'Uploaded via TestController',1,NULL,'2025-07-14 05:56:11','2025-07-14 05:56:11'),(109,27,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752472669/services/27/f990545d-adad-4caa-ae6d-f90768bf3d2d.jpg','Service image for 21.jpg',1,1,'Uploaded via TestController',1,NULL,'2025-07-14 05:57:49','2025-07-14 05:57:49'),(110,27,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752472671/services/27/40fcf601-110d-42bd-8909-b64523dc91a4.webp','Service image for young-lady-showing-her-red-manicure-pedicure-nails-young-lady-showing-her-red-manicure-pedicure-nails-rose-142082356.webp',0,2,'Uploaded via TestController',1,NULL,'2025-07-14 05:57:51','2025-07-14 05:57:51'),(111,71,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752472778/services/71/4237de8e-37a1-4677-a478-1719b8306928.jpg','Service image for B3-BE888_sensor_M_20180723160955.jpg',1,1,'Uploaded via TestController',1,NULL,'2025-07-14 05:59:39','2025-07-14 05:59:39'),(112,71,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752472780/services/71/b101ddd8-d2a2-4728-87dd-9401d2defca4.png','Service image for float-therapy.png',0,2,'Uploaded via TestController',1,NULL,'2025-07-14 05:59:41','2025-07-14 05:59:41'),(113,72,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752472859/services/72/0bda7958-8789-42e3-8f8e-058d7aba8ee7.jpg','Service image for bon-tam-rai-hoa-hong-2_441ccdc2297a4b5c8905257b3236ce87_grande.jpg',1,1,'Uploaded via TestController',1,NULL,'2025-07-14 06:01:00','2025-07-14 06:01:00'),(114,72,'https://res.cloudinary.com/dj5wpyfvh/image/upload/v1752472861/services/72/a3e3d846-6784-401f-8001-c6065456f0ca.jpg','Service image for o-dau-ban-bon-cau-viglacera-thiet-bi-ve-sinh-cao-cap-gia-tot-1.jpg',0,2,'Uploaded via TestController',1,NULL,'2025-07-14 06:01:02','2025-07-14 06:01:02');
/*!40000 ALTER TABLE `service_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_material`
--

DROP TABLE IF EXISTS `service_material`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_material` (
  `service_material_id` int NOT NULL AUTO_INCREMENT,
  `service_id` int NOT NULL,
  `inventory_item_id` int NOT NULL,
  `quantity_per_service` int NOT NULL,
  PRIMARY KEY (`service_material_id`),
  KEY `service_id` (`service_id`),
  KEY `inventory_item_id` (`inventory_item_id`),
  CONSTRAINT `service_material_ibfk_1` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`),
  CONSTRAINT `service_material_ibfk_2` FOREIGN KEY (`inventory_item_id`) REFERENCES `inventory_item` (`inventory_item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_material`
--

LOCK TABLES `service_material` WRITE;
/*!40000 ALTER TABLE `service_material` DISABLE KEYS */;
INSERT INTO `service_material` VALUES (1,1,1,50),(2,1,2,1),(3,2,1,70),(4,2,2,1),(5,2,5,10),(6,3,3,1),(7,3,6,1),(8,27,2,1),(9,27,7,1),(10,27,4,1);
/*!40000 ALTER TABLE `service_material` ENABLE KEYS */;
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
  `booking_id` int NOT NULL COMMENT 'ID của lịch hẹn đã hoàn thành mà review này dành cho.',
  `rating` tinyint unsigned NOT NULL COMMENT 'Điểm đánh giá (1-5)',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_visible` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1: Hiện, 0: Ẩn review khỏi public',
  `manager_reply` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Phản hồi của manager cho review này',
  PRIMARY KEY (`review_id`),
  KEY `service_id` (`service_id`),
  KEY `customer_id` (`customer_id`),
  KEY `service_reviews_ibfk_3` (`booking_id`),
  CONSTRAINT `service_reviews_ibfk_1` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`) ON DELETE CASCADE,
  CONSTRAINT `service_reviews_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE,
  CONSTRAINT `service_reviews_ibfk_3` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_reviews`
--

LOCK TABLES `service_reviews` WRITE;
/*!40000 ALTER TABLE `service_reviews` DISABLE KEYS */;
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
INSERT INTO `spa_information` VALUES (1,'BeautyZone','Số 10 Đường An Bình','Phường Yên Hòa','Hà Nội','100000','Việt Nam','02412345678','0912345678','contact@annhienspa.vn','support@annhienspa.vn','https://annhienspa.vn','https://placehold.co/200x100/E6F2FF/333333?text=AnNhienLogo','0123456789','Vui lòng hủy lịch trước 24 giờ để tránh phí hủy. Chi tiết xem tại website.','Điều khoản đặt lịch chi tiết có tại quầy lễ tân và website của spa.','Nơi bạn tìm thấy sự thư giãn và tái tạo năng lượng.','An nhiên Spa cung cấp các dịch vụ chăm sóc sức khỏe và sắc đẹp hàng đầu với đội ngũ chuyên nghiệp và không gian yên tĩnh.',10.00,15,'2025-06-01 09:40:23','2025-07-16 04:12:42');
/*!40000 ALTER TABLE `spa_information` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplier`
--

DROP TABLE IF EXISTS `supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier` (
  `supplier_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`supplier_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier`
--

LOCK TABLES `supplier` WRITE;
/*!40000 ALTER TABLE `supplier` DISABLE KEYS */;
INSERT INTO `supplier` VALUES (1,'Công ty TNHH Mỹ Phẩm ABC','SĐT: 0901234567, Email: abc@mypham.com',1),(2,'Công ty Dụng Cụ Spa XYZ','SĐT: 0912345678, Email: xyz@dungcuspa.com',1),(3,'Công ty Vật Tư Y Tế DEF','SĐT: 0933333333, Email: def@yt.com',1);
/*!40000 ALTER TABLE `supplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `therapist_schedules`
--

DROP TABLE IF EXISTS `therapist_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `therapist_schedules` (
  `schedule_id` int NOT NULL AUTO_INCREMENT,
  `therapist_user_id` int NOT NULL COMMENT 'FK đến users.user_id của kỹ thuật viên',
  `start_datetime` datetime NOT NULL COMMENT 'Thời gian bắt đầu của ca làm việc hoặc khoảng thời gian cụ thể',
  `end_datetime` datetime NOT NULL COMMENT 'Thời gian kết thúc của ca làm việc hoặc khoảng thời gian cụ thể',
  `is_available` tinyint(1) DEFAULT '1' COMMENT 'TRUE nếu làm việc, FALSE nếu là giờ nghỉ đã đăng ký trong ca',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Ví dụ: Ca sáng, Ca chiều, Nghỉ đột xuất, Họp',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`schedule_id`),
  KEY `idx_therapist_schedule_datetimes` (`therapist_user_id`,`start_datetime`,`end_datetime`),
  CONSTRAINT `therapist_schedules_ibfk_1` FOREIGN KEY (`therapist_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `therapist_schedules`
--

LOCK TABLES `therapist_schedules` WRITE;
/*!40000 ALTER TABLE `therapist_schedules` DISABLE KEYS */;
INSERT INTO `therapist_schedules` VALUES (5,3,'2025-06-05 09:00:00','2025-06-05 18:00:00',1,'Ca làm việc ngày 05/06','2025-06-01 09:40:23','2025-06-01 09:40:23'),(6,3,'2025-06-06 09:00:00','2025-06-06 12:00:00',1,'Ca sáng ngày 06/06','2025-06-01 09:40:23','2025-06-01 09:40:23'),(7,3,'2025-06-06 12:00:00','2025-06-06 13:00:00',0,'Nghỉ trưa','2025-06-01 09:40:23','2025-06-01 09:40:23'),(8,3,'2025-06-06 13:00:00','2025-06-06 18:00:00',1,'Ca chiều ngày 06/06','2025-06-01 09:40:23','2025-06-01 09:40:23'),(9,4,'2025-06-05 13:00:00','2025-06-05 21:00:00',1,'Ca làm việc ngày 05/06','2025-06-01 09:40:23','2025-06-01 09:40:23');
/*!40000 ALTER TABLE `therapist_schedules` ENABLE KEYS */;
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
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,1,'Nguyễn Văn An','quangkhoa5112@5dulieu.com','$2a$10$Q8m8OY5RIEWeo1alSpOx1up8kZLEz.QDkfiKfyBlbO3GN0ySqwEm.','0912345678','MALE','1980-01-15',NULL,NULL,1,'2025-06-01 09:40:23','2025-06-01 09:40:23','2025-07-11 05:26:24'),(2,2,'Trần Thị Bình','manager123@spademo.com','$2b$10$abcdefghijklmnopqrstuv','0987654321','FEMALE','1985-05-20','',NULL,1,'2025-06-01 09:40:23','2025-06-01 09:40:23','2025-07-21 10:43:16'),(3,3,'Lê Minh Cường','therapist1@spademo.com','$2b$10$abcdefghijklmnopqrstuv','0905112233','MALE','1990-09-10','thanh xuyen 4 , pho yen , thai nguyen123',NULL,1,'2025-06-01 09:40:23','2025-06-01 09:40:23','2025-07-21 15:34:17'),(4,3,'Phạm Thị Dung','therapist2@spademo.com','$2a$10$OVBrE/4NZQt9PLxUsoEdG.ixzbd9nKCqnO6pQP4pVETHkqut3AI4i','0905445566','FEMALE','1992-12-01',NULL,NULL,1,'2025-06-01 09:40:23','2025-06-01 09:40:23','2025-07-21 15:42:51'),(5,4,'Hoàng Văn Em','receptionist@spademo.com','$2b$10$abcdefghijklmnopqrstuv','0918778899','MALE','1995-03-25',NULL,NULL,1,'2025-06-01 09:40:23','2025-06-01 09:40:23','2025-07-11 05:26:24'),(6,1,'Nguyễn Văn Admin','admin@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234567','MALE','1985-01-15',NULL,NULL,1,NULL,'2025-06-04 03:47:10','2025-07-11 05:26:24'),(7,2,'Trần Thị Manager','manager@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234568','FEMALE','1988-03-20','',NULL,1,NULL,'2025-06-04 03:57:48','2025-07-23 02:36:36'),(8,3,'Lê Văn Therapist','therapist@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234569','MALE','1990-07-10',NULL,NULL,1,NULL,'2025-06-04 03:57:48','2025-07-11 05:26:24'),(9,4,'Phạm Thị Receptionist','receptionist@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234570','FEMALE','1992-11-25',NULL,NULL,1,NULL,'2025-06-04 03:57:48','2025-07-11 05:26:24'),(10,1,'Hoàng Minh Quản Trị','admin2@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234571','MALE','1987-05-12',NULL,NULL,1,NULL,'2025-06-04 03:57:48','2025-07-11 05:26:24'),(11,3,'Nguyễn Thị Spa Master','therapist2@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234572','FEMALE','1989-09-18',NULL,NULL,1,NULL,'2025-06-04 03:57:48','2025-07-11 05:26:24'),(12,3,'Mai Anh Tuấn','therapist3@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234573','MALE','1991-04-12',NULL,NULL,1,NULL,'2025-06-18 01:49:35','2025-07-11 05:26:24'),(13,3,'Trần Ngọc Bích','therapist4@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234574','FEMALE','1993-08-22',NULL,NULL,1,NULL,'2025-06-18 01:49:35','2025-07-11 05:26:24'),(14,3,'Vũ Minh Đức','therapist5@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234575','MALE','1989-11-05','thanh xuyen 4 ,Thai Nguyen,Pho yen123',NULL,1,NULL,'2025-06-18 01:49:35','2025-07-21 15:33:53'),(15,3,'Hoàng Thị Thu','therapist6@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234576','FEMALE','1995-02-18',NULL,NULL,1,NULL,'2025-06-18 01:49:35','2025-07-11 05:26:24'),(16,3,'Đặng Văn Long','therapist7@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234577','MALE','1988-06-30',NULL,NULL,1,NULL,'2025-06-18 01:49:35','2025-07-11 05:26:24'),(17,3,'Ngô Mỹ Linh','therapist8@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234578','FEMALE','1992-07-21',NULL,NULL,1,NULL,'2025-06-18 01:49:35','2025-07-11 05:26:24'),(18,3,'Bùi Quang Huy','therapist9@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234579','MALE','1996-01-09',NULL,NULL,1,NULL,'2025-06-18 01:49:35','2025-07-11 05:26:24'),(19,3,'Đỗ Phương Thảo','therapist10@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234580','FEMALE','1994-03-14',NULL,NULL,1,NULL,'2025-06-18 01:49:35','2025-07-11 05:26:24'),(20,3,'Lương Thế Vinh','therapist11@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234581','MALE','1998-10-25',NULL,NULL,1,NULL,'2025-06-18 01:49:35','2025-07-11 05:26:24'),(21,6,'Phan Thị Diễm','marketing@beautyzone.com','$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW','0901234582','FEMALE','1990-12-03',NULL,NULL,1,NULL,'2025-06-18 01:49:35','2025-07-11 05:26:24'),(22,7,'Nguyễn Thị Kho','inventory@beautyzone.com','$2a$10$testhashinventory','0909999999','FEMALE','1990-01-01','123 Đường Kho, Quận 1',NULL,1,NULL,'2025-07-16 06:45:56','2025-07-16 06:45:56'),(23,2,'Nguyen Dat','dat123@spamanagement.com','$2a$10$klZfCbtobkQ3up8FoE2qgeuZ2sITi7dDG/IhJOuO5nLKr50BqjJme','0908098943','MALE',NULL,'thanh xuyen 4 , pho yen , thai nguyen123',NULL,0,NULL,'2025-07-21 10:40:16','2025-07-21 10:40:16'),(24,3,'NguyenDat','therapist-nguyendat245@spamanagement.com','$2a$10$D.m3C.JDeQ29Xrr8MfJGbOg7vX3vz4BZ9iSduaryI6T7ZSe2L0vs6','0908098912','MALE','2004-01-04','thanh xuyen 4 , pho yen , thai nguyen123',NULL,0,NULL,'2025-07-21 18:28:08','2025-07-21 18:28:08');
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

-- Dump completed on 2025-07-23  9:37:00
