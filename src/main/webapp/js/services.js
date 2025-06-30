// js/services.js

class ServicesPage {
    constructor() {
        this.allServices = [];
        this.filteredServices = [];
        this.currentPage = 1;
        this.itemsPerPage = 9;

        this.init();
    }

    async init() {
        this.initDOM();
        await this.loadServices();
        this.initEventListeners();
        this.renderServices();
    }

    initDOM() {
        this.servicesGrid = document.getElementById('services-grid');
        this.paginationContainer = document.getElementById('pagination');
        this.resultsCount = document.getElementById('results-count');
        this.searchInput = document.getElementById('search-input');
        this.sortSelect = document.getElementById('sort-select');
        this.clearFiltersBtn = document.getElementById('clear-filters');
        
        // Service Detail Modal
        this.modal = document.getElementById('service-modal');
        this.modalTitle = document.getElementById('modal-title');
        this.modalBody = document.getElementById('modal-body');
        this.closeModalBtn = document.getElementById('close-modal');

        // Mobile Filters
        this.mobileFilterBtn = document.getElementById('mobile-filter-btn');
        this.mobileFilterModal = document.getElementById('mobile-filter-modal');
        this.closeMobileFilterBtn = document.getElementById('close-mobile-filter');
        this.applyMobileFiltersBtn = document.getElementById('apply-mobile-filters');
        this.clearMobileFiltersBtn = document.getElementById('clear-mobile-filters');
        
        // Filter inputs
        this.categoryFilters = document.querySelectorAll('.category-filter');
        this.priceRangeFilters = document.querySelectorAll('input[name="price-range"]');
        this.durationFilters = document.querySelectorAll('.duration-filter');
        this.mobileCategoryFilters = document.querySelectorAll('.mobile-category-filter');
    }

    async loadServices() {
        // In a real app, this would be an API call.
        // For this conversion, we'll use the static data from the React component.
        this.allServices = this.getStaticServices();
        this.filteredServices = [...this.allServices];
    }

    initEventListeners() {
        this.searchInput.addEventListener('input', SpaApp.debounce(() => this.applyFiltersAndSort(), 300));
        this.sortSelect.addEventListener('change', () => this.applyFiltersAndSort());
        this.clearFiltersBtn.addEventListener('click', () => this.clearFilters());

        this.categoryFilters.forEach(f => f.addEventListener('change', () => this.applyFiltersAndSort()));
        this.priceRangeFilters.forEach(f => f.addEventListener('change', () => this.applyFiltersAndSort()));
        this.durationFilters.forEach(f => f.addEventListener('change', () => this.applyFiltersAndSort()));

        // Modal listeners
        this.closeModalBtn.addEventListener('click', () => this.closeModal());
        this.modal.addEventListener('click', (e) => {
            if (e.target === this.modal) {
                this.closeModal();
            }
        });

        // Mobile filter listeners
        this.mobileFilterBtn.addEventListener('click', () => this.mobileFilterModal.classList.add('active'));
        this.closeMobileFilterBtn.addEventListener('click', () => this.mobileFilterModal.classList.remove('active'));
        this.applyMobileFiltersBtn.addEventListener('click', () => {
            this.syncAndApplyMobileFilters();
            this.mobileFilterModal.classList.remove('active');
        });
        this.clearMobileFiltersBtn.addEventListener('click', () => {
            this.clearFilters();
            this.mobileFilterModal.classList.remove('active');
        });
    }

    syncAndApplyMobileFilters() {
        // Sync mobile filters to main filters before applying
        this.mobileCategoryFilters.forEach(mobileFilter => {
            const mainFilter = document.querySelector(`.category-filter[value="${mobileFilter.value}"]`);
            if (mainFilter) {
                mainFilter.checked = mobileFilter.checked;
            }
        });
        this.applyFiltersAndSort();
    }
    
