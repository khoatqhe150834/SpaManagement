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
                                                Service Type Name <span class="text-danger-600">*</span>
                                            </label>
                                            <input type="text" name="name" class="form-control radius-8" id="name"
                                                   value="${stype.name}" required />
                                        </div>

                                        <!-- Description -->
                                        <div class="mb-20">
                                            <label for="description" class="form-label fw-semibold text-primary-light text-sm mb-8">Description</label>
                                            <textarea name="description" id="description" class="form-control radius-8"
                                                      placeholder="Write description...">${stype.description}</textarea>
                                        </div>

                                        <!-- Image -->
                                        <div class="mb-20">
                                            <label for="image" class="form-label fw-semibold text-primary-light text-sm mb-8">Hình Ảnh</label>
                                            <div class="d-flex gap-3 align-items-center">
                                                <input type="file" name="image" class="form-control radius-8" id="image"
                                                       accept="image/*" onchange="previewImage(this);">
                                                <div id="imagePreview" class="${empty stype.imageUrl ? 'd-none' : ''}">
                                                    <img src="${stype.imageUrl}" alt="Preview" class="w-100-px h-100-px rounded" id="previewImg">
                                                </div>
                                            </div>
                                            <small class="text-muted">Chọn ảnh mới nếu muốn thay đổi. Nếu không chọn, sẽ giữ ảnh cũ.</small>
                                            <input type="text" name="image_url" class="form-control radius-8 mt-2" id="image_url"
                                                   value="${stype.imageUrl}" placeholder="Hoặc nhập đường dẫn ảnh (nếu có)" />
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
        </script>

        <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
    </body>
</html>
