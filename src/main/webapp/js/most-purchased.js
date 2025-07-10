/**
 * most-purchased.js
 * Manages the "Most Purchased Services" page with client-side filtering, searching, and pagination.
 */
class MostPurchasedPageManager {
    constructor() {
        this.allServices = [];
        this.filteredServices = [];
        this.serviceTypes = new Map();
        
        this.currentPage = 1;
        this.pageSize = 12;

        this.currentFilters = {
            searchQuery: '',
            serviceTypeId: 'all',
            minPrice: null,
            maxPrice: null,
            order: 'purchase-desc'
        };
        
        this.priceRange = { min: 100000, max: 15000000 };
        
        this.apiEndpoint = '/api/most-purchased';
        this.contextPath = document.querySelector('meta[name="context-path"]')?.getAttribute('content') || '';
        this.maxDisplay = 100;

        this.elements = {
            grid: document.getElementById('services-grid'),
            loadingIndicator: document.getElementById('loading-indicator'),
            noResults: document.getElementById('no-results'),
            contentWrapper: document.getElementById('content-wrapper'),
            resultsCount: document.getElementById('results-count'),
            searchInput: document.getElementById('search-input'),
            serviceTypeSelect: document.getElementById('service-type-select'),
            sortSelect: document.getElementById('sort-select'),
            clearFiltersBtn: document.getElementById('clear-filters'),
            pagination: document.getElementById('pagination')
        };
    }

    async init() {
        if (!this.elements.grid) {
            console.error('Required page elements are missing.');
            return;
        }
        await this.loadInitialData();
        this.setupEventListeners();
        lucide.createIcons();
    }

    /**
     * Helper method to get ServiceType from a service object
     * The Service model uses confusing naming: serviceTypeId field actually contains ServiceType object
     */
    getServiceType(service) {
        return service.serviceTypeId || service.serviceType;
    }

    /**
     * Normalize Vietnamese text for case-insensitive search
     * Converts accented characters to their base forms and handles case
     * Example: "Sữa" -> "sua", "Chăm sóc" -> "cham soc"
     */
    normalizeVietnameseText(text) {
        if (!text) return '';
        
        return text
            .toLowerCase()
            .normalize('NFD') // Decompose accented characters
            .replace(/[\u0300-\u036f]/g, '') // Remove diacritical marks
            .replace(/đ/g, 'd') // Replace đ with d
            .replace(/Đ/g, 'd') // Replace Đ with d
            .trim();
    }

    async loadInitialData() {
        this.showLoading();

        try {
            console.log('🌐 Fetching most purchased services from API...');
            const response = await fetch(`${this.contextPath}${this.apiEndpoint}?limit=${this.maxDisplay}`, {
                method: 'GET',
                headers: { 'Accept': 'application/json' }
            });

            if (!response.ok) throw new Error(`HTTP Error: ${response.status}`);
            
            const data = await response.json();
            this.allServices = data.services || [];
            console.log('📦 Received services from API:', this.allServices.length);
            
            if (this.allServices && this.allServices.length > 0) {
                this.extractServiceTypes();
                this.calculatePriceRange();
                this.initializePriceSlider();
                this.applyFiltersAndRender();
                this.hideLoading();
            } else {
                this.showNoResults();
            }
        } catch (error) {
            this.showError(`Không thể tải danh sách dịch vụ phổ biến.`);
            console.error('Failed to fetch most purchased services:', error);
        }
    }

    extractServiceTypes() {
        console.log('🔍 Extracting service types from', this.allServices.length, 'services');
        this.serviceTypes.clear();
        
        this.allServices.forEach(service => {
            const serviceType = this.getServiceType(service);
            
            if (serviceType && serviceType.serviceTypeId && serviceType.name) {
                if (!this.serviceTypes.has(serviceType.serviceTypeId)) {
                    this.serviceTypes.set(serviceType.serviceTypeId, serviceType.name);
                    console.log('✅ Added service type:', serviceType.serviceTypeId, '→', serviceType.name);
                }
            }
        });
        
        console.log('📊 Total unique service types found:', this.serviceTypes.size);
    }

    calculatePriceRange() {
        if (this.allServices.length === 0) return;
        
        const prices = this.allServices.map(service => service.price).filter(price => price > 0);
        if (prices.length > 0) {
            this.priceRange.min = Math.min(...prices);
            this.priceRange.max = Math.max(...prices);
        }
    }
    
