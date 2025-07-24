/**
 * Customer Bookings Management JavaScript
 * Handles DataTables initialization, filtering, and booking actions
 */

// Global variables
let bookingsTable;
const contextPath = window.location.pathname.includes('/spa') ? '/spa' : '';

// Initialize when DOM is ready
$(document).ready(function() {
    initializeBookingsTable();
    initializeEventListeners();
    
    console.log('[CUSTOMER-BOOKINGS] Page initialized successfully');
});

/**
 * Initialize DataTables for bookings
 */
function initializeBookingsTable() {
    bookingsTable = $('#bookingsTable').DataTable({
        responsive: true,
        pageLength: 10,
        lengthMenu: [[10, 25, 50, 100], [10, 25, 50, 100]],
        order: [[2, 'desc'], [3, 'desc']], // Sort by date and time descending
        columnDefs: [
            {
                targets: [7], // Actions column
                orderable: false,
                searchable: false
            },
            {
                targets: [6], // Status column
                orderable: true,
                searchable: true
            }
        ],
        dom: '<"flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-4"<"flex items-center gap-2"l><"flex items-center gap-2"f>>rtip',
        language: {
            lengthMenu: "Hiển thị _MENU_ mục",
            zeroRecords: "Không tìm thấy dữ liệu phù hợp",
            info: "Hiển thị _START_ đến _END_ trong tổng số _TOTAL_ mục",
            infoEmpty: "Hiển thị 0 đến 0 trong tổng số 0 mục",
            infoFiltered: "(được lọc từ _MAX_ mục)",
            search: "Tìm kiếm:",
            paginate: {
                first: "Đầu",
                last: "Cuối",
                next: "Tiếp",
                previous: "Trước"
            },
            emptyTable: "Không có dữ liệu trong bảng",
            loadingRecords: "Đang tải...",
            processing: "Đang xử lý..."
        },
        buttons: [
            {
                extend: 'excel',
                text: '<i class="fas fa-file-excel mr-2"></i>Xuất Excel',
                className: 'btn btn-success btn-sm',
                exportOptions: {
                    columns: [0, 1, 2, 3, 4, 5, 6] // Exclude actions column
                }
            }
        ]
    });
    
    // Add export button to the page
    bookingsTable.buttons().container()
        .appendTo('#bookingsTable_wrapper .dt-buttons');
    
    console.log('[CUSTOMER-BOOKINGS] DataTable initialized');
}

/**
 * Initialize event listeners
 */
function initializeEventListeners() {
    // Status filter
    $('#statusFilter').on('change', function() {
        const selectedStatus = $(this).val();
        filterByStatus(selectedStatus);
    });
    
    // Refresh button
    $('#refreshBtn').on('click', function() {
        refreshBookingsData();
    });
    
    // Search input enhancement
    $('.dataTables_filter input').attr('placeholder', 'Tìm kiếm theo tên dịch vụ, nhân viên...');
    
    console.log('[CUSTOMER-BOOKINGS] Event listeners initialized');
}

/**
 * Filter bookings by status
 */
function filterByStatus(status) {
    if (status === '') {
        bookingsTable.column(6).search('').draw(); // Clear status filter
    } else {
        // Map status values to display text for filtering
        const statusMap = {
            'SCHEDULED': 'Đã lên lịch',
            'CONFIRMED': 'Đã xác nhận',
            'IN_PROGRESS': 'Đang thực hiện',
            'COMPLETED': 'Hoàn thành',
            'CANCELLED': 'Đã hủy'
        };
        
        const displayStatus = statusMap[status] || status;
        bookingsTable.column(6).search(displayStatus).draw();
    }
    
    console.log('[CUSTOMER-BOOKINGS] Filtered by status:', status);
}

/**
 * Refresh bookings data
 */
function refreshBookingsData() {
    const refreshBtn = $('#refreshBtn');
    const originalText = refreshBtn.html();
    
    // Show loading state
    refreshBtn.html('<i data-lucide="loader-2" class="h-4 w-4 mr-2 animate-spin"></i>Đang tải...');
    refreshBtn.prop('disabled', true);
    
    // Simulate refresh (in a real app, this would reload data from server)
    setTimeout(() => {
        // Reset button state
        refreshBtn.html(originalText);
        refreshBtn.prop('disabled', false);
        
        // Reinitialize Lucide icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
        
        // Redraw table
        bookingsTable.draw();
        
        showNotification('Dữ liệu đã được làm mới', 'success');
        console.log('[CUSTOMER-BOOKINGS] Data refreshed');
    }, 1000);
}

/**
 * Cancel a booking
 */
