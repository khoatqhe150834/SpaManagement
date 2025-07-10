// chatbot.js
document.addEventListener('DOMContentLoaded', () => {
    // State variables
    let isOpen = false;
    let isMinimized = false;
    let messages = [];
    let inputValue = '';
    let isTyping = false;
    let hasNewMessage = false;
    let showSuggestions = false;

    // DOM elements
    const chatWindow = document.getElementById('chat-window');
    const minimizedIndicator = document.getElementById('minimized-indicator');
    const toggleChatBtn = document.getElementById('toggle-chat-btn');
    const minimizeBtn = document.getElementById('minimize-btn');
    const closeBtn = document.getElementById('close-btn');
    const messagesArea = document.getElementById('messages-area');
    const chatInput = document.getElementById('chat-input');
    const sendBtn = document.getElementById('send-btn');
    const toggleSuggestionsBtn = document.getElementById('toggle-suggestions-btn');
    const suggestionsArea = document.getElementById('suggestions-area');
    const suggestionsList = document.getElementById('suggestions-list');
    const clearChatBtn = document.getElementById('clear-chat-btn');
    const newMessageDot = document.getElementById('new-message-dot');
    const notificationBadge = document.getElementById('notification-badge');
    const messagesEndRef = messagesArea.querySelector('[ref="messagesEndRef"]');

    // Predefined responses
    const botResponses = {
        greeting: [
            'Xin chào! Tôi là trợ lý ảo của Spa Hương Sen. Tôi có thể giúp gì cho bạn hôm nay?',
            'Chào bạn! Rất vui được hỗ trợ bạn. Bạn cần tư vấn về dịch vụ nào?',
            'Xin chào! Chào mừng bạn đến với Spa Hương Sen. Tôi có thể hỗ trợ bạn như thế nào?'
        ],
        services: [
            'Chúng tôi có các dịch vụ chính: Massage thư giãn, Chăm sóc da mặt, Tắm trắng, và các gói combo cao cấp. Bạn quan tâm đến dịch vụ nào?',
            'Spa Hương Sen cung cấp đa dạng dịch vụ từ massage, chăm sóc da đến tắm trắng. Bạn muốn tìm hiểu chi tiết về dịch vụ nào?'
        ],
        booking: [
            'Để đặt lịch, bạn có thể click vào nút "Đặt lịch ngay" trên website hoặc gọi hotline 0901 234 567. Bạn muốn đặt lịch cho dịch vụ nào?',
            'Bạn có thể đặt lịch trực tuyến qua website hoặc gọi điện cho chúng tôi. Thời gian nào thuận tiện cho bạn?'
        ],
        price: [
            'Giá dịch vụ của chúng tôi từ 199.000đ - 1.299.000đ tùy theo loại dịch vụ. Bạn quan tâm đến dịch vụ nào để tôi báo giá cụ thể?',
            'Chúng tôi có nhiều mức giá phù hợp với nhu cầu. Massage từ 399.000đ, chăm sóc da từ 299.000đ. Bạn cần tư vấn gì thêm?'
        ],
        location: [
            'Spa Hương Sen tọa lạc tại 123 Nguyễn Văn Linh, Quận 7, TP.HCM. Chúng tôi mở cửa từ 8:00 - 21:00 hàng ngày.',
            'Địa chỉ của chúng tôi: 123 Nguyễn Văn Linh, Quận 7, TP.HCM. Gần chợ Tân Mỹ, rất dễ tìm!'
        ],
        promotion: [
            'Hiện tại chúng tôi có ưu đãi giảm 30% cho khách hàng mới và nhiều chương trình khuyến mãi hấp dẫn khác. Bạn muốn biết thêm chi tiết?',
            'Chúng tôi thường xuyên có các chương trình ưu đãi. Bạn có thể xem mục "Ưu đãi" trên website để cập nhật khuyến mãi mới nhất!'
        ],
        default: [
            'Tôi hiểu bạn đang quan tâm đến điều này. Bạn có thể liên hệ trực tiếp với chúng tôi qua hotline 0901 234 567 để được tư vấn chi tiết hơn.',
            'Cảm ơn câu hỏi của bạn. Để được hỗ trợ tốt nhất, bạn có thể gọi cho chúng tôi hoặc đến trực tiếp spa để được tư vấn.',
            'Tôi sẽ chuyển câu hỏi này đến đội ngũ tư vấn chuyên nghiệp. Bạn có thể liên hệ 0901 234 567 để được hỗ trợ ngay.'
        ]
    };

    // Initialize with welcome message
    const initWelcomeMessage = () => {
        const welcomeMessage = {
            id: Date.now().toString(),
            text: botResponses.greeting[0],
            sender: 'bot',
            timestamp: new Date()
        };
        messages = [welcomeMessage];
        renderMessages();
    };
    initWelcomeMessage();

    // Render messages
    function renderMessages() {
        messagesArea.innerHTML = '';
        messages.forEach(message => {
            const messageDiv = document.createElement('div');
            messageDiv.className = `flex ${message.sender === 'user' ? 'justify-end' : 'justify-start'}`;
            messageDiv.innerHTML = `
                <div class="flex items-start space-x-2 max-w-[80%]">
                    <div class="flex-shrink-0 w-8 h-8 rounded-full ${message.sender === 'user' ? 'bg-[#D4AF37] flex items-center justify-center' : 'bg-white border-2 border-[#D4AF37] flex items-center justify-center'}">
                        <i data-lucide="${message.sender === 'user' ? 'user' : 'bot'}" class="h-4 w-4 ${message.sender === 'user' ? 'text-white' : 'text-[#D4AF37]'}"></i>
                    </div>
                    <div class="rounded-lg p-3 ${message.sender === 'user' ? 'bg-[#D4AF37] text-white' : 'bg-white border border-gray-200 text-gray-800'}">
                        <p class="text-sm leading-relaxed">${message.text}</p>
                        <p class="text-xs mt-1 ${message.sender === 'user' ? 'text-white/80' : 'text-gray-500'}">
                            ${formatTime(message.timestamp)}
                        </p>
                    </div>
                </div>
            `;
            messagesArea.appendChild(messageDiv);
        });
        lucide.createIcons(messagesArea);
        scrollToBottom();
    }

    // Render typing indicator
    function renderTypingIndicator(show) {
        let typingDiv = document.getElementById('typing-indicator');
        if (show) {
            if (!typingDiv) {
                typingDiv = document.createElement('div');
                typingDiv.id = 'typing-indicator';
                typingDiv.className = 'flex justify-start';
                typingDiv.innerHTML = `
                    <div class="flex items-start space-x-2 max-w-[80%]">
                        <div class="flex-shrink-0 w-8 h-8 rounded-full bg-white border-2 border-[#D4AF37] flex items-center justify-center">
                            <i data-lucide="bot" class="h-4 w-4 text-[#D4AF37]"></i>
                        </div>
                        <div class="bg-white border border-gray-200 rounded-lg p-3">
                            <div class="flex space-x-1">
                                <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce"></div>
                                <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 0.1s;"></div>
                                <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 0.2s;"></div>
                            </div>
                        </div>
                    </div>
                `;
                messagesArea.appendChild(typingDiv);
                lucide.createIcons(typingDiv);
            }
        } else if (typingDiv) {
            typingDiv.remove();
        }
        scrollToBottom();
    }

    // Scroll to bottom
    function scrollToBottom() {
        messagesArea.scrollTo({
            top: messagesArea.scrollHeight,
            behavior: 'smooth'
        });
    }

    // Format time
    function formatTime(date) {
        return date.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' });
    }

    // Get random response
    function getRandomResponse(responses) {
        return responses[Math.floor(Math.random() * responses.length)];
    }

    // Generate bot response
    function generateBotResponse(userMessage) {
        const message = userMessage.toLowerCase();
        if (message.includes('xin chào') || message.includes('chào') || message.includes('hello') || message.includes('hi')) {
            return getRandomResponse(botResponses.greeting);
        }
        if (message.includes('dịch vụ') || message.includes('massage') || message.includes('chăm sóc') || message.includes('tắm trắng')) {
            return getRandomResponse(botResponses.services);
        }
        if (message.includes('đặt lịch') || message.includes('book') || message.includes('hẹn') || message.includes('lịch')) {
            return getRandomResponse(botResponses.booking);
        }
        if (message.includes('giá') || message.includes('bao nhiêu') || message.includes('tiền') || message.includes('cost') || message.includes('price')) {
            return getRandomResponse(botResponses.price);
        }
        if (message.includes('địa chỉ') || message.includes('ở đâu') || message.includes('location') || message.includes('address')) {
            return getRandomResponse(botResponses.location);
        }
        if (message.includes('khuyến mãi') || message.includes('ưu đãi') || message.includes('giảm giá') || message.includes('promotion')) {
            return getRandomResponse(botResponses.promotion);
        }
        return getRandomResponse(botResponses.default);
    }

    // Handle send message
    async function handleSendMessage() {
        inputValue = chatInput.value.trim();
        if (!inputValue) return;

        const userMessage = {
            id: Date.now().toString(),
            text: inputValue,
            sender: 'user',
            timestamp: new Date()
        };
        messages.push(userMessage);
        renderMessages();
        chatInput.value = '';
        isTyping = true;
        renderTypingIndicator(true);
        sendBtn.disabled = true;

        setTimeout(() => {
            const botResponse = generateBotResponse(userMessage.text);
            const botMessage = {
                id: (Date.now() + 1).toString(),
                text: botResponse,
                sender: 'bot',
                timestamp: new Date()
            };
            messages.push(botMessage);
            renderMessages();
            isTyping = false;
            renderTypingIndicator(false);
            sendBtn.disabled = false;

            if (isMinimized) {
                hasNewMessage = true;
                newMessageDot.style.display = 'block';
            }
        }, 1000 + Math.random() * 1000);
    }

    // Handle key press
    function handleKeyPress(e) {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            handleSendMessage();
        }
    }

    // Get suggested questions
    function getSuggestedQuestions() {
        const lastUserMessage = messages.filter(m => m.sender === 'user').pop();
        if (!lastUserMessage) {
            return [
                'Spa có những dịch vụ gì?',
                'Làm thế nào để đặt lịch hẹn?',
                'Spa ở đâu và mở cửa lúc nào?'
            ];
        }
        const lastUserText = lastUserMessage.text.toLowerCase();
        if (lastUserText.includes('dịch vụ') || lastUserText.includes('massage') || lastUserText.includes('chăm sóc')) {
            return [
                'Massage thư giãn có giá bao nhiêu?',
                'Dịch vụ chăm sóc da mặt như thế nào?',
                'Có gói combo nào tiết kiệm không?',
                'Thời gian thực hiện mỗi dịch vụ?'
            ];
        }
        if (lastUserText.includes('giá') || lastUserText.includes('tiền') || lastUserText.includes('cost')) {
            return [
                'Có chương trình khuyến mãi nào không?',
                'Thanh toán như thế nào?',
                'Có giảm giá cho khách hàng thường xuyên?',
                'Gói combo có rẻ hơn không?'
            ];
        }
        if (lastUserText.includes('đặt lịch') || lastUserText.includes('book') || lastUserText.includes('hẹn')) {
            return [
                'Cần đặt lịch trước bao lâu?',
                'Có thể hủy lịch hẹn không?',
                'Spa mở cửa những giờ nào?',
                'Có thể đặt lịch online không?'
            ];
        }
        if (lastUserText.includes('địa chỉ') || lastUserText.includes('ở đâu') || lastUserText.includes('location')) {
            return [
                'Có chỗ đậu xe không?',
                'Đi xe bus tuyến nào đến spa?',
                'Spa có gần trung tâm thương mại nào?',
                'Có thể gọi taxi đến spa không?'
            ];
        }
        return [
            'Tôi muốn tư vấn dịch vụ phù hợp',
            'Có ưu đãi gì cho khách hàng mới?',
            'Nhân viên có kinh nghiệm không?',
            'Spa có đảm bảo vệ sinh an toàn?'
        ];
    }

    // Render suggestions
    function renderSuggestions() {
        suggestionsList.innerHTML = '';
        getSuggestedQuestions().forEach((question, index) => {
            const btn = document.createElement('button');
            btn.className = 'w-full text-left p-2.5 bg-white border border-gray-200 rounded-lg hover:bg-[#FFF8F0] hover:border-[#D4AF37] transition-all duration-200 text-sm leading-relaxed';
            btn.innerHTML = `<span class="block overflow-hidden" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;">${question}</span>`;
            btn.onclick = () => handleSuggestedQuestionClick(question);
            suggestionsList.appendChild(btn);
        });
    }

    // Handle suggested question click
    function handleSuggestedQuestionClick(question) {
        chatInput.value = question;
        setTimeout(() => {
            const userMessage = {
                id: Date.now().toString(),
                text: question,
                sender: 'user',
                timestamp: new Date()
            };
            messages.push(userMessage);
            renderMessages();
            chatInput.value = '';
            isTyping = true;
            renderTypingIndicator(true);
            sendBtn.disabled = true;

            setTimeout(() => {
                const botResponse = generateBotResponse(question);
                const botMessage = {
                    id: (Date.now() + 1).toString(),
                    text: botResponse,
                    sender: 'bot',
                    timestamp: new Date()
                };
                messages.push(botMessage);
                renderMessages();
                isTyping = false;
                renderTypingIndicator(false);
                sendBtn.disabled = false;

                if (isMinimized) {
                    hasNewMessage = true;
                    newMessageDot.style.display = 'block';
                }
            }, 1000 + Math.random() * 1000);
        }, 100);
    }

    // Toggle chat
    function toggleChat() {
        isOpen = !isOpen;
        isMinimized = false;
        hasNewMessage = false;
        newMessageDot.style.display = 'none';
        notificationBadge.style.display = 'none';
        if (isOpen) {
            chatWindow.style.display = 'block';
            minimizedIndicator.style.display = 'none';
            toggleChatBtn.innerHTML = `<i data-lucide="x" class="h-6 w-6 transition-transform group-hover:rotate-90"></i>`;
            toggleChatBtn.setAttribute('aria-label', 'Đóng chat');
            toggleChatBtn.classList.add('scale-90');
            toggleChatBtn.classList.remove('hover:scale-110');
            chatInput.focus();
            renderMessages();
            renderSuggestions();
        } else {
            chatWindow.style.display = 'none';
            minimizedIndicator.style.display = 'none';
            toggleChatBtn.innerHTML = `<i data-lucide="message-circle" class="h-6 w-6 transition-transform group-hover:scale-110"></i><div class="absolute inset-0 rounded-full bg-[#D4AF37] animate-ping opacity-20"></div>`;
            toggleChatBtn.setAttribute('aria-label', 'Mở chat');
            toggleChatBtn.classList.remove('scale-90');
            toggleChatBtn.classList.add('hover:scale-110');
        }
        lucide.createIcons(toggleChatBtn);
    }

    // Minimize chat
    function minimizeChat() {
        isMinimized = true;
        chatWindow.style.display = 'none';
        minimizedIndicator.style.display = 'block';
    }

    // Maximize chat
    function maximizeChat() {
        isMinimized = false;
        hasNewMessage = false;
        newMessageDot.style.display = 'none';
        chatWindow.style.display = 'block';
        minimizedIndicator.style.display = 'none';
        scrollToBottom();
        chatInput.focus();
    }

    // Handle clear chat
    function handleClearChat() {
        if (confirm('Bạn có chắc chắn muốn xóa toàn bộ lịch sử chat? Hành động này không thể hoàn tác.')) {
            initWelcomeMessage();
            renderMessages();
            renderSuggestions();
            const notification = document.createElement('div');
            notification.className = 'fixed top-4 right-4 z-50 p-4 rounded-lg bg-green-500 text-white font-medium';
            notification.textContent = 'Đã xóa lịch sử chat thành công';
            document.body.appendChild(notification);
            setTimeout(() => notification.remove(), 3000);
        }
    }

    // Toggle suggestions
    function toggleSuggestions() {
        showSuggestions = !showSuggestions;
        if (showSuggestions) {
            suggestionsArea.style.display = 'block';
            toggleSuggestionsBtn.classList.add('bg-[#D4AF37]', 'text-white');
            toggleSuggestionsBtn.classList.remove('bg-gray-100', 'text-gray-600', 'hover:bg-gray-200');
            toggleSuggestionsBtn.innerHTML = `<i data-lucide="message-circle" class="h-4 w-4 mr-2"></i>Ẩn gợi ý<i data-lucide="chevron-down" class="h-4 w-4 ml-1 transition-transform duration-200 rotate-180"></i>`;
            toggleSuggestionsBtn.title = 'Ẩn gợi ý';
            renderSuggestions();
        } else {
            suggestionsArea.style.display = 'none';
            toggleSuggestionsBtn.classList.remove('bg-[#D4AF37]', 'text-white');
            toggleSuggestionsBtn.classList.add('bg-gray-100', 'text-gray-600', 'hover:bg-gray-200');
            toggleSuggestionsBtn.innerHTML = `<i data-lucide="message-circle" class="h-4 w-4 mr-2"></i>Hiện gợi ý<i data-lucide="chevron-down" class="h-4 w-4 ml-1 transition-transform duration-200"></i>`;
            toggleSuggestionsBtn.title = 'Hiện gợi ý';
        }
        lucide.createIcons(toggleSuggestionsBtn);
    }

    // Event listeners
    toggleChatBtn.addEventListener('click', toggleChat);
    minimizeBtn.addEventListener('click', minimizeChat);
    closeBtn.addEventListener('click', toggleChat);
    minimizedIndicator.addEventListener('click', maximizeChat);
    sendBtn.addEventListener('click', handleSendMessage);
    chatInput.addEventListener('keypress', handleKeyPress);
    toggleSuggestionsBtn.addEventListener('click', toggleSuggestions);
    clearChatBtn.addEventListener('click', handleClearChat);

    // Initial render
    renderSuggestions();
});