/**
 * Payment Form JavaScript
 * Handles validation and submission for payment add/edit forms
 */
class PaymentFormManager {
    constructor() {
        this.contextPath = this.getContextPath();
        this.isEditMode = window.isEditMode || false;
        this.currentPaymentId = window.currentPaymentId || null;
        this.validationCache = new Map();
        this.validationTimeouts = new Map();
        
        this.init();
    }
    
    init() {
        this.setupEventListeners();
        this.setupFormValidation();
        this.setupAmountFormatting();
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
        const form = document.getElementById('addPaymentForm') || document.getElementById('editPaymentForm');
        if (form) {
            form.addEventListener('submit', (e) => this.handleFormSubmit(e));
        }
    }
    
    setupFormValidation() {
        const fields = ['customerId', 'paymentDate', 'paymentMethod', 'paymentStatus', 'totalAmount'];
        
        fields.forEach(fieldId => {
            const field = document.getElementById(fieldId);
            if (field && !field.disabled) {
                field.addEventListener('blur', () => this.validateField(fieldId));
                field.addEventListener('input', () => this.clearFieldError(fieldId));
            }
        });
        
        // Special handling for notes field
        const notesField = document.getElementById('notes');
        if (notesField) {
            notesField.addEventListener('input', () => this.validateNotesLength());
        }
    }
    
    setupAmountFormatting() {
        const amountField = document.getElementById('totalAmount');
        if (amountField && !amountField.readOnly) {
            amountField.addEventListener('input', (e) => {
                // Remove non-numeric characters
                let value = e.target.value.replace(/[^\d]/g, '');
                if (value) {
                    // Convert to number and format with thousand separators
                    const numValue = parseInt(value);
                    e.target.value = numValue.toLocaleString('vi-VN');
                }
            });

            amountField.addEventListener('blur', (e) => {
                // Ensure minimum value and proper formatting
                let value = e.target.value.replace(/[^\d]/g, '');
                if (value) {
                    const numValue = parseInt(value);
                    if (numValue < 1000) {
                        e.target.value = '1,000';
                    } else {
                        e.target.value = numValue.toLocaleString('vi-VN');
                    }
                }
            });

            // Set initial formatting if value exists
            if (amountField.value) {
                let value = amountField.value.replace(/[^\d]/g, '');
                if (value) {
                    const numValue = parseInt(value);
                    amountField.value = numValue.toLocaleString('vi-VN');
                }
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
            console.log('Form data to submit:', formData);

            const url = this.isEditMode
                ? `${this.contextPath}/api/payments/${this.currentPaymentId}`
                : `${this.contextPath}/api/payments`;

            const method = this.isEditMode ? 'PUT' : 'POST';
            console.log('Submitting to:', url, 'Method:', method);

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
                
                // Redirect back to payments management
                setTimeout(() => {
                    window.location.href = `${this.contextPath}/manager/payments-management`;
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
        const form = document.getElementById('addPaymentForm') || document.getElementById('editPaymentForm');
        const formData = new FormData(form);
        
        const data = {};
        for (let [key, value] of formData.entries()) {
            data[key] = value;
        }
        
        // Clean up amount field (remove formatting) and convert to string for BigDecimal
        if (data.totalAmount) {
            const cleanAmount = data.totalAmount.replace(/[^\d]/g, '');
            console.log('Original amount:', data.totalAmount, 'Clean amount:', cleanAmount);
            data.totalAmount = cleanAmount; // Send as string for BigDecimal conversion
        }
        
        // Format payment date for server
        if (data.paymentDate) {
            data.paymentDate = data.paymentDate.replace('T', ' ') + ':00';
        }
        
        return data;
    }
    
    validateForm() {
        const requiredFields = this.isEditMode 
            ? ['paymentDate', 'paymentStatus']
            : ['customerId', 'paymentDate', 'paymentMethod', 'paymentStatus', 'totalAmount'];
        
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
        if (!field || field.disabled) return true;
        
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
                    // Remove all non-digit characters for validation
                    const cleanValue = value.replace(/[^\d]/g, '');
                    const amount = parseInt(cleanValue);

                    if (!cleanValue || isNaN(amount) || amount <= 0) {
                        isValid = false;
                        errorMessage = 'Số tiền phải lớn hơn 0';
                    } else if (amount < 1000) {
                        isValid = false;
                        errorMessage = 'Số tiền tối thiểu là 1,000 VNĐ';
                    } else if (amount > 100000000) {
                        isValid = false;
                        errorMessage = 'Số tiền không được vượt quá 100,000,000 VNĐ';
                    }
                    break;
                    
                case 'paymentDate':
                    const selectedDate = new Date(value);
                    const now = new Date();
                    const oneYearAgo = new Date(now.getFullYear() - 1, now.getMonth(), now.getDate());
                    const oneYearFromNow = new Date(now.getFullYear() + 1, now.getMonth(), now.getDate());
                    
                    if (selectedDate < oneYearAgo) {
                        isValid = false;
                        errorMessage = 'Ngày thanh toán không được quá 1 năm trước';
                    } else if (selectedDate > oneYearFromNow) {
                        isValid = false;
                        errorMessage = 'Ngày thanh toán không được quá 1 năm sau';
                    }
                    break;
            }
        }
        
        this.showFieldValidation(fieldId, isValid, errorMessage);
        
        // Perform server-side validation for specific fields
        if (isValid && ['customerId', 'totalAmount'].includes(fieldId) && !this.isEditMode) {
            this.performServerValidation(fieldId, value);
        }
        
        return isValid;
    }
    
    validateNotesLength() {
        const notesField = document.getElementById('notes');
        if (!notesField) return;
        
        const value = notesField.value;
        const maxLength = 500;
        
        if (value.length > maxLength) {
            this.showFieldValidation('notes', false, `Ghi chú không được vượt quá ${maxLength} ký tự`);
            return false;
        } else {
            this.clearFieldError('notes');
            return true;
        }
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
                        endpoint = '/api/validate/payment/customer';
                        params.append('customerId', value);
                        break;
                    case 'totalAmount':
                        endpoint = '/api/validate/payment/amount';
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
                this.clearFieldError(fieldId);
            }
        }, 500); // 500ms debounce
        
