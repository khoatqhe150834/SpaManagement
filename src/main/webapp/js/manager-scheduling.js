/**
 * Manager Scheduling JavaScript
 * Handles scheduling of paid spa services by managers and admins
 * 
 * @author SpaManagement
 */

class ManagerSchedulingSystem {
    constructor() {
        this.contextPath = this.getContextPath();
        this.dataTable = null;
        this.currentSchedulableItems = [];
        this.therapists = [];
        this.currentBookingData = {};
        this.init();
    }
    
    init() {
        console.log('[MANAGER-SCHEDULING] Initializing Manager Scheduling System...');
        this.setupEventListeners();
        this.loadInitialData();

        // Add a small delay to ensure DOM is fully ready
        setTimeout(() => {
            this.initializeDataTable();
        }, 100);

        console.log('[MANAGER-SCHEDULING] System initialized');
    }
    
    getContextPath() {
        // Get context path from global variable set by JSP, fallback to /spa
        return '/spa';
    }
    
    setupEventListeners() {
        // Search and filter inputs (legacy)
        const customerSearch = document.getElementById('customerSearch');
        if (customerSearch) {
            customerSearch.addEventListener('input', () => {
                this.filterTable();
            });
        }
        
        const serviceFilter = document.getElementById('serviceFilter');
        if (serviceFilter) {
            serviceFilter.addEventListener('change', () => {
                this.filterTable();
            });
        }
        
        const priorityFilter = document.getElementById('priorityFilter');
        if (priorityFilter) {
            priorityFilter.addEventListener('change', () => {
                this.filterTable();
            });
        }

        // New filter system integration
        this.setupNewFilterListeners();
        
        // Scheduling form inputs
        const appointmentDate = document.getElementById('appointmentDate');
        const appointmentTime = document.getElementById('appointmentTime');
        const therapistId = document.getElementById('therapistId');
        
        if (appointmentDate) {
            appointmentDate.addEventListener('change', () => {
                this.resetAvailabilityCheck();
            });
        }
        
        if (appointmentTime) {
            appointmentTime.addEventListener('change', () => {
                this.resetAvailabilityCheck();
            });
        }
        
        if (therapistId) {
            therapistId.addEventListener('change', () => {
                this.resetAvailabilityCheck();
            });
        }
        
        // Auto-refresh every 5 minutes
        setInterval(() => {
            this.refreshSchedulableItems();
        }, 5 * 60 * 1000);
    }

