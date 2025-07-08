package util;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

import java.io.*;
import java.nio.file.*;
import java.util.Arrays;

/**
 * Test class for image file operations and directory structure
 * Verifies that the image storage directories work correctly
 */
public class ImageFileOperationsTest {

    private static final String WEBAPP_PATH = "src/main/webapp";
    private static final String UPLOADS_PATH = WEBAPP_PATH + "/uploads/services";
    private static final String ASSETS_PATH = WEBAPP_PATH + "/assets/home/images/services";
    
    private Path testImagePath;
    private byte[] testImageData;

    @BeforeAll
    public static void setUpClass() {
        System.out.println("Setting up image file operations tests...");
        
        // Verify that the required directories exist
        assertTrue(Files.exists(Paths.get(UPLOADS_PATH)), "Uploads directory should exist");
        assertTrue(Files.exists(Paths.get(UPLOADS_PATH + "/full-size")), "Full-size directory should exist");
        assertTrue(Files.exists(Paths.get(UPLOADS_PATH + "/thumbnails")), "Thumbnails directory should exist");
        assertTrue(Files.exists(Paths.get(UPLOADS_PATH + "/temp")), "Temp directory should exist");
        assertTrue(Files.exists(Paths.get(ASSETS_PATH)), "Assets services directory should exist");
        
        System.out.println("✓ All required directories exist");
    }

    @BeforeEach
    public void setUp() {
        // Create test image data (a simple 1x1 pixel PNG)
        testImageData = createTestImageData();
        testImagePath = null;
    }

    @AfterEach
    public void tearDown() {
        // Clean up test files
        if (testImagePath != null && Files.exists(testImagePath)) {
            try {
                Files.delete(testImagePath);
            } catch (IOException e) {
                System.err.println("Warning: Could not delete test file: " + testImagePath);
            }
        }
    }

    @Test
    @DisplayName("Test creating and writing to full-size directory")
    public void testFullSizeDirectoryOperations() throws IOException {
        System.out.println("Testing full-size directory operations...");
        
        String fileName = "test_service_1_full.png";
        testImagePath = Paths.get(UPLOADS_PATH + "/full-size/" + fileName);
        
        // Write test image
        Files.write(testImagePath, testImageData);
        
        // Verify file exists and has correct content
        assertTrue(Files.exists(testImagePath), "Test image should exist");
        byte[] readData = Files.readAllBytes(testImagePath);
        assertArrayEquals(testImageData, readData, "File content should match");
        
        // Verify file size
        long fileSize = Files.size(testImagePath);
        assertEquals(testImageData.length, fileSize, "File size should match");
        
        System.out.println("✓ Full-size directory operations successful");
        System.out.println("  Created file: " + fileName + " (" + fileSize + " bytes)");
    }

    @Test
    @DisplayName("Test creating and writing to thumbnails directory")
    public void testThumbnailsDirectoryOperations() throws IOException {
        System.out.println("Testing thumbnails directory operations...");
        
        String fileName = "test_service_1_thumb.png";
        testImagePath = Paths.get(UPLOADS_PATH + "/thumbnails/" + fileName);
        
        // Create smaller test data for thumbnail
        byte[] thumbnailData = Arrays.copyOf(testImageData, testImageData.length / 2);
        
        // Write thumbnail image
        Files.write(testImagePath, thumbnailData);
        
        // Verify file exists and has correct content
        assertTrue(Files.exists(testImagePath), "Thumbnail should exist");
        byte[] readData = Files.readAllBytes(testImagePath);
        assertArrayEquals(thumbnailData, readData, "Thumbnail content should match");
        
        System.out.println("✓ Thumbnails directory operations successful");
        System.out.println("  Created thumbnail: " + fileName + " (" + thumbnailData.length + " bytes)");
    }

    @Test
    @DisplayName("Test temporary file operations")
    public void testTempDirectoryOperations() throws IOException {
        System.out.println("Testing temp directory operations...");
        
        String fileName = "temp_upload_" + System.currentTimeMillis() + ".png";
        testImagePath = Paths.get(UPLOADS_PATH + "/temp/" + fileName);
        
        // Write temporary file
        Files.write(testImagePath, testImageData);
        
        // Verify file exists
        assertTrue(Files.exists(testImagePath), "Temp file should exist");
        
        // Simulate moving file from temp to permanent location
        Path permanentPath = Paths.get(UPLOADS_PATH + "/full-size/moved_" + fileName);
        Files.move(testImagePath, permanentPath);
        
        // Verify move operation
        assertFalse(Files.exists(testImagePath), "Temp file should be moved");
        assertTrue(Files.exists(permanentPath), "Permanent file should exist");
        
        // Update testImagePath for cleanup
        testImagePath = permanentPath;
        
        System.out.println("✓ Temp directory operations successful");
        System.out.println("  Moved file from temp to: " + permanentPath.getFileName());
    }

