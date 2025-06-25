-- Check what bookings exist on 2025-06-26 that cause availability conflicts
-- This will help explain why day 26 shows as red (fully booked)

SELECT 
    'Existing Bookings on 2025-06-26' as analysis_type,
    ba.booking_appointment_id,
    ba.service_id,
    s.name as service_name,
    s.service_type_id,
    st.name as service_type_name,
    ba.therapist_user_id,
    u.full_name as therapist_name,
    ba.start_time,
    ba.end_time,
    ba.status
FROM booking_appointments ba
JOIN services s ON ba.service_id = s.service_id
JOIN service_types st ON s.service_type_id = st.service_type_id
JOIN users u ON ba.therapist_user_id = u.user_id
WHERE DATE(ba.start_time) = '2025-06-26'
ORDER BY ba.start_time;

-- Show therapist availability by service type
SELECT 
    'Therapist Availability by Service Type' as analysis_type,
    t.service_type_id,
    st.name as service_type_name,
    COUNT(*) as total_therapists,
    SUM(CASE WHEN t.availability_status = 'AVAILABLE' THEN 1 ELSE 0 END) as available_therapists,
    GROUP_CONCAT(CONCAT(u.full_name, ':', t.availability_status)) as therapist_details
FROM therapists t
JOIN service_types st ON t.service_type_id = st.service_type_id
JOIN users u ON t.user_id = u.user_id
GROUP BY t.service_type_id, st.name
ORDER BY t.service_type_id;

-- Check if any therapists have multiple bookings on day 26 (causing bottlenecks)
SELECT 
    'Therapist Workload on 2025-06-26' as analysis_type,
    ba.therapist_user_id,
    u.full_name as therapist_name,
    t.service_type_id,
    st.name as therapist_specialty,
    COUNT(*) as bookings_count,
    GROUP_CONCAT(CONCAT(TIME(ba.start_time), '-', TIME(ba.end_time))) as time_slots
FROM booking_appointments ba
JOIN users u ON ba.therapist_user_id = u.user_id
JOIN therapists t ON ba.therapist_user_id = t.user_id
JOIN service_types st ON t.service_type_id = st.service_type_id
WHERE DATE(ba.start_time) = '2025-06-26'
GROUP BY ba.therapist_user_id, u.full_name, t.service_type_id, st.name
ORDER BY bookings_count DESC, t.service_type_id; 