    setupNewFilterListeners() {
        // Integration with new filter panel
        const applyFiltersBtn = document.getElementById('applySchedulingFilters');
        if (applyFiltersBtn) {
            applyFiltersBtn.addEventListener('click', () => {
                this.applyAdvancedFilters();
            });
        }

        const resetFiltersBtn = document.getElementById('resetSchedulingFilters');
        if (resetFiltersBtn) {
            resetFiltersBtn.addEventListener('click', () => {
                this.resetAdvancedFilters();
            });
        }

        const refreshBtn = document.getElementById('refreshSchedulingData');
        if (refreshBtn) {
            refreshBtn.addEventListener('click', () => {
                this.refreshSchedulableItems();
            });
        }

        // Add event listeners for individual filter inputs
        const filterInputs = [
            'schedulingCustomerFilter',
            'schedulingServiceFilter',
            'schedulingPriorityFilter',
            'schedulingStatusFilter',
            'minQuantity',
            'maxQuantity',
            'schedulingPaymentDateFilter',
            'schedulingUrgencyFilter'
        ];

        filterInputs.forEach(inputId => {
            const input = document.getElementById(inputId);
            if (input) {
                input.addEventListener('change', () => {
                    // Auto-apply filters when individual inputs change
                    this.applyAdvancedFilters();
                });
            }
        });

        // Setup toggle filter panel
        const toggleButton = document.getElementById('toggleSchedulingFilters');
        const filterPanel = document.getElementById('schedulingFilterPanel');
        
        if (toggleButton && filterPanel) {
            toggleButton.addEventListener('click', () => {
                filterPanel.classList.toggle('show');
                
                // Update button appearance
                const icon = toggleButton.querySelector('i');
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
        }
    }

    applyAdvancedFilters() {
        if (!this.dataTable) {
            console.warn('[MANAGER-SCHEDULING] DataTable not initialized, cannot apply filters');
            return;
        }

        const filters = {
            customer: document.getElementById('schedulingCustomerFilter')?.value || '',
            service: document.getElementById('schedulingServiceFilter')?.value || '',
            priority: document.getElementById('schedulingPriorityFilter')?.value || '',
            status: document.getElementById('schedulingStatusFilter')?.value || '',
            minQuantity: document.getElementById('minQuantity')?.value || '',
            maxQuantity: document.getElementById('maxQuantity')?.value || '',
            paymentDate: document.getElementById('schedulingPaymentDateFilter')?.value || '',
            urgency: document.getElementById('schedulingUrgencyFilter')?.value || '',
            dateRange: document.getElementById('schedulingDateRangePicker')?.value || ''
        };

        console.log('[MANAGER-SCHEDULING] Applying advanced filters:', filters);

        // Clear existing custom search functions
        $.fn.dataTable.ext.search = $.fn.dataTable.ext.search.filter(fn => 
            !fn.name || (!fn.name.includes('scheduling'))
        );

        // Reset all column-specific searches
        this.dataTable.columns().search('');

        // Apply column-specific filters
        if (filters.customer) {
            this.dataTable.column(0).search(filters.customer, false, false);
        }
        if (filters.service) {
            this.dataTable.column(1).search(filters.service, false, false);
        }
        if (filters.priority) {
            // Map priority values to display text
            const priorityMap = {
                'HIGH': 'Cao',
                'MEDIUM': 'Trung bình',
                'LOW': 'Thấp'
            };
            this.dataTable.column(4).search(priorityMap[filters.priority] || filters.priority, false, false);
        }
        if (filters.status) {
            // Map status values to display text
            const statusMap = {
                'PENDING': 'Chờ đặt lịch',
                'SCHEDULED': 'Đã đặt lịch',
                'COMPLETED': 'Hoàn thành',
                'CANCELLED': 'Đã hủy'
            };
            this.dataTable.column(5).search(statusMap[filters.status] || filters.status, false, false);
        }

        // Apply custom filters
        this.applyCustomFilters(filters);

        // Redraw table
        this.dataTable.draw();

        this.showAlert('Đã áp dụng bộ lọc', 'success');
    }

    applyCustomFilters(filters) {
        // Add quantity range filter
        if (filters.minQuantity || filters.maxQuantity) {
            const quantityFilter = function(settings, data, dataIndex) {
                if (settings.nTable.id !== 'schedulingTable') return true;
                
                // Extract quantity from column 2 (format: "remaining/total")
                const quantityText = data[2];
                const quantityMatch = quantityText.match(/(\d+)\/\d+/);
                const quantity = quantityMatch ? parseInt(quantityMatch[1]) : 0;
                
                const min = parseInt(filters.minQuantity) || 0;
                const max = parseInt(filters.maxQuantity) || 999999;
                
                return quantity >= min && quantity <= max;
            };
            quantityFilter.name = 'schedulingQuantityFilter';
            $.fn.dataTable.ext.search.push(quantityFilter);
        }

        // Add payment date filter
        if (filters.paymentDate) {
            const dateFilter = function(settings, data, dataIndex) {
                if (settings.nTable.id !== 'schedulingTable') return true;
                
                const paymentDateStr = data[3]; // Column 3 is payment date
                const paymentDate = new Date(paymentDateStr);
                const today = new Date();
                
                switch (filters.paymentDate) {
                    case 'today':
                        return paymentDate.toDateString() === today.toDateString();
                    case 'yesterday':
                        const yesterday = new Date(today);
                        yesterday.setDate(yesterday.getDate() - 1);
                        return paymentDate.toDateString() === yesterday.toDateString();
                    case 'this_week':
                        const weekStart = new Date(today);
                        weekStart.setDate(today.getDate() - today.getDay());
                        return paymentDate >= weekStart;
                    case 'last_week':
                        const lastWeekStart = new Date(today);
                        lastWeekStart.setDate(today.getDate() - today.getDay() - 7);
                        const lastWeekEnd = new Date(lastWeekStart);
                        lastWeekEnd.setDate(lastWeekStart.getDate() + 6);
                        return paymentDate >= lastWeekStart && paymentDate <= lastWeekEnd;
                    case 'this_month':
                        return paymentDate.getMonth() === today.getMonth() && 
                               paymentDate.getFullYear() === today.getFullYear();
                    case 'last_month':
                        const lastMonth = new Date(today);
                        lastMonth.setMonth(today.getMonth() - 1);
                        return paymentDate.getMonth() === lastMonth.getMonth() && 
                               paymentDate.getFullYear() === lastMonth.getFullYear();
                    default:
                        return true;
                }
            };
            dateFilter.name = 'schedulingDateFilter';
            $.fn.dataTable.ext.search.push(dateFilter);
        }

        // Add urgency filter
        if (filters.urgency) {
            const urgencyFilter = function(settings, data, dataIndex) {
                if (settings.nTable.id !== 'schedulingTable') return true;
                
                const paymentDateStr = data[3];
                const paymentDate = new Date(paymentDateStr);
                const today = new Date();
                const daysDiff = Math.ceil((today - paymentDate) / (1000 * 60 * 60 * 24));
                
                switch (filters.urgency) {
                    case 'urgent':
                        return daysDiff > 7;
                    case 'normal':
                        return daysDiff >= 3 && daysDiff <= 7;
                    case 'low':
                        return daysDiff < 3;
                    default:
                        return true;
                }
            };
            urgencyFilter.name = 'schedulingUrgencyFilter';
            $.fn.dataTable.ext.search.push(urgencyFilter);
        }

        // Add date range filter if specified
        if (filters.dateRange) {
            const dateRangeParts = filters.dateRange.split(' - ');
            if (dateRangeParts.length === 2) {
                const startDate = moment(dateRangeParts[0], 'DD/MM/YYYY');
                const endDate = moment(dateRangeParts[1], 'DD/MM/YYYY');
                
                const dateRangeFilter = function(settings, data, dataIndex) {
                    if (settings.nTable.id !== 'schedulingTable') return true;
                    
                    const paymentDateStr = data[3];
                    const paymentDate = moment(paymentDateStr, 'DD/MM/YYYY');
                    
                    return paymentDate.isBetween(startDate, endDate, 'day', '[]');
                };
                dateRangeFilter.name = 'schedulingDateRangeFilter';
                $.fn.dataTable.ext.search.push(dateRangeFilter);
            }
        }
    }

    resetAdvancedFilters() {
        // Reset all filter inputs
        const filterInputs = [
            'schedulingCustomerFilter',
            'schedulingServiceFilter', 
            'schedulingPriorityFilter',
            'schedulingStatusFilter',
            'minQuantity',
            'maxQuantity',
            'schedulingPaymentDateFilter',
            'schedulingUrgencyFilter',
            'schedulingDateRangePicker'
        ];

        filterInputs.forEach(id => {
            const element = document.getElementById(id);
            if (element) {
                element.value = '';
            }
        });

        // Clear DataTable filters
        if (this.dataTable) {
            // Remove custom filters
            $.fn.dataTable.ext.search = $.fn.dataTable.ext.search.filter(fn => 
                !fn.name || (!fn.name.includes('scheduling'))
            );
            
            this.dataTable.search('').columns().search('').draw();
        }

        this.showAlert('Đã đặt lại bộ lọc', 'info');
    }

    // Method to refresh schedulable items (can be called from JSP)
    refreshSchedulableItems() {
        console.log('[MANAGER-SCHEDULING] Refreshing schedulable items...');
        this.loadSchedulableItems();
    }
    
    async loadInitialData() {
        try {
            this.showLoading(true);
            
            // Load schedulable items
            await this.loadSchedulableItems();
            
            // Load therapists
            await this.loadTherapists();
            
            // Load service filter options
            this.populateServiceFilter();
            
        } catch (error) {
            console.error('[MANAGER-SCHEDULING] Error loading initial data:', error);
            this.showAlert('Lỗi tải dữ liệu ban đầu', 'danger');
        } finally {
            this.showLoading(false);
        }
    }
    
    async loadSchedulableItems() {
        try {
            const url = `${this.contextPath}/api/manager/scheduling/schedulable-items`;
            console.log('[MANAGER-SCHEDULING] Loading schedulable items from:', url);
            console.log('[MANAGER-SCHEDULING] Context path:', this.contextPath);
            console.log('[MANAGER-SCHEDULING] Full URL:', window.location.origin + url);

            const response = await fetch(url, {
                method: 'GET',
                credentials: 'same-origin', // Include session cookies
                headers: {
                    'Accept': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest' // Mark as AJAX request
                }
            });

            console.log('[MANAGER-SCHEDULING] Response status:', response.status);

            if (!response.ok) {
                if (response.status === 401) {
                    console.error('[MANAGER-SCHEDULING] Authentication required - redirecting to login');
                    this.showAlert('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.', 'danger');
                    setTimeout(() => {
                        window.location.href = `${this.contextPath}/login`;
                    }, 2000);
                    return;
                } else if (response.status === 403) {
                    console.error('[MANAGER-SCHEDULING] Access denied - insufficient permissions');
                    this.showAlert('Bạn không có quyền truy cập chức năng này.', 'danger');
                    return;
                }
                throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }

            const text = await response.text();
            console.log('[MANAGER-SCHEDULING] Raw response:', text.substring(0, 200));

            let data;
            try {
                data = JSON.parse(text);
            } catch (parseError) {
                console.error('[MANAGER-SCHEDULING] JSON parse error:', parseError);
                console.error('[MANAGER-SCHEDULING] Response text:', text);
                throw new Error('Invalid JSON response from server');
            }

            if (data.success) {
                this.currentSchedulableItems = data.data || [];
                this.populateSchedulableItemsTable();
                this.populateSchedulingFilters(); // Populate filter dropdowns
                this.updateStatistics();
                console.log('[MANAGER-SCHEDULING] Loaded', this.currentSchedulableItems.length, 'schedulable items');
            } else {
                throw new Error(data.message || 'Failed to load schedulable items');
            }

        } catch (error) {
            console.error('[MANAGER-SCHEDULING] Error loading schedulable items:', error);
            this.showAlert('Lỗi tải danh sách dịch vụ cần đặt lịch: ' + error.message, 'danger');
        }
    }
    
    async loadTherapists() {
        try {
            const url = `${this.contextPath}/manager/scheduling`;
            console.log('[MANAGER-SCHEDULING] Loading therapists...');
            console.log('[MANAGER-SCHEDULING] Context path:', this.contextPath);
            console.log('[MANAGER-SCHEDULING] Therapists URL:', url);
            console.log('[MANAGER-SCHEDULING] Full URL:', window.location.origin + url);

            // Use URLSearchParams instead of FormData for better compatibility
            const formData = new URLSearchParams();
            formData.append('action', 'get_therapists');
            console.log('[MANAGER-SCHEDULING] Form data:', Array.from(formData.entries()));

            const requestHeaders = {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            };
            console.log('[MANAGER-SCHEDULING] Request headers:', requestHeaders);

            const response = await fetch(url, {
                method: 'POST',
                credentials: 'same-origin', // Include session cookies
                headers: requestHeaders,
                body: formData
            });

            console.log('[MANAGER-SCHEDULING] Therapists response status:', response.status);
            console.log('[MANAGER-SCHEDULING] Response headers:', Object.fromEntries(response.headers.entries()));
            console.log('[MANAGER-SCHEDULING] Response URL:', response.url);

            if (!response.ok) {
                // Get response body for debugging
                const responseText = await response.text();
                console.error('[MANAGER-SCHEDULING] Error response body:', responseText);

                if (response.status === 401) {
                    console.error('[MANAGER-SCHEDULING] Authentication required for therapists');
                    this.showAlert('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.', 'danger');
                    setTimeout(() => {
                        window.location.href = `${this.contextPath}/login`;
                    }, 2000);
                    return;
                } else if (response.status === 403) {
                    console.error('[MANAGER-SCHEDULING] Access denied for therapists');
                    this.showAlert('Bạn không có quyền truy cập danh sách nhân viên.', 'danger');
                    return;
                } else if (response.status === 400) {
                    console.error('[MANAGER-SCHEDULING] Bad Request - Response:', responseText);
                    this.showAlert('Lỗi yêu cầu không hợp lệ. Vui lòng thử lại.', 'danger');
                    return;
                }
                throw new Error(`HTTP ${response.status}: ${responseText}`);
            }

            const text = await response.text();
            console.log('[MANAGER-SCHEDULING] Therapists raw response:', text.substring(0, 200));

            let data;
            try {
                data = JSON.parse(text);
            } catch (parseError) {
                console.error('[MANAGER-SCHEDULING] Therapists JSON parse error:', parseError);
                console.error('[MANAGER-SCHEDULING] Response text:', text);
                // If it's HTML (likely an error page), show a generic message
                if (text.includes('<!doctype') || text.includes('<html') || text.includes('<!DOCTYPE')) {
                    console.warn('[MANAGER-SCHEDULING] Server returned HTML instead of JSON for therapists - likely authentication/authorization issue');
                    this.showAlert('Lỗi xác thực. Vui lòng đăng nhập lại.', 'warning');
                    setTimeout(() => {
                        window.location.href = `${this.contextPath}/login`;
                    }, 2000);
                    return;
                }
                throw new Error('Invalid JSON response from server');
            }

            if (data.success) {
                this.therapists = data.data || [];
                this.populateTherapistSelect();
                console.log('[MANAGER-SCHEDULING] Loaded', this.therapists.length, 'therapists');
            } else {
                console.warn('[MANAGER-SCHEDULING] Failed to load therapists:', data.message);
                this.showAlert('Không thể tải danh sách nhân viên: ' + (data.message || 'Lỗi không xác định'), 'warning');
            }

        } catch (error) {
            console.error('[MANAGER-SCHEDULING] Error loading therapists:', error);
            this.showAlert('Lỗi tải danh sách nhân viên: ' + error.message, 'danger');
        }
    }
    
    initializeDataTable() {
        console.log('[MANAGER-SCHEDULING] Starting DataTable initialization...');

        // Check if jQuery and DataTables are available
        if (typeof $ === 'undefined') {
            console.error('[MANAGER-SCHEDULING] jQuery not loaded');
            return;
        }

        if (!$.fn.DataTable) {
            console.error('[MANAGER-SCHEDULING] DataTables not loaded');
            return;
        }

        // Check if the new table ID exists, fallback to old one for compatibility
        const tableId = document.getElementById('schedulingTable') ? 'schedulingTable' : 'schedulableItemsTable';
        const tableElement = $(`#${tableId}`);

        console.log('[MANAGER-SCHEDULING] Table ID found:', tableId);

        // Ensure table element exists
        if (tableElement.length === 0) {
            console.error('[MANAGER-SCHEDULING] Table element not found:', tableId);
            return;
        }

        // Check if DataTable is already initialized
        if ($.fn.DataTable.isDataTable(`#${tableId}`)) {
            console.log('[MANAGER-SCHEDULING] DataTable already initialized, destroying first...');
            try {
                tableElement.DataTable().destroy();
                console.log('[MANAGER-SCHEDULING] Previous DataTable destroyed successfully');
            } catch (destroyError) {
                console.error('[MANAGER-SCHEDULING] Error destroying previous DataTable:', destroyError);
            }
        }

        // Clear any existing DataTable classes and attributes
        tableElement.removeClass('dataTable');
        tableElement.find('thead, tbody, tfoot').removeClass();

        console.log('[MANAGER-SCHEDULING] Initializing DataTable for:', tableId);

        try {
            this.dataTable = tableElement.DataTable({
            responsive: true,
            processing: true,
            searching: true,
            searchDelay: 300,
            pageLength: 10,
            lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "Tất cả"]],
            order: [[3, 'desc']], // Sort by payment date (column 3) descending
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
            dom: 'Blfrtip',
            buttons: [
                {
                    extend: 'excelHtml5',
                    text: '<i data-lucide="file-spreadsheet" class="h-4 w-4 mr-1"></i> Xuất Excel',
                    className: 'bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded',
                    exportOptions: {
                        columns: ':not(:last-child)' // Exclude the last column (actions)
                    }
                },
                {
                    text: '<i data-lucide="refresh-cw" class="h-4 w-4 mr-1"></i> Làm mới',
                    className: 'bg-primary hover:bg-primary-dark text-white font-bold py-2 px-4 rounded',
                    action: () => {
                        this.refreshSchedulableItems();
                    }
                }
            ],
            columnDefs: [
                {
                    responsivePriority: 1,
                    targets: [0, 1, 2, 6] // Customer, Service, Remaining, Actions are high priority
                },
                {
                    responsivePriority: 2,
                    targets: [3, 4] // Payment date, Priority are medium priority
                },
                {
                    responsivePriority: 3,
                    targets: [5] // Status is low priority
                },
                {
                    targets: 6, // Actions column
                    orderable: false,
                    searchable: false
                }
            ],
            drawCallback: function() {
                // Re-initialize Lucide icons after table redraw
                if (typeof lucide !== 'undefined') {
                    lucide.createIcons();
                }
                console.log('[MANAGER-SCHEDULING] DataTable redrawn');
            },
            initComplete: function() {
                var table = this.api();

                // Apply custom styling after DataTables initialization
                $('.dataTables_filter input').addClass('ml-2 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary');
                $('.dataTables_length select').addClass('mx-2 px-2 py-1 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary');
                $('.dataTables_paginate .paginate_button').addClass('mx-1');

                // Style the wrapper
                $('.dataTables_wrapper').addClass('px-0 pb-0');

                // Initialize Lucide icons in the table
                if (typeof lucide !== 'undefined') {
                    lucide.createIcons();
                }
            }
        });

        // Make DataTable globally accessible for filter functions
        window.schedulingTable = this.dataTable;

        console.log('[MANAGER-SCHEDULING] DataTable initialized successfully');

        } catch (error) {
            console.error('[MANAGER-SCHEDULING] Error initializing DataTable:', error);
            this.showAlert('Lỗi khởi tạo bảng dữ liệu: ' + error.message, 'error');
        }
    }
    
