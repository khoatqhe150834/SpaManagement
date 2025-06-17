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



-- ==========================================
-- REMAINING SPA SERVICES (Part 2)
-- ==========================================

-- Services for Service Type 9: Liệu Pháp Nước (10 services)
INSERT INTO `services` (`service_type_id`, `name`, `description`, `price`, `duration_minutes`, `buffer_time_after_minutes`, `image_url`, `is_active`, `bookable_online`, `requires_consultation`) VALUES
(9, 'Jacuzzi Massage Nước Ấm', 'Massage trong bồn jacuzzi với nước khoáng ấm', 800000.00, 60, 20, 'https://placehold.co/300x200/AFEEEE/333333?text=JacuzziMassage', 1, 1, 0),
(9, 'Tắm Khoáng Nóng Onsen', 'Tắm khoáng nóng theo phong cách Nhật Bản', 600000.00, 45, 15, 'https://placehold.co/300x200/B0E0E6/333333?text=OnsenBath', 1, 1, 0),
(9, 'Vichy Shower Treatment', 'Tắm massage với vòi sen Vichy', 700000.00, 50, 15, 'https://placehold.co/300x200/E0FFFF/333333?text=VichyShower', 1, 1, 0),
(9, 'Tắm Sữa Dê Cleopatra', 'Tắm sữa dê giàu dưỡng chất như nữ hoàng Ai Cập', 900000.00, 75, 20, 'https://placehold.co/300x200/FFF8DC/333333?text=MilkBath', 1, 1, 0),
(9, 'Flotation Therapy', 'Liệu pháp nổi trên mặt nước muối Epsom', 1200000.00, 60, 30, 'https://placehold.co/300x200/F0F8FF/333333?text=FloatTherapy', 1, 1, 1),
(9, 'Tắm Hoa Hồng', 'Tắm thư giãn với cánh hoa hồng tươi', 650000.00, 60, 15, 'https://placehold.co/300x200/FFB6C1/333333?text=RosePetalBath', 1, 1, 0),
(9, 'Aqua Fitness', 'Tập thể dục trong nước để thư giãn cơ bắp', 400000.00, 45, 15, 'https://placehold.co/300x200/40E0D0/333333?text=AquaFitness', 1, 1, 0),
(9, 'Thalassotherapy', 'Liệu pháp nước biển và tảo biển', 850000.00, 90, 20, 'https://placehold.co/300x200/20B2AA/333333?text=Thalassotherapy', 1, 1, 0),
(9, 'Kneipp Water Therapy', 'Liệu pháp nước Kneipp chữa bệnh', 550000.00, 60, 15, 'https://placehold.co/300x200/87CEEB/333333?text=KneippTherapy', 1, 1, 1),
(9, 'Contrast Hydrotherapy', 'Liệu pháp tương phản nóng lạnh', 500000.00, 45, 15, 'https://placehold.co/300x200/F0FFFF/333333?text=ContrastTherapy', 1, 1, 0);

-- Services for Service Type 10: Y Học Cổ Truyền Việt Nam (10 services)
INSERT INTO `services` (`service_type_id`, `name`, `description`, `price`, `duration_minutes`, `buffer_time_after_minutes`, `image_url`, `is_active`, `bookable_online`, `requires_consultation`) VALUES
(10, 'Bấm Huyệt Chữa Bệnh', 'Bấm huyệt theo y học cổ truyền Việt Nam', 400000.00, 60, 15, 'https://placehold.co/300x200/90EE90/333333?text=AcupressureVN', 1, 1, 1),
(10, 'Châm Cứu Điều Trị', 'Châm cứu chữa bệnh bằng kim', 500000.00, 75, 20, 'https://placehold.co/300x200/32CD32/333333?text=Acupuncture', 1, 1, 1),
(10, 'Giác Hơi Thảo Dược', 'Giác hơi kết hợp với thảo dược', 350000.00, 45, 15, 'https://placehold.co/300x200/228B22/333333?text=Cupping', 1, 1, 0),
(10, 'Xông Hơi Lá Thuốc Nam', 'Xông hơi với lá thuốc Nam truyền thống', 300000.00, 40, 15, 'https://placehold.co/300x200/9ACD32/333333?text=HerbalSteam', 1, 1, 0),
(10, 'Massage Tuina Trung Quốc', 'Massage Tuina theo phong cách Trung Quốc', 450000.00, 75, 15, 'https://placehold.co/300x200/6B8E23/333333?text=TuinaMassage', 1, 1, 0),
(10, 'Trị Liệu Đá Nóng Himalaya', 'Massage với đá nóng Himalaya', 650000.00, 90, 20, 'https://placehold.co/300x200/8FBC8F/333333?text=HimalayaStone', 1, 1, 0),
(10, 'Xoa Bóp Gù Truyền Thống', 'Xoa bóp gù theo phương pháp dân gian', 300000.00, 45, 10, 'https://placehold.co/300x200/ADFF2F/333333?text=TraditionalMassage', 1, 1, 0),
(10, 'Ngâm Chân Thuốc Bắc', 'Ngâm chân với thuốc Bắc quý hiếm', 250000.00, 30, 10, 'https://placehold.co/300x200/98FB98/333333?text=HerbalFootSoak', 1, 1, 0),
(10, 'Cạo Gió Chữa Bệnh', 'Cạo gió theo phương pháp y học dân gian', 200000.00, 30, 10, 'https://placehold.co/300x200/F0E68C/333333?text=CaoGio', 1, 1, 0),
(10, 'Đắp Lá Chuối Điều Trị', 'Đắp lá chuối non chữa viêm khớp', 350000.00, 60, 15, 'https://placehold.co/300x200/7CFC00/333333?text=BananaLeafTreatment', 1, 1, 1);

