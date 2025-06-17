-- ==========================================
-- SPA SERVICES DATA INSERT SCRIPT
-- ==========================================
-- This script adds comprehensive service types and services for a Vietnamese spa

-- ==========================================
-- INSERT SERVICE TYPES (10+ categories)
-- ==========================================

INSERT INTO `service_types` (`name`, `description`, `image_url`, `is_active`) VALUES
-- Additional service types (IDs 5-15)
('Chăm Sóc Móng', 'Dịch vụ làm đẹp móng tay và móng chân chuyên nghiệp', 'https://placehold.co/300x200/FFB6C1/333333?text=NailCare', 1),
('Tẩy Lông & Waxing', 'Các phương pháp tẩy lông an toàn và hiệu quả', 'https://placehold.co/300x200/DDA0DD/333333?text=Waxing', 1),
('Chăm Sóc Lông Mi & Lông Mày', 'Dịch vụ làm đẹp mắt và định hình lông mày', 'https://placehold.co/300x200/F0E68C/333333?text=EyeCare', 1),
('Liệu Pháp Thơm', 'Trị liệu bằng tinh dầu thiên nhiên và hương thơm', 'https://placehold.co/300x200/E6E6FA/333333?text=Aromatherapy', 1),
('Liệu Pháp Nước', 'Các liệu pháp sử dụng nước khoáng và thủy trị liệu', 'https://placehold.co/300x200/AFEEEE/333333?text=Hydrotherapy', 1),
('Y Học Cổ Truyền Việt Nam', 'Các phương pháp chữa bệnh truyền thống của Việt Nam', 'https://placehold.co/300x200/90EE90/333333?text=TraditionalMedicine', 1),
('Giảm Cân & Định Hình Cơ Thể', 'Các liệu pháp hỗ trợ giảm cân và tạo vóc dáng', 'https://placehold.co/300x200/FFA07A/333333?text=Slimming', 1),
('Dịch Vụ Cặp Đôi', 'Các gói dịch vụ đặc biệt dành cho cặp đôi', 'https://placehold.co/300x200/FFDAB9/333333?text=Couples', 1),
('Chống Lão Hóa', 'Các liệu pháp chống lão hóa và trẻ hóa làn da', 'https://placehold.co/300x200/F5DEB3/333333?text=AntiAging', 1),
('Thải Độc & Thanh Lọc', 'Các liệu pháp thanh lọc cơ thể và thải độc tự nhiên', 'https://placehold.co/300x200/98FB98/333333?text=Detox', 1),
('Massage Trị Liệu', 'Các phương pháp massage chuyên sâu cho điều trị', 'https://placehold.co/300x200/B0E0E6/333333?text=TherapeuticMassage', 1);

-- ==========================================
-- INSERT SERVICES FOR EACH SERVICE TYPE
-- ==========================================

-- Services for existing Service Type 1: Massage Thư Giãn (ID: 1) - Add 4 more to make 10 total
INSERT INTO `services` (`service_type_id`, `name`, `description`, `price`, `duration_minutes`, `buffer_time_after_minutes`, `image_url`, `is_active`, `bookable_online`, `requires_consultation`) VALUES
(1, 'Massage Thái Cổ Truyền', 'Massage theo phong cách Thái Lan với các động tác duỗi giãn cơ thể', 650000.00, 90, 15, 'https://placehold.co/300x200/DEB887/333333?text=ThaiMassage', 1, 1, 0),
(1, 'Massage Shiatsu Nhật Bản', 'Kỹ thuật massage bấm huyệt theo phong cách Nhật Bản', 750000.00, 75, 15, 'https://placehold.co/300x200/F4A460/333333?text=Shiatsu', 1, 1, 0),
(1, 'Massage Foot Reflexology', 'Massage phản xạ bàn chân kích thích các huyệt đạo', 400000.00, 45, 10, 'https://placehold.co/300x200/CD853F/333333?text=FootReflexology', 1, 1, 0),
(1, 'Massage Toàn Thân Dầu Dừa', 'Massage thư giãn toàn thân với dầu dừa nguyên chất', 550000.00, 60, 15, 'https://placehold.co/300x200/DDA0DD/333333?text=CoconutMassage', 1, 1, 0);

