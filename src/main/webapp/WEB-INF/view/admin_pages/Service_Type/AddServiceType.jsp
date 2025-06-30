<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en" data-theme="light">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Add Service Type</title>
            <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
            <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
            <style>
                .switch {
                    position: relative;
                    display: inline-block;
                    width: 48px;
                    height: 24px;
                    vertical-align: middle;
                }

                .switch input {
                    display: none;
                }

                .slider {
                    position: absolute;
                    cursor: pointer;
                    top: 0;
                    left: 0;
                    right: 0;
                    bottom: 0;
                    background-color: #ccc;
                    transition: .4s;
                    border-radius: 24px;
                }

                .slider:before {
                    position: absolute;
                    content: "";
                    height: 18px;
                    width: 18px;
                    left: 3px;
                    bottom: 3px;
                    background-color: white;
                    transition: .4s;
                    border-radius: 50%;
                }

                input:checked+.slider {
                    background-color: #2196F3;
                }

                input:checked+.slider:before {
                    transform: translateX(24px);
                }

                .invalid-feedback {
                    color: red;
                    display: block;
                }
            </style>
        </head>

        <body>

            <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
            <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

            <div class="dashboard-main-body">
                <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                    <h6 class="fw-semibold mb-0">Add Service Type</h6>
                    <ul class="d-flex align-items-center gap-2">
                        <li class="fw-medium">
                            <a href="servicetype" class="d-flex align-items-center gap-1 hover-text-primary">
                                <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                                Back to List
                            </a>
                        </li>
                        <li>-</li>
                        <li class="fw-medium">Create New Service Type</li>
                    </ul>
                </div>

                <div class="card h-100 p-0 radius-12">
                    <div class="card-body p-24">
                        <div class="row justify-content-center">
                            <div class="col-xxl-6 col-xl-8 col-lg-10">
                                <div class="card border">
                                    <div class="card-body">
                                        <form action="servicetype" method="post" enctype="multipart/form-data"
                                            id="serviceTypeForm" novalidate>
                                            <input type="hidden" name="service" value="insert" />

                                            <!-- Name -->
                                            <div class="mb-20">
                                                <label for="name"
                                                    class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                    Service Type Name <span class="text-danger-600">*</span>
                                                </label>
                                                <input type="text" name="name" class="form-control radius-8" id="name"
                                                    placeholder="Enter service type name" required maxlength="200"
                                                    data-bs-toggle="tooltip" data-bs-placement="right"
                                                    title="Tên không được để trống, tối đa 200 ký tự, không chứa ký tự đặc biệt, cho phép tiếng Việt, không trùng tên đã có." />
                                                <div class="invalid-feedback" id="nameError"></div>
                                            </div>

                                            <!-- Description -->
                                            <div class="mb-20">
                                                <label for="description"
                                                    class="form-label fw-semibold text-primary-light text-sm mb-8">Mô tả
                                                    <span class="text-danger-600">*</span></label>
                                                <textarea name="description" id="description"
                                                    class="form-control radius-8" placeholder="Nhập mô tả..." rows="7"
                                                    oninput="validateDescription(this)"></textarea>
                                                <div class="invalid-feedback" id="descriptionError"></div>
                                                <small class="text-muted">Tối thiểu 20 ký tự, tối đa 500 ký tự</small>
                                            </div>

                                            <!-- Image -->
                                            <div class="mb-20">
                                                <label for="image"
                                                    class="form-label fw-semibold text-primary-light text-sm mb-8">Hình
                                                    Ảnh</label>
                                                <div class="d-flex gap-3 align-items-center">
                                                    <input type="file" name="image" class="form-control radius-8"
                                                        id="image" accept="image/jpeg,image/png,image/gif"
                                                        onchange="validateImageAsync(this);">
                                                    <div id="imagePreview" class="d-none">
                                                        <img src="" alt="Preview" class="w-100-px h-100-px rounded"
                                                            id="previewImg" onclick="showImageModal(this.src)"
                                                            style="cursor: pointer;">
                                                    </div>
                                                </div>
                                                <div class="invalid-feedback" id="imageError"></div>
                                                <small class="text-danger" id="imageSizeHint"
                                                    style="display:none;">Không được upload ảnh quá 2MB.</small>
                                                <small class="text-muted">
                                                    Chấp nhận: JPG, PNG, GIF. Kích thước tối đa: 2MB. Kích thước tối
                                                    thiểu: 200x200px
                                                </small>
                                            </div>

                                            <!-- Status -->
                                            <div class="mb-20">
                                                <label
                                                    class="form-label fw-semibold text-primary-light text-sm mb-8 d-block">Trạng
                                                    thái</label>
                                                <label class="switch">
                                                    <input type="checkbox" name="is_active" id="is_active" checked>
                                                    <span class="slider"></span>
                                                </label>
                                                <span class="ms-2">Đang hoạt động</span>
                                            </div>

                                            <!-- Action Buttons -->
                                            <div class="d-flex align-items-center justify-content-center gap-3">
                                                <a href="servicetype?service=list-all&page=${page}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}"
                                                    class="btn btn-outline-danger border border-danger-600 px-56 py-11 radius-8">Cancel</a>
                                                <button type="submit"
                                                    class="btn btn-primary border border-primary-600 text-md px-56 py-12 radius-8">Save</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal hiển thị ảnh lớn -->
            <div id="imageModal"
                style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100vw; height:100vh; background:rgba(0,0,0,0.8); align-items:center; justify-content:center;">
                <img id="modalImg" src=""
                    style="max-width:90vw; max-height:90vh; border:4px solid #fff; border-radius:8px;">
            </div>

            <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
            <script>
                var contextPath = "${pageContext.request.contextPath}";

                const vietnameseDescPattern = /^[a-zA-Z0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s.,\-()!?:;"'\n\r]+$/;

                let isSubmitting = false;
                let nameCheckTimeout = null;
                let isNameDuplicateError = false;

                // Validation functions
                function validateDescription(input) {
                    const descriptionError = document.getElementById('descriptionError');
                    let value = input.value.trim();
                    if (value.length < 20) {
                        descriptionError.textContent = 'Mô tả phải có ít nhất 20 ký tự';
                        descriptionError.style.color = 'red';
                        input.classList.add('is-invalid');
                        input.classList.remove('is-valid');
                        return false;
                    }
                    if (value.length > 500) {
                        descriptionError.textContent = 'Mô tả không được vượt quá 500 ký tự';
                        descriptionError.style.color = 'red';
                        input.classList.add('is-invalid');
                        input.classList.remove('is-valid');
                        return false;
                    }
                    descriptionError.textContent = 'Mô tả hợp lệ';
                    descriptionError.style.color = 'green';
                    input.classList.remove('is-invalid');
                    input.classList.add('is-valid');
                    return true;
                }

                function previewImage(input) {
                    const preview = document.getElementById('imagePreview');
                    const previewImg = document.getElementById('previewImg');
                    if (input.files && input.files[0]) {
                        const reader = new FileReader();
                        reader.onload = function (e) {
                            previewImg.src = e.target.result;
                            preview.classList.remove('d-none');
                        }
                        reader.readAsDataURL(input.files[0]);
                    } else {
                        preview.classList.add('d-none');
                    }
                }

                function showImageModal(src) {
                    const modal = document.getElementById('imageModal');
                    const modalImg = document.getElementById('modalImg');
                    modal.style.display = 'flex';
                    modalImg.src = src;
                }

                // Close modal when clicking outside the image
                document.getElementById('imageModal').onclick = function () {
                    this.style.display = 'none';
                };

                // Thêm hàm validateImageAsync
                async function validateImageAsync(input) {
                    return new Promise((resolve) => {
                        const imageError = document.getElementById('imageError');
                        const imageSizeHint = document.getElementById('imageSizeHint');
                        const file = input.files[0];

                        if (!file) {
                            // Nếu không có file mới, coi như hợp lệ
                            resolve(true);
                            return;
                        }

                        // Check file size
                        if (file.size > 2 * 1024 * 1024) {
                            imageError.textContent = 'Không được upload ảnh quá 2MB.';
                            imageError.style.display = 'block';
                            imageError.style.color = 'red';
                            input.classList.add('is-invalid');
                            resolve(false);
                            return;
                        }

                        // Check file type
                        const validTypes = ['image/jpeg', 'image/png', 'image/gif'];
                        if (!validTypes.includes(file.type)) {
                            imageError.textContent = 'Chỉ chấp nhận file JPG, PNG hoặc GIF.';
                            imageError.style.display = 'block';
                            imageError.style.color = 'red';
                            input.classList.add('is-invalid');
                            resolve(false);
                            return;
                        }

                        // Check image dimensions
                        const img = new Image();
                        img.onload = function () {
                            if (this.width < 200 || this.height < 200) {
                                imageError.textContent = 'Kích thước ảnh phải tối thiểu 200x200px. Ảnh bạn chọn là ' + this.width + 'x' + this.height + 'px.';
                                imageError.style.display = 'block';
                                imageError.style.color = 'red';
                                input.classList.add('is-invalid');
                                resolve(false);
                                return;
                            }
                            // Nếu hợp lệ
                            imageError.textContent = '';
                            imageError.style.display = 'none';
                            input.classList.remove('is-invalid');
                            input.classList.add('is-valid');
                            previewImage(input);
                            resolve(true);
                        };
                        img.onerror = () => {
                            imageError.textContent = 'Ảnh không hợp lệ hoặc bị lỗi';
                            imageError.style.color = 'red';
                            imageError.style.display = 'block';
                            input.classList.add('is-invalid');
                            resolve(false);
                        };
                        img.src = URL.createObjectURL(file);
                    });
                }

                function validateName(input) {
                    const vietnameseNamePattern = /^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s]+$/;
                    const value = input.value.trim();
                    const errorDiv = document.getElementById('nameError');

                    if (value === '') {
                        input.classList.remove('is-valid');
                        input.classList.add('is-invalid');
                        errorDiv.textContent = 'Tên không được để trống';
                        errorDiv.style.color = 'red';
                        return false;
                    }
                    if (value.length < 2) {
                        input.classList.remove('is-valid');
                        input.classList.add('is-invalid');
                        errorDiv.textContent = 'Tên phải có ít nhất 2 ký tự';
                        errorDiv.style.color = 'red';
                        return false;
                    }
                    if (value.length > 200) {
                        input.classList.remove('is-valid');
                        input.classList.add('is-invalid');
                        errorDiv.textContent = 'Tên không được vượt quá 200 ký tự';
                        errorDiv.style.color = 'red';
                        return false;
                    }
                    if (!vietnameseNamePattern.test(value)) {
                        input.classList.remove('is-valid');
                        input.classList.add('is-invalid');
                        errorDiv.textContent = 'Tên chỉ được chứa chữ cái và khoảng trắng (cho phép tiếng Việt có dấu)';
                        errorDiv.style.color = 'red';
                        return false;
                    }
                    if (!isNameDuplicateError) {
                        input.classList.remove('is-invalid');
                        input.classList.add('is-valid');
                        errorDiv.textContent = 'Tên hợp lệ';
                        errorDiv.style.color = 'green';
                    }
                    return true;
                }

                // Sửa lại form submit để đợi validate ảnh
                $('form').on('submit', async function (e) {
                    e.preventDefault();
                    isSubmitting = true;
                    clearTimeout(nameCheckTimeout);

                    // Chuẩn hóa khoảng trắng
                    let nameValue = $('#name').val();
                    nameValue = nameValue.replace(/\s+/g, ' ').trim();
                    $('#name').val(nameValue);

                    // Validate các trường
                    const nameValid = validateName(document.getElementById('name'));
                    const descValid = validateDescription(document.getElementById('description'));
                    const imageValid = await validateImageAsync(document.getElementById('image'));

                    // Nếu các trường cơ bản hợp lệ, kiểm tra trùng tên (bắt buộc phải chờ AJAX)
                    if (nameValid && descValid && imageValid) {
                        checkNameDuplicate(nameValue, function (isDuplicate, msg) {
                            if (isDuplicate) {
                                isNameDuplicateError = true;
                                $('#name').removeClass('is-valid').addClass('is-invalid');
                                $('#nameError').text(msg || 'Tên này đã tồn tại trong hệ thống').css('color', 'red');
                                isSubmitting = false;
                                return;
                            } else {
                                isNameDuplicateError = false;
                                isSubmitting = false;
                                e.target.submit();
                            }
                        });
                    } else {
                        isSubmitting = false;
                    }
                });

                $(document).ready(function () {
                    const vietnameseNamePattern = /^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s]+$/;

                    $('#name').on('input', function () {
                        isNameDuplicateError = false;
                        clearTimeout(nameCheckTimeout);
                        let value = $(this).val();
                        const errorDiv = $('#nameError');

                        if (value === '') {
                            setInvalid('Tên không được để trống');
                            return;
                        }
                        if (value.length < 2) {
                            setInvalid('Tên phải có ít nhất 2 ký tự');
                            return;
                        }
                        if (value.length > 200) {
                            setInvalid('Tên không được vượt quá 200 ký tự');
                            return;
                        }
                        if (!vietnameseNamePattern.test(value)) {
                            setInvalid('Tên chỉ được chứa chữ cái và khoảng trắng (cho phép tiếng Việt có dấu)');
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

                    // Khi blur (rời khỏi input), chuẩn hóa khoảng trắng
                    $('#name').on('blur', function () {
                        let value = $(this).val();
                        // Chuẩn hóa: xóa khoảng trắng đầu/cuối và chuyển nhiều khoảng trắng liên tiếp thành 1 khoảng trắng
                        value = value.replace(/\s+/g, ' ').trim();
                        $(this).val(value).trigger('input');
                    });

                    // Khi submit form, chuẩn hóa khoảng trắng
                    $('#serviceTypeForm').on('submit', function (e) {
                        let nameValue = $('#name').val();
                        // Chuẩn hóa: xóa khoảng trắng đầu/cuối và chuyển nhiều khoảng trắng liên tiếp thành 1 khoảng trắng
                        nameValue = nameValue.replace(/\s+/g, ' ').trim();
                        $('#name').val(nameValue);
                    });

                    // Description
                    $('#description').on('input', function () {
                        validateDescription(this);
                    });
                    $('#description').on('blur', function () {
                        this.value = this.value.replace(/\s+/g, ' ').trim();
                        validateDescription(this);
                    });

                    // Image
                    $('#image').on('change', async function () {
                        await validateImageAsync(this);
                    });
                });

                function checkNameDuplicate(name, callback) {
                    $.ajax({
                        url: contextPath + '/servicetype',
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

                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl);
                });
            </script>
        </body>

        </html>