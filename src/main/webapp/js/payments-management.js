/**
 * Payment Management JavaScript
 * Handles add/edit payment functionality for managers
 */
class PaymentManager {
    constructor() {
        this.contextPath = this.getContextPath();
        this.currentPaymentId = null;
        this.isEditMode = false;
        this.validationEndpoints = {
            customer: '/api/validate/payment/customer',
            amount: '/api/validate/payment/amount',
            reference: '/api/validate/payment/reference'
        };

        this.validationCache = new Map();
        this.validationTimeouts = new Map();
        
        this.init();
    }
    
    init() {
        this.setupEventListeners();
        this.setupFormValidation();
        this.setupModalHandlers();
    }
    
    getContextPath() {
        const metaContextPath = document.querySelector('meta[name="context-path"]');
        if (metaContextPath) {
            return metaContextPath.getAttribute('content');
        }
        
        const path = window.location.pathname;
        const segments = path.split('/');
        if (segments.length > 1 && segments[1]) {
            return '/' + segments[1];
        }
        
        return '';
    }
    
    setupEventListeners() {
        // Add Payment buttons
        const addPaymentBtn = document.getElementById('addPaymentBtn');
        const emptyAddPaymentBtn = document.getElementById('emptyAddPaymentBtn');
        
        if (addPaymentBtn) {
            addPaymentBtn.addEventListener('click', () => this.openAddPaymentModal());
        }
        
        if (emptyAddPaymentBtn) {
            emptyAddPaymentBtn.addEventListener('click', () => this.openAddPaymentModal());
        }
        
        // Modal close handlers
        const closeModal = document.getElementById('closeModal');
        const cancelPayment = document.getElementById('cancelPayment');
        const paymentModal = document.getElementById('paymentModal');
        
        if (closeModal) {
            closeModal.addEventListener('click', () => this.closeModal());
        }
        
        if (cancelPayment) {
            cancelPayment.addEventListener('click', () => this.closeModal());
        }
        
        if (paymentModal) {
            paymentModal.addEventListener('click', (e) => {
                if (e.target === paymentModal) {
                    this.closeModal();
                }
            });
        }
        
        // Form submission
        const paymentForm = document.getElementById('paymentForm');
        if (paymentForm) {
            paymentForm.addEventListener('submit', (e) => this.handleFormSubmit(e));
        }
    }
    
