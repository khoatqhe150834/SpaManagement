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
    console.log('Context path:', contextPath);

    // Get current payment ID from global variable or form
    currentPaymentId = window.currentPaymentId || document.getElementById('paymentId')?.value;

    if (!currentPaymentId) {
        // Fallback: extract from URL
        var pathParts = window.location.pathname.split('/');
        currentPaymentId = pathParts[pathParts.length - 1];
    }

    console.log('Current payment ID:', currentPaymentId);
    console.log('Window.currentPaymentId:', window.currentPaymentId);
    console.log('Form payment ID:', document.getElementById('paymentId')?.value);

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
    console.log('Initializing payment edit form...');
    var form = document.getElementById('editPaymentForm');
    console.log('Form element found:', form);

    if (form) {
        console.log('Adding submit event listener to form');
        form.addEventListener('submit', handleFormSubmit);

        // Also check if submit button exists
        var submitBtn = document.getElementById('submitBtn');
        console.log('Submit button found:', submitBtn);

        // Add direct click listener to submit button for debugging
        if (submitBtn) {
            submitBtn.addEventListener('click', function(e) {
                console.log('Submit button clicked directly');
                console.log('Button disabled:', submitBtn.disabled);
                console.log('Form element:', form);
            });
        }
    } else {
        console.error('Form element not found!');
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
        // Initialize the unit price display for existing items
        initializeExistingItemPrice(item);
    });
}

/**
 * Initialize unit price display for existing service items
 */