-- Services for Service Type 11: Giảm Cân & Định Hình Cơ Thể (10 services)
INSERT INTO `services` (`service_type_id`, `name`, `description`, `price`, `duration_minutes`, `buffer_time_after_minutes`, `image_url`, `is_active`, `bookable_online`, `requires_consultation`) VALUES
(11, 'Máy Giảm Béo RF', 'Giảm béo bằng sóng radio tần số cao', 1500000.00, 60, 20, 'https://placehold.co/300x200/FFA07A/333333?text=RFSlimming', 1, 1, 1),
(11, 'Massage Tan Mỡ Bụng', 'Massage chuyên sâu giúp tan mỡ bụng', 600000.00, 75, 15, 'https://placehold.co/300x200/FF7F50/333333?text=BellyFatMassage', 1, 1, 0),
(11, 'Liposuction Không Phẫu Thuật', 'Hút mỡ không xâm lấn bằng công nghệ cao', 3000000.00, 120, 30, 'https://placehold.co/300x200/CD5C5C/333333?text=NonSurgicalLipo', 1, 1, 1),
(11, 'Body Contouring', 'Định hình cơ thể với máy móc hiện đại', 2000000.00, 90, 20, 'https://placehold.co/300x200/F08080/333333?text=BodyContouring', 1, 1, 1),
(11, 'Cryolipolysis Đông Lạnh Mỏ', 'Giảm mỡ bằng công nghệ đông lạnh', 2500000.00, 60, 30, 'https://placehold.co/300x200/4682B4/333333?text=CoolSculpting', 1, 1, 1),
(11, 'EMS Điện Kích Thích Cơ', 'Kích thích cơ bắp bằng xung điện', 800000.00, 45, 15, 'https://placehold.co/300x200/FFB347/333333?text=EMSTraining', 1, 1, 0),
(11, 'Bandage Quấn Thảo Dược', 'Quấn băng thảo dược giảm size', 700000.00, 90, 20, 'https://placehold.co/300x200/DEB887/333333?text=HerbalWrap', 1, 1, 0),
(11, 'Infrared Sauna Giảm Cân', 'Xông hơi hồng ngoại giúp đốt cháy mỡ', 500000.00, 45, 15, 'https://placehold.co/300x200/FF6347/333333?text=InfraredSauna', 1, 1, 0),
(11, 'Lymphatic Drainage', 'Massage dẫn lưu bạch huyết giảm phù nề', 650000.00, 60, 15, 'https://placehold.co/300x200/20B2AA/333333?text=LymphaticMassage', 1, 1, 0),
(11, 'Pressotherapy Ép Khí', 'Máy ép khí giúp lưu thông máu', 750000.00, 45, 15, 'https://placehold.co/300x200/87CEEB/333333?text=Pressotherapy', 1, 1, 0);

