<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="utils.ChatbotClient" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trợ Lý AI - Spa Hương Sen</title>
    
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
    
    <!-- Custom Styles -->
    <style>
        .chat-container {
            height: calc(100vh - 200px);
            min-height: 500px;
        }
        
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
        
        .chat-input:focus {
            outline: none;
            ring: 2px;
            ring-color: #8B5A3C;
        }
        
        .scrollbar-hide {
            -ms-overflow-style: none;
            scrollbar-width: none;
        }
        
        .scrollbar-hide::-webkit-scrollbar {
            display: none;
        }
    </style>
</head>

<body class="bg-gray-50">
    <!-- Include Header -->
    <jsp:include page="common/header.jsp" />
    
    <!-- Main Content -->
    <main class="pt-20 pb-8">
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
            <!-- Page Header -->
            <div class="text-center mb-8">
                <h1 class="text-3xl font-bold text-gray-900 mb-2">
                    🌸 Trợ Lý AI Spa Hương Sen
                </h1>
                <p class="text-gray-600">
                    Tôi có thể giúp bạn tư vấn về dịch vụ spa, giá cả, và đặt lịch hẹn
                </p>
                
                <!-- Health Status -->
                <div id="healthStatus" class="mt-4 inline-flex items-center px-3 py-1 rounded-full text-sm">
                    <div class="animate-spin rounded-full h-4 w-4 border-b-2 border-primary mr-2"></div>
                    Đang kiểm tra kết nối...
                </div>
            </div>
            
            <!-- Chat Container -->
            <div class="bg-white rounded-xl shadow-lg overflow-hidden chat-container">
                <!-- Chat Header -->
                <div class="bg-gradient-to-r from-primary to-secondary text-white p-4">
                    <div class="flex items-center justify-between">
                        <div class="flex items-center">
                            <div class="w-10 h-10 bg-white/20 rounded-full flex items-center justify-center mr-3">
                                <i data-lucide="bot" class="w-6 h-6"></i>
                            </div>
                            <div>
                                <h3 class="font-semibold">Trợ Lý AI</h3>
                                <p class="text-sm opacity-90">Luôn sẵn sàng hỗ trợ bạn</p>
                            </div>
                        </div>
                        <button id="clearChatBtn" class="p-2 hover:bg-white/20 rounded-lg transition-colors" title="Xóa cuộc trò chuyện">
                            <i data-lucide="trash-2" class="w-5 h-5"></i>
                        </button>
                    </div>
                </div>
                
                <!-- Chat Messages -->
                <div id="chatMessages" class="flex-1 p-6 overflow-y-auto scrollbar-hide" style="height: calc(100% - 140px);">
                    <!-- Welcome Message -->
                    <div class="flex items-start mb-4 message-animation">
                        <div class="w-8 h-8 bg-primary rounded-full flex items-center justify-center mr-3 flex-shrink-0">
                            <i data-lucide="bot" class="w-4 h-4 text-white"></i>
                        </div>
                        <div class="bg-gray-100 rounded-lg p-3 max-w-xs lg:max-w-md">
                            <p class="text-gray-800">
                                🌸 Xin chào! Tôi là trợ lý AI của Spa Hương Sen. Tôi có thể giúp bạn:
                                <br><br>
                                • Tư vấn về các dịch vụ spa<br>
                                • Thông tin giá cả và khuyến mãi<br>
                                • Hướng dẫn đặt lịch hẹn<br>
                                • Giải đáp thắc mắc về spa<br>
                                <br>
                                Bạn cần hỗ trợ gì hôm nay?
                            </p>
                        </div>
                    </div>
                </div>
                
                <!-- Chat Input -->
                <div class="border-t border-gray-200 p-4">
                    <form id="chatForm" class="flex items-center space-x-3">
                        <div class="flex-1 relative">
                            <input 
                                type="text" 
                                id="messageInput" 
                                class="w-full px-4 py-3 border border-gray-300 rounded-lg chat-input focus:ring-primary focus:border-primary" 
                                placeholder="Nhập câu hỏi của bạn..."
                                maxlength="500"
                                required
                            >
                            <div id="charCount" class="absolute right-3 top-1/2 transform -translate-y-1/2 text-xs text-gray-400">
                                0/500
                            </div>
                        </div>
                        <button 
                            type="submit" 
                            id="sendBtn"
                            class="bg-primary hover:bg-primary/90 text-white px-6 py-3 rounded-lg transition-colors flex items-center space-x-2 disabled:opacity-50 disabled:cursor-not-allowed"
                        >
                            <span>Gửi</span>
                            <i data-lucide="send" class="w-4 h-4"></i>
                        </button>
                    </form>
                </div>
            </div>
            
            <!-- Quick Actions -->
            <div class="mt-6 grid grid-cols-2 md:grid-cols-4 gap-3">
                <button class="quick-action-btn p-3 bg-white rounded-lg shadow hover:shadow-md transition-shadow text-center" data-message="Spa có những dịch vụ gì?">
                    <i data-lucide="sparkles" class="w-6 h-6 text-primary mx-auto mb-1"></i>
                    <span class="text-sm text-gray-700">Dịch vụ spa</span>
                </button>
                <button class="quick-action-btn p-3 bg-white rounded-lg shadow hover:shadow-md transition-shadow text-center" data-message="Bảng giá dịch vụ như thế nào?">
                    <i data-lucide="dollar-sign" class="w-6 h-6 text-primary mx-auto mb-1"></i>
                    <span class="text-sm text-gray-700">Bảng giá</span>
                </button>
                <button class="quick-action-btn p-3 bg-white rounded-lg shadow hover:shadow-md transition-shadow text-center" data-message="Làm thế nào để đặt lịch hẹn?">
                    <i data-lucide="calendar" class="w-6 h-6 text-primary mx-auto mb-1"></i>
                    <span class="text-sm text-gray-700">Đặt lịch</span>
                </button>
                <button class="quick-action-btn p-3 bg-white rounded-lg shadow hover:shadow-md transition-shadow text-center" data-message="Spa có khuyến mãi gì không?">
                    <i data-lucide="gift" class="w-6 h-6 text-primary mx-auto mb-1"></i>
                    <span class="text-sm text-gray-700">Khuyến mãi</span>
                </button>
            </div>
        </div>
    </main>
    
    <!-- Include Footer -->
    <jsp:include page="common/footer.jsp" />
    
    <!-- Global Configuration -->
    <script>
        window.spaConfig = {
            contextPath: '${pageContext.request.contextPath}',
            apiEndpoint: '${pageContext.request.contextPath}/api/chat'
        };
    </script>
    
    <!-- Chatbot JavaScript -->
    <script src="${pageContext.request.contextPath}/js/chatbot.js"></script>
    
    <!-- Initialize Lucide Icons -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            lucide.createIcons();
        });
    </script>
</body>
</html>
