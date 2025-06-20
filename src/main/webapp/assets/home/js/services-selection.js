// Enhanced Services Selection JavaScript
// This file handles the dynamic loading and filtering of services with enhanced UI/UX

// Enhanced global variables
let selectedServices = new Set();
let servicesData = {};
let category = ['all', 'featured', 'new'];

// Initialize configuration from server
const config = window.serviceSelectionConfig || {};
const DEFAULT_MIN_PRICE = config.minPrice || 0;
const DEFAULT_MAX_PRICE = config.maxPrice || 10000000;

let currentFilters = {
  category: 'all',
  search: '',
  minPrice: DEFAULT_MIN_PRICE,
  maxPrice: DEFAULT_MAX_PRICE
};

/**
 * Enhanced service selection handling
 * @param {HTMLElement} checkbox - The checkbox element that was clicked
 */
function updateServiceSelection(checkbox) {
  const serviceId = checkbox.value;
  const serviceCard = checkbox.closest('.service-card');
  
  if (checkbox.checked) {
    selectedServices.add(serviceId);
    serviceCard.classList.add('selected');
  } else {
    selectedServices.delete(serviceId);
    serviceCard.classList.remove('selected');
  }
  
  updateSelectionSummary();
}

/**
 * Update selection summary display
 */
function updateSelectionSummary() {
  const selectedCount = selectedServices.size;
  const totalPrice = Array.from(selectedServices).reduce((sum, serviceId) => {
    const service = servicesData[serviceId];
    return sum + (service ? parseFloat(service.price) : 0);
  }, 0);
  
  const selectedCountElement = document.getElementById('selectedCount');
  const totalPriceElement = document.getElementById('totalPrice');
  const continueBtn = document.getElementById('continueBtn');
  
  if (selectedCountElement) selectedCountElement.textContent = selectedCount;
  if (totalPriceElement) totalPriceElement.textContent = formatPriceToVND(totalPrice);
  if (continueBtn) continueBtn.disabled = selectedCount === 0;
}

/**
 * Enhanced display services function with modern UI
 * @param {Array} services - Array of service objects to display
 */
function displayServices(services) {
  const servicesContainer = document.querySelector('.services-container');

  // Check if services array is empty or null
  if (!services || services.length === 0) {
    servicesContainer.innerHTML = 
      '<div class="empty-state">' +
        '<i class="fa fa-search"></i>' +
        '<h4>Không tìm thấy dịch vụ</h4>' +
        '<p>Vui lòng thử lại với từ khóa khác hoặc điều chỉnh bộ lọc</p>' +
      '</div>';
    return;
  }

  servicesData = {}; // Reset services data
  let servicesHTML = '';

  services.forEach(service => {
    servicesData[service.serviceId] = service; // Store service data
    const isSelected = selectedServices.has(service.serviceId.toString());
    
    const imageHTML = service.imageUrl ? 
      '<img src="' + service.imageUrl + '" alt="' + service.name + '" class="service-card-image">' :
      '<div class="service-card-image" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 3rem;">' +
        '<i class="fa fa-spa"></i>' +
      '</div>';
    
    const ratingHTML = service.averageRating && service.averageRating > 0 ? 
      '<div class="service-rating">' +
        generateStarRating(service.averageRating) +
        '<span>(' + service.averageRating + ')</span>' +
      '</div>' : '';
    
    servicesHTML += 
      '<div class="service-card ' + (isSelected ? 'selected' : '') + '" data-service-id="' + service.serviceId + '">' +
        '<input type="checkbox" ' +
               'name="selectedServices" ' +
               'value="' + service.serviceId + '" ' +
               'class="service-select-checkbox" ' +
               'id="service_' + service.serviceId + '"' +
               (isSelected ? ' checked' : '') +
               ' onchange="updateServiceSelection(this)">' +
        
        '<div class="service-select-indicator">' +
            '<i class="fa fa-check"></i>' +
        '</div>' +
        
        '<div class="service-card-header">' +
            imageHTML +
        '</div>' +
        
        '<div class="service-card-content">' +
            '<h3 class="service-title">' + service.name + '</h3>' +
            '<p class="service-description">' + (service.description || '') + '</p>' +
            
            '<div class="service-details">' +
                '<div class="service-price">' +
                    formatPriceToVND(service.price) +
                '</div>' +
                '<div class="service-duration">' +
                    '<i class="fa fa-clock-o"></i> ' + service.durationMinutes + ' phút' +
                '</div>' +
            '</div>' +
            
            ratingHTML +
        '</div>' +
      '</div>';
  });

  servicesContainer.innerHTML = servicesHTML;
  updateSelectionSummary();
}

