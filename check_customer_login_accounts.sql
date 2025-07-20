-- Script kiểm tra tài khoản khách hàng có thể đăng nhập được
-- Chạy script này để xem danh sách tài khoản khách hàng có thể đăng nhập

-- 1. Kiểm tra cấu trúc bảng customers
SELECT 
    'Cấu trúc bảng customers:' as info,
    COUNT(*) as total_customers,
    SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) as active_accounts,
    SUM(CASE WHEN is_active = 0 THEN 1 ELSE 0 END) as inactive_accounts,
    SUM(CASE WHEN hash_password IS NOT NULL THEN 1 ELSE 0 END) as accounts_with_password,
    SUM(CASE WHEN hash_password IS NULL THEN 1 ELSE 0 END) as accounts_without_password,
    SUM(CASE WHEN email IS NOT NULL THEN 1 ELSE 0 END) as accounts_with_email,
    SUM(CASE WHEN email IS NULL THEN 1 ELSE 0 END) as accounts_without_email
FROM customers;

-- 2. Danh sách tài khoản khách hàng CÓ THỂ đăng nhập (có email + password + active)
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
    created_at,
    updated_at
FROM customers 
WHERE email IS NOT NULL 
    AND hash_password IS NOT NULL 
    AND is_active = 1
ORDER BY customer_id;

-- 3. Danh sách tài khoản khách hàng KHÔNG THỂ đăng nhập
SELECT 
    customer_id,
    full_name,
    email,
    phone_number,
    CASE 
        WHEN email IS NULL THEN 'Không có email'
        WHEN hash_password IS NULL THEN 'Không có mật khẩu'
        WHEN is_active = 0 THEN 'Tài khoản không hoạt động'
        ELSE 'Khác'
    END as reason_cannot_login,
    CASE 
        WHEN is_active = 1 THEN 'Hoạt động'
        ELSE 'Không hoạt động'
    END as account_status,
    created_at
FROM customers 
WHERE email IS NULL 
    OR hash_password IS NULL 
    OR is_active = 0
ORDER BY customer_id;

-- 4. Thống kê chi tiết theo trạng thái
SELECT 
    'Tài khoản có thể đăng nhập:' as category,
    COUNT(*) as count
FROM customers 
WHERE email IS NOT NULL 
    AND hash_password IS NOT NULL 
    AND is_active = 1

UNION ALL

SELECT 
    'Tài khoản không có email:' as category,
    COUNT(*) as count
FROM customers 
WHERE email IS NULL

UNION ALL

SELECT 
    'Tài khoản không có mật khẩu:' as category,
    COUNT(*) as count
FROM customers 
WHERE hash_password IS NULL

UNION ALL

SELECT 
    'Tài khoản không hoạt động:' as category,
    COUNT(*) as count
FROM customers 
WHERE is_active = 0

UNION ALL

SELECT 
    'Tài khoản chưa xác thực email:' as category,
    COUNT(*) as count
FROM customers 
WHERE is_verified = 0 
    AND email IS NOT NULL;

-- 5. Danh sách tài khoản test có thể dùng để đăng nhập (với thông tin đầy đủ)
SELECT 
    '=== TÀI KHOẢN KHÁCH HÀNG CÓ THỂ ĐĂNG NHẬP ===' as info
UNION ALL
SELECT 
    CONCAT(
        'ID: ', customer_id, 
        ' | Tên: ', full_name,
        ' | Email: ', email,
        ' | SĐT: ', phone_number,
        ' | Điểm tích lũy: ', loyalty_points,
        ' | Xác thực email: ', CASE WHEN is_verified = 1 THEN 'Có' ELSE 'Chưa' END
    ) as account_info
FROM customers 
WHERE email IS NOT NULL 
    AND hash_password IS NOT NULL 
    AND is_active = 1
ORDER BY customer_id;

-- 6. Kiểm tra tài khoản có remember me tokens
SELECT 
    'Tài khoản có remember me tokens:' as info,
    COUNT(DISTINCT email) as count
FROM remember_me_tokens rmt
WHERE EXISTS (
    SELECT 1 FROM customers c 
    WHERE c.email = rmt.email
);

-- 7. Danh sách email đã có remember me tokens
SELECT 
    rmt.email,
    c.full_name,
    c.phone_number,
    rmt.expiry_date,
    CASE 
        WHEN rmt.expiry_date > NOW() THEN 'Còn hiệu lực'
        ELSE 'Hết hạn'
    END as token_status
FROM remember_me_tokens rmt
LEFT JOIN customers c ON c.email = rmt.email
WHERE c.email IS NOT NULL
ORDER BY rmt.expiry_date DESC; 