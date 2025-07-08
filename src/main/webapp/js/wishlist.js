/**
 * Wishlist Management System
 * Handles wishlist modal, item management, and localStorage operations
 */

class WishlistManager {
    constructor() {
        this.wishlistItems = [];
        this.currentUser = null;
        this.isAuthenticated = false;
        this.modal = null;
        this.isLoading = false;
        
        this.init();
    }

    /**
     * Initialize the wishlist manager
     */
    init() {
        this.modal = document.getElementById('wishlistModal');
        this.checkAuthenticationStatus();
        this.bindEvents();
        this.loadWishlist();
    }

    /**
     * Check if user is authenticated (from session or localStorage)
     */
    checkAuthenticationStatus() {
        // Check if user is logged in from session (you can modify this based on your auth system)
        const userSession = sessionStorage.getItem('currentUser');
        const userLocal = localStorage.getItem('currentUser');
        
        if (userSession || userLocal) {
            this.currentUser = JSON.parse(userSession || userLocal);
            this.isAuthenticated = true;
        } else {
            // Check for user data from JSP
            const userDataElement = document.getElementById('userData');
            if (userDataElement) {
                const userId = userDataElement.getAttribute('data-user-id');
                const userType = userDataElement.getAttribute('data-user-type');
                if (userId) {
                    this.currentUser = { 
                        id: userId, 
                        userType: userType 
                    };
                    this.isAuthenticated = true;
                }
            }
        }
    }