    setupEventListeners() {
        this.elements.searchInput.addEventListener('input', () => this.handleSearch());
        this.elements.serviceTypeSelect.addEventListener('change', (e) => this.handleFilterChange('serviceTypeId', e.target.value));
        this.elements.sortSelect.addEventListener('change', (e) => this.handleFilterChange('order', e.target.value));
        this.elements.clearFiltersBtn.addEventListener('click', () => this.clearAllFilters());
    }

    initializePriceSlider() {
        const minSlider = document.getElementById('min-price-slider');
        const maxSlider = document.getElementById('max-price-slider');
        const minInput = document.getElementById('min-price-input');
        const maxInput = document.getElementById('max-price-input');
        const minDisplay = document.getElementById('min-price-display');
        const maxDisplay = document.getElementById('max-price-display');
        const sliderRange = document.getElementById('slider-range');
        const priceMinLimit = document.getElementById('price-min-limit');
        const priceMaxLimit = document.getElementById('price-max-limit');

        if (!minSlider || !maxSlider) return;

        const initialMin = this.priceRange.min;
        const initialMax = this.priceRange.max;
        
        minSlider.min = initialMin;
        minSlider.max = initialMax;
        minSlider.value = initialMin;
        
        maxSlider.min = initialMin;
        maxSlider.max = initialMax;
        maxSlider.value = initialMax;

        if (minInput) {
            minInput.value = initialMin;
            minInput.placeholder = initialMin.toString();
        }
        if (maxInput) {
            maxInput.value = initialMax;
            maxInput.placeholder = initialMax.toString();
        }

        this.updatePriceDisplay(initialMin, initialMax);
        this.updateSliderRange(initialMin, initialMax, initialMin, initialMax);
        
        if (priceMinLimit) priceMinLimit.textContent = this.formatPrice(initialMin);
        if (priceMaxLimit) priceMaxLimit.textContent = this.formatPrice(initialMax);

        const updatePriceRange = () => {
            let minVal = parseInt(minSlider.value);
            let maxVal = parseInt(maxSlider.value);

            if (minVal >= maxVal) {
                minVal = maxVal - 50000;
                minSlider.value = minVal;
            }

            if (minInput) minInput.value = minVal;
            if (maxInput) maxInput.value = maxVal;

            this.updatePriceDisplay(minVal, maxVal);
            this.updateSliderRange(minVal, maxVal, initialMin, initialMax);

            this.currentFilters.minPrice = minVal;
            this.currentFilters.maxPrice = maxVal;
            
            clearTimeout(this.priceFilterTimeout);
            this.priceFilterTimeout = setTimeout(() => {
                this.applyFiltersAndRender();
            }, 500);
        };

        minSlider.addEventListener('input', updatePriceRange);
        maxSlider.addEventListener('input', updatePriceRange);

        if (minInput) {
            minInput.addEventListener('blur', () => {
                const value = parseInt(minInput.value) || initialMin;
                minSlider.value = Math.max(initialMin, Math.min(value, parseInt(maxSlider.value) - 50000));
                updatePriceRange();
            });
        }

        if (maxInput) {
            maxInput.addEventListener('blur', () => {
                const value = parseInt(maxInput.value) || initialMax;
                maxSlider.value = Math.max(parseInt(minSlider.value) + 50000, Math.min(value, initialMax));
                updatePriceRange();
            });
        }
    }

    updatePriceDisplay(minVal, maxVal) {
        const minDisplay = document.getElementById('min-price-display');
        const maxDisplay = document.getElementById('max-price-display');
        
        if (minDisplay) minDisplay.textContent = this.formatPrice(minVal);
        if (maxDisplay) maxDisplay.textContent = this.formatPrice(maxVal);
    }

    updateSliderRange(minVal, maxVal, rangeMin, rangeMax) {
        const sliderRange = document.getElementById('slider-range');
        if (!sliderRange) return;

        const rangeWidth = rangeMax - rangeMin;
        const leftPercent = ((minVal - rangeMin) / rangeWidth) * 100;
        const rightPercent = ((maxVal - rangeMin) / rangeWidth) * 100;
        
        sliderRange.style.left = leftPercent + '%';
        sliderRange.style.width = (rightPercent - leftPercent) + '%';
    }

