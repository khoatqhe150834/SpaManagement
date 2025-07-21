-- Create promotion_usage table for tracking customer promotion usage
-- This table tracks when customers use promotion codes and prevents misuse

DROP TABLE IF EXISTS `promotion_usage`;

CREATE TABLE `promotion_usage` (
  `usage_id` int NOT NULL AUTO_INCREMENT,
  `promotion_id` int NOT NULL,
  `customer_id` int NOT NULL,
  `payment_id` int DEFAULT NULL COMMENT 'Liên kết với payment khi áp dụng mã',
  `booking_id` int DEFAULT NULL COMMENT 'Liên kết với booking khi áp dụng mã',
  `discount_amount` decimal(10,2) NOT NULL COMMENT 'Số tiền thực tế được giảm',
  `original_amount` decimal(10,2) NOT NULL COMMENT 'Số tiền gốc trước khi giảm',
  `final_amount` decimal(10,2) NOT NULL COMMENT 'Số tiền cuối cùng sau khi giảm',
  `used_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  PRIMARY KEY (`usage_id`),
  
  -- Unique constraint: one promotion per customer per payment (prevent duplicate usage)
  UNIQUE KEY `uk_promotion_customer_payment` (`promotion_id`,`customer_id`,`payment_id`),
  
  -- Indexes for performance
  KEY `idx_customer_promotions` (`customer_id`,`used_at`),
  KEY `idx_promotion_usage` (`promotion_id`,`used_at`),
  KEY `fk_promotion_usage_payment` (`payment_id`),
  KEY `fk_promotion_usage_booking` (`booking_id`),
  
  -- Foreign key constraints
  CONSTRAINT `fk_promotion_usage_promotion` FOREIGN KEY (`promotion_id`) REFERENCES `promotions` (`promotion_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_promotion_usage_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_promotion_usage_payment` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`payment_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_promotion_usage_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE SET NULL,
  
  -- Check constraints
  CONSTRAINT `chk_discount_amount_positive` CHECK (`discount_amount` >= 0),
  CONSTRAINT `chk_original_amount_positive` CHECK (`original_amount` > 0),
  CONSTRAINT `chk_final_amount_non_negative` CHECK (`final_amount` >= 0),
  CONSTRAINT `chk_discount_not_exceed_original` CHECK (`discount_amount` <= `original_amount`)
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create indexes for better query performance
CREATE INDEX `idx_promotion_usage_date_range` ON `promotion_usage` (`promotion_id`, `used_at`);
CREATE INDEX `idx_customer_usage_history` ON `promotion_usage` (`customer_id`, `used_at` DESC);

-- Insert sample data for testing (optional - remove in production)
-- INSERT INTO `promotion_usage` (`promotion_id`, `customer_id`, `payment_id`, `discount_amount`, `original_amount`, `final_amount`) 
-- VALUES 
-- (1, 1, NULL, 20000.00, 100000.00, 80000.00),
-- (2, 2, NULL, 100000.00, 1200000.00, 1100000.00);

-- Verify table creation
DESCRIBE `promotion_usage`;
SHOW CREATE TABLE `promotion_usage`;

-- Optional: Create a view for promotion usage statistics
CREATE OR REPLACE VIEW `v_promotion_usage_stats` AS
SELECT 
    p.promotion_id,
    p.title,
    p.promotion_code,
    p.discount_type,
    p.discount_value,
    COUNT(pu.usage_id) as total_usage_count,
    SUM(pu.discount_amount) as total_discount_given,
    AVG(pu.discount_amount) as avg_discount_amount,
    COUNT(DISTINCT pu.customer_id) as unique_customers,
    MIN(pu.used_at) as first_used_date,
    MAX(pu.used_at) as last_used_date
FROM promotions p
LEFT JOIN promotion_usage pu ON p.promotion_id = pu.promotion_id
GROUP BY p.promotion_id, p.title, p.promotion_code, p.discount_type, p.discount_value
ORDER BY total_usage_count DESC; 
 
 