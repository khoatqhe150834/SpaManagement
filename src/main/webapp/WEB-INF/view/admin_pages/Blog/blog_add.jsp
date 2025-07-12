<%-- 
    Document   : blog_add
    Created on : Jun 18, 2025, 3:26:59 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Blog - Spa Hương Sen</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: "#D4AF37",
                        "primary-dark": "#B8941F",
                        secondary: "#FADADD",
                        "spa-cream": "#FFF8F0",
                        "spa-dark": "#333333",
                        "spa-gray": "#F3F4F6",
                    },
                    fontFamily: {
                        sans: ["Roboto", "sans-serif"],
                    },
                },
            },
        };
    </script>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
    <!-- Quill Editor -->
    <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
    <style>
        .ql-container.is-invalid {
            border: 1px solid #dc3545 !important;
            border-radius: 8px;
        }
        .ql-toolbar {
            border-top-left-radius: 8px;
            border-top-right-radius: 8px;
        }
        .ql-container {
            border-bottom-left-radius: 8px;
            border-bottom-right-radius: 8px;
        }
    </style>
</head>
<body class="bg-spa-cream font-sans text-spa-dark min-h-screen">
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
    <main class="w-full md:w-[calc(100%-256px)] md:ml-64 bg-white min-h-screen transition-all">
        <div class="p-6 bg-spa-cream min-h-screen">
            <!-- Header & Breadcrumb -->
            <div class="flex items-center justify-between mb-8">
                <div>
                    <h1 class="text-2xl font-bold text-spa-dark">Thêm Blog</h1>
                    <nav class="text-sm text-gray-500 flex items-center space-x-2 mt-1">
                        <a href="${pageContext.request.contextPath}/dashboard" class="hover:text-primary">Dashboard</a>
                        <span>/</span>
                        <a href="${pageContext.request.contextPath}/blog" class="hover:text-primary">Blog</a>
                        <span>/</span>
                        <span>Thêm mới</span>
                    </nav>
                </div>
                <a href="${pageContext.request.contextPath}/blog" 
                   class="px-4 py-2 bg-gray-200 text-spa-dark rounded-lg hover:bg-primary hover:text-white font-semibold flex items-center gap-2">
                    <i data-lucide="arrow-left" class="h-5 w-5"></i> Quay lại
                </a>
            </div>
            <div class="max-w-4xl mx-auto">
                <div class="bg-white rounded-xl shadow-lg p-8">
                    <!-- Alert Messages -->
                    <c:if test="${not empty error}">
                        <div class="bg-red-50 border-l-4 border-red-400 p-4 mb-6">
                            <div class="flex">
                                <div class="flex-shrink-0">
                                    <i data-lucide="alert-circle" class="h-5 w-5 text-red-400"></i>
                                </div>
                                <div class="ml-3">
                                    <p class="text-sm text-red-700">${error}</p>
                                </div>
                            </div>
                        </div>
                    </c:if>
                    <form action="${pageContext.request.contextPath}/blog?action=add" method="post" enctype="multipart/form-data" class="space-y-6" id="blogAddForm" novalidate>
                        <!-- Title -->
                        <div>
                            <label class="block text-sm font-semibold text-spa-dark mb-2" for="title">
                                Tiêu đề <span class="text-red-500">*</span>
                            </label>
                            <input type="text" 
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent transition-colors" 
                                   id="title" name="title" 
                                   placeholder="Nhập tiêu đề blog...">
                            <div class="text-red-500 text-sm mt-1 hidden" id="titleError"></div>
                        </div>
                        <!-- Summary -->
                        <div>
                            <label class="block text-sm font-semibold text-spa-dark mb-2" for="summary">
                                Tóm tắt <span class="text-red-500">*</span>
                            </label>
                            <textarea class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent transition-colors resize-none" 
                                      id="summary" name="summary" 
                                      rows="3" 
                                      placeholder="Tóm tắt ngắn gọn về nội dung blog..."></textarea>
                            <div class="text-red-500 text-sm mt-1 hidden" id="summaryError"></div>
                        </div>
                        <!-- Category -->
                        <div>
                            <label class="block text-sm font-semibold text-spa-dark mb-2" for="category">
                                Danh mục <span class="text-red-500">*</span>
                            </label>
                            <select class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent transition-colors" 
                                    name="category" id="category">
                                <option value="">Chọn danh mục</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.categoryId}">${cat.name}</option>
                                </c:forEach>
                            </select>
                            <div class="text-red-500 text-sm mt-1 hidden" id="categoryError"></div>
                        </div>
                        <!-- Content -->
                        <div>
                            <label class="block text-sm font-semibold text-spa-dark mb-2">
                                Nội dung <span class="text-red-500">*</span>
                            </label>
                            <div class="border border-gray-300 rounded-lg overflow-hidden">
                                <div id="toolbar-container" class="border-b border-gray-300 bg-gray-50 p-2">
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
                                    </span>
                                    <span class="ql-formats">
                                        <button class="ql-clean"></button>
                                    </span>
                                </div>
                                <div id="editor" style="min-height: 300px; max-height: 500px; overflow-y: auto;"></div>
                                <input type="hidden" name="content" id="content-hidden" />
                            </div>
                            <div class="text-red-500 text-sm mt-1 hidden" id="contentError"></div>
                        </div>
                        <!-- Image Upload -->
                        <div>
                            <label class="block text-sm font-semibold text-spa-dark mb-2" for="featureImage">
                                Ảnh đại diện <span class="text-red-500">*</span>
                            </label>
                            <input type="file" 
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent transition-colors" 
                                   name="featureImage" id="featureImage" 
                                   accept="image/*">
                            <div class="text-red-500 text-sm mt-1 hidden" id="imageError"></div>
                        </div>
                        <!-- Submit Button -->
                        <div class="flex justify-end pt-6 border-t border-gray-200">
                            <button type="submit" 
                                    class="px-6 py-3 bg-primary text-white rounded-lg hover:bg-primary-dark font-semibold flex items-center gap-2 transition-colors">
                                <i data-lucide="save" class="h-5 w-5"></i>
                                Thêm Blog
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            lucide.createIcons();
            // Editor Js Start
            const quill = new Quill('#editor', {
                modules: {
                    syntax: true,
                    toolbar: '#toolbar-container',
                },
                placeholder: 'Compose an epic...',
                theme: 'snow',
            });
            document.getElementById('blogAddForm').addEventListener('submit', async function(e) {
                e.preventDefault();
                let hasError = false;
                // Title
                const title = document.getElementById('title');
                const titleError = document.getElementById('titleError');
                if (isOnlyWhitespace(title.value)) {
                    title.classList.add('border-red-500', 'focus:border-red-500', 'focus:ring-red-500');
                    titleError.textContent = 'Title không được để trống hoặc chỉ chứa khoảng trắng.';
                    titleError.classList.remove('hidden');
                    hasError = true;
                } else if (title.value.trim().length < 5) {
                    title.classList.add('border-red-500', 'focus:border-red-500', 'focus:ring-red-500');
                    titleError.textContent = 'Title must be at least 5 characters.';
                    titleError.classList.remove('hidden');
                    hasError = true;
                } else if (title.value.trim().length > 100) {
                    title.classList.add('border-red-500', 'focus:border-red-500', 'focus:ring-red-500');
                    titleError.textContent = 'Title must be at most 100 characters.';
                    titleError.classList.remove('hidden');
                    hasError = true;
                } else {
                    title.classList.remove('border-red-500', 'focus:border-red-500', 'focus:ring-red-500');
                    titleError.textContent = '';
                    titleError.classList.add('hidden');
                }
                // Title duplicate check
                if (title.value.trim()) {
                    const isDup = await checkTitleDuplicate(title.value);
                    if (isDup) {
                        title.classList.add('border-red-500', 'focus:border-red-500', 'focus:ring-red-500');
                        titleError.textContent = 'Title đã tồn tại, vui lòng chọn tiêu đề khác.';
                        titleError.classList.remove('hidden');
                        hasError = true;
                    }
                }
                // Summary
                const summary = document.getElementById('summary');
                const summaryError = document.getElementById('summaryError');
                if (isOnlyWhitespace(summary.value)) {
                    summary.classList.add('border-red-500', 'focus:border-red-500', 'focus:ring-red-500');
                    summaryError.textContent = 'Summary không được để trống hoặc chỉ chứa khoảng trắng.';
                    summaryError.classList.remove('hidden');
                    hasError = true;
                } else if (summary.value.trim().length < 10) {
                    summary.classList.add('border-red-500', 'focus:border-red-500', 'focus:ring-red-500');
                    summaryError.textContent = 'Summary must be at least 10 characters.';
                    summaryError.classList.remove('hidden');
                    hasError = true;
                } else if (summary.value.trim().length > 255) {
                    summary.classList.add('border-red-500', 'focus:border-red-500', 'focus:ring-red-500');
                    summaryError.textContent = 'Summary must be at most 255 characters.';
                    summaryError.classList.remove('hidden');
                    hasError = true;
                } else {
                    summary.classList.remove('border-red-500', 'focus:border-red-500', 'focus:ring-red-500');
                    summaryError.textContent = '';
                    summaryError.classList.add('hidden');
                }
                // Category
                const category = document.getElementById('category');
                const categoryError = document.getElementById('categoryError');
                const validCategoryValues = Array.from(category.options).map(opt => opt.value).filter(v => v);
                if (!category.value || !validCategoryValues.includes(category.value)) {
                    category.classList.add('border-red-500', 'focus:border-red-500', 'focus:ring-red-500');
                    categoryError.textContent = 'Please select a valid category.';
                    categoryError.classList.remove('hidden');
                    hasError = true;
                } else {
                    category.classList.remove('border-red-500', 'focus:border-red-500', 'focus:ring-red-500');
                    categoryError.textContent = '';
                    categoryError.classList.add('hidden');
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
                    contentError.classList.remove('hidden');
                    hasError = true;
                } else if (quillText.length < 10) {
                    contentError.textContent = 'Content must be at least 10 characters.';
                    quillContainer.classList.add('is-invalid');
                    contentError.classList.remove('hidden');
                    hasError = true;
                } else if (quillText.length > 5000) {
                    contentError.textContent = 'Content must be at most 5000 characters.';
                    quillContainer.classList.add('is-invalid');
                    contentError.classList.remove('hidden');
                    hasError = true;
                } else {
                    contentError.textContent = '';
                    quillContainer.classList.remove('is-invalid');
                    contentError.classList.add('hidden');
                }
                // Image
                const image = document.getElementById('featureImage');
                const imageError = document.getElementById('imageError');
                if (image.files && image.files[0]) {
                    const file = image.files[0];
                    const validTypes = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
                    if (!validTypes.includes(file.type)) {
                        image.classList.add('border-red-500', 'focus:border-red-500', 'focus:ring-red-500');
                        imageError.textContent = 'Image must be JPG, PNG, WEBP, or GIF.';
                        imageError.classList.remove('hidden');
                        hasError = true;
                    } else if (file.size > 2 * 1024 * 1024) {
                        image.classList.add('border-red-500', 'focus:border-red-500', 'focus:ring-red-500');
                        imageError.textContent = 'Image must be less than 2MB.';
                        imageError.classList.remove('hidden');
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
                                image.classList.add('border-red-500', 'focus:border-red-500', 'focus:ring-red-500');
                                imageError.textContent = 'File không phải là ảnh hợp lệ.';
                                imageError.classList.remove('hidden');
                                hasError = true;
                            } else {
                                image.classList.remove('border-red-500', 'focus:border-red-500', 'focus:ring-red-500');
                                imageError.textContent = '';
                                imageError.classList.add('hidden');
                            }
                        };
                        fr.readAsArrayBuffer(file.slice(0, 4));
                    }
                } else {
                    image.classList.add('border-red-500', 'focus:border-red-500', 'focus:ring-red-500');
                    imageError.textContent = 'Vui lòng tải lên ảnh đại diện.';
                    imageError.classList.remove('hidden');
                    hasError = true;
                }
                if (!hasError) {
                    this.submit();
                }
            });
            // AJAX check title duplicate
            async function checkTitleDuplicate(title) {
                if (!title.trim()) return false;
                const resp = await fetch(`${pageContext.request.contextPath}/blog?action=checkTitle&title=` + encodeURIComponent(title.trim()));
                if (!resp.ok) return false;
                const data = await resp.json();
                return data.duplicate === true;
            }
            document.getElementById('title').addEventListener('blur', async function() {
                const title = this.value.trim();
                if (title) {
                    const isDup = await checkTitleDuplicate(title);
                    if (isDup) {
                        this.classList.add('border-red-500', 'focus:border-red-500', 'focus:ring-red-500');
                        document.getElementById('titleError').textContent = 'Title đã tồn tại, vui lòng chọn tiêu đề khác.';
                        document.getElementById('titleError').classList.remove('hidden');
                    }
                }
            });
            function isOnlyWhitespace(str) {
                return !str || str.trim().length === 0;
            }
        });
    </script>
    <!-- Quill/Highlight/KaTeX custom scripts for advanced editor features -->
    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
    <script src="${pageContext.request.contextPath}/assets/admin/js/editor.highlighted.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/js/editor.quill.js"></script>
    <script src="${pageContext.request.contextPath}/assets/admin/js/editor.katex.min.js"></script>
</body>
</html>
