-- Create Promotions Table for Spa Management System
-- This table stores all promotion/discount information

USE [G1_SpaManagement]
GO

-- Drop table if exists (for recreation)
IF OBJECT_ID('dbo.promotions', 'U') IS NOT NULL
    DROP TABLE dbo.promotions;
GO

CREATE TABLE promotions (
    promotion_id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    promotion_code NVARCHAR(50) NOT NULL UNIQUE,
    discount_type NVARCHAR(20) NOT NULL CHECK (discount_type IN ('percentage', 'fixed')),
    discount_value DECIMAL(10,2) NOT NULL CHECK (discount_value > 0),
    applies_to_service_id INT NULL,
    minimum_appointment_value DECIMAL(10,2) NULL,
    start_date DATETIME NULL,
    end_date DATETIME NULL,
    status NVARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'expired', 'upcoming')),
    usage_limit_per_customer INT NULL CHECK (usage_limit_per_customer > 0),
    total_usage_limit INT NULL CHECK (total_usage_limit > 0),
    current_usage_count INT NOT NULL DEFAULT 0 CHECK (current_usage_count >= 0),
    applicable_scope NVARCHAR(50) NULL CHECK (applicable_scope IN ('all', 'specific', 'category')),
    applicable_service_ids_json NVARCHAR(MAX) NULL,
    image_url NVARCHAR(500) NULL,
    terms_and_conditions NVARCHAR(MAX) NULL,
    created_by_user_id INT NULL,
    is_auto_apply BIT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Create indexes for better performance
CREATE INDEX IX_promotions_promotion_code ON promotions(promotion_code);
CREATE INDEX IX_promotions_status ON promotions(status);
CREATE INDEX IX_promotions_start_date ON promotions(start_date);
CREATE INDEX IX_promotions_end_date ON promotions(end_date);
CREATE INDEX IX_promotions_created_at ON promotions(created_at);
GO

-- Create trigger to automatically update updated_at column
CREATE TRIGGER TR_promotions_updated_at
ON promotions
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE promotions 
    SET updated_at = GETDATE()
    FROM promotions p
    INNER JOIN inserted i ON p.promotion_id = i.promotion_id;
END;
GO

-- Insert sample data for testing
INSERT INTO promotions (
    title, description, promotion_code, discount_type, discount_value,
    minimum_appointment_value, start_date, end_date, status,
    usage_limit_per_customer, total_usage_limit, applicable_scope,
    terms_and_conditions, is_auto_apply
) VALUES 
(
    'Welcome New Customer',
    'Special discount for first-time customers',
    'WELCOME20',
    'percentage',
    20.00,
    100.00,
    GETDATE(),
    DATEADD(MONTH, 3, GETDATE()),
    'active',
    1,
    100,
    'all',
    'This promotion is valid for first-time customers only. Cannot be combined with other offers.',
    1
),
(
    'Summer Spa Special',
    'Cool down with our refreshing summer treatments',
    'SUMMER30',
    'percentage',
    30.00,
    150.00,
    GETDATE(),
    DATEADD(MONTH, 2, GETDATE()),
    'active',
    3,
    200,
    'specific',
    'Valid for selected spa treatments only. See terms and conditions for eligible services.',
    0
),
(
    'Fixed Discount $50',
    'Get $50 off on any service package',
    'SAVE50',
    'fixed',
    50.00,
    200.00,
    GETDATE(),
    DATEADD(MONTH, 1, GETDATE()),
    'active',
    2,
    50,
    'all',
    'Minimum purchase of $200 required. Valid until supplies last.',
    0
),
(
    'VIP Member Exclusive',
    'Exclusive offer for our VIP members',
    'VIP15',
    'percentage',
    15.00,
    NULL,
    DATEADD(DAY, 7, GETDATE()),
    DATEADD(MONTH, 6, GETDATE()),
    'upcoming',
    NULL,
    NULL,
    'all',
    'VIP membership required. Cannot be combined with other promotions.',
    1
),
(
    'Holiday Season Discount',
    'Last year holiday promotion (expired)',
    'HOLIDAY25',
    'percentage',
    25.00,
    120.00,
    DATEADD(MONTH, -6, GETDATE()),
    DATEADD(MONTH, -3, GETDATE()),
    'expired',
    2,
    300,
    'all',
    'This promotion has expired and is no longer valid.',
    0
);
GO

-- Display created table structure
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'promotions'
ORDER BY ORDINAL_POSITION;
GO

-- Display sample data
SELECT 
    promotion_id,
    title,
    promotion_code,
    discount_type,
    discount_value,
    status,
    created_at
FROM promotions
ORDER BY created_at DESC;
GO

PRINT 'Promotions table created successfully with sample data!'; 