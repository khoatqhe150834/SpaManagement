// Booking Checkout System - Integrated with Real Cart Data
class BookingCheckout {
    constructor() {
        this.currentStep = 'checkout'; // 'checkout' or 'payment'
        this.cartItems = [];
        this.isLoading = false;
        this.paymentInfo = null;
        this.timeLeft = 900; // 15 minutes in seconds
        this.timerInterval = null;
        this.copiedRef = false;
    }

    init() {
        this.loadCartItems();
        this.setupEventListeners();
        this.setupCartSynchronization();
        this.updateDisplay();
    }

    setupCartSynchronization() {
        // Listen for cart updates from other components
        window.addEventListener('cartUpdated', () => {
            console.log('Cart updated event received, reloading cart items');
            this.loadCartItems().then(() => {
                this.updateDisplay();
            });
        });

        // Listen for page visibility changes to reload cart when user returns
        document.addEventListener('visibilitychange', () => {
            if (!document.hidden) {
                console.log('Page became visible, checking for cart updates');
                this.loadCartItems().then(() => {
                    this.updateDisplay();
                });
            }
        });
    }

    setupEventListeners() {
        // Checkout button
        const checkoutBtn = document.getElementById('checkoutBtn');
        if (checkoutBtn) {
            checkoutBtn.addEventListener('click', () => this.handleCheckout());
        }

        // Back to checkout button
        const backToCheckoutBtn = document.getElementById('backToCheckoutBtn');
        if (backToCheckoutBtn) {
            backToCheckoutBtn.addEventListener('click', () => this.handleBackToCheckout());
        }

        // Payment complete button
        const paymentCompleteBtn = document.getElementById('paymentCompleteBtn');
        if (paymentCompleteBtn) {
            paymentCompleteBtn.addEventListener('click', () => this.handlePaymentComplete());
        }

        // Copy reference number button
        const copyRefBtn = document.getElementById('copyRefBtn');
        if (copyRefBtn) {
            copyRefBtn.addEventListener('click', () => this.copyReferenceNumber());
        }
    }

    async loadCartItems() {
        this.setLoading(true);

        try {
            // Debug: Check all localStorage keys
            console.log('=== CART DEBUG ===');
            console.log('All localStorage keys:', Object.keys(localStorage));

            // Check if user is authenticated
            const user = await this.getCurrentUser();
            console.log('Current user:', user);

            const cartKey = user ? `cart_${user.id}` : 'session_cart';
            console.log('Using cart key:', cartKey);

            // Load cart from localStorage
            const savedCart = localStorage.getItem(cartKey);
            console.log('Raw cart data:', savedCart);

            if (savedCart) {
                this.cartItems = JSON.parse(savedCart);
                console.log('Parsed cart items:', this.cartItems);
                console.log('Cart items count:', this.cartItems.length);
            } else {
                this.cartItems = [];
                console.log('No cart items found, starting with empty cart');

                // Try alternative cart keys as fallback
                const alternativeKeys = ['session_cart', 'cart', 'cartItems'];
                for (const key of alternativeKeys) {
                    const altCart = localStorage.getItem(key);
                    if (altCart) {
                        console.log(`Found cart data in alternative key '${key}':`, altCart);
                        try {
                            const altItems = JSON.parse(altCart);
                            if (Array.isArray(altItems) && altItems.length > 0) {
                                this.cartItems = altItems;
                                console.log('Using alternative cart data:', this.cartItems);
                                break;
                            }
                        } catch (e) {
                            console.warn(`Invalid JSON in ${key}:`, e);
                        }
                    }
                }
            }

            // Validate cart items structure
            const originalCount = this.cartItems.length;
            this.cartItems = this.cartItems.filter(item => this.validateCartItem(item));
            const validCount = this.cartItems.length;

            if (originalCount !== validCount) {
                console.warn(`Filtered out ${originalCount - validCount} invalid cart items`);
            }

            console.log('Final cart items:', this.cartItems);
            console.log('=== END CART DEBUG ===');

        } catch (error) {
            console.error('Failed to load cart items:', error);
            this.cartItems = [];
            this.showNotification('Không thể tải giỏ hàng. Vui lòng thử lại.', 'error');
        } finally {
            this.setLoading(false);
        }
    }

