/**
 * Payment Form JavaScript
 * Handles form validation, submission, and UI interactions for payment add/edit forms
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize Lucide icons
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }

    // Get form elements
    var form = document.getElementById('addPaymentForm') || document.getElementById('editPaymentForm');
    var submitBtn = document.getElementById('submitBtn');

    // Check if we're in edit mode
    var isEditMode = window.isEditMode || false;
    var currentPaymentId = window.currentPaymentId || null;

    // Get context path
    var metaTag = document.querySelector('meta[name="context-path"]');
    var contextPath = metaTag ? metaTag.content : '';

    if (form) {
        // Setup form validation
        setupFormValidation();

        // Setup form submission
        form.addEventListener('submit', handleFormSubmit);

        // Setup amount formatting and calculations
        setupAmountFormatting();

        // Setup customer search functionality
        setupCustomerSearch();

        // Setup service items functionality
        setupServiceItems();

        // Reference number is auto-generated on server side

        // Payment date validation removed - using current time automatically
    }

    /**
     * Sets up form validation for all required fields
     */
    function setupFormValidation() {
        var requiredFields = form.querySelectorAll('[required]');

        for (var i = 0; i < requiredFields.length; i++) {
            var field = requiredFields[i];
            // Add real-time validation
            field.addEventListener('blur', function() {
                validateField(this);
            });

            field.addEventListener('input', function() {
                // Clear error state when user starts typing
                clearFieldError(this);
            });
        }
    }

    /**
     * Sets up amount field formatting and calculations
     */
    function setupAmountFormatting() {
        var subtotalField = document.getElementById('subtotalAmount');
        var taxField = document.getElementById('taxAmount');
        var totalField = document.getElementById('totalAmount');

        // Amount fields are now readonly and calculated automatically
        // No input event listeners needed since they're not editable

        // Subtotal is now readonly and calculated from services
        // No blur event listener needed

        // Remove formatting before form submission (readonly fields are already properly formatted)
        form.addEventListener('submit', function() {
            [subtotalField, taxField, totalField].forEach(function(field) {
                if (field && field.value) {
                    var rawValue = field.value.replace(/[^\d]/g, '');
                    field.value = rawValue;
                }
            });
        });
    }



    /**
     * Handles form submission
     */
    function handleFormSubmit(e) {
        e.preventDefault();

        console.log('Form submission started');

        // Validate all fields
        if (!validateForm()) {
            console.log('Form validation failed');
            return;
        }

        // Show loading state
        showLoadingState();

        // Prepare form data
        var formData = new FormData(form);
        var paymentData = {};

        // Convert FormData to object using a more compatible approach
        try {
            formData.forEach(function(value, key) {
                paymentData[key] = value;
            });
        } catch (error) {
            console.log('FormData.forEach not supported, using fallback');
            // Fallback for older browsers
            var inputs = form.querySelectorAll('input, select, textarea');
            for (var i = 0; i < inputs.length; i++) {
                var input = inputs[i];
                if (input.name && input.name !== 'paymentDate') { // Skip paymentDate since we removed it
                    paymentData[input.name] = input.value;
                    console.log('Added field:', input.name, '=', input.value);
                }
            }
        }
        
        // Remove fields that are auto-generated on server side
        delete paymentData.paymentDate;
        delete paymentData.paymentStatus; // Auto-set to PAID
        delete paymentData.referenceNumber; // Auto-generated

        // Clean amount values (remove formatting) and validate
        if (paymentData.totalAmount) {
            paymentData.totalAmount = paymentData.totalAmount.replace(/[^\d]/g, '');
            console.log('Cleaned totalAmount:', paymentData.totalAmount);
        }
        if (paymentData.subtotalAmount) {
            paymentData.subtotalAmount = paymentData.subtotalAmount.replace(/[^\d]/g, '');
            console.log('Cleaned subtotalAmount:', paymentData.subtotalAmount);
        }
        if (paymentData.taxAmount) {
            paymentData.taxAmount = paymentData.taxAmount.replace(/[^\d]/g, '');
            console.log('Cleaned taxAmount:', paymentData.taxAmount);
        }
        
        // Validate amounts are valid numbers
        if (!paymentData.totalAmount || isNaN(parseInt(paymentData.totalAmount))) {
            showNotification('Tổng tiền không hợp lệ', 'error');
            hideLoadingState();
            return;
        }
        if (!paymentData.subtotalAmount || isNaN(parseInt(paymentData.subtotalAmount))) {
            showNotification('Tiền dịch vụ không hợp lệ', 'error');
            hideLoadingState();
            return;
        }

        // Collect service items data
        paymentData.paymentItems = collectServiceItemsData();

        console.log('Payment data:', paymentData);

        // Determine API endpoint
        var endpoint = isEditMode
            ? contextPath + '/api/payments/' + currentPaymentId
            : contextPath + '/api/payments';

        console.log('Submitting to endpoint:', endpoint);

        // Submit form data
        console.log('Sending request to:', endpoint);
        console.log('Request method:', isEditMode ? 'PUT' : 'POST');
        console.log('Request body:', JSON.stringify(paymentData, null, 2));
        
        fetch(endpoint, {
            method: isEditMode ? 'PUT' : 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest',
                'Accept': 'application/json'
            },
            body: JSON.stringify(paymentData)
        })
        .then(function(response) {
            console.log('Response status:', response.status);
            console.log('Response headers:', response.headers);

            // Check if response is OK
            if (response.ok) {
                // Try to parse as JSON
                return response.text().then(function(text) {
                    console.log('Success response text:', text);
                    try {
                        return JSON.parse(text);
                    } catch (e) {
                        console.error('Error parsing JSON:', e);
                        console.log('Response text:', text);
                        throw new Error('Invalid JSON response from server');
                    }
                });
            }

            // If not OK, try to get error details
            return response.text().then(function(text) {
                console.error('Error response status:', response.status);
                console.error('Error response text:', text);
                
                // Try to parse error response as JSON
                try {
                    const errorData = JSON.parse(text);
                    throw new Error(errorData.message || 'Server error: ' + response.status);
                } catch (parseError) {
                    // If not JSON, use the raw text
                    throw new Error('Server error: ' + response.status + ' - ' + text);
                }
            });
        })
        .then(function(data) {
            console.log('Response data:', data);
            if (data && data.success) {
                // Show success message
                showNotification(
                    isEditMode ? 'Cập nhật thanh toán thành công!' : 'Thêm thanh toán thành công!',
                    'success'
                );

                // Redirect to payments management page after delay
                setTimeout(function() {
                    window.location.href = contextPath + '/manager/payments-management';
                }, 1500);
            } else {
                throw new Error((data && data.message) || 'Có lỗi xảy ra');
            }
        })
        .catch(function(error) {
            console.error('Error:', error);
            showNotification('Có lỗi xảy ra: ' + error.message, 'error');
            hideLoadingState();
        });
    }

    /**
     * Validates the entire form
     */
    function validateForm() {
        var isValid = true;
        var requiredFields = form.querySelectorAll('[required]');

        for (var i = 0; i < requiredFields.length; i++) {
            if (!validateField(requiredFields[i])) {
                isValid = false;
            }
        }

        // Additional custom validations
        if (!validateAmount()) {
            isValid = false;
        }

        if (!validateServiceItems()) {
            isValid = false;
        }

        return isValid;
    }

    /**
     * Validates a single field
     */
    function validateField(field) {
        var value = field.value.trim();
        var fieldName = field.name;
        var isValid = true;
        var errorMessage = '';

        // Check if required field is empty
        if (field.hasAttribute('required') && !value) {
            errorMessage = 'Trường này là bắt buộc';
            isValid = false;
        }

        // Field-specific validations
        switch (fieldName) {
            case 'customerId':
                // In edit mode, customerId is a hidden field and already validated
                if (!isEditMode && value && !isValidCustomerId(value)) {
                    errorMessage = 'Vui lòng chọn khách hàng hợp lệ';
                    isValid = false;
                }
                break;

            // Payment date validation removed - using current time automatically

            case 'totalAmount':
                if (value && !isValidAmount(value)) {
                    errorMessage = 'Số tiền phải lớn hơn 0';
                    isValid = false;
                }
                break;
        }

        // Show/hide error
        if (isValid) {
            clearFieldError(field);
        } else {
            showFieldError(field, errorMessage);
        }

        return isValid;
    }

    /**
     * Validates amount fields specifically
     */
    function validateAmount() {
        var subtotalField = document.getElementById('subtotalAmount');
        var totalField = document.getElementById('totalAmount');
        var isValid = true;

        // Validate subtotal
        if (subtotalField) {
            var subtotalValue = subtotalField.value.replace(/[^\d]/g, '');
            var subtotal = parseInt(subtotalValue);

            if (isNaN(subtotal) || subtotal <= 0) {
                showFieldError(subtotalField, 'Tiền dịch vụ phải lớn hơn 0');
                isValid = false;
            } else if (subtotal > 100000000) { // 100 million VND limit
                showFieldError(subtotalField, 'Tiền dịch vụ không được vượt quá 100,000,000 VNĐ');
                isValid = false;
            } else {
                clearFieldError(subtotalField);
            }
        }

        // Validate total
        if (totalField) {
            var totalValue = totalField.value.replace(/[^\d]/g, '');
            var total = parseInt(totalValue);

            if (isNaN(total) || total <= 0) {
                showFieldError(totalField, 'Tổng tiền không hợp lệ');
                isValid = false;
            } else {
                clearFieldError(totalField);
            }
        }

        return isValid;
    }



    /**
     * Validation helper functions
     */
    function isValidCustomerId(value) {
        return /^\d+$/.test(value);
    }

    function isValidDate(value) {
        var date = new Date(value);
        return date instanceof Date && !isNaN(date);
    }

    function isValidAmount(value) {
        var cleanValue = value.replace(/[^\d]/g, '');
        var amount = parseInt(cleanValue);
        return !isNaN(amount) && amount > 0;
    }



    /**
     * Shows loading state on submit button
     */
    function showLoadingState() {
        if (submitBtn) {
            submitBtn.disabled = true;
            var originalText = submitBtn.innerHTML;
            submitBtn.setAttribute('data-original-text', originalText);
            submitBtn.innerHTML = '<i data-lucide="loader-2" class="w-4 h-4 inline mr-2 animate-spin"></i>Đang xử lý...';
            lucide.createIcons();
        }
    }

    /**
     * Hides loading state on submit button
     */
    function hideLoadingState() {
        if (submitBtn) {
            submitBtn.disabled = false;
            var originalText = submitBtn.getAttribute('data-original-text');
            if (originalText) {
                submitBtn.innerHTML = originalText;
                lucide.createIcons();
            }
        }
    }


});

