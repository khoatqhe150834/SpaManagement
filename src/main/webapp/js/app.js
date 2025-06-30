// Main JavaScript file for Spa Website

class SpaApp {
    constructor() {
        this.currentSlide = 0;
        this.isAutoPlaying = true;
        this.autoPlayInterval = null;
        this.slides = [];
        this.slideData = [
            {
                title: "Spa Cao Cấp<br><span class='text-primary'>Nâng Niu Vẻ Đẹp</span><br>Tự Nhiên",
                description: "Trải nghiệm không gian thư giãn đẳng cấp với các liệu pháp chăm sóc sắc đẹp dành riêng cho phụ nữ Việt Nam"
            },
            {
                title: "Massage Thư Giãn<br><span class='text-primary'>Phục Hồi Năng Lượng</span><br>Tự Nhiên",
                description: "Thư giãn hoàn toàn với các kỹ thuật massage truyền thống kết hợp tinh dầu thảo dược quý hiếm"
            },
            {
                title: "Chăm Sóc Da Mặt<br><span class='text-primary'>Làn Da Rạng Rỡ</span><br>Tự Nhiên",
                description: "Phục hồi và nuôi dưỡng làn da với các liệu pháp chăm sóc da cao cấp và sản phẩm hữu cơ"
            },
            {
                title: "Tắm Trắng Thảo Dược<br><span class='text-primary'>Vẻ Đẹp Tỏa Sáng</span><br>Từ Bên Trong",
                description: "Làm trắng da tự nhiên với các thảo dược quý hiếm và công nghệ chăm sóc da tiên tiến"
            }
        ];

        this.init();
    }

    async init() {
        await this.loadSharedComponents(); // Load header/footer first
        this.initDOM();
        this.initHeroSlider();
        this.initMobileMenu();
        this.initScrollAnimations();
        this.initLucideIcons();
        this.initEventListeners();
    }

    async loadSharedComponents() {
        const headerContainer = document.getElementById('header-container');
        const footerContainer = document.getElementById('footer-container');

        try {
            // Fetch and load header
            if (headerContainer) {
                const headerResponse = await fetch('components/header.html');
                headerContainer.innerHTML = await headerResponse.text();
            }

            // Fetch and load footer
            if (footerContainer) {
                const footerResponse = await fetch('components/footer.html');
                footerContainer.innerHTML = await footerResponse.text();
            }
            
            this.updateAuthLinks();
            this.setActiveNavLink();

        } catch (error) {
            console.error('Error loading shared components:', error);
        }
    }

    updateAuthLinks() {
        const loggedOutLinks = document.getElementById('auth-links-logged-out');
        const loggedInLinks = document.getElementById('auth-links-logged-in');
        const dashboardLink = document.getElementById('dashboard-link');

        if (Auth.isAuthenticated()) {
            const user = Auth.getUser();
            loggedOutLinks.classList.add('hidden');
            loggedInLinks.classList.remove('hidden');
            
            // Set the correct dashboard link based on role
            const roleToDashboardMap = {
                'admin': 'admin-dashboard.html',
                'manager': 'manager-dashboard.html',
                'customer': 'customer-dashboard.html',
                'therapist': 'therapist-dashboard.html',
                'marketing': 'marketing-dashboard.html'
            };
            dashboardLink.href = roleToDashboardMap[user.role] || 'login.html';

        } else {
            loggedOutLinks.classList.remove('hidden');
            loggedInLinks.classList.add('hidden');
        }
    }
    
    setActiveNavLink() {
        const currentPage = window.location.pathname.split('/').pop();
        const navLinks = document.querySelectorAll('.nav-link');
        
        navLinks.forEach(link => {
            if (link.getAttribute('href') === currentPage) {
                link.classList.add('text-blue-700', 'dark:text-white');
                link.classList.remove('text-gray-900', 'dark:text-gray-400');
            }
        });
    }

    initDOM() {
        // Cache DOM elements
        this.heroSlider = document.getElementById('hero-slider');
        this.heroTitle = document.getElementById('hero-title');
        this.heroDescription = document.getElementById('hero-description');
        this.mobileMenuBtn = document.getElementById('mobile-menu-btn');
        this.mobileMenu = document.getElementById('mobile-menu');
        this.prevSlideBtn = document.getElementById('prev-slide');
        this.nextSlideBtn = document.getElementById('next-slide');
        this.sliderDots = document.querySelectorAll('.slider-dot');
        this.slides = document.querySelectorAll('.hero-slide');
    }

