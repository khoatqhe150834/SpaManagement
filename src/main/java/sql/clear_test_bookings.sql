-- Clear test bookings that are causing calendar availability issues
-- WARNING: This will remove all existing bookings - use only in development!

-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- Clear booking appointments (the actual service appointments)
DELETE FROM booking_appointments WHERE booking_appointment_id >= 143;

-- Clear booking groups (the booking sessions)
DELETE FROM booking_groups WHERE booking_group_id >= 185;

-- Clear booking sessions (temporary session data)
DELETE FROM booking_sessions;

-- Clear any check-ins related to these appointments
DELETE FROM checkins;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Verify cleanup
SELECT 'Remaining booking_appointments' as table_name, COUNT(*) as count FROM booking_appointments
UNION ALL
SELECT 'Remaining booking_groups' as table_name, COUNT(*) as count FROM booking_groups
UNION ALL
SELECT 'Remaining booking_sessions' as table_name, COUNT(*) as count FROM booking_sessions; 