<%-- 
    Document   : blog_add
    Created on : Jun 18, 2025, 3:26:59 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- meta tags and other links -->
<!DOCTYPE html>
<html lang="en" data-theme="light">

    <!-- Mirrored from wowdash.wowtheme7.com/demo/add-blog.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 03 Feb 2025 04:44:35 GMT -->
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Wowdash - Bootstrap 5 Admin Dashboard HTML Template</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
        <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
    </head>
    <body>
        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />



        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Add Blog</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Dashboard
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Add Blog</li>
                </ul>
            </div>

            <div class="card mt-24">
                <div class="card-body p-24">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger mb-16">${error}</div>
                    </c:if>
                    <form action="${pageContext.request.contextPath}/blog?action=add" method="post" enctype="multipart/form-data" class="d-flex flex-column gap-20">
                        <div>
                            <label class="form-label fw-bold text-neutral-900" for="title">Title <span class="text-danger">*</span></label>
                            <input type="text" class="form-control border border-neutral-200 radius-8" id="title" name="title" placeholder="Enter Post Title" required>
                        </div>
                        <div>
                            <label class="form-label fw-bold text-neutral-900" for="slug">Slug <span class="text-danger">*</span></label>
                            <input type="text" class="form-control border border-neutral-200 radius-8" id="slug" name="slug" placeholder="unique-slug" required>
                        </div>
                        <div>
                            <label class="form-label fw-bold text-neutral-900" for="summary">Summary <span class="text-danger">*</span></label>
                            <textarea class="form-control border border-neutral-200 radius-8" id="summary" name="summary" rows="2" placeholder="Short summary..." required></textarea>
                        </div>
                        <div>
                            <label class="form-label fw-bold text-neutral-900">Category <span class="text-danger">*</span></label>
                            <select class="form-control border border-neutral-200 radius-8" name="category" id="category" required>
                                <option value="">Select category</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.categoryId}">${cat.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div>
                            <label class="form-label fw-bold text-neutral-900">Status <span class="text-danger">*</span></label>
                            <select class="form-control border border-neutral-200 radius-8" name="status" id="status" required>
                                <option value="DRAFT">Draft</option>
                                <option value="PUBLISHED">Published</option>
                                <option value="SCHEDULED">Scheduled</option>
                                <option value="ARCHIVED">Archived</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label fw-bold text-neutral-900">Content <span class="text-danger">*</span></label>
                            <div class="border border-neutral-200 radius-8 overflow-hidden">
                                <div class="height-200">
                                    <div id="toolbar-container">
                                        <span class="ql-formats">
                                            <select class="ql-font"></select>
                                            <select class="ql-size"></select>
                                        </span>
                                        <span class="ql-formats">
                                            <button class="ql-bold"></button>
                                            <button class="ql-italic"></button>
                                            <button class="ql-underline"></button>
                                            <button class="ql-strike"></button>
                                        </span>
                                        <span class="ql-formats">
                                            <select class="ql-color"></select>
                                            <select class="ql-background"></select>
                                        </span>
                                        <span class="ql-formats">
                                            <button class="ql-script" value="sub"></button>
                                            <button class="ql-script" value="super"></button>
                                        </span>
                                        <span class="ql-formats">
                                            <button class="ql-header" value="1"></button>
                                            <button class="ql-header" value="2"></button>
                                            <button class="ql-blockquote"></button>
                                            <button class="ql-code-block"></button>
                                        </span>
                                        <span class="ql-formats">
                                            <button class="ql-list" value="ordered"></button>
                                            <button class="ql-list" value="bullet"></button>
                                            <button class="ql-indent" value="-1"></button>
                                            <button class="ql-indent" value="+1"></button>
                                        </span>
                                        <span class="ql-formats">
                                            <button class="ql-direction" value="rtl"></button>
                                            <select class="ql-align"></select>
                                        </span>
                                        <span class="ql-formats">
                                            <button class="ql-link"></button>
                                            <button class="ql-image"></button>
                                            <button class="ql-video"></button>
                                            <button class="ql-formula"></button>
                                        </span>
                                        <span class="ql-formats">
                                            <button class="ql-clean"></button>
                                        </span>
                                    </div>
                                    <div id="editor" style="min-height:200px;"></div>
                                    <input type="hidden" name="content" id="content-hidden" />
                                </div>
                            </div>
                        </div>
                        <div>
                            <label class="form-label fw-bold text-neutral-900">Upload Thumbnail <span class="text-danger">*</span></label>
                            <input type="file" class="form-control border border-neutral-200 radius-8" name="featureImage" id="featureImage" accept="image/*" required>
                        </div>
                        <button type="submit" class="btn btn-primary-600 radius-8">Submit</button>
                    </form>
                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />

        <script src="${pageContext.request.contextPath}/assets/admin/js/editor.highlighted.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/js/editor.quill.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/js/editor.katex.min.js"></script>

        <script>
            // Editor Js Start
            const quill = new Quill('#editor', {
                modules: {
                    syntax: true,
                    toolbar: '#toolbar-container',
                },
                placeholder: 'Compose an epic...',
                theme: 'snow',
            });
            // On submit, copy content to hidden input
            document.querySelector('form').addEventListener('submit', function(e) {
                document.getElementById('content-hidden').value = quill.root.innerHTML;
            });


            // =============================== Upload Single Image js start here ================================================
            const fileInput = document.getElementById("upload-file");
            const imagePreview = document.getElementById("uploaded-img__preview");
            const uploadedImgContainer = document.querySelector(".uploaded-img");
            const removeButton = document.querySelector(".uploaded-img__remove");

            fileInput.addEventListener("change", (e) => {
                if (e.target.files.length) {
                    const src = URL.createObjectURL(e.target.files[0]);
                    imagePreview.src = src;
                    uploadedImgContainer.classList.remove('d-none');
                }
            });
            removeButton.addEventListener("click", () => {
                imagePreview.src = "";
                uploadedImgContainer.classList.add('d-none');
                fileInput.value = "";
            });
            // =============================== Upload Single Image js End here ================================================

        </script>

    </body>

    <!-- Mirrored from wowdash.wowtheme7.com/demo/add-blog.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 03 Feb 2025 04:44:36 GMT -->
</html>
