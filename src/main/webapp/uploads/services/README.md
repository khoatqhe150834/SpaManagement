# Service Images Directory Structure

This directory contains all service-related images for the Spa Management System.

## Directory Structure

```
services/
├── full-size/          # Original full-resolution images
├── thumbnails/         # Thumbnail versions (optimized for web display)
├── temp/              # Temporary storage for uploads before processing
└── README.md          # This documentation file
```

## Usage Guidelines

### Full-size Directory
- Contains original high-resolution service images
- Used for detailed views and printing
- Recommended max size: 2MB per image
- Supported formats: JPG, PNG, WebP

### Thumbnails Directory
- Contains optimized thumbnail versions
- Used for service listings and previews
- Recommended size: 300x200 pixels
- Optimized for fast web loading

### Temp Directory
- Temporary storage during upload process
- Files are moved to appropriate directories after validation
- Automatically cleaned up periodically

## File Naming Convention

Service images should follow this naming pattern:
- Full-size: `service_{serviceId}_{imageId}_full.{ext}`
- Thumbnail: `service_{serviceId}_{imageId}_thumb.{ext}`

Example:
- `service_1_1_full.jpg` (Full-size image for service ID 1, image ID 1)
- `service_1_1_thumb.jpg` (Thumbnail for service ID 1, image ID 1)

## Database Integration

Images are managed through the `service_images` table with the following key fields:
- `image_id`: Unique identifier for each image
- `service_id`: Links to the service this image belongs to
- `url`: Relative path to the image file
- `is_primary`: Indicates if this is the main image for the service
- `sort_order`: Display order for multiple images
- `is_active`: Whether the image is currently visible

## Security Considerations

- Only authenticated admin users should be able to upload images
- File types are validated before upload
- File sizes are limited to prevent abuse
- Directory permissions should be set appropriately
