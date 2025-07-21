package model;

/**
 * Generic API response wrapper class
 * Used for consistent JSON responses across all API endpoints
 * 
 * @author SpaManagement
 * @param <T> The type of data being returned
 */
public class ApiResponse<T> {
    
    private boolean success;
    private String message;
    private T data;
    private String error;
    private Long timestamp;
    
    // Constructors
    public ApiResponse() {
        this.timestamp = System.currentTimeMillis();
    }
    
    public ApiResponse(boolean success, String message, T data) {
        this();
        this.success = success;
        this.message = message;
        this.data = data;
    }
    
    public ApiResponse(boolean success, String message, T data, String error) {
        this(success, message, data);
        this.error = error;
    }
    
    // Getters and Setters
    public boolean isSuccess() {
        return success;
    }
    
    public void setSuccess(boolean success) {
        this.success = success;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public T getData() {
        return data;
    }
    
    public void setData(T data) {
        this.data = data;
    }
    
    public String getError() {
        return error;
    }
    
    public void setError(String error) {
        this.error = error;
    }
    
    public Long getTimestamp() {
        return timestamp;
    }
    
    public void setTimestamp(Long timestamp) {
        this.timestamp = timestamp;
    }
    
    // Utility methods
    
    /**
     * Create a successful response with data
     */
    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(true, "Success", data);
    }
    
    /**
     * Create a successful response with data and message
     */
    public static <T> ApiResponse<T> success(String message, T data) {
        return new ApiResponse<>(true, message, data);
    }
    
    /**
     * Create a successful response with just a message
     */
    public static ApiResponse<Object> successMessage(String message) {
        return new ApiResponse<>(true, message, null);
    }
    
    /**
     * Create an error response with message
     */
    public static <T> ApiResponse<T> error(String message) {
        ApiResponse<T> response = new ApiResponse<>(false, message, null);
        response.setError(message);
        return response;
    }
    
    /**
     * Create an error response with message and error details
     */
    public static <T> ApiResponse<T> error(String message, String error) {
        return new ApiResponse<>(false, message, null, error);
    }
    
    /**
     * Create an error response with message and partial data
     */
    public static <T> ApiResponse<T> error(String message, T data) {
        ApiResponse<T> response = new ApiResponse<>(false, message, data);
        response.setError(message);
        return response;
    }
    
    /**
     * Check if the response indicates success
     */
    public boolean wasSuccessful() {
        return success;
    }
    
    /**
     * Check if the response has data
     */
    public boolean hasData() {
        return data != null;
    }
    
    /**
     * Check if the response has an error
     */
    public boolean hasError() {
        return error != null && !error.trim().isEmpty();
    }
    
    @Override
    public String toString() {
        return "ApiResponse{" +
                "success=" + success +
                ", message='" + message + '\'' +
                ", hasData=" + hasData() +
                ", hasError=" + hasError() +
                ", timestamp=" + timestamp +
                '}';
    }
}
