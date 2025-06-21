class Calendar {
constructor() {
this.currentDate = new Date();
this.selectedDate = null;
this.isOpen = false;
this.animationClass = '';

        this.months = [
            'Tháng một', 'Tháng hai', 'Tháng ba', 'Tháng tư',
            'Tháng năm', 'Tháng sáu', 'Tháng bảy', 'Tháng tám',
            'Tháng chín', 'Tháng mười', 'Tháng mười một', 'Tháng mười hai'
        ];

        this.initializeElements();
        this.bindEvents();
        this.updateDisplay();
    }

    initializeElements() {
        this.modal = document.getElementById('calendarModal');
        this.backdrop = this.modal.querySelector('.calendar-backdrop');
        this.openBtn = document.getElementById('openCalendarBtn');
        this.closeBtn = document.getElementById('closeCalendarBtn');
        this.prevMonthBtn = document.getElementById('prevMonthBtn');
        this.nextMonthBtn = document.getElementById('nextMonthBtn');
        this.monthYearDisplay = document.getElementById('monthYear');
        this.calendarDays = document.getElementById('calendarDays');
        this.dateInput = document.getElementById('dateInput');
        this.selectedDateDisplay = document.getElementById('selectedDateDisplay');
        this.dateValue = document.getElementById('dateValue');
        this.buttonText = document.getElementById('buttonText');
    }

    bindEvents() {
        this.openBtn.addEventListener('click', () => this.openCalendar());
        this.closeBtn.addEventListener('click', () => this.closeCalendar());
        this.backdrop.addEventListener('click', () => this.closeCalendar());
        this.prevMonthBtn.addEventListener('click', () => this.navigateMonth('prev'));
        this.nextMonthBtn.addEventListener('click', () => this.navigateMonth('next'));

        // Prevent modal from closing when clicking inside the calendar container
        this.modal.querySelector('.calendar-container').addEventListener('click', (e) => {
            e.stopPropagation();
        });

        // Handle escape key
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && this.isOpen) {
                this.closeCalendar();
            }
        });
    }

    openCalendar() {
        this.isOpen = true;
        this.modal.classList.add('open');
        document.body.style.overflow = 'hidden';
        this.updateDisplay();
    }

    closeCalendar() {
        this.isOpen = false;
        this.modal.classList.remove('open');
        document.body.style.overflow = 'unset';
    }

    navigateMonth(direction) {
        this.animationClass = direction === 'prev' ? 'slide-right' : 'slide-left';
        this.calendarDays.className = `calendar-days ${this.animationClass}`;

        setTimeout(() => {
            const newDate = new Date(this.currentDate);
            newDate.setMonth(this.currentDate.getMonth() + (direction === 'next' ? 1 : -1));
            this.currentDate = newDate;
            this.animationClass = '';
            this.updateDisplay();
        }, 150);
    }

    getDaysInMonth(date) {
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
                isPrevious: true
            });
        }

        // Current month's days
        for (let day = 1; day <= daysInMonth; day++) {
            days.push({
                date: day,
                isCurrentMonth: true,
                isPrevious: false
            });
        }

        // Next month's leading days
        const remainingDays = 42 - days.length;
        for (let day = 1; day <= remainingDays; day++) {
            days.push({
                date: day,
                isCurrentMonth: false,
                isPrevious: false
            });
        }

        return days;
    }

    handleDateClick(day) {
        if (!day.isCurrentMonth) return;

        const newDate = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth(), day.date);
        this.selectedDate = newDate;
        this.updateSelectedDateDisplay();
        this.closeCalendar();
    }

    isDateSelected(day) {
        if (!this.selectedDate || !day.isCurrentMonth) return false;

        return (
            this.selectedDate.getDate() === day.date &&
            this.selectedDate.getMonth() === this.currentDate.getMonth() &&
            this.selectedDate.getFullYear() === this.currentDate.getFullYear()
        );
    }

    isToday(day) {
        if (!day.isCurrentMonth) return false;

        const today = new Date();
        return (
            today.getDate() === day.date &&
            today.getMonth() === this.currentDate.getMonth() &&
            today.getFullYear() === this.currentDate.getFullYear()
        );
    }

    updateDisplay() {
        // Update month/year display
        this.monthYearDisplay.textContent = `${this.months[this.currentDate.getMonth()]} ${this.currentDate.getFullYear()}`;

        // Update date input
        if (this.selectedDate) {
            this.dateInput.value = this.selectedDate.toLocaleDateString('vi-VN');
        }

        // Generate calendar days
        const days = this.getDaysInMonth(this.currentDate);
        this.calendarDays.innerHTML = '';
        this.calendarDays.className = `calendar-days ${this.animationClass}`;

        days.forEach((day, index) => {
            const dayButton = document.createElement('button');
            dayButton.className = 'calendar-day';
            dayButton.textContent = day.date;

            if (!day.isCurrentMonth) {
                dayButton.disabled = true;
            } else {
                dayButton.addEventListener('click', () => this.handleDateClick(day));
            }

            if (this.isDateSelected(day)) {
                dayButton.classList.add('selected');
            }

            if (this.isToday(day)) {
                dayButton.classList.add('today');
            }

            this.calendarDays.appendChild(dayButton);
        });
    }

    updateSelectedDateDisplay() {
        if (this.selectedDate) {
            this.selectedDateDisplay.style.display = 'block';
            this.dateValue.textContent = this.selectedDate.toLocaleDateString('vi-VN', {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });
            this.buttonText.textContent = 'Change Date';
        } else {
            this.selectedDateDisplay.style.display = 'none';
            this.buttonText.textContent = 'Select Date';
        }
    }

}

