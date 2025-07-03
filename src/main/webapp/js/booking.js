// js/booking.js

class BookingPage {
    constructor() {
        this.services = [
            { id: 'facial-basic', name: 'Chăm sóc da mặt cơ bản', duration: '60 phút', price: '299.000đ' },
            { id: 'facial-advanced', name: 'Điều trị mụn chuyên sâu', duration: '90 phút', price: '599.000đ' },
            { id: 'massage-relaxing', name: 'Massage thư giãn toàn thân', duration: '90 phút', price: '499.000đ' },
            { id: 'massage-herbal', name: 'Massage thảo dược', duration: '75 phút', price: '399.000đ' },
            { id: 'whitening-collagen', name: 'Tắm trắng collagen', duration: '45 phút', price: '299.000đ' },
            { id: 'detox-herbal', name: 'Detox thảo dược', duration: '60 phút', price: '399.000đ' },
            { id: 'package-basic', name: 'Gói Chăm sóc Cơ bản', duration: '150 phút', price: '699.000đ' },
            { id: 'package-vip', name: 'Gói VIP Premium', duration: '240 phút', price: '1.299.000đ' }
        ];

        this.timeSlots = [
            '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
            '14:00', '14:30', '15:00', '15:30', '16:00', '16:30',
            '17:00', '17:30', '18:00', '18:30', '19:00', '19:30'
        ];
        
        this.selectedService = null;
        this.selectedTime = null;

        this.init();
    }

    init() {
        this.initDOM();
        this.populateServices();
        this.populateDates();
        this.populateTimeSlots();
        this.initEventListeners();
        this.checkUrlParams();
    }

    initDOM() {
        this.form = document.getElementById('booking-form');
        this.servicesContainer = document.getElementById('services-container');
        this.dateSelect = document.getElementById('date-select');
        this.timeSlotsContainer = document.getElementById('time-slots-container');
        
        this.bookingFormView = document.getElementById('booking-form-view');
        this.confirmationView = document.getElementById('confirmation-view');
        this.bookingSummary = document.getElementById('booking-summary');
        this.newBookingBtn = document.getElementById('new-booking-btn');
    }

    populateServices() {
        this.services.forEach(service => {
            const label = document.createElement('label');
            label.className = 'cursor-pointer';
            label.innerHTML = `
                <input type="radio" name="service" value="${service.id}" class="sr-only service-radio">
                <div class="service-card-item border-2 rounded-lg p-4 transition-all border-gray-200 hover:border-primary">
                    <h3 class="font-semibold text-spa-dark">${service.name}</h3>
                    <p class="text-sm text-gray-600">${service.duration}</p>
                    <p class="text-lg font-bold text-primary">${service.price}</p>
                </div>
            `;
            this.servicesContainer.appendChild(label);
        });
    }

    populateDates() {
        const today = new Date();
        let options = '<option value="">Chọn ngày...</option>';
        for (let i = 1; i <= 30; i++) {
            const date = new Date(today);
            date.setDate(today.getDate() + i);
            const value = date.toISOString().split('T')[0];
            const display = date.toLocaleDateString('vi-VN', { 
                weekday: 'long', 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric' 
            });
            options += `<option value="${value}">${display}</option>`;
        }
        this.dateSelect.innerHTML = options;
    }

    populateTimeSlots() {
        this.timeSlots.forEach(time => {
            const label = document.createElement('label');
            label.className = 'cursor-pointer';
            label.innerHTML = `
                <input type="radio" name="time" value="${time}" class="sr-only time-radio">
                <div class="time-slot-item text-center py-2 px-3 border-2 rounded-lg transition-all border-gray-200 hover:border-primary">
                    ${time}
                </div>
            `;
            this.timeSlotsContainer.appendChild(label);
        });
    }

    initEventListeners() {
        this.form.addEventListener('submit', (e) => this.handleSubmit(e));
        
        this.servicesContainer.addEventListener('change', (e) => {
            if (e.target.classList.contains('service-radio')) {
                this.selectedService = e.target.value;
                this.updateSelectedCard(this.servicesContainer, '.service-card-item');
            }
        });
        
        this.timeSlotsContainer.addEventListener('change', (e) => {
            if (e.target.classList.contains('time-radio')) {
                this.selectedTime = e.target.value;
                this.updateSelectedCard(this.timeSlotsContainer, '.time-slot-item', 'bg-primary text-white', 'bg-transparent text-gray-700');
            }
        });

        this.newBookingBtn.addEventListener('click', () => this.resetForm());
    }
    
    updateSelectedCard(container, itemSelector, activeClasses = 'border-primary bg-spa-cream', inactiveClasses = 'border-gray-200') {
        container.querySelectorAll(itemSelector).forEach(item => {
            const radio = item.previousElementSibling;
            item.classList.remove(...activeClasses.split(' '));
            item.classList.add(...inactiveClasses.split(' '));
            if (radio.checked) {
                item.classList.remove(...inactiveClasses.split(' '));
                item.classList.add(...activeClasses.split(' '));
            }
        });
    }

    checkUrlParams() {
        const urlParams = new URLSearchParams(window.location.search);
        const serviceId = urlParams.get('service');
        if (serviceId) {
            const serviceRadio = this.servicesContainer.querySelector(`input[value="${serviceId}"]`);
            if (serviceRadio) {
                serviceRadio.checked = true;
                this.selectedService = serviceId;
                this.updateSelectedCard(this.servicesContainer, '.service-card-item');
            }
        }
    }

    handleSubmit(e) {
        e.preventDefault();
        const formData = new FormData(this.form);
        const data = Object.fromEntries(formData.entries());

        if (!this.selectedService || !data.date || !this.selectedTime || !data.name || !data.phone) {
            SpaApp.showNotification('Vui lòng điền đầy đủ các trường bắt buộc.', 'error');
            return;
        }

        const serviceName = this.services.find(s => s.id === this.selectedService)?.name;
        const dateDisplay = this.dateSelect.options[this.dateSelect.selectedIndex].text;
        
        this.bookingSummary.innerHTML = `
            <h3 class="font-semibold text-spa-dark mb-4">Thông tin đặt lịch:</h3>
            <div class="space-y-2 text-left">
                <p><strong>Dịch vụ:</strong> ${serviceName}</p>
                <p><strong>Ngày:</strong> ${dateDisplay}</p>
                <p><strong>Giờ:</strong> ${this.selectedTime}</p>
                <p><strong>Tên:</strong> ${data.name}</p>
                <p><strong>Điện thoại:</strong> ${data.phone}</p>
            </div>
        `;

        this.bookingFormView.classList.add('hidden');
        this.confirmationView.classList.remove('hidden');
        window.scrollTo(0, 0);
        lucide.createIcons();
    }
    
    resetForm() {
        this.form.reset();
        this.selectedService = null;
        this.selectedTime = null;
        this.updateSelectedCard(this.servicesContainer, '.service-card-item');
        this.updateSelectedCard(this.timeSlotsContainer, '.time-slot-item', 'bg-primary text-white', 'bg-transparent text-gray-700');
        
        this.confirmationView.classList.add('hidden');
        this.bookingFormView.classList.remove('hidden');
    }
}

document.addEventListener('DOMContentLoaded', () => {
    if (document.getElementById('booking-form')) {
        new BookingPage();
    }
}); 