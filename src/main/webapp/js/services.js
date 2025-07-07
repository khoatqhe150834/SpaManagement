// services.js - Services page functionality
class ServicesManager {
    constructor() {
        this.currentPage = 1;
        this.pageSize = 12;
        this.currentFilters = {
            searchQuery: '',
            category: 'all',
            minPrice: null,
            maxPrice: null,
            order: 'default'
        };
        this.serviceTypes = [];
        this.priceRange = { min: 0, max: 10000000 };

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

    async init() {
        try {
            // Initialize Lucide icons
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }

            // Load service types first
            await this.loadServiceTypes();
            
            // Load initial services
        await this.loadServices();
            
            // Setup event listeners
            this.setupEventListeners();
            
            // Setup price range slider
            this.setupPriceSlider();
            
        } catch (error) {
            console.error('Error initializing services page:', error);
            this.showError('Lỗi khi tải trang dịch vụ');
        }
    }

    async loadServiceTypes() {
        try {
            const response = await fetch('/api/service-types');
            const data = await response.json();
            
            if (data.success) {
                this.serviceTypes = data.serviceTypes;
                this.updateServiceTypeFilters();
            } else {
                console.error('Error loading service types:', data.error);
            }
        } catch (error) {
            console.error('Error fetching service types:', error);
        }
    }

    async loadServices() {
        try {
            this.showLoading();
            
            const params = new URLSearchParams({
                page: this.currentPage,
                size: this.pageSize
            });

            // Add filters to params
            if (this.currentFilters.searchQuery) {
                params.append('name', this.currentFilters.searchQuery);
            }
            if (this.currentFilters.category && this.currentFilters.category !== 'all') {
                params.append('category', this.currentFilters.category);
            }
            if (this.currentFilters.minPrice !== null) {
                params.append('minPrice', this.currentFilters.minPrice);
            }
            if (this.currentFilters.maxPrice !== null) {
                params.append('maxPrice', this.currentFilters.maxPrice);
            }
            if (this.currentFilters.order && this.currentFilters.order !== 'default') {
                params.append('order', this.currentFilters.order);
            }

            const response = await fetch(`/api/services?${params}`);
            const data = await response.json();
            
            this.hideLoading();
            
            if (data.success) {
                this.renderServices(data.services);
                this.renderPagination(data.pagination);
                this.updateResultsCount(data.pagination.totalCount);
            } else {
                this.showError(data.error || 'Lỗi khi tải dịch vụ');
            }
        } catch (error) {
            this.hideLoading();
            console.error('Error loading services:', error);
            this.showError('Lỗi khi tải dịch vụ');
        }
    }

    renderServices(services) {
        const container = document.getElementById('services-grid');
        
        if (!services || services.length === 0) {
            container.innerHTML = `
                <div class="col-span-full text-center py-12">
                    <div class="text-gray-500 text-lg mb-4">
                        <i data-lucide="search-x" class="h-16 w-16 mx-auto mb-4 text-gray-400"></i>
                        <p>Không tìm thấy dịch vụ nào</p>
                        <p class="text-sm mt-2">Hãy thử thay đổi bộ lọc hoặc từ khóa tìm kiếm</p>
                    </div>
                </div>
            `;
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }
            return;
        }

        container.innerHTML = services.map(service => this.createServiceCard(service)).join('');
        