    /**
     * Bind event listeners
     */
    bindEvents() {
        // Modal close buttons
        document.getElementById('closeWishlistBtn')?.addEventListener('click', () => this.closeModal());
        document.getElementById('closeFooterBtn')?.addEventListener('click', () => this.closeModal());
        document.getElementById('exploreServicesBtn')?.addEventListener('click', () => this.exploreServices());
        
        // Add all to cart button
        document.getElementById('addAllToCartBtn')?.addEventListener('click', () => this.addAllToCart());
        
        // Close modal when clicking outside
        this.modal?.addEventListener('click', (e) => {
            if (e.target === this.modal) {
                this.closeModal();
            }
        });
        
        // Escape key to close modal
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && this.modal?.classList.contains('active')) {
                this.closeModal();
            }
        });
    }

    /**
     * Load wishlist items from localStorage
     */
    async loadWishlist() {
        if (!this.isAuthenticated || !this.currentUser) {
            this.showNotAuthenticatedState();
            return;
        }

        this.showLoadingState();
        
        try {
            // Simulate API call delay
            await new Promise(resolve => setTimeout(resolve, 300));
            
            const savedWishlist = localStorage.getItem(`wishlist_${this.currentUser.id}`);
            this.wishlistItems = savedWishlist ? JSON.parse(savedWishlist) : [];
            
            this.renderWishlist();
        } catch (error) {
            console.error('Failed to load wishlist:', error);
            this.showNotification('Không thể tải danh sách yêu thích', 'error');
            this.showEmptyState();
        }
    }

    /**
     * Save wishlist to localStorage
     */
    saveWishlist() {
        if (!this.currentUser) return;
        
        try {
            localStorage.setItem(`wishlist_${this.currentUser.id}`, JSON.stringify(this.wishlistItems));
        } catch (error) {
            console.error('Failed to save wishlist:', error);
            this.showNotification('Không thể lưu danh sách yêu thích', 'error');
        }
    }

    /**
     * Show the wishlist modal
     */
    showModal() {
        this.modal?.classList.add('active');
        document.body.style.overflow = 'hidden';
        this.loadWishlist();
    }

    /**
     * Close the wishlist modal
     */
    closeModal() {
        this.modal?.classList.remove('active');
        document.body.style.overflow = '';
    }

    /**
     * Navigate to services page
     */
    exploreServices() {
        window.location.href = '/services';
        this.closeModal();
    }

    /**
     * Add item to wishlist
     */
    addToWishlist(serviceData) {
        if (!this.isAuthenticated) {
            this.showNotification('Vui lòng đăng nhập để sử dụng tính năng này', 'error');
            return false;
        }

        const existingItem = this.wishlistItems.find(item => item.serviceId === serviceData.serviceId);
        if (existingItem) {
            this.showNotification('Dịch vụ đã có trong danh sách yêu thích', 'error');
            return false;
        }

        const newItem = {
            id: Date.now().toString(),
            serviceId: serviceData.serviceId,
            serviceName: serviceData.serviceName,
            serviceImage: serviceData.serviceImage,
            servicePrice: serviceData.servicePrice,
            serviceRating: serviceData.serviceRating || 5.0,
            addedAt: new Date().toISOString()
        };

        this.wishlistItems.push(newItem);
        this.saveWishlist();
        this.showNotification('Đã thêm vào danh sách yêu thích', 'success');
        this.updateWishlistCount();
        
        return true;
    }

    /**
     * Remove item from wishlist
     */
    removeFromWishlist(itemId) {
        const itemIndex = this.wishlistItems.findIndex(item => item.id === itemId);
        if (itemIndex === -1) return false;

        this.wishlistItems.splice(itemIndex, 1);
        this.saveWishlist();
        this.showNotification('Đã xóa khỏi danh sách yêu thích', 'success');
        this.renderWishlist();
        
        return true;
    }

    /**
     * Check if service is in wishlist
     */
    isInWishlist(serviceId) {
        return this.wishlistItems.some(item => item.serviceId === serviceId);
    }

    /**
     * Move item to cart
     */
    moveToCart(serviceId) {
        // Find the item in wishlist
        const item = this.wishlistItems.find(item => item.serviceId === serviceId);
        if (!item) return;

        // Add to cart (you can customize this based on your cart system)
        this.addToCart(item);
        
        // Remove from wishlist
        this.removeFromWishlist(item.id);
        
        this.showNotification('Đã thêm vào giỏ hàng', 'success');
    }

    /**
     * Add all items to cart
     */
    addAllToCart() {
        if (this.wishlistItems.length === 0) return;

        this.wishlistItems.forEach(item => {
            this.addToCart(item);
        });

        // Clear wishlist
        this.wishlistItems = [];
        this.saveWishlist();
        this.renderWishlist();
        
        this.showNotification(`Đã thêm tất cả vào giỏ hàng`, 'success');
    }

    /**
     * Add item to cart (customize based on your cart system)
     */
    addToCart(item) {
        // This is a placeholder - implement your cart logic here
        console.log('Adding to cart:', item);
        
        // Example: Send to cart API or add to cart localStorage
        try {
            const currentCartItems = JSON.parse(localStorage.getItem('cart') || '[]');
            const existingCartItem = currentCartItems.find(cartItem => cartItem.serviceId === item.serviceId);

            if (!existingCartItem) {
                currentCartItems.push({
                    serviceId: item.serviceId,
                    serviceName: item.serviceName,
                    serviceImage: item.serviceImage,
                    servicePrice: item.servicePrice,
                    quantity: 1,
                    addedAt: new Date().toISOString()
                });
                localStorage.setItem('cart', JSON.stringify(currentCartItems));
            }
        } catch (error) {
            console.error('Failed to add to cart:', error);
        }
    }

    /**
     * Render wishlist items
     */
    renderWishlist() {
        this.hideAllStates();
        
        if (this.wishlistItems.length === 0) {
            this.showEmptyState();
            return;
        }

        this.showWishlistItems();
        this.updateWishlistCount();
        
        const container = document.getElementById('wishlistItems');
        const template = document.getElementById('wishlistItemTemplate');
        
        if (!container || !template) return;

        container.innerHTML = '';
        
        this.wishlistItems.forEach(item => {
            const itemElement = template.content.cloneNode(true);
            
            // Populate item data
            itemElement.querySelector('.service-image').src = item.serviceImage;
            itemElement.querySelector('.service-image').alt = item.serviceName;
            itemElement.querySelector('.service-name').textContent = item.serviceName;
            itemElement.querySelector('.service-rating').textContent = item.serviceRating.toFixed(1);
            itemElement.querySelector('.service-price').textContent = `${item.servicePrice.toLocaleString()}đ`;
            itemElement.querySelector('.added-date').textContent = 
                `Thêm vào: ${new Date(item.addedAt).toLocaleDateString('vi-VN')}`;
            
            // Bind events
            itemElement.querySelector('.remove-btn').addEventListener('click', () => {
                this.removeFromWishlist(item.id);
            });
            
            itemElement.querySelector('.add-to-cart-btn').addEventListener('click', () => {
                this.moveToCart(item.serviceId);
            });
            
            itemElement.querySelector('.view-details-btn').addEventListener('click', () => {
                this.viewServiceDetails(item.serviceId);
            });
            
            container.appendChild(itemElement);
        });
        
        // Re-initialize Lucide icons for new elements
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
    }

    /**
     * View service details
     */
    viewServiceDetails(serviceId) {
        window.location.href = `/services/${serviceId}`;
    }

    /**
     * Update wishlist count display
     */
    updateWishlistCount() {
        const countElement = document.getElementById('wishlistCount');
        const totalElement = document.getElementById('totalItemsText');
        
        if (countElement) {
            countElement.textContent = this.wishlistItems.length;
        }
        
        if (totalElement) {
            totalElement.textContent = `Tổng ${this.wishlistItems.length} dịch vụ yêu thích`;
        }
    }

    /**
     * Show different states
     */
    showNotAuthenticatedState() {
        this.hideAllStates();
        document.getElementById('notAuthenticatedState')?.classList.remove('hidden');
    }

    showLoadingState() {
        this.hideAllStates();
        document.getElementById('loadingState')?.classList.remove('hidden');
    }

    showEmptyState() {
        this.hideAllStates();
        document.getElementById('emptyState')?.classList.remove('hidden');
    }

    showWishlistItems() {
        this.hideAllStates();
        document.getElementById('wishlistItems')?.classList.remove('hidden');
        document.getElementById('wishlistFooter')?.classList.remove('hidden');
    }

    hideAllStates() {
        const states = [
            'notAuthenticatedState',
            'loadingState', 
            'emptyState',
            'wishlistItems',
            'wishlistFooter'
        ];
        
        states.forEach(stateId => {
            document.getElementById(stateId)?.classList.add('hidden');
        });
    }

    /**
     * Show notification
     */
    showNotification(message, type = 'success') {
        const container = document.getElementById('notificationContainer');
        if (!container) return;

        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.textContent = message;
        
        container.appendChild(notification);
        
        // Trigger animation
        setTimeout(() => {
            notification.classList.add('show');
        }, 100);
        
        // Remove notification after 3 seconds
        setTimeout(() => {
            notification.classList.remove('show');
            setTimeout(() => {
                container.removeChild(notification);
            }, 300);
        }, 3000);
    }
}

