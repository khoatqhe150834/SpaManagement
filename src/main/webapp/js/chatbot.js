// chatbot.js - Enhanced with Python API integration
document.addEventListener('DOMContentLoaded', () => {
    // State variables
    let isOpen = false;
    let isMinimized = false;
    let messages = [];
    let inputValue = '';
    let isTyping = false;
    let hasNewMessage = false;
    let showSuggestions = false;
    let sessionId = 'spa-' + Date.now() + '-' + Math.floor(Math.random() * 10000);
    let apiHealthy = false;

    // Drag resize state variables
    let isResizing = false;
    let resizeDirection = '';
    let startX = 0;
    let startY = 0;
    let startWidth = 0;
    let startHeight = 0;
    let startLeft = 0;
    let startTop = 0;

    // DOM elements with safety checks
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
    const messagesEndRef = messagesArea?.querySelector('[ref="messagesEndRef"]');

    // Check if all required elements exist
    const requiredElements = {
        chatWindow, toggleChatBtn, messagesArea, chatInput, sendBtn
    };

    const missingElements = Object.entries(requiredElements)
        .filter(([name, element]) => !element)
        .map(([name]) => name);

    if (missingElements.length > 0) {
        console.error('Missing required chatbot elements:', missingElements);
        return; // Exit if critical elements are missing
    }

    console.log('All chatbot DOM elements found successfully');

    // API Configuration
    const API_BASE_URL = window.location.origin + (window.spaConfig?.contextPath || '');
    const CHATBOT_API_URL = API_BASE_URL + '/api/chat';

    // Debug logging
    console.log('Chatbot initialized with config:', {
        API_BASE_URL,
        CHATBOT_API_URL,
        spaConfig: window.spaConfig,
        sessionId
    });

    // Check API health on initialization
    async function checkApiHealth() {
        console.log('Checking API health at:', CHATBOT_API_URL + '?action=health');
        try {
            const response = await fetch(CHATBOT_API_URL + '?action=health', {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                }
            });

            console.log('Health check response status:', response.status);

            if (response.ok) {
                const data = await response.json();
                apiHealthy = data.success && data.status === 'healthy';
                console.log('Chatbot API health check result:', {
                    healthy: apiHealthy,
                    data: data
                });
            } else {
                apiHealthy = false;
                console.warn('Chatbot API health check failed with status:', response.status);
            }
        } catch (error) {
            apiHealthy = false;
            console.error('Chatbot API health check error:', error);
        }
    }

    // Send message to Python API via Java servlet
    async function sendMessageToAPI(message) {
        console.log('Sending message to API:', { message, sessionId, url: CHATBOT_API_URL });
        try {
            const requestBody = {
                message: message,
                sessionId: sessionId
            };

            const response = await fetch(CHATBOT_API_URL, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(requestBody)
            });

            console.log('API response status:', response.status);

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const data = await response.json();
            console.log('API response data:', data);

            if (data.success && data.response) {
                return data.response;
            } else {
                throw new Error(data.error || 'Unknown error from API');
            }
        } catch (error) {
            console.error('Error sending message to API:', error);
            // Fallback to basic response
            return 'Xin lỗi, tôi đang gặp sự cố kỹ thuật. Bạn có thể liên hệ trực tiếp với chúng tôi qua hotline 0901 234 567 để được hỗ trợ.';
        }
    }

    // Initialize with welcome message
    const initWelcomeMessage = () => {
        const welcomeMessage = {
            id: Date.now().toString(),
            text: 'Xin chào! Tôi là trợ lý AI của Spa Hương Sen. Tôi có thể giúp bạn tư vấn về các dịch vụ spa, đặt lịch hẹn, và trả lời mọi câu hỏi về spa. Bạn cần hỗ trợ gì hôm nay?',
            sender: 'bot',
            timestamp: new Date()
        };
        messages = [welcomeMessage];
        renderMessages();
    };

    // Initialize the chatbot
    async function initializeChatbot() {
        await checkApiHealth();
        initWelcomeMessage();
    }

    initializeChatbot();

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
                    <div class="chat-message-bubble rounded-lg p-3 ${message.sender === 'user' ? 'bg-[#D4AF37] text-white' : 'bg-white border border-gray-200 text-gray-800'}">
                        <p class="chat-message-content text-sm leading-relaxed">${message.text}</p>
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

    // Generate bot response using API
    async function generateBotResponse(userMessage) {
        if (apiHealthy) {
            return await sendMessageToAPI(userMessage);
        } else {
            // Fallback responses when API is not available
            const message = userMessage.toLowerCase();
            if (message.includes('xin chào') || message.includes('chào') || message.includes('hello') || message.includes('hi')) {
                return 'Xin chào! Tôi là trợ lý AI của Spa Hương Sen. Hiện tại hệ thống đang bảo trì, bạn có thể liên hệ hotline 0901 234 567 để được hỗ trợ trực tiếp.';
            }
            return 'Xin lỗi, hệ thống chatbot đang tạm thời bảo trì. Bạn có thể liên hệ trực tiếp với chúng tôi qua hotline 0901 234 567 hoặc email info@spahuongsen.vn để được hỗ trợ.';
        }
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

        try {
            // Add a small delay for better UX
            await new Promise(resolve => setTimeout(resolve, 500));

            const botResponse = await generateBotResponse(userMessage.text);
            const botMessage = {
                id: (Date.now() + 1).toString(),
                text: botResponse,
                sender: 'bot',
                timestamp: new Date()
            };
            messages.push(botMessage);
            renderMessages();

            if (isMinimized) {
                hasNewMessage = true;
                newMessageDot.style.display = 'block';
            }
        } catch (error) {
            console.error('Error handling message:', error);
            const errorMessage = {
                id: (Date.now() + 1).toString(),
                text: 'Xin lỗi, đã có lỗi xảy ra. Vui lòng thử lại sau hoặc liên hệ hotline 0901 234 567.',
                sender: 'bot',
                timestamp: new Date()
            };
            messages.push(errorMessage);
            renderMessages();
        } finally {
            isTyping = false;
            renderTypingIndicator(false);
            sendBtn.disabled = false;
        }
    }

    // Handle key press
    function handleKeyPress(e) {
        if (e.key === 'Enter' && e.ctrlKey) {
            e.preventDefault();
            handleSendMessage();
        }
    }

    // Auto-resize textarea
    function autoResizeTextarea() {
        chatInput.style.height = 'auto';
        const scrollHeight = chatInput.scrollHeight;
        const maxHeight = 120; // max-h-[120px] from CSS
        const minHeight = 40;  // min-h-[40px] from CSS

        if (scrollHeight > maxHeight) {
            chatInput.style.height = maxHeight + 'px';
            chatInput.style.overflowY = 'auto';
        } else if (scrollHeight < minHeight) {
            chatInput.style.height = minHeight + 'px';
            chatInput.style.overflowY = 'hidden';
        } else {
            chatInput.style.height = scrollHeight + 'px';
            chatInput.style.overflowY = 'hidden';
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
        getSuggestedQuestions().forEach((question) => {
            const btn = document.createElement('button');
            btn.className = 'w-full text-left p-2.5 bg-white border border-gray-200 rounded-lg hover:bg-[#FFF8F0] hover:border-[#D4AF37] transition-all duration-200 text-sm leading-relaxed';
            btn.innerHTML = `<span class="block overflow-hidden" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;">${question}</span>`;
            btn.onclick = () => handleSuggestedQuestionClick(question);
            suggestionsList.appendChild(btn);
        });
    }

    // Handle suggested question click
    async function handleSuggestedQuestionClick(question) {
        chatInput.value = question;

        // Small delay for visual feedback
        await new Promise(resolve => setTimeout(resolve, 100));

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

        try {
            // Add a small delay for better UX
            await new Promise(resolve => setTimeout(resolve, 500));

            const botResponse = await generateBotResponse(question);
            const botMessage = {
                id: (Date.now() + 1).toString(),
                text: botResponse,
                sender: 'bot',
                timestamp: new Date()
            };
            messages.push(botMessage);
            renderMessages();

            if (isMinimized) {
                hasNewMessage = true;
                newMessageDot.style.display = 'block';
            }
        } catch (error) {
            console.error('Error handling suggested question:', error);
            const errorMessage = {
                id: (Date.now() + 1).toString(),
                text: 'Xin lỗi, đã có lỗi xảy ra. Vui lòng thử lại sau.',
                sender: 'bot',
                timestamp: new Date()
            };
            messages.push(errorMessage);
            renderMessages();
        } finally {
            isTyping = false;
            renderTypingIndicator(false);
            sendBtn.disabled = false;
        }
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

    // Drag resize functionality
    function initDragResize() {
        const resizeHandles = document.querySelectorAll('.resize-handle');

        resizeHandles.forEach(handle => {
            handle.addEventListener('mousedown', startResize);
        });

        document.addEventListener('mousemove', doResize);
        document.addEventListener('mouseup', stopResize);
    }

    function startResize(e) {
        e.preventDefault();
        e.stopPropagation();

        isResizing = true;
        resizeDirection = e.target.className.match(/resize-handle-(\w+(?:-\w+)?)/)?.[1] || '';

        startX = e.clientX;
        startY = e.clientY;

        const rect = chatWindow.getBoundingClientRect();
        startWidth = rect.width;
        startHeight = rect.height;
        startLeft = rect.left;
        startTop = rect.top;

        // Disable transitions during resize
        chatWindow.style.transition = 'none';

        // Add resizing class for visual feedback
        chatWindow.classList.add('resizing');

        console.log('Started resizing:', resizeDirection);
    }

    function doResize(e) {
        if (!isResizing) return;

        e.preventDefault();

        const deltaX = e.clientX - startX;
        const deltaY = e.clientY - startY;

        let newWidth = startWidth;
        let newHeight = startHeight;
        let newLeft = startLeft;
        let newTop = startTop;

        // Calculate new dimensions based on resize direction
        switch (resizeDirection) {
            case 'right':
                newWidth = Math.max(300, Math.min(600, startWidth + deltaX));
                break;
            case 'left':
                newWidth = Math.max(300, Math.min(600, startWidth - deltaX));
                newLeft = startLeft + (startWidth - newWidth);
                break;
            case 'bottom':
                newHeight = Math.max(350, Math.min(700, startHeight + deltaY));
                break;
            case 'top':
                newHeight = Math.max(350, Math.min(700, startHeight - deltaY));
                newTop = startTop + (startHeight - newHeight);
                break;
            case 'bottom-right':
                newWidth = Math.max(300, Math.min(600, startWidth + deltaX));
                newHeight = Math.max(350, Math.min(700, startHeight + deltaY));
                break;
            case 'bottom-left':
                newWidth = Math.max(300, Math.min(600, startWidth - deltaX));
                newHeight = Math.max(350, Math.min(700, startHeight + deltaY));
                newLeft = startLeft + (startWidth - newWidth);
                break;
            case 'top-right':
                newWidth = Math.max(300, Math.min(600, startWidth + deltaX));
                newHeight = Math.max(350, Math.min(700, startHeight - deltaY));
                newTop = startTop + (startHeight - newHeight);
                break;
            case 'top-left':
                newWidth = Math.max(300, Math.min(600, startWidth - deltaX));
                newHeight = Math.max(350, Math.min(700, startHeight - deltaY));
                newLeft = startLeft + (startWidth - newWidth);
                newTop = startTop + (startHeight - newHeight);
                break;
        }

        // Apply new dimensions and position
        chatWindow.style.width = newWidth + 'px';
        chatWindow.style.height = newHeight + 'px';
        chatWindow.style.left = newLeft + 'px';
        chatWindow.style.top = newTop + 'px';
        chatWindow.style.right = 'auto';
        chatWindow.style.bottom = 'auto';
    }

    function stopResize() {
        if (!isResizing) return;

        isResizing = false;
        resizeDirection = '';

        // Re-enable transitions
        chatWindow.style.transition = '';

        // Remove resizing class
        chatWindow.classList.remove('resizing');

        // Save the new size to localStorage
        const rect = chatWindow.getBoundingClientRect();
        localStorage.setItem('chatbot-width', rect.width);
        localStorage.setItem('chatbot-height', rect.height);
        localStorage.setItem('chatbot-left', rect.left);
        localStorage.setItem('chatbot-top', rect.top);

        console.log('Resize completed:', rect.width + 'x' + rect.height);
    }

    // Reset chatbot to default position and size
    function resetChatbotPosition() {
        chatWindow.style.width = '384px';
        chatWindow.style.height = '480px';
        chatWindow.style.left = 'auto';
        chatWindow.style.top = 'auto';
        chatWindow.style.right = '1rem';
        chatWindow.style.bottom = '5rem';

        // Clear saved dimensions
        localStorage.removeItem('chatbot-width');
        localStorage.removeItem('chatbot-height');
        localStorage.removeItem('chatbot-left');
        localStorage.removeItem('chatbot-top');

        console.log('Chatbot position reset to default');
    }

    // Load saved dimensions
    function loadSavedDimensions() {
        const savedWidth = localStorage.getItem('chatbot-width');
        const savedHeight = localStorage.getItem('chatbot-height');
        const savedLeft = localStorage.getItem('chatbot-left');
        const savedTop = localStorage.getItem('chatbot-top');

        if (savedWidth && savedHeight) {
            chatWindow.style.width = savedWidth + 'px';
            chatWindow.style.height = savedHeight + 'px';

            // Only apply saved position if user has manually resized/moved the window
            if (savedLeft && savedTop && (savedLeft !== 'auto' && savedTop !== 'auto')) {
                // Check if the saved position is still within viewport
                const viewportWidth = window.innerWidth;
                const viewportHeight = window.innerHeight;
                const width = parseInt(savedWidth);
                const height = parseInt(savedHeight);
                const left = parseInt(savedLeft);
                const top = parseInt(savedTop);

                // Ensure the window is still visible
                if (left >= 0 && top >= 0 && left + width <= viewportWidth && top + height <= viewportHeight) {
                    chatWindow.style.left = savedLeft + 'px';
                    chatWindow.style.top = savedTop + 'px';
                    chatWindow.style.right = 'auto';
                    chatWindow.style.bottom = 'auto';
                }
            }

            console.log('Loaded saved dimensions:', savedWidth + 'x' + savedHeight);
        }
    }

    // Event listeners
    toggleChatBtn.addEventListener('click', toggleChat);
    minimizeBtn.addEventListener('click', minimizeChat);
    closeBtn.addEventListener('click', toggleChat);
    minimizedIndicator.addEventListener('click', maximizeChat);
    sendBtn.addEventListener('click', handleSendMessage);
    chatInput.addEventListener('keypress', handleKeyPress);
    chatInput.addEventListener('input', autoResizeTextarea);
    toggleSuggestionsBtn.addEventListener('click', toggleSuggestions);
    clearChatBtn.addEventListener('click', handleClearChat);

    // Initialize drag resize functionality
    initDragResize();

    // Load saved dimensions
    loadSavedDimensions();

    // Add double-click to reset size (optional UX enhancement)
    if (chatWindow) {
        const chatHeader = chatWindow.querySelector('.bg-gradient-to-r');
        if (chatHeader) {
            chatHeader.addEventListener('dblclick', resetChatbotPosition);
        }
    }

    // Initial render
    renderSuggestions();
});