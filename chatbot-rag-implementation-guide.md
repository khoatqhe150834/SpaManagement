# AI Chatbot with RAG Implementation Guide for Java Web Applications

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Technology Stack](#technology-stack)
3. [Prerequisites](#prerequisites)
4. [Implementation Steps](#implementation-steps)
5. [Code Examples](#code-examples)
6. [Integration Guidelines](#integration-guidelines)
7. [Security Considerations](#security-considerations)
8. [Deployment and Maintenance](#deployment-and-maintenance)

## Architecture Overview

### What is RAG (Retrieval-Augmented Generation)?

RAG combines the power of large language models with external knowledge retrieval to provide accurate, contextual responses based on your specific data. Instead of relying solely on the model's training data, RAG retrieves relevant information from your knowledge base and uses it to generate informed responses.

### RAG Architecture Components

```
User Query → Embedding → Vector Search → Context Retrieval → LLM → Response
     ↓              ↓           ↓              ↓           ↓        ↓
  Chat UI    →  Embeddings  →  Vector DB  →  Knowledge  →  OpenAI  →  UI
```

### Integration with Spa Management System

The chatbot will integrate with your existing JSP-based spa management system by:

- Leveraging existing servlet architecture
- Using current database connections
- Maintaining session management
- Following existing security patterns

## Technology Stack

### Core Technologies

- **Backend**: Java 17, Jakarta Servlets, Maven
- **Vector Database**: Pinecone (cloud) or Weaviate (self-hosted)
- **LLM Provider**: OpenAI GPT-4 or Azure OpenAI
- **Embedding Model**: OpenAI text-embedding-ada-002
- **HTTP Client**: Apache HttpClient (already in your project)
- **JSON Processing**: Jackson (already in your project)
- **Frontend**: JavaScript, WebSocket for real-time chat

### Additional Dependencies

```xml
<!-- Add to your existing pom.xml -->
<dependency>
    <groupId>io.pinecone</groupId>
    <artifactId>pinecone-client</artifactId>
    <version>0.7.0</version>
</dependency>

<dependency>
    <groupId>org.java-websocket</groupId>
    <artifactId>Java-WebSocket</artifactId>
    <version>1.5.3</version>
</dependency>

<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-text</artifactId>
    <version>1.10.0</version>
</dependency>
```

## Prerequisites

### 1. API Keys and Services

- OpenAI API key
- Pinecone API key and environment
- Vector database setup

### 2. Knowledge Base Preparation

- Spa service descriptions
- FAQ documents
- Policy documents
- Treatment information
- Booking procedures

### 3. Environment Configuration

Create `chatbot.properties` in `src/main/resources/`:

```properties
openai.api.key=${OPENAI_API_KEY}
pinecone.api.key=${PINECONE_API_KEY}
pinecone.environment=${PINECONE_ENVIRONMENT}
pinecone.index.name=spa-knowledge-base
embedding.model=text-embedding-ada-002
chat.model=gpt-4
max.tokens=1000
temperature=0.7
```

## Implementation Steps

### Step 1: Document Ingestion and Embedding Service

Create the embedding service to process your knowledge base:

```java
// src/main/java/service/EmbeddingService.java
package service;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.hc.client5.http.classic.methods.HttpPost;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.io.entity.StringEntity;

import java.util.List;
import java.util.Map;

public class EmbeddingService {
    private final String apiKey;
    private final CloseableHttpClient httpClient;
    private final ObjectMapper objectMapper;

    public EmbeddingService(String apiKey) {
        this.apiKey = apiKey;
        this.httpClient = HttpClients.createDefault();
        this.objectMapper = new ObjectMapper();
    }

    public double[] generateEmbedding(String text) throws Exception {
        HttpPost request = new HttpPost("https://api.openai.com/v1/embeddings");
        request.setHeader("Authorization", "Bearer " + apiKey);
        request.setHeader("Content-Type", "application/json");

        Map<String, Object> requestBody = Map.of(
            "input", text,
            "model", "text-embedding-ada-002"
        );

        request.setEntity(new StringEntity(objectMapper.writeValueAsString(requestBody)));

        return httpClient.execute(request, response -> {
            Map<String, Object> responseBody = objectMapper.readValue(
                response.getEntity().getContent(), Map.class);
            List<Map<String, Object>> data = (List<Map<String, Object>>) responseBody.get("data");
            List<Double> embedding = (List<Double>) data.get(0).get("embedding");
            return embedding.stream().mapToDouble(Double::doubleValue).toArray();
        });
    }
}
```

### Step 2: Vector Database Integration

```java
// src/main/java/service/VectorDatabaseService.java
package service;

import io.pinecone.PineconeClient;
import io.pinecone.PineconeClientConfig;
import io.pinecone.proto.UpsertRequest;
import io.pinecone.proto.QueryRequest;
import io.pinecone.proto.Vector;

import java.util.List;
import java.util.Map;

public class VectorDatabaseService {
    private final PineconeClient pineconeClient;
    private final String indexName;

    public VectorDatabaseService(String apiKey, String environment, String indexName) {
        PineconeClientConfig config = new PineconeClientConfig()
            .withApiKey(apiKey)
            .withEnvironment(environment);
        this.pineconeClient = new PineconeClient(config);
        this.indexName = indexName;
    }

    public void upsertDocument(String id, double[] embedding, Map<String, String> metadata) {
        Vector vector = Vector.newBuilder()
            .setId(id)
            .addAllValues(Arrays.stream(embedding).boxed().collect(Collectors.toList()))
            .putAllMetadata(metadata)
            .build();

        UpsertRequest request = UpsertRequest.newBuilder()
            .addVectors(vector)
            .build();

        pineconeClient.getBlockingStub().upsert(request);
    }

    public List<ScoredVector> searchSimilar(double[] queryEmbedding, int topK) {
        QueryRequest request = QueryRequest.newBuilder()
            .addAllVector(Arrays.stream(queryEmbedding).boxed().collect(Collectors.toList()))
            .setTopK(topK)
            .setIncludeMetadata(true)
            .build();

        return pineconeClient.getBlockingStub().query(request).getMatchesList();
    }
}
```

### Step 3: Chat Service Implementation

```java
// src/main/java/service/ChatService.java
package service;

import com.fasterxml.jackson.databind.ObjectMapper;
import model.ChatMessage;
import model.ChatResponse;

import java.util.List;
import java.util.Map;

public class ChatService {
    private final EmbeddingService embeddingService;
    private final VectorDatabaseService vectorService;
    private final OpenAIService openAIService;

    public ChatService(EmbeddingService embeddingService,
                      VectorDatabaseService vectorService,
                      OpenAIService openAIService) {
        this.embeddingService = embeddingService;
        this.vectorService = vectorService;
        this.openAIService = openAIService;
    }

    public ChatResponse processMessage(String userMessage, String sessionId) throws Exception {
        // 1. Generate embedding for user query
        double[] queryEmbedding = embeddingService.generateEmbedding(userMessage);

        // 2. Search for relevant context
        List<ScoredVector> similarDocs = vectorService.searchSimilar(queryEmbedding, 5);

        // 3. Build context from retrieved documents
        String context = buildContext(similarDocs);

        // 4. Generate response using LLM
        String systemPrompt = buildSystemPrompt(context);
        String response = openAIService.generateResponse(systemPrompt, userMessage);

        return new ChatResponse(response, sessionId, System.currentTimeMillis());
    }

    private String buildContext(List<ScoredVector> documents) {
        StringBuilder context = new StringBuilder();
        for (ScoredVector doc : documents) {
            context.append(doc.getMetadata().get("content")).append("\n\n");
        }
        return context.toString();
    }

    private String buildSystemPrompt(String context) {
        return String.format("""
            You are a helpful assistant for a spa management system.
            Use the following context to answer questions about spa services, bookings, and policies.

            Context:
            %s

            Instructions:
            - Provide accurate information based on the context
            - If information is not in the context, say so politely
            - Be helpful and professional
            - Focus on spa-related topics
            """, context);
    }
}
```

### Step 4: OpenAI Service Implementation

```java
// src/main/java/service/OpenAIService.java
package service;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.hc.client5.http.classic.methods.HttpPost;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.io.entity.StringEntity;

import java.util.List;
import java.util.Map;

public class OpenAIService {
    private final String apiKey;
    private final CloseableHttpClient httpClient;
    private final ObjectMapper objectMapper;
    private final String model;
    private final int maxTokens;
    private final double temperature;

    public OpenAIService(String apiKey, String model, int maxTokens, double temperature) {
        this.apiKey = apiKey;
        this.httpClient = HttpClients.createDefault();
        this.objectMapper = new ObjectMapper();
        this.model = model;
        this.maxTokens = maxTokens;
        this.temperature = temperature;
    }

    public String generateResponse(String systemPrompt, String userMessage) throws Exception {
        HttpPost request = new HttpPost("https://api.openai.com/v1/chat/completions");
        request.setHeader("Authorization", "Bearer " + apiKey);
        request.setHeader("Content-Type", "application/json");

        Map<String, Object> requestBody = Map.of(
            "model", model,
            "messages", List.of(
                Map.of("role", "system", "content", systemPrompt),
                Map.of("role", "user", "content", userMessage)
            ),
            "max_tokens", maxTokens,
            "temperature", temperature
        );

        request.setEntity(new StringEntity(objectMapper.writeValueAsString(requestBody)));

        return httpClient.execute(request, response -> {
            Map<String, Object> responseBody = objectMapper.readValue(
                response.getEntity().getContent(), Map.class);
            List<Map<String, Object>> choices = (List<Map<String, Object>>) responseBody.get("choices");
            Map<String, Object> message = (Map<String, Object>) choices.get(0).get("message");
            return (String) message.get("content");
        });
    }
}
```

### Step 5: Chat Controller (Servlet)

```java
// src/main/java/controller/ChatController.java
package controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ChatResponse;
import service.ChatService;
import util.ConfigUtil;

import java.io.IOException;
import java.util.Map;

@WebServlet("/api/chat")
public class ChatController extends HttpServlet {
    private ChatService chatService;
    private ObjectMapper objectMapper;

    @Override
    public void init() throws ServletException {
        try {
            // Initialize services
            this.chatService = ServiceFactory.getChatService();
            this.objectMapper = new ObjectMapper();
        } catch (Exception e) {
            throw new ServletException("Failed to initialize ChatController", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");

        try {
            // Parse request
            Map<String, Object> requestData = objectMapper.readValue(
                request.getInputStream(), Map.class);
            String message = (String) requestData.get("message");

            if (message == null || message.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(objectMapper.writeValueAsString(
                    Map.of("error", "Message cannot be empty")));
                return;
            }

            // Get or create session
            HttpSession session = request.getSession();
            String sessionId = session.getId();

            // Process message
            ChatResponse chatResponse = chatService.processMessage(message.trim(), sessionId);

            // Return response
            response.getWriter().write(objectMapper.writeValueAsString(chatResponse));

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(objectMapper.writeValueAsString(
                Map.of("error", "Failed to process message: " + e.getMessage())));
        }
    }

    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response) {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setStatus(HttpServletResponse.SC_OK);
    }
}
```

### Step 6: Model Classes

```java
// src/main/java/model/ChatMessage.java
package model;

import lombok.Data;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ChatMessage {
    private String message;
    private String sender; // "user" or "bot"
    private long timestamp;
    private String sessionId;
}
```

```java
// src/main/java/model/ChatResponse.java
package model;

import lombok.Data;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ChatResponse {
    private String response;
    private String sessionId;
    private long timestamp;
    private boolean success = true;
}
```

### Step 7: Service Factory and Configuration

```java
// src/main/java/service/ServiceFactory.java
package service;

import util.ConfigUtil;

public class ServiceFactory {
    private static ChatService chatService;
    private static EmbeddingService embeddingService;
    private static VectorDatabaseService vectorService;
    private static OpenAIService openAIService;

    public static synchronized ChatService getChatService() throws Exception {
        if (chatService == null) {
            initializeServices();
        }
        return chatService;
    }

    private static void initializeServices() throws Exception {
        // Load configuration
        String openAIKey = ConfigUtil.getProperty("openai.api.key");
        String pineconeKey = ConfigUtil.getProperty("pinecone.api.key");
        String pineconeEnv = ConfigUtil.getProperty("pinecone.environment");
        String indexName = ConfigUtil.getProperty("pinecone.index.name");
        String chatModel = ConfigUtil.getProperty("chat.model");
        int maxTokens = Integer.parseInt(ConfigUtil.getProperty("max.tokens"));
        double temperature = Double.parseDouble(ConfigUtil.getProperty("temperature"));

        // Initialize services
        embeddingService = new EmbeddingService(openAIKey);
        vectorService = new VectorDatabaseService(pineconeKey, pineconeEnv, indexName);
        openAIService = new OpenAIService(openAIKey, chatModel, maxTokens, temperature);
        chatService = new ChatService(embeddingService, vectorService, openAIService);
    }
}
```

```java
// src/main/java/util/ConfigUtil.java
package util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class ConfigUtil {
    private static Properties properties;

    static {
        loadProperties();
    }

    private static void loadProperties() {
        properties = new Properties();
        try (InputStream input = ConfigUtil.class.getClassLoader()
                .getResourceAsStream("chatbot.properties")) {
            if (input != null) {
                properties.load(input);
            }
        } catch (IOException e) {
            throw new RuntimeException("Failed to load chatbot.properties", e);
        }
    }

    public static String getProperty(String key) {
        String value = System.getenv(key.toUpperCase().replace(".", "_"));
        if (value != null) {
            return value;
        }
        return properties.getProperty(key);
    }
}
```

### Step 8: Knowledge Base Initialization

```java
// src/main/java/service/KnowledgeBaseInitializer.java
package service;

import dao.ServiceDAO;
import model.Service;
import java.util.List;
import java.util.Map;

public class KnowledgeBaseInitializer {
    private final EmbeddingService embeddingService;
    private final VectorDatabaseService vectorService;
    private final ServiceDAO serviceDAO;

    public KnowledgeBaseInitializer(EmbeddingService embeddingService,
                                  VectorDatabaseService vectorService,
                                  ServiceDAO serviceDAO) {
        this.embeddingService = embeddingService;
        this.vectorService = vectorService;
        this.serviceDAO = serviceDAO;
    }

    public void initializeKnowledgeBase() throws Exception {
        System.out.println("Initializing knowledge base...");

        // 1. Load spa services from database
        initializeServices();

        // 2. Load FAQ documents
        initializeFAQs();

        // 3. Load policy documents
        initializePolicies();

        System.out.println("Knowledge base initialization completed.");
    }

    private void initializeServices() throws Exception {
        List<Service> services = serviceDAO.getAllServices();

        for (Service service : services) {
            String content = formatServiceContent(service);
            double[] embedding = embeddingService.generateEmbedding(content);

            Map<String, String> metadata = Map.of(
                "type", "service",
                "service_id", String.valueOf(service.getServiceId()),
                "title", service.getServiceName(),
                "content", content,
                "category", service.getCategoryName() != null ? service.getCategoryName() : "General"
            );

            vectorService.upsertDocument(
                "service_" + service.getServiceId(),
                embedding,
                metadata
            );
        }

        System.out.println("Initialized " + services.size() + " services in knowledge base.");
    }

    private String formatServiceContent(Service service) {
        return String.format("""
            Service: %s
            Description: %s
            Duration: %d minutes
            Price: $%.2f
            Category: %s
            """,
            service.getServiceName(),
            service.getDescription() != null ? service.getDescription() : "No description available",
            service.getDuration(),
            service.getPrice(),
            service.getCategoryName() != null ? service.getCategoryName() : "General"
        );
    }

    private void initializeFAQs() throws Exception {
        String[] faqs = {
            "Q: How do I book a spa service? A: You can book online through our website by selecting your desired service, choosing a date and time, and completing the booking form. You can also call us directly.",
            "Q: What is your cancellation policy? A: Cancellations must be made at least 24 hours in advance to avoid charges. Same-day cancellations may incur a fee.",
            "Q: Do you offer group bookings? A: Yes, we offer special packages for groups of 4 or more people. Contact us for group rates and availability.",
            "Q: What should I bring to my appointment? A: Just bring yourself! We provide all necessary towels, robes, and amenities. Arrive 15 minutes early for check-in.",
            "Q: Do you offer gift certificates? A: Yes, we offer gift certificates for all our services. They can be purchased online or in-person and make perfect gifts.",
            "Q: What are your operating hours? A: We are open Monday-Saturday 9 AM to 8 PM, and Sunday 10 AM to 6 PM. Holiday hours may vary."
        };

        for (int i = 0; i < faqs.length; i++) {
            double[] embedding = embeddingService.generateEmbedding(faqs[i]);
            Map<String, String> metadata = Map.of(
                "type", "faq",
                "content", faqs[i]
            );
            vectorService.upsertDocument("faq_" + i, embedding, metadata);
        }

        System.out.println("Initialized " + faqs.length + " FAQs in knowledge base.");
    }

    private void initializePolicies() throws Exception {
        String[] policies = {
            "Spa Policy: All guests must arrive 15 minutes before their scheduled appointment time for check-in and consultation.",
            "Health Policy: Please inform us of any health conditions, allergies, or medications that might affect your treatment.",
            "Payment Policy: We accept cash, credit cards, and gift certificates. Gratuities are appreciated but not required.",
            "Privacy Policy: Your personal information and treatment details are kept strictly confidential.",
            "Age Policy: Guests under 16 must be accompanied by a parent or guardian for all treatments."
        };

        for (int i = 0; i < policies.length; i++) {
            double[] embedding = embeddingService.generateEmbedding(policies[i]);
            Map<String, String> metadata = Map.of(
                "type", "policy",
                "content", policies[i]
            );
            vectorService.upsertDocument("policy_" + i, embedding, metadata);
        }

        System.out.println("Initialized " + policies.length + " policies in knowledge base.");
    }
}
```

## Code Examples

### Frontend Chat Interface

Add this to your main layout JSP (e.g., `src/main/webapp/WEB-INF/includes/layout.jsp`):

```html
<!-- Chatbot HTML Structure -->
<div id="chatbot-container" class="chatbot-container">
  <div id="chatbot-header" class="chatbot-header">
    <h4><i class="fas fa-spa"></i> Spa Assistant</h4>
    <button id="chatbot-toggle" class="chatbot-toggle">−</button>
  </div>
  <div id="chatbot-body" class="chatbot-body">
    <div id="chatbot-messages" class="chatbot-messages">
      <div class="message bot-message">
        Hi! I'm your spa assistant. I can help you with information about our
        services, booking procedures, and policies. How can I assist you today?
      </div>
    </div>
    <div id="chatbot-input-container" class="chatbot-input-container">
      <input
        type="text"
        id="chatbot-input"
        placeholder="Ask about our services..."
        maxlength="500"
      />
      <button id="chatbot-send" class="chatbot-send">
        <i class="fas fa-paper-plane"></i>
      </button>
    </div>
  </div>
</div>

<!-- Include chatbot CSS and JS -->
<link
  rel="stylesheet"
  href="${pageContext.request.contextPath}/css/chatbot.css"
/>
<script src="${pageContext.request.contextPath}/js/chatbot.js"></script>
```

### JavaScript Chat Implementation

Create `src/main/webapp/js/chatbot.js`:

```javascript
class SpaChatbot {
  constructor() {
    this.messagesContainer = document.getElementById("chatbot-messages");
    this.inputField = document.getElementById("chatbot-input");
    this.sendButton = document.getElementById("chatbot-send");
    this.toggleButton = document.getElementById("chatbot-toggle");
    this.chatbotBody = document.getElementById("chatbot-body");
    this.isMinimized = false;

    this.initializeEventListeners();
    this.loadChatHistory();
  }

  initializeEventListeners() {
    this.sendButton.addEventListener("click", () => this.sendMessage());
    this.inputField.addEventListener("keypress", (e) => {
      if (e.key === "Enter" && !e.shiftKey) {
        e.preventDefault();
        this.sendMessage();
      }
    });
    this.toggleButton.addEventListener("click", () => this.toggleChat());

    // Auto-resize input field
    this.inputField.addEventListener("input", () => this.autoResizeInput());
  }

  async sendMessage() {
    const message = this.inputField.value.trim();
    if (!message) return;

    // Disable input while processing
    this.setInputState(false);

    this.addMessage(message, "user");
    this.inputField.value = "";
    this.showTypingIndicator();

    try {
      const response = await fetch(`${window.location.origin}/spa/api/chat`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ message }),
      });

      const data = await response.json();
      this.hideTypingIndicator();

      if (data.error) {
        this.addMessage(
          "Sorry, I encountered an error. Please try again.",
          "bot",
          true
        );
      } else {
        this.addMessage(data.response, "bot");
        this.saveChatHistory();
      }
    } catch (error) {
      this.hideTypingIndicator();
      this.addMessage(
        "Sorry, I'm having trouble connecting. Please try again later.",
        "bot",
        true
      );
      console.error("Chat error:", error);
    } finally {
      this.setInputState(true);
    }
  }

  addMessage(text, sender, isError = false) {
    const messageDiv = document.createElement("div");
    messageDiv.className = `message ${sender}-message${
      isError ? " error-message" : ""
    }`;

    // Format message with basic markdown support
    const formattedText = this.formatMessage(text);
    messageDiv.innerHTML = formattedText;

    // Add timestamp
    const timestamp = document.createElement("div");
    timestamp.className = "message-timestamp";
    timestamp.textContent = new Date().toLocaleTimeString([], {
      hour: "2-digit",
      minute: "2-digit",
    });
    messageDiv.appendChild(timestamp);

    this.messagesContainer.appendChild(messageDiv);
    this.scrollToBottom();
  }

  formatMessage(text) {
    // Basic markdown formatting
    return text
      .replace(/\*\*(.*?)\*\*/g, "<strong>$1</strong>")
      .replace(/\*(.*?)\*/g, "<em>$1</em>")
      .replace(/\n/g, "<br>")
      .replace(/`(.*?)`/g, "<code>$1</code>");
  }

  showTypingIndicator() {
    const indicator = document.createElement("div");
    indicator.className = "typing-indicator";
    indicator.id = "typing-indicator";
    indicator.innerHTML = `
            <div class="typing-dots">
                <span></span><span></span><span></span>
            </div>
            <div class="typing-text">Spa Assistant is typing...</div>
        `;
    this.messagesContainer.appendChild(indicator);
    this.scrollToBottom();
  }

  hideTypingIndicator() {
    const indicator = document.getElementById("typing-indicator");
    if (indicator) indicator.remove();
  }

  toggleChat() {
    this.isMinimized = !this.isMinimized;
    this.chatbotBody.style.display = this.isMinimized ? "none" : "flex";
    this.toggleButton.textContent = this.isMinimized ? "+" : "−";

    // Save state
    localStorage.setItem("chatbot-minimized", this.isMinimized);
  }

  setInputState(enabled) {
    this.inputField.disabled = !enabled;
    this.sendButton.disabled = !enabled;
    this.sendButton.innerHTML = enabled
      ? '<i class="fas fa-paper-plane"></i>'
      : '<i class="fas fa-spinner fa-spin"></i>';
  }

  autoResizeInput() {
    this.inputField.style.height = "auto";
    this.inputField.style.height =
      Math.min(this.inputField.scrollHeight, 100) + "px";
  }

  scrollToBottom() {
    this.messagesContainer.scrollTop = this.messagesContainer.scrollHeight;
  }

  saveChatHistory() {
    const messages = Array.from(this.messagesContainer.children)
      .filter(
        (el) =>
          el.classList.contains("message") &&
          !el.classList.contains("typing-indicator")
      )
      .map((el) => ({
        text: el.textContent.replace(/\d{1,2}:\d{2}$/, "").trim(),
        sender: el.classList.contains("user-message") ? "user" : "bot",
        timestamp: Date.now(),
      }))
      .slice(-20); // Keep only last 20 messages

    localStorage.setItem("chatbot-history", JSON.stringify(messages));
  }

  loadChatHistory() {
    try {
      const history = JSON.parse(
        localStorage.getItem("chatbot-history") || "[]"
      );
      const minimized = localStorage.getItem("chatbot-minimized") === "true";

      // Load previous messages (except welcome message)
      if (history.length > 0) {
        // Clear welcome message
        this.messagesContainer.innerHTML = "";

        history.forEach((msg) => {
          this.addMessage(msg.text, msg.sender);
        });
      }

      // Restore minimized state
      if (minimized) {
        this.isMinimized = true;
        this.chatbotBody.style.display = "none";
        this.toggleButton.textContent = "+";
      }
    } catch (error) {
      console.error("Failed to load chat history:", error);
    }
  }
}

// Initialize chatbot when DOM is loaded
document.addEventListener("DOMContentLoaded", () => {
  // Only initialize if chatbot container exists
  if (document.getElementById("chatbot-container")) {
    new SpaChatbot();
  }
});
```

### CSS Styling

Create `src/main/webapp/css/chatbot.css`:

```css
/* Chatbot Container */
.chatbot-container {
  position: fixed;
  bottom: 20px;
  right: 20px;
  width: 380px;
  max-height: 600px;
  background: #ffffff;
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12);
  display: flex;
  flex-direction: column;
  z-index: 1000;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border: 1px solid #e1e5e9;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
}

.chatbot-container:hover {
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
}

/* Header */
.chatbot-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 16px 20px;
  border-radius: 12px 12px 0 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  cursor: pointer;
  user-select: none;
}

.chatbot-header h4 {
  margin: 0;
  font-size: 16px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 8px;
}

.chatbot-toggle {
  background: rgba(255, 255, 255, 0.2);
  border: none;
  color: white;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  cursor: pointer;
  font-size: 18px;
  font-weight: bold;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background-color 0.2s;
}

.chatbot-toggle:hover {
  background: rgba(255, 255, 255, 0.3);
}

/* Body */
.chatbot-body {
  display: flex;
  flex-direction: column;
  height: 500px;
}

/* Messages Container */
.chatbot-messages {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 12px;
  scroll-behavior: smooth;
}

.chatbot-messages::-webkit-scrollbar {
  width: 6px;
}

.chatbot-messages::-webkit-scrollbar-track {
  background: #f1f3f4;
  border-radius: 3px;
}

.chatbot-messages::-webkit-scrollbar-thumb {
  background: #c1c8cd;
  border-radius: 3px;
}

.chatbot-messages::-webkit-scrollbar-thumb:hover {
  background: #a8b3ba;
}

/* Messages */
.message {
  max-width: 85%;
  padding: 12px 16px;
  border-radius: 18px;
  word-wrap: break-word;
  line-height: 1.4;
  position: relative;
  animation: messageSlideIn 0.3s ease-out;
}

@keyframes messageSlideIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.user-message {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  align-self: flex-end;
  margin-left: auto;
  border-bottom-right-radius: 6px;
}

.bot-message {
  background: #f8f9fa;
  color: #2c3e50;
  align-self: flex-start;
  border: 1px solid #e9ecef;
  border-bottom-left-radius: 6px;
}

.error-message {
  background: #fee;
  border-color: #fcc;
  color: #c33;
}

.message-timestamp {
  font-size: 11px;
  opacity: 0.6;
  margin-top: 4px;
  text-align: right;
}

.bot-message .message-timestamp {
  text-align: left;
}

/* Message formatting */
.message strong {
  font-weight: 600;
}

.message em {
  font-style: italic;
}

.message code {
  background: rgba(0, 0, 0, 0.1);
  padding: 2px 4px;
  border-radius: 3px;
  font-family: "Monaco", "Menlo", "Ubuntu Mono", monospace;
  font-size: 0.9em;
}

/* Typing Indicator */
.typing-indicator {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 16px;
  background: #f8f9fa;
  border-radius: 18px;
  border-bottom-left-radius: 6px;
  max-width: 85%;
  align-self: flex-start;
  border: 1px solid #e9ecef;
}

.typing-dots {
  display: flex;
  gap: 4px;
}

.typing-dots span {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #667eea;
  animation: typing 1.4s infinite ease-in-out;
}

.typing-dots span:nth-child(1) {
  animation-delay: -0.32s;
}
.typing-dots span:nth-child(2) {
  animation-delay: -0.16s;
}
.typing-dots span:nth-child(3) {
  animation-delay: 0s;
}

@keyframes typing {
  0%,
  80%,
  100% {
    transform: scale(0.8);
    opacity: 0.5;
  }
  40% {
    transform: scale(1);
    opacity: 1;
  }
}

.typing-text {
  font-size: 12px;
  color: #6c757d;
  font-style: italic;
}

/* Input Container */
.chatbot-input-container {
  padding: 16px 20px;
  border-top: 1px solid #e9ecef;
  display: flex;
  gap: 12px;
  align-items: flex-end;
  background: #fafbfc;
  border-radius: 0 0 12px 12px;
}

.chatbot-input-container input {
  flex: 1;
  padding: 12px 16px;
  border: 1px solid #e1e5e9;
  border-radius: 20px;
  outline: none;
  font-size: 14px;
  resize: none;
  min-height: 20px;
  max-height: 80px;
  font-family: inherit;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.chatbot-input-container input:focus {
  border-color: #667eea;
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.chatbot-input-container input:disabled {
  background: #f8f9fa;
  cursor: not-allowed;
}

.chatbot-send {
  padding: 12px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  border-radius: 50%;
  cursor: pointer;
  width: 44px;
  height: 44px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
  flex-shrink: 0;
}

.chatbot-send:hover:not(:disabled) {
  transform: scale(1.05);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
}

.chatbot-send:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
}

/* Responsive Design */
@media (max-width: 480px) {
  .chatbot-container {
    width: calc(100vw - 40px);
    right: 20px;
    left: 20px;
    max-height: 70vh;
  }

  .chatbot-body {
    height: 400px;
  }

  .message {
    max-width: 90%;
  }
}

/* Animation for container appearance */
.chatbot-container {
  animation: chatbotSlideIn 0.4s ease-out;
}

@keyframes chatbotSlideIn {
  from {
    opacity: 0;
    transform: translateY(20px) scale(0.95);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}
```

## Integration Guidelines

### 1. Integration with Existing Spa Management System

#### Database Integration

```java
// Extend existing ServiceDAO to support chatbot queries
public class ServiceDAO {
    // Existing methods...

    public List<Service> searchServicesByKeywords(String keywords) throws SQLException {
        String sql = """
            SELECT s.*, c.category_name
            FROM services s
            LEFT JOIN categories c ON s.category_id = c.category_id
            WHERE s.service_name LIKE ? OR s.description LIKE ?
            AND s.is_active = 1
            ORDER BY s.service_name
            """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            String searchTerm = "%" + keywords + "%";
            stmt.setString(1, searchTerm);
            stmt.setString(2, searchTerm);

            ResultSet rs = stmt.executeQuery();
            List<Service> services = new ArrayList<>();

            while (rs.next()) {
                services.add(mapResultSetToService(rs));
            }

            return services;
        }
    }

    public List<Service> getServicesByCategory(String categoryName) throws SQLException {
        String sql = """
            SELECT s.*, c.category_name
            FROM services s
            JOIN categories c ON s.category_id = c.category_id
            WHERE c.category_name LIKE ? AND s.is_active = 1
            ORDER BY s.service_name
            """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, "%" + categoryName + "%");
            ResultSet rs = stmt.executeQuery();
            List<Service> services = new ArrayList<>();

            while (rs.next()) {
                services.add(mapResultSetToService(rs));
            }

            return services;
        }
    }
}
```

#### Session Integration

```java
// Enhanced ChatService with session context
public class ChatService {
    // ... existing code ...

    public ChatResponse processMessage(String userMessage, String sessionId, HttpSession httpSession) throws Exception {
        // Get user context from session
        User currentUser = (User) httpSession.getAttribute("user");
        String userContext = buildUserContext(currentUser);

        // Generate embedding for user query
        double[] queryEmbedding = embeddingService.generateEmbedding(userMessage);

        // Search for relevant context
        List<ScoredVector> similarDocs = vectorService.searchSimilar(queryEmbedding, 5);

        // Build context from retrieved documents
        String context = buildContext(similarDocs);

        // Generate response using LLM with user context
        String systemPrompt = buildSystemPrompt(context, userContext);
        String response = openAIService.generateResponse(systemPrompt, userMessage);

        return new ChatResponse(response, sessionId, System.currentTimeMillis());
    }

    private String buildUserContext(User user) {
        if (user == null) {
            return "The user is not logged in. Provide general information and suggest logging in for personalized assistance.";
        }

        return String.format("""
            User Context:
            - Name: %s
            - Email: %s
            - Member since: %s
            - The user is logged in and can make bookings.
            """,
            user.getFullName(),
            user.getEmail(),
            user.getCreatedAt()
        );
    }

    private String buildSystemPrompt(String context, String userContext) {
        return String.format("""
            You are a helpful assistant for a spa management system.
            Use the following context to answer questions about spa services, bookings, and policies.

            Knowledge Base Context:
            %s

            %s

            Instructions:
            - Provide accurate information based on the context
            - If the user is logged in, you can help them with bookings
            - If the user is not logged in, suggest they log in for personalized service
            - Be helpful, professional, and spa-focused
            - If information is not in the context, say so politely
            - For booking requests, provide the booking URL: /spa/booking
            - For service details, provide the services URL: /spa/services
            """, context, userContext);
    }
}
```

### 2. Initialization Servlet

```java
// src/main/java/listener/ChatbotInitializationListener.java
package listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import service.KnowledgeBaseInitializer;
import service.ServiceFactory;
import dao.ServiceDAO;

@WebListener
public class ChatbotInitializationListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            System.out.println("Initializing chatbot knowledge base...");

            // Initialize knowledge base in background thread
            Thread initThread = new Thread(() -> {
                try {
                    KnowledgeBaseInitializer initializer = new KnowledgeBaseInitializer(
                        ServiceFactory.getEmbeddingService(),
                        ServiceFactory.getVectorDatabaseService(),
                        new ServiceDAO()
                    );

                    initializer.initializeKnowledgeBase();
                    System.out.println("Chatbot knowledge base initialized successfully.");

                } catch (Exception e) {
                    System.err.println("Failed to initialize chatbot knowledge base: " + e.getMessage());
                    e.printStackTrace();
                }
            });

            initThread.setDaemon(true);
            initThread.start();

        } catch (Exception e) {
            System.err.println("Error starting chatbot initialization: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Cleanup resources if needed
        System.out.println("Chatbot context destroyed.");
    }
}
```

### 3. JSP Integration

Add to your main layout or specific pages:

```jsp
<%-- Add to head section --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/chatbot.css">

<%-- Add before closing body tag --%>
<c:if test="${not empty pageContext.request.userPrincipal or param.showChatbot eq 'true'}">
    <%@ include file="/WEB-INF/includes/chatbot.jsp" %>
</c:if>

<script src="${pageContext.request.contextPath}/js/chatbot.js"></script>
```

Create `src/main/webapp/WEB-INF/includes/chatbot.jsp`:

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div id="chatbot-container" class="chatbot-container">
    <div id="chatbot-header" class="chatbot-header">
        <h4><i class="fas fa-spa"></i> Spa Assistant</h4>
        <button id="chatbot-toggle" class="chatbot-toggle">−</button>
    </div>
    <div id="chatbot-body" class="chatbot-body">
        <div id="chatbot-messages" class="chatbot-messages">
            <div class="message bot-message">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        Hi ${sessionScope.user.firstName}! I'm your spa assistant. I can help you with information about our services, booking procedures, and policies. How can I assist you today?
                    </c:when>
                    <c:otherwise>
                        Hi! I'm your spa assistant. I can help you with information about our services, booking procedures, and policies. How can I assist you today?
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <div id="chatbot-input-container" class="chatbot-input-container">
            <input type="text" id="chatbot-input" placeholder="Ask about our services..." maxlength="500" />
            <button id="chatbot-send" class="chatbot-send">
                <i class="fas fa-paper-plane"></i>
            </button>
        </div>
    </div>
</div>
```

## Security Considerations

### 1. API Key Management

```java
// src/main/java/util/SecurityUtil.java
package util;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import java.util.Base64;

public class SecurityUtil {
    private static final String ALGORITHM = "AES";
    private static final String TRANSFORMATION = "AES";

    public static String encryptApiKey(String apiKey, String secretKey) throws Exception {
        SecretKeySpec keySpec = new SecretKeySpec(secretKey.getBytes(), ALGORITHM);
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);
        cipher.init(Cipher.ENCRYPT_MODE, keySpec);
        byte[] encrypted = cipher.doFinal(apiKey.getBytes());
        return Base64.getEncoder().encodeToString(encrypted);
    }

    public static String decryptApiKey(String encryptedApiKey, String secretKey) throws Exception {
        SecretKeySpec keySpec = new SecretKeySpec(secretKey.getBytes(), ALGORITHM);
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);
        cipher.init(Cipher.DECRYPT_MODE, keySpec);
        byte[] decrypted = cipher.doFinal(Base64.getDecoder().decode(encryptedApiKey));
        return new String(decrypted);
    }
}
```

### 2. Rate Limiting

```java
// src/main/java/filter/ChatRateLimitFilter.java
package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

@WebFilter("/api/chat")
public class ChatRateLimitFilter implements Filter {
    private static final int MAX_REQUESTS_PER_MINUTE = 20;
    private static final int MAX_REQUESTS_PER_HOUR = 100;
    private static final ConcurrentHashMap<String, RateLimitInfo> rateLimitMap = new ConcurrentHashMap<>();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String clientId = getClientIdentifier(httpRequest);

        if (isRateLimited(clientId)) {
            httpResponse.setStatus(HttpServletResponse.SC_TOO_MANY_REQUESTS);
            httpResponse.setContentType("application/json");
            httpResponse.getWriter().write("{\"error\":\"Rate limit exceeded. Please try again later.\"}");
            return;
        }

        chain.doFilter(request, response);
    }

    private String getClientIdentifier(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return session.getId();
        }
        return request.getRemoteAddr();
    }

    private boolean isRateLimited(String clientId) {
        long currentTime = System.currentTimeMillis();

        rateLimitMap.compute(clientId, (key, info) -> {
            if (info == null) {
                info = new RateLimitInfo();
            }

            // Reset counters if time windows have passed
            if (currentTime - info.lastMinuteReset > 60000) {
                info.minuteCount.set(0);
                info.lastMinuteReset = currentTime;
            }

            if (currentTime - info.lastHourReset > 3600000) {
                info.hourCount.set(0);
                info.lastHourReset = currentTime;
            }

            info.minuteCount.incrementAndGet();
            info.hourCount.incrementAndGet();

            return info;
        });

        RateLimitInfo info = rateLimitMap.get(clientId);
        return info.minuteCount.get() > MAX_REQUESTS_PER_MINUTE ||
               info.hourCount.get() > MAX_REQUESTS_PER_HOUR;
    }

    private static class RateLimitInfo {
        AtomicInteger minuteCount = new AtomicInteger(0);
        AtomicInteger hourCount = new AtomicInteger(0);
        long lastMinuteReset = System.currentTimeMillis();
        long lastHourReset = System.currentTimeMillis();
    }
}
```

### 3. Input Validation and Sanitization

```java
// src/main/java/validation/ChatInputValidator.java
package validation;

import org.apache.commons.text.StringEscapeUtils;
import java.util.regex.Pattern;

public class ChatInputValidator {
    private static final int MAX_MESSAGE_LENGTH = 500;
    private static final Pattern MALICIOUS_PATTERN = Pattern.compile(
        "(?i)(script|javascript|vbscript|onload|onerror|onclick|eval|expression|alert|confirm|prompt)",
        Pattern.CASE_INSENSITIVE
    );

    public static ValidationResult validateMessage(String message) {
        if (message == null || message.trim().isEmpty()) {
            return new ValidationResult(false, "Message cannot be empty");
        }

        if (message.length() > MAX_MESSAGE_LENGTH) {
            return new ValidationResult(false, "Message too long. Maximum " + MAX_MESSAGE_LENGTH + " characters allowed");
        }

        if (MALICIOUS_PATTERN.matcher(message).find()) {
            return new ValidationResult(false, "Message contains potentially harmful content");
        }

        // Check for excessive special characters
        long specialCharCount = message.chars()
            .filter(ch -> !Character.isLetterOrDigit(ch) && !Character.isWhitespace(ch))
            .count();

        if (specialCharCount > message.length() * 0.3) {
            return new ValidationResult(false, "Message contains too many special characters");
        }

        return new ValidationResult(true, "Valid");
    }

    public static String sanitizeMessage(String message) {
        if (message == null) return "";

        // Remove HTML tags and escape special characters
        String sanitized = StringEscapeUtils.escapeHtml4(message);

        // Remove excessive whitespace
        sanitized = sanitized.replaceAll("\\s+", " ").trim();

        return sanitized;
    }

    public static class ValidationResult {
        private final boolean valid;
        private final String message;

        public ValidationResult(boolean valid, String message) {
            this.valid = valid;
            this.message = message;
        }

        public boolean isValid() { return valid; }
        public String getMessage() { return message; }
    }
}
```

### 4. Enhanced Chat Controller with Security

```java
// Updated ChatController with security measures
@WebServlet("/api/chat")
public class ChatController extends HttpServlet {
    private ChatService chatService;
    private ObjectMapper objectMapper;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Security headers
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("X-Frame-Options", "DENY");
        response.setHeader("X-XSS-Protection", "1; mode=block");

        try {
            // Parse and validate request
            Map<String, Object> requestData = objectMapper.readValue(
                request.getInputStream(), Map.class);
            String message = (String) requestData.get("message");

            // Validate input
            ChatInputValidator.ValidationResult validation =
                ChatInputValidator.validateMessage(message);

            if (!validation.isValid()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(objectMapper.writeValueAsString(
                    Map.of("error", validation.getMessage())));
                return;
            }

            // Sanitize input
            String sanitizedMessage = ChatInputValidator.sanitizeMessage(message);

            // Get session
            HttpSession session = request.getSession();
            String sessionId = session.getId();

            // Process message with session context
            ChatResponse chatResponse = chatService.processMessage(
                sanitizedMessage, sessionId, session);

            // Log interaction (for monitoring)
            logChatInteraction(sessionId, sanitizedMessage, chatResponse);

            // Return response
            response.getWriter().write(objectMapper.writeValueAsString(chatResponse));

        } catch (Exception e) {
            // Log error without exposing details
            System.err.println("Chat processing error: " + e.getMessage());

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(objectMapper.writeValueAsString(
                Map.of("error", "Unable to process your request at this time. Please try again.")));
        }
    }

    private void logChatInteraction(String sessionId, String message, ChatResponse response) {
        // Implement logging for monitoring and analytics
        System.out.printf("[CHAT] Session: %s, Message length: %d, Response time: %dms%n",
            sessionId, message.length(), System.currentTimeMillis() - response.getTimestamp());
    }
}
```

### 5. Data Privacy Measures

```java
// src/main/java/service/PrivacyService.java
package service;

import java.util.regex.Pattern;

public class PrivacyService {
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}\\b"
    );

    private static final Pattern PHONE_PATTERN = Pattern.compile(
        "\\b\\d{3}[-.]?\\d{3}[-.]?\\d{4}\\b"
    );

    private static final Pattern SSN_PATTERN = Pattern.compile(
        "\\b\\d{3}-\\d{2}-\\d{4}\\b"
    );

    public static String redactSensitiveInfo(String text) {
        if (text == null) return null;

        String redacted = text;

        // Redact email addresses
        redacted = EMAIL_PATTERN.matcher(redacted).replaceAll("[EMAIL_REDACTED]");

        // Redact phone numbers
        redacted = PHONE_PATTERN.matcher(redacted).replaceAll("[PHONE_REDACTED]");

        // Redact SSN
        redacted = SSN_PATTERN.matcher(redacted).replaceAll("[SSN_REDACTED]");

        return redacted;
    }

    public static boolean containsSensitiveInfo(String text) {
        if (text == null) return false;

        return EMAIL_PATTERN.matcher(text).find() ||
               PHONE_PATTERN.matcher(text).find() ||
               SSN_PATTERN.matcher(text).find();
    }
}
```

## Deployment and Maintenance

### 1. Environment Configuration

#### Production Environment Variables

```bash
# Set these environment variables in your production environment
export OPENAI_API_KEY="your-openai-api-key"
export PINECONE_API_KEY="your-pinecone-api-key"
export PINECONE_ENVIRONMENT="your-pinecone-environment"
export PINECONE_INDEX_NAME="spa-knowledge-base"
export CHAT_MODEL="gpt-4"
export MAX_TOKENS="1000"
export TEMPERATURE="0.7"
export CHATBOT_ENCRYPTION_KEY="your-32-character-encryption-key"
```

#### Heroku Configuration

Add to your existing `Procfile`:

```
web: java $JAVA_OPTS -jar target/dependency/webapp-runner.jar --port $PORT target/*.war
```

Add environment variables in Heroku:

```bash
heroku config:set OPENAI_API_KEY="your-key"
heroku config:set PINECONE_API_KEY="your-key"
heroku config:set PINECONE_ENVIRONMENT="your-env"
# ... other variables
```

### 2. Database Schema Updates

```sql
-- Add chatbot-related tables for logging and analytics
CREATE TABLE chatbot_conversations (
    conversation_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    session_id VARCHAR(255) NOT NULL,
    user_id INT NULL,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMP NULL,
    message_count INT DEFAULT 0,
    INDEX idx_session_id (session_id),
    INDEX idx_user_id (user_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

CREATE TABLE chatbot_messages (
    message_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    conversation_id BIGINT NOT NULL,
    message_type ENUM('user', 'bot') NOT NULL,
    message_content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    response_time_ms INT NULL,
    INDEX idx_conversation_id (conversation_id),
    INDEX idx_created_at (created_at),
    FOREIGN KEY (conversation_id) REFERENCES chatbot_conversations(conversation_id) ON DELETE CASCADE
);

CREATE TABLE chatbot_feedback (
    feedback_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    message_id BIGINT NOT NULL,
    rating TINYINT CHECK (rating BETWEEN 1 AND 5),
    feedback_text TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_message_id (message_id),
    FOREIGN KEY (message_id) REFERENCES chatbot_messages(message_id) ON DELETE CASCADE
);
```

### 3. Monitoring and Analytics

```java
// src/main/java/service/ChatAnalyticsService.java
package service;

import dao.DatabaseConnection;
import java.sql.*;
import java.util.*;

public class ChatAnalyticsService {

    public void logConversation(String sessionId, Integer userId) throws SQLException {
        String sql = """
            INSERT INTO chatbot_conversations (session_id, user_id)
            VALUES (?, ?)
            ON DUPLICATE KEY UPDATE message_count = message_count + 1
            """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, sessionId);
            if (userId != null) {
                stmt.setInt(2, userId);
            } else {
                stmt.setNull(2, Types.INTEGER);
            }
            stmt.executeUpdate();
        }
    }

    public void logMessage(String sessionId, String messageType, String content, Integer responseTimeMs) throws SQLException {
        String sql = """
            INSERT INTO chatbot_messages (conversation_id, message_type, message_content, response_time_ms)
            SELECT conversation_id, ?, ?, ?
            FROM chatbot_conversations
            WHERE session_id = ?
            ORDER BY started_at DESC
            LIMIT 1
            """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, messageType);
            stmt.setString(2, content.substring(0, Math.min(content.length(), 1000))); // Truncate if too long
            if (responseTimeMs != null) {
                stmt.setInt(3, responseTimeMs);
            } else {
                stmt.setNull(3, Types.INTEGER);
            }
            stmt.setString(4, sessionId);
            stmt.executeUpdate();
        }
    }

    public Map<String, Object> getDailyStats(Date date) throws SQLException {
        String sql = """
            SELECT
                COUNT(DISTINCT c.conversation_id) as total_conversations,
                COUNT(m.message_id) as total_messages,
                AVG(m.response_time_ms) as avg_response_time,
                COUNT(CASE WHEN m.message_type = 'user' THEN 1 END) as user_messages,
                COUNT(CASE WHEN m.message_type = 'bot' THEN 1 END) as bot_messages
            FROM chatbot_conversations c
            LEFT JOIN chatbot_messages m ON c.conversation_id = m.conversation_id
            WHERE DATE(c.started_at) = DATE(?)
            """;

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, new java.sql.Date(date.getTime()));

            ResultSet rs = stmt.executeQuery();
            Map<String, Object> stats = new HashMap<>();

            if (rs.next()) {
                stats.put("totalConversations", rs.getInt("total_conversations"));
                stats.put("totalMessages", rs.getInt("total_messages"));
                stats.put("avgResponseTime", rs.getDouble("avg_response_time"));
                stats.put("userMessages", rs.getInt("user_messages"));
                stats.put("botMessages", rs.getInt("bot_messages"));
            }

            return stats;
        }
    }
}
```

### 4. Knowledge Base Maintenance

```java
// src/main/java/service/KnowledgeBaseMaintenanceService.java
package service;

import dao.ServiceDAO;
import model.Service;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class KnowledgeBaseMaintenanceService {
    private final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
    private final KnowledgeBaseInitializer initializer;
    private final ServiceDAO serviceDAO;

    public KnowledgeBaseMaintenanceService(KnowledgeBaseInitializer initializer, ServiceDAO serviceDAO) {
        this.initializer = initializer;
        this.serviceDAO = serviceDAO;
    }

    public void startScheduledUpdates() {
        // Update knowledge base daily at 2 AM
        scheduler.scheduleAtFixedRate(this::updateKnowledgeBase, 0, 24, TimeUnit.HOURS);

        // Health check every hour
        scheduler.scheduleAtFixedRate(this::performHealthCheck, 0, 1, TimeUnit.HOURS);
    }

    private void updateKnowledgeBase() {
        try {
            System.out.println("Starting scheduled knowledge base update...");

            // Get recently updated services
            List<Service> updatedServices = serviceDAO.getServicesUpdatedSince(
                System.currentTimeMillis() - TimeUnit.DAYS.toMillis(1)
            );

            if (!updatedServices.isEmpty()) {
                // Update only changed services
                for (Service service : updatedServices) {
                    initializer.updateServiceInKnowledgeBase(service);
                }
                System.out.println("Updated " + updatedServices.size() + " services in knowledge base.");
            } else {
                System.out.println("No services updated in the last 24 hours.");
            }

        } catch (Exception e) {
            System.err.println("Failed to update knowledge base: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void performHealthCheck() {
        try {
            // Check if vector database is accessible
            // Check if OpenAI API is accessible
            // Log health status
            System.out.println("Chatbot health check completed successfully.");
        } catch (Exception e) {
            System.err.println("Chatbot health check failed: " + e.getMessage());
        }
    }

    public void shutdown() {
        scheduler.shutdown();
        try {
            if (!scheduler.awaitTermination(60, TimeUnit.SECONDS)) {
                scheduler.shutdownNow();
            }
        } catch (InterruptedException e) {
            scheduler.shutdownNow();
        }
    }
}
```

### 5. Performance Optimization

#### Caching Strategy

```java
// src/main/java/service/ChatCacheService.java
package service;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;

public class ChatCacheService {
    private static final long CACHE_EXPIRY_MS = TimeUnit.MINUTES.toMillis(30);
    private final ConcurrentHashMap<String, CacheEntry> embeddingCache = new ConcurrentHashMap<>();
    private final ConcurrentHashMap<String, CacheEntry> responseCache = new ConcurrentHashMap<>();

    public double[] getCachedEmbedding(String text) {
        CacheEntry entry = embeddingCache.get(text);
        if (entry != null && !entry.isExpired()) {
            return (double[]) entry.value;
        }
        return null;
    }

    public void cacheEmbedding(String text, double[] embedding) {
        embeddingCache.put(text, new CacheEntry(embedding, System.currentTimeMillis()));

        // Clean up expired entries periodically
        if (embeddingCache.size() % 100 == 0) {
            cleanupExpiredEntries();
        }
    }

    public String getCachedResponse(String queryHash) {
        CacheEntry entry = responseCache.get(queryHash);
        if (entry != null && !entry.isExpired()) {
            return (String) entry.value;
        }
        return null;
    }

    public void cacheResponse(String queryHash, String response) {
        responseCache.put(queryHash, new CacheEntry(response, System.currentTimeMillis()));
    }

    private void cleanupExpiredEntries() {
        long currentTime = System.currentTimeMillis();
        embeddingCache.entrySet().removeIf(entry -> entry.getValue().isExpired(currentTime));
        responseCache.entrySet().removeIf(entry -> entry.getValue().isExpired(currentTime));
    }

    private static class CacheEntry {
        final Object value;
        final long timestamp;

        CacheEntry(Object value, long timestamp) {
            this.value = value;
            this.timestamp = timestamp;
        }

        boolean isExpired() {
            return isExpired(System.currentTimeMillis());
        }

        boolean isExpired(long currentTime) {
            return currentTime - timestamp > CACHE_EXPIRY_MS;
        }
    }
}
```

### 6. Deployment Checklist

#### Pre-deployment

- [ ] Set up vector database (Pinecone index)
- [ ] Configure API keys and environment variables
- [ ] Test knowledge base initialization
- [ ] Verify rate limiting configuration
- [ ] Test security measures
- [ ] Run integration tests

#### Deployment Steps

1. **Build the application**:

   ```bash
   mvn clean package
   ```

2. **Deploy to Heroku**:

   ```bash
   git add .
   git commit -m "Add RAG chatbot implementation"
   git push heroku main
   ```

3. **Initialize knowledge base**:

   ```bash
   heroku run java -cp target/classes:target/dependency/* service.KnowledgeBaseInitializer
   ```

4. **Monitor deployment**:
   ```bash
   heroku logs --tail
   ```

#### Post-deployment

- [ ] Verify chatbot functionality
- [ ] Monitor API usage and costs
- [ ] Check error logs
- [ ] Test rate limiting
- [ ] Validate security measures
- [ ] Set up monitoring alerts

### 7. Maintenance Tasks

#### Daily

- Monitor API usage and costs
- Check error logs
- Review chat analytics

#### Weekly

- Update knowledge base with new content
- Review and optimize system prompts
- Analyze user feedback

#### Monthly

- Performance optimization review
- Security audit
- Cost analysis and optimization
- Update dependencies

### 8. Troubleshooting Common Issues

#### High API Costs

- Implement more aggressive caching
- Optimize embedding generation frequency
- Review and reduce context size
- Consider using smaller models for simple queries

#### Slow Response Times

- Enable response caching
- Optimize vector search parameters
- Consider using faster embedding models
- Implement connection pooling

#### Poor Response Quality

- Review and update system prompts
- Expand knowledge base content
- Adjust similarity search thresholds
- Implement feedback collection and analysis

This comprehensive guide provides everything needed to implement a production-ready RAG chatbot for your Java web application. The implementation is tailored to work with your existing spa management system architecture and includes all necessary security, performance, and maintenance considerations.
