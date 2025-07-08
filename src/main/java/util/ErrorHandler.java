package util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.JsonObject;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Comprehensive error handling utility for the spa management system
 * Provides consistent error responses and user-friendly error messages
 */
public class ErrorHandler {
    
    private static final Logger LOGGER = Logger.getLogger(ErrorHandler.class.getName());
    
    // Error codes for different types of errors
    public static final String ERROR_FILE_TOO_LARGE = "FILE_TOO_LARGE";
    public static final String ERROR_INVALID_FILE_TYPE = "INVALID_FILE_TYPE";
    public static final String ERROR_INVALID_DIMENSIONS = "INVALID_DIMENSIONS";
    public static final String ERROR_SERVICE_NOT_FOUND = "SERVICE_NOT_FOUND";
    public static final String ERROR_IMAGE_NOT_FOUND = "IMAGE_NOT_FOUND";
    public static final String ERROR_UPLOAD_FAILED = "UPLOAD_FAILED";
    public static final String ERROR_PROCESSING_FAILED = "PROCESSING_FAILED";
    public static final String ERROR_DATABASE_ERROR = "DATABASE_ERROR";
    public static final String ERROR_PERMISSION_DENIED = "PERMISSION_DENIED";
    public static final String ERROR_INVALID_REQUEST = "INVALID_REQUEST";
    public static final String ERROR_NETWORK_ERROR = "NETWORK_ERROR";
    
    /**
     * Gets user-friendly error message for error codes
     */
    public static String getUserFriendlyMessage(String errorCode) {
        switch (errorCode) {
            case ERROR_FILE_TOO_LARGE:
                return "File size is too large. Maximum allowed size is 2MB per file.";
            case ERROR_INVALID_FILE_TYPE:
                return "Invalid file type. Only JPG, PNG, and WebP images are allowed.";
            case ERROR_INVALID_DIMENSIONS:
                return "Image dimensions are too small. Minimum size is 150x150 pixels.";
            case ERROR_SERVICE_NOT_FOUND:
                return "The selected service could not be found. Please refresh the page and try again.";
            case ERROR_IMAGE_NOT_FOUND:
                return "The image could not be found. It may have been deleted already.";
            case ERROR_UPLOAD_FAILED:
                return "Upload failed due to a server error. Please try again.";
            case ERROR_PROCESSING_FAILED:
                return "Image processing failed. Please check the file and try again.";
            case ERROR_DATABASE_ERROR:
                return "A database error occurred. Please try again later.";
            case ERROR_PERMISSION_DENIED:
                return "You don't have permission to perform this action.";
            case ERROR_INVALID_REQUEST:
                return "Invalid request. Please check your input and try again.";
            case ERROR_NETWORK_ERROR:
                return "Network error occurred. Please check your connection and try again.";
            default:
                return "An unexpected error occurred. Please try again.";
        }
    }
    
    /**
     * Sends a JSON error response
     */
    public static void sendJsonError(HttpServletResponse response, String errorCode, String customMessage) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        
        JsonObject error = new JsonObject();
        error.addProperty("success", false);
        error.addProperty("errorCode", errorCode);
        error.addProperty("error", customMessage != null ? customMessage : getUserFriendlyMessage(errorCode));
        
