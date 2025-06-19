# Test Appointments SQL Script

This file contains SQL commands to insert and subsequently delete test appointment data for a specific customer. This is useful for testing features that rely on a customer's booking history, such as the "Quick Select" options.

**Customer for Testing:**

- **Name:** Melanie Lancaster
- **Email:** quangkhoa5112@gmail.com
- **User ID:** 83
- **Customer ID:** 1 (Assuming the customer ID is 1 based on the provided user data. Please adjust if incorrect.)

---

## 1. Insert Test Data

Run these `INSERT` commands to add 5 test appointments for the customer. This will create a history where one therapist is booked most often, and another is the most recent.

```sql
-- Make sure to use the correct `customer_id` that corresponds to `user_id = 83`. We assume it's `1` here.
-- Therapist 12 is booked 3 times (most frequent).
-- Therapist 14 is booked last (most recent).

INSERT INTO `appointments`
(`customer_id`, `therapist_user_id`, `service_id`, `start_time`, `end_time`, `status`, `payment_status`, `original_service_price`, `final_price_after_discount`, `final_amount_payable`, `created_at`, `updated_at`)
VALUES
-- Appointment 1 (Most Booked Therapist), Service ID 1: 500,000
(1, 12, 1, '2024-05-10 10:00:00', '2024-05-10 11:00:00', 'COMPLETED', 'PAID', 500000.00, 500000.00, 500000.00, NOW(), NOW()),

-- Appointment 2 (Most Booked Therapist), Service ID 2: 700,000
(1, 12, 2, '2024-05-15 14:00:00', '2024-05-15 15:30:00', 'COMPLETED', 'PAID', 700000.00, 700000.00, 700000.00, NOW(), NOW()),

-- Appointment 3 (Most Booked Therapist), Service ID 1: 500,000
(1, 12, 1, '2024-05-20 09:00:00', '2024-05-20 10:00:00', 'COMPLETED', 'PAID', 500000.00, 500000.00, 500000.00, NOW(), NOW()),

-- Appointment 4 (Another Therapist), Service ID 3: 400,000
(1, 13, 3, '2024-05-25 11:00:00', '2024-05-25 12:00:00', 'COMPLETED', 'PAID', 400000.00, 400000.00, 400000.00, NOW(), NOW()),

-- Appointment 5 (Most Recent Therapist), Service ID 5: 450,000
(1, 14, 5, '2024-06-01 16:00:00', '2024-06-01 17:00:00', 'COMPLETED', 'PAID', 450000.00, 450000.00, 450000.00, NOW(), NOW());
```

---

## 2. Cleanup Test Data

Run this `DELETE` command to remove all the test appointments for the customer, cleaning up the database for other tests.

```sql
-- Use the same `customer_id` as you used for the inserts.
DELETE FROM `appointments` WHERE `customer_id` = 1;
```
