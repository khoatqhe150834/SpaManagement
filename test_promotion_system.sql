-- =====================================================
-- TEST SCRIPT: HỆ THỐNG PROMOTION HOÀN CHỈNH
-- =====================================================
-- Chạy script này để kiểm tra toàn bộ hệ thống promotion
-- Sau khi chạy, test các trang promotion

-- =====================================================
-- 1. KIỂM TRA TÀI KHOẢN CUSTOMER CÓ THỂ LOGIN
-- =====================================================
SELECT '=== 1. TÀI KHOẢN CUSTOMER ===' as test_section;

SELECT 
    a.accountID,
    a.username,
    a.email,
    a.status,
    r.roleName,
    c.customerID,
    c.fullName,
    c.phone,
    CASE 
        WHEN a.status = 'VERIFIED' THEN '✅ Có thể login'
        ELSE '❌ Không thể login'
    END as login_status
FROM Account a
JOIN Role r ON a.roleID = r.roleID
LEFT JOIN Customer c ON a.accountID = c.accountID
WHERE r.roleName = 'CUSTOMER'
ORDER BY a.accountID;

-- =====================================================
-- 2. KIỂM TRA PROMOTION CÓ SẴN
-- =====================================================
SELECT '=== 2. PROMOTION CÓ SẴN ===' as test_section;

SELECT 
    p.promotionID,
    p.title,
    p.promotionCode,
    p.discountType,
    p.discountValue,
    p.startDate,
    p.endDate,
    p.status,
    p.customerCondition,
    p.usageLimitPerCustomer,
    CASE 
        WHEN p.status = 'ACTIVE' AND p.startDate <= CURDATE() AND p.endDate >= CURDATE() 
        THEN '✅ Có thể sử dụng'
        ELSE '❌ Không thể sử dụng'
    END as availability_status
FROM Promotion p
ORDER BY p.promotionID;

-- =====================================================
-- 3. KIỂM TRA PROMOTION USAGE
-- =====================================================
SELECT '=== 3. PROMOTION USAGE ===' as test_section;

SELECT 
    pu.promotionUsageID,
    pu.customerID,
    pu.promotionID,
    pu.usageDate,
    p.promotionCode,
    p.title,
    c.fullName as customerName
FROM PromotionUsage pu
JOIN Promotion p ON pu.promotionID = p.promotionID
JOIN Customer c ON pu.customerID = c.customerID
ORDER BY pu.usageDate DESC
LIMIT 10;

-- =====================================================
-- 4. KIỂM TRA CUSTOMER PROMOTION SUMMARY
-- =====================================================
SELECT '=== 4. CUSTOMER PROMOTION SUMMARY ===' as test_section;

-- Test với customer ID = 1
SELECT 
    c.customerID,
    c.fullName,
    COUNT(pu.promotionUsageID) as total_usage,
    COUNT(DISTINCT pu.promotionID) as unique_promotions_used
FROM Customer c
LEFT JOIN PromotionUsage pu ON c.customerID = pu.customerID
WHERE c.customerID = 1
GROUP BY c.customerID, c.fullName;

-- =====================================================
-- 5. KIỂM TRA PROMOTION IMAGE
-- =====================================================
SELECT '=== 5. PROMOTION IMAGE ===' as test_section;

SELECT 
    promotionID,
    title,
    imageURL,
    CASE 
        WHEN imageURL IS NULL THEN '❌ Không có ảnh'
        WHEN imageURL LIKE 'http%' THEN '✅ External URL'
        WHEN imageURL LIKE '/%' THEN '✅ Internal Path'
        ELSE '⚠️ Other Format'
    END as image_status
FROM Promotion
ORDER BY promotionID;

-- =====================================================
-- 6. KIỂM TRA PROMOTION MỚI (7 NGÀY QUA)
-- =====================================================
SELECT '=== 6. PROMOTION MỚI ===' as test_section;

SELECT 
    p.promotionID,
    p.title,
    p.promotionCode,
    p.createdDate,
    DATEDIFF(CURDATE(), p.createdDate) as days_since_created,
    CASE 
        WHEN DATEDIFF(CURDATE(), p.createdDate) <= 7 THEN '🆕 Mới'
        ELSE '📅 Cũ'
    END as new_status
FROM Promotion p
WHERE p.createdDate >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
ORDER BY p.createdDate DESC;

-- =====================================================
-- 7. KIỂM TRA PROMOTION CONDITIONS
-- =====================================================
SELECT '=== 7. PROMOTION CONDITIONS ===' as test_section;

