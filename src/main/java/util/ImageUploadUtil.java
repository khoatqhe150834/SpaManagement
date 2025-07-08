package util;

import jakarta.servlet.http.Part;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.List;
import javax.imageio.ImageIO;

/**
 * Utility class for handling image uploads, validation, and processing
 * Provides comprehensive image management for the spa management system
 */
public class ImageUploadUtil {

    // Configuration constants
    public static final int MAX_FILE_SIZE = 2 * 1024 * 1024; // 2MB
    public static final Set<String> ALLOWED_EXTENSIONS = Set.of("jpg", "jpeg", "png", "webp");
    public static final Set<String> ALLOWED_MIME_TYPES = Set.of(
            "image/jpeg", "image/jpg", "image/png", "image/webp");

    // Thumbnail configuration
    public static final int THUMBNAIL_WIDTH = 300;
    public static final int THUMBNAIL_HEIGHT = 200;
    public static final int MIN_IMAGE_WIDTH = 150;
    public static final int MIN_IMAGE_HEIGHT = 150;

    // Directory paths (relative to webapp)
    public static final String UPLOADS_BASE_PATH = "/uploads/services";
    public static final String FULL_SIZE_PATH = UPLOADS_BASE_PATH + "/full-size";
    public static final String THUMBNAILS_PATH = UPLOADS_BASE_PATH + "/thumbnails";
    public static final String TEMP_PATH = UPLOADS_BASE_PATH + "/temp";

    /**
     * Validates an uploaded file
     */
    public static ValidationResult validateFile(Part filePart) {
        ValidationResult result = new ValidationResult();

        if (filePart == null || filePart.getSize() == 0) {
            result.addError("No file selected");
            return result;
        }

        // Check file size
        if (filePart.getSize() > MAX_FILE_SIZE) {
            result.addError("File size exceeds maximum limit of " + (MAX_FILE_SIZE / 1024 / 1024) + "MB");
        }

        // Check MIME type
        String contentType = filePart.getContentType();
        if (contentType == null || !ALLOWED_MIME_TYPES.contains(contentType.toLowerCase())) {
            result.addError("Invalid file type. Only JPG, PNG, and WebP files are allowed");
        }

        // Check file extension
        String fileName = getSubmittedFileName(filePart);
        if (fileName != null) {
            String extension = getFileExtension(fileName).toLowerCase();
            if (!ALLOWED_EXTENSIONS.contains(extension)) {
                result.addError(
                        "Invalid file extension. Only " + String.join(", ", ALLOWED_EXTENSIONS) + " are allowed");
            }
        } else {
            result.addError("Invalid file name");
        }

        return result;
    }

    /**
     * Validates image dimensions
     */
    public static ValidationResult validateImageDimensions(InputStream imageStream) {
        ValidationResult result = new ValidationResult();

        try {
            BufferedImage image = ImageIO.read(imageStream);
            if (image == null) {
                result.addError("Invalid image file");
                return result;
            }

            if (image.getWidth() < MIN_IMAGE_WIDTH || image.getHeight() < MIN_IMAGE_HEIGHT) {
                result.addError(
                        "Image dimensions must be at least " + MIN_IMAGE_WIDTH + "x" + MIN_IMAGE_HEIGHT + " pixels");
            }

        } catch (IOException e) {
            result.addError("Error reading image: " + e.getMessage());
        }

        return result;
    }

    /**
     * Generates a unique filename for a service image
     */
    public static String generateFileName(Integer serviceId, Integer imageId, String type, String originalFileName) {
        String extension = getFileExtension(originalFileName);
        return String.format("service_%d_%d_%s.%s", serviceId, imageId, type, extension);
    }

    /**
     * Generates a unique filename with timestamp for temporary files
     */
    public static String generateTempFileName(String originalFileName) {
        String extension = getFileExtension(originalFileName);
        String baseName = getFileNameWithoutExtension(originalFileName);
        return String.format("temp_%d_%s.%s", System.currentTimeMillis(), baseName, extension);
    }

