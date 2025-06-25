-- Analysis script to understand booking data structure
-- and why CSP constraints might not be working

-- 1. Check booking_appointments table structure
SELECT 'BOOKING_APPOINTMENTS TABLE STRUCTURE' as analysis_type;
DESCRIBE booking_appointments;

-- 2. Check all data in booking_appointments for 2025-06-26
SELECT 'BOOKINGS ON 2025-06-26' as analysis_type;
SELECT 
    ba.booking_appointment_id,
    ba.booking_group_id,
    ba.service_id,
    ba.therapist_user_id,
    ba.start_time,
    ba.end_time,
    ba.status,
    s.name as service_name,
    u.full_name as therapist_name
FROM booking_appointments ba
LEFT JOIN services s ON ba.service_id = s.service_id
LEFT JOIN users u ON ba.therapist_user_id = u.user_id
WHERE DATE(ba.start_time) = '2025-06-26'
ORDER BY ba.start_time, ba.therapist_user_id;

-- 3. Count bookings by therapist on 2025-06-26
SELECT 'BOOKING COUNT BY THERAPIST ON 2025-06-26' as analysis_type;
SELECT 
    ba.therapist_user_id,
    u.full_name as therapist_name,
    COUNT(*) as booking_count,
    GROUP_CONCAT(
        CONCAT(TIME(ba.start_time), '-', TIME(ba.end_time), '(', s.name, ')')
        ORDER BY ba.start_time
        SEPARATOR ', '
    ) as time_slots
FROM booking_appointments ba
LEFT JOIN users u ON ba.therapist_user_id = u.user_id
LEFT JOIN services s ON ba.service_id = s.service_id
WHERE DATE(ba.start_time) = '2025-06-26'
  AND ba.status IN ('SCHEDULED', 'IN_PROGRESS')
GROUP BY ba.therapist_user_id, u.full_name
ORDER BY booking_count DESC;

-- 4. Check for overlapping bookings (should be conflicts)
SELECT 'OVERLAPPING BOOKINGS ANALYSIS' as analysis_type;
SELECT 
    a1.booking_appointment_id as booking1_id,
    a1.therapist_user_id,
    a1.start_time as booking1_start,
    a1.end_time as booking1_end,
    a2.booking_appointment_id as booking2_id,
    a2.start_time as booking2_start,
    a2.end_time as booking2_end,
    'OVERLAP DETECTED' as conflict_status
FROM booking_appointments a1
JOIN booking_appointments a2 ON (
    a1.therapist_user_id = a2.therapist_user_id 
    AND a1.booking_appointment_id != a2.booking_appointment_id
    AND a1.status IN ('SCHEDULED', 'IN_PROGRESS')
    AND a2.status IN ('SCHEDULED', 'IN_PROGRESS')
    AND (
        (a1.start_time < a2.end_time AND a1.end_time > a2.start_time)
    )
)
WHERE DATE(a1.start_time) = '2025-06-26'
ORDER BY a1.therapist_user_id, a1.start_time;

-- 5. Check therapist availability status
SELECT 'THERAPIST AVAILABILITY STATUS' as analysis_type;
SELECT 
    t.user_id,
    u.full_name,
    t.availability_status,
    COUNT(ba.booking_appointment_id) as bookings_count
FROM therapists t
LEFT JOIN users u ON t.user_id = u.user_id
LEFT JOIN booking_appointments ba ON (
    t.user_id = ba.therapist_user_id 
    AND DATE(ba.start_time) = '2025-06-26'
    AND ba.status IN ('SCHEDULED', 'IN_PROGRESS')
)
GROUP BY t.user_id, u.full_name, t.availability_status
ORDER BY bookings_count DESC;

-- 6. Detailed analysis of therapist 1 (who has many bookings)
SELECT 'DETAILED ANALYSIS OF THERAPIST 1' as analysis_type;
SELECT 
    ba.booking_appointment_id,
    ba.booking_group_id,
    ba.service_id,
    s.name as service_name,
    ba.start_time,
    ba.end_time,
    TIMESTAMPDIFF(MINUTE, ba.start_time, ba.end_time) as duration_minutes,
    ba.status,
    ba.service_notes
FROM booking_appointments ba
LEFT JOIN services s ON ba.service_id = s.service_id
WHERE ba.therapist_user_id = 1 
  AND DATE(ba.start_time) = '2025-06-26'
ORDER BY ba.start_time;

-- 7. Check if the time 14:30 on 2025-06-26 should be blocked for therapist 1
SELECT 'TIME SLOT 14:30 CONFLICT CHECK FOR THERAPIST 1' as analysis_type;
SELECT 
    ba.booking_appointment_id,
    ba.start_time,
    ba.end_time,
    ba.status,
    s.name as service_name,
    CASE 
        WHEN ba.start_time <= '2025-06-26 14:30:00' AND ba.end_time > '2025-06-26 14:30:00' THEN 'BLOCKS 14:30'
        WHEN ba.start_time <= '2025-06-26 15:30:00' AND ba.end_time > '2025-06-26 14:30:00' THEN 'OVERLAPS WITH 14:30-15:30'
        ELSE 'NO CONFLICT'
    END as conflict_status
FROM booking_appointments ba
LEFT JOIN services s ON ba.service_id = s.service_id
WHERE ba.therapist_user_id = 1
  AND DATE(ba.start_time) = '2025-06-26'
  AND ba.status IN ('SCHEDULED', 'IN_PROGRESS')
  AND (
    -- Check for overlap with a hypothetical 14:30-15:30 appointment
    ba.start_time < '2025-06-26 15:30:00' AND ba.end_time > '2025-06-26 14:30:00'
  )
ORDER BY ba.start_time;

-- 8. Check database connection and table existence
SELECT 'DATABASE CONNECTION TEST' as analysis_type;
SELECT 
    COUNT(*) as total_bookings,
    COUNT(DISTINCT therapist_user_id) as unique_therapists,
    MIN(start_time) as earliest_booking,
    MAX(start_time) as latest_booking
FROM booking_appointments; 