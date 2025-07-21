/**
 * WebSocket Booking Test System
 * Real-time booking slot reservation testing with double-booking prevention
 * 
 * @author SpaManagement
 */

class WebSocketBookingTest {
    constructor() {
        this.websocket = null;
        this.currentUser = this.getCurrentUser();
        this.selectedSlots = new Set();
        this.isConnected = false;
        this.reconnectAttempts = 0;
        this.maxReconnectAttempts = 5;
        
        this.init();
    }
    
    init() {
        this.logToConsole('[SYSTEM] Khởi tạo WebSocket Booking Test System...');
        this.connectWebSocket();
        this.setupEventListeners();
        this.updateConnectionStatus(false);
    }
    
    getCurrentUser() {
        // Get current user from JSP or session
        const userElement = document.querySelector('[data-current-user]');
        return {
            id: userElement?.dataset.userId || 'user1',
            name: userElement?.dataset.userName || document.getElementById('userSimulation')?.value || 'user1'
        };
    }
    
    connectWebSocket() {
        try {
            // Use WebSocket URL - adjust port and path as needed
            const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
            const wsUrl = `${protocol}//${window.location.host}/G1_SpaManagement/booking-websocket`;
            
            this.logToConsole(`[WEBSOCKET] Đang kết nối tới: ${wsUrl}`);
            
            this.websocket = new WebSocket(wsUrl);
            
            this.websocket.onopen = (event) => {
                this.onWebSocketOpen(event);
            };
            
            this.websocket.onmessage = (event) => {
                this.onWebSocketMessage(event);
            };
            
            this.websocket.onclose = (event) => {
                this.onWebSocketClose(event);
            };
            
            this.websocket.onerror = (event) => {
                this.onWebSocketError(event);
            };
            
        } catch (error) {
            this.logToConsole(`[ERROR] Lỗi kết nối WebSocket: ${error.message}`, 'error');
            this.updateConnectionStatus(false);
        }
    }
    
    onWebSocketOpen(event) {
        this.isConnected = true;
        this.reconnectAttempts = 0;
        this.updateConnectionStatus(true);
        this.logToConsole('[WEBSOCKET] Kết nối thành công!', 'success');
        
        // Send initial connection message
        this.sendMessage({
            action: 'connect',
            userId: this.currentUser.id,
            userName: this.currentUser.name,
            timestamp: new Date().toISOString()
        });
    }
    
    onWebSocketMessage(event) {
        try {
            const message = JSON.parse(event.data);
            this.logToConsole(`[RECEIVED] ${JSON.stringify(message)}`, 'info');
            
            switch (message.action) {
                case 'slot_selected':
                    this.handleSlotSelected(message);
                    break;
                case 'slot_booked':
                    this.handleSlotBooked(message);
                    break;
                case 'slot_released':
                    this.handleSlotReleased(message);
                    break;
                case 'user_connected':
                    this.handleUserConnected(message);
                    break;
                case 'user_disconnected':
                    this.handleUserDisconnected(message);
                    break;
                case 'test_reset':
                    this.handleTestReset(message);
                    break;
                default:
                    this.logToConsole(`[WARNING] Hành động không xác định: ${message.action}`, 'warning');
            }
        } catch (error) {
            this.logToConsole(`[ERROR] Lỗi xử lý tin nhắn: ${error.message}`, 'error');
        }
    }
    
    onWebSocketClose(event) {
        this.isConnected = false;
        this.updateConnectionStatus(false);
        this.logToConsole(`[WEBSOCKET] Kết nối đóng. Code: ${event.code}, Reason: ${event.reason}`, 'warning');
        
        // Attempt to reconnect
        if (this.reconnectAttempts < this.maxReconnectAttempts) {
            this.reconnectAttempts++;
            this.logToConsole(`[WEBSOCKET] Thử kết nối lại lần ${this.reconnectAttempts}/${this.maxReconnectAttempts}...`, 'info');
            setTimeout(() => this.connectWebSocket(), 3000);
        } else {
            this.logToConsole('[WEBSOCKET] Đã vượt quá số lần thử kết nối lại', 'error');
        }
    }
    
    onWebSocketError(event) {
        this.logToConsole(`[ERROR] WebSocket error: ${event.type}`, 'error');
        this.updateConnectionStatus(false);
    }
    
