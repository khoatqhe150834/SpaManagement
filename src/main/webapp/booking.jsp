<%-- src/main/webapp/booking.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Spa Booking System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css" rel="stylesheet">
    <style>
        .booking-container { max-width: 1200px; margin: 0 auto; padding: 20px; }
        .step-indicator { margin-bottom: 30px; }
        .step { display: inline-block; padding: 10px 20px; margin: 5px; border-radius: 25px; }
        .step.active { background-color: #007bff; color: white; }
        .step.completed { background-color: #28a745; color: white; }
        .step.inactive { background-color: #e9ecef; color: #6c757d; }
        .time-slot { margin: 5px; padding: 10px 15px; border: 1px solid #ddd; border-radius: 5px; cursor: pointer; }
        .time-slot:hover { background-color: #f8f9fa; }
        .time-slot.selected { background-color: #007bff; color: white; }
        .service-info { background-color: #f8f9fa; padding: 20px; border-radius: 10px; margin-bottom: 20px; }
        .calendar-container { margin: 20px 0; }
        .loading { text-align: center; padding: 20px; }
        .alert-info { margin: 15px 0; }
        .resource-option { padding: 10px; border: 1px solid #ddd; margin: 5px 0; border-radius: 5px; cursor: pointer; }
        .resource-option:hover { background-color: #f8f9fa; }
        .resource-option.selected { background-color: #007bff; color: white; }
    </style>
</head>
<body>
    <div class="booking-container">
        <h1 class="text-center mb-4">🌺 Spa Booking System</h1>
        
        <!-- Step Indicator -->
        <div class="step-indicator text-center">
            <span class="step active" id="step1">1. Select Service</span>
            <span class="step inactive" id="step2">2. Choose Date</span>
            <span class="step inactive" id="step3">3. Pick Time</span>
            <span class="step inactive" id="step4">4. Select Resources</span>
            <span class="step inactive" id="step5">5. Confirm</span>
        </div>
        
        <!-- Step 1: Service Selection -->
        <div id="serviceSelection" class="step-content">
            <h3>Step 1: Select a Service to Book</h3>
            <div class="row">
                <div class="col-md-8">
                    <c:choose>
                        <c:when test="${not empty paymentItems}">
                            <div class="mb-3">
                                <label for="paymentItemSelect" class="form-label">Choose from your paid services:</label>
                                <select id="paymentItemSelect" class="form-select" onchange="selectPaymentItem()">
                                    <option value="">-- Select a service --</option>
                                    <c:forEach var="item" items="${paymentItems}">
                                        <option value="${item.paymentItemId}" 
                                                data-service-name="${item.serviceName}"
                                                data-quantity="${item.quantity}"
                                                data-booked="${item.bookedQuantity}"
                                                data-remaining="${item.remainingQuantity}"
                                                data-duration="${item.serviceDuration}"
                                                data-buffer="${item.bufferTime}"
                                                data-price="<fmt:formatNumber value='${item.unitPrice}' type='currency' currencySymbol='₫'/>">
                                            ${item.serviceName} (${item.remainingQuantity}/${item.quantity} remaining)
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-warning">
                                <h5>No Available Services</h5>
                                <p>You don't have any paid services available for booking. Please make a payment first.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- Service Information Panel -->
            <div id="serviceInfo" class="service-info" style="display: none;">
                <h4>Service Information</h4>
                <div class="row">
                    <div class="col-md-6">
                        <p><strong>Service:</strong> <span id="infoServiceName">-</span></p>
                        <p><strong>Duration:</strong> <span id="infoDuration">-</span> minutes</p>
                        <p><strong>Buffer Time:</strong> <span id="infoBuffer">-</span> minutes</p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Price:</strong> <span id="infoPrice">-</span></p>
                        <p><strong>Remaining Sessions:</strong> <span id="infoRemaining">-</span></p>
                        <p><strong>Total Time Needed:</strong> <span id="infoTotalTime">-</span> minutes</p>
                    </div>
                </div>
                <button type="button" class="btn btn-primary" onclick="nextStep(2)">Continue to Date Selection</button>
            </div>
        </div>
        
        <!-- Step 2: Date Selection -->
        <div id="dateSelection" class="step-content" style="display: none;">
            <h3>Step 2: Choose Your Appointment Date</h3>
            <div class="calendar-container">
                <label for="appointmentDate" class="form-label">Select Date:</label>
                <input type="text" id="appointmentDate" class="form-control" 
                       placeholder="Click to select date" readonly>
            </div>
            <div class="mt-3">
                <button type="button" class="btn btn-secondary" onclick="previousStep(1)">Back</button>
                <button type="button" class="btn btn-primary" id="continueToTime" 
                        onclick="loadAvailableSlots()" disabled>Load Available Times</button>
            </div>
        </div>
        
        <!-- Step 3: Time Selection -->
        <div id="timeSelection" class="step-content" style="display: none;">
            <h3>Step 3: Choose Your Time Slot</h3>
            <div id="loadingSlots" class="loading" style="display: none;">
                <div class="spinner-border" role="status">
                    <span class="visually-hidden">Loading available time slots...</span>
                </div>
                <p>Loading available time slots...</p>
            </div>
            <div id="availableSlots" class="row"></div>
            <div class="mt-3">
                <button type="button" class="btn btn-secondary" onclick="previousStep(2)">Back</button>
                <button type="button" class="btn btn-primary" id="continueToResources" 
                        onclick="loadAvailableResources()" disabled>Select Resources</button>
            </div>
        </div>
        
        <!-- Step 4: Resource Selection -->
        <div id="resourceSelection" class="step-content" style="display: none;">
            <h3>Step 4: Select Therapist, Room & Bed</h3>
            <div id="selectedTimeInfo" class="alert alert-info"></div>
            <div id="loadingResources" class="loading" style="display: none;">
                <div class="spinner-border" role="status">
                    <span class="visually-hidden">Loading available resources...</span>
                </div>
                <p>Loading available resources...</p>
            </div>
            <div id="availableResources"></div>
            <div class="mt-3">
                <button type="button" class="btn btn-secondary" onclick="previousStep(3)">Back</button>
                <button type="button" class="btn btn-success" id="continueToConfirm" 
                        onclick="nextStep(5)" disabled>Review Booking</button>
            </div>
        </div>
        
        <!-- Step 5: Confirmation -->
        <div id="confirmation" class="step-content" style="display: none;">
            <h3>Step 5: Confirm Your Booking</h3>
            <div class="service-info">
                <h4>Booking Summary</h4>
                <div id="bookingSummary"></div>
                <div class="mt-4">
                    <button type="button" class="btn btn-secondary" onclick="previousStep(4)">Back</button>
                    <button type="button" class="btn btn-success btn-lg" onclick="confirmBooking()">
                        <span id="bookingButtonText">Confirm Booking</span>
                        <span id="bookingSpinner" class="spinner-border spinner-border-sm" 
                              role="status" style="display: none;"></span>
                    </button>
                </div>
            </div>
        </div>
        
        <!-- Success Message -->
        <div id="successMessage" class="step-content" style="display: none;">
            <div class="alert alert-success text-center">
                <h4>🎉 Booking Confirmed!</h4>
                <div id="successDetails"></div>
                <div class="mt-3">
                    <button type="button" class="btn btn-primary" onclick="bookAnother()">Book Another Session</button>
                    <button type="button" class="btn btn-outline-primary" onclick="location.reload()">Start Over</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script>
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
                const response = await fetch(
                    `booking?action=getAvailableSlots&paymentItemId=${selectedPaymentItem.id}&date=${selectedDate}`
                );
                const data = await response.json();
                
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
                alert('Error loading available time slots. Please try again.');
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
                const response = await fetch(
                    `booking?action=getAvailableResources&paymentItemId=${selectedPaymentItem.id}&date=${selectedDate}&time=${selectedTime}`
                );
                const data = await response.json();
                
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
        
        function nextStep(step) {
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
                const formData = new FormData();
                formData.append('action', 'createBooking');
                formData.append('paymentItemId', selectedPaymentItem.id);
                formData.append('appointmentDate', selectedDate);
                formData.append('appointmentTime', selectedTime);
                formData.append('therapistId', selectedResource.therapistId);
                formData.append('roomId', selectedResource.roomId);
                if (selectedResource.bedId) {
                    formData.append('bedId', selectedResource.bedId);
                }
                
                const response = await fetch('booking', {
                    method: 'POST',
                    body: formData
                });
                
                const result = await response.json();
                
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
    </script>
</body>
</html>