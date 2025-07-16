-- Database Update Script for Promotion System Enhancement
-- Run this script on your MySQL database

-- 1. Add customer_condition column to promotions table
ALTER TABLE promotions 
ADD COLUMN customer_condition VARCHAR(20) DEFAULT 'ALL' 
COMMENT 'Customer condition: ALL, INDIVIDUAL, COUPLE, GROUP';

-- 2. Update existing data with default value
UPDATE promotions 
SET customer_condition = 'ALL' 
WHERE customer_condition IS NULL;

-- 3. Add constraint to ensure valid values
ALTER TABLE promotions 
ADD CONSTRAINT chk_customer_condition 
CHECK (customer_condition IN ('ALL', 'INDIVIDUAL', 'COUPLE', 'GROUP'));

-- 4. Verify the table structure
DESCRIBE promotions;

-- 5. Sample data verification
SELECT promotion_id, title, promotion_code, customer_condition, status 
FROM promotions 
LIMIT 5; 
 
 