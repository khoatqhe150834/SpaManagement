// TEST: Verify JavaScript file is loading
console.log('🚀 service-selection.js is loading...');
alert('JavaScript file loaded!');

// Service data - will be loaded from API
let services = [];
let serviceTypes = [];
let currentServices = [];
let allServicesCache = new Map(); // Cache to store all fetched services

// State management
let selectedServices = [];
let activeCategory = 'all';
let searchQuery = '';
let minPrice = 0;
let maxPrice = 10000000;
const absoluteMinPrice = 0;
const absoluteMaxPrice = 10000000;
const priceStep = 100000; // 100,000 VND steps
const maxServicesAllowed = 6; // Maximum 6 services allowed

// DOM elements - will be initialized after DOM loads
let searchInput, minPriceInput, maxPriceInput, minSlider, maxSlider, sliderRange;
let minValue, maxValue, categoryBtns, servicesTitle, resetFilters;
let servicesList, noResults, selectedServicesContent, totalAmount, continueBtn;

// Initialize DOM elements
function initializeDOM() {
  searchInput = document.getElementById('searchInput');
  minPriceInput = document.getElementById('minPriceInput');
  maxPriceInput = document.getElementById('maxPriceInput');
  minSlider = document.getElementById('minSlider');
  maxSlider = document.getElementById('maxSlider');
  sliderRange = document.getElementById('sliderRange');
  minValue = document.getElementById('minValue');
  maxValue = document.getElementById('maxValue');
  servicesTitle = document.getElementById('servicesTitle');
  resetFilters = document.getElementById('resetFilters');
  servicesList = document.getElementById('servicesList');
  noResults = document.getElementById('noResults');
  selectedServicesContent = document.getElementById('selectedServicesContent');
  totalAmount = document.getElementById('totalAmount');
  continueBtn = document.getElementById('continueBtn');
  
  console.log('DOM elements initialized');
}

// Get context path for API calls
function getContextPath() {
  // For your specific setup, the context path is '/spa'
  return '/spa';
}

// Round price to nearest step
function roundToStep(value) {
  return Math.round(value / priceStep) * priceStep;
}

// API functions
async function fetchServiceTypes() {
  try {
    const contextPath = getContextPath();
    const url = `${contextPath}/api/service-types`;
    console.log('Fetching service types from:', url);
    
    const response = await fetch(url);
    console.log('Service types response status:', response.status);
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    const data = await response.json();
    console.log('Service types data received:', data);
    
    serviceTypes = data;
    return data;
  } catch (error) {
    console.error('Error fetching service types:', error);
    return [];
  }
}

async function fetchServices(filters = {}) {
  try {
    const contextPath = getContextPath();
    const params = new URLSearchParams();
    
    if (filters.category && filters.category !== 'all') {
      params.append('category', filters.category);
    }
    if (filters.search) {
      params.append('search', filters.search);
    }
    if (filters.minPrice !== undefined) {
      params.append('minPrice', filters.minPrice);
    }
    if (filters.maxPrice !== undefined) {
      params.append('maxPrice', filters.maxPrice);
    }

    const url = `${contextPath}/api/services?${params}`;
    console.log('Fetching services from:', url);
    console.log('Filters applied:', filters);
    
    const response = await fetch(url);
    console.log('Services response status:', response.status);
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    const data = await response.json();
    console.log('Services data received:', data);
    
    // DEBUG: Simple response structure check
    console.log('🔍 Response type:', typeof data, 'IsArray:', Array.isArray(data));
    
    // Try to extract services array
    if (Array.isArray(data)) {
      console.log('✅ Direct array, count:', data.length);
      return data;
    } else if (data && data.services && Array.isArray(data.services)) {
      console.log('✅ Services property, count:', data.services.length);
      return data.services;
    } else {
      console.log('❌ No services array found in response');
      console.log('Available keys:', data ? Object.keys(data) : 'none');
      return [];
    }
  } catch (error) {
    console.error('Error fetching services:', error);
    console.warn('Using fallback sample data due to API error');
    
    // Return sample data as fallback
    return [
      {
        serviceId: 1,
        name: "Sample Service (API Failed)",
        description: "This is sample data because API failed",
        price: 25,
        durationMinutes: 30,
        serviceTypeId: { name: "Sample Category" }
      }
    ];
  }
}

