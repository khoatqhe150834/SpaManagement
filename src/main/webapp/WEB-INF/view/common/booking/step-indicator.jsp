<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 
    Booking Step Indicator Component
    Parameters expected:
    - currentStep: Current booking step (services, time, therapists, payment)
    - bookingSession: BookingSession object with current state
--%>

<!-- Iconify Icons -->
<script src="https://code.iconify.design/3/3.1.1/iconify.min.js"></script>

<!-- Main container for the component -->
<div class="booking-step-indicator">
    <div class="step-indicator-container">
        <!-- The background line for the progress bar -->
        <div class="progress-bar-line"></div>
        <!-- The active/colored line showing progress -->
        <div class="progress-bar-line-active" style="width: <c:choose>
            <c:when test='${currentStep == "services"}'>25%</c:when>
            <c:when test='${currentStep == "time"}'>50%</c:when>
            <c:when test='${currentStep == "therapists"}'>75%</c:when>
            <c:when test='${currentStep == "payment"}'>100%</c:when>
            <c:otherwise>0%</c:otherwise>
        </c:choose>;"></div>

        <!-- Steps container -->
        <div class="steps-container">

            <!-- Step 1: Services -->
            <div class="step-item">
                <div class="step-circle ${currentStep == 'services' ? 'active' : ''} ${bookingSession.hasServices() ? 'completed' : ''}" 
                     onclick="navigateToStep('services', ${bookingSession.hasServices() || currentStep == 'services'})">
                    <c:choose>
                        <c:when test="${bookingSession.hasServices() && currentStep != 'services'}">
                            <!-- Checkmark Icon -->
                            <iconify-icon icon="material-symbols:check"></iconify-icon>
                        </c:when>
                        <c:when test="${currentStep == 'services'}">
                            <iconify-icon icon="material-symbols:spa"></iconify-icon>
                        </c:when>
                        <c:otherwise>
                            <span class="step-number">1</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="step-content">
                    <h3 class="step-title ${currentStep == 'services' ? 'active' : ''} ${bookingSession.hasServices() ? 'completed' : ''}">Chọn Dịch Vụ</h3>
                    <p class="step-description">Lựa chọn các dịch vụ spa</p>
                </div>
                <c:if test="${bookingSession.hasServices()}">
                    <div class="step-summary">
                        <span class="summary-badge">
                            <iconify-icon icon="material-symbols:spa"></iconify-icon>
                            ${bookingSession.data.selectedServices.size()} dịch vụ đã chọn
                        </span>
                        <c:if test="${currentStep != 'services'}">
                            <button class="edit-button" onclick="navigateToStep('services', true)" title="Chỉnh sửa dịch vụ">
                                <iconify-icon icon="material-symbols:edit"></iconify-icon>
                            </button>
                        </c:if>
                    </div>
                </c:if>
            </div>

            <!-- Step 2: Time -->
            <div class="step-item">
                <div class="step-circle ${currentStep == 'time' ? 'active' : ''} ${bookingSession.hasTimeSlots() ? 'completed' : ''} ${!bookingSession.hasServices() ? 'disabled' : ''}" 
                     onclick="navigateToStep('time', ${bookingSession.hasServices()})">
                    <c:choose>
                        <c:when test="${bookingSession.hasTimeSlots() && currentStep != 'time'}">
                            <iconify-icon icon="material-symbols:check"></iconify-icon>
                        </c:when>
                        <c:when test="${currentStep == 'time'}">
                            <iconify-icon icon="material-symbols:schedule"></iconify-icon>
                        </c:when>
                        <c:otherwise>
                            <span class="step-number">2</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="step-content">
                    <h3 class="step-title ${currentStep == 'time' ? 'active' : ''} ${bookingSession.hasTimeSlots() ? 'completed' : ''}">Chọn Thời Gian</h3>
                    <p class="step-description">Đặt lịch theo thời gian mong muốn</p>
                </div>
                <c:if test="${bookingSession.hasTimeSlots()}">
                    <div class="step-summary">
                        <span class="summary-badge">
                            <iconify-icon icon="material-symbols:schedule"></iconify-icon>
                            <c:if test="${not empty bookingSession.data.selectedDate}">
                                Ngày ${bookingSession.data.selectedDate}
                            </c:if>
                        </span>
                        <c:if test="${currentStep != 'time' && bookingSession.hasServices()}">
                            <button class="edit-button" onclick="navigateToStep('time', true)" title="Chỉnh sửa thời gian">
                                <iconify-icon icon="material-symbols:edit"></iconify-icon>
                            </button>
                        </c:if>
                    </div>
                </c:if>
            </div>

            <!-- Step 3: Therapists -->
            <div class="step-item">
                <div class="step-circle ${currentStep == 'therapists' ? 'active' : ''} ${bookingSession.hasTherapistAssignments() ? 'completed' : ''} ${!bookingSession.hasTimeSlots() ? 'disabled' : ''}" 
                     onclick="navigateToStep('therapists', ${bookingSession.hasTimeSlots()})">
                    <c:choose>
                        <c:when test="${bookingSession.hasTherapistAssignments() && currentStep != 'therapists'}">
                            <iconify-icon icon="material-symbols:check"></iconify-icon>
                        </c:when>
                        <c:when test="${currentStep == 'therapists'}">
                            <iconify-icon icon="material-symbols:person"></iconify-icon>
                        </c:when>
                        <c:otherwise>
                            <span class="step-number">3</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="step-content">
                    <h3 class="step-title ${currentStep == 'therapists' ? 'active' : ''} ${bookingSession.hasTherapistAssignments() ? 'completed' : ''}">Chọn Nhân Viên</h3>
                    <p class="step-description">Lựa chọn nhân viên phục vụ</p>
                </div>
                <c:if test="${bookingSession.hasTherapistAssignments()}">
                    <div class="step-summary">
                        <span class="summary-badge">
                            <iconify-icon icon="material-symbols:person"></iconify-icon>
                            Nhân viên đã được chọn
                        </span>
                        <c:if test="${currentStep != 'therapists' && bookingSession.hasTimeSlots()}">
                            <button class="edit-button" onclick="navigateToStep('therapists', true)" title="Chỉnh sửa nhân viên">
                                <iconify-icon icon="material-symbols:edit"></iconify-icon>
                            </button>
                        </c:if>
                    </div>
                </c:if>
            </div>

            <!-- Step 4: Payment -->
            <div class="step-item">
                <div class="step-circle ${currentStep == 'payment' ? 'active' : ''} ${bookingSession.readyForPayment ? 'completed' : ''} ${!bookingSession.hasTherapistAssignments() ? 'disabled' : ''}" 
                     onclick="navigateToStep('payment', ${bookingSession.hasTherapistAssignments()})">
                    <c:choose>
                        <c:when test="${currentStep == 'payment'}">
                            <iconify-icon icon="material-symbols:payments"></iconify-icon>
                        </c:when>
                        <c:otherwise>
                            <span class="step-number">4</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="step-content">
                    <h3 class="step-title ${currentStep == 'payment' ? 'active' : ''} ${bookingSession.readyForPayment ? 'completed' : ''}">Thanh Toán</h3>
                    <p class="step-description">Hoàn tất đặt lịch và thanh toán</p>
                </div>
                <c:if test="${bookingSession.hasTherapistAssignments() && not empty bookingSession.data.totalAmount}">
                    <div class="step-summary">
                        <span class="summary-badge">
                            <iconify-icon icon="material-symbols:monetization-on"></iconify-icon>
                            Tổng: <span class="amount-text">${bookingSession.data.totalAmount} VNĐ</span>
                        </span>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<!-- CSS Styles with Spa Primary Color -->
