// Booking Checkout System - Converted from React
class BookingCheckout {
    constructor() {
        this.currentStep = 'checkout'; // 'checkout' or 'payment'
        this.cartItems = [];
        this.isLoading = false;
        this.paymentInfo = null;
        this.timeLeft = 900; // 15 minutes in seconds
        this.timerInterval = null;
        this.copiedRef = false;
        
        // Mock cart data for testing
        this.mockCartItems = [
            {
                id: '1',
                serviceId: '1',
                serviceName: 'Massage thư giãn toàn thân',
                serviceImage: 'https://images.pexels.com/photos/3997989/pexels-photo-3997989.jpeg?auto=compress&cs=tinysrgb&w=400',
                servicePrice: 500000,
                serviceDuration: 90,
                quantity: 1,
                description: 'Massage thư giãn với tinh dầu thảo dược tự nhiên, giúp giảm stress và mệt mỏi'
            },
            {
                id: '2',
                serviceId: '2',
                serviceName: 'Chăm sóc da mặt cao cấp',
                serviceImage: 'https://images.pexels.com/photos/3985263/pexels-photo-3985263.jpeg?auto=compress&cs=tinysrgb&w=400',
                servicePrice: 800000,
                serviceDuration: 120,
                quantity: 1,
                description: 'Điều trị da mặt với công nghệ hiện đại và sản phẩm cao cấp từ Hàn Quốc'
            }
        ];
    }

    init() {
        this.loadCartItems();
        this.setupEventListeners();
        this.updateDisplay();
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
        try {
            // Check if user is authenticated
            const user = await this.getCurrentUser();
            const cartKey = user ? `cart_${user.id}` : 'session_cart';
            
            // Load cart from localStorage
            const savedCart = localStorage.getItem(cartKey);
            if (savedCart) {
                this.cartItems = JSON.parse(savedCart);
            } else {
                // Use mock data for testing
                this.cartItems = this.mockCartItems;
            }
        } catch (error) {
            console.error('Failed to load cart items:', error);
            this.cartItems = this.mockCartItems; // Fallback to mock data
        }
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
        
        if (!container) return;

        if (this.cartItems.length === 0) {
            container.style.display = 'none';
            if (emptyMessage) emptyMessage.style.display = 'block';
            return;
        }

        if (emptyMessage) emptyMessage.style.display = 'none';
        container.style.display = 'block';

        container.innerHTML = this.cartItems.map(item => `
            <div class="cart-item-card group bg-white border border-gray-200 rounded-xl p-6 shadow-sm hover:shadow-md transition-all duration-300 hover:border-[#D4AF37]/30">
                <div class="flex items-start space-x-4">
                    <img
                        src="${item.serviceImage}"
                        alt="${item.serviceName}"
                        class="w-24 h-24 object-cover rounded-xl shadow-sm group-hover:shadow-md transition-shadow duration-300"
                    />
                    
                    <div class="flex-1">
                        <h3 class="text-xl font-semibold text-[#333333] mb-2 group-hover:text-[#D4AF37] transition-colors duration-300">
                            ${item.serviceName}
                        </h3>
                        <p class="text-sm text-gray-600 mb-3 leading-relaxed">
                            ${item.description}
                        </p>
                        <div class="flex items-center">
                            <div class="flex items-center text-sm text-gray-500 bg-gray-50 px-3 py-1 rounded-full">
                                <i data-lucide="clock" class="h-4 w-4 mr-1.5 text-[#D4AF37]"></i>
                                <span class="font-medium">${item.serviceDuration} phút</span>
                            </div>
                        </div>
                    </div>

                    <div class="text-right min-w-[140px]">
                        <div class="text-xl font-bold text-[#D4AF37] mb-3">
                            ${this.formatCurrency(item.servicePrice)}
                        </div>
                        
                        <!-- Quantity Controls -->
                        <div class="flex items-center justify-center space-x-3 mb-3 bg-gray-50 rounded-lg p-2">
                            <button
                                onclick="bookingCheckout.updateQuantity('${item.id}', ${item.quantity - 1})"
                                class="quantity-btn p-2 rounded-full bg-white hover:bg-red-50 hover:text-red-600 transition-all duration-200 shadow-sm hover:shadow-md border border-gray-200"
                            >
                                <i data-lucide="minus" class="h-4 w-4"></i>
                            </button>
                            <span class="w-10 text-center font-bold text-lg text-[#333333] bg-white px-2 py-1 rounded-md border border-gray-200">${item.quantity}</span>
                            <button
                                onclick="bookingCheckout.updateQuantity('${item.id}', ${item.quantity + 1})"
                                class="quantity-btn p-2 rounded-full bg-white hover:bg-[#D4AF37] hover:text-white transition-all duration-200 shadow-sm hover:shadow-md border border-gray-200"
                            >
                                <i data-lucide="plus" class="h-4 w-4"></i>
                            </button>
                        </div>

                        <!-- Remove Button -->
                        <button
                            onclick="bookingCheckout.removeItem('${item.id}')"
                            class="text-red-500 hover:text-red-700 hover:bg-red-50 transition-all duration-200 text-sm flex items-center justify-center w-full py-2 px-3 rounded-lg border border-red-200 hover:border-red-300"
                        >
                            <i data-lucide="trash-2" class="h-4 w-4 mr-1"></i>
                            Xóa
                        </button>

                        <!-- Subtotal -->
                        <div class="text-sm text-gray-600 mt-3 pt-3 border-t border-gray-100">
                            <span class="text-xs text-gray-500">Tổng cộng:</span>
                            <div class="font-bold text-[#D4AF37] text-lg">
                                ${this.formatCurrency(item.servicePrice * item.quantity)}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `).join('');

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
        
        this.cartItems = this.cartItems.map(item =>
            item.id === itemId ? { ...item, quantity: newQuantity } : item
        );
        
        this.saveCart();
        this.renderCartItems();
        this.updateSummary();
    }

    removeItem(itemId) {
        this.cartItems = this.cartItems.filter(item => item.id !== itemId);
        this.saveCart();
        this.renderCartItems();
        this.updateSummary();
    }

    async saveCart() {
        try {
            const user = await this.getCurrentUser();
            const cartKey = user ? `cart_${user.id}` : 'session_cart';
            localStorage.setItem(cartKey, JSON.stringify(this.cartItems));
        } catch (error) {
            console.error('Failed to save cart:', error);
        }
    }

    calculateSubtotal() {
        return this.cartItems.reduce((total, item) => total + (item.servicePrice * item.quantity), 0);
    }

    calculateTax() {
        return this.calculateSubtotal() * 0.1; // 10% VAT
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
        if (this.cartItems.length === 0) {
            this.showNotification('Giỏ hàng trống!', 'error');
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

    handlePaymentComplete() {
        this.showNotification('Cảm ơn bạn đã thanh toán! Chúng tôi sẽ liên hệ xác nhận trong thời gian sớm nhất.', 'success');

        // Clear cart after successful payment
        this.cartItems = [];
        this.saveCart();

        // Redirect to booking confirmation or home page after a delay
        setTimeout(() => {
            window.location.href = window.spaConfig.contextPath + '/';
        }, 3000);
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

        if (overlay) {
            overlay.style.display = loading ? 'flex' : 'none';
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
                    <i data-lucide="credit-card" class="h-5 w-5 mr-2"></i>
                    Thanh toán
                `;
                lucide.createIcons();
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
    bookingCheckout = new BookingCheckout();
    bookingCheckout.init();
});

// Export for global access
window.bookingCheckout = bookingCheckout;
