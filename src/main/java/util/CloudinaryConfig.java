package util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.ServletContext;
import java.io.IOException;
import java.util.Map;

/**
 * Utility class for Cloudinary configuration and operations
 */
public class CloudinaryConfig {
    private static Cloudinary cloudinary;
    
    /**
     * Initialize Cloudinary with configuration parameters
     * 
     * @param cloudName Cloudinary cloud name
     * @param apiKey Cloudinary API key
     * @param apiSecret Cloudinary API secret
     */
    public static void init(String cloudName, String apiKey, String apiSecret) {
        if (cloudinary == null) {
            cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", cloudName,
                "api_key", apiKey,
                "api_secret", apiSecret,
                "secure", true
            ));
        }
    }
    
    /**
     * Initialize Cloudinary from ServletContext parameters
     * 
     * @param context ServletContext containing Cloudinary configuration parameters
     */
    public static void init(ServletContext context) {
        String cloudName = context.getInitParameter("cloudinary.cloud_name");
        String apiKey = context.getInitParameter("cloudinary.api_key");
        String apiSecret = context.getInitParameter("cloudinary.api_secret");
        
        init(cloudName, apiKey, apiSecret);
    }
    
    /**
     * Upload an image to Cloudinary
     * 
     * @param fileBytes Image file as byte array
     * @param publicId Public ID for the image (optional)
     * @return Map containing upload result information
     * @throws IOException If upload fails
     */
    @SuppressWarnings("unchecked")
    public static Map<String, Object> uploadImage(byte[] fileBytes, String publicId) throws IOException {
        if (cloudinary == null) {
            throw new IllegalStateException("Cloudinary not initialized. Call init() first.");
        }
        
        Map<String, Object> params = ObjectUtils.asMap(
            "public_id", publicId,
            "overwrite", true,
            "resource_type", "image"
        );
        
        return cloudinary.uploader().upload(fileBytes, params);
    }
    
    /**
     * Delete an image from Cloudinary by its URL
     */
    public static void deleteImageByUrl(String url) throws IOException {
        if (cloudinary == null) {
            throw new IllegalStateException("Cloudinary not initialized. Call init() first.");
        }
        if (url == null || !url.contains("cloudinary.com")) return;
        // Parse publicId from URL
        // Example: https://res.cloudinary.com/demo/image/upload/v1234567890/services/123/abcxyz.png
        // publicId = services/123/abcxyz (không có đuôi .png)
        String[] parts = url.split("/upload/");
        if (parts.length < 2) return;
        String afterUpload = parts[1];
        int dotIdx = afterUpload.lastIndexOf('.');
        String publicId = (dotIdx > 0) ? afterUpload.substring(0, dotIdx) : afterUpload;
        cloudinary.uploader().destroy(publicId, ObjectUtils.emptyMap());
    }
    
    /**
     * Get the Cloudinary instance
     * 
     * @return Cloudinary instance
     */
    public static Cloudinary getCloudinary() {
        if (cloudinary == null) {
            throw new IllegalStateException("Cloudinary not initialized. Call init() first.");
        }
        return cloudinary;
    }
}
