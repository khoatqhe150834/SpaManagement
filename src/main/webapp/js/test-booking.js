/**
 * Test Booking System JavaScript
 * External JavaScript file for comprehensive CSP solver testing
 */

// Global variables
let currentServiceId = null;
let currentCustomerId = null;
let currentDate = null;
let currentTherapistId = null;
let currentServiceTypeId = null;
let currentRoomId = null;
let currentBedId = null;

// Context path - will be set by JSP or default to /spa
let contextPath = window.contextPath || '/spa';
let testResults = {
    csp: null,
    availability: null,
    timeGeneration: null,
    conflicts: null,
    performance: null
};

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    console.log('Test Booking System initialized');

    // Update context path if set by JSP
    if (window.contextPath) {
        contextPath = window.contextPath;
        console.log('Context path updated from JSP:', contextPath);
    } else {
        console.log('Using default context path:', contextPath);
    }

    // Initialize current date from the date input (set by JSP)
    const dateInput = document.getElementById('testDate');
    if (dateInput && dateInput.value) {
        currentDate = dateInput.value;
        console.log('Initial date set to:', currentDate);
    } else {
        // Fallback: set to tomorrow if not set by JSP
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        currentDate = tomorrow.toISOString().split('T')[0];
        if (dateInput) {
            dateInput.value = currentDate;
        }
        console.log('Fallback date set to:', currentDate);
    }

    checkControllerStatus();
    loadServices();
    loadCustomers();
    loadRooms();
});

/**
 * Check if test controller is accessible
 */
async function checkControllerStatus() {
    try {
        const testUrl = `${contextPath}/test/booking`;
        console.log('Testing controller at URL:', testUrl);

        const response = await fetch(testUrl, {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        });

        console.log('Controller response status:', response.status);
        console.log('Controller response content-type:', response.headers.get('content-type'));

        if (response.ok) {
            const data = await response.json();
            document.getElementById('controllerStatus').innerHTML =
                '<span class="text-success">✓ Online</span>';
            console.log('Test controller status:', data);
        } else {
            document.getElementById('controllerStatus').innerHTML =
                '<span class="text-danger">✗ Error (' + response.status + ')</span>';
            console.error('Controller returned error status:', response.status);
        }
    } catch (error) {
        document.getElementById('controllerStatus').innerHTML =
            '<span class="text-danger">✗ Offline</span>';
        console.error('Controller status check failed:', error);
    }
}

/**
 * Load all active services
 */
async function loadServices() {
    try {
        const servicesUrl = `${contextPath}/test/booking?action=load_services`;
        console.log('Loading services from URL:', servicesUrl);

        const response = await fetch(servicesUrl, {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        });

        console.log('Services response status:', response.status);
        console.log('Services response content-type:', response.headers.get('content-type'));

        if (response.ok) {
            const responseText = await response.text();
            console.log('Services raw response (first 200 chars):', responseText.substring(0, 200));

            try {
                const data = JSON.parse(responseText);
                console.log('Services data parsed successfully:', data);
                populateServiceSelect(data.data || []);
            } catch (parseError) {
                console.error('JSON parse error:', parseError);
                console.error('Response was not valid JSON:', responseText.substring(0, 500));
                showError('Invalid JSON response from services endpoint');
            }
        } else {
            const errorText = await response.text();
            console.error('Failed to load services:', response.status, errorText.substring(0, 200));
            showError(`Failed to load services: ${response.status}`);
        }
    } catch (error) {
        console.error('Network error loading services:', error);
        showError('Network error loading services: ' + error.message);
    }
}

/**
 * Load customers for testing
 */
async function loadCustomers() {
    try {
        const response = await fetch(`${contextPath}/test/booking?action=load_customers`, {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        });
        
        if (response.ok) {
            const data = await response.json();
            populateCustomerSelect(data.data || []);
        } else {
            console.error('Failed to load customers:', response.status);
            // Use default customer if loading fails
            populateCustomerSelect([{userId: 113, fullName: 'Test Customer', phone: '0123456789'}]);
        }
    } catch (error) {
        console.error('Error loading customers:', error);
        // Use default customer if loading fails
        populateCustomerSelect([{userId: 113, fullName: 'Test Customer', phone: '0123456789'}]);
    }
}

/**
 * Populate service dropdown
 */
function populateServiceSelect(services) {
    const select = document.getElementById('serviceSelect');
    select.innerHTML = '<option value="">-- Select a Service --</option>';

    services.forEach(service => {
        const option = document.createElement('option');
        option.value = service.serviceId;
        option.textContent = `${service.name} (${service.durationMinutes} min - ${formatPrice(service.price)} VND)`;
        option.dataset.duration = service.durationMinutes;
        option.dataset.price = service.price;
        option.dataset.name = service.name;

        // Add service type information for qualified therapist matching
        if (service.serviceTypeId && service.serviceTypeId.serviceTypeId) {
            option.dataset.serviceTypeId = service.serviceTypeId.serviceTypeId;
            option.dataset.serviceTypeName = service.serviceTypeId.name;
            console.log(`Service ${service.name}: Service Type ID ${service.serviceTypeId.serviceTypeId} (${service.serviceTypeId.name})`);
        } else {
            option.dataset.serviceTypeId = 'null';
            option.dataset.serviceTypeName = 'Unknown Service Type';
            console.warn(`Service ${service.name}: No service type assigned (serviceTypeId: ${service.serviceTypeId})`);
        }

        select.appendChild(option);
    });

    console.log(`Loaded ${services.length} services with service type information`);
}

