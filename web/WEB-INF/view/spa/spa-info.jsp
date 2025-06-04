<%--
    Document   : spa-info
    Created on : Jun 4, 2025, 4:43:43 PM
    Author     : quang
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Spa Information - ${spa.name}</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .spa-logo {
                max-width: 200px;
                height: auto;
            }
            .info-section {
                margin-bottom: 2rem;
            }
            .contact-info i {
                width: 25px;
                color: #0d6efd;
            }
        </style>
    </head>
    <body>
        <div class="container py-5">
            <div class="row">
                <div class="col-md-12 text-center mb-4">
                    <c:if test="${not empty spa.logoUrl}">
                        <img src="${spa.logoUrl}" alt="${spa.name} Logo" class="spa-logo mb-3">
                    </c:if>
                    <h1 class="display-4">${spa.name}</h1>
                </div>
            </div>

            <div class="row">
                <!-- Contact Information -->
                <div class="col-md-6 info-section">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h3 class="card-title mb-0"><i class="fas fa-info-circle me-2"></i>Contact Information</h3>
                        </div>
                        <div class="card-body contact-info">
                            <p><i class="fas fa-map-marker-alt"></i> <strong>Address:</strong><br>
                                ${spa.addressLine1}<br>
                                <c:if test="${not empty spa.addressLine2}">${spa.addressLine2}<br></c:if>
                                ${spa.city}, ${spa.postalCode}<br>
                                ${spa.country}
                            </p>
                            <p><i class="fas fa-phone"></i> <strong>Phone:</strong><br>
                                Main: ${spa.phoneNumberMain}<br>
                                <c:if test="${not empty spa.phoneNumberSecondary}">
                                    Secondary: ${spa.phoneNumberSecondary}
                                </c:if>
                            </p>
                            <p><i class="fas fa-envelope"></i> <strong>Email:</strong><br>
                                Main: ${spa.emailMain}<br>
                                <c:if test="${not empty spa.emailSecondary}">
                                    Secondary: ${spa.emailSecondary}
                                </c:if>
                            </p>
                            <c:if test="${not empty spa.websiteUrl}">
                                <p><i class="fas fa-globe"></i> <strong>Website:</strong><br>
                                    <a href="${spa.websiteUrl}" target="_blank">${spa.websiteUrl}</a>
                                </p>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Business Information -->
                <div class="col-md-6 info-section">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h3 class="card-title mb-0"><i class="fas fa-building me-2"></i>Business Information</h3>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty spa.taxIdentificationNumber}">
                                <p><strong>Tax ID:</strong> ${spa.taxIdentificationNumber}</p>
                            </c:if>
                            <p><strong>VAT Percentage:</strong> ${spa.vatPercentage}%</p>
                            <p><strong>Default Appointment Buffer:</strong> ${spa.defaultAppointmentBufferMinutes} minutes</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- About Us Section -->
            <div class="row">
                <div class="col-md-12 info-section">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h3 class="card-title mb-0"><i class="fas fa-info-circle me-2"></i>About Us</h3>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty spa.aboutUsShort}">
                                <h4>Brief Description</h4>
                                <p>${spa.aboutUsShort}</p>
                            </c:if>
                            <c:if test="${not empty spa.aboutUsLong}">
                                <h4>Detailed Information</h4>
                                <p>${spa.aboutUsLong}</p>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Policies Section -->
            <div class="row">
                <div class="col-md-6 info-section">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h3 class="card-title mb-0"><i class="fas fa-calendar-times me-2"></i>Cancellation Policy</h3>
                        </div>
                        <div class="card-body">
                            <p>${spa.cancellationPolicy}</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 info-section">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h3 class="card-title mb-0"><i class="fas fa-file-contract me-2"></i>Booking Terms</h3>
                        </div>
                        <div class="card-body">
                            <p>${spa.bookingTerms}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS and dependencies -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