    clearFilters() {
        this.searchInput.value = '';
        this.categoryFilters.forEach(f => f.checked = false);
        this.priceRangeFilters.forEach(f => f.checked = false);
        this.durationFilters.forEach(f => f.checked = false);
        this.mobileCategoryFilters.forEach(f => f.checked = false);
        this.sortSelect.value = 'default';
        this.applyFiltersAndSort();
    }

    applyFiltersAndSort() {
        let services = [...this.allServices];

        // Search filter
        const searchTerm = this.searchInput.value.toLowerCase();
        if (searchTerm) {
            services = services.filter(s => 
                s.name.toLowerCase().includes(searchTerm) || 
                s.description.toLowerCase().includes(searchTerm) ||
                s.tags.some(t => t.toLowerCase().includes(searchTerm))
            );
        }

        // Category filter
        const selectedCategories = Array.from(this.categoryFilters)
            .filter(f => f.checked)
            .map(f => f.value);

        if (selectedCategories.length > 0) {
            services = services.filter(s => selectedCategories.includes(s.category));
        }

        // Price filter
        const selectedPriceRange = document.querySelector('input[name="price-range"]:checked');
        if (selectedPriceRange) {
            const [min, max] = selectedPriceRange.value.split('-').map(Number);
            services = services.filter(s => {
                const price = parseInt(s.price.replace(/\D/g, ''));
                if (max) {
                    return price >= min * 1000 && price <= max * 1000;
                }
                return price >= min * 1000;
            });
        }
        
        // Duration filter
        const selectedDurations = Array.from(this.durationFilters)
            .filter(f => f.checked)
            .map(f => f.value);

        if (selectedDurations.length > 0) {
            services = services.filter(s => {
                const duration = parseInt(s.duration);
                return selectedDurations.some(range => {
                    const [min, max] = range.split('-').map(Number);
                    if (max) return duration >= min && duration <= max;
                    return duration >= min;
                });
            });
        }

        // Sorting
        const sortValue = this.sortSelect.value;
        switch (sortValue) {
            case 'name-asc':
                services.sort((a, b) => a.name.localeCompare(b.name, 'vi'));
                break;
            case 'name-desc':
                services.sort((a, b) => b.name.localeCompare(a.name, 'vi'));
                break;
            case 'price-asc':
                services.sort((a, b) => parseInt(a.price.replace(/\D/g, '')) - parseInt(b.price.replace(/\D/g, '')));
                break;
            case 'price-desc':
                services.sort((a, b) => parseInt(b.price.replace(/\D/g, '')) - parseInt(a.price.replace(/\D/g, '')));
                break;
            case 'rating-desc':
                services.sort((a, b) => b.rating - a.rating);
                break;
        }

        this.filteredServices = services;
        this.currentPage = 1;
        this.renderServices();
    }

    renderServices() {
        this.servicesGrid.innerHTML = '';
        this.resultsCount.textContent = `Hiển thị ${this.filteredServices.length} kết quả`;

        if (this.filteredServices.length === 0) {
            this.servicesGrid.innerHTML = `<p class="text-gray-600 col-span-full text-center">Không tìm thấy dịch vụ phù hợp.</p>`;
            this.renderPagination();
            return;
        }

        const startIndex = (this.currentPage - 1) * this.itemsPerPage;
        const endIndex = startIndex + this.itemsPerPage;
        const pageServices = this.filteredServices.slice(startIndex, endIndex);

        pageServices.forEach(service => {
            const card = this.createServiceCard(service);
            this.servicesGrid.appendChild(card);
        });
        
        this.renderPagination();
        lucide.createIcons(); // Re-initialize icons
    }
    
