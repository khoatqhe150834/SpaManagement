// Therapist Selection JavaScript
console.log('👨‍⚕️ Therapist Selection JS Loading...');

// State management
let selectedServices = [];
let selectedTherapists = {};
let allTherapists = [];
let recentTherapists = [];

// Sample data
const sampleServices = [
    {
        id: 1,
        name: 'Massage toàn thân thư giãn',
        duration: '90 phút',
        price: '1,200,000 VND',
        priceValue: 1200000,
        icon: 'mdi:spa'
    },
    {
        id: 2,
        name: 'Chăm sóc da mặt cơ bản',
        duration: '60 phút',
        price: '800,000 VND',
        priceValue: 800000,
        icon: 'mdi:leaf'
    }
];

const sampleTherapists = [
    {
        id: 1,
        name: 'An Nguyễn',
        specialty: 'Chuyên gia massage',
        rating: 4.9,
        experience: '5 năm kinh nghiệm',
        avatar: 'https://placehold.co/80x80/E2E8F0/4A5568?text=AN',
        available: true
    },
    {
        id: 2,
        name: 'Minh Trần',
        specialty: 'Chuyên gia da và nail',
        rating: 4.8,
        experience: '4 năm kinh nghiệm',
        avatar: 'https://placehold.co/80x80/E2E8F0/4A5568?text=MT',
        available: true
    },
    {
        id: 3,
        name: 'Deni',
        specialty: 'Chuyên gia da',
        rating: 4.8,
        experience: '3 năm kinh nghiệm',
        avatar: 'https://placehold.co/80x80/E2E8F0/4A5568?text=DN',
        available: true
    }
];

// Initialize the page
function initializeTherapistSelection() {
    console.log('🚀 Initializing Therapist Selection...');
    
    loadSelectedServices();
    loadRecentTherapists();
    loadAllTherapists();
    setupEventListeners();
    initializeSelectionState();
    renderSelectedServices();
    renderRecentTherapists();
    updateSummary();
    
    console.log('✅ Therapist Selection initialized successfully');
}

// Load selected services
function loadSelectedServices() {
    selectedServices = sampleServices;
    console.log('📋 Loaded selected services:', selectedServices);
}

// Load recent therapists
function loadRecentTherapists() {
    recentTherapists = [
        { ...sampleTherapists[0], lastVisit: '15/05/2025' },
        { ...sampleTherapists[2], lastVisit: '10/05/2025' }
    ];
    console.log('⏰ Loaded recent therapists:', recentTherapists);
}

// Load all therapists
function loadAllTherapists() {
    allTherapists = sampleTherapists;
    console.log('👥 Loaded all therapists:', allTherapists);
}

// Initialize selection state
function initializeSelectionState() {
    selectedServices.forEach(service => {
        selectedTherapists[service.id] = {
            type: 'auto',
            therapistId: null
        };
    });
    console.log('🎯 Initialized selection state:', selectedTherapists);
}

// Setup event listeners
function setupEventListeners() {
    const continueBtn = document.getElementById('continueBtn');
    if (continueBtn) {
        continueBtn.addEventListener('click', handleContinue);
    }
}

// Handle continue button
function handleContinue() {
    console.log('➡️ Continuing to time selection');
    window.location.href = '/spa/appointments/time-selection';
}

// Render selected services
function renderSelectedServices() {
    const container = document.getElementById('selectedServicesList');
    if (!container) return;
    
    const html = selectedServices.map(service => `
        <div class="service-therapist-item" data-service-id="${service.id}">
            <div class="service-info">
                <h3 class="service-name">
                    <iconify-icon icon="${service.icon}"></iconify-icon>
                    ${service.name}
                </h3>
                <div class="service-details">
                    <span class="service-duration">
                        <iconify-icon icon="mdi:clock-outline"></iconify-icon>
                        ${service.duration}
                    </span>
                    <span class="service-price">
                        <iconify-icon icon="mdi:tag"></iconify-icon>
                        ${service.price}
                    </span>
                </div>
            </div>
            
            <div class="therapist-selection">
                <label class="selection-label">Chọn chuyên gia:</label>
                <div class="therapist-options">
                    <button class="therapist-option auto-assign active" 
                            data-service-id="${service.id}" data-selection="auto">
                        <iconify-icon icon="mdi:auto-fix"></iconify-icon>
                        <span>Tự động chọn</span>
                        <small>Hệ thống sẽ chọn chuyên gia phù hợp nhất</small>
                    </button>
                    <button class="therapist-option manual-select" 
                            data-service-id="${service.id}" data-selection="manual">
                        <iconify-icon icon="mdi:account-search"></iconify-icon>
                        <span>Chọn thủ công</span>
                        <small>Tự chọn chuyên gia ưa thích</small>
                    </button>
                </div>
            </div>
        </div>
    `).join('');
    
    container.innerHTML = html;
    
    // Setup option listeners
    document.querySelectorAll('.therapist-option').forEach(button => {
        button.addEventListener('click', handleTherapistOptionClick);
    });
}

