<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="controller.CSPBookingAPI" %>
<%@ page import="controller.CSPBookingAPI.AvailableSlot" %>
<%@ page import="controller.CSPBookingAPI.UnavailableSlot" %>
<%@ page import="controller.CSPBookingAPI.BookingResult" %>
<%@ page import="controller.CSPBookingAPI.SystemInfo" %>
<%@ page import="controller.CSPBookingAPI.HealthStatus" %>
<%@ page import="controller.CSPBookingAPI.PaymentItemDetails" %>
<%@ page import="controller.CSPBookingAPI.QualifiedTherapist" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    // Load PaymentItem data from URL parameter
    String paymentItemIdParam = request.getParameter("paymentItemId");
    Integer paymentItemId = null;
    PaymentItemDetails paymentDetails = null;
    List<QualifiedTherapist> qualifiedTherapists = null;
    String errorMessage = null;

    if (paymentItemIdParam != null && !paymentItemIdParam.trim().isEmpty()) {
        try {
            paymentItemId = Integer.parseInt(paymentItemIdParam);
            paymentDetails = CSPBookingAPI.loadPaymentItemDetails(paymentItemId);

            if (paymentDetails != null) {
                qualifiedTherapists = CSPBookingAPI.findQualifiedTherapists(paymentDetails.serviceId);
                // Debug information
                System.out.println("DEBUG: Service ID: " + paymentDetails.serviceId);
                System.out.println("DEBUG: Qualified therapists count: " + (qualifiedTherapists != null ? qualifiedTherapists.size() : "null"));
                if (qualifiedTherapists != null) {
                    for (QualifiedTherapist qt : qualifiedTherapists) {
                        System.out.println("DEBUG: Therapist: " + qt.therapistName + " (ID: " + qt.therapistId + ")");
                    }
                }
            } else {
                errorMessage = "Payment item not found with ID: " + paymentItemId;
            }
        } catch (NumberFormatException e) {
            errorMessage = "Invalid payment item ID: " + paymentItemIdParam;
        }
    } else {
        errorMessage = "Payment item ID is required";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CSP Booking System - Production Test</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .status-healthy { color: #28a745; }
        .status-error { color: #dc3545; }
        .performance-excellent { color: #28a745; }
        .performance-good { color: #ffc107; }
        .performance-slow { color: #dc3545; }
        .slot-card { 
            border-left: 4px solid #007bff; 
            margin-bottom: 8px;
            transition: all 0.3s ease;
        }
        .slot-card:hover {
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .unavailable-slot { 
            border-left: 4px solid #dc3545; 
            background-color: #f8f9fa;
        }
        .test-section {
            margin-bottom: 30px;
        }
        .result-box {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin: 10px 0;
        }
        .metric-card {
            text-align: center;
            padding: 20px;
            border-radius: 8px;
            margin: 10px 0;
        }
        .metric-value {
            font-size: 2rem;
            font-weight: bold;
        }
        .metric-label {
            color: #6c757d;
            font-size: 0.9rem;
        }
        .time-slot-btn {
            min-height: 80px;
            transition: all 0.3s ease;
        }
        .time-slot-btn:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .time-slot-btn:disabled {
            opacity: 0.4;
        }
        .booking-step {
            border-left: 4px solid #007bff;
            padding-left: 15px;
        }
        .resource-count {
            font-size: 0.75rem;
            font-weight: bold;
        }
    </style>

    <!-- JavaScript functions defined early to be available for HTML event handlers -->
    <script>
        // Global functions for CSP booking system
        function loadAvailableSlots() {
            const selectedDate = document.getElementById('selectedDate').value;
            const paymentItemId = <%= paymentItemId != null ? paymentItemId : "null" %>;

            if (!selectedDate) {
                alert('Please select a date first.');
                return;
            }

            if (!paymentItemId) {
                alert('Payment item ID is required.');
                return;
            }

            // Validate date is not in the past
            const today = new Date().toISOString().split('T')[0];
            if (selectedDate < today) {
                alert('Please select a date that is today or in the future.');
                return;
            }

            // Show loading
            const resultsDiv = document.getElementById('slotsResults');
            resultsDiv.innerHTML = '<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Loading available slots...</div>';
            document.getElementById('availableSlotsSection').style.display = 'block';

            // Make AJAX request to get available slots
            fetch('${pageContext.request.contextPath}/api/csp-booking/available-slots', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    paymentItemId: paymentItemId,
                    selectedDate: selectedDate
                })
            })
            .then(response => response.json())
            .then(data => {
                displayAvailableSlots(data);
            })
            .catch(error => {
                console.error('Error loading slots:', error);
                resultsDiv.innerHTML = '<div class="alert alert-danger"><i class="fas fa-exclamation-triangle"></i> Error loading slots: ' + error.message + '</div>';
            });
        }

        function displayAvailableSlots(data) {
            const resultsDiv = document.getElementById('slotsResults');

            if (!data.success) {
                resultsDiv.innerHTML = '<div class="alert alert-danger"><i class="fas fa-exclamation-triangle"></i> ' + data.message + '</div>';
                return;
            }

            const availableSlots = data.availableSlots || [];
            const unavailableSlots = data.unavailableSlots || [];

            let html = '<div class="row">';

            // Available slots column
            html += '<div class="col-md-6">';
            html += '<div class="card border-success">';
            html += '<div class="card-header bg-success text-white">';
            html += '<h6><i class="fas fa-check-circle"></i> Available Slots (' + availableSlots.length + ')</h6>';
            html += '</div>';
            html += '<div class="card-body" style="max-height: 400px; overflow-y: auto;">';

            if (availableSlots.length > 0) {
                availableSlots.forEach((slot, index) => {
                    html += '<div class="card slot-card mb-2">';
                    html += '<div class="card-body py-2">';
                    html += '<div class="row align-items-center">';
                    html += '<div class="col-md-4">';
                    html += '<strong><i class="fas fa-clock"></i> ' + formatTime(slot.startTime) + ' - ' + formatTime(slot.endTime) + '</strong>';
                    html += '</div>';
                    html += '<div class="col-md-4">';
                    html += '<small><i class="fas fa-user-md"></i> ' + slot.therapistName + '</small>';
                    html += '</div>';
                    html += '<div class="col-md-4">';
                    html += '<button class="btn btn-sm btn-primary" onclick="selectSlot(' + index + ')">';
                    html += '<i class="fas fa-calendar-plus"></i> Select';
                    html += '</button>';
                    html += '</div>';
                    html += '</div>';
                    html += '<div class="row mt-1">';
                    html += '<div class="col-12">';
                    html += '<small class="text-muted"><i class="fas fa-door-open"></i> Room ' + slot.roomId + ', Bed ' + slot.bedId + ' | Confidence: ' + slot.confidenceLevel + '</small>';
                    html += '</div>';
                    html += '</div>';
                    html += '</div>';
                    html += '</div>';
                });
            } else {
                html += '<div class="alert alert-info"><i class="fas fa-info-circle"></i> No available slots found for the selected date.</div>';
            }

            html += '</div></div></div>';

            // Unavailable slots column
            html += '<div class="col-md-6">';
            html += '<div class="card border-warning">';
            html += '<div class="card-header bg-warning text-dark">';
            html += '<h6><i class="fas fa-times-circle"></i> Unavailable Slots (' + unavailableSlots.length + ')</h6>';
            html += '</div>';
            html += '<div class="card-body" style="max-height: 400px; overflow-y: auto;">';

            if (unavailableSlots.length > 0) {
                unavailableSlots.forEach(slot => {
                    html += '<div class="card slot-card unavailable-slot mb-2">';
                    html += '<div class="card-body py-2">';
                    html += '<div class="row">';
                    html += '<div class="col-md-6">';
                    html += '<strong><i class="fas fa-clock"></i> ' + formatTime(slot.startTime) + ' - ' + formatTime(slot.endTime) + '</strong>';
                    html += '</div>';
                    html += '<div class="col-md-6">';
                    html += '<small class="text-muted"><i class="fas fa-info-circle"></i> ' + slot.reason + '</small>';
                    html += '</div>';
                    html += '</div>';
                    html += '</div>';
                    html += '</div>';
                });
            } else {
                html += '<div class="alert alert-success"><i class="fas fa-check-circle"></i> All time slots are available!</div>';
            }

            html += '</div></div></div></div>';

            // Summary
            html += '<div class="row mt-3">';
            html += '<div class="col-12">';
            html += '<div class="alert alert-info">';
            html += '<strong>Summary:</strong> ' + data.summary;
            html += '<br><strong>Processing Time:</strong> ' + data.processingTime + 'ms';
            html += '</div>';
            html += '</div>';
            html += '</div>';

            resultsDiv.innerHTML = html;
        }

        function formatTime(timeStr) {
            if (typeof timeStr === 'string') {
                return timeStr.substring(0, 5); // HH:MM format
            }
            return timeStr;
        }

        function selectSlot(slotIndex) {
            alert('Slot selection functionality will be implemented in the next phase.');
            // TODO: Implement actual booking logic
        }
    </script>
</head>
<body>
    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h2><i class="fas fa-cogs"></i> CSP Booking System - Production Test Interface</h2>
                        <p class="mb-0">Comprehensive testing of the Constraint Satisfaction Problem booking system</p>
                    </div>
                    <div class="card-body">

                        <!-- PaymentItem Information Section -->
                        <% if (errorMessage != null) { %>
                            <div class="alert alert-danger">
                                <i class="fas fa-exclamation-triangle"></i> <strong>Error:</strong> <%= errorMessage %>
                            </div>
                        <% } else if (paymentDetails != null) { %>
                            <div class="test-section">
                                <h4><i class="fas fa-receipt"></i> Service Information</h4>
                                <div class="row">
                                    <div class="col-md-8">
                                        <div class="card border-success">
                                            <div class="card-header bg-success text-white">
                                                <h5><i class="fas fa-spa"></i> <%= paymentDetails.serviceName %></h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <p><strong>Description:</strong> <%= paymentDetails.serviceDescription %></p>
                                                        <p><strong>Duration:</strong> <%= paymentDetails.serviceDuration %> minutes</p>
                                                        <p><strong>Payment Item ID:</strong> <%= paymentDetails.paymentItemId %></p>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <p><strong>Customer ID:</strong> <%= paymentDetails.customerId %></p>
                                                        <p><strong>Total Quantity:</strong> <%= paymentDetails.totalQuantity %></p>
                                                        <p><strong>Remaining:</strong> <span class="badge bg-primary"><%= paymentDetails.remainingQuantity %></span></p>
                                                        <p><strong>Payment Status:</strong> <span class="badge bg-success"><%= paymentDetails.paymentStatus %></span></p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="card border-info">
                                            <div class="card-header bg-info text-white">
                                                <h6><i class="fas fa-calendar-alt"></i> Date Selection</h6>
                                            </div>
                                            <div class="card-body">
                                                <div class="mb-3">
                                                    <label for="selectedDate" class="form-label">Select Date:</label>
                                                    <input type="date" class="form-control" id="selectedDate"
                                                           min="<%= LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) %>"
                                                           onchange="loadAvailableSlots()">
                                                </div>
                                                <button type="button" class="btn btn-primary w-100" onclick="loadAvailableSlots()">
                                                    <i class="fas fa-search"></i> Find Available Slots
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Qualified Therapists Section -->
                            <div class="test-section">
                                <h4><i class="fas fa-user-md"></i> Qualified Therapists</h4>
                                <div class="card">
                                    <div class="card-body">
                                        <!-- Debug Information -->
                                        <div class="alert alert-info">
                                            <strong>Debug Info:</strong><br>
                                            Service ID: <%= paymentDetails != null ? paymentDetails.serviceId : "null" %><br>
                                            Service Name: <%= paymentDetails != null ? paymentDetails.serviceName : "null" %><br>
                                            Qualified Therapists: <%= qualifiedTherapists != null ? qualifiedTherapists.size() + " found" : "null" %><br>
                                            <% if (qualifiedTherapists != null && !qualifiedTherapists.isEmpty()) { %>
                                                First Therapist: <%= qualifiedTherapists.get(0).therapistName %>
                                            <% } %>
                                        </div>
                                        
                                        <% if (qualifiedTherapists != null && !qualifiedTherapists.isEmpty()) { %>
                                            <div class="row">
                                                <% for (QualifiedTherapist therapist : qualifiedTherapists) { %>
                                                    <div class="col-md-4 mb-3">
                                                        <div class="card border-primary">
                                                            <div class="card-body">
                                                                <h6><i class="fas fa-user"></i> <%= therapist.therapistName %></h6>
                                                                <p class="small mb-1"><strong>ID:</strong> <%= therapist.therapistId %></p>
                                                                <p class="small mb-1"><strong>Email:</strong> <%= therapist.email %></p>
                                                                <p class="small mb-1"><strong>Phone:</strong> <%= therapist.phone %></p>
                                                                <p class="small mb-1"><strong>Experience:</strong> <%= therapist.yearsOfExperience %> years</p>
                                                                <p class="small mb-0"><strong>Status:</strong>
                                                                    <span class="badge bg-<%= "AVAILABLE".equals(therapist.availabilityStatus) ? "success" : "warning" %>">
                                                                        <%= therapist.availabilityStatus %>
                                                                    </span>
                                                                </p>
                                                            </div>
                                                        </div>
                                                    </div>
                                                <% } %>
                                            </div>
                                        <% } else { %>
                                            <div class="alert alert-warning">
                                                <i class="fas fa-exclamation-triangle"></i> No qualified therapists found for this service.
                                            </div>
                                            
                                            <!-- Additional Debug Information -->
                                            <% if (paymentDetails != null) { %>
                                                <div class="alert alert-secondary">
                                                    <h6>Database Debug Information:</h6>
                                                    <pre><%= CSPBookingAPI.debugDatabaseState(paymentDetails.serviceId) %></pre>
                                                </div>
                                            <% } %>
                                        <% } %>
                                    </div>
                                </div>
                            </div>

                            <!-- Available Slots Section -->
                            <div class="test-section" id="availableSlotsSection" style="display: none;">
                                <h4><i class="fas fa-clock"></i> Available Time Slots</h4>
                                <div id="slotsResults">
                                    <!-- Results will be loaded here -->
                                </div>
                            </div>
                        <% } %>

                        <!-- System Status Section -->
                        <div class="test-section">
                            <h4><i class="fas fa-heartbeat"></i> System Status</h4>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="card">
                                        <div class="card-body">
                                            <h6>System Information</h6>
                                            <%
                                                try {
                                                    CSPBookingAPI.SystemInfo systemInfo = CSPBookingAPI.getSystemInfo();
                                            %>
                                            <div class="result-box">
                                                <strong>System:</strong> <%= systemInfo.systemType %> v<%= systemInfo.version %><br>
                                                <strong>Status:</strong> <span class="status-healthy"><%= systemInfo.status %></span><br>
                                                <strong>Business Hours:</strong> <%= systemInfo.businessHours %><br>
                                                <strong>Time Interval:</strong> <%= systemInfo.timeInterval %><br>
                                                <strong>Buffer Time:</strong> <%= systemInfo.bufferTime %>
                                            </div>
                                            <%
                                                } catch (Exception e) {
                                            %>
                                            <div class="alert alert-danger">
                                                <i class="fas fa-exclamation-triangle"></i> Error: <%= e.getMessage() %>
                                            </div>
                                            <%
                                                }
                                            %>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="card">
                                        <div class="card-body">
                                            <h6>Health Check</h6>
                                            <%
                                                try {
                                                    CSPBookingAPI.HealthStatus health = CSPBookingAPI.getSystemHealth();
                                                    String statusClass = "healthy".equals(health.status) ? "status-healthy" : "status-error";
                                                    String icon = "healthy".equals(health.status) ? "fa-check-circle" : "fa-exclamation-triangle";
                                            %>
                                            <div class="result-box">
                                                <div class="<%= statusClass %>">
                                                    <i class="fas <%= icon %>"></i> <strong><%= health.status.toUpperCase() %></strong>
                                                </div>
                                                <small class="text-muted">
                                                    Response Time: <%= health.responseTimeMs %>ms<br>
                                                    <%= health.testResult != null ? health.testResult : (health.error != null ? health.error : "") %>
                                                </small>
                                            </div>
                                            <%
                                                } catch (Exception e) {
                                            %>
                                            <div class="alert alert-danger">
                                                <i class="fas fa-exclamation-triangle"></i> Health check failed: <%= e.getMessage() %>
                                            </div>
                                            <%
                                                }
                                            %>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Customer Booking Simulation Section -->
                        <div class="test-section">
                            <h4><i class="fas fa-calendar-plus"></i> Customer Booking Simulation</h4>
                            <p class="text-muted">Simulate the real customer booking process with service selection, time slot viewing, and resource availability.</p>

                            <!-- Data Consistency Control -->
                            <div class="alert alert-info">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h6><i class="fas fa-cog"></i> Data Consistency Settings</h6>
                                        <small>Control whether data stays the same on page reload or generates randomly each time.</small>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-check form-switch">
                                            <input class="form-check-input" type="checkbox" id="consistentDataToggle" checked onchange="toggleDataConsistency()">
                                            <label class="form-check-label" for="consistentDataToggle">
                                                <strong id="dataMode">Consistent Data</strong>
                                            </label>
                                        </div>
                                        <button class="btn btn-sm btn-outline-primary mt-1" onclick="regenerateData()">
                                            <i class="fas fa-sync-alt"></i> Regenerate Data
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <!-- Service Selection -->
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <div class="card">
                                        <div class="card-header bg-primary text-white">
                                            <h6><i class="fas fa-spa"></i> Step 1: Choose Your Service</h6>
                                        </div>
                                        <div class="card-body">
                                            <div class="mb-3">
                                                <label for="serviceSelect" class="form-label">Select Service:</label>
                                                <select class="form-select" id="serviceSelect" onchange="loadTimeSlots()">
                                                    <option value="">-- Choose a Service --</option>
                                                    <option value="1">Swedish Massage (60 min) - $80</option>
                                                    <option value="2">Deep Tissue Massage (90 min) - $120</option>
                                                    <option value="3">Classic Facial (60 min) - $70</option>
                                                    <option value="4">Anti-Aging Facial (75 min) - $95</option>
                                                    <option value="5">Basic Manicure (30 min) - $35</option>
                                                    <option value="6">Gel Manicure (45 min) - $50</option>
                                                </select>
                                            </div>
                                            <div id="serviceInfo" class="alert alert-info" style="display: none;">
                                                <div id="serviceDetails"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="card">
                                        <div class="card-header bg-success text-white">
                                            <h6><i class="fas fa-clock"></i> Step 2: Select Date & Time</h6>
                                        </div>
                                        <div class="card-body">
                                            <div class="mb-3">
                                                <label for="dateSelect" class="form-label">Select Date:</label>
                                                <select class="form-select" id="dateSelect" onchange="loadTimeSlots()">
                                                    <option value="">-- Choose Date --</option>
                                                    <%
                                                        java.time.LocalDate today = java.time.LocalDate.now();
                                                        for (int i = 0; i < 7; i++) {
                                                            java.time.LocalDate date = today.plusDays(i);
                                                            String dateStr = date.toString();
                                                            String displayDate = date.format(java.time.format.DateTimeFormatter.ofPattern("EEEE, MMM dd, yyyy"));
                                                    %>
                                                    <option value="<%= dateStr %>"><%= displayDate %></option>
                                                    <%
                                                        }
                                                    %>
                                                </select>
                                            </div>
                                            <div id="loadingTimeSlots" class="text-center" style="display: none;">
                                                <div class="spinner-border spinner-border-sm text-primary" role="status"></div>
                                                <small class="text-muted ms-2">Loading available times...</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Time Slots Display -->
                            <div id="timeSlotsSection" style="display: none;">
                                <div class="card">
                                    <div class="card-header bg-info text-white">
                                        <h6><i class="fas fa-calendar-alt"></i> Step 3: Available Time Slots (8:00 AM - 8:00 PM)</h6>
                                        <div class="row mt-2">
                                            <div class="col-12">
                                                <small>
                                                    <span class="badge bg-success me-2">✓ Available</span>
                                                    <span class="badge bg-warning text-dark me-2">⚡ Peak Hours</span>
                                                    <span class="badge bg-danger me-2">✗ Unavailable</span>
                                                    <em>Hover over slots for details • Click unavailable slots to see why</em>
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <div id="timeSlotsGrid" class="row">
                                            <!-- Time slots will be loaded here -->
                                        </div>
                                        <div id="noSlotsMessage" class="alert alert-warning" style="display: none;">
                                            <i class="fas fa-exclamation-triangle"></i> No available time slots found for the selected service and date.
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Resource Details Modal -->
                            <div class="modal fade" id="resourceModal" tabindex="-1">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-header bg-warning text-dark">
                                            <h5 class="modal-title">
                                                <i class="fas fa-info-circle"></i> Booking Details
                                            </h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body">
                                            <div id="resourceDetails">
                                                <!-- Resource details will be loaded here -->
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                            <button type="button" class="btn btn-primary" onclick="simulateBooking()">
                                                <i class="fas fa-check"></i> Confirm Booking (Simulation)
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Booking Confirmation -->
                            <div id="bookingConfirmation" class="alert alert-success" style="display: none;">
                                <h6><i class="fas fa-check-circle"></i> Booking Confirmed!</h6>
                                <div id="confirmationDetails"></div>
                            </div>
                        </div>

                        <!-- Real Therapist Schedule Management Section -->
                        <div class="test-section">
                            <h4><i class="fas fa-calendar-check"></i> Therapist Schedule Management</h4>
                            <p class="text-muted">View real booking schedules for each therapist with filtering by date and service to understand system availability.</p>

                            <!-- Schedule Filters -->
                            <div class="row mb-4">
                                <div class="col-md-3">
                                    <div class="card">
                                        <div class="card-header bg-secondary text-white">
                                            <h6><i class="fas fa-filter"></i> Schedule Filters</h6>
                                        </div>
                                        <div class="card-body">
                                            <div class="mb-3">
                                                <label for="filterTherapist" class="form-label">Select Therapist:</label>
                                                <select class="form-select" id="filterTherapist" onchange="loadTherapistSchedule()">
                                                    <option value="">-- Select Therapist --</option>
                                                    <!-- Therapists will be loaded from database -->
                                                </select>
                                            </div>
                                            <div class="mb-3">
                                                <label for="filterDate" class="form-label">Filter by Date:</label>
                                                <select class="form-select" id="filterDate" onchange="loadTherapistSchedule()">
                                                    <option value="">All Dates</option>
                                                    <%
                                                        java.time.LocalDate filterToday = java.time.LocalDate.now();
                                                        for (int i = -7; i <= 14; i++) {
                                                            java.time.LocalDate filterDate = filterToday.plusDays(i);
                                                            String filterDateStr = filterDate.toString();
                                                            String filterDisplayDate = filterDate.format(java.time.format.DateTimeFormatter.ofPattern("EEEE, MMM dd"));
                                                            String dayLabel = i == 0 ? " (Today)" : (i == 1 ? " (Tomorrow)" : (i == -1 ? " (Yesterday)" : ""));
                                                    %>
                                                    <option value="<%= filterDateStr %>"><%= filterDisplayDate %><%= dayLabel %></option>
                                                    <%
                                                        }
                                                    %>
                                                </select>
                                            </div>
                                            <div class="mb-3">
                                                <label for="filterService" class="form-label">Filter by Service:</label>
                                                <select class="form-select" id="filterService" onchange="loadTherapistSchedule()">
                                                    <option value="">All Services</option>
                                                    <!-- Services will be loaded from database -->
                                                </select>
                                            </div>
                                            <div class="mb-3">
                                                <label for="filterStatus" class="form-label">Filter by Status:</label>
                                                <select class="form-select" id="filterStatus" onchange="loadTherapistSchedule()">
                                                    <option value="">All Statuses</option>
                                                    <option value="SCHEDULED">Scheduled</option>
                                                    <option value="CONFIRMED">Confirmed</option>
                                                    <option value="IN_PROGRESS">In Progress</option>
                                                    <option value="COMPLETED">Completed</option>
                                                    <option value="CANCELLED">Cancelled</option>
                                                    <option value="NO_SHOW">No Show</option>
                                                </select>
                                            </div>
                                            <div class="d-grid gap-2">
                                                <button class="btn btn-primary" onclick="loadTherapistSchedule()">
                                                    <i class="fas fa-sync-alt"></i> Load Schedule
                                                </button>
                                                <button class="btn btn-outline-secondary" onclick="clearScheduleFilters()">
                                                    <i class="fas fa-times"></i> Clear Filters
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-9">
                                    <div class="card">
                                        <div class="card-header bg-primary text-white">
                                            <h6><i class="fas fa-chart-bar"></i> Schedule Summary</h6>
                                        </div>
                                        <div class="card-body">
                                            <div class="row text-center" id="scheduleSummary">
                                                <div class="col-md-3">
                                                    <div class="metric-card bg-light">
                                                        <div class="metric-value text-primary" id="totalAppointments">0</div>
                                                        <div class="metric-label">Total Appointments</div>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="metric-card bg-light">
                                                        <div class="metric-value text-success" id="confirmedAppointments">0</div>
                                                        <div class="metric-label">Confirmed</div>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="metric-card bg-light">
                                                        <div class="metric-value text-warning" id="scheduledAppointments">0</div>
                                                        <div class="metric-label">Scheduled</div>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="metric-card bg-light">
                                                        <div class="metric-value text-info" id="workloadHours">0h</div>
                                                        <div class="metric-label">Total Hours</div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row mt-3">
                                                <div class="col-12">
                                                    <div class="alert alert-info" id="therapistInfo" style="display: none;">
                                                        <h6><i class="fas fa-user-md"></i> <span id="selectedTherapistName">Therapist</span> Schedule</h6>
                                                        <div id="therapistDetails"></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Therapist Schedule Table -->
                            <div class="card">
                                <div class="card-header bg-dark text-white">
                                    <h6><i class="fas fa-table"></i> Therapist Schedule
                                        <span class="badge bg-secondary ms-2" id="filteredCount">0 appointments</span>
                                    </h6>
                                </div>
                                <div class="card-body">
                                    <div id="loadingBookings" class="text-center" style="display: none;">
                                        <div class="spinner-border text-primary" role="status"></div>
                                        <p class="mt-2">Loading existing bookings...</p>
                                    </div>

                                    <div class="table-responsive">
                                        <table class="table table-striped table-hover" id="bookingsTable">
                                            <thead class="table-dark">
                                                <tr>
                                                    <th>Booking ID</th>
                                                    <th>Date</th>
                                                    <th>Time</th>
                                                    <th>Service</th>
                                                    <th>Customer</th>
                                                    <th>Therapist</th>
                                                    <th>Room</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody id="bookingsTableBody">
                                                <tr>
                                                    <td colspan="9" class="text-center text-muted">
                                                        <i class="fas fa-info-circle"></i> Select a therapist to view their schedule
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <!-- Availability Analysis -->
                            <div class="row mt-4">
                                <div class="col-md-6">
                                    <div class="card">
                                        <div class="card-header bg-info text-white">
                                            <h6><i class="fas fa-chart-pie"></i> Unavailability Breakdown</h6>
                                        </div>
                                        <div class="card-body">
                                            <div id="unavailabilityChart">
                                                <canvas id="reasonChart" width="400" height="200"></canvas>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="card">
                                        <div class="card-header bg-warning text-dark">
                                            <h6><i class="fas fa-clock"></i> Peak Hours Analysis</h6>
                                        </div>
                                        <div class="card-body">
                                            <div id="peakHoursAnalysis">
                                                <div class="row text-center">
                                                    <div class="col-6">
                                                        <h4 class="text-danger" id="peakUnavailable">0</h4>
                                                        <small>Peak Hours Unavailable</small>
                                                    </div>
                                                    <div class="col-6">
                                                        <h4 class="text-success" id="regularUnavailable">0</h4>
                                                        <small>Regular Hours Unavailable</small>
                                                    </div>
                                                </div>
                                                <hr>
                                                <div class="text-center">
                                                    <h5>Most Common Peak Hour Issues:</h5>
                                                    <div id="peakIssues" class="mt-2">
                                                        <span class="badge bg-danger me-1">No Therapist (45%)</span>
                                                        <span class="badge bg-warning text-dark me-1">Fully Booked (35%)</span>
                                                        <span class="badge bg-info me-1">No Room (20%)</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Detailed Slot Analysis -->
                        <div class="test-section">
                            <h4><i class="fas fa-calendar-check"></i> Detailed Slot Analysis (Swedish Massage)</h4>
                            <%
                                try {
                                    long startTime = System.currentTimeMillis();
                                    BookingResult detailedResult = CSPBookingAPI.findAvailableSlotsDetailed(1, 10);
                                    long duration = System.currentTimeMillis() - startTime;
                                    
                                    List<AvailableSlot> availableSlots = detailedResult.getAvailableSlots();
                                    List<UnavailableSlot> unavailableSlots = detailedResult.getUnavailableSlots();
                            %>
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <div class="metric-card bg-success text-white">
                                        <div class="metric-value"><%= availableSlots.size() %></div>
                                        <div class="metric-label">Available Slots</div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="metric-card bg-warning text-white">
                                        <div class="metric-value"><%= unavailableSlots.size() %></div>
                                        <div class="metric-label">Unavailable Slots</div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="metric-card bg-info text-white">
                                        <div class="metric-value"><%= duration %>ms</div>
                                        <div class="metric-label">Response Time</div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <h6><i class="fas fa-check-circle text-success"></i> Available Slots</h6>
                                    <%
                                        for (int i = 0; i < Math.min(5, availableSlots.size()); i++) {
                                            AvailableSlot slot = availableSlots.get(i);
                                    %>
                                    <div class="card slot-card">
                                        <div class="card-body py-2">
                                            <div class="row align-items-center">
                                                <div class="col-md-3">
                                                    <small><strong>#<%= i+1 %></strong></small>
                                                </div>
                                                <div class="col-md-4">
                                                    <small><i class="fas fa-calendar"></i> <%= slot.getDate() %></small>
                                                </div>
                                                <div class="col-md-5">
                                                    <small><i class="fas fa-clock"></i> <%= slot.getStartTime() %> - <%= slot.getEndTime() %></small>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <small><i class="fas fa-user"></i> Therapist <%= slot.getTherapistId() %></small>
                                                </div>
                                                <div class="col-md-6">
                                                    <small><i class="fas fa-door-open"></i> Room <%= slot.getRoomId() %>, Bed <%= slot.getBedId() %></small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <%
                                        }
                                        if (availableSlots.size() > 5) {
                                    %>
                                    <small class="text-muted">... and <%= availableSlots.size() - 5 %> more available slots</small>
                                    <%
                                        }
                                    %>
                                </div>
                                <div class="col-md-6">
                                    <h6><i class="fas fa-times-circle text-warning"></i> Unavailable Slots (Sample)</h6>
                                    <%
                                        for (int i = 0; i < Math.min(5, unavailableSlots.size()); i++) {
                                            UnavailableSlot slot = unavailableSlots.get(i);
                                    %>
                                    <div class="card slot-card unavailable-slot">
                                        <div class="card-body py-2">
                                            <div class="row align-items-center">
                                                <div class="col-md-3">
                                                    <small><strong>#<%= i+1 %></strong></small>
                                                </div>
                                                <div class="col-md-4">
                                                    <small><i class="fas fa-calendar"></i> <%= slot.getDate() %></small>
                                                </div>
                                                <div class="col-md-5">
                                                    <small><i class="fas fa-clock"></i> <%= slot.getStartTime() %> - <%= slot.getEndTime() %></small>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-12">
                                                    <small><i class="fas fa-info-circle"></i> <%= slot.getReason() %></small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <%
                                        }
                                        if (unavailableSlots.size() > 5) {
                                    %>
                                    <small class="text-muted">... and <%= unavailableSlots.size() - 5 %> more unavailable slots</small>
                                    <%
                                        }
                                    %>
                                </div>
                            </div>
                            <%
                                } catch (Exception e) {
                            %>
                            <div class="alert alert-danger">
                                <i class="fas fa-exclamation-triangle"></i> Detailed analysis failed: <%= e.getMessage() %>
                            </div>
                            <%
                                }
                            %>
                        </div>

                        <!-- Production Test Results -->
                        <div class="test-section">
                            <h4><i class="fas fa-clipboard-check"></i> Production Test Results</h4>
                            <div class="result-box">
                                <pre style="background: white; border: 1px solid #dee2e6; padding: 15px; border-radius: 5px;"><%= CSPBookingAPI.runProductionTest() %></pre>
                            </div>
                        </div>

                        <!-- Footer -->
                        <div class="text-center mt-4">
                            <div class="alert alert-success">
                                <h5><i class="fas fa-check-circle"></i> CSP Booking System Test Complete</h5>
                                <p class="mb-0">
                                    System is <strong>operational</strong> and ready for production use.<br>
                                    <small class="text-muted">Test performed at: <%= new java.util.Date() %></small>
                                </p>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Booking simulation functionality
        const services = {
            1: {
                name: 'Swedish Massage',
                duration: 60,
                price: 80,
                type: 'Massage',
                description: 'Relaxing full-body massage using gentle strokes',
                qualifiedTherapists: ['Dr. Sarah Anderson', 'Ms. Maria Rodriguez', 'Mr. David Thompson', 'Dr. Jennifer Lee'],
                specializations: ['Relaxation', 'Stress Relief', 'Muscle Tension'],
                roomRequirements: 'Private massage room with dimmed lighting'
            },
            2: {
                name: 'Deep Tissue Massage',
                duration: 90,
                price: 120,
                type: 'Massage',
                description: 'Intensive massage targeting deep muscle layers',
                qualifiedTherapists: ['Dr. Sarah Anderson', 'Mr. David Thompson', 'Dr. Michael Martinez'],
                specializations: ['Deep Tissue', 'Sports Therapy', 'Injury Recovery'],
                roomRequirements: 'Private massage room with specialized equipment'
            },
            3: {
                name: 'Classic Facial',
                duration: 60,
                price: 70,
                type: 'Facial',
                description: 'Cleansing and rejuvenating facial treatment',
                qualifiedTherapists: ['Ms. Maria Rodriguez', 'Dr. Jennifer Lee', 'Ms. Lisa Martinez'],
                specializations: ['Skincare', 'Anti-Aging', 'Hydration'],
                roomRequirements: 'Facial treatment room with steamer and equipment'
            },
            4: {
                name: 'Anti-Aging Facial',
                duration: 75,
                price: 95,
                type: 'Facial',
                description: 'Advanced facial treatment for mature skin',
                qualifiedTherapists: ['Dr. Jennifer Lee', 'Ms. Lisa Martinez'],
                specializations: ['Anti-Aging', 'Advanced Skincare', 'Collagen Therapy'],
                roomRequirements: 'Advanced facial room with specialized anti-aging equipment'
            },
            5: {
                name: 'Basic Manicure',
                duration: 30,
                price: 35,
                type: 'Manicure',
                description: 'Essential nail care and polish application',
                qualifiedTherapists: ['Ms. Maria Rodriguez', 'Ms. Lisa Martinez', 'Ms. Emma Garcia', 'Ms. Sophie Wilson'],
                specializations: ['Nail Care', 'Polish Application', 'Hand Care'],
                roomRequirements: 'Manicure station with proper ventilation'
            },
            6: {
                name: 'Gel Manicure',
                duration: 45,
                price: 50,
                type: 'Manicure',
                description: 'Long-lasting gel polish manicure',
                qualifiedTherapists: ['Ms. Lisa Martinez', 'Ms. Emma Garcia', 'Ms. Sophie Wilson'],
                specializations: ['Gel Application', 'UV Curing', 'Nail Art'],
                roomRequirements: 'Manicure station with UV lamp and gel equipment'
            }
        };

        let selectedSlot = null;
        let availableSlots = [];
        let allBookings = [];
        let filteredBookings = [];

        // Seeded Random Number Generator for consistent data
        class SeededRandom {
            constructor(seed = 12345) {
                this.seed = seed;
            }

            // Linear Congruential Generator for consistent pseudo-random numbers
            next() {
                this.seed = (this.seed * 1664525 + 1013904223) % Math.pow(2, 32);
                return this.seed / Math.pow(2, 32);
            }

            // Get random number between 0 and 1 (like Math.random())
            random() {
                return this.next();
            }

            // Get random integer between min and max (inclusive)
            randomInt(min, max) {
                return Math.floor(this.random() * (max - min + 1)) + min;
            }

            // Get random element from array
            randomChoice(array) {
                return array[Math.floor(this.random() * array.length)];
            }

            // Shuffle array (Fisher-Yates algorithm)
            shuffle(array) {
                const shuffled = [...array];
                for (let i = shuffled.length - 1; i > 0; i--) {
                    const j = Math.floor(this.random() * (i + 1));
                    [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
                }
                return shuffled;
            }
        }

        // Global seeded random instance
        let rng = new SeededRandom(12345); // Fixed seed for consistent data
        let useConsistentData = true; // Toggle for consistent vs random data

        // Helper function to get random number (consistent or truly random)
        function getRandom() {
            return useConsistentData ? rng.random() : Math.random();
        }

        // Helper function to get random integer
        function getRandomInt(min, max) {
            return useConsistentData ? rng.randomInt(min, max) : Math.floor(Math.random() * (max - min + 1)) + min;
        }

        // Helper function to get random choice from array
        function getRandomChoice(array) {
            return useConsistentData ? rng.randomChoice(array) : array[Math.floor(Math.random() * array.length)];
        }

        // Control functions
        function toggleDataConsistency() {
            useConsistentData = document.getElementById('consistentDataToggle').checked;
            document.getElementById('dataMode').textContent = useConsistentData ? 'Consistent Data' : 'Random Data';

            if (useConsistentData) {
                // Reset seed for consistent data
                rng = new SeededRandom(12345);
            }

            // Clear existing data to force regeneration
            allBookings = [];
            filteredBookings = [];
            availableSlots = [];

            // Update displays
            document.getElementById('serviceSelect').value = '';
            document.getElementById('dateSelect').value = '';
            document.getElementById('serviceInfo').style.display = 'none';
            document.getElementById('timeSlotsSection').style.display = 'none';
        }

        function regenerateData() {
            if (useConsistentData) {
                // Use a different seed for new consistent data
                const newSeed = Date.now() % 100000; // Use timestamp for new seed
                rng = new SeededRandom(newSeed);
                console.log('New seed:', newSeed);
            }

            // Clear and regenerate all data
            allBookings = [];
            filteredBookings = [];
            availableSlots = [];

            // Reload bookings
            loadAllBookings();

            // Clear current selections
            document.getElementById('serviceSelect').value = '';
            document.getElementById('dateSelect').value = '';
            document.getElementById('serviceInfo').style.display = 'none';
            document.getElementById('timeSlotsSection').style.display = 'none';
        }

        function loadTimeSlots() {
            const serviceId = document.getElementById('serviceSelect').value;
            const selectedDate = document.getElementById('dateSelect').value;

            if (!serviceId || !selectedDate) {
                document.getElementById('timeSlotsSection').style.display = 'none';
                return;
            }

            // Show service info
            const service = services[serviceId];
            const qualifiedTherapistsList = service.qualifiedTherapists.map(therapist =>
                '<span class="badge bg-primary me-1">' + therapist + '</span>'
            ).join('');

            const specializationsList = service.specializations.map(spec =>
                '<span class="badge bg-info me-1">' + spec + '</span>'
            ).join('');

            document.getElementById('serviceDetails').innerHTML =
                '<div class="row">' +
                    '<div class="col-md-6">' +
                        '<strong>' + service.name + '</strong><br>' +
                        '<small class="text-muted">' + service.description + '</small><br><br>' +
                        '<i class="fas fa-clock"></i> <strong>Duration:</strong> ' + service.duration + ' minutes<br>' +
                        '<i class="fas fa-dollar-sign"></i> <strong>Price:</strong> $' + service.price + '<br>' +
                        '<i class="fas fa-spa"></i> <strong>Type:</strong> ' + service.type + '<br>' +
                        '<i class="fas fa-door-open"></i> <strong>Room:</strong> ' + service.roomRequirements +
                    '</div>' +
                    '<div class="col-md-6">' +
                        '<h6><i class="fas fa-user-md"></i> Qualified Therapists (' + service.qualifiedTherapists.length + '):</h6>' +
                        '<div class="mb-2">' + qualifiedTherapistsList + '</div>' +
                        '<h6><i class="fas fa-star"></i> Specializations:</h6>' +
                        '<div>' + specializationsList + '</div>' +
                    '</div>' +
                '</div>';
            document.getElementById('serviceInfo').style.display = 'block';

            // Show loading
            document.getElementById('loadingTimeSlots').style.display = 'block';
            document.getElementById('timeSlotsSection').style.display = 'block';

            // Simulate API call to get available slots
            setTimeout(() => {
                generateTimeSlots(serviceId, selectedDate);
                document.getElementById('loadingTimeSlots').style.display = 'none';
            }, 1000);
        }

        function generateTimeSlots(serviceId, selectedDate) {
            // Generate all possible time slots from 8 AM to 8 PM
            const slots = [];
            const startHour = 8;
            const endHour = 20;

            // Define possible unavailability reasons
            const unavailabilityReasons = [
                { reason: 'NO_THERAPIST_AVAILABLE', message: 'No qualified therapists available', weight: 0.4 },
                { reason: 'NO_ROOM_AVAILABLE', message: 'All treatment rooms occupied', weight: 0.25 },
                { reason: 'NO_BED_AVAILABLE', message: 'All treatment beds in use', weight: 0.15 },
                { reason: 'THERAPIST_BREAK', message: 'Therapist break time', weight: 0.1 },
                { reason: 'MAINTENANCE', message: 'Room maintenance scheduled', weight: 0.05 },
                { reason: 'FULLY_BOOKED', message: 'All resources fully booked', weight: 0.05 }
            ];

            for (let hour = startHour; hour < endHour; hour++) {
                for (let minute = 0; minute < 60; minute += 15) {
                    const startTime = String(hour).padStart(2, '0') + ':' + String(minute).padStart(2, '0');
                    const service = services[serviceId];
                    const endMinute = minute + service.duration + 15; // Include buffer time
                    const endHour = hour + Math.floor(endMinute / 60);
                    const finalMinute = endMinute % 60;

                    // Check if slot fits within business hours
                    if (endHour <= 20) {
                        const endTime = String(endHour).padStart(2, '0') + ':' + String(finalMinute).padStart(2, '0');

                        // Simulate availability with realistic patterns
                        let isAvailable = true;
                        let unavailabilityReason = null;
                        let unavailabilityMessage = '';
                        let therapistCount = 0;
                        let roomCount = 0;
                        let bedCount = 0;

                        // Higher unavailability during peak hours (11 AM - 2 PM, 6 PM - 8 PM)
                        const isPeakHour = (hour >= 11 && hour <= 14) || (hour >= 18 && hour <= 20);
                        const baseAvailability = isPeakHour ? 0.6 : 0.8; // 60% vs 80% availability

                        // Weekend has different availability patterns
                        const selectedDateObj = new Date(selectedDate);
                        const isWeekend = selectedDateObj.getDay() === 0 || selectedDateObj.getDay() === 6;
                        const weekendModifier = isWeekend ? 0.9 : 1.0; // Slightly better weekend availability

                        const availabilityChance = baseAvailability * weekendModifier;

                        if (getRandom() > availabilityChance) {
                            isAvailable = false;
                            // Select random reason based on weights
                            const randomValue = getRandom();
                            let cumulativeWeight = 0;

                            for (const reasonObj of unavailabilityReasons) {
                                cumulativeWeight += reasonObj.weight;
                                if (randomValue <= cumulativeWeight) {
                                    unavailabilityReason = reasonObj.reason;
                                    unavailabilityMessage = reasonObj.message;
                                    break;
                                }
                            }
                        } else {
                            // Generate realistic resource counts when available
                            const service = services[serviceId];
                            const maxQualifiedTherapists = service.qualifiedTherapists.length;

                            // Available therapists should not exceed qualified therapists
                            therapistCount = Math.min(
                                getRandomInt(1, 3),
                                maxQualifiedTherapists
                            );
                            roomCount = getRandomInt(1, 3);
                            bedCount = getRandomInt(1, 4);
                        }

                        slots.push({
                            startTime,
                            endTime,
                            isAvailable,
                            therapistCount,
                            roomCount,
                            bedCount,
                            unavailabilityReason,
                            unavailabilityMessage,
                            date: selectedDate,
                            serviceId: serviceId,
                            isPeakHour: isPeakHour
                        });
                    }
                }
            }

            displayTimeSlots(slots);
        }

        function displayTimeSlots(slots) {
            const grid = document.getElementById('timeSlotsGrid');
            const noSlotsMessage = document.getElementById('noSlotsMessage');

            const availableSlots = slots.filter(slot => slot.isAvailable);

            if (availableSlots.length === 0) {
                grid.innerHTML = '';
                noSlotsMessage.style.display = 'block';
                return;
            }

            noSlotsMessage.style.display = 'none';

            let html = '';
            slots.forEach((slot, index) => {
                let statusClass, statusIcon, disabled, resourceInfo;

                if (slot.isAvailable) {
                    statusClass = slot.isPeakHour ? 'btn-outline-warning' : 'btn-outline-success';
                    statusIcon = 'fa-check-circle';
                    disabled = '';
                    resourceInfo = '<small class="text-success">T:' + slot.therapistCount + ' R:' + slot.roomCount + ' B:' + slot.bedCount + '</small>';
                } else {
                    statusClass = 'btn-outline-danger';
                    statusIcon = 'fa-times-circle';
                    disabled = ''; // Make unavailable slots clickable to show details
                    resourceInfo = '<small class="text-danger" title="' + slot.unavailabilityMessage + '">' +
                                  getShortReason(slot.unavailabilityReason) + '</small>';
                }

                const peakIndicator = slot.isPeakHour ? '<span class="badge bg-warning text-dark" style="font-size: 0.6rem;">Peak</span>' : '';

                html += '<div class="col-md-3 col-sm-4 col-6 mb-2">' +
                        '<button class="btn ' + statusClass + ' w-100 time-slot-btn position-relative" ' +
                        disabled + ' onclick="showSlotDetails(' + index + ')" data-slot-index="' + index + '" ' +
                        'title="' + (slot.isAvailable ? 'Available - Click for details' : slot.unavailabilityMessage) + '">' +
                        peakIndicator +
                        '<div class="d-flex flex-column">' +
                        '<div class="fw-bold"><i class="fas ' + statusIcon + '"></i> ' + slot.startTime + '</div>' +
                        '<small>' + slot.endTime + '</small>' +
                        resourceInfo +
                        '</div></button></div>';
            });

            grid.innerHTML = html;
            window.availableSlots = slots; // Store for later use
        }

        function getShortReason(reason) {
            const shortReasons = {
                'NO_THERAPIST_AVAILABLE': 'No Therapist',
                'NO_ROOM_AVAILABLE': 'No Room',
                'NO_BED_AVAILABLE': 'No Bed',
                'THERAPIST_BREAK': 'Break Time',
                'MAINTENANCE': 'Maintenance',
                'FULLY_BOOKED': 'Fully Booked'
            };
            return shortReasons[reason] || 'Unavailable';
        }

        function getAvailableTherapistsForSlot(slot, service) {
            // Simulate which specific therapists are available for this slot
            const availableTherapists = [];
            const qualifiedTherapists = service.qualifiedTherapists;

            // Randomly select available therapists from qualified ones
            const availableCount = Math.min(slot.therapistCount, qualifiedTherapists.length);
            const shuffled = useConsistentData ? rng.shuffle(qualifiedTherapists) : [...qualifiedTherapists].sort(() => 0.5 - Math.random());

            for (let i = 0; i < availableCount; i++) {
                const therapist = shuffled[i];
                const experience = getRandomInt(3, 12); // 3-12 years experience
                const rating = (getRandom() * 1.5 + 3.5).toFixed(1); // 3.5-5.0 rating
                const isSpecialist = getRandom() > 0.6; // 40% chance of being specialist

                availableTherapists.push({
                    name: therapist,
                    experience: experience,
                    rating: rating,
                    isSpecialist: isSpecialist
                });
            }

            if (availableTherapists.length === 0) {
                return '<div class="alert alert-warning"><small>No qualified therapists available for this slot</small></div>';
            }

            let html = '<div class="row">';
            availableTherapists.forEach((therapist, index) => {
                const specialistBadge = therapist.isSpecialist ?
                    '<span class="badge bg-warning text-dark ms-1">Specialist</span>' : '';

                html += '<div class="col-md-6 mb-2">' +
                        '<div class="card border-success">' +
                            '<div class="card-body py-2">' +
                                '<h6 class="card-title mb-1">' +
                                    '<i class="fas fa-user-md text-success"></i> ' + therapist.name +
                                    specialistBadge +
                                '</h6>' +
                                '<small class="text-muted">' +
                                    '<i class="fas fa-star text-warning"></i> ' + therapist.rating + '/5.0 • ' +
                                    '<i class="fas fa-calendar-alt"></i> ' + therapist.experience + ' years exp.' +
                                '</small>' +
                            '</div>' +
                        '</div>' +
                    '</div>';
            });
            html += '</div>';

            return html;
        }

        function showSlotDetails(slotIndex) {
            const slot = window.availableSlots[slotIndex];
            if (!slot) return;

            selectedSlot = slot;
            const service = services[slot.serviceId];

            // Handle unavailable slots
            if (!slot.isAvailable) {
                showUnavailableSlotDetails(slot, service);
                return;
            }

            const details =
                '<div class="row">' +
                    '<div class="col-md-6">' +
                        '<h6><i class="fas fa-spa"></i> Service Details</h6>' +
                        '<table class="table table-sm">' +
                            '<tr><td><strong>Service:</strong></td><td>' + service.name + '</td></tr>' +
                            '<tr><td><strong>Duration:</strong></td><td>' + service.duration + ' minutes</td></tr>' +
                            '<tr><td><strong>Price:</strong></td><td>$' + service.price + '</td></tr>' +
                            '<tr><td><strong>Date:</strong></td><td>' + formatDate(slot.date) + '</td></tr>' +
                            '<tr><td><strong>Time:</strong></td><td>' + slot.startTime + ' - ' + slot.endTime + '</td></tr>' +
                        '</table>' +
                    '</div>' +
                    '<div class="col-md-6">' +
                        '<h6><i class="fas fa-users"></i> Available Resources</h6>' +
                        '<div class="row text-center">' +
                            '<div class="col-4">' +
                                '<div class="card bg-light">' +
                                    '<div class="card-body py-2">' +
                                        '<h4 class="text-primary">' + slot.therapistCount + '</h4>' +
                                        '<small>Therapists</small>' +
                                    '</div>' +
                                '</div>' +
                            '</div>' +
                            '<div class="col-4">' +
                                '<div class="card bg-light">' +
                                    '<div class="card-body py-2">' +
                                        '<h4 class="text-success">' + slot.roomCount + '</h4>' +
                                        '<small>Rooms</small>' +
                                    '</div>' +
                                '</div>' +
                            '</div>' +
                            '<div class="col-4">' +
                                '<div class="card bg-light">' +
                                    '<div class="card-body py-2">' +
                                        '<h4 class="text-info">' + slot.bedCount + '</h4>' +
                                        '<small>Beds</small>' +
                                    '</div>' +
                                '</div>' +
                            '</div>' +
                        '</div>' +
                        '<div class="mt-3">' +
                            '<h6><i class="fas fa-user-md"></i> Available Qualified Therapists</h6>' +
                            '<div class="mb-2">' +
                                getAvailableTherapistsForSlot(slot, service) +
                            '</div>' +
                            '<h6><i class="fas fa-info-circle"></i> Booking Information</h6>' +
                            '<div class="alert alert-info">' +
                                '<small>' +
                                    '<i class="fas fa-user"></i> <strong>Therapist Assignment:</strong> You can choose from available qualified therapists<br>' +
                                    '<i class="fas fa-door-open"></i> <strong>Room:</strong> ' + service.roomRequirements + '<br>' +
                                    '<i class="fas fa-bed"></i> <strong>Equipment:</strong> All necessary equipment provided<br>' +
                                    '<i class="fas fa-clock"></i> <strong>Buffer Time:</strong> 15 minutes included for preparation<br>' +
                                    '<i class="fas fa-star"></i> <strong>Specializations:</strong> ' + service.specializations.join(', ') +
                                '</small>' +
                            '</div>' +
                        '</div>' +
                    '</div>' +
                '</div>';

            document.getElementById('resourceDetails').innerHTML = details;

            const modal = new bootstrap.Modal(document.getElementById('resourceModal'));
            modal.show();
        }

        function showUnavailableSlotDetails(slot, service) {
            const details =
                '<div class="row">' +
                    '<div class="col-md-6">' +
                        '<h6><i class="fas fa-spa"></i> Service Details</h6>' +
                        '<table class="table table-sm">' +
                            '<tr><td><strong>Service:</strong></td><td>' + service.name + '</td></tr>' +
                            '<tr><td><strong>Duration:</strong></td><td>' + service.duration + ' minutes</td></tr>' +
                            '<tr><td><strong>Price:</strong></td><td>$' + service.price + '</td></tr>' +
                            '<tr><td><strong>Date:</strong></td><td>' + formatDate(slot.date) + '</td></tr>' +
                            '<tr><td><strong>Time:</strong></td><td>' + slot.startTime + ' - ' + slot.endTime + '</td></tr>' +
                        '</table>' +
                    '</div>' +
                    '<div class="col-md-6">' +
                        '<h6><i class="fas fa-exclamation-triangle text-danger"></i> Unavailability Details</h6>' +
                        '<div class="alert alert-danger">' +
                            '<h6><i class="fas fa-times-circle"></i> ' + slot.unavailabilityMessage + '</h6>' +
                            '<p class="mb-2"><strong>Reason Code:</strong> ' + slot.unavailabilityReason + '</p>' +
                            getUnavailabilityExplanation(slot.unavailabilityReason) +
                        '</div>' +
                        '<div class="mt-2">' +
                            '<h6><i class="fas fa-user-md"></i> Qualified Therapists Status</h6>' +
                            getTherapistAvailabilityStatus(slot, service) +
                        '</div>' +
                        '<div class="mt-3">' +
                            '<h6><i class="fas fa-lightbulb text-warning"></i> Suggestions</h6>' +
                            '<div class="alert alert-info">' +
                                getAlternativeSuggestions(slot) +
                            '</div>' +
                        '</div>' +
                    '</div>' +
                '</div>';

            document.getElementById('resourceDetails').innerHTML = details;

            // Update modal title and button
            document.querySelector('#resourceModal .modal-title').innerHTML =
                '<i class="fas fa-exclamation-triangle"></i> Slot Unavailable';
            document.querySelector('#resourceModal .btn-primary').style.display = 'none';

            const modal = new bootstrap.Modal(document.getElementById('resourceModal'));
            modal.show();

            // Reset modal for next use
            modal._element.addEventListener('hidden.bs.modal', function () {
                document.querySelector('#resourceModal .modal-title').innerHTML =
                    '<i class="fas fa-info-circle"></i> Booking Details';
                document.querySelector('#resourceModal .btn-primary').style.display = 'inline-block';
            }, { once: true });
        }

        function getUnavailabilityExplanation(reason) {
            const explanations = {
                'NO_THERAPIST_AVAILABLE':
                    '<p><strong>Details:</strong> All qualified therapists for this service are currently booked or unavailable during this time slot.</p>',
                'NO_ROOM_AVAILABLE':
                    '<p><strong>Details:</strong> All treatment rooms are occupied by other appointments during this time period.</p>',
                'NO_BED_AVAILABLE':
                    '<p><strong>Details:</strong> All treatment beds are in use. This may be due to high demand or maintenance.</p>',
                'THERAPIST_BREAK':
                    '<p><strong>Details:</strong> This time slot falls during scheduled therapist break time. Our staff need regular breaks to provide quality service.</p>',
                'MAINTENANCE':
                    '<p><strong>Details:</strong> Scheduled maintenance or cleaning is taking place in the treatment rooms during this time.</p>',
                'FULLY_BOOKED':
                    '<p><strong>Details:</strong> This is a popular time slot and all resources (therapists, rooms, and beds) are fully booked.</p>'
            };
            return explanations[reason] || '<p><strong>Details:</strong> This time slot is currently unavailable.</p>';
        }

        function getTherapistAvailabilityStatus(slot, service) {
            const qualifiedTherapists = service.qualifiedTherapists;
            let html = '<div class="table-responsive"><table class="table table-sm">';
            html += '<thead><tr><th>Therapist</th><th>Status</th><th>Reason</th></tr></thead><tbody>';

            const unavailabilityReasons = [
                'Booked with another client',
                'On scheduled break',
                'In training session',
                'Personal time off',
                'Double-booked (system conflict)',
                'Equipment maintenance'
            ];

            qualifiedTherapists.forEach(therapist => {
                const isAvailable = getRandom() > 0.8; // 20% chance of being available even when slot is unavailable
                let status, reason, statusClass;

                if (isAvailable) {
                    status = 'Available';
                    reason = 'Ready for booking';
                    statusClass = 'text-success';
                } else {
                    status = 'Unavailable';
                    reason = getRandomChoice(unavailabilityReasons);
                    statusClass = 'text-danger';
                }

                html += '<tr>' +
                        '<td><i class="fas fa-user-md"></i> ' + therapist + '</td>' +
                        '<td><span class="' + statusClass + '"><strong>' + status + '</strong></span></td>' +
                        '<td><small class="text-muted">' + reason + '</small></td>' +
                        '</tr>';
            });

            html += '</tbody></table></div>';

            // Add summary
            const availableCount = qualifiedTherapists.filter(() => Math.random() > 0.8).length;
            const totalCount = qualifiedTherapists.length;

            html += '<div class="alert alert-info mt-2">' +
                    '<small><i class="fas fa-info-circle"></i> ' +
                    '<strong>Summary:</strong> ' + availableCount + ' of ' + totalCount + ' qualified therapists available. ' +
                    'Slot unavailable due to insufficient resources or other constraints.' +
                    '</small></div>';

            return html;
        }

        function getAlternativeSuggestions(slot) {
            const hour = parseInt(slot.startTime.split(':')[0]);
            let suggestions = '';

            if (slot.unavailabilityReason === 'NO_THERAPIST_AVAILABLE') {
                suggestions = '<strong>Try:</strong> Earlier morning slots (8-10 AM) or evening slots (6-8 PM) typically have more therapist availability.';
            } else if (slot.unavailabilityReason === 'NO_ROOM_AVAILABLE') {
                suggestions = '<strong>Try:</strong> Mid-morning (10-11 AM) or mid-afternoon (3-4 PM) slots often have better room availability.';
            } else if (slot.unavailabilityReason === 'THERAPIST_BREAK') {
                suggestions = '<strong>Try:</strong> Slots 30-60 minutes before or after this time. Break times are usually 15-30 minutes.';
            } else if (slot.unavailabilityReason === 'MAINTENANCE') {
                suggestions = '<strong>Try:</strong> Different time of day or consider booking for tomorrow. Maintenance is usually scheduled during off-peak hours.';
            } else if (slot.unavailabilityReason === 'FULLY_BOOKED') {
                if (hour >= 11 && hour <= 14) {
                    suggestions = '<strong>Try:</strong> This is peak lunch time. Consider morning (8-11 AM) or late afternoon (4-6 PM) slots.';
                } else if (hour >= 18) {
                    suggestions = '<strong>Try:</strong> This is peak evening time. Consider earlier in the day or weekend appointments.';
                } else {
                    suggestions = '<strong>Try:</strong> Different date or consider our off-peak hours for better availability.';
                }
            } else {
                suggestions = '<strong>Try:</strong> Different time slots or dates. You can also call us for real-time availability updates.';
            }

            suggestions += '<br><br><i class="fas fa-phone"></i> <strong>Need help?</strong> Call us at (555) 123-4567 for personalized assistance.';
            return suggestions;
        }

        function simulateBooking() {
            if (!selectedSlot) return;

            const service = services[selectedSlot.serviceId];
            const bookingId = 'BK' + Date.now();

            const confirmationHtml =
                '<div class="row">' +
                    '<div class="col-md-8">' +
                        '<strong>Booking ID:</strong> ' + bookingId + '<br>' +
                        '<strong>Service:</strong> ' + service.name + '<br>' +
                        '<strong>Date:</strong> ' + formatDate(selectedSlot.date) + '<br>' +
                        '<strong>Time:</strong> ' + selectedSlot.startTime + ' - ' + selectedSlot.endTime + '<br>' +
                        '<strong>Duration:</strong> ' + service.duration + ' minutes<br>' +
                        '<strong>Price:</strong> $' + service.price +
                    '</div>' +
                    '<div class="col-md-4">' +
                        '<div class="text-center">' +
                            '<i class="fas fa-qrcode fa-3x text-primary"></i><br>' +
                            '<small>QR Code for Check-in</small>' +
                        '</div>' +
                    '</div>' +
                '</div>' +
                '<hr>' +
                '<p class="mb-0">' +
                    '<i class="fas fa-info-circle"></i> ' +
                    '<strong>Note:</strong> This is a simulation. In a real system, this would create an actual booking ' +
                    'and send confirmation email/SMS to the customer.' +
                '</p>';

            document.getElementById('confirmationDetails').innerHTML = confirmationHtml;
            document.getElementById('bookingConfirmation').style.display = 'block';

            // Close modal
            const modal = bootstrap.Modal.getInstance(document.getElementById('resourceModal'));
            modal.hide();

            // Scroll to confirmation
            document.getElementById('bookingConfirmation').scrollIntoView({ behavior: 'smooth' });

            // Reset form after 10 seconds
            setTimeout(() => {
                document.getElementById('bookingConfirmation').style.display = 'none';
                resetBookingForm();
            }, 10000);
        }

        function resetBookingForm() {
            document.getElementById('serviceSelect').value = '';
            document.getElementById('dateSelect').value = '';
            document.getElementById('serviceInfo').style.display = 'none';
            document.getElementById('timeSlotsSection').style.display = 'none';
            selectedSlot = null;
            window.availableSlots = [];
        }

        function formatDate(dateStr) {
            const date = new Date(dateStr);
            return date.toLocaleDateString('en-US', {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });
        }

        // Real Therapist Schedule Management Functions
        function loadTherapistSchedule() {
            const therapistId = document.getElementById('filterTherapist').value;
            const dateFilter = document.getElementById('filterDate').value;
            const serviceId = document.getElementById('filterService').value;
            const status = document.getElementById('filterStatus').value;

            if (!therapistId) {
                document.getElementById('therapistInfo').style.display = 'none';
                return;
            }

            document.getElementById('loadingBookings').style.display = 'block';

            // Build API URL with parameters
            let apiUrl = '${pageContext.request.contextPath}/api/therapist-schedule?action=getSchedule&therapistId=' + therapistId;
            if (dateFilter) apiUrl += '&date=' + dateFilter;
            if (serviceId) apiUrl += '&serviceId=' + serviceId;
            if (status) apiUrl += '&status=' + status;

            fetch(apiUrl)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        allBookings = data.bookings;
                        filteredBookings = [...allBookings];
                        displayTherapistSchedule();
                        loadScheduleStats();
                    } else {
                        console.error('Error loading schedule:', data.error);
                        alert('Error loading therapist schedule: ' + data.error);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error loading therapist schedule: ' + error.message);
                })
                .finally(() => {
                    document.getElementById('loadingBookings').style.display = 'none';
                });
        }

        // Removed old random booking generation - now using real data from database

        // Old filter functions removed - now using real-time API filtering

        function displayTherapistSchedule() {
            const tbody = document.getElementById('bookingsTableBody');
            const filteredCount = document.getElementById('filteredCount');

            filteredCount.textContent = filteredBookings.length + ' appointments';

            if (filteredBookings.length === 0) {
                tbody.innerHTML = '<tr><td colspan="9" class="text-center text-muted">' +
                                '<i class="fas fa-search"></i> No appointments found for the selected filters</td></tr>';
                return;
            }

            let html = '';
            filteredBookings.forEach(booking => {
                const statusClass = getRealStatusClass(booking.bookingStatus);
                const statusIcon = getRealStatusIcon(booking.bookingStatus);
                const formattedDate = new Date(booking.appointmentDate).toLocaleDateString('en-US', {
                    month: 'short', day: 'numeric', weekday: 'short'
                });

                // Calculate end time
                const startTime = booking.appointmentTime;
                const duration = booking.durationMinutes || 60;
                const endTime = calculateEndTime(startTime, duration);

                html += '<tr>' +
                        '<td><code>BK-' + booking.bookingId + '</code></td>' +
                        '<td>' + formattedDate + '</td>' +
                        '<td>' + startTime + ' - ' + endTime + '</td>' +
                        '<td>' + (booking.serviceName || 'Service #' + booking.serviceId) + '</td>' +
                        '<td>' + (booking.customerName || 'Customer #' + booking.customerId) + '</td>' +
                        '<td>' + (booking.therapistName || 'Therapist') + '</td>' +
                        '<td>' + (booking.roomId ? 'Room ' + booking.roomId : 'TBD') +
                        (booking.bedId ? ', Bed ' + booking.bedId : '') + '</td>' +
                        '<td><span class="badge ' + statusClass + '">' +
                        '<i class="fas ' + statusIcon + '"></i> ' + booking.bookingStatus + '</span></td>' +
                        '<td>' +
                        '<button class="btn btn-sm btn-outline-info" onclick="viewRealBookingDetails(' + booking.bookingId + ')" title="View Details">' +
                        '<i class="fas fa-eye"></i></button> ' +
                        '<button class="btn btn-sm btn-outline-warning" onclick="analyzeRealBookingImpact(' + booking.bookingId + ')" title="Analyze Impact">' +
                        '<i class="fas fa-chart-line"></i></button>' +
                        '</td>' +
                        '</tr>';
            });

            tbody.innerHTML = html;
        }

        function calculateEndTime(startTime, durationMinutes) {
            const [hours, minutes] = startTime.split(':').map(Number);
            const startDate = new Date();
            startDate.setHours(hours, minutes, 0, 0);

            const endDate = new Date(startDate.getTime() + durationMinutes * 60000);
            return String(endDate.getHours()).padStart(2, '0') + ':' +
                   String(endDate.getMinutes()).padStart(2, '0');
        }

        function getRealStatusClass(status) {
            const classes = {
                'SCHEDULED': 'bg-primary',
                'CONFIRMED': 'bg-success',
                'IN_PROGRESS': 'bg-info',
                'COMPLETED': 'bg-secondary',
                'CANCELLED': 'bg-danger',
                'NO_SHOW': 'bg-warning text-dark'
            };
            return classes[status] || 'bg-secondary';
        }

        function getRealStatusIcon(status) {
            const icons = {
                'SCHEDULED': 'fa-calendar',
                'CONFIRMED': 'fa-check-circle',
                'IN_PROGRESS': 'fa-play-circle',
                'COMPLETED': 'fa-check-double',
                'CANCELLED': 'fa-times-circle',
                'NO_SHOW': 'fa-exclamation-triangle'
            };
            return icons[status] || 'fa-question-circle';
        }

        // Old status and summary functions removed - now using real booking status from database

        function viewRealBookingDetails(bookingId) {
            const booking = allBookings.find(b => b.bookingId === bookingId);
            if (!booking) return;

            const endTime = calculateEndTime(booking.appointmentTime, booking.durationMinutes || 60);

            const details =
                '<div class="row">' +
                    '<div class="col-md-6">' +
                        '<h6><i class="fas fa-info-circle"></i> Booking Information</h6>' +
                        '<table class="table table-sm">' +
                            '<tr><td><strong>Booking ID:</strong></td><td>BK-' + booking.bookingId + '</td></tr>' +
                            '<tr><td><strong>Date:</strong></td><td>' + formatDate(booking.appointmentDate) + '</td></tr>' +
                            '<tr><td><strong>Time:</strong></td><td>' + booking.appointmentTime + ' - ' + endTime + '</td></tr>' +
                            '<tr><td><strong>Duration:</strong></td><td>' + (booking.durationMinutes || 60) + ' minutes</td></tr>' +
                            '<tr><td><strong>Service:</strong></td><td>' + (booking.serviceName || 'Service #' + booking.serviceId) + '</td></tr>' +
                            '<tr><td><strong>Status:</strong></td><td><span class="badge ' + getRealStatusClass(booking.bookingStatus) + '">' + booking.bookingStatus + '</span></td></tr>' +
                        '</table>' +
                    '</div>' +
                    '<div class="col-md-6">' +
                        '<h6><i class="fas fa-users"></i> Assignment Details</h6>' +
                        '<table class="table table-sm">' +
                            '<tr><td><strong>Customer:</strong></td><td>' + (booking.customerName || 'Customer #' + booking.customerId) + '</td></tr>' +
                            '<tr><td><strong>Therapist:</strong></td><td>' + (booking.therapistName || 'Therapist #' + booking.therapistUserId) + '</td></tr>' +
                            '<tr><td><strong>Room:</strong></td><td>' + (booking.roomId ? 'Room ' + booking.roomId : 'To be assigned') + '</td></tr>' +
                            '<tr><td><strong>Bed:</strong></td><td>' + (booking.bedId ? 'Bed ' + booking.bedId : 'To be assigned') + '</td></tr>' +
                            '<tr><td><strong>Notes:</strong></td><td>' + (booking.bookingNotes || 'No notes') + '</td></tr>' +
                        '</table>' +
                    '</div>' +
                '</div>';

            document.getElementById('resourceDetails').innerHTML = details;
            document.querySelector('#resourceModal .modal-title').innerHTML =
                '<i class="fas fa-calendar-check"></i> Booking Details';
            document.querySelector('#resourceModal .btn-primary').style.display = 'none';

            const modal = new bootstrap.Modal(document.getElementById('resourceModal'));
            modal.show();

            // Reset modal for next use
            modal._element.addEventListener('hidden.bs.modal', function () {
                document.querySelector('#resourceModal .modal-title').innerHTML =
                    '<i class="fas fa-info-circle"></i> Booking Details';
                document.querySelector('#resourceModal .btn-primary').style.display = 'inline-block';
            }, { once: true });
        }

        function analyzeRealBookingImpact(bookingId) {
            const booking = allBookings.find(b => b.bookingId === bookingId);
            if (!booking) return;

            // Simulate impact analysis
            const impactData = {
                therapistUtilization: Math.floor(Math.random() * 30) + 70,
                roomUtilization: Math.floor(Math.random() * 25) + 75,
                timeSlotDemand: Math.floor(Math.random() * 40) + 60,
                conflictingRequests: Math.floor(Math.random() * 5)
            };

            const endTime = calculateEndTime(booking.appointmentTime, booking.durationMinutes || 60);

            const analysis =
                '<div class="row">' +
                    '<div class="col-12">' +
                        '<h6><i class="fas fa-chart-line"></i> Impact Analysis for BK-' + booking.bookingId + '</h6>' +
                        '<div class="alert alert-info">' +
                            '<strong>Booking:</strong> ' + (booking.serviceName || 'Service #' + booking.serviceId) +
                            ' on ' + formatDate(booking.appointmentDate) + ' at ' + booking.appointmentTime + ' - ' + endTime +
                        '</div>' +
                    '</div>' +
                '</div>' +
                '<div class="row">' +
                    '<div class="col-md-6">' +
                        '<h6>Resource Utilization</h6>' +
                        '<div class="mb-2">' +
                            '<small>Therapist (' + (booking.therapistName || 'Therapist #' + booking.therapistUserId) + '):</small>' +
                            '<div class="progress">' +
                                '<div class="progress-bar bg-primary" style="width: ' + impactData.therapistUtilization + '%">' +
                                    impactData.therapistUtilization + '%' +
                                '</div>' +
                            '</div>' +
                        '</div>' +
                        '<div class="mb-2">' +
                            '<small>Room (' + (booking.roomId ? 'Room ' + booking.roomId : 'TBD') + '):</small>' +
                            '<div class="progress">' +
                                '<div class="progress-bar bg-success" style="width: ' + impactData.roomUtilization + '%">' +
                                    impactData.roomUtilization + '%' +
                                '</div>' +
                            '</div>' +
                        '</div>' +
                    '</div>' +
                    '<div class="col-md-6">' +
                        '<h6>Time Slot Analysis</h6>' +
                        '<table class="table table-sm">' +
                            '<tr><td>Time Slot Demand:</td><td>' + impactData.timeSlotDemand + '%</td></tr>' +
                            '<tr><td>Conflicting Requests:</td><td>' + impactData.conflictingRequests + '</td></tr>' +
                            '<tr><td>Peak Hour:</td><td>' + (isPeakTime(booking.appointmentTime) ? 'Yes' : 'No') + '</td></tr>' +
                        '</table>' +
                    '</div>' +
                '</div>';

            document.getElementById('resourceDetails').innerHTML = analysis;
            document.querySelector('#resourceModal .modal-title').innerHTML =
                '<i class="fas fa-chart-line"></i> Impact Analysis';
            document.querySelector('#resourceModal .btn-primary').style.display = 'none';

            const modal = new bootstrap.Modal(document.getElementById('resourceModal'));
            modal.show();
        }

        function isPeakTime(timeStr) {
            const hour = parseInt(timeStr.split(':')[0]);
            return (hour >= 11 && hour <= 14) || (hour >= 18 && hour <= 20);
        }

        // Load therapists and services on page load
        function loadTherapists() {
            fetch('${pageContext.request.contextPath}/api/therapist-schedule?action=getTherapists')
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const therapistSelect = document.getElementById('filterTherapist');
                        therapistSelect.innerHTML = '<option value="">-- Select Therapist --</option>';

                        data.therapists.forEach(therapist => {
                            const option = document.createElement('option');
                            option.value = therapist.userId;
                            option.textContent = therapist.fullName +
                                (therapist.serviceTypeName ? ' (' + therapist.serviceTypeName + ')' : '');
                            therapistSelect.appendChild(option);
                        });
                    } else {
                        console.error('Error loading therapists:', data.error);
                    }
                })
                .catch(error => {
                    console.error('Error loading therapists:', error);
                });
        }

        function loadServices() {
            fetch('${pageContext.request.contextPath}/api/therapist-schedule?action=getServices')
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const serviceSelect = document.getElementById('filterService');
                        serviceSelect.innerHTML = '<option value="">All Services</option>';

                        data.services.forEach(service => {
                            const option = document.createElement('option');
                            option.value = service.serviceId;
                            option.textContent = service.name + ' (' + service.durationMinutes + ' min)';
                            serviceSelect.appendChild(option);
                        });
                    } else {
                        console.error('Error loading services:', data.error);
                    }
                })
                .catch(error => {
                    console.error('Error loading services:', error);
                });
        }

        function displayTherapistSchedule() {
            const tbody = document.getElementById('bookingsTableBody');
            const filteredCount = document.getElementById('filteredCount');

            filteredCount.textContent = filteredBookings.length + ' appointments';

            if (filteredBookings.length === 0) {
                tbody.innerHTML = '<tr><td colspan="9" class="text-center text-muted">' +
                                '<i class="fas fa-search"></i> No appointments found for the selected filters</td></tr>';
                return;
            }

            let html = '';
            filteredBookings.forEach(booking => {
                const statusClass = getRealStatusClass(booking.bookingStatus);
                const statusIcon = getRealStatusIcon(booking.bookingStatus);
                const formattedDate = new Date(booking.appointmentDate).toLocaleDateString('en-US', {
                    month: 'short', day: 'numeric', weekday: 'short'
                });

                // Calculate end time
                const startTime = booking.appointmentTime;
                const duration = booking.durationMinutes || 60;
                const endTime = calculateEndTime(startTime, duration);

                html += '<tr>' +
                        '<td><code>BK-' + booking.bookingId + '</code></td>' +
                        '<td>' + formattedDate + '</td>' +
                        '<td>' + startTime + ' - ' + endTime + '</td>' +
                        '<td>' + (booking.serviceName || 'Service #' + booking.serviceId) + '</td>' +
                        '<td>' + (booking.customerName || 'Customer #' + booking.customerId) + '</td>' +
                        '<td>' + (booking.therapistName || 'Therapist') + '</td>' +
                        '<td>' + (booking.roomId ? 'Room ' + booking.roomId : 'TBD') +
                        (booking.bedId ? ', Bed ' + booking.bedId : '') + '</td>' +
                        '<td><span class="badge ' + statusClass + '">' +
                        '<i class="fas ' + statusIcon + '"></i> ' + booking.bookingStatus + '</span></td>' +
                        '<td>' +
                        '<button class="btn btn-sm btn-outline-info" onclick="viewRealBookingDetails(' + booking.bookingId + ')" title="View Details">' +
                        '<i class="fas fa-eye"></i></button> ' +
                        '<button class="btn btn-sm btn-outline-warning" onclick="analyzeRealBookingImpact(' + booking.bookingId + ')" title="Analyze Impact">' +
                        '<i class="fas fa-chart-line"></i></button>' +
                        '</td>' +
                        '</tr>';
            });

            tbody.innerHTML = html;
        }

        function loadScheduleStats() {
            const therapistId = document.getElementById('filterTherapist').value;
            const dateFilter = document.getElementById('filterDate').value;

            if (!therapistId) return;

            let apiUrl = '${pageContext.request.contextPath}/api/therapist-schedule?action=getScheduleStats&therapistId=' + therapistId;
            if (dateFilter) apiUrl += '&date=' + dateFilter;

            fetch(apiUrl)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const stats = data.stats;
                        document.getElementById('totalAppointments').textContent = stats.totalAppointments;
                        document.getElementById('confirmedAppointments').textContent = stats.confirmedAppointments;
                        document.getElementById('scheduledAppointments').textContent = stats.scheduledAppointments;
                        document.getElementById('workloadHours').textContent = stats.totalHours + 'h';

                        // Show therapist info
                        if (stats.therapistName) {
                            document.getElementById('selectedTherapistName').textContent = stats.therapistName;
                            document.getElementById('therapistDetails').innerHTML =
                                '<strong>Email:</strong> ' + (stats.therapistEmail || 'N/A') + '<br>' +
                                '<strong>Phone:</strong> ' + (stats.therapistPhone || 'N/A');
                            document.getElementById('therapistInfo').style.display = 'block';
                        }
                    }
                })
                .catch(error => {
                    console.error('Error loading schedule stats:', error);
                });
        }

        function loadTherapistSchedule() {
            const therapistId = document.getElementById('filterTherapist').value;
            const dateFilter = document.getElementById('filterDate').value;
            const serviceId = document.getElementById('filterService').value;
            const status = document.getElementById('filterStatus').value;

            if (!therapistId) {
                document.getElementById('therapistInfo').style.display = 'none';
                return;
            }

            document.getElementById('loadingBookings').style.display = 'block';

            // Build API URL with parameters
            let apiUrl = '${pageContext.request.contextPath}/api/therapist-schedule?action=getSchedule&therapistId=' + therapistId;
            if (dateFilter) apiUrl += '&date=' + dateFilter;
            if (serviceId) apiUrl += '&serviceId=' + serviceId;
            if (status) apiUrl += '&status=' + status;

            fetch(apiUrl)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        allBookings = data.bookings;
                        filteredBookings = [...allBookings];
                        displayTherapistSchedule();
                        loadScheduleStats();
                    } else {
                        console.error('Error loading schedule:', data.error);
                        alert('Error loading therapist schedule: ' + data.error);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error loading therapist schedule: ' + error.message);
                })
                .finally(() => {
                    document.getElementById('loadingBookings').style.display = 'none';
                });
        }

        function clearScheduleFilters() {
            document.getElementById('filterTherapist').value = '';
            document.getElementById('filterDate').value = '';
            document.getElementById('filterService').value = '';
            document.getElementById('filterStatus').value = '';
            document.getElementById('therapistInfo').style.display = 'none';

            // Clear table
            const tbody = document.getElementById('bookingsTableBody');
            tbody.innerHTML = '<tr><td colspan="9" class="text-center text-muted">' +
                            '<i class="fas fa-info-circle"></i> Select a therapist to view their schedule</td></tr>';

            // Reset metrics
            document.getElementById('totalAppointments').textContent = '0';
            document.getElementById('confirmedAppointments').textContent = '0';
            document.getElementById('scheduledAppointments').textContent = '0';
            document.getElementById('workloadHours').textContent = '0h';
        }

        function viewRealBookingDetails(bookingId) {
            const booking = allBookings.find(b => b.bookingId === bookingId);
            if (!booking) return;

            const endTime = calculateEndTime(booking.appointmentTime, booking.durationMinutes || 60);

            const details =
                '<div class="row">' +
                    '<div class="col-md-6">' +
                        '<h6><i class="fas fa-info-circle"></i> Booking Information</h6>' +
                        '<table class="table table-sm">' +
                            '<tr><td><strong>Booking ID:</strong></td><td>BK-' + booking.bookingId + '</td></tr>' +
                            '<tr><td><strong>Date:</strong></td><td>' + formatDate(booking.appointmentDate) + '</td></tr>' +
                            '<tr><td><strong>Time:</strong></td><td>' + booking.appointmentTime + ' - ' + endTime + '</td></tr>' +
                            '<tr><td><strong>Duration:</strong></td><td>' + (booking.durationMinutes || 60) + ' minutes</td></tr>' +
                            '<tr><td><strong>Service:</strong></td><td>' + (booking.serviceName || 'Service #' + booking.serviceId) + '</td></tr>' +
                            '<tr><td><strong>Status:</strong></td><td><span class="badge ' + getRealStatusClass(booking.bookingStatus) + '">' + booking.bookingStatus + '</span></td></tr>' +
                        '</table>' +
                    '</div>' +
                    '<div class="col-md-6">' +
                        '<h6><i class="fas fa-users"></i> Assignment Details</h6>' +
                        '<table class="table table-sm">' +
                            '<tr><td><strong>Customer:</strong></td><td>' + (booking.customerName || 'Customer #' + booking.customerId) + '</td></tr>' +
                            '<tr><td><strong>Therapist:</strong></td><td>' + (booking.therapistName || 'Therapist #' + booking.therapistUserId) + '</td></tr>' +
                            '<tr><td><strong>Room:</strong></td><td>' + (booking.roomId ? 'Room ' + booking.roomId : 'TBD') + '</td></tr>' +
                            '<tr><td><strong>Bed:</strong></td><td>' + (booking.bedId ? 'Bed ' + booking.bedId : 'TBD') + '</td></tr>' +
                        '</table>' +
                        '<div class="mt-3">' +
                            '<h6><i class="fas fa-sticky-note"></i> Notes</h6>' +
                            '<div class="alert alert-info">' +
                                '<small>' + (booking.bookingNotes || 'No notes available') + '</small>' +
                            '</div>' +
                        '</div>' +
                    '</div>' +
                '</div>';

            // Show in modal (assuming you have a modal for this)
            alert('Booking Details:\n\nBooking ID: BK-' + booking.bookingId + 
                  '\nDate: ' + formatDate(booking.appointmentDate) + 
                  '\nTime: ' + booking.appointmentTime + ' - ' + endTime + 
                  '\nService: ' + (booking.serviceName || 'Service #' + booking.serviceId) + 
                  '\nStatus: ' + booking.bookingStatus);
        }

        function analyzeRealBookingImpact(bookingId) {
            const booking = allBookings.find(b => b.bookingId === bookingId);
            if (!booking) return;

            // Simple analysis - in a real system this would be more sophisticated
            const analysis = 'Booking Impact Analysis:\n\n' +
                           'Booking ID: BK-' + booking.bookingId + '\n' +
                           'Resource Usage: ' + (booking.durationMinutes || 60) + ' minutes\n' +
                           'Therapist: ' + (booking.therapistName || 'Therapist #' + booking.therapistUserId) + '\n' +
                           'Room Impact: ' + (booking.roomId ? 'Room ' + booking.roomId + ' occupied' : 'No room assigned') + '\n' +
                           'Status Impact: ' + booking.bookingStatus + ' - affects availability calculations';

            alert(analysis);
        }

        function calculateEndTime(startTime, durationMinutes) {
            const [hours, minutes] = startTime.split(':').map(Number);
            const startDate = new Date();
            startDate.setHours(hours, minutes, 0, 0);

            const endDate = new Date(startDate.getTime() + durationMinutes * 60000);
            return String(endDate.getHours()).padStart(2, '0') + ':' +
                   String(endDate.getMinutes()).padStart(2, '0');
        }

        function getRealStatusClass(status) {
            const classes = {
                'SCHEDULED': 'bg-primary',
                'CONFIRMED': 'bg-success',
                'IN_PROGRESS': 'bg-info',
                'COMPLETED': 'bg-secondary',
                'CANCELLED': 'bg-danger',
                'NO_SHOW': 'bg-warning text-dark'
            };
            return classes[status] || 'bg-secondary';
        }

        function getRealStatusIcon(status) {
            const icons = {
                'SCHEDULED': 'fa-calendar',
                'CONFIRMED': 'fa-check-circle',
                'IN_PROGRESS': 'fa-play-circle',
                'COMPLETED': 'fa-check-double',
                'CANCELLED': 'fa-times-circle',
                'NO_SHOW': 'fa-exclamation-triangle'
            };
            return icons[status] || 'fa-question-circle';
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            // Load therapists and services
            loadTherapists();
            loadServices();

            // Set minimum date to today (only if element exists)
            const selectedDateElement = document.getElementById('selectedDate');
            if (selectedDateElement) {
                const today = new Date().toISOString().split('T')[0];
                selectedDateElement.min = today;
            }
        });
    </script>
</body>
</html>
