class RegisterPage {
    constructor() {
        this.form = document.getElementById('register-form');
        if (!this.form) return;

        this.fullNameInput = document.getElementById('fullName');
        this.phoneInput = document.getElementById('phone');
        this.emailInput = document.getElementById('email');
        this.passwordInput = document.getElementById('password');
        this.confirmPasswordInput = document.getElementById('confirmPassword');
        this.agreeTermsCheckbox = document.getElementById('agreeTerms');
        
        this.togglePasswordBtn = document.getElementById('toggle-password');
        this.toggleConfirmPasswordBtn = document.getElementById('toggle-confirm-password');

        this.submitBtn = document.getElementById('submit-btn');

        this.termsLink = document.getElementById('terms-link');
        this.termsModal = document.getElementById('terms-modal');
        this.closeModalBtn = document.getElementById('close-modal-btn');
        this.acceptTermsBtn = document.getElementById('accept-terms-btn');

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

        // Add blur listener for trimming
        [this.fullNameInput, this.phoneInput, this.emailInput].forEach(input => {
            input.addEventListener('blur', (e) => this.trimOnBlur(e));
        });

        this.fullNameInput.addEventListener('input', () => this.validateFullName());
        
        // Debounce validation for email and phone
        this.emailInput.addEventListener('input', this.debounce(() => this.validateEmail(false, true), 500));
        this.phoneInput.addEventListener('input', this.debounce(() => this.validatePhone(false, true), 500));

        // Add real-time validation for password fields
        this.passwordInput.addEventListener('input', () => this.validatePassword());
        this.confirmPasswordInput.addEventListener('input', () => this.validateConfirmPassword());

        this.agreeTermsCheckbox.addEventListener('change', () => this.validateAgreeTerms());

        // Modal event listeners
        this.termsLink.addEventListener('click', (e) => {
            e.preventDefault();
            this.openModal();
        });
        this.closeModalBtn.addEventListener('click', () => this.closeModal());
        this.acceptTermsBtn.addEventListener('click', () => this.closeModal());
        this.termsModal.addEventListener('click', (e) => {
            if (e.target === this.termsModal) {
                this.closeModal();
            }
        });
    }

    togglePasswordVisibility(input, button) {
        const type = input.getAttribute('type') === 'password' ? 'text' : 'password';
        input.setAttribute('type', type);
        button.innerHTML = type === 'password' 
            ? '<i data-lucide="eye" class="h-5 w-5 text-gray-400 hover:text-gray-600"></i>' 
            : '<i data-lucide="eye-off" class="h-5 w-5 text-gray-400 hover:text-gray-600"></i>';
        lucide.createIcons();
    }
    
    sanitizeInput(inputElement) {
        let value = inputElement.value;
        // Collapse multiple spaces into a single space
        value = value.replace(/\s\s+/g, ' ');
        // For all but password fields, we can also trim in real-time if desired,
        // but trimming on blur is often a better UX. Let's stick to that.
        inputElement.value = value;
    }

    trimOnBlur(event) {
        const input = event.target;
        input.value = input.value.trim();
    }

    setError(input, errorElement, message) {
        input.classList.remove('border-green-600', 'focus:ring-green-600');
        input.classList.add('border-red-600', 'focus:ring-red-600');
        if (errorElement) {
            errorElement.textContent = message;
            errorElement.classList.remove('hidden');
        }
    }

    setSuccess(input, errorElement, show = false) {
        input.classList.remove('border-red-600', 'focus:ring-red-600');
        if (errorElement) {
            errorElement.textContent = '';
            errorElement.classList.add('hidden');
        }
        if (show) {
            input.classList.add('border-green-600', 'focus:ring-green-600');
        }
    }

    validateFullName(showSuccess = false) {
        this.sanitizeInput(this.fullNameInput);
        const value = this.fullNameInput.value.trim();
        const errorElement = document.getElementById('fullNameError');
        if (value === '') {
            this.setError(this.fullNameInput, errorElement, 'Vui lòng nhập họ tên.');
            return false;
        }
        this.setSuccess(this.fullNameInput, errorElement, showSuccess);
        return true;
    }

    async validatePhone(showSuccess = false, checkAvailable = false) {
        this.sanitizeInput(this.phoneInput);
        const value = this.phoneInput.value.trim();
        const errorElement = document.getElementById('phoneError');
        const phoneRegex = /^0\d{9}$/;

        if (value === '') {
            this.setError(this.phoneInput, errorElement, 'Vui lòng nhập số điện thoại.');
            return false;
        }
        if (!phoneRegex.test(value)) {
            this.setError(this.phoneInput, errorElement, 'Số điện thoại phải bắt đầu bằng 0 và có đúng 10 chữ số.');
            return false;
        }
        if (checkAvailable) {
            const isTaken = await this.checkAvailability('phone', value);
            if (isTaken) {
                this.setError(this.phoneInput, errorElement, 'Số điện thoại này đã được đăng ký.');
                return false;
            }
        }
        this.setSuccess(this.phoneInput, errorElement, showSuccess);
        return true;
    }

