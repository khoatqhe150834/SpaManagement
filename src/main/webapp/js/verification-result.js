// File: verification-result.js

document.addEventListener('DOMContentLoaded', function() {
    // Initialize Lucide icons
    if (window.lucide) {
        lucide.createIcons();
    }
    
    // Add a simple fade-in animation for the main card
    const successCard = document.querySelector('.bg-white.rounded-xl');
    if (successCard) {
        successCard.style.opacity = '0';
        successCard.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            successCard.style.transition = 'all 0.6s ease-out';
            successCard.style.opacity = '1';
            successCard.style.transform = 'translateY(0)';
        }, 100);
    }
});

// Navigation functions are now globally accessible
function navigateToHome() {
    window.location.href = window.spaConfig.contextPath + '/';
}

function navigateToLogin() {
    const email = window.spaConfig.email;
    const password = window.spaConfig.password;

    if (email) {
        sessionStorage.setItem('prefill_email', email);
    }
    if (password) {
        sessionStorage.setItem('prefill_password', password);
    }
    sessionStorage.setItem('from_verification', 'true');

    window.location.href = window.spaConfig.contextPath + '/login';
}

function navigateToServices() {
    window.location.href = window.spaConfig.contextPath + '/services';
}

function navigateToProfile() {
    window.location.href = window.spaConfig.contextPath + '/customer/profile';
} 