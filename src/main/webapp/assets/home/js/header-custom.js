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
  

});



/**
 * Get context path helper function
 */
function getContextPath() {
  return window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2)) || '';
} 