    populateSchedulableItemsTable() {
        // Check for both new and old table body IDs for compatibility
        const tbody = document.getElementById('schedulingTableBody') || document.getElementById('schedulableItemsBody');
        if (!tbody) return;

        let html = '';

        if (this.currentSchedulableItems.length === 0) {
            html = `
                <tr>
                    <td colspan="7" class="text-center py-12">
                        <i data-lucide="inbox" class="h-16 w-16 text-gray-400 mx-auto mb-4"></i>
                        <h3 class="text-lg font-semibold text-spa-dark mb-2">Không có dịch vụ nào cần đặt lịch</h3>
                        <p class="text-gray-600">Tất cả dịch vụ đã được đặt lịch hoặc chưa có thanh toán nào.</p>
                    </td>
                </tr>
            `;
        } else {
            this.currentSchedulableItems.forEach(item => {
                const priorityClass = this.getPriorityClass(item.priorityLevel || 'NORMAL');
                const customerInitial = item.customerName ? item.customerName.charAt(0).toUpperCase() : 'K';

                html += `
                    <tr class="hover:bg-spa-cream/50 transition-colors">
                        <td>
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 bg-primary rounded-full flex items-center justify-center text-white font-semibold">
                                    ${customerInitial}
                                </div>
                                <div>
                                    <div class="font-semibold text-spa-dark">${this.escapeHtml(item.customerName || 'N/A')}</div>
                                    <div class="text-sm text-gray-600">${this.escapeHtml(item.customerPhone || 'N/A')}</div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-blue-100 text-blue-800">
                                ${this.escapeHtml(item.serviceName || 'N/A')}
                            </span>
                        </td>
                        <td class="text-center">
                            <span class="inline-flex items-center px-2 py-1 rounded-md text-sm font-medium bg-yellow-100 text-yellow-800">
                                ${item.remainingQuantity}/${item.totalQuantity}
                            </span>
                        </td>
                        <td data-order="${item.paymentDate}">${this.formatDate(item.paymentDate)}</td>
                        <td class="text-center">
                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium ${priorityClass}">
                                ${this.getPriorityText(item.priorityLevel || 'NORMAL')}
                            </span>
                        </td>
                        <td class="text-center">
                            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                Chờ đặt lịch
                            </span>
                        </td>
                        <td class="text-center">
                            <button class="inline-flex items-center px-3 py-1 text-sm font-medium text-white bg-primary hover:bg-primary-dark rounded-md transition-colors duration-200"
                                    onclick="openSchedulingModal(${item.paymentItemId})"
                                    title="Đặt lịch thông minh với CSP Solver">
                                <i data-lucide="calendar-plus" class="h-4 w-4 mr-1"></i>
                                Đặt lịch
                            </button>
                        </td>
                    </tr>
                `;
            });
        }

        tbody.innerHTML = html;

        // Initialize Lucide icons for the new content
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
        
        // Reinitialize DataTable if it exists
        if (this.dataTable) {
            this.dataTable.clear().rows.add($(tbody).find('tr')).draw();
        }
    }
    
