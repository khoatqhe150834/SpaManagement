-- Thêm cột customer_condition vào bảng promotions
-- Script này cần chạy trên cơ sở dữ liệu để cập nhật schema

-- Kiểm tra và thêm cột customer_condition nếu chưa tồn tại
ALTER TABLE promotions 
ADD COLUMN customer_condition VARCHAR(20) DEFAULT 'ALL' 
COMMENT 'Điều kiện khách hàng: ALL, INDIVIDUAL, COUPLE, GROUP';

-- Cập nhật dữ liệu hiện có
UPDATE promotions 
SET customer_condition = 'ALL' 
WHERE customer_condition IS NULL;

-- Thêm constraint để đảm bảo giá trị hợp lệ
ALTER TABLE promotions 
ADD CONSTRAINT chk_customer_condition 
CHECK (customer_condition IN ('ALL', 'INDIVIDUAL', 'COUPLE', 'GROUP'));

-- Thêm comment cho bảng
ALTER TABLE promotions 
COMMENT = 'Bảng khuyến mãi với điều kiện áp dụng cho từng loại khách hàng';

-- Hiển thị cấu trúc bảng sau khi cập nhật
DESCRIBE promotions; 
 
 