    validateCartItem(item) {
        console.log('Validating cart item:', item);

        if (!item || typeof item !== 'object') {
            console.warn('Cart item is not an object:', item);
            return false;
        }

        // Check for essential fields with flexible naming
        const hasId = item.id || item.serviceId;
        const hasServiceId = item.serviceId;
        const hasName = item.serviceName || item.name;
        const hasPrice = item.servicePrice !== undefined || item.price !== undefined;
        const hasQuantity = item.quantity !== undefined;

        if (!hasId || !hasServiceId || !hasName || !hasPrice) {
            console.warn('Cart item missing required fields:', {
                hasId, hasServiceId, hasName, hasPrice, hasQuantity,
                item
            });
            return false;
        }

        // Ensure numeric fields are valid
        const price = item.servicePrice || item.price || 0;
        const quantity = item.quantity || 1;

        if (isNaN(price) || price < 0) {
            console.warn('Cart item has invalid price:', price);
            return false;
        }

        if (isNaN(quantity) || quantity <= 0) {
            console.warn('Cart item has invalid quantity:', quantity);
            return false;
        }

        console.log('Cart item is valid:', item);
        return true;
    }

    async getCurrentUser() {
        // In a real app, this would be an API call
        const userJson = sessionStorage.getItem('user');
        return userJson ? JSON.parse(userJson) : null;
    }

    updateDisplay() {
        if (this.currentStep === 'checkout') {
            this.showCheckoutStep();
            this.renderCartItems();
            this.updateSummary();
        } else if (this.currentStep === 'payment') {
            this.showPaymentStep();
            this.startTimer();
        }
    }

    showCheckoutStep() {
        const checkoutStep = document.getElementById('checkoutStep');
        const paymentStep = document.getElementById('paymentStep');
        
        if (checkoutStep) checkoutStep.style.display = 'block';
        if (paymentStep) paymentStep.style.display = 'none';
    }

    showPaymentStep() {
        const checkoutStep = document.getElementById('checkoutStep');
        const paymentStep = document.getElementById('paymentStep');
        
        if (checkoutStep) checkoutStep.style.display = 'none';
        if (paymentStep) paymentStep.style.display = 'block';
    }

