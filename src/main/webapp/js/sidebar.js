class SidebarManager {
    constructor(userRole) {
        this.sidebar = document.getElementById('main-sidebar');
        if (!this.sidebar) {
            console.error("Sidebar element #main-sidebar not found.");
            return;
        }

        this.overlay = document.getElementById('sidebar-overlay');
        this.closeSidebarBtn = document.getElementById('close-sidebar-btn');
        this.logoutBtn = document.getElementById('logout-btn');
        this.navButtons = this.sidebar.querySelectorAll('.nav-button');
        
        this.userRole = userRole;
        this.activeItem = 'dashboard'; 
        this.expandedItems = new Set();
        
        this.init();
    }

    init() {
        this.autoExpandRoleMenu();
        this.initEventListeners();
        this.detectActiveItem();

        // Make toggle function globally available for header button
        window.toggleSidebar = () => this.toggleSidebar();
        
        if (window.lucide) {
            lucide.createIcons();
        }
    }

    autoExpandRoleMenu() {
        let roleMenuId = '';
        switch (this.userRole) {
            case 'CUSTOMER': roleMenuId = 'customer-portal'; break;
            case 'MANAGER': roleMenuId = 'manager-dashboard'; break;
            case 'ADMIN': roleMenuId = 'admin-panel'; break;
            case 'THERAPIST': roleMenuId = 'therapist-interface'; break;
            case 'MARKETING': roleMenuId = 'marketing-portal'; break;
        }
        
        if (roleMenuId) {
            this.expandedItems.add(roleMenuId);
            this.updateExpandedState();
        }
    }
    
    detectActiveItem() {
        const currentPath = window.location.pathname;
        let bestMatch = null;

        this.navButtons.forEach(button => {
            const buttonPath = button.dataset.path;
            if (buttonPath && currentPath.includes(buttonPath)) {
                // Find the most specific match
                if (!bestMatch || buttonPath.length > bestMatch.dataset.path.length) {
                    bestMatch = button;
                }
            }
        });
        
        if (bestMatch) {
            this.setActiveItem(bestMatch.dataset.itemId);
            const parentMenu = bestMatch.closest('.submenu');
            if (parentMenu) {
                const parentButton = parentMenu.previousElementSibling;
                if(parentButton && parentButton.dataset.itemId) {
                    this.expandedItems.add(parentButton.dataset.itemId);
                    this.updateExpandedState();
                }
            }
        } else {
             this.setActiveItem('dashboard'); // Default active item
        }
    }

    initEventListeners() {
        // Handle all navigation clicks via event delegation
        this.sidebar.addEventListener('click', (e) => {
            const button = e.target.closest('.nav-button');
            if (!button) return;

            const itemId = button.dataset.itemId;
            const path = button.dataset.path;

            if (button.classList.contains('nav-expandable')) {
                this.toggleExpanded(itemId);
            } else if (path) {
                this.setActiveItem(itemId);
                window.location.href = path;
            }
        });

        // Close button on mobile
        this.closeSidebarBtn?.addEventListener('click', () => this.closeSidebar());

        // Clicking the overlay closes the sidebar
        this.overlay?.addEventListener('click', () => this.closeSidebar());
        
        // Logout functionality
        this.logoutBtn?.addEventListener('click', () => {
             if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
                const contextPath = document.body.dataset.contextPath || '';
                window.location.href = `${contextPath}/logout`;
            }
        });
    }

    toggleSidebar() {
        if (this.sidebar.classList.contains('-translate-x-full')) {
            this.openSidebar();
        } else {
            this.closeSidebar();
        }
    }

    openSidebar() {
        this.sidebar.classList.remove('-translate-x-full');
        this.overlay?.classList.remove('hidden');
    }

    closeSidebar() {
        this.sidebar.classList.add('-translate-x-full');
        this.overlay?.classList.add('hidden');
    }

    toggleExpanded(itemId) {
        if (this.expandedItems.has(itemId)) {
            this.expandedItems.delete(itemId);
        } else {
            this.expandedItems.add(itemId);
        }
        this.updateExpandedState();
    }
    
    updateExpandedState() {
        this.sidebar.querySelectorAll('.nav-expandable').forEach(button => {
            const itemId = button.dataset.itemId;
            const submenu = button.nextElementSibling;
            const chevron = button.querySelector('[data-lucide="chevron-right"]');

            if (this.expandedItems.has(itemId)) {
                submenu?.classList.remove('hidden');
                chevron?.classList.add('rotate-90');
                button.classList.add('bg-[#FFF8F0]', 'text-[#D4AF37]');
            } else {
                submenu?.classList.add('hidden');
                chevron?.classList.remove('rotate-90');
                 if(this.activeItem !== itemId) {
                    button.classList.remove('bg-[#FFF8F0]', 'text-[#D4AF37]');
                }
            }
        });
    }

    setActiveItem(itemId) {
        if (!itemId) return;
        this.activeItem = itemId;

        this.navButtons.forEach(btn => {
            const icon = btn.querySelector('i[data-lucide]');
            if (btn.dataset.itemId === itemId && !btn.classList.contains('nav-expandable')) {
                btn.classList.add('bg-[#D4AF37]', 'text-white', 'shadow-sm');
                btn.classList.remove('text-gray-600', 'hover:bg-[#FFF8F0]', 'hover:text-[#D4AF37]');
                icon?.classList.add('text-white');
                icon?.classList.remove('text-gray-400', 'text-gray-500');
            } else {
                btn.classList.remove('bg-[#D4AF37]', 'text-white', 'shadow-sm');
                if(!this.expandedItems.has(btn.dataset.itemId)) {
                    btn.classList.add('text-gray-600', 'hover:bg-[#FFF8F0]', 'hover:text-[#D4AF37]');
                }
            }
        });
    }
}