    sendMessage(message) {
        if (this.websocket && this.websocket.readyState === WebSocket.OPEN) {
            this.websocket.send(JSON.stringify(message));
            this.logToConsole(`[SENT] ${JSON.stringify(message)}`, 'sent');
        } else {
            this.logToConsole('[ERROR] WebSocket chưa kết nối', 'error');
        }
    }
    
    selectTimeSlot(time, slotId) {
        const slotElement = document.querySelector(`[data-slot-id="${slotId}"]`);
        
        if (!slotElement || slotElement.classList.contains('booked')) {
            this.logToConsole(`[WARNING] Slot ${time} không thể đặt`, 'warning');
            return;
        }
        
        // Update UI immediately for better UX
        this.updateSlotStatus(slotId, 'selected', this.currentUser.name);
        this.selectedSlots.add(slotId);
        
        // Send selection to server
        this.sendMessage({
            action: 'select_slot',
            timeSlot: time,
            slotId: slotId,
            userId: this.currentUser.id,
            userName: this.currentUser.name,
            timestamp: new Date().toISOString()
        });
        
        this.logToConsole(`[ACTION] Đã chọn slot ${time}`, 'success');
        
        // Auto-confirm booking after 3 seconds (simulate user confirmation)
        setTimeout(() => {
            if (this.selectedSlots.has(slotId)) {
                this.confirmBooking(time, slotId);
            }
        }, 3000);
    }
    
    confirmBooking(time, slotId) {
        this.sendMessage({
            action: 'book_slot',
            timeSlot: time,
            slotId: slotId,
            userId: this.currentUser.id,
            userName: this.currentUser.name,
            timestamp: new Date().toISOString()
        });
        
        this.selectedSlots.delete(slotId);
        this.logToConsole(`[ACTION] Xác nhận đặt slot ${time}`, 'success');
    }
    
    handleSlotSelected(message) {
        if (message.userId !== this.currentUser.id) {
            this.updateSlotStatus(message.slotId, 'selected', message.userName);
            this.logToConsole(`[UPDATE] ${message.userName} đang chọn slot ${message.timeSlot}`, 'info');
        }
    }
    
    handleSlotBooked(message) {
        this.updateSlotStatus(message.slotId, 'booked', message.userName);
        
        if (message.userId === this.currentUser.id) {
            this.logToConsole(`[SUCCESS] Bạn đã đặt thành công slot ${message.timeSlot}`, 'success');
        } else {
            this.updateSlotStatus(message.slotId, 'just-booked', message.userName);
            this.logToConsole(`[UPDATE] ${message.userName} đã đặt slot ${message.timeSlot}`, 'warning');
            
            // Revert to booked status after animation
            setTimeout(() => {
                this.updateSlotStatus(message.slotId, 'booked', message.userName);
            }, 2000);
        }
    }
    
    handleSlotReleased(message) {
        this.updateSlotStatus(message.slotId, 'available', null);
        this.logToConsole(`[UPDATE] Slot ${message.timeSlot} đã được giải phóng`, 'info');
    }
    
    handleUserConnected(message) {
        this.logToConsole(`[USER] ${message.userName} đã kết nối`, 'info');
    }
    
    handleUserDisconnected(message) {
        this.logToConsole(`[USER] ${message.userName} đã ngắt kết nối`, 'info');
    }
    
    handleTestReset(message) {
        this.resetAllSlots();
        this.logToConsole('[SYSTEM] Test đã được reset', 'success');
    }
    
    updateSlotStatus(slotId, status, bookedBy) {
        const slotElement = document.querySelector(`[data-slot-id="${slotId}"]`);
        if (!slotElement) return;
        
        // Remove all status classes
        slotElement.classList.remove('available', 'booked', 'selected', 'just-booked');
        
        // Add new status class
        slotElement.classList.add(status);
        
        // Update status text
        const statusElement = slotElement.querySelector('.slot-status');
        if (statusElement) {
            switch (status) {
                case 'available':
                    statusElement.textContent = 'Có thể đặt';
                    break;
                case 'selected':
                    statusElement.textContent = `${bookedBy} đang chọn`;
                    break;
                case 'booked':
                    statusElement.textContent = `Đã đặt bởi ${bookedBy}`;
                    break;
                case 'just-booked':
                    statusElement.textContent = `Vừa đặt bởi ${bookedBy}`;
                    break;
            }
        }
    }
    
