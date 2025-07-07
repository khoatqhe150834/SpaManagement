/**
 * Homepage Sections Manager
 * Manages all three homepage sections: Recently Viewed, Promotional, and Most Purchased Services
 */
class HomepageSectionsManager {
    constructor() {
        this.apiUrl = '/api/homepage';
        this.contextPath = this.getContextPath();
        this.recentlyViewedKey = 'spa_recently_viewed_services';
        this.maxRecentlyViewed = 8;
        this.isInitialized = false;
        
        // Beauty images array for fallbacks
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
    }

    /**
     * Initialize all homepage sections
     */
    async init() {
        if (this.isInitialized) return;
        
        console.log('🏠 Initializing Homepage Sections Manager...');
        
        try {
            // Initialize demo data for development/testing
            this.initDemoData();
            
            // Load all sections data
            await this.loadAllSections();
            
            // Track service views when visiting service details pages
            this.initServiceTracking();
            
            this.isInitialized = true;
            console.log('✅ Homepage Sections Manager initialized successfully');
        } catch (error) {
            console.error('❌ Failed to initialize Homepage Sections Manager:', error);
        }
    }

    /**
     * Initialize demo data for development/testing
     */
    initDemoData() {
        // Add some demo service IDs to recently viewed for testing
        const demoServiceIds = [1, 2, 3];
        if (this.getRecentlyViewedIds().length === 0) {
            try {
                localStorage.setItem(this.recentlyViewedKey, JSON.stringify(demoServiceIds));
                console.log('📝 Demo recently viewed data initialized');
            } catch (error) {
                console.warn('Could not initialize demo data:', error);
            }
        }
    }

    /**
     * Get context path for URL construction
     */
    getContextPath() {
        const metaContextPath = document.querySelector('meta[name="context-path"]');
        if (metaContextPath) {
            return metaContextPath.getAttribute('content');
        }
        
        const pathArray = window.location.pathname.split('/');
        return pathArray.length > 1 ? '/' + pathArray[1] : '';
    }

    /**
     * Load all sections data
     */
    async loadAllSections() {
        try {
            const recentlyViewedIds = this.getRecentlyViewedIds();
            const params = new URLSearchParams({
                action: 'all-sections',
                limit: '8'
            });
            
            if (recentlyViewedIds.length > 0) {
                params.append('recentlyViewedIds', recentlyViewedIds.join(','));
            }

            const response = await fetch(`${this.contextPath}${this.apiUrl}?${params}`);
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const data = await response.json();
            
            if (data.success) {
                // Render each section
                this.renderRecentlyViewed(data.sections.recentlyViewed);
                this.renderPromotionalServices(data.sections.promotional);
                this.renderMostPurchasedServices(data.sections.mostPurchased);
            } else {
                console.error('API returned error:', data.error);
            }
        } catch (error) {
            console.error('Error loading homepage sections:', error);
            this.showErrorMessage('Không thể tải dữ liệu. Vui lòng thử lại sau.');
        }
    }

    /**
     * Render Recently Viewed Services section
     */
    renderRecentlyViewed(services) {
        const section = document.getElementById('recently-viewed-section');
        const grid = document.getElementById('recently-viewed-grid');
        
        if (!section || !grid) return;

        if (services.length === 0) {
            section.style.display = 'none';
            return;
        }

        grid.innerHTML = '';
        
        services.forEach((service, index) => {
            const serviceCard = this.createServiceCard(service, 'recently-viewed', index);
            grid.appendChild(serviceCard);
        });

        // Show section with animation
        section.style.display = 'block';
        this.animateSection(section);
        
        // Initialize icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
    }

    /**
     * Render Promotional Services section
     */
    renderPromotionalServices(services) {
        const grid = document.getElementById('promotional-grid');
        if (!grid) return;

        grid.innerHTML = '';
        
        if (services.length === 0) {
            grid.innerHTML = `
                <div class="col-span-full text-center py-12">
                    <p class="text-gray-500 text-lg">Hiện tại chưa có chương trình khuyến mãi nào.</p>
                </div>
            `;
            return;
        }

        services.forEach((service, index) => {
            const serviceCard = this.createServiceCard(service, 'promotional', index);
            grid.appendChild(serviceCard);
        });

        // Animate cards
        this.animateCards(grid);
        
        // Initialize icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
    }

