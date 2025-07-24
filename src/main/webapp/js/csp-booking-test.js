/**
 * CSP Booking System - Production Test JavaScript
 * Provides interactive testing interface for the CSP booking system
 */

const CSPBookingTest = {
    baseUrl: '/G1_SpaManagement/api/csp-booking',
    
    // Service names mapping
    serviceNames: {
        1: 'Swedish Massage',
        2: 'Deep Tissue Massage', 
        3: 'Classic Facial',
        4: 'Anti-Aging Facial',
        5: 'Basic Manicure',
        6: 'Gel Manicure'
    },

    // Utility functions
    formatTime: function(timeString) {
        return timeString.substring(0, 5); // HH:MM format
    },

    formatDate: function(dateString) {
        const date = new Date(dateString);
        return date.toLocaleDateString('en-US', { 
            weekday: 'short', 
            month: 'short', 
            day: 'numeric' 
        });
    },

    getPerformanceClass: function(responseTime) {
        if (responseTime < 50) return 'performance-excellent';
        if (responseTime < 200) return 'performance-good';
        return 'performance-slow';
    },

    getPerformanceText: function(responseTime) {
        if (responseTime < 50) return 'EXCELLENT';
        if (responseTime < 200) return 'GOOD';
        return 'SLOW';
    },

    showLoading: function(show) {
        const loading = document.querySelector('.loading');
        loading.style.display = show ? 'block' : 'none';
    },

    // API calls
    makeRequest: async function(endpoint, params = {}) {
        const url = new URL(this.baseUrl + endpoint, window.location.origin);
        Object.keys(params).forEach(key => url.searchParams.append(key, params[key]));
        
        const response = await fetch(url);
        return await response.json();
    }
};

// System Health Check
async function checkSystemHealth() {
    const statusDiv = document.getElementById('healthStatus');
    statusDiv.innerHTML = '<div class="spinner-border spinner-border-sm" role="status"></div> Checking...';
    
    try {
        const health = await CSPBookingTest.makeRequest('/health');
        
        const statusClass = health.status === 'healthy' ? 'status-healthy' : 'status-error';
        const icon = health.status === 'healthy' ? 'fa-check-circle' : 'fa-exclamation-triangle';
        
        statusDiv.innerHTML = `
            <div class="${statusClass}">
                <i class="fas ${icon}"></i> <strong>${health.status.toUpperCase()}</strong>
            </div>
            <small class="text-muted">
                Response Time: ${health.responseTimeMs}ms<br>
                ${health.testResult || health.error || ''}
            </small>
        `;
    } catch (error) {
        statusDiv.innerHTML = `
            <div class="status-error">
                <i class="fas fa-exclamation-triangle"></i> <strong>ERROR</strong>
            </div>
            <small class="text-muted">Failed to connect: ${error.message}</small>
        `;
    }
}

// System Status
async function getSystemStatus() {
    const infoDiv = document.getElementById('systemInfo');
    infoDiv.innerHTML = '<div class="spinner-border spinner-border-sm" role="status"></div> Loading...';
    
    try {
        const status = await CSPBookingTest.makeRequest('/');
        
        infoDiv.innerHTML = `
            <div class="status-healthy">
                <i class="fas fa-info-circle"></i> <strong>${status.systemType}</strong>
            </div>
            <small class="text-muted">
                Version: ${status.version}<br>
                Business Hours: ${status.businessHours}<br>
                Time Interval: ${status.timeInterval}<br>
                Buffer Time: ${status.bufferTime}
            </small>
        `;
    } catch (error) {
        infoDiv.innerHTML = `
            <div class="status-error">
                <i class="fas fa-exclamation-triangle"></i> <strong>ERROR</strong>
            </div>
            <small class="text-muted">Failed to load: ${error.message}</small>
        `;
    }
}

// Find Available Slots
async function findAvailableSlots(detailed = false) {
    const serviceId = document.getElementById('serviceId').value;
    const maxResults = document.getElementById('maxResults').value;
    const resultsDiv = document.getElementById('bookingResults');
    
    CSPBookingTest.showLoading(true);
    resultsDiv.innerHTML = '';
    
    try {
        const endpoint = detailed ? '/available-slots-detailed' : '/available-slots';
        const result = await CSPBookingTest.makeRequest(endpoint, {
            serviceId: serviceId,
            maxResults: maxResults
        });
        
        if (result.success) {
            displayBookingResults(result, detailed);
        } else {
            resultsDiv.innerHTML = `
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle"></i> ${result.error}
                </div>
            `;
        }
    } catch (error) {
        resultsDiv.innerHTML = `
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle"></i> Error: ${error.message}
            </div>
        `;
    } finally {
        CSPBookingTest.showLoading(false);
    }
}

