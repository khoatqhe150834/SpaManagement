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

            <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
            <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

            <div class="dashboard-main-body">
                <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                    <h6 class="fw-semibold mb-0">Add New Service</h6>
                    <ul class="d-flex align-items-center gap-2">
                        <li class="fw-medium">
                            <a href="servicetype" class="d-flex align-items-center gap-1 hover-text-primary">
                                <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                                Back to Service Types
                            </a>
                        </li>
                        <li>-</li>
                        <li class="fw-medium">Create New Service</li>
                    </ul>
                </div>

                <div class="card h-100 p-0 radius-12">
                    <div class="card-body p-24">
                        <div class="row justify-content-center">
                            <div class="col-xxl-6 col-xl-8 col-lg-10">
                                <div class="card border">
                                    <div class="card-body">
                                        <form action="service" method="post" enctype="multipart/form-data">
                                            <input type="hidden" name="service" value="insert" />
                                            <div class="mb-20">
                                                <label for="service_type_id" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                    Service Type <span class="text-danger-600">*</span>
                                                </label>
                                                <select name="service_type_id" id="service_type_id" class="form-control radius-8" required>
                                                    <c:forEach var="type" items="${serviceTypes}">
                                                        <option value="${type.serviceTypeId}">${type.name}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <!-- Name -->
                                            <div class="mb-20">
                                                <label for="name"
                                                    class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                    Service Name <span class="text-danger-600">*</span>
                                                </label>
                                                <input type="text" name="name" class="form-control radius-8" id="name"
                                                    placeholder="Enter service name" required>
                                            </div>

                                            <!-- Description -->
                                            <div class="mb-20">
                                                <label for="description"
                                                    class="form-label fw-semibold text-primary-light text-sm mb-8">Description</label>
                                                <textarea name="description" id="description"
                                                    class="form-control radius-8"
                                                    placeholder="Write description..."></textarea>
                                            </div>

                                            <!-- Price -->
                                            <div class="mb-20">
                                                <label for="price"
                                                    class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                    Price (VND) <span class="text-danger-600">*</span>
                                                </label>
                                                <input type="number" name="price" class="form-control radius-8"
                                                    id="price" required>
                                            </div>

                                            <!-- Duration -->
                                            <div class="mb-20">
                                                <label for="duration_minutes"
                                                    class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                    Duration (minutes) <span class="text-danger-600">*</span>
                                                </label>
                                                <input type="number" name="duration_minutes"
                                                    class="form-control radius-8" id="duration_minutes" required>
                                            </div>

                                            <!-- Buffer Time -->
                                            <div class="mb-20">
                                                <label for="buffer_time_after_minutes"
                                                    class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                    Buffer Time After (minutes)
                                                </label>
                                                <input type="number" name="buffer_time_after_minutes"
                                                    class="form-control radius-8" id="buffer_time_after_minutes" value="0">
                                            </div>

                                            <!-- Image URL -->
                                            <div class="mb-20">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                    Upload Images
                                                </label>
                                                <div class="upload-image-wrapper d-flex align-items-center gap-3 flex-wrap">
                                                    <div class="uploaded-imgs-container d-flex gap-3 flex-wrap"></div>
                                                    <label
                                                        class="upload-file-multiple h-120-px w-120-px border input-form-light radius-8 overflow-hidden border-dashed bg-neutral-50 bg-hover-neutral-200 d-flex align-items-center flex-column justify-content-center gap-1"
                                                        for="upload-file-multiple">
                                                        <iconify-icon icon="solar:camera-outline"
                                                            class="text-xl text-secondary-light"></iconify-icon>
                                                        <span class="fw-semibold text-secondary-light">Upload</span>
                                                        <input id="upload-file-multiple" type="file" name="images" multiple hidden>
                                                    </label>
                                                </div>
                                            </div>

                                            <!-- Checkboxes -->
                                            <div class="mb-20">
                                                <div
                                                    class="form-switch switch-primary d-flex align-items-center gap-3 mb-2">
                                                    <input class="form-check-input" type="checkbox" role="switch"
                                                        name="is_active" id="is_active" checked>
                                                    <label
                                                        class="form-check-label line-height-1 fw-medium text-secondary-light"
                                                        for="is_active">Active</label>
                                                </div>
                                                <div
                                                    class="form-switch switch-primary d-flex align-items-center gap-3 mb-2">
                                                    <input class="form-check-input" type="checkbox" role="switch"
                                                        name="bookable_online" id="bookable_online" checked>
                                                    <label
                                                        class="form-check-label line-height-1 fw-medium text-secondary-light"
                                                        for="bookable_online">Bookable Online</label>
                                                </div>
                                                <div class="form-switch switch-primary d-flex align-items-center gap-3">
                                                    <input class="form-check-input" type="checkbox" role="switch"
                                                        name="requires_consultation" id="requires_consultation">
                                                    <label
                                                        class="form-check-label line-height-1 fw-medium text-secondary-light"
                                                        for="requires_consultation">Requires Consultation</label>
                                                </div>
                                            </div>

                                            <!-- Buttons -->
                                            <div class="d-flex align-items-center justify-content-center gap-3">
                                                <a href="servicetype"
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

            <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
            <script>
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