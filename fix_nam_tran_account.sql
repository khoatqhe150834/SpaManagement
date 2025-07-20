-- Script sửa tài khoản nam.tran@email.com
-- Chạy script này để khắc phục vấn đề đăng nhập

-- 1. Kiểm tra trạng thái hiện tại
SELECT 
    'Trạng thái hiện tại:' as info,
    customer_id,
    full_name,
    email,
    CASE WHEN hash_password IS NOT NULL THEN 'Có mật khẩu' ELSE 'Không có mật khẩu' END as password_status,
    CASE WHEN is_active = 1 THEN 'Hoạt động' ELSE 'Không hoạt động' END as account_status,
    CASE WHEN is_verified = 1 THEN 'Đã xác thực' ELSE 'Chưa xác thực' END as verification_status,
    hash_password
FROM customers 
WHERE email = 'nam.tran@email.com';

-- 2. Sửa mật khẩu (tạo hash mới cho mật khẩu "123456")
-- Lưu ý: Hash này được tạo bằng BCrypt với salt rounds = 10
UPDATE customers 
SET 
    hash_password = '$2a$10$lyJgp/pjXtmmrRz1.ec29Osep5i8YluhNCFWj.8ckoU5qUHhQCaeG',
    is_active = 1,
    is_verified = 1,
    updated_at = CURRENT_TIMESTAMP
WHERE email = 'nam.tran@email.com';

-- 3. Kiểm tra sau khi sửa
SELECT 
    'Sau khi sửa:' as info,
    customer_id,
    full_name,
    email,
    CASE WHEN hash_password IS NOT NULL THEN 'Có mật khẩu' ELSE 'Không có mật khẩu' END as password_status,
    CASE WHEN is_active = 1 THEN 'Hoạt động' ELSE 'Không hoạt động' END as account_status,
    CASE WHEN is_verified = 1 THEN 'Đã xác thực' ELSE 'Chưa xác thực' END as verification_status,
    updated_at
FROM customers 
WHERE email = 'nam.tran@email.com';

-- 4. Test login query
SELECT 
    'Test đăng nhập:' as info,
    CASE 
        WHEN email IS NOT NULL 
            AND hash_password IS NOT NULL 
            AND is_active = 1 
        THEN '✅ Có thể đăng nhập'
        ELSE '❌ Không thể đăng nhập'
    END as login_status
FROM customers 
WHERE email = 'nam.tran@email.com';

-- 5. Tạo remember me token (tùy chọn)
INSERT INTO remember_me_tokens (email, password, token, expiry_date, created_at)
VALUES (
    'nam.tran@email.com',
    '123456',
    UUID(),
    DATE_ADD(NOW(), INTERVAL 30 DAY),
    NOW()
);

-- 6. Kiểm tra tất cả tài khoản test
SELECT 
    'Tài khoản test có thể đăng nhập:' as info
UNION ALL
SELECT 
    CONCAT(
        'ID: ', customer_id, 
        ' | Email: ', email,
        ' | Password: ', CASE WHEN hash_password IS NOT NULL THEN 'Có' ELSE 'Không' END,
        ' | Active: ', CASE WHEN is_active = 1 THEN 'Có' ELSE 'Không' END,
        ' | Verified: ', CASE WHEN is_verified = 1 THEN 'Có' ELSE 'Không' END
    ) as account_info
FROM customers 
WHERE email IN (
    'nam.tran@email.com',
    'mai.nguyen@email.com', 
    'lan.le@email.com',
    'kimchi.vo@email.com'
)
ORDER BY email; 