    /**
     * Creates a thumbnail from an image
     */
    public static BufferedImage createThumbnail(BufferedImage originalImage) {
        int originalWidth = originalImage.getWidth();
        int originalHeight = originalImage.getHeight();

        // Calculate scaling to maintain aspect ratio
        double scaleX = (double) THUMBNAIL_WIDTH / originalWidth;
        double scaleY = (double) THUMBNAIL_HEIGHT / originalHeight;
        double scale = Math.min(scaleX, scaleY);

        int scaledWidth = (int) (originalWidth * scale);
        int scaledHeight = (int) (originalHeight * scale);

        // Create thumbnail with high quality scaling
        BufferedImage thumbnail = new BufferedImage(THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2d = thumbnail.createGraphics();

        // Set high quality rendering hints
        g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
        g2d.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);

        // Fill background with white
        g2d.setColor(Color.WHITE);
        g2d.fillRect(0, 0, THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT);

        // Center the scaled image
        int x = (THUMBNAIL_WIDTH - scaledWidth) / 2;
        int y = (THUMBNAIL_HEIGHT - scaledHeight) / 2;

        g2d.drawImage(originalImage, x, y, scaledWidth, scaledHeight, null);
        g2d.dispose();

        return thumbnail;
    }

    /**
     * Saves an image to the specified path
     */
    public static void saveImage(BufferedImage image, String filePath, String format) throws IOException {
        File outputFile = new File(filePath);
        System.out.println("ImageUploadUtil: Writing file to absolute path: " + outputFile.getAbsolutePath());
        outputFile.getParentFile().mkdirs(); // Create directories if they don't exist
        ImageIO.write(image, format, outputFile);
    }

    /**
     * Processes and saves both full-size and thumbnail versions of an image
     */
    public static ProcessedImageResult processAndSaveImage(Part filePart, String webappPath,
            Integer serviceId, Integer imageId) throws IOException {

        String originalFileName = getSubmittedFileName(filePart);
        String extension = getFileExtension(originalFileName);

        // Generate file names
        String fullSizeFileName = generateFileName(serviceId, imageId, "full", originalFileName);
        String thumbnailFileName = generateFileName(serviceId, imageId, "thumb", originalFileName);

        // Full paths
        String fullSizePath = webappPath + FULL_SIZE_PATH + "/" + fullSizeFileName;
        String thumbnailPath = webappPath + THUMBNAILS_PATH + "/" + thumbnailFileName;

        // Read original image
        BufferedImage originalImage = ImageIO.read(filePart.getInputStream());
        if (originalImage == null) {
            throw new IOException("Invalid image file");
        }

        // Save full-size image
        saveImage(originalImage, fullSizePath, extension);

        // Create and save thumbnail
        BufferedImage thumbnail = createThumbnail(originalImage);
        saveImage(thumbnail, thumbnailPath, extension);

        // Return result with relative URLs
        ProcessedImageResult result = new ProcessedImageResult();
        result.setFullSizeUrl(FULL_SIZE_PATH + "/" + fullSizeFileName);
        result.setThumbnailUrl(THUMBNAILS_PATH + "/" + thumbnailFileName);
        result.setFileName(fullSizeFileName);
        result.setFileSize((int) filePart.getSize());
        result.setWidth(originalImage.getWidth());
        result.setHeight(originalImage.getHeight());

        return result;
    }

    /**
     * Processes and saves ONLY the full-size version of an image, skipping
     * thumbnail creation.
     */
    public static ProcessedImageResult processAndSaveFullSizeImageOnly(Part filePart, String webappPath,
            Integer serviceId, Integer imageId) throws IOException {

        String originalFileName = getSubmittedFileName(filePart);
        String extension = getFileExtension(originalFileName);

        // Generate file name
        String fullSizeFileName = generateFileName(serviceId, imageId, "full", originalFileName);

        // Full path
        String fullSizePath = webappPath + FULL_SIZE_PATH + "/" + fullSizeFileName;
        System.out.println("ImageUploadUtil: Attempting to save to full path: " + fullSizePath);

        // Read original image
        BufferedImage originalImage = ImageIO.read(filePart.getInputStream());
        if (originalImage == null) {
            throw new IOException("Invalid image file");
        }

        // Save full-size image
        saveImage(originalImage, fullSizePath, extension);

        // Return result with relative URL
        ProcessedImageResult result = new ProcessedImageResult();
        result.setFullSizeUrl(FULL_SIZE_PATH + "/" + fullSizeFileName);
        result.setThumbnailUrl(null); // Explicitly set thumbnail to null
        result.setFileName(fullSizeFileName);
        result.setFileSize((int) filePart.getSize());
        result.setWidth(originalImage.getWidth());
        result.setHeight(originalImage.getHeight());

        return result;
    }

