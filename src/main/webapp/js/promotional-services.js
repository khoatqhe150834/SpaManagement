/**
 * Promotional and Most Purchased Services Manager
 * Handles display and interaction for promotional services and most purchased services sections
 */
class PromotionalServicesManager {
    constructor() {
        this.promotionalSection = null;
        this.promotionalGrid = null;
        this.mostPurchasedSection = null;
        this.mostPurchasedGrid = null;
        
        // Sample data - in a real app, this would come from API/backend
        this.promotionalServices = [];
        this.mostPurchasedServices = [];
        
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
        this.promotionalSection = document.getElementById('promotional-services-section');
        this.promotionalGrid = document.getElementById('promotional-services-grid');
        this.mostPurchasedSection = document.getElementById('most-purchased-section');
        this.mostPurchasedGrid = document.getElementById('most-purchased-grid');
        
        if (!this.promotionalSection && !this.mostPurchasedSection) {
            console.warn('Promotional/Most purchased services elements not found');
            return;
        }

        // Initialize with demo data
        this.initializeDemoData();
        
        // Render services
        this.renderPromotionalServices();
        this.renderMostPurchasedServices();
        
        // Set up event listeners
        this.setupEventListeners();
    }

    setupEventListeners() {
        // View all promotions button
        const promotionsBtn = document.getElementById('view-all-promotions-btn');
        if (promotionsBtn) {
            promotionsBtn.addEventListener('click', () => {
                window.location.href = this.getContextPath() + '/promotions';
            });
        }

        // View all popular services button
        const popularBtn = document.getElementById('view-all-popular-btn');
        if (popularBtn) {
            popularBtn.addEventListener('click', () => {
                window.location.href = this.getContextPath() + '/services';
            });
        }
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

    renderPromotionalServices() {
        if (!this.promotionalGrid || this.promotionalServices.length === 0) return;
        
        this.promotionalGrid.innerHTML = this.promotionalServices.map((service, index) => 
            this.createPromotionalServiceHTML(service, index)
        ).join('');
        
        // Re-initialize Lucide icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
        
        // Add event listeners
        this.addPromotionalServiceEventListeners();
    }

    renderMostPurchasedServices() {
        if (!this.mostPurchasedGrid || this.mostPurchasedServices.length === 0) return;
        
        this.mostPurchasedGrid.innerHTML = this.mostPurchasedServices.map((service, index) => 
            this.createMostPurchasedServiceHTML(service, index)
        ).join('');
        
        // Re-initialize Lucide icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
        
        // Add event listeners
        this.addMostPurchasedServiceEventListeners();
    }

    createPromotionalServiceHTML(service, index) {
        const contextPath = this.getContextPath();
        const formattedDiscountPrice = new Intl.NumberFormat('vi-VN').format(service.discountPrice);
        const formattedOriginalPrice = new Intl.NumberFormat('vi-VN').format(service.originalPrice);
        
        return `
            <div class="promotional-service-item group cursor-pointer bg-white rounded-lg shadow-lg hover:shadow-xl transition-all duration-300 overflow-hidden"
                 data-service-id="${service.id}"
                 data-service-name="${service.name}"
                 data-service-image="${service.image}"
                 data-service-price="${service.discountPrice}">
                
                <div class="relative">
                    <img src="${service.image}"
                         alt="${service.name}"
                         class="w-full h-48 object-cover group-hover:scale-105 transition-transform duration-300"
                         onerror="this.src='${contextPath}/assets/home/images/placeholder-service.jpg'">
                    
                    <div class="absolute top-3 left-3 bg-red-500 text-white px-2 py-1 rounded-full text-xs font-bold flex items-center">
                        <i data-lucide="percent" class="h-3 w-3 mr-1"></i>
                        -${service.discountPercent}%
                    </div>
                    
                    <div class="absolute top-3 right-3 bg-primary text-white px-2 py-1 rounded text-xs font-medium">
                        ${service.category}
                    </div>
                </div>
                
                <div class="p-4">
                    <h3 class="font-semibold text-spa-dark mb-2 line-clamp-2 group-hover:text-primary transition-colors">
                        ${service.name}
                    </h3>
                    
                    <div class="flex items-center mb-2">
                        <i data-lucide="star" class="h-4 w-4 text-primary mr-1"></i>
                        <span class="text-sm font-medium">${service.rating}</span>
                        <span class="text-gray-400 text-sm ml-2">• ${service.duration} phút</span>
                    </div>
                    
                    <div class="mb-3">
                        <div class="flex items-center space-x-2">
                            <span class="text-lg font-bold text-primary">
                                ${formattedDiscountPrice}đ
                            </span>
                            <span class="text-sm text-gray-500 line-through">
                                ${formattedOriginalPrice}đ
                            </span>
                        </div>
                        <p class="text-xs text-gray-500 mt-1">
                            Có hiệu lực đến ${service.validUntil}
                        </p>
                    </div>
                    
                    <button class="promotional-book-btn w-full bg-primary text-white py-2 rounded-lg hover:bg-primary-dark transition-colors font-semibold text-sm flex items-center justify-center">
                        <i data-lucide="calendar" class="h-4 w-4 mr-2"></i>
                        Đặt ngay
                    </button>
                </div>
            </div>
        `;
    }

    createMostPurchasedServiceHTML(service, index) {
        const contextPath = this.getContextPath();
        const formattedPrice = new Intl.NumberFormat('vi-VN').format(service.price);
        const formattedPurchases = new Intl.NumberFormat('vi-VN').format(service.totalPurchases);
        
        // Determine rank badge color
        let rankBadgeClass = '';
        switch (service.popularityRank) {
            case 1:
                rankBadgeClass = 'bg-yellow-500';
                break;
            case 2:
                rankBadgeClass = 'bg-gray-400';
                break;
            case 3:
                rankBadgeClass = 'bg-amber-600';
                break;
            default:
                rankBadgeClass = 'bg-primary';
        }
        
        return `
            <div class="most-purchased-item group cursor-pointer bg-white rounded-lg shadow-sm hover:shadow-lg transition-all duration-300 overflow-hidden border border-gray-100 relative"
                 data-service-id="${service.id}"
                 data-service-name="${service.name}"
                 data-service-image="${service.image}"
                 data-service-price="${service.price}">
                
                <!-- Popularity Rank Badge -->
                <div class="absolute top-3 left-3 z-10">
                    <div class="w-8 h-8 rounded-full flex items-center justify-center text-white text-sm font-bold ${rankBadgeClass}">
                        ${service.popularityRank}
                    </div>
                </div>

                <!-- Best Seller Badge -->
                ${service.isBestSeller ? `
                <div class="absolute top-3 right-3 z-10 bg-red-500 text-white px-2 py-1 rounded-full text-xs font-bold flex items-center">
                    <i data-lucide="award" class="h-3 w-3 mr-1"></i>
                    Best Seller
                </div>
                ` : ''}
                
                <div class="relative">
                    <img src="${service.image}"
                         alt="${service.name}"
                         class="w-full h-48 object-cover group-hover:scale-105 transition-transform duration-300"
                         onerror="this.src='${contextPath}/assets/home/images/placeholder-service.jpg'">
                    <div class="absolute inset-0 bg-gradient-to-t from-black/20 to-transparent"></div>
                </div>
                
                <div class="p-4">
                    <h3 class="font-semibold text-spa-dark mb-2 line-clamp-2 group-hover:text-primary transition-colors">
                        ${service.name}
                    </h3>
                    
                    <div class="flex items-center justify-between mb-2">
                        <div class="flex items-center">
                            <i data-lucide="star" class="h-4 w-4 text-primary mr-1"></i>
                            <span class="text-sm font-medium">${service.rating}</span>
                        </div>
                        <span class="text-xs text-gray-500">${service.duration} phút</span>
                    </div>
                    
                    <div class="flex items-center mb-3">
                        <i data-lucide="trending-up" class="h-4 w-4 text-green-500 mr-1"></i>
                        <span class="text-sm text-gray-600">
                            ${formattedPurchases} lượt đặt
                        </span>
                    </div>
                    
                    <div class="flex items-center justify-between">
                        <span class="text-lg font-bold text-primary">
                            ${formattedPrice}đ
                        </span>
                        <button class="popular-book-btn bg-primary text-white px-4 py-2 rounded-lg hover:bg-primary-dark transition-colors font-semibold text-sm flex items-center">
                            <i data-lucide="shopping-cart" class="h-4 w-4 mr-1"></i>
                            Đặt
                        </button>
                    </div>
                </div>
            </div>
        `;
    }

    addPromotionalServiceEventListeners() {
        // Service item click handlers
        const serviceItems = this.promotionalGrid.querySelectorAll('.promotional-service-item');
        serviceItems.forEach(item => {
            item.addEventListener('click', (e) => {
                // Don't navigate if clicking on book button
                if (e.target.closest('.promotional-book-btn')) {
                    return;
                }
                
                // Track the service view and navigate
                this.trackServiceViewFromElement(item);
                window.location.href = this.getContextPath() + '/services';
            });
        });

        // Book service button handlers
        const bookButtons = this.promotionalGrid.querySelectorAll('.promotional-book-btn');
        bookButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                e.stopPropagation();
                window.location.href = this.getContextPath() + '/booking';
            });
        });
    }

    addMostPurchasedServiceEventListeners() {
        // Service item click handlers
        const serviceItems = this.mostPurchasedGrid.querySelectorAll('.most-purchased-item');
        serviceItems.forEach(item => {
            item.addEventListener('click', (e) => {
                // Don't navigate if clicking on book button
                if (e.target.closest('.popular-book-btn')) {
                    return;
                }
                
                // Track the service view and navigate
                this.trackServiceViewFromElement(item);
                window.location.href = this.getContextPath() + '/services';
            });
        });

        // Book service button handlers
        const bookButtons = this.mostPurchasedGrid.querySelectorAll('.popular-book-btn');
        bookButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                e.stopPropagation();
                window.location.href = this.getContextPath() + '/booking';
            });
        });
    }

    trackServiceViewFromElement(element) {
        if (!element) return;
        
        const serviceId = element.dataset.serviceId;
        const serviceName = element.dataset.serviceName;
        const serviceImage = element.dataset.serviceImage;
        const servicePrice = parseInt(element.dataset.servicePrice);
        
        // Use global tracking function if available
        if (typeof window.trackServiceView === 'function') {
            window.trackServiceView(serviceId, serviceName, serviceImage, servicePrice);
        }
    }

    // Demo data initialization (remove in production)
    initializeDemoData() {
        this.promotionalServices = [
            {
                id: 'promo-1',
                name: 'Massage đá nóng thư giãn toàn thân',
                image: 'https://images.pexels.com/photos/3997989/pexels-photo-3997989.jpeg?auto=compress&cs=tinysrgb&w=400',
                category: 'Massage',
                rating: 4.8,
                duration: 90,
                originalPrice: 800000,
                discountPrice: 600000,
                discountPercent: 25,
                validUntil: '31/12/2024'
            },
            {
                id: 'promo-2',
                name: 'Chăm sóc da mặt collagen cao cấp',
                image: 'https://images.pexels.com/photos/3985263/pexels-photo-3985263.jpeg?auto=compress&cs=tinysrgb&w=400',
                category: 'Chăm sóc da',
                rating: 4.9,
                duration: 60,
                originalPrice: 1200000,
                discountPrice: 840000,
                discountPercent: 30,
                validUntil: '15/12/2024'
            },
            {
                id: 'promo-3',
                name: 'Tắm trắng thảo dược thiên nhiên',
                image: 'https://images.pexels.com/photos/3985254/pexels-photo-3985254.jpeg?auto=compress&cs=tinysrgb&w=400',
                category: 'Tắm trắng',
                rating: 4.7,
                duration: 45,
                originalPrice: 500000,
                discountPrice: 350000,
                discountPercent: 30,
                validUntil: '20/12/2024'
            },
            {
                id: 'promo-4',
                name: 'Gói chăm sóc toàn diện VIP',
                image: 'https://images.pexels.com/photos/3997991/pexels-photo-3997991.jpeg?auto=compress&cs=tinysrgb&w=400',
                category: 'Gói VIP',
                rating: 5.0,
                duration: 180,
                originalPrice: 2000000,
                discountPrice: 1400000,
                discountPercent: 30,
                validUntil: '31/12/2024'
            }
        ];

        this.mostPurchasedServices = [
            {
                id: 'popular-1',
                name: 'Massage thư giãn toàn thân cơ bản',
                image: 'https://images.pexels.com/photos/3997989/pexels-photo-3997989.jpeg?auto=compress&cs=tinysrgb&w=400',
                rating: 4.8,
                duration: 60,
                price: 500000,
                totalPurchases: 1250,
                popularityRank: 1,
                isBestSeller: true
            },
            {
                id: 'popular-2',
                name: 'Chăm sóc da mặt cơ bản',
                image: 'https://images.pexels.com/photos/3985263/pexels-photo-3985263.jpeg?auto=compress&cs=tinysrgb&w=400',
                rating: 4.7,
                duration: 45,
                price: 300000,
                totalPurchases: 980,
                popularityRank: 2,
                isBestSeller: true
            },
            {
                id: 'popular-3',
                name: 'Tắm trắng sữa ong chúa',
                image: 'https://images.pexels.com/photos/3985254/pexels-photo-3985254.jpeg?auto=compress&cs=tinysrgb&w=400',
                rating: 4.6,
                duration: 30,
                price: 250000,
                totalPurchases: 750,
                popularityRank: 3,
                isBestSeller: false
            },
            {
                id: 'popular-4',
                name: 'Liệu pháp làm đẹp toàn diện',
                image: 'https://images.pexels.com/photos/3997991/pexels-photo-3997991.jpeg?auto=compress&cs=tinysrgb&w=400',
                rating: 4.9,
                duration: 120,
                price: 900000,
                totalPurchases: 650,
                popularityRank: 4,
                isBestSeller: false
            }
        ];
    }

    // Public API methods
    updatePromotionalServices(services) {
        this.promotionalServices = services;
        this.renderPromotionalServices();
    }

    updateMostPurchasedServices(services) {
        this.mostPurchasedServices = services;
        this.renderMostPurchasedServices();
    }

    getPromotionalServices() {
        return [...this.promotionalServices];
    }

    getMostPurchasedServices() {
        return [...this.mostPurchasedServices];
    }
}

// Initialize when script loads
const promotionalServicesManager = new PromotionalServicesManager();

// Export for use in other scripts if needed
window.PromotionalServicesManager = PromotionalServicesManager;
window.promotionalServicesManagerInstance = promotionalServicesManager; 