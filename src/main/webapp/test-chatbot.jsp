<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="utils.ChatbotClient" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Chatbot - Spa Hương Sen</title>
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#8B5A3C',
                        secondary: '#D4A574',
                        accent: '#F5E6D3'
                    }
                }
            }
        }
    </script>
    
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
    
    <style>
        .message-animation {
            animation: slideIn 0.3s ease-out;
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .typing-indicator {
            animation: pulse 1.5s infinite;
        }
    </style>
</head>

<body class="bg-gray-50 min-h-screen">
    <div class="container mx-auto px-4 py-8">
        <!-- Header -->
        <div class="text-center mb-8">
            <h1 class="text-4xl font-bold text-gray-900 mb-2">
                🧪 Test Chatbot AI
            </h1>
            <p class="text-gray-600 mb-4">
                Kiểm tra kết nối và chức năng chatbot AI cho Spa Hương Sen
            </p>
            
            <!-- API Status Check -->
            <div class="bg-white rounded-lg shadow p-6 mb-6">
                <h2 class="text-xl font-semibold mb-4">🔍 Kiểm tra trạng thái API</h2>
                
                <%
                    // Test API connection
                    boolean isApiHealthy = false;
                    String healthStatus = "Đang kiểm tra...";
                    String healthColor = "yellow";
                    
                    try {
                        isApiHealthy = ChatbotClient.isHealthy();
                        if (isApiHealthy) {
                            healthStatus = "✅ API hoạt động bình thường";
                            healthColor = "green";
                        } else {
                            healthStatus = "❌ API không phản hồi";
                            healthColor = "red";
                        }
                    } catch (Exception e) {
                        healthStatus = "⚠️ Lỗi kết nối: " + e.getMessage();
                        healthColor = "red";
                    }
                %>
                
                <div class="p-4 rounded-lg <%= healthColor.equals("green") ? "bg-green-100 text-green-800" : 
                                                healthColor.equals("red") ? "bg-red-100 text-red-800" : 
                                                "bg-yellow-100 text-yellow-800" %>">
                    <p class="font-medium"><%= healthStatus %></p>
                    <p class="text-sm mt-1">API Endpoint: http://localhost:8000</p>
                    <p class="text-sm">Thời gian kiểm tra: <%= new java.util.Date() %></p>
                </div>
                
                <!-- System Info -->
                <%
                    String systemInfo = ChatbotClient.getSystemInfo();
                    if (systemInfo != null) {
                %>
                <div class="mt-4 p-3 bg-blue-50 rounded-lg">
                    <h3 class="font-medium text-blue-800 mb-2">📊 Thông tin hệ thống:</h3>
                    <pre class="text-xs text-blue-700 overflow-auto"><%= systemInfo %></pre>
                </div>
                <% } %>
            </div>
        </div>
        
        <!-- Chat Test Interface -->
        <div class="max-w-4xl mx-auto">
            <div class="bg-white rounded-xl shadow-lg overflow-hidden">
                <!-- Chat Header -->
                <div class="bg-gradient-to-r from-primary to-secondary text-white p-4">
                    <div class="flex items-center">
                        <div class="w-10 h-10 bg-white/20 rounded-full flex items-center justify-center mr-3">
                            <i data-lucide="bot" class="w-6 h-6"></i>
                        </div>
                        <div>
                            <h3 class="font-semibold">Test Chatbot AI</h3>
                            <p class="text-sm opacity-90">Kiểm tra chức năng trò chuyện</p>
                        </div>
                    </div>
                </div>
                
                <!-- Chat Messages -->
                <div id="chatMessages" class="h-96 p-6 overflow-y-auto bg-gray-50">
                    <!-- Welcome Message -->
                    <div class="flex items-start mb-4 message-animation">
                        <div class="w-8 h-8 bg-primary rounded-full flex items-center justify-center mr-3 flex-shrink-0">
                            <i data-lucide="bot" class="w-4 h-4 text-white"></i>
                        </div>
                        <div class="bg-white rounded-lg p-3 max-w-md shadow">
                            <p class="text-gray-800 text-sm">
                                🧪 Chào mừng đến với giao diện test chatbot!<br><br>
                                Hãy thử gửi một tin nhắn để kiểm tra kết nối với AI chatbot.<br><br>
                                Ví dụ: "Xin chào", "Spa có dịch vụ gì?", "Giá cả như thế nào?"
                            </p>
                        </div>
                    </div>
                </div>
                
                <!-- Chat Input -->
                <div class="border-t border-gray-200 p-4 bg-white">
                    <form id="testChatForm" class="flex items-center space-x-3">
                        <div class="flex-1">
                            <input 
                                type="text" 
                                id="testMessageInput" 
                                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary" 
                                placeholder="Nhập tin nhắn test..."
                                maxlength="500"
                                required
                            >
                        </div>
                        <button 
                            type="submit" 
                            id="testSendBtn"
                            class="bg-primary hover:bg-primary/90 text-white px-6 py-3 rounded-lg transition-colors flex items-center space-x-2"
                        >
                            <span>Test</span>
                            <i data-lucide="send" class="w-4 h-4"></i>
                        </button>
                    </form>
                </div>
            </div>
            
            <!-- Test Results -->
            <div id="testResults" class="mt-6 bg-white rounded-lg shadow p-6">
                <h3 class="text-lg font-semibold mb-4">📋 Kết quả test</h3>
                <div id="testLog" class="space-y-2 text-sm">
                    <p class="text-gray-600">Chưa có test nào được thực hiện...</p>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript for Testing -->
    <script>
        let testCount = 0;
        
        document.addEventListener('DOMContentLoaded', function() {
            lucide.createIcons();
            
            const form = document.getElementById('testChatForm');
            const input = document.getElementById('testMessageInput');
            const sendBtn = document.getElementById('testSendBtn');
            const chatMessages = document.getElementById('chatMessages');
            const testLog = document.getElementById('testLog');
            
            form.addEventListener('submit', async function(e) {
                e.preventDefault();
                
                const message = input.value.trim();
                if (!message) return;
                
                testCount++;
                const testId = `test-${testCount}`;
                
                // Add user message
                addMessage('user', message);
                
                // Clear input and disable button
                input.value = '';
                sendBtn.disabled = true;
                sendBtn.innerHTML = '<span>Đang test...</span><div class="animate-spin rounded-full h-4 w-4 border-b-2 border-white ml-2"></div>';
                
                // Show typing indicator
                showTypingIndicator();
                
                // Log test start
                logTest(testId, 'START', `Gửi tin nhắn: "${message}"`);
                
                try {
                    const startTime = Date.now();
                    
                    // Send to API
                    const formData = new FormData();
                    formData.append('message', message);
                    
                    const response = await fetch('${pageContext.request.contextPath}/api/chat', {
                        method: 'POST',
                        body: formData
                    });
                    
                    const endTime = Date.now();
                    const responseTime = endTime - startTime;
                    
                    hideTypingIndicator();
                    
                    if (response.ok) {
                        const data = await response.json();
                        
                        if (data.success) {
                            addMessage('bot', data.response);
                            logTest(testId, 'SUCCESS', `Phản hồi nhận được (${responseTime}ms): "${data.response.substring(0, 100)}${data.response.length > 100 ? '...' : ''}"`);
                        } else {
                            addMessage('bot', `Lỗi: ${data.error}`);
                            logTest(testId, 'ERROR', `API trả về lỗi: ${data.error}`);
                        }
                    } else {
                        const errorText = await response.text();
                        addMessage('bot', `Lỗi HTTP ${response.status}: ${errorText}`);
                        logTest(testId, 'ERROR', `HTTP ${response.status}: ${errorText}`);
                    }
                    
                } catch (error) {
                    hideTypingIndicator();
                    addMessage('bot', `Lỗi kết nối: ${error.message}`);
                    logTest(testId, 'ERROR', `Lỗi kết nối: ${error.message}`);
                } finally {
                    sendBtn.disabled = false;
                    sendBtn.innerHTML = '<span>Test</span><i data-lucide="send" class="w-4 h-4 ml-2"></i>';
                    lucide.createIcons(sendBtn);
                }
            });
        });
        
        function addMessage(sender, text) {
            const chatMessages = document.getElementById('chatMessages');
            const messageDiv = document.createElement('div');
            messageDiv.className = `flex items-start mb-4 message-animation ${sender === 'user' ? 'justify-end' : 'justify-start'}`;
            
            const timestamp = new Date().toLocaleTimeString('vi-VN');
            
            if (sender === 'user') {
                messageDiv.innerHTML = `
                    <div class="bg-primary text-white rounded-lg p-3 max-w-md mr-3 shadow">
                        <p class="text-sm">${escapeHtml(text)}</p>
                        <p class="text-xs mt-1 opacity-80">${timestamp}</p>
                    </div>
                    <div class="w-8 h-8 bg-secondary rounded-full flex items-center justify-center flex-shrink-0">
                        <i data-lucide="user" class="w-4 h-4 text-white"></i>
                    </div>
                `;
            } else {
                messageDiv.innerHTML = `
                    <div class="w-8 h-8 bg-primary rounded-full flex items-center justify-center mr-3 flex-shrink-0">
                        <i data-lucide="bot" class="w-4 h-4 text-white"></i>
                    </div>
                    <div class="bg-white rounded-lg p-3 max-w-md shadow">
                        <p class="text-gray-800 text-sm">${escapeHtml(text)}</p>
                        <p class="text-xs mt-1 text-gray-500">${timestamp}</p>
                    </div>
                `;
            }
            
            chatMessages.appendChild(messageDiv);
            lucide.createIcons(messageDiv);
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }
        
        function showTypingIndicator() {
            const chatMessages = document.getElementById('chatMessages');
            const typingDiv = document.createElement('div');
            typingDiv.id = 'typing-indicator';
            typingDiv.className = 'flex items-start mb-4 typing-indicator';
            typingDiv.innerHTML = `
                <div class="w-8 h-8 bg-primary rounded-full flex items-center justify-center mr-3 flex-shrink-0">
                    <i data-lucide="bot" class="w-4 h-4 text-white"></i>
                </div>
                <div class="bg-white rounded-lg p-3 shadow">
                    <div class="flex space-x-1">
                        <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce"></div>
                        <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 0.1s;"></div>
                        <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 0.2s;"></div>
                    </div>
                </div>
            `;
            
            chatMessages.appendChild(typingDiv);
            lucide.createIcons(typingDiv);
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }
        
        function hideTypingIndicator() {
            const typingDiv = document.getElementById('typing-indicator');
            if (typingDiv) {
                typingDiv.remove();
            }
        }
        
        function logTest(testId, status, message) {
            const testLog = document.getElementById('testLog');
            const timestamp = new Date().toLocaleTimeString('vi-VN');
            
            if (testCount === 1 && status === 'START') {
                testLog.innerHTML = ''; // Clear initial message
            }
            
            const logEntry = document.createElement('div');
            logEntry.className = `p-2 rounded ${
                status === 'SUCCESS' ? 'bg-green-50 text-green-800' :
                status === 'ERROR' ? 'bg-red-50 text-red-800' :
                'bg-blue-50 text-blue-800'
            }`;
            logEntry.innerHTML = `
                <span class="font-mono text-xs">[${timestamp}]</span>
                <span class="font-medium">${testId}</span>
                <span class="px-2 py-1 rounded text-xs ${
                    status === 'SUCCESS' ? 'bg-green-200' :
                    status === 'ERROR' ? 'bg-red-200' :
                    'bg-blue-200'
                }">${status}</span>
                <span>${message}</span>
            `;
            
            testLog.appendChild(logEntry);
            testLog.scrollTop = testLog.scrollHeight;
        }
        
        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
    </script>
</body>
</html>
