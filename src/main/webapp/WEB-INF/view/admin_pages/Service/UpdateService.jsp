<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en" data-theme="light">

        <head>
            <meta charset="UTF-8">
            <title>Update Service</title>
            <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
            <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
        </head>

        <body>

            <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
            <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

            <div class="dashboard-main-body">
                <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                    <h6 class="fw-semibold mb-0">Cập nhật dịch vụ</h6>
                    <ul class="d-flex align-items-center gap-2">
                        <li class="fw-medium">
                            <a href="service?service=list-all&page=${page}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}${not empty serviceTypeId ? '&serviceTypeId='.concat(serviceTypeId) : ''}"
                                class="d-flex align-items-center gap-1 hover-text-primary">
                                <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                                Trở lại danh sách dịch vụ
                            </a>
                        </li>
                        <li>-</li>
                        <li class="fw-medium">Cập nhật dịch vụ</li>
                    </ul>
                </div>

                <div class="card h-100 p-0 radius-12">
                    <div class="card-body p-24">
                        <div class="row justify-content-center">
                            <div class="col-xxl-8 col-xl-10">
                                <form action="service" method="post" enctype="multipart/form-data" class="border p-24 radius-12">
                                    <input type="hidden" name="service" value="update" />
                                    <input type="hidden" name="id" value="${service.serviceId}" />
                                    <input type="hidden" name="stypeId" value="${service.serviceTypeId.serviceTypeId}" />

                                    <!-- =================================== Thông tin cơ bản =================================== -->
                                    <div class="mb-32">
                                        <div class="d-flex align-items-center gap-3 mb-20">
                                            <div class="bg-primary-50 d-flex align-items-center justify-content-center w-40-px h-40-px radius-12">
                                                <iconify-icon icon="solar:document-text-outline" class="text-primary text-xl"></iconify-icon>
                                            </div>
                                            <h6 class="fw-semibold text-primary-light mb-0">Thông tin cơ bản</h6>
                                        </div>
        
                                        <div class="mb-20">
                                            <label class="form-label fw-semibold text-primary-light text-sm mb-8">Loại dịch vụ</label>
                                            <input type="text" class="form-control radius-8" value="${service.serviceTypeId.name}" readonly>
                                            <input type="hidden" name="service_type_id" value="${service.serviceTypeId.serviceTypeId}" />
                                        </div>
                                        <div class="mb-20">
                                            <label for="name" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                Tên dịch vụ <span class="text-danger-600">*</span>
                                            </label>
                                            <input type="text" name="name" class="form-control radius-8" id="name" value="${service.name}" required>
                                        </div>
                                        <div class="mb-20">
                                            <label for="description" class="form-label fw-semibold text-primary-light text-sm mb-8">Mô tả</label>
                                            <textarea name="description" id="description" class="form-control radius-8">${service.description}</textarea>
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
                                                    <label for="price" class="form-label fw-semibold text-primary-light text-sm mb-8">Giá</label>
                                                    <div class="input-group">
                                                        <input type="number" name="price" class="form-control radius-8-start" id="price" value="${service.price}" required>
                                                        <span class="input-group-text">VND</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="mb-20">
                                                    <label for="duration_minutes" class="form-label fw-semibold text-primary-light text-sm mb-8">Thời lượng</label>
                                                    <div class="input-group">
                                                         <input type="number" name="duration_minutes" class="form-control radius-8-start" id="duration_minutes" value="${service.durationMinutes}">
                                                         <span class="input-group-text">phút</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="mb-20">
                                                    <label for="buffer_time_after_minutes" class="form-label fw-semibold text-primary-light text-sm mb-8">Thời gian chờ</label>
                                                    <div class="input-group">
                                                        <input type="number" name="buffer_time_after_minutes" class="form-control radius-8-start" id="buffer_time_after_minutes" value="${service.bufferTimeAfterMinutes}">
                                                        <span class="input-group-text">phút</span>
                                                    </div>
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
                                            <c:forEach var="img" items="${serviceImages}">
                                                <div class="existing-img-container position-relative h-120-px w-120-px border input-form-light radius-8 overflow-hidden border-dashed bg-neutral-50">
                                                    <img src="${pageContext.request.contextPath}${img.imageUrl}" class="w-100 h-100 object-fit-cover" />
                                                    <input type="checkbox" name="delete_image_ids" value="${img.id}" id="delete_img_${img.id}" class="delete-checkbox" hidden />
                                                    <label for="delete_img_${img.id}" class="uploaded-img__remove position-absolute top-0 end-0 z-1 text-2xxl line-height-1 me-8 mt-8 d-flex" style="cursor: pointer;">
                                                        <iconify-icon icon="radix-icons:cross-2" class="text-xl text-danger-600"></iconify-icon>
                                                    </label>
                                                </div>
                                            </c:forEach>
                                            <div class="uploaded-imgs-container d-flex gap-3 flex-wrap"></div>
                                            <label class="upload-file-multiple h-120-px w-120-px border input-form-light radius-8 overflow-hidden border-dashed bg-neutral-50 bg-hover-neutral-200 d-flex align-items-center flex-column justify-content-center gap-1" for="upload-file-multiple">
                                                <iconify-icon icon="solar:camera-outline" class="text-xl text-secondary-light"></iconify-icon>
                                                <span class="fw-semibold text-secondary-light">Tải lên</span>
                                                <input id="upload-file-multiple" type="file" name="images" multiple hidden>
                                            </label>
                                        </div>
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
                                                    <input class="form-check-input" type="checkbox" role="switch" name="is_active" id="is_active" ${service.isActive ? "checked" : "" }>
                                                </div>
                                            </div>
                                            <div class="list-group-item d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h6 class="mb-0">Cho phép đặt online</h6>
                                                    <small class="text-muted d-block mt-1">Cho phép khách hàng tự đặt lịch cho dịch vụ này qua website.</small>
                                                </div>
                                                <div class="form-switch switch-primary">
                                                    <input class="form-check-input" type="checkbox" role="switch" name="bookable_online" id="bookable_online" ${service.bookableOnline ? "checked" : "" }>
                                                </div>
                                            </div>
                                            <div class="list-group-item d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h6 class="mb-0">Yêu cầu tư vấn</h6>
                                                    <small class="text-muted d-block mt-1">Yêu cầu khách hàng phải được tư vấn trước khi đặt dịch vụ.</small>
                                                </div>
                                                <div class="form-switch switch-primary">
                                                     <input class="form-check-input" type="checkbox" role="switch" name="requires_consultation" id="requires_consultation" ${service.requiresConsultation ? "checked" : "" }>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- =================================== Nút bấm =================================== -->
                                    <div class="d-flex align-items-center justify-content-end gap-3">
                                        <a href="service?service=list-all&page=${page}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}${not empty serviceTypeId ? '&serviceTypeId='.concat(serviceTypeId) : ''}"
                                            class="btn btn-outline-danger border border-danger-600 px-40 py-11 radius-8">Hủy</a>
                                        <button type="submit"
                                            class="btn btn-primary border border-primary-600 text-md px-40 py-12 radius-8">Cập nhật</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />

            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    const deleteCheckboxes = document.querySelectorAll('.delete-checkbox');
                    deleteCheckboxes.forEach(checkbox => {
                        checkbox.addEventListener('change', function() {
                            const container = this.closest('.existing-img-container');
                            if (this.checked) {
                                container.style.opacity = '0.5';
                            } else {
                                container.style.opacity = '1';
                            }
                        });
                    });
                });

                // ================================================ Upload Multiple image js Start here ================================================
                const fileInputMultiple = document.getElementById("upload-file-multiple");
                const uploadedImgsContainer = document.querySelector(".uploaded-imgs-container");
                let selectedFiles = new DataTransfer(); // To manage FileList object

                fileInputMultiple.addEventListener("change", (e) => {
                    const files = e.target.files;
                    
                    // Add new files to our DataTransfer object
                    Array.from(files).forEach(file => {
                        // Validate file type
                        if (!file.type.startsWith('image/')) {
                            alert('Please upload only image files.');
                            return;
                        }
                        
                        // Validate file size (2MB = 2 * 1024 * 1024 bytes)
                        if (file.size > 2 * 1024 * 1024) {
                            alert('File size should not exceed 2MB.');
                            return;
                        }

                        selectedFiles.items.add(file);
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
                        
                        // Store file name as data attribute for removal
                        imgContainer.dataset.fileName = file.name;

                        imgContainer.appendChild(removeButton);
                        imgContainer.appendChild(imagePreview);
                        uploadedImgsContainer.appendChild(imgContainer);

                        removeButton.addEventListener('click', () => {
                            // Remove file from DataTransfer object
                            const newFiles = new DataTransfer();
                            const fileName = imgContainer.dataset.fileName;
                            
                            Array.from(selectedFiles.files).forEach(file => {
                                if (file.name !== fileName) {
                                    newFiles.items.add(file);
                                }
                            });
                            
                            selectedFiles = newFiles;
                            fileInputMultiple.files = selectedFiles.files;
                            
                            // Remove preview
                            URL.revokeObjectURL(src);
                            imgContainer.remove();
                        });
                    });

                    // Update the file input with all selected files
                    fileInputMultiple.files = selectedFiles.files;
                });

                // Clear selected files when form is reset
                document.querySelector('form').addEventListener('reset', () => {
                    selectedFiles = new DataTransfer();
                    fileInputMultiple.files = selectedFiles.files;
                    uploadedImgsContainer.innerHTML = '';
                });
                // ================================================ Upload Multiple image js End here  ================================================
            </script>
        </body>

        </html>