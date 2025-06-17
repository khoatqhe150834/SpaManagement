<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Verification Banner for Unverified Customers --%>
<c:if test="${sessionScope.userType == 'customer' && sessionScope.customer != null}">
    <c:if test="${empty sessionScope.customer.isVerified || !sessionScope.customer.isVerified}">
        <div class="alert alert-warning verification-banner sticky-top" style="margin-bottom: 0; border-radius: 0; z-index: 1020;">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <strong>Email Verification Required</strong>
                        <span class="ms-2">Please verify your email to book appointments and access your full profile.</span>
                    </div>
                    <div class="col-md-4 text-md-end mt-2 mt-md-0">
                        <a href="${pageContext.request.contextPath}/resend-verification" 
                           class="btn btn-sm btn-outline-warning me-2">
                            <i class="fas fa-envelope me-1"></i>Resend Email
                        </a>
                        <button type="button" class="btn btn-sm btn-light" onclick="dismissBanner()">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <script>
        function dismissBanner() {
            document.querySelector('.verification-banner').style.display = 'none';
            // Store dismissal in session storage (until page refresh)
            sessionStorage.setItem('verificationBannerDismissed', 'true');
        }

        // Check if banner was previously dismissed in this session
        if (sessionStorage.getItem('verificationBannerDismissed') === 'true') {
            document.addEventListener('DOMContentLoaded', function() {
                const banner = document.querySelector('.verification-banner');
                if (banner) banner.style.display = 'none';
            });
        }
        </script>

        <style>
        .verification-banner {
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            border-left: 4px solid #ffc107;
        }
        .verification-banner .btn-outline-warning {
            border-color: #ffc107;
            color: #856404;
        }
        .verification-banner .btn-outline-warning:hover {
            background-color: #ffc107;
            color: #212529;
        }
        </style>
    </c:if>
</c:if> 