    renderCartItems() {
        const container = document.getElementById('cartItemsContainer');
        const emptyMessage = document.getElementById('emptyCartMessage');
        const loadingState = document.getElementById('cartLoadingState');

        if (!container) {
            console.error('Cart items container not found');
            return;
        }

        // Hide loading state
        if (loadingState) loadingState.style.display = 'none';

        if (this.cartItems.length === 0) {
            container.style.display = 'none';
            if (emptyMessage) emptyMessage.style.display = 'block';
            console.log('No cart items to display');
            return;
        }

        if (emptyMessage) emptyMessage.style.display = 'none';
        container.style.display = 'block';

        console.log('Rendering', this.cartItems.length, 'cart items');

        container.innerHTML = this.cartItems.map(item => {
            // Provide default values for missing fields
            const serviceImage = item.serviceImage || item.image || 'https://images.pexels.com/photos/3985263/pexels-photo-3985263.jpeg?auto=compress&cs=tinysrgb&w=400';
            const serviceName = item.serviceName || item.name || 'Dịch vụ spa';
            const description = item.description || item.serviceDescription || 'Dịch vụ chăm sóc sắc đẹp chuyên nghiệp';
            const serviceDuration = item.serviceDuration || item.duration || 60;
            const servicePrice = item.servicePrice || item.price || 0;
            const quantity = item.quantity || 1;

            return `
            <div class="cart-item-card group bg-white border border-gray-200 rounded-xl p-8 shadow-lg hover:shadow-xl transition-all duration-300 hover:border-primary/30">
                <div class="flex items-start space-x-6">
                    <img
                        src="${serviceImage}"
                        alt="${serviceName}"
                        class="w-28 h-28 object-cover rounded-xl shadow-md group-hover:shadow-lg transition-shadow duration-300"
                        onerror="this.src='https://images.pexels.com/photos/3985263/pexels-photo-3985263.jpeg?auto=compress&cs=tinysrgb&w=400'"
                    />

                    <div class="flex-1">
                        <h3 class="text-2xl font-serif font-semibold text-spa-dark mb-3 group-hover:text-primary transition-colors duration-300">
                            ${serviceName}
                        </h3>
                        <p class="text-gray-600 mb-4 leading-relaxed">
                            ${description}
                        </p>
                        <div class="flex items-center">
                            <div class="flex items-center text-gray-500 bg-spa-cream px-4 py-2 rounded-full">
                                <i data-lucide="clock" class="h-5 w-5 mr-2 text-primary"></i>
                                <span class="font-semibold">${serviceDuration} phút</span>
                            </div>
                        </div>
                    </div>

                    <div class="text-right min-w-[160px]">
                        <div class="text-2xl font-bold text-primary mb-4">
                            ${this.formatCurrency(servicePrice)}
                        </div>

                        <!-- Quantity Controls -->
                        <div class="flex items-center justify-center space-x-4 mb-4 bg-spa-cream rounded-xl p-3">
                            <button
                                onclick="bookingCheckout.updateQuantity('${item.id}', ${quantity - 1})"
                                class="quantity-btn p-3 rounded-full bg-white hover:bg-red-50 hover:text-red-600 transition-all duration-200 shadow-md hover:shadow-lg border border-gray-200"
                            >
                                <i data-lucide="minus" class="h-5 w-5"></i>
                            </button>
                            <span class="w-12 text-center font-bold text-xl text-spa-dark bg-white px-3 py-2 rounded-lg border border-gray-200">${quantity}</span>
                            <button
                                onclick="bookingCheckout.updateQuantity('${item.id}', ${quantity + 1})"
                                class="quantity-btn p-3 rounded-full bg-white hover:bg-primary hover:text-white transition-all duration-200 shadow-md hover:shadow-lg border border-gray-200"
                            >
                                <i data-lucide="plus" class="h-5 w-5"></i>
                            </button>
                        </div>

                        <!-- Remove Button -->
                        <button
                            onclick="bookingCheckout.removeItem('${item.id}')"
                            class="text-red-500 hover:text-red-700 hover:bg-red-50 transition-all duration-200 flex items-center justify-center w-full py-3 px-4 rounded-xl border border-red-200 hover:border-red-300 font-semibold"
                        >
                            <i data-lucide="trash-2" class="h-5 w-5 mr-2"></i>
                            Xóa
                        </button>

                        <!-- Subtotal -->
                        <div class="text-gray-600 mt-4 pt-4 border-t border-gray-200">
                            <span class="text-sm text-gray-500">Tổng cộng:</span>
                            <div class="font-bold text-primary text-xl">
                                ${this.formatCurrency(servicePrice * quantity)}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            `;
        }).join('');

        // Re-initialize Lucide icons for new content
        if (window.lucide) {
            lucide.createIcons();
        }
    }

    updateQuantity(itemId, newQuantity) {
        if (newQuantity <= 0) {
            this.removeItem(itemId);
            return;
        }

        const itemIndex = this.cartItems.findIndex(item => item.id === itemId);
        if (itemIndex === -1) {
            console.error('Item not found:', itemId);
            this.showNotification('Không tìm thấy sản phẩm', 'error');
            return;
        }

        this.cartItems[itemIndex].quantity = newQuantity;

        this.saveCart();
        this.renderCartItems();
        this.updateSummary();
        this.showNotification('Đã cập nhật số lượng', 'success');
    }

    removeItem(itemId) {
        const itemIndex = this.cartItems.findIndex(item => item.id === itemId);
        if (itemIndex === -1) {
            console.error('Item not found:', itemId);
            return;
        }

        const itemName = this.cartItems[itemIndex].serviceName || this.cartItems[itemIndex].name || 'sản phẩm';
        this.cartItems = this.cartItems.filter(item => item.id !== itemId);

        this.saveCart();
        this.renderCartItems();
        this.updateSummary();
        this.showNotification(`Đã xóa ${itemName} khỏi giỏ hàng`, 'success');

        // Trigger cart update event for other components
        window.dispatchEvent(new CustomEvent('cartUpdated'));
    }

    async saveCart() {
        try {
            const user = await this.getCurrentUser();
            const cartKey = user ? `cart_${user.id}` : 'session_cart';
            localStorage.setItem(cartKey, JSON.stringify(this.cartItems));

            // Trigger cart update event for other components
            window.dispatchEvent(new CustomEvent('cartUpdated'));

            console.log('Cart saved successfully:', this.cartItems.length, 'items');
        } catch (error) {
            console.error('Failed to save cart:', error);
            this.showNotification('Không thể lưu giỏ hàng', 'error');
        }
    }

