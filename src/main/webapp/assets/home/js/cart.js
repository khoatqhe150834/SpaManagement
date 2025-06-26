/**
 * Cart Management JavaScript
 * Handles cart operations for the spa management system
 */

// Cart API base URL - will be set by the JSP page
let CART_API_BASE_URL = '';

/**
 * Initialize cart functionality
 */
function initializeCart() {
    // Cart icon functionality is handled by header-custom.js
    console.log('Cart functionality initialized');
}

/**
 * Update cart item quantity
 * @param {number} cartItemId - The cart item ID
 * @param {number} quantity - New quantity
 */
function updateCartQuantity(cartItemId, quantity) {
    quantity = parseInt(quantity);
    
    if (quantity < 1) {
        removeCartItem(cartItemId);
        return;
    }
    
    const formData = new FormData();
    formData.append('cartItemId', cartItemId);
    formData.append('quantity', quantity);
    
    fetch(CART_API_BASE_URL + '/update', {
        method: 'POST',
        body: formData,
        credentials: 'same-origin',
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        if (data.success) {
            showCartMessage('Đã cập nhật số lượng dịch vụ', 'success');
            // Update cart count in header
            if (typeof updateCartCount === 'function') {
                updateCartCount();
            }
            // Reload page to show updated cart
            setTimeout(() => {
                location.reload();
            }, 1000);
        } else {
            showCartMessage(data.message || 'Không thể cập nhật số lượng', 'error');
        }
    })
    .catch(error => {
        console.error('Error updating quantity:', error);
        showCartMessage('Đã có lỗi xảy ra khi cập nhật số lượng', 'error');
    });
}

/**
 * Remove item from cart
 * @param {number} cartItemId - The cart item ID to remove
 */
function removeCartItem(cartItemId) {
    if (!confirm('Bạn có chắc chắn muốn xóa dịch vụ này khỏi giỏ hàng?')) {
        return;
    }
    
    const formData = new FormData();
    formData.append('cartItemId', cartItemId);
    
    fetch(CART_API_BASE_URL + '/remove', {
        method: 'POST',
        body: formData,
        credentials: 'same-origin',
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        if (data.success) {
            showCartMessage('Đã xóa dịch vụ khỏi giỏ hàng', 'success');
            // Update cart count in header
            if (typeof updateCartCount === 'function') {
                updateCartCount();
            }
            // Remove the cart item element from DOM
            const cartItemElement = document.querySelector(`[data-cart-item-id="${cartItemId}"]`);
            if (cartItemElement) {
                cartItemElement.style.transition = 'opacity 0.3s ease';
                cartItemElement.style.opacity = '0';
                setTimeout(() => {
                    cartItemElement.remove();
                    // Check if cart is now empty
                    checkEmptyCart();
                }, 300);
            } else {
                // Fallback: reload page
                setTimeout(() => {
                    location.reload();
                }, 1000);
            }
        } else {
            showCartMessage(data.message || 'Không thể xóa dịch vụ', 'error');
        }
    })
    .catch(error => {
        console.error('Error removing item:', error);
        showCartMessage('Đã có lỗi xảy ra khi xóa dịch vụ', 'error');
    });
}

/**
 * Clear entire cart
 */
function clearCartItems() {
    if (!confirm('Bạn có chắc chắn muốn xóa toàn bộ giỏ hàng?')) {
        return;
    }
    
    fetch(CART_API_BASE_URL + '/clear', {
        method: 'POST',
        credentials: 'same-origin',
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        if (data.success) {
            showCartMessage('Đã xóa toàn bộ giỏ hàng', 'success');
            // Update cart count in header
            if (typeof updateCartCount === 'function') {
                updateCartCount();
            }
            // Reload page to show empty cart
            setTimeout(() => {
                location.reload();
            }, 1000);
        } else {
            showCartMessage(data.message || 'Không thể xóa giỏ hàng', 'error');
        }
    })
    .catch(error => {
        console.error('Error clearing cart:', error);
        showCartMessage('Đã có lỗi xảy ra khi xóa giỏ hàng', 'error');
    });
}

/**
 * Proceed to booking with cart items
 */
