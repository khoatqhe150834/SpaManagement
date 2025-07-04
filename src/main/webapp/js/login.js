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
        this.rememberMeCheckbox = document.getElementById('remember-me');

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
        this.handlePrefill();
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

        const emailRegex = /^[a-zA-Z0-9][a-zA-Z0-9._%+-]*@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
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
        
        if (isLoading) {
            // Add loading state
            this.submitBtn.classList.add('cursor-not-allowed', 'opacity-75');
            this.submitBtn.style.transform = 'scale(0.98)';
            this.submitBtn.querySelector('.btn-text').textContent = 'Đang xử lý...';
            
            // Create and add spinner if it doesn't exist
            let spinner = this.submitBtn.querySelector('.btn-spinner');
            if (!spinner) {
                spinner = document.createElement('div');
                spinner.className = 'btn-spinner inline-block w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin mr-2';
                this.submitBtn.insertBefore(spinner, this.submitBtn.querySelector('.btn-text'));
            }
            spinner.classList.remove('hidden');
        } else {
            // Remove loading state
            this.submitBtn.classList.remove('cursor-not-allowed', 'opacity-75');
            this.submitBtn.style.transform = '';
            this.submitBtn.querySelector('.btn-text').textContent = 'Đăng nhập';
            
            const spinner = this.submitBtn.querySelector('.btn-spinner');
            if (spinner) {
                spinner.classList.add('hidden');
            }
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
        const rememberMe = this.rememberMeCheckbox.checked;
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

    handlePrefill() {
        // First try to prefill from remember-me cookie data
        const rememberedEmail = this.form.dataset.rememberedEmail;
        const rememberedPassword = this.form.dataset.rememberedPassword;
        const rememberMeChecked = this.form.dataset.rememberMeChecked === 'true';

        if (rememberedEmail) {
            this.emailInput.value = rememberedEmail;
            if (rememberedPassword) {
                this.passwordInput.value = rememberedPassword;
            }
            if (rememberMeChecked) {
                this.rememberMeCheckbox.checked = true;
            }
        }

        // Then try session-based prefill (this will override cookie-based if present)
        handlePrefillCredentials({
            emailFieldSelector: '#email',
            passwordFieldSelector: '#password',
            rememberMeSelector: '#remember-me',
            notificationCallback: (message, type) => {
                const notification = document.getElementById('notification');
                if (notification) {
                    notification.textContent = message;
                    notification.className = `notification ${type}`;
                    notification.classList.add('show');
                    setTimeout(() => notification.classList.remove('show'), 5000);
                }
            }
        });
    }
}

document.addEventListener('DOMContentLoaded', () => {
    if (document.getElementById('login-form')) {
        const loginPage = new LoginPage();

        if (typeof handlePrefillCredentials === 'function') {
            // Check for a specific message from a previous flow (e.g., password reset)
            const prefillMessage = sessionStorage.getItem('prefill_message');
            
            const prefillResult = handlePrefillCredentials({
                emailFieldSelector: '#email',
                passwordFieldSelector: '#password',
                rememberMeSelector: '#remember-me',
                notificationCallback: (message, type) => {
                    const finalMessage = prefillMessage || message; // Use specific message if available
                    if (typeof window.showNotification === 'function') {
                        window.showNotification(finalMessage, type);
                    } else {
                        // Final fallback is console, no more alerts.
                        console.log(`Notification (${type}): ${finalMessage}`);
                    }
                }
            });

            if (prefillResult.emailFilled) {
                loginPage.validateEmail(true);
            }
            if (prefillResult.passwordFilled) {
                loginPage.validatePassword(true);
                loginPage.submitBtn.focus();
            } else if (prefillResult.emailFilled) {
                loginPage.passwordInput.focus();
            }
        }
    }
}); 