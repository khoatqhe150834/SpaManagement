// Therapist Selection JavaScript
console.log('👨‍⚕️ Therapist Selection JS Loading...');

// State management
let selectedServices = [];
let selectedTherapists = {};
let allTherapists = [];
let recentTherapists = [];
let availableTherapists = {};

// Get context path for API calls
function getContextPath() {
    return '/spa';
}

// Initialize the page
function initializeTherapistSelection() {
    console.log('🚀 Initializing Therapist Selection...');
    
    loadBookingState();
    loadSelectedServicesFromServer();
    setupEventListeners();
    
    console.log('✅ Therapist Selection initialized successfully');
}

// Load booking state from storage
function loadBookingState() {
    if (window.BookingStorage) {
        const savedServices = window.BookingStorage.getSelectedServices();
        const savedTherapist = window.BookingStorage.getSelectedTherapist();
        
        if (savedServices && savedServices.length > 0) {
            selectedServices = savedServices;
            console.log('📋 Loaded services from storage:', selectedServices);
        }
        
        if (savedTherapist) {
            console.log('👨‍⚕️ Loaded therapist from storage:', savedTherapist);
        }
    }
}

// Load selected services from server (JSP data)
function loadSelectedServicesFromServer() {
    // Get services from the JSP rendered data
    const serviceElements = document.querySelectorAll('.service-therapist-item');
    selectedServices = [];
    
    serviceElements.forEach(element => {
        const serviceId = element.dataset.serviceId;
        const serviceName = element.querySelector('.service-name').textContent.trim();
        const durationText = element.querySelector('.service-duration').textContent.trim();
        const priceText = element.querySelector('.service-price').textContent.trim();
        
        // Extract numeric values
        const duration = durationText.match(/\d+/)?.[0] || '0';
        const price = priceText.replace(/[^\d]/g, '') || '0';
        
        const service = {
            id: serviceId,
            name: serviceName,
            duration: `${duration} phút`,
            price: `${parseInt(price).toLocaleString('vi-VN')} VND`,
            priceValue: parseInt(price)
        };
        
        selectedServices.push(service);
        
        // Initialize therapist selection state
        selectedTherapists[serviceId] = {
            type: 'auto',
            therapistId: null
        };
    });
    
    console.log('📋 Loaded selected services from server:', selectedServices);
    
    // Load therapists for the selected services
    loadTherapistsForServices();
    initializeSelectionState();
    loadRecentTherapists();
}

// Load therapists for selected services
async function loadTherapistsForServices() {
    try {
        const serviceIds = selectedServices.map(service => service.id);
        const contextPath = getContextPath();
        const url = `${contextPath}/api/therapists?serviceIds=${serviceIds.join(',')}`;
        
        console.log('🔍 Loading therapists for services:', serviceIds);
        console.log('🔍 API URL:', url);
        
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const data = await response.json();
        console.log('👥 Therapists API response:', data);
        
        // Store available therapists for each service
        if (data && Array.isArray(data)) {
            allTherapists = data;
            
            // Group therapists by service compatibility
            selectedServices.forEach(service => {
                availableTherapists[service.id] = allTherapists.filter(therapist => 
                    therapist.available && therapist.availabilityStatus === 'AVAILABLE'
                );
            });
            
            console.log('👥 Available therapists by service:', availableTherapists);
        }
        
    } catch (error) {
        console.error('❌ Error loading therapists:', error);
        // Use fallback data
        allTherapists = getSampleTherapists();
        selectedServices.forEach(service => {
            availableTherapists[service.id] = allTherapists;
        });
    }
}

// Get sample therapists as fallback
function getSampleTherapists() {
    return [
        {
            staffId: 1,
            user: {
                fullName: 'An Nguyễn',
                email: 'an.nguyen@spa.com'
            },
            specialization: 'Chuyên gia massage',
            experienceYears: 5,
            available: true,
            availabilityStatus: 'AVAILABLE'
        },
        {
            staffId: 2,
            user: {
                fullName: 'Minh Trần',
                email: 'minh.tran@spa.com'
            },
            specialization: 'Chuyên gia da và nail',
            experienceYears: 4,
            available: true,
            availabilityStatus: 'AVAILABLE'
        },
        {
            staffId: 3,
            user: {
                fullName: 'Deni',
                email: 'deni@spa.com'
            },
            specialization: 'Chuyên gia da',
            experienceYears: 3,
            available: true,
            availabilityStatus: 'AVAILABLE'
        }
    ];
}

// Load recent therapists (placeholder for now)
function loadRecentTherapists() {
    // TODO: Implement actual recent therapists from user history
    recentTherapists = [];
    console.log('⏰ Recent therapists (placeholder):', recentTherapists);
    
    // Hide recent section if no recent therapists
    const recentSection = document.querySelector('.rebook-section');
    if (recentTherapists.length === 0 && recentSection) {
        // Keep the section but show the no-recent message
        console.log('ℹ️ No recent therapists to display');
    }
}