    /**
     * Render Most Purchased Services section
     */
    renderMostPurchasedServices(services) {
        const grid = document.getElementById('most-purchased-grid');
        if (!grid) return;

        grid.innerHTML = '';
        
        if (services.length === 0) {
            grid.innerHTML = `
                <div class="col-span-full text-center py-12">
                    <p class="text-gray-500 text-lg">Chưa có dữ liệu dịch vụ phổ biến.</p>
                </div>
            `;
            return;
        }

        services.forEach((service, index) => {
            const serviceCard = this.createServiceCard(service, 'most-purchased', index);
            grid.appendChild(serviceCard);
        });

        // Animate cards
        this.animateCards(grid);
        
        // Initialize icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
    }

    /**
     * Create service card element
     */
    createServiceCard(service, section, index) {
        const card = document.createElement('div');
        card.className = 'bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1';
        card.style.animationDelay = `${index * 100}ms`;
        
        const rating = service.averageRating || 0;
        
        // Get image with fallback
        const imageUrl = service.imageUrl || this.getServiceImage(service.serviceId);
        
        // Create promotional badge for promotional section
        let promotionalBadge = '';
        if (section === 'promotional') {
            promotionalBadge = `
                <div class="bg-red-600 text-white text-xs font-bold px-3 py-1 absolute z-10 rounded-br-lg">
                    KHUYẾN MÃI
                </div>
            `;
        }
        
        // Create ranking badge for most purchased section
        let rankingBadge = '';
        if (section === 'most-purchased') {
            const rank = index + 1;
            let badgeColor = 'bg-gray-500';
            if (rank === 1) badgeColor = 'bg-yellow-500';
            else if (rank === 2) badgeColor = 'bg-gray-400';
            else if (rank === 3) badgeColor = 'bg-yellow-600';
            
            rankingBadge = `
                <div class="${badgeColor} text-white text-xs font-bold px-2 py-1 absolute z-10 rounded-full top-3 left-3 flex items-center">
                    <i data-lucide="trophy" class="h-3 w-3 mr-1"></i>
                    <span>#${rank}</span>
                </div>
            `;
            
            // Add purchase count badge only if count > 0
            if (service.purchaseCount > 0) {
                 rankingBadge += `
                    <div class="bg-blue-500 text-white text-xs font-semibold px-2 py-1 absolute z-10 rounded-full top-3 right-3 flex items-center">
                        <i data-lucide="user-check" class="h-3 w-3 mr-1"></i>
                        <span>${service.purchaseCount} lượt đặt</span>
                    </div>
                `;
            }
        }
        
        card.innerHTML = `
            ${promotionalBadge}${rankingBadge}
            <div class="relative">
                <img 
                    src="${imageUrl}" 
                    alt="${service.name}" 
                    class="w-full h-48 object-cover" 
                    onerror="this.src='${this.beautyImages[0]}'"
                />
                <div class="absolute top-3 right-3 bg-white/90 px-2 py-1 rounded-full">
                    <div class="flex items-center">
                        <i data-lucide="star" class="h-3 w-3 text-primary fill-current mr-1"></i>
                        <span class="text-xs font-medium">${rating.toFixed(1)}</span>
                    </div>
                </div>
            </div>
            <div class="p-5">
                <div class="mb-2">
                    <span class="text-xs text-primary font-medium bg-secondary px-2 py-1 rounded-full">
                        ${service.serviceType ? service.serviceType.name : 'Dịch vụ'}
                    </span>
                </div>
                <h3 class="text-lg font-semibold text-spa-dark mb-2 line-clamp-2">${service.name}</h3>
                <p class="text-gray-600 text-sm mb-4 h-12 overflow-hidden line-clamp-2">${service.description || ''}</p>
                <div class="flex items-center justify-between mb-4">
                    <div class="flex items-center text-gray-500">
                        <i data-lucide="clock" class="h-4 w-4 mr-1"></i>
                        <span class="text-sm">${service.durationMinutes} phút</span>
                    </div>
                    <div class="text-xl font-bold text-primary">${service.formattedPrice}</div>
                </div>
                <div class="grid grid-cols-2 gap-2">
                    <button class="view-details-btn w-full bg-secondary text-spa-dark py-2.5 px-3 rounded-full hover:bg-primary hover:text-white transition-all duration-300 font-medium text-sm flex items-center justify-center" 
                            onclick="homepageSections.viewServiceDetails(${service.serviceId})">
                        Xem chi tiết
                    </button>
                    <button class="add-to-cart-btn w-full bg-primary text-white py-2.5 px-3 rounded-full hover:bg-primary-dark transition-all duration-300 font-medium text-sm flex items-center justify-center" 
                            onclick="homepageSections.addToCart(${JSON.stringify(service).replace(/"/g, '&quot;')})">
                        Thêm vào giỏ
                    </button>
                </div>
            </div>
        `;

        return card;
    }

