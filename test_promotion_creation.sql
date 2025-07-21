-- Test script để kiểm tra việc tạo promotion
USE spa_management;

-- Kiểm tra cấu trúc bảng promotions
DESCRIBE promotions;

-- Kiểm tra dữ liệu hiện tại
SELECT promotion_id, title, promotion_code, status, created_at FROM promotions ORDER BY promotion_id DESC LIMIT 5;

-- Test insert một promotion mới
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
) VALUES (
    'Test Promotion', 
    'TEST123', 
    'PERCENTAGE', 
    20.00, 
    'Test description', 
    'SCHEDULED', 
    '2025-01-01 00:00:00', 
    '2025-12-31 23:59:59', 
    0, 
    false, 
    0.00, 
    'ENTIRE_APPOINTMENT', 
    'ALL'
);

-- Kiểm tra kết quả
SELECT promotion_id, title, promotion_code, status, created_at FROM promotions ORDER BY promotion_id DESC LIMIT 5;

-- Xóa test data
DELETE FROM promotions WHERE promotion_code = 'TEST123'; 