-- Test script cho tính năng tính số lượng mã còn lại
USE spa_management;

-- 1. Kiểm tra cấu trúc bảng promotion_usage
DESCRIBE promotion_usage;

-- 2. Tạo dữ liệu test
-- Thêm một số promotion test
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
    is_auto_apply, 
    minimum_appointment_value, 
    applicable_scope, 
    customer_condition,
    usage_limit_per_customer,
    total_usage_limit
) VALUES 
-- Promotion có giới hạn 3 lần/khách hàng
('Khuyến mãi test 1', 'TEST1', 'PERCENTAGE', 10.00, 'Giảm 10% cho test', 'ACTIVE', NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 0, false, 0.00, 'ALL_SERVICES', 'ALL', 3, 100),
-- Promotion không giới hạn
('Khuyến mãi test 2', 'TEST2', 'FIXED_AMOUNT', 50000.00, 'Giảm 50k cho test', 'ACTIVE', NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 0, false, 0.00, 'ALL_SERVICES', 'ALL', NULL, 100),
-- Promotion có giới hạn 2 lần/khách hàng
('Khuyến mãi test 3', 'TEST3', 'PERCENTAGE', 20.00, 'Giảm 20% cho test', 'ACTIVE', NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 0, false, 0.00, 'ALL_SERVICES', 'ALL', 2, 50)
ON DUPLICATE KEY UPDATE 
    title = VALUES(title),
    discount_value = VALUES(discount_value),
    usage_limit_per_customer = VALUES(usage_limit_per_customer);

-- 3. Thêm dữ liệu sử dụng promotion cho customer ID 1
INSERT INTO promotion_usage (
    promotion_id, 
    customer_id, 
    payment_id, 
    booking_id, 
    discount_amount, 
    original_amount, 
    final_amount, 
    used_at
) VALUES 
-- Customer 1 đã sử dụng TEST1 2 lần
(LAST_INSERT_ID()-2, 1, NULL, NULL, 10000.00, 100000.00, 90000.00, NOW()),
(LAST_INSERT_ID()-2, 1, NULL, NULL, 15000.00, 150000.00, 135000.00, NOW()),
-- Customer 1 đã sử dụng TEST2 1 lần
(LAST_INSERT_ID()-1, 1, NULL, NULL, 50000.00, 200000.00, 150000.00, NOW()),
-- Customer 2 đã sử dụng TEST1 1 lần
(LAST_INSERT_ID()-2, 2, NULL, NULL, 20000.00, 200000.00, 180000.00, NOW()),
-- Customer 2 đã sử dụng TEST3 2 lần (hết lượt)
(LAST_INSERT_ID(), 2, NULL, NULL, 40000.00, 200000.00, 160000.00, NOW()),
(LAST_INSERT_ID(), 2, NULL, NULL, 30000.00, 150000.00, 120000.00, NOW())
ON DUPLICATE KEY UPDATE 
    discount_amount = VALUES(discount_amount),
    original_amount = VALUES(original_amount),
    final_amount = VALUES(final_amount);

-- 4. Test query để tính số lượng còn lại cho customer 1
SELECT 
    p.promotion_id,
    p.title,
    p.promotion_code,
    p.usage_limit_per_customer,
    COUNT(pu.usage_id) as used_count,
    CASE 
        WHEN p.usage_limit_per_customer IS NULL THEN NULL
        ELSE GREATEST(0, p.usage_limit_per_customer - COUNT(pu.usage_id))
    END as remaining_count
FROM promotions p
LEFT JOIN promotion_usage pu ON p.promotion_id = pu.promotion_id AND pu.customer_id = 1
WHERE p.promotion_code IN ('TEST1', 'TEST2', 'TEST3')
GROUP BY p.promotion_id, p.title, p.promotion_code, p.usage_limit_per_customer
ORDER BY p.promotion_id;

-- 5. Test query để tính số lượng còn lại cho customer 2
SELECT 
    p.promotion_id,
    p.title,
    p.promotion_code,
    p.usage_limit_per_customer,
    COUNT(pu.usage_id) as used_count,
    CASE 
        WHEN p.usage_limit_per_customer IS NULL THEN NULL
        ELSE GREATEST(0, p.usage_limit_per_customer - COUNT(pu.usage_id))
    END as remaining_count
FROM promotions p
LEFT JOIN promotion_usage pu ON p.promotion_id = pu.promotion_id AND pu.customer_id = 2
WHERE p.promotion_code IN ('TEST1', 'TEST2', 'TEST3')
GROUP BY p.promotion_id, p.title, p.promotion_code, p.usage_limit_per_customer
ORDER BY p.promotion_id;

-- 6. Test summary cho customer 1
SELECT 
    COUNT(DISTINCT p.promotion_id) as total_promotions,
    SUM(CASE WHEN p.usage_limit_per_customer IS NULL THEN 1 ELSE 0 END) as unlimited_promotions,
    SUM(CASE 
        WHEN p.usage_limit_per_customer IS NULL THEN 0
        ELSE GREATEST(0, p.usage_limit_per_customer - COALESCE(pu.used_count, 0))
    END) as total_remaining_uses
FROM promotions p
LEFT JOIN (
    SELECT promotion_id, COUNT(*) as used_count
    FROM promotion_usage
    WHERE customer_id = 1
    GROUP BY promotion_id
) pu ON p.promotion_id = pu.promotion_id
WHERE p.status = 'ACTIVE' AND p.promotion_code IN ('TEST1', 'TEST2', 'TEST3');

-- 7. Test summary cho customer 2
SELECT 
    COUNT(DISTINCT p.promotion_id) as total_promotions,
    SUM(CASE WHEN p.usage_limit_per_customer IS NULL THEN 1 ELSE 0 END) as unlimited_promotions,
    SUM(CASE 
        WHEN p.usage_limit_per_customer IS NULL THEN 0
        ELSE GREATEST(0, p.usage_limit_per_customer - COALESCE(pu.used_count, 0))
    END) as total_remaining_uses
FROM promotions p
LEFT JOIN (
    SELECT promotion_id, COUNT(*) as used_count
    FROM promotion_usage
    WHERE customer_id = 2
    GROUP BY promotion_id
) pu ON p.promotion_id = pu.promotion_id
WHERE p.status = 'ACTIVE' AND p.promotion_code IN ('TEST1', 'TEST2', 'TEST3');

-- 8. Kiểm tra current_usage_count trong bảng promotions
SELECT 
    promotion_id,
    title,
    promotion_code,
    current_usage_count,
    usage_limit_per_customer,
    total_usage_limit
FROM promotions 
WHERE promotion_code IN ('TEST1', 'TEST2', 'TEST3')
ORDER BY promotion_id;

-- 9. Cleanup test data (uncomment để xóa dữ liệu test)
-- DELETE FROM promotion_usage WHERE promotion_id IN (SELECT promotion_id FROM promotions WHERE promotion_code IN ('TEST1', 'TEST2', 'TEST3'));
-- DELETE FROM promotions WHERE promotion_code IN ('TEST1', 'TEST2', 'TEST3'); 