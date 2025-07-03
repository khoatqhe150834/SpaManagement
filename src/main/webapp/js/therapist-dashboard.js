document.addEventListener('DOMContentLoaded', () => {
	const auth = new Auth();
	const currentUser = auth.getCurrentUser();

	// Role-based access control
	if (!currentUser || currentUser.role !== 'therapist') {
		window.location.href = 'login.html'; // Or a 403 page
		return;
	}

	// Mock data for a specific therapist's dashboard
	const mockTherapistData = {
		therapistName: currentUser.name || 'Anna Lee',
		appointments: [
			{
				time: '09:00 AM',
				duration: '60 min',
				client: 'Robert Brown',
				service: 'Swedish Massage',
				room: 'Tranquility Room',
				status: 'Completed',
				notes: 'Client reported lower back tension. Focused on that area.',
			},
			{
				time: '10:15 AM',
				duration: '90 min',
				client: 'Emily White',
				service: 'Deep Tissue Massage',
				room: 'Serenity Suite',
				status: 'In Progress',
				notes: 'Client is a returning customer. Prefers medium pressure.',
			},
			{
				time: '12:00 PM',
				duration: '60 min',
				client: 'Michael Green',
				service: 'Aromatherapy Facial',
				room: 'Zen Garden Room',
				status: 'Upcoming',
				notes: 'First-time client. Check for any skin allergies.',
			},
			{
				time: '02:00 PM',
				duration: '90 min',
				client: 'Jessica Blue',
				service: 'Hot Stone Therapy',
				room: 'Serenity Suite',
				status: 'Upcoming',
				notes: '',
			},
			{
				time: '04:00 PM',
				duration: '60 min',
				client: 'David Black',
				service: 'Sports Massage',
				room: 'Tranquility Room',
				status: 'Upcoming',
				notes: 'Focus on shoulder and leg muscles.',
			},
		],
	};

	const mainContent = document.getElementById('main-content');
	if (mainContent) {
		mainContent.innerHTML = `
      <div class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-bold text-gray-900 dark:text-white">
          Welcome, ${mockTherapistData.therapistName}
        </h1>
        <div class="text-right">
            <p class="text-lg font-semibold text-gray-700 dark:text-gray-300">Today's Appointments</p>
            <p class="text-2xl font-bold text-blue-600 dark:text-blue-400">${
							mockTherapistData.appointments.length
						}</p>
        </div>
      </div>
      
      <!-- Appointments Timeline -->
      <div>
        <h2 class="text-2xl font-semibold text-gray-800 dark:text-gray-200 mb-4">Your Schedule</h2>
        ${createAppointmentsTimeline(mockTherapistData.appointments)}
      </div>
    `;
	}
});

function createAppointmentsTimeline(appointments) {
	const getStatusClasses = (status) => {
		switch (status) {
			case 'Completed':
				return {
					bg: 'bg-gray-100 dark:bg-gray-700',
					text: 'text-gray-500 dark:text-gray-400',
					icon: `<svg class="w-5 h-5 text-green-500" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path></svg>`,
				};
			case 'In Progress':
				return {
					bg: 'bg-blue-50 dark:bg-blue-900/50',
					text: 'text-blue-800 dark:text-blue-300',
					icon: `<svg class="w-5 h-5 text-blue-500 animate-spin" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg>`,
				};
			case 'Upcoming':
			default:
				return {
					bg: 'bg-white dark:bg-gray-800',
					text: 'text-gray-900 dark:text-white',
					icon: `<svg class="w-5 h-5 text-gray-400" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.414-1.415L11 9.586V6z" clip-rule="evenodd"></path></svg>`,
				};
		}
	};

	return `
    <ol class="relative border-l border-gray-200 dark:border-gray-700">                  
      ${appointments
				.map((appt) => {
					const statusStyle = getStatusClasses(appt.status);
					return `
          <li class="mb-10 ml-6">            
            <span class="absolute flex items-center justify-center w-8 h-8 bg-gray-100 rounded-full -left-4 ring-4 ring-white dark:ring-gray-900 dark:bg-gray-600">
              ${statusStyle.icon}
            </span>
            <div class="shadow-md rounded-lg p-4 ${statusStyle.bg} ${statusStyle.text}">
              <div class="flex justify-between items-start">
                  <div>
                      <time class="block mb-1 text-sm font-normal leading-none text-gray-400 dark:text-gray-500">${
												appt.time
											} - ${appt.duration}</time>
                      <h3 class="text-lg font-semibold">${appt.service}</h3>
                      <p class="text-sm font-medium">Client: ${appt.client}</p>
                      <p class="text-sm text-gray-500 dark:text-gray-400">Room: ${
												appt.room
											}</p>
                  </div>
                  <span class="bg-blue-100 text-blue-800 text-xs font-medium px-2.5 py-0.5 rounded dark:bg-blue-900 dark:text-blue-300">${
										appt.status
									}</span>
              </div>
              <div class="mt-3 pt-3 border-t border-gray-200 dark:border-gray-600">
                  <h4 class="font-semibold text-sm mb-1">Client Notes:</h4>
                  <p class="text-sm italic text-gray-600 dark:text-gray-400">
                    ${
											appt.notes ||
											'<span class="opacity-70">No notes yet.</span>'
										}
                  </p>
                  ${
										appt.status !== 'Completed'
											? `<button class="mt-2 text-sm text-blue-600 hover:underline dark:text-blue-400">Add/Edit Notes</button>`
											: ''
									}
              </div>
            </div>
          </li>
        `;
				})
				.join('')}
    </ol>
  `;
} 