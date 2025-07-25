// Global variables
let currentStep = 1;
let selectedPaymentItem = null;
let selectedDate = null;
let selectedTime = null;
let selectedResource = null;
let availableSlots = [];

// Make variables globally accessible
window.selectedPaymentItem = selectedPaymentItem;
window.currentStep = currentStep;

console.log('booking-page.js loaded successfully');

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
    console.log('initializePreSelectedService called with:', paymentItemData);
    if (paymentItemData) {
        // Set both local and global variables
        selectedPaymentItem = paymentItemData;
        window.selectedPaymentItem = paymentItemData;
        
        console.log('selectedPaymentItem set to:', selectedPaymentItem);
        console.log('window.selectedPaymentItem set to:', window.selectedPaymentItem);

        // Mark step as completed and move to step 2
        updateStepIndicator(1, 'completed');
        currentStep = 2;
        window.currentStep = currentStep;
        updateStepIndicator(2, 'active');
        
        console.log('Pre-selected service initialized successfully');
        
        // Verify the variables are set
        console.log('Verification - selectedPaymentItem:', selectedPaymentItem);
        console.log('Verification - window.selectedPaymentItem:', window.selectedPaymentItem);
    }
}

// Make function globally accessible
window.initializePreSelectedService = initializePreSelectedService;