    populateServiceFilter() {
        const serviceFilter = document.getElementById('serviceFilter');
        if (!serviceFilter) return;
        
        // Get unique services from schedulable items
        const services = [...new Set(this.currentSchedulableItems.map(item => item.serviceName))];
        
        // Clear existing options (except "All")
        serviceFilter.innerHTML = '<option value="">Tất cả dịch vụ</option>';
        
        services.forEach(serviceName => {
            if (serviceName) {
                const option = document.createElement('option');
                option.value = serviceName;
                option.textContent = serviceName;
                serviceFilter.appendChild(option);
            }
        });

        // Also populate the new scheduling filter dropdowns
        this.populateSchedulingFilters();
    }

    populateSchedulingFilters() {
        // Populate customer filter
        const customerFilter = document.getElementById('schedulingCustomerFilter');
        if (customerFilter) {
            const customers = [...new Set(this.currentSchedulableItems.map(item => item.customerName))];
            
            // Keep the "All customers" option and add unique customers
            let customerOptions = '<option value="">Tất cả khách hàng</option>';
            customers.forEach(customerName => {
                if (customerName) {
                    customerOptions += `<option value="${customerName}">${customerName}</option>`;
                }
            });
            customerFilter.innerHTML = customerOptions;
        }

        // Populate service filter
        const schedulingServiceFilter = document.getElementById('schedulingServiceFilter');
        if (schedulingServiceFilter) {
            const services = [...new Set(this.currentSchedulableItems.map(item => item.serviceName))];
            
            let serviceOptions = '<option value="">Tất cả dịch vụ</option>';
            services.forEach(serviceName => {
                if (serviceName) {
                    serviceOptions += `<option value="${serviceName}">${serviceName}</option>`;
                }
            });
            schedulingServiceFilter.innerHTML = serviceOptions;
        }
    }
    
