Implement persist booking sessions for customers

Solution Overview
Generate a Unique Guest ID: When a guest visits the website, generate a unique ID (e.g., UUID) and store it in a cookie or localStorage.
Store booking sessions in Database: Save the service items in a database, linking them to the guest ID.
API Endpoints: Create backend endpoints to manage the cart (add, update, remove, retrieve).
Sync Cart: Use the guest ID to retrieve and update the cart on each page load or cart action.
Handle Login: If the guest logs in, merge their guest cart with their account’s cart.
Clean Up: Periodically remove expired guest carts.
