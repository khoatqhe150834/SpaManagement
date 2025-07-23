/**
 * Payment Edit JavaScript
 * Handles payment editing functionality with service item management
 */

// Global variables
var contextPath = '';
var currentPaymentId = null;
var isEditMode = true;

document.addEventListener('DOMContentLoaded', function() {
    // Get context path
    contextPath = document.querySelector('meta[name="context-path"]')?.getAttribute('content') || '';
    
    // Get current payment ID from URL or form
    var pathParts = window.location.pathname.split('/');
    currentPaymentId = pathParts[pathParts.length - 1];
    
    // Initialize form
    initializePaymentEditForm();
    
    // Setup service management
    setupServiceManagement();
    
    // Setup form validation
    setupFormValidation();
    
    // Setup amount calculations
    setupAmountCalculations();
    
    // Initialize Lucide icons
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }
});

/**
 * Initialize payment edit form
 */
function initializePaymentEditForm() {
    var form = document.getElementById('editPaymentForm');
    if (form) {
        form.addEventListener('submit', handleFormSubmit);
    }
    
    // Setup existing service items
    setupExistingServiceItems();
    
    // Calculate initial totals
    updateServiceTotals();
}

/**
 * Setup existing service items with event listeners
 */
function setupExistingServiceItems() {
    var serviceItems = document.querySelectorAll('.service-item');
    serviceItems.forEach(function(item) {
        setupServiceItemEvents(item);
    });
}

/**
 * Setup service management functionality
 */
function setupServiceManagement() {
    var addServiceBtn = document.getElementById('addServiceBtn');
    if (addServiceBtn) {
        addServiceBtn.addEventListener('click', addServiceItem);
    }
    
    // Setup remove buttons for existing items
    document.addEventListener('click', function(e) {
        if (e.target.closest('.remove-service-btn')) {
            e.preventDefault();
            removeServiceItem(e.target.closest('.service-item'));
        }
    });
}

/**
 * Add new service item
 */
function addServiceItem() {
    var container = document.getElementById('serviceItemsContainer');
    var template = document.getElementById('serviceSelectionTemplate');

    if (!container || !template) {
        console.error('Service container or template not found');
        return;
    }
    
    // Clone the template's inner service-item div, not the template wrapper
    var templateServiceItem = template.querySelector('.service-item');
    if (!templateServiceItem) {
        console.error('Service item template structure not found');
        return;
    }

    var newItem = templateServiceItem.cloneNode(true);
    newItem.removeAttribute('data-item-id'); // New items don't have IDs yet
    
    // Clear values in the new item
    var serviceSelect = newItem.querySelector('.service-select');
    var quantityInput = newItem.querySelector('.quantity-input');
    var unitPriceInput = newItem.querySelector('.unit-price');
    
    if (serviceSelect) serviceSelect.value = '';
    if (quantityInput) quantityInput.value = '1';
    if (unitPriceInput) unitPriceInput.value = '';
    
    container.appendChild(newItem);
    setupServiceItemEvents(newItem);
    
    // Initialize Lucide icons for the new item
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }
    
    updateServiceTotals();
}

/**
 * Remove service item with validation
 */
function removeServiceItem(item) {
    var serviceItems = document.querySelectorAll('.service-item:not(.hidden)');
    
    // Prevent removal if only one item remains
    if (serviceItems.length <= 1) {
        showNotification('Phải có ít nhất một dịch vụ trong thanh toán', 'error');
        return;
    }
    
    // Confirm removal
    if (confirm('Bạn có chắc chắn muốn xóa dịch vụ này?')) {
        item.remove();
        updateServiceTotals();
        showNotification('Đã xóa dịch vụ', 'success');
    }
}

/**
 * Setup event listeners for a service item
 */
function setupServiceItemEvents(item) {
    var serviceSelect = item.querySelector('.service-select');
    var quantityInput = item.querySelector('.quantity-input');
    var unitPriceInput = item.querySelector('.unit-price');
    
    if (serviceSelect) {
        serviceSelect.addEventListener('change', function() {
            var selectedOption = this.options[this.selectedIndex];
            if (selectedOption.value) {
                var price = selectedOption.getAttribute('data-price') || '0';
                unitPriceInput.value = parseInt(price).toLocaleString('vi-VN') + ' VNĐ';
            } else {
                unitPriceInput.value = '';
            }
            updateServiceTotals();
        });
    }
    
    if (quantityInput) {
        quantityInput.addEventListener('input', function() {
            var quantity = parseInt(this.value);
            if (isNaN(quantity) || quantity < 1) {
                this.value = 1;
            } else if (quantity > 10) {
                this.value = 10;
                showNotification('Số lượng tối đa là 10', 'warning');
            }
            updateServiceTotals();
        });
        
        quantityInput.addEventListener('blur', function() {
            if (!this.value || parseInt(this.value) < 1) {
                this.value = 1;
                updateServiceTotals();
            }
        });
    }
}

/**
 * Update service totals and payment amounts
 */
