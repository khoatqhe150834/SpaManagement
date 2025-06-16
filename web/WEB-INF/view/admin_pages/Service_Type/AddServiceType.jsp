<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        </style>
    </head>
    <body>

        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
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
                                    <form action="servicetype" method="post" enctype="multipart/form-data" id="serviceTypeForm" novalidate>
                                        <input type="hidden" name="service" value="insert" />

                                        <!-- Name -->
                                        <div class="mb-20">
                                            <label for="name" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                Service Type Name <span class="text-danger-600">*</span>
                                            </label>
                                            <input type="text" name="name" class="form-control radius-8" id="name" 
                                                   placeholder="Enter service type name" required
                                                   minlength="2" maxlength="100"
                                                   pattern="[a-zA-Z0-9\s\-]+"
                                                   oninput="validateName(this)">
                                            <div class="invalid-feedback" id="nameError"></div>
                                        </div>

                                        <!-- Description -->
                                        <div class="mb-20">
                                            <label for="description" class="form-label fw-semibold text-primary-light text-sm mb-8">Description</label>
                                            <textarea name="description" id="description" class="form-control radius-8" 
                                                      placeholder="Write description..." maxlength="500"
                                                      oninput="validateDescription(this)"></textarea>
                                            <div class="invalid-feedback" id="descriptionError"></div>
                                            <small class="text-muted">Maximum 500 characters</small>
                                        </div>

                                        <!-- Image -->
                                        <div class="mb-20">
                                            <label for="image" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                Hình Ảnh <span class="text-danger-600">*</span>
                                            </label>
                                            <div class="d-flex gap-3 align-items-center">
                                                <input type="file" name="image" class="form-control radius-8" id="image" 
                                                       accept="image/jpeg,image/png,image/gif" 
                                                       onchange="validateImage(this);" required>
                                                <div id="imagePreview" class="d-none">
                                                    <img src="" alt="Preview" class="w-100-px h-100-px rounded" id="previewImg" onclick="showImageModal(this.src)" style="cursor: pointer;">
                                                </div>
                                            </div>
                                            <div class="invalid-feedback" id="imageError"></div>
                                            <small class="text-muted">Chấp nhận: JPG, PNG, GIF. Kích thước tối đa: 2MB. Kích thước tối thiểu: 200x200px</small>
                                        </div>

                                        <!-- Status -->
                                        <div class="mb-20">
                                            <label class="form-label fw-semibold text-primary-light text-sm mb-8 d-block">Trạng thái</label>
                                            <label class="switch">
                                                <input type="checkbox" name="is_active" id="is_active" checked>
                                                <span class="slider"></span>
                                            </label>
                                            <span class="ms-2">Đang hoạt động</span>
                                        </div>

                                        <!-- Action Buttons -->
                                        <div class="d-flex align-items-center justify-content-center gap-3">
                                            <a href="servicetype" class="btn btn-outline-danger border border-danger-600 px-56 py-11 radius-8">Cancel</a>
                                            <button type="submit" class="btn btn-primary border border-primary-600 text-md px-56 py-12 radius-8">Save</button>
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
        <div id="imageModal" style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100vw; height:100vh; background:rgba(0,0,0,0.8); align-items:center; justify-content:center;">
            <img id="modalImg" src="" style="max-width:90vw; max-height:90vh; border:4px solid #fff; border-radius:8px;">
        </div>

        <script>
        // Validation functions
        function validateName(input) {
            const nameError = document.getElementById('nameError');
            const value = input.value.trim();
            
            if (value.length < 2) {
                nameError.textContent = 'Tên phải có ít nhất 2 ký tự';
                input.setCustomValidity('Tên phải có ít nhất 2 ký tự');
            } else if (value.length > 100) {
                nameError.textContent = 'Tên không được vượt quá 100 ký tự';
                input.setCustomValidity('Tên không được vượt quá 100 ký tự');
            } else if (!/^[a-zA-Z0-9\s\-]+$/.test(value)) {
                nameError.textContent = 'Tên không được chứa ký tự đặc biệt';
                input.setCustomValidity('Tên không được chứa ký tự đặc biệt');
            } else {
                nameError.textContent = '';
                input.setCustomValidity('');
            }
        }

        function validateDescription(input) {
            const descriptionError = document.getElementById('descriptionError');
            const value = input.value.trim();
            
            if (value.length > 500) {
                descriptionError.textContent = 'Mô tả không được vượt quá 500 ký tự';
                input.setCustomValidity('Mô tả không được vượt quá 500 ký tự');
            } else {
                descriptionError.textContent = '';
                input.setCustomValidity('');
            }
        }

        function validateImage(input) {
            const imageError = document.getElementById('imageError');
            const file = input.files[0];
            
            if (file) {
                // Check file size (2MB = 2 * 1024 * 1024 bytes)
                if (file.size > 2 * 1024 * 1024) {
                    imageError.textContent = 'Kích thước file không được vượt quá 2MB';
                    input.setCustomValidity('Kích thước file không được vượt quá 2MB');
                    input.value = '';
                    return;
                }

                // Check file type
                const validTypes = ['image/jpeg', 'image/png', 'image/gif'];
                if (!validTypes.includes(file.type)) {
                    imageError.textContent = 'Chỉ chấp nhận file JPG, PNG hoặc GIF';
                    input.setCustomValidity('Chỉ chấp nhận file JPG, PNG hoặc GIF');
                    input.value = '';
                    return;
                }

                // Check image dimensions
                const img = new Image();
                img.onload = function() {
                    if (this.width < 200 || this.height < 200) {
                        imageError.textContent = 'Kích thước ảnh tối thiểu phải là 200x200px';
                        input.setCustomValidity('Kích thước ảnh tối thiểu phải là 200x200px');
                        input.value = '';
                        return;
                    }
                    
                    // Check aspect ratio (not too long or too wide)
                    const ratio = this.width / this.height;
                    if (ratio < 0.5 || ratio > 2) {
                        imageError.textContent = 'Tỷ lệ khung hình không phù hợp';
                        input.setCustomValidity('Tỷ lệ khung hình không phù hợp');
                        input.value = '';
                        return;
                    }

                    imageError.textContent = '';
                    input.setCustomValidity('');
                    previewImage(input);
                };
                img.src = URL.createObjectURL(file);
            }
        }

        // Form submission validation
        document.getElementById('serviceTypeForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Validate all fields
            const name = document.getElementById('name');
            const description = document.getElementById('description');
            const image = document.getElementById('image');
            
            validateName(name);
            validateDescription(description);
            validateImage(image);
            
            // Check if form is valid
            if (this.checkValidity()) {
                this.submit();
            } else {
                e.stopPropagation();
            }
            
            this.classList.add('was-validated');
        });

        // Existing functions
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

        <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
    </body>
</html>