    /**
     * Ensures upload directories exist
     */
    public static void ensureDirectoriesExist(String webappPath) {
        String[] directories = {
                webappPath + FULL_SIZE_PATH,
                webappPath + THUMBNAILS_PATH,
                webappPath + TEMP_PATH
        };

        for (String dir : directories) {
            File directory = new File(dir);
            System.out.println("ImageUploadUtil: Checking directory: " + directory.getAbsolutePath());
            if (!directory.exists()) {
                boolean created = directory.mkdirs();
                System.out
                        .println("ImageUploadUtil: Directory did not exist. Attempting to create. Success: " + created);
            } else {
                System.out.println("ImageUploadUtil: Directory already exists.");
            }
        }
    }

    /**
     * Deletes image files (both full-size and thumbnail)
     */
    public static void deleteImageFiles(String webappPath, String imageUrl) {
        if (imageUrl == null || imageUrl.isEmpty())
            return;

        try {
            // Delete full-size image
            Path fullSizePath = Paths.get(webappPath + imageUrl);
            Files.deleteIfExists(fullSizePath);

            // Delete thumbnail (convert full-size URL to thumbnail URL)
            String thumbnailUrl = imageUrl.replace("/full-size/", "/thumbnails/")
                    .replace("_full.", "_thumb.");
            Path thumbnailPath = Paths.get(webappPath + thumbnailUrl);
            Files.deleteIfExists(thumbnailPath);

        } catch (IOException e) {
            System.err.println("Error deleting image files: " + e.getMessage());
        }
    }

    /**
     * Gets the submitted file name from a Part
     */
    public static String getSubmittedFileName(Part part) {
        if (part == null)
            return null;

        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition == null)
            return null;

        for (String token : contentDisposition.split(";")) {
            if (token.trim().startsWith("filename")) {
                String fileName = token.substring(token.indexOf("=") + 2, token.length() - 1);
                return fileName.isEmpty() ? null : fileName;
            }
        }
        return null;
    }

    /**
     * Gets file extension from filename
     */
    public static String getFileExtension(String fileName) {
        if (fileName == null || fileName.isEmpty())
            return "";
        int lastDotIndex = fileName.lastIndexOf('.');
        return lastDotIndex > 0 ? fileName.substring(lastDotIndex + 1) : "";
    }

    /**
     * Gets filename without extension
     */
    public static String getFileNameWithoutExtension(String fileName) {
        if (fileName == null || fileName.isEmpty())
            return "";
        int lastDotIndex = fileName.lastIndexOf('.');
        return lastDotIndex > 0 ? fileName.substring(0, lastDotIndex) : fileName;
    }

    /**
     * Validation result class
     */
    public static class ValidationResult {
        private final List<String> errors = new ArrayList<>();

        public void addError(String error) {
            errors.add(error);
        }

        public boolean isValid() {
            return errors.isEmpty();
        }

        public List<String> getErrors() {
            return new ArrayList<>(errors);
        }

        public String getErrorsAsString() {
            return String.join("; ", errors);
        }
    }

    /**
     * Processed image result class
     */
    public static class ProcessedImageResult {
        private String fullSizeUrl;
        private String thumbnailUrl;
        private String fileName;
        private int fileSize;
        private int width;
        private int height;

        // Getters and setters
        public String getFullSizeUrl() {
            return fullSizeUrl;
        }

        public void setFullSizeUrl(String fullSizeUrl) {
            this.fullSizeUrl = fullSizeUrl;
        }

        public String getThumbnailUrl() {
            return thumbnailUrl;
        }

        public void setThumbnailUrl(String thumbnailUrl) {
            this.thumbnailUrl = thumbnailUrl;
        }

        public String getFileName() {
            return fileName;
        }

        public void setFileName(String fileName) {
            this.fileName = fileName;
        }

        public int getFileSize() {
            return fileSize;
        }

        public void setFileSize(int fileSize) {
            this.fileSize = fileSize;
        }

        public int getWidth() {
            return width;
        }

        public void setWidth(int width) {
            this.width = width;
        }

        public int getHeight() {
            return height;
        }

        public void setHeight(int height) {
            this.height = height;
        }
    }
}