        PrintWriter out = response.getWriter();
        out.print(error.toString());
        out.flush();
    }
    
    /**
     * Sends a JSON error response with default message
     */
    public static void sendJsonError(HttpServletResponse response, String errorCode) throws IOException {
        sendJsonError(response, errorCode, null);
    }
    
    /**
     * Logs and sends error response
     */
    public static void logAndSendError(HttpServletResponse response, String errorCode, 
                                     String logMessage, Exception exception) throws IOException {
        LOGGER.log(Level.SEVERE, logMessage, exception);
        sendJsonError(response, errorCode);
    }
    
    /**
     * Creates a standardized error response object
     */
    public static JsonObject createErrorResponse(String errorCode, String customMessage) {
        JsonObject error = new JsonObject();
        error.addProperty("success", false);
        error.addProperty("errorCode", errorCode);
        error.addProperty("error", customMessage != null ? customMessage : getUserFriendlyMessage(errorCode));
        return error;
    }
    
    /**
     * Creates a standardized success response object
     */
    public static JsonObject createSuccessResponse(String message) {
        JsonObject success = new JsonObject();
        success.addProperty("success", true);
        success.addProperty("message", message);
        return success;
    }
    
    /**
     * Handles file validation errors
     */
    public static JsonObject handleFileValidationError(ImageUploadUtil.ValidationResult validation, String fileName) {
        JsonObject result = new JsonObject();
        result.addProperty("success", false);
        result.addProperty("fileName", fileName);
        
        String errors = validation.getErrorsAsString();
        
        // Determine error code based on error message
        String errorCode = ERROR_INVALID_REQUEST;
        if (errors.contains("File size exceeds")) {
            errorCode = ERROR_FILE_TOO_LARGE;
        } else if (errors.contains("Invalid file type") || errors.contains("Invalid file extension")) {
            errorCode = ERROR_INVALID_FILE_TYPE;
        } else if (errors.contains("Image dimensions")) {
            errorCode = ERROR_INVALID_DIMENSIONS;
        }
        
        result.addProperty("errorCode", errorCode);
        result.addProperty("error", getUserFriendlyMessage(errorCode));
        result.addProperty("details", errors);
        
        return result;
    }
    
    /**
     * Handles upload processing errors
     */
    public static JsonObject handleUploadError(Exception exception, String fileName) {
        JsonObject result = new JsonObject();
        result.addProperty("success", false);
        result.addProperty("fileName", fileName);
        
        String errorCode = ERROR_PROCESSING_FAILED;
        String message = exception.getMessage();
        
        // Determine specific error code based on exception
        if (exception instanceof java.io.IOException) {
            if (message != null && message.contains("Invalid image")) {
                errorCode = ERROR_INVALID_FILE_TYPE;
            } else {
                errorCode = ERROR_UPLOAD_FAILED;
            }
        } else if (exception instanceof java.sql.SQLException) {
            errorCode = ERROR_DATABASE_ERROR;
        }
        
        result.addProperty("errorCode", errorCode);
        result.addProperty("error", getUserFriendlyMessage(errorCode));
        
        // Log the actual exception for debugging
        LOGGER.log(Level.SEVERE, "Upload error for file: " + fileName, exception);
        
        return result;
    }
    
    /**
     * Validates request parameters and returns error if invalid
     */
    public static JsonObject validateRequiredParameter(String paramValue, String paramName) {
        if (paramValue == null || paramValue.trim().isEmpty()) {
            return createErrorResponse(ERROR_INVALID_REQUEST, 
                paramName + " is required and cannot be empty");
        }
        return null; // No error
    }
    
    /**
     * Validates numeric parameter
     */
    public static JsonObject validateNumericParameter(String paramValue, String paramName) {
        JsonObject requiredError = validateRequiredParameter(paramValue, paramName);
        if (requiredError != null) return requiredError;
        
        try {
            Integer.parseInt(paramValue);
            return null; // No error
        } catch (NumberFormatException e) {
            return createErrorResponse(ERROR_INVALID_REQUEST, 
                paramName + " must be a valid number");
        }
    }
    
    /**
     * Handles batch upload errors with summary
     */
    public static JsonObject createBatchErrorSummary(int totalFiles, int successCount, int errorCount) {
        JsonObject summary = new JsonObject();
        summary.addProperty("success", errorCount == 0);
        summary.addProperty("totalFiles", totalFiles);
        summary.addProperty("successCount", successCount);
        summary.addProperty("errorCount", errorCount);
        
        if (errorCount == 0) {
            summary.addProperty("message", "All files uploaded successfully!");
        } else if (successCount == 0) {
            summary.addProperty("message", "All uploads failed. Please check your files and try again.");
        } else {
            summary.addProperty("message", 
                String.format("Batch upload completed: %d successful, %d failed", successCount, errorCount));
        }
        
        return summary;
    }
    
    /**
     * Redirects to error page with message
     */
    public static void redirectToErrorPage(HttpServletRequest request, HttpServletResponse response, 
                                         String errorMessage) throws IOException {
        request.getSession().setAttribute("errorMessage", errorMessage);
        response.sendRedirect(request.getContextPath() + "/error");
    }
    
    /**
     * Sets error message in session for display on next page
     */
    public static void setErrorMessage(HttpServletRequest request, String errorCode, String customMessage) {
        String message = customMessage != null ? customMessage : getUserFriendlyMessage(errorCode);
        request.getSession().setAttribute("errorMessage", message);
        request.getSession().setAttribute("errorCode", errorCode);
    }
    
    /**
     * Sets success message in session
     */
    public static void setSuccessMessage(HttpServletRequest request, String message) {
        request.getSession().setAttribute("successMessage", message);
    }
    
    /**
     * Clears error and success messages from session
     */
    public static void clearMessages(HttpServletRequest request) {
        request.getSession().removeAttribute("errorMessage");
        request.getSession().removeAttribute("errorCode");
        request.getSession().removeAttribute("successMessage");
    }
}
