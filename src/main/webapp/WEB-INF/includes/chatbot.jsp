<!-- chatbot.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chatbot Widget</title>
    <!-- Assuming you have Lucide icons via CDN or local; adjust as needed -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
    <script src="chatbot.js" defer></script>
    <style>
        /* Add any necessary CSS here if not using Tailwind; for simplicity, assuming Tailwind or inline styles.
           But since original uses Tailwind classes, you may need to include Tailwind CDN or compile it.
           For this example, I'll use inline styles mimicking the structure. */
        .fixed { position: fixed; }
        .z-50 { z-index: 50; }
        .bottom-20 { bottom: 5rem; }
        .right-4 { right: 1rem; }
        .w-96 { width: 24rem; }
        .max-w-[calc(100vw-2rem)] { max-width: calc(100vw - 2rem); }
        .transition-all { transition: all 0.3s; }
        .duration-300 { transition-duration: 300ms; }
        .ease-in-out { transition-timing-function: ease-in-out; }
        .transform { transform: translate(0); }
        .scale-100 { transform: scale(1); }
        .opacity-100 { opacity: 1; }
        .scale-95 { transform: scale(0.95); }
        .opacity-0 { opacity: 0; }
        .pointer-events-none { pointer-events: none; }
        .bg-white { background-color: white; }
        .rounded-lg { border-radius: 0.5rem; }
        .shadow-2xl { box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -2px rgba(0,0,0,0.05); }
        .border { border-width: 1px; }
        .border-gray-200 { border-color: rgb(229,231,235); }
        .overflow-hidden { overflow: hidden; }
        .bg-gradient-to-r { background: linear-gradient(to right, #D4AF37, #B8941F); }
        .from-[#D4AF37] { }
        .to-[#B8941F] { }
        .p-4 { padding: 1rem; }
        .flex { display: flex; }
        .items-center { align-items: center; }
        .justify-between { justify-content: space-between; }
        .rounded-full { border-radius: 9999px; }
        .p-2 { padding: 0.5rem; }
        .mr-3 { margin-right: 0.75rem; }
        .text-white { color: white; }
        .font-semibold { font-weight: 600; }
        .text-sm { font-size: 0.875rem; }
        .text-white\/80 { color: rgba(255,255,255,0.8); }
        .text-xs { font-size: 0.75rem; }
        .space-x-2 > * + * { margin-left: 0.5rem; }
        .hover\:text-white:hover { color: white; }
        .transition-colors { transition: color 0.2s; }
        .p-1 { padding: 0.25rem; }
        .h-4 { height: 1rem; }
        .w-4 { width: 1rem; }
        .h-48 { height: 12rem; }
        .overflow-y-auto { overflow-y: auto; }
        .space-y-4 > * + * { margin-top: 1rem; }
        .bg-gray-50 { background-color: rgb(249,250,251); }
        .justify-end { justify-content: flex-end; }
        .justify-start { justify-content: flex-start; }
        .space-x-2 > * + * { margin-left: 0.5rem; }
        .flex-shrink-0 { flex-shrink: 0; }
        .w-8 { width: 2rem; }
        .h-8 { height: 2rem; }
        .bg-[#D4AF37] { background-color: #D4AF37; }
        .text-white { color: white; }
        .border-2 { border-width: 2px; }
        .border-[#D4AF37] { border-color: #D4AF37; }
        .max-w-[80%] { max-width: 80%; }
        .p-3 { padding: 0.75rem; }
        .text-gray-800 { color: rgb(31,41,55); }
        .leading-relaxed { line-height: 1.625; }
        .mt-1 { margin-top: 0.25rem; }
        .text-gray-500 { color: rgb(107,114,128); }
        .text-white\/80 { color: rgba(255,255,255,0.8); }
        .border-t { border-top-width: 1px; }
        .bg-white { background-color: white; }
        .justify-between { justify-content: space-between; }
        .mb-3 { margin-bottom: 0.75rem; }
        .px-3 { padding-left: 0.75rem; padding-right: 0.75rem; }
        .py-2 { padding-top: 0.5rem; padding-bottom: 0.5rem; }
        .font-medium { font-weight: 500; }
        .transition-all { transition: all 0.2s; }
        .duration-200 { transition-duration: 200ms; }
        .bg-[#D4AF37] { background-color: #D4AF37; }
        .text-white { color: white; }
        .bg-gray-100 { background-color: rgb(243,244,246); }
        .text-gray-600 { color: rgb(75,85,99); }
        .hover\:bg-gray-200:hover { background-color: rgb(229,231,235); }
        .mr-2 { margin-right: 0.5rem; }
        .ml-1 { margin-left: 0.25rem; }
        .rotate-180 { transform: rotate(180deg); }
        .text-gray-500 { color: rgb(107,114,128); }
        .hover\:text-red-500:hover { color: rgb(239,68,68); }
        .hover\:bg-red-50:hover { background-color: rgb(254,242,242); }
        .mr-1 { margin-right: 0.25rem; }
        .animate-in { animation: fadeIn 0.2s; }
        .slide-in-from-top-2 { }
        .text-gray-700 { color: rgb(55,65,81); }
        .mb-3 { margin-bottom: 0.75rem; }
        .space-y-1\.5 > * + * { margin-top: 0.375rem; }
        .text-left { text-align: left; }
        .p-2\.5 { padding: 0.625rem; }
        .bg-white { background-color: white; }
        .border-gray-200 { border-color: rgb(229,231,235); }
        .hover\:bg-[#FFF8F0]:hover { background-color: #FFF8F0; }
        .hover\:border-[#D4AF37]:hover { border-color: #D4AF37; }
        .leading-relaxed { line-height: 1.625; }
        .flex-1 { flex: 1; }
        .border-gray-300 { border-color: rgb(209,213,219); }
        .px-4 { padding-left: 1rem; padding-right: 1rem; }
        .py-2 { padding-top: 0.5rem; padding-bottom: 0.5rem; }
        .focus\:outline-none:focus { outline: none; }
        .focus\:ring-2:focus { box-shadow: 0 0 0 2px #D4AF37; }
        .focus\:border-transparent:focus { border-color: transparent; }
        .text-sm { font-size: 0.875rem; }
        .bg-[#D4AF37] { background-color: #D4AF37; }
        .text-white { color: white; }
        .p-2 { padding: 0.5rem; }
        .hover\:bg-[#B8941F]:hover { background-color: #B8941F; }
        .disabled\:opacity-50:disabled { opacity: 0.5; }
        .disabled\:cursor-not-allowed:disabled { cursor: not-allowed; }
        .text-xs { font-size: 0.75rem; }
        .text-gray-500 { color: rgb(107,114,128); }
        .mt-1\.5 { margin-top: 0.375rem; }
        .text-center { text-align: center; }
        .bottom-4 { bottom: 1rem; }
        .w-14 { width: 3.5rem; }
        .h-14 { height: 3.5rem; }
        .shadow-lg { box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -1px rgba(0,0,0,0.06); }
        .hover\:shadow-xl:hover { box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04); }
        .group:hover .group-hover\:rotate-90 { transform: rotate(90deg); }
        .group:hover .group-hover\:scale-110 { transform: scale(1.1); }
        .absolute { position: absolute; }
        .-top-1 { top: -0.25rem; }
        .-right-1 { right: -0.25rem; }
        .w-4 { width: 1rem; }
        .h-4 { height: 1rem; }
        .bg-red-500 { background-color: rgb(239,68,68); }
        .animate-pulse { animation: pulse 1s infinite; }
        .inset-0 { top: 0; right: 0; bottom: 0; left: 0; }
        .animate-ping { animation: ping 1s cubic-bezier(0,0,0.2,1) infinite; }
        .opacity-20 { opacity: 0.2; }
        .w-2 { width: 0.5rem; }
        .h-2 { height: 0.5rem; }
        .bg-gray-400 { background-color: rgb(156,163,175); }
        .animate-bounce { animation: bounce 1s infinite; }
        /* Add keyframes if needed */
        @keyframes bounce { 0%, 100% { transform: translateY(-25%); } 50% { transform: translateY(0); } }
        @keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.5; } }
        @keyframes ping { 75%, 100% { transform: scale(2); opacity: 0; } }
    </style>
</head>
<body>
    <div id="chatbot-widget" class="fixed z-50">
        <!-- Chat Window (initially hidden) -->
        <div id="chat-window" class="fixed bottom-20 right-4 w-96 max-w-[calc(100vw-2rem)] transition-all duration-300 ease-in-out transform scale-100 opacity-100" style="display: none;">
            <div class="bg-white rounded-lg shadow-2xl border border-gray-200 overflow-hidden">
                <!-- Chat Header -->
                <div class="bg-gradient-to-r from-[#D4AF37] to-[#B8941F] p-4 flex items-center justify-between">
                    <div class="flex items-center">
                        <div class="bg-white rounded-full p-2 mr-3">
                            <i data-lucide="bot" class="h-5 w-5 text-[#D4AF37]"></i>
                        </div>
                        <div>
                            <h3 class="text-white font-semibold text-sm">Trợ lý Spa Hương Sen</h3>
                            <p class="text-white/80 text-xs">Luôn sẵn sàng hỗ trợ bạn</p>
                        </div>
                    </div>
                    <div class="flex items-center space-x-2">
                        <button id="minimize-btn" class="text-white/80 hover:text-white transition-colors p-1" aria-label="Thu nhỏ chat">
                            <i data-lucide="minimize-2" class="h-4 w-4"></i>
                        </button>
                        <button id="close-btn" class="text-white/80 hover:text-white transition-colors p-1" aria-label="Đóng chat">
                            <i data-lucide="x" class="h-4 w-4"></i>
                        </button>
                    </div>
                </div>

                <!-- Messages Area -->
                <div id="messages-area" class="h-64 overflow-y-auto p-4 space-y-4 bg-gray-50">
                    <!-- Messages will be appended here -->
                    <div ref="messagesEndRef"></div>
                </div>

                <!-- Chat Controls -->
                <div class="border-t border-gray-200 p-3 bg-white">
                    <div class="flex items-center justify-between mb-3">
                        <button id="toggle-suggestions-btn" class="flex items-center px-3 py-2 rounded-lg text-sm font-medium transition-all duration-200 bg-gray-100 text-gray-600 hover:bg-gray-200" title="Hiện gợi ý">
                            <i data-lucide="message-circle" class="h-4 w-4 mr-2"></i>
                            Hiện gợi ý
                            <i data-lucide="chevron-down" class="h-4 w-4 ml-1 transition-transform duration-200"></i>
                        </button>
                        
                        <button id="clear-chat-btn" class="flex items-center px-3 py-2 text-gray-500 hover:text-red-500 hover:bg-red-50 rounded-lg transition-all duration-200 text-sm" title="Xóa lịch sử chat">
                            <i data-lucide="trash-2" class="h-4 w-4 mr-1"></i>
                            Xóa chat
                        </button>
                    </div>

                    <!-- Suggested Questions (initially hidden) -->
                    <div id="suggestions-area" class="bg-gray-50 border-t border-gray-200 p-3 animate-in slide-in-from-top-2 duration-200" style="display: none;">
                        <h4 class="text-sm font-medium text-gray-700 mb-3">Câu hỏi gợi ý:</h4>
                        <div id="suggestions-list" class="space-y-1.5">
                            <!-- Suggestions will be appended here -->
                        </div>
                    </div>

                    <!-- Input Area -->
                    <div class="p-3 border-t border-gray-200 bg-white">
                        <div class="flex space-x-2">
                            <input id="chat-input" type="text" placeholder="Nhập tin nhắn của bạn..." class="flex-1 border border-gray-300 rounded-full px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#D4AF37] focus:border-transparent text-sm" maxlength="500">
                            <button id="send-btn" class="bg-[#D4AF37] text-white rounded-full p-2 hover:bg-[#B8941F] transition-colors disabled:opacity-50 disabled:cursor-not-allowed" aria-label="Gửi tin nhắn">
                                <i data-lucide="send" class="h-4 w-4"></i>
                            </button>
                        </div>
                        <p class="text-xs text-gray-500 mt-1.5 text-center">
                            Nhấn Enter để gửi • Tối đa 500 ký tự
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Minimized Chat Indicator (initially hidden) -->
        <div id="minimized-indicator" class="fixed bottom-20 right-4 bg-white rounded-lg shadow-lg border border-gray-200 p-3 cursor-pointer hover:shadow-xl transition-shadow" style="display: none;">
            <div class="flex items-center space-x-2">
                <div class="bg-[#D4AF37] rounded-full p-1">
                    <i data-lucide="bot" class="h-4 w-4 text-white"></i>
                </div>
                <span class="text-sm font-medium text-gray-700">Trợ lý Spa</span>
                <div id="new-message-dot" class="w-2 h-2 bg-red-500 rounded-full animate-pulse" style="display: none;"></div>
            </div>
        </div>

        <!-- Chat Toggle Button -->
        <button id="toggle-chat-btn" class="fixed bottom-4 right-4 w-14 h-14 bg-gradient-to-r from-[#D4AF37] to-[#B8941F] text-white rounded-full shadow-lg hover:shadow-xl transition-all duration-300 flex items-center justify-center group scale-100 hover:scale-110" aria-label="Mở chat">
            <i data-lucide="message-circle" class="h-6 w-6 transition-transform group-hover:scale-110"></i>
            <div id="notification-badge" class="absolute -top-1 -right-1 w-4 h-4 bg-red-500 rounded-full flex items-center justify-center" style="display: none;">
                <div class="w-2 h-2 bg-white rounded-full animate-pulse"></div>
            </div>
            <div class="absolute inset-0 rounded-full bg-[#D4AF37] animate-ping opacity-20"></div>
        </button>
    </div>
    <script>
        // Initialize Lucide icons
        lucide.createIcons();
    </script>
</body>
</html>