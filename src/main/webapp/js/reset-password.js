document.addEventListener('DOMContentLoaded', function () {
    const COOLDOWN_SECONDS = 60;

    // --- Element Selectors ---
    const form = document.getElementById('forgotPasswordForm');
    if (!form) return; // Exit if the form is not on the page
    
    const emailInput = document.getElementById('email');
    const emailError = document.getElementById('email-error');
    const emailSuccess = document.getElementById('email-success');
    const emailValidIcon = document.getElementById('email-valid-icon');
    const emailInvalidIcon = document.getElementById('email-invalid-icon');
    const emailValidationIcon = document.getElementById('email-validation-icon');
    const formErrorContainer = document.getElementById('form-error-container');
    const formErrorMessage = document.getElementById('form-error-message');
    
    const submitButton = document.getElementById('submit-button');
    const buttonText = document.getElementById('button-text');
    const loadingSpinner = document.getElementById('loading-spinner');

    const formView = document.getElementById('reset-form-view');
    const successView = document.getElementById('success-view');
    const sentEmailAddress = document.getElementById('sent-email-address');
    
    const resendButton = document.getElementById('resend-button');

    let emailCheckTimeout;
    const DEBOUNCE_DELAY = 500; // ms

    // --- Helper Functions ---
    function validateEmail(email) {
        const re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(String(email).toLowerCase());
    }

    function showFormError(message) {
        formErrorMessage.textContent = message;
        formErrorContainer.classList.remove('hidden');
    }

    function clearFormError() {
        formErrorContainer.classList.add('hidden');
        emailError.classList.add('hidden');
        emailInput.classList.remove('border-red-500');
    }
            
    function setLoadingState(isLoading) {
        submitButton.disabled = isLoading;
        if (isLoading) {
            buttonText.classList.add('hidden');
            loadingSpinner.classList.remove('hidden');
        } else {
            buttonText.classList.remove('hidden');
            loadingSpinner.classList.add('hidden');
        }
    }

    function showSuccessView(email) {
        sentEmailAddress.textContent = email;
        formView.classList.add('hidden');
        successView.classList.remove('hidden');
        localStorage.setItem('resetEmail', email); // Store email for cooldown persistence
        
        const countdownManager = new CountdownManager({
            countdownSectionId: 'countdown-section',
            resendSectionId: 'resend-section',
            countdownTimerId: 'countdown-timer',
            storageKey: 'resetCooldownEnd',
            duration: COOLDOWN_SECONDS,
            onFinish: () => {
                const resendButton = document.getElementById('resend-button');
                resendButton.disabled = false;
            }
        });
        countdownManager.start();
    }

    // --- Main Logic ---
    async function doPasswordReset() {
        clearFormError();
        // Prioritize email from input, fallback to localStorage for resend functionality
        let email = emailInput.value.trim() || localStorage.getItem('resetEmail');

        if (!email || !validateEmail(email)) {
            // If there's still no valid email, something is wrong.
            // Show the main form with an error.
            successView.classList.add('hidden');
            formView.classList.remove('hidden');
            showFormError('Không thể gửi lại email. Vui lòng nhập lại địa chỉ email của bạn.');
            localStorage.removeItem('resetCooldownEnd');
            localStorage.removeItem('resetEmail');
            return;
        }

        // Use different loading indicators for initial submit vs. resend
        const isResend = formView.classList.contains('hidden'); // If form is hidden, we're resending
        if (!isResend) {
            setLoadingState(true);
        } else {
            resendButton.disabled = true;
            resendButton.innerHTML = `<div class="animate-spin rounded-full h-5 w-5 border-b-2 border-primary mx-auto"></div>`;
        }

        const resetUrl = form.dataset.resetUrl;

        try {
            const response = await fetch(resetUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'email=' + encodeURIComponent(email)
            });

            const result = await response.json();

            if (response.ok) {
                showSuccessView(email);
            } else {
                successView.classList.add('hidden');
                formView.classList.remove('hidden');
                showFormError(result.message || 'Đã có lỗi xảy ra. Vui lòng thử lại.');
            }
        } catch (error) {
            console.error('Password reset error:', error);
            successView.classList.add('hidden');
            formView.classList.remove('hidden');
            showFormError('Lỗi kết nối. Vui lòng kiểm tra lại mạng của bạn.');
        } finally {
            if (!isResend) {
                setLoadingState(false);
            } else {
                // Reset the resend button text - countdown manager will handle the rest
                resendButton.innerHTML = 'Gửi lại email';
                resendButton.disabled = false;
            }
        }
    }

    // --- Cooldown Logic ---
    function checkInitialCooldown() {
        const cooldownEndTime = localStorage.getItem('resetCooldownEnd');
        if (!cooldownEndTime) return;
        
        const now = new Date().getTime();
        const secondsLeft = Math.round((parseInt(cooldownEndTime, 10) - now) / 1000);

        if (secondsLeft > 0) {
            const storedEmail = localStorage.getItem('resetEmail');
            if(storedEmail) {
                 sentEmailAddress.textContent = storedEmail;
            }
            formView.classList.add('hidden');
            successView.classList.remove('hidden');
            
            const countdownManager = new CountdownManager({
                countdownSectionId: 'countdown-section',
                resendSectionId: 'resend-section',
                countdownTimerId: 'countdown-timer',
                storageKey: 'resetCooldownEnd',
                duration: COOLDOWN_SECONDS,
                 onFinish: () => {
                    const resendButton = document.getElementById('resend-button');
                    resendButton.disabled = false;
                }
            });
            countdownManager.init();
        } else {
            localStorage.removeItem('resetCooldownEnd');
            localStorage.removeItem('resetEmail');
        }
    }
            
    // --- Event Listeners ---
    if(resendButton) {
        resendButton.addEventListener('click', () => {
            const isCountingDown = !!localStorage.getItem('resetCooldownEnd');
            if(isCountingDown) {
                 const now = new Date().getTime();
                 const endTime = parseInt(localStorage.getItem('resetCooldownEnd'), 10);
                 if (now < endTime) {
                    return;
                 }
            }
            resendButton.disabled = true;
            resendButton.textContent = 'Gửi lại email'; 
            doPasswordReset();
        });
    }

    if(form) {
        form.addEventListener('submit', (event) => {
            event.preventDefault();
            doPasswordReset();
        });
    }
    
    checkInitialCooldown();

    // Email validation on input
    if (emailInput) {
        emailInput.addEventListener('input', function() {
            const email = this.value.trim();
            
            clearTimeout(emailCheckTimeout);
            clearEmailValidation();
    
            if (!email) {
                showEmailError('Vui lòng nhập địa chỉ email.');
                return;
            }
    
            if (!validateEmail(email)) {
                showEmailError('Định dạng email không hợp lệ.');
                return;
            }
    
            // Debounce server validation
            emailCheckTimeout = setTimeout(() => {
                validateEmailWithServer(email);
            }, DEBOUNCE_DELAY);
        });
    }

    async function validateEmailWithServer(email) {
        const validationUrl = form.dataset.validateEmailUrl;
        showValidationSpinner(true);

        try {
            const response = await fetch(`${validationUrl}&email=${encodeURIComponent(email)}`, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json'
                }
            });

            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            
            const data = await response.json();
            
            if (data.exists) {
                showEmailSuccess('Email hợp lệ');
            } else {
                showEmailError(data.message || 'Email không tồn tại trong hệ thống');
            }
        } catch (error) {
            console.error('Error validating email:', error);
            showEmailError('Lỗi kiểm tra email. Vui lòng thử lại.');
        } finally {
            showValidationSpinner(false);
        }
    }

    function showEmailError(message) {
        emailError.textContent = message;
        emailError.classList.remove('hidden');
        emailSuccess.classList.add('hidden');
        emailInput.classList.add('border-red-500');
        emailInput.classList.remove('border-green-500');
        emailValidIcon.classList.add('hidden');
        emailInvalidIcon.classList.remove('hidden');
        emailValidationIcon.style.opacity = '1';
        submitButton.disabled = true;
    }

    function showEmailSuccess(message) {
        emailSuccess.textContent = message;
        emailSuccess.classList.remove('hidden');
        emailError.classList.add('hidden');
        emailInput.classList.remove('border-red-500');
        emailInput.classList.add('border-green-500');
        emailValidIcon.classList.remove('hidden');
        emailInvalidIcon.classList.add('hidden');
        emailValidationIcon.style.opacity = '1';
        submitButton.disabled = false;
    }

    function clearEmailValidation() {
        emailError.classList.add('hidden');
        emailSuccess.classList.add('hidden');
        emailInput.classList.remove('border-red-500', 'border-green-500');
        emailValidIcon.classList.add('hidden');
        emailInvalidIcon.classList.add('hidden');
        emailValidationIcon.style.opacity = '0';
        submitButton.disabled = true;
    }

    function showValidationSpinner(isLoading) {
        if (isLoading) {
            loadingSpinner.classList.remove('hidden');
            submitButton.disabled = true;
            buttonText.classList.add('hidden');
        } else {
            loadingSpinner.classList.add('hidden');
            submitButton.disabled = false;
            buttonText.classList.remove('hidden');
        }
    }
});