function selectServiceCard(paymentItemId) {
    console.log('selectServiceCard called with paymentItemId:', paymentItemId);

    // Remove previous selection
    document.querySelectorAll('.service-card').forEach(card => {
        card.classList.remove('border-primary', 'bg-primary/5');
        card.classList.add('border-gray-200');
    });

    // Find and select the clicked card
    const selectedCard = document.querySelector(`[data-payment-item-id="${paymentItemId}"]`);
    console.log('Found card:', selectedCard);

    if (selectedCard) {
        console.log('Found card with dataset:', selectedCard.dataset);

        selectedCard.classList.remove('border-gray-200');
        selectedCard.classList.add('border-primary', 'bg-primary/5');

        // Extract data from the card
        selectedPaymentItem = {
            id: parseInt(selectedCard.dataset.paymentItemId),
            serviceName: selectedCard.dataset.serviceName,
            quantity: parseInt(selectedCard.dataset.quantity),
            booked: parseInt(selectedCard.dataset.booked),
            remaining: parseInt(selectedCard.dataset.remaining),
            duration: parseInt(selectedCard.dataset.duration),
            buffer: parseInt(selectedCard.dataset.buffer),
            price: selectedCard.dataset.price
        };

        window.selectedPaymentItem = selectedPaymentItem; // Also set on window
        console.log('Selected service card:', selectedPaymentItem);

        // Mark step as completed
        updateStepIndicator(1, 'completed');

        // Enable next step
        currentStep = 2;
        window.currentStep = currentStep; // Also set on window
        nextStep(2);
    } else {
        console.error('Card not found for paymentItemId:', paymentItemId);
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

        // Mark step as completed
        updateStepIndicator(1, 'completed');
    } else {
        // Reset step to active
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
    console.log('loadAvailableSlots called');
    console.log('selectedPaymentItem:', selectedPaymentItem);
    console.log('window.selectedPaymentItem:', window.selectedPaymentItem);
    console.log('selectedDate:', selectedDate);

    // Check both local and global variables
    const paymentItem = selectedPaymentItem || window.selectedPaymentItem;
    
    if (!paymentItem) {
        console.error('No service selected - both selectedPaymentItem and window.selectedPaymentItem are null');
        alert('Please select a service first.');
        return;
    }

    if (!selectedDate) {
        console.error('No date selected');
        alert('Please select a date first.');
        return;
    }

    // Use the found payment item
    const currentPaymentItem = paymentItem;
    console.log('Using payment item:', currentPaymentItem);

    document.getElementById('loadingSlots').style.display = 'block';
    document.getElementById('availableSlots').innerHTML = '';

    try {
        // Use absolute URL to ensure correct routing
        const contextPath = window.location.pathname.includes('/spa') ? '/spa' : '';
        const url = `${contextPath}/customer/booking-api?action=getAvailableSlots&paymentItemId=${currentPaymentItem.id}&date=${selectedDate}`;
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
        const url = `${contextPath}/customer/booking-api?action=getAvailableResources&paymentItemId=${selectedPaymentItem.id}&date=${selectedDate}&time=${selectedTime}`;
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
        console.log('Sending booking request to:', `${contextPath}/customer/booking-api`);
        console.log('Form data:', Object.fromEntries(formData));

        const response = await fetch(`${contextPath}/customer/booking-api`, {
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
    if (selectedPaymentItem && selectedPaymentItem.remaining > 1) {
        // Reset steps but keep service selected
        currentStep = 2;
        selectedDate = null;
        selectedTime = null;
        selectedResource = null;

        // Reset UI
        datePicker.clear();
        document.getElementById('continueToTime').disabled = true;

        // Update remaining quantity
        selectedPaymentItem.remaining -= 1;

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

// Additional utility functions
function changeService() {
    // Reset service selection
    selectedPaymentItem = null;
    window.selectedPaymentItem = null; // Also reset on window

    // Remove visual selection from service cards
    document.querySelectorAll('.service-card').forEach(card => {
        card.classList.remove('border-primary', 'bg-primary/5');
        card.classList.add('border-gray-200');
    });

    // Go back to step 1
    currentStep = 1;
    window.currentStep = currentStep; // Also set on window
    nextStep(1);
    updateStepIndicator(1, 'active');
    updateStepIndicator(2, 'inactive');
    updateStepIndicator(3, 'inactive');
    updateStepIndicator(4, 'inactive');
    updateStepIndicator(5, 'inactive');
}

function bookNextSession() {
    // Get current service info
    const serviceName = document.getElementById('remainingServiceName').textContent;
    const remainingCount = parseInt(document.getElementById('remainingCount').textContent);

    if (remainingCount > 0) {
        // Redirect to book next session of the same service
        const urlParams = new URLSearchParams(window.location.search);
        const paymentItemId = urlParams.get('paymentItemId');

        if (paymentItemId) {
            window.location.href = `${window.location.pathname}?paymentItemId=${paymentItemId}`;
        } else {
            // Reset the form for next booking
            resetBookingForm();

            // Go back to step 2 (date selection) since service is already selected
            currentStep = 2;
            nextStep(2);
            updateStepIndicator(2, 'active');
        }
    }
}

function viewAllBookings() {
    // Redirect to customer bookings page
    const contextPath = window.location.pathname.split('/')[1];
    window.location.href = `/${contextPath}/customer/bookings`;
}

function backToServices() {
    // Redirect back to customer dashboard or services page
    window.location.href = window.location.pathname;
}

function resetBookingForm() {
    // Reset global variables
    selectedDate = null;
    selectedTime = null;
    selectedResource = null;

    // Reset UI elements (check if they exist first)
    if (datePicker) {
        datePicker.clear();
    }
    
    const continueToTime = document.getElementById('continueToTime');
    const continueToResources = document.getElementById('continueToResources');
    const continueToConfirm = document.getElementById('continueToConfirm');
    
    if (continueToTime) continueToTime.disabled = true;
    if (continueToResources) continueToResources.disabled = true;
    if (continueToConfirm) continueToConfirm.disabled = true;

    // Clear slots and resources
    const availableSlots = document.getElementById('availableSlots');
    const availableResources = document.getElementById('availableResources');
    const bookingSummary = document.getElementById('bookingSummary');
    
    if (availableSlots) availableSlots.innerHTML = '';
    if (availableResources) availableResources.innerHTML = '';
    if (bookingSummary) bookingSummary.innerHTML = '';

    // Reset step indicators
    updateStepIndicator(2, 'inactive');
    updateStepIndicator(3, 'inactive');
    updateStepIndicator(4, 'inactive');
    updateStepIndicator(5, 'inactive');
}

// Make functions globally accessible
window.selectServiceCard = selectServiceCard;
window.changeService = changeService;
window.loadAvailableSlots = loadAvailableSlots;
window.bookNextSession = bookNextSession;
window.viewAllBookings = viewAllBookings;
window.backToServices = backToServices;
window.resetBookingForm = resetBookingForm;
window.previousStep = previousStep;
window.nextStep = nextStep;
window.nextStepToConfirmation = nextStepToConfirmation;
window.confirmBooking = confirmBooking;
window.initializePreSelectedService = initializePreSelectedService;

console.log('All functions made globally accessible');

// Debug function to check current state
window.checkBookingState = function() {
    console.log('=== Booking State Debug ===');
    console.log('selectedPaymentItem:', selectedPaymentItem);
    console.log('window.selectedPaymentItem:', window.selectedPaymentItem);
    console.log('selectedDate:', selectedDate);
    console.log('selectedTime:', selectedTime);
    console.log('selectedResource:', selectedResource);
    console.log('currentStep:', currentStep);
    console.log('========================');
};

// Manual initialization trigger for debugging
window.manualInitialize = function() {
    console.log('Manual initialization triggered');
    const preSelectedData = document.getElementById('preSelectedServiceData');
    if (preSelectedData) {
        const paymentItemData = {
            id: parseInt(preSelectedData.dataset.id),
            serviceName: preSelectedData.dataset.serviceName,
            quantity: parseInt(preSelectedData.dataset.quantity),
            booked: parseInt(preSelectedData.dataset.booked),
            remaining: parseInt(preSelectedData.dataset.remaining),
            duration: parseInt(preSelectedData.dataset.duration),
            buffer: parseInt(preSelectedData.dataset.buffer),
            price: preSelectedData.dataset.price
        };
        
        console.log('Manual init with data:', paymentItemData);
        initializePreSelectedService(paymentItemData);
    } else {
        console.log('No preSelectedServiceData found');
    }
};
