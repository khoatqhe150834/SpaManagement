/**
 * Recently Viewed Services Manager
 * Handles tracking, display, and interaction for recently viewed services
 */
class RecentlyViewedServices {
    constructor() {
        this.storageKey = 'recently_viewed_services';
        this.maxItems = 10; // Keep max 10 items in storage
        this.displayItems = 4; // Show max 4 items in UI
        this.recentlyViewed = [];
        this.section = null;
        this.grid = null;
        
        this.beautyImages = [
            'https://images.pexels.com/photos/3985254/pexels-photo-3985254.jpeg?auto=compress&cs=tinysrgb&w=400',
            'https://images.pexels.com/photos/3997991/pexels-photo-3997991.jpeg?auto=compress&cs=tinysrgb&w=400',
            'https://images.pexels.com/photos/3985263/pexels-photo-3985263.jpeg?auto=compress&cs=tinysrgb&w=400',
            'https://images.pexels.com/photos/3997989/pexels-photo-3997989.jpeg?auto=compress&cs=tinysrgb&w=400',
            'https://images.pexels.com/photos/3985330/pexels-photo-3985330.jpeg?auto=compress&cs=tinysrgb&w=400',
            'https://images.pexels.com/photos/3985331/pexels-photo-3985331.jpeg?auto=compress&cs=tinysrgb&w=400',
            'https://images.pexels.com/photos/3997992/pexels-photo-3997992.jpeg?auto=compress&cs=tinysrgb&w=400',
            'https://images.pexels.com/photos/3985337/pexels-photo-3985337.jpeg?auto=compress&cs=tinysrgb&w=400'
        ];
        
        this.init();
    }

