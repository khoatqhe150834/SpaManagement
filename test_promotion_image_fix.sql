-- Script test và sửa vấn đề ảnh promotion
USE spa_management;

-- 1. Kiểm tra cấu trúc bảng promotions
DESCRIBE promotions;

-- 2. Kiểm tra dữ liệu ảnh hiện tại
SELECT 
    promotion_id,
    title,
    promotion_code,
    image_url,
    status,
    created_at,
    updated_at
FROM promotions 
ORDER BY promotion_id DESC 
LIMIT 10;

-- 3. Kiểm tra các promotion có ảnh
SELECT 
    COUNT(*) as total_promotions,
    COUNT(image_url) as promotions_with_images,
    COUNT(*) - COUNT(image_url) as promotions_without_images,
    SUM(CASE WHEN image_url IS NOT NULL AND image_url != '' THEN 1 ELSE 0 END) as valid_images
FROM promotions;

-- 4. Tạo dữ liệu test với ảnh mới
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
    customer_condition,
    current_usage_count,
    usage_limit_per_customer,
    total_usage_limit,
    minimum_appointment_value
) VALUES (
    'Test Promotion - Ảnh mới',
    'IMG_TEST',
    'FIXED_AMOUNT',
    150000.00,
    'Khuyến mãi test để kiểm tra ảnh mới',
    'ACTIVE',
    NOW(),
    DATE_ADD(NOW(), INTERVAL 30 DAY),
    '/uploads/promotions/test_new_image.jpg',
    'ALL',
    0,
    100,
    500,
    1000000.00
) ON DUPLICATE KEY UPDATE 
    title = VALUES(title),
    image_url = VALUES(image_url),
    updated_at = NOW();

-- 5. Cập nhật ảnh cho promotion test
UPDATE promotions 
SET 
    image_url = CONCAT('/uploads/promotions/', UNIX_TIMESTAMP(), '_test_promotion.jpg'),
    updated_at = NOW()
WHERE promotion_code = 'IMG_TEST';

-- 6. Kiểm tra kết quả sau khi cập nhật
SELECT 
    promotion_id,
    title,
    promotion_code,
    image_url,
    status,
    updated_at
FROM promotions 
WHERE promotion_code = 'IMG_TEST';

-- 7. Tạo thư mục upload test (nếu chưa có)
-- Trong thực tế, thư mục này sẽ được tạo tự động bởi ứng dụng
-- Thư mục mặc định: /uploads/promotions/

-- 8. Kiểm tra URL ảnh đầy đủ
SELECT 
    promotion_id,
    title,
    promotion_code,
    image_url,
    CONCAT('http://localhost:8080/spa-management', image_url) as full_image_url,
    status
FROM promotions 
WHERE image_url IS NOT NULL AND image_url != ''
ORDER BY promotion_id DESC 
LIMIT 5;

-- 9. Kiểm tra cache busting
SELECT 
    promotion_id,
    title,
    promotion_code,
    image_url,
    CONCAT('http://localhost:8080/spa-management', image_url, '?v=', UNIX_TIMESTAMP()) as cache_busted_url,
    status
FROM promotions 
WHERE image_url IS NOT NULL AND image_url != ''
ORDER BY promotion_id DESC 
LIMIT 5;

-- 10. Tạo view để kiểm tra ảnh an toàn
CREATE OR REPLACE VIEW promotion_images_safe AS
SELECT 
    p.promotion_id,
    p.title,
    p.promotion_code,
    p.status,
    CASE 
        WHEN p.image_url IS NULL OR p.image_url = '' THEN 'https://placehold.co/300x300/D4AF37/FFFFFF?text=PROMO'
        ELSE CONCAT('/uploads/promotions/', p.image_url)
    END as image_url,
    CASE 
        WHEN p.image_url IS NULL OR p.image_url = '' THEN 'https://placehold.co/300x300/D4AF37/FFFFFF?text=PROMO'
        ELSE CONCAT('/uploads/promotions/', p.image_url, '?v=', UNIX_TIMESTAMP())
    END as cache_busted_image_url,
    p.created_at,
    p.updated_at
FROM promotions p;

-- 11. Test view
SELECT * FROM promotion_images_safe WHERE promotion_code = 'IMG_TEST';

-- 12. Kiểm tra file system (nếu có quyền)
-- Trong thực tế, cần kiểm tra thư mục upload có tồn tại không
-- Thư mục: /uploads/promotions/

-- 13. Tạo procedure để cập nhật ảnh an toàn
DELIMITER //
CREATE PROCEDURE UpdatePromotionImage(IN promo_id INT, IN new_image_url VARCHAR(500))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error updating promotion image' as message;
    END;
    
    START TRANSACTION;
    
    UPDATE promotions 
    SET 
        image_url = new_image_url,
        updated_at = NOW()
    WHERE promotion_id = promo_id;
    
    COMMIT;
    SELECT 'Promotion image updated successfully' as message;
END //
DELIMITER ;

-- 14. Test procedure
CALL UpdatePromotionImage(1, '/uploads/promotions/test_procedure.jpg');

-- 15. Xóa procedure test
DROP PROCEDURE IF EXISTS UpdatePromotionImage;

-- 16. Cleanup test data (uncomment để xóa)
-- DELETE FROM promotions WHERE promotion_code = 'IMG_TEST';

-- 17. Kết quả cuối cùng
SELECT 
    'Promotion Image Fix Summary' as summary,
    COUNT(*) as total_promotions,
    COUNT(image_url) as promotions_with_images,
    COUNT(*) - COUNT(image_url) as promotions_without_images,
    SUM(CASE WHEN image_url LIKE '/uploads/promotions/%' THEN 1 ELSE 0 END) as valid_upload_images
FROM promotions; 