SELECT 
    p.promotionID,
    p.title,
    p.promotionCode,
    p.minimumAppointmentValue,
    p.customerCondition,
    p.usageLimitPerCustomer,
    CASE 
        WHEN p.minimumAppointmentValue IS NULL OR p.minimumAppointmentValue = 0 
        THEN '✅ Không có điều kiện giá trị tối thiểu'
        ELSE CONCAT('💰 Tối thiểu: ', FORMAT(p.minimumAppointmentValue, 0), '₫')
    END as minimum_value_status,
    CASE 
        WHEN p.customerCondition = 'INDIVIDUAL' THEN '👤 Khách hàng cá nhân'
        WHEN p.customerCondition = 'COUPLE' THEN '💑 Khách hàng đi cặp'
        WHEN p.customerCondition = 'GROUP' THEN '👥 Khách hàng đi nhóm'
        ELSE '🌍 Tất cả khách hàng'
    END as customer_condition_status
FROM Promotion p
ORDER BY p.promotionID;

-- =====================================================
-- 8. TEST DATA CHO CUSTOMER LOGIN
-- =====================================================
SELECT '=== 8. TEST DATA CHO CUSTOMER LOGIN ===' as test_section;

-- Tạo test customer nếu chưa có
INSERT IGNORE INTO Account (username, password, email, status, roleID) 
VALUES ('testcustomer', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'testcustomer@example.com', 'VERIFIED', 6);

INSERT IGNORE INTO Customer (accountID, fullName, phone, address, dateOfBirth, gender, email) 
SELECT a.accountID, 'Test Customer', '0123456789', 'Test Address', '1990-01-01', 'MALE', a.email
FROM Account a 
WHERE a.username = 'testcustomer' AND NOT EXISTS (SELECT 1 FROM Customer c WHERE c.accountID = a.accountID);

-- Hiển thị test account
SELECT 
    'Test Account Info:' as info,
    a.username,
    a.password,
    a.email,
    a.status,
    r.roleName,
    c.customerID,
    c.fullName
FROM Account a
JOIN Role r ON a.roleID = r.roleID
LEFT JOIN Customer c ON a.accountID = c.accountID
WHERE a.username = 'testcustomer';

-- =====================================================
-- 9. KIỂM TRA ROLE PERMISSIONS
-- =====================================================
SELECT '=== 9. ROLE PERMISSIONS ===' as test_section;

SELECT 
    r.roleID,
    r.roleName,
    r.description,
    CASE 
        WHEN r.roleName = 'CUSTOMER' THEN '✅ Có thể access /promotions/*'
        WHEN r.roleName IN ('ADMIN', 'MANAGER', 'MARKETING') THEN '✅ Có thể quản lý promotion'
        ELSE '❌ Không có quyền promotion'
    END as promotion_permission
FROM Role r
ORDER BY r.roleID;

-- =====================================================
-- 10. SUMMARY REPORT
-- =====================================================
SELECT '=== 10. SUMMARY REPORT ===' as test_section;

SELECT 
    'Tổng số promotion' as metric,
    COUNT(*) as value
FROM Promotion
UNION ALL
SELECT 
    'Promotion đang active',
    COUNT(*)
FROM Promotion 
WHERE status = 'ACTIVE' AND startDate <= CURDATE() AND endDate >= CURDATE()
UNION ALL
SELECT 
    'Customer có thể login',
    COUNT(*)
FROM Account a
JOIN Role r ON a.roleID = r.roleID
WHERE r.roleName = 'CUSTOMER' AND a.status = 'VERIFIED'
UNION ALL
SELECT 
    'Promotion có ảnh',
    COUNT(*)
FROM Promotion 
WHERE imageURL IS NOT NULL;

-- =====================================================
-- HƯỚNG DẪN TEST
-- =====================================================
SELECT '=== HƯỚNG DẪN TEST ===' as test_section;

SELECT '1. Login với customer account:' as step;
SELECT '   - Username: testcustomer' as detail;
SELECT '   - Password: 123456' as detail;
SELECT '' as step;

SELECT '2. Test các trang promotion:' as step;
SELECT '   - /promotions/available' as detail;
SELECT '   - /promotions/my-promotions' as detail;
SELECT '   - /promotions/notification' as detail;
SELECT '' as step;

SELECT '3. Test các tính năng:' as step;
SELECT '   - Copy promotion code' as detail;
SELECT '   - Share promotion' as detail;
SELECT '   - View promotion details' as detail;
SELECT '' as step;

SELECT '4. Kiểm tra lỗi:' as step;
SELECT '   - Không còn lỗi 500' as detail;
SELECT '   - JSP parse đúng' as detail;
SELECT '   - JavaScript hoạt động' as detail; 