/**
 * Generate star rating HTML
 * @param {number} rating - The rating value
 * @returns {string} - HTML string for star rating
 */
function generateStarRating(rating) {
  let stars = '';
  for (let i = 1; i <= 5; i++) {
    stars += '<i class="fa fa-star' + (i <= rating ? '' : '-o') + '"></i>';
  }
  return stars;
}

/**
 * Loads services based on the service type ID
 * @param {string|number} typeId - The ID of the service type ('all', 'featured', 'new', or numeric ID)
 */
function loadServicesByTypeId(typeId) {
  // Update currentFilters and use main filter function
  if (typeId === 'all' || typeId === 'featured' || typeId === 'new') {
    currentFilters.category = typeId;
  } else {
    currentFilters.category = 'type-' + typeId;
  }
  fetchFilterServices(currentFilters);
}

/**
 * Handles the search input event
 * Updates the current search filter and fetches filtered services
 */
function handleSearchInput() {
  currentFilters.search = document.getElementById('searchInput').value;
  debouncedFetchFilterServices(currentFilters);
}

/**
 * Clears the search input and fetches all services
 */
function clearSearch() {
  document.getElementById('searchInput').value = '';
  currentFilters.search = '';
  fetchFilterServices(currentFilters);
}

/**
 * Dual Range Slider - Based on W3Schools range slider tutorial
 * Updates both sliders and ensures proper range selection
 */
function updateDualRange() {
    const minSlider = document.getElementById('minPriceSlider');
    const maxSlider = document.getElementById('maxPriceSlider');
    const rangeTrack = document.getElementById('rangeTrack');
    
    if (!minSlider || !maxSlider || !rangeTrack) return;
    
    let minValue = parseInt(minSlider.value);
    let maxValue = parseInt(maxSlider.value);
    
    // Prevent collision - ensure min doesn't exceed max
    if (minValue > maxValue) {
        if (document.activeElement === minSlider) {
            maxValue = minValue;
            maxSlider.value = maxValue;
        } else {
            minValue = maxValue;
            minSlider.value = minValue;
        }
    }
    
    // Update current filters
    currentFilters.minPrice = minValue;
    currentFilters.maxPrice = maxValue;
    
    // Update visual display
    updatePriceDisplayValues();
    updateRangeVisualTrack();
    
    // Trigger service filtering with debounce
    debouncedFetchFilterServices(currentFilters);
}

/**
 * Updates the price display values based on W3Schools dynamic display approach
 */
function updatePriceDisplayValues() {
    const minSlider = document.getElementById('minPriceSlider');
    const maxSlider = document.getElementById('maxPriceSlider');
    const minDisplay = document.getElementById('minPriceValue');
    const maxDisplay = document.getElementById('maxPriceValue');
    
    if (minDisplay && minSlider) {
        minDisplay.textContent = formatPriceToVND(minSlider.value);
    }
    if (maxDisplay && maxSlider) {
        maxDisplay.textContent = formatPriceToVND(maxSlider.value);
    }
}

/**
 * Updates the visual range track between slider thumbs
 * Follows W3Schools approach for custom styling
 */
function updateRangeVisualTrack() {
    const minSlider = document.getElementById('minPriceSlider');
    const maxSlider = document.getElementById('maxPriceSlider');
    const rangeTrack = document.getElementById('rangeTrack');
    
    if (!minSlider || !maxSlider || !rangeTrack) return;
    
    const min = parseInt(minSlider.min);
    const max = parseInt(minSlider.max);
    const minVal = parseInt(minSlider.value);
    const maxVal = parseInt(maxSlider.value);
    
    // Calculate percentage positions
    const leftPercent = ((minVal - min) / (max - min)) * 100;
    const rightPercent = ((maxVal - min) / (max - min)) * 100;
    
    // Update the visual track
    rangeTrack.style.left = leftPercent + '%';
    rangeTrack.style.width = (rightPercent - leftPercent) + '%';
}

/**
 * Enhanced category selection with visual feedback
 * @param {string} categoryValue - The category value to select
 */
