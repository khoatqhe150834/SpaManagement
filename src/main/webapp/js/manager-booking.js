/**
 * Manager Booking Management JavaScript
 * Handles filter functionality and booking management operations
 */

// Initialize Manager Booking Filters
function initializeManagerBookingFilters() {
    console.log('Manager Booking Filter Script Loaded');
    
    // Filter toggle functionality
    const toggleButton = document.getElementById('toggleManagerBookingFilters');
    const filterPanel = document.getElementById('managerBookingFilterPanel');
    
    if (toggleButton && filterPanel) {
        toggleButton.addEventListener('click', function() {
            const icon = this.querySelector('i');
            
            filterPanel.classList.toggle('show');
            if (icon) {
                icon.classList.toggle('rotate-180');
            }
        });
    }
    
    // Apply filters functionality
    const applyButton = document.getElementById('applyFilters');
    if (applyButton) {
        applyButton.addEventListener('click', function() {
            if (window.managerBookingTable) {
                window.managerBookingTable.draw();
            }
        });
    }
    
    // Reset filters functionality
    const resetButton = document.getElementById('resetFilters');
    if (resetButton) {
        resetButton.addEventListener('click', function() {
            // Clear all filter inputs
            const filterInputs = [
                'startDateFilter',
                'endDateFilter', 
                'customerFilter',
                'bookingIdFilter'
            ];
            
            filterInputs.forEach(function(inputId) {
                const input = document.getElementById(inputId);
                if (input) {
                    input.value = '';
                }
            });
            
            // Clear all select filters
            const selectFilters = [
                'therapistFilter',
                'statusFilterMgr', 
                'serviceTypeFilter'
            ];
            
            selectFilters.forEach(function(selectId) {
                const select = document.getElementById(selectId);
                if (select) {
                    select.value = '';
                }
            });
            
            // Redraw table
            if (window.managerBookingTable) {
                window.managerBookingTable.draw();
            }
        });
    }
    
    // Real-time search for customer and booking ID
    const customerFilter = document.getElementById('customerFilter');
    const bookingIdFilter = document.getElementById('bookingIdFilter');
    
    if (customerFilter) {
        customerFilter.addEventListener('input', debounce(function() {
            if (window.managerBookingTable) {
                window.managerBookingTable.draw();
            }
        }, 500));
    }
    
    if (bookingIdFilter) {
        bookingIdFilter.addEventListener('input', debounce(function() {
            if (window.managerBookingTable) {
                window.managerBookingTable.draw();
            }
        }, 500));
    }
}

// Debounce function for search inputs
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = function() {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Manager Booking Action Functions
function viewManagerBookingDetails(bookingId) {
    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
    window.location.href = contextPath + '/manager/booking-details?id=' + bookingId;
}

function reassignManagerBooking(bookingId) {
    if (confirm('Bạn có chắc chắn muốn phân công lại đặt lịch #BK' + bookingId.toString().padStart(3, '0') + '?')) {
        // Implementation for reassigning therapist
        console.log('Reassigning booking:', bookingId);
        
        // You can implement the reassignment logic here
        // For example, open a modal or redirect to reassignment page
        alert('Chức năng phân công lại đang được phát triển');
    }
}

function editManagerBooking(bookingId) {
    const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
    window.location.href = contextPath + '/manager/booking-edit?id=' + bookingId;
}

// Export booking data
function exportManagerBookingData() {
    if (window.managerBookingTable) {
        // Trigger DataTables Excel export
        window.managerBookingTable.button('.buttons-excel').trigger();
    }
}

// Refresh booking data
function refreshManagerBookingData() {
    if (window.managerBookingTable) {
        window.managerBookingTable.ajax.reload(null, false); // false = keep current page
        console.log('Manager booking data refreshed');
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Initialize filter functionality
    setTimeout(function() {
        initializeManagerBookingFilters();
    }, 100);
});

console.log('Manager Booking Script Loaded Successfully');
