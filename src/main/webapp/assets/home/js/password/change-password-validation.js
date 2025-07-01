/**
 * Password Change Validation
 * Handles real-time validation and form submission for password change form
 */
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('passwordChangeForm');
    const submitBtn = document.getElementById('submitBtn');
    
    // Validation utility functions
    function setError(input, errorElement, message) {
        input.classList.remove('border-green-600', 'focus:ring-green-600');
        input.classList.add('border-red-600', 'focus:ring-red-600');
        errorElement.textContent = message;
        errorElement.classList.remove('hidden');
    }

    function setSuccess(input, errorElement, show) {
        input.classList.remove('border-red-600', 'focus:ring-red-600');
        errorElement.textContent = '';
        errorElement.classList.add('hidden');
        if (show) {
            input.classList.add('border-green-600', 'focus:ring-green-600');
        }
    }
    
    if (form) {
        // Focus on current password field
        document.getElementById('currentPassword').focus();
        
        // Real-time validation for current password
        document.getElementById('currentPassword').addEventListener('input', function() {
            validateCurrentPassword();
        });

        document.getElementById('currentPassword').addEventListener('blur', function() {
            validateCurrentPassword(true);
        });
        
        // Function to validate current password
        function validateCurrentPassword(showSuccess = false) {
            const currentPassword = document.getElementById('currentPassword');
            const errorElement = document.getElementById('currentPasswordMessage');
            const value = currentPassword.value.trim();
            
            if (value === '') {
                setError(currentPassword, errorElement, 'Vui lòng nhập mật khẩu hiện tại');
                return false;
            } else if (value.length < 6) {
                setError(currentPassword, errorElement, 'Mật khẩu hiện tại phải có ít nhất 6 ký tự');
                return false;
            }
            
            setSuccess(currentPassword, errorElement, showSuccess);
            return true;
        }
        
        // Function to validate new password
        function validateNewPassword(showSuccess = false) {
            const currentPassword = document.getElementById('currentPassword').value.trim();
            const newPassword = document.getElementById('newPassword');
            const errorElement = document.getElementById('newPasswordMessage');
            const value = newPassword.value.trim();
            
            if (value === '') {
                setError(newPassword, errorElement, 'Vui lòng nhập mật khẩu mới');
                return false;
            } else if (value.length < 6) {
                setError(newPassword, errorElement, 'Mật khẩu mới phải có ít nhất 6 ký tự');
                return false;
            } else if (currentPassword && value === currentPassword) {
                setError(newPassword, errorElement, 'Mật khẩu mới phải khác với mật khẩu hiện tại');
                return false;
            } 
            
            setSuccess(newPassword, errorElement, showSuccess);
            return true;
        }
        
        // Real-time validation for new password
        document.getElementById('newPassword').addEventListener('input', function() {
            validateNewPassword();
        });

        document.getElementById('newPassword').addEventListener('input', function() {
            validateNewPassword(true);
        });
        
        // Function to validate confirm password
        function validateConfirmPassword(showSuccess = false) {
            const newPassword = document.getElementById('newPassword').value.trim();
            const confirmPassword = document.getElementById('confirmPassword');
            const errorElement = document.getElementById('confirmPasswordMessage');
            const value = confirmPassword.value.trim();
            
            if (value === '') {
                setError(confirmPassword, errorElement, 'Vui lòng nhập xác nhận mật khẩu');
                return false;
            } else if (value.length < 6) {
                setError(confirmPassword, errorElement, 'Xác nhận mật khẩu phải có ít nhất 6 ký tự');
                return false;
            } else if (newPassword !== value) {
                setError(confirmPassword, errorElement, 'Xác nhận mật khẩu không khớp với mật khẩu mới');
                return false;
            }
            
            setSuccess(confirmPassword, errorElement, showSuccess);
            return true;
        }
        
        // Real-time validation for confirm password
        document.getElementById('confirmPassword').addEventListener('input', function() {
            validateConfirmPassword();
        });

        document.getElementById('confirmPassword').addEventListener('blur', function() {
            validateConfirmPassword(true);
        });
        
        // Form submission validation
        form.addEventListener('submit', function(e) {
            const isCurrentPasswordValid = validateCurrentPassword(true);
            const isNewPasswordValid = validateNewPassword(true);
            const isConfirmPasswordValid = validateConfirmPassword(true);
            
            if (!isCurrentPasswordValid || !isNewPasswordValid || !isConfirmPasswordValid) {
                e.preventDefault();
                // Focus on first error field
                const firstInvalidField = form.querySelector('.border-red-600');
                if (firstInvalidField) {
                    firstInvalidField.focus();
                } else {
                    document.getElementById('currentPassword').focus();
                }
                return;
            }
            
            // Show loading state
            submitBtn.disabled = true;
            submitBtn.classList.add('cursor-not-allowed', 'opacity-75');
            submitBtn.innerHTML = '<i class="fa fa-spinner fa-spin mr-2"></i>ĐANG XỬ LÝ...';
        });
    }
    
    // Auto-hide alerts after 8 seconds
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            alert.style.transition = 'opacity 0.5s ease';
            alert.style.opacity = '0';
            setTimeout(() => alert.remove(), 500);
        });
    }, 8000);
}); 