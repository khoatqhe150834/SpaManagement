// Service data
const services = [
  {
      id: '1',
      name: 'Pedicure Treatments - (client to provide flip flops)',
      duration: '10 phút - 1 giờ, 40 phút',
      price: 'từ 3 £',
      priceValue: 3,
      description: 'IMPORTANT MESSAGE - Perfect You are proud to offer our clients 100% steriliz...',
      category: 'pedicure'
  },
  {
      id: '2',
      name: 'Manicure Treatments',
      duration: '5 phút - 1 giờ, 30 phút',
      price: 'từ 3 £',
      priceValue: 3,
      description: 'IMPORTANT MESSAGE - Perfect You are proud to offer our clients 100% steriliz...',
      category: 'manicure'
  },
  {
      id: '3',
      name: 'BIAB Overlay',
      duration: '1 giờ, 50 phút',
      price: '45 £',
      priceValue: 45,
      description: 'BIAB or in other words builder in the bottle. What is it? Gel like polish applied as...',
      category: 'biab'
  },
  {
      id: '4',
      name: 'UV Gel Nail Extensions & Infills ( GEL FINISH ONLY)',
      duration: '1 giờ, 45 phút - 2 giờ, 35 phút',
      price: 'từ 46 £',
      priceValue: 46,
      description: 'UV Gel UV Gel extensions are not plastic tips! We put a form under your natural...',
      category: 'extensions'
  },
  {
      id: '5',
      name: 'Classic Facial Treatment',
      duration: '1 giờ',
      price: '35 £',
      priceValue: 35,
      description: 'Relaxing facial treatment with deep cleansing and moisturizing...',
      category: 'facial'
  },
  {
      id: '6',
      name: 'Eyebrow Threading',
      duration: '15 phút',
      price: '12 £',
      priceValue: 12,
      description: 'Professional eyebrow shaping using traditional threading technique...',
      category: 'eyebrows'
  },
  {
      id: '7',
      name: 'Luxury Spa Pedicure',
      duration: '1 giờ, 30 phút',
      price: '55 £',
      priceValue: 55,
      description: 'Premium pedicure with exfoliation, massage, and luxury treatments...',
      category: 'pedicure'
  },
  {
      id: '8',
      name: 'Gel Polish Manicure',
      duration: '45 phút',
      price: '25 £',
      priceValue: 25,
      description: 'Long-lasting gel polish application with professional finish...',
      category: 'manicure'
  },
  {
      id: '9',
      name: 'Deep Cleansing Facial',
      duration: '1 giờ, 15 phút',
      price: '65 £',
      priceValue: 65,
      description: 'Intensive facial treatment for deep pore cleansing and skin renewal...',
      category: 'facial'
  },
  {
      id: '10',
      name: 'Acrylic Nail Extensions',
      duration: '2 giờ',
      price: '80 £',
      priceValue: 80,
      description: 'Professional acrylic nail extensions with custom design options...',
      category: 'extensions'
  }
];

// State management
let selectedServices = [];
let activeCategory = 'featured';
let searchQuery = '';
let minPrice = 0;
let maxPrice = 100;
const absoluteMinPrice = 0;
const absoluteMaxPrice = 100;

// DOM elements
const searchInput = document.getElementById('searchInput');
const minPriceInput = document.getElementById('minPriceInput');
const maxPriceInput = document.getElementById('maxPriceInput');
const minSlider = document.getElementById('minSlider');
const maxSlider = document.getElementById('maxSlider');
const sliderRange = document.getElementById('sliderRange');
const minValue = document.getElementById('minValue');
const maxValue = document.getElementById('maxValue');
const categoryBtns = document.querySelectorAll('.category-btn');
const servicesTitle = document.getElementById('servicesTitle');
const resetFilters = document.getElementById('resetFilters');
const servicesList = document.getElementById('servicesList');
const noResults = document.getElementById('noResults');
const selectedServicesContent = document.getElementById('selectedServicesContent');
const totalAmount = document.getElementById('totalAmount');
const continueBtn = document.getElementById('continueBtn');

// Initialize the application
function init() {
  setupEventListeners();
  updateSliderRange();
  renderServices();
  updateSelectedServices();
}

// Event listeners
function setupEventListeners() {
  // Search input
  searchInput.addEventListener('input', (e) => {
      searchQuery = e.target.value;
      renderServices();
      updateFiltersVisibility();
  });

  // Price inputs
  minPriceInput.addEventListener('input', (e) => {
      const value = parseInt(e.target.value) || 0;
      minPrice = Math.min(value, maxPrice);
      minPriceInput.value = minPrice;
      minSlider.value = minPrice;
      updateSliderRange();
      renderServices();
      updateFiltersVisibility();
  });

  maxPriceInput.addEventListener('input', (e) => {
      const value = parseInt(e.target.value) || 0;
      maxPrice = Math.max(value, minPrice);
      maxPriceInput.value = maxPrice;
      maxSlider.value = maxPrice;
      updateSliderRange();
      renderServices();
      updateFiltersVisibility();
  });

  // Range sliders
  minSlider.addEventListener('input', (e) => {
      const value = parseInt(e.target.value);
      minPrice = Math.min(value, maxPrice);
      minSlider.value = minPrice;
      minPriceInput.value = minPrice;
      updateSliderRange();
      renderServices();
      updateFiltersVisibility();
  });

  maxSlider.addEventListener('input', (e) => {
      const value = parseInt(e.target.value);
      maxPrice = Math.max(value, minPrice);
      maxSlider.value = maxPrice;
      maxPriceInput.value = maxPrice;
      updateSliderRange();
      renderServices();
      updateFiltersVisibility();
  });

  // Category buttons
  categoryBtns.forEach(btn => {
      btn.addEventListener('click', (e) => {
          activeCategory = e.target.dataset.category;
          updateCategoryButtons();
          renderServices();
      });
  });

  // Reset filters
  resetFilters.addEventListener('click', () => {
      searchQuery = '';
      minPrice = absoluteMinPrice;
      maxPrice = absoluteMaxPrice;
      
      searchInput.value = '';
      minPriceInput.value = minPrice;
      maxPriceInput.value = maxPrice;
      minSlider.value = minPrice;
      maxSlider.value = maxPrice;
      
      updateSliderRange();
      renderServices();
      updateFiltersVisibility();
  });

  // Continue button
  continueBtn.addEventListener('click', () => {
      if (selectedServices.length > 0) {
          alert('Proceeding to next step...');
      }
  });
}