-- Services for existing Service Type 2: Chăm Sóc Da Mặt (ID: 2) - Add 6 more to make 10 total  
INSERT INTO `services` (`service_type_id`, `name`, `description`, `price`, `duration_minutes`, `buffer_time_after_minutes`, `image_url`, `is_active`, `bookable_online`, `requires_consultation`) VALUES
(2, 'Điều Trị Nám & Tàn Nhang', 'Liệu trình chuyên sâu điều trị nám melasma và tàn nhang', 800000.00, 90, 20, 'https://placehold.co/300x200/FFEFD5/333333?text=MelesmaTreatment', 1, 1, 1),
(2, 'Facial Vitamin C Brightening', 'Chăm sóc da với vitamin C giúp da sáng mịn', 550000.00, 75, 15, 'https://placehold.co/300x200/FFF8DC/333333?text=VitaminCFacial', 1, 1, 0),
(2, 'Microdermabrasion', 'Lột da mặt bằng tinh thể kim cương loại bỏ lớp da chết', 700000.00, 60, 20, 'https://placehold.co/300x200/F0FFFF/333333?text=Microdermabrasion', 1, 1, 1),
(2, 'Hydrafacial Deep Cleansing', 'Làm sạch sâu và cấp ẩm chuyên sâu cho da mặt', 900000.00, 90, 15, 'https://placehold.co/300x200/E0FFFF/333333?text=Hydrafacial', 1, 1, 0),
(2, 'Collagen Boost Facial', 'Liệu trình kích thích collagen tự nhiên chống lão hóa', 850000.00, 80, 15, 'https://placehold.co/300x200/F5FFFA/333333?text=CollagenFacial', 1, 1, 0),
(2, 'Oxygen Infusion Treatment', 'Truyền oxy tinh khiết giúp da tươi sáng và khỏe mạnh', 750000.00, 70, 15, 'https://placehold.co/300x200/F0F8FF/333333?text=OxygenFacial', 1, 1, 0);

-- Services for existing Service Type 3: Chăm Sóc Toàn Thân (ID: 3) - Add 6 more to make 10 total
INSERT INTO `services` (`service_type_id`, `name`, `description`, `price`, `duration_minutes`, `buffer_time_after_minutes`, `image_url`, `is_active`, `bookable_online`, `requires_consultation`) VALUES
(3, 'Body Wrap Bùn Khoáng', 'Đắp bùn khoáng toàn thân giúp thải độc và làm mềm da', 600000.00, 75, 20, 'https://placehold.co/300x200/D2B48C/333333?text=MudWrap', 1, 1, 0),
(3, 'Tắm Trắng Toàn Thân', 'Liệu trình tắm trắng an toàn với thành phần tự nhiên', 800000.00, 90, 25, 'https://placehold.co/300x200/FFF5EE/333333?text=BodyWhitening', 1, 1, 0),
(3, 'Massage Giảm Cellulite', 'Massage chuyên sâu giúp giảm cellulite và săn chắc da', 700000.00, 75, 15, 'https://placehold.co/300x200/FFE4E1/333333?text=CelluliteMassage', 1, 1, 0),
(3, 'Body Polish & Moisturizing', 'Tẩy tế bào chết và dưỡng ẩm toàn thân chuyên sâu', 500000.00, 60, 15, 'https://placehold.co/300x200/F0FFF0/333333?text=BodyPolish', 1, 1, 0),
(3, 'Chocolate Body Treatment', 'Liệu pháp chocolate tươi giúp nuôi dưỡng và thư giãn', 650000.00, 80, 20, 'https://placehold.co/300x200/D2691E/333333?text=ChocolateTreatment', 1, 1, 0),
(3, 'Seaweed Body Wrap', 'Đắp rong biển giàu khoáng chất cho da toàn thân', 580000.00, 70, 20, 'https://placehold.co/300x200/2E8B57/333333?text=SeaweedWrap', 1, 1, 0);