        this.validationTimeouts.set(fieldId, timeout);
    }
    
    showFieldValidation(fieldId, isValid, message) {
        const field = document.getElementById(fieldId);
        if (!field) return;
        
        // Remove existing error styling
        field.classList.remove('border-red-500', 'border-green-500', 'border-blue-300');
        
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
            
            // Find the right place to insert the error message
            const errorContainer = document.getElementById(fieldId + 'Error');
            if (errorContainer) {
                errorContainer.textContent = message;
                errorContainer.classList.remove('hidden');
            } else {
                field.parentNode.appendChild(errorDiv);
            }
        } else if (isValid) {
            field.classList.add('border-green-500');
            
            // Hide existing error container
            const errorContainer = document.getElementById(fieldId + 'Error');
            if (errorContainer) {
                errorContainer.classList.add('hidden');
            }
        }
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
        
        // Hide existing error container
        const errorContainer = document.getElementById(fieldId + 'Error');
        if (errorContainer) {
            errorContainer.classList.add('hidden');
        }
    }
    
    clearFieldError(fieldId) {
        const field = document.getElementById(fieldId);
        if (!field) return;
        
        field.classList.remove('border-red-500', 'border-green-500', 'border-blue-300');
        
        const existingError = field.parentNode.querySelector('.field-error');
        if (existingError) {
            existingError.remove();
        }
        
        const errorContainer = document.getElementById(fieldId + 'Error');
        if (errorContainer) {
            errorContainer.classList.add('hidden');
        }
    }
    
    showSubmitLoading() {
        const submitBtn = document.getElementById('submitBtn');
        if (submitBtn) {
            submitBtn.disabled = true;
            const isEdit = this.isEditMode;
            submitBtn.innerHTML = `<i data-lucide="loader-2" class="h-4 w-4 mr-2 animate-spin"></i>${isEdit ? 'Đang cập nhật...' : 'Đang lưu...'}`;
            
            // Re-initialize Lucide icons
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }
        }
    }
    
    hideSubmitLoading() {
        const submitBtn = document.getElementById('submitBtn');
        if (submitBtn) {
            submitBtn.disabled = false;
            const isEdit = this.isEditMode;
            submitBtn.innerHTML = `<i data-lucide="save" class="w-4 h-4 inline mr-2"></i>${isEdit ? 'Cập Nhật' : 'Thêm Thanh Toán'}`;
            
            // Re-initialize Lucide icons
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }
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

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    window.paymentFormManager = new PaymentFormManager();
});
