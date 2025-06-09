<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<!--<html lang="en" data-theme="light">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>View Staff - Admin Dashboard</title>
        <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
        <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
        <script type="text/javascript">
            // Logic JS can be added here if needed
        </script>
    </head>
    <body>
        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">View Staff Profile</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="staff" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Back to Staff List
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Staff Profile</li>
                </ul>
            </div>

            <div class="card h-100 p-0 radius-12">
                <div class="card-body p-24">
                    <div class="row justify-content-center">
                        <div class="col-xxl-8 col-xl-10 col-lg-12">
                            <div class="card border">
                                <div class="card-body">
                                    <div class="staff-details">
                                        <div class="row">
                                             Staff Profile Image 
                                            <div class="col-md-3 text-center">
                                                <img src="<c:if test="${not empty staff.user.avatarUrl}">${staff.user.avatarUrl}</c:if>" alt="Staff Avatar" class="img-fluid rounded-circle w-150px h-150px">
                                            </div>
                                             Staff Information 
                                            <div class="col-md-9">
                                                <h5 class="text-primary-600">${staff.user.fullName}</h5>
                                                <p><strong>Email:</strong> ${staff.user.email}</p>
                                                <p><strong>Phone:</strong> ${staff.user.phoneNumber}</p>
                                                <p><strong>Service Type:</strong> ${staff.serviceType.name}</p>
                                                <p><strong>Bio:</strong> ${staff.bio}</p>
                                                <p><strong>Availability Status:</strong> ${staff.availabilityStatus}</p>
                                                <p><strong>Years of Experience:</strong> ${staff.yearsOfExperience}</p>
                                                <p><strong>Created At:</strong> <fmt:formatDate value="${staff.createdAt}" pattern="yyyy-MM-dd HH:mm" /></p>
                                                <p><strong>Updated At:</strong> <fmt:formatDate value="${staff.updatedAt}" pattern="yyyy-MM-dd HH:mm" /></p>
                                            </div>
                                        </div>
                                        <div class="mt-4">
                                            <a href="staff?service=pre-update&id=${staff.user.userId}" class="btn btn-warning">Edit Profile</a>
                                            <a href="staff" class="btn btn-secondary">Back to Staff List</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
    </body>
</html>-->

<!DOCTYPE html>
<html lang="en" data-theme="light">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>View Staff - Admin Dashboard</title>
        <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
        <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
    </head>
    <body>
        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">View Staff Profile</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="staff" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Back to Staff List
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Staff Profile</li>
                </ul>
            </div>

            <div class="card h-100 p-0 radius-12">
                <div class="card-body p-24">
                    <div class="row justify-content-center">
                        <div class="col-xxl-8 col-xl-10 col-lg-12">
                            <div class="card border">
                                <div class="card-body">
                                    <div class="staff-details">
                                        <div class="row">
                                            <!-- Staff Profile Image -->
                                            <div class="col-md-3 text-center">
                                                <img src="<c:if test="${not empty staff.user.avatarUrl}">${staff.user.avatarUrl}</c:if><c:if test="${empty staff.user.avatarUrl}">/path/to/default-avatar.png</c:if>" alt="Staff Avatar" class="img-fluid rounded-circle w-150px h-150px">
                                            </div>
                                            <!-- Staff Information -->
                                            <div class="col-md-9">
                                                <h5 class="text-primary-600">${staff.user.fullName}</h5>
                                                <p><strong>Email:</strong> ${staff.user.email}</p>
                                                <p><strong>Phone:</strong> ${staff.user.phoneNumber}</p>
                                                <p><strong>Service Type:</strong> ${staff.serviceType.name}</p>
                                                <p><strong>Bio:</strong> ${staff.bio}</p>
                                                <p><strong>Availability Status:</strong> ${staff.availabilityStatus}</p>
                                                <p><strong>Years of Experience:</strong> ${staff.yearsOfExperience}</p>
                                                <p><strong>Created At:</strong> <fmt:formatDate value="${staff.createdAt}" pattern="yyyy-MM-dd HH:mm" /></p>
                                                <p><strong>Updated At:</strong> <fmt:formatDate value="${staff.updatedAt}" pattern="yyyy-MM-dd HH:mm" /></p>
                                            </div>
                                        </div>
                                        <div class="mt-4">
                                            <a href="staff?service=pre-update&id=${staff.user.userId}" class="btn btn-warning">Edit Profile</a>
                                            <a href="staff" class="btn btn-secondary">Back to Staff List</a>
                                        </div>
                                    </div>
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

        
        