-- Services for existing Service Type 4: Dịch Vụ Gội Đầu Dưỡng Sinh (ID: 4) - Add 4 more to make 10 total
INSERT INTO `services` (`service_type_id`, `name`, `description`, `price`, `duration_minutes`, `buffer_time_after_minutes`, `image_url`, `is_active`, `bookable_online`, `requires_consultation`) VALUES
(4, 'Massage Da Đầu Tinh Dầu', 'Massage da đầu chuyên sâu với tinh dầu thảo mộc', 350000.00, 45, 10, 'https://placehold.co/300x200/DDA0DD/333333?text=ScalpMassage', 1, 1, 0),
(4, 'Điều Trị Gàu & Ngứa Da Đầu', 'Liệu trình chuyên trị gàu và các vấn đề về da đầu', 450000.00, 60, 15, 'https://placehold.co/300x200/F0E68C/333333?text=DandruffTreatment', 1, 1, 1),
(4, 'Hair Mask Keratin Phục Hồi', 'Ủ tóc keratin giúp phục hồi tóc hư tổn', 400000.00, 75, 15, 'https://placehold.co/300x200/FFE4B5/333333?text=KeratinMask', 1, 1, 0),
(4, 'Gội Đầu Bằng Lá Bồ Kết', 'Gội đầu theo phương pháp dân gian với lá bồ kết', 250000.00, 40, 10, 'https://placehold.co/300x200/9ACD32/333333?text=HerbalWash', 1, 1, 0);

-- Services for Service Type 5: Chăm Sóc Móng (10 services)
INSERT INTO `services` (`service_type_id`, `name`, `description`, `price`, `duration_minutes`, `buffer_time_after_minutes`, `image_url`, `is_active`, `bookable_online`, `requires_consultation`) VALUES
(5, 'Manicure Cơ Bản', 'Làm móng tay cơ bản với cắt, giũa và sơn móng', 200000.00, 45, 10, 'https://placehold.co/300x200/FFB6C1/333333?text=BasicManicure', 1, 1, 0),
(5, 'Pedicure Deluxe', 'Chăm sóc móng chân cao cấp với ngâm chân và massage', 350000.00, 75, 15, 'https://placehold.co/300x200/DDA0DD/333333?text=DeluxePedicure', 1, 1, 0),
(5, 'Gel Polish Manicure', 'Sơn gel bền màu lên đến 3 tuần', 300000.00, 60, 10, 'https://placehold.co/300x200/FF69B4/333333?text=GelManicure', 1, 1, 0),
(5, 'Nail Art Design', 'Vẽ móng nghệ thuật theo yêu cầu', 400000.00, 90, 15, 'https://placehold.co/300x200/FF1493/333333?text=NailArt', 1, 1, 0),
(5, 'French Manicure', 'Kiểu móng Pháp cổ điển thanh lịch', 250000.00, 50, 10, 'https://placehold.co/300x200/FFF0F5/333333?text=FrenchManicure', 1, 1, 0),
(5, 'Spa Pedicure Thảo Dược', 'Chăm sóc chân với thảo dược thiên nhiên', 450000.00, 90, 20, 'https://placehold.co/300x200/E6E6FA/333333?text=HerbalPedicure', 1, 1, 0),
(5, 'Paraffin Treatment', 'Ngâm tay chân trong sáp ấm để dưỡng ẩm', 300000.00, 45, 10, 'https://placehold.co/300x200/FFEFD5/333333?text=ParaffinTreatment', 1, 1, 0),
(5, 'Callus Removal', 'Loại bỏ vết chai cứng ở bàn chân', 200000.00, 30, 10, 'https://placehold.co/300x200/F5DEB3/333333?text=CallusRemoval', 1, 1, 0),
(5, 'Acrylic Nail Extension', 'Nối móng acrylic theo độ dài mong muốn', 500000.00, 120, 20, 'https://placehold.co/300x200/DA70D6/333333?text=AcrylicNails', 1, 1, 0),
(5, 'Cuticle Care Treatment', 'Chăm sóc da quanh móng chuyên sâu', 150000.00, 30, 5, 'https://placehold.co/300x200/FAFAD2/333333?text=CuticleCare', 1, 1, 0);

