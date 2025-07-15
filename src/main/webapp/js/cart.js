// Cart item interface
/*
interface CartItem {
  id: string;
  serviceId: string;
  serviceName: string;
  serviceImage: string;
  servicePrice: number;
  serviceDuration: number;
  quantity: number;
  addedAt: string;
}
*/

// Cart state
let cartItems = [];
let isLoading = false;

// Initialize cart function
async function initializeCart() {
    console.log('🛒 Initializing cart...');
    await loadCart();
    await updateCartIcon();

    // Setup cart icon click handler (only if not already set up)
    const cartIconBtn = document.getElementById('cart-icon-btn');
    if (cartIconBtn && !cartIconBtn.hasAttribute('data-cart-initialized')) {
        cartIconBtn.addEventListener('click', () => {
            openCart();
        });
        cartIconBtn.setAttribute('data-cart-initialized', 'true');
    }
}

// Initialize cart on DOM ready
document.addEventListener('DOMContentLoaded', async () => {
    await initializeCart();

    // Listen for cart updates
    window.addEventListener('cartUpdated', async () => {
        await loadCart();
        await updateCartIcon();
    });
});

// Handle browser back/forward navigation (bfcache)
window.addEventListener('pageshow', async (event) => {
    console.log('🔄 Page show event triggered, persisted:', event.persisted);
    // Always refresh cart on pageshow, especially when coming from bfcache
    await initializeCart();
});

// Handle page visibility changes (when user switches tabs and comes back)
document.addEventListener('visibilitychange', async () => {
    if (!document.hidden) {
        console.log('👁️ Page became visible, refreshing cart...');
        await updateCartIcon();
    }
});

// Handle window focus (additional safety net)
window.addEventListener('focus', async () => {
    console.log('🎯 Window focused, refreshing cart icon...');
    await updateCartIcon();
});

// Handle localStorage changes (cross-tab synchronization)
window.addEventListener('storage', async (event) => {
    if (event.key === 'session_cart') {
        console.log('💾 Cart storage changed in another tab, syncing...');
        await loadCart();
        await updateCartIcon();
    }
});

// Additional safety net: periodically refresh cart icon (every 5 seconds)
setInterval(async () => {
    if (!isLoading && !document.hidden) {
        await updateCartIcon();
    }
}, 5000);

// Load cart data
async function loadCart() {
    isLoading = true;
    showLoading(true);

    try {
        // Always use session_cart regardless of login status
        const cartKey = 'session_cart';

        // Load cart from localStorage
        const savedCart = localStorage.getItem(cartKey);
        if (savedCart) {
            cartItems = JSON.parse(savedCart);
            console.log(`🛒 Cart loaded: ${cartItems.length} items from ${cartKey}`);
            updateCartDisplay();
        } else {
            cartItems = [];
            console.log(`🛒 Cart empty: no data found in ${cartKey}`);
            updateCartDisplay();
        }
    } catch (error) {
        console.error('❌ Error loading cart:', error);
        showNotification('Không thể tải giỏ hàng', 'error');
    } finally {
        isLoading = false;
        showLoading(false);
    }
}

// Get current user
async function getCurrentUser() {
    // In a real app, this would be an API call
    // For now, we'll check the session storage
    const userJson = sessionStorage.getItem('user');
    return userJson ? JSON.parse(userJson) : null;
}

// Save cart
async function saveCart(items) {
    try {
        // Always use session_cart regardless of login status
        const cartKey = 'session_cart';
        localStorage.setItem(cartKey, JSON.stringify(items));
        
        // Update cart icon and trigger cart update event
        await updateCartIcon();
        window.dispatchEvent(new CustomEvent('cartUpdated'));
    } catch (error) {
        console.error('Failed to save cart:', error);
        showNotification('Không thể lưu giỏ hàng', 'error');
    }
}

