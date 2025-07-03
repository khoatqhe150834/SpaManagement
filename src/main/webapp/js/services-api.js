// services-api.js - Enhanced API-based Services page functionality
class ServicesManager {
    constructor() {
        this.currentPage = 1;
        this.pageSize = 12;
        this.currentFilters = {
            searchQuery: '',
            category: 'all',
            minPrice: 0,
            maxPrice: 1000000,
            order: 'default'
        };
        this.serviceTypes = [];
        this.priceRange = { min: 0, max: 1000000 };
        this.rangeSlider = null;
        this.isLoading = false;
        
        // Beauty-themed splash images
        this.beautyImages = [
            'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAwIiBoZWlnaHQ9IjIwMCIgdmlld0JveD0iMCAwIDMwMCAyMDAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGRlZnM+PGxpbmVhckdyYWRpZW50IGlkPSJhIiB4MT0iMCUiIHkxPSIwJSIgeDI9IjEwMCUiIHkyPSIxMDAlIj48c3RvcCBvZmZzZXQ9IjAlIiBzdG9wLWNvbG9yPSIjRkZGOEYwIi8+PHN0b3Agb2Zmc2V0PSIxMDAlIiBzdG9wLWNvbG9yPSIjRkFEQUREIi8+PC9saW5lYXJHcmFkaWVudD48L2RlZnM+PHJlY3Qgd2lkdGg9IjMwMCIgaGVpZ2h0PSIyMDAiIGZpbGw9InVybCgjYSkiLz48Y2lyY2xlIGN4PSIxNTAiIGN5PSIxMDAiIHI9IjQwIiBmaWxsPSIjRDRBRjM3IiBvcGFjaXR5PSIwLjgiLz48cGF0aCBkPSJNMTMwIDkwSDE3MFYxMTBIMTMwVjkwWiIgZmlsbD0iI0Q0QUYzNyIgb3BhY2l0eT0iMC42Ii8+PHRleHQgeD0iMTUwIiB5PSIxNzAiIGZvbnQtZmFtaWx5PSJBcmlhbCwgc2Fucy1zZXJpZiIgZm9udC1zaXplPSIxNCIgZmlsbD0iI0Q0QUYzNyIgdGV4dC1hbmNob3I9Im1pZGRsZSI+U3BhIFNlcnZpY2U8L3RleHQ+PC9zdmc+',
            'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAwIiBoZWlnaHQ9IjIwMCIgdmlld0JveD0iMCAwIDMwMCAyMDAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGRlZnM+PGxpbmVhckdyYWRpZW50IGlkPSJiIiB4MT0iMCUiIHkxPSIwJSIgeDI9IjEwMCUiIHkyPSIxMDAlIj48c3RvcCBvZmZzZXQ9IjAlIiBzdG9wLWNvbG9yPSIjRkZGOEYwIi8+PHN0b3Agb2Zmc2V0PSIxMDAlIiBzdG9wLWNvbG9yPSIjRTZFNkZBIi8+PC9saW5lYXJHcmFkaWVudD48L2RlZnM+PHJlY3Qgd2lkdGg9IjMwMCIgaGVpZ2h0PSIyMDAiIGZpbGw9InVybCgjYikiLz48cGF0aCBkPSJNMTIwIDgwQzEyMCA2MC44OTQzIDEzNC44OTQgNDYgMTU0IDQ2UzE4OCA2MC44OTQzIDE4OCA4MFYxMjBDMTg4IDEzOS4xMDYgMTczLjEwNiAxNTQgMTU0IDE1NFMxMjAgMTM5LjEwNiAxMjAgMTIwVjgwWiIgZmlsbD0iI0Q0QUYzNyIgb3BhY2l0eT0iMC43Ii8+PHBhdGggZD0iTTE0MCA5MEgxNjhWMTEwSDE0MFY5MFoiIGZpbGw9IiNGRkZGRkYiIG9wYWNpdHk9IjAuOSIvPjx0ZXh0IHg9IjE1MCIgeT0iMTc1IiBmb250LWZhbWlseT0iQXJpYWwsIHNhbnMtc2VyaWYiIGZvbnQtc2l6ZT0iMTIiIGZpbGw9IiNEMTFENDciIHRleHQtYW5jaG9yPSJtaWRkbGUiPkJlYXV0eSBDYXJlPC90ZXh0Pjwvc3ZnPg==',
            'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAwIiBoZWlnaHQ9IjIwMCIgdmlld0JveD0iMCAwIDMwMCAyMDAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGRlZnM+PHJhZGlhbEdyYWRpZW50IGlkPSJjIiBjeD0iNTAlIiBjeT0iNTAlIiByPSI1MCUiPjxzdG9wIG9mZnNldD0iMCUiIHN0b3AtY29sb3I9IiNGQURBREQiLz48c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiNGRkY4RjAiLz48L3JhZGlhbEdyYWRpZW50PjwvZGVmcz48cmVjdCB3aWR0aD0iMzAwIiBoZWlnaHQ9IjIwMCIgZmlsbD0idXJsKCNjKSIvPjxlbGxpcHNlIGN4PSIxNTAiIGN5PSI5MCIgcng9IjMwIiByeT0iMjAiIGZpbGw9IiNEMTFENDciIG9wYWNpdHk9IjAuOCIvPjxlbGxpcHNlIGN4PSIxNTAiIGN5PSIxMTAiIHJ4PSI0MCIgcnk9IjI1IiBmaWxsPSIjRDRBRjM3IiBvcGFjaXR5PSIwLjYiLz48dGV4dCB4PSIxNTAiIHk9IjE2NSIgZm9udC1mYW1pbHk9IkFyaWFsLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjEzIiBmaWxsPSIjRDRBRjM3IiB0ZXh0LWFuY2hvcj0ibWlkZGxlIj5GYWNpYWwgQ2FyZTwvdGV4dD48L3N2Zz4=',
            'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAwIiBoZWlnaHQ9IjIwMCIgdmlld0JveD0iMCAwIDMwMCAyMDAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGRlZnM+PGxpbmVhckdyYWRpZW50IGlkPSJkIiB4MT0iMCUiIHkxPSIwJSIgeDI9IjAlIiB5Mj0iMTAwJSI+PHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iI0ZBREFERCIvPjxzdG9wIG9mZnNldD0iNTAlIiBzdG9wLWNvbG9yPSIjRkZGOEYwIi8+PHN0b3Agb2Zmc2V0PSIxMDAlIiBzdG9wLWNvbG9yPSIjRkFEQUREIi8+PC9saW5lYXJHcmFkaWVudD48L2RlZnM+PHJlY3Qgd2lkdGg9IjMwMCIgaGVpZ2h0PSIyMDAiIGZpbGw9InVybCgjZCkiLz48cGF0aCBkPSJNMTAwIDEwMEM5MCA5MCA5MCA3MCA5MCA1MEM5MCA1MCA5MCA1MCA5MCA1MEMxMTAgNTAgMTMwIDcwIDEzMCA3MEMxNTAgNzAgMTcwIDUwIDE3MCA1MEMxNzAgNTAgMTcwIDUwIDE3MCA1MEMxNzAgNTAgMTkwIDUwIDIxMCA1MEMyMTAgNzAgMjEwIDkwIDIwMCAxMDBDMTgwIDEwMCAxNjAgOTAgMTQwIDkwQzEyMCA5MCAxMDAgMTAwIDEwMCAxMDBaIiBmaWxsPSIjRDRBRjM3IiBvcGFjaXR5PSIwLjciLz48dGV4dCB4PSIxNTAiIHk9IjE1MCIgZm9udC1mYW1pbHk9IkFyaWFsLCBzYW5zLXNlcmlmIiBmb250LXNpemU9IjEzIiBmaWxsPSIjRDRBRjM3IiB0ZXh0LWFuY2hvcj0ibWlkZGxlIj5NYXNzYWdlPC90ZXh0Pjwvc3ZnPg==',
            'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAwIiBoZWlnaHQ9IjIwMCIgdmlld0JveD0iMCAwIDMwMCAyMDAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGRlZnM+PGxpbmVhckdyYWRpZW50IGlkPSJlIiB4MT0iNDUlIiB5MT0iMCUiIHgyPSI1NSUiIHkyPSIxMDAlIj48c3RvcCBvZmZzZXQ9IjAlIiBzdG9wLWNvbG9yPSIjRkZGOEYwIi8+PHN0b3Agb2Zmc2V0PSI1MCUiIHN0b3AtY29sb3I9IiNGQURBREQiLz48c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiNGRkY4RjAiLz48L2xpbmVhckdyYWRpZW50PjwvZGVmcz48cmVjdCB3aWR0aD0iMzAwIiBoZWlnaHQ9IjIwMCIgZmlsbD0idXJsKCNlKSIvPjxyZWN0IHg9IjEyMCIgeT0iNzAiIHdpZHRoPSI2MCIgaGVpZ2h0PSI2MCIgcng9IjMwIiBmaWxsPSIjRDRBRjM3IiBvcGFjaXR5PSIwLjgiLz48Y2lyY2xlIGN4PSIxMzUiIGN5PSI4NSIgcj0iNSIgZmlsbD0iI0ZGRkZGRiIvPjxjaXJjbGUgY3g9IjE2NSIgY3k9Ijg1IiByPSI1IiBmaWxsPSIjRkZGRkZGIi8+PHBhdGggZD0iTTEzNSAxMDBIMTY1IiBzdHJva2U9IiNGRkZGRkYiIHN0cm9rZS13aWR0aD0iMyIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIi8+PHRleHQgeD0iMTUwIiB5PSIxNjAiIGZvbnQtZmFtaWx5PSJBcmlhbCwgc2Fucy1zZXJpZiIgZm9udC1zaXplPSIxMyIgZmlsbD0iI0Q0QUYzNyIgdGV4dC1hbmNob3I9Im1pZGRsZSI+Qm9keSBDYXJlPC90ZXh0Pjwvc3ZnPg=='
        ];
        
        this.init();
    }