    async validateEmail(showSuccess = false, checkAvailable = false) {
        this.sanitizeInput(this.emailInput);
        const value = this.emailInput.value.trim();
        const errorElement = document.getElementById('emailError');
        
        if (value === '') {
            this.setError(this.emailInput, errorElement, 'Vui lòng nhập email.');
            return false;
        }

        const emailRegex = /^[a-zA-Z0-9][a-zA-Z0-9._%+-]*@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (!emailRegex.test(value)) {
            this.setError(this.emailInput, errorElement, 'Email không hợp lệ.');
            return false;
        }
         if (checkAvailable) {
            const isTaken = await this.checkAvailability('email', value);
            if (isTaken) {
                this.setError(this.emailInput, errorElement, 'Email này đã được đăng ký.');
                return false;
            }
        }
        this.setSuccess(this.emailInput, errorElement, showSuccess);
        return true;
    }

    validatePassword(showSuccess = false) {
        const errorElement = document.getElementById('passwordError');
        const password = this.passwordInput.value;

        console.log('Validating Password Field:');
        console.log('  - Password Value:', `"${password}"`);
        console.log('  - Error Element:', errorElement);

        if (password.trim() === '') {
            console.log('  - Result: FAIL (empty)');
            this.setError(this.passwordInput, errorElement, 'Vui lòng nhập mật khẩu.');
            return false;
        }

        const passwordRegex = /^.{6,}$/;
        if (!passwordRegex.test(password)) {
            console.log('  - Result: FAIL (too short)');
            this.setError(this.passwordInput, errorElement, 'Mật khẩu phải có ít nhất 6 ký tự.');
            return false;
        }

        console.log('  - Result: SUCCESS');
        this.setSuccess(this.passwordInput, errorElement, showSuccess);
        return true;
    }

    validateConfirmPassword(showSuccess = false) {
        const errorElement = document.getElementById('confirmPasswordError');
        const confirmPassword = this.confirmPasswordInput.value;
        
        console.log('Validating Confirm Password Field:');
        console.log('  - Confirm Password Value:', `"${confirmPassword}"`);
        console.log('  - Error Element:', errorElement);

        if (confirmPassword.trim() === '') {
            console.log('  - Result: FAIL (empty)');
            this.setError(this.confirmPasswordInput, errorElement, 'Vui lòng xác nhận mật khẩu.');
            return false;
        }

        if (this.passwordInput.value !== confirmPassword) {
            console.log('  - Result: FAIL (mismatch)');
            this.setError(this.confirmPasswordInput, errorElement, 'Mật khẩu không khớp.');
            return false;
        }
        
        console.log('  - Result: SUCCESS');
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
        
        // Run all validations and wait for them to complete
        const validations = await Promise.all([
            this.validateFullName(true),
            
            this.validatePassword(true),
            this.validateConfirmPassword(true),
            this.validateAgreeTerms(),
            this.validatePhone(true, true),
            this.validateEmail(true, true),
        ]);
        
        const isFormValid = validations.every(isValid => isValid);

        if (!isFormValid) {
            return;
        }

        this.setLoading(true);
        
        try {
            const formData = new FormData(this.form);
            const response = await fetch('register', {
                method: 'POST',
                body: new URLSearchParams(formData)
            });

            const result = await response.json();

            if (result.success) {
                 window.location.href = result.redirectUrl;
            } else {
                SpaApp.showNotification(result.message || 'Đăng ký thất bại, vui lòng thử lại.', 'error');
            }
        } catch (error) {
             SpaApp.showNotification('Không thể kết nối đến máy chủ.', 'error');
        } finally {
            this.setLoading(false);
        }
    }

    openModal() {
        this.termsModal.classList.add('flex');
        this.termsModal.classList.remove('hidden');
        lucide.createIcons(); // Re-initialize icons when modal opens
    }

    closeModal() {
        this.termsModal.classList.add('hidden');
        this.termsModal.classList.remove('flex');
    }

    async checkAvailability(field, value) {
        try {
            const response = await fetch(`register?validate=${field}&value=${encodeURIComponent(value)}`);
            const data = await response.json();
            return data.isDuplicate;
        } catch (error) {
            console.error('Availability check failed:', error);
            return false; // Fail safe, assume it's not taken
        }
    }

    debounce(func, delay) {
        let timeout;
        return (...args) => {
            clearTimeout(timeout);
            timeout = setTimeout(() => {
                func.apply(this, args);
            }, delay);
        };
    }
}

document.addEventListener('DOMContentLoaded', () => {
    if (document.getElementById('register-form')) {
        new RegisterPage();
    }
});