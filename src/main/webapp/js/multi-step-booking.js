// Multi-step Booking System - Converted from React
class MultiStepBooking {
    constructor() {
        this.currentStep = 1;
        this.totalSteps = 5;
        this.cartItems = [];
        this.selectedServices = [];
        this.selectedTimeSlot = null;
        this.selectedTherapist = null;
        this.selectedPaymentMethod = '';
        this.guestInfo = {
            fullName: '',
            phone: '',
            email: '',
            address: '',
            notes: ''
        };
        this.currentCalendarDate = new Date();
        this.bookingCode = '';
        this.errors = {};
        this.isLoading = false;
        this.qrCodeCopied = false;

        // Mock data
        this.mockTherapists = [
            {
                id: '1',
                name: 'Chị Nguyễn Thị Hương',
                specialties: ['Massage', 'Chăm sóc da', 'Tắm trắng'],
                rating: 4.9,
                experience: '8 năm kinh nghiệm',
                avatar: 'https://images.pexels.com/photos/3985263/pexels-photo-3985263.jpeg?auto=compress&cs=tinysrgb&w=150',
                available: true
            },
            {
                id: '2',
                name: 'Chị Trần Thị Lan',
                specialties: ['Tắm trắng', 'Massage', 'Gói combo'],
                rating: 4.8,
                experience: '6 năm kinh nghiệm',
                avatar: 'https://images.pexels.com/photos/3997991/pexels-photo-3997991.jpeg?auto=compress&cs=tinysrgb&w=150',
                available: true
            },
            {
                id: '3',
                name: 'Chị Lê Thị Mai',
                specialties: ['Chăm sóc da', 'Gói combo'],
                rating: 4.7,
                experience: '5 năm kinh nghiệm',
                avatar: 'https://images.pexels.com/photos/3985254/pexels-photo-3985254.jpeg?auto=compress&cs=tinysrgb&w=150',
                available: Math.random() > 0.3
            }
        ];

        this.paymentMethods = [
            { 
                id: 'cash', 
                name: 'Tiền mặt', 
                description: 'Thanh toán bằng tiền mặt tại spa',
                icon: '💵'
            },
            { 
                id: 'card', 
                name: 'Thẻ tín dụng/ghi nợ', 
                description: 'Visa, Mastercard, JCB',
                icon: '💳'
            },
            { 
                id: 'momo', 
                name: 'MoMo', 
                description: 'Ví điện tử MoMo',
                icon: '📱'
            },
            { 
                id: 'zalopay', 
                name: 'ZaloPay', 
                description: 'Ví điện tử ZaloPay',
                icon: '💰'
            }
        ];

        this.init();
    }

    init() {
        this.loadCartItems();
        this.initializeProgressBar();
        this.setupEventListeners();
        this.updateStepDisplay();
        this.populateStep1();
    }

    loadCartItems() {
        try {
            // Always use session_cart regardless of login status
            const cartKey = 'session_cart';

            const savedCart = localStorage.getItem(cartKey);
            this.cartItems = savedCart ? JSON.parse(savedCart) : [];
        } catch (error) {
            console.error('Failed to load cart items:', error);
            this.cartItems = [];
        }
    }

    initializeProgressBar() {
        const progressBar = document.getElementById('progress-bar');
        let progressHTML = '';
        
        for (let i = 1; i <= this.totalSteps; i++) {
            const isActive = i <= this.currentStep;
            const isCompleted = i < this.currentStep;
            
            progressHTML += `
                <div class="flex items-center flex-1">
                    <div class="w-8 h-8 rounded-full flex items-center justify-center text-sm font-semibold ${
                        isActive ? 'bg-primary text-white' : 'bg-gray-200 text-gray-500'
                    }">
                        ${isCompleted ? '<i data-lucide="check-circle" class="h-4 w-4"></i>' : i}
                    </div>
                    ${i < this.totalSteps ? `<div class="flex-1 h-1 mx-2 ${isCompleted ? 'bg-primary' : 'bg-gray-200'}"></div>` : ''}
                </div>
            `;
        }
        
        progressBar.innerHTML = progressHTML;
        lucide.createIcons();
    }

    setupEventListeners() {
        // Navigation buttons
        document.getElementById('next-btn').addEventListener('click', () => this.handleNextStep());
        document.getElementById('prev-btn').addEventListener('click', () => this.handlePrevStep());
        document.getElementById('submit-btn').addEventListener('click', () => this.handleBookingSubmit());

        // Calendar buttons
        document.getElementById('choose-time-btn').addEventListener('click', () => this.showCalendarModal());
        document.getElementById('change-time-btn').addEventListener('click', () => this.showCalendarModal());
        document.getElementById('close-calendar-btn').addEventListener('click', () => this.hideCalendarModal());
        document.getElementById('confirm-time-btn').addEventListener('click', () => this.confirmTimeSelection());

        // Calendar navigation
        document.getElementById('prev-month-btn').addEventListener('click', () => this.prevMonth());
        document.getElementById('next-month-btn').addEventListener('click', () => this.nextMonth());

        // QR Code copy
        document.getElementById('copy-qr-btn').addEventListener('click', () => this.copyQRCode());
    }

