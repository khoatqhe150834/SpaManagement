/**
 * Common Email Validation Utility
 * Provides consistent email validation across all forms in the application
 * Usage: EmailValidator.init(inputSelector, errorSelector, options)
 */
var EmailValidator = (function() {
    'use strict';
    
    // Strict email regex pattern for practical use
    const EMAIL_REGEX = /^[a-zA-Z0-9](?:[a-zA-Z0-9._-]*[a-zA-Z0-9])?@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;
    
    // Default error messages in Vietnamese
    const DEFAULT_MESSAGES = {
        empty: 'Vui lòng nhập địa chỉ email',
        invalid: 'Vui lòng nhập địa chỉ email hợp lệ',
        tooLong: 'Email quá dài (tối đa 254 ký tự)',
        invalidChars: 'Email chỉ được chứa chữ cái, số, dấu chấm, gạch ngang và gạch dưới',
        multipleAt: 'Email phải chứa đúng một ký tự @',
        invalidLocal: 'Phần trước @ không hợp lệ',
        localTooLong: 'Phần trước @ quá dài (tối đa 64 ký tự)',
        invalidDots: 'Email không được bắt đầu hoặc kết thúc bằng dấu chấm',
        invalidHyphens: 'Email không được bắt đầu hoặc kết thúc bằng dấu gạch ngang',
        consecutiveDots: 'Email không được chứa hai dấu chấm liên tiếp',
        invalidDomain: 'Tên miền không hợp lệ',
        domainTooLong: 'Tên miền quá dài',
        noDomainDot: 'Tên miền phải chứa ít nhất một dấu chấm'
    };
    
    // Default options
    const DEFAULT_OPTIONS = {
        messages: DEFAULT_MESSAGES,
        showErrorsImmediately: true,
        preventSpaces: true,
        cleanPaste: true,
        enableRealTimeValidation: true,
        debounceTime: 300,
        cssClasses: {
            error: 'field-error',
            valid: 'field-valid',
            errorMessage: 'field-error-message'
        }
    };
    
    /**
     * Validates email address with comprehensive checks
     * @param {string} email - Email to validate
     * @param {object} messages - Custom error messages
     * @returns {string|null} - Error message or null if valid
     */
    function validateEmail(email, messages) {
        messages = messages || DEFAULT_MESSAGES;
        
        if (!email || email.trim() === '') {
            return messages.empty;
        }
        
        if (email.length > 254) {
            return messages.tooLong;
        }
        
        // Check for spaces specifically (most common invalid character)
        if (/\s/.test(email)) {
            return 'Email không được chứa khoảng trắng';
        }
        
        // Check for invalid characters
        const invalidChars = /[^a-zA-Z0-9@._-]/;
        if (invalidChars.test(email)) {
            return messages.invalidChars;
        }
        
        // Check for multiple @ symbols
        const atCount = (email.match(/@/g) || []).length;
        if (atCount !== 1) {
            return messages.multipleAt;
        }
        
        // Split email into local and domain parts
        const parts = email.split('@');
        const localPart = parts[0];
        const domainPart = parts[1];
        
        // Validate local part (before @)
        if (!localPart || localPart.length === 0) {
            return messages.invalidLocal;
        }
        
        if (localPart.length > 64) {
            return messages.localTooLong;
        }
        
        if (localPart.startsWith('.') || localPart.endsWith('.')) {
            return messages.invalidDots;
        }
        
        if (localPart.startsWith('-') || localPart.endsWith('-')) {
            return messages.invalidHyphens;
        }
        
        if (localPart.indexOf('..') !== -1) {
            return messages.consecutiveDots;
        }
        
        // Validate domain part (after @)
        if (!domainPart || domainPart.length === 0) {
            return messages.invalidDomain;
        }
        
        if (domainPart.length > 253) {
            return messages.domainTooLong;
        }
        
        if (!domainPart.includes('.')) {
            return messages.noDomainDot;
        }
        
        // Final regex check
        if (!EMAIL_REGEX.test(email)) {
            return messages.invalid;
        }
        
        return null; // Valid email
    }
    
    /**
     * Shows error message and applies error styling
     */
    function showError(inputElement, errorElement, message, cssClasses) {
        if (errorElement) {
            errorElement.textContent = message;
            errorElement.style.display = 'block';
            errorElement.className = cssClasses.errorMessage;
        }
        
        inputElement.classList.add(cssClasses.error);
        inputElement.classList.remove(cssClasses.valid);
    }
    
    /**
     * Hides error message and applies valid styling
     */
    function hideError(inputElement, errorElement, cssClasses) {
        if (errorElement) {
            errorElement.style.display = 'none';
            errorElement.textContent = '';
        }
        
        inputElement.classList.remove(cssClasses.error);
        inputElement.classList.add(cssClasses.valid);
    }
    
    /**
     * Clears all validation styling
     */
    function clearValidation(inputElement, errorElement, cssClasses) {
        if (errorElement) {
            errorElement.style.display = 'none';
            errorElement.textContent = '';
        }
        
        inputElement.classList.remove(cssClasses.error, cssClasses.valid);
    }
    
    /**
     * Enhanced space prevention with multiple event types and capture phase
     */
    function preventSpaces(inputElement) {
        // Primary keydown prevention with capture phase
        inputElement.addEventListener('keydown', function(e) {
            if (e.keyCode === 32 || e.key === ' ' || e.code === 'Space') {
                e.preventDefault();
                e.stopPropagation();
                return false;
            }
        }, true);
        
        // Additional keypress prevention
        inputElement.addEventListener('keypress', function(e) {
            if (e.keyCode === 32 || e.key === ' ' || e.code === 'Space') {
                e.preventDefault();
                e.stopPropagation();
                return false;
            }
        }, true);
        
        // Clean spaces from paste
        inputElement.addEventListener('paste', function(e) {
            setTimeout(() => {
                const currentValue = this.value;
                const cleanedValue = currentValue.replace(/\s/g, '');
                if (currentValue !== cleanedValue) {
                    this.value = cleanedValue;
                    // Trigger input event after cleanup
                    this.dispatchEvent(new Event('input', { bubbles: true }));
                }
            }, 0);
        });
        
        // Also prevent drag and drop of text with spaces
        inputElement.addEventListener('drop', function(e) {
            setTimeout(() => {
                const currentValue = this.value;
                const cleanedValue = currentValue.replace(/\s/g, '');
                if (currentValue !== cleanedValue) {
                    this.value = cleanedValue;
                    this.dispatchEvent(new Event('input', { bubbles: true }));
                }
            }, 0);
        });
    }
    
    /**
     * Creates a validator instance for an email input
     * @param {string|Element} inputSelector - CSS selector or DOM element for email input
     * @param {string|Element} errorSelector - CSS selector or DOM element for error display
     * @param {object} options - Configuration options
     * @returns {object} - Validator instance with methods
     */
    function createValidator(inputSelector, errorSelector, options) {
        // Merge options with defaults
        const config = Object.assign({}, DEFAULT_OPTIONS, options || {});
        config.messages = Object.assign({}, DEFAULT_MESSAGES, (options && options.messages) || {});
        
        // Get DOM elements
        const inputElement = typeof inputSelector === 'string' 
            ? document.querySelector(inputSelector) 
            : inputSelector;
            
        const errorElement = errorSelector ? (typeof errorSelector === 'string' 
            ? document.querySelector(errorSelector) 
            : errorSelector) : null;
            
        if (!inputElement) {
            console.error('EmailValidator: Input element not found');
            return null;
        }
        
        let validationTimeout;
        let isValid = false;
        
        // Enhanced space prevention if enabled
        if (config.preventSpaces) {
            preventSpaces(inputElement);
        }
        
        // Real-time validation
        if (config.enableRealTimeValidation) {
            inputElement.addEventListener('input', function() {
                const email = this.value;
                
                // Clear previous timeout
                clearTimeout(validationTimeout);
                
                // Debounce validation
                validationTimeout = setTimeout(() => {
                    const error = validateEmail(email, config.messages);
                    
                    if (error) {
                        if (config.showErrorsImmediately) {
                            showError(inputElement, errorElement, error, config.cssClasses);
                        }
                        isValid = false;
                    } else if (email.trim()) {
                        hideError(inputElement, errorElement, config.cssClasses);
                        isValid = true;
                    } else {
                        clearValidation(inputElement, errorElement, config.cssClasses);
                        isValid = false;
                    }
                    
                    // Trigger custom event for other scripts to listen
                    inputElement.dispatchEvent(new CustomEvent('emailValidation', {
                        detail: { isValid: isValid, error: error, email: email }
                    }));
                    
                }, config.debounceTime);
            });
        }
        
        // Return validator instance with public methods
        return {
            // Validate email and return result
            validate: function() {
                const email = inputElement.value;
                const error = validateEmail(email, config.messages);
                isValid = !error && email.trim() !== '';
                
                if (error) {
                    showError(inputElement, errorElement, error, config.cssClasses);
                } else if (email.trim()) {
                    hideError(inputElement, errorElement, config.cssClasses);
                } else {
                    clearValidation(inputElement, errorElement, config.cssClasses);
                }
                
                return {
                    isValid: isValid,
                    error: error,
                    email: email
                };
            },
            
            // Check if current email is valid
            isValid: function() {
                return isValid;
            },
            
            // Get current email value
            getValue: function() {
                return inputElement.value;
            },
            
            // Clear validation state
            clear: function() {
                clearValidation(inputElement, errorElement, config.cssClasses);
                isValid = false;
            },
            
            // Focus the input
            focus: function() {
                inputElement.focus();
            },
            
            // Set email value
            setValue: function(email) {
                inputElement.value = email || '';
                inputElement.dispatchEvent(new Event('input', { bubbles: true }));
            },
            
            // Get the input element
            getElement: function() {
                return inputElement;
            },
            
            // Get the error element
            getErrorElement: function() {
                return errorElement;
            }
        };
    }
    
    /**
     * Reset Password Form Handler
     * Specialized handler for reset password forms with AJAX email existence checking
     */
    function initResetPasswordForm(options) {
        const config = Object.assign({
            formSelector: '#resetPasswordForm',
            emailInputSelector: '#emailInput',
            errorMessageSelector: '#emailInputMessage',
            submitButtonSelector: '#submitBtn',
            ajaxEndpoint: '/reset-password',
            debounceTime: 800
        }, options || {});
        
        // Wait for DOM ready
        $(document).ready(function() {
            let emailCheckTimeout;
            let isEmailValid = false;
            
            // Get context path for AJAX requests
            const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2)) || '';
            
            // Get elements
            const emailInput = $(config.emailInputSelector);
            const emailMessage = $(config.errorMessageSelector);
            const submitBtn = $(config.submitButtonSelector);
            const form = $(config.formSelector);
            
            if (!emailInput.length || !emailMessage.length || !submitBtn.length || !form.length) {
                console.error('EmailValidator: Reset password form elements not found');
                return;
            }
            
            // Initialize basic email validator
            emailInput.emailValidator(config.errorMessageSelector, {
                debounceTime: 0, // We'll handle our own debouncing for AJAX
                showErrorsImmediately: false, // We'll handle showing errors after AJAX check
                preventSpaces: true,
                cleanPaste: true
            });
            
            // Email format validation (using common validator)
            function isEmailFormatValid(email) {
                const error = validateEmail(email);
                return !error;
            }
            
            // Show validation message with styling
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
                    url: contextPath + config.ajaxEndpoint,
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
            
            // Email input event handler with space validation
            emailInput.on('input', function() {
                const rawEmail = $(this).val();
                const email = rawEmail.trim();
                
                // Clear previous timeout
                clearTimeout(emailCheckTimeout);
                
                // Reset state
                isEmailValid = false;
                updateSubmitButton();
                
                // Check for spaces first (before trim)
                if (rawEmail !== email || /\s/.test(rawEmail)) {
                    showMessage('<i class="fa fa-exclamation-triangle"></i> Email không được chứa khoảng trắng', false);
                    return;
                }
                
                if (email === '') {
                    hideMessage();
                    return;
                }
                
                // Check email format first
                if (!isEmailFormatValid(email)) {
                    showMessage('<i class="fa fa-exclamation-triangle"></i> Định dạng email không hợp lệ', false);
                    return;
                }
                
                // Show loading message
                showMessage('<i class="fa fa-spinner fa-spin"></i> Đang kiểm tra email...', false);
                
                // Debounce AJAX call
                emailCheckTimeout = setTimeout(function() {
                    checkEmailExists(email);
                }, config.debounceTime);
            });
            
            // Form submission handler
            form.on('submit', function(e) {
                const rawEmail = emailInput.val();
                const email = rawEmail.trim();
                
                // Check for spaces first (before trim)
                if (rawEmail !== email || /\s/.test(rawEmail)) {
                    e.preventDefault();
                    showMessage('<i class="fa fa-exclamation-triangle"></i> Email không được chứa khoảng trắng', false);
                    emailInput.focus();
                    return false;
                }
                
                if (email === '') {
                    e.preventDefault();
                    showMessage('<i class="fa fa-exclamation-triangle"></i> Vui lòng nhập địa chỉ email', false);
                    emailInput.focus();
                    return false;
                }
                
                if (!isEmailFormatValid(email)) {
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
            emailInput.focus();
        });
    }

    // Auto-initialize space prevention for any email input on DOM ready
    document.addEventListener('DOMContentLoaded', function() {
        // Auto-prevent spaces for any email input field
        const emailInputs = document.querySelectorAll('input[type="email"]');
        emailInputs.forEach(function(input) {
            preventSpaces(input);
        });
        
        // Special handling for reset password form if it exists
        const resetPasswordForm = document.querySelector('#resetPasswordForm');
        if (resetPasswordForm) {
            const emailInput = document.querySelector('#emailInput');
            if (emailInput) {
                // Enhanced space prevention for reset password form
                preventSpaces(emailInput);
            }
        }
    });

    // Public API
    return {
        // Create a new validator instance
        init: createValidator,
        
        // Static validation method
        validate: validateEmail,
        
        // Initialize reset password form
        initResetPassword: initResetPasswordForm,
        
        // Default configuration
        defaults: DEFAULT_OPTIONS,
        
        // Utility methods
        utils: {
            showError: showError,
            hideError: hideError,
            clearValidation: clearValidation,
            preventSpaces: preventSpaces
        }
    };
})();

// jQuery plugin wrapper (if jQuery is available)
if (typeof jQuery !== 'undefined') {
    (function($) {
        $.fn.emailValidator = function(errorSelector, options) {
            return this.each(function() {
                const validator = EmailValidator.init(this, errorSelector, options);
                $(this).data('emailValidator', validator);
            });
        };
    })(jQuery);
}

// Auto-initialize reset password form if detected
$(document).ready(function() {
    if ($('#resetPasswordForm').length) {
        EmailValidator.initResetPassword();
    }
}); 