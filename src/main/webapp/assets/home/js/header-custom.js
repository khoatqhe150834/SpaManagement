/**
 * Header Custom JavaScript - Avatar Dropdown Functionality
 * Handles user avatar dropdown interactions and keyboard navigation
 */

// JavaScript for Avatar Dropdown Toggle
document.addEventListener('DOMContentLoaded', function() {
  // Handle Customer Avatar Dropdown
  const customerAvatarButton = document.getElementById('customerAvatarButton');
  const customerAvatarDropdown = document.getElementById('customerAvatarDropdown');

  if (customerAvatarButton && customerAvatarDropdown) {
    customerAvatarButton.addEventListener('click', function(event) {
      event.stopPropagation();
      const isExpanded = customerAvatarButton.getAttribute('aria-expanded') === 'true';
      
      // Close any other open dropdowns first
      closeAllDropdowns();
      
      // Toggle current dropdown
      if (!isExpanded) {
        customerAvatarDropdown.style.display = 'block';
        customerAvatarButton.setAttribute('aria-expanded', 'true');
        
        // Focus management for accessibility
        setTimeout(() => {
          const firstLink = customerAvatarDropdown.querySelector('a');
          if (firstLink) firstLink.focus();
        }, 100);
      }
    });
  }

  // Handle User Avatar Dropdown
  const userAvatarButton = document.getElementById('userAvatarButton');
  const userAvatarDropdown = document.getElementById('userAvatarDropdown');

  if (userAvatarButton && userAvatarDropdown) {
    userAvatarButton.addEventListener('click', function(event) {
      event.stopPropagation();
      const isExpanded = userAvatarButton.getAttribute('aria-expanded') === 'true';
      
      // Close any other open dropdowns first
      closeAllDropdowns();
      
      // Toggle current dropdown
      if (!isExpanded) {
        userAvatarDropdown.style.display = 'block';
        userAvatarButton.setAttribute('aria-expanded', 'true');
        
        // Focus management for accessibility
        setTimeout(() => {
          const firstLink = userAvatarDropdown.querySelector('a');
          if (firstLink) firstLink.focus();
        }, 100);
      }
    });
  }

  // Close dropdown if clicked outside (for both customer and user)
  document.addEventListener('click', function(event) {
    closeAllDropdowns();
  });

  // Close dropdown with Escape key (for both customer and user)
  document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
      closeAllDropdowns();
      
      // Return focus to the avatar button that was open
      if (customerAvatarButton && customerAvatarButton.getAttribute('aria-expanded') === 'true') {
        customerAvatarButton.focus();
      }
      if (userAvatarButton && userAvatarButton.getAttribute('aria-expanded') === 'true') {
        userAvatarButton.focus();
      }
    }
  });

  // Arrow key navigation within dropdowns
  document.addEventListener('keydown', function(event) {
    const activeDropdown = document.querySelector('.avatar-dropdown[style*="block"]');
    if (!activeDropdown) return;

    const links = activeDropdown.querySelectorAll('a');
    const currentFocus = document.activeElement;
    const currentIndex = Array.from(links).indexOf(currentFocus);

    if (event.key === 'ArrowDown') {
      event.preventDefault();
      const nextIndex = currentIndex < links.length - 1 ? currentIndex + 1 : 0;
      links[nextIndex].focus();
    } else if (event.key === 'ArrowUp') {
      event.preventDefault();
      const prevIndex = currentIndex > 0 ? currentIndex - 1 : links.length - 1;
      links[prevIndex].focus();
    }
  });

  /**
   * Helper function to close all open dropdowns
   */
  function closeAllDropdowns() {
    // Close customer dropdown
    if (customerAvatarDropdown && customerAvatarDropdown.style.display === 'block') {
      customerAvatarDropdown.style.display = 'none';
      if (customerAvatarButton) {
        customerAvatarButton.setAttribute('aria-expanded', 'false');
      }
    }
    
    // Close user dropdown
    if (userAvatarDropdown && userAvatarDropdown.style.display === 'block') {
      userAvatarDropdown.style.display = 'none';
      if (userAvatarButton) {
        userAvatarButton.setAttribute('aria-expanded', 'false');
      }
    }
  }

  /**
   * Add hover effects for better UX (optional)
   */
  function addHoverEffects() {
    const avatarContainers = document.querySelectorAll('.user-avatar-container');
    
    avatarContainers.forEach(container => {
      const button = container.querySelector('.user-avatar-button');
      const dropdown = container.querySelector('.avatar-dropdown');
      
      if (button && dropdown) {
        // Optional: Show dropdown on hover after a delay
        let hoverTimeout;
        
        container.addEventListener('mouseenter', function() {
          // Only show on hover if not on mobile
          if (window.innerWidth > 768) {
            hoverTimeout = setTimeout(() => {
              if (!button.getAttribute('aria-expanded') || button.getAttribute('aria-expanded') === 'false') {
                button.click();
              }
            }, 300);
          }
        });
        
        container.addEventListener('mouseleave', function() {
          clearTimeout(hoverTimeout);
          // Don't auto-close on mouse leave - let user click to close
        });
      }
    });
  }

  // Initialize hover effects
  addHoverEffects();
  
  // Initialize cart functionality
  initializeCartIcon();
});

