// services.js - Enhanced Services page functionality
class ServicesPageManager {
    constructor() {
        this.currentPage = 1;
        this.pageSize = this.getPageSize(); // Dynamic page size
        this.currentFilters = {
            searchQuery: '',
            category: 'all',
            minPrice: null,
            maxPrice: null,
            order: 'default'
        };
        this.serviceTypes = [];
        this.priceRange = { min: 0, max: 10000000 };
        this.serviceDetailsUrl = null;

        this.init();
    }

    getPageSize() {
        // Check if page size is set from server-side data
        if (window.servicesPageData && window.servicesPageData.pageSize) {
            return parseInt(window.servicesPageData.pageSize);
        }
        
        // Check for URL parameter
        const urlParams = new URLSearchParams(window.location.search);
        const pageSizeParam = urlParams.get('pageSize');
        if (pageSizeParam) {
            const pageSize = parseInt(pageSizeParam);
            if (pageSize > 0 && pageSize <= 100) { // Reasonable limits
                return pageSize;
            }
        }
        
        // Check localStorage for user preference
        const savedPageSize = localStorage.getItem('servicesPageSize');
        if (savedPageSize) {
            const pageSize = parseInt(savedPageSize);
            if (pageSize > 0 && pageSize <= 100) {
                return pageSize;
            }
        }
        
        // Dynamic based on screen size
        return this.calculateDynamicPageSize();
    }

    calculateDynamicPageSize() {
        const screenWidth = window.innerWidth;
        const screenHeight = window.innerHeight;
        
        // Mobile devices
        if (screenWidth < 768) {
            return 8; // Smaller page size for mobile
        }
        // Tablet devices
        else if (screenWidth < 1024) {
            return 12;
        }
        // Desktop - calculate based on screen size
        else {
            // Estimate how many cards can fit on screen
            const cardHeight = 450; // Approximate card height
            const headerHeight = 200; // Approximate header/filter height
            const availableHeight = screenHeight - headerHeight;
            const cardsPerColumn = Math.floor(availableHeight / cardHeight);
            
            // Cards per row (responsive grid)
            let cardsPerRow = 4; // Default for large screens
            if (screenWidth < 1280) cardsPerRow = 3;
            if (screenWidth < 1024) cardsPerRow = 2;
            
            // Calculate total cards that fit on screen + 1 row for scrolling
            const calculatedSize = Math.max(8, (cardsPerColumn + 1) * cardsPerRow);
            
            // Cap at reasonable maximum
            return Math.min(calculatedSize, 24);
        }
    }

    setPageSize(newPageSize) {
        if (newPageSize > 0 && newPageSize <= 100) {
            this.pageSize = newPageSize;
            // Save user preference
            localStorage.setItem('servicesPageSize', newPageSize.toString());
            // Trigger reload if using API
            if (window.servicesManager && typeof window.servicesManager.loadServices === 'function') {
                window.servicesManager.pageSize = newPageSize;
                window.servicesManager.currentPage = 1; // Reset to first page
                window.servicesManager.loadServices();
            }
        }
    }

    init() {
        try {
            // Initialize Lucide icons
        if (typeof lucide !== 'undefined') {
        lucide.createIcons();
            }

            // Get data from window object set by JSP
            if (window.servicesPageData) {
                this.serviceDetailsUrl = window.servicesPageData.serviceDetailsUrl;
                if (window.servicesPageData.priceRange) {
                    this.priceRange = window.servicesPageData.priceRange;
                }
            }

            // Initialize page components
            this.initializeEventListeners();
            this.initializePriceSlider();
            this.stabilizeCardLayout();
            this.initializeResponsivePageSize();

        } catch (error) {
            console.error('ServicesPageManager initialization error:', error);
        }
    }

