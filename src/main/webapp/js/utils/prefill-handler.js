/**
 * Checks sessionStorage for credentials set by a verification or registration flow
 * and uses them to prefill a form. This function is designed to be reusable.
 *
 * @param {object} options - Configuration for the prefill handler.
 * @param {string} options.emailFieldSelector - The CSS selector for the email input field.
 * @param {string} options.passwordFieldSelector - The CSS selector for the password input field.
 * @param {string} [options.rememberMeSelector] - Optional. The CSS selector for the "remember me" checkbox.
 * @param {function} [options.notificationCallback] - Optional. A function to call to display a success message, e.g., `(message, type) => { ... }`.
 * @returns {object} An object indicating which fields were successfully prefilled, e.g., `{ emailFilled: true, passwordFilled: true }`.
 */
function handlePrefillCredentials(options) {
    const fromVerification = sessionStorage.getItem('from_verification');
    const fromPasswordReset = sessionStorage.getItem('from_password_reset');
    const prefillEmail = sessionStorage.getItem('prefill_email');
    const prefillPassword = sessionStorage.getItem('prefill_password');

    const result = { emailFilled: false, passwordFilled: false };

    // Check if this is from either verification or password reset flow
    if ((fromVerification !== 'true' && fromPasswordReset !== 'true') || !prefillEmail) {
        return result;
    }

    const emailField = document.querySelector(options.emailFieldSelector);
    const passwordField = document.querySelector(options.passwordFieldSelector);
    
    if (!emailField) {
        console.error("Prefill handler: Email field not found with selector:", options.emailFieldSelector);
        return result;
    }

    emailField.value = prefillEmail;
    result.emailFilled = true;

    if (prefillPassword && passwordField) {
        passwordField.value = prefillPassword;
        result.passwordFilled = true;
        
        if (options.rememberMeSelector) {
            const rememberMeCheckbox = document.querySelector(options.rememberMeSelector);
            if (rememberMeCheckbox) {
                rememberMeCheckbox.checked = true;
            }
        }
    }

    // Use the specific message from the previous flow, or fall back to a default.
    const message = sessionStorage.getItem('prefill_message') || 'Thông tin đăng nhập đã được điền sẵn!';
    if (options.notificationCallback && typeof options.notificationCallback === 'function') {
        options.notificationCallback(message, 'success');
    }
    
    // Clear all the stored credentials for security
    sessionStorage.removeItem('from_verification');
    sessionStorage.removeItem('from_password_reset');
    sessionStorage.removeItem('prefill_email');
    sessionStorage.removeItem('prefill_password');
    sessionStorage.removeItem('prefill_message'); // Also clear the message

    return result;
} 