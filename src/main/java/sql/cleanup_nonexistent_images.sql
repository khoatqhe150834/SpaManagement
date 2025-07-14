-- Cleanup script to remove service_images entries for non-existent files
-- This will allow the frontend to fall back to placeholder images

USE `spamanagement`;

-- Remove all entries from service_images table since the actual image files don't exist
-- This will make the frontend fall back to the beautyImages placeholders
DELETE FROM service_images WHERE url LIKE '/uploads/services/full-size/%';

-- Also clear the image_url field in services table for entries that referenced non-existent images
UPDATE services 
SET image_url = NULL 
WHERE image_url LIKE '/uploads/services/full-size/%';

-- Verify the cleanup
SELECT 'Service images after cleanup:' as status;
SELECT COUNT(*) as remaining_service_images FROM service_images;

SELECT 'Services with image_url after cleanup:' as status;
SELECT COUNT(*) as services_with_image_url FROM services WHERE image_url IS NOT NULL AND image_url != '';

-- Show a few services to verify they'll use placeholder images
SELECT service_id, name, image_url FROM services LIMIT 10; 