// Initialize calendar when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
new Calendar();
});

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beautiful Calendar Popup Component</title>
    <link rel="stylesheet" href="styles.css">
    <script src="https://code.iconify.design/3/3.1.1/iconify.min.js"></script>
</head>
<body>
    <div class="container">
        <div class="demo-card">
            <div class="demo-header">
                <div class="demo-icon">
                    <iconify-icon icon="material-symbols:calendar-month" width="28" height="28"></iconify-icon>
                </div>
                <h1 class="demo-title">
                    <iconify-icon icon="fluent:calendar-sparkle-20-filled" width="24" height="24"></iconify-icon>
                    Beautiful Calendar
                </h1>
                <p class="demo-description">
                    <iconify-icon icon="material-symbols:touch-app" width="16" height="16"></iconify-icon>
                    Click the button below to open the calendar popup
                </p>
            </div>

            <div class="demo-content">
                <div id="selectedDateDisplay" class="selected-date-card" style="display: none;">
                    <p class="selected-date-label">
                        <iconify-icon icon="material-symbols:event-available" width="16" height="16"></iconify-icon>
                        Selected Date:
                    </p>
                    <p id="selectedDateText" class="selected-date-text">
                        <iconify-icon icon="material-symbols:calendar-today" width="18" height="18"></iconify-icon>
                        <span id="dateValue"></span>
                    </p>
                </div>

                <button id="openCalendarBtn" class="open-calendar-btn">
                    <iconify-icon icon="material-symbols:calendar-add-on" width="20" height="20"></iconify-icon>
                    <span id="buttonText">Select Date</span>
                    <iconify-icon icon="material-symbols:arrow-forward" width="16" height="16"></iconify-icon>
                </button>
            </div>
        </div>
    </div>

    <!-- Calendar Modal -->
    <div id="calendarModal" class="calendar-modal">
        <div class="calendar-backdrop"></div>
        <div class="calendar-container">
            <!-- Header -->
            <div class="calendar-header">
                <button id="closeCalendarBtn" class="close-btn">
                    <iconify-icon icon="material-symbols:close" width="20" height="20"></iconify-icon>
                </button>
                <div class="header-content">
                    <div class="header-icon">
                        <iconify-icon icon="material-symbols:calendar-month" width="20" height="20"></iconify-icon>
                    </div>
                    <h2 class="header-title">Chọn ngày cho Tây Tế Bảo Chết Toàn Thân</h2>
                </div>
            </div>

            <!-- Content -->
            <div class="calendar-content">
                <!-- Date Input -->
                <div class="date-input-section">
                    <label class="date-input-label">Chọn ngày:</label>
                    <div class="date-input-container">
                        <input
                            type="text"
                            id="dateInput"
                            readonly
                            placeholder="Nhấn để chọn ngày khả dụng..."
                            class="date-input"
                        />
                        <iconify-icon icon="material-symbols:calendar-today" class="input-icon" width="20" height="20"></iconify-icon>
                    </div>
                </div>

                <!-- Month Navigation -->
                <div class="month-navigation">
                    <button id="prevMonthBtn" class="nav-btn">
                        <iconify-icon icon="material-symbols:chevron-left" width="20" height="20"></iconify-icon>
                    </button>
                    <h3 class="month-title">
                        <iconify-icon icon="material-symbols:date-range" width="18" height="18"></iconify-icon>
                        <span id="monthYear"></span>
                    </h3>
                    <button id="nextMonthBtn" class="nav-btn">
                        <iconify-icon icon="material-symbols:chevron-right" width="20" height="20"></iconify-icon>
                    </button>
                </div>

                <!-- Calendar Grid -->
                <div class="calendar-grid-container">
                    <!-- Week Headers -->
                    <div class="week-headers">
                        <div class="week-day">T2</div>
                        <div class="week-day">T3</div>
                        <div class="week-day">T4</div>
                        <div class="week-day">T5</div>
                        <div class="week-day">T6</div>
                        <div class="week-day">T7</div>
                        <div class="week-day">CN</div>
                    </div>

                    <!-- Calendar Days -->
                    <div id="calendarDays" class="calendar-days"></div>
                </div>
            </div>
        </div>
    </div>

    <script src="script.js"></script>

