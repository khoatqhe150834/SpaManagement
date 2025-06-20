<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add New Staff</title>
        <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
        <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />

        <!-- Add JavaScript here -->
        <script type="text/javascript">
            function fetchUserFullName() {
                var userId = document.getElementById('userId').value;
                var fullNameInput = document.getElementById('fullName');

                if (userId) {
                    var xhr = new XMLHttpRequest();
                    xhr.open("GET", "staff?service=getUserFullName&userId=" + encodeURIComponent(userId), true);
                    xhr.onload = function () {
                        if (xhr.status === 200) {
                            try {
                                var response = JSON.parse(xhr.responseText);
                                if (response.fullName) {
                                    fullNameInput.value = response.fullName;
                                } else {
                                    fullNameInput.value = 'User not found';
                                }
                            } catch (e) {
                                fullNameInput.value = 'Error parsing response';
                                console.error("Error parsing JSON response: ", e);
                            }
                        } else {
                            fullNameInput.value = 'Error fetching user';
                            console.error("Request failed with status: ", xhr.status);
                        }
                    };
                    xhr.onerror = function () {
                        fullNameInput.value = 'Network error';
                        console.error("Network error occurred");
                    };
                    xhr.send();
                } else {
                    fullNameInput.value = '';
                }
            }

            document.addEventListener('DOMContentLoaded', function() {
                document.getElementById('userSelect').addEventListener('change', function() {
                    var userId = this.value;
                    if (userId) {
                        fetch('<c:url value="/ajax/user-fullname"/>?userId=' + userId)
                            .then(response => response.json())
                            .then(data => {
                                document.getElementById('fullNameInput').value = data.fullName || '';
                            });
                    } else {
                        document.getElementById('fullNameInput').value = '';
                    }
                });
            });
        </script>
    </head>
    <body>
        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Add New Staff</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="staff" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Back to Staff List
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Create New Staff</li>
                </ul>
            </div>

            <div class="card h-100 p-0 radius-12">
                <div class="card-body p-24">
                    <div class="row justify-content-center">
                        <div class="col-xxl-6 col-xl-8 col-lg-10">
                            <div class="card border">
                                <div class="card-body">
                                    <form action="staff" method="post">
                                        <input type="hidden" name="service" value="insert" />

                                        <!-- User ID -->
                                        <div class="mb-20">
                                            <label for="userId" class="form-label fw-semibold text-primary-light text-sm mb-8">UserID <span class="text-danger-600">*</span></label>
                                            <select id="userSelect" name="userId" class="form-select" required>
                                                <option value="">-- Select UserID --</option>
                                                <c:forEach var="user" items="${userList}">
                                                    <option value="${user.userId}">${user.userId} - ${user.fullName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <!-- Full Name (Readonly) -->
                                        <div class="mb-20">
                                            <label for="fullName" class="form-label fw-semibold text-primary-light text-sm mb-8">Full Name <span class="text-danger-600">*</span></label>
                                            <input type="text" id="fullNameInput" name="fullName" class="form-control" readonly />
                                        </div>

                                        <!-- Bio -->
                                        <div class="mb-20">
                                            <label for="bio" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                Bio
                                                <span class="text-muted text-sm">(20-500 characters)</span>
                                            </label>
                                            <div class="position-relative">
                                                <textarea 
                                                    name="bio" 
                                                    class="form-control radius-8" 
                                                    id="bio" 
                                                    placeholder="Write a brief description about the staff member (minimum 20 characters)..." 
                                                    rows="4"
                                                    style="resize: none;"
                                                    minlength="20"
                                                    maxlength="500"
                                                    required
                                                ></textarea>
                                                <div class="form-text text-end">
                                                    <span id="bioCharCount">0</span>/500 characters
                                                    <span id="bioValidationMessage" class="ms-2"></span>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Service Type -->
                                        <div class="mb-20">
                                            <label for="serviceTypeId" class="form-label fw-semibold text-primary-light text-sm mb-8">Service Type <span class="text-danger-600">*</span></label>
                                            <select name="serviceTypeId" class="form-control radius-8" id="serviceTypeId" required>
                                                <c:forEach var="serviceType" items="${serviceTypes}">
                                                    <option value="${serviceType.serviceTypeId}">${serviceType.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <!-- Availability Status -->
                                        <div class="mb-20">
                                            <label for="availabilityStatus" class="form-label fw-semibold text-primary-light text-sm mb-8">Availability Status <span class="text-danger-600">*</span></label>
                                            <select name="availabilityStatus" class="form-control radius-8" id="availabilityStatus" required>
                                                <option value="AVAILABLE">Available</option>
                                                <option value="BUSY">Busy</option>
                                                <option value="OFFLINE">Offline</option>
                                                <option value="ON_LEAVE">On Leave</option>
                                            </select>
                                        </div>

                                        <!-- Experience -->
                                        <div class="mb-20">
                                            <label for="yearsOfExperience" class="form-label fw-semibold text-primary-light text-sm mb-8">Years of Experience <span class="text-danger-600">*</span></label>
                                            <input type="number" name="yearsOfExperience" class="form-control radius-8" id="yearsOfExperience" required />
                                        </div>

                                        <!-- Action Buttons -->
                                        <div class="d-flex align-items-center justify-content-center gap-3">
                                            <a href="staff" class="btn btn-outline-danger border border-danger-600 px-56 py-11 radius-8">Cancel</a>
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

        <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />

        <script>
            // Xử lý bio textarea
            const bioTextarea = document.getElementById('bio');
            const bioCharCount = document.getElementById('bioCharCount');
            const bioValidationMessage = document.getElementById('bioValidationMessage');
            const minLength = 20;
            const maxLength = 500;

            // Hàm format bio: loại bỏ khoảng trắng thừa
            function formatBio(text) {
                // Thay thế 2 hoặc nhiều khoảng trắng bằng 1 khoảng trắng
                return text.replace(/\s{2,}/g, ' ').trim();
            }

            // Hàm validate bio
            function validateBio(text) {
                const formattedText = formatBio(text);
                const length = formattedText.length;
                
                if (length < minLength) {
                    bioValidationMessage.textContent = `Please enter at least ${minLength} characters`;
                    bioValidationMessage.className = 'ms-2 text-danger';
                    return false;
                } else if (length > maxLength) {
                    bioValidationMessage.textContent = `Maximum ${maxLength} characters allowed`;
                    bioValidationMessage.className = 'ms-2 text-danger';
                    return false;
                } else {
                    bioValidationMessage.textContent = '';
                    bioValidationMessage.className = 'ms-2';
                    return true;
                }
            }

            // Hàm cập nhật số ký tự
            function updateCharCount() {
                const currentText = bioTextarea.value;
                const formattedText = formatBio(currentText);
                const currentLength = formattedText.length;
                
                bioCharCount.textContent = currentLength;
                
                if (currentLength > maxLength) {
                    bioCharCount.classList.add('text-danger');
                } else {
                    bioCharCount.classList.remove('text-danger');
                }

                validateBio(currentText);
            }

            // Xử lý sự kiện input
            bioTextarea.addEventListener('input', function(e) {
                const currentText = this.value;
                const formattedText = formatBio(currentText);
                
                // Nếu text đã được format khác với text hiện tại
                if (currentText !== formattedText) {
                    const cursorPosition = this.selectionStart;
                    const diff = currentText.length - formattedText.length;
                    
                    this.value = formattedText;
                    
                    // Giữ vị trí con trỏ
                    this.setSelectionRange(cursorPosition - diff, cursorPosition - diff);
                }
                
                updateCharCount();
            });

            // Xử lý sự kiện blur (khi rời khỏi textarea)
            bioTextarea.addEventListener('blur', function() {
                this.value = formatBio(this.value);
                updateCharCount();
            });

            // Xử lý sự kiện submit form
            document.querySelector('form').addEventListener('submit', function(e) {
                const bioText = bioTextarea.value;
                if (!validateBio(bioText)) {
                    e.preventDefault();
                    bioTextarea.focus();
                }
            });

            // Khởi tạo khi trang load
            updateCharCount();
        </script>

        <style>
            .form-text {
                font-size: 0.875rem;
                color: #6c757d;
            }
            
            .text-danger {
                color: #dc3545 !important;
            }
            
            textarea#bio {
                transition: border-color 0.15s ease-in-out;
            }
            
            textarea#bio:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 0.2rem rgba(var(--primary-rgb), 0.25);
            }
            
            textarea#bio.error {
                border-color: #dc3545;
            }
            
            #bioValidationMessage {
                font-size: 0.875rem;
                transition: color 0.15s ease-in-out;
            }
        </style>
    </body>
</html>
