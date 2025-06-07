/**
 * Reset Password Validation
 * Handles email validation and form submission for reset password form
 */
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('resetPasswordForm');
    const submitBtn = document.getElementById('submitBtn');
    const emailInput = document.getElementById('emailInput');
    
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
        emailInput.focus();
        
        // Real-time email validation
        emailInput.addEventListener('input', function() {
            const email = this.value.trim();
            
            if (email === '') {
                hideMessage('emailInput');
            } else if (!isValidEmail(email)) {
                showErrorMessage('emailInput', 'Định dạng email không hợp lệ');
            } else {
                showSuccessMessage('emailInput', 'Email hợp lệ');
            }
        });
        
        // Email field blur validation
        emailInput.addEventListener('blur', function() {
            const email = this.value.trim();
            
            if (email === '') {
                hideMessage('emailInput');
            } else if (!isValidEmail(email)) {
                showErrorMessage('emailInput', 'Vui lòng nhập địa chỉ email hợp lệ');
            } else {
                showSuccessMessage('emailInput', 'Email hợp lệ');
            }
        });
        
        // Form submission validation
        form.addEventListener('submit', function(e) {
            const email = emailInput.value.trim();
            
            if (!email) {
                e.preventDefault();
                showErrorMessage('emailInput', 'Vui lòng nhập địa chỉ email');
                emailInput.focus();
                return;
            }
            
            if (!isValidEmail(email)) {
                e.preventDefault();
                showErrorMessage('emailInput', 'Vui lòng nhập địa chỉ email hợp lệ');
                emailInput.focus();
                return;
            }
            
            // Show loading state
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<div class="loading-spinner"></div><i class="fa fa-spinner fa-spin"></i> ĐANG GỬI...';
        });
    }
    
    function isValidEmail(email) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    }
    
    // Auto-hide alerts
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            if (!alert.classList.contains('alert-success')) {
                alert.style.transition = 'opacity 0.5s ease';
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 500);
            }
        });
    }, 8000);
}); 