// Initialize selection state
function initializeSelectionState() {
    selectedServices.forEach(service => {
        if (!selectedTherapists[service.id]) {
            selectedTherapists[service.id] = {
                type: 'auto',
                therapistId: null
            };
        }
    });
    console.log('🎯 Initialized selection state:', selectedTherapists);
    updateSummary();
}

// Setup event listeners
function setupEventListeners() {
    // Continue button
    const continueBtn = document.getElementById('continueBtn');
    if (continueBtn) {
        continueBtn.addEventListener('click', handleContinue);
    }
    
    // View all therapists button
    const viewAllBtn = document.getElementById('viewAllTherapists');
    if (viewAllBtn) {
        viewAllBtn.addEventListener('click', toggleAllTherapistsSection);
    }
    
    // Therapist option buttons
    document.querySelectorAll('.therapist-option').forEach(button => {
        button.addEventListener('click', handleTherapistOptionClick);
    });
    
    console.log('🎧 Event listeners set up');
}

// Handle therapist option click
function handleTherapistOptionClick(event) {
    const button = event.currentTarget;
    const serviceId = button.dataset.serviceId;
    const selectionType = button.dataset.selection;
    
    console.log(`🎯 Therapist option clicked: ${selectionType} for service ${serviceId}`);
    
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
        // Hide therapist cards
        const therapistCards = container.querySelector('.therapist-cards');
        if (therapistCards) {
            therapistCards.style.display = 'none';
        }
    } else if (selectionType === 'manual') {
        // Show therapist cards
        const therapistCards = container.querySelector('.therapist-cards');
        if (therapistCards) {
            therapistCards.style.display = 'block';
            renderTherapistCards(serviceId);
        }
    }
    
    updateSummary();
}

// Render therapist cards for a specific service
function renderTherapistCards(serviceId) {
    const container = document.getElementById(`therapistGrid${serviceId}`);
    if (!container) return;
    
    const therapists = availableTherapists[serviceId] || [];
    
    if (therapists.length === 0) {
        container.innerHTML = `
            <div class="no-therapists-message" style="text-align: center; padding: 2rem; color: #6b7280;">
                <iconify-icon icon="mdi:account-off" style="font-size: 3rem; margin-bottom: 1rem;"></iconify-icon>
                <p>Không có chuyên gia nào khả dụng</p>
                <small>Vui lòng chọn tự động hoặc thử lại sau</small>
            </div>
        `;
        return;
    }
    
    const html = therapists.map(therapist => {
        const isSelected = selectedTherapists[serviceId].therapistId === therapist.staffId;
        const initials = getInitials(therapist.user.fullName);
        
        return `
            <div class="therapist-card ${isSelected ? 'selected' : ''}" 
                 data-therapist-id="${therapist.staffId}" 
                 data-service-id="${serviceId}">
                <div class="therapist-avatar">
                    <img src="https://placehold.co/80x80/E2E8F0/4A5568?text=${initials}" 
                         alt="${therapist.user.fullName}">
                    <div class="therapist-rating">
                        <iconify-icon icon="mdi:star"></iconify-icon>
                        <span>4.8</span>
                    </div>
                </div>
                <div class="therapist-info">
                    <h4 class="therapist-name">${therapist.user.fullName}</h4>
                    <p class="specialty">${therapist.specialization || 'Chuyên gia spa'}</p>
                    <p class="experience">${therapist.experienceYears || 3} năm kinh nghiệm</p>
                </div>
            </div>
        `;
    }).join('');
    
    container.innerHTML = html;
    
    // Add click listeners to therapist cards
    container.querySelectorAll('.therapist-card').forEach(card => {
        card.addEventListener('click', handleTherapistCardClick);
    });
}

// Handle therapist card click
function handleTherapistCardClick(event) {
    const card = event.currentTarget;
    const therapistId = parseInt(card.dataset.therapistId);
    const serviceId = card.dataset.serviceId;
    
    console.log(`👨‍⚕️ Therapist selected: ${therapistId} for service ${serviceId}`);
    
    // Update selection state
    selectedTherapists[serviceId].therapistId = therapistId;
    
    // Update card states
    const container = card.closest('.therapist-grid');
    container.querySelectorAll('.therapist-card').forEach(c => c.classList.remove('selected'));
    card.classList.add('selected');
    
    updateSummary();
}

// Get initials from full name
function getInitials(fullName) {
    return fullName
        .split(' ')
        .map(name => name.charAt(0))
        .join('')
        .toUpperCase()
        .substring(0, 2);
}

// Toggle all therapists section
function toggleAllTherapistsSection() {
    const section = document.querySelector('.all-therapists-section');
    if (section) {
        const isHidden = section.style.display === 'none';
        section.style.display = isHidden ? 'block' : 'none';
        
        if (isHidden) {
            renderAllTherapists();
        }
    }
}

