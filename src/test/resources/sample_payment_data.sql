-- Sample Payment Data for Testing Payment History Page
-- Run this script if your database has no payment records

-- First, ensure we have some customers (adjust customer_id as needed)
INSERT IGNORE INTO customers (customer_id, full_name, email, hash_password, phone_number, role_id, is_active, loyalty_points, is_verified, created_at, updated_at) 
VALUES 
(1, 'Nguyễn Thị Mai', 'mai.nguyen@example.com', '$2a$10$example.hash.password', '0901234567', 1, TRUE, 100, TRUE, NOW(), NOW()),
(2, 'Trần Văn Nam', 'nam.tran@example.com', '$2a$10$example.hash.password', '0912345678', 1, TRUE, 50, TRUE, NOW(), NOW()),
(3, 'Lê Thị Hoa', 'hoa.le@example.com', '$2a$10$example.hash.password', '0923456789', 1, TRUE, 200, TRUE, NOW(), NOW());

-- Insert sample services (adjust service_id as needed)
INSERT IGNORE INTO services (service_id, service_name, description, price, duration_minutes, is_active, created_at, updated_at)
VALUES 
(1, 'Massage thư giãn toàn thân', 'Massage thư giãn với tinh dầu thiên nhiên', 500000, 90, TRUE, NOW(), NOW()),
(2, 'Chăm sóc da mặt cao cấp', 'Chăm sóc da mặt với công nghệ hiện đại', 800000, 120, TRUE, NOW(), NOW()),
(3, 'Tắm trắng collagen', 'Tắm trắng với collagen tự nhiên', 300000, 60, TRUE, NOW(), NOW()),
(4, 'Massage đá nóng', 'Massage thư giãn với đá nóng', 600000, 75, TRUE, NOW(), NOW()),
(5, 'Chăm sóc móng tay', 'Chăm sóc và trang trí móng tay', 200000, 45, TRUE, NOW(), NOW());

-- Insert sample payments
INSERT INTO payments (customer_id, total_amount, tax_amount, subtotal_amount, payment_method, payment_status, reference_number, transaction_date, payment_date, notes, created_at, updated_at)
VALUES 
-- Customer 1 payments
(1, 550000, 50000, 500000, 'CASH', 'PAID', 'SPA20241220001', NOW() - INTERVAL 5 DAY, NOW() - INTERVAL 5 DAY, 'Thanh toán dịch vụ massage thư giãn', NOW() - INTERVAL 5 DAY, NOW() - INTERVAL 5 DAY),
(1, 880000, 80000, 800000, 'BANK_TRANSFER', 'PAID', 'SPA20241218002', NOW() - INTERVAL 7 DAY, NOW() - INTERVAL 7 DAY, 'Thanh toán chăm sóc da mặt cao cấp', NOW() - INTERVAL 7 DAY, NOW() - INTERVAL 7 DAY),
(1, 330000, 30000, 300000, 'VNPAY', 'PENDING', 'SPA20241222003', NOW() - INTERVAL 2 DAY, NULL, 'Chờ xác nhận thanh toán VNPay', NOW() - INTERVAL 2 DAY, NOW() - INTERVAL 2 DAY),

-- Customer 2 payments  
(2, 660000, 60000, 600000, 'CREDIT_CARD', 'PAID', 'SPA20241219004', NOW() - INTERVAL 6 DAY, NOW() - INTERVAL 6 DAY, 'Thanh toán massage đá nóng', NOW() - INTERVAL 6 DAY, NOW() - INTERVAL 6 DAY),
(2, 220000, 20000, 200000, 'CASH', 'PAID', 'SPA20241221005', NOW() - INTERVAL 3 DAY, NOW() - INTERVAL 3 DAY, 'Thanh toán chăm sóc móng tay', NOW() - INTERVAL 3 DAY, NOW() - INTERVAL 3 DAY),
(2, 550000, 50000, 500000, 'MOMO', 'FAILED', 'SPA20241223006', NOW() - INTERVAL 1 DAY, NULL, 'Thanh toán thất bại qua MoMo', NOW() - INTERVAL 1 DAY, NOW() - INTERVAL 1 DAY),

