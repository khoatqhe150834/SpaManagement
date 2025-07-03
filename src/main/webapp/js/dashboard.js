// js/dashboard.js

/**
 * Manages the main dashboard layout, including the sidebar and header.
 * It is responsible for role-based authentication and navigation.
 * Specific dashboard content is handled by separate scripts (e.g., admin-dashboard.js).
 */
class DashboardLayout {
	constructor() {
		this.auth = new Auth();
		this.user = this.auth.getCurrentUser();
		this.role = this.user ? this.user.role : null;

		// Define navigation for all roles
		this.sidebarNavs = {
			customer: [
				{ name: 'Dashboard', icon: 'layout-dashboard', href: 'customer-dashboard.html' },
				{ name: 'My Appointments', icon: 'calendar', href: '#' },
				{ name: 'My Wishlist', icon: 'heart', href: '#' },
				{ name: 'Profile', icon: 'user', href: '#' },
			],
			admin: [
				{ name: 'Dashboard', icon: 'layout-dashboard', href: 'admin-dashboard.html' },
				{ name: 'User Management', icon: 'users', href: '#' },
				{ name: 'Service Management', icon: 'briefcase', href: '#' },
				{ name: 'Settings', icon: 'settings', href: '#' },
			],
			manager: [
				{ name: 'Dashboard', icon: 'layout-dashboard', href: 'manager-dashboard.html' },
				{ name: 'Staff Schedule', icon: 'calendar-check', href: '#' },
				{ name: 'Service Performance', icon: 'bar-chart-2', href: '#' },
				{ name: 'Inventory', icon: 'archive', href: '#' },
				{ name: 'Reports', icon: 'file-text', href: '#' },
			],
			marketing: [
				{ name: 'Dashboard', icon: 'layout-dashboard', href: 'marketing-dashboard.html' },
				{ name: 'Campaigns', icon: 'volume-2', href: '#' },
				{ name: 'Analytics', icon: 'trending-up', href: '#' },
				{ name: 'Promotions', icon: 'ticket', href: '#' },
			],
			therapist: [
				{ name: 'Dashboard', icon: 'layout-dashboard', href: 'therapist-dashboard.html' },
				{ name: 'My Schedule', icon: 'calendar', href: '#' },
				{ name: 'Client History', icon: 'history', href: '#' },
				{ name: 'Profile', icon: 'user', href: '#' },
			],
		};

		this.init();
	}

	async init() {
		// Protect all dashboard routes
		this.auth.protectRoute(['customer', 'admin', 'manager', 'marketing', 'therapist']);
		
		await this.loadLayout();
		this.populateHeader();
		this.populateSidebar();
		this.initEventListeners();
	}

	async loadLayout() {
		try {
			// Fetches the reusable layout and injects it into the page
			const response = await fetch('components/dashboard-layout.html');
			const layoutHtml = await response.text();
			const container = document.getElementById('dashboard-layout-container');
			if (container) {
				container.innerHTML = layoutHtml;
			} else {
				console.error('#dashboard-layout-container not found.');
			}
		} catch (error) {
			console.error('Error loading dashboard layout:', error);
		}
	}

	populateHeader() {
		const userEmailElement = document.getElementById('user-email');
		const userNameElement = document.getElementById('user-name');
		
		if (this.user) {
			if (userEmailElement) userEmailElement.textContent = this.user.email;
			if (userNameElement) userNameElement.textContent = this.user.name || this.user.role;
		}
	}

	populateSidebar() {
		const nav = document.getElementById('sidebar-nav');
		const navItems = this.sidebarNavs[this.role];
		if (!nav || !navItems) return;

		// Determine the current page to set the active link
		const currentPage = window.location.pathname.split('/').pop();

		nav.innerHTML = navItems
			.map((item) => {
				const isActive = item.href === currentPage;
				return `
            <li>
              <a href="${item.href}" class="flex items-center p-2 text-gray-900 rounded-lg dark:text-white ${
								isActive
									? 'bg-gray-100 dark:bg-gray-700'
									: 'hover:bg-gray-100 dark:hover:bg-gray-700'
							}">
                <i data-lucide="${item.icon}" class="w-5 h-5 text-gray-500 dark:text-gray-400"></i>
                <span class="ml-3">${item.name}</span>
              </a>
            </li>
          `;
			})
			.join('');
		
		lucide.createIcons();
	}

	initEventListeners() {
		const logoutBtn = document.getElementById('logout-btn');
		if (logoutBtn) {
			logoutBtn.addEventListener('click', (e) => {
				e.preventDefault();
				this.auth.logout();
			});
		}

		const userDropdownButton = document.getElementById('user-dropdown-button');
		const userDropdown = document.getElementById('user-dropdown');
		if(userDropdownButton && userDropdown) {
			userDropdownButton.addEventListener('click', () => {
				userDropdown.classList.toggle('hidden');
			});
		}
	}
}

document.addEventListener('DOMContentLoaded', () => {
	new DashboardLayout();
}); 