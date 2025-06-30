class CountdownManager {
    constructor(options) {
        this.countdownSection = document.getElementById(options.countdownSectionId);
        this.resendSection = document.getElementById(options.resendSectionId);
        this.countdownTimerEl = document.getElementById(options.countdownTimerId);
        
        this.storageKey = options.storageKey;
        this.duration = options.duration || 60;

        this.countdownInterval = null;

        if (!this.countdownSection || !this.resendSection || !this.countdownTimerEl || !this.storageKey) {
            console.error('CountdownManager: Missing required options or DOM elements.');
            return;
        }
    }

    init() {
        const endTime = localStorage.getItem(this.storageKey);
        if (!endTime) {
            this.start();
        } else {
            this.tick(endTime);
        }
    }

    start() {
        const endTime = Date.now() + this.duration * 1000;
        localStorage.setItem(this.storageKey, endTime);
        this.tick(endTime);
    }

    tick(endTime) {
        if (this.countdownInterval) {
            clearInterval(this.countdownInterval);
        }

        const remainingSeconds = Math.round((endTime - Date.now()) / 1000);

        if (remainingSeconds <= 0) {
            this.finish();
            return;
        }
        
        this.updateUI(remainingSeconds);

        this.countdownInterval = setInterval(() => {
            const seconds = Math.round((endTime - Date.now()) / 1000);
            if (seconds > 0) {
                this.updateUI(seconds);
            } else {
                this.finish();
            }
        }, 1000);
    }

    finish() {
        clearInterval(this.countdownInterval);
        localStorage.removeItem(this.storageKey);
        this.countdownSection.style.display = 'none';
        this.resendSection.style.display = 'block';
    }
    
    updateUI(seconds) {
        this.countdownTimerEl.textContent = seconds;
        this.countdownSection.style.display = 'block';
        this.resendSection.style.display = 'none';
    }
} 