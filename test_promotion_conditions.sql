-- Test script cho điều kiện sử dụng mã khuyến mãi
USE spa_management;

-- 1. Kiểm tra cấu trúc bảng
DESCRIBE promotions;

-- 2. Tạo dữ liệu test cho các điều kiện khác nhau
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
    minimum_appointment_value,
    customer_condition,
    current_usage_count, 
    is_auto_apply, 
    applicable_scope
) VALUES 
-- Promotion với điều kiện giá trị tối thiểu
('Giảm 20% cho đơn từ 500K', 'MIN500K20', 'PERCENTAGE', 20.00, 'Giảm 20% cho đơn hàng từ 500,000đ', 'ACTIVE', NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 3, 500000.00, 'ALL', 0, false, 'ENTIRE_APPOINTMENT'),

-- Promotion cho khách hàng cá nhân
('Giảm 15% cho khách cá nhân', 'INDIVIDUAL15', 'PERCENTAGE', 15.00, 'Giảm 15% cho khách hàng đi 1 người', 'ACTIVE', NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 2, 0.00, 'INDIVIDUAL', 0, false, 'ENTIRE_APPOINTMENT'),

-- Promotion cho cặp đôi
('Giảm 25% cho cặp đôi', 'COUPLE25', 'PERCENTAGE', 25.00, 'Giảm 25% cho khách hàng đi 2 người', 'ACTIVE', NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 1, 0.00, 'COUPLE', 0, false, 'ENTIRE_APPOINTMENT'),

-- Promotion cho nhóm
('Giảm 30% cho nhóm', 'GROUP30', 'PERCENTAGE', 30.00, 'Giảm 30% cho nhóm 3+ người', 'ACTIVE', NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 1, 0.00, 'GROUP', 0, false, 'ENTIRE_APPOINTMENT'),

-- Promotion đã hết hạn
('Khuyến mãi hết hạn', 'EXPIRED10', 'PERCENTAGE', 10.00, 'Khuyến mãi đã hết hạn', 'ACTIVE', DATE_SUB(NOW(), INTERVAL 30 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY), 5, 0.00, 'ALL', 0, false, 'ENTIRE_APPOINTMENT'),

-- Promotion sắp có hiệu lực
('Khuyến mãi sắp có hiệu lực', 'FUTURE20', 'PERCENTAGE', 20.00, 'Khuyến mãi sắp có hiệu lực', 'ACTIVE', DATE_ADD(NOW(), INTERVAL 1 DAY), DATE_ADD(NOW(), INTERVAL 31 DAY), 10, 0.00, 'ALL', 0, false, 'ENTIRE_APPOINTMENT'),

-- Promotion không khả dụng
('Khuyến mãi không khả dụng', 'INACTIVE15', 'PERCENTAGE', 15.00, 'Khuyến mãi không khả dụng', 'INACTIVE', NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 3, 0.00, 'ALL', 0, false, 'ENTIRE_APPOINTMENT'),

-- Promotion giảm giá cố định
('Giảm 100K cho đơn từ 1M', 'FIXED100K', 'FIXED_AMOUNT', 100000.00, 'Giảm 100,000đ cho đơn từ 1,000,000đ', 'ACTIVE', NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 2, 1000000.00, 'ALL', 0, false, 'ENTIRE_APPOINTMENT')
ON DUPLICATE KEY UPDATE updated_at = NOW();

-- 3. Lấy promotion IDs
SET @min500k_promo_id = (SELECT promotion_id FROM promotions WHERE promotion_code = 'MIN500K20');
SET @individual_promo_id = (SELECT promotion_id FROM promotions WHERE promotion_code = 'INDIVIDUAL15');
SET @couple_promo_id = (SELECT promotion_id FROM promotions WHERE promotion_code = 'COUPLE25');
SET @group_promo_id = (SELECT promotion_id FROM promotions WHERE promotion_code = 'GROUP30');
SET @expired_promo_id = (SELECT promotion_id FROM promotions WHERE promotion_code = 'EXPIRED10');
SET @future_promo_id = (SELECT promotion_id FROM promotions WHERE promotion_code = 'FUTURE20');
SET @inactive_promo_id = (SELECT promotion_id FROM promotions WHERE promotion_code = 'INACTIVE15');
SET @fixed_promo_id = (SELECT promotion_id FROM promotions WHERE promotion_code = 'FIXED100K');

