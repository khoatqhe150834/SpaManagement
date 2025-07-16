package controller.api;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.ChatbotClient;

/**
 * API Servlet for handling chatbot requests
 * Proxies requests to the Python FastAPI chatbot server
 */
@WebServlet(name = "ChatbotApiServlet", urlPatterns = {"/api/chat", "/api/chatbot"})
public class ChatbotApiServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(ChatbotApiServlet.class.getName());
    private static final Gson gson = new Gson();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set response headers
        response.setContentType("application/json; charset=UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");

        PrintWriter out = response.getWriter();

        try {
            // Get message parameter - handle both form data and JSON
            String message = null;
            String contentType = request.getContentType();

            LOGGER.info("Processing POST request - Content-Type: " + contentType);

            if (contentType != null && contentType.contains("application/json")) {
                // Handle JSON request
                StringBuilder jsonBuffer = new StringBuilder();
                String line;
                try (BufferedReader reader = request.getReader()) {
                    while ((line = reader.readLine()) != null) {
                        jsonBuffer.append(line);
                    }
                }

                JsonObject jsonRequest = gson.fromJson(jsonBuffer.toString(), JsonObject.class);
                if (jsonRequest.has("message")) {
                    message = jsonRequest.get("message").getAsString();
                }
            } else {
                // Handle form data (multipart or URL-encoded)
                message = request.getParameter("message");
            }

            LOGGER.info("Extracted message: " + (message != null ? "'" + message + "'" : "null"));

            if (message == null || message.trim().isEmpty()) {
                sendErrorResponse(out, "Message parameter is required", HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
            
            // Get or create session ID for conversation context
            HttpSession session = request.getSession(true);
            String sessionId = (String) session.getAttribute("chatbot_session_id");
            if (sessionId == null) {
                sessionId = ChatbotClient.generateSessionId();
                session.setAttribute("chatbot_session_id", sessionId);
                LOGGER.info("Created new chatbot session: " + sessionId);
            }
            
            // Log the request
            LOGGER.info("Processing chatbot request - Session: " + sessionId + ", Message: " + message);
            
            // Send message to chatbot API
            String chatbotResponse = ChatbotClient.sendMessage(message, sessionId);
            
            // Create success response
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("response", chatbotResponse);
            jsonResponse.addProperty("sessionId", sessionId);
            jsonResponse.addProperty("timestamp", System.currentTimeMillis());
            
            // Send response
            out.print(gson.toJson(jsonResponse));
            out.flush();
            
            LOGGER.info("Chatbot response sent successfully");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing chatbot request", e);
            sendErrorResponse(out, "Internal server error: " + e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json; charset=UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        
        PrintWriter out = response.getWriter();
        String action = request.getParameter("action");
        
        try {
            if ("health".equals(action)) {
                // Health check endpoint
                boolean isHealthy = ChatbotClient.isHealthy();
                
                JsonObject healthResponse = new JsonObject();
                healthResponse.addProperty("success", true);
                healthResponse.addProperty("healthy", isHealthy);
                healthResponse.addProperty("status", isHealthy ? "healthy" : "unhealthy");
                healthResponse.addProperty("timestamp", System.currentTimeMillis());
                
                out.print(gson.toJson(healthResponse));
                
            } else if ("system-info".equals(action)) {
                // System info endpoint
                String systemInfo = ChatbotClient.getSystemInfo();
                
                JsonObject infoResponse = new JsonObject();
                infoResponse.addProperty("success", true);
                if (systemInfo != null) {
                    infoResponse.addProperty("systemInfo", systemInfo);
                } else {
                    infoResponse.addProperty("error", "Unable to retrieve system information");
                }
                infoResponse.addProperty("timestamp", System.currentTimeMillis());
                
                out.print(gson.toJson(infoResponse));
                
            } else if ("session".equals(action)) {
                // Get current session info
                HttpSession session = request.getSession(false);
                String sessionId = session != null ? (String) session.getAttribute("chatbot_session_id") : null;
                
                JsonObject sessionResponse = new JsonObject();
                sessionResponse.addProperty("success", true);
                sessionResponse.addProperty("hasSession", sessionId != null);
                if (sessionId != null) {
                    sessionResponse.addProperty("sessionId", sessionId);
                }
                sessionResponse.addProperty("timestamp", System.currentTimeMillis());
                
                out.print(gson.toJson(sessionResponse));
                
            } else {
                sendErrorResponse(out, "Invalid action parameter. Supported actions: health, system-info, session", 
                                HttpServletResponse.SC_BAD_REQUEST);
            }
            
            out.flush();
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing GET request", e);
            sendErrorResponse(out, "Internal server error: " + e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Handle CORS preflight requests
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setStatus(HttpServletResponse.SC_OK);
    }
    
    /**
     * Send error response in JSON format
     */
    private void sendErrorResponse(PrintWriter out, String message, int statusCode) throws IOException {
        JsonObject error = new JsonObject();
        error.addProperty("success", false);
        error.addProperty("error", message);
        error.addProperty("timestamp", System.currentTimeMillis());
        
        out.print(gson.toJson(error));
        out.flush();
    }
}
