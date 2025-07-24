<!-- Manager Bookings JSP: /WEB-INF/views/manager/bookings.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Bookings - BeautyZone Manager</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/buttons/2.4.1/css/buttons.bootstrap5.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid py-4">
        <div class="row">
            <div class="col-12">
                <div class="card shadow">
                    <div class="card-header bg-dark text-white">
                        <h4 class="mb-0"><i class="fas fa-chart-line me-2"></i>All Bookings Management</h4>
                    </div>
                    <div class="card-body">
                        <!-- Advanced Filters -->
                        <div class="row mb-4">
                            <div class="col-md-2">
                                <label for="startDateFilter" class="form-label">From Date</label>
                                <input type="date" id="startDateFilter" class="form-control">
                            </div>
                            <div class="col-md-2">
                                <label for="endDateFilter" class="form-label">To Date</label>
                                <input type="date" id="endDateFilter" class="form-control">
                            </div>
                            <div class="col-md-2">
                                <label for="therapistFilter" class="form-label">Therapist</label>
                                <select id="therapistFilter" class="form-select">
                                    <option value="">All Therapists</option>
                                    <c:forEach items="${therapists}" var="therapist">
                                        <option value="${therapist.userId}">${therapist.fullName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label for="statusFilterMgr" class="form-label">Status</label>
                                <select id="statusFilterMgr" class="form-select">
                                    <option value="">All Statuses</option>
                                    <option value="SCHEDULED">Scheduled</option>
                                    <option value="CONFIRMED">Confirmed</option>
                                    <option value="IN_PROGRESS">In Progress</option>
                                    <option value="COMPLETED">Completed</option>
                                    <option value="CANCELLED">Cancelled</option>
                                    <option value="NO_SHOW">No Show</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label for="serviceTypeFilter" class="form-label">Service Type</label>
                                <select id="serviceTypeFilter" class="form-select">
                                    <option value="">All Types</option>
                                    <c:forEach items="${serviceTypes}" var="serviceType">
                                        <option value="${serviceType.serviceTypeId}">${serviceType.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">&nbsp;</label>
                                <div>
                                    <button id="applyFilters" class="btn btn-primary btn-sm">
                                        <i class="fas fa-filter"></i> Apply
                                    </button>
                                    <button id="resetFilters" class="btn btn-secondary btn-sm">
                                        <i class="fas fa-undo"></i> Reset
                                    </button>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Bookings Table -->
                        <div class="table-responsive">
                            <table id="managerBookingsTable" class="table table-striped table-hover">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Booking ID</th>
                                        <th>Customer</th>
                                        <th>Therapist</th>
                                        <th>Service</th>
                                        <th>Date & Time</th>
                                        <th>Room</th>
                                        <th>Revenue</th>
                                        <th>Payment</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Data will be loaded via AJAX -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.1/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.bootstrap5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.html5.min.js"></script>

    <script>
        $(document).ready(function() {
            // Initialize DataTable
            var table = $('#managerBookingsTable').DataTable({
                processing: true,
                serverSide: true,
                ajax: {
                    url: '${pageContext.request.contextPath}/manager/bookings?action=data',
                    type: 'GET',
                    data: function(d) {
                        d.startDate = $('#startDateFilter').val();
                        d.endDate = $('#endDateFilter').val();
                        d.therapistId = $('#therapistFilter').val();
                        d.status = $('#statusFilterMgr').val();
                        d.serviceTypeId = $('#serviceTypeFilter').val();
                    }
                },
                columns: [
                    { 
                        data: 'bookingId',
                        render: function(data) {
                            return '#BK' + data.toString().padStart(3, '0');
                        }
                    },
                    { 
                        data: 'customerName',
                        render: function(data, type, row) {
                            return data + '<br><small class="text-muted">' + 
                                   (row.customerPhone || '') + '</small>';
                        }
                    },
                    { data: 'therapistName' },
                    { data: 'serviceName' },
                    { 
                        data: null,
                        render: function(data) {
                            var date = new Date(data.appointmentDate);
                            return date.toLocaleDateString() + '<br><small>' + 
                                   data.appointmentTime + '</small>';
                        }
                    },
                    { data: 'roomName' },
                    { 
                        data: 'totalAmount',
                        render: function(data) {
                            return new Intl.NumberFormat('vi-VN', {
                                style: 'currency',
                                currency: 'VND'
                            }).format(data);
                        }
                    },
                    { 
                        data: 'paymentStatus',
                        render: function(data) {
                            var badgeClass = data === 'PAID' ? 'success' : 
                                           data === 'PENDING' ? 'warning' : 'danger';
                            return '<span class="badge bg-' + badgeClass + '">' + data + '</span>';
                        }
                    },
                    { 
                        data: 'bookingStatus',
                        render: function(data) {
                            var badgeClass = 'secondary';
                            if (data === 'CONFIRMED') badgeClass = 'success';
                            else if (data === 'IN_PROGRESS') badgeClass = 'warning';
                            else if (data === 'COMPLETED') badgeClass = 'info';
                            else if (data === 'CANCELLED') badgeClass = 'danger';
                            
                            return '<span class="badge bg-' + badgeClass + '">' + 
                                   data.replace('_', ' ') + '</span>';
                        }
                    },
                    { 
                        data: null,
                        orderable: false,
                        render: function(data, type, row) {
                            return '<div class="btn-group btn-group-sm">' +
                                   '<button class="btn btn-outline-info" onclick="viewDetails(' + 
                                   row.bookingId + ')" title="View Details">' +
                                   '<i class="fas fa-eye"></i></button>' +
                                   '<button class="btn btn-outline-warning" onclick="reassign(' + 
                                   row.bookingId + ')" title="Reassign">' +
                                   '<i class="fas fa-user-edit"></i></button>' +
                                   '<button class="btn btn-outline-secondary" onclick="editBooking(' + 
                                   row.bookingId + ')" title="Edit">' +
                                   '<i class="fas fa-edit"></i></button>' +
                                   '</div>';
                        }
                    }
                ],
                order: [[4, 'desc']],
                pageLength: 25,
                dom: 'Bfrtip',
                buttons: [
                    'copy', 'csv', 'excel', 'pdf'
                ],
                language: {
                    processing: "Loading bookings...",
                    emptyTable: "No bookings found",
                    info: "Showing _START_ to _END_ of _TOTAL_ bookings",
                    infoEmpty: "Showing 0 to 0 of 0 bookings",
                    infoFiltered: "(filtered from _MAX_ total bookings)"
                }
            });
            
            // Filter functionality
            $('#applyFilters').on('click', function() {
                table.draw();
            });
            
            $('#resetFilters').on('click', function() {
                $('#startDateFilter, #endDateFilter').val('');
                $('#therapistFilter, #statusFilterMgr, #serviceTypeFilter').val('');
                table.draw();
            });
        });
        
        // Action functions
        function viewDetails(bookingId) {
            // Implementation for viewing booking details
        }
        
        function reassign(bookingId) {
            // Implementation for reassigning therapist
        }
        
        function editBooking(bookingId) {
            // Implementation for editing booking
        }
    </script>
</body>
</html>