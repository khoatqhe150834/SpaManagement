<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm mới dịch vụ</title>
    <!-- jQuery CDN -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
    <jsp:include page="/WEB-INF/view/admin_pages/Common/Header.jsp" />
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
                    <span class="text-primary font-semibold">Thêm mới dịch vụ</span>
                </div>
                <!-- Card Form -->
                <div class="bg-white rounded-2xl shadow-lg p-8">
                    <form action="service" method="post" enctype="multipart/form-data" id="service-form">
                        <input type="hidden" name="service" value="insert" />
                        <!-- Thông tin cơ bản -->
                        <div class="mb-8">
                            <h2 class="text-lg font-semibold text-primary mb-4 flex items-center gap-2"><i data-lucide="file-text" class="w-5 h-5"></i> Thông tin cơ bản</h2>
                            <div class="grid grid-cols-1 gap-6">
                                <div>
                                    <label for="service_type_id" class="block font-medium text-gray-700 mb-1">Loại dịch vụ <span class="text-red-600">*</span></label>
                                    <select name="service_type_id" id="service_type_id" class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary" required>
                                        <c:forEach var="type" items="${serviceTypes}">
                                            <option value="${type.serviceTypeId}">${type.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label for="name" class="block font-medium text-gray-700 mb-1">Tên dịch vụ <span class="text-red-600">*</span></label>
                                    <input type="text" name="name" class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary" id="name" placeholder="Nhập tên dịch vụ" required />
                                    <div class="flex justify-between items-center mt-1">
                                        <div class="text-sm" id="nameError"></div>
                                        <small class="text-gray-400 ml-auto" id="nameCharCount">0/200</small>
                                    </div>
                                </div>
                                <div>
                                    <label for="description" class="block font-medium text-gray-700 mb-1">Mô tả</label>
                                    <textarea name="description" id="description" class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary" placeholder="Nhập mô tả..." rows="5"></textarea>
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
                                    <label for="price" class="block font-medium text-gray-700 mb-1">Giá <span class="text-red-600">*</span></label>
                                    <div class="flex items-center">
                                        <input type="number" name="price" class="w-full border rounded-l-lg px-3 py-2 focus:ring-primary focus:border-primary" id="price" required>
                                        <span class="inline-block bg-gray-100 border border-l-0 rounded-r-lg px-3 py-2 text-gray-500">VND</span>
                                    </div>
                                    <div class="text-sm mt-1" id="priceError"></div>
                                </div>
                                <div>
                                    <label for="duration_minutes" class="block font-medium text-gray-700 mb-1">Thời lượng <span class="text-red-600">*</span></label>
                                    <div class="flex items-center">
                                        <input type="number" name="duration_minutes" class="w-full border rounded-l-lg px-3 py-2 focus:ring-primary focus:border-primary" id="duration_minutes" required>
                                        <span class="inline-block bg-gray-100 border border-l-0 rounded-r-lg px-3 py-2 text-gray-500">phút</span>
                                    </div>
                                    <div class="text-sm mt-1" id="durationError"></div>
                                </div>
                                <div>
                                    <label for="buffer_time_after_minutes" class="block font-medium text-gray-700 mb-1">Thời gian chờ sau</label>
                                    <div class="flex items-center">
                                        <input type="number" name="buffer_time_after_minutes" class="w-full border rounded-l-lg px-3 py-2 focus:ring-primary focus:border-primary" id="buffer_time_after_minutes" value="0">
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
                                    <label class="switch">
                                        <input type="checkbox" name="is_active" id="is_active" checked>
                                        <span class="slider"></span>
                                    </label>
                                </div>
                                <div class="flex items-center justify-between bg-gray-50 rounded-lg px-4 py-2">
                                    <div>
                                        <div class="font-semibold">Cho phép đặt online</div>
                                        <div class="text-xs text-gray-400">Cho phép khách hàng tự đặt lịch cho dịch vụ này qua website.</div>
                                    </div>
                                    <label class="switch">
                                        <input type="checkbox" name="bookable_online" id="bookable_online" checked>
                                        <span class="slider"></span>
                                    </label>
                                </div>
                                <div class="flex items-center justify-between bg-gray-50 rounded-lg px-4 py-2">
                                    <div>
                                        <div class="font-semibold">Yêu cầu tư vấn</div>
                                        <div class="text-xs text-gray-400">Yêu cầu khách hàng phải được tư vấn trước khi đặt dịch vụ.</div>
                                    </div>
                                    <label class="switch">
                                        <input type="checkbox" name="requires_consultation" id="requires_consultation">
                                        <span class="slider"></span>
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
                                <i data-lucide="save" class="w-5 h-5"></i> Lưu
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

        // Helper functions
        function setValid(input, errorDiv, msg) {
            if (!input || !errorDiv) return;
            input.classList.remove('border-red-500', 'focus:ring-red-500', 'border-gray-300', 'focus:ring-primary');
            input.classList.add('border-green-500', 'focus:ring-green-500');
            errorDiv.textContent = msg;
            errorDiv.style.color = 'green';
        }

        function setInvalid(input, errorDiv, msg) {
            if (!input || !errorDiv) return;
            input.classList.remove('border-green-500', 'focus:ring-green-500', 'border-gray-300', 'focus:ring-primary');
            input.classList.add('border-red-500', 'focus:ring-red-500');
            errorDiv.textContent = msg;
            errorDiv.style.color = 'red';
        }

        function setDefault(input, errorDiv) {
            if (!input || !errorDiv) return;
            input.classList.remove('border-red-500', 'focus:ring-red-500', 'border-green-500', 'focus:ring-green-500');
            input.classList.add('border-gray-300', 'focus:ring-primary');
            errorDiv.textContent = '';
        }

        function updateCharCount(input, counterId, maxLength) {
            const counter = document.getElementById(counterId);
            const currentLength = input.value.length;
            counter.textContent = currentLength + '/' + maxLength;
            
            if (currentLength > maxLength * 0.8) {
                counter.style.color = '#f59e0b';
            } else if (currentLength > maxLength) {
                counter.style.color = '#f44336';
            } else {
                counter.style.color = '#6b7280';
            }
        }

        function validateName(input) {
            if (!input) return false;
            
            const vietnameseNamePattern = /^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s]+$/;
            const value = input.value.trim();
            const errorDiv = document.getElementById('nameError');
            
            if (!errorDiv) return false;
            
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
            return true;
        }

        // Validate Description
        function validateDescription(input) {
            if (!input) return false;
            const errorDiv = document.getElementById('descriptionError');
            if (!errorDiv) return false;
            const value = input.value.trim();
            if (value.length < 20) {
                setInvalid(input, errorDiv, 'Mô tả phải có ít nhất 20 ký tự');
                return false;
            }
            if (value.length > 500) {
                setInvalid(input, errorDiv, 'Mô tả không được vượt quá 500 ký tự');
                return false;
            }
            setValid(input, errorDiv, 'Mô tả hợp lệ');
            return true;
        }

        // Validate Price
        function validatePrice(input) {
            if (!input) return false;
            const errorDiv = document.getElementById('priceError');
            if (!errorDiv) return false;
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

        // Validate Duration
        function validateDuration(input) {
            if (!input) return false;
            const errorDiv = document.getElementById('durationError');
            if (!errorDiv) return false;
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

        // Validate Buffer Time
        function validateBufferTime(input) {
            if (!input) return false;
            const errorDiv = document.getElementById('bufferError');
            if (!errorDiv) return false;
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

        // DataTransfer to accumulate files
        let dt = new DataTransfer();

        function handleImageUpload(input) {
            const files = input.files;
            const container = document.querySelector('.uploaded-imgs-container');
            const errorDiv = document.getElementById('imageError');
            let hasValid = false;
            let errorMsg = '';

            if (files.length === 0) {
                setDefault(input, errorDiv);
                return;
            }

            let filesProcessed = 0;
            for (let i = 0; i < files.length; i++) {
                const file = files[i];
                // Check file size (max 2MB)
                if (file.size > 2 * 1024 * 1024) {
                    errorMsg += `File ${file.name} vượt quá 2MB. `;
                    filesProcessed++;
                    continue;
                }
                // Check file type
                const validTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
                if (!validTypes.includes(file.type)) {
                    errorMsg += `File ${file.name} không phải là ảnh hợp lệ. `;
                    filesProcessed++;
                    continue;
                }
                // Check image dimensions
                const url = URL.createObjectURL(file);
                const img = new Image();
                img.onload = function() {
                    if (img.width < 200 || img.height < 200) {
                        errorMsg += `File ${file.name} nhỏ hơn 200x200px. `;
                        URL.revokeObjectURL(url);
                    } else {
                        hasValid = true;
                        dt.items.add(file); // accumulate file
                        const reader = new FileReader();
                        reader.onload = function(e) {
                            const previewDiv = document.createElement('div');
                            previewDiv.className = 'relative h-28 w-28 border-2 border-dashed border-gray-300 rounded-lg bg-gray-50 overflow-hidden flex items-center justify-center mr-2 mb-2';
                            const imgElem = document.createElement('img');
                            imgElem.src = e.target.result;
                            imgElem.className = 'w-full h-full object-cover';
                            previewDiv.appendChild(imgElem);
                            container.appendChild(previewDiv);
                        };
                        reader.readAsDataURL(file);
                        URL.revokeObjectURL(url);
                    }
                    filesProcessed++;
                    if (filesProcessed === files.length) {
                        // Set the input's files to the accumulated DataTransfer
                        input.files = dt.files;
                        if (hasValid) {
                            setValid(input, errorDiv, 'Ảnh đã được chọn');
                        } else {
                            setInvalid(input, errorDiv, errorMsg || 'Không có ảnh hợp lệ');
                        }
                    }
                };
                img.onerror = function() {
                    errorMsg += `File ${file.name} không phải là ảnh hợp lệ. `;
                    URL.revokeObjectURL(url);
                    filesProcessed++;
                    if (filesProcessed === files.length) {
                        input.files = dt.files;
                        if (hasValid) {
                            setValid(input, errorDiv, 'Ảnh đã được chọn');
                        } else {
                            setInvalid(input, errorDiv, errorMsg || 'Không có ảnh hợp lệ');
                        }
                    }
                };
                img.src = url;
            }
        }

        // AJAX check duplicate service name
        function checkServiceNameDuplicate(name, callback) {
            $.ajax({
                url: contextPath + '/manager/service',
                type: 'GET',
                data: { 
                    service: 'check-duplicate-name', 
                    name: name 
                },
                dataType: 'json',
                success: function(response) {
                    callback(!response.valid, response.message);
                },
                error: function() {
                    callback(false, 'Không thể kiểm tra tên. Vui lòng thử lại.');
                }
            });
        }

        // Form validation and submission
        function validateForm() {
            const nameValid = validateName(document.getElementById('name'));
            const descValid = validateDescription(document.getElementById('description'));
            const priceValid = validatePrice(document.getElementById('price'));
            const durationValid = validateDuration(document.getElementById('duration_minutes'));
            const bufferValid = validateBufferTime(document.getElementById('buffer_time_after_minutes'));
            
            return nameValid && descValid && priceValid && durationValid && bufferValid;
        }

        // Real-time validation event bindings
        $(document).ready(function() {
            const nameInput = document.getElementById('name');
            const descInput = document.getElementById('description');

            // Initialize character counts
            updateCharCount(nameInput, 'nameCharCount', 200);
            updateCharCount(descInput, 'descCharCount', 500);

            // Real-time name validation
            $('#name').on('input', function() {
                const input = this;
                const errorDiv = document.getElementById('nameError');
                updateCharCount(this, 'nameCharCount', 200);
                if (validateName(this)) {
                    checkServiceNameDuplicate(this.value.trim(), function(isDuplicate, msg) {
                        if (isDuplicate) {
                            setInvalid(input, errorDiv, msg || 'Tên này đã tồn tại trong hệ thống');
                        } else {
                            setValid(input, errorDiv, 'Tên hợp lệ');
                        }
                    });
                }
            });

            $('#name').on('blur', function() {
                const input = this;
                const errorDiv = document.getElementById('nameError');
                this.value = this.value.replace(/\s+/g, ' ').trim();
                updateCharCount(this, 'nameCharCount', 200);
                if (validateName(this)) {
                    checkServiceNameDuplicate(this.value.trim(), function(isDuplicate, msg) {
                        if (isDuplicate) {
                            setInvalid(input, errorDiv, msg || 'Tên này đã tồn tại trong hệ thống');
                        } else {
                            setValid(input, errorDiv, 'Tên hợp lệ');
                        }
                    });
                }
            });

            // Description
            $('#description').on('input', function() {
                updateCharCount(this, 'descCharCount', 500);
                validateDescription(this);
            });

            $('#description').on('blur', function() {
                this.value = this.value.replace(/\s+/g, ' ').trim();
                updateCharCount(this, 'descCharCount', 500);
                validateDescription(this);
            });

            // Price
            $('#price').on('input', function() {
                validatePrice(this);
            });
            $('#price').on('blur', function() {
                validatePrice(this);
            });

            // Duration
            $('#duration_minutes').on('input', function() {
                validateDuration(this);
            });
            $('#duration_minutes').on('blur', function() {
                validateDuration(this);
            });

            // Buffer Time
            $('#buffer_time_after_minutes').on('input', function() {
                validateBufferTime(this);
            });
            $('#buffer_time_after_minutes').on('blur', function() {
                validateBufferTime(this);
            });

            if ($('#upload-file-multiple')) {
                $('#upload-file-multiple').on('change', function () {
                    handleImageUpload(this);
                });
            }

            // Form submission
            $('#service-form').on('submit', function(e) {
                e.preventDefault();
                let nameValue = $('#name').val();
                nameValue = nameValue.replace(/\s+/g, ' ').trim();
                $('#name').val(nameValue);
                const nameValid = validateName(document.getElementById('name'));
                const descValid = validateDescription(document.getElementById('description'));
                const priceValid = validatePrice(document.getElementById('price'));
                const durationValid = validateDuration(document.getElementById('duration_minutes'));
                const bufferValid = validateBufferTime(document.getElementById('buffer_time_after_minutes'));
                if (nameValid && descValid && priceValid && durationValid && bufferValid) {
                    checkServiceNameDuplicate(nameValue, function(isDuplicate, msg) {
                        if (isDuplicate) {
                            setInvalid(document.getElementById('name'), document.getElementById('nameError'), msg || 'Tên này đã tồn tại trong hệ thống');
                            return;
                        } else {
                            setValid(document.getElementById('name'), document.getElementById('nameError'), 'Tên hợp lệ');
                            e.target.submit();
                        }
                    });
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
        #nameError, #descriptionError, #priceError, #durationError, #bufferError {
            min-height: 20px;
            margin-top: 4px;
            font-size: 0.875rem;
        }
        #nameError:empty, #descriptionError:empty, #priceError:empty, #durationError:empty, #bufferError:empty {
            display: none;
        }
        .border-red-500 {
            border-color: #ef4444 !important;
        }
        .border-green-500 {
            border-color: #22c55e !important;
        }
        .switch {
  position: relative;
  display: inline-block;
  width: 48px;
  height: 28px;
}
.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}
.slider {
  position: absolute;
  cursor: pointer;
  top: 0; left: 0; right: 0; bottom: 0;
  background-color: #ccc;
  transition: .4s;
  border-radius: 34px;
}
.slider:before {
  position: absolute;
  content: "";
  height: 22px;
  width: 22px;
  left: 3px;
  bottom: 3px;
  background-color: white;
  transition: .4s;
  border-radius: 50%;
  box-shadow: 0 1px 4px rgba(0,0,0,0.2);
}
.switch input:checked + .slider {
  background-color: #D4AF37;
}
.switch input:focus + .slider {
  box-shadow: 0 0 1px #D4AF37;
}
.switch input:checked + .slider:before {
  transform: translateX(20px);
        }
    </style>
</body>
</html>