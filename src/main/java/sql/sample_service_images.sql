-- Sample service images data for testing
-- This file adds sample images to the service_images table

USE `spamanagement`;

-- Insert sample images for different services
INSERT INTO service_images (service_id, url, alt_text, is_primary, sort_order, caption, is_active, file_size) VALUES
-- Service 1: Massage Thụy Điển
(1, '/uploads/services/full-size/service_1_1_full.png', 'Swedish Massage Room', 1, 0, 'Relaxing Swedish massage treatment', 1, 150000),
(1, '/uploads/services/full-size/service_1_2_full.png', 'Swedish Massage Oils', 0, 1, 'Premium massage oils used', 1, 120000),

-- Service 2: Massage Đá Nóng  
(2, '/uploads/services/full-size/service_2_1_full.png', 'Hot Stone Massage Setup', 1, 0, 'Hot stone massage with heated basalt stones', 1, 202786),
(2, '/uploads/services/full-size/service_2_2_full.png', 'Hot Stone Massage Therapy', 0, 1, 'Professional hot stone therapy', 1, 180000),

-- Service 3: Chăm Sóc Da Cơ Bản
(3, '/uploads/services/full-size/service_3_1_full.png', 'Basic Facial Treatment', 1, 0, 'Cleansing and moisturizing facial', 1, 165000),
(3, '/uploads/services/full-size/service_3_2_full.png', 'Facial Mask Application', 0, 1, 'Nourishing facial mask treatment', 1, 145000),

-- Service 4: Trị Mụn Chuyên Sâu
(4, '/uploads/services/full-size/service_4_1_full.png', 'Acne Treatment Room', 1, 0, 'Professional acne treatment', 1, 175000),

-- Service 5: Tẩy Tế Bào Chết Toàn Thân
(5, '/uploads/services/full-size/service_5_1_full.png', 'Body Scrub Treatment', 1, 0, 'Full body exfoliation treatment', 1, 190000),

-- Service 6: Gội Đầu Thảo Dược
(6, '/uploads/services/full-size/service_6_1_full.png', 'Herbal Hair Wash', 1, 0, 'Traditional herbal hair treatment', 1, 130000),

-- Service 7: Massage Thái Cổ Truyền
(7, '/uploads/services/full-size/service_7_1_full.png', 'Thai Traditional Massage', 1, 0, 'Authentic Thai massage therapy', 1, 210000),

-- Service 8: Massage Shiatsu Nhật Bản
(8, '/uploads/services/full-size/service_8_1_full.png', 'Shiatsu Massage Points', 1, 0, 'Japanese Shiatsu pressure point massage', 1, 195000),

-- Service 9: Massage Foot Reflexology
(9, '/uploads/services/full-size/service_9_1_full.png', 'Foot Reflexology Treatment', 1, 0, 'Therapeutic foot reflexology', 1, 160000),

-- Service 10: Massage Toàn Thân Dầu Dừa
(10, '/uploads/services/full-size/service_10_1_full.png', 'Coconut Oil Massage', 1, 0, 'Full body massage with pure coconut oil', 1, 185000),

-- More services with single images
(11, '/uploads/services/full-size/service_11_1_full.png', 'Melasma Treatment', 1, 0, 'Advanced melasma treatment', 1, 220000),
(12, '/uploads/services/full-size/service_12_1_full.png', 'Vitamin C Facial', 1, 0, 'Brightening vitamin C facial', 1, 170000),
(13, '/uploads/services/full-size/service_13_1_full.png', 'Microdermabrasion Treatment', 1, 0, 'Diamond crystal microdermabrasion', 1, 200000),
(14, '/uploads/services/full-size/service_14_1_full.png', 'Hydrafacial Deep Cleansing', 1, 0, 'Deep hydrafacial treatment', 1, 230000),
(15, '/uploads/services/full-size/service_15_1_full.png', 'Collagen Boost Facial', 1, 0, 'Anti-aging collagen facial', 1, 240000),

-- Add some images for newer services
(27, '/uploads/services/full-size/service_27_1_full.png', 'Basic Manicure Setup', 1, 0, 'Professional manicure service', 1, 110000),
(28, '/uploads/services/full-size/service_28_1_full.png', 'Deluxe Pedicure Spa', 1, 0, 'Luxury pedicure treatment', 1, 140000),
(29, '/uploads/services/full-size/service_29_1_full.png', 'Gel Polish Application', 1, 0, 'Long-lasting gel polish manicure', 1, 125000),
(30, '/uploads/services/full-size/service_30_1_full.png', 'Nail Art Design', 1, 0, 'Creative nail art service', 1, 115000);

-- Update services table to reflect primary images where they exist
UPDATE services s 
JOIN service_images si ON s.service_id = si.service_id 
SET s.image_url = si.url 
WHERE si.is_primary = 1;

-- Verify the data
SELECT s.service_id, s.name, s.image_url, si.url as first_image_url, si.is_primary 
FROM services s 
LEFT JOIN service_images si ON s.service_id = si.service_id 
WHERE s.service_id <= 15
ORDER BY s.service_id, si.sort_order; 