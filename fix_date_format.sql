-- =====================================================
-- FIX DATE FORMAT - SỬA FORMAT DATE
-- =====================================================
-- Script này sửa các vấn đề về date format có thể gây lỗi 500

-- =====================================================
-- 1. KIỂM TRA DATE FORMAT HIỆN TẠI
-- =====================================================
SELECT '=== 1. KIỂM TRA DATE FORMAT ===' as section;

SELECT 
    promotionID,
    title,
    startDate,
    endDate,
    createdDate,
    CASE 
        WHEN startDate IS NULL THEN '❌ StartDate NULL'
        WHEN endDate IS NULL THEN '❌ EndDate NULL'
        WHEN startDate > endDate THEN '❌ StartDate > EndDate'
        ELSE '✅ OK'
    END as date_status
FROM Promotion
ORDER BY promotionID;

-- =====================================================
-- 2. SỬA DATE FORMAT
-- =====================================================
SELECT '=== 2. SỬA DATE FORMAT ===' as section;

-- Sửa startDate NULL
UPDATE Promotion 
SET startDate = CURDATE()
WHERE startDate IS NULL;

-- Sửa endDate NULL
UPDATE Promotion 
SET endDate = DATE_ADD(CURDATE(), INTERVAL 30 DAY)
WHERE endDate IS NULL;

-- Sửa endDate < startDate
UPDATE Promotion 
SET endDate = DATE_ADD(startDate, INTERVAL 30 DAY)
WHERE endDate < startDate;

-- =====================================================
-- 3. TẠO TEST DATA VỚI DATE ĐÚNG
-- =====================================================
SELECT '=== 3. TẠO TEST DATA ===' as section;

-- Xóa test data cũ nếu có
DELETE FROM Promotion WHERE title LIKE '%Test%';

-- Tạo test data mới với date đúng format
INSERT INTO Promotion (
    title, 
    promotionCode, 
    description, 
    discountType, 
    discountValue, 
    startDate, 
    endDate, 
    status, 
    customerCondition, 
    minimumAppointmentValue, 
    usageLimitPerCustomer, 
    imageURL, 
    createdDate
) VALUES 
('Test Khuyến Mãi 1', 'TEST001', 'Khuyến mãi test 1', 'PERCENTAGE', 10, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), 'ACTIVE', 'ALL', 500000, 1, NULL, NOW()),
('Test Khuyến Mãi 2', 'TEST002', 'Khuyến mãi test 2', 'FIXED_AMOUNT', 50000, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 60 DAY), 'ACTIVE', 'INDIVIDUAL', 1000000, 2, NULL, NOW()),
('Test Khuyến Mãi 3', 'TEST003', 'Khuyến mãi test 3', 'PERCENTAGE', 20, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 90 DAY), 'ACTIVE', 'COUPLE', 800000, 1, NULL, NOW());

-- =====================================================
-- 4. KIỂM TRA SAU KHI SỬA
-- =====================================================
SELECT '=== 4. KIỂM TRA SAU KHI SỬA ===' as section;

SELECT 
    promotionID,
    title,
    promotionCode,
    startDate,
    endDate,
    DATEDIFF(endDate, startDate) as duration_days,
    CASE 
        WHEN startDate IS NOT NULL 
         AND endDate IS NOT NULL 
         AND startDate <= endDate 
         AND startDate <= CURDATE()
         AND endDate >= CURDATE()
        THEN '✅ Có thể sử dụng'
        ELSE '❌ Không thể sử dụng'
    END as availability_status
FROM Promotion
ORDER BY promotionID;

-- =====================================================
-- 5. TEST CUSTOMER ACCOUNT
-- =====================================================
SELECT '=== 5. TEST CUSTOMER ACCOUNT ===' as section;

-- Tạo test customer nếu chưa có
INSERT IGNORE INTO Account (username, password, email, status, roleID) 
VALUES ('testcustomer', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'testcustomer@example.com', 'VERIFIED', 6);

INSERT IGNORE INTO Customer (accountID, fullName, phone, address, dateOfBirth, gender, email) 
SELECT a.accountID, 'Test Customer', '0123456789', 'Test Address', '1990-01-01', 'MALE', a.email
FROM Account a 
WHERE a.username = 'testcustomer' AND NOT EXISTS (SELECT 1 FROM Customer c WHERE c.accountID = a.accountID);

-- Hiển thị test account
SELECT 
    'Test Account:' as info,
    a.username,
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
-- 6. SUMMARY
-- =====================================================
SELECT '=== 6. SUMMARY ===' as section;

SELECT 
    'Tổng số promotion' as metric,
    COUNT(*) as value
FROM Promotion
UNION ALL
SELECT 
    'Promotion có date hợp lệ',
    COUNT(*)
FROM Promotion 
WHERE startDate IS NOT NULL 
  AND endDate IS NOT NULL 
  AND startDate <= endDate
UNION ALL
SELECT 
    'Promotion đang active',
    COUNT(*)
FROM Promotion 
WHERE status = 'ACTIVE' 
  AND startDate <= CURDATE() 
  AND endDate >= CURDATE();

-- =====================================================
-- HƯỚNG DẪN TEST
-- =====================================================
SELECT '=== HƯỚNG DẪN TEST ===' as section;

SELECT '1. Chạy script này để sửa date format' as step;
SELECT '2. Login với: testcustomer / 123456' as step;
SELECT '3. Truy cập: /promotions/available' as step;
SELECT '4. Kiểm tra không còn lỗi 500 ở phần hiển thị ngày' as step; 