    updateStepDisplay() {
        const stepTitles = [
            'Chọn dịch vụ từ giỏ hàng',
            'Lên lịch hẹn', 
            'Chọn nhân viên',
            'Thông tin thanh toán',
            'Hoàn tất thanh toán',
            'Hoàn thành'
        ];

        document.getElementById('step-title').textContent = stepTitles[this.currentStep - 1];
        document.getElementById('step-indicator').textContent = `Bước ${Math.min(this.currentStep, this.totalSteps)} / ${this.totalSteps}`;

        // Show/hide step content
        for (let i = 1; i <= 6; i++) {
            const stepElement = document.getElementById(`step-${i}`);
            if (stepElement) {
                stepElement.style.display = i === this.currentStep ? 'block' : 'none';
            }
        }

        // Update navigation buttons
        const prevBtn = document.getElementById('prev-btn');
        const nextBtn = document.getElementById('next-btn');
        const submitBtn = document.getElementById('submit-btn');
        const navButtons = document.getElementById('navigation-buttons');

        if (this.currentStep === 6) {
            navButtons.style.display = 'none';
        } else {
            navButtons.style.display = 'flex';
            prevBtn.style.display = this.currentStep > 1 ? 'block' : 'none';
            
            if (this.currentStep === this.totalSteps) {
                nextBtn.style.display = 'none';
                submitBtn.style.display = 'block';
            } else {
                nextBtn.style.display = 'block';
                submitBtn.style.display = 'none';
            }
        }

        this.initializeProgressBar();
    }

    populateStep1() {
        const cartCount = document.getElementById('cart-count');
        const emptyCartMessage = document.getElementById('empty-cart-message');
        const cartItemsContainer = document.getElementById('cart-items-container');
        const cartServicesGrid = document.getElementById('cart-services-grid');

        cartCount.textContent = this.cartItems.length;

        if (this.cartItems.length === 0) {
            emptyCartMessage.style.display = 'block';
            cartItemsContainer.style.display = 'none';
            return;
        }

        emptyCartMessage.style.display = 'none';
        cartItemsContainer.style.display = 'block';

        // Populate cart services
        cartServicesGrid.innerHTML = this.cartItems.map(item => {
            const isSelected = this.selectedServices.includes(item.serviceId);
            const isDisabled = !isSelected && this.selectedServices.length >= 6;

            return `
                <div class="service-card p-4 border-2 rounded-lg ${isSelected ? 'selected' : ''} ${isDisabled ? 'opacity-60 cursor-not-allowed' : 'cursor-pointer'}" 
                     data-service-id="${item.serviceId}" onclick="${!isDisabled ? `booking.toggleService('${item.serviceId}')` : ''}">
                    <div class="flex items-center space-x-4">
                        <img src="${item.serviceImage}" alt="${item.serviceName}" class="w-16 h-16 object-cover rounded-lg">
                        <div class="flex-1">
                            <div class="flex items-center justify-between mb-2">
                                <h4 class="font-semibold text-spa-dark">${item.serviceName}</h4>
                                ${isSelected ? '<i data-lucide="check-circle" class="h-6 w-6 text-primary"></i>' : ''}
                            </div>
                            <div class="flex items-center space-x-4 mb-2">
                                <div class="flex items-center text-primary">
                                    <i data-lucide="dollar-sign" class="h-4 w-4 mr-1"></i>
                                    <span class="font-bold">${item.servicePrice.toLocaleString()}đ</span>
                                </div>
                                <div class="flex items-center text-gray-500">
                                    <i data-lucide="timer" class="h-4 w-4 mr-1"></i>
                                    <span class="text-sm">${item.serviceDuration} phút</span>
                                </div>
                            </div>
                            <div class="flex items-center justify-between">
                                <span class="text-xs bg-primary text-white px-2 py-1 rounded-full">${item.serviceCategory}</span>
                                <div class="flex items-center">
                                    <i data-lucide="star" class="h-4 w-4 text-primary fill-current mr-1"></i>
                                    <span class="text-sm font-medium">${item.serviceRating}</span>
                                </div>
                            </div>
                            ${item.quantity > 1 ? `<div class="mt-2 text-sm text-gray-600">Số lượng: ${item.quantity}</div>` : ''}
                        </div>
                    </div>
                </div>
            `;
        }).join('');

        this.updateSelectedServicesDisplay();
        lucide.createIcons();
    }

