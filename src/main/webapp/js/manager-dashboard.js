document.addEventListener('DOMContentLoaded', () => {
	const auth = new Auth();
	const currentUser = auth.getCurrentUser();

	// Role-based access control
	if (!currentUser || currentUser.role !== 'manager') {
		// Redirect to login or a 'not authorized' page if user is not a manager
		window.location.href = 'login.html';
		return;
	}

	// Mock data for the manager's dashboard
	const mockManagerData = {
		kpis: {
			totalRevenue: '4,520',
			todaysBookings: 28,
			occupancyRate: '85%',
			newClients: 12,
		},
		staffSchedule: [
			{
				id: 1,
				therapist: 'Anna Lee',
				time: '09:00 AM - 05:00 PM',
				status: 'On-Duty',
				appointments: 5,
			},
			{
				id: 2,
				therapist: 'John Smith',
				time: '10:00 AM - 06:00 PM',
				status: 'On-Duty',
				appointments: 7,
			},
			{
				id: 3,
				therapist: 'Maria Garcia',
				time: '11:00 AM - 07:00 PM',
				status: 'Break',
				appointments: 4,
			},
			{
				id: 4,
				therapist: 'Chen Wang',
				time: '01:00 PM - 09:00 PM',
				status: 'On-Duty',
				appointments: 6,
			},
		],
		servicePerformance: [
			{ name: 'Deep Tissue Massage', bookings: 125, revenue: 18750 },
			{ name: 'Aromatherapy Facial', bookings: 98, revenue: 12250 },
			{ name: 'Hot Stone Therapy', bookings: 75, revenue: 11250 },
			{ name: 'Manicure & Pedicure', bookings: 150, revenue: 9000 },
		],
		inventoryStatus: [
			{ item: 'Lavender Essential Oil', stock: 30, status: 'In Stock' },
			{ item: 'Massage Stones Set', stock: 5, status: 'Low Stock' },
			{ item: 'Organic Face Cream', stock: 50, status: 'In Stock' },
			{ item: 'Herbal Tea Selection', stock: 8, status: 'Low Stock' },
			{ item: 'Disposable Slippers', stock: 0, status: 'Out of Stock' },
		],
	};

	const mainContent = document.getElementById('main-content');
	if (mainContent) {
		mainContent.innerHTML = `
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-4">
        ${createKpiCards(mockManagerData.kpis)}
      </div>

      <div class="grid grid-cols-1 xl:grid-cols-2 gap-4">
        <!-- Staff Schedule -->
        <div class="bg-white dark:bg-gray-800 shadow-md sm:rounded-lg p-4">
          <h3 class="text-xl font-bold dark:text-white mb-4">Today's Staff Schedule</h3>
          <div class="overflow-x-auto">
            ${createStaffScheduleTable(mockManagerData.staffSchedule)}
          </div>
        </div>

        <!-- Service Performance -->
        <div class="bg-white dark:bg-gray-800 shadow-md sm:rounded-lg p-4">
          <h3 class="text-xl font-bold dark:text-white mb-4">Top Service Performance</h3>
          <div class="overflow-hidden">
            ${createServicePerformanceList(mockManagerData.servicePerformance)}
          </div>
        </div>
      </div>
      
      <!-- Inventory Status -->
      <div class="mt-4 bg-white dark:bg-gray-800 shadow-md sm:rounded-lg p-4">
        <h3 class="text-xl font-bold dark:text-white mb-4">Inventory Status</h3>
        <div class="overflow-x-auto">
          ${createInventoryStatusTable(mockManagerData.inventoryStatus)}
        </div>
      </div>
    `;
	}
});

