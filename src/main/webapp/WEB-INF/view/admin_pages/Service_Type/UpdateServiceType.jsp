<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi" class="scroll-smooth">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Cập nhật Loại Dịch Vụ</title>
            <!-- jQuery CDN -->
            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
                    },
                    fontFamily: {
                      serif: ["Playfair Display", "serif"],
                      sans: ["Roboto", "sans-serif"],
                    },
                  },
                },
              };
            </script>
            <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet" />
            <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
            <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
        </head>

        <body class="bg-spa-cream font-sans min-h-screen">
            <jsp:include page="/WEB-INF/view/common/header.jsp" />
            <div class="flex">
                <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
                <main class="flex-1 py-12 lg:py-20 ml-64">
                    <div class="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8">
                        <div class="mb-8 flex items-center justify-between">
                            <h1 class="text-2xl font-serif text-spa-dark font-bold">Cập nhật Loại Dịch Vụ</h1>
                            <a href="servicetype?service=list-all&page=${page}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}"
                               class="inline-flex items-center gap-2 h-10 px-4 bg-gray-200 text-spa-dark font-semibold rounded-lg hover:bg-gray-300 transition-colors">
                                <i data-lucide="arrow-left" class="w-5 h-5"></i>
                                <span>Quay lại</span>
                            </a>
                        </div>
                        <form action="servicetype" method="post" enctype="multipart/form-data" id="serviceTypeForm" novalidate class="bg-white rounded-2xl shadow-lg p-8 space-y-6">
                            <input type="hidden" name="service" value="update" />
                            <input type="hidden" name="id" value="${stype.serviceTypeId}" />
                            <!-- Name -->
                            <div>
                                <label for="name" class="block text-sm font-medium text-spa-dark mb-2">Tên Loại Dịch Vụ <span class="text-red-500">*</span></label>
                                <input type="text" name="name" id="name" maxlength="200" required placeholder="Nhập tên loại dịch vụ" value="${stype.name}" class="block w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-primary" />
                                <div class="flex justify-between items-center mt-1">
                                    <div class="text-red-500 text-xs" id="nameError"></div>
                                    <small class="text-gray-400 ml-auto" id="nameCharCount">0/200</small>
                                </div>
                            </div>
                            <!-- Description -->
                            <div>
                                <label for="description" class="block text-sm font-medium text-spa-dark mb-2">Mô tả <span class="text-red-500">*</span></label>
                                <textarea name="description" id="description" rows="5" placeholder="Nhập mô tả..." class="block w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-primary">${stype.description}</textarea>
                                <div class="flex justify-between items-center mt-1">
                                    <div class="text-red-500 text-xs" id="descriptionError"></div>
                                    <small class="text-gray-400 ml-auto" id="descCharCount">0/500</small>
                                </div>
                                <small class="text-gray-500">Tối thiểu 20 ký tự, tối đa 500 ký tự</small>
                            </div>
                            <!-- Image -->
                            <div>
                                <label for="image" class="block text-sm font-medium text-spa-dark mb-2">Hình Ảnh</label>
                                <input type="file" name="image" id="image" accept="image/jpeg,image/png,image/gif" class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-primary file:text-white hover:file:bg-primary-dark" onchange="validateImageAsync(this);">
                                <div id="imagePreview" class="mt-2${empty stype.imageUrl ? ' hidden' : ''}">
                                    <c:if test="${not empty stype.imageUrl}">
                                        <img src="${pageContext.request.contextPath}${stype.imageUrl}" alt="Preview" class="w-32 h-32 object-cover rounded-lg border" id="previewImg" onclick="showImageModal(this.src)" style="cursor:pointer;">
                                    </c:if>
                                </div>
                                <div class="text-red-500 text-xs mt-1" id="imageError"></div>
                                <small class="text-gray-500">Chọn ảnh mới nếu muốn thay đổi. Nếu không chọn, sẽ giữ ảnh cũ.<br>Chấp nhận: JPG, PNG, GIF. Kích thước tối đa: 2MB. Kích thước tối thiểu: 200x200px</small>
                            </div>
                            <!-- Status -->
                            <div>
                                <label class="block text-sm font-medium text-spa-dark mb-2">Trạng thái</label>
                                <label class="inline-flex items-center cursor-pointer select-none">
                                    <input type="checkbox" name="is_active" id="is_active" class="sr-only peer" ${stype.active ? "checked" : "" }>
                                    <div class="w-11 h-6 bg-gray-200 rounded-full transition-colors duration-300 relative peer-checked:bg-primary">
                                        <span class="absolute left-1 top-1 w-4 h-4 bg-white rounded-full shadow transition-transform duration-300 peer-checked:translate-x-[20px]"></span>
                                    </div>
                                    <span class="ml-3 text-sm text-spa-dark">Đang hoạt động</span>
                                </label>
                            </div>
                            <!-- Action Buttons -->
                            <div class="flex items-center justify-center gap-4 mt-6">
                                <a href="servicetype?service=list-all&page=${page}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}"
                                   class="inline-flex items-center justify-center px-6 py-2 border border-gray-300 rounded-lg text-gray-700 bg-gray-100 hover:bg-gray-200 font-semibold">Cancel</a>
                                <button type="submit" class="inline-flex items-center justify-center px-6 py-2 rounded-lg bg-primary text-white font-semibold hover:bg-primary-dark transition-colors">Update</button>
                            </div>
                        </form>
                    </div>
                </main>
            </div>
            <jsp:include page="/WEB-INF/view/common/footer.jsp" />
            <!-- Modal hiển thị ảnh lớn -->
            <div id="imageModal" style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100vw; height:100vh; background:rgba(0,0,0,0.8); align-items:center; justify-content:center;">
                <img id="modalImg" src="" style="max-width:90vw; max-height:90vh; border:4px solid #fff; border-radius:8px;">
            </div>
            <script>
                var contextPath = "${pageContext.request.contextPath}";

                // --- Helper functions for Tailwind border color ---
                function setInvalid(input, errorDiv, msg) {
                    input.classList.remove('border-green-500', 'focus:ring-green-500', 'border-gray-300', 'focus:ring-primary');
                    input.classList.add('border-red-500', 'focus:ring-red-500');
                    errorDiv.textContent = msg;
                    errorDiv.style.color = 'red';
                }
                function setValid(input, errorDiv, msg) {
                    input.classList.remove('border-red-500', 'focus:ring-red-500', 'border-gray-300', 'focus:ring-primary');
                    input.classList.add('border-green-500', 'focus:ring-green-500');
                    errorDiv.textContent = msg;
                    errorDiv.style.color = 'green';
                }
                function setDefault(input, errorDiv) {
                    input.classList.remove('border-red-500', 'focus:ring-red-500', 'border-green-500', 'focus:ring-green-500');
                    input.classList.add('border-gray-300', 'focus:ring-primary');
                    errorDiv.textContent = '';
                }

                // --- Character count functions ---
                function updateCharCount(input, counterId, maxLength) {
                    try {
                        const counter = document.getElementById(counterId);
                        if (!counter) {
                            console.error('Counter element not found:', counterId);
                            return;
                        }
                        if (!input) {
                            console.error('Input element not found');
                            return;
                        }
                        
                        const value = input.value || "";
                        const currentLength = value.length;
                        const displayText = currentLength + '/' + maxLength;
                        
                        counter.textContent = displayText;
                        
                        if (currentLength > maxLength * 0.8) {
                            counter.style.color = '#f59e0b';
                        } else if (currentLength > maxLength) {
                            counter.style.color = '#f44336';
                        } else {
                            counter.style.color = '#6b7280';
                        }
                    } catch (error) {
                        console.error('Error in updateCharCount:', error);
                    }
                }

                // --- Validate Name ---
                function validateName(input) {
                    const vietnameseNamePattern = /^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s]+$/;
                    const value = input.value.trim();
                    const errorDiv = document.getElementById('nameError');
                    if (value === '') {
                        setInvalid(input, errorDiv, 'Tên không được để trống');
                        return false;
                    }
                    if (value.length < 2) {
                        setInvalid(input, errorDiv, 'Tên phải có ít nhất 2 ký tự');
                        return false;
                    }
                    if (value.length > 200) {
                        setInvalid(input, errorDiv, 'Tên không được vượt quá 200 ký tự');
                        return false;
                    }
                    if (!vietnameseNamePattern.test(value)) {
                        setInvalid(input, errorDiv, 'Tên chỉ được chứa chữ cái và khoảng trắng (cho phép tiếng Việt có dấu)');
                        return false;
                    }
                    setValid(input, errorDiv, 'Tên hợp lệ');
                    return true;
                }

                // --- Validate Description ---
                function validateDescription(input) {
                    const errorDiv = document.getElementById('descriptionError');
                    let value = input.value.trim();
                    if (value.length < 20) {
                        setInvalid(input, errorDiv, 'Mô tả phải có ít nhất 20 ký tự');
                        return false;
                    }
                    if (value.length > 500) {
                        setInvalid(input, errorDiv, 'Mô tả không được vượt quá 500 ký tự');
                        return false;
                    }
                    setValid(input, errorDiv, 'Mô tả hợp lệ');
                    return true;
                }

                // --- Validate Image (giữ nguyên logic, chỉ update class nếu có lỗi) ---
                async function validateImageAsync(input) {
                    return new Promise((resolve) => {
                        const imageError = document.getElementById('imageError');
                        const file = input.files[0];
                        if (!file) {
                            setDefault(input, imageError);
                            resolve(true);
                            return;
                        }
                        if (file.size > 2 * 1024 * 1024) {
                            setInvalid(input, imageError, 'Không được upload ảnh quá 2MB.');
                            resolve(false);
                            return;
                        }
                        const validTypes = ['image/jpeg', 'image/png', 'image/gif'];
                        if (!validTypes.includes(file.type)) {
                            setInvalid(input, imageError, 'Chỉ chấp nhận file JPG, PNG hoặc GIF.');
                            resolve(false);
                            return;
                        }
                        const img = new Image();
                        img.onload = function () {
                            if (this.width < 200 || this.height < 200) {
                                setInvalid(input, imageError, 'Kích thước ảnh phải tối thiểu 200x200px. Ảnh bạn chọn là ' + this.width + 'x' + this.height + 'px.');
                                resolve(false);
                                return;
                            }
                            setValid(input, imageError, '');
                            previewImage(input);
                            resolve(true);
                        };
                        img.onerror = () => {
                            setInvalid(input, imageError, 'Ảnh không hợp lệ hoặc bị lỗi');
                            resolve(false);
                        };
                        img.src = URL.createObjectURL(file);
                    });
                }

                // --- Preview Image (giữ nguyên) ---
                function previewImage(input) {
                    const preview = document.getElementById('imagePreview');
                    const previewImg = document.getElementById('previewImg');
                    if (input.files && input.files[0]) {
                        const reader = new FileReader();
                        reader.onload = function (e) {
                            previewImg.src = e.target.result;
                            preview.classList.remove('hidden');
                        }
                        reader.readAsDataURL(input.files[0]);
                    } else {
                        preview.classList.add('hidden');
                    }
                }

                // --- Show Image Modal (giữ nguyên) ---
                function showImageModal(src) {
                    const modal = document.getElementById('imageModal');
                    const modalImg = document.getElementById('modalImg');
                    modal.style.display = 'flex';
                    modalImg.src = src;
                }
                document.getElementById('imageModal').onclick = function () {
                    this.style.display = 'none';
                };

                // --- Real-time validate event binding ---
                document.addEventListener('DOMContentLoaded', function () {
                    const nameInput = document.getElementById('name');
                    const descInput = document.getElementById('description');
                    const imageInput = document.getElementById('image');

                    // Initialize character counts on page load
                    updateCharCount(nameInput, 'nameCharCount', 200);
                    updateCharCount(descInput, 'descCharCount', 500);

                    nameInput.addEventListener('input', function () {
                        updateCharCount(this, 'nameCharCount', 200);
                        if (validateName(this)) {
                            checkNameDuplicate(this.value.trim(), function (isDuplicate, msg) {
                                if (isDuplicate) {
                                    setInvalid(nameInput, document.getElementById('nameError'), msg || 'Tên này đã tồn tại trong hệ thống');
                                } else {
                                    setValid(nameInput, document.getElementById('nameError'), 'Tên hợp lệ');
                                }
                            });
                        }
                    });
                    nameInput.addEventListener('blur', function () {
                        this.value = this.value.replace(/\s+/g, ' ').trim();
                        updateCharCount(this, 'nameCharCount', 200);
                        if (validateName(this)) {
                            checkNameDuplicate(this.value.trim(), function (isDuplicate, msg) {
                                if (isDuplicate) {
                                    setInvalid(nameInput, document.getElementById('nameError'), msg || 'Tên này đã tồn tại trong hệ thống');
                                } else {
                                    setValid(nameInput, document.getElementById('nameError'), 'Tên hợp lệ');
                                }
                            });
                        }
                    });
                    descInput.addEventListener('input', function () {
                        updateCharCount(this, 'descCharCount', 500);
                        validateDescription(this);
                    });
                    descInput.addEventListener('blur', function () {
                        this.value = this.value.replace(/\s+/g, ' ').trim();
                        updateCharCount(this, 'descCharCount', 500);
                        validateDescription(this);
                    });
                    imageInput.addEventListener('change', async function () {
                        await validateImageAsync(this);
                    });
                });

                // --- AJAX checkNameDuplicate giữ nguyên, chỉ gọi sau khi validateName ok ---
                function checkNameDuplicate(name, callback) {
                    var id = document.querySelector('input[name="id"]').value;
                    var data = { service: 'check-duplicate-name', name: name };
                    if (id) data.id = id;
                    $.ajax({
                        url: contextPath + '/manager/servicetype',
                        type: 'GET',
                        data: data,
                        dataType: 'json',
                        success: function (response) {
                            callback(!response.valid, response.message);
                        },
                        error: function () {
                            callback(false, 'Không thể kiểm tra tên. Vui lòng thử lại.');
                        }
                    });
                }

                // --- Form submit giữ nguyên, chỉ validate lại class ---
                $('form').on('submit', async function (e) {
                    e.preventDefault();
                    let nameValue = $('#name').val();
                    nameValue = nameValue.replace(/\s+/g, ' ').trim();
                    $('#name').val(nameValue);
                    const nameValid = validateName(document.getElementById('name'));
                    const descValid = validateDescription(document.getElementById('description'));
                    const imageValid = await validateImageAsync(document.getElementById('image'));
                    if (nameValid && descValid && imageValid) {
                        checkNameDuplicate(nameValue, function (isDuplicate, msg) {
                            if (isDuplicate) {
                                setInvalid(document.getElementById('name'), document.getElementById('nameError'), msg || 'Tên này đã tồn tại trong hệ thống');
                                return;
                            } else {
                                setValid(document.getElementById('name'), document.getElementById('nameError'), 'Tên hợp lệ');
                                e.target.submit();
                            }
                        });
                    }
                });

                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl);
                });
            </script>

            <!-- Modal hiển thị ảnh lớn -->
            <div id="imageModal"
                style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100vw; height:100vh; background:rgba(0,0,0,0.8); align-items:center; justify-content:center;">
                <img id="modalImg" src=""
                    style="max-width:90vw; max-height:90vh; border:4px solid #fff; border-radius:8px;">
            </div>



        </body>

        </html>