    init() {
        // Wait for DOM to be ready
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => this.setup());
        } else {
            this.setup();
        }
    }

    setup() {
        this.section = document.getElementById('recently-viewed-section');
        this.grid = document.getElementById('recently-viewed-grid');

        if (!this.section || !this.grid) {
            console.warn('Recently viewed services elements not found');
            return;
        }

        // Load and display services
        this.loadRecentlyViewedServices();

        // Set up event listeners
        this.setupEventListeners();
    }

    setupEventListeners() {
        // View all services button
        const viewAllBtn = document.getElementById('view-all-services-btn');
        if (viewAllBtn) {
            viewAllBtn.addEventListener('click', () => {
                window.location.href = this.getContextPath() + '/services';
            });
        }

        // Listen for custom events to track service views
        document.addEventListener('trackServiceView', (event) => {
            const { serviceId, serviceName, serviceImage, servicePrice } = event.detail;
            this.trackServiceView(serviceId, serviceName, serviceImage, servicePrice);
        });
    }

    getContextPath() {
        // Get the context path from the current URL or a meta tag
        const metaContextPath = document.querySelector('meta[name="context-path"]');
        if (metaContextPath) {
            return metaContextPath.getAttribute('content');
        }
        
        // Fallback: extract from current path
        const path = window.location.pathname;
        const segments = path.split('/');
        if (segments.length > 1 && segments[1]) {
            return '/' + segments[1];
        }
        
        return '';
    }

    loadRecentlyViewedServices() {
        // Load from localStorage
        const stored = localStorage.getItem(this.storageKey);
        this.recentlyViewed = stored ? JSON.parse(stored) : [];
        
        // Filter to display items and show section if there are services
        const displayServices = this.recentlyViewed.slice(0, this.displayItems);
        
        if (displayServices.length > 0) {
            this.renderServices(displayServices);
            this.showSection();
        }
    }

    trackServiceView(serviceId, serviceName, serviceImage, servicePrice) {
        const newService = {
            id: serviceId,
            name: serviceName,
            image: serviceImage,
            price: servicePrice,
            viewedAt: new Date().toISOString()
        };

        // Remove if already exists and add to beginning
        this.recentlyViewed = this.recentlyViewed.filter(s => s.id !== serviceId);
        this.recentlyViewed.unshift(newService);

        // Keep only max items
        this.recentlyViewed = this.recentlyViewed.slice(0, this.maxItems);

        // Save to localStorage
        localStorage.setItem(this.storageKey, JSON.stringify(this.recentlyViewed));

        // Update display
        const displayServices = this.recentlyViewed.slice(0, this.displayItems);
        this.renderServices(displayServices);

        // Show section if it wasn't visible before
        if (this.section && this.section.classList.contains('hidden')) {
            this.showSection();
        }
    }

    renderServices(services) {
        if (!this.grid) return;
        
        this.grid.innerHTML = services.map((service, index) => 
            this.createServiceHTML(service, index)
        ).join('');
        
        // Re-initialize Lucide icons for the new content
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
        
        // Add event listeners to the new elements
        this.addServiceEventListeners();
    }

    createServiceHTML(service, index) {
        const contextPath = this.getContextPath();
        const formattedPrice = new Intl.NumberFormat('vi-VN', {
            style: 'decimal',
            minimumFractionDigits: 0,
            maximumFractionDigits: 0
        }).format(service.price) + ' ₫';

        const imageUrl = service.image || this.getFallbackImage(service.id);

        // Assume average rating for recently viewed services (could be enhanced to store actual ratings)
        const rating = 4.5;
        const featured = rating >= 4.5;

        return `
            <div class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1"
                 style="animation-delay: ${index * 150}ms"
                 data-service-id="${service.id}"
                 data-service-name="${service.name}"
                 data-service-image="${service.image}"
                 data-service-price="${service.price}">

                ${featured ? `
                <div class="bg-primary text-white text-xs font-semibold px-3 py-1 absolute z-10 rounded-br-lg">
                    Đã xem
                </div>` : ''}

                <div class="relative">
                    <img src="${imageUrl}"
                         alt="${service.name}"
                         class="w-full h-48 object-cover"
                         onerror="this.onerror=null; this.src='${this.beautyImages[0]}'">

                    <div class="absolute top-3 right-3 bg-white/90 px-2 py-1 rounded-full">
                        <div class="flex items-center">
                            <i data-lucide="star" class="h-3 w-3 text-primary fill-current mr-1"></i>
                            <span class="text-xs font-medium">${rating.toFixed(1)}</span>
                        </div>
                    </div>
                </div>

                <div class="p-5">
                    <div class="mb-2">
                        <span class="text-xs text-primary font-medium bg-secondary px-2 py-1 rounded-full">Đã xem gần đây</span>
                    </div>
                    <h3 class="text-lg font-semibold text-spa-dark mb-2 truncate">${service.name}</h3>
                    <p class="text-gray-600 text-sm mb-4 h-12 overflow-hidden">Dịch vụ bạn đã xem gần đây</p>
                    <div class="flex items-center justify-between mb-4">
                        <div class="flex items-center text-gray-500">
                            <i data-lucide="clock" class="h-4 w-4 mr-1"></i>
                            <span class="text-sm">60 phút</span>
                        </div>
                        <div class="text-xl font-bold text-primary">${formattedPrice}</div>
                    </div>
                    <div class="grid grid-cols-2 gap-2">
                        <button class="view-details-btn w-full bg-secondary text-spa-dark py-2.5 px-3 rounded-full hover:bg-primary hover:text-white transition-all duration-300 font-medium text-sm flex items-center justify-center" data-id="${service.id}">
                            Xem chi tiết
                        </button>
                        <button class="add-to-cart-btn w-full bg-primary text-white py-2.5 px-3 rounded-full hover:bg-primary-dark transition-all duration-300 font-medium text-sm flex items-center justify-center" data-id="${service.id}">
                            Thêm vào giỏ
                        </button>
                    </div>
                </div>
            </div>
        `;
    }

    getFallbackImage(serviceId) {
        if (!serviceId) return this.beautyImages[0];
        const imageIndex = Math.abs(parseInt(serviceId, 10) * 7) % this.beautyImages.length;
        return this.beautyImages[imageIndex];
    }

    addServiceEventListeners() {
        // View details button handlers
        const viewDetailsButtons = this.grid.querySelectorAll('.view-details-btn');
        viewDetailsButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                e.stopPropagation();
                const serviceId = button.dataset.id;

                // Track the service view
                const serviceItem = button.closest('[data-service-id]');
                if (serviceItem) {
                    const serviceName = serviceItem.dataset.serviceName;
                    const serviceImage = serviceItem.dataset.serviceImage;
                    const servicePrice = parseInt(serviceItem.dataset.servicePrice);

                    this.trackServiceView(serviceId, serviceName, serviceImage, servicePrice);
                }

                // Navigate to service details page
                window.location.href = this.getContextPath() + '/service-details?id=' + serviceId;
            });
        });

        // Add to cart button handlers
        const addToCartButtons = this.grid.querySelectorAll('.add-to-cart-btn');
        addToCartButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                e.stopPropagation();
                const serviceId = button.dataset.id;
                const serviceItem = button.closest('[data-service-id]');

                if (serviceItem) {
                    const serviceName = serviceItem.dataset.serviceName;
                    const serviceImage = serviceItem.dataset.serviceImage;
                    const servicePrice = parseInt(serviceItem.dataset.servicePrice);

                    // Track the service view when adding to cart
                    this.trackServiceView(serviceId, serviceName, serviceImage, servicePrice);

                    // Create service data for cart
                    const serviceData = {
                        serviceId: parseInt(serviceId),
                        serviceName: serviceName,
                        serviceImage: serviceImage,
                        servicePrice: servicePrice,
                        serviceDuration: 60 // Default duration
                    };

                    // Add to cart using global function
                    if (typeof window.addToCart === 'function') {
                        window.addToCart(serviceData);
                    } else {
                        console.error('Global addToCart function not found!');
                        alert('Không thể thêm vào giỏ hàng. Vui lòng thử lại.');
                    }
                }
            });
        });
    }

    showSection() {
        if (!this.section) return;

        this.section.classList.remove('hidden');

        // Trigger animation after a short delay
        setTimeout(() => {
            this.section.classList.remove('opacity-0', 'translate-y-8');
            this.section.classList.add('opacity-100', 'translate-y-0');
        }, 100);
    }

    hideSection() {
        if (!this.section) return;
        
        this.section.classList.add('opacity-0', 'translate-y-8');
        this.section.classList.remove('opacity-100', 'translate-y-0');
        
        setTimeout(() => {
            this.section.classList.add('hidden');
        }, 1000);
    }

    clearRecentlyViewed() {
        this.recentlyViewed = [];
        localStorage.removeItem(this.storageKey);
        this.hideSection();
    }

    // Public API methods
    getRecentlyViewed() {
        return [...this.recentlyViewed];
    }

    removeService(serviceId) {
        this.recentlyViewed = this.recentlyViewed.filter(s => s.id !== serviceId);
        localStorage.setItem(this.storageKey, JSON.stringify(this.recentlyViewed));
        
        const displayServices = this.recentlyViewed.slice(0, this.displayItems);
        if (displayServices.length > 0) {
            this.renderServices(displayServices);
        } else {
            this.hideSection();
        }
    }
}

// Global utility function to track service views from other pages
window.trackServiceView = function(serviceId, serviceName, serviceImage, servicePrice) {
    // Dispatch custom event that the RecentlyViewedServices instance will listen for
    const event = new CustomEvent('trackServiceView', {
        detail: { serviceId, serviceName, serviceImage, servicePrice }
    });
    document.dispatchEvent(event);
};

// Initialize when script loads
const recentlyViewedServices = new RecentlyViewedServices();

// Export for use in other scripts if needed
window.RecentlyViewedServices = RecentlyViewedServices;
window.recentlyViewedServicesInstance = recentlyViewedServices; 