-- 4. Test query: Kiểm tra điều kiện sử dụng
SELECT '=== KIỂM TRA ĐIỀU KIỆN SỬ DỤNG MÃ KHUYẾN MÃI ===' as test_section;

-- 4.1. Kiểm tra promotion với điều kiện giá trị tối thiểu
SELECT 
    'MIN500K20' as promotion_code,
    title,
    minimum_appointment_value,
    CASE 
        WHEN minimum_appointment_value > 0 THEN CONCAT('Đơn hàng tối thiểu: ', FORMAT(minimum_appointment_value, 0), ' VND')
        ELSE 'Không có điều kiện giá trị tối thiểu'
    END as condition_description,
    status,
    CASE 
        WHEN NOW() BETWEEN start_date AND end_date THEN 'Đang hiệu lực'
        WHEN NOW() < start_date THEN 'Sắp có hiệu lực'
        WHEN NOW() > end_date THEN 'Đã hết hạn'
    END as validity_status
FROM promotions 
WHERE promotion_code = 'MIN500K20';

-- 4.2. Kiểm tra promotion theo customer condition
SELECT 
    promotion_code,
    title,
    customer_condition,
    CASE 
        WHEN customer_condition = 'INDIVIDUAL' THEN 'Khách hàng cá nhân (1 người)'
        WHEN customer_condition = 'COUPLE' THEN 'Khách hàng đi cặp (2 người)'
        WHEN customer_condition = 'GROUP' THEN 'Khách hàng đi nhóm (3+ người)'
        WHEN customer_condition = 'ALL' THEN 'Tất cả khách hàng'
        ELSE 'Không xác định'
    END as condition_description,
    usage_limit_per_customer,
    CASE 
        WHEN usage_limit_per_customer IS NULL THEN 'Không giới hạn'
        ELSE CONCAT(usage_limit_per_customer, ' lần/khách hàng')
    END as usage_limit_desc
FROM promotions 
WHERE promotion_code IN ('INDIVIDUAL15', 'COUPLE25', 'GROUP30', 'MIN500K20')
ORDER BY customer_condition;

-- 4.3. Kiểm tra trạng thái hiệu lực
SELECT 
    promotion_code,
    title,
    status,
    start_date,
    end_date,
    CASE 
        WHEN status != 'ACTIVE' THEN 'Không khả dụng'
        WHEN NOW() < start_date THEN 'Sắp có hiệu lực'
        WHEN NOW() > end_date THEN 'Đã hết hạn'
        WHEN NOW() BETWEEN start_date AND end_date THEN 'Đang hiệu lực'
        ELSE 'Không xác định'
    END as current_status,
    CASE 
        WHEN status != 'ACTIVE' THEN 'bg-gray-100 text-gray-800'
        WHEN NOW() < start_date THEN 'bg-yellow-100 text-yellow-800'
        WHEN NOW() > end_date THEN 'bg-red-100 text-red-800'
        WHEN NOW() BETWEEN start_date AND end_date THEN 'bg-green-100 text-green-800'
        ELSE 'bg-gray-100 text-gray-800'
    END as badge_class
FROM promotions 
WHERE promotion_code IN ('EXPIRED10', 'FUTURE20', 'INACTIVE15', 'MIN500K20')
ORDER BY status, start_date;

-- 5. Test validation logic
SELECT '=== TEST VALIDATION LOGIC ===' as test_section;

-- 5.1. Test với đơn hàng 300K (dưới điều kiện 500K)
SELECT 
    'MIN500K20' as promotion_code,
    300000 as order_amount,
    minimum_appointment_value,
    CASE 
        WHEN 300000 >= minimum_appointment_value THEN 'Có thể sử dụng'
        ELSE CONCAT('Không đủ điều kiện. Cần tối thiểu ', FORMAT(minimum_appointment_value, 0), ' VND')
    END as validation_result
FROM promotions 
WHERE promotion_code = 'MIN500K20';

-- 5.2. Test với đơn hàng 600K (đủ điều kiện 500K)
SELECT 
    'MIN500K20' as promotion_code,
    600000 as order_amount,
    minimum_appointment_value,
    CASE 
        WHEN 600000 >= minimum_appointment_value THEN 'Có thể sử dụng'
        ELSE CONCAT('Không đủ điều kiện. Cần tối thiểu ', FORMAT(minimum_appointment_value, 0), ' VND')
    END as validation_result
