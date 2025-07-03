<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en" data-theme="light">

        <head>
            <meta charset="UTF-8">
            <title>Add Service</title>
            <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
            <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
        </head>

        <body>

            <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
            <jsp:include page="/WEB-INF/view/common/header.jsp" />

            <div class="dashboard-main-body">
                <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                    <h6 class="fw-semibold mb-0">Thêm mới dịch vụ</h6>
                    <ul class="d-flex align-items-center gap-2">
                        <li class="fw-medium">
                            <a href="service?service=list-all&page=${page}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}${not empty serviceTypeId ? '&serviceTypeId='.concat(serviceTypeId) : ''}" class="d-flex align-items-center gap-1 hover-text-primary">
                                <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                                Trở lại danh sách dịch vụ
                            </a>
                        </li>
                        <li>-</li>
                        <li class="fw-medium">Thêm mới dịch vụ</li>
                    </ul>
                </div>

                <div class="card h-100 p-0 radius-12">
                    <div class="card-body p-24">
                        <div class="row justify-content-center">
                            <div class="col-xxl-8 col-xl-10">
                                <form action="service" method="post" enctype="multipart/form-data" class="border p-24 radius-12" id="service-form">
                                    <input type="hidden" name="service" value="insert" />

                                    <!-- =================================== Thông tin cơ bản =================================== -->
                                    <div class="mb-32">
                                        <div class="d-flex align-items-center gap-3 mb-20">
                                            <div class="bg-primary-50 d-flex align-items-center justify-content-center w-40-px h-40-px radius-12">
                                                <iconify-icon icon="solar:document-text-outline" class="text-primary text-xl"></iconify-icon>
                                            </div>
                                            <h6 class="fw-semibold text-primary-light mb-0">Thông tin cơ bản</h6>
                                        </div>
                                        <div class="mb-20">
                                            <label for="service_type_id" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                Loại dịch vụ <span class="text-danger-600">*</span>
                                            </label>
                                            <select name="service_type_id" id="service_type_id" class="form-control radius-8" required>
                                                <c:forEach var="type" items="${serviceTypes}">
                                                    <option value="${type.serviceTypeId}">${type.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="mb-20">
                                            <label for="name" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                Tên dịch vụ <span class="text-danger-600">*</span>
                                            </label>
                                            <input type="text" name="name" class="form-control radius-8" id="name"
                                                placeholder="Nhập tên dịch vụ" required />
                                            <div class="d-flex justify-content-between">
                                                <div class="invalid-feedback" id="nameError"></div>
                                                <small class="text-muted ms-auto" id="nameCharCount">0/200</small>
                                            </div>
                                        </div>
                                        <div class="mb-20">
                                            <label for="description" class="form-label fw-semibold text-primary-light text-sm mb-8">Mô tả</label>
                                            <textarea name="description" id="description"
                                                class="form-control radius-8" placeholder="Nhập mô tả..." rows="7"></textarea>
                                            <div class="d-flex justify-content-between">
                                                <div class="invalid-feedback" id="descriptionError"></div>
                                                <small class="text-muted ms-auto" id="descCharCount">0/500</small>
                                            </div>
                                            
                                        </div>
                                    </div>
                                    
                                    <!-- =================================== Giá & Thời gian =================================== -->
                                    <div class="mb-32">
                                        <div class="d-flex align-items-center gap-3 mb-20">
                                            <div class="bg-success-50 d-flex align-items-center justify-content-center w-40-px h-40-px radius-12">
                                                <iconify-icon icon="solar:wallet-money-outline" class="text-success text-xl"></iconify-icon>
                                            </div>
                                            <h6 class="fw-semibold text-primary-light mb-0">Giá & Thời gian</h6>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="mb-20">
                                                    <label for="price" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                        Giá <span class="text-danger-600">*</span>
                                                    </label>
                                                    <div class="input-group">
                                                        <input type="number" name="price" class="form-control radius-8-start" id="price" required>
                                                        <span class="input-group-text">VND</span>
                                                    </div>
                                                    <div class="invalid-feedback" id="priceError"></div>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="mb-20">
                                                    <label for="duration_minutes" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                        Thời lượng <span class="text-danger-600">*</span>
                                                    </label>
                                                    <div class="input-group">
                                                        <input type="number" name="duration_minutes" class="form-control radius-8-start" id="duration_minutes" required>
                                                        <span class="input-group-text">phút</span>
                                                    </div>
                                                    <div class="invalid-feedback" id="durationError"></div>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="mb-20">
                                                    <label for="buffer_time_after_minutes" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                        Thời gian chờ sau
                                                    </label>
                                                    <div class="input-group">
                                                        <input type="number" name="buffer_time_after_minutes" class="form-control radius-8-start" id="buffer_time_after_minutes" value="0">
                                                        <span class="input-group-text">phút</span>
                                                    </div>
                                                    <div class="invalid-feedback" id="bufferError"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- =================================== Hình ảnh dịch vụ =================================== -->
                                    <div class="mb-32">
                                        <div class="d-flex align-items-center gap-3 mb-20">
                                            <div class="bg-info-50 d-flex align-items-center justify-content-center w-40-px h-40-px radius-12">
                                                <iconify-icon icon="solar:gallery-wide-outline" class="text-info text-xl"></iconify-icon>
                                            </div>
                                            <h6 class="fw-semibold text-primary-light mb-0">Hình ảnh dịch vụ</h6>
                                        </div>
                                        <div class="upload-image-wrapper d-flex align-items-center gap-3 flex-wrap">
                                            <div class="uploaded-imgs-container d-flex gap-3 flex-wrap"></div>
                                            <label class="upload-file-multiple h-120-px w-120-px border input-form-light radius-8 overflow-hidden border-dashed bg-neutral-50 bg-hover-neutral-200 d-flex align-items-center flex-column justify-content-center gap-1" for="upload-file-multiple">
                                                <iconify-icon icon="solar:camera-outline" class="text-xl text-secondary-light"></iconify-icon>
                                                <span class="fw-semibold text-secondary-light">Tải lên</span>
                                                <input id="upload-file-multiple" type="file" name="images" multiple hidden>
                                            </label>
                                        </div>
                                        <div class="invalid-feedback" id="imageError" style="margin-top: 4px; font-size: 0.95em; min-height: 18px; color: red; display: block;"></div>
                                    </div>
                                    
                                    <!-- =================================== Cài đặt =================================== -->
                                    <div class="mb-32">
                                        <div class="d-flex align-items-center gap-3 mb-20">
                                            <div class="bg-warning-50 d-flex align-items-center justify-content-center w-40-px h-40-px radius-12">
                                                <iconify-icon icon="solar:settings-outline" class="text-warning text-xl"></iconify-icon>
                                            </div>
                                            <h6 class="fw-semibold text-primary-light mb-0">Cài đặt</h6>
                                        </div>
                                        <div class="list-group">
                                            <div class="list-group-item d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h6 class="mb-0">Active</h6>
                                                    <small class="text-muted d-block mt-1">Dịch vụ sẽ hiển thị và có thể được đặt lịch.</small>
                                                </div>
                                                <div class="form-switch switch-primary">
                                                    <input class="form-check-input" type="checkbox" role="switch" name="is_active" id="is_active" checked>
                                                </div>
                                            </div>
                                            <div class="list-group-item d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h6 class="mb-0">Cho phép đặt online</h6>
                                                    <small class="text-muted d-block mt-1">Cho phép khách hàng tự đặt lịch cho dịch vụ này qua website.</small>
                                                </div>
                                                <div class="form-switch switch-primary">
                                                    <input class="form-check-input" type="checkbox" role="switch" name="bookable_online" id="bookable_online" checked>
                                                </div>
                                            </div>
                                            <div class="list-group-item d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h6 class="mb-0">Yêu cầu tư vấn</h6>
                                                    <small class="text-muted d-block mt-1">Yêu cầu khách hàng phải được tư vấn trước khi đặt dịch vụ.</small>
                                                </div>
                                                <div class="form-switch switch-primary">
                                                    <input class="form-check-input" type="checkbox" role="switch" name="requires_consultation" id="requires_consultation">
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- =================================== Nút bấm =================================== -->
                                    <div class="d-flex align-items-center justify-content-end gap-3">
                                        <a href="service?service=list-all&page=${page}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}${not empty serviceTypeId ? '&serviceTypeId='.concat(serviceTypeId) : ''}"
                                            class="btn btn-outline-danger border border-danger-600 px-40 py-11 radius-8">Hủy</a>
                                        <button type="submit"
                                            class="btn btn-primary border border-primary-600 text-md px-40 py-12 radius-8">Lưu</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
            <script>
                var contextPath = '${pageContext.request.contextPath}';
                // ================================================ Upload Multiple image js Start here ================================================
                const fileInputMultiple = document.getElementById("upload-file-multiple");
                const uploadedImgsContainer = document.querySelector(".uploaded-imgs-container");
                let selectedFiles = new DataTransfer(); // To manage FileList object

                fileInputMultiple.addEventListener("change", (e) => {
                    const files = Array.from(e.target.files);
                    const imageErrorDiv = document.getElementById('imageError');
                    imageErrorDiv.textContent = "";
                    let errorMessages = [];
                    let checkedCount = 0;
                    let validFiles = [];

                    // Lấy danh sách tên file đã có trong selectedFiles
                    const existingFileNames = Array.from(selectedFiles.files).map(f => f.name);

                    if (files.length === 0) {
                        imageErrorDiv.textContent = "";
                        return;
                    }

                    files.forEach((file, idx) => {
                        // Nếu file đã tồn tại trong selectedFiles thì bỏ qua
                        if (existingFileNames.includes(file.name)) {
                            checkDone();
                            return;
                        }
                        // Validate file type
                        if (!['image/jpeg', 'image/png', 'image/gif'].includes(file.type)) {
                            errorMessages.push(`\"${file.name}\": Chỉ chấp nhận JPEG, PNG hoặc GIF.`);
                            checkDone();
                            return;
                        }
                        // Validate file size (2MB)
                        if (file.size > 2 * 1024 * 1024) {
                            errorMessages.push(`\"${file.name}\": Kích thước vượt quá 2MB.`);
                            checkDone();
                            return;
                        }
                        // Validate dimensions
                        const reader = new FileReader();
                        reader.onload = function (event) {
                            const img = new Image();
                            img.onload = function () {
                                if (img.width < 150 || img.height < 150) {
                                    errorMessages.push(`\"${file.name}\": Kích thước phải lớn hơn 150x150px.`);
                                } else {
                                    validFiles.push(file);
                                    const src = URL.createObjectURL(file);

                                    const imgContainer = document.createElement('div');
                                    imgContainer.classList.add('position-relative', 'h-120-px', 'w-120-px', 'border', 'input-form-light', 'radius-8', 'overflow-hidden', 'border-dashed', 'bg-neutral-50');

                                    const removeButton = document.createElement('button');
                                    removeButton.type = 'button';
                                    removeButton.classList.add('uploaded-img__remove', 'position-absolute', 'top-0', 'end-0', 'z-1', 'text-2xxl', 'line-height-1', 'me-8', 'mt-8', 'd-flex');
                                    removeButton.innerHTML = '<iconify-icon icon="radix-icons:cross-2" class="text-xl text-danger-600"></iconify-icon>';

                                    const imagePreview = document.createElement('img');
                                    imagePreview.classList.add('w-100', 'h-100', 'object-fit-cover');
                                    imagePreview.src = src;

                                    imgContainer.dataset.fileName = file.name;
                                    imgContainer.appendChild(removeButton);
                                    imgContainer.appendChild(imagePreview);
                                    uploadedImgsContainer.appendChild(imgContainer);

                                    removeButton.addEventListener('click', () => {
                                        const newFiles = new DataTransfer();
                                        const fileName = imgContainer.dataset.fileName;
                                        Array.from(selectedFiles.files).forEach(f => {
                                            if (f.name !== fileName) {
                                                newFiles.items.add(f);
                                            }
                                        });
                                        selectedFiles = newFiles;
                                        fileInputMultiple.files = selectedFiles.files;
                                        URL.revokeObjectURL(src);
                                        imgContainer.remove();
                                        if (selectedFiles.files.length === 0) {
                                            imageErrorDiv.textContent = "";
                                        }
                                    });
                                }
                                checkDone();
                            };
                            img.onerror = function () {
                                errorMessages.push(`\"${file.name}\": File không phải là ảnh hợp lệ.`);
                                checkDone();
                            };
                            img.src = event.target.result;
                        };
                        reader.readAsDataURL(file);
                    });

                    function checkDone() {
                        checkedCount++;
                        if (checkedCount === files.length) {
                            // Thêm file hợp lệ vào DataTransfer
                            validFiles.forEach(f => selectedFiles.items.add(f));
                            fileInputMultiple.files = selectedFiles.files;
                            if (errorMessages.length > 0) {
                                imageErrorDiv.textContent = errorMessages.join(' ');
                                imageErrorDiv.style.color = 'red';
                            } else if (validFiles.length > 0) {
                                imageErrorDiv.textContent = "Tất cả ảnh hợp lệ";
                                imageErrorDiv.style.color = 'green';
                            } else {
                                imageErrorDiv.textContent = "";
                            }
                        }
                    }
                });

                // Clear selected files when form is reset
                document.querySelector('form').addEventListener('reset', () => {
                    selectedFiles = new DataTransfer();
                    fileInputMultiple.files = selectedFiles.files;
                    uploadedImgsContainer.innerHTML = '';
                });
                // ================================================ Upload Multiple image js End here  ================================================
                

                //REAL-Time Validation
                let isSubmitting = false;
                let nameCheckTimeout = null;
                let isNameDuplicateError = false;

                // Regex cho tên dịch vụ: chỉ cho phép chữ cái (có dấu), khoảng trắng
                const vietnameseNamePattern = /^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s]+$/;
                // Regex cho mô tả: cho phép chữ, số, dấu câu, khoảng trắng
                const vietnameseDescPattern = /^[a-zA-Z0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s.,\-()!?:;"'\n\r]+$/;

                function validateName(input) {
                    const value = input.value.trim();
                    const errorDiv = document.getElementById('nameError');
                    if (value === '') {
                        setInvalid('Tên dịch vụ không được để trống');
                        return false;
                    }
                    if (value.length < 2) {
                        setInvalid('Tên dịch vụ phải có ít nhất 2 ký tự');
                        return false;
                    }
                    if (value.length > 200) {
                        setInvalid('Tên dịch vụ không được vượt quá 200 ký tự');
                        return false;
                    }
                    if (!vietnameseNamePattern.test(value)) {
                        setInvalid('Tên chỉ được chứa chữ cái, khoảng trắng (cho phép tiếng Việt có dấu)');
                        return false;
                    }
                    if (!isNameDuplicateError) setValid('Tên hợp lệ');
                    return true;
                    function setInvalid(msg) {
                        input.classList.remove('is-valid');
                        input.classList.add('is-invalid');
                        errorDiv.textContent = msg;
                        errorDiv.style.color = 'red';
                    }
                    function setValid(msg) {
                        input.classList.remove('is-invalid');
                        input.classList.add('is-valid');
                        errorDiv.textContent = msg;
                        errorDiv.style.color = 'green';
                    }
                }

                function validateDescription(input) {
                    const value = input.value.trim();
                    const errorDiv = document.getElementById('descriptionError');
                    if (value.length === 0) {
                        setInvalid('Mô tả dịch vụ không được để trống');
                        return false;
                    }
                    if (value.length > 500) {
                        setInvalid('Mô tả dịch vụ không được vượt quá 500 ký tự');
                        return false;
                    }
                    if (!vietnameseDescPattern.test(value)) {
                        setInvalid('Mô tả chỉ được chứa chữ, số, dấu câu, khoảng trắng (cho phép tiếng Việt có dấu)');
                        return false;
                    }
                    setValid('Mô tả hợp lệ');
                    return true;
                    function setInvalid(msg) {
                        input.classList.remove('is-valid');
                        input.classList.add('is-invalid');
                        errorDiv.textContent = msg;
                        errorDiv.style.color = 'red';
                    }
                    function setValid(msg) {
                        input.classList.remove('is-invalid');
                        input.classList.add('is-valid');
                        errorDiv.textContent = msg;
                        errorDiv.style.color = 'green';
                    }
                }

                function checkNameDuplicate(name, callback) {
                    $.ajax({
                        url: contextPath + '/service',
                        type: 'GET',
                        data: { service: 'check-duplicate-name', name: name },
                        dataType: 'json',
                        success: function (response) {
                            callback(!response.valid, response.message);
                        },
                        error: function () {
                            callback(false, 'Không thể kiểm tra tên. Vui lòng thử lại.');
                        }
                    });
                }

                function validatePrice(input) {
                    const value = parseFloat(input.value);
                    const errorDiv = document.getElementById('priceError');
                    if (isNaN(value) || value <= 0) {
                        input.classList.add('is-invalid');
                        input.classList.remove('is-valid');
                        errorDiv.textContent = 'Giá phải là số lớn hơn 0';
                        return false;
                    }
                    input.classList.remove('is-invalid');
                    input.classList.add('is-valid');
                    errorDiv.textContent = '';
                    return true;
                }

                function validateDuration(input) {
                    const value = parseInt(input.value);
                    const errorDiv = document.getElementById('durationError');
                    if (isNaN(value) || value < 5 || value > 600) {
                        input.classList.add('is-invalid');
                        input.classList.remove('is-valid');
                        errorDiv.textContent = 'Thời lượng phải từ 5 đến 600 phút';
                        return false;
                    }
                    input.classList.remove('is-invalid');
                    input.classList.add('is-valid');
                    errorDiv.textContent = '';
                    return true;
                }

                function validateBuffer(input) {
                    const value = parseInt(input.value);
                    const errorDiv = document.getElementById('bufferError');
                    if (isNaN(value) || value < 0) {
                        input.classList.add('is-invalid');
                        input.classList.remove('is-valid');
                        errorDiv.textContent = 'Thời gian chờ phải >= 0';
                        return false;
                    }
                    input.classList.remove('is-invalid');
                    input.classList.add('is-valid');
                    errorDiv.textContent = '';
                    return true;
                }

                $(document).ready(function () {
                    $('#name').on('input', function () {
                        $('#nameCharCount').text(this.value.length + '/200');
                    });

                    $('#description').on('input', function () {
                        $('#descCharCount').text(this.value.length + '/500');
                    });

                    $('#nameCharCount').text($('#name').val().length + '/200');
                    $('#descCharCount').text($('#description').val().length + '/500');

                    $('#name').on('input', function () {
                        isNameDuplicateError = false;
                        clearTimeout(nameCheckTimeout);
                        let value = $(this).val();
                        const errorDiv = $('#nameError');

                        if (value === '') {
                            setInvalid('Tên dịch vụ không được để trống');
                            return;
                        }
                        if (value.length < 2) {
                            setInvalid('Tên dịch vụ phải có ít nhất 2 ký tự');
                            return;
                        }
                        if (value.length > 200) {
                            setInvalid('Tên dịch vụ không được vượt quá 200 ký tự');
                            return;
                        }
                        if (!vietnameseNamePattern.test(value)) {
                            setInvalid('Tên chỉ được chứa chữ cái, khoảng trắng (cho phép tiếng Việt có dấu)');
                            return;
                        }
                        if (!isNameDuplicateError) setValid('Tên hợp lệ');
                        nameCheckTimeout = setTimeout(() => {
                            checkNameDuplicate(value, function (isDuplicate, msg) {
                                if (isSubmitting) return;
                                if (isDuplicate) {
                                    isNameDuplicateError = true;
                                    setInvalid(msg || 'Tên này đã tồn tại trong hệ thống');
                                } else {
                                    isNameDuplicateError = false;
                                    setValid('Tên hợp lệ');
                                }
                            });
                        }, 400);

                        function setInvalid(msg) {
                            $('#name').removeClass('is-valid').addClass('is-invalid');
                            errorDiv.text(msg).css('color', 'red');
                        }
                        function setValid(msg) {
                            if (!isNameDuplicateError) {
                                $('#name').removeClass('is-invalid').addClass('is-valid');
                                errorDiv.text(msg).css('color', 'green');
                            }
                        }
                    });

                    $('#name').on('blur', function () {
                        let value = $(this).val();
                        value = value.replace(/\s+/g, ' ').trim();
                        $(this).val(value).trigger('input');
                    });

                    $('#description').on('input', function () {
                        validateDescription(this);
                    });
                    $('#description').on('blur', function () {
                        this.value = this.value.replace(/\s+/g, ' ').trim();
                        validateDescription(this);
                    });

                    $('#price').on('input blur', function () {
                        validatePrice(this);
                    });
                    $('#duration_minutes').on('input blur', function () {
                        validateDuration(this);
                    });
                    $('#buffer_time_after_minutes').on('input blur', function () {
                        validateBuffer(this);
                    });

                    $('#service-form').on('submit', function (e) {
                        isSubmitting = true;
                        let nameValue = $('#name').val().replace(/\s+/g, ' ').trim();
                        $('#name').val(nameValue);

                        const nameValid = validateName(document.getElementById('name'));
                        const descValid = validateDescription(document.getElementById('description'));
                        const priceValid = validatePrice(document.getElementById('price'));
                        const durationValid = validateDuration(document.getElementById('duration_minutes'));
                        const bufferValid = validateBuffer(document.getElementById('buffer_time_after_minutes'));

                        if (nameValid && descValid && priceValid && durationValid && bufferValid) {
                            checkNameDuplicate(nameValue, function (isDuplicate, msg) {
                                if (isDuplicate) {
                                    isNameDuplicateError = true;
                                    $('#name').removeClass('is-valid').addClass('is-invalid');
                                    $('#nameError').text(msg || 'Tên này đã tồn tại trong hệ thống').css('color', 'red');
                                    isSubmitting = false;
                                    e.preventDefault();
                                    return;
                                } else {
                                    isNameDuplicateError = false;
                                    isSubmitting = false;
                                    // Cho phép submit
                                    $('#service-form')[0].submit();
                                }
                            });
                            e.preventDefault(); // Đợi AJAX xong mới submit
                        } else {
                            isSubmitting = false;
                            e.preventDefault();
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