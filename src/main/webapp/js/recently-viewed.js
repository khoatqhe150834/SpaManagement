/**
 * recently-viewed.js
 * Manages the dedicated "Recently Viewed" page with client-side filtering, searching, and pagination.
 */
class RecentlyViewedPageManager {
    constructor() {
        this.allServices = [];
        this.filteredServices = [];
        this.serviceTypes = new Map();
        
        this.currentPage = 1;
        this.pageSize = 12;

        this.currentFilters = {
            searchQuery: '',
            serviceTypeId: 'all',
            order: 'default'
        };
        
        this.storageKey = 'spa_recently_viewed_services';
        this.apiEndpoint = '/api/services/by-ids';
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
        
        this.beautyImages = [
            'https://images.pexels.com/photos/3985254/pexels-photo-3985254.jpeg?auto=compress&cs=tinysrgb&w=400',
            'https://images.pexels.com/photos/3997991/pexels-photo-3997991.jpeg?auto=compress&cs=tinysrgb&w=400'
        ];
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

    getRecentlyViewedIds() {
        try {
            const stored = localStorage.getItem(this.storageKey) || '[]';
            const viewed = JSON.parse(stored);
            return viewed.map(id => parseInt(id, 10)).filter(id => !isNaN(id));
        } catch (error) {
            console.error('Error reading recently viewed IDs from localStorage', error);
            return [];
        }
    }

    async loadInitialData() {
        this.showLoading();
        const serviceIds = this.getRecentlyViewedIds().slice(0, this.maxDisplay);

        if (serviceIds.length === 0) {
            this.showNoResults();
            return;
        }

        try {
            const response = await fetch(`${this.contextPath}${this.apiEndpoint}`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                body: JSON.stringify(serviceIds)
            });

            if (!response.ok) throw new Error(`HTTP Error: ${response.status}`);
            
            this.allServices = await response.json();
            
            if (this.allServices && this.allServices.length > 0) {
                this.extractServiceTypes();
                this.populateFilterOptions();
                this.applyFiltersAndRender();
                this.hideLoading();
            } else {
                this.showNoResults();
            }
        } catch (error) {
            this.showError(`Không thể tải các dịch vụ đã xem.`);
            console.error('Failed to fetch recently viewed services:', error);
        }
    }

    extractServiceTypes() {
        this.allServices.forEach(service => {
            if (service.serviceType && !this.serviceTypes.has(service.serviceType.serviceTypeId)) {
                this.serviceTypes.set(service.serviceType.serviceTypeId, service.serviceType.name);
            }
        });
    }

    populateFilterOptions() {
        const select = this.elements.serviceTypeSelect;
        this.serviceTypes.forEach((name, id) => {
            const option = new Option(name, id);
            select.add(option);
        });
    }
    
    setupEventListeners() {
        this.elements.searchInput.addEventListener('input', () => this.handleSearch());
        this.elements.serviceTypeSelect.addEventListener('change', (e) => this.handleFilterChange('serviceTypeId', e.target.value));
        this.elements.sortSelect.addEventListener('change', (e) => this.handleFilterChange('order', e.target.value));
        this.elements.clearFiltersBtn.addEventListener('click', () => this.clearAllFilters());
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
        const query = this.currentFilters.searchQuery.toLowerCase().trim();
        if (query) {
            services = services.filter(s => s.name.toLowerCase().includes(query) || (s.description && s.description.toLowerCase().includes(query)));
        }

        // 2. Filter by Service Type
        const typeId = this.currentFilters.serviceTypeId;
        if (typeId !== 'all') {
            services = services.filter(s => s.serviceType && s.serviceType.serviceTypeId == typeId);
        }
        
        // 3. Sort
        const order = this.currentFilters.order;
        if (order !== 'default') {
            services.sort((a, b) => {
                switch (order) {
                    case 'name-asc': return a.name.localeCompare(b.name);
                    case 'name-desc': return b.name.localeCompare(a.name);
                    case 'price-asc': return a.price - b.price;
                    case 'price-desc': return b.price - a.price;
                    case 'rating-desc': return (b.averageRating || 0) - (a.averageRating || 0);
                    default: return 0;
                }
            });
        }
        
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

        for (let i = 1; i <= totalPages; i++) {
            const button = document.createElement('button');
            button.textContent = i;
            button.className = `px-3 py-1 text-sm rounded-md ${this.currentPage === i ? 'bg-primary text-white' : 'bg-white text-gray-700 hover:bg-gray-100'}`;
            button.onclick = () => {
                this.currentPage = i;
                this.renderPage();
            };
            this.elements.pagination.appendChild(button);
        }
    }

    createServiceCard(service) {
        const imageUrl = service.imageUrl || this.getServiceImage(service.serviceId);
        const rating = service.averageRating || 0;
        const escapedService = JSON.stringify(service).replace(/"/g, "&quot;");
        
        return `
            <div class="bg-white rounded-lg shadow-lg overflow-hidden flex flex-col">
                <a href="${this.contextPath}/service-details?id=${service.serviceId}" class="block">
                    <img src="${imageUrl}" alt="${service.name}" class="w-full h-48 object-cover" onerror="this.src='${this.beautyImages[0]}'">
                </a>
                <div class="p-5 flex-grow flex flex-col">
                    <h3 class="text-lg font-semibold text-spa-dark mb-2 flex-grow">${service.name}</h3>
                    <div class="text-xl font-bold text-primary my-2">${service.formattedPrice}</div>
                    <button class="w-full mt-auto bg-primary text-white py-2.5 rounded-full hover:bg-primary-dark transition-colors font-medium text-sm" 
                            onclick='window.cartManager.addToCart(${escapedService})'>
                        Thêm vào giỏ
                    </button>
                </div>
            </div>`;
    }

    getServiceImage(serviceId) {
        const imageIndex = Math.abs(serviceId * 7) % this.beautyImages.length;
        return this.beautyImages[imageIndex];
    }
    
    clearAllFilters() {
        this.currentFilters = { searchQuery: '', serviceTypeId: 'all', order: 'default' };
        this.elements.searchInput.value = '';
        this.elements.serviceTypeSelect.value = 'all';
        this.elements.sortSelect.value = 'default';
        this.currentPage = 1;
        this.applyFiltersAndRender();
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
        const manager = new RecentlyViewedPageManager();
        manager.init();
    }
}); 