/**
 * Populate customer dropdown
 */
function populateCustomerSelect(customers) {
    const select = document.getElementById('customerSelect');
    select.innerHTML = '<option value="">-- Select a Customer --</option>';
    
    customers.forEach(customer => {
        const option = document.createElement('option');
        option.value = customer.userId;
        option.textContent = `${customer.fullName} (${customer.phone || 'No phone'})`;
        select.appendChild(option);
    });
    
    // Select first customer by default
    if (customers.length > 0) {
        select.value = customers[0].userId;
        currentCustomerId = customers[0].userId;
    }
    
    console.log(`Loaded ${customers.length} customers`);
}

/**
 * Handle service selection change
 */
function onServiceChange() {
    const select = document.getElementById('serviceSelect');
    const selectedOption = select.options[select.selectedIndex];

    if (selectedOption.value) {
        currentServiceId = parseInt(selectedOption.value);
        currentServiceTypeId = selectedOption.dataset.serviceTypeId ? parseInt(selectedOption.dataset.serviceTypeId) : null;

        // Update service details display
        document.getElementById('serviceName').textContent = selectedOption.dataset.name;
        document.getElementById('serviceDuration').textContent = selectedOption.dataset.duration;
        document.getElementById('servicePrice').textContent = formatPrice(selectedOption.dataset.price);
        document.getElementById('serviceTypeId').textContent = selectedOption.dataset.serviceTypeId || 'null';
        document.getElementById('serviceTypeName').textContent = selectedOption.dataset.serviceTypeName || 'Unknown Service Type';
        document.getElementById('serviceDetails').style.display = 'block';

        console.log(`Service selected: ${selectedOption.dataset.name} (ID: ${currentServiceId}, Service Type: ${selectedOption.dataset.serviceTypeName})`);

        // Load qualified therapists for this service
        loadQualifiedTherapists(currentServiceId);
    } else {
        currentServiceId = null;
        currentServiceTypeId = null;
        document.getElementById('serviceDetails').style.display = 'none';

        // Clear therapists dropdown
        clearTherapistsDropdown();
        console.log('Service selection cleared');
    }
}

/**
 * Handle date change
 */
function onDateChange() {
    const dateInput = document.getElementById('testDate');
    currentDate = dateInput.value;
    console.log(`Test date changed to: ${currentDate}`);
}

/**
 * Handle therapist selection change
 */
function onTherapistChange() {
    const select = document.getElementById('therapistSelect');
    const selectedOption = select.options[select.selectedIndex];

    if (selectedOption.value) {
        currentTherapistId = parseInt(selectedOption.value);

        // Update therapist details display
        document.getElementById('therapistName').textContent = selectedOption.dataset.name;
        document.getElementById('therapistExperience').textContent = selectedOption.dataset.experience || '0';
        document.getElementById('therapistServiceTypeId').textContent = selectedOption.dataset.serviceTypeId || 'null';
        document.getElementById('therapistServiceType').textContent = selectedOption.dataset.serviceTypeName || 'Unknown';
        document.getElementById('therapistStatus').textContent = selectedOption.dataset.status || 'Unknown';
        document.getElementById('therapistDetails').style.display = 'block';

        console.log(`Therapist selected: ${selectedOption.dataset.name} (ID: ${currentTherapistId}, Service Type: ${selectedOption.dataset.serviceTypeName})`);
    } else {
        currentTherapistId = null;
        document.getElementById('therapistDetails').style.display = 'none';
        console.log('Therapist selection cleared');
    }
}

/**
 * Load qualified therapists for a specific service
 */
async function loadQualifiedTherapists(serviceId) {
    try {
        console.log(`Loading qualified therapists for service ID: ${serviceId}`);

        const response = await fetch(`${contextPath}/test/booking?action=load_qualified_therapists&serviceId=${serviceId}`, {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        });

        console.log('Qualified therapists response status:', response.status);
        console.log('Qualified therapists response content-type:', response.headers.get('content-type'));

        if (response.ok) {
            const responseText = await response.text();
            console.log('Qualified therapists raw response (first 200 chars):', responseText.substring(0, 200));

            try {
                const data = JSON.parse(responseText);
                console.log('Qualified therapists data parsed successfully:', data);
                populateTherapistsDropdown(data);
            } catch (parseError) {
                console.error('JSON parse error:', parseError);
                console.error('Response was not valid JSON:', responseText.substring(0, 500));
                showError('Invalid JSON response from qualified therapists endpoint');
                clearTherapistsDropdown();
            }
        } else {
            const errorText = await response.text();
            console.error('Failed to load qualified therapists:', response.status, errorText.substring(0, 200));
            showError(`Failed to load qualified therapists: ${response.status}`);
            clearTherapistsDropdown();
        }
    } catch (error) {
        console.error('Network error loading qualified therapists:', error);
        showError('Network error loading qualified therapists: ' + error.message);
        clearTherapistsDropdown();
    }
}

