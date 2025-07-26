-- Fix booking constraints to exclude CANCELLED and NO_SHOW bookings
-- This allows rebooking the same therapist/bed/room after cancellation

-- Step 1: Drop existing constraints that block cancelled bookings
ALTER TABLE bookings DROP INDEX uk_therapist_no_overlap;
ALTER TABLE bookings DROP INDEX uk_bed_no_overlap;
ALTER TABLE bookings DROP INDEX uk_room_single_bed_no_overlap;

-- Step 2: Create new constraints using generated columns (compatible with MySQL 5.7+)
-- Add a generated column that is NULL for cancelled/no-show bookings

-- Add a generated column for active bookings only
ALTER TABLE bookings
ADD COLUMN active_booking_flag INT GENERATED ALWAYS AS (
    CASE WHEN booking_status NOT IN ('CANCELLED', 'NO_SHOW') THEN 1 ELSE NULL END
) STORED;

-- Create unique constraints using the generated column
-- Therapist availability constraint (excludes CANCELLED and NO_SHOW)
ALTER TABLE bookings
ADD CONSTRAINT uk_therapist_no_overlap_active
UNIQUE (therapist_user_id, appointment_date, appointment_time, active_booking_flag);

-- Bed availability constraint (excludes CANCELLED and NO_SHOW)
ALTER TABLE bookings
ADD CONSTRAINT uk_bed_no_overlap_active
UNIQUE (bed_id, appointment_date, appointment_time, active_booking_flag);

-- Room single bed constraint (excludes CANCELLED and NO_SHOW)
ALTER TABLE bookings
ADD CONSTRAINT uk_room_single_bed_no_overlap_active
UNIQUE (room_id, appointment_date, appointment_time, bed_id, active_booking_flag);

-- Step 3: Test the fix
-- Insert a test booking
INSERT INTO bookings (customer_id, payment_item_id, service_id, therapist_user_id, 
                     appointment_date, appointment_time, duration_minutes, booking_status, 
                     booking_notes, room_id, bed_id) 
VALUES (1, 1, 1, 46, '2025-07-27', '10:00:00', 60, 'SCHEDULED', 
        'Test booking for constraint fix', 2, 3);

-- Cancel the test booking
UPDATE bookings 
SET booking_status = 'CANCELLED', 
    booking_notes = CONCAT(booking_notes, '\n[CANCELLED for testing]')
WHERE therapist_user_id = 46 
  AND appointment_date = '2025-07-27' 
  AND appointment_time = '10:00:00'
  AND booking_notes LIKE '%Test booking for constraint fix%';

-- Try to book the same therapist at the same time (should succeed now)
INSERT INTO bookings (customer_id, payment_item_id, service_id, therapist_user_id, 
                     appointment_date, appointment_time, duration_minutes, booking_status, 
                     booking_notes, room_id, bed_id) 
VALUES (2, 2, 1, 46, '2025-07-27', '10:00:00', 60, 'SCHEDULED', 
        'New booking after cancellation - should work', 2, 3);

-- Verify the results
SELECT booking_id, customer_id, therapist_user_id, appointment_date, appointment_time, 
       booking_status, booking_notes
FROM bookings 
WHERE therapist_user_id = 46 
  AND appointment_date = '2025-07-27' 
  AND appointment_time = '10:00:00'
ORDER BY booking_id;

-- Clean up test data
DELETE FROM bookings 
WHERE booking_notes LIKE '%Test booking for constraint fix%' 
   OR booking_notes LIKE '%New booking after cancellation - should work%';