// Add to cart
async function addToCart(serviceData) {
    try {
        // Always use session_cart regardless of login status
        const cartKey = 'session_cart';

        // Load current cart
        let currentCart = [];
        const savedCart = localStorage.getItem(cartKey);
        if (savedCart) {
            currentCart = JSON.parse(savedCart);
        }

        // Check if item already exists
        const existingItem = currentCart.find(item => item.serviceId === serviceData.serviceId);
        
        if (existingItem) {
            existingItem.quantity += 1;
        } else {
            const newItem = {
                id: Date.now().toString(),
                ...serviceData,
                quantity: 1,
                addedAt: new Date().toISOString()
            };
            currentCart.push(newItem);
        }

        // Save updated cart
        await saveCart(currentCart);
        showNotification('Đã thêm vào giỏ hàng', 'success');
        
        return true;
    } catch (error) {
        console.error('Failed to add to cart:', error);
        showNotification('Không thể thêm vào giỏ hàng', 'error');
        return false;
    }
}

// Update quantity
async function updateQuantity(itemId, newQuantity) {
    if (newQuantity < 0) return;
    
    const itemIndex = cartItems.findIndex(item => item.id === itemId);
    if (itemIndex === -1) return;

    if (newQuantity === 0) {
        await removeFromCart(itemId);
        return;
    }

    cartItems[itemIndex].quantity = newQuantity;
    await saveCart(cartItems);
    updateCartDisplay();
    showNotification('Đã cập nhật số lượng', 'success');
}

// Remove item
async function removeFromCart(itemId) {
    cartItems = cartItems.filter(item => item.id !== itemId);
    await saveCart(cartItems);
    updateCartDisplay();
    showNotification('Đã xóa dịch vụ khỏi giỏ hàng', 'success');
}   

// Clear cart
async function clearCart() {
    if (!confirm('Bạn có chắc muốn xóa tất cả dịch vụ khỏi giỏ hàng?')) return;

    cartItems = [];
    // Always use session_cart regardless of login status
    localStorage.removeItem('session_cart');
    
    updateCartDisplay();
    await updateCartIcon();
    window.dispatchEvent(new CustomEvent('cartUpdated'));
    showNotification('Đã xóa tất cả dịch vụ khỏi giỏ hàng', 'success');
}

// Calculate totals
function calculateTotals() {
    const total = cartItems.reduce((sum, item) => sum + (item.servicePrice * item.quantity), 0);
    const totalDuration = cartItems.reduce((sum, item) => sum + (item.serviceDuration * item.quantity), 0);
    const totalItems = cartItems.reduce((sum, item) => sum + item.quantity, 0);
    
    return { total, totalDuration, totalItems };
}

// Update cart display
function updateCartDisplay() {
    const cartItemsContainer = document.getElementById('cartItems');
    const emptyCartMessage = document.getElementById('emptyCartMessage');
    const cartFooter = document.getElementById('cartFooter');
    const cartItemCount = document.getElementById('cartItemCount');
    
    if (!cartItemsContainer || !emptyCartMessage || !cartFooter || !cartItemCount) return;

    // Update cart item count
    const totalItems = cartItems.reduce((sum, item) => sum + item.quantity, 0);
    cartItemCount.textContent = totalItems;

    if (cartItems.length === 0) {
        emptyCartMessage.style.display = 'block';
        cartItemsContainer.style.display = 'none';
        cartFooter.style.display = 'none';
        return;
    }

    // Show cart items and footer
    emptyCartMessage.style.display = 'none';
    cartItemsContainer.style.display = 'block';
    cartFooter.style.display = 'block';

    // Render cart items
    cartItemsContainer.innerHTML = cartItems.map(item => {
        // Use placehold.co placeholder if no image
        const imageUrl = item.serviceImage || `https://placehold.co/300x200/FFB6C1/333333?text=${encodeURIComponent(item.serviceName || 'Service')}`;
        
        return `
        <div class="flex items-start space-x-4 p-4 bg-white rounded-lg border border-gray-200">
            <img src="${imageUrl}" alt="${item.serviceName}" class="w-20 h-20 object-cover rounded-lg">
            <div class="flex-1">
                <h3 class="font-medium text-gray-900">${item.serviceName}</h3>
                <p class="text-[#D4AF37] font-medium mt-1">
                    ${formatCurrency(item.servicePrice)}
                </p>
                <p class="text-gray-500 text-sm mt-1">
                    ${item.serviceDuration} phút
                </p>
            </div>
            <div class="flex items-center space-x-2">
                <button onclick="updateQuantity('${item.id}', ${item.quantity - 1})" class="p-1 hover:text-primary">
                    <i data-lucide="minus" class="h-4 w-4"></i>
                </button>
                <span class="w-8 text-center">${item.quantity}</span>
                <button onclick="updateQuantity('${item.id}', ${item.quantity + 1})" class="p-1 hover:text-primary">
                    <i data-lucide="plus" class="h-4 w-4"></i>
                </button>
                <button onclick="removeFromCart('${item.id}')" class="p-1 text-red-500 hover:text-red-700 ml-2">
                    <i data-lucide="trash-2" class="h-4 w-4"></i>
                </button>
            </div>
        </div>
        `;
    }).join('');

    // Update totals
    const totalPrice = cartItems.reduce((sum, item) => sum + (item.servicePrice * item.quantity), 0);
    const totalDuration = cartItems.reduce((sum, item) => sum + (item.serviceDuration * item.quantity), 0);
    
    document.getElementById('totalPrice').textContent = formatCurrency(totalPrice);
    document.getElementById('totalDuration').textContent = `${totalDuration} phút`;
    document.getElementById('totalItems').textContent = totalItems;

    // Reinitialize Lucide icons
    lucide.createIcons();
}