    populateTherapistSelect() {
        const therapistSelect = document.getElementById('therapistId');
        if (!therapistSelect) return;
        
        // Clear existing options
        therapistSelect.innerHTML = '<option value="">Chọn kỹ thuật viên</option>';
        
        this.therapists.forEach(therapist => {
            if (therapist.isActive) {
                const option = document.createElement('option');
                option.value = therapist.userId;
                option.textContent = therapist.fullName;
                therapistSelect.appendChild(option);
            }
        });
    }
    
    filterTable() {
        if (!this.dataTable) return;
        
        const customerSearch = document.getElementById('customerSearch').value.toLowerCase();
        const serviceFilter = document.getElementById('serviceFilter').value;
        const priorityFilter = document.getElementById('priorityFilter').value;
        
        this.dataTable.search('').columns().search('').draw();
        
        // Apply custom filtering
        $.fn.dataTable.ext.search.push((settings, data, dataIndex) => {
            const customerName = data[0].toLowerCase();
            const serviceName = data[1];
            const priority = data[6];
            
            // Customer search filter
            if (customerSearch && !customerName.includes(customerSearch)) {
                return false;
            }
            
            // Service filter
            if (serviceFilter && !serviceName.includes(serviceFilter)) {
                return false;
            }
            
            // Priority filter
            if (priorityFilter && !priority.includes(this.getPriorityText(priorityFilter))) {
                return false;
            }
            
            return true;
        });
        
        this.dataTable.draw();
        
        // Remove the custom filter after drawing
        $.fn.dataTable.ext.search.pop();
    }
    
