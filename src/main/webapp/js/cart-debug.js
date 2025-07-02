// Cart Debug Script
// This script helps debug cart functionality

console.log('Cart debug script loaded');

// Test if cart functions are available
setTimeout(() => {
    console.log('Testing cart functions availability:');
    console.log('window.addToCart:', typeof window.addToCart);
    console.log('window.openCart:', typeof window.openCart);
    console.log('window.closeCart:', typeof window.closeCart);
    console.log('window.clearCart:', typeof window.clearCart);
    
    // Test if cart elements exist
    console.log('Cart elements check:');
    console.log('cart-badge:', document.getElementById('cart-badge'));
    console.log('cart-icon-btn:', document.getElementById('cart-icon-btn'));
    console.log('cartModal:', document.getElementById('cartModal'));
    console.log('cartItemCount:', document.getElementById('cartItemCount'));
    
    // Check if any cart items exist in localStorage
    const sessionCart = localStorage.getItem('session_cart');
    console.log('Current session cart:', sessionCart);
    
    // Test adding a sample item
    window.testAddToCart = async function() {
        console.log('Testing add to cart with sample data...');
        const testService = {
            serviceId: 'test-1',
            serviceName: 'Test Service',
            serviceImage: 'https://via.placeholder.com/150',
            servicePrice: 100000,
            serviceDuration: 60
        };
        
        if (window.addToCart) {
            const result = await window.addToCart(testService);
            console.log('Test add to cart result:', result);
        } else {
            console.error('addToCart function not available for testing');
        }
    };
    
    console.log('Debug functions loaded. You can run window.testAddToCart() to test.');
}, 1000); 