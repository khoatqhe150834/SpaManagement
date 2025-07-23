/**
 * Customer Payment History Filter Functionality
 * Handles filtering and search functionality for customer payment history page
 */

// Global variables
let customerPaymentHistoryFilterTimeout;
let customerPaymentHistoryInitialized = false;

// Initialize when document is ready - removed to prevent double initialization
// The function will be called from the JSP file after DOM is ready

/**
 * Initialize all filter functionality for customer payment history
 */
window.initializeCustomerPaymentHistoryFilters = function initializeCustomerPaymentHistoryFilters() {
    // Prevent multiple initializations
    if (customerPaymentHistoryInitialized) {
        console.log('Customer payment history filters already initialized, skipping...');
        return;
    }
    customerPaymentHistoryInitialized = true;
    // Toggle filter panel
    const filterPanel = document.getElementById('customerPaymentHistoryFilterPanel');
    const toggleFiltersBtn = document.getElementById('toggleCustomerPaymentHistoryFilters');

    if (filterPanel && toggleFiltersBtn) {
        // Use jQuery for better compatibility and to avoid conflicts
        $(toggleFiltersBtn).off('click.customerPaymentHistoryFilter').on('click.customerPaymentHistoryFilter', function(e) {
            e.preventDefault();
            e.stopPropagation();
            $(filterPanel).toggleClass('show');
            
            // Toggle the icon rotation
            const icon = toggleFiltersBtn.querySelector('i[data-lucide="filter"]');
            if (icon) {
                $(icon).toggleClass('rotate-180');
            }
        });
    } else {
        console.warn('Filter panel or toggle button not found');
    }

    // Apply filters
    $('#applyCustomerPaymentHistoryFilters').on('click', function() {
        applyCustomerPaymentHistoryFilters(true);
    });

    // Reset filters
    $('#resetCustomerPaymentHistoryFilters').on('click', function() {
        resetCustomerPaymentHistoryFilters();
    });

    // Real-time filtering on input change
    $('#customerPaymentHistoryMethodFilter, #customerPaymentHistoryStatusFilter').on('change', function() {
        applyCustomerPaymentHistoryFilters();
    });

    $('#customerPaymentHistoryMinAmount, #customerPaymentHistoryMaxAmount').on('input', function() {
        clearTimeout(customerPaymentHistoryFilterTimeout);
        customerPaymentHistoryFilterTimeout = setTimeout(function() {
            applyCustomerPaymentHistoryFilters();
        }, 500);
    });

    // Payment ID filter with debounce
    $('#customerPaymentHistoryIdFilter').on('input', function() {
        clearTimeout(customerPaymentHistoryFilterTimeout);
        customerPaymentHistoryFilterTimeout = setTimeout(function() {
            applyCustomerPaymentHistoryFilters();
        }, 500);
    });

    // Date filters
    $('#customerPaymentHistoryDateFrom, #customerPaymentHistoryDateTo').on('change', function() {
        applyCustomerPaymentHistoryFilters();
    });

    // Setup filters when DataTable is ready
    setupCustomerPaymentHistoryFilters();


};

/**
 * Setup filter functionality for DataTable integration
 */
function setupCustomerPaymentHistoryFilters() {
    // Remove any existing event handlers to prevent duplicates
    $(document).off('init.dt', '#paymentsTable');

    // Wait for DataTable to be initialized
    $(document).one('init.dt', '#paymentsTable', function() {
        // Apply filters button - ensure single event binding
        $('#applyCustomerPaymentHistoryFilters').off('click').on('click', function() {
            applyCustomerPaymentHistoryFilters(true);
        });

        // Reset filters button - ensure single event binding
        $('#resetCustomerPaymentHistoryFilters').off('click').on('click', function() {
            resetCustomerPaymentHistoryFilters();
        });

        console.log('Customer payment history DataTable filters setup complete');
    });
}

/**
 * Apply all active filters to the customer payment history table
 */