    formatPrice(price) {
        return new Intl.NumberFormat('vi-VN', {
            style: 'decimal',
            minimumFractionDigits: 0,
            maximumFractionDigits: 0
        }).format(price) + ' ₫';
    }

    handleSearch() {
        clearTimeout(this.searchTimeout);
        this.searchTimeout = setTimeout(() => {
            this.handleFilterChange('searchQuery', this.elements.searchInput.value);
        }, 300);
    }

    handleFilterChange(filterName, value) {
        this.currentFilters[filterName] = value;
        this.currentPage = 1;
        this.applyFiltersAndRender();
    }

    applyFiltersAndRender() {
        let services = [...this.allServices];

        // 1. Filter by Search Query
        const query = this.currentFilters.searchQuery.trim();
        if (query) {
            const normalizedQuery = this.normalizeVietnameseText(query);
            services = services.filter(s => {
                const normalizedName = this.normalizeVietnameseText(s.name);
                const normalizedDescription = this.normalizeVietnameseText(s.description || '');
                return normalizedName.includes(normalizedQuery) || normalizedDescription.includes(normalizedQuery);
            });
        }

        // 2. Filter by Service Type
        const typeId = this.currentFilters.serviceTypeId;
        if (typeId !== 'all') {
            services = services.filter(s => {
                const serviceType = this.getServiceType(s);
                return serviceType && serviceType.serviceTypeId == typeId;
            });
        }

        // 3. Filter by Price Range
        if (this.currentFilters.minPrice !== null) {
            services = services.filter(s => s.price >= this.currentFilters.minPrice);
        }
        if (this.currentFilters.maxPrice !== null) {
            services = services.filter(s => s.price <= this.currentFilters.maxPrice);
        }
        
        // 4. Sort
        const order = this.currentFilters.order;
        services.sort((a, b) => {
            switch (order) {
                case 'purchase-desc': 
                    // Primary sort by purchase count, secondary by rating
                    const aPurchases = a.purchaseCount || 0;
                    const bPurchases = b.purchaseCount || 0;
                    if (aPurchases !== bPurchases) {
                        return bPurchases - aPurchases;
                    }
                    return (b.averageRating || 0) - (a.averageRating || 0);
                case 'name-asc': return a.name.localeCompare(b.name);
                case 'name-desc': return b.name.localeCompare(a.name);
                case 'price-asc': return a.price - b.price;
                case 'price-desc': return b.price - a.price;
                case 'rating-desc': return (b.averageRating || 0) - (a.averageRating || 0);
                default: return (b.purchaseCount || 0) - (a.purchaseCount || 0);
            }
        });
        
        this.filteredServices = services;
        this.renderPage();
    }
    
    renderPage() {
        const total = this.filteredServices.length;
        this.elements.resultsCount.textContent = `Hiển thị ${total} kết quả`;

        if (total === 0) {
            this.elements.grid.innerHTML = '<p class="col-span-full text-center text-gray-500">Không tìm thấy dịch vụ nào khớp với bộ lọc của bạn.</p>';
            this.elements.pagination.innerHTML = '';
            return;
        }
        
        const start = (this.currentPage - 1) * this.pageSize;
        const end = start + this.pageSize;
        const paginatedServices = this.filteredServices.slice(start, end);
        
        this.elements.grid.innerHTML = paginatedServices.map(service => this.createServiceCard(service)).join('');
        this.renderPagination();
        lucide.createIcons();
    }
    