function selectCategory(categoryValue) {
  // Remove active class from all buttons
  document.querySelectorAll('.service-type-btn').forEach(btn => {
    btn.classList.remove('active');
  });
  
  // Add active class to selected button
  const selectedBtn = document.querySelector('[data-type-id="' + categoryValue + '"]') || 
                     document.querySelector('[onclick*="selectCategory(\'all\')"]');
  if (selectedBtn) {
    selectedBtn.classList.add('active');
  }
  
  // Update filters and fetch services
  if (categoryValue === 'all' || categoryValue === 'featured' || categoryValue === 'new') {
    currentFilters.category = categoryValue;
  } else {
    currentFilters.category = 'type-' + categoryValue;
  }
  fetchFilterServices(currentFilters);
}

/**
 * Formats a numeric price value to Vietnamese Dong currency format
 * @param {number} price - The price value to format
 * @returns {string} - Formatted price string in VND
 */
function formatPriceToVND(price) {
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(price);
}

/**
 * Show loading state
 */
function showLoadingState() {
  const servicesContainer = document.querySelector('.services-container');
  servicesContainer.innerHTML = 
    '<div class="loading-state">' +
      '<div class="loading-spinner"></div>' +
      '<p>Đang tải dịch vụ...</p>' +
    '</div>';
}

/**
 * Loads all available service types from the API and displays them
 */
function loadAllServicesTypes() {
  const serviceTypesContainer = document.querySelector('.service-types-container');
  
  // Check if service types are already loaded from server
  if (serviceTypesContainer && serviceTypesContainer.children.length > 0) {
    // Add default buttons if not present
    addDefaultServiceTypeButtons();
    return;
  }
  
  const url = getContextPath() + '/api/service-types';

  fetch(url)
    .then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.json();
    })
    .then(data => {
      displayServiceTypes(data);
    })
    .catch(error => {
      console.error('Error loading services types:', error);
      if (serviceTypesContainer) {
        serviceTypesContainer.innerHTML = '<p>Lỗi khi tải danh mục dịch vụ</p>';
      }
    });
}

/**
 * Add default service type buttons (all, featured, new)
 */
function addDefaultServiceTypeButtons() {
  const serviceTypesContainer = document.querySelector('.service-types-container');
  if (!serviceTypesContainer) return;
  
  // Check if default buttons already exist
  if (serviceTypesContainer.querySelector('[onclick*="selectCategory(\'all\')"]')) {
    return;
  }
  
  const defaultButtons = 
    '<button type="button" class="service-type-btn" onclick="selectCategory(\'all\')" data-type-id="all">Tất cả dịch vụ</button>' +
    '<button type="button" class="service-type-btn" onclick="selectCategory(\'featured\')" data-type-id="featured">Dịch vụ nổi bật</button>' +
    '<button type="button" class="service-type-btn" onclick="selectCategory(\'new\')" data-type-id="new">Dịch vụ mới nhất</button>';
  
  serviceTypesContainer.insertAdjacentHTML('afterbegin', defaultButtons);
}

/**
 * Displays service type buttons including default categories and custom service types
 * @param {Array} serviceTypes - Array of service type objects
 */
function displayServiceTypes(serviceTypes) {
  const serviceTypesContainer = document.querySelector('.service-types-container');
  if (!serviceTypesContainer) return;

  let serviceTypesHTML = '';

  // add all services type button
  serviceTypesHTML += 
    '<button type="button" class="service-type-btn" onclick="selectCategory(\'all\')" data-type-id="all">Tất cả dịch vụ</button>';
  
  // add featured services type button
  serviceTypesHTML += 
    '<button type="button" class="service-type-btn" onclick="selectCategory(\'featured\')" data-type-id="featured">Dịch vụ nổi bật</button>';
  
  // add new services type button
  serviceTypesHTML += 
    '<button type="button" class="service-type-btn" onclick="selectCategory(\'new\')" data-type-id="new">Dịch vụ mới nhất</button>';
  
  // add other services type buttons  
  serviceTypes.forEach(serviceType => {
    serviceTypesHTML += 
      '<button type="button" class="service-type-btn" onclick="selectCategory(' + serviceType.serviceTypeId + ')" data-type-id="' + serviceType.serviceTypeId + '">' +
        serviceType.name +
      '</button>';
  });

  serviceTypesContainer.innerHTML = serviceTypesHTML;
}

/**
 * Helper function to get the context path of the application
 * @returns {string} - The context path
 */
function getContextPath() {
  return window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
}

/**
 * Fetches filtered services based on provided filter criteria
 * @param {Object} currentFilters - Filter object containing category, search, minPrice, maxPrice
 */