function createKpiCards(kpis) {
	const kpiItems = [
		{
			label: 'Total Revenue',
			value: `$${kpis.totalRevenue}`,
			icon: 'cash',
		},
		{
			label: 'Today\'s Bookings',
			value: kpis.todaysBookings,
			icon: 'calendar',
		},
		{
			label: 'Occupancy Rate',
			value: kpis.occupancyRate,
			icon: 'users',
		},
		{
			label: 'New Clients',
			value: kpis.newClients,
			icon: 'user-plus',
		},
	];

	return kpiItems
		.map(
			(item) => `
    <div class="bg-white dark:bg-gray-800 shadow-md rounded-lg p-4 flex items-center justify-between">
      <div>
        <p class="text-sm font-medium text-gray-500 dark:text-gray-400">${item.label}</p>
        <p class="text-2xl font-bold text-gray-900 dark:text-white">${item.value}</p>
      </div>
      <div class="bg-blue-100 dark:bg-blue-900 text-blue-600 dark:text-blue-300 rounded-full p-3">
        <!-- SVG icon placeholder -->
        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v.01"></path></svg>
      </div>
    </div>
  `
		)
		.join('');
}

function createStaffScheduleTable(schedule) {
	return `
    <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
      <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
        <tr>
          <th scope="col" class="px-6 py-3">Therapist</th>
          <th scope="col" class="px-6 py-3">Schedule</th>
          <th scope="col" class="px-6 py-3">Status</th>
          <th scope="col" class="px-6 py-3 text-center">Appointments</th>
        </tr>
      </thead>
      <tbody>
        ${schedule
					.map(
						(member) => `
          <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700">
            <th scope="row" class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white">${member.therapist}</th>
            <td class="px-6 py-4">${member.time}</td>
            <td class="px-6 py-4">
                <span class="px-2 py-1 font-semibold leading-tight ${
									member.status === 'On-Duty'
										? 'text-green-700 bg-green-100 dark:bg-green-700 dark:text-green-100'
										: 'text-yellow-700 bg-yellow-100 dark:bg-yellow-700 dark:text-yellow-100'
								} rounded-full">
                    ${member.status}
                </span>
            </td>
            <td class="px-6 py-4 text-center">${member.appointments}</td>
          </tr>
        `
					)
					.join('')}
      </tbody>
    </table>
  `;
}

function createServicePerformanceList(services) {
	return `
    <ul class="divide-y divide-gray-200 dark:divide-gray-700">
      ${services
				.map(
					(service) => `
        <li class="py-3 sm:py-4">
          <div class="flex items-center space-x-4">
            <div class="flex-1 min-w-0">
              <p class="text-sm font-medium text-gray-900 truncate dark:text-white">${service.name}</p>
              <p class="text-sm text-gray-500 truncate dark:text-gray-400">${service.bookings} bookings</p>
            </div>
            <div class="inline-flex items-center text-base font-semibold text-gray-900 dark:text-white">
              $${service.revenue.toLocaleString()}
            </div>
          </div>
        </li>
      `
				)
				.join('')}
    </ul>
  `;
}

function createInventoryStatusTable(inventory) {
	const getStatusClass = (status) => {
		switch (status) {
			case 'In Stock':
				return 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300';
			case 'Low Stock':
				return 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-300';
			case 'Out of Stock':
				return 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-300';
			default:
				return 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300';
		}
	};

	return `
    <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
      <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
        <tr>
          <th scope="col" class="px-6 py-3">Item Name</th>
          <th scope="col" class="px-6 py-3">Stock Level</th>
          <th scope="col" class="px-6 py-3">Status</th>
        </tr>
      </thead>
      <tbody>
        ${inventory
					.map(
						(item) => `
          <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700">
            <th scope="row" class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white">${item.item}</th>
            <td class="px-6 py-4">${item.stock} units</td>
            <td class="px-6 py-4">
              <span class="text-xs font-medium mr-2 px-2.5 py-0.5 rounded-full ${getStatusClass(
								item.status
							)}">
                ${item.status}
              </span>
            </td>
          </tr>
        `
					)
					.join('')}
      </tbody>
    </table>
  `;
} 