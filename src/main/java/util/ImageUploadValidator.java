package util;

import java.util.Arrays;
import java.util.List;

import jakarta.servlet.http.Part;

public class ImageUploadValidator {
    private static final List<String> ALLOWED_TYPES = Arrays.asList("image/jpeg", "image/png", "image/gif", "image/webp");
    private static final long MAX_SIZE = 2 * 1024 * 1024; // 2MB

    public static boolean isValidImage(Part filePart) {
        if (filePart == null || filePart.getSize() == 0) return false;
        String contentType = filePart.getContentType();
        if (!ALLOWED_TYPES.contains(contentType)) return false;
        if (filePart.getSize() > MAX_SIZE) return false;
        return true;
    }

    public static String getErrorMessage(Part filePart) {
        if (filePart == null || filePart.getSize() == 0) return "Vui lòng chọn ảnh.";
        String contentType = filePart.getContentType();
        if (!ALLOWED_TYPES.contains(contentType)) return "Chỉ chấp nhận JPG, PNG, GIF, WEBP.";
        if (filePart.getSize() > MAX_SIZE) return "Kích thước ảnh tối đa 2MB.";
        return null;
    }
} 