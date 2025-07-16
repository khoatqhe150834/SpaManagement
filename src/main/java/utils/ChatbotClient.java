package utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;

/**
 * HTTP Client utility for communicating with the Spa Chatbot API
 * Handles requests to the Python FastAPI server running on localhost:8000
 */
public class ChatbotClient {
    
    private static final Logger LOGGER = Logger.getLogger(ChatbotClient.class.getName());
    private static final String API_URL = "http://localhost:8000";
    private static final Gson gson = new Gson();
    private static final int CONNECTION_TIMEOUT = 10000; // 10 seconds
    private static final int READ_TIMEOUT = 30000; // 30 seconds
    
    /**
     * Send a message to the chatbot API and get response
     * 
     * @param message The user's message
     * @param sessionId The session ID for conversation context
     * @return The chatbot's response message
     */
    public static String sendMessage(String message, String sessionId) {
        if (message == null || message.trim().isEmpty()) {
            return "Vui lòng nhập câu hỏi của bạn.";
        }
        
        if (sessionId == null || sessionId.trim().isEmpty()) {
            sessionId = "spa-" + System.currentTimeMillis();
        }
        
        try {
            // Create request JSON
            JsonObject request = new JsonObject();
            request.addProperty("message", message.trim());
            request.addProperty("session_id", sessionId);
            
            LOGGER.info("Sending message to chatbot API: " + message);
            
            // Create HTTP connection
            URL url = new URL(API_URL + "/chat");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setRequestProperty("Accept", "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(CONNECTION_TIMEOUT);
            conn.setReadTimeout(READ_TIMEOUT);
            
            // Write request body
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = gson.toJson(request).getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }
            
            // Check response code
            int responseCode = conn.getResponseCode();
            LOGGER.info("Chatbot API response code: " + responseCode);
            
            // Read response
            InputStream inputStream = (responseCode >= 200 && responseCode < 300) 
                ? conn.getInputStream() 
                : conn.getErrorStream();
                
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(inputStream, StandardCharsets.UTF_8))) {
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) {
                    response.append(line.trim());
                }
                
                if (responseCode >= 200 && responseCode < 300) {
                    // Parse successful response
                    JsonObject responseObj = gson.fromJson(response.toString(), JsonObject.class);
                    if (responseObj.has("response")) {
                        String botResponse = responseObj.get("response").getAsString();
                        LOGGER.info("Chatbot response received successfully");
                        return botResponse;
                    } else {
                        LOGGER.warning("Invalid response format from chatbot API");
                        return "Xin lỗi, hệ thống chatbot trả về định dạng không hợp lệ.";
                    }
                } else {
                    // Handle error response
                    LOGGER.warning("Chatbot API error: " + response.toString());
                    return "Xin lỗi, hệ thống chatbot đang gặp sự cố. Vui lòng thử lại sau.";
                }
            }
            
        } catch (JsonSyntaxException e) {
            LOGGER.log(Level.SEVERE, "JSON parsing error", e);
            return "Xin lỗi, có lỗi xử lý dữ liệu từ hệ thống chatbot.";
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Network error communicating with chatbot API", e);
            return "Xin lỗi, không thể kết nối đến hệ thống chatbot. Vui lòng kiểm tra kết nối mạng.";
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in chatbot communication", e);
            return "Xin lỗi, hệ thống chatbot đang gặp sự cố không xác định. Vui lòng thử lại sau.";
        }
    }
    
    /**
     * Check if the chatbot API is healthy and responding
     * 
     * @return true if the API is healthy, false otherwise
     */
    public static boolean isHealthy() {
        try {
            URL url = new URL(API_URL + "/health");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");
            conn.setConnectTimeout(5000); // 5 seconds for health check
            conn.setReadTimeout(5000);

            int responseCode = conn.getResponseCode();

            // Read response body for debugging
            InputStream inputStream = (responseCode >= 200 && responseCode < 300)
                ? conn.getInputStream()
                : conn.getErrorStream();

            StringBuilder responseBody = new StringBuilder();
            if (inputStream != null) {
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(inputStream, StandardCharsets.UTF_8))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        responseBody.append(line);
                    }
                }
            }

            boolean isHealthy = responseCode == 200;

            LOGGER.info("Chatbot API health check: " + (isHealthy ? "HEALTHY" : "UNHEALTHY") +
                       " (response code: " + responseCode + ")");
            LOGGER.info("Health response body: " + responseBody.toString());

            // Try to parse the JSON response to check the actual status
            if (isHealthy && responseBody.length() > 0) {
                try {
                    JsonObject healthResponse = gson.fromJson(responseBody.toString(), JsonObject.class);
                    if (healthResponse.has("status")) {
                        String status = healthResponse.get("status").getAsString();
                        isHealthy = "healthy".equals(status);
                        LOGGER.info("Parsed health status: " + status);
                    }
                } catch (JsonSyntaxException e) {
                    LOGGER.warning("Failed to parse health response JSON: " + e.getMessage());
                    // Still return true if HTTP 200, even if JSON parsing fails
                }
            }

            return isHealthy;
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Health check failed", e);
            return false;
        }
    }
    
    /**
     * Get system information from the chatbot API
     * 
     * @return JSON string with system information or null if failed
     */
    public static String getSystemInfo() {
        try {
            URL url = new URL(API_URL + "/system/info");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");
            conn.setConnectTimeout(CONNECTION_TIMEOUT);
            conn.setReadTimeout(READ_TIMEOUT);
            
            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                    StringBuilder response = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) {
                        response.append(line.trim());
                    }
                    return response.toString();
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to get system info", e);
        }
        return null;
    }
    
    /**
     * Generate a unique session ID for a new chat session
     * 
     * @return A unique session ID
     */
    public static String generateSessionId() {
        return "spa-" + System.currentTimeMillis() + "-" + 
               Integer.toHexString((int)(Math.random() * 0x10000));
    }
}
