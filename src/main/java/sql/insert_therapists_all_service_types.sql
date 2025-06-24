-- Insert therapists for all remaining service types (5-15)
-- This ensures CSP simulation can find qualified therapists for all services

-- First, insert users for the new therapists
INSERT INTO `users` (`role_id`, `email`, `password`, `full_name`, `phone_number`, `gender`, `birthday`, `avatar_url`, `address`, `is_verified`, `created_at`, `updated_at`) VALUES
-- Service Type 5: Chăm Sóc Móng (Nail Care)
(3, 'nail.specialist1@spaluxury.com', '$2a$10$encrypted_password', 'Nguyễn Minh Anh', '0903456789', 'FEMALE', '1992-03-15', '/assets/staff/nail_specialist1.jpg', '123 Nail Street, HCM', 1, NOW(), NOW()),
(3, 'nail.specialist2@spaluxury.com', '$2a$10$encrypted_password', 'Trần Thùy Linh', '0903456790', 'FEMALE', '1990-07-22', '/assets/staff/nail_specialist2.jpg', '456 Beauty Ave, HCM', 1, NOW(), NOW()),

-- Service Type 6: Tẩy Lông & Waxing
(3, 'waxing.expert1@spaluxury.com', '$2a$10$encrypted_password', 'Lê Thị Hương', '0903456791', 'FEMALE', '1988-11-08', '/assets/staff/waxing_expert1.jpg', '789 Smooth Road, HCM', 1, NOW(), NOW()),
(3, 'waxing.expert2@spaluxury.com', '$2a$10$encrypted_password', 'Phạm Thị Lan', '0903456792', 'FEMALE', '1993-02-14', '/assets/staff/waxing_expert2.jpg', '321 Hair Free St, HCM', 1, NOW(), NOW()),

-- Service Type 7: Chăm Sóc Lông Mi & Lông Mày (Eye Care)
(3, 'eyecare.artist1@spaluxury.com', '$2a$10$encrypted_password', 'Võ Thị Mai', '0903456793', 'FEMALE', '1991-09-30', '/assets/staff/eyecare_artist1.jpg', '654 Brow Lane, HCM', 1, NOW(), NOW()),
(3, 'eyecare.artist2@spaluxury.com', '$2a$10$encrypted_password', 'Đặng Thị Ngọc', '0903456794', 'FEMALE', '1989-04-18', '/assets/staff/eyecare_artist2.jpg', '987 Lash Blvd, HCM', 1, NOW(), NOW()),

-- Service Type 8: Liệu Pháp Thơm (Aromatherapy)
(3, 'aroma.therapist1@spaluxury.com', '$2a$10$encrypted_password', 'Hoàng Thị Bình', '0903456795', 'FEMALE', '1987-12-05', '/assets/staff/aroma_therapist1.jpg', '147 Scent Street, HCM', 1, NOW(), NOW()),
(3, 'aroma.therapist2@spaluxury.com', '$2a$10$encrypted_password', 'Ngô Thị Thu', '0903456796', 'FEMALE', '1994-01-25', '/assets/staff/aroma_therapist2.jpg', '258 Fragrance Ave, HCM', 1, NOW(), NOW()),

-- Service Type 9: Liệu Pháp Nước (Hydrotherapy)
(3, 'hydro.therapist1@spaluxury.com', '$2a$10$encrypted_password', 'Bùi Văn Đức', '0903456797', 'MALE', '1986-06-12', '/assets/staff/hydro_therapist1.jpg', '369 Water Way, HCM', 1, NOW(), NOW()),
(3, 'hydro.therapist2@spaluxury.com', '$2a$10$encrypted_password', 'Lý Thị Hoa', '0903456798', 'FEMALE', '1992-08-20', '/assets/staff/hydro_therapist2.jpg', '741 Aqua Road, HCM', 1, NOW(), NOW()),

