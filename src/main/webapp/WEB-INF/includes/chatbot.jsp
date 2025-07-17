<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    /* Chatbot resize styles */
    .resize-handle {
        background-color: transparent;
        transition: background-color 0.2s ease;
    }

    .resize-handle:hover {
        background-color: rgba(212, 175, 55, 0.2) !important;
    }

    .resizing {
        user-select: none;
        pointer-events: none;
    }

    .resizing .resize-handle {
        pointer-events: auto;
    }

    /* Improve corner handle visibility */
    .resize-handle-top-left,
    .resize-handle-top-right,
    .resize-handle-bottom-left,
    .resize-handle-bottom-right {
        border-radius: 2px;
    }

    .resize-handle-top-left:hover,
    .resize-handle-top-right:hover,
    .resize-handle-bottom-left:hover,
    .resize-handle-bottom-right:hover {
        background-color: rgba(212, 175, 55, 0.4) !important;
    }
</style>

<div id="chatbot-widget" class="fixed z-50">
    <!-- Chat Window (initially hidden) -->
    <div id="chat-window" class="fixed bottom-20 right-4 max-w-[calc(100vw-2rem)] transition-none transform scale-100 opacity-100" style="display: none; width: 384px; height: 480px; min-width: 300px; min-height: 350px; max-width: 600px; max-height: 700px;">
        <div class="bg-white rounded-lg shadow-2xl border border-gray-200 overflow-hidden h-full relative">
            <!-- Resize Handles -->
            <!-- Top resize handle -->
            <div class="resize-handle resize-handle-top absolute top-0 left-0 right-0 h-1 cursor-n-resize hover:bg-primary/20 transition-colors z-10"></div>
            <!-- Right resize handle -->
            <div class="resize-handle resize-handle-right absolute top-0 right-0 bottom-0 w-1 cursor-e-resize hover:bg-primary/20 transition-colors z-10"></div>
            <!-- Bottom resize handle -->
            <div class="resize-handle resize-handle-bottom absolute bottom-0 left-0 right-0 h-1 cursor-s-resize hover:bg-primary/20 transition-colors z-10"></div>
            <!-- Left resize handle -->
            <div class="resize-handle resize-handle-left absolute top-0 left-0 bottom-0 w-1 cursor-w-resize hover:bg-primary/20 transition-colors z-10"></div>
            <!-- Corner resize handles -->
            <div class="resize-handle resize-handle-top-left absolute top-0 left-0 w-3 h-3 cursor-nw-resize hover:bg-primary/30 transition-colors z-10"></div>
            <div class="resize-handle resize-handle-top-right absolute top-0 right-0 w-3 h-3 cursor-ne-resize hover:bg-primary/30 transition-colors z-10"></div>
            <div class="resize-handle resize-handle-bottom-left absolute bottom-0 left-0 w-3 h-3 cursor-sw-resize hover:bg-primary/30 transition-colors z-10"></div>
            <div class="resize-handle resize-handle-bottom-right absolute bottom-0 right-0 w-3 h-3 cursor-se-resize hover:bg-primary/30 transition-colors z-10"></div>

            <!-- Chat Content Container -->
            <div class="flex flex-col h-full">
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
            <div id="messages-area" class="flex-1 overflow-y-auto p-4 space-y-4 bg-gray-50">
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
            </div> <!-- Close flex container -->
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