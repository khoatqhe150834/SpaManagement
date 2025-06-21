<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">

    <!-- Mirrored from wowdash.wowtheme7.com/demo/view-profile.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 03 Feb 2025 04:44:21 GMT -->
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xem hồ sơ nhân viên</title>
        <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
        <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp"></jsp:include>
        </head>
        <body>
        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp"></jsp:include>

        <jsp:include page="/WEB-INF/view/common/admin/header.jsp"></jsp:include>

            <div class="dashboard-main-body">
                <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                    <h6 class="fw-semibold mb-0">Xem hồ sơ nhân viên</h6>
                    <ul class="d-flex align-items-center gap-2">
                        <li class="fw-medium">
                            <a href="staff" class="d-flex align-items-center gap-1 hover-text-primary">
                                <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                                Quay lại danh sách nhân viên
                            </a>
                        </li>
                    </ul>
                </div>

                <div class="row gy-4">
                    <div class="col-lg-5">
                        <div class="user-grid-card position-relative border radius-16 overflow-hidden bg-base h-100">
                            <img src="${staff.user.avatarUrl != null ? staff.user.avatarUrl : '/assets/images/user-grid/user-grid-img14.png'}" 
                             alt="Avatar" class="border br-white border-width-2-px w-200-px h-200-px rounded-circle object-fit-cover mx-auto d-block mt-4">
                        <div class="pb-24 ms-16 mb-24 me-16 mt-4">
                            <div class="text-center border border-top-0 border-start-0 border-end-0">
                                <h6 class="mb-0 mt-16">${staff.user.fullName}</h6>
                                <span class="text-secondary-light mb-16">${staff.user.email}</span>
                            </div>
                            <div class="mt-24">
                                <h6 class="text-xl mb-16">Thông tin cá nhân</h6>
                                <ul>
                                    <li class="d-flex align-items-center gap-1 mb-12">
                                        <span class="w-30 text-md fw-semibold text-primary-light">Mã nhân viên</span>
                                        <span class="w-70 text-secondary-light fw-medium">: ${staff.user.userId}</span>
                                    </li>
                                    <li class="d-flex align-items-center gap-1 mb-12">
                                        <span class="w-30 text-md fw-semibold text-primary-light">Email</span>
                                        <span class="w-70 text-secondary-light fw-medium">: ${staff.user.email}</span>
                                    </li>
                                    <li class="d-flex align-items-center gap-1 mb-12">
                                        <span class="w-30 text-md fw-semibold text-primary-light">Số điện thoại</span>
                                        <span class="w-70 text-secondary-light fw-medium">: ${staff.user.phoneNumber}</span>
                                    </li>
                                    <li class="d-flex align-items-center gap-1 mb-12">
                                        <span class="w-30 text-md fw-semibold text-primary-light">Giới tính</span>
                                        <span class="w-70 text-secondary-light fw-medium">: ${staff.user.gender}</span>
                                    </li>
                                    <li class="d-flex align-items-center gap-1 mb-12">
                                        <span class="w-30 text-md fw-semibold text-primary-light">Ngày sinh</span>
                                        <span class="w-70 text-secondary-light fw-medium">: <fmt:formatDate value="${staff.user.birthday}" pattern="dd/MM/yyyy"/></span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-7">
                    <div class="card h-100">
                        <div class="card-body p-24">
                            <ul class="nav border-gradient-tab nav-pills mb-20 d-inline-flex" id="pills-tab" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link d-flex align-items-center px-24 active" id="pills-edit-profile-tab" data-bs-toggle="pill" data-bs-target="#pills-edit-profile" type="button" role="tab" aria-controls="pills-edit-profile" aria-selected="true">
                                        Thông tin hồ sơ 
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link d-flex align-items-center px-24" id="pills-change-passwork-tab" data-bs-toggle="pill" data-bs-target="#pills-change-passwork" type="button" role="tab" aria-controls="pills-change-passwork" aria-selected="false" tabindex="-1">
                                        Đổi mật khẩu
                                    </button>
                                </li>

                            </ul>

                            <div class="tab-content" id="pills-tabContent">   
                                <div class="tab-pane fade show active" id="pills-edit-profile" role="tabpanel" aria-labelledby="pills-edit-profile-tab" tabindex="0">
                                    <form>
                                        <!-- Full Name (Readonly) -->
                                        <div class="mb-20">
                                            <label for="fullName" class="form-label fw-semibold text-primary-light text-sm mb-8">Họ và tên <span class="text-danger-600">*</span></label>
                                            <input type="text" name="fullName" class="form-control radius-8" id="fullName" value="${staff.user.fullName}" required readonly />
                                        </div>

                                        <!-- Bio -->
                                        <div class="mb-12">
                                            <label for="bio" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                Tiểu sử
                                                <span class="text-muted text-sm">(20-500 ký tự)</span>
                                            </label>
                                            <div class="position-relative">
                                                <textarea 
                                                    name="bio" 
                                                    class="form-control radius-8" 
                                                    id="bio" 
                                                    placeholder="Viết mô tả ngắn về nhân viên (tối thiểu 20 ký tự)..." 
                                                    rows="5"
                                                    style="resize: none;"
                                                    minlength="20"
                                                    maxlength="500"
                                                    required
                                                    readonly
                                                >${staff.bio}</textarea>
                                            </div>
                                        </div>

                                        <!-- Service Type -->
                                        <div class="mb-12">
                                            <label for="serviceTypeId" class="form-label fw-semibold text-primary-light text-sm mb-8">Loại dịch vụ <span class="text-danger-600">*</span></label>
                                            <select name="serviceTypeId" class="form-control radius-8" id="serviceTypeId" required disabled>
                                                <c:forEach var="serviceType" items="${serviceTypes}">
                                                    <option value="${serviceType.serviceTypeId}" ${serviceType.serviceTypeId == staff.serviceType.serviceTypeId ? "selected" : ""}>${serviceType.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <!-- Availability Status -->
                                        <div class="mb-20">
                                            <label for="availabilityStatus" class="form-label fw-semibold text-primary-light text-sm mb-8">Trạng thái sẵn sàng <span class="text-danger-600">*</span></label>
                                            <select name="availabilityStatus" class="form-control radius-8" id="availabilityStatus" required disabled>
                                                <option value="AVAILABLE" ${staff.availabilityStatus == 'AVAILABLE' ? "selected" : ""}>Sẵn sàng</option>
                                                <option value="BUSY" ${staff.availabilityStatus == 'BUSY' ? "selected" : ""}>Bận</option>
                                                <option value="OFFLINE" ${staff.availabilityStatus == 'OFFLINE' ? "selected" : ""}>Ngoại tuyến</option>
                                                <option value="ON_LEAVE" ${staff.availabilityStatus == 'ON_LEAVE' ? "selected" : ""}>Đang nghỉ</option>
                                            </select>
                                        </div>

                                        <!-- Years of Experience -->
                                        <div class="mb-20">
                                            <label for="yearsOfExperience" class="form-label fw-semibold text-primary-light text-sm mb-8">Số năm kinh nghiệm <span class="text-danger-600">*</span></label>
                                            <input type="number" name="yearsOfExperience" class="form-control radius-8" id="yearsOfExperience" value="${staff.yearsOfExperience}" required readonly />
                                        </div>
                                    </form>
                                </div>

                                <div class="tab-pane fade" id="pills-change-passwork" role="tabpanel" aria-labelledby="pills-change-passwork-tab" tabindex="0">
                                    <div class="mb-20">
                                        <label for="your-password" class="form-label fw-semibold text-primary-light text-sm mb-8">Mật khẩu mới <span class="text-danger-600">*</span></label>
                                        <div class="position-relative">
                                            <input type="password" class="form-control radius-8" id="your-password" placeholder="Nhập mật khẩu mới*">
                                            <span class="toggle-password ri-eye-line cursor-pointer position-absolute end-0 top-50 translate-middle-y me-16 text-secondary-light" data-toggle="#your-password"></span>
                                        </div>
                                    </div>
                                    <div class="mb-20">
                                        <label for="confirm-password" class="form-label fw-semibold text-primary-light text-sm mb-8">Xác nhận mật khẩu <span class="text-danger-600">*</span></label>
                                        <div class="position-relative">
                                            <input type="password" class="form-control radius-8" id="confirm-password" placeholder="Xác nhận mật khẩu*">
                                            <span class="toggle-password ri-eye-line cursor-pointer position-absolute end-0 top-50 translate-middle-y me-16 text-secondary-light" data-toggle="#confirm-password"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/view/common/admin/js.jsp"></jsp:include>


        <script>
            // ======================== Upload Image Start =====================
            function readURL(input) {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        $('#imagePreview').css('background-image', 'url(' + e.target.result + ')');
                        $('#imagePreview').hide();
                        $('#imagePreview').fadeIn(650);
                    }
                    reader.readAsDataURL(input.files[0]);
                }
            }
            $("#imageUpload").change(function () {
                readURL(this);
            });
            // ======================== Upload Image End =====================

            // ================== Password Show Hide Js Start ==========
            function initializePasswordToggle(toggleSelector) {
                $(toggleSelector).on('click', function () {
                    $(this).toggleClass("ri-eye-off-line");
                    var input = $($(this).attr("data-toggle"));
                    if (input.attr("type") === "password") {
                        input.attr("type", "text");
                    } else {
                        input.attr("type", "password");
                    }
                });
            }
            // Call the function
            initializePasswordToggle('.toggle-password');
            // ========================= Password Show Hide Js End ===========================
        </script>

    </body>

    <!-- Mirrored from wowdash.wowtheme7.com/demo/view-profile.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 03 Feb 2025 04:44:22 GMT -->
</html>