-- Service Type 10: Y Học Cổ Truyền Việt Nam (Traditional Medicine)
(3, 'traditional.healer1@spaluxury.com', '$2a$10$encrypted_password', 'Trần Văn Hiếu', '0903456799', 'MALE', '1975-03-10', '/assets/staff/traditional_healer1.jpg', '852 Heritage St, HCM', 1, NOW(), NOW()),
(3, 'traditional.healer2@spaluxury.com', '$2a$10$encrypted_password', 'Phạm Thị Cúc', '0903456800', 'FEMALE', '1980-11-22', '/assets/staff/traditional_healer2.jpg', '963 Ancient Way, HCM', 1, NOW(), NOW()),

-- Service Type 11: Giảm Cân & Định Hình Cơ Thể (Slimming)
(3, 'slimming.coach1@spaluxury.com', '$2a$10$encrypted_password', 'Vũ Thị Xuân', '0903456801', 'FEMALE', '1985-05-15', '/assets/staff/slimming_coach1.jpg', '159 Fit Street, HCM', 1, NOW(), NOW()),
(3, 'slimming.coach2@spaluxury.com', '$2a$10$encrypted_password', 'Đinh Văn Mạnh', '0903456802', 'MALE', '1983-09-07', '/assets/staff/slimming_coach2.jpg', '357 Shape Ave, HCM', 1, NOW(), NOW()),

-- Service Type 12: Dịch Vụ Cặp Đôi (Couples Services)
(3, 'couples.specialist1@spaluxury.com', '$2a$10$encrypted_password', 'Lê Thị Yến', '0903456803', 'FEMALE', '1990-02-28', '/assets/staff/couples_specialist1.jpg', '468 Romance Road, HCM', 1, NOW(), NOW()),
(3, 'couples.specialist2@spaluxury.com', '$2a$10$encrypted_password', 'Trương Văn Phước', '0903456804', 'MALE', '1988-07-16', '/assets/staff/couples_specialist2.jpg', '579 Love Lane, HCM', 1, NOW(), NOW()),

-- Service Type 13: Chống Lão Hóa (Anti-Aging)
(3, 'antiaging.expert1@spaluxury.com', '$2a$10$encrypted_password', 'Châu Thị Mỹ', '0903456805', 'FEMALE', '1982-10-03', '/assets/staff/antiaging_expert1.jpg', '680 Youth Street, HCM', 1, NOW(), NOW()),
(3, 'antiaging.expert2@spaluxury.com', '$2a$10$encrypted_password', 'Hồ Thị Liễu', '0903456806', 'FEMALE', '1984-12-11', '/assets/staff/antiaging_expert2.jpg', '791 Renewal Ave, HCM', 1, NOW(), NOW()),

-- Service Type 14: Thải Độc & Thanh Lọc (Detox)
(3, 'detox.specialist1@spaluxury.com', '$2a$10$encrypted_password', 'Dương Thị Nhàn', '0903456807', 'FEMALE', '1987-04-19', '/assets/staff/detox_specialist1.jpg', '802 Cleanse Blvd, HCM', 1, NOW(), NOW()),
(3, 'detox.specialist2@spaluxury.com', '$2a$10$encrypted_password', 'Phan Văn Tú', '0903456808', 'MALE', '1986-08-26', '/assets/staff/detox_specialist2.jpg', '913 Pure Path, HCM', 1, NOW(), NOW()),

-- Service Type 15: Massage Trị Liệu (Therapeutic Massage)
(3, 'therapeutic.massage1@spaluxury.com', '$2a$10$encrypted_password', 'Mai Thị Bảo', '0903456809', 'FEMALE', '1981-01-17', '/assets/staff/therapeutic_massage1.jpg', '124 Healing St, HCM', 1, NOW(), NOW()),
(3, 'therapeutic.massage2@spaluxury.com', '$2a$10$encrypted_password', 'Huỳnh Văn Khang', '0903456810', 'MALE', '1979-06-24', '/assets/staff/therapeutic_massage2.jpg', '235 Therapy Ave, HCM', 1, NOW(), NOW());