    createServiceCard(service) {
        const div = document.createElement('div');
        div.className = 'bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1';
        div.innerHTML = `
            ${service.featured ? `
            <div class="bg-primary text-white text-xs font-semibold px-3 py-1 absolute z-10 rounded-br-lg">
                Nổi bật
            </div>` : ''}
            <div class="relative">
                <img src="${service.image}" alt="${service.name}" class="w-full h-48 object-cover" loading="lazy">
                <div class="absolute top-3 right-3 bg-white/90 px-2 py-1 rounded-full">
                    <div class="flex items-center">
                        <i data-lucide="star" class="h-3 w-3 text-primary fill-current mr-1"></i>
                        <span class="text-xs font-medium">${service.rating}</span>
                    </div>
                </div>
            </div>
            <div class="p-5">
                <div class="mb-2">
                    <span class="text-xs text-primary font-medium bg-secondary px-2 py-1 rounded-full">${service.category}</span>
                </div>
                <h3 class="text-lg font-semibold text-spa-dark mb-2 truncate">${service.name}</h3>
                <p class="text-gray-600 text-sm mb-4 h-12 overflow-hidden">${service.description}</p>
                <div class="flex items-center justify-between mb-4">
                    <div class="flex items-center text-gray-500">
                        <i data-lucide="clock" class="h-4 w-4 mr-1"></i>
                        <span class="text-sm">${service.duration}</span>
                    </div>
                    <div class="text-xl font-bold text-primary">${service.price}</div>
                </div>
                <div class="flex gap-2">
                    <button class="view-details-btn flex-1 bg-secondary text-spa-dark py-1.5 px-3 rounded-full hover:bg-primary hover:text-white transition-all duration-300 font-medium text-sm" data-id="${service.id}">
                        Xem chi tiết
                    </button>
                    <a href="booking.html?service=${service.id}" class="add-to-cart-btn px-3 py-1.5 bg-primary text-white rounded-full hover:bg-primary-dark transition-all duration-300 font-medium text-sm flex items-center">
                        Đặt lịch
                        <i data-lucide="arrow-right" class="ml-1 h-3 w-3"></i>
                    </a>
                </div>
            </div>
        `;
        div.querySelector('.view-details-btn').addEventListener('click', () => this.showModal(service.id));
        return div;
    }

    renderPagination() {
        this.paginationContainer.innerHTML = '';
        const totalPages = Math.ceil(this.filteredServices.length / this.itemsPerPage);

        if (totalPages <= 1) return;

        // Previous button
        const prevBtn = document.createElement('button');
        prevBtn.innerHTML = `<i data-lucide="chevron-left" class="h-4 w-4"></i>`;
        prevBtn.disabled = this.currentPage === 1;
        prevBtn.addEventListener('click', () => {
            this.currentPage--;
            this.renderServices();
        });
        this.paginationContainer.appendChild(prevBtn);

        // Page numbers
        for (let i = 1; i <= totalPages; i++) {
            const pageBtn = document.createElement('button');
            pageBtn.textContent = i;
            if (i === this.currentPage) {
                pageBtn.classList.add('active');
            }
            pageBtn.addEventListener('click', () => {
                this.currentPage = i;
                this.renderServices();
            });
            this.paginationContainer.appendChild(pageBtn);
        }

        // Next button
        const nextBtn = document.createElement('button');
        nextBtn.innerHTML = `<i data-lucide="chevron-right" class="h-4 w-4"></i>`;
        nextBtn.disabled = this.currentPage === totalPages;
        nextBtn.addEventListener('click', () => {
            this.currentPage++;
            this.renderServices();
        });
        this.paginationContainer.appendChild(nextBtn);
        lucide.createIcons();
    }