// Display Booking Results
function displayBookingResults(result, detailed) {
    const resultsDiv = document.getElementById('bookingResults');
    const serviceName = CSPBookingTest.serviceNames[result.serviceId];
    const performanceClass = CSPBookingTest.getPerformanceClass(result.responseTimeMs);
    const performanceText = CSPBookingTest.getPerformanceText(result.responseTimeMs);
    
    let html = `
        <div class="alert alert-success">
            <h6><i class="fas fa-check-circle"></i> Search Complete</h6>
            <div class="row">
                <div class="col-md-3">
                    <strong>Service:</strong> ${serviceName}
                </div>
                <div class="col-md-3">
                    <strong>Found:</strong> ${result.foundSlots} slots
                </div>
                <div class="col-md-3">
                    <strong>Response Time:</strong> 
                    <span class="${performanceClass}">${result.responseTimeMs}ms (${performanceText})</span>
                </div>
                <div class="col-md-3">
                    <strong>Requested:</strong> ${result.maxResults} max
                </div>
            </div>
        </div>
    `;
    
    // Available Slots
    if (result.slots && result.slots.length > 0) {
        html += '<h6><i class="fas fa-calendar-check"></i> Available Slots</h6>';
        result.slots.forEach((slot, index) => {
            html += `
                <div class="card slot-card">
                    <div class="card-body py-2">
                        <div class="row align-items-center">
                            <div class="col-md-2">
                                <strong>#${index + 1}</strong>
                            </div>
                            <div class="col-md-3">
                                <i class="fas fa-calendar"></i> ${CSPBookingTest.formatDate(slot.date)}
                            </div>
                            <div class="col-md-3">
                                <i class="fas fa-clock"></i> ${CSPBookingTest.formatTime(slot.startTime)} - ${CSPBookingTest.formatTime(slot.endTime)}
                            </div>
                            <div class="col-md-2">
                                <i class="fas fa-user"></i> Therapist ${slot.therapistId}
                            </div>
                            <div class="col-md-2">
                                <i class="fas fa-door-open"></i> Room ${slot.roomId}, Bed ${slot.bedId}
                            </div>
                        </div>
                    </div>
                </div>
            `;
        });
    }
    
    // Unavailable Slots (detailed mode only)
    if (detailed && result.unavailableSlots && result.unavailableSlots.length > 0) {
        html += `
            <h6 class="mt-3"><i class="fas fa-calendar-times"></i> Unavailable Slots 
                <small class="text-muted">(${result.unavailableSlots.length} total)</small>
            </h6>
        `;
        
        // Show first 5 unavailable slots
        const slotsToShow = result.unavailableSlots.slice(0, 5);
        slotsToShow.forEach((slot, index) => {
            html += `
                <div class="card slot-card unavailable-slot">
                    <div class="card-body py-2">
                        <div class="row align-items-center">
                            <div class="col-md-2">
                                <small>#${index + 1}</small>
                            </div>
                            <div class="col-md-3">
                                <small><i class="fas fa-calendar"></i> ${CSPBookingTest.formatDate(slot.date)}</small>
                            </div>
                            <div class="col-md-3">
                                <small><i class="fas fa-clock"></i> ${CSPBookingTest.formatTime(slot.startTime)} - ${CSPBookingTest.formatTime(slot.endTime)}</small>
                            </div>
                            <div class="col-md-4">
                                <small><i class="fas fa-info-circle"></i> ${slot.reason}</small>
                            </div>
                        </div>
                    </div>
                </div>
            `;
        });
        
        if (result.unavailableSlots.length > 5) {
            html += `<small class="text-muted">... and ${result.unavailableSlots.length - 5} more unavailable slots</small>`;
        }
    }
    
    resultsDiv.innerHTML = html;
}

// Performance Test
async function runPerformanceTest() {
    const resultsDiv = document.getElementById('performanceResults');
    resultsDiv.innerHTML = '<div class="spinner-border spinner-border-sm" role="status"></div> Running performance tests...';
    
    const testCases = [
        { serviceId: 1, maxResults: 5, name: 'Swedish Massage (5 slots)' },
        { serviceId: 3, maxResults: 10, name: 'Classic Facial (10 slots)' },
        { serviceId: 5, maxResults: 20, name: 'Basic Manicure (20 slots)' },
        { serviceId: 1, maxResults: 50, name: 'Swedish Massage (50 slots)' }
    ];
    
    let html = '<h6><i class="fas fa-tachometer-alt"></i> Performance Test Results</h6>';
    let totalTime = 0;
    
    try {
        for (const testCase of testCases) {
            const result = await CSPBookingTest.makeRequest('/available-slots', {
                serviceId: testCase.serviceId,
                maxResults: testCase.maxResults
            });
            
            const performanceClass = CSPBookingTest.getPerformanceClass(result.responseTimeMs);
            const performanceText = CSPBookingTest.getPerformanceText(result.responseTimeMs);
            totalTime += result.responseTimeMs;
            
            html += `
                <div class="card mb-2">
                    <div class="card-body py-2">
                        <div class="row align-items-center">
                            <div class="col-md-6">
                                <strong>${testCase.name}</strong>
                            </div>
                            <div class="col-md-3">
                                Found: ${result.foundSlots} slots
                            </div>
                            <div class="col-md-3">
                                <span class="${performanceClass}">
                                    ${result.responseTimeMs}ms (${performanceText})
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            `;
        }
        
        const avgTime = Math.round(totalTime / testCases.length);
        const avgClass = CSPBookingTest.getPerformanceClass(avgTime);
        const avgText = CSPBookingTest.getPerformanceText(avgTime);
        
        html += `
            <div class="alert alert-info mt-3">
                <strong>Overall Performance:</strong> 
                <span class="${avgClass}">Average ${avgTime}ms (${avgText})</span> | 
                Total: ${totalTime}ms
            </div>
        `;
        
    } catch (error) {
        html += `
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle"></i> Performance test failed: ${error.message}
            </div>
        `;
    }
    
    resultsDiv.innerHTML = html;
}

// Initialize page
document.addEventListener('DOMContentLoaded', function() {
    // Auto-check system health on page load
    checkSystemHealth();
    getSystemStatus();
});
