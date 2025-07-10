/**
 * Spa Chatbot - AI Assistant for Spa Management System
 * Integrates with existing Tailwind CSS and Lucide icons
 */
class SpaChatbot {
    constructor() {
        this.messagesContainer = document.getElementById('chatbot-messages');
        this.inputField = document.getElementById('chatbot-input');
        this.sendButton = document.getElementById('chatbot-send');
        this.toggleButton = document.getElementById('chatbot-toggle');
        this.chatbotContainer = document.getElementById('chatbot-container');
        this.chatbotBody = document.getElementById('chatbot-body');
        this.charCount = document.getElementById('char-count');
        
        this.isMinimized = false;
        this.isLoading = false;
        
        if (this.messagesContainer && this.inputField && this.sendButton) {
            this.initializeEventListeners();
            this.loadChatHistory();
            this.setupAutoResize();
        } else {
            console.error('Chatbot elements not found');
        }
    }
    
    initializeEventListeners() {
        // Send message events
        this.sendButton.addEventListener('click', () => this.sendMessage());
        this.inputField.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                this.sendMessage();
            }
        });
        
        // Toggle chatbot
        this.toggleButton.addEventListener('click', () => this.toggleChat());
        
        // Character count
        this.inputField.addEventListener('input', () => this.updateCharCount());
        
        // Quick action buttons
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('quick-action-btn')) {
                const message = e.target.getAttribute('data-message');
                if (message) {
                    this.inputField.value = message;
                    this.updateCharCount();
                    this.sendMessage();
                }
            }
        });
        
        // Auto-scroll on new messages
        this.observeMessages();
    }
    
    setupAutoResize() {
        this.inputField.addEventListener('input', () => {
            this.inputField.style.height = 'auto';
            const newHeight = Math.min(this.inputField.scrollHeight, 80);
            this.inputField.style.height = newHeight + 'px';
        });
    }
    
    updateCharCount() {
        const count = this.inputField.value.length;
        this.charCount.textContent = count;
        
        // Change color based on character count
        if (count > 450) {
            this.charCount.className = 'text-red-500';
        } else if (count > 400) {
            this.charCount.className = 'text-yellow-500';
        } else {
            this.charCount.className = 'text-gray-400';
        }
    }
    
    async sendMessage() {
        const message = this.inputField.value.trim();
        if (!message || this.isLoading) return;
        
        // Validate message length
        if (message.length > 500) {
            this.showError('Tin nhắn quá dài. Vui lòng nhập tối đa 500 ký tự.');
            return;
        }
        
        // Set loading state
        this.setLoadingState(true);
        
        // Add user message
        this.addMessage(message, 'user');
        
        // Clear input
        this.inputField.value = '';
        this.updateCharCount();
        this.inputField.style.height = 'auto';
        
        // Show typing indicator
        this.showTypingIndicator();
        
        try {
            const response = await this.callChatAPI(message);
            this.hideTypingIndicator();
            
            if (response.error) {
                this.addMessage(response.error, 'bot', true);
            } else {
                this.addMessage(response.response || response.message, 'bot');
                this.saveChatHistory();
            }
        } catch (error) {
            this.hideTypingIndicator();
            console.error('Chat error:', error);
            this.addMessage('Xin lỗi, tôi đang gặp sự cố kỹ thuật. Vui lòng thử lại sau.', 'bot', true);
        } finally {
            this.setLoadingState(false);
        }
    }
    
    async callChatAPI(message) {
        const response = await fetch(`${window.location.origin}${window.location.pathname.split('/')[1] ? '/' + window.location.pathname.split('/')[1] : ''}/api/chat`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify({ message })
        });
        
        if (!response.ok) {
            if (response.status === 429) {
                throw new Error('Bạn đã gửi quá nhiều tin nhắn. Vui lòng chờ một chút.');
            } else if (response.status === 400) {
                throw new Error('Tin nhắn không hợp lệ.');
            } else {
                throw new Error('Không thể kết nối đến server.');
            }
        }
        
        return await response.json();
    }
    
    addMessage(text, sender, isError = false) {
        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${sender}-message flex items-start space-x-2`;
        
        if (sender === 'user') {
            messageDiv.className += ' flex-row-reverse space-x-reverse';
        }
        
        const iconDiv = document.createElement('div');
        iconDiv.className = `w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 mt-1 ${
            sender === 'user' ? 'bg-primary' : 'bg-primary'
        }`;
        
        const icon = document.createElement('i');
        icon.setAttribute('data-lucide', sender === 'user' ? 'user' : 'sparkles');
        icon.className = 'h-3 w-3 text-white';
        iconDiv.appendChild(icon);
        
        const contentDiv = document.createElement('div');
        contentDiv.className = `message-content rounded-lg px-3 py-2 shadow-sm border max-w-xs ${
            sender === 'user' 
                ? 'bg-gradient-to-r from-primary to-primary-dark text-white rounded-tr-sm' 
                : isError 
                    ? 'bg-red-50 border-red-200 text-red-700 rounded-tl-sm'
                    : 'bg-white border-gray-200 text-spa-dark rounded-tl-sm'
        }`;
        
        const textP = document.createElement('p');
        textP.className = 'text-sm';
        textP.innerHTML = this.formatMessage(text);
        
        const timeDiv = document.createElement('div');
        timeDiv.className = `text-xs mt-1 ${sender === 'user' ? 'text-white/70' : 'text-gray-500'}`;
        timeDiv.textContent = new Date().toLocaleTimeString('vi-VN', { 
            hour: '2-digit', 
            minute: '2-digit' 
        });
        
        contentDiv.appendChild(textP);
        contentDiv.appendChild(timeDiv);
        
        messageDiv.appendChild(iconDiv);
        messageDiv.appendChild(contentDiv);
        
        this.messagesContainer.appendChild(messageDiv);
        
        // Initialize Lucide icons for new message
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
        
        this.scrollToBottom();
    }
    
    formatMessage(text) {
        // Basic formatting for common patterns
        return text
            .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
            .replace(/\*(.*?)\*/g, '<em>$1</em>')
            .replace(/`(.*?)`/g, '<code class="bg-gray-100 px-1 rounded text-xs">$1</code>')
            .replace(/\n/g, '<br>');
    }
    
    showTypingIndicator() {
        const indicator = document.createElement('div');
        indicator.id = 'typing-indicator';
        indicator.className = 'message bot-message flex items-start space-x-2';
        
        indicator.innerHTML = `
            <div class="w-6 h-6 bg-primary rounded-full flex items-center justify-center flex-shrink-0 mt-1">
                <i data-lucide="sparkles" class="h-3 w-3 text-white"></i>
            </div>
            <div class="bg-white rounded-lg rounded-tl-sm px-3 py-2 shadow-sm border">
                <div class="typing-indicator flex items-center space-x-2">
                    <div class="typing-dots flex space-x-1">
                        <span></span>
                        <span></span>
                        <span></span>
                    </div>
                    <span class="text-xs text-gray-500">Đang trả lời...</span>
                </div>
            </div>
        `;
        
        this.messagesContainer.appendChild(indicator);
        
        // Initialize Lucide icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
        
        this.scrollToBottom();
    }
    
    hideTypingIndicator() {
        const indicator = document.getElementById('typing-indicator');
        if (indicator) {
            indicator.remove();
        }
    }
    
    setLoadingState(loading) {
        this.isLoading = loading;
        this.sendButton.disabled = loading;
        this.inputField.disabled = loading;
        
        if (loading) {
            this.chatbotContainer.classList.add('chatbot-loading');
        } else {
            this.chatbotContainer.classList.remove('chatbot-loading');
        }
    }
    
    toggleChat() {
        this.isMinimized = !this.isMinimized;
        
        if (this.isMinimized) {
            this.chatbotContainer.classList.add('chatbot-minimized');
            this.toggleButton.innerHTML = '<i data-lucide="plus" class="h-4 w-4"></i>';
        } else {
            this.chatbotContainer.classList.remove('chatbot-minimized');
            this.toggleButton.innerHTML = '<i data-lucide="minus" class="h-4 w-4"></i>';
        }
        
        // Reinitialize icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
        
        // Save state
        localStorage.setItem('spa-chatbot-minimized', this.isMinimized);
    }
    
    scrollToBottom() {
        setTimeout(() => {
            this.messagesContainer.scrollTop = this.messagesContainer.scrollHeight;
        }, 100);
    }
    
    observeMessages() {
        const observer = new MutationObserver(() => {
            this.scrollToBottom();
        });
        
        observer.observe(this.messagesContainer, {
            childList: true,
            subtree: true
        });
    }
    
    showError(message) {
        this.addMessage(message, 'bot', true);
    }
    
    saveChatHistory() {
        try {
            const messages = Array.from(this.messagesContainer.children)
                .filter(el => el.classList.contains('message') && !el.id)
                .slice(-10) // Keep only last 10 messages
                .map(el => {
                    const isUser = el.classList.contains('user-message');
                    const textContent = el.querySelector('.message-content p').textContent;
                    return {
                        text: textContent,
                        sender: isUser ? 'user' : 'bot',
                        timestamp: Date.now()
                    };
                });
            
            localStorage.setItem('spa-chatbot-history', JSON.stringify(messages));
        } catch (error) {
            console.warn('Failed to save chat history:', error);
        }
    }
    
    loadChatHistory() {
        try {
            const history = JSON.parse(localStorage.getItem('spa-chatbot-history') || '[]');
            const minimized = localStorage.getItem('spa-chatbot-minimized') === 'true';
            
            // Load previous messages (skip if there's already a welcome message)
            if (history.length > 0 && this.messagesContainer.children.length <= 1) {
                history.forEach(msg => {
                    if (msg.text && msg.sender) {
                        this.addMessage(msg.text, msg.sender);
                    }
                });
            }
            
            // Restore minimized state
            if (minimized) {
                this.isMinimized = true;
                this.chatbotContainer.classList.add('chatbot-minimized');
                this.toggleButton.innerHTML = '<i data-lucide="plus" class="h-4 w-4"></i>';
                
                // Reinitialize icons
                if (typeof lucide !== 'undefined') {
                    lucide.createIcons();
                }
            }
        } catch (error) {
            console.warn('Failed to load chat history:', error);
        }
    }
}

// Auto-initialize when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        window.spaChatbot = new SpaChatbot();
    });
} else {
    window.spaChatbot = new SpaChatbot();
}
