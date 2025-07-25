ALTER TABLE bookings 
ADD CONSTRAINT uk_therapist_no_overlap 
UNIQUE (therapist_user_id, appointment_date, appointment_time);

-- B. Unique Constraint on Bed + Time Slot  
-- Prevents same bed being booked at overlapping times
ALTER TABLE bookings 
ADD CONSTRAINT uk_bed_no_overlap 
UNIQUE (bed_id, appointment_date, appointment_time);

-- C. Unique Constraint on Room + Time Slot (if room has only 1 bed)
-- For rooms with single beds
ALTER TABLE bookings 
ADD CONSTRAINT uk_room_single_bed_no_overlap 
UNIQUE (room_id, appointment_date, appointment_time, bed_id);


-- QUICK TEST: Run these commands one by one

-- 1. Add constraints
ALTER TABLE bookings ADD CONSTRAINT uk_therapist_no_overlap UNIQUE (therapist_user_id, appointment_date, appointment_time);
ALTER TABLE bookings ADD CONSTRAINT uk_bed_no_overlap UNIQUE (bed_id, appointment_date, appointment_time);

-- 2. Create valid booking
INSERT INTO bookings (customer_id, payment_item_id, service_id, therapist_user_id, appointment_date, appointment_time, duration_minutes, booking_status, booking_notes, room_id, bed_id) 
VALUES (1, 4, 1, 3, '2025-08-30', '14:00:00', 60, 'SCHEDULED', 'QUICK TEST: Valid', 1, 1);

-- 3. Try therapist conflict (SHOULD FAIL)
INSERT INTO bookings (customer_id, payment_item_id, service_id, therapist_user_id, appointment_date, appointment_time, duration_minutes, booking_status, booking_notes, room_id, bed_id) 
VALUES (2, 5, 2, 3, '2025-08-30', '14:00:00', 90, 'SCHEDULED', 'QUICK TEST: Therapist conflict', 2, 2);

-- 4. Try bed conflict (SHOULD FAIL)  
INSERT INTO bookings (customer_id, payment_item_id, service_id, therapist_user_id, appointment_date, appointment_time, duration_minutes, booking_status, booking_notes, room_id, bed_id) 
VALUES (2, 5, 2, 4, '2025-08-30', '14:00:00', 45, 'SCHEDULED', 'QUICK TEST: Bed conflict', 1, 1);

-- 5. Try valid different time (SHOULD SUCCEED)
INSERT INTO bookings (customer_id, payment_item_id, service_id, therapist_user_id, appointment_date, appointment_time, duration_minutes, booking_status, booking_notes, room_id, bed_id) 
VALUES (2, 5, 2, 3, '2025-08-30', '15:30:00', 60, 'SCHEDULED', 'QUICK TEST: Different time', 2, 2);

-- 6. Check results
SELECT booking_id, therapist_user_id, bed_id, appointment_date, appointment_time, booking_notes 
FROM bookings WHERE booking_notes LIKE 'QUICK TEST:%' ORDER BY appointment_time;

-- 7. Cleanup
DELETE FROM bookings WHERE booking_notes LIKE 'QUICK TEST:%';

DELETE FROM bookings WHERE booking_notes LIKE 'QUICK TEST:%';

select * from bookings;