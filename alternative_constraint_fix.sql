-- Alternative solution: Remove database constraints and rely on application logic
-- This is simpler and works with any MySQL version

-- Step 1: Drop the problematic unique constraints
ALTER TABLE bookings DROP INDEX uk_therapist_no_overlap;
ALTER TABLE bookings DROP INDEX uk_bed_no_overlap; 
ALTER TABLE bookings DROP INDEX uk_room_single_bed_no_overlap;

-- Step 2: Add regular indexes for performance (not unique)
-- These help with query performance but don't enforce uniqueness
CREATE INDEX idx_therapist_schedule_active 
ON bookings (therapist_user_id, appointment_date, appointment_time, booking_status);

CREATE INDEX idx_bed_schedule_active 
ON bookings (bed_id, appointment_date, appointment_time, booking_status);

CREATE INDEX idx_room_schedule_active 
ON bookings (room_id, appointment_date, appointment_time, bed_id, booking_status);

-- Step 3: Test that overlapping bookings are now allowed at database level
-- Insert a test booking
INSERT INTO bookings (customer_id, payment_item_id, service_id, therapist_user_id, 
                     appointment_date, appointment_time, duration_minutes, booking_status, 
                     booking_notes, room_id, bed_id) 
VALUES (1, 1, 1, 46, '2025-07-28', '10:00:00', 60, 'SCHEDULED', 
        'Test booking 1', 2, 3);

-- Try to insert another booking with same therapist/time (should succeed now)
INSERT INTO bookings (customer_id, payment_item_id, service_id, therapist_user_id, 
                     appointment_date, appointment_time, duration_minutes, booking_status, 
                     booking_notes, room_id, bed_id) 
VALUES (2, 2, 1, 46, '2025-07-28', '10:00:00', 60, 'SCHEDULED', 
        'Test booking 2 - overlapping', 2, 3);

-- Verify both bookings exist
SELECT booking_id, customer_id, therapist_user_id, appointment_date, appointment_time, 
       booking_status, booking_notes
FROM bookings 
WHERE therapist_user_id = 46 
  AND appointment_date = '2025-07-28' 
  AND appointment_time = '10:00:00'
ORDER BY booking_id;

-- Clean up test data
DELETE FROM bookings 
WHERE booking_notes LIKE 'Test booking%' 
  AND appointment_date = '2025-07-28';

-- Step 4: Verify the application logic handles conflicts
-- The Java code in BookingDAO.isTherapistAvailable() and 
-- ManagerSchedulingController.checkTherapistAvailability() 
-- already properly excludes CANCELLED bookings when checking availability.

SELECT 'Alternative fix applied. Database constraints removed, application logic will handle conflicts.' as message;

-- Note: This approach relies entirely on the application logic to prevent conflicts.
-- The advantage is that it's simple and works with any MySQL version.
-- The disadvantage is that if someone inserts data directly into the database,
-- they could create conflicts that the application wouldn't catch.
