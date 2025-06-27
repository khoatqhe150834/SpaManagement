/**
 * Example Service Selection Integration with Booking Service Badge
 * This file demonstrates how to integrate service selection with the booking service badge
 * 
 * Usage: Include this file on service selection pages and call the appropriate functions
 * when services are added, removed, or updated.
 */

(function() {
    'use strict';
    
    /**
     * Example: Add a service to the booking session
     * This function should be called when a user selects a service
     */
    window.addServiceToBooking = function(serviceData) {
        try {
            // Get existing selected services from session storage
            let selectedServices = JSON.parse(sessionStorage.getItem('selectedServices') || '[]');
            
            // Check if service is already selected
            const existingIndex = selectedServices.findIndex(s => s.id === serviceData.id);
            
            if (existingIndex === -1) {
                // Add new service
                selectedServices.push(serviceData);
                sessionStorage.setItem('selectedServices', JSON.stringify(selectedServices));
                
                // Update booking badge
                if (typeof addServiceToBadge === 'function') {
                    addServiceToBadge(serviceData);
                }
                
                console.log('Service added to booking:', serviceData);
                return true;
            } else {
                console.warn('Service already selected');
                return false;
            }
        } catch (error) {
            console.error('Error adding service to booking:', error);
            return false;
        }
    };
    
    /**
     * Example: Remove a service from the booking session
     * This function should be called when a user deselects a service
     */
    window.removeServiceFromBooking = function(serviceId) {
        try {
            // Get existing selected services from session storage
            let selectedServices = JSON.parse(sessionStorage.getItem('selectedServices') || '[]');
            
            // Remove service
            selectedServices = selectedServices.filter(s => s.id !== serviceId);
            sessionStorage.setItem('selectedServices', JSON.stringify(selectedServices));
            
            // Update booking badge
            if (typeof removeServiceFromBadge === 'function') {
                removeServiceFromBadge(serviceId);
            }
            
            console.log('Service removed from booking:', serviceId);
            return true;
        } catch (error) {
            console.error('Error removing service from booking:', error);
            return false;
        }
    };
    
    /**
     * Example: Clear all selected services
     */
    window.clearAllServices = function() {
        try {
            sessionStorage.removeItem('selectedServices');
            
            // Update booking badge
            if (typeof clearBookingBadge === 'function') {
                clearBookingBadge();
            }
            
            console.log('All services cleared from booking');
            return true;
        } catch (error) {
            console.error('Error clearing services:', error);
            return false;
        }
    };
    
    /**
     * Example: Update booking session data
     * This can be used for more complex booking session management
     */
    window.updateBookingSession = function(sessionData) {
        try {
            sessionStorage.setItem('bookingSession', JSON.stringify(sessionData));
            
            // Trigger badge update
            if (typeof updateBookingBadge === 'function') {
                updateBookingBadge();
            }
            
            // Dispatch custom event
            window.dispatchEvent(new CustomEvent('bookingSessionUpdated', {
                detail: sessionData
            }));
            
            console.log('Booking session updated:', sessionData);
            return true;
        } catch (error) {
            console.error('Error updating booking session:', error);
            return false;
        }
    };
    
    /**
     * Example: Initialize service selection buttons
     * This function demonstrates how to set up service selection UI
     */
    window.initializeServiceSelection = function() {
        // Example: Set up click handlers for service cards
        document.querySelectorAll('.service-card').forEach(card => {
            const serviceId = card.dataset.serviceId;
            const serviceName = card.dataset.serviceName;
            const servicePrice = card.dataset.servicePrice;
            const addButton = card.querySelector('.add-service-btn');
            const removeButton = card.querySelector('.remove-service-btn');
            
            if (addButton) {
                addButton.addEventListener('click', function() {
                    const serviceData = {
                        id: serviceId,
                        name: serviceName,
                        price: parseFloat(servicePrice) || 0,
                        addedAt: new Date().toISOString()
                    };
                    
                    if (addServiceToBooking(serviceData)) {
                        // Update UI to show service is selected
                        card.classList.add('selected');
                        addButton.style.display = 'none';
                        if (removeButton) removeButton.style.display = 'block';
                        
                        // Show success message
                        showNotification('Đã thêm dịch vụ vào danh sách đặt lịch', 'success');
                    }
                });
            }
            
            if (removeButton) {
                removeButton.addEventListener('click', function() {
                    if (removeServiceFromBooking(serviceId)) {
                        // Update UI to show service is not selected
                        card.classList.remove('selected');
                        removeButton.style.display = 'none';
                        if (addButton) addButton.style.display = 'block';
                        
                        // Show success message
                        showNotification('Đã xóa dịch vụ khỏi danh sách đặt lịch', 'info');
                    }
                });
            }
        });
        
        // Initialize badge with current state
        if (typeof updateBookingBadge === 'function') {
            updateBookingBadge();
        }
        
        console.log('Service selection initialized');
    };
    
    /**
     * Example: Show notification to user
     */
    function showNotification(message, type = 'info') {
        // Create notification element
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: ${type === 'success' ? '#28a745' : type === 'error' ? '#dc3545' : '#17a2b8'};
            color: white;
            padding: 15px 20px;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
            z-index: 9999;
            font-size: 14px;
            min-width: 250px;
            animation: slideInFromRight 0.3s ease-out;
        `;
        notification.textContent = message;
        
        // Add animation styles
        const style = document.createElement('style');
        style.textContent = `
            @keyframes slideInFromRight {
                from { transform: translateX(100%); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
            @keyframes slideOutToRight {
                from { transform: translateX(0); opacity: 1; }
                to { transform: translateX(100%); opacity: 0; }
            }
        `;
        if (!document.querySelector('#notification-styles')) {
            style.id = 'notification-styles';
            document.head.appendChild(style);
        }
        
        document.body.appendChild(notification);
        
        // Auto remove after 3 seconds
        setTimeout(() => {
            notification.style.animation = 'slideOutToRight 0.3s ease-out forwards';
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.parentNode.removeChild(notification);
                }
            }, 300);
        }, 3000);
    }
    
    /**
     * Example: Restore selected services state on page load
     */
    function restoreServiceSelectionState() {
        try {
            const selectedServices = JSON.parse(sessionStorage.getItem('selectedServices') || '[]');
            
            selectedServices.forEach(service => {
                const serviceCard = document.querySelector(`[data-service-id="${service.id}"]`);
                if (serviceCard) {
                    serviceCard.classList.add('selected');
                    const addButton = serviceCard.querySelector('.add-service-btn');
                    const removeButton = serviceCard.querySelector('.remove-service-btn');
                    
                    if (addButton) addButton.style.display = 'none';
                    if (removeButton) removeButton.style.display = 'block';
                }
            });
            
            console.log('Service selection state restored');
        } catch (error) {
            console.error('Error restoring service selection state:', error);
        }
    }
    
    // Initialize when DOM is ready
    document.addEventListener('DOMContentLoaded', function() {
        // Restore state first
        restoreServiceSelectionState();
        
        // Then initialize selection handlers
        setTimeout(() => {
            initializeServiceSelection();
        }, 100);
    });
    
})(); 