<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
    <head>
        <meta charset="UTF-8">
        <title>Add Service</title>
        <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
        <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
    </head>
    <body>

        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Add New Service</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="servicetype" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Back to Service Types
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Create New Service</li>
                </ul>
            </div>

            <div class="card h-100 p-0 radius-12">
                <div class="card-body p-24">
                    <div class="row justify-content-center">
                        <div class="col-xxl-6 col-xl-8 col-lg-10">
                            <div class="card border">
                                <div class="card-body">
                                    <form action="service" method="post">
                                        <input type="hidden" name="service" value="insert" />
                                        <input type="hidden" name="stypeId" value="${stype.serviceTypeId}" />

                                        <!-- Name -->
                                        <div class="mb-20">
                                            <label for="name" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                Service Name <span class="text-danger-600">*</span>
                                            </label>
                                            <input type="text" name="name" class="form-control radius-8" id="name" placeholder="Enter service name" required>
                                        </div>

                                        <!-- Description -->
                                        <div class="mb-20">
                                            <label for="description" class="form-label fw-semibold text-primary-light text-sm mb-8">Description</label>
                                            <textarea name="description" id="description" class="form-control radius-8" placeholder="Write description..."></textarea>
                                        </div>

                                        <!-- Price -->
                                        <div class="mb-20">
                                            <label for="price" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                Price (VND) <span class="text-danger-600">*</span>
                                            </label>
                                            <input type="number" name="price" class="form-control radius-8" id="price" required>
                                        </div>

                                        <!-- Duration -->
                                        <div class="mb-20">
                                            <label for="durationMinutes" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                Duration (minutes) <span class="text-danger-600">*</span>
                                            </label>
                                            <input type="number" name="durationMinutes" class="form-control radius-8" id="durationMinutes" required>
                                        </div>

                                        <!-- Buffer Time -->
                                        <div class="mb-20">
                                            <label for="bufferTimeAfterMinutes" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                Buffer Time After (minutes)
                                            </label>
                                            <input type="number" name="bufferTimeAfterMinutes" class="form-control radius-8" id="bufferTimeAfterMinutes" value="0">
                                        </div>

                                        <!-- Image URL -->
                                        <div class="mb-20">
                                            <label for="imageUrl" class="form-label fw-semibold text-primary-light text-sm mb-8">Image URL</label>
                                            <input type="text" name="imageUrl" class="form-control radius-8" id="imageUrl" placeholder="https://example.com/image.jpg">
                                        </div>

                                        <!-- Checkboxes -->
                                        <div class="mb-20">
                                            <div class="form-switch switch-primary d-flex align-items-center gap-3 mb-2">
                                                <input class="form-check-input" type="checkbox" role="switch" name="isActive" id="isActive" checked>
                                                <label class="form-check-label line-height-1 fw-medium text-secondary-light" for="isActive">Active</label>
                                            </div>
                                            <div class="form-switch switch-primary d-flex align-items-center gap-3 mb-2">
                                                <input class="form-check-input" type="checkbox" role="switch" name="bookableOnline" id="bookableOnline" checked>
                                                <label class="form-check-label line-height-1 fw-medium text-secondary-light" for="bookableOnline">Bookable Online</label>
                                            </div>
                                            <div class="form-switch switch-primary d-flex align-items-center gap-3">
                                                <input class="form-check-input" type="checkbox" role="switch" name="requiresConsultation" id="requiresConsultation">
                                                <label class="form-check-label line-height-1 fw-medium text-secondary-light" for="requiresConsultation">Requires Consultation</label>
                                            </div>
                                        </div>

                                        <!-- Buttons -->
                                        <div class="d-flex align-items-center justify-content-center gap-3">
                                            <a href="servicetype" class="btn btn-outline-danger border border-danger-600 px-56 py-11 radius-8">Cancel</a>
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