function initializeExistingItemPrice(item) {
    var serviceSelect = item.querySelector('.service-select');
    var unitPriceInput = item.querySelector('.unit-price');

    if (serviceSelect && serviceSelect.value && unitPriceInput) {
        var selectedOption = serviceSelect.options[serviceSelect.selectedIndex];
        if (selectedOption) {
            var price = selectedOption.getAttribute('data-price') || '0';
            var priceValue = parseFloat(price) || 0;
            unitPriceInput.value = Math.round(priceValue).toLocaleString('vi-VN') + ' VNĐ';
        }
    }
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
                // Parse the price as a decimal number (e.g., 750000.00)
                var priceValue = parseFloat(price) || 0;
                unitPriceInput.value = Math.round(priceValue).toLocaleString('vi-VN') + ' VNĐ';
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
        var totalPriceInput = item.querySelector('.total-price');

        if (serviceSelect && serviceSelect.value && quantityInput && quantityInput.value) {
            var selectedOption = serviceSelect.options[serviceSelect.selectedIndex];
            var price = parseFloat(selectedOption.getAttribute('data-price') || '0');
            var quantity = parseInt(quantityInput.value) || 1;
            var itemTotal = Math.round(price) * quantity;

            // Update individual item total
            if (totalPriceInput) {
                totalPriceInput.value = itemTotal.toLocaleString('vi-VN') + ' VNĐ';
            }

            subtotal += itemTotal;
        }
    });

    // Update subtotal display (span element, not input)
    var subtotalField = document.getElementById('subtotalAmount');
    if (subtotalField) {
        subtotalField.textContent = subtotal.toLocaleString('vi-VN') + ' VNĐ';
    }

    // Calculate VAT (10% of subtotal)
    var tax = Math.round(subtotal * 0.1);
    var total = subtotal + tax;

    // Update tax display (span element, not input)
    var taxField = document.getElementById('taxAmount');
    if (taxField) {
        taxField.textContent = tax.toLocaleString('vi-VN') + ' VNĐ';
    }

    // Update total display (span element, not input)
    var totalField = document.getElementById('totalAmount');
    if (totalField) {
        totalField.textContent = total.toLocaleString('vi-VN') + ' VNĐ';
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

    console.log('Form submit triggered');
    console.log('Event:', e);

    // Get submit button and disable it
    var submitBtn = document.getElementById('submitBtn');
    if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i data-lucide="loader-2" class="w-4 h-4 inline mr-2 animate-spin"></i>Đang cập nhật...';
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
    }

    // Validate form
    console.log('Starting form validation...');
    var isValid = validateForm();
    console.log('Form validation result:', isValid);

    if (!isValid) {
        console.log('Form validation failed, re-enabling button');
        // Re-enable button if validation fails
        if (submitBtn) {
            submitBtn.disabled = false;
            submitBtn.innerHTML = '<i data-lucide="save" class="w-4 h-4 inline mr-2"></i>Cập nhật thanh toán';
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }
        }
        return;
    }

    console.log('Form validation passed, proceeding with submission...');
    
    // Collect form data
    var formData = new FormData(e.target);
    var paymentData = {};

    // Convert FormData to object
    for (var pair of formData.entries()) {
        paymentData[pair[0]] = pair[1];
    }

    // Get amount values from display elements (spans)
    var subtotalElement = document.getElementById('subtotalAmount');
    var taxElement = document.getElementById('taxAmount');
    var totalElement = document.getElementById('totalAmount');

    if (subtotalElement) {
        paymentData.subtotalAmount = subtotalElement.textContent.replace(/[^\d]/g, '');
    }
    if (taxElement) {
        paymentData.taxAmount = taxElement.textContent.replace(/[^\d]/g, '');
    }
    if (totalElement) {
        paymentData.totalAmount = totalElement.textContent.replace(/[^\d]/g, '');
    }
    
    // Collect service items data
    paymentData.paymentItems = collectServiceItemsData();

    console.log('Payment data:', paymentData);
    console.log('Payment items:', paymentData.paymentItems);
    console.log('Current payment ID:', currentPaymentId);

    // Submit to API
    var endpoint = contextPath + '/api/payments/' + currentPaymentId;
    console.log('API endpoint:', endpoint);
    console.log('Making fetch request to:', endpoint);
    console.log('Request payload:', JSON.stringify(paymentData, null, 2));

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
        console.log('Received response:', response);
        console.log('Response status:', response.status);
        console.log('Response ok:', response.ok);

        if (response.ok) {
            return response.json();
        } else {
            return response.text().then(function(text) {
                console.error('Error response body:', text);
                throw new Error('HTTP ' + response.status + ': ' + response.statusText + ' - ' + text);
            });
        }
    })
    .then(function(data) {
        console.log('Payment updated successfully:', data);
        showNotification('Cập nhật thanh toán thành công!', 'success');

        // Redirect after success
        setTimeout(function() {
            window.location.href = contextPath + '/manager/payment-details?id=' + currentPaymentId;
        }, 2000);
    })
    .catch(function(error) {
        console.error('Fetch error:', error);
        console.error('Error stack:', error.stack);
        showNotification('Có lỗi xảy ra khi cập nhật thanh toán: ' + error.message, 'error');

        // Re-enable submit button
        var submitBtn = document.getElementById('submitBtn');
        if (submitBtn) {
            submitBtn.disabled = false;
            submitBtn.innerHTML = '<i data-lucide="save" class="w-4 h-4 inline mr-2"></i>Cập nhật thanh toán';
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }
        }
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
            var unitPriceRaw = selectedOption.getAttribute('data-price') || '0';
            var unitPrice = Math.round(parseFloat(unitPriceRaw)).toString();
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
    console.log('validateForm() called');
    var isValid = true;

    // Clean up empty service items first
    cleanupEmptyServiceItems();

    // Validate service items
    console.log('Validating service items...');
    var serviceItemsValid = validateServiceItems();
    console.log('Service items validation result:', serviceItemsValid);
    if (!serviceItemsValid) {
        isValid = false;
    }

    // Validate required fields (excluding those in empty service items)
    var requiredFields = document.querySelectorAll('[required]');
    console.log('Found required fields:', requiredFields.length);

    requiredFields.forEach(function(field) {
        // Check if this field is inside a service item
        var serviceItem = field.closest('.service-item');
        if (serviceItem) {
            // If it's in a service item, check if the service item has a selected service
            var serviceSelect = serviceItem.querySelector('.service-select');
            if (!serviceSelect || !serviceSelect.value) {
                // Skip validation for fields in empty service items
                console.log('Skipping validation for field in empty service item:', field.name || field.id);
                return;
            }
        }

        var fieldValid = validateField(field);
        console.log('Field', field.name || field.id, 'validation result:', fieldValid);
        if (!fieldValid) {
            isValid = false;
        }
    });

    console.log('Overall form validation result:', isValid);
    return isValid;
}

/**
 * Clean up empty service items by hiding them
 */
function cleanupEmptyServiceItems() {
    var serviceItems = document.querySelectorAll('.service-item');
    serviceItems.forEach(function(item) {
        var serviceSelect = item.querySelector('.service-select');
        if (!serviceSelect || !serviceSelect.value) {
            // Hide empty service items to exclude them from validation
            if (!item.classList.contains('hidden')) {
                console.log('Hiding empty service item');
                item.classList.add('hidden');
            }
        }
    });
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

    if (subtotalField && taxField && subtotalField.textContent) {
        var subtotal = parseInt(subtotalField.textContent.replace(/[^\d]/g, '')) || 0;
        var tax = Math.round(subtotal * 0.1); // 10% VAT
        taxField.textContent = tax.toLocaleString('vi-VN') + ' VNĐ';
        calculateTotal();
    }
};

window.calculateTotal = function() {
    var subtotalField = document.getElementById('subtotalAmount');
    var taxField = document.getElementById('taxAmount');
    var totalField = document.getElementById('totalAmount');

    if (subtotalField && taxField && totalField) {
        var subtotal = parseInt(subtotalField.textContent.replace(/[^\d]/g, '')) || 0;
        var tax = parseInt(taxField.textContent.replace(/[^\d]/g, '')) || 0;
        var total = subtotal + tax;
        totalField.textContent = total > 0 ? total.toLocaleString('vi-VN') + ' VNĐ' : '';
    }
};
