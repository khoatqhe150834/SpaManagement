/**
 * Customer Payment History Filter Functionality
 * Handles filtering and search functionality for customer payment history page
 */

// Global variables
let filterTimeout;

// Initialize when document is ready
$(document).ready(function() {
    initializePaymentHistoryFilters();
});

/**
 * Initialize all filter functionality
 */
function initializePaymentHistoryFilters() {
    // Toggle filter panel
    $('#toggleFilters').on('click', function() {
        const panel = $('#filterPanel');
        const button = $(this);
        
        panel.toggleClass('hidden');
        
        if (panel.hasClass('hidden')) {
            button.find('i').removeClass('rotate-180');
        } else {
            button.find('i').addClass('rotate-180');
        }
    });
    
    // Apply filters
    $('#applyFilters').on('click', function() {
        applyPaymentFilters(true);
    });
    
    // Reset filters
    $('#resetFilters').on('click', function() {
        resetPaymentFilters();
    });
    
    // Real-time filtering on input change
    $('#methodFilter, #statusFilter').on('change', function() {
        applyPaymentFilters();
    });
    
    $('#minAmount, #maxAmount').on('input', function() {
        clearTimeout(filterTimeout);
        filterTimeout = setTimeout(function() {
            applyPaymentFilters();
        }, 500);
    });
    
    console.log('Payment history filters initialized');
}

/**
 * Apply all active filters to the payment table
 */
function applyPaymentFilters(showNotification = false) {
    if (!$.fn.DataTable.isDataTable('#paymentsTable')) {
        return;
    }

    const table = $('#paymentsTable').DataTable();

    // Get filter values
    const methodFilter = $('#methodFilter').val();
    const statusFilter = $('#statusFilter').val();
    const minAmount = $('#minAmount').val();
    const maxAmount = $('#maxAmount').val();
    const dateRange = $('#dateRangePicker').val();

    // Clear all existing search functions and column searches
    $.fn.dataTable.ext.search = [];
    table.search('').columns().search('');

    // Add comprehensive custom search function if any filters are active
    if (methodFilter || statusFilter || minAmount || maxAmount || dateRange) {
        $.fn.dataTable.ext.search.push(function(settings, data, dataIndex) {
            if (settings.nTable.id !== 'paymentsTable') {
                return true;
            }

            // Get the actual row element to access data attributes
            const row = settings.aoData[dataIndex].nTr;
            
            // Method filter
            if (methodFilter) {
                let methodText = getMethodDisplayText(methodFilter);
                const methodCell = $(row).find('td:eq(2)').text().trim();
                if (methodCell !== methodText) {
                    return false;
                }
            }

            // Status filter
            if (statusFilter) {
                let statusText = getStatusDisplayText(statusFilter);
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
            if (dateRange) {
                const dates = dateRange.split(' - ');
                if (dates.length === 2) {
                    const startDate = new Date(dates[0]);
                    const endDate = new Date(dates[1]);
                    endDate.setHours(23, 59, 59, 999);

                    const dateCell = $(row).find('td:eq(1)');
                    const dateString = dateCell.attr('data-order');
                    const rowDate = dateString ? new Date(dateString) : new Date();

                    if (rowDate < startDate || rowDate > endDate) {
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
    updatePaymentFilterStatus();

    if (showNotification) {
        showPaymentNotification('Đã áp dụng bộ lọc', 'success');
    }
}

/**
 * Reset all filters to default state
 */
function resetPaymentFilters() {
    // Clear all filter inputs
    $('#methodFilter').val('');
    $('#statusFilter').val('');
    $('#minAmount').val('');
    $('#maxAmount').val('');
    $('#dateRangePicker').val('');

    // Clear all custom search functions
    $.fn.dataTable.ext.search = [];

    // Clear DataTable filters
    if ($.fn.DataTable.isDataTable('#paymentsTable')) {
        const table = $('#paymentsTable').DataTable();
        table.search('').columns().search('').draw();
    }

    // Update filter button appearance
    updatePaymentFilterStatus();

    showPaymentNotification('Đã đặt lại bộ lọc', 'info');
}

/**
 * Update filter button appearance based on active filters
 */
function updatePaymentFilterStatus() {
    const methodFilter = $('#methodFilter').val();
    const statusFilter = $('#statusFilter').val();
    const minAmount = $('#minAmount').val();
    const maxAmount = $('#maxAmount').val();
    const dateRange = $('#dateRangePicker').val();

    const hasActiveFilters = methodFilter || statusFilter || minAmount || maxAmount || dateRange;

    const filterButton = $('#toggleFilters');
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
function getMethodDisplayText(methodEnum) {
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
function getStatusDisplayText(statusEnum) {
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
function showPaymentNotification(message, type = 'info') {
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
