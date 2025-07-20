-- Script debug tài khoản nam.tran@email.com
-- Chạy script này để kiểm tra chi tiết tài khoản

-- 1. Kiểm tra thông tin chi tiết tài khoản
SELECT 
    customer_id,
    full_name,
    email,
    phone_number,
    CASE 
        WHEN hash_password IS NOT NULL THEN 'Có mật khẩu'
        ELSE 'Không có mật khẩu'
    END as password_status,
    CASE 
        WHEN is_active = 1 THEN 'Hoạt động'
        ELSE 'Không hoạt động'
    END as account_status,
    CASE 
        WHEN is_verified = 1 THEN 'Đã xác thực email'
        ELSE 'Chưa xác thực email'
    END as email_verification,
    loyalty_points,
    role_id,
    created_at,
    updated_at,
    hash_password
FROM customers 
WHERE email = 'nam.tran@email.com';

-- 2. Kiểm tra hash password có hợp lệ không
SELECT 
    'Kiểm tra hash password:' as info,
    CASE 
        WHEN hash_password LIKE '$2a$%' THEN 'BCrypt hash hợp lệ'
        WHEN hash_password LIKE '$2b$%' THEN 'BCrypt hash hợp lệ'
        WHEN hash_password IS NULL THEN 'Không có mật khẩu'
        ELSE 'Hash không hợp lệ'
    END as hash_status,
    LENGTH(hash_password) as hash_length
FROM customers 
WHERE email = 'nam.tran@email.com';

-- 3. Kiểm tra remember me tokens
SELECT 
    'Remember me tokens:' as info,
    COUNT(*) as token_count
FROM remember_me_tokens 
WHERE email = 'nam.tran@email.com';

-- 4. Kiểm tra email verification tokens
SELECT 
    'Email verification tokens:' as info,
    COUNT(*) as token_count,
    SUM(CASE WHEN is_used = 1 THEN 1 ELSE 0 END) as used_tokens,
    SUM(CASE WHEN is_used = 0 THEN 1 ELSE 0 END) as unused_tokens
FROM email_verification_tokens 
WHERE user_email = 'nam.tran@email.com';

-- 5. So sánh với tài khoản khác hoạt động tốt
SELECT 
    'So sánh với tài khoản hoạt động:' as info
UNION ALL
SELECT 
    CONCAT(
        'ID: ', customer_id, 
        ' | Email: ', email,
        ' | Password: ', CASE WHEN hash_password IS NOT NULL THEN 'Có' ELSE 'Không' END,
        ' | Active: ', CASE WHEN is_active = 1 THEN 'Có' ELSE 'Không' END,
        ' | Verified: ', CASE WHEN is_verified = 1 THEN 'Có' ELSE 'Không' END
    ) as comparison
FROM customers 
WHERE email IN ('mai.nguyen@email.com', 'nam.tran@email.com', 'lan.le@email.com')
ORDER BY email;

-- 6. Kiểm tra role_id có đúng không
SELECT 
    'Kiểm tra role:' as info,
    c.role_id,
    r.role_name,
    r.description
FROM customers c
LEFT JOIN roles r ON c.role_id = r.role_id
WHERE c.email = 'nam.tran@email.com';

-- 7. Test login query (mô phỏng)
SELECT 
    'Test login query:' as info,
    CASE 
        WHEN email IS NOT NULL 
            AND hash_password IS NOT NULL 
            AND is_active = 1 
        THEN 'Có thể đăng nhập'
        ELSE 'Không thể đăng nhập'
    END as login_status,
    CASE 
        WHEN email IS NULL THEN 'Thiếu email'
        WHEN hash_password IS NULL THEN 'Thiếu mật khẩu'
        WHEN is_active = 0 THEN 'Tài khoản không hoạt động'
        ELSE 'OK'
    END as issue_detail
FROM customers 
WHERE email = 'nam.tran@email.com'; 