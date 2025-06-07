/**
 * Reset Password Validation
 * Handles email validation and form submission for reset password form
 */
$(document).ready(function() {
    let emailCheckTimeout;
    let isEmailValid = false;
    
    // Get context path for AJAX requests
    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2)) || '';
    
    // Email input element
    const emailInput = $('#emailInput');
    const emailMessage = $('#emailInputMessage');
    const submitBtn = $('#submitBtn');
    
    // Email validation function
    function validateEmail(email) {
        const emailRegex = /^[A-Za-z0-9+_.-]+@(.+)$/;
        return emailRegex.test(email);
    }
    
    // Show validation message
    function showMessage(message, isSuccess = false) {
        emailMessage.html(message).show();
        if (isSuccess) {
            emailMessage.removeClass('error-message').addClass('success-message');
            emailInput.removeClass('error').addClass('success');
        } else {
            emailMessage.removeClass('success-message').addClass('error-message');
            emailInput.removeClass('success').addClass('error');
        }
    }
    
    // Hide validation message
    function hideMessage() {
        emailMessage.hide();
        emailInput.removeClass('error success');
    }
    
    // Update submit button state
    function updateSubmitButton() {
        if (isEmailValid) {
            submitBtn.prop('disabled', false).removeClass('disabled');
        } else {
            submitBtn.prop('disabled', true).addClass('disabled');
        }
    }
    
    // AJAX email existence check
    function checkEmailExists(email) {
        $.ajax({
            url: contextPath + '/reset-password',
            type: 'GET',
            data: {
                ajax: 'checkEmail',
                email: email
            },
            dataType: 'json',
            timeout: 5000,
            success: function(response) {
                if (response.exists) {
                    showMessage('<i class="fa fa-check-circle"></i> ' + response.message, true);
                    isEmailValid = true;
                } else {
                    showMessage('<i class="fa fa-exclamation-triangle"></i> ' + response.message, false);
                    isEmailValid = false;
                }
                updateSubmitButton();
            },
            error: function(xhr, status, error) {
                console.error('AJAX Error:', error);
                if (status === 'timeout') {
                    showMessage('<i class="fa fa-exclamation-triangle"></i> Kiểm tra email quá lâu, vui lòng thử lại', false);
                } else {
                    showMessage('<i class="fa fa-exclamation-triangle"></i> Lỗi kết nối, vui lòng thử lại', false);
                }
                isEmailValid = false;
                updateSubmitButton();
            }
        });
    }
    
    // Email input event handler
    emailInput.on('input', function() {
        const email = $(this).val().trim();
        
        // Clear previous timeout
        clearTimeout(emailCheckTimeout);
        
        // Reset state
        isEmailValid = false;
        updateSubmitButton();
        
        if (email === '') {
            hideMessage();
            return;
        }
        
        // Check email format first
        if (!validateEmail(email)) {
            showMessage('<i class="fa fa-exclamation-triangle"></i> Định dạng email không hợp lệ', false);
            return;
        }
        
        // Show loading message
        showMessage('<i class="fa fa-spinner fa-spin"></i> Đang kiểm tra email...', false);
        
        // Debounce AJAX call (wait 800ms after user stops typing)
        emailCheckTimeout = setTimeout(function() {
            checkEmailExists(email);
        }, 800);
    });
    
    // Form submission handler
    $('#resetPasswordForm').on('submit', function(e) {
        const email = emailInput.val().trim();
        
        if (email === '') {
            e.preventDefault();
            showMessage('<i class="fa fa-exclamation-triangle"></i> Vui lòng nhập địa chỉ email', false);
            emailInput.focus();
            return false;
        }
        
        if (!validateEmail(email)) {
            e.preventDefault();
            showMessage('<i class="fa fa-exclamation-triangle"></i> Định dạng email không hợp lệ', false);
            emailInput.focus();
            return false;
        }
        
        if (!isEmailValid) {
            e.preventDefault();
            showMessage('<i class="fa fa-exclamation-triangle"></i> Email không tồn tại trong hệ thống', false);
            emailInput.focus();
            return false;
        }
        
        // Show loading state
        submitBtn.html('<i class="fa fa-spinner fa-spin"></i> Đang gửi...').prop('disabled', true);
        
        return true;
    });
    
    // Initial state
    updateSubmitButton();
    
    // Focus on email input when page loads
    emailInput.focus();
}); 