function applyCustomerPaymentHistoryFilters(showNotification = false) {
    if (!$.fn.DataTable.isDataTable('#paymentsTable')) {
        return;
    }

    const table = $('#paymentsTable').DataTable();

    // Get filter values
    const paymentIdFilter = $('#customerPaymentHistoryIdFilter').val();
    const methodFilter = $('#customerPaymentHistoryMethodFilter').val();
    const statusFilter = $('#customerPaymentHistoryStatusFilter').val();
    const minAmount = $('#customerPaymentHistoryMinAmount').val();
    const maxAmount = $('#customerPaymentHistoryMaxAmount').val();
    const dateFrom = $('#customerPaymentHistoryDateFrom').val();
    const dateTo = $('#customerPaymentHistoryDateTo').val();

    // Clear all existing search functions and column searches
    $.fn.dataTable.ext.search = [];
    table.search('').columns().search('');

    // Add comprehensive custom search function if any filters are active
    if (paymentIdFilter || methodFilter || statusFilter || minAmount || maxAmount || dateFrom || dateTo) {
        $.fn.dataTable.ext.search.push(function(settings, data, dataIndex) {
            if (settings.nTable.id !== 'paymentsTable') {
                return true;
            }

            // Get the actual row element to access data attributes
            const row = settings.aoData[dataIndex].nTr;

            // Payment ID filter
            if (paymentIdFilter) {
                const paymentIdCell = $(row).find('td:eq(0)').text().trim().toLowerCase();
                if (paymentIdCell.indexOf(paymentIdFilter.toLowerCase()) === -1) {
                    return false;
                }
            }

            // Method filter
            if (methodFilter) {
                let methodText = getCustomerPaymentHistoryMethodDisplayText(methodFilter);
                const methodCell = $(row).find('td:eq(2)').text().trim();
                if (methodCell !== methodText) {
                    return false;
                }
            }

            // Status filter
            if (statusFilter) {
                let statusText = getCustomerPaymentHistoryStatusDisplayText(statusFilter);
                const statusCell = $(row).find('td:eq(4)').text().trim();
                if (statusCell !== statusText) {
                    return false;
                }
            }

            // Amount range filter
            if (minAmount || maxAmount) {
                const amountCell = $(row).find('td:eq(3)');
                const amount = parseFloat(amountCell.attr('data-order')) || 0;
                const min = minAmount ? parseFloat(minAmount) : 0;
                const max = maxAmount ? parseFloat(maxAmount) : Number.MAX_VALUE;
                
                if (amount < min || amount > max) {
                    return false;
                }
            }

            // Date range filter
            if (dateFrom || dateTo) {
                const dateCell = $(row).find('td:eq(1)');
                const dateString = dateCell.attr('data-order');
                const rowDate = dateString ? new Date(dateString) : new Date();

                if (dateFrom) {
                    const startDate = new Date(dateFrom);
                    if (rowDate < startDate) {
                        return false;
                    }
                }

                if (dateTo) {
                    const endDate = new Date(dateTo);
                    endDate.setHours(23, 59, 59, 999);
                    if (rowDate > endDate) {
                        return false;
                    }
                }
            }

            return true;
        });
    }

    // Redraw table
    table.draw();

    // Update filter button appearance
    updateCustomerPaymentHistoryFilterStatus();

    if (showNotification) {
        showCustomerPaymentHistoryNotification('Đã áp dụng bộ lọc', 'success');
    }
}

/**
 * Reset all filters to default state
 */
function resetCustomerPaymentHistoryFilters() {
    // Clear all filter inputs
    $('#customerPaymentHistoryIdFilter').val('');
    $('#customerPaymentHistoryMethodFilter').val('');
    $('#customerPaymentHistoryStatusFilter').val('');
    $('#customerPaymentHistoryMinAmount').val('');
    $('#customerPaymentHistoryMaxAmount').val('');
    $('#customerPaymentHistoryDateFrom').val('');
    $('#customerPaymentHistoryDateTo').val('');

    // Clear all custom search functions
    $.fn.dataTable.ext.search = [];

    // Clear DataTable filters
    if ($.fn.DataTable.isDataTable('#paymentsTable')) {
        const table = $('#paymentsTable').DataTable();
        table.search('').columns().search('').draw();
    }

    // Update filter button appearance
    updateCustomerPaymentHistoryFilterStatus();

    showCustomerPaymentHistoryNotification('Đã đặt lại bộ lọc', 'info');
}

/**
 * Update filter button appearance based on active filters
 */
function updateCustomerPaymentHistoryFilterStatus() {
    const paymentIdFilter = $('#customerPaymentHistoryIdFilter').val();
    const methodFilter = $('#customerPaymentHistoryMethodFilter').val();
    const statusFilter = $('#customerPaymentHistoryStatusFilter').val();
    const minAmount = $('#customerPaymentHistoryMinAmount').val();
    const maxAmount = $('#customerPaymentHistoryMaxAmount').val();
    const dateFrom = $('#customerPaymentHistoryDateFrom').val();
    const dateTo = $('#customerPaymentHistoryDateTo').val();

    const hasActiveFilters = paymentIdFilter || methodFilter || statusFilter || minAmount || maxAmount || dateFrom || dateTo;

    const filterButton = $('#toggleCustomerPaymentHistoryFilters');
    if (hasActiveFilters) {
        filterButton.addClass('bg-primary text-white').removeClass('bg-white text-gray-700');
        filterButton.find('i').addClass('text-white');
    } else {
        filterButton.removeClass('bg-primary text-white').addClass('bg-white text-gray-700');
        filterButton.find('i').removeClass('text-white');
    }
}

/**
 * Convert payment method enum to display text
 */
function getCustomerPaymentHistoryMethodDisplayText(methodEnum) {
    switch(methodEnum) {
        case 'BANK_TRANSFER': return 'Chuyển khoản';
        case 'CREDIT_CARD': return 'Thẻ tín dụng';
        case 'VNPAY': return 'VNPay';
        case 'MOMO': return 'MoMo';
        case 'ZALOPAY': return 'ZaloPay';
        case 'CASH': return 'Tiền mặt';
        default: return methodEnum;
    }
}

/**
 * Convert payment status enum to display text
 */
function getCustomerPaymentHistoryStatusDisplayText(statusEnum) {
    switch(statusEnum) {
        case 'PAID': return 'Đã thanh toán';
        case 'PENDING': return 'Chờ xử lý';
        case 'FAILED': return 'Thất bại';
        case 'REFUNDED': return 'Đã hoàn tiền';
        default: return statusEnum;
    }
}

/**
 * Show notification to user
 */
function showCustomerPaymentHistoryNotification(message, type = 'info') {
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