    renderPagination() {
        const totalPages = Math.ceil(this.filteredServices.length / this.pageSize);
        this.elements.pagination.innerHTML = '';
        if (totalPages <= 1) return;

        let paginationHTML = '';
        const hasPrevious = this.currentPage > 1;
        const hasNext = this.currentPage < totalPages;

        // Previous button
        if (hasPrevious) {
            paginationHTML += `
                <button onclick="window.mostPurchasedManager.goToPage(${this.currentPage - 1})" 
                        class="px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-l-md hover:bg-gray-50 transition-colors">
                    Trước
                </button>
            `;
        }

        // Page numbers with smart ellipsis
        const startPage = Math.max(1, this.currentPage - 2);
        const endPage = Math.min(totalPages, this.currentPage + 2);

        // First page (if not in range)
        if (startPage > 1) {
            paginationHTML += `
                <button onclick="window.mostPurchasedManager.goToPage(1)" 
                        class="px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 hover:bg-gray-50 transition-colors">
                    1
                </button>
            `;
            if (startPage > 2) {
                paginationHTML += `<span class="px-3 py-2 text-sm text-gray-500 border border-gray-300 bg-white">...</span>`;
            }
        }

        // Page numbers
        for (let i = startPage; i <= endPage; i++) {
            const isActive = i === this.currentPage;
            paginationHTML += `
                <button onclick="window.mostPurchasedManager.goToPage(${i})" 
                        class="px-3 py-2 text-sm font-medium ${isActive 
                            ? 'text-white bg-primary border-primary' 
                            : 'text-gray-700 bg-white border-gray-300 hover:bg-gray-50'} 
                        border transition-colors">
                    ${i}
                </button>
            `;
        }

        // Last page (if not in range)
        if (endPage < totalPages) {
            if (endPage < totalPages - 1) {
                paginationHTML += `<span class="px-3 py-2 text-sm text-gray-500 border border-gray-300 bg-white">...</span>`;
            }
            paginationHTML += `
                <button onclick="window.mostPurchasedManager.goToPage(${totalPages})" 
                        class="px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 hover:bg-gray-50 transition-colors">
                    ${totalPages}
                </button>
            `;
        }

        // Next button
        if (hasNext) {
            paginationHTML += `
                <button onclick="window.mostPurchasedManager.goToPage(${this.currentPage + 1})" 
                        class="px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-r-md hover:bg-gray-50 transition-colors">
                    Sau
                </button>
            `;
        }

        this.elements.pagination.innerHTML = `<div class="inline-flex -space-x-px">${paginationHTML}</div>`;
    }