    async init() {
        try {
            console.log('🚀 ServicesManager initializing...');
            
            // Initialize Lucide icons
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }

            // Load price range first
            console.log('💰 Loading price range...');
            await this.loadPriceRange();
            console.log('✅ Price range loaded:', this.priceRange);
            
            // Load service types
            console.log('🏷️ Loading service types...');
            await this.loadServiceTypes();
            console.log('✅ Service types loaded:', this.serviceTypes.length, 'types');
            
            // Setup UI components
            console.log('🎚️ Setting up UI components...');
            this.setupPriceRangeSlider();
            
            // Small delay to ensure DOM is ready
            setTimeout(() => {
                this.setupEventListeners();
                console.log('🎮 Event listeners attached');
            }, 100);
            
            // Load initial services
            console.log('📋 Loading initial services...');
            await this.loadServices();
            
            console.log('✅ ServicesManager initialization complete!');
        } catch (error) {
            console.error('💥 Error initializing services page:', error);
            this.showError('Lỗi khi tải trang dịch vụ');
        }
    }

    async loadPriceRange() {
        try {
            const response = await fetch('/spa/api/services?action=price-range');
            const data = await response.json();
            
            if (data.success) {
                this.priceRange.min = data.minPrice;
                this.priceRange.max = data.maxPrice;
                this.currentFilters.minPrice = data.minPrice;
                this.currentFilters.maxPrice = data.maxPrice;
            }
        } catch (error) {
            console.error('Error loading price range:', error);
        }
    }

    async loadServiceTypes() {
        try {
            const response = await fetch('/spa/api/service-types');
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
        if (this.isLoading) {
            console.log('⏳ Already loading services, skipping...');
            return;
        }
        
        try {
            this.isLoading = true;
            this.showLoadingState();
            
            console.log('🔍 Building API parameters...');
            const params = new URLSearchParams({
                page: this.currentPage,
                size: this.pageSize
            });

            // Add filters to params with detailed logging
            if (this.currentFilters.searchQuery) {
                params.append('name', this.currentFilters.searchQuery);
                console.log('📝 Added search query:', this.currentFilters.searchQuery);
            }
            if (this.currentFilters.category && this.currentFilters.category !== 'all') {
                // Format category as "type-{id}" to match backend expectation
                const categoryParam = `type-${this.currentFilters.category}`;
                params.append('category', categoryParam);
                console.log('🏷️ Added category filter:', categoryParam);
            }
            if (this.currentFilters.minPrice !== null && this.currentFilters.minPrice !== this.priceRange.min) {
                params.append('minPrice', this.currentFilters.minPrice);
                console.log('💰 Added min price:', this.currentFilters.minPrice);
            }
            if (this.currentFilters.maxPrice !== null && this.currentFilters.maxPrice !== this.priceRange.max) {
                params.append('maxPrice', this.currentFilters.maxPrice);
                console.log('💰 Added max price:', this.currentFilters.maxPrice);
            }
            if (this.currentFilters.order && this.currentFilters.order !== 'default') {
                params.append('order', this.currentFilters.order);
                console.log('🔀 Added order:', this.currentFilters.order);
            }

            const apiUrl = `/spa/api/services?${params}`;
            console.log('🌐 API URL:', apiUrl);
            console.log('📊 Full current filters:', JSON.stringify(this.currentFilters, null, 2));

            const response = await fetch(apiUrl);
            console.log('📡 API Response status:', response.status);
            
            const data = await response.json();
            console.log('📦 API Response data:', data);
            
            if (data.success) {
                console.log('✅ API Success! Services count:', data.services.length);
                console.log('📋 Services data:', data.services);
                
                this.renderServices(data.services);
                this.renderPagination(data.pagination);
                this.updateResultsCount(data.pagination.totalCount);
            } else {
                console.error('❌ API Error:', data.error);
                this.showError(data.error || 'Lỗi khi tải dịch vụ');
            }
        } catch (error) {
            console.error('💥 Exception in loadServices:', error);
            this.showError('Lỗi khi tải dịch vụ');
        } finally {
            this.isLoading = false;
            this.hideLoadingState();
            console.log('🏁 loadServices completed');
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

        // Add smooth transition
        container.style.opacity = '0.5';
        
        setTimeout(() => {
            container.innerHTML = services.map(service => this.createServiceCard(service)).join('');
            container.style.opacity = '1';
            
            // Reinitialize icons
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }
        }, 100);
    }

    createServiceCard(service) {
        const formattedPrice = new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(service.price);

        const rating = service.averageRating || 0;
        const featured = service.averageRating >= 4.5;
        
        // Get random beauty image for each service
        const randomImageIndex = Math.abs(service.serviceId * 7) % this.beautyImages.length;
        const beautyImage = this.beautyImages[randomImageIndex];

        return `
            <div class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1">
                ${featured ? `
                <div class="bg-primary text-white text-xs font-semibold px-3 py-1 absolute z-10 rounded-br-lg">
                    Nổi bật
                </div>` : ''}
                <div class="relative">
                    <img 
                        src="${beautyImage}" 
                        alt="${service.name}" 
                        class="w-full h-48 object-cover" 
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
                        <span class="text-xs text-primary font-medium bg-secondary px-2 py-1 rounded-full">${this.getServiceTypeName(service.serviceTypeId.serviceTypeId) || 'Dịch vụ'}</span>
                    </div>
                    <h3 class="text-lg font-semibold text-spa-dark mb-2 truncate">${service.name}</h3>
                    <p class="text-gray-600 text-sm mb-4 h-12 overflow-hidden">${service.description || ''}</p>
                    <div class="flex items-center justify-between mb-4">
                        <div class="flex items-center text-gray-500">
                            <i data-lucide="clock" class="h-4 w-4 mr-1"></i>
                            <span class="text-sm">${service.durationMinutes} phút</span>
                        </div>
                        <div class="text-xl font-bold text-primary">${formattedPrice}</div>
                    </div>
                    <div class="grid grid-cols-2 gap-2">
                        <button class="view-details-btn w-full bg-secondary text-spa-dark py-2.5 px-3 rounded-full hover:bg-primary hover:text-white transition-all duration-300 font-medium text-sm flex items-center justify-center" data-id="${service.serviceId}" onclick="servicesManager.viewServiceDetails(${service.serviceId})">
                            Xem chi tiết
                        </button>
                        <button class="add-to-cart-btn w-full bg-primary text-white py-2.5 px-3 rounded-full hover:bg-primary-dark transition-all duration-300 font-medium text-sm flex items-center justify-center" data-id="${service.serviceId}" onclick='servicesManager.addToCart(${JSON.stringify(service)})'>
                            Thêm vào giỏ
                        </button>
                    </div>
                </div>
            </div>
        `;
    }

    renderPagination(pagination) {
        const container = document.getElementById('pagination');
        if (!container) return;

        if (pagination.totalPages <= 1) {
            container.innerHTML = '';
            return;
        }

        let paginationHTML = '';

        // Previous button
        if (pagination.hasPrevious) {
            paginationHTML += `
                <button onclick="servicesManager.goToPage(${pagination.currentPage - 1})" 
                        class="px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-l-md hover:bg-gray-50 transition-colors">
                    Trước
                </button>
            `;
        }

        // Page numbers
        const startPage = Math.max(1, pagination.currentPage - 2);
        const endPage = Math.min(pagination.totalPages, pagination.currentPage + 2);

        if (startPage > 1) {
            paginationHTML += `
                <button onclick="servicesManager.goToPage(1)" 
                        class="px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 hover:bg-gray-50 transition-colors">
                    1
                </button>
            `;
            if (startPage > 2) {
                paginationHTML += `<span class="px-3 py-2 text-sm text-gray-500">...</span>`;
            }
        }

        for (let i = startPage; i <= endPage; i++) {
            const isActive = i === pagination.currentPage;
            paginationHTML += `
                <button onclick="servicesManager.goToPage(${i})" 
                        class="px-3 py-2 text-sm font-medium ${isActive 
                            ? 'text-white bg-primary border-primary' 
                            : 'text-gray-700 bg-white border-gray-300 hover:bg-gray-50'} 
                        border transition-colors">
                    ${i}
                </button>
            `;
        }

        if (endPage < pagination.totalPages) {
            if (endPage < pagination.totalPages - 1) {
                paginationHTML += `<span class="px-3 py-2 text-sm text-gray-500">...</span>`;
            }
            paginationHTML += `
                <button onclick="servicesManager.goToPage(${pagination.totalPages})" 
                        class="px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 hover:bg-gray-50 transition-colors">
                    ${pagination.totalPages}
                </button>
            `;
        }

        // Next button
        if (pagination.hasNext) {
            paginationHTML += `
                <button onclick="servicesManager.goToPage(${pagination.currentPage + 1})" 
                        class="px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-r-md hover:bg-gray-50 transition-colors">
                    Sau
                </button>
            `;
        }

        container.innerHTML = `<div class="inline-flex -space-x-px">${paginationHTML}</div>`;
    }

    updateServiceTypeFilters() {
        console.log('🔄 Updating service type filters...');
        console.log('📋 Available service types:', this.serviceTypes);
        
        // Update desktop dropdown
        const desktopSelect = document.getElementById('service-type-select');
        if (desktopSelect) {
            console.log('✅ Desktop dropdown found, populating options...');
            // Clear existing options (except "All services")
            desktopSelect.innerHTML = '<option value="all">Tất cả dịch vụ</option>';
            
            // Add service type options
            this.serviceTypes.forEach(type => {
                const option = document.createElement('option');
                option.value = type.serviceTypeId;
                option.textContent = type.name;
                desktopSelect.appendChild(option);
                console.log('➕ Added option:', type.name, 'with ID:', type.serviceTypeId);
            });
            console.log('✅ Desktop dropdown populated with', this.serviceTypes.length, 'options');
        } else {
            console.error('❌ Desktop service type select NOT found!');
        }

        // Update mobile dropdown
        const mobileSelect = document.getElementById('mobile-service-type-select');
        if (mobileSelect) {
            console.log('✅ Mobile dropdown found, populating options...');
            // Clear existing options (except "All services")
            mobileSelect.innerHTML = '<option value="all">Tất cả dịch vụ</option>';
            
            // Add service type options
            this.serviceTypes.forEach(type => {
                const option = document.createElement('option');
                option.value = type.serviceTypeId;
                option.textContent = type.name;
                mobileSelect.appendChild(option);
            });
            console.log('✅ Mobile dropdown populated with', this.serviceTypes.length, 'options');
        } else {
            console.error('❌ Mobile service type select NOT found!');
        }
    }

    setupPriceRangeSlider() {
        // Remove existing price section and apply button if they exist
        const existingPriceSection = document.querySelector('[data-price-section]');
        if (existingPriceSection) {
            existingPriceSection.remove();
        }

        // Remove the "Áp dụng" button from the existing custom price section
        const applyButton = document.getElementById('apply-price-filter');
        if (applyButton) {
            applyButton.remove();
        }

        // Create double range slider
        const sidebar = document.querySelector('#filters-sidebar .bg-white');
        const priceHTML = `
            <div class="mb-6" data-price-section>
                <h4 class="font-medium text-spa-dark mb-4">Khoảng giá</h4>
                
                <!-- Price display with better formatting -->
                <div class="flex justify-between items-center mb-4 p-3 bg-gray-50 rounded-lg">
                    <div class="text-center">
                        <div class="text-xs text-gray-500 mb-1">Từ</div>
                        <span class="text-sm font-medium text-primary" id="min-price-display">${this.formatPriceShort(this.priceRange.min)}</span>
                    </div>
                    <div class="text-gray-400">-</div>
                    <div class="text-center">
                        <div class="text-xs text-gray-500 mb-1">Đến</div>
                        <span class="text-sm font-medium text-primary" id="max-price-display">${this.formatPriceShort(this.priceRange.max)}</span>
                    </div>
                </div>
                
                <!-- Enhanced Double range slider -->
                <div class="relative mb-6 px-2">
                    <div class="relative h-6">
                        <!-- Background track -->
                        <div class="absolute top-2 w-full h-2 bg-gray-200 rounded-lg"></div>
                        <!-- Active track -->
                        <div id="slider-track" class="absolute top-2 h-2 bg-primary rounded-lg"></div>
                        <!-- Min slider -->
                        <input type="range" 
                               id="min-price-range" 
                               min="${this.priceRange.min}" 
                               max="${this.priceRange.max}" 
                               value="${this.currentFilters.minPrice}" 
                               step="100000"
                               class="absolute w-full h-6 appearance-none cursor-pointer slider-input"
                               style="background: transparent; z-index: 2;">
                        <!-- Max slider -->
                        <input type="range" 
                               id="max-price-range" 
                               min="${this.priceRange.min}" 
                               max="${this.priceRange.max}" 
                               value="${this.currentFilters.maxPrice}" 
                               step="100000"
                               class="absolute w-full h-6 appearance-none cursor-pointer slider-input"
                               style="background: transparent; z-index: 1;">
                    </div>
                </div>
                
                <!-- Manual price inputs with better styling -->
                <div class="grid grid-cols-2 gap-3">
                    <div>
                        <label class="block text-xs text-gray-600 mb-1 font-medium">Giá tối thiểu</label>
                        <div class="relative">
                            <input type="number" 
                                   id="min-price-input" 
                                   placeholder="100,000" 
                                   class="w-full pl-3 pr-8 py-2 border border-gray-300 rounded-md text-sm focus:ring-2 focus:ring-primary focus:border-transparent"
                                   min="${this.priceRange.min}"
                                   max="${this.priceRange.max}"
                                   value="${this.currentFilters.minPrice}">
                            <span class="absolute right-2 top-2 text-xs text-gray-500">đ</span>
                        </div>
                    </div>
                    <div>
                        <label class="block text-xs text-gray-600 mb-1 font-medium">Giá tối đa</label>
                        <div class="relative">
                            <input type="number" 
                                   id="max-price-input" 
                                   placeholder="15,000,000" 
                                   class="w-full pl-3 pr-8 py-2 border border-gray-300 rounded-md text-sm focus:ring-2 focus:ring-primary focus:border-transparent"
                                   min="${this.priceRange.min}"
                                   max="${this.priceRange.max}"
                                   value="${this.currentFilters.maxPrice}">
                            <span class="absolute right-2 top-2 text-xs text-gray-500">đ</span>
                        </div>
                    </div>
                </div>
            </div>
        `;
        
        if (sidebar) {
            sidebar.insertAdjacentHTML('beforeend', priceHTML);
            this.addSliderStyles();
            this.initializeRangeSlider();
        }
    }

    addSliderStyles() {
        // Add enhanced CSS for slider styling
        if (!document.getElementById('slider-styles')) {
            const style = document.createElement('style');
            style.id = 'slider-styles';
            style.textContent = `
                .slider-input::-webkit-slider-thumb {
                    appearance: none;
                    height: 22px;
                    width: 22px;
                    border-radius: 50%;
                    background: #D4AF37;
                    cursor: pointer;
                    box-shadow: 0 3px 6px rgba(0,0,0,0.2);
                    border: 3px solid white;
                    position: relative;
                    z-index: 3;
                }
                
                .slider-input::-moz-range-thumb {
                    height: 22px;
                    width: 22px;
                    border-radius: 50%;
                    background: #D4AF37;
                    cursor: pointer;
                    border: 3px solid white;
                    box-shadow: 0 3px 6px rgba(0,0,0,0.2);
                    z-index: 3;
                }

                .slider-input:focus::-webkit-slider-thumb {
                    box-shadow: 0 3px 6px rgba(0,0,0,0.3), 0 0 0 3px rgba(212, 175, 55, 0.3);
                }

                .slider-input:hover::-webkit-slider-thumb {
                    background: #B8941F;
                }

                .slider-input {
                    pointer-events: auto;
                }

                .slider-input:focus {
                    outline: none;
                }
            `;
            document.head.appendChild(style);
        }
    }

    initializeRangeSlider() {
        const minSlider = document.getElementById('min-price-range');
        const maxSlider = document.getElementById('max-price-range');
        const minInput = document.getElementById('min-price-input');
        const maxInput = document.getElementById('max-price-input');
        const minDisplay = document.getElementById('min-price-display');
        const maxDisplay = document.getElementById('max-price-display');
        const track = document.getElementById('slider-track');

        if (!minSlider || !maxSlider) return;
        
        let sliderTimeout;

        const updateTrack = () => {
            const min = parseInt(minSlider.value);
            const max = parseInt(maxSlider.value);
            const range = this.priceRange.max - this.priceRange.min;
            
            const minPercent = ((min - this.priceRange.min) / range) * 100;
            const maxPercent = ((max - this.priceRange.min) / range) * 100;
            
            track.style.left = minPercent + '%';
            track.style.width = (maxPercent - minPercent) + '%';
        };

        const updateValues = (minVal, maxVal) => {
            // Ensure min is not greater than max
            if (minVal > maxVal) {
                [minVal, maxVal] = [maxVal, minVal];
            }

            this.currentFilters.minPrice = minVal;
            this.currentFilters.maxPrice = maxVal;

            minSlider.value = minVal;
            maxSlider.value = maxVal;
            minInput.value = minVal;
            maxInput.value = maxVal;
            minDisplay.textContent = this.formatPriceShort(minVal);
            maxDisplay.textContent = this.formatPriceShort(maxVal);

            updateTrack();

            // Apply filter with debounce
            clearTimeout(sliderTimeout);
            sliderTimeout = setTimeout(() => {
                this.currentPage = 1;
                this.loadServices();
            }, 500); // 500ms debounce
        };

        // Slider events with logging
        minSlider.addEventListener('input', () => {
            console.log('🎚️ Min slider moved to:', minSlider.value);
            updateValues(parseInt(minSlider.value), parseInt(maxSlider.value));
        });

        maxSlider.addEventListener('input', () => {
            console.log('🎚️ Max slider moved to:', maxSlider.value);
            // Ensure min slider value is not greater than max slider
            if (parseInt(minSlider.value) > parseInt(maxSlider.value)) {
                maxSlider.value = minSlider.value;
            }
            updateValues(parseInt(minSlider.value), parseInt(maxSlider.value));
        });

        // Input events
        minInput.addEventListener('change', () => {
            const val = parseInt(minInput.value) || this.priceRange.min;
            updateValues(
                Math.max(this.priceRange.min, Math.min(val, this.priceRange.max)),
                parseInt(maxSlider.value)
            );
        });

        maxInput.addEventListener('change', () => {
            const val = parseInt(maxInput.value) || this.priceRange.max;
            updateValues(
                parseInt(minSlider.value),
                Math.max(this.priceRange.min, Math.min(val, this.priceRange.max))
            );
        });

        // Initial track update
        updateTrack();
    }

    setupEventListeners() {
        // Search input with debounce
        const searchInput = document.getElementById('search-input');
        if (searchInput) {
            let searchTimeout;
            searchInput.addEventListener('input', (e) => {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    this.currentFilters.searchQuery = e.target.value.trim();
                    this.currentPage = 1;
                    this.loadServices();
                }, 300); // Reduced delay for better responsiveness
            });
        }

        // Sort dropdown - immediate change
        const sortSelect = document.getElementById('sort-select');
        if (sortSelect) {
            sortSelect.addEventListener('change', (e) => {
                this.currentFilters.order = e.target.value;
                this.currentPage = 1;
                this.loadServices();
            });
        }

        // Service type dropdowns - immediate change with debug logging
        const serviceTypeSelect = document.getElementById('service-type-select');
        if (serviceTypeSelect) {
            console.log('✅ Desktop service type dropdown found');
            serviceTypeSelect.addEventListener('change', (e) => {
                console.log('🔄 Desktop dropdown changed to:', e.target.value);
                console.log('📊 Current filters before change:', JSON.stringify(this.currentFilters));
                
                this.currentFilters.category = e.target.value;
                this.currentPage = 1;
                
                console.log('📊 Current filters after change:', JSON.stringify(this.currentFilters));
                console.log('🚀 Loading services with new filter...');
                
                this.loadServices();
                
                // Sync mobile dropdown
                const mobileSelect = document.getElementById('mobile-service-type-select');
                if (mobileSelect) {
                    mobileSelect.value = e.target.value;
                    console.log('🔄 Mobile dropdown synced to:', e.target.value);
                }
            });
        } else {
            console.error('❌ Desktop service type dropdown NOT found');
        }

        const mobileServiceTypeSelect = document.getElementById('mobile-service-type-select');
        if (mobileServiceTypeSelect) {
            console.log('✅ Mobile service type dropdown found');
            mobileServiceTypeSelect.addEventListener('change', (e) => {
                console.log('🔄 Mobile dropdown changed to:', e.target.value);
                console.log('📊 Current filters before change:', JSON.stringify(this.currentFilters));
                
                this.currentFilters.category = e.target.value;
                this.currentPage = 1;
                
                console.log('📊 Current filters after change:', JSON.stringify(this.currentFilters));
                console.log('🚀 Loading services with new filter...');
                
                this.loadServices();
                
                // Sync desktop dropdown
                const desktopSelect = document.getElementById('service-type-select');
                if (desktopSelect) {
                    desktopSelect.value = e.target.value;
                    console.log('🔄 Desktop dropdown synced to:', e.target.value);
                }
            });
        } else {
            console.error('❌ Mobile service type dropdown NOT found');
        }

        // Remove old price range radio buttons
        document.addEventListener('change', (e) => {
            if (e.target.name === 'price-range') {
                e.target.checked = false; // Disable old radio buttons
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

        // Close modal when clicking outside
        if (mobileFilterModal) {
            mobileFilterModal.addEventListener('click', (e) => {
                if (e.target === mobileFilterModal) {
                    mobileFilterModal.classList.remove('active');
                }
            });
        }

        if (clearMobileFilters) {
            clearMobileFilters.addEventListener('click', () => {
                this.clearMobileFilters();
            });
        }
    }

    getServiceTypeName(serviceTypeId) {
        if (!serviceTypeId) return 'Dịch vụ';
        const serviceType = this.serviceTypes.find(type => type.serviceTypeId == serviceTypeId);
        return serviceType ? serviceType.name : 'Dịch vụ';
    }

    clearAllFilters() {
        // Reset filters to defaults
        this.currentFilters = {
            searchQuery: '',
            category: 'all',
            minPrice: this.priceRange.min,
            maxPrice: this.priceRange.max,
            order: 'default'
        };

        // Clear UI elements
        const searchInput = document.getElementById('search-input');
        if (searchInput) searchInput.value = '';

        const sortSelect = document.getElementById('sort-select');
        if (sortSelect) sortSelect.value = 'default';

        // Reset service type dropdowns
        const serviceTypeSelect = document.getElementById('service-type-select');
        if (serviceTypeSelect) serviceTypeSelect.value = 'all';
        
        const mobileServiceTypeSelect = document.getElementById('mobile-service-type-select');
        if (mobileServiceTypeSelect) mobileServiceTypeSelect.value = 'all';

        // Reset price sliders and inputs
        const minSlider = document.getElementById('min-price-range');
        const maxSlider = document.getElementById('max-price-range');
        const minInput = document.getElementById('min-price-input');
        const maxInput = document.getElementById('max-price-input');
        const minDisplay = document.getElementById('min-price-display');
        const maxDisplay = document.getElementById('max-price-display');

        if (minSlider) minSlider.value = this.priceRange.min;
        if (maxSlider) maxSlider.value = this.priceRange.max;
        if (minInput) minInput.value = this.priceRange.min;
        if (maxInput) maxInput.value = this.priceRange.max;
        if (minDisplay) minDisplay.textContent = this.formatPrice(this.priceRange.min);
        if (maxDisplay) maxDisplay.textContent = this.formatPrice(this.priceRange.max);

        // Update slider track
        const track = document.getElementById('slider-track');
        if (track) {
            track.style.left = '0%';
            track.style.width = '100%';
        }

        this.currentPage = 1;
        this.loadServices();
    }

    clearMobileFilters() {
        // Reset mobile service type dropdown
        const mobileServiceTypeSelect = document.getElementById('mobile-service-type-select');
        if (mobileServiceTypeSelect) {
            mobileServiceTypeSelect.value = 'all';
        }
        
        // Reset desktop service type dropdown to sync
        const serviceTypeSelect = document.getElementById('service-type-select');
        if (serviceTypeSelect) {
            serviceTypeSelect.value = 'all';
        }
        
        // Reset category filter and reload
        this.currentFilters.category = 'all';
        this.currentPage = 1;
        this.loadServices();
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
        console.log('View service details:', serviceId);
        alert(`Xem chi tiết dịch vụ ID: ${serviceId}`);
    }

    addToCart(service) {
        const serviceData = {
            serviceId: service.serviceId,
            serviceName: service.name,
            serviceImage: service.imageUrl || this.beautyImages[Math.abs(service.serviceId * 7) % this.beautyImages.length],
            servicePrice: service.price,
            serviceDuration: service.durationMinutes
        };

        // Integration with existing cart functionality
        if (typeof addToCart === 'function') {
            addToCart(serviceData);
        } else {
            console.error('Global addToCart function not found!');
            alert(`Thêm dịch vụ ID: ${service.serviceId} vào giỏ hàng (Lỗi)`);
        }
    }

    showLoadingState() {
        const container = document.getElementById('services-grid');
        if (container) {
            container.style.opacity = '0.6';
            container.style.pointerEvents = 'none';
        }
    }

    hideLoadingState() {
        const container = document.getElementById('services-grid');
        if (container) {
            container.style.opacity = '1';
            container.style.pointerEvents = 'auto';
        }
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

    formatPrice(price) {
        // Format price without currency symbol for better display
        return new Intl.NumberFormat('vi-VN').format(price) + 'đ';
    }

    formatPriceShort(price) {
        // Short format for slider display
        if (price >= 1000000) {
            return (price / 1000000).toFixed(1) + 'M đ';
        } else if (price >= 1000) {
            return (price / 1000).toFixed(0) + 'K đ';
        }
        return price + 'đ';
    }
}

// Initialize the services manager when the page loads
let servicesManager;
document.addEventListener('DOMContentLoaded', () => {
    servicesManager = new ServicesManager();
});

// Add CSS for the enhanced components
const enhancedCSS = `
/* Modal styles */
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

/* Double range slider styles */
.slider-min, .slider-max {
    pointer-events: none;
}

.slider-min::-webkit-slider-thumb, .slider-max::-webkit-slider-thumb {
    pointer-events: all;
    appearance: none;
    width: 20px;
    height: 20px;
    border-radius: 50%;
    background: #D4AF37;
    cursor: pointer;
    border: 2px solid #fff;
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
}

.slider-min::-moz-range-thumb, .slider-max::-moz-range-thumb {
    pointer-events: all;
    appearance: none;
    width: 20px;
    height: 20px;
    border-radius: 50%;
    background: #D4AF37;
    cursor: pointer;
    border: 2px solid #fff;
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
}

/* Loading and transition effects */
.transition-opacity {
    transition: opacity 0.3s ease-in-out;
}

/* Service card hover effects */
.service-card-container {
    transition: all 0.3s ease;
}

.service-card-container:hover {
    transform: translateY(-4px);
    box-shadow: 0 10px 25px rgba(0,0,0,0.1);
}

/* Utility classes */
.line-clamp-2 {
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

/* Improved button styles */
.btn-primary {
    background: linear-gradient(135deg, #D4AF37 0%, #B8941F 100%);
    transition: all 0.3s ease;
}

.btn-primary:hover {
    background: linear-gradient(135deg, #B8941F 0%, #A17D1A 100%);
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(212, 175, 55, 0.3);
}

/* Responsive improvements */
@media (max-width: 768px) {
    .slider-min::-webkit-slider-thumb, .slider-max::-webkit-slider-thumb {
        width: 24px;
        height: 24px;
    }
}
`;

// Add CSS to head
const style = document.createElement('style');
style.textContent = enhancedCSS;
document.head.appendChild(style); 