function updateServiceTotals() {
    var serviceItems = document.querySelectorAll('.service-item:not(.hidden)');
    var subtotal = 0;
    
    serviceItems.forEach(function(item) {
        var serviceSelect = item.querySelector('.service-select');
        var quantityInput = item.querySelector('.quantity-input');
        
        if (serviceSelect && serviceSelect.value && quantityInput && quantityInput.value) {
            var selectedOption = serviceSelect.options[serviceSelect.selectedIndex];
            var price = parseInt(selectedOption.getAttribute('data-price') || '0');
            var quantity = parseInt(quantityInput.value) || 1;
            
            subtotal += price * quantity;
        }
    });
    
    // Update subtotal field
    var subtotalField = document.getElementById('subtotalAmount');
    if (subtotalField) {
        subtotalField.value = subtotal.toLocaleString('vi-VN');
    }
    
    // Auto-calculate VAT and total
    if (typeof autoCalculateTax === 'function') {
        autoCalculateTax();
    } else {
        // Fallback VAT calculation
        var taxField = document.getElementById('taxAmount');
        var totalField = document.getElementById('totalAmount');
        
        if (taxField && totalField) {
            var tax = Math.round(subtotal / 1.1 * 0.1); // VAT included in price
            taxField.value = tax.toLocaleString('vi-VN');
            totalField.value = subtotal.toLocaleString('vi-VN');
        }
    }
}

/**
 * Setup form validation
 */
function setupFormValidation() {
    var form = document.getElementById('editPaymentForm');
    if (!form) return;
    
    // Add validation for required fields
    var requiredFields = form.querySelectorAll('[required]');
    requiredFields.forEach(function(field) {
        field.addEventListener('blur', function() {
            validateField(field);
        });
        
        field.addEventListener('input', function() {
            clearFieldError(field);
        });
    });
}

/**
 * Setup amount calculation event listeners
 */
function setupAmountCalculations() {
    var subtotalField = document.getElementById('subtotalAmount');
    var taxField = document.getElementById('taxAmount');
    
    if (subtotalField) {
        subtotalField.addEventListener('input', function() {
            if (typeof autoCalculateTax === 'function') {
                autoCalculateTax();
            }
        });
    }
    
    if (taxField) {
        taxField.addEventListener('input', function() {
            if (typeof calculateTotal === 'function') {
                calculateTotal();
            }
        });
    }
}

/**
 * Handle form submission
 */
function handleFormSubmit(e) {
    e.preventDefault();
    
    // Validate form
    if (!validateForm()) {
        return;
    }
    
    // Collect form data
    var formData = new FormData(e.target);
    var paymentData = {};
    
    // Convert FormData to object
    for (var pair of formData.entries()) {
        paymentData[pair[0]] = pair[1];
    }
    
    // Clean amount values
    if (paymentData.totalAmount) {
        paymentData.totalAmount = paymentData.totalAmount.replace(/[^\d]/g, '');
    }
    if (paymentData.subtotalAmount) {
        paymentData.subtotalAmount = paymentData.subtotalAmount.replace(/[^\d]/g, '');
    }
    if (paymentData.taxAmount) {
        paymentData.taxAmount = paymentData.taxAmount.replace(/[^\d]/g, '');
    }
    
    // Collect service items data
    paymentData.paymentItems = collectServiceItemsData();
    
    console.log('Payment data:', paymentData);
    
    // Submit to API
    var endpoint = contextPath + '/api/payments/' + currentPaymentId;
    
    fetch(endpoint, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
            'Accept': 'application/json'
        },
        body: JSON.stringify(paymentData)
    })
    .then(function(response) {
        if (response.ok) {
            return response.json();
        } else {
            throw new Error('Network response was not ok');
        }
    })
    .then(function(data) {
        showNotification('Cập nhật thanh toán thành công!', 'success');
        
        // Redirect after success
        setTimeout(function() {
            window.location.href = contextPath + '/manager/payments';
        }, 2000);
    })
    .catch(function(error) {
        console.error('Error:', error);
        showNotification('Có lỗi xảy ra khi cập nhật thanh toán', 'error');
    });
}

/**
 * Collect service items data from the form
 */
function collectServiceItemsData() {
    var serviceItems = document.querySelectorAll('.service-item:not(.hidden)');
    var paymentItems = [];

    serviceItems.forEach(function(item) {
        var serviceSelect = item.querySelector('.service-select');
        var quantityInput = item.querySelector('.quantity-input');
        var itemId = item.getAttribute('data-item-id');

        if (serviceSelect && quantityInput && serviceSelect.value) {
            var selectedOption = serviceSelect.options[serviceSelect.selectedIndex];
            var serviceId = parseInt(serviceSelect.value);
            var quantity = parseInt(quantityInput.value) || 1;
            var unitPrice = selectedOption.getAttribute('data-price') || '0';
            var duration = selectedOption.getAttribute('data-duration') || '0';

            var paymentItem = {
                serviceId: serviceId,
                quantity: quantity,
                unitPrice: unitPrice,
                totalPrice: (parseInt(unitPrice) * quantity).toString(),
                serviceDuration: parseInt(duration)
            };
            
            // Include item ID for existing items
            if (itemId) {
                paymentItem.paymentItemId = parseInt(itemId);
            }

            paymentItems.push(paymentItem);
        }
    });

    return paymentItems;
}

