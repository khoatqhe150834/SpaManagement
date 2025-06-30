document.addEventListener('DOMContentLoaded', function () {
    const COOLDOWN_SECONDS = 60;

    // --- Element Selectors ---
    const form = document.getElementById('forgotPasswordForm');
    if (!form) return; // Exit if the form is not on the page
    
    const emailInput = document.getElementById('email');
    const emailError = document.getElementById('email-error');
    const formErrorContainer = document.getElementById('form-error-container');
    const formErrorMessage = document.getElementById('form-error-message');
    
    const submitButton = document.getElementById('submit-button');
    const buttonText = document.getElementById('button-text');
    const loadingSpinner = document.getElementById('loading-spinner');

    const formView = document.getElementById('reset-form-view');
    const successView = document.getElementById('success-view');
    const sentEmailAddress = document.getElementById('sent-email-address');
    
    const resendButton = document.getElementById('resend-button');

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
        startResendCooldown();
    }

    // --- Main Logic ---
    async function doPasswordReset() {
        clearFormError();
        const email = emailInput.value.trim();

        if (!validateEmail(email)) {
            emailError.textContent = 'Vui lòng nhập một địa chỉ email hợp lệ.';
            emailError.classList.remove('hidden');
            emailInput.classList.add('border-red-500');
            return;
        }

        setLoadingState(true);
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
                showFormError(result.message || 'Đã có lỗi xảy ra. Vui lòng thử lại.');
            }
        } catch (error) {
            showFormError('Lỗi kết nối. Vui lòng kiểm tra lại mạng của bạn.');
        } finally {
            setLoadingState(false);
        }
    }

    // --- Cooldown Logic ---
    let countdownInterval;

    function updateResendButton(secondsLeft) {
        resendButton.disabled = true;
        resendButton.textContent = `Gửi lại sau (${secondsLeft}s)`;
    }

    function startResendCooldown() {
        const cooldownEndTime = new Date().getTime() + COOLDOWN_SECONDS * 1000;
        localStorage.setItem('resetCooldownEnd', cooldownEndTime);
        
        if (countdownInterval) clearInterval(countdownInterval);

        countdownInterval = setInterval(() => {
            const now = new Date().getTime();
            const secondsLeft = Math.round((cooldownEndTime - now) / 1000);

            if (secondsLeft <= 0) {
                clearInterval(countdownInterval);
                resendButton.disabled = false;
                resendButton.textContent = 'Gửi lại email';
                localStorage.removeItem('resetCooldownEnd');
            } else {
                updateResendButton(secondsLeft);
            }
        }, 1000);
    }
            
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
            startResendCooldown();
        } else {
            localStorage.removeItem('resetCooldownEnd');
            localStorage.removeItem('resetEmail');
        }
    }
            
    // --- Event Listeners ---
    resendButton.addEventListener('click', doPasswordReset);
    form.addEventListener('submit', (event) => {
        event.preventDefault();
        doPasswordReset();
    });

    checkInitialCooldown();
});
