/**
 * Manager Payment Details Filter Functionality
 * Handles filtering and search functionality for manager payment details page
 */

// Global variables
let paymentDetailsFilterTimeout;
let paymentDetailsInitialized = false;

// Initialize when document is ready - removed to prevent double initialization
// The function will be called from the JSP file after DOM is ready

/**
 * Initialize all filter functionality for payment details
 */
function initializePaymentDetailsFilters() {
    // Prevent multiple initializations
    if (paymentDetailsInitialized) {
        console.log('Manager payment details filters already initialized, skipping...');
        return;
    }
    paymentDetailsInitialized = true;
    // Toggle filter panel
    const filterPanel = document.getElementById('paymentDetailsFilterPanel');
    const toggleFiltersBtn = document.getElementById('togglePaymentDetailsFilters');

    if (filterPanel && toggleFiltersBtn) {
        toggleFiltersBtn.addEventListener('click', function() {
            filterPanel.classList.toggle('show');
        });
    }
    
    // Apply filters
    $('#applyPaymentDetailsFilters').on('click', function() {
        applyPaymentDetailsFilters(true);
    });
    
    // Reset filters
    $('#resetPaymentDetailsFilters').on('click', function() {
        resetPaymentDetailsFilters();
    });
    
    // Real-time filtering on input change
    $('#paymentDetailsMethodFilter, #paymentDetailsStatusFilter').on('change', function() {
        applyPaymentDetailsFilters();
    });
    
    $('#paymentDetailsMinAmount, #paymentDetailsMaxAmount').on('input', function() {
        clearTimeout(paymentDetailsFilterTimeout);
        paymentDetailsFilterTimeout = setTimeout(function() {
            applyPaymentDetailsFilters();
        }, 500);
    });

    // Setup filters when DataTable is ready
    setupPaymentDetailsFilters();

    console.log('Manager payment details filters initialized');
}

/**
 * Setup filter functionality for DataTable integration
 */
function setupPaymentDetailsFilters() {
    // Wait for DataTable to be initialized
    $(document).on('init.dt', '#paymentItemsTable', function() {
        const table = $('#paymentItemsTable').DataTable();

        // Apply filters button
        $('#applyPaymentDetailsFilters').off('click').on('click', function() {
            applyPaymentDetailsFilters(true);
        });

        // Reset filters button
        $('#resetPaymentDetailsFilters').off('click').on('click', function() {
            resetPaymentDetailsFilters();
        });

        console.log('Manager payment details DataTable filters setup complete');
    });
}

/**
 * Apply all active filters to the payment items table
 */
function applyPaymentDetailsFilters(showNotification = false) {
    if (!$.fn.DataTable.isDataTable('#paymentItemsTable')) {
        return;
    }

    const table = $('#paymentItemsTable').DataTable();

    // Get filter values
    const serviceNameFilter = $('#paymentDetailsServiceFilter').val();
    const quantityFilter = $('#paymentDetailsQuantityFilter').val();
    const minAmount = $('#paymentDetailsMinAmount').val();
    const maxAmount = $('#paymentDetailsMaxAmount').val();
    const durationFilter = $('#paymentDetailsDurationFilter').val();

    // Clear all existing search functions and column searches
    $.fn.dataTable.ext.search = [];
    table.search('').columns().search('');

    // Add comprehensive custom search function if any filters are active
    if (serviceNameFilter || quantityFilter || minAmount || maxAmount || durationFilter) {
        $.fn.dataTable.ext.search.push(function(settings, data, dataIndex) {
            if (settings.nTable.id !== 'paymentItemsTable') {
                return true;
            }

            // Get the actual row element to access data attributes
            const row = settings.aoData[dataIndex].nTr;
            
            // Service name filter
            if (serviceNameFilter) {
                const serviceCell = $(row).find('td:eq(0)').text().trim().toLowerCase();
                if (serviceCell.indexOf(serviceNameFilter.toLowerCase()) === -1) {
                    return false;
                }
            }

            // Quantity filter
            if (quantityFilter) {
                const quantityCell = $(row).find('td:eq(1)').text().trim();
                const quantity = parseInt(quantityCell) || 0;
                const filterQuantity = parseInt(quantityFilter) || 0;
                if (quantity !== filterQuantity) {
                    return false;
                }
            }

            // Amount range filter (unit price)
            if (minAmount || maxAmount) {
                const priceCell = $(row).find('td:eq(2)');
                const priceText = priceCell.text().replace(/[^\d]/g, '');
                const price = parseFloat(priceText) || 0;
                const min = minAmount ? parseFloat(minAmount) : 0;
                const max = maxAmount ? parseFloat(maxAmount) : Number.MAX_VALUE;
                
                if (price < min || price > max) {
                    return false;
                }
            }

            // Duration filter
            if (durationFilter) {
                const durationCell = $(row).find('td:eq(3)').text().trim();
                const durationMatch = durationCell.match(/(\d+)/);
                const duration = durationMatch ? parseInt(durationMatch[1]) : 0;
                const filterDuration = parseInt(durationFilter) || 0;
                if (duration !== filterDuration) {
                    return false;
                }
            }

            return true;
        });
    }

    // Redraw table
    table.draw();

    // Update filter button appearance
    updatePaymentDetailsFilterStatus();

    if (showNotification) {
        showPaymentDetailsNotification('Đã áp dụng bộ lọc', 'success');
    }
}

