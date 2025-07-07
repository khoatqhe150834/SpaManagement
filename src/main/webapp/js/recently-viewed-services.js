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
        
        // Initialize with demo data if empty (for testing - remove in production)
        this.initializeDemoData();
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
        const formattedPrice = new Intl.NumberFormat('vi-VN').format(service.price);
        const viewedDate = new Date(service.viewedAt).toLocaleDateString('vi-VN');
        
        return `
            <div class="service-item group cursor-pointer bg-white rounded-xl shadow-lg hover:shadow-2xl transition-all duration-500 overflow-hidden border border-gray-100 transform hover:scale-105 animate-fadeIn"
                 style="animation-delay: ${index * 150}ms"
                 data-service-id="${service.id}"
                 data-service-name="${service.name}"
                 data-service-image="${service.image}"
                 data-service-price="${service.price}">
                
                <div class="relative overflow-hidden">
                    <img src="${service.image}"
                         alt="${service.name}"
                         class="w-full h-48 object-cover group-hover:scale-110 transition-transform duration-500"
                         onerror="this.src='${contextPath}/assets/home/images/placeholder-service.jpg'">
                    
                    <div class="absolute inset-0 bg-gradient-to-t from-black/30 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                    
                    <div class="absolute top-3 right-3 bg-primary/90 backdrop-blur-sm rounded-full p-2 transform scale-0 group-hover:scale-100 transition-transform duration-300">
                        <i data-lucide="eye" class="h-4 w-4 text-white"></i>
                    </div>
                    
                    <div class="absolute bottom-3 left-3 bg-white/90 backdrop-blur-sm rounded-full px-3 py-1 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                        <span class="text-xs font-medium text-spa-dark">Đã xem</span>
                    </div>
                </div>
                
                <div class="p-5">
                    <h3 class="font-semibold text-spa-dark text-lg mb-3 line-clamp-2 group-hover:text-primary transition-colors duration-300 leading-tight">
                        ${service.name}
                    </h3>
                    
                    <div class="flex items-center justify-between mb-4">
                        <div class="text-2xl font-bold text-primary">
                            ${formattedPrice}đ
                        </div>
                        <div class="text-xs text-gray-500">
                            ${viewedDate}
                        </div>
                    </div>
                    
                    <button class="book-service-btn w-full bg-gradient-to-r from-primary to-primary-dark text-white py-3 rounded-lg hover:from-primary-dark hover:to-primary transition-all duration-300 font-semibold text-sm flex items-center justify-center shadow-md hover:shadow-lg transform hover:scale-105">
                        <i data-lucide="calendar" class="h-4 w-4 mr-2"></i>
                        Đặt ngay
                    </button>
                </div>
            </div>
        `;
    }

    addServiceEventListeners() {
        // Service item click handlers
        const serviceItems = this.grid.querySelectorAll('.service-item');
        serviceItems.forEach(item => {
            item.addEventListener('click', (e) => {
                // Don't navigate if clicking on book button
                if (e.target.closest('.book-service-btn')) {
                    return;
                }
                
                // Track the service view and navigate to services
                const serviceId = item.dataset.serviceId;
                const serviceName = item.dataset.serviceName;
                const serviceImage = item.dataset.serviceImage;
                const servicePrice = parseInt(item.dataset.servicePrice);
                
                this.trackServiceView(serviceId, serviceName, serviceImage, servicePrice);
                window.location.href = this.getContextPath() + '/services';
            });
        });

        // Book service button handlers
        const bookButtons = this.grid.querySelectorAll('.book-service-btn');
        bookButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                e.stopPropagation();
                window.location.href = this.getContextPath() + '/booking';
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

    // Demo data initialization (remove in production)
    initializeDemoData() {
        const existingServices = JSON.parse(localStorage.getItem(this.storageKey) || '[]');
        if (existingServices.length === 0) {
            const demoServices = [
                {
                    id: '1',
                    name: 'Massage thư giãn toàn thân',
                    image: 'https://images.pexels.com/photos/3997989/pexels-photo-3997989.jpeg?auto=compress&cs=tinysrgb&w=400',
                    price: 500000,
                    viewedAt: new Date(Date.now() - 1000 * 60 * 30).toISOString() // 30 minutes ago
                },
                {
                    id: '2',
                    name: 'Chăm sóc da mặt cao cấp',
                    image: 'https://images.pexels.com/photos/3985263/pexels-photo-3985263.jpeg?auto=compress&cs=tinysrgb&w=400',
                    price: 800000,
                    viewedAt: new Date(Date.now() - 1000 * 60 * 60).toISOString() // 1 hour ago
                },
                {
                    id: '3',
                    name: 'Tắm trắng collagen',
                    image: 'https://images.pexels.com/photos/3985254/pexels-photo-3985254.jpeg?auto=compress&cs=tinysrgb&w=400',
                    price: 300000,
                    viewedAt: new Date(Date.now() - 1000 * 60 * 60 * 2).toISOString() // 2 hours ago
                }
            ];
            
            localStorage.setItem(this.storageKey, JSON.stringify(demoServices));
            this.recentlyViewed = demoServices;
            
            // Show demo services
            const displayServices = this.recentlyViewed.slice(0, this.displayItems);
            this.renderServices(displayServices);
            this.showSection();
        }
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