    toggleService(serviceId) {
        const isSelected = this.selectedServices.includes(serviceId);
        
        if (isSelected) {
            this.selectedServices = this.selectedServices.filter(id => id !== serviceId);
        } else {
            if (this.selectedServices.length >= 6) return;
            this.selectedServices.push(serviceId);
        }

        this.updateSelectedServicesDisplay();
        this.updateServiceCards();
    }

    updateServiceCards() {
        const serviceCards = document.querySelectorAll('.service-card');
        serviceCards.forEach(card => {
            const serviceId = card.dataset.serviceId;
            const isSelected = this.selectedServices.includes(serviceId);
            const isDisabled = !isSelected && this.selectedServices.length >= 6;

            card.classList.toggle('selected', isSelected);
            card.classList.toggle('opacity-60', isDisabled);
            card.classList.toggle('cursor-not-allowed', isDisabled);
            card.onclick = isDisabled ? null : () => this.toggleService(serviceId);
        });
    }

    updateSelectedServicesDisplay() {
        document.getElementById('selected-count').textContent = this.selectedServices.length;
        
        const warningElement = document.getElementById('service-limit-warning');
        warningElement.style.display = this.selectedServices.length >= 6 ? 'block' : 'none';

        const summaryElement = document.getElementById('selected-summary');
        if (this.selectedServices.length > 0) {
            summaryElement.style.display = 'block';
            this.renderSelectedServicesSummary();
        } else {
            summaryElement.style.display = 'none';
        }
    }

    renderSelectedServicesSummary() {
        const selectedCartItems = this.cartItems.filter(item => this.selectedServices.includes(item.serviceId));
        const totalPrice = selectedCartItems.reduce((sum, item) => sum + (item.servicePrice * item.quantity), 0);
        const totalDuration = selectedCartItems.reduce((sum, item) => sum + (item.serviceDuration * item.quantity), 0);
        const totalItems = selectedCartItems.reduce((sum, item) => sum + item.quantity, 0);

        const listElement = document.getElementById('selected-services-list');
        listElement.innerHTML = selectedCartItems.map(item => `
            <div class="flex items-center justify-between p-3 bg-spa-cream rounded-lg">
                <div class="flex items-center space-x-3">
                    <img src="${item.serviceImage}" alt="${item.serviceName}" class="w-12 h-12 object-cover rounded-lg">
                    <div>
                        <h4 class="font-medium text-spa-dark">${item.serviceName}</h4>
                        <p class="text-sm text-gray-600">${item.serviceDuration} phút × ${item.quantity}</p>
                    </div>
                </div>
                <div class="text-right">
                    <p class="font-bold text-primary">${(item.servicePrice * item.quantity).toLocaleString()}đ</p>
                </div>
            </div>
        `).join('');

        const totalsElement = document.getElementById('selected-totals');
        totalsElement.innerHTML = `
            <div class="grid grid-cols-3 gap-4 text-center">
                <div>
                    <p class="text-sm text-gray-600">Tổng dịch vụ</p>
                    <p class="font-bold text-spa-dark">${totalItems}</p>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Tổng thời gian</p>
                    <p class="font-bold text-spa-dark">${totalDuration} phút</p>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Tổng giá</p>
                    <p class="font-bold text-primary">${totalPrice.toLocaleString()}đ</p>
                </div>
            </div>
        `;
    }

    validateStep() {
        this.errors = {};

        switch (this.currentStep) {
            case 1:
                if (this.selectedServices.length === 0) {
                    this.errors.services = 'Vui lòng chọn ít nhất một dịch vụ';
                }
                break;
            case 2:
                if (!this.selectedTimeSlot) {
                    this.errors.timeSlot = 'Vui lòng chọn thời gian';
                }
                break;
            case 3:
                if (!this.selectedTherapist) {
                    this.errors.therapist = 'Vui lòng chọn nhân viên';
                }
                break;
            case 4:
                const user = sessionStorage.getItem('user');
                if (!user) {
                    // Validate guest info
                    const name = document.getElementById('guest-name').value.trim();
                    const phone = document.getElementById('guest-phone').value.trim();
                    const email = document.getElementById('guest-email').value.trim();
                    const address = document.getElementById('guest-address').value.trim();

                    if (!name) this.errors.fullName = 'Vui lòng nhập họ tên';
                    if (!phone) this.errors.phone = 'Vui lòng nhập số điện thoại';
                    if (!email) this.errors.email = 'Vui lòng nhập email';
                    if (!address) this.errors.address = 'Vui lòng nhập địa chỉ';
                    if (email && !/\S+@\S+\.\S+/.test(email)) {
                        this.errors.email = 'Email không hợp lệ';
                    }
                }
                break;
            case 5:
                if (!this.selectedPaymentMethod) {
                    this.errors.payment = 'Vui lòng chọn phương thức thanh toán';
                }
                break;
        }

        this.displayErrors();
        return Object.keys(this.errors).length === 0;
    }

