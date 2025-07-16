// Booking Checkout JavaScript
// Integrates with cart.js to display actual cart data

class BookingCheckout {
    constructor() {
        this.cartItems = [];
        this.isLoading = false;
        this.paymentTimer = null;
        this.paymentTimeLeft = 15 * 60; // 15 minutes in seconds
        
        this.init();
    }

    async init() {
        console.log('Initializing Booking Checkout...');
        
        // Wait for DOM to be ready
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => this.initializeComponents());
        } else {
            this.initializeComponents();
        }
    }

    async initializeComponents() {
        try {
            // Load cart data
            await this.loadCartData();
            
            // Setup event listeners
            this.setupEventListeners();
            
            // Initialize UI
            this.updateCartDisplay();
            this.updateSummary();
            
            console.log('Booking checkout initialized successfully');
        } catch (error) {
            console.error('Error initializing booking checkout:', error);
            this.showNotification('Có lỗi xảy ra khi tải trang', 'error');
        }
    }

    async loadCartData() {
        this.showLoading(true);

        try {
            console.log('=== CART LOADING DEBUG ===');
            console.log('Loading cart data from session_cart only...');

            // Get current user for debugging purposes only
            const user = await this.getCurrentUser();
            console.log('Current user (for debugging only):', user);

            // Always use session_cart regardless of login status
            const cartKey = 'session_cart';
            console.log('Cart key:', cartKey);

            // Show all localStorage keys for debugging
            console.log('All localStorage keys:', Object.keys(localStorage));
            console.log('Cart-related keys:', Object.keys(localStorage).filter(key => key.includes('cart')));

            // Load cart data from session_cart
            let cartData = [];
            const cartRaw = localStorage.getItem(cartKey);
            console.log(`Raw cart data (${cartKey}):`, cartRaw);

            if (cartRaw) {
                try {
                    cartData = JSON.parse(cartRaw);
                    console.log(`Parsed cart data (${cartKey}):`, cartData);

                    // Validate cart data
                    if (!Array.isArray(cartData)) {
                        console.warn('Cart data is not an array, resetting to empty array');
                        cartData = [];
                    }
                } catch (e) {
                    console.error(`Error parsing cart data from ${cartKey}:`, e);
                    cartData = [];
                }
            } else {
                console.log('No cart data found');
                cartData = [];
            }

            this.cartItems = cartData;
            console.log(`Final cart loaded: ${this.cartItems.length} items`);
            console.log('Final cart items:', this.cartItems);
            console.log('=== END CART LOADING DEBUG ===');

        } catch (error) {
            console.error('Error loading cart data:', error);
            this.cartItems = [];
        } finally {
            this.showLoading(false);
        }
    }



    async getCurrentUser() {
        // Check sessionStorage first (set by JSP)
        const userJson = sessionStorage.getItem('user');
        if (userJson) {
            try {
                return JSON.parse(userJson);
            } catch (e) {
                console.error('Error parsing user from sessionStorage:', e);
            }
        }
        
        // Fallback to localStorage
        const localUserJson = localStorage.getItem('user');
        if (localUserJson) {
            try {
                return JSON.parse(localUserJson);
            } catch (e) {
                console.error('Error parsing user from localStorage:', e);
            }
        }
        
        return null;
    }

    updateCartDisplay() {
        const cartItemsContainer = document.getElementById('cartItemsContainer');
        const emptyCartMessage = document.getElementById('emptyCartMessage');
        const cartLoadingState = document.getElementById('cartLoadingState');
        
        if (!cartItemsContainer || !emptyCartMessage) {
            console.error('Required cart display elements not found');
            return;
        }

        // Hide loading state
        if (cartLoadingState) {
            cartLoadingState.style.display = 'none';
        }

        if (this.cartItems.length === 0) {
            // Show empty cart message
            emptyCartMessage.style.display = 'block';
            cartItemsContainer.style.display = 'none';
            return;
        }

        // Show cart items
        emptyCartMessage.style.display = 'none';
        cartItemsContainer.style.display = 'block';
        
        // Render cart items
        cartItemsContainer.innerHTML = this.cartItems.map(item => this.renderCartItem(item)).join('');
        
        // Reinitialize Lucide icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
    }

    renderCartItem(item) {
        // Use placeholder image if no image provided
        const imageUrl = item.serviceImage || `https://placehold.co/300x200/FFB6C1/333333?text=${encodeURIComponent(item.serviceName || 'Service')}`;
        
        return `
            <div class="cart-item-card bg-white rounded-xl shadow-md p-6 border border-gray-100">
                <div class="flex items-start space-x-6">
                    <!-- Service Image -->
                    <div class="flex-shrink-0">
                        <img src="${imageUrl}" 
                             alt="${this.escapeHtml(item.serviceName)}" 
                             class="w-24 h-24 object-cover rounded-lg shadow-sm"
                             onerror="this.src='https://placehold.co/300x200/FFB6C1/333333?text=Service'">
                    </div>
                    
                    <!-- Service Details -->
                    <div class="flex-1 min-w-0">
                        <h3 class="text-lg  font-semibold text-spa-dark mb-2">
                            ${this.escapeHtml(item.serviceName)}
                        </h3>
                        <div class="flex items-center space-x-3 text-xs text-gray-600 mb-2">
                            <div class="flex items-center">
                                <i data-lucide="clock" class="h-3 w-3 mr-1"></i>
                                <span>${item.serviceDuration} phút</span>
                            </div>
                            <div class="flex items-center">
                                <i data-lucide="calendar" class="h-3 w-3 mr-1"></i>
                                <span>Đã thêm: ${this.formatDate(item.addedAt)}</span>
                            </div>
                        </div>
                        <div class="text-lg font-bold text-primary mb-3">
                            ${this.formatCurrency(item.servicePrice)}
                        </div>
                    </div>
                    
                    <!-- Quantity Controls -->
                    <div class="flex-shrink-0">
                        <div class="flex items-center space-x-3 bg-gray-50 rounded-lg p-2">
                            <button onclick="bookingCheckout.updateQuantity('${item.id}', ${item.quantity - 1})" 
                                    class="quantity-btn p-2 text-gray-600 hover:text-primary hover:bg-white rounded-md transition-all duration-200">
                                <i data-lucide="minus" class="h-4 w-4"></i>
                            </button>
                            <span class="w-10 text-center font-medium text-base">${item.quantity}</span>
                            <button onclick="bookingCheckout.updateQuantity('${item.id}', ${item.quantity + 1})" 
                                    class="quantity-btn p-2 text-gray-600 hover:text-primary hover:bg-white rounded-md transition-all duration-200">
                                <i data-lucide="plus" class="h-4 w-4"></i>
                            </button>
                        </div>
                        <button onclick="bookingCheckout.removeItem('${item.id}')"
                                class="mt-2 w-full text-red-500 hover:text-red-700 text-xs font-medium transition-colors duration-200">
                            <i data-lucide="trash-2" class="h-3 w-3 inline mr-1"></i>
                            Xóa
                        </button>
                    </div>
                </div>
                
                <!-- Item Total -->
                <div class="mt-3 pt-3 border-t border-gray-100">
                    <div class="flex justify-between items-center">
                        <span class="text-sm text-gray-600">Thành tiền:</span>
                        <span class="text-base font-bold text-spa-dark">
                            ${this.formatCurrency(item.servicePrice * item.quantity)}
                        </span>
                    </div>
                </div>
            </div>
        `;
    }

    async updateQuantity(itemId, newQuantity) {
        if (newQuantity < 0) return;
        
        const itemIndex = this.cartItems.findIndex(item => item.id === itemId);
        if (itemIndex === -1) return;

        if (newQuantity === 0) {
            await this.removeItem(itemId);
            return;
        }

        // Update quantity
        this.cartItems[itemIndex].quantity = newQuantity;
        
        // Save to localStorage
        await this.saveCart();
        
        // Update display
        this.updateCartDisplay();
        this.updateSummary();
        
        this.showNotification('Đã cập nhật số lượng', 'success');
    }

    async removeItem(itemId) {
        // Remove item from cart
        this.cartItems = this.cartItems.filter(item => item.id !== itemId);
        
        // Save to localStorage
        await this.saveCart();
        
        // Update display
        this.updateCartDisplay();
        this.updateSummary();
        
        this.showNotification('Đã xóa dịch vụ khỏi giỏ hàng', 'success');
    }

    async saveCart() {
        try {
            console.log('=== CART SAVE DEBUG ===');
            console.log('Cart items to save:', this.cartItems);

            // Always use session_cart regardless of login status
            const cartKey = 'session_cart';
            console.log('Saving to cart key:', cartKey);

            // Save to localStorage
            localStorage.setItem(cartKey, JSON.stringify(this.cartItems));
            console.log('Cart saved successfully');
            console.log('=== END CART SAVE DEBUG ===');

            // Trigger cart update event for other components
            window.dispatchEvent(new CustomEvent('cartUpdated'));
        } catch (error) {
            console.error('Failed to save cart:', error);
            this.showNotification('Không thể lưu giỏ hàng', 'error');
        }
    }

    updateSummary() {
        // Calculate totals
        const subtotal = this.cartItems.reduce((sum, item) => sum + (item.servicePrice * item.quantity), 0);
        const tax = subtotal * 0.1; // 10% VAT
        const total = subtotal + tax;
        
        // Update summary display
        const subtotalElement = document.getElementById('subtotalAmount');
        const taxElement = document.getElementById('taxAmount');
        const totalElement = document.getElementById('totalAmount');
        const paymentTotalElement = document.getElementById('paymentTotalAmount');
        
        if (subtotalElement) subtotalElement.textContent = this.formatCurrency(subtotal);
        if (taxElement) taxElement.textContent = this.formatCurrency(tax);
        if (totalElement) totalElement.textContent = this.formatCurrency(total);
        if (paymentTotalElement) paymentTotalElement.textContent = this.formatCurrency(total);
    }

    setupEventListeners() {
        // Checkout button
        const checkoutBtn = document.getElementById('checkoutBtn');
        if (checkoutBtn) {
            checkoutBtn.addEventListener('click', () => this.proceedToPayment());
        }

        // Back to checkout button
        const backToCheckoutBtn = document.getElementById('backToCheckoutBtn');
        if (backToCheckoutBtn) {
            backToCheckoutBtn.addEventListener('click', () => this.backToCheckout());
        }

        // Payment complete button
        const paymentCompleteBtn = document.getElementById('paymentCompleteBtn');
        if (paymentCompleteBtn) {
            paymentCompleteBtn.addEventListener('click', () => this.completePayment());
        }

        // Copy reference number button
        const copyRefBtn = document.getElementById('copyRefBtn');
        if (copyRefBtn) {
            copyRefBtn.addEventListener('click', () => this.copyReferenceNumber());
        }
    }

    proceedToPayment() {
        if (this.cartItems.length === 0) {
            this.showNotification('Giỏ hàng trống', 'error');
            return;
        }

        // Generate payment reference number
        const referenceNumber = this.generateReferenceNumber();

        // Update payment details
        this.updatePaymentDetails(referenceNumber);

        // Switch to payment step
        this.showPaymentStep();

        // Start payment timer
        this.startPaymentTimer();
    }

    generateReferenceNumber() {
        const timestamp = Date.now().toString().slice(-8);
        const random = Math.random().toString(36).substring(2, 6).toUpperCase();
        return `SPA${timestamp}${random}`;
    }

    updatePaymentDetails(referenceNumber) {
        const referenceElement = document.getElementById('referenceNumber');
        if (referenceElement) {
            referenceElement.textContent = referenceNumber;
        }

        // Generate QR code (placeholder - in real implementation, this would call a QR service)
        const qrCodeImage = document.getElementById('qrCodeImage');
        if (qrCodeImage) {
            const total = this.cartItems.reduce((sum, item) => sum + (item.servicePrice * item.quantity), 0) * 1.1; // Include VAT
            const qrData = `Bank: Vietcombank|Account: 1234567890|Amount: ${total}|Reference: ${referenceNumber}`;
            qrCodeImage.src = `https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=${encodeURIComponent(qrData)}`;
        }
    }

    showPaymentStep() {
        const checkoutStep = document.getElementById('checkoutStep');
        const paymentStep = document.getElementById('paymentStep');

        if (checkoutStep) checkoutStep.style.display = 'none';
        if (paymentStep) paymentStep.style.display = 'block';

        // Scroll to top
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    backToCheckout() {
        const checkoutStep = document.getElementById('checkoutStep');
        const paymentStep = document.getElementById('paymentStep');

        if (checkoutStep) checkoutStep.style.display = 'block';
        if (paymentStep) paymentStep.style.display = 'none';

        // Stop payment timer
        this.stopPaymentTimer();

        // Scroll to top
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    startPaymentTimer() {
        this.paymentTimeLeft = 15 * 60; // Reset to 15 minutes
        this.updateTimerDisplay();

        this.paymentTimer = setInterval(() => {
            this.paymentTimeLeft--;
            this.updateTimerDisplay();

            // Show warning at 5 minutes
            if (this.paymentTimeLeft === 5 * 60) {
                const timerWarning = document.getElementById('timerWarning');
                if (timerWarning) {
                    timerWarning.style.display = 'block';
                }
            }

            // Timer expired
            if (this.paymentTimeLeft <= 0) {
                this.stopPaymentTimer();
                this.showNotification('Thời gian thanh toán đã hết. Vui lòng thử lại.', 'error');
                this.backToCheckout();
            }
        }, 1000);
    }

    stopPaymentTimer() {
        if (this.paymentTimer) {
            clearInterval(this.paymentTimer);
            this.paymentTimer = null;
        }
    }

    updateTimerDisplay() {
        const timerElement = document.getElementById('paymentTimer');
        if (!timerElement) return;

        const minutes = Math.floor(this.paymentTimeLeft / 60);
        const seconds = this.paymentTimeLeft % 60;
        timerElement.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
    }

    async completePayment() {
        try {
            this.showLoading(true);

            // Prepare payment data
            const paymentData = {
                cartItems: this.cartItems.map(item => ({
                    serviceId: parseInt(item.serviceId),
                    quantity: item.quantity
                })),
                paymentMethod: 'BANK_TRANSFER', // Default payment method
                referenceNumber: document.getElementById('referenceNumber')?.textContent || null,
                notes: 'Thanh toán qua QR Code'
            };

            // Call backend to process payment
            const contextPath = window.spaConfig ? window.spaConfig.contextPath : '';
            const response = await fetch(contextPath + '/checkout/process', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(paymentData)
            });

            const result = await response.json();

            if (result.success) {
                // Clear cart after successful payment
                if (result.clearCart) {
                    await this.clearCart();
                }

                // Show success message
                this.showNotification('Thanh toán thành công! Cảm ơn bạn đã sử dụng dịch vụ.', 'success');

                // Log payment details
                console.log('Payment completed:', {
                    paymentId: result.paymentId,
                    referenceNumber: result.referenceNumber,
                    totalAmount: result.totalAmount
                });

                // Redirect to success page or home
                setTimeout(() => {
                    const contextPath = window.spaConfig ? window.spaConfig.contextPath : '';
                    window.location.href = contextPath + '/';
                }, 3000);
            } else {
                // Handle payment failure
                this.showNotification(result.message || 'Thanh toán thất bại. Vui lòng thử lại.', 'error');
            }

        } catch (error) {
            console.error('Payment completion error:', error);

            // Handle different types of errors
            if (error.name === 'TypeError' && error.message.includes('fetch')) {
                this.showNotification('Lỗi kết nối mạng. Vui lòng kiểm tra kết nối internet.', 'error');
            } else if (error.status === 401) {
                this.showNotification('Vui lòng đăng nhập để tiếp tục thanh toán.', 'error');
                // Redirect to login after a delay
                setTimeout(() => {
                    const contextPath = window.spaConfig ? window.spaConfig.contextPath : '';
                    window.location.href = contextPath + '/login';
                }, 2000);
            } else {
                this.showNotification('Có lỗi xảy ra khi xử lý thanh toán. Vui lòng thử lại.', 'error');
            }
        } finally {
            this.showLoading(false);
        }
    }

    async clearCart() {
        try {
            console.log('=== CART CLEAR DEBUG ===');
            console.log('Clearing cart...');

            // Always use session_cart regardless of login status
            console.log('Removing session cart: session_cart');
            localStorage.removeItem('session_cart');

            this.cartItems = [];
            console.log('Cart cleared successfully');
            console.log('=== END CART CLEAR DEBUG ===');

            // Trigger cart update event
            window.dispatchEvent(new CustomEvent('cartUpdated'));
        } catch (error) {
            console.error('Error clearing cart:', error);
        }
    }

    copyReferenceNumber() {
        const referenceElement = document.getElementById('referenceNumber');
        if (!referenceElement) return;

        const referenceNumber = referenceElement.textContent;

        if (navigator.clipboard) {
            navigator.clipboard.writeText(referenceNumber).then(() => {
                this.showNotification('Đã sao chép mã tham chiếu', 'success');
            }).catch(() => {
                this.fallbackCopyText(referenceNumber);
            });
        } else {
            this.fallbackCopyText(referenceNumber);
        }
    }

    fallbackCopyText(text) {
        const textArea = document.createElement('textarea');
        textArea.value = text;
        document.body.appendChild(textArea);
        textArea.select();
        try {
            document.execCommand('copy');
            this.showNotification('Đã sao chép mã tham chiếu', 'success');
        } catch (err) {
            this.showNotification('Không thể sao chép mã tham chiếu', 'error');
        }
        document.body.removeChild(textArea);
    }

    // Utility methods
    showLoading(show) {
        const loadingOverlay = document.getElementById('loadingOverlay');
        const cartLoadingState = document.getElementById('cartLoadingState');

        if (loadingOverlay) {
            loadingOverlay.style.display = show ? 'block' : 'none';
        }

        if (cartLoadingState) {
            cartLoadingState.style.display = show ? 'block' : 'none';
        }
    }

    showNotification(message, type = 'info') {
        // Use the global SpaApp notification system if available
        if (window.SpaApp && typeof window.SpaApp.showNotification === 'function') {
            window.SpaApp.showNotification(message, type);
        } else {
            // Fallback notification system
            this.showFallbackNotification(message, type);
        }
    }

    showFallbackNotification(message, type) {
        const notification = document.getElementById('notification');
        if (!notification) return;

        notification.textContent = message;
        notification.className = `notification ${type}`;
        notification.classList.add('show');

        setTimeout(() => {
            notification.classList.remove('show');
        }, 5000);
    }

    formatCurrency(amount) {
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(amount);
    }

    formatDate(dateString) {
        try {
            const date = new Date(dateString);
            return new Intl.DateTimeFormat('vi-VN', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            }).format(date);
        } catch (error) {
            return 'N/A';
        }
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    // Debug methods for development
    debugCart() {
        console.log('=== CART DEBUG INFO ===');
        console.log('Cart items:', this.cartItems);
        console.log('Cart length:', this.cartItems.length);

        // Check session_cart only
        const sessionCart = localStorage.getItem('session_cart');
        console.log('session_cart:', sessionCart);

        if (sessionCart) {
            try {
                const parsedCart = JSON.parse(sessionCart);
                console.log('Parsed session_cart:', parsedCart);
                console.log('Session cart length:', parsedCart.length);
            } catch (e) {
                console.error('Error parsing session_cart:', e);
            }
        }

        console.log('=== END CART DEBUG ===');
    }

    async addTestCartItems() {
        const testItems = [
            {
                serviceId: 'test-1',
                serviceName: 'Massage Thư Giãn',
                serviceImage: 'https://placehold.co/300x200/FFB6C1/333333?text=Massage',
                servicePrice: 500000,
                serviceDuration: 60
            },
            {
                serviceId: 'test-2',
                serviceName: 'Chăm Sóc Da Mặt',
                serviceImage: 'https://placehold.co/300x200/FFB6C1/333333?text=Facial',
                servicePrice: 800000,
                serviceDuration: 90
            }
        ];

        for (const item of testItems) {
            const cartItem = {
                id: Date.now().toString() + Math.random().toString(36).substr(2, 9),
                ...item,
                quantity: 1,
                addedAt: new Date().toISOString()
            };
            this.cartItems.push(cartItem);
        }

        await this.saveCart();
        this.updateCartDisplay();
        this.updateSummary();
        this.showNotification('Đã thêm dịch vụ test vào giỏ hàng', 'success');
    }

    async clearAllCartData() {
        // Clear session_cart only
        localStorage.removeItem('session_cart');

        this.cartItems = [];
        this.updateCartDisplay();
        this.updateSummary();
        this.showNotification('Đã xóa tất cả dữ liệu giỏ hàng', 'success');
    }

    async refreshCart() {
        await this.loadCartData();
        this.updateCartDisplay();
        this.updateSummary();
        this.showNotification('Đã làm mới giỏ hàng', 'info');
    }
}

// Initialize booking checkout when DOM is ready
let bookingCheckout;

document.addEventListener('DOMContentLoaded', function() {
    bookingCheckout = new BookingCheckout();

    // Make debug functions globally available for development
    window.debugCart = () => bookingCheckout.debugCart();
    window.addTestCartItems = () => bookingCheckout.addTestCartItems();
    window.clearAllCartData = () => bookingCheckout.clearAllCartData();
    window.refreshCart = () => bookingCheckout.refreshCart();

    console.log('Booking checkout system initialized');
});