-- Now insert staff records for each new therapist
INSERT INTO `staff` (`user_id`, `description`, `availability_status`, `service_type_id`, `created_at`, `updated_at`, `average_rating`) VALUES
-- Service Type 5: Chăm Sóc Móng (Nail Care)
((SELECT user_id FROM users WHERE email = 'nail.specialist1@spaluxury.com'), 'Chuyên gia chăm sóc móng với 8 năm kinh nghiệm. Thành thạo nail art và các kỹ thuật trang trí móng hiện đại.', 'AVAILABLE', 5, NOW(), NOW(), 4.8),
((SELECT user_id FROM users WHERE email = 'nail.specialist2@spaluxury.com'), 'Kỹ thuật viên nail chuyên nghiệp, đặc biệt về gel và acrylic nails.', 'AVAILABLE', 5, NOW(), NOW(), 4.6),

-- Service Type 6: Tẩy Lông & Waxing
((SELECT user_id FROM users WHERE email = 'waxing.expert1@spaluxury.com'), 'Chuyên gia tẩy lông với công nghệ laser và wax không đau.', 'AVAILABLE', 6, NOW(), NOW(), 4.7),
((SELECT user_id FROM users WHERE email = 'waxing.expert2@spaluxury.com'), 'Kỹ thuật viên tẩy lông kinh nghiệm, sử dụng sản phẩm tự nhiên an toàn.', 'AVAILABLE', 6, NOW(), NOW(), 4.5),

-- Service Type 7: Chăm Sóc Lông Mi & Lông Mày
((SELECT user_id FROM users WHERE email = 'eyecare.artist1@spaluxury.com'), 'Nghệ sĩ chuyên về nối mi và phun xăm lông mày 3D.', 'AVAILABLE', 7, NOW(), NOW(), 4.9),
((SELECT user_id FROM users WHERE email = 'eyecare.artist2@spaluxury.com'), 'Chuyên gia định hình lông mày và chăm sóc vùng mắt.', 'AVAILABLE', 7, NOW(), NOW(), 4.6),

-- Service Type 8: Liệu Pháp Thơm (Aromatherapy)
((SELECT user_id FROM users WHERE email = 'aroma.therapist1@spaluxury.com'), 'Chuyên gia trị liệu tinh dầu với chứng chỉ quốc tế về aromatherapy.', 'AVAILABLE', 8, NOW(), NOW(), 4.8),
((SELECT user_id FROM users WHERE email = 'aroma.therapist2@spaluxury.com'), 'Kỹ thuật viên trẻ, am hiểu về các loại tinh dầu thiên nhiên Việt Nam.', 'AVAILABLE', 8, NOW(), NOW(), 4.4),

-- Service Type 9: Liệu Pháp Nước (Hydrotherapy)
((SELECT user_id FROM users WHERE email = 'hydro.therapist1@spaluxury.com'), 'Chuyên gia thủy trị liệu với 15 năm kinh nghiệm về jacuzzi và mineral baths.', 'AVAILABLE', 9, NOW(), NOW(), 4.9),
((SELECT user_id FROM users WHERE email = 'hydro.therapist2@spaluxury.com'), 'Kỹ thuật viên thủy trị liệu, chuyên về các liệu pháp nước khoáng.', 'AVAILABLE', 9, NOW(), NOW(), 4.7),

-- Service Type 10: Y Học Cổ Truyền Việt Nam
((SELECT user_id FROM users WHERE email = 'traditional.healer1@spaluxury.com'), 'Thầy thuốc y học cổ truyền với 25 năm kinh nghiệm châm cứu và bấm huyệt.', 'AVAILABLE', 10, NOW(), NOW(), 5.0),
((SELECT user_id FROM users WHERE email = 'traditional.healer2@spaluxury.com'), 'Cô thuốc chuyên về massage bấm huyệt và thảo dược dân gian.', 'AVAILABLE', 10, NOW(), NOW(), 4.8),

