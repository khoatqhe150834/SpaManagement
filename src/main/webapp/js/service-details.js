/**
 * Service Details Page Manager
 * Handles loading and displaying individual service details with enhanced functionality
 */
class ServiceDetailsManager {
    constructor() {
        this.serviceId = null;
        this.service = null;
        this.contextPath = this.getContextPath();

        // Enhanced functionality properties
        this.serviceData = null;
        this.serviceImages = [];
        this.currentImageIndex = 0;
        this.zoomLevel = 1;
        this.zoomImageIndex = 0;
        this.isAddingToCart = false;

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
        // Check if we have data from JSP (enhanced mode)
        if (window.serviceDetailsData) {
            this.serviceData = window.serviceDetailsData.serviceData;
            this.serviceImages = window.serviceDetailsData.serviceImages;
            console.log('[SERVICE_DETAILS] Using JSP data:', this.serviceData, this.serviceImages);

            this.setupEnhancedMode();
        } else {
            // Fallback to API mode
            this.serviceId = this.getServiceIdFromUrl();

            if (!this.serviceId) {
                this.showError();
                return;
            }

            // Load service details
            this.loadServiceDetails();
        }

        // Setup event listeners
        this.setupEventListeners();
    }

    setupEnhancedMode() {
        this.showServiceContent();
        this.initializeImageCarousel();
        this.loadRelatedServices();
        this.setupImageErrorHandling();
    }

