/**
 * Service Tracker Utility
 * Provides easy methods to track service views for the recently viewed services feature
 */

/**
 * Track a service view - call this when a user views a service
 * @param {string} serviceId - Unique identifier for the service
 * @param {string} serviceName - Display name of the service
 * @param {string} serviceImage - URL to service image
 * @param {number} servicePrice - Price of the service in VND
 */
function trackServiceView(serviceId, serviceName, serviceImage, servicePrice) {
    // Validate parameters
    if (!serviceId || !serviceName || !serviceImage || servicePrice === undefined) {
        console.warn('trackServiceView: Missing required parameters', {
            serviceId, serviceName, serviceImage, servicePrice
        });
        return;
    }

    // Use the global function if available
    if (typeof window.trackServiceView === 'function') {
        window.trackServiceView(serviceId, serviceName, serviceImage, servicePrice);
    } else {
        // Fallback: store directly in localStorage if the main script isn't loaded
        const storageKey = 'recently_viewed_services';
        const maxItems = 10;
        
        const newService = {
            id: serviceId.toString(),
            name: serviceName,
            image: serviceImage,
            price: parseInt(servicePrice),
            viewedAt: new Date().toISOString()
        };
        
        try {
            const existing = JSON.parse(localStorage.getItem(storageKey) || '[]');
            const filtered = existing.filter(s => s.id !== serviceId.toString());
            const updated = [newService, ...filtered].slice(0, maxItems);
            
            localStorage.setItem(storageKey, JSON.stringify(updated));
            console.log('Service view tracked:', serviceName);
        } catch (error) {
            console.error('Failed to track service view:', error);
        }
    }
}

/**
 * Auto-track service views based on page content
 * Call this on service detail pages to automatically track the current service
 */
function autoTrackCurrentService() {
    // Try to extract service data from meta tags
    const serviceId = document.querySelector('meta[name="service-id"]')?.getAttribute('content');
    const serviceName = document.querySelector('meta[name="service-name"]')?.getAttribute('content');
    const serviceImage = document.querySelector('meta[name="service-image"]')?.getAttribute('content');
    const servicePrice = document.querySelector('meta[name="service-price"]')?.getAttribute('content');
    
    if (serviceId && serviceName && serviceImage && servicePrice) {
        trackServiceView(serviceId, serviceName, serviceImage, parseInt(servicePrice));
        return true;
    }
    
    // Try to extract from data attributes on the body
    const body = document.body;
    const bodyServiceId = body.dataset.serviceId;
    const bodyServiceName = body.dataset.serviceName;
    const bodyServiceImage = body.dataset.serviceImage;
    const bodyServicePrice = body.dataset.servicePrice;
    
    if (bodyServiceId && bodyServiceName && bodyServiceImage && bodyServicePrice) {
        trackServiceView(bodyServiceId, bodyServiceName, bodyServiceImage, parseInt(bodyServicePrice));
        return true;
    }
    
    console.warn('autoTrackCurrentService: Could not find service data in meta tags or body data attributes');
    return false;
}

/**
 * Set up click tracking for service links
 * Call this to automatically track service views when users click on service links
 * @param {string} selector - CSS selector for service links (default: '.service-link')
 */
function setupServiceLinkTracking(selector = '.service-link') {
    document.addEventListener('click', function(event) {
        const link = event.target.closest(selector);
        if (!link) return;
        
        // Extract service data from data attributes
        const serviceId = link.dataset.serviceId;
        const serviceName = link.dataset.serviceName || link.textContent.trim();
        const serviceImage = link.dataset.serviceImage;
        const servicePrice = link.dataset.servicePrice;
        
        if (serviceId && serviceName && serviceImage && servicePrice) {
            trackServiceView(serviceId, serviceName, serviceImage, parseInt(servicePrice));
        }
    });
}

/**
 * Track service view from a specific element
 * @param {HTMLElement} element - Element containing service data in data attributes
 */
function trackServiceFromElement(element) {
    if (!element) return;
    
    const serviceId = element.dataset.serviceId;
    const serviceName = element.dataset.serviceName;
    const serviceImage = element.dataset.serviceImage;
    const servicePrice = element.dataset.servicePrice;
    
    if (serviceId && serviceName && serviceImage && servicePrice) {
        trackServiceView(serviceId, serviceName, serviceImage, parseInt(servicePrice));
    }
}

/**
 * Initialize service tracking when DOM is ready
 */
function initServiceTracking() {
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            setupServiceLinkTracking();
            
            // Auto-track if this is a service detail page
            setTimeout(autoTrackCurrentService, 100);
        });
    } else {
        setupServiceLinkTracking();
        setTimeout(autoTrackCurrentService, 100);
    }
}

// Export functions for global use
window.trackServiceView = trackServiceView;
window.autoTrackCurrentService = autoTrackCurrentService;
window.setupServiceLinkTracking = setupServiceLinkTracking;
window.trackServiceFromElement = trackServiceFromElement;
window.initServiceTracking = initServiceTracking;

// Auto-initialize
initServiceTracking(); 