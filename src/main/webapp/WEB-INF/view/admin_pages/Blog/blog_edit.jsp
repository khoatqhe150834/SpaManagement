<%-- 
    Document   : blog_edit
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
        <style>
            .ql-container.is-invalid {
                border: 1px solid #dc3545 !important;
                border-radius: 8px;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />



        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <div class="d-flex align-items-center gap-2">
                    <a href="${pageContext.request.contextPath}/blog?id=${blog.blogId}" class="btn btn-secondary radius-8 d-flex align-items-center gap-1">
                        <iconify-icon icon="ep:back" class="text-lg"></iconify-icon>
                        Thoát
                    </a>
                    <h6 class="fw-semibold mb-0 ms-3">Edit Blog</h6>
                </div>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Dashboard
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Edit Blog</li>
                </ul>
            </div>

            <div class="row gy-4">
                <div class="col-lg-12">
                    <div class="card mt-24">
                        <div class="card-body p-24">
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger mb-16">${error}</div>
                            </c:if>
                            <c:if test="${not empty success}">
                                <div class="alert alert-success mb-16">${success}</div>
                            </c:if>
                            <form action="${pageContext.request.contextPath}/blog?action=edit&id=${blog.blogId}" method="post" enctype="multipart/form-data" class="d-flex flex-column gap-20" id="blogEditForm" novalidate>
                                <div>
                                    <label class="form-label fw-bold text-neutral-900" for="title">Title <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control border border-neutral-200 radius-8" id="title" name="title" placeholder="Enter Post Title" value="${blog.title}">
                                    <div class="invalid-feedback" id="titleError"></div>
                                </div>
                                <div>
                                    <label class="form-label fw-bold text-neutral-900" for="summary">Summary <span class="text-danger">*</span></label>
                                    <textarea class="form-control border border-neutral-200 radius-8" id="summary" name="summary" rows="2" placeholder="Short summary...">${blog.summary}</textarea>
                                    <div class="invalid-feedback" id="summaryError"></div>
                                </div>
                                <div>
                                    <label class="form-label fw-bold text-neutral-900">Category <span class="text-danger">*</span></label>
                                    <select class="form-control border border-neutral-200 radius-8" name="category" id="category">
                                        <option value="">Select category</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.categoryId}" <c:if test="${selectedCategoryIds != null && selectedCategoryIds.contains(cat.categoryId)}">selected</c:if>>${cat.name}</option>
                                        </c:forEach>
                                    </select>
                                    <div class="invalid-feedback" id="categoryError"></div>
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
                                            <div class="invalid-feedback" id="contentError"></div>
                                        </div>
                                    </div>
                                </div>

                                <div>
                                    <label class="form-label fw-bold text-neutral-900">Upload Thumbnail <span class="text-danger">*</span></label>
                                    <input type="file" class="form-control border border-neutral-200 radius-8" name="featureImage" id="featureImage" accept="image/*">
                                    <div class="invalid-feedback" id="imageError"></div>
                                    <c:if test="${not empty blog.featureImageUrl}">
                                        <div class="mt-2">
                                            <img src="${pageContext.request.contextPath}/${blog.featureImageUrl}" alt="Current Image" style="max-width: 200px; max-height: 120px; border-radius: 8px;" />
                                            <span class="text-sm text-neutral-500 ms-2">Current image</span>
                                        </div>
                                    </c:if>
                                </div>

                                <button type="submit" class="btn btn-primary-600 radius-8">Update</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />

        <script src="${pageContext.request.contextPath}/assets/admin/js/editor.highlighted.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/js/editor.quill.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/js/editor.katex.min.js"></script>

        <script>
            const blogId = ${blog.blogId};
            // Editor Js Start
            const quill = new Quill('#editor', {
                modules: {
                    syntax: true,
                    toolbar: '#toolbar-container',
                },
                placeholder: 'Compose an epic...',
                theme: 'snow',
            });
            // Set initial content
            quill.root.innerHTML = `${blog.content}`;
            // On submit, copy content to hidden input
            document.getElementById('blogEditForm').addEventListener('submit', async function(e) {
                e.preventDefault();
                let hasError = false;
                // Title
                const title = document.getElementById('title');
                const titleError = document.getElementById('titleError');
                if (isOnlyWhitespace(title.value)) {
                    title.classList.add('is-invalid');
                    titleError.textContent = 'Title không được để trống hoặc chỉ chứa khoảng trắng.';
                    hasError = true;
                } else if (title.value.trim().length < 5) {
                    title.classList.add('is-invalid');
                    titleError.textContent = 'Title must be at least 5 characters.';
                    hasError = true;
                } else if (title.value.trim().length > 100) {
                    title.classList.add('is-invalid');
                    titleError.textContent = 'Title must be at most 100 characters.';
                    hasError = true;
                } else {
                    title.classList.remove('is-invalid');
                    titleError.textContent = '';
                }
                // Title duplicate check
                if (title.value.trim()) {
                    const isDup = await checkTitleDuplicate(title.value);
                    if (isDup) {
                        title.classList.add('is-invalid');
                        titleError.textContent = 'Title đã tồn tại, vui lòng chọn tiêu đề khác.';
                        hasError = true;
                    }
                }
                // Summary
                const summary = document.getElementById('summary');
                const summaryError = document.getElementById('summaryError');
                if (isOnlyWhitespace(summary.value)) {
                    summary.classList.add('is-invalid');
                    summaryError.textContent = 'Summary không được để trống hoặc chỉ chứa khoảng trắng.';
                    hasError = true;
                } else if (summary.value.trim().length < 10) {
                    summary.classList.add('is-invalid');
                    summaryError.textContent = 'Summary must be at least 10 characters.';
                    hasError = true;
                } else if (summary.value.trim().length > 255) {
                    summary.classList.add('is-invalid');
                    summaryError.textContent = 'Summary must be at most 255 characters.';
                    hasError = true;
                } else {
                    summary.classList.remove('is-invalid');
                    summaryError.textContent = '';
                }
                // Category
                const category = document.getElementById('category');
                const categoryError = document.getElementById('categoryError');
                const validCategoryValues = Array.from(category.options).map(opt => opt.value).filter(v => v);
                if (!category.value || !validCategoryValues.includes(category.value)) {
                    category.classList.add('is-invalid');
                    categoryError.textContent = 'Please select a valid category.';
                    hasError = true;
                } else {
                    category.classList.remove('is-invalid');
                    categoryError.textContent = '';
                }
                // Content (Quill)
                const contentHidden = document.getElementById('content-hidden');
                const contentError = document.getElementById('contentError');
                const quillText = quill.getText().trim();
                const quillHtml = quill.root.innerHTML;
                contentHidden.value = quillHtml;
                const quillContainer = document.querySelector('.ql-container');
                if (isOnlyWhitespace(quillText)) {
                    contentError.textContent = 'Content không được để trống hoặc chỉ chứa khoảng trắng.';
                    quillContainer.classList.add('is-invalid');
                    hasError = true;
                } else if (quillText.length < 10) {
                    contentError.textContent = 'Content must be at least 10 characters.';
                    quillContainer.classList.add('is-invalid');
                    hasError = true;
                } else if (quillText.length > 5000) {
                    contentError.textContent = 'Content must be at most 5000 characters.';
                    quillContainer.classList.add('is-invalid');
                    hasError = true;
                } else {
                    contentError.textContent = '';
                    quillContainer.classList.remove('is-invalid');
                }
                // Image
                const image = document.getElementById('featureImage');
                const imageError = document.getElementById('imageError');
                if (image.files && image.files[0]) {
                    const file = image.files[0];
                    const validTypes = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
                    if (!validTypes.includes(file.type)) {
                        image.classList.add('is-invalid');
                        imageError.textContent = 'Image must be JPG, PNG, WEBP, or GIF.';
                        hasError = true;
                    } else if (file.size > 2 * 1024 * 1024) {
                        image.classList.add('is-invalid');
                        imageError.textContent = 'Image must be less than 2MB.';
                        hasError = true;
                    } else {
                        // Kiểm tra file thực sự là ảnh bằng FileReader
                        const fr = new FileReader();
                        fr.onload = function(e) {
                            const arr = new Uint8Array(e.target.result).subarray(0, 4);
                            let header = '';
                            for(let i = 0; i < arr.length; i++) header += arr[i].toString(16);
                            // Kiểm tra magic number của file ảnh phổ biến
                            const isImage = (
                                header.startsWith('ffd8') || // jpg
                                header.startsWith('89504e47') || // png
                                header.startsWith('47494638') || // gif
                                header.startsWith('52494646') // webp
                            );
                            if (!isImage) {
                                image.classList.add('is-invalid');
                                imageError.textContent = 'File không phải là ảnh hợp lệ.';
                                hasError = true;
                            } else {
                                image.classList.remove('is-invalid');
                                imageError.textContent = '';
                            }
                        };
                        fr.readAsArrayBuffer(file.slice(0, 4));
                    }
                } else {
                    image.classList.remove('is-invalid');
                    imageError.textContent = '';
                }
                if (!hasError) {
                    this.submit();
                }
            });
            // AJAX check title duplicate
            async function checkTitleDuplicate(title) {
                if (!title.trim()) return false;
                const resp = await fetch(`${pageContext.request.contextPath}/blog?action=checkTitle&title=` + encodeURIComponent(title.trim()) + '&excludeId=' + blogId);
                if (!resp.ok) return false;
                const data = await resp.json();
                return data.duplicate === true;
            }
            document.getElementById('title').addEventListener('blur', async function() {
                const title = this.value.trim();
                if (title) {
                    const isDup = await checkTitleDuplicate(title);
                    if (isDup) {
                        this.classList.add('is-invalid');
                        document.getElementById('titleError').textContent = 'Title đã tồn tại, vui lòng chọn tiêu đề khác.';
                    }
                }
            });
            function isOnlyWhitespace(str) {
                return !str || str.trim().length === 0;
            }
            function containsDangerousChars(str) {
                // Chỉ loại các ký tự: < > { } [ ] | ` ~ ^ $ % \
                return /[<>\{\}\[\]\|`~^$%\\]/.test(str);
            }
        </script>

    </body>

    <!-- Mirrored from wowdash.wowtheme7.com/demo/add-blog.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 03 Feb 2025 04:44:36 GMT -->
</html>