/**
 * Populate therapists dropdown with qualified therapists
 */
function populateTherapistsDropdown(data) {
    const select = document.getElementById('therapistSelect');
    select.innerHTML = '<option value="">-- Select a Therapist --</option>';

    if (data.success && data.data && data.data.length > 0) {
        data.data.forEach(therapist => {
            const option = document.createElement('option');
            option.value = therapist.userId;
            option.textContent = `${therapist.fullName} - ${therapist.serviceTypeName} (${therapist.yearsOfExperience} years)`;
            option.dataset.name = therapist.fullName;
            option.dataset.experience = therapist.yearsOfExperience;
            option.dataset.serviceTypeName = therapist.serviceTypeName;
            option.dataset.status = therapist.availabilityStatus;
            option.dataset.serviceTypeId = therapist.serviceTypeId;
            select.appendChild(option);
        });

        console.log(`Populated ${data.data.length} qualified therapists for service type: ${data.serviceTypeName}`);

        // Show service type matching information
        if (data.serviceTypeName) {
            console.log(`✅ Service Type Match: Service "${data.serviceName}" (${data.serviceTypeName}) matched with ${data.count} qualified therapists`);
        }
    } else {
        const option = document.createElement('option');
        option.value = '';
        option.textContent = '-- No Qualified Therapists Found --';
        option.disabled = true;
        select.appendChild(option);

        console.warn(`❌ No qualified therapists found for service: ${data.serviceName} (Service Type: ${data.serviceTypeName})`);
        showError(`No qualified therapists found for service type: ${data.serviceTypeName || 'Unknown'}`);
    }
}

/**
 * Clear therapists dropdown
 */
function clearTherapistsDropdown() {
    const select = document.getElementById('therapistSelect');
    select.innerHTML = '<option value="">-- Select Service First --</option>';

    // Hide therapist details
    document.getElementById('therapistDetails').style.display = 'none';
    currentTherapistId = null;

    console.log('Therapists dropdown cleared');
}

/**
 * Load all available rooms
 */
async function loadRooms() {
    try {
        console.log('Loading rooms...');

        const response = await fetch(`${contextPath}/test/booking?action=load_rooms`, {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        });

        console.log('Rooms response status:', response.status);
        console.log('Rooms response content-type:', response.headers.get('content-type'));

        if (response.ok) {
            const responseText = await response.text();
            console.log('Rooms raw response (first 200 chars):', responseText.substring(0, 200));

            try {
                const data = JSON.parse(responseText);
                console.log('Rooms data parsed successfully:', data);
                populateRoomsDropdown(data);
            } catch (parseError) {
                console.error('JSON parse error:', parseError);
                console.error('Response was not valid JSON:', responseText.substring(0, 500));
                showError('Invalid JSON response from rooms endpoint');
                clearRoomsDropdown();
            }
        } else {
            const errorText = await response.text();
            console.error('Failed to load rooms:', response.status, errorText.substring(0, 200));
            showError(`Failed to load rooms: ${response.status}`);
            clearRoomsDropdown();
        }
    } catch (error) {
        console.error('Network error loading rooms:', error);
        showError('Network error loading rooms: ' + error.message);
        clearRoomsDropdown();
    }
}

/**
 * Populate rooms dropdown
 */
function populateRoomsDropdown(data) {
    const select = document.getElementById('roomSelect');
    select.innerHTML = '<option value="">-- Select a Room --</option>';

    if (data.success && data.data && data.data.length > 0) {
        data.data.forEach(room => {
            const option = document.createElement('option');
            option.value = room.roomId;
            option.textContent = `${room.name} (Capacity: ${room.capacity})`;
            option.dataset.name = room.name;
            option.dataset.capacity = room.capacity;
            option.dataset.description = room.description || '';
            option.dataset.isActive = room.isActive;
            select.appendChild(option);
        });

        console.log(`Populated ${data.data.length} rooms`);
    } else {
        const option = document.createElement('option');
        option.value = '';
        option.textContent = '-- No Rooms Found --';
        option.disabled = true;
        select.appendChild(option);

        console.warn('No rooms found');
        showError('No rooms found in database');
    }
}

/**
 * Clear rooms dropdown
 */
function clearRoomsDropdown() {
    const select = document.getElementById('roomSelect');
    select.innerHTML = '<option value="">-- Loading Rooms --</option>';

    // Hide room details
    document.getElementById('roomDetails').style.display = 'none';
    currentRoomId = null;

    // Clear beds dropdown as well
    clearBedsDropdown();

    console.log('Rooms dropdown cleared');
}

/**
 * Handle room selection change
 */