-- Customer 3 payments
(3, 1100000, 100000, 1000000, 'BANK_TRANSFER', 'PAID', 'SPA20241217007', NOW() - INTERVAL 8 DAY, NOW() - INTERVAL 8 DAY, 'Combo massage + chăm sóc da', NOW() - INTERVAL 8 DAY, NOW() - INTERVAL 8 DAY),
(3, 330000, 30000, 300000, 'CASH', 'REFUNDED', 'SPA20241220008', NOW() - INTERVAL 5 DAY, NOW() - INTERVAL 5 DAY, 'Đã hoàn tiền do khách hủy', NOW() - INTERVAL 5 DAY, NOW() - INTERVAL 4 DAY);

-- Get the payment IDs for payment items (this assumes auto-increment starts from 1)
-- Insert payment items for each payment
INSERT INTO payment_items (payment_id, service_id, quantity, unit_price, total_price, service_duration, created_at)
VALUES 
-- Payment 1 items (Customer 1 - Massage)
(1, 1, 1, 500000, 500000, 90, NOW() - INTERVAL 5 DAY),

-- Payment 2 items (Customer 1 - Facial)  
(2, 2, 1, 800000, 800000, 120, NOW() - INTERVAL 7 DAY),

-- Payment 3 items (Customer 1 - Collagen bath)
(3, 3, 1, 300000, 300000, 60, NOW() - INTERVAL 2 DAY),

-- Payment 4 items (Customer 2 - Hot stone massage)
(4, 4, 1, 600000, 600000, 75, NOW() - INTERVAL 6 DAY),

-- Payment 5 items (Customer 2 - Nail care)
(5, 5, 1, 200000, 200000, 45, NOW() - INTERVAL 3 DAY),

-- Payment 6 items (Customer 2 - Failed massage)
(6, 1, 1, 500000, 500000, 90, NOW() - INTERVAL 1 DAY),

-- Payment 7 items (Customer 3 - Combo)
(7, 1, 1, 500000, 500000, 90, NOW() - INTERVAL 8 DAY),
(7, 2, 1, 500000, 500000, 120, NOW() - INTERVAL 8 DAY),

-- Payment 8 items (Customer 3 - Refunded)
(8, 3, 1, 300000, 300000, 60, NOW() - INTERVAL 5 DAY);

-- Insert payment item usage tracking
INSERT INTO payment_item_usage (payment_item_id, total_quantity, booked_quantity, last_updated)
VALUES 
(1, 1, 0, NOW() - INTERVAL 5 DAY),
(2, 1, 1, NOW() - INTERVAL 7 DAY),
(3, 1, 0, NOW() - INTERVAL 2 DAY),
(4, 1, 1, NOW() - INTERVAL 6 DAY),
(5, 1, 1, NOW() - INTERVAL 3 DAY),
(6, 1, 0, NOW() - INTERVAL 1 DAY),
(7, 1, 1, NOW() - INTERVAL 8 DAY),
(8, 1, 1, NOW() - INTERVAL 8 DAY),
(9, 1, 0, NOW() - INTERVAL 5 DAY);

-- Verify the data was inserted
SELECT 'Payment Summary' as info;
SELECT 
    p.payment_id,
    c.full_name as customer_name,
    p.total_amount,
    p.payment_method,
    p.payment_status,
    p.reference_number,
    p.payment_date,
    COUNT(pi.payment_item_id) as item_count
FROM payments p
JOIN customers c ON p.customer_id = c.customer_id
LEFT JOIN payment_items pi ON p.payment_id = pi.payment_id
GROUP BY p.payment_id
ORDER BY p.created_at DESC;

SELECT 'Total payments by customer' as info;
SELECT 
    c.customer_id,
    c.full_name,
    COUNT(p.payment_id) as payment_count,
    SUM(CASE WHEN p.payment_status = 'PAID' THEN p.total_amount ELSE 0 END) as total_paid
FROM customers c
LEFT JOIN payments p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY payment_count DESC;
