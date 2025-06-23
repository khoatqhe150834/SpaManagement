/**
 * Password Change Validation
 * Handles real-time validation and form submission for password change form
 */
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('passwordChangeForm');
    const submitBtn = document.getElementById('submitBtn');
    
    // Validation message utility functions
    function showErrorMessage(fieldId, message) {
        const field = document.getElementById(fieldId);
        const messageElement = document.getElementById(fieldId + 'Message');
        
        // Update field styling
        field.style.borderColor = '#f44336';
        field.style.boxShadow = '0 0 5px rgba(244, 67, 54, 0.3)';
        
        // Update message content and styling
        messageElement.innerHTML = '<i class="fa fa-exclamation-circle"></i>' + message;
        messageElement.className = 'validation-message invalid';
        messageElement.style.display = 'block';
    }
    
    function showSuccessMessage(fieldId, message) {
        const field = document.getElementById(fieldId);
        const messageElement = document.getElementById(fieldId + 'Message');
        
        // Update field styling
        field.style.borderColor = '#4CAF50';
        field.style.boxShadow = '0 0 5px rgba(76, 175, 80, 0.3)';
        
        // Update message content and styling
        messageElement.innerHTML = '<i class="fa fa-check-circle"></i>' + message;
        messageElement.className = 'validation-message valid';
        messageElement.style.display = 'block';
    }
    
    function hideMessage(fieldId) {
        const field = document.getElementById(fieldId);
        const messageElement = document.getElementById(fieldId + 'Message');
        
        // Reset field styling
        field.style.borderColor = '';
        field.style.boxShadow = '';
        
        // Hide message
        messageElement.style.display = 'none';
        messageElement.className = 'validation-message';
    }
    
    if (form) {
        // Focus on current password field
        document.getElementById('currentPassword').focus();
        
        // Real-time validation for current password
        document.getElementById('currentPassword').addEventListener('input', function() {
            const currentPassword = this.value.trim();
            
            if (currentPassword === '') {
                hideMessage('currentPassword');
            } else if (currentPassword.length < 6) {
                showErrorMessage('currentPassword', 'Mật khẩu hiện tại phải có ít nhất 6 ký tự');
            } else {
                hideMessage('currentPassword');
            }
        
            // Re-validate new password when current password changes
            const newPassword = document.getElementById('newPassword').value;
            if (newPassword) {
                validateNewPassword();
            }
        });
        
        // Function to validate new password
        function validateNewPassword() {
            const currentPassword = document.getElementById('currentPassword').value;
            const newPassword = document.getElementById('newPassword').value.trim();
            
            if (newPassword === '') {
                hideMessage('newPassword');
            } else if (newPassword.length < 6) {
                showErrorMessage('newPassword', 'Mật khẩu mới phải có ít nhất 6 ký tự');
            } else if (currentPassword && newPassword === currentPassword) {
                showErrorMessage('newPassword', 'Mật khẩu mới phải khác với mật khẩu hiện tại');
            } else {
                showSuccessMessage('newPassword', 'Mật khẩu mới hợp lệ');
            }
            
            // Re-validate confirm password if it has value
            const confirmPassword = document.getElementById('confirmPassword').value;
            if (confirmPassword) {
                validateConfirmPassword();
            }
        }
        
        // Real-time validation for new password
        document.getElementById('newPassword').addEventListener('input', validateNewPassword);
        
        // Real-time validation for confirm password
        function validateConfirmPassword() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (confirmPassword === '') {
                hideMessage('confirmPassword');
            } else if (confirmPassword.length < 6) {
                showErrorMessage('confirmPassword', 'Xác nhận mật khẩu phải có ít nhất 6 ký tự');
            } else if (newPassword !== confirmPassword) {
                showErrorMessage('confirmPassword', 'Xác nhận mật khẩu không khớp với mật khẩu mới');
            } else {
                showSuccessMessage('confirmPassword', 'Xác nhận mật khẩu khớp');
            }
        }
        
        document.getElementById('confirmPassword').addEventListener('input', validateConfirmPassword);
        
        // Form submission validation
        form.addEventListener('submit', function(e) {
            const currentPassword = document.getElementById('currentPassword').value.trim();
            const newPassword = document.getElementById('newPassword').value.trim();
            const confirmPassword = document.getElementById('confirmPassword').value.trim();
            
            let hasErrors = false;
            
            // Validate current password
            if (!currentPassword) {
                showErrorMessage('currentPassword', 'Vui lòng nhập mật khẩu hiện tại');
                hasErrors = true;
            } else if (currentPassword.length < 6) {
                showErrorMessage('currentPassword', 'Mật khẩu hiện tại phải có ít nhất 6 ký tự');
                hasErrors = true;
            }
            
            // Validate new password
            if (!newPassword) {
                showErrorMessage('newPassword', 'Vui lòng nhập mật khẩu mới');
                hasErrors = true;
            } else if (newPassword.length < 6) {
                showErrorMessage('newPassword', 'Mật khẩu mới phải có ít nhất 6 ký tự');
                hasErrors = true;
            } else if (currentPassword === newPassword) {
                showErrorMessage('newPassword', 'Mật khẩu mới phải khác với mật khẩu hiện tại');
                hasErrors = true;
            }
            
            // Validate confirm password
            if (!confirmPassword) {
                showErrorMessage('confirmPassword', 'Vui lòng nhập xác nhận mật khẩu');
                hasErrors = true;
            } else if (confirmPassword.length < 6) {
                showErrorMessage('confirmPassword', 'Xác nhận mật khẩu phải có ít nhất 6 ký tự');
                hasErrors = true;
            } else if (newPassword !== confirmPassword) {
                showErrorMessage('confirmPassword', 'Xác nhận mật khẩu không khớp với mật khẩu mới');
                hasErrors = true;
            }
            
            if (hasErrors) {
                e.preventDefault();
                // Focus on first error field
                const firstErrorField = document.querySelector('.invalid');
                if (firstErrorField && firstErrorField.previousElementSibling) {
                    firstErrorField.previousElementSibling.focus();
                } else {
                    // Fallback: focus on current password field
                    document.getElementById('currentPassword').focus();
                }
                return;
            }
            
            // Show loading state
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> ĐANG XỬ LÝ...';
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