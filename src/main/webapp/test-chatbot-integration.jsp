<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Chatbot Integration - Spa Hương Sen</title>
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: "#D4AF37",
                        "primary-dark": "#B8941F",
                        secondary: "#FADADD",
                        "spa-cream": "#FFF8F0",
                        "spa-dark": "#333333",
                    }
                }
            }
        };
    </script>
    
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
</head>
<body class="bg-spa-cream min-h-screen">
    <div class="container mx-auto px-4 py-8">
        <div class="max-w-4xl mx-auto">
            <h1 class="text-3xl font-bold text-spa-dark mb-6 text-center">
                🤖 Chatbot Integration Test
            </h1>
            
            <div class="bg-white rounded-lg shadow-lg p-6 mb-6">
                <h2 class="text-xl font-semibold text-spa-dark mb-4">Integration Status</h2>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <!-- API Health Check -->
                    <div class="border rounded-lg p-4">
                        <h3 class="font-semibold text-gray-700 mb-2">Python API Health</h3>
                        <div id="api-status" class="text-sm">
                            <span class="text-yellow-600">Checking...</span>
                        </div>
                        <button id="check-api-btn" class="mt-2 px-3 py-1 bg-primary text-white rounded text-sm hover:bg-primary-dark">
                            Check API
                        </button>
                    </div>
                    
                    <!-- Java Servlet Test -->
                    <div class="border rounded-lg p-4">
                        <h3 class="font-semibold text-gray-700 mb-2">Java Servlet</h3>
                        <div id="servlet-status" class="text-sm">
                            <span class="text-yellow-600">Ready to test</span>
                        </div>
                        <button id="test-servlet-btn" class="mt-2 px-3 py-1 bg-primary text-white rounded text-sm hover:bg-primary-dark">
                            Test Servlet
                        </button>
                    </div>
                </div>
            </div>
            
            <div class="bg-white rounded-lg shadow-lg p-6 mb-6">
                <h2 class="text-xl font-semibold text-spa-dark mb-4">Quick Test</h2>
                <div class="flex gap-2 mb-4">
                    <input id="test-message" type="text" placeholder="Nhập tin nhắn test..." 
                           class="flex-1 border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-primary">
                    <button id="send-test-btn" class="px-4 py-2 bg-primary text-white rounded hover:bg-primary-dark">
                        Gửi
                    </button>
                </div>
                <div id="test-response" class="bg-gray-50 border rounded p-3 min-h-[100px] text-sm">
                    <em class="text-gray-500">Phản hồi sẽ hiển thị ở đây...</em>
                </div>
            </div>
            
            <div class="bg-white rounded-lg shadow-lg p-6">
                <h2 class="text-xl font-semibold text-spa-dark mb-4">Instructions</h2>
                <ol class="list-decimal list-inside space-y-2 text-gray-700">
                    <li>Đảm bảo Python chatbot API đang chạy trên localhost:8000</li>
                    <li>Kiểm tra trạng thái API bằng nút "Check API"</li>
                    <li>Test Java servlet integration bằng nút "Test Servlet"</li>
                    <li>Thử gửi tin nhắn test để kiểm tra toàn bộ flow</li>
                    <li>Nếu mọi thứ hoạt động, chatbot bubble trên homepage sẽ sử dụng AI thực</li>
                </ol>
            </div>
        </div>
    </div>
    
    <!-- Global Configuration -->
    <script>
        window.spaConfig = {
            contextPath: '${pageContext.request.contextPath}',
            apiEndpoint: '${pageContext.request.contextPath}/api/chat'
        };
    </script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            lucide.createIcons();
            
            const apiStatusEl = document.getElementById('api-status');
            const servletStatusEl = document.getElementById('servlet-status');
            const testResponseEl = document.getElementById('test-response');
            const testMessageInput = document.getElementById('test-message');
            
            // Check API Health
            document.getElementById('check-api-btn').addEventListener('click', async function() {
                apiStatusEl.innerHTML = '<span class="text-yellow-600">Checking...</span>';
                
                try {
                    const response = await fetch(window.spaConfig.apiEndpoint + '?action=health');
                    const data = await response.json();
                    
                    if (data.success && data.status === 'healthy') {
                        apiStatusEl.innerHTML = '<span class="text-green-600">✅ Healthy</span>';
                    } else {
                        apiStatusEl.innerHTML = '<span class="text-red-600">❌ Unhealthy</span>';
                    }
                } catch (error) {
                    apiStatusEl.innerHTML = '<span class="text-red-600">❌ Error: ' + error.message + '</span>';
                }
            });
            
            // Test Servlet
            document.getElementById('test-servlet-btn').addEventListener('click', async function() {
                servletStatusEl.innerHTML = '<span class="text-yellow-600">Testing...</span>';
                
                try {
                    const response = await fetch(window.spaConfig.apiEndpoint, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            message: 'Test connection',
                            sessionId: 'test-' + Date.now()
                        })
                    });
                    
                    if (response.ok) {
                        servletStatusEl.innerHTML = '<span class="text-green-600">✅ Working</span>';
                    } else {
                        servletStatusEl.innerHTML = '<span class="text-red-600">❌ Error: ' + response.status + '</span>';
                    }
                } catch (error) {
                    servletStatusEl.innerHTML = '<span class="text-red-600">❌ Error: ' + error.message + '</span>';
                }
            });
            
            // Send Test Message
            document.getElementById('send-test-btn').addEventListener('click', async function() {
                const message = testMessageInput.value.trim();
                if (!message) return;
                
                testResponseEl.innerHTML = '<em class="text-yellow-600">Đang gửi...</em>';
                
                try {
                    const response = await fetch(window.spaConfig.apiEndpoint, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            message: message,
                            sessionId: 'test-' + Date.now()
                        })
                    });
                    
                    const data = await response.json();
                    
                    if (data.success) {
                        testResponseEl.innerHTML = '<strong>Bot:</strong> ' + data.response;
                    } else {
                        testResponseEl.innerHTML = '<span class="text-red-600">Error: ' + (data.error || 'Unknown error') + '</span>';
                    }
                } catch (error) {
                    testResponseEl.innerHTML = '<span class="text-red-600">Error: ' + error.message + '</span>';
                }
                
                testMessageInput.value = '';
            });
            
            // Enter key support
            testMessageInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    document.getElementById('send-test-btn').click();
                }
            });
            
            // Auto-check API on load
            document.getElementById('check-api-btn').click();
        });
    </script>
</body>
</html>
