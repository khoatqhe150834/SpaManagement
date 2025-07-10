# Service Images Directory

This directory contains all service-related images for the Spa Management System.

## Directory Structure

```
services/
├── service_*_*_full.jpg    # Full-size service images (saved directly here)
├── thumbnails/            # Thumbnail versions (if needed in future)
├── temp/                  # Temporary storage during upload
└── README.md             # This documentation file
```

## Current Implementation

As of the latest update, the system saves full-size images directly in the `/services/` directory without creating thumbnails. This simplifies the structure and focuses on storing high-quality service images.

## File Naming Convention

Service images follow this naming pattern:

- Full-size: `service_{serviceId}_{imageId}_full.{ext}`

Example:

- `service_1_1_full.jpg` (Full-size image for service ID 1, image ID 1)
- `service_15_3_full.png` (Full-size image for service ID 15, image ID 3)

## Usage Guidelines

### Image Requirements

- Maximum file size: 2MB per image
- Supported formats: JPG, JPEG, PNG, WebP
- Minimum dimensions: 150x150 pixels
- Recommended for web display and detailed views

### Upload Process

1. Images are uploaded via the admin interface
2. Files are validated for size, format, and dimensions
3. Images are saved directly to `/services/` directory
4. Database records are created in `service_images` table
5. URLs are stored as `/services/filename.ext`

## Database Integration

Images are managed through the `service_images` table:

- `image_id`: Unique identifier for each image
- `service_id`: Links to the service this image belongs to
- `url`: Relative path starting with `/services/`
- `is_primary`: Whether this is the main image for the service
- `sort_order`: Display order for multiple images
- `is_active`: Whether the image is currently visible

## Access

Images in this directory are directly accessible via web requests:

- URL pattern: `{contextPath}/services/service_{serviceId}_{imageId}_full.{ext}`
- Example: `/SpaManagement/services/service_1_1_full.jpg`

## Security Considerations

- Only authenticated admin users can upload images
- File types and sizes are validated before upload
- Directory permissions should be set appropriately for web access