    openSchedulingModal(paymentItemId) {
        const item = this.currentSchedulableItems.find(item => item.paymentItemId === paymentItemId);
        if (!item) {
            this.showAlert('Không tìm thấy thông tin dịch vụ', 'error');
            return;
        }

        // Store current booking data
        this.currentBookingData = item;

        // Populate modal with item data
        document.getElementById('paymentItemId').value = item.paymentItemId;
        document.getElementById('customerName').textContent = item.customerName || 'N/A';
        document.getElementById('customerPhone').textContent = item.customerPhone || 'N/A';
        document.getElementById('serviceName').textContent = item.serviceName || 'N/A';
        document.getElementById('serviceDuration').textContent = this.formatDuration(item.serviceDuration);

        // Set customer avatar
        const customerAvatar = document.getElementById('customerAvatar');
        if (customerAvatar) {
            customerAvatar.textContent = item.customerName ? item.customerName.charAt(0).toUpperCase() : 'K';
        }

        // Reset form
        this.resetSchedulingForm();

        // Show modal (using new modal structure)
        const modal = document.getElementById('schedulingModal');
        if (modal) {
            modal.classList.remove('hidden');
        }
    }

    closeSchedulingModal() {
        const modal = document.getElementById('schedulingModal');
        if (modal) {
            modal.classList.add('hidden');
        }

        // Reset form
        this.resetSchedulingForm();

        // Clear current booking data
        this.currentBookingData = {};
    }