// Additional utility functions for external use
window.PaymentForm = {
    /**
     * Formats amount with thousand separators
     */
    formatAmount: function(amount) {
        if (!amount) return '';
        var cleanAmount = amount.toString().replace(/[^\d]/g, '');
        return parseInt(cleanAmount).toLocaleString('vi-VN');
    },

    /**
     * Cleans formatted amount to get raw number
     */
    cleanAmount: function(formattedAmount) {
        return formattedAmount.replace(/[^\d]/g, '');
    },
    
    /**
     * Shows notification message (added for external access)
     */
    showNotification: function(message, type) {
        showNotification(message, type);
    }
};

/**
 * Setup customer search functionality
 */
function setupCustomerSearch() {
    var searchInput = document.getElementById('customerSearch');
    var customerSelect = document.getElementById('customerId');
    var customerInfo = document.getElementById('selectedCustomerInfo');

    if (searchInput && customerSelect) {
        // Filter customers as user types
        searchInput.addEventListener('input', function() {
            var searchTerm = this.value.toLowerCase();
            var options = customerSelect.querySelectorAll('option');

            for (var i = 1; i < options.length; i++) { // Skip first empty option
                var option = options[i];
                var text = option.textContent.toLowerCase();
                var name = option.getAttribute('data-name') || '';
                var phone = option.getAttribute('data-phone') || '';

                if (text.includes(searchTerm) || name.toLowerCase().includes(searchTerm) || phone.includes(searchTerm)) {
                    option.style.display = '';
                } else {
                    option.style.display = 'none';
                }
            }
        });

        // Show customer info when selected
        customerSelect.addEventListener('change', function() {
            var selectedOption = this.options[this.selectedIndex];
            if (selectedOption.value) {
                var name = selectedOption.getAttribute('data-name') || '';
                var phone = selectedOption.getAttribute('data-phone') || '';
                var email = selectedOption.getAttribute('data-email') || '';

                document.getElementById('customerName').textContent = name;
                document.getElementById('customerPhone').textContent = phone;
                document.getElementById('customerEmail').textContent = email;

                customerInfo.classList.remove('hidden');
            } else {
                customerInfo.classList.add('hidden');
            }
        });
    }
}
/**
 * Setup service items functionality
 */
