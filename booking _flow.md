Flow of the spa booking process

1. User chooses a service
2. User chooses a therapist
3. User chooses a date and time slot
4. User is redirected to the payment page
5. User is redirected to the confirmation page
6. System send email to the user with the booking details with QR checkin code

7. System send notification to the therapist with the booking details
8. User can cancel the booking
9. User can reschedule the booking
10. User can view the booking details
11. User can view the booking history
12. User can view the booking status
13. User can view the booking details
14. User can view the booking history
15. User can view the booking status

State of the appointments

1. Created
2. Confirmed
3. Cancelled
4. Rescheduled
5. Completed
6. No-show

Use BookingController for booking process

With therapist selection, create a servlet to get therapist for each service user book in booking summary

### 3. Browser Storage (Client-Side)

Use localStorage/sessionStorage for immediate state recovery:

- Store booking steps completion status
- Store selected values for each step
- Validate against server session on page load

### 4. Implementation Strategy

Hybrid Approach (Pre-filter + Optimization):
Pre-compute a broader set of valid time slots (e.g., all slots where at least one qualified therapist is available), but use a CSP solver to optimize therapist assignments and refine the time slot list based on soft constraints.
How:
When the customer selects a service and day, generate a list of candidate time slots.
When the customer picks a time slot, solve a smaller CSP to assign a therapist, optimizing for preferences and workload balance.
If the customer doesn’t pick a time slot, suggest an optimal (therapist, time slot) pair.
Benefits:
Balances user-friendliness (pre-given slots) with optimization (CSP solving).
Can suggest “best” time slots based on preferences or therapist availability.
Example:
Customer selects physical therapy, June 25. System shows {2:00, 3:00, 4:00}.
Customer picks 3:00. CSP assigns Therapist1 (preferred) if available, or Therapist3 otherwise.
If no preference, CSP suggests 2:00 with Therapist3 to balance workload.

Batch Scheduling for Multiple Bookings:

If multiple customers book simultaneously or you’re scheduling for a whole day/week, solve a global CSP to assign all bookings at once.
How:

Define variables $ T_i, S_i $ for all bookings.
Apply all constraints (availability, no double-booking, etc.).
Optimize soft constraints (e.g., minimize gaps, balance workload).

Benefits:

Ensures globally optimal assignments (e.g., avoids overloading one therapist).
Can handle complex scenarios (e.g., multiple services, varying durations).

Drawback:

Computationally intensive for real-time use; better for offline scheduling.
beginning hour 8am - 8pm

-- 1. Get business hours for a day
SELECT open_time, close_time, is_closed
FROM business_hours
WHERE day_of_week = ?;

-- 2. Check therapist working schedule
SELECT ts.start_datetime, ts.end_datetime, ts.is_available
FROM therapist_schedules ts
WHERE ts.therapist_user_id = ?
AND ts.start_datetime <= ?
AND ts.end_datetime >= ?
AND ts.is_available = 1;

-- 3. Check conflicting appointments
SELECT ba.start_time, ba.end_time
FROM booking_appointments ba
WHERE ba.therapist_user_id = ?
AND ba.status IN ('SCHEDULED', 'IN_PROGRESS')
AND ba.start_time < ?
AND ba.end_time > ?;

-- 4. Get therapists qualified for a service
SELECT DISTINCT t.user_id, u.full_name, t.availability_status
FROM therapists t
JOIN users u ON t.user_id = u.user_id
JOIN services s ON t.service_type_id = s.service_type_id
WHERE s.service_id = ?
AND t.availability_status = 'AVAILABLE'
AND u.is_active = 1;

-- 5. Get all available time slots for a date (optimized query)
WITH RECURSIVE time_slots AS (
-- Base case: start with business opening time
SELECT
DATE(?) + INTERVAL HOUR(bh.open_time) HOUR + INTERVAL MINUTE(bh.open_time) MINUTE as slot_start,
? as target_date,
bh.close_time
FROM business_hours bh
WHERE bh.day_of_week = DAYNAME(?)

    UNION ALL

    -- Recursive case: add 30-minute intervals
    SELECT
        slot_start + INTERVAL 30 MINUTE,
        target_date,
        close_time
    FROM time_slots
    WHERE slot_start + INTERVAL 30 MINUTE <=
          DATE(target_date) + INTERVAL HOUR(close_time) HOUR + INTERVAL MINUTE(close_time) MINUTE

)
SELECT
slot_start,
slot_start + INTERVAL ? MINUTE as slot_end -- total duration of all services
FROM time_slots
WHERE slot_start + INTERVAL ? MINUTE <=
DATE(target_date) + INTERVAL HOUR(close_time) HOUR + INTERVAL MINUTE(close_time) MINUTE;

-- Find therapists available between 12:00 PM and 2:00 PM on 2025-06-23
SELECT
t.user_id as therapist_id,
u.full_name as therapist_name,
t.service_type_id,
t.availability_status,
COALESCE(AVG(ta.workload_balance_score), 0) as avg_workload_score,
COUNT(ta.assignment_id) as assignments_today
FROM therapists t
JOIN users u ON t.user_id = u.user_id
LEFT JOIN therapist_assignments ta ON ta.therapist_user_id = t.user_id
AND ta.assignment_date = '2025-06-23'
AND ta.assignment_status IN ('SCHEDULED', 'IN_PROGRESS')
WHERE t.availability_status = 'AVAILABLE'
-- Check if therapist is free during 12:00-14:00
AND NOT EXISTS (
SELECT 1 FROM therapist_assignments ta2
WHERE ta2.therapist_user_id = t.user_id
AND ta2.assignment_date = '2025-06-23'
AND ta2.assignment_status IN ('SCHEDULED', 'IN_PROGRESS')
AND (
-- Check if requested time overlaps with existing assignments
('12:00:00' < ta2.end_time AND '14:00:00' > ta2.start_time)
)
)
GROUP BY t.user_id, u.full_name, t.service_type_id, t.availability_status
ORDER BY avg_workload_score ASC, assignments_today ASC;

-- See complete schedule for 2025-06-23

SELECT
ta.start_time,
ta.end_time,
u.full_name as therapist_name,
s.name as service_name,
ta.estimated_duration_minutes,
ta.workload_balance_score,
ta.assignment_status,
ta.notes
FROM therapist_assignments ta
JOIN users u ON ta.therapist_user_id = u.user_id
JOIN services s ON ta.service_id = s.service_id
WHERE ta.assignment_date = '2025-06-23'
ORDER BY ta.start_time, u.full_name;
