-- Simple script to extend existing shopping_carts table for CartSession functionality
-- Run this in your spa_management database

-- Add expires_at column to shopping_carts table
ALTER TABLE shopping_carts 
ADD COLUMN expires_at TIMESTAMP NULL 
COMMENT 'Session expiration time for cookie-based carts';

-- Add index for expires_at for cleanup queries
ALTER TABLE shopping_carts 
ADD INDEX idx_expires_at (expires_at);

-- Update existing session_id column to be longer for UUID support
ALTER TABLE shopping_carts 
MODIFY COLUMN session_id VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL 
COMMENT 'UUID-based session ID for cookie-scoped carts';

-- Optional: Add a stored procedure to cleanup expired sessions
DELIMITER //
CREATE PROCEDURE CleanupExpiredCartSessions()
BEGIN
    DELETE FROM cart_items 
    WHERE cart_id IN (
        SELECT cart_id FROM shopping_carts 
        WHERE expires_at IS NOT NULL AND expires_at < NOW()
    );
    
    DELETE FROM shopping_carts 
    WHERE expires_at IS NOT NULL AND expires_at < NOW();
    
    SELECT ROW_COUNT() as deleted_sessions;
END //
DELIMITER ;

-- Add comment explaining enhanced functionality
ALTER TABLE shopping_carts 
COMMENT = 'Enhanced shopping carts table supporting both customer-based and session-based (cookie) carts with expiration.';

-- Sample query to check cart sessions
-- SELECT 
--     cart_id,
--     customer_id,
--     session_id,
--     status,
--     expires_at,
--     created_at,
--     updated_at,
--     (SELECT COUNT(*) FROM cart_items WHERE cart_id = shopping_carts.cart_id) as item_count
-- FROM shopping_carts 
-- WHERE (expires_at IS NULL OR expires_at > NOW())
-- ORDER BY updated_at DESC;

-- Sample update to set expiration for existing session-based carts
-- UPDATE shopping_carts 
-- SET expires_at = DATE_ADD(created_at, INTERVAL 30 DAY)
-- WHERE session_id IS NOT NULL AND expires_at IS NULL; 