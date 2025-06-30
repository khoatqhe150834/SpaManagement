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
    const prefillEmail = sessionStorage.getItem('prefill_email');
    const prefillPassword = sessionStorage.getItem('prefill_password');

    const result = { emailFilled: false, passwordFilled: false };

    if (fromVerification !== 'true' || !prefillEmail) {
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

    if (options.notificationCallback && typeof options.notificationCallback === 'function') {
        options.notificationCallback('Thông tin đăng nhập đã được điền sẵn từ quá trình xác thực!', 'success');
    }
    
    // Clear the stored credentials for security
    sessionStorage.removeItem('from_verification');
    sessionStorage.removeItem('prefill_email');
    sessionStorage.removeItem('prefill_password');

    return result;
} 