    initializeEventListeners() {
        // Search functionality
        const searchInput = document.getElementById('search-input');
        if (searchInput) {
            let searchTimeout;
            searchInput.addEventListener('input', (e) => {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    this.currentFilters.searchQuery = e.target.value.trim();
                    this.applyFilters();
                }, 300);
            });
        }

        // Service type filter
        const serviceTypeSelect = document.getElementById('service-type-select');
        if (serviceTypeSelect) {
            serviceTypeSelect.addEventListener('change', (e) => {
                this.currentFilters.category = e.target.value;
                this.applyFilters();
            });
        }

        // Sort functionality
        const sortSelect = document.getElementById('sort-select');
        if (sortSelect) {
            sortSelect.addEventListener('change', (e) => {
                this.currentFilters.order = e.target.value;
                this.applyFilters();
            });
        }

        // Service detail buttons
        document.addEventListener('click', (e) => {
            if (e.target.matches('.service-detail-btn') || e.target.closest('.service-detail-btn')) {
                const btn = e.target.matches('.service-detail-btn') ? e.target : e.target.closest('.service-detail-btn');
                const serviceId = btn.getAttribute('data-service-id');
                if (serviceId && this.serviceDetailsUrl) {
                    window.location.href = `${this.serviceDetailsUrl}?id=${serviceId}`;
                }
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
        this.initializeMobileFilters();
    }

    initializePriceSlider() {
        console.log('🎚️ Initializing price slider...');
        
        const minSlider = document.getElementById('min-price-slider');
        const maxSlider = document.getElementById('max-price-slider');
        const minInput = document.getElementById('min-price-input');
        const maxInput = document.getElementById('max-price-input');
        const minDisplay = document.getElementById('min-price-display');
        const maxDisplay = document.getElementById('max-price-display');
        const sliderRange = document.getElementById('slider-range');

        console.log('🔍 Slider elements found:', {
            minSlider: !!minSlider,
            maxSlider: !!maxSlider,
            minInput: !!minInput,
            maxInput: !!maxInput,
            minDisplay: !!minDisplay,
            maxDisplay: !!maxDisplay,
            sliderRange: !!sliderRange
        });

        if (!minSlider || !maxSlider) {
            console.error('❌ Price slider elements not found!');
            return;
        }

        // Set initial values from server data
        console.log('💰 Price range data:', this.priceRange);
        const initialMin = this.priceRange.min || 100000;
        const initialMax = this.priceRange.max || 15000000;
        console.log('📊 Using price range:', { initialMin, initialMax });
        
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

        // Update display with proper formatting
        this.updatePriceDisplay(initialMin, initialMax);
        this.updateSliderRange(initialMin, initialMax, initialMin, initialMax);
        
        // Update price limit displays with proper formatting
        const priceMinLimit = document.getElementById('price-min-limit');
        const priceMaxLimit = document.getElementById('price-max-limit');
        if (priceMinLimit) {
            priceMinLimit.textContent = this.formatPrice(initialMin);
        }
        if (priceMaxLimit) {
            priceMaxLimit.textContent = this.formatPrice(initialMax);
        }

        // Add event listeners
        const updatePriceRange = () => {
            let minVal = parseInt(minSlider.value);
            let maxVal = parseInt(maxSlider.value);

            // Ensure min is not greater than max
            if (minVal >= maxVal) {
                minVal = maxVal - 50000;
                minSlider.value = minVal;
            }

            // Update inputs
            if (minInput) minInput.value = minVal;
            if (maxInput) maxInput.value = maxVal;

            // Update display
            this.updatePriceDisplay(minVal, maxVal);
            this.updateSliderRange(minVal, maxVal, initialMin, initialMax);

            // Update filters
            this.currentFilters.minPrice = minVal;
            this.currentFilters.maxPrice = maxVal;
            
            // Apply filters with debounce
            clearTimeout(this.priceFilterTimeout);
            this.priceFilterTimeout = setTimeout(() => {
                this.applyFilters();
            }, 500);
        };

        minSlider.addEventListener('input', updatePriceRange);
        maxSlider.addEventListener('input', updatePriceRange);

        // Input field listeners
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

        console.log('✅ Price slider initialized successfully!');
    }

    initializeResponsivePageSize() {
        // Recalculate page size on window resize (debounced)
        let resizeTimeout;
        window.addEventListener('resize', () => {
            clearTimeout(resizeTimeout);
            resizeTimeout = setTimeout(() => {
                const newPageSize = this.calculateDynamicPageSize();
                if (newPageSize !== this.pageSize) {
                    console.log(`📱 Responsive page size changed: ${this.pageSize} → ${newPageSize}`);
                    this.pageSize = newPageSize;
                    
                    // Update API manager if available
                    if (window.servicesManager && typeof window.servicesManager.loadServices === 'function') {
                        window.servicesManager.pageSize = newPageSize;
                        window.servicesManager.currentPage = 1; // Reset to first page
                        window.servicesManager.loadServices();
                    }
                }
            }, 300);
        });
        
        console.log(`📏 Initial dynamic page size: ${this.pageSize}`);
    }

    updatePriceDisplay(minVal, maxVal) {
        const minDisplay = document.getElementById('min-price-display');
        const maxDisplay = document.getElementById('max-price-display');
        
        if (minDisplay) {
            minDisplay.textContent = this.formatPrice(minVal);
        }
        if (maxDisplay) {
            maxDisplay.textContent = this.formatPrice(maxVal);
        }
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

    stabilizeCardLayout() {
        // Ensure all service cards have consistent height immediately
        const serviceCards = document.querySelectorAll('.service-card');
        
        serviceCards.forEach((card) => {
            // Force consistent height and prevent layout shift
            card.style.minHeight = '450px';
            
            // Ensure image containers are stable
            const imageContainer = card.querySelector('.relative.h-48');
            if (imageContainer) {
                imageContainer.style.height = '192px';
                imageContainer.style.minHeight = '192px';
                imageContainer.style.maxHeight = '192px';
                imageContainer.style.overflow = 'hidden';
            }

            // Ensure all images are immediately visible (no opacity transitions)
            const images = card.querySelectorAll('img');
            images.forEach(img => {
                img.style.opacity = '1';
                img.style.transition = 'transform 0.3s ease'; // Only transform for hover
            });
        });
    }

    showSkeletonLoading() {
        const skeletonLoading = document.getElementById('skeleton-loading');
        if (skeletonLoading) {
            skeletonLoading.style.display = 'contents';
        }
    }

    hideSkeletonLoading() {
        const skeletonLoading = document.getElementById('skeleton-loading');
        if (skeletonLoading) {
            skeletonLoading.style.display = 'none';
        }
    }

    applyFilters() {
        // Delegate to services-api.js if it exists and has filtering capability
        if (window.servicesManager && typeof window.servicesManager.loadServices === 'function') {
            // Update the API manager's filters
            if (window.servicesManager.currentFilters) {
                window.servicesManager.currentFilters.minPrice = this.currentFilters.minPrice;
                window.servicesManager.currentFilters.maxPrice = this.currentFilters.maxPrice;
                window.servicesManager.currentFilters.searchQuery = this.currentFilters.searchQuery;
                window.servicesManager.currentFilters.category = this.currentFilters.category;
                window.servicesManager.currentFilters.order = this.currentFilters.order;
            }
            // Trigger API filtering
            window.servicesManager.loadServices();
            return;
        }
        
        // Also try the global servicesManager variable
        if (typeof servicesManager !== 'undefined' && servicesManager && typeof servicesManager.loadServices === 'function') {
            // Update the API manager's filters
            if (servicesManager.currentFilters) {
                servicesManager.currentFilters.minPrice = this.currentFilters.minPrice;
                servicesManager.currentFilters.maxPrice = this.currentFilters.maxPrice;
                servicesManager.currentFilters.searchQuery = this.currentFilters.searchQuery;
                servicesManager.currentFilters.category = this.currentFilters.category;
                servicesManager.currentFilters.order = this.currentFilters.order;
            }
            // Trigger API filtering
            servicesManager.loadServices();
            return;
        }

        // Fallback: Filter existing server-rendered services (if any)
        const serviceCards = document.querySelectorAll('.service-card');
        let visibleCount = 0;

        serviceCards.forEach(card => {
            const serviceName = card.getAttribute('data-service-name') || '';
            const servicePrice = parseInt(card.getAttribute('data-service-price')) || 0;
            const serviceType = card.getAttribute('data-service-type') || '';

            let visible = true;

            // Search filter
            if (this.currentFilters.searchQuery) {
                const query = this.currentFilters.searchQuery.toLowerCase();
                visible = visible && serviceName.toLowerCase().includes(query);
            }

            // Category filter
            if (this.currentFilters.category && this.currentFilters.category !== 'all') {
                visible = visible && serviceType === this.currentFilters.category;
            }

            // Price filters
            if (this.currentFilters.minPrice !== null) {
                visible = visible && servicePrice >= this.currentFilters.minPrice;
            }
            if (this.currentFilters.maxPrice !== null) {
                visible = visible && servicePrice <= this.currentFilters.maxPrice;
            }

            // Show/hide card
            if (visible) {
                card.style.display = 'block';
                visibleCount++;
            } else {
                card.style.display = 'none';
            }
        });

        // Apply sorting to visible cards
        this.applySorting();

        // Update results count
        this.updateResultsCount(visibleCount);
    }

    applySorting() {
        const container = document.getElementById('services-grid');
        if (!container) return;

        const cards = Array.from(container.querySelectorAll('.service-card[style*="display: block"], .service-card:not([style*="display: none"])'));
        
        if (this.currentFilters.order === 'default') return; // Keep original order

        cards.sort((a, b) => {
            const nameA = a.getAttribute('data-service-name') || '';
            const nameB = b.getAttribute('data-service-name') || '';
            const priceA = parseInt(a.getAttribute('data-service-price')) || 0;
            const priceB = parseInt(b.getAttribute('data-service-price')) || 0;

            switch (this.currentFilters.order) {
                case 'name-asc':
                    return nameA.localeCompare(nameB, 'vi');
                case 'name-desc':
                    return nameB.localeCompare(nameA, 'vi');
                case 'price-asc':
                    return priceA - priceB;
                case 'price-desc':
                    return priceB - priceA;
                default:
                    return 0;
            }
        });

        // Reorder the DOM elements
        cards.forEach(card => container.appendChild(card));
    }

    updateResultsCount(count) {
        const resultsCount = document.getElementById('results-count');
        if (resultsCount) {
            resultsCount.textContent = `Hiển thị ${count} kết quả`;
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

        // Reset form elements
        const searchInput = document.getElementById('search-input');
        if (searchInput) searchInput.value = '';

        const serviceTypeSelect = document.getElementById('service-type-select');
        if (serviceTypeSelect) serviceTypeSelect.value = 'all';

        const sortSelect = document.getElementById('sort-select');
        if (sortSelect) sortSelect.value = 'default';

        // Reset price sliders
        this.resetPriceSlider();

        // Apply filters
        this.applyFilters();
    }

    resetPriceSlider() {
        const minSlider = document.getElementById('min-price-slider');
        const maxSlider = document.getElementById('max-price-slider');
        const minInput = document.getElementById('min-price-input');
        const maxInput = document.getElementById('max-price-input');

        const initialMin = this.priceRange.min || 100000;
        const initialMax = this.priceRange.max || 15000000;

        if (minSlider) minSlider.value = initialMin;
        if (maxSlider) maxSlider.value = initialMax;
        if (minInput) minInput.value = initialMin;
        if (maxInput) maxInput.value = initialMax;

        this.updatePriceDisplay(initialMin, initialMax);
        this.updateSliderRange(initialMin, initialMax, initialMin, initialMax);
        
        // Update price limit displays with proper formatting
        const priceMinLimit = document.getElementById('price-min-limit');
        const priceMaxLimit = document.getElementById('price-max-limit');
        if (priceMinLimit) {
            priceMinLimit.textContent = this.formatPrice(initialMin);
        }
        if (priceMaxLimit) {
            priceMaxLimit.textContent = this.formatPrice(initialMax);
        }
    }

    initializeMobileFilters() {
        const mobileFilterBtn = document.getElementById('mobile-filter-btn');
        const mobileFilterModal = document.getElementById('mobile-filter-modal');
        const closeMobileFilter = document.getElementById('close-mobile-filter');
        const clearMobileFilters = document.getElementById('clear-mobile-filters');

        if (mobileFilterBtn && mobileFilterModal) {
            mobileFilterBtn.addEventListener('click', () => {
                mobileFilterModal.style.display = 'flex';
                document.body.style.overflow = 'hidden';
            });
        }

        if (closeMobileFilter && mobileFilterModal) {
            closeMobileFilter.addEventListener('click', () => {
                mobileFilterModal.style.display = 'none';
                document.body.style.overflow = '';
            });
        }

        if (clearMobileFilters) {
            clearMobileFilters.addEventListener('click', () => {
                this.clearAllFilters();
                if (mobileFilterModal) {
                    mobileFilterModal.style.display = 'none';
                    document.body.style.overflow = '';
                }
            });
        }

        // Mobile service type filter
        const mobileServiceTypeSelect = document.getElementById('mobile-service-type-select');
        if (mobileServiceTypeSelect) {
            mobileServiceTypeSelect.addEventListener('change', (e) => {
                this.currentFilters.category = e.target.value;
                this.applyFilters();
                
                // Sync with desktop filter
                const desktopSelect = document.getElementById('service-type-select');
                if (desktopSelect) desktopSelect.value = e.target.value;
            });
        }
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    console.log('Services page loading...');
    
    // Initialize the services page manager
    const servicesManager = new ServicesPageManager();
    
    // Make it globally accessible for debugging
    window.servicesManager = servicesManager;
    
    console.log('Services page loaded successfully');
}); 