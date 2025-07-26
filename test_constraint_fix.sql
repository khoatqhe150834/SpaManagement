-- Test script to verify the constraint fix works
-- Run this step by step to test the solution

-- Step 1: Check current constraints
SHOW INDEX FROM bookings WHERE Key_name LIKE '%overlap%';

-- Step 2: Test current behavior (should fail if old constraints exist)
-- Try to insert a booking with same therapist/time as a cancelled booking
SELECT 'Testing current constraint behavior...' as status;

-- Find a cancelled booking to test with
SELECT booking_id, customer_id, therapist_user_id, appointment_date, appointment_time, booking_status
FROM bookings 
WHERE booking_status = 'CANCELLED' 
LIMIT 1;

-- Step 3: Try to create a new booking with same therapist/time (will fail with old constraints)
-- Replace the values below with actual values from the cancelled booking above
/*
INSERT INTO bookings (customer_id, payment_item_id, service_id, therapist_user_id, 
                     appointment_date, appointment_time, duration_minutes, booking_status, 
                     booking_notes, room_id, bed_id) 
VALUES (999, 1, 1, 46, '2025-07-26', '08:30:00', 60, 'SCHEDULED', 
        'Test booking - should fail with old constraints', 2, 3);
*/

-- Step 4: Apply the fix (run the main fix script)
-- This should be done by running fix_booking_constraints.sql

-- Step 5: Verify the fix worked
-- Check if the generated column was added
DESCRIBE bookings;

-- Check new constraints
SHOW INDEX FROM bookings WHERE Key_name LIKE '%active%';

-- Step 6: Test that the fix works
-- Try the same insert again (should succeed after fix)
/*
INSERT INTO bookings (customer_id, payment_item_id, service_id, therapist_user_id, 
                     appointment_date, appointment_time, duration_minutes, booking_status, 
                     booking_notes, room_id, bed_id) 
VALUES (999, 1, 1, 46, '2025-07-26', '08:30:00', 60, 'SCHEDULED', 
        'Test booking - should succeed after fix', 2, 3);
*/

-- Step 7: Verify both bookings exist
/*
SELECT booking_id, customer_id, therapist_user_id, appointment_date, appointment_time, 
       booking_status, active_booking_flag, booking_notes
FROM bookings 
WHERE therapist_user_id = 46 
  AND appointment_date = '2025-07-26' 
  AND appointment_time = '08:30:00'
ORDER BY booking_id;
*/

-- Step 8: Test that active bookings still conflict (should fail)
/*
INSERT INTO bookings (customer_id, payment_item_id, service_id, therapist_user_id, 
                     appointment_date, appointment_time, duration_minutes, booking_status, 
                     booking_notes, room_id, bed_id) 
VALUES (998, 1, 1, 46, '2025-07-26', '08:30:00', 60, 'SCHEDULED', 
        'Test booking - should fail because therapist is busy', 2, 3);
*/

-- Step 9: Clean up test data
/*
DELETE FROM bookings 
WHERE booking_notes LIKE '%Test booking%' 
  AND customer_id IN (998, 999);
*/

SELECT 'Test script ready. Follow the steps in comments.' as message;