function onRoomChange() {
    const select = document.getElementById('roomSelect');
    const selectedOption = select.options[select.selectedIndex];

    if (selectedOption.value) {
        currentRoomId = parseInt(selectedOption.value);

        // Update room details display
        document.getElementById('roomName').textContent = selectedOption.dataset.name;
        document.getElementById('roomId').textContent = currentRoomId;
        document.getElementById('roomCapacity').textContent = selectedOption.dataset.capacity || '0';
        document.getElementById('roomStatus').textContent = selectedOption.dataset.isActive === 'true' ? 'Active' : 'Inactive';
        document.getElementById('roomDetails').style.display = 'block';

        console.log(`Room selected: ${selectedOption.dataset.name} (ID: ${currentRoomId})`);

        // Load beds for this room
        loadBeds(currentRoomId);
    } else {
        currentRoomId = null;
        document.getElementById('roomDetails').style.display = 'none';

        // Clear beds dropdown
        clearBedsDropdown();
        console.log('Room selection cleared');
    }
}

/**
 * Load beds for a specific room
 */
async function loadBeds(roomId) {
    try {
        console.log(`Loading beds for room ID: ${roomId}`);

        const response = await fetch(`${contextPath}/test/booking?action=load_beds&roomId=${roomId}`, {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        });

        console.log('Beds response status:', response.status);
        console.log('Beds response content-type:', response.headers.get('content-type'));

        if (response.ok) {
            const responseText = await response.text();
            console.log('Beds raw response (first 200 chars):', responseText.substring(0, 200));

            try {
                const data = JSON.parse(responseText);
                console.log('Beds data parsed successfully:', data);
                populateBedsDropdown(data);
            } catch (parseError) {
                console.error('JSON parse error:', parseError);
                console.error('Response was not valid JSON:', responseText.substring(0, 500));
                showError('Invalid JSON response from beds endpoint');
                clearBedsDropdown();
            }
        } else {
            const errorText = await response.text();
            console.error('Failed to load beds:', response.status, errorText.substring(0, 200));
            showError(`Failed to load beds: ${response.status}`);
            clearBedsDropdown();
        }
    } catch (error) {
        console.error('Network error loading beds:', error);
        showError('Network error loading beds: ' + error.message);
        clearBedsDropdown();
    }
}

/**
 * Populate beds dropdown
 */
function populateBedsDropdown(data) {
    const select = document.getElementById('bedSelect');
    select.innerHTML = '<option value="">-- Select a Bed --</option>';

    if (data.success && data.data && data.data.length > 0) {
        data.data.forEach(bed => {
            const option = document.createElement('option');
            option.value = bed.bedId;
            option.textContent = `${bed.name} (Room: ${bed.roomName})`;
            option.dataset.name = bed.name;
            option.dataset.roomName = bed.roomName || 'Unknown Room';
            option.dataset.description = bed.description || '';
            option.dataset.isActive = bed.isActive;
            select.appendChild(option);
        });

        console.log(`Populated ${data.data.length} beds for room ID: ${data.roomId}`);
    } else {
        const option = document.createElement('option');
        option.value = '';
        option.textContent = '-- No Beds Found --';
        option.disabled = true;
        select.appendChild(option);

        console.warn(`No beds found for room ID: ${data.roomId}`);
        showError(`No beds found for selected room`);
    }
}

/**
 * Clear beds dropdown
 */
function clearBedsDropdown() {
    const select = document.getElementById('bedSelect');
    select.innerHTML = '<option value="">-- Select Room First --</option>';

    // Hide bed details
    document.getElementById('bedDetails').style.display = 'none';
    currentBedId = null;

    console.log('Beds dropdown cleared');
}

/**
 * Handle bed selection change
 */
function onBedChange() {
    const select = document.getElementById('bedSelect');
    const selectedOption = select.options[select.selectedIndex];

    if (selectedOption.value) {
        currentBedId = parseInt(selectedOption.value);

        // Update bed details display
        document.getElementById('bedName').textContent = selectedOption.dataset.name;
        document.getElementById('bedId').textContent = currentBedId;
        document.getElementById('bedRoomName').textContent = selectedOption.dataset.roomName || 'Unknown Room';
        document.getElementById('bedStatus').textContent = selectedOption.dataset.isActive === 'true' ? 'Active' : 'Inactive';
        document.getElementById('bedDetails').style.display = 'block';

        console.log(`Bed selected: ${selectedOption.dataset.name} (ID: ${currentBedId}, Room: ${selectedOption.dataset.roomName})`);
    } else {
        currentBedId = null;
        document.getElementById('bedDetails').style.display = 'none';
        console.log('Bed selection cleared');
    }
}

/**
 * Test CSP solver
 */