// Handle therapist option click
function handleTherapistOptionClick(event) {
    const button = event.currentTarget;
    const serviceId = parseInt(button.dataset.serviceId);
    const selectionType = button.dataset.selection;
    
    // Update button states
    const container = button.closest('.service-therapist-item');
    container.querySelectorAll('.therapist-option').forEach(btn => {
        btn.classList.remove('active');
    });
    button.classList.add('active');
    
    // Update selection state
    selectedTherapists[serviceId].type = selectionType;
    if (selectionType === 'auto') {
        selectedTherapists[serviceId].therapistId = null;
    }
    
    updateSummary();
}

// Render recent therapists
function renderRecentTherapists() {
    const container = document.getElementById('recentTherapists');
    if (!container) return;
    
    const html = recentTherapists.map(therapist => `
        <div class="recent-therapist-card" data-therapist-id="${therapist.id}">
            <div class="therapist-avatar">
                <img src="${therapist.avatar}" alt="${therapist.name}">
                <div class="therapist-rating">
                    <iconify-icon icon="mdi:star"></iconify-icon>
                    <span>${therapist.rating}</span>
                </div>
            </div>
            <div class="therapist-info">
                <h3 class="therapist-name">${therapist.name}</h3>
                <p class="therapist-specialty">${therapist.specialty}</p>
                <p class="last-visit">Lần cuối: ${therapist.lastVisit}</p>
            </div>
            <button class="quick-rebook-btn" onclick="handleQuickRebook(${therapist.id})">
                <iconify-icon icon="mdi:lightning-bolt"></iconify-icon>
                Đặt lại
            </button>
        </div>
    `).join('');
    
    container.innerHTML = html;
}

// Handle quick rebook
function handleQuickRebook(therapistId) {
    console.log(`⚡ Quick rebook with therapist ${therapistId}`);
    
    const therapist = recentTherapists.find(t => t.id === therapistId);
    if (!therapist) return;
    
    // Set all services to manual with this therapist
    selectedServices.forEach(service => {
        selectedTherapists[service.id] = {
            type: 'manual',
            therapistId: therapistId
        };
    });
    
    // Update UI
    document.querySelectorAll('.recent-therapist-card').forEach(card => {
        card.classList.remove('selected');
    });
    const selectedCard = document.querySelector(`[data-therapist-id="${therapistId}"].recent-therapist-card`);
    if (selectedCard) {
        selectedCard.classList.add('selected');
    }
    
    updateSummary();
    
    // Show notification
    alert(`Đã chọn ${therapist.name} cho tất cả dịch vụ!`);
}

// Update summary
function updateSummary() {
    updateSummaryServices();
    updateSummaryTotal();
}

// Update summary services
function updateSummaryServices() {
    const container = document.getElementById('summaryServices');
    if (!container) return;
    
    const html = selectedServices.map(service => {
        const selection = selectedTherapists[service.id];
        let therapistInfo = '';
        
        if (selection.type === 'auto') {
            therapistInfo = `
                <div class="therapist-selection-status auto">
                    <iconify-icon icon="mdi:auto-fix"></iconify-icon>
                    <span>Tự động chọn chuyên gia</span>
                </div>
            `;
        } else if (selection.therapistId) {
            const therapist = allTherapists.find(t => t.id === selection.therapistId);
            therapistInfo = `
                <div class="therapist-selection-status manual">
                    <iconify-icon icon="mdi:account-check"></iconify-icon>
                    <span>${therapist ? therapist.name : 'Chuyên gia đã chọn'}</span>
                </div>
            `;
        } else {
            therapistInfo = `
                <div class="therapist-selection-status manual">
                    <iconify-icon icon="mdi:account-search"></iconify-icon>
                    <span>Chưa chọn chuyên gia</span>
                </div>
            `;
        }
        
        return `
            <div class="summary-service-item">
                <div class="service-summary">
                    <h4 class="service-name">${service.name}</h4>
                    <p class="service-meta">${service.duration} • ${service.price}</p>
                </div>
                <div class="therapist-summary">
                    ${therapistInfo}
                </div>
            </div>
        `;
    }).join('');
    
    container.innerHTML = html;
}

// Update summary total
function updateSummaryTotal() {
    const totalServices = selectedServices.length;
    const totalAmount = selectedServices.reduce((sum, service) => sum + service.priceValue, 0);
    
    const totalCountEl = document.querySelector('.total-count');
    if (totalCountEl) {
        totalCountEl.textContent = totalServices;
    }
    
    const totalPriceEl = document.querySelector('.total-price');
    if (totalPriceEl) {
        totalPriceEl.textContent = `${totalAmount.toLocaleString('vi-VN')} VND`;
    }
}

// Initialize when DOM loads
document.addEventListener('DOMContentLoaded', function() {
    console.log('🎭 DOM loaded, initializing therapist selection...');
    initializeTherapistSelection();
}); 