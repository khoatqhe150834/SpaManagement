document.addEventListener('DOMContentLoaded', () => {
	const postsContainer = document.getElementById('blog-posts-container');

	// Mock data for blog posts
	const mockBlogPosts = [
		{
			id: 1,
			title: 'The Top 5 Benefits of Regular Massages',
			author: 'Jane Doe, Lead Therapist',
			date: 'October 26, 2024',
			excerpt:
				'Discover how regular massages can improve your physical and mental health, from reducing stress to boosting your immune system.',
			imageUrl:
				'https://images.unsplash.com/photo-1519824145371-296259d3de24?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
			category: 'Wellness',
		},
		{
			id: 2,
			title: 'A Guide to Skincare: Finding Your Perfect Facial',
			author: 'Emily White, Esthetician',
			date: 'October 22, 2024',
			excerpt:
				'Not sure which facial is right for you? Our expert esthetician breaks down the options to help you achieve glowing skin.',
			imageUrl:
				'https://images.unsplash.com/photo-1598452934505-1a2a5141ee9f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
			category: 'Beauty',
		},
		{
			id: 3,
			title: 'The Power of Aromatherapy: Scents for Mind and Body',
			author: 'Anna Lee, Aromatherapist',
			date: 'October 18, 2024',
			excerpt:
				'Learn how essential oils can be used to calm your mind, energize your body, and create a sense of balance in your daily life.',
			imageUrl:
				'https://images.unsplash.com/photo-1599387737838-66a158d684e2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
			category: 'Holistic Health',
		},
		{
			id: 4,
			title: 'Detox Your Body: The Benefits of a Spa Day',
			author: 'John Smith, Wellness Coach',
			date: 'October 15, 2024',
			excerpt:
				'A spa day is more than just a treat. It\'s a way to detoxify your body, clear your mind, and reset your system.',
			imageUrl:
				'https://images.unsplash.com/photo-1620732822221-a3c310b7df16?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
			category: 'Wellness',
		},
		{
			id: 5,
			title: 'Manicures and Pedicures: More Than Just a Polish',
			author: 'Maria Garcia, Nail Technician',
			date: 'October 11, 2024',
			excerpt:
				'Proper nail care is essential for your health and confidence. Learn the benefits of professional manicures and pedicures.',
			imageUrl:
				'https://images.unsplash.com/photo-1632345031435-8727f669dfcd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
			category: 'Beauty',
		},
		{
			id: 6,
			title: 'Yoga and Meditation for a Stress-Free Life',
			author: 'Chen Wang, Yoga Instructor',
			date: 'October 07, 2024',
			excerpt:
				'Combine the power of yoga and meditation to build resilience against stress. Simple practices you can do at home.',
			imageUrl:
				'https://images.unsplash.com/photo-1506126613408-4e0e0f7c50e1?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
			category: 'Mindfulness',
		},
	];

	if (postsContainer) {
		postsContainer.innerHTML = mockBlogPosts
			.map((post) => createPostCard(post))
			.join('');
	}

	// --- Single Post Page Logic ---
	const postContentContainer = document.getElementById('blog-post-content');
	if (postContentContainer) {
		renderSinglePost(mockBlogPosts);
	}
});

function renderSinglePost(posts) {
	const postContentContainer = document.getElementById('blog-post-content');
	const urlParams = new URLSearchParams(window.location.search);
	const postId = parseInt(urlParams.get('id'));
	const post = posts.find((p) => p.id === postId);

	if (post) {
		document.title = `${post.title} - Serenity Spa`; // Update page title
		postContentContainer.innerHTML = `
      <header class="mb-8">
        <p class="text-base text-blue-600 font-semibold tracking-wide uppercase">${
					post.category
				}</p>
        <h1 class="text-4xl md:text-5xl font-extrabold text-gray-900 leading-tight mt-2 mb-4">${
					post.title
				}</h1>
        <div class="flex items-center text-sm text-gray-500">
          <span>By ${post.author}</span>
          <span class="mx-2">&middot;</span>
          <span>${post.date}</span>
        </div>
      </header>
      <img src="${
				post.imageUrl
			}" alt="${post.title}" class="w-full h-96 object-cover rounded-lg shadow-md mb-8">
      <div class="prose lg:prose-xl max-w-none">
        <p class="lead">${post.excerpt}</p>
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent eget est in lorem consequat consectetur. Sed at semper eros, nec consectetur nunc. Nulla facilisi. Curabitur vel justo et est efficitur feugiat. Integer nec nulla id massa aliquam faucibus. Vivamus sit amet odio eget orci blandit feugiat.</p>
        <p>Suspendisse potenti. Mauris id magna in justo eleifend consequat. Sed euismod, quam et consequat luctus, arcu massa feugiat nisi, a commodo erat quam et magna. In hac habitasse platea dictumst. Morbi dapibus, sem vel commodo venenatis, justo felis semper erat, et luctus tortor lorem at nulla.</p>
        <blockquote>
          "Wellness is a state of complete physical, mental, and social well-being, and not merely the absence of disease or infirmity."
          <cite>- World Health Organization</cite>
        </blockquote>
        <h2>A Deeper Dive into Relaxation</h2>
        <p>Phasellus et ante sed augue faucibus consectetur. In hac habitasse platea dictumst. Sed nec elit at est tincidunt iaculis. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Donec at nisi eu lacus rutrum commodo. Proin dapibus, massa ut commodo suscipit, ipsum est tincidunt magna, ut consequat felis dui sit amet elit.</p>
        <p>Nullam id dolor id nibh ultricies vehicula ut id elit. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Cras mattis consectetur purus sit amet fermentum. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum.</p>
      </div>
    `;
	} else {
		postContentContainer.innerHTML = `
      <div class="text-center">
        <h1 class="text-4xl font-bold text-red-600">Post Not Found</h1>
        <p class="mt-4 text-gray-600">We couldn't find the blog post you were looking for.</p>
        <a href="blog.html" class="mt-6 inline-block bg-blue-500 text-white py-2 px-4 rounded-lg hover:bg-blue-600">
          &larr; Back to Blog
        </a>
      </div>
    `;
	}
}

function createPostCard(post) {
	return `
    <div class="bg-white rounded-lg shadow-lg overflow-hidden flex flex-col transform hover:scale-105 transition-transform duration-300">
      <img src="${post.imageUrl}" alt="${post.title}" class="w-full h-56 object-cover">
      <div class="p-6 flex flex-col flex-grow">
        <p class="text-sm text-blue-500 font-semibold">${post.category}</p>
        <h3 class="text-xl font-bold text-brown-700 mt-2 mb-2">${post.title}</h3>
        <p class="text-gray-600 flex-grow">${post.excerpt}</p>
        <div class="mt-4 pt-4 border-t border-gray-200">
          <div class="flex items-center justify-between">
              <div>
                  <p class="text-sm font-medium text-gray-900">${post.author}</p>
                  <p class="text-sm text-gray-500">${post.date}</p>
              </div>
              <a href="blog-post.html?id=${post.id}" class="text-blue-600 hover:text-blue-800 font-semibold">
                Read More &rarr;
              </a>
          </div>
        </div>
      </div>
    </div>
  `;
} 