</body>
</html>

:root {
--spa-primary: #c8945f;
--amber-100: #fef3c7;
--amber-300: #fcd34d;
--amber-500: #f59e0b;
--amber-600: #d97706;
--amber-700: #b45309;
--amber-800: #92400e;
--blue-50: #eff6ff;
--orange-50: #fff7ed;
--orange-200: #fed7aa;
--gray-50: #f9fafb;
--gray-100: #f3f4f6;
--gray-200: #e5e7eb;
--gray-300: #d1d5db;
--gray-400: #9ca3af;
--gray-500: #6b7280;
--gray-600: #4b5563;
--gray-700: #374151;
--gray-800: #1f2937;
}

- {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  }

body {
font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
background-color: var(--blue-50);
min-height: 100vh;
transition: all 0.15s cubic-bezier(0.4, 0, 0.2, 1);
}

.container {
min-height: 100vh;
display: flex;
align-items: center;
justify-content: center;
padding: 1rem;
}

.demo-card {
background: white;
border-radius: 1rem;
box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
border: 2px solid var(--gray-200);
padding: 2rem;
max-width: 28rem;
width: 100%;
}

.demo-header {
text-align: center;
margin-bottom: 2rem;
}

.demo-icon {
display: inline-flex;
align-items: center;
justify-content: center;
width: 4rem;
height: 4rem;
background-color: var(--spa-primary);
border-radius: 1rem;
margin-bottom: 1rem;
border: 2px solid var(--amber-600);
color: white;
}

.demo-title {
font-size: 1.5rem;
font-weight: bold;
color: var(--gray-800);
margin-bottom: 0.5rem;
display: flex;
align-items: center;
justify-content: center;
gap: 0.5rem;
}

.demo-title iconify-icon {
color: var(--spa-primary);
}

.demo-description {
color: var(--gray-600);
display: flex;
align-items: center;
justify-content: center;
gap: 0.5rem;
}

.demo-description iconify-icon {
color: var(--gray-400);
}

.demo-content {
display: flex;
flex-direction: column;
gap: 1rem;
}

