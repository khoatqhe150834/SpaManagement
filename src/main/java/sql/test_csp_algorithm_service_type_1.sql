-- Test Data for CSP Algorithm: Service Type 1 (Massage) - All Therapists Occupied
-- This script creates booking appointments for service ID = 1 (Swedish Massage) 
-- across multiple time slots and days to fully occupy all 4 therapists qualified for service type 1
-- 
-- Therapists qualified for service type 1 (Massage):
-- - user_id 3: Massage specialist with 5 years experience
-- - user_id 12: Thai massage and acupressure specialist  
-- - user_id 16: Sports massage and injury recovery specialist
-- - user_id 18: Hot stone massage specialist
--
-- Service Details:
-- - Service ID: 1 (Swedish Massage)
-- - Duration: 60 minutes
-- - Buffer time: 15 minutes
-- - Price: 500,000 VND
--
-- Test Period: June 30 - July 3, 2025
-- Time Slots: 10:00 AM, 2:00 PM, 4:00 PM, 6:00 PM (4 slots per day)
-- Total Appointments: 64 (4 therapists × 4 time slots × 4 days)

-- =============================================================================
-- DAY 1: JUNE 30, 2025
-- =============================================================================

-- Create booking groups for June 30, 2025
INSERT INTO `booking_groups` 
(`customer_id`, `booking_date`, `total_amount`, `payment_status`, `booking_status`, `payment_method`, `special_notes`)
VALUES 
-- Time Slot 1: 10:00 AM
(1, '2025-06-30', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - June 30 - 10:00 AM'),
(2, '2025-06-30', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - June 30 - 10:00 AM'),
(3, '2025-06-30', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - June 30 - 10:00 AM'),
(5, '2025-06-30', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - June 30 - 10:00 AM'),

-- Time Slot 2: 2:00 PM
(1, '2025-06-30', 500000.00, 'PENDING', 'CONFIRMED', 'CREDIT_CARD', 'CSP Test - June 30 - 2:00 PM'),
(2, '2025-06-30', 500000.00, 'PENDING', 'CONFIRMED', 'CREDIT_CARD', 'CSP Test - June 30 - 2:00 PM'),
(3, '2025-06-30', 500000.00, 'PENDING', 'CONFIRMED', 'CREDIT_CARD', 'CSP Test - June 30 - 2:00 PM'),
(5, '2025-06-30', 500000.00, 'PENDING', 'CONFIRMED', 'CREDIT_CARD', 'CSP Test - June 30 - 2:00 PM'),

-- Time Slot 3: 4:00 PM
(1, '2025-06-30', 500000.00, 'PENDING', 'CONFIRMED', 'CASH', 'CSP Test - June 30 - 4:00 PM'),
(2, '2025-06-30', 500000.00, 'PENDING', 'CONFIRMED', 'CASH', 'CSP Test - June 30 - 4:00 PM'),
(3, '2025-06-30', 500000.00, 'PENDING', 'CONFIRMED', 'CASH', 'CSP Test - June 30 - 4:00 PM'),
(5, '2025-06-30', 500000.00, 'PENDING', 'CONFIRMED', 'CASH', 'CSP Test - June 30 - 4:00 PM'),

-- Time Slot 4: 6:00 PM
(1, '2025-06-30', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - June 30 - 6:00 PM'),
(2, '2025-06-30', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - June 30 - 6:00 PM'),
(3, '2025-06-30', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - June 30 - 6:00 PM'),
(5, '2025-06-30', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - June 30 - 6:00 PM');

-- =============================================================================
-- DAY 2: JULY 1, 2025
-- =============================================================================

-- Create booking groups for July 1, 2025
INSERT INTO `booking_groups` 
(`customer_id`, `booking_date`, `total_amount`, `payment_status`, `booking_status`, `payment_method`, `special_notes`)
VALUES 
-- Time Slot 1: 10:00 AM
(1, '2025-07-01', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 1 - 10:00 AM'),
(2, '2025-07-01', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 1 - 10:00 AM'),
(3, '2025-07-01', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 1 - 10:00 AM'),
(5, '2025-07-01', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 1 - 10:00 AM'),

-- Time Slot 2: 2:00 PM
(1, '2025-07-01', 500000.00, 'PENDING', 'CONFIRMED', 'CREDIT_CARD', 'CSP Test - July 1 - 2:00 PM'),
(2, '2025-07-01', 500000.00, 'PENDING', 'CONFIRMED', 'CREDIT_CARD', 'CSP Test - July 1 - 2:00 PM'),
(3, '2025-07-01', 500000.00, 'PENDING', 'CONFIRMED', 'CREDIT_CARD', 'CSP Test - July 1 - 2:00 PM'),
(5, '2025-07-01', 500000.00, 'PENDING', 'CONFIRMED', 'CREDIT_CARD', 'CSP Test - July 1 - 2:00 PM'),

-- Time Slot 3: 4:00 PM
(1, '2025-07-01', 500000.00, 'PENDING', 'CONFIRMED', 'CASH', 'CSP Test - July 1 - 4:00 PM'),
(2, '2025-07-01', 500000.00, 'PENDING', 'CONFIRMED', 'CASH', 'CSP Test - July 1 - 4:00 PM'),
(3, '2025-07-01', 500000.00, 'PENDING', 'CONFIRMED', 'CASH', 'CSP Test - July 1 - 4:00 PM'),
(5, '2025-07-01', 500000.00, 'PENDING', 'CONFIRMED', 'CASH', 'CSP Test - July 1 - 4:00 PM'),

-- Time Slot 4: 6:00 PM
(1, '2025-07-01', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 1 - 6:00 PM'),
(2, '2025-07-01', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 1 - 6:00 PM'),
(3, '2025-07-01', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 1 - 6:00 PM'),
(5, '2025-07-01', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 1 - 6:00 PM');

-- =============================================================================
-- DAY 3: JULY 2, 2025
-- =============================================================================

-- Create booking groups for July 2, 2025
INSERT INTO `booking_groups` 
(`customer_id`, `booking_date`, `total_amount`, `payment_status`, `booking_status`, `payment_method`, `special_notes`)
VALUES 
-- Time Slot 1: 10:00 AM
(1, '2025-07-02', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 2 - 10:00 AM'),
(2, '2025-07-02', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 2 - 10:00 AM'),
(3, '2025-07-02', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 2 - 10:00 AM'),
(5, '2025-07-02', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 2 - 10:00 AM'),

-- Time Slot 2: 2:00 PM
(1, '2025-07-02', 500000.00, 'PENDING', 'CONFIRMED', 'CREDIT_CARD', 'CSP Test - July 2 - 2:00 PM'),
(2, '2025-07-02', 500000.00, 'PENDING', 'CONFIRMED', 'CREDIT_CARD', 'CSP Test - July 2 - 2:00 PM'),
(3, '2025-07-02', 500000.00, 'PENDING', 'CONFIRMED', 'CREDIT_CARD', 'CSP Test - July 2 - 2:00 PM'),
(5, '2025-07-02', 500000.00, 'PENDING', 'CONFIRMED', 'CREDIT_CARD', 'CSP Test - July 2 - 2:00 PM'),

-- Time Slot 3: 4:00 PM
(1, '2025-07-02', 500000.00, 'PENDING', 'CONFIRMED', 'CASH', 'CSP Test - July 2 - 4:00 PM'),
(2, '2025-07-02', 500000.00, 'PENDING', 'CONFIRMED', 'CASH', 'CSP Test - July 2 - 4:00 PM'),
(3, '2025-07-02', 500000.00, 'PENDING', 'CONFIRMED', 'CASH', 'CSP Test - July 2 - 4:00 PM'),
(5, '2025-07-02', 500000.00, 'PENDING', 'CONFIRMED', 'CASH', 'CSP Test - July 2 - 4:00 PM'),

-- Time Slot 4: 6:00 PM
(1, '2025-07-02', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 2 - 6:00 PM'),
(2, '2025-07-02', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 2 - 6:00 PM'),
(3, '2025-07-02', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 2 - 6:00 PM'),
(5, '2025-07-02', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 2 - 6:00 PM');

-- =============================================================================
-- DAY 4: JULY 3, 2025
-- =============================================================================

-- Create booking groups for July 3, 2025
INSERT INTO `booking_groups` 
(`customer_id`, `booking_date`, `total_amount`, `payment_status`, `booking_status`, `payment_method`, `special_notes`)
VALUES 
-- Time Slot 1: 10:00 AM
(1, '2025-07-03', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 3 - 10:00 AM'),
(2, '2025-07-03', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 3 - 10:00 AM'),
(3, '2025-07-03', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 3 - 10:00 AM'),
(5, '2025-07-03', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 3 - 10:00 AM'),

-- Time Slot 2: 2:00 PM
(1, '2025-07-03', 500000.00, 'PENDING', 'CONFIRMED', 'CREDIT_CARD', 'CSP Test - July 3 - 2:00 PM'),
(2, '2025-07-03', 500000.00, 'PENDING', 'CONFIRMED', 'CREDIT_CARD', 'CSP Test - July 3 - 2:00 PM'),
(3, '2025-07-03', 500000.00, 'PENDING', 'CONFIRMED', 'CREDIT_CARD', 'CSP Test - July 3 - 2:00 PM'),
(5, '2025-07-03', 500000.00, 'PENDING', 'CONFIRMED', 'CREDIT_CARD', 'CSP Test - July 3 - 2:00 PM'),

-- Time Slot 3: 4:00 PM
(1, '2025-07-03', 500000.00, 'PENDING', 'CONFIRMED', 'CASH', 'CSP Test - July 3 - 4:00 PM'),
(2, '2025-07-03', 500000.00, 'PENDING', 'CONFIRMED', 'CASH', 'CSP Test - July 3 - 4:00 PM'),
(3, '2025-07-03', 500000.00, 'PENDING', 'CONFIRMED', 'CASH', 'CSP Test - July 3 - 4:00 PM'),
(5, '2025-07-03', 500000.00, 'PENDING', 'CONFIRMED', 'CASH', 'CSP Test - July 3 - 4:00 PM'),

-- Time Slot 4: 6:00 PM
(1, '2025-07-03', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 3 - 6:00 PM'),
(2, '2025-07-03', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 3 - 6:00 PM'),
(3, '2025-07-03', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 3 - 6:00 PM'),
(5, '2025-07-03', 500000.00, 'PENDING', 'CONFIRMED', 'ONLINE_BANKING', 'CSP Test - July 3 - 6:00 PM');

-- =============================================================================
-- BOOKING APPOINTMENTS CREATION
-- =============================================================================

-- Get the starting booking group ID for calculations
SET @start_group_id = (SELECT MAX(booking_group_id) - 63 FROM booking_groups);

-- JUNE 30, 2025 - APPOINTMENTS
-- Time Slot 1: 10:00 AM - 11:00 AM
INSERT INTO `booking_appointments` 
(`booking_group_id`, `service_id`, `therapist_user_id`, `start_time`, `end_time`, `service_price`, `status`, `service_notes`)
VALUES
(@start_group_id + 0, 1, 3, '2025-06-30 10:00:00', '2025-06-30 11:00:00', 500000.00, 'SCHEDULED', 'CSP Test - June 30 10:00 AM - Therapist 3'),
(@start_group_id + 1, 1, 12, '2025-06-30 10:00:00', '2025-06-30 11:00:00', 500000.00, 'SCHEDULED', 'CSP Test - June 30 10:00 AM - Therapist 12'),
(@start_group_id + 2, 1, 16, '2025-06-30 10:00:00', '2025-06-30 11:00:00', 500000.00, 'SCHEDULED', 'CSP Test - June 30 10:00 AM - Therapist 16'),
(@start_group_id + 3, 1, 18, '2025-06-30 10:00:00', '2025-06-30 11:00:00', 500000.00, 'SCHEDULED', 'CSP Test - June 30 10:00 AM - Therapist 18'),

-- Time Slot 2: 2:00 PM - 3:00 PM
(@start_group_id + 4, 1, 3, '2025-06-30 14:00:00', '2025-06-30 15:00:00', 500000.00, 'SCHEDULED', 'CSP Test - June 30 2:00 PM - Therapist 3'),
(@start_group_id + 5, 1, 12, '2025-06-30 14:00:00', '2025-06-30 15:00:00', 500000.00, 'SCHEDULED', 'CSP Test - June 30 2:00 PM - Therapist 12'),
(@start_group_id + 6, 1, 16, '2025-06-30 14:00:00', '2025-06-30 15:00:00', 500000.00, 'SCHEDULED', 'CSP Test - June 30 2:00 PM - Therapist 16'),
(@start_group_id + 7, 1, 18, '2025-06-30 14:00:00', '2025-06-30 15:00:00', 500000.00, 'SCHEDULED', 'CSP Test - June 30 2:00 PM - Therapist 18'),

-- Time Slot 3: 4:00 PM - 5:00 PM
(@start_group_id + 8, 1, 3, '2025-06-30 16:00:00', '2025-06-30 17:00:00', 500000.00, 'SCHEDULED', 'CSP Test - June 30 4:00 PM - Therapist 3'),
(@start_group_id + 9, 1, 12, '2025-06-30 16:00:00', '2025-06-30 17:00:00', 500000.00, 'SCHEDULED', 'CSP Test - June 30 4:00 PM - Therapist 12'),
(@start_group_id + 10, 1, 16, '2025-06-30 16:00:00', '2025-06-30 17:00:00', 500000.00, 'SCHEDULED', 'CSP Test - June 30 4:00 PM - Therapist 16'),
(@start_group_id + 11, 1, 18, '2025-06-30 16:00:00', '2025-06-30 17:00:00', 500000.00, 'SCHEDULED', 'CSP Test - June 30 4:00 PM - Therapist 18'),

-- Time Slot 4: 6:00 PM - 7:00 PM
(@start_group_id + 12, 1, 3, '2025-06-30 18:00:00', '2025-06-30 19:00:00', 500000.00, 'SCHEDULED', 'CSP Test - June 30 6:00 PM - Therapist 3'),
(@start_group_id + 13, 1, 12, '2025-06-30 18:00:00', '2025-06-30 19:00:00', 500000.00, 'SCHEDULED', 'CSP Test - June 30 6:00 PM - Therapist 12'),
(@start_group_id + 14, 1, 16, '2025-06-30 18:00:00', '2025-06-30 19:00:00', 500000.00, 'SCHEDULED', 'CSP Test - June 30 6:00 PM - Therapist 16'),
(@start_group_id + 15, 1, 18, '2025-06-30 18:00:00', '2025-06-30 19:00:00', 500000.00, 'SCHEDULED', 'CSP Test - June 30 6:00 PM - Therapist 18');

-- JULY 1, 2025 - APPOINTMENTS
-- Time Slot 1: 10:00 AM - 11:00 AM
INSERT INTO `booking_appointments` 
(`booking_group_id`, `service_id`, `therapist_user_id`, `start_time`, `end_time`, `service_price`, `status`, `service_notes`)
VALUES
(@start_group_id + 16, 1, 3, '2025-07-01 10:00:00', '2025-07-01 11:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 1 10:00 AM - Therapist 3'),
(@start_group_id + 17, 1, 12, '2025-07-01 10:00:00', '2025-07-01 11:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 1 10:00 AM - Therapist 12'),
(@start_group_id + 18, 1, 16, '2025-07-01 10:00:00', '2025-07-01 11:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 1 10:00 AM - Therapist 16'),
(@start_group_id + 19, 1, 18, '2025-07-01 10:00:00', '2025-07-01 11:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 1 10:00 AM - Therapist 18'),

-- Time Slot 2: 2:00 PM - 3:00 PM
(@start_group_id + 20, 1, 3, '2025-07-01 14:00:00', '2025-07-01 15:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 1 2:00 PM - Therapist 3'),
(@start_group_id + 21, 1, 12, '2025-07-01 14:00:00', '2025-07-01 15:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 1 2:00 PM - Therapist 12'),
(@start_group_id + 22, 1, 16, '2025-07-01 14:00:00', '2025-07-01 15:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 1 2:00 PM - Therapist 16'),
(@start_group_id + 23, 1, 18, '2025-07-01 14:00:00', '2025-07-01 15:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 1 2:00 PM - Therapist 18'),

-- Time Slot 3: 4:00 PM - 5:00 PM
(@start_group_id + 24, 1, 3, '2025-07-01 16:00:00', '2025-07-01 17:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 1 4:00 PM - Therapist 3'),
(@start_group_id + 25, 1, 12, '2025-07-01 16:00:00', '2025-07-01 17:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 1 4:00 PM - Therapist 12'),
(@start_group_id + 26, 1, 16, '2025-07-01 16:00:00', '2025-07-01 17:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 1 4:00 PM - Therapist 16'),
(@start_group_id + 27, 1, 18, '2025-07-01 16:00:00', '2025-07-01 17:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 1 4:00 PM - Therapist 18'),

-- Time Slot 4: 6:00 PM - 7:00 PM
(@start_group_id + 28, 1, 3, '2025-07-01 18:00:00', '2025-07-01 19:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 1 6:00 PM - Therapist 3'),
(@start_group_id + 29, 1, 12, '2025-07-01 18:00:00', '2025-07-01 19:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 1 6:00 PM - Therapist 12'),
(@start_group_id + 30, 1, 16, '2025-07-01 18:00:00', '2025-07-01 19:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 1 6:00 PM - Therapist 16'),
(@start_group_id + 31, 1, 18, '2025-07-01 18:00:00', '2025-07-01 19:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 1 6:00 PM - Therapist 18');

-- JULY 2, 2025 - APPOINTMENTS
-- Time Slot 1: 10:00 AM - 11:00 AM
INSERT INTO `booking_appointments` 
(`booking_group_id`, `service_id`, `therapist_user_id`, `start_time`, `end_time`, `service_price`, `status`, `service_notes`)
VALUES
(@start_group_id + 32, 1, 3, '2025-07-02 10:00:00', '2025-07-02 11:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 2 10:00 AM - Therapist 3'),
(@start_group_id + 33, 1, 12, '2025-07-02 10:00:00', '2025-07-02 11:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 2 10:00 AM - Therapist 12'),
(@start_group_id + 34, 1, 16, '2025-07-02 10:00:00', '2025-07-02 11:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 2 10:00 AM - Therapist 16'),
(@start_group_id + 35, 1, 18, '2025-07-02 10:00:00', '2025-07-02 11:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 2 10:00 AM - Therapist 18'),

-- Time Slot 2: 2:00 PM - 3:00 PM
(@start_group_id + 36, 1, 3, '2025-07-02 14:00:00', '2025-07-02 15:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 2 2:00 PM - Therapist 3'),
(@start_group_id + 37, 1, 12, '2025-07-02 14:00:00', '2025-07-02 15:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 2 2:00 PM - Therapist 12'),
(@start_group_id + 38, 1, 16, '2025-07-02 14:00:00', '2025-07-02 15:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 2 2:00 PM - Therapist 16'),
(@start_group_id + 39, 1, 18, '2025-07-02 14:00:00', '2025-07-02 15:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 2 2:00 PM - Therapist 18'),

-- Time Slot 3: 4:00 PM - 5:00 PM
(@start_group_id + 40, 1, 3, '2025-07-02 16:00:00', '2025-07-02 17:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 2 4:00 PM - Therapist 3'),
(@start_group_id + 41, 1, 12, '2025-07-02 16:00:00', '2025-07-02 17:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 2 4:00 PM - Therapist 12'),
(@start_group_id + 42, 1, 16, '2025-07-02 16:00:00', '2025-07-02 17:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 2 4:00 PM - Therapist 16'),
(@start_group_id + 43, 1, 18, '2025-07-02 16:00:00', '2025-07-02 17:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 2 4:00 PM - Therapist 18'),

-- Time Slot 4: 6:00 PM - 7:00 PM
(@start_group_id + 44, 1, 3, '2025-07-02 18:00:00', '2025-07-02 19:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 2 6:00 PM - Therapist 3'),
(@start_group_id + 45, 1, 12, '2025-07-02 18:00:00', '2025-07-02 19:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 2 6:00 PM - Therapist 12'),
(@start_group_id + 46, 1, 16, '2025-07-02 18:00:00', '2025-07-02 19:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 2 6:00 PM - Therapist 16'),
(@start_group_id + 47, 1, 18, '2025-07-02 18:00:00', '2025-07-02 19:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 2 6:00 PM - Therapist 18');

-- JULY 3, 2025 - APPOINTMENTS
-- Time Slot 1: 10:00 AM - 11:00 AM
INSERT INTO `booking_appointments` 
(`booking_group_id`, `service_id`, `therapist_user_id`, `start_time`, `end_time`, `service_price`, `status`, `service_notes`)
VALUES
(@start_group_id + 48, 1, 3, '2025-07-03 10:00:00', '2025-07-03 11:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 3 10:00 AM - Therapist 3'),
(@start_group_id + 49, 1, 12, '2025-07-03 10:00:00', '2025-07-03 11:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 3 10:00 AM - Therapist 12'),
(@start_group_id + 50, 1, 16, '2025-07-03 10:00:00', '2025-07-03 11:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 3 10:00 AM - Therapist 16'),
(@start_group_id + 51, 1, 18, '2025-07-03 10:00:00', '2025-07-03 11:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 3 10:00 AM - Therapist 18'),

-- Time Slot 2: 2:00 PM - 3:00 PM
(@start_group_id + 52, 1, 3, '2025-07-03 14:00:00', '2025-07-03 15:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 3 2:00 PM - Therapist 3'),
(@start_group_id + 53, 1, 12, '2025-07-03 14:00:00', '2025-07-03 15:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 3 2:00 PM - Therapist 12'),
(@start_group_id + 54, 1, 16, '2025-07-03 14:00:00', '2025-07-03 15:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 3 2:00 PM - Therapist 16'),
(@start_group_id + 55, 1, 18, '2025-07-03 14:00:00', '2025-07-03 15:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 3 2:00 PM - Therapist 18'),

-- Time Slot 3: 4:00 PM - 5:00 PM
(@start_group_id + 56, 1, 3, '2025-07-03 16:00:00', '2025-07-03 17:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 3 4:00 PM - Therapist 3'),
(@start_group_id + 57, 1, 12, '2025-07-03 16:00:00', '2025-07-03 17:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 3 4:00 PM - Therapist 12'),
(@start_group_id + 58, 1, 16, '2025-07-03 16:00:00', '2025-07-03 17:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 3 4:00 PM - Therapist 16'),
(@start_group_id + 59, 1, 18, '2025-07-03 16:00:00', '2025-07-03 17:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 3 4:00 PM - Therapist 18'),

-- Time Slot 4: 6:00 PM - 7:00 PM
(@start_group_id + 60, 1, 3, '2025-07-03 18:00:00', '2025-07-03 19:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 3 6:00 PM - Therapist 3'),
(@start_group_id + 61, 1, 12, '2025-07-03 18:00:00', '2025-07-03 19:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 3 6:00 PM - Therapist 12'),
(@start_group_id + 62, 1, 16, '2025-07-03 18:00:00', '2025-07-03 19:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 3 6:00 PM - Therapist 16'),
(@start_group_id + 63, 1, 18, '2025-07-03 18:00:00', '2025-07-03 19:00:00', 500000.00, 'SCHEDULED', 'CSP Test - July 3 6:00 PM - Therapist 18');

-- Verify the test data
SELECT 
    bg.booking_group_id,
    bg.customer_id,
    bg.booking_date,
    ba.appointment_id,
    ba.service_id,
    s.name as service_name,
    s.service_type_id,
    st.name as service_type_name,
    ba.therapist_user_id,
    u.full_name as therapist_name,
    t.service_type_id as therapist_service_type,
    ba.start_time,
    ba.end_time,
    ba.status
FROM booking_groups bg
JOIN booking_appointments ba ON bg.booking_group_id = ba.booking_group_id  
JOIN services s ON ba.service_id = s.service_id
JOIN service_types st ON s.service_type_id = st.service_type_id
JOIN users u ON ba.therapist_user_id = u.user_id
JOIN therapists t ON ba.therapist_user_id = t.user_id
WHERE bg.booking_date = '2025-06-30'
  AND ba.start_time = '2025-06-30 10:00:00'
  AND s.service_id = 1
ORDER BY ba.therapist_user_id;

-- Check that all therapists for service type 1 are now occupied at 10:00 AM on 2025-06-30
SELECT 
    t.user_id as therapist_id,
    u.full_name as therapist_name,
    t.service_type_id,
    st.name as service_type_name,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM booking_appointments ba 
            WHERE ba.therapist_user_id = t.user_id 
            AND ba.start_time = '2025-06-30 10:00:00'
            AND ba.status = 'SCHEDULED'
        ) THEN 'OCCUPIED'
        ELSE 'AVAILABLE'
    END as availability_status
FROM therapists t
JOIN users u ON t.user_id = u.user_id  
JOIN service_types st ON t.service_type_id = st.service_type_id
WHERE t.service_type_id = 1
ORDER BY t.user_id;

-- Summary: CSP Algorithm Test Scenario
-- ===========================================
-- All 4 therapists qualified for service type 1 (Massage) are now OCCUPIED 
-- at 10:00 AM on June 30, 2025 with Swedish Massage appointments.
-- 
-- This creates the perfect test scenario for the CSP algorithm:
-- - When a new customer tries to book service ID = 1 (Swedish Massage) at 10:00 AM
-- - The algorithm should detect that ALL qualified therapists are busy
-- - It should either suggest alternative time slots or return "no availability"
--
-- Expected CSP Algorithm Behavior:
-- 1. Query: Find available therapists for service_id = 1 at 2025-06-30 10:00:00
-- 2. Result: No therapists available (all 4 are occupied)
-- 3. Fallback: Suggest next available time slots for these therapists
-- 4. Alternative: Suggest different service times or dates 