    displayErrors() {
        // Clear previous errors
        document.querySelectorAll('.error-message').forEach(el => el.style.display = 'none');
        
        Object.keys(this.errors).forEach(field => {
            const errorElement = document.getElementById(`${field}-error`) || document.querySelector(`.${field}-error`);
            if (errorElement) {
                errorElement.textContent = this.errors[field];
                errorElement.style.display = 'block';
            }
        });
    }

    handleNextStep() {
        if (this.validateStep()) {
            this.currentStep++;
            this.updateStepDisplay();
            this.populateCurrentStep();
            window.scrollTo(0, 0);
        }
    }

    handlePrevStep() {
        this.currentStep--;
        this.updateStepDisplay();
        this.populateCurrentStep();
        this.errors = {};
        window.scrollTo(0, 0);
    }

    populateCurrentStep() {
        switch (this.currentStep) {
            case 2:
                this.populateStep2();
                break;
            case 3:
                this.populateStep3();
                break;
            case 4:
                this.populateStep4();
                break;
            case 5:
                this.populateStep5();
                break;
        }
    }

    populateStep2() {
        const selectedCartItems = this.cartItems.filter(item => this.selectedServices.includes(item.serviceId));
        const totalPrice = selectedCartItems.reduce((sum, item) => sum + (item.servicePrice * item.quantity), 0);
        const totalDuration = selectedCartItems.reduce((sum, item) => sum + (item.serviceDuration * item.quantity), 0);

        // Populate services list
        const servicesList = document.getElementById('step2-services-list');
        servicesList.innerHTML = selectedCartItems.map(item => `
            <div class="flex items-center justify-between p-4 bg-spa-cream rounded-lg">
                <div class="flex items-center space-x-4">
                    <img src="${item.serviceImage}" alt="${item.serviceName}" class="w-16 h-16 object-cover rounded-lg">
                    <div>
                        <h4 class="font-semibold text-spa-dark">${item.serviceName}</h4>
                        <p class="text-sm text-gray-600">${item.serviceDuration} phút × ${item.quantity} = ${item.serviceDuration * item.quantity} phút</p>
                        <p class="font-bold text-primary">${(item.servicePrice * item.quantity).toLocaleString()}đ</p>
                    </div>
                </div>
            </div>
        `).join('');

        // Populate totals
        const totalsElement = document.getElementById('step2-totals');
        totalsElement.innerHTML = `
            <div>
                <p class="text-sm text-gray-600">Tổng thời gian: ${totalDuration} phút</p>
                <p class="text-lg font-bold text-primary">Tổng cộng: ${totalPrice.toLocaleString()}đ</p>
            </div>
        `;

        // Update time display
        this.updateTimeDisplay();
    }

    updateTimeDisplay() {
        const selectedTimeDisplay = document.getElementById('selected-time-display');
        const chooseTimeBtn = document.getElementById('choose-time-btn');

        if (this.selectedTimeSlot) {
            selectedTimeDisplay.style.display = 'block';
            chooseTimeBtn.style.display = 'none';
            
            const date = new Date(this.selectedTimeSlot.date);
            document.getElementById('selected-date-text').textContent = date.toLocaleDateString('vi-VN');
            document.getElementById('selected-time-text').textContent = this.selectedTimeSlot.time;
        } else {
            selectedTimeDisplay.style.display = 'none';
            chooseTimeBtn.style.display = 'flex';
        }
    }

    showCalendarModal() {
        document.getElementById('calendar-modal').style.display = 'flex';
        this.generateCalendar();
        this.updateCalendarTimeSlots();
    }

    hideCalendarModal() {
        document.getElementById('calendar-modal').style.display = 'none';
    }