-- Services for Service Type 6: Tẩy Lông & Waxing (10 services)
INSERT INTO `services` (`service_type_id`, `name`, `description`, `price`, `duration_minutes`, `buffer_time_after_minutes`, `image_url`, `is_active`, `bookable_online`, `requires_consultation`) VALUES
(6, 'Waxing Chân Toàn Phần', 'Tẩy lông toàn bộ đôi chân bằng sáp nóng', 400000.00, 60, 15, 'https://placehold.co/300x200/DDA0DD/333333?text=FullLegWax', 1, 1, 0),
(6, 'Waxing Tay Toàn Phần', 'Tẩy lông toàn bộ đôi tay bằng sáp nóng', 300000.00, 45, 10, 'https://placehold.co/300x200/F0E68C/333333?text=FullArmWax', 1, 1, 0),
(6, 'Waxing Nách', 'Tẩy lông vùng nách sạch sẽ và an toàn', 150000.00, 20, 10, 'https://placehold.co/300x200/FFB6C1/333333?text=UnderarmWax', 1, 1, 0),
(6, 'Waxing Mặt', 'Tẩy lông mặt nhẹ nhàng cho da nhạy cảm', 200000.00, 30, 10, 'https://placehold.co/300x200/FFEFD5/333333?text=FacialWax', 1, 1, 0),
(6, 'Brazilian Wax', 'Tẩy lông vùng bikini theo kiểu Brazil', 500000.00, 45, 20, 'https://placehold.co/300x200/FF69B4/333333?text=BrazilianWax', 1, 1, 1),
(6, 'Bikini Line Wax', 'Tẩy lông đường bikini cơ bản', 300000.00, 30, 15, 'https://placehold.co/300x200/DA70D6/333333?text=BikiniWax', 1, 1, 0),
(6, 'Tẩy Lông Laser IPL', 'Tẩy lông vĩnh viễn bằng công nghệ IPL', 800000.00, 60, 20, 'https://placehold.co/300x200/E6E6FA/333333?text=IPLHairRemoval', 1, 1, 1),
(6, 'Waxing Bụng', 'Tẩy lông vùng bụng sạch sẽ', 250000.00, 25, 10, 'https://placehold.co/300x200/F5DEB3/333333?text=AbdomenWax', 1, 1, 0),
(6, 'Waxing Lưng Nam', 'Tẩy lông lưng dành cho nam giới', 350000.00, 40, 15, 'https://placehold.co/300x200/D2B48C/333333?text=BackWaxMen', 1, 1, 0),
(6, 'Sugar Wax Tự Nhiên', 'Tẩy lông bằng sáp đường tự nhiên, ít đau', 320000.00, 45, 10, 'https://placehold.co/300x200/F0FFF0/333333?text=SugarWax', 1, 1, 0);

-- Services for Service Type 7: Chăm Sóc Lông Mi & Lông Mày (10 services)
INSERT INTO `services` (`service_type_id`, `name`, `description`, `price`, `duration_minutes`, `buffer_time_after_minutes`, `image_url`, `is_active`, `bookable_online`, `requires_consultation`) VALUES
(7, 'Nối Mi Classic', 'Nối mi từng sợi theo phong cách tự nhiên', 500000.00, 90, 15, 'https://placehold.co/300x200/F0E68C/333333?text=ClassicLashes', 1, 1, 0),
(7, 'Nối Mi Volume', 'Nối mi nhiều tầng tạo độ dày đặc', 700000.00, 120, 20, 'https://placehold.co/300x200/FFB6C1/333333?text=VolumeLashes', 1, 1, 0),
(7, 'Uốn Mi Tự Nhiên', 'Uốn mi tạo độ cong tự nhiên không cần mascara', 300000.00, 45, 10, 'https://placehold.co/300x200/FFEFD5/333333?text=LashLift', 1, 1, 0),
(7, 'Nhuộm Mi & Lông Mày', 'Nhuộm màu tự nhiên cho mi và lông mày', 200000.00, 30, 10, 'https://placehold.co/300x200/DDA0DD/333333?text=TintingService', 1, 1, 0),
(7, 'Tạo Dáng Lông Mày Threading', 'Tạo dáng lông mày bằng chỉ theo kiểu Ấn Độ', 150000.00, 25, 5, 'https://placehold.co/300x200/D2B48C/333333?text=BrowThreading', 1, 1, 0),
(7, 'Phun Xăm Lông Mày 3D', 'Phun xăm lông mày tự nhiên công nghệ 3D', 2000000.00, 150, 30, 'https://placehold.co/300x200/F5DEB3/333333?text=3DBrowTattoo', 1, 1, 1),
(7, 'Lamination Lông Mày', 'Uốn và cố định lông mày tạo dáng hoàn hảo', 350000.00, 45, 10, 'https://placehold.co/300x200/E6E6FA/333333?text=BrowLamination', 1, 1, 0),
(7, 'Làm Sạch Lông Mày', 'Nhổ sạch lông mày thừa tạo dáng gọn gàng', 100000.00, 20, 5, 'https://placehold.co/300x200/F0FFF0/333333?text=BrowCleaning', 1, 1, 0),
(7, 'Cấy Mi Vĩnh Viễn', 'Cấy mi tự thân tạo mi dài vĩnh viễn', 15000000.00, 240, 60, 'https://placehold.co/300x200/FF69B4/333333?text=LashImplant', 1, 1, 1),
(7, 'Chăm Sóc Mi Sau Nối', 'Dưỡng và chăm sóc mi sau khi nối', 200000.00, 30, 10, 'https://placehold.co/300x200/FAFAD2/333333?text=LashCare', 1, 1, 0);