    initHeroSlider() {
        if (!this.heroSlider) return;

        // Start auto-play
        this.startAutoPlay();

        // Initialize slider dots
        this.updateSliderDots();
        this.updateSlideContent();
    }

    initMobileMenu() {
        if (!this.mobileMenuBtn || !this.mobileMenu) return;

        this.mobileMenuBtn.addEventListener('click', () => {
            this.mobileMenu.classList.toggle('hidden');
        });

        // Close mobile menu when clicking outside
        document.addEventListener('click', (e) => {
            if (!this.mobileMenuBtn.contains(e.target) && !this.mobileMenu.contains(e.target)) {
                this.mobileMenu.classList.add('hidden');
            }
        });
    }

    initScrollAnimations() {
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                }
            });
        }, observerOptions);

        // Observe fade-in elements
        document.querySelectorAll('.fade-in').forEach(el => {
            observer.observe(el);
        });
    }

    initLucideIcons() {
        // Initialize Lucide icons when available
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
    }

    initEventListeners() {
        // Hero slider controls
        if (this.prevSlideBtn) {
            this.prevSlideBtn.addEventListener('click', () => this.prevSlide());
        }

        if (this.nextSlideBtn) {
            this.nextSlideBtn.addEventListener('click', () => this.nextSlide());
        }

        // Slider dots
        this.sliderDots.forEach((dot, index) => {
            dot.addEventListener('click', () => this.goToSlide(index));
        });

        // Smooth scrolling for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Window resize handler
        window.addEventListener('resize', () => {
            this.handleResize();
        });

        // Keyboard navigation for slider
        document.addEventListener('keydown', (e) => {
            if (e.key === 'ArrowLeft') this.prevSlide();
            if (e.key === 'ArrowRight') this.nextSlide();
        });

        document.addEventListener('scroll', SpaApp.throttle(() => {
            const header = document.querySelector('header nav'); // Target the nav inside the header
            if (!header) return;
            const currentScroll = window.pageYOffset;
            if (currentScroll > 50) {
                header.classList.add('scrolled');
            } else {
                header.classList.remove('scrolled');
            }
        }, 100));
    }

    startAutoPlay() {
        this.autoPlayInterval = setInterval(() => {
            if (this.isAutoPlaying) {
                this.nextSlide();
            }
        }, 5000);
    }

    stopAutoPlay() {
        if (this.autoPlayInterval) {
            clearInterval(this.autoPlayInterval);
            this.autoPlayInterval = null;
        }
        this.isAutoPlaying = false;
        
        // Resume after 10 seconds
        setTimeout(() => {
            this.isAutoPlaying = true;
            this.startAutoPlay();
        }, 10000);
    }

    nextSlide() {
        this.currentSlide = (this.currentSlide + 1) % this.slides.length;
        this.updateSlider();
        this.stopAutoPlay();
    }

    prevSlide() {
        this.currentSlide = (this.currentSlide - 1 + this.slides.length) % this.slides.length;
        this.updateSlider();
        this.stopAutoPlay();
    }

    goToSlide(index) {
        this.currentSlide = index;
        this.updateSlider();
        this.stopAutoPlay();
    }

    updateSlider() {
        // Update slide visibility
        this.slides.forEach((slide, index) => {
            if (index === this.currentSlide) {
                slide.classList.remove('inactive');
                slide.classList.add('active');
            } else {
                slide.classList.remove('active');
                slide.classList.add('inactive');
            }
        });

        // Update content
        this.updateSlideContent();
        this.updateSliderDots();
    }

    updateSlideContent() {
        if (this.heroTitle && this.heroDescription && this.slideData[this.currentSlide]) {
            const slideData = this.slideData[this.currentSlide];
            this.heroTitle.innerHTML = slideData.title;
            this.heroDescription.textContent = slideData.description;
        }
    }

    updateSliderDots() {
        this.sliderDots.forEach((dot, index) => {
            if (index === this.currentSlide) {
                dot.classList.remove('bg-white/50');
                dot.classList.add('bg-white');
            } else {
                dot.classList.remove('bg-white');
                dot.classList.add('bg-white/50');
            }
        });
    }

    handleResize() {
        // Handle responsive behavior
        if (window.innerWidth < 768) {
            this.mobileMenu.classList.add('hidden');
        }
    }

    // Utility methods
    static showNotification(message, type = 'info') {
        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.textContent = message;
        
        document.body.appendChild(notification);
        
        // Show notification
        setTimeout(() => notification.classList.add('show'), 100);
        
        // Hide and remove notification
        setTimeout(() => {
            notification.classList.remove('show');
            setTimeout(() => document.body.removeChild(notification), 300);
        }, 5000);
    }

    static formatCurrency(amount) {
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(amount);
    }

    static formatDate(date) {
        return new Intl.DateTimeFormat('vi-VN', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        }).format(new Date(date));
    }

    static validateEmail(email) {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(email);
    }

    static validatePhone(phone) {
        const re = /^(\+84|84|0)[1-9][0-9]{8}$/;
        return re.test(phone.replace(/\s/g, ''));
    }

    static debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }

    static throttle(func, limit) {
        let inThrottle;
        return function() {
            const args = arguments;
            const context = this;
            if (!inThrottle) {
                func.apply(context, args);
                inThrottle = true;
                setTimeout(() => inThrottle = false, limit);
            }
        };
    }
}

