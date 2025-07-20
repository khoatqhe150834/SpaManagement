-- Script test và sửa lỗi hệ thống promotion
USE spa_management;

-- 1. Kiểm tra cấu trúc bảng promotions
DESCRIBE promotions;

-- 2. Kiểm tra dữ liệu null có thể gây lỗi
SELECT 
    promotion_id,
    title,
    current_usage_count,
    usage_limit_per_customer,
    total_usage_limit,
    minimum_appointment_value,
    customer_condition
FROM promotions 
WHERE current_usage_count IS NULL 
   OR usage_limit_per_customer IS NULL 
   OR total_usage_limit IS NULL 
   OR minimum_appointment_value IS NULL
   OR customer_condition IS NULL;

-- 3. Sửa dữ liệu null để tránh lỗi
UPDATE promotions 
SET current_usage_count = 0 
WHERE current_usage_count IS NULL;

UPDATE promotions 
SET usage_limit_per_customer = 0 
WHERE usage_limit_per_customer IS NULL;

UPDATE promotions 
SET total_usage_limit = 0 
WHERE total_usage_limit IS NULL;

UPDATE promotions 
SET minimum_appointment_value = 0 
WHERE minimum_appointment_value IS NULL;

UPDATE promotions 
SET customer_condition = 'ALL' 
WHERE customer_condition IS NULL;

-- 4. Kiểm tra lại sau khi sửa
SELECT 
    promotion_id,
    title,
    current_usage_count,
    usage_limit_per_customer,
    total_usage_limit,
    minimum_appointment_value,
    customer_condition
FROM promotions 
LIMIT 5;

-- 5. Tạo dữ liệu test để kiểm tra tính năng
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
    created_at, 
    updated_at
) VALUES (
    'Test Promotion - Không lỗi',
    'TEST001',
    'FIXED_AMOUNT',
    100000,
    'Khuyến mãi test để kiểm tra không có lỗi hệ thống',
    'ACTIVE',
    NOW(),
    DATE_ADD(NOW(), INTERVAL 30 DAY),
    0,
    500,
    1000,
    1000000,
    'ALL',
    NOW(),
    NOW()
) ON DUPLICATE KEY UPDATE updated_at = NOW();

-- 6. Kiểm tra promotion test
SELECT 
    promotion_id,
    title,
    promotion_code,
    current_usage_count,
    usage_limit_per_customer,
    total_usage_limit,
    minimum_appointment_value,
    customer_condition,
    status
FROM promotions 
WHERE promotion_code = 'TEST001';

-- 7. Kiểm tra bảng promotion_usage nếu có
SHOW TABLES LIKE 'promotion_usage';

-- 8. Kiểm tra log lỗi (nếu có bảng log)
SHOW TABLES LIKE '%log%';

-- 9. Tạo view để kiểm tra promotion với thống kê an toàn
CREATE OR REPLACE VIEW promotion_stats_safe AS
SELECT 
    p.promotion_id,
    p.title,
    p.promotion_code,
    p.status,
    COALESCE(p.current_usage_count, 0) as current_usage_count,
    COALESCE(p.usage_limit_per_customer, 0) as usage_limit_per_customer,
    COALESCE(p.total_usage_limit, 0) as total_usage_limit,
    COALESCE(p.minimum_appointment_value, 0) as minimum_appointment_value,
    COALESCE(p.customer_condition, 'ALL') as customer_condition,
    CASE 
        WHEN p.total_usage_limit > 0 THEN 
            ROUND((COALESCE(p.current_usage_count, 0) / p.total_usage_limit) * 100, 1)
        ELSE 0 
    END as usage_percentage
FROM promotions p;

-- 10. Test view
SELECT * FROM promotion_stats_safe WHERE promotion_code = 'TEST001';

-- 11. Kiểm tra các ràng buộc database
SELECT 
    CONSTRAINT_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE TABLE_SCHEMA = 'spa_management' 
  AND TABLE_NAME = 'promotions';

-- 12. Kiểm tra index để tối ưu hiệu suất
SHOW INDEX FROM promotions;

-- 13. Tạo procedure để cập nhật thống kê an toàn
DELIMITER //
CREATE PROCEDURE UpdatePromotionStats(IN promo_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error updating promotion stats' as message;
    END;
    
    START TRANSACTION;
    
    UPDATE promotions 
    SET 
        current_usage_count = COALESCE(current_usage_count, 0),
        usage_limit_per_customer = COALESCE(usage_limit_per_customer, 0),
        total_usage_limit = COALESCE(total_usage_limit, 0),
        minimum_appointment_value = COALESCE(minimum_appointment_value, 0),
        customer_condition = COALESCE(customer_condition, 'ALL'),
        updated_at = NOW()
    WHERE promotion_id = promo_id;
    
    COMMIT;
    SELECT 'Promotion stats updated successfully' as message;
END //
DELIMITER ;

-- 14. Test procedure
CALL UpdatePromotionStats(1);

-- 15. Xóa procedure test
DROP PROCEDURE IF EXISTS UpdatePromotionStats;

-- 16. Kết quả cuối cùng
SELECT 
    'Promotion System Error Fix Summary' as summary,
    COUNT(*) as total_promotions,
    SUM(CASE WHEN current_usage_count IS NULL THEN 1 ELSE 0 END) as null_usage_count,
    SUM(CASE WHEN usage_limit_per_customer IS NULL THEN 1 ELSE 0 END) as null_limit_per_customer,
    SUM(CASE WHEN total_usage_limit IS NULL THEN 1 ELSE 0 END) as null_total_limit,
    SUM(CASE WHEN minimum_appointment_value IS NULL THEN 1 ELSE 0 END) as null_min_value,
    SUM(CASE WHEN customer_condition IS NULL THEN 1 ELSE 0 END) as null_customer_condition
FROM promotions; 