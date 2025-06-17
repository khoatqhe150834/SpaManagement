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