<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.time.*, java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Booking System - CSP Solver Debug</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        .test-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }
        .section-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            padding: 20px;
        }
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 0;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .test-button {
            margin: 5px;
            min-width: 180px;
        }
        .result-card {
            margin: 10px 0;
            border-left: 4px solid #007bff;
            background: #f8f9fa;
            padding: 15px;
            border-radius: 0 4px 4px 0;
        }
        .result-success { border-left-color: #28a745; background: #d4edda; }
        .result-error { border-left-color: #dc3545; background: #f8d7da; }
        .result-warning { border-left-color: #ffc107; background: #fff3cd; }
        .time-slot {
            display: inline-block;
            margin: 3px;
            padding: 6px 10px;
            border-radius: 4px;
            font-size: 11px;
            min-width: 100px;
            text-align: center;
        }
        .slot-available { background: #d4edda; border: 1px solid #c3e6cb; }
        .slot-unavailable { background: #f8d7da; border: 1px solid #f5c6cb; }
        .slot-limited { background: #fff3cd; border: 1px solid #ffeaa7; }
        .performance-chart {
            max-height: 300px;
            overflow-y: auto;
        }
        .loading-spinner {
            display: none;
            text-align: center;
            padding: 20px;
        }
        .service-details {
            background: #e3f2fd;
            border: 1px solid #2196f3;
            border-radius: 6px;
            padding: 10px;
            margin: 10px 0;
        }
        .analysis-badge {
            font-size: 12px;
            padding: 4px 8px;
            border-radius: 12px;
        }
        .status-healthy { background: #d4edda; color: #155724; }
        .status-warning { background: #fff3cd; color: #856404; }
        .status-error { background: #f8d7da; color: #721c24; }
    </style>
</head>
<body class="bg-light">
    <div class="test-container">
        <!-- Header -->
        <div class="hero-section text-center">
            <h1><i class="fas fa-flask"></i> Test Booking System</h1>
            <p class="lead">Comprehensive CSP Solver & Availability Testing Tool</p>
            <p class="mb-0">Debug time slot generation, constraint satisfaction, and booking conflicts</p>
        </div>

        <!-- Configuration Section -->
        <div class="section-card">
            <h3><i class="fas fa-cog"></i> Test Configuration</h3>
            <!-- First Row: Service, Therapist, Date -->
            <div class="row">
                <div class="col-md-4">
                    <label for="serviceSelect" class="form-label">Select Service:</label>
                    <select id="serviceSelect" class="form-select" onchange="onServiceChange()">
                        <option value="">-- Loading Services --</option>
                    </select>
                    <div id="serviceDetails" class="service-details" style="display: none;">
                        <strong>Service:</strong> <span id="serviceName"></span><br>
                        <strong>Duration:</strong> <span id="serviceDuration"></span> minutes<br>
                        <strong>Price:</strong> <span id="servicePrice"></span> VND<br>
                        <strong>Service Type ID:</strong> <span id="serviceTypeId"></span><br>
                        <strong>Service Type:</strong> <span id="serviceTypeName"></span>
                    </div>
                </div>
                <div class="col-md-4">
                    <label for="therapistSelect" class="form-label">Qualified Therapists:</label>
                    <select id="therapistSelect" class="form-select" onchange="onTherapistChange()">
                        <option value="">-- Select Service First --</option>
                    </select>
                    <div id="therapistDetails" class="service-details" style="display: none;">
                        <strong>Therapist:</strong> <span id="therapistName"></span><br>
                        <strong>Experience:</strong> <span id="therapistExperience"></span> years<br>
                        <strong>Service Type ID:</strong> <span id="therapistServiceTypeId"></span><br>
                        <strong>Service Type:</strong> <span id="therapistServiceType"></span><br>
                        <strong>Status:</strong> <span id="therapistStatus"></span>
                    </div>
                </div>
                <div class="col-md-4">
                    <label for="testDate" class="form-label">Test Date:</label>
                    <input type="date" id="testDate" class="form-control" onchange="onDateChange()">
                    <small class="form-text text-muted">Select date to test booking availability</small>
                </div>
            </div>

            <!-- Second Row: Room, Bed, Customer -->
            <div class="row mt-3">
                <div class="col-md-4">
                    <label for="roomSelect" class="form-label">Select Room:</label>
                    <select id="roomSelect" class="form-select" onchange="onRoomChange()">
                        <option value="">-- Loading Rooms --</option>
                    </select>
                    <div id="roomDetails" class="service-details" style="display: none;">
                        <strong>Room:</strong> <span id="roomName"></span><br>
                        <strong>Room ID:</strong> <span id="roomId"></span><br>
                        <strong>Capacity:</strong> <span id="roomCapacity"></span> people<br>
                        <strong>Status:</strong> <span id="roomStatus"></span>
                    </div>
                </div>
                <div class="col-md-4">
                    <label for="bedSelect" class="form-label">Select Bed:</label>
                    <select id="bedSelect" class="form-select" onchange="onBedChange()">
                        <option value="">-- Select Room First --</option>
                    </select>
                    <div id="bedDetails" class="service-details" style="display: none;">
                        <strong>Bed:</strong> <span id="bedName"></span><br>
                        <strong>Bed ID:</strong> <span id="bedId"></span><br>
                        <strong>Room:</strong> <span id="bedRoomName"></span><br>
                        <strong>Status:</strong> <span id="bedStatus"></span>
                    </div>
                </div>
                <div class="col-md-4">
                    <label for="customerSelect" class="form-label">Customer:</label>
                    <select id="customerSelect" class="form-select">
                        <option value="">-- Loading Customers --</option>
                    </select>
                    <small class="form-text text-muted">Select customer for testing</small>
                </div>
            </div>
        </div>

        <!-- Test Actions Section -->
        <div class="section-card">
            <h3><i class="fas fa-play"></i> CSP Solver Tests</h3>
            <div class="row">
                <div class="col-md-6">
                    <h5>Core Algorithm Tests</h5>
                    <button id="testCSP" class="btn btn-primary test-button" onclick="testCSPSolver()">
                        <i class="fas fa-brain"></i> Test CSP Solver
                    </button>
                    <button id="testAvailability" class="btn btn-success test-button" onclick="testAvailabilityService()">
                        <i class="fas fa-clock"></i> Test Availability Service
                    </button>
                    <button id="testTimeGeneration" class="btn btn-info test-button" onclick="testTimeGeneration()">
                        <i class="fas fa-calendar-alt"></i> Test Time Generation
                    </button>
                </div>
                <div class="col-md-6">
                    <h5>Advanced Tests</h5>
                    <button id="testConflicts" class="btn btn-warning test-button" onclick="testConflicts()">
                        <i class="fas fa-exclamation-triangle"></i> Simulate Conflicts
                    </button>
                    <button id="testPerformance" class="btn btn-secondary test-button" onclick="testPerformance()">
                        <i class="fas fa-tachometer-alt"></i> Performance Test
                    </button>
                    <button id="compareAll" class="btn btn-dark test-button" onclick="compareAllTests()">
                        <i class="fas fa-balance-scale"></i> Compare All
                    </button>
                </div>
            </div>
            
            <div class="row mt-3">
                <div class="col-12">
                    <button id="loadBookings" class="btn btn-outline-primary test-button" onclick="loadExistingBookings()">
                        <i class="fas fa-list"></i> Load Existing Bookings
                    </button>
                    <button id="clearResults" class="btn btn-outline-danger test-button" onclick="clearAllResults()">
                        <i class="fas fa-trash"></i> Clear Results
                    </button>
                </div>
            </div>
            
            <div class="loading-spinner" id="loadingSpinner">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Running tests...</span>
                </div>
                <p class="mt-2">Processing test request...</p>
            </div>
        </div>

        <!-- Quick Analysis Section -->
        <div class="section-card">
            <h3><i class="fas fa-chart-line"></i> Quick Analysis</h3>
            <div class="row">
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title">CSP Solver</h5>
                            <p class="card-text" id="cspStatus">
                                <span class="analysis-badge status-warning">Not Tested</span>
                            </p>
                            <small id="cspDetails" class="text-muted">Click test to analyze</small>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title">Availability Service</h5>
                            <p class="card-text" id="availabilityStatus">
                                <span class="analysis-badge status-warning">Not Tested</span>
                            </p>
                            <small id="availabilityDetails" class="text-muted">Click test to analyze</small>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title">Time Generation</h5>
                            <p class="card-text" id="timeGenStatus">
                                <span class="analysis-badge status-warning">Not Tested</span>
                            </p>
                            <small id="timeGenDetails" class="text-muted">Click test to analyze</small>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title">Overall Health</h5>
                            <p class="card-text" id="overallStatus">
                                <span class="analysis-badge status-warning">Pending</span>
                            </p>
                            <small id="overallDetails" class="text-muted">Run tests to evaluate</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Results Section -->
        <div class="section-card">
            <h3><i class="fas fa-chart-bar"></i> Test Results</h3>
            <div id="resultsContainer">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i> Configure test parameters above and run tests to see results here.
                </div>
            </div>
        </div>

        <!-- Performance Metrics Section -->
        <div class="section-card">
            <h3><i class="fas fa-stopwatch"></i> Performance Metrics</h3>
            <div class="row">
                <div class="col-md-6">
                    <h5>Response Times</h5>
                    <div id="performanceChart" class="performance-chart">
                        <p class="text-muted">Run performance tests to see metrics</p>
                    </div>
                </div>
                <div class="col-md-6">
                    <h5>System Information</h5>
                    <div id="systemInfo">
                        <p><strong>Context Path:</strong> <%= request.getContextPath() %></p>
                        <p><strong>Session ID:</strong> <%= session.getId() %></p>
                        <p><strong>Server Time:</strong> <span id="serverTime"></span></p>
                        <p><strong>Test Controller:</strong> <span id="controllerStatus" class="text-warning">Checking...</span></p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- External JavaScript -->
    <script src="<%= request.getContextPath() %>/js/test-booking.js"></script>
    
    <script>
        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            updateServerTime();
            setInterval(updateServerTime, 1000);
            
            // Set context path for external JS
            window.contextPath = '<%= request.getContextPath() %>';
            window.sessionId = '<%= session.getId() %>';
            
            // Set default date to tomorrow
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            document.getElementById('testDate').value = tomorrow.toISOString().split('T')[0];
        });
        
        function updateServerTime() {
            document.getElementById('serverTime').textContent = new Date().toLocaleString();
        }
    </script>
</body>
</html>
