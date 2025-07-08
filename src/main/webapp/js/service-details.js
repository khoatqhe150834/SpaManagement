/**
 * Service Details Page Manager
 * Handles loading and displaying individual service details
 */
class ServiceDetailsManager {
    constructor() {
        this.serviceId = null;
        this.service = null;
        this.contextPath = this.getContextPath();
        
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
        // Get service ID from URL parameters
        this.serviceId = this.getServiceIdFromUrl();
        
        if (!this.serviceId) {
            this.showError();
            return;
        }

        // Load service details
        this.loadServiceDetails();
        
        // Setup event listeners
        this.setupEventListeners();
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
            const serviceImage = this.service.imageUrl || this.getDefaultServiceImage();
            
            window.trackServiceView(
                this.service.serviceId.toString(),
                this.service.name,
                serviceImage,
                this.service.price
            );
        }
    }

    getDefaultServiceImage() {
        // Use the same beauty images array as in services-api.js
        const beautyImages = [
            'https://images.pexels.com/photos/3997989/pexels-photo-3997989.jpeg?auto=compress&cs=tinysrgb&w=800',
            'https://images.pexels.com/photos/3985263/pexels-photo-3985263.jpeg?auto=compress&cs=tinysrgb&w=800',
            'https://images.pexels.com/photos/3985254/pexels-photo-3985254.jpeg?auto=compress&cs=tinysrgb&w=800',
            'https://images.pexels.com/photos/3997991/pexels-photo-3997991.jpeg?auto=compress&cs=tinysrgb&w=800',
            'https://images.pexels.com/photos/3985267/pexels-photo-3985267.jpeg?auto=compress&cs=tinysrgb&w=800'
        ];
        
        const randomImageIndex = Math.abs(this.service.serviceId * 7) % beautyImages.length;
        return beautyImages[randomImageIndex];
    }

    displayServiceDetails() {
        // Hide loading and error states
        document.getElementById('loading-state').classList.add('hidden');
        document.getElementById('error-state').classList.add('hidden');
        
        // Show service content
        const serviceContent = document.getElementById('service-content');
        serviceContent.classList.remove('hidden');

        // Update page title and breadcrumb
        document.title = `${this.service.name} - Spa Hương Sen`;
        document.getElementById('breadcrumb-service-name').textContent = this.service.name;

        // Update service information
        const serviceImage = this.service.imageUrl || this.getDefaultServiceImage();
        document.getElementById('service-image').src = serviceImage;
        document.getElementById('service-image').alt = this.service.name;
        
        document.getElementById('service-name').textContent = this.service.name;
        document.getElementById('service-description').textContent = this.service.description || 'Dịch vụ chăm sóc sắc đẹp chuyên nghiệp';
        
        // Format price
        const formattedPrice = new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(this.service.price);
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
        // Add to cart button (only if user is authenticated)
        const addToCartBtn = document.getElementById('add-to-cart-btn');
        if (addToCartBtn) {
            addToCartBtn.addEventListener('click', () => {
                this.addToCart();
            });
        }
    }

    addToCart() {
        if (!this.service) return;

        const serviceData = {
            serviceId: this.service.serviceId,
            serviceName: this.service.name,
            serviceImage: this.service.imageUrl || this.getDefaultServiceImage(),
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
        if (typeof window.showNotification === 'function') {
            window.showNotification(message, type);
        } else {
            alert(message);
        }
    }
}

// Initialize service details manager when script loads
const serviceDetailsManager = new ServiceDetailsManager();

// Export for use in other scripts if needed
window.ServiceDetailsManager = ServiceDetailsManager;
window.serviceDetailsManagerInstance = serviceDetailsManager;