// Render all therapists
function renderAllTherapists() {
    const container = document.getElementById('allTherapistsGrid');
    if (!container) return;
    
    const html = allTherapists.map(therapist => {
        const initials = getInitials(therapist.user.fullName);
        
        return `
            <div class="therapist-card" data-therapist-id="${therapist.staffId}">
                <div class="therapist-avatar">
                    <img src="https://placehold.co/80x80/E2E8F0/4A5568?text=${initials}" 
                         alt="${therapist.user.fullName}">
                    <div class="therapist-rating">
                        <iconify-icon icon="mdi:star"></iconify-icon>
                        <span>4.8</span>
                    </div>
                </div>
                <div class="therapist-info">
                    <h4 class="therapist-name">${therapist.user.fullName}</h4>
                    <p class="specialty">${therapist.specialization || 'Chuyên gia spa'}</p>
                    <p class="experience">${therapist.experienceYears || 3} năm kinh nghiệm</p>
                </div>
            </div>
        `;
    }).join('');
    
    container.innerHTML = html;
}

// Handle continue button
async function handleContinue() {
    console.log('➡️ Continuing to time selection');
    
    try {
        // Prepare therapist selection data
        const therapistSelections = {};
        let finalTherapistId = null;
        
        // For simplicity, if all services use auto-selection or if there's a single manual selection,
        // we'll use one therapist for the entire appointment
        const manualSelections = Object.values(selectedTherapists).filter(selection => 
            selection.type === 'manual' && selection.therapistId
        );
        
        if (manualSelections.length > 0) {
            // Use the first manually selected therapist
            finalTherapistId = manualSelections[0].therapistId;
        } else {
            // Use auto-selection - let the server choose
            finalTherapistId = null;
        }
        
        // Save to browser storage
        if (window.BookingStorage && finalTherapistId) {
            const selectedTherapist = allTherapists.find(t => t.staffId === finalTherapistId);
            if (selectedTherapist) {
                window.BookingStorage.saveSelectedTherapist(selectedTherapist);
            }
        }
        
        // Save to server session
        const formData = new FormData();
        if (finalTherapistId) {
            formData.append('therapistId', finalTherapistId);
        } else {
            formData.append('therapistId', 'auto');
        }
        
        const contextPath = getContextPath();
        const response = await fetch(`${contextPath}/process-booking/save-therapist`, {
            method: 'POST',
            body: formData,
            credentials: 'same-origin'
        });
        
        const data = await response.json();
        if (data.success) {
            console.log('✅ Therapist selection saved successfully');
            // Redirect to time selection
            window.location.href = `${contextPath}/process-booking/time-selection`;
        } else {
            console.error('❌ Error saving therapist selection:', data.message);
            alert('Có lỗi xảy ra khi lưu lựa chọn chuyên gia. Vui lòng thử lại.');
        }
        
    } catch (error) {
        console.error('❌ Error in handleContinue:', error);
        alert('Có lỗi xảy ra. Vui lòng thử lại.');
    }
}

// Update summary
function updateSummary() {
    updateSummaryServices();
    console.log('📊 Summary updated');
}

// Update summary services
function updateSummaryServices() {
    const summaryItems = document.querySelectorAll('.summary-service-item');
    
    summaryItems.forEach(item => {
        const serviceId = item.dataset.serviceId;
        const selection = selectedTherapists[serviceId];
        const statusElement = item.querySelector('.therapist-selection-status');
        
        if (statusElement && selection) {
            if (selection.type === 'auto') {
                statusElement.className = 'therapist-selection-status auto';
                statusElement.innerHTML = `
                    <iconify-icon icon="mdi:auto-fix"></iconify-icon>
                    <span>Tự động chọn chuyên gia</span>
                `;
            } else if (selection.type === 'manual' && selection.therapistId) {
                const therapist = allTherapists.find(t => t.staffId === selection.therapistId);
                if (therapist) {
                    statusElement.className = 'therapist-selection-status manual';
                    statusElement.innerHTML = `
                        <iconify-icon icon="mdi:account-check"></iconify-icon>
                        <span>${therapist.user.fullName}</span>
                    `;
                }
            } else {
                statusElement.className = 'therapist-selection-status manual';
                statusElement.innerHTML = `
                    <iconify-icon icon="mdi:account-search"></iconify-icon>
                    <span>Chọn chuyên gia...</span>
                `;
            }
        }
    });
}

// Handle quick rebook (placeholder for future implementation)
function handleQuickRebook(therapistId) {
    console.log(`⚡ Quick rebook with therapist: ${therapistId}`);
    // TODO: Implement quick rebook functionality
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    console.log('📄 DOM loaded, initializing therapist selection...');
    initializeTherapistSelection();
}); 