    getServiceIdFromUrl() {
        const urlParams = new URLSearchParams(window.location.search);
        return urlParams.get('id');
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

    async loadServiceDetails() {
        try {
            // Show loading state
            this.showLoading();

            // Fetch service details from API
            const response = await fetch(`${this.contextPath}/api/services/${this.serviceId}`);
            
            if (!response.ok) {
                throw new Error('Service not found');
            }

            this.service = await response.json();
            
            // Track service view
            this.trackServiceView();
            
            // Display service details
            this.displayServiceDetails();
            
        } catch (error) {
            console.error('Error loading service details:', error);
            this.showError();
        }
    }

    trackServiceView() {
        if (this.service && typeof window.trackServiceView === 'function') {
            // Get service image with fallback
            const serviceImage = this.getServiceImageUrl();
            
            window.trackServiceView(
                this.service.serviceId.toString(),
                this.service.name,
                serviceImage,
                this.service.price
            );
        }
    }

    getServiceImageUrl() {
        // Use the service's imageUrl from database if available
        if (this.service.imageUrl && this.service.imageUrl.trim() !== '' && this.service.imageUrl !== '/services/default.jpg') {
            // Ensure the URL has proper context path
            let imageUrl = this.service.imageUrl;
            
            // Only add context path if the URL starts with / and doesn't already include context path
            if (imageUrl.startsWith('/') && !imageUrl.startsWith(this.contextPath)) {
                imageUrl = `${this.contextPath}${imageUrl}`;
            }
            
            console.log('🖼️ Using database image for service:', this.service.serviceId, '→', imageUrl);
            return imageUrl;
        }
        
        // Fallback to placehold.co placeholder with service name
        const serviceName = encodeURIComponent(this.service.name || 'Service');
        const placeholderUrl = `https://placehold.co/800x600/FFB6C1/333333?text=${serviceName}`;
        console.log('🖼️ Using placeholder image for service:', this.service.serviceId, '→', placeholderUrl);
        return placeholderUrl;
    }

    loadServiceImage() {
        const imageElement = document.getElementById('service-image');
        if (!imageElement) return;

        // Set alt text immediately
        imageElement.alt = this.service.name;
        
        // Show loading placeholder initially
        const serviceName = encodeURIComponent(this.service.name || 'Service');
        const loadingPlaceholder = `https://placehold.co/800x600/E5E7EB/9CA3AF?text=Loading...`;
        imageElement.src = loadingPlaceholder;

        // Get the optimal image URL
        const serviceImage = this.getServiceImageUrl();

        // If it's already a placeholder, load it directly (fast)
        if (serviceImage.includes('placehold.co')) {
            imageElement.src = serviceImage;
            return;
        }

        // For database images, try loading with a timeout and fallback
        const loadWithFallback = (imageUrl, isRetry = false) => {
            // Create a new image to test loading
            const testImage = new Image();
            
            testImage.onload = () => {
                // Image loaded successfully, apply it
                imageElement.src = imageUrl;
                console.log('🖼️ Successfully loaded image for service:', this.service.serviceId);
            };
            
            testImage.onerror = () => {
                if (!isRetry) {
                    console.log('🖼️ Database image failed, using placeholder for service:', this.service.serviceId);
                    // Use placeholder as fallback
                    const serviceName = encodeURIComponent(this.service.name || 'Service');
                    const fallbackUrl = `https://placehold.co/800x600/FFB6C1/333333?text=${serviceName}`;
                    imageElement.src = fallbackUrl;
                } else {
                    console.error('🖼️ Both database image and placeholder failed for service:', this.service.serviceId);
                }
            };

            // Set a timeout for slow loading images
            const timeoutId = setTimeout(() => {
                if (!testImage.complete) {
                    console.log('🖼️ Image loading timeout, using placeholder for service:', this.service.serviceId);
                    testImage.onerror(); // Trigger fallback
                }
            }, 3000); // 3 second timeout

            // Clear timeout when image loads or fails
            testImage.onload = () => {
                clearTimeout(timeoutId);
                imageElement.src = imageUrl;
                console.log('🖼️ Successfully loaded image for service:', this.service.serviceId);
            };

            testImage.onerror = () => {
                clearTimeout(timeoutId);
                if (!isRetry) {
                    console.log('🖼️ Database image failed, using placeholder for service:', this.service.serviceId);
                    const serviceName = encodeURIComponent(this.service.name || 'Service');
                    const fallbackUrl = `https://placehold.co/800x600/FFB6C1/333333?text=${serviceName}`;
                    imageElement.src = fallbackUrl;
                }
            };

            // Start loading the test image
            testImage.src = imageUrl;
        };

        // Start the loading process
        loadWithFallback(serviceImage);
    }

    displayServiceDetails() {
        // Hide loading and error states
        document.getElementById('loading-state').classList.add('hidden');
        document.getElementById('error-state').classList.add('hidden');
        
        // Show service content
        const serviceContent = document.getElementById('service-content');
        serviceContent.classList.remove('hidden');

        // Update page title
        document.title = `${this.service.name} - Spa Hương Sen`;

        // Update service information with optimized image loading
        this.loadServiceImage();
        
        document.getElementById('service-name').textContent = this.service.name;
        document.getElementById('service-description').textContent = this.service.description || 'Dịch vụ chăm sóc sắc đẹp chuyên nghiệp';
        
        // Format price with thousand separators
        const formattedPrice = new Intl.NumberFormat('vi-VN', {
            style: 'decimal',
            minimumFractionDigits: 0,
            maximumFractionDigits: 0
        }).format(this.service.price) + ' ₫';
        document.getElementById('service-price').textContent = formattedPrice;
        
        // Duration
        document.getElementById('service-duration').textContent = `${this.service.durationMinutes || 60} phút`;
        
        // Service type (if available)
        const serviceTypeElement = document.getElementById('service-type');
        if (this.service.serviceTypeId && this.service.serviceTypeId.name) {
            serviceTypeElement.textContent = this.service.serviceTypeId.name;
        } else {
            serviceTypeElement.textContent = 'Dịch vụ spa';
        }
        
        // Rating
        const rating = this.service.averageRating || 4.5;
        document.getElementById('service-rating').textContent = rating.toFixed(1);
        
        // Detailed description
        const detailedDescription = this.service.detailedDescription || 
            `${this.service.name} là một trong những dịch vụ chăm sóc sắc đẹp cao cấp tại Spa Hương Sen. 
            Với đội ngũ chuyên viên giàu kinh nghiệm và sử dụng các sản phẩm chất lượng cao, 
            chúng tôi cam kết mang đến cho bạn trải nghiệm thư giãn và làm đẹp tuyệt vời nhất.`;
        
        document.getElementById('service-detailed-description').textContent = detailedDescription;

        // Initialize Lucide icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
    }

    setupEventListeners() {
        // Image navigation
        const prevBtn = document.getElementById('prev-btn');
        const nextBtn = document.getElementById('next-btn');
        if (prevBtn) prevBtn.addEventListener('click', () => this.prevImage());
        if (nextBtn) nextBtn.addEventListener('click', () => this.nextImage());

        // Thumbnail clicks
        document.querySelectorAll('.thumbnail-item').forEach((thumb, index) => {
            thumb.addEventListener('click', () => this.goToImage(index));
        });

        // Main image click for zoom
        const mainImage = document.getElementById('main-service-image');
        if (mainImage) {
            mainImage.addEventListener('click', () => {
                const currentImage = this.serviceImages[this.currentImageIndex];
                if (currentImage) {
                    this.openImageZoom(currentImage.url, currentImage.altText);
                }
            });
        }

        // Cart button
        const addToCartBtn = document.getElementById('add-to-cart-btn');
        if (addToCartBtn) {
            addToCartBtn.addEventListener('click', (e) => {
                e.preventDefault();
                const serviceId = addToCartBtn.getAttribute('data-service-id');
                this.addToCart(serviceId);
            });
        }

        // Wishlist button
        const addToWishlistBtn = document.getElementById('add-to-wishlist-btn');
        if (addToWishlistBtn) {
            addToWishlistBtn.addEventListener('click', (e) => {
                e.preventDefault();
                const serviceId = addToWishlistBtn.getAttribute('data-service-id');
                this.addToWishlist(serviceId);
            });
        }

        // Zoom modal controls
        this.setupZoomModalListeners();

        // Related services navigation
        this.setupRelatedServicesNavigation();

        console.log('[ServiceDetails] Event listeners setup complete');
    }

    addToCart() {
        if (!this.service) return;

        const serviceData = {
            serviceId: this.service.serviceId,
            serviceName: this.service.name,
            serviceImage: this.getServiceImageUrl(),
            servicePrice: this.service.price,
            serviceDuration: this.service.durationMinutes || 60
        };

        // Add to cart using global function
        if (typeof window.addToCart === 'function') {
            window.addToCart(serviceData);
        } else {
            console.error('Global addToCart function not found!');
            this.showNotification('Không thể thêm vào giỏ hàng. Vui lòng thử lại.', 'error');
        }
    }

    showLoading() {
        document.getElementById('loading-state').classList.remove('hidden');
        document.getElementById('error-state').classList.add('hidden');
        document.getElementById('service-content').classList.add('hidden');
    }

    showError() {
        document.getElementById('loading-state').classList.add('hidden');
        document.getElementById('error-state').classList.remove('hidden');
        document.getElementById('service-content').classList.add('hidden');
        
        // Initialize Lucide icons for error state
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
    }

    showNotification(message, type = 'info') {
        const notification = document.getElementById('notification');
        if (!notification) return;

        notification.textContent = message;
        notification.className = `notification ${type} show`;

        setTimeout(() => {
            notification.classList.remove('show');
        }, 3000);
    }

    // Enhanced functionality methods
    setupZoomModalListeners() {
        const zoomCloseBtn = document.getElementById('zoom-close-btn');
        const zoomInBtn = document.getElementById('zoom-in-btn');
        const zoomOutBtn = document.getElementById('zoom-out-btn');
        const zoomResetBtn = document.getElementById('zoom-reset-btn');
        const zoomPrevBtn = document.getElementById('zoom-prev-btn');
        const zoomNextBtn = document.getElementById('zoom-next-btn');
        const zoomModal = document.getElementById('image-zoom-modal');

        if (zoomCloseBtn) zoomCloseBtn.addEventListener('click', () => this.closeImageZoom());
        if (zoomInBtn) zoomInBtn.addEventListener('click', () => this.zoomIn());
        if (zoomOutBtn) zoomOutBtn.addEventListener('click', () => this.zoomOut());
        if (zoomResetBtn) zoomResetBtn.addEventListener('click', () => this.resetZoom());
        if (zoomPrevBtn) zoomPrevBtn.addEventListener('click', () => this.zoomPrevImage());
        if (zoomNextBtn) zoomNextBtn.addEventListener('click', () => this.zoomNextImage());

        // Close on background click
        if (zoomModal) {
            zoomModal.addEventListener('click', (e) => {
                if (e.target === zoomModal) {
                    this.closeImageZoom();
                }
            });
        }

        // Keyboard navigation
        document.addEventListener('keydown', (e) => {
            const modal = document.getElementById('image-zoom-modal');
            if (modal && !modal.classList.contains('hidden')) {
                switch(e.key) {
                    case 'Escape':
                        this.closeImageZoom();
                        break;
                    case 'ArrowLeft':
                        this.zoomPrevImage();
                        break;
                    case 'ArrowRight':
                        this.zoomNextImage();
                        break;
                    case '+':
                    case '=':
                        this.zoomIn();
                        break;
                    case '-':
                        this.zoomOut();
                        break;
                    case '0':
                        this.resetZoom();
                        break;
                }
            }
        });
    }

    setupRelatedServicesNavigation() {
        const relatedPrev = document.getElementById('related-prev');
        const relatedNext = document.getElementById('related-next');
        const relatedGrid = document.getElementById('related-services-grid');

        if (relatedPrev && relatedNext && relatedGrid) {
            relatedPrev.addEventListener('click', () => {
                relatedGrid.scrollBy({ left: -300, behavior: 'smooth' });
            });

            relatedNext.addEventListener('click', () => {
                relatedGrid.scrollBy({ left: 300, behavior: 'smooth' });
            });
        }
    }

    showServiceContent() {
        const serviceContent = document.getElementById('service-content');
        const loadingState = document.getElementById('loading-state');

        if (serviceContent && loadingState) {
            loadingState.classList.add('hidden');
            serviceContent.classList.remove('hidden');
        }
    }

    initializeImageCarousel() {
        if (this.serviceImages.length > 0) {
            this.updateMainImage();
        }

        // Set up error handling for images
        this.setupImageErrorHandling();
    }

    setupImageErrorHandling() {
        // Handle main service image errors
        const mainImage = document.getElementById('main-service-image');
        if (mainImage) {
            mainImage.addEventListener('error', (e) => {
                const serviceName = this.serviceData ? this.serviceData.name : 'Service';
                e.target.src = `https://placehold.co/800x600/FFB6C1/333333?text=${encodeURIComponent(serviceName)}`;
            });
        }

        // Handle thumbnail image errors
        document.querySelectorAll('.thumbnail-item img').forEach((img, index) => {
            img.addEventListener('error', (e) => {
                e.target.src = `https://placehold.co/80x80/FFB6C1/333333?text=${index + 1}`;
            });
        });

        // Handle fallback image in the "otherwise" case
        const fallbackImage = document.querySelector('img[src*="placehold.co"]');
        if (fallbackImage) {
            fallbackImage.addEventListener('error', (e) => {
                const serviceName = this.serviceData ? this.serviceData.name : 'Service';
                e.target.src = `https://placehold.co/800x600/FFB6C1/333333?text=${encodeURIComponent(serviceName)}`;
            });
        }
    }

    prevImage() {
        if (this.currentImageIndex > 0) {
            this.currentImageIndex--;
            this.updateMainImage();
        }
    }

    nextImage() {
        if (this.currentImageIndex < this.serviceImages.length - 1) {
            this.currentImageIndex++;
            this.updateMainImage();
        }
    }

    goToImage(index) {
        if (index >= 0 && index < this.serviceImages.length) {
            this.currentImageIndex = index;
            this.updateMainImage();
        }
    }

    updateMainImage() {
        const mainImage = document.getElementById('main-service-image');
        const currentImageSpan = document.getElementById('current-image');
        const prevBtn = document.getElementById('prev-btn');
        const nextBtn = document.getElementById('next-btn');

        if (mainImage && this.serviceImages[this.currentImageIndex]) {
            const currentImage = this.serviceImages[this.currentImageIndex];
            mainImage.src = currentImage.url;
            mainImage.alt = currentImage.altText;

            // Update counter
            if (currentImageSpan) {
                currentImageSpan.textContent = this.currentImageIndex + 1;
            }

            // Update navigation buttons
            if (prevBtn) prevBtn.disabled = this.currentImageIndex === 0;
            if (nextBtn) nextBtn.disabled = this.currentImageIndex === this.serviceImages.length - 1;

            // Update active thumbnail
            document.querySelectorAll('.thumbnail-item').forEach((thumb, index) => {
                if (index === this.currentImageIndex) {
                    thumb.classList.add('border-primary');
                    thumb.classList.remove('border-transparent');
                } else {
                    thumb.classList.remove('border-primary');
                    thumb.classList.add('border-transparent');
                }
            });
        }
    }

    // Cart Management Functions
    addToCart(serviceId) {
        console.log('[CART] addToCart function called with serviceId:', serviceId);
        console.log('[CART] Current timestamp:', new Date().toISOString());

        // Prevent multiple simultaneous calls
        if (this.isAddingToCart) {
            console.warn('[CART] Already adding to cart, ignoring duplicate call');
            return;
        }

        const button = document.getElementById('add-to-cart-btn');
        if (!button) {
            console.error('[CART] Add to cart button not found');
            return;
        }

        // Check if button is already disabled
        if (button.disabled) {
            console.warn('[CART] Button is disabled, ignoring click');
            return;
        }

        console.log('[CART] Button state before processing:', {
            disabled: button.disabled,
            innerHTML: button.innerHTML.substring(0, 50) + '...'
        });

        // Set debounce flag and button state
        this.isAddingToCart = true;
        const originalText = button.innerHTML;

        // Show loading state
        button.innerHTML = '<i data-lucide="loader-2" class="h-5 w-5 mr-2 animate-spin"></i>Đang thêm...';
        button.disabled = true;

        console.log('[CART] Button updated to loading state');

        // Simulate API call (replace with actual cart API)
        fetch('/spa/api/cart/add', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                serviceId: serviceId,
                quantity: 1
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Show success state
                button.innerHTML = '<i data-lucide="check" class="h-5 w-5 mr-2"></i>Đã thêm vào giỏ';
                button.classList.remove('bg-primary', 'hover:bg-primary-dark');
                button.classList.add('bg-green-500', 'hover:bg-green-600');

                // Show notification
                this.showNotification('Đã thêm dịch vụ vào giỏ hàng!', 'success');

                // Reset button after 2 seconds
                setTimeout(() => {
                    button.innerHTML = originalText;
                    button.classList.remove('bg-green-500', 'hover:bg-green-600');
                    button.classList.add('bg-primary', 'hover:bg-primary-dark');
                    button.disabled = false;
                    this.isAddingToCart = false;
                    if (typeof lucide !== 'undefined') lucide.createIcons();
                }, 2000);
            } else {
                throw new Error(data.message || 'Không thể thêm vào giỏ hàng');
            }
        })
        .catch(error => {
            console.error('Cart error:', error);
            button.innerHTML = originalText;
            button.disabled = false;
            this.isAddingToCart = false;
            this.showNotification('Lỗi: ' + error.message, 'error');
            if (typeof lucide !== 'undefined') lucide.createIcons();
        });
    }

    // Wishlist Management Functions
    addToWishlist(serviceId) {
        const button = document.getElementById('add-to-wishlist-btn');
        if (!button) return;

        const originalText = button.innerHTML;

        // Show loading state
        button.innerHTML = '<i data-lucide="loader-2" class="h-5 w-5 mr-2 animate-spin"></i>Đang thêm...';
        button.disabled = true;

        // Simulate API call (replace with actual wishlist API)
        fetch('/spa/api/wishlist/add', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                serviceId: serviceId
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Show success state
                button.innerHTML = '<i data-lucide="heart" class="h-5 w-5 mr-2 fill-current"></i>Đã yêu thích';
                button.classList.remove('bg-pink-500', 'hover:bg-pink-600');
                button.classList.add('bg-red-500', 'hover:bg-red-600');

                // Show notification
                this.showNotification('Đã thêm vào danh sách yêu thích!', 'success');

                // Update button to remove from wishlist
                button.onclick = () => this.removeFromWishlist(serviceId);
            } else {
                throw new Error(data.message || 'Không thể thêm vào yêu thích');
            }
        })
        .catch(error => {
            console.error('Wishlist error:', error);
            button.innerHTML = originalText;
            button.disabled = false;
            this.showNotification('Lỗi: ' + error.message, 'error');
            if (typeof lucide !== 'undefined') lucide.createIcons();
        });
    }

    removeFromWishlist(serviceId) {
        const button = document.getElementById('add-to-wishlist-btn');
        if (!button) return;

        fetch('/spa/api/wishlist/remove', {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                serviceId: serviceId
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Reset to add state
                button.innerHTML = '<i data-lucide="heart" class="h-5 w-5 mr-2"></i>Thêm vào yêu thích';
                button.classList.remove('bg-red-500', 'hover:bg-red-600');
                button.classList.add('bg-pink-500', 'hover:bg-pink-600');
                button.onclick = () => this.addToWishlist(serviceId);

                this.showNotification('Đã xóa khỏi danh sách yêu thích!', 'info');
            }
        })
        .catch(error => {
            console.error('Remove wishlist error:', error);
            this.showNotification('Lỗi: ' + error.message, 'error');
        });
    }

    // Image Zoom Functions
    openImageZoom(imageUrl, altText) {
        const modal = document.getElementById('image-zoom-modal');
        const zoomImage = document.getElementById('zoom-image');
        const zoomCounter = document.getElementById('zoom-counter');
        const zoomCurrent = document.getElementById('zoom-current');
        const zoomTotal = document.getElementById('zoom-total');
        const zoomPrevBtn = document.getElementById('zoom-prev-btn');
        const zoomNextBtn = document.getElementById('zoom-next-btn');

        // Find the index of the clicked image
        this.zoomImageIndex = this.serviceImages.findIndex(img => img.url === imageUrl);
        if (this.zoomImageIndex === -1) this.zoomImageIndex = 0;

        // Set up the modal
        zoomImage.src = imageUrl;
        zoomImage.alt = altText;
        this.zoomLevel = 1;
        zoomImage.style.transform = 'scale(1)';

        // Show/hide navigation and counter based on image count
        if (this.serviceImages.length > 1) {
            zoomCounter.classList.remove('hidden');
            zoomCurrent.textContent = this.zoomImageIndex + 1;
            zoomTotal.textContent = this.serviceImages.length;

            if (this.zoomImageIndex > 0) zoomPrevBtn.classList.remove('hidden');
            else zoomPrevBtn.classList.add('hidden');

            if (this.zoomImageIndex < this.serviceImages.length - 1) zoomNextBtn.classList.remove('hidden');
            else zoomNextBtn.classList.add('hidden');
        } else {
            zoomCounter.classList.add('hidden');
            zoomPrevBtn.classList.add('hidden');
            zoomNextBtn.classList.add('hidden');
        }

        modal.classList.remove('hidden');
        document.body.style.overflow = 'hidden';
    }

    closeImageZoom() {
        const modal = document.getElementById('image-zoom-modal');
        modal.classList.add('hidden');
        document.body.style.overflow = 'auto';
    }

    zoomIn() {
        const zoomImage = document.getElementById('zoom-image');
        this.zoomLevel = Math.min(this.zoomLevel * 1.2, 3);
        zoomImage.style.transform = `scale(${this.zoomLevel})`;
    }

    zoomOut() {
        const zoomImage = document.getElementById('zoom-image');
        this.zoomLevel = Math.max(this.zoomLevel / 1.2, 0.5);
        zoomImage.style.transform = `scale(${this.zoomLevel})`;
    }

    resetZoom() {
        const zoomImage = document.getElementById('zoom-image');
        this.zoomLevel = 1;
        zoomImage.style.transform = 'scale(1)';
    }

    zoomPrevImage() {
        if (this.zoomImageIndex > 0) {
            this.zoomImageIndex--;
            const image = this.serviceImages[this.zoomImageIndex];
            this.openImageZoom(image.url, image.altText);
        }
    }

    zoomNextImage() {
        if (this.zoomImageIndex < this.serviceImages.length - 1) {
            this.zoomImageIndex++;
            const image = this.serviceImages[this.zoomImageIndex];
            this.openImageZoom(image.url, image.altText);
        }
    }

    // Related Services Functions
    loadRelatedServices() {
        if (!this.serviceData) return;

        const container = document.getElementById('related-services-grid');
        if (!container) return;

        fetch(`/spa/api/services/related/${this.serviceData.serviceId}?limit=5`)
            .then(response => response.json())
            .then(services => {
                if (services && services.length > 0) {
                    container.innerHTML = services.map(service => `
                        <div class="flex-shrink-0 w-64 bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                            <div class="relative h-48">
                                <img src="${service.imageUrl || 'https://placehold.co/256x192/FFB6C1/333333?text=' + encodeURIComponent(service.name)}"
                                     alt="${service.name}"
                                     class="w-full h-full object-cover"
                                     onerror="this.src='https://placehold.co/256x192/FFB6C1/333333?text=' + encodeURIComponent('${service.name}')">
                                <div class="absolute top-2 right-2 bg-primary text-white px-2 py-1 rounded-full text-xs font-semibold">
                                    ${this.formatCurrency(service.price)}
                                </div>
                            </div>
                            <div class="p-4">
                                <h3 class="font-semibold text-spa-dark mb-2 line-clamp-2">${service.name}</h3>
                                <p class="text-gray-600 text-sm mb-3 line-clamp-2">${service.description || 'Dịch vụ chăm sóc sắc đẹp chuyên nghiệp'}</p>
                                <a href="/spa/service-details?id=${service.serviceId}"
                                   class="block w-full bg-primary text-white text-center py-2 rounded-full hover:bg-primary-dark transition-all duration-300 font-semibold">
                                    Xem chi tiết
                                </a>
                            </div>
                        </div>
                    `).join('');

                    // Show navigation arrows if needed
                    const prevBtn = document.getElementById('related-prev');
                    const nextBtn = document.getElementById('related-next');
                    if (services.length > 3) {
                        if (prevBtn) prevBtn.classList.remove('hidden');
                        if (nextBtn) nextBtn.classList.remove('hidden');
                    }
                } else {
                    container.innerHTML = '<div class="text-center text-gray-500 py-8">Không có dịch vụ liên quan</div>';
                }
            })
            .catch(error => {
                console.error('Error loading related services:', error);
                container.innerHTML = '<div class="text-center text-gray-500 py-8">Không thể tải dịch vụ liên quan</div>';
            });
    }

    // Currency formatting helper
    formatCurrency(amount) {
        try {
            return new Intl.NumberFormat('vi-VN').format(amount) + '₫';
        } catch (error) {
            // Fallback for older browsers
            return amount.toLocaleString('vi-VN') + '₫';
        }
    }

    // Notification function
    showNotification(message, type = 'info') {
        const notification = document.getElementById('notification');
        if (!notification) return;

        notification.textContent = message;
        notification.className = `notification ${type} show`;

        setTimeout(() => {
            notification.classList.remove('show');
        }, 3000);
    }

    // Image carousel methods
    prevImage() {
        if (this.currentImageIndex > 0) {
            this.currentImageIndex--;
            this.updateMainImage();
        }
    }

    nextImage() {
        if (this.currentImageIndex < this.serviceImages.length - 1) {
            this.currentImageIndex++;
            this.updateMainImage();
        }
    }

    goToImage(index) {
        if (index >= 0 && index < this.serviceImages.length) {
            this.currentImageIndex = index;
            this.updateMainImage();
        }
    }

    updateMainImage() {
        const mainImage = document.getElementById('main-service-image');
        const currentImageSpan = document.getElementById('current-image');
        const prevBtn = document.getElementById('prev-btn');
        const nextBtn = document.getElementById('next-btn');

        if (mainImage && this.serviceImages[this.currentImageIndex]) {
            const currentImage = this.serviceImages[this.currentImageIndex];
            mainImage.src = currentImage.url;
            mainImage.alt = currentImage.altText;

            // Update counter
            if (currentImageSpan) {
                currentImageSpan.textContent = this.currentImageIndex + 1;
            }

            // Update navigation buttons
            if (prevBtn) prevBtn.disabled = this.currentImageIndex === 0;
            if (nextBtn) nextBtn.disabled = this.currentImageIndex === this.serviceImages.length - 1;

            // Update active thumbnail
            document.querySelectorAll('.thumbnail-item').forEach((thumb, index) => {
                if (index === this.currentImageIndex) {
                    thumb.classList.add('border-primary');
                    thumb.classList.remove('border-transparent');
                } else {
                    thumb.classList.remove('border-primary');
                    thumb.classList.add('border-transparent');
                }
            });
        }
    }

    // Image zoom functions
    openImageZoom(imageUrl, altText) {
        const modal = document.getElementById('image-zoom-modal');
        const zoomImage = document.getElementById('zoom-image');
        const zoomCounter = document.getElementById('zoom-counter');
        const zoomCurrent = document.getElementById('zoom-current');
        const zoomTotal = document.getElementById('zoom-total');
        const zoomPrevBtn = document.getElementById('zoom-prev-btn');
        const zoomNextBtn = document.getElementById('zoom-next-btn');

        // Find the index of the clicked image
        this.zoomImageIndex = this.serviceImages.findIndex(img => img.url === imageUrl);
        if (this.zoomImageIndex === -1) this.zoomImageIndex = 0;

        // Set up the modal
        zoomImage.src = imageUrl;
        zoomImage.alt = altText;
        this.zoomLevel = 1;
        zoomImage.style.transform = 'scale(1)';

        // Show/hide navigation and counter based on image count
        if (this.serviceImages.length > 1) {
            zoomCounter.classList.remove('hidden');
            zoomCurrent.textContent = this.zoomImageIndex + 1;
            zoomTotal.textContent = this.serviceImages.length;

            if (this.zoomImageIndex > 0) zoomPrevBtn.classList.remove('hidden');
            else zoomPrevBtn.classList.add('hidden');

            if (this.zoomImageIndex < this.serviceImages.length - 1) zoomNextBtn.classList.remove('hidden');
            else zoomNextBtn.classList.add('hidden');
        } else {
            zoomCounter.classList.add('hidden');
            zoomPrevBtn.classList.add('hidden');
            zoomNextBtn.classList.add('hidden');
        }

        modal.classList.remove('hidden');
        document.body.style.overflow = 'hidden';
    }

    closeImageZoom() {
        const modal = document.getElementById('image-zoom-modal');
        modal.classList.add('hidden');
        document.body.style.overflow = 'auto';
    }

    zoomIn() {
        const zoomImage = document.getElementById('zoom-image');
        this.zoomLevel = Math.min(this.zoomLevel * 1.2, 3);
        zoomImage.style.transform = `scale(${this.zoomLevel})`;
    }

    zoomOut() {
        const zoomImage = document.getElementById('zoom-image');
        this.zoomLevel = Math.max(this.zoomLevel / 1.2, 0.5);
        zoomImage.style.transform = `scale(${this.zoomLevel})`;
    }

    resetZoom() {
        const zoomImage = document.getElementById('zoom-image');
        this.zoomLevel = 1;
        zoomImage.style.transform = 'scale(1)';
    }

    zoomPrevImage() {
        if (this.zoomImageIndex > 0) {
            this.zoomImageIndex--;
            const image = this.serviceImages[this.zoomImageIndex];
            this.openImageZoom(image.url, image.altText);
        }
    }

    zoomNextImage() {
        if (this.zoomImageIndex < this.serviceImages.length - 1) {
            this.zoomImageIndex++;
            const image = this.serviceImages[this.zoomImageIndex];
            this.openImageZoom(image.url, image.altText);
        }
    }

    // Utility methods
    formatCurrency(amount) {
        try {
            return new Intl.NumberFormat('vi-VN').format(amount) + '₫';
        } catch (error) {
            // Fallback for older browsers
            return amount.toLocaleString('vi-VN') + '₫';
        }
    }

    showServiceContent() {
        const serviceContent = document.getElementById('service-content');
        const loadingState = document.getElementById('loading-state');

        if (serviceContent && loadingState) {
            loadingState.classList.add('hidden');
            serviceContent.classList.remove('hidden');
        }
    }

    setupRelatedServicesNavigation() {
        const relatedPrev = document.getElementById('related-prev');
        const relatedNext = document.getElementById('related-next');
        const relatedGrid = document.getElementById('related-services-grid');

        if (relatedPrev && relatedNext && relatedGrid) {
            relatedPrev.addEventListener('click', () => {
                relatedGrid.scrollBy({ left: -300, behavior: 'smooth' });
            });

            relatedNext.addEventListener('click', () => {
                relatedGrid.scrollBy({ left: 300, behavior: 'smooth' });
            });
        }
    }

    // Cart and wishlist functionality
    addToCart(serviceId) {
        console.log('[CART] addToCart function called with serviceId:', serviceId);
        console.log('[CART] Current timestamp:', new Date().toISOString());

        // Prevent multiple simultaneous calls
        if (this.isAddingToCart) {
            console.warn('[CART] Already adding to cart, ignoring duplicate call');
            return;
        }

        const button = document.getElementById('add-to-cart-btn');
        if (!button) {
            console.error('[CART] Add to cart button not found');
            return;
        }

        // Check if button is already disabled
        if (button.disabled) {
            console.warn('[CART] Button is disabled, ignoring click');
            return;
        }

        console.log('[CART] Button state before processing:', {
            disabled: button.disabled,
            innerHTML: button.innerHTML.substring(0, 50) + '...'
        });

        // Set debounce flag and button state
        this.isAddingToCart = true;
        const originalText = button.innerHTML;

        // Show loading state
        button.innerHTML = '<i data-lucide="loader-2" class="h-5 w-5 mr-2 animate-spin"></i>Đang thêm...';
        button.disabled = true;

        console.log('[CART] Button updated to loading state');

        // Simulate API call (replace with actual cart API)
        fetch('/spa/api/cart/add', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                serviceId: serviceId,
                quantity: 1
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Show success state
                button.innerHTML = '<i data-lucide="check" class="h-5 w-5 mr-2"></i>Đã thêm vào giỏ';
                button.classList.remove('bg-primary', 'hover:bg-primary-dark');
                button.classList.add('bg-green-500', 'hover:bg-green-600');

                // Show notification
                this.showNotification('Đã thêm dịch vụ vào giỏ hàng!', 'success');

                // Reset button after 2 seconds
                setTimeout(() => {
                    button.innerHTML = originalText;
                    button.classList.remove('bg-green-500', 'hover:bg-green-600');
                    button.classList.add('bg-primary', 'hover:bg-primary-dark');
                    button.disabled = false;
                    this.isAddingToCart = false;
                    if (typeof lucide !== 'undefined') lucide.createIcons();
                }, 2000);
            } else {
                throw new Error(data.message || 'Không thể thêm vào giỏ hàng');
            }
        })
        .catch(error => {
            console.error('Cart error:', error);
            button.innerHTML = originalText;
            button.disabled = false;
            this.isAddingToCart = false;
            this.showNotification('Lỗi: ' + error.message, 'error');
            if (typeof lucide !== 'undefined') lucide.createIcons();
        });
    }

    addToWishlist(serviceId) {
        const button = document.getElementById('add-to-wishlist-btn');
        if (!button) return;

        const originalText = button.innerHTML;

        // Show loading state
        button.innerHTML = '<i data-lucide="loader-2" class="h-5 w-5 mr-2 animate-spin"></i>Đang thêm...';
        button.disabled = true;

        // Simulate API call (replace with actual wishlist API)
        fetch('/spa/api/wishlist/add', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                serviceId: serviceId
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Show success state
                button.innerHTML = '<i data-lucide="heart" class="h-5 w-5 mr-2 fill-current"></i>Đã yêu thích';
                button.classList.remove('bg-pink-500', 'hover:bg-pink-600');
                button.classList.add('bg-red-500', 'hover:bg-red-600');

                // Show notification
                this.showNotification('Đã thêm vào danh sách yêu thích!', 'success');

                // Update button to remove from wishlist
                button.onclick = () => this.removeFromWishlist(serviceId);
            } else {
                throw new Error(data.message || 'Không thể thêm vào yêu thích');
            }
        })
        .catch(error => {
            console.error('Wishlist error:', error);
            button.innerHTML = originalText;
            button.disabled = false;
            this.showNotification('Lỗi: ' + error.message, 'error');
            if (typeof lucide !== 'undefined') lucide.createIcons();
        });
    }

    removeFromWishlist(serviceId) {
        const button = document.getElementById('add-to-wishlist-btn');
        if (!button) return;

        fetch('/spa/api/wishlist/remove', {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                serviceId: serviceId
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Reset to add state
                button.innerHTML = '<i data-lucide="heart" class="h-5 w-5 mr-2"></i>Thêm vào yêu thích';
                button.classList.remove('bg-red-500', 'hover:bg-red-600');
                button.classList.add('bg-pink-500', 'hover:bg-pink-600');
                button.onclick = () => this.addToWishlist(serviceId);

                this.showNotification('Đã xóa khỏi danh sách yêu thích!', 'info');
            }
        })
        .catch(error => {
            console.error('Remove wishlist error:', error);
            this.showNotification('Lỗi: ' + error.message, 'error');
        });
    }

    // Related services functionality
    loadRelatedServices() {
        if (!this.serviceData) return;

        const container = document.getElementById('related-services-grid');
        if (!container) return;

        fetch(`/spa/api/services/related/${this.serviceData.serviceId}?limit=5`)
            .then(response => response.json())
            .then(services => {
                if (services && services.length > 0) {
                    container.innerHTML = services.map(service => `
                        <div class="flex-shrink-0 w-64 bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                            <div class="relative h-48">
                                <img src="${service.imageUrl || 'https://placehold.co/256x192/FFB6C1/333333?text=' + encodeURIComponent(service.name)}"
                                     alt="${service.name}"
                                     class="w-full h-full object-cover"
                                     onerror="this.src='https://placehold.co/256x192/FFB6C1/333333?text=' + encodeURIComponent('${service.name}')">
                                <div class="absolute top-2 right-2 bg-primary text-white px-2 py-1 rounded-full text-xs font-semibold">
                                    ${this.formatCurrency(service.price)}
                                </div>
                            </div>
                            <div class="p-4">
                                <h3 class="font-semibold text-spa-dark mb-2 line-clamp-2">${service.name}</h3>
                                <p class="text-gray-600 text-sm mb-3 line-clamp-2">${service.description || 'Dịch vụ chăm sóc sắc đẹp chuyên nghiệp'}</p>
                                <a href="/spa/service-details?id=${service.serviceId}"
                                   class="block w-full bg-primary text-white text-center py-2 rounded-full hover:bg-primary-dark transition-all duration-300 font-semibold">
                                    Xem chi tiết
                                </a>
                            </div>
                        </div>
                    `).join('');

                    // Show navigation arrows if needed
                    const prevBtn = document.getElementById('related-prev');
                    const nextBtn = document.getElementById('related-next');
                    if (services.length > 3) {
                        if (prevBtn) prevBtn.classList.remove('hidden');
                        if (nextBtn) nextBtn.classList.remove('hidden');
                    }
                } else {
                    container.innerHTML = '<div class="text-center text-gray-500 py-8">Không có dịch vụ liên quan</div>';
                }
            })
            .catch(error => {
                console.error('Error loading related services:', error);
                container.innerHTML = '<div class="text-center text-gray-500 py-8">Không thể tải dịch vụ liên quan</div>';
            });
    }

    setupImageErrorHandling() {
        // Handle main service image errors
        const mainImage = document.getElementById('main-service-image');
        if (mainImage) {
            mainImage.addEventListener('error', (e) => {
                const serviceName = this.serviceData ? this.serviceData.name : 'Service';
                e.target.src = `https://placehold.co/800x600/FFB6C1/333333?text=${encodeURIComponent(serviceName)}`;
            });
        }

        // Handle thumbnail image errors
        document.querySelectorAll('.thumbnail-item img').forEach((img, index) => {
            img.addEventListener('error', (e) => {
                e.target.src = `https://placehold.co/80x80/FFB6C1/333333?text=${index + 1}`;
            });
        });

        // Handle fallback image in the "otherwise" case
        const fallbackImage = document.querySelector('img[src*="placehold.co"]');
        if (fallbackImage) {
            fallbackImage.addEventListener('error', (e) => {
                const serviceName = this.serviceData ? this.serviceData.name : 'Service';
                e.target.src = `https://placehold.co/800x600/FFB6C1/333333?text=${encodeURIComponent(serviceName)}`;
            });
        }
    }

    initializeImageCarousel() {
        if (this.serviceImages.length > 0) {
            this.updateMainImage();
        }

        // Set up error handling for images
        this.setupImageErrorHandling();
    }
}

// Initialize service details manager when script loads
const serviceDetailsManager = new ServiceDetailsManager();

// Export for use in other scripts if needed
window.ServiceDetailsManager = ServiceDetailsManager;
window.serviceDetailsManagerInstance = serviceDetailsManager;
