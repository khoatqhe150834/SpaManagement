/**
 * recently-viewed.js
 * Manages the dedicated "Recently Viewed" page by fetching and rendering services from localStorage.
 */
class RecentlyViewedPage {
    constructor() {
        this.grid = document.getElementById('recently-viewed-full-grid');
        this.loadingIndicator = document.getElementById('loading-indicator');
        this.noResults = document.getElementById('no-results');
        this.storageKey = 'spa_recently_viewed_services';
        this.apiEndpoint = '/api/services/by-ids';
        this.contextPath = this.getContextPath();
        this.maxDisplay = 100;

        this.beautyImages = [
            'https://images.pexels.com/photos/3985254/pexels-photo-3985254.jpeg?auto=compress&cs=tinysrgb&w=400',
            'https://images.pexels.com/photos/3997991/pexels-photo-3997991.jpeg?auto=compress&cs=tinysrgb&w=400',
            'https://images.pexels.com/photos/3985263/pexels-photo-3985263.jpeg?auto=compress&cs=tinysrgb&w=400',
            'https://images.pexels.com/photos/3997989/pexels-photo-3997989.jpeg?auto=compress&cs=tinysrgb&w=400',
            'https://images.pexels.com/photos/3985330/pexels-photo-3985330.jpeg?auto=compress&cs=tinysrgb&w=400'
        ];
    }

    init() {
        if (!this.grid || !this.loadingIndicator || !this.noResults) {
            console.error('Required elements for the recently viewed page are missing.');
            return;
        }
        this.loadServices();
        lucide.createIcons();
    }

    getContextPath() {
        return document.querySelector('meta[name="context-path"]')?.getAttribute('content') || '';
    }

    getRecentlyViewedIds() {
        try {
            const stored = localStorage.getItem(this.storageKey);
            const viewed = stored ? JSON.parse(stored) : [];
            return viewed.map(id => parseInt(id, 10)).filter(id => !isNaN(id));
        } catch (error) {
            console.error('Error reading recently viewed IDs from localStorage', error);
            return [];
        }
    }

    async loadServices() {
        this.showLoading();
        const serviceIds = this.getRecentlyViewedIds().slice(0, this.maxDisplay);

        if (serviceIds.length === 0) {
            this.showNoResults();
            return;
        }

        try {
            const response = await fetch(`${this.contextPath}${this.apiEndpoint}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(serviceIds)
            });

            if (!response.ok) throw new Error(`HTTP Error: ${response.status}`);
            
            const services = await response.json();
            
            if (services && services.length > 0) {
                this.renderServices(services);
                this.hideLoading();
            } else {
                this.showNoResults();
            }

        } catch (error) {
            this.showError(`Không thể tải các dịch vụ đã xem. Vui lòng thử lại.`);
            console.error('Failed to fetch recently viewed services:', error);
        }
    }

    renderServices(services) {
        this.grid.innerHTML = services.map(service => this.createServiceCard(service)).join('');
        lucide.createIcons();
    }

    createServiceCard(service) {
        const imageUrl = service.imageUrl || this.getServiceImage(service.serviceId);
        const rating = service.averageRating || 0;
        
        // Escape the service object for inline onclick handler
        const escapedService = JSON.stringify(service).replace(/"/g, "&quot;");
        
        return `
            <div class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1 flex flex-col">
                <div class="relative">
                    <a href="${this.contextPath}/service-details?id=${service.serviceId}" class="block">
                        <img src="${imageUrl}" alt="${service.name}" class="w-full h-48 object-cover" onerror="this.src='${this.beautyImages[0]}'">
                    </a>
                    <div class="absolute top-3 right-3 bg-white/90 px-2 py-1 rounded-full">
                        <div class="flex items-center">
                            <i data-lucide="star" class="h-3 w-3 text-primary fill-current mr-1"></i>
                            <span class="text-xs font-medium">${rating.toFixed(1)}</span>
                        </div>
                    </div>
                </div>
                <div class="p-5 flex-grow flex flex-col">
                    <div class="mb-2">
                        <span class="text-xs text-primary font-medium bg-secondary px-2 py-1 rounded-full">
                            ${service.serviceType ? service.serviceType.name : 'Dịch vụ'}
                        </span>
                    </div>
                    <h3 class="text-lg font-semibold text-spa-dark mb-2 line-clamp-2 flex-grow">${service.name}</h3>
                    <div class="flex items-center justify-between my-4">
                        <div class="flex items-center text-gray-500">
                            <i data-lucide="clock" class="h-4 w-4 mr-1"></i>
                            <span class="text-sm">${service.durationMinutes} phút</span>
                        </div>
                        <div class="text-xl font-bold text-primary">${service.formattedPrice}</div>
                    </div>
                    <div class="mt-auto">
                        <button class="w-full bg-primary text-white py-2.5 px-3 rounded-full hover:bg-primary-dark transition-all duration-300 font-medium text-sm flex items-center justify-center" 
                                onclick='window.cartManager.addToCart(${escapedService})'>
                            <i data-lucide="shopping-cart" class="h-4 w-4 mr-2"></i>
                            Thêm vào giỏ
                        </button>
                    </div>
                </div>
            </div>
        `;
    }

    getServiceImage(serviceId) {
        const imageIndex = Math.abs(serviceId * 7) % this.beautyImages.length;
        return this.beautyImages[imageIndex];
    }
    
    showLoading() {
        this.loadingIndicator.style.display = 'block';
        this.grid.style.display = 'none';
        this.noResults.style.display = 'none';
    }

    hideLoading() {
        this.loadingIndicator.style.display = 'none';
        this.grid.style.display = 'grid';
    }

    showNoResults() {
        this.loadingIndicator.style.display = 'none';
        this.grid.style.display = 'none';
        this.noResults.style.display = 'block';
    }
    
    showError(message) {
        this.hideLoading();
        this.grid.style.display = 'none';
        const noResults = document.getElementById('no-results');
        if (noResults) {
            noResults.style.display = 'block';
            noResults.innerHTML = `<p class="text-red-500">${message}</p>`;
        }
    }
}

document.addEventListener('DOMContentLoaded', () => {
    if (document.getElementById('recently-viewed-full-grid')) {
        const recentlyViewedPage = new RecentlyViewedPage();
        recentlyViewedPage.init();
    }
}); 