    goToPage(page) {
        if (page >= 1 && page <= Math.ceil(this.filteredServices.length / this.pageSize)) {
            this.currentPage = page;
            this.renderPage();
            // Scroll to top of services grid
            document.getElementById('services-grid').scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    }

    createServiceCard(service) {
        const imageUrl = this.getServiceImageUrl(service);
        const serviceType = this.getServiceType(service);
        const escapedService = JSON.stringify(service).replace(/"/g, "&quot;");
        
        // Format price with proper thousand separators
        const formattedPrice = new Intl.NumberFormat('vi-VN', {
            style: 'decimal',
            minimumFractionDigits: 0,
            maximumFractionDigits: 0
        }).format(service.price) + ' ₫';
        
        // Get service type name for badge
        const serviceTypeName = serviceType ? serviceType.name : 'Dịch vụ';
        
        // Format duration
        const duration = service.durationMinutes || 60;
        const durationText = duration >= 60 ? `${Math.floor(duration / 60)} giờ${duration % 60 ? ` ${duration % 60} phút` : ''}` : `${duration} phút`;
        
        // Truncate description to fit layout
        const description = service.description || '';
        const truncatedDescription = description.length > 60 ? description.substring(0, 60) + '...' : description;

        // Show purchase count if available
        const purchaseCount = service.purchaseCount || 0;
        const purchaseText = purchaseCount > 0 ? `${purchaseCount} lượt đặt` : 'Mới';
        
        return `
            <div class="service-card bg-white rounded-lg shadow-lg overflow-hidden flex flex-col">
                <div class="relative h-48">
                    <a href="${this.contextPath}/service-details?id=${service.serviceId}" class="block">
                        <img src="${imageUrl}" alt="${service.name}" class="w-full h-48 object-cover">
                    </a>
                    <div class="absolute top-2 right-2">
                        <span class="bg-red-500 text-white text-xs px-2 py-1 rounded-full font-medium">${purchaseText}</span>
                    </div>
                </div>
                <div class="p-5">
                    <div class="mb-2">
                        <span class="text-xs text-primary font-medium bg-secondary px-2 py-1 rounded-full">${serviceTypeName}</span>
                    </div>
                    <h3 class="text-lg font-semibold text-spa-dark mb-2 truncate">${service.name}</h3>
                    <p class="text-gray-600 text-sm mb-4 h-12 overflow-hidden">${truncatedDescription}</p>
                    <div class="flex items-center justify-between mb-4">
                        <div class="flex items-center text-gray-500">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4 mr-1">
                                <path d="M12 6v6l4 2"></path>
                                <circle cx="12" cy="12" r="10"></circle>
                            </svg>
                            <span class="text-sm">${durationText}</span>
                        </div>
                        <div class="text-xl font-bold text-primary">${formattedPrice}</div>
                    </div>
                    <div class="grid grid-cols-2 gap-2">
                        <button class="view-details-btn w-full bg-secondary text-spa-dark py-2.5 px-3 rounded-full hover:bg-primary hover:text-white transition-all duration-300 font-medium text-sm flex items-center justify-center"
                                onclick="window.location.href='${this.contextPath}/service-details?id=${service.serviceId}'">
                            Xem chi tiết
                        </button>
                        <button class="add-to-cart-btn w-full bg-primary text-white py-2.5 px-3 rounded-full hover:bg-primary-dark transition-all duration-300 font-medium text-sm flex items-center justify-center"
                                onclick='window.cartManager.addToCart(${escapedService})'>
                            Thêm vào giỏ
                        </button>
                    </div>
                </div>
            </div>`;
    }

    getServiceImageUrl(service) {
        // Use the service's imageUrl from database if available
        if (service.imageUrl && service.imageUrl.trim() !== '' && service.imageUrl !== '/services/default.jpg') {
            const imageUrl = service.imageUrl.startsWith('/') ? `${this.contextPath}${service.imageUrl}` : service.imageUrl;
            return imageUrl;
        }
        
        // Fallback to placehold.co placeholder with service name
        const serviceName = encodeURIComponent(service.name || 'Service');
        const placeholderUrl = `https://placehold.co/300x200/FFB6C1/333333?text=${serviceName}`;
        return placeholderUrl;
    }
    
    clearAllFilters() {
        this.currentFilters = { searchQuery: '', serviceTypeId: 'all', minPrice: null, maxPrice: null, order: 'purchase-desc' };
        this.elements.searchInput.value = '';
        this.elements.serviceTypeSelect.value = 'all';
        this.elements.sortSelect.value = 'purchase-desc';
        this.resetPriceSlider();
        this.currentPage = 1;
        this.applyFiltersAndRender();
    }

    resetPriceSlider() {
        const minSlider = document.getElementById('min-price-slider');
        const maxSlider = document.getElementById('max-price-slider');
        const minInput = document.getElementById('min-price-input');
        const maxInput = document.getElementById('max-price-input');

        const initialMin = this.priceRange.min;
        const initialMax = this.priceRange.max;

        if (minSlider) minSlider.value = initialMin;
        if (maxSlider) maxSlider.value = initialMax;
        if (minInput) minInput.value = initialMin;
        if (maxInput) maxInput.value = initialMax;

        this.updatePriceDisplay(initialMin, initialMax);
        this.updateSliderRange(initialMin, initialMax, initialMin, initialMax);
        
        const priceMinLimit = document.getElementById('price-min-limit');
        const priceMaxLimit = document.getElementById('price-max-limit');
        if (priceMinLimit) priceMinLimit.textContent = this.formatPrice(initialMin);
        if (priceMaxLimit) priceMaxLimit.textContent = this.formatPrice(initialMax);
    }

    showLoading() {
        this.elements.loadingIndicator.style.display = 'block';
        this.elements.contentWrapper.classList.add('hidden');
    }

    hideLoading() {
        this.elements.loadingIndicator.style.display = 'none';
        this.elements.contentWrapper.classList.remove('hidden');
    }

    showNoResults() {
        this.elements.loadingIndicator.style.display = 'none';
        this.elements.noResults.style.display = 'block';
        this.elements.contentWrapper.classList.add('hidden');
    }
    
    showError(message) {
        this.hideLoading();
        this.elements.noResults.innerHTML = `<p class="text-red-500">${message}</p>`;
        this.elements.noResults.style.display = 'block';
    }
}

document.addEventListener('DOMContentLoaded', () => {
    if (document.getElementById('services-grid')) {
        window.mostPurchasedManager = new MostPurchasedPageManager();
        window.mostPurchasedManager.init();
    }
}); 