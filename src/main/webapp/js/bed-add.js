/**
 * Bed Add Form JavaScript
 * Handles validation and form submission for adding new beds
 */

document.addEventListener('DOMContentLoaded', function() {
    // Form validation
    document.getElementById('addBedForm').addEventListener('submit', function(e) {
        let isValid = true;

        // Validate bed name
        const name = document.getElementById('name').value.trim();
        const nameError = document.getElementById('nameError');
        if (!name) {
            nameError.textContent = 'Tên giường không được để trống.';
            nameError.classList.remove('hidden');
            isValid = false;
        } else if (name.length < 2) {
            nameError.textContent = 'Tên giường phải có ít nhất 2 ký tự.';
            nameError.classList.remove('hidden');
            isValid = false;
        } else if (name.length > 50) {
            nameError.textContent = 'Tên giường không được vượt quá 50 ký tự.';
            nameError.classList.remove('hidden');
            isValid = false;
        } else {
            nameError.classList.add('hidden');
        }

        // Validate description length
        const description = document.getElementById('description').value.trim();
        const descriptionError = document.getElementById('descriptionError');
        if (description.length > 200) {
            descriptionError.textContent = 'Mô tả không được vượt quá 200 ký tự.';
            descriptionError.classList.remove('hidden');
            isValid = false;
        } else {
            descriptionError.classList.add('hidden');
        }

        if (!isValid) {
            e.preventDefault();
        }
    });

    // Real-time validation with AJAX
    let nameValidationTimeout;
    const roomId = document.querySelector('input[name="roomId"]').value;

    document.getElementById('name').addEventListener('input', function() {
        const nameInput = this;
        const nameError = document.getElementById('nameError');
        const name = nameInput.value.trim();

        // Clear previous timeout
        clearTimeout(nameValidationTimeout);

        // Basic client-side validation first
        if (!name) {
            nameError.textContent = 'Tên giường không được để trống.';
            nameError.classList.remove('hidden');
            removeValidationIndicator(nameInput);
            return;
        }

        if (name.length < 2) {
            nameError.textContent = 'Tên giường phải có ít nhất 2 ký tự.';
            nameError.classList.remove('hidden');
            removeValidationIndicator(nameInput);
            return;
        }

        if (name.length > 50) {
            nameError.textContent = 'Tên giường không được vượt quá 50 ký tự.';
            nameError.classList.remove('hidden');
            removeValidationIndicator(nameInput);
            return;
        }

        // Hide error for basic validation
        nameError.classList.add('hidden');

        // Set timeout for AJAX validation (debouncing)
        nameValidationTimeout = setTimeout(() => {
            validateBedNameAjax(name, nameInput, nameError, roomId);
        }, 300);
    });

    // Character counter for description
    document.getElementById('description').addEventListener('input', function() {
        const charCount = document.getElementById('charCount');
        const descriptionError = document.getElementById('descriptionError');
        const currentLength = this.value.length;

        charCount.textContent = currentLength + '/200 ký tự';

        if (currentLength > 200) {
            charCount.classList.add('text-red-500');
            charCount.classList.remove('text-gray-500');
            descriptionError.textContent = 'Mô tả không được vượt quá 200 ký tự.';
            descriptionError.classList.remove('hidden');
        } else {
            charCount.classList.remove('text-red-500');
            charCount.classList.add('text-gray-500');
            descriptionError.classList.add('hidden');
        }
    });

    // AJAX validation functions
    function validateBedNameAjax(name, inputElement, errorElement, roomId) {
        // Show loading indicator
        showValidationLoading(inputElement);

        // Get context path from the current URL
        const contextPath = window.location.pathname.split('/')[1];

        // Make AJAX request to validate bed name within room
        fetch('/' + contextPath + '/api/validate/bed/name', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'name=' + encodeURIComponent(name) + '&roomId=' + encodeURIComponent(roomId)
        })
        .then(response => response.json())
        .then(data => {
            if (data.valid) {
                showValidationSuccess(inputElement);
                errorElement.classList.add('hidden');
            } else {
                showValidationError(inputElement);
                errorElement.textContent = data.message;
                errorElement.classList.remove('hidden');
            }
        })
        .catch(error => {
            console.error('Validation error:', error);
            removeValidationIndicator(inputElement);
            errorElement.textContent = 'Lỗi kiểm tra tên giường. Vui lòng thử lại.';
            errorElement.classList.remove('hidden');
        });
    }

    function showValidationLoading(inputElement) {
        removeValidationIndicator(inputElement);
        inputElement.style.borderColor = '#f59e0b';
        inputElement.style.backgroundImage = 'url("data:image/svg+xml,%3csvg width=\'20\' height=\'20\' viewBox=\'0 0 20 20\' xmlns=\'http://www.w3.org/2000/svg\'%3e%3cg fill=\'none\' fill-rule=\'evenodd\'%3e%3cg fill=\'%23f59e0b\' fill-opacity=\'0.8\'%3e%3cpath d=\'M10 3v3l4-4-4-4v3c-4.42 0-8 3.58-8 8 0 1.57.46 3.03 1.24 4.26L5.7 11.8c-.45-.83-.7-1.79-.7-2.8 0-3.31 2.69-6 6-6z\'/%3e%3c/g%3e%3c/g%3e%3c/svg%3e")';
        inputElement.style.backgroundRepeat = 'no-repeat';
        inputElement.style.backgroundPosition = 'right 10px center';
        inputElement.style.backgroundSize = '20px 20px';
    }

    function showValidationSuccess(inputElement) {
        removeValidationIndicator(inputElement);
        inputElement.style.borderColor = '#10b981';
        inputElement.style.backgroundImage = 'url("data:image/svg+xml,%3csvg width=\'20\' height=\'20\' viewBox=\'0 0 20 20\' xmlns=\'http://www.w3.org/2000/svg\'%3e%3cpath fill=\'%2310b981\' fill-rule=\'evenodd\' d=\'M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z\' clip-rule=\'evenodd\'/%3e%3c/svg%3e")';
        inputElement.style.backgroundRepeat = 'no-repeat';
        inputElement.style.backgroundPosition = 'right 10px center';
        inputElement.style.backgroundSize = '20px 20px';
    }

    function showValidationError(inputElement) {
        removeValidationIndicator(inputElement);
        inputElement.style.borderColor = '#ef4444';
        inputElement.style.backgroundImage = 'url("data:image/svg+xml,%3csvg width=\'20\' height=\'20\' viewBox=\'0 0 20 20\' xmlns=\'http://www.w3.org/2000/svg\'%3e%3cpath fill=\'%23ef4444\' fill-rule=\'evenodd\' d=\'M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z\' clip-rule=\'evenodd\'/%3e%3c/svg%3e")';
        inputElement.style.backgroundRepeat = 'no-repeat';
        inputElement.style.backgroundPosition = 'right 10px center';
        inputElement.style.backgroundSize = '20px 20px';
    }

    function removeValidationIndicator(inputElement) {
        inputElement.style.borderColor = '';
        inputElement.style.backgroundImage = '';
        inputElement.style.backgroundRepeat = '';
        inputElement.style.backgroundPosition = '';
        inputElement.style.backgroundSize = '';
    }
});