function setupServiceItems() {
    var addServiceBtn = document.getElementById('addServiceBtn');
    var serviceContainer = document.getElementById('serviceItemsContainer');
    var template = document.getElementById('serviceSelectionTemplate');

    if (addServiceBtn && serviceContainer && template) {
        addServiceBtn.addEventListener('click', function() {
            addServiceItem();
        });
    }
}

/**
 * Add a new service item
 */
function addServiceItem() {
    var serviceContainer = document.getElementById('serviceItemsContainer');
    var template = document.getElementById('serviceSelectionTemplate');

    if (serviceContainer && template) {
        // Remove empty state message if it exists
        var emptyState = serviceContainer.querySelector('.text-center');
        if (emptyState) {
            emptyState.remove();
        }

        // Clone template
        var newItem = template.cloneNode(true);
        newItem.id = '';
        newItem.classList.remove('hidden');

        // Setup event listeners for the new item
        setupServiceItemEvents(newItem);

        serviceContainer.appendChild(newItem);

        // Initialize Lucide icons for the new item
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
    }
}

/**
 * Setup events for a service item
 */
function setupServiceItemEvents(item) {
    var serviceSelect = item.querySelector('.service-select');
    var quantityInput = item.querySelector('.quantity-input');
    var unitPriceInput = item.querySelector('.unit-price');
    var removeBtn = item.querySelector('.remove-service-btn');

    // Update unit price when service is selected
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

    // Update totals when quantity changes
    if (quantityInput) {
        quantityInput.addEventListener('input', function() {
            updateServiceTotals();
        });
    }

    // Remove service item
    if (removeBtn) {
        removeBtn.addEventListener('click', function() {
            item.remove();
            updateServiceTotals();

            // Show empty state if no items left
            var serviceContainer = document.getElementById('serviceItemsContainer');
            if (serviceContainer && serviceContainer.children.length === 0) {
                serviceContainer.innerHTML =
                    '<div class="text-center py-8 text-gray-500">' +
                        '<i data-lucide="package" class="w-12 h-12 mx-auto mb-2 text-gray-400"></i>' +
                        '<p>Chưa có dịch vụ nào được chọn</p>' +
                        '<p class="text-sm">Nhấn "Thêm dịch vụ" để bắt đầu</p>' +
                    '</div>';
                if (typeof lucide !== 'undefined') {
                    lucide.createIcons();
                }
            }
        });
    }
}

