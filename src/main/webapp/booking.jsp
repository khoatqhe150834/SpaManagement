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
            <span class="step <c:choose><c:when test='${not empty selectedPaymentItem}'>completed</c:when><c:otherwise>active</c:otherwise></c:choose>" id="step1">
                <c:choose>
                    <c:when test="${not empty selectedPaymentItem}">1. Selected Service</c:when>
                    <c:otherwise>1. Select Service</c:otherwise>
                </c:choose>
            </span>
            <span class="step <c:choose><c:when test='${not empty selectedPaymentItem}'>active</c:when><c:otherwise>inactive</c:otherwise></c:choose>" id="step2">2. Choose Date</span>
            <span class="step inactive" id="step3">3. Pick Time</span>
            <span class="step inactive" id="step4">4. Select Resources</span>
            <span class="step inactive" id="step5">5. Confirm</span>
        </div>
        
        <!-- Step 1: Service Selection -->
        <div id="serviceSelection" class="step-content" <c:if test="${not empty selectedPaymentItem}">style="display: none;"</c:if>>
            <h3>Step 1: Selected Service</h3>
            <div class="row">
                <div class="col-md-8">
                    <c:choose>
                        <c:when test="${not empty selectedPaymentItem}">
                            <!-- Display selected service information -->
                            <div class="alert alert-info">
                                <h5>🌺 Service Selected</h5>
                                <p><strong>Service:</strong> ${selectedPaymentItem.serviceName}</p>
                                <p><strong>Remaining Sessions:</strong> ${selectedPaymentItem.remainingQuantity}/${selectedPaymentItem.quantity}</p>
                                <p><strong>Duration:</strong> ${selectedPaymentItem.serviceDuration} minutes</p>
                                <p><strong>Price:</strong> <fmt:formatNumber value='${selectedPaymentItem.unitPrice}' type='currency' currencySymbol='₫'/></p>
                            </div>
                        </c:when>
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
        <div id="dateSelection" class="step-content" <c:choose><c:when test="${not empty selectedPaymentItem}">style="display: block;"</c:when><c:otherwise>style="display: none;"</c:otherwise></c:choose>>
            <h3>Step 2: Choose Your Appointment Date</h3>

            <!-- Show selected service summary when pre-selected -->
            <c:if test="${not empty selectedPaymentItem}">
                <div class="alert alert-success mb-3">
                    <h6>✅ Selected Service: <strong>${selectedPaymentItem.serviceName}</strong></h6>
                    <small>Duration: ${selectedPaymentItem.serviceDuration} minutes | Remaining: ${selectedPaymentItem.remainingQuantity}/${selectedPaymentItem.quantity} sessions</small>
                </div>
            </c:if>
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
                        onclick="nextStepToConfirmation(5)" disabled>Review Booking</button>
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

    <!-- Hidden data for pre-selected service -->
    <c:if test="${not empty selectedPaymentItem}">
        <div id="preSelectedServiceData" style="display: none;"
             data-id="${selectedPaymentItem.paymentItemId}"
             data-service-name="${selectedPaymentItem.serviceName}"
             data-quantity="${selectedPaymentItem.quantity}"
             data-booked="${selectedPaymentItem.bookedQuantity}"
             data-remaining="${selectedPaymentItem.remainingQuantity}"
             data-duration="${selectedPaymentItem.serviceDuration}"
             data-buffer="${selectedPaymentItem.bufferTime}"
             data-price="<fmt:formatNumber value='${selectedPaymentItem.unitPrice}' type='currency' currencySymbol='₫'/>">
        </div>
    </c:if>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="<c:url value='/js/booking-page.js'/>"></script>
    <script>
        // Initialize page - check if service is pre-selected
        function initializePage() {
            const preSelectedData = document.getElementById('preSelectedServiceData');
            if (preSelectedData) {
                // Pre-populate selectedPaymentItem from server data
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

                // Check if function is available and initialize
                if (typeof initializePreSelectedService === 'function') {
                    initializePreSelectedService(paymentItemData);
                }
            }
        }

        // Multiple initialization attempts to ensure reliability
        document.addEventListener('DOMContentLoaded', function() {
            // Wait for external script to load
            let attempts = 0;
            const maxAttempts = 10;

            function tryInitialize() {
                attempts++;
                if (typeof initializePreSelectedService !== 'undefined') {
                    initializePage();
                } else if (attempts < maxAttempts) {
                    setTimeout(tryInitialize, 50);
                } else {
                    console.error('Failed to load booking-page.js functions after', maxAttempts, 'attempts');
                }
            }

            tryInitialize();
        });
    </script>
</body>
</html>