// Convert service data from backend format to frontend format
function transformServiceData(serviceList) {
  return serviceList.map(service => {
    const transformedService = {
      id: service.serviceId.toString(),
      name: service.name,
      duration: `${service.durationMinutes || 'N/A'} phút`,
      price: `${(service.price || 0).toLocaleString('vi-VN')} VND`,
      priceValue: service.price || 0,
      description: service.description || '',
      category: service.serviceTypeId?.name?.toLowerCase() || 'other'
    };
    
    // Cache the service for later use
    allServicesCache.set(transformedService.id, transformedService);
    return transformedService;
  });
}

// Initialize category dropdown with service types
async function initializeCategoryDropdown() {
  await fetchServiceTypes();
  
  const dropdownMenu = document.getElementById('categoryDropdownMenu');
  if (!dropdownMenu) return;
  
  // Clear existing items except all
  const allItem = dropdownMenu.querySelector('[data-category="all"]');
  dropdownMenu.innerHTML = '';
  
  // Add all item back
  if (allItem) {
    dropdownMenu.appendChild(allItem);
  } else {
    const allItem = document.createElement('button');
    allItem.className = 'category-dropdown-item active';
    allItem.dataset.category = 'all';
    allItem.innerHTML = '<i class="fas fa-star"></i>Tất cả';
    dropdownMenu.appendChild(allItem);
  }
  
  // Add service type items
  serviceTypes.forEach(serviceType => {
    console.log('📋 Creating dropdown item for service type:', serviceType.name, 'ID:', serviceType.serviceTypeId);
    
    const item = document.createElement('button');
    item.className = 'category-dropdown-item';
    // Use type-{typeId} format that the backend expects
    item.dataset.category = `type-${serviceType.serviceTypeId}`;
    
    console.log('📋 Set data-category to:', item.dataset.category);
    
    // Add appropriate icon for service type
    const icon = getServiceTypeIcon(serviceType.name);
    item.innerHTML = `<i class="${icon}"></i>${serviceType.name}`;
    
    dropdownMenu.appendChild(item);
  });
  
  // Setup dropdown event listeners
  setupDropdownEventListeners();
}

// Get appropriate icon for service type
function getServiceTypeIcon(serviceTypeName) {
  const name = serviceTypeName.toLowerCase();
  if (name.includes('massage')) return 'fas fa-spa';
  if (name.includes('chăm sóc da')) return 'fas fa-leaf';
  if (name.includes('móng')) return 'fas fa-hand-sparkles';
  if (name.includes('lông')) return 'fas fa-eye';
  if (name.includes('liệu pháp')) return 'fas fa-seedling';
  if (name.includes('cắp đôi')) return 'fas fa-heart';
  if (name.includes('định hình')) return 'fas fa-cut';
  if (name.includes('waxing')) return 'fas fa-feather';
  if (name.includes('truyền thống')) return 'fas fa-yin-yang';
  if (name.includes('thảo dược')) return 'fas fa-mortar-pestle';
  return 'fas fa-spa'; // default icon
}