    calculateSubtotal() {
        return this.cartItems.reduce((total, item) => {
            const price = item.servicePrice || item.price || 0;
            const quantity = item.quantity || 1;
            return total + (price * quantity);
        }, 0);
    }

    calculateTax() {
        return Math.round(this.calculateSubtotal() * 0.1); // 10% VAT, rounded
    }

    calculateTotal() {
        return this.calculateSubtotal() + this.calculateTax();
    }

    updateSummary() {
        const subtotalEl = document.getElementById('subtotalAmount');
        const taxEl = document.getElementById('taxAmount');
        const totalEl = document.getElementById('totalAmount');

        if (subtotalEl) subtotalEl.textContent = this.formatCurrency(this.calculateSubtotal());
        if (taxEl) taxEl.textContent = this.formatCurrency(this.calculateTax());
        if (totalEl) totalEl.textContent = this.formatCurrency(this.calculateTotal());
    }

    formatCurrency(amount) {
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(amount);
    }

    async handleCheckout() {
        // Reload cart to ensure we have the latest data
        await this.loadCartItems();

        if (this.cartItems.length === 0) {
            this.showNotification('Giỏ hàng trống! Vui lòng thêm dịch vụ trước khi thanh toán.', 'error');
            return;
        }

        // Validate cart items
        const invalidItems = this.cartItems.filter(item => !this.validateCartItem(item));
        if (invalidItems.length > 0) {
            console.error('Invalid cart items found:', invalidItems);
            this.showNotification('Có sản phẩm không hợp lệ trong giỏ hàng. Vui lòng kiểm tra lại.', 'error');
            return;
        }

        // Check if total amount is valid
        const total = this.calculateTotal();
        if (total <= 0) {
            this.showNotification('Tổng tiền không hợp lệ. Vui lòng kiểm tra lại giỏ hàng.', 'error');
            return;
        }

        this.setLoading(true);

        try {
            // Simulate payment processing
            await new Promise(resolve => setTimeout(resolve, 2000));

            this.paymentInfo = this.generatePaymentInfo();
            this.currentStep = 'payment';
            this.timeLeft = 900; // Reset timer
            this.updateDisplay();

            console.log('Checkout successful, proceeding to payment step');
        } catch (error) {
            console.error('Checkout failed:', error);
            this.showNotification('Có lỗi xảy ra khi xử lý thanh toán. Vui lòng thử lại.', 'error');
        } finally {
            this.setLoading(false);
        }
    }

    generatePaymentInfo() {
        const total = this.calculateTotal();
        const refNumber = `SPA${Date.now().toString().slice(-8)}`;

        return {
            totalAmount: total,
            referenceNumber: refNumber,
            qrCodeData: `https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=Bank Transfer|Amount:${total}|Ref:${refNumber}|Account:1234567890`,
            bankInfo: {
                bankName: 'Vietcombank',
                accountNumber: '1234567890',
                accountName: 'SPA HUONG SEN'
            }
        };
    }

    handleBackToCheckout() {
        this.currentStep = 'checkout';
        this.paymentInfo = null;
        this.timeLeft = 900;
        this.stopTimer();
        this.updateDisplay();
    }

    async handlePaymentComplete() {
        try {
            this.showNotification('Cảm ơn bạn đã thanh toán! Chúng tôi sẽ liên hệ xác nhận trong thời gian sớm nhất.', 'success');

            // Store order information for confirmation (optional)
            const orderInfo = {
                items: [...this.cartItems],
                total: this.calculateTotal(),
                paymentInfo: this.paymentInfo,
                completedAt: new Date().toISOString()
            };

            // Save order to session storage for confirmation page
            sessionStorage.setItem('lastOrder', JSON.stringify(orderInfo));

            // Clear cart after successful payment
            await this.clearCart();

            console.log('Payment completed successfully, cart cleared');

            // Redirect to home page after a delay
            setTimeout(() => {
                window.location.href = window.spaConfig.contextPath + '/';
            }, 3000);

        } catch (error) {
            console.error('Error completing payment:', error);
            this.showNotification('Có lỗi xảy ra khi hoàn tất thanh toán. Vui lòng liên hệ hỗ trợ.', 'error');
        }
    }