/**
 * Cart Icon Functionality
 */
function initializeCartIcon() {
  // Load initial cart count
  updateCartCount();
  
  // Set up periodic cart count refresh (every 30 seconds)
  setInterval(updateCartCount, 30000);
  
  // Listen for cart update events
  document.addEventListener('cartUpdated', function(event) {
    updateCartCount();
    if (event.detail && event.detail.animate) {
      animateCartBadge();
    }
  });
}

/**
 * Update cart count from server
 */
function updateCartCount() {
  fetch(getContextPath() + '/api/cart/count', {
    method: 'GET',
    credentials: 'same-origin'
  })
  .then(response => response.json())
  .then(data => {
    if (data.success) {
      updateCartBadge(data.count);
    }
  })
  .catch(error => {
    console.error('Error fetching cart count:', error);
  });
}

/**
 * Update cart badge display
 */
function updateCartBadge(count) {
  const cartBadge = document.getElementById('cartBadge');
  if (cartBadge) {
    cartBadge.textContent = count;
    
    if (count > 0) {
      cartBadge.classList.remove('hidden');
    } else {
      cartBadge.classList.add('hidden');
    }
  }
}

/**
 * Animate cart badge when item is added
 */
function animateCartBadge() {
  const cartBadge = document.getElementById('cartBadge');
  if (cartBadge) {
    cartBadge.classList.add('animate-pulse');
    setTimeout(() => {
      cartBadge.classList.remove('animate-pulse');
    }, 600);
  }
}

/**
 * Add item to cart (to be called from service pages)
 */
function addToCart(serviceId, quantity = 1) {
  const formData = new FormData();
  formData.append('serviceId', serviceId);
  formData.append('quantity', quantity);
  
  return fetch(getContextPath() + '/api/cart/add', {
    method: 'POST',
    body: formData,
    credentials: 'same-origin'
  })
  .then(response => response.json())
  .then(data => {
    if (data.success) {
      // Update cart count immediately
      updateCartBadge(data.cartCount);
      animateCartBadge();
      
      // Dispatch cart updated event
      document.dispatchEvent(new CustomEvent('cartUpdated', {
        detail: { count: data.cartCount, animate: true }
      }));
      
      // Show success message (optional)
      showCartMessage(data.message, 'success');
    } else {
      showCartMessage(data.message, 'error');
    }
    return data;
  })
  .catch(error => {
    console.error('Error adding to cart:', error);
    showCartMessage('Đã có lỗi xảy ra khi thêm vào giỏ hàng', 'error');
    throw error;
  });
}

/**
 * Remove item from cart
 */
function removeFromCart(cartItemId) {
  const formData = new FormData();
  formData.append('cartItemId', cartItemId);
  
  return fetch(getContextPath() + '/api/cart/remove', {
    method: 'POST',
    body: formData,
    credentials: 'same-origin'
  })
  .then(response => response.json())
  .then(data => {
    if (data.success) {
      updateCartBadge(data.cartCount);
      
      // Dispatch cart updated event
      document.dispatchEvent(new CustomEvent('cartUpdated', {
        detail: { count: data.cartCount }
      }));
      
      showCartMessage(data.message, 'success');
    } else {
      showCartMessage(data.message, 'error');
    }
    return data;
  })
  .catch(error => {
    console.error('Error removing from cart:', error);
    showCartMessage('Đã có lỗi xảy ra khi xóa khỏi giỏ hàng', 'error');
    throw error;
  });
}

/**
 * Clear entire cart
 */
function clearCart() {
  return fetch(getContextPath() + '/api/cart/clear', {
    method: 'POST',
    credentials: 'same-origin'
  })
  .then(response => response.json())
  .then(data => {
    if (data.success) {
      updateCartBadge(0);
      
      // Dispatch cart updated event
      document.dispatchEvent(new CustomEvent('cartUpdated', {
        detail: { count: 0 }
      }));
      
      showCartMessage(data.message, 'success');
    } else {
      showCartMessage(data.message, 'error');
    }
    return data;
  })
  .catch(error => {
    console.error('Error clearing cart:', error);
    showCartMessage('Đã có lỗi xảy ra khi xóa giỏ hàng', 'error');
    throw error;
  });
}

/**
 * Show cart-related messages
 */
function showCartMessage(message, type) {
  // Check if there's already a toast notification system
  if (typeof showToast === 'function') {
    showToast(message, type);
  } else {
    // Simple fallback notification
    const notification = document.createElement('div');
    notification.className = `cart-notification cart-notification-${type}`;
    notification.textContent = message;
    notification.style.cssText = `
      position: fixed;
      top: 20px;
      right: 20px;
      background: ${type === 'success' ? '#4CAF50' : '#f44336'};
      color: white;
      padding: 12px 24px;
      border-radius: 4px;
      z-index: 10000;
      box-shadow: 0 2px 8px rgba(0,0,0,0.2);
    `;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
      notification.remove();
    }, 3000);
  }
}

/**
 * Get context path helper function
 */
function getContextPath() {
  return window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2)) || '';
} 