    setupModalHandlers() {
        // ESC key to close modal
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                const modal = document.getElementById('paymentModal');
                if (modal && !modal.classList.contains('hidden')) {
                    this.closeModal();
                }
            }
        });
    }
    
    setupFormValidation() {
        const form = document.getElementById('paymentForm');
        if (!form) return;
        
        // Real-time validation for form fields
        const fields = ['customerId', 'totalAmount', 'paymentMethod', 'paymentStatus'];
        
        fields.forEach(fieldId => {
            const field = document.getElementById(fieldId);
            if (field) {
                field.addEventListener('blur', () => this.validateField(fieldId));
                field.addEventListener('input', () => this.clearFieldError(fieldId));
            }
        });
        
        // Special handling for amount field
        const amountField = document.getElementById('totalAmount');
        if (amountField) {
            amountField.addEventListener('input', (e) => {
                // Format number with thousand separators
                let value = e.target.value.replace(/[^\d]/g, '');
                if (value) {
                    e.target.value = parseInt(value).toLocaleString('vi-VN');
                }
            });
        }
    }
    
    openAddPaymentModal() {
        this.isEditMode = false;
        this.currentPaymentId = null;
        
        // Reset form
        this.resetForm();
        
        // Update modal title
        const modalTitle = document.getElementById('modalTitle');
        if (modalTitle) {
            modalTitle.textContent = 'Thêm thanh toán mới';
        }
        
        // Set default values
        const paymentDate = document.getElementById('paymentDate');
        if (paymentDate) {
            const now = new Date();
            const localDateTime = new Date(now.getTime() - now.getTimezoneOffset() * 60000)
                .toISOString().slice(0, 16);
            paymentDate.value = localDateTime;
        }
        
        const paymentStatus = document.getElementById('paymentStatus');
        if (paymentStatus) {
            paymentStatus.value = 'PAID';
        }
        
        // Show modal
        this.showModal();
    }
    
    openEditPaymentModal(paymentId) {
        this.isEditMode = true;
        this.currentPaymentId = paymentId;
        
        // Update modal title
        const modalTitle = document.getElementById('modalTitle');
        if (modalTitle) {
            modalTitle.textContent = 'Chỉnh sửa thanh toán';
        }
        
        // Load payment data
        this.loadPaymentData(paymentId);
        
        // Show modal
        this.showModal();
    }
    
    async loadPaymentData(paymentId) {
        try {
            this.showLoadingState();
            
            const response = await fetch(`${this.contextPath}/api/payments/${paymentId}`);
            
            if (!response.ok) {
                throw new Error('Không thể tải thông tin thanh toán');
            }
            
            const payment = await response.json();
            this.populateForm(payment);
            
        } catch (error) {
            console.error('Error loading payment data:', error);
            this.showNotification('Lỗi khi tải thông tin thanh toán: ' + error.message, 'error');
            this.closeModal();
        } finally {
            this.hideLoadingState();
        }
    }
    
    populateForm(payment) {
        // Populate form fields with payment data
        const fields = {
            'paymentId': payment.paymentId,
            'customerId': payment.customerId,
            'paymentMethod': payment.paymentMethod,
            'paymentStatus': payment.paymentStatus,
            'totalAmount': payment.totalAmount,
            'notes': payment.notes || ''
        };
        
        Object.entries(fields).forEach(([fieldId, value]) => {
            const field = document.getElementById(fieldId);
            if (field) {
                field.value = value;
            }
        });
        
        // Handle payment date
        if (payment.paymentDate) {
            const paymentDate = document.getElementById('paymentDate');
            if (paymentDate) {
                const date = new Date(payment.paymentDate);
                const localDateTime = new Date(date.getTime() - date.getTimezoneOffset() * 60000)
                    .toISOString().slice(0, 16);
                paymentDate.value = localDateTime;
            }
        }
    }
    
    async handleFormSubmit(e) {
        e.preventDefault();
        
        if (this.isSubmitting) return;
        
        // Validate form
        if (!this.validateForm()) {
            return;
        }
        
        this.isSubmitting = true;
        this.showSubmitLoading();
        
        try {
            const formData = this.getFormData();
            const url = this.isEditMode 
                ? `${this.contextPath}/api/payments/${this.currentPaymentId}`
                : `${this.contextPath}/api/payments`;
            
            const method = this.isEditMode ? 'PUT' : 'POST';
            
            const response = await fetch(url, {
                method: method,
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: JSON.stringify(formData)
            });
            
            const result = await response.json();
            
            if (response.ok && result.success) {
                const message = this.isEditMode 
                    ? 'Cập nhật thanh toán thành công!'
                    : 'Thêm thanh toán thành công!';
                
                this.showNotification(message, 'success');
                this.closeModal();
                
                // Reload page to refresh data
                setTimeout(() => {
                    window.location.reload();
                }, 1500);
                
            } else {
                throw new Error(result.message || 'Có lỗi xảy ra khi lưu thanh toán');
            }
            
        } catch (error) {
            console.error('Error submitting payment:', error);
            this.showNotification('Lỗi: ' + error.message, 'error');
        } finally {
            this.isSubmitting = false;
            this.hideSubmitLoading();
        }
    }
    
    getFormData() {
        const form = document.getElementById('paymentForm');
        const formData = new FormData(form);
        
        const data = {};
        for (let [key, value] of formData.entries()) {
            data[key] = value;
        }
        
        // Clean up amount field (remove formatting)
        if (data.totalAmount) {
            data.totalAmount = parseFloat(data.totalAmount.replace(/[^\d]/g, ''));
        }
        
        return data;
    }
    
    validateForm() {
        const requiredFields = ['customerId', 'paymentMethod', 'paymentStatus', 'totalAmount', 'paymentDate'];
        let isValid = true;
        
        requiredFields.forEach(fieldId => {
            if (!this.validateField(fieldId)) {
                isValid = false;
            }
        });
        
        return isValid;
    }
    
    validateField(fieldId) {
        const field = document.getElementById(fieldId);
        if (!field) return true;
        
        const value = field.value.trim();
        let isValid = true;
        let errorMessage = '';
        
        // Required field validation
        if (!value) {
            isValid = false;
            errorMessage = 'Trường này là bắt buộc';
        } else {
            // Specific field validations
            switch (fieldId) {
                case 'totalAmount':
                    const amount = parseFloat(value.replace(/[^\d]/g, ''));
                    if (isNaN(amount) || amount <= 0) {
                        isValid = false;
                        errorMessage = 'Số tiền phải lớn hơn 0';
                    } else if (amount > 100000000) {
                        isValid = false;
                        errorMessage = 'Số tiền không được vượt quá 100,000,000 VNĐ';
                    }
                    break;
            }
        }
        
        this.showFieldValidation(fieldId, isValid, errorMessage);

        // Perform server-side validation for specific fields
        if (isValid && ['customerId', 'totalAmount'].includes(fieldId)) {
            this.performServerValidation(fieldId, value);
        }

        return isValid;
    }

    async performServerValidation(fieldId, value) {
        // Clear existing timeout
        if (this.validationTimeouts.has(fieldId)) {
            clearTimeout(this.validationTimeouts.get(fieldId));
        }

        // Set new timeout for debounced validation
        const timeout = setTimeout(async () => {
            try {
                const cacheKey = `${fieldId}:${value}`;

                // Check cache first
                if (this.validationCache.has(cacheKey)) {
                    const cachedResult = this.validationCache.get(cacheKey);
                    this.showFieldValidation(fieldId, cachedResult.valid, cachedResult.message);
                    return;
                }

                // Show loading state
                this.showFieldValidationLoading(fieldId);

                let endpoint = '';
                let params = new URLSearchParams();

                switch (fieldId) {
                    case 'customerId':
                        endpoint = this.validationEndpoints.customer;
                        params.append('customerId', value);
                        break;
                    case 'totalAmount':
                        endpoint = this.validationEndpoints.amount;
                        params.append('amount', value);
                        break;
                }

                if (endpoint) {
                    const response = await fetch(`${this.contextPath}${endpoint}?${params.toString()}`);
                    const result = await response.json();

                    // Cache result
                    this.validationCache.set(cacheKey, {
                        valid: result.valid,
                        message: result.message
                    });

                    this.showFieldValidation(fieldId, result.valid, result.message);
                }

            } catch (error) {
                console.error('Server validation error:', error);
                // Don't show error to user for server validation failures
            }
        }, 500); // 500ms debounce

        this.validationTimeouts.set(fieldId, timeout);
    }

    showFieldValidationLoading(fieldId) {
        const field = document.getElementById(fieldId);
        if (!field) return;

        // Remove existing states
        field.classList.remove('border-red-500', 'border-green-500');
        field.classList.add('border-blue-300');

        // Remove existing messages
        const existingError = field.parentNode.querySelector('.field-error');
        if (existingError) {
            existingError.remove();
        }

        // Add loading message
        const loadingDiv = document.createElement('div');
        loadingDiv.className = 'field-error text-blue-500 text-xs mt-1 flex items-center';
        loadingDiv.innerHTML = '<i data-lucide="loader-2" class="h-3 w-3 mr-1 animate-spin"></i>Đang kiểm tra...';
        field.parentNode.appendChild(loadingDiv);

        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
    }
    
    showFieldValidation(fieldId, isValid, message) {
        const field = document.getElementById(fieldId);
        if (!field) return;
        
        // Remove existing error styling
        field.classList.remove('border-red-500', 'border-green-500');
        
        // Remove existing error message
        const existingError = field.parentNode.querySelector('.field-error');
        if (existingError) {
            existingError.remove();
        }
        
        if (!isValid && message) {
            // Add error styling
            field.classList.add('border-red-500');
            
            // Add error message
            const errorDiv = document.createElement('div');
            errorDiv.className = 'field-error text-red-500 text-xs mt-1';
            errorDiv.textContent = message;
            field.parentNode.appendChild(errorDiv);
        } else if (isValid) {
            field.classList.add('border-green-500');
        }
    }
    
    clearFieldError(fieldId) {
        const field = document.getElementById(fieldId);
        if (!field) return;
        
        field.classList.remove('border-red-500', 'border-green-500');
        
        const existingError = field.parentNode.querySelector('.field-error');
        if (existingError) {
            existingError.remove();
        }
    }
    
    resetForm() {
        const form = document.getElementById('paymentForm');
        if (form) {
            form.reset();
            
            // Clear all validation states
            const fields = form.querySelectorAll('input, select, textarea');
            fields.forEach(field => {
                this.clearFieldError(field.id);
            });
        }
    }
    
    showModal() {
        const modal = document.getElementById('paymentModal');
        if (modal) {
            modal.classList.remove('hidden');
            document.body.style.overflow = 'hidden';
            
            // Focus first input
            const firstInput = modal.querySelector('input:not([type="hidden"]), select');
            if (firstInput) {
                setTimeout(() => firstInput.focus(), 100);
            }
        }
    }
    
    closeModal() {
        const modal = document.getElementById('paymentModal');
        if (modal) {
            modal.classList.add('hidden');
            document.body.style.overflow = 'auto';
            this.resetForm();
        }
    }
    
    showLoadingState() {
        const modal = document.getElementById('paymentModal');
        if (modal) {
            const loadingOverlay = document.createElement('div');
            loadingOverlay.id = 'loadingOverlay';
            loadingOverlay.className = 'absolute inset-0 bg-white bg-opacity-75 flex items-center justify-center z-10';
            loadingOverlay.innerHTML = `
                <div class="flex items-center">
                    <i data-lucide="loader-2" class="h-6 w-6 mr-2 animate-spin text-primary"></i>
                    <span class="text-gray-600">Đang tải...</span>
                </div>
            `;
            modal.querySelector('.bg-white').style.position = 'relative';
            modal.querySelector('.bg-white').appendChild(loadingOverlay);

            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }
        }
    }

    hideLoadingState() {
        const loadingOverlay = document.getElementById('loadingOverlay');
        if (loadingOverlay) {
            loadingOverlay.remove();
        }
    }
    
    showSubmitLoading() {
        const submitBtn = document.querySelector('#paymentForm button[type="submit"]');
        if (submitBtn) {
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i data-lucide="loader-2" class="h-4 w-4 mr-2 animate-spin"></i>Đang lưu...';
        }
    }
    
    hideSubmitLoading() {
        const submitBtn = document.querySelector('#paymentForm button[type="submit"]');
        if (submitBtn) {
            submitBtn.disabled = false;
            submitBtn.innerHTML = 'Lưu thanh toán';
        }
    }
    
    showNotification(message, type = 'info') {
        // Create notification element
        const notification = document.createElement('div');
        notification.className = `fixed top-4 right-4 z-50 p-4 rounded-lg shadow-lg max-w-sm transition-all duration-300 transform translate-x-full`;
        
        // Set notification style based on type
        switch (type) {
            case 'success':
                notification.classList.add('bg-green-500', 'text-white');
                break;
            case 'error':
                notification.classList.add('bg-red-500', 'text-white');
                break;
            case 'warning':
                notification.classList.add('bg-yellow-500', 'text-white');
                break;
            default:
                notification.classList.add('bg-blue-500', 'text-white');
        }
        
        notification.innerHTML = `
            <div class="flex items-center">
                <span class="flex-1">${message}</span>
                <button class="ml-2 text-white hover:text-gray-200" onclick="this.parentElement.parentElement.remove()">
                    <i data-lucide="x" class="h-4 w-4"></i>
                </button>
            </div>
        `;
        
        document.body.appendChild(notification);
        
        // Initialize Lucide icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
        
        // Animate in
        setTimeout(() => {
            notification.classList.remove('translate-x-full');
        }, 100);
        
        // Auto remove after 5 seconds
        setTimeout(() => {
            notification.classList.add('translate-x-full');
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.remove();
                }
            }, 300);
        }, 5000);
    }
}

