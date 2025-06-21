// Enhanced Time Selection with Service-Specific Calendar Pickers using Flatpickr
console.log('📅 Enhanced Time Selection JS Loading...');

// Time Selection Module
window.TimeSelection = (function() {
    'use strict';
    
    // State management
    let selectedServices = [];
    let serviceTimeSelections = {};
    let availabilityData = {};
    let therapistSchedules = {};
    let existingBookings = {};
    let currentModalService = null;
    let modalSelectedDate = null;
    let modalSelectedTime = null;
    let currentModalDate = new Date(); // For calendar navigation
    let selectedCalendarDate = null; // Currently selected date in calendar
    
    // Configuration
    const config = {
        bufferTime: 10, // 10 minutes buffer between appointments
        workingHours: {
            start: '08:00',
            end: '18:00'
        },
        timeSlotInterval: 30, // 30 minutes
        maxDaysAhead: 30,
        apiEndpoints: {
            availability: '/api/availability',
            therapistSchedules: '/api/therapist-schedules',
            saveDateTime: '/process-booking/save-time'
        }
    };
    
    // Vietnamese localization
    const vietnameseLocale = {
        dayNames: ['Chủ nhật', 'Thứ hai', 'Thứ ba', 'Thứ tư', 'Thứ năm', 'Thứ sáu', 'Thứ bảy'],
        monthNames: [
            'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
            'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'
        ]
    };
    
    // Vietnamese months for display
    const vietnameseMonths = [
        'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
        'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'
    ];
    
    // Utility Functions
    function formatCurrency(amount) {
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(amount);
    }
    
    function formatDuration(minutes) {
        const hours = Math.floor(minutes / 60);
        const mins = minutes % 60;
        if (hours > 0 && mins > 0) {
            return `${hours}h ${mins}p`;
        } else if (hours > 0) {
            return `${hours}h`;
        } else {
            return `${mins}p`;
        }
    }
    
    function generateTimeSlots(startTime, endTime, interval = 30) {
        const slots = [];
        const start = new Date(`2000-01-01T${startTime}:00`);
        const end = new Date(`2000-01-01T${endTime}:00`);
        
        for (let time = new Date(start); time <= end; time.setMinutes(time.getMinutes() + interval)) {
            slots.push(time.toTimeString().slice(0, 5));
        }
        
        return slots;
    }
    
    function addMinutes(timeStr, minutes) {
        const time = new Date(`2000-01-01T${timeStr}:00`);
        time.setMinutes(time.getMinutes() + minutes);
        return time.toTimeString().slice(0, 5);
    }
    
    function isTimeSlotAvailable(date, startTime, durationMinutes, serviceId) {
        const endTime = addMinutes(startTime, durationMinutes + config.bufferTime);
        
        // Check therapist schedules and existing bookings
        return checkServiceAvailability(date, startTime, endTime, serviceId);
    }
    
    function checkServiceAvailability(date, startTime, endTime, serviceId) {
        // Simulated availability check - replace with actual API call
        const dateKey = date;
        const unavailableSlots = existingBookings[dateKey] || [];
        
        // Simple overlap check
        for (const booking of unavailableSlots) {
            if (booking.serviceId === serviceId) {
                if (startTime < booking.endTime && endTime > booking.startTime) {
                    return false;
                }
            }
        }
        
        return true;
    }
    
    // Check if a date has available time slots for a service
    function checkDateAvailability(dateStr, service) {
        const timeSlots = generateTimeSlots(config.workingHours.start, config.workingHours.end, config.timeSlotInterval);
        const serviceDuration = service.duration || service.estimatedDuration || 60;
        
        // Check if any time slot can accommodate this service
        for (const slot of timeSlots) {
            if (isTimeSlotAvailable(dateStr, slot, serviceDuration, service.serviceId)) {
                return true;
            }
        }
        
        return false;
    }
    
    // Initialize the module
    function init() {
        console.log('🚀 Initializing Enhanced Time Selection...');
        
        // Get booking data from window object
        if (!window.bookingData || !window.bookingData.selectedServices) {
            console.error('❌ No booking data found');
            showError('Không tìm thấy dữ liệu dịch vụ đã chọn');
            return;
        }
        
        selectedServices = window.bookingData.selectedServices;
        console.log('📋 Selected services:', selectedServices);
        
        // Load any existing time selections from session data
        loadExistingSelections();
        
        // Load availability data
        loadAvailabilityData()
            .then(() => {
                renderServicesList();
                setupEventListeners();
                updateContinueButton();
            })
            .catch(error => {
                console.error('❌ Error loading availability data:', error);
                // Continue with basic functionality
                renderServicesList();
                setupEventListeners();
            });
        
        console.log('✅ Time Selection initialized successfully');
    }
    
    // Load existing time selections from session data
    function loadExistingSelections() {
        if (window.bookingData.sessionData && window.bookingData.sessionData.selectedServices) {
            const services = window.bookingData.sessionData.selectedServices;
            services.forEach(service => {
                if (service.scheduledTime && service.selectedDate) {
                    serviceTimeSelections[service.serviceId] = {
                        date: service.selectedDate,
                        time: service.scheduledTime,
                        service: service
                    };
                    console.log(`🔄 Loaded existing selection for service ${service.serviceId}: ${service.selectedDate} ${service.scheduledTime}`);
                }
            });
        }
    }
    
    // Load availability data from API
    async function loadAvailabilityData() {
        try {
            // Load therapist schedules
            const schedulesResponse = await fetch(`${window.bookingData.contextPath}${config.apiEndpoints.therapistSchedules}`);
            if (schedulesResponse.ok) {
                therapistSchedules = await schedulesResponse.json();
            }
            
            // Load existing bookings for availability checking
            const availabilityResponse = await fetch(`${window.bookingData.contextPath}${config.apiEndpoints.availability}`);
            if (availabilityResponse.ok) {
                availabilityData = await availabilityResponse.json();
                existingBookings = availabilityData.bookings || {};
            }
            
            console.log('📊 Availability data loaded successfully');
        } catch (error) {
            console.warn('⚠️ Could not load availability data, using fallback:', error);
            // Use fallback data for development
            loadFallbackData();
        }
    }
    
    // Fallback data for development
    function loadFallbackData() {
        existingBookings = {
            '2025-06-22': [
                { serviceId: 1, startTime: '09:00', endTime: '10:30' },
                { serviceId: 2, startTime: '14:00', endTime: '15:00' }
            ],
            '2025-06-23': [
                { serviceId: 1, startTime: '10:00', endTime: '11:30' },
                { serviceId: 3, startTime: '15:00', endTime: '16:30' }
            ]
        };
    }
    
    // Render the services list with calendar icons
    function renderServicesList() {
        const container = document.getElementById('servicesList');
        if (!container) {
            console.error('❌ Services list container not found');
            return;
        }
        
        container.innerHTML = '';
        
        selectedServices.forEach((service, index) => {
            const serviceCard = createServiceCard(service, index);
            container.appendChild(serviceCard);
        });
        
        console.log(`📝 Rendered ${selectedServices.length} service cards`);
    }
    
    // Create service card HTML
    function createServiceCard(service, index) {
        const card = document.createElement('div');
        card.className = `service-card ${serviceTimeSelections[service.serviceId] ? 'completed' : ''}`;
        
        const duration = service.duration || service.estimatedDuration || 60;
        const price = service.price || service.estimatedPrice || 0;
        
        card.innerHTML = `
            <div class="service-header">
                <div class="service-info">
                    <h3 class="service-name">${service.serviceName || service.name}</h3>
                    <div class="service-details">
                        <span class="service-duration">
                            <iconify-icon icon="material-symbols:schedule"></iconify-icon>
                            ${formatDuration(duration)}
                        </span>
                        <span class="service-price">
                            <iconify-icon icon="material-symbols:payments"></iconify-icon>
                            ${formatCurrency(price)}
                        </span>
                    </div>
                </div>
                <button class="calendar-icon-btn" onclick="openCalendarModal(${service.serviceId})">
                    <iconify-icon icon="material-symbols:calendar-month" width="24" height="24"></iconify-icon>
                </button>
            </div>
            <div class="service-content" style="display: ${serviceTimeSelections[service.serviceId] ? 'block' : 'none'};">
                <div class="selected-datetime" id="selectedDateTime_${service.serviceId}">
                    ${getSelectedDateTimeDisplay(service.serviceId)}
                </div>
            </div>
        `;
        
        return card;
    }
    
    // Get selected date/time display
    function getSelectedDateTimeDisplay(serviceId) {
        const selection = serviceTimeSelections[serviceId];
        if (!selection) return '';
        
        const dateObj = new Date(selection.date);
        const formattedDate = dateObj.toLocaleDateString('vi-VN', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
        
        return `
            <div class="datetime-info">
                <iconify-icon icon="material-symbols:event" class="datetime-icon"></iconify-icon>
                <div class="datetime-details">
                    <div class="datetime-date">${formattedDate}</div>
                    <div class="datetime-time">Thời gian: ${selection.time}</div>
                </div>
            </div>
        `;
    }
    
    // Open calendar modal
    function openCalendarModal(serviceId) {
        currentModalService = selectedServices.find(s => s.serviceId === serviceId);
        if (!currentModalService) return;
        
        console.log(`📅 Opening calendar for service: ${currentModalService.serviceName || currentModalService.name}`);
        
        // Update modal title
        document.getElementById('modalTitle').textContent = `Chọn ngày cho ${currentModalService.serviceName || currentModalService.name}`;
        
        // Load existing selection if available
        const existingSelection = serviceTimeSelections[serviceId];
        if (existingSelection) {
            console.log(`🔄 Loading existing selection: ${existingSelection.date} ${existingSelection.time}`);
            modalSelectedDate = existingSelection.date;
            modalSelectedTime = existingSelection.time;
            
            // Set calendar to the month of existing selection
            const existingDate = new Date(existingSelection.date);
            currentModalDate = new Date(existingDate.getFullYear(), existingDate.getMonth(), 1);
            selectedCalendarDate = existingDate;
        } else {
            // Reset modal state for new selection
            modalSelectedDate = null;
            modalSelectedTime = null;
            selectedCalendarDate = null;
            currentModalDate = new Date(); // Current month
        }
        
        // Show modal
        document.getElementById('calendarModal').classList.add('open');
        
        // Initialize custom calendar after modal is visible
        setTimeout(() => {
            initializeCustomCalendar();
            bindCalendarEvents();
            
            // If we have existing selection, show its time slots
            if (existingSelection) {
                showModalTimeSlots(existingSelection.date);
                // Update date input display
                const dateInput = document.getElementById('datePicker');
                if (dateInput) {
                    dateInput.value = selectedCalendarDate.toLocaleDateString('vi-VN');
                }
            } else {
                // Hide time slots for new selection
                document.getElementById('modalTimeSlots').style.display = 'none';
            }
            
            updateModalConfirmButton();
        }, 100);
    }
    
    // Close calendar modal
    function closeCalendarModal() {
        document.getElementById('calendarModal').classList.remove('open');
        currentModalService = null;
        modalSelectedDate = null;
        modalSelectedTime = null;
        selectedCalendarDate = null;
    }
    
    // Initialize custom calendar
    function initializeCustomCalendar() {
        updateMonthDisplay();
        updateCalendarDays();
    }
    
    // Update month/year display
    function updateMonthDisplay() {
        const monthYearEl = document.getElementById('monthYear');
        if (monthYearEl) {
            monthYearEl.textContent = `${vietnameseMonths[currentModalDate.getMonth()]} ${currentModalDate.getFullYear()}`;
        }
    }
    
    // Get days in month for calendar grid
    function getDaysInMonth(date) {
        const year = date.getFullYear();
        const month = date.getMonth();
        const firstDay = new Date(year, month, 1);
        const lastDay = new Date(year, month + 1, 0);
        const daysInMonth = lastDay.getDate();
        const startingDayOfWeek = (firstDay.getDay() + 6) % 7; // Adjust for Monday start

        const days = [];

        // Previous month's trailing days
        const prevMonth = new Date(year, month - 1, 0);
        for (let i = startingDayOfWeek - 1; i >= 0; i--) {
            days.push({
                date: prevMonth.getDate() - i,
                isCurrentMonth: false,
                isPrevious: true,
                fullDate: new Date(year, month - 1, prevMonth.getDate() - i)
            });
        }

        // Current month's days
        for (let day = 1; day <= daysInMonth; day++) {
            days.push({
                date: day,
                isCurrentMonth: true,
                isPrevious: false,
                fullDate: new Date(year, month, day)
            });
        }

        // Next month's leading days
        const remainingDays = 42 - days.length;
        for (let day = 1; day <= remainingDays; day++) {
            days.push({
                date: day,
                isCurrentMonth: false,
                isPrevious: false,
                fullDate: new Date(year, month + 1, day)
            });
        }

        return days;
    }
    
    // Update calendar days grid
    function updateCalendarDays() {
        const calendarDaysEl = document.getElementById('calendarDays');
        if (!calendarDaysEl) return;
        
        const days = getDaysInMonth(currentModalDate);
        calendarDaysEl.innerHTML = '';
        
        days.forEach((day) => {
            const dayButton = document.createElement('button');
            dayButton.className = 'calendar-day';
            dayButton.textContent = day.date;

            if (!day.isCurrentMonth) {
                dayButton.disabled = true;
            } else {
                // Check if date is available
                const dateStr = day.fullDate.toISOString().split('T')[0];
                const isAvailable = checkDateAvailability(dateStr, currentModalService);
                const isPast = day.fullDate < new Date().setHours(0, 0, 0, 0);
                const isToday = isDateToday(day.fullDate);
                const isSelected = isDateSelected(day.fullDate);
                
                if (!isAvailable || isPast) {
                    dayButton.disabled = true;
                }
                
                if (isToday) {
                    dayButton.classList.add('today');
                }
                
                if (isSelected) {
                    dayButton.classList.add('selected');
                }
                
                dayButton.addEventListener('click', () => handleCalendarDateClick(day));
            }

            calendarDaysEl.appendChild(dayButton);
        });
    }
    
    // Check if date is today
    function isDateToday(date) {
        const today = new Date();
        return date.toDateString() === today.toDateString();
    }
    
    // Check if date is selected
    function isDateSelected(date) {
        if (!selectedCalendarDate) return false;
        return date.toDateString() === selectedCalendarDate.toDateString();
    }
    
    // Handle calendar date click
    function handleCalendarDateClick(day) {
        if (!day.isCurrentMonth) return;

        selectedCalendarDate = day.fullDate;
        modalSelectedDate = day.fullDate.toISOString().split('T')[0];
        
        // Update date input
        const dateInput = document.getElementById('datePicker');
        if (dateInput) {
            dateInput.value = day.fullDate.toLocaleDateString('vi-VN');
        }
        
        // Update calendar display
        updateCalendarDays();
        
        // Show time slots
        showModalTimeSlots(modalSelectedDate);
    }
    
    // Bind calendar events
    function bindCalendarEvents() {
        // Previous month button
        const prevBtn = document.getElementById('prevMonthBtn');
        if (prevBtn) {
            prevBtn.onclick = () => navigateMonth(-1);
        }
        
        // Next month button
        const nextBtn = document.getElementById('nextMonthBtn');
        if (nextBtn) {
            nextBtn.onclick = () => navigateMonth(1);
        }
        
        // Close modal when clicking backdrop
        const backdrop = document.querySelector('.calendar-backdrop');
        if (backdrop) {
            backdrop.onclick = closeCalendarModal;
        }
    }
    
    // Navigate month
    function navigateMonth(direction) {
        const newDate = new Date(currentModalDate);
        newDate.setMonth(currentModalDate.getMonth() + direction);
        currentModalDate = newDate;
        updateMonthDisplay();
        updateCalendarDays();
    }
    
    // Show time slots for selected date
    function showModalTimeSlots(dateStr) {
        console.log(`⏰ Showing time slots for: ${dateStr}`);
        
        const timeSlotsSection = document.getElementById('modalTimeSlots');
        const timeSlotsGrid = document.getElementById('modalTimeSlotsGrid');
        
        if (!timeSlotsSection || !timeSlotsGrid) return;
        
        // Generate time slots
        const timeSlots = generateTimeSlots(config.workingHours.start, config.workingHours.end, config.timeSlotInterval);
        const serviceDuration = currentModalService.duration || currentModalService.estimatedDuration || 60;
        
        // Clear existing slots
        timeSlotsGrid.innerHTML = '';
        timeSlots.forEach(slot => {
            const isAvailable = isTimeSlotAvailable(dateStr, slot, serviceDuration, currentModalService.serviceId);
            
            const button = document.createElement('button');
            button.className = `time-slot ${isAvailable ? '' : 'disabled'}`;
            
            // Check if this is the previously selected time
            if (modalSelectedTime === slot) {
                button.classList.add('selected');
            }
            
            button.textContent = slot;
            button.disabled = !isAvailable;
            
            if (isAvailable) {
                button.onclick = () => selectModalTimeSlot(slot);
            }
            
            timeSlotsGrid.appendChild(button);
        });
        
        // Show the time slots section
        timeSlotsSection.style.display = 'block';
        
        // Update confirm button
        updateModalConfirmButton();
    }
    
    // Select time slot in modal
    function selectModalTimeSlot(timeStr) {
        console.log(`⏰ Modal time slot selected: ${timeStr}`);
        
        // Clear previous selections
        const timeSlotsGrid = document.getElementById('modalTimeSlotsGrid');
        timeSlotsGrid.querySelectorAll('.time-slot.selected').forEach(el => {
            el.classList.remove('selected');
        });
        
        // Mark selected time slot
        event.target.classList.add('selected');
        modalSelectedTime = timeStr;
        
        // Update confirm button
        updateModalConfirmButton();
    }
    
    // Update modal confirm button
    function updateModalConfirmButton() {
        const confirmBtn = document.getElementById('modalConfirmBtn');
        if (!confirmBtn) return;
        
        confirmBtn.disabled = !modalSelectedDate || !modalSelectedTime;
        
        if (modalSelectedDate && modalSelectedTime) {
            confirmBtn.textContent = `Xác nhận ${modalSelectedTime}`;
        } else {
            confirmBtn.textContent = 'Xác nhận';
        }
    }
    
    // Confirm time selection
    function confirmTimeSelection() {
        if (!currentModalService || !modalSelectedDate || !modalSelectedTime) return;
        
        console.log(`✅ Confirming selection: ${modalSelectedDate} ${modalSelectedTime} for ${currentModalService.serviceName}`);
        
        // Save the selection
        serviceTimeSelections[currentModalService.serviceId] = {
            date: modalSelectedDate,
            time: modalSelectedTime,
            service: currentModalService
        };
        
        // Update service card
        updateServiceCard(currentModalService.serviceId);
        
        // Close modal
        closeCalendarModal();
        
        // Update continue button
        updateContinueButton();
        
        console.log('📝 Updated service time selections:', serviceTimeSelections);
    }
    
    // Update service card after selection
    function updateServiceCard(serviceId) {
        const serviceCard = document.querySelector(`.service-card:has(.calendar-icon-btn[onclick*="${serviceId}"])`);
        if (!serviceCard) return;
        
        // Mark as completed
        serviceCard.classList.add('completed');
        
        // Show selected datetime
        const serviceContent = serviceCard.querySelector('.service-content');
        const selectedDateTime = serviceCard.querySelector(`#selectedDateTime_${serviceId}`);
        
        if (serviceContent && selectedDateTime) {
            serviceContent.style.display = 'block';
            selectedDateTime.innerHTML = getSelectedDateTimeDisplay(serviceId);
        }
    }
    
    // Update continue button state
    function updateContinueButton() {
        const continueBtn = document.getElementById('continueBtn');
        if (!continueBtn) return;
        
        const allServicesSelected = selectedServices.every(service => 
            serviceTimeSelections[service.serviceId]
        );
        
        continueBtn.disabled = !allServicesSelected;
        
        if (allServicesSelected) {
            continueBtn.innerHTML = `
                <iconify-icon icon="material-symbols:arrow-forward"></iconify-icon>
                Tiếp tục đến bước tiếp theo
            `;
            continueBtn.onclick = proceedToNextStep;
        } else {
            const remaining = selectedServices.length - Object.keys(serviceTimeSelections).length;
            continueBtn.innerHTML = `
                <iconify-icon icon="material-symbols:schedule"></iconify-icon>
                Còn ${remaining} dịch vụ chưa chọn thời gian
            `;
        }
    }
    
    // Proceed to next step
    async function proceedToNextStep() {
        console.log('🚀 Proceeding to next step with selections:', serviceTimeSelections);
        
        // Validate that all services have time selections
        const allServicesSelected = selectedServices.every(service => 
            serviceTimeSelections[service.serviceId]
        );
        
        if (!allServicesSelected) {
            showError('Vui lòng chọn thời gian cho tất cả dịch vụ');
            return;
        }
        
        try {
            // Get the first service's date and time (all services should use same start date/time)
            const firstSelection = Object.values(serviceTimeSelections)[0];
            if (!firstSelection || !firstSelection.date || !firstSelection.time) {
                showError('Không tìm thấy thông tin thời gian đã chọn');
                return;
            }
            
            // Prepare form data for server (backend expects form parameters, not JSON)
            const formData = new URLSearchParams();
            formData.append('selectedDate', firstSelection.date);
            formData.append('selectedTime', firstSelection.time);
            
            console.log('📤 Sending date/time to server:', {
                selectedDate: firstSelection.date,
                selectedTime: firstSelection.time
            });
            
            // Save to server
            const response = await fetch(`${window.bookingData.contextPath}${config.apiEndpoints.saveDateTime}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: formData,
                credentials: 'same-origin'
            });
            
            const result = await response.json();
            
            if (result.success) {
                console.log('✅ Time saved successfully');
                // Navigate to next step (therapist selection)
                window.location.href = `${window.bookingData.contextPath}/process-booking/therapists`;
            } else {
                showError('Lỗi lưu thời gian đã chọn: ' + (result.message || 'Unknown error'));
            }
            
        } catch (error) {
            console.error('❌ Error saving time selections:', error);
            showError('Lỗi kết nối. Vui lòng thử lại.');
        }
    }
    
    // Setup event listeners
    function setupEventListeners() {
        // Modal close on backdrop click
        document.getElementById('calendarModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeCalendarModal();
            }
        });
        
        console.log('🎧 Event listeners setup complete');
    }
    
    // Show error message
    function showError(message) {
        // You could implement a toast notification or modal here
        alert(message);
    }
    
    // Global functions for onclick handlers
    window.openCalendarModal = openCalendarModal;
    window.closeCalendarModal = closeCalendarModal;
    window.confirmTimeSelection = confirmTimeSelection;
    
    // Public API
    return {
        init: init,
        openCalendarModal: openCalendarModal,
        closeCalendarModal: closeCalendarModal,
        confirmTimeSelection: confirmTimeSelection,
        getSelections: () => serviceTimeSelections,
        clearSelections: () => {
            serviceTimeSelections = {};
            updateContinueButton();
        }
    };
    
})();

// Auto-initialize when script loads
console.log('✅ Enhanced Time Selection JS with Flatpickr loaded successfully'); 