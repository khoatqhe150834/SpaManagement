// js/login.js

class LoginPage {
    constructor() {
        this.form = document.getElementById('login-form');
        if (!this.form) return;

        this.emailInput = document.getElementById('email');
        this.passwordInput = document.getElementById('password');
        this.togglePasswordBtn = document.getElementById('toggle-password');
        this.errorMessageContainer = document.getElementById('error-message');
        this.submitBtn = document.getElementById('submit-btn');

        this.demoUsers = {
            'admin@spahuongsen.vn': { password: 'password123', role: 'admin', redirect: 'admin-dashboard.html', name: 'Jane Admin' },
            'manager@spahuongsen.vn': { password: 'password123', role: 'manager', redirect: 'manager-dashboard.html', name: 'Mike Manager' },
            'marketing@spahuongsen.vn': { password: 'password123', role: 'marketing', redirect: 'marketing-dashboard.html', name: 'Maria Spark' },
            'therapist@spahuongsen.vn': { password: 'password123', role: 'therapist', redirect: 'therapist-dashboard.html', name: 'Anna Lee' },
            'customer@spahuongsen.vn': { password: 'password123', role: 'customer', redirect: 'customer-dashboard.html', name: 'John Doe' }
        };

        this.init();
    }

    init() {
        lucide.createIcons();
        this.initEventListeners();
    }

    initEventListeners() {
        this.form.addEventListener('submit', (e) => this.handleSubmit(e));
        this.togglePasswordBtn.addEventListener('click', () => this.togglePasswordVisibility());
        
        this.emailInput.addEventListener('input', () => this.validateEmail());
        this.emailInput.addEventListener('blur', () => this.validateEmail(true));
        
        this.passwordInput.addEventListener('input', () => this.validatePassword());
        this.passwordInput.addEventListener('blur', () => this.validatePassword(true));
    }

    validateEmail(showSuccess = false) {
        const errorElement = this.emailInput.parentElement.nextElementSibling;
        
        if (this.emailInput.value.trim() === '') {
            this.setError(this.emailInput, errorElement, 'Vui lòng nhập email.');
            return false;
        }

        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(this.emailInput.value)) {
            this.setError(this.emailInput, errorElement, 'Email không hợp lệ.');
            return false;
        }

        this.setSuccess(this.emailInput, errorElement, showSuccess);
        return true;
    }

    validatePassword(showSuccess = false) {
        const errorElement = this.passwordInput.parentElement.nextElementSibling;

        if (this.passwordInput.value.trim() === '') {
            this.setError(this.passwordInput, errorElement, 'Vui lòng nhập mật khẩu.');
            return false;
        }
        
        if (this.passwordInput.value.length < 6) {
             this.setError(this.passwordInput, errorElement, 'Mật khẩu phải có ít nhất 6 ký tự.');
             return false;
        }

        this.setSuccess(this.passwordInput, errorElement, showSuccess);
        return true;
    }

    setError(input, errorElement, message) {
        input.classList.remove('border-green-600', 'focus:ring-green-600');
        input.classList.add('border-red-600', 'focus:ring-red-600');
        errorElement.textContent = message;
        errorElement.classList.remove('hidden');
    }

    setSuccess(input, errorElement, show) {
        input.classList.remove('border-red-600', 'focus:ring-red-600');
        errorElement.textContent = '';
        errorElement.classList.add('hidden');
        if (show) {
            input.classList.add('border-green-600', 'focus:ring-green-600');
        }
    }

    togglePasswordVisibility() {
        const type = this.passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        this.passwordInput.setAttribute('type', type);
        this.togglePasswordBtn.innerHTML = type === 'password' 
            ? '<i data-lucide="eye" class="h-5 w-5 text-gray-400 hover:text-gray-600"></i>' 
            : '<i data-lucide="eye-off" class="h-5 w-5 text-gray-400 hover:text-gray-600"></i>';
        lucide.createIcons();
    }

    showGlobalError(message) {
        this.errorMessageContainer.querySelector('p').innerHTML = message;
        this.errorMessageContainer.classList.remove('hidden');
    }

    hideGlobalError() {
        this.errorMessageContainer.classList.add('hidden');
    }
    
    setLoading(isLoading) {
        this.submitBtn.disabled = isLoading;
        this.submitBtn.querySelector('.btn-text').classList.toggle('hidden', isLoading);
        this.submitBtn.querySelector('.btn-spinner').classList.toggle('hidden', !isLoading);
        if(isLoading) {
            this.submitBtn.classList.add('cursor-not-allowed');
        } else {
            this.submitBtn.classList.remove('cursor-not-allowed');
        }
    }
    
    async handleSubmit(e) {
        e.preventDefault();
        this.hideGlobalError();

        const isEmailValid = this.validateEmail(true);
        const isPasswordValid = this.validatePassword(true);

        if (!isEmailValid || !isPasswordValid) return;
        
        this.setLoading(true);

        const formData = new FormData(this.form);
        const rememberMe = document.getElementById('remember-me').checked;
        formData.set('rememberMe', rememberMe);

        try {
            const response = await fetch(this.form.action, {
                method: 'POST',
                body: new URLSearchParams(formData)
            });

            const result = await response.json();

            if (response.ok && result.success) {
                window.location.href = result.redirectUrl;
            } else {
                let message = result.message;
                if (result.verificationRequired) {
                    const resendLink = `email-verification-required?email=${encodeURIComponent(result.email)}`;
                    message += ` <a href="${resendLink}" class="font-bold underline hover:text-red-600">Gửi lại email?</a>`;
                }
                this.showGlobalError(message);
            }
        } catch (error) {
            this.showGlobalError('Đã xảy ra lỗi kết nối. Vui lòng thử lại.');
        } finally {
            this.setLoading(false);
        }
    }
}

document.addEventListener('DOMContentLoaded', () => {
    if (document.getElementById('login-form')) {
        new LoginPage();
    }
}); 