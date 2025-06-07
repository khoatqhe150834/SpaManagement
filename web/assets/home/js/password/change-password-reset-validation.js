/**
 * Change Password (Reset) Validation
 * Handles password validation and form submission for password reset via token
 */
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('passwordChangeForm');
    const submitBtn = document.getElementById('submitBtn');
    const newPassword = document.getElementById('newPassword');
    const confirmPassword = document.getElementById('confirmPassword');
    const passwordMatch = document.getElementById('passwordMatch');
    
    if (form) {
        newPassword.focus();
        
        // Check password match
        function checkPasswordMatch() {
            const password = newPassword.value;
            const confirm = confirmPassword.value;
            
            if (confirm.length === 0) {
                passwordMatch.innerHTML = '';
                return false;
            }
            
            if (password === confirm) {
                passwordMatch.innerHTML = '<span class="valid"><i class="fa fa-check"></i> Mật khẩu khớp</span>';
                return true;
            } else {
                passwordMatch.innerHTML = '<span class="invalid"><i class="fa fa-times"></i> Mật khẩu không khớp</span>';
                return false;
            }
        }
        
        // Validate form
        function validateForm() {
            const password = newPassword.value;
            const confirm = confirmPassword.value;
            const isPasswordValid = password.length >= 6;
            const isPasswordMatch = password === confirm && confirm.length > 0;
            
            submitBtn.disabled = !(isPasswordValid && isPasswordMatch);
        }
        
        // Event listeners
        newPassword.addEventListener('input', function() {
            if (confirmPassword.value.length > 0) {
                checkPasswordMatch();
            }
            validateForm();
        });
        
        confirmPassword.addEventListener('input', function() {
            checkPasswordMatch();
            validateForm();
        });
        
        // Form submission
        form.addEventListener('submit', function(e) {
            const password = newPassword.value;
            const confirm = confirmPassword.value;
            
            if (password !== confirm) {
                e.preventDefault();
                alert('Mật khẩu xác nhận không khớp. Vui lòng kiểm tra lại.');
                confirmPassword.focus();
                return;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                alert('Mật khẩu phải có ít nhất 6 ký tự.');
                newPassword.focus();
                return;
            }
            
            // Store email and password for login redirect
            const userEmailElement = document.querySelector('.user-email');
            const userEmail = userEmailElement ? userEmailElement.textContent.trim() : '';
            
            if (userEmail) {
                sessionStorage.setItem('loginEmail', userEmail);
                sessionStorage.setItem('loginPassword', password);
                sessionStorage.setItem('passwordJustChanged', 'true');
            }
            
            // Show loading state
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<div class="loading-spinner"></div>ĐANG XỬ LÝ...';
        });
        
        // Initial validation
        validateForm();
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