// Global variables
let currentStep = 1;
let selectedPaymentItem = null;
let selectedDate = null;
let selectedTime = null;
let selectedResource = null;
let availableSlots = [];

// Initialize date picker
let datePicker = flatpickr("#appointmentDate", {
    minDate: "today",
    dateFormat: "Y-m-d",
    onChange: function(selectedDates, dateStr, instance) {
        selectedDate = dateStr;
        document.getElementById('continueToTime').disabled = !dateStr;
        updateStepIndicator(2, 'active');
    }
});

// Initialize page with pre-selected service data
function initializePreSelectedService(paymentItemData) {
    if (paymentItemData) {
        selectedPaymentItem = paymentItemData;

        // Update service info panel
        document.getElementById('infoServiceName').textContent = selectedPaymentItem.serviceName;
        document.getElementById('infoDuration').textContent = selectedPaymentItem.duration;
        document.getElementById('infoBuffer').textContent = selectedPaymentItem.buffer;
        document.getElementById('infoPrice').textContent = selectedPaymentItem.price;
        document.getElementById('infoRemaining').textContent = selectedPaymentItem.remaining;
        document.getElementById('infoTotalTime').textContent = selectedPaymentItem.duration + selectedPaymentItem.buffer;

        // Show service info and mark step as completed
        document.getElementById('serviceInfo').style.display = 'block';
        updateStepIndicator(1, 'completed');

        // Move to step 2 (date selection) since service is already selected
        currentStep = 2;
        updateStepIndicator(2, 'active');
    }
}

function selectPaymentItem() {
    const select = document.getElementById('paymentItemSelect');
    const option = select.options[select.selectedIndex];
    
    if (option.value) {
        selectedPaymentItem = {
            id: parseInt(option.value),
            serviceName: option.dataset.serviceName,
            quantity: parseInt(option.dataset.quantity),
            booked: parseInt(option.dataset.booked),
            remaining: parseInt(option.dataset.remaining),
            duration: parseInt(option.dataset.duration),
            buffer: parseInt(option.dataset.buffer),
            price: option.dataset.price
        };
        
        // Update service info panel
        document.getElementById('infoServiceName').textContent = selectedPaymentItem.serviceName;
        document.getElementById('infoDuration').textContent = selectedPaymentItem.duration;
        document.getElementById('infoBuffer').textContent = selectedPaymentItem.buffer;
        document.getElementById('infoPrice').textContent = selectedPaymentItem.price;
        document.getElementById('infoRemaining').textContent = selectedPaymentItem.remaining;
        document.getElementById('infoTotalTime').textContent = selectedPaymentItem.duration + selectedPaymentItem.buffer;
        
        document.getElementById('serviceInfo').style.display = 'block';
        updateStepIndicator(1, 'completed');
    } else {
        document.getElementById('serviceInfo').style.display = 'none';
        updateStepIndicator(1, 'active');
    }
}

function nextStep(step) {
    // Hide current step
    document.querySelectorAll('.step-content').forEach(el => el.style.display = 'none');
    
    // Show target step
    const stepElements = {
        1: 'serviceSelection',
        2: 'dateSelection', 
        3: 'timeSelection',
        4: 'resourceSelection',
        5: 'confirmation'
    };
    
    document.getElementById(stepElements[step]).style.display = 'block';
    currentStep = step;
    updateStepIndicator(step, 'active');
}

function previousStep(step) {
    nextStep(step);
    updateStepIndicator(step, 'active');
}

function updateStepIndicator(step, status) {
    const stepEl = document.getElementById('step' + step);
    stepEl.className = 'step ' + status;
}

async function loadAvailableSlots() {
    if (!selectedPaymentItem || !selectedDate) {
        alert('Please select a service and date first.');
        return;
    }

    document.getElementById('loadingSlots').style.display = 'block';
    document.getElementById('availableSlots').innerHTML = '';

    try {
        // Use absolute URL to ensure correct routing
        const contextPath = window.location.pathname.includes('/spa') ? '/spa' : '';
        const url = `${contextPath}/manager/booking-api?action=getAvailableSlots&paymentItemId=${selectedPaymentItem.id}&date=${selectedDate}`;
        console.log('Fetching available slots from:', url);
        console.log('Current location:', window.location.href);

        const response = await fetch(url, {
            method: 'GET',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        });

        console.log('Response status:', response.status);
        console.log('Response headers:', response.headers);

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const responseText = await response.text();
        console.log('Raw response:', responseText);

        // Check if response is HTML (authentication redirect)
        if (responseText.trim().startsWith('<!DOCTYPE') || responseText.trim().startsWith('<html')) {
            throw new Error('Authentication required. Please log in as a customer to access booking features.');
        }

        const data = JSON.parse(responseText);
        
        document.getElementById('loadingSlots').style.display = 'none';
        
        if (data.availableSlots && data.availableSlots.length > 0) {
            availableSlots = data.availableSlots;
            displayAvailableSlots(data.availableSlots);
            nextStep(3);
            updateStepIndicator(2, 'completed');
        } else {
            document.getElementById('availableSlots').innerHTML = 
                '<div class="col-12"><div class="alert alert-warning">No available time slots for this date. Please try another date.</div></div>';
        }
    } catch (error) {
        document.getElementById('loadingSlots').style.display = 'none';
        console.error('Error loading slots:', error);

        // Show more specific error message
        let errorMessage = 'Error loading available time slots. Please try again.';
        if (error.message.includes('Authentication required')) {
            errorMessage = 'Please log in as a customer to book services. Managers can book on behalf of customers by accessing the booking page with a specific payment item.';
        } else if (error.message.includes('HTTP error')) {
            errorMessage = 'Server error occurred. Please check your connection and try again.';
        }

        document.getElementById('availableSlots').innerHTML =
            '<div class="col-12"><div class="alert alert-danger">' + errorMessage + '</div></div>';
    }
}