<style>
:root {
    /* Spa Primary Colors */
    --spa-primary: #c8945f;
    --spa-primary-hover: #b8845f;
    --spa-primary-light: #f3f0ec;
    --spa-accent: #596bb5;
    
    /* Gray scale */
    --gray-50: #f9fafb;
    --gray-100: #f3f4f6;
    --gray-200: #e5e7eb;
    --gray-300: #d1d5db;
    --gray-400: #9ca3af;
    --gray-500: #6b7280;
    --gray-600: #4b5563;
    --gray-700: #374151;
    --gray-800: #1f2937;
    --gray-900: #111827;
    --white: #ffffff;
    
    /* Supporting Colors */
    --spa-success: #16a34a;
    --spa-warning: #f59e0b;
    --spa-danger: #dc2626;
    --spa-info: #0891b2;
}

.booking-step-indicator {
    width: 100%;
    max-width: 64rem; /* 4xl */
    background: var(--white);
    border-radius: 1rem;
    box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
    padding: 1.5rem;
    margin: 0 auto 2rem auto;
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
}

.step-indicator-container {
    position: relative;
}

/* Progress bar line (background) */
.progress-bar-line {
    position: absolute;
    top: 24px; /* Vertically center with the 48px circles */
    left: 0;
    right: 0;
    height: 4px;
    background-color: var(--gray-200);
    z-index: 0;
    border-radius: 2px;
}

