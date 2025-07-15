<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="utils.ChatbotClient" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.charset.StandardCharsets" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Simple API Test</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-50 min-h-screen p-8">
    <div class="max-w-4xl mx-auto">
        <h1 class="text-3xl font-bold text-gray-900 mb-6">🔍 Simple API Test</h1>
        
        <div class="bg-white rounded-lg shadow p-6 mb-6">
            <h2 class="text-xl font-semibold mb-4">ChatbotClient Test Results</h2>
            
            <%
                // Test 1: Health Check
                out.println("<h3 class='font-medium mb-2'>1. Health Check:</h3>");
                try {
                    boolean isHealthy = ChatbotClient.isHealthy();
                    if (isHealthy) {
                        out.println("<div class='p-3 bg-green-50 text-green-800 rounded mb-4'>");
                        out.println("<p>✅ Health check PASSED</p>");
                        out.println("</div>");
                    } else {
                        out.println("<div class='p-3 bg-red-50 text-red-800 rounded mb-4'>");
                        out.println("<p>❌ Health check FAILED</p>");
                        out.println("</div>");
                    }
                } catch (Exception e) {
                    out.println("<div class='p-3 bg-red-50 text-red-800 rounded mb-4'>");
                    out.println("<p>❌ Health check exception: " + e.getMessage() + "</p>");
                    out.println("</div>");
                }
                
                // Test 2: Send Message
                out.println("<h3 class='font-medium mb-2'>2. Send Message:</h3>");
                try {
                    String sessionId = ChatbotClient.generateSessionId();
                    String botResponse = ChatbotClient.sendMessage("Hello, this is a test message", sessionId);
                    
                    out.println("<div class='p-3 bg-green-50 text-green-800 rounded mb-4'>");
                    out.println("<p>✅ Message sent successfully</p>");
                    out.println("<p><strong>Session ID:</strong> " + sessionId + "</p>");
                    out.println("<p><strong>Bot Response:</strong> " + botResponse + "</p>");
                    out.println("</div>");
                } catch (Exception e) {
                    out.println("<div class='p-3 bg-red-50 text-red-800 rounded mb-4'>");
                    out.println("<p>❌ Send message exception: " + e.getMessage() + "</p>");
                    out.println("</div>");
                }
                
                // Test 3: System Info
                out.println("<h3 class='font-medium mb-2'>3. System Info:</h3>");
                try {
                    String systemInfo = ChatbotClient.getSystemInfo();
                    if (systemInfo != null) {
                        out.println("<div class='p-3 bg-blue-50 text-blue-800 rounded mb-4'>");
                        out.println("<p>✅ System info retrieved</p>");
                        out.println("<pre class='text-xs mt-2 overflow-auto bg-gray-100 p-2 rounded'>" + systemInfo + "</pre>");
                        out.println("</div>");
                    } else {
                        out.println("<div class='p-3 bg-yellow-50 text-yellow-800 rounded mb-4'>");
                        out.println("<p>⚠️ System info is null</p>");
                        out.println("</div>");
                    }
                } catch (Exception e) {
                    out.println("<div class='p-3 bg-red-50 text-red-800 rounded mb-4'>");
                    out.println("<p>❌ System info exception: " + e.getMessage() + "</p>");
                    out.println("</div>");
                }
            %>
        </div>
        
        <div class="bg-white rounded-lg shadow p-6 mb-6">
            <h2 class="text-xl font-semibold mb-4">Raw HTTP Test</h2>
            
            <%
                // Raw HTTP test to localhost:8000/health
                out.println("<h3 class='font-medium mb-2'>Direct HTTP to localhost:8000/health:</h3>");
                try {
                    URL url = new URL("http://localhost:8000/health");
                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                    conn.setRequestMethod("GET");
                    conn.setConnectTimeout(10000);
                    conn.setReadTimeout(10000);
                    
                    int responseCode = conn.getResponseCode();
                    String responseMessage = conn.getResponseMessage();
                    
                    // Read response body
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
                    
                    if (responseCode == 200) {
                        out.println("<div class='p-3 bg-green-50 text-green-800 rounded mb-4'>");
                        out.println("<p>✅ Direct HTTP SUCCESS</p>");
                        out.println("<p><strong>Response Code:</strong> " + responseCode + "</p>");
                        out.println("<p><strong>Response Message:</strong> " + responseMessage + "</p>");
                        out.println("<p><strong>Response Body:</strong></p>");
                        out.println("<pre class='text-xs mt-2 bg-gray-100 p-2 rounded overflow-auto'>" + responseBody.toString() + "</pre>");
                        out.println("</div>");
                    } else {
                        out.println("<div class='p-3 bg-red-50 text-red-800 rounded mb-4'>");
                        out.println("<p>❌ Direct HTTP FAILED</p>");
                        out.println("<p><strong>Response Code:</strong> " + responseCode + "</p>");
                        out.println("<p><strong>Response Message:</strong> " + responseMessage + "</p>");
                        out.println("<p><strong>Error Body:</strong></p>");
                        out.println("<pre class='text-xs mt-2 bg-gray-100 p-2 rounded overflow-auto'>" + responseBody.toString() + "</pre>");
                        out.println("</div>");
                    }
                    
                } catch (Exception e) {
                    out.println("<div class='p-3 bg-red-50 text-red-800 rounded mb-4'>");
                    out.println("<p>❌ Direct HTTP exception: " + e.getClass().getSimpleName() + ": " + e.getMessage() + "</p>");
                    out.println("</div>");
                }
            %>
        </div>
        
        <div class="bg-white rounded-lg shadow p-6">
            <h2 class="text-xl font-semibold mb-4">Quick Actions</h2>
            
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <a href="${pageContext.request.contextPath}/chatbot" 
                   class="block p-4 bg-blue-50 hover:bg-blue-100 rounded-lg border border-blue-200 transition-colors text-center">
                    <h3 class="font-medium text-blue-900">Go to Chatbot</h3>
                    <p class="text-sm text-blue-700">/chatbot</p>
                </a>
                
                <a href="${pageContext.request.contextPath}/debug-chatbot.jsp" 
                   class="block p-4 bg-green-50 hover:bg-green-100 rounded-lg border border-green-200 transition-colors text-center">
                    <h3 class="font-medium text-green-900">Debug Page</h3>
                    <p class="text-sm text-green-700">/debug-chatbot.jsp</p>
                </a>
                
                <a href="javascript:location.reload()" 
                   class="block p-4 bg-yellow-50 hover:bg-yellow-100 rounded-lg border border-yellow-200 transition-colors text-center">
                    <h3 class="font-medium text-yellow-900">Refresh Test</h3>
                    <p class="text-sm text-yellow-700">Run tests again</p>
                </a>
            </div>
        </div>
        
        <div class="mt-6 p-4 bg-blue-50 border border-blue-200 rounded-lg">
            <h3 class="font-medium text-blue-800 mb-2">💡 What to Look For:</h3>
            <ul class="list-disc list-inside text-sm text-blue-700 space-y-1">
                <li><strong>Health Check:</strong> Should show ✅ PASSED if Docker container is healthy</li>
                <li><strong>Send Message:</strong> Should return actual AI response, not "false"</li>
                <li><strong>System Info:</strong> Should show JSON with system details</li>
                <li><strong>Direct HTTP:</strong> Should show 200 response with JSON health data</li>
            </ul>
        </div>
    </div>
</body>
</html>