function displayAvailableSlots(slots) {
    const container = document.getElementById('availableSlots');
    container.innerHTML = '<div class="col-12"><h5>Available Time Slots (' + slots.length + ' found):</h5></div>';
    
    slots.forEach(slot => {
        const startTime = slot.timeSlot.startTime.split('T')[1].substring(0, 5);
        const endTime = slot.timeSlot.endTime.split('T')[1].substring(0, 5);
        
        const slotDiv = document.createElement('div');
        slotDiv.className = 'col-md-3';
        slotDiv.innerHTML = `
            <div class="time-slot" data-time="${startTime}" onclick="selectTimeSlot('${startTime}', this)">
                <strong>${startTime} - ${endTime}</strong><br>
                <small>${slot.totalCombinations} resource combinations available</small>
            </div>
        `;
        container.appendChild(slotDiv);
    });
}

function selectTimeSlot(time, element) {
    // Remove previous selection
    document.querySelectorAll('.time-slot').forEach(el => el.classList.remove('selected'));
    
    // Select current
    element.classList.add('selected');
    selectedTime = time;
    
    document.getElementById('continueToResources').disabled = false;
    updateStepIndicator(3, 'completed');
}

async function loadAvailableResources() {
    if (!selectedTime) {
        alert('Please select a time slot first.');
        return;
    }
    
    document.getElementById('selectedTimeInfo').innerHTML = 
        `<strong>Selected:</strong> ${selectedDate} at ${selectedTime} for ${selectedPaymentItem.serviceName}`;
    
    document.getElementById('loadingResources').style.display = 'block';
    document.getElementById('availableResources').innerHTML = '';
    
    try {
        // Use absolute URL to ensure correct routing
        const contextPath = window.location.pathname.includes('/spa') ? '/spa' : '';
        const url = `${contextPath}/manager/booking-api?action=getAvailableResources&paymentItemId=${selectedPaymentItem.id}&date=${selectedDate}&time=${selectedTime}`;
        console.log('Fetching available resources from:', url);

        const response = await fetch(url, {
            method: 'GET',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        });

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const responseText = await response.text();

        // Check if response is HTML (authentication redirect)
        if (responseText.trim().startsWith('<!DOCTYPE') || responseText.trim().startsWith('<html')) {
            throw new Error('Authentication required. Please log in as a customer to access booking features.');
        }

        const data = JSON.parse(responseText);
        
        document.getElementById('loadingResources').style.display = 'none';
        
        if (data.availableResources && data.availableResources.length > 0) {
            displayAvailableResources(data.availableResources);
            nextStep(4);
            updateStepIndicator(3, 'completed');
        } else {
            document.getElementById('availableResources').innerHTML = 
                '<div class="alert alert-warning">No available resources for this time slot. Please select another time.</div>';
        }
    } catch (error) {
        document.getElementById('loadingResources').style.display = 'none';
        console.error('Error loading resources:', error);
        alert('Error loading available resources. Please try again.');
    }
}

function displayAvailableResources(resources) {
    const container = document.getElementById('availableResources');
    container.innerHTML = '<h5>Choose Your Preferred Combination:</h5>';
    
    resources.forEach((resource, index) => {
        const resourceDiv = document.createElement('div');
        resourceDiv.className = 'resource-option';
        resourceDiv.dataset.index = index;
        resourceDiv.onclick = () => selectResource(resource, resourceDiv);
        
        resourceDiv.innerHTML = `
            <div class="row">
                <div class="col-md-4">
                    <strong>👩‍⚕️ Therapist:</strong><br>
                    ${resource.therapistName}
                </div>
                <div class="col-md-4">
                    <strong>🏠 Room:</strong><br>
                    ${resource.roomName}
                </div>
                <div class="col-md-4">
                    <strong>🛏️ Bed:</strong><br>
                    ${resource.bedName || 'N/A'}
                </div>
            </div>
        `;
        
        container.appendChild(resourceDiv);
    });
}

function selectResource(resource, element) {
    // Remove previous selection
    document.querySelectorAll('.resource-option').forEach(el => el.classList.remove('selected'));

    // Select current
    element.classList.add('selected');
    selectedResource = resource;

    document.getElementById('continueToConfirm').disabled = false;
    updateStepIndicator(4, 'completed');
}

