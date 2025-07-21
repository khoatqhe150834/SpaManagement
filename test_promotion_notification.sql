-- Test script cho tính năng thông báo promotion
USE spa_management;

-- 1. Kiểm tra cấu trúc bảng
DESCRIBE promotions;
DESCRIBE customers;

-- 2. Tạo dữ liệu test cho khách hàng
INSERT INTO customers (username, email, password, full_name, phone, address, loyalty_points, status, created_at, updated_at)
VALUES 
('testcustomer1', 'customer1@test.com', 'password123', 'Nguyễn Văn Test', '0123456789', 'Hà Nội', 1000, 'ACTIVE', NOW(), NOW()),
('testcustomer2', 'customer2@test.com', 'password123', 'Trần Thị Test', '0987654321', 'TP.HCM', 2500, 'ACTIVE', NOW(), NOW())
ON DUPLICATE KEY UPDATE updated_at = NOW();

-- 3. Tạo promotions test để kiểm tra thông báo
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
    customer_condition
) VALUES 
-- Promotion mới được tạo
('Khuyến mãi mùa hè', 'SUMMER2024', 'PERCENTAGE', 25.00, 'Giảm 25% cho dịch vụ spa mùa hè', 'ACTIVE', NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 0, false, 0.00, 'ENTIRE_APPOINTMENT', 'ALL'),

-- Promotion sắp hết hạn
('Khuyến mãi cuối tháng', 'MONTHEND20', 'PERCENTAGE', 20.00, 'Giảm 20% cuối tháng', 'ACTIVE', NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY), 0, false, 0.00, 'ENTIRE_APPOINTMENT', 'ALL'),

-- Promotion cho khách hàng mới
('Chào mừng khách hàng mới', 'WELCOME30', 'PERCENTAGE', 30.00, 'Giảm 30% cho khách hàng mới', 'ACTIVE', NOW(), DATE_ADD(NOW(), INTERVAL 60 DAY), 0, false, 0.00, 'ENTIRE_APPOINTMENT', 'ALL')

ON DUPLICATE KEY UPDATE updated_at = NOW();

-- 4. Kiểm tra kết quả
SELECT 
    promotion_id,
    title,
    promotion_code,
    status,
    start_date,
    end_date,
    created_at
FROM promotions 
WHERE promotion_code IN ('SUMMER2024', 'MONTHEND20', 'WELCOME30')
ORDER BY created_at DESC;

-- 5. Test query để lấy promotions mới cho khách hàng
SELECT 
    p.promotion_id,
    p.title,
    p.promotion_code,
    p.discount_type,
    p.discount_value,
    p.description,
    p.start_date,
    p.end_date,
    p.status,
    p.created_at
FROM promotions p
WHERE p.status = 'ACTIVE'
  AND p.start_date <= NOW()
  AND p.end_date >= NOW()
ORDER BY p.created_at DESC
LIMIT 10;

-- 6. Kiểm tra khách hàng test
SELECT 
    customer_id,
    username,
    email,
    full_name,
    status,
    created_at
FROM customers 
WHERE username LIKE 'testcustomer%'
ORDER BY created_at DESC; 