    generateCalendar() {
        const year = this.currentCalendarDate.getFullYear();
        const month = this.currentCalendarDate.getMonth();
        
        // Update month/year display
        document.getElementById('calendar-month-year').textContent = 
            this.currentCalendarDate.toLocaleDateString('vi-VN', { month: 'long', year: 'numeric' });

        const firstDay = new Date(year, month, 1);
        const lastDay = new Date(year, month + 1, 0);
        const startDate = new Date(firstDay);
        startDate.setDate(startDate.getDate() - firstDay.getDay());

        const daysContainer = document.getElementById('calendar-days');
        let daysHTML = '';
        const today = new Date();
        
        for (let i = 0; i < 42; i++) {
            const date = new Date(startDate);
            date.setDate(startDate.getDate() + i);
            
            const isCurrentMonth = date.getMonth() === month;
            const isPast = date < today;
            const isToday = date.toDateString() === today.toDateString();
            const isSunday = date.getDay() === 0;
            const isSelected = this.selectedTimeSlot && this.selectedTimeSlot.date === date.toISOString().split('T')[0];
            
            const available = isCurrentMonth && !isPast && !isSunday;
            
            daysHTML += `
                <button class="calendar-day p-2 text-sm rounded-lg transition-colors ${
                    !isCurrentMonth ? 'text-gray-300' :
                    isPast || isSunday ? 'text-gray-400 cursor-not-allowed' :
                    isToday ? 'today' :
                    isSelected ? 'selected' :
                    'available text-gray-700'
                }" ${available ? `onclick="booking.selectCalendarDate('${date.toISOString().split('T')[0]}')"` : 'disabled'}>
                    ${date.getDate()}
                </button>
            `;
        }
        
        daysContainer.innerHTML = daysHTML;
    }

    selectCalendarDate(dateString) {
        this.selectedCalendarDate = dateString;
        this.generateCalendar(); // Refresh to show selection
        this.updateCalendarTimeSlots();
    }

    updateCalendarTimeSlots() {
        const noDateEl = document.getElementById('calendar-no-date');
        const timeSlotsEl = document.getElementById('calendar-time-slots');
        
        if (!this.selectedCalendarDate) {
            noDateEl.style.display = 'block';
            timeSlotsEl.style.display = 'none';
            return;
        }

        noDateEl.style.display = 'none';
        timeSlotsEl.style.display = 'block';

        // Update selected date display
        const date = new Date(this.selectedCalendarDate);
        document.getElementById('selected-date-text-modal').textContent = 
            date.toLocaleDateString('vi-VN', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });

        // Generate time slots
        const timeSlots = this.generateTimeSlots();
        const timeSlotsGrid = document.getElementById('time-slots-grid');
        
