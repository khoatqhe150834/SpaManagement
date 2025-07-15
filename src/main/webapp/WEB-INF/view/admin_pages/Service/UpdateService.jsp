<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập nhật dịch vụ</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              primary: "#D4AF37",
              "primary-dark": "#B8941F",
              secondary: "#FADADD",
              "spa-cream": "#FFF8F0",
              "spa-dark": "#333333",
            },
            fontFamily: {
              serif: ["Playfair Display", "serif"],
              sans: ["Roboto", "sans-serif"],
            },
          },
        },
      };
    </script>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
</head>
<body class="bg-spa-cream font-sans min-h-screen">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        <main class="flex-1 py-12 lg:py-20 ml-64">
            <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
                <!-- Breadcrumb -->
                <div class="flex flex-wrap items-center gap-2 mb-8 text-gray-500 text-sm">
                    <a href="service?service=list-all&page=${page}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}${not empty serviceTypeId ? '&serviceTypeId='.concat(serviceTypeId) : ''}" class="flex items-center gap-1 hover:text-primary">
                        <i data-lucide="home" class="w-4 h-4"></i>
                        Danh sách dịch vụ
                    </a>
                    <span>-</span>
                    <span class="text-primary font-semibold">Cập nhật dịch vụ</span>
                </div>
                <!-- Card Form -->
                <div class="bg-white rounded-2xl shadow-lg p-8">
                    <form action="service" method="post" enctype="multipart/form-data" id="service-form">
                        <input type="hidden" name="service" value="update" />
                        <input type="hidden" name="id" value="${service.serviceId}" />
                        <input type="hidden" name="stypeId" value="${service.serviceTypeId.serviceTypeId}" />
                        <!-- Thông tin cơ bản -->
                        <div class="mb-8">
                            <h2 class="text-lg font-semibold text-primary mb-4 flex items-center gap-2"><i data-lucide="file-text" class="w-5 h-5"></i> Thông tin cơ bản</h2>
                            <div class="grid grid-cols-1 gap-6">
                                <div>
                                    <label class="block font-medium text-gray-700 mb-1">Loại dịch vụ</label>
                                    <input type="text" class="w-full border rounded-lg px-3 py-2 bg-gray-100" value="${service.serviceTypeId.name}" readonly>
                                    <input type="hidden" name="service_type_id" value="${service.serviceTypeId.serviceTypeId}" />
                                </div>
                                <div>
                                    <label for="name" class="block font-medium text-gray-700 mb-1">Tên dịch vụ <span class="text-red-600">*</span></label>
                                    <input type="text" name="name" class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary" id="name" placeholder="Nhập tên dịch vụ" value="${service.name}" required />
                                    <div class="flex justify-between items-center mt-1">
                                        <div class="text-sm" id="nameError"></div>
                                        <small class="text-gray-400 ml-auto" id="nameCharCount">0/200</small>
                                    </div>
                                </div>
                                <div>
                                    <label for="description" class="block font-medium text-gray-700 mb-1">Mô tả</label>
                                    <textarea name="description" id="description" class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary" rows="5">${service.description}</textarea>
                                    <div class="flex justify-between items-center mt-1">
                                        <div class="text-sm" id="descriptionError"></div>
                                        <small class="text-gray-400 ml-auto" id="descCharCount">0/500</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Giá & Thời gian -->
                        <div class="mb-8">
                            <h2 class="text-lg font-semibold text-primary mb-4 flex items-center gap-2"><i data-lucide="wallet" class="w-5 h-5"></i> Giá & Thời gian</h2>
                            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                                <div>
                                    <label for="price" class="block font-medium text-gray-700 mb-1">Giá</label>
                                    <div class="flex items-center">
                                        <input type="number" name="price" class="w-full border rounded-l-lg px-3 py-2 focus:ring-primary focus:border-primary" id="price" value="${service.price}" required>
                                        <span class="inline-block bg-gray-100 border border-l-0 rounded-r-lg px-3 py-2 text-gray-500">VND</span>
                                    </div>
                                    <div class="text-sm mt-1" id="priceError"></div>
                                </div>
                                <div>
                                    <label for="duration_minutes" class="block font-medium text-gray-700 mb-1">Thời lượng</label>
                                    <div class="flex items-center">
                                        <input type="number" name="duration_minutes" class="w-full border rounded-l-lg px-3 py-2 focus:ring-primary focus:border-primary" id="duration_minutes" value="${service.durationMinutes}">
                                        <span class="inline-block bg-gray-100 border border-l-0 rounded-r-lg px-3 py-2 text-gray-500">phút</span>
                                    </div>
                                    <div class="text-sm mt-1" id="durationError"></div>
                                </div>
                                <div>
                                    <label for="buffer_time_after_minutes" class="block font-medium text-gray-700 mb-1">Thời gian chờ</label>
                                    <div class="flex items-center">
                                        <input type="number" name="buffer_time_after_minutes" class="w-full border rounded-l-lg px-3 py-2 focus:ring-primary focus:border-primary" id="buffer_time_after_minutes" value="${service.bufferTimeAfterMinutes}">
                                        <span class="inline-block bg-gray-100 border border-l-0 rounded-r-lg px-3 py-2 text-gray-500">phút</span>
                                    </div>
                                    <div class="text-sm mt-1" id="bufferError"></div>
                                </div>
                            </div>
                        </div>
                        <!-- Hình ảnh dịch vụ -->
                        <div class="mb-8">
                            <h2 class="text-lg font-semibold text-primary mb-4 flex items-center gap-2"><i data-lucide="image" class="w-5 h-5"></i> Hình ảnh dịch vụ</h2>
                            <div class="flex flex-wrap items-center gap-3 mb-2">
                                <c:forEach var="img" items="${serviceImages}">
                                    <div class="relative h-28 w-28 border-2 border-dashed border-gray-300 rounded-lg bg-gray-50 overflow-hidden flex items-center justify-center mr-2 mb-2 existing-img-container" data-img-id="${img.id}">
                                        <img src="${pageContext.request.contextPath}${img.imageUrl}" class="w-full h-full object-cover" />
                                        <input type="checkbox" name="delete_image_ids" value="${img.id}" id="delete_img_${img.id}" class="delete-checkbox hidden" />
                                        <button type="button" class="absolute top-1 right-1 bg-white rounded-full p-1 shadow remove-existing-img-btn" title="Xóa ảnh này">
                                            <i data-lucide="x" class="w-4 h-4 text-red-600"></i>
                                        </button>
                                    </div>
                                </c:forEach>
                                <div class="flex gap-3 flex-wrap uploaded-imgs-container"></div>
                                <label class="flex flex-col items-center justify-center gap-1 h-28 w-28 border-2 border-dashed border-gray-300 rounded-lg bg-gray-50 hover:bg-gray-100 cursor-pointer" for="upload-file-multiple">
                                    <i data-lucide="camera" class="w-6 h-6 text-gray-400"></i>
                                    <span class="text-gray-500 text-sm">Tải lên</span>
                                    <input id="upload-file-multiple" type="file" name="images" multiple hidden>
                                </label>
                            </div>
                            <div class="text-sm mt-1" id="imageError"></div>
                        </div>
                        <!-- Cài đặt -->
                        <div class="mb-8">
                            <h2 class="text-lg font-semibold text-primary mb-4 flex items-center gap-2"><i data-lucide="settings" class="w-5 h-5"></i> Cài đặt</h2>
                            <div class="space-y-3">
                                <div class="flex items-center justify-between bg-gray-50 rounded-lg px-4 py-2">
                                    <div>
                                        <div class="font-semibold">Active</div>
                                        <div class="text-xs text-gray-400">Dịch vụ sẽ hiển thị và có thể được đặt lịch.</div>
                                    </div>
                                    <label class="inline-flex items-center cursor-pointer">
                                        <input type="checkbox" name="is_active" id="is_active" class="sr-only peer" ${service.isActive ? "checked" : "" }>
                                        <div class="w-11 h-6 bg-gray-200 rounded-full peer peer-checked:bg-primary transition-all"></div>
                                        <div class="dot absolute left-1 top-1 bg-white w-4 h-4 rounded-full transition-all peer-checked:translate-x-5"></div>
                                    </label>
                                </div>
                                <div class="flex items-center justify-between bg-gray-50 rounded-lg px-4 py-2">
                                    <div>
                                        <div class="font-semibold">Cho phép đặt online</div>
                                        <div class="text-xs text-gray-400">Cho phép khách hàng tự đặt lịch cho dịch vụ này qua website.</div>
                                    </div>
                                    <label class="inline-flex items-center cursor-pointer">
                                        <input type="checkbox" name="bookable_online" id="bookable_online" class="sr-only peer" ${service.bookableOnline ? "checked" : "" }>
                                        <div class="w-11 h-6 bg-gray-200 rounded-full peer peer-checked:bg-primary transition-all"></div>
                                        <div class="dot absolute left-1 top-1 bg-white w-4 h-4 rounded-full transition-all peer-checked:translate-x-5"></div>
                                    </label>
                                </div>
                                <div class="flex items-center justify-between bg-gray-50 rounded-lg px-4 py-2">
                                    <div>
                                        <div class="font-semibold">Yêu cầu tư vấn</div>
                                        <div class="text-xs text-gray-400">Yêu cầu khách hàng phải được tư vấn trước khi đặt dịch vụ.</div>
                                    </div>
                                    <label class="inline-flex items-center cursor-pointer">
                                        <input type="checkbox" name="requires_consultation" id="requires_consultation" class="sr-only peer" ${service.requiresConsultation ? "checked" : "" }>
                                        <div class="w-11 h-6 bg-gray-200 rounded-full peer peer-checked:bg-primary transition-all"></div>
                                        <div class="dot absolute left-1 top-1 bg-white w-4 h-4 rounded-full transition-all peer-checked:translate-x-5"></div>
                                    </label>
                                </div>
                            </div>
                        </div>
                        <!-- Nút bấm -->
                        <div class="flex justify-end gap-3 mt-8">
                            <a href="service?service=list-all&page=${page}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}${not empty serviceTypeId ? '&serviceTypeId='.concat(serviceTypeId) : ''}" class="inline-flex items-center gap-2 px-6 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition">
                                <i data-lucide="arrow-left" class="w-5 h-5"></i> Hủy
                            </a>
                            <button type="submit" class="inline-flex items-center gap-2 px-6 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition">
                                <i data-lucide="save" class="w-5 h-5"></i> Cập nhật
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
    <script>
        var contextPath = "${pageContext.request.contextPath}";
        if (window.lucide) lucide.createIcons();
    </script>
    <!-- Giữ lại toàn bộ script validation, upload ảnh, ... ở cuối file như cũ -->
    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
    <script>
        // Utility functions for validation
        function setValid(input, errorDiv, message) {
            input.classList.remove('is-invalid');
            input.classList.add('is-valid');
            errorDiv.textContent = message;
            errorDiv.style.color = '#22c55e';
        }
        function setInvalid(input, errorDiv, message) {
            input.classList.remove('is-valid');
            input.classList.add('is-invalid');
            errorDiv.textContent = message;
            errorDiv.style.color = '#f44336';
        }
        function setDefault(input, errorDiv) {
            input.classList.remove('is-valid', 'is-invalid');
            errorDiv.textContent = '';
        }
        function updateCharCount(input, counterId, maxLength) {
            const counter = document.getElementById(counterId);
            const currentLength = input.value.length;
            counter.textContent = `${currentLength}/${maxLength}`;
            if (currentLength > maxLength * 0.8) {
                counter.style.color = '#f59e0b';
            } else if (currentLength > maxLength) {
                counter.style.color = '#f44336';
            } else {
                counter.style.color = '#6b7280';
            }
        }
        function validateName(input) {
            const vietnameseNamePattern = /^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s]+$/;
            const value = input.value.trim();
            const errorDiv = document.getElementById('nameError');
            if (value === '') {
                setInvalid(input, errorDiv, 'Tên dịch vụ không được để trống');
                return false;
            }
            if (value.length < 2) {
                setInvalid(input, errorDiv, 'Tên dịch vụ phải có ít nhất 2 ký tự');
                return false;
            }
            if (value.length > 200) {
                setInvalid(input, errorDiv, 'Tên dịch vụ không được vượt quá 200 ký tự');
                return false;
            }
            if (!vietnameseNamePattern.test(value)) {
                setInvalid(input, errorDiv, 'Tên dịch vụ chỉ được chứa chữ cái và khoảng trắng');
                return false;
            }
            setValid(input, errorDiv, 'Tên hợp lệ');
            return true;
        }
        function validateDescription(input) {
            const errorDiv = document.getElementById('descriptionError');
            const value = input.value.trim();
            if (value.length > 500) {
                setInvalid(input, errorDiv, 'Mô tả không được vượt quá 500 ký tự');
                return false;
            }
            setValid(input, errorDiv, 'Mô tả hợp lệ');
            return true;
        }
        function validatePrice(input) {
            const errorDiv = document.getElementById('priceError');
            const value = parseFloat(input.value);
            if (isNaN(value) || value <= 0) {
                setInvalid(input, errorDiv, 'Giá phải là số dương');
                return false;
            }
            if (value > 10000000) {
                setInvalid(input, errorDiv, 'Giá không được vượt quá 10,000,000 VND');
                return false;
            }
            setValid(input, errorDiv, 'Giá hợp lệ');
            return true;
        }
        function validateDuration(input) {
            const errorDiv = document.getElementById('durationError');
            const value = parseInt(input.value);
            if (isNaN(value) || value <= 0) {
                setInvalid(input, errorDiv, 'Thời lượng phải là số dương');
                return false;
            }
            if (value < 15) {
                setInvalid(input, errorDiv, 'Thời lượng tối thiểu là 15 phút');
                return false;
            }
            if (value > 480) {
                setInvalid(input, errorDiv, 'Thời lượng không được vượt quá 8 giờ (480 phút)');
                return false;
            }
            setValid(input, errorDiv, 'Thời lượng hợp lệ');
            return true;
        }
        function validateBufferTime(input) {
            const errorDiv = document.getElementById('bufferError');
            const value = parseInt(input.value);
            if (isNaN(value) || value < 0) {
                setInvalid(input, errorDiv, 'Thời gian chờ phải là số không âm');
                return false;
            }
            if (value > 120) {
                setInvalid(input, errorDiv, 'Thời gian chờ không được vượt quá 2 giờ (120 phút)');
                return false;
            }
            setValid(input, errorDiv, 'Thời gian chờ hợp lệ');
            return true;
        }
        function handleImageUpload(input) {
            const files = input.files;
            const container = document.querySelector('.uploaded-imgs-container');
            const errorDiv = document.getElementById('imageError');
            if (files.length === 0) {
                setDefault(input, errorDiv);
                return;
            }
            for (let i = 0; i < files.length; i++) {
                const file = files[i];
                if (file.size > 5 * 1024 * 1024) {
                    setInvalid(input, errorDiv, `File ${file.name} vượt quá 5MB`);
                    return;
                }
                const validTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
                if (!validTypes.includes(file.type)) {
                    setInvalid(input, errorDiv, `File ${file.name} không phải là ảnh hợp lệ`);
                    return;
                }
            }
            setValid(input, errorDiv, `${files.length} ảnh đã được chọn`);
            container.innerHTML = '';
            for (let i = 0; i < files.length; i++) {
                const file = files[i];
                const reader = new FileReader();
                reader.onload = function(e) {
                    const previewDiv = document.createElement('div');
                    previewDiv.className = 'relative h-28 w-28 border-2 border-dashed border-gray-300 rounded-lg bg-gray-50 overflow-hidden flex items-center justify-center mr-2 mb-2';
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.className = 'w-full h-full object-cover';
                    const removeBtn = document.createElement('button');
                    removeBtn.type = 'button';
                    removeBtn.className = 'absolute top-1 right-1 bg-white rounded-full p-1 shadow hover:bg-red-50';
                    removeBtn.innerHTML = '<i data-lucide="x" class="w-4 h-4 text-red-600"></i>';
                    removeBtn.onclick = function() {
                        previewDiv.remove();
                        const dt = new DataTransfer();
                        const input = document.getElementById('upload-file-multiple');
                        const { files } = input;
                        for (let i = 0; i < files.length; i++) {
                            if (i !== Array.from(container.children).indexOf(previewDiv)) {
                                dt.items.add(files[i]);
                            }
                        }
                        input.files = dt.files;
                    };
                    previewDiv.appendChild(img);
                    previewDiv.appendChild(removeBtn);
                    container.appendChild(previewDiv);
                    if (window.lucide) {
                        lucide.createIcons();
                    }
                };
                reader.readAsDataURL(file);
            }
        }
        function validateForm() {
            const nameValid = validateName(document.getElementById('name'));
            const descValid = validateDescription(document.getElementById('description'));
            const priceValid = validatePrice(document.getElementById('price'));
            const durationValid = validateDuration(document.getElementById('duration_minutes'));
            const bufferValid = validateBufferTime(document.getElementById('buffer_time_after_minutes'));
            return nameValid && descValid && priceValid && durationValid && bufferValid;
        }
        // AJAX check duplicate service name
        function checkServiceNameDuplicate(name, id, callback) {
            $.ajax({
                url: contextPath + '/manager/service',
                type: 'GET',
                data: { service: 'check-duplicate-name', name: name, id: id },
                dataType: 'json',
                success: function (response) {
                    callback(!response.valid, response.message);
                },
                error: function () {
                    callback(false, 'Không thể kiểm tra tên. Vui lòng thử lại.');
                }
            });
        }
        document.addEventListener('DOMContentLoaded', function() {
            const nameInput = document.getElementById('name');
            const descInput = document.getElementById('description');
            const priceInput = document.getElementById('price');
            const durationInput = document.getElementById('duration_minutes');
            const bufferInput = document.getElementById('buffer_time_after_minutes');
            const imageInput = document.getElementById('upload-file-multiple');
            const serviceId = document.querySelector('input[name="id"]').value;
            // Name validation
            nameInput.addEventListener('input', function() {
                updateCharCount(this, 'nameCharCount', 200);
                if (validateName(this)) {
                    checkServiceNameDuplicate(this.value.trim(), serviceId, function(isDuplicate, msg) {
                        if (isDuplicate) {
                            setInvalid(nameInput, document.getElementById('nameError'), msg || 'Tên này đã tồn tại trong hệ thống');
                        } else {
                            setValid(nameInput, document.getElementById('nameError'), 'Tên hợp lệ');
                        }
                    });
                }
            });
            nameInput.addEventListener('blur', function() {
                this.value = this.value.replace(/\s+/g, ' ').trim();
                if (validateName(this)) {
                    checkServiceNameDuplicate(this.value.trim(), serviceId, function(isDuplicate, msg) {
                        if (isDuplicate) {
                            setInvalid(nameInput, document.getElementById('nameError'), msg || 'Tên này đã tồn tại trong hệ thống');
                        } else {
                            setValid(nameInput, document.getElementById('nameError'), 'Tên hợp lệ');
                        }
                    });
                }
            });
            // Description validation
            descInput.addEventListener('input', function() {
                updateCharCount(this, 'descCharCount', 500);
                validateDescription(this);
            });
            descInput.addEventListener('blur', function() {
                this.value = this.value.replace(/\s+/g, ' ').trim();
                validateDescription(this);
            });
            // Price validation
            priceInput.addEventListener('input', validatePrice.bind(null, priceInput));
            priceInput.addEventListener('blur', validatePrice.bind(null, priceInput));
            // Duration validation
            durationInput.addEventListener('input', validateDuration.bind(null, durationInput));
            durationInput.addEventListener('blur', validateDuration.bind(null, durationInput));
            // Buffer time validation
            bufferInput.addEventListener('input', validateBufferTime.bind(null, bufferInput));
            bufferInput.addEventListener('blur', validateBufferTime.bind(null, bufferInput));
            // Image upload
            if (imageInput) {
                imageInput.addEventListener('change', function() {
                    handleImageUpload(this);
                });
            }
            // Form submission
            document.getElementById('service-form').addEventListener('submit', function(e) {
                if (!validateForm()) {
                    e.preventDefault();
                    alert('Vui lòng kiểm tra lại thông tin trước khi lưu!');
                }
            });
        });
    </script>
    <style>
        .is-valid {
            border: 2px solid #22c55e !important;
        }
        .is-invalid {
            border: 2px solid #f44336 !important;
        }
        .invalid-feedback {
            margin-top: 4px;
            font-size: 0.95em;
            min-height: 18px;
            color: red;
            display: block;
        }
        .is-valid ~ .invalid-feedback {
            color: #22c55e;
        }
    </style>
</body>
</html>