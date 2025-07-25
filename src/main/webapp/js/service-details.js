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
        console.log('[SERVICE_DETAILS] Setup called, checking for data...');
        console.log('[SERVICE_DETAILS] window.serviceDetailsData:', window.serviceDetailsData);

        // Check if we have data from JSP (enhanced mode)
        if (window.serviceDetailsData) {
            this.serviceData = window.serviceDetailsData.serviceData;
            this.serviceImages = window.serviceDetailsData.serviceImages;
            
            // Make sure we have complete service data
            if (this.serviceData) {
                // Add missing fields if needed
                if (!this.serviceData.durationMinutes) {
                    // Try to get duration from the page
                    const durationElement = document.getElementById('service-duration');
                    if (durationElement) {
                        const durationText = durationElement.textContent;
                        const durationMatch = durationText.match(/(\d+)/);
                        if (durationMatch) {
                            this.serviceData.durationMinutes = parseInt(durationMatch[1]);
                        } else {
                            this.serviceData.durationMinutes = 60; // Default
                        }
                    } else {
                        this.serviceData.durationMinutes = 60; // Default
                    }
                }
                
                // Make sure we have a description
                if (!this.serviceData.description) {
                    const descElement = document.getElementById('service-description');
                    if (descElement) {
                        this.serviceData.description = descElement.textContent.trim();
                    }
                }
            }
            
            console.log('[SERVICE_DETAILS] Using JSP data:', this.serviceData, this.serviceImages);
            console.log('[SERVICE_DETAILS] Service images count:', this.serviceImages ? this.serviceImages.length : 0);

            this.setupEnhancedMode();
        } else {
            console.log('[SERVICE_DETAILS] No JSP data found, falling back to API mode');
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
        // Load related services
        this.loadRelatedServices();
        this.setupImageErrorHandling();

        // Initialize Lucide icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
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

        // Load related services
        this.loadRelatedServices();

        // Initialize Lucide icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
    }

    setupEventListeners() {
        console.log('[SERVICE_DETAILS] Setting up event listeners...');

        // Image navigation
        const prevBtn = document.getElementById('prev-btn');
        const nextBtn = document.getElementById('next-btn');
        console.log('[SERVICE_DETAILS] Navigation buttons found:', { prevBtn: !!prevBtn, nextBtn: !!nextBtn });

        if (prevBtn) {
            prevBtn.addEventListener('click', () => {
                console.log('[SERVICE_DETAILS] Previous button clicked');
                this.prevImage();
            });
        }
        if (nextBtn) {
            nextBtn.addEventListener('click', () => {
                console.log('[SERVICE_DETAILS] Next button clicked');
                this.nextImage();
            });
        }

        // Thumbnail clicks
        const thumbnails = document.querySelectorAll('.thumbnail-item');
        console.log('[SERVICE_DETAILS] Thumbnails found:', thumbnails.length);

        thumbnails.forEach((thumb, index) => {
            thumb.addEventListener('click', () => {
                console.log('[SERVICE_DETAILS] Thumbnail clicked:', index);
                this.goToImage(index);
            });
        });

        // Main image click for zoom
        const mainImage = document.getElementById('main-service-image');
        console.log('[SERVICE_DETAILS] Main image found:', !!mainImage);

        if (mainImage) {
            mainImage.addEventListener('click', () => {
                console.log('[SERVICE_DETAILS] Main image clicked for zoom');
                const currentImage = this.serviceImages[this.currentImageIndex];
                if (currentImage) {
                    console.log('[SERVICE_DETAILS] Opening zoom for image:', currentImage.url);
                    this.openImageZoom(currentImage.url, currentImage.altText);
                } else {
                    console.warn('[SERVICE_DETAILS] No current image found for zoom');
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

        // Related services navigation - removed since using server-side rendering

        // Related services add to cart buttons
        this.setupRelatedServicesCart();

        console.log('[ServiceDetails] Event listeners setup complete');
    }

    // Legacy addToCart method for API-based loading
    addToCartLegacy() {
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

    // setupRelatedServicesNavigation removed - using server-side rendered related services

    setupRelatedServicesCart() {
        // Handle add to cart buttons for related services
        const relatedCartButtons = document.querySelectorAll('.add-to-cart-related');

        relatedCartButtons.forEach(button => {
            button.addEventListener('click', async (e) => {
                e.preventDefault();

                const serviceId = button.getAttribute('data-service-id');
                const serviceName = button.getAttribute('data-service-name');
                const servicePrice = button.getAttribute('data-service-price');

                if (serviceId && serviceName && servicePrice) {
                    await this.addRelatedServiceToCart(serviceId, serviceName, servicePrice, button);
                }
            });
        });
    }

    async addRelatedServiceToCart(serviceId, serviceName, servicePrice, button) {
        try {
            // Try to find the service image from the button's parent card
            let serviceImage = `https://placehold.co/300x200/FFB6C1/333333?text=${encodeURIComponent(serviceName)}`;
            
            try {
                // Find the parent card element
                const card = button.closest('.bg-white');
                if (card) {
                    // Find the image element within the card
                    const imgElement = card.querySelector('img');
                    if (imgElement && imgElement.src && !imgElement.src.includes('placehold.co')) {
                        serviceImage = imgElement.src;
                        console.log('[ServiceDetails] Found image in card:', serviceImage);
                    }
                }
            } catch (imgError) {
                console.warn('[ServiceDetails] Error finding image in card:', imgError);
            }
            
            // Prepare service data
            const serviceData = {
                serviceId: parseInt(serviceId),
                serviceName: serviceName,
                serviceImage: serviceImage,
                servicePrice: parseFloat(servicePrice),
                serviceDuration: 60 // Default duration
            };
            
            console.log('[ServiceDetails] Adding related service to cart:', serviceData);
            
            // Use the global addToCart function if available
            if (typeof window.addToCart === 'function') {
                window.addToCart(serviceData);
                
                // Update cart icon immediately
                if (typeof window.updateCartIcon === 'function') {
                    await window.updateCartIcon();
                }
                
                // Show success feedback
                this.showRelatedServiceAddedFeedback(button, serviceName);
                
                console.log('[ServiceDetails] Related service added to cart:', serviceName);
            } else {
                // Fallback to direct localStorage manipulation
                // Get existing cart from localStorage
                let cart = JSON.parse(localStorage.getItem('session_cart') || '[]');
    
                // Check if service already exists in cart
                const existingItemIndex = cart.findIndex(item => item.serviceId === parseInt(serviceId));
    
                if (existingItemIndex !== -1) {
                    // Increase quantity if already exists
                    cart[existingItemIndex].quantity += 1;
                } else {
                    // Add new item to cart
                    cart.push({
                        serviceId: parseInt(serviceId),
                        serviceName: serviceName,
                        serviceImage: serviceImage,
                        servicePrice: parseFloat(servicePrice),
                        serviceDuration: 60,
                        quantity: 1,
                        addedAt: new Date().toISOString()
                    });
                }
    
                // Save updated cart
                localStorage.setItem('session_cart', JSON.stringify(cart));
    
                // Update cart count in header using global function
                if (typeof window.updateCartIcon === 'function') {
                    await window.updateCartIcon();
                }
    
                // Show success feedback
                this.showRelatedServiceAddedFeedback(button, serviceName);
    
                console.log('[ServiceDetails] Related service added to cart (fallback):', serviceName);
            }
        } catch (error) {
            console.error('[ServiceDetails] Error adding related service to cart:', error);
            this.showNotification('Có lỗi xảy ra khi thêm dịch vụ vào giỏ hàng', 'error');
        }
    }

    showRelatedServiceAddedFeedback(button, serviceName) {
        // Store original button content - hardcoded to ensure it's always correct
        const originalContent = '<i data-lucide="shopping-cart" class="h-4 w-4 mr-1"></i>Thêm vào giỏ';

        // Show success state
        button.innerHTML = '<i data-lucide="check" class="h-4 w-4 mr-2 inline"></i>Đã thêm';
        button.classList.add('bg-green-500', 'text-white');
        button.classList.remove('bg-primary', 'hover:bg-primary-dark');
        button.disabled = true;

        // Initialize Lucide icons for the success icon
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }

        // Show notification
        this.showNotification(`Đã thêm "${serviceName}" vào giỏ hàng`, 'success');

        // Reset button after 2 seconds
        setTimeout(() => {
            button.innerHTML = originalContent;
            button.classList.remove('bg-green-500', 'text-white');
            button.classList.add('bg-primary', 'hover:bg-primary-dark');
            button.disabled = false;

            // Re-initialize Lucide icons
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }
        }, 2000);
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

    // Related Services Functions - Removed API call since services are loaded server-side

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
        console.log('[IMAGE_CAROUSEL] prevImage called, current index:', this.currentImageIndex);
        if (this.currentImageIndex > 0) {
            this.currentImageIndex--;
            console.log('[IMAGE_CAROUSEL] Moving to previous image, new index:', this.currentImageIndex);
            this.updateMainImage();
        } else {
            console.log('[IMAGE_CAROUSEL] Already at first image');
        }
    }

    nextImage() {
        console.log('[IMAGE_CAROUSEL] nextImage called, current index:', this.currentImageIndex);
        if (this.currentImageIndex < this.serviceImages.length - 1) {
            this.currentImageIndex++;
            console.log('[IMAGE_CAROUSEL] Moving to next image, new index:', this.currentImageIndex);
            this.updateMainImage();
        } else {
            console.log('[IMAGE_CAROUSEL] Already at last image');
        }
    }

    goToImage(index) {
        console.log('[IMAGE_CAROUSEL] goToImage called with index:', index);
        if (index >= 0 && index < this.serviceImages.length) {
            this.currentImageIndex = index;
            console.log('[IMAGE_CAROUSEL] Moving to image index:', this.currentImageIndex);
            this.updateMainImage();
        } else {
            console.log('[IMAGE_CAROUSEL] Invalid image index:', index);
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



    // Get service image URL with fallback
    getServiceImageUrl() {
        // For enhanced mode, use the first image from serviceImages array
        if (this.serviceImages && this.serviceImages.length > 0) {
            const primaryImage = this.serviceImages.find(img => img.isPrimary) || this.serviceImages[0];
            if (primaryImage && primaryImage.url && primaryImage.url.trim() !== '') {
                console.log('🖼️ Using service image from serviceImages:', primaryImage.url);
                return primaryImage.url;
            }
        }

        // For legacy mode, use the service object
        const service = this.service || this.serviceData;
        if (service && service.imageUrl && service.imageUrl.trim() !== '' && service.imageUrl !== '/services/default.jpg') {
            // Ensure the URL has proper context path
            let imageUrl = service.imageUrl;

            // Only add context path if the URL starts with / and doesn't already include context path
            if (imageUrl.startsWith('/') && !imageUrl.startsWith(this.contextPath)) {
                imageUrl = `${this.contextPath}${imageUrl}`;
            }

            console.log('🖼️ Using database image for service:', service.serviceId, '→', imageUrl);
            return imageUrl;
        }
        
        // Try to get the image from the main service image element
        const mainImageElement = document.getElementById('main-service-image');
        if (mainImageElement && mainImageElement.src && !mainImageElement.src.includes('placehold.co')) {
            console.log('🖼️ Using main image element src:', mainImageElement.src);
            return mainImageElement.src;
        }

        // Fallback to placehold.co placeholder with service name
        const serviceName = (this.serviceData && this.serviceData.name) || (service && service.name) || 'Service';
        const placeholderUrl = `https://placehold.co/300x200/FFB6C1/333333?text=${encodeURIComponent(serviceName)}`;
        console.log('🖼️ Using placeholder image for service:', placeholderUrl);
        return placeholderUrl;
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

    // Duplicate setupRelatedServicesNavigation removed

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

        // Save the original button content
        const originalText = '<i data-lucide="shopping-cart" class="h-5 w-5 mr-2"></i>Thêm vào giỏ hàng';
        
        // Set debounce flag and button state
        this.isAddingToCart = true;

        // Show loading state
        button.innerHTML = '<i data-lucide="loader-2" class="h-5 w-5 mr-2 animate-spin"></i>Đang thêm...';
        button.disabled = true;
        
        // Initialize Lucide icons for the loading spinner
        if (typeof lucide !== 'undefined') lucide.createIcons();

        // Get service data from the page
        const service = this.service || this.serviceData;
        
        if (!service) {
            console.error('[CART] No service data available');
            button.innerHTML = originalText;
            button.disabled = false;
            this.isAddingToCart = false;
            this.showNotification('Không thể thêm vào giỏ hàng: Thiếu thông tin dịch vụ', 'error');
            if (typeof lucide !== 'undefined') lucide.createIcons();
            return;
        }

        // Prepare service data with proper image URL
        const serviceData = {
            serviceId: parseInt(serviceId),
            serviceName: service.name || 'Dịch vụ',
            serviceImage: this.getServiceImageUrl(),
            servicePrice: service.price || 0,
            serviceDuration: service.durationMinutes || 60
        };

        console.log('[CART] Service data prepared:', serviceData);

        // Use the global cart function instead of API call
        if (typeof window.addToCart === 'function') {
            try {
                window.addToCart(serviceData);
                
                // Update cart icon immediately
                if (typeof window.updateCartIcon === 'function') {
                    window.updateCartIcon();
                }

                // Show success state
                button.innerHTML = '<i data-lucide="check" class="h-5 w-5 mr-2"></i>Đã thêm vào giỏ';
                button.classList.remove('bg-primary', 'hover:bg-primary-dark');
                button.classList.add('bg-green-500', 'hover:bg-green-600');
                
                // Initialize Lucide icons for the success icon
                if (typeof lucide !== 'undefined') lucide.createIcons();

                // Reset button after 2 seconds
                setTimeout(() => {
                    button.innerHTML = originalText;
                    button.classList.remove('bg-green-500', 'hover:bg-green-600');
                    button.classList.add('bg-primary', 'hover:bg-primary-dark');
                    button.disabled = false;
                    this.isAddingToCart = false;
                    if (typeof lucide !== 'undefined') lucide.createIcons();
                }, 2000);

            } catch (error) {
                console.error('Cart error:', error);
                button.innerHTML = originalText;
                button.disabled = false;
                this.isAddingToCart = false;
                this.showNotification('Lỗi: ' + error.message, 'error');
                if (typeof lucide !== 'undefined') lucide.createIcons();
            }
        } else {
            console.error('Global addToCart function not found!');
            button.innerHTML = originalText;
            button.disabled = false;
            this.isAddingToCart = false;
            this.showNotification('Không thể thêm vào giỏ hàng. Vui lòng thử lại.', 'error');
            if (typeof lucide !== 'undefined') lucide.createIcons();
        }
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
    async loadRelatedServices() {
        try {
            const serviceId = this.serviceData ? this.serviceData.serviceId : this.service.serviceId;
            const response = await fetch(`${this.contextPath}/api/services?limit=6&exclude=${serviceId}`);
            
            if (!response.ok) {
                throw new Error('Failed to load related services');
            }

            const data = await response.json();
            const relatedServices = data.services || data;
            
            this.displayRelatedServices(relatedServices.slice(0, 6)); // Show max 6 related services
        } catch (error) {
            console.error('Error loading related services:', error);
            this.hideRelatedServicesLoading();
        }
    }

    displayRelatedServices(services) {
        const container = document.getElementById('related-services-grid');
        const skeletonLoading = document.getElementById('related-skeleton-loading');
        
        if (!container) return;

        // Hide skeleton loading
        if (skeletonLoading) {
            skeletonLoading.remove();
        }

        // Clear existing content
        container.innerHTML = '';

        if (!services || services.length === 0) {
            container.innerHTML = `
                <div class="col-span-full text-center py-8">
                    <i data-lucide="search" class="h-12 w-12 text-gray-400 mx-auto mb-4"></i>
                    <p class="text-gray-500">Không có dịch vụ liên quan</p>
                </div>
            `;
            if (typeof lucide !== 'undefined') lucide.createIcons();
            return;
        }

        // Generate service cards with EXACT styling from services.jsp
        services.forEach((service, index) => {
            const serviceCard = this.createServiceCard(service, index);
            container.appendChild(serviceCard);
        });

        // Initialize Lucide icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }

        // Setup cart buttons for related services
        this.setupRelatedServicesCart();
    }

    createServiceCard(service, loadOrder) {
        const card = document.createElement('div');
        card.className = 'bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1';
        card.setAttribute('data-load-order', loadOrder);

        // Get service image URL with fallback
        const imageUrl = this.getServiceImageForCard(service);
        
        // Format price
        const formattedPrice = new Intl.NumberFormat('vi-VN').format(service.price) + ' ₫';
        
        // Get rating
        const rating = service.averageRating || 4.5;

        card.innerHTML = `
            <div class="relative">
                <img 
                    src="${imageUrl}" 
                    alt="${service.name}" 
                    class="w-full h-48 object-cover"
                    loading="lazy"
                    onerror="this.src='https://placehold.co/300x200/FFB6C1/333333?text=${encodeURIComponent(service.name)}';"
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
                        ${service.serviceTypeId && service.serviceTypeId.name ? service.serviceTypeId.name : 'Dịch vụ spa'}
                    </span>
                </div>
                <h3 class="text-lg font-semibold text-spa-dark mb-2 line-clamp-2">${service.name}</h3>
                <p class="text-gray-600 text-sm mb-4 h-12 overflow-hidden line-clamp-2">
                    ${service.description || 'Dịch vụ chăm sóc sắc đẹp chuyên nghiệp tại Spa Hương Sen'}
                </p>
                <div class="flex items-center justify-between mb-4">
                    <div class="flex items-center text-gray-500">
                        <i data-lucide="clock" class="h-4 w-4 mr-1"></i>
                        <span class="text-sm">${service.durationMinutes || 60} phút</span>
                    </div>
                    <div class="text-xl font-bold text-primary">${formattedPrice}</div>
                </div>
                <div class="grid grid-cols-2 gap-2">
                    <button 
                        class="view-details-btn w-full bg-secondary text-spa-dark py-2.5 px-3 rounded-full hover:bg-primary hover:text-white transition-all duration-300 font-medium text-sm flex items-center justify-center"
                        onclick="window.location.href='${this.contextPath}/service-details?id=${service.serviceId}'"
                    >
                        Xem chi tiết
                    </button>
                    <button 
                        class="add-to-cart-related w-full bg-primary text-white py-2.5 px-3 rounded-full hover:bg-primary-dark transition-all duration-300 font-medium text-sm flex items-center justify-center"
                        data-service-id="${service.serviceId}"
                        data-service-name="${service.name}"
                        data-service-price="${service.price}"
                    >
                        <i data-lucide="shopping-cart" class="h-4 w-4 mr-1"></i>
                        Thêm vào giỏ
                    </button>
                </div>
            </div>
        `;

        return card;
    }

    getServiceImageForCard(service) {
        // Get context path for proper URL construction
        const contextPath = this.contextPath || '';
        
        // Check if service has images property (from API)
        if (service.images && service.images.length > 0) {
            const primaryImage = service.images.find(img => img.isPrimary) || service.images[0];
            if (primaryImage && primaryImage.url && primaryImage.url.trim() !== '') {
                console.log('🖼️ Using primary image from service.images:', primaryImage.url);
                return primaryImage.url;
            }
        }
        
        // Use the service's imageUrl from database if available
        if (service.imageUrl && service.imageUrl.trim() !== '' && service.imageUrl !== '/services/default.jpg') {
            // Ensure the URL has proper context path
            const imageUrl = service.imageUrl.startsWith('/') ? `${contextPath}${service.imageUrl}` : service.imageUrl;
            console.log('🖼️ Using database image for service:', service.serviceId, '→', imageUrl);
            return imageUrl;
        }
        
        // Fallback to placehold.co placeholder with service name
        const serviceName = encodeURIComponent(service.name || 'Service');
        const placeholderUrl = `https://placehold.co/300x200/FFB6C1/333333?text=${serviceName}`;
        console.log('🖼️ Using placeholder image for service:', service.serviceId, '→', placeholderUrl);
        return placeholderUrl;
    }

    hideRelatedServicesLoading() {
        const skeletonLoading = document.getElementById('related-skeleton-loading');
        if (skeletonLoading) {
            skeletonLoading.remove();
        }
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
