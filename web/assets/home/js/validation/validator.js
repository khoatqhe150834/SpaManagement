

const form = document.getElementById('registerForm');
const fullName = document.getElementById('fullName');
const phone = document.getElementById('phone');
const email = document.getElementById('email');
const password = document.getElementById('password');
const confirmPassword = document.getElementById('confirmPassword');

const setError = (element, message) => {
    const inputControl = element.closest('.form-group');
    const errorDisplay = inputControl.querySelector('.error');
    errorDisplay.innerText = message;
    inputControl.classList.add('error');
    inputControl.classList.remove('success');
}

const setSuccess = (element) => {
    const inputControl = element.closest('.form-group');
    const errorDisplay = inputControl.querySelector('.error');
    errorDisplay.innerText = '';
    inputControl.classList.remove('error');
    inputControl.classList.add('success');
}

function isValidFullName(name) {
    // Accept Vietnamese letters, spaces, min 6 chars
    return /^[a-zA-ZÀ-ỹ\s]{6,100}$/.test(name);
}

function isValidPhone(phone) {
    return /^[0-9]{10,11}$/.test(phone);
}

function isValidEmail(email) {
    // Simple email regex
    return /^[A-Za-z0-9+_.-]+@(.+)$/.test(email);
}

function isStrongPassword(pw) {
    // At least 6 chars, 1 upper, 1 lower, 1 digit, 1 special
    return /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$/.test(pw);
}

function validateForm() {
    let valid = true;
    const fullNameValue = fullName.value.trim();
    const phoneValue = phone.value.trim();
    const emailValue = email.value.trim();
    const passwordValue = password.value.trim();
    const confirmPasswordValue = confirmPassword.value.trim();

    // Full Name
    if (fullNameValue === '') {
        setError(fullName, 'Họ tên không được để trống');
        valid = false;
    } else if (fullNameValue.length < 6) {
        setError(fullName, 'Họ tên phải có ít nhất 6 ký tự');
        valid = false;
    } else if (!isValidFullName(fullNameValue)) {
        setError(fullName, 'Họ tên không được chứa ký tự đặc biệt');
        valid = false;
    } else {
        setSuccess(fullName);
    }

    // Phone
    if (phoneValue === '') {
        setError(phone, 'Số điện thoại không được để trống');
        valid = false;
    } else if (!isValidPhone(phoneValue)) {
        setError(phone, 'Số điện thoại phải là 10 hoặc 11 chữ số');
        valid = false;
    } else {
        setSuccess(phone);
    }

    // Email
    if (emailValue === '') {
        setError(email, 'Email không được để trống');
        valid = false;
    } else if (!isValidEmail(emailValue)) {
        setError(email, 'Vui lòng nhập đúng định dạng email');
        valid = false;
    } else {
        setSuccess(email);
    }

    // Password
    if (passwordValue === '') {
        setError(password, 'Mật khẩu không được để trống');
        valid = false;
    } else if (passwordValue.length < 6) {
        setError(password, 'Mật khẩu phải có ít nhất 6 ký tự');
        valid = false;
    } else if (!isStrongPassword(passwordValue)) {
        setError(password, 'Mật khẩu phải bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt');
        valid = false;
    } else {
        setSuccess(password);
    }

    // Confirm Password
    if (confirmPasswordValue === '') {
        setError(confirmPassword, 'Vui lòng nhập lại mật khẩu');
        valid = false;
    } else if (confirmPasswordValue !== passwordValue) {
        setError(confirmPassword, 'Mật khẩu không khớp');
        valid = false;
    } else {
        setSuccess(confirmPassword);
    }

    return valid;
}

form.addEventListener('submit', function(event) {
    if (!validateForm()) {
        event.preventDefault();
    }
});



