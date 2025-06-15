-- Test Customers for Customer Management
-- Insert sample customers into the customers table

-- Sample customers with various data
INSERT INTO customers (role_id, full_name, email, hash_password, phone_number, gender, birthday, address, is_active, loyalty_points, created_at, updated_at) 
VALUES 
    (1, 'Nguyễn Thị Lan', 'lan.nguyen@email.com', '$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW', '0901234567', 'Female', '1992-05-15', '123 Nguyễn Trãi, Quận 1, TP.HCM', 1, 150, NOW(), NOW()),
    
    (1, 'Trần Văn Minh', 'minh.tran@email.com', '$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW', '0901234568', 'Male', '1988-11-22', '456 Lê Lợi, Quận 3, TP.HCM', 1, 200, NOW(), NOW()),
    
    (1, 'Lê Thị Hoa', 'hoa.le@email.com', '$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW', '0901234569', 'Female', '1995-08-10', '789 Trần Hưng Đạo, Quận 5, TP.HCM', 1, 320, NOW(), NOW()),
    
    (1, 'Phạm Quốc Dũng', 'dung.pham@email.com', '$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW', '0901234570', 'Male', '1990-03-18', '321 Võ Văn Tần, Quận 3, TP.HCM', 1, 450, NOW(), NOW()),
    
    (1, 'Hoàng Thị Mai', 'mai.hoang@email.com', '$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW', '0901234571', 'Female', '1993-12-07', '654 Cách Mạng Tháng 8, Quận 10, TP.HCM', 1, 180, NOW(), NOW()),
    
    (1, 'Nguyễn Văn Thành', 'thanh.nguyen@email.com', '$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW', '0901234572', 'Male', '1987-06-25', '987 Điện Biên Phủ, Quận Bình Thạnh, TP.HCM', 1, 275, NOW(), NOW()),
    
    (1, 'Trần Thị Bình', 'binh.tran@email.com', '$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW', '0901234573', 'Female', '1991-09-14', '147 Nam Kỳ Khởi Nghĩa, Quận 1, TP.HCM', 0, 90, NOW(), NOW()),
    
    (1, 'Lê Văn Tùng', 'tung.le@email.com', '$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW', '0901234574', 'Male', '1994-01-30', '258 Lý Tự Trọng, Quận 1, TP.HCM', 1, 380, NOW(), NOW()),
    
    (1, 'Phạm Thị Yến', 'yen.pham@email.com', '$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW', '0901234575', 'Female', '1989-04-12', '369 Pasteur, Quận 3, TP.HCM', 1, 520, NOW(), NOW()),
    
    (1, 'Hoàng Văn Long', 'long.hoang@email.com', '$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW', '0901234576', 'Male', '1986-10-08', '741 Hai Bà Trưng, Quận 1, TP.HCM', 1, 210, NOW(), NOW());

-- Password for all test customers is: "123456"  
-- Hash: $2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW

-- Add some inactive customers for testing status filter
INSERT INTO customers (role_id, full_name, email, hash_password, phone_number, gender, birthday, address, is_active, loyalty_points, created_at, updated_at) 
VALUES 
    (1, 'Nguyễn Thị Inactive', 'inactive1@email.com', '$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW', '0901234577', 'Female', '1985-07-20', '852 Inactive Street', 0, 0, NOW(), NOW()),
    
    (1, 'Trần Văn Disabled', 'disabled@email.com', '$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW', '0901234578', 'Male', '1983-02-14', '963 Disabled Avenue', 0, 50, NOW(), NOW());

-- Query to verify the inserted customers:
-- SELECT customer_id, full_name, email, phone_number, gender, is_active, loyalty_points, created_at 
-- FROM customers 
-- ORDER BY customer_id; 