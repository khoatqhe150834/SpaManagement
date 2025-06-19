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
                    <h6 class="fw-semibold mb-0">Update Service</h6>
                    <ul class="d-flex align-items-center gap-2">
                        <li class="fw-medium">
                            <a href="service?service=viewByServiceType&id=${service.serviceTypeId.serviceTypeId}"
                                class="d-flex align-items-center gap-1 hover-text-primary">
                                <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                                Back to Service Type
                            </a>
                        </li>
                        <li>-</li>
                        <li class="fw-medium">Edit Service</li>
                    </ul>
                </div>

                <div class="card h-100 p-0 radius-12">
                    <div class="card-body p-24">
                        <div class="row justify-content-center">
                            <div class="col-xxl-6 col-xl-8 col-lg-10">
                                <div class="card border">
                                    <div class="card-body">
                                        <form action="service" method="post" enctype="multipart/form-data">
                                            <input type="hidden" name="service" value="update" />
                                            <input type="hidden" name="id" value="${service.serviceId}" />
                                            <input type="hidden" name="stypeId"
                                                value="${service.serviceTypeId.serviceTypeId}" />

                                            <!-- Hiển thị loại dịch vụ (không cho sửa) -->
                                            <div class="mb-20">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                    Service Type
                                                </label>
                                                <input type="text" class="form-control radius-8" value="${service.serviceTypeId.name}" readonly>
                                                <input type="hidden" name="service_type_id" value="${service.serviceTypeId.serviceTypeId}" />
                                            </div>

                                            <!-- Name -->
                                            <div class="mb-20">
                                                <label for="name"
                                                    class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                    Service Name <span class="text-danger-600">*</span>
                                                </label>
                                                <input type="text" name="name" class="form-control radius-8" id="name"
                                                    value="${service.name}" required>
                                            </div>

                                            <!-- Description -->
                                            <div class="mb-20">
                                                <label for="description"
                                                    class="form-label fw-semibold text-primary-light text-sm mb-8">Description</label>
                                                <textarea name="description" id="description"
                                                    class="form-control radius-8">${service.description}</textarea>
                                            </div>

                                            <!-- Price -->
                                            <div class="mb-20">
                                                <label for="price"
                                                    class="form-label fw-semibold text-primary-light text-sm mb-8">Price
                                                    (VND)</label>
                                                <input type="number" name="price" class="form-control radius-8"
                                                    id="price" value="${service.price}" required>
                                            </div>

                                            <!-- Duration -->
                                            <div class="mb-20">
                                                <label for="duration_minutes"
                                                    class="form-label fw-semibold text-primary-light text-sm mb-8">Duration
                                                    (minutes)</label>
                                                <input type="number" name="duration_minutes"
                                                    class="form-control radius-8" id="duration_minutes"
                                                    value="${service.durationMinutes}">
                                            </div>

                                            <!-- Buffer -->
                                            <div class="mb-20">
                                                <label for="buffer_time_after_minutes"
                                                    class="form-label fw-semibold text-primary-light text-sm mb-8">Buffer
                                                    Time (minutes)</label>
                                                <input type="number" name="buffer_time_after_minutes"
                                                    class="form-control radius-8" id="buffer_time_after_minutes"
                                                    value="${service.bufferTimeAfterMinutes}">
                                            </div>

                                            <!-- Image URL -->
                                            <div class="mb-20">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                    Upload Images
                                                </label>
                                                <div class="upload-image-wrapper d-flex align-items-center gap-3 flex-wrap">
                                                    <!-- Hiển thị ảnh hiện tại của dịch vụ -->
                                                    <c:forEach var="img" items="${serviceImages}">
                                                        <div class="position-relative h-120-px w-120-px border input-form-light radius-8 overflow-hidden border-dashed bg-neutral-50">
                                                            <img src="${img.imageUrl}" class="w-100 h-100 object-fit-cover" />
                                                        </div>
                                                    </c:forEach>
                                                    <label
                                                        class="upload-file-multiple h-120-px w-120-px border input-form-light radius-8 overflow-hidden border-dashed bg-neutral-50 bg-hover-neutral-200 d-flex align-items-center flex-column justify-content-center gap-1"
                                                        for="upload-file-multiple">
                                                        <iconify-icon icon="solar:camera-outline"
                                                            class="text-xl text-secondary-light"></iconify-icon>
                                                        <span class="fw-semibold text-secondary-light">Upload</span>
                                                        <!-- Lưu ý: name=\"images\" và có multiple -->
                                                        <input id="upload-file-multiple" type="file" name="images" multiple hidden>
                                                    </label>
                                                </div>
                                            </div>

                                            <!-- Checkboxes -->
                                            <div class="mb-20">
                                                <div class="form-switch switch-primary d-flex align-items-center gap-3 mb-2">
                                                    <input class="form-check-input" type="checkbox" role="switch"
                                                        name="is_active" id="is_active" ${service.isActive ? "checked" : "" }>
                                                    <label class="form-check-label line-height-1 fw-medium text-secondary-light"
                                                        for="is_active">Active</label>
                                                </div>
                                                <div class="form-switch switch-primary d-flex align-items-center gap-3 mb-2">
                                                    <input class="form-check-input" type="checkbox" role="switch"
                                                        name="bookable_online" id="bookable_online" ${service.bookableOnline ? "checked" : "" }>
                                                    <label class="form-check-label line-height-1 fw-medium text-secondary-light"
                                                        for="bookable_online">Bookable Online</label>
                                                </div>
                                                <div class="form-switch switch-primary d-flex align-items-center gap-3">
                                                    <input class="form-check-input" type="checkbox" role="switch"
                                                        name="requires_consultation" id="requires_consultation" ${service.requiresConsultation ? "checked" : "" }>
                                                    <label class="form-check-label line-height-1 fw-medium text-secondary-light"
                                                        for="requires_consultation">Requires Consultation</label>
                                                </div>
                                            </div>

                                            <!-- Buttons -->
                                            <div class="d-flex align-items-center justify-content-center gap-3">
                                                <a href="service?service=viewByServiceType&id=${service.serviceTypeId.serviceTypeId}"
                                                    class="btn btn-outline-danger border border-danger-600 px-56 py-11 radius-8">Cancel</a>
                                                <button type="submit"
                                                    class="btn btn-primary border border-primary-600 text-md px-56 py-12 radius-8">Update</button>
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

                fileInputMultiple.addEventListener("change", (e) => {
                    const files = e.target.files;

                    Array.from(files).forEach(file => {
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

                        imgContainer.appendChild(removeButton);
                        imgContainer.appendChild(imagePreview);
                        uploadedImgsContainer.appendChild(imgContainer);

                        removeButton.addEventListener('click', () => {
                            URL.revokeObjectURL(src);
                            imgContainer.remove();
                        });
                    });

                    // Clear the file input so the same file(s) can be uploaded again if needed
                    fileInputMultiple.value = '';
                });
                // ================================================ Upload Multiple image js End here  ================================================
            </script>
        </body>

        </html>