    async clearCart() {
        try {
            this.cartItems = [];
            await this.saveCart();

            // Also clear any cached cart data
            const user = await this.getCurrentUser();
            const cartKey = user ? `cart_${user.id}` : 'session_cart';
            localStorage.removeItem(cartKey);

            // Trigger cart update event
            window.dispatchEvent(new CustomEvent('cartUpdated'));

            console.log('Cart cleared successfully');
        } catch (error) {
            console.error('Failed to clear cart:', error);
        }
    }

    startTimer() {
        this.stopTimer(); // Clear any existing timer

        this.updateTimerDisplay();
        this.timerInterval = setInterval(() => {
            this.timeLeft--;
            this.updateTimerDisplay();

            if (this.timeLeft <= 0) {
                this.stopTimer();
                this.showNotification('Thời gian thanh toán đã hết. Vui lòng thử lại.', 'error');
                this.handleBackToCheckout();
            }
        }, 1000);
    }

    stopTimer() {
        if (this.timerInterval) {
            clearInterval(this.timerInterval);
            this.timerInterval = null;
        }
    }

    updateTimerDisplay() {
        const timerEl = document.getElementById('paymentTimer');
        const warningEl = document.getElementById('timerWarning');

        if (timerEl) {
            timerEl.textContent = this.formatTime(this.timeLeft);
        }

        if (warningEl) {
            if (this.timeLeft <= 300) { // 5 minutes
                warningEl.style.display = 'block';
            } else {
                warningEl.style.display = 'none';
            }
        }

        // Update payment info display
        if (this.paymentInfo) {
            this.updatePaymentDisplay();
        }
    }

    updatePaymentDisplay() {
        const qrCodeImg = document.getElementById('qrCodeImage');
        const bankNameEl = document.getElementById('bankName');
        const accountNumberEl = document.getElementById('accountNumber');
        const accountNameEl = document.getElementById('accountName');
        const referenceNumberEl = document.getElementById('referenceNumber');
        const paymentTotalEl = document.getElementById('paymentTotalAmount');

        if (qrCodeImg) qrCodeImg.src = this.paymentInfo.qrCodeData;
        if (bankNameEl) bankNameEl.textContent = this.paymentInfo.bankInfo.bankName;
        if (accountNumberEl) accountNumberEl.textContent = this.paymentInfo.bankInfo.accountNumber;
        if (accountNameEl) accountNameEl.textContent = this.paymentInfo.bankInfo.accountName;
        if (referenceNumberEl) referenceNumberEl.textContent = this.paymentInfo.referenceNumber;
        if (paymentTotalEl) paymentTotalEl.textContent = this.formatCurrency(this.paymentInfo.totalAmount);
    }

    formatTime(seconds) {
        const minutes = Math.floor(seconds / 60);
        const remainingSeconds = seconds % 60;
        return `${minutes.toString().padStart(2, '0')}:${remainingSeconds.toString().padStart(2, '0')}`;
    }

    copyReferenceNumber() {
        if (this.paymentInfo && navigator.clipboard) {
            navigator.clipboard.writeText(this.paymentInfo.referenceNumber).then(() => {
                const copyBtn = document.getElementById('copyRefBtn');
                if (copyBtn) {
                    const icon = copyBtn.querySelector('i');
                    if (icon) {
                        icon.setAttribute('data-lucide', 'check');
                        lucide.createIcons();
                    }
                }

                this.copiedRef = true;
                setTimeout(() => {
                    this.copiedRef = false;
                    if (copyBtn) {
                        const icon = copyBtn.querySelector('i');
                        if (icon) {
                            icon.setAttribute('data-lucide', 'copy');
                            lucide.createIcons();
                        }
                    }
                }, 2000);

                this.showNotification('Đã sao chép mã tham chiếu', 'success');
            }).catch(err => {
                console.error('Failed to copy reference number:', err);
                this.showNotification('Không thể sao chép mã tham chiếu', 'error');
            });
        }
    }

