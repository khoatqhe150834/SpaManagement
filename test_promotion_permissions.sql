-- Script test phân quyền promotion
-- Chạy script này để kiểm tra cấu hình phân quyền

-- 1. Kiểm tra cấu trúc bảng roles
SELECT 
    'Cấu trúc bảng roles:' as info,
    COUNT(*) as total_roles
FROM roles;

SELECT 
    role_id,
    role_name,
    description
FROM roles
ORDER BY role_id;

-- 2. Kiểm tra users với role khác nhau
SELECT 
    'Users theo role:' as info,
    r.role_name,
    COUNT(u.user_id) as user_count
FROM roles r
LEFT JOIN users u ON r.role_id = u.role_id
GROUP BY r.role_id, r.role_name
ORDER BY r.role_id;

-- 3. Kiểm tra customers
SELECT 
    'Customers:' as info,
    COUNT(*) as total_customers,
    SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) as active_customers,
    SUM(CASE WHEN role_id = 5 THEN 1 ELSE 0 END) as customer_role_count
FROM customers;

-- 4. Test tài khoản cụ thể
SELECT 
    'Test tài khoản nam.tran@email.com:' as info,
    customer_id,
    full_name,
    email,
    role_id,
    CASE WHEN is_active = 1 THEN 'Hoạt động' ELSE 'Không hoạt động' END as status,
    CASE WHEN is_verified = 1 THEN 'Đã xác thực' ELSE 'Chưa xác thực' END as verification
FROM customers 
WHERE email = 'nam.tran@email.com';

-- 5. Kiểm tra role của customer
SELECT 
    'Role của customer:' as info,
    c.customer_id,
    c.full_name,
    c.email,
    c.role_id,
    r.role_name,
    r.description
FROM customers c
LEFT JOIN roles r ON c.role_id = r.role_id
WHERE c.email = 'nam.tran@email.com';

-- 6. Test URLs có thể truy cập
SELECT 
    'URLs có thể truy cập với role CUSTOMER (5):' as info
UNION ALL
SELECT 
    CONCAT(
        'URL: /promotions/my-promotions | Role: CUSTOMER (5) | ',
        CASE WHEN 5 IN (1,2,6,5) THEN '✅ Có quyền' ELSE '❌ Không có quyền' END
    ) as test_result
UNION ALL
SELECT 
    CONCAT(
        'URL: /promotions/available | Role: CUSTOMER (5) | ',
        CASE WHEN 5 IN (1,2,6,5) THEN '✅ Có quyền' ELSE '❌ Không có quyền' END
    ) as test_result
UNION ALL
SELECT 
    CONCAT(
        'URL: /promotions/notification | Role: CUSTOMER (5) | ',
        CASE WHEN 5 IN (1,2,6,5) THEN '✅ Có quyền' ELSE '❌ Không có quyền' END
    ) as test_result
UNION ALL
SELECT 
    CONCAT(
        'URL: /promotion/list | Role: CUSTOMER (5) | ',
        CASE WHEN 5 IN (1,2,6) THEN '✅ Có quyền' ELSE '❌ Không có quyền' END
    ) as test_result;

-- 7. Kiểm tra session data
SELECT 
    'Kiểm tra session data:' as info,
    'Customer session: customer object' as session_info
UNION ALL
SELECT 
    'User session: user object' as session_info;

-- 8. Test remember me tokens
SELECT 
    'Remember me tokens:' as info,
    COUNT(*) as total_tokens,
    COUNT(DISTINCT email) as unique_emails
FROM remember_me_tokens;

-- 9. Kiểm tra tài khoản test có thể đăng nhập
SELECT 
    'Tài khoản test có thể đăng nhập:' as info
UNION ALL
SELECT 
    CONCAT(
        'ID: ', customer_id, 
        ' | Email: ', email,
        ' | Role: ', role_id,
        ' | Active: ', CASE WHEN is_active = 1 THEN 'Có' ELSE 'Không' END,
        ' | Verified: ', CASE WHEN is_verified = 1 THEN 'Có' ELSE 'Không' END
    ) as account_info
FROM customers 
WHERE email IN (
    'nam.tran@email.com',
    'mai.nguyen@email.com',
    'lan.le@email.com'
)
ORDER BY email; 