.selected-date-card {
padding: 1rem;
background-color: var(--orange-50);
border: 2px solid var(--orange-200);
border-radius: 0.75rem;
}

.selected-date-label {
font-size: 0.875rem;
font-weight: 500;
color: var(--spa-primary);
margin-bottom: 0.25rem;
display: flex;
align-items: center;
gap: 0.5rem;
}

.selected-date-text {
font-size: 1.125rem;
font-weight: 600;
color: var(--amber-800);
display: flex;
align-items: center;
gap: 0.5rem;
}

.open-calendar-btn {
width: 100%;
display: flex;
align-items: center;
justify-content: center;
gap: 0.75rem;
padding: 1rem;
background-color: var(--spa-primary);
color: white;
font-weight: 600;
border-radius: 0.75rem;
border: 2px solid transparent;
cursor: pointer;
transition: all 0.2s ease;
box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
}

.open-calendar-btn:hover {
background-color: var(--amber-600);
border-color: var(--amber-700);
transform: scale(1.02);
}

.open-calendar-btn:active {
transform: scale(0.98);
}

.open-calendar-btn iconify-icon:first-child {
transition: transform 0.2s ease;
}

.open-calendar-btn:hover iconify-icon:first-child {
transform: scale(1.1);
}

.open-calendar-btn iconify-icon:last-child {
transition: transform 0.2s ease;
}

.open-calendar-btn:hover iconify-icon:last-child {
transform: translateX(0.25rem);
}

/_ Calendar Modal _/
.calendar-modal {
position: fixed;
inset: 0;
z-index: 50;
display: none;
align-items: center;
justify-content: center;
padding: 1rem;
}

.calendar-modal.open {
display: flex;
}

.calendar-backdrop {
position: absolute;
inset: 0;
background-color: rgba(0, 0, 0, 0.3);
backdrop-filter: blur(4px);
transition: opacity 0.3s ease;
}

.calendar-container {
position: relative;
background: white;
border-radius: 1rem;
box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
border: 2px solid var(--gray-200);
max-width: 28rem;
width: 100%;
margin: 1rem;
transform: scale(1);
transition: all 0.3s ease;
animation: fadeIn 0.3s ease-out;
}

@keyframes fadeIn {
from {
opacity: 0;
transform: scale(0.95);
}
to {
opacity: 1;
transform: scale(1);
}
}

.calendar-header {
position: relative;
padding: 1.5rem;
padding-bottom: 1rem;
background-color: var(--spa-primary);
border-radius: 1rem 1rem 0 0;
color: white;
}

.close-btn {
position: absolute;
top: 1rem;
right: 1rem;
padding: 0.5rem;
background-color: rgba(255, 255, 255, 0.2);
border: none;
border-radius: 50%;
cursor: pointer;
transition: background-color 0.2s ease;
z-index: 10;
color: white;
}

.close-btn:hover {
background-color: rgba(255, 255, 255, 0.3);
}

.header-content {
display: flex;
align-items: center;
gap: 0.75rem;
padding-right: 3rem;
}

.header-icon {
padding: 0.5rem;
background-color: rgba(255, 255, 255, 0.2);
border-radius: 0.5rem;
flex-shrink: 0;
}

.header-title {
font-size: 1.125rem;
font-weight: 600;
line-height: 1.25;
}

.calendar-content {
padding: 1.5rem;
background: white;
border-radius: 0 0 1rem 1rem;
}

.date-input-section {
margin-bottom: 1.5rem;
}

.date-input-label {
display: block;
font-size: 0.875rem;
font-weight: 500;
color: var(--gray-700);
margin-bottom: 0.5rem;
}

.date-input-container {
position: relative;
}

.date-input {
width: 100%;
padding: 0.75rem 1rem;
padding-right: 3rem;
border: 2px solid var(--gray-200);
border-radius: 0.75rem;
background-color: var(--gray-50);
transition: all 0.2s ease;
font-size: 1rem;
}

.date-input:focus {
outline: none;
border-color: var(--spa-primary);
box-shadow: 0 0 0 3px rgba(200, 148, 95, 0.1);
}

