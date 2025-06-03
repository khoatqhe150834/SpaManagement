<%-- 
    Document   : ViewServiceDetails
    Created on : Jun 3, 2025, 2:02:14 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en" data-theme="light">

    <!-- Mirrored from wowdash.wowtheme7.com/demo/view-profile.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 03 Feb 2025 04:44:21 GMT -->
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Wowdash - Bootstrap 5 Admin Dashboard HTML Template</title>
        <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
        <!-- CSS here -->
        <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp"></jsp:include>
        </head>
        <body>
            <!-- SIDEBAR here -->
        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp"></jsp:include>

            <!-- HEADER here -->
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp"></jsp:include>

            <div class="dashboard-main-body">
                <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                    <h6 class="fw-semibold mb-0">View Profile</h6>
                    <ul class="d-flex align-items-center gap-2">
                        <li class="fw-medium">
                            <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                                <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                                Dashboard
                            </a>
                        </li>
                        <li>-</li>
                        <li class="fw-medium">View Profile</li>
                    </ul>
                </div>

                <div class="row gy-4">
                    <div class="col-lg-4">
                        <div class="user-grid-card position-relative border radius-16 overflow-hidden bg-base h-100">
                            <img src="assets/images/user-grid/user-grid-bg1.png" alt="" class="w-100 object-fit-cover">
                            <div class="pb-24 ms-16 mb-24 me-16  mt--100">
                                <div class="text-center border border-top-0 border-start-0 border-end-0">
                                    <img src="assets/images/user-grid/user-grid-img14.png" alt="" class="border br-white border-width-2-px w-200-px h-200-px rounded-circle object-fit-cover">
                                    <h6 class="mb-0 mt-16">Jacob Jones</h6>
                                    <span class="text-secondary-light mb-16">ifrandom@gmail.com</span>
                                </div>
                                <div class="mt-24">
                                    <h6 class="text-xl mb-16">Personal Info</h6>
                                <c:forEach var="service" items="${services}">
                                    <div class="border-bottom pb-16 mb-16">
                                        <h6 class="text-lg text-primary-light mb-12">Service ID: ${service.serviceId}</h6>
                                        <ul>
                                            <li class="d-flex align-items-center gap-1 mb-8">
                                                <span class="w-40 text-md fw-semibold text-primary-light">Service Type</span>
                                                <span class="w-60 text-secondary-light fw-medium">: ${service.serviceTypeId.name}</span>
                                            </li>
                                            <li class="d-flex align-items-center gap-1 mb-8">
                                                <span class="w-40 text-md fw-semibold text-primary-light">Name</span>
                                                <span class="w-60 text-secondary-light fw-medium">: ${service.name}</span>
                                            </li>
                                            <li class="d-flex align-items-center gap-1 mb-8">
                                                <span class="w-40 text-md fw-semibold text-primary-light">Description</span>
                                                <span class="w-60 text-secondary-light fw-medium">: ${service.description}</span>
                                            </li>
                                            <li class="d-flex align-items-center gap-1 mb-8">
                                                <span class="w-40 text-md fw-semibold text-primary-light">Price</span>
                                                <span class="w-60 text-secondary-light fw-medium">: $${service.price}</span>
                                            </li>
                                            <li class="d-flex align-items-center gap-1 mb-8">
                                                <span class="w-40 text-md fw-semibold text-primary-light">Duration</span>
                                                <span class="w-60 text-secondary-light fw-medium">: ${service.durationMinutes} mins</span>
                                            </li>
                                            <li class="d-flex align-items-center gap-1 mb-8">
                                                <span class="w-40 text-md fw-semibold text-primary-light">Buffer</span>
                                                <span class="w-60 text-secondary-light fw-medium">: ${service.bufferTimeAfterMinutes} mins</span>
                                            </li>
                                            <li class="d-flex align-items-center gap-1 mb-8">
                                                <span class="w-40 text-md fw-semibold text-primary-light">Active</span>
                                                <span class="w-60 text-secondary-light fw-medium">: 
                                                    <c:choose>
                                                        <c:when test="${service.active}">Yes</c:when>
                                                        <c:otherwise>No</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </li>
                                            <li class="d-flex align-items-center gap-1 mb-8">
                                                <span class="w-40 text-md fw-semibold text-primary-light">Rating</span>
                                                <span class="w-60 text-secondary-light fw-medium">: ${service.averageRating}</span>
                                            </li>
                                            <li class="d-flex align-items-center gap-1 mb-8">
                                                <span class="w-40 text-md fw-semibold text-primary-light">Online?</span>
                                                <span class="w-60 text-secondary-light fw-medium">: 
                                                    <c:choose>
                                                        <c:when test="${service.bookableOnline}">Yes</c:when>
                                                        <c:otherwise>No</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </li>
                                            <li class="d-flex align-items-center gap-1 mb-8">
                                                <span class="w-40 text-md fw-semibold text-primary-light">Consultation?</span>
                                                <span class="w-60 text-secondary-light fw-medium">: 
                                                    <c:choose>
                                                        <c:when test="${service.requiresConsultation}">Yes</c:when>
                                                        <c:otherwise>No</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </li>
                                            <li class="d-flex align-items-center gap-1 mb-8">
                                                <span class="w-40 text-md fw-semibold text-primary-light">Created</span>
                                                <span class="w-60 text-secondary-light fw-medium">: 
                                                    <fmt:formatDate value="${service.createdAt}" pattern="dd MMM yyyy HH:mm"/>
                                                </span>
                                            </li>
                                            <li class="d-flex align-items-center gap-1 mb-8">
                                                <span class="w-40 text-md fw-semibold text-primary-light">Updated</span>
                                                <span class="w-60 text-secondary-light fw-medium">: 
                                                    <fmt:formatDate value="${service.updatedAt}" pattern="dd MMM yyyy HH:mm"/>
                                                </span>
                                            </li>
                                        </ul>
                                    </div>
                                </c:forEach>


                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-8">

                </div>
            </div>
        </div>

        <!-- JS here -->
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