// Global functions for button onclick handlers
function editPayment(paymentId) {
    if (window.paymentManager) {
        window.paymentManager.openEditPaymentModal(paymentId);
    }
}

function viewPayment(paymentId) {
    window.location.href = `${window.location.origin}${window.location.pathname.replace('/manager/payments-management', '')}/customer/payment-details?id=${paymentId}`;
}

async function updatePaymentStatus(paymentId, status) {
    const statusNames = {
        'PAID': 'Đã thanh toán',
        'PENDING': 'Chờ xử lý',
        'FAILED': 'Thất bại',
        'REFUNDED': 'Đã hoàn tiền'
    };

    const statusName = statusNames[status] || status;

    if (confirm(`Bạn có chắc chắn muốn cập nhật trạng thái thanh toán thành "${statusName}"?`)) {
        try {
            const contextPath = window.paymentManager ? window.paymentManager.contextPath : '';

            const response = await fetch(`${contextPath}/api/payments/${paymentId}/status`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: JSON.stringify({ status: status })
            });

            const result = await response.json();

            if (response.ok && result.success) {
                if (window.paymentManager) {
                    window.paymentManager.showNotification(`Cập nhật trạng thái thành công!`, 'success');
                }

                // Reload page to refresh data
                setTimeout(() => {
                    window.location.reload();
                }, 1500);

            } else {
                throw new Error(result.message || 'Có lỗi xảy ra khi cập nhật trạng thái');
            }

        } catch (error) {
            console.error('Error updating payment status:', error);
            if (window.paymentManager) {
                window.paymentManager.showNotification('Lỗi: ' + error.message, 'error');
            } else {
                alert('Lỗi: ' + error.message);
            }
        }
    }
}

function printReceipt(paymentId) {
    window.open(`${window.location.origin}${window.location.pathname.replace('/manager/payments-management', '')}/receipts/payment/${paymentId}`, '_blank');
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    window.paymentManager = new PaymentManager();
});