async function testCSPSolver() {
    if (!validateInputs()) return;
    
    showLoading(true);
    updateQuickAnalysis('csp', 'Testing...', 'status-warning');
    
    const startTime = Date.now();
    
    try {
        const params = new URLSearchParams({
            action: 'test_csp_solver',
            serviceId: currentServiceId,
            customerId: getCurrentCustomerId(),
            date: currentDate,
            maxResults: 50
        });

        // Add room and bed constraints if selected
        if (currentRoomId) {
            params.append('roomId', currentRoomId);
        }
        if (currentBedId) {
            params.append('bedId', currentBedId);
        }
        if (currentTherapistId) {
            params.append('therapistId', currentTherapistId);
        }
        
        const response = await fetch(`${contextPath}/test/booking?${params}`, {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        });
        
        const responseTime = Date.now() - startTime;
        
        if (response.ok) {
            const data = await response.json();
            testResults.csp = { data, responseTime, success: true };
            
            displayTestResult('CSP Solver Test', data, responseTime);
            updateQuickAnalysisFromResult('csp', data.analysis);
            
            console.log(`CSP Solver test completed: ${data.solutionsFound} solutions in ${responseTime}ms`);
        } else {
            const errorText = await response.text();
            testResults.csp = { error: errorText, responseTime, success: false };
            
            showError(`CSP Solver test failed: ${response.status}`);
            updateQuickAnalysis('csp', 'Failed', 'status-error');
        }
    } catch (error) {
        const responseTime = Date.now() - startTime;
        testResults.csp = { error: error.message, responseTime, success: false };
        
        showError(`CSP Solver test error: ${error.message}`);
        updateQuickAnalysis('csp', 'Error', 'status-error');
    } finally {
        showLoading(false);
    }
}

/**
 * Test availability service
 */
async function testAvailabilityService() {
    if (!validateInputs()) return;
    
    showLoading(true);
    updateQuickAnalysis('availability', 'Testing...', 'status-warning');
    
    const startTime = Date.now();
    
    try {
        const params = new URLSearchParams({
            action: 'test_availability_service',
            serviceId: currentServiceId,
            customerId: getCurrentCustomerId(),
            date: currentDate
        });
        
        const response = await fetch(`${contextPath}/test/booking?${params}`, {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        });
        
        const responseTime = Date.now() - startTime;
        
        if (response.ok) {
            const data = await response.json();
            testResults.availability = { data, responseTime, success: true };
            
            displayTestResult('Availability Service Test', data, responseTime);
            updateQuickAnalysisFromResult('availability', data.analysis);
            
            console.log(`Availability Service test completed: ${data.slotsFound} slots in ${responseTime}ms`);
        } else {
            const errorText = await response.text();
            testResults.availability = { error: errorText, responseTime, success: false };
            
            showError(`Availability Service test failed: ${response.status}`);
            updateQuickAnalysis('availability', 'Failed', 'status-error');
        }
    } catch (error) {
        const responseTime = Date.now() - startTime;
        testResults.availability = { error: error.message, responseTime, success: false };
        
        showError(`Availability Service test error: ${error.message}`);
        updateQuickAnalysis('availability', 'Error', 'status-error');
    } finally {
        showLoading(false);
    }
}

/**
 * Test time generation
 */
async function testTimeGeneration() {
    showLoading(true);
    updateQuickAnalysis('timeGen', 'Testing...', 'status-warning');
    
    const startTime = Date.now();
    
    try {
        const params = new URLSearchParams({
            action: 'test_time_generation',
            date: currentDate || '2025-07-25',
            serviceDuration: 75
        });
        
        const response = await fetch(`${contextPath}/test/booking?${params}`, {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        });
        
        const responseTime = Date.now() - startTime;
        
        if (response.ok) {
            const data = await response.json();
            testResults.timeGeneration = { data, responseTime, success: true };
            
            displayTimeGenerationResult(data, responseTime);
            
            // Analyze time generation result
            const slotsGenerated = extractSlotsFromTimeGeneration(data.testOutput);
            if (slotsGenerated > 20) {
                updateQuickAnalysis('timeGen', 'Healthy', 'status-healthy', `${slotsGenerated} slots`);
            } else if (slotsGenerated === 1) {
                updateQuickAnalysis('timeGen', 'Bug Detected', 'status-error', 'Only 1 slot!');
            } else {
                updateQuickAnalysis('timeGen', 'Limited', 'status-warning', `${slotsGenerated} slots`);
            }
            
            console.log(`Time Generation test completed in ${responseTime}ms`);
        } else {
            const errorText = await response.text();
            testResults.timeGeneration = { error: errorText, responseTime, success: false };
            
            showError(`Time Generation test failed: ${response.status}`);
            updateQuickAnalysis('timeGen', 'Failed', 'status-error');
        }
    } catch (error) {
        const responseTime = Date.now() - startTime;
        testResults.timeGeneration = { error: error.message, responseTime, success: false };
        
        showError(`Time Generation test error: ${error.message}`);
        updateQuickAnalysis('timeGen', 'Error', 'status-error');
    } finally {
        showLoading(false);
    }
}

/**
 * Test conflict scenarios
 */
async function testConflicts() {
    showLoading(true);

    try {
        const params = new URLSearchParams({
            action: 'simulate_conflicts',
            date: currentDate || '2025-07-25'
        });

        const response = await fetch(`${contextPath}/test/booking?${params}`, {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        });

        if (response.ok) {
            const data = await response.json();
            displayConflictResults(data);
            console.log('Conflict simulation completed');
        } else {
            showError(`Conflict test failed: ${response.status}`);
        }
    } catch (error) {
        showError(`Conflict test error: ${error.message}`);
    } finally {
        showLoading(false);
    }
}

/**
 * Test performance
 */
