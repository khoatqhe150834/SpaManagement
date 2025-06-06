/**
 * Registration Form Validation
 * Handles real-time validation, duplicate checking, and form submission for registration page
 */
$(document).ready(function() {
    // Get context path from a hidden input or meta tag (will be set in JSP)
    const contextPath = $('meta[name="context-path"]').attr('content') || '';

    // Validation state object
    const validationState = {
        fullName: false,
        phone: false,
        email: false,
        password: false,
        confirmPassword: false
    };

    // Vietnamese name pattern (includes Vietnamese characters and spaces)
    const vietnameseNamePattern = /^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s]{6,100}$/;
    
    // Vietnamese phone pattern (starts with 0 and specific prefixes)
    const vietnamesePhonePattern = /^(0[3|5|7|8|9])+([0-9]{8})$/;
    
    // Email pattern
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    
    // Password pattern (at least 6 characters)
    const passwordPattern = /^.{6,30}$/;

    // AJAX duplicate checking functions
    function checkEmailDuplicate(email, callback) {
        if (!email || email.trim() === '') {
            callback(false, 'Email không được để trống');
            return;
        }
        
        $.ajax({
            url: contextPath + '/register',
            type: 'GET',
            data: {
                validate: 'email',
                value: email.trim()
            },
            dataType: 'json',
            timeout: 5000,
            success: function(response) {
                callback(response.valid, response.message);
            },
            error: function() {
                callback(false, 'Không thể kiểm tra email. Vui lòng thử lại.');
            }
        });
    }

    function checkPhoneDuplicate(phone, callback) {
        if (!phone || phone.trim() === '') {
            callback(false, 'Số điện thoại không được để trống');
            return;
        }
        
        $.ajax({
            url: contextPath + '/register',
            type: 'GET',
            data: {
                validate: 'phone',
                value: phone.trim()
            },
            dataType: 'json',
            timeout: 5000,
            success: function(response) {
                callback(response.valid, response.message);
            },
            error: function() {
                callback(false, 'Không thể kiểm tra số điện thoại. Vui lòng thử lại.');
            }
        });
    }

    // Validation functions
    function validateFullName() {
        const fullName = $('#fullName').val().trim();
        const field = $('#fullName');
        
        if (fullName === '') {
            showError(field, 'Họ tên không được để trống.');
            return false;
        } else if (fullName.length < 6) {
            showError(field, 'Họ tên phải có ít nhất 6 ký tự.');
            return false;
        } else if (fullName.length > 100) {
            showError(field, 'Họ tên không được vượt quá 100 ký tự.');
            return false;
        } else if (!vietnameseNamePattern.test(fullName)) {
            showError(field, 'Họ tên chỉ được chứa chữ cái và khoảng trắng.');
            return false;
        } else {
            showSuccess(field, 'Họ tên hợp lệ.');
            return true;
        }
    }

    function validatePhone(callback) {
        const phone = $('#phone').val().trim();
        const field = $('#phone');
        
        if (phone === '') {
            showError(field, 'Số điện thoại không được để trống.');
            if (callback) callback(false);
            return false;
        } else if (!vietnamesePhonePattern.test(phone)) {
            showError(field, 'Số điện thoại phải bắt đầu bằng 03, 05, 07, 08, 09 và có 10 chữ số.');
            if (callback) callback(false);
            return false;
        } else {
            // Check for duplicates
            showLoading(field, 'Đang kiểm tra số điện thoại...');
            checkPhoneDuplicate(phone, function(isValid, message) {
                if (isValid) {
                    showSuccess(field, message);
                } else {
                    showError(field, message);
                }
                if (callback) callback(isValid);
            });
            return true; // Basic validation passed, AJAX will determine final result
        }
    }

    function validateEmail(callback) {
        const email = $('#email').val().trim();
        const field = $('#email');
        
        if (email === '') {
            showError(field, 'Email không được để trống.');
            if (callback) callback(false);
            return false;
        } else if (!emailPattern.test(email)) {
            showError(field, 'Định dạng email không hợp lệ.');
            if (callback) callback(false);
            return false;
        } else if (email.length > 255) {
            showError(field, 'Email không được vượt quá 255 ký tự.');
            if (callback) callback(false);
            return false;
        } else {
            // Check for duplicates
            showLoading(field, 'Đang kiểm tra email...');
            checkEmailDuplicate(email, function(isValid, message) {
                if (isValid) {
                    showSuccess(field, message);
                } else {
                    showError(field, message);
                }
                if (callback) callback(isValid);
            });
            return true; // Basic validation passed, AJAX will determine final result
        }
    }

    function validatePassword() {
        const password = $('#password').val();
        const field = $('#password');
        
        if (password === '') {
            showError(field, 'Mật khẩu không được để trống.');
            return false;
        } else if (password.length < 6) {
            showError(field, 'Mật khẩu phải có ít nhất 6 ký tự.');
            return false;
        } else if (password.length > 30) {
            showError(field, 'Mật khẩu không được vượt quá 30 ký tự.');
            return false;
        } else {
            showSuccess(field, 'Mật khẩu hợp lệ.');
            // Re-validate confirm password if it has been entered
            if ($('#confirmPassword').val() !== '') {
                validateConfirmPassword();
            }
            return true;
        }
    }

    function validateConfirmPassword() {
        const password = $('#password').val();
        const confirmPassword = $('#confirmPassword').val();
        const field = $('#confirmPassword');
        
        if (confirmPassword === '') {
            showError(field, 'Vui lòng nhập lại mật khẩu.');
            return false;
        } else if (password !== confirmPassword) {
            showError(field, 'Mật khẩu nhập lại không khớp.');
            return false;
        } else {
            showSuccess(field, 'Mật khẩu khớp.');
            return true;
        }
    }

    function showError(field, message) {
        field.removeClass('is-valid is-loading').addClass('is-invalid');
        field.parent().find('.error').remove();
        field.parent().find('.success').remove();
        field.parent().find('.loading').remove();
        field.parent().append('<span class="error">' + message + '</span>');
    }

    function showSuccess(field, message) {
        field.removeClass('is-invalid is-loading').addClass('is-valid');
        field.parent().find('.error').remove();
        field.parent().find('.success').remove();
        field.parent().find('.loading').remove();
        field.parent().append('<span class="success">' + message + '</span>');
    }

    function showLoading(field, message) {
        field.removeClass('is-invalid is-valid').addClass('is-loading');
        field.parent().find('.error').remove();
        field.parent().find('.success').remove();
        field.parent().find('.loading').remove();
        field.parent().append('<span class="loading" style="color: #ffa500;">' + message + '</span>');
    }

    function clearValidation(field) {
        field.removeClass('is-invalid is-valid is-loading');
        field.parent().find('.error').remove();
        field.parent().find('.success').remove();
        field.parent().find('.loading').remove();
    }

    function updateValidationState(callback) {
        let validationCount = 0;
        let totalValidations = 5;
        
        // Synchronous validations
        validationState.fullName = validateFullName();
        validationState.password = validatePassword();
        validationState.confirmPassword = validateConfirmPassword();
        validationCount += 3;
        
        // Asynchronous validations
        validatePhone(function(isValid) {
            validationState.phone = isValid;
            validationCount++;
            if (validationCount === totalValidations && callback) callback();
        });
        
        validateEmail(function(isValid) {
            validationState.email = isValid;
            validationCount++;
            if (validationCount === totalValidations && callback) callback();
        });
    }

    function isFormValid() {
        return Object.values(validationState).every(state => state === true);
    }

    // Event listeners for real-time validation
    $('#fullName').on('blur', function() {
        validationState.fullName = validateFullName();
    });

    $('#fullName').on('input', function() {
        if ($(this).hasClass('is-invalid') || $(this).hasClass('is-valid')) {
            validationState.fullName = validateFullName();
        }
    });

    $('#phone').on('blur', function() {
        validatePhone(function(isValid) {
            validationState.phone = isValid;
        });
    });

    $('#phone').on('input', function() {
        // Only re-validate basic format on input, not duplicate check
        const phone = $(this).val().trim();
        const field = $(this);
        
        if ($(this).hasClass('is-invalid') || $(this).hasClass('is-valid')) {
            if (phone === '') {
                showError(field, 'Số điện thoại không được để trống.');
                validationState.phone = false;
            } else if (!vietnamesePhonePattern.test(phone)) {
                showError(field, 'Số điện thoại phải bắt đầu bằng 03, 05, 07, 08, 09 và có 10 chữ số.');
                validationState.phone = false;
            } else {
                clearValidation(field);
                // Don't trigger duplicate check on input, only on blur
            }
        }
    });

    $('#email').on('blur', function() {
        validateEmail(function(isValid) {
            validationState.email = isValid;
        });
    });

    $('#email').on('input', function() {
        // Only re-validate basic format on input, not duplicate check
        const email = $(this).val().trim();
        const field = $(this);
        
        if ($(this).hasClass('is-invalid') || $(this).hasClass('is-valid')) {
            if (email === '') {
                showError(field, 'Email không được để trống.');
                validationState.email = false;
            } else if (!emailPattern.test(email)) {
                showError(field, 'Định dạng email không hợp lệ.');
                validationState.email = false;
            } else if (email.length > 255) {
                showError(field, 'Email không được vượt quá 255 ký tự.');
                validationState.email = false;
            } else {
                clearValidation(field);
                // Don't trigger duplicate check on input, only on blur
            }
        }
    });

    $('#password').on('blur', function() {
        validationState.password = validatePassword();
    });

    $('#password').on('input', function() {
        if ($(this).hasClass('is-invalid') || $(this).hasClass('is-valid')) {
            validationState.password = validatePassword();
        }
    });

    $('#confirmPassword').on('blur', function() {
        validationState.confirmPassword = validateConfirmPassword();
    });

    $('#confirmPassword').on('input', function() {
        if ($(this).hasClass('is-invalid') || $(this).hasClass('is-valid')) {
            validationState.confirmPassword = validateConfirmPassword();
        }
    });

    // Form submission validation
    $('#registerForm').on('submit', function(e) {
        e.preventDefault(); // Always prevent initial submission
        
        const form = this;
        const submitButton = $(form).find('button[type="submit"]');
        
        // Check current validation state without triggering loading states
        const currentValidState = {
            fullName: validateFullName(),
            password: validatePassword(),
            confirmPassword: validateConfirmPassword(),
            phone: validationState.phone,
            email: validationState.email
        };
        
        // If email or phone haven't been validated yet, focus on them
        if (!$('#email').hasClass('is-valid') && !$('#email').hasClass('is-invalid')) {
            $('#email').focus();
            return;
        }
        
        if (!$('#phone').hasClass('is-valid') && !$('#phone').hasClass('is-invalid')) {
            $('#phone').focus();
            return;
        }
        
        // Check if all fields are valid
        const allValid = Object.values(currentValidState).every(state => state === true);
        
        if (!allValid) {
            // Focus on first invalid field
            const fields = ['#fullName', '#phone', '#email', '#password', '#confirmPassword'];
            const states = [currentValidState.fullName, currentValidState.phone, currentValidState.email, currentValidState.password, currentValidState.confirmPassword];
            
            for (let i = 0; i < fields.length; i++) {
                if (!states[i]) {
                    $(fields[i]).focus();
                    break;
                }
            }
            
            return false;
        }
        
        // All validation passed, submit the form
        submitButton.prop('disabled', true).text('Đang đăng ký...');
        form.submit();
    });

    // Prevent form submission with Enter key unless all fields are valid
    $('#registerForm input').on('keypress', function(e) {
        if (e.which === 13) { // Enter key
            e.preventDefault();
            $(this).blur(); // Trigger validation
            
            // If current field is valid, move to next field
            const currentField = $(this);
            const allFields = $('#registerForm input[type="text"], #registerForm input[type="email"], #registerForm input[type="password"]');
            const currentIndex = allFields.index(currentField);
            
            if (currentIndex < allFields.length - 1) {
                allFields.eq(currentIndex + 1).focus();
            } else {
                // Last field, try to submit if all valid
                updateValidationState();
                if (isFormValid()) {
                    $('#registerForm').submit();
                }
            }
        }
    });

    // Initialize validation state
    Object.keys(validationState).forEach(key => {
        validationState[key] = false;
    });
}); 