/* Progress bar line (active/colored) */
.progress-bar-line-active {
    position: absolute;
    top: 24px;
    left: 0;
    height: 4px;
    background-color: var(--spa-primary);
    z-index: 1;
    transition: width 0.3s ease-in-out;
    border-radius: 2px;
}

.steps-container {
    position: relative;
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    z-index: 10;
}

.step-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    width: 25%;
    cursor: pointer;
}

.step-circle {
    width: 48px;
    height: 48px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 0.5rem;
    transition: all 0.3s ease;
    font-weight: 700;
    font-size: 1.25rem;
    border: 2px solid var(--gray-300);
    background-color: var(--gray-200);
    color: var(--gray-500);
}

/* Step circle states */
.step-circle.active {
    background: var(--white);
    border: 4px solid var(--spa-primary);
    color: var(--spa-primary);
    box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
    transform: scale(1.1);
}

.step-circle.completed {
    background-color: var(--spa-primary);
    border: 2px solid var(--spa-primary);
    color: var(--white);
    box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
}

.step-circle.disabled {
    background-color: var(--gray-200);
    border: 2px solid var(--gray-300);
    color: var(--gray-400);
    cursor: not-allowed;
}

.step-circle:hover:not(.disabled) {
    transform: scale(1.05);
    box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
}

.step-circle.active:hover {
    transform: scale(1.15);
}

/* Icon alignment in step circles */
.step-circle iconify-icon {
    font-size: 1.75rem;
    line-height: 1;
    display: flex;
    align-items: center;
    justify-content: center;
}

.step-number {
    font-size: 1.25rem;
    font-weight: 700;
}

.step-content {
    text-align: center;
    margin-bottom: 0.75rem;
}

.step-title {
    font-weight: 600;
    font-size: 0.875rem;
    color: var(--gray-600);
    margin-bottom: 0.125rem;
    transition: color 0.3s ease;
}

.step-title.active {
    color: var(--spa-primary);
    font-weight: 700;
}

.step-title.completed {
    color: var(--spa-primary);
}

.step-description {
    font-size: 0.75rem;
    color: var(--gray-500);
    line-height: 1.4;
}

.step-summary {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 0.75rem;
    color: var(--gray-600);
}