function proceedToBooking() {
    // Check if cart has items
    const cartItems = document.querySelectorAll('.cart-item');
    if (cartItems.length === 0) {
        showCartMessage('Giỏ hàng của bạn đang trống', 'error');
        return;
    }
    
    // Redirect to booking time selection
    window.location.href = CART_API_BASE_URL.replace('/api/cart', '/process-booking/time');
}

/**
 * Check if cart is empty and show appropriate message
 */
function checkEmptyCart() {
    const cartItems = document.querySelectorAll('.cart-item');
    const cartSummary = document.querySelector('.cart-summary');
    const cartItemsContainer = document.querySelector('.cart-items');
    
    if (cartItems.length === 0) {
        // Hide cart summary
        if (cartSummary) {
            cartSummary.style.display = 'none';
        }
        
        // Show empty cart message
        if (cartItemsContainer) {
            cartItemsContainer.innerHTML = `
                <div class="empty-cart">
                    <i class="fa fa-shopping-cart" style="font-size: 4rem; color: #ddd; margin-bottom: 1rem;"></i>
                    <h4>Giỏ hàng của bạn đang trống</h4>
                    <p>Hãy khám phá các dịch vụ tuyệt vời của chúng tôi!</p>
                    <a href="${CART_API_BASE_URL.replace('/api/cart', '/process-booking/services')}" class="continue-shopping">
                        <i class="fa fa-spa"></i> Khám Phá Dịch Vụ
                    </a>
                </div>
            `;
        }
    }
}

/**
 * Show cart message to user
 * @param {string} message - Message to display
 * @param {string} type - Message type (success, error, info)
 */
function showCartMessage(message, type = 'info') {
    // Use the message function from header-custom.js if available
    if (typeof window.showCartMessage === 'function') {
        window.showCartMessage(message, type);
        return;
    }
    
    // Create a simple notification if header-custom.js is not loaded
    const notification = document.createElement('div');
    notification.className = `cart-notification cart-notification-${type}`;
    notification.textContent = message;
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${type === 'success' ? '#4CAF50' : type === 'error' ? '#f44336' : '#2196F3'};
        color: white;
        padding: 12px 24px;
        border-radius: 8px;
        z-index: 10000;
        box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        font-family: 'Inter', sans-serif;
        font-size: 14px;
        max-width: 300px;
        word-wrap: break-word;
    `;
    
    document.body.appendChild(notification);
    
    // Auto-remove after 3 seconds
    setTimeout(() => {
        notification.style.opacity = '0';
        notification.style.transition = 'opacity 0.3s ease';
        setTimeout(() => {
            if (notification.parentNode) {
                notification.remove();
            }
        }, 300);
    }, 3000);
}

/**
 * Setup quantity input handlers
 */
function setupQuantityHandlers() {
    // Handle quantity input changes
    document.querySelectorAll('.quantity-input').forEach(input => {
        input.addEventListener('change', function() {
            const cartItemId = this.closest('.cart-item').getAttribute('data-cart-item-id');
            const quantity = parseInt(this.value);
            
            if (quantity >= 1) {
                updateCartQuantity(cartItemId, quantity);
            } else {
                this.value = 1; // Reset to minimum
            }
        });
        
        // Prevent invalid input
        input.addEventListener('keypress', function(e) {
            // Allow only numbers
            if (!/[0-9]/.test(e.key) && !['Backspace', 'Delete', 'ArrowLeft', 'ArrowRight'].includes(e.key)) {
                e.preventDefault();
            }
        });
    });
}

/**
 * Initialize cart page functionality when DOM is loaded
 */
document.addEventListener('DOMContentLoaded', function() {
    initializeCart();
    setupQuantityHandlers();
    
    // Setup continue shopping links
    document.querySelectorAll('.continue-shopping').forEach(link => {
        if (!link.href || link.href === '#') {
            link.href = CART_API_BASE_URL.replace('/api/cart', '/process-booking/services');
        }
    });
});

// Backward compatibility - expose functions globally
window.updateQuantity = updateCartQuantity;
window.removeFromCart = removeCartItem;
window.clearCart = clearCartItems;
window.proceedToBooking = proceedToBooking; 