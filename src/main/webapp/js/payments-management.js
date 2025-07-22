/**
 * Payments Management JavaScript
 * Handles DataTables initialization, filtering, and CRUD operations for payments
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize Lucide icons
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }

    // Toggle dropdowns
    document.querySelectorAll('.dropdown-toggle').forEach(function(item) {
        item.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            const dropdown = item.closest('.dropdown');
            const menu = dropdown.querySelector('.dropdown-menu');
            
            // Close other dropdowns
            document.querySelectorAll('.dropdown-menu').forEach(function(otherMenu) {
                if (otherMenu !== menu) {
                    otherMenu.classList.add('hidden');
                }
            });
            
            // Toggle current dropdown
            menu.classList.toggle('hidden');
        });
    });
    
    // Close dropdowns when clicking outside
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.dropdown')) {
            document.querySelectorAll('.dropdown-menu').forEach(function(menu) {
                menu.classList.add('hidden');
            });
        }
    });
    
    // Toggle filter panel
    const filterPanel = document.getElementById('filterPanel');
    const toggleFiltersBtn = document.getElementById('toggleFilters');
    
    if (filterPanel && toggleFiltersBtn) {
        toggleFiltersBtn.addEventListener('click', function() {
            filterPanel.classList.toggle('show');
        });
    }
    
    // Initialize Date Range Picker
    initializeDateRangePicker();
    
    // Initialize DataTables
    initializeDataTable();
    
    // Setup modal functionality
    setupModalHandlers();
    
    // Initialize Charts if data is available
    initializeCharts();
});

// Initialize DataTables
function initializeDataTable() {
    if ($.fn.DataTable && document.getElementById('paymentsTable') && !$.fn.DataTable.isDataTable('#paymentsTable')) {
        const paymentsTable = $('#paymentsTable').DataTable({
            responsive: true,
            dom: 'Blfrtip',
            processing: true,
            stateSave: true,
            stateDuration: 300, // 5 minutes state persistence
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
            order: [[2, 'desc']], // Sort by payment date (column 2) in descending order
            columnDefs: [
                { responsivePriority: 1, targets: [0, 1, 2, 4, 5, 7] },
                { responsivePriority: 2, targets: [3] },
                { responsivePriority: 3, targets: [6] },
                {
                    targets: 0, // Payment ID column
                    type: 'num',
                    render: function(data, type, row) {
                        if (type === 'sort' || type === 'type') {
                            // Extract numeric value from "#123" format
                            var numericValue = data.replace(/[^\d]/g, '');
                            return parseInt(numericValue) || 0;
                        }
                        return data;
                    }
                },
                {
                    targets: 7, // Actions column
                    orderable: false,
                    searchable: false
                }
            ],
            pageLength: 10,
            lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "Tất cả"]],
            buttons: [
                {
                    extend: 'excelHtml5',
                    text: '<i data-lucide="file-spreadsheet" class="h-4 w-4 mr-1"></i> Xuất Excel',
                    className: 'bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded',
                    exportOptions: { columns: ':not(:last-child)' },
                    title: 'Báo cáo thanh toán - Spa Hương Sen'
                },
                {
                    extend: 'print',
                    text: '<i data-lucide="printer" class="h-4 w-4 mr-1"></i> In báo cáo',
                    className: 'bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded ml-2',
                    exportOptions: { columns: ':not(:last-child)' },
                    title: 'Báo cáo thanh toán - Spa Hương Sen'
                }
            ],
            dom: '<"flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-4"<"flex items-center"l><"flex items-center"Bf>>rtip',
            initComplete: function() {
                // Apply custom styling after DataTables initialization
                $('.dataTables_filter input').addClass('ml-2 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary');
                $('.dataTables_length select').addClass('mx-2 px-2 py-1 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary');
                $('.dataTables_paginate .paginate_button').addClass('mx-1');
                $('.dataTables_wrapper').addClass('px-0 pb-0');
                
                // Initialize Lucide icons in the table
                lucide.createIcons();
                
                // Setup filter functionality
                setupFilters(this.api());
            }
        });
    }
}

// Setup filter functionality
function setupFilters(table) {
    // Apply filters button
    $('#applyFilters').on('click', function() {
        applyFilters(table, true);
    });
    
    // Reset filters button
    $('#resetFilters').on('click', function() {
        resetFilters(table);
    });
    
    // Setup real-time filtering
    setupRealTimeFilters(table);
}

// Setup real-time filtering for all filter inputs
function setupRealTimeFilters(table) {
    let filterTimeout;
    
    // Debounced filter function
    function debouncedFilter() {
        clearTimeout(filterTimeout);
        filterTimeout = setTimeout(function() {
            applyFilters(table);
            updateFilterStatus();
        }, 300);
    }
    
    // Bind events to filter inputs for real-time filtering
    $('#customerFilter').on('change', debouncedFilter);
    $('#methodFilter').on('change', debouncedFilter);
    $('#statusFilter').on('change', debouncedFilter);
    $('#minAmount').on('input', debouncedFilter);
    $('#maxAmount').on('input', debouncedFilter);
}

// Initialize Date Range Picker
function initializeDateRangePicker() {
    if ($.fn.daterangepicker && document.getElementById('dateRangePicker')) {
        $('#dateRangePicker').daterangepicker({
            opens: 'left',
            autoUpdateInput: false,
            locale: {
                format: 'DD/MM/YYYY',
                applyLabel: 'Áp dụng',
                cancelLabel: 'Hủy',
                fromLabel: 'Từ',
                toLabel: 'Đến',
                customRangeLabel: 'Tùy chỉnh',
                daysOfWeek: ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'],
                monthNames: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'],
                firstDay: 1
            },
            ranges: {
                'Hôm nay': [moment(), moment()],
                'Hôm qua': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                '7 ngày qua': [moment().subtract(6, 'days'), moment()],
                '30 ngày qua': [moment().subtract(29, 'days'), moment()],
                'Tháng này': [moment().startOf('month'), moment().endOf('month')],
                'Tháng trước': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
            }
        });
        
        $('#dateRangePicker').on('apply.daterangepicker', function(ev, picker) {
            $(this).val(picker.startDate.format('DD/MM/YYYY') + ' - ' + picker.endDate.format('DD/MM/YYYY'));
            // Apply date filter to table
            applyDateFilter($('#paymentsTable').DataTable(), picker.startDate, picker.endDate);
        });

        $('#dateRangePicker').on('cancel.daterangepicker', function(ev, picker) {
            $(this).val('');
            // Clear date filter
            clearDateFilter($('#paymentsTable').DataTable());
        });
    }
}

// Apply all filters to the DataTable
function applyFilters(table, showNotification = false) {
    // Get filter values
    const customerFilter = $('#customerFilter').val();
    const methodFilter = $('#methodFilter').val();
    const statusFilter = $('#statusFilter').val();
    const minAmount = $('#minAmount').val();
    const maxAmount = $('#maxAmount').val();

    // Clear existing custom search functions
    $.fn.dataTable.ext.search = $.fn.dataTable.ext.search.filter(function(fn) {
        return fn.name !== 'amountRangeFilter' && fn.name !== 'dateRangeFilter';
    });

    // Reset all column-specific searches
    table.columns().search('');

    // Apply customer filter - search in customer name column (index 1)
    if (customerFilter) {
        table.column(1).search(customerFilter);
    }

    // Apply payment method filter - search in method column (index 3)
    if (methodFilter) {
        // Map internal values to display values
        const methodMap = {
            'BANK_TRANSFER': 'Chuyển khoản',
            'CREDIT_CARD': 'Thẻ tín dụng',
            'VNPAY': 'VNPay',
            'MOMO': 'MoMo',
            'ZALOPAY': 'ZaloPay',
            'CASH': 'Tiền mặt'
        };
        
        table.column(3).search(methodMap[methodFilter] || methodFilter);
    }

    // Apply status filter - search in status column (index 5)
    if (statusFilter) {
        // Map internal values to display values
        const statusMap = {
            'PAID': 'Đã thanh toán',
            'PENDING': 'Chờ xử lý',
            'FAILED': 'Thất bại',
            'REFUNDED': 'Đã hoàn tiền'
        };
        
        table.column(5).search(statusMap[statusFilter] || statusFilter);
    }

    // Apply amount filter using custom search function
    if (minAmount || maxAmount) {
        const min = parseFloat(minAmount) || 0;
        const max = parseFloat(maxAmount) || Infinity;
        
        // Create a custom search function for amount filtering
        const amountRangeFilter = function(settings, data, dataIndex) {
            // Get the amount value from the hidden span in the amount column (index 4)
            const amountText = $(table.cell(dataIndex, 4).node()).find('span.hidden').text();
            const amount = parseFloat(amountText.replace(/[^\d.,]/g, '').replace(',', '')) || 0;
            
            // Check if amount is within range
            return (amount >= min && amount <= max);
        };
        
        // Name the function for later removal
        amountRangeFilter.name = 'amountRangeFilter';
        
        // Add the custom search function
        $.fn.dataTable.ext.search.push(amountRangeFilter);
    }

    // Apply all filters with a single draw
    table.draw();

    // Update filter status indicator
    updateFilterStatus();

    // Show success notification only when manually triggered
    if (showNotification) {
        showNotification('Đã áp dụng bộ lọc thành công', 'success');
    }
}

// Reset all filters and return the table to its default state
function resetFilters(table) {
    // Reset all filter inputs
    $('#customerFilter').val('');
    $('#methodFilter').val('');
    $('#statusFilter').val('');
    $('#minAmount').val('');
    $('#maxAmount').val('');
    $('#dateRangePicker').val('');
    
    // Reset DataTable filters
    table.search('').columns().search('').draw();

    // Clear custom search functions
    $.fn.dataTable.ext.search = $.fn.dataTable.ext.search.filter(function(fn) {
        return fn.name !== 'amountRangeFilter' && fn.name !== 'dateRangeFilter';
    });

    // Update filter status
    updateFilterStatus();

    // Show notification
    showNotification('Đã đặt lại bộ lọc', 'info');
}

// Apply date range filter to the table
function applyDateFilter(table, startDate, endDate) {
    // Remove any existing date filter
    $.fn.dataTable.ext.search = $.fn.dataTable.ext.search.filter(function(fn) {
        return fn.name !== 'dateRangeFilter';
    });
    
    // Create a new date filter function
    const dateRangeFilter = function(settings, data, dataIndex) {
        // Get date from the date column (index 2)
        const dateStr = data[2];
        
        // Parse the date (format: dd/MM/yyyy HH:mm)
        const dateParts = dateStr.split('/');
        if (dateParts.length !== 3) return true; // If date format is unexpected, include the row
        
        const day = parseInt(dateParts[0]);
        const month = parseInt(dateParts[1]) - 1; // Month is 0-indexed in JS Date
        const yearTimeParts = dateParts[2].split(' ');
        const year = parseInt(yearTimeParts[0]);
        
        const rowDate = new Date(year, month, day);
        const rowDateMoment = moment(rowDate);
        
        // Check if the date is within range
        return (rowDateMoment.isSameOrAfter(startDate, 'day') && 
                rowDateMoment.isSameOrBefore(endDate, 'day'));
    };
    
    // Name the function for later removal
    dateRangeFilter.name = 'dateRangeFilter';
    
    // Add the custom search function
    $.fn.dataTable.ext.search.push(dateRangeFilter);
    
    // Apply the filter
    table.draw();
    
    // Show notification
    showNotification('Đã lọc theo khoảng thời gian', 'success');
}

// Clear date filter from the table
function clearDateFilter(table) {
    // Remove date filter from custom search functions
    $.fn.dataTable.ext.search = $.fn.dataTable.ext.search.filter(function(fn) {
        return fn.name !== 'dateRangeFilter';
    });

    // Redraw the table
    table.draw();
    
    // Show notification
    showNotification('Đã xóa bộ lọc thời gian', 'info');
}

// Update the filter button status based on active filters
function updateFilterStatus() {
    // Check if any filters are active
    const customerFilter = $('#customerFilter').val();
    const methodFilter = $('#methodFilter').val();
    const statusFilter = $('#statusFilter').val();
    const minAmount = $('#minAmount').val();
    const maxAmount = $('#maxAmount').val();
    const dateRange = $('#dateRangePicker').val();

    const hasActiveFilters = customerFilter || methodFilter || statusFilter || 
                            minAmount || maxAmount || dateRange;

    // Update filter button appearance
    const filterButton = $('#toggleFilters');
    if (hasActiveFilters) {
        filterButton.addClass('bg-primary text-white').removeClass('bg-white text-gray-700');
        filterButton.find('i').addClass('text-white');
    } else {
        filterButton.removeClass('bg-primary text-white').addClass('bg-white text-gray-700');
        filterButton.find('i').removeClass('text-white');
    }
}

// Set up modal handlers for payment operations
function setupModalHandlers() {
    const paymentModal = document.getElementById('paymentModal');
    const closeModal = document.getElementById('closeModal');
    const cancelPayment = document.getElementById('cancelPayment');
    const addPaymentBtn = document.getElementById('addPaymentBtn');
    const emptyAddPaymentBtn = document.getElementById('emptyAddPaymentBtn');
    const paymentForm = document.getElementById('paymentForm');
    
    // Get context path from meta tag
    const contextPath = document.querySelector('meta[name="context-path"]')?.content || '';
    
    if (addPaymentBtn) {
        addPaymentBtn.addEventListener('click', function() {
            window.location.href = contextPath + '/manager/payment-add';
        });
    }

    if (emptyAddPaymentBtn) {
        emptyAddPaymentBtn.addEventListener('click', function() {
            window.location.href = contextPath + '/manager/payment-add';
        });
    }
    
    if (closeModal) {
        closeModal.addEventListener('click', function() {
            closePaymentModal();
        });
    }
    
    if (cancelPayment) {
        cancelPayment.addEventListener('click', function() {
            closePaymentModal();
        });
    }
    
    if (paymentForm) {
        paymentForm.addEventListener('submit', function(e) {
            e.preventDefault();
            savePayment();
        });
    }
}

// View payment details
function viewPayment(paymentId) {
    const contextPath = document.querySelector('meta[name="context-path"]')?.content || '';
    window.location.href = contextPath + '/manager/payment-details?id=' + paymentId;
}

// Edit payment
function editPayment(paymentId) {
    const contextPath = document.querySelector('meta[name="context-path"]')?.content || '';
    window.location.href = contextPath + '/manager/payment-edit?id=' + paymentId;
}

// Update payment status
function updatePaymentStatus(paymentId, newStatus) {
    const contextPath = document.querySelector('meta[name="context-path"]')?.content || '';
    
    // Status labels for display
    const statusLabels = {
        'PAID': 'Đã thanh toán',
        'PENDING': 'Chờ xử lý',
        'FAILED': 'Thất bại',
        'REFUNDED': 'Đã hoàn tiền'
    };
    
    if (confirm(`Bạn có chắc chắn muốn cập nhật trạng thái thanh toán #${paymentId} thành "${statusLabels[newStatus]}"?`)) {
        // Show loading state
        const button = event.target.closest('button');
        const originalContent = button.innerHTML;
        button.innerHTML = '<i data-lucide="loader-2" class="h-3 w-3 animate-spin mr-1"></i> Đang cập nhật...';
        button.disabled = true;
        
        // Send API request
        fetch(contextPath + '/manager/payments/update-status', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: JSON.stringify({
                paymentId: paymentId,
                paymentStatus: newStatus
            })
        })
        .then(response => {
            if (response.ok) {
                return response.json();
            }
            throw new Error('Network response was not ok');
        })
        .then(data => {
            if (data.success) {
                // Show success message
                showNotification('Cập nhật trạng thái thanh toán thành công!', 'success');
                
                // Reload the page to reflect changes
                setTimeout(() => {
                    location.reload();
                }, 1500);
            } else {
                throw new Error(data.message || 'Có lỗi xảy ra');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showNotification('Có lỗi xảy ra: ' + error.message, 'error');
            
            // Restore button state
            button.innerHTML = originalContent;
            button.disabled = false;
            lucide.createIcons();
        });
    }
}

// Print receipt
function printReceipt(paymentId) {
    const contextPath = document.querySelector('meta[name="context-path"]')?.content || '';
    
    // Open receipt in new window for printing
    const receiptWindow = window.open(
        contextPath + '/manager/payment/receipt/' + paymentId,
        'receipt',
        'width=800,height=600,scrollbars=yes,resizable=yes'
    );
    
    if (receiptWindow) {
        receiptWindow.focus();
        // Auto print when loaded
        receiptWindow.onload = function() {
            receiptWindow.print();
        };
    } else {
        showNotification('Không thể mở cửa sổ in hóa đơn. Vui lòng kiểm tra trình duyệt.', 'error');
    }
}

// Initialize charts
function initializeCharts() {
    // Payment Methods Chart
    const paymentMethodsCtx = document.getElementById('paymentMethodsChart');
    if (paymentMethodsCtx) {
        // Get data from the page or use defaults
        const chartData = window.chartData || {};
        const cashPercent = chartData.cashPaymentsPercent || 20;
        const bankTransferPercent = chartData.bankTransferPaymentsPercent || 30;
        const creditCardPercent = chartData.creditCardPaymentsPercent || 15;
        const vnpayPercent = chartData.vnpayPaymentsPercent || 15;
        const momoPercent = chartData.momoPaymentsPercent || 10;
        const zalopayPercent = chartData.zalopayPaymentsPercent || 10;
        
        new Chart(paymentMethodsCtx, {
            type: 'pie',
            data: {
                labels: ['Tiền mặt', 'Chuyển khoản', 'Thẻ tín dụng', 'VNPay', 'MoMo', 'ZaloPay'],
                datasets: [{
                    data: [cashPercent, bankTransferPercent, creditCardPercent, vnpayPercent, momoPercent, zalopayPercent],
                    backgroundColor: [
                        '#10B981', '#3B82F6', '#F59E0B', '#0068FF', '#A50064', '#0068FF'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right',
                        labels: { font: { family: 'Roboto' } }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return `${context.label || ''}: ${context.raw || 0}%`;
                            }
                        }
                    }
                }
            }
        });
    }
    
    // Monthly Revenue Chart
    const monthlyRevenueCtx = document.getElementById('monthlyRevenueChart');
    if (monthlyRevenueCtx) {
        // Get data from the page or use defaults
        const chartData = window.chartData || {};
        const labels = chartData.monthlyRevenueLabels || ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6'];
        const data = chartData.monthlyRevenueData || [0, 0, 0, 0, 0, 0];
        
        new Chart(monthlyRevenueCtx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu (VNĐ)',
                    data: data,
                    backgroundColor: '#D4AF37',
                    borderColor: '#B8941F',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ' VNĐ';
                            }
                        }
                    }
                },
                plugins: {
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const formattedValue = context.raw.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                                return `${context.dataset.label || ''}: ${formattedValue} VNĐ`;
                            }
                        }
                    }
                }
            }
        });
    }
}

// Show notification
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
    lucide.createIcons();
    
    // Animate in
    setTimeout(() => {
        notification.classList.remove('translate-x-full');
    }, 100);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        notification.classList.add('translate-x-full');
        setTimeout(() => {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 300);
    }, 5000);
}

// Modal Functions
function closePaymentModal() {
    const modal = document.getElementById('paymentModal');
    if (modal) {
        modal.classList.add('hidden');
    }
}

function savePayment() {
    // Get form data
    const paymentId = document.getElementById('paymentId').value;
    const customerId = document.getElementById('customerId').value;
    const paymentDate = document.getElementById('paymentDate').value;
    const paymentMethod = document.getElementById('paymentMethod').value;
    const paymentStatus = document.getElementById('paymentStatus').value;
    const totalAmount = document.getElementById('totalAmount').value;
    const notes = document.getElementById('notes').value;
    
    // Validate required fields
    if (!customerId || !paymentDate || !paymentMethod || !paymentStatus || !totalAmount) {
        showNotification('Vui lòng điền đầy đủ thông tin bắt buộc', 'error');
        return;
    }
    
    // Get context path
    const contextPath = document.querySelector('meta[name="context-path"]')?.content || '';
    
    // Prepare data for API call
    const paymentData = {
        paymentId: paymentId || null,
        customerId: customerId,
        paymentDate: paymentDate,
        paymentMethod: paymentMethod,
        paymentStatus: paymentStatus,
        totalAmount: totalAmount,
        notes: notes
    };
    
    // Show loading state
    const submitButton = document.querySelector('#paymentForm button[type="submit"]');
    const originalButtonText = submitButton.innerHTML;
    submitButton.innerHTML = '<i data-lucide="loader-2" class="h-4 w-4 animate-spin mr-2"></i> Đang lưu...';
    submitButton.disabled = true;
    
    // Determine if this is an add or edit operation
    const isEdit = !!paymentId;
    const url = isEdit 
        ? contextPath + '/manager/payments/update'
        : contextPath + '/manager/payments/add';
    
    // Send API request
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: JSON.stringify(paymentData)
    })
    .then(response => {
        if (response.ok) {
            return response.json();
        }
        throw new Error('Network response was not ok');
    })
    .then(data => {
        if (data.success) {
            // Show success message
            showNotification(isEdit ? 'Cập nhật thanh toán thành công!' : 'Thêm thanh toán thành công!', 'success');
            
            // Close modal
            closePaymentModal();
            
            // Reload the page to reflect changes
            setTimeout(() => {
                location.reload();
            }, 1500);
        } else {
            throw new Error(data.message || 'Có lỗi xảy ra');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showNotification('Có lỗi xảy ra: ' + error.message, 'error');
        
        // Restore button state
        submitButton.innerHTML = originalButtonText;
        submitButton.disabled = false;
        lucide.createIcons();
    });
}