    showModal(serviceId) {
        const service = this.allServices.find(s => s.id === serviceId);
        if (!service) return;

        this.modalTitle.textContent = service.name;
        this.modalBody.innerHTML = `
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <img src="${service.image}" alt="${service.name}" class="rounded-lg w-full h-64 object-cover">
                </div>
                <div>
                    <span class="text-xs text-primary font-medium bg-secondary px-2 py-1 rounded-full">${service.category}</span>
                    <p class="text-gray-600 mt-4">${service.detailedDescription}</p>
                    <div class="flex justify-between items-center mt-4 text-sm">
                        <span class="flex items-center"><i data-lucide="clock" class="h-4 w-4 mr-2"></i>${service.duration}</span>
                        <span class="flex items-center"><i data-lucide="star" class="h-4 w-4 mr-2 text-primary fill-current"></i>${service.rating} (${service.reviewCount} reviews)</span>
                        <span class="text-2xl font-bold text-primary">${service.price}</span>
                    </div>
                </div>
            </div>
            <div class="mt-6">
                <h4 class="font-semibold text-lg mb-2">Lợi ích chính</h4>
                <ul class="list-disc list-inside space-y-1 text-gray-600">
                    ${service.benefits.map(b => `<li>${b}</li>`).join('')}
                </ul>
            </div>
            <div class="mt-6">
                <h4 class="font-semibold text-lg mb-2">Đánh giá từ khách hàng</h4>
                <div class="space-y-4">
                    ${service.reviews.map(r => `
                        <div class="border-t pt-4">
                            <div class="flex justify-between items-center">
                                <p class="font-semibold">${r.customerName}</p>
                                <div class="flex">
                                    ${[...Array(r.rating)].map(() => `<i data-lucide="star" class="h-4 w-4 text-primary fill-current"></i>`).join('')}
                                </div>
                            </div>
                            <p class="text-gray-600 italic mt-1">"${r.comment}"</p>
                        </div>
                    `).join('')}
                </div>
            </div>
            <div class="mt-8 text-center">
                <a href="booking.html?service=${service.id}" class="btn btn-primary">
                    <i data-lucide="calendar" class="h-5 w-5 mr-2"></i>
                    Đặt lịch ngay
                </a>
            </div>
        `;
        this.modal.classList.add('active');
        lucide.createIcons();
    }

    closeModal() {
        this.modal.classList.remove('active');
    }
    
