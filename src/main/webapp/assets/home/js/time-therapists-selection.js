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
    let modalSelectedTherapist = null; // Selected therapist for current time slot
    let currentModalDate = new Date(); // For calendar navigation
    let selectedCalendarDate = null; // Currently selected date in calendar
    
    // Configuration
    const config = {
        bufferTime: 10, // 10 minutes buffer between appointments
        workingHours: {
            start: '07:00',
            end: '19:00'
        },
        timeSlotInterval: 30, // 30 minutes
        maxDaysAhead: 30,
        apiEndpoints: {
            availability: '/api/availability',
            therapistSchedules: '/api/therapist-schedules',
            saveDateTime: '/process-booking/save-time-therapists'
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
        
        // Render services immediately for faster loading
                renderServicesList();
                setupEventListeners();
        updateContinueButton();
        
        // Hide loading state immediately since basic functionality is ready
        if (window.hideLoadingState) {
            setTimeout(() => {
                window.hideLoadingState();
            }, 50); // Very fast loading
        }
        
        // Load availability data in background for enhanced features
        loadAvailabilityData()
            .then(() => {
                console.log('✅ Background availability data loaded');
                // Update any UI that depends on availability data
                updateContinueButton();
            })
            .catch(error => {
                console.warn('⚠️ Background availability loading failed:', error);
                // Basic functionality still works without this data
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
    
    // Load availability data from API using CSPSolver
    async function loadAvailabilityData() {
        try {
            // Load calendar availability for current month
            const currentDate = new Date();
            const year = currentDate.getFullYear();
            const month = currentDate.getMonth() + 1;
            
            // Get service IDs for availability checking
            const serviceIds = selectedServices.map(service => service.serviceId).join(',');
            
            const availabilityResponse = await fetch(
                `${window.bookingData.contextPath}/api/availability?action=calendar&year=${year}&month=${month}&serviceIds=${serviceIds}`
            );
            
            if (availabilityResponse.ok) {
                const data = await availabilityResponse.json();
                if (data.success) {
                    availabilityData = data;
                    console.log('📊 Calendar availability data loaded:', data);
                } else {
                    throw new Error(data.message || 'Failed to load availability data');
                }
            } else {
                throw new Error(`HTTP ${availabilityResponse.status}: ${availabilityResponse.statusText}`);
            }
            
        } catch (error) {
            console.warn('⚠️ Could not load availability data, using fallback:', error);
            // Use fallback data for development
            loadFallbackData();
        }
    }

    // Load availability for a specific month
    async function loadMonthAvailability(year, month) {
        try {
            // When in modal context, use only the current modal service
            // Otherwise, use all selected services for overview
            let serviceIds;
            if (currentModalService) {
                // In modal: show availability for just this service
                serviceIds = currentModalService.serviceId.toString();
                console.log(`📅 Loading calendar for specific service: ${currentModalService.serviceName} (ID: ${currentModalService.serviceId})`);
            } else {
                // Overview: show availability across all services
                serviceIds = selectedServices.map(service => service.serviceId).join(',');
                console.log(`📅 Loading calendar for all services: ${serviceIds}`);
            }
            
            const response = await fetch(
                `${window.bookingData.contextPath}/api/availability?action=calendar&year=${year}&month=${month}&serviceIds=${serviceIds}`
            );
            
            if (response.ok) {
                const data = await response.json();
                if (data.success) {
                    return data;
                }
            }
            throw new Error('Failed to load month availability');
        } catch (error) {
            console.error('Error loading month availability:', error);
            return null;
        }
    }

    // Load time slots for a specific date and service
    async function loadTimeSlots(serviceId, date) {
        try {
            console.log(`🔍 DEBUG: Loading time slots for service ${serviceId} on ${date}`);
            const response = await fetch(
                `${window.bookingData.contextPath}/api/availability?action=time-slots&serviceId=${serviceId}&date=${date}`
            );
            
            if (response.ok) {
                const data = await response.json();
                console.log(`🔍 DEBUG: API response for service ${serviceId}:`, data);
                
                if (data.success && data.timeSlots && data.timeSlots.length > 0) {
                    // Ensure all time slots have therapist data
                    const enhancedTimeSlots = data.timeSlots.map(slot => {
                        if (!slot.availableTherapists || slot.availableTherapists.length === 0) {
                            console.log(`🔍 DEBUG: Adding fallback therapist for slot ${slot.time}`);
                            slot.availableTherapists = [
                                {
                                    therapistId: 1,
                                    therapistName: 'Nhà trị liệu có sẵn'
                                }
                            ];
                            slot.therapistCount = 1;
                        }
                        return slot;
                    });
                    
                    console.log(`🔍 DEBUG: Enhanced time slots with therapist data:`, enhancedTimeSlots);
                    return enhancedTimeSlots;
                }
            }
            throw new Error('Failed to load time slots or empty response');
        } catch (error) {
            console.error('Error loading time slots:', error);
            return [];
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
        
        console.log(`🔍 DEBUG: getSelectedDateTimeDisplay for service ${serviceId}:`, selection);
        console.log(`🔍 DEBUG: therapist data in selection:`, selection.therapist);
        
        const dateObj = new Date(selection.date);
        const formattedDate = dateObj.toLocaleDateString('vi-VN', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
        
        // Calculate end time based on service duration
        const serviceDuration = selection.service.estimatedDuration || selection.service.duration || 60;
        const endTime = addMinutes(selection.time, serviceDuration);
        
        let therapistDisplay = '';
        if (selection.therapist) {
            console.log(`🔍 DEBUG: Found therapist in selection:`, selection.therapist);
            console.log(`🔍 DEBUG: therapistName:`, selection.therapist.therapistName);
            therapistDisplay = `<div class="datetime-therapist">Nhà trị liệu: ${selection.therapist.therapistName}</div>`;
            console.log(`🔍 DEBUG: Generated therapistDisplay HTML:`, therapistDisplay);
        } else {
            console.log(`🔍 DEBUG: No therapist data found in selection for service ${serviceId}`);
            console.log(`🔍 DEBUG: selection.therapist value:`, selection.therapist, 'type:', typeof selection.therapist);
        }
        
        const finalHTML = `
            <div class="datetime-info">
                <iconify-icon icon="material-symbols:event" class="datetime-icon"></iconify-icon>
                <div class="datetime-details">
                    <div class="datetime-date">${formattedDate}</div>
                    <div class="datetime-time">Thời gian: ${selection.time} - ${endTime}</div>
                    ${therapistDisplay}
                </div>
            </div>
        `;
        
        console.log(`🔍 DEBUG: Final HTML for service ${serviceId}:`, finalHTML);
        return finalHTML;
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
            modalSelectedTherapist = null;
            selectedCalendarDate = null;
            currentModalDate = new Date(); // Current month
        }
        
        // Show modal
        document.getElementById('calendarModal').classList.add('open');
        document.body.style.overflow = 'hidden'; // Prevent background scrolling
        
        // Initialize custom calendar after modal is visible
        setTimeout(async () => {
            await initializeCustomCalendar();
            bindCalendarEvents();
            
            // If we have existing selection, show its time slots
            if (existingSelection) {
                await showModalTimeSlots(existingSelection.date);
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
        document.body.style.overflow = ''; // Restore scrolling
        currentModalService = null;
        modalSelectedDate = null;
        modalSelectedTime = null;
        modalSelectedTherapist = null;
        selectedCalendarDate = null;
    }
    
    // Initialize custom calendar
    async function initializeCustomCalendar() {
        updateMonthDisplay();
        await updateCalendarDays();
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
    
    // Update calendar days grid with availability from CSPSolver
    async function updateCalendarDays() {
        const calendarDaysEl = document.getElementById('calendarDays');
        if (!calendarDaysEl) return;
        
        console.log(`🔍 DEBUG: Starting updateCalendarDays, initial classes=${calendarDaysEl.className}`);
        
        // Show loading state
        calendarDaysEl.classList.add('calendar-loading');
        console.log(`🔍 DEBUG: Added loading state, classes=${calendarDaysEl.className}`);
        
        const days = getDaysInMonth(currentModalDate);
        calendarDaysEl.innerHTML = '';
        
        // Load availability data for the current month
        const year = currentModalDate.getFullYear();
        const month = currentModalDate.getMonth() + 1;
        const monthAvailability = await loadMonthAvailability(year, month);
        
        // Create a map of availability by date
        const availabilityMap = {};
        if (monthAvailability && monthAvailability.days) {
            monthAvailability.days.forEach(day => {
                availabilityMap[day.date] = day;
            });
        }
        
        days.forEach((day) => {
            const dayButton = document.createElement('button');
            dayButton.className = 'calendar-day';
            dayButton.textContent = day.date;

            if (!day.isCurrentMonth) {
                dayButton.disabled = true;
                dayButton.classList.add('other-month');
            } else {
                const dateStr = day.fullDate.toISOString().split('T')[0];
                const isToday = isDateToday(day.fullDate);
                const isSelected = isDateSelected(day.fullDate);
                
                // Apply availability status from API
                const dayAvailability = availabilityMap[dateStr];
                if (dayAvailability) {
                    dayButton.classList.add(dayAvailability.status);
                    
                    // Only disable actually past days or truly unavailable days
                    if (dayAvailability.status === 'past') {
                    dayButton.disabled = true;
                        dayButton.title = 'Ngày đã qua';
                    } else if (dayAvailability.status === 'fully-booked' && !isToday) {
                        dayButton.disabled = true;
                        dayButton.title = 'Hết chỗ trong ngày này';
                    } else if (!dayAvailability.available && !isToday) {
                        dayButton.disabled = true;
                        dayButton.title = 'Không có khung giờ khả dụng';
                    } else {
                        // For today or available days, always allow clicking
                        dayButton.disabled = false;
                        
                        // Add tooltip with availability info
                        if (dayAvailability.availableSlots > 0) {
                            dayButton.title = `${dayAvailability.availableSlots} khung giờ khả dụng`;
                        } else if (isToday) {
                            dayButton.title = 'Không còn khung giờ khả dụng hôm nay - nhấn để xem';
                        } else {
                            dayButton.title = 'Nhấn để kiểm tra khả dụng';
                        }
                    }
                } else {
                    // Fallback for dates without availability data
                    const today = new Date();
                    today.setHours(0, 0, 0, 0);
                    const isPast = day.fullDate < today;
                    if (isPast) {
                        dayButton.disabled = true;
                        dayButton.classList.add('past');
                    } else {
                        // Use the old availability check as fallback
                        const isAvailable = checkDateAvailability(dateStr, currentModalService);
                        if (!isAvailable) {
                            dayButton.disabled = true;
                            dayButton.classList.add('fully-booked');
                        } else {
                            dayButton.classList.add('available');
                        }
                    }
                }
                
                if (isToday) {
                    dayButton.classList.add('today');
                }
                
                if (isSelected) {
                    dayButton.classList.add('selected');
                }
                
                dayButton.addEventListener('click', (event) => {
                    console.log(`🔍 DEBUG: Button clicked for day ${day.date}, disabled=${dayButton.disabled}, classes=${dayButton.className}`);
                    if (!dayButton.disabled) {
                        handleCalendarDateClick(day);
                    } else {
                        console.log(`🔍 DEBUG: Click blocked - button is disabled`);
                    }
                });
            }

            calendarDaysEl.appendChild(dayButton);
        });
        
        // Remove loading state
        calendarDaysEl.classList.remove('calendar-loading');
        console.log(`🔍 DEBUG: Removed loading state from calendar, classes=${calendarDaysEl.className}`);
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
    async function handleCalendarDateClick(day) {
        console.log(`🔍 DEBUG: Calendar day clicked:`, day);
        console.log(`🔍 DEBUG: day.date = ${day.date}, day.fullDate = ${day.fullDate}, day.isCurrentMonth = ${day.isCurrentMonth}`);
        
        if (!day.isCurrentMonth) return;

        selectedCalendarDate = day.fullDate;
        // Fix timezone issue: format date locally instead of using toISOString()
        const year = day.fullDate.getFullYear();
        const month = String(day.fullDate.getMonth() + 1).padStart(2, '0');
        const dayNum = String(day.fullDate.getDate()).padStart(2, '0');
        modalSelectedDate = `${year}-${month}-${dayNum}`;
        
        console.log(`🔍 DEBUG: Selected calendar date: ${selectedCalendarDate}`);
        console.log(`🔍 DEBUG: Modal selected date (ISO): ${modalSelectedDate}`);
        
        // Update date input
        const dateInput = document.getElementById('datePicker');
        if (dateInput) {
            dateInput.value = day.fullDate.toLocaleDateString('vi-VN');
        }
        
        // Update calendar display
        await updateCalendarDays();
        
        // Show time slots
        await showModalTimeSlots(modalSelectedDate);
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
    async function navigateMonth(direction) {
        const newDate = new Date(currentModalDate);
        newDate.setMonth(currentModalDate.getMonth() + direction);
        currentModalDate = newDate;
        updateMonthDisplay();
        await updateCalendarDays();
    }
    
    // Show time slots for selected date using API
    async function showModalTimeSlots(dateStr) {
        console.log(`⏰ Showing time slots for: ${dateStr}`);
        
        const timeSlotsSection = document.getElementById('modalTimeSlots');
        const timeSlotsGrid = document.getElementById('modalTimeSlotsGrid');
        const infoSection = document.getElementById('timeSelectionInfo');
        
        if (!timeSlotsSection || !timeSlotsGrid) return;
        
        // Show loading state
        timeSlotsGrid.innerHTML = '<div class="loading-slots">Đang tải khung giờ...</div>';
        timeSlotsSection.style.display = 'block';
        
        // Show information section to help users understand the "trị liệu" numbers
        if (infoSection) {
            infoSection.style.display = 'block';
        }
        
        try {
            // Load time slots from API
            const timeSlots = await loadTimeSlots(currentModalService.serviceId, dateStr);
            
            console.log(`🔍 DEBUG: Received ${timeSlots.length} time slots from API for ${dateStr}:`, timeSlots);
            
            // Clear loading state
        timeSlotsGrid.innerHTML = '';
            
            if (timeSlots && timeSlots.length > 0) {
                console.log(`🔍 DEBUG: Rendering ${timeSlots.length} time slots...`);
                timeSlots.forEach((slot, index) => {
                    console.log(`🔍 DEBUG: Slot ${index}: ${slot.time} - Available: ${slot.available} - Therapists: ${slot.therapistCount} - Status: ${slot.status}`);
                    
                    const button = document.createElement('button');
                    button.className = `time-slot ${slot.available ? '' : 'disabled'}`;
                    
                    // Add status-specific classes for better styling
                    if (slot.status) {
                        button.classList.add(slot.status);
                    }
                    
                    // Check if this is the previously selected time
                    if (modalSelectedTime === slot.time) {
                        button.classList.add('selected');
                    }
                    
                    // Create time slot content with therapist info
                    const timeContent = document.createElement('div');
                    timeContent.className = 'time-slot-time';
                    timeContent.textContent = slot.time;
                    
                    let therapistInfo = document.createElement('div');
                    therapistInfo.className = 'time-slot-therapists';
                    
                    // Handle unavailable slots with clear messaging
                    if (!slot.available) {
                        // Update existing element instead of replacing
                        therapistInfo.className = 'time-slot-therapists therapist-info-display unavailable';
                        therapistInfo.innerHTML = `
                            <iconify-icon icon="material-symbols:block" width="12" height="12" style="margin-right: 2px; color: #dc2626;"></iconify-icon>
                            <span style="color: #dc2626; font-weight: 600;">${slot.statusMessage || 'Hết chỗ'}</span>
                        `;
                        
                        button.title = 'Khung giờ này đã đầy. Vui lòng chọn khung giờ khác.';
                        button.disabled = true;
                    }
                    // Check for conflicts with other selected services
                    else if (slot.available) {
                        const selectedDateTime = new Date(`${modalSelectedDate}T${slot.time}`);
                        const currentServiceDuration = currentModalService.estimatedDuration || 60;
                        
                        // Set therapist count info
                        if (slot.therapistCount > 0) {
                            // Update the existing element instead of replacing it
                            therapistInfo.className = 'time-slot-therapists therapist-info-display';
                            therapistInfo.innerHTML = `
                                <iconify-icon icon="material-symbols:person" width="12" height="12" style="margin-right: 2px;"></iconify-icon>
                                ${slot.statusMessage || slot.therapistCount + ' có sẵn'}
                            `;
                            
                            // Create tooltip text directly
                            const therapistTooltip = `${slot.therapistCount} nhà trị liệu có thể phục vụ trong khung giờ này. ${
                                slot.therapistCount > 3 ? 'Rất nhiều lựa chọn!' : 
                                slot.therapistCount > 1 ? 'Có nhiều lựa chọn nhà trị liệu.' : 
                                'Chỉ có 1 nhà trị liệu khả dụng.'
                            }`;
                            
                            // Add therapist count badge if more than 1
                            if (slot.therapistCount > 1) {
                                const countBadge = document.createElement('div');
                                countBadge.className = 'therapist-count';
                                countBadge.textContent = slot.therapistCount;
                                button.appendChild(countBadge);
                            }
                            
                            // Set enhanced tooltip
                            button.title = therapistTooltip;
                        } else {
                            therapistInfo.textContent = 'Không có';
                        }
                        
                        // Async conflict checking - will update UI when complete
                        // Store reference to avoid closure issues
                        const currentTherapistInfo = therapistInfo;
                        const originalTooltip = button.title;
                        
                        checkTimeConflicts(selectedDateTime, currentServiceDuration, currentModalService.serviceId)
                            .then(conflicts => {
                                if (conflicts.length > 0) {
                                    button.classList.add('conflict');
                                    button.title = `⚠️ Khung giờ này xung đột với: ${conflicts.map(c => c.serviceName).join(', ')}. Vui lòng chọn khung giờ khác.`;
                                    currentTherapistInfo.textContent = 'Xung đột';
                                } else {
                                    // Keep the enhanced tooltip that was set earlier
                                    if (!button.title || button.title.includes('nhà trị liệu khả dụng')) {
                                        button.title = originalTooltip;
                                    }
                                }
                            })
                            .catch(error => {
                                console.warn('Conflict check failed for slot:', slot.time, error);
                            });
                        
                        // Set initial title while conflict check is running
                        if (slot.therapistCount > 0) {
                            button.title = `${slot.therapistCount} nhà trị liệu khả dụng`;
                        }
                    }
                    
                    button.appendChild(timeContent);
                    button.appendChild(therapistInfo);
                    button.disabled = !slot.available;
                    
                    if (slot.available) {
                        button.onclick = () => selectModalTimeSlot(slot);
                    }
                    
                    timeSlotsGrid.appendChild(button);
                });
                
                console.log(`✅ DEBUG: Successfully rendered ${timeSlotsGrid.children.length} time slot buttons`);
            } else {
                // Fallback to generated time slots if API fails
                console.warn('No time slots from API, using fallback with mock therapist data');
                const fallbackSlots = generateTimeSlots(config.workingHours.start, config.workingHours.end, 30);
                const serviceDuration = currentModalService.duration || currentModalService.estimatedDuration || 60;
                
                fallbackSlots.forEach(slot => {
            const isAvailable = isTimeSlotAvailable(dateStr, slot, serviceDuration, currentModalService.serviceId);
            
            const button = document.createElement('button');
            button.className = `time-slot ${isAvailable ? '' : 'disabled'}`;
            
            if (modalSelectedTime === slot) {
                button.classList.add('selected');
            }
            
                    // Create time slot content with therapist info (similar to API version)
                    const timeContent = document.createElement('div');
                    timeContent.className = 'time-slot-time';
                    timeContent.textContent = slot;
                    
                    let therapistInfo = document.createElement('div');
                    therapistInfo.className = 'time-slot-therapists';
            
            if (isAvailable) {
                        // Mock therapist data for fallback with enhanced display
                        therapistInfo.className = 'time-slot-therapists therapist-info-display';
                        therapistInfo.innerHTML = `
                            <iconify-icon icon="material-symbols:person" width="12" height="12" style="margin-right: 2px;"></iconify-icon>
                            1 có sẵn
                        `;
                        
                        button.title = '1 nhà trị liệu có thể phục vụ trong khung giờ này. Chỉ có 1 nhà trị liệu khả dụng.';
                        
                        // Create mock therapist data for the slot
                        const mockTherapistSlot = {
                            time: slot,
                            available: true,
                            therapistCount: 1,
                            availableTherapists: [
                                {
                                    therapistId: 1,
                                    therapistName: 'Nhà trị liệu có sẵn'
                                }
                            ]
                        };
                        
                        button.onclick = () => selectModalTimeSlot(mockTherapistSlot);
                    } else {
                        therapistInfo.textContent = 'Không có';
                    }
                    
                    button.appendChild(timeContent);
                    button.appendChild(therapistInfo);
                    button.disabled = !isAvailable;
            
            timeSlotsGrid.appendChild(button);
        });
            }
            
        } catch (error) {
            console.error('Error loading time slots:', error);
            timeSlotsGrid.innerHTML = '<div class="error-message">Không thể tải khung giờ. Vui lòng thử lại.</div>';
        }
        
        // Update confirm button
        updateModalConfirmButton();
    }
    
    // Select time slot in modal
    async function selectModalTimeSlot(timeSlot) {
        console.log(`⏰ Modal time slot selected:`, timeSlot);
        
        // Handle both string and object timeSlot
        let timeStr, therapists;
        if (typeof timeSlot === 'string') {
            timeStr = timeSlot;
            therapists = [];
        } else {
            timeStr = timeSlot.time;
            therapists = timeSlot.availableTherapists || [];
        }
        
        console.log('🔍 DEBUG: selectModalTimeSlot function called - timeStr:', timeStr, 'therapists:', therapists);
        
        // 🔍 CONFLICT VALIDATION: Check for overlapping appointments
        const selectedDateTime = new Date(`${modalSelectedDate}T${timeStr}`);
        const currentServiceDuration = currentModalService.estimatedDuration || 60; // Default 60 minutes
        
        try {
            // Check if this time conflicts with other selected services using CSP
            const conflicts = await checkTimeConflicts(selectedDateTime, currentServiceDuration, currentModalService.serviceId);
            
            if (conflicts.length > 0) {
                const conflictMessages = conflicts.map(conflict => 
                    `• ${conflict.serviceName} (${conflict.time}) - ${conflict.type === 'csp' ? 'CSP' : 'Local'} conflict ${conflict.overlapMinutes !== 'Unknown' ? conflict.overlapMinutes + ' phút' : ''}`
                ).join('\n');
                
                showError(`❌ Thời gian đã chọn xung đột với các dịch vụ khác:\n\n${conflictMessages}\n\nVui lòng chọn thời gian khác hoặc thay đổi thời gian các dịch vụ đã chọn.`);
                return; // Don't allow selection
            }
        } catch (error) {
            console.warn('Conflict checking failed, proceeding with selection:', error);
            // Continue with selection if conflict checking fails
        }
        
        // Set selected time
        modalSelectedTime = timeStr;
        
        // If multiple therapists available, show therapist selection modal
        if (therapists.length > 1) {
            console.log('🔍 DEBUG: Multiple therapists available, showing therapist selection');
            showTherapistSelectionModal(timeStr, modalSelectedDate, therapists);
        } else if (therapists.length === 1) {
            // Auto-select the only available therapist
            console.log('🔍 DEBUG: Only one therapist available, auto-selecting:', therapists[0]);
            modalSelectedTherapist = therapists[0];
            console.log('🔍 DEBUG: Auto-selected therapist stored:', modalSelectedTherapist);
            updateModalConfirmButton();
        } else {
            // No therapist info available, continue with time selection only
            console.log('🔍 DEBUG: No therapist info available (therapists array length:', therapists.length, ')');
            modalSelectedTherapist = null;
            updateModalConfirmButton();
        }
        
        // Mark selected time slot
        const timeSlotsGrid = document.getElementById('modalTimeSlotsGrid');
        if (timeSlotsGrid) {
        timeSlotsGrid.querySelectorAll('.time-slot.selected').forEach(el => {
            el.classList.remove('selected');
        });
        
            const timeSlotButtons = timeSlotsGrid.querySelectorAll('.time-slot');
            timeSlotButtons.forEach((button) => {
                const buttonTimeText = button.querySelector('.time-slot-time')?.textContent || button.textContent;
                if (buttonTimeText.includes(timeStr)) {
                    button.classList.add('selected');
                }
            });
        }
    }
    
    // Show therapist selection modal
    function showTherapistSelectionModal(timeStr, dateStr, therapists) {
        console.log('🧑‍⚕️ Showing therapist selection modal for', timeStr, dateStr, therapists);
        
        // Store current selection context
        window.currentTherapistSelection = {
            timeStr: timeStr,
            dateStr: dateStr,
            therapists: therapists
        };
        
        // Update modal title
        const modalTitle = document.getElementById('therapistModalTitle');
        if (modalTitle) {
            modalTitle.textContent = `Chọn nhà trị liệu - ${currentModalService.serviceName}`;
        }
        
        // Update selected time display
        const selectedTimeDisplay = document.getElementById('selectedTimeDisplay');
        if (selectedTimeDisplay) {
            const dateObj = new Date(dateStr);
            const formattedDate = dateObj.toLocaleDateString('vi-VN', {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });
            selectedTimeDisplay.textContent = `${formattedDate} lúc ${timeStr}`;
        }
        
        // Populate therapist list
        const therapistList = document.getElementById('therapistList');
        if (therapistList) {
            therapistList.innerHTML = '';
            
            therapists.forEach(therapist => {
                const therapistCard = createTherapistCard(therapist);
                therapistList.appendChild(therapistCard);
            });
        }
        
        // Show therapist modal
        const therapistModal = document.getElementById('therapistModal');
        if (therapistModal) {
            therapistModal.classList.add('open');
            document.body.style.overflow = 'hidden'; // Prevent scrolling
        }
        
        // Reset confirmation button
        const confirmBtn = document.getElementById('therapistConfirmBtn');
        if (confirmBtn) {
            confirmBtn.disabled = true;
        }
    }
    
    // Create therapist card element
    function createTherapistCard(therapist) {
        const card = document.createElement('div');
        card.className = 'therapist-card';
        card.onclick = () => selectTherapist(therapist, card);
        
        // Get initials for avatar
        const initials = therapist.therapistName.split(' ')
            .map(name => name.charAt(0))
            .join('')
            .substring(0, 2);
        
        card.innerHTML = `
            <div class="therapist-header">
                <div class="therapist-avatar">${initials}</div>
                <div class="therapist-info">
                    <div class="therapist-name">${therapist.therapistName}</div>
                    <div class="therapist-specialty">Nhà trị liệu chuyên nghiệp</div>
                    <div class="therapist-rating">
                        <span class="rating-stars">★★★★★</span>
                        <span class="rating-text">5.0 (${Math.floor(Math.random() * 50) + 20} đánh giá)</span>
                    </div>
                    <div class="therapist-availability">✓ Có sẵn tại thời gian này</div>
                </div>
            </div>
        `;
        
        return card;
    }
    
    // Select therapist
    function selectTherapist(therapist, cardElement) {
        console.log('🧑‍⚕️ Therapist selected:', therapist);
        
        // Clear previous selections
        document.querySelectorAll('.therapist-card.selected').forEach(card => {
            card.classList.remove('selected');
        });
        
        // Mark current selection
        cardElement.classList.add('selected');
        
        // Store selected therapist
        modalSelectedTherapist = therapist;
        
        // Enable confirm button
        const confirmBtn = document.getElementById('therapistConfirmBtn');
        if (confirmBtn) {
            confirmBtn.disabled = false;
        }
    }
    
    // Close therapist modal
    function closeTherapistModal() {
        const therapistModal = document.getElementById('therapistModal');
        if (therapistModal) {
            therapistModal.classList.remove('open');
            document.body.style.overflow = ''; // Restore scrolling
        }
        
        // Only reset selections if no therapist was confirmed
        // This allows the selection to persist when user confirms a therapist
        if (!window.currentTherapistSelection || !window.currentTherapistSelection.selectedTherapist) {
            modalSelectedTherapist = null;
        }
        
        // Clean up the temporary selection context but preserve selected therapist
        if (window.currentTherapistSelection) {
            const selectedTherapist = window.currentTherapistSelection.selectedTherapist;
            window.currentTherapistSelection = null;
            // If we had a selected therapist, restore it to modalSelectedTherapist
            if (selectedTherapist) {
                modalSelectedTherapist = selectedTherapist;
                console.log('🔍 DEBUG: Restored modalSelectedTherapist from confirmed selection:', modalSelectedTherapist);
            }
        }
    }
    
    // Confirm therapist selection
    function confirmTherapistSelection() {
        if (!modalSelectedTherapist || !window.currentTherapistSelection) {
            console.error('No therapist selected');
            return;
        }
        
        console.log('✅ Confirming therapist selection:', modalSelectedTherapist);
        
        // Store the selected therapist in the window object for persistence
        window.currentTherapistSelection.selectedTherapist = modalSelectedTherapist;
        
        // Also ensure it's set for the main modal
        // Don't reset modalSelectedTherapist here - it should persist
        console.log('🔍 DEBUG: Therapist saved to window.currentTherapistSelection.selectedTherapist:', modalSelectedTherapist);
        
        // Close therapist modal
        closeTherapistModal();
        
        // Update the main modal confirm button
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
        console.log('🧑‍⚕️ Selected therapist:', modalSelectedTherapist);
        console.log('🔍 DEBUG: modalSelectedTherapist type:', typeof modalSelectedTherapist, 'value:', modalSelectedTherapist);
        
        // Ensure we have therapist data - provide fallback if missing
        let therapistToSave = modalSelectedTherapist;
        if (!therapistToSave) {
            console.log('🔍 DEBUG: No therapist selected, checking window.currentTherapistSelection');
            // Check if there's a therapist selection from the therapist modal
            if (window.currentTherapistSelection && window.currentTherapistSelection.selectedTherapist) {
                console.log('🔍 DEBUG: Found therapist in window.currentTherapistSelection');
                therapistToSave = window.currentTherapistSelection.selectedTherapist;
            } else {
                console.log('🔍 DEBUG: Providing fallback therapist');
                therapistToSave = {
                    therapistId: 1,
                    therapistName: 'Nhà trị liệu có sẵn'
                };
            }
        }
        
        // Save the selection including therapist info
        const selectionData = {
            date: modalSelectedDate,
            time: modalSelectedTime,
            service: currentModalService,
            therapist: therapistToSave
        };
        
        console.log('🔍 DEBUG: About to save selection data:', selectionData);
        serviceTimeSelections[currentModalService.serviceId] = selectionData;
        
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
        console.log(`🔍 DEBUG: updateServiceCard called for service ${serviceId}`);
        const serviceCard = document.querySelector(`.service-card:has(.calendar-icon-btn[onclick*="${serviceId}"])`);
        console.log(`🔍 DEBUG: serviceCard found:`, serviceCard);
        if (!serviceCard) {
            console.log(`🔍 DEBUG: No service card found for service ${serviceId}`);
            return;
        }
        
        // Mark as completed
        serviceCard.classList.add('completed');
        console.log(`🔍 DEBUG: Added completed class to service card`);
        
        // Show selected datetime
        const serviceContent = serviceCard.querySelector('.service-content');
        const selectedDateTime = serviceCard.querySelector(`#selectedDateTime_${serviceId}`);
        
        console.log(`🔍 DEBUG: serviceContent found:`, serviceContent);
        console.log(`🔍 DEBUG: selectedDateTime element found:`, selectedDateTime);
        
        if (serviceContent && selectedDateTime) {
            serviceContent.style.display = 'block';
            const dateTimeHTML = getSelectedDateTimeDisplay(serviceId);
            console.log(`🔍 DEBUG: About to set innerHTML with:`, dateTimeHTML);
            selectedDateTime.innerHTML = dateTimeHTML;
            console.log(`🔍 DEBUG: innerHTML set successfully, new content:`, selectedDateTime.innerHTML);
        } else {
            console.log(`🔍 DEBUG: Missing elements - serviceContent: ${!!serviceContent}, selectedDateTime: ${!!selectedDateTime}`);
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
            
            // Add therapist selections for each service
            for (const [serviceId, selection] of Object.entries(serviceTimeSelections)) {
                if (selection.therapist && selection.therapist.therapistId) {
                    const therapistParam = `${selection.therapist.therapistId}_${selection.therapist.therapistName}`;
                    formData.append(`therapist_${serviceId}`, therapistParam);
                }
            }
            
            console.log('📤 Sending date/time and therapist data to server:', {
                selectedDate: firstSelection.date,
                selectedTime: firstSelection.time,
                therapistSelections: Object.entries(serviceTimeSelections).map(([serviceId, sel]) => ({
                    serviceId,
                    therapist: sel.therapist
                }))
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
                console.log('✅ Time and therapist selections saved successfully');
                // Navigate to next step based on server response
                const nextStep = result.nextStep || 'payment';
                window.location.href = `${window.bookingData.contextPath}/process-booking/${nextStep}`;
            } else {
                showError('Lỗi lưu thông tin đã chọn: ' + (result.message || 'Unknown error'));
            }
            
        } catch (error) {
            console.error('❌ Error saving time and therapist selections:', error);
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
    
    // Check for time conflicts between services using CSP solver
    async function checkTimeConflicts(selectedDateTime, serviceDuration, currentServiceId) {
        console.log('🔍 Checking time conflicts using CSP solver...');
        
        const conflicts = [];
        
        // First check local overlaps (fast)
        for (const [serviceId, selection] of Object.entries(serviceTimeSelections)) {
            // Skip checking against the same service
            if (parseInt(serviceId) === currentServiceId) {
                continue;
            }
            
            const existingDateTime = new Date(`${selection.date}T${selection.time}`);
            const existingDuration = selection.service.estimatedDuration || 60;
            
            // Calculate time ranges
            const selectedStartTime = selectedDateTime.getTime();
            const selectedEndTime = selectedStartTime + (serviceDuration * 60 * 1000);
            
            const existingStartTime = existingDateTime.getTime();
            const existingEndTime = existingStartTime + (existingDuration * 60 * 1000);
            
            // Check for overlap
            const hasOverlap = selectedStartTime < existingEndTime && selectedEndTime > existingStartTime;
            
            if (hasOverlap) {
                // Calculate overlap duration in minutes
                const overlapStart = Math.max(selectedStartTime, existingStartTime);
                const overlapEnd = Math.min(selectedEndTime, existingEndTime);
                const overlapMinutes = Math.round((overlapEnd - overlapStart) / (60 * 1000));
                
                conflicts.push({
                    serviceId: serviceId,
                    serviceName: selection.service.serviceName,
                    time: selection.time,
                    overlapMinutes: overlapMinutes,
                    type: 'local'
                });
            }
        }
        
        // Then check CSP constraints for more complex conflicts
        try {
            const cspConflicts = await checkCSPConflicts(
                currentServiceId, 
                selectedDateTime.toISOString().split('T')[0], // date
                Object.values(serviceTimeSelections)
            );
            
            if (cspConflicts && cspConflicts.length > 0) {
                conflicts.push(...cspConflicts.map(conflict => ({
                    ...conflict,
                    type: 'csp'
                })));
            }
        } catch (error) {
            console.warn('CSP conflict checking failed, using local checking only:', error);
        }
        
        return conflicts;
    }

    // Call CSP API for advanced conflict checking
    async function checkCSPConflicts(serviceId, date, currentSelections) {
        try {
            const currentSelectionsJson = JSON.stringify(
                Object.fromEntries(
                    currentSelections.map(sel => [
                        sel.serviceId || serviceId, 
                        { date: sel.date, time: sel.time }
                    ])
                )
            );
            
            const url = `/spa/api/time-conflicts?action=check-conflicts&serviceId=${serviceId}&date=${date}&currentSelections=${encodeURIComponent(currentSelectionsJson)}`;
            
            console.log('🔗 Calling CSP API:', url);
            
            const response = await fetch(url);
            const data = await response.json();
            
            if (data.success && data.conflictingSlots) {
                console.log('📊 CSP conflicts found:', data.conflictingSlots);
                return data.conflictingSlots.map(conflict => ({
                    serviceId: serviceId,
                    time: conflict.time,
                    serviceName: `Service ${serviceId}`,
                    message: conflict.reason,
                    dateTime: conflict.dateTime,
                    overlapMinutes: 'Unknown'
                }));
            }
            
            return [];
        } catch (error) {
            console.error('Error checking CSP conflicts:', error);
            return [];
        }
    }
    
    // Show error message
    function showError(message) {
        // Enhanced error display with better formatting
        const isConflictError = message.includes('❌');
        
        if (isConflictError) {
            // For conflict errors, use a more detailed alert
            alert(message);
        } else {
            // For other errors, use simple alert
        alert(message);
        }
    }
    
    // Global functions for onclick handlers
    window.openCalendarModal = openCalendarModal;
    window.closeCalendarModal = closeCalendarModal;
    window.confirmTimeSelection = confirmTimeSelection;
    window.closeTherapistModal = closeTherapistModal;
    window.confirmTherapistSelection = confirmTherapistSelection;
    
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