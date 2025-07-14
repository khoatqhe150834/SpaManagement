<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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