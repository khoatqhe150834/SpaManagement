// File: email-verification-required.js

document.addEventListener('DOMContentLoaded', function() {
    if (window.lucide) {
        lucide.createIcons();
    }
    
    const email = window.spaConfig.email;
    if (!email) {
        console.error("Email not found for countdown.");
        return;
    }

    const resendEmailBtn = document.getElementById('resendEmailBtn');

    const countdownManager = new CountdownManager({
        countdownSectionId: 'countdownSection',
        resendSectionId: 'resendSection',
        countdownTimerId: 'countdownTimer',
        storageKey: `verification_countdown_end_time_${email}`,
        duration: 60
    });

    countdownManager.init();

    if (resendEmailBtn) {
        resendEmailBtn.addEventListener('click', function(e) {
            e.preventDefault();
            sendVerificationEmail(email);
        });
    }
    
    function sendVerificationEmail(email) {
        const btn = resendEmailBtn;
        const originalHTML = btn.innerHTML;
        
        btn.innerHTML = '<i data-lucide="loader-2" class="h-5 w-5 animate-spin"></i><span class="ml-2">Đang gửi...</span>';
        btn.disabled = true;
        lucide.createIcons();
        
        fetch(`${window.spaConfig.contextPath}/resend-verification?email=${encodeURIComponent(email)}`)
        .then(response => {
            return response.json().then(data => {
                if (response.ok) {
                    countdownManager.start();
                    if (window.SpaApp && window.SpaApp.showNotification) {
                        SpaApp.showNotification(data.message || 'Email xác thực đã được gửi thành công!', 'success');
                    }
                } else {
                    throw new Error(data.message || 'Network response was not ok');
                }
            });
        })
        .catch(error => {
            let errorMessage = error.message || 'Có lỗi xảy ra khi gửi email. Vui lòng thử lại sau.';
            if (window.SpaApp && window.SpaApp.showNotification) {
                SpaApp.showNotification(errorMessage, 'error');
            } else {
                alert(errorMessage);
            }
        })
        .finally(() => {
            btn.innerHTML = originalHTML;
            btn.disabled = false;
            lucide.createIcons();
        });
    }
});

function navigateTo(page) {
    const contextPath = window.spaConfig.contextPath;
    switch(page) {
        case 'login':
            window.location.href = contextPath + '/login';
            break;
        case 'home':
            window.location.href = contextPath + '/';
            break;
        default:
            window.location.href = contextPath + '/' + page;
    }
} 