-- Services for Service Type 12: Dịch Vụ Cặp Đôi (10 services)
INSERT INTO `services` (`service_type_id`, `name`, `description`, `price`, `duration_minutes`, `buffer_time_after_minutes`, `image_url`, `is_active`, `bookable_online`, `requires_consultation`) VALUES
(12, 'Couples Massage Suite', 'Massage đôi trong phòng riêng romantic', 1200000.00, 90, 30, 'https://placehold.co/300x200/FFDAB9/333333?text=CouplesMassage', 1, 1, 0),
(12, 'Private Jacuzzi for Two', 'Jacuzzi riêng tư dành cho hai người', 1500000.00, 60, 30, 'https://placehold.co/300x200/FFE4E1/333333?text=PrivateJacuzzi', 1, 1, 0),
(12, 'Wine & Dine Spa Package', 'Gói spa kết hợp với rượu vang và ăn tối', 2500000.00, 180, 30, 'https://placehold.co/300x200/F5DEB3/333333?text=WineDineSpa', 1, 1, 0),
(12, 'Couples Facial Treatment', 'Chăm sóc da mặt cho cặp đôi', 1000000.00, 75, 20, 'https://placehold.co/300x200/FFF8DC/333333?text=CouplesFacial', 1, 1, 0),
(12, 'Romantic Rose Package', 'Gói dịch vụ lãng mạn với hoa hồng', 1800000.00, 120, 30, 'https://placehold.co/300x200/FFB6C1/333333?text=RomanticPackage', 1, 1, 0),
(12, 'Sunset Beach Massage', 'Massage trên bãi biển lúc hoàng hôn', 2000000.00, 90, 30, 'https://placehold.co/300x200/FF7F50/333333?text=BeachMassage', 1, 1, 0),
(12, 'Couples Yoga Session', 'Lớp yoga dành cho cặp đôi', 800000.00, 60, 15, 'https://placehold.co/300x200/98FB98/333333?text=CouplesYoga', 1, 1, 0),
(12, 'Anniversary Celebration', 'Gói kỷ niệm ngày cưới đặc biệt', 3000000.00, 240, 60, 'https://placehold.co/300x200/DDA0DD/333333?text=Anniversary', 1, 1, 0),
(12, 'Honeymoon Bliss Package', 'Gói tuần trăng mật hoàn hảo', 2800000.00, 180, 45, 'https://placehold.co/300x200/F0E68C/333333?text=Honeymoon', 1, 1, 0),
(12, 'Couples Meditation', 'Thiền đôi trong không gian yên tĩnh', 600000.00, 45, 15, 'https://placehold.co/300x200/E6E6FA/333333?text=CouplesMeditation', 1, 1, 0);

-- Services for Service Type 13: Chống Lão Hóa (10 services)  
INSERT INTO `services` (`service_type_id`, `name`, `description`, `price`, `duration_minutes`, `buffer_time_after_minutes`, `image_url`, `is_active`, `bookable_online`, `requires_consultation`) VALUES
(13, 'Anti-Aging Facial Premium', 'Chăm sóc da chống lão hóa cao cấp', 1200000.00, 90, 20, 'https://placehold.co/300x200/F5DEB3/333333?text=AntiAgingFacial', 1, 1, 0),
(13, 'Botox Treatment', 'Tiêm botox giảm nếp nhăn', 5000000.00, 30, 30, 'https://placehold.co/300x200/FFE4E1/333333?text=BotoxTreatment', 1, 1, 1),
(13, 'Collagen Infusion', 'Truyền collagen tươi vào da', 2000000.00, 75, 20, 'https://placehold.co/300x200/FFF0F5/333333?text=CollagenInfusion', 1, 1, 1),
(13, 'LED Light Therapy', 'Liệu pháp ánh sáng LED chống lão hóa', 800000.00, 45, 15, 'https://placehold.co/300x200/E0FFFF/333333?text=LEDTherapy', 1, 1, 0),
(13, 'Peptide Facial Mask', 'Mặt nạ peptide chống nhăn', 900000.00, 60, 15, 'https://placehold.co/300x200/F0F8FF/333333?text=PeptideMask', 1, 1, 0),
(13, 'Stem Cell Treatment', 'Liệu pháp tế bào gốc trẻ hóa', 8000000.00, 120, 30, 'https://placehold.co/300x200/F5FFFA/333333?text=StemCellTreatment', 1, 1, 1),
(13, 'Retinol Peel', 'Lột da bằng retinol chống lão hóa', 1500000.00, 60, 20, 'https://placehold.co/300x200/FFEFD5/333333?text=RetinolPeel', 1, 1, 1),
(13, 'Ultrasound Lifting', 'Nâng cơ mặt bằng sóng siêu âm', 3000000.00, 90, 30, 'https://placehold.co/300x200/F0FFF0/333333?text=UltrasoundLifting', 1, 1, 1),
(13, 'Vampire Facial', 'Chăm sóc da bằng huyết thanh tự thân', 6000000.00, 90, 30, 'https://placehold.co/300x200/DC143C/333333?text=VampireFacial', 1, 1, 1),
(13, 'Gold Facial Treatment', 'Liệu pháp vàng 24k chống lão hóa', 2500000.00, 75, 20, 'https://placehold.co/300x200/FFD700/333333?text=GoldFacial', 1, 1, 0);