function cancelBooking(bookingId) {
    if (!bookingId) {
        showNotification('Lỗi: Không tìm thấy mã đặt lịch', 'error');
        return;
    }
    
    // Show confirmation dialog
    if (!confirm('Bạn có chắc chắn muốn hủy lịch hẹn này không?')) {
        return;
    }
    
    // Get cancellation reason
    const reason = prompt('Vui lòng nhập lý do hủy lịch (tùy chọn):');
    
    // Show loading state
    const cancelBtn = $(`button[onclick="cancelBooking(${bookingId})"]`);
    const originalText = cancelBtn.html();
    cancelBtn.html('<i data-lucide="loader-2" class="h-3 w-3 mr-1 animate-spin"></i>Đang hủy...');
    cancelBtn.prop('disabled', true);
    
    // Send cancellation request
    $.ajax({
        url: contextPath + '/customer/bookings/cancel',
        method: 'POST',
        data: {
            bookingId: bookingId,
            reason: reason || ''
        },
        dataType: 'json',
        success: function(response) {
            if (response.success) {
                showNotification(response.message || 'Đã hủy lịch hẹn thành công', 'success');
                
                // Update the row in the table
                updateBookingRowStatus(bookingId, 'CANCELLED', 'Đã hủy');
                
                // Update statistics
                updateStatistics();
                
            } else {
                showNotification(response.message || 'Không thể hủy lịch hẹn', 'error');
                
                // Reset button state
                cancelBtn.html(originalText);
                cancelBtn.prop('disabled', false);
            }
        },
        error: function(xhr, status, error) {
            console.error('[CUSTOMER-BOOKINGS] Error cancelling booking:', error);
            showNotification('Lỗi kết nối. Vui lòng thử lại sau.', 'error');
            
            // Reset button state
            cancelBtn.html(originalText);
            cancelBtn.prop('disabled', false);
        },
        complete: function() {
            // Reinitialize Lucide icons
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }
        }
    });
}

/**
 * Update booking row status in the table
 */
function updateBookingRowStatus(bookingId, newStatus, displayStatus) {
    const row = bookingsTable.row(function(idx, data, node) {
        return $(node).find('td:first-child .font-mono').text().includes('#' + bookingId);
    });
    
    if (row.length > 0) {
        const rowNode = row.node();
        const statusCell = $(rowNode).find('td:nth-child(7)');
        const actionsCell = $(rowNode).find('td:nth-child(8)');
        
        // Update status badge
        statusCell.html(`<span class="status-badge status-${newStatus.toLowerCase().replace('_', '-')}">${displayStatus}</span>`);
        
        // Remove cancel button
        actionsCell.find('button[onclick*="cancelBooking"]').remove();
        
        // Redraw the row
        bookingsTable.row(rowNode).invalidate().draw(false);
    }
}

/**
 * Update statistics after booking changes
 */
function updateStatistics() {
    // In a real application, this would fetch updated statistics from the server
    // For now, we'll just update the cancelled bookings count
    const cancelledElement = $('.grid .bg-red-100').closest('.bg-white').find('.text-2xl');
    if (cancelledElement.length > 0) {
        const currentCount = parseInt(cancelledElement.text()) || 0;
        cancelledElement.text(currentCount + 1);
    }
}

/**
 * Show notification message
 */
function showNotification(message, type = 'info') {
    // Create notification element
    const notification = $(`
        <div class="fixed top-4 right-4 z-50 max-w-sm w-full bg-white border border-gray-200 rounded-lg shadow-lg transform transition-all duration-300 translate-x-full">
            <div class="p-4">
                <div class="flex items-center">
                    <div class="flex-shrink-0">
                        ${getNotificationIcon(type)}
                    </div>
                    <div class="ml-3">
                        <p class="text-sm font-medium text-gray-900">${message}</p>
                    </div>
                    <div class="ml-auto pl-3">
                        <button class="inline-flex text-gray-400 hover:text-gray-600 focus:outline-none" onclick="$(this).closest('.fixed').remove()">
                            <i data-lucide="x" class="h-4 w-4"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    `);
    
    // Add to page
    $('body').append(notification);
    
    // Initialize Lucide icons
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }
    
    // Animate in
    setTimeout(() => {
        notification.removeClass('translate-x-full');
    }, 100);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        notification.addClass('translate-x-full');
        setTimeout(() => {
            notification.remove();
        }, 300);
    }, 5000);
}

/**
 * Get notification icon based on type
 */
function getNotificationIcon(type) {
    const icons = {
        success: '<i data-lucide="check-circle" class="h-5 w-5 text-green-500"></i>',
        error: '<i data-lucide="x-circle" class="h-5 w-5 text-red-500"></i>',
        warning: '<i data-lucide="alert-triangle" class="h-5 w-5 text-yellow-500"></i>',
        info: '<i data-lucide="info" class="h-5 w-5 text-blue-500"></i>'
    };
    
    return icons[type] || icons.info;
}

/**
 * Utility function to format date
 */
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('vi-VN', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric'
    });
}

/**
 * Utility function to format time
 */
function formatTime(timeString) {
    const time = new Date('1970-01-01T' + timeString);
    return time.toLocaleTimeString('vi-VN', {
        hour: '2-digit',
        minute: '2-digit',
        hour12: false
    });
}