async function testPerformance() {
    showLoading(true);

    try {
        const params = new URLSearchParams({
            action: 'performance_test',
            iterations: 5
        });

        const response = await fetch(`${contextPath}/test/booking?${params}`, {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        });

        if (response.ok) {
            const data = await response.json();
            testResults.performance = data;
            displayPerformanceResults(data);
            console.log('Performance test completed');
        } else {
            showError(`Performance test failed: ${response.status}`);
        }
    } catch (error) {
        showError(`Performance test error: ${error.message}`);
    } finally {
        showLoading(false);
    }
}

/**
 * Load existing bookings
 */
async function loadExistingBookings() {
    if (!currentDate) {
        showError('Please select a date first');
        return;
    }

    showLoading(true);

    try {
        const params = new URLSearchParams({
            action: 'load_existing_bookings',
            date: currentDate
        });

        const response = await fetch(`${contextPath}/test/booking?${params}`, {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        });

        if (response.ok) {
            const data = await response.json();
            displayExistingBookings(data);
            console.log(`Loaded ${data.count} existing bookings`);
        } else {
            showError(`Failed to load bookings: ${response.status}`);
        }
    } catch (error) {
        showError(`Error loading bookings: ${error.message}`);
    } finally {
        showLoading(false);
    }
}

/**
 * Compare all test results
 */
async function compareAllTests() {
    console.log('Starting comprehensive test comparison...');

    // Run all tests sequentially
    await testCSPSolver();
    await testAvailabilityService();
    await testTimeGeneration();

    // Generate comparison
    generateComparisonAnalysis();
    updateOverallHealth();

    console.log('All tests completed');
}

/**
 * Utility functions
 */
function validateInputs() {
    if (!currentServiceId) {
        showError('Please select a service first');
        return false;
    }

    if (!currentDate) {
        showError('Please select a test date');
        return false;
    }

    return true;
}

function getCurrentCustomerId() {
    const customerSelect = document.getElementById('customerSelect');
    return customerSelect.value || '113';
}

function showLoading(show) {
    const spinner = document.getElementById('loadingSpinner');
    spinner.style.display = show ? 'block' : 'none';
}

function showError(message) {
    const container = document.getElementById('resultsContainer');
    const errorHtml = `
        <div class="result-card result-error">
            <h5><i class="fas fa-exclamation-triangle"></i> Error</h5>
            <p>${message}</p>
            <small class="text-muted">${new Date().toLocaleTimeString()}</small>
        </div>
    `;
    container.innerHTML = errorHtml + container.innerHTML;
}

function updateQuickAnalysis(type, status, statusClass, details = '') {
    const statusElement = document.getElementById(`${type}Status`);
    const detailsElement = document.getElementById(`${type}Details`);

    if (statusElement) {
        statusElement.innerHTML = `<span class="analysis-badge ${statusClass}">${status}</span>`;
    }

    if (detailsElement) {
        detailsElement.textContent = details || 'Analysis complete';
    }
}

function updateQuickAnalysisFromResult(type, analysis) {
    if (!analysis) return;

    let statusClass = 'status-warning';
    let details = analysis.issue || '';

    switch (analysis.status) {
        case 'HEALTHY':
            statusClass = 'status-healthy';
            break;
        case 'SINGLE_SLOT_BUG':
            statusClass = 'status-error';
            break;
        case 'LIMITED':
            statusClass = 'status-warning';
            break;
        case 'NO_SOLUTIONS':
        case 'NO_SLOTS':
            statusClass = 'status-error';
            break;
    }

    updateQuickAnalysis(type, analysis.status, statusClass, details);
}

function updateOverallHealth() {
    const cspHealthy = testResults.csp?.data?.analysis?.status === 'HEALTHY';
    const availabilityHealthy = testResults.availability?.data?.analysis?.status === 'HEALTHY';
    const timeGenHealthy = testResults.timeGeneration?.success;

    let overallStatus = 'Pending';
    let statusClass = 'status-warning';
    let details = 'Run more tests';

    if (cspHealthy && availabilityHealthy && timeGenHealthy) {
        overallStatus = 'Healthy';
        statusClass = 'status-healthy';
        details = 'All systems working';
    } else if (testResults.csp?.data?.analysis?.status === 'SINGLE_SLOT_BUG') {
        overallStatus = 'Bug Detected';
        statusClass = 'status-error';
        details = 'CSP solver issue found';
    } else {
        overallStatus = 'Issues Found';
        statusClass = 'status-warning';
        details = 'Some tests failed';
    }

    updateQuickAnalysis('overall', overallStatus, statusClass, details);
}

function formatPrice(price) {
    return new Intl.NumberFormat('vi-VN').format(price);
}

function formatTimeSlot(timeStr) {
    if (!timeStr) return 'Unknown';

    try {
        const date = new Date(timeStr);
        return date.toLocaleTimeString('vi-VN', {
            hour: '2-digit',
            minute: '2-digit',
            hour12: false
        });
    } catch (e) {
        return timeStr.substring(0, 5); // Just show HH:MM
    }
}

function getStatusClass(status) {
    switch (status) {
        case 'HEALTHY': return 'status-healthy';
        case 'SINGLE_SLOT_BUG': return 'status-error';
        case 'LIMITED': return 'status-warning';
        case 'NO_SOLUTIONS':
        case 'NO_SLOTS': return 'status-error';
        default: return 'status-warning';
    }
}