-- Services for Service Type 14: Thải Độc & Thanh Lọc (10 services)
INSERT INTO `services` (`service_type_id`, `name`, `description`, `price`, `duration_minutes`, `buffer_time_after_minutes`, `image_url`, `is_active`, `bookable_online`, `requires_consultation`) VALUES
(14, 'Full Body Detox Program', 'Chương trình thải độc toàn diện', 1800000.00, 120, 30, 'https://placehold.co/300x200/98FB98/333333?text=FullDetox', 1, 1, 1),
(14, 'Colon Hydrotherapy', 'Thủy trị liệu ruột già', 1200000.00, 60, 30, 'https://placehold.co/300x200/40E0D0/333333?text=ColonHydrotherapy', 1, 1, 1),
(14, 'Lymphatic Detox Massage', 'Massage thải độc hệ bạch huyết', 800000.00, 75, 15, 'https://placehold.co/300x200/20B2AA/333333?text=LymphaticDetox', 1, 1, 0),
(14, 'Infrared Sauna Detox', 'Xông hơi hồng ngoại thải độc', 600000.00, 45, 15, 'https://placehold.co/300x200/FF6347/333333?text=InfraredDetox', 1, 1, 0),
(14, 'Green Tea Detox Wrap', 'Đắp trà xanh thải độc toàn thân', 700000.00, 90, 20, 'https://placehold.co/300x200/9ACD32/333333?text=GreenTeaWrap', 1, 1, 0),
(14, 'Ionic Foot Detox', 'Thải độc qua bàn chân bằng ion', 500000.00, 45, 15, 'https://placehold.co/300x200/87CEEB/333333?text=IonicFootDetox', 1, 1, 0),
(14, 'Juice Cleanse Program', 'Chương trình thanh lọc bằng nước ép', 900000.00, 60, 15, 'https://placehold.co/300x200/32CD32/333333?text=JuiceCleanse', 1, 1, 0),
(14, 'Clay Detox Facial', 'Chăm sóc mặt thải độc bằng đất sét', 650000.00, 75, 15, 'https://placehold.co/300x200/8FBC8F/333333?text=ClayDetoxFacial', 1, 1, 0),
(14, 'Oxygen Detox Treatment', 'Liệu pháp oxy thải độc', 850000.00, 60, 15, 'https://placehold.co/300x200/F0F8FF/333333?text=OxygenDetox', 1, 1, 0),
(14, 'Herbal Steam Detox', 'Xông hơi thảo dược thải độc', 400000.00, 40, 15, 'https://placehold.co/300x200/ADFF2F/333333?text=HerbalSteamDetox', 1, 1, 0);

-- Services for Service Type 15: Massage Trị Liệu (10 services)
INSERT INTO `services` (`service_type_id`, `name`, `description`, `price`, `duration_minutes`, `buffer_time_after_minutes`, `image_url`, `is_active`, `bookable_online`, `requires_consultation`) VALUES
(15, 'Deep Tissue Massage', 'Massage mô sâu điều trị đau cơ', 700000.00, 75, 15, 'https://placehold.co/300x200/B0E0E6/333333?text=DeepTissue', 1, 1, 1),
(15, 'Sports Massage Therapy', 'Massage thể thao phục hồi cơ bắp', 650000.00, 60, 15, 'https://placehold.co/300x200/4682B4/333333?text=SportsMassage', 1, 1, 0),
(15, 'Trigger Point Therapy', 'Điều trị các điểm kích hoạt đau', 600000.00, 60, 15, 'https://placehold.co/300x200/5F9EA0/333333?text=TriggerPoint', 1, 1, 1),
(15, 'Myofascial Release', 'Giải phóng cân mạc cơ', 750000.00, 75, 20, 'https://placehold.co/300x200/708090/333333?text=MyofascialRelease', 1, 1, 1),
(15, 'Craniosacral Therapy', 'Liệu pháp cột sống cổ', 800000.00, 60, 20, 'https://placehold.co/300x200/778899/333333?text=CraniosacralTherapy', 1, 1, 1),
(15, 'Orthopedic Massage', 'Massage chỉnh hình', 900000.00, 90, 20, 'https://placehold.co/300x200/2F4F4F/333333?text=OrthopedicMassage', 1, 1, 1),
(15, 'Prenatal Massage', 'Massage cho phụ nữ mang thai', 550000.00, 60, 15, 'https://placehold.co/300x200/FFB6C1/333333?text=PrenatalMassage', 1, 1, 1),
(15, 'Geriatric Massage', 'Massage cho người cao tuổi', 500000.00, 45, 15, 'https://placehold.co/300x200/D3D3D3/333333?text=GeriatricMassage', 1, 1, 1),
(15, 'Scar Tissue Massage', 'Massage điều trị scar tích', 650000.00, 60, 20, 'https://placehold.co/300x200/A9A9A9/333333?text=ScarTissueMassage', 1, 1, 1),
(15, 'Neuromuscular Therapy', 'Liệu pháp thần kinh cơ', 850000.00, 75, 20, 'https://placehold.co/300x200/696969/333333?text=NeuroMuscularTherapy', 1, 1, 1); 