// Setup event listeners for dropdown
function setupDropdownEventListeners() {
  const dropdown = document.getElementById('categoryDropdown');
  const dropdownButton = document.getElementById('categoryDropdownButton');
  const dropdownMenu = document.getElementById('categoryDropdownMenu');
  const dropdownText = dropdownButton.querySelector('.category-dropdown-text');
  
  // Toggle dropdown
  dropdownButton.addEventListener('click', (e) => {
    e.stopPropagation();
    dropdown.classList.toggle('open');
  });
  
  // Close dropdown when clicking outside
  document.addEventListener('click', (e) => {
    if (!dropdown.contains(e.target)) {
      dropdown.classList.remove('open');
    }
  });
  
  // Handle dropdown item selection
  dropdownMenu.addEventListener('click', async (e) => {
    const item = e.target.closest('.category-dropdown-item');
    if (item) {
      console.log('🎯 Service type clicked:', item.textContent);
      console.log('🎯 Dataset category:', item.dataset.category);
      
      // Update active state
      document.querySelectorAll('.category-dropdown-item').forEach(i => i.classList.remove('active'));
      item.classList.add('active');
      
      // Update button text
      const icon = item.querySelector('i').className;
      const text = item.textContent;
      dropdownText.textContent = text;
      
      // Update active category and load services
      activeCategory = item.dataset.category;
      console.log('🎯 Active category set to:', activeCategory);
      await loadAndRenderServices();
      
      // Close dropdown
      dropdown.classList.remove('open');
    }
  });
}

// Load and render services based on current filters
async function loadAndRenderServices() {
  const filters = {
    category: activeCategory,
    search: searchQuery,
    minPrice: minPrice,
    maxPrice: maxPrice
  };
  
  console.log('Loading services with filters:', filters);
  
  const fetchedServices = await fetchServices(filters);
  console.log('Fetched services count:', fetchedServices.length);
  
  if (fetchedServices.length === 0) {
    console.warn('No services received from API - this might indicate an API issue');
  }
  
  currentServices = transformServiceData(fetchedServices);
  console.log('Transformed services:', currentServices);
  
  renderServices();
}

// Initialize the application
async function init() {
  console.log('Initializing application...');
  
  // Initialize DOM elements first
  initializeDOM();
  
  setupEventListeners();
  updateSliderRange();
  
  console.log('About to initialize category dropdown...');
  await initializeCategoryDropdown();
  
  // TEST: Try fetching ALL services without any filters first
  console.log('🧪 TEST: Fetching all services without filters...');
  try {
    const response = await fetch('/spa/api/services');
    const allServicesData = await response.json();
    console.log('🧪 All services (no filters):', allServicesData);
    console.log('🧪 All services count:', allServicesData.services ? allServicesData.services.length : 'No services property');
  } catch (error) {
    console.error('🧪 Error fetching all services:', error);
  }
  
  console.log('About to load and render services...');
  await loadAndRenderServices();
  
  updateSelectedServices();
  console.log('Application initialization complete');
}

