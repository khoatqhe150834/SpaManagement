/**
 * Manager Payment Details Filter Functionality
 * Handles filtering and search functionality for manager payment details page
 */

// Global variables
let paymentDetailsFilterTimeout;
let paymentDetailsInitialized = false;

// Initialize when document is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Initialize filter panel toggle
    initializeFilterPanel();
    
    // Initialize DataTable if it exists
    initializePaymentItemsTable();
});

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

            // Toggle icon rotation
            const icon = toggleFiltersBtn.querySelector('i');
            if (icon) {
                icon.classList.toggle('rotate-180');
            }
            
            // Update button appearance
            if (filterPanel.classList.contains('show')) {
                toggleFiltersBtn.classList.add('bg-primary', 'text-white');
                toggleFiltersBtn.classList.remove('bg-white', 'text-gray-700');
                if (icon) icon.classList.add('text-white');
            } else {
                toggleFiltersBtn.classList.remove('bg-primary', 'text-white');
                toggleFiltersBtn.classList.add('bg-white', 'text-gray-700');
                if (icon) icon.classList.remove('text-white');
            }
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
    $('#paymentDetailsServiceFilter, #paymentDetailsQuantityFilter, #paymentDetailsDurationFilter').on('change', function() {
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
 * Initialize the filter panel toggle functionality
 */
function initializeFilterPanel() {
    const toggleButton = document.getElementById('togglePaymentDetailsFilters');
    const filterPanel = document.getElementById('paymentDetailsFilterPanel');
    
    if (toggleButton && filterPanel) {
        toggleButton.addEventListener('click', function() {
            filterPanel.classList.toggle('show');
            
            // Toggle icon rotation
            const icon = toggleButton.querySelector('i');
            if (icon) {
                icon.classList.toggle('rotate-180');
            }
            
            // Update button appearance
            if (filterPanel.classList.contains('show')) {
                toggleButton.classList.add('bg-primary', 'text-white');
                toggleButton.classList.remove('bg-white', 'text-gray-700');
                if (icon) icon.classList.add('text-white');
            } else {
                toggleButton.classList.remove('bg-primary', 'text-white');
                toggleButton.classList.add('bg-white', 'text-gray-700');
                if (icon) icon.classList.remove('text-white');
            }
        });
        
        // Setup filter buttons
        const applyButton = document.getElementById('applyPaymentDetailsFilters');
        const resetButton = document.getElementById('resetPaymentDetailsFilters');
        
        if (applyButton) {
            applyButton.addEventListener('click', applyPaymentDetailsFilters);
        }
        
        if (resetButton) {
            resetButton.addEventListener('click', resetPaymentDetailsFilters);
        }
    }
}

/**
 * Apply all active filters to the payment items table
 */
function applyPaymentDetailsFilters(showNotification = false) {
    if (!$.fn.DataTable.isDataTable('#paymentItemsTable')) {
        console.warn('DataTable not initialized, cannot apply filters');
        return;
    }

    const table = $('#paymentItemsTable').DataTable();

    // Get filter values
    const serviceFilter = document.getElementById('paymentDetailsServiceFilter')?.value || '';
    const quantityFilter = document.getElementById('paymentDetailsQuantityFilter')?.value || '';
    const minAmount = document.getElementById('paymentDetailsMinAmount')?.value || '';
    const maxAmount = document.getElementById('paymentDetailsMaxAmount')?.value || '';
    const durationFilter = document.getElementById('paymentDetailsDurationFilter')?.value || '';
    const usageFilter = document.getElementById('paymentDetailsUsageFilter')?.value || '';
    
    // Clear existing custom search functions
    $.fn.dataTable.ext.search = $.fn.dataTable.ext.search.filter(function(fn) {
        return fn.name !== 'paymentDetailsAmountFilter' && 
               fn.name !== 'paymentDetailsDurationFilter' && 
               fn.name !== 'paymentDetailsUsageFilter';
    });
    
    // Apply service name filter
    if (serviceFilter) {
        table.column(0).search(serviceFilter, true, false);
    } else {
        table.column(0).search('');
    }
    
    // Apply quantity filter
    if (quantityFilter) {
        table.column(1).search('^' + quantityFilter + '$', true, false);
    } else {
        table.column(1).search('');
    }
    
    // Apply amount range filter
    if (minAmount || maxAmount) {
        const amountFilter = function(settings, data, dataIndex) {
            const amount = parseFloat(data[4].replace(/[^\d.,]/g, '').replace(/\./g, '').replace(',', '.')) || 0;
            const min = parseFloat(minAmount) || 0;
            const max = parseFloat(maxAmount) || Infinity;
            return amount >= min && amount <= max;
        };
        amountFilter.name = 'paymentDetailsAmountFilter';
        $.fn.dataTable.ext.search.push(amountFilter);
    }
    
    // Apply duration filter
    if (durationFilter) {
        const durationFilterFn = function(settings, data, dataIndex) {
            const durationText = data[3];
            const match = durationText.match(/(\d+)/);
            const duration = match ? parseInt(match[1]) : 0;
            return duration === parseInt(durationFilter);
        };
        durationFilterFn.name = 'paymentDetailsDurationFilter';
        $.fn.dataTable.ext.search.push(durationFilterFn);
    }
    
    // Apply usage status filter
    if (usageFilter) {
        const usageFilterFn = function(settings, data, dataIndex) {
            const usageText = data[5];
            if (usageFilter === 'used') {
                return usageText.includes('đã sử dụng') && !usageText.includes('Còn lại: 0');
            } else if (usageFilter === 'unused') {
                return !usageText.includes('đã sử dụng') || usageText.includes('Còn lại: 0');
            }
            return true;
        };
        usageFilterFn.name = 'paymentDetailsUsageFilter';
        $.fn.dataTable.ext.search.push(usageFilterFn);
    }
    
    // Apply all filters with a single draw
    table.draw();
    
    // Update filter button appearance
    updatePaymentDetailsFilterStatus();

    if (showNotification) {
        showNotification('Đã áp dụng bộ lọc', 'success');
    }
}

/**
 * Reset all filters to default state
 */
function resetPaymentDetailsFilters() {
    // Reset filter inputs
    document.getElementById('paymentDetailsServiceFilter')?.value = '';
    document.getElementById('paymentDetailsQuantityFilter')?.value = '';
    document.getElementById('paymentDetailsMinAmount')?.value = '';
    document.getElementById('paymentDetailsMaxAmount')?.value = '';
    document.getElementById('paymentDetailsDurationFilter')?.value = '';
    document.getElementById('paymentDetailsUsageFilter')?.value = '';
    
    // Clear DataTable filters
    const table = $('#paymentItemsTable').DataTable();
    if (table) {
        // Clear custom search functions
        $.fn.dataTable.ext.search = $.fn.dataTable.ext.search.filter(function(fn) {
            return fn.name !== 'paymentDetailsAmountFilter' && 
                   fn.name !== 'paymentDetailsDurationFilter' && 
                   fn.name !== 'paymentDetailsUsageFilter';
        });
        
        // Clear column searches
        table.columns().search('');
        
        // Redraw table
        table.search('').draw();
    }
    
    // Update filter button appearance
    updatePaymentDetailsFilterStatus();

    showNotification('Đã đặt lại bộ lọc', 'info');
}

/**
 * Update filter button appearance based on active filters
 */
function updatePaymentDetailsFilterStatus() {
    const serviceFilter = document.getElementById('paymentDetailsServiceFilter')?.value || '';
    const quantityFilter = document.getElementById('paymentDetailsQuantityFilter')?.value || '';
    const minAmount = document.getElementById('paymentDetailsMinAmount')?.value || '';
    const maxAmount = document.getElementById('paymentDetailsMaxAmount')?.value || '';
    const durationFilter = document.getElementById('paymentDetailsDurationFilter')?.value || '';
    const usageFilter = document.getElementById('paymentDetailsUsageFilter')?.value || '';

    const hasActiveFilters = serviceFilter || quantityFilter || minAmount || maxAmount || durationFilter || usageFilter;

    const filterButton = document.getElementById('togglePaymentDetailsFilters');
    if (filterButton) {
        if (hasActiveFilters) {
            filterButton.classList.add('bg-primary', 'text-white');
            filterButton.classList.remove('bg-white', 'text-gray-700');
            const icon = filterButton.querySelector('i');
            if (icon) icon.classList.add('text-white');
        } else {
            filterButton.classList.remove('bg-primary', 'text-white');
            filterButton.classList.add('bg-white', 'text-gray-700');
            const icon = filterButton.querySelector('i');
            if (icon) icon.classList.remove('text-white');
        }
    }
}

/**
 * Show notification message
 */
function showNotification(message, type = 'info') {
    // Create notification element
    const notification = document.createElement('div');
    notification.className = `fixed top-4 right-4 z-50 p-4 rounded-lg shadow-lg max-w-sm transition-all duration-300 transform translate-x-full`;
    
    // Set colors based on type
    const colors = {
        success: 'bg-green-500 text-white',
        error: 'bg-red-500 text-white',
        warning: 'bg-yellow-500 text-white',
        info: 'bg-blue-500 text-white'
    };
    
    notification.className += ' ' + (colors[type] || colors.info);
    
    // Determine icon based on type
    let iconName = 'info';
    if (type === 'success') iconName = 'check-circle';
    else if (type === 'error') iconName = 'x-circle';
    else if (type === 'warning') iconName = 'alert-triangle';
    
    notification.innerHTML = 
        '<div class="flex items-center gap-2">' +
            '<i data-lucide="' + iconName + '" class="h-5 w-5"></i>' +
            '<span>' + message + '</span>' +
        '</div>';
    
    document.body.appendChild(notification);
    
    // Initialize icon
    if (typeof lucide !== 'undefined') {
        lucide.createIcons({
            icons: {
                [iconName]: notification.querySelector(`[data-lucide="${iconName}"]`)
            }
        });
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

/**
 * Populate service filter dropdown with unique service names
 */
function populateServiceFilter() {
    const table = $('#paymentItemsTable').DataTable();
    const serviceFilter = document.getElementById('paymentDetailsServiceFilter');
    
    if (table && serviceFilter) {
        // Get all service names from the first column
        const serviceNames = new Set();
        
        table.column(0).data().each(function(value) {
            // Extract service name from HTML content
            const div = document.createElement('div');
            div.innerHTML = value;
            const serviceName = div.querySelector('.service-name')?.textContent.trim();
            
            if (serviceName && serviceName !== 'Dịch vụ không xác định') {
                serviceNames.add(serviceName);
            }
        });
        
        // Clear existing options except the first one
        while (serviceFilter.options.length > 1) {
            serviceFilter.remove(1);
        }
        
        // Add service names as options
        serviceNames.forEach(function(name) {
            const option = document.createElement('option');
            option.value = name;
            option.textContent = name;
            serviceFilter.appendChild(option);
        });
    }
}

/**
 * Initialize progress bars for usage visualization
 */
function initializeProgressBars() {
    document.querySelectorAll('.usage-progress-bar').forEach(function(bar) {
        const booked = parseInt(bar.getAttribute('data-booked')) || 0;
        const total = parseInt(bar.getAttribute('data-total')) || 1;
        const percentage = total > 0 ? (booked / total) * 100 : 0;

        // Animate progress bar
        setTimeout(function() {
            bar.style.width = percentage + '%';
        }, 100);
    });
}

/**
 * Setup pagination preservation during filtering and sorting
 */
function setupPaginationPreservation(table) {
    // Store the current page and page length when the page loads
    var currentPage = table.page.info().page;
    var currentPageLength = table.page.len();
    
    // Create a variable to store the page before sorting
    var pageBeforeSorting = currentPage;
    
    // Handle pre-draw to capture the current page before any operation
    table.on('preDraw', function() {
        // Only store the page if we're not already in a sorting operation
        if (!$(table.table().node()).data('sortingInProgress')) {
            pageBeforeSorting = table.page.info().page;
            currentPageLength = table.page.len();
        }
        return true; // Allow the draw to proceed
    });
    
    // Handle column header clicks (sorting)
    $('#paymentItemsTable thead').on('click', 'th', function() {
        // Set a flag to indicate sorting is happening
        $(table.table().node()).data('sortingInProgress', true);
    });
    
    // Handle order event (when sorting actually happens)
    table.on('order.dt', function() {
        // Flag that sorting is in progress
        $(table.table().node()).data('sortingInProgress', true);
    });
    
    // Handle post-draw to restore the page after sorting
    table.on('draw.dt', function() {
        // Check if this draw was triggered by a sort operation
        if ($(table.table().node()).data('sortingInProgress')) {
            // Get the current table info after sorting
            var info = table.page.info();
            
            // Calculate the maximum valid page number
            var maxPage = Math.max(0, Math.ceil(info.recordsDisplay / info.length) - 1);
            
            // Determine which page to go to
            var targetPage = Math.min(pageBeforeSorting, maxPage);
            
            // Only change page if we're not already on the target page
            if (info.page !== targetPage) {
                // Go to the target page without redrawing
                table.page(targetPage).draw(false);
            }
            
            // Reset the sorting flag
            $(table.table().node()).data('sortingInProgress', false);
        }
        
        // Reinitialize progress bars after draw
        setTimeout(initializeProgressBars, 50);
    });
}

/**
 * Initialize the payment items DataTable with custom filtering
 */
function initializePaymentItemsTable() {
    const table = document.getElementById('paymentItemsTable');
    if (!table || typeof $.fn.DataTable !== 'function') return;
    
    // Initialize DataTable if not already initialized
    if (!$.fn.DataTable.isDataTable('#paymentItemsTable')) {
        const dataTable = $('#paymentItemsTable').DataTable({
            responsive: true,
            dom: 'Blfrtip',
            processing: true,
            stateSave: true,
            stateDuration: 300, // 5 minutes state persistence
            pageResize: true,
            columnDefs: [
                // Service name column (index 0)
                {
                    targets: 0,
                    type: 'string'
                },
                // Quantity column (index 1) - numeric sorting
                {
                    targets: 1,
                    type: 'num'
                },
                // Unit price column (index 2) - numeric sorting
                {
                    targets: 2,
                    type: 'num',
                    render: function(data, type, row) {
                        if (type === 'sort' || type === 'type') {
                            // Extract numeric value from formatted currency
                            return parseFloat(data.replace(/[^\d.,]/g, '').replace(/\./g, '').replace(',', '.')) || 0;
                        }
                        return data;
                    }
                },
                // Duration column (index 3) - numeric sorting
                {
                    targets: 3,
                    type: 'num',
                    render: function(data, type, row) {
                        if (type === 'sort' || type === 'type') {
                            // Extract numeric value from "X phút" format
                            var match = data.match(/(\d+)/);
                            return match ? parseInt(match[1]) : 0;
                        }
                        return data;
                    }
                },
                // Total price column (index 4) - numeric sorting
                {
                    targets: 4,
                    type: 'num',
                    render: function(data, type, row) {
                        if (type === 'sort' || type === 'type') {
                            // Extract numeric value from formatted currency
                            return parseFloat(data.replace(/[^\d.,]/g, '').replace(/\./g, '').replace(',', '.')) || 0;
                        }
                        return data;
                    }
                }
            ],
            language: {
                "sProcessing": "Đang xử lý...",
                "sLengthMenu": "Hiển thị _MENU_ mục",
                "sZeroRecords": "Không tìm thấy dòng nào phù hợp",
                "sInfo": "Đang hiển thị _START_ đến _END_ trong tổng số _TOTAL_ mục",
                "sInfoEmpty": "Đang hiển thị 0 đến 0 trong tổng số 0 mục",
                "sInfoFiltered": "(được lọc từ _MAX_ mục)",
                "sSearch": "Tìm kiếm:",
                "oPaginate": {
                    "sFirst": "Đầu",
                    "sPrevious": "Trước",
                    "sNext": "Tiếp",
                    "sLast": "Cuối"
                }
            },
            buttons: [
                {
                    extend: 'excel',
                    text: '<i data-lucide="file-spreadsheet" class="h-4 w-4 mr-1"></i> Xuất Excel',
                    className: 'bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors inline-flex items-center',
                    exportOptions: {
                        columns: ':visible'
                    }
                },
                {
                    extend: 'print',
                    text: '<i data-lucide="printer" class="h-4 w-4 mr-1"></i> In',
                    className: 'bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors inline-flex items-center',
                    exportOptions: {
                        columns: ':visible'
                    }
                }
            ],
            dom: '<"flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-4"<"flex items-center"l><"flex items-center"Bf>>rtip',
            initComplete: function() {
                // Apply custom styling after DataTables initialization
                $('.dataTables_filter input').addClass('ml-2 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary');
                $('.dataTables_length select').addClass('mx-2 px-2 py-1 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary');
                $('.dataTables_paginate .paginate_button').addClass('mx-1');

                // Style the wrapper
                $('.dataTables_wrapper').addClass('px-6 pb-6');

                // Initialize progress bars after DataTables is ready
                setTimeout(initializeProgressBars, 100);

                // Reinitialize Lucide icons for DataTables buttons
                setTimeout(function() {
                    if (typeof lucide !== 'undefined') {
                        lucide.createIcons();
                    }
                }, 200);

                // Populate service filter dropdown with unique service names
                populateServiceFilter();
                
                // Initialize filter functionality
                initializePaymentDetailsFilters();
            }
        });

        // Handle pagination preservation during filtering and sorting
        setupPaginationPreservation(dataTable);
    }
}
