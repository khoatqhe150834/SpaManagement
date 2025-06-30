document.addEventListener('DOMContentLoaded', () => {
	const auth = new Auth();
	const currentUser = auth.getCurrentUser();

	// Role-based access control
	if (!currentUser || currentUser.role !== 'marketing') {
		window.location.href = 'login.html'; // Or a 403 page
		return;
	}

	const mockMarketingData = {
		kpis: {
			ctr: '2.5%',
			conversionRate: '5.2%',
			cpa: '$25.40',
			totalLeads: 450,
		},
		campaigns: [
			{
				name: 'Summer Glow Package',
				status: 'Active',
				channel: 'Social Media',
				spend: 1200,
				conversions: 60,
				roi: '350%',
			},
			{
				name: 'New Year, New You',
				status: 'Active',
				channel: 'Email',
				spend: 800,
				conversions: 85,
				roi: '520%',
			},
			{
				name: 'Mother\'s Day Special',
				status: 'Finished',
				channel: 'Google Ads',
				spend: 1500,
				conversions: 75,
				roi: '400%',
			},
			{
				name: 'Holiday Relaxation',
				status: 'Upcoming',
				channel: 'All Channels',
				spend: 0,
				conversions: 0,
				roi: 'N/A',
			},
		],
		trafficSources: {
			labels: ['Organic Search', 'Social Media', 'Email', 'Paid Ads', 'Direct'],
			data: [40, 25, 15, 15, 5],
		},
		promotionRoi: [
			{ code: 'RELAX20', description: '20% off all massages', uses: 150, revenue: 7500 },
			{ code: 'SKIN15', description: '15% off facials', uses: 220, revenue: 11000 },
			{ code: 'NEW10', description: '10% off for new clients', uses: 80, revenue: 4000 },
		],
	};

	const mainContent = document.getElementById('main-content');
	if (mainContent) {
		mainContent.innerHTML = `
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-4">
        ${createKpiCards(mockMarketingData.kpis)}
      </div>

      <div class="grid grid-cols-1 xl:grid-cols-5 gap-4">
        <!-- Active Campaigns Table -->
        <div class="xl:col-span-3 bg-white dark:bg-gray-800 shadow-md sm:rounded-lg p-4">
          <h3 class="text-xl font-bold dark:text-white mb-4">Campaign Performance</h3>
          <div class="overflow-x-auto">
            ${createCampaignsTable(mockMarketingData.campaigns)}
          </div>
        </div>

        <!-- Traffic Sources Chart -->
        <div class="xl:col-span-2 bg-white dark:bg-gray-800 shadow-md sm:rounded-lg p-4 flex flex-col items-center">
          <h3 class="text-xl font-bold dark:text-white mb-4">Traffic Sources</h3>
          <canvas id="trafficSourcesChart" class="w-full h-full"></canvas>
        </div>
      </div>

       <!-- Promotion ROI -->
      <div class="mt-4 bg-white dark:bg-gray-800 shadow-md sm:rounded-lg p-4">
        <h3 class="text-xl font-bold dark:text-white mb-4">Promotion ROI</h3>
        <div class="overflow-hidden">
          ${createPromotionList(mockMarketingData.promotionRoi)}
        </div>
      </div>
    `;

		// Initialize Chart.js
		renderTrafficSourcesChart(mockMarketingData.trafficSources);
	}
});

function createKpiCards(kpis) {
	const kpiItems = [
		{ label: 'Click-Through Rate', value: kpis.ctr },
		{ label: 'Conversion Rate', value: kpis.conversionRate },
		{ label: 'Cost Per Acquisition', value: kpis.cpa },
		{ label: 'Total Leads', value: kpis.totalLeads },
	];

	return kpiItems
		.map(
			(item) => `
    <div class="bg-white dark:bg-gray-800 shadow-md rounded-lg p-4">
      <p class="text-sm font-medium text-gray-500 dark:text-gray-400">${item.label}</p>
      <p class="text-2xl font-bold text-gray-900 dark:text-white">${item.value}</p>
    </div>
  `
		)
		.join('');
}

function createCampaignsTable(campaigns) {
	const getStatusClass = (status) => {
		switch (status) {
			case 'Active':
				return 'text-green-700 bg-green-100 dark:bg-green-700 dark:text-green-100';
			case 'Finished':
				return 'text-gray-700 bg-gray-100 dark:bg-gray-700 dark:text-gray-100';
			case 'Upcoming':
				return 'text-blue-700 bg-blue-100 dark:bg-blue-700 dark:text-blue-100';
			default:
				return '';
		}
	};
	return `
    <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
      <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
        <tr>
          <th scope="col" class="px-6 py-3">Campaign</th>
          <th scope="col" class="px-6 py-3">Status</th>
          <th scope="col" class="px-6 py-3">Conversions</th>
          <th scope="col" class="px-6 py-3">ROI</th>
        </tr>
      </thead>
      <tbody>
        ${campaigns
					.map(
						(campaign) => `
          <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700">
            <th scope="row" class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white">${campaign.name}</th>
            <td class="px-6 py-4">
              <span class="px-2 py-1 font-semibold leading-tight rounded-full ${getStatusClass(
								campaign.status
							)}">
                ${campaign.status}
              </span>
            </td>
            <td class="px-6 py-4">${campaign.conversions}</td>
            <td class="px-6 py-4 font-bold ${
							campaign.roi.startsWith('N') ? 'text-gray-500' : 'text-green-500'
						}">${campaign.roi}</td>
          </tr>
        `
					)
					.join('')}
      </tbody>
    </table>
  `;
}

function renderTrafficSourcesChart(trafficData) {
	const ctx = document.getElementById('trafficSourcesChart').getContext('2d');
	new Chart(ctx, {
		type: 'doughnut',
		data: {
			labels: trafficData.labels,
			datasets: [
				{
					label: 'Traffic Source',
					data: trafficData.data,
					backgroundColor: [
						'#1c64f2', // blue
						'#16bdca', // teal
						'#9061f9', // purple
						'#f2994a', // orange
						'#6875f5', // indigo
					],
					hoverOffset: 4,
				},
			],
		},
		options: {
			responsive: true,
			maintainAspectRatio: false,
			legend: {
				position: 'bottom',
			},
		},
	});
}

function createPromotionList(promotions) {
	return `
    <ul class="divide-y divide-gray-200 dark:divide-gray-700">
      ${promotions
				.map(
					(promo) => `
        <li class="py-3 sm:py-4">
          <div class="flex items-center space-x-4">
            <div class="flex-shrink-0">
                <span class="text-lg font-bold text-blue-600 dark:text-blue-400 bg-blue-100 dark:bg-gray-700 rounded-lg px-3 py-2">${
									promo.code
								}</span>
            </div>
            <div class="flex-1 min-w-0">
              <p class="text-sm font-medium text-gray-900 truncate dark:text-white">${
								promo.description
							}</p>
              <p class="text-sm text-gray-500 truncate dark:text-gray-400">${
								promo.uses
							} uses</p>
            </div>
            <div class="inline-flex items-center text-base font-semibold text-gray-900 dark:text-white">
              $${promo.revenue.toLocaleString()}
            </div>
          </div>
        </li>
      `
				)
				.join('')}
    </ul>
  `;
} 