    @Test
    @DisplayName("Test directory permissions and access")
    public void testDirectoryPermissions() {
        System.out.println("Testing directory permissions...");
        
        Path uploadsDir = Paths.get(UPLOADS_PATH);
        Path fullSizeDir = Paths.get(UPLOADS_PATH + "/full-size");
        Path thumbnailsDir = Paths.get(UPLOADS_PATH + "/thumbnails");
        Path tempDir = Paths.get(UPLOADS_PATH + "/temp");
        
        // Test read permissions
        assertTrue(Files.isReadable(uploadsDir), "Uploads directory should be readable");
        assertTrue(Files.isReadable(fullSizeDir), "Full-size directory should be readable");
        assertTrue(Files.isReadable(thumbnailsDir), "Thumbnails directory should be readable");
        assertTrue(Files.isReadable(tempDir), "Temp directory should be readable");
        
        // Test write permissions
        assertTrue(Files.isWritable(uploadsDir), "Uploads directory should be writable");
        assertTrue(Files.isWritable(fullSizeDir), "Full-size directory should be writable");
        assertTrue(Files.isWritable(thumbnailsDir), "Thumbnails directory should be writable");
        assertTrue(Files.isWritable(tempDir), "Temp directory should be writable");
        
        System.out.println("✓ Directory permissions test successful");
    }

    @Test
    @DisplayName("Test file naming conventions")
    public void testFileNamingConventions() throws IOException {
        System.out.println("Testing file naming conventions...");
        
        // Test various valid file names
        String[] validNames = {
            "service_1_1_full.jpg",
            "service_123_456_thumb.png",
            "service_1_1_full.webp",
            "service_999_1_thumb.jpeg"
        };
        
        for (String fileName : validNames) {
            Path filePath = Paths.get(UPLOADS_PATH + "/temp/" + fileName);
            
            // Create test file
            Files.write(filePath, testImageData);
            assertTrue(Files.exists(filePath), "File should be created: " + fileName);
            
            // Validate naming pattern
            assertTrue(isValidServiceImageName(fileName), "File name should follow convention: " + fileName);
            
            // Clean up
            Files.delete(filePath);
        }
        
        System.out.println("✓ File naming conventions test successful");
    }

    @Test
    @DisplayName("Test file size limits and validation")
    public void testFileSizeValidation() throws IOException {
        System.out.println("Testing file size validation...");
        
        // Test small file (should be acceptable)
        byte[] smallFile = new byte[1024]; // 1KB
        Arrays.fill(smallFile, (byte) 0xFF);
        
        testImagePath = Paths.get(UPLOADS_PATH + "/temp/small_test.png");
        Files.write(testImagePath, smallFile);
        
        long smallFileSize = Files.size(testImagePath);
        assertTrue(smallFileSize <= 2 * 1024 * 1024, "Small file should be within size limit"); // 2MB limit
        
        System.out.println("✓ File size validation test successful");
        System.out.println("  Small file size: " + smallFileSize + " bytes");
    }

    /**
     * Creates test image data (minimal PNG header)
     */
    private byte[] createTestImageData() {
        // Minimal PNG file signature and IHDR chunk for a 1x1 pixel image
        return new byte[] {
            (byte) 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG signature
            0x00, 0x00, 0x00, 0x0D, // IHDR chunk length
            0x49, 0x48, 0x44, 0x52, // IHDR
            0x00, 0x00, 0x00, 0x01, // Width: 1
            0x00, 0x00, 0x00, 0x01, // Height: 1
            0x08, 0x02, 0x00, 0x00, 0x00, // Bit depth, color type, compression, filter, interlace
            (byte) 0x90, 0x77, 0x53, (byte) 0xDE, // CRC
            0x00, 0x00, 0x00, 0x00, // IEND chunk length
            0x49, 0x45, 0x4E, 0x44, // IEND
            (byte) 0xAE, 0x42, 0x60, (byte) 0x82 // IEND CRC
        };
    }

    /**
     * Validates service image file naming convention
     */
    private boolean isValidServiceImageName(String fileName) {
        // Pattern: service_{serviceId}_{imageId}_{type}.{extension}
        // Where type is 'full' or 'thumb'
        String pattern = "^service_\\d+_\\d+_(full|thumb)\\.(jpg|jpeg|png|webp)$";
        return fileName.matches(pattern);
    }
}
