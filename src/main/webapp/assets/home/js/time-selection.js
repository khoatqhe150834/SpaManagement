// Time Selection with FullCalendar Integration
console.log('🗓️ FullCalendar Time Selection JS Loading...');

// State management
let calendar;
let selectedDate = null;
let selectedTimeSlot = null;
let availableTimeSlots = [
    '08:00', '08:30', '09:00', '09:30', '10:00', '10:30',
    '11:00', '11:30', '12:00', '12:30', '13:00', '13:30',
    '14:00', '14:30', '15:00', '15:30', '16:00', '16:30',
    '17:00', '17:30', '18:00', '18:30'
];

// Unavailable slots (simulated data - in real app this would come from API)
let unavailableSlots = {
    '2025-06-20': ['09:00', '10:00', '14:00', '15:00'],
    '2025-06-21': ['08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00'], // Fully booked
    '2025-06-22': ['12:00', '13:00', '16:00'],
    '2025-06-23': ['08:00', '09:00', '17:00', '18:00'],
    '2025-06-24': ['10:00', '11:00', '15:00'],
    '2025-06-25': ['08:30', '14:30', '16:30'],
    '2025-06-26': []
};

// Vietnamese day names for FullCalendar
const vietnameseDayNames = {
    0: 'Chủ nhật',
    1: 'Thứ hai', 
    2: 'Thứ ba',
    3: 'Thứ tư',
    4: 'Thứ năm',
    5: 'Thứ sáu',
    6: 'Thứ bảy'
};

const vietnameseMonthNames = [
    'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
    'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'
];

// Initialize FullCalendar
function initializeCalendar() {
    const calendarEl = document.getElementById('fullcalendar');
    
    calendar = new FullCalendar.Calendar(calendarEl, {
        // Basic configuration
        initialView: 'dayGridMonth',
        locale: 'vi', // Vietnamese locale
        firstDay: 1, // Monday first
        height: 'auto',
        
        // Header configuration
        headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth'
        },
        
        // Custom button text
        buttonText: {
            today: 'Hôm nay',
            month: 'Tháng',
            prev: '‹',
            next: '›'
        },
        
        // Date formatting
        titleFormat: {
            year: 'numeric',
            month: 'long'
        },
        
        // Disable past dates
        validRange: {
            start: new Date().toISOString().split('T')[0] // Today onwards
        },
        
        // Custom day cell content
        dayCellContent: function(info) {
            const dateStr = info.date.toISOString().split('T')[0];
            const isUnavailable = unavailableSlots[dateStr] && 
                                 unavailableSlots[dateStr].length >= availableTimeSlots.length;
            
            return {
                html: `
                    <div class="fc-day-content">
                        <div class="fc-day-number">${info.dayNumberText}</div>
                        ${isUnavailable ? '<div class="fc-day-status unavailable">Kín lịch</div>' : 
                          '<div class="fc-day-status available">Còn trống</div>'}
                    </div>
                `
            };
        },
        
        // Date click handler
        dateClick: function(info) {
            handleDateClick(info.date, info.dayEl);
        },
        
        // Month change handler
        datesSet: function(info) {
            updateAvailabilityMessage();
        }
    });
    
    calendar.render();
}

// Handle date selection
function handleDateClick(date, dayEl) {
    // Remove previous selection
    document.querySelectorAll('.fc-daygrid-day.selected').forEach(el => {
        el.classList.remove('selected');
    });
    
    // Add selection to clicked date
    dayEl.classList.add('selected');
    
    // Update selected date
    selectedDate = date.toISOString().split('T')[0];
    
    // Show time slots for selected date
    showTimeSlots(selectedDate);
    
    // Update availability message
    updateAvailabilityMessage(selectedDate);
}

// Show time slots for selected date
function showTimeSlots(dateStr) {
    const timeSlotsSection = document.querySelector('.time-slots-section');
    const selectedDateDisplay = document.getElementById('selectedDateDisplay');
    const timeSlotsList = document.getElementById('timeSlotsList');
    
    if (!timeSlotsSection || !selectedDateDisplay || !timeSlotsList) return;
    
    // Format date for display
    const date = new Date(dateStr + 'T00:00:00');
    const dayName = vietnameseDayNames[date.getDay()];
    const day = date.getDate();
    const month = date.getMonth() + 1;
    const year = date.getFullYear();
    
    selectedDateDisplay.textContent = `${dayName}, ${day}/${month}/${year}`;
    
    // Get unavailable slots for this date
    const unavailable = unavailableSlots[dateStr] || [];
    
    // Generate time slots HTML
    const timeSlotsHTML = availableTimeSlots.map(time => {
        const isUnavailable = unavailable.includes(time);
        const isSelected = selectedTimeSlot === time;
        
        return `
            <button class="time-slot ${isSelected ? 'selected' : ''} ${isUnavailable ? 'unavailable' : ''}"
                    onclick="selectTimeSlot('${time}')"
                    ${isUnavailable ? 'disabled' : ''}>
                ${time}
            </button>
        `;
    }).join('');
    
    timeSlotsList.innerHTML = timeSlotsHTML;
    
    // Show the section with animation
    timeSlotsSection.style.display = 'block';
    setTimeout(() => {
        timeSlotsSection.style.opacity = '1';
        timeSlotsSection.style.transform = 'translateY(0)';
    }, 10);
}

