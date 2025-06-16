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

            document.getElementById('userSelect').addEventListener('change', function() {
                var selectedOption = this.options[this.selectedIndex];
                var fullName = selectedOption.getAttribute('data-fullname');
                document.getElementById('fullNameInput').value = fullName || '';
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
                                            <label for="userId" class="form-label fw-semibold text-primary-light text-sm mb-8">User <span class="text-danger-600">*</span></label>
                                            <select id="userSelect" name="userId" class="form-select" required>
                                                <option value="">-- Select UserID --</option>
                                                <c:forEach var="user" items="${userList}">
                                                    <option value="${user.userId}" data-fullname="${user.fullName}">${user.userId}</option>
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
                                            <label for="bio" class="form-label fw-semibold text-primary-light text-sm mb-8">Bio</label>
                                            <textarea name="bio" class="form-control radius-8" id="bio" placeholder="Write bio..."></textarea>
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
    </body>
</html>
