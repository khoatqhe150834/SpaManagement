/**
 * Therapist Booking Filter Functionality
 * Handles filtering and search functionality for therapist booking page
 */

// Global variables
let therapistBookingFilterTimeout;
let therapistBookingInitialized = false;

/**
 * Initialize all filter functionality for therapist booking
 */
window.initializeTherapistBookingFilters = function initializeTherapistBookingFilters() {
    // Prevent multiple initializations
    if (therapistBookingInitialized) {
        console.log('Therapist booking filters already initialized, skipping...');
        return;
    }
    therapistBookingInitialized = true;
    
    // Set today's date as default in the filter input (but don't apply it automatically)
    const today = new Date().toISOString().split('T')[0];
    $('#therapistBookingDateFilter').val('');
    
    // Toggle filter panel
    const filterPanel = document.getElementById('therapistBookingFilterPanel');
    const toggleFiltersBtn = document.getElementById('toggleTherapistBookingFilters');

    if (filterPanel && toggleFiltersBtn) {
        // Use jQuery for better compatibility and to avoid conflicts
        $(toggleFiltersBtn).off('click.therapistBookingFilter').on('click.therapistBookingFilter', function(e) {
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
    $('#applyTherapistBookingFilters').on('click', function() {
        applyTherapistBookingFilters(true);
    });

    // Reset filters
    $('#resetTherapistBookingFilters').on('click', function() {
        resetTherapistBookingFilters();
    });

    // Today button
    $('#todayTherapistBookingFilter').on('click', function() {
        const today = new Date().toISOString().split('T')[0];
        $('#therapistBookingDateFilter').val(today);
        applyTherapistBookingFilters(true);
    });

    // Real-time filtering on input change
    $('#therapistBookingStatusFilter').on('change', function() {
        applyTherapistBookingFilters();
    });

    $('#therapistBookingCustomerFilter, #therapistBookingServiceFilter, #therapistBookingRoomFilter').on('input', function() {
        clearTimeout(therapistBookingFilterTimeout);
        therapistBookingFilterTimeout = setTimeout(function() {
            applyTherapistBookingFilters();
        }, 500);
    });

    // Date and time filters
    $('#therapistBookingDateFilter, #therapistBookingTimeFrom, #therapistBookingTimeTo').on('change', function() {
        applyTherapistBookingFilters();
    });

    // Setup filters when DataTable is ready
    setupTherapistBookingFilters();
};

/**
 * Setup filter functionality for DataTable integration
 */
function setupTherapistBookingFilters() {
    // Remove any existing event handlers to prevent duplicates
    $(document).off('init.dt', '#therapistBookingsTable');

    // Wait for DataTable to be initialized
    $(document).one('init.dt', '#therapistBookingsTable', function() {
        console.log('Therapist booking DataTable filters initialized');
    });
}

/**
 * Apply all active filters to the DataTable
 */
function applyTherapistBookingFilters(showNotification = false) {
    // Use global table reference if available
    const table = window.therapistBookingTable || $('#therapistBookingsTable').DataTable();
    
    if (!table || !$.fn.DataTable.isDataTable('#therapistBookingsTable')) {
        console.warn('DataTable not initialized yet');
        return;
    }
    
    // Get filter values
    const filters = {
        date: $('#therapistBookingDateFilter').val(),
        customer: $('#therapistBookingCustomerFilter').val().trim(),
        service: $('#therapistBookingServiceFilter').val().trim(),
        status: $('#therapistBookingStatusFilter').val(),
        timeFrom: $('#therapistBookingTimeFrom').val(),
        timeTo: $('#therapistBookingTimeTo').val(),
        room: $('#therapistBookingRoomFilter').val().trim()
    };

    console.log('Therapist booking filter values:', filters);

    // Remove any existing custom search functions
    $.fn.dataTable.ext.search = $.fn.dataTable.ext.search.filter(function(fn) {
        return fn.name !== 'therapistBookingFilter';
    });

    // Add custom search function if any filters are active
    const hasActiveFilters = Object.values(filters).some(v => v && v.trim());
    
    if (hasActiveFilters) {
        $.fn.dataTable.ext.search.push(function therapistBookingFilter(settings, data, dataIndex) {
            if (settings.nTable.id !== 'therapistBookingsTable') {
                return true;
            }

            // Get the raw data from the table
            const rowData = table.row(dataIndex).data();
            if (!rowData) return true;

            // Check date filter
            if (filters.date) {
                const appointmentDate = new Date(rowData.appointmentDate);
                const filterDate = new Date(filters.date);
                if (appointmentDate.toDateString() !== filterDate.toDateString()) {
                    return false;
                }
            }

            // Check customer filter (column 1)
            if (filters.customer && !data[1].toLowerCase().includes(filters.customer.toLowerCase())) {
                return false;
            }

            // Check service filter (column 2)
            if (filters.service && !data[2].toLowerCase().includes(filters.service.toLowerCase())) {
                return false;
            }

            // Check room filter (column 4)
            if (filters.room && !data[4].toLowerCase().includes(filters.room.toLowerCase())) {
                return false;
            }

            // Check status filter (column 5) - match exact status value
            if (filters.status && rowData.bookingStatus !== filters.status) {
                return false;
            }

            // Check time range filter
            if (filters.timeFrom || filters.timeTo) {
                const appointmentTime = rowData.appointmentTime;
                if (appointmentTime) {
                    if (filters.timeFrom && appointmentTime < filters.timeFrom) {
                        return false;
                    }
                    if (filters.timeTo && appointmentTime > filters.timeTo) {
                        return false;
                    }
                }
            }

            return true;
        });
    }

    // If date filter is set, reload data with new date parameter
    if (filters.date) {
        table.ajax.reload();
    } else {
        // Just redraw with current filters
        table.draw();
    }

    if (showNotification && typeof showTherapistBookingNotification === 'function') {
        const activeFilters = Object.values(filters).filter(v => v && v.trim()).length;
        if (activeFilters > 0) {
            showTherapistBookingNotification(`Đã áp dụng ${activeFilters} bộ lọc`, 'info');
        }
    }

    console.log('Therapist booking filters applied:', filters);
}

/**
 * Reset all filters to their default state
 */
function resetTherapistBookingFilters() {
    // Set today's date as default
    const today = new Date().toISOString().split('T')[0];
    
    // Clear all filter inputs
    $('#therapistBookingDateFilter').val(today);
    $('#therapistBookingCustomerFilter').val('');
    $('#therapistBookingServiceFilter').val('');
    $('#therapistBookingStatusFilter').val('');
    $('#therapistBookingTimeFrom').val('');
    $('#therapistBookingTimeTo').val('');
    $('#therapistBookingRoomFilter').val('');

    // Remove any custom search functions
    $.fn.dataTable.ext.search = $.fn.dataTable.ext.search.filter(function(fn) {
        return fn.name !== 'therapistBookingFilter';
    });

    // Clear DataTable filters and reload with today's date
    const table = window.therapistBookingTable || $('#therapistBookingsTable').DataTable();
    if (table && $.fn.DataTable.isDataTable('#therapistBookingsTable')) {
        table.search('').columns().search('').ajax.reload();
    }

    if (typeof showTherapistBookingNotification === 'function') {
        showTherapistBookingNotification('Đã đặt lại tất cả bộ lọc và hiển thị lịch hôm nay', 'info');
    }

    console.log('Therapist booking filters reset');
}

/**
 * Show notification message
 */
function showTherapistBookingNotification(message, type = 'info') {
    // Create notification element if it doesn't exist
    let notification = document.getElementById('therapist-booking-notification');
    if (!notification) {
        notification = document.createElement('div');
        notification.id = 'therapist-booking-notification';
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
window.applyTherapistBookingFilters = applyTherapistBookingFilters;
window.resetTherapistBookingFilters = resetTherapistBookingFilters;
window.showTherapistBookingNotification = showTherapistBookingNotification;

console.log('Therapist Booking Filter Script Loaded');
