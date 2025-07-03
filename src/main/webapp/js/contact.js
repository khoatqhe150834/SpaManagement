// js/contact.js

class ContactPage {
    constructor() {
        this.faqItems = [
            {
                question: 'Tôi cần đặt lịch trước bao lâu?',
                answer: 'Chúng tôi khuyến khích đặt lịch trước ít nhất 24 giờ để đảm bảo có chỗ. Tuy nhiên, chúng tôi cũng nhận khách đột xuất tùy theo tình hình.'
            },
            {
                question: 'Các sản phẩm sử dụng có an toàn không?',
                answer: 'Tất cả sản phẩm tại spa đều là hàng chính hãng, có nguồn gốc rõ ràng và đã được kiểm định an toàn. Chúng tôi ưu tiên sử dụng các sản phẩm tự nhiên.'
            },
            {
                question: 'Có chính sách hoàn tiền không?',
                answer: 'Khách hàng có thể hủy lịch miễn phí trước 4 giờ. Nếu không hài lòng với dịch vụ, chúng tôi sẽ hoàn lại 100% chi phí.'
            },
            {
                question: 'Spa có phù hợp với da nhạy cảm không?',
                answer: 'Chúng tôi có các liệu pháp dành riêng cho da nhạy cảm. Xin vui lòng thông báo tình trạng da khi đặt lịch để được tư vấn phù hợp.'
            }
        ];

        this.init();
    }

    init() {
        this.initDOM();
        this.populateFAQ();
        this.initEventListeners();
    }

    initDOM() {
        this.form = document.getElementById('contact-form');
        this.formContainer = document.getElementById('form-container');
        this.successMessage = document.getElementById('form-success-message');
        this.faqContainer = document.getElementById('faq-container');
    }

    populateFAQ() {
        this.faqItems.forEach(item => {
            const faqItem = document.createElement('div');
            faqItem.className = 'bg-white rounded-lg shadow-sm';
            faqItem.innerHTML = `
                <button class="w-full flex justify-between items-center p-5 text-left font-semibold text-spa-dark focus:outline-none">
                    <span>${item.question}</span>
                    <i data-lucide="chevron-down" class="h-5 w-5 transition-transform"></i>
                </button>
                <div class="px-5 pb-5 text-gray-600 leading-relaxed hidden">
                    <p>${item.answer}</p>
                </div>
            `;
            this.faqContainer.appendChild(faqItem);
        });
        lucide.createIcons();
    }

    initEventListeners() {
        this.form.addEventListener('submit', e => this.handleSubmit(e));
        
        this.faqContainer.addEventListener('click', e => {
            const button = e.target.closest('button');
            if (button) {
                const answerDiv = button.nextElementSibling;
                const icon = button.querySelector('i');
                
                answerDiv.classList.toggle('hidden');
                icon.classList.toggle('rotate-180');
            }
        });
    }

    handleSubmit(e) {
        e.preventDefault();
        const formData = new FormData(this.form);
        const data = Object.fromEntries(formData.entries());

        if (data.name && data.phone && data.message) {
            this.formContainer.classList.add('hidden');
            this.successMessage.classList.remove('hidden');
            
            setTimeout(() => {
                this.successMessage.classList.add('hidden');
                this.formContainer.classList.remove('hidden');
                this.form.reset();
            }, 5000);
        } else {
            SpaApp.showNotification('Vui lòng điền các trường bắt buộc.', 'error');
        }
    }
}

document.addEventListener('DOMContentLoaded', () => {
    if (document.getElementById('contact-form')) {
        new ContactPage();
    }
}); 