/**
 * Wishlist Button Component
 * Manages individual wishlist buttons on service cards
 */
class WishlistButton {
    constructor(element, serviceData) {
        this.element = element;
        this.serviceData = serviceData;
        this.isInWishlist = false;
        this.isLoading = false;
        
        this.init();
    }

    init() {
        this.checkWishlistStatus();
        this.bindEvents();
    }

    checkWishlistStatus() {
        if (window.wishlistManager) {
            this.isInWishlist = window.wishlistManager.isInWishlist(this.serviceData.serviceId);
            this.updateButtonState();
        }
    }

    bindEvents() {
        this.element.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            this.toggleWishlist();
        });
    }

    async toggleWishlist() {
        if (this.isLoading) return;
        
        this.isLoading = true;
        this.updateButtonState();
        
        try {
            if (this.isInWishlist) {
                // Remove from wishlist
                const items = window.wishlistManager.wishlistItems;
                const item = items.find(item => item.serviceId === this.serviceData.serviceId);
                if (item) {
                    window.wishlistManager.removeFromWishlist(item.id);
                    this.isInWishlist = false;
                }
            } else {
                // Add to wishlist
                const success = window.wishlistManager.addToWishlist(this.serviceData);
                if (success) {
                    this.isInWishlist = true;
                }
            }
            
            this.updateButtonState();
        } catch (error) {
            console.error('Failed to toggle wishlist:', error);
            window.wishlistManager.showNotification('Có lỗi xảy ra', 'error');
        } finally {
            this.isLoading = false;
        }
    }

    updateButtonState() {
        const heartIcon = this.element.querySelector('[data-lucide="heart"]');
        
        if (this.isLoading) {
            this.element.classList.add('opacity-50', 'cursor-not-allowed');
            this.element.disabled = true;
            if (heartIcon) {
                heartIcon.className = 'h-5 w-5 animate-spin';
            }
        } else {
            this.element.classList.remove('opacity-50', 'cursor-not-allowed');
            this.element.disabled = false;
            
            if (this.isInWishlist) {
                this.element.className = 'wishlist-btn p-2 rounded-full transition-all duration-300 bg-red-100 text-red-500 hover:bg-red-200';
                this.element.title = 'Xóa khỏi yêu thích';
                if (heartIcon) {
                    heartIcon.className = 'h-5 w-5 fill-current';
                }
            } else {
                this.element.className = 'wishlist-btn p-2 rounded-full transition-all duration-300 bg-gray-100 text-gray-500 hover:bg-red-100 hover:text-red-500';
                this.element.title = 'Thêm vào yêu thích';
                if (heartIcon) {
                    heartIcon.className = 'h-5 w-5';
                }
            }
        }
    }
}

// Initialize wishlist manager when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    window.wishlistManager = new WishlistManager();
    
    // Initialize wishlist buttons
    document.querySelectorAll('.wishlist-btn').forEach(button => {
        const serviceData = {
            serviceId: button.getAttribute('data-service-id'),
            serviceName: button.getAttribute('data-service-name'),
            serviceImage: button.getAttribute('data-service-image'),
            servicePrice: parseFloat(button.getAttribute('data-service-price')),
            serviceRating: parseFloat(button.getAttribute('data-service-rating')) || 5.0
        };
        
        if (serviceData.serviceId) {
            new WishlistButton(button, serviceData);
        }
    });
});

// Global functions for external use
window.showWishlist = function() {
    if (window.wishlistManager) {
        window.wishlistManager.showModal();
    }
};

window.addToWishlist = function(serviceData) {
    if (window.wishlistManager) {
        return window.wishlistManager.addToWishlist(serviceData);
    }
    return false;
};

window.removeFromWishlist = function(serviceId) {
    if (window.wishlistManager) {
        const items = window.wishlistManager.wishlistItems;
        const item = items.find(item => item.serviceId === serviceId);
        if (item) {
            return window.wishlistManager.removeFromWishlist(item.id);
        }
    }
    return false;
};

window.isInWishlist = function(serviceId) {
    if (window.wishlistManager) {
        return window.wishlistManager.isInWishlist(serviceId);
    }
    return false;
}; 