FROM promotions 
WHERE promotion_code = 'MIN500K20';

-- 5.3. Test với đơn hàng 1.2M (đủ điều kiện 1M cho FIXED100K)
SELECT 
    'FIXED100K' as promotion_code,
    1200000 as order_amount,
    minimum_appointment_value,
    CASE 
        WHEN 1200000 >= minimum_appointment_value THEN 'Có thể sử dụng'
        ELSE CONCAT('Không đủ điều kiện. Cần tối thiểu ', FORMAT(minimum_appointment_value, 0), ' VND')
    END as validation_result
FROM promotions 
WHERE promotion_code = 'FIXED100K';

-- 6. Test customer condition validation
SELECT '=== TEST CUSTOMER CONDITION ===' as test_section;

-- 6.1. Test INDIVIDUAL condition
SELECT 
    'INDIVIDUAL15' as promotion_code,
    'INDIVIDUAL' as required_condition,
    1 as booking_people,
    CASE 
        WHEN 1 = 1 THEN 'Hợp lệ - Khách hàng cá nhân'
        ELSE 'Không hợp lệ - Cần 1 người'
    END as validation_result
FROM promotions 
WHERE promotion_code = 'INDIVIDUAL15';

-- 6.2. Test COUPLE condition
SELECT 
    'COUPLE25' as promotion_code,
    'COUPLE' as required_condition,
    2 as booking_people,
    CASE 
        WHEN 2 = 2 THEN 'Hợp lệ - Khách hàng đi cặp'
        ELSE 'Không hợp lệ - Cần 2 người'
    END as validation_result
FROM promotions 
WHERE promotion_code = 'COUPLE25';

-- 6.3. Test GROUP condition
SELECT 
    'GROUP30' as promotion_code,
    'GROUP' as required_condition,
    4 as booking_people,
    CASE 
        WHEN 4 >= 3 THEN 'Hợp lệ - Khách hàng đi nhóm'
        ELSE 'Không hợp lệ - Cần 3+ người'
    END as validation_result
FROM promotions 
WHERE promotion_code = 'GROUP30';

-- 7. Test usage limits
SELECT '=== TEST USAGE LIMITS ===' as test_section;

-- 7.1. Test usage limit per customer
SELECT 
    promotion_code,
    usage_limit_per_customer,
    0 as current_usage,
    CASE 
        WHEN usage_limit_per_customer IS NULL THEN 'Không giới hạn'
        WHEN 0 < usage_limit_per_customer THEN CONCAT('Còn ', usage_limit_per_customer, ' lượt')
        ELSE 'Đã hết lượt'
    END as remaining_usage
FROM promotions 
WHERE promotion_code IN ('INDIVIDUAL15', 'COUPLE25', 'GROUP30', 'MIN500K20');

-- 8. Test complete validation
SELECT '=== TEST COMPLETE VALIDATION ===' as test_section;

-- 8.1. Test promotion có thể sử dụng
SELECT 
    p.promotion_code,
    p.title,
    p.status,
    p.minimum_appointment_value,
    p.customer_condition,
    p.usage_limit_per_customer,
    CASE 
        WHEN p.status != 'ACTIVE' THEN 'Không khả dụng - Trạng thái không ACTIVE'
        WHEN NOW() < p.start_date THEN 'Không khả dụng - Chưa có hiệu lực'
        WHEN NOW() > p.end_date THEN 'Không khả dụng - Đã hết hạn'
        WHEN p.minimum_appointment_value > 0 THEN CONCAT('Cần đơn hàng tối thiểu ', FORMAT(p.minimum_appointment_value, 0), ' VND')
        WHEN p.usage_limit_per_customer IS NOT NULL AND p.usage_limit_per_customer <= 0 THEN 'Không khả dụng - Đã hết lượt'
        ELSE 'Có thể sử dụng'
    END as validation_result
FROM promotions p
WHERE p.promotion_code IN ('MIN500K20', 'INDIVIDUAL15', 'EXPIRED10', 'FUTURE20', 'INACTIVE15')
ORDER BY p.promotion_code;

-- 9. Cleanup test data (uncomment if needed)
-- DELETE FROM promotions WHERE promotion_code IN ('MIN500K20', 'INDIVIDUAL15', 'COUPLE25', 'GROUP30', 'EXPIRED10', 'FUTURE20', 'INACTIVE15', 'FIXED100K'); 