/**
 * Validate the entire form
 */
function validateForm() {
    var isValid = true;
    
    // Validate service items
    if (!validateServiceItems()) {
        isValid = false;
    }
    
    // Validate required fields
    var requiredFields = document.querySelectorAll('[required]');
    requiredFields.forEach(function(field) {
        if (!validateField(field)) {
            isValid = false;
        }
    });
    
    return isValid;
}

/**
 * Validate service items
 */
function validateServiceItems() {
    var serviceItems = document.querySelectorAll('.service-item:not(.hidden)');
    
    // Filter out empty service items
    var validServiceItems = [];
    for (var i = 0; i < serviceItems.length; i++) {
        var serviceSelect = serviceItems[i].querySelector('.service-select');
        if (serviceSelect && serviceSelect.value) {
            validServiceItems.push(serviceItems[i]);
        }
    }

    // At least one service item should be selected
    if (validServiceItems.length === 0) {
        showNotification('Vui lòng chọn ít nhất một dịch vụ', 'error');
        return false;
    }

    // Validate each valid service item
    for (var j = 0; j < validServiceItems.length; j++) {
        var item = validServiceItems[j];
        var quantityInput = item.querySelector('.quantity-input');

        // Validate quantity
        var quantity = parseInt(quantityInput.value);
        if (!quantityInput || !quantityInput.value || isNaN(quantity) || quantity <= 0) {
            showNotification('Vui lòng nhập số lượng hợp lệ (lớn hơn 0) cho mục ' + (j + 1), 'error');
            return false;
        }

        if (quantity > 10) {
            showNotification('Số lượng không được vượt quá 10 cho mục ' + (j + 1), 'error');
            return false;
        }
    }

    return true;
}

/**
 * Validate individual field
 */
function validateField(field) {
    var value = field.value.trim();
    var isValid = true;
    var errorMessage = '';

    if (field.hasAttribute('required') && !value) {
        errorMessage = 'Trường này là bắt buộc';
        isValid = false;
    }

    if (isValid) {
        clearFieldError(field);
    } else {
        showFieldError(field, errorMessage);
    }

    return isValid;
}

/**
 * Show field error
 */
function showFieldError(field, message) {
    var errorElement = document.getElementById(field.name + 'Error') || 
                      document.getElementById(field.id + 'Error');
    
    if (errorElement) {
        errorElement.textContent = message;
        errorElement.classList.remove('hidden');
    }

    field.classList.add('border-red-500');
    field.classList.remove('border-gray-300');
}

/**
 * Clear field error
 */
function clearFieldError(field) {
    var errorElement = document.getElementById(field.name + 'Error') || 
                      document.getElementById(field.id + 'Error');
    
    if (errorElement) {
        errorElement.classList.add('hidden');
    }

    field.classList.remove('border-red-500');
    field.classList.add('border-gray-300');
}

/**
 * Enhanced notification system
 */
function showNotification(message, type) {
    type = type || 'info';

    var notification = document.createElement('div');
    notification.className = 'fixed top-4 right-4 z-50 p-4 rounded-lg shadow-lg max-w-sm transition-all duration-300 transform translate-x-full';

    var colors = {
        success: 'bg-green-500 text-white',
        error: 'bg-red-500 text-white',
        warning: 'bg-yellow-500 text-white',
        info: 'bg-blue-500 text-white'
    };

    notification.className += ' ' + (colors[type] || colors.info);

    var iconName = 'info';
    if (type === 'success') iconName = 'check-circle';
    else if (type === 'error') iconName = 'x-circle';
    else if (type === 'warning') iconName = 'alert-triangle';

    notification.innerHTML =
        '<div class="flex items-center gap-2">' +
            '<i data-lucide="' + iconName + '" class="h-5 w-5"></i>' +
            '<span>' + message + '</span>' +
        '</div>';

    document.body.appendChild(notification);
    
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }

    setTimeout(function() {
        notification.classList.remove('translate-x-full');
    }, 100);

    setTimeout(function() {
        notification.classList.add('translate-x-full');
        setTimeout(function() {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 300);
    }, 5000);
}

// Global functions for compatibility with payment-form.js
window.autoCalculateTax = function() {
    var subtotalField = document.getElementById('subtotalAmount');
    var taxField = document.getElementById('taxAmount');

    if (subtotalField && taxField && subtotalField.value) {
        var subtotal = parseInt(subtotalField.value.replace(/[^\d]/g, '')) || 0;
        var tax = Math.round(subtotal / 1.1 * 0.1); // VAT included in price
        taxField.value = tax.toLocaleString('vi-VN');
        calculateTotal();
    }
};

window.calculateTotal = function() {
    var subtotalField = document.getElementById('subtotalAmount');
    var totalField = document.getElementById('totalAmount');

    if (subtotalField && totalField) {
        var subtotal = parseInt(subtotalField.value.replace(/[^\d]/g, '')) || 0;
        totalField.value = subtotal > 0 ? subtotal.toLocaleString('vi-VN') : '';
    }
};
