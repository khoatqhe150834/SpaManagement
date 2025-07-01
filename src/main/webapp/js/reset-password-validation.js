class ResetPasswordPage {
    constructor() {
        this.form = document.getElementById('reset-password-form');
        if (!this.form) return;

        this.newPasswordInput = document.getElementById('newPassword');
        this.confirmPasswordInput = document.getElementById('confirmPassword');
        
        this.toggleNewPasswordBtn = document.getElementById('toggle-new-password');
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
        
        // Password visibility toggles
        if (this.toggleNewPasswordBtn) {
            this.toggleNewPasswordBtn.addEventListener('click', () => 
                this.togglePasswordVisibility(this.newPasswordInput, this.toggleNewPasswordBtn));
        }
        
        if (this.toggleConfirmPasswordBtn) {
            this.toggleConfirmPasswordBtn.addEventListener('click', () => 
                this.togglePasswordVisibility(this.confirmPasswordInput, this.toggleConfirmPasswordBtn));
        }

        // Real-time validation for password fields
        if (this.newPasswordInput) {
            this.newPasswordInput.addEventListener('input', () => this.validateNewPassword());
        }
        
        if (this.confirmPasswordInput) {
            this.confirmPasswordInput.addEventListener('input', () => this.validateConfirmPassword());
        }
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
        if (errorElement) {
            errorElement.textContent = message;
            errorElement.classList.remove('hidden');
        }
    }

    setSuccess(input, errorElement, showSuccess = false) {
        input.classList.remove('border-red-600', 'focus:ring-red-600');
        if (errorElement) {
            errorElement.textContent = '';
            errorElement.classList.add('hidden');
        }
        if (showSuccess) {
            input.classList.add('border-green-600', 'focus:ring-green-600');
        }
    }

    validateNewPassword(showSuccess = false) {
        const errorElement = document.getElementById('newPasswordError');
        const password = this.newPasswordInput.value;

        if (password.trim() === '') {
            this.setError(this.newPasswordInput, errorElement, 'Vui lòng nhập mật khẩu mới.');
            return false;
        }

        if (password.length < 6) {
            this.setError(this.newPasswordInput, errorElement, 'Mật khẩu phải có ít nhất 6 ký tự.');
            return false;
        }

        // Check for basic password strength
        if (password.length < 8) {
            // Optional: Add warning for weak passwords but don't fail validation
            // You can customize this based on your password policy
        }

        this.setSuccess(this.newPasswordInput, errorElement, showSuccess);
        
        // Re-validate confirm password if it has a value
        if (this.confirmPasswordInput.value) {
            this.validateConfirmPassword();
        }
        
        return true;
    }

    validateConfirmPassword(showSuccess = false) {
        const errorElement = document.getElementById('confirmPasswordError');
        const confirmPassword = this.confirmPasswordInput.value;
        const newPassword = this.newPasswordInput.value;

        if (confirmPassword.trim() === '') {
            this.setError(this.confirmPasswordInput, errorElement, 'Vui lòng xác nhận mật khẩu.');
            return false;
        }

        if (confirmPassword !== newPassword) {
            this.setError(this.confirmPasswordInput, errorElement, 'Mật khẩu xác nhận không khớp.');
            return false;
        }

        this.setSuccess(this.confirmPasswordInput, errorElement, showSuccess);
        return true;
    }

    setLoading(isLoading) {
        this.submitBtn.disabled = isLoading;
        const btnText = this.submitBtn.querySelector('.btn-text');
        const btnSpinner = this.submitBtn.querySelector('.btn-spinner');
        
        if (isLoading) {
            btnText.classList.add('hidden');
            btnSpinner.classList.remove('hidden');
        } else {
            btnText.classList.remove('hidden');
            btnSpinner.classList.add('hidden');
        }
    }

    async handleSubmit(e) {
        e.preventDefault();

        // Validate all fields
        const isNewPasswordValid = this.validateNewPassword(true);
        const isConfirmPasswordValid = this.validateConfirmPassword(true);

        if (!isNewPasswordValid || !isConfirmPasswordValid) {
            // Focus on the first invalid field
            if (!isNewPasswordValid) {
                this.newPasswordInput.focus();
            } else if (!isConfirmPasswordValid) {
                this.confirmPasswordInput.focus();
            }
            return;
        }

        this.setLoading(true);

        try {
            const formData = new URLSearchParams();
            formData.append('newPassword', this.newPasswordInput.value);
            formData.append('confirmPassword', this.confirmPasswordInput.value);

            const response = await fetch(this.form.action, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: formData
            });

            const data = await response.json();

            if (response.ok) {
                // Success response
                if (data.success) {
                    this.showNotification(data.success, 'success');
                    
                    // Redirect after showing success message
                    setTimeout(() => {
                        window.location.href = data.redirect || '/spa/login';
                    }, 1500);
                } else {
                    // Unexpected success response format
                    this.showNotification('Mật khẩu đã được thay đổi thành công!', 'success');
                    setTimeout(() => {
                        window.location.href = '/spa/login';
                    }, 1500);
                }
            } else {
                // Error response
                if (data.error) {
                    this.showNotification(data.error, 'error');
                    
                    // If there's a redirect for errors (like session expired)
                    if (data.redirect) {
                        setTimeout(() => {
                            window.location.href = data.redirect;
                        }, 2000);
                    }
                } else {
                    this.showNotification('Có lỗi xảy ra. Vui lòng thử lại.', 'error');
                }
            }
        } catch (error) {
            console.error('Reset password error:', error);
            
            // Check if the error is due to invalid JSON response
            if (error instanceof SyntaxError && error.message.includes('JSON')) {
                // Server returned HTML instead of JSON, likely a redirect or server error page
                this.showNotification('Có lỗi kết nối xảy ra. Đang tải lại trang...', 'error');
                setTimeout(() => {
                    window.location.reload();
                }, 1500);
            } else {
                this.showNotification('Có lỗi xảy ra. Vui lòng thử lại.', 'error');
            }
        } finally {
            this.setLoading(false);
        }
    }

    showNotification(message, type = 'info') {
        // Use the same notification system as other pages
        if (window.showNotification) {
            window.showNotification(message, type);
        } else {
            // Fallback alert
            alert(message);
        }
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new ResetPasswordPage();
}); 