        timeSlotsGrid.innerHTML = timeSlots.map(slot => `
            <button class="time-slot p-3 text-sm rounded-lg border-2 transition-all ${
                slot.available ? 'available border-gray-200' : 'border-gray-100 bg-gray-50 text-gray-400 cursor-not-allowed'
            }" 
            ${slot.available ? `onclick="booking.selectTimeSlot('${slot.time}')"` : 'disabled'}>
                ${slot.time}
            </button>
        `).join('');
    }

    generateTimeSlots() {
        const timeSlots = [
            '07:00', '07:30', '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', 
            '11:00', '11:30', '12:00', '12:30', '13:00', '13:30', '14:00', '14:30',
            '15:00', '15:30', '16:00', '16:30', '17:00', '17:30', '18:00', '18:30', '19:00'
        ];

        return timeSlots.map(time => ({
            time,
            available: Math.random() > 0.3 // 70% availability
        }));
    }

    selectTimeSlot(time) {
        this.selectedCalendarTime = time;
        
        // Update time slots display
        const timeSlots = document.querySelectorAll('.time-slot');
        timeSlots.forEach(slot => {
            slot.classList.remove('selected');
            if (slot.textContent.trim() === time) {
                slot.classList.add('selected');
            }
        });

        // Show confirmation section
        const confirmSection = document.getElementById('confirm-time-section');
        confirmSection.style.display = 'block';
        
        const date = new Date(this.selectedCalendarDate);
        document.getElementById('confirm-datetime-text').textContent = 
            `${date.toLocaleDateString('vi-VN')} - ${time}`;
    }

    confirmTimeSelection() {
        if (this.selectedCalendarDate && this.selectedCalendarTime) {
            this.selectedTimeSlot = {
                date: this.selectedCalendarDate,
                time: this.selectedCalendarTime
            };
            this.hideCalendarModal();
            this.updateTimeDisplay();
        }
    }

    prevMonth() {
        this.currentCalendarDate.setMonth(this.currentCalendarDate.getMonth() - 1);
        this.generateCalendar();
    }

    nextMonth() {
        this.currentCalendarDate.setMonth(this.currentCalendarDate.getMonth() + 1);
        this.generateCalendar();
    }

    async handleBookingSubmit() {
        if (!this.validateStep()) return;

        this.isLoading = true;
        const submitBtn = document.getElementById('submit-btn');
        const originalContent = submitBtn.innerHTML;
        
        submitBtn.innerHTML = `
            <div class="loading-spinner mr-2"></div>
            Đang xử lý...
        `;
        submitBtn.disabled = true;
        
        try {
            // Simulate API call
            await new Promise(resolve => setTimeout(resolve, 2000));
            
            // Generate booking code
            this.bookingCode = `SPA${Date.now().toString().slice(-6)}`;
            
            // Move to success step
            this.currentStep = 6;
            this.updateStepDisplay();
            this.populateSuccessStep();
            
        } catch (error) {
            console.error('Booking failed:', error);
            alert('Có lỗi xảy ra khi đặt lịch. Vui lòng thử lại.');
        } finally {
            this.isLoading = false;
            submitBtn.innerHTML = originalContent;
            submitBtn.disabled = false;
        }
    }

    populateSuccessStep() {
        document.getElementById('booking-code').textContent = this.bookingCode;
        
        const selectedCartItems = this.cartItems.filter(item => this.selectedServices.includes(item.serviceId));
        const totalPrice = selectedCartItems.reduce((sum, item) => sum + (item.servicePrice * item.quantity), 0);
        
        const detailsElement = document.getElementById('success-booking-details');
        detailsElement.innerHTML = `
            <div class="flex justify-between text-sm">
                <span class="text-gray-600">Dịch vụ:</span>
                <span class="font-medium">${selectedCartItems.length} dịch vụ</span>
            </div>
            <div class="flex justify-between text-sm">
                <span class="text-gray-600">Ngày:</span>
                <span class="font-medium">${new Date(this.selectedTimeSlot.date).toLocaleDateString('vi-VN')}</span>
            </div>
            <div class="flex justify-between text-sm">
                <span class="text-gray-600">Giờ:</span>
                <span class="font-medium">${this.selectedTimeSlot.time}</span>
            </div>
            <div class="flex justify-between text-sm">
                <span class="text-gray-600">Nhân viên:</span>
                <span class="font-medium">${this.selectedTherapist.name}</span>
            </div>
            <div class="flex justify-between text-sm font-bold border-t pt-2">
                <span>Tổng:</span>
                <span class="text-primary">${totalPrice.toLocaleString()}đ</span>
            </div>
        `;
    }

    populateStep3() {
        // Populate summary
        const selectedCartItems = this.cartItems.filter(item => this.selectedServices.includes(item.serviceId));
        const totalPrice = selectedCartItems.reduce((sum, item) => sum + (item.servicePrice * item.quantity), 0);
        const totalDuration = selectedCartItems.reduce((sum, item) => sum + (item.serviceDuration * item.quantity), 0);
        const totalItems = selectedCartItems.reduce((sum, item) => sum + item.quantity, 0);

        const summaryElement = document.getElementById('step3-summary');
        summaryElement.innerHTML = `
            <div class="flex items-center space-x-3">
                <i data-lucide="package" class="h-8 w-8 text-primary"></i>
                <div>
                    <h4 class="font-semibold text-spa-dark">${totalItems} dịch vụ</h4>
                    <p class="text-sm text-gray-600">${totalDuration} phút - ${totalPrice.toLocaleString()}đ</p>
                </div>
            </div>
            <div class="flex items-center space-x-3">
                <i data-lucide="calendar" class="h-8 w-8 text-primary"></i>
                <div>
                    <p class="font-semibold text-spa-dark">${new Date(this.selectedTimeSlot.date).toLocaleDateString('vi-VN')}</p>
                    <p class="text-sm text-gray-600">${this.selectedTimeSlot.time}</p>
                </div>
            </div>
        `;

        // Populate therapists
        const therapistsGrid = document.getElementById('therapists-grid');
        const availableTherapists = this.getAvailableTherapists();
        
        therapistsGrid.innerHTML = availableTherapists.map(therapist => `
            <div class="therapist-card p-6 border-2 rounded-lg ${this.selectedTherapist?.id === therapist.id ? 'selected' : ''} ${therapist.available ? 'cursor-pointer' : 'opacity-60 cursor-not-allowed'}" 
                 onclick="${therapist.available ? `booking.selectTherapist('${therapist.id}')` : ''}">
                <div class="flex items-center space-x-4">
                    <img src="${therapist.avatar}" alt="${therapist.name}" class="w-16 h-16 object-cover rounded-full">
                    <div class="flex-1">
                        <div class="flex items-center justify-between mb-2">
                            <h4 class="font-semibold text-spa-dark">${therapist.name}</h4>
                            ${this.selectedTherapist?.id === therapist.id ? '<i data-lucide="check-circle" class="h-6 w-6 text-primary"></i>' : ''}
                        </div>
                        <div class="flex items-center mb-2">
                            <i data-lucide="star" class="h-4 w-4 text-primary fill-current mr-1"></i>
                            <span class="text-sm font-medium mr-3">${therapist.rating}</span>
                            <span class="text-sm text-gray-600">${therapist.experience}</span>
                        </div>
                        <div class="flex flex-wrap gap-1">
                            ${therapist.specialties.map(specialty => `
                                <span class="text-xs bg-primary text-white px-2 py-1 rounded-full">${specialty}</span>
                            `).join('')}
                        </div>
                        ${!therapist.available ? '<p class="text-sm text-red-500 mt-2">Không có lịch</p>' : ''}
                    </div>
                </div>
            </div>
        `).join('');

        lucide.createIcons();
    }

    getAvailableTherapists() {
        if (this.selectedServices.length === 0) return this.mockTherapists;
        
        const selectedCartItems = this.cartItems.filter(item => this.selectedServices.includes(item.serviceId));
        const serviceCategories = selectedCartItems.map(item => item.serviceCategory);
        
        return this.mockTherapists.filter(therapist => 
            therapist.specialties.some(specialty => 
                serviceCategories.includes(specialty) || specialty === 'Gói combo'
            )
        );
    }

    selectTherapist(therapistId) {
        this.selectedTherapist = this.mockTherapists.find(t => t.id === therapistId);
        
        // Update therapist cards
        const therapistCards = document.querySelectorAll('.therapist-card');
        therapistCards.forEach(card => {
            card.classList.remove('selected');
            if (card.getAttribute('onclick') && card.getAttribute('onclick').includes(therapistId)) {
                card.classList.add('selected');
            }
        });

        lucide.createIcons();
    }

    populateStep4() {
        const user = sessionStorage.getItem('user');
        const guestForm = document.getElementById('guest-info-form');
        const userDisplay = document.getElementById('user-info-display');

        if (user) {
            const userData = JSON.parse(user);
            guestForm.style.display = 'none';
            userDisplay.style.display = 'block';
            
            const userDetails = document.getElementById('user-details');
            userDetails.innerHTML = `
                <div class="flex items-center">
                    <i data-lucide="user" class="h-4 w-4 text-primary mr-2"></i>
                    <span>${userData.fullName || 'Người dùng'}</span>
                </div>
                <div class="flex items-center">
                    <i data-lucide="phone" class="h-4 w-4 text-primary mr-2"></i>
                    <span>0901 234 567</span>
                </div>
                <div class="flex items-center md:col-span-2">
                    <i data-lucide="mail" class="h-4 w-4 text-primary mr-2"></i>
                    <span>${userData.email}</span>
                </div>
                <div class="flex items-center md:col-span-2">
                    <i data-lucide="map-pin" class="h-4 w-4 text-primary mr-2"></i>
                    <span>123 Nguyễn Văn Linh, Quận 7, TP.HCM</span>
                </div>
            `;
        } else {
            guestForm.style.display = 'block';
            userDisplay.style.display = 'none';
        }

        // Populate booking summary
        this.populateBookingSummary();
        lucide.createIcons();
    }

    populateBookingSummary() {
        const selectedCartItems = this.cartItems.filter(item => this.selectedServices.includes(item.serviceId));
        const totalPrice = selectedCartItems.reduce((sum, item) => sum + (item.servicePrice * item.quantity), 0);

        const summaryContent = document.getElementById('step4-summary-content');
        summaryContent.innerHTML = selectedCartItems.map(item => `
            <div class="flex items-center justify-between p-4 bg-spa-cream rounded-lg">
                <div class="flex items-center space-x-4">
                    <img src="${item.serviceImage}" alt="${item.serviceName}" class="w-16 h-16 object-cover rounded-lg">
                    <div>
                        <h4 class="font-semibold text-spa-dark">${item.serviceName}</h4>
                        <p class="text-sm text-primary">${new Date(this.selectedTimeSlot.date).toLocaleDateString('vi-VN')} - ${this.selectedTimeSlot.time}</p>
                        <p class="text-sm text-gray-600">Nhân viên: ${this.selectedTherapist.name}</p>
                    </div>
                </div>
                <div class="text-right">
                    <div class="text-lg font-bold text-primary">${(item.servicePrice * item.quantity).toLocaleString()}đ</div>
                </div>
            </div>
        `).join('') + `
            <div class="border-t pt-4">
                <div class="flex justify-between text-xl font-bold">
                    <span>Tổng cộng:</span>
                    <span class="text-primary">${totalPrice.toLocaleString()}đ</span>
                </div>
            </div>
        `;
    }

    populateStep5() {
        // Populate booking review
        const selectedCartItems = this.cartItems.filter(item => this.selectedServices.includes(item.serviceId));
        const totalPrice = selectedCartItems.reduce((sum, item) => sum + (item.servicePrice * item.quantity), 0);
        const totalDuration = selectedCartItems.reduce((sum, item) => sum + (item.serviceDuration * item.quantity), 0);

        const reviewElement = document.getElementById('step5-booking-review');
        reviewElement.innerHTML = `
            <div class="flex justify-between">
                <span class="text-gray-600">Dịch vụ:</span>
                <span class="font-medium">${selectedCartItems.map(item => item.serviceName).join(', ')}</span>
            </div>
            <div class="flex justify-between">
                <span class="text-gray-600">Ngày:</span>
                <span class="font-medium">${new Date(this.selectedTimeSlot.date).toLocaleDateString('vi-VN')}</span>
            </div>
            <div class="flex justify-between">
                <span class="text-gray-600">Giờ:</span>
                <span class="font-medium">${this.selectedTimeSlot.time}</span>
            </div>
            <div class="flex justify-between">
                <span class="text-gray-600">Nhân viên:</span>
                <span class="font-medium">${this.selectedTherapist.name}</span>
            </div>
            <div class="flex justify-between">
                <span class="text-gray-600">Thời gian:</span>
                <span class="font-medium">${totalDuration} phút</span>
            </div>
            <div class="border-t pt-4">
                <div class="flex justify-between text-lg font-bold">
                    <span>Tổng cộng:</span>
                    <span class="text-primary">${totalPrice.toLocaleString()}đ</span>
                </div>
            </div>
        `;

        // Populate payment methods
        const paymentMethodsElement = document.getElementById('payment-methods');
        paymentMethodsElement.innerHTML = this.paymentMethods.map(method => `
            <div class="payment-method p-4 border-2 rounded-lg cursor-pointer transition-all ${
                this.selectedPaymentMethod === method.id ? 'selected' : 'border-gray-200 hover:border-primary hover:bg-spa-cream'
            }" onclick="booking.selectPaymentMethod('${method.id}')">
                <div class="flex items-center justify-between">
                    <div class="flex items-center">
                        <span class="text-2xl mr-3">${method.icon}</span>
                        <div>
                            <h4 class="font-semibold text-spa-dark">${method.name}</h4>
                            <p class="text-sm text-gray-600">${method.description}</p>
                        </div>
                    </div>
                    ${this.selectedPaymentMethod === method.id ? '<i data-lucide="check-circle" class="h-6 w-6 text-primary"></i>' : ''}
                </div>
            </div>
        `).join('');

        this.updateQRPaymentSection();
        lucide.createIcons();
    }

    selectPaymentMethod(methodId) {
        this.selectedPaymentMethod = methodId;
        
        // Update payment method cards
        const paymentCards = document.querySelectorAll('.payment-method');
        paymentCards.forEach(card => {
            card.classList.remove('selected');
            if (card.getAttribute('onclick').includes(methodId)) {
                card.classList.add('selected');
            }
        });

        this.updateQRPaymentSection();
        lucide.createIcons();
    }

    updateQRPaymentSection() {
        const qrSection = document.getElementById('qr-payment-section');
        const qrInstructions = document.getElementById('qr-instructions');
        
        if (['momo', 'zalopay', 'banking'].includes(this.selectedPaymentMethod)) {
            qrSection.style.display = 'block';
            const methodName = this.paymentMethods.find(m => m.id === this.selectedPaymentMethod)?.name;
            qrInstructions.textContent = `Quét mã QR bằng ứng dụng ${methodName}`;
        } else {
            qrSection.style.display = 'none';
        }
    }

    copyQRCode() {
        const selectedCartItems = this.cartItems.filter(item => this.selectedServices.includes(item.serviceId));
        const serviceNames = selectedCartItems.map(item => item.serviceName).join(', ');
        const totalPrice = selectedCartItems.reduce((sum, item) => sum + (item.servicePrice * item.quantity), 0);
        
        const qrText = `Mã đặt lịch: ${this.bookingCode}\nSpa Hương Sen\nDịch vụ: ${serviceNames}\nNhân viên: ${this.selectedTherapist?.name}\nThời gian: ${this.selectedTimeSlot?.date} ${this.selectedTimeSlot?.time}\nGiá: ${totalPrice.toLocaleString()}đ`;
        
        navigator.clipboard.writeText(qrText);
        
        const copyBtn = document.getElementById('copy-qr-btn');
        const originalContent = copyBtn.innerHTML;
        copyBtn.innerHTML = '<i data-lucide="check" class="h-4 w-4 mr-2"></i><span>Đã sao chép</span>';
        
        setTimeout(() => {
            copyBtn.innerHTML = originalContent;
            lucide.createIcons();
        }, 2000);
        
        lucide.createIcons();
    }
}

// Initialize booking system when DOM is ready
let booking;
document.addEventListener('DOMContentLoaded', function() {
    if (document.getElementById('step-1')) {
        booking = new MultiStepBooking();
    }
}); 