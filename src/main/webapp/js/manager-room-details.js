/**
 * Manager Room Details Filter Functionality
 * Handles filtering and search functionality for manager room details page (beds table)
 */

// Global variables
let managerRoomDetailsFilterTimeout;

// Initialize when document is ready
$(document).ready(function() {
    initializeManagerRoomDetailsFilters();
});

/**
 * Initialize all filter functionality for manager room details
 */
window.initializeManagerRoomDetailsFilters = function initializeManagerRoomDetailsFilters() {
    // Toggle filter panel
    const filterPanel = document.getElementById('managerRoomDetailsFilterPanel');
    const toggleFiltersBtn = document.getElementById('toggleManagerRoomDetailsFilters');
    
    if (filterPanel && toggleFiltersBtn) {
        // Use jQuery for better compatibility and to avoid conflicts
        $(toggleFiltersBtn).off('click.managerRoomDetailsFilter').on('click.managerRoomDetailsFilter', function(e) {
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
    
    // Setup filters when DataTable is ready
    setupManagerRoomDetailsFilters();
    
};

/**
 * Setup filter functionality for DataTable integration
 */
function setupManagerRoomDetailsFilters() {
    // Wait for DataTable to be initialized
    $(document).on('init.dt', '#bedsTable', function() {
        const table = $('#bedsTable').DataTable();
        
        // Apply filters button
        $('#applyManagerRoomDetailsFilters').off('click').on('click', function() {
            applyManagerRoomDetailsFilters(true);
        });
        
        // Reset filters button
        $('#resetManagerRoomDetailsFilters').off('click').on('click', function() {
            resetManagerRoomDetailsFilters();
        });
        
        // Real-time filtering on input change
        $('#managerRoomDetailsBedNameFilter, #managerRoomDetailsStatusFilter').on('change', function() {
            applyManagerRoomDetailsFilters();
        });
        
        $('#managerRoomDetailsBedIdFilter').on('input', function() {
            clearTimeout(managerRoomDetailsFilterTimeout);
            managerRoomDetailsFilterTimeout = setTimeout(function() {
                applyManagerRoomDetailsFilters();
            }, 500);
        });
        
        // Date filters
        $('#managerRoomDetailsDateFrom, #managerRoomDetailsDateTo').on('change', function() {
            applyManagerRoomDetailsFilters();
        });
        

    });
}

/**
 * Apply all active filters to the beds table
 */
function applyManagerRoomDetailsFilters(showNotification = false) {
    if (!$.fn.DataTable.isDataTable('#bedsTable')) {
        return;
    }

    const table = $('#bedsTable').DataTable();

    // Get filter values
    const bedIdFilter = $('#managerRoomDetailsBedIdFilter').val();
    const bedNameFilter = $('#managerRoomDetailsBedNameFilter').val();
    const statusFilter = $('#managerRoomDetailsStatusFilter').val();
    const dateFrom = $('#managerRoomDetailsDateFrom').val();
    const dateTo = $('#managerRoomDetailsDateTo').val();

    // Clear all existing search functions and column searches
    $.fn.dataTable.ext.search = [];
    table.search('').columns().search('');

    // Add comprehensive custom search function if any filters are active
    if (bedIdFilter || bedNameFilter || statusFilter || dateFrom || dateTo) {
        $.fn.dataTable.ext.search.push(function(settings, data, dataIndex) {
            if (settings.nTable.id !== 'bedsTable') {
                return true;
            }

            // Get the actual row element to access data attributes
            const row = settings.aoData[dataIndex].nTr;
            
            // Bed ID filter
            if (bedIdFilter) {
                const bedIdCell = $(row).find('td:eq(0)').text().trim().toLowerCase();
                if (bedIdCell.indexOf(bedIdFilter.toLowerCase()) === -1) {
                    return false;
                }
            }
            
            // Bed name filter
            if (bedNameFilter) {
                const bedNameCell = $(row).find('td:eq(1)').text().trim().toLowerCase();
                if (bedNameCell.indexOf(bedNameFilter.toLowerCase()) === -1) {
                    return false;
                }
            }

            // Status filter
            if (statusFilter) {
                const statusCell = $(row).find('td:eq(3)').text().trim();
                if (statusFilter === 'active' && statusCell.indexOf('Hoạt động') === -1) {
                    return false;
                }
                if (statusFilter === 'inactive' && statusCell.indexOf('Bảo trì') === -1) {
                    return false;
                }
            }

            // Date range filter
            if (dateFrom || dateTo) {
                const dateCell = $(row).find('td:eq(4)');
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
    updateManagerRoomDetailsFilterStatus();

    if (showNotification) {
        showManagerRoomDetailsNotification('Đã áp dụng bộ lọc', 'success');
    }
}

/**
 * Reset all filters to default state
 */
function resetManagerRoomDetailsFilters() {
    // Clear all filter inputs
    $('#managerRoomDetailsBedIdFilter').val('');
    $('#managerRoomDetailsBedNameFilter').val('');
    $('#managerRoomDetailsStatusFilter').val('');
    $('#managerRoomDetailsDateFrom').val('');
    $('#managerRoomDetailsDateTo').val('');

    // Clear all custom search functions
    $.fn.dataTable.ext.search = [];

    // Clear DataTable filters
    if ($.fn.DataTable.isDataTable('#bedsTable')) {
        const table = $('#bedsTable').DataTable();
        table.search('').columns().search('').draw();
    }

    // Update filter button appearance
    updateManagerRoomDetailsFilterStatus();

    showManagerRoomDetailsNotification('Đã đặt lại bộ lọc', 'info');
}

/**
 * Update filter button appearance based on active filters
 */
function updateManagerRoomDetailsFilterStatus() {
    const bedIdFilter = $('#managerRoomDetailsBedIdFilter').val();
    const bedNameFilter = $('#managerRoomDetailsBedNameFilter').val();
    const statusFilter = $('#managerRoomDetailsStatusFilter').val();
    const dateFrom = $('#managerRoomDetailsDateFrom').val();
    const dateTo = $('#managerRoomDetailsDateTo').val();

    const hasActiveFilters = bedIdFilter || bedNameFilter || statusFilter || dateFrom || dateTo;

    const filterButton = $('#toggleManagerRoomDetailsFilters');
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
function showManagerRoomDetailsNotification(message, type = 'info') {
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