/**
 * Update service totals and recalculate payment amounts
 */
function updateServiceTotals() {
    var serviceItems = document.querySelectorAll('.service-item:not(.hidden)');
    var total = 0;

    serviceItems.forEach(function(item) {
        var serviceSelect = item.querySelector('.service-select');
        var quantityInput = item.querySelector('.quantity-input');

        if (serviceSelect && quantityInput && serviceSelect.value) {
            var selectedOption = serviceSelect.options[serviceSelect.selectedIndex];
            var price = parseInt(selectedOption.getAttribute('data-price') || '0');
            var quantity = parseInt(quantityInput.value) || 1;
            total += price * quantity;
        }
    });

    // Update subtotal field
    var subtotalField = document.getElementById('subtotalAmount');
    if (subtotalField) {
        if (total > 0) {
            subtotalField.value = total.toLocaleString('vi-VN');
            // Always auto-calculate tax when services change
            autoCalculateTax();
        } else {
            subtotalField.value = '';
            // Clear tax and total when no services
            var taxField = document.getElementById('taxAmount');
            var totalField = document.getElementById('totalAmount');
            if (taxField) taxField.value = '';
            if (totalField) totalField.value = '';
        }
    }
}

// Reference number generation removed - handled automatically on server side

/**
 * Auto-calculate 10% VAT based on subtotal
 * VAT = subtotal * 0.1 (10% of subtotal)
 * Global function accessible from anywhere
 */
function autoCalculateTax() {
    var subtotalField = document.getElementById('subtotalAmount');
    var taxField = document.getElementById('taxAmount');

    if (subtotalField && taxField && subtotalField.value) {
        var subtotal = parseInt(subtotalField.value.replace(/[^\d]/g, '')) || 0;
        // Calculate VAT: VAT = subtotal * 0.1 (10% of subtotal)
        var tax = Math.round(subtotal * 0.1);
        taxField.value = tax.toLocaleString('vi-VN');
        calculateTotal();
    }
}

/**
 * Calculate total amount
 * Total = subtotal + tax (10% VAT)
 * Global function accessible from anywhere
 */