// Override nextStep function for confirmation step
function nextStepToConfirmation(step) {
    if (step === 5) {
        // Update booking summary
        const summary = document.getElementById('bookingSummary');
        summary.innerHTML = `
            <div class="row">
                <div class="col-md-6">
                    <p><strong>Service:</strong> ${selectedPaymentItem.serviceName}</p>
                    <p><strong>Date:</strong> ${selectedDate}</p>
                    <p><strong>Time:</strong> ${selectedTime}</p>
                    <p><strong>Duration:</strong> ${selectedPaymentItem.duration} minutes</p>
                </div>
                <div class="col-md-6">
                    <p><strong>Therapist:</strong> ${selectedResource.therapistName}</p>
                    <p><strong>Room:</strong> ${selectedResource.roomName}</p>
                    <p><strong>Bed:</strong> ${selectedResource.bedName || 'N/A'}</p>
                    <p><strong>Price:</strong> ${selectedPaymentItem.price}</p>
                </div>
            </div>
        `;
    }

    // Hide current step
    document.querySelectorAll('.step-content').forEach(el => el.style.display = 'none');

    // Show target step
    const stepElements = {
        1: 'serviceSelection',
        2: 'dateSelection',
        3: 'timeSelection',
        4: 'resourceSelection',
        5: 'confirmation'
    };

    document.getElementById(stepElements[step]).style.display = 'block';
    currentStep = step;
    updateStepIndicator(step, 'active');
}

async function confirmBooking() {
    const button = document.querySelector('button[onclick="confirmBooking()"]');
    const buttonText = document.getElementById('bookingButtonText');
    const spinner = document.getElementById('bookingSpinner');

    // Disable button and show spinner
    button.disabled = true;
    buttonText.textContent = 'Creating Booking...';
    spinner.style.display = 'inline-block';

    try {
        // Prepare form data as URL-encoded parameters
        const formData = new URLSearchParams();
        formData.append('action', 'createBooking');
        formData.append('paymentItemId', selectedPaymentItem.id);
        formData.append('appointmentDate', selectedDate);
        formData.append('appointmentTime', selectedTime);
        formData.append('therapistId', selectedResource.therapistId);
        formData.append('roomId', selectedResource.roomId);
        if (selectedResource.bedId) {
            formData.append('bedId', selectedResource.bedId);
        }

        // Use absolute URL to ensure correct routing
        const contextPath = window.location.pathname.includes('/spa') ? '/spa' : '';
        console.log('Sending booking request to:', `${contextPath}/manager/booking-api`);
        console.log('Form data:', Object.fromEntries(formData));

        const response = await fetch(`${contextPath}/manager/booking-api`, {
            method: 'POST',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: formData
        });

        console.log('Booking response status:', response.status);
        console.log('Booking response headers:', response.headers);

        const responseText = await response.text();
        console.log('Raw booking response:', responseText);

        // Check if response is HTML (authentication redirect)
        if (responseText.trim().startsWith('<!DOCTYPE') || responseText.trim().startsWith('<html')) {
            throw new Error('Authentication required or server error. Please refresh the page and try again.');
        }

        const result = JSON.parse(responseText);

        if (result.success) {
            // Show success message
            document.getElementById('successDetails').innerHTML = `
                <p><strong>Booking ID:</strong> ${result.bookingId}</p>
                <p><strong>Service:</strong> ${result.serviceName}</p>
                <p><strong>Date & Time:</strong> ${result.appointmentDate} at ${result.appointmentTime}</p>
                <p><strong>Remaining Sessions:</strong> ${result.remainingQuantity}</p>
            `;

            // Hide confirmation and show success
            document.getElementById('confirmation').style.display = 'none';
            document.getElementById('successMessage').style.display = 'block';
            updateStepIndicator(5, 'completed');
        } else {
            alert('Booking failed: ' + result.message);
        }
    } catch (error) {
        console.error('Error creating booking:', error);
        alert('Error creating booking. Please try again.');
    } finally {
        // Re-enable button
        button.disabled = false;
        buttonText.textContent = 'Confirm Booking';
        spinner.style.display = 'none';
    }
}

function bookAnother() {
    // Reset form but keep the same payment item if it has remaining quantity
    if (selectedPaymentItem.remaining > 1) {
        // Reset steps but keep service selected
        currentStep = 2;
        selectedDate = null;
        selectedTime = null;
        selectedResource = null;

        // Reset UI
        datePicker.clear();
        document.getElementById('continueToTime').disabled = true;

        // Update remaining quantity display
        selectedPaymentItem.remaining -= 1;
        document.getElementById('infoRemaining').textContent = selectedPaymentItem.remaining;

        // Go to date selection
        document.getElementById('successMessage').style.display = 'none';
        nextStep(2);
        updateStepIndicator(1, 'completed');
        updateStepIndicator(2, 'active');
    } else {
        // No more remaining quantity, start over
        location.reload();
    }
}
