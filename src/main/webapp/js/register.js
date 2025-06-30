// js/register.js

class RegisterPage {
    constructor() {
        this.form = document.getElementById('register-form');
        this.fullNameInput = document.getElementById('fullName');
        this.emailInput = document.getElementById('email');
        this.passwordInput = document.getElementById('password');
        this.confirmPasswordInput = document.getElementById('confirmPassword');
        this.agreeTermsCheckbox = document.getElementById('agreeTerms');
        this.togglePasswordBtns = document.querySelectorAll('.toggle-password');
        this.submitBtn = document.getElementById('submit-btn');

        this.init();
    }

    init() {
        lucide.createIcons();
        this.initEventListeners();
    }

    initEventListeners() {
        this.form.addEventListener('submit', (e) => this.handleSubmit(e));
        
        this.togglePasswordBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                const input = btn.previousElementSibling;
                this.togglePasswordVisibility(input, btn);
            });
        });

        // Clear errors on input
        this.fullNameInput.addEventListener('input', () => FormValidator.clearError(this.fullNameInput));
        this.emailInput.addEventListener('input', () => FormValidator.clearError(this.emailInput));
        this.passwordInput.addEventListener('input', () => FormValidator.clearError(this.passwordInput));
        this.confirmPasswordInput.addEventListener('input', () => FormValidator.clearError(this.confirmPasswordInput));
        this.agreeTermsCheckbox.addEventListener('change', () => FormValidator.clearError(this.agreeTermsCheckbox, 'agreeTerms-error'));
    }

    togglePasswordVisibility(input, button) {
        const type = input.getAttribute('type') === 'password' ? 'text' : 'password';
        input.setAttribute('type', type);
        button.innerHTML = type === 'password' 
            ? '<i data-lucide="eye" class="h-5 w-5 text-gray-400 hover:text-gray-600"></i>' 
            : '<i data-lucide="eye-off" class="h-5 w-5 text-gray-400 hover:text-gray-600"></i>';
        lucide.createIcons();
    }
    
    setLoading(isLoading) {
        this.submitBtn.disabled = isLoading;
        this.submitBtn.querySelector('.btn-text').classList.toggle('hidden', isLoading);
        this.submitBtn.querySelector('.btn-spinner').classList.toggle('hidden', !isLoading);
    }
    
    async handleSubmit(e) {
        e.preventDefault();
        
        const isFullNameValid = FormValidator.validateRequired(this.fullNameInput, 'Vui lòng nhập họ tên.');
        const isEmailValid = FormValidator.validateEmail(this.emailInput, 'Vui lòng nhập email hợp lệ.');
        const isPasswordValid = FormValidator.validatePassword(this.passwordInput, 'Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường và số.');
        const isConfirmPasswordValid = FormValidator.validatePasswordMatch(this.passwordInput, this.confirmPasswordInput, 'Mật khẩu không khớp.');
        const isTermsAgreed = FormValidator.validateCheckbox(this.agreeTermsCheckbox, 'Vui lòng đồng ý với điều khoản.', 'agreeTerms-error');

        if (!isFullNameValid || !isEmailValid || !isPasswordValid || !isConfirmPasswordValid || !isTermsAgreed) {
            return;
        }

        this.setLoading(true);
        
        // Simulate API call
        await new Promise(resolve => setTimeout(resolve, 1500));

        this.setLoading(false);
        SpaApp.showNotification('Đăng ký thành công! Chuyển hướng đến trang đăng nhập...', 'success');
        
        setTimeout(() => {
            window.location.href = 'login.html';
        }, 2000);
    }
}

document.addEventListener('DOMContentLoaded', () => {
    if (document.getElementById('register-form')) {
        new RegisterPage();
    }
}); 