function extractSlotsFromTimeGeneration(output) {
    if (!output) return 0;

    const match = output.match(/Generated (\d+) time slots/);
    return match ? parseInt(match[1]) : 0;
}

function clearAllResults() {
    document.getElementById('resultsContainer').innerHTML = `
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i> Configure test parameters above and run tests to see results here.
        </div>
    `;

    // Reset quick analysis
    ['csp', 'availability', 'timeGen', 'overall'].forEach(type => {
        updateQuickAnalysis(type, 'Not Tested', 'status-warning', 'Click test to analyze');
    });

    // Clear test results
    testResults = {
        csp: null,
        availability: null,
        timeGeneration: null,
        conflicts: null,
        performance: null
    };

    console.log('All results cleared');
}

/**
 * Display test result (main function for CSP Solver and other tests)
 */
function displayTestResult(title, data, responseTime) {
    const container = document.getElementById('resultsContainer');

    let resultClass = 'result-success';
    if (!data.success) {
        resultClass = 'result-error';
    } else if (data.analysis && data.analysis.status === 'SINGLE_SLOT_BUG') {
        resultClass = 'result-error';
    } else if (data.analysis && data.analysis.status === 'LIMITED') {
        resultClass = 'result-warning';
    }

    let resultHtml = `
        <div class="result-card ${resultClass}">
            <h5><i class="fas fa-test-tube"></i> ${title}</h5>
            <p><strong>Response Time:</strong> ${responseTime}ms</p>
            <p><strong>Status:</strong> ${data.success ? 'Success' : 'Failed'}</p>
    `;

    if (data.success) {
        if (data.solutionsFound !== undefined) {
            resultHtml += `<p><strong>Solutions Found:</strong> ${data.solutionsFound}</p>`;
        }
        if (data.slotsFound !== undefined) {
            resultHtml += `<p><strong>Slots Found:</strong> ${data.slotsFound}</p>`;
        }

        // Display analysis
        if (data.analysis) {
            resultHtml += `
                <div class="mt-3">
                    <strong>Analysis:</strong>
                    <span class="analysis-badge ${getStatusClass(data.analysis.status)}">${data.analysis.status}</span>
                    <br><small>${data.analysis.issue}</small>
                </div>
            `;

            // Show additional analysis details
            if (data.analysis.totalSolutions) {
                resultHtml += `<br><small>Total Solutions: ${data.analysis.totalSolutions}</small>`;
            }
            if (data.analysis.uniqueTimeSlots) {
                resultHtml += `<br><small>Unique Time Slots: ${data.analysis.uniqueTimeSlots}</small>`;
            }
            if (data.analysis.firstSlot) {
                resultHtml += `<br><small>First Slot: ${data.analysis.firstSlot}</small>`;
            }
            if (data.analysis.lastSlot) {
                resultHtml += `<br><small>Last Slot: ${data.analysis.lastSlot}</small>`;
            }
        }

        // Display time slots if available
        if (data.data && Array.isArray(data.data) && data.data.length > 0) {
            resultHtml += '<div class="mt-3"><strong>Time Slots:</strong><br>';

            const displaySlots = data.data.slice(0, 12); // Show first 12 slots
            displaySlots.forEach(slot => {
                const startTime = slot.timeSlot?.startTime || slot.startTime || 'Unknown';
                const available = slot.available !== undefined ? slot.available : true;
                const slotClass = available ? 'slot-available' : 'slot-unavailable';

                resultHtml += `<div class="time-slot ${slotClass}">${formatTimeSlot(startTime)}</div>`;
            });

            if (data.data.length > 12) {
                resultHtml += `<p class="mt-2 text-muted">... and ${data.data.length - 12} more slots</p>`;
            }

            resultHtml += '</div>';
        }

        // Display execution details
        if (data.executionTime) {
            resultHtml += `<br><small>Execution Time: ${data.executionTime}ms</small>`;
        }
        if (data.parameters) {
            resultHtml += `<br><small>Parameters: Service ID ${data.parameters.serviceId}, Customer ID ${data.parameters.customerId}, Date ${data.parameters.date}</small>`;
        }

    } else {
        resultHtml += `<p class="text-danger"><strong>Error:</strong> ${data.message || 'Unknown error'}</p>`;
        if (data.error) {
            resultHtml += `<p class="text-danger"><small>Error Type: ${data.error}</small></p>`;
        }
    }

    resultHtml += '</div>';

    container.innerHTML = resultHtml + container.innerHTML;
}

/**
 * Display time generation result
 */
function displayTimeGenerationResult(data, responseTime) {
    const container = document.getElementById('resultsContainer');

    const resultHtml = `
        <div class="result-card result-success">
            <h5><i class="fas fa-calendar-alt"></i> Time Generation Test</h5>
            <p><strong>Response Time:</strong> ${responseTime}ms</p>
            <div class="mt-3">
                <strong>Test Output:</strong>
                <pre style="background: #f8f9fa; padding: 10px; border-radius: 4px; font-size: 12px; max-height: 200px; overflow-y: auto;">${data.testOutput}</pre>
            </div>
        </div>
    `;

    container.innerHTML = resultHtml + container.innerHTML;
}

