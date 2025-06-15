-- Test Users for MenuService Role-Based Navigation
-- Insert users with different role_id values to test menu functionality

-- Admin User (role_id = 1)
INSERT INTO users (role_id, full_name, email, hash_password, phone_number, gender, birthday, avatar_url, is_active, created_at, updated_at) 
VALUES (1, 'Nguyễn Văn Admin', 'admin@beautyzone.com', '$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW', '0901234567', 'MALE', '1985-01-15', '/assets/avatars/admin.jpg', 1, NOW(), NOW());

-- Manager User (role_id = 2) 
INSERT INTO users (role_id, full_name, email, hash_password, phone_number, gender, birthday, avatar_url, is_active, created_at, updated_at)
VALUES (2, 'Trần Thị Manager', 'manager@beautyzone.com', '$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW', '0901234568', 'FEMALE', '1988-03-20', '/assets/avatars/manager.jpg', 1, NOW(), NOW());

-- Therapist User (role_id = 3)
INSERT INTO users (role_id, full_name, email, hash_password, phone_number, gender, birthday, avatar_url, is_active, created_at, updated_at)
VALUES (3, 'Lê Văn Therapist', 'therapist@beautyzone.com', '$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW', '0901234569', 'MALE', '1990-07-10', '/assets/avatars/therapist.jpg', 1, NOW(), NOW());

-- Receptionist User (role_id = 4)
INSERT INTO users (role_id, full_name, email, hash_password, phone_number, gender, birthday, avatar_url, is_active, created_at, updated_at)
VALUES (4, 'Phạm Thị Receptionist', 'receptionist@beautyzone.com', '$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW', '0901234570', 'FEMALE', '1992-11-25', '/assets/avatars/receptionist.jpg', 1, NOW(), NOW());

-- Additional test users for each role
-- Another Admin
INSERT INTO users (role_id, full_name, email, hash_password, phone_number, gender, birthday, avatar_url, is_active, created_at, updated_at)
VALUES (1, 'Hoàng Minh Quản Trị', 'admin2@beautyzone.com', '$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW', '0901234571', 'MALE', '1987-05-12', '/assets/avatars/admin2.jpg', 1, NOW(), NOW());

-- Another Therapist
INSERT INTO users (role_id, full_name, email, hash_password, phone_number, gender, birthday, avatar_url, is_active, created_at, updated_at)
VALUES (3, 'Nguyễn Thị Spa Master', 'therapist2@beautyzone.com', '$2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW', '0901234572', 'FEMALE', '1989-09-18', '/assets/avatars/therapist2.jpg', 1, NOW(), NOW());

-- Password for all test users is: "123456"
-- Hash: $2a$10$Y/Y.9uE0upqAMPodd.r7qeSjhv1TC4NxFvqFrFFGii0QM1.94v2CW

-- To test, you can login with:
-- admin@beautyzone.com / password123 (Admin menu)
-- manager@beautyzone.com / password123 (Manager menu)  
-- therapist@beautyzone.com / password123 (Therapist menu)
-- receptionist@beautyzone.com / password123 (Receptionist menu)

-- Query to verify the inserted users and their roles:
-- SELECT u.user_id, u.full_name, u.email, u.role_id, r.role_name 
-- FROM users u 
-- LEFT JOIN roles r ON u.role_id = r.role_id 
-- WHERE u.email LIKE '%@beautyzone.com'
-- ORDER BY u.role_id; 