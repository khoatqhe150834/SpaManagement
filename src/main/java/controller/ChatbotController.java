package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.ChatbotClient;
import java.util.logging.Logger;

/**
 * Controller for the chatbot page
 * Serves the chatbot interface JSP page
 */
@WebServlet(name = "ChatbotController", urlPatterns = {"/chatbot", "/chat"})
public class ChatbotController extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(ChatbotController.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        LOGGER.info("Serving chatbot page");
        
        // Check if chatbot API is healthy and set attribute for JSP
        boolean isApiHealthy = ChatbotClient.isHealthy();
        request.setAttribute("chatbotApiHealthy", isApiHealthy);
        
        // Set page metadata
        request.setAttribute("pageTitle", "Trợ Lý AI - Spa Hương Sen");
        request.setAttribute("pageDescription", "Tư vấn dịch vụ spa, giá cả và đặt lịch hẹn với trợ lý AI thông minh");
        
        // Forward to chatbot JSP page
        request.getRequestDispatcher("/WEB-INF/view/chatbot.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle POST requests the same as GET for this page
        doGet(request, response);
    }
}