    updateConnectionStatus(connected) {
        const statusIndicator = document.getElementById('connectionStatus');
        const statusText = document.getElementById('connectionText');
        
        if (connected) {
            statusIndicator.classList.remove('disconnected');
            statusIndicator.classList.add('connected');
            statusText.textContent = 'Đã kết nối';
        } else {
            statusIndicator.classList.remove('connected');
            statusIndicator.classList.add('disconnected');
            statusText.textContent = 'Mất kết nối';
        }
    }
    
    logToConsole(message, type = 'info') {
        const consoleLog = document.getElementById('consoleLog');
        const timestamp = new Date().toLocaleTimeString();
        const logEntry = document.createElement('div');
        
        let color = '#00ff00';
        switch (type) {
            case 'error':
                color = '#ff4444';
                break;
            case 'warning':
                color = '#ffaa00';
                break;
            case 'success':
                color = '#44ff44';
                break;
            case 'sent':
                color = '#00aaff';
                break;
        }
        
        logEntry.innerHTML = `<span style="color: #888">[${timestamp}]</span> <span style="color: ${color}">${message}</span>`;
        consoleLog.appendChild(logEntry);
        consoleLog.scrollTop = consoleLog.scrollHeight;
    }
    
    setupEventListeners() {
        // User simulation change
        const userSelect = document.getElementById('userSimulation');
        if (userSelect) {
            userSelect.addEventListener('change', (e) => {
                this.currentUser.id = e.target.value;
                this.currentUser.name = e.target.options[e.target.selectedIndex].text;
                this.logToConsole(`[USER] Chuyển sang ${this.currentUser.name}`, 'info');
            });
        }
    }
    
    resetAllSlots() {
        const slots = document.querySelectorAll('.time-slot');
        slots.forEach(slot => {
            this.updateSlotStatus(slot.dataset.slotId, 'available', null);
        });
        this.selectedSlots.clear();
    }
    
    // Global functions for button clicks
    resetTest() {
        this.sendMessage({
            action: 'reset_test',
            userId: this.currentUser.id,
            userName: this.currentUser.name,
            timestamp: new Date().toISOString()
        });
        this.logToConsole('[ACTION] Yêu cầu reset test', 'info');
    }
    
    simulateMultipleUsers() {
        this.logToConsole('[SIMULATION] Mô phỏng nhiều người dùng đặt cùng lúc...', 'info');
        
        // Simulate 3 users trying to book the same slot
        const availableSlots = document.querySelectorAll('.time-slot.available');
        if (availableSlots.length > 0) {
            const targetSlot = availableSlots[0];
            const time = targetSlot.dataset.time;
            const slotId = targetSlot.dataset.slotId;
            
            // Simulate rapid booking attempts
            setTimeout(() => this.simulateUserBooking('user2', 'Test User 2', time, slotId), 100);
            setTimeout(() => this.simulateUserBooking('user3', 'Test User 3', time, slotId), 200);
            setTimeout(() => this.simulateUserBooking('user4', 'Test User 4', time, slotId), 300);
        }
    }
    
    simulateUserBooking(userId, userName, time, slotId) {
        this.sendMessage({
            action: 'select_slot',
            timeSlot: time,
            slotId: slotId,
            userId: userId,
            userName: userName,
            timestamp: new Date().toISOString()
        });
    }
    
    reconnectWebSocket() {
        this.logToConsole('[ACTION] Thử kết nối lại WebSocket...', 'info');
        this.reconnectAttempts = 0;
        if (this.websocket) {
            this.websocket.close();
        }
        setTimeout(() => this.connectWebSocket(), 1000);
    }
    
    clearConsole() {
        const consoleLog = document.getElementById('consoleLog');
        consoleLog.innerHTML = '<div>[SYSTEM] Console đã được xóa</div>';
    }
}

// Initialize the test system when page loads
let bookingTest;

document.addEventListener('DOMContentLoaded', function() {
    bookingTest = new WebSocketBookingTest();
});

// Global functions for JSP onclick handlers
function selectTimeSlot(time, slotId) {
    if (bookingTest) {
        bookingTest.selectTimeSlot(time, slotId);
    }
}

function resetTest() {
    if (bookingTest) {
        bookingTest.resetTest();
    }
}

function simulateMultipleUsers() {
    if (bookingTest) {
        bookingTest.simulateMultipleUsers();
    }
}

function reconnectWebSocket() {
    if (bookingTest) {
        bookingTest.reconnectWebSocket();
    }
}

function clearConsole() {
    if (bookingTest) {
        bookingTest.clearConsole();
    }
}
