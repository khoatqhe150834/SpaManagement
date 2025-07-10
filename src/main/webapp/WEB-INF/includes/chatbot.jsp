<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- AI Chatbot Interface -->
<div id="chatbot-container" class="fixed bottom-6 right-6 w-80 max-w-sm bg-white rounded-xl shadow-2xl border border-gray-200 z-50 transition-all duration-300 ease-out transform">
    <!-- Chatbot Header -->
    <div id="chatbot-header" class="bg-gradient-to-r from-primary to-primary-dark text-white px-6 py-4 rounded-t-xl cursor-pointer select-none">
        <div class="flex items-center justify-between">
            <div class="flex items-center space-x-3">
                <div class="w-8 h-8 bg-white/20 rounded-full flex items-center justify-center">
                    <i data-lucide="message-circle" class="h-5 w-5"></i>
                </div>
                <div>
                    <h4 class="font-semibold text-sm">Trợ lý Spa</h4>
                    <p class="text-xs text-white/80">Hỗ trợ 24/7</p>
                </div>
            </div>
            <button id="chatbot-toggle" class="w-8 h-8 bg-white/20 hover:bg-white/30 rounded-full flex items-center justify-center transition-colors duration-200">
                <i data-lucide="minus" class="h-4 w-4"></i>
            </button>
        </div>
    </div>

    <!-- Chatbot Body -->
    <div id="chatbot-body" class="flex flex-col h-96">
        <!-- Messages Container -->
        <div id="chatbot-messages" class="flex-1 p-4 overflow-y-auto space-y-3 bg-spa-cream/30">
            <!-- Welcome Message -->
            <div class="message bot-message flex items-start space-x-2">
                <div class="w-6 h-6 bg-primary rounded-full flex items-center justify-center flex-shrink-0 mt-1">
                    <i data-lucide="sparkles" class="h-3 w-3 text-white"></i>
                </div>
                <div class="bg-white rounded-lg rounded-tl-sm px-3 py-2 shadow-sm border max-w-xs">
                    <p class="text-sm text-spa-dark">
                        <c:choose>
                            <c:when test="${not empty sessionScope.customer}">
                                Xin chào ${sessionScope.customer.fullName}! Tôi là trợ lý AI của Spa Hương Sen. Tôi có thể giúp bạn tìm hiểu về dịch vụ, đặt lịch và giải đáp thắc mắc. Bạn cần hỗ trợ gì hôm nay?
                            </c:when>
                            <c:when test="${not empty sessionScope.user}">
                                Xin chào ${sessionScope.user.fullName}! Tôi là trợ lý AI của Spa Hương Sen. Tôi có thể giúp bạn về thông tin dịch vụ và chính sách spa. Bạn cần hỗ trợ gì?
                            </c:when>
                            <c:otherwise>
                                Xin chào! Tôi là trợ lý AI của Spa Hương Sen. Tôi có thể giúp bạn tìm hiểu về dịch vụ, giá cả và chính sách của spa. Bạn muốn biết điều gì?
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <div class="text-xs text-gray-500 mt-1">
                        <fmt:formatDate value="<%= new java.util.Date() %>" pattern="HH:mm"/>
                    </div>
                </div>
            </div>
        </div>

        <!-- Input Container -->
        <div id="chatbot-input-container" class="p-4 border-t border-gray-100 bg-white rounded-b-xl">
            <div class="flex items-end space-x-2">
                <div class="flex-1 relative">
                    <textarea 
                        id="chatbot-input" 
                        placeholder="Nhập câu hỏi của bạn..." 
                        maxlength="500"
                        rows="1"
                        class="w-full px-3 py-2 border border-gray-300 rounded-lg resize-none focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary text-sm transition-all duration-200"
                        style="min-height: 36px; max-height: 80px;"
                    ></textarea>
                    <div class="absolute bottom-1 right-1 text-xs text-gray-400">
                        <span id="char-count">0</span>/500
                    </div>
                </div>
                <button 
                    id="chatbot-send" 
                    class="w-9 h-9 bg-primary hover:bg-primary-dark text-white rounded-lg flex items-center justify-center transition-all duration-200 transform hover:scale-105 disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none"
                >
                    <i data-lucide="send" class="h-4 w-4"></i>
                </button>
            </div>
            
            <!-- Quick Actions -->
            <div class="mt-3 flex flex-wrap gap-2">
                <button class="quick-action-btn text-xs px-2 py-1 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-full transition-colors duration-200" data-message="Dịch vụ nào phổ biến nhất?">
                    Dịch vụ phổ biến
                </button>
                <button class="quick-action-btn text-xs px-2 py-1 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-full transition-colors duration-200" data-message="Giá cả như thế nào?">
                    Bảng giá
                </button>
                <button class="quick-action-btn text-xs px-2 py-1 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-full transition-colors duration-200" data-message="Làm thế nào để đặt lịch?">
                    Đặt lịch
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Chatbot Styles -->
<style>
/* Custom scrollbar for messages */
#chatbot-messages::-webkit-scrollbar {
    width: 4px;
}

#chatbot-messages::-webkit-scrollbar-track {
    background: transparent;
}

#chatbot-messages::-webkit-scrollbar-thumb {
    background: #D4AF37;
    border-radius: 2px;
}

#chatbot-messages::-webkit-scrollbar-thumb:hover {
    background: #B8941F;
}

/* Message animations */
.message {
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

/* User message styling */
.user-message {
    flex-direction: row-reverse;
}

.user-message .message-content {
    background: linear-gradient(135deg, #D4AF37 0%, #B8941F 100%);
    color: white;
    border-radius: 12px;
    border-top-right-radius: 4px;
}

/* Typing indicator */
.typing-indicator {
    display: flex;
    align-items: center;
    space-x-2;
}

.typing-dots {
    display: flex;
    space-x-1;
}

.typing-dots span {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background: #D4AF37;
    animation: typing 1.4s infinite ease-in-out;
}

.typing-dots span:nth-child(1) { animation-delay: -0.32s; }
.typing-dots span:nth-child(2) { animation-delay: -0.16s; }
.typing-dots span:nth-child(3) { animation-delay: 0s; }

@keyframes typing {
    0%, 80%, 100% { 
        transform: scale(0.8);
        opacity: 0.5;
    }
    40% { 
        transform: scale(1);
        opacity: 1;
    }
}

/* Minimized state */
.chatbot-minimized {
    height: auto !important;
}

.chatbot-minimized #chatbot-body {
    display: none;
}

/* Mobile responsive */
@media (max-width: 640px) {
    #chatbot-container {
        width: calc(100vw - 2rem);
        right: 1rem;
        left: 1rem;
        max-width: none;
    }
    
    #chatbot-body {
        height: 320px;
    }
}

/* Error message styling */
.error-message .message-content {
    background: #fee2e2;
    border: 1px solid #fecaca;
    color: #dc2626;
}

/* Loading state */
.chatbot-loading #chatbot-send {
    pointer-events: none;
}

.chatbot-loading #chatbot-send i {
    animation: spin 1s linear infinite;
}

@keyframes spin {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
}
</style>

<!-- Chatbot JavaScript -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Initialize Lucide icons for the chatbot
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }
    
    // Initialize chatbot after a short delay to ensure all elements are ready
    setTimeout(function() {
        if (typeof SpaChatbot !== 'undefined') {
            new SpaChatbot();
        } else {
            console.warn('SpaChatbot class not found. Make sure chatbot.js is loaded.');
        }
    }, 100);
});
</script>

<!-- Load Chatbot JavaScript -->
<script src="<c:url value='/js/chatbot.js'/>"></script>