-- Service Type 11: Giảm Cân & Định Hình Cơ Thể
((SELECT user_id FROM users WHERE email = 'slimming.coach1@spaluxury.com'), 'Huấn luyện viên thể hình kết hợp với chuyên gia massage giảm cân.', 'AVAILABLE', 11, NOW(), NOW(), 4.6),
((SELECT user_id FROM users WHERE email = 'slimming.coach2@spaluxury.com'), 'Chuyên gia định hình cơ thể với các công nghệ hiện đại như RF và Cavitation.', 'AVAILABLE', 11, NOW(), NOW(), 4.7),

-- Service Type 12: Dịch Vụ Cặp Đôi
((SELECT user_id FROM users WHERE email = 'couples.specialist1@spaluxury.com'), 'Chuyên gia tư vấn và thực hiện các gói spa dành cho cặp đôi.', 'AVAILABLE', 12, NOW(), NOW(), 4.8),
((SELECT user_id FROM users WHERE email = 'couples.specialist2@spaluxury.com'), 'Kỹ thuật viên có kinh nghiệm về massage cặp đôi và liệu pháp thư giãn.', 'AVAILABLE', 12, NOW(), NOW(), 4.5),

-- Service Type 13: Chống Lão Hóa
((SELECT user_id FROM users WHERE email = 'antiaging.expert1@spaluxury.com'), 'Chuyên gia chống lão hóa với công nghệ Radio Frequency và Micro-current.', 'AVAILABLE', 13, NOW(), NOW(), 4.9),
((SELECT user_id FROM users WHERE email = 'antiaging.expert2@spaluxury.com'), 'Bác sĩ thẩm mỹ chuyên về các liệu pháp trẻ hóa da không xâm lấn.', 'AVAILABLE', 13, NOW(), NOW(), 5.0),

-- Service Type 14: Thải Độc & Thanh Lọc
((SELECT user_id FROM users WHERE email = 'detox.specialist1@spaluxury.com'), 'Chuyên gia detox với các phương pháp tự nhiên và thảo dược.', 'AVAILABLE', 14, NOW(), NOW(), 4.7),
((SELECT user_id FROM users WHERE email = 'detox.specialist2@spaluxury.com'), 'Kỹ thuật viên chuyên về colon hydrotherapy và lymphatic drainage.', 'AVAILABLE', 14, NOW(), NOW(), 4.6),

-- Service Type 15: Massage Trị Liệu
((SELECT user_id FROM users WHERE email = 'therapeutic.massage1@spaluxury.com'), 'Chuyên gia massage trị liệu với bằng cấp y khoa và 12 năm kinh nghiệm.', 'AVAILABLE', 15, NOW(), NOW(), 5.0),
((SELECT user_id FROM users WHERE email = 'therapeutic.massage2@spaluxury.com'), 'Kỹ thuật viên massage trị liệu chuyên về phục hồi chức năng và giảm đau.', 'AVAILABLE', 15, NOW(), NOW(), 4.8);

-- Verify the insertion by selecting therapists by service type
SELECT 
    st.service_type_id,
    st.name as service_type_name,
    s.user_id,
    u.full_name as therapist_name,
    s.description,
    s.availability_status,
    s.average_rating
FROM staff s 
JOIN users u ON s.user_id = u.user_id 
JOIN service_types st ON s.service_type_id = st.service_type_id 
WHERE st.service_type_id >= 5 
ORDER BY st.service_type_id, u.full_name;

-- Summary query to show therapist count per service type
SELECT 
    st.service_type_id,
    st.name as service_type_name,
    COUNT(s.user_id) as therapist_count
FROM service_types st 
LEFT JOIN staff s ON st.service_type_id = s.service_type_id 
GROUP BY st.service_type_id, st.name 
ORDER BY st.service_type_id; 