        // Reinitialize icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
    }
    
    createServiceCard(service) {
        const formattedPrice = new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(service.price);

        const rating = service.averageRating || 0;
        const stars = this.generateStars(rating);
        const imageUrl = service.imageUrl || this.getServiceImage(service.serviceId);

        return `
            <div class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-shadow duration-300">
            <div class="relative">
                    <img 
                        src="${imageUrl}" 
                        alt="${service.name}"
                        class="w-full h-48 object-cover"
                        onerror="this.src='${this.beautyImages[0]}'"
                    />
                    ${service.averageRating >= 4.5 ? '<div class="absolute top-2 right-2 bg-primary text-white px-2 py-1 rounded-full text-xs font-medium">Phổ biến</div>' : ''}
                </div>
                
                <div class="p-6">
                    <div class="flex items-center justify-between mb-2">
                        <span class="text-sm text-primary font-medium">${service.serviceTypeId?.name || 'Dịch vụ'}</span>
                        <span class="text-sm text-gray-500">${service.durationMinutes} phút</span>
            </div>
                    
                    <h3 class="text-lg font-serif font-bold text-spa-dark mb-2">${service.name}</h3>
                    
                    <p class="text-gray-600 text-sm mb-4 line-clamp-2">${service.description || ''}</p>
                    
                    <div class="flex items-center mb-4">
                        <div class="flex items-center mr-2">
                            ${stars}
                </div>
                        <span class="text-sm text-gray-600">(${rating.toFixed(1)})</span>
                    </div>
                    
                    <div class="flex items-center justify-between">
                        <div class="text-2xl font-bold text-primary">${formattedPrice}</div>
                        <button 
                            class="bg-primary text-white px-4 py-2 rounded-full hover:bg-primary-dark transition-colors duration-300 text-sm font-medium"
                            onclick="servicesManager.viewServiceDetails(${service.serviceId})"
                        >
                        Xem chi tiết
                    </button>
                    </div>
                </div>
            </div>
        `;
    }

    generateStars(rating) {
        const fullStars = Math.floor(rating);
        const hasHalfStar = rating % 1 >= 0.5;
        const emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

        let stars = '';
        
        // Full stars
        for (let i = 0; i < fullStars; i++) {
            stars += '<i data-lucide="star" class="h-4 w-4 fill-yellow-400 text-yellow-400"></i>';
        }
        
        // Half star
        if (hasHalfStar) {
            stars += '<i data-lucide="star-half" class="h-4 w-4 fill-yellow-400 text-yellow-400"></i>';
        }
        
        // Empty stars
        for (let i = 0; i < emptyStars; i++) {
            stars += '<i data-lucide="star" class="h-4 w-4 text-gray-300"></i>';
        }
        
        return stars;
    }

    getServiceImage(serviceId) {
        // Simple hash function to get a consistent image based on service ID
        const imageIndex = Math.abs(serviceId * 7) % this.beautyImages.length;
        return this.beautyImages[imageIndex];
    }

    renderPagination(pagination) {
        const container = document.getElementById('pagination');
        
        if (pagination.totalPages <= 1) {
            container.innerHTML = '';
            return;
        }

        let paginationHTML = '';

        // Previous button
        if (pagination.hasPrevious) {
            paginationHTML += `
                <button onclick="servicesManager.goToPage(${pagination.currentPage - 1})" 
                        class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-l-md hover:bg-gray-50">
                    <i data-lucide="chevron-left" class="h-4 w-4"></i>
                </button>
            `;
        }

        // Page numbers
        const startPage = Math.max(1, pagination.currentPage - 2);
        const endPage = Math.min(pagination.totalPages, pagination.currentPage + 2);

        if (startPage > 1) {
            paginationHTML += `<button onclick="servicesManager.goToPage(1)" class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 hover:bg-gray-50">1</button>`;
            if (startPage > 2) {
                paginationHTML += `<span class="px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300">...</span>`;
            }
        }

        for (let i = startPage; i <= endPage; i++) {
            const isActive = i === pagination.currentPage;
            paginationHTML += `
                <button onclick="servicesManager.goToPage(${i})" 
                        class="px-3 py-2 text-sm font-medium ${isActive ? 'text-white bg-primary border-primary' : 'text-gray-500 bg-white border-gray-300 hover:bg-gray-50'} border">
                    ${i}
                </button>
            `;
        }

        if (endPage < pagination.totalPages) {
            if (endPage < pagination.totalPages - 1) {
                paginationHTML += `<span class="px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300">...</span>`;
            }
            paginationHTML += `<button onclick="servicesManager.goToPage(${pagination.totalPages})" class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 hover:bg-gray-50">${pagination.totalPages}</button>`;
        }

        // Next button
        if (pagination.hasNext) {
            paginationHTML += `
                <button onclick="servicesManager.goToPage(${pagination.currentPage + 1})" 
                        class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-r-md hover:bg-gray-50">
                    <i data-lucide="chevron-right" class="h-4 w-4"></i>
                </button>
            `;
        }

        container.innerHTML = `<div class="flex">${paginationHTML}</div>`;
        
        // Reinitialize icons
        if (typeof lucide !== 'undefined') {
        lucide.createIcons();
        }
    }

    updateServiceTypeFilters() {
        // Update sidebar categories
        const sidebarContainer = document.querySelector('#filters-sidebar .space-y-2');
        if (sidebarContainer) {
            sidebarContainer.innerHTML = this.serviceTypes.map(type => `
                <label class="flex items-center">
                    <input
                        type="checkbox"
                        value="${type.serviceTypeId}"
                        class="category-filter rounded text-primary focus:ring-primary"
                    />
                    <span class="ml-2 text-sm">${type.name}</span>
                </label>
            `).join('');
        }

        // Update mobile categories
        const mobileContainer = document.querySelector('#mobile-filter-modal .space-y-2');
        if (mobileContainer) {
            mobileContainer.innerHTML = this.serviceTypes.map(type => `
                <label class="flex items-center">
                    <input
                        type="checkbox"
                        value="${type.serviceTypeId}"
                        class="mobile-category-filter rounded text-primary focus:ring-primary"
                    />
                    <span class="ml-2 text-sm">${type.name}</span>
                </label>
            `).join('');
        }
    }

    setupPriceSlider() {
        // Create a custom price range slider
        const priceSection = document.querySelector('[data-price-section]') || this.createPriceSection();
        
        // For now, use the existing radio buttons
        // You can later implement a proper range slider library like noUiSlider
    }

    createPriceSection() {
        const sidebar = document.querySelector('#filters-sidebar .bg-white');
        const priceHTML = `
            <div class="mb-6" data-price-section>
                <h4 class="font-medium text-spa-dark mb-3">Khoảng giá tùy chỉnh</h4>
                <div class="flex gap-2 mb-3">
                    <input 
                        type="number" 
                        id="min-price-input" 
                        placeholder="Từ" 
                        class="flex-1 px-3 py-2 border border-gray-300 rounded-md text-sm"
                        min="0"
                    />
                    <input 
                        type="number" 
                        id="max-price-input" 
                        placeholder="Đến" 
                        class="flex-1 px-3 py-2 border border-gray-300 rounded-md text-sm"
                        min="0"
                    />
                </div>
                <button 
                    id="apply-price-filter" 
                    class="w-full bg-primary text-white py-2 rounded-md text-sm hover:bg-primary-dark"
                >
                    Áp dụng
                </button>
            </div>
        `;
        
        if (sidebar) {
            sidebar.insertAdjacentHTML('beforeend', priceHTML);
        }
        
        return document.querySelector('[data-price-section]');
    }

    setupEventListeners() {
        // Search input
        const searchInput = document.getElementById('search-input');
        if (searchInput) {
            let searchTimeout;
            searchInput.addEventListener('input', (e) => {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    this.currentFilters.searchQuery = e.target.value.trim();
                    this.currentPage = 1;
                    this.loadServices();
                }, 500);
            });
        }

        // Sort dropdown
        const sortSelect = document.getElementById('sort-select');
        if (sortSelect) {
            sortSelect.addEventListener('change', (e) => {
                this.currentFilters.order = e.target.value;
                this.currentPage = 1;
                this.loadServices();
            });
        }

        // Category filters
        document.addEventListener('change', (e) => {
            if (e.target.classList.contains('category-filter') || e.target.classList.contains('mobile-category-filter')) {
                this.updateCategoryFilter();
            }
        });

        // Price range filters
        document.addEventListener('change', (e) => {
            if (e.target.name === 'price-range') {
                this.updatePriceFilter(e.target.value);
            }
        });

        // Custom price inputs
        document.addEventListener('click', (e) => {
            if (e.target.id === 'apply-price-filter') {
                this.applyCustomPriceFilter();
            }
        });

        // Clear filters
        const clearFiltersBtn = document.getElementById('clear-filters');
        if (clearFiltersBtn) {
            clearFiltersBtn.addEventListener('click', () => {
                this.clearAllFilters();
            });
        }

        // Mobile filter modal
        this.setupMobileFilters();
    }

    setupMobileFilters() {
        const mobileFilterBtn = document.getElementById('mobile-filter-btn');
        const mobileFilterModal = document.getElementById('mobile-filter-modal');
        const closeMobileFilter = document.getElementById('close-mobile-filter');
        const applyMobileFilters = document.getElementById('apply-mobile-filters');
        const clearMobileFilters = document.getElementById('clear-mobile-filters');

        if (mobileFilterBtn && mobileFilterModal) {
            mobileFilterBtn.addEventListener('click', () => {
                mobileFilterModal.classList.add('active');
            });
        }

        if (closeMobileFilter && mobileFilterModal) {
            closeMobileFilter.addEventListener('click', () => {
                mobileFilterModal.classList.remove('active');
            });
        }

        if (applyMobileFilters) {
            applyMobileFilters.addEventListener('click', () => {
                this.applyMobileFilters();
                mobileFilterModal.classList.remove('active');
            });
        }

        if (clearMobileFilters) {
            clearMobileFilters.addEventListener('click', () => {
                this.clearMobileFilters();
            });
        }
    }

    updateCategoryFilter() {
        const selectedCategories = [];
        document.querySelectorAll('.category-filter:checked, .mobile-category-filter:checked').forEach(checkbox => {
            selectedCategories.push(checkbox.value);
        });

        if (selectedCategories.length === 0) {
            this.currentFilters.category = 'all';
        } else {
            // For simplicity, use the first selected category
            // You can modify this to support multiple categories
            this.currentFilters.category = selectedCategories[0];
        }

        this.currentPage = 1;
        this.loadServices();
    }

    updatePriceFilter(priceRange) {
        switch(priceRange) {
            case '0-300':
                this.currentFilters.minPrice = 0;
                this.currentFilters.maxPrice = 300000;
                break;
            case '300-500':
                this.currentFilters.minPrice = 300000;
                this.currentFilters.maxPrice = 500000;
                break;
            case '500-800':
                this.currentFilters.minPrice = 500000;
                this.currentFilters.maxPrice = 800000;
                break;
            case '800+':
                this.currentFilters.minPrice = 800000;
                this.currentFilters.maxPrice = null;
                break;
            default:
                this.currentFilters.minPrice = null;
                this.currentFilters.maxPrice = null;
        }

        this.currentPage = 1;
        this.loadServices();
    }

    applyCustomPriceFilter() {
        const minInput = document.getElementById('min-price-input');
        const maxInput = document.getElementById('max-price-input');

        if (minInput && maxInput) {
            const minPrice = minInput.value ? parseInt(minInput.value) : null;
            const maxPrice = maxInput.value ? parseInt(maxInput.value) : null;

            this.currentFilters.minPrice = minPrice;
            this.currentFilters.maxPrice = maxPrice;

            this.currentPage = 1;
            this.loadServices();
        }
    }

    clearAllFilters() {
        // Reset filters
        this.currentFilters = {
            searchQuery: '',
            category: 'all',
            minPrice: null,
            maxPrice: null,
            order: 'default'
        };

        // Clear UI
        const searchInput = document.getElementById('search-input');
        if (searchInput) searchInput.value = '';

        const sortSelect = document.getElementById('sort-select');
        if (sortSelect) sortSelect.value = 'default';

        document.querySelectorAll('.category-filter, .mobile-category-filter').forEach(checkbox => {
            checkbox.checked = false;
        });

        document.querySelectorAll('input[name="price-range"]').forEach(radio => {
            radio.checked = false;
        });

        const minPriceInput = document.getElementById('min-price-input');
        const maxPriceInput = document.getElementById('max-price-input');
        if (minPriceInput) minPriceInput.value = '';
        if (maxPriceInput) maxPriceInput.value = '';

        this.currentPage = 1;
        this.loadServices();
    }

    applyMobileFilters() {
        // Sync mobile filters with main filters
        this.updateCategoryFilter();
    }

    clearMobileFilters() {
        document.querySelectorAll('.mobile-category-filter').forEach(checkbox => {
            checkbox.checked = false;
        });
    }

    goToPage(page) {
        this.currentPage = page;
        this.loadServices();
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    updateResultsCount(count) {
        const resultsElement = document.getElementById('results-count');
        if (resultsElement) {
            resultsElement.textContent = `Hiển thị ${count} kết quả`;
        }
    }

    viewServiceDetails(serviceId) {
        // Implement service detail modal or redirect
        console.log('View service details:', serviceId);
        // You can implement a modal or redirect to a detail page
        // For now, let's redirect to a booking page or show an alert
        alert(`Xem chi tiết dịch vụ ID: ${serviceId}`);
    }

    showLoading() {
        const container = document.getElementById('services-grid');
        if (container) {
            container.innerHTML = `
                <div class="col-span-full text-center py-12">
                    <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto"></div>
                    <p class="mt-4 text-gray-600">Đang tải dịch vụ...</p>
            </div>
        `;
        }
    }

    hideLoading() {
        // Loading will be hidden when services are rendered
    }

    showError(message) {
        const container = document.getElementById('services-grid');
        if (container) {
            container.innerHTML = `
                <div class="col-span-full text-center py-12">
                    <div class="text-red-500 text-lg mb-4">
                        <i data-lucide="alert-circle" class="h-16 w-16 mx-auto mb-4"></i>
                        <p>${message}</p>
                    </div>
                </div>
            `;
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }
        }
    }
}

// Initialize the services manager when the page loads
let servicesManager;
document.addEventListener('DOMContentLoaded', () => {
    servicesManager = new ServicesManager();
});

// Add CSS for modal
const modalCSS = `
.modal {
    display: none;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0,0,0,0.5);
    align-items: center;
    justify-content: center;
    padding: 20px;
}

.modal.active {
    display: flex;
}

.line-clamp-2 {
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}
`;

// Add CSS to head
const style = document.createElement('style');
style.textContent = modalCSS;
document.head.appendChild(style); 