    /**
     * Get service image with fallback
     */
    getServiceImage(serviceId) {
        const imageIndex = Math.abs(serviceId * 7) % this.beautyImages.length;
        return this.beautyImages[imageIndex];
    }

    /**
     * Initialize service tracking for other pages
     */
    initServiceTracking() {
        // Expose global function for service tracking
        window.trackServiceView = (serviceId) => {
            this.trackServiceView(serviceId);
        };
    }

    /**
     * Track service view
     */
    trackServiceView(serviceId) {
        if (!serviceId) return;

        try {
            const numericServiceId = parseInt(serviceId, 10);
            if (isNaN(numericServiceId)) {
                console.warn('Invalid service ID provided for tracking:', serviceId);
                return;
            }

            let viewedServices = this.getRecentlyViewedIds();
            
            // Optimization: if the service is already the first item, no change is needed.
            if (viewedServices.length > 0 && viewedServices[0] === numericServiceId) {
                return;
            }

            // Remove if already exists (compare as numbers)
            viewedServices = viewedServices.filter(id => id !== numericServiceId);

            // Add to beginning
            viewedServices.unshift(numericServiceId);

            // Limit to max items
            if (viewedServices.length > this.maxRecentlyViewed) {
                viewedServices = viewedServices.slice(0, this.maxRecentlyViewed);
            }

            // Save to localStorage
            localStorage.setItem(this.recentlyViewedKey, JSON.stringify(viewedServices));

            console.log('🔍 Service tracked, refreshing recently viewed section:', numericServiceId);

            // Asynchronously refresh just the recently viewed section to update the UI instantly.
            this.refreshRecentlyViewedSection();
            
        } catch (error) {
            console.error('Error tracking service view:', error);
        }
    }

    /**
     * Get recently viewed service IDs from localStorage
     */
    getRecentlyViewedIds() {
        try {
            const stored = localStorage.getItem(this.recentlyViewedKey);
            const viewed = stored ? JSON.parse(stored) : [];
            // Sanitize to ensure all IDs are numbers
            return viewed.map(id => parseInt(id, 10)).filter(id => !isNaN(id));
        } catch (error) {
            console.error('Error getting recently viewed services:', error);
            return [];
        }
    }

    /**
     * View service details
     */
    viewServiceDetails(serviceId) {
        // Track the view
        this.trackServiceView(serviceId);
        
        // Navigate to service details (implement based on your routing)
        window.location.href = `${this.contextPath}/service-details?id=${serviceId}`;
    }

    /**
     * Add service to cart
     */
    addToCart(service) {
        // Track the service view when adding to cart
        this.trackServiceView(service.serviceId);
        
        const serviceData = {
            serviceId: service.serviceId,
            serviceName: service.name,
            serviceImage: service.imageUrl || this.getServiceImage(service.serviceId),
            servicePrice: service.price,
            serviceDuration: service.durationMinutes
        };

        // Integration with existing cart functionality
        if (typeof addToCart === 'function') {
            addToCart(serviceData);
        } else if (typeof window.cartManager !== 'undefined' && window.cartManager.addToCart) {
            window.cartManager.addToCart(serviceData);
        } else {
            // Fallback: redirect to booking with service selected
            window.location.href = `${this.contextPath}/booking?serviceId=${service.serviceId}`;
        }
    }

