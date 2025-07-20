-- Test script để kiểm tra các trang promotion
-- Chạy script này để đảm bảo có dữ liệu test

-- 1. Kiểm tra tài khoản customer có thể login
SELECT 
    a.accountID,
    a.username,
    a.email,
    a.status,
    a.roleID,
    r.roleName,
    c.customerID,
    c.fullName,
    c.phone
FROM Account a
JOIN Role r ON a.roleID = r.roleID
LEFT JOIN Customer c ON a.accountID = c.accountID
WHERE r.roleName = 'CUSTOMER' 
AND a.status = 'VERIFIED'
ORDER BY a.accountID;

-- 2. Kiểm tra promotion có sẵn
SELECT 
    p.promotionID,
    p.title,
    p.promotionCode,
    p.description,
    p.discountType,
    p.discountValue,
    p.startDate,
    p.endDate,
    p.status,
    p.customerCondition,
    p.usageLimitPerCustomer,
    p.imageURL
FROM Promotion p
WHERE p.status = 'ACTIVE'
AND p.startDate <= CURDATE()
AND p.endDate >= CURDATE()
ORDER BY p.promotionID;

-- 3. Kiểm tra promotion usage của customer
SELECT 
    pu.promotionUsageID,
    pu.customerID,
    pu.promotionID,
    pu.usageDate,
    pu.bookingID,
    p.promotionCode,
    p.title,
    c.fullName as customerName
FROM PromotionUsage pu
JOIN Promotion p ON pu.promotionID = p.promotionID
JOIN Customer c ON pu.customerID = c.customerID
ORDER BY pu.usageDate DESC
LIMIT 10;

-- 4. Test login với customer account
-- Sử dụng account này để test:
-- Username: customer1
-- Password: 123456
-- Hoặc:
-- Username: customer2  
-- Password: 123456

-- 5. Kiểm tra URL mapping trong web.xml
-- Đảm bảo các URL sau được map đúng:
-- /promotions/available -> CustomerPromotionController
-- /promotions/notification -> CustomerPromotionController
-- /promotions/my-promotions -> CustomerPromotionController

-- 6. Kiểm tra AuthorizationFilter
-- Đảm bảo customer có thể access các URL promotion

-- 7. Test các trang JSP đã sửa:
-- - available_promotions.jsp (đã sửa lỗi EL expression)
-- - promotion_notification.jsp (đã sửa lỗi EL expression)
-- - my_promotions.jsp (đã redesign)

-- 8. Kiểm tra session management
-- Đảm bảo customerID được lưu đúng trong session

-- 9. Test notification system
-- Kiểm tra xem có promotion mới nào được tạo không
SELECT 
    p.promotionID,
    p.title,
    p.promotionCode,
    p.createdDate,
    DATEDIFF(CURDATE(), p.createdDate) as days_since_created
FROM Promotion p
WHERE p.createdDate >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
ORDER BY p.createdDate DESC;

-- 10. Kiểm tra image upload
-- Đảm bảo imageURL được lưu đúng format
SELECT 
    promotionID,
    title,
    imageURL,
    CASE 
        WHEN imageURL LIKE 'http%' THEN 'External URL'
        WHEN imageURL LIKE '/%' THEN 'Internal Path'
        ELSE 'Other Format'
    END as url_type
FROM Promotion
WHERE imageURL IS NOT NULL
ORDER BY promotionID; 