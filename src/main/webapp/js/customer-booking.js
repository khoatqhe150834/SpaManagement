/**
 * Customer Booking Filter Functionality
 * Handles filtering and search functionality for customer booking page
 */

// Global variables
let customerBookingFilterTimeout;
let customerBookingInitialized = false;

/**
 * Initialize all filter functionality for customer booking
 */
window.initializeCustomerBookingFilters = function initializeCustomerBookingFilters() {
    // Prevent multiple initializations
    if (customerBookingInitialized) {
        console.log('Customer booking filters already initialized, skipping...');
        return;
    }
    customerBookingInitialized = true;
    
    // Toggle filter panel
    const filterPanel = document.getElementById('customerBookingFilterPanel');
    const toggleFiltersBtn = document.getElementById('toggleCustomerBookingFilters');

    if (filterPanel && toggleFiltersBtn) {
        // Use jQuery for better compatibility and to avoid conflicts
        $(toggleFiltersBtn).off('click.customerBookingFilter').on('click.customerBookingFilter', function(e) {
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
    $('#applyCustomerBookingFilters').on('click', function() {
        applyCustomerBookingFilters(true);
    });

    // Reset filters
    $('#resetCustomerBookingFilters').on('click', function() {
        resetCustomerBookingFilters();
    });

    // Real-time filtering on input change
    $('#customerBookingStatusFilter, #customerBookingPaymentFilter').on('change', function() {
        applyCustomerBookingFilters();
    });

    $('#customerBookingIdFilter, #customerBookingServiceFilter, #customerBookingTherapistFilter').on('input', function() {
        clearTimeout(customerBookingFilterTimeout);
        customerBookingFilterTimeout = setTimeout(function() {
            applyCustomerBookingFilters();
        }, 500);
    });

    // Date filters
    $('#customerBookingDateFrom, #customerBookingDateTo').on('change', function() {
        applyCustomerBookingFilters();
    });

    // Setup filters when DataTable is ready
    setupCustomerBookingFilters();
};

/**
 * Setup filter functionality for DataTable integration
 */
function setupCustomerBookingFilters() {
    // Remove any existing event handlers to prevent duplicates
    $(document).off('init.dt', '#bookingsTable');

    // Wait for DataTable to be initialized
    $(document).one('init.dt', '#bookingsTable', function() {
        // Apply filters button - ensure single event binding
        $('#applyCustomerBookingFilters').off('click').on('click', function() {
            applyCustomerBookingFilters(true);
        });

        // Reset filters button - ensure single event binding
        $('#resetCustomerBookingFilters').off('click').on('click', function() {
            resetCustomerBookingFilters();
        });

        console.log('Customer booking DataTable filters initialized');
    });
}

/**
 * Apply all active filters to the DataTable
 */
function applyCustomerBookingFilters(showNotification = false) {
    // Use global table reference if available
    const table = window.customerBookingTable || $('#bookingsTable').DataTable();

    if (!table || !$.fn.DataTable.isDataTable('#bookingsTable')) {
        console.warn('DataTable not initialized yet');
        return;
    }
    
    // Get filter values
    const filters = {
        bookingId: $('#customerBookingIdFilter').val().trim(),
        service: $('#customerBookingServiceFilter').val().trim(),
        status: $('#customerBookingStatusFilter').val(),
        payment: $('#customerBookingPaymentFilter').val(),
        dateFrom: $('#customerBookingDateFrom').val(),
        dateTo: $('#customerBookingDateTo').val(),
        therapist: $('#customerBookingTherapistFilter').val().trim()
    };

    // Remove any existing custom search functions
    $.fn.dataTable.ext.search = $.fn.dataTable.ext.search.filter(function(fn) {
        return fn.name !== 'customerBookingFilter';
    });

    // Add custom search function if any filters are active
    const hasActiveFilters = Object.values(filters).some(v => v && v.trim());

    if (hasActiveFilters) {
        $.fn.dataTable.ext.search.push(function customerBookingFilter(settings, data, dataIndex) {
            if (settings.nTable.id !== 'bookingsTable') {
                return true;
            }

            // Check booking ID filter (column 0)
            if (filters.bookingId && !data[0].toLowerCase().includes(filters.bookingId.toLowerCase())) {
                return false;
            }

            // Check service filter (column 1)
            if (filters.service && !data[1].toLowerCase().includes(filters.service.toLowerCase())) {
                return false;
            }

            // Check therapist filter (column 3)
            if (filters.therapist && !data[3].toLowerCase().includes(filters.therapist.toLowerCase())) {
                return false;
            }

            // Check status filter (column 5) - match exact status value
            if (filters.status) {
                // Get the raw data from the table
                const rowData = table.row(dataIndex).data();
                if (rowData && rowData.bookingStatus !== filters.status) {
                    return false;
                }
            }

            // Check payment filter (column 6) - match exact payment value
            if (filters.payment) {
                // Get the raw data from the table
                const rowData = table.row(dataIndex).data();
                if (rowData && rowData.paymentStatus !== filters.payment) {
                    return false;
                }
            }

            // Check date range filter
            if (filters.dateFrom || filters.dateTo) {
                const rowData = table.row(dataIndex).data();
                if (rowData && rowData.appointmentDate) {
                    const rowDate = new Date(rowData.appointmentDate);

                    if (filters.dateFrom) {
                        const fromDate = new Date(filters.dateFrom);
                        if (rowDate < fromDate) return false;
                    }

                    if (filters.dateTo) {
                        const toDate = new Date(filters.dateTo);
                        if (rowDate > toDate) return false;
                    }
                }
            }

            return true;
        });
    }

    // Redraw the table
    table.draw();

    if (showNotification && typeof showBookingNotification === 'function') {
        const activeFilters = Object.values(filters).filter(v => v && v.trim()).length;
        if (activeFilters > 0) {
            showBookingNotification(`Đã áp dụng ${activeFilters} bộ lọc`, 'info');
        }
    }

    console.log('Customer booking filters applied:', filters);
}

/**
 * Reset all filters to their default state
 */
function resetCustomerBookingFilters() {
    // Clear all filter inputs
    $('#customerBookingIdFilter').val('');
    $('#customerBookingServiceFilter').val('');
    $('#customerBookingStatusFilter').val('');
    $('#customerBookingPaymentFilter').val('');
    $('#customerBookingDateFrom').val('');
    $('#customerBookingDateTo').val('');
    $('#customerBookingTherapistFilter').val('');

    // Remove any custom search functions
    $.fn.dataTable.ext.search = $.fn.dataTable.ext.search.filter(function(fn) {
        return fn.name !== 'customerBookingFilter';
    });

    // Clear DataTable filters
    const table = window.customerBookingTable || $('#bookingsTable').DataTable();
    if (table && $.fn.DataTable.isDataTable('#bookingsTable')) {
        table.search('').columns().search('').draw();
    }

    if (typeof showBookingNotification === 'function') {
        showBookingNotification('Đã đặt lại tất cả bộ lọc', 'info');
    }

    console.log('Customer booking filters reset');
}

/**
 * Show notification message
 */
function showBookingNotification(message, type = 'info') {
    // Create notification element if it doesn't exist
    let notification = document.getElementById('booking-notification');
    if (!notification) {
        notification = document.createElement('div');
        notification.id = 'booking-notification';
        notification.className = 'fixed top-4 right-4 z-50 max-w-sm';
        document.body.appendChild(notification);
    }

    // Set notification content and style based on type
    const typeClasses = {
        success: 'bg-green-500 text-white',
        error: 'bg-red-500 text-white',
        warning: 'bg-yellow-500 text-white',
        info: 'bg-blue-500 text-white'
    };

    notification.innerHTML = `
        <div class="p-4 rounded-lg shadow-lg ${typeClasses[type] || typeClasses.info} animate-fadeIn">
            <div class="flex items-center">
                <span class="flex-1">${message}</span>
                <button onclick="this.parentElement.parentElement.remove()" class="ml-2 text-white hover:text-gray-200">
                    <i data-lucide="x" class="h-4 w-4"></i>
                </button>
            </div>
        </div>
    `;

    // Initialize Lucide icons
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }

    // Auto-remove after 5 seconds
    setTimeout(() => {
        if (notification && notification.parentElement) {
            notification.remove();
        }
    }, 5000);
}

// Export functions for global access
window.applyCustomerBookingFilters = applyCustomerBookingFilters;
window.resetCustomerBookingFilters = resetCustomerBookingFilters;
window.showBookingNotification = showBookingNotification;

console.log('Customer Booking Filter Script Loaded');