    /**
     * Animate section entrance
     */
    animateSection(section) {
        section.style.opacity = '0';
        section.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            section.style.transition = 'opacity 0.6s ease-out, transform 0.6s ease-out';
            section.style.opacity = '1';
            section.style.transform = 'translateY(0)';
        }, 100);
    }

    /**
     * Animate cards with staggered delay
     */
    animateCards(grid) {
        const cards = grid.querySelectorAll('.bg-white');
        cards.forEach((card, index) => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                card.style.transition = 'opacity 0.6s ease-out, transform 0.6s ease-out';
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, index * 100);
        });
    }

    /**
     * Show error message
     */
    showErrorMessage(message) {
        console.error('Homepage Sections Error:', message);
        // You can implement a toast notification here if available
    }

    /**
     * Refreshes just the "Recently Viewed" section for a faster, more targeted UI update.
     */
    async refreshRecentlyViewedSection() {
        console.log('🔄 Refreshing just the recently viewed section...');
        try {
            const recentlyViewedIds = this.getRecentlyViewedIds();

            if (recentlyViewedIds.length === 0) {
                this.renderRecentlyViewed([]);
                return;
            }
            
            // We reuse the 'all-sections' action as it correctly returns data based on IDs.
            // This is more efficient on the frontend as we only re-render one component.
            const params = new URLSearchParams({
                action: 'all-sections',
                limit: '8' // Keep consistent with initial load
            });
            params.append('recentlyViewedIds', recentlyViewedIds.join(','));

            const response = await fetch(`${this.contextPath}${this.apiUrl}?${params}`);

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const data = await response.json();

            if (data.success && data.sections && data.sections.recentlyViewed) {
                this.renderRecentlyViewed(data.sections.recentlyViewed);
            } else {
                console.warn('Could not refresh recently viewed section via API.');
            }
        } catch (error) {
            console.error('Error refreshing recently viewed section:', error);
        }
    }

    /**
     * Refresh all sections
     */
    async refresh() {
        console.log('🔄 Refreshing homepage sections...');
        await this.loadAllSections();
    }
}

// Initialize on DOM content loaded
let homepageSections;
document.addEventListener('DOMContentLoaded', () => {
    homepageSections = new HomepageSectionsManager();
    homepageSections.init();
});

// Add enhanced CSS for animations and styling
const homepageCSS = `
/* Line clamp utility */
.line-clamp-2 {
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

/* Service card animations */
.service-card-entrance {
    animation: serviceCardEntrance 0.6s ease-out forwards;
}

@keyframes serviceCardEntrance {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Promotional section gradient */
.bg-gradient-to-br {
    background: linear-gradient(to bottom right, var(--tw-gradient-stops));
}

.from-red-50 {
    --tw-gradient-from: #fef2f2;
    --tw-gradient-stops: var(--tw-gradient-from), var(--tw-gradient-to, rgba(254, 242, 242, 0));
}

.to-pink-50 {
    --tw-gradient-to: #fdf2f8;
}

/* Enhanced button styles */
.btn-promotional {
    background: linear-gradient(135deg, #dc2626 0%, #991b1b 100%);
    transition: all 0.3s ease;
}

.btn-promotional:hover {
    background: linear-gradient(135deg, #991b1b 0%, #7f1d1d 100%);
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(220, 38, 38, 0.3);
}

/* Badge styles */
.badge-promotional {
    background: linear-gradient(135deg, #dc2626 0%, #991b1b 100%);
    animation: pulse 2s infinite;
}

.badge-ranking {
    font-weight: 700;
    text-shadow: 1px 1px 2px rgba(0,0,0,0.3);
}

.badge-bestseller {
    background: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
    animation: glow 2s ease-in-out infinite alternate;
}

@keyframes glow {
    from {
        box-shadow: 0 0 5px rgba(249, 115, 22, 0.5);
    }
    to {
        box-shadow: 0 0 20px rgba(249, 115, 22, 0.8);
    }
}

/* Responsive improvements */
@media (max-width: 768px) {
    .grid-cols-1.md\\:grid-cols-2.lg\\:grid-cols-4 {
        grid-template-columns: repeat(1, minmax(0, 1fr));
    }
}

@media (min-width: 768px) {
    .grid-cols-1.md\\:grid-cols-2.lg\\:grid-cols-4 {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }
}

@media (min-width: 1024px) {
    .grid-cols-1.md\\:grid-cols-2.lg\\:grid-cols-4 {
        grid-template-columns: repeat(4, minmax(0, 1fr));
    }
}
`;

// Add CSS to head
const homepageStyle = document.createElement('style');
homepageStyle.textContent = homepageCSS;
document.head.appendChild(homepageStyle); 