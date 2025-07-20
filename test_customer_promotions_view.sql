-- Test script cho tính năng khách hàng xem khuyến mãi
USE spa_management;

-- 1. Kiểm tra cấu trúc bảng
DESCRIBE promotions;
DESCRIBE promotion_usage;

-- 2. Tạo dữ liệu test cho khách hàng
INSERT INTO customers (username, email, password, full_name, phone, address, loyalty_points, status, created_at, updated_at)
VALUES 
('customer1', 'customer1@test.com', 'password123', 'Nguyễn Văn A', '0123456789', 'Hà Nội', 1000, 'ACTIVE', NOW(), NOW()),
('customer2', 'customer2@test.com', 'password123', 'Trần Thị B', '0987654321', 'TP.HCM', 2500, 'ACTIVE', NOW(), NOW())
ON DUPLICATE KEY UPDATE updated_at = NOW();

-- 3. Lấy customer IDs
SET @customer1_id = (SELECT customer_id FROM customers WHERE username = 'customer1');
SET @customer2_id = (SELECT customer_id FROM customers WHERE username = 'customer2');

-- 4. Tạo promotions test với usage limits
INSERT INTO promotions (
    title, 
    promotion_code, 
    discount_type, 
    discount_value, 
    description, 
    status, 
    start_date, 
    end_date, 
    usage_limit_per_customer,
    current_usage_count, 
    is_auto_apply, 
    minimum_appointment_value, 
    applicable_scope, 
    customer_condition
) VALUES 
-- Promotion không giới hạn
('Khuyến mãi không giới hạn', 'UNLIMITED20', 'PERCENTAGE', 20.00, 'Giảm 20% không giới hạn', 'ACTIVE', NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), NULL, 0, false, 0.00, 'ENTIRE_APPOINTMENT', 'ALL'),

-- Promotion có giới hạn 3 lần
('Khuyến mãi có giới hạn', 'LIMITED15', 'PERCENTAGE', 15.00, 'Giảm 15% tối đa 3 lần', 'ACTIVE', NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 3, 0, false, 0.00, 'ENTIRE_APPOINTMENT', 'ALL'),

-- Promotion giảm giá cố định
('Giảm giá cố định', 'FIXED50K', 'FIXED_AMOUNT', 50000.00, 'Giảm 50,000đ', 'ACTIVE', NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 2, 0, false, 0.00, 'ENTIRE_APPOINTMENT', 'ALL'),

-- Promotion sắp hết hạn
('Khuyến mãi sắp hết hạn', 'EXPIRING10', 'PERCENTAGE', 10.00, 'Giảm 10% sắp hết hạn', 'ACTIVE', NOW(), DATE_ADD(NOW(), INTERVAL 2 DAY), 5, 0, false, 0.00, 'ENTIRE_APPOINTMENT', 'ALL')
ON DUPLICATE KEY UPDATE updated_at = NOW();

-- 5. Lấy promotion IDs
SET @unlimited_promo_id = (SELECT promotion_id FROM promotions WHERE promotion_code = 'UNLIMITED20');
SET @limited_promo_id = (SELECT promotion_id FROM promotions WHERE promotion_code = 'LIMITED15');
SET @fixed_promo_id = (SELECT promotion_id FROM promotions WHERE promotion_code = 'FIXED50K');
SET @expiring_promo_id = (SELECT promotion_id FROM promotions WHERE promotion_code = 'EXPIRING10');

-- 6. Tạo usage records cho customer1
INSERT INTO promotion_usage (promotion_id, customer_id, used_at, booking_id, payment_id, discount_amount, original_amount, final_amount)
VALUES 
-- Customer1 đã dùng LIMITED15 2 lần
(@limited_promo_id, @customer1_id, NOW(), 1, 1, 15000.00, 100000.00, 85000.00),
(@limited_promo_id, @customer1_id, DATE_SUB(NOW(), INTERVAL 1 DAY), 2, 2, 15000.00, 100000.00, 85000.00),

-- Customer1 đã dùng FIXED50K 1 lần
(@fixed_promo_id, @customer1_id, DATE_SUB(NOW(), INTERVAL 2 DAY), 3, 3, 50000.00, 200000.00, 150000.00),

