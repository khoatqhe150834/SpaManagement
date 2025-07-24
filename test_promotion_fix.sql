-- Test script để sửa và kiểm tra hệ thống promotion
USE spa_management;

-- =====================================================
-- 1. KIỂM TRA VÀ TẠO BẢNG PROMOTION_USAGE NẾU CHƯA CÓ
-- =====================================================
CREATE TABLE IF NOT EXISTS `promotion_usage` (
  `usage_id` int NOT NULL AUTO_INCREMENT,
  `promotion_id` int NOT NULL,
  `customer_id` int NOT NULL,
  `payment_id` int DEFAULT NULL COMMENT 'Liên kết với payment khi áp dụng mã',
  `booking_id` int DEFAULT NULL COMMENT 'Liên kết với booking khi áp dụng mã',
  `discount_amount` decimal(10,2) NOT NULL COMMENT 'Số tiền thực tế được giảm',
  `original_amount` decimal(10,2) NOT NULL COMMENT 'Số tiền gốc trước khi giảm',
  `final_amount` decimal(10,2) NOT NULL COMMENT 'Số tiền cuối cùng sau khi giảm',
  `used_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  PRIMARY KEY (`usage_id`),
  KEY `idx_customer_promotions` (`customer_id`,`used_at`),
  KEY `idx_promotion_usage` (`promotion_id`,`used_at`),
  KEY `fk_promotion_usage_payment` (`payment_id`),
  KEY `fk_promotion_usage_booking` (`booking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 2. KIỂM TRA VÀ SỬA DỮ LIỆU PROMOTION
-- =====================================================
SELECT '=== KIỂM TRA DỮ LIỆU PROMOTION ===' as section;

-- Kiểm tra promotion có lỗi
SELECT 
    promotion_id,
    title,
    promotion_code,
    status,
    start_date,
    end_date,
    current_usage_count,
    usage_limit_per_customer,
    total_usage_limit,
    minimum_appointment_value,
    created_at,
    updated_at,
    CASE 
        WHEN title IS NULL OR title = '' THEN '❌ Title rỗng'
        WHEN promotion_code IS NULL OR promotion_code = '' THEN '❌ Code rỗng'
        WHEN start_date IS NULL THEN '❌ StartDate NULL'
        WHEN end_date IS NULL THEN '❌ EndDate NULL'
        WHEN current_usage_count IS NULL THEN '❌ CurrentUsageCount NULL'
        WHEN created_at IS NULL THEN '⚠️ CreatedAt NULL'
        ELSE '✅ OK'
    END as data_status
FROM promotions 
ORDER BY promotion_id DESC;

-- Sửa dữ liệu NULL để tránh lỗi 500
UPDATE promotions 
SET current_usage_count = 0 
WHERE current_usage_count IS NULL;

UPDATE promotions 
SET usage_limit_per_customer = 100 
WHERE usage_limit_per_customer IS NULL;

UPDATE promotions 
SET total_usage_limit = 1000 
WHERE total_usage_limit IS NULL;

UPDATE promotions 
SET minimum_appointment_value = 0 
WHERE minimum_appointment_value IS NULL;

UPDATE promotions 
SET created_at = NOW() 
WHERE created_at IS NULL;

UPDATE promotions 
SET updated_at = NOW() 
WHERE updated_at IS NULL;

-- =====================================================
-- 3. TẠO DỮ LIỆU TEST CHO PROMOTION
-- =====================================================
SELECT '=== TẠO DỮ LIỆU TEST ===' as section;

-- Xóa test data cũ nếu có
DELETE FROM promotion_usage WHERE promotion_id IN (
    SELECT promotion_id FROM promotions WHERE promotion_code LIKE 'TEST%'
);
DELETE FROM promotions WHERE promotion_code LIKE 'TEST%';

-- Tạo promotion test mới
INSERT INTO promotions (
    title, 
    promotion_code, 
    discount_type, 
    discount_value, 
    description, 
    status, 
    start_date, 
    end_date, 
    current_usage_count,
    usage_limit_per_customer,
    total_usage_limit,
    minimum_appointment_value,
    customer_condition,
    applicable_scope,
    is_auto_apply,
    created_at, 
    updated_at
) VALUES 
(
    'Test Promotion - Giảm giá cố định',
    'TEST001',
    'FIXED_AMOUNT',
    100000.00,
    'Khuyến mãi test để kiểm tra hệ thống',
    'ACTIVE',
    DATE_SUB(NOW(), INTERVAL 1 DAY),  -- Bắt đầu từ hôm qua
    DATE_ADD(NOW(), INTERVAL 30 DAY), -- Kết thúc sau 30 ngày
    0,
    5,  -- Mỗi khách hàng tối đa 5 lần
    100, -- Tổng cộng 100 lần
    500000.00, -- Đơn hàng tối thiểu 500k
    'ALL',
    'ENTIRE_APPOINTMENT',
    false,
    NOW(),
    NOW()
),
(
    'Test Promotion - Giảm phần trăm',
    'TEST002',
    'PERCENTAGE',
    15.00,
    'Khuyến mãi test giảm 15%',
    'ACTIVE',
    DATE_SUB(NOW(), INTERVAL 1 DAY),
    DATE_ADD(NOW(), INTERVAL 30 DAY),
    0,
    3,  -- Mỗi khách hàng tối đa 3 lần
    50,  -- Tổng cộng 50 lần
    300000.00, -- Đơn hàng tối thiểu 300k
    'ALL',
    'ENTIRE_APPOINTMENT',
    false,
    NOW(),
    NOW()
),
(
    'Test Promotion - Không giới hạn',
    'TEST003',
    'FIXED_AMOUNT',
    50000.00,
    'Khuyến mãi test không giới hạn',
    'ACTIVE',
    DATE_SUB(NOW(), INTERVAL 1 DAY),
    DATE_ADD(NOW(), INTERVAL 30 DAY),
    0,
    NULL,  -- Không giới hạn per customer
    NULL,  -- Không giới hạn tổng
    0.00,  -- Không yêu cầu đơn hàng tối thiểu
    'ALL',
    'ENTIRE_APPOINTMENT',
    false,
    NOW(),
    NOW()
);

-- =====================================================
-- 4. KIỂM TRA KẾT QUẢ SAU KHI TẠO
-- =====================================================
SELECT '=== KIỂM TRA PROMOTION TEST ===' as section;

SELECT 
    promotion_id,
    title,
    promotion_code,
    discount_type,
    discount_value,
    status,
    start_date,
    end_date,
    current_usage_count,
    usage_limit_per_customer,
    total_usage_limit,
    minimum_appointment_value,
    CASE 
        WHEN status = 'ACTIVE' AND start_date <= NOW() AND end_date >= NOW() 
        THEN '✅ Có thể sử dụng'
        ELSE '❌ Không thể sử dụng'
    END as usable_status
FROM promotions 
WHERE promotion_code LIKE 'TEST%'
ORDER BY promotion_code;

-- =====================================================
-- 5. KIỂM TRA BẢNG PROMOTION_USAGE
-- =====================================================
SELECT '=== KIỂM TRA BẢNG PROMOTION_USAGE ===' as section;

-- Kiểm tra structure
DESCRIBE promotion_usage;

-- Kiểm tra dữ liệu
SELECT COUNT(*) as total_usage_records FROM promotion_usage;

-- =====================================================
-- 6. TẠO VIEW THỐNG KÊ AN TOÀN
-- =====================================================
CREATE OR REPLACE VIEW v_promotion_stats AS
SELECT 
    p.promotion_id,
    p.title,
    p.promotion_code,
    p.status,
    p.discount_type,
    p.discount_value,
    COALESCE(p.current_usage_count, 0) as current_usage_count,
    COALESCE(p.usage_limit_per_customer, 0) as usage_limit_per_customer,
    COALESCE(p.total_usage_limit, 0) as total_usage_limit,
    COALESCE(p.minimum_appointment_value, 0) as minimum_appointment_value,
    p.start_date,
    p.end_date,
    p.created_at,
    p.updated_at,
    -- Tính toán an toàn
    CASE 
        WHEN p.total_usage_limit > 0 THEN 
            ROUND((COALESCE(p.current_usage_count, 0) / p.total_usage_limit) * 100, 1)
        ELSE 0 
    END as usage_percentage,
    -- Trạng thái có thể sử dụng
    CASE 
        WHEN p.status = 'ACTIVE' 
         AND (p.start_date IS NULL OR p.start_date <= NOW()) 
         AND (p.end_date IS NULL OR p.end_date >= NOW()) 
        THEN 1 
        ELSE 0 
    END as is_usable
FROM promotions p;

-- Kiểm tra view
SELECT 
    promotion_code,
    title,
    usage_percentage,
    is_usable
FROM v_promotion_stats 
WHERE promotion_code LIKE 'TEST%';

-- =====================================================
-- 7. TẠO FUNCTION KIỂM TRA PROMOTION
-- =====================================================
DELIMITER $$

DROP FUNCTION IF EXISTS check_promotion_usable$$
CREATE FUNCTION check_promotion_usable(p_code VARCHAR(50)) 
RETURNS VARCHAR(100)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_count INT DEFAULT 0;
    DECLARE v_status VARCHAR(50);
    DECLARE v_start_date DATETIME;
    DECLARE v_end_date DATETIME;
    DECLARE result VARCHAR(100);
    
    -- Lấy thông tin promotion
    SELECT COUNT(*), MAX(status), MAX(start_date), MAX(end_date)
    INTO v_count, v_status, v_start_date, v_end_date
    FROM promotions 
    WHERE promotion_code = p_code;
    
    -- Kiểm tra
    IF v_count = 0 THEN
        SET result = 'KHÔNG TỒN TẠI';
    ELSEIF v_status != 'ACTIVE' THEN
        SET result = 'KHÔNG ACTIVE';
    ELSEIF v_start_date IS NOT NULL AND v_start_date > NOW() THEN
        SET result = 'CHƯA HIỆU LỰC';
    ELSEIF v_end_date IS NOT NULL AND v_end_date < NOW() THEN
        SET result = 'HẾT HẠN';
    ELSE
        SET result = 'CÓ THỂ SỬ DỤNG';
    END IF;
    
    RETURN result;
END$$

DELIMITER ;

-- Test function
SELECT 
    promotion_code,
    title,
    check_promotion_usable(promotion_code) as status_check
FROM promotions 
WHERE promotion_code LIKE 'TEST%';

-- =====================================================
-- 8. SCRIPT HOÀN TẤT
-- =====================================================
SELECT '=== SCRIPT HOÀN TẤT ===' as section;
SELECT NOW() as completion_time;
SELECT 'Hệ thống promotion đã được kiểm tra và sửa lỗi' as message; 