    resetSchedulingForm() {
        const form = document.getElementById('schedulingForm');
        if (form) {
            form.reset();
        }

        // Reset availability status
        this.resetAvailabilityCheck();

        // Set minimum date to today
        const appointmentDate = document.getElementById('appointmentDate');
        if (appointmentDate) {
            const today = new Date().toISOString().split('T')[0];
            appointmentDate.min = today;
            appointmentDate.value = today;
        }

        // Set default time to current hour + 1
        const appointmentTime = document.getElementById('appointmentTime');
        if (appointmentTime) {
            const now = new Date();
            now.setHours(now.getHours() + 1);
            const timeString = now.toTimeString().slice(0, 5);
            appointmentTime.value = timeString;
        }
    }

    resetAvailabilityCheck() {
        const availabilityStatus = document.getElementById('availabilityStatus');
        const createBookingBtn = document.getElementById('createBookingBtn');

        if (availabilityStatus) {
            availabilityStatus.style.display = 'none';
        }

        if (createBookingBtn) {
            createBookingBtn.disabled = true;
        }
    }

    async checkAvailability() {
        const therapistId = document.getElementById('therapistId').value;
        const appointmentDate = document.getElementById('appointmentDate').value;
        const appointmentTime = document.getElementById('appointmentTime').value;

        if (!therapistId || !appointmentDate || !appointmentTime) {
            this.showAlert('Vui lòng chọn đầy đủ kỹ thuật viên, ngày và giờ hẹn', 'warning');
            return;
        }

        try {
            const formData = new FormData();
            formData.append('action', 'check_availability');
            formData.append('therapistId', therapistId);
            formData.append('date', appointmentDate);
            formData.append('time', appointmentTime);
            formData.append('duration', this.currentBookingData.serviceDuration || 60);

            const response = await fetch(`${this.contextPath}/manager/scheduling`, {
                method: 'POST',
                body: formData
            });

            const data = await response.json();

            if (data.success) {
                this.displayAvailabilityResult(data.data);
            } else {
                this.showAlert(data.message || 'Lỗi kiểm tra lịch trống', 'danger');
            }

        } catch (error) {
            console.error('[MANAGER-SCHEDULING] Error checking availability:', error);
            this.showAlert('Lỗi kết nối khi kiểm tra lịch trống', 'danger');
        }
    }

    displayAvailabilityResult(result) {
        const availabilityStatus = document.getElementById('availabilityStatus');
        const createBookingBtn = document.getElementById('createBookingBtn');

        if (!availabilityStatus || !createBookingBtn) return;

        availabilityStatus.style.display = 'block';

        if (result.available) {
            availabilityStatus.className = 'availability-status availability-available';
            availabilityStatus.innerHTML = `
                <i class="fas fa-check-circle me-2"></i>
                ${result.reason || 'Có lịch trống'}
            `;
            createBookingBtn.disabled = false;
        } else {
            availabilityStatus.className = 'availability-status availability-unavailable';
            availabilityStatus.innerHTML = `
                <i class="fas fa-times-circle me-2"></i>
                ${result.reason || 'Không có lịch trống'}
            `;
            createBookingBtn.disabled = true;
        }
    }

    async createBooking() {
        const form = document.getElementById('schedulingForm');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        const formData = new FormData(form);
        formData.append('action', 'create_booking');

        try {
            this.showLoading(true);

            const response = await fetch(`${this.contextPath}/manager/scheduling`, {
                method: 'POST',
                body: formData
            });

            const data = await response.json();

            if (data.success) {
                this.showAlert('Đặt lịch thành công!', 'success');

                // Close modal
                this.closeSchedulingModal();

                // Refresh data
                await this.refreshSchedulableItems();

            } else {
                this.showAlert(data.message || 'Đặt lịch thất bại', 'danger');
            }

        } catch (error) {
            console.error('[MANAGER-SCHEDULING] Error creating booking:', error);
            this.showAlert('Lỗi kết nối khi đặt lịch', 'danger');
        } finally {
            this.showLoading(false);
        }
    }