    setLoading(loading) {
        this.isLoading = loading;
        const overlay = document.getElementById('loadingOverlay');
        const checkoutBtn = document.getElementById('checkoutBtn');
        const cartLoadingState = document.getElementById('cartLoadingState');
        const cartContainer = document.getElementById('cartItemsContainer');

        if (overlay) {
            overlay.style.display = loading ? 'flex' : 'none';
        }

        // Handle cart loading state
        if (cartLoadingState && cartContainer) {
            if (loading) {
                cartLoadingState.style.display = 'block';
                cartContainer.style.display = 'none';
            } else {
                cartLoadingState.style.display = 'none';
                // cartContainer visibility will be handled by renderCartItems
            }
        }

        if (checkoutBtn) {
            checkoutBtn.disabled = loading;
            if (loading) {
                checkoutBtn.innerHTML = `
                    <div class="loading-spinner w-5 h-5 mr-2"></div>
                    Đang xử lý...
                `;
            } else {
                checkoutBtn.innerHTML = `
                    <i data-lucide="credit-card" class="h-6 w-6 mr-2"></i>
                    Thanh toán
                `;
                if (window.lucide) {
                    lucide.createIcons();
                }
            }
        }
    }

    showNotification(message, type = 'success') {
        const notification = document.getElementById('notification');
        if (!notification) return;

        notification.textContent = message;
        notification.className = `notification ${type}`;
        notification.classList.add('show');

        setTimeout(() => {
            notification.classList.remove('show');
        }, 4000);
    }
}

// Initialize the booking checkout system
let bookingCheckout;

document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing booking checkout system');
    bookingCheckout = new BookingCheckout();
    bookingCheckout.init();

    // Make it globally available immediately
    window.bookingCheckout = bookingCheckout;

    // Add debugging information
    console.log('Booking checkout system initialized');
    console.log('Cart items loaded:', bookingCheckout.cartItems.length);
});

// Export for global access
window.bookingCheckout = bookingCheckout;

// Add utility functions for debugging
window.debugCart = function() {
    if (bookingCheckout) {
        console.log('=== Cart Debug Info ===');
        console.log('Cart items:', bookingCheckout.cartItems);
        console.log('Subtotal:', bookingCheckout.calculateSubtotal());
        console.log('Tax:', bookingCheckout.calculateTax());
        console.log('Total:', bookingCheckout.calculateTotal());
        console.log('Current step:', bookingCheckout.currentStep);
        console.log('======================');
    } else {
        console.log('Booking checkout not initialized yet');
    }
};

window.refreshCart = function() {
    if (bookingCheckout) {
        console.log('Refreshing cart data...');
        bookingCheckout.loadCartItems().then(() => {
            bookingCheckout.updateDisplay();
            console.log('Cart refreshed successfully');
        });
    }
};

// Test function to add sample cart items
window.addTestCartItems = function() {
    const testItems = [
        {
            id: 'test_1',
            serviceId: 1,
            serviceName: 'Massage thư giãn toàn thân',
            serviceImage: 'https://images.pexels.com/photos/3997989/pexels-photo-3997989.jpeg?auto=compress&cs=tinysrgb&w=400',
            servicePrice: 500000,
            serviceDuration: 90,
            quantity: 1,
            addedAt: new Date().toISOString()
        },
        {
            id: 'test_2',
            serviceId: 2,
            serviceName: 'Chăm sóc da mặt cao cấp',
            serviceImage: 'https://images.pexels.com/photos/3985263/pexels-photo-3985263.jpeg?auto=compress&cs=tinysrgb&w=400',
            servicePrice: 800000,
            serviceDuration: 120,
            quantity: 1,
            addedAt: new Date().toISOString()
        }
    ];

    // Save to localStorage
    localStorage.setItem('session_cart', JSON.stringify(testItems));
    console.log('Test cart items added:', testItems);

    // Refresh the checkout page
    if (bookingCheckout) {
        bookingCheckout.loadCartItems().then(() => {
            bookingCheckout.updateDisplay();
        });
    }
};

// Function to clear all cart data
window.clearAllCartData = function() {
    const keys = ['session_cart', 'cart', 'cartItems'];

    // Also check for user-specific cart keys
    Object.keys(localStorage).forEach(key => {
        if (key.startsWith('cart_')) {
            keys.push(key);
        }
    });

    keys.forEach(key => {
        localStorage.removeItem(key);
        console.log('Removed cart key:', key);
    });

    console.log('All cart data cleared');

    if (bookingCheckout) {
        bookingCheckout.loadCartItems().then(() => {
            bookingCheckout.updateDisplay();
        });
    }
};