function fetchFilterServices(currentFilters) {
  // Show loading state
  showLoadingState();
  
  // build the correct API URL based on the filter
  let url = getContextPath() + '/api/services';
  const params = new URLSearchParams();

  // add filter to the URL
  if (currentFilters.category && currentFilters.category !== 'all') {
    params.append('category', currentFilters.category);
  }

  // add search to the URL
  if (currentFilters.search && currentFilters.search.trim() !== '') {
    params.append('search', currentFilters.search.trim());
  }

  // add price range to the URL
  if (currentFilters.minPrice != null) {
    params.append('minPrice', currentFilters.minPrice);
  }
  if (currentFilters.maxPrice != null) {
    params.append('maxPrice', currentFilters.maxPrice);
  }

  const finalUrl = params.toString() ? url + '?' + params.toString() : url;
  console.log('Fetching:', finalUrl);
  
  // fetch the services
  fetch(finalUrl)
    .then(response => {
      if (!response.ok) {
        return response.text().then(text => {
          throw new Error('Server error ' + response.status + ': ' + text);
        });
      }
      return response.json();
    })
    .then(data => {
      const services = data.services || data;
      displayServices(services);
    })
    .catch(error => {
      console.error('Error loading services:', error);
      const servicesContainer = document.querySelector('.services-container');
      if (servicesContainer) {
        servicesContainer.innerHTML = '<p style="color: red;">Lỗi tải dịch vụ: ' + error.message + '</p>';
      }
    });
}

/**
 * Debounces a function to prevent it from being called too frequently
 * @param {Function} func - The function to debounce
 * @param {number} wait - The time to wait in milliseconds
 * @returns {Function} - The debounced function
 */
function debounce(func, wait) {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

const debouncedFetchFilterServices = debounce(fetchFilterServices, 350); // 350ms delay

/**
 * Initialize dual range sliders based on W3Schools approach
 */
function initializeDualRangeSlider() {
  const minSlider = document.getElementById('minPriceSlider');
  const maxSlider = document.getElementById('maxPriceSlider');
  const rangeTrack = document.getElementById('rangeTrack');
  
  if (!minSlider || !maxSlider || !rangeTrack) {
    console.warn('Dual range slider elements not found');
    return;
  }
  
  console.log('Initializing dual range slider with values:', {
    min: DEFAULT_MIN_PRICE,
    max: DEFAULT_MAX_PRICE
  });
  
  // Set attributes for min slider
  minSlider.min = DEFAULT_MIN_PRICE;
  minSlider.max = DEFAULT_MAX_PRICE;
  minSlider.step = 100000;
  minSlider.value = DEFAULT_MIN_PRICE;
  
  // Set attributes for max slider  
  maxSlider.min = DEFAULT_MIN_PRICE;
  maxSlider.max = DEFAULT_MAX_PRICE;
  maxSlider.step = 100000;
  maxSlider.value = DEFAULT_MAX_PRICE;
  
  // Update current filters
  currentFilters.minPrice = DEFAULT_MIN_PRICE;
  currentFilters.maxPrice = DEFAULT_MAX_PRICE;
  
  // Add event listeners using W3Schools approach
  minSlider.oninput = function() {
    updateDualRange();
  };
  
  maxSlider.oninput = function() {
    updateDualRange();
  };
  
  // Initialize display and visual track
  updatePriceDisplayValues();
  updateRangeVisualTrack();
  
  console.log('Dual range slider initialized successfully');
}

/**
 * Initialize the page by loading all services when page loads
 */
document.addEventListener('DOMContentLoaded', function() {
  // Set initial active state
  const allButton = document.querySelector('[onclick*="selectCategory(\'all\')"]');
  if (allButton) {
    allButton.classList.add('active');
  }
  
  // Initialize dual range slider based on W3Schools approach
  initializeDualRangeSlider();
  
  // Initialize page by loading all service types
  loadAllServicesTypes();
  
  // Load initial services if not already displayed by server
  const servicesContainer = document.querySelector('.services-container');
  if (servicesContainer && !servicesContainer.querySelector('.service-card')) {
    fetchFilterServices(currentFilters);
  } else {
    // If services are already displayed, initialize selection summary
    updateSelectionSummary();
  }
  
  // Form submission validation
  const form = document.getElementById('serviceSelectionForm');
  if (form) {
    form.addEventListener('submit', function(e) {
      if (selectedServices.size === 0) {
        e.preventDefault();
        alert('Vui lòng chọn ít nhất một dịch vụ để tiếp tục.');
        return false;
      }
    });
  }
});