// Select time slot
function selectTimeSlot(time) {
    // Remove previous selection
    document.querySelectorAll('.time-slot.selected').forEach(el => {
        el.classList.remove('selected');
    });
    
    // Add selection to clicked time slot
    event.target.classList.add('selected');
    selectedTimeSlot = time;
    
    // Update continue button state
    updateContinueButton();
    
    console.log(`Selected: ${selectedDate} at ${selectedTimeSlot}`);
}

// Update availability message
function updateAvailabilityMessage(dateStr = null) {
    const availabilityMessage = document.querySelector('.availability-message');
    if (!availabilityMessage) return;
    
    if (dateStr) {
        const unavailable = unavailableSlots[dateStr] || [];
        const isFullyBooked = unavailable.length >= availableTimeSlots.length;
        
        if (isFullyBooked) {
            availabilityMessage.style.display = 'block';
            // Update the message for the selected date
            const date = new Date(dateStr + 'T00:00:00');
            const dayName = vietnameseDayNames[date.getDay()];
            const day = date.getDate();
            const month = date.getMonth() + 1;
            
            availabilityMessage.querySelector('.availability-title').textContent = 
                'Deni đã kín lịch vào ngày này';
            availabilityMessage.querySelector('.availability-subtitle').textContent = 
                `Trùng lịch vào ${dayName}, ${day} thg ${month}`;
        } else {
            availabilityMessage.style.display = 'none';
        }
    }
}

// Update continue button
function updateContinueButton() {
    const continueBtn = document.querySelector('.continue-btn');
    if (continueBtn) {
        continueBtn.disabled = !selectedDate || !selectedTimeSlot;
        
        if (selectedDate && selectedTimeSlot) {
            continueBtn.textContent = `Tiếp tục với ${selectedTimeSlot}`;
        } else {
            continueBtn.textContent = 'Chọn thời gian để tiếp tục';
        }
    }
}

// Handle next available date
function handleNextAvailable() {
    const today = new Date();
    let nextDate = new Date(today);
    nextDate.setDate(nextDate.getDate() + 1);
    
    // Find next available date (simplified logic)
    for (let i = 0; i < 30; i++) {
        const dateStr = nextDate.toISOString().split('T')[0];
        const unavailable = unavailableSlots[dateStr] || [];
        
        if (unavailable.length < availableTimeSlots.length) {
            // Found available date - navigate calendar to it
            calendar.gotoDate(nextDate);
            
            // Simulate click on the date
            setTimeout(() => {
                const dayEl = document.querySelector(`[data-date="${dateStr}"]`);
                if (dayEl) {
                    handleDateClick(nextDate, dayEl.closest('.fc-daygrid-day'));
                }
            }, 100);
            break;
        }
        
        nextDate.setDate(nextDate.getDate() + 1);
    }
}

// Handle waitlist
function handleWaitlist() {
    alert('Bạn đã được thêm vào danh sách chờ cho ngày này!');
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    console.log('🗓️ Initializing FullCalendar Time Selection...');
    
    // Initialize calendar
    initializeCalendar();
    
    // Setup event listeners
    setupEventListeners();
    
    // Initial state
    updateContinueButton();
    
    console.log('✅ FullCalendar Time Selection initialized successfully');
});

// Setup additional event listeners
function setupEventListeners() {
    // Next available button
    const nextAvailableBtn = document.querySelector('.btn-next-available');
    if (nextAvailableBtn) {
        nextAvailableBtn.addEventListener('click', handleNextAvailable);
    }
    
    // Waitlist button
    const waitlistBtn = document.querySelector('.btn-waitlist');
    if (waitlistBtn) {
        waitlistBtn.addEventListener('click', handleWaitlist);
    }
    
    // Continue button
    const continueBtn = document.querySelector('.continue-btn');
    if (continueBtn) {
        continueBtn.addEventListener('click', function() {
            if (selectedDate && selectedTimeSlot) {
                console.log('Proceeding with booking:', {
                    date: selectedDate,
                    time: selectedTimeSlot
                });
                // Here you would proceed to the next step (payment/confirmation)
                alert(`Đặt lịch thành công!\nNgày: ${selectedDate}\nGiờ: ${selectedTimeSlot}`);
            }
        });
    }
}

// Add custom styles for day status indicators
const customStyles = `
    <style>
        .fc-day-content {
            position: relative;
            padding: 4px;
        }
        
        .fc-day-status {
            font-size: 10px;
            padding: 2px 4px;
            border-radius: 10px;
            margin-top: 2px;
            text-align: center;
        }
        
        .fc-day-status.available {
            background: #dcfce7;
            color: #166534;
        }
        
        .fc-day-status.unavailable {
            background: #fef2f2;
            color: #dc2626;
        }
        
        .time-slots-section {
            opacity: 0;
            transform: translateY(20px);
            transition: all 0.3s ease;
        }
    </style>
`;

// Inject custom styles
document.head.insertAdjacentHTML('beforeend', customStyles); 