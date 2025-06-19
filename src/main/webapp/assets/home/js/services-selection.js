// Services Selection JavaScript
// This file handles the dynamic loading and filtering of services

// global variables
let category = ['all', 'featured', 'new'];
const DEFAULT_MIN_PRICE = 0;
const DEFAULT_MAX_PRICE = 10000000;

let currentFilters = {
  category: 'all',
  search: '',
  minPrice: DEFAULT_MIN_PRICE,
  maxPrice: DEFAULT_MAX_PRICE
};

/**
 * Loads services based on the service type ID
 * @param {string|number} typeId - The ID of the service type ('all', 'featured', 'new', or numeric ID)
 */
function loadServicesByTypeId(typeId) {
  // Update currentFilters and use main filter function
  if (typeId === 'all' || typeId === 'featured' || typeId === 'new') {
    currentFilters.category = typeId;
  } else {
    currentFilters.category = `type-${typeId}`;
  }
  fetchFilterServices(currentFilters);
}

/**
 * Displays an array of services in the services container
 * @param {Array} services - Array of service objects to display
 */
function displayServices(services) {
  const servicesContainer = document.querySelector('.services-container');

  // Check if services array is empty or null
  if (!services || services.length === 0) {
    servicesContainer.innerHTML = '<p>Không có dịch vụ nào trong danh mục này</p>';
    return;
  }

  let servicesHTML = '';

  services.forEach(service => {
    servicesHTML += `
      <div class="service-card">
        <input type="checkbox" name="selectedServices" value="${service.serviceId}">
        <h3>${service.name}</h3>
        <p>${formatPriceToVND(service.price)}</p>
        <p>Thời gian: ${service.durationMinutes} phút</p>
        <p>${service.description || ''}</p>
      </div>`;
  });

  servicesContainer.innerHTML = servicesHTML;
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

// called by the price range slider
function updatePriceRange() {
  currentFilters.minPrice = document.getElementById('minPriceSlider').value;
  currentFilters.maxPrice = document.getElementById('maxPriceSlider').value;
  updatePriceRangeDisplay();
  debouncedFetchFilterServices(currentFilters);
}

/**
 * Updates the price range display labels
 */
function updatePriceRangeDisplay() {
  const minPriceValue = document.getElementById('minPriceValue');
  const maxPriceValue = document.getElementById('maxPriceValue');
  const minPriceSlider = document.getElementById('minPriceSlider');
  const maxPriceSlider = document.getElementById('maxPriceSlider');
  
  if (minPriceValue) minPriceValue.textContent = formatPriceToVND(minPriceSlider.value);
  if (maxPriceValue) maxPriceValue.textContent = formatPriceToVND(maxPriceSlider.value);
}

/**
 * Selects a category for filtering services
 * @param {string} categoryValue - The category value to select
 */
function selectCategory(categoryValue) {
  if (categoryValue === 'all' || categoryValue === 'featured' || categoryValue === 'new') {
    currentFilters.category = categoryValue;
  } else {
    currentFilters.category = `type-${categoryValue}`;
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
 * Loads all available service types from the API and displays them
 */
function loadAllServicesTypes() {
  const serviceTypesContainer = document.querySelector('.service-types-container');
  const url = `${getContextPath()}/api/service-types`;

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
      serviceTypesContainer.innerHTML = '<p>Lỗi khi tải danh mục dịch vụ</p>';
    });
}

/**
 * Displays service type buttons including default categories and custom service types
 * @param {Array} serviceTypes - Array of service type objects
 */
function displayServiceTypes(serviceTypes) {
  const serviceTypesContainer = document.querySelector('.service-types-container');

  let serviceTypesHTML = '';

  // add all services type button
  serviceTypesHTML += `
    <div class="service-type-card">
      <button type="button" class="service-type-btn" onclick="selectCategory('all')">Tất cả dịch vụ</button>
    </div>`;
  
  // add featured services type button
  serviceTypesHTML += `
    <div class="service-type-card">
      <button type="button" class="service-type-btn" onclick="selectCategory('featured')">Dịch vụ nổi bật</button>
    </div>`;
  
  // add new services type button
  serviceTypesHTML += `
    <div class="service-type-card">
      <button type="button" class="service-type-btn" onclick="selectCategory('new')">Dịch vụ mới nhất</button>
    </div>`;
  
  // add other services type buttons  
  serviceTypes.forEach(serviceType => {
    serviceTypesHTML += `
      <div class="service-type-card">
        <button type="button" class="service-type-btn" onclick="selectCategory(${serviceType.serviceTypeId})">
          ${serviceType.name}
        </button>
      </div>`;
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
  // build the correct API URL based on the filter
  let url = `${getContextPath()}/api/services`;
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

  const finalUrl = params.toString() ? `${url}?${params.toString()}` : url;
  console.log('Fetching:', finalUrl);
  
  // Show loading
  const servicesContainer = document.querySelector('.services-container');
  servicesContainer.innerHTML = '<p>Đang tải dịch vụ...</p>';
  
  // fetch the services
  fetch(finalUrl)
    .then(response => {
      if (!response.ok) {
        return response.text().then(text => {
          throw new Error(`Server error ${response.status}: ${text}`);
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
      servicesContainer.innerHTML = `<p style="color: red;">Lỗi tải dịch vụ: ${error.message}</p>`;
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
 * Initialize the page by loading all services when page loads
 */
document.addEventListener('DOMContentLoaded', function() {
  // Initialize page by loading all service types
  loadAllServicesTypes();
  
  // Initialize price range display
  updatePriceRangeDisplay();
  
  // Load initial services
  fetchFilterServices(currentFilters);
});