.summary-badge {
    background: var(--spa-success);
    background: linear-gradient(135deg, var(--spa-success) 0%, #059669 100%);
    color: var(--white);
    font-weight: 600;
    padding: 0.25rem 0.5rem;
    border-radius: 9999px;
    display: flex;
    align-items: center;
    gap: 0.25rem;
    font-size: 0.75rem;
}

.summary-badge iconify-icon {
    font-size: 0.75rem;
}

.amount-text {
    font-weight: 700;
}

.edit-button {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 1rem;
    height: 1rem;
    color: var(--spa-primary);
    transition: color 0.3s ease, transform 0.2s ease;
    background: none;
    border: none;
    cursor: pointer;
    padding: 0;
}

.edit-button:hover {
    color: var(--spa-primary-hover);
    transform: scale(1.1);
}

.edit-button iconify-icon {
    font-size: 1rem;
}

/* Mobile Responsive */
@media (max-width: 768px) {
    .booking-step-indicator {
        padding: 1rem;
    }
    
    .step-indicator-container {
        margin-bottom: 1rem;
    }
    
    .steps-container {
        flex-direction: column;
        gap: 1.5rem;
        align-items: stretch;
    }
    
    .step-item {
        flex-direction: row;
        width: 100%;
        align-items: center;
        background: var(--white);
        padding: 1rem;
        border-radius: 0.75rem;
        border: 1px solid var(--gray-200);
        box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05);
    }
    
    .step-circle {
        margin-bottom: 0;
        margin-right: 1rem;
        flex-shrink: 0;
        width: 40px;
        height: 40px;
        font-size: 1rem;
    }
    
    .step-circle iconify-icon {
        font-size: 1.25rem;
    }
    
    .step-content {
        text-align: left;
        margin-bottom: 0;
        flex: 1;
        margin-right: 1rem;
    }
    
    .step-title {
        font-size: 1rem;
        margin-bottom: 0.25rem;
    }
    
    .step-description {
        font-size: 0.8125rem;
    }
    
    .step-summary {
        flex-shrink: 0;
    }
    
    .progress-bar-line,
    .progress-bar-line-active {
        display: none;
    }
}

@media (max-width: 480px) {
    .step-item {
        padding: 0.75rem;
    }
    
    .step-circle {
        width: 36px;
        height: 36px;
        font-size: 0.875rem;
    }
    
    .step-circle iconify-icon {
        font-size: 1rem;
    }
    
    .step-title {
        font-size: 0.9375rem;
    }
    
    .step-description {
        font-size: 0.8125rem;
    }
    
    .summary-badge {
        font-size: 0.6875rem;
        padding: 0.1875rem 0.375rem;
    }
}
</style>

<!-- JavaScript for Navigation -->
<script>
function navigateToStep(step, canNavigate) {
    if (!canNavigate) {
        return false;
    }
    
    const currentStep = '${currentStep}';
    const contextPath = '${pageContext.request.contextPath}';
    
    // Don't navigate if already on the same step
    if (currentStep === step) {
        return false;
    }
    
    // Check for unsaved changes
    if (hasUnsavedChanges()) {
        if (!confirm('Bạn có muốn rời khỏi trang này? Các thay đổi chưa lưu sẽ bị mất.')) {
            return false;
        }
    }
    
    // Navigate to the selected step
    switch(step) {
        case 'services':
            window.location.href = contextPath + '/process-booking/services';
            break;
        case 'time':
            window.location.href = contextPath + '/process-booking/time';
            break;
        case 'therapists':
            window.location.href = contextPath + '/process-booking/therapists';
            break;
        case 'payment':
            window.location.href = contextPath + '/process-booking/payment';
            break;
    }
}

// Add smooth scrolling and enhanced interactions
document.addEventListener('DOMContentLoaded', function() {
    // Smooth scroll to top when step indicator loads
    window.scrollTo({ top: 0, behavior: 'smooth' });
    
    // Add hover effects for clickable steps
    document.querySelectorAll('.step-circle:not(.disabled)').forEach(circle => {
        circle.addEventListener('mouseenter', function() {
            if (!this.classList.contains('active')) {
                this.style.transform = 'scale(1.05)';
            }
        });
        
        circle.addEventListener('mouseleave', function() {
            if (!this.classList.contains('active')) {
                this.style.transform = 'scale(1)';
            }
        });
    });
});

// Function to check for unsaved changes (to be implemented by individual pages)
function hasUnsavedChanges() {
    // This should be overridden by individual booking pages
    return false;
}
</script> 