/**
 * Reset all filters to default state
 */
function resetPaymentDetailsFilters() {
    // Clear all filter inputs
    $('#paymentDetailsServiceFilter').val('');
    $('#paymentDetailsQuantityFilter').val('');
    $('#paymentDetailsMinAmount').val('');
    $('#paymentDetailsMaxAmount').val('');
    $('#paymentDetailsDurationFilter').val('');

    // Clear all custom search functions
    $.fn.dataTable.ext.search = [];

    // Clear DataTable filters
    if ($.fn.DataTable.isDataTable('#paymentItemsTable')) {
        const table = $('#paymentItemsTable').DataTable();
        table.search('').columns().search('').draw();
    }

    // Update filter button appearance
    updatePaymentDetailsFilterStatus();

    showPaymentDetailsNotification('Đã đặt lại bộ lọc', 'info');
}

/**
 * Update filter button appearance based on active filters
 */
function updatePaymentDetailsFilterStatus() {
    const serviceNameFilter = $('#paymentDetailsServiceFilter').val();
    const quantityFilter = $('#paymentDetailsQuantityFilter').val();
    const minAmount = $('#paymentDetailsMinAmount').val();
    const maxAmount = $('#paymentDetailsMaxAmount').val();
    const durationFilter = $('#paymentDetailsDurationFilter').val();

    const hasActiveFilters = serviceNameFilter || quantityFilter || minAmount || maxAmount || durationFilter;

    const filterButton = $('#togglePaymentDetailsFilters');
    if (hasActiveFilters) {
        filterButton.addClass('bg-primary text-white').removeClass('bg-white text-gray-700');
        filterButton.find('i').addClass('text-white');
    } else {
        filterButton.removeClass('bg-primary text-white').addClass('bg-white text-gray-700');
        filterButton.find('i').removeClass('text-white');
    }
}

/**
 * Show notification to user
 */
function showPaymentDetailsNotification(message, type = 'info') {
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

/**
 * Get unique service names for filter dropdown
 */
function getUniqueServiceNames() {
    const serviceNames = [];
    if ($.fn.DataTable.isDataTable('#paymentItemsTable')) {
        const table = $('#paymentItemsTable').DataTable();
        table.rows().every(function() {
            const data = this.data();
            const serviceName = $(data[0]).text().trim();
            if (serviceName && serviceNames.indexOf(serviceName) === -1) {
                serviceNames.push(serviceName);
            }
        });
    }
    return serviceNames.sort();
}

/**
 * Populate service filter dropdown with unique values
 */
function populateServiceFilter() {
    const serviceNames = getUniqueServiceNames();
    const select = $('#paymentDetailsServiceFilter');
    
    // Clear existing options except the first one
    select.find('option:not(:first)').remove();
    
    // Add unique service names
    serviceNames.forEach(function(serviceName) {
        select.append(`<option value="${serviceName}">${serviceName}</option>`);
    });
}

// Initialize service filter when DataTable is ready
$(document).on('init.dt', '#paymentItemsTable', function() {
    setTimeout(populateServiceFilter, 100);
});
