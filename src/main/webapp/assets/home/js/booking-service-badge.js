/**
 * Booking Service Badge Manager
 * Handles the display and updating of service count badge on the "Đặt lịch ngay" button
 */

(function() {
    'use strict';
    
    // Configuration
    const CONFIG = {
        badgeId: 'bookingServiceBadge',
        badgeGuestClass: 'booking-service-badge-guest',
        sessionStorageKey: 'selectedServices',

        maxBadgeCount: 99, // Show 99+ for counts above this
        pulseAnimationDuration: 400
    };
    
    // Initialize based on DOM readiness state
    if (document.readyState === 'loading') {
        // DOM is still loading, wait for DOMContentLoaded
        document.addEventListener('DOMContentLoaded', function() {
            BookingServiceBadge.init();
        });
    } else {
        // DOM is already loaded, initialize immediately
        setTimeout(function() {
            BookingServiceBadge.init();
        }, 0);
    }
    
    // Additional redundant check after page fully loads (catches cases where session data loads late)
    window.addEventListener('load', function() {
        setTimeout(function() {
            if (window.BookingServiceBadge && window.BookingServiceBadge.badge) {
                console.log('🔄 Post-load badge check - loading from database and storage...');
                window.BookingServiceBadge.loadFromDatabase(); // Try database again after full page load
                window.BookingServiceBadge.performComprehensiveStorageCheck();
                window.BookingServiceBadge.updateBadgeFromStorage();
            }
        }, 500);
    });
    
    // Main BookingServiceBadge object
    window.BookingServiceBadge = {
        badge: null,
        currentCount: 0,
        apiCallInProgress: false,
        lastApiCall: 0,
        
        /**
         * Initialize the badge system
         */
        init: function() {
            // Try to find badge by ID first (for customers)
            this.badge = document.getElementById(CONFIG.badgeId);
            
            // If not found, try to find by class (for guests)
            if (!this.badge) {
                this.badge = document.querySelector('.' + CONFIG.badgeGuestClass);
            }
            
            // If still not found, try any booking service badge
            if (!this.badge) {
                this.badge = document.querySelector('.booking-service-badge');
            }
            
            if (!this.badge) {
                console.log('No booking service badge found on this page - this is normal for admin/staff pages');
                return;
            }
            
            console.log('Badge element found:', this.badge);
            
            // IMMEDIATE: Load from database first (most authoritative)
            this.loadFromDatabase();
            
            // IMMEDIATE: Check ALL possible storage sources as backup
            this.performComprehensiveStorageCheck();
            
            // IMMEDIATE synchronization check on init
            this.forceSynchronizeAllSources();
            
            // Initial count update 
            this.updateBadgeFromStorage();
            
            // Multiple delayed checks to catch data that loads after DOM
            setTimeout(() => {
                this.loadFromDatabase(); // Try database again
                this.performComprehensiveStorageCheck();
                this.forceSynchronizeAllSources();
                this.updateBadgeFromStorage();
            }, 100);
            
            setTimeout(() => {
                this.loadFromDatabase(); // Try database again
                this.performComprehensiveStorageCheck();
                this.forceSynchronizeAllSources();
                this.updateBadgeFromStorage();
            }, 500);
            
            setTimeout(() => {
                this.forceSynchronizeAllSources();
                this.updateBadgeFromStorage();
            }, 2000);
            
            // Set up storage listeners
            this.setupStorageListeners();
            
            // Set up periodic updates (in case of cross-tab changes)
            this.setupPeriodicUpdates();
            
            // Add test functionality in development
            this.addTestFunctionality();
            
            console.log('Booking service badge initialized successfully');
        },
        
        /**
         * Load service count from database/server session immediately
         */
        loadFromDatabase: function() {
            console.log('🗄️ Loading service count from database...');
            
            // Don't restrict to API pages - always try to load from database
            if (!this.badge) {
                return;
            }
            
            // Make API call but don't block on it
            this.fetchBookingSessionFromAPI(true); // true = immediate load
        },
        
        /**
         * Perform comprehensive storage check - check ALL storage sources immediately
         */
        performComprehensiveStorageCheck: function() {
            console.log('🔍 Performing comprehensive storage check...');
            
            let totalServicesFound = 0;
            let sourceFound = '';
            
            // Check 1: sessionStorage selectedServices
            try {
                const selectedServices = sessionStorage.getItem('selectedServices');
                if (selectedServices) {
                    const parsed = JSON.parse(selectedServices);
                    if (Array.isArray(parsed) && parsed.length > 0) {
                        totalServicesFound = parsed.length;
                        sourceFound = 'sessionStorage.selectedServices';
                        console.log(`✅ Found ${totalServicesFound} services in sessionStorage.selectedServices:`, parsed);
                    }
                }
            } catch (e) {
                console.warn('Error checking sessionStorage.selectedServices:', e);
            }
            
            // Check 2: sessionStorage bookingSession
            if (totalServicesFound === 0) {
                try {
                    const bookingSession = sessionStorage.getItem('bookingSession');
                    if (bookingSession) {
                        const parsed = JSON.parse(bookingSession);
                        if (parsed && parsed.services && Array.isArray(parsed.services) && parsed.services.length > 0) {
                            totalServicesFound = parsed.services.length;
                            sourceFound = 'sessionStorage.bookingSession';
                            console.log(`✅ Found ${totalServicesFound} services in sessionStorage.bookingSession:`, parsed.services);
                        }
                    }
                } catch (e) {
                    console.warn('Error checking sessionStorage.bookingSession:', e);
                }
            }
            
            // Check 3: window.bookingData (various forms)
            if (totalServicesFound === 0) {
                if (typeof window.bookingData !== 'undefined') {
                    if (window.bookingData.sessionData && window.bookingData.sessionData.selectedServices) {
                        const services = window.bookingData.sessionData.selectedServices;
                        if (Array.isArray(services) && services.length > 0) {
                            totalServicesFound = services.length;
                            sourceFound = 'window.bookingData.sessionData.selectedServices';
                            console.log(`✅ Found ${totalServicesFound} services in window.bookingData.sessionData:`, services);
                        }
                    } else if (window.bookingData.selectedServices) {
                        const services = window.bookingData.selectedServices;
                        if (Array.isArray(services) && services.length > 0) {
                            totalServicesFound = services.length;
                            sourceFound = 'window.bookingData.selectedServices';
                            console.log(`✅ Found ${totalServicesFound} services in window.bookingData.selectedServices:`, services);
                        }
                    }
                }
            }
            
            // Check 4: window.savedBookingData
            if (totalServicesFound === 0) {
                if (typeof window.savedBookingData !== 'undefined' && window.savedBookingData.selectedServices) {
                    const services = window.savedBookingData.selectedServices;
                    if (Array.isArray(services) && services.length > 0) {
                        totalServicesFound = services.length;
                        sourceFound = 'window.savedBookingData.selectedServices';
                        console.log(`✅ Found ${totalServicesFound} services in window.savedBookingData:`, services);
                    }
                }
            }
            
            // If we found services, immediately update the badge
            if (totalServicesFound > 0) {
                console.log(`🎯 Immediately displaying ${totalServicesFound} services from ${sourceFound}`);
                this.updateBadge(totalServicesFound);
                return totalServicesFound;
            } else {
                console.log('⚠️ No services found in any storage source during comprehensive check');
                return 0;
            }
        },
        
        /**
         * Force synchronization of all data sources immediately
         */
        forceSynchronizeAllSources: function() {
            console.log('🔄 Force synchronizing all data sources...');
            
            // Check all possible authoritative sources in priority order
            let authoritativeData = null;
            let sourceName = '';
            
            // Priority 1: Server-side booking session data
            if (typeof window.bookingData !== 'undefined' && window.bookingData.sessionData && window.bookingData.sessionData.selectedServices) {
                authoritativeData = window.bookingData.sessionData.selectedServices;
                sourceName = 'window.bookingData.sessionData';
            }
            // Priority 2: Direct selected services in bookingData
            else if (typeof window.bookingData !== 'undefined' && window.bookingData.selectedServices) {
                authoritativeData = window.bookingData.selectedServices;
                sourceName = 'window.bookingData.selectedServices';
            }
            // Priority 3: Saved booking data
            else if (typeof window.savedBookingData !== 'undefined' && window.savedBookingData.selectedServices) {
                authoritativeData = window.savedBookingData.selectedServices;
                sourceName = 'window.savedBookingData';
            }
            
            if (authoritativeData && authoritativeData.length > 0) {
                console.log(`✅ Found authoritative data from ${sourceName} with ${authoritativeData.length} services`);
                console.log('📊 Authoritative services:', authoritativeData);
                
                // Force sync sessionStorage
                this.syncSessionStorageToMatch(authoritativeData);
                
                // Force sync bookingSession storage
                this.syncBookingSessionStorage(authoritativeData);
                
                // Immediately update badge
                this.updateBadge(authoritativeData.length);
                
                return authoritativeData.length;
            } else {
                console.log('⚠️ No authoritative data found, checking API...');
                // Try API as last resort
                this.fetchBookingSessionFromAPI();
                return 0;
            }
        },

        /**
         * Sync bookingSession storage to match authoritative data
         */
        syncBookingSessionStorage: function(authoritativeServices) {
            try {
                const bookingSessionData = {
                    services: authoritativeServices,
                    serviceCount: authoritativeServices.length,
                    lastFetched: Date.now(),
                    synchronized: true
                };
                
                sessionStorage.setItem('bookingSession', JSON.stringify(bookingSessionData));
                console.log('✅ Synchronized bookingSession storage:', bookingSessionData);
                
            } catch (e) {
                console.warn('Error syncing bookingSession storage:', e);
            }
        },
        
        /**
         * Update badge count from various storage sources
         */
        updateBadgeFromStorage: function() {
            // Don't do anything if no badge element
            if (!this.badge) {
                return;
            }
            
            let totalCount = 0;
            let foundBookingData = false;
            let dataSource = '';
            
            // Check for booking session data first (priority)
            const bookingSessionData = this.getBookingSessionData();
            if (bookingSessionData && bookingSessionData.services) {
                totalCount += bookingSessionData.services.length;
                foundBookingData = true;
                dataSource = 'booking session data';
            }
            
            // Check other sources even if we found booking data (for debugging/validation)
            const selectedServices = this.getSelectedServicesFromStorage();
            if (selectedServices.length > 0) {
                if (!foundBookingData) {
                    totalCount = selectedServices.length;
                    dataSource = 'sessionStorage selectedServices';
                } else {
                    console.log(`Note: Also found ${selectedServices.length} services in sessionStorage, but using booking session data (${totalCount})`);
                }
            }
            
            // If still no data found, try comprehensive check
            if (totalCount === 0) {
                const comprehensiveCount = this.performComprehensiveStorageCheck();
                if (comprehensiveCount > 0) {
                    totalCount = comprehensiveCount;
                    dataSource = 'comprehensive storage check';
                }
                // Note: We no longer call API here since database loading happens immediately on init
            }
            
            console.log(`Updating badge with count ${totalCount} from ${dataSource}`);
            this.updateBadge(totalCount);
        },

        /**
         * Determine if we should fetch from API based on current page
         */
        shouldFetchFromAPI: function() {
            const currentPath = window.location.pathname;
            // Only fetch from API on customer/guest pages, not admin pages
            return !currentPath.includes('/admin/') && 
                   !currentPath.includes('/manager/') && 
                   !currentPath.includes('/therapist/') && 
                   !currentPath.includes('/receptionist/');
        },
        
        /**
         * Get selected services from session storage
         */
        getSelectedServicesFromStorage: function() {
            try {
                const stored = sessionStorage.getItem(CONFIG.sessionStorageKey);
                return stored ? JSON.parse(stored) : [];
            } catch (e) {
                console.warn('Error reading selected services from storage:', e);
                return [];
            }
        },
        
        /**
         * Get booking session data from various sources
         */
        getBookingSessionData: function() {
            try {
                // Method 1: Check if booking session data is available from server (time-therapists page)
                if (typeof window.bookingData !== 'undefined' && window.bookingData.sessionData) {
                    const services = window.bookingData.sessionData.selectedServices || [];
                    console.log('Found booking session data from bookingData:', services);
                    
                    // Sync sessionStorage to match this authoritative source
                    this.syncSessionStorageToMatch(services);
                    
                    return { services: services };
                }
                
                // Method 1b: Check if selectedServices is directly available in bookingData
                if (typeof window.bookingData !== 'undefined' && window.bookingData.selectedServices) {
                    const services = window.bookingData.selectedServices || [];
                    console.log('Found booking session data from bookingData.selectedServices:', services);
                    
                    // Sync sessionStorage to match this authoritative source
                    this.syncSessionStorageToMatch(services);
                    
                    return { services: services };
                }
                
                // Method 2: Check if saved booking data is available (services-selection page)
                if (typeof window.savedBookingData !== 'undefined' && window.savedBookingData.selectedServices) {
                    const services = window.savedBookingData.selectedServices || [];
                    console.log('Found booking session data from savedBookingData:', services);
                    
                    // Sync sessionStorage to match this authoritative source  
                    this.syncSessionStorageToMatch(services);
                    
                    return { services: services };
                }
                
                // Method 3: Check session storage as fallback
                const stored = sessionStorage.getItem('bookingSession');
                if (stored) {
                    const parsed = JSON.parse(stored);
                    if (parsed && parsed.services && parsed.services.length > 0) {
                        console.log('Found booking session data from sessionStorage:', parsed.services);
                        return { services: parsed.services };
                    }
                }
                
                return null;
            } catch (e) {
                console.warn('Error getting booking session data:', e);
                return null;
            }
        },

        /**
         * Sync sessionStorage 'selectedServices' to match the authoritative booking data
         */
        syncSessionStorageToMatch: function(authoritativeServices) {
            try {
                // Convert authoritative service data to sessionStorage format
                const sessionStorageFormat = authoritativeServices.map(service => ({
                    id: service.serviceId || service.id,
                    serviceId: service.serviceId || service.id,
                    serviceName: service.serviceName || service.name,
                    price: service.estimatedPrice || service.price,
                    duration: service.estimatedDuration || service.duration
                }));
                
                // Update sessionStorage to match
                sessionStorage.setItem('selectedServices', JSON.stringify(sessionStorageFormat));
                console.log('✅ Synchronized sessionStorage to match authoritative data:', sessionStorageFormat);
                
            } catch (e) {
                console.warn('Error syncing sessionStorage:', e);
            }
        },

        /**
         * Fetch booking session data from server API
         */
        fetchBookingSessionFromAPI: function(immediate = false) {
            // Prevent multiple simultaneous API calls
            if (this.apiCallInProgress) {
                if (immediate) {
                    console.log('API call already in progress, but this is immediate load - will try again shortly');
                    setTimeout(() => this.fetchBookingSessionFromAPI(true), 200);
                }
                console.log('API call already in progress, skipping');
                return;
            }
            
            this.apiCallInProgress = true;
            const self = this;
            
            console.log(`🌐 Fetching booking session from database${immediate ? ' (immediate load)' : ''}...`);
            
            // Use context path from JSP (set in stylesheet.jsp)
            const contextPath = window.APP_CONTEXT_PATH || '';
            const apiUrl = `${contextPath}/api/booking-session`;
            
            console.log(`Making API call to: ${apiUrl}`);
            
            fetch(apiUrl, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json'
                },
                credentials: 'same-origin'
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                }
                return response.json();
            })
            .then(data => {
                if (data.success && data.data) {
                    console.log('✅ Fetched booking session from database:', data.data);
                    const serviceCount = data.data.serviceCount || 0;
                    const selectedServices = data.data.selectedServices || [];
                    
                    if (serviceCount > 0 || selectedServices.length > 0) {
                        const actualCount = selectedServices.length || serviceCount;
                        console.log(`🎯 Database shows ${actualCount} services - updating badge immediately`);
                        
                        // Sync sessionStorage to match database data
                        self.syncSessionStorageToMatch(selectedServices);
                        
                        // Cache the result in bookingSession storage
                        sessionStorage.setItem('bookingSession', JSON.stringify({
                            services: selectedServices,
                            serviceCount: actualCount,
                            lastFetched: Date.now(),
                            source: 'database'
                        }));
                        
                        // Immediately update badge with database count
                        self.updateBadge(actualCount);
                        self.lastApiCall = Date.now();
                        
                        console.log(`✅ Badge updated with ${actualCount} services from database`);
                    } else {
                        console.log('📭 Database shows no services');
                        if (!immediate) {
                            self.updateBadge(0);
                        }
                    }
                } else {
                    console.log('📭 No booking session data from database API');
                    if (immediate) {
                        // On immediate load, if database is empty, still check local storage as fallback
                        console.log('🔄 No database data on immediate load, checking local storage...');
                        self.updateBadgeFromStorage();
                    } else {
                        self.updateBadge(0);
                    }
                }
            })
            .catch(error => {
                console.warn('❌ Error fetching booking session from database:', error);
                if (immediate) {
                    // On immediate load failure, fall back to local storage
                    console.log('🔄 Database failed on immediate load, falling back to local storage...');
                    self.updateBadgeFromStorage();
                } else {
                    // Don't reset badge to 0 on API error, keep current state
                    console.log('API error, keeping current badge state');
                }
            })
            .finally(() => {
                self.apiCallInProgress = false;
            });
        },
        
        /**
         * Update the badge with new count
         */
        updateBadge: function(count) {
            if (!this.badge) return;
            
            const numericCount = parseInt(count) || 0;
            const wasVisible = this.badge.style.display !== 'none';
            const countChanged = this.currentCount !== numericCount;
            
            this.currentCount = numericCount;
            
            if (numericCount > 0) {
                // Show badge with count
                const displayCount = numericCount > CONFIG.maxBadgeCount ? '99+' : numericCount.toString();
                this.badge.textContent = displayCount;
                this.badge.style.display = 'flex';
                
                // Add pulse animation if count changed and badge was already visible
                if (countChanged && wasVisible) {
                    this.addPulseAnimation();
                }
                
                // Set ARIA label for accessibility
                this.badge.setAttribute('aria-label', `${numericCount} dịch vụ đã chọn`);
            } else {
                // Hide badge when count is 0
                this.badge.style.display = 'none';
                this.badge.removeAttribute('aria-label');
            }
        },
        
        /**
         * Add pulse animation to badge
         */
        addPulseAnimation: function() {
            if (!this.badge) return;
            
            this.badge.classList.add('pulse');
            setTimeout(() => {
                this.badge.classList.remove('pulse');
            }, CONFIG.pulseAnimationDuration);
        },
        
        /**
         * Set up storage event listeners for cross-tab updates
         */
        setupStorageListeners: function() {
            const self = this;
            
            // Listen for storage changes (cross-tab communication)
            window.addEventListener('storage', function(e) {
                if (e.key === CONFIG.sessionStorageKey ||
                    e.key === 'bookingSession') {
                    self.updateBadgeFromStorage();
                }
            });
            
            // Listen for custom events that might be dispatched by other scripts
            window.addEventListener('servicesUpdated', function() {
                self.updateBadgeFromStorage();
            });
            
            window.addEventListener('bookingSessionUpdated', function() {
                self.updateBadgeFromStorage();
            });
        },
        
        /**
         * Set up periodic updates to catch any missed changes
         */
        setupPeriodicUpdates: function() {
            const self = this;
            setInterval(function() {
                // Only run if we have a badge element
                if (!self.badge) {
                    return;
                }
                
                // Only do periodic updates if we don't have recent local data
                const lastApiCall = self.lastApiCall || 0;
                const timeSinceLastCall = Date.now() - lastApiCall;
                
                // Only update if no API call in last 30 seconds and no local data
                if (timeSinceLastCall > 30000 && !self.hasLocalData()) {
                    self.updateBadgeFromStorage();
                }
            }, 10000); // Check every 10 seconds (less frequent)
        },

        /**
         * Check if we have local booking data available
         */
        hasLocalData: function() {
            return (typeof window.bookingData !== 'undefined' && window.bookingData.sessionData) ||
                   (typeof window.savedBookingData !== 'undefined' && window.savedBookingData.selectedServices) ||
                   sessionStorage.getItem('bookingSession');
        },
        
        /**
         * Manually update the badge (for external use)
         */
        refresh: function() {
            this.updateBadgeFromStorage();
        },
        
        /**
         * Add a service to the count (for external use)
         */
        addService: function(serviceData) {
            // This could be expanded to actually manage the service data
            // For now, just trigger a refresh
            this.refresh();
            
            // Dispatch custom event
            window.dispatchEvent(new CustomEvent('servicesUpdated', {
                detail: { action: 'add', service: serviceData }
            }));
        },
        
        /**
         * Remove a service from the count (for external use)
         */
        removeService: function(serviceId) {
            // This could be expanded to actually manage the service data
            // For now, just trigger a refresh
            this.refresh();
            
            // Dispatch custom event
            window.dispatchEvent(new CustomEvent('servicesUpdated', {
                detail: { action: 'remove', serviceId: serviceId }
            }));
        },
        
        /**
         * Clear all services (for external use)
         */
        clearServices: function() {
            this.updateBadge(0);
            
            // Dispatch custom event
            window.dispatchEvent(new CustomEvent('servicesUpdated', {
                detail: { action: 'clear' }
            }));
        },
        
        /**
         * Add test functionality for debugging
         */
        addTestFunctionality: function() {
            // Add global test functions for debugging
            window.testBookingBadge = {
                show: (count = 1) => {
                    console.log('Testing badge with count:', count);
                    this.updateBadge(count);
                },
                hide: () => {
                    console.log('Hiding badge');
                    this.updateBadge(0);
                },
                addTestService: () => {
                    const testServices = JSON.parse(sessionStorage.getItem('selectedServices') || '[]');
                    testServices.push({
                        id: 'test-' + Date.now(),
                        name: 'Test Service',
                        price: 100000
                    });
                    sessionStorage.setItem('selectedServices', JSON.stringify(testServices));
                    this.updateBadgeFromStorage();
                    console.log('Added test service. Total services:', testServices.length);
                },
                clearTestServices: () => {
                    sessionStorage.removeItem('selectedServices');
                    this.updateBadgeFromStorage();
                    console.log('Cleared all test services');
                },
                debug: () => {
                    console.log('🔍 BOOKING BADGE DEBUG REPORT');
                    console.log('================================');
                    
                    // Check all data sources
                    console.log('📊 Data Sources:');
                    console.log('- window.bookingData:', typeof window.bookingData !== 'undefined' ? window.bookingData : 'undefined');
                    console.log('- window.savedBookingData:', typeof window.savedBookingData !== 'undefined' ? window.savedBookingData : 'undefined');
                    console.log('- sessionStorage bookingSession:', sessionStorage.getItem('bookingSession'));
                    console.log('- sessionStorage selectedServices:', sessionStorage.getItem('selectedServices'));
                    
                    // Check what each source reports for service count
                    console.log('\n📈 Service Counts by Source:');
                    
                    if (typeof window.bookingData !== 'undefined' && window.bookingData.sessionData) {
                        const services = window.bookingData.sessionData.selectedServices || [];
                        console.log(`- bookingData.sessionData: ${services.length} services`);
                        console.log('  Services:', services);
                    }
                    
                    if (typeof window.bookingData !== 'undefined' && window.bookingData.selectedServices) {
                        const services = window.bookingData.selectedServices || [];
                        console.log(`- bookingData.selectedServices: ${services.length} services`);
                        console.log('  Services:', services);
                    }
                    
                    if (typeof window.savedBookingData !== 'undefined' && window.savedBookingData.selectedServices) {
                        const services = window.savedBookingData.selectedServices || [];
                        console.log(`- savedBookingData: ${services.length} services`);
                        console.log('  Services:', services);
                    }
                    
                    const sessionServices = this.getSelectedServicesFromStorage();
                    console.log(`- sessionStorage selectedServices: ${sessionServices.length} services`);
                    console.log('  Services:', sessionServices);
                    
                    const bookingSession = sessionStorage.getItem('bookingSession');
                    if (bookingSession) {
                        try {
                            const parsed = JSON.parse(bookingSession);
                            console.log(`- sessionStorage bookingSession: ${parsed.services ? parsed.services.length : 0} services`);
                            console.log('  Services:', parsed.services);
                        } catch (e) {
                            console.log('- sessionStorage bookingSession: Invalid JSON');
                        }
                    } else {
                        console.log('- sessionStorage bookingSession: null');
                    }
                    
                    // Show current badge state
                    console.log('\n🏷️ Badge State:');
                    console.log('- Badge element found:', !!this.badge);
                    if (this.badge) {
                        console.log('- Badge visible:', this.badge.style.display !== 'none');
                        console.log('- Badge text:', this.badge.textContent);
                    }
                    
                    // Show what getBookingSessionData returns
                    console.log('\n🎯 Current Priority Data Source:');
                    const currentData = this.getBookingSessionData();
                    if (currentData) {
                        console.log(`- Selected source has ${currentData.services.length} services`);
                        console.log('- Services:', currentData.services);
                    } else {
                        console.log('- No booking data found');
                    }
                    
                    console.log('================================');
                },
                testAPI: () => {
                    console.log('Testing API fetch...');
                    this.fetchBookingSessionFromAPI();
                },
                showForced: (count = 1) => {
                    console.log('Forcing badge to show with count:', count);
                    if (this.badge) {
                        this.badge.style.display = 'flex';
                        this.badge.textContent = count.toString();
                        console.log('Badge forced to show');
                    } else {
                        console.log('No badge element found on this page');
                    }
                },
                simulateBookingSession: () => {
                    console.log('Creating simulated booking session...');
                    const testData = {
                        services: [
                            { serviceId: 1, serviceName: 'Massage Thụy Điển' },
                            { serviceId: 2, serviceName: 'Trị Mụn Chuyên Sâu' },
                            { serviceId: 3, serviceName: 'Massage Đá Nóng' }
                        ],
                        serviceCount: 3,
                        lastFetched: Date.now()
                    };
                    sessionStorage.setItem('bookingSession', JSON.stringify(testData));
                    this.updateBadgeFromStorage();
                    console.log('Simulated booking session created with 3 services');
                },
                refresh: () => {
                    console.log('Manually refreshing badge...');
                    this.updateBadgeFromStorage();
                },
                forceUpdate: () => {
                    console.log('Force updating badge from current data...');
                    console.log('Available data sources:');
                    if (typeof window.bookingData !== 'undefined') {
                        console.log('- window.bookingData:', window.bookingData);
                    }
                    if (typeof window.savedBookingData !== 'undefined') {
                        console.log('- window.savedBookingData:', window.savedBookingData);
                    }
                    this.updateBadgeFromStorage();
                },
                forceSyncAll: () => {
                    console.log('🔄 Using new force synchronization method...');
                    this.forceSynchronizeAllSources();
                },
                fullDebugReport: () => {
                    console.log('🔍 COMPREHENSIVE DEBUG REPORT');
                    console.log('=====================================');
                    
                    // Show current page info
                    console.log('📄 Page Info:');
                    console.log('- URL:', window.location.href);
                    console.log('- Path:', window.location.pathname);
                    
                    // Show all available data
                    console.log('\n📊 All Available Data:');
                    if (typeof window.bookingData !== 'undefined') {
                        console.log('- window.bookingData:', window.bookingData);
                        if (window.bookingData.sessionData) {
                            console.log('- bookingData.sessionData.selectedServices:', window.bookingData.sessionData.selectedServices);
                        }
                        if (window.bookingData.selectedServices) {
                            console.log('- bookingData.selectedServices:', window.bookingData.selectedServices);
                        }
                    } else {
                        console.log('- window.bookingData: undefined');
                    }
                    
                    if (typeof window.savedBookingData !== 'undefined') {
                        console.log('- window.savedBookingData:', window.savedBookingData);
                    } else {
                        console.log('- window.savedBookingData: undefined');
                    }
                    
                    console.log('- sessionStorage selectedServices:', sessionStorage.getItem('selectedServices'));
                    console.log('- sessionStorage bookingSession:', sessionStorage.getItem('bookingSession'));
                    
                    // Show badge info
                    console.log('\n🏷️ Badge Element:');
                    if (this.badge) {
                        console.log('- Element found:', this.badge);
                        console.log('- ID:', this.badge.id);
                        console.log('- Classes:', this.badge.className);
                        console.log('- Current text:', this.badge.textContent);
                        console.log('- Visible:', this.badge.style.display !== 'none');
                    } else {
                        console.log('- Badge element not found');
                    }
                    
                    // Force sync and show result
                    console.log('\n🔄 Force Sync Result:');
                    const syncResult = this.forceSynchronizeAllSources();
                    console.log('- Sync returned count:', syncResult);
                    
                    console.log('=====================================');
                }
            };
            
            console.log('Test functions added. Use testBookingBadge.show(3), testBookingBadge.addTestService(), etc.');
        }
    };
    
    // Global helper functions for easy access
    window.updateBookingBadge = function() {
        if (window.BookingServiceBadge) {
            window.BookingServiceBadge.refresh();
        }
    };
    
    window.addServiceToBadge = function(serviceData) {
        if (window.BookingServiceBadge) {
            window.BookingServiceBadge.addService(serviceData);
        }
    };
    
    window.removeServiceFromBadge = function(serviceId) {
        if (window.BookingServiceBadge) {
            window.BookingServiceBadge.removeService(serviceId);
        }
    };
    
    window.clearBookingBadge = function() {
        if (window.BookingServiceBadge) {
            window.BookingServiceBadge.clearServices();
        }
    };
    
})(); 