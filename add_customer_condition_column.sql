-- Thêm cột customer_condition vào bảng promotions
-- Script này cần chạy trên cơ sở dữ liệu để cập nhật schema

-- Kiểm tra xem cột đã tồn tại chưa
SET @column_exists = (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'promotions'
    AND COLUMN_NAME = 'customer_condition'
);

-- Chỉ thêm cột nếu chưa tồn tại
SET @sql = IF(@column_exists = 0,
    'ALTER TABLE promotions ADD COLUMN customer_condition VARCHAR(20) DEFAULT "ALL" COMMENT "Điều kiện khách hàng: ALL, INDIVIDUAL, COUPLE, GROUP"',
    'SELECT "Column customer_condition already exists" as message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Cập nhật dữ liệu hiện có
UPDATE promotions 
SET customer_condition = 'ALL' 
WHERE customer_condition IS NULL;

-- Thêm constraint để đảm bảo giá trị hợp lệ (chỉ nếu chưa có)
SET @constraint_exists = (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'promotions'
    AND CONSTRAINT_NAME = 'chk_customer_condition'
);

SET @sql_constraint = IF(@constraint_exists = 0,
    'ALTER TABLE promotions ADD CONSTRAINT chk_customer_condition CHECK (customer_condition IN ("ALL", "INDIVIDUAL", "COUPLE", "GROUP"))',
    'SELECT "Constraint chk_customer_condition already exists" as message'
);

PREPARE stmt_constraint FROM @sql_constraint;
EXECUTE stmt_constraint;
DEALLOCATE PREPARE stmt_constraint;

-- Thêm comment cho bảng
ALTER TABLE promotions 
COMMENT = 'Bảng khuyến mãi với điều kiện áp dụng cho từng loại khách hàng';

-- Hiển thị cấu trúc bảng sau khi cập nhật
DESCRIBE promotions;

-- Hiển thị dữ liệu mẫu để kiểm tra
SELECT promotion_id, title, promotion_code, customer_condition, status 
FROM promotions 
LIMIT 5; 
 
 