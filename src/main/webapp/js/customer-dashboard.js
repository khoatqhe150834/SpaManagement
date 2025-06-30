document.addEventListener('DOMContentLoaded', () => {
	const auth = new Auth();
	const currentUser = auth.getCurrentUser();

	// Role-based access control
	if (!currentUser || currentUser.role !== 'customer') {
		window.location.href = 'login.html';
		return;
	}

	// Mock data for the customer's dashboard
	const customerData = {
		metrics: [
			{ label: 'Upcoming Appointments', value: '2', icon: 'calendar' },
			{ label: 'Loyalty Points', value: '1,250', icon: 'gift' },
			{ label: 'Membership Tier', value: 'Silver', icon: 'award' },
			{ label: 'Saved Services', value: '3', icon: 'heart' },
		],
		upcomingAppointments: [
			{
				date: 'Dec 25, 2024',
				time: '02:00 PM',
				service: 'Relaxation Massage',
				status: 'Confirmed',
			},
			{
				date: 'Dec 30, 2024',
				time: '11:00 AM',
				service: 'Aromatherapy Facial',
				status: 'Confirmed',
			},
		],
		appointmentHistory: [
			{
				date: 'Dec 15, 2024',
				service: 'Deep Tissue Massage',
				therapist: 'Anna Lee',
				rating: 5,
				status: 'Completed',
			},
			{
				date: 'Dec 01, 2024',
				service: 'Hot Stone Therapy',
				therapist: 'John Smith',
				rating: 4,
				status: 'Completed',
			},
		],
	};

	const mainContent = document.getElementById('main-content');
	if (mainContent) {
		mainContent.innerHTML = `
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-4">
        ${createMetricCards(customerData.metrics)}
      </div>

      <div class="grid grid-cols-1 gap-4">
        <!-- Upcoming Appointments -->
        <div class="bg-white dark:bg-gray-800 shadow-md sm:rounded-lg p-4">
          <h3 class="text-xl font-bold dark:text-white mb-4">Upcoming Appointments</h3>
          <div class="flow-root">
            ${createUpcomingAppointmentsList(customerData.upcomingAppointments)}
          </div>
        </div>
      </div>
      
      <!-- Appointment History -->
      <div class="mt-4 bg-white dark:bg-gray-800 shadow-md sm:rounded-lg p-4">
        <h3 class="text-xl font-bold dark:text-white mb-4">Appointment History</h3>
        <div class="overflow-x-auto">
          ${createAppointmentHistoryTable(customerData.appointmentHistory)}
        </div>
      </div>
    `;
		lucide.createIcons();
	}
});

function createMetricCards(metrics) {
	return metrics
		.map(
			(metric) => `
    <div class="bg-white dark:bg-gray-800 shadow-md rounded-lg p-4 flex items-center justify-between">
      <div>
        <p class="text-sm font-medium text-gray-500 dark:text-gray-400">${metric.label}</p>
        <p class="text-2xl font-bold text-gray-900 dark:text-white">${metric.value}</p>
      </div>
      <div class="bg-blue-100 dark:bg-blue-900 text-blue-600 dark:text-blue-300 rounded-full p-3">
        <i data-lucide="${metric.icon}" class="w-6 h-6"></i>
      </div>
    </div>
  `
		)
		.join('');
}

function createUpcomingAppointmentsList(appointments) {
	return `
    <ul role="list" class="divide-y divide-gray-200 dark:divide-gray-700">
      ${appointments
				.map(
					(appt) => `
        <li class="py-3 sm:py-4">
            <div class="flex items-center space-x-4">
                <div class="flex-shrink-0">
                    <div class="flex flex-col items-center justify-center w-12 h-12 bg-gray-100 dark:bg-gray-700 rounded-lg">
                        <span class="text-sm font-bold text-gray-900 dark:text-white">${
													appt.date.split(' ')[0]
												}</span>
                        <span class="text-lg font-extrabold text-blue-600 dark:text-blue-400">${
													appt.date.split(' ')[1].replace(',', '')
												}</span>
                    </div>
                </div>
                <div class="flex-1 min-w-0">
                    <p class="text-sm font-medium text-gray-900 truncate dark:text-white">${
											appt.service
										}</p>
                    <p class="text-sm text-gray-500 truncate dark:text-gray-400">${
											appt.time
										}</p>
                </div>
                <div class="inline-flex items-center text-xs font-semibold px-2.5 py-1 rounded-full bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300">
                    ${appt.status}
                </div>
            </div>
        </li>
      `
				)
				.join('')}
    </ul>
  `;
}

function createAppointmentHistoryTable(history) {
	return `
    <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
      <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
        <tr>
          <th scope="col" class="px-6 py-3">Date</th>
          <th scope="col" class="px-6 py-3">Service</th>
          <th scope="col" class="px-6 py-3">Therapist</th>
          <th scope="col" class="px-6 py-3">Rating</th>
          <th scope="col" class="px-6 py-3">Status</th>
        </tr>
      </thead>
      <tbody>
        ${history
					.map(
						(item) => `
          <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700">
            <td class="px-6 py-4">${item.date}</td>
            <th scope="row" class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white">${
							item.service
						}</th>
            <td class="px-6 py-4">${item.therapist}</td>
            <td class="px-6 py-4 flex items-center">
              ${[...Array(5)]
								.map(
									(_, i) =>
										`<i data-lucide="star" class="w-4 h-4 ${
											i < item.rating
												? 'text-yellow-400 fill-current'
												: 'text-gray-300 dark:text-gray-600'
										}"></i>`
								)
								.join('')}
            </td>
            <td class="px-6 py-4">
              <span class="text-xs font-medium mr-2 px-2.5 py-0.5 rounded-full bg-gray-100 text-gray-800 dark:bg-gray-600 dark:text-gray-300">${
								item.status
							}</span>
            </td>
          </tr>
        `
					)
					.join('')}
      </tbody>
    </table>
  `;
} 