// Event listeners
function setupEventListeners() {
  // Search input
  searchInput.addEventListener('input', async (e) => {
      searchQuery = e.target.value;
      await loadAndRenderServices();
      updateFiltersVisibility();
  });

  // Price inputs
  minPriceInput.addEventListener('blur', async (e) => {
      const value = parseInt(e.target.value.replace(/[^\d]/g, '')) || 0;
      const roundedValue = roundToStep(value);
      minPrice = Math.min(roundedValue, maxPrice);
      minPriceInput.value = minPrice;
      minSlider.value = minPrice;
      updateSliderRange();
      await loadAndRenderServices();
      updateFiltersVisibility();
  });

  maxPriceInput.addEventListener('blur', async (e) => {
      const value = parseInt(e.target.value.replace(/[^\d]/g, '')) || 0;
      const roundedValue = roundToStep(value);
      maxPrice = Math.max(roundedValue, minPrice);
      maxPriceInput.value = maxPrice;
      maxSlider.value = maxPrice;
      updateSliderRange();
      await loadAndRenderServices();
      updateFiltersVisibility();
  });

  // Range sliders
  minSlider.addEventListener('input', (e) => {
      const value = parseInt(e.target.value);
      minPrice = Math.min(value, maxPrice);
      minSlider.value = minPrice;
      minPriceInput.value = minPrice;
      updateSliderRange();
  });

  minSlider.addEventListener('change', async (e) => {
      await loadAndRenderServices();
      updateFiltersVisibility();
  });

  maxSlider.addEventListener('input', (e) => {
      const value = parseInt(e.target.value);
      maxPrice = Math.max(value, minPrice);
      maxSlider.value = maxPrice;
      maxPriceInput.value = maxPrice;
      updateSliderRange();
  });

  maxSlider.addEventListener('change', async (e) => {
      await loadAndRenderServices();
      updateFiltersVisibility();
  });

  // Reset filters
  resetFilters.addEventListener('click', async () => {
      searchQuery = '';
      minPrice = absoluteMinPrice;
      maxPrice = absoluteMaxPrice;
      activeCategory = 'all';
      
      searchInput.value = '';
      minPriceInput.value = minPrice;
      maxPriceInput.value = maxPrice;
      minSlider.value = minPrice;
      maxSlider.value = maxPrice;
      
      // Reset dropdown to "all"
      document.querySelectorAll('.category-dropdown-item').forEach(i => i.classList.remove('active'));
      const allItem = document.querySelector('[data-category="all"]');
      if (allItem) {
          allItem.classList.add('active');
          const dropdownText = document.querySelector('.category-dropdown-text');
          if (dropdownText) dropdownText.textContent = 'Tất cả';
      }
      
      updateSliderRange();
      await loadAndRenderServices();
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
  
  minValue.textContent = `${minPrice.toLocaleString('vi-VN')} VND`;
  maxValue.textContent = `${maxPrice.toLocaleString('vi-VN')} VND`;
}

// Update category dropdown (no longer needed as it's handled in event listener)
function updateCategoryDropdown() {
  // This function is now handled by the dropdown event listeners
}

// Render services
function renderServices() {
  console.log('renderServices called with currentServices:', currentServices);
  
  // Check if required DOM elements exist
  if (!servicesList) {
    console.error('servicesList element not found! Check if #servicesList exists in HTML');
    return;
  }
  if (!servicesTitle) {
    console.error('servicesTitle element not found! Check if #servicesTitle exists in HTML');
    return;
  }
  
  const servicesToRender = currentServices;
  console.log('Services to render:', servicesToRender.length);
  
  // Update title
  if (searchQuery) {
      servicesTitle.textContent = `Kết quả tìm kiếm (${servicesToRender.length})`;
  } else if (activeCategory === 'all') {
      servicesTitle.textContent = 'Tất cả';
  } else if (activeCategory.startsWith('type-')) {
      // Extract type ID from "type-{id}" format
      const typeId = parseInt(activeCategory.substring(5));
      const categoryName = serviceTypes.find(type => type.serviceTypeId === typeId)?.name || 'Dịch vụ';
      servicesTitle.textContent = categoryName;
  } else {
      servicesTitle.textContent = 'Dịch vụ';
  }
  
  // Show/hide no results
  if (servicesToRender.length === 0) {
      console.log('No services to render, showing no results');
      servicesList.style.display = 'none';
      if (noResults) noResults.style.display = 'block';
      return;
  }
  
  servicesList.style.display = 'block';
  if (noResults) noResults.style.display = 'none';
  
  // Check if we've reached the service limit
  const isLimitReached = selectedServices.length >= maxServicesAllowed;
  
  // Render service cards
  const html = servicesToRender.map(service => {
      const isSelected = selectedServices.includes(service.id);
      const isDisabled = !isSelected && isLimitReached;
      
      return `
          <div class="service-card ${isDisabled ? 'disabled' : ''}">
          <div class="service-content">
              <div class="service-info">
                  <h3 class="service-name">${service.name}</h3>
                  <p class="service-duration">${service.duration}</p>
                  <p class="service-description">${service.description}</p>
                  <p class="service-price">${service.price}</p>
              </div>
                  <button class="service-add-btn ${isSelected ? 'selected' : ''} ${isDisabled ? 'disabled' : ''}" 
                          onclick="toggleService('${service.id}')"
                          ${isDisabled ? 'disabled' : ''}>
                      <i class="fas ${isSelected ? 'fa-check' : 'fa-plus'}"></i>
              </button>
          </div>
      </div>
      `;
  }).join('');
  
  console.log('Setting HTML for services list');
  servicesList.innerHTML = html;
}

// Toggle service selection
function toggleService(serviceId) {
  if (selectedServices.includes(serviceId)) {
      // Remove service
      selectedServices = selectedServices.filter(id => id !== serviceId);
  } else {
      // Check if adding would exceed the limit
      if (selectedServices.length >= maxServicesAllowed) {
          // Show warning message
          showServiceLimitWarning();
          return; // Don't add the service
      }
      // Add service
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
  // Update the service counter
  updateServiceCounter();
  
  if (selectedServices.length === 0) {
      selectedServicesContent.innerHTML = '<p class="no-services">Không có dịch vụ nào được chọn</p>';
      totalAmount.textContent = 'miễn phí';
      continueBtn.disabled = true;
      return;
  }
  
  const selectedServiceItems = selectedServices.map(serviceId => {
      // Find service in current services or cache
      let service = currentServices.find(s => s.id === serviceId) || allServicesCache.get(serviceId);
      
      if (!service) {
          // If not found anywhere, show placeholder
          return `
              <div class="selected-service-item">
                  <div class="selected-service-content">
                      <div class="selected-service-info">
                          <p class="selected-service-name">Dịch vụ đã chọn (ID: ${serviceId})</p>
                          <p class="selected-service-price">N/A</p>
                      </div>
                      <button class="remove-service-btn" onclick="removeService('${serviceId}')">
                          <i class="fas fa-times"></i>
                      </button>
                  </div>
              </div>
          `;
      }
      
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
  
  // Calculate total (we need to fetch service details for accurate pricing)
  calculateTotal();
  continueBtn.disabled = false;
}

// Calculate total price for selected services
async function calculateTotal() {
  let total = 0;
  
  for (const serviceId of selectedServices) {
      // Find in current services or cache
      let service = currentServices.find(s => s.id === serviceId) || allServicesCache.get(serviceId);
      
      if (service) {
          total += service.priceValue;
      }
  }
  
  totalAmount.textContent = total > 0 ? `${total.toLocaleString('vi-VN')} VND` : 'miễn phí';
}

// Update filters visibility
function updateFiltersVisibility() {
  const hasActiveFilters = searchQuery || minPrice > absoluteMinPrice || maxPrice < absoluteMaxPrice;
  resetFilters.style.display = hasActiveFilters ? 'block' : 'none';
}

// Update service counter display
function updateServiceCounter() {
  const counterElement = document.getElementById('serviceCounter');
  if (counterElement) {
    const countText = `${selectedServices.length}/${maxServicesAllowed}`;
    const isNearLimit = selectedServices.length >= maxServicesAllowed - 1;
    
    counterElement.textContent = countText;
    counterElement.className = `service-counter ${isNearLimit ? 'warning' : ''}`;
  }
}

// Show service limit warning
function showServiceLimitWarning() {
  // Create a temporary notification
  const notification = document.createElement('div');
  notification.className = 'service-limit-notification';
  notification.innerHTML = `
    <div class="notification-content">
      <i class="fas fa-exclamation-triangle"></i>
      <span>Bạn chỉ có thể chọn tối đa ${maxServicesAllowed} dịch vụ!</span>
    </div>
  `;
  
  // Add to page
  document.body.appendChild(notification);
  
  // Show with animation
  setTimeout(() => notification.classList.add('show'), 10);
  
  // Remove after 3 seconds
  setTimeout(() => {
    notification.classList.remove('show');
    setTimeout(() => {
      if (notification.parentNode) {
        notification.parentNode.removeChild(notification);
      }
    }, 300);
  }, 3000);
}

// Initialize the application when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
  console.log('DOM loaded, starting initialization...');
  init();
});