// Update cart icon in header
async function updateCartIcon() {
    const badge = document.getElementById('cart-badge');
    if (!badge) {
        console.log('⚠️ Cart badge element not found');
        return;
    }

    // Calculate total items
    let totalItems = 0;
    try {
        // Always use session_cart regardless of login status
        const cartKey = 'session_cart';
        const savedCart = localStorage.getItem(cartKey);
        if (savedCart) {
            const currentCart = JSON.parse(savedCart);
            totalItems = currentCart.reduce((sum, item) => sum + item.quantity, 0);
        }
        console.log(`🔢 Cart icon updated: ${totalItems} items`);
    } catch (error) {
        console.error('❌ Error calculating cart total for icon:', error);
    }

    if (totalItems > 0) {
        badge.textContent = totalItems > 99 ? '99+' : totalItems;
        badge.style.display = 'flex';
    } else {
        badge.style.display = 'none';
    }
}

// Show/hide loading indicator
function showLoading(show) {
    const loadingOverlay = document.getElementById('cartLoadingOverlay');
    const loadingIndicator = document.getElementById('loadingIndicator');
    const cartContent = document.getElementById('cartContent');
    if (loadingOverlay && loadingIndicator && cartContent) {
        loadingOverlay.style.display = show ? 'block' : 'none';
        loadingIndicator.style.display = show ? 'block' : 'none';
        cartContent.style.opacity = show ? '0.5' : '1';
    }
}

// Show notification using global SpaApp system
function showNotification(message, type = 'success') {
    // Use the global SpaApp notification system for consistency
    if (window.SpaApp && typeof window.SpaApp.showNotification === 'function') {
        window.SpaApp.showNotification(message, type);
    } else {
        // Fallback to console if SpaApp is not available
        console.log(`[Cart ${type.toUpperCase()}]: ${message}`);
    }
}

// Open cart modal
function openCart() {
    const cartModal = document.getElementById('cartModal');
    if (cartModal) {
        cartModal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
        updateCartDisplay();
    }
}

// Close cart modal
function closeCart() {
    const cartModal = document.getElementById('cartModal');
    if (cartModal) {
        cartModal.style.display = 'none';
        document.body.style.overflow = '';
    }
}

// Proceed to checkout
function proceedToCheckout() {
    if (cartItems.length === 0) {
        showNotification('Giỏ hàng trống', 'error');
        return;
    }

    // Redirect to booking checkout page
    const contextPath = window.spaConfig ? window.spaConfig.contextPath : '';
    window.location.href = contextPath + '/booking-checkout';
}



// Format currency
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(amount);
}

// Close cart when clicking outside
document.addEventListener('click', (event) => {
    const cartModal = document.getElementById('cartModal');
    if (!cartModal) return;

    const isClickInside = event.target.closest('.bg-white');
    const isCartIconClick = event.target.closest('#cart-icon-btn');

    if (!isClickInside && !isCartIconClick && cartModal.style.display === 'flex') {
        closeCart();
    }
});

// Close cart on escape key
document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
        closeCart();
    }
});

// Export functions for use in other files
window.cart = {
    addToCart,
    openCart,
    closeCart
};

// Make key functions available globally
window.addToCart = addToCart;
window.openCart = openCart;
window.closeCart = closeCart;
window.clearCart = clearCart; 