// Update slider range visual
function updateSliderRange() {
  const percent1 = (minPrice / absoluteMaxPrice) * 100;
  const percent2 = (maxPrice / absoluteMaxPrice) * 100;
  
  sliderRange.style.left = percent1 + '%';
  sliderRange.style.width = (percent2 - percent1) + '%';
  
  minValue.textContent = `£${minPrice}`;
  maxValue.textContent = `£${maxPrice}`;
}

// Update category buttons
function updateCategoryButtons() {
  categoryBtns.forEach(btn => {
      btn.classList.toggle('active', btn.dataset.category === activeCategory);
  });
}

// Filter services
function getFilteredServices() {
  return services.filter(service => {
      const matchesSearch = service.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                           service.description.toLowerCase().includes(searchQuery.toLowerCase());
      const matchesPrice = service.priceValue >= minPrice && service.priceValue <= maxPrice;
      
      return matchesSearch && matchesPrice;
  });
}

// Render services
function renderServices() {
  const filteredServices = getFilteredServices();
  
  // Update title
  if (searchQuery) {
      servicesTitle.textContent = `Kết quả tìm kiếm (${filteredServices.length})`;
  } else {
      servicesTitle.textContent = 'Nổi bật';
  }
  
  // Show/hide no results
  if (filteredServices.length === 0) {
      servicesList.style.display = 'none';
      noResults.style.display = 'block';
      return;
  }
  
  servicesList.style.display = 'block';
  noResults.style.display = 'none';
  
  // Render service cards
  servicesList.innerHTML = filteredServices.map(service => `
      <div class="service-card">
          <div class="service-content">
              <div class="service-info">
                  <h3 class="service-name">${service.name}</h3>
                  <p class="service-duration">${service.duration}</p>
                  <p class="service-description">${service.description}</p>
                  <p class="service-price">${service.price}</p>
              </div>
              <button class="service-add-btn ${selectedServices.includes(service.id) ? 'selected' : ''}" 
                      onclick="toggleService('${service.id}')">
                  <i class="fas fa-plus"></i>
              </button>
          </div>
      </div>
  `).join('');
}

// Toggle service selection
function toggleService(serviceId) {
  if (selectedServices.includes(serviceId)) {
      selectedServices = selectedServices.filter(id => id !== serviceId);
  } else {
      selectedServices.push(serviceId);
  }
  
  renderServices();
  updateSelectedServices();
}

// Remove service
function removeService(serviceId) {
  selectedServices = selectedServices.filter(id => id !== serviceId);
  renderServices();
  updateSelectedServices();
}

// Update selected services display
function updateSelectedServices() {
  if (selectedServices.length === 0) {
      selectedServicesContent.innerHTML = '<p class="no-services">Không có dịch vụ nào được chọn</p>';
      totalAmount.textContent = 'miễn phí';
      continueBtn.disabled = true;
      return;
  }
  
  const selectedServiceItems = selectedServices.map(serviceId => {
      const service = services.find(s => s.id === serviceId);
      if (!service) return '';
      
      return `
          <div class="selected-service-item">
              <div class="selected-service-content">
                  <div class="selected-service-info">
                      <p class="selected-service-name">${service.name}</p>
                      <p class="selected-service-price">${service.price}</p>
                  </div>
                  <button class="remove-service-btn" onclick="removeService('${serviceId}')">
                      <i class="fas fa-times"></i>
                  </button>
              </div>
          </div>
      `;
  }).join('');
  
  selectedServicesContent.innerHTML = `<div class="selected-services-list">${selectedServiceItems}</div>`;
  
  // Calculate total
  const total = selectedServices.reduce((sum, serviceId) => {
      const service = services.find(s => s.id === serviceId);
      return service ? sum + service.priceValue : sum;
  }, 0);
  
  totalAmount.textContent = `${total} £`;
  continueBtn.disabled = false;
}

// Update filters visibility
function updateFiltersVisibility() {
  const hasActiveFilters = searchQuery || minPrice > absoluteMinPrice || maxPrice < absoluteMaxPrice;
  resetFilters.style.display = hasActiveFilters ? 'block' : 'none';
}

// Initialize the application when DOM is loaded
document.addEventListener('DOMContentLoaded', init);