-- Services for Service Type 8: Liệu Pháp Thơm (10 services)
INSERT INTO `services` (`service_type_id`, `name`, `description`, `price`, `duration_minutes`, `buffer_time_after_minutes`, `image_url`, `is_active`, `bookable_online`, `requires_consultation`) VALUES
(8, 'Aromatherapy Massage Lavender', 'Massage thư giãn với tinh dầu oải hương', 600000.00, 75, 15, 'https://placehold.co/300x200/E6E6FA/333333?text=LavenderAroma', 1, 1, 0),
(8, 'Trị Liệu Tinh Dầu Bạch Đàn', 'Liệu pháp tinh dầu bạch đàn cho hệ hô hấp', 450000.00, 60, 15, 'https://placehold.co/300x200/98FB98/333333?text=EucalyptusTherapy', 1, 1, 0),
(8, 'Xông Hơi Tinh Dầu', 'Xông hơi với các loại tinh dầu thiên nhiên', 350000.00, 45, 15, 'https://placehold.co/300x200/AFEEEE/333333?text=AromaSteam', 1, 1, 0),
(8, 'Massage Tinh Dầu Sả Chanh', 'Massage với tinh dầu sả chanh thư giãn', 500000.00, 60, 15, 'https://placehold.co/300x200/F0FFF0/333333?text=LemongrassAroma', 1, 1, 0),
(8, 'Điều Trị Stress Aromatherapy', 'Liệu pháp tinh dầu chuyên trị stress', 550000.00, 75, 20, 'https://placehold.co/300x200/FFE4E1/333333?text=StressRelief', 1, 1, 0),
(8, 'Thơm Phòng Trị Liệu', 'Trị liệu tâm lý với hương thơm tự nhiên', 400000.00, 45, 10, 'https://placehold.co/300x200/F5FFFA/333333?text=RoomAromatherapy', 1, 1, 0),
(8, 'Ngâm Chân Tinh Dầu', 'Ngâm chân thư giãn với tinh dầu thảo mộc', 300000.00, 40, 10, 'https://placehold.co/300x200/DDA0DD/333333?text=FootAromaSoak', 1, 1, 0),
(8, 'Hít Thở Liệu Pháp', 'Liệu pháp hít thở với tinh dầu', 250000.00, 30, 10, 'https://placehold.co/300x200/F0E68C/333333?text=BreathingTherapy', 1, 1, 0),
(8, 'Massage Đầu Tinh Dầu Bưởi', 'Massage da đầu với tinh dầu bưởi kích thích mọc tóc', 350000.00, 45, 10, 'https://placehold.co/300x200/FFA07A/333333?text=GrapefruitScalp', 1, 1, 0),
(8, 'Aromatherapy Facial', 'Chăm sóc da mặt kết hợp tinh dầu', 650000.00, 80, 15, 'https://placehold.co/300x200/FFEFD5/333333?text=AromaFacial', 1, 1, 0); 