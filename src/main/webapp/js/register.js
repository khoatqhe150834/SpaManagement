class RegisterPage {
    constructor() {
        this.form = document.getElementById('register-form');
        if (!this.form) return;

        this.fullNameInput = document.getElementById('fullName');
        this.emailInput = document.getElementById('email');
        this.passwordInput = document.getElementById('password');
        this.confirmPasswordInput = document.getElementById('confirmPassword');
        this.agreeTermsCheckbox = document.getElementById('agreeTerms');
        
        this.togglePasswordBtn = document.getElementById('toggle-password');
        this.toggleConfirmPasswordBtn = document.getElementById('toggle-confirm-password');

        this.submitBtn = document.getElementById('submit-btn');

        this.init();
    }

    init() {
        lucide.createIcons();
        this.initEventListeners();
    }

    initEventListeners() {
        this.form.addEventListener('submit', (e) => this.handleSubmit(e));
        
        this.togglePasswordBtn.addEventListener('click', () => this.togglePasswordVisibility(this.passwordInput, this.togglePasswordBtn));
        this.toggleConfirmPasswordBtn.addEventListener('click', () => this.togglePasswordVisibility(this.confirmPasswordInput, this.toggleConfirmPasswordBtn));

        this.fullNameInput.addEventListener('input', () => this.validateFullName());
        this.fullNameInput.addEventListener('blur', () => this.validateFullName(true));

        this.emailInput.addEventListener('input', () => this.validateEmail());
        this.emailInput.addEventListener('blur', () => this.validateEmail(true));

        this.passwordInput.addEventListener('input', () => {
            this.validatePassword();
            this.validateConfirmPassword();
        });
        this.passwordInput.addEventListener('blur', () => {
            this.validatePassword(true);
        });

        this.confirmPasswordInput.addEventListener('input', () => this.validateConfirmPassword());
        this.confirmPasswordInput.addEventListener('blur', () => this.validateConfirmPassword(true));
        
        this.agreeTermsCheckbox.addEventListener('change', () => this.validateAgreeTerms());
    }

    togglePasswordVisibility(input, button) {
        const type = input.getAttribute('type') === 'password' ? 'text' : 'password';
        input.setAttribute('type', type);
        button.innerHTML = type === 'password' 
            ? '<i data-lucide="eye" class="h-5 w-5 text-gray-400 hover:text-gray-600"></i>' 
            : '<i data-lucide="eye-off" class="h-5 w-5 text-gray-400 hover:text-gray-600"></i>';
        lucide.createIcons();
    }
    
    setError(input, errorElement, message) {
        input.classList.remove('border-green-600', 'focus:ring-green-600');
        input.classList.add('border-red-600', 'focus:ring-red-600');
        errorElement.textContent = message;
        errorElement.classList.remove('hidden');
    }

    setSuccess(input, errorElement, show = false) {
        input.classList.remove('border-red-600', 'focus:ring-red-600');
        errorElement.textContent = '';
        errorElement.classList.add('hidden');
        if (show) {
            input.classList.add('border-green-600', 'focus:ring-green-600');
        }
    }

    validateFullName(showSuccess = false) {
        const errorElement = this.fullNameInput.parentElement.nextElementSibling;
        if (this.fullNameInput.value.trim() === '') {
            this.setError(this.fullNameInput, errorElement, 'Vui lòng nhập họ tên.');
            return false;
        }
        this.setSuccess(this.fullNameInput, errorElement, showSuccess);
        return true;
    }

    validateEmail(showSuccess = false) {
        const errorElement = this.emailInput.parentElement.nextElementSibling;
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
        const password = this.passwordInput.value;
        const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$/;

        if (!passwordRegex.test(password)) {
            this.setError(this.passwordInput, errorElement, 'Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường và số.');
            return false;
        }
        this.setSuccess(this.passwordInput, errorElement, showSuccess);
        return true;
    }

    validateConfirmPassword(showSuccess = false) {
        const errorElement = this.confirmPasswordInput.parentElement.nextElementSibling;

        if (this.passwordInput.value !== this.confirmPasswordInput.value) {
            this.setError(this.confirmPasswordInput, errorElement, 'Mật khẩu không khớp.');
            return false;
        }
        
        if (this.confirmPasswordInput.value.trim() === '') {
            this.setError(this.confirmPasswordInput, errorElement, 'Vui lòng xác nhận mật khẩu.');
            return false;
        }

        this.setSuccess(this.confirmPasswordInput, errorElement, showSuccess);
        return true;
    }

    validateAgreeTerms() {
        const errorElement = document.getElementById('agreeTermsError');
        if (!this.agreeTermsCheckbox.checked) {
            errorElement.textContent = 'Vui lòng đồng ý với điều khoản.';
            errorElement.classList.remove('hidden');
            return false;
        }
        errorElement.textContent = '';
        errorElement.classList.add('hidden');
        return true;
    }
    
    setLoading(isLoading) {
        this.submitBtn.disabled = isLoading;
        this.submitBtn.querySelector('.btn-text').classList.toggle('hidden', isLoading);
        this.submitBtn.querySelector('.btn-spinner').classList.toggle('hidden', !isLoading);
    }
    
    async handleSubmit(e) {
        e.preventDefault();
        
        const isFullNameValid = this.validateFullName(true);
        const isEmailValid = this.validateEmail(true);
        const isPasswordValid = this.validatePassword(true);
        const isConfirmPasswordValid = this.validateConfirmPassword(true);
        const isTermsAgreed = this.validateAgreeTerms();

        if (!isFullNameValid || !isEmailValid || !isPasswordValid || !isConfirmPasswordValid || !isTermsAgreed) {
            return;
        }

        this.setLoading(true);
        
        await new Promise(resolve => setTimeout(resolve, 1600));

        this.setLoading(false);
        const notification = document.getElementById('notification');
        if (notification) {
            notification.textContent = 'Đăng ký thành công! Chuyển hướng đến trang đăng nhập...';
            notification.className = 'notification success show';
            setTimeout(() => {
                notification.className = 'notification success';
            }, 3000);
        }
        
        setTimeout(() => {
            window.location.href = this.form.querySelector('a[href*="login"]').href;
        }, 2000);
    }
}

document.addEventListener('DOMContentLoaded', () => {
    if (document.getElementById('register-form')) {
        new RegisterPage();
    }
});