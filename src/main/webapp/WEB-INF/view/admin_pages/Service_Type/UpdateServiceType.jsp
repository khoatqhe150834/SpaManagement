<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Update Service Type</title>
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
        .switch input {display:none;}
        .slider {
          position: absolute;
          cursor: pointer;
          top: 0; left: 0; right: 0; bottom: 0;
          background-color: #ccc;
          transition: .4s;
          border-radius: 24px;
        }
        .slider:before {
          position: absolute;
          content: "";
          height: 18px; width: 18px;
          left: 3px; bottom: 3px;
          background-color: white;
          transition: .4s;
          border-radius: 50%;
        }
        input:checked + .slider {
          background-color: #2196F3;
        }
        input:checked + .slider:before {
          transform: translateX(24px);
        }
        .invalid-feedback { display: block; }
        </style>
    </head>
    <body>

        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Update Service Type</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="servicetype" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Back to List
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Edit Service Type</li>
                </ul>
            </div>

            <div class="card h-100 p-0 radius-12">
                <div class="card-body p-24">
                    <div class="row justify-content-center">
                        <div class="col-xxl-6 col-xl-8 col-lg-10">
                            <div class="card border">
                                <div class="card-body">
                                    <form action="servicetype" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="service" value="update" />
                                        <input type="hidden" name="id" value="${stype.serviceTypeId}" />

                                        <!-- Name -->
                                        <div class="mb-20">
                                            <label for="name" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                Tên loại dịch vụ <span class="text-danger-600">*</span>
                                            </label>
                                            <input type="text" name="name" class="form-control radius-8" id="name"
                                                   value="${stype.name}" required placeholder="Nhập tên loại dịch vụ" />
                                            <div class="invalid-feedback" id="nameError"></div>
                                        </div>

                                        <!-- Description -->
                                        <div class="mb-20">
                                            <label for="description" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                Mô tả <span class="text-danger-600">*</span>
                                            </label>
                                            <textarea name="description" id="description" class="form-control radius-8"
                                                      placeholder="Nhập mô tả..." rows="7"
                                                      oninput="validateDescription(this)">${stype.description}</textarea>
                                            <div class="invalid-feedback" id="descriptionError"></div>
                                            <small class="text-muted">Tối thiểu 20 ký tự, tối đa 500 ký tự</small>
                                        </div>

                                        <!-- Image -->
                                        <div class="mb-20">
                                            <label for="image" class="form-label fw-semibold text-primary-light text-sm mb-8">Hình Ảnh</label>
                                            <div class="d-flex gap-3 align-items-center">
                                                <input type="file" name="image" class="form-control radius-8" id="image"
                                                       accept="image/jpeg,image/png,image/gif" onchange="validateImage(this);">
                                                <div id="imagePreview" class="${empty stype.imageUrl ? 'd-none' : ''}">
                                                    <img src="${stype.imageUrl}" alt="Preview" class="w-100-px h-100-px rounded" id="previewImg" onclick="showImageModal(this.src)" style="cursor: pointer;">
                                                </div>
                                            </div>
                                            <div class="invalid-feedback" id="imageError"></div>
                                            <small class="text-danger" id="imageSizeHint" style="display:none;">Không được upload ảnh quá 2MB.</small>
                                            <small class="text-muted">
                                                Chọn ảnh mới nếu muốn thay đổi. Nếu không chọn, sẽ giữ ảnh cũ.<br>
                                                Chấp nhận: JPG, PNG, GIF. Kích thước tối đa: 2MB. Kích thước tối thiểu: 200x200px
                                            </small>
                                        </div>

                                        <!-- Status -->
                                        <div class="mb-20">
                                            <label class="form-label fw-semibold text-primary-light text-sm mb-8 d-block">Trạng thái</label>
                                            <label class="switch">
                                                <input type="checkbox" name="is_active" id="is_active" ${stype.active ? "checked" : ""}>
                                                <span class="slider"></span>
                                            </label>
                                            <span class="ms-2">Đang hoạt động</span>
                                        </div>

                                        <!-- Action Buttons -->
                                        <div class="d-flex align-items-center justify-content-center gap-3">
                                            <a href="servicetype" class="btn btn-outline-danger border border-danger-600 px-56 py-11 radius-8">Cancel</a>
                                            <button type="submit" class="btn btn-primary border border-primary-600 text-md px-56 py-12 radius-8">Update</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />

        <script>
        function previewImage(input) {
            const preview = document.getElementById('imagePreview');
            const previewImg = document.getElementById('previewImg');
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    previewImg.src = e.target.result;
                    preview.classList.remove('d-none');
                }
                reader.readAsDataURL(input.files[0]);
            } else {
                preview.classList.add('d-none');
            }
        }

        const vietnameseNamePattern = /^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s]+$/;
        const vietnameseDescPattern = /^[a-zA-Z0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s.,\-()!?:;"'\n\r]+$/;

        // Validate Name
        function validateName(input) {
            const errorDiv = $('#nameError');
            let value = $(input).val();

            if (value.trim() === '') {
                setInvalid('Tên không được để trống');
                return false;
            }
            if (value.length < 2) {
                setInvalid('Tên phải có ít nhất 2 ký tự');
                return false;
            }
            if (value.length > 200) {
                setInvalid('Tên không được vượt quá 200 ký tự');
                return false;
            }
            if (!vietnameseNamePattern.test(value)) {
                setInvalid('Tên chỉ được chứa chữ cái và khoảng trắng (cho phép tiếng Việt có dấu)');
                return false;
            }
            setValid('Tên hợp lệ');
            return true;

            function setInvalid(msg) {
                $(input).removeClass('is-valid').addClass('is-invalid');
                errorDiv.text(msg).css('color', 'red');
                input.setCustomValidity(msg);
            }
            function setValid(msg) {
                $(input).removeClass('is-invalid').addClass('is-valid');
                errorDiv.text(msg).css('color', 'green');
                input.setCustomValidity('');
            }
        }

        // Validate Description
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

        // Validate Image
        function validateImage(input) {
            const imageError = document.getElementById('imageError');
            const imageSizeHint = document.getElementById('imageSizeHint');
            const file = input.files[0];

            if (file) {
                // Check file size (2MB = 2 * 1024 * 1024 bytes)
                if (file.size > 2 * 1024 * 1024) {
                    imageError.textContent = 'Không được upload ảnh quá 2MB.';
                    imageError.style.display = 'block';
                    imageError.style.color = 'red';
                    input.classList.add('is-invalid');
                    return false;
                } else {
                    imageSizeHint.style.display = 'none';
                }

                // Check file type
                const validTypes = ['image/jpeg', 'image/png', 'image/gif'];
                if (!validTypes.includes(file.type)) {
                    imageError.textContent = 'Chỉ chấp nhận file JPG, PNG hoặc GIF.';
                    imageError.style.display = 'block';
                    imageError.style.color = 'red';
                    input.classList.add('is-invalid');
                    return false;
                }

                // Check image dimensions
                const img = new Image();
                img.onload = function() {
                    if (this.width < 200 || this.height < 200) {
                        imageError.textContent = 'Kích thước ảnh phải tối thiểu 200x200px. Ảnh bạn chọn là ' + this.width + 'x' + this.height + 'px.';
                        imageError.style.display = 'block';
                        imageError.style.color = 'red';
                        input.classList.add('is-invalid');
                        return false;
                    }
                    // Nếu hợp lệ
                    imageError.textContent = '';
                    imageError.style.display = 'none';
                    input.classList.remove('is-invalid');
                    input.classList.add('is-valid');
                    previewImage(input);
                };
                img.src = URL.createObjectURL(file);
            } else {
                imageError.textContent = '';
                imageError.style.display = 'none';
                input.classList.remove('is-invalid', 'is-valid');
            }
        }

        // Gắn validate realtime cho name
        $('#name').on('input', function() {
            validateName(this);
        });

        // Khi blur (rời khỏi input), chuẩn hóa khoảng trắng và validate lại
        $('#name').on('blur', function() {
            let value = $(this).val();
            value = value.replace(/\s+/g, ' ').trim();
            $(this).val(value);
            validateName(this);
        });

        // Gắn validate realtime cho description
        $('#description').on('input', function() {
            validateDescription(this);
        });
        $('#description').on('blur', function() {
            this.value = this.value.replace(/\s+/g, ' ').trim();
            validateDescription(this);
        });

        // Validate image khi chọn file
        $('#image').on('change', function() {
            validateImage(this);
        });

        // Khi submit form, chuẩn hóa khoảng trắng
        $('form').on('submit', function(e) {
            let nameValue = $('#name').val();
            nameValue = nameValue.replace(/\s+/g, ' ').trim();
            $('#name').val(nameValue);
            validateName(document.getElementById('name'));
            validateDescription(document.getElementById('description'));
            validateImage(document.getElementById('image'));
            if (!this.checkValidity()) {
                e.preventDefault();
                e.stopPropagation();
                this.classList.add('was-validated');
            }
        });
        </script>

        <!-- Modal hiển thị ảnh lớn -->
        <div id="imageModal" style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100vw; height:100vh; background:rgba(0,0,0,0.8); align-items:center; justify-content:center;">
            <img id="modalImg" src="" style="max-width:90vw; max-height:90vh; border:4px solid #fff; border-radius:8px;">
        </div>
        <script>
        function showImageModal(src) {
            var modal = document.getElementById('imageModal');
            var modalImg = document.getElementById('modalImg');
            modalImg.src = src;
            modal.style.display = 'flex';
            // Đóng modal khi click ra ngoài ảnh
            modal.onclick = function(e) {
                if (e.target === modal) {
                    modal.style.display = 'none';
                    modalImg.src = '';
                }
            }
        }
        </script>

        
    </body>
</html>
