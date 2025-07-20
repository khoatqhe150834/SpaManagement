-- =====================================================
-- FIX PROMOTION DATA - SỬA DỮ LIỆU PROMOTION
-- =====================================================
-- Script này sửa các dữ liệu promotion có thể gây lỗi 500

-- =====================================================
-- 1. KIỂM TRA DỮ LIỆU PROMOTION HIỆN TẠI
-- =====================================================
SELECT '=== 1. KIỂM TRA DỮ LIỆU PROMOTION ===' as section;

SELECT 
    promotionID,
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
    createdDate,
    CASE 
        WHEN title IS NULL OR title = '' THEN '❌ Title rỗng'
        WHEN promotionCode IS NULL OR promotionCode = '' THEN '❌ Code rỗng'
        WHEN startDate IS NULL THEN '❌ StartDate NULL'
        WHEN endDate IS NULL THEN '❌ EndDate NULL'
        WHEN discountValue IS NULL THEN '❌ DiscountValue NULL'
        ELSE '✅ OK'
    END as data_status
FROM Promotion
ORDER BY promotionID;

-- =====================================================
-- 2. SỬA DỮ LIỆU NULL/EMPTY
-- =====================================================
SELECT '=== 2. SỬA DỮ LIỆU NULL/EMPTY ===' as section;

-- Sửa title NULL/empty
UPDATE Promotion 
SET title = CONCAT('Khuyến mãi #', promotionID)
WHERE title IS NULL OR title = '';

-- Sửa promotionCode NULL/empty
UPDATE Promotion 
SET promotionCode = CONCAT('PROMO', LPAD(promotionID, 3, '0'))
WHERE promotionCode IS NULL OR promotionCode = '';

-- Sửa description NULL/empty
UPDATE Promotion 
SET description = CONCAT('Khuyến mãi đặc biệt dành cho khách hàng. Mã: ', promotionCode)
WHERE description IS NULL OR description = '';

-- Sửa startDate NULL
UPDATE Promotion 
SET startDate = CURDATE()
WHERE startDate IS NULL;

-- Sửa endDate NULL
UPDATE Promotion 
SET endDate = DATE_ADD(CURDATE(), INTERVAL 30 DAY)
WHERE endDate IS NULL;

-- Sửa discountValue NULL
UPDATE Promotion 
SET discountValue = 10
WHERE discountValue IS NULL;

-- Sửa discountType NULL
UPDATE Promotion 
SET discountType = 'PERCENTAGE'
WHERE discountType IS NULL;

-- Sửa status NULL
UPDATE Promotion 
SET status = 'ACTIVE'
WHERE status IS NULL;

-- Sửa customerCondition NULL
UPDATE Promotion 
SET customerCondition = 'ALL'
WHERE customerCondition IS NULL;

-- =====================================================
-- 3. KIỂM TRA SAU KHI SỬA
-- =====================================================
SELECT '=== 3. KIỂM TRA SAU KHI SỬA ===' as section;

SELECT 
    promotionID,
    title,
    promotionCode,
    discountType,
    discountValue,
    startDate,
    endDate,
    status,
    customerCondition,
    CASE 
        WHEN title IS NOT NULL AND title != '' 
         AND promotionCode IS NOT NULL AND promotionCode != ''
         AND startDate IS NOT NULL 
         AND endDate IS NOT NULL 
         AND discountValue IS NOT NULL 
         AND discountType IS NOT NULL 
         AND status IS NOT NULL 
         AND customerCondition IS NOT NULL
        THEN '✅ Đã sửa'
        ELSE '❌ Vẫn còn lỗi'
    END as fix_status
FROM Promotion
ORDER BY promotionID;

-- =====================================================
-- 4. TẠO TEST DATA NẾU CHƯA CÓ
-- =====================================================
SELECT '=== 4. TẠO TEST DATA ===' as section;

-- Kiểm tra xem có promotion nào không
SELECT COUNT(*) as total_promotions FROM Promotion;

-- Nếu không có promotion nào, tạo test data
INSERT IGNORE INTO Promotion (
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
('Chào Hè Rực Rỡ - Giảm 20%', 'SUMMER20', 'Giảm giá 20% cho tất cả dịch vụ massage.', 'PERCENTAGE', 20, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 60 DAY), 'ACTIVE', 'ALL', 1000000, 1, NULL, NOW()),
('Khuyến mãi đầu tuần', 'MONDAY10', 'Giảm 10% cho dịch vụ vào thứ 2 hàng tuần.', 'PERCENTAGE', 10, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY), 'ACTIVE', 'INDIVIDUAL', 500000, 2, NULL, NOW()),
('Ưu đãi cặp đôi', 'COUPLE15', 'Giảm 15% cho khách hàng đi cặp.', 'PERCENTAGE', 15, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 45 DAY), 'ACTIVE', 'COUPLE', 800000, 1, NULL, NOW()),
('Giảm giá nhóm', 'GROUP25', 'Giảm 25% cho nhóm từ 3 người trở lên.', 'PERCENTAGE', 25, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 90 DAY), 'ACTIVE', 'GROUP', 1500000, 1, NULL, NOW()),
('Khuyến mãi sinh nhật', 'BIRTHDAY50', 'Giảm 50% cho khách hàng trong tháng sinh nhật.', 'PERCENTAGE', 50, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 365 DAY), 'ACTIVE', 'ALL', 200000, 1, NULL, NOW());

-- =====================================================
-- 5. KIỂM TRA FINAL RESULT
-- =====================================================
SELECT '=== 5. FINAL RESULT ===' as section;

SELECT 
    promotionID,
    title,
    promotionCode,
    discountType,
    discountValue,
    startDate,
    endDate,
    status,
    customerCondition,
    minimumAppointmentValue,
    usageLimitPerCustomer
FROM Promotion
ORDER BY promotionID;

-- =====================================================
-- 6. TEST CUSTOMER ACCOUNT
-- =====================================================
SELECT '=== 6. TEST CUSTOMER ACCOUNT ===' as section;

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
-- 7. SUMMARY
-- =====================================================
SELECT '=== 7. SUMMARY ===' as section;

SELECT 
    'Tổng số promotion' as metric,
    COUNT(*) as value
FROM Promotion
UNION ALL
SELECT 
    'Promotion active',
    COUNT(*)
FROM Promotion 
WHERE status = 'ACTIVE' AND startDate <= CURDATE() AND endDate >= CURDATE()
UNION ALL
SELECT 
    'Promotion có dữ liệu đầy đủ',
    COUNT(*)
FROM Promotion 
WHERE title IS NOT NULL AND title != ''
  AND promotionCode IS NOT NULL AND promotionCode != ''
  AND startDate IS NOT NULL 
  AND endDate IS NOT NULL 
  AND discountValue IS NOT NULL;

-- =====================================================
-- HƯỚNG DẪN TEST
-- =====================================================
SELECT '=== HƯỚNG DẪN TEST ===' as section;

SELECT '1. Chạy script này để sửa dữ liệu' as step;
SELECT '2. Login với: testcustomer / 123456' as step;
SELECT '3. Truy cập: /promotions/available' as step;
SELECT '4. Kiểm tra không còn lỗi 500' as step; 