.input-icon {
position: absolute;
right: 0.75rem;
top: 50%;
transform: translateY(-50%);
color: var(--gray-400);
}

.month-navigation {
display: flex;
align-items: center;
justify-content: space-between;
margin-bottom: 1.5rem;
}

.nav-btn {
padding: 0.5rem;
background-color: var(--gray-100);
border: none;
border-radius: 0.5rem;
cursor: pointer;
transition: all 0.2s ease;
color: var(--gray-600);
}

.nav-btn:hover {
background-color: var(--gray-200);
color: var(--gray-800);
}

.month-title {
font-size: 1.125rem;
font-weight: 600;
color: var(--gray-800);
display: flex;
align-items: center;
gap: 0.5rem;
}

.month-title iconify-icon {
color: var(--spa-primary);
}

.calendar-grid-container {
margin-bottom: 0;
}

.week-headers {
display: grid;
grid-template-columns: repeat(7, 1fr);
gap: 0.25rem;
margin-bottom: 0.5rem;
}

.week-day {
text-align: center;
font-size: 0.875rem;
font-weight: 500;
color: var(--gray-500);
padding: 0.5rem;
background-color: var(--gray-50);
border-radius: 0.25rem;
}

.calendar-days {
display: grid;
grid-template-columns: repeat(7, 1fr);
gap: 0.25rem;
}

.calendar-day {
aspect-ratio: 1;
display: flex;
align-items: center;
justify-content: center;
font-size: 0.875rem;
border-radius: 0.5rem;
transition: all 0.2s ease;
position: relative;
border: 2px solid transparent;
background: white;
cursor: pointer;
}

.calendar-day:disabled {
color: var(--gray-300);
cursor: not-allowed;
}

.calendar-day:not(:disabled):hover {
border-color: var(--spa-primary);
background-color: var(--orange-50);
color: var(--spa-primary);
transform: scale(1.05);
}

.calendar-day.selected {
background-color: var(--spa-primary);
color: white;
border-color: var(--spa-primary);
box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
transform: scale(1.05);
}

.calendar-day.today:not(.selected) {
background-color: var(--amber-100);
color: var(--amber-700);
font-weight: 600;
border-color: var(--amber-300);
}

.calendar-day.today:not(.selected)::after {
content: '';
position: absolute;
bottom: -0.25rem;
left: 50%;
transform: translateX(-50%);
width: 0.5rem;
height: 0.5rem;
background-color: var(--amber-500);
border-radius: 50%;
}

.calendar-day.selected::after {
content: '';
position: absolute;
top: -0.25rem;
right: -0.25rem;
width: 1rem;
height: 1rem;
background-color: var(--spa-primary);
border: 2px solid white;
border-radius: 50%;
background-image: url("data:image/svg+xml,%3csvg viewBox='0 0 16 16' fill='white' xmlns='http://www.w3.org/2000/svg'%3e%3cpath d='m13.854 3.646-7.5 7.5a.5.5 0 0 1-.708 0l-3.5-3.5a.5.5 0 1 1 .708-.708L6 10.293l7.146-7.147a.5.5 0 0 1 .708.708z'/%3e%3c/svg%3e");
background-size: 0.75rem;
background-repeat: no-repeat;
background-position: center;
}

/_ Animation classes _/
.slide-left {
animation: slideLeft 0.15s ease-out;
}

.slide-right {
animation: slideRight 0.15s ease-out;
}

@keyframes slideLeft {
from { transform: translateX(0); }
to { transform: translateX(-10px); }
}

@keyframes slideRight {
from { transform: translateX(0); }
to { transform: translateX(10px); }
}

/_ Custom scrollbar _/
::-webkit-scrollbar {
width: 6px;
}

::-webkit-scrollbar-track {
background: #f1f1f1;
border-radius: 3px;
}

::-webkit-scrollbar-thumb {
background: #c1c1c1;
border-radius: 3px;
}

::-webkit-scrollbar-thumb:hover {
background: #a1a1a1;
}
