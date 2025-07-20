-- Test script cho tính năng upload ảnh promotion
USE spa_management;

-- 1. Kiểm tra cấu trúc bảng promotions
DESCRIBE promotions;

-- 2. Kiểm tra cột image_url
SELECT promotion_id, title, promotion_code, image_url, status 
FROM promotions 
WHERE image_url IS NOT NULL 
LIMIT 5;

-- 3. Tạo thư mục upload test (nếu chưa có)
-- Trong thực tế, thư mục này sẽ được tạo tự động bởi ứng dụng
-- Thư mục mặc định: /uploads/promotions/

-- 4. Test query để kiểm tra ảnh hiện có
SELECT 
    promotion_id,
    title,
    promotion_code,
    CASE 
        WHEN image_url IS NULL OR image_url = '' THEN 'Không có ảnh'
        ELSE CONCAT('Có ảnh: ', image_url)
    END as image_status,
    status
FROM promotions 
ORDER BY promotion_id DESC 
LIMIT 10;

-- 5. Kiểm tra các promotion có ảnh
SELECT 
    COUNT(*) as total_promotions,
    COUNT(image_url) as promotions_with_images,
    COUNT(*) - COUNT(image_url) as promotions_without_images
FROM promotions;

-- 6. Tạo dữ liệu test cho promotion với ảnh
INSERT INTO promotions (
    title, 
    promotion_code, 
    discount_type, 
    discount_value, 
    description, 
    status, 
    start_date, 
    end_date, 
    image_url,
    customer_condition
) VALUES 
('Khuyến mãi test ảnh 1', 'IMG1', 'PERCENTAGE', 15.00, 'Test upload ảnh 1', 'ACTIVE', NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), '/uploads/promotions/test_image_1.jpg', 'ALL'),
('Khuyến mãi test ảnh 2', 'IMG2', 'FIXED_AMOUNT', 100000.00, 'Test upload ảnh 2', 'ACTIVE', NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), '/uploads/promotions/test_image_2.png', 'ALL')
ON DUPLICATE KEY UPDATE 
    title = VALUES(title),
    discount_value = VALUES(discount_value),
    image_url = VALUES(image_url);

-- 7. Kiểm tra kết quả sau khi thêm
SELECT 
    promotion_id,
    title,
    promotion_code,
    image_url,
    status
FROM promotions 
WHERE promotion_code IN ('IMG1', 'IMG2');

-- 8. Cleanup test data (uncomment để xóa)
-- DELETE FROM promotions WHERE promotion_code IN ('IMG1', 'IMG2');

-- 9. Kiểm tra cấu hình upload trong web.xml
-- Đảm bảo có cấu hình MultipartConfig trong PromotionController:
-- @MultipartConfig(
--     fileSizeThreshold = 1024 * 1024,    // 1 MB
--     maxFileSize = 1024 * 1024 * 10,     // 10 MB
--     maxRequestSize = 1024 * 1024 * 50   // 50 MB
-- )

-- 10. Kiểm tra ImageUploadValidator
-- Đảm bảo file util/ImageUploadValidator.java có các validation:
-- - Kiểm tra định dạng file (JPG, PNG, GIF, WEBP)
-- - Kiểm tra kích thước file (tối đa 10MB)
-- - Kiểm tra file không null

-- 11. Test URL ảnh
-- Trong JSP, ảnh sẽ được hiển thị như sau:
-- <img src="${pageContext.request.contextPath}${promotion.imageUrl}" alt="${promotion.title}">
-- 
-- Ví dụ: nếu image_url = '/uploads/promotions/1234567890_promotion.jpg'
-- thì URL đầy đủ sẽ là: http://localhost:8080/spa-management/uploads/promotions/1234567890_promotion.jpg 