    async refreshSchedulableItems() {
        try {
            this.showLoading(true);
            await this.loadSchedulableItems();
            this.showAlert('Dữ liệu đã được cập nhật', 'info');
        } catch (error) {
            console.error('[MANAGER-SCHEDULING] Error refreshing data:', error);
            this.showAlert('Lỗi cập nhật dữ liệu', 'danger');
        } finally {
            this.showLoading(false);
        }
    }

    updateStatistics() {
        // Update statistics based on current data
        const totalRemaining = this.currentSchedulableItems.reduce((sum, item) => sum + (item.remainingQuantity || 0), 0);
        const totalCustomers = new Set(this.currentSchedulableItems.map(item => item.customerId)).size;
        const totalItems = this.currentSchedulableItems.length;

        const totalRemainingEl = document.getElementById('totalServicesRemaining');
        const totalCustomersEl = document.getElementById('totalCustomersWithUnscheduled');
        const totalItemsEl = document.getElementById('itemsWithRemaining');

        if (totalRemainingEl) totalRemainingEl.textContent = totalRemaining;
        if (totalCustomersEl) totalCustomersEl.textContent = totalCustomers;
        if (totalItemsEl) totalItemsEl.textContent = totalItems;
    }

    showLoading(show) {
        const spinner = document.getElementById('loadingSpinner');
        if (spinner) {
            spinner.style.display = show ? 'block' : 'none';
        }
    }

    showAlert(message, type) {
        // Use the new notification system
        this.showNotification(message, type);
    }

    showNotification(message, type = 'info') {
        const notification = document.createElement('div');
        notification.className = `fixed top-4 right-4 z-50 p-4 rounded-lg shadow-lg max-w-sm transition-all duration-300 transform translate-x-full`;

        const colors = {
            success: 'bg-green-500 text-white',
            error: 'bg-red-500 text-white',
            danger: 'bg-red-500 text-white', // Map danger to error
            warning: 'bg-yellow-500 text-white',
            info: 'bg-blue-500 text-white'
        };
        notification.className += ' ' + (colors[type] || colors.info);

        let iconName = 'info';
        if (type === 'success') iconName = 'check-circle';
        else if (type === 'error' || type === 'danger') iconName = 'x-circle';
        else if (type === 'warning') iconName = 'alert-triangle';

        notification.innerHTML =
            '<div class="flex items-center gap-2">' +
                '<i data-lucide="' + iconName + '" class="h-5 w-5"></i>' +
                '<span>' + message + '</span>' +
            '</div>';

        document.body.appendChild(notification);
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }

        setTimeout(() => {
            notification.classList.remove('translate-x-full');
        }, 100);

        setTimeout(() => {
            notification.classList.add('translate-x-full');
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.parentNode.removeChild(notification);
                }
            }, 300);
        }, 5000);
    }

    // Utility methods

    formatDuration(minutes) {
        if (!minutes) return 'N/A';

        const hours = Math.floor(minutes / 60);
        const mins = minutes % 60;

        if (hours > 0 && mins > 0) {
            return `${hours}h ${mins}m`;
        } else if (hours > 0) {
            return `${hours}h`;
        } else {
            return `${mins}m`;
        }
    }

    formatCurrency(amount) {
        if (!amount) return 'N/A';
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(amount);
    }

    formatDate(dateString) {
        if (!dateString) return 'N/A';
        const date = new Date(dateString);
        return date.toLocaleDateString('vi-VN');
    }

    getPriorityClass(priority) {
        switch (priority) {
            case 'HIGH': return 'bg-red-100 text-red-800';
            case 'MEDIUM': return 'bg-orange-100 text-orange-800';
            case 'NORMAL': return 'bg-green-100 text-green-800';
            default: return 'bg-green-100 text-green-800';
        }
    }

    getPriorityText(priority) {
        switch (priority) {
            case 'HIGH': return 'Cao';
            case 'MEDIUM': return 'Trung bình';
            case 'NORMAL': return 'Bình thường';
            default: return 'Bình thường';
        }
    }

    escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
}

// Global functions for JSP onclick handlers
function refreshSchedulableItems() {
    window.managerSchedulingSystem.refreshSchedulableItems();
}

function checkAvailability() {
    window.managerSchedulingSystem.checkAvailability();
}

function createBooking() {
    window.managerSchedulingSystem.createBooking();
}

function closeSchedulingModal() {
    window.managerSchedulingSystem.closeSchedulingModal();
}

function refreshSchedulableItems() {
    window.managerSchedulingSystem.refreshSchedulableItems();
}

// Initialize the manager scheduling system when page loads
document.addEventListener('DOMContentLoaded', () => {
    // Prevent multiple initializations
    if (!window.managerSchedulingSystem) {
        console.log('[MANAGER-SCHEDULING] Creating new ManagerSchedulingSystem instance');
        window.managerSchedulingSystem = new ManagerSchedulingSystem();
    } else {
        console.log('[MANAGER-SCHEDULING] ManagerSchedulingSystem already exists');
    }
});