/**
 * Display conflict results
 */
function displayConflictResults(data) {
    const container = document.getElementById('resultsContainer');

    let conflictHtml = `
        <div class="result-card result-success">
            <h5><i class="fas fa-exclamation-triangle"></i> Conflict Simulation</h5>
            <p><strong>Date:</strong> ${data.date}</p>
            <p><strong>Scenarios:</strong> ${data.conflictScenarios ? data.conflictScenarios.length : 0}</p>
    `;

    if (data.conflictScenarios && data.conflictScenarios.length > 0) {
        conflictHtml += '<div class="mt-3"><strong>Conflict Scenarios:</strong><br>';
        data.conflictScenarios.forEach(scenario => {
            conflictHtml += `
                <div class="mt-2 p-2" style="border: 1px solid #ddd; border-radius: 4px;">
                    <strong>${scenario.name}</strong> (${scenario.timeRange})<br>
                    <small>${scenario.description}</small><br>
                    <small>Conflicts: ${scenario.conflictCount}</small>
                </div>
            `;
        });
        conflictHtml += '</div>';
    }

    conflictHtml += '</div>';
    container.innerHTML = conflictHtml + container.innerHTML;
}

/**
 * Display performance results
 */
function displayPerformanceResults(data) {
    const container = document.getElementById('resultsContainer');

    let performanceHtml = `
        <div class="result-card result-success">
            <h5><i class="fas fa-tachometer-alt"></i> Performance Test Results</h5>
    `;

    if (data.results && data.results.length > 0) {
        performanceHtml += '<div class="mt-3"><strong>Performance Metrics:</strong><br>';
        data.results.forEach(result => {
            performanceHtml += `
                <div class="mt-2 p-2" style="border: 1px solid #ddd; border-radius: 4px;">
                    <strong>${result.scenario}</strong><br>
                    <small>Average Time: ${result.averageTime}ms</small><br>
                    <small>Success Rate: ${result.successCount}/${result.iterations}</small>
                </div>
            `;
        });
        performanceHtml += '</div>';
    }

    performanceHtml += '</div>';
    container.innerHTML = performanceHtml + container.innerHTML;
}

/**
 * Display existing bookings
 */
function displayExistingBookings(data) {
    const container = document.getElementById('resultsContainer');

    let bookingsHtml = `
        <div class="result-card result-success">
            <h5><i class="fas fa-list"></i> Existing Bookings</h5>
            <p><strong>Date:</strong> ${data.date}</p>
            <p><strong>Count:</strong> ${data.count}</p>
    `;

    if (data.data && data.data.length > 0) {
        bookingsHtml += '<div class="mt-3"><strong>Bookings:</strong><br>';
        data.data.forEach(booking => {
            bookingsHtml += `
                <div class="mt-2 p-2" style="border: 1px solid #ddd; border-radius: 4px;">
                    <strong>${booking.customerName}</strong> - ${booking.serviceName}<br>
                    <small>${booking.startTime} - ${booking.endTime} (${booking.status})</small>
                </div>
            `;
        });
        bookingsHtml += '</div>';
    }

    bookingsHtml += '</div>';
    container.innerHTML = bookingsHtml + container.innerHTML;
}

/**
 * Generate comparison analysis
 */
function generateComparisonAnalysis() {
    console.log('Generating comparison analysis...');

    const container = document.getElementById('resultsContainer');

    let analysisHtml = `
        <div class="result-card result-success">
            <h5><i class="fas fa-balance-scale"></i> Comparison Analysis</h5>
            <div class="mt-3">
    `;

    // Analyze CSP results
    if (testResults.csp && testResults.csp.success) {
        const cspData = testResults.csp.data;
        analysisHtml += `
            <div class="mb-3">
                <strong>CSP Solver:</strong>
                <span class="analysis-badge ${getStatusClass(cspData.analysis?.status || 'UNKNOWN')}">${cspData.analysis?.status || 'Unknown'}</span>
                <br><small>Solutions: ${cspData.solutionsFound}, Time: ${testResults.csp.responseTime}ms</small>
            </div>
        `;
    }

    // Analyze Availability results
    if (testResults.availability && testResults.availability.success) {
        const availData = testResults.availability.data;
        analysisHtml += `
            <div class="mb-3">
                <strong>Availability Service:</strong>
                <span class="analysis-badge ${getStatusClass(availData.analysis?.status || 'UNKNOWN')}">${availData.analysis?.status || 'Unknown'}</span>
                <br><small>Slots: ${availData.slotsFound}, Time: ${testResults.availability.responseTime}ms</small>
            </div>
        `;
    }

    // Analyze Time Generation results
    if (testResults.timeGeneration && testResults.timeGeneration.success) {
        analysisHtml += `
            <div class="mb-3">
                <strong>Time Generation:</strong>
                <span class="analysis-badge status-healthy">Completed</span>
                <br><small>Time: ${testResults.timeGeneration.responseTime}ms</small>
            </div>
        `;
    }

    analysisHtml += '</div></div>';
    container.innerHTML = analysisHtml + container.innerHTML;
}
