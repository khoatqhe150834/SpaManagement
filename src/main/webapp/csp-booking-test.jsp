<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
            margin-bottom: 10px;
        }
        .unavailable-slot { 
            border-left: 4px solid #dc3545; 
            background-color: #f8f9fa;
        }
        .loading { display: none; }
        .results-section { margin-top: 20px; }
        pre { background: #f8f9fa; padding: 15px; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h2><i class="fas fa-calendar-check"></i> CSP Booking System - Production Test</h2>
                        <p class="mb-0">Real-time testing of the Constraint Satisfaction Problem booking system</p>
                    </div>
                    <div class="card-body">
                        
                        <!-- System Status Section -->
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <div class="card">
                                    <div class="card-header">
                                        <h5><i class="fas fa-heartbeat"></i> System Health</h5>
                                    </div>
                                    <div class="card-body">
                                        <button class="btn btn-outline-primary" onclick="checkSystemHealth()">
                                            <i class="fas fa-sync-alt"></i> Check Health
                                        </button>
                                        <div id="healthStatus" class="mt-3"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card">
                                    <div class="card-header">
                                        <h5><i class="fas fa-info-circle"></i> System Info</h5>
                                    </div>
                                    <div class="card-body">
                                        <button class="btn btn-outline-info" onclick="getSystemStatus()">
                                            <i class="fas fa-info"></i> Get Status
                                        </button>
                                        <div id="systemInfo" class="mt-3"></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Booking Test Section -->
                        <div class="card">
                            <div class="card-header">
                                <h5><i class="fas fa-search"></i> Booking Availability Test</h5>
                            </div>
                            <div class="card-body">
                                <form id="bookingTestForm">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <label for="serviceId" class="form-label">Service Type</label>
                                            <select class="form-select" id="serviceId" required>
                                                <option value="1">Swedish Massage (60 min)</option>
                                                <option value="2">Deep Tissue Massage (90 min)</option>
                                                <option value="3">Classic Facial (60 min)</option>
                                                <option value="4">Anti-Aging Facial (75 min)</option>
                                                <option value="5">Basic Manicure (30 min)</option>
                                                <option value="6">Gel Manicure (45 min)</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <label for="maxResults" class="form-label">Max Results</label>
                                            <select class="form-select" id="maxResults">
                                                <option value="5">5 slots</option>
                                                <option value="10" selected>10 slots</option>
                                                <option value="20">20 slots</option>
                                                <option value="50">50 slots</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label">Test Type</label><br>
                                            <div class="btn-group" role="group">
                                                <button type="button" class="btn btn-outline-primary" onclick="findAvailableSlots(false)">
                                                    <i class="fas fa-search"></i> Quick Search
                                                </button>
                                                <button type="button" class="btn btn-outline-info" onclick="findAvailableSlots(true)">
                                                    <i class="fas fa-search-plus"></i> Detailed Search
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </form>

                                <div class="loading mt-3">
                                    <div class="text-center">
                                        <div class="spinner-border text-primary" role="status">
                                            <span class="visually-hidden">Loading...</span>
                                        </div>
                                        <p class="mt-2">Searching for available slots...</p>
                                    </div>
                                </div>

                                <div id="bookingResults" class="results-section"></div>
                            </div>
                        </div>

                        <!-- Performance Testing Section -->
                        <div class="card mt-4">
                            <div class="card-header">
                                <h5><i class="fas fa-tachometer-alt"></i> Performance Testing</h5>
                            </div>
                            <div class="card-body">
                                <button class="btn btn-warning" onclick="runPerformanceTest()">
                                    <i class="fas fa-stopwatch"></i> Run Performance Test
                                </button>
                                <div id="performanceResults" class="mt-3"></div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/csp-booking-test.js"></script>
</body>
</html>