    getStaticServices() {
        // This data is copied from the Services.tsx file
        return [
          {
            id: '1',
            name: 'Điều trị mụn chuyên sâu',
            category: 'Chăm sóc da mặt',
            duration: '90 phút',
            price: '599.000đ',
            description: 'Điều trị mụn hiệu quả với công nghệ hiện đại và thảo dược tự nhiên.',
            detailedDescription: 'Liệu pháp điều trị mụn chuyên sâu kết hợp công nghệ hiện đại với thảo dược tự nhiên. Quy trình bao gồm làm sạch sâu, tẩy tế bào chết, chiết xuất mụn an toàn, và đắp mặt nạ phục hồi. Sử dụng các sản phẩm chứa Salicylic Acid, Tea Tree Oil và các chiết xuất thảo dược Việt Nam.',
            image: 'https://images.pexels.com/photos/3985263/pexels-photo-3985263.jpeg?auto=compress&cs=tinysrgb&w=600',
            rating: 4.9,
            reviewCount: 127,
            featured: true,
            tags: ['mụn', 'da nhạy cảm', 'điều trị'],
            features: [
              'Làm sạch sâu lỗ chân lông',
              'Chiết xuất mụn an toàn không đau',
              'Đắp mặt nạ phục hồi da',
              'Tư vấn chế độ chăm sóc tại nhà'
            ],
            benefits: [
              'Giảm 80% mụn sau 4 buổi điều trị',
              'Da sạch mịn, không để lại scar',
              'Kiểm soát dầu thừa hiệu quả',
              'Tăng độ đàn hồi và sáng da'
            ],
            reviews: [
              {
                id: '1',
                customerName: 'Chị Mai Anh',
                rating: 5,
                comment: 'Điều trị mụn rất hiệu quả, da sạch mịn hơn nhiều sau 3 buổi.',
                date: '15/12/2024'
              },
              {
                id: '2',
                customerName: 'Chị Thanh Hương',
                rating: 5,
                comment: 'Nhân viên chuyên nghiệp, quy trình rõ ràng, kết quả vượt mong đợi.',
                date: '10/12/2024'
              }
            ]
          },
          {
            id: '2',
            name: 'Chăm sóc da lão hóa',
            category: 'Chăm sóc da mặt',
            duration: '120 phút',
            price: '799.000đ',
            description: 'Phục hồi độ đàn hồi và giảm nếp nhăn với collagen tự nhiên.',
            detailedDescription: 'Liệu pháp chống lão hóa toàn diện sử dụng công nghệ RF và collagen tự nhiên. Quy trình bao gồm massage lymphatic, đắp mặt nạ collagen, và sử dụng serum chống lão hóa cao cấp.',
            image: 'https://images.pexels.com/photos/3997991/pexels-photo-3997991.jpeg?auto=compress&cs=tinysrgb&w=600',
            rating: 4.8,
            reviewCount: 89,
            tags: ['chống lão hóa', 'collagen', 'nếp nhăn'],
            features: [
              'Massage lymphatic chuyên sâu',
              'Đắp mặt nạ collagen tươi',
              'Sử dụng serum chống lão hóa',
              'Massage mặt bằng đá quý'
            ],
            benefits: [
                'Giảm nếp nhăn và vết chân chim',
                'Tăng cường độ đàn hồi và săn chắc',
                'Làm sáng và đều màu da',
                'Cung cấp độ ẩm sâu'
            ],
            reviews: []
          },
          {
            id: '3',
            name: 'Massage Thụy Điển thư giãn',
            category: 'Massage thư giãn',
            duration: '60 phút',
            price: '450.000đ',
            description: 'Giảm căng thẳng và mệt mỏi với kỹ thuật massage Thụy Điển.',
            detailedDescription: 'Trải nghiệm sự thư giãn tuyệt đối với liệu pháp massage Thụy Điển, kết hợp các động tác xoa bóp, miết, và vỗ nhẹ nhàng giúp giảm căng cơ, cải thiện tuần hoàn máu và mang lại cảm giác thư thái sâu sắc.',
            image: 'https://images.pexels.com/photos/3997989/pexels-photo-3997989.jpeg?auto=compress&cs=tinysrgb&w=600',
            rating: 4.9,
            reviewCount: 210,
            featured: true,
            tags: ['thư giãn', 'massage', 'căng thẳng'],
            benefits: [
                'Giảm đau nhức cơ bắp',
                'Cải thiện tuần hoàn máu',
                'Giảm stress và lo âu',
                'Cải thiện chất lượng giấc ngủ'
            ],
            reviews: []
          },
          {
              id: '4',
              name: 'Tắm trắng thảo dược',
              category: 'Tắm trắng',
              duration: '75 phút',
              price: '650.000đ',
              description: 'Sở hữu làn da trắng hồng tự nhiên với các loại thảo dược quý hiếm.',
              detailedDescription: 'Liệu pháp tắm trắng an toàn và hiệu quả, sử dụng 100% thảo dược thiên nhiên như cam thảo, ngọc trai, và các loại hoa lá quý hiếm. Giúp loại bỏ tế bào chết, làm mờ vết thâm và dưỡng da trắng sáng, mịn màng.',
              image: 'https://images.pexels.com/photos/3985254/pexels-photo-3985254.jpeg?auto=compress&cs=tinysrgb&w=600',
              rating: 4.7,
              reviewCount: 95,
              tags: ['làm trắng', 'thảo dược', 'da sáng'],
              benefits: [
                'Bật tone da ngay sau lần đầu',
                'An toàn, không gây kích ứng',
                'Cung cấp độ ẩm, giúp da mềm mịn',
                'Làm mờ các vết thâm, sạm'
              ],
              reviews: []
          }
        ];
    }
}

// Initialize the services page logic
document.addEventListener('DOMContentLoaded', () => {
    if (document.getElementById('services-grid')) {
        new ServicesPage();
    }
}); 