// Form validation utilities
class FormValidator {
    constructor(form) {
        this.form = form;
        this.errors = {};
    }

    validateField(field, rules) {
        const value = field.value.trim();
        const fieldName = field.name || field.id;
        let isValid = true;

        // Clear previous errors
        delete this.errors[fieldName];
        field.classList.remove('error');
        
        const errorElement = field.parentNode.querySelector('.form-error');
        if (errorElement) {
            errorElement.remove();
        }

        // Apply validation rules
        if (rules.required && !value) {
            this.addError(field, fieldName, 'Trường này là bắt buộc');
            isValid = false;
        } else if (value) {
            if (rules.email && !SpaApp.validateEmail(value)) {
                this.addError(field, fieldName, 'Email không hợp lệ');
                isValid = false;
            }
            
            if (rules.phone && !SpaApp.validatePhone(value)) {
                this.addError(field, fieldName, 'Số điện thoại không hợp lệ');
                isValid = false;
            }
            
            if (rules.minLength && value.length < rules.minLength) {
                this.addError(field, fieldName, `Tối thiểu ${rules.minLength} ký tự`);
                isValid = false;
            }
            
            if (rules.maxLength && value.length > rules.maxLength) {
                this.addError(field, fieldName, `Tối đa ${rules.maxLength} ký tự`);
                isValid = false;
            }
        }

        return isValid;
    }

    addError(field, fieldName, message) {
        this.errors[fieldName] = message;
        field.classList.add('error');
        
        const errorElement = document.createElement('div');
        errorElement.className = 'form-error';
        errorElement.textContent = message;
        field.parentNode.appendChild(errorElement);
    }

    isValid() {
        return Object.keys(this.errors).length === 0;
    }
}

// Local Storage utilities
class StorageManager {
    static set(key, value) {
        try {
            localStorage.setItem(key, JSON.stringify(value));
        } catch (error) {
            console.error('Error saving to localStorage:', error);
        }
    }

    static get(key, defaultValue = null) {
        try {
            const item = localStorage.getItem(key);
            return item ? JSON.parse(item) : defaultValue;
        } catch (error) {
            console.error('Error reading from localStorage:', error);
            return defaultValue;
        }
    }

    static remove(key) {
        try {
            localStorage.removeItem(key);
        } catch (error) {
            console.error('Error removing from localStorage:', error);
        }
    }

    static clear() {
        try {
            localStorage.clear();
        } catch (error) {
            console.error('Error clearing localStorage:', error);
        }
    }
}

class Auth {
    static login(user, rememberMe) {
        const storage = rememberMe ? localStorage : sessionStorage;
        storage.setItem('user', JSON.stringify(user));
    }

    static logout() {
        localStorage.removeItem('user');
        sessionStorage.removeItem('user');
        window.location.href = 'login.html';
    }

    static getUser() {
        const userStr = localStorage.getItem('user') || sessionStorage.getItem('user');
        return userStr ? JSON.parse(userStr) : null;
    }

    static isAuthenticated() {
        return this.getUser() !== null;
    }

    static getRole() {
        const user = this.getUser();
        return user ? user.role : null;
    }

    static protectRoute(allowedRoles = []) {
        if (!this.isAuthenticated()) {
            window.location.href = 'login.html';
            return;
        }

        if (allowedRoles.length > 0 && !allowedRoles.includes(this.getRole())) {
            window.location.href = '404.html'; // Or a dedicated 'unauthorized' page
        }
    }
}

// Initialize the app when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Initialize the main app
    window.spaApp = new SpaApp();
    
    // Make utilities globally available
    window.SpaApp = SpaApp;
    window.FormValidator = FormValidator;
    window.StorageManager = StorageManager;
    
    console.log('Spa website initialized successfully!');
}); 