/**
 * Manager Rooms Management Filter Functionality
 * Handles filtering and search functionality for manager rooms management page
 */

// Global variables
let managerRoomsFilterTimeout;

// Initialize when document is ready
$(document).ready(function() {
    initializeManagerRoomsFilters();
});

/**
 * Initialize all filter functionality for manager rooms
 */
window.initializeManagerRoomsFilters = function initializeManagerRoomsFilters() {
    // Toggle filter panel
    const filterPanel = document.getElementById('managerRoomsFilterPanel');
    const toggleFiltersBtn = document.getElementById('toggleManagerRoomsFilters');
    
    if (filterPanel && toggleFiltersBtn) {
        // Use jQuery for better compatibility and to avoid conflicts
        $(toggleFiltersBtn).off('click.managerRoomsFilter').on('click.managerRoomsFilter', function(e) {
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
    setupManagerRoomsFilters();
    
};

/**
 * Setup filter functionality for DataTable integration
 */
function setupManagerRoomsFilters() {
    // Wait for DataTable to be initialized
    $(document).on('init.dt', '#roomsTable', function() {
        const table = $('#roomsTable').DataTable();
        
        // Apply filters button
        $('#applyManagerRoomsFilters').off('click').on('click', function() {
            applyManagerRoomsFilters(true);
        });
        
        // Reset filters button
        $('#resetManagerRoomsFilters').off('click').on('click', function() {
            resetManagerRoomsFilters();
        });
        
        // Real-time filtering on input change
        $('#managerRoomsNameFilter, #managerRoomsStatusFilter').on('change', function() {
            applyManagerRoomsFilters();
        });
        
        $('#managerRoomsMinCapacity, #managerRoomsMaxCapacity').on('input', function() {
            clearTimeout(managerRoomsFilterTimeout);
            managerRoomsFilterTimeout = setTimeout(function() {
                applyManagerRoomsFilters();
            }, 500);
        });
        
        // Date filters
        $('#managerRoomsDateFrom, #managerRoomsDateTo').on('change', function() {
            applyManagerRoomsFilters();
        });
        

    });
}

/**
 * Apply all active filters to the rooms table
 */
function applyManagerRoomsFilters(showNotification = false) {
    if (!$.fn.DataTable.isDataTable('#roomsTable')) {
        return;
    }

    const table = $('#roomsTable').DataTable();

    // Get filter values
    const nameFilter = $('#managerRoomsNameFilter').val();
    const statusFilter = $('#managerRoomsStatusFilter').val();
    const minCapacity = $('#managerRoomsMinCapacity').val();
    const maxCapacity = $('#managerRoomsMaxCapacity').val();
    const dateFrom = $('#managerRoomsDateFrom').val();
    const dateTo = $('#managerRoomsDateTo').val();

    // Clear all existing search functions and column searches
    $.fn.dataTable.ext.search = [];
    table.search('').columns().search('');

    // Add comprehensive custom search function if any filters are active
    if (nameFilter || statusFilter || minCapacity || maxCapacity || dateFrom || dateTo) {
        $.fn.dataTable.ext.search.push(function(settings, data, dataIndex) {
            if (settings.nTable.id !== 'roomsTable') {
                return true;
            }

            // Get the actual row element to access data attributes
            const row = settings.aoData[dataIndex].nTr;
            
            // Room name filter
            if (nameFilter) {
                const nameCell = $(row).find('td:eq(1)').text().trim().toLowerCase();
                if (nameCell.indexOf(nameFilter.toLowerCase()) === -1) {
                    return false;
                }
            }

            // Status filter
            if (statusFilter) {
                const statusCell = $(row).find('td:eq(4)').text().trim();
                if (statusFilter === 'active' && statusCell.indexOf('Hoạt động') === -1) {
                    return false;
                }
                if (statusFilter === 'inactive' && statusCell.indexOf('Bảo trì') === -1) {
                    return false;
                }
            }

            // Capacity range filter
            if (minCapacity || maxCapacity) {
                const capacityCell = $(row).find('td:eq(3)').text().trim();
                const capacity = parseInt(capacityCell) || 0;
                const min = minCapacity ? parseInt(minCapacity) : 0;
                const max = maxCapacity ? parseInt(maxCapacity) : Number.MAX_VALUE;
                
                if (capacity < min || capacity > max) {
                    return false;
                }
            }

            // Date range filter
            if (dateFrom || dateTo) {
                const dateCell = $(row).find('td:eq(5)');
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
    updateManagerRoomsFilterStatus();

    if (showNotification) {
        showManagerRoomsNotification('Đã áp dụng bộ lọc', 'success');
    }
}

/**
 * Reset all filters to default state
 */
function resetManagerRoomsFilters() {
    // Clear all filter inputs
    $('#managerRoomsNameFilter').val('');
    $('#managerRoomsStatusFilter').val('');
    $('#managerRoomsMinCapacity').val('');
    $('#managerRoomsMaxCapacity').val('');
    $('#managerRoomsDateFrom').val('');
    $('#managerRoomsDateTo').val('');

    // Clear all custom search functions
    $.fn.dataTable.ext.search = [];

    // Clear DataTable filters
    if ($.fn.DataTable.isDataTable('#roomsTable')) {
        const table = $('#roomsTable').DataTable();
        table.search('').columns().search('').draw();
    }

    // Update filter button appearance
    updateManagerRoomsFilterStatus();

    showManagerRoomsNotification('Đã đặt lại bộ lọc', 'info');
}

/**
 * Update filter button appearance based on active filters
 */
function updateManagerRoomsFilterStatus() {
    const nameFilter = $('#managerRoomsNameFilter').val();
    const statusFilter = $('#managerRoomsStatusFilter').val();
    const minCapacity = $('#managerRoomsMinCapacity').val();
    const maxCapacity = $('#managerRoomsMaxCapacity').val();
    const dateFrom = $('#managerRoomsDateFrom').val();
    const dateTo = $('#managerRoomsDateTo').val();

    const hasActiveFilters = nameFilter || statusFilter || minCapacity || maxCapacity || dateFrom || dateTo;

    const filterButton = $('#toggleManagerRoomsFilters');
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
function showManagerRoomsNotification(message, type = 'info') {
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