-- Customer1 đã dùng EXPIRING10 3 lần
(@expiring_promo_id, @customer1_id, NOW(), 4, 4, 10000.00, 100000.00, 90000.00),
(@expiring_promo_id, @customer1_id, DATE_SUB(NOW(), INTERVAL 1 DAY), 5, 5, 10000.00, 100000.00, 90000.00),
(@expiring_promo_id, @customer1_id, DATE_SUB(NOW(), INTERVAL 2 DAY), 6, 6, 10000.00, 100000.00, 90000.00);

-- 7. Tạo usage records cho customer2
INSERT INTO promotion_usage (promotion_id, customer_id, used_at, booking_id, payment_id, discount_amount, original_amount, final_amount)
VALUES 
-- Customer2 đã dùng LIMITED15 3 lần (hết lượt)
(@limited_promo_id, @customer2_id, NOW(), 7, 7, 15000.00, 100000.00, 85000.00),
(@limited_promo_id, @customer2_id, DATE_SUB(NOW(), INTERVAL 1 DAY), 8, 8, 15000.00, 100000.00, 85000.00),
(@limited_promo_id, @customer2_id, DATE_SUB(NOW(), INTERVAL 2 DAY), 9, 9, 15000.00, 100000.00, 85000.00),

-- Customer2 đã dùng FIXED50K 2 lần (hết lượt)
(@fixed_promo_id, @customer2_id, NOW(), 10, 10, 50000.00, 200000.00, 150000.00),
(@fixed_promo_id, @customer2_id, DATE_SUB(NOW(), INTERVAL 1 DAY), 11, 11, 50000.00, 200000.00, 150000.00);

-- 8. Test query: Xem promotion summary cho customer1
SELECT 'Customer1 Summary' as test_type;
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
    WHERE customer_id = @customer1_id
    GROUP BY promotion_id
) pu ON p.promotion_id = pu.promotion_id
WHERE p.status = 'ACTIVE';

-- 9. Test query: Xem chi tiết promotions cho customer1
SELECT 'Customer1 Details' as test_type;
SELECT 
    p.promotion_id,
    p.title,
    p.promotion_code,
    p.discount_type,
    p.discount_value,
    p.usage_limit_per_customer,
    p.status,
    p.start_date,
    p.end_date,
    COUNT(pu.usage_id) as used_count,
    CASE 
        WHEN p.usage_limit_per_customer IS NULL THEN NULL 
        ELSE GREATEST(0, p.usage_limit_per_customer - COUNT(pu.usage_id)) 
    END as remaining_count
FROM promotions p
LEFT JOIN promotion_usage pu ON p.promotion_id = pu.promotion_id AND pu.customer_id = @customer1_id
WHERE p.status = 'ACTIVE'
GROUP BY p.promotion_id, p.title, p.promotion_code, p.discount_type, p.discount_value, p.usage_limit_per_customer, p.status, p.start_date, p.end_date
ORDER BY p.start_date DESC;

-- 10. Test query: Xem promotion summary cho customer2
SELECT 'Customer2 Summary' as test_type;
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
    WHERE customer_id = @customer2_id
    GROUP BY promotion_id
) pu ON p.promotion_id = pu.promotion_id
WHERE p.status = 'ACTIVE';

-- 11. Test query: Xem chi tiết promotions cho customer2
SELECT 'Customer2 Details' as test_type;
SELECT 
    p.promotion_id,
    p.title,
    p.promotion_code,
    p.discount_type,
    p.discount_value,
    p.usage_limit_per_customer,
    p.status,
    p.start_date,
    p.end_date,
    COUNT(pu.usage_id) as used_count,
    CASE 
        WHEN p.usage_limit_per_customer IS NULL THEN NULL 
        ELSE GREATEST(0, p.usage_limit_per_customer - COUNT(pu.usage_id)) 
    END as remaining_count
FROM promotions p
LEFT JOIN promotion_usage pu ON p.promotion_id = pu.promotion_id AND pu.customer_id = @customer2_id
WHERE p.status = 'ACTIVE'
GROUP BY p.promotion_id, p.title, p.promotion_code, p.discount_type, p.discount_value, p.usage_limit_per_customer, p.status, p.start_date, p.end_date
ORDER BY p.start_date DESC;

-- 12. Cleanup test data (uncomment if needed)
-- DELETE FROM promotion_usage WHERE customer_id IN (@customer1_id, @customer2_id);
-- DELETE FROM promotions WHERE promotion_code IN ('UNLIMITED20', 'LIMITED15', 'FIXED50K', 'EXPIRING10');
-- DELETE FROM customers WHERE username IN ('customer1', 'customer2'); 