function calculateTotal() {
    var subtotalField = document.getElementById('subtotalAmount');
    var taxField = document.getElementById('taxAmount');
    var totalField = document.getElementById('totalAmount');

    if (subtotalField && totalField) {
        var subtotal = parseInt(subtotalField.value.replace(/[^\d]/g, '')) || 0;
        var tax = parseInt(taxField.value.replace(/[^\d]/g, '')) || 0;

        // Total = subtotal + tax
        var total = subtotal + tax;
        totalField.value = total > 0 ? total.toLocaleString('vi-VN') : '';
    }
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

        if (serviceSelect && quantityInput && serviceSelect.value) {
            var selectedOption = serviceSelect.options[serviceSelect.selectedIndex];
            var serviceId = parseInt(serviceSelect.value);
            var quantity = parseInt(quantityInput.value) || 1;
            var unitPrice = selectedOption.getAttribute('data-price') || '0';
            var duration = selectedOption.getAttribute('data-duration') || '0';

            paymentItems.push({
                serviceId: serviceId,
                quantity: quantity,
                unitPrice: unitPrice,
                totalPrice: (parseInt(unitPrice) * quantity).toString(),
                serviceDuration: parseInt(duration)
            });
        }
    });

    return paymentItems;
}

// Payment date validation functions removed - using current time automatically

/**
 * Enhanced service validation
 */
function validateServiceItems() {
    var serviceItems = document.querySelectorAll('.service-item:not(.hidden)');

    // Filter out empty service items (items without service selected)
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
    var isValid = true;
    for (var j = 0; j < validServiceItems.length; j++) {
        var item = validServiceItems[j];
        var serviceSelect = item.querySelector('.service-select');
        var quantityInput = item.querySelector('.quantity-input');

        // Validate quantity
        var quantity = parseInt(quantityInput.value);
        if (!quantityInput || !quantityInput.value || isNaN(quantity) || quantity <= 0) {
            showNotification('Vui lòng nhập số lượng hợp lệ (lớn hơn 0) cho mục ' + (j + 1), 'error');
            isValid = false;
            break;
        }

        if (quantity > 10) {
            showNotification('Số lượng không được vượt quá 10 cho mục ' + (j + 1), 'error');
            isValid = false;
            break;
        }

        // Validate service price
        var selectedOption = serviceSelect.options[serviceSelect.selectedIndex];
        var price = selectedOption.getAttribute('data-price');
        if (!price || parseInt(price) <= 0) {
            showNotification('Dịch vụ được chọn ở mục ' + (j + 1) + ' không có giá hợp lệ', 'error');
            isValid = false;
            break;
        }
    }

    return isValid;
}

/**
 * Show field error with enhanced styling
 */
function showFieldError(field, message) {
    var errorElement = document.getElementById(field.name + 'Error') ||
                      document.getElementById(field.id + 'Error');

    if (errorElement) {
        errorElement.textContent = message;
        errorElement.classList.remove('hidden');
    }

    // Add error styling to field
    field.classList.add('border-red-500', 'field-error');
    field.classList.remove('border-gray-300');

    // Remove error animation after it completes
    setTimeout(function() {
        field.classList.remove('field-error');
    }, 300);
}

/**
 * Clear field error with enhanced styling
 */
function clearFieldError(field) {
    var errorElement = document.getElementById(field.name + 'Error') ||
                      document.getElementById(field.id + 'Error');

    if (errorElement) {
        errorElement.classList.add('hidden');
    }

    // Remove error styling
    field.classList.remove('border-red-500');
    field.classList.add('border-gray-300');
}

/**
 * Enhanced notification system
 */
function showNotification(message, type) {
    // Default type to info if not provided
    type = type || 'info';

    // Create notification element
    var notification = document.createElement('div');
    notification.className = 'fixed top-4 right-4 z-50 p-4 rounded-lg shadow-lg max-w-sm transition-all duration-300 transform translate-x-full';

    // Set colors based on type
    var colors = {
        success: 'bg-green-500 text-white',
        error: 'bg-red-500 text-white',
        warning: 'bg-yellow-500 text-white',
        info: 'bg-blue-500 text-white'
    };

    notification.className += ' ' + (colors[type] || colors.info);

    // Determine icon based on type
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

    // Initialize Lucide icons if available
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }

    // Animate in
    setTimeout(function() {
        notification.classList.remove('translate-x-full');
    }, 100);

    // Auto remove after 5 seconds
    setTimeout(function() {
        notification.classList.add('translate-x-full');
        setTimeout(function() {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 300);
    }, 5000);
}